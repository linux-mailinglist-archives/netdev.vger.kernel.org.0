Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE0BB35E008
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 15:27:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239792AbhDMN1H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 09:27:07 -0400
Received: from uho.ysoft.cz ([81.19.3.130]:58193 "EHLO uho.ysoft.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231697AbhDMN06 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Apr 2021 09:26:58 -0400
Received: from [10.0.29.110] (unknown [10.0.29.110])
        by uho.ysoft.cz (Postfix) with ESMTP id 25268A0955;
        Tue, 13 Apr 2021 15:26:30 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ysoft.com;
        s=20160406-ysoft-com; t=1618320390;
        bh=JBTZkRH+RisXWx6nb2B/Jz3vzcdT8S+CK2Nlb/trwwU=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=fDNYc/sn18JNbd4wl+nJBN+9syzSMLuMxv0uAfWXqKhSPINkK6KIyTAwVqt4rbx0/
         HbkKOsjLx74vz2T/iz7y9MtZbeSwxp2ahwrNegB7haJZVWZBjeHR6dNoq+FCV7IU0e
         HmNJ9hGqv1UTa6erFlSmf8IItTNmrqp4LlGqdWUs=
Subject: Re: Broken imx6 to QCA8334 connection since PHYLIB to PHYLINK
 conversion
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Jonathan McDowell <noodles@earth.li>,
        Florian Fainelli <f.fainelli@gmail.com>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org
References: <b7f5842a-c7b7-6439-ae68-51e1690d2507@ysoft.com>
 <YHRVv/GwCmnRN14j@lunn.ch> <9fa83984-f385-4705-a50f-688928cc366f@ysoft.com>
 <YHWSNaoNELqI3e4r@lunn.ch>
From:   =?UTF-8?B?TWljaGFsIFZva8OhxI0=?= <michal.vokac@ysoft.com>
Message-ID: <a1927419-1392-7599-c74d-5305b536e018@ysoft.com>
Date:   Tue, 13 Apr 2021 15:26:30 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <YHWSNaoNELqI3e4r@lunn.ch>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 13. 04. 21 14:44, Andrew Lunn wrote:
> On Tue, Apr 13, 2021 at 09:09:37AM +0200, Michal Vokáč wrote:
>> On 12. 04. 21 16:14, Andrew Lunn wrote:
>> The FEC does not have PHY and is connected to the switch at RGMII level.
>> Adding the fixed-link { speed = <1000>; full-duplex; }; subnode to FEC
>> does not help.
> 
> If the FEC does not have a PHY, it should not have a
> phy-handle. Instead, you need a fixed-link.
> 
> What is currently happening is that both the switch and the FEC are
> trying to connect to the same PHY. Probably the switch does its
> connection first and succeeds. When the FEC tries to connect, the PHY
> is in use, so an error is returned.
> 
> By providing a fixed-link, instead of a phy-handle, a simulated PHY is
> generated, which the FEC can connect to.

That was it, thanks a lot Andrew! I will send a patch ASAP.

Michal

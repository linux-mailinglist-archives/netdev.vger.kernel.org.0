Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0E132F3F9F
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 01:46:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403793AbhALW3k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 17:29:40 -0500
Received: from mail-out.m-online.net ([212.18.0.10]:37714 "EHLO
        mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2394594AbhALW3L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jan 2021 17:29:11 -0500
Received: from frontend01.mail.m-online.net (unknown [192.168.8.182])
        by mail-out.m-online.net (Postfix) with ESMTP id 4DFlZp2Htbz1s46c;
        Tue, 12 Jan 2021 23:28:02 +0100 (CET)
Received: from localhost (dynscan1.mnet-online.de [192.168.6.70])
        by mail.m-online.net (Postfix) with ESMTP id 4DFlZp1nRSz1tSPw;
        Tue, 12 Jan 2021 23:28:02 +0100 (CET)
X-Virus-Scanned: amavisd-new at mnet-online.de
Received: from mail.mnet-online.de ([192.168.8.182])
        by localhost (dynscan1.mail.m-online.net [192.168.6.70]) (amavisd-new, port 10024)
        with ESMTP id DA9Re4kRXOe8; Tue, 12 Jan 2021 23:28:01 +0100 (CET)
X-Auth-Info: WsqRAc3017K+IJyGHqkoJTGMikCRbWSJ6VYgSzAxhWY=
Received: from [127.0.0.1] (p578adb1c.dip0.t-ipconnect.de [87.138.219.28])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mnet-online.de (Postfix) with ESMTPSA;
        Tue, 12 Jan 2021 23:28:01 +0100 (CET)
Subject: Re: [PATCH net-next] net: ks8851: Connect and start/stop the internal
 PHY
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, Heiner Kallweit <hkallweit1@gmail.com>,
        Lukas Wunner <lukas@wunner.de>
References: <20210111125337.36513-1-marex@denx.de> <X/xlDTUQTLgVoaUE@lunn.ch>
From:   Marek Vasut <marex@denx.de>
Message-ID: <dd43881e-edff-74fd-dbcb-26c5ca5b6e72@denx.de>
Date:   Tue, 12 Jan 2021 23:28:00 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <X/xlDTUQTLgVoaUE@lunn.ch>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/11/21 3:47 PM, Andrew Lunn wrote:
> On Mon, Jan 11, 2021 at 01:53:37PM +0100, Marek Vasut wrote:
>> Unless the internal PHY is connected and started, the phylib will not
>> poll the PHY for state and produce state updates. Connect the PHY and
>> start/stop it.
> 
> Hi Marek
> 
> Please continue the conversion and remove all mii_calls.
> 
> ks8851_set_link_ksettings() calling mii_ethtool_set_link_ksettings()
> is not good, phylib will not know about changes which we made to the
> PHY etc.

Hi,

I noticed a couple of drivers implement both the mii and mdiobus 
options, I was pondering why is that. Is there some legacy backward 
compatibility reason for keeping both or is it safe to remove the mii 
support completely from the driver?

Either way, I will do that in a separate patch, so it could be reverted 
if it breaks something.

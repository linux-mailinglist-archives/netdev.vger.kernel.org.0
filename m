Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 904B53D4B05
	for <lists+netdev@lfdr.de>; Sun, 25 Jul 2021 04:36:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229949AbhGYB4A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Jul 2021 21:56:00 -0400
Received: from tulum.helixd.com ([162.252.81.98]:48606 "EHLO tulum.helixd.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229665AbhGYBz7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 24 Jul 2021 21:55:59 -0400
Received: from [IPv6:2600:8801:8800:12e8:3407:b7f2:b44b:78da] (unknown [IPv6:2600:8801:8800:12e8:3407:b7f2:b44b:78da])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (Client did not present a certificate)
        (Authenticated sender: dalcocer@helixd.com)
        by tulum.helixd.com (Postfix) with ESMTPSA id 114E82045C;
        Sat, 24 Jul 2021 19:36:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=tulum.helixd.com;
        s=mail; t=1627180590;
        bh=JBUb2ZjqKGJ4geCjFWgPWCJexiUS9uTi0KAPaE3x1m8=;
        h=Subject:From:To:Cc:References:Date:In-Reply-To:From;
        b=dHFyIf0jrjxoa083exUBbZy5c/xAoX5va2456dCEq0vXhEKnYy8aerXqkukEZb8Sb
         6+07lOW+SZ9I/6Ni5uyblfukWS2hLKCUcX2JCGm+nsBC3WUmBrXLb1SvKNPDyEbKCZ
         kwWGRV+CLNorIDVj6PW4rVa1WaqfiW5kWqG6RdZM=
Subject: Re: Marvell switch port shows LOWERLAYERDOWN, ping fails
From:   Dario Alcocer <dalcocer@helixd.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org
References: <6a70869d-d8d5-4647-0640-4e95866a0392@helixd.com>
 <YPrHJe+zJGJ7oezW@lunn.ch> <0188e53d-1535-658a-4134-a5f05f214bef@helixd.com>
 <YPsJnLCKVzEUV5cb@lunn.ch> <b5d1facd-470b-c45f-8ce7-c7df49267989@helixd.com>
 <82974be6-4ccc-3ae1-a7ad-40fd2e134805@helixd.com> <YPxPF2TFSDX8QNEv@lunn.ch>
 <f8ee6413-9cf5-ce07-42f3-6cc670c12824@helixd.com>
Message-ID: <bcd589bd-eeb4-478c-127b-13f613fdfebc@helixd.com>
Date:   Sat, 24 Jul 2021 19:36:29 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <f8ee6413-9cf5-ce07-42f3-6cc670c12824@helixd.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/24/21 7:26 PM, Dario Alcocer wrote:
> On 7/24/21 10:34 AM, Andrew Lunn wrote:
>> You might want to enable dbg prints in driver/nets/phy/phy.c, so you
>> can see the state machine changes.
>
> Great suggestion. I added the following to the boot options:
>
> dyndbg="file net/dsa/* +p; file drivers/net/phy/phy.c +p"
>
> The relevant messages collected from the system log are below. 
> Interestingly, all of the ports go from UP to NOLINK. In addition, 
> "breaking chain for DSA event 7" is reported, once for each port.
>
> I'll dig into the DSA sources to see the significance of event 7. 

Event 7 is DSA_NOTIFIER_VLAN_ADD, found in net/dsa/dsa_priv.h


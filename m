Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFD5D2F7A34
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 13:47:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388071AbhAOMq6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 07:46:58 -0500
Received: from mail-out.m-online.net ([212.18.0.10]:43190 "EHLO
        mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387747AbhAOMq4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 07:46:56 -0500
Received: from frontend01.mail.m-online.net (unknown [192.168.8.182])
        by mail-out.m-online.net (Postfix) with ESMTP id 4DHLWb3FD4z1rxbc;
        Fri, 15 Jan 2021 13:45:47 +0100 (CET)
Received: from localhost (dynscan1.mnet-online.de [192.168.6.70])
        by mail.m-online.net (Postfix) with ESMTP id 4DHLWb2qKjz1tYWB;
        Fri, 15 Jan 2021 13:45:47 +0100 (CET)
X-Virus-Scanned: amavisd-new at mnet-online.de
Received: from mail.mnet-online.de ([192.168.8.182])
        by localhost (dynscan1.mail.m-online.net [192.168.6.70]) (amavisd-new, port 10024)
        with ESMTP id qUf1dJ7Um2r4; Fri, 15 Jan 2021 13:45:46 +0100 (CET)
X-Auth-Info: Q52BCThch4xhWf+XpUxPolgYqnxbB46oIwTOn/R7Gho=
Received: from [IPv6:::1] (p578adb1c.dip0.t-ipconnect.de [87.138.219.28])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mnet-online.de (Postfix) with ESMTPSA;
        Fri, 15 Jan 2021 13:45:46 +0100 (CET)
Subject: Re: [PATCH net-next] net: ks8851: Connect and start/stop the internal
 PHY
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, Heiner Kallweit <hkallweit1@gmail.com>,
        Lukas Wunner <lukas@wunner.de>
References: <20210111125337.36513-1-marex@denx.de> <X/xlDTUQTLgVoaUE@lunn.ch>
 <dd43881e-edff-74fd-dbcb-26c5ca5b6e72@denx.de> <YABNA+0aPI42lJLh@lunn.ch>
From:   Marek Vasut <marex@denx.de>
Message-ID: <268090ca-06dd-d7e2-c06b-b9282f3cbe67@denx.de>
Date:   Fri, 15 Jan 2021 13:45:45 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <YABNA+0aPI42lJLh@lunn.ch>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/14/21 2:54 PM, Andrew Lunn wrote:
> On Tue, Jan 12, 2021 at 11:28:00PM +0100, Marek Vasut wrote:
>> On 1/11/21 3:47 PM, Andrew Lunn wrote:
>>> On Mon, Jan 11, 2021 at 01:53:37PM +0100, Marek Vasut wrote:
>>>> Unless the internal PHY is connected and started, the phylib will not
>>>> poll the PHY for state and produce state updates. Connect the PHY and
>>>> start/stop it.
>>>
>>> Hi Marek
>>>
>>> Please continue the conversion and remove all mii_calls.
>>>
>>> ks8851_set_link_ksettings() calling mii_ethtool_set_link_ksettings()
>>> is not good, phylib will not know about changes which we made to the
>>> PHY etc.
>>
>> Hi,
>>
>> I noticed a couple of drivers implement both the mii and mdiobus options.
> 
> Which ones?

boardcom b44.c and bcm63xx_enet.c for example

> Simply getting the link status might be safe, but if
> set_link_ksettings() or get_link_ksettings() is used, phylib is going
> to get confused when the PHY is changed without it knowing.. So please
> do remove all the mii calls as part of the patchset.

Isn't that gonna break some ABI ?

Also, is separate patch OK ?

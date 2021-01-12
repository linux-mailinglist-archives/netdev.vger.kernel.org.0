Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18B912F3FA1
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 01:46:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404222AbhALW3o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 17:29:44 -0500
Received: from mail-out.m-online.net ([212.18.0.10]:34095 "EHLO
        mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2394601AbhALW33 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jan 2021 17:29:29 -0500
Received: from frontend01.mail.m-online.net (unknown [192.168.8.182])
        by mail-out.m-online.net (Postfix) with ESMTP id 4DFlbN4zLJz1s2K6;
        Tue, 12 Jan 2021 23:28:32 +0100 (CET)
Received: from localhost (dynscan1.mnet-online.de [192.168.6.70])
        by mail.m-online.net (Postfix) with ESMTP id 4DFlbN4VR4z1tSPw;
        Tue, 12 Jan 2021 23:28:32 +0100 (CET)
X-Virus-Scanned: amavisd-new at mnet-online.de
Received: from mail.mnet-online.de ([192.168.8.182])
        by localhost (dynscan1.mail.m-online.net [192.168.6.70]) (amavisd-new, port 10024)
        with ESMTP id WWOZK3IBOvqS; Tue, 12 Jan 2021 23:28:31 +0100 (CET)
X-Auth-Info: x+wed1Lb0j8FwshcgiR952GaAYwJpbN67402AhWAvdc=
Received: from [127.0.0.1] (p578adb1c.dip0.t-ipconnect.de [87.138.219.28])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mnet-online.de (Postfix) with ESMTPSA;
        Tue, 12 Jan 2021 23:28:31 +0100 (CET)
Subject: Re: [PATCH net-next] net: ks8851: Connect and start/stop the internal
 PHY
To:     Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>, Lukas Wunner <lukas@wunner.de>
References: <20210111125337.36513-1-marex@denx.de>
 <a8eb8186-cde4-19ab-5b3c-e885e11106cf@gmail.com>
 <8c46baf2-28c9-190a-090c-c2980842b78e@denx.de>
 <aeb906d3-be61-c3cd-4ec0-88e66f384369@gmail.com>
 <177a7c60-2c3a-3242-7999-12ad4fec78b3@denx.de>
 <d20d2e2e-9745-4f75-3179-f68e1efcf29b@gmail.com>
From:   Marek Vasut <marex@denx.de>
Message-ID: <007e384e-9568-106c-d853-2abc4484210d@denx.de>
Date:   Tue, 12 Jan 2021 23:28:30 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <d20d2e2e-9745-4f75-3179-f68e1efcf29b@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/11/21 3:43 PM, Heiner Kallweit wrote:
> On 11.01.2021 15:10, Marek Vasut wrote:
>> On 1/11/21 2:50 PM, Heiner Kallweit wrote:
>>> On 11.01.2021 14:38, Marek Vasut wrote:
>>>> On 1/11/21 2:26 PM, Heiner Kallweit wrote:
>>>> [...]
>>>>
>>>>> LGTM. When having a brief look at the driver I stumbled across two things:
>>>>>
>>>>> 1. Do MAC/PHY support any pause mode? Then a call to
>>>>>       phy_support_(a)sym_pause() would be missing.
>>>>
>>>> https://ww1.microchip.com/downloads/en/DeviceDoc/KSZ8851-16MLL-Single-Port-Ethernet-MAC-Controller-with-8-Bit-or-16-Bit-Non-PCI-Interface-DS00002357B.pdf
>>>> page 64
>>>>
>>>> https://www.mouser.com/datasheet/2/268/ksz8851-16mll_ds-776208.pdf
>>>> page 65
>>>>
>>>> The later is more complete.
>>>>
>>>> Apparently it does support pause.
>>
>> Based on the datasheet, does it support sym or asym pause ?
>>
> 
> According to the description of flow control on p.23 it can support asym pause.
> However on the MAC side flow control doesn't seem to be always active, it's
> controlled by these two bits:
> 
> p.49, TXCR, bit 3
> p.50, RXCR1, bit 10
> 
> Default seems to be that flow control is disabled.

So I guess this patch is OK as-is ?

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31D1B2F7EEF
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 16:07:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731883AbhAOPGw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 10:06:52 -0500
Received: from mail-out.m-online.net ([212.18.0.10]:56258 "EHLO
        mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725910AbhAOPGv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 10:06:51 -0500
Received: from frontend01.mail.m-online.net (unknown [192.168.8.182])
        by mail-out.m-online.net (Postfix) with ESMTP id 4DHPdM4jVXz1rsY2;
        Fri, 15 Jan 2021 16:05:59 +0100 (CET)
Received: from localhost (dynscan1.mnet-online.de [192.168.6.70])
        by mail.m-online.net (Postfix) with ESMTP id 4DHPdM4BkWz1tYWP;
        Fri, 15 Jan 2021 16:05:59 +0100 (CET)
X-Virus-Scanned: amavisd-new at mnet-online.de
Received: from mail.mnet-online.de ([192.168.8.182])
        by localhost (dynscan1.mail.m-online.net [192.168.6.70]) (amavisd-new, port 10024)
        with ESMTP id CR6tDLSs4S5X; Fri, 15 Jan 2021 16:05:58 +0100 (CET)
X-Auth-Info: 1onHjol+H6khHdJuvdpIp+DUUczUrWb5IHdwjwwJ9/s=
Received: from [IPv6:::1] (p578adb1c.dip0.t-ipconnect.de [87.138.219.28])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mnet-online.de (Postfix) with ESMTPSA;
        Fri, 15 Jan 2021 16:05:58 +0100 (CET)
Subject: Re: [PATCH net-next] net: ks8851: Fix mixed module/builtin build
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Lukas Wunner <lukas@wunner.de>
References: <20210115134239.126152-1-marex@denx.de> <YAGuA8O0lr19l5lH@lunn.ch>
From:   Marek Vasut <marex@denx.de>
Message-ID: <e000a5f4-53bb-a4e4-f032-3dbe394d5ea3@denx.de>
Date:   Fri, 15 Jan 2021 16:05:57 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <YAGuA8O0lr19l5lH@lunn.ch>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/15/21 4:00 PM, Andrew Lunn wrote:
> On Fri, Jan 15, 2021 at 02:42:39PM +0100, Marek Vasut wrote:
>> When either the SPI or PAR variant is compiled as module AND the other
>> variant is compiled as built-in, the following build error occurs:
>>
>> arm-linux-gnueabi-ld: drivers/net/ethernet/micrel/ks8851_common.o: in function `ks8851_probe_common':
>> ks8851_common.c:(.text+0x1564): undefined reference to `__this_module'
>>
>> Fix this by including the ks8851_common.c in both ks8851_spi.c and
>> ks8851_par.c. The DEBUG macro is defined in ks8851_common.c, so it
>> does not have to be defined again.
> 
> DEBUG should not be defined for production code. So i would remove it
> altogether.
> 
> There is kconfig'ury you can use to make them both the same. But i'm
> not particularly good with it.

We had discussion about this module/builtin topic in ks8851 before, so I 
was hoping someone might provide a better suggestion.

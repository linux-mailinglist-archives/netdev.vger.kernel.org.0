Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93782194FA3
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 04:24:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727612AbgC0DYG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 23:24:06 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:50934 "EHLO
        mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726363AbgC0DYF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 23:24:05 -0400
Received: from frontend01.mail.m-online.net (unknown [192.168.8.182])
        by mail-out.m-online.net (Postfix) with ESMTP id 48pRz72BwFz1qrGJ;
        Fri, 27 Mar 2020 04:24:00 +0100 (CET)
Received: from localhost (dynscan1.mnet-online.de [192.168.6.70])
        by mail.m-online.net (Postfix) with ESMTP id 48pRz43c8fz1qv55;
        Fri, 27 Mar 2020 04:24:00 +0100 (CET)
X-Virus-Scanned: amavisd-new at mnet-online.de
Received: from mail.mnet-online.de ([192.168.8.182])
        by localhost (dynscan1.mail.m-online.net [192.168.6.70]) (amavisd-new, port 10024)
        with ESMTP id eY9M2SiyByS0; Fri, 27 Mar 2020 04:23:59 +0100 (CET)
X-Auth-Info: 5vN8Egy5N5kTK0Zs+jg36LD5YoowDOxsNcUKb2P332Y=
Received: from [IPv6:::1] (unknown [195.140.253.167])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mnet-online.de (Postfix) with ESMTPSA;
        Fri, 27 Mar 2020 04:23:59 +0100 (CET)
Subject: Re: [PATCH] net: ks8851-ml: Fix IO operations, again
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, lukas@wunner.de, ynezz@true.cz,
        yuehaibing@huawei.com
References: <20200325142547.45393-1-marex@denx.de>
 <20200326.202108.1067673336802728242.davem@davemloft.net>
From:   Marek Vasut <marex@denx.de>
Message-ID: <53869ef3-0825-55eb-fb89-f5e732b7e7ac@denx.de>
Date:   Fri, 27 Mar 2020 04:23:58 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200326.202108.1067673336802728242.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/27/20 4:21 AM, David Miller wrote:
> From: Marek Vasut <marex@denx.de>
> Date: Wed, 25 Mar 2020 15:25:47 +0100
> 
>> This patch reverts 58292104832f ("net: ks8851-ml: Fix 16-bit IO operation")
>> and edacb098ea9c ("net: ks8851-ml: Fix 16-bit data access"), because it
>> turns out these were only necessary due to buggy hardware. This patch adds
>> a check for such a buggy hardware to prevent any such mistakes again.
>>
>> While working further on the KS8851 driver, it came to light that the
>> KS8851-16MLL is capable of switching bus endianness by a hardware strap,
>> EESK pin. If this strap is incorrect, the IO accesses require such endian
>> swapping as is being reverted by this patch. Such swapping also impacts
>> the performance significantly.
>>
>> Hence, in addition to removing it, detect that the hardware is broken,
>> report to user, and fail to bind with such hardware.
>>
>> Fixes: 58292104832f ("net: ks8851-ml: Fix 16-bit IO operation")
>> Fixes: edacb098ea9c ("net: ks8851-ml: Fix 16-bit data access")
>> Signed-off-by: Marek Vasut <marex@denx.de>
> 
> Applied, thanks.

Sorry for this mess.

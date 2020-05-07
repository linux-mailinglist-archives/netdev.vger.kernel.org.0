Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A1AD1C8653
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 12:03:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726495AbgEGKDN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 06:03:13 -0400
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:64214 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725809AbgEGKDL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 May 2020 06:03:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1588845791; x=1620381791;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=igCCKMJbhqYeOoGE+sQmu6rCvyg1z00o31S2SkbWHs4=;
  b=C+z3V5HA5iScKDWWnhxLVdUG75hxp7AJKRwez785+AB+XvwZLrP5AdD+
   lWXHEYwFAfvnP9QLQTWj1893cGp8PhPQY7bC9YeQi9jaW79CozXV/fcOH
   5mooHB+jSL2ye6f2dHGcJUDwi2KNRn11+Q0p1zcOcrX8ZDAY/nA0pgRez
   y+YS/k4sz5BhBarx6G+zT/6gYZM1vAkSnUbmWVznjHe8cu+8W1QPY4WSI
   2FxCLbzG1boKnFBuzGeTGih9JDaPivVZdx9XnqsKrtSTKCiesWYHKGcu/
   dTp73q37z3FRVU3DJHuzBpDun6UmOpFwgseVRhHNAGCNCPQpqPL4UOXAh
   A==;
IronPort-SDR: KiGC/Nbaj7CKs/uXQhNZzQ0gtCXZnf5CMmQNdcCvp6mTdIoPwsnOXx/5zJGR9eg65Lbu9v4wrs
 wisJ1JXL1nneY0JJDEeSQLWvo8hayE50Le8vhK1ntku/RGzBNhKBIukj0kICCBm2Z31AF/pDMc
 KcEC+sxSU3dRkSk8D7P9/4M6acSrRltj4IxfbDwYBCWWp6DmbU0M6CbRWHMJqlnHqkiB7A+r3V
 vP5bKgiY3JgncsHMmT2eNsVqlgWEgykswRAIk+6SRaXCu5/P5Ed3BMOFqBaDqJZHw8em1rk4Uj
 jeI=
X-IronPort-AV: E=Sophos;i="5.73,363,1583218800"; 
   d="scan'208";a="72706941"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 07 May 2020 03:03:10 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 7 May 2020 03:03:10 -0700
Received: from [10.205.29.55] (10.10.115.15) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server id 15.1.1713.5 via Frontend
 Transport; Thu, 7 May 2020 03:03:06 -0700
Subject: Re: [PATCH v4 1/5] net: macb: fix wakeup test in runtime
 suspend/resume routines
To:     Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>
CC:     <linux-arm-kernel@lists.infradead.org>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        <harini.katakam@xilinx.com>, <linux-kernel@vger.kernel.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        <antoine.tenart@bootlin.com>, <f.fainelli@gmail.com>
References: <cover.1588763703.git.nicolas.ferre@microchip.com>
 <dc30ff1d17cb5a75ddd10966eab001f67ac744ef.1588763703.git.nicolas.ferre@microchip.com>
 <20200506131843.22cf1dab@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Nicolas Ferre <nicolas.ferre@microchip.com>
Organization: microchip
Message-ID: <347c9a4f-8a01-a931-c9d5-536339337f8a@microchip.com>
Date:   Thu, 7 May 2020 12:03:04 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200506131843.22cf1dab@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06/05/2020 at 22:18, Jakub Kicinski wrote:
> EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
> 
> On Wed, 6 May 2020 13:37:37 +0200 nicolas.ferre@microchip.com wrote:
>> From: Nicolas Ferre <nicolas.ferre@microchip.com>
>>
>> Use the proper struct device pointer to check if the wakeup flag
>> and wakeup source are positioned.
>> Use the one passed by function call which is equivalent to
>> &bp->dev->dev.parent.
>>
>> It's preventing the trigger of a spurious interrupt in case the
>> Wake-on-Lan feature is used.
>>
>> Fixes: bc1109d04c39 ("net: macb: Add pm runtime support")
> 
>          Fixes tag: Fixes: bc1109d04c39 ("net: macb: Add pm runtime support")
>          Has these problem(s):
>                  - Target SHA1 does not exist

Indeed, it's:
Fixes: d54f89af6cc4 ("net: macb: Add pm runtime support")

David: do I have to respin or you can modify it?

Thanks. Regards,
   Nicolas
>> Signed-off-by: Nicolas Ferre <nicolas.ferre@microchip.com>
>> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
>> Cc: Claudiu Beznea <claudiu.beznea@microchip.com>
>> Cc: Harini Katakam <harini.katakam@xilinx.com>
>> ---
>>   drivers/net/ethernet/cadence/macb_main.c | 4 ++--
>>   1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
>> index 36290a8e2a84..d11fae37d46b 100644
>> --- a/drivers/net/ethernet/cadence/macb_main.c
>> +++ b/drivers/net/ethernet/cadence/macb_main.c
>> @@ -4616,7 +4616,7 @@ static int __maybe_unused macb_runtime_suspend(struct device *dev)
>>        struct net_device *netdev = dev_get_drvdata(dev);
>>        struct macb *bp = netdev_priv(netdev);
>>
>> -     if (!(device_may_wakeup(&bp->dev->dev))) {
>> +     if (!(device_may_wakeup(dev))) {
>>                clk_disable_unprepare(bp->tx_clk);
>>                clk_disable_unprepare(bp->hclk);
>>                clk_disable_unprepare(bp->pclk);
>> @@ -4632,7 +4632,7 @@ static int __maybe_unused macb_runtime_resume(struct device *dev)
>>        struct net_device *netdev = dev_get_drvdata(dev);
>>        struct macb *bp = netdev_priv(netdev);
>>
>> -     if (!(device_may_wakeup(&bp->dev->dev))) {
>> +     if (!(device_may_wakeup(dev))) {
>>                clk_prepare_enable(bp->pclk);
>>                clk_prepare_enable(bp->hclk);
>>                clk_prepare_enable(bp->tx_clk);
> 


-- 
Nicolas Ferre

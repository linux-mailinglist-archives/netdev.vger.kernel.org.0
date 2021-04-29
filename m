Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6493836EE6B
	for <lists+netdev@lfdr.de>; Thu, 29 Apr 2021 18:55:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240803AbhD2Q4D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Apr 2021 12:56:03 -0400
Received: from esa.microchip.iphmx.com ([68.232.154.123]:33585 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231238AbhD2Q4C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Apr 2021 12:56:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1619715316; x=1651251316;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=ScWp8ofsYrARe5yBRyhUEWi4uTfNWBn2+W2xJb2CiZM=;
  b=WYiRkwTsyil0lzN8R/vkv13GwkWqd2FJQJlOno5rjG2UBLR4TJ5XBRlh
   v00Mdv/nST2Z7wbKqTP8J4zPx36DsMGoKDpUjqdz4Ln2/LkMaZlCuO0Bb
   ToTi0IpB1WPZ4ErNNGOCnmyQjgoCXrKMkfN0lbjAB19AxNBc2B1X2IPXt
   4YCttT5F6+6Lko8yUJCmwceKGdqygVt1jCZbMCvIaycuPkaZ7Yq3NMa4U
   MNw7ew8fEC/Vr4h/i5ccYTjr+8zQnjKmYcQOxlZHx+FTU4hPV8c1p3DKO
   2KS5DEgneN2fSauNTIpDF9ndOpc5GSWakibKpwPXFg1smrXB7dnCyA9/2
   A==;
IronPort-SDR: CJnHrgFd1mS2gYtmha0/lmYBCzIBsfW9GcOBZlk2T7wKu4yryOLJFaPdL4/+lJHntBA4zk2DMB
 LFlaNrZ2phLO7cow+cmgtjkJVQk2Shmi8ivPOGq6h9MskKJvSdJqFzD6Jo4Toam4VoXARPgr/f
 ugQAHma/IWZBmF4pdTJ8zB6VrXv1Cjh3LSlxb7XfhUE5aR9CJky6KNS0nBAh7lWr5IGZE2nGJU
 OR/lF5Xgiuu4ESzOUsW5S9lkkGcs2i/hAd8vtODcmToQRBJEYwnIX+PcXk5LcRBSc2YKkz2ZAG
 ylE=
X-IronPort-AV: E=Sophos;i="5.82,259,1613458800"; 
   d="scan'208";a="53032240"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 29 Apr 2021 09:55:15 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 29 Apr 2021 09:55:14 -0700
Received: from [10.171.246.9] (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.2176.2 via Frontend
 Transport; Thu, 29 Apr 2021 09:55:12 -0700
Subject: Re: [PATCH] net: macb: Remove redundant assignment to w0
To:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        Rafal Ozieblo <rafalo@cadence.com>
CC:     <claudiu.beznea@microchip.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <linux@armlinux.org.uk>, <palmer@dabbelt.com>,
        <paul.walmsley@sifive.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-riscv@lists.infradead.org>,
        Michal Simek <michal.simek@xilinx.com>
References: <1619691982-90657-1-git-send-email-jiapeng.chong@linux.alibaba.com>
From:   Nicolas Ferre <nicolas.ferre@microchip.com>
Organization: microchip
Message-ID: <80a97aa9-0bf4-d6c5-597e-4440b07ecdaf@microchip.com>
Date:   Thu, 29 Apr 2021 18:55:11 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <1619691982-90657-1-git-send-email-jiapeng.chong@linux.alibaba.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 29/04/2021 at 12:26, Jiapeng Chong wrote:
> Variable w0 is set to zero but these values is not used as it is
> overwritten later on, hence redundant assignment can be removed.
> 
> Cleans up the following clang-analyzer warning:
> 
> drivers/net/ethernet/cadence/macb_main.c:3265:3: warning: Value stored
> to 'w0' is never read [clang-analyzer-deadcode.DeadStores].
> 
> drivers/net/ethernet/cadence/macb_main.c:3251:3: warning: Value stored
> to 'w0' is never read [clang-analyzer-deadcode.DeadStores].
> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>

NACK: there seems to be a massive bug in this code as I have the strong 
feeling that '=' must be replaces by '|=' in subsequent assignment of 
w0, W1... otherwise I don't understand the meaning of all this!

I don't know how RX filtering must be done in this controller neither 
how to test it so if nobody steps in to fix this, I'll probably have to 
do a patch based on datasheet only.

Please comment if you have a view on this.

Best regards,
   Nicolas

> ---
>   drivers/net/ethernet/cadence/macb_main.c | 2 --
>   1 file changed, 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
> index 0f6a6cb..741b2e3 100644
> --- a/drivers/net/ethernet/cadence/macb_main.c
> +++ b/drivers/net/ethernet/cadence/macb_main.c
> @@ -3248,7 +3248,6 @@ static void gem_prog_cmp_regs(struct macb *bp, struct ethtool_rx_flow_spec *fs)
>          /* ignore field if any masking set */
>          if (tp4sp_m->ip4src == 0xFFFFFFFF) {
>                  /* 1st compare reg - IP source address */
> -               w0 = 0;
>                  w1 = 0;
>                  w0 = tp4sp_v->ip4src;
>                  w1 = GEM_BFINS(T2DISMSK, 1, w1); /* 32-bit compare */
> @@ -3262,7 +3261,6 @@ static void gem_prog_cmp_regs(struct macb *bp, struct ethtool_rx_flow_spec *fs)
>          /* ignore field if any masking set */
>          if (tp4sp_m->ip4dst == 0xFFFFFFFF) {
>                  /* 2nd compare reg - IP destination address */
> -               w0 = 0;
>                  w1 = 0;
>                  w0 = tp4sp_v->ip4dst;
>                  w1 = GEM_BFINS(T2DISMSK, 1, w1); /* 32-bit compare */
> --
> 1.8.3.1
> 


-- 
Nicolas Ferre

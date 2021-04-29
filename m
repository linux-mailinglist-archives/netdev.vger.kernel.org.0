Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1431836EE0F
	for <lists+netdev@lfdr.de>; Thu, 29 Apr 2021 18:23:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240796AbhD2QX2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Apr 2021 12:23:28 -0400
Received: from esa.microchip.iphmx.com ([68.232.154.123]:4313 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240730AbhD2QXY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Apr 2021 12:23:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1619713358; x=1651249358;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=7BcdnZisl7B8/PzFL89x7k4XXNQZrdodFVgVdVog5FU=;
  b=aXam4nK5FHG7bc1QBocED5b46VZHM/JKjvi9NOLOsfuPLyFV2+Tu2KJF
   9QosMp3M6wtQfYCfKLATtDE/fUTHYFei99TkgO/hXygo5RbrQ25vD6f7M
   BEl+eIjJCeF073zoUBDnGTxO5Y5l2ctRqHgJXNZ7CJRJMfL1Q4AfmGNdd
   /d21NoICPtR8K4QXWI2QQva5Ptc892vp2H7ZfQ1dgy5TaACkUn2w21d41
   j9Hr3YPGyiVVvbdD7dgmNTZS29MmgtdjkISZqkaTMt5QYCfc6WqINfNIU
   7vc863g72c6M/2VdQr8PWqbojx1kWbGsQBsi5GB9NzOdiZNr/ewspofHy
   A==;
IronPort-SDR: 9up+t1yzJJ4pGk6aqPHPwq23SeK79ZZS0/Y/Ik5MOTulOKzh5caNovjBGbxJ6lrde4h5QZmJrQ
 G73+Fc0cmYnSDDjVoLsU2YXwIrUMjba7jmRXoEesjVW0Q60ssAZUtNzH6Q9iWHH4rUT3nyL+3R
 Wna9vys0auG6ohc1PqenBrWVDC6VWLhnGT5WJ0I82sPJzhT+fDtLMfo0fttZvYpj/xGIWpcQTN
 xg1HYukdxQqRdkLC3pEkIDPiA8Fr/Yr5p1A7x76LvkAVhFk/dbR+oH+9VmdG9amUI3uuiwhn1e
 sn0=
X-IronPort-AV: E=Sophos;i="5.82,259,1613458800"; 
   d="scan'208";a="115378716"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 29 Apr 2021 09:22:37 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 29 Apr 2021 09:22:36 -0700
Received: from [10.171.246.9] (10.10.115.15) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server id 15.1.2176.2 via Frontend
 Transport; Thu, 29 Apr 2021 09:22:34 -0700
Subject: Re: [PATCH] net: macb: Remove redundant assignment to queue
To:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
CC:     <claudiu.beznea@microchip.com>, <kuba@kernel.org>,
        <davem@davemloft.net>, <linux@armlinux.org.uk>,
        <palmer@dabbelt.com>, <paul.walmsley@sifive.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-riscv@lists.infradead.org>
References: <1619691946-90305-1-git-send-email-jiapeng.chong@linux.alibaba.com>
From:   Nicolas Ferre <nicolas.ferre@microchip.com>
Organization: microchip
Message-ID: <8c969699-6ce3-4731-e33c-2d1b045aafab@microchip.com>
Date:   Thu, 29 Apr 2021 18:22:33 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <1619691946-90305-1-git-send-email-jiapeng.chong@linux.alibaba.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 29/04/2021 at 12:25, Jiapeng Chong wrote:
> Variable queue is set to bp->queues but these values is not used as it
> is overwritten later on, hence redundant assignment  can be removed.
> 
> Cleans up the following clang-analyzer warning:
> 
> drivers/net/ethernet/cadence/macb_main.c:4919:21: warning: Value stored
> to 'queue' during its initialization is never read
> [clang-analyzer-deadcode.DeadStores].
> 
> drivers/net/ethernet/cadence/macb_main.c:4832:21: warning: Value stored
> to 'queue' during its initialization is never read
> [clang-analyzer-deadcode.DeadStores].
> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>

Looks good to me as assignments are done in for loops:
Acked-by: Nicolas Ferre <nicolas.ferre@microchip.com>

Regards,
   Nicolas

> ---
>   drivers/net/ethernet/cadence/macb_main.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
> index 0f6a6cb..5693850 100644
> --- a/drivers/net/ethernet/cadence/macb_main.c
> +++ b/drivers/net/ethernet/cadence/macb_main.c
> @@ -4829,7 +4829,7 @@ static int __maybe_unused macb_suspend(struct device *dev)
>   {
>          struct net_device *netdev = dev_get_drvdata(dev);
>          struct macb *bp = netdev_priv(netdev);
> -       struct macb_queue *queue = bp->queues;
> +       struct macb_queue *queue;
>          unsigned long flags;
>          unsigned int q;
>          int err;
> @@ -4916,7 +4916,7 @@ static int __maybe_unused macb_resume(struct device *dev)
>   {
>          struct net_device *netdev = dev_get_drvdata(dev);
>          struct macb *bp = netdev_priv(netdev);
> -       struct macb_queue *queue = bp->queues;
> +       struct macb_queue *queue;
>          unsigned long flags;
>          unsigned int q;
>          int err;
> --
> 1.8.3.1
> 


-- 
Nicolas Ferre

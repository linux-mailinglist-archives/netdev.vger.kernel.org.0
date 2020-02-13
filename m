Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4897115BB01
	for <lists+netdev@lfdr.de>; Thu, 13 Feb 2020 09:46:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729684AbgBMIp6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Feb 2020 03:45:58 -0500
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:16914 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729526AbgBMIp6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Feb 2020 03:45:58 -0500
Received-SPF: Pass (esa6.microchip.iphmx.com: domain of
  Nicolas.Ferre@microchip.com designates 198.175.253.82 as
  permitted sender) identity=mailfrom;
  client-ip=198.175.253.82; receiver=esa6.microchip.iphmx.com;
  envelope-from="Nicolas.Ferre@microchip.com";
  x-sender="Nicolas.Ferre@microchip.com";
  x-conformance=spf_only; x-record-type="v=spf1";
  x-record-text="v=spf1 mx a:ushub1.microchip.com
  a:smtpout.microchip.com -exists:%{i}.spf.microchip.iphmx.com
  include:servers.mcsv.net include:mktomail.com
  include:spf.protection.outlook.com ~all"
Received-SPF: None (esa6.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@email.microchip.com) identity=helo;
  client-ip=198.175.253.82; receiver=esa6.microchip.iphmx.com;
  envelope-from="Nicolas.Ferre@microchip.com";
  x-sender="postmaster@email.microchip.com";
  x-conformance=spf_only
Authentication-Results: esa6.microchip.iphmx.com; spf=Pass smtp.mailfrom=Nicolas.Ferre@microchip.com; spf=None smtp.helo=postmaster@email.microchip.com; dmarc=pass (p=none dis=none) d=microchip.com
IronPort-SDR: 1C20GDZ9zHq6lqhyTuQjNJdhEbeitvDgpQ2mrR6kPvGPMepTCxAIsj56LRp0LRCd2j8a7ShWu2
 OCBT1ZxsDwUnSV3bT3285biPtzcM7yE8PG9J/CdRjuNdMVo+sq6/5Q71WrDHnSX5bn1KMMpsVJ
 4pDHw2A6Zn4rbaG9IRfYAFtVqpOQ4FRcw4x5xBInRuFgSqm+QGi5BoxVNy0mXyXNkwxwk0OqIR
 idUU8HPazFW/pQpYuQfTHjIlaisR1x27CJcysNaABc37n/CmK+evIllnMXu+nUFTj/Tt9joSBm
 lgo=
X-IronPort-AV: E=Sophos;i="5.70,436,1574146800"; 
   d="scan'208";a="2253968"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 13 Feb 2020 01:45:40 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 13 Feb 2020 01:45:40 -0700
Received: from [10.159.205.131] (10.10.85.251) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.1713.5 via Frontend
 Transport; Thu, 13 Feb 2020 01:45:35 -0700
Subject: Re: [PATCH net] net: macb: ensure interface is not suspended on
 at91rm9200
To:     Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "David S . Miller" <davem@davemloft.net>
CC:     Harini Katakam <harini.katakam@xilinx.com>,
        Shubhrajyoti Datta <shubhrajyoti.datta@xilinx.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20200212164538.383741-1-alexandre.belloni@bootlin.com>
From:   Nicolas Ferre <nicolas.ferre@microchip.com>
Organization: microchip
Message-ID: <a27e7d3f-b576-a90a-00c4-c5ce7bf69592@microchip.com>
Date:   Thu, 13 Feb 2020 09:45:35 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200212164538.383741-1-alexandre.belloni@bootlin.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/02/2020 at 17:45, Alexandre Belloni wrote:
> EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
> 
> Because of autosuspend, at91ether_start is called with clocks disabled.
> Ensure that pm_runtime doesn't suspend the interface as soon as it is
> opened as there is no pm_runtime support is the other relevant parts of the
> platform support for at91rm9200.
> 
> Fixes: d54f89af6cc4 ("net: macb: Add pm runtime support")
> Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>

Acked-by: Nicolas Ferre <nicolas.ferre@microchip.com>

> ---
>   drivers/net/ethernet/cadence/macb_main.c | 6 +++++-
>   1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
> index 4508f0d150da..def94e91883a 100644
> --- a/drivers/net/ethernet/cadence/macb_main.c
> +++ b/drivers/net/ethernet/cadence/macb_main.c
> @@ -3790,6 +3790,10 @@ static int at91ether_open(struct net_device *dev)
>          u32 ctl;
>          int ret;
> 
> +       ret = pm_runtime_get_sync(&lp->pdev->dev);
> +       if (ret < 0)
> +               return ret;
> +
>          /* Clear internal statistics */
>          ctl = macb_readl(lp, NCR);
>          macb_writel(lp, NCR, ctl | MACB_BIT(CLRSTAT));
> @@ -3854,7 +3858,7 @@ static int at91ether_close(struct net_device *dev)
>                            q->rx_buffers, q->rx_buffers_dma);
>          q->rx_buffers = NULL;
> 
> -       return 0;
> +       return pm_runtime_put(&lp->pdev->dev);
>   }
> 
>   /* Transmit packet */
> --
> 2.24.1
> 


-- 
Nicolas Ferre

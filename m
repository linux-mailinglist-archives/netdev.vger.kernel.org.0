Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 901154AEFFB
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 12:33:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230092AbiBILde (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 06:33:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbiBILde (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 06:33:34 -0500
X-Greylist: delayed 63 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 09 Feb 2022 02:25:51 PST
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B8F8E148617
        for <netdev@vger.kernel.org>; Wed,  9 Feb 2022 02:25:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1644402351; x=1675938351;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=tKssAuH+rgarP0EYdoMpZsm6AfzDbRcpB7eIOckVr+8=;
  b=Cdxa53MndEsT3OS3T1LHc1XU+fJWXoUc6gJhel92lZqVlj286xlPMyBN
   FG+0PXhkEpc/cc3jDEi08j6iqV2BUEPqCecV5j35YS/R5wvI/JOorDZ7W
   sx0F5WejVBHiAnGtZJTU8dJxLk68MVcO967HjPH3KNvnWOAjqNgCGQv2Q
   s3UEJKlluaTM7C0rT1rolLlI1zoXHNi7e6bgL76K4yS70cDdnPSmEeAdQ
   MJ1qDHrFhxeh/8SRnGSzZR9JsJHTJ9sV5f6UVNMNHmleuaJVL9y5oQIkS
   qoFnXOhTMPtVfdCB7UqQOK8XU2Ihp7Hv9lQg6mX3IlE1GMnl/WntyzmFM
   A==;
IronPort-SDR: nGNsrxLmsWkOMGuzZt+kNen+3rqOnR8/JnVhk0PEznY0smadEE71pwygWpO09i5NykHPK/ug/R
 oux1jfrqQOqnrN/1FNKtmBnr+MQctYQveZRFfKFR7CpE7o28FmaSNW+ZFn6rWNQCIv2wyXzErJ
 u1OT9+MhXcFNdrdd5ew/ZSobvHKbclmFNE0pbAp6aYHqufd+pYOID0KTU21RSFPUC2WGU+tFv7
 BZNmPVS5SkjeSBHupK/gs78e787jWmhSXmCPa0LPpdU2MrFG0ymkuwYQi3hsYGvixlyb6LHBiY
 gf+tWIdk1+o86FXk+4ZM2wog
X-IronPort-AV: E=Sophos;i="5.88,355,1635231600"; 
   d="scan'208";a="145378883"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 09 Feb 2022 03:24:47 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Wed, 9 Feb 2022 03:24:47 -0700
Received: from [10.159.245.112] (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.2375.17 via Frontend
 Transport; Wed, 9 Feb 2022 03:24:45 -0700
Message-ID: <e33d303b-15d6-d133-bdb3-cb63e305ef24@microchip.com>
Date:   Wed, 9 Feb 2022 11:24:43 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH] net: macb: Align the dma and coherent dma masks
Content-Language: en-US
To:     Harini Katakam <harini.katakam@xilinx.com>, <davem@davemloft.net>,
        <claudiu.beznea@microchip.com>, <kuba@kernel.org>,
        <Conor.Dooley@microchip.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <michal.simek@xilinx.com>, <harinikatakamlinux@gmail.com>,
        <mstamand@ciena.com>
References: <20220209094325.8525-1-harini.katakam@xilinx.com>
From:   Nicolas Ferre <nicolas.ferre@microchip.com>
Organization: microchip
In-Reply-To: <20220209094325.8525-1-harini.katakam@xilinx.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 09/02/2022 at 10:43, Harini Katakam wrote:
> EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
> 
> From: Marc St-Amand <mstamand@ciena.com>
> 
> Single page and coherent memory blocks can use different DMA masks
> when the macb accesses physical memory directly. The kernel is clever
> enough to allocate pages that fit into the requested address width.
> 
> When using the ARM SMMU, the DMA mask must be the same for single
> pages and big coherent memory blocks. Otherwise the translation
> tables turn into one big mess.
> 
>    [   74.959909] macb ff0e0000.ethernet eth0: DMA bus error: HRESP not OK
>    [   74.959989] arm-smmu fd800000.smmu: Unhandled context fault: fsr=0x402, iova=0x3165687460, fsynr=0x20001, cbfrsynra=0x877, cb=1
>    [   75.173939] macb ff0e0000.ethernet eth0: DMA bus error: HRESP not OK
>    [   75.173955] arm-smmu fd800000.smmu: Unhandled context fault: fsr=0x402, iova=0x3165687460, fsynr=0x20001, cbfrsynra=0x877, cb=1
> 
> Since using the same DMA mask does not hurt direct 1:1 physical
> memory mappings, this commit always aligns DMA and coherent masks.
> 
> Signed-off-by: Marc St-Amand <mstamand@ciena.com>
> Signed-off-by: Harini Katakam <harini.katakam@xilinx.com>

Ok:
Acked-by: Nicolas Ferre <nicolas.ferre@microchip.com>

Best regards,
   Nicolas

> ---
>   drivers/net/ethernet/cadence/macb_main.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
> index 1ce20bf52f72..4c231159b562 100644
> --- a/drivers/net/ethernet/cadence/macb_main.c
> +++ b/drivers/net/ethernet/cadence/macb_main.c
> @@ -4765,7 +4765,7 @@ static int macb_probe(struct platform_device *pdev)
> 
>   #ifdef CONFIG_ARCH_DMA_ADDR_T_64BIT
>          if (GEM_BFEXT(DAW64, gem_readl(bp, DCFG6))) {
> -               dma_set_mask(&pdev->dev, DMA_BIT_MASK(44));
> +               dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(44));
>                  bp->hw_dma_cap |= HW_DMA_CAP_64B;
>          }
>   #endif
> --
> 2.17.1
> 


-- 
Nicolas Ferre

Return-Path: <netdev+bounces-11029-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C593D731299
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 10:47:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2607A281707
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 08:47:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 45C473D75;
	Thu, 15 Jun 2023 08:47:24 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 391E7EDF
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 08:47:24 +0000 (UTC)
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 100CD3C1E;
	Thu, 15 Jun 2023 01:47:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1686818835; x=1718354835;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=QTzovRalX3ETeY4VZEKtHx2GIcZ+aGw7PXrcvk6ii2c=;
  b=dcvIlLIOxqA/NyB8OIJZdIWNm+JDM/HXaIVOLDFAHQS7MIYzW96CNS2e
   KQlgRlYT7wm3GsulKbWhwMoHXe4pgFLLHwkBmkvjGfBHCjfsDI1vbMdzH
   SkxvD6HYQk/TH9SGyoKtOmC7/BCrjT0rcFXdLVmgxG9sIt3/YCeJXLCbY
   imuiRKa8f7/N3mHjhT/VW1hJwCNptp04XeVjaXb5mxO+7mxKEIt6idomC
   N3oCBSjblSPyP6Qufj4ztCMFeo0J7yXCvJrYmgRMVbt40D2pXnQQt4YV2
   f66WYosf4NzRMUxHLlryZTsi8A5FIdAYiAyejRdH/vyVD/18JqL3XxVll
   Q==;
X-IronPort-AV: E=Sophos;i="6.00,244,1681196400"; 
   d="scan'208";a="218618754"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 15 Jun 2023 01:47:14 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 15 Jun 2023 01:47:12 -0700
Received: from [10.159.245.112] (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.2507.21 via Frontend
 Transport; Thu, 15 Jun 2023 01:47:09 -0700
Message-ID: <c03077f4-93de-d1c4-0f5d-19292553e6c8@microchip.com>
Date: Thu, 15 Jun 2023 10:46:57 +0200
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH net-next v4 2/2] net: macb: Add support for partial store
 and forward
Content-Language: en-US
To: Pranavi Somisetty <pranavi.somisetty@amd.com>, <davem@davemloft.net>,
	<edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
	<robh+dt@kernel.org>, <krzysztof.kozlowski+dt@linaro.org>,
	<claudiu.beznea@microchip.com>
CC: <git@amd.com>, <michal.simek@amd.com>, <harini.katakam@amd.com>,
	<radhey.shyam.pandey@amd.com>, <netdev@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>
References: <20230613054340.12837-1-pranavi.somisetty@amd.com>
 <20230613054340.12837-3-pranavi.somisetty@amd.com>
From: Nicolas Ferre <nicolas.ferre@microchip.com>
Organization: microchip
In-Reply-To: <20230613054340.12837-3-pranavi.somisetty@amd.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
	RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 13/06/2023 at 07:43, Pranavi Somisetty wrote:
> EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
> 
> From: Maulik Jodhani <maulik.jodhani@xilinx.com>
> 
> When the receive partial store and forward mode is activated, the
> receiver will only begin to forward the packet to the external AHB
> or AXI slave when enough packet data is stored in the packet buffer.
> The amount of packet data required to activate the forwarding process
> is programmable via watermark registers which are located at the same
> address as the partial store and forward enable bits. Adding support to
> read this rx-watermark value from device-tree, to program the watermark
> registers and enable partial store and forwarding.
> 
> Signed-off-by: Maulik Jodhani <maulik.jodhani@xilinx.com>
> Signed-off-by: Pranavi Somisetty <pranavi.somisetty@amd.com>

Looks good to me:
Acked-by: Nicolas Ferre <nicolas.ferre@microchip.com>

Thanks for your patch and effort to address comments Pranavi.

Best regards,
   Nicolas

> ---
> Changes v2:
> 1. Removed all the changes related to validating FCS when Rx checksum offload is disabled.
> 2. Instead of using a platform dependent number (0xFFF) for the reset value of rx watermark,
> derive it from designcfg_debug2 register.
> 3. Added a check to see if partial s/f is supported, by reading the
> designcfg_debug6 register.
> 
> Changes v3:
> 1. Followed reverse christmas tree pattern in declaring variables.
> 2. Return -EINVAL when an invalid watermark value is set.
> 3. Removed netdev_info when partial store and forward is not enabled.
> 4. Validating the rx-watermark value in probe itself and only write to the register
> in init.
> 5. Writing a reset value to the pbuf_cuthru register before disabing partial store
> and forward is redundant. So removing it.
> 6. Removed the platform caps flag.
> 7. Instead of reading rx-watermark from DT in macb_configure_caps,
> reading it in probe.
> 8. Changed Signed-Off-By and author names on this patch.
> 
> Changes v4:
> 1. Removed redundant code and unused variables.
> 2. When the rx-watermark value is invalid, instead of returning EINVAL,
> do not enable partial store and forward.
> 3. Change rx-watermark variable's size to u32 instead of u16.
> ---
>   drivers/net/ethernet/cadence/macb.h      | 12 +++++++++++
>   drivers/net/ethernet/cadence/macb_main.c | 27 ++++++++++++++++++++++++
>   2 files changed, 39 insertions(+)
> 
> diff --git a/drivers/net/ethernet/cadence/macb.h b/drivers/net/ethernet/cadence/macb.h
> index 14dfec4db8f9..39d53117a8ce 100644
> --- a/drivers/net/ethernet/cadence/macb.h
> +++ b/drivers/net/ethernet/cadence/macb.h
> @@ -82,6 +82,7 @@
>   #define GEM_NCFGR              0x0004 /* Network Config */
>   #define GEM_USRIO              0x000c /* User IO */
>   #define GEM_DMACFG             0x0010 /* DMA Configuration */
> +#define GEM_PBUFRXCUT          0x0044 /* RX Partial Store and Forward */
>   #define GEM_JML                        0x0048 /* Jumbo Max Length */
>   #define GEM_HS_MAC_CONFIG      0x0050 /* GEM high speed config */
>   #define GEM_HRB                        0x0080 /* Hash Bottom */
> @@ -343,6 +344,10 @@
>   #define GEM_ADDR64_SIZE                1
> 
> 
> +/* Bitfields in PBUFRXCUT */
> +#define GEM_ENCUTTHRU_OFFSET   31 /* Enable RX partial store and forward */
> +#define GEM_ENCUTTHRU_SIZE     1
> +
>   /* Bitfields in NSR */
>   #define MACB_NSR_LINK_OFFSET   0 /* pcs_link_state */
>   #define MACB_NSR_LINK_SIZE     1
> @@ -509,6 +514,8 @@
>   #define GEM_TX_PKT_BUFF_OFFSET                 21
>   #define GEM_TX_PKT_BUFF_SIZE                   1
> 
> +#define GEM_RX_PBUF_ADDR_OFFSET                        22
> +#define GEM_RX_PBUF_ADDR_SIZE                  4
> 
>   /* Bitfields in DCFG5. */
>   #define GEM_TSU_OFFSET                         8
> @@ -517,6 +524,8 @@
>   /* Bitfields in DCFG6. */
>   #define GEM_PBUF_LSO_OFFSET                    27
>   #define GEM_PBUF_LSO_SIZE                      1
> +#define GEM_PBUF_CUTTHRU_OFFSET                        25
> +#define GEM_PBUF_CUTTHRU_SIZE                  1
>   #define GEM_DAW64_OFFSET                       23
>   #define GEM_DAW64_SIZE                         1
> 
> @@ -1283,6 +1292,9 @@ struct macb {
> 
>          u32                     wol;
> 
> +       /* holds value of rx watermark value for pbuf_rxcutthru register */
> +       u32                     rx_watermark;
> +
>          struct macb_ptp_info    *ptp_info;      /* macb-ptp interface */
> 
>          struct phy              *sgmii_phy;     /* for ZynqMP SGMII mode */
> diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
> index 41964fd02452..7d023b92b169 100644
> --- a/drivers/net/ethernet/cadence/macb_main.c
> +++ b/drivers/net/ethernet/cadence/macb_main.c
> @@ -2617,6 +2617,9 @@ static void macb_reset_hw(struct macb *bp)
>          macb_writel(bp, TSR, -1);
>          macb_writel(bp, RSR, -1);
> 
> +       /* Disable RX partial store and forward and reset watermark value */
> +       gem_writel(bp, PBUFRXCUT, 0);
> +
>          /* Disable all interrupts */
>          for (q = 0, queue = bp->queues; q < bp->num_queues; ++q, ++queue) {
>                  queue_writel(queue, IDR, -1);
> @@ -2770,6 +2773,10 @@ static void macb_init_hw(struct macb *bp)
>                  bp->rx_frm_len_mask = MACB_RX_JFRMLEN_MASK;
> 
>          macb_configure_dma(bp);
> +
> +       /* Enable RX partial store and forward and set watermark */
> +       if (bp->rx_watermark)
> +               gem_writel(bp, PBUFRXCUT, (bp->rx_watermark | GEM_BIT(ENCUTTHRU)));
>   }
> 
>   /* The hash address register is 64 bits long and takes up two
> @@ -4923,6 +4930,7 @@ static int macb_probe(struct platform_device *pdev)
>          phy_interface_t interface;
>          struct net_device *dev;
>          struct resource *regs;
> +       u32 wtrmrk_rst_val;
>          void __iomem *mem;
>          struct macb *bp;
>          int err, val;
> @@ -4995,6 +5003,25 @@ static int macb_probe(struct platform_device *pdev)
> 
>          bp->usrio = macb_config->usrio;
> 
> +       /* By default we set to partial store and forward mode for zynqmp.
> +        * Disable if not set in devicetree.
> +        */
> +       if (GEM_BFEXT(PBUF_CUTTHRU, gem_readl(bp, DCFG6))) {
> +               err = of_property_read_u32(bp->pdev->dev.of_node,
> +                                          "cdns,rx-watermark",
> +                                          &bp->rx_watermark);
> +
> +               if (!err) {
> +                       /* Disable partial store and forward in case of error or
> +                        * invalid watermark value
> +                        */
> +                       wtrmrk_rst_val = (1 << (GEM_BFEXT(RX_PBUF_ADDR, gem_readl(bp, DCFG2)))) - 1;
> +                       if (bp->rx_watermark > wtrmrk_rst_val || !bp->rx_watermark) {
> +                               dev_info(&bp->pdev->dev, "Invalid watermark value\n");
> +                               bp->rx_watermark = 0;
> +                       }
> +               }
> +       }
>          spin_lock_init(&bp->lock);
> 
>          /* setup capabilities */
> --
> 2.36.1
> 

-- 
Nicolas Ferre



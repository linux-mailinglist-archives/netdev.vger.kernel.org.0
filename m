Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59F3E617F59
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 15:23:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230458AbiKCOX3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 10:23:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230074AbiKCOXZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 10:23:25 -0400
Received: from madras.collabora.co.uk (madras.collabora.co.uk [46.235.227.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81191F58;
        Thu,  3 Nov 2022 07:23:24 -0700 (PDT)
Received: from [192.168.1.100] (2-237-20-237.ip236.fastwebnet.it [2.237.20.237])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (No client certificate requested)
        (Authenticated sender: kholk11)
        by madras.collabora.co.uk (Postfix) with ESMTPSA id 96FE26600371;
        Thu,  3 Nov 2022 14:23:21 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
        s=mail; t=1667485402;
        bh=3mt1m6/QtMnNnjR535B2nVg3qDLugNulE7yA6duNDag=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=OC8hm/Q4NRI6uEEABE1mX5Wvw4kDDeQEGmMKkS4Ru23B2iGdCoIF47mdcG4SqtIQ1
         cLroty8af5np/zfAOspaO+mq/PE65O/qQItqrEHRuwPYDXukYx8ITynggYdz0oNoHL
         rb6LbFPvr1fiqQx1s3QK3UDVDU2vy7lTRmgmPSAKtszwj6MkHjEP8+0iO89k/C1508
         4H+p0Z+ryn4kzMXNMtEP68r/Q0C17jCRFLlzTWmxiSWegJdRNYzPJS1Sp81uvU1BJk
         tp79Jh6hgnhwl4BYfmuI0Vc43S39JGv7qJ+v3NY6CZEJQowxfwcIUOFb+Ymwqij6Gy
         kEtriTb2LqmKQ==
Message-ID: <5248b495-710b-ad72-7813-869dc660cf31@collabora.com>
Date:   Thu, 3 Nov 2022 15:23:19 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.3
Subject: Re: [PATCH v3 net-next 3/8] net: ethernet: mtk_wed: introduce wed mcu
 support
Content-Language: en-US
To:     Lorenzo Bianconi <lorenzo@kernel.org>, netdev@vger.kernel.org
Cc:     nbd@nbd.name, john@phrozen.org, sean.wang@mediatek.com,
        Mark-MC.Lee@mediatek.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, matthias.bgg@gmail.com,
        linux-mediatek@lists.infradead.org, lorenzo.bianconi@redhat.com,
        Bo.Jiao@mediatek.com, sujuan.chen@mediatek.com,
        ryder.Lee@mediatek.com, evelyn.tsai@mediatek.com,
        devicetree@vger.kernel.org, robh+dt@kernel.org,
        daniel@makrotopia.org, krzysztof.kozlowski+dt@linaro.org
References: <cover.1667466887.git.lorenzo@kernel.org>
 <01c82e3783373e04b609d60075ef7ecf71d0d24d.1667466887.git.lorenzo@kernel.org>
From:   AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>
In-Reply-To: <01c82e3783373e04b609d60075ef7ecf71d0d24d.1667466887.git.lorenzo@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Il 03/11/22 10:28, Lorenzo Bianconi ha scritto:
> From: Sujuan Chen <sujuan.chen@mediatek.com>
> 
> Introduce WED mcu support used to configure WED WO chip.
> This is a preliminary patch in order to add RX Wireless
> Ethernet Dispatch available on MT7986 SoC.
> 
> Tested-by: Daniel Golle <daniel@makrotopia.org>
> Co-developed-by: Lorenzo Bianconi <lorenzo@kernel.org>
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> Signed-off-by: Sujuan Chen <sujuan.chen@mediatek.com>
> ---
>   drivers/net/ethernet/mediatek/Makefile       |   2 +-
>   drivers/net/ethernet/mediatek/mtk_wed_mcu.c  | 364 +++++++++++++++++++
>   drivers/net/ethernet/mediatek/mtk_wed_regs.h |   1 +
>   drivers/net/ethernet/mediatek/mtk_wed_wo.h   | 152 ++++++++
>   include/linux/soc/mediatek/mtk_wed.h         |  29 ++
>   5 files changed, 547 insertions(+), 1 deletion(-)
>   create mode 100644 drivers/net/ethernet/mediatek/mtk_wed_mcu.c
>   create mode 100644 drivers/net/ethernet/mediatek/mtk_wed_wo.h
> 
> diff --git a/drivers/net/ethernet/mediatek/Makefile b/drivers/net/ethernet/mediatek/Makefile
> index 45ba0970504a..d4bdefa77159 100644
> --- a/drivers/net/ethernet/mediatek/Makefile
> +++ b/drivers/net/ethernet/mediatek/Makefile
> @@ -5,7 +5,7 @@
>   
>   obj-$(CONFIG_NET_MEDIATEK_SOC) += mtk_eth.o
>   mtk_eth-y := mtk_eth_soc.o mtk_sgmii.o mtk_eth_path.o mtk_ppe.o mtk_ppe_debugfs.o mtk_ppe_offload.o
> -mtk_eth-$(CONFIG_NET_MEDIATEK_SOC_WED) += mtk_wed.o
> +mtk_eth-$(CONFIG_NET_MEDIATEK_SOC_WED) += mtk_wed.o mtk_wed_mcu.o
>   ifdef CONFIG_DEBUG_FS
>   mtk_eth-$(CONFIG_NET_MEDIATEK_SOC_WED) += mtk_wed_debugfs.o
>   endif
> diff --git a/drivers/net/ethernet/mediatek/mtk_wed_mcu.c b/drivers/net/ethernet/mediatek/mtk_wed_mcu.c
> new file mode 100644
> index 000000000000..20987eecfb52
> --- /dev/null
> +++ b/drivers/net/ethernet/mediatek/mtk_wed_mcu.c

..snip..

> +
> +int mtk_wed_mcu_init(struct mtk_wed_wo *wo)
> +{
> +	u32 val;
> +	int ret;
> +
> +	skb_queue_head_init(&wo->mcu.res_q);
> +	init_waitqueue_head(&wo->mcu.wait);
> +	mutex_init(&wo->mcu.mutex);
> +
> +	ret = mtk_wed_mcu_load_firmware(wo);
> +	if (ret)
> +		return ret;
> +
> +	do {
> +		/* get dummy cr */
> +		val = wed_r32(wo->hw->wed_dev,
> +			      MTK_WED_SCR0 + 4 * MTK_WED_DUMMY_CR_FWDL);
> +	} while (val && !time_after(jiffies, jiffies + MTK_FW_DL_TIMEOUT));

Here you can use readx_poll_timeout() instead: please do so.

> +
> +	return val ? -EBUSY : 0;
> +}
> +
> +MODULE_FIRMWARE(MT7986_FIRMWARE_WO0);
> +MODULE_FIRMWARE(MT7986_FIRMWARE_WO1);
> diff --git a/drivers/net/ethernet/mediatek/mtk_wed_regs.h b/drivers/net/ethernet/mediatek/mtk_wed_regs.h
> index e270fb336143..c940b3bb215b 100644
> --- a/drivers/net/ethernet/mediatek/mtk_wed_regs.h
> +++ b/drivers/net/ethernet/mediatek/mtk_wed_regs.h
> @@ -152,6 +152,7 @@ struct mtk_wdma_desc {
>   
>   #define MTK_WED_RING_RX(_n)				(0x400 + (_n) * 0x10)
>   
> +#define MTK_WED_SCR0					0x3c0
>   #define MTK_WED_WPDMA_INT_TRIGGER			0x504
>   #define MTK_WED_WPDMA_INT_TRIGGER_RX_DONE		BIT(1)
>   #define MTK_WED_WPDMA_INT_TRIGGER_TX_DONE		GENMASK(5, 4)
> diff --git a/drivers/net/ethernet/mediatek/mtk_wed_wo.h b/drivers/net/ethernet/mediatek/mtk_wed_wo.h
> new file mode 100644
> index 000000000000..2ef3ccdec5bf
> --- /dev/null
> +++ b/drivers/net/ethernet/mediatek/mtk_wed_wo.h
> @@ -0,0 +1,152 @@


..snip..

> +
> +#define MTK_WO_MCU_CFG_LS_BASE				0 /* XXX: 0x15194000 */

Since that definition is zero, you can safely remove it: like so, the ones
following will be a bit more readable.

> +#define MTK_WO_MCU_CFG_LS_HW_VER_ADDR			(MTK_WO_MCU_CFG_LS_BASE + 0x000)
> +#define MTK_WO_MCU_CFG_LS_FW_VER_ADDR			(MTK_WO_MCU_CFG_LS_BASE + 0x004)
> +#define MTK_WO_MCU_CFG_LS_CFG_DBG1_ADDR			(MTK_WO_MCU_CFG_LS_BASE + 0x00c)
> +#define MTK_WO_MCU_CFG_LS_CFG_DBG2_ADDR			(MTK_WO_MCU_CFG_LS_BASE + 0x010)
> +#define MTK_WO_MCU_CFG_LS_WF_MCCR_ADDR			(MTK_WO_MCU_CFG_LS_BASE + 0x014)
> +#define MTK_WO_MCU_CFG_LS_WF_MCCR_SET_ADDR		(MTK_WO_MCU_CFG_LS_BASE + 0x018)
> +#define MTK_WO_MCU_CFG_LS_WF_MCCR_CLR_ADDR		(MTK_WO_MCU_CFG_LS_BASE + 0x01c)
> +#define MTK_WO_MCU_CFG_LS_WF_MCU_CFG_WM_WA_ADDR		(MTK_WO_MCU_CFG_LS_BASE + 0x050)
> +#define MTK_WO_MCU_CFG_LS_WM_BOOT_ADDR_ADDR		(MTK_WO_MCU_CFG_LS_BASE + 0x060)
> +#define MTK_WO_MCU_CFG_LS_WA_BOOT_ADDR_ADDR		(MTK_WO_MCU_CFG_LS_BASE + 0x064)

..snip..

> +
> +static inline int
> +mtk_wed_mcu_check_msg(struct mtk_wed_wo *wo, struct sk_buff *skb)
> +{
> +	struct mtk_wed_mcu_hdr *hdr = (struct mtk_wed_mcu_hdr *)skb->data;
> +
> +	if (hdr->version)

	if (hdr->version || skb->len < sizeof(*hdr) || skb->len != le16_to_cpu(hdr->length))
		return -EINVAL;


> +		return -EINVAL;
> +
> +	if (skb->len < sizeof(*hdr))
> +		return -EINVAL;
> +
> +	if (skb->len != le16_to_cpu(hdr->length))
> +		return -EINVAL;
> +
> +	return 0;
> +}
> +

Regards,
Angelo


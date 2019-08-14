Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F8DC8CF67
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 11:26:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726998AbfHNJ0Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Aug 2019 05:26:24 -0400
Received: from mx.0dd.nl ([5.2.79.48]:33346 "EHLO mx.0dd.nl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725928AbfHNJ0Y (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Aug 2019 05:26:24 -0400
Received: from mail.vdorst.com (mail.vdorst.com [IPv6:fd01::250])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx.0dd.nl (Postfix) with ESMTPS id 30B115FA49;
        Wed, 14 Aug 2019 11:26:22 +0200 (CEST)
Authentication-Results: mx.0dd.nl;
        dkim=pass (2048-bit key; secure) header.d=vdorst.com header.i=@vdorst.com header.b="FCW1o57/";
        dkim-atps=neutral
Received: from www (www.vdorst.com [192.168.2.222])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.vdorst.com (Postfix) with ESMTPSA id F3C5A1D6F475;
        Wed, 14 Aug 2019 11:26:21 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.vdorst.com F3C5A1D6F475
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vdorst.com;
        s=default; t=1565774782;
        bh=3q426un0gISmLfXN0uWMxNzgRrhcurIB/xDHYXFpo4Q=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FCW1o57/r09K2Ap/lcGfI0LnufPMC1XNE4Yl9DFVJ8gGILsIjk5yXEiHf7n8wrqRB
         sEXM+q1zopHa7IZc3iK3CrYZC6Tfwc4ZsYxNwVbVPHRX5xj009mjI2GpQ8BJvswbDG
         8Ru5t2fNaxKN4BSY+CpcRPL+bm7MD6WfRIs8izFoYgVk23ZiFmjwj0agLmtLA4Na+c
         WFtZpEJRR7BZeTo1QkoBxCOWRQUWo5wcbjlcWSGpklcYGHmW1LgZs+XbEQk8NhHgXq
         Lpzlf9Jgd6cutlQfgVLO3twOFqUC7T6k0ABvgDXUYHm1bqu5szoFpxEsdi4m6Il8Ik
         8uvR+4eSDzzSg==
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1]) by
 www.vdorst.com (Horde Framework) with HTTPS; Wed, 14 Aug 2019 09:26:21 +0000
Date:   Wed, 14 Aug 2019 09:26:21 +0000
Message-ID: <20190814092621.Horde.epvj8zK96-aCiV70YB5Q7II@www.vdorst.com>
From:   =?utf-8?b?UmVuw6k=?= van Dorst <opensource@vdorst.com>
To:     Stefan Roese <sr@denx.de>
Cc:     netdev@vger.kernel.org, linux-mediatek@lists.infradead.org,
        Sean Wang <sean.wang@mediatek.com>,
        Felix Fietkau <nbd@openwrt.org>,
        John Crispin <john@phrozen.org>,
        Daniel Golle <daniel@makrotopia.org>
Subject: Re: [PATCH] net: ethernet: mediatek: Add MT7628/88 SoC support
References: <20190717125345.Horde.JcDE_nBChPFDDjEgIRfPSl3@www.vdorst.com>
 <a92d7207-80b2-e88d-d869-64c9758ef1da@denx.de>
In-Reply-To: <a92d7207-80b2-e88d-d869-64c9758ef1da@denx.de>
User-Agent: Horde Application Framework 5
Content-Type: text/plain; charset=utf-8; format=flowed; DelSp=Yes
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Stefan,

Quoting Stefan Roese <sr@denx.de>:

> Hi Rene,
>
> On 17.07.19 14:53, René van Dorst wrote:
>
> <snip>
>
>>> +++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
>>> @@ -39,7 +39,8 @@
>>>  				 NETIF_F_SG | NETIF_F_TSO | \
>>>  				 NETIF_F_TSO6 | \
>>>  				 NETIF_F_IPV6_CSUM)
>>> -#define NEXT_RX_DESP_IDX(X, Y)	(((X) + 1) & ((Y) - 1))
>>> +#define MTK_HW_FEATURES_MT7628	(NETIF_F_SG | NETIF_F_RXCSUM)
>>> +#define NEXT_DESP_IDX(X, Y)	(((X) + 1) & ((Y) - 1))
>>>
>>>  #define MTK_MAX_RX_RING_NUM	4
>>>  #define MTK_HW_LRO_DMA_SIZE	8
>>> @@ -118,6 +119,7 @@
>>>  /* PDMA Global Configuration Register */
>>>  #define MTK_PDMA_GLO_CFG	0xa04
>>>  #define MTK_MULTI_EN		BIT(10)
>>> +#define MTK_PDMA_SIZE_8DWORDS	(1 << 4)
>>>
>>>  /* PDMA Reset Index Register */
>>>  #define MTK_PDMA_RST_IDX	0xa08
>>> @@ -276,11 +278,18 @@
>>>  #define TX_DMA_OWNER_CPU	BIT(31)
>>>  #define TX_DMA_LS0		BIT(30)
>>>  #define TX_DMA_PLEN0(_x)	(((_x) & MTK_TX_DMA_BUF_LEN) << 16)
>>> +#define TX_DMA_PLEN1(_x)	((_x) & MTK_TX_DMA_BUF_LEN)
>>>  #define TX_DMA_SWC		BIT(14)
>>>  #define TX_DMA_SDL(_x)		(((_x) & 0x3fff) << 16)
>>>
>>> +/* PDMA on MT7628 */
>>> +#define TX_DMA_DONE		BIT(31)
>>> +#define TX_DMA_LS1		BIT(14)
>>> +#define TX_DMA_DESP2_DEF	(TX_DMA_LS0 | TX_DMA_DONE)
>>> +
>>>  /* QDMA descriptor rxd2 */
>>>  #define RX_DMA_DONE		BIT(31)
>>> +#define RX_DMA_LSO		BIT(30)
>>>  #define RX_DMA_PLEN0(_x)	(((_x) & 0x3fff) << 16)
>>>  #define RX_DMA_GET_PLEN0(_x)	(((_x) >> 16) & 0x3fff)
>>>
>>> @@ -289,6 +298,7 @@
>>>
>>>  /* QDMA descriptor rxd4 */
>>>  #define RX_DMA_L4_VALID		BIT(24)
>>> +#define RX_DMA_L4_VALID_PDMA	BIT(30)		/* when PDMA is used */
>>>  #define RX_DMA_FPORT_SHIFT	19
>>>  #define RX_DMA_FPORT_MASK	0x7
>>>
>>> @@ -412,6 +422,19 @@
>>>  #define CO_QPHY_SEL            BIT(0)
>>>  #define GEPHY_MAC_SEL          BIT(1)
>>>
>>> +/* MT7628/88 specific stuff */
>>> +#define MT7628_PDMA_OFFSET	0x0800
>>> +#define MT7628_SDM_OFFSET	0x0c00
>>> +
>>> +#define MT7628_TX_BASE_PTR0	(MT7628_PDMA_OFFSET + 0x00)
>>> +#define MT7628_TX_MAX_CNT0	(MT7628_PDMA_OFFSET + 0x04)
>>> +#define MT7628_TX_CTX_IDX0	(MT7628_PDMA_OFFSET + 0x08)
>>> +#define MT7628_TX_DTX_IDX0	(MT7628_PDMA_OFFSET + 0x0c)
>>> +#define MT7628_PST_DTX_IDX0	BIT(0)
>>> +
>>> +#define MT7628_SDM_MAC_ADRL	(MT7628_SDM_OFFSET + 0x0c)
>>> +#define MT7628_SDM_MAC_ADRH	(MT7628_SDM_OFFSET + 0x10)
>>> +
>>>  struct mtk_rx_dma {
>>>  	unsigned int rxd1;
>>>  	unsigned int rxd2;
>>> @@ -509,6 +532,7 @@ enum mtk_clks_map {
>>>  				 BIT(MTK_CLK_SGMII_CK) | \
>>>  				 BIT(MTK_CLK_ETH2PLL))
>>>  #define MT7621_CLKS_BITMAP	(0)
>>> +#define MT7628_CLKS_BITMAP	(0)
>>>  #define MT7629_CLKS_BITMAP	(BIT(MTK_CLK_ETHIF) | BIT(MTK_CLK_ESW) |  \
>>>  				 BIT(MTK_CLK_GP0) | BIT(MTK_CLK_GP1) | \
>>>  				 BIT(MTK_CLK_GP2) | BIT(MTK_CLK_FE) | \
>>> @@ -563,6 +587,10 @@ struct mtk_tx_ring {
>>>  	struct mtk_tx_dma *last_free;
>>>  	u16 thresh;
>>>  	atomic_t free_count;
>>> +	int dma_size;
>>> +	struct mtk_tx_dma *dma_pdma;	/* For MT7628/88 PDMA handling */
>>> +	dma_addr_t phys_pdma;
>>> +	int cpu_idx;
>>>  };
>>>
>>>  /* PDMA rx ring mode */
>>> @@ -604,6 +632,7 @@ enum mkt_eth_capabilities {
>>>  	MTK_HWLRO_BIT,
>>>  	MTK_SHARED_INT_BIT,
>>>  	MTK_TRGMII_MT7621_CLK_BIT,
>>> +	MTK_SOC_MT7628,
>>
>> This should be MTK_SOC_MT7628_BIT, this only defines the bit number!
>>
>> and futher on #define MTK_SOC_MT7628 BIT(MTK_SOC_MT7628_BIT)
>
> Okay, thanks.
>
>> Based on this commit [0], MT7621 also needs the PDMA for the RX path.
>> I know that is not your issue but I think it is better to add a extra
>> capability bit for the PDMA bits so it can also be used on other socs.
>
> Yes, MT7621 also uses PDMA for RX. The code for RX is pretty much
> shared (re-used), with slight changes for the MT7628/88 to work
> correctly on this SoC.
>
> I'll work on a capability bit for PDMA vs QDMA on TX though. This
> might make things a little more transparent.

Great, Thanks for addressing this issue.

I hope we can collaborate to also support mt76x8 in my PHYLINK patches [0][1].
I am close to posting V2 of the patches but I am currently waiting on some
fiber modules to test the changes better.

Greats,

René

[0] https://patchwork.ozlabs.org/patch/1136551/
[1] https://patchwork.ozlabs.org/patch/1136519/

>
>> Greats,
>>
>> René
>>
>> [0] https://lkml.org/lkml/2018/3/14/1038
>
> Thanks,
> Stefan




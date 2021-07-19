Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D6963CF001
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 01:37:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1442629AbhGSW4B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Jul 2021 18:56:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1386464AbhGSUBU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Jul 2021 16:01:20 -0400
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF7E7C061574;
        Mon, 19 Jul 2021 13:39:14 -0700 (PDT)
Received: by mail-lf1-x136.google.com with SMTP id f30so32448101lfj.1;
        Mon, 19 Jul 2021 13:41:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:subject:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Srs9vIptNx9OCtPzB/isCkxq5qoyz6/HpDoXNg5nqSU=;
        b=Cjj6C4neDksnbRVzcj2j3UWb32Wx3ZvFimbrcflrmbJxjCDgw5UO5CUEdF6lWgyKow
         Nl2AKipWDStmZFieyoKaM7CYucH5LJtpnSoC6TR3nQasluGv+X1x3ug4lQCs/70Ge1Eq
         BOo4kTkyBQOlkuRo/R9fyaLHQzBaXbpz2/NNUThgyqdH5AOkSbCrC0hzrHjrKzGw1ajR
         lJ7r0/90D8qZj3dxV6C9dHppVhaYCSFf5xzl2sbZ2iLRFq/RmgvbLyhc9BRb+7lIwCYV
         Dn+z3W3huoBnbh7xQkr9YfW+uO6cEi6pPejXi9AXE6PIMsqBe21++wU8cXApzr1Wn/H5
         AytA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Srs9vIptNx9OCtPzB/isCkxq5qoyz6/HpDoXNg5nqSU=;
        b=sWVwcllwL+qH8wJjLDLZ7cxPJpkpC6JpHOy+wdnz5jLnCGOiX7L7uJ+qKTO6QQdfU4
         CigU/XsQUn9dlw0cyHngV5QKvI4MxifDF1w9Q5aaH6D3Xj5AJnQG52H3DWiT8QsyqURX
         FInAThbb0cuLYL+Y7TwgBbbMjPDShYBGQydNpSL0Jij9RV5bdjxGty9a/qYNSZTVwE7j
         WPRUT3AAq2VkXXypH3VAg6PxmpGq6wfrbnKW+P4DU881nJO0GGup96zshNnYy40Uwsh5
         k9djToxUJf7zvnS7Bb9ygb0Q6Sn1V2HT6vxGnT/uHLViGPjBtgnXAdbmBAMHXvvb6EX6
         0Xzw==
X-Gm-Message-State: AOAM533zoJnJ5uV3jLwsYsoJQr/tx627/p/Lo3dajlr9PJNXEfdjMoWx
        GgJgWufhEHtFBHTs9jj2dVc=
X-Google-Smtp-Source: ABdhPJwta0tnGOe4ZH3EzXXzE4jyVcl6A8LDDaSvN8U+8rclVwulPHy4TYBjIkKeGakVKvFAM9YPrw==
X-Received: by 2002:ac2:5e71:: with SMTP id a17mr18864152lfr.465.1626727308250;
        Mon, 19 Jul 2021 13:41:48 -0700 (PDT)
Received: from [192.168.1.102] ([178.176.75.152])
        by smtp.gmail.com with ESMTPSA id b14sm1375767lfb.149.2021.07.19.13.41.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Jul 2021 13:41:47 -0700 (PDT)
From:   Sergei Shtylyov <sergei.shtylyov@gmail.com>
Subject: Re: [PATCH/RFC 2/2] ravb: Add GbEthernet driver support
To:     Biju Das <biju.das.jz@bp.renesas.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Sergey Shtylyov <s.shtylyov@omprussia.ru>,
        Adam Ford <aford173@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Andrew Gabbasov <andrew_gabbasov@mentor.com>,
        Yuusuke Ashizuka <ashiduka@fujitsu.com>,
        netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>,
        Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>
References: <20210714145408.4382-1-biju.das.jz@bp.renesas.com>
 <20210714145408.4382-3-biju.das.jz@bp.renesas.com>
Message-ID: <1bb4d076-03cf-96d3-852c-a80aa38fa8e7@gmail.com>
Date:   Mon, 19 Jul 2021 23:41:45 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210714145408.4382-3-biju.das.jz@bp.renesas.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello!

On 7/14/21 5:54 PM, Biju Das wrote:

> Add Gigabit Ethernet driver support.
> 
> The Gigabit Etherner IP consists of Ethernet controller (E-MAC),
> Internal TCP/IP Offload Engine (TOE) and Dedicated Direct memory
> access controller (DMAC).
> 
> Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
> ---
>  drivers/net/ethernet/renesas/ravb.h      |  92 ++-
>  drivers/net/ethernet/renesas/ravb_main.c | 683 ++++++++++++++++++++---
>  2 files changed, 682 insertions(+), 93 deletions(-)
> 
> diff --git a/drivers/net/ethernet/renesas/ravb.h b/drivers/net/ethernet/renesas/ravb.h
> index 80e62ca2e3d3..4e65683fb458 100644
> --- a/drivers/net/ethernet/renesas/ravb.h
> +++ b/drivers/net/ethernet/renesas/ravb.h
[...]
> @@ -181,25 +183,39 @@ enum ravb_reg {
>  
>  	/* E-MAC registers */
>  	ECMR	= 0x0500,
> +	CXR20	= 0x0500,	/* Documented for RZ/G2L only */

   This is the same register as ECMR. Those cryptic CXR<n> names we first encountered in
the R-Car gen1 SoCs. :-)

>  	RFLR	= 0x0508,
> +	CXR2A	= 0x0508,	/* Documented for RZ/G2L only */

   Same comment -- no need to re-#define the macro.

[...]
> @@ -216,6 +232,7 @@ enum CCC_BIT {
>  	CCC_CSEL_HPB	= 0x00010000,
>  	CCC_CSEL_ETH_TX	= 0x00020000,
>  	CCC_CSEL_GMII_REF = 0x00030000,
> +	CCC_BOC		= 0x00100000,	/* Documented for RZ/G2L only */

   Hm, where do you use it? I'm not seeing...

[...]
> @@ -804,16 +821,21 @@ enum TID_BIT {
>  enum ECMR_BIT {
>  	ECMR_PRM	= 0x00000001,
>  	ECMR_DM		= 0x00000002,
> +	CXR20_LPM	= 0x00000010,	/* Documented for RZ/G2L only */

   Please use the ECMR_ prefix.

>  	ECMR_TE		= 0x00000020,
>  	ECMR_RE		= 0x00000040,
>  	ECMR_MPDE	= 0x00000200,
> +	CXR20_CER	= 0x00001000,	/* Documented for RZ/G2L only */

   Ditto.

>  	ECMR_TXF	= 0x00010000,	/* Documented for R-Car Gen3 only */
>  	ECMR_RXF	= 0x00020000,
>  	ECMR_PFR	= 0x00040000,
>  	ECMR_ZPF	= 0x00080000,	/* Documented for R-Car Gen3 only */
>  	ECMR_RZPF	= 0x00100000,
>  	ECMR_DPAD	= 0x00200000,
> +	CXR20_CXSER	= 0x00400000,	/* Documented for RZ/G2L only */

    Ditto.

>  	ECMR_RCSC	= 0x00800000,
> +	CXR20_TCPT	= 0x01000000,	/* Documented for RZ/G2L only */
> +	CXR20_RCPT	= 0x02000000,	/* Documented for RZ/G2L only */

   Ditto.

[...]
> @@ -823,6 +845,7 @@ enum ECSR_BIT {
>  	ECSR_MPD	= 0x00000002,
>  	ECSR_LCHNG	= 0x00000004,
>  	ECSR_PHYI	= 0x00000008,
> +	ECSR_RFRI	= 0x00000010,	/* Documented for RZ/G2L only */

   Not PFRI?
   Also, my R-Car gen2/3 manual dociment the bit.

[...]
> @@ -862,6 +885,14 @@ enum GECMR_BIT {
>  	GECMR_SPEED_1000 = 0x00000001,
>  };
>  
> +/* GECMR */
> +enum RGETH_GECMR_BIT {
> +	RGETH_GECMR_SPEED	= 0x00000030,
> +	RGETH_GECMR_SPEED_10	= 0x00000000,
> +	RGETH_GECMR_SPEED_100	= 0x00000010,
> +	RGETH_GECMR_SPEED_1000	= 0x00000020,

   Why not place those values in the existing GECMR *enum* with the necessary annotations?
Also I think the prefixes should be GETH, not RGETH -- RAVB is the EtherAVB driver's name, not
the actual hardware...

[...]
> @@ -956,8 +1035,11 @@ enum RAVB_QUEUE {
>  
>  #define RX_BUF_SZ	(2048 - ETH_FCS_LEN + sizeof(__sum16))
>  
> +#define RGETH_RCV_BUFF_MAX 8192
> +#define RGETH_RCV_DESCRIPTOR_DATA_SIZE 4080

   Please shorten DESCRIPTOR to DESC. And RCV_ should probably be renemed to R?..

[...]> @@ -1040,6 +1123,11 @@ struct ravb_private {
>  	unsigned txcidm:1;		/* TX Clock Internal Delay Mode */
>  	unsigned rgmii_override:1;	/* Deprecated rgmii-*id behavior */
>  	int num_tx_desc;		/* TX descriptors per packet */
> +
> +	int duplex;
> +	struct ravb_rx_desc *rgeth_rx_ring[NUM_RX_QUEUE];
> +	struct sk_buff *rxtop_skb;
> +	struct reset_control *rstc;

   I'd have apreciated some comments here... I don't quite understand what the first 3 are for...

[...]
> diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
> index 7e6feda59f4a..e28a63de553d 100644
> --- a/drivers/net/ethernet/renesas/ravb_main.c
> +++ b/drivers/net/ethernet/renesas/ravb_main.c
[...]
> @@ -82,6 +83,23 @@ static int ravb_config(struct net_device *ndev)
>  	return error;
>  }
>  
> +static void rgeth_set_rate(struct net_device *ndev)

   What about ravb_set_rate_rzgl? I think we use this convention in sh_eth.c...

[...]
> @@ -217,6 +235,29 @@ static int ravb_tx_free(struct net_device *ndev, int q, bool free_txed_only)
>  }
>  
>  /* Free skb's and DMA buffers for Ethernet AVB */
> +static void rgeth_ring_free_ex(struct net_device *ndev, int q)

   It definitely should be called ravb_rx_ring_free_rgeth(), I think...

> +{
> +	struct ravb_private *priv = netdev_priv(ndev);
> +	int ring_size;
> +	int i;
> +
> +	for (i = 0; i < priv->num_rx_ring[q]; i++) {
> +		struct ravb_rx_desc *desc = &priv->rgeth_rx_ring[q][i];
> +
> +		if (!dma_mapping_error(ndev->dev.parent,
> +				       le32_to_cpu(desc->dptr)))
> +			dma_unmap_single(ndev->dev.parent,
> +					 le32_to_cpu(desc->dptr),
> +					 RGETH_RCV_BUFF_MAX,
> +					 DMA_FROM_DEVICE);
> +	}
> +	ring_size = sizeof(struct ravb_rx_desc) *
> +		    (priv->num_rx_ring[q] + 1);
> +	dma_free_coherent(ndev->dev.parent, ring_size, priv->rgeth_rx_ring[q],
> +			  priv->rx_desc_dma[q]);
> +	priv->rgeth_rx_ring[q] = NULL;
> +}
> +
>  static void ravb_ring_free_ex(struct net_device *ndev, int q)
>  {
>  	struct ravb_private *priv = netdev_priv(ndev);
> @@ -247,8 +288,12 @@ static void ravb_ring_free(struct net_device *ndev, int q)
>  	int ring_size;
>  	int i;
>  
> -	if (priv->rx_ring[q]) {
> -		ravb_ring_free_ex(ndev, q);
> +	if (priv->chip_id == RZ_G2L) {
> +		if (priv->rgeth_rx_ring[q])
> +			rgeth_ring_free_ex(ndev, q);
> +	} else {
> +		if (priv->rx_ring[q])
> +			ravb_ring_free_ex(ndev, q);

   I definitely don't like that _ex suffix...

[...]
> @@ -281,6 +326,36 @@ static void ravb_ring_free(struct net_device *ndev, int q)
>  }
>  
>  /* Format skb and descriptor buffer for Ethernet AVB */
> +static void rgeth_ring_format_ex(struct net_device *ndev, int q)

    How about ravb_rx_ring_format_geth()?

> +{
> +	struct ravb_private *priv = netdev_priv(ndev);
> +	struct ravb_rx_desc *rx_desc;
> +	int rx_ring_size = sizeof(*rx_desc) * priv->num_rx_ring[q];
> +	dma_addr_t dma_addr;
> +	int i;
> +
> +	memset(priv->rgeth_rx_ring[q], 0, rx_ring_size);
> +	/* Build RX ring buffer */
> +	for (i = 0; i < priv->num_rx_ring[q]; i++) {
> +		/* RX descriptor */
> +		rx_desc = &priv->rgeth_rx_ring[q][i];
> +		rx_desc->ds_cc = cpu_to_le16(RGETH_RCV_DESCRIPTOR_DATA_SIZE);

    Mhm, I think we should further parametrize the RX data in order to save the code duplication...

> +		dma_addr = dma_map_single(ndev->dev.parent, priv->rx_skb[q][i]->data,
> +					  RGETH_RCV_BUFF_MAX,
> +					  DMA_FROM_DEVICE);
> +		/* We just set the data size to 0 for a failed mapping which
> +		 * should prevent DMA from happening...
> +		 */
> +		if (dma_mapping_error(ndev->dev.parent, dma_addr))
> +			rx_desc->ds_cc = cpu_to_le16(0);
> +		rx_desc->dptr = cpu_to_le32(dma_addr);
> +		rx_desc->die_dt = DT_FEMPTY;
> +	}
> +	rx_desc = &priv->rgeth_rx_ring[q][i];
> +	rx_desc->dptr = cpu_to_le32((u32)priv->rx_desc_dma[q]);
> +	rx_desc->die_dt = DT_LINKFIX; /* type */
> +}
> +
>  static void ravb_ring_format_ex(struct net_device *ndev, int q)
>  {
>  	struct ravb_private *priv = netdev_priv(ndev);
> @@ -326,7 +401,10 @@ static void ravb_ring_format(struct net_device *ndev, int q)
>  	priv->dirty_tx[q] = 0;
>  
>  	/* Build RX ring buffer */
> -	ravb_ring_format_ex(ndev, q);
> +	if (priv->chip_id == RZ_G2L)
> +		rgeth_ring_format_ex(ndev, q);
> +	else
> +		ravb_ring_format_ex(ndev, q);

   ... so that we don't have alike code snippets anymore...

[...]
> @@ -356,7 +434,7 @@ static void ravb_ring_format(struct net_device *ndev, int q)
>  static int ravb_ring_init(struct net_device *ndev, int q)
>  {
>  	struct ravb_private *priv = netdev_priv(ndev);
> -	size_t skb_sz = RX_BUF_SZ;
> +	size_t skb_sz = (priv->chip_id == RZ_G2L) ? RGETH_RCV_BUFF_MAX : RX_BUF_SZ;

    Should be also parametrized...

[...] 
> @@ -414,6 +503,45 @@ static int ravb_ring_init(struct net_device *ndev, int q)
>  }
>  
>  /* E-MAC init function */
> +static void rgeth_emac_init_ex(struct net_device *ndev)
> +{
> +	struct ravb_private *priv = netdev_priv(ndev);
> +
> +	/* Receive frame limit set register */
> +	ravb_write(ndev, RGETH_RCV_BUFF_MAX + ETH_FCS_LEN, RFLR);
> +
> +	/* PAUSE prohibition */
> +	ravb_write(ndev, ECMR_ZPF | (priv->duplex ? ECMR_DM : 0) |
> +			 ECMR_TE | ECMR_RE | CXR20_RCPT |
> +			 ECMR_TXF | ECMR_RXF | ECMR_PRM, ECMR);
> +
> +	rgeth_set_rate(ndev);
> +
> +	/* Set MAC address */
> +	ravb_write(ndev,
> +		   (ndev->dev_addr[0] << 24) | (ndev->dev_addr[1] << 16) |
> +		   (ndev->dev_addr[2] << 8)  | (ndev->dev_addr[3]), MAHR);
> +	ravb_write(ndev,
> +		   (ndev->dev_addr[4] << 8)  | (ndev->dev_addr[5]), MALR);
> +
> +	/* E-MAC status register clear */
> +	ravb_write(ndev, ECSR_ICD | ECSR_LCHNG | ECSR_RFRI, ECSR);
> +	ravb_write(ndev, CSR0_TPE | CSR0_RPE, CSR0);
> +
> +	/* E-MAC interrupt enable register */
> +	ravb_write(ndev, ECSIPR_ICDIP, ECSIPR);
> +
> +	ravb_write(ndev, ravb_read(ndev, CXR31)
> +			 & ~CXR31_SEL_LINK1, CXR31);
> +	if (priv->phy_interface == PHY_INTERFACE_MODE_RGMII_ID) {
> +		ravb_write(ndev, ravb_read(ndev, CXR31)
> +			 | CXR31_SEL_LINK0, CXR31);
> +	} else {
> +		ravb_write(ndev, ravb_read(ndev, CXR31)
> +			 & ~CXR31_SEL_LINK0, CXR31);
> +	}
> +}

   The more I look at your patches, the more I think Geert's suggestion to mimic the sh_eth's
approach to handling the SoC differencies is worth using in this driver as well...

[...]
> @@ -442,10 +570,41 @@ static void ravb_emac_init_ex(struct net_device *ndev)
[...]
>  /* Device init function for Ethernet AVB */
> +static void rgeth_dmac_init_ex(struct net_device *ndev)
> +{
> +	/* Set AVB RX */
> +	ravb_write(ndev, 0x60000000, RCR);

   What those (undocumented?) bits mean, I wonder?

[...]
> @@ -545,6 +708,23 @@ static void ravb_get_tx_tstamp(struct net_device *ndev)
>  	}
>  }
>  
> +static void rgeth_rx_csum(struct sk_buff *skb)
> +{
> +	u8 *hw_csum;
> +
> +	/* The hardware checksum is contained in sizeof(__sum16) (2) bytes
> +	 * appended to packet data
> +	 */
> +	if (unlikely(skb->len < sizeof(__sum16)))
> +		return;
> +	hw_csum = skb_tail_pointer(skb) - sizeof(__sum16);
> +
> +	if (*hw_csum == 0)
> +		skb->ip_summed = CHECKSUM_UNNECESSARY;
> +	else
> +		skb->ip_summed = CHECKSUM_NONE;
> +}

   So does GbEth device sumpport checksuming or not?

[...]
> @@ -561,6 +741,143 @@ static void ravb_rx_csum(struct sk_buff *skb)
>  }
>  
>  /* Packet receive function for Ethernet AVB */
> +struct sk_buff *rgeth_get_skb(struct net_device *ndev, int q, int entry,

   Not *static*?

> +			      struct ravb_rx_desc *desc)
> +{
> +	struct ravb_private *priv = netdev_priv(ndev);
> +	struct sk_buff *skb;
> +
> +	skb = priv->rx_skb[q][entry];
> +	priv->rx_skb[q][entry] = NULL;
> +	dma_unmap_single(ndev->dev.parent, le32_to_cpu(desc->dptr),
> +			 ALIGN(RGETH_RCV_BUFF_MAX, 16), DMA_FROM_DEVICE);
> +
> +	return skb;
> +}
> +
> +static bool rgeth_rx_ex(struct net_device *ndev, int *quota, int q)
> +{
> +	struct ravb_private *priv = netdev_priv(ndev);
> +	int entry = priv->cur_rx[q] % priv->num_rx_ring[q];
> +	int boguscnt = priv->dirty_rx[q] + priv->num_rx_ring[q] - priv->cur_rx[q];
> +	struct net_device_stats *stats = &priv->stats[q];
> +	struct ravb_rx_desc *desc;
> +	struct sk_buff *skb;
> +	dma_addr_t dma_addr;
> +	u8  desc_status;
> +	u8  die_dt;
> +	u16 pkt_len;
> +	int limit;
> +
> +	boguscnt = min(boguscnt, *quota);
> +	limit = boguscnt;
> +	desc = &priv->rgeth_rx_ring[q][entry];
> +	while (desc->die_dt != DT_FEMPTY) {
> +		/* Descriptor type must be checked before all other reads */
> +		dma_rmb();
> +		desc_status = desc->msc;
> +		pkt_len = le16_to_cpu(desc->ds_cc) & RX_DS;
> +
> +		if (--boguscnt < 0)
> +			break;
> +
> +		/* We use 0-byte descriptors to mark the DMA mapping errors */
> +		if (!pkt_len)
> +			continue;
> +
> +		if (desc_status & MSC_MC)
> +			stats->multicast++;
> +
> +		if (desc_status & (MSC_CRC | MSC_RFE | MSC_RTSF | MSC_RTLF | MSC_CEEF)) {
> +			stats->rx_errors++;
> +			if (desc_status & MSC_CRC)
> +				stats->rx_crc_errors++;
> +			if (desc_status & MSC_RFE)
> +				stats->rx_frame_errors++;
> +			if (desc_status & (MSC_RTLF | MSC_RTSF))
> +				stats->rx_length_errors++;
> +			if (desc_status & MSC_CEEF)
> +				stats->rx_missed_errors++;
> +		} else {
> +			die_dt = desc->die_dt & 0xF0;
> +			if (die_dt == DT_FSINGLE) {

   Why not *switch*?

> +				skb = rgeth_get_skb(ndev, q, entry, desc);
> +				skb_put(skb, pkt_len);
> +				skb->protocol = eth_type_trans(skb, ndev);
> +				if (ndev->features & NETIF_F_RXCSUM)
> +					rgeth_rx_csum(skb);
> +				napi_gro_receive(&priv->napi[q], skb);
> +				stats->rx_packets++;
> +				stats->rx_bytes += pkt_len;
> +			} else if (die_dt == DT_FSTART) {
> +				priv->rxtop_skb = rgeth_get_skb(ndev, q, entry, desc);
> +				skb_put(priv->rxtop_skb, pkt_len);
> +			} else if (die_dt == DT_FMID) {
> +				skb = rgeth_get_skb(ndev, q, entry, desc);
> +				skb_copy_to_linear_data_offset(priv->rxtop_skb,
> +							       priv->rxtop_skb->len,
> +							       skb->data,
> +							       pkt_len);
> +				skb_put(priv->rxtop_skb, pkt_len);
> +				dev_kfree_skb(skb);
> +			} else if (die_dt == DT_FEND) {
> +				skb = rgeth_get_skb(ndev, q, entry, desc);
> +				skb_copy_to_linear_data_offset(priv->rxtop_skb,
> +							       priv->rxtop_skb->len,
> +							       skb->data,
> +							       pkt_len);
> +				skb_put(priv->rxtop_skb, pkt_len);
> +				dev_kfree_skb(skb);
> +				priv->rxtop_skb->protocol =
> +					eth_type_trans(priv->rxtop_skb, ndev);
> +				if (ndev->features & NETIF_F_RXCSUM)
> +					rgeth_rx_csum(skb);
> +				napi_gro_receive(&priv->napi[q],
> +						 priv->rxtop_skb);
> +				stats->rx_packets++;
> +				stats->rx_bytes += priv->rxtop_skb->len;
> +			}

   So why it's necessary to handle the multidecriptor packets?

[...]
> @@ -678,7 +995,10 @@ static bool ravb_rx_ex(struct net_device *ndev, int *quota, int q)
>  
>  static bool ravb_rx(struct net_device *ndev, int *quota, int q)
>  {
> -	return ravb_rx_ex(ndev, quota, q);
> +	struct ravb_private *priv = netdev_priv(ndev);
> +
> +	return (priv->chip_id == RZ_G2L) ?
> +		rgeth_rx_ex(ndev, quota, q) : ravb_rx_ex(ndev, quota, q);

   Definitely better with the pre-init'ed function pointers if needed at all)...

[...]
> @@ -696,11 +1016,15 @@ static void ravb_rcv_snd_enable(struct net_device *ndev)
>  /* function for waiting dma process finished */
>  static int ravb_stop_dma(struct net_device *ndev)
>  {
> +	struct ravb_private *priv = netdev_priv(ndev);
>  	int error;
>  
>  	/* Wait for stopping the hardware TX process */
> -	error = ravb_wait(ndev, TCCR,
> -			  TCCR_TSRQ0 | TCCR_TSRQ1 | TCCR_TSRQ2 | TCCR_TSRQ3, 0);
> +	if (priv->chip_id == RZ_G2L)
> +		error = ravb_wait(ndev, TCCR, TCCR_TSRQ0, 0);

   Only a single TX queue?

> +	else
> +		error = ravb_wait(ndev, TCCR,
> +				  TCCR_TSRQ0 | TCCR_TSRQ1 | TCCR_TSRQ2 | TCCR_TSRQ3, 0);

   This is better expressed thru a mask in the private data...

[...]
> @@ -823,11 +1147,13 @@ static bool ravb_queue_interrupt(struct net_device *ndev, int q)
>  
>  static bool ravb_timestamp_interrupt(struct net_device *ndev)
>  {
> +	struct ravb_private *priv = netdev_priv(ndev);
>  	u32 tis = ravb_read(ndev, TIS);
>  
>  	if (tis & TIS_TFUF) {
>  		ravb_write(ndev, ~(TIS_TFUF | TIS_RESERVED), TIS);
> -		ravb_get_tx_tstamp(ndev);
> +		if (priv->chip_id != RZ_G2L)
> +			ravb_get_tx_tstamp(ndev);

   So, no TX pakcet timestaming?..

[...]
> @@ -872,7 +1198,7 @@ static irqreturn_t ravb_interrupt(int irq, void *dev_id)
>  	}
>  
>  	/* gPTP interrupt status summary */
> -	if (iss & ISS_CGIS) {
> +	if (priv->chip_id != RZ_G2L && (iss & ISS_CGIS)) {

   ...and no gPTP IRQ?

>  		ravb_ptp_interrupt(ndev);
>  		result = IRQ_HANDLED;
>  	}
> @@ -947,12 +1273,20 @@ static int ravb_poll(struct napi_struct *napi, int budget)
>  	int q = napi - priv->napi;
>  	int mask = BIT(q);
>  	int quota = budget;
> +	int entry;
> +	struct ravb_rx_desc *desc;

   The lines with the local variables should be sotrted by length, the longer going first
(so caleld reverse Xmas tree)...

[...]
> @@ -1082,15 +1440,23 @@ static int ravb_phy_init(struct net_device *ndev)
>  		netdev_info(ndev, "limited PHY to 100Mbit/s\n");
>  	}
>  
> -	/* 10BASE, Pause and Asym Pause is not supported */
> -	phy_remove_link_mode(phydev, ETHTOOL_LINK_MODE_10baseT_Half_BIT);
> -	phy_remove_link_mode(phydev, ETHTOOL_LINK_MODE_10baseT_Full_BIT);
> -	phy_remove_link_mode(phydev, ETHTOOL_LINK_MODE_Pause_BIT);
> -	phy_remove_link_mode(phydev, ETHTOOL_LINK_MODE_Asym_Pause_BIT);
> +	if (priv->chip_id == RZ_G2L) {

  Why not *switch*?

cxr35> +		if (priv->phy_interface == PHY_INTERFACE_MODE_RGMII_ID)
> +			ravb_write(ndev, ravb_read(ndev, CXR35) | CXR35_SEL_MODIN, CXR35);
> +		else if (priv->phy_interface == PHY_INTERFACE_MODE_RGMII)
> +			ravb_write(ndev, 0x3E80000, CXR35);
> +	} else {
>  
[...]
> @@ -1133,6 +1499,24 @@ static void ravb_set_msglevel(struct net_device *ndev, u32 value)
>  	priv->msg_enable = value;
>  }
>  
> +static const char rgeth_gstrings_stats[][ETH_GSTRING_LEN] = {
> +	"rx_queue_0_current",
> +	"tx_queue_0_current",
> +	"rx_queue_0_dirty",
> +	"tx_queue_0_dirty",
> +	"rx_queue_0_packets",
> +	"tx_queue_0_packets",
> +	"rx_queue_0_bytes",
> +	"tx_queue_0_bytes",
> +	"rx_queue_0_mcast_packets",
> +	"rx_queue_0_errors",
> +	"rx_queue_0_crc_errors",
> +	"rx_queue_0_frame_errors",
> +	"rx_queue_0_length_errors",
> +	"rx_queue_0_csum_offload_errors",
> +	"rx_queue_0_over_errors",
> +};

   I think we can get out without duplicating the stgring arrays...

[...]
> @@ -1669,6 +2079,20 @@ static struct net_device_stats *ravb_get_stats(struct net_device *ndev)
>  	stats0 = &priv->stats[RAVB_BE];
>  	stats1 = &priv->stats[RAVB_NC];
>  
> +	if (priv->chip_id == RZ_G2L) {
> +		nstats->tx_dropped += ravb_read(ndev, TROCR);
> +		ravb_write(ndev, 0, TROCR);	/* (write clear) */

   Why duplicated with R-Car gen3?

> +		nstats->collisions += ravb_read(ndev, CDCR);
> +		ravb_write(ndev, 0, CDCR);	/* (write clear) */
> +		nstats->tx_carrier_errors += ravb_read(ndev, LCCR);
> +		ravb_write(ndev, 0, LCCR);	/* (write clear) */
> +
> +		nstats->tx_carrier_errors += ravb_read(ndev, CERCR);
> +		ravb_write(ndev, 0, CERCR);	/* (write clear) */
> +		nstats->tx_carrier_errors += ravb_read(ndev, CEECR);
> +		ravb_write(ndev, 0, CEECR);	/* (write clear) */
> +	}
> +
>  	if (priv->chip_id == RCAR_GEN3) {

   Must be else if here...

[...]
> @@ -1899,6 +2325,44 @@ static int ravb_set_features(struct net_device *ndev,
>  	return 0;
>  }
>  
> +static int rgeth_set_features(struct net_device *ndev,
> +			      netdev_features_t features)
> +{
> +	int error;
> +	unsigned int reg = 0;
> +	netdev_features_t changed = features ^ ndev->features;

   Reverse Xmas tree, please.

> +
> +	reg = ravb_read(ndev, CSR0);
> +
> +	ravb_write(ndev, ravb_read(ndev, CSR0) & ~(CSR0_RPE | CSR0_TPE), CSR0);

   Why read CSR0 twice?

[...]
> @@ -1930,7 +2408,10 @@ static int ravb_mdio_init(struct ravb_private *priv)
>  		return -ENOMEM;
>  
>  	/* Hook up MII support for ethtool */
> -	priv->mii_bus->name = "ravb_mii";
> +	if (priv->chip_id == RZ_G2L)
> +		priv->mii_bus->name = "rgeth_mii";
> +	else
> +		priv->mii_bus->name = "ravb_mii";

   Hm... I don't think we need this.

[...]
> @@ -1965,6 +2446,7 @@ static const struct of_device_id ravb_match_table[] = {
>  	{ .compatible = "renesas,etheravb-rcar-gen2", .data = (void *)RCAR_GEN2 },
>  	{ .compatible = "renesas,etheravb-r8a7795", .data = (void *)RCAR_GEN3 },
>  	{ .compatible = "renesas,etheravb-rcar-gen3", .data = (void *)RCAR_GEN3 },
> +	{ .compatible = "renesas,rzg2l-gether", .data = (void *)RZ_G2L },

   Mhm, we reserve the right to call the hardware "gether" to the to the rdriver...
Would  the "renesas,rzg2l-gbeth" string fit?

[...]
> @@ -2082,20 +2565,11 @@ static int ravb_probe(struct platform_device *pdev)
>  		return -EINVAL;
>  	}
>  
> -	/* Get base address */
> -	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> -	if (!res) {
> -		dev_err(&pdev->dev, "invalid resource\n");
> -		return -EINVAL;
> -	}
> -
>  	ndev = alloc_etherdev_mqs(sizeof(struct ravb_private),
>  				  NUM_TX_QUEUE, NUM_RX_QUEUE);
>  	if (!ndev)
>  		return -ENOMEM;
>  
> -	/* The Ether-specific entries in the device structure. */
> -	ndev->base_addr = res->start;
>  
>  	chip_id = (enum ravb_chip_id)of_device_get_match_data(&pdev->dev);
>  
> @@ -2104,11 +2578,19 @@ static int ravb_probe(struct platform_device *pdev)
>  	priv = netdev_priv(ndev);
>  	priv->chip_id = chip_id;
>  
> -	ndev->features = NETIF_F_RXCSUM;
> -	ndev->hw_features = NETIF_F_RXCSUM;
> -
> -	pm_runtime_enable(&pdev->dev);
> -	pm_runtime_get_sync(&pdev->dev);
> +	if (chip_id == RZ_G2L) {
> +		ndev->hw_features |= (NETIF_F_HW_CSUM | NETIF_F_RXCSUM);
> +		priv->rstc = devm_reset_control_get(&pdev->dev, NULL);
> +		if (IS_ERR(priv->rstc)) {
> +			dev_err(&pdev->dev, "failed to get cpg reset\n");
> +			free_netdev(ndev);
> +			return PTR_ERR(priv->rstc);
> +		}
> +		reset_control_deassert(priv->rstc);

   This asks for the serpate patch.

[...]
> @@ -2120,18 +2602,24 @@ static int ravb_probe(struct platform_device *pdev)
>  	}
>  	ndev->irq = irq;
>  
> +	pm_runtime_enable(&pdev->dev);
> +	pm_runtime_get_sync(&pdev->dev);
> +
>  	priv->ndev = ndev;
>  	priv->pdev = pdev;
>  	priv->num_tx_ring[RAVB_BE] = BE_TX_RING_SIZE;
>  	priv->num_rx_ring[RAVB_BE] = BE_RX_RING_SIZE;
>  	priv->num_tx_ring[RAVB_NC] = NC_TX_RING_SIZE;
>  	priv->num_rx_ring[RAVB_NC] = NC_RX_RING_SIZE;
> -	priv->addr = devm_ioremap_resource(&pdev->dev, res);
> +	priv->addr = devm_platform_get_and_ioremap_resource(pdev, 0, &res);

   Separate patch, please.

[...]
> @@ -2181,30 +2671,39 @@ static int ravb_probe(struct platform_device *pdev)
[...]
>  	/* Set AVB config mode */
>  	ravb_set_config_mode(ndev);
>  
> -	/* Set GTI value */
> -	error = ravb_set_gti(ndev);
> -	if (error)
> -		goto out_disable_refclk;
> +	if (priv->chip_id != RZ_G2L) {
> +		/* Set GTI value */
> +		error = ravb_set_gti(ndev);
> +		if (error)
> +			goto out_disable_refclk;
>  
> -	/* Request GTI loading */
> -	ravb_modify(ndev, GCCR, GCCR_LTI, GCCR_LTI);
> +		/* Request GTI loading */
> +		ravb_modify(ndev, GCCR, GCCR_LTI, GCCR_LTI);
>  
> -	if (priv->chip_id == RCAR_GEN3) {
> -		ravb_parse_delay_mode(np, ndev);
> -		ravb_set_delay_mode(ndev);
> +		if (priv->chip_id == RCAR_GEN3) {
> +			ravb_parse_delay_mode(np, ndev);
> +			ravb_set_delay_mode(ndev);
> +		}
>  	}

   Ugh... needs to be untagled too.

   Went thru the large patch at last! If you need help addressing comments,
I can probably make the driver patches using data parametrization vs chip_id.

[...]

MBR, Sergei

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8908368A65D
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 23:55:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232866AbjBCWzf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 17:55:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232580AbjBCWze (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 17:55:34 -0500
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D27C11EBCC;
        Fri,  3 Feb 2023 14:55:31 -0800 (PST)
Received: by mail-wm1-x332.google.com with SMTP id n28-20020a05600c3b9c00b003ddca7a2bcbso4963182wms.3;
        Fri, 03 Feb 2023 14:55:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=YDuMqP7XDSUZ3yofb4uO/pMM7Aq3DbQpUK7pMF007rQ=;
        b=Y5Jg8jGVfS3iYO53ot5YQz6YoZiPTkYhZApO9M3g8PG1jRzNKDbT/Md5pEPVgjALJ1
         4WSJwxBIxQfE82qYkqK9alJ2jmcG9Jl/e2uNeBs33NApqNDljl/wPxNvDosW+5motiou
         l2WkudxLcE4HBB9ztQrfG49NoahXlQbSk1tP9JUiZvvIV7Fbp9Ri5HLykilmy75IdFHJ
         zQ/8yfCtmuo3ro+Ia5u/wdaeDYk//BNuZ6j12YZexVJ/SKLJt+NSdKqPv5VREgp8R2eC
         OJa3ZDqrLgtBgCGgp0s92/oUoEp2RdVOEBndh4nIQpeOvFaGhevduUOCsCW0ihUO+hNd
         5jqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YDuMqP7XDSUZ3yofb4uO/pMM7Aq3DbQpUK7pMF007rQ=;
        b=HFnFWgskrRCDWSjkUPuRyUS2fwqPcoMr17SRarImNqjYnj9Nbb+Ium7QcIgTD1fV3x
         HgrdT0svdZNosqZRBVxudnsseK66+X1AUgkgFSkrkV2Qx77D9Tz2Aa5NqX/dJYMQnw9s
         HAlzFTYrfXIqgvGLIP1LjhjBKD+NLg+hTmStS6Fwb188Rk4ng4KFysk9rTPw4k3URc7t
         BceQ8ytqyvTCZV4/hBMAJq+yTiQxkbaYadFW5/CcyJ+lNdTiPuE+GKFKRqU/nlVOWO1u
         xsTsGaHKprsBlyvv1TzWIiEsn2zPyAVJGslEVRoVBryupWhUPAyIB/5AXv8wPOrvUswh
         Bcmg==
X-Gm-Message-State: AO0yUKXn3zxQMlId4yOoL40ABEUBjbQ74E6ttcxDGffvpXbsXONXeY/l
        rY7+UPX4uDaKGeMwNQ3FJKg=
X-Google-Smtp-Source: AK7set8stzNwpYl+F12xbFRrMaXYUnJzMWJk35x/p6xaTD2Hy3inuDAu4wZUMNQ2iS08NfkQvoBI0w==
X-Received: by 2002:a7b:c8c6:0:b0:3dc:4296:6d56 with SMTP id f6-20020a7bc8c6000000b003dc42966d56mr5450237wml.30.1675464930210;
        Fri, 03 Feb 2023 14:55:30 -0800 (PST)
Received: from skbuf ([188.26.57.116])
        by smtp.gmail.com with ESMTPSA id m40-20020a05600c3b2800b003dcc82ce53fsm4282505wms.38.2023.02.03.14.55.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Feb 2023 14:55:29 -0800 (PST)
Date:   Sat, 4 Feb 2023 00:55:27 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Daniel Golle <daniel@makrotopia.org>
Cc:     netdev@vger.kernel.org, linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        John Crispin <john@phrozen.org>, Felix Fietkau <nbd@nbd.name>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Jianhui Zhao <zhaojh329@gmail.com>,
        =?utf-8?B?QmrDuHJu?= Mork <bjorn@mork.no>
Subject: Re: [PATCH 6/9] net: ethernet: mtk_eth_soc: ppe: add support for
 flow accounting
Message-ID: <20230203225527.e3uyysmxmd463ani@skbuf>
References: <cover.1675407169.git.daniel@makrotopia.org>
 <cover.1675407169.git.daniel@makrotopia.org>
 <7ce673e90b72e1a19b7657bebc2ca8d1ea596f96.1675407169.git.daniel@makrotopia.org>
 <7ce673e90b72e1a19b7657bebc2ca8d1ea596f96.1675407169.git.daniel@makrotopia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7ce673e90b72e1a19b7657bebc2ca8d1ea596f96.1675407169.git.daniel@makrotopia.org>
 <7ce673e90b72e1a19b7657bebc2ca8d1ea596f96.1675407169.git.daniel@makrotopia.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 03, 2023 at 07:05:08AM +0000, Daniel Golle wrote:
> The PPE units found in MT7622 and newer support packet and byte
> accounting of hw-offloaded flows. Add support for reading those counters
> as found in MediaTek's SDK[1], make them accessible via debugfs and add
> them to the flow offload stats.
> 
> [1]: https://git01.mediatek.com/plugins/gitiles/openwrt/feeds/mtk-openwrt-feeds/+/bc6a6a375c800dc2b80e1a325a2c732d1737df92
> Signed-off-by: Daniel Golle <daniel@makrotopia.org>
> ---
>  drivers/net/ethernet/mediatek/mtk_eth_soc.c   |   8 +-
>  drivers/net/ethernet/mediatek/mtk_eth_soc.h   |   1 +
>  drivers/net/ethernet/mediatek/mtk_ppe.c       | 110 +++++++++++++++++-
>  drivers/net/ethernet/mediatek/mtk_ppe.h       |  24 +++-
>  .../net/ethernet/mediatek/mtk_ppe_debugfs.c   |   9 +-
>  .../net/ethernet/mediatek/mtk_ppe_offload.c   |   7 ++
>  drivers/net/ethernet/mediatek/mtk_ppe_regs.h  |  14 +++
>  7 files changed, 168 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
> index f09cd6a132c9..d50dea1f20f3 100644
> --- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
> +++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
> @@ -4708,7 +4708,9 @@ static int mtk_probe(struct platform_device *pdev)
>  			u32 ppe_addr = eth->soc->reg_map->ppe_base + i * 0x400;
>  
>  			eth->ppe[i] = mtk_ppe_init(eth, eth->base + ppe_addr,
> -						   eth->soc->offload_version, i);
> +						   eth->soc->offload_version, i,
> +						   eth->soc->has_accounting);

All arguments mtk_ppe_init() needs (this includes eth->soc->offload_version)
are already available to it. See, first line in mtk_ppe_init() is:

	const struct mtk_soc_data *soc = eth->soc;

> +
>  			if (!eth->ppe[i]) {
>  				err = -ENOMEM;
>  				goto err_deinit_ppe;
> diff --git a/drivers/net/ethernet/mediatek/mtk_ppe.c b/drivers/net/ethernet/mediatek/mtk_ppe.c
> index 6883eb34cd8b..26fa89afc69a 100644
> --- a/drivers/net/ethernet/mediatek/mtk_ppe.c
> +++ b/drivers/net/ethernet/mediatek/mtk_ppe.c
> @@ -74,6 +74,46 @@ static int mtk_ppe_wait_busy(struct mtk_ppe *ppe)
>  	return ret;
>  }
>  
> +static int mtk_ppe_mib_wait_busy(struct mtk_ppe *ppe)
> +{
> +	int ret;
> +	u32 val;
> +
> +	ret = readl_poll_timeout(ppe->base + MTK_PPE_MIB_SER_CR, val,
> +				 !(val & MTK_PPE_MIB_SER_CR_ST),
> +				 20, MTK_PPE_WAIT_TIMEOUT_US);
> +
> +	if (ret)
> +		dev_err(ppe->dev, "MIB table busy");
> +
> +	return ret;
> +}
> +
> +static int mtk_mib_entry_read(struct mtk_ppe *ppe, u16 index, u64 *bytes, u64 *packets)
> +{
> +	u32 val, cnt_r0, cnt_r1, cnt_r2;
> +	u32 byte_cnt_low, byte_cnt_high, pkt_cnt_low, pkt_cnt_high;
> +
> +	val = FIELD_PREP(MTK_PPE_MIB_SER_CR_ADDR, index) | MTK_PPE_MIB_SER_CR_ST;
> +	ppe_w32(ppe, MTK_PPE_MIB_SER_CR, val);
> +
> +	if (mtk_ppe_mib_wait_busy(ppe))
> +		return -ETIMEDOUT;

err = mtk_ppe_mib_wait_busy();
if (err)
	return err;

> +
> +	cnt_r0 = readl(ppe->base + MTK_PPE_MIB_SER_R0);
> +	cnt_r1 = readl(ppe->base + MTK_PPE_MIB_SER_R1);
> +	cnt_r2 = readl(ppe->base + MTK_PPE_MIB_SER_R2);
> +
> +	byte_cnt_low = FIELD_GET(MTK_PPE_MIB_SER_R0_BYTE_CNT_LOW, cnt_r0);
> +	byte_cnt_high = FIELD_GET(MTK_PPE_MIB_SER_R1_BYTE_CNT_HIGH, cnt_r1);
> +	pkt_cnt_low = FIELD_GET(MTK_PPE_MIB_SER_R1_PKT_CNT_LOW, cnt_r1);
> +	pkt_cnt_high = FIELD_GET(MTK_PPE_MIB_SER_R2_PKT_CNT_HIGH, cnt_r2);
> +	*bytes = ((u64)byte_cnt_high << 32) | byte_cnt_low;
> +	*packets = (pkt_cnt_high << 16) | pkt_cnt_low;
> +
> +	return 0;
> +}
> +
>  static void mtk_ppe_cache_clear(struct mtk_ppe *ppe)
>  {
>  	ppe_set(ppe, MTK_PPE_CACHE_CTL, MTK_PPE_CACHE_CTL_CLEAR);
>  struct mtk_ppe *mtk_ppe_init(struct mtk_eth *eth, void __iomem *base,
> -			     int version, int index)
> +			     int version, int index, bool accounting)
>  {
>  	const struct mtk_soc_data *soc = eth->soc;
>  	struct device *dev = eth->dev;
>  	struct mtk_ppe *ppe;
>  	u32 foe_flow_size;
>  	void *foe;
> +	struct mtk_mib_entry *mib;
> +	struct mtk_foe_accounting *acct;
>  
>  	ppe = devm_kzalloc(dev, sizeof(*ppe), GFP_KERNEL);
>  	if (!ppe)
> @@ -778,6 +856,7 @@ struct mtk_ppe *mtk_ppe_init(struct mtk_eth *eth, void __iomem *base,
>  	ppe->eth = eth;
>  	ppe->dev = dev;
>  	ppe->version = version;
> +	ppe->accounting = accounting;
>  
>  	foe = dmam_alloc_coherent(ppe->dev,
>  				  MTK_PPE_ENTRIES * soc->foe_entry_size,
> @@ -793,6 +872,25 @@ struct mtk_ppe *mtk_ppe_init(struct mtk_eth *eth, void __iomem *base,
>  	if (!ppe->foe_flow)
>  		goto err_free_l2_flows;
>  
> +	if (accounting) {
> +		mib = dmam_alloc_coherent(ppe->dev, MTK_PPE_ENTRIES * sizeof(*mib),
> +					  &ppe->mib_phys, GFP_KERNEL);
> +		if (!mib)
> +			return NULL;
> +
> +		memset(mib, 0, MTK_PPE_ENTRIES * sizeof(*mib));

I remember Jakub pointing out in another email that consistent DMA
memory is already zero-initialized, and it appears in
scripts/coccinelle/api/alloc/zalloc-simple.cocci.

> +
> +		ppe->mib_table = mib;
> +
> +		acct = devm_kzalloc(dev, MTK_PPE_ENTRIES * sizeof(*acct),
> +				    GFP_KERNEL);
> +
> +		if (!acct)
> +			return NULL;
> +
> +		ppe->acct_table = acct;
> +	}
> +
>  	mtk_ppe_debugfs_init(ppe, index);
>  
>  	return ppe;
> @@ -922,6 +1020,16 @@ void mtk_ppe_start(struct mtk_ppe *ppe)
>  		ppe_w32(ppe, MTK_PPE_DEFAULT_CPU_PORT1, 0xcb777);
>  		ppe_w32(ppe, MTK_PPE_SBW_CTRL, 0x7f);
>  	}
> +
> +	if (ppe->accounting && ppe->mib_phys) {
> +		ppe_w32(ppe, MTK_PPE_MIB_TB_BASE, ppe->mib_phys);
> +		ppe_m32(ppe, MTK_PPE_MIB_CFG, MTK_PPE_MIB_CFG_EN,
> +			MTK_PPE_MIB_CFG_EN);
> +		ppe_m32(ppe, MTK_PPE_MIB_CFG, MTK_PPE_MIB_CFG_RD_CLR,
> +			MTK_PPE_MIB_CFG_RD_CLR);
> +		ppe_m32(ppe, MTK_PPE_MIB_CACHE_CTL, MTK_PPE_MIB_CACHE_CTL_EN,
> +			MTK_PPE_MIB_CFG_RD_CLR);
> +	}
>  }
>  
>  int mtk_ppe_stop(struct mtk_ppe *ppe)
> diff --git a/drivers/net/ethernet/mediatek/mtk_ppe_debugfs.c b/drivers/net/ethernet/mediatek/mtk_ppe_debugfs.c
> index 391b071bcff3..39775740340b 100644
> --- a/drivers/net/ethernet/mediatek/mtk_ppe_debugfs.c
> +++ b/drivers/net/ethernet/mediatek/mtk_ppe_debugfs.c
> @@ -82,6 +82,7 @@ mtk_ppe_debugfs_foe_show(struct seq_file *m, void *private, bool bind)
>  		struct mtk_foe_entry *entry = mtk_foe_get_entry(ppe, i);
>  		struct mtk_foe_mac_info *l2;
>  		struct mtk_flow_addr_info ai = {};
> +		struct mtk_foe_accounting *acct;
>  		unsigned char h_source[ETH_ALEN];
>  		unsigned char h_dest[ETH_ALEN];
>  		int type, state;
> @@ -95,6 +96,8 @@ mtk_ppe_debugfs_foe_show(struct seq_file *m, void *private, bool bind)
>  		if (bind && state != MTK_FOE_STATE_BIND)
>  			continue;
>  
> +		acct = mtk_foe_entry_get_mib(ppe, i, NULL);

might return NULL

> +
>  		type = FIELD_GET(MTK_FOE_IB1_PACKET_TYPE, entry->ib1);
>  		seq_printf(m, "%05x %s %7s", i,
>  			   mtk_foe_entry_state_str(state),
> @@ -153,9 +156,11 @@ mtk_ppe_debugfs_foe_show(struct seq_file *m, void *private, bool bind)
>  		*((__be16 *)&h_dest[4]) = htons(l2->dest_mac_lo);
>  
>  		seq_printf(m, " eth=%pM->%pM etype=%04x"
> -			      " vlan=%d,%d ib1=%08x ib2=%08x\n",
> +			      " vlan=%d,%d ib1=%08x ib2=%08x"
> +			      " packets=%lld bytes=%lld\n",

%llu

>  			   h_source, h_dest, ntohs(l2->etype),
> -			   l2->vlan1, l2->vlan2, entry->ib1, ib2);
> +			   l2->vlan1, l2->vlan2, entry->ib1, ib2,
> +			   acct->packets, acct->bytes);
>  	}
>  
>  	return 0;
> diff --git a/drivers/net/ethernet/mediatek/mtk_ppe_offload.c b/drivers/net/ethernet/mediatek/mtk_ppe_offload.c
> index 81afd5ee3fbf..832e11ad9a16 100644
> --- a/drivers/net/ethernet/mediatek/mtk_ppe_offload.c
> +++ b/drivers/net/ethernet/mediatek/mtk_ppe_offload.c
> @@ -497,6 +497,7 @@ static int
>  mtk_flow_offload_stats(struct mtk_eth *eth, struct flow_cls_offload *f)
>  {
>  	struct mtk_flow_entry *entry;
> +	struct mtk_foe_accounting diff;
>  	u32 idle;
>  
>  	entry = rhashtable_lookup(&eth->flow_table, &f->cookie,
> @@ -507,6 +508,12 @@ mtk_flow_offload_stats(struct mtk_eth *eth, struct flow_cls_offload *f)
>  	idle = mtk_foe_entry_idle_time(eth->ppe[entry->ppe_index], entry);
>  	f->stats.lastused = jiffies - idle * HZ;
>  
> +	if (entry->hash != 0xFFFF) {
> +		mtk_foe_entry_get_mib(eth->ppe[entry->ppe_index], entry->hash, &diff);

If this returns NULL, you don't want to add diff.packets and diff.bytes
to f->stats, because no one bothers to initialize "diff" to all-zeroes.
So it contains junk from kernel stack memory. You might want to avoid this.

> +		f->stats.pkts += diff.packets;
> +		f->stats.bytes += diff.bytes;
> +	}
> +
>  	return 0;
>  }
>  

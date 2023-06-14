Return-Path: <netdev+bounces-10897-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D9DF730AC9
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 00:33:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 313131C20DCB
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 22:33:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8BBBE13ADE;
	Wed, 14 Jun 2023 22:31:06 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 790C4261DA
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 22:31:06 +0000 (UTC)
Received: from mail-qt1-x834.google.com (mail-qt1-x834.google.com [IPv6:2607:f8b0:4864:20::834])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BF19294A
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 15:30:50 -0700 (PDT)
Received: by mail-qt1-x834.google.com with SMTP id d75a77b69052e-3f9c7665317so24260771cf.3
        for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 15:30:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1686781849; x=1689373849;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=dKd1XFIVGPOZA4qvGS585JsImLUJNE7z0dQLfRUwg58=;
        b=gnXHD4nQzB0QIOwIvJEgWKLBuBINVAGVg5dL/IEAe6LVkF3BOKwDSk7agG2uH4aiEz
         f4VX2xA8wIrgwCDsRP970bn7/Q12NwzZ7fPhEaf0eSHZaBN6NzXLLXLn8cKWWKHBiwte
         iIXG/6w+F9ktgMnVraUHnucrShZ/o8Rt69Xno=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686781849; x=1689373849;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dKd1XFIVGPOZA4qvGS585JsImLUJNE7z0dQLfRUwg58=;
        b=Qv/HQMazrIw9lQbtb8+b5dngiultTG/qYnLskyGhIvJAr50eT62ReCi8R/6bRg37Jm
         /c+UMBfdlpralGuh8h5JPvyafH5Ty3pDi/9jqJAkgMV6bgDeLfvkKYZZFPM7XgwaUFTC
         v8a5og4MMq8UuNhwwZzpep8diVBicoIYIVUjJWgum9oWpmFz2WiXcUJ9E8GR5LuCMoT5
         nE+1nsar1sBkI/oxQb/yCCXKvpW4qMb1wKJr/hi1AVfNP+lPaGtM+cALRz/kqry3Hi3r
         EA7u7h9xc1F6cKw8n+BBUreTakf8P3es0Xca0gh9NKj4k6sy4QhQDdSmRfR+jYHsxIe4
         Zmpg==
X-Gm-Message-State: AC+VfDxbB9+J2Kk0pwpqKPH+qPuH2J6dsiAB4C0pT2uiERLI6ZlLtuQg
	vpR+Cp6pgtkQtKSdAJrYKJzdnHG11FysoYkPeG0ZwnQUwfXSz3Pk9b0s0JVTd0G4dZAGCsZk89A
	DpIlVC6Fh+DLB/jaJfkkkgdV+Ywjb8AlYDZ8tVtjWZfnY4ss+QfTlsdYzPZZwKjA6JV++TGCjWg
	pmUYMhKw==
X-Google-Smtp-Source: ACHHUZ6LURpDmVJ8FJM6IG7K7k1O09Ixn5RpQ3KjUe6fLCkah961KOcWHS5vZjq6BQ3BAfudyDzcSg==
X-Received: by 2002:ac8:5cce:0:b0:3f9:d266:7be7 with SMTP id s14-20020ac85cce000000b003f9d2667be7mr3417722qta.42.1686781849159;
        Wed, 14 Jun 2023 15:30:49 -0700 (PDT)
Received: from stbirv-lnx-2.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d3-20020ac85443000000b003ef2db16e72sm5419360qtq.94.2023.06.14.15.30.46
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 14 Jun 2023 15:30:48 -0700 (PDT)
From: Justin Chen <justin.chen@broadcom.com>
To: netdev@vger.kernel.org,
	devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	bcm-kernel-feedback-list@broadcom.com
Cc: florian.fainelli@broadcom.com,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	robh+dt@kernel.org,
	krzysztof.kozlowski+dt@linaro.org,
	conor+dt@kernel.org,
	opendmb@gmail.com,
	andrew@lunn.ch,
	hkallweit1@gmail.com,
	linux@armlinux.org.uk,
	richardcochran@gmail.com,
	sumit.semwal@linaro.org,
	christian.koenig@amd.com,
	simon.horman@corigine.com,
	Justin Chen <justin.chen@broadcom.com>
Subject: [PATCH net-next v7 08/11] net: bcmasp: Add support for ethtool driver stats
Date: Wed, 14 Jun 2023 15:30:17 -0700
Message-Id: <1686781820-832-9-git-send-email-justin.chen@broadcom.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1686781820-832-1-git-send-email-justin.chen@broadcom.com>
References: <1686781820-832-1-git-send-email-justin.chen@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
	boundary="000000000000f6203105fe1e8047"
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
	MIME_HEADER_CTYPE_ONLY,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,T_TVD_MIME_NO_HEADERS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>

--000000000000f6203105fe1e8047

Add support for ethernet driver specific stats.

Signed-off-by: Justin Chen <justin.chen@broadcom.com>
---
 drivers/net/ethernet/broadcom/asp2/bcmasp.c        |   1 +
 drivers/net/ethernet/broadcom/asp2/bcmasp.h        |  21 +++
 .../net/ethernet/broadcom/asp2/bcmasp_ethtool.c    | 158 +++++++++++++++++++++
 drivers/net/ethernet/broadcom/asp2/bcmasp_intf.c   |   8 ++
 4 files changed, 188 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/asp2/bcmasp.c b/drivers/net/ethernet/broadcom/asp2/bcmasp.c
index ba9842c760d5..a8905fef4f8a 100644
--- a/drivers/net/ethernet/broadcom/asp2/bcmasp.c
+++ b/drivers/net/ethernet/broadcom/asp2/bcmasp.c
@@ -891,6 +891,7 @@ int bcmasp_set_en_mda_filter(struct bcmasp_intf *intf, unsigned char *addr,
 		/* Attempt to combine filters */
 		ret = bcmasp_combine_set_filter(intf, addr, mask, i);
 		if (!ret) {
+			intf->mib.filters_combine_cnt++;
 			return 0;
 		}
 	}
diff --git a/drivers/net/ethernet/broadcom/asp2/bcmasp.h b/drivers/net/ethernet/broadcom/asp2/bcmasp.h
index 7dc597658ed7..1485c2c3712d 100644
--- a/drivers/net/ethernet/broadcom/asp2/bcmasp.h
+++ b/drivers/net/ethernet/broadcom/asp2/bcmasp.h
@@ -245,6 +245,26 @@ struct bcmasp_intf_stats64{
 	struct u64_stats_sync		syncp;
 };
 
+struct bcmasp_mib_counters {
+	u32	edpkt_ts;
+	u32	edpkt_rx_pkt_cnt;
+	u32	edpkt_hdr_ext_cnt;
+	u32	edpkt_hdr_out_cnt;
+	u32	umac_frm_cnt;
+	u32	fb_frm_cnt;
+	u32	fb_rx_fifo_depth;
+	u32	fb_out_frm_cnt;
+	u32	fb_filt_out_frm_cnt;
+	u32	alloc_rx_skb_failed;
+	u32	tx_dma_failed;
+	u32	mc_filters_full_cnt;
+	u32	uc_filters_full_cnt;
+	u32	filters_combine_cnt;
+	u32	promisc_filters_cnt;
+	u32	tx_realloc_offload_failed;
+	u32	tx_realloc_offload;
+};
+
 struct bcmasp_intf_ops {
 	unsigned long (*rx_desc_read)(struct bcmasp_intf *intf);
 	void (*rx_buffer_write)(struct bcmasp_intf *intf, dma_addr_t addr);
@@ -307,6 +327,7 @@ struct bcmasp_intf {
 
 	/* Statistics */
 	struct bcmasp_intf_stats64	stats64;
+	struct bcmasp_mib_counters	mib;
 
 	u32			wolopts;
 	u8			sopass[SOPASS_MAX];
diff --git a/drivers/net/ethernet/broadcom/asp2/bcmasp_ethtool.c b/drivers/net/ethernet/broadcom/asp2/bcmasp_ethtool.c
index 59d853c2293c..fc47e27b148d 100644
--- a/drivers/net/ethernet/broadcom/asp2/bcmasp_ethtool.c
+++ b/drivers/net/ethernet/broadcom/asp2/bcmasp_ethtool.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 #define pr_fmt(fmt)				"bcmasp_ethtool: " fmt
 
+#include <asm-generic/unaligned.h>
 #include <linux/ethtool.h>
 #include <linux/netdevice.h>
 #include <linux/platform_device.h>
@@ -8,6 +9,160 @@
 #include "bcmasp.h"
 #include "bcmasp_intf_defs.h"
 
+enum bcmasp_stat_type {
+	BCMASP_STAT_RX_EDPKT,
+	BCMASP_STAT_RX_CTRL,
+	BCMASP_STAT_RX_CTRL_PER_INTF,
+	BCMASP_STAT_SOFT,
+};
+
+struct bcmasp_stats {
+	char stat_string[ETH_GSTRING_LEN];
+	enum bcmasp_stat_type type;
+	u32 reg_offset;
+};
+
+#define STAT_BCMASP_SOFT_MIB(str) { \
+	.stat_string = str, \
+	.type = BCMASP_STAT_SOFT, \
+}
+
+#define STAT_BCMASP_OFFSET(str, _type, offset) { \
+	.stat_string = str, \
+	.type = _type, \
+	.reg_offset = offset, \
+}
+
+#define STAT_BCMASP_RX_EDPKT(str, offset) \
+	STAT_BCMASP_OFFSET(str, BCMASP_STAT_RX_EDPKT, offset)
+#define STAT_BCMASP_RX_CTRL(str, offset) \
+	STAT_BCMASP_OFFSET(str, BCMASP_STAT_RX_CTRL, offset)
+#define STAT_BCMASP_RX_CTRL_PER_INTF(str, offset) \
+	STAT_BCMASP_OFFSET(str, BCMASP_STAT_RX_CTRL_PER_INTF, offset)
+
+/* Must match the order of struct bcmasp_mib_counters */
+static const struct bcmasp_stats bcmasp_gstrings_stats[] = {
+	/* EDPKT counters */
+	STAT_BCMASP_RX_EDPKT("RX Time Stamp", ASP_EDPKT_RX_TS_COUNTER),
+	STAT_BCMASP_RX_EDPKT("RX PKT Count", ASP_EDPKT_RX_PKT_CNT),
+	STAT_BCMASP_RX_EDPKT("RX PKT Buffered", ASP_EDPKT_HDR_EXTR_CNT),
+	STAT_BCMASP_RX_EDPKT("RX PKT Pushed to DRAM", ASP_EDPKT_HDR_OUT_CNT),
+	/* ASP RX control */
+	STAT_BCMASP_RX_CTRL_PER_INTF("Frames From Unimac",
+				     ASP_RX_CTRL_UMAC_0_FRAME_COUNT),
+	STAT_BCMASP_RX_CTRL_PER_INTF("Frames From Port",
+				     ASP_RX_CTRL_FB_0_FRAME_COUNT),
+	STAT_BCMASP_RX_CTRL_PER_INTF("RX Buffer FIFO Depth",
+				     ASP_RX_CTRL_FB_RX_FIFO_DEPTH),
+	STAT_BCMASP_RX_CTRL("Frames Out(Buffer)",
+			    ASP_RX_CTRL_FB_OUT_FRAME_COUNT),
+	STAT_BCMASP_RX_CTRL("Frames Out(Filters)",
+			    ASP_RX_CTRL_FB_FILT_OUT_FRAME_COUNT),
+	/* Software maintained statistics */
+	STAT_BCMASP_SOFT_MIB("RX SKB Alloc Failed"),
+	STAT_BCMASP_SOFT_MIB("TX DMA Failed"),
+	STAT_BCMASP_SOFT_MIB("Multicast Filters Full"),
+	STAT_BCMASP_SOFT_MIB("Unicast Filters Full"),
+	STAT_BCMASP_SOFT_MIB("MDA Filters Combined"),
+	STAT_BCMASP_SOFT_MIB("Promisc Filter Set"),
+	STAT_BCMASP_SOFT_MIB("TX Realloc For Offload Failed"),
+	STAT_BCMASP_SOFT_MIB("Tx Realloc For Offload"),
+};
+
+#define BCMASP_STATS_LEN	ARRAY_SIZE(bcmasp_gstrings_stats)
+
+static u16 bcmasp_stat_fixup_offset(struct bcmasp_intf *intf,
+				    const struct bcmasp_stats *s)
+{
+	struct bcmasp_priv *priv = intf->parent;
+
+	if (!strcmp("Frames Out(Buffer)", s->stat_string))
+		return priv->hw_info->rx_ctrl_fb_out_frame_count;
+
+	if (!strcmp("Frames Out(Filters)", s->stat_string))
+		return priv->hw_info->rx_ctrl_fb_filt_out_frame_count;
+
+	if (!strcmp("RX Buffer FIFO Depth", s->stat_string))
+		return priv->hw_info->rx_ctrl_fb_rx_fifo_depth;
+
+	return s->reg_offset;
+}
+
+static int bcmasp_get_sset_count(struct net_device *dev, int string_set)
+{
+	switch (string_set) {
+	case ETH_SS_STATS:
+		return BCMASP_STATS_LEN;
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
+static void bcmasp_get_strings(struct net_device *dev, u32 stringset,
+			       u8 *data)
+{
+	int i;
+
+	switch (stringset) {
+	case ETH_SS_STATS:
+		for (i = 0; i < BCMASP_STATS_LEN; i++) {
+			memcpy(data + i * ETH_GSTRING_LEN,
+			       bcmasp_gstrings_stats[i].stat_string,
+			       ETH_GSTRING_LEN);
+		}
+		break;
+	default:
+		return;
+	}
+}
+
+static void bcmasp_update_mib_counters(struct bcmasp_intf *intf)
+{
+	int i;
+
+	for (i = 0; i < BCMASP_STATS_LEN; i++) {
+		const struct bcmasp_stats *s;
+		u32 offset, val;
+		char *p;
+
+		s = &bcmasp_gstrings_stats[i];
+		offset = bcmasp_stat_fixup_offset(intf, s);
+		switch (s->type) {
+		case BCMASP_STAT_SOFT:
+			continue;
+		case BCMASP_STAT_RX_EDPKT:
+			val = rx_edpkt_core_rl(intf->parent, offset);
+			break;
+		case BCMASP_STAT_RX_CTRL:
+			val = rx_ctrl_core_rl(intf->parent, offset);
+			break;
+		case BCMASP_STAT_RX_CTRL_PER_INTF:
+			offset += sizeof(u32) * intf->port;
+			val = rx_ctrl_core_rl(intf->parent, offset);
+			break;
+		}
+		p = (char *)(&intf->mib) + (i * sizeof(u32));
+		put_unaligned(val, (u32 *)p);
+	}
+}
+
+static void bcmasp_get_ethtool_stats(struct net_device *dev,
+				     struct ethtool_stats *stats,
+				     u64 *data)
+{
+	struct bcmasp_intf *intf = netdev_priv(dev);
+	char *p;
+	int i;
+
+	if (netif_running(dev))
+		bcmasp_update_mib_counters(intf);
+
+	for (i = 0; i < BCMASP_STATS_LEN; i++) {
+		p = (char *)(&intf->mib) + (i * sizeof(u32));
+		data[i] = *(u32 *)p;
+	}
+}
+
 static void bcmasp_get_drvinfo(struct net_device *dev,
 			       struct ethtool_drvinfo *info)
 {
@@ -340,4 +495,7 @@ const struct ethtool_ops bcmasp_ethtool_ops = {
 	.get_eth_mac_stats	= bcmasp_get_eth_mac_stats,
 	.get_rmon_stats		= bcmasp_get_rmon_stats,
 	.get_eth_ctrl_stats	= bcmasp_get_eth_ctrl_stats,
+	.get_strings		= bcmasp_get_strings,
+	.get_ethtool_stats	= bcmasp_get_ethtool_stats,
+	.get_sset_count		= bcmasp_get_sset_count,
 };
diff --git a/drivers/net/ethernet/broadcom/asp2/bcmasp_intf.c b/drivers/net/ethernet/broadcom/asp2/bcmasp_intf.c
index 899cb06a3fde..e67e725633b4 100644
--- a/drivers/net/ethernet/broadcom/asp2/bcmasp_intf.c
+++ b/drivers/net/ethernet/broadcom/asp2/bcmasp_intf.c
@@ -105,6 +105,7 @@ static void bcmasp_set_rx_mode(struct net_device *dev)
 		netdev_for_each_mc_addr(ha, dev) {
 			ret = bcmasp_set_en_mda_filter(intf, ha->addr, mask);
 			if (ret) {
+				intf->mib.mc_filters_full_cnt++;
 				goto set_promisc;
 			}
 		}
@@ -113,6 +114,7 @@ static void bcmasp_set_rx_mode(struct net_device *dev)
 	netdev_for_each_uc_addr(ha, dev) {
 		ret = bcmasp_set_en_mda_filter(intf, ha->addr, mask);
 		if (ret) {
+			intf->mib.uc_filters_full_cnt++;
 			goto set_promisc;
 		}
 	}
@@ -122,6 +124,7 @@ static void bcmasp_set_rx_mode(struct net_device *dev)
 
 set_promisc:
 	bcmasp_set_promisc(intf, 1);
+	intf->mib.promisc_filters_cnt++;
 
 	/* disable all filters used by this port */
 	bcmasp_disable_all_filters(intf);
@@ -157,6 +160,7 @@ static struct sk_buff *bcmasp_csum_offload(struct net_device *dev,
 					   struct sk_buff *skb,
 					   bool *csum_hw)
 {
+	struct bcmasp_intf *intf = netdev_priv(dev);
 	u32 header = 0, header2 = 0, epkt = 0;
 	struct bcmasp_pkt_offload *offload;
 	unsigned int header_cnt = 0;
@@ -169,11 +173,13 @@ static struct sk_buff *bcmasp_csum_offload(struct net_device *dev,
 	if (unlikely(skb_headroom(skb) < sizeof(*offload))) {
 		new_skb = skb_realloc_headroom(skb, sizeof(*offload));
 		if (!new_skb) {
+			intf->mib.tx_realloc_offload_failed++;
 			goto help;
 		}
 
 		dev_consume_skb_any(skb);
 		skb = new_skb;
+		intf->mib.tx_realloc_offload++;
 	}
 
 	switch (skb->protocol) {
@@ -312,6 +318,7 @@ static netdev_tx_t bcmasp_xmit(struct sk_buff *skb, struct net_device *dev)
 		}
 
 		if (dma_mapping_error(kdev, mapping)) {
+			intf->mib.tx_dma_failed++;
 			spb_index = intf->tx_spb_index;
 			for (j = 0; j < i; j++) {
 				bcmasp_clean_txcb(intf, spb_index);
@@ -549,6 +556,7 @@ static int bcmasp_rx_poll(struct napi_struct *napi, int budget)
 			u64_stats_inc(&stats->rx_errors);
 			u64_stats_update_end(&stats->syncp);
 
+			intf->mib.alloc_rx_skb_failed++;
 			netif_warn(intf, rx_err, intf->ndev,
 				   "SKB alloc failed\n");
 			goto next;
-- 
2.7.4


--000000000000f6203105fe1e8047
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
NhTY3E+cXCB11wty89QStajwXdhGJTYEvUgvsq1h8CwJj9w/38ldAQf5WjhPmApYeJR2ewFrBMCM
4lHkdRJ6TDc9nXoEkypUfjJkJHe7Eal06tosh6JpAgMBAAGjggHZMIIB1TAOBgNVHQ8BAf8EBAMC
BaAwgaMGCCsGAQUFBwEBBIGWMIGTME4GCCsGAQUFBzAChkJodHRwOi8vc2VjdXJlLmdsb2JhbHNp
Z24uY29tL2NhY2VydC9nc2djY3IzcGVyc29uYWxzaWduMmNhMjAyMC5jcnQwQQYIKwYBBQUHMAGG
NWh0dHA6Ly9vY3NwLmdsb2JhbHNpZ24uY29tL2dzZ2NjcjNwZXJzb25hbHNpZ24yY2EyMDIwME0G
A1UdIARGMEQwQgYKKwYBBAGgMgEoCjA0MDIGCCsGAQUFBwIBFiZodHRwczovL3d3dy5nbG9iYWxz
aWduLmNvbS9yZXBvc2l0b3J5LzAJBgNVHRMEAjAAMEkGA1UdHwRCMEAwPqA8oDqGOGh0dHA6Ly9j
cmwuZ2xvYmFsc2lnbi5jb20vZ3NnY2NyM3BlcnNvbmFsc2lnbjJjYTIwMjAuY3JsMCMGA1UdEQQc
MBqBGGp1c3Rpbi5jaGVuQGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEFBQcDBDAfBgNVHSME
GDAWgBSWM9HmWBdbNHWKgVZk1b5I3qGPzzAdBgNVHQ4EFgQUIWGeYuaTsnIada5Xx8TR3cheUbgw
DQYJKoZIhvcNAQELBQADggEBAHNQlMqQOFYPYFO71A+8t+qWMmtOdd2iGswSOvpSZ/pmGlfw8ZvY
dRTkl27m37la84AxRkiVMes14JyOZJoMh/g7fbgPlU14eBc6WQWkIA6AmNkduFWTr1pRezkjpeo6
xVmdBLM4VY1TFDYj7S8H2adPuypd62uHMY/MZi+BIUys4uAFA+N3NuUBNjcVZXYPplYxxKEuIFq6
sDL+OV16G+F9CkNMN3txsym8Nnx5WAYZb6+rBUIhMGz70V05xsHQfzvo2s7f0J1tJ5BoRlPPhL0h
VOnWA3h71u9TfSsv+PXVm3P21TfOS2uc1hbzEqyENCP4i5XQ0rv0TmPW42GZ0o4xggJtMIICaQIB
ATBrMFsxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMTEwLwYDVQQDEyhH
bG9iYWxTaWduIEdDQyBSMyBQZXJzb25hbFNpZ24gMiBDQSAyMDIwAgwj8BKLXNpALfemdRAwDQYJ
YIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIOLjZZUn9WSUWgYRcmGghoWZCTUbQcH767HS
BcLaPY78MBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIzMDYxNDIy
MzA0OVowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCGSAFl
AwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQCATAN
BgkqhkiG9w0BAQEFAASCAQAELH2xejg/BkaNy2SbYmJfWpgv6wDyDQ3hV+wZIiW5wOgif2X6dvf6
QPMlLflrIjFqIc6biu1371gFZEQ5XGqT2KZGatOo1QLeAX6g7UAZ4jlRzd12gQnLFvb4byU3OsX8
Rr94Jxwtfco9bFqvtS0KBy84R6okSJo1gDJSdWyiHO9XfVP077qO6UNQz0oL+GSYf3pdT8McW2uL
lkVv5AQwmswHndQI+61oXE+uuERevGgfI2vPEJvVx8EGPVhlRYLJl8Y5doGP8mzdILPPGNcNvWDx
QBFPM34+rHylPibx2iKo/it/cCz59Fa28PjlAIASRTgk/1KXCOMFuX9MpiAx
--000000000000f6203105fe1e8047--


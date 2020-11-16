Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AFDD2B3FE5
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 10:36:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728536AbgKPJfQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 04:35:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726621AbgKPJfP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Nov 2020 04:35:15 -0500
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11FB3C0613D1;
        Mon, 16 Nov 2020 01:35:14 -0800 (PST)
Received: by mail-lj1-x243.google.com with SMTP id 11so19387477ljf.2;
        Mon, 16 Nov 2020 01:35:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ou7EtV1RxMuUf4lV5Tyhbpg+CmsgkEYcDuAbco0D340=;
        b=sWtq/Dy3/9wfA1Mj8CTkEkh+kvUm7YAzL0HmSclj/F8ZIjsr4tHRG0a0cOmjbHJQSO
         TOb+g4HQhdlJiA3wloKPNwoMLe4Rk+2FI3mSDvxenCW1eTC2LIe6G586bXGUrTMBDTbM
         ASaZWIXCLoFYjOvh4qOr79MLItlR5O/BIQe4Ed3vyNNecJ0an9o1NuqAzaaUknSETBPE
         JHkBXkZtUhKc5nS7dSWoKsPTBz6/whMXB/0ipnaov4IvhVLHnLo95hS4ZcfwpZUPkrk5
         8Buh4CURSkfBUqpcpC8gvOLgz2KbuQbZqTuqliJtsGWFjkVc6oMIa8PBma0Oox99+Sh6
         fuzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ou7EtV1RxMuUf4lV5Tyhbpg+CmsgkEYcDuAbco0D340=;
        b=l7arPiS3Mh7E5CFliawlUoiHPgjQkHGrNUyCKAWICQ7dfkkvVOCicEPkUSy28XwOT7
         8rFUitpv8Iiiv877k1W3qybQcxgkSP8rIfPYsBjhSZYiE4WP1tUxGGoPEfV9st3Trt6i
         aeVIk/8/67V61HDgKke0k1MOeK/CDAeQluH6A6u5nAEtUwwh8t9VKg1qe5DVZVHui11L
         6DDUoIpxm5dlRomamc8GXQoBNF2t24gDym00uteUShISlf3E7VV3PN3nDHC3D+AFNyCG
         WvgNYBHp2aYGPHGoCNdjbKpBedJwIx45s5LLxFR+OaJhRSHtFPbbO+n9smM2NTZHgftA
         1Z4Q==
X-Gm-Message-State: AOAM533yaKmFKfU0bnEmqVMhghA8XeZgMaQBhWMRRwWpgnJHdN9XKMks
        teir04m0ajVYm9xiPrlWGck=
X-Google-Smtp-Source: ABdhPJzgMYyWqD+aahFpWv1HDhCszKD2XblSFEn+UGXRNDex+y7/foPGPyehxOIpCzKUuYFdMhVG2w==
X-Received: by 2002:a2e:9915:: with SMTP id v21mr5968770lji.460.1605519312599;
        Mon, 16 Nov 2020 01:35:12 -0800 (PST)
Received: from localhost.localdomain (87-205-71-93.adsl.inetia.pl. [87.205.71.93])
        by smtp.gmail.com with ESMTPSA id t26sm2667986lfp.296.2020.11.16.01.35.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2020 01:35:11 -0800 (PST)
From:   alardam@gmail.com
X-Google-Original-From: marekx.majtyka@intel.com
To:     magnus.karlsson@intel.com, bjorn.topel@intel.com,
        andrii.nakryiko@gmail.com, kuba@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org, davem@davemloft.net,
        john.fastabend@gmail.com, hawk@kernel.org, toke@redhat.com
Cc:     maciej.fijalkowski@intel.com, jonathan.lemon@gmail.com,
        bpf@vger.kernel.org, jeffrey.t.kirsher@intel.com,
        maciejromanfijalkowski@gmail.com, intel-wired-lan@lists.osuosl.org,
        Marek Majtyka <marekx.majtyka@intel.com>
Subject: [PATCH 1/8] net: ethtool: extend netdev_features flag set
Date:   Mon, 16 Nov 2020 10:34:45 +0100
Message-Id: <20201116093452.7541-2-marekx.majtyka@intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201116093452.7541-1-marekx.majtyka@intel.com>
References: <20201116093452.7541-1-marekx.majtyka@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Marek Majtyka <marekx.majtyka@intel.com>

Implement support for checking if a netdev has XDP and AF_XDP zero copy
support. Previously, there was no way to do this other than to try
to create an AF_XDP socket on the interface or load an XDP program
and see if it worked. This commit changes this by extending existing
netdev_features in the following way:
 * xdp        - full XDP support (XDP_{TX, PASS, DROP, ABORT, REDIRECT})
 * af-xdp-zc  - AF_XDP zero copy support

By default these new flags are disabled for all drivers.

    $ ethtool -k enp1s0f0
     Features for enp1s0f0:
     ..
     xdp: off [fixed]
     af-xdp-zc: off [fixed]

Signed-off-by: Marek Majtyka <marekx.majtyka@intel.com>
---
 include/linux/netdev_features.h |  6 ++++++
 include/net/xdp.h               | 13 +++++++++++++
 include/net/xdp_sock_drv.h      | 11 +++++++++++
 net/ethtool/common.c            |  2 ++
 4 files changed, 32 insertions(+)

diff --git a/include/linux/netdev_features.h b/include/linux/netdev_features.h
index 934de56644e7..d154ee7209b9 100644
--- a/include/linux/netdev_features.h
+++ b/include/linux/netdev_features.h
@@ -85,6 +85,8 @@ enum {
 
 	NETIF_F_HW_MACSEC_BIT,		/* Offload MACsec operations */
 
+	NETIF_F_XDP_BIT,		/* XDP support */
+	NETIF_F_AF_XDP_ZC_BIT,		/* AF_XDP zero-copy support */
 	/*
 	 * Add your fresh new feature above and remember to update
 	 * netdev_features_strings[] in net/core/ethtool.c and maybe
@@ -157,6 +159,9 @@ enum {
 #define NETIF_F_GRO_FRAGLIST	__NETIF_F(GRO_FRAGLIST)
 #define NETIF_F_GSO_FRAGLIST	__NETIF_F(GSO_FRAGLIST)
 #define NETIF_F_HW_MACSEC	__NETIF_F(HW_MACSEC)
+#define NETIF_F_XDP		__NETIF_F(XDP)
+#define NETIF_F_AF_XDP_ZC	__NETIF_F(AF_XDP_ZC)
+
 
 /* Finds the next feature with the highest number of the range of start till 0.
  */
@@ -182,6 +187,7 @@ static inline int find_next_netdev_feature(u64 feature, unsigned long start)
 /* Features valid for ethtool to change */
 /* = all defined minus driver/device-class-related */
 #define NETIF_F_NEVER_CHANGE	(NETIF_F_VLAN_CHALLENGED | \
+				 NETIF_F_XDP | NETIF_F_AF_XDP_ZC | \
 				 NETIF_F_LLTX | NETIF_F_NETNS_LOCAL)
 
 /* remember that ((t)1 << t_BITS) is undefined in C99 */
diff --git a/include/net/xdp.h b/include/net/xdp.h
index 7d48b2ae217a..82bb47372b02 100644
--- a/include/net/xdp.h
+++ b/include/net/xdp.h
@@ -254,6 +254,19 @@ struct xdp_attachment_info {
 	u32 flags;
 };
 
+#if defined(CONFIG_NET) && defined(CONFIG_BPF_SYSCALL)
+static __always_inline void
+xdp_set_feature_flag(netdev_features_t *features)
+{
+	*features |= NETIF_F_XDP;
+}
+#else
+static __always_inline void
+xdp_set_feature_flag(netdev_features_t *features)
+{
+}
+#endif
+
 struct netdev_bpf;
 bool xdp_attachment_flags_ok(struct xdp_attachment_info *info,
 			     struct netdev_bpf *bpf);
diff --git a/include/net/xdp_sock_drv.h b/include/net/xdp_sock_drv.h
index 5b1ee8a9976d..86b41f89d09d 100644
--- a/include/net/xdp_sock_drv.h
+++ b/include/net/xdp_sock_drv.h
@@ -22,6 +22,12 @@ void xsk_clear_rx_need_wakeup(struct xsk_buff_pool *pool);
 void xsk_clear_tx_need_wakeup(struct xsk_buff_pool *pool);
 bool xsk_uses_need_wakeup(struct xsk_buff_pool *pool);
 
+static __always_inline void
+xsk_set_feature_flag(netdev_features_t *features)
+{
+	*features |= NETIF_F_AF_XDP_ZC;
+}
+
 static inline u32 xsk_pool_get_headroom(struct xsk_buff_pool *pool)
 {
 	return XDP_PACKET_HEADROOM + pool->headroom;
@@ -235,6 +241,11 @@ static inline void xsk_buff_raw_dma_sync_for_device(struct xsk_buff_pool *pool,
 {
 }
 
+static __always_inline void
+xsk_set_feature_flag(netdev_features_t *features)
+{
+}
+
 #endif /* CONFIG_XDP_SOCKETS */
 
 #endif /* _LINUX_XDP_SOCK_DRV_H */
diff --git a/net/ethtool/common.c b/net/ethtool/common.c
index 24036e3055a1..eed225283eee 100644
--- a/net/ethtool/common.c
+++ b/net/ethtool/common.c
@@ -68,6 +68,8 @@ const char netdev_features_strings[NETDEV_FEATURE_COUNT][ETH_GSTRING_LEN] = {
 	[NETIF_F_HW_TLS_RX_BIT] =	 "tls-hw-rx-offload",
 	[NETIF_F_GRO_FRAGLIST_BIT] =	 "rx-gro-list",
 	[NETIF_F_HW_MACSEC_BIT] =	 "macsec-hw-offload",
+	[NETIF_F_XDP_BIT] =              "xdp",
+	[NETIF_F_AF_XDP_ZC_BIT] =        "af-xdp-zc",
 };
 
 const char
-- 
2.20.1


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 100F827E013
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 07:18:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727657AbgI3FRt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 01:17:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725306AbgI3FRt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Sep 2020 01:17:49 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C87DC0613D0;
        Tue, 29 Sep 2020 22:17:47 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id x16so370743pgj.3;
        Tue, 29 Sep 2020 22:17:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xsh/NGfm9Lpck5qsH9oUyBKmR7gvigd5uWEhglPw8r8=;
        b=Px15OB6AyCpqk574Y/sAhDwl65KgkjVHiXyo2UacJHbd7BuHGOE39iRoOt7sDy4RFG
         1Lg1BU3JmP8YVXv61BSElcMObnR+IsbgpRYFLDfXAE69M/BsiYE8SbDfk8F13KtxG1kr
         63YzxEThDUKXVTYbJK2oHDc/7rKIYFbTSsnBGp2yhOBL/DgeAmqJCjbgoTb8LvLBTNAs
         h1aecY0uFMrflao6Ze2ELtirur1A5HA82r0rVlINwt8bD2gARTjfQoAAKgLKDNEKtJxS
         Y5bZpRCHrueZ9JdWpKzCOxnvUkhelWsxbwsJKTDRt3gxn3OtkhJnvYLO2ImlrwtKFIyQ
         Dgaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xsh/NGfm9Lpck5qsH9oUyBKmR7gvigd5uWEhglPw8r8=;
        b=CiNZKxFu205j/J/2hMcDdwei/lh2XMbqUpBrgZZyKPGpSCnFU8ZjsfNJROEay/aQ+h
         1psAH7PenZCK/lwYVpJR/japgLgKw7F3dhqCLQJr/V0Ix3545/oyP+rerVYO1HkHM6CS
         HpLrW49ezv0Ks99EDwWyAWg+/Veepi8+1tQ6RrQaYJJ/WXF1nHeZHfbeFJ/oZqmBO/lw
         ld5eRIJ79HSXrmDb9RQhsOXLvPMkspsQWv1a6I80w0GeLtH0Zol/m9ORHF3Ahnzx8KVy
         4KBf/U6rb9TC6/z7do5lNBkXL+pAUE7Ytx+R7wtGQCNXIJPrMrSiTsxOwrDWg+s9RBiV
         YNeA==
X-Gm-Message-State: AOAM5322l1eMFV+rM4GralA7ZQ5Lape4RxfeDEHZyRR8A4cmTe1BQIYV
        J9jD2MeFW+5xmkROHMnppNVPVDpuHepdccCdKFY=
X-Google-Smtp-Source: ABdhPJx0xFgLfzUTp3/ALdDLXFuszMeOe1qKRKcrIVOdbQCBvl/uWe/uAJ6y++a70pyVFGgMJMF8Kg==
X-Received: by 2002:a63:2063:: with SMTP id r35mr856885pgm.320.1601443066501;
        Tue, 29 Sep 2020 22:17:46 -0700 (PDT)
Received: from localhost.localdomain ([49.207.218.220])
        by smtp.gmail.com with ESMTPSA id gm17sm633432pjb.46.2020.09.29.22.17.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Sep 2020 22:17:45 -0700 (PDT)
From:   Anant Thazhemadam <anant.thazhemadam@gmail.com>
To:     mst@redhat.com, jasowang@redhat.com, davem@davemloft.net,
        kuba@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        hawk@kernel.org, john.fastabend@gmail.com
Cc:     Anant Thazhemadam <anant.thazhemadam@gmail.com>,
        linux-kernel-mentees@lists.linuxfoundation.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org
Subject: [Linux-kernel-mentees][PATCH 1/2] net: reorder members of virtnet_info for optimization
Date:   Wed, 30 Sep 2020 10:47:21 +0530
Message-Id: <20200930051722.389587-2-anant.thazhemadam@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200930051722.389587-1-anant.thazhemadam@gmail.com>
References: <20200930051722.389587-1-anant.thazhemadam@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Analysis of the structure virtnet_info using pahole gives the
following stats.
	/* size: 256, cachelines: 4, members: 25 */
	/* sum members: 245, holes: 3, sum holes: 11 */
	/* paddings: 1, sum paddings: 4 */

Reordering the order in which the members of virtnet_info are declared
helps in packing byte holes in the middle of virtnet_info, reduce the
size required by the structure by 8 bytes, and also allows members to be
stored without overstepping the boundaries of a cacheline (for a
cacheline of size 64bytes) unnecessarily.

Analysis using pahole post-reordering of members gives the following
stats.
	/* size: 248, cachelines: 4, members: 25 */
        /* padding: 3 */
        /* paddings: 1, sum paddings: 4 */
        /* last cacheline: 56 bytes */

Signed-off-by: Anant Thazhemadam <anant.thazhemadam@gmail.com>
---
The complete analysis done by pahole can be found below.
Before the change:
		struct virtnet_info {
		struct virtio_device *     vdev;                 /*     0     8 */
		struct virtqueue *         cvq;                  /*     8     8 */
		struct net_device *        dev;                  /*    16     8 */
		struct send_queue *        sq;                   /*    24     8 */
		struct receive_queue *     rq;                   /*    32     8 */
		unsigned int               status;               /*    40     4 */
		u16                        max_queue_pairs;      /*    44     2 */
		u16                        curr_queue_pairs;     /*    46     2 */
		u16                        xdp_queue_pairs;      /*    48     2 */
		bool                       big_packets;          /*    50     1 */
		bool                       mergeable_rx_bufs;    /*    51     1 */
		bool                       has_cvq;              /*    52     1 */
		bool                       any_header_sg;        /*    53     1 */
		u8                         hdr_len;              /*    54     1 */

		/* XXX 1 byte hole, try to pack */

		struct delayed_work refill;                      /*    56    88 */

		/* XXX last struct has 4 bytes of padding */

		/* --- cacheline 2 boundary (128 bytes) was 16 bytes ago --- */
		struct work_struct config_work;                  /*   144    32 */
		bool                       affinity_hint_set;    /*   176     1 */

		/* XXX 7 bytes hole, try to pack */

		struct hlist_node  node;                         /*   184    16 */
		/* --- cacheline 3 boundary (192 bytes) was 8 bytes ago --- */
		struct hlist_node  node_dead;                    /*   200    16 */
		struct control_buf *       ctrl;                 /*   216     8 */
		u8                         duplex;               /*   224     1 */

		/* XXX 3 bytes hole, try to pack */

		u32                        speed;                /*   228     4 */
		long unsigned int          guest_offloads;       /*   232     8 */
		long unsigned int          guest_offloads_capable; /*   240     8 */
		struct failover *          failover;             /*   248     8 */

		/* size: 256, cachelines: 4, members: 25 */
		/* sum members: 245, holes: 3, sum holes: 11 */
		/* paddings: 1, sum paddings: 4 */
	};

After the Change:
	struct virtnet_info {
		struct virtio_device *     vdev;                 /*     0     8 */
		struct virtqueue *         cvq;                  /*     8     8 */
		struct net_device *        dev;                  /*    16     8 */
		struct send_queue *        sq;                   /*    24     8 */
		struct receive_queue *     rq;                   /*    32     8 */
		unsigned int               status;               /*    40     4 */
		u16                        max_queue_pairs;      /*    44     2 */
		u16                        curr_queue_pairs;     /*    46     2 */
		u16                        xdp_queue_pairs;      /*    48     2 */
		bool                       big_packets;          /*    50     1 */
		bool                       mergeable_rx_bufs;    /*    51     1 */
		bool                       has_cvq;              /*    52     1 */
		bool                       any_header_sg;        /*    53     1 */
		bool                       affinity_hint_set;    /*    54     1 */
		u8                         hdr_len;              /*    55     1 */
		struct control_buf *       ctrl;                 /*    56     8 */
		/* --- cacheline 1 boundary (64 bytes) --- */
		struct work_struct config_work;                  /*    64    32 */
		struct hlist_node  node;                         /*    96    16 */
		struct hlist_node  node_dead;                    /*   112    16 */
		/* --- cacheline 2 boundary (128 bytes) --- */
		long unsigned int          guest_offloads;       /*   128     8 */
		long unsigned int          guest_offloads_capable; /*   136     8 */
		struct failover *          failover;             /*   144     8 */
		struct delayed_work refill;                      /*   152    88 */

		/* XXX last struct has 4 bytes of padding */

		/* --- cacheline 3 boundary (192 bytes) was 48 bytes ago --- */
		u32                        speed;                /*   240     4 */
		u8                         duplex;               /*   244     1 */

		/* size: 248, cachelines: 4, members: 25 */
		/* padding: 3 */
		/* paddings: 1, sum paddings: 4 */
		/* last cacheline: 56 bytes */
	};

It can be seen that the size has reduced by 8 bytes, and the holes have been eliminated
as well. Also, more members of virtnet_info are accomodated within one cacheline 
(without unnecessarily crossing over the cacheline boundary).


 drivers/net/virtio_net.c | 42 ++++++++++++++++++++--------------------
 1 file changed, 21 insertions(+), 21 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 263b005981bd..32747f1980ae 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -137,29 +137,29 @@ struct receive_queue {
 
 	struct napi_struct napi;
 
+	/* Name of this receive queue: input.$index */
+	char name[40];
+
 	struct bpf_prog __rcu *xdp_prog;
 
 	struct virtnet_rq_stats stats;
 
+	/* RX: fragments + linear part + virtio header */
+	struct scatterlist sg[MAX_SKB_FRAGS + 2];
+
+	/* Page frag for packet buffer allocation. */
+	struct page_frag alloc_frag;
+
 	/* Chain pages by the private ptr. */
 	struct page *pages;
 
 	/* Average packet length for mergeable receive buffers. */
 	struct ewma_pkt_len mrg_avg_pkt_len;
 
-	/* Page frag for packet buffer allocation. */
-	struct page_frag alloc_frag;
-
-	/* RX: fragments + linear part + virtio header */
-	struct scatterlist sg[MAX_SKB_FRAGS + 2];
+	struct xdp_rxq_info xdp_rxq;
 
 	/* Min single buffer size for mergeable buffers case. */
 	unsigned int min_buf_len;
-
-	/* Name of this receive queue: input.$index */
-	char name[40];
-
-	struct xdp_rxq_info xdp_rxq;
 };
 
 /* Control VQ buffers: protected by the rtnl lock */
@@ -202,33 +202,33 @@ struct virtnet_info {
 	/* Host can handle any s/g split between our header and packet data */
 	bool any_header_sg;
 
+	/* Does the affinity hint is set for virtqueues? */
+	bool affinity_hint_set;
+
 	/* Packet virtio header size */
 	u8 hdr_len;
 
-	/* Work struct for refilling if we run low on memory. */
-	struct delayed_work refill;
+	struct control_buf *ctrl;
 
 	/* Work struct for config space updates */
 	struct work_struct config_work;
 
-	/* Does the affinity hint is set for virtqueues? */
-	bool affinity_hint_set;
-
 	/* CPU hotplug instances for online & dead */
 	struct hlist_node node;
 	struct hlist_node node_dead;
 
-	struct control_buf *ctrl;
-
-	/* Ethtool settings */
-	u8 duplex;
-	u32 speed;
-
 	unsigned long guest_offloads;
 	unsigned long guest_offloads_capable;
 
 	/* failover when STANDBY feature enabled */
 	struct failover *failover;
+
+	/* Work struct for refilling if we run low on memory. */
+	struct delayed_work refill;
+
+	/* Ethtool settings */
+	u32 speed;
+	u8 duplex;
 };
 
 struct padded_vnet_hdr {
-- 
2.25.1


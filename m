Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CE2C27E017
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 07:18:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727761AbgI3FR5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 01:17:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725306AbgI3FRy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Sep 2020 01:17:54 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80376C061755;
        Tue, 29 Sep 2020 22:17:54 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id y6so301861plt.9;
        Tue, 29 Sep 2020 22:17:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3kFQkly1sTsAvr9NqpCdE/6D85qWzElfytCruQQ6xp0=;
        b=baEIgc1tAUz1CwCztA6ANx5C1M1eacWueIwa4tbHblGGxkmzCqNHjvhO+P/HWeEtiV
         VLIXdvqHNVLsk3fOqxcPATIMh9b7Rr+ctg3rk00Fo9WKt8g/s73sPS5xujg6Cy3573iC
         4hGaJGvw0cVOb9ZTnjXCiV4xIemufkqGd4nJ54J9Pal1W2uhpZWDeW3wx0ul077oR+qw
         gKqOSgTybJLRHockdq/oPVoXNwy/BXfAAWih2bB7Hdjvvrc+VGvzNZZEO5K+yILLYy6P
         0h529DY47EjOiKdvaoS7nXipkDAcxsIVZKNrNyYBb01R7pur9ytj1zZJBGzvsg5hn7EA
         J85Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3kFQkly1sTsAvr9NqpCdE/6D85qWzElfytCruQQ6xp0=;
        b=QRR73ddHQDM0kF2p8Jtkl5ApzSTR/rOg1BDLvzgL0LMTrfTbcWHQtxSZv9URHxn2lX
         8Xx7hIewGd6vme+a+bO1yJ7m8Ezfec+9Q4r/DgLRNtWZW5TDNE21M8Wm5voiiUajEHXs
         6pjjL6rXeaud2n5E2xv1JFNFGmJuZ2nhDZxSZ4O8rWM9gcoS9aQoZser312io8iHb7Hn
         xEfRrFMM4us4iGx8cf5uwn39Om/smaQqF7NOJqp21fHaDDGlza18jpfOV0H5h3Tm/YCj
         42pT4AjqzliV6dH5+6fk2A3YgQyyiRkM41EPYT+2I6UD5MfiK1Pr68LfViI65Pqz1cHV
         9weQ==
X-Gm-Message-State: AOAM531oC+G7RndCWwu6yQ+Cm1PupLM2fhZFwZ53iLIWRJxN1TfLeeOh
        gHP7gJQSQL5rCw6tTpT2vgk=
X-Google-Smtp-Source: ABdhPJwSER/8mTDxyPrH6z2kjHv64sIYRdLt4cRdx81XrZFtXXE3LVUl+Eyuk4hLLb+2aEhI8YLkBQ==
X-Received: by 2002:a17:902:c3d2:b029:d2:93f9:1d8a with SMTP id j18-20020a170902c3d2b02900d293f91d8amr1105887plj.66.1601443073874;
        Tue, 29 Sep 2020 22:17:53 -0700 (PDT)
Received: from localhost.localdomain ([49.207.218.220])
        by smtp.gmail.com with ESMTPSA id gm17sm633432pjb.46.2020.09.29.22.17.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Sep 2020 22:17:53 -0700 (PDT)
From:   Anant Thazhemadam <anant.thazhemadam@gmail.com>
To:     mst@redhat.com, jasowang@redhat.com, davem@davemloft.net,
        kuba@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        hawk@kernel.org, john.fastabend@gmail.com, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        kpsingh@chromium.org
Cc:     Anant Thazhemadam <anant.thazhemadam@gmail.com>,
        linux-kernel-mentees@lists.linuxfoundation.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org
Subject: [Linux-kernel-mentees][PATCH 2/2] net: reorder members of receive_queue in virtio_net for optimization
Date:   Wed, 30 Sep 2020 10:47:22 +0530
Message-Id: <20200930051722.389587-3-anant.thazhemadam@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200930051722.389587-1-anant.thazhemadam@gmail.com>
References: <20200930051722.389587-1-anant.thazhemadam@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Analysis of the structure receive_queue using pahole gives the
following stats.
	/* size: 1280, cachelines: 20, members: 11 */
        /* sum members: 1220, holes: 1, sum holes: 60 */
        /* paddings: 2, sum paddings: 44 */
        /* forced alignments: 2, forced holes: 1, sum forced holes: 60 */

Reordering the order in which the members of receive_queue are declared
helps in packing byte holes in the middle of receive_queue, and also
allows more members to be fully stored in a cacheline (of size 64bytes)
without overstepping over cachelines unnecessarily.

Analysis using pahole post-reordering of members gives us the following
stats.
	/* size: 1280, cachelines: 20, members: 11 */
        /* padding: 60 */
        /* paddings: 2, sum paddings: 44 */
        /* forced alignments: 2 */

Signed-off-by: Anant Thazhemadam <anant.thazhemadam@gmail.com>
---
The complete analysis done by pahole can be found below.

Before the change:
	struct receive_queue {
		struct virtqueue *         vq;                   /*     0     8 */
		struct napi_struct napi __attribute__((__aligned__(8))); /*     8   392 */

		/* XXX last struct has 4 bytes of padding */

		/* --- cacheline 6 boundary (384 bytes) was 16 bytes ago --- */
		struct bpf_prog *          xdp_prog;             /*   400     8 */
		struct virtnet_rq_stats stats;                   /*   408    64 */
		/* --- cacheline 7 boundary (448 bytes) was 24 bytes ago --- */
		struct page *              pages;                /*   472     8 */
		struct ewma_pkt_len mrg_avg_pkt_len;             /*   480     8 */
		struct page_frag   alloc_frag;                   /*   488    16 */
		struct scatterlist sg[19];                       /*   504   608 */
		/* --- cacheline 17 boundary (1088 bytes) was 24 bytes ago --- */
		unsigned int               min_buf_len;          /*  1112     4 */
		char                       name[40];             /*  1116    40 */

		/* XXX 60 bytes hole, try to pack */

		/* --- cacheline 19 boundary (1216 bytes) --- */
		struct xdp_rxq_info xdp_rxq __attribute__((__aligned__(64))); /*  1216    64 */

		/* XXX last struct has 40 bytes of padding */

		/* size: 1280, cachelines: 20, members: 11 */
		/* sum members: 1220, holes: 1, sum holes: 60 */
		/* paddings: 2, sum paddings: 44 */
		/* forced alignments: 2, forced holes: 1, sum forced holes: 60 */
	} __attribute__((__aligned__(64)));

After the change:
	struct receive_queue {
		struct virtqueue *         vq;                   /*     0     8 */
		struct napi_struct napi __attribute__((__aligned__(8))); /*     8   392 */

		/* XXX last struct has 4 bytes of padding */

		/* --- cacheline 6 boundary (384 bytes) was 16 bytes ago --- */
		char                       name[40];             /*   400    40 */
		struct bpf_prog *          xdp_prog;             /*   440     8 */
		/* --- cacheline 7 boundary (448 bytes) --- */
		struct virtnet_rq_stats stats;                   /*   448    64 */
		/* --- cacheline 8 boundary (512 bytes) --- */
		struct scatterlist sg[19];                       /*   512   608 */
		/* --- cacheline 17 boundary (1088 bytes) was 32 bytes ago --- */
		struct page_frag   alloc_frag;                   /*  1120    16 */
		struct page *              pages;                /*  1136     8 */
		struct ewma_pkt_len mrg_avg_pkt_len;             /*  1144     8 */
		/* --- cacheline 18 boundary (1152 bytes) --- */
		struct xdp_rxq_info xdp_rxq __attribute__((__aligned__(64))); /*  1152    64 */

		/* XXX last struct has 40 bytes of padding */

		/* --- cacheline 19 boundary (1216 bytes) --- */
		unsigned int               min_buf_len;          /*  1216     4 */

		/* size: 1280, cachelines: 20, members: 11 */
		/* padding: 60 */
		/* paddings: 2, sum paddings: 44 */
		/* forced alignments: 2 */
	} __attribute__((__aligned__(64)));

It can be observed that the holes have been eliminated. 
Also, more members of virtnet_info are accomodated within a cacheline (instead of 
unnecessarily crossing over the cacheline boundary).
There is a padding of 60 performed at the end since the min_buf_len is only of 
size 4, and xdp_rxq is of size 64. If declared anywhere else other than at the 
end, a 60 bytes hole would open up again.

 drivers/net/virtio_net.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index f7bd85001cf0..b52db0b4879a 100644
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
-- 
2.25.1


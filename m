Return-Path: <netdev+bounces-2214-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EE987700BED
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 17:34:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0FE0F1C2139A
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 15:34:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA51E21065;
	Fri, 12 May 2023 15:29:34 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3359209BE;
	Fri, 12 May 2023 15:29:34 +0000 (UTC)
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB60D106E4;
	Fri, 12 May 2023 08:29:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683905352; x=1715441352;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=0H3Jo5u8syYtrs2oEf4GVK8DWDDlchIpBRUlgLTFGBk=;
  b=m09bC1WCNgIeKReTD16PU0FKtEW04w62zSoRydV/cxh9tcl6Zesdw6gP
   G5sjWuCP0pTVj0UJmoAiJF1XzR6n/gXR0tejB10VfJ2bfEWVrSYU8bkuD
   ZmYpYzUOLx7Kbjp+Fwn7iVxnREKjz03Z17LNt/2eIvfz6a3BCGyGaVQyY
   yYyN/raf8/diTsKbBZv5m52KYXCdWTfObof1pi+i4O69PbXk29JNDMM4G
   elVUEU7HIfe1aWHmfHl6owyv8yCNgrDIPig6Fny0dgIbsR9remyQGQ9SP
   3iV25OO39GoaPJN8tEBvbXl40TkQLK90hSjogCO8/wDKPBJ9bTSibgbCU
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10708"; a="437151133"
X-IronPort-AV: E=Sophos;i="5.99,269,1677571200"; 
   d="scan'208";a="437151133"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2023 08:29:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10708"; a="946665835"
X-IronPort-AV: E=Sophos;i="5.99,269,1677571200"; 
   d="scan'208";a="946665835"
Received: from irvmail002.ir.intel.com ([10.43.11.120])
  by fmsmga006.fm.intel.com with ESMTP; 12 May 2023 08:29:06 -0700
Received: from lincoln.igk.intel.com (lincoln.igk.intel.com [10.102.21.235])
	by irvmail002.ir.intel.com (Postfix) with ESMTP id 1E23635FB9;
	Fri, 12 May 2023 16:29:05 +0100 (IST)
From: Larysa Zaremba <larysa.zaremba@intel.com>
To: bpf@vger.kernel.org
Cc: Larysa Zaremba <larysa.zaremba@intel.com>,
	Stanislav Fomichev <sdf@google.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Andrii Nakryiko <andrii@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Martin KaFai Lau <martin.lau@linux.dev>,
	Song Liu <song@kernel.org>,
	Yonghong Song <yhs@fb.com>,
	John Fastabend <john.fastabend@gmail.com>,
	KP Singh <kpsingh@kernel.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Jesse Brandeburg <jesse.brandeburg@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Anatoly Burakov <anatoly.burakov@intel.com>,
	Jesper Dangaard Brouer <brouer@redhat.com>,
	Alexander Lobakin <alexandr.lobakin@intel.com>,
	Magnus Karlsson <magnus.karlsson@gmail.com>,
	Maryam Tahhan <mtahhan@redhat.com>,
	xdp-hints@xdp-project.net,
	netdev@vger.kernel.org,
	intel-wired-lan@lists.osuosl.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH RESEND bpf-next 15/15] selftests/bpf: Add flags and new hints to xdp_hw_metadata
Date: Fri, 12 May 2023 17:26:07 +0200
Message-Id: <20230512152607.992209-16-larysa.zaremba@intel.com>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20230512152607.992209-1-larysa.zaremba@intel.com>
References: <20230512152607.992209-1-larysa.zaremba@intel.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Add hints added in the previous patches (VLAN tags and checksum level)
to the xdp_hw_metadata program.

Also, to make metadata layout more straightforward, add flags field
to pass information about validity of every separate hint separately.

Signed-off-by: Larysa Zaremba <larysa.zaremba@intel.com>
---
 .../selftests/bpf/progs/xdp_hw_metadata.c     | 40 ++++++++++++++++---
 tools/testing/selftests/bpf/xdp_hw_metadata.c | 29 +++++++++++---
 tools/testing/selftests/bpf/xdp_metadata.h    | 28 ++++++++++++-
 3 files changed, 85 insertions(+), 12 deletions(-)

diff --git a/tools/testing/selftests/bpf/progs/xdp_hw_metadata.c b/tools/testing/selftests/bpf/progs/xdp_hw_metadata.c
index f95f82a8b449..97bad79ce4ca 100644
--- a/tools/testing/selftests/bpf/progs/xdp_hw_metadata.c
+++ b/tools/testing/selftests/bpf/progs/xdp_hw_metadata.c
@@ -20,6 +20,12 @@ extern int bpf_xdp_metadata_rx_timestamp(const struct xdp_md *ctx,
 					 __u64 *timestamp) __ksym;
 extern int bpf_xdp_metadata_rx_hash(const struct xdp_md *ctx, __u32 *hash,
 				    enum xdp_rss_hash_type *rss_type) __ksym;
+extern int bpf_xdp_metadata_rx_ctag(const struct xdp_md *ctx,
+				    __u16 *vlan_tag) __ksym;
+extern int bpf_xdp_metadata_rx_stag(const struct xdp_md *ctx,
+				    __u16 *vlan_tag) __ksym;
+extern int bpf_xdp_metadata_rx_csum_lvl(const struct xdp_md *ctx,
+					__u8 *csum_level) __ksym;
 
 SEC("xdp")
 int rx(struct xdp_md *ctx)
@@ -83,15 +89,39 @@ int rx(struct xdp_md *ctx)
 		return XDP_PASS;
 	}
 
+	meta->hint_valid = 0;
+
 	err = bpf_xdp_metadata_rx_timestamp(ctx, &meta->rx_timestamp);
-	if (!err)
+	if (err) {
+		meta->rx_timestamp_err = err;
+	} else {
+		meta->hint_valid |= XDP_META_FIELD_TS;
 		meta->xdp_timestamp = bpf_ktime_get_tai_ns();
-	else
-		meta->rx_timestamp = 0; /* Used by AF_XDP as not avail signal */
+	}
 
 	err = bpf_xdp_metadata_rx_hash(ctx, &meta->rx_hash, &meta->rx_hash_type);
-	if (err < 0)
-		meta->rx_hash_err = err; /* Used by AF_XDP as no hash signal */
+	if (err)
+		meta->rx_hash_err = err;
+	else
+		meta->hint_valid |= XDP_META_FIELD_RSS;
+
+	err = bpf_xdp_metadata_rx_ctag(ctx, &meta->rx_ctag);
+	if (err)
+		meta->rx_ctag_err = err;
+	else
+		meta->hint_valid |= XDP_META_FIELD_CTAG;
+
+	err = bpf_xdp_metadata_rx_stag(ctx, &meta->rx_stag);
+	if (err)
+		meta->rx_stag_err = err;
+	else
+		meta->hint_valid |= XDP_META_FIELD_STAG;
+
+	err = bpf_xdp_metadata_rx_csum_lvl(ctx, &meta->rx_csum_lvl);
+	if (err)
+		meta->rx_csum_err = err;
+	else
+		meta->hint_valid |= XDP_META_FIELD_CSUM_LVL;
 
 	__sync_add_and_fetch(&pkts_redir, 1);
 	return bpf_redirect_map(&xsk, ctx->rx_queue_index, XDP_PASS);
diff --git a/tools/testing/selftests/bpf/xdp_hw_metadata.c b/tools/testing/selftests/bpf/xdp_hw_metadata.c
index 613321eb84c1..efcabe68f64b 100644
--- a/tools/testing/selftests/bpf/xdp_hw_metadata.c
+++ b/tools/testing/selftests/bpf/xdp_hw_metadata.c
@@ -156,15 +156,16 @@ static void verify_xdp_metadata(void *data, clockid_t clock_id)
 
 	meta = data - sizeof(*meta);
 
-	if (meta->rx_hash_err < 0)
-		printf("No rx_hash err=%d\n", meta->rx_hash_err);
-	else
+	if (meta->hint_valid & XDP_META_FIELD_RSS)
 		printf("rx_hash: 0x%X with RSS type:0x%X\n",
 		       meta->rx_hash, meta->rx_hash_type);
+	else
+		printf("No rx_hash, err=%d\n", meta->rx_hash_err);
+
+	if (meta->hint_valid & XDP_META_FIELD_TS) {
+		printf("rx_timestamp:  %llu (sec:%0.4f)\n", meta->rx_timestamp,
+		       (double)meta->rx_timestamp / NANOSEC_PER_SEC);
 
-	printf("rx_timestamp:  %llu (sec:%0.4f)\n", meta->rx_timestamp,
-	       (double)meta->rx_timestamp / NANOSEC_PER_SEC);
-	if (meta->rx_timestamp) {
 		__u64 usr_clock = gettime(clock_id);
 		__u64 xdp_clock = meta->xdp_timestamp;
 		__s64 delta_X = xdp_clock - meta->rx_timestamp;
@@ -179,8 +180,24 @@ static void verify_xdp_metadata(void *data, clockid_t clock_id)
 		       usr_clock, (double)usr_clock / NANOSEC_PER_SEC,
 		       (double)delta_X2U / NANOSEC_PER_SEC,
 		       (double)delta_X2U / 1000);
+	} else {
+		printf("No rx_timestamp, err=%d\n", meta->rx_timestamp_err);
 	}
 
+	if (meta->hint_valid & XDP_META_FIELD_CTAG)
+		printf("rx_ctag: %u\n", meta->rx_ctag);
+	else
+		printf("No rx_ctag, err=%d\n", meta->rx_ctag_err);
+
+	if (meta->hint_valid & XDP_META_FIELD_STAG)
+		printf("rx_stag: %u\n", meta->rx_stag);
+	else
+		printf("No rx_stag, err=%d\n", meta->rx_stag_err);
+
+	if (meta->hint_valid & XDP_META_FIELD_CSUM_LVL)
+		printf("Checksum was checked at level %u\n", meta->rx_csum_lvl);
+	else
+		printf("Checksum was not checked, err=%d\n", meta->rx_csum_err);
 }
 
 static void verify_skb_metadata(int fd)
diff --git a/tools/testing/selftests/bpf/xdp_metadata.h b/tools/testing/selftests/bpf/xdp_metadata.h
index 6664893c2c77..7c0267a8918a 100644
--- a/tools/testing/selftests/bpf/xdp_metadata.h
+++ b/tools/testing/selftests/bpf/xdp_metadata.h
@@ -17,12 +17,38 @@
 #define ETH_P_8021AD 0x88A8
 #endif
 
+#define BIT(nr)			(1 << (nr))
+
+enum xdp_meta_field {
+	XDP_META_FIELD_TS	= BIT(0),
+	XDP_META_FIELD_RSS	= BIT(1),
+	XDP_META_FIELD_CTAG	= BIT(2),
+	XDP_META_FIELD_STAG	= BIT(3),
+	XDP_META_FIELD_CSUM_LVL	= BIT(4),
+};
+
 struct xdp_meta {
-	__u64 rx_timestamp;
+	union {
+		__u64 rx_timestamp;
+		__s32 rx_timestamp_err;
+	};
 	__u64 xdp_timestamp;
 	__u32 rx_hash;
 	union {
 		__u32 rx_hash_type;
 		__s32 rx_hash_err;
 	};
+	union {
+		__u16 rx_ctag;
+		__s32 rx_ctag_err;
+	};
+	union {
+		__u16 rx_stag;
+		__s32 rx_stag_err;
+	};
+	union {
+		__u8 rx_csum_lvl;
+		__s32 rx_csum_err;
+	};
+	enum xdp_meta_field hint_valid;
 };
-- 
2.35.3



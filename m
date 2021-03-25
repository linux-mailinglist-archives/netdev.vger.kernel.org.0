Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 586AA349161
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 13:02:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230294AbhCYMBf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 08:01:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230096AbhCYMBZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Mar 2021 08:01:25 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97799C06174A;
        Thu, 25 Mar 2021 05:01:24 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id y200so1822735pfb.5;
        Thu, 25 Mar 2021 05:01:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0fvJcL4250HO5zd+wRl8/iAR+2lRRD0vrCW2L2g+W8M=;
        b=QUCtUqyy1Mb87DIgLOyo2rqhqbZ6H1lw0Y/wkAcBum52cHy6d91qRUZ647BmO7KDY7
         R516ow5i8coiHktuINCPjhxuQfvLtKWKSq4ZAEyoBTgeBGGutWrs2Bnqvd41kY94uax3
         w7Pqz5tROzxuhJ7sRfl355mZIw85wycQR01q4acrFFTAxMOIYAoDNiaFcseZ0xtiW8Q5
         2VuqzfTmcgPnS0lAaOkkpb4beLjqmU2TvMBf0rq/HnsgENMJxEyICCtLheOSZ2CJlOG+
         cw5G8/BwCLX0lURNGf0lSfYQIy1neBy9oq5nStLruKMC+8d3TBa1XjVHJFRFUacneiv+
         l/8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0fvJcL4250HO5zd+wRl8/iAR+2lRRD0vrCW2L2g+W8M=;
        b=tNaRcJKiWFYruWFyY0CP3or3kIkPduxd1rTCsG0zX1yWE/UBFjZ7y1ackF2FE/j9/n
         8behdlPMlXYVI/Yz2d5s6F6N2lZoi4xL5LiXEgdS97khtTPcGbkOklOc7tbHEDHaSU0k
         Ipf/GjYqI2qAP1e9YOCedbuZi+iqNQOGM15iB4xHZPeyig9GoXB9s531jERajf/itucU
         IrHNV249Na81pHIpy1+sPDJnYskLUKebR50LfGqYsozPfr2HXwh5pW2t94bqDGg59GxS
         YZPD34ELnp8+zLHZ0cu9Q6UR0cz0dcqBl26zmwvrTZGO/a9U8Mk0xDI54Ihp59Ys7zqv
         +H1A==
X-Gm-Message-State: AOAM533XqqiuBvu81Fg8/ATSIYBy6sfgNsYi7YEwqHc4GymaSY5PNIzh
        e2+Kwqlh4WezEP207liAlYtKbQ9mm7Yw2g==
X-Google-Smtp-Source: ABdhPJwecekan97o6w/dQ++hOmNI8x7RR9JUY6Jl/Vm2f6/0mA5I33P1RWPHfMerDdanwOZyv+az2Q==
X-Received: by 2002:a63:141e:: with SMTP id u30mr7495616pgl.31.1616673683845;
        Thu, 25 Mar 2021 05:01:23 -0700 (PDT)
Received: from localhost ([112.79.237.176])
        by smtp.gmail.com with ESMTPSA id fa21sm5594603pjb.25.2021.03.25.05.01.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Mar 2021 05:01:23 -0700 (PDT)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org
Cc:     brouer@redhat.com, Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Shuah Khan <shuah@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Subject: [PATCH bpf-next 1/5] tools pkt_cls.h: sync with kernel sources
Date:   Thu, 25 Mar 2021 17:29:59 +0530
Message-Id: <20210325120020.236504-2-memxor@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210325120020.236504-1-memxor@gmail.com>
References: <20210325120020.236504-1-memxor@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Update the header file so we can use the new defines in subsequent
patches.

Reviewed-by: Toke Høiland-Jørgensen <toke@redhat.com>
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 tools/include/uapi/linux/pkt_cls.h | 174 ++++++++++++++++++++++++++++-
 1 file changed, 170 insertions(+), 4 deletions(-)

diff --git a/tools/include/uapi/linux/pkt_cls.h b/tools/include/uapi/linux/pkt_cls.h
index 12153771396a..025c40fef93d 100644
--- a/tools/include/uapi/linux/pkt_cls.h
+++ b/tools/include/uapi/linux/pkt_cls.h
@@ -16,9 +16,36 @@ enum {
 	TCA_ACT_STATS,
 	TCA_ACT_PAD,
 	TCA_ACT_COOKIE,
+	TCA_ACT_FLAGS,
+	TCA_ACT_HW_STATS,
+	TCA_ACT_USED_HW_STATS,
 	__TCA_ACT_MAX
 };
 
+#define TCA_ACT_FLAGS_NO_PERCPU_STATS 1 /* Don't use percpu allocator for
+					 * actions stats.
+					 */
+
+/* tca HW stats type
+ * When user does not pass the attribute, he does not care.
+ * It is the same as if he would pass the attribute with
+ * all supported bits set.
+ * In case no bits are set, user is not interested in getting any HW statistics.
+ */
+#define TCA_ACT_HW_STATS_IMMEDIATE (1 << 0) /* Means that in dump, user
+					     * gets the current HW stats
+					     * state from the device
+					     * queried at the dump time.
+					     */
+#define TCA_ACT_HW_STATS_DELAYED (1 << 1) /* Means that in dump, user gets
+					   * HW stats that might be out of date
+					   * for some time, maybe couple of
+					   * seconds. This is the case when
+					   * driver polls stats updates
+					   * periodically or when it gets async
+					   * stats update from the device.
+					   */
+
 #define TCA_ACT_MAX __TCA_ACT_MAX
 #define TCA_OLD_COMPAT (TCA_ACT_MAX+1)
 #define TCA_ACT_MAX_PRIO 32
@@ -63,12 +90,53 @@ enum {
 #define TC_ACT_GOTO_CHAIN __TC_ACT_EXT(2)
 #define TC_ACT_EXT_OPCODE_MAX	TC_ACT_GOTO_CHAIN
 
+/* These macros are put here for binary compatibility with userspace apps that
+ * make use of them. For kernel code and new userspace apps, use the TCA_ID_*
+ * versions.
+ */
+#define TCA_ACT_GACT 5
+#define TCA_ACT_IPT 6
+#define TCA_ACT_PEDIT 7
+#define TCA_ACT_MIRRED 8
+#define TCA_ACT_NAT 9
+#define TCA_ACT_XT 10
+#define TCA_ACT_SKBEDIT 11
+#define TCA_ACT_VLAN 12
+#define TCA_ACT_BPF 13
+#define TCA_ACT_CONNMARK 14
+#define TCA_ACT_SKBMOD 15
+#define TCA_ACT_CSUM 16
+#define TCA_ACT_TUNNEL_KEY 17
+#define TCA_ACT_SIMP 22
+#define TCA_ACT_IFE 25
+#define TCA_ACT_SAMPLE 26
+
 /* Action type identifiers*/
-enum {
-	TCA_ID_UNSPEC=0,
-	TCA_ID_POLICE=1,
+enum tca_id {
+	TCA_ID_UNSPEC = 0,
+	TCA_ID_POLICE = 1,
+	TCA_ID_GACT = TCA_ACT_GACT,
+	TCA_ID_IPT = TCA_ACT_IPT,
+	TCA_ID_PEDIT = TCA_ACT_PEDIT,
+	TCA_ID_MIRRED = TCA_ACT_MIRRED,
+	TCA_ID_NAT = TCA_ACT_NAT,
+	TCA_ID_XT = TCA_ACT_XT,
+	TCA_ID_SKBEDIT = TCA_ACT_SKBEDIT,
+	TCA_ID_VLAN = TCA_ACT_VLAN,
+	TCA_ID_BPF = TCA_ACT_BPF,
+	TCA_ID_CONNMARK = TCA_ACT_CONNMARK,
+	TCA_ID_SKBMOD = TCA_ACT_SKBMOD,
+	TCA_ID_CSUM = TCA_ACT_CSUM,
+	TCA_ID_TUNNEL_KEY = TCA_ACT_TUNNEL_KEY,
+	TCA_ID_SIMP = TCA_ACT_SIMP,
+	TCA_ID_IFE = TCA_ACT_IFE,
+	TCA_ID_SAMPLE = TCA_ACT_SAMPLE,
+	TCA_ID_CTINFO,
+	TCA_ID_MPLS,
+	TCA_ID_CT,
+	TCA_ID_GATE,
 	/* other actions go here */
-	__TCA_ID_MAX=255
+	__TCA_ID_MAX = 255
 };
 
 #define TCA_ID_MAX __TCA_ID_MAX
@@ -120,6 +188,10 @@ enum {
 	TCA_POLICE_RESULT,
 	TCA_POLICE_TM,
 	TCA_POLICE_PAD,
+	TCA_POLICE_RATE64,
+	TCA_POLICE_PEAKRATE64,
+	TCA_POLICE_PKTRATE64,
+	TCA_POLICE_PKTBURST64,
 	__TCA_POLICE_MAX
 #define TCA_POLICE_RESULT TCA_POLICE_RESULT
 };
@@ -333,12 +405,19 @@ enum {
 
 /* Basic filter */
 
+struct tc_basic_pcnt {
+	__u64 rcnt;
+	__u64 rhit;
+};
+
 enum {
 	TCA_BASIC_UNSPEC,
 	TCA_BASIC_CLASSID,
 	TCA_BASIC_EMATCHES,
 	TCA_BASIC_ACT,
 	TCA_BASIC_POLICE,
+	TCA_BASIC_PCNT,
+	TCA_BASIC_PAD,
 	__TCA_BASIC_MAX
 };
 
@@ -485,17 +564,54 @@ enum {
 
 	TCA_FLOWER_IN_HW_COUNT,
 
+	TCA_FLOWER_KEY_PORT_SRC_MIN,	/* be16 */
+	TCA_FLOWER_KEY_PORT_SRC_MAX,	/* be16 */
+	TCA_FLOWER_KEY_PORT_DST_MIN,	/* be16 */
+	TCA_FLOWER_KEY_PORT_DST_MAX,	/* be16 */
+
+	TCA_FLOWER_KEY_CT_STATE,	/* u16 */
+	TCA_FLOWER_KEY_CT_STATE_MASK,	/* u16 */
+	TCA_FLOWER_KEY_CT_ZONE,		/* u16 */
+	TCA_FLOWER_KEY_CT_ZONE_MASK,	/* u16 */
+	TCA_FLOWER_KEY_CT_MARK,		/* u32 */
+	TCA_FLOWER_KEY_CT_MARK_MASK,	/* u32 */
+	TCA_FLOWER_KEY_CT_LABELS,	/* u128 */
+	TCA_FLOWER_KEY_CT_LABELS_MASK,	/* u128 */
+
+	TCA_FLOWER_KEY_MPLS_OPTS,
+
+	TCA_FLOWER_KEY_HASH,		/* u32 */
+	TCA_FLOWER_KEY_HASH_MASK,	/* u32 */
+
 	__TCA_FLOWER_MAX,
 };
 
 #define TCA_FLOWER_MAX (__TCA_FLOWER_MAX - 1)
 
+enum {
+	TCA_FLOWER_KEY_CT_FLAGS_NEW = 1 << 0, /* Beginning of a new connection. */
+	TCA_FLOWER_KEY_CT_FLAGS_ESTABLISHED = 1 << 1, /* Part of an existing connection. */
+	TCA_FLOWER_KEY_CT_FLAGS_RELATED = 1 << 2, /* Related to an established connection. */
+	TCA_FLOWER_KEY_CT_FLAGS_TRACKED = 1 << 3, /* Conntrack has occurred. */
+	TCA_FLOWER_KEY_CT_FLAGS_INVALID = 1 << 4, /* Conntrack is invalid. */
+	TCA_FLOWER_KEY_CT_FLAGS_REPLY = 1 << 5, /* Packet is in the reply direction. */
+	__TCA_FLOWER_KEY_CT_FLAGS_MAX,
+};
+
 enum {
 	TCA_FLOWER_KEY_ENC_OPTS_UNSPEC,
 	TCA_FLOWER_KEY_ENC_OPTS_GENEVE, /* Nested
 					 * TCA_FLOWER_KEY_ENC_OPT_GENEVE_
 					 * attributes
 					 */
+	TCA_FLOWER_KEY_ENC_OPTS_VXLAN,	/* Nested
+					 * TCA_FLOWER_KEY_ENC_OPT_VXLAN_
+					 * attributes
+					 */
+	TCA_FLOWER_KEY_ENC_OPTS_ERSPAN,	/* Nested
+					 * TCA_FLOWER_KEY_ENC_OPT_ERSPAN_
+					 * attributes
+					 */
 	__TCA_FLOWER_KEY_ENC_OPTS_MAX,
 };
 
@@ -513,18 +629,68 @@ enum {
 #define TCA_FLOWER_KEY_ENC_OPT_GENEVE_MAX \
 		(__TCA_FLOWER_KEY_ENC_OPT_GENEVE_MAX - 1)
 
+enum {
+	TCA_FLOWER_KEY_ENC_OPT_VXLAN_UNSPEC,
+	TCA_FLOWER_KEY_ENC_OPT_VXLAN_GBP,		/* u32 */
+	__TCA_FLOWER_KEY_ENC_OPT_VXLAN_MAX,
+};
+
+#define TCA_FLOWER_KEY_ENC_OPT_VXLAN_MAX \
+		(__TCA_FLOWER_KEY_ENC_OPT_VXLAN_MAX - 1)
+
+enum {
+	TCA_FLOWER_KEY_ENC_OPT_ERSPAN_UNSPEC,
+	TCA_FLOWER_KEY_ENC_OPT_ERSPAN_VER,              /* u8 */
+	TCA_FLOWER_KEY_ENC_OPT_ERSPAN_INDEX,            /* be32 */
+	TCA_FLOWER_KEY_ENC_OPT_ERSPAN_DIR,              /* u8 */
+	TCA_FLOWER_KEY_ENC_OPT_ERSPAN_HWID,             /* u8 */
+	__TCA_FLOWER_KEY_ENC_OPT_ERSPAN_MAX,
+};
+
+#define TCA_FLOWER_KEY_ENC_OPT_ERSPAN_MAX \
+		(__TCA_FLOWER_KEY_ENC_OPT_ERSPAN_MAX - 1)
+
+enum {
+	TCA_FLOWER_KEY_MPLS_OPTS_UNSPEC,
+	TCA_FLOWER_KEY_MPLS_OPTS_LSE,
+	__TCA_FLOWER_KEY_MPLS_OPTS_MAX,
+};
+
+#define TCA_FLOWER_KEY_MPLS_OPTS_MAX (__TCA_FLOWER_KEY_MPLS_OPTS_MAX - 1)
+
+enum {
+	TCA_FLOWER_KEY_MPLS_OPT_LSE_UNSPEC,
+	TCA_FLOWER_KEY_MPLS_OPT_LSE_DEPTH,
+	TCA_FLOWER_KEY_MPLS_OPT_LSE_TTL,
+	TCA_FLOWER_KEY_MPLS_OPT_LSE_BOS,
+	TCA_FLOWER_KEY_MPLS_OPT_LSE_TC,
+	TCA_FLOWER_KEY_MPLS_OPT_LSE_LABEL,
+	__TCA_FLOWER_KEY_MPLS_OPT_LSE_MAX,
+};
+
+#define TCA_FLOWER_KEY_MPLS_OPT_LSE_MAX \
+		(__TCA_FLOWER_KEY_MPLS_OPT_LSE_MAX - 1)
+
 enum {
 	TCA_FLOWER_KEY_FLAGS_IS_FRAGMENT = (1 << 0),
 	TCA_FLOWER_KEY_FLAGS_FRAG_IS_FIRST = (1 << 1),
 };
 
+#define TCA_FLOWER_MASK_FLAGS_RANGE	(1 << 0) /* Range-based match */
+
 /* Match-all classifier */
 
+struct tc_matchall_pcnt {
+	__u64 rhit;
+};
+
 enum {
 	TCA_MATCHALL_UNSPEC,
 	TCA_MATCHALL_CLASSID,
 	TCA_MATCHALL_ACT,
 	TCA_MATCHALL_FLAGS,
+	TCA_MATCHALL_PCNT,
+	TCA_MATCHALL_PAD,
 	__TCA_MATCHALL_MAX,
 };
 
-- 
2.30.2


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94072364179
	for <lists+netdev@lfdr.de>; Mon, 19 Apr 2021 14:20:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239157AbhDSMTB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 08:19:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239093AbhDSMS4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Apr 2021 08:18:56 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8C50C061760;
        Mon, 19 Apr 2021 05:18:26 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id g16so9760022pfq.5;
        Mon, 19 Apr 2021 05:18:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3kf2IR+vyr2ZS9j3pXYnVjnrecvHBRgA8KdfYqYNGqw=;
        b=fMb8DaDUXqLYSfB7qnEBKxJnSKgbeOVt3cu+7AWXElc99KxdQPkL3Q1YZu3AXv0LYp
         oI/mupDqDyJ/0jLd5l71aI1WomV2EmMA85mzcCwQPkbmRB38RlGc35w5FZMEG8K16Ed7
         mrFuvP9JlfFrPUlq3MVVgtEgq+fgHyjE2dXvbndFBbB4tPoLhcKw9Hxs5Uc8SwKMsnNf
         jKXaqBNjfHs98cENngjJKlqBfJ4/oICPCeXc+Qgtov5WWZJP4vWNQI8yOnn7PeOqcHGS
         GLwgT3wl2MRDeTRknsx3bTe96KQl5v2qu45BQT6EdVd3Ay+twuVqIfRs5Jys3Oznrnov
         Q0KQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3kf2IR+vyr2ZS9j3pXYnVjnrecvHBRgA8KdfYqYNGqw=;
        b=Hk33TujnsqIleWdsFrsxrEbaAMJUmaTQpQfsp0q4hpWR1Ibj5Ge5bqPHbQVZKmXgZ8
         XTSKOT/HOq57gEOcjvodMW7RGheTGbl9TrlSLctaoz4IAUtOmPKdZLNa0/2xZ7twwN9A
         OfuwNelo2C1MS0S7dsYBWe4a5OyU3GJwqsWClp/krfosaHc2ux/V6ykpH/BycC+e4sdN
         or75HAYQXLREDmbDLra37NwUpXKo9c93SzNpiPR2JLygZFk4vOjKGkKYd5G1PonqqM/q
         TnCzh7uXeo1xj8NL60KoN4MItEscrWlIpBAX9pAsiDj9lNQ7Ue4HUf5Y32MAS18YRYa3
         d1KA==
X-Gm-Message-State: AOAM530CxJyp+WEySAidluuPGMKr97hjP76Bu9o76GpUIPSh3hmD1rep
        YDZfipmiLHQ8dIvJ3O0VbgCmugKPDWVNFQ==
X-Google-Smtp-Source: ABdhPJyiWfAxATro6hJA85x/67mBYoJYhqS0BzEXv2Llh2hOUu6WKzBFeJ0IG/e7hYVgxZny9fpH7g==
X-Received: by 2002:aa7:90d3:0:b029:241:21a1:6ffb with SMTP id k19-20020aa790d30000b029024121a16ffbmr19249973pfk.43.1618834706025;
        Mon, 19 Apr 2021 05:18:26 -0700 (PDT)
Received: from localhost ([112.79.253.181])
        by smtp.gmail.com with ESMTPSA id d17sm12137001pfn.60.2021.04.19.05.18.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Apr 2021 05:18:25 -0700 (PDT)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH bpf-next v2 1/4] tools: pkt_cls.h: sync with kernel sources
Date:   Mon, 19 Apr 2021 17:48:08 +0530
Message-Id: <20210419121811.117400-2-memxor@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210419121811.117400-1-memxor@gmail.com>
References: <20210419121811.117400-1-memxor@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Update the header file so we can use the new defines in subsequent
patches. Also make sure they remain up to date.

Reviewed-by: Toke Høiland-Jørgensen <toke@redhat.com>
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 tools/include/uapi/linux/pkt_cls.h | 174 ++++++++++++++++++++++++++++-
 tools/lib/bpf/Makefile             |   3 +
 2 files changed, 173 insertions(+), 4 deletions(-)

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
 
diff --git a/tools/lib/bpf/Makefile b/tools/lib/bpf/Makefile
index e43e1896cb4b..745624d91a01 100644
--- a/tools/lib/bpf/Makefile
+++ b/tools/lib/bpf/Makefile
@@ -152,6 +152,9 @@ $(BPF_IN_SHARED): force $(BPF_HELPER_DEFS)
 	@(test -f ../../include/uapi/linux/if_xdp.h -a -f ../../../include/uapi/linux/if_xdp.h && ( \
 	(diff -B ../../include/uapi/linux/if_xdp.h ../../../include/uapi/linux/if_xdp.h >/dev/null) || \
 	echo "Warning: Kernel ABI header at 'tools/include/uapi/linux/if_xdp.h' differs from latest version at 'include/uapi/linux/if_xdp.h'" >&2 )) || true
+	@(test -f ../../include/uapi/linux/pkt_cls.h -a -f ../../../include/uapi/linux/pkt_cls.h && ( \
+	(diff -B ../../include/uapi/linux/pkt_cls.h ../../../include/uapi/linux/pkt_cls.h >/dev/null) || \
+	echo "Warning: Kernel ABI header at 'tools/include/uapi/linux/pkt_cls.h' differs from latest version at 'include/uapi/linux/pkt_cls.h'" >&2 )) || true
 	$(Q)$(MAKE) $(build)=libbpf OUTPUT=$(SHARED_OBJDIR) CFLAGS="$(CFLAGS) $(SHLIB_FLAGS)"
 
 $(BPF_IN_STATIC): force $(BPF_HELPER_DEFS)
-- 
2.30.2


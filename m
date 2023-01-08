Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B66E7661609
	for <lists+netdev@lfdr.de>; Sun,  8 Jan 2023 16:11:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233169AbjAHPLk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Jan 2023 10:11:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229822AbjAHPLj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Jan 2023 10:11:39 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49A7E6265;
        Sun,  8 Jan 2023 07:11:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673190698; x=1704726698;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=3aSyeGbeMNfHDYKc5OXsAMpLIkaVT1dnok7Bt0nCv9I=;
  b=FqIlfoQ0wMhk/JOx5a6VgPu+3qZX/eRX88Pm9rJZCSGcJ/p2vEvCyfRo
   IkqWchwOC/2gPynA3xt56ONgxpTORstYLuj2rSDCUqCDIzLboPr1L91XK
   S7gHTMdMTtfAi5xjHFriN6beO77fFLy2wilS3QykNW8RwAr5gqpcoz7ab
   ogKiwh5th7kk64ZupRo+sNBawxKgwBeNM6VddvZbFUZXlB3bM3gyYwPr9
   3t0c2VyGerkYjlG7Jc6hi8VzKXWFVLTWf+779mEZs1E5q3WDGtuDqCfxj
   kWj7I5Q8SVIrANbc+wSeUQbZioIV9IX1lavD23pLhdKCxOSymvrMtV6e9
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10584"; a="349941525"
X-IronPort-AV: E=Sophos;i="5.96,310,1665471600"; 
   d="scan'208";a="349941525"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jan 2023 07:11:37 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10584"; a="658348255"
X-IronPort-AV: E=Sophos;i="5.96,310,1665471600"; 
   d="scan'208";a="658348255"
Received: from sse-cse-haiyue-nuc.sh.intel.com ([10.239.241.114])
  by fmsmga007.fm.intel.com with ESMTP; 08 Jan 2023 07:11:33 -0800
From:   Haiyue Wang <haiyue.wang@intel.com>
To:     bpf@vger.kernel.org
Cc:     Haiyue Wang <haiyue.wang@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        netdev@vger.kernel.org (open list:BPF [NETWORKING] (tc BPF, sock_addr)),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH bpf-next v1] bpf: Remove the unnecessary insn buffer comparison
Date:   Sun,  8 Jan 2023 23:12:57 +0800
Message-Id: <20230108151258.96570-1-haiyue.wang@intel.com>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The variable 'insn' is initialized to 'insn_buf' without being changed,
only some helper macros are defined, so the insn buffer comparison is
unnecessary, just remove it.

Signed-off-by: Haiyue Wang <haiyue.wang@intel.com>
---
 net/core/filter.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/net/core/filter.c b/net/core/filter.c
index ab811293ae5d..d9befa6ba04e 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -6847,9 +6847,6 @@ u32 bpf_tcp_sock_convert_ctx_access(enum bpf_access_type type,
 					FIELD));			\
 	} while (0)
 
-	if (insn > insn_buf)
-		return insn - insn_buf;
-
 	switch (si->off) {
 	case offsetof(struct bpf_tcp_sock, rtt_min):
 		BUILD_BUG_ON(sizeof_field(struct tcp_sock, rtt_min) !=
@@ -10147,9 +10144,6 @@ static u32 sock_ops_convert_ctx_access(enum bpf_access_type type,
 			SOCK_OPS_GET_FIELD(BPF_FIELD, OBJ_FIELD, OBJ);	      \
 	} while (0)
 
-	if (insn > insn_buf)
-		return insn - insn_buf;
-
 	switch (si->off) {
 	case offsetof(struct bpf_sock_ops, op):
 		*insn++ = BPF_LDX_MEM(BPF_FIELD_SIZEOF(struct bpf_sock_ops_kern,
-- 
2.39.0


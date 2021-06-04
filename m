Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F3E939B011
	for <lists+netdev@lfdr.de>; Fri,  4 Jun 2021 03:54:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230124AbhFDBzv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 21:55:51 -0400
Received: from mail-pf1-f180.google.com ([209.85.210.180]:36353 "EHLO
        mail-pf1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229576AbhFDBzu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Jun 2021 21:55:50 -0400
Received: by mail-pf1-f180.google.com with SMTP id c12so6340500pfl.3;
        Thu, 03 Jun 2021 18:53:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wBg06JBpiPCzgvoJ4HY+DQglchFViQwPvQYbexv1VvI=;
        b=J7CZDMGflxAkoaz4zNQRN/MDQCXtr/sHow7cgB8Jr2WGgwjl7Tu6ycwSbc0rQGZ8+9
         nh2AI1LIeI/KM6bQifGDyjVaQD3SAU9Dfs/nAU1cybc8ntJrKFQ12qlJ2Zu9Sql10ETA
         chUwj0v15TsD6QEp8QvRawmAAE+IviEQ4zMRkmcUhDd3/Egbcc5KEWOT6bT8mYR8GQn+
         DliO/Xc5Xcg0Grg/evOo/AoUEZomnithpuEO3ZeaalyPyd5UT3j0HAiFgg4epXkZgUAk
         xh+xy5aWWY6X63hFVRukALs7t8vaCJIv/n5mWSjFnGIRtzzGfJAmm6g7HBz23B60Uqe9
         rBtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wBg06JBpiPCzgvoJ4HY+DQglchFViQwPvQYbexv1VvI=;
        b=tn15DPw9Rmu0NLiKK6UifBMn4zVHjyTmWuRmp/VRdl3gD7sxbf4zI5AoOFWhGQSZKk
         772o9+APyf4PRA2U27Eiy6IIVff5HLYOsdQpBE9fkxoN8IScFNOxHWHTC8Od1XdLx3af
         U8oyXpqvYlX6qv9+FFvUxTWifWtxWucTeEnhW1sQCBr4ZKYIfg4NfpxaXaRzIAXiGX8/
         X7zMWUm48aNXGlPtBCF8H7KpZVTDaCao7G1PKmSeT/1FHnaV4jWLyNf2GKYovlegdYOQ
         bpEExwtW5Ct0oR90FXCNj6Z22CPQGBzMp4/UJIyIYvG33EKYSrzbanUTQdV4V2aGRzdK
         8hKw==
X-Gm-Message-State: AOAM531HorAYiN0h8y14qZMzoaRTVvl7yWweeeQgOsVLdmDA/wnTD0bc
        8N+DPFnoARZ9e+qx9/EHRtc=
X-Google-Smtp-Source: ABdhPJyLezzkJaJdoYuq76C9UPYY5C26bq1ehr7BHzIkk1tSJGa9IAH93tWSh1xjdPcekd79SMsnlw==
X-Received: by 2002:a63:581c:: with SMTP id m28mr2353577pgb.353.1622771570513;
        Thu, 03 Jun 2021 18:52:50 -0700 (PDT)
Received: from athina.mtv.corp.google.com ([2620:15c:211:0:c45:b07d:e001:d01])
        by smtp.gmail.com with ESMTPSA id c130sm274502pfc.51.2021.06.03.18.52.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Jun 2021 18:52:49 -0700 (PDT)
From:   =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <zenczykowski@gmail.com>
To:     =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     Linux Network Development Mailing List <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        BPF Mailing List <bpf@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Dongseok Yi <dseok.yi@samsung.com>,
        Willem de Bruijn <willemb@google.com>
Subject: [PATCH bpf-next 1/2] Revert "bpf: Check for BPF_F_ADJ_ROOM_FIXED_GSO when bpf_skb_change_proto"
Date:   Thu,  3 Jun 2021 18:52:37 -0700
Message-Id: <20210604015238.2422145-1-zenczykowski@gmail.com>
X-Mailer: git-send-email 2.32.0.rc1.229.g3e70b5a671-goog
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maciej Żenczykowski <maze@google.com>

This reverts commit fa7b83bf3b156c767f3e4a25bbf3817b08f3ff8e.

See the followup commit for the reasoning why I believe the appropriate
approach is to simply make this change without a flag, but it can basically
be summarized as using this helper without the flag is bug-prone or outright
buggy, and thus the default should be this new behaviour.

As this commit has only made it into net-next/master, but not into
any real release, such a backwards incompatible change is still ok.

Cc: Dongseok Yi <dseok.yi@samsung.com>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Willem de Bruijn <willemb@google.com>
Signed-off-by: Maciej Żenczykowski <maze@google.com>
---
 net/core/filter.c | 22 +++++++++-------------
 1 file changed, 9 insertions(+), 13 deletions(-)

diff --git a/net/core/filter.c b/net/core/filter.c
index caa88955562e..04848de3e058 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -3235,7 +3235,7 @@ static int bpf_skb_net_hdr_pop(struct sk_buff *skb, u32 off, u32 len)
 	return ret;
 }
 
-static int bpf_skb_proto_4_to_6(struct sk_buff *skb, u64 flags)
+static int bpf_skb_proto_4_to_6(struct sk_buff *skb)
 {
 	const u32 len_diff = sizeof(struct ipv6hdr) - sizeof(struct iphdr);
 	u32 off = skb_mac_header_len(skb);
@@ -3264,9 +3264,7 @@ static int bpf_skb_proto_4_to_6(struct sk_buff *skb, u64 flags)
 		}
 
 		/* Due to IPv6 header, MSS needs to be downgraded. */
-		if (!(flags & BPF_F_ADJ_ROOM_FIXED_GSO))
-			skb_decrease_gso_size(shinfo, len_diff);
-
+		skb_decrease_gso_size(shinfo, len_diff);
 		/* Header must be checked, and gso_segs recomputed. */
 		shinfo->gso_type |= SKB_GSO_DODGY;
 		shinfo->gso_segs = 0;
@@ -3278,7 +3276,7 @@ static int bpf_skb_proto_4_to_6(struct sk_buff *skb, u64 flags)
 	return 0;
 }
 
-static int bpf_skb_proto_6_to_4(struct sk_buff *skb, u64 flags)
+static int bpf_skb_proto_6_to_4(struct sk_buff *skb)
 {
 	const u32 len_diff = sizeof(struct ipv6hdr) - sizeof(struct iphdr);
 	u32 off = skb_mac_header_len(skb);
@@ -3307,9 +3305,7 @@ static int bpf_skb_proto_6_to_4(struct sk_buff *skb, u64 flags)
 		}
 
 		/* Due to IPv4 header, MSS can be upgraded. */
-		if (!(flags & BPF_F_ADJ_ROOM_FIXED_GSO))
-			skb_increase_gso_size(shinfo, len_diff);
-
+		skb_increase_gso_size(shinfo, len_diff);
 		/* Header must be checked, and gso_segs recomputed. */
 		shinfo->gso_type |= SKB_GSO_DODGY;
 		shinfo->gso_segs = 0;
@@ -3321,17 +3317,17 @@ static int bpf_skb_proto_6_to_4(struct sk_buff *skb, u64 flags)
 	return 0;
 }
 
-static int bpf_skb_proto_xlat(struct sk_buff *skb, __be16 to_proto, u64 flags)
+static int bpf_skb_proto_xlat(struct sk_buff *skb, __be16 to_proto)
 {
 	__be16 from_proto = skb->protocol;
 
 	if (from_proto == htons(ETH_P_IP) &&
 	      to_proto == htons(ETH_P_IPV6))
-		return bpf_skb_proto_4_to_6(skb, flags);
+		return bpf_skb_proto_4_to_6(skb);
 
 	if (from_proto == htons(ETH_P_IPV6) &&
 	      to_proto == htons(ETH_P_IP))
-		return bpf_skb_proto_6_to_4(skb, flags);
+		return bpf_skb_proto_6_to_4(skb);
 
 	return -ENOTSUPP;
 }
@@ -3341,7 +3337,7 @@ BPF_CALL_3(bpf_skb_change_proto, struct sk_buff *, skb, __be16, proto,
 {
 	int ret;
 
-	if (unlikely(flags & ~(BPF_F_ADJ_ROOM_FIXED_GSO)))
+	if (unlikely(flags))
 		return -EINVAL;
 
 	/* General idea is that this helper does the basic groundwork
@@ -3361,7 +3357,7 @@ BPF_CALL_3(bpf_skb_change_proto, struct sk_buff *, skb, __be16, proto,
 	 * that. For offloads, we mark packet as dodgy, so that headers
 	 * need to be verified first.
 	 */
-	ret = bpf_skb_proto_xlat(skb, proto, flags);
+	ret = bpf_skb_proto_xlat(skb, proto);
 	bpf_compute_data_pointers(skb);
 	return ret;
 }
-- 
2.32.0.rc1.229.g3e70b5a671-goog


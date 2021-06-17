Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08F983AA7E8
	for <lists+netdev@lfdr.de>; Thu, 17 Jun 2021 02:10:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234883AbhFQAMQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 20:12:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230481AbhFQAMP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Jun 2021 20:12:15 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36A79C061574;
        Wed, 16 Jun 2021 17:10:07 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id e7so1990202plj.7;
        Wed, 16 Jun 2021 17:10:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=UHZ5YMekjSRT+s0xrshOz5js1a8Rx9jxwpgPSLh3c50=;
        b=VcPw2lDwWr8gXttl6/n11H2bPuN7FSdlgQb0nNY2CZT4rrtr62H5uf0D3JNbyUYN9v
         gsmSS0OHfQ7c9KUdEXSNfEfvkTZLtkX9+bN/rLrl0g+934gYyKR1svtXcU19qoQv3YNP
         QhmI4XgFWin3PmmAv1BoROOMLi3vTtj8xwabXCwsmcZcaHFJSoMha5Z704wIlJR1T82H
         JWw/XS6qbHWYDm6c+wGKPeT2XeEwFZkaYC0dNpu559fwAXBSIdlaTkBIZlcG+cRJ2LAt
         YVu1rPMcbuNQmWcxTrv7+TylTGnhgw/9qhwqkFLpebAeSc/yMtR5gCin/ZUWjSVJcSus
         84tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UHZ5YMekjSRT+s0xrshOz5js1a8Rx9jxwpgPSLh3c50=;
        b=FT4zKuljCvd7K69zFgH3d35DuTyi7xPL3SWOvCrO8oYIolGzzWj9RTEusGqVdCKedk
         UNbHQ+QzzRg2TzFPvTu84010XK61uuggS+iuF2ydI5umkkweUjrXyG+W4IcwRA55iKG/
         r1ZpmFXgtQtH5nnoNErI9FN1PqDXrtNqePsOW4ci6V498NCRMofP0FsB5tnxDoZVwR2R
         gpw1QGwKvAB8XKffxmf7n4/fWrpyeh+vPgqgeBb0FciMPXd2/5YMgjthSuKXYvyN76a5
         TLEr23lXExLZHV5osRrZJov5Om6mKr6Fy42o4sMCNofhmPnC5bIHaABOwc+3m+d279+R
         kqoQ==
X-Gm-Message-State: AOAM5314HPFU9two+Vhlv8YmrgbdvAUkO3B9wsY1638DViQGgtbOVamN
        Cf0FpDr8cqIFu1Lm9gi9Gi0=
X-Google-Smtp-Source: ABdhPJwzbbuVxuncCTkspM/BldbgMP+QMLtdFrOs8MgJF15b0MYiY/1TxZyqoEp1K+K6XFBYKVUnIA==
X-Received: by 2002:a17:90a:5907:: with SMTP id k7mr2474463pji.46.1623888606695;
        Wed, 16 Jun 2021 17:10:06 -0700 (PDT)
Received: from athina.mtv.corp.google.com ([2620:15c:211:200:926a:e8dd:9095:3ddd])
        by smtp.gmail.com with ESMTPSA id r92sm6599633pja.6.2021.06.16.17.10.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Jun 2021 17:10:06 -0700 (PDT)
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
Subject: [PATCH bpf-next v2 1/4] Revert "bpf: Check for BPF_F_ADJ_ROOM_FIXED_GSO when bpf_skb_change_proto"
Date:   Wed, 16 Jun 2021 17:09:50 -0700
Message-Id: <20210617000953.2787453-1-zenczykowski@gmail.com>
X-Mailer: git-send-email 2.32.0.272.g935e593368-goog
In-Reply-To: <CANP3RGfjLikQ6dg=YpBU0OeHvyv7JOki7CyOUS9modaXAi-9vQ@mail.gmail.com>
References: <CANP3RGfjLikQ6dg=YpBU0OeHvyv7JOki7CyOUS9modaXAi-9vQ@mail.gmail.com>
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
index 239de1306de9..65ab4e21c087 100644
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
2.32.0.272.g935e593368-goog


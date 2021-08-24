Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EA403F5889
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 08:55:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232245AbhHXG4W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Aug 2021 02:56:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231292AbhHXG4T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Aug 2021 02:56:19 -0400
Received: from mail-qv1-xf2a.google.com (mail-qv1-xf2a.google.com [IPv6:2607:f8b0:4864:20::f2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54DC7C061575;
        Mon, 23 Aug 2021 23:55:35 -0700 (PDT)
Received: by mail-qv1-xf2a.google.com with SMTP id q6so11123178qvs.12;
        Mon, 23 Aug 2021 23:55:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rFn2OBk8wKvVC+gZ/hQgYxD/xSmcUa/BDPBqvKKIdBI=;
        b=VjeL2PFMDB4tOdxkWq5ym5nPBpEKH+3JcCJ8c5yezlH7cmtu3vmExu932AwLBtJXDE
         ZdYUCNw4HPOPt/QVNL/TUBduSeqXAy1c+lkwTE5VanOFiS1qHiVRXfJ4ixhf/cfPvlZs
         8tuDASNRfOycPCbF8J7fA4kDVXUkAkxh62cktbLr8zHaF8uek7RgPMSHVIkmhgeZ/bGS
         Lsq7E5yAiZxARsAYKFnGnEF4BTT1U+8prRB8OW0KF5YysSUF3Svut3D5GR2bd0kudskv
         4eEvWb4O+szxHHxg5lQagOa/wzPGsGKPHwVJqTIFEkupBtCJd180HpPNJwJqSfTi6exH
         odhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rFn2OBk8wKvVC+gZ/hQgYxD/xSmcUa/BDPBqvKKIdBI=;
        b=SPJWxQL095wnv0ALlf6FPKr7wW6HK/OurngfIKnuND0zw4eRTL50r4fhdxbh0K6e6n
         +zNmmd7QHT1rvLt75O1qLh2mCFv9q8ZgccKErFWYnnIBlO6yXZ1CvvDnHIUolGLQVUcG
         s0MFK3krnd/aL0H1hLjshMoDIDqSUE4Z3mm8X3Hs4SsdO9yObk9CPqil73RE5KXQSnYe
         jw0Et+yZR3/Rr3yXz1eXpqAkJmvGELhPSFqaCt/8mcAfSJbqyaYlb6psISrfEpR/w8ty
         E642D/2iyVQu79IG2FTnU2YtL1SPsKwnv+/8AxpFRc+gBtDPSXwEdp9+5mZhIB2svo2E
         ggSQ==
X-Gm-Message-State: AOAM531HXhBvG9GtEPsJsinPNtk1PL/11ZrNJcySqGeaRb1cXEYE0jtE
        lZQ5XfdmyV8lX0fJe7KdD5I=
X-Google-Smtp-Source: ABdhPJxO8MfhmUTISjdPZLZcgmb+LCRa4h1ZOm4rFbosDMrWxlSORWm9iGvz4e87TsUsQyYyDDa9kg==
X-Received: by 2002:a05:6214:410e:: with SMTP id kc14mr37712503qvb.33.1629788134597;
        Mon, 23 Aug 2021 23:55:34 -0700 (PDT)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id j184sm10420617qkd.74.2021.08.23.23.55.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Aug 2021 23:55:34 -0700 (PDT)
From:   CGEL <cgel.zte@gmail.com>
X-Google-Original-From: CGEL <deng.changcheng@zte.com.cn>
To:     Alexei Starovoitov <ast@kernel.org>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Yonghong Song <yhs@fb.com>, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jing Yangyang <jing.yangyang@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH linux-next] tools:test_xdp_noinline: fix boolreturn.cocci warnings
Date:   Mon, 23 Aug 2021 23:55:26 -0700
Message-Id: <20210824065526.60416-1-deng.changcheng@zte.com.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jing Yangyang <jing.yangyang@zte.com.cn>

Return statements in functions returning bool should use true/false
instead of 1/0.

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Jing Yangyang <jing.yangyang@zte.com.cn>
---
 .../selftests/bpf/progs/test_xdp_noinline.c        | 42 +++++++++++-----------
 1 file changed, 21 insertions(+), 21 deletions(-)

diff --git a/tools/testing/selftests/bpf/progs/test_xdp_noinline.c b/tools/testing/selftests/bpf/progs/test_xdp_noinline.c
index 3a67921..37075f8 100644
--- a/tools/testing/selftests/bpf/progs/test_xdp_noinline.c
+++ b/tools/testing/selftests/bpf/progs/test_xdp_noinline.c
@@ -239,7 +239,7 @@ bool parse_udp(void *data, void *data_end,
 	udp = data + off;
 
 	if (udp + 1 > data_end)
-		return 0;
+		return false;
 	if (!is_icmp) {
 		pckt->flow.port16[0] = udp->source;
 		pckt->flow.port16[1] = udp->dest;
@@ -247,7 +247,7 @@ bool parse_udp(void *data, void *data_end,
 		pckt->flow.port16[0] = udp->dest;
 		pckt->flow.port16[1] = udp->source;
 	}
-	return 1;
+	return true;
 }
 
 static __attribute__ ((noinline))
@@ -261,7 +261,7 @@ bool parse_tcp(void *data, void *data_end,
 
 	tcp = data + off;
 	if (tcp + 1 > data_end)
-		return 0;
+		return false;
 	if (tcp->syn)
 		pckt->flags |= (1 << 1);
 	if (!is_icmp) {
@@ -271,7 +271,7 @@ bool parse_tcp(void *data, void *data_end,
 		pckt->flow.port16[0] = tcp->dest;
 		pckt->flow.port16[1] = tcp->source;
 	}
-	return 1;
+	return true;
 }
 
 static __attribute__ ((noinline))
@@ -287,7 +287,7 @@ bool encap_v6(struct xdp_md *xdp, struct ctl_value *cval,
 	void *data;
 
 	if (bpf_xdp_adjust_head(xdp, 0 - (int)sizeof(struct ipv6hdr)))
-		return 0;
+		return false;
 	data = (void *)(long)xdp->data;
 	data_end = (void *)(long)xdp->data_end;
 	new_eth = data;
@@ -295,7 +295,7 @@ bool encap_v6(struct xdp_md *xdp, struct ctl_value *cval,
 	old_eth = data + sizeof(struct ipv6hdr);
 	if (new_eth + 1 > data_end ||
 	    old_eth + 1 > data_end || ip6h + 1 > data_end)
-		return 0;
+		return false;
 	memcpy(new_eth->eth_dest, cval->mac, 6);
 	memcpy(new_eth->eth_source, old_eth->eth_dest, 6);
 	new_eth->eth_proto = 56710;
@@ -314,7 +314,7 @@ bool encap_v6(struct xdp_md *xdp, struct ctl_value *cval,
 	ip6h->saddr.in6_u.u6_addr32[2] = 3;
 	ip6h->saddr.in6_u.u6_addr32[3] = ip_suffix;
 	memcpy(ip6h->daddr.in6_u.u6_addr32, dst->dstv6, 16);
-	return 1;
+	return true;
 }
 
 static __attribute__ ((noinline))
@@ -335,7 +335,7 @@ bool encap_v4(struct xdp_md *xdp, struct ctl_value *cval,
 	ip_suffix <<= 15;
 	ip_suffix ^= pckt->flow.src;
 	if (bpf_xdp_adjust_head(xdp, 0 - (int)sizeof(struct iphdr)))
-		return 0;
+		return false;
 	data = (void *)(long)xdp->data;
 	data_end = (void *)(long)xdp->data_end;
 	new_eth = data;
@@ -343,7 +343,7 @@ bool encap_v4(struct xdp_md *xdp, struct ctl_value *cval,
 	old_eth = data + sizeof(struct iphdr);
 	if (new_eth + 1 > data_end ||
 	    old_eth + 1 > data_end || iph + 1 > data_end)
-		return 0;
+		return false;
 	memcpy(new_eth->eth_dest, cval->mac, 6);
 	memcpy(new_eth->eth_source, old_eth->eth_dest, 6);
 	new_eth->eth_proto = 8;
@@ -367,8 +367,8 @@ bool encap_v4(struct xdp_md *xdp, struct ctl_value *cval,
 		csum += *next_iph_u16++;
 	iph->check = ~((csum & 0xffff) + (csum >> 16));
 	if (bpf_xdp_adjust_head(xdp, (int)sizeof(struct iphdr)))
-		return 0;
-	return 1;
+		return false;
+	return true;
 }
 
 static __attribute__ ((noinline))
@@ -386,10 +386,10 @@ bool decap_v6(struct xdp_md *xdp, void **data, void **data_end, bool inner_v4)
 	else
 		new_eth->eth_proto = 56710;
 	if (bpf_xdp_adjust_head(xdp, (int)sizeof(struct ipv6hdr)))
-		return 0;
+		return false;
 	*data = (void *)(long)xdp->data;
 	*data_end = (void *)(long)xdp->data_end;
-	return 1;
+	return true;
 }
 
 static __attribute__ ((noinline))
@@ -404,10 +404,10 @@ bool decap_v4(struct xdp_md *xdp, void **data, void **data_end)
 	memcpy(new_eth->eth_dest, old_eth->eth_dest, 6);
 	new_eth->eth_proto = 8;
 	if (bpf_xdp_adjust_head(xdp, (int)sizeof(struct iphdr)))
-		return 0;
+		return false;
 	*data = (void *)(long)xdp->data;
 	*data_end = (void *)(long)xdp->data_end;
-	return 1;
+	return true;
 }
 
 static __attribute__ ((noinline))
@@ -564,22 +564,22 @@ static bool get_packet_dst(struct real_definition **real,
 	hash = get_packet_hash(pckt, hash_16bytes);
 	if (hash != 0x358459b7 /* jhash of ipv4 packet */  &&
 	    hash != 0x2f4bc6bb /* jhash of ipv6 packet */)
-		return 0;
+		return false;
 	key = 2 * vip_info->vip_num + hash % 2;
 	real_pos = bpf_map_lookup_elem(&ch_rings, &key);
 	if (!real_pos)
-		return 0;
+		return false;
 	key = *real_pos;
 	*real = bpf_map_lookup_elem(&reals, &key);
 	if (!(*real))
-		return 0;
+		return false;
 	if (!(vip_info->flags & (1 << 1))) {
 		__u32 conn_rate_key = 512 + 2;
 		struct lb_stats *conn_rate_stats =
 		    bpf_map_lookup_elem(&stats, &conn_rate_key);
 
 		if (!conn_rate_stats)
-			return 1;
+			return true;
 		cur_time = bpf_ktime_get_ns();
 		if ((cur_time - conn_rate_stats->v2) >> 32 > 0xffFFFF) {
 			conn_rate_stats->v1 = 1;
@@ -587,14 +587,14 @@ static bool get_packet_dst(struct real_definition **real,
 		} else {
 			conn_rate_stats->v1 += 1;
 			if (conn_rate_stats->v1 >= 1)
-				return 1;
+				return true;
 		}
 		if (pckt->flow.proto == IPPROTO_UDP)
 			new_dst_lru.atime = cur_time;
 		new_dst_lru.pos = key;
 		bpf_map_update_elem(lru_map, &pckt->flow, &new_dst_lru, 0);
 	}
-	return 1;
+	return true;
 }
 
 __attribute__ ((noinline))
-- 
1.8.3.1



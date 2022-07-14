Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC28A57411B
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 03:57:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232172AbiGNB5f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 21:57:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229725AbiGNB5e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 21:57:34 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CCD522BDF;
        Wed, 13 Jul 2022 18:57:34 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id f11so230347pgj.7;
        Wed, 13 Jul 2022 18:57:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=QEFD8UEDLflLNqgQcLwFXDM2cd0cOwEDdb9XlhbH4ys=;
        b=oK3booY/UKJedbrTI8072q/AFTCHy6bKPeZiP60iqUX+NvM828d1MK//+Qq5X4qZm1
         iGH/WKGPYJHroGrihMamfl0srlCm3/PuA100aWHULdkJFALA5AkpvJ8mLZgXErJlLdfe
         4DpvV6ORfwkwdmMVu0HdzYrVw6FuSZEdv7+NfO+01mu0Y0ytbzfp/bGyuPx9oxsDyyzr
         P74pRr49NfVqECJYlF7WZnuNwUoio8/+j3unEUFG4VSgFdqdS9Ja4EywjeFa/T3uZi7m
         ak6HzNyEuIC40A8axsPoqKgGnvlx/0RpwJLc2M+ppAoiGZ2Usp4stZb8SZtesu3f9aMy
         tXsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=QEFD8UEDLflLNqgQcLwFXDM2cd0cOwEDdb9XlhbH4ys=;
        b=GboMEZG5k0ZpeTxguBd4WqShhCSQ6/JimEpi2G+GSJ5+fqD3tqHclnXxZzIJIYKMgy
         xMQ7bJyhNCZrB1UqyOz4JS1NTCdRiH7N+4Z8icHXOxh1DcHyyyj3uVVzMou4WfI7Cdeq
         cL1/VLS1c+RtaBuz42975rUZJwabGBvnUQedLJaRpq8dvgjxK6m/czvjm480cB0qJDRf
         Vlz1Wmll7Gxl7fgT3gfaQEw74qA8zgHkcCAS2eVigf0XPyN4d7WdWVFqx8bqgA0HXzsW
         Pnyu6q99Dpg7NItp12luO2pczCb3LgSnt5dJ7rUm3A6DCtTPgBEub8Ef4Pa4cAqmiGhR
         U1Hg==
X-Gm-Message-State: AJIora+v7xYNCR1pySvpQqhiNVVHgUfBrO6prbZ2mS/LungF262uHP8k
        gYgjobPmZSvY+qLQU8bQx4Y=
X-Google-Smtp-Source: AGRyM1s66EyjNZllGAu1+HlJDXad7sC+cYWu4RvO2yo+32ux/eJDbKpJiq//cWALCZq7OM213gfS0Q==
X-Received: by 2002:a05:6a00:2312:b0:52b:928:99dd with SMTP id h18-20020a056a00231200b0052b092899ddmr5928587pfh.77.1657763853662;
        Wed, 13 Jul 2022 18:57:33 -0700 (PDT)
Received: from localhost.localdomain ([23.91.97.158])
        by smtp.gmail.com with ESMTPSA id t24-20020a17090a5d9800b001ef917f1c30sm163843pji.6.2022.07.13.18.57.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Jul 2022 18:57:33 -0700 (PDT)
From:   xiaolinkui <xiaolinkui@gmail.com>
X-Google-Original-From: xiaolinkui <xiaolinkui@kylinos.cn>
To:     ast@kernel.org, daniel@iogearbox.net, davem@davemloft.net,
        kuba@kernel.org, hawk@kernel.org, john.fastabend@gmail.com,
        andrii@kernel.org, martin.lau@linux.dev, song@kernel.org,
        yhs@fb.com, kpsingh@kernel.org, sdf@google.com, haoluo@google.com,
        jolsa@kernel.org, mykolal@fb.com, shuah@kernel.org,
        nathan@kernel.org, ndesaulniers@google.com, trix@redhat.com,
        xiaolinkui@kylinos.cn, xiaolinkui@gmail.com
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
        llvm@lists.linux.dev
Subject: [PATCH bpf-next] selftests/bpf: Return true/false (not 1/0) from bool functions
Date:   Thu, 14 Jul 2022 09:56:47 +0800
Message-Id: <20220714015647.25074-1-xiaolinkui@kylinos.cn>
X-Mailer: git-send-email 2.17.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Linkui Xiao <xiaolinkui@kylinos.cn>

Return boolean values ("true" or "false") instead of 1 or 0 from bool
functions.  This fixes the following warnings from coccicheck:

tools/testing/selftests/bpf/progs/test_xdp_noinline.c:407:9-10: WARNING:
return of 0/1 in function 'decap_v4' with return type bool
tools/testing/selftests/bpf/progs/test_xdp_noinline.c:389:9-10: WARNING:
return of 0/1 in function 'decap_v6' with return type bool
tools/testing/selftests/bpf/progs/test_xdp_noinline.c:290:9-10: WARNING:
return of 0/1 in function 'encap_v6' with return type bool
tools/testing/selftests/bpf/progs/test_xdp_noinline.c:264:9-10: WARNING:
return of 0/1 in function 'parse_tcp' with return type bool
tools/testing/selftests/bpf/progs/test_xdp_noinline.c:242:9-10: WARNING:
return of 0/1 in function 'parse_udp' with return type bool

Generated by: scripts/coccinelle/misc/boolreturn.cocci

Signed-off-by: Linkui Xiao <xiaolinkui@kylinos.cn>
Suggested-by: Stanislav Fomichev <sdf@google.com>
---
 .../selftests/bpf/progs/test_xdp_noinline.c   | 30 +++++++++----------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff --git a/tools/testing/selftests/bpf/progs/test_xdp_noinline.c b/tools/testing/selftests/bpf/progs/test_xdp_noinline.c
index 125d872d7981..ba48fcb98ab2 100644
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
-- 
2.17.1


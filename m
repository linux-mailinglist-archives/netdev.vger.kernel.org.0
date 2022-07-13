Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FBC1572AAC
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 03:11:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233195AbiGMBKz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 21:10:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232959AbiGMBKw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 21:10:52 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E904D1CB4;
        Tue, 12 Jul 2022 18:10:46 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id b8so8440881pjo.5;
        Tue, 12 Jul 2022 18:10:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=OisGpvmsBUcNy/K8e3atLql8+1eBKPZiV0iMxHObDa8=;
        b=hZfLK385958JuQOh2vnt8AKshEDCVQH50EyT7Vgazcvs6Vaa8CIroI8/ARHMI7deYo
         UhzJ8tvKuUdstJEjWBfyoJamf5KP7ZXjO6GJOYOP11pE0F3F86F4ILZci8N0vBgnsnj6
         Jntm6DsdHtj0zkkrl0FUubVisJh0ZTKsD2ofIQXI68+iIw8hl0eOrw0GR+98uCQ8mYyO
         6XHPPVknzApADwlk36WwzenY7yM4d2v2UAsyKkn8FfqeRirVOfTmqQJT5bZRGATdYkTO
         r+hzdOVxSHcC0ok8EoGAHH8zwJU4YYgrTXLxkIJFfElUobTGOkFwAGK8aeTtsaBq8aNo
         /T0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=OisGpvmsBUcNy/K8e3atLql8+1eBKPZiV0iMxHObDa8=;
        b=HXASiNBrPcBaCJ4bG3KxoQOXs31NWEG2gtDWKdyDVG548oTghdFzJ9SDdT1tKu56na
         igTLTzp13c3Hv8e7alXfc2VFWLPwe0yh6E2/nHw2MCFOPzMsCMXK7ogkU+ukxs35OAh1
         0v0Frw7ez/uqWpjcwGX6crKlEiwCKAEKd/5DyXHKIHduI5aOtwv9PJUYarkVHq+r9547
         Mn8uaLWR+uxdpuSjHa+hk1TC+MqLoqAIx7fJ1ia1IuP0Ev1QFIeMrHV2ywLVMmdYwf56
         c+IGvgIWi4kbpDMifKKlvvJWs+ctUg9e2c8K3GqrxsIlWsbNDFFII81juvu3MO17YHfV
         WGFQ==
X-Gm-Message-State: AJIora/ES7eYNdtALXCgB2RLhUNG5lDPvB8UrKXDN6hoOEQTTHjoMXfL
        l6vWB4BUniwi89dZURI3Vg0=
X-Google-Smtp-Source: AGRyM1vAQZRaSWknrD+0/AmwidYVnrRoW/qomRse98W5BtjQCR5E5y77xA1ZjgH06Pxqs6oxuR/PZQ==
X-Received: by 2002:a17:902:d4c2:b0:16b:ffc5:9705 with SMTP id o2-20020a170902d4c200b0016bffc59705mr771028plg.142.1657674645338;
        Tue, 12 Jul 2022 18:10:45 -0700 (PDT)
Received: from localhost.localdomain ([23.91.97.158])
        by smtp.gmail.com with ESMTPSA id z16-20020aa79490000000b0051c6613b5basm7523415pfk.134.2022.07.12.18.10.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jul 2022 18:10:45 -0700 (PDT)
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
Subject: [PATCH] selftests/bpf: Return true/false (not 1/0) from bool functions
Date:   Wed, 13 Jul 2022 09:10:00 +0800
Message-Id: <20220713011000.29090-1-xiaolinkui@kylinos.cn>
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

From: Linkui Xiao<xiaolinkui@kylinos.cn>

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

Signed-off-by: Linkui Xiao<xiaolinkui@kylinos.cn>
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


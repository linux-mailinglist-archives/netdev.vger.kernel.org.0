Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EC2466AFA4
	for <lists+netdev@lfdr.de>; Sun, 15 Jan 2023 08:17:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230168AbjAOHRd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Jan 2023 02:17:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230194AbjAOHQq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Jan 2023 02:16:46 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DDC79007;
        Sat, 14 Jan 2023 23:16:31 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id p24so27362528plw.11;
        Sat, 14 Jan 2023 23:16:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2M5wk3Ez9XgQJyntZJtJSNbfjxm2vkTKIKYAZNk8Mp8=;
        b=avI0vMeV8DQ5yGUfbJrt8m6isIKf5bEGKjfE9xC8WpPfn9awUiLEl9cBUfKLcgR5Go
         SoVz9dUome6IOHstMbwnZJ9KFkemFahgbJheGEHQ+Xkcaych5TqxclOh8AQh6t/5i4mW
         fU4YDWrS/CA7wpywoSQ4IhuTCq3in5CuDvuiL+XddB8HNXl3HPUekR8hUWUAK00/d/Bu
         KpqqPhhczBoUWjKlm+HJrZ645y/ZbUJyzBSoPh5U350XcVA0hEEYbhvsBIsDmNu6dsDW
         honyxJydyKR5hndA6D3G6pdPbz+QR7Vk5ANIeE066nDXhCcTSTyyQoY+nvbx18cIN/Py
         +Ubg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2M5wk3Ez9XgQJyntZJtJSNbfjxm2vkTKIKYAZNk8Mp8=;
        b=UuqH8HzA3dKiKZePo3l0jbFedVuPy5BDsFJTNDJEk9VNWVJ/QA7MGhdyHnMLbUgvVN
         hRgXWNNnjOaLaHQMty6gEG/5PN6KdmaLwGqJb6pwiIL56Af+8hxhBtb6u8HF357HASEg
         Bxdfv6x6XKHFtMQGYCFcd6NDXwJFRQhJdta8GKkhJpkUAVDv/oWKf1lI1JmwCbEbCs+K
         MVaX5VeG+GTSL7/UHKFkBX4FVZocIN1VvVqtNlVs8X1IWeDghmsl7xvkfo3BSbf5yEQ6
         C5n4xqoR5WNNv0G0hyxUS3Wp5bCy3/yW1iFAn+csLChbV/BQBIerHyaTANLI70N1+xqi
         OBjw==
X-Gm-Message-State: AFqh2kqeyj4CeBTjHcoRala8ee9Cr5/jY3Grtq21K8shDxW7hD9zSsEL
        aKBuPevxMLi26fCcfK4pKXG3DjUOIRQgfB4=
X-Google-Smtp-Source: AMrXdXtRbxjnZJ1gJyGuugTfd6DfH+wyBvQ2sLMl2n/XljsNtNIBzL6y69kMl13XuxDeNa4TezMAnQ==
X-Received: by 2002:a05:6a20:9398:b0:b6:8c0b:7146 with SMTP id x24-20020a056a20939800b000b68c0b7146mr14248309pzh.59.1673766990648;
        Sat, 14 Jan 2023 23:16:30 -0800 (PST)
Received: from WDIR.. ([182.209.58.25])
        by smtp.gmail.com with ESMTPSA id z13-20020aa7990d000000b0058a313f4e4esm10272796pff.149.2023.01.14.23.16.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Jan 2023 23:16:30 -0800 (PST)
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Yonghong Song <yhs@fb.com>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org
Subject: [bpf-next 03/10] samples/bpf: fix broken lightweight tunnel testing
Date:   Sun, 15 Jan 2023 16:16:06 +0900
Message-Id: <20230115071613.125791-4-danieltimlee@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230115071613.125791-1-danieltimlee@gmail.com>
References: <20230115071613.125791-1-danieltimlee@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The test_lwt_bpf is a script that tests the functionality of BPF through
the output of the ftrace with bpf_trace_printk. Currently, this program
is not operating normally for several reasons.

First of all, this test script can't parse the ftrace results properly.
GNU sed tries to be as greedy as possible when attempting pattern
matching. Due to this, cutting metadata (such as timestamp) from the
log entry of ftrace doesn't work properly, and also desired log isn't
extracted properly. To make sed stripping clearer, 'nocontext-info'
option with the ftrace has been used to remove metadata from the log.
Also, instead of using unclear pattern matching, this commit specifies
an explicit parse pattern.

Also, unlike before when this test was introduced, the way
bpf_trace_printk behaves has changed[1]. The previous bpf_trace_printk
had to always have '\n' in order to print newline, but now that the
bpf_trace_printk call includes newline by default, so '\n' is no longer
needed.

Lastly with the lwt ENCAP_BPF out, the context information with the
sk_buff protocol is preserved. Therefore, this commit changes the
previous test result from 'protocol 0' to 'protocol 8', which means
ETH_P_IP.

[1]: commit ac5a72ea5c89 ("bpf: Use dedicated bpf_trace_printk event instead of trace_printk()")
Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
---
 samples/bpf/test_lwt_bpf.c  | 36 ++++++++++++++++++------------------
 samples/bpf/test_lwt_bpf.sh | 11 +++++++----
 2 files changed, 25 insertions(+), 22 deletions(-)

diff --git a/samples/bpf/test_lwt_bpf.c b/samples/bpf/test_lwt_bpf.c
index 1b568575ad11..f53dab88d231 100644
--- a/samples/bpf/test_lwt_bpf.c
+++ b/samples/bpf/test_lwt_bpf.c
@@ -44,9 +44,9 @@ SEC("test_ctx")
 int do_test_ctx(struct __sk_buff *skb)
 {
 	skb->cb[0] = CB_MAGIC;
-	printk("len %d hash %d protocol %d\n", skb->len, skb->hash,
+	printk("len %d hash %d protocol %d", skb->len, skb->hash,
 	       skb->protocol);
-	printk("cb %d ingress_ifindex %d ifindex %d\n", skb->cb[0],
+	printk("cb %d ingress_ifindex %d ifindex %d", skb->cb[0],
 	       skb->ingress_ifindex, skb->ifindex);
 
 	return BPF_OK;
@@ -56,9 +56,9 @@ int do_test_ctx(struct __sk_buff *skb)
 SEC("test_cb")
 int do_test_cb(struct __sk_buff *skb)
 {
-	printk("cb0: %x cb1: %x cb2: %x\n", skb->cb[0], skb->cb[1],
+	printk("cb0: %x cb1: %x cb2: %x", skb->cb[0], skb->cb[1],
 	       skb->cb[2]);
-	printk("cb3: %x cb4: %x\n", skb->cb[3], skb->cb[4]);
+	printk("cb3: %x cb4: %x", skb->cb[3], skb->cb[4]);
 
 	return BPF_OK;
 }
@@ -72,11 +72,11 @@ int do_test_data(struct __sk_buff *skb)
 	struct iphdr *iph = data;
 
 	if (data + sizeof(*iph) > data_end) {
-		printk("packet truncated\n");
+		printk("packet truncated");
 		return BPF_DROP;
 	}
 
-	printk("src: %x dst: %x\n", iph->saddr, iph->daddr);
+	printk("src: %x dst: %x", iph->saddr, iph->daddr);
 
 	return BPF_OK;
 }
@@ -97,7 +97,7 @@ static inline int rewrite(struct __sk_buff *skb, uint32_t old_ip,
 
 	ret = bpf_skb_load_bytes(skb, IP_PROTO_OFF, &proto, 1);
 	if (ret < 0) {
-		printk("bpf_l4_csum_replace failed: %d\n", ret);
+		printk("bpf_l4_csum_replace failed: %d", ret);
 		return BPF_DROP;
 	}
 
@@ -120,14 +120,14 @@ static inline int rewrite(struct __sk_buff *skb, uint32_t old_ip,
 		ret = bpf_l4_csum_replace(skb, off, old_ip, new_ip,
 					  flags | sizeof(new_ip));
 		if (ret < 0) {
-			printk("bpf_l4_csum_replace failed: %d\n");
+			printk("bpf_l4_csum_replace failed: %d");
 			return BPF_DROP;
 		}
 	}
 
 	ret = bpf_l3_csum_replace(skb, IP_CSUM_OFF, old_ip, new_ip, sizeof(new_ip));
 	if (ret < 0) {
-		printk("bpf_l3_csum_replace failed: %d\n", ret);
+		printk("bpf_l3_csum_replace failed: %d", ret);
 		return BPF_DROP;
 	}
 
@@ -137,7 +137,7 @@ static inline int rewrite(struct __sk_buff *skb, uint32_t old_ip,
 		ret = bpf_skb_store_bytes(skb, IP_SRC_OFF, &new_ip, sizeof(new_ip), 0);
 
 	if (ret < 0) {
-		printk("bpf_skb_store_bytes() failed: %d\n", ret);
+		printk("bpf_skb_store_bytes() failed: %d", ret);
 		return BPF_DROP;
 	}
 
@@ -153,12 +153,12 @@ int do_test_rewrite(struct __sk_buff *skb)
 
 	ret = bpf_skb_load_bytes(skb, IP_DST_OFF, &old_ip, 4);
 	if (ret < 0) {
-		printk("bpf_skb_load_bytes failed: %d\n", ret);
+		printk("bpf_skb_load_bytes failed: %d", ret);
 		return BPF_DROP;
 	}
 
 	if (old_ip == 0x2fea8c0) {
-		printk("out: rewriting from %x to %x\n", old_ip, new_ip);
+		printk("out: rewriting from %x to %x", old_ip, new_ip);
 		return rewrite(skb, old_ip, new_ip, 1);
 	}
 
@@ -173,7 +173,7 @@ static inline int __do_push_ll_and_redirect(struct __sk_buff *skb)
 
 	ret = bpf_skb_change_head(skb, 14, 0);
 	if (ret < 0) {
-		printk("skb_change_head() failed: %d\n", ret);
+		printk("skb_change_head() failed: %d", ret);
 	}
 
 	ehdr.h_proto = __constant_htons(ETH_P_IP);
@@ -182,7 +182,7 @@ static inline int __do_push_ll_and_redirect(struct __sk_buff *skb)
 
 	ret = bpf_skb_store_bytes(skb, 0, &ehdr, sizeof(ehdr), 0);
 	if (ret < 0) {
-		printk("skb_store_bytes() failed: %d\n", ret);
+		printk("skb_store_bytes() failed: %d", ret);
 		return BPF_DROP;
 	}
 
@@ -202,7 +202,7 @@ int do_push_ll_and_redirect(struct __sk_buff *skb)
 
 	ret = __do_push_ll_and_redirect(skb);
 	if (ret >= 0)
-		printk("redirected to %d\n", ifindex);
+		printk("redirected to %d", ifindex);
 
 	return ret;
 }
@@ -229,7 +229,7 @@ SEC("fill_garbage")
 int do_fill_garbage(struct __sk_buff *skb)
 {
 	__fill_garbage(skb);
-	printk("Set initial 96 bytes of header to FF\n");
+	printk("Set initial 96 bytes of header to FF");
 	return BPF_OK;
 }
 
@@ -238,7 +238,7 @@ int do_fill_garbage_and_redirect(struct __sk_buff *skb)
 {
 	int ifindex = DST_IFINDEX;
 	__fill_garbage(skb);
-	printk("redirected to %d\n", ifindex);
+	printk("redirected to %d", ifindex);
 	return bpf_redirect(ifindex, 0);
 }
 
@@ -246,7 +246,7 @@ int do_fill_garbage_and_redirect(struct __sk_buff *skb)
 SEC("drop_all")
 int do_drop_all(struct __sk_buff *skb)
 {
-	printk("dropping with: %d\n", BPF_DROP);
+	printk("dropping with: %d", BPF_DROP);
 	return BPF_DROP;
 }
 
diff --git a/samples/bpf/test_lwt_bpf.sh b/samples/bpf/test_lwt_bpf.sh
index 8fc9356545d8..2e9f5126963b 100755
--- a/samples/bpf/test_lwt_bpf.sh
+++ b/samples/bpf/test_lwt_bpf.sh
@@ -22,6 +22,7 @@ IP_LOCAL="192.168.99.1"
 PROG_SRC="test_lwt_bpf.c"
 BPF_PROG="test_lwt_bpf.o"
 TRACE_ROOT=/sys/kernel/debug/tracing
+CONTEXT_INFO=$(cat ${TRACE_ROOT}/trace_options | grep context)
 
 function lookup_mac()
 {
@@ -98,7 +99,7 @@ function remove_prog {
 function filter_trace {
 	# Add newline to allow starting EXPECT= variables on newline
 	NL=$'\n'
-	echo "${NL}$*" | sed -e 's/^.*: : //g'
+	echo "${NL}$*" | sed -e 's/bpf_trace_printk: //g'
 }
 
 function expect_fail {
@@ -162,11 +163,11 @@ function test_ctx_out {
 		failure "test_ctx out: packets are dropped"
 	}
 	match_trace "$(get_trace)" "
-len 84 hash 0 protocol 0
+len 84 hash 0 protocol 8
 cb 1234 ingress_ifindex 0 ifindex 0
-len 84 hash 0 protocol 0
+len 84 hash 0 protocol 8
 cb 1234 ingress_ifindex 0 ifindex 0
-len 84 hash 0 protocol 0
+len 84 hash 0 protocol 8
 cb 1234 ingress_ifindex 0 ifindex 0" || exit 1
 	remove_prog out
 }
@@ -369,6 +370,7 @@ setup_one_veth $NS1 $VETH0 $VETH1 $IPVETH0 $IPVETH1 $IPVETH1b
 setup_one_veth $NS2 $VETH2 $VETH3 $IPVETH2 $IPVETH3
 ip netns exec $NS1 netserver
 echo 1 > ${TRACE_ROOT}/tracing_on
+echo nocontext-info > ${TRACE_ROOT}/trace_options
 
 DST_MAC=$(lookup_mac $VETH1 $NS1)
 SRC_MAC=$(lookup_mac $VETH0)
@@ -399,4 +401,5 @@ test_netperf_redirect
 
 cleanup
 echo 0 > ${TRACE_ROOT}/tracing_on
+echo $CONTEXT_INFO > ${TRACE_ROOT}/trace_options
 exit 0
-- 
2.34.1


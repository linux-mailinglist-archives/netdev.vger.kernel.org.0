Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 216ED64FDC4
	for <lists+netdev@lfdr.de>; Sun, 18 Dec 2022 06:18:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230385AbiLRFSa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Dec 2022 00:18:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230272AbiLRFSO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Dec 2022 00:18:14 -0500
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D05B75F79
        for <netdev@vger.kernel.org>; Sat, 17 Dec 2022 21:18:12 -0800 (PST)
Received: by mail-wm1-x329.google.com with SMTP id m5-20020a7bca45000000b003d2fbab35c6so4329669wml.4
        for <netdev@vger.kernel.org>; Sat, 17 Dec 2022 21:18:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VZjrql4GzJFHQJkJaKmcf2NkEXsxLrfG96nTce813zM=;
        b=q9j+E6sC/Mv5x8/TehXbtRXdQiQqqENXX7LLpqFkYiBa55+8Ym66+zW4pq4VTXeHWl
         XZr7HRd5XthTvqPx42b23iS0OD7LaAtKz2N0BA+hLNO8iCmYfCxo2bGU3/dePc/hYCAo
         zv5jSj5r3eaI8nCWSLh179yoY1FpO9pdnwRNU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VZjrql4GzJFHQJkJaKmcf2NkEXsxLrfG96nTce813zM=;
        b=GnQ7sgORMTtTYmJFcOtNMExtipaZgSJa42WIgsT+xxajD9MRanmsrkRfo26E8g8gZU
         6/i4tmlNS6HS2hRUm7AA1WQs/dvMhOubVIO8ckahGJC5nTHz9HB77Zms9d11IoN27TUu
         M+mDRne4s0E+I6VEGLjE6glm1vHT1jWydlp8e99xmmJQ5upuWIfB/0T7PHJ8ZvE9mOD+
         jLFqS4hO9YJ3EfdV4RJRkZLh62rgetbKfyQLZ7ZpZCHZoVeP5Ph1a/F0lzNUuGgfANF6
         KnLK70W2zcSlOYBinJCp0GaBbN8OHlQKMT5pPFoTuHK0IpBWjL3XxRGxY6136xuiJ91d
         uprg==
X-Gm-Message-State: ANoB5plzqN8nc1Q/8TEqY9n2SnbqBVPHZdfKCFPpFojumU63Nk9+YOYJ
        Fj2PClFZm3eVJ7N+zyJKuHWPhg==
X-Google-Smtp-Source: AA0mqf6f3ef5BuwOP85Gx7YZu5EIiEpnxNCOl1r7V0jE6yQouke8p5FYLVXungY9c4+QkgtMwi2lfg==
X-Received: by 2002:a7b:cbd1:0:b0:3d1:ed41:57c0 with SMTP id n17-20020a7bcbd1000000b003d1ed4157c0mr28766562wmi.30.1671340691305;
        Sat, 17 Dec 2022 21:18:11 -0800 (PST)
Received: from workstation.ehrig.io (tmo-122-74.customers.d1-online.com. [80.187.122.74])
        by smtp.gmail.com with ESMTPSA id k62-20020a1ca141000000b003cf894dbc4fsm7805231wme.25.2022.12.17.21.18.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 Dec 2022 21:18:10 -0800 (PST)
From:   Christian Ehrig <cehrig@cloudflare.com>
To:     bpf@vger.kernel.org
Cc:     cehrig@cloudflare.com, Alexei Starovoitov <ast@kernel.org>,
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
        Mykola Lysenko <mykolal@fb.com>, Shuah Khan <shuah@kernel.org>,
        Joanne Koong <joannelkoong@gmail.com>,
        Kui-Feng Lee <kuifeng@fb.com>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Kaixi Fan <fankaixi.li@bytedance.com>,
        Paul Chaignon <paul@isovalent.com>,
        Shmulik Ladkani <shmulik@metanetworks.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Subject: [PATCH bpf-next 2/2] selftests/bpf: Add BPF_F_NO_TUNNEL_KEY test
Date:   Sun, 18 Dec 2022 06:17:32 +0100
Message-Id: <20221218051734.31411-2-cehrig@cloudflare.com>
X-Mailer: git-send-email 2.37.4
In-Reply-To: <20221218051734.31411-1-cehrig@cloudflare.com>
References: <20221218051734.31411-1-cehrig@cloudflare.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds a selftest simulating a GRE sender and receiver using
tunnel headers without tunnel keys. It validates if packets encapsulated
using BPF_F_NO_TUNNEL_KEY are decapsulated by a GRE receiver not
configured with tunnel keys.

Signed-off-by: Christian Ehrig <cehrig@cloudflare.com>
---
 .../selftests/bpf/progs/test_tunnel_kern.c    | 21 ++++++++++
 tools/testing/selftests/bpf/test_tunnel.sh    | 40 +++++++++++++++++--
 2 files changed, 58 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/bpf/progs/test_tunnel_kern.c b/tools/testing/selftests/bpf/progs/test_tunnel_kern.c
index 98af55f0bcd3..508da4a23c4f 100644
--- a/tools/testing/selftests/bpf/progs/test_tunnel_kern.c
+++ b/tools/testing/selftests/bpf/progs/test_tunnel_kern.c
@@ -81,6 +81,27 @@ int gre_set_tunnel(struct __sk_buff *skb)
 	return TC_ACT_OK;
 }
 
+SEC("tc")
+int gre_set_tunnel_no_key(struct __sk_buff *skb)
+{
+	int ret;
+	struct bpf_tunnel_key key;
+
+	__builtin_memset(&key, 0x0, sizeof(key));
+	key.remote_ipv4 = 0xac100164; /* 172.16.1.100 */
+	key.tunnel_ttl = 64;
+
+	ret = bpf_skb_set_tunnel_key(skb, &key, sizeof(key),
+				     BPF_F_ZERO_CSUM_TX | BPF_F_SEQ_NUMBER |
+				     BPF_F_NO_TUNNEL_KEY);
+	if (ret < 0) {
+		log_err(ret);
+		return TC_ACT_SHOT;
+	}
+
+	return TC_ACT_OK;
+}
+
 SEC("tc")
 int gre_get_tunnel(struct __sk_buff *skb)
 {
diff --git a/tools/testing/selftests/bpf/test_tunnel.sh b/tools/testing/selftests/bpf/test_tunnel.sh
index 2eaedc1d9ed3..06857b689c11 100755
--- a/tools/testing/selftests/bpf/test_tunnel.sh
+++ b/tools/testing/selftests/bpf/test_tunnel.sh
@@ -66,15 +66,20 @@ config_device()
 
 add_gre_tunnel()
 {
+	tun_key=
+	if [ -n "$1" ]; then
+		tun_key="key $1"
+	fi
+
 	# at_ns0 namespace
 	ip netns exec at_ns0 \
-        ip link add dev $DEV_NS type $TYPE seq key 2 \
+        ip link add dev $DEV_NS type $TYPE seq $tun_key \
 		local 172.16.1.100 remote 172.16.1.200
 	ip netns exec at_ns0 ip link set dev $DEV_NS up
 	ip netns exec at_ns0 ip addr add dev $DEV_NS 10.1.1.100/24
 
 	# root namespace
-	ip link add dev $DEV type $TYPE key 2 external
+	ip link add dev $DEV type $TYPE $tun_key external
 	ip link set dev $DEV up
 	ip addr add dev $DEV 10.1.1.200/24
 }
@@ -238,7 +243,7 @@ test_gre()
 
 	check $TYPE
 	config_device
-	add_gre_tunnel
+	add_gre_tunnel 2
 	attach_bpf $DEV gre_set_tunnel gre_get_tunnel
 	ping $PING_ARG 10.1.1.100
 	check_err $?
@@ -253,6 +258,30 @@ test_gre()
         echo -e ${GREEN}"PASS: $TYPE"${NC}
 }
 
+test_gre_no_tunnel_key()
+{
+	TYPE=gre
+	DEV_NS=gre00
+	DEV=gre11
+	ret=0
+
+	check $TYPE
+	config_device
+	add_gre_tunnel
+	attach_bpf $DEV gre_set_tunnel_no_key gre_get_tunnel
+	ping $PING_ARG 10.1.1.100
+	check_err $?
+	ip netns exec at_ns0 ping $PING_ARG 10.1.1.200
+	check_err $?
+	cleanup
+
+        if [ $ret -ne 0 ]; then
+                echo -e ${RED}"FAIL: $TYPE"${NC}
+                return 1
+        fi
+        echo -e ${GREEN}"PASS: $TYPE"${NC}
+}
+
 test_ip6gre()
 {
 	TYPE=ip6gre
@@ -589,6 +618,7 @@ cleanup()
 	ip link del ipip6tnl11 2> /dev/null
 	ip link del ip6ip6tnl11 2> /dev/null
 	ip link del gretap11 2> /dev/null
+	ip link del gre11 2> /dev/null
 	ip link del ip6gre11 2> /dev/null
 	ip link del ip6gretap11 2> /dev/null
 	ip link del geneve11 2> /dev/null
@@ -641,6 +671,10 @@ bpf_tunnel_test()
 	test_gre
 	errors=$(( $errors + $? ))
 
+	echo "Testing GRE tunnel (without tunnel keys)..."
+	test_gre_no_tunnel_key
+	errors=$(( $errors + $? ))
+
 	echo "Testing IP6GRE tunnel..."
 	test_ip6gre
 	errors=$(( $errors + $? ))
-- 
2.37.4


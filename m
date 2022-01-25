Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C06A149AF39
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 10:10:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1455789AbiAYJHF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 04:07:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1454225AbiAYI6V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 03:58:21 -0500
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2D7EC05A199;
        Tue, 25 Jan 2022 00:18:09 -0800 (PST)
Received: by mail-pf1-x42b.google.com with SMTP id p37so18954648pfh.4;
        Tue, 25 Jan 2022 00:18:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8fMIhYh/j4v25pOVuKzY8WeiuuQjcrhkrY/qBrQikhk=;
        b=H4uRqbo2mz11fQLsoARPO2Dn0pxOqeZcCcvsSEWrinAyyt3KmUynk82bi9fJPwZ3fu
         IbXCudWsNQ62Ma4HpYy6B2Dn0Fl8Crne2HJkaSVI+WOg8W8gnHT2B0ZK1UqTXsKkOMqS
         7BrdX30ixL6XePH2H8hUvG4epZslcvrnbLa1pm16IAnlBHYO2gKuhVkKJUoVA49DUL7V
         PSUPSvr3z9RcwqYBWdQ1aqFp1m6s5s8Tc7fSelDfhDAn01L4gZbo8+Z8bpoprlBbnz1o
         oL9DiqyUlIICJ8390bUydzjYDeAu3GuhNsKOV07H0UrwX3eF0RcqdHRVWfHzyMcZ/Zkj
         s+aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8fMIhYh/j4v25pOVuKzY8WeiuuQjcrhkrY/qBrQikhk=;
        b=kACTn5zQX6fLfJo4VLmVv478QxJa9TU8b5mmjEuKe3g35EUXNZ6dsR/5npYliba0kl
         +QC1smrdmauybUJ0A6sYD2sZoZRAN0KVKSyQME9LJKYClkSLrmJ6fqKPxgPKKrjcjNzf
         1etxNO/dXqyS0sseJyYYlNpK07hXRwKlFMaB2BoF55dl408+rTEAPIRb2SvC6wl8PyHc
         0UuivlBZTv4ZYK3nTUkZEw082nFp/hM5+VlsAR2uUg5BVePeQGeEsi4jiAb7VJzlUC8q
         jC8KAOwvZPDyejiG8J3h0Tpt6Zcj42wesJO4aIP600WqYmWMcZl6NbKe1zgrx0Ws+s2Q
         4P8Q==
X-Gm-Message-State: AOAM532fVvXzz1k1yLLkb7c+k30Uuln8Ad6wam3fXmDy2AklPjKitBut
        g3anTIWjEfVV2/Rc3SDtIGsnnsC/sHU=
X-Google-Smtp-Source: ABdhPJxvAB3a1pP3mf+CvmPX5CqEPrDM+tETr03f+hTWIrazTPjIShS2PnOmfZCnij8EYy3jk+bNQg==
X-Received: by 2002:a05:6a00:b42:b0:4ca:a5da:f184 with SMTP id p2-20020a056a000b4200b004caa5daf184mr3438023pfo.50.1643098689176;
        Tue, 25 Jan 2022 00:18:09 -0800 (PST)
Received: from Laptop-X1.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id l21sm18928949pfu.120.2022.01.25.00.18.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Jan 2022 00:18:08 -0800 (PST)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, bpf@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Mathieu Xhonneux <m.xhonneux@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        William Tu <u9012063@gmail.com>,
        Toshiaki Makita <toshiaki.makita1@gmail.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH bpf 6/7] selftests/bpf/test_xdp_meta: use temp netns for testing
Date:   Tue, 25 Jan 2022 16:17:16 +0800
Message-Id: <20220125081717.1260849-7-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220125081717.1260849-1-liuhangbin@gmail.com>
References: <20220125081717.1260849-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use temp netns instead of hard code name for testing in case the
netns already exists.

Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 tools/testing/selftests/bpf/test_xdp_meta.sh | 38 ++++++++++----------
 1 file changed, 20 insertions(+), 18 deletions(-)

diff --git a/tools/testing/selftests/bpf/test_xdp_meta.sh b/tools/testing/selftests/bpf/test_xdp_meta.sh
index d10cefd6eb09..ea69370caae3 100755
--- a/tools/testing/selftests/bpf/test_xdp_meta.sh
+++ b/tools/testing/selftests/bpf/test_xdp_meta.sh
@@ -2,6 +2,8 @@
 
 # Kselftest framework requirement - SKIP code is 4.
 readonly KSFT_SKIP=4
+readonly NS1="ns1-$(mktemp -u XXXXXX)"
+readonly NS2="ns2-$(mktemp -u XXXXXX)"
 
 cleanup()
 {
@@ -13,8 +15,8 @@ cleanup()
 
 	set +e
 	ip link del veth1 2> /dev/null
-	ip netns del ns1 2> /dev/null
-	ip netns del ns2 2> /dev/null
+	ip netns del ${NS1} 2> /dev/null
+	ip netns del ${NS2} 2> /dev/null
 }
 
 ip link set dev lo xdp off 2>/dev/null > /dev/null
@@ -24,32 +26,32 @@ if [ $? -ne 0 ];then
 fi
 set -e
 
-ip netns add ns1
-ip netns add ns2
+ip netns add ${NS1}
+ip netns add ${NS2}
 
 trap cleanup 0 2 3 6 9
 
 ip link add veth1 type veth peer name veth2
 
-ip link set veth1 netns ns1
-ip link set veth2 netns ns2
+ip link set veth1 netns ${NS1}
+ip link set veth2 netns ${NS2}
 
-ip netns exec ns1 ip addr add 10.1.1.11/24 dev veth1
-ip netns exec ns2 ip addr add 10.1.1.22/24 dev veth2
+ip netns exec ${NS1} ip addr add 10.1.1.11/24 dev veth1
+ip netns exec ${NS2} ip addr add 10.1.1.22/24 dev veth2
 
-ip netns exec ns1 tc qdisc add dev veth1 clsact
-ip netns exec ns2 tc qdisc add dev veth2 clsact
+ip netns exec ${NS1} tc qdisc add dev veth1 clsact
+ip netns exec ${NS2} tc qdisc add dev veth2 clsact
 
-ip netns exec ns1 tc filter add dev veth1 ingress bpf da obj test_xdp_meta.o sec t
-ip netns exec ns2 tc filter add dev veth2 ingress bpf da obj test_xdp_meta.o sec t
+ip netns exec ${NS1} tc filter add dev veth1 ingress bpf da obj test_xdp_meta.o sec t
+ip netns exec ${NS2} tc filter add dev veth2 ingress bpf da obj test_xdp_meta.o sec t
 
-ip netns exec ns1 ip link set dev veth1 xdp obj test_xdp_meta.o sec x
-ip netns exec ns2 ip link set dev veth2 xdp obj test_xdp_meta.o sec x
+ip netns exec ${NS1} ip link set dev veth1 xdp obj test_xdp_meta.o sec x
+ip netns exec ${NS2} ip link set dev veth2 xdp obj test_xdp_meta.o sec x
 
-ip netns exec ns1 ip link set dev veth1 up
-ip netns exec ns2 ip link set dev veth2 up
+ip netns exec ${NS1} ip link set dev veth1 up
+ip netns exec ${NS2} ip link set dev veth2 up
 
-ip netns exec ns1 ping -c 1 10.1.1.22
-ip netns exec ns2 ping -c 1 10.1.1.11
+ip netns exec ${NS1} ping -c 1 10.1.1.22
+ip netns exec ${NS2} ping -c 1 10.1.1.11
 
 exit 0
-- 
2.31.1


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E6C149AF42
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 10:10:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1455835AbiAYJHe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 04:07:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1454232AbiAYI6W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 03:58:22 -0500
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B8CEC05A19A;
        Tue, 25 Jan 2022 00:18:16 -0800 (PST)
Received: by mail-pf1-x42d.google.com with SMTP id p37so18954939pfh.4;
        Tue, 25 Jan 2022 00:18:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SnVSNMKy52XbhPLKBQYYgTXySBoRRsbquBsPKnvecCk=;
        b=BidoxjrzfYvjErQaBQ8xv871HIYIo35AH7+MHHndYuHAKIBxrTdi4VM/dAwPf5wLxT
         9h0FH0STuwkdD3LANZk5By6y9eEI5jVuN0wpkXvfAQ5yMw1roaaEJIV6qQ0+c6hxv6j3
         ITXJHoplSFyidog1RaaFy/9EDHNAj1PKnZyfjOPFmIQnmViHVsk4g8ITtM9dS2VaSidu
         xoOvAWXaWvQWIQfJYyhQ320wYVJYF/ERax9bGtc1T4Upx/hh3bQOc9aSJKwE7sLgU59X
         kmbumGC13eXh2tVBo5/9JBaWx4brUH0DIeYZxuhqWw0i7uzWe0mwqc8dyIx+qBZ/F114
         cOgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SnVSNMKy52XbhPLKBQYYgTXySBoRRsbquBsPKnvecCk=;
        b=vTJ+O+0WgCdzJHkIvTqQeHuBPziBDrsvxZBZT2cDV3hxKEtznnPEgdnq1T7jZXvVj7
         Rd5U39qDqyD6UQjx/mGdobg7++CGUBpyBrUAm4kdEKslVAUw7WiJJPhf1F8qtgwQn9/g
         4S2F02IYZXKTkn5i1gu/h3+EARTyBiiB9NZDzc1FFAGuJ65j9Xq7Bg2StBfFPCikyo1F
         pMSsNwxw0A85sZR+4CVJUJsQyX1V8BC7WE2ywYvmouWz9PynlemnKDmfB/V0sxQ7Gzvf
         4i/BmZYFiydkr3WOfP1Q+BwMpHXVA/Y3FFb8a1ADfYalzSnvFwhvm6wb5R6Ct06MtdXk
         dbYg==
X-Gm-Message-State: AOAM532cn9UXo+jxjmVCAI9Ulw4Kukn+mgudzmMi7FHkbYkJC2RB+kPA
        MleoDzx6Ex6oVJfkq28MW93MdqbAttg=
X-Google-Smtp-Source: ABdhPJyYy35USLhCzOT92ouwDk3aL+zQPh5uOv2FLlTW1lDcHYWXxaippNCIL7HJnELfv6t7YWyISA==
X-Received: by 2002:a63:8c59:: with SMTP id q25mr14244001pgn.13.1643098695447;
        Tue, 25 Jan 2022 00:18:15 -0800 (PST)
Received: from Laptop-X1.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id l21sm18928949pfu.120.2022.01.25.00.18.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Jan 2022 00:18:15 -0800 (PST)
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
Subject: [PATCH bpf 7/7] selftests/bpf/test_xdp_redirect: use temp netns for testing
Date:   Tue, 25 Jan 2022 16:17:17 +0800
Message-Id: <20220125081717.1260849-8-liuhangbin@gmail.com>
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
 .../selftests/bpf/test_xdp_redirect.sh        | 30 ++++++++++---------
 1 file changed, 16 insertions(+), 14 deletions(-)

diff --git a/tools/testing/selftests/bpf/test_xdp_redirect.sh b/tools/testing/selftests/bpf/test_xdp_redirect.sh
index 57c8db9972a6..1d79f31480ad 100755
--- a/tools/testing/selftests/bpf/test_xdp_redirect.sh
+++ b/tools/testing/selftests/bpf/test_xdp_redirect.sh
@@ -10,6 +10,8 @@
 #     | xdp forwarding |
 #     ------------------
 
+readonly NS1="ns1-$(mktemp -u XXXXXX)"
+readonly NS2="ns2-$(mktemp -u XXXXXX)"
 ret=0
 
 setup()
@@ -17,27 +19,27 @@ setup()
 
 	local xdpmode=$1
 
-	ip netns add ns1
-	ip netns add ns2
+	ip netns add ${NS1}
+	ip netns add ${NS2}
 
-	ip link add veth1 index 111 type veth peer name veth11 netns ns1
-	ip link add veth2 index 222 type veth peer name veth22 netns ns2
+	ip link add veth1 index 111 type veth peer name veth11 netns ${NS1}
+	ip link add veth2 index 222 type veth peer name veth22 netns ${NS2}
 
 	ip link set veth1 up
 	ip link set veth2 up
-	ip -n ns1 link set dev veth11 up
-	ip -n ns2 link set dev veth22 up
+	ip -n ${NS1} link set dev veth11 up
+	ip -n ${NS2} link set dev veth22 up
 
-	ip -n ns1 addr add 10.1.1.11/24 dev veth11
-	ip -n ns2 addr add 10.1.1.22/24 dev veth22
+	ip -n ${NS1} addr add 10.1.1.11/24 dev veth11
+	ip -n ${NS2} addr add 10.1.1.22/24 dev veth22
 }
 
 cleanup()
 {
 	ip link del veth1 2> /dev/null
 	ip link del veth2 2> /dev/null
-	ip netns del ns1 2> /dev/null
-	ip netns del ns2 2> /dev/null
+	ip netns del ${NS1} 2> /dev/null
+	ip netns del ${NS2} 2> /dev/null
 }
 
 test_xdp_redirect()
@@ -52,13 +54,13 @@ test_xdp_redirect()
 		return 0
 	fi
 
-	ip -n ns1 link set veth11 $xdpmode obj xdp_dummy.o sec xdp &> /dev/null
-	ip -n ns2 link set veth22 $xdpmode obj xdp_dummy.o sec xdp &> /dev/null
+	ip -n ${NS1} link set veth11 $xdpmode obj xdp_dummy.o sec xdp &> /dev/null
+	ip -n ${NS2} link set veth22 $xdpmode obj xdp_dummy.o sec xdp &> /dev/null
 	ip link set dev veth1 $xdpmode obj test_xdp_redirect.o sec redirect_to_222 &> /dev/null
 	ip link set dev veth2 $xdpmode obj test_xdp_redirect.o sec redirect_to_111 &> /dev/null
 
-	if ip netns exec ns1 ping -c 1 10.1.1.22 &> /dev/null &&
-	   ip netns exec ns2 ping -c 1 10.1.1.11 &> /dev/null; then
+	if ip netns exec ${NS1} ping -c 1 10.1.1.22 &> /dev/null &&
+	   ip netns exec ${NS2} ping -c 1 10.1.1.11 &> /dev/null; then
 		echo "selftests: test_xdp_redirect $xdpmode [PASS]";
 	else
 		ret=1
-- 
2.31.1


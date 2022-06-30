Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9ECC3561264
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 08:22:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230224AbiF3GWj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 02:22:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229891AbiF3GWh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 02:22:37 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EFBA1CB00
        for <netdev@vger.kernel.org>; Wed, 29 Jun 2022 23:22:36 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id g20-20020a17090a579400b001ed52939d72so1777829pji.4
        for <netdev@vger.kernel.org>; Wed, 29 Jun 2022 23:22:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=VHXw7xQ+6+vyo71xCXX7RRrbJ2n2eOp/V9R36tedzpI=;
        b=nvbfTbAObEFkBtuB4x3naHxWuc25LdvlcREyVQS2lu/dB4Or2+0HqmZRjWAgWwXxUE
         gJ1gx/zfkp0Nz4pivbi3f4PCicWSLYXWug7eJmSAFnHR5mRahvcF1XtmvHkeGnv4dlHt
         QIXAX7+nQ5D4KK4kW52iWPPV3wMw62TAaMBkwBgaIhhwzkPCgW7FSPvoR7/nLYRMN9Wc
         TZLq8Ae1b8kwGd3P3lLT3SSrrO4rZNrBhSKwouG3lnoIZfPONOKerBW4l0wp2IKauzR5
         95QnRC64apzcUn61ZzWIkoT/YdvnGaT+UjKzodOPclH363shnGrc95qLqUzRabnnd3Ee
         YkSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=VHXw7xQ+6+vyo71xCXX7RRrbJ2n2eOp/V9R36tedzpI=;
        b=deSXWNQx7dLQ/DiJq7nNKR6HJKYDc2Atnv1VJ8+hw+a79p61SzIf0Lfv0+k3qpIDOE
         0p/zeLDn9dk2uceScGTi+SgLYGZ62Ea0Si3JtHR08QJQozCBZkinUQBAYK9Y4Ndlv4gH
         yC9fYg/LXEx12cOFrKyWvuid3S4ea+HDZ6y3RXd5c0Ocu0zXfLRWM84IRBC1nYQ+Ajsd
         0l/jop0wnMs8SqyGYtv7mBIpbF8JOF68Ddor00tsGCRdlgCXvv0ve9wm5Rgf+/Z0QChh
         hhtfoF6Hx16S+2bmv3rJpgP+Lyb2WT4HraYyma3Du8MQxHDs4NTA/xewuW10ug6+w74D
         S9RQ==
X-Gm-Message-State: AJIora91UMnhaCW3rbVNHo9jvcWAotT6LIsTNb0+Q1nlLurudcKdFzaj
        +Q1CQmczwOqrjtyTb0dTgfS4vj7W0kE=
X-Google-Smtp-Source: AGRyM1t46+sVjHcD+sgzzPi/wuPb/MTduc6YapPcR78UAgT+uUmjmeRhzDFb8QLiYSmFXBlw9W2S7A==
X-Received: by 2002:a17:902:d548:b0:16b:8c20:c6e2 with SMTP id z8-20020a170902d54800b0016b8c20c6e2mr12904487plf.24.1656570155454;
        Wed, 29 Jun 2022 23:22:35 -0700 (PDT)
Received: from Laptop-X1.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id x12-20020a17090300cc00b001624dab05edsm12579459plc.8.2022.06.29.23.22.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jun 2022 23:22:34 -0700 (PDT)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH net] selftests/net: fix section name when using xdp_dummy.o
Date:   Thu, 30 Jun 2022 14:22:28 +0800
Message-Id: <20220630062228.3453016-1-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since commit 8fffa0e3451a ("selftests/bpf: Normalize XDP section names in
selftests") the xdp_dummy.o's section name has changed to xdp. But some
tests are still using "section xdp_dummy", which make the tests failed.
Fix them by updating to the new section name.

Fixes: 8fffa0e3451a ("selftests/bpf: Normalize XDP section names in selftests")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 tools/testing/selftests/net/udpgro.sh         | 2 +-
 tools/testing/selftests/net/udpgro_bench.sh   | 2 +-
 tools/testing/selftests/net/udpgro_frglist.sh | 2 +-
 tools/testing/selftests/net/udpgro_fwd.sh     | 2 +-
 tools/testing/selftests/net/veth.sh           | 6 +++---
 5 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/tools/testing/selftests/net/udpgro.sh b/tools/testing/selftests/net/udpgro.sh
index f8a19f548ae9..ebbd0b282432 100755
--- a/tools/testing/selftests/net/udpgro.sh
+++ b/tools/testing/selftests/net/udpgro.sh
@@ -34,7 +34,7 @@ cfg_veth() {
 	ip -netns "${PEER_NS}" addr add dev veth1 192.168.1.1/24
 	ip -netns "${PEER_NS}" addr add dev veth1 2001:db8::1/64 nodad
 	ip -netns "${PEER_NS}" link set dev veth1 up
-	ip -n "${PEER_NS}" link set veth1 xdp object ../bpf/xdp_dummy.o section xdp_dummy
+	ip -n "${PEER_NS}" link set veth1 xdp object ../bpf/xdp_dummy.o section xdp
 }
 
 run_one() {
diff --git a/tools/testing/selftests/net/udpgro_bench.sh b/tools/testing/selftests/net/udpgro_bench.sh
index 820bc50f6b68..fad2d1a71cac 100755
--- a/tools/testing/selftests/net/udpgro_bench.sh
+++ b/tools/testing/selftests/net/udpgro_bench.sh
@@ -34,7 +34,7 @@ run_one() {
 	ip -netns "${PEER_NS}" addr add dev veth1 2001:db8::1/64 nodad
 	ip -netns "${PEER_NS}" link set dev veth1 up
 
-	ip -n "${PEER_NS}" link set veth1 xdp object ../bpf/xdp_dummy.o section xdp_dummy
+	ip -n "${PEER_NS}" link set veth1 xdp object ../bpf/xdp_dummy.o section xdp
 	ip netns exec "${PEER_NS}" ./udpgso_bench_rx ${rx_args} -r &
 	ip netns exec "${PEER_NS}" ./udpgso_bench_rx -t ${rx_args} -r &
 
diff --git a/tools/testing/selftests/net/udpgro_frglist.sh b/tools/testing/selftests/net/udpgro_frglist.sh
index 807b74c8fd80..832c738cc3c2 100755
--- a/tools/testing/selftests/net/udpgro_frglist.sh
+++ b/tools/testing/selftests/net/udpgro_frglist.sh
@@ -36,7 +36,7 @@ run_one() {
 	ip netns exec "${PEER_NS}" ethtool -K veth1 rx-gro-list on
 
 
-	ip -n "${PEER_NS}" link set veth1 xdp object ../bpf/xdp_dummy.o section xdp_dummy
+	ip -n "${PEER_NS}" link set veth1 xdp object ../bpf/xdp_dummy.o section xdp
 	tc -n "${PEER_NS}" qdisc add dev veth1 clsact
 	tc -n "${PEER_NS}" filter add dev veth1 ingress prio 4 protocol ipv6 bpf object-file ../bpf/nat6to4.o section schedcls/ingress6/nat_6  direct-action
 	tc -n "${PEER_NS}" filter add dev veth1 egress prio 4 protocol ip bpf object-file ../bpf/nat6to4.o section schedcls/egress4/snat4 direct-action
diff --git a/tools/testing/selftests/net/udpgro_fwd.sh b/tools/testing/selftests/net/udpgro_fwd.sh
index 6f05e06f6761..1bcd82e1f662 100755
--- a/tools/testing/selftests/net/udpgro_fwd.sh
+++ b/tools/testing/selftests/net/udpgro_fwd.sh
@@ -46,7 +46,7 @@ create_ns() {
 		ip -n $BASE$ns addr add dev veth$ns $BM_NET_V4$ns/24
 		ip -n $BASE$ns addr add dev veth$ns $BM_NET_V6$ns/64 nodad
 	done
-	ip -n $NS_DST link set veth$DST xdp object ../bpf/xdp_dummy.o section xdp_dummy 2>/dev/null
+	ip -n $NS_DST link set veth$DST xdp object ../bpf/xdp_dummy.o section xdp 2>/dev/null
 }
 
 create_vxlan_endpoint() {
diff --git a/tools/testing/selftests/net/veth.sh b/tools/testing/selftests/net/veth.sh
index 19eac3e44c06..430895d1a2b6 100755
--- a/tools/testing/selftests/net/veth.sh
+++ b/tools/testing/selftests/net/veth.sh
@@ -289,14 +289,14 @@ if [ $CPUS -gt 1 ]; then
 	ip netns exec $NS_SRC ethtool -L veth$SRC rx 1 tx 2 2>/dev/null
 	printf "%-60s" "bad setting: XDP with RX nr less than TX"
 	ip -n $NS_DST link set dev veth$DST xdp object ../bpf/xdp_dummy.o \
-		section xdp_dummy 2>/dev/null &&\
+		section xdp 2>/dev/null &&\
 		echo "fail - set operation successful ?!?" || echo " ok "
 
 	# the following tests will run with multiple channels active
 	ip netns exec $NS_SRC ethtool -L veth$SRC rx 2
 	ip netns exec $NS_DST ethtool -L veth$DST rx 2
 	ip -n $NS_DST link set dev veth$DST xdp object ../bpf/xdp_dummy.o \
-		section xdp_dummy 2>/dev/null
+		section xdp 2>/dev/null
 	printf "%-60s" "bad setting: reducing RX nr below peer TX with XDP set"
 	ip netns exec $NS_DST ethtool -L veth$DST rx 1 2>/dev/null &&\
 		echo "fail - set operation successful ?!?" || echo " ok "
@@ -311,7 +311,7 @@ if [ $CPUS -gt 2 ]; then
 	chk_channels "setting invalid channels nr" $DST 2 2
 fi
 
-ip -n $NS_DST link set dev veth$DST xdp object ../bpf/xdp_dummy.o section xdp_dummy 2>/dev/null
+ip -n $NS_DST link set dev veth$DST xdp object ../bpf/xdp_dummy.o section xdp 2>/dev/null
 chk_gro_flag "with xdp attached - gro flag" $DST on
 chk_gro_flag "        - peer gro flag" $SRC off
 chk_tso_flag "        - tso flag" $SRC off
-- 
2.35.1


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 913726D7396
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 07:01:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236889AbjDEFB1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 01:01:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236593AbjDEFBZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 01:01:25 -0400
Received: from wout1-smtp.messagingengine.com (wout1-smtp.messagingengine.com [64.147.123.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE3A93599
        for <netdev@vger.kernel.org>; Tue,  4 Apr 2023 22:01:19 -0700 (PDT)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.west.internal (Postfix) with ESMTP id 9FF6A320027A;
        Wed,  5 Apr 2023 01:01:16 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Wed, 05 Apr 2023 01:01:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nikishkin.pw; h=
        cc:cc:content-transfer-encoding:content-type:date:date:from:from
        :in-reply-to:message-id:mime-version:reply-to:sender:subject
        :subject:to:to; s=fm2; t=1680670876; x=1680757276; bh=xXS0K5Cd3D
        iRfHUPC5Iu+xFsqnqNkRwmWb65+p5Eklc=; b=yywa6ThkAyZxT+u70TttYyTEM8
        jQW5V37BtfbZOJCNf/U4FOi7qKS3bi1YZzNBe7jFmQvz8Tr4umho2u2Wjw4t7TwT
        GC+rQjMC9zGn4rqnPXn3cQXL3WOpi1EhyKNWhhxu9ErLzAbXh6G/R3By9A6oId5o
        EqffLyCylwLdwbX3jEQ+zw1mOQWuEBkpkOi8Ja3A79XIWjWRS+N9bYIwqHoBplvB
        54ompFs59tQjQCrsv3ZMzpm37yqlPr22AY7L1eBFJ/kj7LFbDD2gneTjO1uj5EbK
        EXjG/QhGKq1Ag2gdctCEtpX1T0+gpNxL9hm4ubW+lxv553gLLiVl3UcHL8aQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding
        :content-type:date:date:feedback-id:feedback-id:from:from
        :in-reply-to:message-id:mime-version:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm2; t=1680670876; x=1680757276; bh=xXS0K5Cd3DiRf
        HUPC5Iu+xFsqnqNkRwmWb65+p5Eklc=; b=K/487RRYQzQICmyOh22csUJqefDv7
        ra5WTlZXKIeNGGpsLKWfxuScBofafVXFxCdO/1Oo/I/kErqttDB0vZWIszizRQvL
        0jDuB5J3JJHqXzeahwuxn+5zVZOLDc99PyhdP25PsyMzwp+dW6mgQBbpSQZJ5z6y
        lCR3GebRpL70usdOGRdYUYd/DE+pBInputFIQUCwdgrjeUP9tkkkPgdnuleE1X8n
        hh9gjYD42AIZdMgJmUGVv9VQCJqmBkABVOgco+2NxkOBwlIhaAHYWOY4VixNG411
        YuprZYUJMKIIiWRdXNzAKTxiqiqMOUa96eC7ziQv9cJCMMYxjydt33Q3Q==
X-ME-Sender: <xms:mwAtZJg-wnnsxpgRe0tm4MYk7coipE5CgUxFN2rGGKoMEjM3tUMRuw>
    <xme:mwAtZOBSByjaOVtbP_TJPXOegeq2Y7RmUS1FCp0nsQw7YwyGAvLOpC1tL54e7C7g0
    ldYW1qAMB79aELQJ-s>
X-ME-Received: <xmr:mwAtZJHhcz13HYE4ioG7rx3KbyR5Wp4rJ0VGrmN_NFEZJa9jfMSe-DAG2PIaHXRTwsV3WY1sbg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrvdejtddgkeekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucgfrhhlucfvnfffucdlfedtmdenucfjughrpefhvf
    evufffkffoggfgsedtkeertdertddtnecuhfhrohhmpegglhgrughimhhirhcupfhikhhi
    shhhkhhinhcuoehvlhgrughimhhirhesnhhikhhishhhkhhinhdrphifqeenucggtffrrg
    htthgvrhhnpeevjeetfeeftefhffelvefgteelieehveehgeeltdettedvtdekffelgeeg
    iedtveenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    hvlhgrughimhhirhesnhhikhhishhhkhhinhdrphif
X-ME-Proxy: <xmx:mwAtZOS8jjtSNB3eRLzZRwXXhJlHoKJrk71_QB6Vc-Z2j9dZRinSjA>
    <xmx:mwAtZGwJ76-bSjRfFbNXntO3LEyQXGQu3K5rAr2uNELnoaqnHkZWPQ>
    <xmx:mwAtZE6ntIOjPGprhHlBIAh_fyGbhrpV_2-ImaUmHn070YIz4dHj3A>
    <xmx:nAAtZI4pGyhIrZUenHNK3M9fRgBtKd1aVBrzLz3PWWD5krEA1EWE5g>
Feedback-ID: id3b446c5:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 5 Apr 2023 01:01:11 -0400 (EDT)
From:   Vladimir Nikishkin <vladimir@nikishkin.pw>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, eng.alaamohamedsoliman.am@gmail.com,
        gnault@redhat.com, razor@blackwall.org, idosch@nvidia.com,
        liuhangbin@gmail.com, eyal.birger@gmail.com, jtoppins@redhat.com,
        Vladimir Nikishkin <vladimir@nikishkin.pw>
Subject: [PATCH net-next v6] vxlan: try to send a packet normally if local bypass fails
Date:   Wed,  5 Apr 2023 13:01:02 +0800
Message-Id: <20230405050102.15612-1-vladimir@nikishkin.pw>
X-Mailer: git-send-email 2.35.7
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.9 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In vxlan_core, if an fdb entry is pointing to a local
address with some port, the system tries to get the packet to
deliver the packet to the vxlan directly, bypassing the network
stack.

This patch makes it still try canonical delivery, if there is no
linux kernel vxlan listening on this port. This will be useful
for the cases when there is some userspace daemon expecting
vxlan packets for post-processing, or some other implementation
of vxlan.

Signed-off-by: Vladimir Nikishkin <vladimir@nikishkin.pw>
---
 drivers/net/vxlan/vxlan_core.c                |  29 +++--
 include/net/vxlan.h                           |   4 +-
 include/uapi/linux/if_link.h                  |   1 +
 tools/include/uapi/linux/if_link.h            |   2 +
 tools/testing/selftests/net/Makefile          |   1 +
 tools/testing/selftests/net/rtnetlink.sh      |   3 +
 .../selftests/net/test_vxlan_nolocalbypass.sh | 102 ++++++++++++++++++
 7 files changed, 135 insertions(+), 7 deletions(-)
 create mode 100755 tools/testing/selftests/net/test_vxlan_nolocalbypass.sh

diff --git a/drivers/net/vxlan/vxlan_core.c b/drivers/net/vxlan/vxlan_core.c
index 561fe1b314f5..f9dfb179af58 100644
--- a/drivers/net/vxlan/vxlan_core.c
+++ b/drivers/net/vxlan/vxlan_core.c
@@ -2341,7 +2341,7 @@ static int encap_bypass_if_local(struct sk_buff *skb, struct net_device *dev,
 				 union vxlan_addr *daddr,
 				 __be16 dst_port, int dst_ifindex, __be32 vni,
 				 struct dst_entry *dst,
-				 u32 rt_flags)
+				 u32 rt_flags, bool localbypass)
 {
 #if IS_ENABLED(CONFIG_IPV6)
 	/* IPv6 rt-flags are checked against RTF_LOCAL, but the value of
@@ -2355,11 +2355,13 @@ static int encap_bypass_if_local(struct sk_buff *skb, struct net_device *dev,
 	    !(rt_flags & (RTCF_BROADCAST | RTCF_MULTICAST))) {
 		struct vxlan_dev *dst_vxlan;
 
-		dst_release(dst);
 		dst_vxlan = vxlan_find_vni(vxlan->net, dst_ifindex, vni,
 					   daddr->sa.sa_family, dst_port,
 					   vxlan->cfg.flags);
 		if (!dst_vxlan) {
+			if (!localbypass)
+				return 0;
+			dst_release(dst);
 			dev->stats.tx_errors++;
 			vxlan_vnifilter_count(vxlan, vni, NULL,
 					      VXLAN_VNI_STATS_TX_ERRORS, 0);
@@ -2367,6 +2369,7 @@ static int encap_bypass_if_local(struct sk_buff *skb, struct net_device *dev,
 
 			return -ENOENT;
 		}
+		dst_release(dst);
 		vxlan_encap_bypass(skb, vxlan, dst_vxlan, vni, true);
 		return 1;
 	}
@@ -2494,9 +2497,11 @@ void vxlan_xmit_one(struct sk_buff *skb, struct net_device *dev,
 
 		if (!info) {
 			/* Bypass encapsulation if the destination is local */
+			bool localbypass = flags & VXLAN_F_LOCALBYPASS;
 			err = encap_bypass_if_local(skb, dev, vxlan, dst,
 						    dst_port, ifindex, vni,
-						    &rt->dst, rt->rt_flags);
+						    &rt->dst, rt->rt_flags,
+						    localbypass);
 			if (err)
 				goto out_unlock;
 
@@ -2568,10 +2573,10 @@ void vxlan_xmit_one(struct sk_buff *skb, struct net_device *dev,
 
 		if (!info) {
 			u32 rt6i_flags = ((struct rt6_info *)ndst)->rt6i_flags;
-
+			bool localbypass = flags & VXLAN_F_LOCALBYPASS;
 			err = encap_bypass_if_local(skb, dev, vxlan, dst,
 						    dst_port, ifindex, vni,
-						    ndst, rt6i_flags);
+						    ndst, rt6i_flags, localbypass);
 			if (err)
 				goto out_unlock;
 		}
@@ -3202,6 +3207,7 @@ static const struct nla_policy vxlan_policy[IFLA_VXLAN_MAX + 1] = {
 	[IFLA_VXLAN_TTL_INHERIT]	= { .type = NLA_FLAG },
 	[IFLA_VXLAN_DF]		= { .type = NLA_U8 },
 	[IFLA_VXLAN_VNIFILTER]	= { .type = NLA_U8 },
+	[IFLA_VXLAN_LOCALBYPASS]	= { .type = NLA_U8 },
 };
 
 static int vxlan_validate(struct nlattr *tb[], struct nlattr *data[],
@@ -4011,6 +4017,14 @@ static int vxlan_nl2conf(struct nlattr *tb[], struct nlattr *data[],
 			conf->flags |= VXLAN_F_UDP_ZERO_CSUM_TX;
 	}
 
+	if (data[IFLA_VXLAN_LOCALBYPASS]) {
+		err = vxlan_nl2flag(conf, data, IFLA_VXLAN_LOCALBYPASS,
+				    VXLAN_F_LOCALBYPASS, changelink,
+				    false, extack);
+		if (err)
+			return err;
+	}
+
 	if (data[IFLA_VXLAN_UDP_ZERO_CSUM6_TX]) {
 		err = vxlan_nl2flag(conf, data, IFLA_VXLAN_UDP_ZERO_CSUM6_TX,
 				    VXLAN_F_UDP_ZERO_CSUM6_TX, changelink,
@@ -4232,6 +4246,7 @@ static size_t vxlan_get_size(const struct net_device *dev)
 		nla_total_size(sizeof(__u8)) + /* IFLA_VXLAN_UDP_ZERO_CSUM6_RX */
 		nla_total_size(sizeof(__u8)) + /* IFLA_VXLAN_REMCSUM_TX */
 		nla_total_size(sizeof(__u8)) + /* IFLA_VXLAN_REMCSUM_RX */
+		nla_total_size(sizeof(__u8)) + /* IFLA_VXLAN_LOCALBYPASS */
 		0;
 }
 
@@ -4308,7 +4323,9 @@ static int vxlan_fill_info(struct sk_buff *skb, const struct net_device *dev)
 	    nla_put_u8(skb, IFLA_VXLAN_REMCSUM_TX,
 		       !!(vxlan->cfg.flags & VXLAN_F_REMCSUM_TX)) ||
 	    nla_put_u8(skb, IFLA_VXLAN_REMCSUM_RX,
-		       !!(vxlan->cfg.flags & VXLAN_F_REMCSUM_RX)))
+		       !!(vxlan->cfg.flags & VXLAN_F_REMCSUM_RX)) ||
+	    nla_put_u8(skb, IFLA_VXLAN_LOCALBYPASS,
+		       !!(vxlan->cfg.flags & VXLAN_F_LOCALBYPASS)))
 		goto nla_put_failure;
 
 	if (nla_put(skb, IFLA_VXLAN_PORT_RANGE, sizeof(ports), &ports))
diff --git a/include/net/vxlan.h b/include/net/vxlan.h
index 20bd7d893e10..0be91ca78d3a 100644
--- a/include/net/vxlan.h
+++ b/include/net/vxlan.h
@@ -328,6 +328,7 @@ struct vxlan_dev {
 #define VXLAN_F_TTL_INHERIT		0x10000
 #define VXLAN_F_VNIFILTER               0x20000
 #define VXLAN_F_MDB			0x40000
+#define VXLAN_F_LOCALBYPASS		0x80000
 
 /* Flags that are used in the receive path. These flags must match in
  * order for a socket to be shareable
@@ -348,7 +349,8 @@ struct vxlan_dev {
 					 VXLAN_F_UDP_ZERO_CSUM6_TX |	\
 					 VXLAN_F_UDP_ZERO_CSUM6_RX |	\
 					 VXLAN_F_COLLECT_METADATA  |	\
-					 VXLAN_F_VNIFILTER)
+					 VXLAN_F_VNIFILTER         |    \
+					 VXLAN_F_LOCALBYPASS)
 
 struct net_device *vxlan_dev_create(struct net *net, const char *name,
 				    u8 name_assign_type, struct vxlan_config *conf);
diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
index 8d679688efe0..0fc56be5e19f 100644
--- a/include/uapi/linux/if_link.h
+++ b/include/uapi/linux/if_link.h
@@ -827,6 +827,7 @@ enum {
 	IFLA_VXLAN_TTL_INHERIT,
 	IFLA_VXLAN_DF,
 	IFLA_VXLAN_VNIFILTER, /* only applicable with COLLECT_METADATA mode */
+	IFLA_VXLAN_LOCALBYPASS,
 	__IFLA_VXLAN_MAX
 };
 #define IFLA_VXLAN_MAX	(__IFLA_VXLAN_MAX - 1)
diff --git a/tools/include/uapi/linux/if_link.h b/tools/include/uapi/linux/if_link.h
index 39e659c83cfd..1253bd0aa90e 100644
--- a/tools/include/uapi/linux/if_link.h
+++ b/tools/include/uapi/linux/if_link.h
@@ -748,6 +748,8 @@ enum {
 	IFLA_VXLAN_GPE,
 	IFLA_VXLAN_TTL_INHERIT,
 	IFLA_VXLAN_DF,
+	IFLA_VXLAN_VNIFILTER,
+	IFLA_VXLAN_LOCALBYPASS,
 	__IFLA_VXLAN_MAX
 };
 #define IFLA_VXLAN_MAX	(__IFLA_VXLAN_MAX - 1)
diff --git a/tools/testing/selftests/net/Makefile b/tools/testing/selftests/net/Makefile
index 1de34ec99290..7a9cfd0c92db 100644
--- a/tools/testing/selftests/net/Makefile
+++ b/tools/testing/selftests/net/Makefile
@@ -83,6 +83,7 @@ TEST_GEN_FILES += nat6to4.o
 TEST_GEN_FILES += ip_local_port_range
 TEST_GEN_FILES += bind_wildcard
 TEST_PROGS += test_vxlan_mdb.sh
+TEST_PROGS += test_vxlan_nolocalbypass.sh
 
 TEST_FILES := settings
 
diff --git a/tools/testing/selftests/net/rtnetlink.sh b/tools/testing/selftests/net/rtnetlink.sh
index 383ac6fc037d..09a5ef4bd42b 100755
--- a/tools/testing/selftests/net/rtnetlink.sh
+++ b/tools/testing/selftests/net/rtnetlink.sh
@@ -505,6 +505,9 @@ kci_test_encap_vxlan()
 	ip -netns "$testns" link set dev "$vxlan" type vxlan udpcsum 2>/dev/null
 	check_fail $?
 
+	ip -netns "$testns" link set dev "$vxlan" type vxlan nolocalbypass 2>/dev/null
+	check_fail $?
+
 	ip -netns "$testns" link set dev "$vxlan" type vxlan udp6zerocsumtx 2>/dev/null
 	check_fail $?
 
diff --git a/tools/testing/selftests/net/test_vxlan_nolocalbypass.sh b/tools/testing/selftests/net/test_vxlan_nolocalbypass.sh
new file mode 100755
index 000000000000..efa37af2da7b
--- /dev/null
+++ b/tools/testing/selftests/net/test_vxlan_nolocalbypass.sh
@@ -0,0 +1,102 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+
+# This file is testing that the [no]localbypass option for a vxlan device is
+# working. With the nolocalbypass option, packets to a local destination, which
+# have no corresponding vxlan in the kernel, will be delivered to userspace, for
+# any userspace process to process. In this test tcpdump plays the role of such a
+# process. This is what the test 1 is checking.
+# The test 2 checks that without the nolocalbypass (which is equivalent to the
+# localbypass option), the packets do not reach userspace.
+
+EXIT_FAIL=1
+ksft_skip=4
+EXIT_SUCCESS=0
+
+if [ "$(id -u)" -ne 0 ];then
+        echo "SKIP: Need root privileges"
+        exit $ksft_skip;
+fi
+
+if [ ! -x "$(command -v ip)" ]; then
+        echo "SKIP: Could not run test without ip tool"
+        exit $ksft_skip
+fi
+
+if [ ! -x "$(command -v bridge)" ]; then
+        echo "SKIP: Could not run test without bridge tool"
+        exit $ksft_skip
+fi
+
+if [ ! -x "$(command -v tcpdump)" ]; then
+        echo "SKIP: Could not run test without tcpdump tool"
+        exit $ksft_skip
+fi
+
+if [ ! -x "$(command -v grep)" ]; then
+        echo "SKIP: Could not run test without grep tool"
+        exit $ksft_skip
+fi
+
+ip link help vxlan 2>&1 | grep -q "localbypass"
+if [ $? -ne 0 ]; then
+   echo "SKIP: iproute2 bridge too old, missing VXLAN nolocalbypass support"
+   exit $ksft_skip
+fi
+
+
+packetfile=/tmp/packets-"$(uuidgen)"
+
+# test 1: packets going to userspace
+rm "$packetfile"
+ip link del dev testvxlan0
+ip link add testvxlan0 type vxlan  \
+  id 100 \
+  dstport 4789 \
+  srcport 4789 4790 \
+  nolearning noproxy \
+  nolocalbypass
+ip link set up dev testvxlan0
+bridge fdb add 00:00:00:00:00:00 dev testvxlan0 dst 127.0.0.1 port 4792
+ip address add 172.16.100.1/24 dev testvxlan0
+tcpdump -i lo 'udp and port 4792' > "$packetfile" &
+tcpdump_pid=$!
+timeout 5 ping -c 5 172.16.100.2
+kill "$tcpdump_pid"
+ip link del dev testvxlan0
+
+if grep -q "VXLAN" "$packetfile" ; then
+  echo 'Positive test passed'
+else
+  echo 'Positive test failed'
+  exit $EXIT_FAIL
+fi
+rm "$packetfile"
+
+# test 2: old behaviour preserved
+ip link del dev testvxlan0
+ip link add testvxlan0 type vxlan  \
+  id 100 \
+  dstport 4789 \
+  srcport 4789 4790 \
+  nolearning noproxy \
+  localbypass
+ip link set up dev testvxlan0
+bridge fdb add 00:00:00:00:00:00 dev testvxlan0 dst 127.0.0.1 port 4792
+ip address add 172.16.100.1/24 dev testvxlan0
+tcpdump -i lo 'udp and port 4792' > "$packetfile" &
+tcpdump_pid=$!
+timeout 5 ping -c 5 172.16.100.2
+kill "$tcpdump_pid"
+ip link del dev testvxlan0
+
+if grep -q "VXLAN" "$packetfile" ; then
+  echo 'Negative test failed'
+  exit $EXIT_FAIL
+else
+  echo 'Negative test passed'
+fi
+rm "$packetfile"
+
+exit $EXIT_SUCCESS
+
-- 
2.35.7

--
Fastmail.


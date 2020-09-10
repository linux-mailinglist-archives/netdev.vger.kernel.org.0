Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDA57264507
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 13:04:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730512AbgIJLEx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 07:04:53 -0400
Received: from new2-smtp.messagingengine.com ([66.111.4.224]:52647 "EHLO
        new2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730624AbgIJLCQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 07:02:16 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.nyi.internal (Postfix) with ESMTP id 17CF958038E;
        Thu, 10 Sep 2020 07:02:13 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Thu, 10 Sep 2020 07:02:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=Ghd7Lhk3+TiY5a3bWin7YFFz5q1YcBN7Vsnjd4d2VOs=; b=hXWtNgfh
        1FqbExOV6GKJ1Y8bCPjZNQqq/qGOcjWxlQ9sXZ/sClfDas6KuNhTuYl14mwxaYnf
        3U5fRbT/milxjN7PeMQAXoFu5RNsfmPgr4WhnAJ61jLUbCdGeVIuI6Sxs/FUV70+
        r0b7JzjfRK/w1XAOLI2u3LA6HN4oGlDUSooF7768AmEHh7/0u5bivmV3mUjBLY6j
        ktnpsZtcIgpQsat5jDNCTa+lG/dNyRuK56o6tyuEPjwmMXcKmbwFfX0O8PWzugL7
        GqiuIHPzpR5Yiun0ynD7jwvV/zDg55POfO86w5m/UIEU8uz3ZtkGG8DL13r0lV2s
        Sl/XF14p7GG8cg==
X-ME-Sender: <xms:tAdaX5It6i5VRbNDENwg4o0Kc2Q9QymrXa8lUUq_FW2OeCOxjGMC8A>
    <xme:tAdaX1KvNEU8f8Dcj6rTkn1pe0CQtah021jmcjs4byry7TdERYwgS3Qc14rIMJsVM
    Ex8wBDKSk-GaeU>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrudehjedgvdelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrfeeirddufedu
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:tAdaXxuq6n9dV9MIZT7TVyT3KNB5FQd7jCaexfG4kFwhId-bhhq2xg>
    <xmx:tAdaX6YbhssN-I_Id5cNGOmR9vf6QkvbOLhk-VZsNU9IHjf0ibwfaw>
    <xmx:tAdaXwauPNJ9ai59qF-8RTsQIuHDd6n5WrmCHIKlVKkmLbbrWfsulw>
    <xmx:tQdaX2NP1LuhBvgSwVDzKmD6Ocx8YwJpDrkSE19MKjlftA4V5VVgew>
Received: from shredder.mtl.com (igld-84-229-36-131.inter.net.il [84.229.36.131])
        by mail.messagingengine.com (Postfix) with ESMTPA id DA1D93064683;
        Thu, 10 Sep 2020 07:02:10 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        nikolay@nvidia.com, roopa@nvidia.com,
        vasundhara-v.volam@broadcom.com, jtoppins@redhat.com,
        michael.chan@broadcom.com, andrew@lunn.ch, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net 2/2] selftests: rtnetlink: Test bridge enslavement with different parent IDs
Date:   Thu, 10 Sep 2020 14:01:27 +0300
Message-Id: <20200910110127.3113683-3-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200910110127.3113683-1-idosch@idosch.org>
References: <20200910110127.3113683-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Test that an upper device of netdevs with different parent IDs can be
enslaved to a bridge.

The test fails without previous commit.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Reviewed-by: Nikolay Aleksandrov <nikolay@nvidia.com>
---
 tools/testing/selftests/net/rtnetlink.sh | 47 ++++++++++++++++++++++++
 1 file changed, 47 insertions(+)

diff --git a/tools/testing/selftests/net/rtnetlink.sh b/tools/testing/selftests/net/rtnetlink.sh
index 7c38a909f8b8..8a2fe6d64bf2 100755
--- a/tools/testing/selftests/net/rtnetlink.sh
+++ b/tools/testing/selftests/net/rtnetlink.sh
@@ -1175,6 +1175,51 @@ kci_test_neigh_get()
 	echo "PASS: neigh get"
 }
 
+kci_test_bridge_parent_id()
+{
+	local ret=0
+	sysfsnet=/sys/bus/netdevsim/devices/netdevsim
+	probed=false
+
+	if [ ! -w /sys/bus/netdevsim/new_device ] ; then
+		modprobe -q netdevsim
+		check_err $?
+		if [ $ret -ne 0 ]; then
+			echo "SKIP: bridge_parent_id can't load netdevsim"
+			return $ksft_skip
+		fi
+		probed=true
+	fi
+
+	echo "10 1" > /sys/bus/netdevsim/new_device
+	while [ ! -d ${sysfsnet}10 ] ; do :; done
+	echo "20 1" > /sys/bus/netdevsim/new_device
+	while [ ! -d ${sysfsnet}20 ] ; do :; done
+	udevadm settle
+	dev10=`ls ${sysfsnet}10/net/`
+	dev20=`ls ${sysfsnet}20/net/`
+
+	ip link add name test-bond0 type bond mode 802.3ad
+	ip link set dev $dev10 master test-bond0
+	ip link set dev $dev20 master test-bond0
+	ip link add name test-br0 type bridge
+	ip link set dev test-bond0 master test-br0
+	check_err $?
+
+	# clean up any leftovers
+	ip link del dev test-br0
+	ip link del dev test-bond0
+	echo 20 > /sys/bus/netdevsim/del_device
+	echo 10 > /sys/bus/netdevsim/del_device
+	$probed && rmmod netdevsim
+
+	if [ $ret -ne 0 ]; then
+		echo "FAIL: bridge_parent_id"
+		return 1
+	fi
+	echo "PASS: bridge_parent_id"
+}
+
 kci_test_rtnl()
 {
 	local ret=0
@@ -1224,6 +1269,8 @@ kci_test_rtnl()
 	check_err $?
 	kci_test_neigh_get
 	check_err $?
+	kci_test_bridge_parent_id
+	check_err $?
 
 	kci_del_dummy
 	return $ret
-- 
2.26.2


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE73261468
	for <lists+netdev@lfdr.de>; Sun,  7 Jul 2019 10:04:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727372AbfGGIEJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Jul 2019 04:04:09 -0400
Received: from new2-smtp.messagingengine.com ([66.111.4.224]:33699 "EHLO
        new2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726330AbfGGIEI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Jul 2019 04:04:08 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id 54F5511D2;
        Sun,  7 Jul 2019 04:04:07 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Sun, 07 Jul 2019 04:04:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=8AJxmEzpoeWIykhTtb77rUFAqcOZvj5GHWt8atNXf6w=; b=shqUF7P5
        DkThnJ1b1UHho9wy/hgBSp1Mu6mvv0xcILdKS7TdoCyY9Ns+k8SHrGcIrg49xW9L
        2s+juUEWSgL9jGTNgMP8Nx6jME7CgSsopE9wd1pg4J2R5a8gI8GDwVskXKupQGE9
        mxsGaYx7ttSiubfuBvivucmdUAM4lKMADjfW5zWU/mtOFAuGqa3jItSLz8dLIJk8
        CeU9WRNbVy+JI2OfGElzSlDOYil+gPqMaVbKMJHkaKDOfLPOwXn9iiMyja3EEAZz
        W70N6vjw+p1x4Mr2DUXtBT03Li0cqgIn5IxFR5qpVWzNR/NaPD6+GeegPi0IH0kh
        GTc631DtgYnXjw==
X-ME-Sender: <xms:d6chXZc8T8BF4zwLKxk02sTZSZPWhj22F6jWZuQq6t_Qp-IIrTMDtA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrfeejgdduvdejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpedt
X-ME-Proxy: <xmx:d6chXefiOaEt1sE3ktS7tHZ6r6XixNmsSE3XRYdtb-2V4OOvmgqi1Q>
    <xmx:d6chXSDr1FLm7HJxeEStPKfh-TdmCIGjJt0puVh5RTZg-87xL72Qaw>
    <xmx:d6chXcFkyB2CxhhB5pQoFpij4oez_UG2Ypl5oyjO3ITGeeRZn5HE1Q>
    <xmx:d6chXapZ-SkOUMNeKPcdhtb1m4EM4qR-lLjSg_UjXL_KmLJiY6liiQ>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id AFC7A8005C;
        Sun,  7 Jul 2019 04:04:04 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, mlxsw@mellanox.com,
        dsahern@gmail.com, roopa@cumulusnetworks.com,
        nikolay@cumulusnetworks.com, andy@greyhouse.net,
        pablo@netfilter.org, jakub.kicinski@netronome.com,
        pieter.jansenvanvuuren@netronome.com, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [RFC PATCH net-next 3/5] selftests: forwarding: devlink_lib: Add devlink-trap helpers
Date:   Sun,  7 Jul 2019 11:03:34 +0300
Message-Id: <20190707080336.3794-4-idosch@idosch.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190707080336.3794-1-idosch@idosch.org>
References: <20190707075828.3315-1-idosch@idosch.org>
 <20190707080336.3794-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

Add helpers to interact with devlink-trap, such as setting the action of
a trap and retrieving statistics.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 .../selftests/net/forwarding/devlink_lib.sh   | 125 ++++++++++++++++++
 1 file changed, 125 insertions(+)

diff --git a/tools/testing/selftests/net/forwarding/devlink_lib.sh b/tools/testing/selftests/net/forwarding/devlink_lib.sh
index 8553a67a2322..101a63f8fc5f 100644
--- a/tools/testing/selftests/net/forwarding/devlink_lib.sh
+++ b/tools/testing/selftests/net/forwarding/devlink_lib.sh
@@ -27,6 +27,12 @@ if [ $? -ne 0 ]; then
 	exit 1
 fi
 
+devlink help 2>&1 | grep "trap" &> /dev/null
+if [ $? -ne 0 ]; then
+	echo "SKIP: iproute2 too old, missing devlink-trap"
+	exit $KSFT_SKIP
+fi
+
 ##############################################################################
 # Devlink helpers
 
@@ -190,3 +196,122 @@ devlink_tc_bind_pool_th_restore()
 	devlink sb tc bind set $port tc $tc type $dir \
 		pool ${orig[0]} th ${orig[1]}
 }
+
+devlink_trap_report_set()
+{
+	local trap_name=$1; shift
+	local report=$1; shift
+
+	# Pipe output to /dev/null to avoid expected warnings.
+	devlink trap set $DEVLINK_DEV trap $trap_name report $report \
+		&> /dev/null
+}
+
+devlink_trap_action_set()
+{
+	local trap_name=$1; shift
+	local action=$1; shift
+
+	# Pipe output to /dev/null to avoid expected warnings.
+	devlink trap set $DEVLINK_DEV trap $trap_name \
+		action $action &> /dev/null
+}
+
+devlink_trap_rx_packets_get()
+{
+	local trap_name=$1; shift
+
+	devlink -js trap show $DEVLINK_DEV trap $trap_name \
+		| jq '.[][][]["stats"]["rx"]["packets"]'
+}
+
+devlink_trap_rx_bytes_get()
+{
+	local trap_name=$1; shift
+
+	devlink -js trap show $DEVLINK_DEV trap $trap_name \
+		| jq '.[][][]["stats"]["rx"]["bytes"]'
+}
+
+devlink_trap_stats_idle_test()
+{
+	local trap_name=$1; shift
+	local t0_packets t0_bytes
+	local t1_packets t1_bytes
+
+	t0_packets=$(devlink_trap_rx_packets_get $trap_name)
+	t0_bytes=$(devlink_trap_rx_bytes_get $trap_name)
+
+	sleep 1
+
+	t1_packets=$(devlink_trap_rx_packets_get $trap_name)
+	t1_bytes=$(devlink_trap_rx_bytes_get $trap_name)
+
+	if [[ $t0_packets -eq $t1_packets && $t0_bytes -eq $t1_bytes ]]; then
+		return 0
+	else
+		return 1
+	fi
+}
+
+devlink_trap_group_rx_packets_get()
+{
+	local group_name=$1; shift
+
+	devlink -js trap group show $DEVLINK_DEV group $group_name \
+		| jq '.[][][]["stats"]["rx"]["packets"]'
+}
+
+devlink_trap_group_rx_bytes_get()
+{
+	local group_name=$1; shift
+
+	devlink -js trap group show $DEVLINK_DEV group $group_name \
+		| jq '.[][][]["stats"]["rx"]["bytes"]'
+}
+
+devlink_trap_group_stats_idle_test()
+{
+	local group_name=$1; shift
+	local t0_packets t0_bytes
+	local t1_packets t1_bytes
+
+	t0_packets=$(devlink_trap_group_rx_packets_get $group_name)
+	t0_bytes=$(devlink_trap_group_rx_bytes_get $group_name)
+
+	sleep 1
+
+	t1_packets=$(devlink_trap_group_rx_packets_get $group_name)
+	t1_bytes=$(devlink_trap_group_rx_bytes_get $group_name)
+
+	if [[ $t0_packets -eq $t1_packets && $t0_bytes -eq $t1_bytes ]]; then
+		return 0
+	else
+		return 1
+	fi
+}
+
+devlink_trap_mon_input_port_test()
+{
+	local trap_name=$1; shift
+	local input_port=$1; shift
+	local devlink_pid
+	local tmp_dir
+	local rc
+
+	tmp_dir="$(mktemp -d)"
+
+	devlink_trap_report_set $trap_name "true"
+	timeout 1 devlink -v mon trap-report &> ${tmp_dir}/reports.txt
+	devlink_trap_report_set $trap_name "false"
+
+	grep -e "$trap_name" ${tmp_dir}/reports.txt -A 2 \
+		| grep -q -e "$input_port"
+
+	# Return false if no reports were found.
+	rc=$?
+
+	rm -rf $tmp_dir
+
+	return $rc
+}
-- 
2.20.1


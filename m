Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 636B333A4B3
	for <lists+netdev@lfdr.de>; Sun, 14 Mar 2021 13:22:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235372AbhCNMU5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Mar 2021 08:20:57 -0400
Received: from new2-smtp.messagingengine.com ([66.111.4.224]:32965 "EHLO
        new2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235317AbhCNMU2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Mar 2021 08:20:28 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id 220965808B9;
        Sun, 14 Mar 2021 08:20:28 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Sun, 14 Mar 2021 08:20:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=Jy6zdGV7LEDTSTm2PmkfRxx51ZPdgJpL+NEw6b1svlk=; b=brGon87M
        ft49+q9LOeiEFCBVBT5y4XTxp8o4N1mvay6EfdGtIpskP0S/pHgo6XukMiRVutYM
        CUH+8JITEUK7iVoxeZy7Hd0R1lXeJ5RMMia+pwtBNErDWzkc12lUcAW/+n9x913+
        fyi4PaJJNuUL326GfT5LnSKY7Npsy8aKfDXIA5yCO+Luldjx33goCe1O5PQ5SdQh
        cAyOUjlu/l+xip38jO5XwAiMyoO7jEwxEfxzQRxV5IVVJ2b6EpFCelTukPEpTKDC
        3OPQJXFyvMM16wTeH8+9J6qoSmfcR5HYxw6xX995Ct8qZ0IaYBLee6wGUVg3YrIe
        uStpkPXUQV0FtQ==
X-ME-Sender: <xms:jP9NYEA6hQOBWmevV6yArW4ohGoFig1AmwmnjsDDlUqKYwQ5DHt9uw>
    <xme:jP9NYGhpBa32VwzBA2MqE5pVvy0PpK54hpzfgu1s9jcdVJ6wsaV-v3HKpwS5gWmAh
    FRBnauuL_UZy94>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledruddvjedgudefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepfeeghfehveehvefhteekueehfeeffe
    eitddvffeltdelgfefffdvjeduleefudefnecuffhomhgrihhnpehgihhthhhusgdrtgho
    mhenucfkphepkeegrddvvdelrdduheefrdeggeenucevlhhushhtvghrufhiiigvpedtne
    curfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:jP9NYHmpQdueR_EJwVbOpJC4yUXgsB4-4k0eHe13qhrnhmDRLlq5aQ>
    <xmx:jP9NYKxKp8ef_Cub6GjckyixlY6f6nWQXbluWvqCcUEK5sqYXfNUXA>
    <xmx:jP9NYJQXJYq748f3EdWK8viCYhmtmy0TOGIO20NPEFnC7NhsbFz7JQ>
    <xmx:jP9NYEHigZHtxeoRb1r_cYB-ALY3nB0q9KKWMDdoU57zfveFGElP_A>
Received: from shredder.lan (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id B8436240054;
        Sun, 14 Mar 2021 08:20:25 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        yotam.gi@gmail.com, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        roopa@nvidia.com, peter.phaal@inmon.com, neil.mckee@inmon.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 04/11] selftests: netdevsim: Test psample functionality
Date:   Sun, 14 Mar 2021 14:19:33 +0200
Message-Id: <20210314121940.2807621-5-idosch@idosch.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210314121940.2807621-1-idosch@idosch.org>
References: <20210314121940.2807621-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Test various aspects of psample functionality over netdevsim and in
particular test that the psample module correctly reports the provided
metadata.

Example:

 # ./psample.sh
 TEST: psample enable / disable                                      [ OK ]
 TEST: psample group number                                          [ OK ]
 TEST: psample metadata                                              [ OK ]

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../drivers/net/netdevsim/psample.sh          | 181 ++++++++++++++++++
 1 file changed, 181 insertions(+)
 create mode 100755 tools/testing/selftests/drivers/net/netdevsim/psample.sh

diff --git a/tools/testing/selftests/drivers/net/netdevsim/psample.sh b/tools/testing/selftests/drivers/net/netdevsim/psample.sh
new file mode 100755
index 000000000000..ee10b1a8933c
--- /dev/null
+++ b/tools/testing/selftests/drivers/net/netdevsim/psample.sh
@@ -0,0 +1,181 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+#
+# This test is for checking the psample module. It makes use of netdevsim
+# which periodically generates "sampled" packets.
+
+lib_dir=$(dirname $0)/../../../net/forwarding
+
+ALL_TESTS="
+	psample_enable_test
+	psample_group_num_test
+	psample_md_test
+"
+NETDEVSIM_PATH=/sys/bus/netdevsim/
+DEV_ADDR=1337
+DEV=netdevsim${DEV_ADDR}
+DEVLINK_DEV=netdevsim/${DEV}
+SYSFS_NET_DIR=/sys/bus/netdevsim/devices/$DEV/net/
+PSAMPLE_DIR=/sys/kernel/debug/netdevsim/$DEV/psample/
+CAPTURE_FILE=$(mktemp)
+NUM_NETIFS=0
+source $lib_dir/lib.sh
+source $lib_dir/devlink_lib.sh
+
+# Available at https://github.com/Mellanox/libpsample
+require_command psample
+
+psample_capture()
+{
+	rm -f $CAPTURE_FILE
+
+	timeout 2 ip netns exec testns1 psample &> $CAPTURE_FILE
+}
+
+psample_enable_test()
+{
+	RET=0
+
+	echo 1 > $PSAMPLE_DIR/enable
+	check_err $? "Failed to enable sampling when should not"
+
+	echo 1 > $PSAMPLE_DIR/enable 2>/dev/null
+	check_fail $? "Sampling enablement succeeded when should fail"
+
+	psample_capture
+	if [ $(cat $CAPTURE_FILE | wc -l) -eq 0 ]; then
+		check_err 1 "Failed to capture sampled packets"
+	fi
+
+	echo 0 > $PSAMPLE_DIR/enable
+	check_err $? "Failed to disable sampling when should not"
+
+	echo 0 > $PSAMPLE_DIR/enable 2>/dev/null
+	check_fail $? "Sampling disablement succeeded when should fail"
+
+	psample_capture
+	if [ $(cat $CAPTURE_FILE | wc -l) -ne 0 ]; then
+		check_err 1 "Captured sampled packets when should not"
+	fi
+
+	log_test "psample enable / disable"
+}
+
+psample_group_num_test()
+{
+	RET=0
+
+	echo 1234 > $PSAMPLE_DIR/group_num
+	echo 1 > $PSAMPLE_DIR/enable
+
+	psample_capture
+	grep -q -e "group 1234" $CAPTURE_FILE
+	check_err $? "Sampled packets reported with wrong group number"
+
+	# New group number should only be used after disable / enable.
+	echo 4321 > $PSAMPLE_DIR/group_num
+
+	psample_capture
+	grep -q -e "group 4321" $CAPTURE_FILE
+	check_fail $? "Group number changed while sampling is active"
+
+	echo 0 > $PSAMPLE_DIR/enable && echo 1 > $PSAMPLE_DIR/enable
+
+	psample_capture
+	grep -q -e "group 4321" $CAPTURE_FILE
+	check_err $? "Group number did not change after restarting sampling"
+
+	log_test "psample group number"
+
+	echo 0 > $PSAMPLE_DIR/enable
+}
+
+psample_md_test()
+{
+	RET=0
+
+	echo 1 > $PSAMPLE_DIR/enable
+
+	echo 1234 > $PSAMPLE_DIR/in_ifindex
+	echo 4321 > $PSAMPLE_DIR/out_ifindex
+	psample_capture
+
+	grep -q -e "in-ifindex 1234" $CAPTURE_FILE
+	check_err $? "Sampled packets reported with wrong in-ifindex"
+
+	grep -q -e "out-ifindex 4321" $CAPTURE_FILE
+	check_err $? "Sampled packets reported with wrong out-ifindex"
+
+	echo 5 > $PSAMPLE_DIR/out_tc
+	psample_capture
+
+	grep -q -e "out-tc 5" $CAPTURE_FILE
+	check_err $? "Sampled packets reported with wrong out-tc"
+
+	echo $((2**16 - 1)) > $PSAMPLE_DIR/out_tc
+	psample_capture
+
+	grep -q -e "out-tc " $CAPTURE_FILE
+	check_fail $? "Sampled packets reported with out-tc when should not"
+
+	echo 1 > $PSAMPLE_DIR/out_tc
+	echo 10000 > $PSAMPLE_DIR/out_tc_occ_max
+	psample_capture
+
+	grep -q -e "out-tc-occ " $CAPTURE_FILE
+	check_err $? "Sampled packets not reported with out-tc-occ when should"
+
+	echo 0 > $PSAMPLE_DIR/out_tc_occ_max
+	psample_capture
+
+	grep -q -e "out-tc-occ " $CAPTURE_FILE
+	check_fail $? "Sampled packets reported with out-tc-occ when should not"
+
+	echo 10000 > $PSAMPLE_DIR/latency_max
+	psample_capture
+
+	grep -q -e "latency " $CAPTURE_FILE
+	check_err $? "Sampled packets not reported with latency when should"
+
+	echo 0 > $PSAMPLE_DIR/latency_max
+	psample_capture
+
+	grep -q -e "latency " $CAPTURE_FILE
+	check_fail $? "Sampled packets reported with latency when should not"
+
+	log_test "psample metadata"
+
+	echo 0 > $PSAMPLE_DIR/enable
+}
+
+setup_prepare()
+{
+	modprobe netdevsim &> /dev/null
+
+	echo "$DEV_ADDR 1" > ${NETDEVSIM_PATH}/new_device
+	while [ ! -d $SYSFS_NET_DIR ] ; do :; done
+
+	set -e
+
+	ip netns add testns1
+	devlink dev reload $DEVLINK_DEV netns testns1
+
+	set +e
+}
+
+cleanup()
+{
+	pre_cleanup
+	rm -f $CAPTURE_FILE
+	ip netns del testns1
+	echo "$DEV_ADDR" > ${NETDEVSIM_PATH}/del_device
+	modprobe -r netdevsim &> /dev/null
+}
+
+trap cleanup EXIT
+
+setup_prepare
+
+tests_run
+
+exit $EXIT_STATUS
-- 
2.29.2


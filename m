Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01E092466B1
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 14:52:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728529AbgHQMws (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 08:52:48 -0400
Received: from wnew3-smtp.messagingengine.com ([64.147.123.17]:41735 "EHLO
        wnew3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728460AbgHQMwn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Aug 2020 08:52:43 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.west.internal (Postfix) with ESMTP id 848BC96C;
        Mon, 17 Aug 2020 08:52:41 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 17 Aug 2020 08:52:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=fVJ4PhELr1POP2qOa9FY1nLDgGLQSoP5u1WZrNPF3Po=; b=Um3/slVW
        7Cs91YntXxX3JvMWtW2YLJ8dWLk19JP+4bgyFJiqug0QedSYCiECFYCvqF1pcRHx
        hUwjbQscJ9J12FMxcOLHTnJI3uWpHzItMu4Sfwf8xmUshBp25K1Dx0diZ4+eDFDn
        t0JHAXrFyHaLhpZRwp7e4mCRBHZ3+uTipQD4l+zJosprLYnpwlCY5/RNsx/B2kbz
        RUfECHAXvrSoSkat0aibcf/HtEWgwZKM0BQPiNu4CnaywtBxfNOo+LZl3O9/Vi9/
        wU7vhXCe6S1dM64hcWKNZ59ow0S/PDLYaaeaLuM1eFi/RW9DefyMiX16Xn8f3ul6
        M75u7h/xyNUpBA==
X-ME-Sender: <xms:mX06X7advRPJayNcz5Dz2YJCscegxzEe6w0BLbD-K7o7eh_FvnmRrQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedruddtfedgheeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeejledrudekvddrieefrdegvden
    ucevlhhushhtvghrufhiiigvpedvnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughosh
    gthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:mX06X6bGK0N5kJ_EMeGVRVXR-AwoE0zXCuFOy983CVC0bTg4jtupKw>
    <xmx:mX06X98QhfqmWggdC5LNqzioKajBq2Xed8or5goWd5pedUMRs0Uw3g>
    <xmx:mX06Xxr1R2zzMELyPR2_690N3v_6J1WWz0Z_W-8zNT5cqppLiCnflg>
    <xmx:mX06X77OOT8JgYy0Gw2mi46SxRSnA3vQFTFS0Fw8JxpgAmlSJqDC_zYy0Wg>
Received: from localhost.localdomain (bzq-79-182-63-42.red.bezeqint.net [79.182.63.42])
        by mail.messagingengine.com (Postfix) with ESMTPA id 4839630600A6;
        Mon, 17 Aug 2020 08:52:28 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        amcohen@nvidia.com, danieller@nvidia.com, mlxsw@nvidia.com,
        roopa@nvidia.com, dsahern@gmail.com, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com, saeedm@nvidia.com,
        tariqt@nvidia.com, ayal@nvidia.com, eranbe@nvidia.com,
        mkubecek@suse.cz, Ido Schimmel <idosch@nvidia.com>
Subject: [RFC PATCH net-next 3/6] selftests: netdevsim: Add devlink metric tests
Date:   Mon, 17 Aug 2020 15:50:56 +0300
Message-Id: <20200817125059.193242-4-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200817125059.193242-1-idosch@idosch.org>
References: <20200817125059.193242-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Test the existing functionality of the devlink metric infrastructure.
Tests will be added for any new functionality.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../networking/devlink/devlink-metric.rst     | 11 +++++
 .../drivers/net/netdevsim/devlink.sh          | 49 ++++++++++++++++++-
 2 files changed, 59 insertions(+), 1 deletion(-)

diff --git a/Documentation/networking/devlink/devlink-metric.rst b/Documentation/networking/devlink/devlink-metric.rst
index cf5c5b4e4077..8a4515df1bc0 100644
--- a/Documentation/networking/devlink/devlink-metric.rst
+++ b/Documentation/networking/devlink/devlink-metric.rst
@@ -24,3 +24,14 @@ driver-specific ``devlink`` documentation under
 
 When possible, a selftest (under ``tools/testing/selftests/drivers/``) should
 also be provided to ensure the metrics are updated under the right conditions.
+
+Testing
+=======
+
+See ``tools/testing/selftests/drivers/net/netdevsim/devlink.sh`` for a
+test covering the core infrastructure. Test cases should be added for any new
+functionality.
+
+Device drivers should focus their tests on device-specific functionality, such
+as making sure the exposed metrics are correctly incremented and read from the
+device.
diff --git a/tools/testing/selftests/drivers/net/netdevsim/devlink.sh b/tools/testing/selftests/drivers/net/netdevsim/devlink.sh
index de4b32fc4223..4ca345e227bc 100755
--- a/tools/testing/selftests/drivers/net/netdevsim/devlink.sh
+++ b/tools/testing/selftests/drivers/net/netdevsim/devlink.sh
@@ -5,7 +5,8 @@ lib_dir=$(dirname $0)/../../../net/forwarding
 
 ALL_TESTS="fw_flash_test params_test regions_test reload_test \
 	   netns_reload_test resource_test dev_info_test \
-	   empty_reporter_test dummy_reporter_test"
+	   empty_reporter_test dummy_reporter_test \
+	   metric_counter_test"
 NUM_NETIFS=0
 source $lib_dir/lib.sh
 
@@ -486,6 +487,52 @@ dummy_reporter_test()
 	log_test "dummy reporter test"
 }
 
+metric_counter_value_get()
+{
+	local metric=$1; shift
+
+	cmd_jq "devlink -jps dev metric show $DL_HANDLE metric $metric" \
+		'.[][][]["value"]'
+}
+
+metric_group_get()
+{
+	local metric=$1; shift
+
+	cmd_jq "devlink -jp dev metric show $DL_HANDLE metric $metric" \
+		'.[][][]["group"]'
+}
+
+metric_counter_test()
+{
+	RET=0
+
+	local val_t0=$(metric_counter_value_get dummy_counter)
+	local val_t1=$(metric_counter_value_get dummy_counter)
+	(( val_t0 < val_t1 ))
+	check_err $? "Expected to read a higher value in second read"
+
+	echo "y" > $DEBUGFS_DIR/metric/fail_counter_get
+	metric_counter_value_get dummy_counter
+	check_fail $? "Unexpected success of counter get"
+	echo "n" > $DEBUGFS_DIR/metric/fail_counter_get
+
+	devlink dev metric set $DL_HANDLE metric dummy_counter group 10
+
+	(( 10 == $(metric_group_get dummy_counter) ))
+	check_err $? "Expected \"dummy_counter\" to be in group 10"
+
+	devlink dev metric show group 10 | grep -q "dummy_counter"
+	check_err $? "Expected \"dummy_counter\" to be dumped"
+
+	devlink dev metric show group 20 | grep -q "dummy_counter"
+	check_fail $? "Did not expect to see \"dummy_counter\" in group 20"
+
+	devlink dev metric set $DL_HANDLE metric dummy_counter group 0
+
+	log_test "metric counter test"
+}
+
 setup_prepare()
 {
 	modprobe netdevsim
-- 
2.26.2


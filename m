Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECFF139F708
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 14:44:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232739AbhFHMqs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 08:46:48 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:56025 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232714AbhFHMqn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Jun 2021 08:46:43 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id E93D55C0138;
        Tue,  8 Jun 2021 08:44:49 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Tue, 08 Jun 2021 08:44:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=u7BcEU+ZJDXTJRwWTPXVC+3NVjACyrB+SzIAVcwtKwQ=; b=odQR1Gun
        tiBbKKxNJgsu1o1ecrJbY9rtJ3oqS67OzYHyRWakyWNpacPKXob9MLxKq5TZKhWo
        Nai21GeUf8sbYxhNw264FBNmdfQdW4S/1u6kNz54GE4aPtLmNf8PsEcQPVjh7rur
        RZ5HA6DgLfC3Wu5CilRE+e1pb+VFZc9P+2rqMlKZ65xTyHFrWLxtLhcfy2aGkTzR
        sqef0NHTwAdAD0xIPtDUIn4584u9vAHyX+eH6I0WjiQ24Rpys8Mtdw5zMCNzO0yb
        JKO6GRE2MPsz9mS/WG/b96e1KlznNPVEvAMlBNyjFBLKjylD7DWY7Qrw4zNwk5st
        IXd9bQUxQtgeOw==
X-ME-Sender: <xms:QWa_YBNWD6EUQm1RZ1Uq3NsdFyYNhuDjs7VajHjTEQXr202-hutALQ>
    <xme:QWa_YD_UVnaM9ELuG1jjeRmH84z0VO0I0knIPpVZNIUG1zpv3ubTVOokvrkVJvVK2
    54geG0jzbC5Dow>
X-ME-Received: <xmr:QWa_YARRHanPyDrjNGXRkfJcskgOic6RFpMCyM60Mz91cG5gyLBOsCtpMCMxEzMIJglz9scsmmrbosYS85VMFvw7RuXzRcozTQFD3A2I8ri0CA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfedtledggedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepfeeghfehveehvefhteekueehfeeffe
    eitddvffeltdelgfefffdvjeduleefudefnecuffhomhgrihhnpehgihhthhhusgdrtgho
    mhenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:QWa_YNuC2MR9bqDSxYNOjsNp6sKewpJSfSGZ96PPi6NrJOJ3K5b63A>
    <xmx:QWa_YJc96B1MfAVLQPDYWurli50PtOVhnCMptKaMKr_zzO9TIur5Nw>
    <xmx:QWa_YJ1_Up2hoiHUYAMY2NRfrFCOTWg6KvUV1PNos9WHCwlppSTZAQ>
    <xmx:QWa_YDvsqXgpF4LPjsldJ5x9Rk0ZG76v0Q1PzZgYnuWQmbCziOtLMg>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 8 Jun 2021 08:44:47 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        petrm@nvidia.com, amcohen@nvidia.com, vadimp@nvidia.com,
        c_mykolak@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 4/8] selftests: devlink_lib: Fix bouncing of netdevsim DEVLINK_DEV
Date:   Tue,  8 Jun 2021 15:44:10 +0300
Message-Id: <20210608124414.1664294-5-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210608124414.1664294-1-idosch@idosch.org>
References: <20210608124414.1664294-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Machata <petrm@nvidia.com>

In the commit referenced below, a check was added to devlink_lib that
asserts the existence of a devlink device referenced by $DEVLINK_DEV.
Unfortunately, several netdevsim tests point DEVLINK_DEV at a device that
does not exist at the time that devlink_lib is sourced. Thus these tests
spuriously fail.

Fix this by introducing an override. By setting DEVLINK_DEV to an empty
string, the user declares their intention to handle DEVLINK_DEV management
on their own.

In all netdevsim tests that use devlink_lib and set DEVLINK_DEV, set
instead an empty DEVLINK_DEV just before sourcing devlink_lib, and set it
to the correct value right afterwards.

Fixes: 557c4d2f780c ("selftests: devlink_lib: add check for devlink device existence")
Signed-off-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../testing/selftests/drivers/net/netdevsim/devlink_trap.sh | 4 +++-
 tools/testing/selftests/drivers/net/netdevsim/fib.sh        | 6 ++++--
 tools/testing/selftests/drivers/net/netdevsim/nexthop.sh    | 4 +++-
 tools/testing/selftests/drivers/net/netdevsim/psample.sh    | 4 +++-
 tools/testing/selftests/net/forwarding/devlink_lib.sh       | 2 +-
 5 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/drivers/net/netdevsim/devlink_trap.sh b/tools/testing/selftests/drivers/net/netdevsim/devlink_trap.sh
index da49ad2761b5..6165901a1cf3 100755
--- a/tools/testing/selftests/drivers/net/netdevsim/devlink_trap.sh
+++ b/tools/testing/selftests/drivers/net/netdevsim/devlink_trap.sh
@@ -24,13 +24,15 @@ ALL_TESTS="
 NETDEVSIM_PATH=/sys/bus/netdevsim/
 DEV_ADDR=1337
 DEV=netdevsim${DEV_ADDR}
-DEVLINK_DEV=netdevsim/${DEV}
 DEBUGFS_DIR=/sys/kernel/debug/netdevsim/$DEV/
 SLEEP_TIME=1
 NETDEV=""
 NUM_NETIFS=0
 source $lib_dir/lib.sh
+
+DEVLINK_DEV=
 source $lib_dir/devlink_lib.sh
+DEVLINK_DEV=netdevsim/${DEV}
 
 require_command udevadm
 
diff --git a/tools/testing/selftests/drivers/net/netdevsim/fib.sh b/tools/testing/selftests/drivers/net/netdevsim/fib.sh
index 251f228ce63e..fc794cd30389 100755
--- a/tools/testing/selftests/drivers/net/netdevsim/fib.sh
+++ b/tools/testing/selftests/drivers/net/netdevsim/fib.sh
@@ -33,13 +33,15 @@ ALL_TESTS="
 NETDEVSIM_PATH=/sys/bus/netdevsim/
 DEV_ADDR=1337
 DEV=netdevsim${DEV_ADDR}
-DEVLINK_DEV=netdevsim/${DEV}
 SYSFS_NET_DIR=/sys/bus/netdevsim/devices/$DEV/net/
 NUM_NETIFS=0
 source $lib_dir/lib.sh
-source $lib_dir/devlink_lib.sh
 source $lib_dir/fib_offload_lib.sh
 
+DEVLINK_DEV=
+source $lib_dir/devlink_lib.sh
+DEVLINK_DEV=netdevsim/${DEV}
+
 ipv4_identical_routes()
 {
 	fib_ipv4_identical_routes_test "testns1"
diff --git a/tools/testing/selftests/drivers/net/netdevsim/nexthop.sh b/tools/testing/selftests/drivers/net/netdevsim/nexthop.sh
index ba75c81cda91..e8e0dc088d6a 100755
--- a/tools/testing/selftests/drivers/net/netdevsim/nexthop.sh
+++ b/tools/testing/selftests/drivers/net/netdevsim/nexthop.sh
@@ -44,12 +44,14 @@ ALL_TESTS="
 NETDEVSIM_PATH=/sys/bus/netdevsim/
 DEV_ADDR=1337
 DEV=netdevsim${DEV_ADDR}
-DEVLINK_DEV=netdevsim/${DEV}
 SYSFS_NET_DIR=/sys/bus/netdevsim/devices/$DEV/net/
 DEBUGFS_NET_DIR=/sys/kernel/debug/netdevsim/$DEV/
 NUM_NETIFS=0
 source $lib_dir/lib.sh
+
+DEVLINK_DEV=
 source $lib_dir/devlink_lib.sh
+DEVLINK_DEV=netdevsim/${DEV}
 
 nexthop_check()
 {
diff --git a/tools/testing/selftests/drivers/net/netdevsim/psample.sh b/tools/testing/selftests/drivers/net/netdevsim/psample.sh
index ee10b1a8933c..e689ff7a0b12 100755
--- a/tools/testing/selftests/drivers/net/netdevsim/psample.sh
+++ b/tools/testing/selftests/drivers/net/netdevsim/psample.sh
@@ -14,13 +14,15 @@ ALL_TESTS="
 NETDEVSIM_PATH=/sys/bus/netdevsim/
 DEV_ADDR=1337
 DEV=netdevsim${DEV_ADDR}
-DEVLINK_DEV=netdevsim/${DEV}
 SYSFS_NET_DIR=/sys/bus/netdevsim/devices/$DEV/net/
 PSAMPLE_DIR=/sys/kernel/debug/netdevsim/$DEV/psample/
 CAPTURE_FILE=$(mktemp)
 NUM_NETIFS=0
 source $lib_dir/lib.sh
+
+DEVLINK_DEV=
 source $lib_dir/devlink_lib.sh
+DEVLINK_DEV=netdevsim/${DEV}
 
 # Available at https://github.com/Mellanox/libpsample
 require_command psample
diff --git a/tools/testing/selftests/net/forwarding/devlink_lib.sh b/tools/testing/selftests/net/forwarding/devlink_lib.sh
index c19e001f138b..39fb9b8e7b58 100644
--- a/tools/testing/selftests/net/forwarding/devlink_lib.sh
+++ b/tools/testing/selftests/net/forwarding/devlink_lib.sh
@@ -18,7 +18,7 @@ if [[ ! -v DEVLINK_DEV ]]; then
 
 	DEVLINK_VIDDID=$(lspci -s $(echo $DEVLINK_DEV | cut -d"/" -f2) \
 			 -n | cut -d" " -f3)
-else
+elif [[ ! -z "$DEVLINK_DEV" ]]; then
 	devlink dev show $DEVLINK_DEV &> /dev/null
 	if [ $? -ne 0 ]; then
 		echo "SKIP: devlink device \"$DEVLINK_DEV\" not found"
-- 
2.31.1


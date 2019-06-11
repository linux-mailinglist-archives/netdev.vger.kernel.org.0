Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 624B33D140
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 17:46:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405355AbfFKPp7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jun 2019 11:45:59 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:55787 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2405210AbfFKPp6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jun 2019 11:45:58 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 191B822212;
        Tue, 11 Jun 2019 11:45:57 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Tue, 11 Jun 2019 11:45:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=eYrllg7NxzVfSxD6b75E8bAsxwDabdxTmg6ltcio6qM=; b=Jx0yGJhb
        JSHNSPKR1M35xKuCU6CXs88a9YBAhSRmRpDENx/N3sm2TNjt3Vjgb5qJ9yWXynfV
        C3bZ21esrrF9zxIxY2PxTrqzXbHD57Exz6OODHez0yOeH/SmrvHhFSITfaRVBSA7
        re+3Yige67eDBUD770yvOKeLIi35xIcXOZS//fDznSepVc0hZt2q8gNIhVwZTVf4
        kkblSPCYhSk3sEmVKa2KFl1bpmEyMJ2I4fiWHrE027lhsBhfGGR2VKJ5nqGZt1oo
        pWudA6oDPtGaArWN47lpTbV1o4W6fERjxyrx1HhsppTgAc88fHx0MiEUPKV5tAzH
        /n8k1dSSK+AQvw==
X-ME-Sender: <xms:tMz_XFMaKtMROsXFVz6BBDsAbkDbIj92NpJbHb0I51fvjdimUCR1qw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddrudehhedgjeeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuffhomhgrihhnpehphhgtrdhshhenucfkphepudelfedrgeejrd
    duieehrddvhedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhs
    tghhrdhorhhgnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:tMz_XMO8PJxqy7rX-t0Arp6RopPZDlOy10X6C_C7EHFMi1YW66GYMA>
    <xmx:tMz_XPR94vZyen4P8wltU-I6kB_PxH1aSDDL6Px2Q8VXNmLKq4WoiQ>
    <xmx:tMz_XGDih187L8ZsieWgwtGh8gSc-Zwhe8nHlrN-uTGGO0zcbAokhw>
    <xmx:tcz_XHexBvUjwU0-jZ0kb5196RuAiIf_8-6QF6PDhidLenLJ1Gn2AA>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id E24CD380085;
        Tue, 11 Jun 2019 11:45:54 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, shalomt@mellanox.com,
        petrm@mellanox.com, richardcochran@gmail.com, olteanv@gmail.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next v2 9/9] selftests: ptp: Add Physical Hardware Clock test
Date:   Tue, 11 Jun 2019 18:45:12 +0300
Message-Id: <20190611154512.17650-10-idosch@idosch.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190611154512.17650-1-idosch@idosch.org>
References: <20190611154512.17650-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shalom Toledo <shalomt@mellanox.com>

Test the PTP Physical Hardware Clock functionality using the "phc_ctl" (a
part of "linuxptp").

The test contains three sub-tests:
  * "settime" test
  * "adjtime" test
  * "adjfreq" test

"settime" test:
  * set the PHC time to 0 seconds.
  * wait for 120.5 seconds.
  * check if PHC time equal to 120.XX seconds.

"adjtime" test:
  * set the PHC time to 0 seconds.
  * adjust the time by 10 seconds.
  * check if PHC time equal to 10.XX seconds.

"adjfreq" test:
  * adjust the PHC frequency to be 1% faster.
  * set the PHC time to 0 seconds.
  * wait for 100.5 seconds.
  * check if PHC time equal to 101.XX seconds.

Usage:
  $ ./phc.sh /dev/ptp<X>

  It is possible to run a subset of the tests, for example:
    * To run only the "settime" test:
      $ TESTS="settime" ./phc.sh /dev/ptp<X>

Signed-off-by: Shalom Toledo <shalomt@mellanox.com>
Reviewed-by: Petr Machata <petrm@mellanox.com>
Acked-by: Richard Cochran <richardcochran@gmail.com>
Tested-by: Vladimir Oltean <olteanv@gmail.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 tools/testing/selftests/ptp/phc.sh | 166 +++++++++++++++++++++++++++++
 1 file changed, 166 insertions(+)
 create mode 100755 tools/testing/selftests/ptp/phc.sh

diff --git a/tools/testing/selftests/ptp/phc.sh b/tools/testing/selftests/ptp/phc.sh
new file mode 100755
index 000000000000..ac6e5a6e1d3a
--- /dev/null
+++ b/tools/testing/selftests/ptp/phc.sh
@@ -0,0 +1,166 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+
+ALL_TESTS="
+	settime
+	adjtime
+	adjfreq
+"
+DEV=$1
+
+##############################################################################
+# Sanity checks
+
+if [[ "$(id -u)" -ne 0 ]]; then
+	echo "SKIP: need root privileges"
+	exit 0
+fi
+
+if [[ "$DEV" == "" ]]; then
+	echo "SKIP: PTP device not provided"
+	exit 0
+fi
+
+require_command()
+{
+	local cmd=$1; shift
+
+	if [[ ! -x "$(command -v "$cmd")" ]]; then
+		echo "SKIP: $cmd not installed"
+		exit 1
+	fi
+}
+
+phc_sanity()
+{
+	phc_ctl $DEV get &> /dev/null
+
+	if [ $? != 0 ]; then
+		echo "SKIP: unknown clock $DEV: No such device"
+		exit 1
+	fi
+}
+
+require_command phc_ctl
+phc_sanity
+
+##############################################################################
+# Helpers
+
+# Exit status to return at the end. Set in case one of the tests fails.
+EXIT_STATUS=0
+# Per-test return value. Clear at the beginning of each test.
+RET=0
+
+check_err()
+{
+	local err=$1
+
+	if [[ $RET -eq 0 && $err -ne 0 ]]; then
+		RET=$err
+	fi
+}
+
+log_test()
+{
+	local test_name=$1
+
+	if [[ $RET -ne 0 ]]; then
+		EXIT_STATUS=1
+		printf "TEST: %-60s  [FAIL]\n" "$test_name"
+		return 1
+	fi
+
+	printf "TEST: %-60s  [ OK ]\n" "$test_name"
+	return 0
+}
+
+tests_run()
+{
+	local current_test
+
+	for current_test in ${TESTS:-$ALL_TESTS}; do
+		$current_test
+	done
+}
+
+##############################################################################
+# Tests
+
+settime_do()
+{
+	local res
+
+	res=$(phc_ctl $DEV set 0 wait 120.5 get 2> /dev/null \
+		| awk '/clock time is/{print $5}' \
+		| awk -F. '{print $1}')
+
+	(( res == 120 ))
+}
+
+adjtime_do()
+{
+	local res
+
+	res=$(phc_ctl $DEV set 0 adj 10 get 2> /dev/null \
+		| awk '/clock time is/{print $5}' \
+		| awk -F. '{print $1}')
+
+	(( res == 10 ))
+}
+
+adjfreq_do()
+{
+	local res
+
+	# Set the clock to be 1% faster
+	res=$(phc_ctl $DEV freq 10000000 set 0 wait 100.5 get 2> /dev/null \
+		| awk '/clock time is/{print $5}' \
+		| awk -F. '{print $1}')
+
+	(( res == 101 ))
+}
+
+##############################################################################
+
+cleanup()
+{
+	phc_ctl $DEV freq 0.0 &> /dev/null
+	phc_ctl $DEV set &> /dev/null
+}
+
+settime()
+{
+	RET=0
+
+	settime_do
+	check_err $?
+	log_test "settime"
+	cleanup
+}
+
+adjtime()
+{
+	RET=0
+
+	adjtime_do
+	check_err $?
+	log_test "adjtime"
+	cleanup
+}
+
+adjfreq()
+{
+	RET=0
+
+	adjfreq_do
+	check_err $?
+	log_test "adjfreq"
+	cleanup
+}
+
+trap cleanup EXIT
+
+tests_run
+
+exit $EXIT_STATUS
-- 
2.20.1


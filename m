Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BDCFB32F4E
	for <lists+netdev@lfdr.de>; Mon,  3 Jun 2019 14:14:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727591AbfFCMOE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 08:14:04 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:35935 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727536AbfFCMOB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jun 2019 08:14:01 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 005A72227B;
        Mon,  3 Jun 2019 08:14:01 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Mon, 03 Jun 2019 08:14:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=7kN4pI0euK4vkJhCV/crq5mfh6CDNsgOg7/EMN6miQI=; b=j18A1JWY
        Nb3ts3xYS44y+1kKIev4H+o/ih36CnYb/Hn1SRYHGJIrMsKW/v2HWMCb00u0gsIP
        w8frsKxA7d1axzJP43OwwdPZatF23CtWXRT0Jtr00c/K3KRqy7rckyuEtAygDNt7
        94Q0XgaRi4UsBeFBDD1r89sUbS16PeztA26KTGsxJObstF0xSogfUnigeu6N6M/C
        N/ElDcnY9dAZede3Sw7OPAA1f9BTYIg9+asx7L0AH3i+Cbx9Nkm8HeAMjIlFSa10
        GX2Kt85TfIgSXtSARQ9wB43ziTCgH3CA9c7T5xDhrSoS+e3ZzQK9J0y0K2Pj0jbq
        LS817twFvsWUpw==
X-ME-Sender: <xms:CA_1XKd4ndWj0g8KdJHxWYeYKxnQBNvP0y2OEJZkY9ZXqkk95V3lkA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddrudefjedggeeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuffhomhgrihhnpehphhgtrdhshhenucfkphepudelfedrgeejrd
    duieehrddvhedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhs
    tghhrdhorhhgnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:CA_1XKPgaFMgS1m-QjAEehd0UvdQRE6T9eoIcKHqJnM8GcTslymEtw>
    <xmx:CA_1XGWAfsFytkvwUbjIeNFjVbuKc-7Do1RdXXOFuhvmdvRBKphrCQ>
    <xmx:CA_1XKx5xb87qB5pkml_kX9qsKTAOR6xZYbJ1lEBWWyE3yk9xHRtYQ>
    <xmx:CA_1XMzh7xf-i2j45xD54UcSPyD6SR_1NXCporvIQaC3bDSGaU74lg>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 52255380089;
        Mon,  3 Jun 2019 08:13:59 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, richardcochran@gmail.com, jiri@mellanox.com,
        shalomt@mellanox.com, petrm@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 9/9] selftests: ptp: Add Physical Hardware Clock test
Date:   Mon,  3 Jun 2019 15:12:44 +0300
Message-Id: <20190603121244.3398-10-idosch@idosch.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190603121244.3398-1-idosch@idosch.org>
References: <20190603121244.3398-1-idosch@idosch.org>
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


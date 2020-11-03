Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25C052A4CAA
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 18:24:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728750AbgKCRYZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 12:24:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728742AbgKCRYX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 12:24:23 -0500
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 406E6C061A04
        for <netdev@vger.kernel.org>; Tue,  3 Nov 2020 09:24:23 -0800 (PST)
Received: by mail-wr1-x42c.google.com with SMTP id 33so8572277wrl.7
        for <netdev@vger.kernel.org>; Tue, 03 Nov 2020 09:24:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=eFw7qsj6z01pcgLzMm8dHLRPOHpj/X67em/halFVu3o=;
        b=mSA+X10FOUtdTGgVaa8szAyvp7xLUiw5xJzr/sxWIGAgUIFKLzjAPoBb0crIjNqKS7
         /cQeiw1EIWeX+FO/UOOS6nV318jIDXCdf3tWw2b3GzX2IL/sjdo9YdzEbfOsMYO3Zaan
         X81dEcprvdVUQHeGdEQCxubMYYam/pFIY/3YCOYVYIgOZ6/38bRrSslBWbvvrHJLzdKp
         /Q0IA5uyiNC8cKEWYELvM21d6Qt6Ej6O/1aAUbmzHHCh1jU0XH0JDTIUOqx/htH5OTDP
         rD+VUD0Y0fCR8JQ8DLXyJgRepqrkS6chRK4oaSrI3A1PVt/8n9anXUHNwgUTGQbrATpT
         0k4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=eFw7qsj6z01pcgLzMm8dHLRPOHpj/X67em/halFVu3o=;
        b=nhzShSBpr55PXRArA2myZxZcVZnXTVlCnND3cm/9CX3JG/Ovn7F8rP+xGkqjEZz/IW
         aMGx3oEvu1qo+DdxsD1pMKv+jDmPdkKFin+1xzjqejZicuUmbJvGj/wilrKkCS6wdcXA
         YBF8aNF+3wgWofvmoPEzEQ3xqF/nn+epZToCJRxcrrBJjGtlOUzpeuYDQ4mmaT13nsu3
         fpUkq5WpW+KM50DximtPpcrO2JjnYUU3kOHYvLs5+/A5FH+7GzH1R8IlgmJotl6+MC4K
         jAwovb1GI5cvU7Ci0x6riKLvkTZ71j5Kxw1MfdFoq8Z+S8dR/3rD8sXAmXjK6H36xB/F
         xeTg==
X-Gm-Message-State: AOAM532rHH0pQDjm8wchJVC+JrPXNb65YyawylFF+wRJ4icvPh7RxQr3
        ebPYZ+eJRs0LpTLcgwF38B0DJJHHf3lhiqe5
X-Google-Smtp-Source: ABdhPJwD1UyhsS3G8BvW6xOfH7zUhBVgT+g24QU1NWMIxSbG8uUXSV7HTKtWK4yY2FNWkPJp5n9YtA==
X-Received: by 2002:adf:f64f:: with SMTP id x15mr18237203wrp.228.1604424261625;
        Tue, 03 Nov 2020 09:24:21 -0800 (PST)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id a128sm2650795wmf.5.2020.11.03.09.24.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2020 09:24:20 -0800 (PST)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, kuba@kernel.org,
        bridge@lists.linux-foundation.org,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH net-next 04/16] selftests: net: bridge: add initial MLDv2 include test
Date:   Tue,  3 Nov 2020 19:24:00 +0200
Message-Id: <20201103172412.1044840-5-razor@blackwall.org>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20201103172412.1044840-1-razor@blackwall.org>
References: <20201103172412.1044840-1-razor@blackwall.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

Add the initial setup for MLDv2 tests with the first test of a simple
is_include report. For MLDv2 we need to setup the bridge properly and we
also send the full precooked packets instead of relying on mausezahn to
fill in some parts. For verification we use the generic S,G state checking
functions from lib.sh.

Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
---
 .../selftests/net/forwarding/bridge_mld.sh    | 146 ++++++++++++++++++
 1 file changed, 146 insertions(+)
 create mode 100755 tools/testing/selftests/net/forwarding/bridge_mld.sh

diff --git a/tools/testing/selftests/net/forwarding/bridge_mld.sh b/tools/testing/selftests/net/forwarding/bridge_mld.sh
new file mode 100755
index 000000000000..3d0d579e4e03
--- /dev/null
+++ b/tools/testing/selftests/net/forwarding/bridge_mld.sh
@@ -0,0 +1,146 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+
+ALL_TESTS="mldv2include_test"
+NUM_NETIFS=4
+CHECK_TC="yes"
+TEST_GROUP="ff02::cc"
+TEST_GROUP_MAC="33:33:00:00:00:cc"
+
+# MLDv2 is_in report: grp ff02::cc is_include 2001:db8:1::1,2001:db8:1::2,2001:db8:1::3
+MZPKT_IS_INC="33:33:00:00:00:01:fe:54:00:04:5e:ba:86:dd:60:0a:2d:ae:00:54:00:01:fe:80:00:\
+00:00:00:00:00:fc:54:00:ff:fe:04:5e:ba:ff:02:00:00:00:00:00:00:00:00:00:00:00:00:00:01:3a:\
+00:05:02:00:00:00:00:8f:00:8e:d9:00:00:00:01:01:00:00:03:ff:02:00:00:00:00:00:00:00:00:00:\
+00:00:00:00:cc:20:01:0d:b8:00:01:00:00:00:00:00:00:00:00:00:01:20:01:0d:b8:00:01:00:00:00:\
+00:00:00:00:00:00:02:20:01:0d:b8:00:01:00:00:00:00:00:00:00:00:00:03"
+
+source lib.sh
+
+h1_create()
+{
+	simple_if_init $h1 2001:db8:1::1/64
+}
+
+h1_destroy()
+{
+	simple_if_fini $h1 2001:db8:1::1/64
+}
+
+h2_create()
+{
+	simple_if_init $h2 2001:db8:1::2/64
+}
+
+h2_destroy()
+{
+	simple_if_fini $h2 2001:db8:1::2/64
+}
+
+switch_create()
+{
+	ip link add dev br0 type bridge mcast_snooping 1 mcast_query_response_interval 100 \
+					mcast_mld_version 2 mcast_startup_query_interval 300 \
+					mcast_querier 1
+
+	ip link set dev $swp1 master br0
+	ip link set dev $swp2 master br0
+
+	ip link set dev br0 up
+	ip link set dev $swp1 up
+	ip link set dev $swp2 up
+
+	# make sure a query has been generated
+	sleep 5
+}
+
+switch_destroy()
+{
+	ip link set dev $swp2 down
+	ip link set dev $swp1 down
+
+	ip link del dev br0
+}
+
+setup_prepare()
+{
+	h1=${NETIFS[p1]}
+	swp1=${NETIFS[p2]}
+
+	swp2=${NETIFS[p3]}
+	h2=${NETIFS[p4]}
+
+	vrf_prepare
+
+	h1_create
+	h2_create
+
+	switch_create
+}
+
+cleanup()
+{
+	pre_cleanup
+
+	switch_destroy
+
+	h2_destroy
+	h1_destroy
+
+	vrf_cleanup
+}
+
+mldv2include_prepare()
+{
+	local host1_if=$1
+	local X=("2001:db8:1::1" "2001:db8:1::2" "2001:db8:1::3")
+
+	ip link set dev br0 type bridge mcast_mld_version 2
+	check_err $? "Could not change bridge MLD version to 2"
+
+	$MZ $host1_if $MZPKT_IS_INC -q
+	sleep 1
+	bridge -j -d -s mdb show dev br0 \
+		| jq -e ".[].mdb[] | \
+			 select(.grp == \"$TEST_GROUP\" and .source_list != null)" &>/dev/null
+	check_err $? "Missing *,G entry with source list"
+	bridge -j -d -s mdb show dev br0 \
+		| jq -e ".[].mdb[] | \
+			 select(.grp == \"$TEST_GROUP\" and \
+				.source_list != null and .filter_mode == \"include\")" &>/dev/null
+	check_err $? "Wrong *,G entry filter mode"
+	brmcast_check_sg_entries "is_include" "${X[@]}"
+}
+
+mldv2cleanup()
+{
+	local port=$1
+
+	bridge mdb del dev br0 port $port grp $TEST_GROUP
+	ip link set dev br0 type bridge mcast_mld_version 1
+}
+
+mldv2include_test()
+{
+	RET=0
+	local X=("2001:db8:1::1" "2001:db8:1::2" "2001:db8:1::3")
+
+	mldv2include_prepare $h1
+
+	brmcast_check_sg_state 0 "${X[@]}"
+
+	brmcast_check_sg_fwding 1 "${X[@]}"
+	brmcast_check_sg_fwding 0 "2001:db8:1::100"
+
+	log_test "MLDv2 report $TEST_GROUP is_include"
+
+	mldv2cleanup $swp1
+}
+
+trap cleanup EXIT
+
+setup_prepare
+setup_wait
+
+tests_run
+
+exit $EXIT_STATUS
-- 
2.25.4


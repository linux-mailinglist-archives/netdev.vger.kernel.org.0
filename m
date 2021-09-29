Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70CBB41BE93
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 07:13:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244199AbhI2FPQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 01:15:16 -0400
Received: from smtp-relay-internal-1.canonical.com ([185.125.188.123]:59204
        "EHLO smtp-relay-internal-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S244185AbhI2FPN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 01:15:13 -0400
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com [209.85.214.197])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 619374025C
        for <netdev@vger.kernel.org>; Wed, 29 Sep 2021 05:13:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1632892408;
        bh=uiO1edA6wx8hksyUnwHTbB7wnkLlIj9BZJS/WV8b6fI=;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version;
        b=RABvHsqRQFkr4wV+uoaF3fZuXLKLATjyZ6J6DHNhMUl9WAstBw/WGwa3bNxepSPag
         A9UaBNO/kQoAImjJspcMEav67mlCkeEtpxJnEWQVsQFabO0BXcAfjWTCs3B0/MLYZT
         y1QAchoXu4imygCfo8VvCAxHkubxVLLS/rIPoTXET+SwggV/syE+/Gvegz2ircb40L
         YBXflQx0UOYzpP294XZxLoDWV8i4KuujMQeG7FDDEn1I3bnmCUwcNG+X5l+ivZkN7W
         i481b0ynt/XlqSJ0XDh9hkAU59ZMljCKgMy2P1hnLJamLqANCQbpvwrkHhfVRlq375
         Mjvv93B328CDw==
Received: by mail-pl1-f197.google.com with SMTP id u18-20020a170902e81200b0013e2de8b171so612758plg.8
        for <netdev@vger.kernel.org>; Tue, 28 Sep 2021 22:13:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=uiO1edA6wx8hksyUnwHTbB7wnkLlIj9BZJS/WV8b6fI=;
        b=O8ZTKIl2vVsTE+dR+zOapWgI1rQdY0pqnvdycgE/9dRsckxkuRAtD80j8y677M+hCu
         a2sM2L0zQmIISfGxPEpuB8QRgS9oPxaQpWLkmEDznSJDD4O1qtCPzyzMmAo+/2rRrxhk
         wsM0u1C6WyuqE5k5Tq3/syYLHsPYViTSbLXnTIluuBQ/WwGuHtdnvGuvP8LonDgb6gX7
         CejcMEhRRQHQT4+h/hyUxESwgAiJNdGwy0Zex8DppZvaewsU4tHFj8A/o7ACvfy2ZlRY
         vvluDGuRopdyQHH0YId4TKRdg34gsY1fP3Ssz9oNCpU0cHiXBLHL4F6Okos0zI4P/tF+
         lDmw==
X-Gm-Message-State: AOAM530YiXRzD+/xpizog6p/Xlf7mWub+QTvtfq4NhsGz8XPkKOQKvgV
        koBparUMqViEEHMZ+7xBYID0rOtM41hqVcG9+AYbUsTn+3iIVHujxyaZMpy4HycWyHFfT9fnMg8
        2uRaHXJO+OPzRv8wjCKcdAOIvNEszLL1O
X-Received: by 2002:a05:6a00:248c:b0:447:52ee:f646 with SMTP id c12-20020a056a00248c00b0044752eef646mr1487079pfv.75.1632892406675;
        Tue, 28 Sep 2021 22:13:26 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyoERvB0FEPO+GQQqd/pNIdGtohxZEq2bV1nhFJajyfgmrtVa6uBxvnDuxkvC1lPRNtGf2F4A==
X-Received: by 2002:a05:6a00:248c:b0:447:52ee:f646 with SMTP id c12-20020a056a00248c00b0044752eef646mr1487058pfv.75.1632892406351;
        Tue, 28 Sep 2021 22:13:26 -0700 (PDT)
Received: from localhost.localdomain (223-136-83-121.emome-ip.hinet.net. [223.136.83.121])
        by smtp.gmail.com with ESMTPSA id a10sm769975pfn.48.2021.09.28.22.13.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Sep 2021 22:13:25 -0700 (PDT)
From:   Po-Hsu Lin <po-hsu.lin@canonical.com>
To:     linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     po-hsu.lin@canonical.com, ast@kernel.org, daniel@iogearbox.net,
        davem@davemloft.net, kuba@kernel.org, hawk@kernel.org,
        john.fastabend@gmail.com, skhan@linuxfoundation.org,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        kpsingh@kernel.org, jakub@cloudflare.com
Subject: [PATCHv2] selftests/bpf: Use kselftest skip code for skipped tests
Date:   Wed, 29 Sep 2021 13:12:50 +0800
Message-Id: <20210929051250.13831-1-po-hsu.lin@canonical.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are several test cases in the bpf directory are still using
exit 0 when they need to be skipped. Use kselftest framework skip
code instead so it can help us to distinguish the return status.

Criterion to filter out what should be fixed in bpf directory:
  grep -r "exit 0" -B1 | grep -i skip

This change might cause some false-positives if people are running
these test scripts directly and only checking their return codes,
which will change from 0 to 4. However I think the impact should be
small as most of our scripts here are already using this skip code.
And there will be no such issue if running them with the kselftest
framework.

v1 -> v2:
  - Ignore bpf/test_bpftool_build.sh as similar changes has been made.
  - Make KSFT_SKIP readonly as suggested by Jakub Sitnicki.

Signed-off-by: Po-Hsu Lin <po-hsu.lin@canonical.com>
---
 tools/testing/selftests/bpf/test_xdp_meta.sh | 5 ++++-
 tools/testing/selftests/bpf/test_xdp_vlan.sh | 7 +++++--
 2 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/bpf/test_xdp_meta.sh b/tools/testing/selftests/bpf/test_xdp_meta.sh
index 637fcf4..d10cefd 100755
--- a/tools/testing/selftests/bpf/test_xdp_meta.sh
+++ b/tools/testing/selftests/bpf/test_xdp_meta.sh
@@ -1,5 +1,8 @@
 #!/bin/sh
 
+# Kselftest framework requirement - SKIP code is 4.
+readonly KSFT_SKIP=4
+
 cleanup()
 {
 	if [ "$?" = "0" ]; then
@@ -17,7 +20,7 @@ cleanup()
 ip link set dev lo xdp off 2>/dev/null > /dev/null
 if [ $? -ne 0 ];then
 	echo "selftests: [SKIP] Could not run test without the ip xdp support"
-	exit 0
+	exit $KSFT_SKIP
 fi
 set -e
 
diff --git a/tools/testing/selftests/bpf/test_xdp_vlan.sh b/tools/testing/selftests/bpf/test_xdp_vlan.sh
index bb8b0da..0cbc760 100755
--- a/tools/testing/selftests/bpf/test_xdp_vlan.sh
+++ b/tools/testing/selftests/bpf/test_xdp_vlan.sh
@@ -2,6 +2,9 @@
 # SPDX-License-Identifier: GPL-2.0
 # Author: Jesper Dangaard Brouer <hawk@kernel.org>
 
+# Kselftest framework requirement - SKIP code is 4.
+readonly KSFT_SKIP=4
+
 # Allow wrapper scripts to name test
 if [ -z "$TESTNAME" ]; then
     TESTNAME=xdp_vlan
@@ -94,7 +97,7 @@ while true; do
 	    -h | --help )
 		usage;
 		echo "selftests: $TESTNAME [SKIP] usage help info requested"
-		exit 0
+		exit $KSFT_SKIP
 		;;
 	    * )
 		shift
@@ -117,7 +120,7 @@ fi
 ip link set dev lo xdpgeneric off 2>/dev/null > /dev/null
 if [ $? -ne 0 ]; then
 	echo "selftests: $TESTNAME [SKIP] need ip xdp support"
-	exit 0
+	exit $KSFT_SKIP
 fi
 
 # Interactive mode likely require us to cleanup netns
-- 
2.7.4


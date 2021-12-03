Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD5DA467012
	for <lists+netdev@lfdr.de>; Fri,  3 Dec 2021 03:37:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378119AbhLCClU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 21:41:20 -0500
Received: from mga18.intel.com ([134.134.136.126]:2291 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1378086AbhLCClT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 Dec 2021 21:41:19 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10186"; a="223769801"
X-IronPort-AV: E=Sophos;i="5.87,283,1631602800"; 
   d="scan'208";a="223769801"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2021 18:37:54 -0800
X-IronPort-AV: E=Sophos;i="5.87,283,1631602800"; 
   d="scan'208";a="501010487"
Received: from liweilv-mobl.ccr.corp.intel.com (HELO lkp-bingo.fnst-test.com) ([10.255.30.243])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2021 18:37:51 -0800
From:   Li Zhijian <zhijianx.li@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, shuah@kernel.org
Cc:     netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org, Li Zhijian <zhijianx.li@intel.com>,
        Philip Li <philip.li@intel.com>,
        kernel test robot <lkp@intel.com>
Subject: [PATCH] selftests: net/fcnal-test.sh: add exit code
Date:   Fri,  3 Dec 2021 10:32:13 +0800
Message-Id: <20211203023213.5021-1-zhijianx.li@intel.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Previously, the selftest framework always treats it as *ok* even though
some of them are failed actually. That's because the script always
returns 0.

It supports PASS/FAIL/SKIP exit code now.

CC: Philip Li <philip.li@intel.com>
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Li Zhijian <zhijianx.li@intel.com>
---
 tools/testing/selftests/net/fcnal-test.sh | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/tools/testing/selftests/net/fcnal-test.sh b/tools/testing/selftests/net/fcnal-test.sh
index 3313566ce906..46297ceaa6d1 100755
--- a/tools/testing/selftests/net/fcnal-test.sh
+++ b/tools/testing/selftests/net/fcnal-test.sh
@@ -4077,3 +4077,11 @@ cleanup 2>/dev/null
 
 printf "\nTests passed: %3d\n" ${nsuccess}
 printf "Tests failed: %3d\n"   ${nfail}
+
+if [ $nfail -ne 0 ]; then
+	exit 1 # KSFT_FAIL
+elif [ $nsuccess -eq 0 ]; then
+	exit $ksft_skip
+fi
+
+exit 0 # KSFT_PASS
-- 
2.32.0


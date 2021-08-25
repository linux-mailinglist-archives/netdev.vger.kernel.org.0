Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8C8D3F6EB0
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 07:05:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231735AbhHYFFs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 01:05:48 -0400
Received: from mail.cn.fujitsu.com ([183.91.158.132]:15318 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S230407AbhHYFFs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Aug 2021 01:05:48 -0400
IronPort-HdrOrdr: =?us-ascii?q?A9a23=3ALdJKkqjjMwc7y6KTzTLN7IwF1XBQXuYji2hC?=
 =?us-ascii?q?6mlwRA09TyX4rbHLoB1/73LJYVkqNk3I5urrBEDtexLhHP1OkOws1NWZLWrbUQ?=
 =?us-ascii?q?KTRekM0WKI+UyDJ8SRzI5g/JYlW61/Jfm1NlJikPv9iTPSL/8QhPWB74Ck7N2z?=
 =?us-ascii?q?80tQ?=
X-IronPort-AV: E=Sophos;i="5.84,349,1620662400"; 
   d="scan'208";a="113428576"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 25 Aug 2021 13:05:01 +0800
Received: from G08CNEXMBPEKD04.g08.fujitsu.local (unknown [10.167.33.201])
        by cn.fujitsu.com (Postfix) with ESMTP id 302994D0D497;
        Wed, 25 Aug 2021 13:04:57 +0800 (CST)
Received: from G08CNEXCHPEKD09.g08.fujitsu.local (10.167.33.85) by
 G08CNEXMBPEKD04.g08.fujitsu.local (10.167.33.201) with Microsoft SMTP Server
 (TLS) id 15.0.1497.23; Wed, 25 Aug 2021 13:04:56 +0800
Received: from localhost.localdomain (10.167.225.141) by
 G08CNEXCHPEKD09.g08.fujitsu.local (10.167.33.209) with Microsoft SMTP Server
 id 15.0.1497.23 via Frontend Transport; Wed, 25 Aug 2021 13:04:56 +0800
From:   Li Zhijian <lizhijian@cn.fujitsu.com>
To:     <rjw@rjwysocki.net>, <viresh.kumar@linaro.org>, <shuah@kernel.org>,
        <Jason@zx2c4.com>, <masahiroy@kernel.org>,
        <linux-kselftest@vger.kernel.org>
CC:     <linux-pm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <wireguard@lists.zx2c4.com>, <netdev@vger.kernel.org>,
        Li Zhijian <lizhijian@cn.fujitsu.com>,
        Philip Li <philip.li@intel.com>,
        "kernel test robot" <lkp@intel.com>
Subject: [PATCH] selftests: cleanup config
Date:   Wed, 25 Aug 2021 13:09:48 +0800
Message-ID: <20210825050948.10339-1-lizhijian@cn.fujitsu.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-yoursite-MailScanner-ID: 302994D0D497.A0473
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: lizhijian@fujitsu.com
X-Spam-Status: No
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

- DEBUG_PI_LIST was renamed to DEBUG_PLIST since 8e18faeac3 ("lib/plist: rename DEBUG_PI_LIST to DEBUG_PLIST")
- SYNC was removed since aff9da10e21 ("staging/android: make sync_timeline internal to sw_sync")

$ for k in $(grep ^CONFIG $(find tools/testing/selftests/ -name config) | awk -F'=' '{print$1}' | awk -F':' '{print $2}' | sort | uniq); do  k=${k#CONFIG_}; git grep -qw -e "menuconfig $k" -e "config $k" || echo "$k is missing"; done;
DEBUG_PI_LIST is missing
SYNC is missing

CC: Philip Li <philip.li@intel.com>
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Li Zhijian <lizhijian@cn.fujitsu.com>
---
 tools/testing/selftests/cpufreq/config              | 2 +-
 tools/testing/selftests/sync/config                 | 1 -
 tools/testing/selftests/wireguard/qemu/debug.config | 2 +-
 3 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/cpufreq/config b/tools/testing/selftests/cpufreq/config
index 27ff72ebd0f5..75e900793e8a 100644
--- a/tools/testing/selftests/cpufreq/config
+++ b/tools/testing/selftests/cpufreq/config
@@ -6,7 +6,7 @@ CONFIG_CPU_FREQ_GOV_ONDEMAND=y
 CONFIG_CPU_FREQ_GOV_CONSERVATIVE=y
 CONFIG_CPU_FREQ_GOV_SCHEDUTIL=y
 CONFIG_DEBUG_RT_MUTEXES=y
-CONFIG_DEBUG_PI_LIST=y
+CONFIG_DEBUG_PLIST=y
 CONFIG_DEBUG_SPINLOCK=y
 CONFIG_DEBUG_MUTEXES=y
 CONFIG_DEBUG_LOCK_ALLOC=y
diff --git a/tools/testing/selftests/sync/config b/tools/testing/selftests/sync/config
index 1ab7e8130db2..47ff5afc3727 100644
--- a/tools/testing/selftests/sync/config
+++ b/tools/testing/selftests/sync/config
@@ -1,4 +1,3 @@
 CONFIG_STAGING=y
 CONFIG_ANDROID=y
-CONFIG_SYNC=y
 CONFIG_SW_SYNC=y
diff --git a/tools/testing/selftests/wireguard/qemu/debug.config b/tools/testing/selftests/wireguard/qemu/debug.config
index fe07d97df9fa..2b321b8a96cf 100644
--- a/tools/testing/selftests/wireguard/qemu/debug.config
+++ b/tools/testing/selftests/wireguard/qemu/debug.config
@@ -47,7 +47,7 @@ CONFIG_DEBUG_ATOMIC_SLEEP=y
 CONFIG_TRACE_IRQFLAGS=y
 CONFIG_DEBUG_BUGVERBOSE=y
 CONFIG_DEBUG_LIST=y
-CONFIG_DEBUG_PI_LIST=y
+CONFIG_DEBUG_PLIST=y
 CONFIG_PROVE_RCU=y
 CONFIG_SPARSE_RCU_POINTER=y
 CONFIG_RCU_CPU_STALL_TIMEOUT=21
-- 
2.31.1




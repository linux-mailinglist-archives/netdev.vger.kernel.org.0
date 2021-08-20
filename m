Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE3933F250E
	for <lists+netdev@lfdr.de>; Fri, 20 Aug 2021 04:58:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237872AbhHTC7J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Aug 2021 22:59:09 -0400
Received: from mail.cn.fujitsu.com ([183.91.158.132]:41931 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S234797AbhHTC7I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Aug 2021 22:59:08 -0400
IronPort-HdrOrdr: =?us-ascii?q?A9a23=3AykiYbqPLLL4ekMBcTiWjsMiBIKoaSvp037Eq?=
 =?us-ascii?q?v3oedfUzSL3/qynOpoVj6faaslYssR0b9exofZPwJE80lqQFhrX5X43SPzUO0V?=
 =?us-ascii?q?HAROoJgLcKgQeQfxEWndQ96U4PScdD4aXLfDpHZNjBkXSFOudl0N+a67qpmOub?=
 =?us-ascii?q?639sSDthY6Zm4xwRMHfhLmRGABlBGYEiFIeRou5Opz+bc3wRacihQlYfWeyrna?=
 =?us-ascii?q?ywqLvWJQ4BGwU86BSDyReh6LvBGRCe2RsEFxNjqI1SiVT4rw=3D=3D?=
X-IronPort-AV: E=Sophos;i="5.84,336,1620662400"; 
   d="scan'208";a="113158693"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 20 Aug 2021 10:58:28 +0800
Received: from G08CNEXMBPEKD06.g08.fujitsu.local (unknown [10.167.33.206])
        by cn.fujitsu.com (Postfix) with ESMTP id 11F084D0D9BA;
        Fri, 20 Aug 2021 10:58:23 +0800 (CST)
Received: from G08CNEXCHPEKD07.g08.fujitsu.local (10.167.33.80) by
 G08CNEXMBPEKD06.g08.fujitsu.local (10.167.33.206) with Microsoft SMTP Server
 (TLS) id 15.0.1497.23; Fri, 20 Aug 2021 10:58:17 +0800
Received: from FNSTPC.g08.fujitsu.local (10.167.226.45) by
 G08CNEXCHPEKD07.g08.fujitsu.local (10.167.33.209) with Microsoft SMTP Server
 id 15.0.1497.23 via Frontend Transport; Fri, 20 Aug 2021 10:58:17 +0800
From:   Li Zhijian <lizhijian@cn.fujitsu.com>
To:     <shuah@kernel.org>, <linux-kselftest@vger.kernel.org>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>
CC:     <ast@kernel.org>, <daniel@iogearbox.net>, <andrii@kernel.org>,
        <kafai@fb.com>, <songliubraving@fb.com>, <yhs@fb.com>,
        <kpsingh@kernel.org>, <linux-kernel@vger.kernel.org>,
        <philip.li@intel.com>, <yifeix.zhu@intel.com>,
        Li Zhijian <lizhijian@cn.fujitsu.com>
Subject: [PATCH v2 5/5] selftests/bpf: exit with KSFT_SKIP if no Makefile found
Date:   Fri, 20 Aug 2021 10:55:49 +0800
Message-ID: <20210820025549.28325-1-lizhijian@cn.fujitsu.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210820015556.23276-1-lizhijian@cn.fujitsu.com>
References: <20210820015556.23276-1-lizhijian@cn.fujitsu.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-yoursite-MailScanner-ID: 11F084D0D9BA.AFE72
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: lizhijian@fujitsu.com
X-Spam-Status: No
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This would happend when we run the tests after install kselftests
 root@lkp-skl-d01 ~# /kselftests/run_kselftest.sh -t bpf:test_doc_build.sh
 TAP version 13
 1..1
 # selftests: bpf: test_doc_build.sh
 perl: warning: Setting locale failed.
 perl: warning: Please check that your locale settings:
         LANGUAGE = (unset),
         LC_ALL = (unset),
         LC_ADDRESS = "en_US.UTF-8",
         LC_NAME = "en_US.UTF-8",
         LC_MONETARY = "en_US.UTF-8",
         LC_PAPER = "en_US.UTF-8",
         LC_IDENTIFICATION = "en_US.UTF-8",
         LC_TELEPHONE = "en_US.UTF-8",
         LC_MEASUREMENT = "en_US.UTF-8",
         LC_TIME = "en_US.UTF-8",
         LC_NUMERIC = "en_US.UTF-8",
         LANG = "en_US.UTF-8"
     are supported and installed on your system.
 perl: warning: Falling back to the standard locale ("C").
 # skip:    bpftool files not found!
 #
 ok 1 selftests: bpf: test_doc_build.sh # SKIP

Signed-off-by: Li Zhijian <lizhijian@cn.fujitsu.com>
---
 tools/testing/selftests/bpf/test_bpftool_build.sh | 2 +-
 tools/testing/selftests/bpf/test_doc_build.sh     | 5 +++++
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/test_bpftool_build.sh b/tools/testing/selftests/bpf/test_bpftool_build.sh
index ac349a5cea7e..b03a87571592 100755
--- a/tools/testing/selftests/bpf/test_bpftool_build.sh
+++ b/tools/testing/selftests/bpf/test_bpftool_build.sh
@@ -22,7 +22,7 @@ KDIR_ROOT_DIR=$(realpath $PWD/$SCRIPT_REL_DIR/../../../../)
 cd $KDIR_ROOT_DIR
 if [ ! -e tools/bpf/bpftool/Makefile ]; then
 	echo -e "skip:    bpftool files not found!\n"
-	exit 0
+	exit 4 # KSFT_SKIP=4
 fi
 
 ERROR=0
diff --git a/tools/testing/selftests/bpf/test_doc_build.sh b/tools/testing/selftests/bpf/test_doc_build.sh
index d67ced95a6cf..679cf968c7d1 100755
--- a/tools/testing/selftests/bpf/test_doc_build.sh
+++ b/tools/testing/selftests/bpf/test_doc_build.sh
@@ -10,6 +10,11 @@ KDIR_ROOT_DIR=$(realpath $SCRIPT_REL_DIR/../../../../)
 SCRIPT_REL_DIR=$(dirname $(realpath --relative-to=$KDIR_ROOT_DIR $SCRIPT_REL_PATH))
 cd $KDIR_ROOT_DIR
 
+if [ ! -e $PWD/$SCRIPT_REL_DIR/Makefile ]; then
+	echo -e "skip:    bpftool files not found!\n"
+	exit 4 # KSFT_SKIP=4
+fi
+
 for tgt in docs docs-clean; do
 	make -s -C $PWD/$SCRIPT_REL_DIR $tgt;
 done
-- 
2.32.0




Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F228D3F1455
	for <lists+netdev@lfdr.de>; Thu, 19 Aug 2021 09:27:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236765AbhHSH1s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Aug 2021 03:27:48 -0400
Received: from mail.cn.fujitsu.com ([183.91.158.132]:12272 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S232003AbhHSH1p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Aug 2021 03:27:45 -0400
IronPort-HdrOrdr: =?us-ascii?q?A9a23=3AoxiJsquheJHX+6qQyiJgOSgW7skDktV00zEX?=
 =?us-ascii?q?/kB9WHVpmszxra6TdZMgpHnJYVcqKQgdcL+7WJVoLUmxyXcx2/h1AV7AZniAhI?=
 =?us-ascii?q?LLFvAA0WKK+VSJcEeSygce79YFT0EUMrzN5DZB4voSmDPIcerI3uP3jZyAtKPP?=
 =?us-ascii?q?yWt3VwF2Z+VF5wd9MAySFUp7X2B9dOEEPavZ9sxavCChZHhSSsy6A0MOV+/Fq8?=
 =?us-ascii?q?aOu4nhZXc9dmQawTjLnTW186T7DhTd+h8fVglEybAk/XOAsyGR3NTaj82G?=
X-IronPort-AV: E=Sophos;i="5.84,334,1620662400"; 
   d="scan'208";a="113116166"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 19 Aug 2021 15:27:05 +0800
Received: from G08CNEXMBPEKD04.g08.fujitsu.local (unknown [10.167.33.201])
        by cn.fujitsu.com (Postfix) with ESMTP id 2557C4D0D4BE;
        Thu, 19 Aug 2021 15:27:02 +0800 (CST)
Received: from G08CNEXCHPEKD07.g08.fujitsu.local (10.167.33.80) by
 G08CNEXMBPEKD04.g08.fujitsu.local (10.167.33.201) with Microsoft SMTP Server
 (TLS) id 15.0.1497.23; Thu, 19 Aug 2021 15:27:02 +0800
Received: from FNSTPC.g08.fujitsu.local (10.167.226.45) by
 G08CNEXCHPEKD07.g08.fujitsu.local (10.167.33.209) with Microsoft SMTP Server
 id 15.0.1497.23 via Frontend Transport; Thu, 19 Aug 2021 15:27:01 +0800
From:   Li Zhijian <lizhijian@cn.fujitsu.com>
To:     <shuah@kernel.org>, <linux-kselftest@vger.kernel.org>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>
CC:     <ast@kernel.org>, <daniel@iogearbox.net>, <andrii@kernel.org>,
        <kafai@fb.com>, <songliubraving@fb.com>, <yhs@fb.com>,
        <kpsingh@kernel.org>, <linux-kernel@vger.kernel.org>,
        <philip.li@intel.com>, <yifeix.zhu@intel.com>,
        Li Zhijian <lizhijian@cn.fujitsu.com>
Subject: [PATCH 2/3] selftests/bpf: add default bpftool built by selftests to PATH
Date:   Thu, 19 Aug 2021 15:24:30 +0800
Message-ID: <20210819072431.21966-2-lizhijian@cn.fujitsu.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210819072431.21966-1-lizhijian@cn.fujitsu.com>
References: <20210819072431.21966-1-lizhijian@cn.fujitsu.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-yoursite-MailScanner-ID: 2557C4D0D4BE.A019E
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: lizhijian@fujitsu.com
X-Spam-Status: No
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For 'make run_tests':
selftests will build bpftool into tools/testing/selftests/bpf/tools/sbin/bpftool
by default.

==================
root@lkp-skl-d01 /opt/rootfs/v5.14-rc4# make -C tools/testing/selftests/bpf run_tests
make: Entering directory '/opt/rootfs/v5.14-rc4/tools/testing/selftests/bpf'
  MKDIR    include
  MKDIR    libbpf
  MKDIR    bpftool
[...]
  GEN     /opt/rootfs/v5.14-rc4/tools/testing/selftests/bpf/tools/build/bpftool/profiler.skel.h
  CC      /opt/rootfs/v5.14-rc4/tools/testing/selftests/bpf/tools/build/bpftool/prog.o
  GEN     /opt/rootfs/v5.14-rc4/tools/testing/selftests/bpf/tools/build/bpftool/pid_iter.skel.h
  CC      /opt/rootfs/v5.14-rc4/tools/testing/selftests/bpf/tools/build/bpftool/pids.o
  LINK    /opt/rootfs/v5.14-rc4/tools/testing/selftests/bpf/tools/build/bpftool/bpftool
  INSTALL bpftool
  GEN      vmlinux.h
[...]
 # test_feature_dev_json (test_bpftool.TestBpftool) ... ERROR
 # test_feature_kernel (test_bpftool.TestBpftool) ... ERROR
 # test_feature_kernel_full (test_bpftool.TestBpftool) ... ERROR
 # test_feature_kernel_full_vs_not_full (test_bpftool.TestBpftool) ... ERROR
 # test_feature_macros (test_bpftool.TestBpftool) ... Error: bug: failed to retrieve CAP_BPF status: Invalid argument
 # ERROR
 #
 # ======================================================================
 # ERROR: test_feature_dev_json (test_bpftool.TestBpftool)
 # ----------------------------------------------------------------------
 # Traceback (most recent call last):
 #   File "/opt/rootfs/v5.14-rc4/tools/testing/selftests/bpf/test_bpftool.py", line 57, in wrapper
 #     return f(*args, iface, **kwargs)
 #   File "/opt/rootfs/v5.14-rc4/tools/testing/selftests/bpf/test_bpftool.py", line 82, in test_feature_dev_json
 #     res = bpftool_json(["feature", "probe", "dev", iface])
 #   File "/opt/rootfs/v5.14-rc4/tools/testing/selftests/bpf/test_bpftool.py", line 42, in bpftool_json
 #     res = _bpftool(args)
 #   File "/opt/rootfs/v5.14-rc4/tools/testing/selftests/bpf/test_bpftool.py", line 34, in _bpftool
 #     return subprocess.check_output(_args)
 #   File "/usr/lib/python3.7/subprocess.py", line 395, in check_output
 #     **kwargs).stdout
 #   File "/usr/lib/python3.7/subprocess.py", line 487, in run
 #     output=stdout, stderr=stderr)
 # subprocess.CalledProcessError: Command '['bpftool', '-j', 'feature', 'probe', 'dev', 'dummy0']' returned non-zero exit status 255.
 #
==================

Signed-off-by: Li Zhijian <lizhijian@cn.fujitsu.com>
---
 tools/testing/selftests/bpf/test_bpftool.sh | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/tools/testing/selftests/bpf/test_bpftool.sh b/tools/testing/selftests/bpf/test_bpftool.sh
index 66690778e36d..6b7ba19be1d0 100755
--- a/tools/testing/selftests/bpf/test_bpftool.sh
+++ b/tools/testing/selftests/bpf/test_bpftool.sh
@@ -2,4 +2,9 @@
 # SPDX-License-Identifier: GPL-2.0
 # Copyright (c) 2020 SUSE LLC.
 
+SCRIPT_DIR=$(dirname $(realpath $0))
+
+# 'make -C tools/testing/selftests/bpf' will install to BPFTOOL_INSTALL_PATH
+BPFTOOL_INSTALL_PATH="$SCRIPT_DIR"/tools/sbin
+export PATH=$BPFTOOL_INSTALL_PATH:$PATH
 python3 -m unittest -v test_bpftool.TestBpftool
-- 
2.32.0




Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C0491D76C8
	for <lists+netdev@lfdr.de>; Mon, 18 May 2020 13:23:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726990AbgERLXn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 07:23:43 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:38814 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726557AbgERLXn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 May 2020 07:23:43 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04IBGxpx009077;
        Mon, 18 May 2020 11:23:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id; s=corp-2020-01-29;
 bh=WhKgqWW/ss1/ui8eF5iBOOIA94Jr8CndDKl/Rj/QT98=;
 b=XkC0I8S9dNCz4tUgnnXy2Ec6Lt/Mo1sP5ms4dLa6YRpqon7nT802/lCejPWWds8mS3xH
 acvVksX396SjMzopQAV7Nvjwrk1lf1kgQfg/DjBeYhEibYaAw0oz3Iym6+3Tu9KtT5Ha
 zwBQhhbJoYhNqZ2SR4hK++ibRsTJAeKzb5AGdfUPfxsiMZgtrDIjOkbTobUXJwJ4ihvu
 m9N6WFi1uPM+9enOIWODeyM1SpyM3CkFSPh6q+77gqCOQd49uUrEfj5aEtM1bhJJtzWX
 mRM37DUuB8h2nT+7mEh28vGZXBTkb1uYi3FbjIRPEsWLkldrF5tBKrpAUd32223AnXtI tQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 3127kqx6pe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 18 May 2020 11:23:26 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04IBJ5Nt036031;
        Mon, 18 May 2020 11:23:26 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 312sxq58jp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 18 May 2020 11:23:26 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 04IBNO6g031124;
        Mon, 18 May 2020 11:23:24 GMT
Received: from localhost.uk.oracle.com (/10.175.184.176)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 18 May 2020 04:23:24 -0700
From:   Alan Maguire <alan.maguire@oracle.com>
To:     shuah@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andriin@fb.com, bpf@vger.kernel.org
Cc:     kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@chromium.org,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        Alan Maguire <alan.maguire@oracle.com>
Subject: [PATCH bpf-next] selftests/bpf: add general instructions for test execution
Date:   Mon, 18 May 2020 12:23:10 +0100
Message-Id: <1589800990-11209-1-git-send-email-alan.maguire@oracle.com>
X-Mailer: git-send-email 1.8.3.1
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9624 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 malwarescore=0
 mlxlogscore=999 bulkscore=0 mlxscore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005180102
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9624 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 spamscore=0
 bulkscore=0 clxscore=1015 priorityscore=1501 mlxscore=0 impostorscore=0
 suspectscore=0 mlxlogscore=999 malwarescore=0 cotscore=-2147483648
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005180102
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Getting a clean BPF selftests run involves ensuring latest trunk LLVM/clang
are used, pahole is recent (>=1.16) and config matches the specified
config file as closely as possible.  Document all of this in the general
README.rst file.  Also note how to work around timeout failures.

Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
---
 tools/testing/selftests/bpf/README.rst | 46 ++++++++++++++++++++++++++++++++++
 1 file changed, 46 insertions(+)

diff --git a/tools/testing/selftests/bpf/README.rst b/tools/testing/selftests/bpf/README.rst
index 0f67f1b..b00eebb 100644
--- a/tools/testing/selftests/bpf/README.rst
+++ b/tools/testing/selftests/bpf/README.rst
@@ -1,6 +1,52 @@
 ==================
 BPF Selftest Notes
 ==================
+First verify the built kernel config options match the config options
+specified in the config file in this directory.  Test failures for
+unknown helpers, inability to find BTF etc will be observed otherwise.
+
+To ensure the maximum number of tests pass, it is best to use the latest
+trunk LLVM/clang, i.e.
+
+git clone https://github.com/llvm/llvm-project
+
+Build/install trunk LLVM:
+
+.. code-block:: bash
+  git clone https://github.com/llvm/llvm-project
+  cd llvm-project
+  mkdir build/llvm
+  cd build/llvm
+  cmake ../../llvm/
+  make
+  sudo make install
+  cd ../../
+
+Build/install trunk clang:
+
+.. code-block:: bash
+  mkdir -p build/clang
+  cd build/clang
+  cmake ../../clang
+  make
+  sudo make install
+
+When building the kernel with CONFIG_DEBUG_INFO_BTF, pahole
+version 16 or later is also required for BTF function
+support. pahole can be built from the source at
+
+https://github.com/acmel/dwarves
+
+It is often available in "dwarves/libdwarves" packages also,
+but be aware that versions prior to 1.16 will fail with
+errors that functions cannot be found in BTF.
+
+When running selftests, the default timeout of 45 seconds
+can be exceeded by some tests.  We can override the default
+timeout via a "settings" file; for example:
+
+.. code-block:: bash
+  echo "timeout=120" > tools/testing/selftests/bpf/settings
 
 Additional information about selftest failures are
 documented here.
-- 
1.8.3.1


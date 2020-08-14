Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABD042446AD
	for <lists+netdev@lfdr.de>; Fri, 14 Aug 2020 10:58:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727793AbgHNI65 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Aug 2020 04:58:57 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:54596 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726050AbgHNI64 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Aug 2020 04:58:56 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07E8VQxl187939;
        Fri, 14 Aug 2020 04:58:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=pp1;
 bh=3bD+VkoYgERAXYyqXKaVYhVGu32lTtmgYGXCqKyQo7Q=;
 b=ZddHAH0F7UFwlugExDuDfhw0yeloN8dLRra8nS24qS3PBSzOXPm7Ts+/gEgqyKkAKfhn
 h9roZ29DfzqyebBDZ+mlvMfNoZwKuUvY/vgVO+UN5xUaYRxyFQQVUBKkS3p2f2UbignO
 5qD3k6pQ3eHkE+N969x4BRYPGS5Z5tlHYsTlChV5XhcKrJETbH4owC5Mfth6pRywviD6
 /hwkPmELQFWY5L8AArjfQdgfHKKTnEM+qOP3eg23gL/vd9vUajWT+kF/wIOGksObU/jK
 tL4Ny+02NTYyCCgDIY7aMF65xR2FVsBGJ69cT+79WWqRovw+miunECvwubm89GVgpMoE kA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 32w4ba863t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Aug 2020 04:58:41 -0400
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 07E8WUdQ192053;
        Fri, 14 Aug 2020 04:58:40 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com with ESMTP id 32w4ba8637-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Aug 2020 04:58:40 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 07E8pk9c004338;
        Fri, 14 Aug 2020 08:58:38 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma06ams.nl.ibm.com with ESMTP id 32skaheefr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Aug 2020 08:58:38 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 07E8wZLf27591046
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Aug 2020 08:58:35 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A347FA405C;
        Fri, 14 Aug 2020 08:58:35 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9485AA4064;
        Fri, 14 Aug 2020 08:58:31 +0000 (GMT)
Received: from localhost.localdomain.com (unknown [9.85.94.53])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 14 Aug 2020 08:58:31 +0000 (GMT)
From:   Balamuruhan S <bala24@linux.ibm.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        naveen.n.rao@linux.vnet.ibm.com, ravi.bangoria@linux.ibm.com,
        sandipan@linux.ibm.com, kafai@fb.com, songliubraving@fb.com,
        yhs@fb.com, andriin@fb.com, john.fastabend@gmail.com,
        kpsingh@chromium.org, Balamuruhan S <bala24@linux.ibm.com>
Subject: [PATCH bpf] selftest/bpf: make bpftool if it is not already built
Date:   Fri, 14 Aug 2020 14:27:56 +0530
Message-Id: <20200814085756.205609-1-bala24@linux.ibm.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-14_04:2020-08-14,2020-08-14 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=15 mlxscore=0
 malwarescore=0 bulkscore=0 impostorscore=0 lowpriorityscore=0
 priorityscore=1501 clxscore=1011 phishscore=0 spamscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008140060
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

test_bpftool error out if bpftool is not available in bpftool dir
linux/tools/bpf/bpftool, build and clean it as part of test
bootstrap and teardown.

Error log:
---------
test_feature_dev_json (test_bpftool.TestBpftool) ... ERROR
test_feature_kernel (test_bpftool.TestBpftool) ... ERROR
test_feature_kernel_full (test_bpftool.TestBpftool) ... ERROR
test_feature_kernel_full_vs_not_full (test_bpftool.TestBpftool) ... ERROR
test_feature_macros (test_bpftool.TestBpftool) ... ERROR

======================================================================
ERROR: test_feature_dev_json (test_bpftool.TestBpftool)
----------------------------------------------------------------------
Traceback (most recent call last):
  File "/home/ubuntu/disk/linux/tools/testing/selftests/bpf/test_bpftool.py",
    return f(*args, iface, **kwargs)
  File "/home/ubuntu/disk/linux/tools/testing/selftests/bpf/test_bpftool.py",
    res = bpftool_json(["feature", "probe", "dev", iface])
  File "/home/ubuntu/disk/linux/tools/testing/selftests/bpf/test_bpftool.py",
    res = _bpftool(args)
  File "/home/ubuntu/disk/linux/tools/testing/selftests/bpf/test_bpftool.py",
    return subprocess.check_output(_args)
  File "/usr/lib/python3.8/subprocess.py", line 411, in check_output
    return run(*popenargs, stdout=PIPE, timeout=timeout, check=True,
  File "/usr/lib/python3.8/subprocess.py", line 489, in run
    with Popen(*popenargs, **kwargs) as process:
  File "/usr/lib/python3.8/subprocess.py", line 854, in __init__
    self._execute_child(args, executable, preexec_fn, close_fds,
  File "/usr/lib/python3.8/subprocess.py", line 1702, in _execute_child
    raise child_exception_type(errno_num, err_msg, err_filename)
FileNotFoundError: [Errno 2] No such file or directory: 'bpftool'

Signed-off-by: Balamuruhan S <bala24@linux.ibm.com>
---
 tools/testing/selftests/bpf/test_bpftool.py | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/tools/testing/selftests/bpf/test_bpftool.py b/tools/testing/selftests/bpf/test_bpftool.py
index 4fed2dc25c0a..60357c6891a6 100644
--- a/tools/testing/selftests/bpf/test_bpftool.py
+++ b/tools/testing/selftests/bpf/test_bpftool.py
@@ -58,12 +58,25 @@ def default_iface(f):
     return wrapper
 
 
+def make_bpftool(clean=False):
+    cmd = "make"
+    if clean:
+        cmd = "make clean"
+    return subprocess.run(cmd, shell=True, cwd=bpftool_dir, check=True,
+                          stdout=subprocess.DEVNULL)
+
 class TestBpftool(unittest.TestCase):
     @classmethod
     def setUpClass(cls):
         if os.getuid() != 0:
             raise UnprivilegedUserError(
                 "This test suite needs root privileges")
+        if subprocess.getstatusoutput("bpftool -h")[0]:
+            make_bpftool()
+
+    @classmethod
+    def tearDownClass(cls):
+        make_bpftool(clean=True)
 
     @default_iface
     def test_feature_dev_json(self, iface):

base-commit: 6e868cf355725fbe9fa512d01b09b8ee7f3358f0
-- 
2.24.1


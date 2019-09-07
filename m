Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 99E84AC97A
	for <lists+netdev@lfdr.de>; Sat,  7 Sep 2019 23:43:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393052AbfIGVnZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Sep 2019 17:43:25 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:48190 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727500AbfIGVnZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Sep 2019 17:43:25 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x87Ld90q149116;
        Sat, 7 Sep 2019 21:42:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2019-08-05;
 bh=m7+5mPwetUSLa6GGEVBeNctO1RzGMtRhppzVsKMw5j8=;
 b=cXE9MwLcesIftJYWl42xvYTYgZpt0OlhuPjchB6OgSV4jnzppihvKvErDAQ1t8vB+sQw
 0glMFToEud3iUnn4NTb/Jl8nP9mfBuJ2uIrQpuhqQ4iwUpjUO1qgBGsIQPxYpb0eBurI
 5bPWS+fQZn6BzXbgIiaLQlMT0LN52bfZ1vTP4b75u7a0S2d++2GjphZcKRK58cekjSLu
 o9sMZShC9PcwQk7csDanyJU8fbHk3RDMwHe7l6q4db2SOqbW+CjwrzJR+5BG+cBhbpCZ
 XTLwo6D0u1CFQFmu6TdfpcVjItTqy+sB41zAe5LgPlBaNymCWjcZUT5YnGPzhNyfyCrF 3w== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2uvmet810v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 07 Sep 2019 21:42:24 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x87LbUvr177955;
        Sat, 7 Sep 2019 21:42:23 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2uv4d0g9t9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 07 Sep 2019 21:42:23 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x87LgKt9006850;
        Sat, 7 Sep 2019 21:42:21 GMT
Received: from dhcp-10-175-169-153.vpn.oracle.com (/10.175.169.153)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 07 Sep 2019 14:42:20 -0700
From:   Alan Maguire <alan.maguire@oracle.com>
To:     ast@kernel.org, daniel@iogearbox.net, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, davem@davemloft.net,
        jakub.kicinski@netronome.com, hawk@kernel.org,
        john.fastabend@gmail.com, rostedt@goodmis.org, mingo@redhat.com,
        quentin.monnet@netronome.com, rdna@fb.com, joe@wand.net.nz,
        acme@redhat.com, jolsa@kernel.org, alexey.budankov@linux.intel.com,
        gregkh@linuxfoundation.org, namhyung@kernel.org, sdf@google.com,
        f.fainelli@gmail.com, shuah@kernel.org, peter@lekensteyn.nl,
        ivan@cloudflare.com, andriin@fb.com,
        bhole_prashant_q7@lab.ntt.co.jp, david.calavera@gmail.com,
        danieltimlee@gmail.com, ctakshak@fb.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kselftest@vger.kernel.org
Cc:     Alan Maguire <alan.maguire@oracle.com>
Subject: [RFC bpf-next 4/7] bpf: add libpcap feature test
Date:   Sat,  7 Sep 2019 22:40:41 +0100
Message-Id: <1567892444-16344-5-git-send-email-alan.maguire@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1567892444-16344-1-git-send-email-alan.maguire@oracle.com>
References: <1567892444-16344-1-git-send-email-alan.maguire@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9373 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1909070235
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9373 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1909070235
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

this test will be used when deciding whether to add the pcap
support features in the following patch

Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
---
 tools/build/Makefile.feature       |  2 ++
 tools/build/feature/Makefile       |  4 ++++
 tools/build/feature/test-libpcap.c | 26 ++++++++++++++++++++++++++
 3 files changed, 32 insertions(+)
 create mode 100644 tools/build/feature/test-libpcap.c

diff --git a/tools/build/Makefile.feature b/tools/build/Makefile.feature
index 86b793d..35e65418 100644
--- a/tools/build/Makefile.feature
+++ b/tools/build/Makefile.feature
@@ -85,6 +85,7 @@ FEATURE_TESTS_EXTRA :=                  \
          libbfd-liberty                 \
          libbfd-liberty-z               \
          libopencsd                     \
+         libpcap                        \
          libunwind-x86                  \
          libunwind-x86_64               \
          libunwind-arm                  \
@@ -113,6 +114,7 @@ FEATURE_DISPLAY ?=              \
          libelf                 \
          libnuma                \
          numa_num_possible_cpus \
+         libpcap                \
          libperl                \
          libpython              \
          libcrypto              \
diff --git a/tools/build/feature/Makefile b/tools/build/feature/Makefile
index 0658b8c..c7585a1 100644
--- a/tools/build/feature/Makefile
+++ b/tools/build/feature/Makefile
@@ -27,6 +27,7 @@ FILES=                                          \
          test-libelf-mmap.bin                   \
          test-libnuma.bin                       \
          test-numa_num_possible_cpus.bin        \
+         test-libpcap.bin                       \
          test-libperl.bin                       \
          test-libpython.bin                     \
          test-libpython-version.bin             \
@@ -209,6 +210,9 @@ FLAGS_PERL_EMBED=$(PERL_EMBED_CCOPTS) $(PERL_EMBED_LDOPTS)
 $(OUTPUT)test-libperl.bin:
 	$(BUILD) $(FLAGS_PERL_EMBED)
 
+$(OUTPUT)test-libpcap.bin:
+	$(BUILD) -lpcap
+
 $(OUTPUT)test-libpython.bin:
 	$(BUILD) $(FLAGS_PYTHON_EMBED)
 
diff --git a/tools/build/feature/test-libpcap.c b/tools/build/feature/test-libpcap.c
new file mode 100644
index 0000000..7f60eb9
--- /dev/null
+++ b/tools/build/feature/test-libpcap.c
@@ -0,0 +1,26 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <pcap.h>
+
+#define PKTLEN 100
+
+int main(void)
+{
+	char dummy_data[PKTLEN] = { 0 };
+	pcap_dumper_t *pcap_dumper;
+	struct pcap_pkthdr hdr;
+	int proto = 1;
+	pcap_t *pcap;
+
+	pcap = pcap_open_dead(proto, PKTLEN);
+	pcap_dumper = pcap_dump_open(pcap, "-");
+	hdr.caplen = PKTLEN;
+	hdr.len = PKTLEN;
+	hdr.ts.tv_sec = 0;
+	hdr.ts.tv_usec = 0;
+	pcap_dump((u_char *)pcap_dumper, &hdr, (const u_char *)dummy_data);
+	pcap_dump_flush(pcap_dumper);
+	pcap_dump_close(pcap_dumper);
+	pcap_close(pcap);
+
+	return 0;
+}
-- 
1.8.3.1


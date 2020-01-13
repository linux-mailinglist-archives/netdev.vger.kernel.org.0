Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D531138C62
	for <lists+netdev@lfdr.de>; Mon, 13 Jan 2020 08:32:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728811AbgAMHcH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jan 2020 02:32:07 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:41080 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728847AbgAMHcG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jan 2020 02:32:06 -0500
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 00D7Ue0J017533
        for <netdev@vger.kernel.org>; Sun, 12 Jan 2020 23:32:05 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=g2L0ndR2Fb/5ZG+K7BX9PViazIin+aA4pa/dBMkl+i4=;
 b=LxEHxKRIdY1uUejZpWPsKxNaGTKqdmuGKsq2GDrXeiX/mCj6OY/KisIze5bBlrWqlOp7
 7/fRSMQFBJ2AvgerBbazExoKFwiBWshDqH4El74MO8GhCZ185kbDUd6+H0we+CdkTnsr
 Zk+L0LZ1lr1ht02Ugq9OL4Yj6G6X6KZOGxY= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2xfxt4386h-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Sun, 12 Jan 2020 23:32:05 -0800
Received: from intmgw003.03.ash8.facebook.com (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::129) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Sun, 12 Jan 2020 23:32:04 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id B79B72EC2329; Sun, 12 Jan 2020 23:32:01 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v2 bpf-next 6/6] selftests/bpf: build runqslower from selftests
Date:   Sun, 12 Jan 2020 23:31:43 -0800
Message-ID: <20200113073143.1779940-7-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200113073143.1779940-1-andriin@fb.com>
References: <20200113073143.1779940-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-13_01:2020-01-13,2020-01-13 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0
 clxscore=1015 mlxlogscore=847 impostorscore=0 priorityscore=1501
 spamscore=0 adultscore=0 lowpriorityscore=0 suspectscore=9 bulkscore=0
 malwarescore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-2001130063
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ensure runqslower tool is built as part of selftests to prevent it from bit
rotting.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/testing/selftests/bpf/Makefile | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index bf9f7e415e95..246d09ffb296 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -73,7 +73,7 @@ TEST_PROGS_EXTENDED := with_addr.sh \
 # Compile but not part of 'make run_tests'
 TEST_GEN_PROGS_EXTENDED = test_sock_addr test_skb_cgroup_id_user \
 	flow_dissector_load test_flow_dissector test_tcp_check_syncookie_user \
-	test_lirc_mode2_user xdping test_cpp
+	test_lirc_mode2_user xdping test_cpp runqslower
 
 TEST_CUSTOM_PROGS = urandom_read
 
@@ -124,6 +124,11 @@ $(OUTPUT)/test_stub.o: test_stub.c
 	$(call msg,CC,,$@)
 	$(CC) -c $(CFLAGS) -o $@ $<
 
+.PHONY: $(OUTPUT)/runqslower
+$(OUTPUT)/runqslower: force
+	$(Q)$(MAKE) $(submake_extras) -C $(TOOLSDIR)/bpf/runqslower	      \
+		    OUTPUT=$(CURDIR)/tools/
+
 BPFOBJ := $(OUTPUT)/libbpf.a
 
 $(TEST_GEN_PROGS) $(TEST_GEN_PROGS_EXTENDED): $(OUTPUT)/test_stub.o $(BPFOBJ)
-- 
2.17.1


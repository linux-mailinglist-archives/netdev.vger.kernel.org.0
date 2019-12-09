Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D12F711643D
	for <lists+netdev@lfdr.de>; Mon,  9 Dec 2019 01:01:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726917AbfLIABT convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sun, 8 Dec 2019 19:01:19 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:24182 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726863AbfLIABT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Dec 2019 19:01:19 -0500
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xB8Numk7031310
        for <netdev@vger.kernel.org>; Sun, 8 Dec 2019 16:01:18 -0800
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2wrvh0ag8h-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Sun, 08 Dec 2019 16:01:18 -0800
Received: from intmgw002.41.prn1.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Sun, 8 Dec 2019 16:01:16 -0800
Received: by devbig007.ftw2.facebook.com (Postfix, from userid 572438)
        id 85208760CCB; Sun,  8 Dec 2019 16:01:14 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Alexei Starovoitov <ast@kernel.org>
Smtp-Origin-Hostname: devbig007.ftw2.facebook.com
To:     <davem@davemloft.net>
CC:     <daniel@iogearbox.net>, <rostedt@goodmis.org>, <x86@kernel.org>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf 0/3] bpf: Make BPF trampoline friendly to ftrace
Date:   Sun, 8 Dec 2019 16:01:11 -0800
Message-ID: <20191209000114.1876138-1-ast@kernel.org>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-08_07:2019-12-05,2019-12-08 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_midline policy=fb_default score=62 priorityscore=1501
 impostorscore=0 clxscore=1034 mlxscore=62 mlxlogscore=-20 suspectscore=1
 malwarescore=0 lowpriorityscore=0 phishscore=0 adultscore=0 spamscore=62
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912080207
X-FB-Internal: spam
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Patch 1 - fix crash function_graph tracer encounters BPF trampoline
Patch 2 - use register_ftrace_direct() API to attach BPF trampoline
Patch 3 - simple test

Alexei Starovoitov (3):
  ftrace: Fix function_graph tracer interaction with BPF trampoline
  bpf: Make BPF trampoline use register_ftrace_direct() API
  selftests/bpf: test function_graph tracer and bpf trampoline together

 arch/x86/kernel/ftrace.c                   | 14 -----
 include/linux/bpf.h                        |  1 +
 include/linux/ftrace.h                     |  5 ++
 kernel/bpf/trampoline.c                    | 64 ++++++++++++++++++++--
 kernel/trace/fgraph.c                      |  9 +++
 kernel/trace/ftrace.c                      | 19 +++----
 tools/testing/selftests/bpf/test_ftrace.sh | 39 +++++++++++++
 7 files changed, 119 insertions(+), 32 deletions(-)
 create mode 100755 tools/testing/selftests/bpf/test_ftrace.sh

-- 
2.23.0


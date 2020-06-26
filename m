Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF91720A9C4
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 02:14:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726416AbgFZAOM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jun 2020 20:14:12 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:22302 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725876AbgFZANw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jun 2020 20:13:52 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 05Q08iux007909
        for <netdev@vger.kernel.org>; Thu, 25 Jun 2020 17:13:51 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=3ONjp7CWOSdFHihdfBb7maRuGkiLLNmD1ygd6LZZmLQ=;
 b=NB2DGrcoziBum2zvrT0a+J8ujl28JYJ8u1KydUH29yUHOVniCiopB16vriMcEkb4i7GT
 swISqSGSdPJAtW+kmXhN2wMPid5j9IxHmSZ1EfFE3Vjb+ImrY0rtTtrlEpvPpbWH48E7
 zzs/Ai9r6p5ZJRTZqVrtf5MJobEmPyPrMwQ= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0001303.ppops.net with ESMTP id 31ux1gjwfn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 25 Jun 2020 17:13:51 -0700
Received: from intmgw003.08.frc2.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:11d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 25 Jun 2020 17:13:50 -0700
Received: by devbig006.ftw2.facebook.com (Postfix, from userid 4523)
        id 4DC8F62E4FA9; Thu, 25 Jun 2020 17:13:42 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Song Liu <songliubraving@fb.com>
Smtp-Origin-Hostname: devbig006.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <peterz@infradead.org>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <kernel-team@fb.com>, <john.fastabend@gmail.com>,
        <kpsingh@chromium.org>, Song Liu <songliubraving@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v2 bpf-next 1/4] perf: export get/put_chain_entry()
Date:   Thu, 25 Jun 2020 17:13:29 -0700
Message-ID: <20200626001332.1554603-2-songliubraving@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200626001332.1554603-1-songliubraving@fb.com>
References: <20200626001332.1554603-1-songliubraving@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-25_19:2020-06-25,2020-06-25 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 adultscore=0 mlxlogscore=999 clxscore=1015 priorityscore=1501
 lowpriorityscore=0 cotscore=-2147483648 phishscore=0 spamscore=0
 mlxscore=0 bulkscore=0 impostorscore=0 suspectscore=8 classifier=spam
 adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006250142
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This would be used by bpf stack mapo.

Signed-off-by: Song Liu <songliubraving@fb.com>
---
 include/linux/perf_event.h | 2 ++
 kernel/events/callchain.c  | 4 ++--
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index b4bb32082342c..00ab5efa38334 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -1244,6 +1244,8 @@ get_perf_callchain(struct pt_regs *regs, u32 init_n=
r, bool kernel, bool user,
 extern struct perf_callchain_entry *perf_callchain(struct perf_event *ev=
ent, struct pt_regs *regs);
 extern int get_callchain_buffers(int max_stack);
 extern void put_callchain_buffers(void);
+extern struct perf_callchain_entry *get_callchain_entry(int *rctx);
+extern void put_callchain_entry(int rctx);
=20
 extern int sysctl_perf_event_max_stack;
 extern int sysctl_perf_event_max_contexts_per_stack;
diff --git a/kernel/events/callchain.c b/kernel/events/callchain.c
index 334d48b16c36d..50b8a1622807f 100644
--- a/kernel/events/callchain.c
+++ b/kernel/events/callchain.c
@@ -149,7 +149,7 @@ void put_callchain_buffers(void)
 	}
 }
=20
-static struct perf_callchain_entry *get_callchain_entry(int *rctx)
+struct perf_callchain_entry *get_callchain_entry(int *rctx)
 {
 	int cpu;
 	struct callchain_cpus_entries *entries;
@@ -168,7 +168,7 @@ static struct perf_callchain_entry *get_callchain_ent=
ry(int *rctx)
 		(*rctx * perf_callchain_entry__sizeof()));
 }
=20
-static void
+void
 put_callchain_entry(int rctx)
 {
 	put_recursion_context(this_cpu_ptr(callchain_recursion), rctx);
--=20
2.24.1


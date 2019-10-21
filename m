Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 48AABDE29B
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 05:39:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727025AbfJUDjS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Oct 2019 23:39:18 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:47506 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726835AbfJUDjR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Oct 2019 23:39:17 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x9L3Te3A006554
        for <netdev@vger.kernel.org>; Sun, 20 Oct 2019 20:39:16 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=gi/f2wMVo+ikdzN54dfo6bogi2CxnfqL8nt4gvC1wvU=;
 b=e15isOjJwB35E0CN3CD84K11wMBuKhTDoxrdO2DyqoQDQ3jXHhBGaGFjNVz7r61sAhg6
 TijmrwKQy8spXgrnfrB1TUB9BFNbZ0MEjvRpbtaeB2DKhNAURPN4R906DhCbMwPgP904
 jppQIsYfvVRKBknNIAXowgzvD4XplMtykS4= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2vr0ah4wjw-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Sun, 20 Oct 2019 20:39:16 -0700
Received: from 2401:db00:12:909f:face:0:3:0 (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Sun, 20 Oct 2019 20:39:13 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id 0D976861976; Sun, 20 Oct 2019 20:39:12 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH bpf-next 3/7] libbpf: add uprobe/uretprobe and tp/raw_tp section suffixes
Date:   Sun, 20 Oct 2019 20:38:58 -0700
Message-ID: <20191021033902.3856966-4-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191021033902.3856966-1-andriin@fb.com>
References: <20191021033902.3856966-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-21_01:2019-10-18,2019-10-21 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0
 mlxlogscore=999 impostorscore=0 suspectscore=8 bulkscore=0 malwarescore=0
 spamscore=0 mlxscore=0 priorityscore=1501 adultscore=0 clxscore=1015
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1910210029
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Map uprobe/uretprobe into KPROBE program type. tp/raw_tp are just an
alias for more verbose tracepoint/raw_tracepoint, respectively.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/lib/bpf/libbpf.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 39163e68dc1e..bf0c94fe74ca 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -4552,11 +4552,15 @@ static const struct {
 } section_names[] = {
 	BPF_PROG_SEC("socket",			BPF_PROG_TYPE_SOCKET_FILTER),
 	BPF_PROG_SEC("kprobe/",			BPF_PROG_TYPE_KPROBE),
+	BPF_PROG_SEC("uprobe/",			BPF_PROG_TYPE_KPROBE),
 	BPF_PROG_SEC("kretprobe/",		BPF_PROG_TYPE_KPROBE),
+	BPF_PROG_SEC("uretprobe/",		BPF_PROG_TYPE_KPROBE),
 	BPF_PROG_SEC("classifier",		BPF_PROG_TYPE_SCHED_CLS),
 	BPF_PROG_SEC("action",			BPF_PROG_TYPE_SCHED_ACT),
 	BPF_PROG_SEC("tracepoint/",		BPF_PROG_TYPE_TRACEPOINT),
+	BPF_PROG_SEC("tp/",			BPF_PROG_TYPE_TRACEPOINT),
 	BPF_PROG_SEC("raw_tracepoint/",		BPF_PROG_TYPE_RAW_TRACEPOINT),
+	BPF_PROG_SEC("raw_tp/",			BPF_PROG_TYPE_RAW_TRACEPOINT),
 	BPF_PROG_BTF("tp_btf/",			BPF_PROG_TYPE_RAW_TRACEPOINT),
 	BPF_PROG_SEC("xdp",			BPF_PROG_TYPE_XDP),
 	BPF_PROG_SEC("perf_event",		BPF_PROG_TYPE_PERF_EVENT),
-- 
2.17.1


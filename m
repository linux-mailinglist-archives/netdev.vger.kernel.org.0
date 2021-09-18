Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BE5C4102CE
	for <lists+netdev@lfdr.de>; Sat, 18 Sep 2021 03:56:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238138AbhIRB53 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Sep 2021 21:57:29 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:16273 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236829AbhIRB50 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Sep 2021 21:57:26 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4HBDRZ2mrVz8tFj;
        Sat, 18 Sep 2021 09:55:22 +0800 (CST)
Received: from dggpeml500025.china.huawei.com (7.185.36.35) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Sat, 18 Sep 2021 09:55:57 +0800
Received: from huawei.com (10.175.124.27) by dggpeml500025.china.huawei.com
 (7.185.36.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.8; Sat, 18 Sep
 2021 09:55:56 +0800
From:   Hou Tao <houtao1@huawei.com>
To:     Alexei Starovoitov <ast@kernel.org>, Yonghong Song <yhs@fb.com>
CC:     Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <houtao1@huawei.com>
Subject: [PATCH bpf-next v2 2/3] libbpf: support detecting and attaching of writable tracepoint program
Date:   Sat, 18 Sep 2021 10:09:57 +0800
Message-ID: <20210918020958.1167652-3-houtao1@huawei.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210918020958.1167652-1-houtao1@huawei.com>
References: <20210918020958.1167652-1-houtao1@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.124.27]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpeml500025.china.huawei.com (7.185.36.35)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Program on writable tracepoint is BPF_PROG_TYPE_RAW_TRACEPOINT_WRITABLE,
but its attachment is the same as BPF_PROG_TYPE_RAW_TRACEPOINT.

Signed-off-by: Hou Tao <houtao1@huawei.com>
---
 tools/lib/bpf/libbpf.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index da65a1666a5e..981fcdd95bdc 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -7976,6 +7976,10 @@ static const struct bpf_sec_def section_defs[] = {
 		.attach_fn = attach_raw_tp),
 	SEC_DEF("raw_tp/", RAW_TRACEPOINT,
 		.attach_fn = attach_raw_tp),
+	SEC_DEF("raw_tracepoint_writable/", RAW_TRACEPOINT_WRITABLE,
+		.attach_fn = attach_raw_tp),
+	SEC_DEF("raw_tp_writable/", RAW_TRACEPOINT_WRITABLE,
+		.attach_fn = attach_raw_tp),
 	SEC_DEF("tp_btf/", TRACING,
 		.expected_attach_type = BPF_TRACE_RAW_TP,
 		.is_attach_btf = true,
-- 
2.29.2


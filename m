Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D4F04A333D
	for <lists+netdev@lfdr.de>; Sun, 30 Jan 2022 03:16:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353766AbiA3CQv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Jan 2022 21:16:51 -0500
Received: from szxga01-in.huawei.com ([45.249.212.187]:16934 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353761AbiA3CQt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Jan 2022 21:16:49 -0500
Received: from canpemm500010.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4JmZTq5ZHRzZfNw;
        Sun, 30 Jan 2022 10:12:47 +0800 (CST)
Received: from k03.huawei.com (10.67.174.111) by
 canpemm500010.china.huawei.com (7.192.105.118) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Sun, 30 Jan 2022 10:16:47 +0800
From:   He Fengqing <hefengqing@huawei.com>
To:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <ast@kernel.org>, <daniel@iogearbox.net>, <andrii@kernel.org>,
        <kafai@fb.com>, <songliubraving@fb.com>, <yhs@fb.com>,
        <john.fastabend@gmail.com>
Subject: [bpf-next] bpf: Add CAP_NET_ADMIN for sk_lookup program type
Date:   Sun, 30 Jan 2022 03:03:52 +0000
Message-ID: <20220130030352.2710479-1-hefengqing@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.174.111]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 canpemm500010.china.huawei.com (7.192.105.118)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SK_LOOKUP program type was introduced in commit e9ddbb7707ff
("bpf: Introduce SK_LOOKUP program type with a dedicated attach point"),
but the commit did not add SK_LOOKUP program type in net admin prog type.
I think SK_LOOKUP program type should need CAP_NET_ADMIN, so add SK_LOOKUP
program type in net_admin_prog_type.

Fixes: e9ddbb7707ff ("bpf: Introduce SK_LOOKUP program type with a dedicated attach point")

Signed-off-by: He Fengqing <hefengqing@huawei.com>
---
 kernel/bpf/syscall.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 9befb1123770..2a8a4a5266fb 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -2163,6 +2163,7 @@ static bool is_net_admin_prog_type(enum bpf_prog_type prog_type)
 	case BPF_PROG_TYPE_SK_MSG:
 	case BPF_PROG_TYPE_LIRC_MODE2:
 	case BPF_PROG_TYPE_FLOW_DISSECTOR:
+	case BPF_PROG_TYPE_SK_LOOKUP:
 	case BPF_PROG_TYPE_CGROUP_DEVICE:
 	case BPF_PROG_TYPE_CGROUP_SOCK:
 	case BPF_PROG_TYPE_CGROUP_SOCK_ADDR:
-- 
2.25.1


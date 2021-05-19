Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F2AB3887B4
	for <lists+netdev@lfdr.de>; Wed, 19 May 2021 08:40:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231760AbhESGmH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 02:42:07 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:4675 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230154AbhESGmG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 May 2021 02:42:06 -0400
Received: from dggems704-chm.china.huawei.com (unknown [172.30.72.60])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4FlNTz3gG6z1BNss;
        Wed, 19 May 2021 14:37:59 +0800 (CST)
Received: from dggpemm500019.china.huawei.com (7.185.36.180) by
 dggems704-chm.china.huawei.com (10.3.19.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 19 May 2021 14:40:45 +0800
Received: from ubuntu1804.huawei.com (10.67.174.98) by
 dggpemm500019.china.huawei.com (7.185.36.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 19 May 2021 14:40:45 +0800
From:   Pu Lehui <pulehui@huawei.com>
To:     <ast@kernel.org>, <daniel@iogearbox.net>, <andrii@kernel.org>,
        <kafai@fb.com>, <songliubraving@fb.com>, <yhs@fb.com>,
        <john.fastabend@gmail.com>, <kpsingh@kernel.org>
CC:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <pulehui@huawei.com>
Subject: [PATCH bpf-next] bpf: Make some symbols static
Date:   Wed, 19 May 2021 14:41:16 +0800
Message-ID: <20210519064116.240536-1-pulehui@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.174.98]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpemm500019.china.huawei.com (7.185.36.180)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The sparse tool complains as follows:

kernel/bpf/syscall.c:4567:29: warning:
 symbol 'bpf_sys_bpf_proto' was not declared. Should it be static?
kernel/bpf/syscall.c:4592:29: warning:
 symbol 'bpf_sys_close_proto' was not declared. Should it be static?

This symbol is not used outside of syscall.c, so marks it static.

Signed-off-by: Pu Lehui <pulehui@huawei.com>
---
 kernel/bpf/syscall.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 2361d97e2c67..73d15bc62d8c 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -4564,7 +4564,7 @@ BPF_CALL_3(bpf_sys_bpf, int, cmd, void *, attr, u32, attr_size)
 	return __sys_bpf(cmd, KERNEL_BPFPTR(attr), attr_size);
 }
 
-const struct bpf_func_proto bpf_sys_bpf_proto = {
+static const struct bpf_func_proto bpf_sys_bpf_proto = {
 	.func		= bpf_sys_bpf,
 	.gpl_only	= false,
 	.ret_type	= RET_INTEGER,
@@ -4589,7 +4589,7 @@ BPF_CALL_1(bpf_sys_close, u32, fd)
 	return close_fd(fd);
 }
 
-const struct bpf_func_proto bpf_sys_close_proto = {
+static const struct bpf_func_proto bpf_sys_close_proto = {
 	.func		= bpf_sys_close,
 	.gpl_only	= false,
 	.ret_type	= RET_INTEGER,
-- 
2.17.1


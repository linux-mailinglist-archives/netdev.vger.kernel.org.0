Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 467F31A65F7
	for <lists+netdev@lfdr.de>; Mon, 13 Apr 2020 13:53:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729233AbgDMLvu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Apr 2020 07:51:50 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:60498 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729178AbgDMLvu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Apr 2020 07:51:50 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 79E6F4CF4FE89C54BBF1;
        Mon, 13 Apr 2020 19:51:47 +0800 (CST)
Received: from linux-lmwb.huawei.com (10.175.103.112) by
 DGGEMS411-HUB.china.huawei.com (10.3.19.211) with Microsoft SMTP Server id
 14.3.487.0; Mon, 13 Apr 2020 19:51:41 +0800
From:   Zou Wei <zou_wei@huawei.com>
To:     <ast@kernel.org>, <daniel@iogearbox.net>, <kafai@fb.com>,
        <songliubraving@fb.com>, <yhs@fb.com>, <andriin@fb.com>,
        <john.fastabend@gmail.com>, <kpsingh@chromium.org>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     Zou Wei <zou_wei@huawei.com>
Subject: [PATCH-next] bpf: Verifier, remove unneeded conversion to bool
Date:   Mon, 13 Apr 2020 19:57:56 +0800
Message-ID: <1586779076-101346-1-git-send-email-zou_wei@huawei.com>
X-Mailer: git-send-email 2.6.2
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.103.112]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This issue was detected by using the Coccinelle software:

kernel/bpf/verifier.c:1259:16-21: WARNING: conversion to bool not needed here

The conversion to bool is unneeded, remove it

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zou Wei <zou_wei@huawei.com>
---
 kernel/bpf/verifier.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 04c6630..38cfcf7 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -1255,8 +1255,7 @@ static void __mark_reg_unknown(const struct bpf_verifier_env *env,
 	reg->type = SCALAR_VALUE;
 	reg->var_off = tnum_unknown;
 	reg->frameno = 0;
-	reg->precise = env->subprog_cnt > 1 || !env->allow_ptr_leaks ?
-		       true : false;
+	reg->precise = env->subprog_cnt > 1 || !env->allow_ptr_leaks;
 	__mark_reg_unbounded(reg);
 }
 
-- 
2.6.2


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62616337367
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 14:07:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233327AbhCKNGw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 08:06:52 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:13908 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233252AbhCKNGi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Mar 2021 08:06:38 -0500
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4Dx8LP3y2PzkXdy;
        Thu, 11 Mar 2021 21:05:01 +0800 (CST)
Received: from localhost.localdomain (10.175.102.38) by
 DGGEMS409-HUB.china.huawei.com (10.3.19.209) with Microsoft SMTP Server id
 14.3.498.0; Thu, 11 Mar 2021 21:06:20 +0800
From:   'Wei Yongjun <weiyongjun1@huawei.com>
To:     <weiyongjun1@huawei.com>, Alexei Starovoitov <ast@kernel.org>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Christian Brauner <christian@brauner.io>,
        Song Liu <songliubraving@fb.com>
CC:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <kernel-janitors@vger.kernel.org>, Hulk Robot <hulkci@huawei.com>
Subject: [PATCH bpf-next] bpf: Make symbol 'bpf_task_storage_busy' static
Date:   Thu, 11 Mar 2021 13:15:05 +0000
Message-ID: <20210311131505.1901509-1-weiyongjun1@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type:   text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Originating-IP: [10.175.102.38]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wei Yongjun <weiyongjun1@huawei.com>

The sparse tool complains as follows:

kernel/bpf/bpf_task_storage.c:23:1: warning:
 symbol '__pcpu_scope_bpf_task_storage_busy' was not declared. Should it be static?

This symbol is not used outside of bpf_task_storage.c, so this
commit marks it static.

Fixes: bc235cdb423a ("bpf: Prevent deadlock from recursive bpf_task_storage_[get|delete]")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
---
 kernel/bpf/bpf_task_storage.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/bpf/bpf_task_storage.c b/kernel/bpf/bpf_task_storage.c
index fd3c74ef608e..3ce75758d394 100644
--- a/kernel/bpf/bpf_task_storage.c
+++ b/kernel/bpf/bpf_task_storage.c
@@ -20,7 +20,7 @@
 
 DEFINE_BPF_STORAGE_CACHE(task_cache);
 
-DEFINE_PER_CPU(int, bpf_task_storage_busy);
+static DEFINE_PER_CPU(int, bpf_task_storage_busy);
 
 static void bpf_task_storage_lock(void)
 {


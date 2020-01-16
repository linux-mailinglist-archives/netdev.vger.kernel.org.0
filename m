Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 846C314017F
	for <lists+netdev@lfdr.de>; Fri, 17 Jan 2020 02:38:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388438AbgAQBiX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 20:38:23 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:9180 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730720AbgAQBiX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 20:38:23 -0500
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 7529E2450DA21B6F08DA;
        Fri, 17 Jan 2020 09:38:20 +0800 (CST)
Received: from localhost (10.133.213.239) by DGGEMS413-HUB.china.huawei.com
 (10.3.19.213) with Microsoft SMTP Server id 14.3.439.0; Fri, 17 Jan 2020
 09:38:12 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <ast@kernel.org>, <daniel@iogearbox.net>, <kafai@fb.com>,
        <songliubraving@fb.com>, <yhs@fb.com>, <andriin@fb.com>,
        <brianvv@google.com>
CC:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH bpf-next] bpf: Remove set but not used variable 'first_key'
Date:   Thu, 16 Jan 2020 22:53:00 +0800
Message-ID: <20200116145300.59056-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.133.213.239]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

kernel/bpf/syscall.c: In function generic_map_lookup_batch:
kernel/bpf/syscall.c:1339:7: warning: variable first_key set but not used [-Wunused-but-set-variable]

It is never used, so remove it.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 kernel/bpf/syscall.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 0d94d36..c26a714 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -1336,7 +1336,6 @@ int generic_map_lookup_batch(struct bpf_map *map,
 	void *buf, *buf_prevkey, *prev_key, *key, *value;
 	int err, retry = MAP_LOOKUP_RETRIES;
 	u32 value_size, cp, max_count;
-	bool first_key = false;
 
 	if (attr->batch.elem_flags & ~BPF_F_LOCK)
 		return -EINVAL;
@@ -1365,7 +1364,6 @@ int generic_map_lookup_batch(struct bpf_map *map,
 	}
 
 	err = -EFAULT;
-	first_key = false;
 	prev_key = NULL;
 	if (ubatch && copy_from_user(buf_prevkey, ubatch, map->key_size))
 		goto free_buf;
-- 
2.7.4



Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88A891B3A10
	for <lists+netdev@lfdr.de>; Wed, 22 Apr 2020 10:29:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726532AbgDVI2z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 04:28:55 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:57568 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726396AbgDVI2t (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Apr 2020 04:28:49 -0400
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 05290F7D3C5C81FB0C00;
        Wed, 22 Apr 2020 16:28:46 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS413-HUB.china.huawei.com (10.3.19.213) with Microsoft SMTP Server id
 14.3.487.0; Wed, 22 Apr 2020 16:28:41 +0800
From:   Mao Wenan <maowenan@huawei.com>
To:     <ast@kernel.org>, <daniel@iogearbox.net>, <kafai@fb.com>,
        <songliubraving@fb.com>, <yhs@fb.com>, <andriin@fb.com>,
        <john.fastabend@gmail.com>, <kpsingh@chromium.org>
CC:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <kernel-janitors@vger.kernel.org>
Subject: [PATCH bpf-next 2/2] libbpf: Return err if bpf_object__load failed
Date:   Wed, 22 Apr 2020 16:30:10 +0800
Message-ID: <20200422083010.28000-3-maowenan@huawei.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200422083010.28000-1-maowenan@huawei.com>
References: <20200422083010.28000-1-maowenan@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.113.25]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

bpf_object__load() has various return code, when
it failed to load object, it must return err instead
of return -EINVAL.

Signed-off-by: Mao Wenan <maowenan@huawei.com>
---
 tools/lib/bpf/libbpf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 8f480e29a6b0..8e1dc6980fac 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -7006,7 +7006,7 @@ int bpf_prog_load_xattr(const struct bpf_prog_load_attr *attr,
 	err = bpf_object__load(obj);
 	if (err) {
 		bpf_object__close(obj);
-		return -EINVAL;
+		return err;
 	}
 
 	*pobj = obj;
-- 
2.20.1


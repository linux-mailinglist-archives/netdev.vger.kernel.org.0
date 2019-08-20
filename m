Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE8C49536D
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 03:33:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728872AbfHTBdL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Aug 2019 21:33:11 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:4731 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728627AbfHTBdL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Aug 2019 21:33:11 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id EF227A58CA1FC4ADCFA3;
        Tue, 20 Aug 2019 09:33:03 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS411-HUB.china.huawei.com (10.3.19.211) with Microsoft SMTP Server id
 14.3.439.0; Tue, 20 Aug 2019 09:32:56 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <bjorn.topel@intel.com>, <magnus.karlsson@intel.com>,
        <jonathan.lemon@gmail.com>, <ast@kernel.org>,
        <daniel@iogearbox.net>, <kafai@fb.com>, <songliubraving@fb.com>,
        <yhs@fb.com>, <john.fastabend@gmail.com>
CC:     YueHaibing <yuehaibing@huawei.com>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <kernel-janitors@vger.kernel.org>
Subject: [PATCH -next] bpf: Use PTR_ERR_OR_ZERO in xsk_map_inc()
Date:   Tue, 20 Aug 2019 01:36:52 +0000
Message-ID: <20190820013652.147041-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type:   text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Originating-IP: [10.175.113.25]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use PTR_ERR_OR_ZERO rather than if(IS_ERR(...)) + PTR_ERR

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 kernel/bpf/xskmap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/bpf/xskmap.c b/kernel/bpf/xskmap.c
index 4cc28e226398..942c662e2eed 100644
--- a/kernel/bpf/xskmap.c
+++ b/kernel/bpf/xskmap.c
@@ -21,7 +21,7 @@ int xsk_map_inc(struct xsk_map *map)
 	struct bpf_map *m = &map->map;
 
 	m = bpf_map_inc(m, false);
-	return IS_ERR(m) ? PTR_ERR(m) : 0;
+	return PTR_ERR_OR_ZERO(m);
 }
 
 void xsk_map_put(struct xsk_map *map)




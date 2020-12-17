Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E6BE2DCE6E
	for <lists+netdev@lfdr.de>; Thu, 17 Dec 2020 10:33:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726580AbgLQJc2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Dec 2020 04:32:28 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:9900 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726155AbgLQJc0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Dec 2020 04:32:26 -0500
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4CxRZK57hgz7Fwt;
        Thu, 17 Dec 2020 17:31:05 +0800 (CST)
Received: from huawei.com (10.44.142.101) by DGGEMS411-HUB.china.huawei.com
 (10.3.19.211) with Microsoft SMTP Server id 14.3.498.0; Thu, 17 Dec 2020
 17:31:36 +0800
From:   Zhuling <zhuling8@huawei.com>
To:     <ast@kernel.org>, <daniel@iogearbox.net>, <andrii@kernel.org>,
        <kafai@fb.com>, <songliubraving@fb.com>, <yhs@fb.com>,
        <john.fastabend@gmail.com>, <kpsingh@kernel.org>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>
CC:     <luanjianhai@huawei.com>, <luchunhua@huawei.com>,
        <zhuling8@huawei.com>
Subject: [PATCH] Modify hardcode to SECCOMP_MODE_FILTER
Date:   Thu, 17 Dec 2020 16:46:32 +0800
Message-ID: <20201217084632.67251-1-zhuling8@huawei.com>
X-Mailer: git-send-email 2.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.44.142.101]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: zhuling <zhuling8@huawei.com>

    bpf/seccomp: modify hardcode 2 to SECCOMP_MODE_FILTER

    while the hardcode 2 has been define in seccomp_bpf.c, we should use
the definitions(SECCOMP_MODE_FILTER) instead of hardcode 2.

Signed-off-by: zhuling <zhuling8@huawei.com>
---
 samples/bpf/tracex5_user.c | 2 +-
 samples/seccomp/dropper.c  | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/samples/bpf/tracex5_user.c b/samples/bpf/tracex5_user.c
index c17d3fb..417753f 100644
--- a/samples/bpf/tracex5_user.c
+++ b/samples/bpf/tracex5_user.c
@@ -28,7 +28,7 @@ static void install_accept_all_seccomp(void)
 		.len = (unsigned short)(sizeof(filter)/sizeof(filter[0])),
 		.filter = filter,
 	};
-	if (prctl(PR_SET_SECCOMP, 2, &prog))
+	if (prctl(PR_SET_SECCOMP, SECCOMP_MODE_FILTER, &prog))
 		perror("prctl");
 }

diff --git a/samples/seccomp/dropper.c b/samples/seccomp/dropper.c
index cc0648e..08f8e7f 100644
--- a/samples/seccomp/dropper.c
+++ b/samples/seccomp/dropper.c
@@ -46,7 +46,7 @@ static int install_filter(int nr, int arch, int error)
 		perror("prctl(NO_NEW_PRIVS)");
 		return 1;
 	}
-	if (prctl(PR_SET_SECCOMP, 2, &prog)) {
+	if (prctl(PR_SET_SECCOMP, SECCOMP_MODE_FILTER, &prog)) {
 		perror("prctl(PR_SET_SECCOMP)");
 		return 1;
 	}
--
2.9.5


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 342BF48248C
	for <lists+netdev@lfdr.de>; Fri, 31 Dec 2021 16:20:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230193AbhLaPUh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Dec 2021 10:20:37 -0500
Received: from szxga02-in.huawei.com ([45.249.212.188]:29320 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbhLaPUh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Dec 2021 10:20:37 -0500
Received: from dggpeml500025.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4JQTN41K00zbjMg;
        Fri, 31 Dec 2021 23:20:04 +0800 (CST)
Received: from huawei.com (10.175.124.27) by dggpeml500025.china.huawei.com
 (7.185.36.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.20; Fri, 31 Dec
 2021 23:20:34 +0800
From:   Hou Tao <houtao1@huawei.com>
To:     Alexei Starovoitov <ast@kernel.org>
CC:     Martin KaFai Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <houtao1@huawei.com>
Subject: [PATCH bpf-next] bpf: support bpf_jit_enable=2 for CONFIG_BPF_JIT_ALWAYS_ON
Date:   Fri, 31 Dec 2021 23:35:50 +0800
Message-ID: <20211231153550.3807430-1-houtao1@huawei.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.124.27]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpeml500025.china.huawei.com (7.185.36.35)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

bpf_jit_enable=2 is used to dump the jited images for debug purpose,
however if CONFIG_BPF_JIT_ALWAYS_ON is enabled, its value is fixed
as one and can not be changed. So make the debug switch work again.

Signed-off-by: Hou Tao <houtao1@huawei.com>
---
 net/core/sysctl_net_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/sysctl_net_core.c b/net/core/sysctl_net_core.c
index 7b4d485aac7a..20e44427afa8 100644
--- a/net/core/sysctl_net_core.c
+++ b/net/core/sysctl_net_core.c
@@ -387,7 +387,7 @@ static struct ctl_table net_core_table[] = {
 		.proc_handler	= proc_dointvec_minmax_bpf_enable,
 # ifdef CONFIG_BPF_JIT_ALWAYS_ON
 		.extra1		= SYSCTL_ONE,
-		.extra2		= SYSCTL_ONE,
+		.extra2		= &two,
 # else
 		.extra1		= SYSCTL_ZERO,
 		.extra2		= &two,
-- 
2.27.0


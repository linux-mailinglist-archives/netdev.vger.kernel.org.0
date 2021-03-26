Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3554A34A775
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 13:41:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230093AbhCZMlH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Mar 2021 08:41:07 -0400
Received: from foss.arm.com ([217.140.110.172]:58694 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229744AbhCZMks (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Mar 2021 08:40:48 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 19461143D;
        Fri, 26 Mar 2021 05:40:48 -0700 (PDT)
Received: from net-arm-thunderx2-02.shanghai.arm.com (net-arm-thunderx2-02.shanghai.arm.com [10.169.208.215])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 95E803F7D7;
        Fri, 26 Mar 2021 05:40:41 -0700 (PDT)
From:   Jianlin Lv <Jianlin.Lv@arm.com>
To:     bpf@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, viro@zeniv.linux.org.uk, rdna@fb.com,
        dvyukov@google.com, nicolas.dichtel@6wind.com,
        keescook@chromium.org, masahiroy@kernel.org, maheshb@google.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Jianlin.Lv@arm.com, iecedge@gmail.com, nd@arm.com
Subject: [PATCH bpf-next] bpf: trace jit code when enable BPF_JIT_ALWAYS_ON
Date:   Fri, 26 Mar 2021 20:40:30 +0800
Message-Id: <20210326124030.1138964-1-Jianlin.Lv@arm.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When CONFIG_BPF_JIT_ALWAYS_ON is enabled, the value of bpf_jit_enable in
/proc/sys is limited to SYSCTL_ONE. This is not convenient for debugging.
This patch modifies the value of extra2 (max) to 2 that support developers
to emit traces on kernel log.

Signed-off-by: Jianlin Lv <Jianlin.Lv@arm.com>
---
 net/core/sysctl_net_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/sysctl_net_core.c b/net/core/sysctl_net_core.c
index d84c8a1b280e..aa16883ac445 100644
--- a/net/core/sysctl_net_core.c
+++ b/net/core/sysctl_net_core.c
@@ -386,7 +386,7 @@ static struct ctl_table net_core_table[] = {
 		.proc_handler	= proc_dointvec_minmax_bpf_enable,
 # ifdef CONFIG_BPF_JIT_ALWAYS_ON
 		.extra1		= SYSCTL_ONE,
-		.extra2		= SYSCTL_ONE,
+		.extra2		= &two,
 # else
 		.extra1		= SYSCTL_ZERO,
 		.extra2		= &two,
-- 
2.25.1


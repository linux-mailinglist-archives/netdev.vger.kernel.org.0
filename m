Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2D744D7117
	for <lists+netdev@lfdr.de>; Sat, 12 Mar 2022 22:48:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232792AbiCLVqT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Mar 2022 16:46:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232786AbiCLVqR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Mar 2022 16:46:17 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7134E4738C
        for <netdev@vger.kernel.org>; Sat, 12 Mar 2022 13:45:11 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id mg21-20020a17090b371500b001bef9e4657cso14147308pjb.0
        for <netdev@vger.kernel.org>; Sat, 12 Mar 2022 13:45:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=n4TdA0gI45Xj2K7cbGIisTENSr0kI8/Q/IOoENBXZ+U=;
        b=SQ0I8H66lDEAJ5Fn+aBHX2jFmxn+HWhTyZPJM9VS3toIjepFpNofZSjcwzqrm+lvOE
         0Ec0+qsqnJtxq+2Iq+TUd9L2UEi2DVSKKUu4JkmbGQ8kPsJmq9VIExRz2ZCpqeOahHAN
         5MSp+CK3O2Iszsp8s+fp+KOQTHT4aQLzzBmpRsTsRp8wj2iGbjjUfC4PJNgxw6JWEuYp
         sqP87yJ305yj9H9eqt5eUH22PR7TnShOrAYuJpUitX8407qc5/uZE+NvyDNZ05e4RvAb
         xoUsCA6HTr7cTa5MgJV4zTLelfGaKR/sZWF7biHh1n53TK2TU5AxD1GN1qWD7Xgnujdx
         dwXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=n4TdA0gI45Xj2K7cbGIisTENSr0kI8/Q/IOoENBXZ+U=;
        b=oBQgLDTpHrcjKF/T8cZb0rga1ae/vy2Pfgq6/um1j6ztMb7dffdD4w0FnfV/LKeCGv
         YbxdISujoe6SeE0QCj2w4k6aoIx9Zfu8b95SHMvfRnuRByxQbIFlBbCLtCQOwdw1MQZ9
         YzELrabxX0D0vjZLdlIRZK5ebIAO22c3f6xxUMA05EN+pPbiE/3FPkt8fPAPUMZBm4Io
         4ipZdM+ssC0o9Z9Lsud+JarTXL+N8WtCd47XntAlftjtSdaabRmVwxhIuYcUWZ7I6bba
         xfeoq2PhCjCnusWtZJtufsX19mQN1igGO3JOuynROmqBmkbBRe2aOhVsJwsobkX5vsnq
         wDYA==
X-Gm-Message-State: AOAM530lzu7zqOXq2yOvSVcd5zlBuAkXsyxkRnXLts23u4V/zQSB5GWl
        NIJct/gR9c30sMo3LhdsALmYr7O8K4k=
X-Google-Smtp-Source: ABdhPJy72PyaesuExpg6KU7juGJ8sd256y2E9l8vgOlrQFeZzSJWXeZi0HOZcxgSeb/hruHTWMyCWA==
X-Received: by 2002:a17:90b:1647:b0:1c3:b18c:793f with SMTP id il7-20020a17090b164700b001c3b18c793fmr10522647pjb.134.1647121510990;
        Sat, 12 Mar 2022 13:45:10 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:7661:178d:4650:697])
        by smtp.gmail.com with ESMTPSA id bh6-20020a056a00308600b004f6aa0367f6sm13033523pfb.118.2022.03.12.13.45.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 12 Mar 2022 13:45:10 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        jeffreyji <jeffreyji@google.com>,
        Brian Vazquez <brianvv@google.com>,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH net-next] net: disable preemption in dev_core_stats_XXX_inc() helpers
Date:   Sat, 12 Mar 2022 13:45:05 -0800
Message-Id: <20220312214505.3294762-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.35.1.723.g4982287a31-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

syzbot was kind enough to remind us that dev->{tx_dropped|rx_dropped}
could be increased in process context.

BUG: using smp_processor_id() in preemptible [00000000] code: syz-executor413/3593
caller is netdev_core_stats_alloc+0x98/0x110 net/core/dev.c:10298
CPU: 1 PID: 3593 Comm: syz-executor413 Not tainted 5.17.0-rc7-syzkaller-02426-g97aeb877de7f #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
 check_preemption_disabled+0x16b/0x170 lib/smp_processor_id.c:49
 netdev_core_stats_alloc+0x98/0x110 net/core/dev.c:10298
 dev_core_stats include/linux/netdevice.h:3855 [inline]
 dev_core_stats_rx_dropped_inc include/linux/netdevice.h:3866 [inline]
 tun_get_user+0x3455/0x3ab0 drivers/net/tun.c:1800
 tun_chr_write_iter+0xe1/0x200 drivers/net/tun.c:2015
 call_write_iter include/linux/fs.h:2074 [inline]
 new_sync_write+0x431/0x660 fs/read_write.c:503
 vfs_write+0x7cd/0xae0 fs/read_write.c:590
 ksys_write+0x12d/0x250 fs/read_write.c:643
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7f2cf4f887e3
Code: 5d 41 5c 41 5d 41 5e e9 9b fd ff ff 66 2e 0f 1f 84 00 00 00 00 00 90 64 8b 04 25 18 00 00 00 85 c0 75 14 b8 01 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 55 c3 0f 1f 40 00 48 83 ec 28 48 89 54 24 18
RSP: 002b:00007ffd50dd5fd8 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
RAX: ffffffffffffffda RBX: 00007ffd50dd6000 RCX: 00007f2cf4f887e3
RDX: 000000000000002a RSI: 0000000000000000 RDI: 00000000000000c8
RBP: 0000000000000003 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007ffd50dd5ff0 R14: 00007ffd50dd5fe8 R15: 00007ffd50dd5fe4
 </TASK>

Fixes: 625788b58445 ("net: add per-cpu storage and net->core_stats")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: jeffreyji <jeffreyji@google.com>
Cc: Brian Vazquez <brianvv@google.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
---
 include/linux/netdevice.h | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 0d994710b3352395b8c6d6fd53affb2fe0cea39f..8cbe96ce0a2cd9e4f02168835d460d1c91901430 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -3858,10 +3858,14 @@ static inline struct net_device_core_stats *dev_core_stats(struct net_device *de
 #define DEV_CORE_STATS_INC(FIELD)						\
 static inline void dev_core_stats_##FIELD##_inc(struct net_device *dev)		\
 {										\
-	struct net_device_core_stats *p = dev_core_stats(dev);			\
+	struct net_device_core_stats *p;					\
+										\
+	preempt_disable();							\
+	p = dev_core_stats(dev);						\
 										\
 	if (p)									\
 		local_inc(&p->FIELD);						\
+	preempt_enable();							\
 }
 DEV_CORE_STATS_INC(rx_dropped)
 DEV_CORE_STATS_INC(tx_dropped)
-- 
2.35.1.723.g4982287a31-goog


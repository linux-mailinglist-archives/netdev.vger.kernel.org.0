Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C361D6B929F
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 13:06:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231793AbjCNMFt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 08:05:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231816AbjCNMFf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 08:05:35 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2895622012;
        Tue, 14 Mar 2023 05:05:06 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id y4so31588914edo.2;
        Tue, 14 Mar 2023 05:05:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678795492; x=1681387492;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=cTftpNTZVaRtyzROGImOq5njKqLB79c0IbOQ0jc7OZE=;
        b=bkSJdLBz7cVc511o/xuK9q0iCPwVyJzD/yy+E4vPaG7xLZcIs6VBTKEgZMDLYqd9pb
         8uMLziz6xhZBcPEXUsM2AbHcajXOhSUnHUp8VAQMfTuAsZMYoQ/H05FrQSGmSbf0R89X
         Y5Q7fVX7zw0sFTmMZTV0mJSXLEYMqo/LOMXy1Oo6oX9fToRoNgQ9PHGtd/yDU2TBgMqY
         xjRDXhjfdDq9xDBn/vCNGUemX8CZ5RDTVAJfAabfNK0a0aqi85mUWTqRpM4LBW9508H4
         jJqVD8w13y1Y5piYMmGvahBKVBq2777BRJgoLfhc1rvzBl1tf1JtFAPHM7d8G20zlh0V
         YmHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678795492; x=1681387492;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cTftpNTZVaRtyzROGImOq5njKqLB79c0IbOQ0jc7OZE=;
        b=i1LcQ2HNUiicjMr9XGWeN93zoLit2XpUuI2AWmnDtgjcd9ceEuImxdZkpNOz7cQ3N4
         NjqNsDPa3ONCQy+x5sdLhJo3H5sAD6UgBKhAVlcruoFPEtmzbNQraPdtXeCLggDlO6/m
         kyB+I1HQHkOPh/BOGcLlX31j8kxFSsOKBxaaBaarOEm9IKeDKpexlFNmD4w/8UJD49Ab
         5ycwq2Ikf1T8mq4xES/5NX5nKaF/8/AUgRK/bYJRUL2bk6wB/bNaEbgvEDWYPAZN972q
         gIDD1NkaxmJe1dc4Zb+vZ7fl8D7UemKZhTAroF+EPzAtYJ1f758keb+OJptSw/+rppY2
         B4wg==
X-Gm-Message-State: AO0yUKWxmE0HOJPqoNHu5Zd988fG6rYQTO4I13Ymgc5JgMbLv9lsxmcO
        NDN4oA9FDBPp4ZG9jbQ9PBg=
X-Google-Smtp-Source: AK7set9QvZnwOEnmuy3C0UOsB4AV4xJCg0I48wZaTkn0lFYMCPscGqT65K9uTCwNO4HL/xHAfF/aqA==
X-Received: by 2002:a17:906:5181:b0:929:b101:937d with SMTP id y1-20020a170906518100b00929b101937dmr5432140ejk.1.1678795491757;
        Tue, 14 Mar 2023 05:04:51 -0700 (PDT)
Received: from ivan-HLYL-WXX9.. ([37.252.81.68])
        by smtp.gmail.com with ESMTPSA id gt16-20020a1709072d9000b008c327bef167sm1059839ejc.7.2023.03.14.05.04.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Mar 2023 05:04:51 -0700 (PDT)
From:   Ivan Orlov <ivan.orlov0322@gmail.com>
To:     socketcan@hartkopp.net, mkl@pengutronix.de, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com
Cc:     Ivan Orlov <ivan.orlov0322@gmail.com>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        himadrispandya@gmail.com, skhan@linuxfoundation.org,
        syzbot+c9bfd85eca611ebf5db1@syzkaller.appspotmail.com
Subject: [PATCH] FS, NET: Fix KMSAN uninit-value in vfs_write
Date:   Tue, 14 Mar 2023 16:04:45 +0400
Message-Id: <20230314120445.12407-1-ivan.orlov0322@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Syzkaller reported the following issue:

=====================================================
BUG: KMSAN: uninit-value in aio_rw_done fs/aio.c:1520 [inline]
BUG: KMSAN: uninit-value in aio_write+0x899/0x950 fs/aio.c:1600
 aio_rw_done fs/aio.c:1520 [inline]
 aio_write+0x899/0x950 fs/aio.c:1600
 io_submit_one+0x1d1c/0x3bf0 fs/aio.c:2019
 __do_sys_io_submit fs/aio.c:2078 [inline]
 __se_sys_io_submit+0x293/0x770 fs/aio.c:2048
 __x64_sys_io_submit+0x92/0xd0 fs/aio.c:2048
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x3d/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

Uninit was created at:
 slab_post_alloc_hook mm/slab.h:766 [inline]
 slab_alloc_node mm/slub.c:3452 [inline]
 __kmem_cache_alloc_node+0x71f/0xce0 mm/slub.c:3491
 __do_kmalloc_node mm/slab_common.c:967 [inline]
 __kmalloc+0x11d/0x3b0 mm/slab_common.c:981
 kmalloc_array include/linux/slab.h:636 [inline]
 bcm_tx_setup+0x80e/0x29d0 net/can/bcm.c:930
 bcm_sendmsg+0x3a2/0xce0 net/can/bcm.c:1351
 sock_sendmsg_nosec net/socket.c:714 [inline]
 sock_sendmsg net/socket.c:734 [inline]
 sock_write_iter+0x495/0x5e0 net/socket.c:1108
 call_write_iter include/linux/fs.h:2189 [inline]
 aio_write+0x63a/0x950 fs/aio.c:1600
 io_submit_one+0x1d1c/0x3bf0 fs/aio.c:2019
 __do_sys_io_submit fs/aio.c:2078 [inline]
 __se_sys_io_submit+0x293/0x770 fs/aio.c:2048
 __x64_sys_io_submit+0x92/0xd0 fs/aio.c:2048
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x3d/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

CPU: 1 PID: 5034 Comm: syz-executor350 Not tainted 6.2.0-rc6-syzkaller-80422-geda666ff2276 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/12/2023
=====================================================

We can follow the call chain and find that 'bcm_tx_setup' function calls 'memcpy_from_msg'
to copy some content to the newly allocated frame of 'op->frames'. After that the 'len'
field of copied structure being compared with some constant value (64 or 8). However, if
'memcpy_from_msg' returns an error, we will compare some uninitialized memory. This triggers
'uninit-value' issue.

This patch will add 'memcpy_from_msg' possible errors processing to avoid uninit-value
issue.

Tested via syzkaller

Reported-by: syzbot+c9bfd85eca611ebf5db1@syzkaller.appspotmail.com
Link: https://syzkaller.appspot.com/bug?id=47f897f8ad958bbde5790ebf389b5e7e0a345089
Signed-off-by: Ivan Orlov <ivan.orlov0322@gmail.com>
---
 net/can/bcm.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/net/can/bcm.c b/net/can/bcm.c
index 27706f6ace34..a962ec2b8ba5 100644
--- a/net/can/bcm.c
+++ b/net/can/bcm.c
@@ -941,6 +941,8 @@ static int bcm_tx_setup(struct bcm_msg_head *msg_head, struct msghdr *msg,
 
 			cf = op->frames + op->cfsiz * i;
 			err = memcpy_from_msg((u8 *)cf, msg, op->cfsiz);
+			if (err < 0)
+				goto free_op;
 
 			if (op->flags & CAN_FD_FRAME) {
 				if (cf->len > 64)
@@ -950,12 +952,8 @@ static int bcm_tx_setup(struct bcm_msg_head *msg_head, struct msghdr *msg,
 					err = -EINVAL;
 			}
 
-			if (err < 0) {
-				if (op->frames != &op->sframe)
-					kfree(op->frames);
-				kfree(op);
-				return err;
-			}
+			if (err < 0)
+				goto free_op;
 
 			if (msg_head->flags & TX_CP_CAN_ID) {
 				/* copy can_id into frame */
@@ -1026,6 +1024,12 @@ static int bcm_tx_setup(struct bcm_msg_head *msg_head, struct msghdr *msg,
 		bcm_tx_start_timer(op);
 
 	return msg_head->nframes * op->cfsiz + MHSIZ;
+
+free_op:
+	if (op->frames != &op->sframe)
+		kfree(op->frames);
+	kfree(op);
+	return err;
 }
 
 /*
-- 
2.34.1


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90AFF4D3DE9
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 01:12:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238925AbiCJAND (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 19:13:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238468AbiCJAMt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 19:12:49 -0500
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD070FDFB2
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 16:11:49 -0800 (PST)
Received: by mail-pf1-x42b.google.com with SMTP id f8so3656252pfj.5
        for <netdev@vger.kernel.org>; Wed, 09 Mar 2022 16:11:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GUtS9jPPcxoYaWRVMAl4laJhVfjAuJUE53nGLurHfyA=;
        b=QuWpZHIOZUYU/hqQQnYZifIcmDGOztxIn556B9CHPp4jphoS9wYcdN6/3OEI8roCcz
         O/RNhUQ/dh1mjIQlnB6VMLZlPyftuu5NH1IErY8Wi7F1MSF7BAj4ZXxtEFS3VisF3toL
         a1zcGDdmjAPbmKSvAaryjrvpN7r2YHbcovmCsQt1WaKwI2pSPz5oljs2+GHKBsS71884
         ZIiA8pjNVKci0okELMikt0DSYiJgJGkevSqCCZHxEdkPECiXAIVlz8gzk35TpJWPNMXL
         lbDhkEFSrwwl+ejGJAgkF6RtPvJ7GvLZTBTa/MSKnJV+P43mwSiqupmfh0qLqrY0inUt
         xiSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GUtS9jPPcxoYaWRVMAl4laJhVfjAuJUE53nGLurHfyA=;
        b=UEyYCeVT0OxmkoaUxHzsW6KUWb52cqvjZBrcckkH2a8l1ORUrFUBQIhoYNtCeQcpOo
         jBUey9vSeHvpm1wlFyXFWkeubgErvpUCLSoHxig8dnU6CJsw4cFrMh8/OrLpCGL/GqOE
         4HHFqXq/nEF1jGQuGGVTJtgk9L6pL4RifdxNe4WNNFuR9wNpP+mbmbknUb6IXdbM4Jvd
         uZQn/64RcClbDc2FrDVfElKV5HeW2X8yYUyz9vfN0xZLyoBLfkvobOtmokDSM+yuS07U
         atjTc2nHatKibci9vJZfAGn8pcoXHRzM9R0L4ByHGO3jp/3bDWNFdS26y0wkaaIDahZP
         Fs0A==
X-Gm-Message-State: AOAM530PHa2USEZw3RJrQyDwfAzqHSS946NJ2OHVJdoTaHAHoapimCkh
        YFeMiP6NuRY6CDf57Rv1Xos=
X-Google-Smtp-Source: ABdhPJyz9RAD0yoEgGncxMKc48cGUENAWh9tgpjmqJ3rlw1NZb/2Yw3CSbhv7DxuOPmkDQVKjMtm4g==
X-Received: by 2002:a63:8bc8:0:b0:380:b539:bea5 with SMTP id j191-20020a638bc8000000b00380b539bea5mr1791537pge.486.1646871109185;
        Wed, 09 Mar 2022 16:11:49 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:c6c7:6f77:9634:183c])
        by smtp.gmail.com with ESMTPSA id k22-20020aa788d6000000b004f73278d1aasm4420445pff.138.2022.03.09.16.11.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Mar 2022 16:11:48 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzkaller@googlegroups.com>,
        Xin Long <lucien.xin@gmail.com>,
        Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Subject: [PATCH net] sctp: fix kernel-infoleak for SCTP sockets
Date:   Wed,  9 Mar 2022 16:11:45 -0800
Message-Id: <20220310001145.297371-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.35.1.616.g0bdcbb4464-goog
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

syzbot reported a kernel infoleak [1] of 4 bytes.

After analysis, it turned out r->idiag_expires is not initialized
if inet_sctp_diag_fill() calls inet_diag_msg_common_fill()

Make sure to clear idiag_timer/idiag_retrans/idiag_expires
and let inet_diag_msg_sctpasoc_fill() fill them again if needed.

[1]

BUG: KMSAN: kernel-infoleak in instrument_copy_to_user include/linux/instrumented.h:121 [inline]
BUG: KMSAN: kernel-infoleak in copyout lib/iov_iter.c:154 [inline]
BUG: KMSAN: kernel-infoleak in _copy_to_iter+0x6ef/0x25a0 lib/iov_iter.c:668
 instrument_copy_to_user include/linux/instrumented.h:121 [inline]
 copyout lib/iov_iter.c:154 [inline]
 _copy_to_iter+0x6ef/0x25a0 lib/iov_iter.c:668
 copy_to_iter include/linux/uio.h:162 [inline]
 simple_copy_to_iter+0xf3/0x140 net/core/datagram.c:519
 __skb_datagram_iter+0x2d5/0x11b0 net/core/datagram.c:425
 skb_copy_datagram_iter+0xdc/0x270 net/core/datagram.c:533
 skb_copy_datagram_msg include/linux/skbuff.h:3696 [inline]
 netlink_recvmsg+0x669/0x1c80 net/netlink/af_netlink.c:1977
 sock_recvmsg_nosec net/socket.c:948 [inline]
 sock_recvmsg net/socket.c:966 [inline]
 __sys_recvfrom+0x795/0xa10 net/socket.c:2097
 __do_sys_recvfrom net/socket.c:2115 [inline]
 __se_sys_recvfrom net/socket.c:2111 [inline]
 __x64_sys_recvfrom+0x19d/0x210 net/socket.c:2111
 do_syscall_x64 arch/x86/entry/common.c:51 [inline]
 do_syscall_64+0x54/0xd0 arch/x86/entry/common.c:82
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Uninit was created at:
 slab_post_alloc_hook mm/slab.h:737 [inline]
 slab_alloc_node mm/slub.c:3247 [inline]
 __kmalloc_node_track_caller+0xe0c/0x1510 mm/slub.c:4975
 kmalloc_reserve net/core/skbuff.c:354 [inline]
 __alloc_skb+0x545/0xf90 net/core/skbuff.c:426
 alloc_skb include/linux/skbuff.h:1158 [inline]
 netlink_dump+0x3e5/0x16c0 net/netlink/af_netlink.c:2248
 __netlink_dump_start+0xcf8/0xe90 net/netlink/af_netlink.c:2373
 netlink_dump_start include/linux/netlink.h:254 [inline]
 inet_diag_handler_cmd+0x2e7/0x400 net/ipv4/inet_diag.c:1341
 sock_diag_rcv_msg+0x24a/0x620
 netlink_rcv_skb+0x40c/0x7e0 net/netlink/af_netlink.c:2494
 sock_diag_rcv+0x63/0x80 net/core/sock_diag.c:277
 netlink_unicast_kernel net/netlink/af_netlink.c:1317 [inline]
 netlink_unicast+0x1093/0x1360 net/netlink/af_netlink.c:1343
 netlink_sendmsg+0x14d9/0x1720 net/netlink/af_netlink.c:1919
 sock_sendmsg_nosec net/socket.c:705 [inline]
 sock_sendmsg net/socket.c:725 [inline]
 sock_write_iter+0x594/0x690 net/socket.c:1061
 do_iter_readv_writev+0xa7f/0xc70
 do_iter_write+0x52c/0x1500 fs/read_write.c:851
 vfs_writev fs/read_write.c:924 [inline]
 do_writev+0x645/0xe00 fs/read_write.c:967
 __do_sys_writev fs/read_write.c:1040 [inline]
 __se_sys_writev fs/read_write.c:1037 [inline]
 __x64_sys_writev+0xe5/0x120 fs/read_write.c:1037
 do_syscall_x64 arch/x86/entry/common.c:51 [inline]
 do_syscall_64+0x54/0xd0 arch/x86/entry/common.c:82
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Bytes 68-71 of 2508 are uninitialized
Memory access of size 2508 starts at ffff888114f9b000
Data copied to user address 00007f7fe09ff2e0

CPU: 1 PID: 3478 Comm: syz-executor306 Not tainted 5.17.0-rc4-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011

Fixes: 8f840e47f190 ("sctp: add the sctp_diag.c file")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Cc: Xin Long <lucien.xin@gmail.com>
Cc: Vlad Yasevich <vyasevich@gmail.com>
Cc: Neil Horman <nhorman@tuxdriver.com>
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
---
 net/sctp/diag.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/net/sctp/diag.c b/net/sctp/diag.c
index 034e2c74497df7f841d5d5b13b9695d291389089..d9c6d8f30f0935910a5c62a5a78c3813392b8231 100644
--- a/net/sctp/diag.c
+++ b/net/sctp/diag.c
@@ -61,10 +61,6 @@ static void inet_diag_msg_sctpasoc_fill(struct inet_diag_msg *r,
 		r->idiag_timer = SCTP_EVENT_TIMEOUT_T3_RTX;
 		r->idiag_retrans = asoc->rtx_data_chunks;
 		r->idiag_expires = jiffies_to_msecs(t3_rtx->expires - jiffies);
-	} else {
-		r->idiag_timer = 0;
-		r->idiag_retrans = 0;
-		r->idiag_expires = 0;
 	}
 }
 
@@ -144,13 +140,14 @@ static int inet_sctp_diag_fill(struct sock *sk, struct sctp_association *asoc,
 	r = nlmsg_data(nlh);
 	BUG_ON(!sk_fullsock(sk));
 
+	r->idiag_timer = 0;
+	r->idiag_retrans = 0;
+	r->idiag_expires = 0;
 	if (asoc) {
 		inet_diag_msg_sctpasoc_fill(r, sk, asoc);
 	} else {
 		inet_diag_msg_common_fill(r, sk);
 		r->idiag_state = sk->sk_state;
-		r->idiag_timer = 0;
-		r->idiag_retrans = 0;
 	}
 
 	if (inet_diag_msg_attrs_fill(sk, skb, r, ext, user_ns, net_admin))
-- 
2.35.1.616.g0bdcbb4464-goog


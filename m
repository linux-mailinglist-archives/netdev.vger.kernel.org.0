Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8DE7421B67
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 03:05:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230010AbhJEBHE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Oct 2021 21:07:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229549AbhJEBHD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Oct 2021 21:07:03 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C484EC061745
        for <netdev@vger.kernel.org>; Mon,  4 Oct 2021 18:05:13 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id on6so1952557pjb.5
        for <netdev@vger.kernel.org>; Mon, 04 Oct 2021 18:05:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zqidSq1+bKbcI5rRo9YGhm6lOT10LF6cVmMBEPHE9VU=;
        b=g6TLg8WGEICnvxA7kw0jJRU503zWyX9qiurgalhvKsfUvY6qHh3UHoYR0DGJ9vEquZ
         SVvjxqyUEkYVmVmxiyLkbLCEHoQLYO3XlPXQmDKgtlzjCoFJWUfEIeCTkknqOvFUdu6D
         ythsSHMZUZBHp7AEK3bNA5jJ7un2MPvXXbWkERlsCIXahFdlebugoQ5fdpTqtJ73Ro9D
         z6X+a6lbloIGnIeHzrS99vhb6xERVis5q+9Wkk6Eik2V/B5uSZAmp7YmCei1JOFFcJzn
         ZY3px9kdVIZmwZQlNuHjZ6eNHr+aOn79+KqjFN4HFwzPfdFbzozW0/Oshtis3XDJIGX0
         7HcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zqidSq1+bKbcI5rRo9YGhm6lOT10LF6cVmMBEPHE9VU=;
        b=AiU/j4fxGtAVuozZM7fib5PLoWqKXtMmNWuFY6iDfYXblbgcE5O7a/UfTHY8yyj2YG
         f/ZFT7ZBxrtop8lwOTh4O9Pwc9GIIOggKIJa82c3e9tvsqKfBM+VPaPA+ewqTqFAs+ru
         LL2i8rzI6suSd6bj25eyxzaSYVnMHyele7AgCKpITFhi+N0KVXckNJHdqwl85IZgydCp
         UK8dYhAW+OGGV3O0vqacqSl+X6zNPUfAiHNLaw2tnR7B1+OKdTZmb+/fCrcWvSNwNkqJ
         Bq62n5Uymdjal6C1eDzhqHMJXutHSK+qIIcndGCOHnCN/MGkt98015RG/Mdw/m+moeIS
         lhPw==
X-Gm-Message-State: AOAM5320B3d9Nx7MkEz4mp/AMYfeFloKsQ8wucA+E2SAlMvgc6edTGZZ
        mAZxo0z9EAxbuGzN8xNBCgo=
X-Google-Smtp-Source: ABdhPJzmYG8z+xIjBRw1HEyRx5jtNMJJlu0o7ZpVRkNy0U92h6IdAsbhOcaD5SlItAHEXJzPLFQvug==
X-Received: by 2002:a17:90b:3591:: with SMTP id mm17mr325613pjb.140.1633395913284;
        Mon, 04 Oct 2021 18:05:13 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:7236:cc97:8564:4e2a])
        by smtp.gmail.com with ESMTPSA id d67sm6509348pga.67.2021.10.04.18.05.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Oct 2021 18:05:12 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net 0/2] net: bridge: br_get_linkxstats_size() fixes
Date:   Mon,  4 Oct 2021 18:05:06 -0700
Message-Id: <20211005010508.2194560-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.33.0.800.g4c38ced690-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

This patch series attempts to fix the following syzbot report.

WARNING: CPU: 1 PID: 21425 at net/core/rtnetlink.c:5388 rtnl_stats_get+0x80f/0x8c0 net/core/rtnetlink.c:5388
Modules linked in:
CPU: 1 PID: 21425 Comm: syz-executor394 Not tainted 5.13.0-rc4-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:rtnl_stats_get+0x80f/0x8c0 net/core/rtnetlink.c:5388
Code: e9 9c fc ff ff 4c 89 e7 89 0c 24 e8 ab 8b a8 fa 8b 0c 24 e9 bc fc ff ff 4c 89 e7 e8 9b 8b a8 fa e9 df fe ff ff e8 61 85 63 fa <0f> 0b e9 f7 fc ff ff 41 be ea ff ff ff e9 f9 fc ff ff 41 be 97 ff
RSP: 0018:ffffc9000cf77688 EFLAGS: 00010293
RAX: 0000000000000000 RBX: 000000000000012c RCX: 0000000000000000
RDX: ffff8880211754c0 RSI: ffffffff8711571f RDI: 0000000000000003
RBP: ffff8880175aa780 R08: 00000000ffffffa6 R09: ffff88823bd5c04f
R10: ffffffff87115413 R11: 0000000000000001 R12: ffff8880175aab74
R13: ffff8880175aab40 R14: 00000000ffffffa6 R15: 0000000000000006
FS:  0000000001ff9300(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000005cfd58 CR3: 000000002cd43000 CR4: 00000000001506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 rtnetlink_rcv_msg+0x44e/0xad0 net/core/rtnetlink.c:5562
 netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2504
 netlink_unicast_kernel net/netlink/af_netlink.c:1314 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1340
 netlink_sendmsg+0x856/0xd90 net/netlink/af_netlink.c:1929
 sock_sendmsg_nosec net/socket.c:654 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:674
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2350
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2404
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2433
 do_syscall_64+0x3a/0xb0 arch/x86/entry/common.c:47
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x4440d9

Eric Dumazet (2):
  net: bridge: use nla_total_size_64bit() in br_get_linkxstats_size()
  net: bridge: fix under estimation in br_get_linkxstats_size()

 net/bridge/br_netlink.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

-- 
2.33.0.800.g4c38ced690-goog


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E0403F3864
	for <lists+netdev@lfdr.de>; Sat, 21 Aug 2021 05:51:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241010AbhHUDvs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Aug 2021 23:51:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232719AbhHUDvr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Aug 2021 23:51:47 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D89C5C061756
        for <netdev@vger.kernel.org>; Fri, 20 Aug 2021 20:51:08 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id u13-20020a17090abb0db0290177e1d9b3f7so15200393pjr.1
        for <netdev@vger.kernel.org>; Fri, 20 Aug 2021 20:51:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=mBt6S7Z+fo/h4SDQ9g4EpoFhaMYhFBfaXzFLbKkDFFQ=;
        b=tO2QV9wvNsiuWqC4JL7cH6snBg6jTkLYrKyx7fnRSirBqO0SPMnrBUCIPTWZuE0gJS
         KYj2N83GoWtw4M7Sui37mAjtsn1Tqb1oVNwqk0whc6jdELfthrSMuWW4jTg0wIBquuoH
         KgGtzcAsorH8J4WVFtP4kLgDn7R/qH4+//z+h7ZYDXdRS+Oy/M0Y/n55yhVwG1o4/U6Q
         lemNOJYfOXwexthMoTo5QVuebPm9MPAo1eUyYase5sU7Lq1VmV5jlmIC23FjSrf3UFZc
         3vyGfWtgZ/OSl9yeCcqTStzZzItf4gSofeZM9FgDTtkOstuwG1sBwi+cdhwbfx1rHVpP
         IHLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=mBt6S7Z+fo/h4SDQ9g4EpoFhaMYhFBfaXzFLbKkDFFQ=;
        b=B4UfFLaAN46IzEj18JFMDxMani4hpOKrOaJKfgvWRwVG90ZFAmChbM7JG5KP45TTZq
         Mrw1/Um/1LByMJn6ak/BDFgRucbMtxF1XVL+S1nizmAJAm+5wCiKAomyM2kB8Rmm4jx6
         4VnoNLxwSkPNGLWCnB9XTjNLRwHjngEObPqYlxyK3LCg9ike8iy/YoTQaY6xoez3TbYF
         cJHBjMq103bGkKrs6/ko03DWg+NOnZ65h51nKM0uo0XfpA9WZSw6VHT8MZSRz+fVgcmK
         R32KUoufkK6X80Kr8TMpJ59HXmNPbL4vLQLZuQYXfEeXWTbr+XcxOyXwsHH1o/u8t0mF
         uD0A==
X-Gm-Message-State: AOAM532EpTCdqIZzaWnf/o20u6V1e+hau76R8XQhV4l0ZvEuDoCEEJmi
        sAaO4I86NpbFUdLSvPb1Ln2tpm8k19rFNg==
X-Google-Smtp-Source: ABdhPJwyRMIhifdakZrNbsxXul0QzmRrEweAIfzCJ+TKDaxrCsEqVGtA/euOKri6VT9s929toqmHjQ==
X-Received: by 2002:a17:90b:1981:: with SMTP id mv1mr6237053pjb.45.1629517868192;
        Fri, 20 Aug 2021 20:51:08 -0700 (PDT)
Received: from ip-10-124-121-13.byted.org (ec2-54-241-92-238.us-west-1.compute.amazonaws.com. [54.241.92.238])
        by smtp.gmail.com with ESMTPSA id fa21sm12960927pjb.20.2021.08.20.20.51.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Aug 2021 20:51:07 -0700 (PDT)
From:   Jiang Wang <jiang.wang@bytedance.com>
To:     netdev@vger.kernel.org
Cc:     cong.wang@bytedance.com, duanxiongchun@bytedance.com,
        xieyongji@bytedance.com, chaiwen.cc@bytedance.com,
        Dmitry Osipenko <digetx@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Rao Shoaib <rao.shoaib@oracle.com>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v1] af_unix: fix NULL pointer bug in unix_shutdown
Date:   Sat, 21 Aug 2021 03:50:44 +0000
Message-Id: <20210821035045.373991-1-jiang.wang@bytedance.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 94531cfcbe79 ("af_unix: Add unix_stream_proto for sockmap") 
introduced a bug for af_unix SEQPACKET type. In unix_shutdown, the 
unhash function will call prot->unhash(), which is NULL for SEQPACKET. 
And kernel will panic. On ARM32, it will show following messages: (it 
likely affects x86 too).

Fix the bug by checking the sk->type first.

Kernel log:
<--- cut here ---
 Unable to handle kernel NULL pointer dereference at virtual address
00000000
 pgd = 2fba1ffb
 *pgd=00000000
 Internal error: Oops: 80000005 [#1] PREEMPT SMP THUMB2
 Modules linked in:
 CPU: 1 PID: 1999 Comm: falkon Tainted: G        W
5.14.0-rc5-01175-g94531cfcbe79-dirty #9240
 Hardware name: NVIDIA Tegra SoC (Flattened Device Tree)
 PC is at 0x0
 LR is at unix_shutdown+0x81/0x1a8
 pc : [<00000000>]    lr : [<c08f3311>]    psr: 600f0013
 sp : e45aff70  ip : e463a3c0  fp : beb54f04
 r10: 00000125  r9 : e45ae000  r8 : c4a56664
 r7 : 00000001  r6 : c4a56464  r5 : 00000001  r4 : c4a56400
 r3 : 00000000  r2 : c5a6b180  r1 : 00000000  r0 : c4a56400
 Flags: nZCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment none
 Control: 50c5387d  Table: 05aa804a  DAC: 00000051
 Register r0 information: slab PING start c4a56400 pointer offset 0
 Register r1 information: NULL pointer
 Register r2 information: slab task_struct start c5a6b180 pointer offset 0
 Register r3 information: NULL pointer
 Register r4 information: slab PING start c4a56400 pointer offset 0
 Register r5 information: non-paged memory
 Register r6 information: slab PING start c4a56400 pointer offset 100
 Register r7 information: non-paged memory
 Register r8 information: slab PING start c4a56400 pointer offset 612
 Register r9 information: non-slab/vmalloc memory
 Register r10 information: non-paged memory
 Register r11 information: non-paged memory
 Register r12 information: slab filp start e463a3c0 pointer offset 0
 Process falkon (pid: 1999, stack limit = 0x9ec48895)
 Stack: (0xe45aff70 to 0xe45b0000)
 ff60:                                     e45ae000 c5f26a00 00000000 00000125
 ff80: c0100264 c07f7fa3 beb54f04 fffffff7 00000001 e6f3fc0e b5e5e9ec beb54ec4
 ffa0: b5da0ccc c010024b b5e5e9ec beb54ec4 0000000f 00000000 00000000 beb54ebc
 ffc0: b5e5e9ec beb54ec4 b5da0ccc 00000125 beb54f58 00785238 beb5529c beb54f04
 ffe0: b5da1e24 beb54eac b301385c b62b6ee8 600f0030 0000000f 00000000 00000000
 [<c08f3311>] (unix_shutdown) from [<c07f7fa3>] (__sys_shutdown+0x2f/0x50)
 [<c07f7fa3>] (__sys_shutdown) from [<c010024b>]
(__sys_trace_return+0x1/0x16)
 Exception stack(0xe45affa8 to 0xe45afff0)

Signed-off-by: Jiang Wang <jiang.wang@bytedance.com>
Reported-by: Dmitry Osipenko <digetx@gmail.com>
Tested-by: Dmitry Osipenko <digetx@gmail.com>
---
 net/unix/af_unix.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 443c49081636..6965bc578a80 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -2847,7 +2847,8 @@ static int unix_shutdown(struct socket *sock, int mode)
 		int peer_mode = 0;
 		const struct proto *prot = READ_ONCE(other->sk_prot);
 
-		prot->unhash(other);
+		if (sk->sk_type == SOCK_STREAM)
+			prot->unhash(other);
 		if (mode&RCV_SHUTDOWN)
 			peer_mode |= SEND_SHUTDOWN;
 		if (mode&SEND_SHUTDOWN)
-- 
2.20.1


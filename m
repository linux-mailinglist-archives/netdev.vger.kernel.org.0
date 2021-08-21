Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAB2C3F3BF7
	for <lists+netdev@lfdr.de>; Sat, 21 Aug 2021 20:07:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231260AbhHUSId (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Aug 2021 14:08:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229733AbhHUSId (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Aug 2021 14:08:33 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40D4BC061575
        for <netdev@vger.kernel.org>; Sat, 21 Aug 2021 11:07:53 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id a21so11578599pfh.5
        for <netdev@vger.kernel.org>; Sat, 21 Aug 2021 11:07:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8GJsXQuTpKR2wbHDfP7I1D/01uKb8jZNCY+DWhBzgmo=;
        b=TIB+RBAgH2h2zSki63S+WYlw3AyD3MPcXf0osPvAucaDGEClyzYSEiH2OLT6cAE7+U
         O4ekTzJhQ2rj6aA6mdvWqF9pKqq9sLBxz5BNDn04HlXBcZ2oOt/khfZyJF5b29c/e2he
         hd5PsYah1pEx9nGWZDNfz+IMmUckPALs1wq2tI+oNDWTbQaRH5V9wL2+wdfGrULX8P9c
         pOnxnJzMfq32VcsDmelDCfyG9Gymgd6XD2yoVWBgDY47nR16YUQkE8yaMmWER80D0Bh7
         fkB3G271uCIe6KZIvl1BMvaUxaiKuN/hIi8DGQ2Gk5I7s7W0DMNdAlJR4UsoRE9Ktt/S
         K/ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8GJsXQuTpKR2wbHDfP7I1D/01uKb8jZNCY+DWhBzgmo=;
        b=hp0a6wuhMQ/yzF4AcRl5LpTCldV0yg8fsi9oYHONL6bNVauJylkSIizKueW5dyFngL
         33KF3yhJ82Y2zX+BuDao6J68K0oqy0Ivr3baT/siOx1xvuGR3sNB54fpRZr8oPDTDGme
         vm2i+cr9/mOCPmCLB+1qBemxavlxyIbL99VttvBUhGIrqnrmN8E3VarXTOZGrRJPhLdf
         b+0VdbWSatKBG6N3uy4rkb7ygdVJvgxwobx9Oo68vyc+w/T5BhKCSa0OG0wZrQPWUtQ8
         QL84KVn3iMbLczo9rae8EzWjc8l6gj6vbQj3SY6RzilkzLw6KXKeg3nWL9T/80wGUC0D
         t58g==
X-Gm-Message-State: AOAM533JcznD6tphboRzFNWw5h0F5k3TL2vN/9bFuZ6T4pMYMZx3aFfC
        sv23IIn/RNGe6jNbuKIwWcjw8g==
X-Google-Smtp-Source: ABdhPJwWegNY4tNj3aN8baq189DLQrBmrG3fbjMv6aFrT3BR5GjwReseEtyfLb0IyUEWHMuurCs3dA==
X-Received: by 2002:aa7:8d0c:0:b029:3e0:2e32:3148 with SMTP id j12-20020aa78d0c0000b02903e02e323148mr25776486pfe.23.1629569272676;
        Sat, 21 Aug 2021 11:07:52 -0700 (PDT)
Received: from ip-10-124-121-13.byted.org (ec2-54-241-92-238.us-west-1.compute.amazonaws.com. [54.241.92.238])
        by smtp.gmail.com with ESMTPSA id n32sm11944585pgl.69.2021.08.21.11.07.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Aug 2021 11:07:52 -0700 (PDT)
From:   Jiang Wang <jiang.wang@bytedance.com>
To:     bpf@vger.kernel.org
Cc:     cong.wang@bytedance.com, duanxiongchun@bytedance.com,
        xieyongji@bytedance.com, chaiwen.cc@bytedance.com,
        kuniyu@amazon.co.jp, Dmitry Osipenko <digetx@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Rao Shoaib <rao.shoaib@oracle.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH bpf-next v2] af_unix: fix NULL pointer bug in unix_shutdown
Date:   Sat, 21 Aug 2021 18:07:36 +0000
Message-Id: <20210821180738.1151155-1-jiang.wang@bytedance.com>
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

Fix the bug by checking the prot->unhash is NULL or not first.

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
v1 -> v2: check prot->unhash directly.

 net/unix/af_unix.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 443c49081636..15c1e4e4012d 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -2847,7 +2847,8 @@ static int unix_shutdown(struct socket *sock, int mode)
 		int peer_mode = 0;
 		const struct proto *prot = READ_ONCE(other->sk_prot);
 
-		prot->unhash(other);
+		if (prot->unhash)
+			prot->unhash(other);
 		if (mode&RCV_SHUTDOWN)
 			peer_mode |= SEND_SHUTDOWN;
 		if (mode&SEND_SHUTDOWN)
-- 
2.20.1


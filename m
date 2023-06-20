Return-Path: <netdev+bounces-12191-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1A889736971
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 12:37:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C9D4B28128C
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 10:37:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D13BDC13B;
	Tue, 20 Jun 2023 10:36:46 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0C742F5B
	for <netdev@vger.kernel.org>; Tue, 20 Jun 2023 10:36:46 +0000 (UTC)
Received: from mail-il1-x131.google.com (mail-il1-x131.google.com [IPv6:2607:f8b0:4864:20::131])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA70D1AC
	for <netdev@vger.kernel.org>; Tue, 20 Jun 2023 03:36:44 -0700 (PDT)
Received: by mail-il1-x131.google.com with SMTP id e9e14a558f8ab-343a9a89205so268055ab.1
        for <netdev@vger.kernel.org>; Tue, 20 Jun 2023 03:36:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mihalicyn.com; s=mihalicyn; t=1687257404; x=1689849404;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/8QOt0Jk8FxtXTGtnYbB+8rPfb+iCUj0sRAGKW2Hgec=;
        b=NPn6yCWA9d+K/MB9GfGDr4K/EMho6SzZ5j5Ujhz5vaE4+sDtE7mzrIPUdLQQ0cqU5Q
         eetplrHAYx+2xLxCRixZbIhb0W2NsW3jwAkhzAjxBDX8YKjJiNC7BKjRD67Wu86MdABb
         AW5qW1mUG1WMPET81MSW3/snWbWoZtiTlhXzY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687257404; x=1689849404;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/8QOt0Jk8FxtXTGtnYbB+8rPfb+iCUj0sRAGKW2Hgec=;
        b=aGvqiwqj6+wqe3Rgpe4rR25JoBXUIoywwKxyoKn7HDcJT7E8xZ1bxFQ8v9USmJMDSw
         UGlslNDFDRVZxJ6UA38gPOdZfM6EqORCS0wTvmntwBpjXXk+SVEajcc03kdJupYBq3IU
         1uvBM3Ry4c/SCl9JnzjiI9sAJQn2GqWFJ00yHBSZ4okkPBfeNU8gf42nAQKa4ixW9Zss
         e0VeIhGBmWn3qFd/qkKu64E/OAk1CgnSYUXrEQInpSjZIQJ5vaX7eUdEmytmchBilKuO
         sinS/gqbnrAy/qk12wuW7Z0ssjgdnbvuAI8l5NiaqCQLzW3S5qdrEb+QI/Hl+vIeLakg
         90Sg==
X-Gm-Message-State: AC+VfDy7v3EHSQ+kUUzjgkPIbnGtS4f8jb67Eg4cOR9X0KCdvfJwb8Oy
	O47n+TSmcT+VqYZgwqWyl/K+xSTYpvS3ydaHPKccwA==
X-Google-Smtp-Source: ACHHUZ5g6yAM58fmDCv9197oAFQtrSLEhplUKo0+KZ1c2Bko1QYjdeKNfvqaC/StdtWI/dMMYiY+9GCtJ4pIfDedUS4=
X-Received: by 2002:a6b:8d50:0:b0:77e:2763:1f2a with SMTP id
 p77-20020a6b8d50000000b0077e27631f2amr7181318iod.2.1687257403901; Tue, 20 Jun
 2023 03:36:43 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230620000009.9675-1-kuniyu@amazon.com>
In-Reply-To: <20230620000009.9675-1-kuniyu@amazon.com>
From: Alexander Mikhalitsyn <alexander@mihalicyn.com>
Date: Tue, 20 Jun 2023 12:36:32 +0200
Message-ID: <CAJqdLrrmZGNE3NQ99_+rUkUMAWmWRo04VRhjdzGKBO3zmRmpjg@mail.gmail.com>
Subject: Re: [PATCH v1 net] af_unix: Call scm_recv() only after scm_set_cred().
To: Kuniyuki Iwashima <kuniyu@amazon.com>
Cc: "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Christian Brauner <brauner@kernel.org>, Kuniyuki Iwashima <kuni1840@gmail.com>, netdev@vger.kernel.org, 
	syzkaller <syzkaller@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, Jun 20, 2023 at 2:00=E2=80=AFAM Kuniyuki Iwashima <kuniyu@amazon.co=
m> wrote:
>
> syzkaller hit a WARN_ON_ONCE(!scm->pid) in scm_pidfd_recv().
>
> In unix_stream_read_generic(), some paths reach scm_recv() without callin=
g
> scm_set_cred().
>
> Let's say unix_stream_read_generic() is blocked in unix_stream_data_wait(=
).
> If a concurrent thread calls shutdown(RCV_SHUTDOWN) for the socket itself
> or its peer calls close(), we bail out the while loop without calling
> scm_set_cred().
>
> If the socket is configured with SO_PASSCRED or SO_PASSPIDFD, scm_recv()
> would populate cmsg with garbage.
>
> Let's not call scm_recv() unless scm_set_cred() is called.
>
> WARNING: CPU: 1 PID: 3245 at include/net/scm.h:138 scm_pidfd_recv include=
/net/scm.h:138 [inline]
> WARNING: CPU: 1 PID: 3245 at include/net/scm.h:138 scm_recv.constprop.0+0=
x754/0x850 include/net/scm.h:177
> Modules linked in:
> CPU: 1 PID: 3245 Comm: syz-executor.1 Not tainted 6.4.0-rc5-01219-gfa0e21=
fa4443 #2
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.16.0-0-=
gd239552ce722-prebuilt.qemu.org 04/01/2014
> RIP: 0010:scm_pidfd_recv include/net/scm.h:138 [inline]
> RIP: 0010:scm_recv.constprop.0+0x754/0x850 include/net/scm.h:177
> Code: 67 fd e9 55 fd ff ff e8 4a 70 67 fd e9 7f fd ff ff e8 40 70 67 fd e=
9 3e fb ff ff e8 36 70 67 fd e9 02 fd ff ff e8 8c 3a 20 fd <0f> 0b e9 fe fb=
 ff ff e8 50 70 67 fd e9 2e f9 ff ff e8 46 70 67 fd
> RSP: 0018:ffffc90009af7660 EFLAGS: 00010216
> RAX: 00000000000000a1 RBX: ffff888041e58a80 RCX: ffffc90003852000
> RDX: 0000000000040000 RSI: ffffffff842675b4 RDI: 0000000000000007
> RBP: ffffc90009af7810 R08: 0000000000000007 R09: 0000000000000013
> R10: 00000000000000f8 R11: 0000000000000001 R12: ffffc90009af7db0
> R13: 0000000000000000 R14: ffff888041e58a88 R15: 1ffff9200135eecc
> FS:  00007f6b7113f640(0000) GS:ffff88806cf00000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f6b7111de38 CR3: 0000000012a6e002 CR4: 0000000000770ee0
> PKRU: 55555554
> Call Trace:
>  <TASK>
>  unix_stream_read_generic+0x5fe/0x1f50 net/unix/af_unix.c:2830
>  unix_stream_recvmsg+0x194/0x1c0 net/unix/af_unix.c:2880
>  sock_recvmsg_nosec net/socket.c:1019 [inline]
>  sock_recvmsg+0x188/0x1d0 net/socket.c:1040
>  ____sys_recvmsg+0x210/0x610 net/socket.c:2712
>  ___sys_recvmsg+0xff/0x190 net/socket.c:2754
>  do_recvmmsg+0x25d/0x6c0 net/socket.c:2848
>  __sys_recvmmsg net/socket.c:2927 [inline]
>  __do_sys_recvmmsg net/socket.c:2950 [inline]
>  __se_sys_recvmmsg net/socket.c:2943 [inline]
>  __x64_sys_recvmmsg+0x224/0x290 net/socket.c:2943
>  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>  do_syscall_64+0x3f/0x90 arch/x86/entry/common.c:80
>  entry_SYSCALL_64_after_hwframe+0x72/0xdc
> RIP: 0033:0x7f6b71da2e5d
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 8b 0d 73 9f 1b 00 f7 d8 64 89 01 48
> RSP: 002b:00007f6b7113ecc8 EFLAGS: 00000246 ORIG_RAX: 000000000000012b
> RAX: ffffffffffffffda RBX: 00000000004bc050 RCX: 00007f6b71da2e5d
> RDX: 0000000000000007 RSI: 0000000020006600 RDI: 000000000000000b
> RBP: 00000000004bc050 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000120 R11: 0000000000000246 R12: 0000000000000000
> R13: 000000000000006e R14: 00007f6b71e03530 R15: 0000000000000000
>  </TASK>
>
> Fixes: 5e2ff6704a27 ("scm: add SO_PASSPIDFD and SCM_PIDFD")
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Reported-by: syzkaller <syzkaller@googlegroups.com>
> Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
> ---
>  net/unix/af_unix.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
> index e7728b57a8c7..f1b76e0a8192 100644
> --- a/net/unix/af_unix.c
> +++ b/net/unix/af_unix.c
> @@ -2905,7 +2905,7 @@ static int unix_stream_read_generic(struct unix_str=
eam_read_state *state,
>         } while (size);
>
>         mutex_unlock(&u->iolock);
> -       if (state->msg)
> +       if (state->msg && check_creds)
>                 scm_recv(sock, state->msg, &scm, flags);
>         else
>                 scm_destroy(&scm);
> --
> 2.30.2
>

Dear Kuniyuki,

Thanks for looking into it!

I'm afraid that this can lead to some regressions from the userspace
side, because with this change we will stop sending
SCM_CREDENTIALS, SCM_SECURITY and SCM_RIGHTS in case scm_set_cred wasn't ca=
lled.

Wouldn't it be safer just to ensure that scm->creds.uid is always
initialized and skip SCM_PIDFD in case when scm->pid is NULL?

Kind regards,
Alex


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD75A4E80C4
	for <lists+netdev@lfdr.de>; Sat, 26 Mar 2022 13:24:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232865AbiCZM0C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Mar 2022 08:26:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232839AbiCZM0C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Mar 2022 08:26:02 -0400
X-Greylist: delayed 2149 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sat, 26 Mar 2022 05:24:23 PDT
Received: from kylie.crudebyte.com (kylie.crudebyte.com [5.189.157.229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8FDD292BA5;
        Sat, 26 Mar 2022 05:24:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=crudebyte.com; s=kylie; h=Content-Type:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
        Content-ID:Content-Description;
        bh=b0sF/A2IXGzEeoocXOZUQN9bsOEvXQ00kZXmIDoPRs4=; b=BJyl8HmOzQiMTLOhn5wjezhvx1
        kcJwGQBhQ0RsAi3o4q5EQXjsCC9Etc2FMQVYaTFVOF85HQRcM/6MqRPDXDeviO8X0xu4zjb6+rmIA
        /nfNxKKKs5et0k6GEfXuFf7Dnf7LtxUQiFskLPkXHmIzcmQQtcAlwCz3jQuCZcP6yV8JXhPoKED+v
        sXHdSoqPfnm0668gdFg29rV8eG0hYxxG/ubhFLOHysUO/YJsLAjOsmTMZAORz5djXybKHwylIGODG
        DXyue+hWVclZ3eJ7bXWMeZHeuEbB/udPl+9MTG2rCTsr4QZXs9IHO4Tpk+y5O80lKXcT2127PprdL
        Vbw0LeTkiLDtC+1WOoTL2hw2Nh+6mPdXHVr+g9hXfICSwJHhTu3ltADk5s8IZ+IKL3+WjqKVAZmKz
        nUn7lFBr4qpHPn86JdzT+NebaNdW5xKyi30O9WPjNt4OzoH4R0bY5OabPg3RLI6es2v7v7O6c/fsN
        2yZgK4y88Cqf1jWSjhFA2aavZ+aMvM+GLnL8atfERgJsqzPrknZh0p7JcX5W5XKKxWATn8qEpJWq5
        bG4Mlv6Wt4cIwSo4DAtDJQHzj9PA+w8FpQrcKnxnO52T2gG8VESiBJLf3FRhAzcqrD8BYjykqZnkz
        vxGTI3bOhHqqaQZbcaUk6fmy71KWj3dhwycCQcl40=;
From:   Christian Schoenebeck <linux_oss@crudebyte.com>
To:     David Kahurani <k.kahurani@gmail.com>
Cc:     davem@davemloft.net, ericvh@gmail.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, lucho@ionkov.net,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        v9fs-developer@lists.sourceforge.net,
        syzbot+5e28cdb7ebd0f2389ca4@syzkaller.appspotmail.com,
        asmadeus@codewreck.org
Subject: Re: [syzbot] WARNING in p9_client_destroy
Date:   Sat, 26 Mar 2022 12:48:26 +0100
Message-ID: <3597833.OkAhqpS0b6@silver>
In-Reply-To: <CAAZOf26g-L2nSV-Siw6mwWQv1nv6on8c0fWqB4bKmX73QAFzow@mail.gmail.com>
References: <CAAZOf26g-L2nSV-Siw6mwWQv1nv6on8c0fWqB4bKmX73QAFzow@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Donnerstag, 24. M=E4rz 2022 13:13:25 CET David Kahurani wrote:
> On Monday, February 28, 2022 at 4:38:57 AM UTC+3 asmadeus@codewreck.org
>=20
> wrote:
> > syzbot wrote on Sun, Feb 27, 2022 at 04:53:29PM -0800:
> > > kmem_cache_destroy 9p-fcall-cache: Slab cache still has objects when
> > > called from p9_client_destroy+0x213/0x370 net/9p/client.c:1100
> >=20
> > hmm, there is no previous "Packet with tag %d has still references"
> > (sic) message, so this is probably because p9_tag_cleanup only relies on
> > rcu read lock for consistency, so even if the connection has been closed
> > above (clnt->trans_mode->close) there could have been a request sent
> > (=3D tag added) just before that which isn't visible on the destroying
> > side?
> >=20
> > I guess adding an rcu_barrier() is what makes most sense here to protect
> > this case?
> > I'll send a patch in the next few days unless it was a stupid idea.
>=20
> Looking at this brought me to the same conclusion.
>=20
> ---------------------
>=20
> From cd5a11207a140004bf55005fac7f7e4cec2fd075 Mon Sep 17 00:00:00 2001
> From: David Kahurani <k.kahurani@gmail.com>
> Date: Thu, 24 Mar 2022 15:00:23 +0300
> Subject: [PATCH] net/9p: Flush any delayed rce free
>=20
> As is best practice
>=20
> kmem_cache_destroy 9p-fcall-cache: Slab cache still has objects when call=
ed
> from p9_client_destroy+0x213/0x370 net/9p/client.c:1100
> WARNING: CPU: 1 PID: 3701 at mm/slab_common.c:502 kmem_cache_destroy
> mm/slab_common.c:502 [inline]
> WARNING: CPU: 1 PID: 3701 at mm/slab_common.c:502
> kmem_cache_destroy+0x13b/0x140 mm/slab_common.c:490
> Modules linked in:
> CPU: 1 PID: 3701 Comm: syz-executor.3 Not tainted
> 5.17.0-rc5-syzkaller-00021-g23d04328444a #0
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.14.0-2 04/01/2=
014
> RIP: 0010:kmem_cache_destroy mm/slab_common.c:502 [inline]
> RIP: 0010:kmem_cache_destroy+0x13b/0x140 mm/slab_common.c:490
> Code: da a8 0e 48 89 ee e8 44 6e 15 00 eb c1 c3 48 8b 55 58 48 c7 c6 60 cd
> b6 89 48 c7 c7 30 83 3a 8b 48 8b 4c 24 18 e8 9b 30 60 07 <0f> 0b eb a0 90
> 41 55 49 89 d5 41 54 49 89 f4 55 48 89 fd 53 48 83
> RSP: 0018:ffffc90002767cf0 EFLAGS: 00010282
> RAX: 0000000000000000 RBX: 1ffff920004ecfa5 RCX: 0000000000000000
> RDX: ffff88801e56a280 RSI: ffffffff815f4b38 RDI: fffff520004ecf90
> RBP: ffff888020ba8b00 R08: 0000000000000000 R09: 0000000000000000
> R10: ffffffff815ef1ce R11: 0000000000000000 R12: 0000000000000001
> R13: ffffc90002767d68 R14: dffffc0000000000 R15: 0000000000000000
> FS:  00005555561b0400(0000) GS:ffff88802ca00000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000555556ead708 CR3: 0000000068b97000 CR4: 0000000000150ef0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>  <TASK>
>  p9_client_destroy+0x213/0x370 net/9p/client.c:1100
>  v9fs_session_close+0x45/0x2d0 fs/9p/v9fs.c:504
>  v9fs_kill_super+0x49/0x90 fs/9p/vfs_super.c:226
>  deactivate_locked_super+0x94/0x160 fs/super.c:332
>  deactivate_super+0xad/0xd0 fs/super.c:363
>  cleanup_mnt+0x3a2/0x540 fs/namespace.c:1173
>  task_work_run+0xdd/0x1a0 kernel/task_work.c:164
>  tracehook_notify_resume include/linux/tracehook.h:188 [inline]
>  exit_to_user_mode_loop kernel/entry/common.c:175 [inline]
>  exit_to_user_mode_prepare+0x27e/0x290 kernel/entry/common.c:207
>  __syscall_exit_to_user_mode_work kernel/entry/common.c:289 [inline]
>  syscall_exit_to_user_mode+0x19/0x60 kernel/entry/common.c:300
>  do_syscall_64+0x42/0xb0 arch/x86/entry/common.c:86
>  entry_SYSCALL_64_after_hwframe+0x44/0xae
> RIP: 0033:0x7f5ff63ed4c7
> Code: ff ff ff f7 d8 64 89 01 48 83 c8 ff c3 66 0f 1f 44 00 00 31 f6 e9 09
> 00 00 00 66 0f 1f 84 00 00 00 00 00 b8 a6 00 00 00 0f 05 <48> 3d 01 f0 ff
> ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007fff01862e98 EFLAGS: 00000246 ORIG_RAX: 00000000000000a6
> RAX: 0000000000000000 RBX: 0000000000000000 RCX: 00007f5ff63ed4c7
> RDX: 00007fff01862f6c RSI: 000000000000000a RDI: 00007fff01862f60
> RBP: 00007fff01862f60 R08: 00000000ffffffff R09: 00007fff01862d30
> R10: 00005555561b18b3 R11: 0000000000000246 R12: 00007f5ff64451ea
> R13: 00007fff01864020 R14: 00005555561b1810 R15: 00007fff01864060
>  </TASK>
>=20
> Signed-off-by: David Kahurani <k.kahurani@gmail.com>
> Reported-by: syzbot+5e28cdb7ebd0f2389ca4@syzkaller.appspotmail.com

I'm not absolutely sure that this will really fix this issue, but it seems =
to=20
be a good idea to add a rcu_barrier() call here nevertheless.

Reviewed-by: Christian Schoenebeck <linux_oss@crudebyte.com>

> ---
>  net/9p/client.c | 1 +
>  1 file changed, 1 insertion(+)
>=20
> diff --git a/net/9p/client.c b/net/9p/client.c
> index 8bba0d9cf..67c51913a 100644
> --- a/net/9p/client.c
> +++ b/net/9p/client.c
> @@ -1097,6 +1097,7 @@ void p9_client_destroy(struct p9_client *clnt)
>=20
>   p9_tag_cleanup(clnt);
>=20
> + rcu_barrier();
>   kmem_cache_destroy(clnt->fcall_cache);
>   kfree(clnt);
>  }





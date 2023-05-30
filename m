Return-Path: <netdev+bounces-6399-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7016671627A
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 15:46:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AFFB81C20BB8
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 13:46:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 12CE7209AB;
	Tue, 30 May 2023 13:46:30 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 045671993C
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 13:46:29 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8960C1BB
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 06:45:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685454285;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=t2l6yxyTUoEVEB0Kn+V8wrTZ/yKFOTjoGrpOKOgaUnA=;
	b=bGTLqcx51Pj6uDgoEQf42C3/Uni21yBi/kt7sMqAwd1/3P68VynFq7iJxQhadb+3rNyruT
	QJLe3WMO8AwWXNbrvynMKASy8oEqZw+TZ2gQVNOl5SrcD1Y/cpiTZRakh8v78s5G/pE04f
	64xCi6hwnWpA8jyyKB6mFzhArb5XloY=
Received: from mail-yb1-f200.google.com (mail-yb1-f200.google.com
 [209.85.219.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-594-J1O-e3_2N8GqEF3FNAwYFA-1; Tue, 30 May 2023 09:44:42 -0400
X-MC-Unique: J1O-e3_2N8GqEF3FNAwYFA-1
Received: by mail-yb1-f200.google.com with SMTP id 3f1490d57ef6-ba802c775caso8874147276.2
        for <netdev@vger.kernel.org>; Tue, 30 May 2023 06:44:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685454282; x=1688046282;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=t2l6yxyTUoEVEB0Kn+V8wrTZ/yKFOTjoGrpOKOgaUnA=;
        b=Z/qo4eae17zAU8GBtJL02hAMs+l2tPBnJgpy/m+16UCLkrjEjGwvYYfkYNrS8Fo7gH
         3g1zexX13mpLBKjc+K9nRdiwny1vnNA/IFLTXI9/MbctK+N6KhIvY84IicQTt28wUEp3
         nh5egdhzjYG6/zR21rjCzCQnR+iSycxoihpAGqLLgWgSCjCXKq9qvhsNl0dDegEjhX/Z
         mtMBh9NjaQ2mG7J5SHPKu8eUvPcUojNHU15v6yNZbuMiM+V0DCDEOXZerzmsn6QrsKHs
         566my3yPn/YWvnPSJzj8BrPtONn6+DF7AOTKkDrexLhA76FStaKvI6scmmUzwpFam97A
         9Xbw==
X-Gm-Message-State: AC+VfDwYXN+R5P4MivQfmnX+dh4wpfuxa3QB9b7Rzz3QYTa7rzqW0YMb
	/FYakOUnSLgXb21JjdWlHQ4eraL8wrmrXr7VjYc/BVbRqutJXqbV/yySRe+aJLfRVyQs7+r3so7
	auq0YwZh79a19zMEnHlLQeOj0PYRq487e
X-Received: by 2002:a25:b228:0:b0:b7e:6685:84a with SMTP id i40-20020a25b228000000b00b7e6685084amr2863672ybj.1.1685454282217;
        Tue, 30 May 2023 06:44:42 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7IKY12NixqRNFVbAf3qxjOmgGASLwh4Am+aOp6PdVD5Ny3mpVShyuDa7/dV10V7UB1h+RLJ/ssT/rZQvxwZUM=
X-Received: by 2002:a25:b228:0:b0:b7e:6685:84a with SMTP id
 i40-20020a25b228000000b00b7e6685084amr2863660ybj.1.1685454281946; Tue, 30 May
 2023 06:44:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <0000000000001777f605fce42c5f@google.com> <20230530072310-mutt-send-email-mst@kernel.org>
In-Reply-To: <20230530072310-mutt-send-email-mst@kernel.org>
From: Stefano Garzarella <sgarzare@redhat.com>
Date: Tue, 30 May 2023 15:44:30 +0200
Message-ID: <CAGxU2F7O7ef3mdvNXtiC0VtWiS2DMnoiGwSR=Z6SWbzqcrBF-g@mail.gmail.com>
Subject: Re: [syzbot] [kvm?] [net?] [virt?] general protection fault in vhost_work_queue
To: "Michael S. Tsirkin" <mst@redhat.com>, Mike Christie <michael.christie@oracle.com>
Cc: syzbot <syzbot+d0d442c22fa8db45ff0e@syzkaller.appspotmail.com>, 
	jasowang@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com, 
	virtualization@lists.linux-foundation.org, stefanha@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 30, 2023 at 1:24=E2=80=AFPM Michael S. Tsirkin <mst@redhat.com>=
 wrote:
>
> On Tue, May 30, 2023 at 12:30:06AM -0700, syzbot wrote:
> > Hello,
> >
> > syzbot found the following issue on:
> >
> > HEAD commit:    933174ae28ba Merge tag 'spi-fix-v6.4-rc3' of git://git.=
ker..
> > git tree:       upstream
> > console output: https://syzkaller.appspot.com/x/log.txt?x=3D138d4ae5280=
000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=3Df389ffdf4e9=
ba3f0
> > dashboard link: https://syzkaller.appspot.com/bug?extid=3Dd0d442c22fa8d=
b45ff0e
> > compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binu=
tils for Debian) 2.35.2
> >
> > Unfortunately, I don't have any reproducer for this issue yet.
> >
> > Downloadable assets:
> > disk image: https://storage.googleapis.com/syzbot-assets/21a81b8c2660/d=
isk-933174ae.raw.xz
> > vmlinux: https://storage.googleapis.com/syzbot-assets/b4951d89e238/vmli=
nux-933174ae.xz
> > kernel image: https://storage.googleapis.com/syzbot-assets/21eb405303cc=
/bzImage-933174ae.xz
> >
> > IMPORTANT: if you fix the issue, please add the following tag to the co=
mmit:
> > Reported-by: syzbot+d0d442c22fa8db45ff0e@syzkaller.appspotmail.com
> >
> > general protection fault, probably for non-canonical address 0xdffffc00=
0000000e: 0000 [#1] PREEMPT SMP KASAN
> > KASAN: null-ptr-deref in range [0x0000000000000070-0x0000000000000077]
> > CPU: 0 PID: 29845 Comm: syz-executor.4 Not tainted 6.4.0-rc3-syzkaller-=
00032-g933174ae28ba #0
> > Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS=
 Google 05/16/2023
> > RIP: 0010:vhost_work_queue drivers/vhost/vhost.c:259 [inline]
> > RIP: 0010:vhost_work_queue+0xfc/0x150 drivers/vhost/vhost.c:248
> > Code: 00 00 fc ff df 48 89 da 48 c1 ea 03 80 3c 02 00 75 56 48 b8 00 00=
 00 00 00 fc ff df 48 8b 1b 48 8d 7b 70 48 89 fa 48 c1 ea 03 <80> 3c 02 00 =
75 42 48 8b 7b 70 e8 95 9e ae f9 5b 5d 41 5c 41 5d e9
> > RSP: 0018:ffffc9000333faf8 EFLAGS: 00010202
> > RAX: dffffc0000000000 RBX: 0000000000000000 RCX: ffffc9000d84d000
> > RDX: 000000000000000e RSI: ffffffff841221d7 RDI: 0000000000000070
> > RBP: ffff88804b6b95b0 R08: 0000000000000001 R09: 0000000000000000
> > R10: 0000000000000001 R11: 0000000000000000 R12: ffff88804b6b00b0
> > R13: 0000000000000000 R14: ffff88804b6b95e0 R15: ffff88804b6b95c8
> > FS:  00007f3b445ec700(0000) GS:ffff8880b9800000(0000) knlGS:00000000000=
00000
> > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > CR2: 0000001b2e423000 CR3: 000000005d734000 CR4: 00000000003506f0
> > DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > DR3: 000000000000003b DR6: 00000000ffff0ff0 DR7: 0000000000000400
> > Call Trace:
> >  <TASK>
> >  vhost_transport_send_pkt+0x268/0x520 drivers/vhost/vsock.c:288
> >  virtio_transport_send_pkt_info+0x54c/0x820 net/vmw_vsock/virtio_transp=
ort_common.c:250
> >  virtio_transport_connect+0xb1/0xf0 net/vmw_vsock/virtio_transport_comm=
on.c:813
> >  vsock_connect+0x37f/0xcd0 net/vmw_vsock/af_vsock.c:1414
> >  __sys_connect_file+0x153/0x1a0 net/socket.c:2003
> >  __sys_connect+0x165/0x1a0 net/socket.c:2020
> >  __do_sys_connect net/socket.c:2030 [inline]
> >  __se_sys_connect net/socket.c:2027 [inline]
> >  __x64_sys_connect+0x73/0xb0 net/socket.c:2027
> >  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
> >  do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
> >  entry_SYSCALL_64_after_hwframe+0x63/0xcd
> > RIP: 0033:0x7f3b4388c169
> > Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 f1 19 00 00 90 48 89 f8 48 89=
 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 =
ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
> > RSP: 002b:00007f3b445ec168 EFLAGS: 00000246 ORIG_RAX: 000000000000002a
> > RAX: ffffffffffffffda RBX: 00007f3b439ac050 RCX: 00007f3b4388c169
> > RDX: 0000000000000010 RSI: 0000000020000140 RDI: 0000000000000004
> > RBP: 00007f3b438e7ca1 R08: 0000000000000000 R09: 0000000000000000
> > R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> > R13: 00007f3b43acfb1f R14: 00007f3b445ec300 R15: 0000000000022000
> >  </TASK>
> > Modules linked in:
> > ---[ end trace 0000000000000000 ]---
> > RIP: 0010:vhost_work_queue drivers/vhost/vhost.c:259 [inline]
> > RIP: 0010:vhost_work_queue+0xfc/0x150 drivers/vhost/vhost.c:248
> > Code: 00 00 fc ff df 48 89 da 48 c1 ea 03 80 3c 02 00 75 56 48 b8 00 00=
 00 00 00 fc ff df 48 8b 1b 48 8d 7b 70 48 89 fa 48 c1 ea 03 <80> 3c 02 00 =
75 42 48 8b 7b 70 e8 95 9e ae f9 5b 5d 41 5c 41 5d e9
> > RSP: 0018:ffffc9000333faf8 EFLAGS: 00010202
> > RAX: dffffc0000000000 RBX: 0000000000000000 RCX: ffffc9000d84d000
> > RDX: 000000000000000e RSI: ffffffff841221d7 RDI: 0000000000000070
> > RBP: ffff88804b6b95b0 R08: 0000000000000001 R09: 0000000000000000
> > R10: 0000000000000001 R11: 0000000000000000 R12: ffff88804b6b00b0
> > R13: 0000000000000000 R14: ffff88804b6b95e0 R15: ffff88804b6b95c8
> > FS:  00007f3b445ec700(0000) GS:ffff8880b9900000(0000) knlGS:00000000000=
00000
> > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > CR2: 0000001b2e428000 CR3: 000000005d734000 CR4: 00000000003506e0
> > DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > DR3: 000000000000003b DR6: 00000000ffff0ff0 DR7: 0000000000000400
> > ----------------
> > Code disassembly (best guess), 5 bytes skipped:
> >    0: 48 89 da                mov    %rbx,%rdx
> >    3: 48 c1 ea 03             shr    $0x3,%rdx
> >    7: 80 3c 02 00             cmpb   $0x0,(%rdx,%rax,1)
> >    b: 75 56                   jne    0x63
> >    d: 48 b8 00 00 00 00 00    movabs $0xdffffc0000000000,%rax
> >   14: fc ff df
> >   17: 48 8b 1b                mov    (%rbx),%rbx
> >   1a: 48 8d 7b 70             lea    0x70(%rbx),%rdi
> >   1e: 48 89 fa                mov    %rdi,%rdx
> >   21: 48 c1 ea 03             shr    $0x3,%rdx
> > * 25: 80 3c 02 00             cmpb   $0x0,(%rdx,%rax,1) <-- trapping in=
struction
> >   29: 75 42                   jne    0x6d
> >   2b: 48 8b 7b 70             mov    0x70(%rbx),%rdi
> >   2f: e8 95 9e ae f9          callq  0xf9ae9ec9
> >   34: 5b                      pop    %rbx
> >   35: 5d                      pop    %rbp
> >   36: 41 5c                   pop    %r12
> >   38: 41 5d                   pop    %r13
> >   3a: e9                      .byte 0xe9
>
>
> Stefano, Stefan, take a look?

I'll take a look.

From a first glance, it looks like an issue when we call vhost_work_queue()=
.
@Mike, does that ring any bells since you recently looked at that code?

Thanks,
Stefano



Return-Path: <netdev+bounces-6338-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 81FEC715D19
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 13:24:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 37355280D96
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 11:24:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5816C17AAA;
	Tue, 30 May 2023 11:24:22 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D5A617AA9
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 11:24:22 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 094AD125
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 04:24:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685445853;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=FFKpZXmHv3EVEcNDqoXlVak203z2YTZFcHMcY6d15bo=;
	b=TKwsr6dVPFOoTFhwRivD/dM5azroGX9EbK48TzjuvA9/dDbnsVM1UfgdvJItyqbcI2v8J7
	v/LSaSWW+OQ3Oe4AUG/oODgepVkcPC1jnT0p019vgvx/nfPe0gQATRWd3gb08hQ/LmEonc
	CXjsIZi1+Ka2Fz1WcbDjabv7vJgIb6c=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-248-vLqYbSVnMPeBvUitaMtG2w-1; Tue, 30 May 2023 07:24:12 -0400
X-MC-Unique: vLqYbSVnMPeBvUitaMtG2w-1
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-3f6038dc351so16326245e9.3
        for <netdev@vger.kernel.org>; Tue, 30 May 2023 04:24:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685445851; x=1688037851;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FFKpZXmHv3EVEcNDqoXlVak203z2YTZFcHMcY6d15bo=;
        b=gv2bG2sFK2poGk7cJiF+af79l/FAEXb6MjVnHmoX3hBHgucXm4Zq8FHVjbQhBA15nw
         ABXBiuePHRhsJqvP+wfeeyJJcjKDY4eQKoaxJ8PP9/CCa0aiot6V+4UKTyTmqiXz5Aze
         agNKObngCVmAcqldPJ9Q0sH98BzFaG1nMv1xZVcaT9QecxjH/KV8+QWLdYHH0660I1bG
         YvVty7YUMGFu3X5e1eA5/qEC0U50Lnl6Lpm3vqfAeivVAxkWW8rzCjhBrUtC7zFUWwdj
         DSUsHMKgj10D2OMBBeCmD2HkqswjbvxIQFbTdQwLmBNlqgouEz4mTe8dgNgba9Xrg+3d
         6erQ==
X-Gm-Message-State: AC+VfDzL9QsKjEuySudqhYtl2HK+oFCcW8XHbhI4hoef++cyWQ8uCixd
	ZBP/FWoSRJGe7+izRm/vXxR95YVvdhvlqYLu5wV/bASE7SPXR0GO1iz+0MC4dQ/cNRGHg//5myw
	VSdIVWoFzNe/toRud1gFGZnIV
X-Received: by 2002:a05:600c:228b:b0:3f6:13e1:16b7 with SMTP id 11-20020a05600c228b00b003f613e116b7mr1442245wmf.28.1685445850791;
        Tue, 30 May 2023 04:24:10 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ4olrB3T4242Hm657dR8k3m6TNwqGT1KzpvGbXMckpc6fTPwJMFCqvnLyJXIIbYPJ8cvXRQRA==
X-Received: by 2002:a05:600c:228b:b0:3f6:13e1:16b7 with SMTP id 11-20020a05600c228b00b003f613e116b7mr1442231wmf.28.1685445850463;
        Tue, 30 May 2023 04:24:10 -0700 (PDT)
Received: from redhat.com ([2.52.11.69])
        by smtp.gmail.com with ESMTPSA id k10-20020a7bc40a000000b003f606869603sm20719249wmi.6.2023.05.30.04.24.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 May 2023 04:24:09 -0700 (PDT)
Date: Tue, 30 May 2023 07:24:06 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: syzbot <syzbot+d0d442c22fa8db45ff0e@syzkaller.appspotmail.com>
Cc: jasowang@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
	virtualization@lists.linux-foundation.org,
	Stefano Garzarella <sgarzare@redhat.com>, stefanha@redhat.com
Subject: Re: [syzbot] [kvm?] [net?] [virt?] general protection fault in
 vhost_work_queue
Message-ID: <20230530072310-mutt-send-email-mst@kernel.org>
References: <0000000000001777f605fce42c5f@google.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0000000000001777f605fce42c5f@google.com>
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 30, 2023 at 12:30:06AM -0700, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    933174ae28ba Merge tag 'spi-fix-v6.4-rc3' of git://git.ker..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=138d4ae5280000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=f389ffdf4e9ba3f0
> dashboard link: https://syzkaller.appspot.com/bug?extid=d0d442c22fa8db45ff0e
> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
> 
> Unfortunately, I don't have any reproducer for this issue yet.
> 
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/21a81b8c2660/disk-933174ae.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/b4951d89e238/vmlinux-933174ae.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/21eb405303cc/bzImage-933174ae.xz
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+d0d442c22fa8db45ff0e@syzkaller.appspotmail.com
> 
> general protection fault, probably for non-canonical address 0xdffffc000000000e: 0000 [#1] PREEMPT SMP KASAN
> KASAN: null-ptr-deref in range [0x0000000000000070-0x0000000000000077]
> CPU: 0 PID: 29845 Comm: syz-executor.4 Not tainted 6.4.0-rc3-syzkaller-00032-g933174ae28ba #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 05/16/2023
> RIP: 0010:vhost_work_queue drivers/vhost/vhost.c:259 [inline]
> RIP: 0010:vhost_work_queue+0xfc/0x150 drivers/vhost/vhost.c:248
> Code: 00 00 fc ff df 48 89 da 48 c1 ea 03 80 3c 02 00 75 56 48 b8 00 00 00 00 00 fc ff df 48 8b 1b 48 8d 7b 70 48 89 fa 48 c1 ea 03 <80> 3c 02 00 75 42 48 8b 7b 70 e8 95 9e ae f9 5b 5d 41 5c 41 5d e9
> RSP: 0018:ffffc9000333faf8 EFLAGS: 00010202
> RAX: dffffc0000000000 RBX: 0000000000000000 RCX: ffffc9000d84d000
> RDX: 000000000000000e RSI: ffffffff841221d7 RDI: 0000000000000070
> RBP: ffff88804b6b95b0 R08: 0000000000000001 R09: 0000000000000000
> R10: 0000000000000001 R11: 0000000000000000 R12: ffff88804b6b00b0
> R13: 0000000000000000 R14: ffff88804b6b95e0 R15: ffff88804b6b95c8
> FS:  00007f3b445ec700(0000) GS:ffff8880b9800000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000001b2e423000 CR3: 000000005d734000 CR4: 00000000003506f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 000000000000003b DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Call Trace:
>  <TASK>
>  vhost_transport_send_pkt+0x268/0x520 drivers/vhost/vsock.c:288
>  virtio_transport_send_pkt_info+0x54c/0x820 net/vmw_vsock/virtio_transport_common.c:250
>  virtio_transport_connect+0xb1/0xf0 net/vmw_vsock/virtio_transport_common.c:813
>  vsock_connect+0x37f/0xcd0 net/vmw_vsock/af_vsock.c:1414
>  __sys_connect_file+0x153/0x1a0 net/socket.c:2003
>  __sys_connect+0x165/0x1a0 net/socket.c:2020
>  __do_sys_connect net/socket.c:2030 [inline]
>  __se_sys_connect net/socket.c:2027 [inline]
>  __x64_sys_connect+0x73/0xb0 net/socket.c:2027
>  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>  do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
>  entry_SYSCALL_64_after_hwframe+0x63/0xcd
> RIP: 0033:0x7f3b4388c169
> Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 f1 19 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007f3b445ec168 EFLAGS: 00000246 ORIG_RAX: 000000000000002a
> RAX: ffffffffffffffda RBX: 00007f3b439ac050 RCX: 00007f3b4388c169
> RDX: 0000000000000010 RSI: 0000000020000140 RDI: 0000000000000004
> RBP: 00007f3b438e7ca1 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007f3b43acfb1f R14: 00007f3b445ec300 R15: 0000000000022000
>  </TASK>
> Modules linked in:
> ---[ end trace 0000000000000000 ]---
> RIP: 0010:vhost_work_queue drivers/vhost/vhost.c:259 [inline]
> RIP: 0010:vhost_work_queue+0xfc/0x150 drivers/vhost/vhost.c:248
> Code: 00 00 fc ff df 48 89 da 48 c1 ea 03 80 3c 02 00 75 56 48 b8 00 00 00 00 00 fc ff df 48 8b 1b 48 8d 7b 70 48 89 fa 48 c1 ea 03 <80> 3c 02 00 75 42 48 8b 7b 70 e8 95 9e ae f9 5b 5d 41 5c 41 5d e9
> RSP: 0018:ffffc9000333faf8 EFLAGS: 00010202
> RAX: dffffc0000000000 RBX: 0000000000000000 RCX: ffffc9000d84d000
> RDX: 000000000000000e RSI: ffffffff841221d7 RDI: 0000000000000070
> RBP: ffff88804b6b95b0 R08: 0000000000000001 R09: 0000000000000000
> R10: 0000000000000001 R11: 0000000000000000 R12: ffff88804b6b00b0
> R13: 0000000000000000 R14: ffff88804b6b95e0 R15: ffff88804b6b95c8
> FS:  00007f3b445ec700(0000) GS:ffff8880b9900000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000001b2e428000 CR3: 000000005d734000 CR4: 00000000003506e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 000000000000003b DR6: 00000000ffff0ff0 DR7: 0000000000000400
> ----------------
> Code disassembly (best guess), 5 bytes skipped:
>    0:	48 89 da             	mov    %rbx,%rdx
>    3:	48 c1 ea 03          	shr    $0x3,%rdx
>    7:	80 3c 02 00          	cmpb   $0x0,(%rdx,%rax,1)
>    b:	75 56                	jne    0x63
>    d:	48 b8 00 00 00 00 00 	movabs $0xdffffc0000000000,%rax
>   14:	fc ff df
>   17:	48 8b 1b             	mov    (%rbx),%rbx
>   1a:	48 8d 7b 70          	lea    0x70(%rbx),%rdi
>   1e:	48 89 fa             	mov    %rdi,%rdx
>   21:	48 c1 ea 03          	shr    $0x3,%rdx
> * 25:	80 3c 02 00          	cmpb   $0x0,(%rdx,%rax,1) <-- trapping instruction
>   29:	75 42                	jne    0x6d
>   2b:	48 8b 7b 70          	mov    0x70(%rbx),%rdi
>   2f:	e8 95 9e ae f9       	callq  0xf9ae9ec9
>   34:	5b                   	pop    %rbx
>   35:	5d                   	pop    %rbp
>   36:	41 5c                	pop    %r12
>   38:	41 5d                	pop    %r13
>   3a:	e9                   	.byte 0xe9


Stefano, Stefan, take a look?


> 
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
> 
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> 
> If the bug is already fixed, let syzbot know by replying with:
> #syz fix: exact-commit-title
> 
> If you want to change bug's subsystems, reply with:
> #syz set subsystems: new-subsystem
> (See the list of subsystem names on the web dashboard)
> 
> If the bug is a duplicate of another bug, reply with:
> #syz dup: exact-subject-of-another-report
> 
> If you want to undo deduplication, reply with:
> #syz undup



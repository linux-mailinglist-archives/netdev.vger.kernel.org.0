Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8826C4BE058
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 18:51:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358689AbiBUNNM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 08:13:12 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:47976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358698AbiBUNNL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 08:13:11 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2EA761EEED
        for <netdev@vger.kernel.org>; Mon, 21 Feb 2022 05:12:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645449164;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ppzDXyf5qUdHu/qahqx1jXO12LO18Enabwf41mMpCt8=;
        b=IOwk5MKe9kIOVB+csNMhUi441rxnrpuchtH0lJ6pgoJ3hfaAWxr8HqO+o9c98blavp2H7Z
        Cblf/39v+KhQOEqIS+1hyV7AKnr21DOsYOT1tJRpwR4MPI5cpgImWe9TAUWVhz7egZghlc
        qrCroY2XNNgF9i8DhSBHPkNGTpaBCXQ=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-627-J7cc0K0pMUWFoN_G6Wr0gQ-1; Mon, 21 Feb 2022 08:12:41 -0500
X-MC-Unique: J7cc0K0pMUWFoN_G6Wr0gQ-1
Received: by mail-wm1-f69.google.com with SMTP id r8-20020a7bc088000000b0037bbf779d26so4432590wmh.7
        for <netdev@vger.kernel.org>; Mon, 21 Feb 2022 05:12:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ppzDXyf5qUdHu/qahqx1jXO12LO18Enabwf41mMpCt8=;
        b=8MC6+P8OSwdIbgzI6iMIXjSXW2BSS1Au02FFUdNm05Sxe/vJUVjAtkwJrvIlJVEBP4
         clQ5/MEe4/nzI9zkCK4Nz32g3CqTUeOpSbyTXqjYd4Jz1TChmshTQIE7khgoHvruwXsL
         4Y6EPtowcw76TkS3VaJeyQQZc+gag21bqBThEQq3sS8l+/rkDkMoJ+cIGri5XJDCwF/6
         VhKoZkwNFGWV/k7aifLjYbiI2SeC/7cK8oHePZ/eqXrgOnFpPZHxdNKpvM/ZVBz40kfv
         XSvy93Fsh1AYt83IVSMPvxzDDkAmMukOQ7HurkgjJDWDtIUZJEJFOMMz0pWmeZFneBaV
         LaCw==
X-Gm-Message-State: AOAM532Y0cQ6rMQhvmhkR4DZ61OL1fAbZF7YDxn3mq3NnF3h74GLH0B5
        s17Zyrom7cZ+Fso9P/9s4+YKRxDeMvWnEz/OBtxxrlroIT7o2GYNNZLHHKTIpz8phwgNP53BcLh
        vzEHvNjotGlzHHFdS
X-Received: by 2002:a5d:46d2:0:b0:1e4:a653:e010 with SMTP id g18-20020a5d46d2000000b001e4a653e010mr16634536wrs.77.1645449160023;
        Mon, 21 Feb 2022 05:12:40 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzU8ZEgdy82UVhvG2xdvSW8GSdGfZpb0TmrUMBvl4ZKTzAJyuQlzFVef+h5XXvOG89RBX1XXA==
X-Received: by 2002:a5d:46d2:0:b0:1e4:a653:e010 with SMTP id g18-20020a5d46d2000000b001e4a653e010mr16634524wrs.77.1645449159811;
        Mon, 21 Feb 2022 05:12:39 -0800 (PST)
Received: from sgarzare-redhat (host-95-248-229-156.retail.telecomitalia.it. [95.248.229.156])
        by smtp.gmail.com with ESMTPSA id f7sm43525089wrz.40.2022.02.21.05.12.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Feb 2022 05:12:39 -0800 (PST)
Date:   Mon, 21 Feb 2022 14:12:36 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     syzbot <syzbot+bbb030fc51d6f3c5d067@syzkaller.appspotmail.com>
Cc:     jasowang@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, mst@redhat.com,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        virtualization@lists.linux-foundation.org
Subject: Re: [syzbot] general protection fault in vhost_iotlb_itree_first
Message-ID: <20220221131236.ekihumv67fpsjsoq@sgarzare-redhat>
References: <0000000000003d82b405d85b7be9@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <0000000000003d82b405d85b7be9@google.com>
X-Spam-Status: No, score=-0.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

#syz test: https://github.com/stefano-garzarella/linux.git vsock-fix-stop

On Sat, Feb 19, 2022 at 01:18:24AM -0800, syzbot wrote:
>Hello,
>
>syzbot found the following issue on:
>
>HEAD commit:    359303076163 tty: n_tty: do not look ahead for EOL charact..
>git tree:       upstream
>console output: https://syzkaller.appspot.com/x/log.txt?x=16b34b54700000
>kernel config:  https://syzkaller.appspot.com/x/.config?x=da674567f7b6043d
>dashboard link: https://syzkaller.appspot.com/bug?extid=bbb030fc51d6f3c5d067
>compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
>
>Unfortunately, I don't have any reproducer for this issue yet.
>
>IMPORTANT: if you fix the issue, please add the following tag to the commit:
>Reported-by: syzbot+bbb030fc51d6f3c5d067@syzkaller.appspotmail.com
>
>general protection fault, probably for non-canonical address 0xdffffc0000000000: 0000 [#1] PREEMPT SMP KASAN
>KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
>CPU: 1 PID: 17981 Comm: vhost-17980 Not tainted 5.17.0-rc4-syzkaller-00052-g359303076163 #0
>Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
>RIP: 0010:vhost_iotlb_itree_iter_first drivers/vhost/iotlb.c:19 [inline]
>RIP: 0010:vhost_iotlb_itree_first+0x29/0x280 drivers/vhost/iotlb.c:169
>Code: 00 41 57 41 56 41 55 49 89 d5 41 54 55 48 89 fd 53 48 89 f3 e8 e8 eb a0 fa 48 89 ea 48 b8 00 00 00 00 00 fc ff df 48 c1 ea 03 <80> 3c 02 00 0f 85 e8 01 00 00 4c 8b 65 00 4d 85 e4 0f 84 b3 01 00
>RSP: 0018:ffffc90004f57ac8 EFLAGS: 00010246
>RAX: dffffc0000000000 RBX: 30303030320a0028 RCX: ffffc900103dc000
>RDX: 0000000000000000 RSI: ffffffff86d72738 RDI: 0000000000000000
>RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000002
>R10: ffffffff86d62d88 R11: 0000000000000000 R12: ffff8880260e4d68
>R13: 303030305f3a3057 R14: dffffc0000000000 R15: 0000000000000000
>FS:  0000000000000000(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
>CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>CR2: 00007f2d46121901 CR3: 000000001d652000 CR4: 00000000003506e0
>DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
>Call Trace:
> <TASK>
> translate_desc+0x11e/0x3e0 drivers/vhost/vhost.c:2054
> vhost_get_vq_desc+0x662/0x22c0 drivers/vhost/vhost.c:2300
> vhost_vsock_handle_tx_kick+0x277/0xa20 drivers/vhost/vsock.c:522
> vhost_worker+0x23d/0x3d0 drivers/vhost/vhost.c:372
> kthread+0x2e9/0x3a0 kernel/kthread.c:377
> ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
> </TASK>
>Modules linked in:
>---[ end trace 0000000000000000 ]---
>RIP: 0010:vhost_iotlb_itree_iter_first drivers/vhost/iotlb.c:19 [inline]
>RIP: 0010:vhost_iotlb_itree_first+0x29/0x280 drivers/vhost/iotlb.c:169
>Code: 00 41 57 41 56 41 55 49 89 d5 41 54 55 48 89 fd 53 48 89 f3 e8 e8 eb a0 fa 48 89 ea 48 b8 00 00 00 00 00 fc ff df 48 c1 ea 03 <80> 3c 02 00 0f 85 e8 01 00 00 4c 8b 65 00 4d 85 e4 0f 84 b3 01 00
>RSP: 0018:ffffc90004f57ac8 EFLAGS: 00010246
>RAX: dffffc0000000000 RBX: 30303030320a0028 RCX: ffffc900103dc000
>RDX: 0000000000000000 RSI: ffffffff86d72738 RDI: 0000000000000000
>RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000002
>R10: ffffffff86d62d88 R11: 0000000000000000 R12: ffff8880260e4d68
>R13: 303030305f3a3057 R14: dffffc0000000000 R15: 0000000000000000
>FS:  0000000000000000(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
>CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>CR2: 00007f2d449f6718 CR3: 000000001d652000 CR4: 00000000003506e0
>DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
>----------------
>Code disassembly (best guess):
>   0:	00 41 57             	add    %al,0x57(%rcx)
>   3:	41 56                	push   %r14
>   5:	41 55                	push   %r13
>   7:	49 89 d5             	mov    %rdx,%r13
>   a:	41 54                	push   %r12
>   c:	55                   	push   %rbp
>   d:	48 89 fd             	mov    %rdi,%rbp
>  10:	53                   	push   %rbx
>  11:	48 89 f3             	mov    %rsi,%rbx
>  14:	e8 e8 eb a0 fa       	callq  0xfaa0ec01
>  19:	48 89 ea             	mov    %rbp,%rdx
>  1c:	48 b8 00 00 00 00 00 	movabs $0xdffffc0000000000,%rax
>  23:	fc ff df
>  26:	48 c1 ea 03          	shr    $0x3,%rdx
>* 2a:	80 3c 02 00          	cmpb   $0x0,(%rdx,%rax,1) <-- trapping instruction
>  2e:	0f 85 e8 01 00 00    	jne    0x21c
>  34:	4c 8b 65 00          	mov    0x0(%rbp),%r12
>  38:	4d 85 e4             	test   %r12,%r12
>  3b:	0f                   	.byte 0xf
>  3c:	84                   	.byte 0x84
>  3d:	b3 01                	mov    $0x1,%bl
>
>
>---
>This report is generated by a bot. It may contain errors.
>See https://goo.gl/tpsmEJ for more information about syzbot.
>syzbot engineers can be reached at syzkaller@googlegroups.com.
>
>syzbot will keep track of this issue. See:
>https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
>


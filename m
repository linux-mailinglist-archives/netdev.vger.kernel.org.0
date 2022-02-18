Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45FD74BB857
	for <lists+netdev@lfdr.de>; Fri, 18 Feb 2022 12:39:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234602AbiBRLjc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Feb 2022 06:39:32 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:46916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234884AbiBRLjA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Feb 2022 06:39:00 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 05A013152E
        for <netdev@vger.kernel.org>; Fri, 18 Feb 2022 03:37:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645184253;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=kRz2HhmPOJqUdEguD6ineI0jgT8YXoXhvMfK4d0/iRk=;
        b=iZ8JXWnJegYuprPViiFj2S44PQ5iqRXJGJHJRk8YfDqhz7va0cVkg6kWlG4cwcBN6x2pCA
        9fazozbtoSl1s2Rhbqr0EH5/lxR42g1nYTgNTZkz85TOWE3VsRg/zbtTgvTKxOBhsXjZgi
        V3ZipINj24mTyr6QYckhe1LKrV7RcMo=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-462-96c3APvqM0iXnnz9OXDZyQ-1; Fri, 18 Feb 2022 06:37:32 -0500
X-MC-Unique: 96c3APvqM0iXnnz9OXDZyQ-1
Received: by mail-ed1-f70.google.com with SMTP id j29-20020a508a9d000000b00412aa79f367so2512386edj.0
        for <netdev@vger.kernel.org>; Fri, 18 Feb 2022 03:37:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=kRz2HhmPOJqUdEguD6ineI0jgT8YXoXhvMfK4d0/iRk=;
        b=dmli7a1hAb2NHo0oLGiQjaaqhsUAgpeLDwj8ymdTAwYcmyNwWiOdvqMEQRJEzrzais
         /RrguYQcEYVqsNEdyTzQ6Hr+G0WS70BkPrPvp9bPo6hDeo+8SwWhjEQn8A4fNsmTCh9q
         IuAhshSbHEhNIG0vBHmfLFGIii+bNyJfREshPutBp/VKwO/u3kkrpUIosRfWyJaIl0m6
         Ar8Q2aofXiEkWhu6tWBDaKtJX4HyMtavf8PY7fi1u+uygxFVvlWcASQvBeDiKTNT9cM3
         5a+0QeEU9nyX4W94G7ullA7+JRv3Jt3yWIMBOzt34bZy7x7e2C6FyIVI39Fw9GcTMvPA
         L3hw==
X-Gm-Message-State: AOAM532iGRSgYodSYox6f8LA4876Pqn6pIYmW0kzpAGK5ePMpwYXHNMw
        68zMZObRFUyShMckHORTPuXG+PF32/YCFgxMEZ0ugyKYfz1QwCeyaiM3dHfZk4lVzEjIfgNgIUo
        Yu2os10ZSwh1f5bMU
X-Received: by 2002:a17:906:f293:b0:6b6:bc93:f01f with SMTP id gu19-20020a170906f29300b006b6bc93f01fmr5656029ejb.743.1645184251241;
        Fri, 18 Feb 2022 03:37:31 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyumwEeTQqcko1h2tOqCFdEjZvTGldy8JfDmmW/0pXvLQMU7H6ovgQWyZGrpbpB4r5tpsNPFQ==
X-Received: by 2002:a17:906:f293:b0:6b6:bc93:f01f with SMTP id gu19-20020a170906f29300b006b6bc93f01fmr5656019ejb.743.1645184251001;
        Fri, 18 Feb 2022 03:37:31 -0800 (PST)
Received: from redhat.com ([2.55.156.211])
        by smtp.gmail.com with ESMTPSA id z18sm2209291ejl.78.2022.02.18.03.37.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Feb 2022 03:37:30 -0800 (PST)
Date:   Fri, 18 Feb 2022 06:37:26 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     syzbot <syzbot+3140b17cb44a7b174008@syzkaller.appspotmail.com>
Cc:     jasowang@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com,
        virtualization@lists.linux-foundation.org
Subject: Re: [syzbot] kernel BUG in vhost_get_vq_desc
Message-ID: <20220218063352-mutt-send-email-mst@kernel.org>
References: <00000000000070ac6505d7d9f7a8@google.com>
 <0000000000003b07b305d840b30f@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0000000000003b07b305d840b30f@google.com>
X-Spam-Status: No, score=-0.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 17, 2022 at 05:21:20PM -0800, syzbot wrote:
> syzbot has found a reproducer for the following issue on:
> 
> HEAD commit:    f71077a4d84b Merge tag 'mmc-v5.17-rc1-2' of git://git.kern..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=104c04ca700000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=a78b064590b9f912
> dashboard link: https://syzkaller.appspot.com/bug?extid=3140b17cb44a7b174008
> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1362e232700000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=11373a6c700000
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+3140b17cb44a7b174008@syzkaller.appspotmail.com
> 
> ------------[ cut here ]------------
> kernel BUG at drivers/vhost/vhost.c:2335!
> invalid opcode: 0000 [#1] PREEMPT SMP KASAN
> CPU: 1 PID: 3597 Comm: vhost-3596 Not tainted 5.17.0-rc4-syzkaller-00054-gf71077a4d84b #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> RIP: 0010:vhost_get_vq_desc+0x1d43/0x22c0 drivers/vhost/vhost.c:2335
> Code: 00 00 00 48 c7 c6 20 2c 9d 8a 48 c7 c7 98 a6 8e 8d 48 89 ca 48 c1 e1 04 48 01 d9 e8 b7 59 28 fd e9 74 ff ff ff e8 5d c8 a1 fa <0f> 0b e8 56 c8 a1 fa 48 8b 54 24 18 48 b8 00 00 00 00 00 fc ff df
> RSP: 0018:ffffc90001d1fb88 EFLAGS: 00010293
> RAX: 0000000000000000 RBX: 0000000000000001 RCX: 0000000000000000
> RDX: ffff8880234b0000 RSI: ffffffff86d715c3 RDI: 0000000000000003
> RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000001
> R10: ffffffff86d706bc R11: 0000000000000000 R12: ffff888072c24d68
> R13: 0000000000000000 R14: dffffc0000000000 R15: ffff888072c24bb0
> FS:  0000000000000000(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000000000002 CR3: 000000007902c000 CR4: 00000000003506e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>  <TASK>
>  vhost_vsock_handle_tx_kick+0x277/0xa20 drivers/vhost/vsock.c:522
>  vhost_worker+0x23d/0x3d0 drivers/vhost/vhost.c:372
>  kthread+0x2e9/0x3a0 kernel/kthread.c:377
>  ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295

I don't see how this can trigger normally so I'm assuming
another case of use after free.

>  </TASK>
> Modules linked in:
> ---[ end trace 0000000000000000 ]---
> RIP: 0010:vhost_get_vq_desc+0x1d43/0x22c0 drivers/vhost/vhost.c:2335
> Code: 00 00 00 48 c7 c6 20 2c 9d 8a 48 c7 c7 98 a6 8e 8d 48 89 ca 48 c1 e1 04 48 01 d9 e8 b7 59 28 fd e9 74 ff ff ff e8 5d c8 a1 fa <0f> 0b e8 56 c8 a1 fa 48 8b 54 24 18 48 b8 00 00 00 00 00 fc ff df
> RSP: 0018:ffffc90001d1fb88 EFLAGS: 00010293
> RAX: 0000000000000000 RBX: 0000000000000001 RCX: 0000000000000000
> RDX: ffff8880234b0000 RSI: ffffffff86d715c3 RDI: 0000000000000003
> RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000001
> R10: ffffffff86d706bc R11: 0000000000000000 R12: ffff888072c24d68
> R13: 0000000000000000 R14: dffffc0000000000 R15: ffff888072c24bb0
> FS:  0000000000000000(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000000000002 CR3: 000000007902c000 CR4: 00000000003506e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


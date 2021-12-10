Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F8874708DA
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 19:32:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244799AbhLJSgZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 13:36:25 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:44710 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242477AbhLJSgZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Dec 2021 13:36:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1639161169;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Kt1qUXwiy/M31h3PAsT3UJdAEhB+D0aZE8YQxUWp/Zg=;
        b=h8hAnJLXEmqHCd49Ihd5vtYXmLrsHMw9xMgddIeyqEDoyebZ+e72ExKmqc32TCUenj0sBh
        lZpQle1t38vtvF61AiVSL0ue+MgNoLKT1Dlm/TckQT/W0K99OUG14R3ddeI9jDEB9ZzHer
        EBdUJDv7BpknHbqSpelF/BGBanZk5+8=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-161-K1GtQkt3OgKSkFk7YubRdw-1; Fri, 10 Dec 2021 13:32:48 -0500
X-MC-Unique: K1GtQkt3OgKSkFk7YubRdw-1
Received: by mail-qv1-f69.google.com with SMTP id kc26-20020a056214411a00b003cabea18f69so15336418qvb.19
        for <netdev@vger.kernel.org>; Fri, 10 Dec 2021 10:32:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=Kt1qUXwiy/M31h3PAsT3UJdAEhB+D0aZE8YQxUWp/Zg=;
        b=drEmm6ish3fhTl7GpC7YZQHRRPo4Gmevaqu+Jg5W4tWphzthNeudrtoOjnuiXA1ctD
         cx08oFDFMbCjKE1mRGdUTynON04IQwzGQYcg8O8QSwxjrb5egQaUWptoNfWzwCckWgAh
         uzUp50l1O9yn+4+PANMRRiFCKnWjeF3ZWHPO4kIeTgtPzqq9aimAQ4whghtFbfiWiUFN
         2b0vIShrks4cd1uANSpwRhsUFF3RgxVX3KTJ5EVoPieY2RqGu36W+VraemArpfgbsIxk
         IjUJ7pvGzNl+HwixEIHKJ+g36cGpsf88/VXXH8ctmoGByOzJnWWoW+JMdoxhxphQ7I8w
         3G6w==
X-Gm-Message-State: AOAM531RZnZgvYxbDROVmmOL+zI3JX5bKoWLP1FLJmiluzKqvMiJBKDX
        jf6Gf4zuz83SvYEAUS0qKNWbP4sJhMEJMsbXTASTXdmf93Suo2sZaV11+FcTlmQlYAkl+XIyrjP
        bJiEqMAU68jXvEscWYgmhBF5qTS29n5btuXu8XUGZPB4eJPLvrH7D6IBSy4yOd2ONLQ==
X-Received: by 2002:a05:620a:f8b:: with SMTP id b11mr21469956qkn.81.1639161167680;
        Fri, 10 Dec 2021 10:32:47 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyELrIip8yLlVvpkVIazSZWXAsjANV2Q6PhnPbtmrx3+vcEED5GShpCCuhMdTha8knAGO8N8w==
X-Received: by 2002:a05:620a:f8b:: with SMTP id b11mr21469911qkn.81.1639161167375;
        Fri, 10 Dec 2021 10:32:47 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-237-50.dyn.eolo.it. [146.241.237.50])
        by smtp.gmail.com with ESMTPSA id z8sm2526312qta.50.2021.12.10.10.32.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Dec 2021 10:32:46 -0800 (PST)
Message-ID: <f813f1fc5e646349b36a1d9acb425d4a6878065f.camel@redhat.com>
Subject: Re: [PATCH net] mptcp: fix NULL ptr dereference in inet_csk_accept()
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     mptcp@lists.linux.dev, Geliang Tang <geliangtang@gmail.com>
Date:   Fri, 10 Dec 2021 19:32:43 +0100
In-Reply-To: <299865ffd73315ea549ed4a8026783633203a237.1639155048.git.pabeni@redhat.com>
References: <299865ffd73315ea549ed4a8026783633203a237.1639155048.git.pabeni@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.1 (3.42.1-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2021-12-10 at 17:51 +0100, Paolo Abeni wrote:
> Since commit 740d798e8767 ("mptcp: remove id 0 address"), the PM
> can remove the MPTCP first subflow in response to the netlink DEL_ADDR
> command. At subflow removal time, the TCP subflow socket is orphaned.
> 
> If the relevant MPTCP socket is in listening status and such
> operation races with an accept(), the kernel will access a NULL wait
> queue, as reported by syzbot:
> 
> general protection fault, probably for non-canonical address 0xdffffc0000000003: 0000 [#1] PREEMPT SMP KASAN
> KASAN: null-ptr-deref in range [0x0000000000000018-0x000000000000001f]
> CPU: 1 PID: 6550 Comm: syz-executor122 Not tainted 5.16.0-rc4-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> RIP: 0010:__lock_acquire+0xd7d/0x54a0 kernel/locking/lockdep.c:4897
> Code: 0f 0e 41 be 01 00 00 00 0f 86 c8 00 00 00 89 05 69 cc 0f 0e e9 bd 00 00 00 48 b8 00 00 00 00 00 fc ff df 48 89 da 48 c1 ea 03 <80> 3c 02 00 0f 85 f3 2f 00 00 48 81 3b 20 75 17 8f 0f 84 52 f3 ff
> RSP: 0018:ffffc90001f2f818 EFLAGS: 00010016
> RAX: dffffc0000000000 RBX: 0000000000000018 RCX: 0000000000000000
> RDX: 0000000000000003 RSI: 0000000000000000 RDI: 0000000000000001
> RBP: 0000000000000000 R08: 0000000000000001 R09: 0000000000000001
> R10: 0000000000000000 R11: 000000000000000a R12: 0000000000000000
> R13: ffff88801b98d700 R14: 0000000000000000 R15: 0000000000000001
> FS:  00007f177cd3d700(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f177cd1b268 CR3: 000000001dd55000 CR4: 0000000000350ee0
> Call Trace:
>  <TASK>
>  lock_acquire kernel/locking/lockdep.c:5637 [inline]
>  lock_acquire+0x1ab/0x510 kernel/locking/lockdep.c:5602
>  __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:110 [inline]
>  _raw_spin_lock_irqsave+0x39/0x50 kernel/locking/spinlock.c:162
>  finish_wait+0xc0/0x270 kernel/sched/wait.c:400
>  inet_csk_wait_for_connect net/ipv4/inet_connection_sock.c:464 [inline]
>  inet_csk_accept+0x7de/0x9d0 net/ipv4/inet_connection_sock.c:497
>  mptcp_accept+0xe5/0x500 net/mptcp/protocol.c:2865
>  inet_accept+0xe4/0x7b0 net/ipv4/af_inet.c:739
>  mptcp_stream_accept+0x2e7/0x10e0 net/mptcp/protocol.c:3345
>  do_accept+0x382/0x510 net/socket.c:1773
>  __sys_accept4_file+0x7e/0xe0 net/socket.c:1816
>  __sys_accept4+0xb0/0x100 net/socket.c:1846
>  __do_sys_accept net/socket.c:1864 [inline]
>  __se_sys_accept net/socket.c:1861 [inline]
>  __x64_sys_accept+0x71/0xb0 net/socket.c:1861
>  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>  do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
>  entry_SYSCALL_64_after_hwframe+0x44/0xae
> RIP: 0033:0x7f177cd8b8e9
> Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 b1 14 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007f177cd3d308 EFLAGS: 00000246 ORIG_RAX: 000000000000002b
> RAX: ffffffffffffffda RBX: 00007f177ce13408 RCX: 00007f177cd8b8e9
> RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000003
> RBP: 00007f177ce13400 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 00007f177ce1340c
> R13: 00007f177cde1004 R14: 6d705f706374706d R15: 0000000000022000
>  </TASK>
> 
> Fix the issue explicitly preventing the PM from closing subflows
> of MPTCP socket in listener status.
> 
> Reported-and-tested-by: syzbot+e4d843bb96a9431e6331@syzkaller.appspotmail.com
> Fixes: 740d798e8767 ("mptcp: remove id 0 address")
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>

I'm dumb. We have likely a better fix for this one. I initially thought
it was not suitable for -net... as I was looking to the wrong patch :(

Self-nack, I'll test and send the other patch.

Sorry for the noise.

Paolo


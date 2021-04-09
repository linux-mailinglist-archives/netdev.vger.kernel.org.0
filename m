Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 479AB35A74C
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 21:45:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234370AbhDITpP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Apr 2021 15:45:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233883AbhDITpN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Apr 2021 15:45:13 -0400
Received: from mail-il1-x12a.google.com (mail-il1-x12a.google.com [IPv6:2607:f8b0:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB462C061763;
        Fri,  9 Apr 2021 12:44:59 -0700 (PDT)
Received: by mail-il1-x12a.google.com with SMTP id c15so5687517ilj.1;
        Fri, 09 Apr 2021 12:44:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:message-id:in-reply-to:references:subject:mime-version
         :content-transfer-encoding;
        bh=ILKO2BUOCLqlGNaUtFDszjRt1SnqMhsCCWI06F3bjyk=;
        b=pQ4QCwsGKRwX1SAKvUsD5e92sktfxacpzJaVWVsg7zQLcgJnUMMSe0t+cjkIBTW6tn
         0zEBHMVa+EKwc2ORtpGRAyr19FSD/DJjyvF5mqGv/JNOXri4rg2BcI4P8EH83YzS4OPP
         l+i9xKF4RZDCjUwbg5fJxRZDpO0O+9kCkiHa78B7ridDzonL+EGKttXolKns0quz+M89
         d6X1GC93ES2esliDAcsq2czE89uM3fQV2tjUUMCpZ1EWWIGdNGsdA7nvmDzv3OHtT5rh
         HFYbFYqnUYM9cMNm3oTw6KsbvwMeq43K2VDx955DnDn2x4PhpjhdGMmpU089C6VC9kBu
         lIVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:message-id:in-reply-to:references
         :subject:mime-version:content-transfer-encoding;
        bh=ILKO2BUOCLqlGNaUtFDszjRt1SnqMhsCCWI06F3bjyk=;
        b=M+v8UsyOXu3jy8y9gEl+IUBeU7iCut0q+lbcY6HV2WIxRUovfINd2msJ4QNSTp9XtP
         r82Z+v+Qp5oY/uvi8Q1Zh0Bfk3HiWZWdVLCKSYzF217lLNH+da/fhnAiezpshgP7MmWu
         0negMlkAoQsSla7EBp9C1Q6OCCaPtEmOWa3d2meOlNxgnxN4YMeQYsGu3Gbot1J+fCxT
         TlfN30SyYuy2R6o12YKC09fq7FxfDlmZemaroOzws7fNhgD3HkKIpODCTYeP/CiAjg0F
         LKNJQROMT0zWIZhtxtmkzI/PDruxm6kv6qCNOjWrEoa1e7XuA6rGtkyn7nZ5CblPahRA
         VJ1w==
X-Gm-Message-State: AOAM530sE/dV+T+VOWJZmIF4Hp4zc+rPoFgW22gciqA3ps3Qzk+OFEif
        S0720qQwvptuEjelgGHW2D8O/nZbLLJcOA==
X-Google-Smtp-Source: ABdhPJw+QANABliZ7wrqd0rUsdbLBevDDtEyXTktEHe76D8xqfvOHBdMFGkx4i7+lNljiXJKlK9p2g==
X-Received: by 2002:a05:6e02:12b4:: with SMTP id f20mr10979557ilr.212.1617997499309;
        Fri, 09 Apr 2021 12:44:59 -0700 (PDT)
Received: from localhost ([172.242.244.146])
        by smtp.gmail.com with ESMTPSA id i12sm1549192ila.1.2021.04.09.12.44.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Apr 2021 12:44:58 -0700 (PDT)
Date:   Fri, 09 Apr 2021 12:44:53 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     syzbot <syzbot+b54a1ce86ba4a623b7f0@syzkaller.appspotmail.com>,
        akpm@linux-foundation.org, andrii@kernel.org, ast@kernel.org,
        borisp@nvidia.com, bp@alien8.de, bpf@vger.kernel.org,
        daniel@iogearbox.net, davem@davemloft.net, hpa@zytor.com,
        jmattson@google.com, john.fastabend@gmail.com, joro@8bytes.org,
        kafai@fb.com, kpsingh@kernel.org, kuba@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        mark.rutland@arm.com, masahiroy@kernel.org, mingo@redhat.com,
        netdev@vger.kernel.org, pbonzini@redhat.com, peterz@infradead.org,
        rafael.j.wysocki@intel.com, rostedt@goodmis.org, seanjc@google.com,
        songliubraving@fb.com, syzkaller-bugs@googlegroups.com,
        tglx@linutronix.de, vkuznets@redhat.com, wanpengli@tencent.com,
        will@kernel.org, x86@kernel.org, yhs@fb.com
Message-ID: <6070aeb52e91d_4526f208de@john-XPS-13-9370.notmuch>
In-Reply-To: <0000000000007b81f905bf8bf7ac@google.com>
References: <0000000000007b81f905bf8bf7ac@google.com>
Subject: RE: [syzbot] WARNING: refcount bug in sk_psock_get
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    9c54130c Add linux-next specific files for 20210406
> git tree:       linux-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=17d8d7aad00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=d125958c3995ddcd
> dashboard link: https://syzkaller.appspot.com/bug?extid=b54a1ce86ba4a623b7f0
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1729797ed00000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1190f46ad00000
> 
> The issue was bisected to:
> 
> commit 997acaf6b4b59c6a9c259740312a69ea549cc684
> Author: Mark Rutland <mark.rutland@arm.com>
> Date:   Mon Jan 11 15:37:07 2021 +0000
> 
>     lockdep: report broken irq restoration
> 
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=11a6cc96d00000
> final oops:     https://syzkaller.appspot.com/x/report.txt?x=13a6cc96d00000
> console output: https://syzkaller.appspot.com/x/log.txt?x=15a6cc96d00000
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+b54a1ce86ba4a623b7f0@syzkaller.appspotmail.com
> Fixes: 997acaf6b4b5 ("lockdep: report broken irq restoration")
> 
> ------------[ cut here ]------------
> refcount_t: saturated; leaking memory.
> WARNING: CPU: 1 PID: 8414 at lib/refcount.c:19 refcount_warn_saturate+0xf4/0x1e0 lib/refcount.c:19
> Modules linked in:
> CPU: 1 PID: 8414 Comm: syz-executor793 Not tainted 5.12.0-rc6-next-20210406-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> RIP: 0010:refcount_warn_saturate+0xf4/0x1e0 lib/refcount.c:19
> Code: 1d 69 0c e6 09 31 ff 89 de e8 c8 b4 a6 fd 84 db 75 ab e8 0f ae a6 fd 48 c7 c7 e0 52 c2 89 c6 05 49 0c e6 09 01 e8 91 0f 00 05 <0f> 0b eb 8f e8 f3 ad a6 fd 0f b6 1d 33 0c e6 09 31 ff 89 de e8 93
> RSP: 0018:ffffc90000eef388 EFLAGS: 00010282
> RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
> RDX: ffff88801bbdd580 RSI: ffffffff815c2e05 RDI: fffff520001dde63
> RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
> R10: ffffffff815bcc6e R11: 0000000000000000 R12: 1ffff920001dde74
> R13: 0000000090200301 R14: ffff888026e00000 R15: ffffc90000eef3c0
> FS:  0000000001422300(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000020000000 CR3: 0000000012b3b000 CR4: 00000000001506e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>  __refcount_add_not_zero include/linux/refcount.h:163 [inline]
>  __refcount_inc_not_zero include/linux/refcount.h:227 [inline]
>  refcount_inc_not_zero include/linux/refcount.h:245 [inline]
>  sk_psock_get+0x3b0/0x400 include/linux/skmsg.h:435
>  bpf_exec_tx_verdict+0x11e/0x11a0 net/tls/tls_sw.c:799
>  tls_sw_sendmsg+0xa41/0x1800 net/tls/tls_sw.c:1013
>  inet_sendmsg+0x99/0xe0 net/ipv4/af_inet.c:821

[...]

This is likely a problem with latest round of sockmap patches I'll
tke a look.

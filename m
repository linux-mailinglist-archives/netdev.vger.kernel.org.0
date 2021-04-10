Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14FD335AF16
	for <lists+netdev@lfdr.de>; Sat, 10 Apr 2021 18:42:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234856AbhDJQmR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Apr 2021 12:42:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234392AbhDJQmP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Apr 2021 12:42:15 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCF54C06138A;
        Sat, 10 Apr 2021 09:42:00 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id o123so6323565pfb.4;
        Sat, 10 Apr 2021 09:42:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5KHrjLMdFuGc3XdeY94LPmGiY27g0GenWDy/cdIHxcc=;
        b=Ehagiz6FmuauDSmrG5zS3SSpOX2LJb98EgNAi+2XotiAB/JkgYKvuaBwjafp5PdiO7
         MPbwAGzCCAfwB7MyRjp6YXY1SNt1ZcHwnd6NjehATdGGI4VBSNReTaoUPgjcuMaa6NEs
         j+Tpf3069X/hc9k2amgmV/Uo8kg6Cf+7Bh5B15hMXNo8fOoNX9CCIQYFb0cFASb4wfLj
         BgeyP5CkYGwV+yj5CglvnjuFGjKL8A40QWQ31xKpeI7bxIwKF+xRgpStGPATCC76N6+4
         VHy/VbABtVL7YkSHEP1rCj9mc8FFpXMCx6qDQxz3789UR2983aYjckZHK0AdqxGFBio6
         BWwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5KHrjLMdFuGc3XdeY94LPmGiY27g0GenWDy/cdIHxcc=;
        b=feaovmX7W/ZTdLzlG7VjhVM2XZj3wUkL+1HZUpOOC8HajREjWC6zYiLu4J+iH8DpM0
         Bl5sTihuh4iCLXVY/+8fhP3B3m489ahSTI2YI52o2tT3p4CZCvvVzNNnF2z7gZZA8k03
         Z/vdrCDkOMypwbyGCpIWgRo6upjslcjTp5oFdJY5wcdl4ty0FNGaYETJhbeNZvPli1j9
         0DzUS4n+yxXHcmH9h3LxYHWyjiWBtE9iORh20C7ueV6j+viwOQR82t7w5OTlJPsf0Pjh
         EBFIx2WDYk2OkGv6lKeDPPG2x1LjPF9WYgH9nxXbbzceJt4aP1xvzVZxR6pYEjHPmN1V
         wJmg==
X-Gm-Message-State: AOAM531IJSvHBQhX13XjPWoyOZQwIW73RHiqpAG4t07Xlj/2Fc5ifrI7
        IST2sMb0fsuTY67fxX8QzYgPkxJXt3+0eyPt4Yg=
X-Google-Smtp-Source: ABdhPJxGSKlNFP2bgWae50O7f9Gp0jg23Yn0nS6LmbrZPJPluMI9xJ33JuCKlaHCjtkBcIev9mutTHVZ83jE2PrHcoM=
X-Received: by 2002:a62:fb14:0:b029:22e:e189:c6b1 with SMTP id
 x20-20020a62fb140000b029022ee189c6b1mr17853998pfm.31.1618072920143; Sat, 10
 Apr 2021 09:42:00 -0700 (PDT)
MIME-Version: 1.0
References: <0000000000007b81f905bf8bf7ac@google.com> <6070aeb52e91d_4526f208de@john-XPS-13-9370.notmuch>
In-Reply-To: <6070aeb52e91d_4526f208de@john-XPS-13-9370.notmuch>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Sat, 10 Apr 2021 09:41:49 -0700
Message-ID: <CAM_iQpWpw9XCLrg3y8t9-mYVOpJtL9fXWfeXD7zS52qeTCoDLg@mail.gmail.com>
Subject: Re: [syzbot] WARNING: refcount bug in sk_psock_get
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     syzbot <syzbot+b54a1ce86ba4a623b7f0@syzkaller.appspotmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>, borisp@nvidia.com,
        Borislav Petkov <bp@alien8.de>, bpf <bpf@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        "H. Peter Anvin" <hpa@zytor.com>, jmattson@google.com,
        Joerg Roedel <joro@8bytes.org>,
        Martin KaFai Lau <kafai@fb.com>, kpsingh@kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        "kvm@vger.kernel.org list" <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Mark Rutland <mark.rutland@arm.com>, masahiroy@kernel.org,
        Ingo Molnar <mingo@redhat.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        pbonzini@redhat.com, Peter Zijlstra <peterz@infradead.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Steven Rostedt <rostedt@goodmis.org>, seanjc@google.com,
        Song Liu <songliubraving@fb.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Thomas Gleixner <tglx@linutronix.de>, vkuznets@redhat.com,
        wanpengli@tencent.com, Will Deacon <will@kernel.org>,
        x86 <x86@kernel.org>, Yonghong Song <yhs@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 9, 2021 at 12:45 PM John Fastabend <john.fastabend@gmail.com> wrote:
>
> syzbot wrote:
> > Hello,
> >
> > syzbot found the following issue on:
> >
> > HEAD commit:    9c54130c Add linux-next specific files for 20210406
> > git tree:       linux-next
> > console output: https://syzkaller.appspot.com/x/log.txt?x=17d8d7aad00000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=d125958c3995ddcd
> > dashboard link: https://syzkaller.appspot.com/bug?extid=b54a1ce86ba4a623b7f0
> > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1729797ed00000
> > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1190f46ad00000
> >
> > The issue was bisected to:
> >
> > commit 997acaf6b4b59c6a9c259740312a69ea549cc684
> > Author: Mark Rutland <mark.rutland@arm.com>
> > Date:   Mon Jan 11 15:37:07 2021 +0000
> >
> >     lockdep: report broken irq restoration
> >
> > bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=11a6cc96d00000
> > final oops:     https://syzkaller.appspot.com/x/report.txt?x=13a6cc96d00000
> > console output: https://syzkaller.appspot.com/x/log.txt?x=15a6cc96d00000
> >
> > IMPORTANT: if you fix the issue, please add the following tag to the commit:
> > Reported-by: syzbot+b54a1ce86ba4a623b7f0@syzkaller.appspotmail.com
> > Fixes: 997acaf6b4b5 ("lockdep: report broken irq restoration")
> >
> > ------------[ cut here ]------------
> > refcount_t: saturated; leaking memory.
> > WARNING: CPU: 1 PID: 8414 at lib/refcount.c:19 refcount_warn_saturate+0xf4/0x1e0 lib/refcount.c:19
> > Modules linked in:
> > CPU: 1 PID: 8414 Comm: syz-executor793 Not tainted 5.12.0-rc6-next-20210406-syzkaller #0
> > Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> > RIP: 0010:refcount_warn_saturate+0xf4/0x1e0 lib/refcount.c:19
> > Code: 1d 69 0c e6 09 31 ff 89 de e8 c8 b4 a6 fd 84 db 75 ab e8 0f ae a6 fd 48 c7 c7 e0 52 c2 89 c6 05 49 0c e6 09 01 e8 91 0f 00 05 <0f> 0b eb 8f e8 f3 ad a6 fd 0f b6 1d 33 0c e6 09 31 ff 89 de e8 93
> > RSP: 0018:ffffc90000eef388 EFLAGS: 00010282
> > RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
> > RDX: ffff88801bbdd580 RSI: ffffffff815c2e05 RDI: fffff520001dde63
> > RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
> > R10: ffffffff815bcc6e R11: 0000000000000000 R12: 1ffff920001dde74
> > R13: 0000000090200301 R14: ffff888026e00000 R15: ffffc90000eef3c0
> > FS:  0000000001422300(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
> > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > CR2: 0000000020000000 CR3: 0000000012b3b000 CR4: 00000000001506e0
> > DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> > Call Trace:
> >  __refcount_add_not_zero include/linux/refcount.h:163 [inline]
> >  __refcount_inc_not_zero include/linux/refcount.h:227 [inline]
> >  refcount_inc_not_zero include/linux/refcount.h:245 [inline]
> >  sk_psock_get+0x3b0/0x400 include/linux/skmsg.h:435
> >  bpf_exec_tx_verdict+0x11e/0x11a0 net/tls/tls_sw.c:799
> >  tls_sw_sendmsg+0xa41/0x1800 net/tls/tls_sw.c:1013
> >  inet_sendmsg+0x99/0xe0 net/ipv4/af_inet.c:821
>
> [...]
>
> This is likely a problem with latest round of sockmap patches I'll
> tke a look.

I bet this has nothing to do with my sockmap patches, as clearly
the reproducer does not even have any BPF thing. And actually
the reproducer creates an SMC socket, which coincidentally uses
sk_user_data too, therefore triggers this bug.

I think we should just prohibit TCP_ULP on SMC socket, something
like this:

diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index 47340b3b514f..0d4d6d28f20c 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -2162,6 +2162,9 @@ static int smc_setsockopt(struct socket *sock,
int level, int optname,
        struct smc_sock *smc;
        int val, rc;

+       if (optname == TCP_ULP)
+               return -EOPNOTSUPP;
+
        smc = smc_sk(sk);

        /* generic setsockopts reaching us here always apply to the
@@ -2186,7 +2189,6 @@ static int smc_setsockopt(struct socket *sock,
int level, int optname,
        if (rc || smc->use_fallback)
                goto out;
        switch (optname) {
-       case TCP_ULP:
        case TCP_FASTOPEN:
        case TCP_FASTOPEN_CONNECT:
        case TCP_FASTOPEN_KEY:

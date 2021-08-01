Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E27643DC96C
	for <lists+netdev@lfdr.de>; Sun,  1 Aug 2021 05:26:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230392AbhHAD0J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Jul 2021 23:26:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229761AbhHAD0I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 31 Jul 2021 23:26:08 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2E8AC0613D3
        for <netdev@vger.kernel.org>; Sat, 31 Jul 2021 20:26:00 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id nh14so9032983pjb.2
        for <netdev@vger.kernel.org>; Sat, 31 Jul 2021 20:26:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=3XR3Rna7Rr+9CL16uPJTtqZhFZ3n6mMMJSTweWOLXfo=;
        b=H5qg3Rv7MU+P4vxEQBBg941EZz82TEbn+YLrXqAJYjPhYWhV7UUm6FSQhDPS/94SFQ
         BBg1I1Tw2eXYkRdW7gLanO5HTB3oQl6I+FCnpIOlJfBBEhth03qDoYYFqLk0Nx4/3/j0
         2txnkcrm3GXKTBF649x92vWh4fDiipIVK9heE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=3XR3Rna7Rr+9CL16uPJTtqZhFZ3n6mMMJSTweWOLXfo=;
        b=ueygcGmDSylOVXDldInvXTUk0ueDHVwYy0M1pss5+wX/xRkmcub4Npweo2tMcNB4OY
         ryDqvwsvaBsaEdNyEST35NGleZSQbcuiN4qEaGX2nbQ9MfA3c3Ekwp07HpQ828CfariG
         pjRT8uVbtPavygPtPluEyf4ayVKzKPDI32MRwy8EF9zqQc7fgUPWoLdpBENN9z2qsZtz
         2hEUcF3xf0VIGrXnKycqD6AGGnPQ2DGebV9nWUWqZwBDrsiWavupiS3eSWMS6frFktpg
         NUupvDkoEwMYCGvzlQYJSHbQJ3aBNvaDEPzOD72oedEf6/k9G5jTlRQXBR2WS7NkTCz6
         FBWA==
X-Gm-Message-State: AOAM533cWDNBfdn2zq37Kl1EGWlLcL5BxcqbvZtMcJDboxI+PYoldToG
        dWIAEJ0+6Q1xHTfqJRDXTGKdtw==
X-Google-Smtp-Source: ABdhPJztWny8qDLoF9aDrOGGwPEkUl8/lCnKXM6Yi4tE7zPw7q2cjlDL6++ccQRH4HMcKCFTQSzjiA==
X-Received: by 2002:a62:584:0:b029:32e:3b57:a1c6 with SMTP id 126-20020a6205840000b029032e3b57a1c6mr10199216pff.13.1627788360124;
        Sat, 31 Jul 2021 20:26:00 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id r4sm6540476pjo.46.2021.07.31.20.25.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 31 Jul 2021 20:25:59 -0700 (PDT)
Date:   Sat, 31 Jul 2021 20:25:58 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc:     Andy Lutomirski <luto@amacapital.net>,
        Will Drewry <wad@chromium.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, bpf@vger.kernel.org,
        alaaemadhossney.ae@gmail.com, syzkaller@googlegroups.com,
        Jann Horn <jannh@google.com>,
        Tycho Andersen <tycho@tycho.pizza>,
        Sargun Dhillon <sargun@sargun.me>,
        Christian Brauner <christian.brauner@ubuntu.com>
Subject: Re: memory leak in do_seccomp
Message-ID: <202107311901.8CDF235F65@keescook>
References: <CADVatmPShADZ0F133eS3KjeKj1ZjTNAQfy_QOoJVBan02wuR+Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADVatmPShADZ0F133eS3KjeKj1ZjTNAQfy_QOoJVBan02wuR+Q@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 31, 2021 at 08:20:29PM +0100, Sudip Mukherjee wrote:
> Hi All,
> 
> We had been running syzkaller on v5.10.y and a "memory leak in
> do_seccomp" was being reported on it. I got some time to check that
> today and have managed to get a syzkaller
> reproducer. I dont have a C reproducer which I can share but I can use
> the syz-reproducer to reproduce this with next-20210730.
> The old report on v5.10.y is at
> https://elisa-builder-00.iol.unh.edu/syzkaller/report?id=f6ddd3b592f00e95f9cbd2e74f70a5b04b015c6f

Thanks for the details!

Is this the same as what syzbot saw here (with a C reproducer)?
https://syzkaller.appspot.com/bug?id=2809bb0ac77ad9aa3f4afe42d6a610aba594a987

I can't figure out what happened with the "Patch testing request" that
was made; there's no link?

> 
> BUG: memory leak
> unreferenced object 0xffff888019282c00 (size 512):
>   comm "syz-executor.1", pid 7389, jiffies 4294761829 (age 17.841s)
>   hex dump (first 32 bytes):
>     01 00 00 00 01 00 00 00 00 00 00 00 00 00 00 00  ................
>     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>   backtrace:
>     [<00000000762c0963>] do_seccomp+0x2d5/0x27d0

Can you run "./scripts/faddr2line do_seccomp+0x2d5/0x27d0" for this? I
expect it'll be:
        sfilter = kzalloc(sizeof(*sfilter), GFP_KERNEL | __GFP_NOWARN);

>     [<0000000006e512d1>] do_syscall_64+0x3b/0x90
>     [<0000000094ae9ff8>] entry_SYSCALL_64_after_hwframe+0x44/0xae

The "size 512" in your v5.10.y report is from seccomp_prepare_filter()
(noted above). seccomp_prepare_filter() cleans up its error paths.

> 
> BUG: memory leak
> unreferenced object 0xffffc900006b5000 (size 4096):
>   comm "syz-executor.1", pid 7389, jiffies 4294761829 (age 17.841s)
>   hex dump (first 32 bytes):
>     01 00 00 00 00 00 00 00 00 00 00 00 05 00 00 00  ................
>     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>   backtrace:
>     [<00000000854901e5>] __vmalloc_node_range+0x550/0x9a0
>     [<000000002686628f>] __vmalloc_node+0xb5/0x100
>     [<0000000004cbd298>] bpf_prog_alloc_no_stats+0x38/0x350
>     [<0000000009149728>] bpf_prog_alloc+0x24/0x170
>     [<000000000fe7f1e7>] bpf_prog_create_from_user+0xad/0x2e0
>     [<000000000c70eb02>] do_seccomp+0x325/0x27d0
>     [<0000000006e512d1>] do_syscall_64+0x3b/0x90
>     [<0000000094ae9ff8>] entry_SYSCALL_64_after_hwframe+0x44/0xae

Again, I'm curious about where do_seccomp+0x325/0x27d0 is for this, but
the matching one in v5.10 shows:
        ret = bpf_prog_create_from_user(&sfilter->prog, fprog,
                                        seccomp_check_filter, save_orig);

This and everything remaining below else has bpf_prog_create_from_user()
in the allocation path.

> 
> BUG: memory leak
> unreferenced object 0xffff888026eb1000 (size 2048):
>   comm "syz-executor.1", pid 7389, jiffies 4294761829 (age 17.842s)
>   hex dump (first 32 bytes):
>     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>   backtrace:
>     [<0000000072de7240>] bpf_prog_alloc_no_stats+0xeb/0x350
>     [<0000000009149728>] bpf_prog_alloc+0x24/0x170
>     [<000000000fe7f1e7>] bpf_prog_create_from_user+0xad/0x2e0
>     [<000000000c70eb02>] do_seccomp+0x325/0x27d0
>     [<0000000006e512d1>] do_syscall_64+0x3b/0x90
>     [<0000000094ae9ff8>] entry_SYSCALL_64_after_hwframe+0x44/0xae
> 
> BUG: memory leak
> unreferenced object 0xffff888014dddac0 (size 16):
>   comm "syz-executor.1", pid 7389, jiffies 4294761829 (age 17.842s)
>   hex dump (first 16 bytes):
>     01 00 ca 08 80 88 ff ff c8 ef df 14 80 88 ff ff  ................

These are two kernel pointers:
	0xffff888008ca0001 (unaligned by 1 byte?!)
	0xffff888014dfefc8

Ah, no, this is from:

struct sock_fprog_kern {
        u16                     len;
        struct sock_filter      *filter;
};

The "ca 08 80 88 ff ff" bytes are uninitialized padding. ;) "len" has
a value of 1 (which matches the syzkaller reproducer args below of a
single BPF instruction).

        fp->orig_prog = kmalloc(sizeof(*fkprog), GFP_KERNEL);
        if (!fp->orig_prog)
                return -ENOMEM;

        fkprog = fp->orig_prog;
        fkprog->len = fprog->len;
	...
        fkprog->filter = kmemdup(fp->insns, fsize,
                                 GFP_KERNEL | __GFP_NOWARN);

>   backtrace:
>     [<00000000c5d4ed93>] bpf_prog_store_orig_filter+0x7b/0x1e0
>     [<000000007cb21c2a>] bpf_prog_create_from_user+0x1c6/0x2e0
>     [<000000000c70eb02>] do_seccomp+0x325/0x27d0
>     [<0000000006e512d1>] do_syscall_64+0x3b/0x90
>     [<0000000094ae9ff8>] entry_SYSCALL_64_after_hwframe+0x44/0xae
> 
> BUG: memory leak
> unreferenced object 0xffff888014dfefc8 (size 8):
>   comm "syz-executor.1", pid 7389, jiffies 4294761829 (age 17.842s)
>   hex dump (first 8 bytes):
>     06 00 00 00 ff ff ff 7f                          ........

This contains a userspace (likely stack) pointer, and is referenced
by the second pointer above. (i.e. kmemdup() above, but how have the
contents become a user stack pointer?)

>   backtrace:
>     [<00000000ee5550f8>] kmemdup+0x23/0x50
>     [<00000000f1acd067>] bpf_prog_store_orig_filter+0x103/0x1e0
>     [<000000007cb21c2a>] bpf_prog_create_from_user+0x1c6/0x2e0
>     [<000000000c70eb02>] do_seccomp+0x325/0x27d0
>     [<0000000006e512d1>] do_syscall_64+0x3b/0x90
>     [<0000000094ae9ff8>] entry_SYSCALL_64_after_hwframe+0x44/0xae
> 
> Not sure if this has been already reported or not, but I will be happy
> to test if you have a fix for this.

I was suspecting a missing error path free near bpf_prepare_filter()
as called by bpf_prog_create_from_user() here:

        /* bpf_prepare_filter() already takes care of freeing
         * memory in case something goes wrong.
         */
        fp = bpf_prepare_filter(fp, trans);
        if (IS_ERR(fp))
                return PTR_ERR(fp);

Since only seccomp and af_packet use bpf_prog_create_from_user(),
and af_packet sets neither a "trans" callback nor save_orig. But if
"trans" fails (due to some BPF instructions seccomp doesn't support),
I'd expect this leak to be detected more often.

bpf_prepare_filter() is documented as cleaning up allocations on failure,
though I notice its cleanup differs from bpf_prog_create_from_user()'s,
which uses __bpf_prog_free() instead of __bfp_prog_release(). But
that should only make a difference for orig_prog getting freed,
and bpf_prog_store_orig_filter() should already be freeing that on
failures too.

Similarly, bpf_migrate_filter() cleanups up on failure too, so this
doesn't seem to be it:

        if (!fp->jited)
                fp = bpf_migrate_filter(fp);

        return fp;

So, I'm going to assume the missing free is somehow related to
process management, since I see the Syzkaller reproducer mentions
SECCOMP_SET_MODE_FILTER_LISTENER, fork(), and ptrace(). :)

Quoting from the v5.10.y report:
> # {Threaded:true Collide:true Repeat:true RepeatTimes:0 Procs:8 Slowdown:1 Sandbox:none Fault:false FaultCall:-1 FaultNth:0 Leak:true NetInjection:true NetDevices:true NetReset:true Cgroups:true BinfmtMisc:true CloseFDs:true KCSAN:false DevlinkPCI:false USB:true VhciInjection:false Wifi:false IEEE802154:false Sysctl:true UseTmpDir:true HandleSegv:true Repro:false Trace:false}
> seccomp$SECCOMP_SET_MODE_FILTER_LISTENER(0x1, 0x0, &(0x7f0000000000)={0x1, &(0x7f0000000040)=[{0x6, 0x0, 0x0, 0x7fffffff}]})

0x1 is SECCOMP_SET_MODE_FILTER
0x0 is empty flags
{0x6, 0x0, 0x0, 0x7fffffff} is
	BPF_STMT(BPF_RET, SECCOMP_RET_ALLOW | 0xffff)

For "SECCOMP_SET_MODE_FILTER_LISTENER", defined here:
https://github.com/google/syzkaller/blob/master/sys/linux/seccomp.txt#L15
I was expecting flags to include SECCOMP_FILTER_FLAG_NEW_LISTENER:
	seccomp$SECCOMP_SET_MODE_FILTER_LISTENER(
			op const[SECCOMP_SET_MODE_FILTER],
			flags flags[seccomp_flags_listener],
			arg ptr[in, sock_fprog]) fd_seccomp (breaks_returns)

For the flags:

	seccomp_flags_listener = SECCOMP_FILTER_FLAG_NEW_LISTENER,
				 SECCOMP_FILTER_FLAG_LOG_LISTENER,
				 SECCOMP_FILTER_FLAG_SPEC_ALLOW_LISTENER

which is:

	SECCOMP_FILTER_FLAG_LOG_LISTENER = 10
	SECCOMP_FILTER_FLAG_NEW_LISTENER = 8
	SECCOMP_FILTER_FLAG_SPEC_ALLOW = 4
	SECCOMP_FILTER_FLAG_SPEC_ALLOW_LISTENER = 12

How is flags 0 above? (Maybe I don't understand the syzkaller reproducer
meaning fully?)

> r0 = fork()
> ptrace(0x10, r0)

0x10 is PTRACE_ATTACH

My best guess is there is some LISTENER refcount state we can get into
where all the processes die, but a reference is left alive.

-Kees

-- 
Kees Cook

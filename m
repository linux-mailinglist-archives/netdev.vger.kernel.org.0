Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87CFA7E472
	for <lists+netdev@lfdr.de>; Thu,  1 Aug 2019 22:46:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387803AbfHAUod (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Aug 2019 16:44:33 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:37872 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728904AbfHAUod (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Aug 2019 16:44:33 -0400
Received: by mail-lj1-f195.google.com with SMTP id z28so16489923ljn.4;
        Thu, 01 Aug 2019 13:44:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1/QNfz2nyMHipJKd4QPa1Kd2pkugwLrGk8J5gPknMGg=;
        b=f539gQnJzsG9utKQ9IYsns2SYkv2OUztYZ5zcALYWuXobUtfPAtZMnEqtFlF/7JHdP
         EYbsNtpsdScQ1u74QBhMUVBAWvnqBGggCDKwoixT3r4NKUnJgbPO3oB6r/HejjqgKTdq
         7qI4Y3NlAJHu3gNKqf5EzXEJ8L/+iNobx+ibegEPNkr+VKEe8T+Xc8nuZQeY2qQ4VMvu
         JnQIhdpm4Chfp1atZntSb2yVImisMs1IoVhw/rp5FMLQGqH28FmhzaJ3ZCz1iFdA5uZS
         NAE1KcQwwDVHrs1FElKYJofg+jz1uMEBFJegXWZTDY1+pb/9rALexvqKTfj+cZsTu5cL
         WzvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1/QNfz2nyMHipJKd4QPa1Kd2pkugwLrGk8J5gPknMGg=;
        b=JeYhpTD4zxKUiMiEgARvk5AnTEFL2vo3sMlTperjlC6QdnnmkqppHerQS0efZZuOi0
         FdSp3xJrHj37FPAbyuMk0A5y9VehK6uBTK8dfIoKzxsNk2x7gmwuq/qxgAaIsix7Jblj
         BjeG4kVDNnc6A4HHqwnKdt8+1gc/swxDuQb1n7PQFfZsNgZ2BzsWaY0rFy8AzRu45+RP
         +aiCDKkhAaPu8vNPZJBsFKbS1z1bth9vsecpjTEd/SFfmL6OfqFdVWdkGzovGmGVbFe2
         CkpGg1L2PcC2R8GV27/dO5Tan/SVMYVkJT1t3tYtilHRDsg3ZMr2uoxBh6Gt97uL1S5Z
         wyIw==
X-Gm-Message-State: APjAAAVqHe2kt1R2NvJ41G1m6xYztl5jCOLvDBzYPBvZihsz7atwbASV
        CHlamlmRwxHqr6fRccAxFxPNgFOQa9mkOt7BT8Q=
X-Google-Smtp-Source: APXvYqwx53WyruVv0F5FfQwS6KPYBZIjQPd7DIOxFT0Zml/ZD6m4VAayq7xNb3W2qsdAJra2f+RlBhZ9FTWNA7ZbrVc=
X-Received: by 2002:a2e:7818:: with SMTP id t24mr41041669ljc.210.1564692270893;
 Thu, 01 Aug 2019 13:44:30 -0700 (PDT)
MIME-Version: 1.0
References: <20190731013827.2445262-1-ast@kernel.org> <20190731013827.2445262-2-ast@kernel.org>
 <B6B907F5-E6CA-4C0B-92F3-0411CA4F4D95@fb.com> <CAADnVQJu9s4a=tc0+C5hgSPX4KnpYDzKu0AxxU4nCoU1QaWVEg@mail.gmail.com>
In-Reply-To: <CAADnVQJu9s4a=tc0+C5hgSPX4KnpYDzKu0AxxU4nCoU1QaWVEg@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 1 Aug 2019 13:44:18 -0700
Message-ID: <CAADnVQKrUDGjOi2_SSs=qTxpsXcgM-zdTY3D5VwOcewWQcRTjA@mail.gmail.com>
Subject: Re: [PATCH bpf 1/2] bpf: fix x64 JIT code generation for jmp to 1st insn
To:     Song Liu <songliubraving@fb.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 31, 2019 at 8:43 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Wed, Jul 31, 2019 at 12:36 PM Song Liu <songliubraving@fb.com> wrote:
> >
> >
> >
> > > On Jul 30, 2019, at 6:38 PM, Alexei Starovoitov <ast@kernel.org> wrote:
> > >
> > > Introduction of bounded loops exposed old bug in x64 JIT.
> > > JIT maintains the array of offsets to the end of all instructions to
> > > compute jmp offsets.
> > > addrs[0] - offset of the end of the 1st insn (that includes prologue).
> > > addrs[1] - offset of the end of the 2nd insn.
> > > JIT didn't keep the offset of the beginning of the 1st insn,
> > > since classic BPF didn't have backward jumps and valid extended BPF
> > > couldn't have a branch to 1st insn, because it didn't allow loops.
> > > With bounded loops it's possible to construct a valid program that
> > > jumps backwards to the 1st insn.
> > > Fix JIT by computing:
> > > addrs[0] - offset of the end of prologue == start of the 1st insn.
> > > addrs[1] - offset of the end of 1st insn.
> > >
> > > Reported-by: syzbot+35101610ff3e83119b1b@syzkaller.appspotmail.com
> > > Fixes: 2589726d12a1 ("bpf: introduce bounded loops")
> > > Fixes: 0a14842f5a3c ("net: filter: Just In Time compiler for x86-64")
> > > Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> >
> > Acked-by: Song Liu <songliubraving@fb.com>
> >
> > Do we need similar fix for x86_32?
>
> Right. x86_32 would need similar fix.
>
> Applied to bpf tree.

Yonghong noticed that it subtly changes jited linfo.
Surprisingly perf annotated output for source code in jited bpf progs
looks exactly the same for several large bpf progs that I've looked at.
This to be investigated later.

I've applied the fix:
diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
index a56c95805732..991549a1c5f3 100644
--- a/arch/x86/net/bpf_jit_comp.c
+++ b/arch/x86/net/bpf_jit_comp.c
@@ -1181,7 +1181,7 @@ struct bpf_prog *bpf_int_jit_compile(struct
bpf_prog *prog)

        if (!image || !prog->is_func || extra_pass) {
                if (image)
-                       bpf_prog_fill_jited_linfo(prog, addrs);
+                       bpf_prog_fill_jited_linfo(prog, addrs + 1);
 out_addrs:
                kfree(addrs);
                kfree(jit_data);
and re-pushed bpf tree.
The new commit is here:
https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git/commit/?id=7c2e988f400e83501e0a3568250780609b7c8263

Thanks Yonghong!

For bpf-next we need to figure out how to make test_btf more robust.
We can probably check first few insns for specific jited offsets,
but I don't yet see how to make it work for all archs.
And it will be annoying to keep it working with every change to jit.

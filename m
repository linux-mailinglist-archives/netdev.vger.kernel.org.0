Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4227DCD9DF
	for <lists+netdev@lfdr.de>; Mon,  7 Oct 2019 02:21:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726678AbfJGAVB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Oct 2019 20:21:01 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:34090 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726266AbfJGAVA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Oct 2019 20:21:00 -0400
Received: by mail-qk1-f193.google.com with SMTP id q203so11080891qke.1;
        Sun, 06 Oct 2019 17:20:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CjhIlCPO4IZHyUrYGHcK5dFsgSPh5pjAUfM++lnj5FQ=;
        b=PIsIadk9ZpC1DpGvNsrecu6WqRP81Gb57D2ta8Kmg1qS2cdvvR3Rx2wTT40u6uwg75
         s/PHvOMFzj42gdn8H4gTmWTxOf7Fb0e2LaAPTz8Mi0NSLv+uZsp/Qbl786MSK+acbiIg
         A1vrG/GPXxdeHiZ3UGhxTJ9o4crLr45B0Qu6IhZxltVdwvSj7Za5M2pdH3f0xuJAZysC
         EHPsHe7sOl0+w1r3j1wRK7Ik5U+SBE7l9NDzmXd0x9f6qrdFHOZBzJjRCtWSz4PVSkF1
         cNs6E77j2AqMQVS4cc4WqM0pHnXEOFW+bvbFbfeUICLVomjtkS3FmWLfI2B2alN2i1xd
         OJMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CjhIlCPO4IZHyUrYGHcK5dFsgSPh5pjAUfM++lnj5FQ=;
        b=m4jgnhAp/TaQkDDqa5EnEAu6LM/qUzTSmWyVgEcADSyZ14mySGdLVGEH30r8YkatWY
         m2Y8jmHJsNJ1AcmLDci6YsCk/I5pTbU5b3StZt9gedifBDPxxXu6AyetGWvXnHI6nd5Q
         6YCL8iPNLGVPj91vwYYm+ldSuzE8lQsV487iRIn6vXMZsknPvtCrGLaQljGaDrmmMjpY
         5LDsr8R2n7lFUhugjIYpX0Rv/DbIBitopgH/ZAsvKCzDW7kAbleRvQpVOX/qlIXkoi3h
         L6uVnWSk4s4wJdha5lpn+p3rQUiAEcMfTvkyA+zp4r9d7LCOkEqGqfgecmTPYtU1LDkV
         OMsg==
X-Gm-Message-State: APjAAAU+rAsLB2x83oecMoGeCLzFeuZOwg5NXGS01/DqXJ4WaU+mX60l
        Tz1UUSJIBimkJlG4+MiJHPkL/DTElz3yCMAu0jQ=
X-Google-Smtp-Source: APXvYqxP6w5lvBstF9c5OIivIXR758Blxk4aw7pvwuviZ4FZkyPRcS6sbrRmPKKVcUdhB3OGeCanjXkvt9YjmZ9gNuo=
X-Received: by 2002:a37:98f:: with SMTP id 137mr21902376qkj.449.1570407659086;
 Sun, 06 Oct 2019 17:20:59 -0700 (PDT)
MIME-Version: 1.0
References: <20191005050314.1114330-1-ast@kernel.org> <20191005050314.1114330-4-ast@kernel.org>
 <CAEf4BzahO9XjK7rMYa+DdRRhm2z4MmjD9Y-n3DWGd-W-G3mYRQ@mail.gmail.com> <20191006234935.fxdcva2mdqhgtjhu@ast-mbp.dhcp.thefacebook.com>
In-Reply-To: <20191006234935.fxdcva2mdqhgtjhu@ast-mbp.dhcp.thefacebook.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Sun, 6 Oct 2019 17:20:48 -0700
Message-ID: <CAEf4BzYM=whUfEsuSa8yvZjM62RUfiByEzHye5cpPbeMMDMyeA@mail.gmail.com>
Subject: Re: [PATCH bpf-next 03/10] bpf: process in-kernel BTF
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>, x86@kernel.org,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 6, 2019 at 4:49 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Sat, Oct 05, 2019 at 11:36:16PM -0700, Andrii Nakryiko wrote:
> > On Fri, Oct 4, 2019 at 10:08 PM Alexei Starovoitov <ast@kernel.org> wrote:
> > >
> > > If in-kernel BTF exists parse it and prepare 'struct btf *btf_vmlinux'
> > > for further use by the verifier.
> > > In-kernel BTF is trusted just like kallsyms and other build artifacts
> > > embedded into vmlinux.
> > > Yet run this BTF image through BTF verifier to make sure
> > > that it is valid and it wasn't mangled during the build.
> > >
> > > Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> > > ---
> > >  include/linux/bpf_verifier.h |  4 ++-
> > >  include/linux/btf.h          |  1 +
> > >  kernel/bpf/btf.c             | 66 ++++++++++++++++++++++++++++++++++++
> > >  kernel/bpf/verifier.c        | 18 ++++++++++
> > >  4 files changed, 88 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/include/linux/bpf_verifier.h b/include/linux/bpf_verifier.h
> > > index 26a6d58ca78c..432ba8977a0a 100644
> > > --- a/include/linux/bpf_verifier.h
> > > +++ b/include/linux/bpf_verifier.h
> > > @@ -330,10 +330,12 @@ static inline bool bpf_verifier_log_full(const struct bpf_verifier_log *log)
> > >  #define BPF_LOG_STATS  4
> > >  #define BPF_LOG_LEVEL  (BPF_LOG_LEVEL1 | BPF_LOG_LEVEL2)
> > >  #define BPF_LOG_MASK   (BPF_LOG_LEVEL | BPF_LOG_STATS)
> > > +#define BPF_LOG_KERNEL (BPF_LOG_MASK + 1)
> >
> > It's not clear what's the numbering scheme is for these flags. Are
> > they independent bits? Only one bit allowed at a time? Only some
> > subset of bits allowed?
> > E.g., if I specify BPF_LOG_KERNEL an BPF_LOG_STATS, will it work?
>
> you cannot. It's kernel internal flag. User space cannot pass it in.
> That's why it's just +1 and will keep floating up when other flags
> are added in the future.
> I considered using something really large instead (like ~0),
> but it's imo cleaner to define it as max_visible_flag + 1.

Ah, I see, maybe small comment, e.g., /* kernel-only flag */ or
something along those lines?

>
> > > diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
> > > index 29c7c06c6bd6..848f9d4b9d7e 100644
> > > --- a/kernel/bpf/btf.c
> > > +++ b/kernel/bpf/btf.c
> > > @@ -698,6 +698,9 @@ __printf(4, 5) static void __btf_verifier_log_type(struct btf_verifier_env *env,
> > >         if (!bpf_verifier_log_needed(log))
> > >                 return;
> > >
> > > +       if (log->level == BPF_LOG_KERNEL && !fmt)
> > > +               return;
> >
> > This "!fmt" condition is subtle and took me a bit of time to
> > understand. Is the intent to print only verification errors for
> > BPF_LOG_KERNEL mode? Maybe small comment would help?
>
> It's the way btf.c prints types. It's calling btf_verifier_log_type(..fmt=NULL).
> I need to skip all of these, since they're there to debug invalid BTF
> when user space passes it into the kernel.
> Here the same code is processing in-kernel trusted BTF and extra messages
> are completely unnecessary.
> I will add a comment.
>
> >
> > nit: extra empty line here, might as well get rid of it in this change?
>
> yeah. the empty line was there before. Will remove it.
>
> >
> > > +               if (env->log.level == BPF_LOG_KERNEL)
> > > +                       continue;
> > >                 btf_verifier_log(env, "\t%s val=%d\n",
> > >                                  __btf_name_by_offset(btf, enums[i].name_off),
> > >                                  enums[i].val);
> > > @@ -3367,6 +3378,61 @@ static struct btf *btf_parse(void __user *btf_data, u32 btf_data_size,
> > >         return ERR_PTR(err);
> > >  }
> > >
> > > +extern char __weak _binary__btf_vmlinux_bin_start[];
> > > +extern char __weak _binary__btf_vmlinux_bin_end[];
> > > +
> > > +struct btf *btf_parse_vmlinux(void)
> >
> > It's a bit unfortunate to duplicate a bunch of logic of btf_parse()
> > here. I assume you considered extending btf_parse() with extra flag
> > but decided it's better to have separate vmlinux-specific version?
>
> Right. It looks similar, but it's 70-80% different. I actually started
> with combined, but it didn't look good.
>
> > >
> > > +       if (is_priv && !btf_vmlinux) {
> >
> > I'm missing were you are checking that vmlinux BTF (raw data) is
> > present at all? Should this have additional `&&
> > _binary__btf_vmlinux_bin_start` check?
>
> btf_parse_hdr() is doing it.
> But now I'm thinking I should gate it with CONFIG_DEBUG_INFO_BTF.

You mean btf_data_size check? But in that case you'll get error
message printed even though no BTF was generated, so yeah, I guess
gating is cleaner.

>
> >
> > > +               mutex_lock(&bpf_verifier_lock);
> > > +               btf_vmlinux = btf_parse_vmlinux();
> >
> > This is racy, you might end up parsing vmlinux BTF twice. Check
> > `!btf_vmlinux` again under lock?
>
> right. good catch.
>
> > >
> > > +       if (IS_ERR(btf_vmlinux)) {
> >
> > There is an interesting interplay between non-priviledged BPF and
> > corrupted vmlinux. If vmlinux BTF is malformed, but system only ever
> > does unprivileged BPF, then we'll never parse vmlinux BTF and won't
> > know it's malformed. But once some privileged BPF does parse and
> > detect problem, all subsequent unprivileged BPFs will fail due to bad
> > BTF, even though they shouldn't use/rely on it. Should something be
> > done about this inconsistency?
>
> I did is_priv check to avoid parsing btf in unpriv, since no unpriv
> progs will ever use this stuff.. (not until cpu hw side channels are fixed).
> But this inconsistency is indeed bad.
> Will refactor to do it always.

Sounds good.

> Broken in-kernel BTF is bad enough sign that either gcc or pahole or kernel
> are broken. In all cases the kernel shouldn't be loading any bpf.
>
> Thanks for the review!
>

I'm intending to go over the rest today-tomorrow, so don't post v2 just yet :)

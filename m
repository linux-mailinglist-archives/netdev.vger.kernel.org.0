Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 783AACD9BD
	for <lists+netdev@lfdr.de>; Mon,  7 Oct 2019 01:49:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726269AbfJFXtl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Oct 2019 19:49:41 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:35390 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726000AbfJFXtl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Oct 2019 19:49:41 -0400
Received: by mail-pf1-f196.google.com with SMTP id 205so7493641pfw.2;
        Sun, 06 Oct 2019 16:49:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=SMs2JewYcGSP3CnPuall2iZDxcetigZ64C7idthVvHQ=;
        b=Nzr5v7R0rNNBW5HZCg45CejDo/oi8Xs5E3dPqs2LA/TeKkrgeItedDMVe7/0coc8YX
         BGfhkiPKTyGgtexQwKuqeUwxr0NQ5OtJpugK+Yqd72GUdOC0KAmrIU1+Y7zyyY8FeQ/r
         De2WkriIX1U08m5FZFDOWuAbAeMXTLT6eIoTKHe2Chr62J5ySP6FB/82KbdqJVuaSH2P
         8Z3Asvk+LP4bQ6nH6Jh3cXYnxYbtwSLAznp/ob/3IkAeXHqwnuqa1cwrrTgUIkIybZ9N
         irSpBq3rJVnHFdI6fbWvBjlvjPnWw1ZkpRAQjAHaxjQdCvyHGzG/BBZU50mQikxabaL2
         6+2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=SMs2JewYcGSP3CnPuall2iZDxcetigZ64C7idthVvHQ=;
        b=FoBVluDzehSqeUTlUDQK+oqmJ3PdgIk/WpEz7cTS+WMXhVoarZawTo2N0hvEyiwdds
         X6PN7mTZ3B7pbsAnndduqvnvFYl65X6pWRsG1VrGvOFacE1qidT92A/lfXW1vO3xgcCg
         AyZvaE6kdWm9ioYdgdzi5vNqNCzY8pxXinIb84W0I0YKvay9N46hSwes8juwp8MqDiht
         EtOKTt4dd/jsF4AFo4YyXyNMXGxFb3K5dUCTcM8tGgR/1LY/uGdlPGrEn3CqGppeXb3R
         41y5YwyapqRKEmO5lq8HTzJBJ70R3xREWagQuUaDDlXoHBa4e9XLkhnEejdF5d0D0Vpq
         QNtw==
X-Gm-Message-State: APjAAAW9IBQ6cmQgVYlBq1aQJ9ODyE6LGgwJBbo1Ki/h46xpFguBwMMz
        xevDWE8YJiAnfc1iFcsIYHs=
X-Google-Smtp-Source: APXvYqznj+OTjGPKdS4besI3ZT49NaCznHk0ZkpHco2gKUKFN838uKsgto8t6fQG6YAVsGfNODtM7A==
X-Received: by 2002:a63:2aca:: with SMTP id q193mr27115051pgq.156.1570405780072;
        Sun, 06 Oct 2019 16:49:40 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:180::f2c6])
        by smtp.gmail.com with ESMTPSA id s141sm14677576pfs.13.2019.10.06.16.49.38
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 06 Oct 2019 16:49:39 -0700 (PDT)
Date:   Sun, 6 Oct 2019 16:49:37 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>, x86@kernel.org,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>
Subject: Re: [PATCH bpf-next 03/10] bpf: process in-kernel BTF
Message-ID: <20191006234935.fxdcva2mdqhgtjhu@ast-mbp.dhcp.thefacebook.com>
References: <20191005050314.1114330-1-ast@kernel.org>
 <20191005050314.1114330-4-ast@kernel.org>
 <CAEf4BzahO9XjK7rMYa+DdRRhm2z4MmjD9Y-n3DWGd-W-G3mYRQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzahO9XjK7rMYa+DdRRhm2z4MmjD9Y-n3DWGd-W-G3mYRQ@mail.gmail.com>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 05, 2019 at 11:36:16PM -0700, Andrii Nakryiko wrote:
> On Fri, Oct 4, 2019 at 10:08 PM Alexei Starovoitov <ast@kernel.org> wrote:
> >
> > If in-kernel BTF exists parse it and prepare 'struct btf *btf_vmlinux'
> > for further use by the verifier.
> > In-kernel BTF is trusted just like kallsyms and other build artifacts
> > embedded into vmlinux.
> > Yet run this BTF image through BTF verifier to make sure
> > that it is valid and it wasn't mangled during the build.
> >
> > Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> > ---
> >  include/linux/bpf_verifier.h |  4 ++-
> >  include/linux/btf.h          |  1 +
> >  kernel/bpf/btf.c             | 66 ++++++++++++++++++++++++++++++++++++
> >  kernel/bpf/verifier.c        | 18 ++++++++++
> >  4 files changed, 88 insertions(+), 1 deletion(-)
> >
> > diff --git a/include/linux/bpf_verifier.h b/include/linux/bpf_verifier.h
> > index 26a6d58ca78c..432ba8977a0a 100644
> > --- a/include/linux/bpf_verifier.h
> > +++ b/include/linux/bpf_verifier.h
> > @@ -330,10 +330,12 @@ static inline bool bpf_verifier_log_full(const struct bpf_verifier_log *log)
> >  #define BPF_LOG_STATS  4
> >  #define BPF_LOG_LEVEL  (BPF_LOG_LEVEL1 | BPF_LOG_LEVEL2)
> >  #define BPF_LOG_MASK   (BPF_LOG_LEVEL | BPF_LOG_STATS)
> > +#define BPF_LOG_KERNEL (BPF_LOG_MASK + 1)
> 
> It's not clear what's the numbering scheme is for these flags. Are
> they independent bits? Only one bit allowed at a time? Only some
> subset of bits allowed?
> E.g., if I specify BPF_LOG_KERNEL an BPF_LOG_STATS, will it work?

you cannot. It's kernel internal flag. User space cannot pass it in.
That's why it's just +1 and will keep floating up when other flags
are added in the future.
I considered using something really large instead (like ~0),
but it's imo cleaner to define it as max_visible_flag + 1.

> > diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
> > index 29c7c06c6bd6..848f9d4b9d7e 100644
> > --- a/kernel/bpf/btf.c
> > +++ b/kernel/bpf/btf.c
> > @@ -698,6 +698,9 @@ __printf(4, 5) static void __btf_verifier_log_type(struct btf_verifier_env *env,
> >         if (!bpf_verifier_log_needed(log))
> >                 return;
> >
> > +       if (log->level == BPF_LOG_KERNEL && !fmt)
> > +               return;
> 
> This "!fmt" condition is subtle and took me a bit of time to
> understand. Is the intent to print only verification errors for
> BPF_LOG_KERNEL mode? Maybe small comment would help?

It's the way btf.c prints types. It's calling btf_verifier_log_type(..fmt=NULL).
I need to skip all of these, since they're there to debug invalid BTF
when user space passes it into the kernel.
Here the same code is processing in-kernel trusted BTF and extra messages
are completely unnecessary.
I will add a comment.

> 
> nit: extra empty line here, might as well get rid of it in this change?

yeah. the empty line was there before. Will remove it.

> 
> > +               if (env->log.level == BPF_LOG_KERNEL)
> > +                       continue;
> >                 btf_verifier_log(env, "\t%s val=%d\n",
> >                                  __btf_name_by_offset(btf, enums[i].name_off),
> >                                  enums[i].val);
> > @@ -3367,6 +3378,61 @@ static struct btf *btf_parse(void __user *btf_data, u32 btf_data_size,
> >         return ERR_PTR(err);
> >  }
> >
> > +extern char __weak _binary__btf_vmlinux_bin_start[];
> > +extern char __weak _binary__btf_vmlinux_bin_end[];
> > +
> > +struct btf *btf_parse_vmlinux(void)
> 
> It's a bit unfortunate to duplicate a bunch of logic of btf_parse()
> here. I assume you considered extending btf_parse() with extra flag
> but decided it's better to have separate vmlinux-specific version?

Right. It looks similar, but it's 70-80% different. I actually started
with combined, but it didn't look good.

> >
> > +       if (is_priv && !btf_vmlinux) {
> 
> I'm missing were you are checking that vmlinux BTF (raw data) is
> present at all? Should this have additional `&&
> _binary__btf_vmlinux_bin_start` check?

btf_parse_hdr() is doing it.
But now I'm thinking I should gate it with CONFIG_DEBUG_INFO_BTF.

> 
> > +               mutex_lock(&bpf_verifier_lock);
> > +               btf_vmlinux = btf_parse_vmlinux();
> 
> This is racy, you might end up parsing vmlinux BTF twice. Check
> `!btf_vmlinux` again under lock?

right. good catch.

> >
> > +       if (IS_ERR(btf_vmlinux)) {
> 
> There is an interesting interplay between non-priviledged BPF and
> corrupted vmlinux. If vmlinux BTF is malformed, but system only ever
> does unprivileged BPF, then we'll never parse vmlinux BTF and won't
> know it's malformed. But once some privileged BPF does parse and
> detect problem, all subsequent unprivileged BPFs will fail due to bad
> BTF, even though they shouldn't use/rely on it. Should something be
> done about this inconsistency?

I did is_priv check to avoid parsing btf in unpriv, since no unpriv
progs will ever use this stuff.. (not until cpu hw side channels are fixed).
But this inconsistency is indeed bad.
Will refactor to do it always.
Broken in-kernel BTF is bad enough sign that either gcc or pahole or kernel
are broken. In all cases the kernel shouldn't be loading any bpf.

Thanks for the review!


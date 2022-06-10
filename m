Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92BA7546AC0
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 18:46:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345769AbiFJQqZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jun 2022 12:46:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231317AbiFJQqX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jun 2022 12:46:23 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86F4F3D6CC5
        for <netdev@vger.kernel.org>; Fri, 10 Jun 2022 09:46:21 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id g205so24297702pfb.11
        for <netdev@vger.kernel.org>; Fri, 10 Jun 2022 09:46:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ecpvMPuAyXcCjvwI1Npa8TvEd7kevWUyn9zD5VUs/PE=;
        b=XiSiLvofh+Rrlod91RsrLAeXHYUPt0jR9Q5YzAM+O+8ALxrQimD3f33qUqjsbxbhnD
         CV2uPoA3Pg1qqaiTM9HORR/8Y1NrKmlsXlDo+yJDlp6KfH9qDyzA0AdtOG4ZwBAiESBz
         CcdMjt3YohoyryfEMuxVLP+wywth51Odiyk0Rbapn1n5GdE//wmrh2jK4h4IsVg+zZMU
         RxoEA2AMjLLr6dI/4XHvSgN8mOACIXtVAnTdsSOhpbl+IEmpjEzz4m+xxWwHAKGBoJUB
         f6d/WM6Wcuw8iKTVUQp8QPd93u+yDStERQClF8UnI+r9jYZfdiZH+TaKdtzM0jklj6LR
         E1Jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ecpvMPuAyXcCjvwI1Npa8TvEd7kevWUyn9zD5VUs/PE=;
        b=tT/OAqrO+jldmrFiilMJhdPNVYgGaV/R+WezXyWc1NroS9H9hr2t8J2CA9guuf8k2O
         rRkdDJIUGY6sbxy0+PYobOaHQg/PrphpbITi0AOhxoR5jt93c0LSInYgVqd87dFkYfZL
         pN6gu19h/SE8ntyhw0DW8PfcYV0wn+UJk89JTPZaKNas/aNts82SJkyjL5ZkCo4cDIq0
         tbmQslcKVNuEmzUo5D+NrdNgbgY+k6SPrA4+VfhyfLpTcDMprmIOfr0dv6H8wxqsYQzl
         GjF9zKlRxW7huO1/ZS2RMwuMLV0crCxxFeos7op6MJMKW6WpAblIqta+wThLe3tfTwYX
         Ofhw==
X-Gm-Message-State: AOAM532MD4LZqMe0EoodeBwJRW9dYs684xcFIgN2fRpK2etrDN6pzzBf
        JOqIUCNynA6zPHgQWV11c/lokgGcX/Cznhh+lPDcUg==
X-Google-Smtp-Source: ABdhPJwiIpPHxVZlw/H96OZQ+sBcfoH5Rz9RKwAJH1LQ5d0DaPM0F/uRmKEcD+UA0+3CzoRFNrWIpTAlgzdnwgR5nmo=
X-Received: by 2002:a65:6bce:0:b0:3f2:5f88:6f7d with SMTP id
 e14-20020a656bce000000b003f25f886f7dmr41568649pgw.253.1654879580595; Fri, 10
 Jun 2022 09:46:20 -0700 (PDT)
MIME-Version: 1.0
References: <20220610112648.29695-1-quentin@isovalent.com> <20220610112648.29695-2-quentin@isovalent.com>
 <YqNsWAH24bAIPjqy@google.com> <cb05a59e-07d5-ddd1-b028-82133faaf67e@isovalent.com>
In-Reply-To: <cb05a59e-07d5-ddd1-b028-82133faaf67e@isovalent.com>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Fri, 10 Jun 2022 09:46:09 -0700
Message-ID: <CAKH8qBvvq0f+D8BXChw_8krH896J_cYg0yhRfnDOSO_U1n394w@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/2] Revert "bpftool: Use libbpf 1.0 API mode
 instead of RLIMIT_MEMLOCK"
To:     Quentin Monnet <quentin@isovalent.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Yafang Shao <laoar.shao@gmail.com>,
        Harsh Modi <harshmodi@google.com>,
        Paul Chaignon <paul@cilium.io>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 10, 2022 at 9:34 AM Quentin Monnet <quentin@isovalent.com> wrote:
>
> 2022-06-10 09:07 UTC-0700 ~ sdf@google.com
> > On 06/10, Quentin Monnet wrote:
> >> This reverts commit a777e18f1bcd32528ff5dfd10a6629b655b05eb8.
> >
> >> In commit a777e18f1bcd ("bpftool: Use libbpf 1.0 API mode instead of
> >> RLIMIT_MEMLOCK"), we removed the rlimit bump in bpftool, because the
> >> kernel has switched to memcg-based memory accounting. Thanks to the
> >> LIBBPF_STRICT_AUTO_RLIMIT_MEMLOCK, we attempted to keep compatibility
> >> with other systems and ask libbpf to raise the limit for us if
> >> necessary.
> >
> >> How do we know if memcg-based accounting is supported? There is a probe
> >> in libbpf to check this. But this probe currently relies on the
> >> availability of a given BPF helper, bpf_ktime_get_coarse_ns(), which
> >> landed in the same kernel version as the memory accounting change. This
> >> works in the generic case, but it may fail, for example, if the helper
> >> function has been backported to an older kernel. This has been observed
> >> for Google Cloud's Container-Optimized OS (COS), where the helper is
> >> available but rlimit is still in use. The probe succeeds, the rlimit is
> >> not raised, and probing features with bpftool, for example, fails.
> >
> >> A patch was submitted [0] to update this probe in libbpf, based on what
> >> the cilium/ebpf Go library does [1]. It would lower the soft rlimit to
> >> 0, attempt to load a BPF object, and reset the rlimit. But it may induce
> >> some hard-to-debug flakiness if another process starts, or the current
> >> application is killed, while the rlimit is reduced, and the approach was
> >> discarded.
> >
> >> As a workaround to ensure that the rlimit bump does not depend on the
> >> availability of a given helper, we restore the unconditional rlimit bump
> >> in bpftool for now.
> >
> >> [0]
> >> https://lore.kernel.org/bpf/20220609143614.97837-1-quentin@isovalent.com/
> >> [1] https://github.com/cilium/ebpf/blob/v0.9.0/rlimit/rlimit.go#L39
> >
> >> Cc: Yafang Shao <laoar.shao@gmail.com>
> >> Signed-off-by: Quentin Monnet <quentin@isovalent.com>
> >> ---
> >>   tools/bpf/bpftool/common.c     | 8 ++++++++
> >>   tools/bpf/bpftool/feature.c    | 2 ++
> >>   tools/bpf/bpftool/main.c       | 6 +++---
> >>   tools/bpf/bpftool/main.h       | 2 ++
> >>   tools/bpf/bpftool/map.c        | 2 ++
> >>   tools/bpf/bpftool/pids.c       | 1 +
> >>   tools/bpf/bpftool/prog.c       | 3 +++
> >>   tools/bpf/bpftool/struct_ops.c | 2 ++
> >>   8 files changed, 23 insertions(+), 3 deletions(-)
> >
> >> diff --git a/tools/bpf/bpftool/common.c b/tools/bpf/bpftool/common.c
> >> index a45b42ee8ab0..a0d4acd7c54a 100644
> >> --- a/tools/bpf/bpftool/common.c
> >> +++ b/tools/bpf/bpftool/common.c
> >> @@ -17,6 +17,7 @@
> >>   #include <linux/magic.h>
> >>   #include <net/if.h>
> >>   #include <sys/mount.h>
> >> +#include <sys/resource.h>
> >>   #include <sys/stat.h>
> >>   #include <sys/vfs.h>
> >
> >> @@ -72,6 +73,13 @@ static bool is_bpffs(char *path)
> >>       return (unsigned long)st_fs.f_type == BPF_FS_MAGIC;
> >>   }
> >
> >> +void set_max_rlimit(void)
> >> +{
> >> +    struct rlimit rinf = { RLIM_INFINITY, RLIM_INFINITY };
> >> +
> >> +    setrlimit(RLIMIT_MEMLOCK, &rinf);
> >
> > Do you think it might make sense to print to stderr some warning if
> > we actually happen to adjust this limit?
> >
> > if (getrlimit(MEMLOCK) != RLIM_INFINITY) {
> >     fprintf(stderr, "Warning: resetting MEMLOCK rlimit to
> >     infinity!\n");
> >     setrlimit(RLIMIT_MEMLOCK, &rinf);
> > }
> >
> > ?
> >
> > Because while it's nice that we automatically do this, this might still
> > lead to surprises for some users. OTOH, not sure whether people
> > actually read those warnings? :-/
>
> I'm not strictly opposed to a warning, but I'm not completely sure this
> is desirable.
>
> Bpftool has raised the rlimit for a long time, it changed only in April,
> so I don't think it would come up as a surprise for people who have used
> it for a while. I think this is also something that several other
> BPF-related applications (BCC I think?, bpftrace, Cilium come to mind)
> have been doing too.

In this case ignore me and let's continue doing that :-)

Btw, eventually we'd still like to stop doing that I'd presume? Should
we at some point follow up with something like:

if (kernel_version >= 5.11) { don't touch memlock; }

?

I guess we care only about <5.11 because of the backports, but 5.11+
kernels are guaranteed to have memcg.

I'm not sure whether memlock is used out there in the distros (and
especially for root/bpf_capable), so I'm also not sure whether we
really care or not.

> For new users, I agree the warning may be helpful. But then the message
> is likely to appear the very first time a user runs the command - likely
> as root - and I fear this might worry people not familiar with rlimits,
> who would wonder if they just broke something on their system? Maybe
> with a different phrasing.
>
> Alternatively we could document it in the relevant man pages (not that
> people would see it better, but at least it would be mentioned somewhere
> if people take the time to read the docs)? What do you think?
>
> Quentin

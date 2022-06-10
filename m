Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B52E4546B90
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 19:18:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346265AbiFJRRv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jun 2022 13:17:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237145AbiFJRRo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jun 2022 13:17:44 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF25BBF62
        for <netdev@vger.kernel.org>; Fri, 10 Jun 2022 10:17:43 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id r1so6040176plo.10
        for <netdev@vger.kernel.org>; Fri, 10 Jun 2022 10:17:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9ttz4bPrCursTk4sx46Z+Dtzyu0QFB6lL4vSkzPH+Qs=;
        b=kfx0j+JVhks0EOJJVtIHFxH7i/xb97JzILl3ylQ1mG84AWw2PQ42Wb7TETv7GNOh9Q
         qrBM5TEiI9bfwFkvHZj7fLlp1UKBfbs9ZG9fHTdV5q0q7d2b0dFwBerJzLjCzlKQAXmP
         Taovmiu6QzQQboqKwZJRknYbcVGMpyPlpbDRN4Yu5HuadKPlYGGioScVcgAJmbK3RNPR
         vTqAy4+zMzR7Z4laWiwxvaj77VYKhyifN9f0KaW5u1lknjwP2SDvBHwV11uV8LSaCPux
         IQUdW2O68YWaHbL/2L464JI+1oaWyB+FyhZmSzpbVs/F6ufcr2T3mQwCA3hhQq6nB3Bl
         tzVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9ttz4bPrCursTk4sx46Z+Dtzyu0QFB6lL4vSkzPH+Qs=;
        b=PeKFvxyix3UnklByhYejVBP6o22DtKg3SOu+QEh92J/Y2iO0tqJn7mV7CCzhSpyfOV
         xq98MUTCcui0BjLMnVCpGUEkmBxzYVm6EHouLY/soKvcRySeNYofYwjGUebJV2nF/l59
         g6MdUg+23mmFbV09dFB2lzUTe5EU1t37Q/x211juDQ9x54gO+90ZJY15QH94eKhJAd1F
         8HGxKUFRT+J8yx97WWFTG+eReKNjmOdKZIuCj/eWzdfbAgIyeUHCTm09L3hjKlvbZ2Ha
         YlJ1Ro5+qJ+B1+MkJY+SiGFNTwp0iX5rqtdroKSvRyN3vX8PZlDrNXpLuUyNqJ93ujLR
         Q1CA==
X-Gm-Message-State: AOAM532sT3ldsvoomUXhUxTH+++5URKpOsRc6HY1KHe5EcRA62s64adq
        iIJGdhxny/zhiloDdAoszXI6wuNdkHzEque2HUA2tA==
X-Google-Smtp-Source: ABdhPJxcU/8YS9jnwO3jvpiUISxnTvjV+YDFkosxB5+TNZt0WLfe1dzVA5ZvpV0Ez/dBrWehMOI7YmcLi3/fbw6YNWQ=
X-Received: by 2002:a17:90b:188:b0:1e3:1feb:edb2 with SMTP id
 t8-20020a17090b018800b001e31febedb2mr717927pjs.195.1654881462919; Fri, 10 Jun
 2022 10:17:42 -0700 (PDT)
MIME-Version: 1.0
References: <20220610112648.29695-1-quentin@isovalent.com> <20220610112648.29695-2-quentin@isovalent.com>
 <YqNsWAH24bAIPjqy@google.com> <cb05a59e-07d5-ddd1-b028-82133faaf67e@isovalent.com>
 <CAKH8qBvvq0f+D8BXChw_8krH896J_cYg0yhRfnDOSO_U1n394w@mail.gmail.com> <71b56050-11ad-bd06-09c9-1a8c61b4c1b4@isovalent.com>
In-Reply-To: <71b56050-11ad-bd06-09c9-1a8c61b4c1b4@isovalent.com>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Fri, 10 Jun 2022 10:17:31 -0700
Message-ID: <CAKH8qBsFyakQRd1q6XWggdv4F5+HrHoC4njg9jQFDOfq+kRBCQ@mail.gmail.com>
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

On Fri, Jun 10, 2022 at 10:00 AM Quentin Monnet <quentin@isovalent.com> wrote:
>
> 2022-06-10 09:46 UTC-0700 ~ Stanislav Fomichev <sdf@google.com>
> > On Fri, Jun 10, 2022 at 9:34 AM Quentin Monnet <quentin@isovalent.com> wrote:
> >>
> >> 2022-06-10 09:07 UTC-0700 ~ sdf@google.com
> >>> On 06/10, Quentin Monnet wrote:
> >>>> This reverts commit a777e18f1bcd32528ff5dfd10a6629b655b05eb8.
> >>>
> >>>> In commit a777e18f1bcd ("bpftool: Use libbpf 1.0 API mode instead of
> >>>> RLIMIT_MEMLOCK"), we removed the rlimit bump in bpftool, because the
> >>>> kernel has switched to memcg-based memory accounting. Thanks to the
> >>>> LIBBPF_STRICT_AUTO_RLIMIT_MEMLOCK, we attempted to keep compatibility
> >>>> with other systems and ask libbpf to raise the limit for us if
> >>>> necessary.
> >>>
> >>>> How do we know if memcg-based accounting is supported? There is a probe
> >>>> in libbpf to check this. But this probe currently relies on the
> >>>> availability of a given BPF helper, bpf_ktime_get_coarse_ns(), which
> >>>> landed in the same kernel version as the memory accounting change. This
> >>>> works in the generic case, but it may fail, for example, if the helper
> >>>> function has been backported to an older kernel. This has been observed
> >>>> for Google Cloud's Container-Optimized OS (COS), where the helper is
> >>>> available but rlimit is still in use. The probe succeeds, the rlimit is
> >>>> not raised, and probing features with bpftool, for example, fails.
> >>>
> >>>> A patch was submitted [0] to update this probe in libbpf, based on what
> >>>> the cilium/ebpf Go library does [1]. It would lower the soft rlimit to
> >>>> 0, attempt to load a BPF object, and reset the rlimit. But it may induce
> >>>> some hard-to-debug flakiness if another process starts, or the current
> >>>> application is killed, while the rlimit is reduced, and the approach was
> >>>> discarded.
> >>>
> >>>> As a workaround to ensure that the rlimit bump does not depend on the
> >>>> availability of a given helper, we restore the unconditional rlimit bump
> >>>> in bpftool for now.
> >>>
> >>>> [0]
> >>>> https://lore.kernel.org/bpf/20220609143614.97837-1-quentin@isovalent.com/
> >>>> [1] https://github.com/cilium/ebpf/blob/v0.9.0/rlimit/rlimit.go#L39
> >>>
> >>>> Cc: Yafang Shao <laoar.shao@gmail.com>
> >>>> Signed-off-by: Quentin Monnet <quentin@isovalent.com>
> >>>> ---
> >>>>   tools/bpf/bpftool/common.c     | 8 ++++++++
> >>>>   tools/bpf/bpftool/feature.c    | 2 ++
> >>>>   tools/bpf/bpftool/main.c       | 6 +++---
> >>>>   tools/bpf/bpftool/main.h       | 2 ++
> >>>>   tools/bpf/bpftool/map.c        | 2 ++
> >>>>   tools/bpf/bpftool/pids.c       | 1 +
> >>>>   tools/bpf/bpftool/prog.c       | 3 +++
> >>>>   tools/bpf/bpftool/struct_ops.c | 2 ++
> >>>>   8 files changed, 23 insertions(+), 3 deletions(-)
> >>>
> >>>> diff --git a/tools/bpf/bpftool/common.c b/tools/bpf/bpftool/common.c
> >>>> index a45b42ee8ab0..a0d4acd7c54a 100644
> >>>> --- a/tools/bpf/bpftool/common.c
> >>>> +++ b/tools/bpf/bpftool/common.c
> >>>> @@ -17,6 +17,7 @@
> >>>>   #include <linux/magic.h>
> >>>>   #include <net/if.h>
> >>>>   #include <sys/mount.h>
> >>>> +#include <sys/resource.h>
> >>>>   #include <sys/stat.h>
> >>>>   #include <sys/vfs.h>
> >>>
> >>>> @@ -72,6 +73,13 @@ static bool is_bpffs(char *path)
> >>>>       return (unsigned long)st_fs.f_type == BPF_FS_MAGIC;
> >>>>   }
> >>>
> >>>> +void set_max_rlimit(void)
> >>>> +{
> >>>> +    struct rlimit rinf = { RLIM_INFINITY, RLIM_INFINITY };
> >>>> +
> >>>> +    setrlimit(RLIMIT_MEMLOCK, &rinf);
> >>>
> >>> Do you think it might make sense to print to stderr some warning if
> >>> we actually happen to adjust this limit?
> >>>
> >>> if (getrlimit(MEMLOCK) != RLIM_INFINITY) {
> >>>     fprintf(stderr, "Warning: resetting MEMLOCK rlimit to
> >>>     infinity!\n");
> >>>     setrlimit(RLIMIT_MEMLOCK, &rinf);
> >>> }
> >>>
> >>> ?
> >>>
> >>> Because while it's nice that we automatically do this, this might still
> >>> lead to surprises for some users. OTOH, not sure whether people
> >>> actually read those warnings? :-/
> >>
> >> I'm not strictly opposed to a warning, but I'm not completely sure this
> >> is desirable.
> >>
> >> Bpftool has raised the rlimit for a long time, it changed only in April,
> >> so I don't think it would come up as a surprise for people who have used
> >> it for a while. I think this is also something that several other
> >> BPF-related applications (BCC I think?, bpftrace, Cilium come to mind)
> >> have been doing too.
> >
> > In this case ignore me and let's continue doing that :-)
> >
> > Btw, eventually we'd still like to stop doing that I'd presume?
>
> Agreed. I was thinking either finding a way to improve the probe in
> libbpf, or waiting for some more time until 5.11 gets old, but this may
> take years :/
>
> > Should
> > we at some point follow up with something like:
> >
> > if (kernel_version >= 5.11) { don't touch memlock; }
> >
> > ?
> >
> > I guess we care only about <5.11 because of the backports, but 5.11+
> > kernels are guaranteed to have memcg.
>
> You mean from uname() and parsing the release? Yes I suppose we could do
> that, can do as a follow-up.

Yeah, uname-based, I don't think we can do better? Given that probing
is problematic as well :-(
But idk, up to you.

> > I'm not sure whether memlock is used out there in the distros (and
> > especially for root/bpf_capable), so I'm also not sure whether we
> > really care or not.
>
> Not sure either. For what it's worth, I've never seen complaints so far
> from users about the rlimit being raised (from bpftool or other BPF apps).

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CCA354BC71
	for <lists+netdev@lfdr.de>; Tue, 14 Jun 2022 23:05:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357389AbiFNVCN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jun 2022 17:02:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357447AbiFNVCI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jun 2022 17:02:08 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7164950462
        for <netdev@vger.kernel.org>; Tue, 14 Jun 2022 14:02:07 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id 184so9560581pga.12
        for <netdev@vger.kernel.org>; Tue, 14 Jun 2022 14:02:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SHxXe2riG1wu4DyXW3xH4fwoN0WkfcwtBj/NeXiNoms=;
        b=V8m1jq4MVkbIYD/KOvGCSl3edsAglgmPRKriRmiHncVJcT8slt8tJKq7KEy3i4XjkO
         e4OXsae53Ef2MyrYsrpZ8dbtvK9EifD1lAKi5qxDCBiRXR+/Df+unoE1zJMpD5ZCQNWl
         nw31q+NTsTs96+ywdmmUsilq+SCWLm/1MozQOJDX485D81trArCac2Bomio+CPI2aTI6
         Fr2bsTtdEEUTTIpEtfnlYFWre54P9kmIHrUrLmOJ3PV6LgXzyDk0T8r1iwb2heuLHmSU
         LVzc8l2h4e6mCv2IHGRxkxKwsl0VQJ7uzmf4w28/dQwYtj+AgNfZv/7+HkRUS2gviFPV
         N5Hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SHxXe2riG1wu4DyXW3xH4fwoN0WkfcwtBj/NeXiNoms=;
        b=rGW5Qb6yKqIJxPPaYna720vhQ0Bjvxwt41MJMCC3MfApW88zmYdML/Ba2tk1Dd+VvH
         zTRuA4kxXFrBDhOprwteVLyacZKXUBLiVzYN8J+L9AlnFucHrxFmuHFSPhAkVhnq3zWS
         dNUNq+9KhflkNQyH2Ve/RqVEzAnKnfVOQ8dC4Kp9KBBWQMKLX5Q5qsQh5bJI7miGqGPB
         RelkUIJvexOW3tEljnAC29qjRKCjWHikXUXUnkWQZLiKgoUoKYlndrhuhp5yZeMQewih
         QQAT8ps5lmjE0hr2bTNJCpL1flFv2iz9FOjePas4renz9LgTu3JHk5TUCN0SlfJpkGG6
         JXhA==
X-Gm-Message-State: AJIora+StmJbBFxp93dxi4Mj/fesMGdDbGJPKHd3ZjYLMH6Wyy4c2Gdx
        YeaO/SMTOr/eOmD+opeA/PDqNBZVR6bPUXFWmS1IPg==
X-Google-Smtp-Source: AGRyM1sImoCm55vOxI+tSOhrsLlZO7gfPQ8aK+ePiskQNRIoDBKjFqqcTU3f1kdzmVJ/iABDaVGGaCUu1RnLusGixsE=
X-Received: by 2002:a63:90c7:0:b0:408:9c77:7a7e with SMTP id
 a190-20020a6390c7000000b004089c777a7emr3916372pge.191.1655240526694; Tue, 14
 Jun 2022 14:02:06 -0700 (PDT)
MIME-Version: 1.0
References: <20220610112648.29695-1-quentin@isovalent.com> <20220610112648.29695-2-quentin@isovalent.com>
 <YqNsWAH24bAIPjqy@google.com> <cb05a59e-07d5-ddd1-b028-82133faaf67e@isovalent.com>
 <CAKH8qBvvq0f+D8BXChw_8krH896J_cYg0yhRfnDOSO_U1n394w@mail.gmail.com>
 <71b56050-11ad-bd06-09c9-1a8c61b4c1b4@isovalent.com> <CAKH8qBsFyakQRd1q6XWggdv4F5+HrHoC4njg9jQFDOfq+kRBCQ@mail.gmail.com>
 <CALOAHbCvWzOJ169fPTCp1KsFpkEVukKgGnH4mDeYGOEv6hsEpQ@mail.gmail.com>
 <e9aa57d2-4ce7-23f2-0ba1-ea58f3254353@isovalent.com> <5cd8428d-5d09-3676-cd18-93746d8961e2@iogearbox.net>
In-Reply-To: <5cd8428d-5d09-3676-cd18-93746d8961e2@iogearbox.net>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Tue, 14 Jun 2022 14:01:54 -0700
Message-ID: <CAKH8qBtEvAgbHPq0HJRNmDiE35km26-7+Z-9oKYxwNKyufda-g@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/2] Revert "bpftool: Use libbpf 1.0 API mode
 instead of RLIMIT_MEMLOCK"
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Quentin Monnet <quentin@isovalent.com>,
        Yafang Shao <laoar.shao@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Harsh Modi <harshmodi@google.com>,
        Paul Chaignon <paul@cilium.io>,
        netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
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

On Tue, Jun 14, 2022 at 1:34 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> On 6/14/22 4:20 PM, Quentin Monnet wrote:
> > 2022-06-14 20:37 UTC+0800 ~ Yafang Shao <laoar.shao@gmail.com>
> >> On Sat, Jun 11, 2022 at 1:17 AM Stanislav Fomichev <sdf@google.com> wrote:
> >>> On Fri, Jun 10, 2022 at 10:00 AM Quentin Monnet <quentin@isovalent.com> wrote:
> >>>> 2022-06-10 09:46 UTC-0700 ~ Stanislav Fomichev <sdf@google.com>
> >>>>> On Fri, Jun 10, 2022 at 9:34 AM Quentin Monnet <quentin@isovalent.com> wrote:
> >>>>>> 2022-06-10 09:07 UTC-0700 ~ sdf@google.com
> >>>>>>> On 06/10, Quentin Monnet wrote:
> >>>>>>>> This reverts commit a777e18f1bcd32528ff5dfd10a6629b655b05eb8.
> >>>>>>>
> >>>>>>>> In commit a777e18f1bcd ("bpftool: Use libbpf 1.0 API mode instead of
> >>>>>>>> RLIMIT_MEMLOCK"), we removed the rlimit bump in bpftool, because the
> >>>>>>>> kernel has switched to memcg-based memory accounting. Thanks to the
> >>>>>>>> LIBBPF_STRICT_AUTO_RLIMIT_MEMLOCK, we attempted to keep compatibility
> >>>>>>>> with other systems and ask libbpf to raise the limit for us if
> >>>>>>>> necessary.
> >>>>>>>
> >>>>>>>> How do we know if memcg-based accounting is supported? There is a probe
> >>>>>>>> in libbpf to check this. But this probe currently relies on the
> >>>>>>>> availability of a given BPF helper, bpf_ktime_get_coarse_ns(), which
> >>>>>>>> landed in the same kernel version as the memory accounting change. This
> >>>>>>>> works in the generic case, but it may fail, for example, if the helper
> >>>>>>>> function has been backported to an older kernel. This has been observed
> >>>>>>>> for Google Cloud's Container-Optimized OS (COS), where the helper is
> >>>>>>>> available but rlimit is still in use. The probe succeeds, the rlimit is
> >>>>>>>> not raised, and probing features with bpftool, for example, fails.
> >>>>>>>
> >>>>>>>> A patch was submitted [0] to update this probe in libbpf, based on what
> >>>>>>>> the cilium/ebpf Go library does [1]. It would lower the soft rlimit to
> >>>>>>>> 0, attempt to load a BPF object, and reset the rlimit. But it may induce
> >>>>>>>> some hard-to-debug flakiness if another process starts, or the current
> >>>>>>>> application is killed, while the rlimit is reduced, and the approach was
> >>>>>>>> discarded.
> >>>>>>>
> >>>>>>>> As a workaround to ensure that the rlimit bump does not depend on the
> >>>>>>>> availability of a given helper, we restore the unconditional rlimit bump
> >>>>>>>> in bpftool for now.
> >>>>>>>
> >>>>>>>> [0]
> >>>>>>>> https://lore.kernel.org/bpf/20220609143614.97837-1-quentin@isovalent.com/
> >>>>>>>> [1] https://github.com/cilium/ebpf/blob/v0.9.0/rlimit/rlimit.go#L39
> >>>>>>>
> >>>>>>>> Cc: Yafang Shao <laoar.shao@gmail.com>
> >>>>>>>> Signed-off-by: Quentin Monnet <quentin@isovalent.com>
> >>>>>>>> ---
> >>>>>>>>    tools/bpf/bpftool/common.c     | 8 ++++++++
> >>>>>>>>    tools/bpf/bpftool/feature.c    | 2 ++
> >>>>>>>>    tools/bpf/bpftool/main.c       | 6 +++---
> >>>>>>>>    tools/bpf/bpftool/main.h       | 2 ++
> >>>>>>>>    tools/bpf/bpftool/map.c        | 2 ++
> >>>>>>>>    tools/bpf/bpftool/pids.c       | 1 +
> >>>>>>>>    tools/bpf/bpftool/prog.c       | 3 +++
> >>>>>>>>    tools/bpf/bpftool/struct_ops.c | 2 ++
> >>>>>>>>    8 files changed, 23 insertions(+), 3 deletions(-)
> >>>>>>>
> >>>>>>>> diff --git a/tools/bpf/bpftool/common.c b/tools/bpf/bpftool/common.c
> >>>>>>>> index a45b42ee8ab0..a0d4acd7c54a 100644
> >>>>>>>> --- a/tools/bpf/bpftool/common.c
> >>>>>>>> +++ b/tools/bpf/bpftool/common.c
> >>>>>>>> @@ -17,6 +17,7 @@
> >>>>>>>>    #include <linux/magic.h>
> >>>>>>>>    #include <net/if.h>
> >>>>>>>>    #include <sys/mount.h>
> >>>>>>>> +#include <sys/resource.h>
> >>>>>>>>    #include <sys/stat.h>
> >>>>>>>>    #include <sys/vfs.h>
> >>>>>>>
> >>>>>>>> @@ -72,6 +73,13 @@ static bool is_bpffs(char *path)
> >>>>>>>>        return (unsigned long)st_fs.f_type == BPF_FS_MAGIC;
> >>>>>>>>    }
> >>>>>>>
> >>>>>>>> +void set_max_rlimit(void)
> >>>>>>>> +{
> >>>>>>>> +    struct rlimit rinf = { RLIM_INFINITY, RLIM_INFINITY };
> >>>>>>>> +
> >>>>>>>> +    setrlimit(RLIMIT_MEMLOCK, &rinf);
> >>>>>>>
> >>>>>>> Do you think it might make sense to print to stderr some warning if
> >>>>>>> we actually happen to adjust this limit?
> >>>>>>>
> >>>>>>> if (getrlimit(MEMLOCK) != RLIM_INFINITY) {
> >>>>>>>      fprintf(stderr, "Warning: resetting MEMLOCK rlimit to
> >>>>>>>      infinity!\n");
> >>>>>>>      setrlimit(RLIMIT_MEMLOCK, &rinf);
> >>>>>>> }
> >>>>>>>
> >>>>>>> ?
> >>>>>>>
> >>>>>>> Because while it's nice that we automatically do this, this might still
> >>>>>>> lead to surprises for some users. OTOH, not sure whether people
> >>>>>>> actually read those warnings? :-/
> >>>>>>
> >>>>>> I'm not strictly opposed to a warning, but I'm not completely sure this
> >>>>>> is desirable.
> >>>>>>
> >>>>>> Bpftool has raised the rlimit for a long time, it changed only in April,
> >>>>>> so I don't think it would come up as a surprise for people who have used
> >>>>>> it for a while. I think this is also something that several other
> >>>>>> BPF-related applications (BCC I think?, bpftrace, Cilium come to mind)
> >>>>>> have been doing too.
> >>>>>
> >>>>> In this case ignore me and let's continue doing that :-)
> >>>>>
> >>>>> Btw, eventually we'd still like to stop doing that I'd presume?
> >>>>
> >>>> Agreed. I was thinking either finding a way to improve the probe in
> >>>> libbpf, or waiting for some more time until 5.11 gets old, but this may
> >>>> take years :/
> >>>>
> >>>>> Should
> >>>>> we at some point follow up with something like:
> >>>>>
> >>>>> if (kernel_version >= 5.11) { don't touch memlock; }
> >>>>>
> >>>>> ?
> >>>>>
> >>>>> I guess we care only about <5.11 because of the backports, but 5.11+
> >>>>> kernels are guaranteed to have memcg.
> >>>>
> >>>> You mean from uname() and parsing the release? Yes I suppose we could do
> >>>> that, can do as a follow-up.
> >>>
> >>> Yeah, uname-based, I don't think we can do better? Given that probing
> >>> is problematic as well :-(
> >>> But idk, up to you.
> >>
> >> Agreed with the uname-based solution. Another possible solution is to
> >> probe the member 'memcg' in struct bpf_map, in case someone may
> >> backport memcg-based  memory accounting, but that will be a little
> >> over-engineering. The uname-based solution is simple and can work.
> >
> > Thanks! Yes, memcg would be more complex: the struct is not exposed to
> > user space, and BTF is not a hard dependency for bpftool. I'll work on
> > the uname-based test as a follow-up to this set.
>
> How would this work for things like RHEL? Maybe two potential workarounds ...
> 1) We could use a different helper for the probing and see how far we get with
> it.. though not great, probably still rare enough that we would run into it
> again. 2) Maybe we could create a temp memcg and check whether we get accounted
> against it on prog load (e.g. despite high rlimit)?

This might be dangerous as well: we don't want to move to a different
cgroup and move back; if we are in a multithreaded application, other
threads might potentially create resources in that temp directory. And
I don't think we can fork as well since we are in a library :-(

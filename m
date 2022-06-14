Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01F6154B18C
	for <lists+netdev@lfdr.de>; Tue, 14 Jun 2022 14:56:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356421AbiFNMmB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jun 2022 08:42:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356257AbiFNMln (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jun 2022 08:41:43 -0400
Received: from mail-vs1-xe2c.google.com (mail-vs1-xe2c.google.com [IPv6:2607:f8b0:4864:20::e2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D37B949F1A;
        Tue, 14 Jun 2022 05:38:32 -0700 (PDT)
Received: by mail-vs1-xe2c.google.com with SMTP id i186so8790265vsc.9;
        Tue, 14 Jun 2022 05:38:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OEeIbFtR1YJ0tKMAVjkS0/RYn5SHAacIhGI2Z7HNRyY=;
        b=MV3Pu/CXvXvq2gGE/O6udZ5k3Uu/AQ7FfIypxbXlfoQGeUC9EIbW8b65JQK7t3IT7Q
         Jba5aO7U+lUXMweSlgaDTrVZctBiOf+mSPD+wlSFvPp4TDcksfNEE2wRIbIwBGfGHJeJ
         y77XW4vSoFUfTejsKjNAYBGNcLjZNMiZnxd1/GVHB70f9CNYcpvy6mOkhsAuvMaJvsOr
         QrUIFTIXVb6jYo0x9Ne7aJPDCqWbZpjzTQDZP6MN1AvIzylQsZKBBvmOVmlUJtMKs+yK
         fZghWPW0G5mkXSNSk+JFFRaLT6/me1MxXBxpQLO872SqDC8YKl1bQWWIFpDtoMH/bfkQ
         ONAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OEeIbFtR1YJ0tKMAVjkS0/RYn5SHAacIhGI2Z7HNRyY=;
        b=KMQPFbnbPJeVKY2evXsmlNb5WEJMloB6v8vZwpLozrG+4KBuraYeqnvsHyp8GFmZ0Y
         nhMy0AFaynzW3f9Vrc41fnFtdzumPnXqzT8RKWTGundrhmlid97Qsn1H3NzbFsI15Ys6
         ue9iemvsvLyY4O693h8PSsXFAeIBUfoK1SpoLVkO61lDDv8XMM/DLUaBGVypedhKf+p0
         mEg1+920ALXIqEqb0dkbVUZLZZQviNPs46IgGY7OcEowTCFkzKkEdeXr/5HylnjyOhHH
         umOEo23L/IRK5dCJmjJRzdEoM49fEp8ZzeIBk6rOy5nJDRAgAeGCg1BnkSgubChkz/7B
         E3kg==
X-Gm-Message-State: AJIora/JUdo6jkcJLOwsl2+lJJI/zkrZltyj7C6M41BOOch3YNoHDMWj
        CSyDKmptvJnBCIhUtYafbHO26ehUHRxxPdiStuqO6x+yzyg=
X-Google-Smtp-Source: AGRyM1ufNFkqXaj4uNPKxKMLjpWCupZWqJmfv+3bhR1aC06VAJzkdSEMkWKgbWMzOs50Yt6YIec2EIUi6AJPxWSCsgU=
X-Received: by 2002:a05:6102:2134:b0:34c:40bc:aa4e with SMTP id
 f20-20020a056102213400b0034c40bcaa4emr1847615vsg.16.1655210311631; Tue, 14
 Jun 2022 05:38:31 -0700 (PDT)
MIME-Version: 1.0
References: <20220610112648.29695-1-quentin@isovalent.com> <20220610112648.29695-2-quentin@isovalent.com>
 <YqNsWAH24bAIPjqy@google.com> <cb05a59e-07d5-ddd1-b028-82133faaf67e@isovalent.com>
 <CAKH8qBvvq0f+D8BXChw_8krH896J_cYg0yhRfnDOSO_U1n394w@mail.gmail.com>
 <71b56050-11ad-bd06-09c9-1a8c61b4c1b4@isovalent.com> <CAKH8qBsFyakQRd1q6XWggdv4F5+HrHoC4njg9jQFDOfq+kRBCQ@mail.gmail.com>
In-Reply-To: <CAKH8qBsFyakQRd1q6XWggdv4F5+HrHoC4njg9jQFDOfq+kRBCQ@mail.gmail.com>
From:   Yafang Shao <laoar.shao@gmail.com>
Date:   Tue, 14 Jun 2022 20:37:55 +0800
Message-ID: <CALOAHbCvWzOJ169fPTCp1KsFpkEVukKgGnH4mDeYGOEv6hsEpQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/2] Revert "bpftool: Use libbpf 1.0 API mode
 instead of RLIMIT_MEMLOCK"
To:     Stanislav Fomichev <sdf@google.com>
Cc:     Quentin Monnet <quentin@isovalent.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Harsh Modi <harshmodi@google.com>,
        Paul Chaignon <paul@cilium.io>,
        netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jun 11, 2022 at 1:17 AM Stanislav Fomichev <sdf@google.com> wrote:
>
> On Fri, Jun 10, 2022 at 10:00 AM Quentin Monnet <quentin@isovalent.com> wrote:
> >
> > 2022-06-10 09:46 UTC-0700 ~ Stanislav Fomichev <sdf@google.com>
> > > On Fri, Jun 10, 2022 at 9:34 AM Quentin Monnet <quentin@isovalent.com> wrote:
> > >>
> > >> 2022-06-10 09:07 UTC-0700 ~ sdf@google.com
> > >>> On 06/10, Quentin Monnet wrote:
> > >>>> This reverts commit a777e18f1bcd32528ff5dfd10a6629b655b05eb8.
> > >>>
> > >>>> In commit a777e18f1bcd ("bpftool: Use libbpf 1.0 API mode instead of
> > >>>> RLIMIT_MEMLOCK"), we removed the rlimit bump in bpftool, because the
> > >>>> kernel has switched to memcg-based memory accounting. Thanks to the
> > >>>> LIBBPF_STRICT_AUTO_RLIMIT_MEMLOCK, we attempted to keep compatibility
> > >>>> with other systems and ask libbpf to raise the limit for us if
> > >>>> necessary.
> > >>>
> > >>>> How do we know if memcg-based accounting is supported? There is a probe
> > >>>> in libbpf to check this. But this probe currently relies on the
> > >>>> availability of a given BPF helper, bpf_ktime_get_coarse_ns(), which
> > >>>> landed in the same kernel version as the memory accounting change. This
> > >>>> works in the generic case, but it may fail, for example, if the helper
> > >>>> function has been backported to an older kernel. This has been observed
> > >>>> for Google Cloud's Container-Optimized OS (COS), where the helper is
> > >>>> available but rlimit is still in use. The probe succeeds, the rlimit is
> > >>>> not raised, and probing features with bpftool, for example, fails.
> > >>>
> > >>>> A patch was submitted [0] to update this probe in libbpf, based on what
> > >>>> the cilium/ebpf Go library does [1]. It would lower the soft rlimit to
> > >>>> 0, attempt to load a BPF object, and reset the rlimit. But it may induce
> > >>>> some hard-to-debug flakiness if another process starts, or the current
> > >>>> application is killed, while the rlimit is reduced, and the approach was
> > >>>> discarded.
> > >>>
> > >>>> As a workaround to ensure that the rlimit bump does not depend on the
> > >>>> availability of a given helper, we restore the unconditional rlimit bump
> > >>>> in bpftool for now.
> > >>>
> > >>>> [0]
> > >>>> https://lore.kernel.org/bpf/20220609143614.97837-1-quentin@isovalent.com/
> > >>>> [1] https://github.com/cilium/ebpf/blob/v0.9.0/rlimit/rlimit.go#L39
> > >>>
> > >>>> Cc: Yafang Shao <laoar.shao@gmail.com>
> > >>>> Signed-off-by: Quentin Monnet <quentin@isovalent.com>
> > >>>> ---
> > >>>>   tools/bpf/bpftool/common.c     | 8 ++++++++
> > >>>>   tools/bpf/bpftool/feature.c    | 2 ++
> > >>>>   tools/bpf/bpftool/main.c       | 6 +++---
> > >>>>   tools/bpf/bpftool/main.h       | 2 ++
> > >>>>   tools/bpf/bpftool/map.c        | 2 ++
> > >>>>   tools/bpf/bpftool/pids.c       | 1 +
> > >>>>   tools/bpf/bpftool/prog.c       | 3 +++
> > >>>>   tools/bpf/bpftool/struct_ops.c | 2 ++
> > >>>>   8 files changed, 23 insertions(+), 3 deletions(-)
> > >>>
> > >>>> diff --git a/tools/bpf/bpftool/common.c b/tools/bpf/bpftool/common.c
> > >>>> index a45b42ee8ab0..a0d4acd7c54a 100644
> > >>>> --- a/tools/bpf/bpftool/common.c
> > >>>> +++ b/tools/bpf/bpftool/common.c
> > >>>> @@ -17,6 +17,7 @@
> > >>>>   #include <linux/magic.h>
> > >>>>   #include <net/if.h>
> > >>>>   #include <sys/mount.h>
> > >>>> +#include <sys/resource.h>
> > >>>>   #include <sys/stat.h>
> > >>>>   #include <sys/vfs.h>
> > >>>
> > >>>> @@ -72,6 +73,13 @@ static bool is_bpffs(char *path)
> > >>>>       return (unsigned long)st_fs.f_type == BPF_FS_MAGIC;
> > >>>>   }
> > >>>
> > >>>> +void set_max_rlimit(void)
> > >>>> +{
> > >>>> +    struct rlimit rinf = { RLIM_INFINITY, RLIM_INFINITY };
> > >>>> +
> > >>>> +    setrlimit(RLIMIT_MEMLOCK, &rinf);
> > >>>
> > >>> Do you think it might make sense to print to stderr some warning if
> > >>> we actually happen to adjust this limit?
> > >>>
> > >>> if (getrlimit(MEMLOCK) != RLIM_INFINITY) {
> > >>>     fprintf(stderr, "Warning: resetting MEMLOCK rlimit to
> > >>>     infinity!\n");
> > >>>     setrlimit(RLIMIT_MEMLOCK, &rinf);
> > >>> }
> > >>>
> > >>> ?
> > >>>
> > >>> Because while it's nice that we automatically do this, this might still
> > >>> lead to surprises for some users. OTOH, not sure whether people
> > >>> actually read those warnings? :-/
> > >>
> > >> I'm not strictly opposed to a warning, but I'm not completely sure this
> > >> is desirable.
> > >>
> > >> Bpftool has raised the rlimit for a long time, it changed only in April,
> > >> so I don't think it would come up as a surprise for people who have used
> > >> it for a while. I think this is also something that several other
> > >> BPF-related applications (BCC I think?, bpftrace, Cilium come to mind)
> > >> have been doing too.
> > >
> > > In this case ignore me and let's continue doing that :-)
> > >
> > > Btw, eventually we'd still like to stop doing that I'd presume?
> >
> > Agreed. I was thinking either finding a way to improve the probe in
> > libbpf, or waiting for some more time until 5.11 gets old, but this may
> > take years :/
> >
> > > Should
> > > we at some point follow up with something like:
> > >
> > > if (kernel_version >= 5.11) { don't touch memlock; }
> > >
> > > ?
> > >
> > > I guess we care only about <5.11 because of the backports, but 5.11+
> > > kernels are guaranteed to have memcg.
> >
> > You mean from uname() and parsing the release? Yes I suppose we could do
> > that, can do as a follow-up.
>
> Yeah, uname-based, I don't think we can do better? Given that probing
> is problematic as well :-(
> But idk, up to you.
>

Agreed with the uname-based solution. Another possible solution is to
probe the member 'memcg' in struct bpf_map, in case someone may
backport memcg-based  memory accounting, but that will be a little
over-engineering. The uname-based solution is simple and can work.

-- 
Regards
Yafang

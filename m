Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 291A61A87CB
	for <lists+netdev@lfdr.de>; Tue, 14 Apr 2020 19:43:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440591AbgDNRnc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Apr 2020 13:43:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2440555AbgDNRn2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Apr 2020 13:43:28 -0400
Received: from mail-qv1-xf44.google.com (mail-qv1-xf44.google.com [IPv6:2607:f8b0:4864:20::f44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3C51C061A0C;
        Tue, 14 Apr 2020 10:43:27 -0700 (PDT)
Received: by mail-qv1-xf44.google.com with SMTP id du18so282143qvb.4;
        Tue, 14 Apr 2020 10:43:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Sv7VWsJBKt+YEhRPmWvLM4uzEJs86xQEhIbF2jk45D4=;
        b=ruwWYPwAvMgzw/OCmjPf2FAwX7e3Ps5GaBvQqOCCir5RWSOuDepFz/apemM6T7ELtm
         4sm8Pc9k37LZ2HnmACkHiD/mjkp19RgvGqpHZGYo8oQbxVBhFMtX6BpNlBtxMoPUlSmJ
         Oi9pCJSt45YFISWmC/mZyupmZHdmHVEhLHCpDurMwEKaA2ObxG4qP0BrA32eoR0pYLjX
         jpGs6F+t6TNIuxWwGr3H6ye8tB3XvHmITrl+DvHvJShjckDGw0FUELhjFMONbKnYSpva
         WFCohknLwQFR5327/kKpQ73ehpmuOMU05Le6MNG0lP6ipjyE4vWWvEmNQXk40PbGrg7S
         42Tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Sv7VWsJBKt+YEhRPmWvLM4uzEJs86xQEhIbF2jk45D4=;
        b=mi7IhBhMtk0NHHsTW2AgYUHlUePqUdSwhJk9j/e6UzFrlRBOg9xN5JvFjroJqj/xJ7
         yo2oWGGpmdnPuizc8OWGugsX6R6v8OfRWqyJ0fCcC8HNbRGVPtnDCbt92Y2Njju4qFzn
         RsPQlV2y50l3OwHFkcNKZF3DPsM+ZClOqBRynUlBaxtZI4vypmL38GCMsFU82MhtsH+j
         Y7knkLM2I9WJ+lryTSkTQZUUh/5c3cCOdj5Wq/TQ3++YEZqL7SEREFHMpG8uZsVBULLN
         6U7q66rQusIYuvnjC3eoiswv1FOD0Ygo6DwuO4OhBrCV78JaZlZ/f/g4+9qLIBTFCHdH
         uiEA==
X-Gm-Message-State: AGi0PuZBBt1u/a6F/h1SSAi4ACE+gahL8b6uBO799vz3nbsgdvhkFMMe
        r8ehbtuTNl4Zps1kw8w87XjUt8NtF8Zbhrd0LdwjnOZ1
X-Google-Smtp-Source: APiQypKORlx+7aJwgXl3yUnhDRBVpDGg0oQXK9JPvzoXWbvvy8AWBxAumyUPMr6dVRggGqmTYhC/bxm9ytr+cWlXvkc=
X-Received: by 2002:ad4:42c9:: with SMTP id f9mr1097346qvr.228.1586886206954;
 Tue, 14 Apr 2020 10:43:26 -0700 (PDT)
MIME-Version: 1.0
References: <20200414045613.2104756-1-andriin@fb.com> <6E178D01-CF89-4AEA-8705-9789E58B1D46@fb.com>
In-Reply-To: <6E178D01-CF89-4AEA-8705-9789E58B1D46@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 14 Apr 2020 10:43:15 -0700
Message-ID: <CAEf4BzY0wQ7Db3f61na49R0wPtXDB=Ay5vdBtJQ+XegT9C6RKg@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next] libbpf: always specify expected_attach_type
 on program load if supported
To:     Song Liu <songliubraving@fb.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        Andrey Ignatov <rdna@fb.com>, Kernel Team <Kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 14, 2020 at 12:04 AM Song Liu <songliubraving@fb.com> wrote:
>
>
>
> > On Apr 13, 2020, at 9:56 PM, Andrii Nakryiko <andriin@fb.com> wrote:
> >
> > For some types of BPF programs that utilize expected_attach_type, libbpf won't
> > set load_attr.expected_attach_type, even if expected_attach_type is known from
> > section definition. This was done to preserve backwards compatibility with old
> > kernels that didn't recognize expected_attach_type attribute yet (which was
> > added in 5e43f899b03a ("bpf: Check attach type at prog load time"). But this
> > is problematic for some BPF programs that utilize never features that require
> > kernel to know specific expected_attach_type (e.g., extended set of return
> > codes for cgroup_skb/egress programs).
> >
> > This patch makes libbpf specify expected_attach_type by default, but also
> > detect support for this field in kernel and not set it during program load.
> > This allows to have a good metadata for bpf_program
> > (e.g., bpf_program__get_extected_attach_type()), but still work with old
> > kernels (for cases where it can work at all).
> >
> > Additionally, due to expected_attach_type being always set for recognized
> > program types, bpf_program__attach_cgroup doesn't have to do extra checks to
> > determine correct attach type, so remove that additional logic.
> >
> > Also adjust section_names selftest to account for this change.
> >
> > More detailed discussion can be found in [0].
> >
> >  [0] https://lore.kernel.org/bpf/20200412003604.GA15986@rdna-mbp.dhcp.thefacebook.com/
> >
> > Reported-by: Andrey Ignatov <rdna@fb.com>
> > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
>
> Acked-by: Song Liu <songliubraving@fb.com>
>
> With one nit below.
>
> > ---
> > v1->v2:
> > - fixed prog_type/expected_attach_type combo (Andrey);
> > - added comment explaining what we are doing in probe_exp_attach_type (Andrey).
> >
> > tools/lib/bpf/libbpf.c                        | 127 ++++++++++++------
> > .../selftests/bpf/prog_tests/section_names.c  |  42 +++---
> > 2 files changed, 110 insertions(+), 59 deletions(-)
> >
> > diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> > index ff9174282a8c..c7393182e2ae 100644
> > --- a/tools/lib/bpf/libbpf.c
> > +++ b/tools/lib/bpf/libbpf.c
> > @@ -178,6 +178,8 @@ struct bpf_capabilities {
> >       __u32 array_mmap:1;
> >       /* BTF_FUNC_GLOBAL is supported */
> >       __u32 btf_func_global:1;
> > +     /* kernel support for expected_attach_type in BPF_PROG_LOAD */
> > +     __u32 exp_attach_type:1;
> > };
>
> [...]
>
> > -#define BPF_PROG_SEC_IMPL(string, ptype, eatype, is_attachable, btf, atype) \
> > -     { string, sizeof(string) - 1, ptype, eatype, is_attachable, btf, atype }
> > +#define BPF_PROG_SEC_IMPL(string, ptype, eatype, eatype_optional,        \
> > +                       attachable, attach_btf)                           \
> > +     {                                                                   \
> > +             .sec = string,                                              \
> > +             .len = sizeof(string) - 1,                                  \
> > +             .prog_type = ptype,                                         \
> > +             .sec = string,                                              \
>
> Two lines of ".sec = string".


*facepalm*, will fix in next version, once bpf-next is open.

>
> > +             .expected_attach_type = eatype,                             \
> > +             .is_exp_attach_type_optional = eatype_optional,             \
> > +             .is_attachable = attachable,                                \
> > +             .is_attach_btf = attach_btf,                                \
> > +     }
>

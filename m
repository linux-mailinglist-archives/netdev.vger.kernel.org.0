Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE9293DC08C
	for <lists+netdev@lfdr.de>; Fri, 30 Jul 2021 23:56:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233357AbhG3V4t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Jul 2021 17:56:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232873AbhG3VzR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Jul 2021 17:55:17 -0400
Received: from mail-yb1-xb30.google.com (mail-yb1-xb30.google.com [IPv6:2607:f8b0:4864:20::b30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1202C0613D3;
        Fri, 30 Jul 2021 14:55:10 -0700 (PDT)
Received: by mail-yb1-xb30.google.com with SMTP id s48so18259799ybi.7;
        Fri, 30 Jul 2021 14:55:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ucMlZDLq0PkPJN6sHPh2Ls6egiVhlPqu3vmw+xBT+sY=;
        b=PLTHNBvXfstcgRMLKjG3pl3KbIZdwoIe1C4QfICkQZ3rTEBIC3WVtVql0nOFNKrf6M
         Ozo1IPfbM49xloWLJv0UppRC5re3tHeBEm0O3WmtErCGx6KsInzGsMnM58R3q/eCixfb
         w8TXWoj1NHPz09Qm3QsF2twHfkjxJIdz7FpOAgTFCH/iA4CYcZfM6Vf+Wg0QFfTTslaj
         n7aPT7xAQ09saI+za6QRjt1vnmnZJyzYszX+3+n3W6XYF0qBNOhp4NH1SZYSl3y/kIz0
         jxOL0piugFeOLDIBrJGzqfoM2B5nWBj+/Grs2E8FbdUXHtZh7TvbfbIyEJDWnK8lAhlq
         V72w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ucMlZDLq0PkPJN6sHPh2Ls6egiVhlPqu3vmw+xBT+sY=;
        b=QWfAzCqcCZRBtQOR34EfgVLlLB+rKBPxG9/017PghSTxKgQNkh7O/xAWhS/3oxZHrr
         U2RvtgAjDhBIUvNsp9fo/q+qFDiTv4WzRWwajkj26WKNYxQhpysLDpvEfZyBubML6osg
         nPQRy/OeX410a2zeB0JZEtw/45DPUgIGMScjdV2Kvm6UsLRuPrgg8Gx3vrGIvDxW6ZAm
         YBhngyAW6UJndX1SNUwXX12hZ+5v9xEUfpRdkfFCPs6Fu9dGdYXSqmDxNCFfdHRu8oJR
         qeDHvrYeTT+ikj+kkm2WIMesBLHb4I/2zxhWIlQ3XB6eo3OHRWd8Ckv9WSsxVJ/P5BQM
         3lnw==
X-Gm-Message-State: AOAM530t2lSQ2MmjmhDsGsH3hmK0Qt8Mt/vT9E2DD394h4Yz4lWI1h+I
        y/ZHROz5B4QQSqx6SSB50Qc6dS+KQL5IPZwzTWA=
X-Google-Smtp-Source: ABdhPJzgvD1MFK7zmqHhFL+sX2/ltjsgVlVBVvt6Iv4tz8VnJHZ0k1gWfpdn0Sw8u7dw/ooHA+OOyJKdOsNlE2Ie2IM=
X-Received: by 2002:a25:9942:: with SMTP id n2mr6130377ybo.230.1627682109757;
 Fri, 30 Jul 2021 14:55:09 -0700 (PDT)
MIME-Version: 1.0
References: <20210729162932.30365-1-quentin@isovalent.com> <20210729162932.30365-2-quentin@isovalent.com>
 <CAEf4BzadrpVDm6yAriDSXK2WOzbzeZJoGKxbRzH+KA4YUD7SEg@mail.gmail.com> <b80ab3fb-dc70-5b7e-b86a-8b2b9bded54e@isovalent.com>
In-Reply-To: <b80ab3fb-dc70-5b7e-b86a-8b2b9bded54e@isovalent.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 30 Jul 2021 14:54:58 -0700
Message-ID: <CAEf4BzZiJ5MeBaEVcJF4mVvusCvAHmkwz+NF1xNc6fGUk7Zg6w@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/7] tools: bpftool: slightly ease bash
 completion updates
To:     Quentin Monnet <quentin@isovalent.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 30, 2021 at 2:47 PM Quentin Monnet <quentin@isovalent.com> wrote:
>
> 2021-07-30 11:45 UTC-0700 ~ Andrii Nakryiko <andrii.nakryiko@gmail.com>
> > On Thu, Jul 29, 2021 at 9:29 AM Quentin Monnet <quentin@isovalent.com> wrote:
> >>
> >> Bash completion for bpftool gets two minor improvements in this patch.
> >>
> >> Move the detection of attach types for "bpftool cgroup attach" outside
> >> of the "case/esac" bloc, where we cannot reuse our variable holding the
> >> list of supported attach types as a pattern list. After the change, we
> >> have only one list of cgroup attach types to update when new types are
> >> added, instead of the former two lists.
> >>
> >> Also rename the variables holding lists of names for program types, map
> >> types, and attach types, to make them more unique. This can make it
> >> slightly easier to point people to the relevant variables to update, but
> >> the main objective here is to help run a script to check that bash
> >> completion is up-to-date with bpftool's source code.
> >>
> >> Signed-off-by: Quentin Monnet <quentin@isovalent.com>
> >> ---
> >>  tools/bpf/bpftool/bash-completion/bpftool | 57 +++++++++++++----------
> >>  1 file changed, 32 insertions(+), 25 deletions(-)
> >>
> >> diff --git a/tools/bpf/bpftool/bash-completion/bpftool b/tools/bpf/bpftool/bash-completion/bpftool
> >> index cc33c5824a2f..b2e33a2d8524 100644
> >> --- a/tools/bpf/bpftool/bash-completion/bpftool
> >> +++ b/tools/bpf/bpftool/bash-completion/bpftool
> >> @@ -404,8 +404,10 @@ _bpftool()
> >>                              return 0
> >>                              ;;
> >>                          5)
> >> -                            COMPREPLY=( $( compgen -W 'msg_verdict stream_verdict \
> >> -                                stream_parser flow_dissector' -- "$cur" ) )
> >> +                            local BPFTOOL_PROG_ATTACH_TYPES='msg_verdict \
> >> +                                stream_verdict stream_parser flow_dissector'
> >> +                            COMPREPLY=( $( compgen -W \
> >> +                                "$BPFTOOL_PROG_ATTACH_TYPES" -- "$cur" ) )
> >>                              return 0
> >>                              ;;
> >>                          6)
> >> @@ -464,7 +466,7 @@ _bpftool()
> >>
> >>                      case $prev in
> >>                          type)
> >> -                            COMPREPLY=( $( compgen -W "socket kprobe \
> >> +                            local BPFTOOL_PROG_LOAD_TYPES='socket kprobe \
> >>                                  kretprobe classifier flow_dissector \
> >>                                  action tracepoint raw_tracepoint \
> >>                                  xdp perf_event cgroup/skb cgroup/sock \
> >> @@ -479,8 +481,9 @@ _bpftool()
> >>                                  cgroup/post_bind4 cgroup/post_bind6 \
> >>                                  cgroup/sysctl cgroup/getsockopt \
> >>                                  cgroup/setsockopt cgroup/sock_release struct_ops \
> >> -                                fentry fexit freplace sk_lookup" -- \
> >> -                                                   "$cur" ) )
> >> +                                fentry fexit freplace sk_lookup'
> >> +                            COMPREPLY=( $( compgen -W \
> >> +                                "$BPFTOOL_PROG_LOAD_TYPES" -- "$cur" ) )
> >
> > nit: this and similar COMPREPLY assignments now can be on a single line now, no?
>
> It will go over 80 characters, but OK, it will probably be more readable
> on a single line. I'll change for v2.

80 character rule was lifted a while ago. 100 is totally fine. And in
some special cases readability beats even 100, IMO.

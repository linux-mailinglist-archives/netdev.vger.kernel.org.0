Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 802241B82A6
	for <lists+netdev@lfdr.de>; Sat, 25 Apr 2020 02:12:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726044AbgDYAMo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Apr 2020 20:12:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725851AbgDYAMn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Apr 2020 20:12:43 -0400
Received: from mail-qk1-x742.google.com (mail-qk1-x742.google.com [IPv6:2607:f8b0:4864:20::742])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01146C09B049;
        Fri, 24 Apr 2020 17:12:41 -0700 (PDT)
Received: by mail-qk1-x742.google.com with SMTP id t3so12179607qkg.1;
        Fri, 24 Apr 2020 17:12:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9Wt/T67FNeLrwS1ULzDdIDbtiVwDsVmKhlEyeu4qVTo=;
        b=sRk5e6acw+XgUeQ2uPzkrRqF22Uw7cL9nXAI/d3/WDAzR2oldsry2YbhiVlwxSAAW/
         K78D3h3LJ6TwuJMrtrBEncZ7564jM+x0+vshpReNs/qXEvT/IonS9ONq6EYVc0FLc4rm
         H62QvLp60An0RrhElhgmIGXpc8fp459DZjG04VWmfQQgXYfT69GrOE4gwMgIx4ngnLQQ
         2SqUQh7t94zkIUJgS7RXugksIQvPlCfL55CQx12qHDjwt7jhrsY33sJ0GDUSHCXucSUt
         /GD2MxP4d8x808jTj9jczK6jFveJwNQonqnNVQqNrswSurPempnZ5akSDyiPtsJNIG8G
         LIFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9Wt/T67FNeLrwS1ULzDdIDbtiVwDsVmKhlEyeu4qVTo=;
        b=CjbIjkMR0u0Tnsa8UixL2H97UogkM60dDnPCgRplDUJcgYJJ+B7YvnWkNu7fibIFf1
         jmicvhOHaxbp5dW4/ozBdmCgzslqFwGw+YYmxHELzXIYwvMwlcPEeFV3+UUIiY0qK/MI
         Be402lzt7UeoQx5mqGWCLh+/2QrHUbfl4X2gf3B1RDFCQxEh7N0CQ6OxF3wKuKf6Y0tY
         Oa5OA04cBj9HQHd2Sx18q9jXKmImhF1lsd8A24mtR3rpErUNAW2hyywnzPFUugYX6lrl
         buXYtuTVMUhZCFEjpE1q5XNN6CYbr0XlijJsXlyiL90rIZYuTHCdGzrc/jU3ZS9m7ATr
         zPUw==
X-Gm-Message-State: AGi0PuZPENZCksflpa0Lidv4qQ38mu751W291R9Q+n2GobhvGUbtWgR9
        gdQtORxz+5FVuxfvTGYFTWlHkFo8zE51jVfgr2c=
X-Google-Smtp-Source: APiQypJ46ScglxFpBQwHiw+yOY1EwAlseXmi6o3RdXb0t5ELZcFwUapru5tN6A4uCHyCBhRDG6bFxA5viBtuA6I7wT4=
X-Received: by 2002:a37:6587:: with SMTP id z129mr12205760qkb.437.1587773560859;
 Fri, 24 Apr 2020 17:12:40 -0700 (PDT)
MIME-Version: 1.0
References: <20200424053505.4111226-1-andriin@fb.com> <20200424053505.4111226-8-andriin@fb.com>
 <34110254-6384-153f-af39-d5f9f3a50acb@isovalent.com> <CAEf4BzY9tjQm1f8eTyjYjthTF9n6tZ59r1mpUsYWL4+bFuch2Q@mail.gmail.com>
 <5404b784-2173-210d-6319-fa5f0156701e@isovalent.com>
In-Reply-To: <5404b784-2173-210d-6319-fa5f0156701e@isovalent.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 24 Apr 2020 17:12:29 -0700
Message-ID: <CAEf4BzYZD2=XV+86DFfGvtfBEGkdHAEhxe7WebU2bm=okGJEcA@mail.gmail.com>
Subject: Re: [PATCH bpf-next 07/10] bpftool: expose attach_type-to-string
 array to non-cgroup code
To:     Quentin Monnet <quentin@isovalent.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 24, 2020 at 10:08 AM Quentin Monnet <quentin@isovalent.com> wrote:
>
> 2020-04-24 09:27 UTC-0700 ~ Andrii Nakryiko <andrii.nakryiko@gmail.com>
> > On Fri, Apr 24, 2020 at 3:32 AM Quentin Monnet <quentin@isovalent.com> wrote:
> >>
> >> 2020-04-23 22:35 UTC-0700 ~ Andrii Nakryiko <andriin@fb.com>
> >>> Move attach_type_strings into main.h for access in non-cgroup code.
> >>> bpf_attach_type is used for non-cgroup attach types quite widely now. So also
> >>> complete missing string translations for non-cgroup attach types.
> >>>
> >>> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> >>> ---
> >>>  tools/bpf/bpftool/cgroup.c | 28 +++-------------------------
> >>>  tools/bpf/bpftool/main.h   | 32 ++++++++++++++++++++++++++++++++
> >>>  2 files changed, 35 insertions(+), 25 deletions(-)
> >>>
> >>> diff --git a/tools/bpf/bpftool/cgroup.c b/tools/bpf/bpftool/cgroup.c
> >>> index 62c6a1d7cd18..d1fd9c9f2690 100644
> >>> --- a/tools/bpf/bpftool/cgroup.c
> >>> +++ b/tools/bpf/bpftool/cgroup.c
> >>> @@ -31,35 +31,13 @@
> >>>
> >>>  static unsigned int query_flags;
> >>>
> >>> -static const char * const attach_type_strings[] = {
> >>> -     [BPF_CGROUP_INET_INGRESS] = "ingress",
> >>> -     [BPF_CGROUP_INET_EGRESS] = "egress",
> >>> -     [BPF_CGROUP_INET_SOCK_CREATE] = "sock_create",
> >>> -     [BPF_CGROUP_SOCK_OPS] = "sock_ops",
> >>> -     [BPF_CGROUP_DEVICE] = "device",
> >>> -     [BPF_CGROUP_INET4_BIND] = "bind4",
> >>> -     [BPF_CGROUP_INET6_BIND] = "bind6",
> >>> -     [BPF_CGROUP_INET4_CONNECT] = "connect4",
> >>> -     [BPF_CGROUP_INET6_CONNECT] = "connect6",
> >>> -     [BPF_CGROUP_INET4_POST_BIND] = "post_bind4",
> >>> -     [BPF_CGROUP_INET6_POST_BIND] = "post_bind6",
> >>> -     [BPF_CGROUP_UDP4_SENDMSG] = "sendmsg4",
> >>> -     [BPF_CGROUP_UDP6_SENDMSG] = "sendmsg6",
> >>> -     [BPF_CGROUP_SYSCTL] = "sysctl",
> >>> -     [BPF_CGROUP_UDP4_RECVMSG] = "recvmsg4",
> >>> -     [BPF_CGROUP_UDP6_RECVMSG] = "recvmsg6",
> >>> -     [BPF_CGROUP_GETSOCKOPT] = "getsockopt",
> >>> -     [BPF_CGROUP_SETSOCKOPT] = "setsockopt",
> >>> -     [__MAX_BPF_ATTACH_TYPE] = NULL,
> >>
> >> So you removed the "[__MAX_BPF_ATTACH_TYPE] = NULL" from the new array,
> >> if I understand correctly this is because all attach type enum members
> >> are now in the new attach_type_name[] so we're safe by looping until we
> >> reach __MAX_BPF_ATTACH_TYPE. Sounds good in theory but...
> >>
> >
> > Well, NULL is default value, so having [__MAX_BPF_ATTACH_TYPE] = NULL
> > just increases ARRAY_SIZE(attach_type_names) by one. Which is
> > generally not needed, because we do proper < ARRAY_SIZE() checks
> > everywhere... except for one place. show_bpf_prog in cgroup.c looks up
> > name directly and can pass NULL into jsonw_string_field which will
> > crash.
> >
> > I can fix that by setting [__MAX_BPF_ATTACH_TYPE] to "unknown" or
> > adding extra check in show_bpf_prog() code? Any preferences?
>
> Maybe add the extra check, so we remove this [__MAX_BPF_ATTACH_TYPE]
> indeed. It will be more consistent with the array with program names,
> and as you say, all other places loop on ARRAY_SIZE() just fine.

Sounds good.

>
> Maybe we could print the integer value for the type if we don't know the
> name? Not sure if this is good for JSON though.

We do that in a bunch of places, I'll see if that's easy to do.

>
> >
> >>> -};
> >>> -
> >>>  static enum bpf_attach_type parse_attach_type(const char *str)
> >>>  {
> >>>       enum bpf_attach_type type;
> >>>
> >>>       for (type = 0; type < __MAX_BPF_ATTACH_TYPE; type++) {
> >>> -             if (attach_type_strings[type] &&
> >>> -                 is_prefix(str, attach_type_strings[type]))
> >>> +             if (attach_type_name[type] &&
> >>> +                 is_prefix(str, attach_type_name[type]))
> >>>                       return type;
> >>>       }
> >>
> >> ... I'm concerned the "attach_type_name[type]" here could segfault if we
> >> add a new attach type to the kernel, but don't report it immediately to
> >> bpftool's array.
> >
> > I don't think so. Here we'll iterate over all possible bpf_attach_type
> > (as far as our copy of UAPI header is concerned, of course). If some
> > of the values don't have entries in attach_type_name array, we'll get
> > back NULL (same as with explicit [__MAX_BPF_ATTACH_TYPE] = NULL, btw),
> > which will get handled properly in the loop. And caller will get back
> > __MAX_BPF_ATTACH_TYPE as bpf_attach_type value. So unless I'm still
> > missing something, it seems to be working exactly the same as before?
> >
> >>
> >> Is there any drawback with keeping the "[__MAX_BPF_ATTACH_TYPE] = NULL"?
> >> Or change here to loop on ARRAY_SIZE(), as you do in your own patch for
> >> link?
> >
> > ARRAY_SIZE() == __MAX_BPF_ATTACH_TYPE, isn't it? Previously ARRAY_SIZE
> > was (__MAX_BPF_ATTACH_TYPE + 1), but I don't think it's necessary?
>
> ARRAY_SIZE() /should/ be equal to __MAX_BPF_ATTACH_TYPE, the concern is
> only if new attach types get added to UAPI header and we forget to add
> them to the array. In that case, the assumption is not longer valid and
> we risk reading out of the array in parse_attach_type(). That was not
> the case before, because we knew that the array was always big enough.
> There was no risk to read beyond index __MAX_BPF_ATTACH_TYPE, there is
> one now to read beyond index BPF_LSM_MAC when new types are added. Or am
> I the one missing something?

Ah, I see what you are saying... I can just declare array as

const char *attach_type_strings[__MAX_BPF_ATTACH_TYPE] = { ... }

to prevent this. There is still this issue of potentially getting back
NULL pointer. But that warrants separate "audit" of the code usage and
fixing appropriately, I don't think it belongs in this patch set.

>
> >
> > The only difference is show_bpf_prog() which now is going to do out of
> > array reads, while previously it would get NULL. But both cases are
> > bad and needs fixing.
> >
>
> Right, nice catch, this needs a fix.

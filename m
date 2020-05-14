Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9637B1D414D
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 00:46:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728857AbgENWqk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 18:46:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728229AbgENWqj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 May 2020 18:46:39 -0400
Received: from mail-qt1-x841.google.com (mail-qt1-x841.google.com [IPv6:2607:f8b0:4864:20::841])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 072FDC061A0C;
        Thu, 14 May 2020 15:46:39 -0700 (PDT)
Received: by mail-qt1-x841.google.com with SMTP id b1so376813qtt.1;
        Thu, 14 May 2020 15:46:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=aX8mUUB0M29sVmdS16KIRLkATaFZkyaasWbiWeJqlN0=;
        b=GpfuzRvbV/mcJd/diMQgWK9bZEG8tMZUmRGGnIzJxsO4osAAlSQm2sq9j+HUbX6+XR
         bBVPuuTQd1htcJEdRmw/oQpCR3eRc8lduf7JCLpKnynW+fvj/CAKFilfarIn6axY332Z
         lOjrYp2cx1LZ9BS+WbB7F8CSpZ4+DaBtCJSIL9DhLhwBBb9u7vvgPy+IDyS6/TqBZoQc
         qITGZ9M7p+gLV9mMgHo4OlXBUCBJZWR0nM/AlL9vz5unznSq3byR4XOxWRa81H+iXGtv
         Vg/vP+H72vxiPElY1o5LbnvyPK0immEUR1szR7azHw7WnnNQvmPI0WvyLcgcvhkcNU/A
         R1YA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aX8mUUB0M29sVmdS16KIRLkATaFZkyaasWbiWeJqlN0=;
        b=PISyu+jYZYM6ykCOSnjCu9FHHFLeegDzo8pBWh6Tav97U1c+o7eSGREAPS8g/6RxHx
         8Kbz0l0f6NZC6PlFRUKLzXB41Q22Vip+Xoy+q/hvcFvhqVClPkPYlVV8p3E2Vt1x0q+u
         WSWQ3Lt6f4orUQlKgjUPO7IdwNXqzGzAU50F9tWj5JnB3yU9Z3UjiKMBbpfyAG0bGtdh
         T4ek34YWVocJKiYcAyK0Zy5y0gSEwTUnROX7th/2SvpKSDGY9/w24rvLYLzmb7Pdt+AZ
         rx9SwyIUA4xSvjFoLUppTSV58xkQtc+Yio1H/N3shQBLE2QZEU9qbJQQceK8P0jK2QWg
         0daA==
X-Gm-Message-State: AOAM533eLme6hfFG6/B1VaKGY0ptTjq0gL7U7FkIbKuXHjESlFADi1Pp
        BZ+GglnbW7RrF9UhORuOcziyotjB0SMHcb3bNnE=
X-Google-Smtp-Source: ABdhPJyoJgvjkhsXDNr1ZuA+5/uMTeQZxWPaCYPs5/yhWQMeqojpBsRqWYosTFP1KSQ4pRSRowhqHsF+vdE8UKEBtGw=
X-Received: by 2002:aed:24a1:: with SMTP id t30mr501787qtc.93.1589496398194;
 Thu, 14 May 2020 15:46:38 -0700 (PDT)
MIME-Version: 1.0
References: <20200506132946.2164578-1-jolsa@kernel.org> <20200506132946.2164578-8-jolsa@kernel.org>
 <20200513182940.gil7v5vkthhwck3t@ast-mbp.dhcp.thefacebook.com> <20200514080515.GH3343750@krava>
In-Reply-To: <20200514080515.GH3343750@krava>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 14 May 2020 15:46:26 -0700
Message-ID: <CAEf4BzbZ6TYxVTJx3ij1WXy5AvVQio9Ht=tePO+xQf=JLigoog@mail.gmail.com>
Subject: Re: [PATCH 7/9] bpf: Compile the BTF id whitelist data in vmlinux
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Yonghong Song <yhs@fb.com>, Martin KaFai Lau <kafai@fb.com>,
        David Miller <davem@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Wenbo Zhang <ethercflow@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Brendan Gregg <bgregg@netflix.com>,
        Florent Revest <revest@chromium.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 14, 2020 at 1:05 AM Jiri Olsa <jolsa@redhat.com> wrote:
>
> On Wed, May 13, 2020 at 11:29:40AM -0700, Alexei Starovoitov wrote:
>
> SNIP
>
> > > diff --git a/scripts/link-vmlinux.sh b/scripts/link-vmlinux.sh
> > > index d09ab4afbda4..dee91c6bf450 100755
> > > --- a/scripts/link-vmlinux.sh
> > > +++ b/scripts/link-vmlinux.sh
> > > @@ -130,16 +130,26 @@ gen_btf()
> > >     info "BTF" ${2}
> > >     LLVM_OBJCOPY=${OBJCOPY} ${PAHOLE} -J ${1}
> > >
> > > -   # Create ${2} which contains just .BTF section but no symbols. Add
> > > +   # Create object which contains just .BTF section but no symbols. Add
> > >     # SHF_ALLOC because .BTF will be part of the vmlinux image. --strip-all
> > >     # deletes all symbols including __start_BTF and __stop_BTF, which will
> > >     # be redefined in the linker script. Add 2>/dev/null to suppress GNU
> > >     # objcopy warnings: "empty loadable segment detected at ..."
> > >     ${OBJCOPY} --only-section=.BTF --set-section-flags .BTF=alloc,readonly \
> > > -           --strip-all ${1} ${2} 2>/dev/null
> > > -   # Change e_type to ET_REL so that it can be used to link final vmlinux.
> > > -   # Unlike GNU ld, lld does not allow an ET_EXEC input.
> > > -   printf '\1' | dd of=${2} conv=notrunc bs=1 seek=16 status=none
> > > +           --strip-all ${1} 2>/dev/null
> > > +
> > > +   # Create object that contains just .BTF_whitelist_* sections generated
> > > +   # by bpfwl. Same as BTF section, BTF_whitelist_* data will be part of
> > > +   # the vmlinux image, hence SHF_ALLOC.
> > > +   whitelist=.btf.vmlinux.whitelist
> > > +
> > > +   ${BPFWL} ${1} kernel/bpf/helpers-whitelist > ${whitelist}.c
> > > +   ${CC} -c -o ${whitelist}.o ${whitelist}.c
> > > +   ${OBJCOPY} --only-section=.BTF_whitelist* --set-section-flags .BTF=alloc,readonly \
> > > +                --strip-all ${whitelist}.o 2>/dev/null
> > > +
> > > +   # Link BTF and BTF_whitelist objects together
> > > +   ${LD} -r -o ${2} ${1} ${whitelist}.o
> >
> > Thank you for working on it!
> > Looks great to me overall. In the next rev please drop RFC tag.
> >
> > My only concern is this extra linking step. How many extra seconds does it add?
>
> I did not meassure, but I haven't noticed any noticable delay,
> I'll add meassurements to the next post
>
> >
> > Also in patch 3:
> > +               func = func__find(str);
> > +               if (func)
> > +                       func->id = id;
> > which means that if somebody mistyped the name or that kernel function
> > got renamed there will be no warnings or errors.
> > I think it needs to fail the build instead.
>
> it fails later on, when generating the array:
>
>      if (!func->id) {
>              fprintf(stderr, "FAILED: '%s' function not found in BTF data\n",
>                      func->name);
>              return -1;
>      }
>
> but it can clearly fail before that.. I'll change that

I also means that whitelist can't contain functions that can be
conditionally compiled out, right? I guess we can invent some naming
convention to handle that, e.g: ?some_func will mean it's fine if we
didn't find it?

>
> >
> > If additional linking step takes another 20 seconds it could be a reason
> > to move the search to run-time.
> > We already have that with struct bpf_func_proto->btf_id[].
> > Whitelist could be something similar.
> > I think this mechanism will be reused for unstable helpers and other
> > func->btf_id mappings, so 'bpfwl' name would change eventually.
> > It's not white list specific. It generates a mapping of names to btf_ids.
> > Doing it at build time vs run-time is a trade off and it doesn't have
> > an obvious answer.
>
> I was thinking of putting the names in __init section and generate the BTF
> ids on kernel start, but the build time generation seemed more convenient..
> let's see the linking times with 'real size' whitelist and we can reconsider
>

Being able to record such places where to put BTF ID in code would be
really nice, as Alexei mentioned. There are many potential use cases
where it would be good to have BTF IDs just put into arbitrary
variables/arrays. This would trigger compilation error, if someone
screws up the name, or function is renamed, or if function can be
compiled out under some configuration. E.g., assuming some reasonable
implementation of the macro

static const u32 d_path_whitelist[] = {
    BTF_ID_FUNC(vfs_fallocate),
#ifdef CONFIG_WHATEVER
    BTF_ID_FUNC(do_truncate),
#endif
};

Would be nice and very explicit. Given this is not going to be sorted,
you won't be able to use binary search, but if whitelists are
generally small, it should be fine as is. If not, hashmap could be
built in runtime and would be, probably, faster than binary search for
longer sets of BTF IDs.

I wonder if we can do some assembly magic with generating extra
symbols and/or relocations to achieve this? What do you think? Is it
doable/desirable/better?


> thanks,
> jirka
>

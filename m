Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD5301E8931
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 22:49:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728119AbgE2UtK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 16:49:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727106AbgE2UtK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 May 2020 16:49:10 -0400
Received: from mail-qt1-x841.google.com (mail-qt1-x841.google.com [IPv6:2607:f8b0:4864:20::841])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1640AC03E969;
        Fri, 29 May 2020 13:49:10 -0700 (PDT)
Received: by mail-qt1-x841.google.com with SMTP id g18so3067547qtu.13;
        Fri, 29 May 2020 13:49:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=p8UZRFo1z34KrLoC62TOTt80KaaOP+ZuhCtxwxBkafc=;
        b=nXWK75vRApAM5CxVlL799lYSW4iQUPbCjNsIe4ByHRKcloNaR6Kva7ak4eaSSttX5S
         ORsUhR72WtCrZjvk0ZdZcRc8Ir8NBvURjdn7F7SBgF6/dmukcalDHK9DYxxi5DDVUiTB
         w+qLzWY5nNUMN1n56+mUG3oMEsMvpe3Cws1I4RFGpsETzZ04m78WOP500+CbmZ4KNTsg
         ibw9MM8rceuEg71NctZnyjnApwD717wBZkwpxHG6nl4yvzxyfN1W3AWcg8fNRntE6WUL
         69m4bM7KMzHSurCKyEEcahC/NxpRnIqHAGZ6RUnBMr1Nbces6EOl6wK8rbQV3pLuaNZI
         HWNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=p8UZRFo1z34KrLoC62TOTt80KaaOP+ZuhCtxwxBkafc=;
        b=nqRVrHXEJF1YZUKywQvIdIn9kOM1m1rPHq4fF8sJJZFtxD5PwmSUXeIm1TwhF/T2MO
         pyeFtrfsSz7iDISqLeeyer99eletHtWXuHX3lD6LF8RRmfkRuwW0VCwWyYe4EUM+JB7X
         kUzu5wnl9O6YFsxuE6TYgtgxCI7b0QTnpLq7oCcVNj8tMXwrglvX8BP1kBtvMjmJhjO1
         Sq2MTwGVumnf6xu4q7HNbv3M9fLlnKydgwlDAXEHWQvynGpyutDUQ3TApxiZ49uO8kxs
         ThBF0AvtE6Ny4MckefXKh4u9mm59kkB9O98VuxTPOF7JmFQ/9vKpj4FXkCb7A3GOa3q1
         Dw1A==
X-Gm-Message-State: AOAM530eQ7WEU+H5KKD4pGEd9+WC+Vg/IMPwVIVcTINeAPB6/j+RudsL
        Q8wEtTTTSI/eJOn8EJ1dgWOWMlnPajkoTvebF4A=
X-Google-Smtp-Source: ABdhPJwg+2dVZU3srKV2eAqYn7zc1K3b6wP2BQkLCH50zkkeRp4I1Y7Aws1HiAUcecBqqKVNlzia5qsKrKXnD83h5ZI=
X-Received: by 2002:aed:3f3b:: with SMTP id p56mr10463872qtf.93.1590785348974;
 Fri, 29 May 2020 13:49:08 -0700 (PDT)
MIME-Version: 1.0
References: <20200506132946.2164578-1-jolsa@kernel.org> <20200506132946.2164578-8-jolsa@kernel.org>
 <20200513182940.gil7v5vkthhwck3t@ast-mbp.dhcp.thefacebook.com>
 <20200514080515.GH3343750@krava> <CAEf4BzbZ6TYxVTJx3ij1WXy5AvVQio9Ht=tePO+xQf=JLigoog@mail.gmail.com>
 <20200528172349.GA506785@krava>
In-Reply-To: <20200528172349.GA506785@krava>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 29 May 2020 13:48:58 -0700
Message-ID: <CAEf4BzbM-5-_QzDhrJDFJefo-m0OWDhvjsK_F1vA-ja4URVE9Q@mail.gmail.com>
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

On Thu, May 28, 2020 at 10:24 AM Jiri Olsa <jolsa@redhat.com> wrote:
>
> On Thu, May 14, 2020 at 03:46:26PM -0700, Andrii Nakryiko wrote:
>
> SNIP
>
> > > I was thinking of putting the names in __init section and generate the BTF
> > > ids on kernel start, but the build time generation seemed more convenient..
> > > let's see the linking times with 'real size' whitelist and we can reconsider
> > >
> >
> > Being able to record such places where to put BTF ID in code would be
> > really nice, as Alexei mentioned. There are many potential use cases
> > where it would be good to have BTF IDs just put into arbitrary
> > variables/arrays. This would trigger compilation error, if someone
> > screws up the name, or function is renamed, or if function can be
> > compiled out under some configuration. E.g., assuming some reasonable
> > implementation of the macro
>
> hi,
> I'm struggling with this part.. to get some reasonable reference
> to function/name into 32 bits? any idea? ;-)
>

Well, you don't have to store actual pointer, right? E.g, emitting
something like this in assembly:

.global __BTF_ID___some_function
.type __BTF_ID___some_function, @object
.size __BTF_ID___some_function, 4
__BTF_ID___some_function:
.zero  4

Would reserve 4 bytes and emit __BTF_ID___some_function symbol. If we
can then post-process vmlinux image and for all symbols starting with
__BTF_ID___ find some_function BTF type id and put it into those 4
bytes, that should work, no?

Maybe generalize it to __BTF_ID__{func,struct,typedef}__some_function,
whatever, not sure. Just an idea.


> jirka
>
> >
> > static const u32 d_path_whitelist[] = {
> >     BTF_ID_FUNC(vfs_fallocate),
> > #ifdef CONFIG_WHATEVER
> >     BTF_ID_FUNC(do_truncate),
> > #endif
> > };
> >
> > Would be nice and very explicit. Given this is not going to be sorted,
> > you won't be able to use binary search, but if whitelists are
> > generally small, it should be fine as is. If not, hashmap could be
> > built in runtime and would be, probably, faster than binary search for
> > longer sets of BTF IDs.
> >
> > I wonder if we can do some assembly magic with generating extra
> > symbols and/or relocations to achieve this? What do you think? Is it
> > doable/desirable/better?
> >
> >
> > > thanks,
> > > jirka
> > >
> >
>

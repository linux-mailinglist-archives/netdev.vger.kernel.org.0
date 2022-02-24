Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80CDF4C2155
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 02:49:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229780AbiBXBtv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 20:49:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229739AbiBXBtu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 20:49:50 -0500
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DED3414A229;
        Wed, 23 Feb 2022 17:49:21 -0800 (PST)
Received: by mail-io1-xd2c.google.com with SMTP id q8so1080819iod.2;
        Wed, 23 Feb 2022 17:49:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Xp3HX+o2yPwkIDYrjC+8YezplaiynNPQqGDAPyLnsrM=;
        b=bcLronwAAEWhuaOTKnd1Wyi+1QyBIWtoF8XgQbmjYHdrh3WUvlZKo+G5/xl9L8bJOS
         hPhjeKu6g63amQFrADQp1dFK/6DLzCqNrzhNlHPFs0ZyTgOiZthQzpIVYOo89VaQljXL
         evA2ux+HHunxwoqJNvcVUEO0kqMD1FcMt26+GI3Re+5bxUxPuGsAQF4GlhZNBfB0XHpC
         hJ2w2vinZrL3Nn5S4YbP0KcnmhYtlLbh/nyMqYIxGiL8DKODCciO4fgJannqi0NJEeX5
         vUByipvSwm7zroL1ElQ9pq724wtCwuaKVfNCmCDFttDWllyipSiET6sp2MuO9bVKnjdd
         RyJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Xp3HX+o2yPwkIDYrjC+8YezplaiynNPQqGDAPyLnsrM=;
        b=cRAITEqzqc3KW4obSoVc80uU2y8Ii4f6cfETAGiD3MRVk8w6IyAMX8ThSTI+rjoLbs
         wpSItqUd3CVMgh3rkIR3eU7QFz0d5iayoYJOg8vgqU1SSoAfoiui57+oLLX5Y7q34d5s
         go0eJy67OM89ZN7WdM+13oavqTAs3UosvFOgOCgM2mRDaN7DpPzR81vX+IXKMrRgykac
         cj1kKxZJ6DYk99aOOcewOd25GAv1JntsC4M3Q+T4cQd09oIunwQRVuK3Z4jFxvB/AHsC
         4DC2NM/vDENcGoJW6QjqJwYniwm5XOOLdXYmnxfIei8IAcDFaYO9ro/Gtzd9qQ2xDYy4
         ob3g==
X-Gm-Message-State: AOAM531IOSjiyQuInU/nXJ8ia2N3D7f6BigmJmJ3LQIg+3XdB2jI9VmB
        WgxR7fvHDKHHOO2FANvOKyOfXkeavct2S3LDxDQ=
X-Google-Smtp-Source: ABdhPJx7518hA0zYJ6m7MHEf2daTnuUYNiiomLL5EUrQxpRjCT1cWNvkSwnEO8jULuwia4nsvhHIfKcX4j1Al4U7knY=
X-Received: by 2002:a05:6602:3c6:b0:63d:cac9:bd35 with SMTP id
 g6-20020a05660203c600b0063dcac9bd35mr350721iov.144.1645667361235; Wed, 23 Feb
 2022 17:49:21 -0800 (PST)
MIME-Version: 1.0
References: <1643645554-28723-1-git-send-email-alan.maguire@oracle.com>
 <1643645554-28723-3-git-send-email-alan.maguire@oracle.com>
 <CAEf4Bzb9xhpn5asJo7cwhL61DawqtuL_MakdU0YZwOeWuaRq6A@mail.gmail.com> <alpine.LRH.2.23.451.2202230924001.26488@MyRouter.home>
In-Reply-To: <alpine.LRH.2.23.451.2202230924001.26488@MyRouter.home>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 23 Feb 2022 17:49:10 -0800
Message-ID: <CAEf4BzYzgc8GndgC9GKYaTLK-04BqNOrD3BjdKJ8ko+ShzUXvQ@mail.gmail.com>
Subject: Re: [PATCH v3 bpf-next 2/4] libbpf: add auto-attach for uprobes based
 on section name
To:     Alan Maguire <alan.maguire@oracle.com>
Cc:     Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Jiri Olsa <jolsa@kernel.org>,
        Yucong Sun <sunyucong@gmail.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
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

On Wed, Feb 23, 2022 at 1:33 AM Alan Maguire <alan.maguire@oracle.com> wrote:
>
> On Fri, 4 Feb 2022, Andrii Nakryiko wrote:
>
> > On Mon, Jan 31, 2022 at 8:13 AM Alan Maguire <alan.maguire@oracle.com> wrote:
> > >
> > > Now that u[ret]probes can use name-based specification, it makes
> > > sense to add support for auto-attach based on SEC() definition.
> > > The format proposed is
> > >
> > >         SEC("u[ret]probe//path/to/prog:[raw_offset|[function_name[+offset]]")
> > >
> > > For example, to trace malloc() in libc:
> > >
> > >         SEC("uprobe//usr/lib64/libc.so.6:malloc")
> >
> > I assume that path to library can be relative path as well, right?
> >
> > Also, should be look at trying to locate library in the system if it's
> > specified as "libc"? Or if the binary is "bash", for example. Just
> > bringing this up, because I think it came up before in the context of
> > one of libbpf-tools.
> >
>
> This is a great suggestion for usability, but I'm trying to puzzle
> out how to carry out the location search for cases where the path
> specified is not a relative or absolute path.
>
> A few things we can can do - use search paths from PATH and
> LD_LIBRARY_PATH, with an appended set of standard locations
> such as /usr/bin, /usr/sbin for cases where those environment
> variables are missing or incomplete.
>
> However, when it comes to libraries, do we search in /usr/lib64 or
> /usr/lib? We could use whether the version of libbpf is 64-bit or not I
> suppose, but it's at least conceivable that the user might want to
> instrument a 32-bit library from a 64-bit libbpf.  Do you think that
> approach is sufficient, or are there other things we should do? Thanks!

How does dynamic linker do this? When I specify "libbpf.so", is there
some documented algorithm for finding the library? If it's more or
less codified, we could implement something like that. If not, well,
too bad, we can do some useful heuristic, but ultimately there will be
cases that won't be supported. Worst case user will have to specify an
absolute path.

>
> Alan

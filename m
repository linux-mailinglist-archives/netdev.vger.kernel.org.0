Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC86A1EAF74
	for <lists+netdev@lfdr.de>; Mon,  1 Jun 2020 21:06:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728487AbgFATGt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jun 2020 15:06:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728407AbgFATGs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jun 2020 15:06:48 -0400
Received: from mail-qt1-x843.google.com (mail-qt1-x843.google.com [IPv6:2607:f8b0:4864:20::843])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3998C061A0E;
        Mon,  1 Jun 2020 12:06:46 -0700 (PDT)
Received: by mail-qt1-x843.google.com with SMTP id z1so8647606qtn.2;
        Mon, 01 Jun 2020 12:06:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Llrgk7+W9TLrYsuboc7Lm4z6Mn6CXQv30Bi9jrkMViA=;
        b=HX0AknQPr2UrtWk6MQk+TwJxdu7pIsoIuJDU+wjAFOk/LY2gLxAgByAQatxfdc5+IP
         Iu9P0K6qzfivToi9Cd0seY3ABOVpzDN6vOV/0ges17+YFDroWZS+lXgF3Ar+fe3go3t/
         wwGkLe+nJjzATG9h/IesrS4deSeWKw/Z01/bzPPLRj4/5v2CHptx/564cxjRdNdw57q9
         1IXJ0rB6w/wK3c4Z20mBtbo2cfzeYfgWmOymprg3mzdhaO8zcAVqyJPMO4k7FUl2NeJg
         DlF6xLrF+qjp+jf9LsWoyp6zSO2YfoHzL7T3EbnIXEo6SuoZ69p7G9y8nVREpQrpaGFv
         9yrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Llrgk7+W9TLrYsuboc7Lm4z6Mn6CXQv30Bi9jrkMViA=;
        b=lakx53ZYhkqV5xVdYX6L7CF5m7BsxTMyaDAm/7RtpKnUdmXtLjWxD1R0NZVRC3YqPr
         4FGedzYY6CguG8qw36KFYnL4SXhlIMAAuP762CxNPfTQOjr7qr+GRHXg3v2rLntr31Jq
         i3W1L3R3l5qZuooLBb+m+2eNBEh5V+c0KGT+GhJ9f8ntCbfA5G7KZ+pTy1E/HqiaqrXQ
         WbzozeqXLVbscwYF5hCaasuPvu16nmkSG0xcahynaqP0dhr3azgu2ylE/uMoz7ZVoUJo
         tWwr22SKgiiOKhUoFVHKC4oXfTKN07AToq1DWBDq1cBrDuX8RXkIWJJNdxoNCXLSKilR
         7yuQ==
X-Gm-Message-State: AOAM531j+S5HskC8Km29gt12jWBwoOWlVR0AEHMYoFqTm50BEtZZqYST
        gjDTo8I/vejxW5O9LiyU2bOJkkNH9rcB18zDwrY=
X-Google-Smtp-Source: ABdhPJxQ7/XGtasgrRrJ7vUyCfsoAICbMpDYL+nG9HXjO3JqEezNUhDH3/6Dhr1OsSFHAwd6GpMI5i4BBJ635E32kP8=
X-Received: by 2002:ac8:4b63:: with SMTP id g3mr14945198qts.171.1591038405924;
 Mon, 01 Jun 2020 12:06:45 -0700 (PDT)
MIME-Version: 1.0
References: <20200506132946.2164578-1-jolsa@kernel.org> <20200506132946.2164578-8-jolsa@kernel.org>
 <20200513182940.gil7v5vkthhwck3t@ast-mbp.dhcp.thefacebook.com>
 <20200514080515.GH3343750@krava> <CAEf4BzbZ6TYxVTJx3ij1WXy5AvVQio9Ht=tePO+xQf=JLigoog@mail.gmail.com>
 <20200528172349.GA506785@krava> <CAEf4BzbM-5-_QzDhrJDFJefo-m0OWDhvjsK_F1vA-ja4URVE9Q@mail.gmail.com>
 <20200531151039.GA881900@krava>
In-Reply-To: <20200531151039.GA881900@krava>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 1 Jun 2020 12:06:34 -0700
Message-ID: <CAEf4BzZTyzMaXbpDOCUHyWV7hotwaT3DdHuDxrK=0bfOMLQ5AQ@mail.gmail.com>
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

On Sun, May 31, 2020 at 8:10 AM Jiri Olsa <jolsa@redhat.com> wrote:
>
> On Fri, May 29, 2020 at 01:48:58PM -0700, Andrii Nakryiko wrote:
> > On Thu, May 28, 2020 at 10:24 AM Jiri Olsa <jolsa@redhat.com> wrote:
> > >
> > > On Thu, May 14, 2020 at 03:46:26PM -0700, Andrii Nakryiko wrote:
> > >
> > > SNIP
> > >
> > > > > I was thinking of putting the names in __init section and generate the BTF
> > > > > ids on kernel start, but the build time generation seemed more convenient..
> > > > > let's see the linking times with 'real size' whitelist and we can reconsider
> > > > >
> > > >
> > > > Being able to record such places where to put BTF ID in code would be
> > > > really nice, as Alexei mentioned. There are many potential use cases
> > > > where it would be good to have BTF IDs just put into arbitrary
> > > > variables/arrays. This would trigger compilation error, if someone
> > > > screws up the name, or function is renamed, or if function can be
> > > > compiled out under some configuration. E.g., assuming some reasonable
> > > > implementation of the macro
> > >
> > > hi,
> > > I'm struggling with this part.. to get some reasonable reference
> > > to function/name into 32 bits? any idea? ;-)
> > >
> >
> > Well, you don't have to store actual pointer, right? E.g, emitting
> > something like this in assembly:
> >
> > .global __BTF_ID___some_function
> > .type __BTF_ID___some_function, @object
> > .size __BTF_ID___some_function, 4
> > __BTF_ID___some_function:
> > .zero  4
> >
> > Would reserve 4 bytes and emit __BTF_ID___some_function symbol. If we
> > can then post-process vmlinux image and for all symbols starting with
> > __BTF_ID___ find some_function BTF type id and put it into those 4
> > bytes, that should work, no?
> >
> > Maybe generalize it to __BTF_ID__{func,struct,typedef}__some_function,
> > whatever, not sure. Just an idea.
>
> nice, so something like below?
>
> it'd be in .S file, or perhaps in inline asm, assuming I'll be
> able to pass macro arguments to asm("")

I'd do inline asm, there are no arguments you need to pass into
asm("") itself, everything can be done through macro string
interpolation, I think. Having everything in .c file would be way more
convenient and obvious.

>
> with externs defined in some header file:
>
>   extern const int bpf_skb_output_btf_ids[];
>   extern const int btf_whitelist_d_path[];
>
>   $ objdump -x ./kernel/bpf/whitelist.o
>   ...
>   0000000000000000 l     O .data  0000000000000004 __BTF_ID__func__vfs_truncate
>   0000000000000004 l     O .data  0000000000000004 __BTF_ID__func__vfs_fallocate
>   0000000000000008 l     O .data  0000000000000004 __BTF_ID__func__krava
>   0000000000000010 l     O .data  0000000000000004 __BTF_ID__struct__sk_buff
>   0000000000000000 g       .data  0000000000000000 btf_whitelist_d_path
>   0000000000000010 g       .data  0000000000000000 bpf_skb_output_btf_ids
>
> also it'd be nice to get rid of BTF_ID__ symbols in the final link
>
> thanks,
> jirka
>
>
> ---
> #define BTF_ID(prefix, name)                    \
> .local __BTF_ID__##prefix##__##name;            \
> .type __BTF_ID__##prefix##__##name, @object;    \
> .size __BTF_ID__##prefix##__##name, 4;          \
> __BTF_ID__##prefix##__##name:                   \
> .zero 4
>
> #define BTF_ID_LIST(name)                       \
> .global name;                                   \
> name:
>
> #define ZERO .zero 4
>
> .data
>
> BTF_ID_LIST(btf_whitelist_d_path)
> BTF_ID(func, vfs_truncate)
> BTF_ID(func, vfs_fallocate)
> BTF_ID(func, krava)
> ZERO
>
> BTF_ID_LIST(bpf_skb_output_btf_ids)
> BTF_ID(struct, sk_buff)
>

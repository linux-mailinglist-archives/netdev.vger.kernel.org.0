Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E9C6379F00
	for <lists+netdev@lfdr.de>; Tue, 11 May 2021 07:09:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230309AbhEKFKV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 May 2021 01:10:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:57440 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229885AbhEKFKV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 11 May 2021 01:10:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6D393616EA;
        Tue, 11 May 2021 05:09:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620709755;
        bh=fE6IHU6HUZqvj0DH4qQyG0H9jxoUolUyzkfVi9rdSXw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fPj/JZxOb5RaYxqCFcGcckN3QhutAofMPnU2uy3no5CrA5RyPYyx+YgUnGKvTj996
         IKbmfxmaJ89l22MWOIMoM1+9yiJlWtHmGHd1rerS6lEm7rJ8SzjP9AT9QrScLGPbB7
         47k72ZXVrr/hhSo05IRPajK+Jl7+39vjJog/n8xAQEILUST8NqFl2u57f0IqP2sWMp
         zIiIFJfva9ZMMFhyfcsLzEb8jD1eWDG6ERKuMytIi1qvux1lbAlKfKhYE3HTKhRAiC
         idZE6Hj0LtfsjB63xnTJl8VFbsLuKtxJgZot4jOZLXGOwP06kr6zrEqe3ygWitbrjx
         hpIXFh3eLY6+w==
Date:   Tue, 11 May 2021 08:09:11 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Zhen Lei <thunder.leizhen@huawei.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, netdev <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>
Subject: Re: [PATCH 1/1] libbpf: Delete an unneeded bool conversion
Message-ID: <YJoRd4reWa1viW76@unreal>
References: <20210510124315.3854-1-thunder.leizhen@huawei.com>
 <CAEf4BzaADXguVoh0KXxGYhzG68eA1bqfKH1T1SWyPvkE5BHa5g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzaADXguVoh0KXxGYhzG68eA1bqfKH1T1SWyPvkE5BHa5g@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 10, 2021 at 11:00:29AM -0700, Andrii Nakryiko wrote:
> On Mon, May 10, 2021 at 5:43 AM Zhen Lei <thunder.leizhen@huawei.com> wrote:
> >
> > The result of an expression consisting of a single relational operator is
> > already of the bool type and does not need to be evaluated explicitly.
> >
> > No functional change.
> >
> > Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
> > ---
> 
> See [0] and [1].
> 
>   [0] https://lore.kernel.org/bpf/CAEf4BzYgLf5g3oztbA-CJR4gQ7AVKQAGrsHWCOgTtUMUM-Mxfg@mail.gmail.com/
>   [1] https://lore.kernel.org/bpf/CAEf4BzZQ6=-h3g1duXFwDLr92z7nE6ajv8Rz_Zv=qx=-F3sRVA@mail.gmail.com/

How long do you plan to fight with such patches?

Thanks

> 
> >  tools/lib/bpf/libbpf.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> > index e2a3cf4378140f2..fa02213c451f4d2 100644
> > --- a/tools/lib/bpf/libbpf.c
> > +++ b/tools/lib/bpf/libbpf.c
> > @@ -1504,7 +1504,7 @@ static int set_kcfg_value_tri(struct extern_desc *ext, void *ext_val,
> >                                 ext->name, value);
> >                         return -EINVAL;
> >                 }
> > -               *(bool *)ext_val = value == 'y' ? true : false;
> > +               *(bool *)ext_val = value == 'y';
> >                 break;
> >         case KCFG_TRISTATE:
> >                 if (value == 'y')
> > --
> > 2.26.0.106.g9fadedd
> >
> >

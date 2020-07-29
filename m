Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC05D2323BF
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 19:51:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726990AbgG2Rvj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jul 2020 13:51:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726336AbgG2Rvi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jul 2020 13:51:38 -0400
Received: from mail-qt1-x843.google.com (mail-qt1-x843.google.com [IPv6:2607:f8b0:4864:20::843])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61D79C061794;
        Wed, 29 Jul 2020 10:51:38 -0700 (PDT)
Received: by mail-qt1-x843.google.com with SMTP id d27so18291840qtg.4;
        Wed, 29 Jul 2020 10:51:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=V+0bF9fj95SwJaHo825THI13Rp+EtVA+fcdSeohX/No=;
        b=S9zqCfZVM+vXUdJl/czF2JdIY8jLLlzKOzfnINr3c4F00TdZHVXldPIqqsuh4ZKIPV
         O4gTW7kLfb9SzcvGF/3oj9DWVy9qvWO0YTYUdxfqZXLKuE+rUOmOsXlbsjrPdqMde7Iy
         vnqnzzbXpkXLNGZbNCN1Vsn4j6fVJAAeXmNhjohhpRI3MvrLlFGyBAWeTz0+PHBxqsRQ
         jAsX6cZFeq9lRgPZJgdBQ7ncTK0yP39a/369ePIng+Fx4dmLpQ33VSo4jCJC3tqSLgCD
         TyTVux2rWoeF5j1onjwQdcBAZn8w/1HtMFEQVjj6pA1YeyNeSl0fkLaCh+g9GxWRK5hZ
         kCcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=V+0bF9fj95SwJaHo825THI13Rp+EtVA+fcdSeohX/No=;
        b=Jb3B7aXCHL04rxBzQ/eQQSvdNk+J0nGXDJRi3WT/X4Alxyk606GN5tOQQZCj7tYGVH
         UCBDDfwfgCUz8pJP465Xm1vakL98xNw3iWFWyrNL3NbtLLz1P5aLouo56FPX/iwMhrak
         hKqANoA0g1cDEtm9luv3Gp+vvrEJN2G25UZMdEdZf2SXqgM77+u6TOQL+HC5cR0jQFzj
         ISHVvHC4GLGWefQbdPxmOdRUhlVOWKmV0lqH4SRHIX57SukzFYDrHnt6j/zQyG/Xo4tb
         r/CqXKxkqzW+sxreoyMeglpMCvb9WHeIAEE/19+fqm3I0U1rBPKtON1OHnPR396nWVI0
         pA7g==
X-Gm-Message-State: AOAM531iy9E7LhSnDdyhXAAazXqbktC6jo6nH6SdF986R3I0KXc1pUG6
        jxqnVjT9d/nvWoloB95be+YX0Yz3HwWi6dhuOSc=
X-Google-Smtp-Source: ABdhPJwPSDMQEbPO5Y90+QtOyMMNC0Wb2JR6fq+Lja5yP3TUpMJJdYZKMOgUZ8bQFvknJFdHaFxjFxFbKwV/4nkma1E=
X-Received: by 2002:aed:2ae2:: with SMTP id t89mr16843575qtd.171.1596045097606;
 Wed, 29 Jul 2020 10:51:37 -0700 (PDT)
MIME-Version: 1.0
References: <20200722211223.1055107-1-jolsa@kernel.org> <20200722211223.1055107-8-jolsa@kernel.org>
 <CAEf4BzacqauEc8=o29EBUsmvTMs3FZ+-Kcc4cSJ9Te4yh5-7qg@mail.gmail.com> <20200729160419.GM1319041@krava>
In-Reply-To: <20200729160419.GM1319041@krava>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 29 Jul 2020 10:51:26 -0700
Message-ID: <CAEf4BzZ26StciUpDas1Mdi1gY_LJChjkUEBvqzuZuhFuAAibLQ@mail.gmail.com>
Subject: Re: [PATCH v8 bpf-next 07/13] bpf: Add btf_struct_ids_match function
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        David Miller <davem@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Wenbo Zhang <ethercflow@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Brendan Gregg <bgregg@netflix.com>,
        Florent Revest <revest@chromium.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 29, 2020 at 9:04 AM Jiri Olsa <jolsa@redhat.com> wrote:
>
> On Tue, Jul 28, 2020 at 04:35:16PM -0700, Andrii Nakryiko wrote:
>
> SNIP
>
> > > diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> > > index bae557ff2da8..c981e258fed3 100644
> > > --- a/include/linux/bpf.h
> > > +++ b/include/linux/bpf.h
> > > @@ -1306,6 +1306,8 @@ int btf_struct_access(struct bpf_verifier_log *log,
> > >                       const struct btf_type *t, int off, int size,
> > >                       enum bpf_access_type atype,
> > >                       u32 *next_btf_id);
> > > +bool btf_struct_ids_match(struct bpf_verifier_log *log,
> > > +                         int off, u32 id, u32 mid);
> > >  int btf_resolve_helper_id(struct bpf_verifier_log *log,
> > >                           const struct bpf_func_proto *fn, int);
> > >
> > > diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
> > > index 1ab5fd5bf992..562d4453fad3 100644
> > > --- a/kernel/bpf/btf.c
> > > +++ b/kernel/bpf/btf.c
> > > @@ -4140,6 +4140,35 @@ int btf_struct_access(struct bpf_verifier_log *log,
> > >         return -EINVAL;
> > >  }
> > >
> > > +bool btf_struct_ids_match(struct bpf_verifier_log *log,
> > > +                         int off, u32 id, u32 mid)

just realized that if id == mid and off == 0, btf_struct_ids_match()
will return false. Right now verifier is careful to not call
btf_struct_ids_match in such case, but I wonder if it's better to make
that (common) case also work?

> > > +{
> > > +       const struct btf_type *type;
> > > +       u32 nid;
> > > +       int err;
> > > +
> >
> > mid and nid are terrible names, especially as an input argument name.
> > mid == need_type_id? nid == cur_type_id or something along those
> > lines?
>
> 'mid' was for matching id, 'nid' for nested id ;-)
> need_type_id/cur_type_id sound good

nested I guessed, mid was a mystery to me :))

>
> >
> > > +       do {
> > > +               type = btf_type_by_id(btf_vmlinux, id);
> > > +               if (!type)
> > > +                       return false;
> > > +               err = btf_struct_walk(log, type, off, 1, &nid);
> > > +               if (err < 0)
> > > +                       return false;
> > > +
> > > +               /* We found nested struct object. If it matches
> > > +                * the requested ID, we're done. Otherwise let's
> > > +                * continue the search with offset 0 in the new
> > > +                * type.
> > > +                */
> > > +               if (err == walk_struct && mid == nid)
> > > +                       return true;
> > > +               off = 0;
> > > +               id = nid;
> > > +       } while (err == walk_struct);
> >
> > This seems like a slightly more obvious control flow:
> >
> > again:
> >
> >    ...
> >
> >    if (err != walk_struct)
> >       return false;
>
> ok, and perhaps use in here the switch(err) as in the previous patch?

I think straightforward if is better than switch here, because
anything but walk_struct is not what we expect.

>
> thanks,
> jirka
>
> >
> >    if (mid != nid) {
> >       off = 0;
> >       id = nid;
> >       goto again;
> >    }
> >
> >    return true;
> >
> > > +
> > > +       return false;
> > > +}
> > > +
> > >  int btf_resolve_helper_id(struct bpf_verifier_log *log,
> > >                           const struct bpf_func_proto *fn, int arg)
> > >  {
> >
> > [...]
> >
>

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47FBC3499D1
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 19:58:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230042AbhCYS5q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 14:57:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229616AbhCYS5R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Mar 2021 14:57:17 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC78EC06174A;
        Thu, 25 Mar 2021 11:57:16 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id c204so3016839pfc.4;
        Thu, 25 Mar 2021 11:57:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Cb4rdnuLp99nvgBCEc1MpzgC638yA5gEtV6ZjkDqsso=;
        b=WBLfKdFXmOOAXB5FIUqh+8rXQAsHO8BV2718zQWe6JbhcmQVhkSHmBsQV7Ms8vTcY8
         FhFAPnMZHQA6u+djJxsldvouSYFJhPUs/51OUEbGLaALt8KFE0NlxYnGlxwkVhQnjYxo
         gyQmPb7EA+S00Cs5xUcRnBR/peEgjVqonHdPcPYorFMVhqtSUErZvaLitqkiuhfuqETP
         vEUZyvIP7WIGn0HanB5RZH5ZTfPI1kW4Pv+9tCL1IpD1n9RwSWgUHRjnIrGy6jgs2y6G
         7JDHIpyxnObZ4EVxBzmI54oHWSY7h1b4D93SwHyXJvBxkupTsfgK54Mm91JbRMiEIvqD
         o48w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Cb4rdnuLp99nvgBCEc1MpzgC638yA5gEtV6ZjkDqsso=;
        b=SwMdOw2VQufQd9CIjI0KGULEG2FdJS2p4aEUV7eP2F3zHrRQ/cYkZDdUBoW0Ewq5dl
         X9ps7SLlCcAYUA6kpXeeuoEMl0wAO3MsV1lD1f4Nc0Uue7Jsp0SnE/RcMeYEV7JLg9mF
         kJzAZOF3/Zi/hteKr/3vO2DfA5xEnodQUJ1j3XDdIUcgsKGVisytBZHH/3zJalB5p1J1
         Xq/vtVuzXcwpJ6C6exbyKB5yYMtUNg0yy71kjY+SQF3N5cPqVRpxtXWOLYaTaGMDs3Ga
         0JaTZ572DxYwDKV60rasQO0NTu4soDpIUC2yNc9u13G8VQ5GqYWE9+Q14zCCsmee6vcP
         3TuA==
X-Gm-Message-State: AOAM531xCh78FrAYZJTNKkrKYjNDg0N2J6Jb9VG7ABMblMKwhjJtVhKW
        RXhcNSnmjgwPiqDCtjhXjoT3rEBRrB4asni91hw=
X-Google-Smtp-Source: ABdhPJwExiMjzWa63UeE7o2Y+uS8sDRz6b6WBKjy17XfLlHfnz+kQum8nwU0FPtjhdifs1vcGlMevGmnb9HOGjy2KDc=
X-Received: by 2002:a62:92cc:0:b029:1fa:515d:808f with SMTP id
 o195-20020a6292cc0000b02901fa515d808fmr9125198pfd.43.1616698636133; Thu, 25
 Mar 2021 11:57:16 -0700 (PDT)
MIME-Version: 1.0
References: <161661943080.28508.5809575518293376322.stgit@john-Precision-5820-Tower>
 <161661956953.28508.2297266338306692603.stgit@john-Precision-5820-Tower>
 <CAM_iQpUNUE8cmyNaALG1dZtCfJGah2pggDNk-eVbyxexnA4o_g@mail.gmail.com> <605bf553d16f_64fde2081@john-XPS-13-9370.notmuch>
In-Reply-To: <605bf553d16f_64fde2081@john-XPS-13-9370.notmuch>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Thu, 25 Mar 2021 11:57:05 -0700
Message-ID: <CAM_iQpUdOkbs5MPcfTqNcPV3f0EXU7CQhuV9y2UDrOZ4SawvvA@mail.gmail.com>
Subject: Re: [bpf PATCH 1/2] bpf, sockmap: fix sk->prot unhash op reset
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@fb.com>, bpf <bpf@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Lorenz Bauer <lmb@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 24, 2021 at 7:28 PM John Fastabend <john.fastabend@gmail.com> wrote:
>
> Cong Wang wrote:
> > On Wed, Mar 24, 2021 at 1:59 PM John Fastabend <john.fastabend@gmail.com> wrote:
> > > diff --git a/net/tls/tls_main.c b/net/tls/tls_main.c
> > > index 47b7c5334c34..ecb5634b4c4a 100644
> > > --- a/net/tls/tls_main.c
> > > +++ b/net/tls/tls_main.c
> > > @@ -754,6 +754,12 @@ static void tls_update(struct sock *sk, struct proto *p,
> > >
> > >         ctx = tls_get_ctx(sk);
> > >         if (likely(ctx)) {
> > > +               /* TLS does not have an unhash proto in SW cases, but we need
> > > +                * to ensure we stop using the sock_map unhash routine because
> > > +                * the associated psock is being removed. So use the original
> > > +                * unhash handler.
> > > +                */
> > > +               WRITE_ONCE(sk->sk_prot->unhash, p->unhash);
> > >                 ctx->sk_write_space = write_space;
> > >                 ctx->sk_proto = p;
> >
> > It looks awkward to update sk->sk_proto inside tls_update(),
> > at least when ctx!=NULL.
>
> hmm. It doesn't strike me as paticularly awkward but OK.

I read tls_update() as "updating ctx when it is initialized", with your
patch, we are updating sk->sk_prot->unhash too when updating ctx,
pretty much like a piggyback, hence it reads odd to me.

Thanks.

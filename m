Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D39DB531EAA
	for <lists+netdev@lfdr.de>; Tue, 24 May 2022 00:38:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231611AbiEWWiW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 May 2022 18:38:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229666AbiEWWiQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 May 2022 18:38:16 -0400
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3951C9CF7D;
        Mon, 23 May 2022 15:38:15 -0700 (PDT)
Received: by mail-io1-xd2e.google.com with SMTP id 2so6945363iou.5;
        Mon, 23 May 2022 15:38:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WgfA+bj8h/yfvLtv8TQjcWpJiGYbRoi7JEJT7KRe+10=;
        b=gacDjAeQh6oI7YHuiwPSGFwsV3CF57PtZWR9POoh7jzgX+t+opWpA1dnvhnh8pNHt2
         irTzfrFP+T58xwnWZzI7TMGr6ltUwxZ9thY7wOyeuOcTOQpzRMq3MTANn75hiEDLvimx
         2LkqFw4ADDzhUsVpIZyDjKYyZSPZSIqMkri+sbt1OKBNBeAdinFdn7AY9pdDMZSD8sHi
         G5JatAMH8vpk/KZeY5Qwgf8r56MtS1EVs0BZNwGWWwY4hLtQIXoTXUoIaJ5qJWBZyI1B
         iNk4ijFLQOKSQaFKKvC/oprDbb35shx17I8AfsGhLdhterZbPeqERz2MGVRwn/McDNYK
         mGxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WgfA+bj8h/yfvLtv8TQjcWpJiGYbRoi7JEJT7KRe+10=;
        b=CnA2r/a6PWiLvBQJKY6D/tc41jMpkT1+gwFbFn+m2urwO7wgw88b2F15PZkTTJ4q6K
         95OYVmHygvIheS9fwLHx6i+yXPL7W98b9qOmPgHZmypvDPrDY3kCi+EXgMqSg/8L874l
         5JjrTxxy33vF5g0fqjpSkS/89OWBfR4QJ4nEwDsSYhJGF8tA/dQRaD2/gWng78qfZr8R
         Os+i1ktplZE8AfGQjsz+o7k8k52cLxy/kM+lANswkhd9svqeAjiwpfNfuzitq68NJHf6
         VchyG1MNSjliHZtTpwhpXR6rlZBI6tDio/paI48RZbYC3o6N9dZdkr4QcleKBuk4LBfQ
         RuoQ==
X-Gm-Message-State: AOAM533ykuOzL5zEqTdwML1A5nYtoU2a+au5jYq1NqfObu4fKJC0bt62
        JsxMVeSTN/2A41vGjzhPFvmK/4NHMCueopXR41M=
X-Google-Smtp-Source: ABdhPJx2nthqnJeOlu1EYtk5o5ecqX4NSf9T3KbKuJc6gbO4QF8jsAS27U+zJi6Zr28zSJZfr+Bsf/BbmatEKeYwHfY=
X-Received: by 2002:a02:9f87:0:b0:32e:69ae:23df with SMTP id
 a7-20020a029f87000000b0032e69ae23dfmr12443446jam.237.1653345494552; Mon, 23
 May 2022 15:38:14 -0700 (PDT)
MIME-Version: 1.0
References: <20220523202649.6iiz4h2wf5ryx3w2@jup> <CAEf4BzaecP2XkzftmH7GeeTfj1E+pv=20=L4ztrxe4-JU7MuUw@mail.gmail.com>
 <20220523221954.dsqvy55ron4cfdqq@jup>
In-Reply-To: <20220523221954.dsqvy55ron4cfdqq@jup>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 23 May 2022 15:38:03 -0700
Message-ID: <CAEf4BzY-K8UoT1HhXf=fwdWtY2fdprttUF27Zm6WwSUSRq8ycA@mail.gmail.com>
Subject: Re: [PATCH] bpftool: mmaped fields missing map structure in generated skeletons
To:     Michael Mullin <masmullin@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
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

On Mon, May 23, 2022 at 3:19 PM Michael Mullin <masmullin@gmail.com> wrote:
>
> On Mon, May 23, 2022 at 03:02:31PM -0700, Andrii Nakryiko wrote:
> > On Mon, May 23, 2022 at 1:26 PM Michael Mullin <masmullin@gmail.com> wrote:
> > >
> > > When generating a skeleton which has an mmaped map field, bpftool's
> > > output is missing the map structure.  This causes a compile break when
> > > the generated skeleton is compiled as the field belongs to the internal
> > > struct maps, not directly to the obj.
> > >
> > > Signed-off-by: Michael Mullin <masmullin@gmail.com>
> > > ---
> > >  tools/bpf/bpftool/gen.c | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > >
> > > diff --git a/tools/bpf/bpftool/gen.c b/tools/bpf/bpftool/gen.c
> > > index f158dc1c2149..b49293795ba0 100644
> > > --- a/tools/bpf/bpftool/gen.c
> > > +++ b/tools/bpf/bpftool/gen.c
> > > @@ -853,7 +853,7 @@ codegen_maps_skeleton(struct bpf_object *obj, size_t map_cnt, bool mmaped)
> > >                         i, bpf_map__name(map), i, ident);
> > >                 /* memory-mapped internal maps */
> > >                 if (mmaped && is_internal_mmapable_map(map, ident, sizeof(ident))) {
> > > -                       printf("\ts->maps[%zu].mmaped = (void **)&obj->%s;\n",
> > > +                       printf("\ts->maps[%zu].mmaped = (void **)&obj->maps.%s;\n",
> >
> > That's not right. maps.my_map is struct bpf_map *, but mmaped is
> > supposed to be a blob of memory that is memory-mapped into map.
> >
> > Can you elaborate on how you trigger that compilation error with a
> > small example?
>
> I have an a very small example on github. I have added some sed fixes to
> my Makefile make my sample program compile.
> https://github.com/masmullin2000/libbpf-sample/tree/main/c/simple
>
> https://github.com/masmullin2000/libbpf-sample/tree/02c7f945bf9027daedec04f485a320ba2df28204/c/simple
> contains broken code.

You are missing -g when calling clang to generate debug info (DWARF
and subsequently BTF). When BPF object file doesn't have BTF, we don't
generate those bss/data/rodata/etc sections of the skeleton. You
should be good just by adding -g.

>
> I apologize if this is an incorrect way to share external code.  I
> haven't found the proper way to share example code from
> kernelnewbies.org
>
> >
> > >                                 i, ident);
> > >                 }
> > >                 i++;
> > > --
> > > 2.36.1
> > >

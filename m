Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 497656461EF
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 20:58:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229683AbiLGT6D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 14:58:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229632AbiLGT6B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 14:58:01 -0500
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD1BA314;
        Wed,  7 Dec 2022 11:57:59 -0800 (PST)
Received: by mail-ej1-x62f.google.com with SMTP id b2so16516697eja.7;
        Wed, 07 Dec 2022 11:57:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uwlYb5TtslCWZuJIg0c5fFBPweRvwyNT2B+17eWN7DQ=;
        b=Epu9b5dteaX+/167ItSDQtYNYtOZV7s1VnROxCKUEg8gxgUlaOMVAyAE6IBgRJu4AG
         wd3ZSxVapysJonOPIfag2FxuSw3PMaoxLagpN7DFLU2sZ1nO/GeLBbNiCLm6jJwOBNQy
         7C/T+oc4lMuRN2rJzzinf41OljkHA8cO7RnEJp7F89btQvN7NQpWBNCmXElwesjI7/B8
         9QjyRMd7ExJ+AfEqI8Eu/20lH3oCVkHrpXNcJKJh1zFKWS4K4SKzLEfZjzA160BxyZDQ
         y6WSMVrFhBEBhKUO4GNXx5KQ2ibLGRJ2ZLBj+IyyeaqycbmQFe+jBVeO/ikEdb3Un7W+
         rs7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uwlYb5TtslCWZuJIg0c5fFBPweRvwyNT2B+17eWN7DQ=;
        b=wSMu3V0tjthUIxq00EQo0Xd/ORwVYI5qnEzZ+tf2YpBWwatz9SLvjaok7yPlhq+4GD
         D2r6TgeKiNttEYj2k87dtYralzYyBegEP9QR8Rkm+vqnYjsYx83tqkJ4VjqdKa4laEM+
         XxTeovSFJq5GJOekb2Zg0K6DThlQmdijdKXNdIKipRJxhtITRgQxkkKpNbLk0aaqIqWC
         VTtr83WULPYmssPfjewrnptFlWwRzR9+lEFqQDxUzGHhEP1qEtEO8pb8UIGGTjt3OieT
         kV+bKL30FQ/7MLu9fM9i0mBeajWaONiVhRe9p4h9PvJGXuaQC9sYu5rvxlUeyIv6R6jN
         0wEw==
X-Gm-Message-State: ANoB5pkixNgXIGop5sKjaIRCzKKOQPOSdQ28aZ+duX41xc4Q8Vok4ymq
        crXM5qXhPPNr3yKQZrjKGd02Vvh0uAjMUAtMtno=
X-Google-Smtp-Source: AA0mqf7bp/KMZyjJG/Nw7Jq0hhUH2gskYFrRzVBZEdGZhnQC056fC1ajnukx6kezEJ10OAdCAprYz3mfS629wQzO7qk=
X-Received: by 2002:a17:906:4351:b0:78d:513d:f447 with SMTP id
 z17-20020a170906435100b0078d513df447mr67023013ejm.708.1670443078360; Wed, 07
 Dec 2022 11:57:58 -0800 (PST)
MIME-Version: 1.0
References: <CACkBjsYioeJLhJAZ=Sq4CAL2O_W+5uqcJynFgLSizWLqEjNrjw@mail.gmail.com>
 <CACkBjsbD4SWoAmhYFR2qkP1b6JHO3Og0Vyve0=FO-Jb2JGGRfw@mail.gmail.com> <Y49dMUsX2YgHK0J+@krava>
In-Reply-To: <Y49dMUsX2YgHK0J+@krava>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 7 Dec 2022 11:57:47 -0800
Message-ID: <CAADnVQ+w-xtH=oWPYszG-TqxcHmbrKJK10C=P-o2Ouicx-9OUA@mail.gmail.com>
Subject: Re: BUG: unable to handle kernel paging request in bpf_dispatcher_xdp
To:     Jiri Olsa <olsajiri@gmail.com>
Cc:     Hao Sun <sunhao.th@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 6, 2022 at 7:18 AM Jiri Olsa <olsajiri@gmail.com> wrote:
>
> On Tue, Dec 06, 2022 at 02:46:43PM +0800, Hao Sun wrote:
> > Hao Sun <sunhao.th@gmail.com> =E4=BA=8E2022=E5=B9=B412=E6=9C=886=E6=97=
=A5=E5=91=A8=E4=BA=8C 11:28=E5=86=99=E9=81=93=EF=BC=9A
> > >
> > > Hi,
> > >
> > > The following crash can be triggered with the BPF prog provided.
> > > It seems the verifier passed some invalid progs. I will try to simpli=
fy
> > > the C reproducer, for now, the following can reproduce this:
> > >
> > > HEAD commit: ab0350c743d5 selftests/bpf: Fix conflicts with built-in
> > > functions in bpf_iter_ksym
> > > git tree: bpf-next
> > > console log: https://pastebin.com/raw/87RCSnCs
> > > kernel config: https://pastebin.com/raw/rZdWLcgK
> > > Syz reproducer: https://pastebin.com/raw/4kbwhdEv
> > > C reproducer: https://pastebin.com/raw/GFfDn2Gk
> > >
> >
> > Simplified C reproducer: https://pastebin.com/raw/aZgLcPvW
> >
> > Only two syscalls are required to reproduce this, seems it's an issue
> > in XDP test run. Essentially, the reproducer just loads a very simple
> > prog and tests run repeatedly and concurrently:
> >
> > r0 =3D bpf$PROG_LOAD(0x5, &(0x7f0000000640)=3D@base=3D{0x6, 0xb,
> > &(0x7f0000000500)}, 0x80)
> > bpf$BPF_PROG_TEST_RUN(0xa, &(0x7f0000000140)=3D{r0, 0x0, 0x0, 0x0, 0x0,
> > 0x0, 0xffffffff, 0x0, 0x0, 0x0, 0x0, 0x0}, 0x48)
> >
> > Loaded prog:
> >    0: (18) r0 =3D 0x0
> >    2: (18) r6 =3D 0x0
> >    4: (18) r7 =3D 0x0
> >    6: (18) r8 =3D 0x0
> >    8: (18) r9 =3D 0x0
> >   10: (95) exit
>
> hi,
> I can reproduce with your config.. it seems related to the
> recent static call change:
>   c86df29d11df bpf: Convert BPF_DISPATCHER to use static_call() (not ftra=
ce)
>
> I can't reproduce when I revert that commit.. Peter, any idea?

Jiri,

I see your tested-by tag on Peter's commit c86df29d11df.
I assume you're actually tested it, but
this syzbot oops shows that even empty bpf prog crashes,
so there is something wrong with that commit.

What is the difference between this new kconfig and old one that
you've tested?

I'm trying to understand the severity of the issues and
whether we need to revert that commit asap since the merge window
is about to start.

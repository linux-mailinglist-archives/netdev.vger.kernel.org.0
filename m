Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94335575FD1
	for <lists+netdev@lfdr.de>; Fri, 15 Jul 2022 13:12:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230304AbiGOLMR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 07:12:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232671AbiGOLMP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 07:12:15 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78D89868BE;
        Fri, 15 Jul 2022 04:12:14 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id u6so3611066iop.5;
        Fri, 15 Jul 2022 04:12:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=UlW0VK5pgcNuSESfDY08KdWKF3jSE9iNqz6LueMVk2I=;
        b=mgyMi2mDG6jwhcRoqFwFM7UOc29LYfsORthev01Vyz/G0fpCP6LBjNTFYIfY+Eye1J
         hMOsEC5GfXofaybkF/uQgTvlrz6y7GukPnEZuMMojSTN0U25452vFeqt7VX5Nfl3g/sQ
         RSOY3HgPWg7z/Fz2xnbrs+16rt7PPumxXMACEO1pybkI7GMdgH6/0rxTdYf7Co9tPo+R
         rKvgKl2jkBzVUfmtVZgMxEf6/cq78ez6PrFtcsWgIqg3NZmyH6ZvQ5oBQWgJruXDEGHu
         tCmLNz54a63K4glJT9cH/kVMap0uPu728OjsFNqcrx8wFxifTUBywaEtS4B/H3l6AAKg
         XSWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=UlW0VK5pgcNuSESfDY08KdWKF3jSE9iNqz6LueMVk2I=;
        b=G1Sj0kHeOZvDaaM+aRCiVzCMoUu5jCUAtHJpwfMf1sdpo/Zp/6Wf0XWrRu+EqgREEU
         Pmfy0SxZU4G/loYaJ5LiDEpEEqXd18UBHCWsftCYpaW5r+R8oB3TUnYEKeGYM7DSh/rZ
         2mWIFCCmLi6mx0rcAwX8EAcpjF2jRFHydMV1PXbtlaxBcH3jTz7/I35IFDYH99kFu58Y
         205GzF4ZZXB/0vJRpCY5HQ9hhtIVygSfYE8AVL8jmglR5oLP2dNBOKL7t2DRgj+mbuHU
         DgrQIjwcJoYZpK/8jk2Dqo14p75aQqx3bGjP8j4Y4kFZI1rBY2fIPbdB+pz7nxiM8rYR
         YZxQ==
X-Gm-Message-State: AJIora+EXXT0V7LjS2/FG+xJC0oxSEGf2GuN/s1j843oEwLtxMINqP9g
        a1Bo4z8urS8wYXk8L8Zx/VPs/0G9IDG8yXV/0yo=
X-Google-Smtp-Source: AGRyM1sQMv0bB0zJ5rb/Nj6jLiYYetxNOwpmVNQvcmwPTSY7//c+9o6WaVSga0L3JrAesOY0SNm+DchzwuZKTDUh4n4=
X-Received: by 2002:a02:c4c3:0:b0:33f:4fb4:834b with SMTP id
 h3-20020a02c4c3000000b0033f4fb4834bmr7395396jaj.231.1657883533802; Fri, 15
 Jul 2022 04:12:13 -0700 (PDT)
MIME-Version: 1.0
References: <20220713111430.134810-1-toke@redhat.com> <20220713111430.134810-16-toke@redhat.com>
 <CAEf4BzYUbwqKit9QY6zyq8Pkxa8+8SOiejGzuTGARVyXr8KdcA@mail.gmail.com>
 <CAP01T760my2iTzM5qsYvsZb6wvJP02k7BGOEOP-pHPPHEbH5Rg@mail.gmail.com> <CAEf4BzZJvr+vcO57TK94GM7B5=k2wPgAub4BBJf1Uz0xNpCPVg@mail.gmail.com>
In-Reply-To: <CAEf4BzZJvr+vcO57TK94GM7B5=k2wPgAub4BBJf1Uz0xNpCPVg@mail.gmail.com>
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
Date:   Fri, 15 Jul 2022 13:11:36 +0200
Message-ID: <CAP01T77U28HTwW2c=DEanZs09z1bFO0A+iSnAUAN+Z5r0efNew@mail.gmail.com>
Subject: Re: [RFC PATCH 15/17] selftests/bpf: Add verifier tests for dequeue prog
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
        Mykola Lysenko <mykolal@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Freysteinn Alfredsson <freysteinn.alfredsson@kau.se>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Shuah Khan <shuah@kernel.org>
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

On Thu, 14 Jul 2022 at 20:54, Andrii Nakryiko <andrii.nakryiko@gmail.com> w=
rote:
>
> On Wed, Jul 13, 2022 at 11:45 PM Kumar Kartikeya Dwivedi
> <memxor@gmail.com> wrote:
> >
> > On Thu, 14 Jul 2022 at 07:38, Andrii Nakryiko <andrii.nakryiko@gmail.co=
m> wrote:
> > >
> > > On Wed, Jul 13, 2022 at 4:15 AM Toke H=C3=B8iland-J=C3=B8rgensen <tok=
e@redhat.com> wrote:
> > > >
> > > > From: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> > > >
> > > > Test various cases of direct packet access (proper range propagatio=
n,
> > > > comparison of packet pointers pointing into separate xdp_frames, an=
d
> > > > correct invalidation on packet drop (so that multiple packet pointe=
rs
> > > > are usable safely in a dequeue program)).
> > > >
> > > > Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> > > > Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> > > > ---
> > >
> > > Consider writing these tests as plain C BPF code and put them in
> > > test_progs, is there anything you can't express in C and thus require=
s
> > > test_verifier?
> >
> > Not really, but in general I like test_verifier because it stays
> > immune to compiler shenanigans.
>
> In general I dislike them because they are almost incomprehensible. So
> unless there is a very particular sequence of low-level BPF assembly
> instructions one needs to test, I'd always opt for test_progs as more
> maintainable solution.
>
> Things like making sure that verifier rejects invalid use of
> particular objects or helpers doesn't seem to rely much on particular
> assembly sequence and can and should be expressed with plain C.
>
>
> > So going forward should test_verifier tests be avoided, and normal C
> > tests (using SEC("?...")) be preferred for these cases?
>
> In my opinion, yes, unless absolutely requiring low-level assembly to
> express conditions which are otherwise hard to express reliably in C.
>

Ok, fair point. I will replace these with C tests in the next version.

> >
> > >
> > > >  tools/testing/selftests/bpf/test_verifier.c   |  29 +++-
> > > >  .../testing/selftests/bpf/verifier/dequeue.c  | 160 ++++++++++++++=
++++
> > > >  2 files changed, 180 insertions(+), 9 deletions(-)
> > > >  create mode 100644 tools/testing/selftests/bpf/verifier/dequeue.c
> > > >
> > >
> > > [...]

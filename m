Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E3614F0D12
	for <lists+netdev@lfdr.de>; Mon,  4 Apr 2022 01:52:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347888AbiDCXxQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Apr 2022 19:53:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242803AbiDCXxP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Apr 2022 19:53:15 -0400
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C2533A190;
        Sun,  3 Apr 2022 16:51:20 -0700 (PDT)
Received: by mail-io1-xd32.google.com with SMTP id g21so9366531iom.13;
        Sun, 03 Apr 2022 16:51:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZQegRDWXuFQvAnn9quvvw72t2AEEj0/+XbF0zPO9DH0=;
        b=l8XricTgShuuNHcB+kBCjEJ94MIdLEwD+IvlBXVFTvj8WfauFzIX+dxks3UdnX3lYW
         i8sXj1zVrVsye7TGcP+kMLlg5K4b7WjWPzXE9VIIYmp5zOgQK23sdLstbn/UA/8Xqu0t
         nNSBwcGc1QQyRG5YygxaO/hYx5eQbTGYpQYKy1nuznUglkNuSRFnwfmBhNn0kf0TdGpb
         qA5BH3KK1nSIblRKWIy2lL7bYiM6+A8eNGOrLMq4CWNJgxa9JCWfhCd5ROWYTOmWCuqm
         m4GC7cnPrvIAinOBzZlWBocKyxO26RaEpjJ7xh3jBttpbQIBikZXAbe3LILkRjiSqI1G
         N2fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZQegRDWXuFQvAnn9quvvw72t2AEEj0/+XbF0zPO9DH0=;
        b=dCZt2Q+sLKcYOmZGGgwUuhpGZfv7hYy+j/eOII2XNKiXijB/x6lmnP1ZVXhk0AN6Cw
         YE3n9nR8O58cTRJSJXqr/q8I38OmqqRCbmzVh6mMEcsvjpsCfDBfkJsPppPyv2aUuu1z
         jxvn7T6GR/mS1EJb9sr7hRMH8hP+B6oBDB3YU4WwY1NbV56Ds1rqvtEn3hfar44kMxU1
         4NCGQwiMojunFCG7s5SD2YvM0ccoGbXMqQaNNwE76f9uO5OMmbaGJR+I/izFn6XPExj9
         jXK3bJWqy07CAAOD+m8pyGl55IA46btxeZ3aZSlAbWkxk3OyBPhXsHNzf+C8gh2/YkoC
         u+Wg==
X-Gm-Message-State: AOAM531RiJZ7ufoWhoPTRfqwl1EMVqrJxUSdOjk5Kz1iMWj13imnxQVv
        v7uYqJZor52nsLM2+dzOZp4Bs/htv8lG5T3jPUY=
X-Google-Smtp-Source: ABdhPJxyWRaqrmgOvW/g9S/6eZuPeqvJMOwJtFFVNrqwch0EDAeQToTiTmLqgBnTZwkiHL22cQNBqt+7csz6wTz1CW0=
X-Received: by 2002:a05:6638:2105:b0:323:68db:2e4e with SMTP id
 n5-20020a056638210500b0032368db2e4emr10956837jaj.234.1649029879461; Sun, 03
 Apr 2022 16:51:19 -0700 (PDT)
MIME-Version: 1.0
References: <20220331154555.422506-1-milan@mdaverde.com> <20220331154555.422506-4-milan@mdaverde.com>
 <8457bd5f-0541-e128-b033-05131381c590@isovalent.com> <CAEf4BzaqqZ+bFamrTXSzjgXgAEkBpCTmCffNR-xb8SwN6TNaOw@mail.gmail.com>
 <CACdoK4JbhtOpQeGo+NUh5t3nQG8No8Di6ce-9gwgNw3az2Fu=A@mail.gmail.com>
In-Reply-To: <CACdoK4JbhtOpQeGo+NUh5t3nQG8No8Di6ce-9gwgNw3az2Fu=A@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Sun, 3 Apr 2022 16:51:08 -0700
Message-ID: <CAEf4BzbBdsZzdH9hTTSnuaXq8bhEORFhpaoaT47WA54P4Gr3MQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next 3/3] bpf/bpftool: handle libbpf_probe_prog_type errors
To:     Quentin Monnet <quentin@isovalent.com>
Cc:     Milan Landaverde <milan@mdaverde.com>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Dave Marchevsky <davemarchevsky@fb.com>,
        Stanislav Fomichev <sdf@google.com>,
        Networking <netdev@vger.kernel.org>,
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

On Fri, Apr 1, 2022 at 2:33 PM Quentin Monnet <quentin@isovalent.com> wrote:
>
> On Fri, 1 Apr 2022 at 19:42, Andrii Nakryiko <andrii.nakryiko@gmail.com> wrote:
> >
> > On Fri, Apr 1, 2022 at 9:05 AM Quentin Monnet <quentin@isovalent.com> wrote:
> > >
> > > 2022-03-31 11:45 UTC-0400 ~ Milan Landaverde <milan@mdaverde.com>
> > > > Previously [1], we were using bpf_probe_prog_type which returned a
> > > > bool, but the new libbpf_probe_bpf_prog_type can return a negative
> > > > error code on failure. This change decides for bpftool to declare
> > > > a program type is not available on probe failure.
> > > >
> > > > [1] https://lore.kernel.org/bpf/20220202225916.3313522-3-andrii@kernel.org/
> > > >
> > > > Signed-off-by: Milan Landaverde <milan@mdaverde.com>
> > > > ---
> > > >  tools/bpf/bpftool/feature.c | 2 +-
> > > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > >
> > > > diff --git a/tools/bpf/bpftool/feature.c b/tools/bpf/bpftool/feature.c
> > > > index c2f43a5d38e0..b2fbaa7a6b15 100644
> > > > --- a/tools/bpf/bpftool/feature.c
> > > > +++ b/tools/bpf/bpftool/feature.c
> > > > @@ -564,7 +564,7 @@ probe_prog_type(enum bpf_prog_type prog_type, bool *supported_types,
> > > >
> > > >               res = probe_prog_type_ifindex(prog_type, ifindex);
> > > >       } else {
> > > > -             res = libbpf_probe_bpf_prog_type(prog_type, NULL);
> > > > +             res = libbpf_probe_bpf_prog_type(prog_type, NULL) > 0;
> > > >       }
> > > >
> > > >  #ifdef USE_LIBCAP
> > >
> >
> > A completely unrelated question to you, Quentin. How hard is bpftool's
> > dependency on libcap? We've recently removed libcap from selftests, I
> > wonder if it would be possible to do that for bpftool as well to
> > reduce amount of shared libraries bpftool depends on.
>
> There's not a super-strong dependency on it. It's used in feature
> probing, for two things.
>
> First one is to be accurate when we check that the user has the right
> capabilities for probing efficiently the system. A workaround consists
> in checking that we run with uid=0 (root), although it's less
> accurate.
>
> Second thing is probing as an unprivileged user: if bpftool is run to
> probe as root but with the "unprivileged" keyword, libcap is used to
> drop the CAP_SYS_ADMIN and run the probes without it. I don't know if
> there's an easy alternative to libcap for that. Also I don't know how
> many people use this feature, but I remember that this was added
> because there was some demand at the time, so presumably there are
> users relying on this.
>
> This being said, libcap is optional for compiling bpftool, so you
> should be able to have it work just as well if the library is not
> available on the system? Basically you'd just lose the ability to
> probe as an unprivileged user. Do you need to remove the optional
> dependency completely?

Well, see recent patches from Martin:

82cb2b30773e bpf: selftests: Remove libcap usage from test_progs
b1c2768a82b9 bpf: selftests: Remove libcap usage from test_verifier
663af70aabb7 bpf: selftests: Add helpers to directly use the capget
and capset syscall

We completely got rid of libcap dependency and ended up with more
straightforward code. So I was wondering if this is possible for
bpftool. The less unnecessary library dependencies - the better. The
less feature detection -- the better. That's my only line of thought
here :)

>
> Quentin
>
> PS: Not directly related but since we're talking of libcap, we
> recently discovered that the lib is apparently changing errno when it
> maybe shouldn't and plays badly with batch mode:
> https://stackoverflow.com/questions/71608181/bpf-xdp-bpftool-batch-file-returns-error-reading-batch-file-failed-opera

just another argument in favor of getting rid of extra layers of dependencies

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 174324E4404
	for <lists+netdev@lfdr.de>; Tue, 22 Mar 2022 17:14:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238982AbiCVQP6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Mar 2022 12:15:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233231AbiCVQP5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Mar 2022 12:15:57 -0400
Received: from mail-il1-x12c.google.com (mail-il1-x12c.google.com [IPv6:2607:f8b0:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BDC94CD78;
        Tue, 22 Mar 2022 09:14:29 -0700 (PDT)
Received: by mail-il1-x12c.google.com with SMTP id j15so2608389ila.13;
        Tue, 22 Mar 2022 09:14:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=ZIzlYH948l+CJycdMBUZ9/fbCooDhR48Kgko0AcT0Io=;
        b=O0chmLZ0Xgk7GypkOs6BWwedvaI2xtLe3YGrRgZIcR8sPpWkN/qCZhjnwBvbVjKDwk
         Wrsnuvq9FIXB1lFWbiILFabrqvoi7ZJFCo728NKwLiI6nd4CW6NqjRm4cWPiiGjHBzHI
         sU43TMwmrWQvNT1GLB0bPjtcHGkXGHCYpcZjleJWLf0Syw3edJeF/iNyA/Hjv34VP1OR
         d7lrSLL7yjjQoGJqDd4X5b1NU9frDTD1oIoFSm2GjwltXbXe13qFsyVDc9d042Lxooh4
         7dNrUyQvItPiQF2Q6elNtdmXyg3YnyjIkoFAf9d6atJX0J5IFRMk35BYq3/jAkr9VFco
         dwGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ZIzlYH948l+CJycdMBUZ9/fbCooDhR48Kgko0AcT0Io=;
        b=aQyo3ZqPCfhLAHL9U3gKJJ2X3VCw5GBpjDPpQlNu+EG4qd6R/EnYgcoR+YGroR+cQZ
         WrxDbnrjbulf867wbw/KAW7cB7csC8h4eLZ2217epJhDmy/38hIYl8UNm5ili2576mm5
         9VHwA7j0p/GQKi8JYGxGVRaNX+H8Kk6q3wowI4GsTznVQdSwNaRdi7BnyAvU4pVurvPu
         rpqn8B1KF7c9MXnqFmEYfCwj8Y1cnaoWvKOm0IM5esFwzB9zBV4w9dceOpuXMZHXafQz
         CENnMkYD0P2uRBHIjxSmCaGFu5s831vGOYZhElrwCZNMoN5eAbg8Jmy361l3z2qB5bgo
         d7PA==
X-Gm-Message-State: AOAM533AkJ1PWUG3vJgm8sZ7sPvt8uXeOHftON61INoIDZnKMmUnxFRO
        zJM/2mxJOYBaKsn21fBB2+eDKJFoDMK3rofV220=
X-Google-Smtp-Source: ABdhPJzK8Hba9brFYO7yxZKQsZDDTcOdJeTkQaAOTADCF6rRwfG10UCUu+wzBGfp0WQ9/qz2ewDT6fxR9Fzn4Q16Knc=
X-Received: by 2002:a05:6e02:216f:b0:2c8:2ed0:bba1 with SMTP id
 s15-20020a056e02216f00b002c82ed0bba1mr4644883ilv.87.1647965669045; Tue, 22
 Mar 2022 09:14:29 -0700 (PDT)
MIME-Version: 1.0
References: <20220320060815.7716-2-laoar.shao@gmail.com> <0D674EA5-3626-4885-9ADC-5B7847CC967D@linux.dev>
 <CAEf4BzbpoYbPzYRA8bW=f48=wX0jJPuWX=Jr_uNnC_Jq80Bz3Q@mail.gmail.com>
In-Reply-To: <CAEf4BzbpoYbPzYRA8bW=f48=wX0jJPuWX=Jr_uNnC_Jq80Bz3Q@mail.gmail.com>
From:   Yafang Shao <laoar.shao@gmail.com>
Date:   Wed, 23 Mar 2022 00:13:50 +0800
Message-ID: <CALOAHbB7jUTNUb7QESpjU=w3xgBOY=oJL=DdsMc4zpW=YKF1qg@mail.gmail.com>
Subject: Re: [PATCH] bpf: selftests: cleanup RLIMIT_MEMLOCK
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Roman Gushchin <roman.gushchin@linux.dev>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 22, 2022 at 8:13 AM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Sun, Mar 20, 2022 at 9:58 AM Roman Gushchin <roman.gushchin@linux.dev>=
 wrote:
> >
> >
> > > On Mar 19, 2022, at 11:08 PM, Yafang Shao <laoar.shao@gmail.com> wrot=
e:
> > >
> > > =EF=BB=BFSince we have alread switched to memcg-based memory accoutin=
g and control,
> > > we don't need RLIMIT_MEMLOCK any more.
> > >
> > > Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
> > > Cc: Roman Gushchin <roman.gushchin@linux.dev>
> > >
> > > ---
> > > RLIMIT_MEMLOCK is still used in bpftool and libbpf, but it may be use=
ful
> > > for backward compatibility, so I don't cleanup them.
> >
> > Hi Yafang!
> >
> > As I remember, we haven=E2=80=99t cleaned selftests up with the same lo=
gic: it=E2=80=99s nice to be able to run the same version of tests on older=
 kernels.
> >
>
> It should be fine, at least for test_progs and test_progs-no_alu32.
> Libbpf now does this automatically if running in "libbpf 1.0" mode.
>
> Yafang, please make sure that all the test binaries you are cleaning
> up have libbpf_set_strict_mode(LIBBPF_STRICT_ALL) (test_progs does
> already). You might need to clean up some SEC() definitions, in case
> we still missed some non-conforming ones, though.
>

Thanks for the suggestion. I will do it.

--=20
Thanks
Yafang

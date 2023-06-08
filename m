Return-Path: <netdev+bounces-9125-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2C11A727637
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 06:39:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 773951C20F54
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 04:39:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C23E1C30;
	Thu,  8 Jun 2023 04:39:31 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D115628;
	Thu,  8 Jun 2023 04:39:30 +0000 (UTC)
Received: from mail-yw1-x1142.google.com (mail-yw1-x1142.google.com [IPv6:2607:f8b0:4864:20::1142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C9B8270D;
	Wed,  7 Jun 2023 21:39:25 -0700 (PDT)
Received: by mail-yw1-x1142.google.com with SMTP id 00721157ae682-56974f42224so1535187b3.1;
        Wed, 07 Jun 2023 21:39:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686199164; x=1688791164;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/XropgKuXeNQLqvQa8YUz1hw0VwuOoe/8nudVDeT830=;
        b=HZRUATZlAV3IbhAQbkizborzvV4BZ2on/7dHPQngEeVxl5seGnMnlU6tYjxSjjgqB1
         GS1QzbUQCLOeB7piOsSw0ulZKqNjSwg7CTV5bzfX4qBc3bey+lbbzfhj0gvq3+PEAH+R
         ApVVYyBQg2LWTVYrVdQPu0xprqKc80RfGX+SAFoszk5Odqe6FlLylOJaYRAPVF48SadG
         tXdzaAobh2iyoz01X8BMFNL1iqrgOAPzwncoplOlvbMXZHcP/lppHopj0wxFYZGNArvN
         /wsBFj1SkS5pVqR7jWR5g2cGT1/IJk2G1XmpNo5Pz8KsgCPw6Zs4+jG6ZBtrxAR6Hn5N
         zIQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686199164; x=1688791164;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/XropgKuXeNQLqvQa8YUz1hw0VwuOoe/8nudVDeT830=;
        b=Lw84vZjf0NmWISGA1e54+BunVuNgHBRwDFP0ZR5WxwmPVHW5iN1/P//KBIxueYqieI
         H2m/dWpKQmm9sydYyHtLFT7heSQQ5l+r/tgZA4ui1/KDqAMGr3Q5Sq126iHSHjx2CWzn
         P8y5gFRZYuli4MYU0QXEsO73O/416ToWuHuFpguIlTv27tATy/bixbvH+HC9G5ECvqEm
         ymGV/EjK01or+E+h2cave4cXOHyeKgKxRm63Vt8aHz4cZm80TlKgqglU4pQ9nEgEZxBm
         rLmqngYu3tdGMdvVW73ruSe256glK9aA9PRjB9DOVi0Mfw9FsaXz57aKbw4V3kX1nVOw
         vasQ==
X-Gm-Message-State: AC+VfDzAe9Vu4WYEK5EgliESXsiBzsnVDctevHB7jgTWYGu/6YqGOTBw
	HNhTqYWGUYrA/wnwZtVza/qgM3tYG10zwYvKdIk=
X-Google-Smtp-Source: ACHHUZ6OG73GM5QzW+HSafnvVrns5acdoJKJu1ieTPBMXSLI9Sb+r22xRZb6JdEjVbAZEYfMLH5yz8ftCwiFPq/khSY=
X-Received: by 2002:a81:8450:0:b0:565:b22c:4165 with SMTP id
 u77-20020a818450000000b00565b22c4165mr9757512ywf.11.1686199164563; Wed, 07
 Jun 2023 21:39:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230607125911.145345-1-imagedong@tencent.com>
 <20230607125911.145345-4-imagedong@tencent.com> <20230607201008.662mecxnksxiees3@macbook-pro-8.dhcp.thefacebook.com>
In-Reply-To: <20230607201008.662mecxnksxiees3@macbook-pro-8.dhcp.thefacebook.com>
From: Menglong Dong <menglong8.dong@gmail.com>
Date: Thu, 8 Jun 2023 12:39:13 +0800
Message-ID: <CADxym3bLP1kSzXgCakRMtGGp_jk1DR-nZA=jafZdemzLe3omtA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 3/3] selftests/bpf: add testcase for
 FENTRY/FEXIT with 6+ arguments
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: davem@davemloft.net, dsahern@kernel.org, ast@kernel.org, 
	daniel@iogearbox.net, andrii@kernel.org, martin.lau@linux.dev, 
	song@kernel.org, yhs@fb.com, john.fastabend@gmail.com, kpsingh@kernel.org, 
	sdf@google.com, x86@kernel.org, imagedong@tencent.com, benbjiang@tencent.com, 
	netdev@vger.kernel.org, bpf@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, Jun 8, 2023 at 4:10=E2=80=AFAM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Wed, Jun 07, 2023 at 08:59:11PM +0800, menglong8.dong@gmail.com wrote:
> > From: Menglong Dong <imagedong@tencent.com>
> >
> > Add test9/test10 in fexit_test.c and fentry_test.c to test the fentry
> > and fexit whose target function have 7/12 arguments.
> >
> > Correspondingly, add bpf_testmod_fentry_test7() and
> > bpf_testmod_fentry_test12() to bpf_testmod.c
> >
> > And the testcases passed:
> >
> > ./test_progs -t fexit
> > Summary: 5/12 PASSED, 0 SKIPPED, 0 FAILED
> >
> > ./test_progs -t fentry
> > Summary: 3/0 PASSED, 0 SKIPPED, 0 FAILED
> >
> > Reviewed-by: Jiang Biao <benbjiang@tencent.com>
> > Signed-off-by: Menglong Dong <imagedong@tencent.com>
> > ---
> > v3:
> > - move bpf_fentry_test{7,12} to bpf_testmod.c and rename them to
> >   bpf_testmod_fentry_test{7,12} meanwhile
> > - get return value by bpf_get_func_ret() in
> >   "fexit/bpf_testmod_fentry_test12", as we don't change ___bpf_ctx_cast=
()
> >   in this version
> > ---
> >  .../selftests/bpf/bpf_testmod/bpf_testmod.c   | 19 ++++++++++-
> >  .../selftests/bpf/prog_tests/fentry_fexit.c   |  4 ++-
> >  .../selftests/bpf/prog_tests/fentry_test.c    |  2 ++
> >  .../selftests/bpf/prog_tests/fexit_test.c     |  2 ++
> >  .../testing/selftests/bpf/progs/fentry_test.c | 21 ++++++++++++
> >  .../testing/selftests/bpf/progs/fexit_test.c  | 33 +++++++++++++++++++
> >  6 files changed, 79 insertions(+), 2 deletions(-)
> >
> > diff --git a/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod.c b/to=
ols/testing/selftests/bpf/bpf_testmod/bpf_testmod.c
> > index cf216041876c..66615fdbe3df 100644
> > --- a/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod.c
> > +++ b/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod.c
> > @@ -191,6 +191,19 @@ noinline int bpf_testmod_fentry_test3(char a, int =
b, u64 c)
> >       return a + b + c;
> >  }
> >
> > +noinline int bpf_testmod_fentry_test7(u64 a, void *b, short c, int d,
> > +                                   void *e, u64 f, u64 g)
> > +{
> > +     return a + (long)b + c + d + (long)e + f + g;
> > +}
> > +
> > +noinline int bpf_testmod_fentry_test12(u64 a, void *b, short c, int d,
> > +                                    void *e, u64 f, u64 g, u64 h,
> > +                                    u64 i, u64 j, u64 k, u64 l)
>
> Please switch args to a combination of u8,u16,u32,u64.
> u64 only args might hide bugs.

Okay, that makes sense.


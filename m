Return-Path: <netdev+bounces-7831-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 10392721C45
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 04:56:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B9E812810F2
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 02:56:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0018A37D;
	Mon,  5 Jun 2023 02:56:09 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3E1D198;
	Mon,  5 Jun 2023 02:56:08 +0000 (UTC)
Received: from mail-yb1-xb41.google.com (mail-yb1-xb41.google.com [IPv6:2607:f8b0:4864:20::b41])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BE98CC;
	Sun,  4 Jun 2023 19:56:07 -0700 (PDT)
Received: by mail-yb1-xb41.google.com with SMTP id 3f1490d57ef6-bab8f66d3a2so5118977276.3;
        Sun, 04 Jun 2023 19:56:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685933767; x=1688525767;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6gWa0dT2lb5mRzP5Yoj2JMiWsUkD2gLZ1PMNzk7s+Tw=;
        b=CK7qhsYOmjgD+6hYdUPOE/M3qWHYhw305uD9kDHKRRxJvB88OkYVj01PDMge3IEHg7
         KkCOC4yWZ7qo5vcfTOFV61JOg3H6TDnQA6pCaixcWzlcZBsmrHYPh9na4Adanyab5Vr1
         /MGcGK0qeQlyaiUHe9Ydx8uyNvaaaJwu8s32WHn7XOk6TgUhxRol1MvuahFaLH3O/EBG
         ThfSCQ/Fbyd4R2fETuMaq8uRXUxI42JAqIAwQfLQz6JWcveWhb8wITvimID1KhFKNW1b
         MwwajOBwJperFn+O7SaczRQmJGV/rPC5XsMlKr41ZJegyz0PCuEsT5j9KXGZR3XdQEaX
         R9kQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685933767; x=1688525767;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6gWa0dT2lb5mRzP5Yoj2JMiWsUkD2gLZ1PMNzk7s+Tw=;
        b=ZLWIXes5gpKe/G9saSXQdNjmpGWtflY31QI+3iQgJGG69dKndFwioKvEHThky5j+Ed
         /6UKxgxDzEBzSm42zruMnP0+thCX6rjQkITvZpyCpBgd2hzOhuaN+n1ltdwM6sWED8Vj
         aqqzwP0TRP7/RvJWmAyeZrzafpoY6Nohyz3ZK407BRGRbEBzsViHVFC64KPhFKoeUJQr
         wfMLWDRcmwrKBqm8/Ozk4RgKPd0YqLw8jlLWup4nKu35xjCZ6wDKTVVvsmIH2PoYq0uv
         Ua5gQJCWPMLhqvLteixk4IwLkKEtdVL6hC5Ta+Pnv+SG0gA7KaUKIhwvKL4T/oF1N1kD
         qd/g==
X-Gm-Message-State: AC+VfDyiWEbpVEmPw61mUrGlgkT0Nob2H+rvoVxqb5afm3LrmM4AU+R3
	l4RhBCy9rhMFzJa4yMt02DYr7oubTRccCSl/4DA=
X-Google-Smtp-Source: ACHHUZ7PZuFCppra41w3WE3sTX/zdixviRujMOgi2F7yHrOtjwx2B9DAIC8tnmpdzfd5tqiIFuJoMoio9uVC8+Asxvw=
X-Received: by 2002:a25:2142:0:b0:bac:652e:b65 with SMTP id
 h63-20020a252142000000b00bac652e0b65mr10577871ybh.28.1685933766580; Sun, 04
 Jun 2023 19:56:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230602065958.2869555-1-imagedong@tencent.com>
 <20230602065958.2869555-6-imagedong@tencent.com> <CAADnVQLPhhEjp6HfsQhaEdp269MZGs2jBkPtkeBe8i0r-MWnYA@mail.gmail.com>
In-Reply-To: <CAADnVQLPhhEjp6HfsQhaEdp269MZGs2jBkPtkeBe8i0r-MWnYA@mail.gmail.com>
From: Menglong Dong <menglong8.dong@gmail.com>
Date: Mon, 5 Jun 2023 10:55:55 +0800
Message-ID: <CADxym3ZNwuYTmXyzTuyqhPbwerejJOC8_YuSBsyFwzogOjvagA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 5/5] selftests/bpf: add testcase for
 FENTRY/FEXIT with 6+ arguments
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: Jiri Olsa <olsajiri@gmail.com>, "David S. Miller" <davem@davemloft.net>, 
	David Ahern <dsahern@kernel.org>, Alexei Starovoitov <ast@kernel.org>, 
	Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>, 
	Martin KaFai Lau <martin.lau@linux.dev>, Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>, 
	KP Singh <kpsingh@kernel.org>, Jiri Olsa <jolsa@kernel.org>, X86 ML <x86@kernel.org>, 
	Biao Jiang <benbjiang@tencent.com>, Network Development <netdev@vger.kernel.org>, 
	bpf <bpf@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, 
	"open list:KERNEL SELFTEST FRAMEWORK" <linux-kselftest@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Sat, Jun 3, 2023 at 2:32=E2=80=AFAM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Fri, Jun 2, 2023 at 12:03=E2=80=AFAM <menglong8.dong@gmail.com> wrote:
> >
> > From: Menglong Dong <imagedong@tencent.com>
> >
> > Add test7/test12/test14 in fexit_test.c and fentry_test.c to test the
> > fentry and fexit whose target function have 7/12/14 arguments.
> >
> > And the testcases passed:
> >
> > ./test_progs -t fexit
> > $71      fentry_fexit:OK
> > $73/1    fexit_bpf2bpf/target_no_callees:OK
> > $73/2    fexit_bpf2bpf/target_yes_callees:OK
> > $73/3    fexit_bpf2bpf/func_replace:OK
> > $73/4    fexit_bpf2bpf/func_replace_verify:OK
> > $73/5    fexit_bpf2bpf/func_sockmap_update:OK
> > $73/6    fexit_bpf2bpf/func_replace_return_code:OK
> > $73/7    fexit_bpf2bpf/func_map_prog_compatibility:OK
> > $73/8    fexit_bpf2bpf/func_replace_multi:OK
> > $73/9    fexit_bpf2bpf/fmod_ret_freplace:OK
> > $73/10   fexit_bpf2bpf/func_replace_global_func:OK
> > $73/11   fexit_bpf2bpf/fentry_to_cgroup_bpf:OK
> > $73/12   fexit_bpf2bpf/func_replace_progmap:OK
> > $73      fexit_bpf2bpf:OK
> > $74      fexit_sleep:OK
> > $75      fexit_stress:OK
> > $76      fexit_test:OK
> > Summary: 5/12 PASSED, 0 SKIPPED, 0 FAILED
> >
> > ./test_progs -t fentry
> > $71      fentry_fexit:OK
> > $72      fentry_test:OK
> > $140     module_fentry_shadow:OK
> > Summary: 3/0 PASSED, 0 SKIPPED, 0 FAILED
> >
> > Reviewed-by: Jiang Biao <benbjiang@tencent.com>
> > Signed-off-by: Menglong Dong <imagedong@tencent.com>
> > ---
> >  net/bpf/test_run.c                            | 30 +++++++++++++++-
> >  .../testing/selftests/bpf/progs/fentry_test.c | 34 ++++++++++++++++++
> >  .../testing/selftests/bpf/progs/fexit_test.c  | 35 +++++++++++++++++++
> >  3 files changed, 98 insertions(+), 1 deletion(-)
> >
> > diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
> > index c73f246a706f..e12a72311eca 100644
> > --- a/net/bpf/test_run.c
> > +++ b/net/bpf/test_run.c
> > @@ -536,6 +536,27 @@ int noinline bpf_fentry_test6(u64 a, void *b, shor=
t c, int d, void *e, u64 f)
> >         return a + (long)b + c + d + (long)e + f;
> >  }
> >
> > +noinline int bpf_fentry_test7(u64 a, void *b, short c, int d, void *e,
> > +                             u64 f, u64 g)
> > +{
> > +       return a + (long)b + c + d + (long)e + f + g;
> > +}
> > +
> > +noinline int bpf_fentry_test12(u64 a, void *b, short c, int d, void *e=
,
> > +                              u64 f, u64 g, u64 h, u64 i, u64 j,
> > +                              u64 k, u64 l)
> > +{
> > +       return a + (long)b + c + d + (long)e + f + g + h + i + j + k + =
l;
> > +}
> > +
> > +noinline int bpf_fentry_test14(u64 a, void *b, short c, int d, void *e=
,
> > +                              u64 f, u64 g, u64 h, u64 i, u64 j,
> > +                              u64 k, u64 l, u64 m, u64 n)
> > +{
> > +       return a + (long)b + c + d + (long)e + f + g + h + i + j + k + =
l +
> > +              m + n;
> > +}
>
> Please add test func to bpf_testmod instead of here.

Okay!

Thanks!
Menglong Dong


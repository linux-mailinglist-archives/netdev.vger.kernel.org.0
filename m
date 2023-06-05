Return-Path: <netdev+bounces-7830-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3C772721C30
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 04:55:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AAD581C20AD5
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 02:55:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4161137D;
	Mon,  5 Jun 2023 02:55:04 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27313198;
	Mon,  5 Jun 2023 02:55:04 +0000 (UTC)
Received: from mail-yw1-x1142.google.com (mail-yw1-x1142.google.com [IPv6:2607:f8b0:4864:20::1142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A6E2A9;
	Sun,  4 Jun 2023 19:55:02 -0700 (PDT)
Received: by mail-yw1-x1142.google.com with SMTP id 00721157ae682-568928af8f5so65242317b3.1;
        Sun, 04 Jun 2023 19:55:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685933701; x=1688525701;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2IVNYUufQ9JCjk49iI258fSjZYigZQWdzvsQcVbQviE=;
        b=dV4piXu9PusE2f0xIH/vuYYIZdmUHuPOvQr2y4/6tZM/3HCW6JWkANpKLIamWlR+En
         QBAqp0fj1ylVJ9flBMXgLswL4Mba1+U8kXlIXVHKLX/RQGTc/bH8dPhsoQoXNu9hYnoK
         LXYNp1/JiP77RxyUi2sA4r5LmJ454in3rYb1kcH4rx31l85gOul/8oXTc2yN/7TLPGc7
         w2cBC99uUg7+ZeA2MECeBp7Us+A9ag/H2J+buTYBX2zUxn2tgOrMJ+AALc9pDxZqD8xY
         yqJ8cIMGJZ1YkIls9DlAWl40+NsnRKJo72aF6tpXNEnVewqP4ToM6YMs7YADGn+nznFL
         o/4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685933701; x=1688525701;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2IVNYUufQ9JCjk49iI258fSjZYigZQWdzvsQcVbQviE=;
        b=Z1A5LXKYAyaa1CMatC0mOlcCxkZ8Zuwn0k/4joLghz5xOGdJypgLP4QEyz0zMObRlG
         NRzGJJvyfdsnN4EyFwOC3YCB9xNncz7g6Jw51EyS0JPjjQ3HaYpcItbRyO6Irpd9Kt1A
         yrHjycyVtsa1mUGKJmnDVpk9x7AR5fz+VipE3dQwjjZ7mjvfAuEEYLSJfmmCJh/j+ohE
         gogo0BBvtzyDKuoZUf6itsr1CGuTArX4hxLSzZZutlu5XxVXEP6+0JIDrJhTH1u5l0xa
         /uQPPhF4/dHB4cQLB0c3U1+yWrnhzSwLlXCyeCWeR9PtqfwOMdbAyw/YupFuHOOrySDI
         FJlw==
X-Gm-Message-State: AC+VfDyLbiy0WKTc8VS1IKq8Wsqyhw0oYU1fFxlOfEYzBK7C7PtOMlQB
	l4FYvhEd0Anl2eB+66KNMbnWJeUNUR/UFyElvfQ=
X-Google-Smtp-Source: ACHHUZ6zEr+Ej5npCdWeeKOW11wHgcDU72TKKo9FL4I1iy8UiIFdkMZ8gslHsEFdQ23W6OqOiH84NCNySnDIMcqoCzI=
X-Received: by 2002:a0d:ea45:0:b0:561:9bcc:6c81 with SMTP id
 t66-20020a0dea45000000b005619bcc6c81mr6969492ywe.24.1685933701633; Sun, 04
 Jun 2023 19:55:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230602065958.2869555-1-imagedong@tencent.com>
 <20230602065958.2869555-2-imagedong@tencent.com> <ZHtKl8UE3AmJ3OpH@corigine.com>
In-Reply-To: <ZHtKl8UE3AmJ3OpH@corigine.com>
From: Menglong Dong <menglong8.dong@gmail.com>
Date: Mon, 5 Jun 2023 10:54:50 +0800
Message-ID: <CADxym3ZKi2WV=FBCzU+DrSmtbPC36BZKCs1=_QHXfCbapgU30w@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 1/5] bpf: make MAX_BPF_FUNC_ARGS 14
To: Simon Horman <simon.horman@corigine.com>
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

On Sat, Jun 3, 2023 at 10:13=E2=80=AFPM Simon Horman <simon.horman@corigine=
.com> wrote:
>
> On Fri, Jun 02, 2023 at 02:59:54PM +0800, menglong8.dong@gmail.com wrote:
> > From: Menglong Dong <imagedong@tencent.com>
> >
> > According to the current kernel version, below is a statistics of the
> > function arguments count:
> >
> > argument count | FUNC_PROTO count
> > 7              | 367
> > 8              | 196
> > 9              | 71
> > 10             | 43
> > 11             | 22
> > 12             | 10
> > 13             | 15
> > 14             | 4
> > 15             | 0
> > 16             | 1
> >
> > It's hard to statisics the function count, so I use FUNC_PROTO in the b=
tf
> > of vmlinux instead. The function with 16 arguments is ZSTD_buildCTable(=
),
> > which I think can be ignored.
> >
> > Therefore, let's make the maximum of function arguments count 14. It us=
ed
> > to be 12, but it seems that there is no harm to make it big enough.
> >
> > Reviewed-by: Jiang Biao <benbjiang@tencent.com>
> > Signed-off-by: Menglong Dong <imagedong@tencent.com>
> > ---
> >  include/linux/bpf.h | 9 +++++----
> >  1 file changed, 5 insertions(+), 4 deletions(-)
> >
> > diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> > index f58895830ada..8b997779faf7 100644
> > --- a/include/linux/bpf.h
> > +++ b/include/linux/bpf.h
> > @@ -961,10 +961,10 @@ enum bpf_cgroup_storage_type {
> >
> >  #define MAX_BPF_CGROUP_STORAGE_TYPE __BPF_CGROUP_STORAGE_MAX
> >
> > -/* The longest tracepoint has 12 args.
> > - * See include/trace/bpf_probe.h
> > +/* The maximun number of the kernel function arguments.
>
> Hi Menglong Dong,
>
> as it looks like there will be a v3 anyway, please
> consider correcting the spelling of maximum.
>

According to the advice of Alexei Starovoitov, it seems
we don't need to modify it here anymore. Anyway,
Thank you for reminding me of this spelling mistake :)

> ...


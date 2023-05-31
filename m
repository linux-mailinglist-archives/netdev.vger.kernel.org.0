Return-Path: <netdev+bounces-6669-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BC0D1717631
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 07:30:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C7FFD281346
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 05:30:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE6F22113;
	Wed, 31 May 2023 05:30:44 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C086120F3;
	Wed, 31 May 2023 05:30:44 +0000 (UTC)
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D47EB185;
	Tue, 30 May 2023 22:30:37 -0700 (PDT)
Received: by mail-lj1-x22e.google.com with SMTP id 38308e7fff4ca-2af2451b3f1so57932721fa.2;
        Tue, 30 May 2023 22:30:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685511036; x=1688103036;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mimGVtxLE7vqxai4nDb2ohdrBI+gPPYDUXqmgm8ndBU=;
        b=lV/eo88GcFoqMuG6kFVoYvMPP/yuWfVQ5BCaMyJAnn7D8dd0ao/J4vFEopYvFNL36J
         g1NbK1slo9sAX8JYfqFfBHgplWUR8HRunJlcpbRmjY22iErzO4SBuZoWti9Y/8/5PZ6C
         c6QMSLyighpaRqHif7u0V7WhSJusI1V/HOIMuTe8bdTCCEtJE+dtf7ugHRzp0TveGRck
         jFyUXvyjwE20eoUzHGUUWwTUbe9bUOKRdf9gzuTbk7rHwCpNi9H3Yg6/76D++zcsBB0F
         Ed/D0BC7CCx0QkomNCD4bZKUVNWF4CAye8YP6rh4SX05gMgIUCgF1/9lsgot1Zs8L3Wx
         uBbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685511036; x=1688103036;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mimGVtxLE7vqxai4nDb2ohdrBI+gPPYDUXqmgm8ndBU=;
        b=dKfvGm41ljTE4jdrOMwZYB09lM47UMkaLsPuEfpnqfmPK0/RJPp1nC97y4zpbQ/BB+
         +CJQpzJ0TCbV+UULfAGi+PSmVKG63jJt5Vcmmyqc8vXwVX9xqFxyK0tLXmDVxwPxJgF+
         hbCBnTE22W6ajMg1dHJkF6TIMn1pUTYkNdXpj9+Ei/hNVAB870AJwRtiXN+NTEwTg+84
         38B6aZRDr4JjrGCeI6xi7eifAT0XziYHCN/urux+doESMR1TTzp0EXArlEspKrbUdhbV
         WnhzrIJicvixEi701m9yLyIR577WJbmPcMvQRwhg4qp2ivBebqFoEPaIG8WK0UXISmnd
         8jtA==
X-Gm-Message-State: AC+VfDwimh8nDH0ZXqldv5S2PsklZ5vCIypR47NJqAqloCbGI/XcLaNb
	vtvgjxNYmOSiY9DB4zfvDjcpnxpehp9QwExQM3G4p0N/DQw=
X-Google-Smtp-Source: ACHHUZ7Gdj/kSjhNmjgyUDMdbH8mQKg49lircbw2Y3c2T7K9JvUZuNFObzpSqiH5NuvyxseYBKRz1lbdoO5AN41WRJk=
X-Received: by 2002:a2e:a0c6:0:b0:2af:309b:5a40 with SMTP id
 f6-20020a2ea0c6000000b002af309b5a40mr2099459ljm.12.1685511035763; Tue, 30 May
 2023 22:30:35 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230530070610.600063-1-starmiku1207184332@gmail.com> <4f37f760-048b-9d54-14ae-d1f979898625@meta.com>
In-Reply-To: <4f37f760-048b-9d54-14ae-d1f979898625@meta.com>
From: Teng Qi <starmiku1207184332@gmail.com>
Date: Wed, 31 May 2023 13:30:23 +0800
Message-ID: <CALyQVaxuONP8WXSVGhT2ih12ae0FwE3C+A1s4O7LArTHERmAxg@mail.gmail.com>
Subject: Re: [PATCH v2] kernel: bpf: syscall: fix a possible sleep-in-atomic
 bug in __bpf_prog_put()
To: Yonghong Song <yhs@meta.com>
Cc: ast@kernel.org, daniel@iogearbox.net, john.fastabend@gmail.com, 
	andrii@kernel.org, martin.lau@linux.dev, song@kernel.org, yhs@fb.com, 
	kpsingh@kernel.org, sdf@google.com, haoluo@google.com, jolsa@kernel.org, 
	davem@davemloft.net, kuba@kernel.org, hawk@kernel.org, bpf@vger.kernel.org, 
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
	FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

> I would really like you to create a test case
> to demonstrate with a rcu or spin-lock warnings based on existing code
> base. With a test case, it would hard to see whether we need this
> patch or not.

Ok, I will try to construct a test case.

> Please put 'Fixes' right before 'Signed-off-by' in the above.

Ok.

> Could we have cases where in software context we have irqs_disabled()?

What do you mean about software context?

On Wed, May 31, 2023 at 1:46=E2=80=AFAM Yonghong Song <yhs@meta.com> wrote:
>
>
>
> On 5/30/23 12:06 AM, starmiku1207184332@gmail.com wrote:
> > From: Teng Qi <starmiku1207184332@gmail.com>
> >
> > __bpf_prog_put() indirectly calls kvfree() through bpf_prog_put_deferre=
d()
> > which is unsafe under atomic context. The current
> > condition =E2=80=98in_irq() || irqs_disabled()=E2=80=99 in __bpf_prog_p=
ut() to ensure safety
> > does not cover cases involving the spin lock region and rcu read lock r=
egion.
> > Since __bpf_prog_put() is called by various callers in kernel/, net/ an=
d
> > drivers/, and potentially more in future, it is necessary to handle tho=
se
> > cases as well.
> >
> > Although we haven`t found a proper way to identify the rcu read lock re=
gion,
> > we have noticed that vfree() calls vfree_atomic() with the
> > condition 'in_interrupt()' to ensure safety.
>
> I would really like you to create a test case
> to demonstrate with a rcu or spin-lock warnings based on existing code
> base. With a test case, it would hard to see whether we need this
> patch or not.
>
> >
> > To make __bpf_prog_put() safe in practice, we propose calling
> > bpf_prog_put_deferred() with the condition 'in_interrupt()' and
> > using the work queue for any other context.
> >
> > We also added a comment to indicate that the safety of  __bpf_prog_put(=
)
> > relies implicitly on the implementation of vfree().
> >
> > Signed-off-by: Teng Qi <starmiku1207184332@gmail.com>
> > ---
> > v2:
> > remove comments because of self explanatory of code.
> >
> > Fixes: d809e134be7a ("bpf: Prepare bpf_prog_put() to be called from irq=
 context.")
>
> Please put 'Fixes' right before 'Signed-off-by' in the above.
>
> > ---
> >   kernel/bpf/syscall.c | 2 +-
> >   1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
> > index 14f39c1e573e..96658e5874be 100644
> > --- a/kernel/bpf/syscall.c
> > +++ b/kernel/bpf/syscall.c
> > @@ -2099,7 +2099,7 @@ static void __bpf_prog_put(struct bpf_prog *prog)
> >       struct bpf_prog_aux *aux =3D prog->aux;
> >
> >       if (atomic64_dec_and_test(&aux->refcnt)) {
> > -             if (in_irq() || irqs_disabled()) {
> > +             if (!in_interrupt()) {
>
> Could we have cases where in software context we have irqs_disabled()?
>
> >                       INIT_WORK(&aux->work, bpf_prog_put_deferred);
> >                       schedule_work(&aux->work);
> >               } else {


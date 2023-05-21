Return-Path: <netdev+bounces-4107-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B60EF70AE4F
	for <lists+netdev@lfdr.de>; Sun, 21 May 2023 16:19:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C8B8F280E38
	for <lists+netdev@lfdr.de>; Sun, 21 May 2023 14:19:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A2BA946AB;
	Sun, 21 May 2023 14:19:49 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 843B5259A;
	Sun, 21 May 2023 14:19:49 +0000 (UTC)
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16F49BE;
	Sun, 21 May 2023 07:19:48 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id 4fb4d7f45d1cf-510d8ead2f1so7163501a12.3;
        Sun, 21 May 2023 07:19:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684678786; x=1687270786;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=g7nc8IQP1+x6u9N7+EYfITX13eAIkcVj3K/FpgMBq4Y=;
        b=hMI+YQvgIwZ0nFTrph18YPJAPJ/xqRvgbwDk0QNL7DpOR3z2xwQQZ09Y5ZB6aKwQ1N
         vAgB18wD4Uz/K3EB1WkMeoAAQj9DLgB56nJjPbLccvgfFoiQI74WddeHk+E7C8SRYSYL
         HrpQLEY5WuXmBoxwAPjftuOppi/LU8kC/KLqRKQJB6t4mwXSTDzGCa2Z9HHBVeihFInM
         +j+n2WojQy5OP7ATXwgbIfOAdr8sCKWQNah5J28W/WJwcBBQ+MvXxi6K+vUpN5+DCuKe
         CWg64ghMVjzIgCBe5FnaHQziqCCEr23LlqmF/i8RfrDYQrd5B/cL7jrk1CAmHsXdoFvc
         681A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684678786; x=1687270786;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=g7nc8IQP1+x6u9N7+EYfITX13eAIkcVj3K/FpgMBq4Y=;
        b=SFn5N4Zxm4F1FlfFFlNPK7n2xD4j56CUwEgjU5Yedq16qYyXoOyMqrpOdCQ6usMGcX
         q3SaCqkRbADGozd/zb34GjJnx0lU8mkr9v4GnFOOmEDh2gmFXlrcL4v1l35ZdCrlRViv
         rjRfXtrFtGD/kxnUgzXV0HXNl2+1o2S76TA1VwYwzcF09Q+br0mxmTk6t2R2vHfgBlS4
         5FTuW+8rXYyLJ93+r3vThzycC9sQ4xOvoiffxg5icHWUuSvgKk2WSdB4UmkxeMJ31OaZ
         PKs696XuY4fwCtKeJVZ6nxS9lb6rE2wIAYBGOCZ/B4i4vM2s6WW4rexSc/qYwRijVnLe
         EsXg==
X-Gm-Message-State: AC+VfDy+NxOJGF7mQ9HyZWIJOYKFT1fEaw0gOgfdEGvTed7FmLS67RxW
	rBQm2GQhCD1Y9GTDDWVHhxB18Pwy3w71aW37v1k=
X-Google-Smtp-Source: ACHHUZ4BVlr3vRVhKVcq01bQhG1RUX5SPWxkcsAY6aiBTMuFu3CQVjxEKjSI3NraOjSXw4ScmEjdwc7YjUWWZs4ifb0=
X-Received: by 2002:a05:6402:1217:b0:50b:faa1:e1d5 with SMTP id
 c23-20020a056402121700b0050bfaa1e1d5mr5627068edw.39.1684678786185; Sun, 21
 May 2023 07:19:46 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20220515203653.4039075-1-jolsa@kernel.org> <20230520094722.5393-1-zegao@tencent.com>
 <ZGnRjkjxWrK8HzNm@krava> <20230521190907.e4104a653583dfac785e379a@kernel.org>
In-Reply-To: <20230521190907.e4104a653583dfac785e379a@kernel.org>
From: Ze Gao <zegao2021@gmail.com>
Date: Sun, 21 May 2023 22:19:34 +0800
Message-ID: <CAD8CoPCNNh4_vtTQVGeoN7t7TcN9w60Fw6=r7yKwvxBSr_ZJ3Q@mail.gmail.com>
Subject: Re:
To: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Jiri Olsa <olsajiri@gmail.com>, Alexei Starovoitov <ast@kernel.org>, 
	Andrii Nakryiko <andrii@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Hao Luo <haoluo@google.com>, 
	John Fastabend <john.fastabend@gmail.com>, KP Singh <kpsingh@kernel.org>, 
	Martin KaFai Lau <martin.lau@linux.dev>, Song Liu <song@kernel.org>, 
	Stanislav Fomichev <sdf@google.com>, Steven Rostedt <rostedt@goodmis.org>, Yonghong Song <yhs@fb.com>, bpf@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
	kafai@fb.com, kpsingh@chromium.org, netdev@vger.kernel.org, 
	paulmck@kernel.org, songliubraving@fb.com, Ze Gao <zegao@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
	FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Sun, May 21, 2023 at 6:09=E2=80=AFPM Masami Hiramatsu <mhiramat@kernel.o=
rg> wrote:
>
> On Sun, 21 May 2023 10:08:46 +0200
> Jiri Olsa <olsajiri@gmail.com> wrote:
>
> > On Sat, May 20, 2023 at 05:47:24PM +0800, Ze Gao wrote:
> > >
> > > Hi Jiri,
> > >
> > > Would you like to consider to add rcu_is_watching check in
> > > to solve this from the viewpoint of kprobe_multi_link_prog_run
> >
> > I think this was discussed in here:
> >   https://lore.kernel.org/bpf/20230321020103.13494-1-laoar.shao@gmail.c=
om/
> >
> > and was considered a bug, there's fix mentioned later in the thread
> >
> > there's also this recent patchset:
> >   https://lore.kernel.org/bpf/20230517034510.15639-3-zegao@tencent.com/
> >
> > that solves related problems
>
> I think this rcu_is_watching() is a bit different issue. This rcu_is_watc=
hing()
> check is required if the kprobe_multi_link_prog_run() uses any RCU API.
> E.g. rethook_try_get() is also checks rcu_is_watching() because it uses
> call_rcu().

Yes, that's my point!

Regards,
Ze

>
> >
> > > itself? And accounting of missed runs can be added as well
> > > to imporve observability.
> >
> > right, we count fprobe->nmissed but it's not exposed, we should allow
> > to get 'missed' stats from both fprobe and kprobe_multi later, which
> > is missing now, will check
> >
> > thanks,
> > jirka
> >
> > >
> > > Regards,
> > > Ze
> > >
> > >
> > > -----------------
> > > From 29fd3cd713e65461325c2703cf5246a6fae5d4fe Mon Sep 17 00:00:00 200=
1
> > > From: Ze Gao <zegao@tencent.com>
> > > Date: Sat, 20 May 2023 17:32:05 +0800
> > > Subject: [PATCH] bpf: kprobe_multi runs bpf progs only when rcu_is_wa=
tching
> > >
> > > From the perspective of kprobe_multi_link_prog_run, any traceable
> > > functions can be attached while bpf progs need specical care and
> > > ought to be under rcu protection. To solve the likely rcu lockdep
> > > warns once for good, when (future) functions in idle path were
> > > attached accidentally, we better paying some cost to check at least
> > > in kernel-side, and return when rcu is not watching, which helps
> > > to avoid any unpredictable results.
> > >
> > > Signed-off-by: Ze Gao <zegao@tencent.com>
> > > ---
> > >  kernel/trace/bpf_trace.c | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > >
> > > diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
> > > index 9a050e36dc6c..3e6ea7274765 100644
> > > --- a/kernel/trace/bpf_trace.c
> > > +++ b/kernel/trace/bpf_trace.c
> > > @@ -2622,7 +2622,7 @@ kprobe_multi_link_prog_run(struct bpf_kprobe_mu=
lti_link *link,
> > >     struct bpf_run_ctx *old_run_ctx;
> > >     int err;
> > >
> > > -   if (unlikely(__this_cpu_inc_return(bpf_prog_active) !=3D 1)) {
> > > +   if (unlikely(__this_cpu_inc_return(bpf_prog_active) !=3D 1 || !rc=
u_is_watching())) {
> > >             err =3D 0;
> > >             goto out;
> > >     }
> > > --
> > > 2.40.1
> > >
>
>
> --
> Masami Hiramatsu (Google) <mhiramat@kernel.org>


Return-Path: <netdev+bounces-4852-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 55C5670EC21
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 05:52:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 860832811A5
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 03:52:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C245215B6;
	Wed, 24 May 2023 03:52:13 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB68BEC2;
	Wed, 24 May 2023 03:52:13 +0000 (UTC)
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FC13C1;
	Tue, 23 May 2023 20:52:12 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id 4fb4d7f45d1cf-510ea8d0bb5so948158a12.0;
        Tue, 23 May 2023 20:52:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684900330; x=1687492330;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PIplVH84mQzYA92Hw7xyqoi7EjdVHd4BsS3gkqLQQZk=;
        b=TBfSbXLJmCCNrWLz0DQ3lWQZTgzmLHDVqbff5CzHHTeayTSAofA0cIRgRSTzP5t8xM
         r0mDziKrlLeyb0G0ILOj6BmWCzNUImSkR3LPI6ylI7Y36SaHhr5VQnOZzgyqZrqaxq6d
         i/StgdEy4BNKyaHWQL89/YIhZuyK8DtwHnfoKVoj8FEGbGTn67ffjUA/BIiUge9xiduJ
         ZgKUub24uTk3bO5IyWCooJjv3tthXMZv2cfo20ZOZtxFXX+dYvS1nX8mierZNLuNlf5x
         3lv2spmlOoDVkvnUbVXlevqhK4vmJPSRODPGmByXtwDykUx33aRuIcUj8kp5et6mN8Gj
         hPEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684900330; x=1687492330;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PIplVH84mQzYA92Hw7xyqoi7EjdVHd4BsS3gkqLQQZk=;
        b=IkucrMOgfXfuvQAJARTtZzsIw/1q2B8WzwekuqIS5iSzye9Gb3+4HWNpxOZ4y6zQX/
         ttldwsjtccqBi8XFPOrhLITY9ySoulzgMmbji2dfQWPRazp90uY5TFYjVug2zajrp55w
         Tq7q8LHl+XJVT2Zw3yYrSzyX3ZhCmjKdiaEKV9Dvfapn7mXR8USvIyMSXpkd8ugGXfha
         42GkXgVHMBE0h+FSkkF3Wu2BNIA+0smJ/0jd/kqNrs/FkP9HYiySiv3hv/Zzle1AjbqH
         kgUIlJIWLGZ0EAKrhsHlE7mNk4MJcbdR0mosbsWwGlB1F99bbhvf8NAgGJfaC9F6HbBS
         EHLw==
X-Gm-Message-State: AC+VfDyeW43fZjgMi8g9pVfjw0RbWD0lbHjpfgBNtcIejJE5dsRpY1Ql
	xCl1WAP0TnsdXJGkMJMnmABzzN2qJCo/FSMiH0M=
X-Google-Smtp-Source: ACHHUZ6o2RJCD20bEVdQypVWzIEQEchtzyPWUv7LpdCIUlnwbBJvIbiQgM+DVQFKu7YuYOi5+Fgc15NV6gQiWSBwTzk=
X-Received: by 2002:aa7:dd10:0:b0:510:a5a1:b36d with SMTP id
 i16-20020aa7dd10000000b00510a5a1b36dmr901501edv.33.1684900330454; Tue, 23 May
 2023 20:52:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20220515203653.4039075-1-jolsa@kernel.org> <20230520094722.5393-1-zegao@tencent.com>
 <b4f66729-90ab-080a-51ec-bf435ad6199d@meta.com> <CAD8CoPAXse1GKAb15O5tZJwBqMt1N_btH+qRe7c_a-ryUMjx7A@mail.gmail.com>
 <ZGp+fW855gmWuh9W@krava> <CAD8CoPDASe7hpkFbK+UzJats7j4sbgsCh_P4zaQYVuKD7jWu2w@mail.gmail.com>
 <20230523101041.23ca7cc8@rorschach.local.home>
In-Reply-To: <20230523101041.23ca7cc8@rorschach.local.home>
From: Ze Gao <zegao2021@gmail.com>
Date: Wed, 24 May 2023 11:51:58 +0800
Message-ID: <CAD8CoPCHnTMOzqxJT+9Bg7aP=y8Jt4VUV1=xpBopNZv7VkBU8w@mail.gmail.com>
Subject: Re: kprobes and rcu_is_watching()
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Jiri Olsa <olsajiri@gmail.com>, Yonghong Song <yhs@meta.com>, 
	Alexei Starovoitov <ast@kernel.org>, Andrii Nakryiko <andrii@kernel.org>, 
	Daniel Borkmann <daniel@iogearbox.net>, Hao Luo <haoluo@google.com>, 
	John Fastabend <john.fastabend@gmail.com>, KP Singh <kpsingh@kernel.org>, 
	Martin KaFai Lau <martin.lau@linux.dev>, Masami Hiramatsu <mhiramat@kernel.org>, Song Liu <song@kernel.org>, 
	Stanislav Fomichev <sdf@google.com>, Yonghong Song <yhs@fb.com>, bpf@vger.kernel.org, 
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

Thanks Steven, I think we've come to a consensus on this.

The question here is whether bpf tracing fentry i.e.,
__bpf_prog_enter{_sleepable}
needs to check rcu_is_watching as well before using rcu related
calls. And Yonghong suggested making a change when there is
indeed some bad case occurring since it's rare the tracee is in the idle pa=
th.


Regards,
Ze

On Tue, May 23, 2023 at 10:10=E2=80=AFPM Steven Rostedt <rostedt@goodmis.or=
g> wrote:
>
> [ Added a subject, as I always want to delete these emails as spam! ]
>
> On Mon, 22 May 2023 10:07:42 +0800
> Ze Gao <zegao2021@gmail.com> wrote:
>
> > Oops, I missed that. Thanks for pointing that out, which I thought is
> > conditional use of rcu_is_watching before.
> >
> > One last point, I think we should double check on this
> >      "fentry does not filter with !rcu_is_watching"
> > as quoted from Yonghong and argue whether it needs
> > the same check for fentry as well.
> >
>
> Note that trace_test_and_set_recursion() (which is used by
> ftrace_test_recursion_trylock()) checks for rcu_is_watching() and
> returns false if it isn't (and the trylock will fail).
>
> -- Steve


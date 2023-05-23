Return-Path: <netdev+bounces-4690-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 35DEF70DECA
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 16:10:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B7C381C20D76
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 14:10:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 48AFF1F176;
	Tue, 23 May 2023 14:10:47 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F14831EA9E;
	Tue, 23 May 2023 14:10:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 095CFC433D2;
	Tue, 23 May 2023 14:10:42 +0000 (UTC)
Date: Tue, 23 May 2023 10:10:41 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Ze Gao <zegao2021@gmail.com>
Cc: Jiri Olsa <olsajiri@gmail.com>, Yonghong Song <yhs@meta.com>, Alexei
 Starovoitov <ast@kernel.org>, Andrii Nakryiko <andrii@kernel.org>, Daniel
 Borkmann <daniel@iogearbox.net>, Hao Luo <haoluo@google.com>, John
 Fastabend <john.fastabend@gmail.com>, KP Singh <kpsingh@kernel.org>, Martin
 KaFai Lau <martin.lau@linux.dev>, Masami Hiramatsu <mhiramat@kernel.org>,
 Song Liu <song@kernel.org>, Stanislav Fomichev <sdf@google.com>, Yonghong
 Song <yhs@fb.com>, bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, kafai@fb.com, kpsingh@chromium.org,
 netdev@vger.kernel.org, paulmck@kernel.org, songliubraving@fb.com, Ze Gao
 <zegao@tencent.com>
Subject: Re: kprobes and rcu_is_watching()
Message-ID: <20230523101041.23ca7cc8@rorschach.local.home>
In-Reply-To: <CAD8CoPDASe7hpkFbK+UzJats7j4sbgsCh_P4zaQYVuKD7jWu2w@mail.gmail.com>
References: <20220515203653.4039075-1-jolsa@kernel.org>
	<20230520094722.5393-1-zegao@tencent.com>
	<b4f66729-90ab-080a-51ec-bf435ad6199d@meta.com>
	<CAD8CoPAXse1GKAb15O5tZJwBqMt1N_btH+qRe7c_a-ryUMjx7A@mail.gmail.com>
	<ZGp+fW855gmWuh9W@krava>
	<CAD8CoPDASe7hpkFbK+UzJats7j4sbgsCh_P4zaQYVuKD7jWu2w@mail.gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

[ Added a subject, as I always want to delete these emails as spam! ]

On Mon, 22 May 2023 10:07:42 +0800
Ze Gao <zegao2021@gmail.com> wrote:

> Oops, I missed that. Thanks for pointing that out, which I thought is
> conditional use of rcu_is_watching before.
> 
> One last point, I think we should double check on this
>      "fentry does not filter with !rcu_is_watching"
> as quoted from Yonghong and argue whether it needs
> the same check for fentry as well.
> 

Note that trace_test_and_set_recursion() (which is used by
ftrace_test_recursion_trylock()) checks for rcu_is_watching() and
returns false if it isn't (and the trylock will fail).

-- Steve


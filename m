Return-Path: <netdev+bounces-4532-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9666670D32F
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 07:30:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 653911C20C67
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 05:30:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8EF331B8FE;
	Tue, 23 May 2023 05:30:28 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C2171B8F1;
	Tue, 23 May 2023 05:30:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30185C433EF;
	Tue, 23 May 2023 05:30:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684819826;
	bh=rjc69szkCt6G0ExxvDAbrVBLWQIt7SwJLYPVYIPI4QU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=WG9yX0IdVLkpv7kkfjV7ZB9LeCtEx/3kz0Il1BuXlHMQzvp09tlbmWiaueL92Xwd6
	 VmyFVOWc4Nn9p1IHFwEqvLQ1F1COuXtVZ8lhO0LzUyCxhYM7RtEcvRGLSss0vpdL5C
	 gTs3Kk8t5o5JybPEqR1LFZOeVwsP/eUx67QDxp0+B49Ur4qbNGCj8LrWNqCRRtoowD
	 1xHIR7KvoNFPFZrrNb8XnvCXn+78Cs2/Egmf5TloucuLh3JcwgZ6Q4SGUVESZVepA+
	 zGPGoCQ2OipP9Sxghmh1fW2Vg/PkqQfYdsPZEPOLD3nmmTFxsmdEmb6SYop5WlwhE7
	 qxwurPTIq4ydg==
Date: Tue, 23 May 2023 13:30:19 +0800
From: Masami Hiramatsu (Google) <mhiramat@kernel.org>
To: Ze Gao <zegao2021@gmail.com>
Cc: Jiri Olsa <olsajiri@gmail.com>, Yonghong Song <yhs@meta.com>, Alexei
 Starovoitov <ast@kernel.org>, Andrii Nakryiko <andrii@kernel.org>, Daniel
 Borkmann <daniel@iogearbox.net>, Hao Luo <haoluo@google.com>, John
 Fastabend <john.fastabend@gmail.com>, KP Singh <kpsingh@kernel.org>, Martin
 KaFai Lau <martin.lau@linux.dev>, Masami Hiramatsu <mhiramat@kernel.org>,
 Song Liu <song@kernel.org>, Stanislav Fomichev <sdf@google.com>, Steven
 Rostedt <rostedt@goodmis.org>, Yonghong Song <yhs@fb.com>,
 bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, kafai@fb.com, kpsingh@chromium.org,
 netdev@vger.kernel.org, paulmck@kernel.org, songliubraving@fb.com, Ze Gao
 <zegao@tencent.com>
Subject: Re:
Message-Id: <20230523133019.ce19932f89585eb10d092896@kernel.org>
In-Reply-To: <CAD8CoPDASe7hpkFbK+UzJats7j4sbgsCh_P4zaQYVuKD7jWu2w@mail.gmail.com>
References: <20220515203653.4039075-1-jolsa@kernel.org>
	<20230520094722.5393-1-zegao@tencent.com>
	<b4f66729-90ab-080a-51ec-bf435ad6199d@meta.com>
	<CAD8CoPAXse1GKAb15O5tZJwBqMt1N_btH+qRe7c_a-ryUMjx7A@mail.gmail.com>
	<ZGp+fW855gmWuh9W@krava>
	<CAD8CoPDASe7hpkFbK+UzJats7j4sbgsCh_P4zaQYVuKD7jWu2w@mail.gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 22 May 2023 10:07:42 +0800
Ze Gao <zegao2021@gmail.com> wrote:

> Oops, I missed that. Thanks for pointing that out, which I thought is
> conditional use of rcu_is_watching before.
> 
> One last point, I think we should double check on this
>      "fentry does not filter with !rcu_is_watching"
> as quoted from Yonghong and argue whether it needs
> the same check for fentry as well.

rcu_is_watching() comment says;

 * if the current CPU is not in its idle loop or is in an interrupt or
 * NMI handler, return true.

Thus it returns *fault* if the current CPU is in the idle loop and not
any interrupt(including NMI) context. This means if any tracable function
is called from idle loop, it can be !rcu_is_watching(). I meant, this is
'context' based check, thus fentry can not filter out that some commonly
used functions is called from that context but it can be detected.

Thank you,

> 
> Regards,
> Ze


-- 
Masami Hiramatsu (Google) <mhiramat@kernel.org>


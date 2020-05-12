Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C63B71CFA8B
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 18:25:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726890AbgELQZa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 12:25:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725851AbgELQZ3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 May 2020 12:25:29 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6840C061A0C;
        Tue, 12 May 2020 09:25:27 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id mq3so9762914pjb.1;
        Tue, 12 May 2020 09:25:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=DPxOZ8UjH31LQvxAk2NjnhSgje9QgY2TfNOk4kxHodY=;
        b=g867IP+doOPis7XDgIaBIFCe61VOt8WrrRWL5MxwylRlBclzQRAaNl7JrXdkxzdH0u
         Y9/1oPnv4VoB/xCQ2Z41IyChQylWimj0IwYBWblgIj045vNDOWe7EBlhXxPsjUop5jnV
         J1LVkaAJAZo3C2xTvUjIkypEGQlDE7se8cYuQKvJCbb8du7NOJ0Y3Mzrq+X6ZH+sZygo
         wh+bJN71jmit7GNe6WGW05nAj6BXhWXKJ3KHhades/w6agwoJ+2nQNCwepkIt0/TMNJY
         LIVxo4gxb01lplfXndykP7MJj24oLFX6h90qCsHDl2NuQ8p80j1CWnOINYKmXQcTHLxg
         2Kyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=DPxOZ8UjH31LQvxAk2NjnhSgje9QgY2TfNOk4kxHodY=;
        b=HicwcN9I9X56WjWnTQkjCLCzJbrdd7RI8fyg84+pVfKWzwd4KJJNlHEfg6ylt/XiZX
         OFIKmBtxj/0FhF3BGonsoTEqGR635fnURoHvimxeRymS/w9OWDGrNP5xCdzH74THJ5qv
         WQXEcxNYdGUf2x9m2ZZOhx4Br/BX15RgZtTP6V8mZ01N6/m9vw2C9J1xJApefpqBXnbB
         ySHkZ/cTojChVBJYCvpTZdT5dCFRVf1UV5P35wonK9SUXtGQuVS82zKAt2rwpxqcV6xs
         dYRpcK3OIB4e/9ztCY5GQie2aU4lhKFiWzX0SfLj5J5wje+D6YEivGNUYoceKtWr2J9N
         Kx4w==
X-Gm-Message-State: AGi0Pua3nJRx0DD1QwO1QCC/hvNi7DT/NOWgNJziFb052ZSUXAuk/TVK
        wNIV52gSkVLzVAFrLaH8hWM=
X-Google-Smtp-Source: APiQypLzF4otgBqsmJps32AYusoK9adG6QS1Ufo3dXDXrfVbgYQ8nLpciunGyy0LmT/KajHzj5iYDQ==
X-Received: by 2002:a17:90a:5289:: with SMTP id w9mr28134860pjh.97.1589300727330;
        Tue, 12 May 2020 09:25:27 -0700 (PDT)
Received: from ast-mbp ([2620:10d:c090:400::5:c3f6])
        by smtp.gmail.com with ESMTPSA id c10sm12290836pfm.50.2020.05.12.09.25.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 May 2020 09:25:26 -0700 (PDT)
Date:   Tue, 12 May 2020 09:25:24 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Yonghong Song <yhs@fb.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf@vger.kernel.org,
        Martin KaFai Lau <kafai@fb.com>, netdev@vger.kernel.org,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>, kernel-team@fb.com
Subject: Re: [PATCH bpf-next v4 02/21] bpf: allow loading of a bpf_iter
 program
Message-ID: <20200512162524.4yq4i3or4wtwl43x@ast-mbp>
References: <20200509175859.2474608-1-yhs@fb.com>
 <20200509175900.2474947-1-yhs@fb.com>
 <20200510004139.tjlll6wqq7zevb73@ast-mbp>
 <c128a30f-af40-99c9-706e-4afe268ed38f@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c128a30f-af40-99c9-706e-4afe268ed38f@fb.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 12, 2020 at 08:41:19AM -0700, Yonghong Song wrote:
> 
> 
> On 5/9/20 5:41 PM, Alexei Starovoitov wrote:
> > On Sat, May 09, 2020 at 10:59:00AM -0700, Yonghong Song wrote:
> > > diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> > > index 70ad009577f8..d725ff7d11db 100644
> > > --- a/kernel/bpf/verifier.c
> > > +++ b/kernel/bpf/verifier.c
> > > @@ -7101,6 +7101,10 @@ static int check_return_code(struct bpf_verifier_env *env)
> > >   			return 0;
> > >   		range = tnum_const(0);
> > >   		break;
> > > +	case BPF_PROG_TYPE_TRACING:
> > > +		if (env->prog->expected_attach_type != BPF_TRACE_ITER)
> > > +			return 0;
> > > +		break;
> > 
> > Not related to this set, but I just noticed that I managed to forget to
> > add this check for fentry/fexit/freplace.
> > While it's not too late let's enforce return 0 for them ?
> > Could you follow up with a patch for bpf tree?
> 
> Just want to double check. In selftests, we have
> 
> SEC("fentry/__set_task_comm")
> int BPF_PROG(prog4, struct task_struct *tsk, const char *buf, bool exec)
> {
>         return !tsk;
> }
> 
> SEC("fexit/__set_task_comm")
> int BPF_PROG(prog5, struct task_struct *tsk, const char *buf, bool exec)
> {
>         return !tsk;
> }
> 
> fentry/fexit may returrn 1. What is the intention here? Does this mean
> we should allow [0, 1] instead of [0, 0]?

Argh. I missed that bit when commit ac065870d9282 tweaked the return
value. For fentry/exit the return value is ignored by trampoline.
imo it's misleading to users and should be rejected by the verifier.
so [0,0] for fentry/fexit

> For freplace, we have
> 
> __u64 test_get_skb_len = 0;
> SEC("freplace/get_skb_len")
> int new_get_skb_len(struct __sk_buff *skb)
> {
>         int len = skb->len;
> 
>         if (len != 74)
>                 return 0;
>         test_get_skb_len = 1;
>         return 74; /* original get_skb_len() returns skb->len */
> }
> 
> That means freplace may return arbitrary values depending on what
> to replace?

yes. freplace and fmod_ret can return anything.

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A4ED486179
	for <lists+netdev@lfdr.de>; Thu,  6 Jan 2022 09:31:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236719AbiAFIbq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 03:31:46 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:53304 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236650AbiAFIbp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jan 2022 03:31:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1641457905;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=iD73kWNijA1U4uWtuCWW0P+JxmH4hSDMGlp1iBsoK5c=;
        b=eSjxYFkUVWVjwqzsAmnBuVW8yG1e0f75R70ckuGbXSfMlnHt7z8DszRN5ODwEksrpKzScS
        BBeweHsQnZtxnbNFkqQSePEClTHGT03IyCxJC72vLk04M7QEIjwrTWoroXXad3/a7Ah+0U
        gaZUQyCK3gZuagAq2quGcZ8eowU/cpM=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-218-jMwWhDbZPMKtwJgIojRVGw-1; Thu, 06 Jan 2022 03:31:44 -0500
X-MC-Unique: jMwWhDbZPMKtwJgIojRVGw-1
Received: by mail-wm1-f71.google.com with SMTP id a68-20020a1c9847000000b00346939a2d7cso680736wme.1
        for <netdev@vger.kernel.org>; Thu, 06 Jan 2022 00:31:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=iD73kWNijA1U4uWtuCWW0P+JxmH4hSDMGlp1iBsoK5c=;
        b=n8i4+/GLKzYnIqi3qtMVt02lfr+k2K+4RXCpoDBvgr0inpPha7GiJhi/IfIucfS0AX
         ucefmLEGzYuVEcZoAoGXOKnDbIzYJ497WqfjwfZnW2syg9W4dsXW9hEyB+RR/yHZ6h2S
         7iW6iyIIUJwIg7GAUehJCPkoG79kdgzR/BMe1uaWrrQZdX0Mc9zck/YBeCEed8KqmCZA
         CE+xYY4fbqUmbxoHz9VZ8I4aQIUChIg6KUtS6/JYVO75kwUNPhsKW/FdbcZ13ABPjWI9
         dehWlStcl5bCqAP106vJRotWPuDKCys3q/L2rn+f0ylScMiXYf7FrLe61moMHqHU6pnq
         aN5Q==
X-Gm-Message-State: AOAM5328gdkqttfluc0y7QHvtjYDNxp9/ebSrASR7nxErBDxRoyFPtXc
        vHUX8rsvNlA4uVKheOTZSJyN0qmMsQkzwjWFv0b4+q++LNZwLx1Eve2/x6FgCq/5DA0x4TetWNa
        vr5zmpm1d3bFawSBU
X-Received: by 2002:adf:f24e:: with SMTP id b14mr49092642wrp.612.1641457902852;
        Thu, 06 Jan 2022 00:31:42 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyenm8i9TvSQ1ak4sztO2YCOXtuNWaef/xxLjvTDwVneO0lGa1kAWmVlbRDNshxtQOXDKlWKg==
X-Received: by 2002:adf:f24e:: with SMTP id b14mr49092617wrp.612.1641457902678;
        Thu, 06 Jan 2022 00:31:42 -0800 (PST)
Received: from krava (nat-pool-brq-u.redhat.com. [213.175.37.12])
        by smtp.gmail.com with ESMTPSA id l6sm1843686wry.18.2022.01.06.00.31.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Jan 2022 00:31:42 -0800 (PST)
Date:   Thu, 6 Jan 2022 09:31:40 +0100
From:   Jiri Olsa <jolsa@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Naveen N. Rao" <naveen.n.rao@linux.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 02/13] kprobe: Keep traced function address
Message-ID: <Ydao7Cj6EyNtOys6@krava>
References: <20220104080943.113249-1-jolsa@kernel.org>
 <20220104080943.113249-3-jolsa@kernel.org>
 <CAEf4BzYMF=zNNF-T3fmpXWx3ozek2nb3ektteBwVE=sjw8BE4g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzYMF=zNNF-T3fmpXWx3ozek2nb3ektteBwVE=sjw8BE4g@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 05, 2022 at 08:30:48PM -0800, Andrii Nakryiko wrote:
> On Tue, Jan 4, 2022 at 12:10 AM Jiri Olsa <jolsa@redhat.com> wrote:
> >
> > The bpf_get_func_ip_kprobe helper should return traced function
> > address, but it's doing so only for kprobes that are placed on
> > the function entry.
> >
> > If kprobe is placed within the function, bpf_get_func_ip_kprobe
> > returns that address instead of function entry.
> >
> > Storing the function entry directly in kprobe object, so it could
> > be used in bpf_get_func_ip_kprobe helper.
> >
> > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > ---
> >  include/linux/kprobes.h                              |  3 +++
> >  kernel/kprobes.c                                     | 12 ++++++++++++
> >  kernel/trace/bpf_trace.c                             |  2 +-
> >  tools/testing/selftests/bpf/progs/get_func_ip_test.c |  4 ++--
> >  4 files changed, 18 insertions(+), 3 deletions(-)
> >
> > diff --git a/include/linux/kprobes.h b/include/linux/kprobes.h
> > index 8c8f7a4d93af..a204df4fef96 100644
> > --- a/include/linux/kprobes.h
> > +++ b/include/linux/kprobes.h
> > @@ -74,6 +74,9 @@ struct kprobe {
> >         /* Offset into the symbol */
> >         unsigned int offset;
> >
> > +       /* traced function address */
> > +       unsigned long func_addr;
> > +
> 
> keep in mind that we'll also need (maybe in a follow up series) to
> store bpf_cookie somewhere close to this func_addr as well. Just
> mentioning to keep in mind as you decide with Masami where to put it.

ok

SNIP

> > diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
> > index 21aa30644219..25631253084a 100644
> > --- a/kernel/trace/bpf_trace.c
> > +++ b/kernel/trace/bpf_trace.c
> > @@ -1026,7 +1026,7 @@ BPF_CALL_1(bpf_get_func_ip_kprobe, struct pt_regs *, regs)
> >  {
> >         struct kprobe *kp = kprobe_running();
> >
> > -       return kp ? (uintptr_t)kp->addr : 0;
> > +       return kp ? (uintptr_t)kp->func_addr : 0;
> >  }
> >
> >  static const struct bpf_func_proto bpf_get_func_ip_proto_kprobe = {
> > diff --git a/tools/testing/selftests/bpf/progs/get_func_ip_test.c b/tools/testing/selftests/bpf/progs/get_func_ip_test.c
> > index a587aeca5ae0..e988aefa567e 100644
> > --- a/tools/testing/selftests/bpf/progs/get_func_ip_test.c
> > +++ b/tools/testing/selftests/bpf/progs/get_func_ip_test.c
> > @@ -69,7 +69,7 @@ int test6(struct pt_regs *ctx)
> >  {
> >         __u64 addr = bpf_get_func_ip(ctx);
> >
> > -       test6_result = (const void *) addr == &bpf_fentry_test6 + 5;
> > +       test6_result = (const void *) addr == &bpf_fentry_test6;
> >         return 0;
> >  }
> >
> > @@ -79,6 +79,6 @@ int test7(struct pt_regs *ctx)
> >  {
> >         __u64 addr = bpf_get_func_ip(ctx);
> >
> > -       test7_result = (const void *) addr == &bpf_fentry_test7 + 5;
> > +       test7_result = (const void *) addr == &bpf_fentry_test7;
> 
> we can treat this as a bug fix for bpf_get_func_ip() for kprobes,
> right? I think "Fixes: " tag is in order then.

true, will add that in next version

thanks,
jirka


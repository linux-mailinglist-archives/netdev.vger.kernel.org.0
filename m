Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0F27486174
	for <lists+netdev@lfdr.de>; Thu,  6 Jan 2022 09:30:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236662AbiAFIaw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 03:30:52 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:31710 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236447AbiAFIav (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jan 2022 03:30:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1641457851;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=vjj+fSGy3AdmbQ9M5rrQ05B4+QRffIiePU4dNg++7jg=;
        b=AhEJK7vYPSnmgpvyiZ30wNIABLqe9VUIUMTqRizGGAimqMSdeuym14KdvUZ2deqJD4tPPW
        1kbQUjoMmW0rWMCBeQYwFrRmU7JAHBp3dXEZ+snvgfcIsRj+LN569GuRy1Qt8/71N8C7Vc
        0Cv9m1TJpIq9g8JmpYnHS1jayMe9iYM=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-220-1riGo_EmOt-q6d5RomrWbQ-1; Thu, 06 Jan 2022 03:30:50 -0500
X-MC-Unique: 1riGo_EmOt-q6d5RomrWbQ-1
Received: by mail-wr1-f69.google.com with SMTP id n4-20020adf8b04000000b001a49cff5283so901300wra.14
        for <netdev@vger.kernel.org>; Thu, 06 Jan 2022 00:30:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=vjj+fSGy3AdmbQ9M5rrQ05B4+QRffIiePU4dNg++7jg=;
        b=Uydht8SmcpAUoYFLNXfEi9KFCdSnMx1pp+vdwCyqSQIPjRlxdeR9Z+Qdp7ucIdTOus
         sv5No0S/OzJcvob1sYJ2LZq0lJT+91ioO2DJYrt7EHf7rJ3JsutBIz0QDT5BJCK3FM6D
         9WTecwjQT7ec7s63+BTBLX/ymkDdVFTkME5OTuf9tgYT84kwpzfkeOKsQB4DOM9P04w1
         VlmZ9zLvvsVoOSZB+LhjT89BjebfL9HEdSEKHT3691wimWTMiykrm4Z9cHTjMDx/CJHK
         JnTlS5CyHZsiXte91e5cD6eIKpdwLci7LeTN32tFmQS4ss6RioKlR0QSn/RxFnQfJ4zn
         Kf7w==
X-Gm-Message-State: AOAM530A5l4WKrUcRe/BUlaoDzhtkyKPKgPAZUvLMfWH2bZqCDHbK57H
        St3JiUoKEFhEGS1rM6xhUp5+HsGxMUwy4+UZ3OOuRVl02dD0Hfp18W0UGFOqCIRnKA1u56eVhZk
        9iGFKR3zvCfVi4ZHm
X-Received: by 2002:a05:6000:1b0c:: with SMTP id f12mr5705508wrz.230.1641457849152;
        Thu, 06 Jan 2022 00:30:49 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwfwhEhUu3E8ESCkUP5/TUeTOMDj/7fY1LyWDXZZLeuan85OIM0O4b+3gl/fmau7YNN/mTEJg==
X-Received: by 2002:a05:6000:1b0c:: with SMTP id f12mr5705489wrz.230.1641457848930;
        Thu, 06 Jan 2022 00:30:48 -0800 (PST)
Received: from krava (nat-pool-brq-u.redhat.com. [213.175.37.12])
        by smtp.gmail.com with ESMTPSA id b14sm1459488wri.112.2022.01.06.00.30.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Jan 2022 00:30:47 -0800 (PST)
Date:   Thu, 6 Jan 2022 09:30:45 +0100
From:   Jiri Olsa <jolsa@redhat.com>
To:     Masami Hiramatsu <mhiramat@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Naveen N. Rao" <naveen.n.rao@linux.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 02/13] kprobe: Keep traced function address
Message-ID: <Ydaoteitn9ufdTib@krava>
References: <20220104080943.113249-1-jolsa@kernel.org>
 <20220104080943.113249-3-jolsa@kernel.org>
 <20220105233252.2bc92d14c42827328109d9d0@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220105233252.2bc92d14c42827328109d9d0@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 05, 2022 at 11:32:52PM +0900, Masami Hiramatsu wrote:
> On Tue,  4 Jan 2022 09:09:32 +0100
> Jiri Olsa <jolsa@redhat.com> wrote:
> 
> > The bpf_get_func_ip_kprobe helper should return traced function
> > address, but it's doing so only for kprobes that are placed on
> > the function entry.
> > 
> > If kprobe is placed within the function, bpf_get_func_ip_kprobe
> > returns that address instead of function entry.
> > 
> > Storing the function entry directly in kprobe object, so it could
> > be used in bpf_get_func_ip_kprobe helper.
> 
> Hmm, please do this in bpf side, which should have some data structure
> around the kprobe itself. Do not add this "specialized" field to
> the kprobe data structure.

ok, will check

thanks,
jirka

> 
> Thank you,
> 
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
> >  	/* Offset into the symbol */
> >  	unsigned int offset;
> >  
> > +	/* traced function address */
> > +	unsigned long func_addr;
> > +
> >  	/* Called before addr is executed. */
> >  	kprobe_pre_handler_t pre_handler;
> >  
> > diff --git a/kernel/kprobes.c b/kernel/kprobes.c
> > index d20ae8232835..c4060a8da050 100644
> > --- a/kernel/kprobes.c
> > +++ b/kernel/kprobes.c
> > @@ -1310,6 +1310,7 @@ static void init_aggr_kprobe(struct kprobe *ap, struct kprobe *p)
> >  	copy_kprobe(p, ap);
> >  	flush_insn_slot(ap);
> >  	ap->addr = p->addr;
> > +	ap->func_addr = p->func_addr;
> >  	ap->flags = p->flags & ~KPROBE_FLAG_OPTIMIZED;
> >  	ap->pre_handler = aggr_pre_handler;
> >  	/* We don't care the kprobe which has gone. */
> > @@ -1588,6 +1589,16 @@ static int check_kprobe_address_safe(struct kprobe *p,
> >  	return ret;
> >  }
> >  
> > +static unsigned long resolve_func_addr(kprobe_opcode_t *addr)
> > +{
> > +	char str[KSYM_SYMBOL_LEN];
> > +	unsigned long offset;
> > +
> > +	if (kallsyms_lookup((unsigned long) addr, NULL, &offset, NULL, str))
> > +		return (unsigned long) addr - offset;
> > +	return 0;
> > +}
> > +
> >  int register_kprobe(struct kprobe *p)
> >  {
> >  	int ret;
> > @@ -1600,6 +1611,7 @@ int register_kprobe(struct kprobe *p)
> >  	if (IS_ERR(addr))
> >  		return PTR_ERR(addr);
> >  	p->addr = addr;
> > +	p->func_addr = resolve_func_addr(addr);
> >  
> >  	ret = warn_kprobe_rereg(p);
> >  	if (ret)
> > diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
> > index 21aa30644219..25631253084a 100644
> > --- a/kernel/trace/bpf_trace.c
> > +++ b/kernel/trace/bpf_trace.c
> > @@ -1026,7 +1026,7 @@ BPF_CALL_1(bpf_get_func_ip_kprobe, struct pt_regs *, regs)
> >  {
> >  	struct kprobe *kp = kprobe_running();
> >  
> > -	return kp ? (uintptr_t)kp->addr : 0;
> > +	return kp ? (uintptr_t)kp->func_addr : 0;
> >  }
> >  
> >  static const struct bpf_func_proto bpf_get_func_ip_proto_kprobe = {
> > diff --git a/tools/testing/selftests/bpf/progs/get_func_ip_test.c b/tools/testing/selftests/bpf/progs/get_func_ip_test.c
> > index a587aeca5ae0..e988aefa567e 100644
> > --- a/tools/testing/selftests/bpf/progs/get_func_ip_test.c
> > +++ b/tools/testing/selftests/bpf/progs/get_func_ip_test.c
> > @@ -69,7 +69,7 @@ int test6(struct pt_regs *ctx)
> >  {
> >  	__u64 addr = bpf_get_func_ip(ctx);
> >  
> > -	test6_result = (const void *) addr == &bpf_fentry_test6 + 5;
> > +	test6_result = (const void *) addr == &bpf_fentry_test6;
> >  	return 0;
> >  }
> >  
> > @@ -79,6 +79,6 @@ int test7(struct pt_regs *ctx)
> >  {
> >  	__u64 addr = bpf_get_func_ip(ctx);
> >  
> > -	test7_result = (const void *) addr == &bpf_fentry_test7 + 5;
> > +	test7_result = (const void *) addr == &bpf_fentry_test7;
> >  	return 0;
> >  }
> > -- 
> > 2.33.1
> > 
> 
> 
> -- 
> Masami Hiramatsu <mhiramat@kernel.org>
> 


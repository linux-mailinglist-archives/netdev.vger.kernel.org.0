Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76EF13B8EF2
	for <lists+netdev@lfdr.de>; Thu,  1 Jul 2021 10:38:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235088AbhGAIkw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Jul 2021 04:40:52 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:29141 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235067AbhGAIkv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Jul 2021 04:40:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625128701;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=RdW9ELkyVqCWFo2sv1vnTomLn4doa9a6zTYTvItJQns=;
        b=aBixhq8w08GXYlog/ZprhmuCIpmPI0dXuHrZEg7R+2R6/GzS7/tzQzSyrONqSqZQRQQ2R9
        wSc870/jRICVUpySIvVV4Uxb4cCftGKTl8mPApyzj64nzUC6muPsx0rU0qck7Vbyq1Hvcw
        7hgxZUXM+7/1Vgz1DKcNTATcYdFzlII=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-376-KY6ECP13P7O1EUp3mxGbSQ-1; Thu, 01 Jul 2021 04:38:20 -0400
X-MC-Unique: KY6ECP13P7O1EUp3mxGbSQ-1
Received: by mail-ed1-f69.google.com with SMTP id s6-20020a0564020146b029039578926b8cso2654678edu.20
        for <netdev@vger.kernel.org>; Thu, 01 Jul 2021 01:38:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=RdW9ELkyVqCWFo2sv1vnTomLn4doa9a6zTYTvItJQns=;
        b=SP/EfRZRWzfwwFpvbhsrEWnDOCQw9QRrjNzKCCqycElPQpD8z9T5z7FqcOR9HlgXgS
         7ONvDZThvHkoaYzEWy9vRvoAuEZQjWbd/4dJ/hpMiCpy2lyatRaqOAwFtDvfHmPY6EiN
         QZPiBqDmQKPBj2wbKNGTDLJP2YZvdJNNMswC8u3t2u/J4qiUm41HrcssDen3QzSpVh0S
         9zjP7zPRTcsWjc+AhGgrUIK9HTapSdtvRbEGQAhZ+YfLTB39jIto4++C1J4iCrXyU1xi
         M+X2D4NIozJZ3SM7c9fRu3II31MM++TypwuYRplitL7VSkYX/ODHF31zS/iXMbqA0FPL
         C+Uw==
X-Gm-Message-State: AOAM531vwJei4HClYBEssNK3WrB4crmkXOsaZ7n00S3fA+wrKo+jVVjz
        UviJmyrL8PQ4f8qURhNGTndeMGtwl2cBrQds6r2+X1HxHA7tOxn9CidpJPaq4n4QngOPDdQcOGv
        fiPlFQdzd5e5hUFNP
X-Received: by 2002:a05:6402:358:: with SMTP id r24mr52923924edw.69.1625128699010;
        Thu, 01 Jul 2021 01:38:19 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyE0E4bB0+/WsTGDPlKeZhSomz9jqMJL2UQrPuxlMBN22o0n4P+alKA28qRrT562EECFvEodA==
X-Received: by 2002:a05:6402:358:: with SMTP id r24mr52923905edw.69.1625128698900;
        Thu, 01 Jul 2021 01:38:18 -0700 (PDT)
Received: from krava ([185.153.78.55])
        by smtp.gmail.com with ESMTPSA id n2sm13748418edi.32.2021.07.01.01.38.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Jul 2021 01:38:18 -0700 (PDT)
Date:   Thu, 1 Jul 2021 10:38:14 +0200
From:   Jiri Olsa <jolsa@redhat.com>
To:     Masami Hiramatsu <mhiramat@kernel.org>
Cc:     Yonghong Song <yhs@fb.com>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
Subject: Re: [PATCH bpf-next 4/5] bpf: Add bpf_get_func_ip helper for kprobe
 programs
Message-ID: <YN1+9osJ4NhqZK/j@krava>
References: <20210629192945.1071862-1-jolsa@kernel.org>
 <20210629192945.1071862-5-jolsa@kernel.org>
 <9286ce63-5cba-e16a-a7db-886548a04a64@fb.com>
 <20210701085854.0f2aeafc0fce11f3ca9d52a8@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210701085854.0f2aeafc0fce11f3ca9d52a8@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 01, 2021 at 08:58:54AM +0900, Masami Hiramatsu wrote:

SNIP

> > >   		return &bpf_override_return_proto;
> > >   #endif
> > > +	case BPF_FUNC_get_func_ip:
> > > +		return &bpf_get_func_ip_proto_kprobe;
> > >   	default:
> > >   		return bpf_tracing_func_proto(func_id, prog);
> > >   	}
> > > diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
> > > index ea6178cb5e33..b07d5888db14 100644
> > > --- a/kernel/trace/trace_kprobe.c
> > > +++ b/kernel/trace/trace_kprobe.c
> > > @@ -1570,6 +1570,18 @@ static int kretprobe_event_define_fields(struct trace_event_call *event_call)
> > >   }
> > >   
> > >   #ifdef CONFIG_PERF_EVENTS
> > > +/* Used by bpf get_func_ip helper */
> > > +DEFINE_PER_CPU(u64, current_kprobe_addr) = 0;
> > 
> > Didn't check other architectures. But this should work
> > for x86 where if nested kprobe happens, the second
> > kprobe will not call kprobe handlers.
> 
> No problem, other architecture also does not call nested kprobes handlers.
> However, you don't need this because you can use kprobe_running()
> in kprobe context.
> 
> kp = kprobe_running();
> if (kp)
> 	return kp->addr;

great, that's easier

> 
> BTW, I'm not sure why don't you use instruction_pointer(regs)?

I tried that but it returns function address + 1,
and I thought that could be different on each arch
and we'd need arch specific code to deal with that

thanks,
jirka


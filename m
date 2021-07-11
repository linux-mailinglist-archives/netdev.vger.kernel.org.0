Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C32CB3C3D65
	for <lists+netdev@lfdr.de>; Sun, 11 Jul 2021 16:48:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233394AbhGKOvD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Jul 2021 10:51:03 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:25678 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233381AbhGKOvC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Jul 2021 10:51:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626014895;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+yg5HW/8shmTWWW4M+neHQym5BS96og4YWDUyV+pCFI=;
        b=H7IVbQQU4qUr9CPH0Z9ZgOotkEELgOFlAl/M7spM3aeM3ZxXuRVQPq++Y+cYawce5AI4G3
        VpyU8txXpLCLsFAmhSYlf2mv4uDsAXGlKS13rhYH4kl+r7XyrAPWkNL4trXcU4UJFm1tmV
        4/0OZDoqYBp3+qKKEn85Va3THfRJYkU=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-579-gPWgUmHeNCu4uS4ofviVJQ-1; Sun, 11 Jul 2021 10:48:14 -0400
X-MC-Unique: gPWgUmHeNCu4uS4ofviVJQ-1
Received: by mail-ed1-f71.google.com with SMTP id o8-20020aa7dd480000b02903954c05c938so8376132edw.3
        for <netdev@vger.kernel.org>; Sun, 11 Jul 2021 07:48:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=+yg5HW/8shmTWWW4M+neHQym5BS96og4YWDUyV+pCFI=;
        b=dW3g0GuHCuSF6g8dvtrBn0fJ1ryckx3VVPh5JJVkTglmsZNWjo35VCzBqtJcOhyZzt
         oHDkhiIWkEahCn1Q0A5tkzkB/yhZF5sdvMT3ue4bM5S5ihJbXXwkx0ayynPToUD7QAZf
         ab9NwmxbcjPZ8TtxoIe38d+xqIqQ+i2dsjnO7N1Mh3O5hWYztzW6F/EdWikwi3nLYyMc
         MXk2/2fw794NmVFGl98oMo4M5PC6JaId8lpHrcNrrZwz9e7CwnWwgEBu38V4A2yal6tp
         nUdS/KaxX1kwPq5s0vnO5+X5TsPGc1CwySDlnUxsnC6cOn3aGofulVr/uIXhC0OrlpkY
         yKeg==
X-Gm-Message-State: AOAM531UbePyjmJLdINXGzoe0s6Ehqz3Kmv9bnph8NDv9iB3aXD2sxTR
        /2XNy0i8my9rk2ThhbKI5ZJUbfbM0RtwtYSVx0akzyjG/wdOSt8qAobn4QV5chHYfsI1LF3TpS7
        l/DY16a8+RF0D1kSr
X-Received: by 2002:a50:8e19:: with SMTP id 25mr36357790edw.11.1626014893438;
        Sun, 11 Jul 2021 07:48:13 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJweA12Fm0mKuevcoKmaGJ1MEnZqm7daKuRdqppmGocfc41+s3/g5wJEAzGr4dGLtopyMCEkGg==
X-Received: by 2002:a50:8e19:: with SMTP id 25mr36357775edw.11.1626014893232;
        Sun, 11 Jul 2021 07:48:13 -0700 (PDT)
Received: from krava ([5.171.250.127])
        by smtp.gmail.com with ESMTPSA id v3sm1825885ejb.69.2021.07.11.07.48.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Jul 2021 07:48:12 -0700 (PDT)
Date:   Sun, 11 Jul 2021 16:48:09 +0200
From:   Jiri Olsa <jolsa@redhat.com>
To:     Masami Hiramatsu <mhiramat@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Alan Maguire <alan.maguire@oracle.com>
Subject: Re: [PATCHv3 bpf-next 4/7] bpf: Add bpf_get_func_ip helper for
 kprobe programs
Message-ID: <YOsEqXKGi9shmptu@krava>
References: <20210707214751.159713-1-jolsa@kernel.org>
 <20210707214751.159713-5-jolsa@kernel.org>
 <20210710165512.8b0ffc67a894fef9a883eef2@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210710165512.8b0ffc67a894fef9a883eef2@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 10, 2021 at 04:55:12PM +0900, Masami Hiramatsu wrote:
> On Wed,  7 Jul 2021 23:47:48 +0200
> Jiri Olsa <jolsa@redhat.com> wrote:
> 
> > Adding bpf_get_func_ip helper for BPF_PROG_TYPE_KPROBE programs,
> > so it's now possible to call bpf_get_func_ip from both kprobe and
> > kretprobe programs.
> > 
> > Taking the caller's address from 'struct kprobe::addr', which is
> > defined for both kprobe and kretprobe.
> > 
> 
> Note that the kp->addr of kretprobe will be the callee function
> address, even if the handler is called when the end of the callee.

yes, that's what we need

> 
> Anyway, this looks good to me.
> 
> Reviewed-by: Masami Hiramatsu <mhiramat@kernel.org>

thanks,
jirka

> 
> Thank you,
> 
> > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > ---
> >  include/uapi/linux/bpf.h       |  2 +-
> >  kernel/bpf/verifier.c          |  2 ++
> >  kernel/trace/bpf_trace.c       | 17 +++++++++++++++++
> >  tools/include/uapi/linux/bpf.h |  2 +-
> >  4 files changed, 21 insertions(+), 2 deletions(-)
> > 
> > diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> > index 83e87ffdbb6e..4894f99a1993 100644
> > --- a/include/uapi/linux/bpf.h
> > +++ b/include/uapi/linux/bpf.h
> > @@ -4783,7 +4783,7 @@ union bpf_attr {
> >   *
> >   * u64 bpf_get_func_ip(void *ctx)
> >   * 	Description
> > - * 		Get address of the traced function (for tracing programs).
> > + * 		Get address of the traced function (for tracing and kprobe programs).
> >   * 	Return
> >   * 		Address of the traced function.
> >   */
> > diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> > index f975a3aa9368..79eb9d81a198 100644
> > --- a/kernel/bpf/verifier.c
> > +++ b/kernel/bpf/verifier.c
> > @@ -5979,6 +5979,8 @@ static int has_get_func_ip(struct bpf_verifier_env *env)
> >  			return -ENOTSUPP;
> >  		}
> >  		return 0;
> > +	} else if (type == BPF_PROG_TYPE_KPROBE) {
> > +		return 0;
> >  	}
> >  
> >  	verbose(env, "func %s#%d not supported for program type %d\n",
> > diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
> > index 9edd3b1a00ad..55acf56b0c3a 100644
> > --- a/kernel/trace/bpf_trace.c
> > +++ b/kernel/trace/bpf_trace.c
> > @@ -17,6 +17,7 @@
> >  #include <linux/error-injection.h>
> >  #include <linux/btf_ids.h>
> >  #include <linux/bpf_lsm.h>
> > +#include <linux/kprobes.h>
> >  
> >  #include <net/bpf_sk_storage.h>
> >  
> > @@ -961,6 +962,20 @@ static const struct bpf_func_proto bpf_get_func_ip_proto_tracing = {
> >  	.arg1_type	= ARG_PTR_TO_CTX,
> >  };
> >  
> > +BPF_CALL_1(bpf_get_func_ip_kprobe, struct pt_regs *, regs)
> > +{
> > +	struct kprobe *kp = kprobe_running();
> > +
> > +	return kp ? (u64) kp->addr : 0;
> > +}
> > +
> > +static const struct bpf_func_proto bpf_get_func_ip_proto_kprobe = {
> > +	.func		= bpf_get_func_ip_kprobe,
> > +	.gpl_only	= true,
> > +	.ret_type	= RET_INTEGER,
> > +	.arg1_type	= ARG_PTR_TO_CTX,
> > +};
> > +
> >  const struct bpf_func_proto *
> >  bpf_tracing_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
> >  {
> > @@ -1092,6 +1107,8 @@ kprobe_prog_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
> >  	case BPF_FUNC_override_return:
> >  		return &bpf_override_return_proto;
> >  #endif
> > +	case BPF_FUNC_get_func_ip:
> > +		return &bpf_get_func_ip_proto_kprobe;
> >  	default:
> >  		return bpf_tracing_func_proto(func_id, prog);
> >  	}
> > diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
> > index 83e87ffdbb6e..4894f99a1993 100644
> > --- a/tools/include/uapi/linux/bpf.h
> > +++ b/tools/include/uapi/linux/bpf.h
> > @@ -4783,7 +4783,7 @@ union bpf_attr {
> >   *
> >   * u64 bpf_get_func_ip(void *ctx)
> >   * 	Description
> > - * 		Get address of the traced function (for tracing programs).
> > + * 		Get address of the traced function (for tracing and kprobe programs).
> >   * 	Return
> >   * 		Address of the traced function.
> >   */
> > -- 
> > 2.31.1
> > 
> 
> 
> -- 
> Masami Hiramatsu <mhiramat@kernel.org>
> 


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4163C3C3D64
	for <lists+netdev@lfdr.de>; Sun, 11 Jul 2021 16:48:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233378AbhGKOuy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Jul 2021 10:50:54 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:28168 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233036AbhGKOuy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Jul 2021 10:50:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626014887;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Sgdys5iPg6wbkjWewjIY9i4QMskjqyv3n0Knxnjyej0=;
        b=U5bW3yKGpDcGXmv0ZADCQ1IpbYJB7JAgc2ZYNbKjZIALJVJ3UJ5Jg0c9CTcAgFFdgvmb7F
        LRlocW/HbQubHqxbxK5iLe3Lq8kK6gO5W8sC5SlUU8OYZEH+rl2yvU2/h5Z0Y8ZfbbQEDv
        eJuHKWv0PylQbPcs8R9BJNn3M5MjrKE=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-457-1LCCRS2-OW6n-6g-KV-Pyg-1; Sun, 11 Jul 2021 10:48:05 -0400
X-MC-Unique: 1LCCRS2-OW6n-6g-KV-Pyg-1
Received: by mail-ed1-f71.google.com with SMTP id m21-20020a50ef150000b029039c013d5b80so8360356eds.7
        for <netdev@vger.kernel.org>; Sun, 11 Jul 2021 07:48:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Sgdys5iPg6wbkjWewjIY9i4QMskjqyv3n0Knxnjyej0=;
        b=QB513g6rr6t9e53VrCdwl+FJv6Z/VKPBdZCIZFzLgIMCxxakIPrpaNHP3M3a/t0tN1
         7k0QEFvjxKAJmXttZGxsIP4k0WnAPIFznpV/COPOKgNnRgMQ5mkXxO0R1ugNswtedz6D
         dIZ1dPXk6rNW92trZRqXxB9dKOP8fAO5okp42HNzHDfPWrh0S1CFHw8zvOO6/EN3LV6L
         dWovKOHx4157oeoels8HFcisUgawdo/8TWvRF1f0aoT9+2mPqNT/zP8jxYAKlhwBtX+C
         GdToru0rh4v/AA5n32FlHPdTyvhhnewHbAukkaVw1eiVuW/6ZwIcwkRgywxLrY/+aHAE
         KQCQ==
X-Gm-Message-State: AOAM530EAHiQ5H0xgI/3+c+QgvtU7vpKe3gqRQ5KF0XUcD6+/bmp2/o7
        TqXXD/eMu73V7U8KDdzZ2ZOqoW8MyaWg3biQtxNueUy1slos/eOOttCJIxgiCCt/YeAXjQmqXIF
        pI0AqA/bu7wlZbb4G
X-Received: by 2002:a17:906:4551:: with SMTP id s17mr10913009ejq.26.1626014884683;
        Sun, 11 Jul 2021 07:48:04 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyGWDmZi1hvVjtt6uwRHOfu+Q23TC5jE2YxihaGfMzLC/Q+x603fLRqAC8+oo509HTH689aOQ==
X-Received: by 2002:a17:906:4551:: with SMTP id s17mr10912999ejq.26.1626014884479;
        Sun, 11 Jul 2021 07:48:04 -0700 (PDT)
Received: from krava ([5.171.250.127])
        by smtp.gmail.com with ESMTPSA id k14sm6334314edq.79.2021.07.11.07.48.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Jul 2021 07:48:04 -0700 (PDT)
Date:   Sun, 11 Jul 2021 16:48:00 +0200
From:   Jiri Olsa <jolsa@redhat.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        kernel test robot <lkp@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Alan Maguire <alan.maguire@oracle.com>
Subject: Re: [PATCHv3 bpf-next 3/7] bpf: Add bpf_get_func_ip helper for
 tracing programs
Message-ID: <YOsEoLogYRy7TiJg@krava>
References: <20210707214751.159713-1-jolsa@kernel.org>
 <20210707214751.159713-4-jolsa@kernel.org>
 <20210708021123.w4smo42jml57iowl@ast-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210708021123.w4smo42jml57iowl@ast-mbp.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 07, 2021 at 07:11:23PM -0700, Alexei Starovoitov wrote:
> On Wed, Jul 07, 2021 at 11:47:47PM +0200, Jiri Olsa wrote:
> >  
> > +static bool allow_get_func_ip_tracing(struct bpf_verifier_env *env)
> > +{
> > +	return env->prog->jit_requested && IS_ENABLED(CONFIG_X86_64);
> 
> Why does it have to be gated by 'jited && x86_64' ?
> It's gated by bpf trampoline and it's only implemented on x86_64 so far.
> The trampoline has plenty of features. I would expect bpf trampoline
> for arm64 to implement all of them. If not the func_ip would be just
> one of the trampoline features that couldn't be implemented and at that
> time we'd need a flag mask of a sort, but I'd rather push of feature
> equivalence between trampoline implementations.

ok, check for trampoline's prog types should be enough

> 
> Then jited part also doesn't seem to be necessary.
> The trampoline passed pointer to a stack in R1.
> Interpreter should deal with BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1, -8) insn
> the same way and it should work, since trampoline prepared it.
> What did I miss?

ah right.. will remove that

SNIP

> > diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
> > index 64bd2d84367f..9edd3b1a00ad 100644
> > --- a/kernel/trace/bpf_trace.c
> > +++ b/kernel/trace/bpf_trace.c
> > @@ -948,6 +948,19 @@ const struct bpf_func_proto bpf_snprintf_btf_proto = {
> >  	.arg5_type	= ARG_ANYTHING,
> >  };
> >  
> > +BPF_CALL_1(bpf_get_func_ip_tracing, void *, ctx)
> > +{
> > +	/* Stub, the helper call is inlined in the program. */
> > +	return 0;
> > +}
> 
> may be add a WARN in here that it should never be executed ?
> Or may be add an actual implementation:
>  return ((u64 *)ctx)[-1];
> and check that it works without inlining by the verifier?
> 

sure, but having tracing program with this helper, it will be
always inlined, right? I can't see how it could be skipped

thanks,
jirka


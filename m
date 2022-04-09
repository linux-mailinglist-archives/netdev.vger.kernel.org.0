Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8570D4FAAC0
	for <lists+netdev@lfdr.de>; Sat,  9 Apr 2022 22:24:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241233AbiDIU04 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Apr 2022 16:26:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241675AbiDIU0z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Apr 2022 16:26:55 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F063C2156C4;
        Sat,  9 Apr 2022 13:24:45 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id u3so17641174wrg.3;
        Sat, 09 Apr 2022 13:24:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=irgS8qcLKLYtl+m3fmwnnbCWqovp3OYwRZKXDq3z+5s=;
        b=jNMPcmM90NMUyrhE2B8ZBIlp2m1ScB1/ipCXsgf/fK6FVQzgpP/uVly1wsP8tVl6mz
         U1KlOP/1aJsKHNn9TwNxu6BQowOrw9uVmMUnTdF+0PRTcsplScLNjP5CLcKRTYTJesl8
         RMevXyH6Pocqfo9Dcs5iv2OwPy9wulWmhGrJI7p40dpym3fkRZoSExtmc35RUAO227/t
         BKK2DKBRLYXO3AR2Y8Qt4N/5792hybM6TrzonLJDXqzowBT6weZr2sFp1xYw8szyaUkS
         wwj/B9/v+LP38s1ISxR99V550TfrEjkpf1IEHTvl6fT1IsH2BSsVvX2Ybc6kf/HzqhTH
         yG+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=irgS8qcLKLYtl+m3fmwnnbCWqovp3OYwRZKXDq3z+5s=;
        b=oGE6MTPAVzCEBuAL3tPoajGPG6X1HnLA5jE7jv0bqb0MTfzL5n9ZJdl6t1ZDwRZYSv
         P4pzvrkPmWWWi+K+uQCZUIkn5mi0ox7lYAl0DdwlAgXZR+ii/WOx52gMz1tavWYM0+Sn
         +gfRCNW4pN1Q8qQGkskjioCVN1Pk0odPMuOz3OW4iHeDCe2niR/Ato6KUrKP66Vr47zl
         e3/PPt0zNb9WCmL07xkZw7XUQiiO14TSvj1Ma7uydiYSd4NkJLWR/QmTSM4e6x3lITf3
         bt3xzPsuam+MtNYlf+nqD1EMWRAYT+NtX4PQ89DBhbpyxuaQwTo5Q+khaSezlqxJHaDf
         hCSw==
X-Gm-Message-State: AOAM530Ni8OE34M3mIMshsLCEi8l0OI1rVDCe7p6y3H5VvDDF2u2F+2L
        Iorg//ue+mCP7vKThcnhho4=
X-Google-Smtp-Source: ABdhPJxCSsscc/7Bv1JlLYd6xrqtxSfv0oA0/i+mxiCYJEcJUUymcSN/lSmw2xHJaj9MSOkm1lxZMQ==
X-Received: by 2002:adf:fbcd:0:b0:207:94ee:f648 with SMTP id d13-20020adffbcd000000b0020794eef648mr7388312wrs.541.1649535884288;
        Sat, 09 Apr 2022 13:24:44 -0700 (PDT)
Received: from krava (94.113.247.30.static.b2b.upcbusiness.cz. [94.113.247.30])
        by smtp.gmail.com with ESMTPSA id bs12-20020a056000070c00b00207a2c698b1sm639914wrb.40.2022.04.09.13.24.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Apr 2022 13:24:44 -0700 (PDT)
Date:   Sat, 9 Apr 2022 22:24:41 +0200
From:   Jiri Olsa <olsajiri@gmail.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
Subject: Re: [RFC bpf-next 3/4] bpf: Resolve symbols with
 kallsyms_lookup_names for kprobe multi link
Message-ID: <YlHriYQeG7rTJ3OT@krava>
References: <20220407125224.310255-1-jolsa@kernel.org>
 <20220407125224.310255-4-jolsa@kernel.org>
 <20220408232610.nwtcuectacpwh6rk@MBP-98dd607d3435.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220408232610.nwtcuectacpwh6rk@MBP-98dd607d3435.dhcp.thefacebook.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 08, 2022 at 04:26:10PM -0700, Alexei Starovoitov wrote:
> On Thu, Apr 07, 2022 at 02:52:23PM +0200, Jiri Olsa wrote:
> > Using kallsyms_lookup_names function to speed up symbols lookup in
> > kprobe multi link attachment and replacing with it the current
> > kprobe_multi_resolve_syms function.
> > 
> > This speeds up bpftrace kprobe attachment:
> > 
> >   # perf stat -r 5 -e cycles ./src/bpftrace -e 'kprobe:x* {  } i:ms:1 { exit(); }'
> >   ...
> >   6.5681 +- 0.0225 seconds time elapsed  ( +-  0.34% )
> > 
> > After:
> > 
> >   # perf stat -r 5 -e cycles ./src/bpftrace -e 'kprobe:x* {  } i:ms:1 { exit(); }'
> >   ...
> >   0.5661 +- 0.0275 seconds time elapsed  ( +-  4.85% )
> > 
> > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > ---
> >  kernel/trace/bpf_trace.c | 123 +++++++++++++++++++++++----------------
> >  1 file changed, 73 insertions(+), 50 deletions(-)
> > 
> > diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
> > index b26f3da943de..2602957225ba 100644
> > --- a/kernel/trace/bpf_trace.c
> > +++ b/kernel/trace/bpf_trace.c
> > @@ -2226,6 +2226,72 @@ struct bpf_kprobe_multi_run_ctx {
> >  	unsigned long entry_ip;
> >  };
> >  
> > +struct user_syms {
> > +	const char **syms;
> > +	char *buf;
> > +};
> > +
> > +static int copy_user_syms(struct user_syms *us, void __user *usyms, u32 cnt)
> > +{
> > +	const char __user **usyms_copy = NULL;
> > +	const char **syms = NULL;
> > +	char *buf = NULL, *p;
> > +	int err = -EFAULT;
> > +	unsigned int i;
> > +	size_t size;
> > +
> > +	size = cnt * sizeof(*usyms_copy);
> > +
> > +	usyms_copy = kvmalloc(size, GFP_KERNEL);
> > +	if (!usyms_copy)
> > +		return -ENOMEM;
> > +
> > +	if (copy_from_user(usyms_copy, usyms, size))
> > +		goto error;
> > +
> > +	err = -ENOMEM;
> > +	syms = kvmalloc(size, GFP_KERNEL);
> > +	if (!syms)
> > +		goto error;
> > +
> > +	/* TODO this potentially allocates lot of memory (~6MB in my tests
> > +	 * with attaching ~40k functions). I haven't seen this to fail yet,
> > +	 * but it could be changed to allocate memory gradually if needed.
> > +	 */
> 
> Why would 6MB kvmalloc fail?
> If we don't have such memory the kernel will be ooming soon anyway.
> I don't think we'll see this kvmalloc triggering oom in practice.
> The verifier allocates a lot more memory to check large programs.
> 
> imo this approach is fine. It's simple.
> Trying to do gradual alloc with realloc would be just guessing.
> 
> Another option would be to ask user space (libbpf) to do the sort.
> There are pros and cons.
> This vmalloc+sort is slightly better imo.

ok, makes sense, will keep it

jirka

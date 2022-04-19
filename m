Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3E9A5066E4
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 10:26:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349914AbiDSI2x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Apr 2022 04:28:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240524AbiDSI2v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Apr 2022 04:28:51 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBA5D12A98;
        Tue, 19 Apr 2022 01:26:09 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id 11so15244320edw.0;
        Tue, 19 Apr 2022 01:26:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=qlMzRLQ0OCx1uqmYZwFcY29mjrRCXsvr66MMojKWmP8=;
        b=P5jpGuP2FbZnOB6I5gV27dKuLe04Ag6rTBVEN0lNs7LVSpGmKj1kU4mx33sk0AH9gN
         1zVp8lvXlykYT+6T4n2aZ+4umqBgSaKOKRd8lNpw+IHNS6dJFAafq4vN0qHJEVj7l3t6
         KxkZgTYDRdAR0iiuWMsD2qDyDiiQ8ICXPWM4CvChERhmU9a2eFijYtFJC/gXaNeGsO3F
         Q1aLG0aSH7alPyV4SPNzDNfubtTeXtRi3DuiKkCfqSGT71XInVA7BEGUCyhoLqHOfOXT
         xqEz+nm4NGyko/+dLM+Y0iQNJCXjzrZ7Afvr703NjRcNl/fzY4ejdIKRSBCJVRbUJ4Ju
         3c+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=qlMzRLQ0OCx1uqmYZwFcY29mjrRCXsvr66MMojKWmP8=;
        b=QkOL32XRP9qJ/5V1seDdFjGym3eZwSyVJh3MCzbepNRcDjmamuIvbtBbttDcUJQ9HI
         rsI/dTi+ohBMEdmCcyK1bys0dq+tgw4emjc/yvjOoZjqz4n3bPFPrgq9/0P3K0OKKyZ1
         5BXsXIzy7zSyJeIf5vf1sgDyyd8WOUXeVSttUbwH1YKIDTg4lf+C7ymv6Y1PIAp1Mc/P
         2ycU18LKB8Tnm2eVKS9CfW8cAYVzECzjejt0BVySLtyz+lJqIAGUeEvDr3xB6Rn7q3Hj
         y/boQL76HFAGz7X6zhJCFN+qpyo9JbxEWg2pB88k2w+W8zZ2WL9nLCdhf9yjA0Xrt4nm
         7XJg==
X-Gm-Message-State: AOAM532pGPsttqIR21m+p8qQgwlZM9jST34FBbRAZDfh+8iQsaFHRbRt
        RXbK9OKPxyTiwxUPyqMzpiQ=
X-Google-Smtp-Source: ABdhPJyZMRKj7e26bl9doDNtauY6dNFnzM2v+6rPOjf0RHdggWnoiZoafV0LNr2m61q47LfNDBCA/A==
X-Received: by 2002:a05:6402:c84:b0:41d:72b5:fb05 with SMTP id cm4-20020a0564020c8400b0041d72b5fb05mr15649278edb.361.1650356768157;
        Tue, 19 Apr 2022 01:26:08 -0700 (PDT)
Received: from krava ([193.85.244.190])
        by smtp.gmail.com with ESMTPSA id x1-20020a1709060ee100b006e8a49f215dsm5375726eji.73.2022.04.19.01.26.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Apr 2022 01:26:07 -0700 (PDT)
Date:   Tue, 19 Apr 2022 10:26:05 +0200
From:   Jiri Olsa <olsajiri@gmail.com>
To:     Masami Hiramatsu <mhiramat@kernel.org>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
Subject: Re: [PATCHv2 bpf-next 1/4] kallsyms: Add kallsyms_lookup_names
 function
Message-ID: <Yl5yHVOJpCYr+T3r@krava>
References: <20220418124834.829064-1-jolsa@kernel.org>
 <20220418124834.829064-2-jolsa@kernel.org>
 <20220418233546.dfe0a1be12193c26b05cdd93@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220418233546.dfe0a1be12193c26b05cdd93@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 18, 2022 at 11:35:46PM +0900, Masami Hiramatsu wrote:
> On Mon, 18 Apr 2022 14:48:31 +0200
> Jiri Olsa <jolsa@kernel.org> wrote:
> 
> > Adding kallsyms_lookup_names function that resolves array of symbols
> > with single pass over kallsyms.
> > 
> > The user provides array of string pointers with count and pointer to
> > allocated array for resolved values.
> > 
> >   int kallsyms_lookup_names(const char **syms, size_t cnt,
> >                             unsigned long *addrs)
> 
> What about renaming the 'syms' argument to 'sorted_syms' so that user
> is easily notice what is required?
> Or renaming the function as kallsyms_lookup_sorted_names()?
> 
> 
> > 
> > It iterates all kalsyms symbols and tries to loop up each in provided
> > symbols array with bsearch. The symbols array needs to be sorted by
> > name for this reason.
> > 
> > We also check each symbol to pass ftrace_location, because this API
> > will be used for fprobe symbols resolving. This can be optional in
> > future if there's a need.
> > 
> > We need kallsyms_on_each_symbol function, so enabling it and also
> > the new function for CONFIG_FPROBE option.
> > 
> > Suggested-by: Andrii Nakryiko <andrii@kernel.org>
> > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > ---
> >  include/linux/kallsyms.h |  6 ++++
> >  kernel/kallsyms.c        | 70 +++++++++++++++++++++++++++++++++++++++-
> >  2 files changed, 75 insertions(+), 1 deletion(-)
> > 
> > diff --git a/include/linux/kallsyms.h b/include/linux/kallsyms.h
> > index ce1bd2fbf23e..7c82fa7445d4 100644
> > --- a/include/linux/kallsyms.h
> > +++ b/include/linux/kallsyms.h
> > @@ -72,6 +72,7 @@ int kallsyms_on_each_symbol(int (*fn)(void *, const char *, struct module *,
> >  #ifdef CONFIG_KALLSYMS
> >  /* Lookup the address for a symbol. Returns 0 if not found. */
> >  unsigned long kallsyms_lookup_name(const char *name);
> > +int kallsyms_lookup_names(const char **syms, size_t cnt, unsigned long *addrs);
> >  
> >  extern int kallsyms_lookup_size_offset(unsigned long addr,
> >  				  unsigned long *symbolsize,
> > @@ -103,6 +104,11 @@ static inline unsigned long kallsyms_lookup_name(const char *name)
> >  	return 0;
> >  }
> >  
> > +static inline int kallsyms_lookup_names(const char **syms, size_t cnt, unsigned long *addrs)
> > +{
> > +	return -ERANGE;
> > +}
> > +
> >  static inline int kallsyms_lookup_size_offset(unsigned long addr,
> >  					      unsigned long *symbolsize,
> >  					      unsigned long *offset)
> > diff --git a/kernel/kallsyms.c b/kernel/kallsyms.c
> > index 79f2eb617a62..ef940b25f3fc 100644
> > --- a/kernel/kallsyms.c
> > +++ b/kernel/kallsyms.c
> > @@ -29,6 +29,7 @@
> >  #include <linux/compiler.h>
> >  #include <linux/module.h>
> >  #include <linux/kernel.h>
> > +#include <linux/bsearch.h>
> >  
> >  /*
> >   * These will be re-linked against their real values
> > @@ -228,7 +229,7 @@ unsigned long kallsyms_lookup_name(const char *name)
> >  	return module_kallsyms_lookup_name(name);
> >  }
> >  
> > -#ifdef CONFIG_LIVEPATCH
> > +#if defined(CONFIG_LIVEPATCH) || defined(CONFIG_FPROBE)
> >  /*
> >   * Iterate over all symbols in vmlinux.  For symbols from modules use
> >   * module_kallsyms_on_each_symbol instead.
> > @@ -572,6 +573,73 @@ int sprint_backtrace_build_id(char *buffer, unsigned long address)
> >  	return __sprint_symbol(buffer, address, -1, 1, 1);
> >  }
> >  
> > +#ifdef CONFIG_FPROBE
> > +static int symbols_cmp(const void *a, const void *b)
> > +{
> > +	const char **str_a = (const char **) a;
> > +	const char **str_b = (const char **) b;
> > +
> > +	return strcmp(*str_a, *str_b);
> > +}
> > +
> > +struct kallsyms_data {
> > +	unsigned long *addrs;
> > +	const char **syms;
> > +	size_t cnt;
> > +	size_t found;
> > +};
> > +
> > +static int kallsyms_callback(void *data, const char *name,
> > +			     struct module *mod, unsigned long addr)
> > +{
> > +	struct kallsyms_data *args = data;
> > +
> > +	if (!bsearch(&name, args->syms, args->cnt, sizeof(*args->syms), symbols_cmp))
> > +		return 0;
> > +
> > +	addr = ftrace_location(addr);
> > +	if (!addr)
> > +		return 0;
> 
> Ooops, wait. Did you do this last version? I missed this point.
> This changes the meanings of the kernel function.

yes, it was there before ;-) and you're right.. so some archs can
return different address, I did not realize that

> 
> > +
> > +	args->addrs[args->found++] = addr;
> > +	return args->found == args->cnt ? 1 : 0;
> > +}
> > +
> > +/**
> > + * kallsyms_lookup_names - Lookup addresses for array of symbols
> 
> More correctly "Lookup 'ftraced' addresses for array of sorted symbols", right?
> 
> I'm not sure, we can call it as a 'kallsyms' API, since this is using
> kallsyms but doesn't return symbol address, but ftrace address.
> I think this name misleads user to expect returning symbol address.
> 
> > + *
> > + * @syms: array of symbols pointers symbols to resolve, must be
> > + * alphabetically sorted
> > + * @cnt: number of symbols/addresses in @syms/@addrs arrays
> > + * @addrs: array for storing resulting addresses
> > + *
> > + * This function looks up addresses for array of symbols provided in
> > + * @syms array (must be alphabetically sorted) and stores them in
> > + * @addrs array, which needs to be big enough to store at least @cnt
> > + * addresses.
> 
> Hmm, sorry I changed my mind. I rather like to expose kallsyms_on_each_symbol()
> and provide this API from fprobe or ftrace, because this returns ftrace address
> and thus this is only used from fprobe.

ok, so how about:

  int ftrace_lookup_symbols(const char **sorted_syms, size_t cnt, unsigned long *addrs);


thanks,
jirka

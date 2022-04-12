Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9AD2B4FE9D8
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 23:08:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231665AbiDLVIX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 17:08:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229503AbiDLVIW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 17:08:22 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6226E15D058;
        Tue, 12 Apr 2022 13:56:29 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id e8so13043066wra.7;
        Tue, 12 Apr 2022 13:56:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=DqMC6Vs8XFHQhcFRE5fkKJXeyhfO8KrefwPFKdUZtCk=;
        b=mT3f6o6xyKP/QNK6+A4sGJyXB4ue9Xe4//e6ckZZvlhk4FxoxL5Qh3J1aG2BDuU/CU
         Mi3yLFiXqYiVnn1bb9qr/IdP4CXb8YVFmnlgj/Nm9rCf5wiaoiXb0Rf7Nl1sXe4bOExy
         3A8TDFgsOTqSaNWAumWiCQHKLgitWLtM01YAmBYAI+wtS3vbdSZ7SBKG7cHNwmeGVDsh
         Qfb/FWh7VgqieoO9lMqAaNabMn7DZDaESC7Q5q2JoNrMsGbzT02W/clUvxkOjoJEECBY
         TXZMqAWsqXcYXpjoVOBNOOu244Ek//c+IDSgQpUZeCuDtgVuvuEb3zLNeKuopF8oJwqy
         ZltQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=DqMC6Vs8XFHQhcFRE5fkKJXeyhfO8KrefwPFKdUZtCk=;
        b=uCXES36KxcJJSZ5FyjLGbg410G5PKOako6eJmKwySlvowt5knJd1AS3xk+vwGi/aPK
         VszxSt2qz+09QN7Mo65RuFGgbH/+pzum19DSo3JrzgnAtsdUfn9aOrmofg11OX2vzCYa
         /ViGEDev2dJgDOQwCu0IKCIByFFRIAntjmKmM0zzD4H5m61ou982X4yhaRBtORZdQDw6
         U4sUeFijR9rSvregUT9Itd/MadR7esk+otI7DlXIXmGCgyu5vEhyEJHbfj83PA8eME3m
         nbAUreVDj6yhCnm3EIhZQmstqRRIoyr1lYuW8SoQ0OQhqrPA8e80wgZcd/J3UEXS/jdp
         4XeA==
X-Gm-Message-State: AOAM532Q2T9Mibr2an+VVmDJZF2K+oz1PrEKLbtLC5VNlGAszCP7+Bmj
        jVakU3/XS3Ua+QOfyhV/ifZ3+JWjnROtUA==
X-Google-Smtp-Source: ABdhPJwykljm7T3aamkw4LwfP0Tg8dcXjfFJvjSrqx4NZaWASx46mBe81WwDk1WdNLoHVi9P+O2cXQ==
X-Received: by 2002:a05:6402:2059:b0:41d:82c2:208a with SMTP id bc25-20020a056402205900b0041d82c2208amr9907207edb.379.1649796378263;
        Tue, 12 Apr 2022 13:46:18 -0700 (PDT)
Received: from krava ([83.240.62.142])
        by smtp.gmail.com with ESMTPSA id c4-20020a170906340400b006d077e850b5sm13368177ejb.23.2022.04.12.13.46.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Apr 2022 13:46:17 -0700 (PDT)
Date:   Tue, 12 Apr 2022 22:46:15 +0200
From:   Jiri Olsa <olsajiri@gmail.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Masami Hiramatsu <mhiramat@kernel.org>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
Subject: Re: [RFC bpf-next 1/4] kallsyms: Add kallsyms_lookup_names function
Message-ID: <YlXlF5ivTR1QLMfk@krava>
References: <20220407125224.310255-1-jolsa@kernel.org>
 <20220407125224.310255-2-jolsa@kernel.org>
 <20220408231925.uc2cfeev7p6nzfww@MBP-98dd607d3435.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220408231925.uc2cfeev7p6nzfww@MBP-98dd607d3435.dhcp.thefacebook.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 08, 2022 at 04:19:25PM -0700, Alexei Starovoitov wrote:
> On Thu, Apr 07, 2022 at 02:52:21PM +0200, Jiri Olsa wrote:
> > Adding kallsyms_lookup_names function that resolves array of symbols
> > with single pass over kallsyms.
> > 
> > The user provides array of string pointers with count and pointer to
> > allocated array for resolved values.
> > 
> >   int kallsyms_lookup_names(const char **syms, u32 cnt,
> >                             unsigned long *addrs)
> > 
> > Before we iterate kallsyms we sort user provided symbols by name and
> > then use that in kalsyms iteration to find each kallsyms symbol in
> > user provided symbols.
> > 
> > We also check each symbol to pass ftrace_location, because this API
> > will be used for fprobe symbols resolving. This can be optional in
> > future if there's a need.
> > 
> > Suggested-by: Andrii Nakryiko <andrii@kernel.org>
> > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > ---
> >  include/linux/kallsyms.h |  6 +++++
> >  kernel/kallsyms.c        | 48 ++++++++++++++++++++++++++++++++++++++++
> >  2 files changed, 54 insertions(+)
> > 
> > diff --git a/include/linux/kallsyms.h b/include/linux/kallsyms.h
> > index ce1bd2fbf23e..5320a5e77f61 100644
> > --- a/include/linux/kallsyms.h
> > +++ b/include/linux/kallsyms.h
> > @@ -72,6 +72,7 @@ int kallsyms_on_each_symbol(int (*fn)(void *, const char *, struct module *,
> >  #ifdef CONFIG_KALLSYMS
> >  /* Lookup the address for a symbol. Returns 0 if not found. */
> >  unsigned long kallsyms_lookup_name(const char *name);
> > +int kallsyms_lookup_names(const char **syms, u32 cnt, unsigned long *addrs);
> >  
> >  extern int kallsyms_lookup_size_offset(unsigned long addr,
> >  				  unsigned long *symbolsize,
> > @@ -103,6 +104,11 @@ static inline unsigned long kallsyms_lookup_name(const char *name)
> >  	return 0;
> >  }
> >  
> > +int kallsyms_lookup_names(const char **syms, u32 cnt, unsigned long *addrs)
> > +{
> > +	return -ERANGE;
> > +}
> > +
> >  static inline int kallsyms_lookup_size_offset(unsigned long addr,
> >  					      unsigned long *symbolsize,
> >  					      unsigned long *offset)
> > diff --git a/kernel/kallsyms.c b/kernel/kallsyms.c
> > index 79f2eb617a62..a3738ddf9e87 100644
> > --- a/kernel/kallsyms.c
> > +++ b/kernel/kallsyms.c
> > @@ -29,6 +29,8 @@
> >  #include <linux/compiler.h>
> >  #include <linux/module.h>
> >  #include <linux/kernel.h>
> > +#include <linux/bsearch.h>
> > +#include <linux/sort.h>
> >  
> >  /*
> >   * These will be re-linked against their real values
> > @@ -572,6 +574,52 @@ int sprint_backtrace_build_id(char *buffer, unsigned long address)
> >  	return __sprint_symbol(buffer, address, -1, 1, 1);
> >  }
> >  
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
> > +	u32 cnt;
> > +	u32 found;
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
> > +
> > +	args->addrs[args->found++] = addr;
> > +	return args->found == args->cnt ? 1 : 0;
> > +}
> > +
> > +int kallsyms_lookup_names(const char **syms, u32 cnt, unsigned long *addrs)
> > +{
> > +	struct kallsyms_data args;
> > +
> > +	sort(syms, cnt, sizeof(*syms), symbols_cmp, NULL);
> 
> It's nice to share symbols_cmp for sort and bsearch,
> but messing technically input argument 'syms' like this will cause
> issues sooner or later.
> Lets make caller do the sort.
> Unordered input will cause issue with bsearch, of course,
> but it's a lesser evil. imo.
> 

Masami,
this logic bubbles up to the register_fprobe_syms, because user
provides symbols as its argument. Can we still force this assumption
to the 'syms' array, like with the comment change below?

FYI the bpf side does not use register_fprobe_syms, it uses
register_fprobe_ips, because it always needs ips as search
base for cookie values

thanks,
jirka


---
diff --git a/kernel/trace/fprobe.c b/kernel/trace/fprobe.c
index d466803dc2b2..28379c0e23e5 100644
--- a/kernel/trace/fprobe.c
+++ b/kernel/trace/fprobe.c
@@ -250,7 +250,7 @@ EXPORT_SYMBOL_GPL(register_fprobe_ips);
 /**
  * register_fprobe_syms() - Register fprobe to ftrace by symbols.
  * @fp: A fprobe data structure to be registered.
- * @syms: An array of target symbols.
+ * @syms: An array of target symbols, must be alphabetically sorted.
  * @num: The number of entries of @syms.
  *
  * Register @fp to the symbols given by @syms array. This will be useful if

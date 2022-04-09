Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9EC4F4FAABD
	for <lists+netdev@lfdr.de>; Sat,  9 Apr 2022 22:24:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239371AbiDIU0t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Apr 2022 16:26:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235417AbiDIU0o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Apr 2022 16:26:44 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86EE011D7B3;
        Sat,  9 Apr 2022 13:24:36 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id v2so3923892wrv.6;
        Sat, 09 Apr 2022 13:24:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=RjLMMMJSK9o4n2QWGsbdtdS98ll1ncXkFKjZkk+c5OE=;
        b=KwWZnyna7HuqcLi4U7VN2do1KHom7HabBHp9GqTZOTF4RyVSXNNkcSH2foUhxQveOB
         BGs45kJUGdre8uUWcQ017A0WBKoOLVWYMPhJQTRxOWw0JCFnftHULMwBUKPhJ/lBXwZU
         WlfXbQ3b0b/SVO33b7GvY2ZCJtgk4jjQpi69jGkzlVmV7029FM7Pf4FwkI/Le4NTBxnT
         nekz2DX3k9klbpZE9cqQy3FmBEhcA9rV26aGLSzAkTRVFeGD8lSF27N9mObXYEt6SK69
         HL5JhRt189gnpiPHFTmhiHgMP7vB1YUDCT54mD4lFztLE9ozhGjyeZKsaY0H8cISxAaw
         n2rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=RjLMMMJSK9o4n2QWGsbdtdS98ll1ncXkFKjZkk+c5OE=;
        b=pJ1hWWqoX89vEgOy05WNdbhlA0I2yRXDvoUMoMua1Cvof2VoSMSiiVS1yvrbSklYLa
         wrQzfkS6EGsT8nWS/s6p+Rt9dYUZ/eKPfGu6xG/b1J+6ruZLOt94lkVpyCzE8uIRtWQn
         kALmlq4paYrdIu7MhwWEJy4aSQJhv3ufp1864y5C4W6aUpPSRFioOifL/ToYBpNh56iS
         /gbYb6NWtwJivGVmPZVVDd0ArQAKYmBGQKBIQhGOER2rCr5FjuLzl0i8wx4EFUx1OPSc
         HCUrxZZ1JFjrUZhX7CF2AN+rqkmZHFI4w2JwQPa/l7lj+FrUbEHUD+86xz1rllnDNrQO
         gdnA==
X-Gm-Message-State: AOAM530CzyNRN+NJmmuEFrcRbOmTPSFhimDsVSbmk9PR6K+qiWMxLV8W
        TpE3S6HQZb0edvYuMN4LerQ=
X-Google-Smtp-Source: ABdhPJz7glTEa1gg3vbpid5r2qCDUlalzYGSZ2e5O69HOhCEpAA++ifdfIaKpO+9hoVY7henLf5A1A==
X-Received: by 2002:a5d:5981:0:b0:204:1da7:93d7 with SMTP id n1-20020a5d5981000000b002041da793d7mr20125083wri.621.1649535875063;
        Sat, 09 Apr 2022 13:24:35 -0700 (PDT)
Received: from krava (94.113.247.30.static.b2b.upcbusiness.cz. [94.113.247.30])
        by smtp.gmail.com with ESMTPSA id y15-20020a05600015cf00b00203e324347bsm26840249wry.102.2022.04.09.13.24.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Apr 2022 13:24:34 -0700 (PDT)
Date:   Sat, 9 Apr 2022 22:24:32 +0200
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
Subject: Re: [RFC bpf-next 1/4] kallsyms: Add kallsyms_lookup_names function
Message-ID: <YlHrgCu86D9vuUKR@krava>
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

ok, will move it out and make some proper comment for the
function mentioning the sort requirement for syms

thanks,
jirka

> 
> > +
> > +	args.addrs = addrs;
> > +	args.syms = syms;
> > +	args.cnt = cnt;
> > +	args.found = 0;
> > +	kallsyms_on_each_symbol(kallsyms_callback, &args);
> > +
> > +	return args.found == args.cnt ? 0 : -EINVAL;
> > +}
> > +
> >  /* To avoid using get_symbol_offset for every symbol, we carry prefix along. */
> >  struct kallsym_iter {
> >  	loff_t pos;
> > -- 
> > 2.35.1
> > 

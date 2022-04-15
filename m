Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 944EE50308F
	for <lists+netdev@lfdr.de>; Sat, 16 Apr 2022 01:09:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356339AbiDOWln (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Apr 2022 18:41:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231616AbiDOWlm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Apr 2022 18:41:42 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9158BBF950;
        Fri, 15 Apr 2022 15:39:12 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id 21so11306277edv.1;
        Fri, 15 Apr 2022 15:39:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Xd/TY0lCcvOfD4XwdghjY2Bw0dW7OQwwq4wE6xzj5Lg=;
        b=DR/30Z2Bvad/UzIT+ijDNS7EQ34yE1Pw3naYQ3q+XlCXXEyDjF3+PrMlBAubnmlni7
         +trIkPmZC5h+TH+9vSvNCUmlqE3fF9RF8qkGvBAgXeoiPc7RX44K9GfEwud4URY1tvOd
         6par0+Pbu16FR7dY8se477ubWO0UHSHTy1n4n/7cmI6R8HkE5puayoB5XsTYapzQCJI8
         XAJrolV9Cx3hX7Ojfq2OZr9SLssGk3pZ/olC4RB3XwOVRhHCDJhCrDqiwDa+Ri1mf97s
         HOl645v6UCQIMWr+LSS5z/8CzEXgPyU/PjT2bQUF6qz60ePlSrctbrC6neF3YnT1hEbU
         q6bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Xd/TY0lCcvOfD4XwdghjY2Bw0dW7OQwwq4wE6xzj5Lg=;
        b=67GqoAay7+vsThi2gZ0A/P6Xp+4k4207FY8JAE417j8BQAdCeD3pOP3olYUPsI6UOx
         ZyGtlaBGZwdqb9qAtGLWjqO39tYlL4l/z81qgysuHzkNohTmyc76hEovAvPbz+LkKs1T
         xxjBa8HBM7wByApphdsFEHnMBmlWZRuhpPL6mj5pcpopIybSluSP1Hd2/gwlNkt29DYZ
         D9gVfh+pZagN62bOZkYaE49a6+hfTKWagkbY3V3/a1rTRGSOVnInlPM+v3Cml0JdYxco
         xJ0H6OaFZKwoYusnLnd0jHktEdLNqT8VAcwrlH9HN3W0uN1Wm1CAcxRWl/m/ruJ3YoBX
         zehw==
X-Gm-Message-State: AOAM532h44BpDiUWJDtRAjj+pIwaN+Fc8lqZkPQENz+Aw4gArsD2Zxyw
        zDrHNmS7TpzIVd6EV9qSufQ=
X-Google-Smtp-Source: ABdhPJwj12+saMkHxF3CiI2y5YsDBikvUq2Ikj7bmWZvCIhpz/z403Arc3JrJj4hZw7osqi8n9jZBg==
X-Received: by 2002:a05:6402:448a:b0:41d:793d:8252 with SMTP id er10-20020a056402448a00b0041d793d8252mr1256813edb.6.1650062350990;
        Fri, 15 Apr 2022 15:39:10 -0700 (PDT)
Received: from krava ([95.82.134.228])
        by smtp.gmail.com with ESMTPSA id b23-20020a05640202d700b00422da9b980esm1015481edx.22.2022.04.15.15.39.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Apr 2022 15:39:10 -0700 (PDT)
Date:   Sat, 16 Apr 2022 00:39:08 +0200
From:   Jiri Olsa <olsajiri@gmail.com>
To:     Masami Hiramatsu <mhiramat@kernel.org>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
Subject: Re: [RFC bpf-next 1/4] kallsyms: Add kallsyms_lookup_names function
Message-ID: <Yln0DCVKAf9yZicG@krava>
References: <20220407125224.310255-1-jolsa@kernel.org>
 <20220407125224.310255-2-jolsa@kernel.org>
 <20220408231925.uc2cfeev7p6nzfww@MBP-98dd607d3435.dhcp.thefacebook.com>
 <YlXlF5ivTR1QLMfk@krava>
 <20220415094727.2880a321bb6674d94e104110@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220415094727.2880a321bb6674d94e104110@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 15, 2022 at 09:47:27AM +0900, Masami Hiramatsu wrote:
> Hi Jiri,
> 
> Sorry for replying later.
> 
> On Tue, 12 Apr 2022 22:46:15 +0200
> Jiri Olsa <olsajiri@gmail.com> wrote:
> 
> > On Fri, Apr 08, 2022 at 04:19:25PM -0700, Alexei Starovoitov wrote:
> > > On Thu, Apr 07, 2022 at 02:52:21PM +0200, Jiri Olsa wrote:
> > > > Adding kallsyms_lookup_names function that resolves array of symbols
> > > > with single pass over kallsyms.
> > > > 
> > > > The user provides array of string pointers with count and pointer to
> > > > allocated array for resolved values.
> > > > 
> > > >   int kallsyms_lookup_names(const char **syms, u32 cnt,
> > > >                             unsigned long *addrs)
> > > > 
> > > > Before we iterate kallsyms we sort user provided symbols by name and
> > > > then use that in kalsyms iteration to find each kallsyms symbol in
> > > > user provided symbols.
> > > > 
> > > > We also check each symbol to pass ftrace_location, because this API
> > > > will be used for fprobe symbols resolving. This can be optional in
> > > > future if there's a need.
> > > > 
> > > > Suggested-by: Andrii Nakryiko <andrii@kernel.org>
> > > > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > > > ---
> > > >  include/linux/kallsyms.h |  6 +++++
> > > >  kernel/kallsyms.c        | 48 ++++++++++++++++++++++++++++++++++++++++
> > > >  2 files changed, 54 insertions(+)
> > > > 
> > > > diff --git a/include/linux/kallsyms.h b/include/linux/kallsyms.h
> > > > index ce1bd2fbf23e..5320a5e77f61 100644
> > > > --- a/include/linux/kallsyms.h
> > > > +++ b/include/linux/kallsyms.h
> > > > @@ -72,6 +72,7 @@ int kallsyms_on_each_symbol(int (*fn)(void *, const char *, struct module *,
> > > >  #ifdef CONFIG_KALLSYMS
> > > >  /* Lookup the address for a symbol. Returns 0 if not found. */
> > > >  unsigned long kallsyms_lookup_name(const char *name);
> > > > +int kallsyms_lookup_names(const char **syms, u32 cnt, unsigned long *addrs);
> > > >  
> > > >  extern int kallsyms_lookup_size_offset(unsigned long addr,
> > > >  				  unsigned long *symbolsize,
> > > > @@ -103,6 +104,11 @@ static inline unsigned long kallsyms_lookup_name(const char *name)
> > > >  	return 0;
> > > >  }
> > > >  
> > > > +int kallsyms_lookup_names(const char **syms, u32 cnt, unsigned long *addrs)
> > > > +{
> > > > +	return -ERANGE;
> > > > +}
> > > > +
> > > >  static inline int kallsyms_lookup_size_offset(unsigned long addr,
> > > >  					      unsigned long *symbolsize,
> > > >  					      unsigned long *offset)
> > > > diff --git a/kernel/kallsyms.c b/kernel/kallsyms.c
> > > > index 79f2eb617a62..a3738ddf9e87 100644
> > > > --- a/kernel/kallsyms.c
> > > > +++ b/kernel/kallsyms.c
> > > > @@ -29,6 +29,8 @@
> > > >  #include <linux/compiler.h>
> > > >  #include <linux/module.h>
> > > >  #include <linux/kernel.h>
> > > > +#include <linux/bsearch.h>
> > > > +#include <linux/sort.h>
> > > >  
> > > >  /*
> > > >   * These will be re-linked against their real values
> > > > @@ -572,6 +574,52 @@ int sprint_backtrace_build_id(char *buffer, unsigned long address)
> > > >  	return __sprint_symbol(buffer, address, -1, 1, 1);
> > > >  }
> > > >  
> > > > +static int symbols_cmp(const void *a, const void *b)
> > > > +{
> > > > +	const char **str_a = (const char **) a;
> > > > +	const char **str_b = (const char **) b;
> > > > +
> > > > +	return strcmp(*str_a, *str_b);
> > > > +}
> > > > +
> > > > +struct kallsyms_data {
> > > > +	unsigned long *addrs;
> > > > +	const char **syms;
> > > > +	u32 cnt;
> > > > +	u32 found;
> > > > +};
> > > > +
> > > > +static int kallsyms_callback(void *data, const char *name,
> > > > +			     struct module *mod, unsigned long addr)
> > > > +{
> > > > +	struct kallsyms_data *args = data;
> > > > +
> > > > +	if (!bsearch(&name, args->syms, args->cnt, sizeof(*args->syms), symbols_cmp))
> > > > +		return 0;
> > > > +
> > > > +	addr = ftrace_location(addr);
> > > > +	if (!addr)
> > > > +		return 0;
> > > > +
> > > > +	args->addrs[args->found++] = addr;
> > > > +	return args->found == args->cnt ? 1 : 0;
> > > > +}
> > > > +
> > > > +int kallsyms_lookup_names(const char **syms, u32 cnt, unsigned long *addrs)
> > > > +{
> > > > +	struct kallsyms_data args;
> > > > +
> > > > +	sort(syms, cnt, sizeof(*syms), symbols_cmp, NULL);
> > > 
> > > It's nice to share symbols_cmp for sort and bsearch,
> > > but messing technically input argument 'syms' like this will cause
> > > issues sooner or later.
> > > Lets make caller do the sort.
> > > Unordered input will cause issue with bsearch, of course,
> > > but it's a lesser evil. imo.
> > > 
> > 
> > Masami,
> > this logic bubbles up to the register_fprobe_syms, because user
> > provides symbols as its argument. Can we still force this assumption
> > to the 'syms' array, like with the comment change below?
> > 
> > FYI the bpf side does not use register_fprobe_syms, it uses
> > register_fprobe_ips, because it always needs ips as search
> > base for cookie values
> 
> Hmm, in that case fprobe can call sort() in the register function.
> That will be much easier and safer. The bpf case, the input array will
> be generated by the bpftool (not by manual), so it can ensure the 
> syms is sorted. But we don't know how fprobe user passes syms array.
> Then register_fprobe_syms() will always requires sort(). I don't like
> such redundant requirements.

ok, I'll add it to register_fprobe_syms

thanks,
jirka

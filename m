Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3502A4FA00F
	for <lists+netdev@lfdr.de>; Sat,  9 Apr 2022 01:19:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236128AbiDHXVg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Apr 2022 19:21:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229609AbiDHXVf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Apr 2022 19:21:35 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70DB037A0E;
        Fri,  8 Apr 2022 16:19:29 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id ms15-20020a17090b234f00b001cb61350f05so568318pjb.5;
        Fri, 08 Apr 2022 16:19:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=bn4eTHEMHtj+XhCx+YKWl3KyotHUmULIJ5IozL6BDc0=;
        b=XrBwF/tXyxn5krStMXb3rr6ZppPn5hvUHjtlGYo8tLTCcm434GrOf37ubiJDEVrPlJ
         Fzkk2V0lx77EyggUC3a9StadWj5EZypHttK2Mh6jMC6jCWWkW66RRGYt9yQnu0JP+1E3
         h7wQVOaDT6wTtu8IKPjLqqykSWDrr2IMZZzrWF4JKUfmSmGHaYIkpyae//TCaCb2g99z
         I6+MIrCP2mhcvQjZRDHPFncABb5Nt6Zs4PckGk94kDKbjO1C072hQU206k4sJr5U7Th5
         8yHCDVsN2/Rh7WktfddlxY9rW4fz+7k60wWjm2O4+t6Gc/P/bU6JkeSTD8lL1HEBtllT
         SVKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=bn4eTHEMHtj+XhCx+YKWl3KyotHUmULIJ5IozL6BDc0=;
        b=dcaD7O5gey8yeHB6xc1smnyU/5WU3sZWfFsIPBcJdgtbZ/UtMJgGFSsw6PoofHzU57
         gQoMbn4H24Ec0yjdF6sqWKB1CVQtJz+qZcV4YbkZWkatCe7eOYsp8BoiPZnG60Mbz2Be
         j8vxKqbPRbHlJwjwl+8c/hToArNO/YE5KF3imw/KScLrjWuKbBc2OyYHuYdW0x4u7gRQ
         T5mFw1mi7c9fDzyRO2BSp/Xcc3ruGdPtmkbwUodPYpbH7cm/O2vbiejdVGrMiYFgZRq/
         1ubMWv4t8h9qEx1C4wDD4ZtMCe/7C1tkWJw/AoicFSvduBKjOzB1Xca/PUF6IIPIWXyL
         itvA==
X-Gm-Message-State: AOAM530NW8MJpjuXUFE8nKkbRcE/hDVu2fGOGwYWpvP74v0AxAYoKUKQ
        HRwV4u1Lwl0y3JHqiNjadYQ=
X-Google-Smtp-Source: ABdhPJzAUEPXmEU9O0yKWWJTpAUKbUc3W7L2TVYZyoVitvzGDX9oVKBIKitTnmBFGLqn0u875IwR0w==
X-Received: by 2002:a17:90b:1b0f:b0:1c6:ed78:67ad with SMTP id nu15-20020a17090b1b0f00b001c6ed7867admr24292074pjb.41.1649459968805;
        Fri, 08 Apr 2022 16:19:28 -0700 (PDT)
Received: from MBP-98dd607d3435.dhcp.thefacebook.com ([2620:10d:c090:400::5:4c4c])
        by smtp.gmail.com with ESMTPSA id d18-20020a056a0010d200b004fa2e13ce80sm28196885pfu.76.2022.04.08.16.19.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Apr 2022 16:19:28 -0700 (PDT)
Date:   Fri, 8 Apr 2022 16:19:25 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Jiri Olsa <jolsa@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
Subject: Re: [RFC bpf-next 1/4] kallsyms: Add kallsyms_lookup_names function
Message-ID: <20220408231925.uc2cfeev7p6nzfww@MBP-98dd607d3435.dhcp.thefacebook.com>
References: <20220407125224.310255-1-jolsa@kernel.org>
 <20220407125224.310255-2-jolsa@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220407125224.310255-2-jolsa@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 07, 2022 at 02:52:21PM +0200, Jiri Olsa wrote:
> Adding kallsyms_lookup_names function that resolves array of symbols
> with single pass over kallsyms.
> 
> The user provides array of string pointers with count and pointer to
> allocated array for resolved values.
> 
>   int kallsyms_lookup_names(const char **syms, u32 cnt,
>                             unsigned long *addrs)
> 
> Before we iterate kallsyms we sort user provided symbols by name and
> then use that in kalsyms iteration to find each kallsyms symbol in
> user provided symbols.
> 
> We also check each symbol to pass ftrace_location, because this API
> will be used for fprobe symbols resolving. This can be optional in
> future if there's a need.
> 
> Suggested-by: Andrii Nakryiko <andrii@kernel.org>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---
>  include/linux/kallsyms.h |  6 +++++
>  kernel/kallsyms.c        | 48 ++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 54 insertions(+)
> 
> diff --git a/include/linux/kallsyms.h b/include/linux/kallsyms.h
> index ce1bd2fbf23e..5320a5e77f61 100644
> --- a/include/linux/kallsyms.h
> +++ b/include/linux/kallsyms.h
> @@ -72,6 +72,7 @@ int kallsyms_on_each_symbol(int (*fn)(void *, const char *, struct module *,
>  #ifdef CONFIG_KALLSYMS
>  /* Lookup the address for a symbol. Returns 0 if not found. */
>  unsigned long kallsyms_lookup_name(const char *name);
> +int kallsyms_lookup_names(const char **syms, u32 cnt, unsigned long *addrs);
>  
>  extern int kallsyms_lookup_size_offset(unsigned long addr,
>  				  unsigned long *symbolsize,
> @@ -103,6 +104,11 @@ static inline unsigned long kallsyms_lookup_name(const char *name)
>  	return 0;
>  }
>  
> +int kallsyms_lookup_names(const char **syms, u32 cnt, unsigned long *addrs)
> +{
> +	return -ERANGE;
> +}
> +
>  static inline int kallsyms_lookup_size_offset(unsigned long addr,
>  					      unsigned long *symbolsize,
>  					      unsigned long *offset)
> diff --git a/kernel/kallsyms.c b/kernel/kallsyms.c
> index 79f2eb617a62..a3738ddf9e87 100644
> --- a/kernel/kallsyms.c
> +++ b/kernel/kallsyms.c
> @@ -29,6 +29,8 @@
>  #include <linux/compiler.h>
>  #include <linux/module.h>
>  #include <linux/kernel.h>
> +#include <linux/bsearch.h>
> +#include <linux/sort.h>
>  
>  /*
>   * These will be re-linked against their real values
> @@ -572,6 +574,52 @@ int sprint_backtrace_build_id(char *buffer, unsigned long address)
>  	return __sprint_symbol(buffer, address, -1, 1, 1);
>  }
>  
> +static int symbols_cmp(const void *a, const void *b)
> +{
> +	const char **str_a = (const char **) a;
> +	const char **str_b = (const char **) b;
> +
> +	return strcmp(*str_a, *str_b);
> +}
> +
> +struct kallsyms_data {
> +	unsigned long *addrs;
> +	const char **syms;
> +	u32 cnt;
> +	u32 found;
> +};
> +
> +static int kallsyms_callback(void *data, const char *name,
> +			     struct module *mod, unsigned long addr)
> +{
> +	struct kallsyms_data *args = data;
> +
> +	if (!bsearch(&name, args->syms, args->cnt, sizeof(*args->syms), symbols_cmp))
> +		return 0;
> +
> +	addr = ftrace_location(addr);
> +	if (!addr)
> +		return 0;
> +
> +	args->addrs[args->found++] = addr;
> +	return args->found == args->cnt ? 1 : 0;
> +}
> +
> +int kallsyms_lookup_names(const char **syms, u32 cnt, unsigned long *addrs)
> +{
> +	struct kallsyms_data args;
> +
> +	sort(syms, cnt, sizeof(*syms), symbols_cmp, NULL);

It's nice to share symbols_cmp for sort and bsearch,
but messing technically input argument 'syms' like this will cause
issues sooner or later.
Lets make caller do the sort.
Unordered input will cause issue with bsearch, of course,
but it's a lesser evil. imo.

> +
> +	args.addrs = addrs;
> +	args.syms = syms;
> +	args.cnt = cnt;
> +	args.found = 0;
> +	kallsyms_on_each_symbol(kallsyms_callback, &args);
> +
> +	return args.found == args.cnt ? 0 : -EINVAL;
> +}
> +
>  /* To avoid using get_symbol_offset for every symbol, we carry prefix along. */
>  struct kallsym_iter {
>  	loff_t pos;
> -- 
> 2.35.1
> 

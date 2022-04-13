Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 852E34FF08E
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 09:28:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233343AbiDMHaH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 03:30:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229718AbiDMHaF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 03:30:05 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 007D618E0C;
        Wed, 13 Apr 2022 00:27:44 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id ks6so2155675ejb.1;
        Wed, 13 Apr 2022 00:27:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=qwO5x8daEsKn7AJxj0XCIjFXgnsykAoMFtFOPr30/OY=;
        b=omH/vMEmEDVQszB0OIuSdTvi7p/jJXy6R7A4244H80S4k3+XRyMjfRgpMOFKczNheK
         0jy7I2xFnKdHegbsri9PY8EXS+4uFYoIGtYTxKnQ/I1UBHEt3e/74Tk+DLZwRfczFDpL
         4nNc2M9wLBIW/NcnCJpG3Nwg22ZUYnph1J536J98rJMFw4wSWrNNxwdCYDzXjpoELrb8
         AiYRB7OjbIX80I0M3LzLL+ukfZ3T35MEbZ7hX6tNFGAwytw5AuBCjFFIbH7dL7b1ku0X
         TxjTMYhCbTwQn0DDRcsEGgsEp0t2OHz72ifkKSR4lHRLVLybOQnppkwpv8o9RuAJmVOv
         jLaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=qwO5x8daEsKn7AJxj0XCIjFXgnsykAoMFtFOPr30/OY=;
        b=hWU0dyWKA1xacCZ4qhwUtkslimdEHXFO9Ni3Bcnlf3CgPV01Ma2A3n9CEQ1YQ3PaCD
         Bd//xRIshLJbJnj0sht+ZDFOkvrcU3wX5yh86LS2JEXdhGyDA5Sn+OgEUu8+xserxEqQ
         5AMdyvdw/5odPWi3aIJIb+djkIWAdPA5YbcaK4CFPNRwIr3LyBKkM0ht2aycDV+NhpUM
         NRHMNqElnj01RidwJrXJE26ZAWisW2pn2oKfWyTg5S/eBd4eGBFN05Syns8hJk/05m4Y
         zo00FTPVFul2shk+q6VFmTlgxz/qrch2yg/9Y2+wDgTmx3Szo1dIkDe/P0O/X/Ab8neo
         wY2g==
X-Gm-Message-State: AOAM533/g2UAUJnyRTCYTPjVzthlUr+PyxuPrwIRQi+sIbgi9yleF3+w
        UKA1a1ScYxgpo5o4jPDbbO0=
X-Google-Smtp-Source: ABdhPJymyC0Lf62J4fDfrOo+9dDUgyCYtUkNg5mcd26g90i1LvwiUVdLiE+l5WqgQs6DUMH4EFe2EQ==
X-Received: by 2002:a17:907:6093:b0:6e0:dabf:1a9f with SMTP id ht19-20020a170907609300b006e0dabf1a9fmr37979065ejc.424.1649834863420;
        Wed, 13 Apr 2022 00:27:43 -0700 (PDT)
Received: from krava ([83.240.62.142])
        by smtp.gmail.com with ESMTPSA id q3-20020a5085c3000000b0041d7958ae70sm831859edh.25.2022.04.13.00.27.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Apr 2022 00:27:43 -0700 (PDT)
Date:   Wed, 13 Apr 2022 09:27:40 +0200
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
Subject: Re: [RFC bpf-next 1/4] kallsyms: Add kallsyms_lookup_names function
Message-ID: <YlZ7bAY1lDQWxUgH@krava>
References: <20220407125224.310255-1-jolsa@kernel.org>
 <20220407125224.310255-2-jolsa@kernel.org>
 <20220408095701.54aea15c3cafcf66dd628a95@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220408095701.54aea15c3cafcf66dd628a95@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 08, 2022 at 09:57:01AM +0900, Masami Hiramatsu wrote:

SNIP

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
> 
> BTW, why do you use 'u32' for this arch independent code?
> I think 'size_t' will make its role clearer.

right, will change

> 
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
> 
> Ditto. I think 'size_t cnt' is better. 

ok, thanks

jirka

> 
> Thank you,
> 
> > +{
> > +	struct kallsyms_data args;
> > +
> > +	sort(syms, cnt, sizeof(*syms), symbols_cmp, NULL);
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
> 
> 
> -- 
> Masami Hiramatsu <mhiramat@kernel.org>

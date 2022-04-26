Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1075F50FCE1
	for <lists+netdev@lfdr.de>; Tue, 26 Apr 2022 14:27:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348884AbiDZMaR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Apr 2022 08:30:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346338AbiDZMaP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Apr 2022 08:30:15 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1602D69295;
        Tue, 26 Apr 2022 05:27:08 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id a1so16475255edt.3;
        Tue, 26 Apr 2022 05:27:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=tUQrxavB/ZORPEFYd+g4E581It2+tjHhQ0R1hZx9kac=;
        b=ZnPrsRi62/v9HJsUi4Io169wkYw6Jp8qgNE3yXWsPNEEN5M9eq6mDaWoAwCjEk57an
         i782RzuCMHROIBq0PmkvwV+YGs2buzhiKFjw23X2LvnUUwrdCBf/cBLFaUV3hOiGlZC6
         VqjVpFP+Ee1Du4rVfPV0vkjq2JxdQf3Ah8AariZPWrmpyZFUsaHJro3PjKJea6Jd4SU+
         o2+BvS/117XPWgc6zkOm04bYuYobvkK81T4sIIigD86ILimXZK4f1QsdIkT45rXC+3oP
         6kl3XV79k/YRrh4i4KDhD9eKv8OzdfSMrxQE8N5k8LNUls55O/3JVBsTI9AnyM/hO4ZA
         RuZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=tUQrxavB/ZORPEFYd+g4E581It2+tjHhQ0R1hZx9kac=;
        b=LWt2JuprMXW9+YYtu7spVX6S3MLgqX58souXzUrl4ShOzEmZnaNzwId8fiXJYbxV0I
         P5I2oRh2cUkqhEa2CPMUj1/BXDmDDSoZhtg9DxyqvcWNNJ1rpM+tPA0LA9qNjbdwEhLS
         1rCv0fw1GAg9nrTvAmhXFMiUGFA9C6rnnpwGBQQX0a6W/ruqqZScPl8x2brNIz4etLa6
         xV34dxgcStbqCGkKZwlvJmiiPZARZEj88/42kV3xt9TDxNHMW91XCCq94qUDDTkCaw07
         BcLBTGmOmFWZhtunfZOSoNyLTtC0GmdJWCWlQmSJ4H7h5P3P8lriauGLYGLKcok7izo4
         0z5A==
X-Gm-Message-State: AOAM531L79vRkBXeBVu+4mdtsRnlp0FUOKTdfGWshpdhPqQdnVWksg26
        HMk4WA13OpfYnztLpZHfhuE=
X-Google-Smtp-Source: ABdhPJya0Jw62MjF+PG5dCtkf26KarZPuivNh7Vg8KYNoMVUS9wIwNXKm932IfOH8VJ4hUeS4w7CQQ==
X-Received: by 2002:a05:6402:1d90:b0:425:dd36:447c with SMTP id dk16-20020a0564021d9000b00425dd36447cmr13616178edb.347.1650976026463;
        Tue, 26 Apr 2022 05:27:06 -0700 (PDT)
Received: from krava ([193.85.244.190])
        by smtp.gmail.com with ESMTPSA id e26-20020a50a69a000000b00425c11446fasm5894150edc.3.2022.04.26.05.27.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Apr 2022 05:27:05 -0700 (PDT)
Date:   Tue, 26 Apr 2022 14:27:04 +0200
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
Message-ID: <YmflGEbjkp8mynxK@krava>
References: <20220418124834.829064-1-jolsa@kernel.org>
 <20220418124834.829064-2-jolsa@kernel.org>
 <20220418233546.dfe0a1be12193c26b05cdd93@kernel.org>
 <Yl5yHVOJpCYr+T3r@krava>
 <YmJPcU9dahEatb0f@krava>
 <20220426190108.d9c76f5ccff52e27dbef21af@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220426190108.d9c76f5ccff52e27dbef21af@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 26, 2022 at 07:01:08PM +0900, Masami Hiramatsu wrote:
> Hi Jiri,
> 
> Sorry for replying late.
> 
> On Fri, 22 Apr 2022 08:47:13 +0200
> Jiri Olsa <olsajiri@gmail.com> wrote:
> 
> > On Tue, Apr 19, 2022 at 10:26:05AM +0200, Jiri Olsa wrote:
> > 
> > SNIP
> > 
> > > > > +static int kallsyms_callback(void *data, const char *name,
> > > > > +			     struct module *mod, unsigned long addr)
> > > > > +{
> > > > > +	struct kallsyms_data *args = data;
> > > > > +
> > > > > +	if (!bsearch(&name, args->syms, args->cnt, sizeof(*args->syms), symbols_cmp))
> > > > > +		return 0;
> > > > > +
> > > > > +	addr = ftrace_location(addr);
> > > > > +	if (!addr)
> > > > > +		return 0;
> > > > 
> > > > Ooops, wait. Did you do this last version? I missed this point.
> > > > This changes the meanings of the kernel function.
> > > 
> > > yes, it was there before ;-) and you're right.. so some archs can
> > > return different address, I did not realize that
> > > 
> > > > 
> > > > > +
> > > > > +	args->addrs[args->found++] = addr;
> > > > > +	return args->found == args->cnt ? 1 : 0;
> > > > > +}
> > > > > +
> > > > > +/**
> > > > > + * kallsyms_lookup_names - Lookup addresses for array of symbols
> > > > 
> > > > More correctly "Lookup 'ftraced' addresses for array of sorted symbols", right?
> > > > 
> > > > I'm not sure, we can call it as a 'kallsyms' API, since this is using
> > > > kallsyms but doesn't return symbol address, but ftrace address.
> > > > I think this name misleads user to expect returning symbol address.
> > > > 
> > > > > + *
> > > > > + * @syms: array of symbols pointers symbols to resolve, must be
> > > > > + * alphabetically sorted
> > > > > + * @cnt: number of symbols/addresses in @syms/@addrs arrays
> > > > > + * @addrs: array for storing resulting addresses
> > > > > + *
> > > > > + * This function looks up addresses for array of symbols provided in
> > > > > + * @syms array (must be alphabetically sorted) and stores them in
> > > > > + * @addrs array, which needs to be big enough to store at least @cnt
> > > > > + * addresses.
> > > > 
> > > > Hmm, sorry I changed my mind. I rather like to expose kallsyms_on_each_symbol()
> > > > and provide this API from fprobe or ftrace, because this returns ftrace address
> > > > and thus this is only used from fprobe.
> > > 
> > > ok, so how about:
> > > 
> > >   int ftrace_lookup_symbols(const char **sorted_syms, size_t cnt, unsigned long *addrs);
> > 
> > quick question.. is it ok if it stays in kalsyms.c object?
> 
> I think if this is for the ftrace API, I think it should be in the ftrace.c, and
> it can remove unneeded #ifdefs in C code.
> 
> > 
> > so we don't need to expose kallsyms_on_each_symbol,
> > and it stays in 'kalsyms' place
> 
> We don't need to expose it to modules, but just make it into a global scope.
> I don't think that doesn't cause a problem.

np, will move it to ftrace

thanks,
jirka

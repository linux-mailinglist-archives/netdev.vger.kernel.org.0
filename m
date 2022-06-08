Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C87F543775
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 17:34:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243506AbiFHPdJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 11:33:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242477AbiFHPdI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 11:33:08 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A355C7B;
        Wed,  8 Jun 2022 08:33:07 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id u12so42225536eja.8;
        Wed, 08 Jun 2022 08:33:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=J4IcVQmCWbsMmkdxbOmYq0AW116qw3cDv81nRHPjJ3A=;
        b=nAbUaLgYFng5Ob23XvU9j6AJ66VuiisUeEu7k2SypVaJxBLm2SauII2aAwjvMNaJ40
         aOVlapNJdp+g3fOjyFqTXQTK4AiTW1CiTD3yXfBIwbFL1IQK4oqOkLzT1/zaeACtrexZ
         jCX+170X3D4kZ5S1bCwgnKx79WfqsC3ceLqjVukJKXhwRMSWgDHg9uMjAMJAMU5vP4hY
         HJZy4YmH0XlpyAm5hSk2OxOnDF3cxUHoT13NBXwzXLa0Y/PsUCWvRUp7TW4eUXfcloIY
         A62I297ZEYDmo4xBaX7jTjv8pdZxRCXvNUHyJhdJusBbTutov5rfRVBPorOEYN0TAAnJ
         RGpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=J4IcVQmCWbsMmkdxbOmYq0AW116qw3cDv81nRHPjJ3A=;
        b=FVjfvhakIgh1Wpj6KfrJagEhae49ATVB8nDr7XuGKdanuOJrwETfDP0WLRd9WHZQul
         cUNhduDdjeqjCgp0ipg6vqqGrz/1TxHFNs1wPu5e8dwy7oLlvIAw+ct0rjCmNoKekWzP
         yTDbZYdzTxwZ4jO2uwMGF9ZU27AleiO55WJE0xpFW86YzkuswuCwlgFTgfUOpHcCgeCv
         2tjAtjLakHvsysb+5gl3tqpseGekMsY6yWaJY2TWM/BFgxDQSZmngg+7H9gn/H2kVBfo
         6pLywR1sOod5qjRD6We/wDaTFABbcljclm5DqPOyUjIwS7B9ayXlkWBSCUG0co+lx2et
         21aw==
X-Gm-Message-State: AOAM530z32wT/ehpjHDe//RHKvOnO8gC/PaS+S3rU+JvC4Xfwm2N4Nx5
        NIT0dYqROqkKNcuBuGE8OuE=
X-Google-Smtp-Source: ABdhPJxp0RDinIIVrI6tGQUw7UnAGVvNgwa+XnK0oFzjTnVCRXrq+wou7h2dju79aKzrgo9LBJ7V4g==
X-Received: by 2002:a17:906:4787:b0:711:d085:88a3 with SMTP id cw7-20020a170906478700b00711d08588a3mr14311805ejc.118.1654702385752;
        Wed, 08 Jun 2022 08:33:05 -0700 (PDT)
Received: from krava ([193.85.244.190])
        by smtp.gmail.com with ESMTPSA id cn26-20020a0564020cba00b0042e0385e724sm11453742edb.40.2022.06.08.08.33.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jun 2022 08:33:05 -0700 (PDT)
From:   Jiri Olsa <olsajiri@gmail.com>
X-Google-Original-From: Jiri Olsa <jolsa@kernel.org>
Date:   Wed, 8 Jun 2022 17:33:02 +0200
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Jiri Olsa <olsajiri@gmail.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Masami Hiramatsu <mhiramat@kernel.org>
Subject: Re: [PATCHv2 bpf 3/3] bpf: Force cookies array to follow symbols
 sorting
Message-ID: <YqDBLrJ2OX4d4ns4@krava>
References: <20220606184731.437300-1-jolsa@kernel.org>
 <20220606184731.437300-4-jolsa@kernel.org>
 <CAADnVQJA54Ra8+tV0e0KwSXAg93JRoiefDXWR-Lqatya5YWKpg@mail.gmail.com>
 <Yp+tTsqPOuVdjpba@krava>
 <CAADnVQJGoM9eqcODx2LGo-qLo0=O05gSw=iifRsWXgU0XWifAA@mail.gmail.com>
 <YqBW65t+hlWNok8e@krava>
 <YqBynO64am32z13X@krava>
 <20220608084023.4be8ffe2@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220608084023.4be8ffe2@gandalf.local.home>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 08, 2022 at 08:40:23AM -0400, Steven Rostedt wrote:
> On Wed, 8 Jun 2022 11:57:48 +0200
> Jiri Olsa <olsajiri@gmail.com> wrote:
> 
> > Steven,
> > is there a reason to show '__ftrace_invalid_address___*' symbols in
> > available_filter_functions? it seems more like debug message to me
> > 
> 
> Yes, because set_ftrace_filter may be set by index. That is, if schedule is
> the 43,245th entry in available_filter_functions, then you can do:
> 
>   # echo 43245 > set_ftrace_filter
>   # cat set_ftrace_filter
>   schedule
> 
> That index must match the array index of the entries in the function list
> internally. The reason for this is that entering a name is an O(n)
> operation, where n is the number of functions in
> available_filter_functions. If you want to enable half of those functions,
> then it takes O(n^2) to do so.
> 
> I first implemented this trick to help with bisecting bad functions. That
> is, every so often a function that should be annotated with notrace, isn't
> and if it gets traced it cause the machine to reboot. To bisect this, I
> would enable half the functions at a time and enable tracing to see if it
> reboots or not, and if it does, I know that one of the half I enabled is
> the culprit, if not, it's in the other half. It would take over 5 minutes
> to enable half the functions. Where as the number trick took one second,
> not only was it O(1) per function, but it did not need to do kallsym
> lookups either. It simply enabled the function at the index.
> 
> Later, libtracefs (used by trace-cmd and others) would allow regex(3)
> enabling of functions. That is, it would search available_filter_functions
> in user space, match them via normal regex, create an index of the
> functions to know where they are, and then write in those numbers to enable
> them. It's much faster than writing in strings.
> 
> My original fix was to simply ignore those functions, but then it would
> make the index no longer match what got set. I noticed this while writing
> my slides for Kernel Recipes, and then fixed it.
> 
> The commit you mention above even states this:
> 
>       __ftrace_invalid_address___<invalid-offset>
>     
>     (showing the offset that caused it to be invalid).
>     
>     This is required for tools that use libtracefs (like trace-cmd does) that
>     scan the available_filter_functions and enable set_ftrace_filter and
>     set_ftrace_notrace using indexes of the function listed in the file (this
>     is a speedup, as enabling thousands of files via names is an O(n^2)
>     operation and can take minutes to complete, where the indexing takes less
>     than a second).
> 
> In other words, having a placeholder is required to keep from breaking user
> space.

ok, we'll have to workaround that then

thanks,
jirka

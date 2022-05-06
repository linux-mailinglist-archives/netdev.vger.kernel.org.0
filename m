Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B70E51E192
	for <lists+netdev@lfdr.de>; Sat,  7 May 2022 00:15:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1444681AbiEFWSk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 May 2022 18:18:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241939AbiEFWSj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 May 2022 18:18:39 -0400
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D5C06540F;
        Fri,  6 May 2022 15:14:54 -0700 (PDT)
Received: by mail-io1-xd2d.google.com with SMTP id e3so9521370ios.6;
        Fri, 06 May 2022 15:14:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rCTLTbLP/HCPwEyRHnS4Xntt1B1zffntB8D6OmsmIYM=;
        b=pg0/Yt3QJEJeyRkqIy1cKjUnl4Q5IC5OVFEgPVFVI9uYOt7Xmm7edvsl6gBEjCELEg
         SnFEiHqFqtJNoimavdRivrQjd4ET896Y+7gS9WthGdnonHoggAlP9MkvbgbP6KcJMIQl
         YiQ0o0q2L55cEB6cjE892PJ3+EiEAMxf9ocexcwjUGMYC//ZCMkg/ArE9S/uU5/bN94+
         zToBvUNywhFlS719I9+9aq7K/fkCLLnebbKWxol21h11RibuL5bzBKeS/i2GsyXDmcIk
         rBHYqK3W9jk/APsnpp+ivf6nQ8PcPYp76lKw6ULV4lYD7s1gQQ+RYnIi8T821cOhijoG
         bRAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rCTLTbLP/HCPwEyRHnS4Xntt1B1zffntB8D6OmsmIYM=;
        b=QE1ZPlHhmfmfyaUe41Zlp99F0TlYN5cqXwHXfxtk1cWEPrvMul4AMQr1kZ/bFK0D+q
         RBsRgwxZO8Ydrs+Rc/NCdgGLOT7RwMOJH72Pa7Df+nKwNRRTGaKbo/at2/bhtUubhIJD
         LSuuFT9OM2Feu7BZa2Lwy9WkcJT1RL+32+txfq5S5JHVaSCrThhDs5uwb0vWTQpJ4jnc
         Afq+DOz83nXufHY3Nbb88h7O8/iNDTpXDYY4rfEp6s0jgt+08m0Zg8qsxF6ca0v91M7J
         xr5y8dh0s+kXomn2D1YG9BiRgUf7cFEs6A5mWt1KZNbB4nWTLTU5Yw6SYmOwBW1jzVFX
         xjUw==
X-Gm-Message-State: AOAM5332SyDtiWvYTLnVv2Au1cdbR5oiox3VIDj4HJC5xQcWDTVyODht
        qDDBr/1nUF+yFKnWMwH80AK7+xKjm7jV8h+a+QC9goWp
X-Google-Smtp-Source: ABdhPJx6cH8/kFAVuNSsKGTXPt73jPWXP1ujELpoKsSM82Mr15WnMzNVpnAQdo4BtqYozrL8n+V7/jh3uk/FDntTVvk=
X-Received: by 2002:a05:6638:33a1:b0:32b:8e2b:f9ba with SMTP id
 h33-20020a05663833a100b0032b8e2bf9bamr2370798jav.93.1651875293774; Fri, 06
 May 2022 15:14:53 -0700 (PDT)
MIME-Version: 1.0
References: <20220503150410.2d9e88aa@rorschach.local.home>
In-Reply-To: <20220503150410.2d9e88aa@rorschach.local.home>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 6 May 2022 15:14:43 -0700
Message-ID: <CAEf4BzYJan2c0oy-eww++VC57ak=+QOt6a9SWUT1M__AKF8VSA@mail.gmail.com>
Subject: Re: : [PATCH] ftrace/x86: Add FTRACE_MCOUNT_MAX_OFFSET to avoid
 adding weak functions
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Jiri Olsa <jolsa@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Peter Zijlstra <peterz@infradead.org>, X86 ML <x86@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 3, 2022 at 12:04 PM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> From: "Steven Rostedt (Google)" <rostedt@goodmis.org>
>
> If an unused weak function was traced, it's call to fentry will still
> exist, which gets added into the __mcount_loc table. Ftrace will use
> kallsyms to retrieve the name for each location in __mcount_loc to display
> it in the available_filter_functions and used to enable functions via the
> name matching in set_ftrace_filter/notrace. Enabling these functions do
> nothing but enable an unused call to ftrace_caller. If a traced weak
> function is overridden, the symbol of the function would be used for it,
> which will either created duplicate names, or if the previous function was
> not traced, it would be incorrectly listed in available_filter_functions
> as a function that can be traced.
>
> This became an issue with BPF[1] as there are tooling that enables the
> direct callers via ftrace but then checks to see if the functions were
> actually enabled. The case of one function that was marked notrace, but
> was followed by an unused weak function that was traced. The unused
> function's call to fentry was added to the __mcount_loc section, and
> kallsyms retrieved the untraced function's symbol as the weak function was
> overridden. Since the untraced function would not get traced, the BPF
> check would detect this and fail.
>
> The real fix would be to fix kallsyms to not show address of weak
> functions as the function before it. But that would require adding code in
> the build to add function size to kallsyms so that it can know when the
> function ends instead of just using the start of the next known symbol.
>
> In the mean time, this is a work around. Add a FTRACE_MCOUNT_MAX_OFFSET
> macro that if defined, ftrace will ignore any function that has its call
> to fentry/mcount that has an offset from the symbol that is greater than
> FTRACE_MCOUNT_MAX_OFFSET.
>
> If CONFIG_HAVE_FENTRY is defined for x86, define FTRACE_MCOUNT_MAX_OFFSET
> to zero, which will have ftrace ignore all locations that are not at the
> start of the function.
>
> [1] https://lore.kernel.org/all/20220412094923.0abe90955e5db486b7bca279@kernel.org/
>
> Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
> ---
>  arch/x86/include/asm/ftrace.h |  5 ++++
>  kernel/trace/ftrace.c         | 50 +++++++++++++++++++++++++++++++++--
>  2 files changed, 53 insertions(+), 2 deletions(-)
>

Thanks for investigating and fixing this! I guess we'll need ENDBR
handling, but otherwise it looks good to me!

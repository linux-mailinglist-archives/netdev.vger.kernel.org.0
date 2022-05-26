Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFC8A534FC7
	for <lists+netdev@lfdr.de>; Thu, 26 May 2022 15:11:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234963AbiEZNLN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 May 2022 09:11:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231279AbiEZNLM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 May 2022 09:11:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F538B4AD;
        Thu, 26 May 2022 06:11:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8C89C61A9C;
        Thu, 26 May 2022 13:11:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33A4BC385A9;
        Thu, 26 May 2022 13:11:08 +0000 (UTC)
Date:   Thu, 26 May 2022 09:11:06 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Ingo Molnar <mingo@kernel.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Jiri Olsa <jolsa@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Peter Zijlstra <peterz@infradead.org>, x86@kernel.org
Subject: Re: [PATCH v2] ftrace: Add FTRACE_MCOUNT_MAX_OFFSET to avoid adding
 weak function
Message-ID: <20220526091106.1eb2287a@gandalf.local.home>
In-Reply-To: <Yo7q6dwphFexGuRA@gmail.com>
References: <20220525180553.419eac77@gandalf.local.home>
        <Yo7q6dwphFexGuRA@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 26 May 2022 04:50:17 +0200
Ingo Molnar <mingo@kernel.org> wrote:


> > The real fix would be to fix kallsyms to not show address of weak
> > functions as the function before it. But that would require adding code in
> > the build to add function size to kallsyms so that it can know when the
> > function ends instead of just using the start of the next known symbol.  
> 
> Yeah, so I actually have a (prototype...) objtool based kallsyms 
> implementation in the (way too large) fast-headers tree that is both faster 
> & allows such details in principle:

Nice.

Will this work for other architectures too?

> > If CONFIG_HAVE_FENTRY is defined for x86, define FTRACE_MCOUNT_MAX_OFFSET
> > to zero, which will have ftrace ignore all locations that are not at the
> > start of the function.
> > 
> > [1] https://lore.kernel.org/all/20220412094923.0abe90955e5db486b7bca279@kernel.org/
> > 
> > Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>  
> 
> LGTM.
> 
> I suppose you'd like to merge this via the tracing tree? If so:

Yeah, I'll pull it through my tree.

> 
>   Acked-by: Ingo Molnar <mingo@kernel.org>

Thanks a lot Ingo for reviewing it. I really appreciate it!

-- Steve

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62B03554024
	for <lists+netdev@lfdr.de>; Wed, 22 Jun 2022 03:41:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355672AbiFVBlR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jun 2022 21:41:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230152AbiFVBlQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jun 2022 21:41:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA7222F39E;
        Tue, 21 Jun 2022 18:41:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 702B2B81995;
        Wed, 22 Jun 2022 01:41:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 163D4C3411C;
        Wed, 22 Jun 2022 01:41:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655862072;
        bh=hplP8TJkxJ6SMYk8fdGq+m1YJeqgd88J3suV7yMIQOI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Q9TP6smK3aUawI7pK8XGkes/9Saq6FMZooxxBsX7wvAkF2BciKH1qRkJ3o0nHh0rN
         SvWpbILlDbU8p9/9w498cXDR1I5vje5aj6j0oARoMbixjqzSM7Q8Uthf+gYdV7fjPP
         d72lRw+rJpIv2mxuIAkrfLTGwzUr3mvxPLxShM/k6vUfAW1sgO5PxV91LbwBLj6Zb/
         f2oEAUZGPUk0bgrJAdm+WbLFZ9tg91aWc5szKFElWnIUW2TvfQgHKr0Rwv57owsy59
         CeLS8T+toIFA6iIfziwS4itK2gIGYY5nKivahlBS+P5fKvD397/pjp0GgegH/z1LGs
         w7HHgUtxDMWyg==
Date:   Wed, 22 Jun 2022 10:41:08 +0900
From:   Masami Hiramatsu (Google) <mhiramat@kernel.org>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Jiri Olsa <jolsa@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH bpf v2 1/2] fprobe: samples: Add use_trace option and
 show hit/missed counter
Message-Id: <20220622104108.3a1cf1ac050eccba0ee2ef6b@kernel.org>
In-Reply-To: <20220617120651.1e525a02@gandalf.local.home>
References: <165461825202.280167.12903689442217921817.stgit@devnote2>
        <165461826247.280167.11939123218334322352.stgit@devnote2>
        <20220617120651.1e525a02@gandalf.local.home>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 17 Jun 2022 12:06:51 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> On Wed,  8 Jun 2022 01:11:02 +0900
> "Masami Hiramatsu (Google)" <mhiramat@kernel.org> wrote:
> 
> >  
> >  static void sample_entry_handler(struct fprobe *fp, unsigned long ip, struct pt_regs *regs)
> >  {
> > -	pr_info("Enter <%pS> ip = 0x%p\n", (void *)ip, (void *)ip);
> > +	if (use_trace)
> > +		trace_printk("Enter <%pS> ip = 0x%p\n", (void *)ip, (void *)ip);
> 
> Could we add a comment stating something like "this is just an example, no
> kernel code should call trace_printk() except when actively debugging".

Indeed. I also add a description for this option so that user can
understand this is just a debug option.

Thank you,


-- 
Masami Hiramatsu (Google) <mhiramat@kernel.org>

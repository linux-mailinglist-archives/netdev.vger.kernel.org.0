Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0AA5536CFA
	for <lists+netdev@lfdr.de>; Sat, 28 May 2022 14:52:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235504AbiE1Mws (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 May 2022 08:52:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235477AbiE1Mwr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 May 2022 08:52:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9349FDEF5;
        Sat, 28 May 2022 05:52:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 26CB160EBB;
        Sat, 28 May 2022 12:52:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBB13C34100;
        Sat, 28 May 2022 12:52:41 +0000 (UTC)
Date:   Sat, 28 May 2022 08:52:40 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Jiri Olsa <jolsa@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, x86@kernel.org
Subject: Re: [PATCH v4] ftrace: Add FTRACE_MCOUNT_MAX_OFFSET to avoid adding
 weak function
Message-ID: <20220528085240.6f9238f2@gandalf.local.home>
In-Reply-To: <YpIKdfPYrztMLOep@hirez.programming.kicks-ass.net>
References: <20220526141912.794c2786@gandalf.local.home>
        <20220527083043.022e8e36@gandalf.local.home>
        <YpIKdfPYrztMLOep@hirez.programming.kicks-ass.net>
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

On Sat, 28 May 2022 13:41:41 +0200
Peter Zijlstra <peterz@infradead.org> wrote:

> In what order does available_filter_functions print the symbols?
> 
> The pending FGKASLR patches randomize kallsyms order and anything that
> prints symbols in address order will be a security leak.

Yes it is sorted, but tracefs is by default root accessible only.

An admin can change the owner of it via normal chmod/chown permissions, but
they get to keep the security pieces if they do.

There's other things in tracefs that can pose security issues if
unprivileged users are allowed to read, which is why the default permissions
of files is rw-r----. 

Thus, I'm not worried about it. And why the security paranoid can always
lockdown tracing, which will completely disable tracefs and access to all
its files.

-- Steve

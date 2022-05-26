Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F30E05350EC
	for <lists+netdev@lfdr.de>; Thu, 26 May 2022 16:44:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237410AbiEZOom (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 May 2022 10:44:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344542AbiEZOok (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 May 2022 10:44:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FDB0D8088;
        Thu, 26 May 2022 07:44:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0124CB820F7;
        Thu, 26 May 2022 14:44:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0B02C34114;
        Thu, 26 May 2022 14:44:31 +0000 (UTC)
Date:   Thu, 26 May 2022 10:44:30 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
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
Subject: Re: [PATCH v3] ftrace: Add FTRACE_MCOUNT_MAX_OFFSET to avoid adding
 weak functions
Message-ID: <20220526104430.7e6456a2@gandalf.local.home>
In-Reply-To: <20220526103810.026560dd@gandalf.local.home>
References: <20220526103810.026560dd@gandalf.local.home>
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

On Thu, 26 May 2022 10:38:10 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> +++ b/arch/x86/include/asm/ftrace.h
> @@ -9,6 +9,11 @@
>  # define MCOUNT_ADDR		((unsigned long)(__fentry__))
>  #define MCOUNT_INSN_SIZE	5 /* sizeof mcount call */
>  
> +/* Ignore unused weak functions which will have non zero offsets */
> +#ifdef CONFIG_HAVE_FENTRY
> +# define FTRACE_MCOUNT_MAX_OFFSET	0
> +#endif
> +

I screwed up this patch. Please ignore.

And Peter just informed me that IBT is in 5.18 already, and not 5.19. So,
I'll add his suggestion in v4.

-- Steve

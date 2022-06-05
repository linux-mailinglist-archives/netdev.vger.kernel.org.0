Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FE3B53DD2F
	for <lists+netdev@lfdr.de>; Sun,  5 Jun 2022 18:51:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346205AbiFEQv3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jun 2022 12:51:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232839AbiFEQv1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Jun 2022 12:51:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4A094DF7F;
        Sun,  5 Jun 2022 09:51:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7A88361141;
        Sun,  5 Jun 2022 16:51:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE50DC385A5;
        Sun,  5 Jun 2022 16:51:24 +0000 (UTC)
Date:   Sun, 5 Jun 2022 12:51:22 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Jiri Olsa <jolsa@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Masami Hiramatsu <mhiramat@kernel.org>
Subject: Re: [PATCH bpf-next 2/3] ftrace: Keep address offset in
 ftrace_lookup_symbols
Message-ID: <20220605125122.7b0e5b52@rorschach.local.home>
In-Reply-To: <20220527205611.655282-3-jolsa@kernel.org>
References: <20220527205611.655282-1-jolsa@kernel.org>
        <20220527205611.655282-3-jolsa@kernel.org>
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

On Fri, 27 May 2022 22:56:10 +0200
Jiri Olsa <jolsa@kernel.org> wrote:

> @@ -8017,6 +8025,7 @@ int ftrace_lookup_symbols(const char **sorted_syms, size_t cnt, unsigned long *a
>  	struct kallsyms_data args;
>  	int err;
>  
> +	memset(addrs, 0x0, sizeof(*addrs) * cnt);

Nit, but you don't need the "0x".

-- Steve

>  	args.addrs = addrs;
>  	args.syms = sorted_syms;
>  	args.cnt = cnt;
> -- 

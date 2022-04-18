Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C8DA505D8C
	for <lists+netdev@lfdr.de>; Mon, 18 Apr 2022 19:33:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347130AbiDRRgS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Apr 2022 13:36:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241994AbiDRRgP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Apr 2022 13:36:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2027B2E9FD;
        Mon, 18 Apr 2022 10:33:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C95DEB81057;
        Mon, 18 Apr 2022 17:33:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A083C385A7;
        Mon, 18 Apr 2022 17:33:31 +0000 (UTC)
Date:   Mon, 18 Apr 2022 13:33:30 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Masami Hiramatsu <mhiramat@kernel.org>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
Subject: Re: [RFC bpf-next 4/4] selftests/bpf: Add attach bench test
Message-ID: <20220418133330.6241014c@gandalf.local.home>
In-Reply-To: <20220416232103.c0b241c2ec7f2b3b985a2f99@kernel.org>
References: <20220407125224.310255-1-jolsa@kernel.org>
        <20220407125224.310255-5-jolsa@kernel.org>
        <CAEf4BzbE1n3Lie+tWTzN69RQUWgjxePorxRr9J8CuiQVUfy-kA@mail.gmail.com>
        <20220412094923.0abe90955e5db486b7bca279@kernel.org>
        <CAEf4BzaQRcZGMqq5wqHo3wSHZAAVvY6AhizDk_dV_GtnwHuxLQ@mail.gmail.com>
        <20220416232103.c0b241c2ec7f2b3b985a2f99@kernel.org>
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

On Sat, 16 Apr 2022 23:21:03 +0900
Masami Hiramatsu <mhiramat@kernel.org> wrote:

> But it seems that __bpf_tramp_exit() doesn't call __fentry__. (I objdump'ed) 
> 
> ffffffff81208270 <__bpf_tramp_exit>:
> ffffffff81208270:       55                      push   %rbp
> ffffffff81208271:       48 89 e5                mov    %rsp,%rbp
> ffffffff81208274:       53                      push   %rbx
> ffffffff81208275:       48 89 fb                mov    %rdi,%rbx
> ffffffff81208278:       e8 83 70 ef ff          callq  ffffffff810ff300 <__rcu_read_lock>
> ffffffff8120827d:       31 d2                   xor    %edx,%edx
> 
> 
> > 
> > So it's quite bizarre and inconsistent.  
> 
> Indeed. I guess there is a bug in scripts/recordmcount.pl.

Actually, x86 doesn't use that script. It either uses the C version, or
with latest gcc, it is created by the compiler itself.

I'll look deeper into it.

-- Steve

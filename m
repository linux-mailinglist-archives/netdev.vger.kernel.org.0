Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9CD54FFBEE
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 18:59:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237122AbiDMRBd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 13:01:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233651AbiDMRBd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 13:01:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96F916A047;
        Wed, 13 Apr 2022 09:59:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5690EB825F0;
        Wed, 13 Apr 2022 16:59:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3B12C385A3;
        Wed, 13 Apr 2022 16:59:07 +0000 (UTC)
Date:   Wed, 13 Apr 2022 12:59:06 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Masami Hiramatsu <mhiramat@kernel.org>,
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
Message-ID: <20220413125906.1689c3e2@rorschach.local.home>
In-Reply-To: <CAEf4BzaA+vr6V24dG7JCHHmedp2TcJv4ZnuKB=zXzuOpi-QYFg@mail.gmail.com>
References: <20220407125224.310255-1-jolsa@kernel.org>
        <20220407125224.310255-5-jolsa@kernel.org>
        <CAEf4BzbE1n3Lie+tWTzN69RQUWgjxePorxRr9J8CuiQVUfy-kA@mail.gmail.com>
        <20220412094923.0abe90955e5db486b7bca279@kernel.org>
        <20220413124419.002abd87@rorschach.local.home>
        <CAEf4BzaA+vr6V24dG7JCHHmedp2TcJv4ZnuKB=zXzuOpi-QYFg@mail.gmail.com>
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

On Wed, 13 Apr 2022 09:45:52 -0700
Andrii Nakryiko <andrii.nakryiko@gmail.com> wrote:

> > Did you only use the "notrace" on the prototype? I see the semicolon at
> > the end of your comment. It only affects the actual function itself,
> > not the prototype.  
> 
> notrace is both on declaration and on definition, see kernel/bpf/trampoline.c:

OK. Note, it only needs to be on the function, the prototype doesn't do
anything. But that shouldn't be the issue.

> 
> void notrace __bpf_tramp_exit(struct bpf_tramp_image *tr)
> {
>         percpu_ref_put(&tr->pcref);
> }
> 

What compiler are you using? as this seems to be a compiler bug.
Because it's not ftrace that picks what functions to trace, but the
compiler itself.

-- Steve



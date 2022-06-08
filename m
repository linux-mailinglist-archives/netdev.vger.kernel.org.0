Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB634543865
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 18:08:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244736AbiFHQIh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 12:08:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240123AbiFHQIf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 12:08:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86E3F1C5D5C;
        Wed,  8 Jun 2022 09:08:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2DDE6617D6;
        Wed,  8 Jun 2022 16:08:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0667AC34116;
        Wed,  8 Jun 2022 16:08:31 +0000 (UTC)
Date:   Wed, 8 Jun 2022 12:08:30 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
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
Message-ID: <20220608120830.1ff5c5eb@gandalf.local.home>
In-Reply-To: <CAEf4BzYkHkB60qPxGu0D=x-BidxObX95+1wjEYN8xsK7Dg_4cw@mail.gmail.com>
References: <20220606184731.437300-1-jolsa@kernel.org>
        <20220606184731.437300-4-jolsa@kernel.org>
        <CAADnVQJA54Ra8+tV0e0KwSXAg93JRoiefDXWR-Lqatya5YWKpg@mail.gmail.com>
        <Yp+tTsqPOuVdjpba@krava>
        <CAADnVQJGoM9eqcODx2LGo-qLo0=O05gSw=iifRsWXgU0XWifAA@mail.gmail.com>
        <YqBW65t+hlWNok8e@krava>
        <YqBynO64am32z13X@krava>
        <20220608084023.4be8ffe2@gandalf.local.home>
        <CAEf4BzYkHkB60qPxGu0D=x-BidxObX95+1wjEYN8xsK7Dg_4cw@mail.gmail.com>
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

On Wed, 8 Jun 2022 08:59:50 -0700
Andrii Nakryiko <andrii.nakryiko@gmail.com> wrote:

> Would it be possible to preprocess ftrace_pages to remove such invalid
> records (so that by the time we have to report
> available_filter_functions there are no invalid records)? Or that data
> is read-only when kernel is running?

It's possible, but will be time consuming (slow down boot up) and racy. In
other words, I didn't feel it was worth it.

We can add it. How much of an issue is it to have these place holders for
you? Currently, I only see it causes issues with tests. Is it really an
issue for use cases?

-- Steve

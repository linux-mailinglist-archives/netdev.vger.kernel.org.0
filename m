Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B9684A9248
	for <lists+netdev@lfdr.de>; Fri,  4 Feb 2022 03:20:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356627AbiBDCUA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 21:20:00 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:48124 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234237AbiBDCT7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 21:19:59 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8AD96B817E5;
        Fri,  4 Feb 2022 02:19:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE461C340E8;
        Fri,  4 Feb 2022 02:19:55 +0000 (UTC)
Date:   Thu, 3 Feb 2022 21:19:54 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Masami Hiramatsu <mhiramat@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, Jiri Olsa <olsajiri@gmail.com>
Subject: Re: [PATCH 0/8] bpf: Add fprobe link
Message-ID: <20220203211954.67c20cd3@gandalf.local.home>
In-Reply-To: <CAADnVQJfq_10H0V+u0w0rzyZ9uy7vq=T-3BMDANjEN8A3-prsQ@mail.gmail.com>
References: <20220202135333.190761-1-jolsa@kernel.org>
        <CAADnVQ+hTWbvNgnvJpAeM_-Ui2-G0YSM3QHB9G2+2kWEd4-Ymw@mail.gmail.com>
        <Yfq+PJljylbwJ3Bf@krava>
        <CAADnVQKeTB=UgY4Gf-46EBa8rwWTu2wvi7hEj2sdVTALGJ0JEg@mail.gmail.com>
        <YfvvfLlM1FOTgvDm@krava>
        <20220204094619.2784e00c0b7359356458ca57@kernel.org>
        <CAADnVQJYY0Xm6M9O02E5rOkdQPX39NOOS4tM2jpwRLQvP-qDBg@mail.gmail.com>
        <20220204110704.7c6eaf43ff9c8f5fe9bf3179@kernel.org>
        <CAADnVQJfq_10H0V+u0w0rzyZ9uy7vq=T-3BMDANjEN8A3-prsQ@mail.gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 3 Feb 2022 18:12:11 -0800
Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:

> > No, fprobe is NOT kprobe on ftrace, kprobe on ftrace is already implemented
> > transparently.  
> 
> Not true.
> fprobe is nothing but _explicit_ kprobe on ftrace.
> There was an implicit optimization for kprobe when ftrace
> could be used.
> All this new interface is doing is making it explicit.
> So a new name is not warranted here.
> 
> > from that viewpoint, fprobe and kprobe interface are similar but different.  
> 
> What is the difference?
> I don't see it.

IIUC, a kprobe on a function (or ftrace, aka fprobe) gives some extra
abilities that a normal kprobe does not. Namely, "what is the function
parameters?"

You can only reliably get the parameters at function entry. Hence, by
having a probe that is unique to functions as supposed to the middle of a
function, makes sense to me.

That is, the API can change. "Give me parameter X". That along with some
BTF reading, could figure out how to get parameter X, and record that.

-- Steve

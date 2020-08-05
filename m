Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADC3823CF59
	for <lists+netdev@lfdr.de>; Wed,  5 Aug 2020 21:20:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728621AbgHETTf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Aug 2020 15:19:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728849AbgHER5u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Aug 2020 13:57:50 -0400
Received: from mail-yb1-xb42.google.com (mail-yb1-xb42.google.com [IPv6:2607:f8b0:4864:20::b42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CC67C061575;
        Wed,  5 Aug 2020 10:56:42 -0700 (PDT)
Received: by mail-yb1-xb42.google.com with SMTP id v89so10014357ybi.8;
        Wed, 05 Aug 2020 10:56:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=li1hE9tF4it7VfRmrQee8o6JUSjiVegDf8MI6ZEx7Xw=;
        b=VRGtmUGAWQDDkaTOsTmd9lNenNetoywtXI7HdQOOcsYrutySs+ol6ML0Z5mC8hGUCb
         KSMEhswVQo13kTKOSWxuNm8lLyxp2KhNKBHTGJQRNNoLvxtGK9Et+iXpeQ/JrdlNNviw
         xB+HZm4D3SQI76qe7TUwFRtnT93f4+jAT4bxO4xQVy+g4cK/HXfTanmG15XG/D4+LPhK
         jDKZCmUsSH6LhEhez8cm0ONUz3ns1lxQGvrufJR+y9btO0A6wWKTtowEpL02k99C/iXx
         35svsGvqq+bq5qbjca1p7V99jdmR5bOAN2dtD0oMbwQsfoQU/piZ+E9VW+WK87APsVxV
         I1qQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=li1hE9tF4it7VfRmrQee8o6JUSjiVegDf8MI6ZEx7Xw=;
        b=gryqoJf/LtjfnFAsJ4ofMNBSTAjWtT1qed9uWG9K43/qVhPfTwB6ow4aYX3T/N0RVQ
         iv7jtaLDb3rWK2JgCC3xFrglpA3/HHjp5fBCtPJULXQJ1qcWe7MTF/ga4kBz8ttwurxE
         G52oqM5WqGNKmtOihs9fk8MJ52CC3JRzqpn7mIJ0OeknVPPpM+5KMxTxeqKJDssG+D+y
         RC1GnY+O7ApFabh152/GbekoP//c4ggxdImprDcXUFFsthdmWT/0WB1trl5OZp4NR9bR
         2oFxylLq0EvrkrchV5j3q5I69SnaiMGefW9PVOFWf54m1UDId7Zv1RfynHjevf+YFTTa
         dutQ==
X-Gm-Message-State: AOAM5332CJfjEdLYwLV4IUrj0hqlIu5XOurdP2fU5EYZjvShkD5w3ZUk
        0Hnq/taSVC5AkvmkHa2NVqNT2fpRjSrU6yPSVhs=
X-Google-Smtp-Source: ABdhPJxPByyNb7ICLni4pJ6BsJD+EnvzFEbpCnvzZnfR60EZfc/fsAHIWGHssLiBJNHBNUN1hd8RlUQMqwOlM7mahTU=
X-Received: by 2002:a25:824a:: with SMTP id d10mr6810040ybn.260.1596650201303;
 Wed, 05 Aug 2020 10:56:41 -0700 (PDT)
MIME-Version: 1.0
References: <20200801084721.1812607-1-songliubraving@fb.com>
 <20200801084721.1812607-6-songliubraving@fb.com> <CAEf4BzaP4TGF7kcmZRAKsy=oWPpFA6sUGFkctpGz-fPp+YuSOQ@mail.gmail.com>
 <DDCD362E-21D3-46BF-90A6-8F3221CBB54E@fb.com> <CAEf4BzY5RYMM6w8wn3qEB3AsuKWv-TMaD5NVFj=YqbCW4DLjqA@mail.gmail.com>
 <7384B583-EE19-4045-AC72-B6FE87C187DD@fb.com> <CAEf4BzaiJnCu14AWougmxH80msGdOp4S8ZNmAiexMmtwUM_2Xg@mail.gmail.com>
 <AF9D0E8C-0AA5-4BE4-90F4-946FABAB63FD@fb.com> <20200805171639.tsqjmifd7eb3htou@ast-mbp.dhcp.thefacebook.com>
 <CAEf4BzYFfAubxo1QY6Axth=gwS9DfzwRkvnYLspfk9tLia0LPg@mail.gmail.com> <20200805174552.56q6eauad7glyzgm@ast-mbp.dhcp.thefacebook.com>
In-Reply-To: <20200805174552.56q6eauad7glyzgm@ast-mbp.dhcp.thefacebook.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 5 Aug 2020 10:56:30 -0700
Message-ID: <CAEf4BzYUTvjAJ4uvYxBbbO7Vjh+K++F0HJe8mJ09RdhOeLeZGQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next 5/5] selftests/bpf: add benchmark for uprobe vs. user_prog
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Song Liu <songliubraving@fb.com>,
        open list <linux-kernel@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Daniel Xu <dlxu@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 5, 2020 at 10:45 AM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Wed, Aug 05, 2020 at 10:27:28AM -0700, Andrii Nakryiko wrote:
> > On Wed, Aug 5, 2020 at 10:16 AM Alexei Starovoitov
> > <alexei.starovoitov@gmail.com> wrote:
> > >
> > > On Wed, Aug 05, 2020 at 04:47:30AM +0000, Song Liu wrote:
> > > >
> > > > Being able to trigger BPF program on a different CPU could enable many
> > > > use cases and optimizations. The use case I am looking at is to access
> > > > perf_event and percpu maps on the target CPU. For example:
> > > >       0. trigger the program
> > > >       1. read perf_event on cpu x;
> > > >       2. (optional) check which process is running on cpu x;
> > > >       3. add perf_event value to percpu map(s) on cpu x.
> > >
> > > If the whole thing is about doing the above then I don't understand why new
> > > prog type is needed. Can prog_test_run support existing BPF_PROG_TYPE_KPROBE?
> > > "enable many use cases" sounds vague. I don't think folks reading
> > > the patches can guess those "use cases".
> > > "Testing existing kprobe bpf progs" would sound more convincing to me.
> >
> > Was just about to propose the same :) I wonder if generic test_run()
> > capability to trigger test programs of whatever supported type on a
> > specified CPU through IPI can be added. That way you can even use the
> > XDP program to do what Song seems to need.
> >
> > TRACEPOINTs might also be a good fit here, given it seems simpler to
> > let users specify custom tracepoint data for test_run(). Having the
> > ability to unit-test KPROBE and TRACEPOINT, however rudimentary, is
> > already a big win.
> >
> > > If the test_run framework can be extended to trigger kprobe with correct pt_regs.
> > > As part of it test_run would trigger on a given cpu with $ip pointing
> > > to some test fuction in test_run.c. For local test_run the stack trace
> > > would include bpf syscall chain. For IPI the stack trace would include
> > > the corresponding kernel pieces where top is our special test function.
> > > Sort of like pseudo kprobe where there is no actual kprobe logic,
> > > since kprobe prog doesn't care about mechanism. It needs correct
> > > pt_regs only as input context.
> > > The kprobe prog output (return value) has special meaning though,
> > > so may be kprobe prog type is not a good fit.
> >
> > It does? I don't remember returning 1 from KPROBE changing anything. I
> > thought it's only the special bpf_override_return() that can influence
> > the kernel function return result.
>
> See comment in trace_call_bpf().
> And logic to handle it in kprobe_perf_func() for kprobes.
> and in perf_trace_run_bpf_submit() for tracepoints.
> It's historical and Song actually discovered an issue with such behavior.
> I don't remember whether we've concluded on the solution.

Oh, thanks for pointers. Never realized there is more going on with
those. I guess return 1; is not advised then, as it causes extra
overhead.

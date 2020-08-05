Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E4A423CD6E
	for <lists+netdev@lfdr.de>; Wed,  5 Aug 2020 19:30:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728873AbgHERaY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Aug 2020 13:30:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728788AbgHER1k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Aug 2020 13:27:40 -0400
Received: from mail-yb1-xb42.google.com (mail-yb1-xb42.google.com [IPv6:2607:f8b0:4864:20::b42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC804C061575;
        Wed,  5 Aug 2020 10:27:39 -0700 (PDT)
Received: by mail-yb1-xb42.google.com with SMTP id x2so4035803ybf.12;
        Wed, 05 Aug 2020 10:27:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BUORAD323AYH3zxx1yaS/aYxJilBT0bejXUe4CU1IsU=;
        b=nb7391sFHHARlePNt23uWFUiCgJDNofextE1aito4sTSYWdJoc/yW7awE7AwDekIQy
         nQMdw7M56WSttzqnt4r/rinYc+iholmrAs7j82PJhz9OyuE2x/UDuIptCwy+aAUe/sc3
         sdtBKtVW+qtwEkNoyEUWTlvt01nHEyrNTAccsXcBausvwY9lV3kNzseWdWRWUtpBf4vn
         vzKszBu0NEbXGrPfS4t/lH+3P7PxcrEKLJR29/MG5j281+Hfmh49/8/4XbVjVcnKcE72
         Bx+120NdmYBdfsL53Mxn9gS4y1TRSKlUMPMNKievyfxEQ22EH7gDVg375zEA+oMC3NRR
         AOog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BUORAD323AYH3zxx1yaS/aYxJilBT0bejXUe4CU1IsU=;
        b=mU25JNlQ0WbPKa7k0gKFBqalEON1tO+EE3nK4Qj+H+g9EbqZtghfIkZm4HH3s9ABLt
         nKY0XOvgIwmiY2FhUTr9g5jmWty/zyOzfRqBn94qcQSrVIlPQGZ3y/U6uNm7UJqBXTT1
         tRtsfSwTCWyBcrk6f8yNX8Oz23fJ0JdEmTimRxBHgFad7OyMGwPbr2IJx1+SEi7yQiKI
         Ms5g2YafQApTE1OFHNA9w7gOxEbwJFL427igAoBvR5FpjlzI7SQfUTh1omZI6kQ2focH
         iUXxwuep1Rz6RlMCzqWKRlvEjXLig06uFjNM0XxMHG6F5b6K59ZMW5zknaN6RIaOWWx6
         yNSA==
X-Gm-Message-State: AOAM533NVlK8SyNGepOAlQ6A2SMjP1sn/MTFN5RpiM/w1njadRIbdaS0
        6rScp2wsuSMbTQS1Bn2WA5unEvOq9kEgxbq0HFk=
X-Google-Smtp-Source: ABdhPJzV/vqVTpcSUL8lQmokCDonYTJ8sM2iojmyXsyq64VdK2J/hLo3FUzGE0OyGsfWug1unqWO9IDmfJ0pgr3dC+s=
X-Received: by 2002:a25:2ad3:: with SMTP id q202mr6206874ybq.27.1596648459142;
 Wed, 05 Aug 2020 10:27:39 -0700 (PDT)
MIME-Version: 1.0
References: <20200801084721.1812607-1-songliubraving@fb.com>
 <20200801084721.1812607-6-songliubraving@fb.com> <CAEf4BzaP4TGF7kcmZRAKsy=oWPpFA6sUGFkctpGz-fPp+YuSOQ@mail.gmail.com>
 <DDCD362E-21D3-46BF-90A6-8F3221CBB54E@fb.com> <CAEf4BzY5RYMM6w8wn3qEB3AsuKWv-TMaD5NVFj=YqbCW4DLjqA@mail.gmail.com>
 <7384B583-EE19-4045-AC72-B6FE87C187DD@fb.com> <CAEf4BzaiJnCu14AWougmxH80msGdOp4S8ZNmAiexMmtwUM_2Xg@mail.gmail.com>
 <AF9D0E8C-0AA5-4BE4-90F4-946FABAB63FD@fb.com> <20200805171639.tsqjmifd7eb3htou@ast-mbp.dhcp.thefacebook.com>
In-Reply-To: <20200805171639.tsqjmifd7eb3htou@ast-mbp.dhcp.thefacebook.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 5 Aug 2020 10:27:28 -0700
Message-ID: <CAEf4BzYFfAubxo1QY6Axth=gwS9DfzwRkvnYLspfk9tLia0LPg@mail.gmail.com>
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

On Wed, Aug 5, 2020 at 10:16 AM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Wed, Aug 05, 2020 at 04:47:30AM +0000, Song Liu wrote:
> >
> > Being able to trigger BPF program on a different CPU could enable many
> > use cases and optimizations. The use case I am looking at is to access
> > perf_event and percpu maps on the target CPU. For example:
> >       0. trigger the program
> >       1. read perf_event on cpu x;
> >       2. (optional) check which process is running on cpu x;
> >       3. add perf_event value to percpu map(s) on cpu x.
>
> If the whole thing is about doing the above then I don't understand why new
> prog type is needed. Can prog_test_run support existing BPF_PROG_TYPE_KPROBE?
> "enable many use cases" sounds vague. I don't think folks reading
> the patches can guess those "use cases".
> "Testing existing kprobe bpf progs" would sound more convincing to me.

Was just about to propose the same :) I wonder if generic test_run()
capability to trigger test programs of whatever supported type on a
specified CPU through IPI can be added. That way you can even use the
XDP program to do what Song seems to need.

TRACEPOINTs might also be a good fit here, given it seems simpler to
let users specify custom tracepoint data for test_run(). Having the
ability to unit-test KPROBE and TRACEPOINT, however rudimentary, is
already a big win.

> If the test_run framework can be extended to trigger kprobe with correct pt_regs.
> As part of it test_run would trigger on a given cpu with $ip pointing
> to some test fuction in test_run.c. For local test_run the stack trace
> would include bpf syscall chain. For IPI the stack trace would include
> the corresponding kernel pieces where top is our special test function.
> Sort of like pseudo kprobe where there is no actual kprobe logic,
> since kprobe prog doesn't care about mechanism. It needs correct
> pt_regs only as input context.
> The kprobe prog output (return value) has special meaning though,
> so may be kprobe prog type is not a good fit.

It does? I don't remember returning 1 from KPROBE changing anything. I
thought it's only the special bpf_override_return() that can influence
the kernel function return result.

> Something like fentry/fexit may be better, since verifier check_return_code()
> enforces 'return 0'. So their return value is effectively "void".
> Then prog_test_run would need to gain an ability to trigger
> fentry/fexit prog on a given cpu.

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D20084A925E
	for <lists+netdev@lfdr.de>; Fri,  4 Feb 2022 03:42:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356650AbiBDCmf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 21:42:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230467AbiBDCmd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 21:42:33 -0500
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3BEDC061714;
        Thu,  3 Feb 2022 18:42:33 -0800 (PST)
Received: by mail-pl1-x62a.google.com with SMTP id t9so1731143plg.13;
        Thu, 03 Feb 2022 18:42:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1mOPyQ5UiB8kEYuS4ShMupKYCA5eSrSa5aHqsgtfLkU=;
        b=lxQJNq2ybkvp1A0zaaPiw437ZpsIEw5sB9BhSqof8oW0L9jykk0ZpIGOuv+dIlTaOr
         Ah6hBQ4Zwgnax0OxjUuLk4+zVyDVb3Ya4d4WTCvYCo8lJQpAn4sI2q7Uk/xAApFArQeO
         l/cVbIrEJIDzEW9lV3OjfbgOOyHQxClBUTLtfpflFdYEApfpnYf7R/HM98IoyLfayYVZ
         sjdLbpPFhajmT0IYpVPdu2yujLZowHLpF9eTBKa6Cm/Mo0/O4Eb9teAbTt5JrmjsBy7A
         OK/0QlPCknDbrIanrXQjnOs8lR0xPFiYF+t8nq1KARtlg2sw1Lfzz4Z6k++uE4wTqfgT
         g2rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1mOPyQ5UiB8kEYuS4ShMupKYCA5eSrSa5aHqsgtfLkU=;
        b=D17TdMyq/nl2GsyNnWsEBcE6GjLkx6gwo1HHCpXaofjAlbIWsaknSn8AhRnxzPKQL8
         V0KYiAxbXJuNmqN0Ik7Svnhpeh/sNdUXIjO6wG4S8D8jiFDEeyRL+p+Z1tCEjCiepmT7
         zP+Bu03INzmHb1aJPQMGV08OMQVh5qQNKPFNhCMupt7gV7kFVlKAq/aY4LAm6TMOli6r
         P6h/ddd9G7kk7k+m98IiNokPCh8pIoHW5tX6Vf/tiLTmRyelgka4T62N0/9L0iOafmEC
         4dk6oRv7QL9f9EJVbNwQdJu2F8ibxHtrKU+sa/mYc5OJT//MqOqbM5NUG8Kft1/AlyXK
         BZlw==
X-Gm-Message-State: AOAM53092nAyDNDVXZLgBK5gQXNgnT7aDtuh5yHUBJ5JKMe5ucYTtQrL
        yhdKy3Jkc3qWPVEYxPC9g3WuMXQs5bQbyt5vRL4=
X-Google-Smtp-Source: ABdhPJyQlw8f5s9Qj1sCCc+tZIZU3IWHEe1b27SYPll4W2TRUiuMwLcwmGpOkC7a8JOJGq+DR+dhgnl2dO+JnF+QPVE=
X-Received: by 2002:a17:90b:1e41:: with SMTP id pi1mr776554pjb.62.1643942553260;
 Thu, 03 Feb 2022 18:42:33 -0800 (PST)
MIME-Version: 1.0
References: <20220202135333.190761-1-jolsa@kernel.org> <CAADnVQ+hTWbvNgnvJpAeM_-Ui2-G0YSM3QHB9G2+2kWEd4-Ymw@mail.gmail.com>
 <Yfq+PJljylbwJ3Bf@krava> <CAADnVQKeTB=UgY4Gf-46EBa8rwWTu2wvi7hEj2sdVTALGJ0JEg@mail.gmail.com>
 <YfvvfLlM1FOTgvDm@krava> <20220204094619.2784e00c0b7359356458ca57@kernel.org>
 <CAADnVQJYY0Xm6M9O02E5rOkdQPX39NOOS4tM2jpwRLQvP-qDBg@mail.gmail.com>
 <20220204110704.7c6eaf43ff9c8f5fe9bf3179@kernel.org> <CAADnVQJfq_10H0V+u0w0rzyZ9uy7vq=T-3BMDANjEN8A3-prsQ@mail.gmail.com>
 <20220203211954.67c20cd3@gandalf.local.home>
In-Reply-To: <20220203211954.67c20cd3@gandalf.local.home>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 3 Feb 2022 18:42:22 -0800
Message-ID: <CAADnVQKjNJjZDs+ZV7vcusEkKuDq+sWhSD3M5GtvNeZMx3Fcmg@mail.gmail.com>
Subject: Re: [PATCH 0/8] bpf: Add fprobe link
To:     Steven Rostedt <rostedt@goodmis.org>
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
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 3, 2022 at 6:19 PM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Thu, 3 Feb 2022 18:12:11 -0800
> Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:
>
> > > No, fprobe is NOT kprobe on ftrace, kprobe on ftrace is already implemented
> > > transparently.
> >
> > Not true.
> > fprobe is nothing but _explicit_ kprobe on ftrace.
> > There was an implicit optimization for kprobe when ftrace
> > could be used.
> > All this new interface is doing is making it explicit.
> > So a new name is not warranted here.
> >
> > > from that viewpoint, fprobe and kprobe interface are similar but different.
> >
> > What is the difference?
> > I don't see it.
>
> IIUC, a kprobe on a function (or ftrace, aka fprobe) gives some extra
> abilities that a normal kprobe does not. Namely, "what is the function
> parameters?"
>
> You can only reliably get the parameters at function entry. Hence, by
> having a probe that is unique to functions as supposed to the middle of a
> function, makes sense to me.
>
> That is, the API can change. "Give me parameter X". That along with some
> BTF reading, could figure out how to get parameter X, and record that.

This is more or less a description of kprobe on ftrace :)
The bpf+kprobe users were relying on that for a long time.
See PT_REGS_PARM1() macros in bpf_tracing.h
They're meaningful only with kprobe on ftrace.
So, no, fprobe is not inventing anything new here.

No one is using kprobe in the middle of the function.
It's too difficult to make anything useful out of it,
so no one bothers.
When people say "kprobe" 99 out of 100 they mean
kprobe on ftrace/fentry.

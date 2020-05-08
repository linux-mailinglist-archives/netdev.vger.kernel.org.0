Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01CCD1CB6E6
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 20:16:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727067AbgEHSQQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 14:16:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727785AbgEHSQE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 May 2020 14:16:04 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7C71C05BD0A;
        Fri,  8 May 2020 11:16:02 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id r2so2262679ilo.6;
        Fri, 08 May 2020 11:16:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EMKYipfxfwTIPATxi6cwzN5o+N57K9koFSEGCPry7gY=;
        b=iYo9FJiduPwU0lQA3dD3sf8yH5Csdu9NKLXthi8ttxFIR7gb0Jsx5nGnXvND3+OZ0G
         NCVY5vg3LEwV9/RF9g9RxmMAg9Q7uLg9h8l9/q6ch3QO3jiBLcskV+FE3aLCrBj5Bh5Z
         JCfWQzhNi+IT2l4c6b6y0FMJRvj25Clk6adTxg2QTNG9x7qMtzE6SYyOdkexgrI5QYOJ
         TN30f/bzPYKHeDA4m17KbQWQ44lK9zY96JkRLT7ENsZKeliYBaQ5hZzVopQef1Hmj+B+
         JIFCvBziVQRGJs00WmVIzj4Y03i7Vmb49y7UB7gBYDSd4ifIh+zSDtROPCedOocPkYxs
         Lpdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EMKYipfxfwTIPATxi6cwzN5o+N57K9koFSEGCPry7gY=;
        b=O8bO04b2qb3AqEtSFt7SCJzUJQAu4+oOGySTgcG8XO2NVMywmr/9q0G/x86DrEVJ8F
         rtPbBNii27IpKR9SJo37Es7ORk+2FnlnxTSdDfVBNeNrZk2/byrg6NcCk/+OFmOuAlZM
         xl8wDvNiPh/Vc7pOGz7AoM533f6mGEi7vnWzp0/rolW8yGJDJjz4Rp7Sc6jfO2A9DSdf
         nUTZ12MIUVMH3s5JWC44Y/SYpPUcNHK/uAQ2Kuy6Y6gREZaPugK/hTWQ5SrH7qH9EZL2
         ABQuYr10UUi9dP/1I9DaLAEeSJMBkhMorHjCf4PerXIAkNiUolwSe92j02nQDtiBgzRf
         EP/Q==
X-Gm-Message-State: AGi0Pubvha5rVLRZFALW0t5/P8PF+F4iN+H3TDrjH6G5AedXd+a006qj
        rxjZrnu4mp2dOnQGVm/T2WLnAgXyB+6ZZVj0Vw8=
X-Google-Smtp-Source: APiQypK+yq31/hfLfegSEavOHigyedthQ4ZpAopxDE1kbFCDpU6y0WcDjB1bYrW3HIvhDxQhV6OLuy9v2t54s+E09SM=
X-Received: by 2002:a92:a053:: with SMTP id b19mr3849735ilm.156.1588961762038;
 Fri, 08 May 2020 11:16:02 -0700 (PDT)
MIME-Version: 1.0
References: <20200504062547.2047304-1-yhs@fb.com> <20200504062602.2048597-1-yhs@fb.com>
 <CAEf4Bzb-COkgcLB=HK4ahtnEFD7QGY0s=Qb-kWTBKK56319JAg@mail.gmail.com> <71cff8d8-05b9-87ef-8a12-1da3e38c4b55@fb.com>
In-Reply-To: <71cff8d8-05b9-87ef-8a12-1da3e38c4b55@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 8 May 2020 11:15:50 -0700
Message-ID: <CAEf4Bza0n3_uukQu_gUxn3X46kVOHeu3rJPdHkh8=QYxunFiig@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 13/20] bpf: add bpf_seq_printf and
 bpf_seq_write helpers
To:     Yonghong Song <yhs@fb.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 6, 2020 at 2:42 PM Yonghong Song <yhs@fb.com> wrote:
>
>
>
> On 5/6/20 10:37 AM, Andrii Nakryiko wrote:
> > On Sun, May 3, 2020 at 11:26 PM Yonghong Song <yhs@fb.com> wrote:
> >>
> >> Two helpers bpf_seq_printf and bpf_seq_write, are added for
> >> writing data to the seq_file buffer.
> >>
> >> bpf_seq_printf supports common format string flag/width/type
> >> fields so at least I can get identical results for
> >> netlink and ipv6_route targets.
> >>
> >
> > Does seq_printf() has its own format string specification? Is there
> > any documentation explaining? I was confused by few different checks
> > below...
>
> Not really. Similar to bpf_trace_printk(), since we need to
> parse format string, so we may only support a subset of
> what seq_printf() does. But we should not invent new
> formats.
>
> >
> >> For bpf_seq_printf and bpf_seq_write, return value -EOVERFLOW
> >> specifically indicates a write failure due to overflow, which
> >> means the object will be repeated in the next bpf invocation
> >> if object collection stays the same. Note that if the object
> >> collection is changed, depending how collection traversal is
> >> done, even if the object still in the collection, it may not
> >> be visited.
> >>
> >> bpf_seq_printf may return -EBUSY meaning that internal percpu
> >> buffer for memory copy of strings or other pointees is
> >> not available. Bpf program can return 1 to indicate it
> >> wants the same object to be repeated. Right now, this should not
> >> happen on no-RT kernels since migrate_enable(), which guards
> >> bpf prog call, calls preempt_enable().
> >
> > You probably meant migrate_disable()/preempt_disable(), right? But
>
> Yes, sorry for typo.
>
> > could it still happen, at least due to NMI? E.g., perf_event BPF
> > program gets triggered during bpf_iter program execution? I think for
> > perf_event_output function, we have 3 levels, for one of each possible
> > "contexts"? Should we do something like that here as well?
>
> Currently bpf_seq_printf() and bpf_seq_write() helpers can
> only be called by iter bpf programs. The iter bpf program can only
> be run on process context as it is triggered by a read() syscall.
> So one level should be enough for non-RT kernel.
>
> For RT kernel, migrate_disable does not prevent preemption,
> so it is possible task in the middle of bpf_seq_printf() might
> be preempted, so I implemented the logic to return -EBUSY.
> I think this case should be extremely rare so I only implemented
> one level nesting.

yeah, makes sense

>
> >
> >>
> >> Signed-off-by: Yonghong Song <yhs@fb.com>
> >> ---
> >>   include/uapi/linux/bpf.h       |  32 +++++-
> >>   kernel/trace/bpf_trace.c       | 195 +++++++++++++++++++++++++++++++++
> >>   scripts/bpf_helpers_doc.py     |   2 +
> >>   tools/include/uapi/linux/bpf.h |  32 +++++-
> >>   4 files changed, 259 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> >> index 97ceb0f2e539..e440a9d5cca2 100644
> >> --- a/include/uapi/linux/bpf.h
> >> +++ b/include/uapi/linux/bpf.h
> >> @@ -3076,6 +3076,34 @@ union bpf_attr {
> >>    *             See: clock_gettime(CLOCK_BOOTTIME)
> >>    *     Return
> >>    *             Current *ktime*.
> >> + *
> >
> > [...]
> >
> >> +BPF_CALL_5(bpf_seq_printf, struct seq_file *, m, char *, fmt, u32, fmt_size,
> >> +          const void *, data, u32, data_len)
> >> +{
> >> +       int err = -EINVAL, fmt_cnt = 0, memcpy_cnt = 0;
> >> +       int i, buf_used, copy_size, num_args;
> >> +       u64 params[MAX_SEQ_PRINTF_VARARGS];
> >> +       struct bpf_seq_printf_buf *bufs;
> >> +       const u64 *args = data;
> >> +
> >> +       buf_used = this_cpu_inc_return(bpf_seq_printf_buf_used);
> >> +       if (WARN_ON_ONCE(buf_used > 1)) {
> >> +               err = -EBUSY;
> >> +               goto out;
> >> +       }
> >> +
> >> +       bufs = this_cpu_ptr(&bpf_seq_printf_buf);
> >> +
> >> +       /*
> >> +        * bpf_check()->check_func_arg()->check_stack_boundary()
> >> +        * guarantees that fmt points to bpf program stack,
> >> +        * fmt_size bytes of it were initialized and fmt_size > 0
> >> +        */
> >> +       if (fmt[--fmt_size] != 0)
> >
> > If we allow fmt_size == 0, this will need to be changed.
>
> Currently, we do not support fmt_size == 0. Yes, if we allow, this
> needs change.
>
> >
> >> +               goto out;
> >> +
> >> +       if (data_len & 7)
> >> +               goto out;
> >> +
> >> +       for (i = 0; i < fmt_size; i++) {
> >> +               if (fmt[i] == '%' && (!data || !data_len))
> >
> > So %% escaping is not supported?
>
> Yes, have not seen a need yet my ipv6_route/netlink example.
> Can certain add if there is a use case.

I can imagine this being used quite often when trying to print out
percentages... Would just suck to have to upgrade kernel just to be
able to print % character :)

>
> >
> >> +                       goto out;
> >> +       }
> >> +
> >> +       num_args = data_len / 8;
> >> +
> >> +       /* check format string for allowed specifiers */
> >> +       for (i = 0; i < fmt_size; i++) {
> >> +               if ((!isprint(fmt[i]) && !isspace(fmt[i])) || !isascii(fmt[i]))
> >
> > why these restrictions? are they essential?
>
> This is the same restriction in bpf_trace_printk(). I guess the purpose
> is to avoid weird print. To promote bpf_iter to dump beyond asscii, I
> guess we can remove this restriction.

well, if underlying seq_printf() will fail for those "more liberal"
strings, then that would be bad. Basically, we should try to not
impose additional restrictions compared to seq_printf, but also no
need to allow more, which will be rejected by it. I haven't checked
seq_printf implementation though, so don't know what are those
restrictions.

>
> >
> >> +                       goto out;
> >> +
> >> +               if (fmt[i] != '%')
> >> +                       continue;
> >> +
> >> +               if (fmt_cnt >= MAX_SEQ_PRINTF_VARARGS) {
> >> +                       err = -E2BIG;
> >> +                       goto out;
> >> +               }
> >> +
> >> +               if (fmt_cnt >= num_args)
> >> +                       goto out;
> >> +
> >> +               /* fmt[i] != 0 && fmt[last] == 0, so we can access fmt[i + 1] */
> >> +               i++;
> >> +
> >> +               /* skip optional "[0+-][num]" width formating field */
> >> +               while (fmt[i] == '0' || fmt[i] == '+'  || fmt[i] == '-')
> >
> > There could be space as well, as an alternative to 0.
>
> We can allow space. But '0' is used more common, right?

I use both space and 0 quite often, space especially with aligned strings.

>
> >
> >> +                       i++;
> >> +               if (fmt[i] >= '1' && fmt[i] <= '9') {
> >> +                       i++;
> >> +                       while (fmt[i] >= '0' && fmt[i] <= '9')
> >> +                               i++;
> >> +               }
> >> +
> >> +               if (fmt[i] == 's') {
> >> +                       /* disallow any further format extensions */
> >> +                       if (fmt[i + 1] != 0 &&
> >> +                           !isspace(fmt[i + 1]) &&
> >> +                           !ispunct(fmt[i + 1]))
> >> +                               goto out;
> >
> > I'm not sure I follow this check either. printf("%sbla", "whatever")
> > is a perfectly fine format string. Unless seq_printf has some
> > additional restrictions?
>
> Yes, just some restriction inherited from bpf_trace_printk().
> Will remove.

see comment above, if we allow it here, but seq_printf() will reject
it, then there is no point

>
> >
> >> +
> >> +                       /* try our best to copy */
> >> +                       if (memcpy_cnt >= MAX_SEQ_PRINTF_MAX_MEMCPY) {
> >> +                               err = -E2BIG;
> >> +                               goto out;
> >> +                       }
> >> +
> >
> > [...]
> >
> >> +
> >> +static int bpf_seq_printf_btf_ids[5];
> >> +static const struct bpf_func_proto bpf_seq_printf_proto = {
> >> +       .func           = bpf_seq_printf,
> >> +       .gpl_only       = true,
> >> +       .ret_type       = RET_INTEGER,
> >> +       .arg1_type      = ARG_PTR_TO_BTF_ID,
> >> +       .arg2_type      = ARG_PTR_TO_MEM,
> >> +       .arg3_type      = ARG_CONST_SIZE,
> >
> > It feels like allowing zero shouldn't hurt too much?
>
> This is the format string, I would prefer to keep it non-zero.

yeah, makes sense, I suppose

>
> >
> >> +       .arg4_type      = ARG_PTR_TO_MEM_OR_NULL,
> >> +       .arg5_type      = ARG_CONST_SIZE_OR_ZERO,
> >> +       .btf_id         = bpf_seq_printf_btf_ids,
> >> +};
> >> +
> >> +BPF_CALL_3(bpf_seq_write, struct seq_file *, m, const void *, data, u32, len)
> >> +{
> >> +       return seq_write(m, data, len) ? -EOVERFLOW : 0;
> >> +}
> >> +
> >> +static int bpf_seq_write_btf_ids[5];
> >> +static const struct bpf_func_proto bpf_seq_write_proto = {
> >> +       .func           = bpf_seq_write,
> >> +       .gpl_only       = true,
> >> +       .ret_type       = RET_INTEGER,
> >> +       .arg1_type      = ARG_PTR_TO_BTF_ID,
> >> +       .arg2_type      = ARG_PTR_TO_MEM,
> >> +       .arg3_type      = ARG_CONST_SIZE,
> >
> > Same, ARG_CONST_SIZE_OR_ZERO?
>
> This one, possible. Let me check.

I just remember how much trouble perf_event_output() was causing me
because it enforced >0 for data length. Even though my variable-sized
output was always >0, proving that to (especially older) verifier was
extremely hard. So the less unnecessary restrictions - the better.

>
> >
> >> +       .btf_id         = bpf_seq_write_btf_ids,
> >> +};
> >> +
> >
> > [...]
> >

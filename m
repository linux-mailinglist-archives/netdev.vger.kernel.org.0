Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E014135306D
	for <lists+netdev@lfdr.de>; Fri,  2 Apr 2021 22:57:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234908AbhDBU5p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Apr 2021 16:57:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229722AbhDBU5m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Apr 2021 16:57:42 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFCF4C0613E6;
        Fri,  2 Apr 2021 13:57:40 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id j25so4273637pfe.2;
        Fri, 02 Apr 2021 13:57:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wp/8sLd49q8DFlfmKbeGwi+FKTLC4V5A4RAp/wmiqEc=;
        b=UfXZXq0QbJrTgpkjF59qfyF297RZFiwOmdO57XUPGTEXyY9xfipJL4jSkXbjORSlaq
         4NAnzQiT/C+QPnTrwdA/zfXW1nxbsQ29T1KLvy3yWfCauMkzP3eKOqA4DQbwBIDwbZAF
         a9mmmu1tOgLJAvxhBf5YQuZ7bKrHoEhlNFHScOcz1qRx8c3/3+QZ8a1mMz22FLnoftey
         7ujB6KYpkSEReaUupo0lVx6G1cxZibWyhbdmFeuxq9FQY/SBDIlFGfinv5sUe0sScYqq
         jj6xSiMf0ATwOBmxgXiF5CLSHcwbGUi0zDkKPJSanEHV1fF1XAlNyA9b9zVeWvsohvgN
         ApWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wp/8sLd49q8DFlfmKbeGwi+FKTLC4V5A4RAp/wmiqEc=;
        b=giQ4nDrCTdN3kSx5FeK3TQKbpU2y6v3Hh2aiOhXDTUlywrQndZFd1mYq9kuE/zi0HZ
         GMGLuhd1bZTugB6SEo+Pp1CgFwJa4ZdRcSgxnb2o59MB1VzY92syqLJYGhB3IradguO+
         lDC9aV3BMuD+eAzdmAuzg/p4zOFBzR4NUAEDO6JTnwLeQTxVjT2imAWyHYYFrS2pJOHW
         OZ7ZGlQ3rb4FUivRjJ0yPLfpNh9POECvFVEq0orRx4b2fPJ3T94atgswK/XWztDacVDl
         eLX4w+SNPyulQkvEGk9zg5H27DG2Rk+LQUcBTYlOM86/2bXlLRcNWz5l1FIeLXV4z6v3
         gXyw==
X-Gm-Message-State: AOAM532wrfDmZh09Y/b8NVPFCcqs4vgeUESn4NmGK1qGIXs9tbeYRa02
        XqCtTR5YbgYVH8PhUhKBOzIOmlPZqbbS1YX4uac=
X-Google-Smtp-Source: ABdhPJw1lR8nKMv8TQYpvhOed271oUoKxk6p+7e5mpP3aOhFZpuGuvTVfj6CCtvazSBL5TfgoQ+6z8TnSstsaZxRwVY=
X-Received: by 2002:aa7:99c6:0:b029:1f5:c49d:dce7 with SMTP id
 v6-20020aa799c60000b02901f5c49ddce7mr13461069pfi.78.1617397060319; Fri, 02
 Apr 2021 13:57:40 -0700 (PDT)
MIME-Version: 1.0
References: <20210401042635.19768-1-xiyou.wangcong@gmail.com>
 <B42B247A-4D0B-4DE9-B4D3-0C452472532D@fb.com> <CAM_iQpW-cuiYsPsu4mYZxZ1Oixffu2pV1TFg1c+eg9XT3wWwPQ@mail.gmail.com>
 <E0D5B076-A726-4845-8F12-640BAA853525@fb.com> <CAM_iQpWdO7efdcA2ovDsOF9XLhWJGgd6Be5qq0=xLphVBRE_Gw@mail.gmail.com>
 <93BBD473-7E1C-4A6E-8BB7-12E63D4799E8@fb.com> <CAM_iQpXEuxwQvT9FNqDa7y5kNpknA4xMNo_973ncy3iYaF-NTA@mail.gmail.com>
 <390A7E97-6A9A-48E4-A0B0-D1B9F5EB3308@fb.com>
In-Reply-To: <390A7E97-6A9A-48E4-A0B0-D1B9F5EB3308@fb.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Fri, 2 Apr 2021 13:57:29 -0700
Message-ID: <CAM_iQpVZdju0KhTV1_jQYjad4p++hNAfikH5FsaOCZrcGFFDYA@mail.gmail.com>
Subject: Re: [RFC Patch bpf-next] bpf: introduce bpf timer
To:     Song Liu <songliubraving@fb.com>
Cc:     "open list:BPF (Safe dynamic programs and tools)" 
        <netdev@vger.kernel.org>,
        "open list:BPF (Safe dynamic programs and tools)" 
        <bpf@vger.kernel.org>,
        "duanxiongchun@bytedance.com" <duanxiongchun@bytedance.com>,
        "wangdongdong.6@bytedance.com" <wangdongdong.6@bytedance.com>,
        Muchun Song <songmuchun@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Yonghong Song <yhs@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 2, 2021 at 12:45 PM Song Liu <songliubraving@fb.com> wrote:
>
>
>
> > On Apr 2, 2021, at 12:08 PM, Cong Wang <xiyou.wangcong@gmail.com> wrote:
> >
> > On Fri, Apr 2, 2021 at 10:57 AM Song Liu <songliubraving@fb.com> wrote:
> >>
> >>
> >>
> >>> On Apr 2, 2021, at 10:34 AM, Cong Wang <xiyou.wangcong@gmail.com> wrote:
> >>>
> >>> On Thu, Apr 1, 2021 at 1:17 PM Song Liu <songliubraving@fb.com> wrote:
> >>>>
> >>>>
> >>>>
> >>>>> On Apr 1, 2021, at 10:28 AM, Cong Wang <xiyou.wangcong@gmail.com> wrote:
> >>>>>
> >>>>> On Wed, Mar 31, 2021 at 11:38 PM Song Liu <songliubraving@fb.com> wrote:
> >>>>>>
> >>>>>>
> >>>>>>
> >>>>>>> On Mar 31, 2021, at 9:26 PM, Cong Wang <xiyou.wangcong@gmail.com> wrote:
> >>>>>>>
> >>>>>>> From: Cong Wang <cong.wang@bytedance.com>
> >>>>>>>
> >>>>>>> (This patch is still in early stage and obviously incomplete. I am sending
> >>>>>>> it out to get some high-level feedbacks. Please kindly ignore any coding
> >>>>>>> details for now and focus on the design.)
> >>>>>>
> >>>>>> Could you please explain the use case of the timer? Is it the same as
> >>>>>> earlier proposal of BPF_MAP_TYPE_TIMEOUT_HASH?
> >>>>>>
> >>>>>> Assuming that is the case, I guess the use case is to assign an expire
> >>>>>> time for each element in a hash map; and periodically remove expired
> >>>>>> element from the map.
> >>>>>>
> >>>>>> If this is still correct, my next question is: how does this compare
> >>>>>> against a user space timer? Will the user space timer be too slow?
> >>>>>
> >>>>> Yes, as I explained in timeout hashmap patchset, doing it in user-space
> >>>>> would require a lot of syscalls (without batching) or copying (with batching).
> >>>>> I will add the explanation here, in case people miss why we need a timer.
> >>>>
> >>>> How about we use a user space timer to trigger a BPF program (e.g. use
> >>>> BPF_PROG_TEST_RUN on a raw_tp program); then, in the BPF program, we can
> >>>> use bpf_for_each_map_elem and bpf_map_delete_elem to scan and update the
> >>>> map? With this approach, we only need one syscall per period.
> >>>
> >>> Interesting, I didn't know we can explicitly trigger a BPF program running
> >>> from user-space. Is it for testing purposes only?
> >>
> >> This is not only for testing. We will use this in perf (starting in 5.13).
> >>
> >> /* currently in Arnaldo's tree, tools/perf/util/bpf_counter.c: */
> >>
> >> /* trigger the leader program on a cpu */
> >> static int bperf_trigger_reading(int prog_fd, int cpu)
> >> {
> >>        DECLARE_LIBBPF_OPTS(bpf_test_run_opts, opts,
> >>                            .ctx_in = NULL,
> >>                            .ctx_size_in = 0,
> >>                            .flags = BPF_F_TEST_RUN_ON_CPU,
> >>                            .cpu = cpu,
> >>                            .retval = 0,
> >>                );
> >>
> >>        return bpf_prog_test_run_opts(prog_fd, &opts);
> >> }
> >>
> >> test_run also passes return value (retval) back to user space, so we and
> >> adjust the timer interval based on retval.
> >
> > This is really odd, every name here contains a "test" but it is not for testing
> > purposes. You probably need to rename/alias it. ;)
> >
> > So, with this we have to get a user-space daemon running just to keep
> > this "timer" alive. If I want to run it every 1ms, it means I have to issue
> > a syscall BPF_PROG_TEST_RUN every 1ms. Even with a timer fd, we
> > still need poll() and timerfd_settime(). This is a considerable overhead
> > for just a single timer.
>
> sys_bpf() takes about 0.5us. I would expect poll() and timerfd_settime() to
> be slightly faster. So the overhead is less than 0.2% of a single core
> (0.5us x 3 / 1ms). Do we need many counters for conntrack?

This is just for one timer. The whole system may end up with many timers
when we have more and more eBPF programs. So managing the timers
in the use-space would be a problem too someday, clearly one daemon
per-timer does not scale.

>
> >
> > With current design, user-space can just exit after installing the timer,
> > either it can adjust itself or other eBPF code can adjust it, so the per
> > timer overhead is the same as a kernel timer.
>
> I guess we still need to hold a fd to the prog/map? Alternatively, we can
> pin the prog/map, but then the user need to clean it up.

Yes, but I don't see how holding a fd could bring any overhead after
initial setup.

>
> >
> > The visibility to other BPF code is important for the conntrack case,
> > because each time we get an expired item during a lookup, we may
> > want to schedule the GC timer to run sooner. At least this would give
> > users more freedom to decide when to reschedule the timer.
>
> Do we plan to share the timer program among multiple processes (which can
> start and terminate in arbitrary orders)? If that is the case, I can imagine
> a timer program is better than a user space timer.

I mean I want other eBPF program to manage the timers in kernel-space,
as conntrack is mostly in kernel-space. If the timer is only manageable
in user-space, it would seriously limit its use case.

Ideally I even prefer to create timers in kernel-space too, but as I already
explained, this seems impossible to me.

Thanks.

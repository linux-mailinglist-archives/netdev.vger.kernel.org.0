Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B84B35598F
	for <lists+netdev@lfdr.de>; Tue,  6 Apr 2021 18:48:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238957AbhDFQs7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 12:48:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232032AbhDFQs6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Apr 2021 12:48:58 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52014C06174A;
        Tue,  6 Apr 2021 09:48:50 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id cl21-20020a17090af695b02900c61ac0f0e9so1577480pjb.1;
        Tue, 06 Apr 2021 09:48:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4T6m/L1iGqOLNQCcIWVfZFuuoP5focxIhAnjZCm7FnM=;
        b=hRTjuR0wzIDdkgjfKZG32RZx9SG06HBXuvLhWL5aUB2qDOFEWSYB4OIfhIukyCZfoV
         SBCzZGZ2a9ZJDRr6HMnLGy12xTDZbxk5I5o++pVLs4s0MeLx0KZ+IrVv80vImaSrt6H7
         J+54e6ZZKWm3KJq5d8EOD/xcG8mgDRw2SJlLoel1V8AoWE3MP1eSBiSGqTFkR6W3tLBc
         vi2GD5/NaTuxdgWqxVW1X/4H9OHVLAhgPR+6+uorbCuAua+jt1cUJ3tj12MEbWc/Ls9F
         XemiiOjErgUnlUFhWmNYIR3xCLeKsdeelLOv+hM4MuVkF339URu4SNRlrT6edHmVFoXL
         Sokw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4T6m/L1iGqOLNQCcIWVfZFuuoP5focxIhAnjZCm7FnM=;
        b=rEhrlQnodQyVBS7Ra69KRzVU4t/1jLOTrfgy1xQD5vTnU6keOwJzCxG0TX+1WEB2Jo
         adnCA1DaDbHJlhc6z6Bx2xALdbf8pGdrg6ocMgUJ4YftjcYdZxcxrh8QH5UO5CuDg/xM
         KWHsC9Mau8YE9zqWhd6O6rsV6szXPVXcv3qMRfWMRqtG+67X70HsdNL13LJ0ou0fNb2b
         64M88LkT/wIx32K2qRvJm1s0i5dUsLSacInEsLsMjXJDZ/y6IbHagjQRD40oKVj455Qg
         5NqzFARn5XJXG7498/zXykVWzX7EMyxSF++438S5JEKEvWVmrXaJAz2xQKzAlfYXJfG2
         HdyQ==
X-Gm-Message-State: AOAM530UPJwPqmkak9AmFulqMyDNfTB+rczEyUYBAl+9JDUd0wpjo6dX
        AkRHbz2nv/qKWSD0tBJpBnm7qlhg3cNlJTtyM04=
X-Google-Smtp-Source: ABdhPJwzcUkHMdNgkeu8DAYUilo+in7Kss4kLZvIWd3F23A62B2vswFVT4AVoN7ZlZEQzofmr+91sgP+KwaIZgkO4WY=
X-Received: by 2002:a17:902:c407:b029:e7:3568:9604 with SMTP id
 k7-20020a170902c407b02900e735689604mr29211215plk.31.1617727729876; Tue, 06
 Apr 2021 09:48:49 -0700 (PDT)
MIME-Version: 1.0
References: <20210401042635.19768-1-xiyou.wangcong@gmail.com>
 <B42B247A-4D0B-4DE9-B4D3-0C452472532D@fb.com> <CAM_iQpW-cuiYsPsu4mYZxZ1Oixffu2pV1TFg1c+eg9XT3wWwPQ@mail.gmail.com>
 <E0D5B076-A726-4845-8F12-640BAA853525@fb.com> <CAM_iQpWdO7efdcA2ovDsOF9XLhWJGgd6Be5qq0=xLphVBRE_Gw@mail.gmail.com>
 <93BBD473-7E1C-4A6E-8BB7-12E63D4799E8@fb.com> <CAM_iQpXEuxwQvT9FNqDa7y5kNpknA4xMNo_973ncy3iYaF-NTA@mail.gmail.com>
 <390A7E97-6A9A-48E4-A0B0-D1B9F5EB3308@fb.com> <CAM_iQpVZdju0KhTV1_jQYjad4p++hNAfikH5FsaOCZrcGFFDYA@mail.gmail.com>
 <93C90E13-4439-4467-811C-C6E410B1816D@fb.com> <CAM_iQpXrnXU85J=fa5+QjRqgo_evGfkfLU9_-aVdoyM_DJU2nA@mail.gmail.com>
 <DCAF6E05-7690-4B1D-B2AD-633B58E8985F@fb.com> <CAM_iQpW+=-RsxfYU_fWm+=9MSr6EzCvKwUayH3FyaPpopAtpWQ@mail.gmail.com>
 <45B3E744-000D-4958-89C0-A5E83959CD4A@fb.com>
In-Reply-To: <45B3E744-000D-4958-89C0-A5E83959CD4A@fb.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Tue, 6 Apr 2021 09:48:38 -0700
Message-ID: <CAM_iQpVwDvpMa2bVwx-2=ePGrkaeCG2HZh4szO9=vAP4ur4xzw@mail.gmail.com>
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

On Mon, Apr 5, 2021 at 11:18 PM Song Liu <songliubraving@fb.com> wrote:
>
>
>
> > On Apr 5, 2021, at 6:24 PM, Cong Wang <xiyou.wangcong@gmail.com> wrote:
> >
> > On Mon, Apr 5, 2021 at 6:08 PM Song Liu <songliubraving@fb.com> wrote:
> >>
> >>
> >>
> >>> On Apr 5, 2021, at 4:49 PM, Cong Wang <xiyou.wangcong@gmail.com> wrote:
> >>>
> >>> On Fri, Apr 2, 2021 at 4:31 PM Song Liu <songliubraving@fb.com> wrote:
> >>>>
> >>>>
> >>>>
> >>>>> On Apr 2, 2021, at 1:57 PM, Cong Wang <xiyou.wangcong@gmail.com> wrote:
> >>>>>
> >>>>> Ideally I even prefer to create timers in kernel-space too, but as I already
> >>>>> explained, this seems impossible to me.
> >>>>
> >>>> Would hrtimer (include/linux/hrtimer.h) work?
> >>>
> >>> By impossible, I meant it is impossible (to me) to take a refcnt to the callback
> >>> prog if we create the timer in kernel-space. So, hrtimer is the same in this
> >>> perspective.
> >>>
> >>> Thanks.
> >>
> >> I guess I am not following 100%. Here is what I would propose:
> >>
> >> We only introduce a new program type BPF_PROG_TYPE_TIMER. No new map type.
> >> The new program will trigger based on a timer, and the program can somehow
> >> control the period of the timer (for example, via return value).
> >
> > Like we already discussed, with this approach the "timer" itself is not
> > visible to kernel, that is, only manageable in user-space. Or do you disagree?
>
> Do you mean we need mechanisms to control the timer, like stop the timer,
> trigger the timer immediately, etc.? And we need these mechanisms in kernel?
> And by "in kernel-space" I assume you mean from BPF programs.

Yes, of course. In the context of our discussion, kernel-space only means
eBPF code running in kernel-space. And like I showed in pseudo code,
we want to manage the timer in eBPF code too, that is, updating timer
expiration time and even deleting a timer. The point is we want to give
users as much flexibility as possible, so that they can use it in whatever
scenarios they want. We do not decide how they use them, they do.

>
> If these are correct, how about something like:
>
> 1. A new program BPF_PROG_TYPE_TIMER, which by default will trigger on a timer.
>    Note that, the timer here is embedded in the program. So all the operations
>    are on the program.
> 2. Allow adding such BPF_PROG_TYPE_TIMER programs to a map of type
>    BPF_MAP_TYPE_PROG_ARRAY.
> 3. Some new helpers that access the program via the BPF_MAP_TYPE_PROG_ARRAY map.
>    Actually, maybe we can reuse existing bpf_tail_call().

Reusing bpf_tail_call() just for timer sounds even crazier than
my current approach. So... what's the advantage of your approach
compared to mine?


>
> The BPF program and map will look like:
>
> ==================== 8< ==========================
> struct data_elem {
>         __u64 expiration;
>         /* other data */
> };

So, expiration is separated from "timer" itself. Naturally, expiration
belongs to the timer itself.

>
> struct {
>         __uint(type, BPF_MAP_TYPE_PERCPU_ARRAY);
>         __uint(max_entries, 256);
>         __type(key, __u32);
>         __type(value, struct data_elem);
> } data_map SEC(".maps");
>
> struct {
>         __uint(type, BPF_MAP_TYPE_PERCPU_ARRAY);
>         __uint(max_entries, 256);
>         __type(key, __u32);
>         __type(value, __u64);
> } timer_prog_map SEC(".maps");

So, users have to use two maps just for a timer. Looks unnecessarily
complex to me.

>
> static __u64
> check_expired_elem(struct bpf_map *map, __u32 *key, __u64 *val,
>                  int *data)
> {
>         u64 expires = *val;
>
>         if (expires < bpf_jiffies64()) {

Value is a 64-bit 'expiration', so it is not atomic to read/write it on 32bit
CPU. And user-space could update it in parallel to this timer callback.
So basically we have to use a bpf spinlock here.


>                 bpf_map_delete_elem(map, key);
>                 *data++;
>         }
>  return 0;
> }
>
> SEC("timer")
> int clean_up_timer(void)
> {
>         int count;
>
>         bpf_for_each_map_elem(&data_map, check_expired_elem, &count, 0);
>         if (count)
>                 return 0; // not re-arm this timer
>         else
>                 return 10; // reschedule this timer after 10 jiffies
> }
>
> SEC("tp_btf/XXX")
> int another_trigger(void)
> {
>         if (some_condition)
>                 bpf_tail_call(NULL, &timer_prog_map, idx);

Are you sure you can use bpf_tail_call() to call a prog asynchronously?


>         return 0;
> }
>
> ==================== 8< ==========================
>
> Would something like this work for contract?

Thanks.

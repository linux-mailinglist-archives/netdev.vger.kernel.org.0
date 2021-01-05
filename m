Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CAED2EB15E
	for <lists+netdev@lfdr.de>; Tue,  5 Jan 2021 18:28:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730557AbhAER2j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 12:28:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728044AbhAER2j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jan 2021 12:28:39 -0500
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E21FC061574;
        Tue,  5 Jan 2021 09:27:58 -0800 (PST)
Received: by mail-lf1-x136.google.com with SMTP id b26so185176lff.9;
        Tue, 05 Jan 2021 09:27:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5Xpp8wKKG2mq9Ot9mVJoX4+mjSGU+CSKGEl0a3j5GNs=;
        b=XRLBO9zaCdKj6nBObKVGifutQqlHGQZ2XUQaiNLl7HAT1ZvdSDMXa7pSidQN/tKP1+
         l60jV3CoNqzH8KBu/aCYljZlJXmLiWgpMi3SxsmF5tgphuhU+7u2Q5dGCTUkHhG6ZOkz
         H4GRJWQ446CznEk+vb0NhdEsnDjdlsktDjAt/d2BoyZyUMBPCgjcBtG16FFi2X9LltcZ
         JvJxrlHsNtbfDQ+3CxSqmaoIMLEWLS8u6YIR7bTW31i6S70KWKBfDZJSOdYifUJdwsSZ
         DXEE3dKN7Hc+EWryxaXypJIc36+X5HxKZGA6xMLLHPocnwbrvAU1ki0LuNwY+fIhIqWu
         iTGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5Xpp8wKKG2mq9Ot9mVJoX4+mjSGU+CSKGEl0a3j5GNs=;
        b=hxsYXceSMestcDmj9T8ILyc8v6pgOjBAct7/aYhjW1eg92l7pu3FPUrqEi0pSPhyap
         +1RxR02ABSI/9c/FRwmeiWDjSP8Qn3ZdhfTsahv3AxbZbUwpOEHDFI6OpiFL9EzsLyIs
         4H3Zl2e72ym0jO3oFH4HPj7H2va/U09yNLTNPzALjs/+WS/Fi4dyqjnLzidQ4SNlmOJ4
         PzQ8w1pbJRbRe/kZcUnt9d9tSImCj478S8owpCatws7bvyyr1KaGWATXXYI8OErFFfqA
         lzitl0MTK1cvKlti7mCrhLfFAzIVFCPkeZMi4wpaxhgwVPchCRA1zI+8Q3g53ZqtFzKH
         vdLw==
X-Gm-Message-State: AOAM533LisbeR7x6NNHQiD7psXDGKmOvbCwCSj5Uns002r3ZcYSNNIcB
        bycr276gz5A8RSBs7V+y8IPKbdxbDV0DejtlH0o=
X-Google-Smtp-Source: ABdhPJx1x3qnkN/D30wgcAomkRUhVJDgzVPa6/f7ayKY0EtfTPB+y4GX8tdGaGsyXu+7i/30QJLvbr7JfjsZcjjU7R0=
X-Received: by 2002:a2e:3314:: with SMTP id d20mr309461ljc.21.1609867676825;
 Tue, 05 Jan 2021 09:27:56 -0800 (PST)
MIME-Version: 1.0
References: <20201215233702.3301881-1-songliubraving@fb.com>
 <20201215233702.3301881-2-songliubraving@fb.com> <20201217190308.insbsxpf6ujapbs3@ast-mbp>
 <C4D9D25A-C3DD-4081-9EAD-B7A5B6B74F45@fb.com> <20201218023444.i6hmdi3bp5vgxou2@ast-mbp>
 <D964C66B-2C25-4C3D-AFDE-E600364A721C@fb.com> <CAADnVQJyTVgnsDx6bJ1t-Diib9r+fiph9Ax-d97qSMvU3iKcRw@mail.gmail.com>
 <231d0521-62a7-427b-5351-359092e73dde@fb.com> <09DA43B9-0F6F-45C1-A60D-12E61493C71F@fb.com>
 <20210105014625.krtz3uzqtfu4y7m5@ast-mbp> <6E122A14-0F77-46F9-8891-EDF4DB494E37@fb.com>
 <CAADnVQJ5eKCnkoUV-K-S80-0CGLNstNw50OX2tndLM+Or+CSHQ@mail.gmail.com> <EB23A240-8A1B-468B-86C8-CF372FE745C5@fb.com>
In-Reply-To: <EB23A240-8A1B-468B-86C8-CF372FE745C5@fb.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 5 Jan 2021 09:27:45 -0800
Message-ID: <CAADnVQLg-kQ9Neva0DvUW8CMiuNhv0HTHdsV5fgV8+ra98wE5w@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 1/4] bpf: introduce task_vma bpf_iter
To:     Song Liu <songliubraving@fb.com>
Cc:     Yonghong Song <yhs@fb.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "andrii@kernel.org" <andrii@kernel.org>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "kpsingh@chromium.org" <kpsingh@chromium.org>,
        Kernel Team <Kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 5, 2021 at 9:11 AM Song Liu <songliubraving@fb.com> wrote:
>
>
>
> > On Jan 5, 2021, at 8:27 AM, Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:
> >
> > On Mon, Jan 4, 2021 at 9:47 PM Song Liu <songliubraving@fb.com> wrote:
> >>
> >>
> >>
> >>> On Jan 4, 2021, at 5:46 PM, Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:
> >>>
> >>> On Fri, Dec 18, 2020 at 05:23:25PM +0000, Song Liu wrote:
> >>>>
> >>>>
> >>>>> On Dec 18, 2020, at 8:38 AM, Yonghong Song <yhs@fb.com> wrote:
> >>>>>
> >>>>>
> >>>>>
> >>>>> On 12/17/20 9:23 PM, Alexei Starovoitov wrote:
> >>>>>> On Thu, Dec 17, 2020 at 8:33 PM Song Liu <songliubraving@fb.com> wrote:
> >>>>>>>>
> >>>>>>>> ahh. I missed that. Makes sense.
> >>>>>>>> vm_file needs to be accurate, but vm_area_struct should be accessed as ptr_to_btf_id.
> >>>>>>>
> >>>>>>> Passing pointer of vm_area_struct into BPF will be tricky. For example, shall we
> >>>>>>> allow the user to access vma->vm_file? IIUC, with ptr_to_btf_id the verifier will
> >>>>>>> allow access of vma->vm_file as a valid pointer to struct file. However, since the
> >>>>>>> vma might be freed, vma->vm_file could point to random data.
> >>>>>> I don't think so. The proposed patch will do get_file() on it.
> >>>>>> There is actually no need to assign it into a different variable.
> >>>>>> Accessing it via vma->vm_file is safe and cleaner.
> >>>>>
> >>>>> I did not check the code but do you have scenarios where vma is freed but old vma->vm_file is not freed due to reference counting, but
> >>>>> freed vma area is reused so vma->vm_file could be garbage?
> >>>>
> >>>> AFAIK, once we unlock mmap_sem, the vma could be freed and reused. I guess ptr_to_btf_id
> >>>> or probe_read would not help with this?
> >>>
> >>> Theoretically we can hack the verifier to treat some ptr_to_btf_id as "less
> >>> valid" than the other ptr_to_btf_id, but the user experience will not be great.
> >>> Reading such bpf prog will not be obvious. I think it's better to run bpf prog
> >>> in mmap_lock then and let it access vma->vm_file. After prog finishes the iter
> >>> bit can do if (mmap_lock_is_contended()) before iterating. That will deliver
> >>> better performance too. Instead of task_vma_seq_get_next() doing
> >>> mmap_lock/unlock at every vma. No need for get_file() either. And no
> >>> __vm_area_struct exposure.
> >>
> >> I think there might be concern calling BPF program with mmap_lock, especially that
> >> the program is sleepable (for bpf_d_path). It shouldn't be a problem for common
> >> cases, but I am not 100% sure for corner cases (many instructions in BPF + sleep).
> >> Current version is designed to be very safe for the workload, which might be too
> >> conservative.
> >
> > I know and I agree with all that, but how do you propose to fix the
> > vm_file concern
> > without holding the lock while prog is running? I couldn't come up with a way.
>
> I guess the gap here is that I don't see why __vm_area_struct exposure is an issue.
> It is similar to __sk_buff, and simpler (though we had more reasons to introduce
> __sk_buff back when there wasn't BTF).
>
> If we can accept __vm_area_struct, current version should work, as it doesn't have
> problem with vm_file

True. The problem with __vm_area_struct is that it is a hard coded
uapi with little to none
extensibility. In this form vma iterator is not really useful beyond
the example in selftest.

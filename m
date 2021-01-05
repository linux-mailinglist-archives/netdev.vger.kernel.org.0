Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBF402EB006
	for <lists+netdev@lfdr.de>; Tue,  5 Jan 2021 17:28:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728440AbhAEQ2B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 11:28:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726827AbhAEQ2B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jan 2021 11:28:01 -0500
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E5C4C061574;
        Tue,  5 Jan 2021 08:27:21 -0800 (PST)
Received: by mail-lf1-x129.google.com with SMTP id o13so73989557lfr.3;
        Tue, 05 Jan 2021 08:27:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LDR5huaMnhKWOdBFRFS1M8FgUWRZwltZZXIo/H14IHE=;
        b=hYYZIVJ0mP9upp8BO6c8thauCsqnM2EYQdjbzcqd91guQbh5WyRV2u+4l8C/aPGWup
         STmTPUHRzPbiPH0EGczI4T79PECqRxZ0+juYi3NmRQMBKMKiFEbR9nUxtSvM8KpqMVUa
         KujZiXEQQc9cdYw7mzgoyNX+rk5egGloGY1v3jNA/zosA2NIveQjtw5LRDfDqrihd7bt
         uKodyheNfvp2uMtAoxK0H8KU5DQQnqRbzI8BNuB2R08T1QzS3bW+p+K1uJCkpGNL3F4o
         JHFt6rECJSZKV9vznImtuqlwfE2QI/AEqfb4hEOGgMA5u3tJN+29Ji3/xjvmGiZfZ2t0
         WCHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LDR5huaMnhKWOdBFRFS1M8FgUWRZwltZZXIo/H14IHE=;
        b=pxca6Tl1mvtKZMdavLJlMKvI3jhfiA0sKxKGY109ap6R/CQ4rBBuZrdHCZ3q7YgFGw
         2sEZGX3GT3Mi1b1TYvbbyKz4kY/MTbDCeY+CvFaz7cF2F91/zsK1SRCwC3rPu9fIaE1q
         G4Dx3gQJf6bkv7rAOSTpClz2XvuZOJ5XWdzj5Oac/hbHc5yT0FfcuM+bvJvAi9mKGxNp
         sJTmjYapPX2TQLn5GWem1HWqaXce/vtbkeLHFUjtxhBbE5M4wy7VHC5gvKpkNFkcDb6g
         MvxByT36gIW+NfKp/vSFWfUsLtvnNTF+V0EpQA3ZCTgfikebMcvDNZ4S6O9F/KPYtEDQ
         o2gg==
X-Gm-Message-State: AOAM530Kbz9GKK6NAMg2hglx1XnamQzklNR70V40lOFQTMwa3/9OHGFp
        IpXIL/1qHUzz4YAzBGISXhcnybJJNgWmwp+n8UaLuXaucEM=
X-Google-Smtp-Source: ABdhPJz8Hkl5A5o6WZUQuMyuZdXWn2cw8hYSREkCe4JrcZYrAMGt+VgkW/VipxO0Hd/OX0GYi1h/lf69/y5Du63E+6I=
X-Received: by 2002:ac2:5497:: with SMTP id t23mr29269lfk.534.1609864039532;
 Tue, 05 Jan 2021 08:27:19 -0800 (PST)
MIME-Version: 1.0
References: <20201215233702.3301881-1-songliubraving@fb.com>
 <20201215233702.3301881-2-songliubraving@fb.com> <20201217190308.insbsxpf6ujapbs3@ast-mbp>
 <C4D9D25A-C3DD-4081-9EAD-B7A5B6B74F45@fb.com> <20201218023444.i6hmdi3bp5vgxou2@ast-mbp>
 <D964C66B-2C25-4C3D-AFDE-E600364A721C@fb.com> <CAADnVQJyTVgnsDx6bJ1t-Diib9r+fiph9Ax-d97qSMvU3iKcRw@mail.gmail.com>
 <231d0521-62a7-427b-5351-359092e73dde@fb.com> <09DA43B9-0F6F-45C1-A60D-12E61493C71F@fb.com>
 <20210105014625.krtz3uzqtfu4y7m5@ast-mbp> <6E122A14-0F77-46F9-8891-EDF4DB494E37@fb.com>
In-Reply-To: <6E122A14-0F77-46F9-8891-EDF4DB494E37@fb.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 5 Jan 2021 08:27:08 -0800
Message-ID: <CAADnVQJ5eKCnkoUV-K-S80-0CGLNstNw50OX2tndLM+Or+CSHQ@mail.gmail.com>
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

On Mon, Jan 4, 2021 at 9:47 PM Song Liu <songliubraving@fb.com> wrote:
>
>
>
> > On Jan 4, 2021, at 5:46 PM, Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:
> >
> > On Fri, Dec 18, 2020 at 05:23:25PM +0000, Song Liu wrote:
> >>
> >>
> >>> On Dec 18, 2020, at 8:38 AM, Yonghong Song <yhs@fb.com> wrote:
> >>>
> >>>
> >>>
> >>> On 12/17/20 9:23 PM, Alexei Starovoitov wrote:
> >>>> On Thu, Dec 17, 2020 at 8:33 PM Song Liu <songliubraving@fb.com> wrote:
> >>>>>>
> >>>>>> ahh. I missed that. Makes sense.
> >>>>>> vm_file needs to be accurate, but vm_area_struct should be accessed as ptr_to_btf_id.
> >>>>>
> >>>>> Passing pointer of vm_area_struct into BPF will be tricky. For example, shall we
> >>>>> allow the user to access vma->vm_file? IIUC, with ptr_to_btf_id the verifier will
> >>>>> allow access of vma->vm_file as a valid pointer to struct file. However, since the
> >>>>> vma might be freed, vma->vm_file could point to random data.
> >>>> I don't think so. The proposed patch will do get_file() on it.
> >>>> There is actually no need to assign it into a different variable.
> >>>> Accessing it via vma->vm_file is safe and cleaner.
> >>>
> >>> I did not check the code but do you have scenarios where vma is freed but old vma->vm_file is not freed due to reference counting, but
> >>> freed vma area is reused so vma->vm_file could be garbage?
> >>
> >> AFAIK, once we unlock mmap_sem, the vma could be freed and reused. I guess ptr_to_btf_id
> >> or probe_read would not help with this?
> >
> > Theoretically we can hack the verifier to treat some ptr_to_btf_id as "less
> > valid" than the other ptr_to_btf_id, but the user experience will not be great.
> > Reading such bpf prog will not be obvious. I think it's better to run bpf prog
> > in mmap_lock then and let it access vma->vm_file. After prog finishes the iter
> > bit can do if (mmap_lock_is_contended()) before iterating. That will deliver
> > better performance too. Instead of task_vma_seq_get_next() doing
> > mmap_lock/unlock at every vma. No need for get_file() either. And no
> > __vm_area_struct exposure.
>
> I think there might be concern calling BPF program with mmap_lock, especially that
> the program is sleepable (for bpf_d_path). It shouldn't be a problem for common
> cases, but I am not 100% sure for corner cases (many instructions in BPF + sleep).
> Current version is designed to be very safe for the workload, which might be too
> conservative.

I know and I agree with all that, but how do you propose to fix the
vm_file concern
without holding the lock while prog is running? I couldn't come up with a way.

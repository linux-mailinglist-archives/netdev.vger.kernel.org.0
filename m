Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD64B2EB39B
	for <lists+netdev@lfdr.de>; Tue,  5 Jan 2021 20:47:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730859AbhAETrQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 14:47:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728082AbhAETrP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jan 2021 14:47:15 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20EE1C0617A0;
        Tue,  5 Jan 2021 11:46:12 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id b8so306188plx.0;
        Tue, 05 Jan 2021 11:46:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=+jYqlDYXvpHa8JbJwo+pEufYImi8FqdqB5zM1HGb8L4=;
        b=UJEl4GRNmDcJH9PoJ1hpP/sSZQMos5nY7mgHfL/gsWD4wBWzRyfwQmuXjkWgwdRKx/
         Pn2ENI9JcIa5xcQQ0hF5/ykyOcaklyGUDl0jpL4v6uERWYs2PaNp1iRBpGSqAvoaQsqu
         /JFibKjazh+J4FE6sicd9iqsmoRuwsyj1fThU1Nk44e0nINNcuzKPtzxS57Suk0r7Pfl
         QmKC8Q3+NI5RK3RdWBVqgVTCiDWKP0OtLPLanPAR9MP25xzWSwuxUMrnpaF4o0AwKCF/
         DPv9WeMTJiYbT1QKTjqUegjTrHZNd6i6DW/kSdIwwpLQk6lb0IvURxwoIg8lE+KDRixZ
         po3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=+jYqlDYXvpHa8JbJwo+pEufYImi8FqdqB5zM1HGb8L4=;
        b=mECRMIiVV5mwTJXnW3h22ElKPGwfk80opEw45MxN6JzKZHKutTvPgv5+2WM2QDLCao
         jg6B6IIIrnN+UeHclJ4cg8YmnHu47QvJhE5FGdBDN2nwjKW0AsUP8xucG9W+wR39GZIG
         gurDCCPd5ig2y3mtjRT2wEACwbqhYi8xz/ZPlIcCZK2t4OV0M0HSQXgMjASXPgmNy1Rp
         dn+GhtrqJ/c7xp60sfwwq7QQfel2PyMSQzu1IeD32KNZk5hsjlsAY/bc4v68TrdhOYb2
         tDArTrpfHEAKTe4riZmIZ4r95gUDbOHh9uzAi2M0P6GqNibanNsSPxqMPUgP6z4it9R5
         h5dw==
X-Gm-Message-State: AOAM530NSCMrdm81as7/mk5wHZqpcXoN35NiK50tLxG5ogstW7UdU3qJ
        QTKwW+YDmtMw2ZN2wlzfaQg=
X-Google-Smtp-Source: ABdhPJzeAhIWoky8dx7CfCTRWS5U9l8E8I+NtYj++dPhMNRQAZAh6tsJoZhAQmUrHq2hcDKBsnP7dQ==
X-Received: by 2002:a17:902:bf44:b029:da:d140:6f91 with SMTP id u4-20020a170902bf44b02900dad1406f91mr726256pls.51.1609875971691;
        Tue, 05 Jan 2021 11:46:11 -0800 (PST)
Received: from ast-mbp ([2620:10d:c090:400::5:5456])
        by smtp.gmail.com with ESMTPSA id m4sm16878pgv.16.2021.01.05.11.46.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Jan 2021 11:46:10 -0800 (PST)
Date:   Tue, 5 Jan 2021 11:46:08 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
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
Subject: Re: [PATCH v2 bpf-next 1/4] bpf: introduce task_vma bpf_iter
Message-ID: <20210105194608.nywfcrsxsk3n7y7q@ast-mbp>
References: <D964C66B-2C25-4C3D-AFDE-E600364A721C@fb.com>
 <CAADnVQJyTVgnsDx6bJ1t-Diib9r+fiph9Ax-d97qSMvU3iKcRw@mail.gmail.com>
 <231d0521-62a7-427b-5351-359092e73dde@fb.com>
 <09DA43B9-0F6F-45C1-A60D-12E61493C71F@fb.com>
 <20210105014625.krtz3uzqtfu4y7m5@ast-mbp>
 <6E122A14-0F77-46F9-8891-EDF4DB494E37@fb.com>
 <CAADnVQJ5eKCnkoUV-K-S80-0CGLNstNw50OX2tndLM+Or+CSHQ@mail.gmail.com>
 <EB23A240-8A1B-468B-86C8-CF372FE745C5@fb.com>
 <CAADnVQLg-kQ9Neva0DvUW8CMiuNhv0HTHdsV5fgV8+ra98wE5w@mail.gmail.com>
 <48243EAC-D280-4A89-BA72-68E529B6E6FD@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48243EAC-D280-4A89-BA72-68E529B6E6FD@fb.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 05, 2021 at 07:38:08PM +0000, Song Liu wrote:
> 
> 
> > On Jan 5, 2021, at 9:27 AM, Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:
> > 
> > On Tue, Jan 5, 2021 at 9:11 AM Song Liu <songliubraving@fb.com> wrote:
> >> 
> >> 
> >> 
> >>> On Jan 5, 2021, at 8:27 AM, Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:
> >>> 
> >>> On Mon, Jan 4, 2021 at 9:47 PM Song Liu <songliubraving@fb.com> wrote:
> >>>> 
> >>>> 
> >>>> 
> >>>>> On Jan 4, 2021, at 5:46 PM, Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:
> >>>>> 
> >>>>> On Fri, Dec 18, 2020 at 05:23:25PM +0000, Song Liu wrote:
> >>>>>> 
> >>>>>> 
> >>>>>>> On Dec 18, 2020, at 8:38 AM, Yonghong Song <yhs@fb.com> wrote:
> >>>>>>> 
> >>>>>>> 
> >>>>>>> 
> >>>>>>> On 12/17/20 9:23 PM, Alexei Starovoitov wrote:
> >>>>>>>> On Thu, Dec 17, 2020 at 8:33 PM Song Liu <songliubraving@fb.com> wrote:
> >>>>>>>>>> 
> >>>>>>>>>> ahh. I missed that. Makes sense.
> >>>>>>>>>> vm_file needs to be accurate, but vm_area_struct should be accessed as ptr_to_btf_id.
> >>>>>>>>> 
> >>>>>>>>> Passing pointer of vm_area_struct into BPF will be tricky. For example, shall we
> >>>>>>>>> allow the user to access vma->vm_file? IIUC, with ptr_to_btf_id the verifier will
> >>>>>>>>> allow access of vma->vm_file as a valid pointer to struct file. However, since the
> >>>>>>>>> vma might be freed, vma->vm_file could point to random data.
> >>>>>>>> I don't think so. The proposed patch will do get_file() on it.
> >>>>>>>> There is actually no need to assign it into a different variable.
> >>>>>>>> Accessing it via vma->vm_file is safe and cleaner.
> >>>>>>> 
> >>>>>>> I did not check the code but do you have scenarios where vma is freed but old vma->vm_file is not freed due to reference counting, but
> >>>>>>> freed vma area is reused so vma->vm_file could be garbage?
> >>>>>> 
> >>>>>> AFAIK, once we unlock mmap_sem, the vma could be freed and reused. I guess ptr_to_btf_id
> >>>>>> or probe_read would not help with this?
> >>>>> 
> >>>>> Theoretically we can hack the verifier to treat some ptr_to_btf_id as "less
> >>>>> valid" than the other ptr_to_btf_id, but the user experience will not be great.
> >>>>> Reading such bpf prog will not be obvious. I think it's better to run bpf prog
> >>>>> in mmap_lock then and let it access vma->vm_file. After prog finishes the iter
> >>>>> bit can do if (mmap_lock_is_contended()) before iterating. That will deliver
> >>>>> better performance too. Instead of task_vma_seq_get_next() doing
> >>>>> mmap_lock/unlock at every vma. No need for get_file() either. And no
> >>>>> __vm_area_struct exposure.
> >>>> 
> >>>> I think there might be concern calling BPF program with mmap_lock, especially that
> >>>> the program is sleepable (for bpf_d_path). It shouldn't be a problem for common
> >>>> cases, but I am not 100% sure for corner cases (many instructions in BPF + sleep).
> >>>> Current version is designed to be very safe for the workload, which might be too
> >>>> conservative.
> >>> 
> >>> I know and I agree with all that, but how do you propose to fix the
> >>> vm_file concern
> >>> without holding the lock while prog is running? I couldn't come up with a way.
> >> 
> >> I guess the gap here is that I don't see why __vm_area_struct exposure is an issue.
> >> It is similar to __sk_buff, and simpler (though we had more reasons to introduce
> >> __sk_buff back when there wasn't BTF).
> >> 
> >> If we can accept __vm_area_struct, current version should work, as it doesn't have
> >> problem with vm_file
> > 
> > True. The problem with __vm_area_struct is that it is a hard coded
> > uapi with little to none
> > extensibility. In this form vma iterator is not really useful beyond
> > the example in selftest.
> 
> With __vm_area_struct, we can still probe_read the page table, so we can 
> cover more use cases than the selftest. But I agree that it is not as
> extensible as feeding real vm_area_struct with BTF to the BPF program. 

Another confusing thing with __vm_area_struct is vm_flags field.
It's copied directly. As __vm_area_struct->flags this field is uapi field,
but its contents are kernel internal. We avoided such corner cases in the past.
When flags field is copied into uapi the kernel internal flags are encoded
and exposed as separate uapi flags. That was the case with
BPF_TCP_* flags. If we have to do this with vm_flags (VM_EXEC, etc) that
might kill the patchset due to abi concerns.

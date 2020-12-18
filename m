Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90AC72DDCF5
	for <lists+netdev@lfdr.de>; Fri, 18 Dec 2020 03:36:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732261AbgLRCf3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Dec 2020 21:35:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727148AbgLRCf2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Dec 2020 21:35:28 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A162C0617B0;
        Thu, 17 Dec 2020 18:34:48 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id t6so622632plq.1;
        Thu, 17 Dec 2020 18:34:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ZnH5T4aKLfOjMzXL0yFNSOTNgNqgoUdXjh8bRbCOSN0=;
        b=qxj27QHASC8Bboo4VlasgkDgSQpKPtHwExSd3v4UwGJKaoska/04pSi96jfQ8Wyy2Z
         Is8tRd0w6MtMWNq8Jq3hBIhqz103Q/zgMyJYusulVB4zBPpqkp4i8JKRyk5r1kh2xVir
         V2kKWXkIZvVrf8FaBQugBLLUcXzZ6UsnKKZyLrHOaE11WbQrzJN8Fz0WHXOE+90bOpnE
         wHNYi3iBsZ9x1XQGwamAOMqRkxGb0eFHI+XcVbiJpNKRKbX3Vg7XEGuJwCfPQ+BC1UPS
         uxuWMcvf2eFrzwRQxlx3d/9IOAAMyH0fd64zz0nmhJgTWX+6YF4XxomCel407C+sm+I8
         D53Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ZnH5T4aKLfOjMzXL0yFNSOTNgNqgoUdXjh8bRbCOSN0=;
        b=KXVUvvVhnHzLCcjeNKKXyaSvXQvJwfrh+Fgzd3dsrtzOgoto5EZHw7qboxLjeAY5PL
         mQyexGO1XiBwKQ2kWNVq2VZ74nxtpp02il1uDUam5BvzPKmg5rkwXCMRQyt9SmjBxvzm
         LBM1jrLU4xh0j/boJVq7TJXhlKPgf721TDJmMagqM5ypx1FDXT1+1BaHh9sLsYcBdpZV
         gTIYpCFYCnDO60wCjVLsi9CK+YA2vZg3NC6cwh2hBuhi97A0FrWx2emeaIiwoJBY1enV
         rde9d/XImAjpNlh2G6BvMkum7f+x3iPSwp3SgsNuIOQZHYwEfwnOhi0E7dXtT3ifeZP1
         sSNQ==
X-Gm-Message-State: AOAM532fG92I+ewi86BTLElpLi/SPjvaporm9xHLqrd8aU/rvxMm+hak
        z+q5zr3Febp8r53xvQeq/vE=
X-Google-Smtp-Source: ABdhPJyx8nl8fXRVuFZYZYPl2tWp3exI+zj8/2WspRQyUIf87Oe5jj1kf7jopM5NJ8PQCuS9jO/oUQ==
X-Received: by 2002:a17:902:ee86:b029:da:76bc:2aa4 with SMTP id a6-20020a170902ee86b02900da76bc2aa4mr1938846pld.62.1608258888004;
        Thu, 17 Dec 2020 18:34:48 -0800 (PST)
Received: from ast-mbp ([2620:10d:c090:400::5:8bfc])
        by smtp.gmail.com with ESMTPSA id ds24sm5912056pjb.30.2020.12.17.18.34.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Dec 2020 18:34:46 -0800 (PST)
Date:   Thu, 17 Dec 2020 18:34:44 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Song Liu <songliubraving@fb.com>
Cc:     "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "andrii@kernel.org" <andrii@kernel.org>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "kpsingh@chromium.org" <kpsingh@chromium.org>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH v2 bpf-next 1/4] bpf: introduce task_vma bpf_iter
Message-ID: <20201218023444.i6hmdi3bp5vgxou2@ast-mbp>
References: <20201215233702.3301881-1-songliubraving@fb.com>
 <20201215233702.3301881-2-songliubraving@fb.com>
 <20201217190308.insbsxpf6ujapbs3@ast-mbp>
 <C4D9D25A-C3DD-4081-9EAD-B7A5B6B74F45@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <C4D9D25A-C3DD-4081-9EAD-B7A5B6B74F45@fb.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 17, 2020 at 10:08:31PM +0000, Song Liu wrote:
> 
> 
> > On Dec 17, 2020, at 11:03 AM, Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:
> > 
> > On Tue, Dec 15, 2020 at 03:36:59PM -0800, Song Liu wrote:
> >> +/*
> >> + * Key information from vm_area_struct. We need this because we cannot
> >> + * assume the vm_area_struct is still valid after each iteration.
> >> + */
> >> +struct __vm_area_struct {
> >> +	__u64 start;
> >> +	__u64 end;
> >> +	__u64 flags;
> >> +	__u64 pgoff;
> >> +};
> > 
> > Where it's inside .c or exposed in uapi/bpf.h it will become uapi
> > if it's used this way. Let's switch to arbitrary BTF-based access instead.
> > 
> >> +static struct __vm_area_struct *
> >> +task_vma_seq_get_next(struct bpf_iter_seq_task_vma_info *info)
> >> +{
> >> +	struct pid_namespace *ns = info->common.ns;
> >> +	struct task_struct *curr_task;
> >> +	struct vm_area_struct *vma;
> >> +	u32 curr_tid = info->tid;
> >> +	bool new_task = false;
> >> +
> >> +	/* If this function returns a non-NULL __vm_area_struct, it held
> >> +	 * a reference to the task_struct. If info->file is non-NULL, it
> >> +	 * also holds a reference to the file. If this function returns
> >> +	 * NULL, it does not hold any reference.
> >> +	 */
> >> +again:
> >> +	if (info->task) {
> >> +		curr_task = info->task;
> >> +	} else {
> >> +		curr_task = task_seq_get_next(ns, &curr_tid, true);
> >> +		if (!curr_task) {
> >> +			info->task = NULL;
> >> +			info->tid++;
> >> +			return NULL;
> >> +		}
> >> +
> >> +		if (curr_tid != info->tid) {
> >> +			info->tid = curr_tid;
> >> +			new_task = true;
> >> +		}
> >> +
> >> +		if (!curr_task->mm)
> >> +			goto next_task;
> >> +		info->task = curr_task;
> >> +	}
> >> +
> >> +	mmap_read_lock(curr_task->mm);
> > 
> > That will hurt. /proc readers do that and it causes all sorts
> > of production issues. We cannot take this lock.
> > There is no need to take it.
> > Switch the whole thing to probe_read style walking.
> > And reimplement find_vma with probe_read while omitting vmacache.
> > It will be short rbtree walk.
> > bpf prog doesn't need to see a stable struct. It will read it through ptr_to_btf_id
> > which will use probe_read equivalent underneath.
> 
> rw_semaphore is designed to avoid write starvation, so read_lock should not cause
> problem unless the lock was taken for extended period. [1] was a recent fix that 
> avoids /proc issue by releasing mmap_lock between iterations. We are using similar
> mechanism here. BTW: I changed this to mmap_read_lock_killable() in the next version. 
> 
> On the other hand, we need a valid vm_file pointer for bpf_d_path. So walking the 

ahh. I missed that. Makes sense.
vm_file needs to be accurate, but vm_area_struct should be accessed as ptr_to_btf_id.

> rbtree without taking any lock would not work. We can avoid taking the lock when 
> some SPF like mechanism merged (hopefully soonish). 
> 
> Did I miss anything? 
> 
> We can improve bpf_iter with some mechanism to specify which task to iterate, so 
> that we don't have to iterate through all tasks when the user only want to inspect 
> vmas in one task. 

yes. let's figure out how to make it parametrizable.
map_iter runs only for given map_fd.
Maybe vma_iter should run only for given pidfd?
I think all_task_all_vmas iter is nice to have, but we don't really need it?

> Thanks,
> Song
> 
> [1] ff9f47f6f00c ("mm: proc: smaps_rollup: do not stall write attempts on mmap_lock")

Thanks for this link. With "if (mmap_lock_is_contended())" check it should work indeed.

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3069B2DD90E
	for <lists+netdev@lfdr.de>; Thu, 17 Dec 2020 20:06:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730199AbgLQTDw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Dec 2020 14:03:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730127AbgLQTDv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Dec 2020 14:03:51 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D11AC061794;
        Thu, 17 Dec 2020 11:03:11 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id lj6so4166003pjb.0;
        Thu, 17 Dec 2020 11:03:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=34kGMBVVwPEkDlzq3RYJ7RO7Q7CRH3DXPMdy6/jOyz4=;
        b=l9XJLA1SsX0JLlC7Juk+ya+zS5XEVS5nmRVRlwy0BiQDtWgkp7j5xVHbz8lfEV8vM4
         cTGb3Pr9w/EjBSP4z35jE4/3wrNNibLGRZtZa8ti3YxwN2ZFMIWP1kHSy6gmqNkshPIP
         WDtI4yzHhers0G8toLzivpdFyWMhMrG5GPvN1UkmbFp7dugkvE7R652oIVa4GU72JRrz
         lUz5zQKGKAWZ9vNJWgjnXRfrkyfgHdWZaZO3CqpMMcUaexOMnE/6X9y/L5Zry7Olfru+
         zstksoPbWMb4CcMURcImQAMJ7iBVfj3X6R7Ehik8KGAzqf74Ef9MO9tnLHhNlLdp99iM
         W4QQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=34kGMBVVwPEkDlzq3RYJ7RO7Q7CRH3DXPMdy6/jOyz4=;
        b=DPl4VogtFFYNYkFtzNi9FcrhKrNB9+6YYYkm6Pjfb9++nz9fHBe4/NF19yYAcv228e
         GqB10olWHvyrZgoOx7bXz/yFxcQKaL9OYuRXvi1hx365vdvDyDsIjH+Pqrbo0Bss06SK
         UTVtLeDXqXfO+e6uumb8B48+oZu/GUH+2wTWSTl6WehQnepNFKVxGT3U0c375rdnH1pw
         kMLyL5a8fFpfugZbZTIVKWsuqRpqGa/XptC/ZK30dEvlU1TMUjSC5gSsiCWIYSYraIxW
         4rggGBnwgCw+VFQn8SxttLjNr9MXBr75cTMcK+f8idbABW+/mnWs+Zrws1oUL3eoIbP8
         Z7Lg==
X-Gm-Message-State: AOAM533cyFgSQ1okM1gFnR2jW9Hp5uMvSVyp0myRVpjagPE2opjWO/F9
        142g56w3+HEZ59jHsl6A/74=
X-Google-Smtp-Source: ABdhPJwxcrDK4P7kUDtRL9fX1Wxc41OduTuMLTeGlNRl2T7TaUu6PPX7sK85TcoTH4si3AxbMhxuuA==
X-Received: by 2002:a17:902:7c0a:b029:da:62c8:90cb with SMTP id x10-20020a1709027c0ab02900da62c890cbmr583260pll.59.1608231790607;
        Thu, 17 Dec 2020 11:03:10 -0800 (PST)
Received: from ast-mbp ([2620:10d:c090:400::5:682])
        by smtp.gmail.com with ESMTPSA id k9sm5680623pjj.8.2020.12.17.11.03.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Dec 2020 11:03:10 -0800 (PST)
Date:   Thu, 17 Dec 2020 11:03:08 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Song Liu <songliubraving@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, john.fastabend@gmail.com,
        kpsingh@chromium.org, kernel-team@fb.com
Subject: Re: [PATCH v2 bpf-next 1/4] bpf: introduce task_vma bpf_iter
Message-ID: <20201217190308.insbsxpf6ujapbs3@ast-mbp>
References: <20201215233702.3301881-1-songliubraving@fb.com>
 <20201215233702.3301881-2-songliubraving@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201215233702.3301881-2-songliubraving@fb.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 15, 2020 at 03:36:59PM -0800, Song Liu wrote:
> +/*
> + * Key information from vm_area_struct. We need this because we cannot
> + * assume the vm_area_struct is still valid after each iteration.
> + */
> +struct __vm_area_struct {
> +	__u64 start;
> +	__u64 end;
> +	__u64 flags;
> +	__u64 pgoff;
> +};

Where it's inside .c or exposed in uapi/bpf.h it will become uapi
if it's used this way. Let's switch to arbitrary BTF-based access instead.

> +static struct __vm_area_struct *
> +task_vma_seq_get_next(struct bpf_iter_seq_task_vma_info *info)
> +{
> +	struct pid_namespace *ns = info->common.ns;
> +	struct task_struct *curr_task;
> +	struct vm_area_struct *vma;
> +	u32 curr_tid = info->tid;
> +	bool new_task = false;
> +
> +	/* If this function returns a non-NULL __vm_area_struct, it held
> +	 * a reference to the task_struct. If info->file is non-NULL, it
> +	 * also holds a reference to the file. If this function returns
> +	 * NULL, it does not hold any reference.
> +	 */
> +again:
> +	if (info->task) {
> +		curr_task = info->task;
> +	} else {
> +		curr_task = task_seq_get_next(ns, &curr_tid, true);
> +		if (!curr_task) {
> +			info->task = NULL;
> +			info->tid++;
> +			return NULL;
> +		}
> +
> +		if (curr_tid != info->tid) {
> +			info->tid = curr_tid;
> +			new_task = true;
> +		}
> +
> +		if (!curr_task->mm)
> +			goto next_task;
> +		info->task = curr_task;
> +	}
> +
> +	mmap_read_lock(curr_task->mm);

That will hurt. /proc readers do that and it causes all sorts
of production issues. We cannot take this lock.
There is no need to take it.
Switch the whole thing to probe_read style walking.
And reimplement find_vma with probe_read while omitting vmacache.
It will be short rbtree walk.
bpf prog doesn't need to see a stable struct. It will read it through ptr_to_btf_id
which will use probe_read equivalent underneath.

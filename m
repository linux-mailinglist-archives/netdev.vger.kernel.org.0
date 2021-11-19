Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEA2045692F
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 05:33:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233423AbhKSEgc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 23:36:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229754AbhKSEgb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Nov 2021 23:36:31 -0500
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5844C061574;
        Thu, 18 Nov 2021 20:33:30 -0800 (PST)
Received: by mail-pf1-x435.google.com with SMTP id m14so8280030pfc.9;
        Thu, 18 Nov 2021 20:33:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=wUYPD/dK7AbnmjRt7DrfQALSJEYOeqazWN+/nDCsZLE=;
        b=a2hOSHDbbGGI/Snv4mcOO+vrCftQw4roHy+cd6KGotO6J02ATNiF0hoYAbTTNMwb7W
         KkDkfLCikndxpSP0pUpRx8sf0vpEGC+dZC/Is0QucWsR9vQPLodQivhxlLw5Q/5/7ISm
         xltnpoduAlf2krlb4/olzkA1vuqSR8qWx5pOc/onmJsJDe/RAjMn4aXLgRvWB/YKwYDP
         VYQYSC8U9VQjSyx2GXiOSDQ271JOWJ6wp2G3s0ofgwvl8P5m22gY/Z6QpMmJs5x0VShW
         14wSspIzOnYZIwwrkQ6Q0bFiCQb6qf+1FsIyHIhE7/RyCQelp6KRCpcFFIh466ScHX/a
         gNlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=wUYPD/dK7AbnmjRt7DrfQALSJEYOeqazWN+/nDCsZLE=;
        b=o6Oo4t/0TPeCnzf/RqXZY8LgfYlXPiJLY1qTXDVWDKnLoHdGZMDoOXW1jdtVegMBDg
         7efyWaJHju9/YM1SIa80Yy4hThTpdkmY3aArgsWug17tiyuEfjmijkQDA7+8Ea9kvbq7
         01bD1SKpjM9DXlQ076PCCIQgYGreCQFfg1waNLBCfns/aYL4hCsYz+hxRyChDcH2g4U4
         G5FvLr0uyBlQV54KzBtKxeEMb0CVs74FjWHPhhZoBAvnIKObg2d5+M67QoYPgabdZrB3
         KeTIVgWlEbmuH160CLcm74H8msFswd5kJ+VCS9Kip2vreFKBWpToLRnmPqqlaOoSpEtW
         T7NQ==
X-Gm-Message-State: AOAM531v2RFP88PH0esDwc8+Cpj6sx5jr16OfB0SY8L0Q7YQIbPvoRwp
        qsKKj5wOwjsMbFgUxctWO3E=
X-Google-Smtp-Source: ABdhPJwjdFNtrn4pAEY6hHtGXWt8HOw1WUzDFERb/z8hEPaVAxeBm6/u7oj4sAyn10TnHd2eutqWVw==
X-Received: by 2002:a62:1e81:0:b0:4a3:7a97:d868 with SMTP id e123-20020a621e81000000b004a37a97d868mr4167067pfe.52.1637296410204;
        Thu, 18 Nov 2021 20:33:30 -0800 (PST)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:4e33])
        by smtp.gmail.com with ESMTPSA id b4sm1193366pfl.60.2021.11.18.20.33.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Nov 2021 20:33:29 -0800 (PST)
Date:   Thu, 18 Nov 2021 20:33:26 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Kenny Ho <Kenny.Ho@amd.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Tejun Heo <tj@kernel.org>,
        Zefan Li <lizefan.x@bytedance.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        cgroups@vger.kernel.org, linux-perf-users@vger.kernel.org,
        y2kenny@gmail.com, amd-gfx@lists.freedesktop.org
Subject: Re: [PATCH RFC 4/4] bpf,cgroup,perf: extend bpf-cgroup to support
 tracepoint attachment
Message-ID: <20211119043326.a4pmgitlkljpamgh@ast-mbp.dhcp.thefacebook.com>
References: <20211118202840.1001787-1-Kenny.Ho@amd.com>
 <20211118202840.1001787-5-Kenny.Ho@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211118202840.1001787-5-Kenny.Ho@amd.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 18, 2021 at 03:28:40PM -0500, Kenny Ho wrote:
> @@ -245,6 +256,21 @@ static int compute_effective_progs(struct cgroup *cgrp,
>  	if (!progs)
>  		return -ENOMEM;
>  
> +	if (atype == CGROUP_TRACEPOINT) {
> +		/* TODO: only create event for cgroup that can have process */
> +
> +		attr.config = bpf_attach_subtype;
> +		attr.type = PERF_TYPE_TRACEPOINT;
> +		attr.sample_type = PERF_SAMPLE_RAW;
> +		attr.sample_period = 1;
> +		attr.wakeup_events = 1;
> +
> +		rc = perf_event_create_for_all_cpus(&attr, cgrp,
> +				&cgrp->bpf.per_cg_events);
> +		if (rc)
> +			goto err;
> +	}
...
> +int perf_event_create_for_all_cpus(struct perf_event_attr *attr,
> +				struct cgroup *cgroup,
> +				struct list_head *entries)
> +{
> +	struct perf_event **events;
> +        struct perf_cgroup *perf_cgrp;
> +	int cpu, i = 0;
> +
> +	events = kzalloc(sizeof(struct perf_event *) * num_possible_cpus(),
> +			GFP_KERNEL);
> +
> +	if (!events)
> +		return -ENOMEM;
> +
> +	for_each_possible_cpu(cpu) {
> +		/* allocate first, connect the cgroup later */
> +		events[i] = perf_event_create_kernel_counter(attr, cpu, NULL, NULL, NULL);

This is a very heavy hammer for this task.
There is really no need for perf_event to be created.
Did you consider using raw_tp approach instead?
It doesn't need this heavy stuff.
Also I suspect in follow up you'd be adding tracepoints to GPU code?
Did you consider just leaving few __weak global functions in GPU code
and let bpf progs attach to them as fentry?
I suspect the true hierarchical nature of bpf-cgroup framework isn't necessary.
The bpf program itself can filter for given cgroup.
We have bpf_current_task_under_cgroup() and friends.
I suggest to sprinkle __weak empty funcs in GPU and see what
you can do with it with fentry and bpf_current_task_under_cgroup.
There is also bpf_get_current_ancestor_cgroup_id().

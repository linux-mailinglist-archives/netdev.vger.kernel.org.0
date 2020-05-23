Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE2B81DF83C
	for <lists+netdev@lfdr.de>; Sat, 23 May 2020 18:30:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728091AbgEWQaB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 May 2020 12:30:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727884AbgEWQaB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 May 2020 12:30:01 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D112C061A0E;
        Sat, 23 May 2020 09:30:01 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id k22so5641362pls.10;
        Sat, 23 May 2020 09:30:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=6pAXMPbHbvLSWlK9WHtxQGZ5oIoO4iFw14tKjUPAMAA=;
        b=oRMDVrL0qv58KOSmQfSrcMW3YBaGg8LvtAoDn1gBbAJ1m3BQCCxIUHgBgeoVXpu9Ze
         YOO4ai731UMt5spKe/HRTRiKNI4He8J4mjr3ScCbMVEnlU1xJclHNI4yOFTrASfk4mjj
         5IDXUXaYAeNAEjULqTZtLWf1oI8IXLZsIJsNi3IwAkXa5Rs3w1d6LONOn4j4YVICv28h
         JIxH/js5/EMbooYVK72cECwIhxeX0r2sHMMF50EkMTy1ezOUnZs4hmPgJgkrPqUGTK6l
         qB49yl2ZMEEcZZoBhZDlZV6cjaAQu9NBFGsJbDuxXxSnn0EzkwIKLZHaO+n5dwcnPS7l
         4cww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=6pAXMPbHbvLSWlK9WHtxQGZ5oIoO4iFw14tKjUPAMAA=;
        b=JEnOTKF7iRFWuHc3CQhsMkxeao1qn7NRyZw/U/nrqrlCvPl7hmS4ZvYriyvnsEAvUA
         B+xqiPhxv90RpzeP2IsktyP1+in7yNEhTLalPDudT1kqPGMtw/ksIzG8+HMug/YOA+iA
         XqQibABPwCHjMN/G2BljmJjVTzFaCHSQf1ly/QnkQY3yPWpEFhMB0QN6TNCQJxCpU3Et
         BbXzRXzYhvf/2gtpUenzMieskBu+mfi/q3aWqn95zA4rIEnIitjM97bCy+zbawTh41S7
         19NLYBRS7gTpaISzRxQNIjSoo2IxOQlpNMCnPMAPPPhFteA4myQTNZPOofIGlu92M1G0
         nuKw==
X-Gm-Message-State: AOAM531nDO8I1VWzTg0SBVjGBa3v8k7+XyF2yrUGt2KU9F/1aTuYZG3U
        6DiYdDipeXlLTzL9s+tFVdLf28Mw
X-Google-Smtp-Source: ABdhPJw10LDTk7fdab6CG7yCB0CKqhKyL/HHY9JnqVwA4pVz6e2Bww4uhjx7hdpGaEAbKJKybDyE5Q==
X-Received: by 2002:a17:90b:1994:: with SMTP id mv20mr10999577pjb.41.1590251400856;
        Sat, 23 May 2020 09:30:00 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id e15sm9462760pfh.23.2020.05.23.09.29.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 May 2020 09:29:59 -0700 (PDT)
Date:   Sat, 23 May 2020 09:29:50 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>, yhs@fb.com,
        andrii.nakryiko@gmail.com, ast@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, jakub@cloudflare.com,
        lmb@cloudflare.com
Message-ID: <5ec94f7eb8377_103c2ab70a8e65c0d1@john-XPS-13-9370.notmuch>
In-Reply-To: <f6f5b27f-0a60-0e86-6e7b-f721b069a88c@iogearbox.net>
References: <159012108670.14791.18091717338621259928.stgit@john-Precision-5820-Tower>
 <159012146282.14791.7652481804905295417.stgit@john-Precision-5820-Tower>
 <f6f5b27f-0a60-0e86-6e7b-f721b069a88c@iogearbox.net>
Subject: Re: [bpf-next PATCH v4 2/5] bpf: extend bpf_base_func_proto helpers
 with probe_* and *current_task*
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Daniel Borkmann wrote:
> On 5/22/20 6:24 AM, John Fastabend wrote:
> > Often it is useful when applying policy to know something about the
> > task. If the administrator has CAP_SYS_ADMIN rights then they can
> > use kprobe + networking hook and link the two programs together to
> > accomplish this. However, this is a bit clunky and also means we have
> > to call both the network program and kprobe program when we could just
> > use a single program and avoid passing metadata through sk_msg/skb->cb,
> > socket, maps, etc.
> > 
> > To accomplish this add probe_* helpers to bpf_base_func_proto programs
> > guarded by a perfmon_capable() check. New supported helpers are the
> > following,
> > 
> >   BPF_FUNC_get_current_task
> >   BPF_FUNC_current_task_under_cgroup
> >   BPF_FUNC_probe_read_user
> >   BPF_FUNC_probe_read_kernel
> >   BPF_FUNC_probe_read_user_str
> >   BPF_FUNC_probe_read_kernel_str
> > 
> > Signed-off-by: John Fastabend <john.fastabend@gmail.com>
> > Acked-by: Yonghong Song <yhs@fb.com>

[...]

> >   bpf_base_func_proto(enum bpf_func_id func_id)
> >   {
> > @@ -648,6 +655,26 @@ bpf_base_func_proto(enum bpf_func_id func_id)
> >   	case BPF_FUNC_jiffies64:
> >   		return &bpf_jiffies64_proto;
> >   	default:
> > +		break;
> > +	}
> > +
> > +	if (!perfmon_capable())
> > +		return NULL;
> > +
> > +	switch (func_id) {
> > +	case BPF_FUNC_get_current_task:
> > +		return &bpf_get_current_task_proto;
> > +	case BPF_FUNC_current_task_under_cgroup:
> > +		return &bpf_current_task_under_cgroup_proto;
> 
> Afaics, the map creation of BPF_MAP_TYPE_CGROUP_ARRAY is only tied to CAP_BPF and
> the bpf_current_task_under_cgroup() technically is not strictly tracing related.
> We do have similar bpf_skb_under_cgroup() for this map type in networking, for
> example, so 'current' is the only differentiator between the two.
> 
> Imho, the get_current_task() and memory probes below are fine and perfmon_capable()
> is also required for them. It's just that this one above stands out from the rest,
> and while thinking about it, what is the rationale for enabling bpf_current_task_under_cgroup()
> but not e.g. bpf_get_current_cgroup_id() or bpf_get_current_ancestor_cgroup_id() helpers
> that you've added in prior patch to sk_msg_func_proto()? What makes these different?

I think the only reason I split it like this is it required touching bpf_trace.c
on the code side.


> 
> The question is also wrt cgroup helpers on how reliable they could be used, say, in
> networking programs when we're under softirq instead of process context? Something
> would need to be documented at min, but I think it's probably best to say that we
> allow retrieving current and the probe mem helpers only, given for these cases you're
> on your own anyway and have to know what you're doing.. while the others can be used
> w/o much thought in some cases where we always have a valid current (like sock_addr
> progs), but not in others tc/BPF or XDP. Wdyt?
> 

That is a good analysis. Let me just drop the current_task_under_cgroup here and then
we can add it on a per context basis.

Thanks,
John

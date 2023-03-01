Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43F3D6A656A
	for <lists+netdev@lfdr.de>; Wed,  1 Mar 2023 03:22:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229672AbjCACWS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Feb 2023 21:22:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229625AbjCACWR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Feb 2023 21:22:17 -0500
Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5406B303F4;
        Tue, 28 Feb 2023 18:22:13 -0800 (PST)
Received: by mail-qt1-f171.google.com with SMTP id l18so11773831qtp.1;
        Tue, 28 Feb 2023 18:22:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677637332;
        h=user-agent:in-reply-to:content-transfer-encoding
         :content-disposition:mime-version:references:message-id:subject:cc
         :to:from:date:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OVA9GcIAMygLrpNCImWuPWpSm5WJrmlGiYht+CpNNPY=;
        b=cxMaDmRzw3XqVJVR0y0yDdfWoie/hYj03AKD3dtZ834oN8HG6e9y8kPGZWZP8xBn6e
         IoNV5jlUvjNqTOOLYmmMJ3PJmC5wb/gSSwgwdWzCH2i3USnL4d+ic2HWYx7cmzclPiia
         72gUu/k7trjtObCSaHCgs0ZRH70AxM3o0xXD3gYj4vF4hWctk4PdsByskGRArNScFJnd
         1S1W82GePu/H+Z6cAXDytcLpM7FOVDUW7ONiH9ak0XXJVwtigtx0LSYpgR0kMvPVxoDj
         ea3BITUPfJvf3g21nk+GgmgREnrAqnUh8h6B6PvaKD5U1uTzB+/DIUpws7haYmEcemBh
         524A==
X-Gm-Message-State: AO0yUKW4OYjamyhaUo6C5XsD30PLBrzDyvM9467a2kULxKPMryfd0Jpb
        d+exTApxs0w1eiWLRVji1fs=
X-Google-Smtp-Source: AK7set95hiBwtvAVDdJbc60Wdd/XuGONr+HXUIRRn8jAhJBIf2IObruUhX/5hjTXAKajJ9JRiVRsvg==
X-Received: by 2002:a05:622a:1751:b0:3bf:cac4:a3a1 with SMTP id l17-20020a05622a175100b003bfcac4a3a1mr8567162qtk.66.1677637332157;
        Tue, 28 Feb 2023 18:22:12 -0800 (PST)
Received: from maniforge ([2620:10d:c091:480::1:f172])
        by smtp.gmail.com with ESMTPSA id p16-20020a05620a15f000b0071d0f1d01easm7853290qkm.57.2023.02.28.18.22.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Feb 2023 18:22:11 -0800 (PST)
Date:   Tue, 28 Feb 2023 20:22:09 -0600
From:   David Vernet <void@manifault.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@kernel.org>,
        Dave Marchevsky <davemarchevsky@meta.com>,
        Tejun Heo <tj@kernel.org>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Kernel Team <kernel-team@fb.com>
Subject: Re: [PATCH v3 bpf-next 5/5] selftests/bpf: Tweak cgroup kfunc test.
Message-ID: <Y/620WKXKpNIzHQL@maniforge>
References: <20230228040121.94253-1-alexei.starovoitov@gmail.com>
 <20230228040121.94253-6-alexei.starovoitov@gmail.com>
 <Y/405fRuemfgdC3l@maniforge>
 <CAADnVQLGweandRXT4dmk71f5MwpebMhmrdTfEkY=wG41AZ7ZAQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAADnVQLGweandRXT4dmk71f5MwpebMhmrdTfEkY=wG41AZ7ZAQ@mail.gmail.com>
User-Agent: Mutt/2.2.9 (2022-11-12)
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 28, 2023 at 04:29:18PM -0800, Alexei Starovoitov wrote:
> On Tue, Feb 28, 2023 at 9:07 AM David Vernet <void@manifault.com> wrote:
> > libbpf: prog 'on_lookup': failed to load: -13
> > libbpf: failed to load object 'cgrp_ls_recursion'
> > libbpf: failed to load BPF skeleton 'cgrp_ls_recursion': -13
> > test_recursion:FAIL:skel_open_and_load unexpected error: -13
> > #43/3    cgrp_local_storage/recursion:FAIL
> > #43      cgrp_local_storage:FAIL
> >
> > All error logs:
> > test_cgrp_local_storage:PASS:join_cgroup /cgrp_local_storage 0 nsec
> > libbpf: prog 'on_lookup': BPF program load failed: Permission denied
> > libbpf: prog 'on_lookup': -- BEGIN PROG LOAD LOG --
> > reg type unsupported for arg#0 function on_lookup#16
> > 0: R1=ctx(off=0,imm=0) R10=fp0
> > ; struct task_struct *task = bpf_get_current_task_btf();
> > 0: (85) call bpf_get_current_task_btf#158     ; R0_w=trusted_ptr_task_struct(off=0,imm=0)
> > 1: (bf) r6 = r0                       ; R0_w=trusted_ptr_task_struct(off=0,imm=0) R6_w=trusted_ptr_task_struct(off=0,imm=0)
> > ; bpf_cgrp_storage_delete(&map_a, task->cgroups->dfl_cgrp);
> > 2: (79) r1 = *(u64 *)(r6 +2296)       ; R1_w=rcu_ptr_or_null_css_set(off=0,imm=0) R6_w=trusted_ptr_task_struct(off=0,imm=0)
> > ; bpf_cgrp_storage_delete(&map_a, task->cgroups->dfl_cgrp);
> > 3: (79) r2 = *(u64 *)(r1 +120)
> > R1 invalid mem access 'rcu_ptr_or_null_'
> 
> This one was tricky :)
> Turned out btf_nested_type_is_trusted() was able to find
> 'cgroups' field in gcc compiled kernel and was failing on clang
> compiled kernel because patch 2 did:
> BTF_TYPE_SAFE_NESTED(struct task_struct) {
>         const cpumask_t *cpus_ptr;
>         struct css_set *cgroups;
> };
> instead of
> BTF_TYPE_SAFE_NESTED(struct task_struct) {
>         const cpumask_t *cpus_ptr;
>         struct css_set __rcu *cgroups;
> };
> The missing tag was causing a miscompare.

Ahh, sorry I missed that in review. Once your patch set lands I'll add a
very loud comment here so that it's not missed in the future.

> Something to keep in mind.
> This ugliness will go away once GCC supports btf tag.

Looking forward to that day.

Given that you'll apply that fix to [0] here's my stamp for this patch:

Acked-by: David Vernet <void@manifault.com>

[0]: https://lore.kernel.org/all/20230228040121.94253-3-alexei.starovoitov@gmail.com/

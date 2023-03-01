Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE59E6A6441
	for <lists+netdev@lfdr.de>; Wed,  1 Mar 2023 01:29:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229523AbjCAA3e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Feb 2023 19:29:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229574AbjCAA3c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Feb 2023 19:29:32 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFF532113;
        Tue, 28 Feb 2023 16:29:31 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id o15so44831089edr.13;
        Tue, 28 Feb 2023 16:29:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CetTXR0kWLsWLIe/6m03tqSuabDoWEZFPYLpg+xQO04=;
        b=h3FSozYRdm6SJ+Jx5w3bK4etFFEDtkKownEAT9eiBFB1+bZqsGexy3EUH6PWOlAiBJ
         hdrCKEll+irxjMA1gx/jhG9JDdCkhb+UDO6VscG9CUWYf2Xr7BMPza9HIhfp6XYqmQo7
         C+cS/4huhWtYcsOWYjmJDJ9H2yJh4Fxp3PEZIRv9GQTmvkaHpc0sUaKZ6Y/wTu+leZcS
         d6Zh7EjkdndiIPXaQ+8/9/a07+k8rLq77oi8ps+Ntr66SpCHMptmgbyPqADPEA1IETEA
         RrSZ/9lwEMKC37vwry2LT9BgALi69rfVIsvV3tz+Rraga8lHHNpAH79glABJpvVkvFWi
         XwiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CetTXR0kWLsWLIe/6m03tqSuabDoWEZFPYLpg+xQO04=;
        b=oF15MRolRcnHrDCOo+Lwq684Cn7XhzY+1VOVhIZ9ExPH+iIRPxsQo1BTCX0h1NBp5m
         g8ohodftMVG/krYxiIUGG0c3Tn8eZOQAl6j1/x0MPTPbjG0DG1scnTHIvH8wmI0Qk4oZ
         7oeR0gJGLLHF6VhzgRZVl9861ItCeEafac2EDhVMbP+CNRW+0pCSUyHbytY0AOC43Xrl
         yIgIftjIaijYUYBiCgptCFzvcAp3jiwcgrKVtA3aSasV0gddXTggQ7AgAPuH0AgYdpl/
         eWMXvoWswUeVc9xI2ZvXUFe+a5IKgmtEx5AOMGJRZ0/eAIdKI0SD4GMKy8YCPfNMwiur
         4c9w==
X-Gm-Message-State: AO0yUKUCgrz+YwGpcsv3OfzEcfsyQuvp8+1gPGpHJIc4E8PVZEJDFrR5
        eN2FonaxVEKuELNgd+yn64B07aKDVowqpVOrX2Q=
X-Google-Smtp-Source: AK7set/bMRMUr/DdcVNwGcy7IEP2ZhW80DXmxvMmdK2OOinCA2AdcaI8ZbZUfvjN5S9GmhkAnmss4oRHLToixhG2FSI=
X-Received: by 2002:a17:907:d30d:b0:8f3:9ee9:f1e2 with SMTP id
 vg13-20020a170907d30d00b008f39ee9f1e2mr3962960ejc.5.1677630570086; Tue, 28
 Feb 2023 16:29:30 -0800 (PST)
MIME-Version: 1.0
References: <20230228040121.94253-1-alexei.starovoitov@gmail.com>
 <20230228040121.94253-6-alexei.starovoitov@gmail.com> <Y/405fRuemfgdC3l@maniforge>
In-Reply-To: <Y/405fRuemfgdC3l@maniforge>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 28 Feb 2023 16:29:18 -0800
Message-ID: <CAADnVQLGweandRXT4dmk71f5MwpebMhmrdTfEkY=wG41AZ7ZAQ@mail.gmail.com>
Subject: Re: [PATCH v3 bpf-next 5/5] selftests/bpf: Tweak cgroup kfunc test.
To:     David Vernet <void@manifault.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@kernel.org>,
        Dave Marchevsky <davemarchevsky@meta.com>,
        Tejun Heo <tj@kernel.org>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 28, 2023 at 9:07=E2=80=AFAM David Vernet <void@manifault.com> w=
rote:
> libbpf: prog 'on_lookup': failed to load: -13
> libbpf: failed to load object 'cgrp_ls_recursion'
> libbpf: failed to load BPF skeleton 'cgrp_ls_recursion': -13
> test_recursion:FAIL:skel_open_and_load unexpected error: -13
> #43/3    cgrp_local_storage/recursion:FAIL
> #43      cgrp_local_storage:FAIL
>
> All error logs:
> test_cgrp_local_storage:PASS:join_cgroup /cgrp_local_storage 0 nsec
> libbpf: prog 'on_lookup': BPF program load failed: Permission denied
> libbpf: prog 'on_lookup': -- BEGIN PROG LOAD LOG --
> reg type unsupported for arg#0 function on_lookup#16
> 0: R1=3Dctx(off=3D0,imm=3D0) R10=3Dfp0
> ; struct task_struct *task =3D bpf_get_current_task_btf();
> 0: (85) call bpf_get_current_task_btf#158     ; R0_w=3Dtrusted_ptr_task_s=
truct(off=3D0,imm=3D0)
> 1: (bf) r6 =3D r0                       ; R0_w=3Dtrusted_ptr_task_struct(=
off=3D0,imm=3D0) R6_w=3Dtrusted_ptr_task_struct(off=3D0,imm=3D0)
> ; bpf_cgrp_storage_delete(&map_a, task->cgroups->dfl_cgrp);
> 2: (79) r1 =3D *(u64 *)(r6 +2296)       ; R1_w=3Drcu_ptr_or_null_css_set(=
off=3D0,imm=3D0) R6_w=3Dtrusted_ptr_task_struct(off=3D0,imm=3D0)
> ; bpf_cgrp_storage_delete(&map_a, task->cgroups->dfl_cgrp);
> 3: (79) r2 =3D *(u64 *)(r1 +120)
> R1 invalid mem access 'rcu_ptr_or_null_'

This one was tricky :)
Turned out btf_nested_type_is_trusted() was able to find
'cgroups' field in gcc compiled kernel and was failing on clang
compiled kernel because patch 2 did:
BTF_TYPE_SAFE_NESTED(struct task_struct) {
        const cpumask_t *cpus_ptr;
        struct css_set *cgroups;
};
instead of
BTF_TYPE_SAFE_NESTED(struct task_struct) {
        const cpumask_t *cpus_ptr;
        struct css_set __rcu *cgroups;
};
The missing tag was causing a miscompare.
Something to keep in mind.
This ugliness will go away once GCC supports btf tag.

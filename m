Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B264D531F31
	for <lists+netdev@lfdr.de>; Tue, 24 May 2022 01:24:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230149AbiEWXYM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 May 2022 19:24:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbiEWXYL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 May 2022 19:24:11 -0400
Received: from mail-ua1-x936.google.com (mail-ua1-x936.google.com [IPv6:2607:f8b0:4864:20::936])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDAFE6C56A;
        Mon, 23 May 2022 16:24:10 -0700 (PDT)
Received: by mail-ua1-x936.google.com with SMTP id n24so5721058uap.13;
        Mon, 23 May 2022 16:24:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yT1hxcWi1Sr+ZWPJBD/mIwsWhjK/m0OllQ7OYXnw3JU=;
        b=oAsNnTC+djdceYMmFJp2wJ3kwIXusR1avJuMq4TPgjaRHhWTTmJm39ePhJsyuOLDZr
         Q/Pg8l3aho+grpHygCDUf4nnUxqWHtPGYGyM41N4cRAXeoHoZ2K1NUUIA/+63xRfjDVm
         iEFUo1a2QH3Y7LrABjjQzItIj0EwJpApVCurFgJiU8DFLbcg3bo0SFm0L3D+b3TbspZL
         C2f8/yJHvgpjnv6awk0f6CD1ffqKixAcTtO9YaXpA/UWJNlXf/S4jhT8EcGr2m9s9iTa
         /kgOHIKYoW6c+meFnEP1ounklySVfsRq4fKPm4ijZr4l8ZAv8CQHKog5A0Wb4j6u041i
         EE2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yT1hxcWi1Sr+ZWPJBD/mIwsWhjK/m0OllQ7OYXnw3JU=;
        b=2yNds9HepoyhILDwddpjxhhx7xKtUH/+aTX/PeFjbZ0jIDscwcl/5rayzNyQaOvyuY
         za1SWTbdoL2qwSnWG48YRCqFY2h6zk4P2L4XABRTOkzlCz7nl0o1D6dzxnoheOZtO+TS
         ctHPgt7jXQJI1LoBp/XKOE1uEcZsy5gSKw0W7MFjIzHaoH2uFPQO6b/bbzermMtI48ZD
         1/z+GSdrdsanLJ8f1o9HrRQAwF2rYKKvOLNx4bpa+m5s8KkGbxyYXb9/rp7ot7lD1SzX
         +HrXHugTvdFR67St+w2ayKJMoosagxjZiD7HMYsBXvN7KkoM2UJ1s80R5RB1xydJO+qi
         1yyw==
X-Gm-Message-State: AOAM530hGezY1C6tXjR2bLHkSdqgtVWUO7X/VTviHP9ttpCN1k+KSs+q
        qYl0/kRc+a3H1biSTPhs8BdmVdUdSXccJuAAI8SQjpndkfg=
X-Google-Smtp-Source: ABdhPJyBzCisZTLabB3yMVKVX/FrORrDMO8o3zoiRNeXbk/5qwb/bwhyamkLxSkmKmX8ngQmnV1tfAzayj4a7LXiEE0=
X-Received: by 2002:ab0:1343:0:b0:362:9e6c:74f5 with SMTP id
 h3-20020ab01343000000b003629e6c74f5mr7945768uae.15.1653348249855; Mon, 23 May
 2022 16:24:09 -0700 (PDT)
MIME-Version: 1.0
References: <20220518225531.558008-1-sdf@google.com> <20220518225531.558008-6-sdf@google.com>
In-Reply-To: <20220518225531.558008-6-sdf@google.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 23 May 2022 16:23:59 -0700
Message-ID: <CAEf4BzYxHsB3D-HT7H1zZsSDEjz_cU7FpfgFnVVzbe5qA4=dYg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v7 05/11] bpf: implement BPF_PROG_QUERY for BPF_LSM_CGROUP
To:     Stanislav Fomichev <sdf@google.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 18, 2022 at 3:55 PM Stanislav Fomichev <sdf@google.com> wrote:
>
> We have two options:
> 1. Treat all BPF_LSM_CGROUP the same, regardless of attach_btf_id
> 2. Treat BPF_LSM_CGROUP+attach_btf_id as a separate hook point
>
> I was doing (2) in the original patch, but switching to (1) here:
>
> * bpf_prog_query returns all attached BPF_LSM_CGROUP programs
> regardless of attach_btf_id
> * attach_btf_id is exported via bpf_prog_info
>
> Signed-off-by: Stanislav Fomichev <sdf@google.com>
> ---
>  include/uapi/linux/bpf.h |   5 ++
>  kernel/bpf/cgroup.c      | 103 +++++++++++++++++++++++++++------------
>  kernel/bpf/syscall.c     |   4 +-
>  3 files changed, 81 insertions(+), 31 deletions(-)
>
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index b9d2d6de63a7..432fc5f49567 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -1432,6 +1432,7 @@ union bpf_attr {
>                 __u32           attach_flags;
>                 __aligned_u64   prog_ids;
>                 __u32           prog_cnt;
> +               __aligned_u64   prog_attach_flags; /* output: per-program attach_flags */
>         } query;
>
>         struct { /* anonymous struct used by BPF_RAW_TRACEPOINT_OPEN command */
> @@ -5911,6 +5912,10 @@ struct bpf_prog_info {
>         __u64 run_cnt;
>         __u64 recursion_misses;
>         __u32 verified_insns;
> +       /* BTF ID of the function to attach to within BTF object identified
> +        * by btf_id.
> +        */
> +       __u32 attach_btf_func_id;

it's called attach_btf_id for PROG_LOAD command, keep it consistently
named (and a bit more generic)?

>  } __attribute__((aligned(8)));
>
>  struct bpf_map_info {

[...]

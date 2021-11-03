Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92C52443A53
	for <lists+netdev@lfdr.de>; Wed,  3 Nov 2021 01:13:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232357AbhKCAPc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Nov 2021 20:15:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233226AbhKCAPY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Nov 2021 20:15:24 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C07BC061714;
        Tue,  2 Nov 2021 17:12:49 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id b4so791423pgh.10;
        Tue, 02 Nov 2021 17:12:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=sVponJRFQk6xcvhX2MIVmWhLebQPmXI4+qFJ5f+Bhmg=;
        b=PgYcbMUvhevtKd+t1TTrND9SDCMrv8fIFo1H2XWkFbhXQnPJCZ+OY43VKfXsOvcx82
         kN0qwQHGR6C0Zx6gk4blvMi8IhaHOqcV4/FYgaaMRHDZftuL3aaIzIbw73wfvkIdv9ex
         nGt0Pi+0uEKR0/wmYspxR+Y+GyWzUaVNsQPgmPBEYW/ZS7HRBPW9G7Nge+M0f24AcY43
         IZubGm7HB7Vd+iy13n9eOVbsk8wxT0nArxyrNCUKpG2hVL3Jot/QI1HZvNySyA5YD3QT
         Jshf1yx+LhDVhxbBRqV3d8Exg4bawEJKMIMnEKkWW9NVpLJpefIXVvEkPye/+oBhJ1DZ
         2biw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=sVponJRFQk6xcvhX2MIVmWhLebQPmXI4+qFJ5f+Bhmg=;
        b=Pf6o/4jPtsGrLBKCnpBtbLdLKKdWPBdVRuHgmfVIyJI2aIfDSHOaZnmIW9ZSFx95xW
         5JMoSerHoZiDbtc/tgWKdhMyxexkFbN/P3wFJUmoCokEgQj2alFOm7gbCZFn5/0Hek9c
         lt4vqHG5ESNpdKmgxfHVkeTPe5ZlYDv+QJER9AVFm0EcBQusoePzCVDCIvqngWL6+LC4
         1yq+nXGoCWggXitntopaTZGjEaDcUvphzV3svP5gwzzMKE08H1amWsZ62hWigNya1VrX
         Wq8gsKp3n9S4Ax7+1U4ZcbuCenUWPkIueCCafNuydCJTonG9Sx1rb3Wz/COe5ILnUVkY
         KsZQ==
X-Gm-Message-State: AOAM530X9ArHGA4b4aEt7Lg4Dymae+8R9G7cgrb5o8YQscnlcQUIVS42
        prLjZWDEyWY2M9R8zvlMPZA=
X-Google-Smtp-Source: ABdhPJweXm1x9FcIlmiWgH7VbqI6S7ngxwuPu04X4F4/FqlpFWYg1CDxzy10sDN2pniI43Fcui4EIg==
X-Received: by 2002:aa7:9208:0:b0:44d:3044:baf0 with SMTP id 8-20020aa79208000000b0044d3044baf0mr39862209pfo.73.1635898368541;
        Tue, 02 Nov 2021 17:12:48 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:9df1])
        by smtp.gmail.com with ESMTPSA id t4sm295995pfj.13.2021.11.02.17.12.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Nov 2021 17:12:48 -0700 (PDT)
Date:   Tue, 2 Nov 2021 17:12:45 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Joe Burton <jevburton.kernel@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Petar Penkov <ppenkov@google.com>,
        Stanislav Fomichev <sdf@google.com>,
        Joe Burton <jevburton@google.com>
Subject: Re: [RFC PATCH v3 0/3] Introduce BPF map tracing capability
Message-ID: <20211103001245.muyte7exph23tmco@ast-mbp.dhcp.thefacebook.com>
References: <20211102021432.2807760-1-jevburton.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211102021432.2807760-1-jevburton.kernel@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 02, 2021 at 02:14:29AM +0000, Joe Burton wrote:
> From: Joe Burton <jevburton@google.com>
> 
> This is the third version of a patch series implementing map tracing.
> 
> Map tracing enables executing BPF programs upon BPF map updates. This
> might be useful to perform upgrades of stateful programs; e.g., tracing
> programs can propagate changes to maps that occur during an upgrade
> operation.
> 
> This version uses trampoline hooks to provide the capability.
> fentry/fexit/fmod_ret programs can attach to two new functions:
>         int bpf_map_trace_update_elem(struct bpf_map* map, void* key,
>                 void* val, u32 flags);
>         int bpf_map_trace_delete_elem(struct bpf_map* map, void* key);
> 
> These hooks work as intended for the following map types:
>         BPF_MAP_TYPE_ARRAY
>         BPF_MAP_TYPE_PERCPU_ARRAY
>         BPF_MAP_TYPE_HASH
>         BPF_MAP_TYPE_PERCPU_HASH
>         BPF_MAP_TYPE_LRU_HASH
>         BPF_MAP_TYPE_LRU_PERCPU_HASH
> 
> The only guarantee about the semantics of these hooks is that they execute
> before the operation takes place. We cannot call them with locks held
> because the hooked program might try to acquire the same locks. Thus they
> may be invoked in situations where the traced map is not ultimately
> updated.
> 
> The original proposal suggested exposing a function for each
> (map type) x (access type). The problem I encountered is that e.g.
> percpu hashtables use a custom function for some access types
> (htab_percpu_map_update_elem) but a common function for others
> (htab_map_delete_elem). Thus a userspace application would have to
> maintain a unique list of functions to attach to for each map type;
> moreover, this list could change across kernel versions. Map tracing is
> easier to use with fewer functions, at the cost of tracing programs
> being triggered more times.

Good point about htab_percpu.
The patches look good to me.
Few minor bits:
- pls don't use #pragma once.
  There was a discussion not too long ago about it and the conclusion
  was that let's not use it.
  It slipped into few selftest/bpf, but let's not introduce more users.
- noinline is not needed in prototype.
- bpf_probe_read is deprecated. Pls use bpf_probe_read_kernel.

and thanks for detailed patch 3.

> To prevent the compiler from optimizing out the calls to my tracing
> functions, I use the asm("") trick described in gcc's
> __attribute__((noinline)) documentation. Experimentally, this trick
> works with clang as well.

I think noinline is enough. I don't think you need that asm in there.

In parallel let's figure out how to do:
SEC("fentry/bpf_map_trace_update_elem")
int BPF_PROG(copy_on_write__update,
             struct bpf_map *map,
             struct allow_reads_key__old *key,
             void *value, u64 map_flags)

It kinda sucks that bpf_probe_read_kernel is necessary to read key/values.
It would be much nicer to be able to specify the exact struct for the key and
access it directly.
The verifier does this already for map iterator.
It's 'void *' on the kernel side while iterator prog can cast this pointer
to specific 'struct key *' and access it directly.
See bpf_iter_reg->ctx_arg_info and btf_ctx_access().

For fentry into bpf_map_trace_update_elem it's a bit more challenging,
since it will be called for all maps and there is no way to statically
check that specific_map->key_size is within prog->aux->max_rdonly_access.

May be we can do a dynamic cast helper (simlar to those that cast sockets)
that will check for key_size at run-time?
Another alternative is to allow 'void *' -> PTR_TO_BTF_ID conversion
and let inlined probe_read do the job.

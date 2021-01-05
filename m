Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 144382EB46A
	for <lists+netdev@lfdr.de>; Tue,  5 Jan 2021 21:50:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728915AbhAEUs6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 15:48:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727304AbhAEUs5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jan 2021 15:48:57 -0500
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 437A4C061793;
        Tue,  5 Jan 2021 12:48:17 -0800 (PST)
Received: by mail-pf1-x429.google.com with SMTP id d2so434440pfq.5;
        Tue, 05 Jan 2021 12:48:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mVVOLK7TKY0xTO7tS1oO2XqfQArJqlcn9xJJIW/nDFI=;
        b=DACEnE1e98TLwGq6kCGUdA1072X7VMlx371yiC3cm3uDYt084dJE2K9jI8NSnaeGKb
         z2Ja2fRJVerXvWAbPZ2ewZGhRm0CT2LrYfsXLPqEYnfbhUxS4eYaPnuNg2SXh7hdUiG9
         HaMisZFXViONKwecB5MedIicHqpii6N2duzn2mOU8qEieTlM2M1iK+5m++BbptctmhqN
         Who5usTiYqYKtIU4s4GmVBnnWgyLoFtOSFg1ZvsWZNDzlKzqN1WFc5QbHz11h9cP1ojW
         qOPS5xQJjB62hq/JoGLe2Cwaz+1u7pPXAhxVK+hZH48mhrJxIMkvSA/MwzCCG/gLRxUD
         Uxfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mVVOLK7TKY0xTO7tS1oO2XqfQArJqlcn9xJJIW/nDFI=;
        b=AUCZvj0EmV4EFfQReoBXqJOQOryPDKKCZdUh3aGN3MtGq2QffN1a3Wxk5dqE3n/omc
         Zy5sDe1aMCPMVaWgdxmqIiGgpCIjMxNlQR4OiktgQfASEPYO9NLltExuZmVebKyessUn
         0BVbsmtl7ZX9v1ZGd32AUJEdlpnknw7Ykq218eD2hDcMISpwbjv+d3GY27qssq0vAehl
         g7pnkwsCghkMd3+RZOXx2JrkRxIv+/ONApW1n0++8S/qyGrmpZxffggz2XWyiFQ8IHsA
         x/uEmGPRbwo1MhIDKM34p63aRKKvXlIVFxeRAf6KOGRR/77nc/bd6yL7sjN0MUMOc3R4
         cqww==
X-Gm-Message-State: AOAM530vD1k3H4rz99OHMhhEoy5UBOBRh7AsVhWlSdmG32JmoM9qioIy
        AwuObpXZBulA6V1z+W93W3+M3W9ia6ret1PLaCE=
X-Google-Smtp-Source: ABdhPJxtGbyC4YlazeCqDAfxlb1ldohpnJZIwsvhSB16ykEujK42H9uOFgLOouW6hVgvnbWU/E6IUYfYT08+MyePZ4Y=
X-Received: by 2002:a62:4d03:0:b029:1ac:6159:4572 with SMTP id
 a3-20020a624d030000b02901ac61594572mr816939pfb.10.1609879696812; Tue, 05 Jan
 2021 12:48:16 -0800 (PST)
MIME-Version: 1.0
References: <1609773991-10509-1-git-send-email-alan.maguire@oracle.com>
In-Reply-To: <1609773991-10509-1-git-send-email-alan.maguire@oracle.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Tue, 5 Jan 2021 12:48:06 -0800
Message-ID: <CAM_iQpW5ajiTTW7HBZiK+n_F1MhGyzzD+OWExns1YbejHRsy5A@mail.gmail.com>
Subject: Re: [RFC PATCH bpf-next] ksnoop: kernel argument/return value
 tracing/display using BTF
To:     Alan Maguire <alan.maguire@oracle.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, andrii@kernel.org,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, yhs@fb.com,
        John Fastabend <john.fastabend@gmail.com>, kpsingh@kernel.org,
        Nathan Chancellor <natechancellor@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        jean-philippe@linaro.org, bpf <bpf@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 4, 2021 at 7:29 AM Alan Maguire <alan.maguire@oracle.com> wrote:
>
> BPF Type Format (BTF) provides a description of kernel data structures
> and of the types kernel functions utilize as arguments and return values.
>
> A helper was recently added - bpf_snprintf_btf() - that uses that
> description to create a string representation of the data provided,
> using the BTF id of its type.  For example to create a string
> representation of a "struct sk_buff", the pointer to the skb
> is provided along with the type id of "struct sk_buff".
>
> Here that functionality is utilized to support tracing kernel
> function entry and return using k[ret]probes.  The "struct pt_regs"
> context can be used to derive arguments and return values, and
> when the user supplies a function name we
>
> - look it up in /proc/kallsyms to find its address/module
> - look it up in the BTF kernel data to get types of arguments
>   and return value
> - store a map representation of the trace information, keyed by
>   instruction pointer
> - on function entry/return we look up the map to retrieve the BTF
>   ids of the arguments/return values and can call bpf_snprintf_btf()
>   with these argument/return values along with the type ids to store
>   a string representation in the map.
> - this is then sent via perf event to userspace where it can be
>   displayed.
>
> ksnoop can be used to show function signatures; for example:

This is definitely quite useful!

Is it possible to integrate this with bpftrace? That would save people
from learning yet another tool. ;)

Thanks.

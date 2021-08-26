Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 083103F7F9A
	for <lists+netdev@lfdr.de>; Thu, 26 Aug 2021 03:01:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235342AbhHZBCG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 21:02:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234655AbhHZBCF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Aug 2021 21:02:05 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9999C061757;
        Wed, 25 Aug 2021 18:01:18 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id om1-20020a17090b3a8100b0017941c44ce4so5335845pjb.3;
        Wed, 25 Aug 2021 18:01:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=x5mp1VjUCkbnes2xyPEjiw2HZc5+2DQzif1w2BN7Ye0=;
        b=OBNgVHwcN7Z0uCYy+iVg9+Ea5EWbV1zbaBavQ+PR44M0n/Eecz6LA2PexDn6ZPmIJQ
         jI7oHP2dm9psRfI75JRT0eYCSvkFJmy8MSYfZuAisMzos8dzY7VwmvP9s5w5IF/lrAoY
         xTEvX705foD6o+IjF0hZ/GtGHOfal2qdMj4KyfdnxgeF4PYyaP11FoDu+NXku2+/JkdR
         vTvEQE1X03VrExHY2UGd25gRj1wK1+0kexobN7ZmkoLMxU47hDsOOeRJjUEHms5jscYa
         L7AN1U9F/uvx8IJjJx48DxCtpMxA9gGKc0mFx/Geh7QHJem92iqlw8CfGnIjii7w0WZk
         jeCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=x5mp1VjUCkbnes2xyPEjiw2HZc5+2DQzif1w2BN7Ye0=;
        b=D74x2ArdE+uhDHGnDwwzvjOCrMdkmBXBPHqHUGYYRE3mFRyXLmDpabAvIO+1w2Qikm
         RPe0/6jVAyR0clGkzV2uNmx0qLzRpiiDBRsUVv9jqRzb7p3H16qkXasy/jWhcW6/w0Ta
         Q1r4lf27yClcoSMTLvLP+4FEyjsDJqEQzo2of2Wfx+60rKapuzyKQ187N6x/dazFgP9o
         Yigzwqx2EoDOUp1T3gI3l2NDgCb9EQtMGEDDq2oNE5EK37jA9wGvmK+hRloCnoDHDRMi
         +b9dXnG27ybK+aDOULN2Q0N19ZFyNWobCl7VXvRSDX0wor+qrIw3tr7ZyCwxlzJSMRHu
         Nsxw==
X-Gm-Message-State: AOAM533A/D3RRb9TVRA+BBp3La6lGOFqar9lYc3pyoDwLdFhqTuTV3D8
        UV5I2n6ofqebTSy/6uKIKs7Qd+nBLFuHluvZ0wE=
X-Google-Smtp-Source: ABdhPJzsKunXcLhpw2bOxAf2aklpZ0Je4JdcOp+kWYbtnW8IF2Lwqw6d+1NBUkCCmRNT67qkEwC2D4iNrR0P1Z4noPc=
X-Received: by 2002:a17:90a:6ac2:: with SMTP id b2mr1213682pjm.36.1629939678250;
 Wed, 25 Aug 2021 18:01:18 -0700 (PDT)
MIME-Version: 1.0
References: <20210825195823.381016-1-davemarchevsky@fb.com> <20210825195823.381016-4-davemarchevsky@fb.com>
In-Reply-To: <20210825195823.381016-4-davemarchevsky@fb.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 25 Aug 2021 18:01:07 -0700
Message-ID: <CAADnVQJ+SRO-PZHYb9ef_RV3Yw_FOuOL0V+Q6A3Z_NYOn-Ezzw@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 3/6] libbpf: Modify bpf_printk to choose
 helper based on arg count
To:     Dave Marchevsky <davemarchevsky@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Yonghong Song <yhs@fb.com>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 25, 2021 at 12:58 PM Dave Marchevsky <davemarchevsky@fb.com> wrote:
>
> Instead of being a thin wrapper which calls into bpf_trace_printk,
> libbpf's bpf_printk convenience macro now chooses between
> bpf_trace_printk and bpf_trace_vprintk. If the arg count (excluding
> format string) is >3, use bpf_trace_vprintk, otherwise use the older
> helper.
>
> The motivation behind this added complexity - instead of migrating
> entirely to bpf_trace_vprintk - is to maintain good developer experience
> for users compiling against new libbpf but running on older kernels.
> Users who are passing <=3 args to bpf_printk will see no change in their
> bytecode.
>
> __bpf_vprintk functions similarly to BPF_SEQ_PRINTF and BPF_SNPRINTF
> macros elsewhere in the file - it allows use of bpf_trace_vprintk
> without manual conversion of varargs to u64 array. Previous
> implementation of bpf_printk macro is moved to __bpf_printk for use by
> the new implementation.
>
> This does change behavior of bpf_printk calls with >3 args in the "new
> libbpf, old kernels" scenario. On my system, using a clang built from
> recent upstream sources (14.0.0 https://github.com/llvm/llvm-project.git
> 50b62731452cb83979bbf3c06e828d26a4698dca), attempting to use 4 args to
> __bpf_printk (old impl) results in a compile-time error:
>
>   progs/trace_printk.c:21:21: error: too many args to 0x6cdf4b8: i64 = Constant<6>
>         trace_printk_ret = __bpf_printk("testing,testing %d %d %d %d\n",

and with a new bpf_printk it will compile to use bpf_trace_vprintk
and gets rejected during load on old kernels, right?
That will be the case for any clang.
It's fine.
Would be good to clarify the commit log.

> I was able to replicate this behavior with an older clang as well. When
> the format string has >3 format specifiers, there is no output to the
> trace_pipe in either case.

I don't understand this paragraph. What are the cases?

> After this patch, using bpf_printk with 4 args would result in a
> trace_vprintk helper call being emitted and a load-time failure on older
> kernels.

right.

> +#define __bpf_printk(fmt, ...)                         \
> +({                                                     \
> +       char ____fmt[] = fmt;                           \

Andrii was suggesting to make it const while we're at it,
but that could be done in a follow up.

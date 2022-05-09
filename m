Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4BC0520731
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 23:55:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231352AbiEIV7M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 17:59:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231357AbiEIV7E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 17:59:04 -0400
Received: from mail-il1-x12a.google.com (mail-il1-x12a.google.com [IPv6:2607:f8b0:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E06D92BA993;
        Mon,  9 May 2022 14:51:48 -0700 (PDT)
Received: by mail-il1-x12a.google.com with SMTP id j12so7372364ila.12;
        Mon, 09 May 2022 14:51:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qAbAyNnTVTXeqWEXMmRt0c7msh1GrAv5pSTcXTdkH8s=;
        b=LSsD9XD0WuUtuN/UROa2maXyqPWwLc834LeZceCe439KfP6cBiXpHNNCwoxFnETh+D
         cLoTiMUMCBIVbRMC+OQe1RqG+rbSrHhLgkxUWDffXzXqhs4myqE9dLOgncdiMBorleyj
         domz3lgH+h8zLNDY8jjNUZo30eG9i4D94dyclBW3kG5P938KjyBd8L9S31COXDNophAd
         Z/n22YXWMy7CSJl1n7kPpF3B3uKuOG5iygfRFP949pF6mNTGbD3OfIaL+mKFXrwBUvjf
         t2rxf86qNuU3QKMfLjVFtwwial4JEmy9ailvVv0447pp1DvptPWrTWyWDZqaDn6cP/u6
         rzAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qAbAyNnTVTXeqWEXMmRt0c7msh1GrAv5pSTcXTdkH8s=;
        b=TmPn3X8uIfMX8skyD8jMViu95fAJv9sdZyLawIbwkvMrHaMmJ8aKgkIHv5Jvr0w8EF
         OgQcTF1HEOuUHaMqiWzDEg7r5ERC0IsH5G3hyWaBV7A40DbafsGMGj1qmjhMABrDfQmJ
         lCLybpR1TJI6idM8ny6XlTRNg6k9UEQtoMiAGbJ7Y22toO5wTADXWocP0Wi9BY5Yv9zJ
         7fPyP2CMe88BBn5rh44b9wAvt4TcsvkUKY0B0rATVFyAOm82Vc5ydJlp1xXGqqtRc0AV
         eeAfJv6UNwHCUwyE0s27qdx14X4Bdo0GxjHl4INtE1AM37cUIgoy95JxYZ1YwMRvNvF+
         agBw==
X-Gm-Message-State: AOAM5321wAAWxM8X9qtddYOfj/vDOMB248jOfyCPgRtDHMVQaR4WRQXV
        QCWt0b+I6n11u1rE9oV1iuBPYtZBZq5ZPj064dU=
X-Google-Smtp-Source: ABdhPJwEbtNFgzl521yz+AFmYSzz+Mi0qoQ3BIaiOYPTbVJho5nzzIN7FRBeAqfVP2iIoM09D8NEshz42niUbBaGPHc=
X-Received: by 2002:a05:6e02:1b82:b0:2cf:199f:3b4b with SMTP id
 h2-20020a056e021b8200b002cf199f3b4bmr7673559ili.71.1652133108217; Mon, 09 May
 2022 14:51:48 -0700 (PDT)
MIME-Version: 1.0
References: <20220429211540.715151-1-sdf@google.com> <20220429211540.715151-4-sdf@google.com>
In-Reply-To: <20220429211540.715151-4-sdf@google.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 9 May 2022 14:51:37 -0700
Message-ID: <CAEf4BzZ_c62i9_QX+6PFBZynAKkEH-2VX-7y_hYQhrP0Ks-ftQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v6 03/10] bpf: per-cgroup lsm flavor
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

On Fri, Apr 29, 2022 at 2:15 PM Stanislav Fomichev <sdf@google.com> wrote:
>
> Allow attaching to lsm hooks in the cgroup context.
>
> Attaching to per-cgroup LSM works exactly like attaching
> to other per-cgroup hooks. New BPF_LSM_CGROUP is added
> to trigger new mode; the actual lsm hook we attach to is
> signaled via existing attach_btf_id.
>
> For the hooks that have 'struct socket' or 'struct sock' as its first
> argument, we use the cgroup associated with that socket. For the rest,
> we use 'current' cgroup (this is all on default hierarchy == v2 only).
> Note that for some hooks that work on 'struct sock' we still
> take the cgroup from 'current' because some of them work on the socket
> that hasn't been properly initialized yet.
>
> Behind the scenes, we allocate a shim program that is attached
> to the trampoline and runs cgroup effective BPF programs array.
> This shim has some rudimentary ref counting and can be shared
> between several programs attaching to the same per-cgroup lsm hook.
>
> Note that this patch bloats cgroup size because we add 211
> cgroup_bpf_attach_type(s) for simplicity sake. This will be
> addressed in the subsequent patch.
>
> Also note that we only add non-sleepable flavor for now. To enable
> sleepable use-cases, bpf_prog_run_array_cg has to grab trace rcu,
> shim programs have to be freed via trace rcu, cgroup_bpf.effective
> should be also trace-rcu-managed + maybe some other changes that
> I'm not aware of.
>
> Signed-off-by: Stanislav Fomichev <sdf@google.com>
> ---
>  arch/x86/net/bpf_jit_comp.c     |  22 ++--
>  include/linux/bpf-cgroup-defs.h |   6 ++
>  include/linux/bpf-cgroup.h      |   7 ++
>  include/linux/bpf.h             |  15 +++
>  include/linux/bpf_lsm.h         |  14 +++
>  include/uapi/linux/bpf.h        |   1 +
>  kernel/bpf/bpf_lsm.c            |  64 ++++++++++++
>  kernel/bpf/btf.c                |  11 ++
>  kernel/bpf/cgroup.c             | 179 +++++++++++++++++++++++++++++---
>  kernel/bpf/syscall.c            |  10 ++
>  kernel/bpf/trampoline.c         | 161 ++++++++++++++++++++++++++++
>  kernel/bpf/verifier.c           |  32 ++++++
>  tools/include/uapi/linux/bpf.h  |   1 +
>  13 files changed, 503 insertions(+), 20 deletions(-)
>

[...]

> @@ -3474,6 +3476,11 @@ static int bpf_prog_attach(const union bpf_attr *attr)
>         case BPF_PROG_TYPE_CGROUP_SOCKOPT:
>         case BPF_PROG_TYPE_CGROUP_SYSCTL:
>         case BPF_PROG_TYPE_SOCK_OPS:
> +       case BPF_PROG_TYPE_LSM:
> +               if (ptype == BPF_PROG_TYPE_LSM &&
> +                   prog->expected_attach_type != BPF_LSM_CGROUP)
> +                       return -EINVAL;
> +

Is it a hard requirement to support non-bpf_link attach for these BPF
trampoline-backed programs? Can we keep it bpf_link-only and use
LINK_CREATE for attachment? That way we won't need to extend query
command and instead add new field to bpf_link_info?

>                 ret = cgroup_bpf_prog_attach(attr, ptype, prog);
>                 break;
>         default:

[...]

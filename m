Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8E9E4629EC
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 02:43:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236836AbhK3Bq2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 20:46:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236822AbhK3Bq1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Nov 2021 20:46:27 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E2ABC061714;
        Mon, 29 Nov 2021 17:43:09 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id h24so14113488pjq.2;
        Mon, 29 Nov 2021 17:43:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=JY7fwQCwIaLfvZtlRwfTmDedzscAuvWuqTYb3KzttUg=;
        b=mH0iAA8d4E8HBrmhuCRlvw2GL8ByI1FrcQflgOVinjg69pqvwkhifJHFW9rJundWbd
         E6PlUHkS2sQViTk1As18ReK+Y5flLu7jUWfZRliBUF4wZV9s7m6tirR3rEuPWEtoDDb2
         HNSXwuchL/ZGoLNpKS6SFvxakonv3yIkfttMiiDpaBhGGPYsgWIR/m52UwYoqvcEy08l
         nIaNPF01Nn0vfRS6sD1DmUUA1OLcuQsZlaXppe5NrZnk4BWgr5xUi1KfBwlxLCG7nb/I
         DazJ8YVWT8YpJFsuegXr34AtTVjbcYaw0QYVgaC/28Dh3c/2jChM2lbWC7PTTQdFX/7O
         MLuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=JY7fwQCwIaLfvZtlRwfTmDedzscAuvWuqTYb3KzttUg=;
        b=bsP+4+LSodng8lfbm7U00sp+B9PhDmLbTrInA93ud4uHcpujAlfgxO9g81dr9JhKjC
         gVj4eyWBVvWAaSU9ezqw3b2ScanNkAXv+UhQk1rEy1eJHKAZqScsLV14znNfDLIcwTJx
         8usI0tgITKD4CVSORBxZoCAKpwMURkbaQSKKHe4ERF1U33AW97DbxqOweerAonTVPi1a
         yLFm1+pagfBeUwRrafnBH2hgKHJrFmkFLlmuO0NtxyZxfH1o5zoZxeO5KaDgGGxrl4xb
         n6m4z6HxFfyUhY0MQMTSv2dnDDwTn/lYos/kWiBCAwsY5GVT5KyHc2eLB4b8LQI51L5I
         wvYw==
X-Gm-Message-State: AOAM5335WLny58ERxgpB4bAHJ2MlCz/fWFMx855gG1QiaULztiMeoVoL
        hJdYwASDIDsk/xsrXbLM000jXMseHQpxK+Op97s=
X-Google-Smtp-Source: ABdhPJxQh1DY/xLlyMot6KckjYcWPrvNOctDL3HP93M8an6dWdCJ1ioZqcv63qE4ZB2jiDnn24AEUFIZ1oCU5ApBTM4=
X-Received: by 2002:a17:903:2306:b0:141:e52e:457d with SMTP id
 d6-20020a170903230600b00141e52e457dmr64272456plh.3.1638236589015; Mon, 29 Nov
 2021 17:43:09 -0800 (PST)
MIME-Version: 1.0
References: <20211123205607.452497-1-zenczykowski@gmail.com>
In-Reply-To: <20211123205607.452497-1-zenczykowski@gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Mon, 29 Nov 2021 17:42:57 -0800
Message-ID: <CAADnVQJG8_vHfHZJkN9MkZvK_70s8mQ2KyUVHWY6-tndLDfqdA@mail.gmail.com>
Subject: Re: [PATCH bpf-next] bpf: allow readonly direct path access for skfilter
To:     =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Cc:     =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Linux Network Development Mailing List 
        <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        BPF Mailing List <bpf@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 23, 2021 at 12:56 PM Maciej =C5=BBenczykowski
<zenczykowski@gmail.com> wrote:
>
> From: Maciej =C5=BBenczykowski <maze@google.com>
>
> skfilter bpf programs can read the packet directly via llvm.bpf.load.byte=
/
> /half/word which are 8/16/32-bit primitive bpf instructions and thus
> behave basically as well as DPA reads.  But there is no 64-bit equivalent=
,
> due to the support for the equivalent 64-bit bpf opcode never having been
> added (unclear why, there was a patch posted).
> DPA uses a slightly different mechanism, so doesn't suffer this limitatio=
n.
>
> Using 64-bit reads, 128-bit ipv6 address comparisons can be done in just
> 2 steps, instead of the 4 steps needed with llvm.bpf.word.

llvm.bpf.word is a pseudo instruction.
It's actually a function call for classic bpf.
See bpf_gen_ld_abs.
We used to have ugly special cases for them in JITs,
but then got rid of it.
Don't use them if performance is a requirement.

> This should hopefully allow simpler (less instructions, and possibly less
> logic and maybe even less jumps) programs.  Less jumps may also mean vast=
ly
> faster bpf verifier times (it can be exponential in the number of jumps..=
.).
>
> This can be particularly important when trying to do something like scan
> a netlink message for a pattern (2000 iteration loop) to decide whether
> a message should be dropped, or delivered to userspace (thus waking it up=
).
>
> I'm requiring CAP_NET_ADMIN because I'm not sure of the security
> implications...
>
> Tested: only build tested
> Signed-off-by: Maciej =C5=BBenczykowski <maze@google.com>
> ---
>  kernel/bpf/verifier.c | 5 +++++
>  1 file changed, 5 insertions(+)
>
> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> index 331b170d9fcc..0c2e25fb9844 100644
> --- a/kernel/bpf/verifier.c
> +++ b/kernel/bpf/verifier.c
> @@ -3258,6 +3258,11 @@ static bool may_access_direct_pkt_data(struct bpf_=
verifier_env *env,
>         enum bpf_prog_type prog_type =3D resolve_prog_type(env->prog);
>
>         switch (prog_type) {
> +       case BPF_PROG_TYPE_SOCKET_FILTER:
> +               if (meta || !capable(CAP_NET_ADMIN))
> +                       return false;

probably needs CAP_BPF too.

Other than that I think it's fine.

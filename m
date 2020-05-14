Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC7C01D4197
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 01:19:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727836AbgENXTy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 19:19:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726050AbgENXTy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 May 2020 19:19:54 -0400
Received: from mail-qk1-x742.google.com (mail-qk1-x742.google.com [IPv6:2607:f8b0:4864:20::742])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07D88C061A0C;
        Thu, 14 May 2020 16:19:53 -0700 (PDT)
Received: by mail-qk1-x742.google.com with SMTP id f13so748776qkh.2;
        Thu, 14 May 2020 16:19:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8+X7Apxv94V1GfeKZzYV0gOnbWmEHSzK15TbZj6TPF4=;
        b=fjM0wqhO6u/83U1vUYbBERXyLik2VApXTe52XFbwEMeFuXLwZlBPivDvOzF7xSi0h4
         /QODpopmbDI3sYLLdSMDYH5f8KS7XEQJXYiRR47AF5XpCXHD0SM8sLmZozJjFFBG4tRW
         BulligGkJFeZY8k/7w2YkjuRWsGAjFgFmQtsubSBZXU0AY6GRUPyEPhruA6bdJ7KtxX4
         FAecH/H3c5yZUwN2ZlCXWGhpmBfOi+vlrNUcf3KEeD/1xu2ovGV3kmuiJHdADuCw2stD
         xH/h9bJPXV7rHcBdDJSDOwEtHCu+vVU4iJnNgkFhTVBBtuJKT4EKpobno2jqHVdCA6Nf
         u+Bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8+X7Apxv94V1GfeKZzYV0gOnbWmEHSzK15TbZj6TPF4=;
        b=VVV6xXMugPWyXF/gr6qzhTV0y1JUuaB7hi57yqIqF2CAdUo7WZIwp20XVSUAtX1Ooh
         xMTCJ0YxIDNfvDHqR5TurdZufGqCRD9LrTzbWjfbY0G2MrEVIb9MITn5pt4Sk2BniKGR
         HJmKmTgIcYuh/kLa7O3jMHo333GCE55MBAgCj6ojUCl4DGO7M5OugB5TcoZKVlPe2MW3
         l7rah5GqjBG1vf94cMSLh0IjQecnc+4xpQ8PIKHYMkNgEQjCfGWJf7T9zMhzMmtofQvk
         XpvO5tjW7qVkZot9Ch9g+Yy3vX10OCJs4xr0OppYBPpCJ50DsgLfdSRBeyHZLWEssuEM
         5Gag==
X-Gm-Message-State: AOAM531YPBFRwPAN343GUPI4OwjvsfZyRVwSJCA9NLFzUX+1S9u9WdEn
        FA80rvGGQ5wx281sNHWOkk9W5KztUejacuU5HjA=
X-Google-Smtp-Source: ABdhPJyMdOaNRs0d+frAtU2jnbr9LMBOzHuX54q85pa1BgTCkO7PKmAlHr+zE9Pc2PfUNQaHm99hWF4u7NNOZWcy6O4=
X-Received: by 2002:ae9:efc1:: with SMTP id d184mr816474qkg.437.1589498392247;
 Thu, 14 May 2020 16:19:52 -0700 (PDT)
MIME-Version: 1.0
References: <20200513075849.20868-1-daniel@iogearbox.net>
In-Reply-To: <20200513075849.20868-1-daniel@iogearbox.net>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 14 May 2020 16:19:41 -0700
Message-ID: <CAEf4BzYfgXSOPmi6B23=rKgUge77g+tg=jJ9jwgZ48Co1nSViA@mail.gmail.com>
Subject: Re: [PATCH bpf-next] bpf, bpftool: Allow probing for CONFIG_HZ from
 kernel config
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Quentin Monnet <quentin@isovalent.com>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 13, 2020 at 1:00 AM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> In Cilium we've recently switched to make use of bpf_jiffies64() for
> parts of our tc and XDP datapath since bpf_ktime_get_ns() is more
> expensive and high-precision is not needed for our timeouts we have
> anyway. Our agent has a probe manager which picks up the json of
> bpftool's feature probe and we also use the macro output in our C
> programs e.g. to have workarounds when helpers are not available on
> older kernels.
>
> Extend the kernel config info dump to also include the kernel's
> CONFIG_HZ, and rework the probe_kernel_image_config() for allowing a
> macro dump such that CONFIG_HZ can be propagated to BPF C code as a
> simple define if available via config. Latter allows to have _compile-
> time_ resolution of jiffies <-> sec conversion in our code since all
> are propagated as known constants.
>
> Given we cannot generally assume availability of kconfig everywhere,
> we also have a kernel hz probe [0] as a fallback. Potentially, bpftool
> could have an integrated probe fallback as well, although to derive it,
> we might need to place it under 'bpftool feature probe full' or similar
> given it would slow down the probing process overall. Yet 'full' doesn't
> fit either for us since we don't want to pollute the kernel log with
> warning messages from bpf_probe_write_user() and bpf_trace_printk() on
> agent startup; I've left it out for the time being.
>
>   [0] https://github.com/cilium/cilium/blob/master/bpf/cilium-probe-kernel-hz.c
>
> Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
> Cc: Martin KaFai Lau <kafai@fb.com>
> ---

libbpf supports kconfig values, so don't have to even probe for that,
it will just appear as a constant global variable:

extern unsigned long CONFIG_HZ __kconfig;

But I assume you want this for iproute2 case, which doesn't support
this, right? We really should try to make iproute2 just use libbpf as
a loader with all the libbpf features available. I think all (at least
all major ones) features needed are already there in libbpf, iproute2
would just need to implement custom support for old-style map
definitions and maybe something else, not sure. I wonder if any of
iproute2/BPF users willing to spend some effort on this?

>  tools/bpf/bpftool/feature.c | 120 ++++++++++++++++++++----------------
>  1 file changed, 67 insertions(+), 53 deletions(-)
>

[...]

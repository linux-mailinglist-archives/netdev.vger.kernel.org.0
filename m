Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 831F448153C
	for <lists+netdev@lfdr.de>; Wed, 29 Dec 2021 17:46:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240888AbhL2QqO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Dec 2021 11:46:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234322AbhL2QqN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Dec 2021 11:46:13 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40CAFC061574;
        Wed, 29 Dec 2021 08:46:13 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id iy13so18946232pjb.5;
        Wed, 29 Dec 2021 08:46:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=m2VHGpOsSlqMAvp8eXPTyOqpWd6XOjYOHnMNBcpT7VE=;
        b=oKbLmkhWLxseBbzoAoTc/1plIjTZRWHEGAHqnj1kwtYvy3JElApZ+OAMUCnHRXzNRz
         lw9q1GLyJM7oroeJSRLDxD1FUPpGKGMPgKsk3MU7+xi07w2bKMUFdhIjVwaVEwlBmSeA
         UVdOTp+XxufSakob4eI7BFNvEYXoSouwV8+zK/r4s/zcWR6IDQzN0YDLJDinIM6G3uxQ
         oMs9mG/SCsMYe3LUCKsU68XgiKB99Plydq69kUz4z3HgeZWQal9Dc3boWCHOsu5XsBsn
         mAcH4sWzinqY7i8QPl284mab6nghjV7j+9oRJkzg6yALSOfDJDqanEbGav9tWQ5OOSxE
         dggA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=m2VHGpOsSlqMAvp8eXPTyOqpWd6XOjYOHnMNBcpT7VE=;
        b=qXA8hyG6RM/mxWwKOIQkiCvN4V3eQlBnJw+cZgArdAtDiKxo++DJN7gR0rntcHm+JP
         RCJcY0MHzun551LXzesF/Mm+WcSAOvqoPdtMukoIRDbfKKZnkgFAAlyIjuF3ySaQTU9i
         /1+n6ILZ1yWoyS2ODKEykmiT6ZwhHvQ8twRlRM6JJmxtAmCpqZ/x3F+I5ZlsfyACHS9E
         mfRCUfp4si56pksTfLGMVfYAW/Um3B3gj0MGEUL0SAf3BfTMS/2ESB1DmBQcfRLj3FhG
         URXUf7ZJik6BigiSLikKAmMALGu8S+TTCHFB1S2YcQBFEiNakSm31WIJCcHL/F2bF6Cj
         dOxQ==
X-Gm-Message-State: AOAM532/Y0MFjdJCP6ilXGCjQSTltjDeHcUaqRkYZMF8dtolhDV1Q6J5
        SyY499mCmUeJZjjNWgRDpFrk+DtldcJhEMeHrmE=
X-Google-Smtp-Source: ABdhPJweW9lxYzxvvOvJG1pq8rjphOJ/T0YrCCS9hDcP87ZqGhZs+grOrfogTU65rUakkFU/BBmS0S6Ied8nspKeTs4=
X-Received: by 2002:a17:902:860c:b0:149:1017:25f0 with SMTP id
 f12-20020a170902860c00b00149101725f0mr26992202plo.116.1640796372752; Wed, 29
 Dec 2021 08:46:12 -0800 (PST)
MIME-Version: 1.0
References: <20211229113256.299024-1-imagedong@tencent.com>
In-Reply-To: <20211229113256.299024-1-imagedong@tencent.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 29 Dec 2021 08:46:01 -0800
Message-ID: <CAADnVQLY2i+2YTj+Oi7+70e98sRC-t6rr536sc=3WYghpki+ug@mail.gmail.com>
Subject: Re: [PATCH net-next] net: bpf: add hook for close of tcp timewait sock
To:     menglong8.dong@gmail.com
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Menglong Dong <imagedong@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 29, 2021 at 3:33 AM <menglong8.dong@gmail.com> wrote:
>
> From: Menglong Dong <imagedong@tencent.com>
>
> The cgroup eBPF attach type 'CGROUP_SOCK_OPS' is able to monitor the
> state change of a tcp connect with 'BPF_SOCK_OPS_STATE_CB' ops.
>
> However, it can't trace the whole state change of a tcp connect. While
> a connect becomes 'TCP_TIME_WAIT' state, this sock will be release and
> a tw sock will be created. While tcp sock release, 'TCP_CLOSE' state
> change will be passed to eBPF program. Howeven, the real state of this
> connect is 'TCP_TIME_WAIT'.
>
> To make eBPF get the real state change of a tcp connect, add
> 'CGROUP_TWSK_CLOSE' cgroup attach type, which will be called when
> tw sock release and tcp connect become CLOSE.

The use case is not explained.
Why bpf tracing cannot be used to achieve the same?

Also there are no selftests.

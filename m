Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7656149D9D5
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 06:08:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233614AbiA0FIh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 00:08:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231201AbiA0FIg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 00:08:36 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 439A0C06161C;
        Wed, 26 Jan 2022 21:08:36 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id c3so1526210pls.5;
        Wed, 26 Jan 2022 21:08:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YwFBiJwCNR2Ej7oenh8eiccZ78vpn8xgNO2lAje6Aiw=;
        b=gGsznywtVegD8GK1UXhoZE+oLJZwTKV/nyRjdwL76E6WGjPLf4UM1NicsEbFD5gEyg
         FhqbHtfyUlDq8Y9XsvHo4z9OYFdNc/ZZ/vbgog9H+dHGvWR2R2/ILtrBv/AiMp53ssUH
         BSN4HcjOWO8lrhPYYScTFUdn32VBaslS7KHGYQyVTvIN3R/Y1z7yADtr/ElTyghjLNlu
         TIMU6UJki74ZTCta8ps+LBs8sCcVkIdg/r+V2IQdMdWz3wSvKgdtrpWmuLvb68KsWkE8
         zVZ2IMJlBRMO7wRGoGZM7m5Ok+XsM63mKFntFN2ymU9w7kv4e7IpMq+GOOnjmB65rcw0
         HA1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YwFBiJwCNR2Ej7oenh8eiccZ78vpn8xgNO2lAje6Aiw=;
        b=7XG3MSFikTeC9FQrL2GGISogXZRarCvvp0vyY0rkT1nsUQH3KJ8jDOYBVDoi6I3Z/b
         beaPX3FakCbYtWK0rnBLObtew+xvP8OsXka6IEmx3TTeCzngR8IYUwe6/BjYO8a0FHir
         bh5QXnMGvFdQ1kIk+FXZwosQLEn9gfqQEbMEa/F/hFgOPUKZiMYqGPtgVBKA8nEZUM9v
         cckUbn+wAw3K5W8z6hjP9+VvN2f4pGeSX4Jx59Ak2QMyEhxvpWqTb0JGBSDn/OOnaD3W
         4/0pTA+d+8wyNFE9DPn2Az8uSMZpeb7D0ZIRFeLpcb8+KpTrxHXGN+2uNIEctwbA9+E3
         v6+g==
X-Gm-Message-State: AOAM531EbDHXzjklQw6CiCC+yuKDnA46gN1mtMeavoNY3TwE4jOTLnAG
        sLZrPD5t7a4N1LbJtMwWW9wF4+YaVjxBxjozF7F8YkaJLds=
X-Google-Smtp-Source: ABdhPJwv6+BA2S3Eve7EWuG+FOX430GePS/AzhqEpIUvzionmqPAOA3oyJ6tjd85IJAxQmkl799KzaVPCyai1XH5bd4=
X-Received: by 2002:a17:90a:d203:: with SMTP id o3mr12237180pju.122.1643260115628;
 Wed, 26 Jan 2022 21:08:35 -0800 (PST)
MIME-Version: 1.0
References: <94e36de3cc2b579e45f95c189a6f5378bf1480ac.1643156174.git.asml.silence@gmail.com>
 <20220126203055.3xre2m276g2q2tkx@kafai-mbp.dhcp.thefacebook.com> <fbc8acbe-4c12-9c68-0418-51e97457d30b@gmail.com>
In-Reply-To: <fbc8acbe-4c12-9c68-0418-51e97457d30b@gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 26 Jan 2022 21:08:24 -0800
Message-ID: <CAADnVQ+p0B-2_b8hYHEW4UGJ7-T0RMfnZ8cZ4NgpvjMiTo6YKA@mail.gmail.com>
Subject: Re: [PATCH for-next v4] cgroup/bpf: fast path skb BPF filtering
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     Martin KaFai Lau <kafai@fb.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Song Liu <songliubraving@fb.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Stanislav Fomichev <sdf@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 26, 2022 at 1:29 PM Pavel Begunkov <asml.silence@gmail.com> wrote:
>
> On 1/26/22 20:30, Martin KaFai Lau wrote:
> > On Wed, Jan 26, 2022 at 12:22:13AM +0000, Pavel Begunkov wrote:
> >>   #define BPF_CGROUP_RUN_PROG_INET_INGRESS(sk, skb)                        \
> >>   ({                                                                       \
> >>      int __ret = 0;                                                        \
> >> -    if (cgroup_bpf_enabled(CGROUP_INET_INGRESS))                  \
> >> +    if (cgroup_bpf_enabled(CGROUP_INET_INGRESS) && sk &&                  \
> >  From reading sk_filter_trim_cap() where this will be called, sk cannot be NULL.
> > If yes, the new sk test is not needed.
>
> Well, there is no sane way to verify how it's used considering
>
> EXPORT_SYMBOL(__cgroup_bpf_run_filter_skb);

BPF_CGROUP_RUN_PROG_INET_INGRESS() is used in one place.
Are you folks saying that you want to remove !sk check
from __cgroup_bpf_run_filter_skb()?
Seems like micro optimization, but sure why not.

EXPORT_SYMBOL() is there because of "ipv6 as a module" mess.
So it's not a concern.

Pls tag the subj of the patch with [PATCH bpf-next]
instead of "for-next".

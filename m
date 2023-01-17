Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20C3E66E4C2
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 18:22:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234676AbjAQRWa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 12:22:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230359AbjAQRWH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 12:22:07 -0500
Received: from mail-yw1-x1136.google.com (mail-yw1-x1136.google.com [IPv6:2607:f8b0:4864:20::1136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CF9F49946;
        Tue, 17 Jan 2023 09:21:08 -0800 (PST)
Received: by mail-yw1-x1136.google.com with SMTP id 00721157ae682-4e4a6af2d99so112678057b3.4;
        Tue, 17 Jan 2023 09:21:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Flsmcs2Du9rlPXG9U0n6tZMvCNhqtwK4sBDPcU3OruQ=;
        b=YKk9Myn2HSL/LLcjfxOO1yNmdU1L0mG4Vw2XqVMSvVBNm3QGbO2CSsN9oDCnwAbCRB
         3secCt2Zo33PX4h4Wv4o1ygH9ucGPr/ssEjqOBeikREC/gY+kL4HEPjexrapZmrUxPro
         YzZ3veC3L1A57T6vlDLEjaGs3U2rJaihIWrxLFj2sNWT4bqYP8fMoEZewz96HYQEIS57
         0d+hLKh9qlwryE+1SaMoLoxmAoxCl/Bt1z/kRskTnnQhHLQxm7ViQzSIjhtIGUL85Ks9
         kfd9NiiysUJkZ0i9Nce22farhEMP7YSj1QjHX2fTZ6K6PlU9s0i1P5UYF5Qp8ez2ZffZ
         UgUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Flsmcs2Du9rlPXG9U0n6tZMvCNhqtwK4sBDPcU3OruQ=;
        b=l6OUslBfwOyWa1yiq2Wq7k61Stem66yC4DXABkOdc2XzcFf0gnYeDR/F/8+8wwZUHm
         G7UgVphfikHPIhS+xrqcpU/yPcG4MZiB+6IvpMQWDhwqeBVASY3Tmr82dObYMamu6/go
         d1c+x9GMcKJTNUiBjDQcFL50uVa2y3ys2dH8uSu6b2m6WEcEmFfnVggGLmm83iwlQ4rf
         xPzBPq+0mrGtF9Hx03DOrgz5uumReH9cUIPFKN+i192bPd4cTUbU+SQtV+fgo1OPYKBy
         InO9azcHPvScK0QWjeR4BXmdfw/9+NpqYth3YhcBwv/n16tjUwMs3GQHvDuSm4pwoXLN
         GEdw==
X-Gm-Message-State: AFqh2kozaANmFmIsEBGlYGYkiHiZhs9y3iKZ3q1KyYuDF6JS6kvoSa+K
        Hg1g/BTzffJmTKIXjszBAmpeg+PaGp34U7HuMRHcX23bIAnYmA==
X-Google-Smtp-Source: AMrXdXuHeptaQYYGvY9jnXAKuKYjLZ2FHAoUdHqkoy3wE9wAspZIW9cv1Pq++dJtyFT3qYyWakNZOVDrLM1Edr4UKHU=
X-Received: by 2002:a81:1348:0:b0:3d1:c26d:12b1 with SMTP id
 69-20020a811348000000b003d1c26d12b1mr426958ywt.24.1673976067612; Tue, 17 Jan
 2023 09:21:07 -0800 (PST)
MIME-Version: 1.0
References: <20221021011510.1890852-1-joannelkoong@gmail.com>
 <CAADnVQKhv2YBrUAQJq6UyqoZJ-FGNQbKenGoPySPNK+GaOjBOg@mail.gmail.com> <0c7fff1b-8d32-3a9f-40d1-03dcbb2315c1@gmail.com>
In-Reply-To: <0c7fff1b-8d32-3a9f-40d1-03dcbb2315c1@gmail.com>
From:   Joanne Koong <joannelkoong@gmail.com>
Date:   Tue, 17 Jan 2023 09:20:56 -0800
Message-ID: <CAJnrk1YB5SSetrKLMZz3HySdMxu4N50_rmbvOAtu-Vmv+tdcOQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v7 0/3] Add skb + xdp dynptrs
To:     Tariq Toukan <ttoukan.linux@gmail.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        bpf <bpf@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <martin.lau@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        Jakub Kicinski <kuba@kernel.org>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Gal Pressman <gal@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 15, 2023 at 4:41 AM Tariq Toukan <ttoukan.linux@gmail.com> wrote:
>
> Hi,
>
> I'm reviving this thread, following the discussion here:
> https://lore.kernel.org/bpf/87fscjakba.fsf@toke.dk/
>
> On 21/10/2022 4:19, Alexei Starovoitov wrote:
> > On Thu, Oct 20, 2022 at 6:15 PM Joanne Koong <joannelkoong@gmail.com> wrote:
> >>
> >> This patchset is the 2nd in the dynptr series. The 1st can be found here [0].
> >>
> >> This patchset adds skb and xdp type dynptrs, which have two main benefits for
> >> packet parsing:
> >>      * allowing operations on sizes that are not statically known at
> >>        compile-time (eg variable-sized accesses).
> >>      * more ergonomic and less brittle iteration through data (eg does not need
> >>        manual if checking for being within bounds of data_end)
> >>
> >> When comparing the differences in runtime for packet parsing without dynptrs
> >> vs. with dynptrs for the more simple cases, there is no noticeable difference.
> >> For the more complex cases where lengths are non-statically known at compile
> >> time, there can be a significant speed-up when using dynptrs (eg a 2x speed up
> >> for cls redirection). Patch 3 contains more details as well as examples of how
> >> to use skb and xdp dynptrs.
> >
> > Before proceeding with this patchset I think we gotta resolve the
> > issues with dynptr-s that Kumar found.
>
> Just to make sure I'm following: The issues that are discussed here?
> https://lore.kernel.org/all/CAP01T74icBDXOM=ckxYVPK90QLcU4n4VRBjON_+v74dQwJfZvw@mail.gmail.com/
>
> What is the current status of dynptrs?
> Any updates since October?
> Do we have any agreement or a plan for this?

Hi Tariq,

The current status of dynptrs is blocked on two things: 1) the fixes
by Kumar in [1] landing upstream and 2) a bigger question of whether
bpf development should proceed with kfuncs or helpers (thread in [2]).
We had a bpf office hour session last Thursday about whether helpers
should be frozen (#2), but did not come to a conclusion in the time
allotted. As a follow-up to the office hour, Toke and David Vernet, I
believe, are working on a document outlining how kfunc stability will
work. After this document is sent out, I think we will probably have
another office hour session or discussion upstream about which
direction to take.

[1] https://lore.kernel.org/bpf/20230101083403.332783-1-memxor@gmail.com/
[2] https://lore.kernel.org/bpf/20221208015434.ervz6q5j7bb4jt4a@macbook-pro-6.dhcp.thefacebook.com/t/#u

>
> Regards,
> Tariq

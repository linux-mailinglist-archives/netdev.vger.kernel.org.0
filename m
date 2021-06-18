Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B6683ACDAC
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 16:38:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234574AbhFROks (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 10:40:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234232AbhFROks (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Jun 2021 10:40:48 -0400
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0C87C061574;
        Fri, 18 Jun 2021 07:38:37 -0700 (PDT)
Received: by mail-lf1-x134.google.com with SMTP id x24so17036894lfr.10;
        Fri, 18 Jun 2021 07:38:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3zleJHevyKJ//b+WW8snwMv50WmZuJV+nTZxScFD/g4=;
        b=sZ2igkKc4vWxJhusDLqAlz4NAWGWyjs+Jh4INzsqE/ZnesEdA74yzqeK/TWOdvstFH
         15LN5ZgnIW/pNiXdcUW3zA9MtKsi4vx6SZ2exfq01bxKKqjGz4WutaGW4bUFCgJxOlGd
         28zSDQf8WCM/IHZj5aq6Am2WX1o22SUSQ1/2Ye0xg5jiKKONIhOXIuC0A0B5W7PN75nn
         PB4+t9v38c7ocyNyuzf1I2M2HBZrnbfuok7mP2UZM2d8/z0tJhi3vPd9oYJlAHTcVEg9
         xAIIv9Px673qrGswyS1Wzah48IFk+LPsTT2mhzWs+9jS8tJviW3YSLUxX4+oyhB26m3+
         ImkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3zleJHevyKJ//b+WW8snwMv50WmZuJV+nTZxScFD/g4=;
        b=DPaFhMzMLidBiMtIW5QLL08mHaQxtATFHMjxgpgH/S/UJsT7PybiSwooRSqDdOd1Hn
         HyLr/4SCRpbXvjEy2Vg8ioUvHn3U/Qpb+eEoDqC6Jv4cy5fhTNskjE93mO6/XcRDh3Iu
         CDmgZsvdQJhsjcfEaLcb/A0ey42dY/43H73D/dPSuGRilG3kt/dNLoKewOU99JKQCftA
         gWeIj9FPlK0+zrLHX61Fwm0aHAluLPTAtNxme34NDTlSAASZbR2VLFKGVRhrHYP0GITy
         po1xxb71pmB5mEwEfFMVFDo7j+Gbj+JH4DqgRzMRqAiyA3wIfT1yPq34F8iQrLlR+9ZW
         ctGA==
X-Gm-Message-State: AOAM533mW0gHULdw3SqZJaXcxV/rqsf2/3+eqTwtTfBP6mS8vQt/W227
        yoz66UWryHFTLp3f6M2uU942f73Gv0c+Wy4GduE=
X-Google-Smtp-Source: ABdhPJzAuzMs6NVa0s3TWesq9m5lyxTWrjZKrZnoV7lTC059Ikwx8s+mPuRMf/R5BSkb+EraqBhM4YRkd2GRseef404=
X-Received: by 2002:ac2:4649:: with SMTP id s9mr3675765lfo.540.1624027116224;
 Fri, 18 Jun 2021 07:38:36 -0700 (PDT)
MIME-Version: 1.0
References: <20210607060724.4nidap5eywb23l3d@apollo> <CAM_iQpWA=SXNR3Ya8_L2aoVJGP_uaRP8EYCpDrnq3y8Uf6qu=g@mail.gmail.com>
 <20210608071908.sos275adj3gunewo@apollo> <CAM_iQpXFmsWhMA-RO2j5Ph5Ak8yJgUVBppGj2_5NS3BuyjkvzQ@mail.gmail.com>
 <20210613025308.75uia7rnt4ue2k7q@apollo> <30ab29b9-c8b0-3b0f-af5f-78421b27b49c@mojatatu.com>
 <20210613203438.d376porvf5zycatn@apollo> <4b1046ef-ba16-f8d8-c02e-d69648ab510b@mojatatu.com>
 <bd18943b-8a0e-be8c-6a99-17f7dfdd3bc4@iogearbox.net> <7248dc4e-8c07-a25d-5ac3-c4c106b7a266@mojatatu.com>
 <20210616153209.pejkgb3iieu6idqq@apollo> <05ec2836-7f0d-0393-e916-fd578d8f14ac@iogearbox.net>
 <f038645a-cb8a-dc59-e57e-2544a259bab1@mojatatu.com>
In-Reply-To: <f038645a-cb8a-dc59-e57e-2544a259bab1@mojatatu.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 18 Jun 2021 07:38:24 -0700
Message-ID: <CAADnVQLO-r88OZEj93Bp_eOLi1zFu3Gfm7To+XtEN7Sj0ZpOMg@mail.gmail.com>
Subject: Re: [PATCH RFC bpf-next 0/7] Add bpf_link based TC-BPF API
To:     Jamal Hadi Salim <jhs@mojatatu.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Vlad Buslov <vladbu@nvidia.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Joe Stringer <joe@cilium.io>,
        Quentin Monnet <quentin@isovalent.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Marcelo Ricardo Leitner <mleitner@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 18, 2021 at 4:40 AM Jamal Hadi Salim <jhs@mojatatu.com> wrote:
>
> We are going to present some of the challenges we faced in a subset
> of our work in an approach to replace iptables at netdev 0x15
> (hopefully we get accepted).

Jamal,
please stop using netdev@vger mailing list to promote a conference
that does NOT represent the netdev kernel community.
Slides shown at that conference is a non-event as far as this discussion goes.

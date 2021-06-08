Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0E1139FB01
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 17:39:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231261AbhFHPlW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 11:41:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230460AbhFHPlU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Jun 2021 11:41:20 -0400
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53702C061574;
        Tue,  8 Jun 2021 08:39:25 -0700 (PDT)
Received: by mail-lf1-x12c.google.com with SMTP id i10so32786797lfj.2;
        Tue, 08 Jun 2021 08:39:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Iq8eVNhJhF1BgqV6rgMywl+V3RTaF2wJHyqDAwR07h4=;
        b=Iw99WPm1KMhY75sqNthZOHqMfd/f3w4A9cgnIYqs1rKNrxhKelf5Lw4wz6VEcDqxDa
         j4A5yhxQqy3wkKjA09NTqedHr6MBeBnrjgKNdarWfojMAj2arlYCCJ2LTF9fWSTGAQTC
         0+KN1UBEIyyxcLThQRMpLPJ7XijRtMjbikgF77E4NSCbNRaoIZ7Dz7j4LbTaBAx0/CvB
         zHqrHVv7eeAXTlqC0syxAK6EZpys8S1FE4Gn8dpWdu0ZkbAGDSi3GKGysgttex0hpiqZ
         eTts9Nn/g4nIBHcYoJvxvOpi918feVsw5/g3WohqFs3pUq8yiiU/wL2Y890WDCw2sDmZ
         Qq1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Iq8eVNhJhF1BgqV6rgMywl+V3RTaF2wJHyqDAwR07h4=;
        b=YZJllNlVuqa+WIvnHV+QwyWYfjKS/yAT0jddWJOejhfha+w1ZeNkJqY8uXMlRiPl/3
         ugWOQ7ET2Fqu+IvEjKohF1mYVOaubnQXnC/fpbA9B/ZGzOBoSLQjLta7K2THh3OKWcxf
         MM29G/lTOeEBnyYVVyPq/6++QlT1HNE2QHNEAvEYJf6SNOtKs5RDTasE3wuSuW45Baxi
         sBTcEFz3EdU1cxztQjLiZWy56gYGGVXtwy0vj1f53ZzH/5EpawcqmHRFDdF8TuITpbMz
         SHKSejY+H5VYw+9CgRsogMUoDkp2hgXAiQidoI7CtbSN4vQuByabQTxBaJRpbga2O1vd
         NyIg==
X-Gm-Message-State: AOAM533I15BrWD9qvbX0i+tfc1dl0fnG+Ia5jrPwNlhIUTr5buHkWOiK
        BXxS1oue4w7IfLI9hwxwSJhBy4U+XKJoXlz4OgI=
X-Google-Smtp-Source: ABdhPJwlKc1tWRxGPO1nGw6sTT8IvYSurj4eT70sJKIp1CD56tRe7oKcBCbnocBopBlvGrAVNG4+kotDKh8o6so5Luc=
X-Received: by 2002:ac2:5551:: with SMTP id l17mr16156795lfk.534.1623166763631;
 Tue, 08 Jun 2021 08:39:23 -0700 (PDT)
MIME-Version: 1.0
References: <20210528195946.2375109-1-memxor@gmail.com> <CAM_iQpVqVKhK+09Sj_At226mdWpVXfVbhy89As2dai7ip8Nmtw@mail.gmail.com>
 <20210607033724.wn6qn4v42dlm4j4o@apollo> <CAM_iQpVCnG8pSci2sMbJ1B5YE-y=reAUp82itgrguecyNBCUVQ@mail.gmail.com>
 <20210607060724.4nidap5eywb23l3d@apollo> <CAM_iQpWA=SXNR3Ya8_L2aoVJGP_uaRP8EYCpDrnq3y8Uf6qu=g@mail.gmail.com>
 <20210608071908.sos275adj3gunewo@apollo>
In-Reply-To: <20210608071908.sos275adj3gunewo@apollo>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 8 Jun 2021 08:39:12 -0700
Message-ID: <CAADnVQLRVikjNe-FqYxcSYLSCXGF_bV1UWERWuW8NvL8+4rJ6A@mail.gmail.com>
Subject: Re: [PATCH RFC bpf-next 0/7] Add bpf_link based TC-BPF API
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc:     Cong Wang <xiyou.wangcong@gmail.com>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Vlad Buslov <vladbu@nvidia.com>, Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Joe Stringer <joe@cilium.io>,
        Quentin Monnet <quentin@isovalent.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 8, 2021 at 12:20 AM Kumar Kartikeya Dwivedi
<memxor@gmail.com> wrote:
>
> > 2) All existing bpf_link targets, except netdev, are fs based, hence an fd makes
> > sense for them naturally. TC filters, or any other netlink based

fs analogy is not applicable.
bpf_link-s for tracing and xdp have nothing to do with file systems.

> > things, are not even
> > related to fs, hence fd does not make sense here, like we never bind a netdev
> > to a fd.
> >
>
> Yes, none of them create any objects. It is only a side effect of current
> semantics that you are able to control the filter's lifetime using the bpf_link
> as filter creation is also accompanied with its attachment to the qdisc.

I think it makes sense to create these objects as part of establishing bpf_link.
ingress qdisc is a fake qdisc anyway.
If we could go back in time I would argue that its existence doesn't
need to be shown in iproute2. It's an object that serves no purpose
other than attaching filters to it. It doesn't do any queuing unlike
real qdiscs.
It's an artifact of old choices. Old doesn't mean good.
The kernel is full of such quirks and oddities. New api-s shouldn't
blindly follow them.
tc qdisc add dev eth0 clsact
is a useless command with nop effect.

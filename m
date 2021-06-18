Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B088E3AD048
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 18:23:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235852AbhFRQZi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 12:25:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232638AbhFRQZg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Jun 2021 12:25:36 -0400
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0291C061574;
        Fri, 18 Jun 2021 09:23:24 -0700 (PDT)
Received: by mail-lf1-x129.google.com with SMTP id p7so17505490lfg.4;
        Fri, 18 Jun 2021 09:23:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JS/DhvlmnghjWYQG91pr5+kEoD0bUOvxAqSq4F29+Lg=;
        b=pyKjX0PgwfXlQ+p4oBdM/x/M/QZx0v8sOAQPz8HvLTtHol2PvrB1OLsw2EY5AwsqRB
         wTwMKH4ulCjR+4NlFAn05mz2+5St/KPzYSNCyYqsHbvIUJ/zYpyqijuyzP6T4UB4btMv
         Sn3wJDBYXuGEb9uu9XNq9VZhnburmx+o2p8zaOURRGuJNDobA/AjgA0p0TYhjXfMqSq2
         hwW2DS55P7hBaqACSjajYG4jq4iHHX0N2gBRdVi3rC9y2bk/jnuWMq867I8nwFYGLOMu
         aFp2fCtCeH4NHLfT5Jf9rPWlVYjvJHIfiPrE9NLddEEEQpiD5moP1/0xb73pnNJsYk5e
         jmEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JS/DhvlmnghjWYQG91pr5+kEoD0bUOvxAqSq4F29+Lg=;
        b=fOkttrIgrFQXYmR6/gKa73D67/h4tnMm2YTIFzVQX24JC6Vu/8MLCzQeTPqBIN0smq
         oYvHyhEk9al6S+Aidz4zCHwW1tz/vPEgM/QUjEe8kSiAX3CTU2jOw4S4zDA7jEnz8SNF
         kHN35Sh+oxR3L5LW+Mg3YLdy59FvXpA2zP/DKB7pXixJOzGxS/2ajHrxKAjnBBiEsL4X
         WAjUaheYxLasg8hhTrGQOhd2adNSzQIRkHrP/fRFxB0axT+RYszi8QFjlAuxx1lXD1CF
         yN+0v4e2vX/RLqmKvWz8JhKWwcqr0mZIH296O2GicrbthXyYhPUmqN8fPQPuPY1YuNXc
         z22w==
X-Gm-Message-State: AOAM530YsQuLftRGFlJsII9A/unOTyF7Y+Fo/eCax0JotvIKkEz/aV5Y
        9fyoB0O//xZK3t0mOECnn/USZ1G4ID/npzrnA9Ji6Lxq
X-Google-Smtp-Source: ABdhPJx8JeK/QwlwM3IgwplZbFKMKEpgdTwHaGApuuYztnSHWkJAQBTy1Jfre0GOG2Am6sc07F64OMXo5HYDSoZnYl0=
X-Received: by 2002:a05:6512:3c91:: with SMTP id h17mr4040834lfv.214.1624033402477;
 Fri, 18 Jun 2021 09:23:22 -0700 (PDT)
MIME-Version: 1.0
References: <20210607060724.4nidap5eywb23l3d@apollo> <CAM_iQpWA=SXNR3Ya8_L2aoVJGP_uaRP8EYCpDrnq3y8Uf6qu=g@mail.gmail.com>
 <20210608071908.sos275adj3gunewo@apollo> <CAM_iQpXFmsWhMA-RO2j5Ph5Ak8yJgUVBppGj2_5NS3BuyjkvzQ@mail.gmail.com>
 <20210613025308.75uia7rnt4ue2k7q@apollo> <30ab29b9-c8b0-3b0f-af5f-78421b27b49c@mojatatu.com>
 <20210613203438.d376porvf5zycatn@apollo> <4b1046ef-ba16-f8d8-c02e-d69648ab510b@mojatatu.com>
 <bd18943b-8a0e-be8c-6a99-17f7dfdd3bc4@iogearbox.net> <7248dc4e-8c07-a25d-5ac3-c4c106b7a266@mojatatu.com>
 <20210616153209.pejkgb3iieu6idqq@apollo> <05ec2836-7f0d-0393-e916-fd578d8f14ac@iogearbox.net>
 <f038645a-cb8a-dc59-e57e-2544a259bab1@mojatatu.com> <CAADnVQLO-r88OZEj93Bp_eOLi1zFu3Gfm7To+XtEN7Sj0ZpOMg@mail.gmail.com>
 <ec3a9381-7b15-e60f-86b6-87135393461d@mojatatu.com>
In-Reply-To: <ec3a9381-7b15-e60f-86b6-87135393461d@mojatatu.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 18 Jun 2021 09:23:10 -0700
Message-ID: <CAADnVQKi_3i6bOrYiDTLXwxhQnHDBJvHankqndzNP7eCJr27pQ@mail.gmail.com>
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

On Fri, Jun 18, 2021 at 7:50 AM Jamal Hadi Salim <jhs@mojatatu.com> wrote:
>
> On 2021-06-18 10:38 a.m., Alexei Starovoitov wrote:
> > On Fri, Jun 18, 2021 at 4:40 AM Jamal Hadi Salim <jhs@mojatatu.com> wrote:
> >>
> >> We are going to present some of the challenges we faced in a subset
> >> of our work in an approach to replace iptables at netdev 0x15
> >> (hopefully we get accepted).
> >
> > Jamal,
> > please stop using netdev@vger mailing list to promote a conference
> > that does NOT represent the netdev kernel community.
>  >
> > Slides shown at that conference is a non-event as far as this discussion goes.
>
> Alexei,
> Tame the aggression, would you please?
> You have no right to make claims as to who represents the community.
> Absolutely none. So get off that high horse.
>
> I only mentioned the slides because it will be a good spot when
> done which captures the issues. As i mentioned in i actually did
> send some email (some Cced to you) but got no response.
> I dont mind having a discussion but you have to be willing to
> listen as well.

You've side tracked technical discussion to promote your own conference.
That's not acceptable. Please use other forums for marketing.
This mailing list is for technical discussions.

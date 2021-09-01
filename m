Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3011F3FE1AE
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 20:04:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236885AbhIASFI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Sep 2021 14:05:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239445AbhIASFI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Sep 2021 14:05:08 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1D30C061760;
        Wed,  1 Sep 2021 11:04:10 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id n13-20020a17090a4e0d00b0017946980d8dso281767pjh.5;
        Wed, 01 Sep 2021 11:04:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DiF3tLB29QW9ENAD317YvoaXV5jLbq8iy3MNLFMDbCo=;
        b=R0F9AUbHanHEVn9Hqw69rDb1XySAZskfrbtJPJIT4u2jFA1nosVK2AW+kyUPOtpHjf
         eD/5ucWhw0604AsCz6yaxk3pz3GHzK3xMbKZw+MFk4z45OrLuSllA86gNp5mjKXEw0xM
         lP0XmtPs8iDxybFw0AxdZmCIlXbj3MLVdk/Z4quZNmlfLt4p9vjmprmPSXmwXYNdV/dm
         jwzblS5/p7z3fDA/yDWpBdq3nVRcc5nm9e1rA8/Awx+s45DWS++VGt0Qz6qFOuU59nW2
         dB7VF4pNaDtTWr43Qlo5mKpptvNpwYK+t4NRz5F895UT8yU14jc27U6DruAovGB5uAo2
         wdmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DiF3tLB29QW9ENAD317YvoaXV5jLbq8iy3MNLFMDbCo=;
        b=ODTB2Vp6O/33hL8LTIED0B41DCaTVv6Ktx5xIcPUMRFkoHKFYChGRHhY1WopMI1o3R
         hnGhb9sispeniEYjtpK2XrgJ0zt7uzwqeY0p3cdsgOBdupfS8QDJGHJixl/PzaUyFIRt
         3FPn7MmBrI207eZ1vh4pu3vIJ4ciEhIj2KJIwQ0as8wqcJCK4w0UBFdLf6dc5JvL+UgB
         q10wcsIC52bg9WT5e22ZpYMaFRz+F+4TdkGSjKLDOaY0ktsbUEa0HTgKdcR38G07fN2I
         YaD1+3+bOCHgHk4CwHA3N9fXL85axpr72/JEATyxsLP10W71WQxd9rFWDILp2NRlb1Rz
         867Q==
X-Gm-Message-State: AOAM5316Phyv3CdObPYZmmZKlazNWhMH8SPYGTG+k71xqZaH68tiqM8q
        /Z/9saBwUoQkrMTSaSpGWFCZQsspQfmBXWyx8MU=
X-Google-Smtp-Source: ABdhPJyEJJPDwIfngREnKVUtzzrLgnLLacQrFH2Zdq8EvoZ9CdRB39/fBVmNX0iKy9rt6ZTiFEHxmXGNWKB/RC1Fbe8=
X-Received: by 2002:a17:902:8c90:b0:12f:699b:27 with SMTP id
 t16-20020a1709028c9000b0012f699b0027mr655112plo.28.1630519450317; Wed, 01 Sep
 2021 11:04:10 -0700 (PDT)
MIME-Version: 1.0
References: <20210821010240.10373-1-xiyou.wangcong@gmail.com>
 <20210824234700.qlteie6al3cldcu5@kafai-mbp> <CAM_iQpWP_kvE58Z+363n+miTQYPYLn6U4sxMKVaDvuRvjJo_Tg@mail.gmail.com>
 <612f137f4dc5c_152fe20891@john-XPS-13-9370.notmuch> <871r68vapw.fsf@toke.dk> <20210901174543.xukawl7ylkqzbuax@kafai-mbp.dhcp.thefacebook.com>
In-Reply-To: <20210901174543.xukawl7ylkqzbuax@kafai-mbp.dhcp.thefacebook.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 1 Sep 2021 11:03:59 -0700
Message-ID: <CAADnVQK8Q6C=yq7qLaibwGDV0YuMP2DywjKfJCXr6Z1p17-tHg@mail.gmail.com>
Subject: Re: [RFC Patch net-next] net_sched: introduce eBPF based Qdisc
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Cong Wang <cong.wang@bytedance.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 1, 2021 at 10:46 AM Martin KaFai Lau <kafai@fb.com> wrote:
> > > Another idea. Rather than work with qdisc objects which creates all
> > > these issues with how to work with existing interfaces, filters, etc.
> > > Why not create an sk_buff map? Then this can be used from the existing
> > > egress/ingress hooks independent of the actual qdisc being used.
> >
> > I agree. In fact, I'm working on doing just this for XDP, and I see no
> > reason why the map type couldn't be reused for skbs as well. Doing it
> > this way has a couple of benefits:
> >
> > - It leaves more flexibility to BPF: want a simple FIFO queue? just
> >   implement that with a single queue map. Or do you want to build a full
> >   hierarchical queueing structure? Just instantiate as many queue maps
> >   as you need to achieve this. Etc.
> Agree.  Regardless how the interface may look like,
> I even think being able to queue/dequeue an skb into different bpf maps
> should be the first thing to do here.  Looking forward to your patches.
>
> >
> > - The behaviour is defined entirely by BPF program behaviour, and does
> >   not require setting up a qdisc hierarchy in addition to writing BPF
> >   code.
> Interesting idea.  If it does not need to use the qdisc object/interface
> and be able to do the qdisc hierarchy setup in a programmable way, it may
> be nice.  It will be useful for the future patches to come with some
> bpf prog examples to do that.

Wow. When core developers think along the same lines and
build/refine the idea together it's simply awesome.

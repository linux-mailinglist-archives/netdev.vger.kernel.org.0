Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AC7E3A9F24
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 17:33:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234616AbhFPPfo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 11:35:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234332AbhFPPfn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Jun 2021 11:35:43 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95A5BC061574;
        Wed, 16 Jun 2021 08:33:36 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id g22so2297916pgk.1;
        Wed, 16 Jun 2021 08:33:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=YMTC6qfJsU9J/ZI5NR0czdPYf8hfDFPK4/N33WdOmEY=;
        b=hb8FnuvXZOVPttyVj+V38RIHHudyvGte5KA9Hqdyf+fvG8KCoH69N0lVXdSquJvoJv
         4J5+wfSDQF4kH4/0ZYdIQJmGXd9GNHHGUW0FF9UvYyxGJCySdD9TbJAZEUW7jJDd5858
         DEeCUOUwGfiMMayBk8htaOq76V53Kg7G9mHvQB8Ie06iAqu1NRVZciLwxTamd7mQo96D
         OXH1zjpJVv8GRbZmo2J2/6lUgwqOvWchHK05dvzR7N8sIbunONFIdMPcifRlHYXnaGUf
         NbpPptT6DSnPikzW1bjyn4pK6cRRLQMD3PCg3/p8ziKjesQ0VZgDGvBq0QrOVBm6HR2D
         jC/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=YMTC6qfJsU9J/ZI5NR0czdPYf8hfDFPK4/N33WdOmEY=;
        b=EYN3KwR702Pjt6Hch1xnqHlxjVyqSn3bgqspIZNrgxsnpnZt/2JfRB/8U2YvjoHd5I
         HSItSVHVxKwTxEjkVCdn+ltifg6BUnEJhj1igeiS4yo+qe0cUbRI8p7LOpgz2a8fyrbw
         k9QSzb98ZAR3Hc46Ih0nIqQVEEukPYZib9mu90FWt4OBkT8tXy14wOjMl+sK8sVwH2UZ
         xAf6WV6Bqyh6oy6hV5YbeI3TReQf/2dwKyUwqXE+M9yo3HpfusnRlgUBV/ZwYByRD2oM
         Em91fcEgj7lzpDWMltbX2dAKRN2exzykVB6qz8Dz47Ck1qg6HkYyRPnQwIUe9nKN26gq
         TLbA==
X-Gm-Message-State: AOAM531QQI81VgMieNZYE3JMRYS/THeTCRJITbenSdaKuv6n1MhYaPQc
        Ktbn/OZ4/v4YJUDk/vIM0iI=
X-Google-Smtp-Source: ABdhPJwB35hwi1oqdI38OeQsmibCzw2Syaszj0ulaMn2/BFM0tNQ7WslDxlT6ur/LlNLJ19dpkHKfw==
X-Received: by 2002:a63:e90e:: with SMTP id i14mr149123pgh.89.1623857616052;
        Wed, 16 Jun 2021 08:33:36 -0700 (PDT)
Received: from localhost ([2402:3a80:11db:39d5:aefe:1e71:33ef:30fb])
        by smtp.gmail.com with ESMTPSA id ga23sm6126709pjb.0.2021.06.16.08.33.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Jun 2021 08:33:35 -0700 (PDT)
Date:   Wed, 16 Jun 2021 21:02:09 +0530
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     Jamal Hadi Salim <jhs@mojatatu.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
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
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Marcelo Ricardo Leitner <mleitner@redhat.com>
Subject: Re: [PATCH RFC bpf-next 0/7] Add bpf_link based TC-BPF API
Message-ID: <20210616153209.pejkgb3iieu6idqq@apollo>
References: <20210607060724.4nidap5eywb23l3d@apollo>
 <CAM_iQpWA=SXNR3Ya8_L2aoVJGP_uaRP8EYCpDrnq3y8Uf6qu=g@mail.gmail.com>
 <20210608071908.sos275adj3gunewo@apollo>
 <CAM_iQpXFmsWhMA-RO2j5Ph5Ak8yJgUVBppGj2_5NS3BuyjkvzQ@mail.gmail.com>
 <20210613025308.75uia7rnt4ue2k7q@apollo>
 <30ab29b9-c8b0-3b0f-af5f-78421b27b49c@mojatatu.com>
 <20210613203438.d376porvf5zycatn@apollo>
 <4b1046ef-ba16-f8d8-c02e-d69648ab510b@mojatatu.com>
 <bd18943b-8a0e-be8c-6a99-17f7dfdd3bc4@iogearbox.net>
 <7248dc4e-8c07-a25d-5ac3-c4c106b7a266@mojatatu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7248dc4e-8c07-a25d-5ac3-c4c106b7a266@mojatatu.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 16, 2021 at 08:10:55PM IST, Jamal Hadi Salim wrote:
> On 2021-06-15 7:07 p.m., Daniel Borkmann wrote:
> > On 6/13/21 11:10 PM, Jamal Hadi Salim wrote:
>
> [..]
>
> > >
> > > I look at it from the perspective that if i can run something with
> > > existing tc loading mechanism then i should be able to do the same
> > > with the new (libbpf) scheme.
> >
> > The intention is not to provide a full-blown tc library (that could be
> > subject to a
> > libtc or such), but rather to only have libbpf abstract the tc related
> > API that is
> > most /relevant/ for BPF program development and /efficient/ in terms of
> > execution in
> > fast-path while at the same time providing a good user experience from
> > the API itself.
> >
> > That is, simple to use and straight forward to explain to folks with
> > otherwise zero
> > experience of tc. The current implementation does all that, and from
> > experience with
> > large BPF programs managed via cls_bpf that is all that is actually
> > needed from tc
> > layer perspective. The ability to have multi programs (incl. priorities)
> > is in the
> > existing libbpf API as well.
> >
>
> Which is a fair statement, but if you take away things that work fine
> with current iproute2 loading I have no motivation to migrate at all.
> Its like that saying of "throwing out the baby with the bathwater".
> I want my baby.
>
> In particular, here's a list from Kartikeya's implementation:
>
> 1) Direct action mode only
> 2) Protocol ETH_P_ALL only
> 3) Only at chain 0
> 4) No block support
>

Block is supported, you just need to set TCM_IFINDEX_MAGIC_BLOCK as ifindex and
parent as the block index. There isn't anything more to it than that from libbpf
side (just specify BPF_TC_CUSTOM enum).

What I meant was that hook_create doesn't support specifying the ingress/egress
block when creating clsact, but that typically isn't a problem because qdiscs
for shared blocks would be set up together prior to the attachment anyway.

> I think he said priority is supported but was also originally on that
> list.
> When we discussed at the meetup it didnt seem these cost anything
> in terms of code complexity or usability of the API.
>
> 1) We use non-DA mode, so i cant live without that (and frankly ebpf
> has challenges adding complex code blocks).
>
> 2) We also use different protocols when i need to
> (yes, you can do the filtering in the bpf code - but why impose that
> if the cost of adding it is simple? and of course it is cheaper to do
> the check outside of ebpf)
> 3) We use chains outside of zero
>
> 4) So far we dont use block support but certainly my recent experiences
> in a deployment shows that we need to group netdevices more often than
> i thought was necessary. So if i could express one map shared by
> multiple netdevices it should cut down the user space complexity.
>
> cheers,
> jamal

--
Kartikeya

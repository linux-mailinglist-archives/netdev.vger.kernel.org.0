Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8279C399296
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 20:31:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229719AbhFBSdV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 14:33:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229657AbhFBSdU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Jun 2021 14:33:20 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F00A8C06174A;
        Wed,  2 Jun 2021 11:31:21 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id d5-20020a17090ab305b02901675357c371so3623693pjr.1;
        Wed, 02 Jun 2021 11:31:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=L4f38XOp1iIkfafLQQl9LPSFE+Zw4m/hbQ7kccs+PAQ=;
        b=n0tqXUyAfQ7wsXMsu8XF4gukNfpV+K5xgOrxr/41gXK8+HoLVdRyvxjo2W05xema6j
         FCHsQYrMUELskQoIlDHEZSyubvXHpTynVcduGbZEDXcbcU82QJPuU56AnYAKZEWqbCHp
         j/FUc2ICqdXUEyvooM+R1Le0nVZUoOCVFi9sulseiwa01BofFI35Pu5SyyPaRB8xHT2E
         2Iurkir3jNa9OLRmgV6MeONsYgXP/4WxNMbxJl03a0NLG39V3uQaAVXaDXXuP7iF2yro
         fvYMMAz05H1zn3tvbgPlbIeYXgdv5hcEo3Xf5Ya7FySRUtglwcORbPIW95Vrs20wx1hy
         HbHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=L4f38XOp1iIkfafLQQl9LPSFE+Zw4m/hbQ7kccs+PAQ=;
        b=TbjVPMDHuBt7PjbCIJ6uTR3SiSmVaMt5M88FMtTaMKLuaTvPDMvG4Tr0k1EyP6ig9g
         XYYIDru09Fw5z5ccDeFFI4YTR59SWPfRKX8DaSnYVsjjjwYcgzKvCOtpxlX1LQhpiXVR
         5ZXkD8/lPVsKOYfZ6V5Xdw2lqUpy2YPOz+maCHsbCvGqK5WdeYurTPDvoebjh+a88Wrt
         iBAET1Zy7Rx5OGzLTUl0Mkime6asIPjHQRmSFKM3rcIpx8sNEH1PcrXzP687DMYNb0oY
         fOFAbZHEDCdvSb62Ef2q72pZa38fpv1KmduhMFWus0T8YzA4Ma4C7jaKR/WILm6HdLWO
         pq+g==
X-Gm-Message-State: AOAM532BpOS3EuQFrCIdIze+nlwfXwAD8ULdg+yMcABN8Mpo2veYNKaG
        v86i3hRGQymLEIqqhDdK/R8=
X-Google-Smtp-Source: ABdhPJx6prsJXhq23n+R/DvTEgi91eh8H6NZYcvmoutX9bxMPeshsjuy+gn6EwD4bR1/aQHxuAWImg==
X-Received: by 2002:a17:902:be0a:b029:104:4f7c:8140 with SMTP id r10-20020a170902be0ab02901044f7c8140mr18034117pls.70.1622658681459;
        Wed, 02 Jun 2021 11:31:21 -0700 (PDT)
Received: from localhost ([2402:3a80:11c3:3834:fb69:d961:ca12:b10d])
        by smtp.gmail.com with ESMTPSA id md24sm205267pjb.43.2021.06.02.11.31.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Jun 2021 11:31:21 -0700 (PDT)
Date:   Thu, 3 Jun 2021 00:00:22 +0530
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Martin KaFai Lau <kafai@fb.com>,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        David Miller <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, kernel-team <kernel-team@fb.com>
Subject: Re: [RFC PATCH bpf-next] bpf: Introduce bpf_timer
Message-ID: <20210602183022.pjk54unrwcg5gp65@apollo>
References: <CAADnVQ+V5o31-h-A+eNsHvHgOJrVfP4wVbyb+jL2J=-ionV0TA@mail.gmail.com>
 <CAM_iQpU-Cvpf-+9R0ZdZY+5Dv+stfodrH0MhvSgryv_tGiX7pA@mail.gmail.com>
 <CAM_iQpVYBNkjDeo+2CzD-qMnR4-2uW+QdMSf_7ohwr0NjgipaQ@mail.gmail.com>
 <CAADnVQJUHydpLwtj9hRWWNGx3bPbdk-+cQiSe3MDFQpwkKmkSw@mail.gmail.com>
 <CAM_iQpXUBuOirztj3kifdFpvygKb-aoqwuXKkLdG9VFte5nynA@mail.gmail.com>
 <20210602020030.igrx5jp45tocekvy@ast-mbp.dhcp.thefacebook.com>
 <874kegbqkd.fsf@toke.dk>
 <20210602175436.axeoauoxetqxzklp@kafai-mbp>
 <20210602181333.3m4vz2xqd5klbvyf@apollo>
 <CAADnVQJTJzxzig=1vvAUMXELUoOwm2vXq0ahP4mfhBWGsCm9QA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAADnVQJTJzxzig=1vvAUMXELUoOwm2vXq0ahP4mfhBWGsCm9QA@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 02, 2021 at 11:56:40PM IST, Alexei Starovoitov wrote:
> On Wed, Jun 2, 2021 at 11:14 AM Kumar Kartikeya Dwivedi
> <memxor@gmail.com> wrote:
> >
> > On Wed, Jun 02, 2021 at 11:24:36PM IST, Martin KaFai Lau wrote:
> > > On Wed, Jun 02, 2021 at 10:48:02AM +0200, Toke Høiland-Jørgensen wrote:
> > > > Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:
> > > >
> > > > >> > In general the garbage collection in any form doesn't scale.
> > > > >> > The conntrack logic doesn't need it. The cillium conntrack is a great
> > > > >> > example of how to implement a conntrack without GC.
> > > > >>
> > > > >> That is simply not a conntrack. We expire connections based on
> > > > >> its time, not based on the size of the map where it residents.
> > > > >
> > > > > Sounds like your goal is to replicate existing kernel conntrack
> > > > > as bpf program by doing exactly the same algorithm and repeating
> > > > > the same mistakes. Then add kernel conntrack functions to allow list
> > > > > of kfuncs (unstable helpers) and call them from your bpf progs.
> > > >
> > > > FYI, we're working on exactly this (exposing kernel conntrack to BPF).
> > > > Hoping to have something to show for our efforts before too long, but
> > > > it's still in a bit of an early stage...
> > > Just curious, what conntrack functions will be made callable to BPF?
> >
> > Initially we're planning to expose the equivalent of nf_conntrack_in and
> > nf_conntrack_confirm to XDP and TC programs (so XDP one works without an skb,
> > and TC one works with an skb), to map these to higher level lookup/insert.
>
> To make sure we're on the same page...
> I still strongly prefer to avoid exposing conntrack via stable helpers.
> Pls use kfunc and unstable interface.

Correct, that is the idea.

--
Kartikeya

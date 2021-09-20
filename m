Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 665844119D8
	for <lists+netdev@lfdr.de>; Mon, 20 Sep 2021 18:33:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234801AbhITQet (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Sep 2021 12:34:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229993AbhITQes (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Sep 2021 12:34:48 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D78AC061574;
        Mon, 20 Sep 2021 09:33:21 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id mv7-20020a17090b198700b0019c843e7233so366898pjb.4;
        Mon, 20 Sep 2021 09:33:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=YVcspMNftAsxUFRvxnT+9Gw5sEXFW56A4jnlNsbowNE=;
        b=Ejfq6rlRJmiwgpL+WjIgdKHbBRpViduhVUDS5G+DOeMixkPZJppAI2ObsEuCDNb4xC
         Zh4Lk+TjiMNMdAydUm1wbY2hAM4NwYAdZwzVyRfwE6LEWoJh2oP307qKYhyvtbxQWBf2
         TYgIGfbsCyf51B72IiJmOCGgpulhdc3IQgLCC2HqIm2HTzAEy0EnsIgNSEvp4Ji5lvSj
         3dPkC8qJvLaeGBJJZMSeNcTG/eDDqFjc2pMEe62AouApgBc5vrsuHS2MgyNGqsYzbKni
         KW8zS6I7iuUO364KMgjgailkHE1Vrnhhr1mOCX72tKOFbi/5LQpHO1pPWJc+OW99iG8t
         jH+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=YVcspMNftAsxUFRvxnT+9Gw5sEXFW56A4jnlNsbowNE=;
        b=U1mq5H2lZShFwDs+Id5zBnWJQ5aBMfpsgEQxIm/43BhZso1yc1ihe3OFb6gS0PkFXn
         Nef8OLzPTjbqQDQKi+AYgGeVukr0T2effjoV+/uR3/qgvmJ4VLPcGUxbHNXctu+//z2d
         90aOcQF5UxI2OMvVFYpUVPm7xjv694IViOIXL8iR8dVtoMLEvm+0Y9usDUQJjIi01y2I
         rA21xfsR9I7UoRYwrtFMJnVxMsPP666mjvFlsfVix8BBoIJUFn4JWxQ6H0C5aHfEh/09
         w53x52NDPEFFyrVg34XKlht+UoExMX/rb+MroUZjtbrX7jkkKFIWA4bag34W+nJMGz+F
         grSg==
X-Gm-Message-State: AOAM531tBSSCkN2pJ/M1/1nUn2tpLZb8XJJN8sDApHOR9pGnxdLtJ3dR
        t0+bhbA7NtSff41trfRV3islpfVnjXUJ8Q3NA4dz5fad
X-Google-Smtp-Source: ABdhPJzwAEBxfVDDXWphEd7DTrS5TKQngb3H8wDsIQGOVfijDexmW0wFjcYhtCXZ21h4zGGIeNWv5uAqmyjVPmjygSE=
X-Received: by 2002:a17:902:e282:b0:13a:45b7:d2cd with SMTP id
 o2-20020a170902e28200b0013a45b7d2cdmr23507984plc.86.1632155600523; Mon, 20
 Sep 2021 09:33:20 -0700 (PDT)
MIME-Version: 1.0
References: <20210916122943.19849-1-yajun.deng@linux.dev> <20210917183311.2db5f332@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <87275ec67ed69d077e0265bc01acd8a2@linux.dev> <CAM_iQpXcqpEFpnyX=wLQFTWJBjWiAMofighQkpnrV2a0Fh83AQ@mail.gmail.com>
 <202109202028152977817@linux.dev>
In-Reply-To: <202109202028152977817@linux.dev>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Mon, 20 Sep 2021 09:33:09 -0700
Message-ID: <CAM_iQpV4eaiD6msaiYNAOYE9Eoy2AjnGrSSwihhCO-yPb-61ww@mail.gmail.com>
Subject: Re: Re: [PATCH net-next] net: socket: add the case sock_no_xxx support
To:     "yajun.deng@linux.dev" <yajun.deng@linux.dev>
Cc:     kuba <kuba@kernel.org>, davem <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 20, 2021 at 5:28 AM yajun.deng@linux.dev
<yajun.deng@linux.dev> wrote:
>
> From: Cong Wang
> Date: 2021-09-20 07:52
> To: Yajun Deng
> CC: Jakub Kicinski; David Miller; Linux Kernel Network Developers; LKML
> Subject: Re: [PATCH net-next] net: socket: add the case sock_no_xxx suppo=
rt
> On Sat, Sep 18, 2021 at 5:11 AM <yajun.deng@linux.dev> wrote:
> >
> > September 18, 2021 9:33 AM, "Jakub Kicinski" <kuba@kernel.org> wrote:
> >
> > > On Thu, 16 Sep 2021 20:29:43 +0800 Yajun Deng wrote:
> > >
> > >> Those sock_no_{mmap, socketpair, listen, accept, connect, shutdown,
> > >> sendpage} functions are used many times in struct proto_ops, but the=
y are
> > >> meaningless. So we can add them support in socket and delete them in=
 struct
> > >> proto_ops.
> > >
> > > So the reason to do this is.. what exactly?
> > >
> > > Removing a couple empty helpers (which is not even part of this patch=
)?
> > >
> > > I'm not sold, sorry.
> >
> > When we define a struct proto_ops xxx, we only need to assign meaningfu=
l member variables that we need.
> > Those {mmap, socketpair, listen, accept, connect, shutdown, sendpage} m=
embers we don't need assign
> > it if we don't need. We just need do once in socket, not in every struc=
t proto_ops.
> >
> > These members are assigned meaningless values far more often than meani=
ngful ones, so this patch I used likely(!!sock->ops->xxx) for this case. Th=
is is the reason why I send this patch.
>
> But you end up adding more code:
>
> 1 file changed, 58 insertions(+), 13 deletions(-)
>
> Yes=EF=BC=8CThis would add more code, but this is at the cost of reducing=
 other codes. At the same time, the code will only run  likely(!sock->ops->=
xxx) in most cases.  Don=E2=80=99t you think that this kind of meaningless =
thing shouldn=E2=80=99t be done by socket?

I have no idea why you call it reducing code while adding 45 lines
of code. So this does not make sense to me.

Thanks.

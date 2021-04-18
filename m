Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A9473634FF
	for <lists+netdev@lfdr.de>; Sun, 18 Apr 2021 14:06:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231169AbhDRMGx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Apr 2021 08:06:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:53472 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230096AbhDRMGx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 18 Apr 2021 08:06:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8B66C6135A;
        Sun, 18 Apr 2021 12:06:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618747585;
        bh=0Hkw/LBurXvOMvOTA27ssuDEirEUjz+l4Zr+rNZncrY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=l/Mltq5wdtlN/1sxiFhEEKamOrJcJkurT0nE0PizIlGVKPgaAMAGPYXV+9sAommQZ
         Q60KQ00b+Zzy+NQodvw6rOw+zur8vyynZP8wo2nKDJ53VAi92u0vbx5+IFhZ3zLPt+
         Z88lccYZM5ZFlaXyJEKSaJ1T0NMVFs3a5VeQ5TuWDmM08srAKvUo9WrU6f3S9ZaBPT
         YF8e2YaLh4fSZHgjysjMy3sXIyhCjv+eQgoLoqZkcy2HKM+QVAOhpBnAK8v7fvl2XQ
         cYPufPtXRkP6dO4RaZkGP1LQD/qQAKwRbevEooHlWHIXxiDg95PDjqEItOKN0fmUTE
         LKZ3sEzlNb7Og==
Date:   Sun, 18 Apr 2021 15:06:21 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Andrea Claudi <aclaudi@redhat.com>
Cc:     linux-netdev <netdev@vger.kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH iproute2] rdma: stat: initialize ret in
 stat_qp_show_parse_cb()
Message-ID: <YHwgvbu392PVbQOh@unreal>
References: <2b6d2d8c4fdcf53baea43c9fbe9f929d99257809.1618350667.git.aclaudi@redhat.com>
 <YHwS2pu/oSdC4qFt@unreal>
 <CAPpH65yk95Yg7wZiNLSebNJ8=hDPff7ixNzxuXzu0yjXYu=gCA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPpH65yk95Yg7wZiNLSebNJ8=hDPff7ixNzxuXzu0yjXYu=gCA@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 18, 2021 at 02:00:38PM +0200, Andrea Claudi wrote:
> On Sun, Apr 18, 2021 at 1:07 PM Leon Romanovsky <leon@kernel.org> wrote:
> >
> > On Wed, Apr 14, 2021 at 12:50:57AM +0200, Andrea Claudi wrote:
> > > In the unlikely case in which the mnl_attr_for_each_nested() cycle is
> > > not executed, this function return an uninitialized value.
> > >
> > > Fix this initializing ret to 0.
> > >
> > > Fixes: 5937552b42e4 ("rdma: Add "stat qp show" support")
> > > Signed-off-by: Andrea Claudi <aclaudi@redhat.com>
> > > ---
> > >  rdma/stat.c | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > >
> > > diff --git a/rdma/stat.c b/rdma/stat.c
> > > index 75d45288..3abedae7 100644
> > > --- a/rdma/stat.c
> > > +++ b/rdma/stat.c
> > > @@ -307,7 +307,7 @@ static int stat_qp_show_parse_cb(const struct nlmsghdr *nlh, void *data)
> > >       struct rd *rd = data;
> > >       const char *name;
> > >       uint32_t idx;
> > > -     int ret;
> > > +     int ret = 0;
> >
> > It should be MNL_CB_OK which is 1 and not 0.
> >
> > Thanks.
> >
> 
> Hi Leon, and thanks for pointing this out.
> As this is already merged, I'll submit a fix.

Thanks

> 
> Regards,
> Andrea
> 
> > >
> > >       mnl_attr_parse(nlh, 0, rd_attr_cb, tb);
> > >       if (!tb[RDMA_NLDEV_ATTR_DEV_INDEX] || !tb[RDMA_NLDEV_ATTR_DEV_NAME] ||
> > > --
> > > 2.30.2
> > >
> >
> 

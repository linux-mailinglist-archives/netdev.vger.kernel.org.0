Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5F46417E05
	for <lists+netdev@lfdr.de>; Sat, 25 Sep 2021 01:04:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345943AbhIXXGF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Sep 2021 19:06:05 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:58879 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1344410AbhIXXGE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Sep 2021 19:06:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632524670;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=bTc7D1V5/zHmNFQQf2SGo7g6Y36OPZMfARi2U8LVPnw=;
        b=RD01odDp/m/xa8oWzFIE8spnVR5FtzGNUMdz1CXJXx4lECoIz2m2/Jt4Bx+mLz1MTCx9eA
        DcUPMOSq+yd6kX1MPXEfZwNsUYMtJ4ljuCZasYPvcYvBzMfoSwJn2iE2EAa1gAS2ufEyxF
        OOACBmgJrx9Elf4q8oFjrgxmhPilwyE=
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com
 [209.85.166.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-402-wpVBRwzdPj2xU3z1U_bjcQ-1; Fri, 24 Sep 2021 19:04:29 -0400
X-MC-Unique: wpVBRwzdPj2xU3z1U_bjcQ-1
Received: by mail-il1-f197.google.com with SMTP id y16-20020a929510000000b0024fca7e125bso11560130ilh.17
        for <netdev@vger.kernel.org>; Fri, 24 Sep 2021 16:04:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:references:mime-version:in-reply-to:date
         :message-id:subject:to:cc;
        bh=bTc7D1V5/zHmNFQQf2SGo7g6Y36OPZMfARi2U8LVPnw=;
        b=CYICkzJubkirG4EDdZhOLuW9MU6wkGYp7sfoVsnb92O0xRn0EO+p7ACRWMS4+BHeTq
         ITgiFa4MTSNz0n7rvG5uWJhGeTh6kbQa6ug0p/D7tqozznlNfZiyRN9L0oCaT2CIEno9
         tIgYWLuXnlBa/BNpZh+8bqNlmd2Q4LHWPfS4kpB5PmfBaH6eh0lS7veqW2peVpJL+51P
         Rjp68nlP4B2Ry6MjbXKXxLK7MPDScW6+1q/6T1dxB8FyHJtbABXaiFQHC2VIYs40SjPw
         G1eSvaDwja8FywoemBouVs0/4FTxgH1UPplFieFDGdbYuuorKvVTiZyvdRU3R+hDF42Y
         b+qQ==
X-Gm-Message-State: AOAM530T4wNknXAB8JaDnArYR1w1XeJu7tEZ9yPpoDbZGWdocYkTsga7
        GWfpa4cySj2/tdxPu71A4srqgCgYAxtNA+xuoVhHjbuRsPnMxO5XZE0v9x11qlR1pmHHqzbu5UD
        e4vduh3fi34vZoGX7Y6RPYf/tWA8v6/0Y
X-Received: by 2002:a05:6e02:1588:: with SMTP id m8mr10589645ilu.188.1632524668497;
        Fri, 24 Sep 2021 16:04:28 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxMyYwvDxHsXW0NbKFokZmiUzsJ0+JI14qS1D91GME7UrEkkMNr0dNfkC/bSbOuX6byR/80hEKMSZMcdv+2c7s=
X-Received: by 2002:a05:6e02:1588:: with SMTP id m8mr10589634ilu.188.1632524668282;
 Fri, 24 Sep 2021 16:04:28 -0700 (PDT)
Received: from 868169051519 named unknown by gmailapi.google.com with
 HTTPREST; Fri, 24 Sep 2021 16:04:27 -0700
From:   mleitner@redhat.com
References: <cover.1632133123.git.lucien.xin@gmail.com> <13c7b29126171310739195264d5e619b62d27f92.1632133123.git.lucien.xin@gmail.com>
 <CAM_iQpW53DGw5bXNXot4kV3qSHf5wgD33AFU3=zz0b69mJwNkw@mail.gmail.com>
 <CADvbK_dSw=H-pVK26tMwpdfkjd3dKGcCrATaRvXqzRwJFoKoyg@mail.gmail.com>
 <CAM_iQpULkRxRjMBWKn+7V51PZXLWW17iQBLr1N5vdJmFVZtJ4A@mail.gmail.com> <CADvbK_dFyVdt3dU57_8=6eYH+bz3_M81=V4B_5sNd+kpXbnUHA@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CADvbK_dFyVdt3dU57_8=6eYH+bz3_M81=V4B_5sNd+kpXbnUHA@mail.gmail.com>
Date:   Fri, 24 Sep 2021 16:04:27 -0700
Message-ID: <CALnP8Za-nJHrVwd9dtzsvABEWH=bZaarEwUeOme9Pfu7iKJzsg@mail.gmail.com>
Subject: Re: [PATCH net 1/2] net: sched: drop ct for the packets toward
 ingress only in act_mirred
To:     Xin Long <lucien.xin@gmail.com>
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        network dev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Davide Caratti <dcaratti@redhat.com>,
        Hangbin Liu <liuhangbin@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Jamal Hadi Salim <jhs@mojatatu.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 22, 2021 at 01:17:05PM +0800, Xin Long wrote:
> On Wed, Sep 22, 2021 at 11:43 AM Cong Wang <xiyou.wangcong@gmail.com> wrote:
> >
> > On Tue, Sep 21, 2021 at 12:02 AM Xin Long <lucien.xin@gmail.com> wrote:
> > >
> > > On Tue, Sep 21, 2021 at 2:31 AM Cong Wang <xiyou.wangcong@gmail.com> wrote:
> > > >
> > > > On Mon, Sep 20, 2021 at 7:12 AM Xin Long <lucien.xin@gmail.com> wrote:
> > > > >
> > > > > nf_reset_ct() called in tcf_mirred_act() is supposed to drop ct for
> > > > > those packets that are mirred or redirected to only ingress, not
> > > > > ingress and egress.
> > > >
> > > > Any reason behind this? I think we at least need to reset it when
> > > > redirecting from ingress to egress as well? That is, when changing
> > > > directions?
> > > For the reason why ct should be reset, it's said in
> > > d09c548dbf3b ("net: sched: act_mirred: Reset ct info when mirror").
> > > The user case is OVS HWOL using TC to do NAT and then redirecting
> > > the NATed skb back to the ingress of one local dev, it's ingress only, this
> > > patch is more like to minimize the side effect of d09c548dbf3b IF there is.
> >
> > What is the side effect here? Or what is wrong with resetting CT on
> > egress side?
> >
> > >
> > > Not sure if it's too much to do for that from ingress to egress.
> > > What I was thinking is this should happen on rx path(ingress), like it
> > > does in internal_dev_recv() in the OVS kernel module. But IF there is
> > > any user case needing doing this for ingress to egress, I would add it.
> >
> > If that is the case, then this patch is completely unnecessary. So
> > instead of going back and forth, please elaborate on why resetting
> > CT for egress is a problem here.
> What I'm afraid is: after resetting CT for the packets redirected to egress,
> the tc rules on the next dev egress that may need these CT will break.

This shouldn't happen. Well, it's not expected from OVS use case POV,
and that would probably be a nightmare to maintain (without something
like OVS), considering packets can be directed to egress from multiple
places and they would have different starting points then.

>
> I can't give a use case right now, and just don't want to introduce extra
> change for which we don't see a use. If you think that's safe, I'm fine
> to do these resets when the direction is changed.

I don't see why it wouldn't be safe.


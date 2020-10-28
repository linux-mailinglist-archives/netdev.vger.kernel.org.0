Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63BD329D394
	for <lists+netdev@lfdr.de>; Wed, 28 Oct 2020 22:45:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727253AbgJ1VpS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 17:45:18 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:34676 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727213AbgJ1VpN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Oct 2020 17:45:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603921510;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=u8Htvo3YIiBwLh8op/Sco1MP/wlQE26q3zWGX/vjziY=;
        b=C6oUZI7WpJNp8DohsnvptSlPcVBNLZhCK7hzbE7jhlpL/XRGOA4Ez21IqUrby+XSQZ4B1p
        qFDhruJvp3zuc8QWniCzphMGIGOOdXZOZzwnplUF4XlykguhK4fZucgDUfvFFtFxAJw40E
        UIwyLo3OxP9w6sJqM/ec/6ZFO9+G7/I=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-437-Xw7JhZxPN2uvsXJ4VdILEQ-1; Wed, 28 Oct 2020 17:45:08 -0400
X-MC-Unique: Xw7JhZxPN2uvsXJ4VdILEQ-1
Received: by mail-wr1-f72.google.com with SMTP id t17so378950wrm.13
        for <netdev@vger.kernel.org>; Wed, 28 Oct 2020 14:45:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=u8Htvo3YIiBwLh8op/Sco1MP/wlQE26q3zWGX/vjziY=;
        b=uHEswDolRCIDdiJwn4i0e6GM9ckV1m6NTFNutcOAPZ9ljp8t9DyeF0LMzoRb8L45bu
         0hTZIeOA2fqEaKkBYJrDV2x2KN7m1IOhqKH3la/HrcAHmrD868D0hGDudz1v8nIUiDA6
         0r/fYSflVatiLMGJIgQ5aJXzQu2S8Equd8+EZLRo2i0Ymc2Pcnx77UGDjWHpyshhrraP
         LjsMwsjHSQT8hKj0sPPQZz2Txkw80oChzfxSNSf6iw+8ecU1lp6aZ8Xkwud+11TNe1OP
         nI8etE7b5JXe9qFaYkZA+xSmCFeDpp2XfXWqQFuYPuj8FspYUVyGzsfi5pXsblVMC5ap
         k3Aw==
X-Gm-Message-State: AOAM531a1OPewSwBOO/m/0GA6rrO5I4A0K8Q3xpOq9SnYFNJ+HLkmCtH
        olxyKO6sihVBuIibZoO0qt3xnuUXtE0d5UNQPsHCBV7QCz7/sl9O4P/BkhRpuzzeemLp4hKaMxB
        qmtnzSleaVExenI8e
X-Received: by 2002:a5d:490c:: with SMTP id x12mr1503247wrq.193.1603921507302;
        Wed, 28 Oct 2020 14:45:07 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz0OLxAxxDhObR9XJI3ds7AIFInheYhz1v1d4ODMS/0TcBnbpW+prNSyR4QMmuuwRpuhQiwXA==
X-Received: by 2002:a5d:490c:: with SMTP id x12mr1503220wrq.193.1603921507090;
        Wed, 28 Oct 2020 14:45:07 -0700 (PDT)
Received: from pc-2.home (2a01cb058d4f8400c9f0d639f7c74c26.ipv6.abo.wanadoo.fr. [2a01:cb05:8d4f:8400:c9f0:d639:f7c7:4c26])
        by smtp.gmail.com with ESMTPSA id 66sm1091660wmb.3.2020.10.28.14.45.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2020 14:45:06 -0700 (PDT)
Date:   Wed, 28 Oct 2020 22:45:04 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Alexander Ovechkin <ovov@yandex-team.ru>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH v2 net] net/sched: act_mpls: Add softdep on mpls_gso.ko
Message-ID: <20201028214504.GB26626@pc-2.home>
References: <1f6cab15bbd15666795061c55563aaf6a386e90e.1603708007.git.gnault@redhat.com>
 <CAM_iQpVBpdJyzfexy8Vnxqa7wH0MhcxkatzQhdOtrskg=dva+A@mail.gmail.com>
 <20201027213951.GA13892@pc-2.home>
 <CAM_iQpWX3xw2uQbVsMNwEBhnKoKGoQgPYpws1Bvpe5M5rWrExQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAM_iQpWX3xw2uQbVsMNwEBhnKoKGoQgPYpws1Bvpe5M5rWrExQ@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 28, 2020 at 12:35:17PM -0700, Cong Wang wrote:
> On Tue, Oct 27, 2020 at 2:39 PM Guillaume Nault <gnault@redhat.com> wrote:
> >
> > On Tue, Oct 27, 2020 at 10:28:29AM -0700, Cong Wang wrote:
> > > On Mon, Oct 26, 2020 at 4:23 AM Guillaume Nault <gnault@redhat.com> wrote:
> > > >
> > > > TCA_MPLS_ACT_PUSH and TCA_MPLS_ACT_MAC_PUSH might be used on gso
> > > > packets. Such packets will thus require mpls_gso.ko for segmentation.
> > >
> > > Any reason not to call request_module() at run time?
> >
> > So that mpls_gso would be loaded only when initialising the
> > TCA_MPLS_ACT_PUSH or TCA_MPLS_ACT_MAC_PUSH modes?
> 
> Yes, exactly.
> 
> >
> > That could be done, but the dependency on mpls_gso wouldn't be visible
> > anymore with modinfo. I don't really mind, I just felt that such
> > information could be important for the end user.
> 
> I think the dependency is determined at run time based on
> TCA_MPLS_ACT_*, so it should be reflected at run time, rather than at
> compile time.
> 
> If loading mpls_gso even when not needed is not a big deal, I am fine
> with your patch too.

Loading mpls_gso looks harmless. It just registers GSO handlers for
ETH_P_MPLS_UC and for ETH_P_MPLS_MC with a low priority.

Since we're not adding a build dependency on mpls_gso for act_mpls, I
have a slight preference for having the soft dependency being reported
by modinfo. This gives a chance to the user to figure out that mpls_gso
can be necessary.

> Thanks.
> 


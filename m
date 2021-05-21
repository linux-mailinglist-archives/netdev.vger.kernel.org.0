Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A110B38C8FC
	for <lists+netdev@lfdr.de>; Fri, 21 May 2021 16:11:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236409AbhEUONO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 May 2021 10:13:14 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:21931 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232170AbhEUONN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 May 2021 10:13:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621606310;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/sIniHPgX0OinMpT0h6MW3GPXOPxD+HoJCloRvl/D6A=;
        b=QOPcil6R3okJO8AN7t/BsmkEf+QWzprgQ90dIU6nnWCv0KHErevPaxpQt/f4GqTSejDpif
        JicdUNcm+g+QJD+rjEvqz89wNvcZuhoTfD+4CnkyPXNHth7igz+mP46oEGoJzNSAWI4k63
        yCkrMRLiDHKB1UTT1xxMRFyfq/T4vlk=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-263-UQB_ni5YPECkSvHnmi4xDg-1; Fri, 21 May 2021 10:11:48 -0400
X-MC-Unique: UQB_ni5YPECkSvHnmi4xDg-1
Received: by mail-ed1-f72.google.com with SMTP id w1-20020aa7da410000b029038d323eeee3so9388519eds.8
        for <netdev@vger.kernel.org>; Fri, 21 May 2021 07:11:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=/sIniHPgX0OinMpT0h6MW3GPXOPxD+HoJCloRvl/D6A=;
        b=CxRmi0td36E4Izd27M9b21jLTjmPIemcLS7O+2CsuJdYIQ+oHUOkSVuDZb+barVG+j
         UWGHoryvajC3rT8dkWN8zq3iyl6eia+G8Yy4og9uB/QelZImQ5jDiW6HikSAOl+pyQFj
         TISF2oQjyTGuT+pgq9qqJLm027hRCWhFdEB15IZUdjMPisVNkQKfh99Z0+pudNXiPiWV
         NI1ovbspjPTYnZDVChEG4UFD6wFma2KwHJP4IBpGsATUFiklbTDd7EnEcL7a5SmvaCDz
         tiQPMz9iFMPyMr7KGp7nRaxIyneKBws59ARulTIM2sBJuJ2prEqffbih4MAaZaSqsZCU
         OCLQ==
X-Gm-Message-State: AOAM531d0BVjFq6SozqtdO37wWi9WT9lDmY0/TG6MEpDhF1XfuTcvjga
        DMTJnkakzd5rspIBE09sH+ZTRzsT+AkgutwWS7RJIABHoqrY2+SAlZuFy1TSVczgxOvOIFtrF6v
        EevWG5oB3pvPTRZjK
X-Received: by 2002:a17:906:d285:: with SMTP id ay5mr10452886ejb.418.1621606307019;
        Fri, 21 May 2021 07:11:47 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyjcYxSXDRBW5rnDNXOwX1PFkKRKI/B2rw6DULDKhjJ6hgVr/TDUYI5BZdwuyo53wfF8PRUzg==
X-Received: by 2002:a17:906:d285:: with SMTP id ay5mr10452866ejb.418.1621606306807;
        Fri, 21 May 2021 07:11:46 -0700 (PDT)
Received: from localhost.localdomain ([151.29.18.58])
        by smtp.gmail.com with ESMTPSA id b25sm4194694edv.9.2021.05.21.07.11.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 May 2021 07:11:45 -0700 (PDT)
Date:   Fri, 21 May 2021 16:11:43 +0200
From:   Juri Lelli <juri.lelli@redhat.com>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        davem@davemloft.net, netdev@vger.kernel.org,
        eric.dumazet@gmail.com, simon.horman@netronome.com,
        oss-drivers@netronome.com, Clark Williams <williams@redhat.com>
Subject: Re: [PATCH net-next 1/2] net: add a napi variant for RT-well-behaved
 drivers
Message-ID: <YKe/n7kVfVqZezTt@localhost.localdomain>
References: <20210514222402.295157-1-kuba@kernel.org>
 <20210515110740.lwt6wlw6wq73ifat@linutronix.de>
 <20210515133104.491fc691@kicinski-fedora-PC1C0HJN>
 <87cztr1zxz.ffs@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87cztr1zxz.ffs@nanos.tec.linutronix.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 15/05/21 22:53, Thomas Gleixner wrote:
> On Sat, May 15 2021 at 13:31, Jakub Kicinski wrote:
> > On Sat, 15 May 2021 13:07:40 +0200 Sebastian Andrzej Siewior wrote:
> >> Now assume another interrupt comes in which wakes a force-threaded
> >> handler (while ksoftirqd is preempted). Before the forced-threaded
> >> handler is invoked, BH is disabled via local_bh_disable(). Since
> >> ksoftirqd is preempted with BH disabled, disabling BH forces the
> >> ksoftirqd thread to the priority of the interrupt thread (SCHED_FIFO,
> >> prio 50 by default) due to the priority inheritance protocol. The
> >> threaded handler will run once ksoftirqd is done which has now been
> >> accelerated.
> >
> > Thanks for the explanation. I'm not married to the patch, if you prefer
> > we can keep the status quo.
> >
> > I'd think, however, that always deferring to ksoftirqd is conceptually
> > easier to comprehend. For power users who need networking there is
> > prefer-busy-poll (which allows application to ask the kernel to service
> > queues when it wants to, with some minimal poll frequency guarantees)
> > and threaded NAPI - which some RT users already started to adapt.
> >
> > Your call.
> >
> >> Part of the problem from RT perspective is the heavy use of softirq and
> >> the BH disabled regions which act as a BKL. I *think* having the network
> >> driver running in a thread would be better (in terms of prioritisation).
> >> I know, davem explained the benefits of NAPI/softirq when it comes to
> >> routing/forwarding (incl. NET_RX/TX priority) and part where NAPI kicks
> >> in during a heavy load (say a packet flood) and system is still
> >> responsible.
> >
> > Right, although with modern multi-core systems where only a subset 
> > of cores process network Rx things look different.
> 
> Bah, I completely forgot about that aspect. Thanks Sebastian for
> bringing it up. I was too focussed on the other questions and there is
> obviously the onset of alzheimer.
> 
> Anyway it's a touch choice to make. There are too many options to chose
> from nowadays. 10 years ago running the softirq at the back of the
> threaded irq handler which just scheduled NAPI was definitely a win, but
> with threaded NAPI, zero copy and other things it's not that important
> anymore IMO. But I might be missing something obviously.
> 
> I've cc'ed a few RT folks @RHT who might give some insight.

So, I asked around, but got mixed type of answers. My feeling is that an
opt-in approach, if feasible, might be useful to accomodate setups that
might indeed benefit from priority inheritance kicking in. In most cases
I'm aware of net handling is done by housekeeping cpus and isolated cpus
(running RT workload) mostly don't enter the kernel, but there are
exceptions to that.

I'll keep trying to ping more people. :)

Thanks,
Juri


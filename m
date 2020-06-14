Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 205581F87C7
	for <lists+netdev@lfdr.de>; Sun, 14 Jun 2020 10:55:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726856AbgFNIzp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Jun 2020 04:55:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726099AbgFNIzo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Jun 2020 04:55:44 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E81E6C03E96F
        for <netdev@vger.kernel.org>; Sun, 14 Jun 2020 01:55:42 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id x6so14001908wrm.13
        for <netdev@vger.kernel.org>; Sun, 14 Jun 2020 01:55:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dectris.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=llpwFJx7bM20R9a6/mhnv06HJ/te3x1vavOQOVX/2CQ=;
        b=S7dzRgrpCv/EKte3nuNXBUVvfSn6Nl5+56xXsIBrcFZDTH6ry7SkYeor2FuubMsuYY
         4mgvYdZm1Sq8pCyD5XWASNJDqsrY9l6aIueXdnoj+HjjZ6OTB40a0jigH72PgSqypvSa
         VckOVTMG2I+N2BVFHFIgtJc106U7SFL0UHTVs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=llpwFJx7bM20R9a6/mhnv06HJ/te3x1vavOQOVX/2CQ=;
        b=Y7r2lD6D5P2JB73uCkJGnQVhIj139TBUH4Dep6AITaz+FYHPsl4ADgpzBynshseMUr
         l1bwUdcfkfRAU4+vxt3cs5TNmQ2IggUF5KxvM+1PgojK8oUryefmUCejDR2b/HeQ41M+
         kifgVUM9z8Lnr5AKD3rBZBwnZB7i/3PDH41sPt8Sk8nYnewAXOC+f/bhDn7+PT2Zv1OZ
         WODqodAfSvfsGH86KnwlbrWOTGEW+crK/xJCrla8vJSPpHt7yASiMjNPROORCNs5VoRk
         KXcQ2Gw61CZU1B5bNlxzIe5CAz4L00RlsDQJnlQX/tDtwW3Q0uC+3fY9dLeLo8VG+CeB
         opzA==
X-Gm-Message-State: AOAM530eGeCISTTR3jrI7lq6IcLsI2A6yrLxnvg5onYDd6mmPDKPa+k3
        lBc3+0XG0qYtuDvVERR1850dAf5+xk6Y6Tft8E7yxg==
X-Google-Smtp-Source: ABdhPJyHz5Bhhj8GoMeDgXuhUhmcgBPzIWtD0lcvZ73CyDndfoVYYyIdA6vV0AaurwANQRaXjov6ypLV5gq6aCZtlxw=
X-Received: by 2002:a05:6000:1202:: with SMTP id e2mr22446338wrx.231.1592124941461;
 Sun, 14 Jun 2020 01:55:41 -0700 (PDT)
MIME-Version: 1.0
References: <CAHApi-mMi2jYAOCrGhpkRVybz0sDpOSkLFCZfVe-2wOcAO_MqQ@mail.gmail.com>
 <CAHApi-=YSo=sOTkRxmY=fct3TePFFdG9oPTRHWYd1AXjk0ACfw@mail.gmail.com>
 <20190902110818.2f6a8894@carbon> <fd3ee317865e9743305c0e88e31f27a2d51a0575.camel@mellanox.com>
In-Reply-To: <fd3ee317865e9743305c0e88e31f27a2d51a0575.camel@mellanox.com>
From:   Kal Cutter Conley <kal.conley@dectris.com>
Date:   Sun, 14 Jun 2020 10:55:30 +0200
Message-ID: <CAHApi-k=9Szxm0QMD4N4PW9Lq8L4hW6e7VfyBePzrTgvKGRs5Q@mail.gmail.com>
Subject: Re: net/mlx5e: bind() always returns EINVAL with XDP_ZEROCOPY
To:     Saeed Mahameed <saeedm@mellanox.com>
Cc:     "brouer@redhat.com" <brouer@redhat.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        "magnus.karlsson@intel.com" <magnus.karlsson@intel.com>,
        "toke.hoiland-jorgensen@kau.se" <toke.hoiland-jorgensen@kau.se>,
        "xdp-newbies@vger.kernel.org" <xdp-newbies@vger.kernel.org>,
        Tariq Toukan <tariqt@mellanox.com>,
        "gospo@broadcom.com" <gospo@broadcom.com>,
        "jakub.kicinski@netronome.com" <jakub.kicinski@netronome.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bjorn.topel@intel.com" <bjorn.topel@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Saeed,
Thanks for explaining the reasoning behind the special mlx5 queue
numbering with XDP zerocopy.

We have a process using AF_XDP that also shares the network interface
with other processes on the system. ethtool rx flow classification
rules are used to route the traffic to the appropriate XSK queue
N..(2N-1). The issue is these queues are only valid as long they are
active (as far as I can tell). This means if my AF_XDP process dies
other processes no longer receive ingress traffic routed over queues
N..(2N-1) even though my XDP program is still loaded and would happily
always return XDP_PASS. Other drivers do not have this usability issue
because they use queues that are always valid. Is there a simple
workaround for this issue? It seems to me queues N..(2N-1) should
simply map to 0..(N-1) when they are not active?

Kal


On Tue, Sep 3, 2019 at 10:19 PM Saeed Mahameed <saeedm@mellanox.com> wrote:
>
> On Mon, 2019-09-02 at 11:08 +0200, Jesper Dangaard Brouer wrote:
> > On Sun, 1 Sep 2019 18:47:15 +0200
> > Kal Cutter Conley <kal.conley@dectris.com> wrote:
> >
> > > Hi,
> > > I figured out the problem. Let me document the issue here for
> > > others
> > > and hopefully start a discussion.
> > >
> > > The mlx5 driver uses special queue ids for ZC. If N is the number
> > > of
> > > configured queues, then for XDP_ZEROCOPY the queue ids start at N.
> > > So
> > > queue ids [0..N) can only be used with XDP_COPY and queue ids
> > > [N..2N)
> > > can only be used with XDP_ZEROCOPY.
> >
> > Thanks for the followup and explanation on how mlx5 AF_XDP queue
> > implementation is different from other vendors.
> >
> >
> > > sudo ethtool -L eth0 combined 16
> > > sudo samples/bpf/xdpsock -r -i eth0 -c -q 0   # OK
> > > sudo samples/bpf/xdpsock -r -i eth0 -z -q 0   # ERROR
> > > sudo samples/bpf/xdpsock -r -i eth0 -c -q 16  # ERROR
> > > sudo samples/bpf/xdpsock -r -i eth0 -z -q 16  # OK
> > >
> > > Why was this done? To use zerocopy if available and fallback on
> > > copy
> > > mode normally you would set sxdp_flags=0. However, here this is no
> > > longer possible. To support this driver, you have to first try
> > > binding
> > > with XDP_ZEROCOPY and the special queue id, then if that fails, you
> > > have to try binding again with a normal queue id. Peculiarities
> > > like
> > > this complicate the XDP user api. Maybe someone can explain the
> > > benefits?
> >
>
> in mlx5 we like to keep full functional separation between different
> queues. Unlike other implementations in mlx5 kernel standard rx rings
> can still function while xsk queues are opened. from user perspective
> this should be very simple and very usefull:
>
> queues 0..(N-1): can't be used for XSK ZC since they are standard RX
> queues managed by kernel  and driver
> queues N..(2N-1): Are XSK user app managed queues, they can't be used
> for anything else.
>
> benefits:
> - RSS is not interrupted, Ongoing traffic and Current RX queues keeps
> going normally when XSK apps are activated/deactivated on the fly.
> - Well-defined full logical separation between different types of RX
> queue.
>
> as Jesper explained we understand the confusion, and we will come up
> with a solution the fits all vendors.
>
> > Thanks for complaining, it is actually valuable. It really illustrate
> > the kernel need to improve in this area, which is what our talk[1] at
> > LPC2019 (Sep 10) is about.
> >
> > Title: "Making Networking Queues a First Class Citizen in the Kernel"
> >  [1] https://linuxplumbersconf.org/event/4/contributions/462/
> >
> > As you can see, several vendors are actually involved. Kudos to
> > Magnus
> > for taking initiative here!  It's unfortunately not solved
> > "tomorrow",
> > as first we have to agree this is needed (facility to register
> > queues),
> > then agree on API and get commitment from vendors, as this requires
> > drivers changes.  There is a long road ahead, but I think it will be
> > worthwhile in the end, as effective use of dedicated hardware queues
> > (both RX and TX) is key to performance.
> >

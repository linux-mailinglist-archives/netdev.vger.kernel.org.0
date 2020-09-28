Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 344ED27AFF3
	for <lists+netdev@lfdr.de>; Mon, 28 Sep 2020 16:25:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726565AbgI1OZN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 10:25:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726415AbgI1OZN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Sep 2020 10:25:13 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 692F4C061755
        for <netdev@vger.kernel.org>; Mon, 28 Sep 2020 07:25:13 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id f18so1168754pfa.10
        for <netdev@vger.kernel.org>; Mon, 28 Sep 2020 07:25:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tDhN3xV44RCE7Dj4T3eeSZTK/zwG09b1fRpQxWI1gVM=;
        b=EoyRIhiofrFN0OjeDMUjkL6sSkjhQGBCQQImLAwt341o/3dWfVIcE+m8VgCdh1vISm
         y71V3ctPBMRoe4fdu3en6lPFtiU+NJBBGcluUXY6ENr5YymS9m5TxBzVIE0KSFpz8bJp
         IpN04rxvBUghnamEp337c5IO7i0EPqZq75NvQs/DvvETLlOmPmC0Y+oc5CNUBbHAb5Ur
         zFLK1rM72vcjQfTg4zNgtGgV6hE+Md6Xizm2ln7C17Z65Yx0VcYW1ruf8YywLTknKlhU
         YTg1nXl3GG99VvX37b0EqAR2uoIxgfU8yIxv9OaxZb/3aeauqsr16hKs9I01fGOCseue
         sVwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tDhN3xV44RCE7Dj4T3eeSZTK/zwG09b1fRpQxWI1gVM=;
        b=UDiYwHHYgFDQgQERvGbu5wjyBYdUwEPt2gdl0rGrS2XFHapxrG5wuO/YojvkSGnn9g
         nNa7YBqoRbZrR2JkHTV11gsHA5jP9pTeZCyl3PqxTIy5Iq6qW6w+4wI4wYsI5AtyoaHh
         bNKSYuBs6wBzdXF738sTD10qApLzdw8ILCFkDpqHI86OpEi0AS66jsl47hPQM9PudRKH
         XAjAX8U4NG/fSxT/9yBLRqCb7RGDX+/k4IUe4SWoNuLX/3VicQ6DyHfrRBe4J7e65CEd
         kEXYJL70eeFZTvFqdpIFecf8zKy5tbiSl7JZ2roKd26SHUJM4qEmcC+8txV0xzLi5Ckk
         NycQ==
X-Gm-Message-State: AOAM531HJH5/tnLelfw+JdG7aRP9hV0qd4Xy5wwYhW7k7VOfBQPA9IrM
        50S76rXuvRl+cyPD7ErF99KZRQ640VJpalZ2V58=
X-Google-Smtp-Source: ABdhPJw5fy8536+em3rTurMI5fwX8dMfMDnui0NUjGklnI3csmWX+k69Tmgk6+A0IO4bQfn/8VziulWsVeqjwoCGJuY=
X-Received: by 2002:a17:902:309:b029:d1:e5e7:ca3f with SMTP id
 9-20020a1709020309b02900d1e5e7ca3fmr1888140pld.43.1601303112912; Mon, 28 Sep
 2020 07:25:12 -0700 (PDT)
MIME-Version: 1.0
References: <20200226005744.1623-1-dsahern@kernel.org> <23fe48b6-71d1-55a3-e0e8-ca4b3fac1f7f@redhat.com>
 <9a5391fb-1d80-43d1-5e88-902738cc2528@gmail.com> <87wo89zroe.fsf@toke.dk>
 <20200226032204-mutt-send-email-mst@kernel.org> <87r1yhzqz8.fsf@toke.dk>
 <0dc879c5-12ce-0df2-24b0-97d105547150@digitalocean.com> <87wo88wcwi.fsf@toke.dk>
 <CAJ8uoz2++_D_XFwUjFri0HmNaNWKtiPNrJr=Fvc8grj-8hRzfg@mail.gmail.com> <b6609e0a-eb2f-78bd-b565-c56dce9e2e48@gmail.com>
In-Reply-To: <b6609e0a-eb2f-78bd-b565-c56dce9e2e48@gmail.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Mon, 28 Sep 2020 16:25:01 +0200
Message-ID: <CAJ8uoz2bj0YWH5K6OW8m+BC06QZTSYW=xbApuEDK5pRCx+RLAA@mail.gmail.com>
Subject: Re: [PATCH RFC net-next] virtio_net: Relax queue requirement for
 using XDP
To:     David Ahern <dsahern@gmail.com>
Cc:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        David Ahern <dahern@digitalocean.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        David Ahern <dsahern@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 28, 2020 at 5:13 AM David Ahern <dsahern@gmail.com> wrote:
>
> On 2/27/20 2:41 AM, Magnus Karlsson wrote:
> > I will unfortunately be after Netdevconf due to other commitments. The
> > plan is to send out the RFC to the co-authors of the Plumbers
> > presentation first, just to check the sanity of it. And after that
> > send it to the mailing list. Note that I have taken two shortcuts in
> > the RFC to be able to make quicker progress. The first on is the
> > driver implementation of the dynamic queue allocation and
> > de-allocation. It just does this within a statically pre-allocated set
> > of queues. The second is that the user space interface is just a
> > setsockopt instead of a rtnetlink interface. Again, just to save some
> > time in this initial phase. The information communicated in the
> > interface is the same though. In the current code, the queue manager
> > can handle the queues of the networking stack, the XDP_TX queues and
> > queues allocated by user space and used for AF_XDP. Other uses from
> > user space is not covered due to my setsockopt shortcut. Hopefully
> > though, this should be enough for an initial assessment.
>
> Any updates on the RFC? I do not recall seeing a patch set on the
> mailing list, but maybe I missed it.

No, you have unfortunately not missed anything. It has been lying on
the shelf collecting dust for most of this time. The reason was that
the driver changes needed to support dynamic queue allocation just
became too complex as it would require major surgery to at least all
Intel drivers, and probably a large number of other ones as well. Do
not think any vendor would support such a high effort solution and I
could not (at that time at least) find a way around it. So, gaining
visibility into what queues have been allocated (by all entities in
the kernel that uses queue) seems to be rather straightforward, but
the dynamic allocation part seems to be anything but.

I also wonder how useful this queue manager proposal would be in light
of Mellanox's subfunction proposal. If people just start to create
many small netdevs (albeit at high cost which people may argue
against) consisting of just an rx/tx queue pair, then the queue
manager dynamic allocation proposal would not be as useful. We could
just use one of these netdevs to bind to in the AF_XDP case and always
just specify queue 0. But one can argue that queue management is
needed even for the subfunction approach, but then it would be at a
much lower level than what I proposed. What is your take on this?
Still worth pursuing in some form or another? If yes, then we really
need to come up with an easy way of supporting this in current
drivers. It is not going to fly otherwise, IMHO.

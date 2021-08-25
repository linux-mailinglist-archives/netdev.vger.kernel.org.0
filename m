Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 601B23F74A8
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 13:59:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240510AbhHYMAa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 08:00:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238434AbhHYMA0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Aug 2021 08:00:26 -0400
Received: from mail-oi1-x22e.google.com (mail-oi1-x22e.google.com [IPv6:2607:f8b0:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 839E9C061757;
        Wed, 25 Aug 2021 04:59:40 -0700 (PDT)
Received: by mail-oi1-x22e.google.com with SMTP id c79so366337oib.11;
        Wed, 25 Aug 2021 04:59:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xXGfHXHkacFj3hVjAUMIKLTRt2NjWIABsXsOJbwv1xg=;
        b=m5g4kNz6Al26gevow/MoVyW3uh9WKyVcZ6nXsCyOM63pHloaWtfHOitbj/ddMrII8Z
         BH49fwETN3J0KAb4hyOK0V61UNkUU2zIVZe6WA+2JSjp22qH3I87Pi0RfRHRg87dRtL2
         2yJHVjk+aEHHpS8j0ezFb9h09F4LiRFrIX8PAYXS4uZhoeO+z5njZFyjX/YG0NM2KiJ+
         g3WH1FSmp6OShKNgatAM1fKdH+1UYaYmJQncijEoM9sMkO+DIcdiW9c4+ACYWNjEacYr
         KDFZqlmg5O/9TGY0QYOtJ2CayVIQoHpJRsrgN+nIWFza6f5Mo05MtRlbwiKuH7MTDQY4
         LJUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xXGfHXHkacFj3hVjAUMIKLTRt2NjWIABsXsOJbwv1xg=;
        b=Ztc0609xIWnsAt2Brcra685MN4z+0AR0zjl/DfoXtJKyWgBghRmS1QTvF4JWKZJpJ6
         H7xsCV9QiKGb9GlSqvvAHk7h9XFTAbpBUtl6DRlR7hgSYKzn+riPDfTxF3qJh7nCMT7F
         7OKTf8IvIsnjq5/uItDSY4HNx/4u2hFPuFYgEqibAGPDLqwpul/p5XJPX8tvDPtPv98R
         ZirxnVQ9eUGG2vv65WA3AD8R9utuOfo6anzu1nF9f2mX7Nban5BAFBTJQh5t3/E9FHxs
         bxICaqi77go36bM4FegbGx0Rvr4L+szwGYv4NbkF5QsBHWJvjeCiPb0IMoPLWPXmFfCs
         KVvg==
X-Gm-Message-State: AOAM533/L2/w+33Y2bzB2MUSmLc9w9WLttJxRE+MMMAgRfjwhSNnG6Fd
        CyYHwuOq4ZuwrnaXClgU2tFE03MEndomklPZLec=
X-Google-Smtp-Source: ABdhPJzWL+J6f3VWAKw/V+b1F/vnLPMT3Ack2d5dRdJjoa09Q2zMLn5qgMA6S2GCDl0lDpXLguAgSB22yJrbmwObfoA=
X-Received: by 2002:aca:c2c6:: with SMTP id s189mr6426351oif.123.1629892779899;
 Wed, 25 Aug 2021 04:59:39 -0700 (PDT)
MIME-Version: 1.0
References: <20210824104918.7930-1-kerneljasonxing@gmail.com>
 <59dff551-2d52-5ecc-14ac-4a6ada5b1275@redhat.com> <CAL+tcoDERDZqtjK1BCc0vYYwYtvgRtb8H6z2FTVbGqr+N7bVmA@mail.gmail.com>
 <20210824153225.GA16546@ranger.igk.intel.com>
In-Reply-To: <20210824153225.GA16546@ranger.igk.intel.com>
From:   Jason Xing <kerneljasonxing@gmail.com>
Date:   Wed, 25 Aug 2021 19:59:03 +0800
Message-ID: <CAL+tcoDUhZfy3NTx4TOv3wa1f8SMkNhzNpVS5qyySaVOm6L-qQ@mail.gmail.com>
Subject: Re: [PATCH] ixgbe: let the xdpdrv work with more than 64 cpus
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc:     Jesper Dangaard Brouer <jbrouer@redhat.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        David Miller <davem@davemloft.net>, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, hawk@kernel.org,
        john.fastabend@gmail.com, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, kpsingh@kernel.org,
        brouer@redhat.com, intel-wired-lan@lists.osuosl.org,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, bpf@vger.kernel.org,
        Jason Xing <xingwanli@kuaishou.com>,
        Shujin Li <lishujin@kuaishou.com>,
        =?UTF-8?B?w43DsWlnbyBIdWd1ZXQ=?= <ihuguet@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 24, 2021 at 11:48 PM Maciej Fijalkowski
<maciej.fijalkowski@intel.com> wrote:
>
> On Tue, Aug 24, 2021 at 11:23:29PM +0800, Jason Xing wrote:
> > On Tue, Aug 24, 2021 at 9:32 PM Jesper Dangaard Brouer
> > <jbrouer@redhat.com> wrote:
> > >
> > >
> > >
> > > On 24/08/2021 12.49, kerneljasonxing@gmail.com wrote:
> > > > From: Jason Xing <xingwanli@kuaishou.com>
> > > >
> > > > Originally, ixgbe driver doesn't allow the mounting of xdpdrv if the
> > > > server is equipped with more than 64 cpus online. So it turns out that
> > > > the loading of xdpdrv causes the "NOMEM" failure.
> > > >
> > > > Actually, we can adjust the algorithm and then make it work, which has
> > > > no harm at all, only if we set the maxmium number of xdp queues.
> > >
> > > This is not true, it can cause harm, because XDP transmission queues are
> > > used without locking. See drivers ndo_xdp_xmit function ixgbe_xdp_xmit().
> > > As driver assumption is that each CPU have its own XDP TX-queue.
>
> Thanks Jesper for chiming in.
>
> > >
> >
> > Point taken. I indeed miss that part which would cause bad behavior if it
> > happens.
> >
> > At this point, I think I should find all the allocation and use of XDP
> > related, say,
> > queues and rings, then adjust them all?
> >
> > Let's say if the server is shipped with 128 cpus, we could map 128 cpus to 64
> > rings in the function ixgbe_xdp_xmit(). However, it sounds a little bit odd.
> >
> > Do you think that it makes any sense?
>
> We need a fallback path for ixgbe. I did the following for ice:
> https://x-lore.kernel.org/bpf/20210819120004.34392-9-maciej.fijalkowski@intel.com/T/#u
>

Thanks. I'm ready to send the v2 patch. Please help me review the next
submission.

Jason

> >
> > Thanks,
> > Jason
> >
> > > This patch is not a proper fix.
> > >
> > > I do think we need a proper fix for this issue on ixgbe.
> > >
> > >
> > > > Fixes: 33fdc82f08 ("ixgbe: add support for XDP_TX action")
> > > > Co-developed-by: Shujin Li <lishujin@kuaishou.com>
> > > > Signed-off-by: Shujin Li <lishujin@kuaishou.com>
> > > > Signed-off-by: Jason Xing <xingwanli@kuaishou.com>
> > > > ---
> > > >   drivers/net/ethernet/intel/ixgbe/ixgbe_lib.c  | 2 +-
> > > >   drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 3 ---
> > > >   2 files changed, 1 insertion(+), 4 deletions(-)
> > > >
> > > > diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_lib.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_lib.c
> > > > index 0218f6c..5953996 100644
> > > > --- a/drivers/net/ethernet/intel/ixgbe/ixgbe_lib.c
> > > > +++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_lib.c
> > > > @@ -299,7 +299,7 @@ static void ixgbe_cache_ring_register(struct ixgbe_adapter *adapter)
> > > >
> > > >   static int ixgbe_xdp_queues(struct ixgbe_adapter *adapter)
> > > >   {
> > > > -     return adapter->xdp_prog ? nr_cpu_ids : 0;
> > > > +     return adapter->xdp_prog ? min_t(int, MAX_XDP_QUEUES, nr_cpu_ids) : 0;
> > > >   }
> > > >
> > > >   #define IXGBE_RSS_64Q_MASK  0x3F
> > > > diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
> > > > index 14aea40..b36d16b 100644
> > > > --- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
> > > > +++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
> > > > @@ -10130,9 +10130,6 @@ static int ixgbe_xdp_setup(struct net_device *dev, struct bpf_prog *prog)
> > > >                       return -EINVAL;
> > > >       }
> > > >
> > > > -     if (nr_cpu_ids > MAX_XDP_QUEUES)
> > > > -             return -ENOMEM;
> > > > -
> > > >       old_prog = xchg(&adapter->xdp_prog, prog);
> > > >       need_reset = (!!prog != !!old_prog);
> > > >
> > > >
> > >

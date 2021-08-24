Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 993723F6189
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 17:24:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238332AbhHXPYx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Aug 2021 11:24:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238305AbhHXPYu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Aug 2021 11:24:50 -0400
Received: from mail-ot1-x334.google.com (mail-ot1-x334.google.com [IPv6:2607:f8b0:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EE51C0613C1;
        Tue, 24 Aug 2021 08:24:06 -0700 (PDT)
Received: by mail-ot1-x334.google.com with SMTP id k12-20020a056830150c00b0051abe7f680bso41971327otp.1;
        Tue, 24 Aug 2021 08:24:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=oeGV5t/oJZwqNMB4jX1FuHm+Z0cA2twU4gN/nkkX+8A=;
        b=SFUT5QMnrpG848wlRzo/0AfLJVjur8Qo1T9Lz0HM4GJS+LOQcQzqpAD9b6x3yll444
         S473LxVNAIJyWwFOVIqr/HUgDkX+T0qgceS8A9m+NRiQ7gmDeIBaK+y1TQ3YtHVcMOQi
         mYAn1SmcAq20Nw74K6bPs+eWszTRocP5WfVWvmnl/VZNtSVA2ZOpYuaL//ZfRFihjjxU
         sbSX/QRZZWz0IaA3UY4SBPsOxKxhk3lgCiXSOn4e8wVz1NcqqSy0Z8OaU4/blrQ55iqe
         3BdBHw3Nyb4kDl5yLxPU+KmoNGeaHEY+29K3stzCDjOe7j3Gf/3IyKFCkSBpSf/p99Do
         9U1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=oeGV5t/oJZwqNMB4jX1FuHm+Z0cA2twU4gN/nkkX+8A=;
        b=eJ4cAznxudB6zsbO6pLS6jHlnRdP+for13cw0g95GwsCo2wITBRlTYt0xowKxo/Tnr
         cufZGhfs8o9F30whUReGbtuUIlwUvxcwN/YHOwI3DosTY141L6lBZOdQuBHCkKI9qpNy
         3kTRo6k1B2/5gBnG/7+TzKYXYiKQK0Plc1RJYBYDTk9kFo0X5eOuboc8vcYALWZS8sBP
         g/pd1+gBSdzAeyiVqdIR02fqUcR2lzYE0zJYvMPowD9BYWXt+eDheXdZC8YCywsoXDS8
         rQeEozvvR2nuGGdVGHcAX0N37DtTAbXmYo5rNwLsdr/PwBZhtOz1dJvMqcNjXeRY7uJu
         xpSQ==
X-Gm-Message-State: AOAM53013GAaUFKNi+nLc+qYg9/iLDHnikMfZ2Eh/xuQRm/5Our5Wayd
        5mEbQBNvmokkdGW6VBQALFTJqaQ5tnFliFSJ+eA=
X-Google-Smtp-Source: ABdhPJxJq0hfArntSLZ0Abf4D5GQ30roxEYoGaXVebZpbQrC3CJzfxuKFpUFpNA7eAbrlywZMiuj9ilh9kov66IugqA=
X-Received: by 2002:a05:6808:208b:: with SMTP id s11mr3145964oiw.95.1629818645584;
 Tue, 24 Aug 2021 08:24:05 -0700 (PDT)
MIME-Version: 1.0
References: <20210824104918.7930-1-kerneljasonxing@gmail.com> <59dff551-2d52-5ecc-14ac-4a6ada5b1275@redhat.com>
In-Reply-To: <59dff551-2d52-5ecc-14ac-4a6ada5b1275@redhat.com>
From:   Jason Xing <kerneljasonxing@gmail.com>
Date:   Tue, 24 Aug 2021 23:23:29 +0800
Message-ID: <CAL+tcoDERDZqtjK1BCc0vYYwYtvgRtb8H6z2FTVbGqr+N7bVmA@mail.gmail.com>
Subject: Re: [PATCH] ixgbe: let the xdpdrv work with more than 64 cpus
To:     Jesper Dangaard Brouer <jbrouer@redhat.com>
Cc:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
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

On Tue, Aug 24, 2021 at 9:32 PM Jesper Dangaard Brouer
<jbrouer@redhat.com> wrote:
>
>
>
> On 24/08/2021 12.49, kerneljasonxing@gmail.com wrote:
> > From: Jason Xing <xingwanli@kuaishou.com>
> >
> > Originally, ixgbe driver doesn't allow the mounting of xdpdrv if the
> > server is equipped with more than 64 cpus online. So it turns out that
> > the loading of xdpdrv causes the "NOMEM" failure.
> >
> > Actually, we can adjust the algorithm and then make it work, which has
> > no harm at all, only if we set the maxmium number of xdp queues.
>
> This is not true, it can cause harm, because XDP transmission queues are
> used without locking. See drivers ndo_xdp_xmit function ixgbe_xdp_xmit().
> As driver assumption is that each CPU have its own XDP TX-queue.
>

Point taken. I indeed miss that part which would cause bad behavior if it
happens.

At this point, I think I should find all the allocation and use of XDP
related, say,
queues and rings, then adjust them all?

Let's say if the server is shipped with 128 cpus, we could map 128 cpus to 64
rings in the function ixgbe_xdp_xmit(). However, it sounds a little bit odd.

Do you think that it makes any sense?

Thanks,
Jason

> This patch is not a proper fix.
>
> I do think we need a proper fix for this issue on ixgbe.
>
>
> > Fixes: 33fdc82f08 ("ixgbe: add support for XDP_TX action")
> > Co-developed-by: Shujin Li <lishujin@kuaishou.com>
> > Signed-off-by: Shujin Li <lishujin@kuaishou.com>
> > Signed-off-by: Jason Xing <xingwanli@kuaishou.com>
> > ---
> >   drivers/net/ethernet/intel/ixgbe/ixgbe_lib.c  | 2 +-
> >   drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 3 ---
> >   2 files changed, 1 insertion(+), 4 deletions(-)
> >
> > diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_lib.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_lib.c
> > index 0218f6c..5953996 100644
> > --- a/drivers/net/ethernet/intel/ixgbe/ixgbe_lib.c
> > +++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_lib.c
> > @@ -299,7 +299,7 @@ static void ixgbe_cache_ring_register(struct ixgbe_adapter *adapter)
> >
> >   static int ixgbe_xdp_queues(struct ixgbe_adapter *adapter)
> >   {
> > -     return adapter->xdp_prog ? nr_cpu_ids : 0;
> > +     return adapter->xdp_prog ? min_t(int, MAX_XDP_QUEUES, nr_cpu_ids) : 0;
> >   }
> >
> >   #define IXGBE_RSS_64Q_MASK  0x3F
> > diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
> > index 14aea40..b36d16b 100644
> > --- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
> > +++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
> > @@ -10130,9 +10130,6 @@ static int ixgbe_xdp_setup(struct net_device *dev, struct bpf_prog *prog)
> >                       return -EINVAL;
> >       }
> >
> > -     if (nr_cpu_ids > MAX_XDP_QUEUES)
> > -             return -ENOMEM;
> > -
> >       old_prog = xchg(&adapter->xdp_prog, prog);
> >       need_reset = (!!prog != !!old_prog);
> >
> >
>

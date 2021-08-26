Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83EE63F8B49
	for <lists+netdev@lfdr.de>; Thu, 26 Aug 2021 17:44:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242986AbhHZPpR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Aug 2021 11:45:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231732AbhHZPpP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Aug 2021 11:45:15 -0400
Received: from mail-ot1-x330.google.com (mail-ot1-x330.google.com [IPv6:2607:f8b0:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DDADC061757;
        Thu, 26 Aug 2021 08:44:28 -0700 (PDT)
Received: by mail-ot1-x330.google.com with SMTP id x10-20020a056830408a00b004f26cead745so4045151ott.10;
        Thu, 26 Aug 2021 08:44:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9CilpbCdLqDwsRtt52+ILqW2aW6JejKoBnd1mtCylR0=;
        b=FzcNQfkt2j/C971eRKpM7lreK0cVnpf03VZZyUn8by0ZpPEHahykL6h1fH3x9UGIIv
         dxU5si8y5ZtwT4ev6J0R9H2Bhd2/VC5Kkb4f4Li0HRpK8Oj8IIivjTslvIlh+U/5UGs5
         J+kDLhBNLWaELdIn4PG7CFD0WJDa8ps+8v5vE8ArumqvosLCzIGkHPGSq6EOxrGd3HA6
         TEWBOLZms2f5Z1O0laRm1x/scq0FtfnsZXXxvL+FSyvtT5X8dgOi/v1i5G78TWI4ZP9b
         qDwJa71vDPnB8n+WQ/fXJdIUWGqDoWPQy0/i/eOW9EdZJ5r60e9yK5nDx5q7RmI1DDie
         Wz6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9CilpbCdLqDwsRtt52+ILqW2aW6JejKoBnd1mtCylR0=;
        b=Mcov0fni1NqRRI7ix0aSkP6PHQYj5qqnErDPe1nbtqXUThrrlq+DP90z83e5g1774h
         fN5tySgmdMg2FaUnpkDSZt6Z++kknzSL2mtpjlB8iFwOPLyf2+NALxa7Fw+TPYzEprPp
         IeqM3jabcT4Cys9dhpoQiO/24cf90+DLCRzpLso3n1h6fooG/RabbCGp5GAJbl7IKUB2
         ucDdjR1MqxpGQuvP9h8TwJTzX0jvh3okdV0kq8WstJ2q6MgN/9v20tGGORsIA3C+f7tb
         Ti99Dqil3uX3P9SJgs1DC6YgNUbkWkcDtRb902ITOt+wChzvXWhIRI1/OpVHZtxxWcOb
         TaZg==
X-Gm-Message-State: AOAM533wICgdZSfbsvITzIqAIfo61PUl0En+O518Qy6jhw8S7hbj6DPX
        toAWP71MBH2DdhkDFdIhz8CCJlowou9Ms64k394=
X-Google-Smtp-Source: ABdhPJz/CxqQQL7rgljSQCbYHVEkoWFgXyV0AO4VSuiXWMZSGM7Oe4gfDuKMnPS3XBk2GbuyFnklFOViI6DPsR3pLK0=
X-Received: by 2002:a9d:75d5:: with SMTP id c21mr3739175otl.118.1629992667943;
 Thu, 26 Aug 2021 08:44:27 -0700 (PDT)
MIME-Version: 1.0
References: <20210826141623.8151-1-kerneljasonxing@gmail.com> <d15a1f43-3fea-b798-7848-61faf3ca1e8c@intel.com>
In-Reply-To: <d15a1f43-3fea-b798-7848-61faf3ca1e8c@intel.com>
From:   Jason Xing <kerneljasonxing@gmail.com>
Date:   Thu, 26 Aug 2021 23:43:52 +0800
Message-ID: <CAL+tcoDfz3un9fvQ7c-TF=eEiFrEXQBEWV9TvgcjbyNVopMJvg@mail.gmail.com>
Subject: Re: [PATCH v4] ixgbe: let the xdpdrv work with more than 64 cpus
To:     Jesse Brandeburg <jesse.brandeburg@intel.com>
Cc:     "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        David Miller <davem@davemloft.net>, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, hawk@kernel.org,
        john.fastabend@gmail.com, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, kpsingh@kernel.org,
        intel-wired-lan@lists.osuosl.org, netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, bpf@vger.kernel.org,
        Jason Xing <xingwanli@kuaishou.com>,
        Shujin Li <lishujin@kuaishou.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 26, 2021 at 11:23 PM Jesse Brandeburg
<jesse.brandeburg@intel.com> wrote:
>
> On 8/26/2021 7:16 AM, kerneljasonxing@gmail.com wrote:
> > From: Jason Xing <xingwanli@kuaishou.com>
> >
> > Originally, ixgbe driver doesn't allow the mounting of xdpdrv if the
> > server is equipped with more than 64 cpus online. So it turns out that
> > the loading of xdpdrv causes the "NOMEM" failure.
> >
> > Actually, we can adjust the algorithm and then make it work through
> > mapping the current cpu to some xdp ring with the protect of @tx_lock.
>
> Thank you very much for working on this!
>
> you should put your sign off block here, and then end with a triple-dash
> "---"
>
> then have your vN: updates below that, so they will be dropped from
> final git apply. It's ok to have more than one triple-dash.
>

Thanks. Now I know much more about the submission.

> >
> > v4:
> > - Update the wrong commit messages. (Jason)
> >
> > v3:
> > - Change nr_cpu_ids to num_online_cpus() (Maciej)
> > - Rename MAX_XDP_QUEUES to IXGBE_MAX_XDP_QS (Maciej)
> > - Rename ixgbe_determine_xdp_cpu() to ixgbe_determine_xdp_q_idx() (Maciej)
> > - Wrap ixgbe_xdp_ring_update_tail() with lock into one function (Maciej)
> >
> > v2:
> > - Adjust cpu id in ixgbe_xdp_xmit(). (Jesper)
> > - Add a fallback path. (Maciej)
> > - Adjust other parts related to xdp ring.
> >
> > Fixes: 33fdc82f08 ("ixgbe: add support for XDP_TX action")
> > Co-developed-by: Shujin Li <lishujin@kuaishou.com>
> > Signed-off-by: Shujin Li <lishujin@kuaishou.com>
> > Signed-off-by: Jason Xing <xingwanli@kuaishou.com>
> > ---
> >  drivers/net/ethernet/intel/ixgbe/ixgbe.h           | 15 ++++-
> >  drivers/net/ethernet/intel/ixgbe/ixgbe_lib.c       |  9 ++-
> >  drivers/net/ethernet/intel/ixgbe/ixgbe_main.c      | 64 ++++++++++++++++------
> >  .../net/ethernet/intel/ixgbe/ixgbe_txrx_common.h   |  1 +
> >  drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c       |  9 +--
> >  5 files changed, 73 insertions(+), 25 deletions(-)
>
> ...
>
> > @@ -8539,21 +8539,32 @@ static u16 ixgbe_select_queue(struct net_device *dev, struct sk_buff *skb,
> >  int ixgbe_xmit_xdp_ring(struct ixgbe_adapter *adapter,
> >                       struct xdp_frame *xdpf)
> >  {
> > -     struct ixgbe_ring *ring = adapter->xdp_ring[smp_processor_id()];
> >       struct ixgbe_tx_buffer *tx_buffer;
> >       union ixgbe_adv_tx_desc *tx_desc;
> > +     struct ixgbe_ring *ring;
> >       u32 len, cmd_type;
> >       dma_addr_t dma;
> > +     int index, ret;
> >       u16 i;
> >
> >       len = xdpf->len;
> >
> > -     if (unlikely(!ixgbe_desc_unused(ring)))
> > -             return IXGBE_XDP_CONSUMED;
> > +     index = ixgbe_determine_xdp_q_idx(smp_processor_id());
> > +     ring = adapter->xdp_ring[index];
> > +
> > +     if (static_branch_unlikely(&ixgbe_xdp_locking_key))
> > +             spin_lock(&ring->tx_lock);
> > +
> > +     if (unlikely(!ixgbe_desc_unused(ring))) {
> > +             ret = IXGBE_XDP_CONSUMED;
> > +             goto out;
> > +     }
>
> This static key stuff is tricky code, but I guess if it works, then it's
> better than nothing.
>
> As Maciej also commented, I'd like to see some before/after numbers for
> some of the xdp sample programs to make sure this doesn't cause a huge
> regression on the xdp transmit path. A small regression would be ok,
> since this *is* adding overhead.
>

Fine. It will take me some time. BTW, I'm wondering that, after I'm
done with the analysis, should I just reply to this email directly or
send the v5 patch including those numbers?

Thanks,
Jason

> Jesse
>

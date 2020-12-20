Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCB122DF4E7
	for <lists+netdev@lfdr.de>; Sun, 20 Dec 2020 10:48:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727416AbgLTJrj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Dec 2020 04:47:39 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:40201 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727291AbgLTJrj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Dec 2020 04:47:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1608457572;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Z+DMY6TbsvTLY1kZR0FCOftjGNW/EZMlYgg90jJZyBs=;
        b=JI3RkpfKID7Rzl6Q7iGCIOd4SPt2oWR1/HbfMah6oXcefFQG4L8yJpy9N+aNO9oWSYQo9W
        jclUdnFowm12rBzE9z22itEju8vcCyaccZAhVuDb68SyLtHHSRSncQM40kz1iK9Mth7cg/
        aRhK8W9Kb78nIYcLHU9jYx/gF3kfyQI=
Received: from mail-yb1-f200.google.com (mail-yb1-f200.google.com
 [209.85.219.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-364-SJu9S3VyNS6LZSa9rh5fPQ-1; Sun, 20 Dec 2020 04:46:10 -0500
X-MC-Unique: SJu9S3VyNS6LZSa9rh5fPQ-1
Received: by mail-yb1-f200.google.com with SMTP id d187so10239945ybc.6
        for <netdev@vger.kernel.org>; Sun, 20 Dec 2020 01:46:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Z+DMY6TbsvTLY1kZR0FCOftjGNW/EZMlYgg90jJZyBs=;
        b=ouFnNGaTeKEh5dSdsAeOKEMscXhbvi6BjwFngh3gptU+MY8Oxi/w2vCKJ3gPDcVgW5
         7i3QgMp8AaN3Go7mVpuncfzbad3l66qWIzvDwjgrurOi0zhplkklM4lAp7AqWndi7jt2
         OWSn+QsjFOoBK8v5h0jfMR27uqcu97bOLxVJI2l1ExuWkL7hv9l/Oz4mlIA47Ybk09JA
         0Fg7WXKVqElDs+vJRFC6PQsnNFvNMXRE1h9Ct6nF76ZXc6ik6xIrz7h2rWteLI7sl9/7
         yHrQNWCf+WzrHr7QwqqH+czJopPeTAXYDfn4ApdQp59DpzjnF92PPlp7b0+CET6lXGCv
         qTRQ==
X-Gm-Message-State: AOAM533DvHzMTJAhCWC5FpdUxZmRjuurGIKYcszqIOZYP9/7gZPbNswq
        ymp95WfEQtFJB3zP047ro60Qdowjv65956gx1wGuAVq4Um2OwYyUoc2j7FzgX6TU9fhiw2Mr98i
        rbhaQ5YQdf97Tz/9lityn0L1uwldPMuV2
X-Received: by 2002:a25:dc7:: with SMTP id 190mr16157313ybn.73.1608457569918;
        Sun, 20 Dec 2020 01:46:09 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyVBvmetdSroAXdUkZMjpSn7QBF92ODkxkgwlCSXRBPKtXAaHaWOOIqqgTV8AJKXqZ47VvPs56ZvJaWAJbkfsQ=
X-Received: by 2002:a25:dc7:: with SMTP id 190mr16157301ybn.73.1608457569666;
 Sun, 20 Dec 2020 01:46:09 -0800 (PST)
MIME-Version: 1.0
References: <cover.1608399672.git.lorenzo@kernel.org> <pj41zl8s9sq499.fsf@u68c7b5b1d2d758.ant.amazon.com>
In-Reply-To: <pj41zl8s9sq499.fsf@u68c7b5b1d2d758.ant.amazon.com>
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Date:   Sun, 20 Dec 2020 10:45:58 +0100
Message-ID: <CAJ0CqmW6XDvgBbgD80xC_Th6BaWnZZfPOySEgBXFfGgPRHakaw@mail.gmail.com>
Subject: Re: [PATCH v4 bpf-next 0/2] introduce xdp_init_buff/xdp_prepare_buff
To:     Shay Agroskin <shayagr@amazon.com>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>,
        BPF-dev-list <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Brouer <brouer@redhat.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Saeed Mahameed <saeed@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>
>
> Lorenzo Bianconi <lorenzo@kernel.org> writes:
>
> > Introduce xdp_init_buff and xdp_prepare_buff utility routines to
> > initialize
> > xdp_buff data structure and remove duplicated code in all XDP
> > capable
> > drivers.
> >
> > Changes since v3:
> > - use __always_inline instead of inline for
> > xdp_init_buff/xdp_prepare_buff
> > - add 'const bool meta_valid' to xdp_prepare_buff signature to
> > avoid
> >   overwriting data_meta with xdp_set_data_meta_invalid()
> > - introduce removed comment in bnxt driver
> >
> > Changes since v2:
> > - precompute xdp->data as hard_start + headroom and save it in a
> > local
> >   variable to reuse it for xdp->data_end and xdp->data_meta in
> >   xdp_prepare_buff()
> >
> > Changes since v1:
> > - introduce xdp_prepare_buff utility routine
> >
> > Lorenzo Bianconi (2):
> >   net: xdp: introduce xdp_init_buff utility routine
> >   net: xdp: introduce xdp_prepare_buff utility routine
> >
> > Acked-by: Martin Habets <habetsm.xilinx@gmail.com>
> > Acked-by: Camelia Groza <camelia.groza@nxp.com>
> >
> >  drivers/net/ethernet/amazon/ena/ena_netdev.c  | 10 ++++------
>
> For changes in ena driver
>
> Acked-by: Shay Agroskin <shayagr@amazon.com>
>
> Also, wouldn't xdp_init_buff() change once the xdp_mb series is
> merged to take care of xdp.mb = 0 part ?
> Maybe this series should wait until the other one is merged ?
>

When this series is merged, I will rebase xdp multi-buff one on top of
it and I will initialize xdp.mb = 0 in xdp_init_buff() without
changing each driver.

Regards,
Lorenzo

> >  drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c |  9 +++------
> >  .../net/ethernet/cavium/thunder/nicvf_main.c  | 12 ++++++------
> >  .../net/ethernet/freescale/dpaa/dpaa_eth.c    | 10 ++++------
> >  .../net/ethernet/freescale/dpaa2/dpaa2-eth.c  | 14
> >  +++++---------
> >  drivers/net/ethernet/intel/i40e/i40e_txrx.c   | 18
> >  +++++++++---------
> >  drivers/net/ethernet/intel/ice/ice_txrx.c     | 15
> >  ++++++++-------
> >  drivers/net/ethernet/intel/igb/igb_main.c     | 18
> >  +++++++++---------
> >  drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 19
> >  +++++++++----------
> >  .../net/ethernet/intel/ixgbevf/ixgbevf_main.c | 19
> >  +++++++++----------
> >  drivers/net/ethernet/marvell/mvneta.c         | 10 +++-------
> >  .../net/ethernet/marvell/mvpp2/mvpp2_main.c   | 14
> >  +++++++-------
> >  drivers/net/ethernet/mellanox/mlx4/en_rx.c    |  9 +++------
> >  .../net/ethernet/mellanox/mlx5/core/en_rx.c   |  8 ++------
> >  .../ethernet/netronome/nfp/nfp_net_common.c   | 12 ++++++------
> >  drivers/net/ethernet/qlogic/qede/qede_fp.c    |  9 +++------
> >  drivers/net/ethernet/sfc/rx.c                 | 10 +++-------
> >  drivers/net/ethernet/socionext/netsec.c       |  9 +++------
> >  drivers/net/ethernet/ti/cpsw.c                | 18
> >  ++++++------------
> >  drivers/net/ethernet/ti/cpsw_new.c            | 18
> >  ++++++------------
> >  drivers/net/hyperv/netvsc_bpf.c               |  8 ++------
> >  drivers/net/tun.c                             | 12 ++++--------
> >  drivers/net/veth.c                            | 14
> >  +++++---------
> >  drivers/net/virtio_net.c                      | 18
> >  ++++++------------
> >  drivers/net/xen-netfront.c                    | 10 ++++------
> >  include/net/xdp.h                             | 19
> >  +++++++++++++++++++
> >  net/bpf/test_run.c                            |  9 +++------
> >  net/core/dev.c                                | 18
> >  ++++++++----------
> >  28 files changed, 159 insertions(+), 210 deletions(-)
>


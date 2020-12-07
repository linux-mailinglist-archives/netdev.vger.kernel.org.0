Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 186372D1BD8
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 22:15:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726632AbgLGVPx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 16:15:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725931AbgLGVPw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Dec 2020 16:15:52 -0500
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87B5BC061749;
        Mon,  7 Dec 2020 13:15:12 -0800 (PST)
Received: by mail-il1-x142.google.com with SMTP id 2so10467903ilg.9;
        Mon, 07 Dec 2020 13:15:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=L0vLg8UT9gnGKmlAs0+JMUGqnXR1z3vg/JyNzC1FgTo=;
        b=tNl7PaMyAfUQkU/tCI8Bo4rEsepUZ2TvMXfnTu+E7qoyjwlsN10mTZd6GDv/W7L/2n
         MmF2H0fP6z+iDnG8mNoPJpnF5S1gHzg+ZoIYra5zGZly5+152ID8WLta4urUg+qBsXaV
         oGlr2BBbKvw0Bhvh9EVnE1yBIDzoUxIhsppgfB5LrYrlJGYIO3mjnSLLrdrSjbQxYjS+
         6y+fySm5+djHaSZAAfiX4YyLhtpHVYwujyM/l5oLXPCSE45aatTQHZ0GCDVQmGHiTKp/
         kSblRmX/g+tnjqlNIQckq+cr3QkcTAX2smEt9PxvG4LaDwWIfNDJcu3LBTUkg1GjvYH1
         1KvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=L0vLg8UT9gnGKmlAs0+JMUGqnXR1z3vg/JyNzC1FgTo=;
        b=OcYxPqjvRqtHcoJ+t2Z44A/5U5KZXcPMrhl4x5cNykOQyG+95PdCN8z2fHH4WwTvHm
         dJei9y71SmGn6/mWXy9L5yu/dy4tp1c/MtdMHrazTqiSvKJHunFrZiw2pOVeDCBWSN4L
         7HXedJd2us926dmoPuMGBVpxvcJ9kAtmY1X5zlWq8x9BpfzpbsPwWrQdQPIkBwNKGGGe
         N69dNySWL6Ijb6QgfAW1gFcTMEAaGGJAAQJQ2zrJzjurEI/bmEqPBSYjG7pCbWPoRyrU
         f2jrefu5zJCL9jnYPFzygtV5Q3drgUtscQG7zLOUIk/idWFWNH1kq8V82127G/XXqOJe
         zQdg==
X-Gm-Message-State: AOAM533ojbmSFl3iPpWkEz+tEd/XVk9TwXkgscCb17tnyv2SGws2nL4u
        nh7xzoE9fmje44c9MgnhSf7e9zW6vr9od4EKud7nPcnk6Xw=
X-Google-Smtp-Source: ABdhPJycdmkxsf4RQx0yUG5Fs32o2jvvhzl6+nzQPBukOlmbZBPazpla6XWgcrV95/9GidkBmhsRVxjS9BFtfmLUx6U=
X-Received: by 2002:a92:d8cc:: with SMTP id l12mr21859317ilo.64.1607375711764;
 Mon, 07 Dec 2020 13:15:11 -0800 (PST)
MIME-Version: 1.0
References: <cover.1607349924.git.lorenzo@kernel.org> <693d48b46dd5172763952acd94358cc5d02dcda3.1607349924.git.lorenzo@kernel.org>
In-Reply-To: <693d48b46dd5172763952acd94358cc5d02dcda3.1607349924.git.lorenzo@kernel.org>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Mon, 7 Dec 2020 13:15:00 -0800
Message-ID: <CAKgT0UcjtERgpV9tke-HcmP7rWOns_-jmthnGiNPES+aqhScFg@mail.gmail.com>
Subject: Re: [PATCH v5 bpf-next 02/14] xdp: initialize xdp_buff mb bit to 0 in
 all XDP drivers
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     bpf <bpf@vger.kernel.org>, Netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, shayagr@amazon.com,
        "Jubran, Samih" <sameehj@amazon.com>,
        John Fastabend <john.fastabend@gmail.com>, dsahern@kernel.org,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>,
        lorenzo.bianconi@redhat.com, Jason Wang <jasowang@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 7, 2020 at 8:36 AM Lorenzo Bianconi <lorenzo@kernel.org> wrote:
>
> Initialize multi-buffer bit (mb) to 0 in all XDP-capable drivers.
> This is a preliminary patch to enable xdp multi-buffer support.
>
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>

I'm really not a fan of this design. Having to update every driver in
order to initialize a field that was fragmented is a pain. At a
minimum it seems like it might be time to consider introducing some
sort of initializer function for this so that you can update things in
one central place the next time you have to add a new field instead of
having to update every individual driver that supports XDP. Otherwise
this isn't going to scale going forward.

> ---
>  drivers/net/ethernet/amazon/ena/ena_netdev.c        | 1 +
>  drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c       | 1 +
>  drivers/net/ethernet/cavium/thunder/nicvf_main.c    | 1 +
>  drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c    | 1 +
>  drivers/net/ethernet/intel/i40e/i40e_txrx.c         | 1 +
>  drivers/net/ethernet/intel/ice/ice_txrx.c           | 1 +
>  drivers/net/ethernet/intel/ixgbe/ixgbe_main.c       | 1 +
>  drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c   | 1 +
>  drivers/net/ethernet/marvell/mvneta.c               | 1 +
>  drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c     | 1 +
>  drivers/net/ethernet/mellanox/mlx4/en_rx.c          | 1 +
>  drivers/net/ethernet/mellanox/mlx5/core/en_rx.c     | 1 +
>  drivers/net/ethernet/netronome/nfp/nfp_net_common.c | 1 +
>  drivers/net/ethernet/qlogic/qede/qede_fp.c          | 1 +
>  drivers/net/ethernet/sfc/rx.c                       | 1 +
>  drivers/net/ethernet/socionext/netsec.c             | 1 +
>  drivers/net/ethernet/ti/cpsw.c                      | 1 +
>  drivers/net/ethernet/ti/cpsw_new.c                  | 1 +
>  drivers/net/hyperv/netvsc_bpf.c                     | 1 +
>  drivers/net/tun.c                                   | 2 ++
>  drivers/net/veth.c                                  | 1 +
>  drivers/net/virtio_net.c                            | 2 ++
>  drivers/net/xen-netfront.c                          | 1 +
>  net/core/dev.c                                      | 1 +
>  24 files changed, 26 insertions(+)
>

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 062702198EB
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 08:55:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726196AbgGIGzD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 02:55:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726006AbgGIGzD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jul 2020 02:55:03 -0400
Received: from mail-vk1-xa42.google.com (mail-vk1-xa42.google.com [IPv6:2607:f8b0:4864:20::a42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A87A5C061A0B;
        Wed,  8 Jul 2020 23:55:02 -0700 (PDT)
Received: by mail-vk1-xa42.google.com with SMTP id h1so199394vkn.12;
        Wed, 08 Jul 2020 23:55:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Kfl7xEGDrIl6D4KKtWSYsZNMmEPY/8miTymFzcOgOcY=;
        b=pq/zBE5Jou88bB+aKyq3rQ9zrbMsh6dyQIXp3QUWlYedyL09pik2oxx4u/STgyAxjF
         sleSdQjOC60HA6vogy0QCrb0Kt7pSvZvT8XIwSHc4cFDrPuQH2V5Duk82Zb7IHRVp8He
         doVbUJOFXXs2hr1UY/j+q7bICI1kfeNJroKV15T3/2BGyoVSAjKZDSOgjSt4iCkdTNlM
         yNxjlvOACZHXbDyorKu9u2G2zduMRBGmvhMsmvJ+l1ZyBxqfKEXhfmerW1Jaw6uFWB3q
         1d7hNEabL8/ioTd41AiA7vvRxbp0jtCidM6HDaEDJiIsxXzdNiH3qgVqt1hnyHKzZNBr
         oljw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Kfl7xEGDrIl6D4KKtWSYsZNMmEPY/8miTymFzcOgOcY=;
        b=PVX4NheX1lNIj1pjj+R6e05pJydM0qi/oZz4pmXkDX64krBtQ6PNLKOUTbr/C8BGwD
         7e31rv6Ere51faQRV4SpcNzoy+w24iWWm9hiQhsfXBTKru55Hd4mjpZa4pleOkOyA4m9
         iZT7Z2TOse0MFGqYNO4NOVKry0VvG2hWu0EMnZCg4jB+eGMfyEo8souNP1mGA2/qDetw
         clLwknyrVvVRnH4bJQTvq93HdnOD3r4H2hQ0Cbzm6vAHM+4Wk6tfnmSb0nB3WuLrMVxW
         1yBxr7gsXxzgrd/rcuk3mL1FOP32yqT0qlI93SfO6oIWTjm24AyX5YJkVTtHP5aO9v2l
         FKVg==
X-Gm-Message-State: AOAM532Kx3Cwzahh+wV6CAYSVmU63D3hyb9gvWYS3tnBf1LhDbNv6zlZ
        oGsQa5rzbUWdwaqjlYdmrQMcip4KnXwPkhtcf80=
X-Google-Smtp-Source: ABdhPJyY396zXJ1Mm0Yz24yfNg5c5l5b6xuYgRV8XDREt8mj5sCUZrvwHr38zwjqzynETmuW6V++dod127MbZ9wLta4=
X-Received: by 2002:a1f:eec8:: with SMTP id m191mr44396249vkh.47.1594277701646;
 Wed, 08 Jul 2020 23:55:01 -0700 (PDT)
MIME-Version: 1.0
References: <1593692353-15102-1-git-send-email-magnus.karlsson@intel.com> <5cf948fe-be1c-a639-2c58-377ef31d28fa@mellanox.com>
In-Reply-To: <5cf948fe-be1c-a639-2c58-377ef31d28fa@mellanox.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Thu, 9 Jul 2020 08:54:50 +0200
Message-ID: <CAJ8uoz2sud5wBFpWKfC-i4n9E77KnQWGPsKLysumsA23pHEjEQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next 00/14] xsk: support shared umems between devices
 and queues
To:     Maxim Mikityanskiy <maximmi@mellanox.com>
Cc:     Magnus Karlsson <magnus.karlsson@intel.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        bpf <bpf@vger.kernel.org>, jeffrey.t.kirsher@intel.com,
        "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>,
        Maciej Fijalkowski <maciejromanfijalkowski@gmail.com>,
        cristian.dumitrescu@intel.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 8, 2020 at 5:02 PM Maxim Mikityanskiy <maximmi@mellanox.com> wrote:
>
> On 2020-07-02 15:18, Magnus Karlsson wrote:
> > This patch set adds support to share a umem between AF_XDP sockets
> > bound to different queue ids on the same device or even between
> > devices. It has already been possible to do this by registering the
> > umem multiple times, but this wastes a lot of memory. Just imagine
> > having 10 threads each having 10 sockets open sharing a single
> > umem. This means that you would have to register the umem 100 times
> > consuming large quantities of memory.
>
> Just to clarify: the main memory savings are achieved, because we don't
> need to store an array of pages in struct xdp_umem multiple times, right?
>
> I guess there is one more drawback of sharing a UMEM the old way
> (register it multiple times): it would map (DMA) the same pages multiple
> times.

Both are correct. The main saving is from only having to DMA map the
device once, your second comment.

> > Instead, we extend the existing XDP_SHARED_UMEM flag to also work when
> > sharing a umem between different queue ids as well as devices. If you
> > would like to share umem between two sockets, just create the first
> > one as would do normally. For the second socket you would not register
> > the same umem using the XDP_UMEM_REG setsockopt. Instead attach one
> > new fill ring and one new completion ring to this second socket and
> > then use the XDP_SHARED_UMEM bind flag supplying the file descriptor of
> > the first socket in the sxdp_shared_umem_fd field to signify that it
> > is the umem of the first socket you would like to share.
> >
> > One important thing to note in this example, is that there needs to be
> > one fill ring and one completion ring per unique device and queue id
> > bound to. This so that the single-producer and single-consumer semantics
> > of the rings can be upheld. To recap, if you bind multiple sockets to
> > the same device and queue id (already supported without this patch
> > set), you only need one pair of fill and completion rings. If you bind
> > multiple sockets to multiple different queues or devices, you need one
> > fill and completion ring pair per unique device,queue_id tuple.
> >
> > The implementation is based around extending the buffer pool in the
> > core xsk code. This is a structure that exists on a per unique device
> > and queue id basis. So, a number of entities that can now be shared
> > are moved from the umem to the buffer pool. Information about DMA
> > mappings are also moved from the buffer pool, but as these are per
> > device independent of the queue id, they are now hanging off the
> > netdev.
>
> Basically, you want to map a pair of (netdev, UMEM) to DMA info. The
> current implementation of xp_find_dma_map stores a list of UMEMs in the
> netdev and goes over that list to find the corresponding DMA info. It
> would be more effective to do it vice-versa, i.e. to store the list of
> netdevs inside of a UMEM, because you normally have fewer netdevs in the
> system than sockets, and you'll have fewer list items to traverse. Of
> course, it has no effect on the data path, but it will improve the time
> to open a socket (i.e. connection rate).

Good idea. Will fix.

> > In summary after this patch set, there is one xdp_sock struct
> > per socket created. This points to an xsk_buff_pool for which there is
> > one per unique device and queue id. The buffer pool points to a DMA
> > mapping structure for which there is one per device that a umem has
> > been bound to. And finally, the buffer pool also points to a xdp_umem
> > struct, for which there is only one per umem registration.
> >
> > Before:
> >
> > XSK -> UMEM -> POOL
> >
> > Now:
> >
> > XSK -> POOL -> DMA
> >              \
> >            > UMEM
> >
> > Patches 1-8 only rearrange internal structures to support the buffer
> > pool carrying this new information, while patch 9 improves performance
> > as we now have rearrange the internal structures quite a bit. Finally,
> > patches 10-14 introduce the new functionality together with libbpf
> > support, samples, and documentation.
> >
> > Libbpf has also been extended to support sharing of umems between
> > sockets bound to different devices and queue ids by introducing a new
> > function called xsk_socket__create_shared(). The difference between
> > this and the existing xsk_socket__create() is that the former takes a
> > reference to a fill ring and a completion ring as these need to be
> > created. This new function needs to be used for the second and
> > following sockets that binds to the same umem. The first one can be
> > created by either function as it will also have called
> > xsk_umem__create().
> >
> > There is also a new sample xsk_fwd that demonstrates this new
> > interface and capability.
> >
> > Note to Maxim at Mellanox. I do not have a mlx5 card, so I have not
> > been able to test the changes to your driver. It compiles, but that is
> > all I can say, so it would be great if you could test it. Also, I did
> > change the name of many functions and variables from umem to pool as a
> > buffer pool is passed down to the driver in this patch set instead of
> > the umem. I did not change the name of the files umem.c and
> > umem.h. Please go through the changes and change things to your
> > liking.
>
> I looked through the mlx5 patches, and I see the changes are minor, and
> most importantly, the functionality is not broken (tested with xdpsock).
> I would still like to make some cosmetic amendments - I'll send you an
> updated patch.

Appreciated. Thanks.

> > Performance for the non-shared umem case is unchanged for the xdpsock
> > sample application with this patch set.
>
> I also tested it on mlx5 (ConnectX-5 Ex), and the performance hasn't
> been hurt.

Good to hear. I might include another patch in the v2 that improves
performance with 3% for the l2fwd sample app on my system. It is in
common code so should benefit everyone. Though, it is dependent on a
new DMA interface patch set from Christof making it from bpf to
bpf-next. If it makes it over in time, I will include it. Otherwise,
it will be submitted later.

/Magnus

> > For workloads that share a
> > umem, this patch set can give rise to added performance benefits due
> > to the decrease in memory usage.
> >
> > This patch has been applied against commit 91f77560e473 ("Merge branch 'test_progs-improvements'")
> >
> > Structure of the patch set:
> >
> > Patch 1: Pass the buffer pool to the driver instead of the umem. This
> >           because the driver needs one buffer pool per napi context
> >           when we later introduce sharing of the umem between queue ids
> >           and devices.
> > Patch 2: Rename the xsk driver interface so they have better names
> >           after the move to the buffer pool
> > Patch 3: There is one buffer pool per device and queue, while there is
> >           only one umem per registration. The buffer pool needs to be
> >           created and destroyed independently of the umem.
> > Patch 4: Move fill and completion rings to the buffer pool as there will
> >           be one set of these per device and queue
> > Patch 5: Move queue_id, dev and need_wakeup to buffer pool again as these
> >           will now be per buffer pool as the umem can be shared between
> >           devices and queues
> > Patch 6: Move xsk_tx_list and its lock to buffer pool
> > Patch 7: Move the creation/deletion of addrs from buffer pool to umem
> > Patch 8: Enable sharing of DMA mappings when multiple queues of the
> >           same device are bound
> > Patch 9: Rearrange internal structs for better performance as these
> >           have been substantially scrambled by the previous patches
> > Patch 10: Add shared umem support between queue ids
> > Patch 11: Add shared umem support between devices
> > Patch 12: Add support for this in libbpf
> > Patch 13: Add a new sample that demonstrates this new feature by
> >            forwarding packets between different netdevs and queues
> > Patch 14: Add documentation
> >
> > Thanks: Magnus
> >
> > Cristian Dumitrescu (1):
> >    samples/bpf: add new sample xsk_fwd.c
> >
> > Magnus Karlsson (13):
> >    xsk: i40e: ice: ixgbe: mlx5: pass buffer pool to driver instead of
> >      umem
> >    xsk: i40e: ice: ixgbe: mlx5: rename xsk zero-copy driver interfaces
> >    xsk: create and free context independently from umem
> >    xsk: move fill and completion rings to buffer pool
> >    xsk: move queue_id, dev and need_wakeup to context
> >    xsk: move xsk_tx_list and its lock to buffer pool
> >    xsk: move addrs from buffer pool to umem
> >    xsk: net: enable sharing of dma mappings
> >    xsk: rearrange internal structs for better performance
> >    xsk: add shared umem support between queue ids
> >    xsk: add shared umem support between devices
> >    libbpf: support shared umems between queues and devices
> >    xsk: documentation for XDP_SHARED_UMEM between queues and netdevs
> >
> >   Documentation/networking/af_xdp.rst                |   68 +-
> >   drivers/net/ethernet/intel/i40e/i40e_ethtool.c     |    2 +-
> >   drivers/net/ethernet/intel/i40e/i40e_main.c        |   29 +-
> >   drivers/net/ethernet/intel/i40e/i40e_txrx.c        |   10 +-
> >   drivers/net/ethernet/intel/i40e/i40e_txrx.h        |    2 +-
> >   drivers/net/ethernet/intel/i40e/i40e_xsk.c         |   79 +-
> >   drivers/net/ethernet/intel/i40e/i40e_xsk.h         |    4 +-
> >   drivers/net/ethernet/intel/ice/ice.h               |   18 +-
> >   drivers/net/ethernet/intel/ice/ice_base.c          |   16 +-
> >   drivers/net/ethernet/intel/ice/ice_lib.c           |    2 +-
> >   drivers/net/ethernet/intel/ice/ice_main.c          |   10 +-
> >   drivers/net/ethernet/intel/ice/ice_txrx.c          |    8 +-
> >   drivers/net/ethernet/intel/ice/ice_txrx.h          |    2 +-
> >   drivers/net/ethernet/intel/ice/ice_xsk.c           |  142 +--
> >   drivers/net/ethernet/intel/ice/ice_xsk.h           |    7 +-
> >   drivers/net/ethernet/intel/ixgbe/ixgbe.h           |    2 +-
> >   drivers/net/ethernet/intel/ixgbe/ixgbe_main.c      |   34 +-
> >   .../net/ethernet/intel/ixgbe/ixgbe_txrx_common.h   |    7 +-
> >   drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c       |   61 +-
> >   drivers/net/ethernet/mellanox/mlx5/core/en.h       |   19 +-
> >   drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c   |    5 +-
> >   .../net/ethernet/mellanox/mlx5/core/en/xsk/rx.h    |   10 +-
> >   .../net/ethernet/mellanox/mlx5/core/en/xsk/setup.c |   12 +-
> >   .../net/ethernet/mellanox/mlx5/core/en/xsk/setup.h |    2 +-
> >   .../net/ethernet/mellanox/mlx5/core/en/xsk/tx.c    |   12 +-
> >   .../net/ethernet/mellanox/mlx5/core/en/xsk/tx.h    |    6 +-
> >   .../net/ethernet/mellanox/mlx5/core/en/xsk/umem.c  |  108 +-
> >   .../net/ethernet/mellanox/mlx5/core/en/xsk/umem.h  |   14 +-
> >   drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |   46 +-
> >   drivers/net/ethernet/mellanox/mlx5/core/en_rx.c    |   16 +-
> >   include/linux/netdevice.h                          |   13 +-
> >   include/net/xdp_sock.h                             |   28 +-
> >   include/net/xdp_sock_drv.h                         |  115 ++-
> >   include/net/xsk_buff_pool.h                        |   47 +-
> >   net/core/dev.c                                     |    3 +
> >   net/ethtool/channels.c                             |    2 +-
> >   net/ethtool/ioctl.c                                |    2 +-
> >   net/xdp/xdp_umem.c                                 |  221 +---
> >   net/xdp/xdp_umem.h                                 |    6 -
> >   net/xdp/xsk.c                                      |  213 ++--
> >   net/xdp/xsk.h                                      |    3 +
> >   net/xdp/xsk_buff_pool.c                            |  314 +++++-
> >   net/xdp/xsk_diag.c                                 |   14 +-
> >   net/xdp/xsk_queue.h                                |   12 +-
> >   samples/bpf/Makefile                               |    3 +
> >   samples/bpf/xsk_fwd.c                              | 1075 ++++++++++++++++++++
> >   tools/lib/bpf/libbpf.map                           |    1 +
> >   tools/lib/bpf/xsk.c                                |  376 ++++---
> >   tools/lib/bpf/xsk.h                                |    9 +
> >   49 files changed, 2327 insertions(+), 883 deletions(-)
> >   create mode 100644 samples/bpf/xsk_fwd.c
> >
> > --
> > 2.7.4
> >
>

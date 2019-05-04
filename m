Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C1D6A13B64
	for <lists+netdev@lfdr.de>; Sat,  4 May 2019 19:25:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726890AbfEDRZw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 May 2019 13:25:52 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:32922 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726480AbfEDRZv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 May 2019 13:25:51 -0400
Received: by mail-qk1-f193.google.com with SMTP id k189so273584qkc.0;
        Sat, 04 May 2019 10:25:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=aeIr2xYUVvk3yQWnL07RF0qzoNgh0zjWYEMxr0YSFWA=;
        b=mD1gRGwUPp5N64opyhHYamX+1iKoFew8i2R99fxUCC31Dt9vxtWIL9XjETHQ9uVbJv
         DXm/LSDeTkZWkJXFcKic8cZIiP19/g9vgYSh/5WAlY873K9RyEaiKFyXNigYAACX2w1m
         K9VFO9ct5eGJpc8aW6JfBxzEq4XUi8U2d12mXg2WtPc4i11BMgV0dtGMfd4Nxg3HUb7L
         d02ckG6Uiuxo5rHxANDakZskw0l7JORdZHmoKtGjP4oUALP/8RKPlkCoZ5bfgReXnaP6
         qNgAz+8MIzTw8c0olzQPuVRzU06KsfYPRqe0w1AfD3SYYWDfByep2V/cM9Nn5sfbrAeI
         +CWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aeIr2xYUVvk3yQWnL07RF0qzoNgh0zjWYEMxr0YSFWA=;
        b=hJHB4yHziEdF7Ef7B4t5KQmtcMyvzB96glamQRpeJhsjwvWcv+Y/tits5XTg3YunI/
         jP5iCrmcGqz0HWiymDm034ToMUq090ToixeOvD/+ujDDRE2ADpslmidLnVDJIxgtjwmy
         OVPkMBYkAf4yfcAlgbRbVCPbzUGv7XtkP3W+OOCKwlzkA9Fc1DFzPLJF607EazjDGJbo
         s3dYNt9SeQPo8Y07i4fQ7O2g0j6x+JCX8S00qfYqNQh9Zj3pdB2NP7nfPrtIbJ8YXJ6i
         0LhdAycFc7MAnv4FjmJQA+iz+zQSrSm/z1SC7bJqOA8o75ekE7/FqrDXv2bIMqPCsLNL
         nBBQ==
X-Gm-Message-State: APjAAAWaU6G4v6Oi8QDE9Rwzy87ZOW8MWkaH3JdEbGnDdO6lpcv1S9L/
        QAo3MzmOhdpZFwpPruuhousryF9WXl0UVAIUys8=
X-Google-Smtp-Source: APXvYqxi+w3yUON7YjqufOPe4m6KCd05Ub21wlYRl1pg2v1EqY0zS7mOcU78nDP+MIVJGwQ6w78+SJ4wlpJ1KhWaYEM=
X-Received: by 2002:a05:620a:12a5:: with SMTP id x5mr13411197qki.334.1556990750181;
 Sat, 04 May 2019 10:25:50 -0700 (PDT)
MIME-Version: 1.0
References: <20190430181215.15305-1-maximmi@mellanox.com>
In-Reply-To: <20190430181215.15305-1-maximmi@mellanox.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Sat, 4 May 2019 19:25:38 +0200
Message-ID: <CAJ+HfNga0DJ9SXd71rf1emwnZnAExahHAX7GwDgV6wY-Escueg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 00/16] AF_XDP infrastructure improvements and
 mlx5e support
To:     Maxim Mikityanskiy <maximmi@mellanox.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Jonathan Lemon <bsd@fb.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Maciej Fijalkowski <maciejromanfijalkowski@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 30 Apr 2019 at 20:12, Maxim Mikityanskiy <maximmi@mellanox.com> wrote:
>
> This series contains improvements to the AF_XDP kernel infrastructure
> and AF_XDP support in mlx5e. The infrastructure improvements are
> required for mlx5e, but also some of them benefit to all drivers, and
> some can be useful for other drivers that want to implement AF_XDP.
>
> The performance testing was performed on a machine with the following
> configuration:
>
> - 24 cores of Intel Xeon E5-2620 v3 @ 2.40 GHz
> - Mellanox ConnectX-5 Ex with 100 Gbit/s link
>
> The results with retpoline disabled, single stream:
>
> txonly: 33.3 Mpps (21.5 Mpps with queue and app pinned to the same CPU)
> rxdrop: 12.2 Mpps
> l2fwd: 9.4 Mpps
>
> The results with retpoline enabled, single stream:
>
> txonly: 21.3 Mpps (14.1 Mpps with queue and app pinned to the same CPU)
> rxdrop: 9.9 Mpps
> l2fwd: 6.8 Mpps
>
> v2 changes:
>
> Added patches for mlx5e and addressed the comments for v1. Rebased for
> bpf-next (net-next has to be merged first, because this series depends
> on some patches from there).
>

Nit: There're some checkpatch warnings (>80 char lines) for the driver parts.


> Maxim Mikityanskiy (16):
>   xsk: Add API to check for available entries in FQ
>   xsk: Add getsockopt XDP_OPTIONS
>   libbpf: Support getsockopt XDP_OPTIONS
>   xsk: Extend channels to support combined XSK/non-XSK traffic
>   xsk: Change the default frame size to 4096 and allow controlling it
>   xsk: Return the whole xdp_desc from xsk_umem_consume_tx
>   net/mlx5e: Replace deprecated PCI_DMA_TODEVICE
>   net/mlx5e: Calculate linear RX frag size considering XSK
>   net/mlx5e: Allow ICO SQ to be used by multiple RQs
>   net/mlx5e: Refactor struct mlx5e_xdp_info
>   net/mlx5e: Share the XDP SQ for XDP_TX between RQs
>   net/mlx5e: XDP_TX from UMEM support
>   net/mlx5e: Consider XSK in XDP MTU limit calculation
>   net/mlx5e: Encapsulate open/close queues into a function
>   net/mlx5e: Move queue param structs to en/params.h
>   net/mlx5e: Add XSK support
>
>  drivers/net/ethernet/intel/i40e/i40e_xsk.c    |  12 +-
>  drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c  |  15 +-
>  .../net/ethernet/mellanox/mlx5/core/Makefile  |   2 +-
>  drivers/net/ethernet/mellanox/mlx5/core/en.h  | 147 +++-
>  .../ethernet/mellanox/mlx5/core/en/params.c   | 108 ++-
>  .../ethernet/mellanox/mlx5/core/en/params.h   |  87 ++-
>  .../net/ethernet/mellanox/mlx5/core/en/xdp.c  | 231 ++++--
>  .../net/ethernet/mellanox/mlx5/core/en/xdp.h  |  36 +-
>  .../mellanox/mlx5/core/en/xsk/Makefile        |   1 +
>  .../ethernet/mellanox/mlx5/core/en/xsk/rx.c   | 192 +++++
>  .../ethernet/mellanox/mlx5/core/en/xsk/rx.h   |  27 +
>  .../mellanox/mlx5/core/en/xsk/setup.c         | 220 ++++++
>  .../mellanox/mlx5/core/en/xsk/setup.h         |  25 +
>  .../ethernet/mellanox/mlx5/core/en/xsk/tx.c   | 108 +++
>  .../ethernet/mellanox/mlx5/core/en/xsk/tx.h   |  15 +
>  .../ethernet/mellanox/mlx5/core/en/xsk/umem.c | 252 +++++++
>  .../ethernet/mellanox/mlx5/core/en/xsk/umem.h |  34 +
>  .../ethernet/mellanox/mlx5/core/en_ethtool.c  |  21 +-
>  .../mellanox/mlx5/core/en_fs_ethtool.c        |  44 +-
>  .../net/ethernet/mellanox/mlx5/core/en_main.c | 680 +++++++++++-------
>  .../net/ethernet/mellanox/mlx5/core/en_rep.c  |  12 +-
>  .../net/ethernet/mellanox/mlx5/core/en_rx.c   | 104 ++-
>  .../ethernet/mellanox/mlx5/core/en_stats.c    | 115 ++-
>  .../ethernet/mellanox/mlx5/core/en_stats.h    |  30 +
>  .../net/ethernet/mellanox/mlx5/core/en_txrx.c |  42 +-
>  .../ethernet/mellanox/mlx5/core/ipoib/ipoib.c |  14 +-
>  drivers/net/ethernet/mellanox/mlx5/core/wq.h  |   5 -
>  include/net/xdp_sock.h                        |  27 +-
>  include/uapi/linux/if_xdp.h                   |  18 +
>  net/xdp/xsk.c                                 |  43 +-
>  net/xdp/xsk_queue.h                           |  14 +
>  samples/bpf/xdpsock_user.c                    |  52 +-
>  tools/include/uapi/linux/if_xdp.h             |  18 +
>  tools/lib/bpf/xsk.c                           | 127 +++-
>  tools/lib/bpf/xsk.h                           |   6 +-
>  35 files changed, 2384 insertions(+), 500 deletions(-)
>  create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/xsk/Makefile
>  create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c
>  create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.h
>  create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c
>  create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.h
>  create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/xsk/tx.c
>  create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/xsk/tx.h
>  create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/xsk/umem.c
>  create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/xsk/umem.h
>
> --
> 2.19.1
>

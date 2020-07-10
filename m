Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52AB521AD1F
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 04:33:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726832AbgGJCdZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 22:33:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726560AbgGJCdZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jul 2020 22:33:25 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78A62C08C5CE
        for <netdev@vger.kernel.org>; Thu,  9 Jul 2020 19:33:23 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id dg28so3410670edb.3
        for <netdev@vger.kernel.org>; Thu, 09 Jul 2020 19:33:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=herbertland-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XQtWhDwHVdqElFK/QXgJMOyqBqrbGytE8W++797Ka9c=;
        b=FUE89Jy76tjVIiyTChhlTlSMRr3OmgHZpg5F1V0nC84t2gp86HjThmVPEJDQ+4J5ug
         3fx+tPWUrBvfV4DgU1zZ3G/2bRlx0rfcmctYRk0TiFpWU8j+MR6lAeVhas5w346x0lWy
         tXgVoTs3mBKT/UTLR/MotNjwbScKYLC33DXXiUhMZ4GFgZWUgaxt00CKdUfDmPWnh0h1
         S6NCnaYGgy6zVF7elheVyv3Bovi/FHfbcSUUsoZg2c/TOHH6Y64hszwoCZZz0/iDtao3
         2jfcCl4rHWafIXVlYbladC/r4tmDCtSkj6HtfRir4mpTODS5ZHIUnIgnALbVDZ5T8B7T
         Zomw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XQtWhDwHVdqElFK/QXgJMOyqBqrbGytE8W++797Ka9c=;
        b=O5uX4FKbUhtpIz4vb7HHvSEMT+nDMgisu4WhjVguHC3JIk+Fmo2pdjar1F3Bm8sD0J
         /voIvsmkbJPbKQu4FVSZR6iHOU/AG4x85WZWxPx8DWvX6B/0hN9IW6uNbheax12I1ASm
         V2Twty9rAD9S+5EUKdm+j39RNk7SG1HEqjF2TPGLHxnsW71vHFN2rqwYI0F+suUQVh/U
         mzqwIi7JYmLnyO72xrHD1BCthi+Lcx3mO4fBNkS57XTMaOCkQ+foqLo0QRKvMUFPb8ic
         5R7GPMiJVgULygDgvMtkE/w8wTf3p57eJ7I/4FFf/ZhnrIIa/4RVc6ZvtEr4ASi8BvZk
         a+vw==
X-Gm-Message-State: AOAM531bSyv+Ngs4+n9Tq3hPguFrCJ7apMceAF3d+J1WTNr26QbnUJCx
        vL13ON60K5AXbE5kxv7u59V64p/b/Y6s4vOxLrNTtw==
X-Google-Smtp-Source: ABdhPJzrSuoX6LWOAI4bReMpjKESS54UoZfxe1ZCFs7OcGnLWm9e29XHgnyuSGnsthCQGfaGtIR3Y8tLxC5oGlRK+ME=
X-Received: by 2002:a50:d513:: with SMTP id u19mr72895727edi.241.1594348402044;
 Thu, 09 Jul 2020 19:33:22 -0700 (PDT)
MIME-Version: 1.0
References: <20200709011814.4003186-1-kuba@kernel.org>
In-Reply-To: <20200709011814.4003186-1-kuba@kernel.org>
From:   Tom Herbert <tom@herbertland.com>
Date:   Thu, 9 Jul 2020 19:33:11 -0700
Message-ID: <CALx6S34JePNX62=rPq5aTW6W_tpPwSeseGcq13iAaJ9Y53QTiQ@mail.gmail.com>
Subject: Re: [PATCH net-next v2 00/10] udp_tunnel: add NIC RX port offload infrastructure
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Michael Chan <michael.chan@broadcom.com>,
        edwin.peer@broadcom.com, emil.s.tantilov@intel.com,
        alexander.h.duyck@linux.intel.com,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Michal Kubecek <mkubecek@suse.cz>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The patch set looks good for its purpose, but, sorry, I can't resist
another round of complaining about vendors that continue to develop
protocol specific offloads instead of moving to protocol agnostic
generic offloads.

On Wed, Jul 8, 2020 at 6:19 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> Kernel has a facility to notify drivers about the UDP tunnel ports
> so that devices can recognize tunneled packets. This is important
> mostly for RX - devices which don't support CHECKSUM_COMPLETE can
> report checksums of inner packets, and compute RSS over inner headers.

With the more use of various routing headers and other protocols we're
going to see more and more cases where it's impossible for devices to
verify checksums. CHECKSUM_COMPLETE is the only way forward!

> Some drivers also match the UDP tunnel ports also for TX, although
> doing so may lead to false positives and negatives.

Hmm, do you know why they do that? I suppose because they don't
support NETIF_F_HW_CSUM and want to offload an inner checksum so they
need to parse the packet in device, which sadly means they need to
parse the packet in the driver to make sure the device can parse it
and set the checksum. So much driver complexity to support protocol
specific offloads... there is no reason why a driver should ever need
to parse a packet on transmit, everything it needs to know is in the
skbuff. Oh, what a tangled web we weave...

>
> Unfortunately the user experience when trying to take adavantage
> of these facilities is suboptimal. First of all there is no way
> for users to check which ports are offloaded. Many drivers resort
> to printing messages to aid debugging, other use debugfs. Even worse
> the availability of the RX features (NETIF_F_RX_UDP_TUNNEL_PORT)
> is established purely on the basis of the driver having the ndos
> installed. For most drivers, however, the ability to perform offloads
> is contingent on device capabilities (driver support multiple device
> and firmware versions). Unless driver resorts to hackish clearing
> of features set incorrectly by the core - users are left guessing
> whether their device really supports UDP tunnel port offload or not.
>
> There is currently no way to indicate or configure whether RX
> features include just the checksum offload or checksum and using
> inner headers for RSS. Many drivers default to not using inner
> headers for RSS because most implementations populate the source
> port with entropy from the inner headers. This, however, is not
> always the case, for example certain switches are only able to
> use a fixed source port during encapsulation.
>
Well, the concept of devices parsing UDP payloads is marginal to begin
with because of the port number ambiguity problem, but as long as the
device isn't modifying UDP payload data I guess we live with it.

As for RSS over the internal headers, I believe this is another lost
cause. The device can only parse what it's programmed to understand
which will always be less than what the host can do. Device sees a new
encap or extension header it doesn't understand, then it doesn't go
into that header and it hits a roadblock. For IPv6 all this should be
remedied by the flow label anyway which Linux and all other OSes set
by default, so in that case a device doesn't need to do anything more
than parse the IP header to do both RSS and RX csum.

> We have also seen many driver authors get the intricacies of UDP
> tunnel port offloads wrong. Most commonly the drivers forget to
> perform reference counting, or take sleeping locks in the callbacks.
>
> This work tries to improve the situation by pulling the UDP tunnel
> port table maintenance out of the drivers. It turns out that almost
> all drivers maintain a fixed size table of ports (in most cases one
> per tunnel type), so we can take care of all the refcounting in the
> core, and let the driver specify if they need to sleep in the
> callbacks or not. The new common implementation will also support
> replacing ports - when a port is removed from a full table it will
> try to find a previously missing port to take its place.
>
> This patch only implements the core functionality along with a few
> drivers I was hoping to test manually [1] along with a test based
> on a netdevsim implementation. Following patches will convert all
> the drivers. Once that's complete we can remove the ndos, and rely
> directly on the new infrastrucutre.
>
> Then after RSS (RXFH) is converted to netlink we can add the ability
> to configure the use of inner RSS headers for UDP tunnels.
>
> [1] Unfortunately I wasn't able to, turns out 2 of the devices
> I had access to were older generation or had old FW, and they
> did not actually support UDP tunnel port notifications (see
> the second paragraph). The thrid device appears to program
> the UDP ports correctly but it generates bad UDP checksums with
> or without these patches. Long story short - I'd appreciate
> reviews and testing here..
>
> Jakub Kicinski (10):
>   debugfs: make sure we can remove u32_array files cleanly
>   udp_tunnel: re-number the offload tunnel types
>   udp_tunnel: add central NIC RX port offload infrastructure
>   ethtool: add tunnel info interface
>   netdevsim: add UDP tunnel port offload support
>   selftests: net: add a test for UDP tunnel info infra
>   ixgbe: don't clear UDP tunnel ports when RXCSUM is disabled
>   ixgbe: convert to new udp_tunnel_nic infra
>   bnxt: convert to new udp_tunnel_nic infra
>   mlx4: convert to new udp_tunnel_nic infra
>
>  Documentation/filesystems/debugfs.rst         |  12 +-
>  Documentation/networking/ethtool-netlink.rst  |  33 +
>  drivers/net/ethernet/broadcom/bnxt/bnxt.c     | 133 +--
>  drivers/net/ethernet/broadcom/bnxt/bnxt.h     |   6 -
>  drivers/net/ethernet/intel/ixgbe/ixgbe.h      |   3 -
>  drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 200 +---
>  .../net/ethernet/mellanox/mlx4/en_netdev.c    | 107 +--
>  drivers/net/ethernet/mellanox/mlx4/mlx4_en.h  |   2 -
>  drivers/net/geneve.c                          |   6 +-
>  drivers/net/netdevsim/Makefile                |   2 +-
>  drivers/net/netdevsim/dev.c                   |   1 +
>  drivers/net/netdevsim/netdev.c                |  12 +-
>  drivers/net/netdevsim/netdevsim.h             |  19 +
>  drivers/net/netdevsim/udp_tunnels.c           | 192 ++++
>  drivers/net/vxlan.c                           |   6 +-
>  fs/debugfs/file.c                             |  27 +-
>  include/linux/debugfs.h                       |  12 +-
>  include/linux/netdevice.h                     |   8 +
>  include/net/udp_tunnel.h                      | 152 ++-
>  include/uapi/linux/ethtool.h                  |   2 +
>  include/uapi/linux/ethtool_netlink.h          |  55 ++
>  mm/cma.h                                      |   3 +
>  mm/cma_debug.c                                |   7 +-
>  net/ethtool/Makefile                          |   3 +-
>  net/ethtool/common.c                          |   9 +
>  net/ethtool/common.h                          |   1 +
>  net/ethtool/netlink.c                         |  12 +
>  net/ethtool/netlink.h                         |   4 +
>  net/ethtool/strset.c                          |   5 +
>  net/ethtool/tunnels.c                         | 259 +++++
>  net/ipv4/Makefile                             |   3 +-
>  net/ipv4/{udp_tunnel.c => udp_tunnel_core.c}  |   0
>  net/ipv4/udp_tunnel_nic.c                     | 897 ++++++++++++++++++
>  net/ipv4/udp_tunnel_stub.c                    |   7 +
>  .../drivers/net/netdevsim/udp_tunnel_nic.sh   | 786 +++++++++++++++
>  35 files changed, 2597 insertions(+), 389 deletions(-)
>  create mode 100644 drivers/net/netdevsim/udp_tunnels.c
>  create mode 100644 net/ethtool/tunnels.c
>  rename net/ipv4/{udp_tunnel.c => udp_tunnel_core.c} (100%)
>  create mode 100644 net/ipv4/udp_tunnel_nic.c
>  create mode 100644 net/ipv4/udp_tunnel_stub.c
>  create mode 100644 tools/testing/selftests/drivers/net/netdevsim/udp_tunnel_nic.sh
>
> --
> 2.26.2
>

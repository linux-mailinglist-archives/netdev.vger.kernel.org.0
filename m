Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E880646076
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 16:18:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728321AbfFNOSL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 10:18:11 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:37784 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726335AbfFNOSL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jun 2019 10:18:11 -0400
Received: by mail-pf1-f196.google.com with SMTP id 19so1553502pfa.4;
        Fri, 14 Jun 2019 07:18:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=tq2E9BaMBW8aSF1f5kHaKuSm/qfkPHS5HXGl0qPPcFw=;
        b=DxpxUC8lcRD4PyxDEUfU/eby1s+AVG3cNIJEjbQSBMFkoIqB0TxIN6o4YLEIMQDq72
         XOCTyAlv0NeDlG1219jQJDENaj6ig6zHxnl/OQAVHbIh/zlLV2ZIHFUJMkhW9Aoa3UiP
         jCr5gRVO+iJYMxIkeIMDEKtP3h6/UqlDfcc2wfcFpAgQWfcCaJA2Rqis6eqK2NZ/6ROi
         54aL8p6+jj04kOUXabQidHVBhFCrVSiRtscHJEdb5sEAbPOM5q1+EwJ1E7Zvzx/yzy9t
         Z3D2uN8FAlxfepIPreEPrkWu6tGGuhUoQxKfoNzOK+AIcZVjv8GzXwJgowraiT9PhJ+U
         kukQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tq2E9BaMBW8aSF1f5kHaKuSm/qfkPHS5HXGl0qPPcFw=;
        b=eAQiQbuNDVZ4xbZHTYmrTyPlqA4AmpKvvtVC1LjMe+x7Vqev543+D0uCnzJUGeLPjt
         Em9f99vCQsrqreg5ghK6zsYTyFlFnuUPfeFTntgTz7+pWTWF06pXubZRilkAElY4iuqS
         h/UQB+chGYsZzcdDGPSPnU8V2gCTQ+1c55DhhDGMsZvPu8q0Ij4nN1yRVvh8GBXdTtT3
         EMbjvAsyf/sHxJwG0rV52wybF6y2ksTLagJIoN2578N0oV5tNEeTAunzUoXudnxKJDz6
         GwUsD+vh6zLuaXVNltaoaKHzPJJCQSoOm0I8++TL6Jb3zEPa27zRiVaMv90tQt00AHIB
         AbWQ==
X-Gm-Message-State: APjAAAVvWxbwtp+j4tBpcAYXubjlf0zQPQmv3xBM3We6zfEzGsFMO8+J
        Cr9w8gZDFvRx/onBeZtp5u8=
X-Google-Smtp-Source: APXvYqxzTYmH+IIhQb8HZJ2cexLAai0xTnPn8j+b9OOEBpPknUOScLoYj6idws9tz9tor/0Pss5veg==
X-Received: by 2002:aa7:92d2:: with SMTP id k18mr74356pfa.153.1560521890003;
        Fri, 14 Jun 2019 07:18:10 -0700 (PDT)
Received: from localhost ([192.55.54.45])
        by smtp.gmail.com with ESMTPSA id k11sm3163533pfi.168.2019.06.14.07.18.05
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 14 Jun 2019 07:18:09 -0700 (PDT)
Date:   Fri, 14 Jun 2019 16:17:20 +0200
From:   Maciej Fijalkowski <maciejromanfijalkowski@gmail.com>
To:     Maxim Mikityanskiy <maximmi@mellanox.com>
Cc:     Magnus Karlsson <magnus.karlsson@intel.com>,
        "bjorn.topel@intel.com" <bjorn.topel@intel.com>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "brouer@redhat.com" <brouer@redhat.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "bruce.richardson@intel.com" <bruce.richardson@intel.com>,
        "ciara.loftus@intel.com" <ciara.loftus@intel.com>,
        "jakub.kicinski@netronome.com" <jakub.kicinski@netronome.com>,
        "xiaolong.ye@intel.com" <xiaolong.ye@intel.com>,
        "qi.z.zhang@intel.com" <qi.z.zhang@intel.com>,
        "sridhar.samudrala@intel.com" <sridhar.samudrala@intel.com>,
        "kevin.laatz@intel.com" <kevin.laatz@intel.com>,
        "ilias.apalodimas@linaro.org" <ilias.apalodimas@linaro.org>,
        "kiran.patil@intel.com" <kiran.patil@intel.com>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        "maciej.fijalkowski@intel.com" <maciej.fijalkowski@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
Subject: Re: [PATCH bpf-next 0/6] add need_wakeup flag to the AF_XDP rings
Message-ID: <20190614161720.00002da5@gmail.com>
In-Reply-To: <b84b2128-da38-3f0e-35fe-7d1466005dca@mellanox.com>
References: <1560411450-29121-1-git-send-email-magnus.karlsson@intel.com>
        <b84b2128-da38-3f0e-35fe-7d1466005dca@mellanox.com>
X-Mailer: Claws Mail 3.17.1 (GTK+ 2.24.32; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 14 Jun 2019 13:38:04 +0000
Maxim Mikityanskiy <maximmi@mellanox.com> wrote:

> On 2019-06-13 10:37, Magnus Karlsson wrote:
> >=20
> > This patch set adds support for a new flag called need_wakeup in the
> > AF_XDP Tx and fill rings. When this flag is set by the driver, it
> > means that the application has to explicitly wake up the kernel Rx
> > (for the bit in the fill ring) or kernel Tx (for bit in the Tx ring)
> > processing by issuing a syscall. Poll() can wake up both and sendto()
> > will wake up Tx processing only. =20
>=20
> At first sight, sounds useful! (I didn't have time to have a deeper look=
=20
> at the series yet.)
>=20
> I see you are replacing ndo_xsk_async_xmit with another function to=20
> support your extension, and some driver changes are made. Does it mean=20
> that every driver must support the new extension? How about making it=20
> optional? I.e. the kernel can check whether the new NDO is implemented=20
> or not, and use the new feature with drivers that support it.

I think I can speak up for Magnus.
That NDO was just renamed in order to better reflect cases where it is
currently being used, e.g. having ndo_xsk_async_xmit() called in order to g=
et
into NAPI and take the buffers from fill queue was misleading a bit, as you
were waking up the Rx side.

The functionality of that NDO stays the same. Magnus also provided explanat=
ions
in commit messages, which I suppose will clarify it more once you go through
the series.

>=20
> Thanks,
> Max
>=20
> > The main reason for introducing this new flag is to be able to
> > efficiently support the case when application and driver is executing
> > on the same core. Previously, the driver was just busy-spinning on the
> > fill ring if it ran out of buffers in the HW and there were none to
> > get from the fill ring. This approach works when the application and
> > driver is running on different cores as the application can replenish
> > the fill ring while the driver is busy-spinning. Though, this is a
> > lousy approach if both of them are running on the same core as the
> > probability of the fill ring getting more entries when the driver is
> > busy-spinning is zero. With this new feature the driver now sets the
> > need_wakeup flag and returns to the application. The application can
> > then replenish the fill queue and then explicitly wake up the Rx
> > processing in the kernel using the syscall poll(). For Tx, the flag is
> > only set to one if the driver has no outstanding Tx completion
> > interrupts. If it has some, the flag is zero as it will be woken up by
> > a completion interrupt anyway. This flag can also be used in other
> > situations where the driver needs to be woken up explicitly.
> >=20
> > As a nice side effect, this new flag also improves the Tx performance
> > of the case where application and driver are running on two different
> > cores as it reduces the number of syscalls to the kernel. The kernel
> > tells user space if it needs to be woken up by a syscall, and this
> > eliminates many of the syscalls. The Rx performance of the 2-core case
> > is on the other hand slightly worse, since there is a need to use a
> > syscall now to wake up the driver, instead of the driver
> > busy-spinning. It does waste less CPU cycles though, which might lead
> > to better overall system performance.
> >=20
> > This new flag needs some simple driver support. If the driver does not
> > support it, the Rx flag is always zero and the Tx flag is always
> > one. This makes any application relying on this feature default to the
> > old behavior of not requiring any syscalls in the Rx path and always
> > having to call sendto() in the Tx path.
> >=20
> > For backwards compatibility reasons, this feature has to be explicitly
> > turned on using a new bind flag (XDP_USE_NEED_WAKEUP). I recommend
> > that you always turn it on as it has a large positive performance
> > impact for the one core case and does not degrade 2 core performance
> > and actually improves it for Tx heavy workloads.
> >=20
> > Here are some performance numbers measured on my local,
> > non-performance optimized development system. That is why you are
> > seeing numbers lower than the ones from Bj=F6rn and Jesper. 64 byte
> > packets at 40Gbit/s line rate. All results in Mpps. Cores =3D=3D 1 means
> > that both application and driver is executing on the same core. Cores
> > =3D=3D 2 that they are on different cores.
> >=20
> >                                Applications
> > need_wakeup  cores    txpush    rxdrop      l2fwd
> > ---------------------------------------------------------------
> >       n         1       0.07      0.06        0.03
> >       y         1       21.6      8.2         6.5
> >       n         2       32.3      11.7        8.7
> >       y         2       33.1      11.7        8.7
> >=20
> > Overall, the need_wakeup flag provides the same or better performance
> > in all the micro-benchmarks. The reduction of sendto() calls in txpush
> > is large. Only a few per second is needed. For l2fwd, the drop is 50%
> > for the 1 core case and more than 99.9% for the 2 core case. Do not
> > know why I am not seeing the same drop for the 1 core case yet.
> >=20
> > The name and inspiration of the flag has been taken from io_uring by
> > Jens Axboe. Details about this feature in io_uring can be found in
> > http://kernel.dk/io_uring.pdf, section 8.3. It also addresses most of
> > the denial of service and sendto() concerns raised by Maxim
> > Mikityanskiy in https://www.spinics.net/lists/netdev/msg554657.html.
> >=20
> > The typical Tx part of an application will have to change from:
> >=20
> > ret =3D sendto(fd,....)
> >=20
> > to:
> >=20
> > if (xsk_ring_prod__needs_wakeup(&xsk->tx))
> >         ret =3D sendto(fd,....)
> >=20
> > and th Rx part from:
> >=20
> > rcvd =3D xsk_ring_cons__peek(&xsk->rx, BATCH_SIZE, &idx_rx);
> > if (!rcvd)
> >         return;
> >=20
> > to:
> >=20
> > rcvd =3D xsk_ring_cons__peek(&xsk->rx, BATCH_SIZE, &idx_rx);
> > if (!rcvd) {
> >         if (xsk_ring_prod__needs_wakeup(&xsk->umem->fq))
> >                ret =3D poll(fd,.....);
> >         return;
> > }
> >=20
> > This patch has been applied against commit aee450cbe482 ("bpf: silence =
warning messages in core")
> >=20
> > Structure of the patch set:
> >=20
> > Patch 1: Replaces the ndo_xsk_async_xmit with ndo_xsk_wakeup to
> >           support waking up both Rx and Tx processing
> > Patch 2: Implements the need_wakeup functionality in common code
> > Patch 3-4: Add need_wakeup support to the i40e and ixgbe drivers
> > Patch 5: Add need_wakeup support to libbpf
> > Patch 6: Add need_wakeup support to the xdpsock sample application
> >=20
> > Thanks: Magnus
> >=20
> > Magnus Karlsson (6):
> >    xsk: replace ndo_xsk_async_xmit with ndo_xsk_wakeup
> >    xsk: add support for need_wakeup flag in AF_XDP rings
> >    i40e: add support for AF_XDP need_wakup feature
> >    ixgbe: add support for AF_XDP need_wakup feature
> >    libbpf: add support for need_wakeup flag in AF_XDP part
> >    samples/bpf: add use of need_sleep flag in xdpsock
> >=20
> >   drivers/net/ethernet/intel/i40e/i40e_main.c        |   5 +-
> >   drivers/net/ethernet/intel/i40e/i40e_xsk.c         |  23 ++-
> >   drivers/net/ethernet/intel/i40e/i40e_xsk.h         |   2 +-
> >   drivers/net/ethernet/intel/ixgbe/ixgbe_main.c      |   5 +-
> >   .../net/ethernet/intel/ixgbe/ixgbe_txrx_common.h   |   2 +-
> >   drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c       |  20 ++-
> >   include/linux/netdevice.h                          |  18 +-
> >   include/net/xdp_sock.h                             |  33 +++-
> >   include/uapi/linux/if_xdp.h                        |  13 ++
> >   net/xdp/xdp_umem.c                                 |   6 +-
> >   net/xdp/xsk.c                                      |  93 +++++++++-
> >   net/xdp/xsk_queue.h                                |   1 +
> >   samples/bpf/xdpsock_user.c                         | 191 ++++++++++++=
+--------
> >   tools/include/uapi/linux/if_xdp.h                  |  13 ++
> >   tools/lib/bpf/xsk.c                                |   4 +
> >   tools/lib/bpf/xsk.h                                |   6 +
> >   16 files changed, 343 insertions(+), 92 deletions(-)
> >=20
> > --
> > 2.7.4
> >  =20
>=20


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11411471DF
	for <lists+netdev@lfdr.de>; Sat, 15 Jun 2019 21:13:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727141AbfFOTN2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Jun 2019 15:13:28 -0400
Received: from mail-ot1-f65.google.com ([209.85.210.65]:38307 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726870AbfFOTN2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Jun 2019 15:13:28 -0400
Received: by mail-ot1-f65.google.com with SMTP id d17so5772607oth.5;
        Sat, 15 Jun 2019 12:13:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=yqFVFFoktPIo29/wRvwviyxL2VKj2+yDNw0fd7trwrU=;
        b=aHJzUvyExyKQBUsrS/jB9rKuxgKPZQ9WHe4bAjQhQXHfMbEUCPmwhBLpyRtN3t0lOW
         hxUC7oQCkg3wryaH42yAdfqfOLO4zWGDTcYl/MQ/8AXwTHWFwYeAn5uK4qAKwP6Rh4Ic
         1mijcn4oHTJZn1DSk0WxpvhB2s7sfU7jt3uXwWHuntYK6RiDyFiLTYHN4ym8Yb1HmpYp
         gNYRHCOvnBVUWtCWP21+mk2Bmex6BGlFk49k+ZSIngCgjOMl6YWC22lkyoD24gFv/WRm
         K9yIt++8xeVo20U8OBw7vH7rzmrf151OAIXhJwmvQxp91m6xNLpoVaHb7macIBnWnMns
         PDug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=yqFVFFoktPIo29/wRvwviyxL2VKj2+yDNw0fd7trwrU=;
        b=mo1CbqCCJW2whZptsDkt8EN39AlN2VDlfPQSLFzNNopymB0+whKU3OmToja1+FnQBs
         xDlPZi6gg1K4B81y5sIs+8zpp+dM5LxuH8rE3wT2x6S9VUltueI6lDcFoQpGWgezRytk
         0uiMry0kyDrmEXVVP4og1vj7H7QHItklcBJfRQmxwdoz0InfPgL7JEl4MiQjb2n8W7vL
         VYJQIiVEa7tSSnvdJascX3OlXWy9o8pcrOwNaLPTokl7kedw0l/ZLeMAHodRYhxlWbK+
         RMKcqYvwMblmOo6ugjfeEk94OJiwZ4/VEvKR+zN7Hg5wQ46SjUVI8MfetGxBi0NTFpuv
         2PSw==
X-Gm-Message-State: APjAAAV82egMvY3E4Wp0U6wL8CdJfNpqCMZSRTdZD70GyOsM78VaatLz
        RK+eg8GCmL8mrki0xMv7AHkC1bF3KYw1/Nt/SF7UaKtuEBEzOnwD
X-Google-Smtp-Source: APXvYqy+O2k+XywM/+e/Li8NmpnX9SLvfRgDBS55iqXfilXSyBOOU2AnK4O/rcw5X29Pl6gSQmGXDdAME9i0f9yNwqU=
X-Received: by 2002:a9d:77c2:: with SMTP id w2mr10728827otl.192.1560626007210;
 Sat, 15 Jun 2019 12:13:27 -0700 (PDT)
MIME-Version: 1.0
References: <1560411450-29121-1-git-send-email-magnus.karlsson@intel.com>
 <b84b2128-da38-3f0e-35fe-7d1466005dca@mellanox.com> <20190614161720.00002da5@gmail.com>
In-Reply-To: <20190614161720.00002da5@gmail.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Sat, 15 Jun 2019 21:13:15 +0200
Message-ID: <CAJ8uoz2szX=+JXXAMyuVmvSsMXZuDqp6a8rjDQpTioxbZwxFmQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next 0/6] add need_wakeup flag to the AF_XDP rings
To:     Maciej Fijalkowski <maciejromanfijalkowski@gmail.com>
Cc:     Maxim Mikityanskiy <maximmi@mellanox.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 14, 2019 at 4:18 PM Maciej Fijalkowski
<maciejromanfijalkowski@gmail.com> wrote:
>
> On Fri, 14 Jun 2019 13:38:04 +0000
> Maxim Mikityanskiy <maximmi@mellanox.com> wrote:
>
> > On 2019-06-13 10:37, Magnus Karlsson wrote:
> > >
> > > This patch set adds support for a new flag called need_wakeup in the
> > > AF_XDP Tx and fill rings. When this flag is set by the driver, it
> > > means that the application has to explicitly wake up the kernel Rx
> > > (for the bit in the fill ring) or kernel Tx (for bit in the Tx ring)
> > > processing by issuing a syscall. Poll() can wake up both and sendto()
> > > will wake up Tx processing only.
> >
> > At first sight, sounds useful! (I didn't have time to have a deeper loo=
k
> > at the series yet.)
> >
> > I see you are replacing ndo_xsk_async_xmit with another function to
> > support your extension, and some driver changes are made. Does it mean
> > that every driver must support the new extension? How about making it
> > optional? I.e. the kernel can check whether the new NDO is implemented
> > or not, and use the new feature with drivers that support it.
>
> I think I can speak up for Magnus.
> That NDO was just renamed in order to better reflect cases where it is
> currently being used, e.g. having ndo_xsk_async_xmit() called in order to=
 get
> into NAPI and take the buffers from fill queue was misleading a bit, as y=
ou
> were waking up the Rx side.

This is correct. As a side note, the Rx/Tx flag is not used in the
Intel drivers as Rx and Tx is done in the same napi. If you wake up
one, you wake up the other too. I put the flag there as a courtesy for
drivers that have Rx and Tx in different napi contexts. If there are
no such drivers out there, let me know and I will remove it.

The other small change that is done to the drivers in patch 2 is that
one of the new functions xsk_[set|clear]_[rx|tx]_need_wakeup need to
be called at the end of Rx and Tx processing respectively. These just
indicate if the flag (Rx or Tx) should be set or cleared. Basically,
does the driver need to be woken up or not. To your point about
compatibility, if the driver does not support this but the application
does: the Rx flag is default set to 0 and the Tx flag is set to 1. If
the driver does not support changing the flag (i.e., it has no support
for this), the app will not call any poll() for Rx since the flag is 0
and always call sendto() for Tx as that flag is always one. This
defaults to the same behavior as previously. The driver will busy-poll
the fill queue and the application will slam sendto() at regular
intervals as it has no idea if it is needed or not.

With that said, I noticed that I forgot to put the Tx flag
initialization to one in the code, sigh. Will fix that in v2.

These lines in xdp_assign_dev() in xdp_umem.c

if (flags & XDP_USE_NEED_WAKEUP)
                umem->flags |=3D XDP_UMEM_MIGHT_SLEEP;

should be:

if (flags & XDP_USE_NEED_WAKEUP) {
                umem->flags |=3D XDP_UMEM_MIGHT_SLEEP;
                /* Tx needs to be explicitly woken up the first time.
                 * Also for supporting drivers that do not implement this
                 * feature. They will always have to call sendto().
                 */
                xsk_set_tx_need_wakeup(umem);
        }

Thanks: Magnus

> The functionality of that NDO stays the same. Magnus also provided explan=
ations
> in commit messages, which I suppose will clarify it more once you go thro=
ugh
> the series.
>
> >
> > Thanks,
> > Max
> >
> > > The main reason for introducing this new flag is to be able to
> > > efficiently support the case when application and driver is executing
> > > on the same core. Previously, the driver was just busy-spinning on th=
e
> > > fill ring if it ran out of buffers in the HW and there were none to
> > > get from the fill ring. This approach works when the application and
> > > driver is running on different cores as the application can replenish
> > > the fill ring while the driver is busy-spinning. Though, this is a
> > > lousy approach if both of them are running on the same core as the
> > > probability of the fill ring getting more entries when the driver is
> > > busy-spinning is zero. With this new feature the driver now sets the
> > > need_wakeup flag and returns to the application. The application can
> > > then replenish the fill queue and then explicitly wake up the Rx
> > > processing in the kernel using the syscall poll(). For Tx, the flag i=
s
> > > only set to one if the driver has no outstanding Tx completion
> > > interrupts. If it has some, the flag is zero as it will be woken up b=
y
> > > a completion interrupt anyway. This flag can also be used in other
> > > situations where the driver needs to be woken up explicitly.
> > >
> > > As a nice side effect, this new flag also improves the Tx performance
> > > of the case where application and driver are running on two different
> > > cores as it reduces the number of syscalls to the kernel. The kernel
> > > tells user space if it needs to be woken up by a syscall, and this
> > > eliminates many of the syscalls. The Rx performance of the 2-core cas=
e
> > > is on the other hand slightly worse, since there is a need to use a
> > > syscall now to wake up the driver, instead of the driver
> > > busy-spinning. It does waste less CPU cycles though, which might lead
> > > to better overall system performance.
> > >
> > > This new flag needs some simple driver support. If the driver does no=
t
> > > support it, the Rx flag is always zero and the Tx flag is always
> > > one. This makes any application relying on this feature default to th=
e
> > > old behavior of not requiring any syscalls in the Rx path and always
> > > having to call sendto() in the Tx path.
> > >
> > > For backwards compatibility reasons, this feature has to be explicitl=
y
> > > turned on using a new bind flag (XDP_USE_NEED_WAKEUP). I recommend
> > > that you always turn it on as it has a large positive performance
> > > impact for the one core case and does not degrade 2 core performance
> > > and actually improves it for Tx heavy workloads.
> > >
> > > Here are some performance numbers measured on my local,
> > > non-performance optimized development system. That is why you are
> > > seeing numbers lower than the ones from Bj=C3=B6rn and Jesper. 64 byt=
e
> > > packets at 40Gbit/s line rate. All results in Mpps. Cores =3D=3D 1 me=
ans
> > > that both application and driver is executing on the same core. Cores
> > > =3D=3D 2 that they are on different cores.
> > >
> > >                                Applications
> > > need_wakeup  cores    txpush    rxdrop      l2fwd
> > > ---------------------------------------------------------------
> > >       n         1       0.07      0.06        0.03
> > >       y         1       21.6      8.2         6.5
> > >       n         2       32.3      11.7        8.7
> > >       y         2       33.1      11.7        8.7
> > >
> > > Overall, the need_wakeup flag provides the same or better performance
> > > in all the micro-benchmarks. The reduction of sendto() calls in txpus=
h
> > > is large. Only a few per second is needed. For l2fwd, the drop is 50%
> > > for the 1 core case and more than 99.9% for the 2 core case. Do not
> > > know why I am not seeing the same drop for the 1 core case yet.
> > >
> > > The name and inspiration of the flag has been taken from io_uring by
> > > Jens Axboe. Details about this feature in io_uring can be found in
> > > http://kernel.dk/io_uring.pdf, section 8.3. It also addresses most of
> > > the denial of service and sendto() concerns raised by Maxim
> > > Mikityanskiy in https://www.spinics.net/lists/netdev/msg554657.html.
> > >
> > > The typical Tx part of an application will have to change from:
> > >
> > > ret =3D sendto(fd,....)
> > >
> > > to:
> > >
> > > if (xsk_ring_prod__needs_wakeup(&xsk->tx))
> > >         ret =3D sendto(fd,....)
> > >
> > > and th Rx part from:
> > >
> > > rcvd =3D xsk_ring_cons__peek(&xsk->rx, BATCH_SIZE, &idx_rx);
> > > if (!rcvd)
> > >         return;
> > >
> > > to:
> > >
> > > rcvd =3D xsk_ring_cons__peek(&xsk->rx, BATCH_SIZE, &idx_rx);
> > > if (!rcvd) {
> > >         if (xsk_ring_prod__needs_wakeup(&xsk->umem->fq))
> > >                ret =3D poll(fd,.....);
> > >         return;
> > > }
> > >
> > > This patch has been applied against commit aee450cbe482 ("bpf: silenc=
e warning messages in core")
> > >
> > > Structure of the patch set:
> > >
> > > Patch 1: Replaces the ndo_xsk_async_xmit with ndo_xsk_wakeup to
> > >           support waking up both Rx and Tx processing
> > > Patch 2: Implements the need_wakeup functionality in common code
> > > Patch 3-4: Add need_wakeup support to the i40e and ixgbe drivers
> > > Patch 5: Add need_wakeup support to libbpf
> > > Patch 6: Add need_wakeup support to the xdpsock sample application
> > >
> > > Thanks: Magnus
> > >
> > > Magnus Karlsson (6):
> > >    xsk: replace ndo_xsk_async_xmit with ndo_xsk_wakeup
> > >    xsk: add support for need_wakeup flag in AF_XDP rings
> > >    i40e: add support for AF_XDP need_wakup feature
> > >    ixgbe: add support for AF_XDP need_wakup feature
> > >    libbpf: add support for need_wakeup flag in AF_XDP part
> > >    samples/bpf: add use of need_sleep flag in xdpsock
> > >
> > >   drivers/net/ethernet/intel/i40e/i40e_main.c        |   5 +-
> > >   drivers/net/ethernet/intel/i40e/i40e_xsk.c         |  23 ++-
> > >   drivers/net/ethernet/intel/i40e/i40e_xsk.h         |   2 +-
> > >   drivers/net/ethernet/intel/ixgbe/ixgbe_main.c      |   5 +-
> > >   .../net/ethernet/intel/ixgbe/ixgbe_txrx_common.h   |   2 +-
> > >   drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c       |  20 ++-
> > >   include/linux/netdevice.h                          |  18 +-
> > >   include/net/xdp_sock.h                             |  33 +++-
> > >   include/uapi/linux/if_xdp.h                        |  13 ++
> > >   net/xdp/xdp_umem.c                                 |   6 +-
> > >   net/xdp/xsk.c                                      |  93 +++++++++-
> > >   net/xdp/xsk_queue.h                                |   1 +
> > >   samples/bpf/xdpsock_user.c                         | 191 ++++++++++=
+++--------
> > >   tools/include/uapi/linux/if_xdp.h                  |  13 ++
> > >   tools/lib/bpf/xsk.c                                |   4 +
> > >   tools/lib/bpf/xsk.h                                |   6 +
> > >   16 files changed, 343 insertions(+), 92 deletions(-)
> > >
> > > --
> > > 2.7.4
> > >
> >
>

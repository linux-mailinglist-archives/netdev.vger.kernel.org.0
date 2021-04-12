Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFC2135D09D
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 20:53:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236725AbhDLSxp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 14:53:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230064AbhDLSxp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Apr 2021 14:53:45 -0400
Received: from mail-ot1-x330.google.com (mail-ot1-x330.google.com [IPv6:2607:f8b0:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCF56C06174A
        for <netdev@vger.kernel.org>; Mon, 12 Apr 2021 11:53:26 -0700 (PDT)
Received: by mail-ot1-x330.google.com with SMTP id v24-20020a9d69d80000b02901b9aec33371so13819875oto.2
        for <netdev@vger.kernel.org>; Mon, 12 Apr 2021 11:53:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=q2c2bk4hAZv4IyXDtl2zFlaq8cOREJUwdyV+adc37xQ=;
        b=ahRnXFg+qJQ/5cQIanHCUpnM9kuddJNfB3qXIvfYI8qhgZcW6xNoRw2daO6UzD+w0K
         JA0bRZaZH15rZo6d1ICZFXSDWA4WaJvNbRMO8YBpJxPpykFr8t6nIK+W6kNi4iIzMg9A
         V13LO+HVJylG5O1b6RDkj85aRq+K5emT97phWu0yo/lAdx1rcThuKAlGeIH2Aa0nOgAd
         XyIk/cj9On6bshY1BxOqVLszek6lt3r1xuPheWgFKog95pwAWOtLMj3erJt/WE9mIrAc
         gw5N/8yR5OYEZdblsRDxzyxisMMraqJtoJByH1Fr45Bj6pOkC2SxToQ73w9oyHqTdSPg
         qbUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=q2c2bk4hAZv4IyXDtl2zFlaq8cOREJUwdyV+adc37xQ=;
        b=Y7oJrZr3GUtR3E11XNebhp10uA65mSzTuvXQbXFrmGdf1OMq3heRaslG2evuS78O42
         B4WweqSQK0JR2k1G4FqnCghaDCBSZRe7MwRBnG6JDZjdVAtiQ4KDlSqwUpv5y3lCfaVy
         GenmsHWufLpZvASs0A649CJMumjSf8O+8TDnsIG4HSUzvc63WiSvnKTyW3f7nSPi+bwY
         31Sn0qDV4FlFwhPVelP3O/+awMjcv3oE6sJnZBEks6h43wnveB4RhDs3awucGdbDZg1A
         +NGjCUFV+rBKCyyP+2cIxXFwYY8tq5ViWwaUfW9PIN2IEX4esGJa9aIsfD/4EUTsceME
         KcpA==
X-Gm-Message-State: AOAM533iI7KI84asZ38o2qVN1pFto7E5yoQ7miuTI6he0/XsaTTNjSIT
        3iQJXtDzrSaKWYWYFy78irGhh+34UVKrVYhMpexI1A==
X-Google-Smtp-Source: ABdhPJymT0/XuxJEv3V6pf63kR+k0XtHJ2ohWWNDUrFefR6PqXGWKyVFM7EOI2TMjTDJIUXpgDuvoXkyE8WlU2DxbrU=
X-Received: by 2002:a05:6830:22c3:: with SMTP id q3mr24732558otc.56.1618253606238;
 Mon, 12 Apr 2021 11:53:26 -0700 (PDT)
MIME-Version: 1.0
References: <20210406183112.1150657-1-jiang.wang@bytedance.com>
 <1D46A084-5B77-4803-8B5F-B2F36541DA10@vmware.com> <CAP_N_Z-KFUYZc7p1z_-9nb9CvjtyGFkgkX1PEbh-SgKbX_snQw@mail.gmail.com>
 <20210412140437.6k3zxw2cv4p54lvm@steredhat>
In-Reply-To: <20210412140437.6k3zxw2cv4p54lvm@steredhat>
From:   "Jiang Wang ." <jiang.wang@bytedance.com>
Date:   Mon, 12 Apr 2021 11:53:15 -0700
Message-ID: <CAP_N_Z9yi96YDW3gJdCFrPJpNhwpJnaT8gruk7JJSsBne8J-8Q@mail.gmail.com>
Subject: Re: Re: [RFC] vsock: add multiple transports support for dgram
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     Jorgen Hansen <jhansen@vmware.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "cong.wang@bytedance.com" <cong.wang@bytedance.com>,
        "duanxiongchun@bytedance.com" <duanxiongchun@bytedance.com>,
        "xieyongji@bytedance.com" <xieyongji@bytedance.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Colin Ian King <colin.king@canonical.com>,
        Norbert Slusarek <nslusarek@gmx.net>,
        Andra Paraschiv <andraprs@amazon.com>,
        Alexander Popov <alex.popov@linux.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 12, 2021 at 7:04 AM Stefano Garzarella <sgarzare@redhat.com> wr=
ote:
>
> Hi Jiang,
> thanks for re-starting the multi-transport support for dgram!

No problem.

> On Wed, Apr 07, 2021 at 11:25:36AM -0700, Jiang Wang . wrote:
> >On Wed, Apr 7, 2021 at 2:51 AM Jorgen Hansen <jhansen@vmware.com> wrote:
> >>
> >>
> >> > On 6 Apr 2021, at 20:31, Jiang Wang <jiang.wang@bytedance.com> wrote=
:
> >> >
> >> > From: "jiang.wang" <jiang.wang@bytedance.com>
> >> >
> >> > Currently, only VMCI supports dgram sockets. To supported
> >> > nested VM use case, this patch removes transport_dgram and
> >> > uses transport_g2h and transport_h2g for dgram too.
>
> I agree on this part, I think that's the direction to go.
> transport_dgram was added as a shortcut.

Got it.

> >>
> >> Could you provide some background for introducing this change - are yo=
u
> >> looking at introducing datagrams for a different transport? VMCI datag=
rams
> >> already support the nested use case,
> >
> >Yes, I am trying to introduce datagram for virtio transport. I wrote a
> >spec patch for
> >virtio dgram support and also a code patch, but the code patch is still =
WIP.
> >When I wrote this commit message, I was thinking nested VM is the same a=
s
> >multiple transport support. But now, I realize they are different.
> >Nested VMs may use
> >the same virtualization layer(KVM on KVM), or different virtualization l=
ayers
> >(KVM on ESXi). Thanks for letting me know that VMCI already supported ne=
sted
> >use cases. I think you mean VMCI on VMCI, right?
> >
> >> but if we need to support multiple datagram
> >> transports we need to rework how we administer port assignment for dat=
agrams.
> >> One specific issue is that the vmci transport won=E2=80=99t receive an=
y datagrams for a
> >> port unless the datagram socket has already been assigned the vmci tra=
nsport
> >> and the port bound to the underlying VMCI device (see below for more d=
etails).
> >>
> >I see.
> >
> >> > The transport is assgined when sending every packet and
> >> > receiving every packet on dgram sockets.
> >>
> >> Is the intent that the same datagram socket can be used for sending pa=
ckets both
> >> In the host to guest, and the guest to directions?
> >
> >Nope. One datagram socket will only send packets to one direction, eithe=
r to the
> >host or to the guest. My above description is wrong. When sending packet=
s, the
> >transport is assigned with the first packet (with auto_bind).
>
> I'm not sure this is right.
> The auto_bind on the first packet should only assign a local port to the
> socket, but does not affect the transport to be used.
>
> A user could send one packet to the nested guest and another to the host
> using the same socket, or am I wrong?

OK. I think you are right.

> >
> >The problem is when receiving packets. The listener can bind to the
> >VMADDR_CID_ANY
> >address. Then it is unclear which transport we should use. For stream
> >sockets, there will be a new socket for each connection, and transport
> >can be decided
> >at that time. For datagram sockets, I am not sure how to handle that.
>
> yes, this I think is the main problem, but maybe the sender one is even
> more complicated.
>
> Maybe we should remove the 1:1 association we have now between vsk and
> transport.

Yes, I thought about that too. One idea is to define two transports in vsk.
For sending pkt, we can pick the right transport when we get the packet, li=
ke
in virtio_transport_send_pkt_info(). For receiving pkts, we have to check
and call both
transports dequeue callbacks if the local cid is CID_ANY.

> At least for DGRAM, for connected sockets I think the association makes
> sense.

Yeah. For a connected socket, we will only use one transport.

> >For VMCI, does the same transport can be used for both receiving from
> >host and from
> >the guest?
>
> Yes, they're registered at different times, but it's the same transport.
>
> >
> >For virtio, the h2g and g2h transports are different,, so we have to
> >choose
> >one of them. My original thought is to wait until the first packet
> >arrives.
> >
> >Another idea is that we always bind to host addr and use h2g
> >transport because I think that might
> >be more common. If a listener wants to recv packets from the host, then
> >it
> >should bind to the guest addr instead of CID_ANY.
>
> Yes, I remember we discussed this idea, this would simplify the
> receiving, but there is still the issue of a user wanting to receive
> packets from both the nested guest and the host.

OK. Agree.

> >Any other suggestions?
> >
>
> I think one solution could be to remove the 1:1 association between
> DGRAM socket and transport.
>
> IIUC VMCI creates a skb for each received packet and queues it through
> sk_receive_skb() directly in the struct sock.
>
> Then the .dgram_dequeue() callback dequeues them using
> skb_recv_datagram().
>
> We can move these parts in the vsock core, and create some helpers to
> allow the transports to enqueue received DGRAM packets in the same way
> (and with the same format) directly in the struct sock.
>

I agree to use skbs (and move them to vscok core). We have another use case
which will need to use skb. But I am not sure how this helps with multiple
transport cases. Each transport has a dgram_dequeue callback. So we still
need to let vsk have multiple transports somehow. Could you elaborate how
using skb help with multiple transport support? Will that be similar to wha=
t I
mentioned above? Thanks.

Regards,

Jiang

> What do you think?
>
> Thanks,
> Stefano
>

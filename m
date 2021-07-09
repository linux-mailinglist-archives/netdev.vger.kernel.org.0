Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B0A33C2698
	for <lists+netdev@lfdr.de>; Fri,  9 Jul 2021 17:05:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232244AbhGIPHt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Jul 2021 11:07:49 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:23098 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231963AbhGIPHs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Jul 2021 11:07:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625843104;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oXpbJbmACSEuV8xJQe8Sj6A86gRDQbCV3Fj44KkNFnk=;
        b=X3c10Vk7eClemuC3YQjtmB2C6ZakI5gTTidYNxTIGXSuQzH6szKEGADevwH8YO7VEAizYX
        f3B2w58vsGWyP5ARKsrBrGgEcjKDRzFghXsj84TR1nVWYDsTvuofONUjCAbSjunlLX1aBl
        SSUGJ4iadeVH5nYoY69i0KDmXPBTJIc=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-244-Cdiwj2C_PratvjdSE-aqVw-1; Fri, 09 Jul 2021 11:05:03 -0400
X-MC-Unique: Cdiwj2C_PratvjdSE-aqVw-1
Received: by mail-qv1-f71.google.com with SMTP id q2-20020ad45ca20000b02902b1554c2318so6535800qvh.11
        for <netdev@vger.kernel.org>; Fri, 09 Jul 2021 08:05:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=oXpbJbmACSEuV8xJQe8Sj6A86gRDQbCV3Fj44KkNFnk=;
        b=O2peUr6f/scAYi+1jiWOfQrAlGkgDm6nOZA4n+A56BYNTVwzR+FX1jjrzH/RCaVKrL
         cPhEe0gjH5WW0dGA2fRzx5WJMFNw9CehCDzM6Zsm2MZj71h8gOu6QjL6dIRF7HUYmvzV
         9RHLrsYjgAb8HPZpuT8UANfG4pBcZEp54NNtEQryBDwjGsCUfySyuXDxdGSeka8fE+I6
         dDnsClGAHW2FPQizTlBOtJcPhKjUNVaB/gdKMEIrZq7uW8EVRHazPZw6dEbVXC+Qg2nA
         yKhpjorgQh2JZWWfACKDW/Mgubv9T6jNYdhZauQmuI9m8h4fqL1I4e3QO/FcwDkPM8q+
         L93w==
X-Gm-Message-State: AOAM531MKs15QtjvxVHscAuejiPClflyBcMIDgLs8IBGZ3R6Yg4W32W6
        TTAqw4q0Ypd9f1Oc9qpHitOAPxUVX7wbbnpw02EwpWllj5NM/OeBMXyA/yOV9DdEi2Y+nwdYEvV
        Urt2L9sGl1SGH6IepLmIYWkApF4pO0eNG
X-Received: by 2002:a05:620a:d42:: with SMTP id o2mr37870643qkl.233.1625843102700;
        Fri, 09 Jul 2021 08:05:02 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxAK1wPKDUuWgrKX5D8U4lB6fY29PZXvDE1tKYCc+sg3DauZGvNpp75sqLliZNUh/dox7ky9ZlP4VJhYcYKpBk=
X-Received: by 2002:a05:620a:d42:: with SMTP id o2mr37870624qkl.233.1625843102487;
 Fri, 09 Jul 2021 08:05:02 -0700 (PDT)
MIME-Version: 1.0
References: <03ee62602dd7b7101f78e0802249a6e2e4c10b7f.camel@infradead.org>
 <20210624123005.1301761-1-dwmw2@infradead.org> <20210624123005.1301761-3-dwmw2@infradead.org>
 <b339549d-c8f1-1e56-2759-f7b15ee8eca1@redhat.com> <bfad641875aff8ff008dd7f9a072c5aa980703f4.camel@infradead.org>
 <1c6110d9-2a45-f766-9d9a-e2996c14b748@redhat.com> <72dfecd426d183615c0dd4c2e68690b0e95dd739.camel@infradead.org>
 <80f61c54a2b39cb129e8606f843f7ace605d67e0.camel@infradead.org>
 <99496947-8171-d252-66d3-0af12c62fd2c@redhat.com> <cdf3fe3ceff17bc2a5aaf006577c1cb0bef40f3a.camel@infradead.org>
 <500370cc-d030-6c2d-8e96-533a3533a8e2@redhat.com> <aa70346d6983a0146b2220e93dac001706723fe3.camel@infradead.org>
 <b6192a2a-0226-2767-46b2-ae61494a8ae7@redhat.com> <1d5b8251e8d9e67613295d5b7f51c49c1ee8c0a8.camel@infradead.org>
 <ccf524ce-17f8-3763-0f86-2afbcf6aa6fc@redhat.com> <511df01a3641c2010d875a61161d6da7093abd4a.camel@infradead.org>
In-Reply-To: <511df01a3641c2010d875a61161d6da7093abd4a.camel@infradead.org>
From:   Eugenio Perez Martin <eperezma@redhat.com>
Date:   Fri, 9 Jul 2021 17:04:26 +0200
Message-ID: <CAJaqyWdZTfjeDgUj1Rindufvq=XYMEdQP8gfGZ3i0a4khKAWxA@mail.gmail.com>
Subject: Re: [PATCH v3 3/5] vhost_net: remove virtio_net_hdr validation, let
 tun/tap do it themselves
To:     David Woodhouse <dwmw2@infradead.org>
Cc:     Jason Wang <jasowang@redhat.com>, netdev@vger.kernel.org,
        Willem de Bruijn <willemb@google.com>,
        "Michael S.Tsirkin" <mst@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 2, 2021 at 10:08 AM David Woodhouse <dwmw2@infradead.org> wrote=
:
>
> On Fri, 2021-07-02 at 11:13 +0800, Jason Wang wrote:
> > =E5=9C=A8 2021/7/2 =E4=B8=8A=E5=8D=881:39, David Woodhouse =E5=86=99=E9=
=81=93:
> > >
> > > Right, but the VMM (or the guest, if we're letting the guest choose)
> > > wouldn't have to use it for those cases.
> >
> >
> > I'm not sure I get here. If so, simply write to TUN directly would work=
.
>
> As noted, that works nicely for me in OpenConnect; I just write it to
> the tun device *instead* of putting it in the vring. My TX latency is
> now fine; it's just RX which takes *two* scheduler wakeups (tun wakes
> vhost thread, wakes guest).
>

Maybe we can do a small test to see the effect of warming up the userland?
* Make vhost to write irqfd BEFORE add the packet to the ring, not after.
* Make userland (I think your selftest would be fine for this) to spin
reading used idx until it sees at least one buffer.

I think this introduces races in the general virtio ring management
but should work well for the testing. Any thoughts?

We could also check what happens in case of burning the userland CPU
checking for used_idx and disable notifications, and see if it is
worth keeping shaving latency in that direction :).

> But it's not clear to me that a VMM could use it. Because the guest has
> already put that packet *into* the vring. Now if the VMM is in the path
> of all wakeups for that vring, I suppose we *might* be able to contrive
> some hackish way to be 'sure' that the kernel isn't servicing it, so we
> could try to 'steal' that packet from the ring in order to send it
> directly... but no. That's awful :)
>
> I do think it'd be interesting to look at a way to reduce the latency
> of the vring wakeup especially for that case of a virtio-net guest with
> a single small packet to send. But realistically speaking, I'm unlikely
> to get to it any time soon except for showing the numbers with the
> userspace equivalent and observing that there's probably a similar win
> to be had for guests too.
>
> In the short term, I should focus on what we want to do to finish off
> my existing fixes. Did we have a consensus on whether to bother
> supporting PI? As I said, I'm mildly inclined to do so just because it
> mostly comes out in the wash as we fix everything else, and making it
> gracefully *refuse* that setup reliably is just as hard.
>
> I think I'll try to make the vhost-net code much more resilient to
> finding that tun_recvmsg() returns a header other than the sock_hlen it
> expects, and see how much still actually needs "fixing" if we can do
> that.
>
>
> > I think the design is to delay the tx checksum as much as possible:
> >
> > 1) host RX -> TAP TX -> Guest RX -> Guest TX -> TX RX -> host TX
> > 2) VM1 TX -> TAP RX -> switch -> TX TX -> VM2 TX
> >
> > E.g  if the checksum is supported in all those path, we don't need any
> > software checksum at all in the above path. And if any part is not
> > capable of doing checksum, the checksum will be done by networking core
> > before calling the hard_start_xmit of that device.
>
> Right, but in *any* case where the 'device' is going to memcpy the data
> around (like tun_put_user() does), it's a waste of time having the
> networking core do a *separate* pass over the data just to checksum it.
>
> > > > > We could similarly do a partial checksum in tun_get_user() and ha=
nd it
> > > > > off to the network stack with ->ip_summed =3D=3D CHECKSUM_PARTIAL=
.
> > > >
> > > > I think that's is how it is expected to work (via vnet header), see
> > > > virtio_net_hdr_to_skb().
> > >
> > > But only if the "guest" supports it; it doesn't get handled by the tu=
n
> > > device. It *could*, since we already have the helpers to checksum *as=
*
> > > we copy to/from userspace.
> > >
> > > It doesn't help for me to advertise that I support TX checksums in
> > > userspace because I'd have to do an extra pass for that. I only do on=
e
> > > pass over the data as I encrypt it, and in many block cipher modes th=
e
> > > encryption of the early blocks affects the IV for the subsequent
> > > blocks... do I can't just go back and "fix" the checksum at the start
> > > of the packet, once I'm finished.
> > >
> > > So doing the checksum as the packet is copied up to userspace would b=
e
> > > very useful.
> >
> >
> > I think I get this, but it requires a new TUN features (and maybe make
> > it userspace controllable via tun_set_csum()).
>
> I don't think it's visible to userspace at all; it's purely between the
> tun driver and the network stack. We *always* set NETIF_F_HW_CSUM,
> regardless of what the user can cope with. And if the user *didn't*
> support checksum offload then tun will transparently do the checksum
> *during* the copy_to_iter() (in either tun_put_user_xdp() or
> tun_put_user()).
>
> Userspace sees precisely what it did before. If it doesn't support
> checksum offload then it gets a pre-checksummed packet just as before.
> It's just that the kernel will do that checksum *while* it's already
> touching the data as it copies it to userspace, instead of in a
> separate pass.
>
> Although actually, for my *benchmark* case with iperf3 sending UDP, I
> spotted in the perf traces that we actually do the checksum as we're
> copying from userspace in the udp_sendmsg() call. There's a check in
> __ip_append_data() which looks to see if the destination device has
> HW_CSUM|IP_CSUM features, and does the copy-and-checksum if not. There
> are definitely use cases which *don't* have that kind of optimisation
> though, and packets that would reach tun_net_xmit() with CHECKSUM_NONE.
> So I think it's worth looking at.
>


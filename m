Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C453637F3ED
	for <lists+netdev@lfdr.de>; Thu, 13 May 2021 10:15:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231695AbhEMIQY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 May 2021 04:16:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230318AbhEMIQW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 May 2021 04:16:22 -0400
Received: from mail-oo1-xc32.google.com (mail-oo1-xc32.google.com [IPv6:2607:f8b0:4864:20::c32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72C24C06174A
        for <netdev@vger.kernel.org>; Thu, 13 May 2021 01:15:12 -0700 (PDT)
Received: by mail-oo1-xc32.google.com with SMTP id l25-20020a4a35190000b029020a54735152so1534964ooa.4
        for <netdev@vger.kernel.org>; Thu, 13 May 2021 01:15:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=aasFNrGPhd1j95YGs4IN8C+Ann70ZEOsBSeAoS3Dquc=;
        b=FgRd4S5mQI4uPqrArD7NNLtUWWEQExXgzxXE7I09ngYJdo9Avo10R6yRLDgZ5s2/6l
         synxTCie/7qazENQLROJCEiesS8U1zE1WZihOvrm9o0X8N2SR5uEexuBpT4MxTur5lVZ
         +aGycbkGr1hqtWAzSxSHixnaylr/972mzSJEClMt6VBxBPMeqBy6l0RVh1FisJImna88
         dJat/3XnyWzQyKdV/8ojviJXIj0Si14zVisj2X4hGdqNhOiBcj+GrLkowWwnneKEH9ft
         SrZBHZPkVNRts2TsKYYIDdhLmS6ubKYfiM4uHfikhNEfaPJB18d48k0F9YziAX9CYDUw
         rhRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=aasFNrGPhd1j95YGs4IN8C+Ann70ZEOsBSeAoS3Dquc=;
        b=bWFBNwZXg3qYM33wIwz0vdMA4mZKr5wJ9H02UNUAj+Wi3v3MBZpwjGXyq/+bnvqHXh
         t9dM3+BgFMdmEYBSbj+llfxbZzsGlLnET0a7xdj+ghDU5lfAKjog82d+Ue3fd/g8UPOB
         2dRlNuphIsF2I98xok+IYHycMmq0yE20LUsO8ccJa3/4qqU19KoSscGdjW8HqQCbGAU6
         XuiQn3iiv+kOrcqUAgTY4y04ypinvstZIWRAKC2cXuPbU0fuKv8JlWmPP6HjTTiJWThr
         DJzuVDnaq4CHuK1a53UaP9YTJdc/bIO3RczBFHGsoY5jOuxeVUCl+Ryb1OcjY4kx6mmq
         bUHw==
X-Gm-Message-State: AOAM531IT6xdc2eQ0O87NNuuRNaklk6NwZLeSpXK+aNB4InnW7EgilO3
        EIGFwHrz+hPUTNADcnNcgwMVVh1wQBUaDAJIIPijyc8JBXkLww==
X-Google-Smtp-Source: ABdhPJyStCuG4H38CtGEsMNsEIxdfX6dofY62H2IsjGc96VsdMKUxff2uYB4KWMZPftWGnS3aRaxspRbGYC7HEhnpl4=
X-Received: by 2002:a4a:98a4:: with SMTP id a33mr31069654ooj.21.1620893711726;
 Thu, 13 May 2021 01:15:11 -0700 (PDT)
MIME-Version: 1.0
References: <20210511044253.469034-1-yuri.benditovich@daynix.com>
 <20210511044253.469034-5-yuri.benditovich@daynix.com> <eb8c4984-f0cc-74ee-537f-fc60deaaaa73@redhat.com>
 <CAOEp5OdrCDPx4ijLcEOm=Wxma6hc=nyqw4Xm6bggBxvgtR0tbg@mail.gmail.com>
 <89759261-3a72-df6c-7a81-b7a48abfad44@redhat.com> <CAOEp5Ocm9Q69Fv=oeyCs01F9J4nCTPiOPpw9_BRZ0WnF+LtEFQ@mail.gmail.com>
 <CACGkMEsZBCzV+d_eLj1aYT+pkS5m1QAy7q8rUkNsdV0C8aL8tQ@mail.gmail.com>
 <CAOEp5OeSankfA6urXLW_fquSMrZ+WYXDtKNacort1UwR=WgxqA@mail.gmail.com>
 <CACGkMEt3bZrdqbWtWjSkXvv5v8iCHiN8hkD3T602RZnb6nPd9A@mail.gmail.com>
 <CAOEp5Odw=eaQWZCXr+U8PipPtO1Avjw-t3gEdKyvNYxuNa5TfQ@mail.gmail.com>
 <CACGkMEuqXaJxGqC+CLoq7k4XDu+W3E3Kk3WvG-D6tnn2K4ZPNA@mail.gmail.com>
 <CAOEp5OfB62SQzxMj_GkVD4EM=Z+xf43TPoTZwMbPPa3BsX2ooA@mail.gmail.com> <CACGkMEu4NdyMoFKbyUGG1aGX+K=ShMZuVuMKYPauEBYz5pxYzA@mail.gmail.com>
In-Reply-To: <CACGkMEu4NdyMoFKbyUGG1aGX+K=ShMZuVuMKYPauEBYz5pxYzA@mail.gmail.com>
From:   Yuri Benditovich <yuri.benditovich@daynix.com>
Date:   Thu, 13 May 2021 11:14:59 +0300
Message-ID: <CAOEp5Oe7FQQFbO7KDiyBPs1=ox+6rOimOwounTHBuVki2Y3DAg@mail.gmail.com>
Subject: Re: [PATCH 4/4] tun: indicate support for USO feature
To:     Jason Wang <jasowang@redhat.com>
Cc:     Yan Vugenfirer <yan@daynix.com>, davem <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, mst <mst@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        virtualization <virtualization@lists.linux-foundation.org>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 13, 2021 at 10:05 AM Jason Wang <jasowang@redhat.com> wrote:
>
> On Thu, May 13, 2021 at 12:36 PM Yuri Benditovich
> <yuri.benditovich@daynix.com> wrote:
> >
> > On Thu, May 13, 2021 at 5:07 AM Jason Wang <jasowang@redhat.com> wrote:
> > >
> > > On Wed, May 12, 2021 at 6:37 PM Yuri Benditovich
> > > <yuri.benditovich@daynix.com> wrote:
> > > >
> > > > On Wed, May 12, 2021 at 12:10 PM Jason Wang <jasowang@redhat.com> w=
rote:
> > > > >
> > > > > On Wed, May 12, 2021 at 4:32 PM Yuri Benditovich
> > > > > <yuri.benditovich@daynix.com> wrote:
> > > > > >
> > > > > > On Wed, May 12, 2021 at 10:50 AM Jason Wang <jasowang@redhat.co=
m> wrote:
> > > > > > >
> > > > > > > On Wed, May 12, 2021 at 1:24 PM Yuri Benditovich
> > > > > > > <yuri.benditovich@daynix.com> wrote:
> > > > > > > >
> > > > > > > > On Wed, May 12, 2021 at 4:33 AM Jason Wang <jasowang@redhat=
.com> wrote:
> > > > > > > > >
> > > > > > > > >
> > > > > > > > > =E5=9C=A8 2021/5/11 =E4=B8=8B=E5=8D=884:33, Yuri Benditov=
ich =E5=86=99=E9=81=93:
> > > > > > > > > > On Tue, May 11, 2021 at 9:50 AM Jason Wang <jasowang@re=
dhat.com> wrote:
> > > > > > > > > >>
> > > > > > > > > >> =E5=9C=A8 2021/5/11 =E4=B8=8B=E5=8D=8812:42, Yuri Bend=
itovich =E5=86=99=E9=81=93:
> > > > > > > > > >>> Signed-off-by: Yuri Benditovich <yuri.benditovich@day=
nix.com>
> > > > > > > > > >>> ---
> > > > > > > > > >>>    drivers/net/tun.c | 2 +-
> > > > > > > > > >>>    1 file changed, 1 insertion(+), 1 deletion(-)
> > > > > > > > > >>>
> > > > > > > > > >>> diff --git a/drivers/net/tun.c b/drivers/net/tun.c
> > > > > > > > > >>> index 84f832806313..a35054f9d941 100644
> > > > > > > > > >>> --- a/drivers/net/tun.c
> > > > > > > > > >>> +++ b/drivers/net/tun.c
> > > > > > > > > >>> @@ -2812,7 +2812,7 @@ static int set_offload(struct t=
un_struct *tun, unsigned long arg)
> > > > > > > > > >>>                        arg &=3D ~(TUN_F_TSO4|TUN_F_TS=
O6);
> > > > > > > > > >>>                }
> > > > > > > > > >>>
> > > > > > > > > >>> -             arg &=3D ~TUN_F_UFO;
> > > > > > > > > >>> +             arg &=3D ~(TUN_F_UFO|TUN_F_USO);
> > > > > > > > > >>
> > > > > > > > > >> It looks to me kernel doesn't use "USO", so TUN_F_UDP_=
GSO_L4 is a better
> > > > > > > > > >> name for this
> > > > > > > > > > No problem, I can change it in v2
> > > > > > > > > >
> > > > > > > > > >   and I guess we should toggle NETIF_F_UDP_GSO_l4 here?
> > > > > > > > > >
> > > > > > > > > > No, we do not, because this indicates only the fact tha=
t the guest can
> > > > > > > > > > send large UDP packets and have them splitted to UDP se=
gments.
> > > > > > > > >
> > > > > > > > >
> > > > > > > > > Actually the reverse. The set_offload() controls the tunt=
ap TX path
> > > > > > > > > (guest RX path).
> > > > > > > >
> > > > > > > > The set_offloads does 2 things:
> > > > > > > > 1. At the initialization time qemu probes set_offload(somet=
hing) to
> > > > > > > > check which features are supported by TAP/TUN.
> > > > > > >
> > > > > > > Note that the probing is used for guest RX features not host =
RX.
> > > > > >
> > > > > > It looks like the hidden assumption (till now) is that if some =
feature
> > > > > > is present - it exists simultaneously for host and guest.
> > > > > > See QEMU get_features: if the TAP/TUN does not have UFO both HO=
ST and
> > > > > > GUEST FEATURES are cleared.
> > > > >
> > > > > Kind of, actually the assumption is: if a guest feature
> > > > > (VIRTIO_NET_F_GUEST_XXX) is support, the corresponding host featu=
re
> > > > > (VIRTIO_NET_F_HOST_XXX) is also supported.
> > > >
> > > > So nothing tells us that the TUNSETOFFLOAD is going to set GUEST of=
floads.
> > > > From if_tun.h
> > > > #define TUN_F_CSUM      0x01    /* You can hand me unchecksummed pa=
ckets. */
> > > > #define TUN_F_TSO4      0x02    /* I can handle TSO for IPv4 packet=
s */
> > > > #define TUN_F_TSO6      0x04    /* I can handle TSO for IPv6 packet=
s */
> > > > #define TUN_F_TSO_ECN   0x08    /* I can handle TSO with ECN bits. =
*/
> > > > #define TUN_F_UFO       0x10    /* I can handle UFO packets */
> > >
> > > Yes, that's why I replied in another thread to say that there's no wa=
y
> > > to refuse GSO packets from userspace, even if TUN_F_XXX is not set vi=
a
> > > tun_set_offload().
> > >
> > > E.g you can disable sending GSO packets to guests but you can't rejec=
t
> > > GSO packets from guest/userspace.
> >
> > We agree here.
> > Sorry for being unclear. I meant following:
> > According to the comment the TUN_F_CSUM is a _host_ capability.
> > According to the comment the TUN_F_UFO is a _guest_ capability.
> >
> > But surprisingly when TUN receives TUN_F_UFO it does not propagate it
> > anywhere, there is no corresponding NETIF flag.
>
> (It looks like I drop the community and other ccs accidentally, adding
> them back and sorry)
I thought you did it intentionally to avoid the flame
>
> Actually, there is one, NETIF_F_GSO_UDP.
>
> Kernel used to have NETIF_F_UFO, but it was removed due to bugs and
> the lack of real hardware support. Then we found it breaks uABI, so
> Willem tries to make it appear for userspace again, and then it was
> renamed to NETIF_F_GSO_UDP.
>
> But I think it's a bug that we don't proporate TUN_F_UFO to NETIF
> flag, this is a must for the driver that doesn't support
> VIRTIO_NET_F_GUEST_UFO. I just try to disable all offloads and
> mrg_rxbuf, then netperf UDP_STREAM from host to guest gives me bad
> length packet in the guest.
>
> Willem, I think we probably need to fix this.
>
>
> > So in fact TUN_F_UFO is processed by the TUN/TAP exactly as a host capa=
bility.
> >
> > >
> > > >
> > > > So, let's write
> > > >
> > > > #define TUN_F_UDP_L4TX       0x20    /* You can send me large UDP p=
ackets */
> > >
> > > So if we stick to the assumption "if a guest feature is supported, th=
e
> > > corresponding host feature is supported". There's no need for this.
> > > And I think it's the most clean way.
> >
> > My personal opinion is that it is extremely wrong to extend such an
> > unobvious assumption to each new feature.
>
> This results in inconsistency with other GSO/CSUM flags. And will
> complicate the uAPI (two flags, one for RX another for TX).
>
> Considering the current code works for many years, it's not worth
> bothering I think.
>
> >
> > >
> > > > #define TUN_F_UDP4_L4RX     0x40   /* I can coalesce UDPv4 segments=
 */
> > > > #define TUN_F_UDP6_L4RX     0x80  /* I can coalesce UDPv6 segments =
*/
> > >
> > > Any value to coalesce UDP segments here? It's better to do it in the
> > > TX source (guest).
> >
> > Coalescing is a consent of the guest to receive packets bigger than MTU=
.
> > Otherwise (if the guest does not agree) the host must segment/fragment
> > packets before transmitting them to the guest.
>
> This looks like a different feature which is not necessarily known by gue=
sts?
>
> Kernel supports GRO which can coalesce packets. (It was not supported
> by TAP yet though).
If I understand things correctly this is exactly this feature:
The guest transmits a large UDP packet with the GSO value that means
that the host should segment it _if needed_.
If the destination (for example another guest) is not able to receive
the original large packet it is segmented and the segments pushed to
that guest.
If the destination can receive the original large packet (currently
not) it is just pushed to it as if it was segmented and then
coalesced.
As an example of the same with TCP:
With the current kernel Windows guest receives coalesced packets (for
example when segmented packets come via physical adapter with
coalescing capability) due to the fact that it dynamically enables
VIRTIO_NET_F_GUEST_TSO via VIRTIO_NET_CTRL_GUEST_OFFLOADS which
finally sets NETIF_F_TSO.
>
>
> > It is not related to guest TX.
> >
> > For example, Windows guest is not able to handle large UDP packets
> > (this is not supported by the stack yet).
>
> In this case, the corresponding guest or host features will be
> disabled, and the kernel won't send those kinds of GSO packets to
> guests.
>
> >
> > >
> > > >
> > > > >
> > > > > >
> > > > > > >
> > > > > > > > 2. Later it configures the guest RX path according to guest=
's needs/capabilities
> > > > > > > > Typical initialization sequence is (in case the QEMU suppor=
ts USO feature):
> > > > > > >
> > > > > > > It also depends on whether the backend(TAP) has the support f=
or guest RX.
> > > > > >
> > > > > > In the code of TAP and TUN I do not see any "if the backend has=
 the
> > > > > > support for guest RX".
> > > > >
> > > > > Yes, the detection is implied as you described above.
> > > > >
> > > > > > This is just the IOCTL and set of TUN_F_* bits. Their meaning i=
s
> > > > > > defined in the comments.
> > > > > >
> > > > > > >
> > > > > > > > TAP/TUN set offload 11 (probe for UFO support)
> > > > > > > > TAP/TUN set offload 21 (probe for USO support)
> > > > > > > > TAP/TUN set offload 0
> > > > > > > > ...
> > > > > > > > TAP/TUN set offload 7 (configuration of offloads according =
to GUEST features)
> > > > > > > >
> > > > > > > > This series of patches is for VIRTIO_NET_F_HOST_USO only, v=
irtio-net
> > > > > > > > features like VIRTIO_NET_F_GUEST_USO_(4/6/whatever) are not=
 defined in
> > > > > > > > the spec yet.
> > > > > > > >
> > > > > > >
> > > > > > > I'm a little bit confused here. Consider you want to implemen=
t guest
> > > > > > > TX so there's no need for any modification on the set_offload=
().
> > > > > >
> > > > > > I do not think so. Please correct me if I'm mistaken:
> > > > > > QEMU needs to indicate the HOST_USO feature (or not indicate).
> > > > > > How can QEMU know the kernel is able to support VIRTIO_NET_HDR_=
GSO_UDP_L4?
> > > > >
> > > > > Ok, I finally get you idea. Thanks for the patience.
> > > > >
> > > > > But still one issue: Assume we implement VIRTIO_NET_F_HOST_USO. H=
ow
> > > > > could we add VIRTIO_NET_F_GUEST_USO in the future? Adding another=
 TUN
> > > > > flag for set_offload()? Seems unnecessary and inconsistency with
> > > > > current TUN flags.
> > > > >
> > > > > >
> > > > > > >
> > > > > > > I think we need to implement both directions at one time as w=
hat has
> > > > > > > been partially done in this series:
> > > > > > >
> > > > > >
> > > > > > You actually suggest that we need to start from Linux virtio-ne=
t
> > > > > > driver and implement on it both TX and RX.
> > > > > > Our main area is virtio-win drivers and all the rest we do when=
 we can.
> > > > > > Currently we have 2 WIP tasks related to Linux (virtio-net RSS =
and
> > > > > > libvirt RSS/eBPF) and (my feeling) we hardly can start with add=
itional
> > > > > > one.
> > > > >
> > > > > I can help for the linux driver if you wish.
> > > >
> > > > I understand. Probably I've made a mistake from the beginning:
> > > > At first stage I've prepared the spec change of what we need in hop=
e
> > > > that this will be fast.
> > > > Probably the better way was to prepare RFC patches first then start
> > > > changing the spec.
> > > >
> > > > So the question is what to do now:
> > > > A)
> > > > Finalize patches for guest TX and respective QEMU patches
> > > > Prepare RFC patches for guest RX, get ack on them
> > > > Change the spec
> > > > Finalize patches for guest RX according to the spec
> > > >
> > > > B)
> > > > Reject the patches for guest TX
> > > > Prepare RFC patches for everything, get ack on them
> > > > Change the spec
> > > > Finalize patches for everything according to the spec
> > > >
> > > > I'm for A) of course :)
> > >
> > > I'm for B :)
> > >
> > > The reasons are:
> > >
> > > 1) keep the assumption of tun_set_offload() to simply the logic and
> > > compatibility
> > > 2) it's hard or tricky to touch guest TX path only (e.g the
> > > virtio_net_hdr_from_skb() is called in both RX and TX)
> >
> > I suspect there is _some_ misunderstanding here.
> > I did not touch virtio_net_hdr_from_skb at all.
> >
>
> Typo, actually I meant virtio_net_hdr_to_skb().
OK.
2) tun_get_user() which is guest TX - this is covered
3) tap_get_user() which is guest TX - this is covered
4) {t}packet_send() which is userspace TX - this is OK, the userspace
does not have this feature, it will never use USO

1) receive_buf() which is Linux guest RX - this is interesting
Do you mean that with my patches if Windows VM sends a packet with USO
- the Linux VM will not receive it correctly segmented?
When I send packets with USO via TUN I receive them segmented on
another TUN (2 Windows adapters).


>
> Thanks
>
> > >
> > > Thanks
> > >
> > > >
> > > > >
> > > > > Thanks
> > > > >
> > > > > > This is a reason why I've added to the virtio spec only HOST_US=
O and
> > > > > > not GUEST_USO4/6.
> > > > > > UDP RSC (which is actually guest rx USO) is not available on Wi=
ndows
> > > > > > at the moment.
> > > > > >
> > > > > > > 1) set_offload() is for guest RX.
> > > > > > > 2) virtio_net_hdr_to_skb() is for both guest TX and guest RX.
> > > > > > >
> > > > > > > For testing, you can run VM2VM on the same host, and you will=
 get
> > > > > > > everything tested.
> > > > > > >
> > > > > > > Thanks
> > > > > > >
> > > > > > > > >
> > > > > > > > > When VIRTIO_NET_F_GUEST_XXX was not negotiated, the corre=
sponding netdev
> > > > > > > > > features needs to be disabled. When host tries to send th=
ose packets to
> > > > > > > > > guest, it needs to do software segmentation.
> > > > > > > > >
> > > > > > > > > See virtio_net_apply_guest_offloads().
> > > > > > > > >
> > > > > > > > > There's currently no way (or not need) to prevent tuntap =
from receiving
> > > > > > > > > GSO packets.
> > > > > > > > >
> > > > > > > > > Thanks
> > > > > > > > >
> > > > > > > > >
> > > > > > > > > >
> > > > > > > > > >> And how about macvtap?
> > > > > > > > > > We will check how to do that for macvtap. We will send =
a separate
> > > > > > > > > > patch for macvtap or ask for advice.
> > > > > > > > > >
> > > > > > > > > >> Thanks
> > > > > > > > > >>
> > > > > > > > > >>
> > > > > > > > > >>>        }
> > > > > > > > > >>>
> > > > > > > > > >>>        /* This gives the user a way to test for new f=
eatures in future by
> > > > > > > > >
> > > > > > > >
> > > > > > >
> > > > > >
> > > > >
> > > >
> > >
> >
>

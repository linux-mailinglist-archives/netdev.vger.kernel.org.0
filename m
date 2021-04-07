Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B6BD357432
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 20:25:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355207AbhDGS0F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 14:26:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236436AbhDGSZ6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Apr 2021 14:25:58 -0400
Received: from mail-oi1-x229.google.com (mail-oi1-x229.google.com [IPv6:2607:f8b0:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8571C061760
        for <netdev@vger.kernel.org>; Wed,  7 Apr 2021 11:25:48 -0700 (PDT)
Received: by mail-oi1-x229.google.com with SMTP id n8so19681611oie.10
        for <netdev@vger.kernel.org>; Wed, 07 Apr 2021 11:25:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Ks/BuC5TosMhli7r6j39VAzsp/D2+jdZn2ef3OjdQXQ=;
        b=tY8e1/U1/b/NU7I6j1afi4IJD6KDjVUrhWHo0+DxkxrpKCqe7dREkF64Q5qV4UXYZ3
         7epYN4DQC/5d0XpFcm7o5a9Tt38jRYnQ5XHYAGFEgHRlV2uTlKn3UoE6igs5eNt4OXxO
         JaEQKwcqMA1/pSl+fl19aj+W8CvaCepz6I3k+OAQiaUbT7DIY3pHJXMNFZ7zhwuVTVD7
         QQkEOAWjVHVraPT6svOGj7tCd59aZYeUI2Uk68DitzPYwzilXwZkL64tk0Mu57NiSSfN
         b91RomSqBwKG1xd2h6kjNKZ7s+WK9bugVPKYINTqhPc6U/84o8DGFwLMUJXsRKoCwO4b
         iSog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Ks/BuC5TosMhli7r6j39VAzsp/D2+jdZn2ef3OjdQXQ=;
        b=RfavXI5XEIglpPg57cPgQGvM38e+dEHe+z+Pd+zO13jpmT3AhRmPE2ErRvhMeeLsFA
         bj4afji43rgS+ustEQWW5q/S5/5vPKq9glvUcX9/Q0UELNPLxDaQD1UVHZwCwyMK6m5k
         M/18JDZn2FZL94Xo1RnccPeY/CmR1yCYuHSwZySjmHG9nU1prtYeEYr0KMew6PSm/U4q
         qeYhPabDL+BDd7V72C83D0XGqCGWZYF0ragfW0LmfMuu9PqPJ9PgxptJ3sF3X4QToa6f
         2JXWoW/sZYgr1qk62AhVz2pkZ6GYjSIexA/PhSkUJNPd9wDQlJv5GHYKLvw61VvhMirx
         1YJA==
X-Gm-Message-State: AOAM533Ew9ozbZYXgM5UBC9qUo0OyfozcboXVCJR6fdj44WZtOIwJ7hs
        VqjAPFjqPgSdlkvnsNg5nA1tsv3+KIuhRZ2cPYrKsQ==
X-Google-Smtp-Source: ABdhPJzbzPbo9He78W+DyRDD6BB2Ds3E4DyyFbLx37Qu9bX3NV09sPWVWYKFiaT/YXZhn97+uZnJQvkDVHjQho1ZPWQ=
X-Received: by 2002:aca:4c0c:: with SMTP id z12mr3193600oia.109.1617819947957;
 Wed, 07 Apr 2021 11:25:47 -0700 (PDT)
MIME-Version: 1.0
References: <20210406183112.1150657-1-jiang.wang@bytedance.com> <1D46A084-5B77-4803-8B5F-B2F36541DA10@vmware.com>
In-Reply-To: <1D46A084-5B77-4803-8B5F-B2F36541DA10@vmware.com>
From:   "Jiang Wang ." <jiang.wang@bytedance.com>
Date:   Wed, 7 Apr 2021 11:25:36 -0700
Message-ID: <CAP_N_Z-KFUYZc7p1z_-9nb9CvjtyGFkgkX1PEbh-SgKbX_snQw@mail.gmail.com>
Subject: Re: [External] Re: [RFC] vsock: add multiple transports support for dgram
To:     Jorgen Hansen <jhansen@vmware.com>
Cc:     "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "cong.wang@bytedance.com" <cong.wang@bytedance.com>,
        "duanxiongchun@bytedance.com" <duanxiongchun@bytedance.com>,
        "xieyongji@bytedance.com" <xieyongji@bytedance.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Stefano Garzarella <sgarzare@redhat.com>,
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

On Wed, Apr 7, 2021 at 2:51 AM Jorgen Hansen <jhansen@vmware.com> wrote:
>
>
> > On 6 Apr 2021, at 20:31, Jiang Wang <jiang.wang@bytedance.com> wrote:
> >
> > From: "jiang.wang" <jiang.wang@bytedance.com>
> >
> > Currently, only VMCI supports dgram sockets. To supported
> > nested VM use case, this patch removes transport_dgram and
> > uses transport_g2h and transport_h2g for dgram too.
>
> Could you provide some background for introducing this change - are you
> looking at introducing datagrams for a different transport? VMCI datagram=
s
> already support the nested use case,

Yes, I am trying to introduce datagram for virtio transport. I wrote a
spec patch for
virtio dgram support and also a code patch, but the code patch is still WIP=
.
When I wrote this commit message, I was thinking nested VM is the same as
multiple transport support. But now, I realize they are different.
Nested VMs may use
the same virtualization layer(KVM on KVM), or different virtualization laye=
rs
(KVM on ESXi). Thanks for letting me know that VMCI already supported neste=
d
use cases. I think you mean VMCI on VMCI, right?

> but if we need to support multiple datagram
> transports we need to rework how we administer port assignment for datagr=
ams.
> One specific issue is that the vmci transport won=E2=80=99t receive any d=
atagrams for a
> port unless the datagram socket has already been assigned the vmci transp=
ort
> and the port bound to the underlying VMCI device (see below for more deta=
ils).
>
I see.

> > The transport is assgined when sending every packet and
> > receiving every packet on dgram sockets.
>
> Is the intent that the same datagram socket can be used for sending packe=
ts both
> In the host to guest, and the guest to directions?

Nope. One datagram socket will only send packets to one direction, either t=
o the
host or to the guest. My above description is wrong. When sending packets, =
the
transport is assigned with the first packet (with auto_bind).

The problem is when receiving packets. The listener can bind to the
VMADDR_CID_ANY
address. Then it is unclear which transport we should use. For stream
sockets, there will be a new socket for each connection, and transport
can be decided
at that time. For datagram sockets, I am not sure how to handle that.
For VMCI, does the same transport can be used for both receiving from
host and from
the guest?

For virtio, the h2g and g2h transports are different,, so we have to choose
one of them. My original thought is to wait until the first packet arrives.

Another idea is that we always bind to host addr and use h2g
transport because I think that might
be more common. If a listener wants to recv packets from the host, then it
should bind to the guest addr instead of CID_ANY.
Any other suggestions?

> Also, as mentioned above the vSocket datagram needs to be bound to a port=
 in the
> VMCI transport before we can receive any datagrams on that port. This mea=
ns that
> vmci_transport_recv_dgram_cb won=E2=80=99t be called unless it is already=
 associated with
> a socket as the transport, and therefore we can=E2=80=99t delay the trans=
port assignment to
> that point.

Got it. Thanks. Please see the above replies.

>
> > Signed-off-by: Jiang Wang <jiang.wang@bytedance.com>
> > ---
> > This patch is not tested. I don't have a VMWare testing
> > environment. Could someone help me to test it?
> >
> > include/net/af_vsock.h         |  2 --
> > net/vmw_vsock/af_vsock.c       | 63 +++++++++++++++++++++--------------=
-------
> > net/vmw_vsock/vmci_transport.c | 20 +++++++++-----
> > 3 files changed, 45 insertions(+), 40 deletions(-)
> >
> > diff --git a/include/net/af_vsock.h b/include/net/af_vsock.h
> > index b1c717286993..aba241e0d202 100644
> > --- a/include/net/af_vsock.h
> > +++ b/include/net/af_vsock.h
> > @@ -96,8 +96,6 @@ struct vsock_transport_send_notify_data {
> > #define VSOCK_TRANSPORT_F_H2G         0x00000001
> > /* Transport provides guest->host communication */
> > #define VSOCK_TRANSPORT_F_G2H         0x00000002
> > -/* Transport provides DGRAM communication */
> > -#define VSOCK_TRANSPORT_F_DGRAM              0x00000004
> > /* Transport provides local (loopback) communication */
> > #define VSOCK_TRANSPORT_F_LOCAL               0x00000008
> >
> > diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
> > index 92a72f0e0d94..7739ab2521a1 100644
> > --- a/net/vmw_vsock/af_vsock.c
> > +++ b/net/vmw_vsock/af_vsock.c
> > @@ -449,8 +449,6 @@ int vsock_assign_transport(struct vsock_sock *vsk, =
struct vsock_sock *psk)
> >
> >       switch (sk->sk_type) {
> >       case SOCK_DGRAM:
> > -             new_transport =3D transport_dgram;
> > -             break;
> >       case SOCK_STREAM:
> >               if (vsock_use_local_transport(remote_cid))
> >                       new_transport =3D transport_local;
> > @@ -1096,7 +1094,6 @@ static int vsock_dgram_sendmsg(struct socket *soc=
k, struct msghdr *msg,
> >       struct sock *sk;
> >       struct vsock_sock *vsk;
> >       struct sockaddr_vm *remote_addr;
> > -     const struct vsock_transport *transport;
> >
> >       if (msg->msg_flags & MSG_OOB)
> >               return -EOPNOTSUPP;
> > @@ -1108,25 +1105,30 @@ static int vsock_dgram_sendmsg(struct socket *s=
ock, struct msghdr *msg,
> >
> >       lock_sock(sk);
> >
> > -     transport =3D vsk->transport;
> > -
> >       err =3D vsock_auto_bind(vsk);
> >       if (err)
> >               goto out;
> >
> > -
> >       /* If the provided message contains an address, use that.  Otherw=
ise
> >        * fall back on the socket's remote handle (if it has been connec=
ted).
> >        */
> >       if (msg->msg_name &&
> >           vsock_addr_cast(msg->msg_name, msg->msg_namelen,
> >                           &remote_addr) =3D=3D 0) {
> > +             vsock_addr_init(&vsk->remote_addr, remote_addr->svm_cid,
> > +                     remote_addr->svm_port);
> > +
> > +             err =3D vsock_assign_transport(vsk, NULL);
> > +             if (err) {
> > +                     err =3D -EINVAL;
> > +                     goto out;
> > +             }
> > +
> >               /* Ensure this address is of the right type and is a vali=
d
> >                * destination.
> >                */
> > -
> >               if (remote_addr->svm_cid =3D=3D VMADDR_CID_ANY)
> > -                     remote_addr->svm_cid =3D transport->get_local_cid=
();
> > +                     remote_addr->svm_cid =3D vsk->transport->get_loca=
l_cid();
> >
> >               if (!vsock_addr_bound(remote_addr)) {
> >                       err =3D -EINVAL;
> > @@ -1136,7 +1138,7 @@ static int vsock_dgram_sendmsg(struct socket *soc=
k, struct msghdr *msg,
> >               remote_addr =3D &vsk->remote_addr;
> >
> >               if (remote_addr->svm_cid =3D=3D VMADDR_CID_ANY)
> > -                     remote_addr->svm_cid =3D transport->get_local_cid=
();
> > +                     remote_addr->svm_cid =3D vsk->transport->get_loca=
l_cid();
> >
> >               /* XXX Should connect() or this function ensure remote_ad=
dr is
> >                * bound?
> > @@ -1150,13 +1152,13 @@ static int vsock_dgram_sendmsg(struct socket *s=
ock, struct msghdr *msg,
> >               goto out;
> >       }
> >
> > -     if (!transport->dgram_allow(remote_addr->svm_cid,
> > +     if (!vsk->transport->dgram_allow(remote_addr->svm_cid,
> >                                   remote_addr->svm_port)) {
> >               err =3D -EINVAL;
> >               goto out;
> >       }
> >
> > -     err =3D transport->dgram_enqueue(vsk, remote_addr, msg, len);
> > +     err =3D vsk->transport->dgram_enqueue(vsk, remote_addr, msg, len)=
;
> >
> > out:
> >       release_sock(sk);
> > @@ -1191,13 +1193,20 @@ static int vsock_dgram_connect(struct socket *s=
ock,
> >       if (err)
> >               goto out;
> >
> > +     memcpy(&vsk->remote_addr, remote_addr, sizeof(vsk->remote_addr));
> > +
> > +     err =3D vsock_assign_transport(vsk, NULL);
> > +     if (err) {
> > +             err =3D -EINVAL;
> > +             goto out;
> > +     }
> > +
> >       if (!vsk->transport->dgram_allow(remote_addr->svm_cid,
> >                                        remote_addr->svm_port)) {
> >               err =3D -EINVAL;
> >               goto out;
> >       }
> >
> > -     memcpy(&vsk->remote_addr, remote_addr, sizeof(vsk->remote_addr));
> >       sock->state =3D SS_CONNECTED;
> >
> > out:
> > @@ -1209,6 +1218,16 @@ static int vsock_dgram_recvmsg(struct socket *so=
ck, struct msghdr *msg,
> >                              size_t len, int flags)
> > {
> >       struct vsock_sock *vsk =3D vsock_sk(sock->sk);
> > +     long timeo;
> > +
> > +     timeo =3D sock_rcvtimeo(sock->sk, flags & MSG_DONTWAIT);
> > +     do {
> > +             if (vsk->transport)
> > +                     break;
> > +     } while (timeo && !vsk->transport);
> > +
> > +     if (!vsk->transport)
> > +             return -EAGAIN;
> >
> >       return vsk->transport->dgram_dequeue(vsk, msg, len, flags);
> > }
> > @@ -2055,14 +2074,6 @@ static int vsock_create(struct net *net, struct =
socket *sock,
> >
> >       vsk =3D vsock_sk(sk);
> >
> > -     if (sock->type =3D=3D SOCK_DGRAM) {
> > -             ret =3D vsock_assign_transport(vsk, NULL);
> > -             if (ret < 0) {
> > -                     sock_put(sk);
> > -                     return ret;
> > -             }
> > -     }
> > -
> >       vsock_insert_unbound(vsk);
> >
> >       return 0;
> > @@ -2182,7 +2193,7 @@ EXPORT_SYMBOL_GPL(vsock_core_get_transport);
> >
> > int vsock_core_register(const struct vsock_transport *t, int features)
> > {
> > -     const struct vsock_transport *t_h2g, *t_g2h, *t_dgram, *t_local;
> > +     const struct vsock_transport *t_h2g, *t_g2h, *t_local;
> >       int err =3D mutex_lock_interruptible(&vsock_register_mutex);
> >
> >       if (err)
> > @@ -2190,7 +2201,6 @@ int vsock_core_register(const struct vsock_transp=
ort *t, int features)
> >
> >       t_h2g =3D transport_h2g;
> >       t_g2h =3D transport_g2h;
> > -     t_dgram =3D transport_dgram;
> >       t_local =3D transport_local;
> >
> >       if (features & VSOCK_TRANSPORT_F_H2G) {
> > @@ -2209,14 +2219,6 @@ int vsock_core_register(const struct vsock_trans=
port *t, int features)
> >               t_g2h =3D t;
> >       }
> >
> > -     if (features & VSOCK_TRANSPORT_F_DGRAM) {
> > -             if (t_dgram) {
> > -                     err =3D -EBUSY;
> > -                     goto err_busy;
> > -             }
> > -             t_dgram =3D t;
> > -     }
> > -
> >       if (features & VSOCK_TRANSPORT_F_LOCAL) {
> >               if (t_local) {
> >                       err =3D -EBUSY;
> > @@ -2227,7 +2229,6 @@ int vsock_core_register(const struct vsock_transp=
ort *t, int features)
> >
> >       transport_h2g =3D t_h2g;
> >       transport_g2h =3D t_g2h;
> > -     transport_dgram =3D t_dgram;
> >       transport_local =3D t_local;
> >
> > err_busy:
> > diff --git a/net/vmw_vsock/vmci_transport.c b/net/vmw_vsock/vmci_transp=
ort.c
> > index 8b65323207db..42ea2a1c92ce 100644
> > --- a/net/vmw_vsock/vmci_transport.c
> > +++ b/net/vmw_vsock/vmci_transport.c
> > @@ -613,6 +613,7 @@ static int vmci_transport_recv_dgram_cb(void *data,=
 struct vmci_datagram *dg)
> >       size_t size;
> >       struct sk_buff *skb;
> >       struct vsock_sock *vsk;
> > +     int err;
> >
> >       sk =3D (struct sock *)data;
> >
> > @@ -629,6 +630,17 @@ static int vmci_transport_recv_dgram_cb(void *data=
, struct vmci_datagram *dg)
> >       if (!vmci_transport_allow_dgram(vsk, dg->src.context))
> >               return VMCI_ERROR_NO_ACCESS;
> >
> > +     vsock_addr_init(&vsk->remote_addr, dg->src.context,
> > +                             dg->src.resource);
> > +
> > +     bh_lock_sock(sk);
> > +     if (!sock_owned_by_user(sk)) {
> > +             err =3D vsock_assign_transport(vsk, NULL);
> > +             if (err)
> > +                     return err;
> > +     }
> > +     bh_unlock_sock(sk);
> > +
> >       size =3D VMCI_DG_SIZE(dg);
> >
> >       /* Attach the packet to the socket's receive queue as an sk_buff.=
 */
> > @@ -2093,13 +2105,7 @@ static int __init vmci_transport_init(void)
> >               goto err_destroy_stream_handle;
> >       }
> >
> > -     /* Register only with dgram feature, other features (H2G, G2H) wi=
ll be
> > -      * registered when the first host or guest becomes active.
> > -      */
> > -     err =3D vsock_core_register(&vmci_transport, VSOCK_TRANSPORT_F_DG=
RAM);
> > -     if (err < 0)
> > -             goto err_unsubscribe;
> > -
> > +     /* H2G, G2H will be registered when the first host or guest becom=
es active. */
> >       err =3D vmci_register_vsock_callback(vmci_vsock_transport_cb);
> >       if (err < 0)
> >               goto err_unregister;
> > --
> > 2.11.0
> >
>

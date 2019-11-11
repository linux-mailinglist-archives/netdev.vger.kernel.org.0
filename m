Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 480F0F799A
	for <lists+netdev@lfdr.de>; Mon, 11 Nov 2019 18:17:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726973AbfKKRRt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Nov 2019 12:17:49 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:24261 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726871AbfKKRRs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Nov 2019 12:17:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573492667;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=U8F88/sItWbD02VGY9zP9Y9ZOIT6fMJeN+Q5XP6oyh4=;
        b=EegUM7+OKb/W2m9Gu+K55VAxmJVqmtomVA9CGqAISAD8NF1HDTRe8k0Fl6fWDS5CBuEm5T
        LmxcDNHjYDyTp1z7zcJlwzrASNpz3+T4Lz9A1o8c/PBBBczjZS9JYvd5HpCDv2caJ++k8g
        yW7JmqYgoOg2R1MHxtnZwYsKgZDly4g=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-304-lKT8TA9FPty6VLVe3TKzEw-1; Mon, 11 Nov 2019 12:17:45 -0500
Received: by mail-wr1-f72.google.com with SMTP id w9so9509005wrn.9
        for <netdev@vger.kernel.org>; Mon, 11 Nov 2019 09:17:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=L5B/HbloBPTfZZowNUyvPaaS2XYvOP2ZX1GUhZLVoWA=;
        b=J8f6v2DoLl/S9PIlliNqW1zWm77hJ3ksGESwbGXT4nGGR5VPIX7SOGj07P/BY0wO/k
         skcOOUujEOn9lPaKJiPc0TP/k37gyRfW3kYySmyMf1sF31AWjQEvq9Y8aXDNbKCdCe7r
         h6/X3Sk5t31UEWUFHMaETDsCHSaoLITGJ1KdmHvPBR/B5qOiw7kmVi4Iyegh2ELEEuyk
         lCB9ojrcyTpIZFEiJwbPDjda1dZ2ykZ/ccIknkhQ6cdgz5agXpOiUC/wZtVD2OuzurEa
         y0r8mjvE3IXOtLyxdUuzEuuHPr9JqQ1qIJYajXl61E4IB5/96yZnlEm/mHBoE/nuS03h
         nJ9g==
X-Gm-Message-State: APjAAAWbsRCkZMcP5oz6ck1xro8MxENqXmURDHwFN9yxN2RHpIkQJbbz
        erXSjNItGLHDVgzFIUy48yxLwgjsw6HblVSyddIM+5yrvpky47+CuTqNJ5jXCLE5g6KdMS3dNlw
        GIkmEB8MX9ZzAuIAa
X-Received: by 2002:adf:fa0b:: with SMTP id m11mr9122031wrr.279.1573492664383;
        Mon, 11 Nov 2019 09:17:44 -0800 (PST)
X-Google-Smtp-Source: APXvYqy0xNO1Zc3/XF6+OzMHScsnq3UkZZAZtjoMcWCT+PExC+s9OksJZ5jSzbxS2VSx3SU8it1yAA==
X-Received: by 2002:adf:fa0b:: with SMTP id m11mr9121984wrr.279.1573492663974;
        Mon, 11 Nov 2019 09:17:43 -0800 (PST)
Received: from steredhat (a-nu5-32.tin.it. [212.216.181.31])
        by smtp.gmail.com with ESMTPSA id x8sm18181603wrr.43.2019.11.11.09.17.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Nov 2019 09:17:43 -0800 (PST)
Date:   Mon, 11 Nov 2019 18:17:40 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Jorgen Hansen <jhansen@vmware.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dexuan Cui <decui@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Sasha Levin <sashal@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>
Subject: Re: [PATCH net-next 11/14] vsock: add multi-transports support
Message-ID: <20191111171740.xwo7isdmtt7ywibo@steredhat>
References: <20191023095554.11340-1-sgarzare@redhat.com>
 <20191023095554.11340-12-sgarzare@redhat.com>
 <MWHPR05MB33761FE4DA27130C72FC5048DA740@MWHPR05MB3376.namprd05.prod.outlook.com>
MIME-Version: 1.0
In-Reply-To: <MWHPR05MB33761FE4DA27130C72FC5048DA740@MWHPR05MB3376.namprd05.prod.outlook.com>
X-MC-Unique: lKT8TA9FPty6VLVe3TKzEw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 11, 2019 at 01:53:39PM +0000, Jorgen Hansen wrote:
> > From: Stefano Garzarella [mailto:sgarzare@redhat.com]
> > Sent: Wednesday, October 23, 2019 11:56 AM
>=20
> Thanks a lot for working on this!
>=20

Thanks to you for the reviews!

> > With the multi-transports support, we can use vsock with nested VMs (us=
ing
> > also different hypervisors) loading both guest->host and
> > host->guest transports at the same time.
> >=20
> > Major changes:
> > - vsock core module can be loaded regardless of the transports
> > - vsock_core_init() and vsock_core_exit() are renamed to
> >   vsock_core_register() and vsock_core_unregister()
> > - vsock_core_register() has a feature parameter (H2G, G2H, DGRAM)
> >   to identify which directions the transport can handle and if it's
> >   support DGRAM (only vmci)
> > - each stream socket is assigned to a transport when the remote CID
> >   is set (during the connect() or when we receive a connection request
> >   on a listener socket).
>=20
> How about allowing the transport to be set during bind as well? That
> would allow an application to ensure that it is using a specific transpor=
t,
> i.e., if it binds to the host CID, it will use H2G, and if it binds to so=
mething
> else it will use G2H? You can still use VMADDR_CID_ANY if you want to
> initially listen to both transports.

Do you mean for socket that will call the connect()?

For listener socket the "[PATCH net-next 14/14] vsock: fix bind() behaviour
taking care of CID" provides this behaviour.
Since the listener sockets don't use any transport specific callback
(they don't send any data to the remote peer), but they are used as placeho=
lder,
we don't need to assign them to a transport.

>=20
>=20
> >   The remote CID is used to decide which transport to use:
> >   - remote CID > VMADDR_CID_HOST will use host->guest transport
> >   - remote CID <=3D VMADDR_CID_HOST will use guest->host transport
> > - listener sockets are not bound to any transports since no transport
> >   operations are done on it. In this way we can create a listener
> >   socket, also if the transports are not loaded or with VMADDR_CID_ANY
> >   to listen on all transports.
> > - DGRAM sockets are handled as before, since only the vmci_transport
> >   provides this feature.
> >=20
> > Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> > ---
> > RFC -> v1:
> > - documented VSOCK_TRANSPORT_F_* flags
> > - fixed vsock_assign_transport() when the socket is already assigned
> >   (e.g connection failed)
> > - moved features outside of struct vsock_transport, and used as
> >   parameter of vsock_core_register()
> > ---
> >  drivers/vhost/vsock.c                   |   5 +-
> >  include/net/af_vsock.h                  |  17 +-
> >  net/vmw_vsock/af_vsock.c                | 237 ++++++++++++++++++------
> >  net/vmw_vsock/hyperv_transport.c        |  26 ++-
> >  net/vmw_vsock/virtio_transport.c        |   7 +-
> >  net/vmw_vsock/virtio_transport_common.c |  28 ++-
> >  net/vmw_vsock/vmci_transport.c          |  31 +++-
> >  7 files changed, 270 insertions(+), 81 deletions(-)
> >=20
>=20
>=20
> > diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c index
> > d89381166028..dddd85d9a147 100644
> > --- a/net/vmw_vsock/af_vsock.c
> > +++ b/net/vmw_vsock/af_vsock.c
> > @@ -130,7 +130,12 @@ static struct proto vsock_proto =3D {  #define
> > VSOCK_DEFAULT_BUFFER_MAX_SIZE (1024 * 256)  #define
> > VSOCK_DEFAULT_BUFFER_MIN_SIZE 128
> >=20
> > -static const struct vsock_transport *transport_single;
> > +/* Transport used for host->guest communication */ static const struct
> > +vsock_transport *transport_h2g;
> > +/* Transport used for guest->host communication */ static const struct
> > +vsock_transport *transport_g2h;
> > +/* Transport used for DGRAM communication */ static const struct
> > +vsock_transport *transport_dgram;
> >  static DEFINE_MUTEX(vsock_register_mutex);
> >=20
> >  /**** UTILS ****/
> > @@ -182,7 +187,7 @@ static int vsock_auto_bind(struct vsock_sock *vsk)
> >  =09return __vsock_bind(sk, &local_addr);
> >  }
> >=20
> > -static int __init vsock_init_tables(void)
> > +static void vsock_init_tables(void)
> >  {
> >  =09int i;
> >=20
> > @@ -191,7 +196,6 @@ static int __init vsock_init_tables(void)
> >=20
> >  =09for (i =3D 0; i < ARRAY_SIZE(vsock_connected_table); i++)
> >  =09=09INIT_LIST_HEAD(&vsock_connected_table[i]);
> > -=09return 0;
> >  }
> >=20
> >  static void __vsock_insert_bound(struct list_head *list, @@ -376,6 +38=
0,62
> > @@ void vsock_enqueue_accept(struct sock *listener, struct sock
> > *connected)  }  EXPORT_SYMBOL_GPL(vsock_enqueue_accept);
> >=20
> > +/* Assign a transport to a socket and call the .init transport callbac=
k.
> > + *
> > + * Note: for stream socket this must be called when vsk->remote_addr i=
s
> > +set
> > + * (e.g. during the connect() or when a connection request on a
> > +listener
> > + * socket is received).
> > + * The vsk->remote_addr is used to decide which transport to use:
> > + *  - remote CID > VMADDR_CID_HOST will use host->guest transport
> > + *  - remote CID <=3D VMADDR_CID_HOST will use guest->host transport  =
*/
> > +int vsock_assign_transport(struct vsock_sock *vsk, struct vsock_sock
> > +*psk) {
> > +=09const struct vsock_transport *new_transport;
> > +=09struct sock *sk =3D sk_vsock(vsk);
> > +
> > +=09switch (sk->sk_type) {
> > +=09case SOCK_DGRAM:
> > +=09=09new_transport =3D transport_dgram;
> > +=09=09break;
> > +=09case SOCK_STREAM:
> > +=09=09if (vsk->remote_addr.svm_cid > VMADDR_CID_HOST)
> > +=09=09=09new_transport =3D transport_h2g;
> > +=09=09else
> > +=09=09=09new_transport =3D transport_g2h;
> > +=09=09break;
>=20
> You already mentioned that you are working on a fix for loopback
> here for the guest, but presumably a host could also do loopback.

IIUC we don't support loopback in the host, because in this case the
application will use the CID_HOST as address, but if we are in a nested
VM environment we are in trouble.

Since several people asked about this feature at the KVM Forum, I would lik=
e
to add a new VMADDR_CID_LOCAL (i.e. using the reserved 1) and implement
loopback in the core.

What do you think?

> If we select transport during bind to a specific CID, this comment

Also in this case, are you talking about the peer that will call
connect()?

> Isn't relevant, but otherwise, we should look at the local addr as
> well, since a socket with local addr of host CID shouldn't use
> the guest to host transport, and a socket with local addr > host CID
> shouldn't use host to guest.

Yes, I agree, in my fix I'm looking at the local addr, and in L1 I'll
not allow to assign a CID to a nested L2 equal to the CID of L1 (in
vhost-vsock)

Maybe we can allow the host loopback (using CID_HOST), only if there isn't
G2H loaded, but also in this case I'd like to move the loopback in the vsoc=
k
core, since we can do that, also if there are no transports loaded.

>=20
>=20
> > +=09default:
> > +=09=09return -ESOCKTNOSUPPORT;
> > +=09}
> > +
> > +=09if (vsk->transport) {
> > +=09=09if (vsk->transport =3D=3D new_transport)
> > +=09=09=09return 0;
> > +
> > +=09=09vsk->transport->release(vsk);
> > +=09=09vsk->transport->destruct(vsk);
> > +=09}
> > +
> > +=09if (!new_transport)
> > +=09=09return -ENODEV;
> > +
> > +=09vsk->transport =3D new_transport;
> > +
> > +=09return vsk->transport->init(vsk, psk); }
> > +EXPORT_SYMBOL_GPL(vsock_assign_transport);
> > +
> > +static bool vsock_find_cid(unsigned int cid) {
> > +=09if (transport_g2h && cid =3D=3D transport_g2h->get_local_cid())
> > +=09=09return true;
> > +
> > +=09if (transport_h2g && cid =3D=3D VMADDR_CID_HOST)
> > +=09=09return true;
> > +
> > +=09return false;
> > +}
> > +
> >  static struct sock *vsock_dequeue_accept(struct sock *listener)  {
> >  =09struct vsock_sock *vlistener;
>=20
>=20
> > diff --git a/net/vmw_vsock/vmci_transport.c
> > b/net/vmw_vsock/vmci_transport.c index 5955238ffc13..2eb3f16d53e7
> > 100644
> > --- a/net/vmw_vsock/vmci_transport.c
> > +++ b/net/vmw_vsock/vmci_transport.c
>=20
> > @@ -1017,6 +1018,15 @@ static int vmci_transport_recv_listen(struct soc=
k
> > *sk,
> >  =09vsock_addr_init(&vpending->remote_addr, pkt->dg.src.context,
> >  =09=09=09pkt->src_port);
> >=20
> > +=09err =3D vsock_assign_transport(vpending, vsock_sk(sk));
> > +=09/* Transport assigned (looking at remote_addr) must be the same
> > +=09 * where we received the request.
> > +=09 */
> > +=09if (err || !vmci_check_transport(vpending)) {
>=20
> We need to send a reset on error, i.e.,
>   vmci_transport_send_reset(sk, pkt);

Good catch, I'll fix in the v2.

Thanks,
Stefano


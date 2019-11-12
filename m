Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C9BFAF8CE5
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 11:36:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726978AbfKLKgl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 05:36:41 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:60649 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725919AbfKLKgk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 05:36:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573554999;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MtYx8D4UhXjFR2Vo9h0VL/OjZVQ/Uw5DM6wZNoc6GTw=;
        b=DGW7jEI4lLtR56j3n+CMb4KOqS+0/HpqEoWXwp9eCBzIWS7ypE3xaLLHgC15LhueeXDjU0
        gyT+O5jlctAgSOFfIJnfOkCl8CS+nbCNxmODgcC5exYfa4XSvb7eidTQ/QydNL2JiYm0yK
        e+q7kckVNYOr0VUFgAhcNiRJlVFp/zc=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-339-bMIWQH-OMkGHx-v9U5JCWg-1; Tue, 12 Nov 2019 05:36:36 -0500
Received: by mail-wr1-f69.google.com with SMTP id m17so11571960wrn.23
        for <netdev@vger.kernel.org>; Tue, 12 Nov 2019 02:36:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=cEKqFrG3VK0+fq0jdhQPgpS1QzH7bLmBVcLITLAfR9o=;
        b=WG7dlE/O6puvyWVlhhfqjq2JbTElgOADaXx0maVPzrSebs7nfAzWFmFmqR4qdbYCsa
         Sgt1nSAfrkETeIusz5jY9Mp1r3JYdNEAXQqQnzTGEbOpwVERG8P2FYMnReFzmkTlxfsd
         Rl0P/0VmJjVHyDVcXyzG9hfNRxOsoplHBJ/Df7MpF9kRmMXxJrFk4Una91hzuoqTAsBd
         baYLsxNuFQYkVrlUPcGt2GOic5FkyiCAuoCl630qfhVIybND3X9Y7++b24oTH+kLUE+u
         MRwzIBb0wXl2HE74c2YF/GXAEW0dtpOKmY0v+Op2RiKb0hRmIsCakg8QopoXRC27KDRy
         ldXA==
X-Gm-Message-State: APjAAAUxKAE0b4bjZP28SpHss/jpAE8qzR4+OmGIrC5/9V9BStc68Yqz
        v4vAhqTTRAUx1cGzXCYJZ1u9eB+47qPqtMDfsQy0mZM/wsVqPRLBefjGQ9vQlCsyxSqa4ybcT8Q
        XDpQV5LAf453Pv1lB
X-Received: by 2002:adf:e80d:: with SMTP id o13mr14169784wrm.73.1573554994794;
        Tue, 12 Nov 2019 02:36:34 -0800 (PST)
X-Google-Smtp-Source: APXvYqwj+bVTLysGUuaKq+Jm14o5nlQAH3NsewrbyWdkqvL+nAsSlaQ00Tbsx/oCesJe8hKmRCYdZg==
X-Received: by 2002:adf:e80d:: with SMTP id o13mr14169752wrm.73.1573554994493;
        Tue, 12 Nov 2019 02:36:34 -0800 (PST)
Received: from steredhat (a-nu5-32.tin.it. [212.216.181.31])
        by smtp.gmail.com with ESMTPSA id j2sm3864847wrt.61.2019.11.12.02.36.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Nov 2019 02:36:33 -0800 (PST)
Date:   Tue, 12 Nov 2019 11:36:30 +0100
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
Message-ID: <20191112103630.vd3kbk7xnplv6rey@steredhat>
References: <20191023095554.11340-1-sgarzare@redhat.com>
 <20191023095554.11340-12-sgarzare@redhat.com>
 <MWHPR05MB33761FE4DA27130C72FC5048DA740@MWHPR05MB3376.namprd05.prod.outlook.com>
 <20191111171740.xwo7isdmtt7ywibo@steredhat>
 <MWHPR05MB33764F82AFA882B921A11E56DA770@MWHPR05MB3376.namprd05.prod.outlook.com>
MIME-Version: 1.0
In-Reply-To: <MWHPR05MB33764F82AFA882B921A11E56DA770@MWHPR05MB3376.namprd05.prod.outlook.com>
X-MC-Unique: bMIWQH-OMkGHx-v9U5JCWg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 12, 2019 at 09:59:12AM +0000, Jorgen Hansen wrote:
> > From: Stefano Garzarella [mailto:sgarzare@redhat.com]
> > Sent: Monday, November 11, 2019 6:18 PM
> > To: Jorgen Hansen <jhansen@vmware.com>
> > Subject: Re: [PATCH net-next 11/14] vsock: add multi-transports support
> >=20
> > On Mon, Nov 11, 2019 at 01:53:39PM +0000, Jorgen Hansen wrote:
> > > > From: Stefano Garzarella [mailto:sgarzare@redhat.com]
> > > > Sent: Wednesday, October 23, 2019 11:56 AM
> > >
> > > Thanks a lot for working on this!
> > >
> >=20
> > Thanks to you for the reviews!
> >=20
> > > > With the multi-transports support, we can use vsock with nested VMs
> > (using
> > > > also different hypervisors) loading both guest->host and
> > > > host->guest transports at the same time.
> > > >
> > > > Major changes:
> > > > - vsock core module can be loaded regardless of the transports
> > > > - vsock_core_init() and vsock_core_exit() are renamed to
> > > >   vsock_core_register() and vsock_core_unregister()
> > > > - vsock_core_register() has a feature parameter (H2G, G2H, DGRAM)
> > > >   to identify which directions the transport can handle and if it's
> > > >   support DGRAM (only vmci)
> > > > - each stream socket is assigned to a transport when the remote CID
> > > >   is set (during the connect() or when we receive a connection requ=
est
> > > >   on a listener socket).
> > >
> > > How about allowing the transport to be set during bind as well? That
> > > would allow an application to ensure that it is using a specific tran=
sport,
> > > i.e., if it binds to the host CID, it will use H2G, and if it binds t=
o something
> > > else it will use G2H? You can still use VMADDR_CID_ANY if you want to
> > > initially listen to both transports.
> >=20
> > Do you mean for socket that will call the connect()?
>=20
> I was just thinking that in general we know the transport at that point, =
so we
> could ensure that the socket would only see traffic from the relevant tra=
nsport,
> but as you mention below -  the updated bind lookup, and the added checks
> when selecting transport should also take care of this, so that is fine.
> =20
> > For listener socket the "[PATCH net-next 14/14] vsock: fix bind() behav=
iour
> > taking care of CID" provides this behaviour.
> > Since the listener sockets don't use any transport specific callback
> > (they don't send any data to the remote peer), but they are used as
> > placeholder,
> > we don't need to assign them to a transport.
> >=20
> > >
> > >
> > > >   The remote CID is used to decide which transport to use:
> > > >   - remote CID > VMADDR_CID_HOST will use host->guest transport
> > > >   - remote CID <=3D VMADDR_CID_HOST will use guest->host transport
> > > > - listener sockets are not bound to any transports since no transpo=
rt
> > > >   operations are done on it. In this way we can create a listener
> > > >   socket, also if the transports are not loaded or with VMADDR_CID_=
ANY
> > > >   to listen on all transports.
> > > > - DGRAM sockets are handled as before, since only the vmci_transpor=
t
> > > >   provides this feature.
> > > >
> > > > Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> > > > ---
> > > > RFC -> v1:
> > > > - documented VSOCK_TRANSPORT_F_* flags
> > > > - fixed vsock_assign_transport() when the socket is already assigne=
d
> > > >   (e.g connection failed)
> > > > - moved features outside of struct vsock_transport, and used as
> > > >   parameter of vsock_core_register()
> > > > ---
> > > >  drivers/vhost/vsock.c                   |   5 +-
> > > >  include/net/af_vsock.h                  |  17 +-
> > > >  net/vmw_vsock/af_vsock.c                | 237 ++++++++++++++++++--=
----
> > > >  net/vmw_vsock/hyperv_transport.c        |  26 ++-
> > > >  net/vmw_vsock/virtio_transport.c        |   7 +-
> > > >  net/vmw_vsock/virtio_transport_common.c |  28 ++-
> > > >  net/vmw_vsock/vmci_transport.c          |  31 +++-
> > > >  7 files changed, 270 insertions(+), 81 deletions(-)
> > > >
> > >
> > >
> > > > diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
> > index
> > > > d89381166028..dddd85d9a147 100644
> > > > --- a/net/vmw_vsock/af_vsock.c
> > > > +++ b/net/vmw_vsock/af_vsock.c
> > > > @@ -130,7 +130,12 @@ static struct proto vsock_proto =3D {  #define
> > > > VSOCK_DEFAULT_BUFFER_MAX_SIZE (1024 * 256)  #define
> > > > VSOCK_DEFAULT_BUFFER_MIN_SIZE 128
> > > >
> > > > -static const struct vsock_transport *transport_single;
> > > > +/* Transport used for host->guest communication */ static const st=
ruct
> > > > +vsock_transport *transport_h2g;
> > > > +/* Transport used for guest->host communication */ static const st=
ruct
> > > > +vsock_transport *transport_g2h;
> > > > +/* Transport used for DGRAM communication */ static const struct
> > > > +vsock_transport *transport_dgram;
> > > >  static DEFINE_MUTEX(vsock_register_mutex);
> > > >
> > > >  /**** UTILS ****/
> > > > @@ -182,7 +187,7 @@ static int vsock_auto_bind(struct vsock_sock *v=
sk)
> > > >  =09return __vsock_bind(sk, &local_addr);
> > > >  }
> > > >
> > > > -static int __init vsock_init_tables(void)
> > > > +static void vsock_init_tables(void)
> > > >  {
> > > >  =09int i;
> > > >
> > > > @@ -191,7 +196,6 @@ static int __init vsock_init_tables(void)
> > > >
> > > >  =09for (i =3D 0; i < ARRAY_SIZE(vsock_connected_table); i++)
> > > >  =09=09INIT_LIST_HEAD(&vsock_connected_table[i]);
> > > > -=09return 0;
> > > >  }
> > > >
> > > >  static void __vsock_insert_bound(struct list_head *list, @@ -376,6
> > +380,62
> > > > @@ void vsock_enqueue_accept(struct sock *listener, struct sock
> > > > *connected)  }  EXPORT_SYMBOL_GPL(vsock_enqueue_accept);
> > > >
> > > > +/* Assign a transport to a socket and call the .init transport cal=
lback.
> > > > + *
> > > > + * Note: for stream socket this must be called when vsk->remote_ad=
dr
> > is
> > > > +set
> > > > + * (e.g. during the connect() or when a connection request on a
> > > > +listener
> > > > + * socket is received).
> > > > + * The vsk->remote_addr is used to decide which transport to use:
> > > > + *  - remote CID > VMADDR_CID_HOST will use host->guest transport
> > > > + *  - remote CID <=3D VMADDR_CID_HOST will use guest->host transpo=
rt
> > */
> > > > +int vsock_assign_transport(struct vsock_sock *vsk, struct vsock_so=
ck
> > > > +*psk) {
> > > > +=09const struct vsock_transport *new_transport;
> > > > +=09struct sock *sk =3D sk_vsock(vsk);
> > > > +
> > > > +=09switch (sk->sk_type) {
> > > > +=09case SOCK_DGRAM:
> > > > +=09=09new_transport =3D transport_dgram;
> > > > +=09=09break;
> > > > +=09case SOCK_STREAM:
> > > > +=09=09if (vsk->remote_addr.svm_cid > VMADDR_CID_HOST)
> > > > +=09=09=09new_transport =3D transport_h2g;
> > > > +=09=09else
> > > > +=09=09=09new_transport =3D transport_g2h;
> > > > +=09=09break;
> > >
> > > You already mentioned that you are working on a fix for loopback
> > > here for the guest, but presumably a host could also do loopback.
> >=20
> > IIUC we don't support loopback in the host, because in this case the
> > application will use the CID_HOST as address, but if we are in a nested
> > VM environment we are in trouble.
>=20
> If both src and dst CID are CID_HOST, we should be fairly sure that this
> Is host loopback, no? If src is anything else, we would do G2H.
>=20

The problem is that we don't know the src until we assign a transport
looking at the dst. (or if the user bound the socket to CID_HOST before
the connect(), but it is not very common)

So if we are in a L1 and the user uses the local guest CID, it works, but i=
f
it uses the HOST_CID, the packet will go to the L0.

If we are in L0, it could be simple, because we can simply check if G2H
is not loaded, so any packet to CID_HOST, is host loopback.

I think that if the user uses the IOCTL_VM_SOCKETS_GET_LOCAL_CID, to set
the dest CID for the loopback, it works in both cases because we return the
HOST_CID in L0, and always the guest CID in L1, also if a H2G is loaded to
handle the L2.

Maybe we should document this in the man page.

But I have a question: Does vmci support the host loopback?
I've tried, and it seems not.

Also vhost-vsock doesn't support it, but virtio-vsock does.

> >=20
> > Since several people asked about this feature at the KVM Forum, I would=
 like
> > to add a new VMADDR_CID_LOCAL (i.e. using the reserved 1) and implement
> > loopback in the core.
> >=20
> > What do you think?
>=20
> What kind of use cases are mentioned in the KVM forum for loopback? One c=
oncern
> is that we have to maintain yet another interprocess communication mechan=
ism,
> even though other choices exist already  (and those are likely to be more=
 efficient
> given the development time and specific focus that went into those). To m=
e, the
> local connections are mainly useful as a way to sanity test the protocol =
and transports.
> However, if loopback is compelling, it would make sense have it in the co=
re, since it
> shouldn't need a specific transport.=20

The common use cases is for developer point of view, and to test the
protocol and transports as you said.

People that are introducing VSOCK support in their projects, would like to
test them on their own PC without starting a VM.

The idea is to move the code to handle loopback from the virtio-vsock,
in the core, but in another series :-)

>=20
> >=20
> > > If we select transport during bind to a specific CID, this comment
> >=20
> > Also in this case, are you talking about the peer that will call
> > connect()?
>=20
> The same thought as mentioned in the beginning - but as mentioned
> above, I agree that your updated bind and transport selection should
> handle this as well.

Got it.

Thanks,
Stefano


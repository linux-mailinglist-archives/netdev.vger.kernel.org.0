Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1BFCEF8C55
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 10:59:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727233AbfKLJ7T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 04:59:19 -0500
Received: from mail-eopbgr750053.outbound.protection.outlook.com ([40.107.75.53]:52647
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725899AbfKLJ7S (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Nov 2019 04:59:18 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M+1Kik3HbB/I4dD6iX1MjiG4XPRZEvI1sDauDsfE1tDTPVvaPcrnNs1Aw4Hk10+obWNW3YF1PvJorS1B3Mzvv/PkeJF0i5bmH2VvXv1QLbi4Yk5CCOF4qOwHcegGVTLUcDU3supzIpu/aIQyg56mBQsC7IkH3+UEmYmJC6hbF1f4pZiDqHiGJkPFzaDJHo7DyejKhDkpYms8x9kg/a31S55U7JhiMOA5VoRZicR4hSB0RbD7LE3Sqkviuvzrgvqx8zegmpeA/dY/A0RpxbKo0oFfi9dfTeFH39y0+7seXyAq5yh2YhVnIfcMbtcqDNnuEPwsE5HYSVf+nrsfmylXyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hnB+URNR5KQXvtEQBC8NZJVUf5ATZ6vNJRSpQFvOto0=;
 b=Kp5EiH5F5lRdgYM6vTmp+VbX60GRA7AnFCFq9HNy+vSOKtQMXz4bdZPrhmGFom0KytozO2N+wXiA4iLzVvL1+d3/zB4Pk6ife9xGfQ9YIJqFpusNrTowHf3RXYJx/Z+1Kx8ChqmTgFOQm4EchU5xfXO6U5miVgIb8KngkhhXQ11ljdUzcQVMJ07YgELgVq7wX1U2Txkjd8NfGz2U5nMH4WMiEjHIksnRABr5AAMgt4RFNAqvOoqdcs0OR4PMKjARy2fBiGjaAag6nF5RoOmo81czVmkf9rA2dOH5K/KgXZs3kaXTlbJCZz1+jaU8le7aWxcsFNiTKFSeHYZotz7L/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vmware.com; dmarc=pass action=none header.from=vmware.com;
 dkim=pass header.d=vmware.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hnB+URNR5KQXvtEQBC8NZJVUf5ATZ6vNJRSpQFvOto0=;
 b=nym9izq4rYVReJtb6M+Oqhxt6/g6QgrfbVMC10OecoP//baIUXyXYqd0zAg996fDwMBiT3gDvJcSu4cpxOCXqa4bELv00OJt04yHyMpWt1BW195fYxZiqLJT3D6Sf1sedXKMWPIzHZg9usFRoqvR7qFnTbvDTqSoGPAqvUtk5uA=
Received: from MWHPR05MB3376.namprd05.prod.outlook.com (10.174.175.149) by
 MWHPR05MB2815.namprd05.prod.outlook.com (10.168.245.146) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2451.21; Tue, 12 Nov 2019 09:59:13 +0000
Received: from MWHPR05MB3376.namprd05.prod.outlook.com
 ([fe80::4098:2c39:d8d3:a209]) by MWHPR05MB3376.namprd05.prod.outlook.com
 ([fe80::4098:2c39:d8d3:a209%7]) with mapi id 15.20.2451.018; Tue, 12 Nov 2019
 09:59:12 +0000
From:   Jorgen Hansen <jhansen@vmware.com>
To:     'Stefano Garzarella' <sgarzare@redhat.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
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
Subject: RE: [PATCH net-next 11/14] vsock: add multi-transports support
Thread-Topic: [PATCH net-next 11/14] vsock: add multi-transports support
Thread-Index: AQHViYhm3+s3qIN1EEmJgzgCfyvFAqeGCo7QgABKOACAAQ6AQA==
Date:   Tue, 12 Nov 2019 09:59:12 +0000
Message-ID: <MWHPR05MB33764F82AFA882B921A11E56DA770@MWHPR05MB3376.namprd05.prod.outlook.com>
References: <20191023095554.11340-1-sgarzare@redhat.com>
 <20191023095554.11340-12-sgarzare@redhat.com>
 <MWHPR05MB33761FE4DA27130C72FC5048DA740@MWHPR05MB3376.namprd05.prod.outlook.com>
 <20191111171740.xwo7isdmtt7ywibo@steredhat>
In-Reply-To: <20191111171740.xwo7isdmtt7ywibo@steredhat>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=jhansen@vmware.com; 
x-originating-ip: [208.91.2.2]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a2ec1a5d-5f63-441d-dfaf-08d76756f878
x-ms-traffictypediagnostic: MWHPR05MB2815:
x-microsoft-antispam-prvs: <MWHPR05MB2815A531CCA8D39A5ABC467EDA770@MWHPR05MB2815.namprd05.prod.outlook.com>
x-vmwhitelist: True
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 021975AE46
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(376002)(346002)(366004)(136003)(396003)(43544003)(189003)(199004)(476003)(8676002)(76116006)(76176011)(7696005)(6436002)(66946007)(74316002)(7736002)(316002)(102836004)(53546011)(6506007)(6916009)(305945005)(5660300002)(26005)(4326008)(11346002)(446003)(8936002)(81156014)(81166006)(486006)(6246003)(25786009)(7416002)(66066001)(52536014)(66556008)(14454004)(478600001)(66446008)(64756008)(99286004)(229853002)(2906002)(9686003)(86362001)(186003)(54906003)(33656002)(71190400001)(71200400001)(66476007)(55016002)(6116002)(3846002)(256004)(14444005);DIR:OUT;SFP:1101;SCL:1;SRVR:MWHPR05MB2815;H:MWHPR05MB3376.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: vmware.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: w0KwgTGwgWNJie4Y02bZQl8VgyyuPNMNRv3c3Quuneb8gsDJMPR0rEp/Iu55udVZxliGIK9Gq0z6vaRris7PmxHu6lB6L8+0e1w1nsFnRBLBRMl0eyGV/rAlE36GUbg6KlMTY++/U6AsmSOHSvhaybHESrQL45nul+WndUNORqDhX6Sq0iwdAC3Yo4j6PCUjVRi5gm/FwJl8g05S96gpGNCL6/W2HOUnWeZ9UJelsRR6enzSjsg1YokkGRJZjuGbqUWpc8OkFMOXEbivClc2huk/iRu55eGUBjhrNwuUCstmXOd61mr/VKJDiipvgZrwD3R/wQMExiB0MOSvYo2FuUzxc2ZiXj5MUAl8MglekzNUfMPsVZamvd4TQW9fmvezt0mUE0WVo+sifexrU6Zk7TZDdTjjoMI0C8W4he1ACbETdxjPCCXdPN4LfncRBW+r
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a2ec1a5d-5f63-441d-dfaf-08d76756f878
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Nov 2019 09:59:12.8424
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: L3FgC4NNAX8vMDP9RyqM0A+rfAc+t0dUMm+0rsS0ubm+H0GGhGGJrgWWGj3UluOeRhvl1gfIBXKkxCh1l8hLRw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR05MB2815
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Stefano Garzarella [mailto:sgarzare@redhat.com]
> Sent: Monday, November 11, 2019 6:18 PM
> To: Jorgen Hansen <jhansen@vmware.com>
> Subject: Re: [PATCH net-next 11/14] vsock: add multi-transports support
>=20
> On Mon, Nov 11, 2019 at 01:53:39PM +0000, Jorgen Hansen wrote:
> > > From: Stefano Garzarella [mailto:sgarzare@redhat.com]
> > > Sent: Wednesday, October 23, 2019 11:56 AM
> >
> > Thanks a lot for working on this!
> >
>=20
> Thanks to you for the reviews!
>=20
> > > With the multi-transports support, we can use vsock with nested VMs
> (using
> > > also different hypervisors) loading both guest->host and
> > > host->guest transports at the same time.
> > >
> > > Major changes:
> > > - vsock core module can be loaded regardless of the transports
> > > - vsock_core_init() and vsock_core_exit() are renamed to
> > >   vsock_core_register() and vsock_core_unregister()
> > > - vsock_core_register() has a feature parameter (H2G, G2H, DGRAM)
> > >   to identify which directions the transport can handle and if it's
> > >   support DGRAM (only vmci)
> > > - each stream socket is assigned to a transport when the remote CID
> > >   is set (during the connect() or when we receive a connection reques=
t
> > >   on a listener socket).
> >
> > How about allowing the transport to be set during bind as well? That
> > would allow an application to ensure that it is using a specific transp=
ort,
> > i.e., if it binds to the host CID, it will use H2G, and if it binds to =
something
> > else it will use G2H? You can still use VMADDR_CID_ANY if you want to
> > initially listen to both transports.
>=20
> Do you mean for socket that will call the connect()?

I was just thinking that in general we know the transport at that point, so=
 we
could ensure that the socket would only see traffic from the relevant trans=
port,
but as you mention below -  the updated bind lookup, and the added checks
when selecting transport should also take care of this, so that is fine.
=20
> For listener socket the "[PATCH net-next 14/14] vsock: fix bind() behavio=
ur
> taking care of CID" provides this behaviour.
> Since the listener sockets don't use any transport specific callback
> (they don't send any data to the remote peer), but they are used as
> placeholder,
> we don't need to assign them to a transport.
>=20
> >
> >
> > >   The remote CID is used to decide which transport to use:
> > >   - remote CID > VMADDR_CID_HOST will use host->guest transport
> > >   - remote CID <=3D VMADDR_CID_HOST will use guest->host transport
> > > - listener sockets are not bound to any transports since no transport
> > >   operations are done on it. In this way we can create a listener
> > >   socket, also if the transports are not loaded or with VMADDR_CID_AN=
Y
> > >   to listen on all transports.
> > > - DGRAM sockets are handled as before, since only the vmci_transport
> > >   provides this feature.
> > >
> > > Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> > > ---
> > > RFC -> v1:
> > > - documented VSOCK_TRANSPORT_F_* flags
> > > - fixed vsock_assign_transport() when the socket is already assigned
> > >   (e.g connection failed)
> > > - moved features outside of struct vsock_transport, and used as
> > >   parameter of vsock_core_register()
> > > ---
> > >  drivers/vhost/vsock.c                   |   5 +-
> > >  include/net/af_vsock.h                  |  17 +-
> > >  net/vmw_vsock/af_vsock.c                | 237 ++++++++++++++++++----=
--
> > >  net/vmw_vsock/hyperv_transport.c        |  26 ++-
> > >  net/vmw_vsock/virtio_transport.c        |   7 +-
> > >  net/vmw_vsock/virtio_transport_common.c |  28 ++-
> > >  net/vmw_vsock/vmci_transport.c          |  31 +++-
> > >  7 files changed, 270 insertions(+), 81 deletions(-)
> > >
> >
> >
> > > diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
> index
> > > d89381166028..dddd85d9a147 100644
> > > --- a/net/vmw_vsock/af_vsock.c
> > > +++ b/net/vmw_vsock/af_vsock.c
> > > @@ -130,7 +130,12 @@ static struct proto vsock_proto =3D {  #define
> > > VSOCK_DEFAULT_BUFFER_MAX_SIZE (1024 * 256)  #define
> > > VSOCK_DEFAULT_BUFFER_MIN_SIZE 128
> > >
> > > -static const struct vsock_transport *transport_single;
> > > +/* Transport used for host->guest communication */ static const stru=
ct
> > > +vsock_transport *transport_h2g;
> > > +/* Transport used for guest->host communication */ static const stru=
ct
> > > +vsock_transport *transport_g2h;
> > > +/* Transport used for DGRAM communication */ static const struct
> > > +vsock_transport *transport_dgram;
> > >  static DEFINE_MUTEX(vsock_register_mutex);
> > >
> > >  /**** UTILS ****/
> > > @@ -182,7 +187,7 @@ static int vsock_auto_bind(struct vsock_sock *vsk=
)
> > >  	return __vsock_bind(sk, &local_addr);
> > >  }
> > >
> > > -static int __init vsock_init_tables(void)
> > > +static void vsock_init_tables(void)
> > >  {
> > >  	int i;
> > >
> > > @@ -191,7 +196,6 @@ static int __init vsock_init_tables(void)
> > >
> > >  	for (i =3D 0; i < ARRAY_SIZE(vsock_connected_table); i++)
> > >  		INIT_LIST_HEAD(&vsock_connected_table[i]);
> > > -	return 0;
> > >  }
> > >
> > >  static void __vsock_insert_bound(struct list_head *list, @@ -376,6
> +380,62
> > > @@ void vsock_enqueue_accept(struct sock *listener, struct sock
> > > *connected)  }  EXPORT_SYMBOL_GPL(vsock_enqueue_accept);
> > >
> > > +/* Assign a transport to a socket and call the .init transport callb=
ack.
> > > + *
> > > + * Note: for stream socket this must be called when vsk->remote_addr
> is
> > > +set
> > > + * (e.g. during the connect() or when a connection request on a
> > > +listener
> > > + * socket is received).
> > > + * The vsk->remote_addr is used to decide which transport to use:
> > > + *  - remote CID > VMADDR_CID_HOST will use host->guest transport
> > > + *  - remote CID <=3D VMADDR_CID_HOST will use guest->host transport
> */
> > > +int vsock_assign_transport(struct vsock_sock *vsk, struct vsock_sock
> > > +*psk) {
> > > +	const struct vsock_transport *new_transport;
> > > +	struct sock *sk =3D sk_vsock(vsk);
> > > +
> > > +	switch (sk->sk_type) {
> > > +	case SOCK_DGRAM:
> > > +		new_transport =3D transport_dgram;
> > > +		break;
> > > +	case SOCK_STREAM:
> > > +		if (vsk->remote_addr.svm_cid > VMADDR_CID_HOST)
> > > +			new_transport =3D transport_h2g;
> > > +		else
> > > +			new_transport =3D transport_g2h;
> > > +		break;
> >
> > You already mentioned that you are working on a fix for loopback
> > here for the guest, but presumably a host could also do loopback.
>=20
> IIUC we don't support loopback in the host, because in this case the
> application will use the CID_HOST as address, but if we are in a nested
> VM environment we are in trouble.

If both src and dst CID are CID_HOST, we should be fairly sure that this
Is host loopback, no? If src is anything else, we would do G2H.

>=20
> Since several people asked about this feature at the KVM Forum, I would l=
ike
> to add a new VMADDR_CID_LOCAL (i.e. using the reserved 1) and implement
> loopback in the core.
>=20
> What do you think?

What kind of use cases are mentioned in the KVM forum for loopback? One con=
cern
is that we have to maintain yet another interprocess communication mechanis=
m,
even though other choices exist already  (and those are likely to be more e=
fficient
given the development time and specific focus that went into those). To me,=
 the
local connections are mainly useful as a way to sanity test the protocol an=
d transports.
However, if loopback is compelling, it would make sense have it in the core=
, since it
shouldn't need a specific transport.=20

>=20
> > If we select transport during bind to a specific CID, this comment
>=20
> Also in this case, are you talking about the peer that will call
> connect()?

The same thought as mentioned in the beginning - but as mentioned
above, I agree that your updated bind and transport selection should
handle this as well.
=20
> > Isn't relevant, but otherwise, we should look at the local addr as
> > well, since a socket with local addr of host CID shouldn't use
> > the guest to host transport, and a socket with local addr > host CID
> > shouldn't use host to guest.
>=20
> Yes, I agree, in my fix I'm looking at the local addr, and in L1 I'll
> not allow to assign a CID to a nested L2 equal to the CID of L1 (in
> vhost-vsock)
>=20
> Maybe we can allow the host loopback (using CID_HOST), only if there isn'=
t
> G2H loaded, but also in this case I'd like to move the loopback in the vs=
ock
> core, since we can do that, also if there are no transports loaded.
> >
> >
> > > +	default:
> > > +		return -ESOCKTNOSUPPORT;
> > > +	}
> > > +
> > > +	if (vsk->transport) {
> > > +		if (vsk->transport =3D=3D new_transport)
> > > +			return 0;
> > > +
> > > +		vsk->transport->release(vsk);
> > > +		vsk->transport->destruct(vsk);
> > > +	}
> > > +
> > > +	if (!new_transport)
> > > +		return -ENODEV;
> > > +
> > > +	vsk->transport =3D new_transport;
> > > +
> > > +	return vsk->transport->init(vsk, psk); }
> > > +EXPORT_SYMBOL_GPL(vsock_assign_transport);
> > > +
> > > +static bool vsock_find_cid(unsigned int cid) {
> > > +	if (transport_g2h && cid =3D=3D transport_g2h->get_local_cid())
> > > +		return true;
> > > +
> > > +	if (transport_h2g && cid =3D=3D VMADDR_CID_HOST)
> > > +		return true;
> > > +
> > > +	return false;
> > > +}
> > > +
> > >  static struct sock *vsock_dequeue_accept(struct sock *listener)  {
> > >  	struct vsock_sock *vlistener;
> >
> >
> > > diff --git a/net/vmw_vsock/vmci_transport.c
> > > b/net/vmw_vsock/vmci_transport.c index 5955238ffc13..2eb3f16d53e7
> > > 100644
> > > --- a/net/vmw_vsock/vmci_transport.c
> > > +++ b/net/vmw_vsock/vmci_transport.c
> >
> > > @@ -1017,6 +1018,15 @@ static int vmci_transport_recv_listen(struct
> sock
> > > *sk,
> > >  	vsock_addr_init(&vpending->remote_addr, pkt->dg.src.context,
> > >  			pkt->src_port);
> > >
> > > +	err =3D vsock_assign_transport(vpending, vsock_sk(sk));
> > > +	/* Transport assigned (looking at remote_addr) must be the same
> > > +	 * where we received the request.
> > > +	 */
> > > +	if (err || !vmci_check_transport(vpending)) {
> >
> > We need to send a reset on error, i.e.,
> >   vmci_transport_send_reset(sk, pkt);
>=20
> Good catch, I'll fix in the v2.
>=20
> Thanks,
> Stefano

Thanks,
Jorgen

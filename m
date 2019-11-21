Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E3D3105609
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 16:54:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726714AbfKUPx4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Nov 2019 10:53:56 -0500
Received: from mail-eopbgr730087.outbound.protection.outlook.com ([40.107.73.87]:12512
        "EHLO NAM05-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726279AbfKUPx4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 Nov 2019 10:53:56 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YLy2Z1rObqHKh7BrkIOgCOFunWItBTaVzzUnrtQQsGy/PJTMJYc8iKr0+T7GDb4Fuswy3pBFF78EMp0get9JmEtHR/UQdlck1AXTzreHGRaMdqGMf6BUg6pgFoKEgiN37uyLZ61PJ41lFRwAe+cJ/NJsnI8eGb7ykum0NYFshGHNN/AHN8PsAUbqATcKoZVHQk+niqXw1YqqoQlXPtPdDZKqdHFGf2JYA3C+glD60es6s4ttPCSMC9dGI5mIYIa15SR6mxmyH1JLkMHS0/tdVNn98vz1Es3lYiG2bFU8ue1f3PQSdFwgnU5tuv5o5qIAALDf2iqK5lT9VvZp0oHppw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ax36A33+/7b7muHsk6F44iGcyRMic1uTUlDCkdwx5fo=;
 b=FbSab7gn56CSAWIWfvEIeoww1ytypXZVx6QooKgyIheLf0nL9nTH+W8rMVYF+bg3E8TdzgeWsqsHM1cVJCyA1faDU9KbhwdcAfZeCtlZORHDA/fbWEKzUDxa4vmZRAdMgh139CY1AtwH01O/aGynedXkxIhmnQiXB+Uh0SgARzyeZ+h9zSRxN1fxeisH2LESuXc93KpaDrWhGXUEyomYCZu8YkzpBZ6nZ0JjZu7MxPpfqo0uN/J4oxEAEp6FOWgkOv50pd7QWAWjgvEfHFljBTWUabCDPpGBMih2M07KUmrRfc+7U4Iad8t/LUj4Hf8bDahO42OL6H24PSk4zdWKhg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vmware.com; dmarc=pass action=none header.from=vmware.com;
 dkim=pass header.d=vmware.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ax36A33+/7b7muHsk6F44iGcyRMic1uTUlDCkdwx5fo=;
 b=nIUnnFA6TPyGEppLSEeyisjLvSrQvKnk1Qp531tT7q+O4xSS+9YT+NgmwVtOioki1jQGnQPSxmmf4A3CCoNuT7Bz3oqPMIj9SM1Mf0pU6oSpeUnBilJVKf/VZVyM5uUMFYJqPsCLJVfeR4GD35kH9h4NL+/ZRJzjBLOM/irg8H8=
Received: from MWHPR05MB3376.namprd05.prod.outlook.com (10.174.175.149) by
 MWHPR05MB3631.namprd05.prod.outlook.com (10.174.251.17) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2474.9; Thu, 21 Nov 2019 15:53:47 +0000
Received: from MWHPR05MB3376.namprd05.prod.outlook.com
 ([fe80::4098:2c39:d8d3:a209]) by MWHPR05MB3376.namprd05.prod.outlook.com
 ([fe80::4098:2c39:d8d3:a209%7]) with mapi id 15.20.2474.015; Thu, 21 Nov 2019
 15:53:47 +0000
From:   Jorgen Hansen <jhansen@vmware.com>
To:     'Stefano Garzarella' <sgarzare@redhat.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        Dexuan Cui <decui@microsoft.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: RE: [PATCH net-next 3/6] vsock: add local transport support in the
 vsock core
Thread-Topic: [PATCH net-next 3/6] vsock: add local transport support in the
 vsock core
Thread-Index: AQHVnsi6A5C79S6UD0KKiVDL3k1B8qeVuhZQgAAHIACAAAGVwA==
Date:   Thu, 21 Nov 2019 15:53:47 +0000
Message-ID: <MWHPR05MB3376D95B5E50DF7CAF675EEDDA4E0@MWHPR05MB3376.namprd05.prod.outlook.com>
References: <20191119110121.14480-1-sgarzare@redhat.com>
 <20191119110121.14480-4-sgarzare@redhat.com>
 <MWHPR05MB3376F4452F0CF38C1AFABA2EDA4E0@MWHPR05MB3376.namprd05.prod.outlook.com>
 <20191121152148.slv26oesn25dpjb6@steredhat>
In-Reply-To: <20191121152148.slv26oesn25dpjb6@steredhat>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=jhansen@vmware.com; 
x-originating-ip: [208.91.2.1]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2e5c9b05-5229-47b4-ccf0-08d76e9afed2
x-ms-traffictypediagnostic: MWHPR05MB3631:
x-microsoft-antispam-prvs: <MWHPR05MB36318B83B106F7C7BC15AE85DA4E0@MWHPR05MB3631.namprd05.prod.outlook.com>
x-vmwhitelist: True
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0228DDDDD7
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(136003)(346002)(396003)(366004)(39860400002)(199004)(189003)(26005)(316002)(7736002)(76116006)(7696005)(71190400001)(71200400001)(81166006)(81156014)(446003)(186003)(86362001)(6116002)(9686003)(11346002)(2906002)(55016002)(229853002)(53546011)(6506007)(6246003)(3846002)(54906003)(305945005)(5660300002)(66066001)(6916009)(14444005)(256004)(99286004)(102836004)(478600001)(76176011)(52536014)(4326008)(66446008)(25786009)(74316002)(64756008)(66556008)(66476007)(66946007)(14454004)(33656002)(6436002)(8676002)(8936002);DIR:OUT;SFP:1101;SCL:1;SRVR:MWHPR05MB3631;H:MWHPR05MB3376.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: vmware.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +vH6rivpM+K+oUMpPEMVav7Sl2MrxAoPXzcRQ8N+uWElk5NMAk0udjqWIEDwSSfwNHx201zBGkj5SoJ8VyNQ/BA9OU5BqGX9Uay0lo5Jy7lhg98D35SH6Rpqf1j0ImFzMzOaZXKnxMtBboOy5mxlIwR2SSeI9P2OWVUPLPTM8OThsR73HKBUjFd8XZRiClvA/JR2e+i8gnnR8NEx69o/ppjJlLvw9q31/sn2Tj1HLM+TIXH8b+/L6KVN+0lE+rrjOkiHaXxxofsAdOfOrQDaG7scl9rSohtquieEDIghd6OzO+/y0XuCaW2JZ0OVL5C3vn/dQHBYQap/MrDHz7rN7lQqk+SMBikDd0N+gBZLQklol8eShtvx9N0Kam6qf3GaeMdfWmaZuXrtdzA0cQHQhKP6jocm365oSOiKvGVR2lcNi5stCr+FJ59GwgDi4qkR
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2e5c9b05-5229-47b4-ccf0-08d76e9afed2
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Nov 2019 15:53:47.5041
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: givXglQbZQq/2XbesKUQxk8Opz91jIATMfbuuqBBpyG7EJ1IpGBoo7zlKby34bsHddIWJch2qHy6mYfoEUkouA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR05MB3631
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Stefano Garzarella [mailto:sgarzare@redhat.com]
> Sent: Thursday, November 21, 2019 4:22 PM
>=20
> On Thu, Nov 21, 2019 at 03:04:18PM +0000, Jorgen Hansen wrote:
> > > From: Stefano Garzarella [mailto:sgarzare@redhat.com]
> > > Sent: Tuesday, November 19, 2019 12:01 PM
> > > To: netdev@vger.kernel.org
> > >
> > > This patch allows to register a transport able to handle
> > > local communication (loopback).
> > >
> > > Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> > > ---
> > >  include/net/af_vsock.h   |  2 ++
> > >  net/vmw_vsock/af_vsock.c | 17 ++++++++++++++++-
> > >  2 files changed, 18 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/include/net/af_vsock.h b/include/net/af_vsock.h
> > > index 4206dc6d813f..b1c717286993 100644
> > > --- a/include/net/af_vsock.h
> > > +++ b/include/net/af_vsock.h
> > > @@ -98,6 +98,8 @@ struct vsock_transport_send_notify_data {
> > >  #define VSOCK_TRANSPORT_F_G2H		0x00000002
> > >  /* Transport provides DGRAM communication */
> > >  #define VSOCK_TRANSPORT_F_DGRAM		0x00000004
> > > +/* Transport provides local (loopback) communication */
> > > +#define VSOCK_TRANSPORT_F_LOCAL		0x00000008
> > >
> > >  struct vsock_transport {
> > >  	struct module *module;
> > > diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
> > > index cc8659838bf2..c9e5bad59dc1 100644
> > > --- a/net/vmw_vsock/af_vsock.c
> > > +++ b/net/vmw_vsock/af_vsock.c
> > > @@ -136,6 +136,8 @@ static const struct vsock_transport
> *transport_h2g;
> > >  static const struct vsock_transport *transport_g2h;
> > >  /* Transport used for DGRAM communication */
> > >  static const struct vsock_transport *transport_dgram;
> > > +/* Transport used for local communication */
> > > +static const struct vsock_transport *transport_local;
> > >  static DEFINE_MUTEX(vsock_register_mutex);
> > >
> > >  /**** UTILS ****/
> > > @@ -2130,7 +2132,7 @@
> EXPORT_SYMBOL_GPL(vsock_core_get_transport);
> > >
> > >  int vsock_core_register(const struct vsock_transport *t, int feature=
s)
> > >  {
> > > -	const struct vsock_transport *t_h2g, *t_g2h, *t_dgram;
> > > +	const struct vsock_transport *t_h2g, *t_g2h, *t_dgram, *t_local;
> > >  	int err =3D mutex_lock_interruptible(&vsock_register_mutex);
> > >
> > >  	if (err)
> > > @@ -2139,6 +2141,7 @@ int vsock_core_register(const struct
> > > vsock_transport *t, int features)
> > >  	t_h2g =3D transport_h2g;
> > >  	t_g2h =3D transport_g2h;
> > >  	t_dgram =3D transport_dgram;
> > > +	t_local =3D transport_local;
> > >
> > >  	if (features & VSOCK_TRANSPORT_F_H2G) {
> > >  		if (t_h2g) {
> > > @@ -2164,9 +2167,18 @@ int vsock_core_register(const struct
> > > vsock_transport *t, int features)
> > >  		t_dgram =3D t;
> > >  	}
> > >
> > > +	if (features & VSOCK_TRANSPORT_F_LOCAL) {
> > > +		if (t_local) {
> > > +			err =3D -EBUSY;
> > > +			goto err_busy;
> > > +		}
> > > +		t_local =3D t;
> > > +	}
> > > +
> > >  	transport_h2g =3D t_h2g;
> > >  	transport_g2h =3D t_g2h;
> > >  	transport_dgram =3D t_dgram;
> > > +	transport_local =3D t_local;
> > >
> > >  err_busy:
> > >  	mutex_unlock(&vsock_register_mutex);
> > > @@ -2187,6 +2199,9 @@ void vsock_core_unregister(const struct
> > > vsock_transport *t)
> > >  	if (transport_dgram =3D=3D t)
> > >  		transport_dgram =3D NULL;
> > >
> > > +	if (transport_local =3D=3D t)
> > > +		transport_local =3D NULL;
> > > +
> > >  	mutex_unlock(&vsock_register_mutex);
> > >  }
> > >  EXPORT_SYMBOL_GPL(vsock_core_unregister);
> > > --
> > > 2.21.0
> >
> > Having loopback support as a separate transport fits nicely, but do we =
need
> to support
> > different variants of loopback? It could just be built in.
>=20
> I agree with you, indeed initially I developed it as built in, but
> DEPMOD found a cyclic dependency because vsock_transport use
> virtio_transport_common that use vsock, so if I include vsock_transport
> in the vsock module, DEPMOD is not happy.
>=20
> I don't know how to break this cyclic dependency, do you have any ideas?

One way to view this would be that the loopback transport and the support
it uses from virtio_transport_common are independent of virtio as such,
and could be part of  the af_vsock module if loopback is configured. So
in a way, the virtio g2h and h2g transports would be extensions of the
built in loopback transport. But that brings in quite a bit of code so
it could be better to just keep it as is.

Thanks,
Jorgen

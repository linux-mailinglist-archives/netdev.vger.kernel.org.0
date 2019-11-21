Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 980231056D8
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 17:19:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727007AbfKUQTx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Nov 2019 11:19:53 -0500
Received: from mail-eopbgr820088.outbound.protection.outlook.com ([40.107.82.88]:60806
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726967AbfKUQTw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 Nov 2019 11:19:52 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eqY3UcW7dWiAWKrXduoXp9x/JZ0SaFQrakwrJQbgU2KqgNgAoD5gbfcVvVTs4UlIDavIcUDYOI5/qIFi7Y+OWbSImHB5QUtgHgN3NtfqsFnHtb9gKR4pVpwA+NRnQJl1fBghebqnjhIX56AZJ5mUie4SRkh8Hn9MI2RosYmOOqkISIQxVljH7rd4oJAT2t5MpfHZmoSwSec0uiH+yHX5xvQdWEZBHshHmfEjC2+LFnVAtkL1n3cdhDjWvXMIzy098WKVTQzJpVCSQ0eMSY38VqXGyAVc38I0UyUwqAO5UgwFmWQDlfHjUJGDZZOkVwPggpWO3NYdu+jcVdGxZLTR5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QMMeBq/9aomTlwObrpenS8dw0g+uYMvvmqOUnyCj2Rw=;
 b=frC6yKhoLpUlY8homFn9WDxt3AFedNK6KRtsQW+QMjXjyzo0Bpj1qXEc4HsA3wiW5W7X3X0G9MLTgFv3RqDe3AuN7cI0FVfxWohBv58an/uNYE6P3s9hGApAIQm4V4EFf1nVJ35IVahuDjUxHTuH8fOaet/mX9epTgD2LS4/Cl/KrPBLcxqwEFV4kVSB3wYLqhibMHiiRSJJtCqohLVQDDu8WQGcbwY6gvT8FAzRTqSUmMpCl4cYpeqljiQzgw+E6IQzkspcPcqCpryQk5L14Tgvgio3z0RlMD3DCsd8xMZyFPgRCtEWovvSJS30z/3BvyA7fJ+O8cJFs1NdBYA0yw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vmware.com; dmarc=pass action=none header.from=vmware.com;
 dkim=pass header.d=vmware.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QMMeBq/9aomTlwObrpenS8dw0g+uYMvvmqOUnyCj2Rw=;
 b=Fwh5P52pmi7hZm4F1NaUh6pgARKKNvFpcXNEXJbsIrzD9swm3+SPHByi+OoWHa7T+icq2sG7UccF87M6Bukfkc2cFaeBBQB549cJzhPCztS8+167QGIiDz+oHwDdDygc2YGHrwsDwSg7l2sGRQN93gZtAsKBjah4Ic6hhQXMqTo=
Received: from MWHPR05MB3376.namprd05.prod.outlook.com (10.174.175.149) by
 MWHPR05MB3677.namprd05.prod.outlook.com (10.174.175.30) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2474.13; Thu, 21 Nov 2019 16:19:46 +0000
Received: from MWHPR05MB3376.namprd05.prod.outlook.com
 ([fe80::4098:2c39:d8d3:a209]) by MWHPR05MB3376.namprd05.prod.outlook.com
 ([fe80::4098:2c39:d8d3:a209%7]) with mapi id 15.20.2474.015; Thu, 21 Nov 2019
 16:19:46 +0000
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
Thread-Index: AQHVnsi6A5C79S6UD0KKiVDL3k1B8qeVuhZQgAAHIACAAAGVwIAADKqAgAAA1wA=
Date:   Thu, 21 Nov 2019 16:19:46 +0000
Message-ID: <MWHPR05MB33765BAE0807B11C507FF626DA4E0@MWHPR05MB3376.namprd05.prod.outlook.com>
References: <20191119110121.14480-1-sgarzare@redhat.com>
 <20191119110121.14480-4-sgarzare@redhat.com>
 <MWHPR05MB3376F4452F0CF38C1AFABA2EDA4E0@MWHPR05MB3376.namprd05.prod.outlook.com>
 <20191121152148.slv26oesn25dpjb6@steredhat>
 <MWHPR05MB3376D95B5E50DF7CAF675EEDDA4E0@MWHPR05MB3376.namprd05.prod.outlook.com>
 <20191121161247.u6xvrso272q4ujag@steredhat>
In-Reply-To: <20191121161247.u6xvrso272q4ujag@steredhat>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=jhansen@vmware.com; 
x-originating-ip: [208.91.2.1]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a7c3599a-916f-4256-3f3d-08d76e9ea033
x-ms-traffictypediagnostic: MWHPR05MB3677:
x-microsoft-antispam-prvs: <MWHPR05MB3677C2D988B3D0C1FF801400DA4E0@MWHPR05MB3677.namprd05.prod.outlook.com>
x-vmwhitelist: True
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0228DDDDD7
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(396003)(346002)(366004)(39860400002)(376002)(189003)(199004)(2906002)(66476007)(66946007)(7696005)(76176011)(4326008)(33656002)(66446008)(66556008)(64756008)(76116006)(5660300002)(52536014)(71190400001)(71200400001)(8936002)(99286004)(6916009)(74316002)(9686003)(55016002)(478600001)(7736002)(6246003)(8676002)(81156014)(81166006)(229853002)(6436002)(305945005)(3846002)(6116002)(316002)(14454004)(11346002)(446003)(256004)(14444005)(66066001)(86362001)(102836004)(26005)(54906003)(6506007)(53546011)(186003)(25786009);DIR:OUT;SFP:1101;SCL:1;SRVR:MWHPR05MB3677;H:MWHPR05MB3376.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: vmware.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 5hj/4Vnd8z7ohkqZBlDzjUhVarbLKNUFln3WcM3gbpQRybRJP2Zflqqlg+bhOKfeNv/MSMHRcJjPSZCg+CJVPjqgyEavAXG3k8pbCoSesFD62/+6sYeJeaIvERn2WIRoJtmArHsLPKzHJLJ5aNf1Fx2STM3r2hx6ewwsofuzir+pt23IbjoMOzHBg6J5dgpBT5/IT18Nuxjehx0sU9AS70k+g3uVanURowwYCSIYNAn1mE2N44mmXWKPbUHKHkRuQ0N6SMguI3M2Qi/Tcw6GNLdRxcPGs2A9NnCJkcb37mHXv8mawSEK+jAhQ2Z5aclHODvX0aRp0qpI1d9XP+jREFm4kTNrKal+Vj5YUV+JkZ/xzZPEwooufVH2SeWBI8lQKyAk1jKRBg+BiLSmuj2+B/ncgHX7D9aEIh/vEb2dazPYSoVtAwhe1KQTjz/jZPGF
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a7c3599a-916f-4256-3f3d-08d76e9ea033
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Nov 2019 16:19:46.6726
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4CDAl1ocMcevzE7ExJQBfnOklGjlc51jn2nk16Fb7hsT05ACP0LTQaIor+YpqXr5F05otBXkN5Y8IruDJkx2cg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR05MB3677
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Stefano Garzarella [mailto:sgarzare@redhat.com]
> Sent: Thursday, November 21, 2019 5:13 PM
>=20
> On Thu, Nov 21, 2019 at 03:53:47PM +0000, Jorgen Hansen wrote:
> > > From: Stefano Garzarella [mailto:sgarzare@redhat.com]
> > > Sent: Thursday, November 21, 2019 4:22 PM
> > >
> > > On Thu, Nov 21, 2019 at 03:04:18PM +0000, Jorgen Hansen wrote:
> > > > > From: Stefano Garzarella [mailto:sgarzare@redhat.com]
> > > > > Sent: Tuesday, November 19, 2019 12:01 PM
> > > > > To: netdev@vger.kernel.org
> > > > >
> > > > > This patch allows to register a transport able to handle
> > > > > local communication (loopback).
> > > > >
> > > > > Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> > > > > ---
> > > > >  include/net/af_vsock.h   |  2 ++
> > > > >  net/vmw_vsock/af_vsock.c | 17 ++++++++++++++++-
> > > > >  2 files changed, 18 insertions(+), 1 deletion(-)
> > > > >
> > > > > diff --git a/include/net/af_vsock.h b/include/net/af_vsock.h
> > > > > index 4206dc6d813f..b1c717286993 100644
> > > > > --- a/include/net/af_vsock.h
> > > > > +++ b/include/net/af_vsock.h
> > > > > @@ -98,6 +98,8 @@ struct vsock_transport_send_notify_data {
> > > > >  #define VSOCK_TRANSPORT_F_G2H		0x00000002
> > > > >  /* Transport provides DGRAM communication */
> > > > >  #define VSOCK_TRANSPORT_F_DGRAM		0x00000004
> > > > > +/* Transport provides local (loopback) communication */
> > > > > +#define VSOCK_TRANSPORT_F_LOCAL		0x00000008
> > > > >
> > > > >  struct vsock_transport {
> > > > >  	struct module *module;
> > > > > diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
> > > > > index cc8659838bf2..c9e5bad59dc1 100644
> > > > > --- a/net/vmw_vsock/af_vsock.c
> > > > > +++ b/net/vmw_vsock/af_vsock.c
> > > > > @@ -136,6 +136,8 @@ static const struct vsock_transport
> > > *transport_h2g;
> > > > >  static const struct vsock_transport *transport_g2h;
> > > > >  /* Transport used for DGRAM communication */
> > > > >  static const struct vsock_transport *transport_dgram;
> > > > > +/* Transport used for local communication */
> > > > > +static const struct vsock_transport *transport_local;
> > > > >  static DEFINE_MUTEX(vsock_register_mutex);
> > > > >
> > > > >  /**** UTILS ****/
> > > > > @@ -2130,7 +2132,7 @@
> > > EXPORT_SYMBOL_GPL(vsock_core_get_transport);
> > > > >
> > > > >  int vsock_core_register(const struct vsock_transport *t, int fea=
tures)
> > > > >  {
> > > > > -	const struct vsock_transport *t_h2g, *t_g2h, *t_dgram;
> > > > > +	const struct vsock_transport *t_h2g, *t_g2h, *t_dgram,
> *t_local;
> > > > >  	int err =3D mutex_lock_interruptible(&vsock_register_mutex);
> > > > >
> > > > >  	if (err)
> > > > > @@ -2139,6 +2141,7 @@ int vsock_core_register(const struct
> > > > > vsock_transport *t, int features)
> > > > >  	t_h2g =3D transport_h2g;
> > > > >  	t_g2h =3D transport_g2h;
> > > > >  	t_dgram =3D transport_dgram;
> > > > > +	t_local =3D transport_local;
> > > > >
> > > > >  	if (features & VSOCK_TRANSPORT_F_H2G) {
> > > > >  		if (t_h2g) {
> > > > > @@ -2164,9 +2167,18 @@ int vsock_core_register(const struct
> > > > > vsock_transport *t, int features)
> > > > >  		t_dgram =3D t;
> > > > >  	}
> > > > >
> > > > > +	if (features & VSOCK_TRANSPORT_F_LOCAL) {
> > > > > +		if (t_local) {
> > > > > +			err =3D -EBUSY;
> > > > > +			goto err_busy;
> > > > > +		}
> > > > > +		t_local =3D t;
> > > > > +	}
> > > > > +
> > > > >  	transport_h2g =3D t_h2g;
> > > > >  	transport_g2h =3D t_g2h;
> > > > >  	transport_dgram =3D t_dgram;
> > > > > +	transport_local =3D t_local;
> > > > >
> > > > >  err_busy:
> > > > >  	mutex_unlock(&vsock_register_mutex);
> > > > > @@ -2187,6 +2199,9 @@ void vsock_core_unregister(const struct
> > > > > vsock_transport *t)
> > > > >  	if (transport_dgram =3D=3D t)
> > > > >  		transport_dgram =3D NULL;
> > > > >
> > > > > +	if (transport_local =3D=3D t)
> > > > > +		transport_local =3D NULL;
> > > > > +
> > > > >  	mutex_unlock(&vsock_register_mutex);
> > > > >  }
> > > > >  EXPORT_SYMBOL_GPL(vsock_core_unregister);
> > > > > --
> > > > > 2.21.0
> > > >
> > > > Having loopback support as a separate transport fits nicely, but do=
 we
> need
> > > to support
> > > > different variants of loopback? It could just be built in.
> > >
> > > I agree with you, indeed initially I developed it as built in, but
> > > DEPMOD found a cyclic dependency because vsock_transport use
> > > virtio_transport_common that use vsock, so if I include vsock_transpo=
rt
> > > in the vsock module, DEPMOD is not happy.
> > >
> > > I don't know how to break this cyclic dependency, do you have any ide=
as?
> >
> > One way to view this would be that the loopback transport and the suppo=
rt
> > it uses from virtio_transport_common are independent of virtio as such,
> > and could be part of  the af_vsock module if loopback is configured. So
> > in a way, the virtio g2h and h2g transports would be extensions of the
> > built in loopback transport. But that brings in quite a bit of code so
> > it could be better to just keep it as is.
>=20
> Great idea!
>=20
> Stefan already suggested (as a long-term goal) to rename the generic
> functionality in virtio_transport_common.c
>=20
> Maybe I can do both in another series later on, since it requires enough
> changes.

Sounds good to me.

Thanks,
Jorgen


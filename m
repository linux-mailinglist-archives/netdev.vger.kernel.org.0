Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B5E6E9F47
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 16:40:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727278AbfJ3PkK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Oct 2019 11:40:10 -0400
Received: from mail-eopbgr700045.outbound.protection.outlook.com ([40.107.70.45]:63968
        "EHLO NAM04-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726302AbfJ3PkK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Oct 2019 11:40:10 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BTWmVKCBvLcveUa7heIEJSz5GFAkv8nmmlQzRoqbZQrfACX3giVPstiON2J+0+SiKsyqhFFiIOE+WSd2NASAo74QPpdOvl9/sg7NtXWIAxH2aIMBr7GY6JsSNv5qhT++OiI2CzySnZ/cn5QczRHAzBCi02CI63+P0kOSmWqzcNx+mbyM1EvtkzoOdNlUineNJ7sN+IotzK35anOsmU0gwQFFVkeGTey07eO+6nCI36cz+UE+JnfHRU4aoDY8Dl5OTQnmtgOOPvXQ0TqrYVBNjrJzUqZeV3kfWnaLwD7Mys49d/4GNRfK+mpimcCKgaZIEWTIMjxn06WgbLzk/pK04w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vc07ImVMgNVyLiULifycZRo6xqCv5Ysb5B4Llv8uH6k=;
 b=ONv7/B3fU82AAHksjsl0HAQtr8IIPltC8D0TUR1cXDv+Hgg8Gp46U3LFLRLwBeM6kyxF1THqNctHoZAPF7+1GtTpOjBPpQpXeVbSnRvl2go2GIgg9NfxFmyLFpdaqnBbqyn+X9xsHdm32eDuB2zVOqlJe0Koe941Den1I0aYJ8HrVS5t00wyfp117+fJrOrvrOuE+DYZvA18OmkDjfF1zq5BMtXFkAolp2rNJoXGqBzuaHdZCVBMsdjlTiVbAkaruNCdS9VQwJK8T+Z1ltyD/4YoWTY7IsSa0lGwg38OSjspGD5LAlCGCKj5avwpO+n0U8+tsVoxOd1ALO6KGJkRcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vmware.com; dmarc=pass action=none header.from=vmware.com;
 dkim=pass header.d=vmware.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vc07ImVMgNVyLiULifycZRo6xqCv5Ysb5B4Llv8uH6k=;
 b=P4sJgcQ7fTR3kYfo4kNOmjNRxzxgjLpBaPNAciBibbddM0Fc9XpcCNOOZnppPEIDF3z4921YTb/fzJwid2OLzp3aRl2GxA0NejmLIvomW1MkGadp+UBYz9Dcz+IMB2Rm3DtJpwB6T3ogxZTAQUvyYL1M7bg1tmy604MOczB9oFk=
Received: from MWHPR05MB3376.namprd05.prod.outlook.com (10.174.175.149) by
 MWHPR05MB2957.namprd05.prod.outlook.com (10.168.246.11) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2408.15; Wed, 30 Oct 2019 15:40:05 +0000
Received: from MWHPR05MB3376.namprd05.prod.outlook.com
 ([fe80::4098:2c39:d8d3:a209]) by MWHPR05MB3376.namprd05.prod.outlook.com
 ([fe80::4098:2c39:d8d3:a209%7]) with mapi id 15.20.2408.018; Wed, 30 Oct 2019
 15:40:05 +0000
From:   Jorgen Hansen <jhansen@vmware.com>
To:     'Stefano Garzarella' <sgarzare@redhat.com>
CC:     Sasha Levin <sashal@kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Arnd Bergmann <arnd@arndb.de>, kvm <kvm@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dexuan Cui <decui@microsoft.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH net-next 11/14] vsock: add multi-transports support
Thread-Topic: [PATCH net-next 11/14] vsock: add multi-transports support
Thread-Index: AQHViYhm3+s3qIN1EEmJgzgCfyvFAqdoVEGAgAsGKDA=
Date:   Wed, 30 Oct 2019 15:40:05 +0000
Message-ID: <MWHPR05MB3376E623764F54D39D8135A9DA600@MWHPR05MB3376.namprd05.prod.outlook.com>
References: <20191023095554.11340-1-sgarzare@redhat.com>
 <20191023095554.11340-12-sgarzare@redhat.com>
 <CAGxU2F7n48kBy_y2GB=mcvraK=mw_2Jn8=2hvQnEOWqWuT9OjA@mail.gmail.com>
In-Reply-To: <CAGxU2F7n48kBy_y2GB=mcvraK=mw_2Jn8=2hvQnEOWqWuT9OjA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=jhansen@vmware.com; 
x-originating-ip: [146.247.47.49]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0bc0d4f6-649e-4161-7d74-08d75d4f6fb3
x-ms-traffictypediagnostic: MWHPR05MB2957:
x-microsoft-antispam-prvs: <MWHPR05MB295719D2CCD818E455543E0DDA600@MWHPR05MB2957.namprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 02065A9E77
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(39860400002)(396003)(136003)(366004)(376002)(199004)(189003)(8936002)(66476007)(305945005)(64756008)(66446008)(316002)(7416002)(7736002)(66556008)(81166006)(81156014)(74316002)(478600001)(52536014)(55016002)(66066001)(8676002)(9686003)(54906003)(6246003)(86362001)(25786009)(66946007)(5660300002)(33656002)(4326008)(76116006)(6436002)(6506007)(14454004)(76176011)(6916009)(476003)(2906002)(7696005)(186003)(71200400001)(71190400001)(6116002)(99286004)(26005)(3846002)(102836004)(256004)(229853002)(446003)(486006)(14444005)(11346002);DIR:OUT;SFP:1101;SCL:1;SRVR:MWHPR05MB2957;H:MWHPR05MB3376.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: vmware.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: lWTiDen5iXKOdLsNU+yjRrfkfy4j2Ny7Ga3uNA4mVYRmgAurEhkdxyahG/ldTgLkslcAbLp3lfkhNFOqWnS5uaFo8AUA0bTkElB0/fzbdv9sVc2OfnOJO67FNY82viBZcW0/8LQFU0ptaum1nnTJ6hDk7YuynnIz+loPrTdHOoX9uIpw+7DppTrOB52qwnwQAlST1M+/9Sobw2qGe6V1XVf6VPgqewSFNYJIFjx/t7lj3Ww5zwS2XZSCTtS7fAg7pqDFrr7YqyB4Y9x9wCzYj470kZFTGQ42lwxWtfcp/OXFySGH+sBByPCUo1rUD4aqK7iQu/NDcAsBnY2W6UFin05yKWB1H+G+ouo0c0idmHTzPXS6Ud3rNxp1xUct8FKPxAvgfgU4MrXqFkli31mwew/UHxnrbpkFRVDuygCRqA76KGUdsmWp+v5JZWpk2GXg
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0bc0d4f6-649e-4161-7d74-08d75d4f6fb3
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Oct 2019 15:40:05.2998
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Ri/s3DjZk4FvNg+1W27BHZSABEN1A34AsICGmdjBsfrxKBRrFkqV2yB8GZfZLBGk64e3FNuMcYv8s9nlESoi/A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR05MB2957
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Stefano Garzarella [mailto:sgarzare@redhat.com]
> > +/* Assign a transport to a socket and call the .init transport callbac=
k.
> > + *
> > + * Note: for stream socket this must be called when vsk->remote_addr
> > +is set
> > + * (e.g. during the connect() or when a connection request on a
> > +listener
> > + * socket is received).
> > + * The vsk->remote_addr is used to decide which transport to use:
> > + *  - remote CID > VMADDR_CID_HOST will use host->guest transport
> > + *  - remote CID <=3D VMADDR_CID_HOST will use guest->host transport
> > +*/ int vsock_assign_transport(struct vsock_sock *vsk, struct
> > +vsock_sock *psk) {
> > +       const struct vsock_transport *new_transport;
> > +       struct sock *sk =3D sk_vsock(vsk);
> > +
> > +       switch (sk->sk_type) {
> > +       case SOCK_DGRAM:
> > +               new_transport =3D transport_dgram;
> > +               break;
> > +       case SOCK_STREAM:
> > +               if (vsk->remote_addr.svm_cid > VMADDR_CID_HOST)
> > +                       new_transport =3D transport_h2g;
> > +               else
> > +                       new_transport =3D transport_g2h;
>=20
> I just noticed that this break the loopback in the guest.
> As a fix, we should use 'transport_g2h' when remote_cid <=3D
> VMADDR_CID_HOST or remote_cid is the id of 'transport_g2h'.
>=20
> To do that we also need to avoid that L2 guests can have the same CID of =
L1.
> For vhost_vsock I can call vsock_find_cid() in vhost_vsock_set_cid()
>=20
> @Jorgen: for vmci we need to do the same? or it is guaranteed, since it's
> already support nested VMs, that a L2 guests cannot have the same CID as
> the L1.

As far as I can tell, we have the same issue with the current support for n=
ested VMs in
VMCI. If we have an L2 guest with the same CID as the L1 guest, we will alw=
ays send to
the L2 guest, and we may assign an L2 guest the same CID as L1. It should b=
e straight
forward to avoid this, though.


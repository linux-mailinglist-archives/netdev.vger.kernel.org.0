Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 133B9105523
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 16:14:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726920AbfKUPO1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Nov 2019 10:14:27 -0500
Received: from mail-eopbgr800089.outbound.protection.outlook.com ([40.107.80.89]:2014
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726634AbfKUPO1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 Nov 2019 10:14:27 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q6RLD3+HZSLP+8YO6c+RJj5i2XVwBborEKugqGA5tFzOeVWfcqSN3OyXJHCvxKMU3XNL9rwI7RXtuQM426kwqIHaoQS++Z8xAR/KLkbQa6R/VOZ5AMmQqwq0tz9fE4gW/VtZQ16Ojz5P0w4iEHRulN079dEJ6DHS8XbvfQk7h4KFuKq/+8RyyVX4BaTKgNyWq8HUtUYiQMUdCdsnHBKzTbKa2PXCqS1J3K5vrzHS37Y0lahZnzxDatMDXzlw+lbwLS2rtpXzxq7Vm8eMBHlhcCgOAq94y8fXo2ctBtyV6m/0a493Mx0ihytZq+FmklHtc75CPc1xn0IZVITYzQgf0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Cyec1X109nXfDP3CaBAon6V4mLUItT4b73iZ3ITqmlg=;
 b=B0Gk/i/TXF8pPGOjGp+lziqyGtsobsAfo18zdSfApe6JXpfRmCv0pAQPVf86MhgWBRU3RizWrBeSmWXp9vJGqzj833NbO92BzY62I3hvaBcyQq9YV2Uw+botUAKU+DE8iT5Vf8YOnzZJSmGnEMi2G97AZbUOPCjiM5keP6Yt7zKToQO8P8XGwMdcx/vp0xxWgI/UXvYXh4Of1HgQUuEPm3AkyToroe43XeGHiXolJg5KrtOk1iXa14Y2VHkDNqkuJWGxvGEfXPUBVg/2Fu5xLgVzsoL/2u/iNy9m0MWCi3lpQ8JO1wH3qLSCbdJwoEFrN5zspe0G8GJcqrHxa4lNzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vmware.com; dmarc=pass action=none header.from=vmware.com;
 dkim=pass header.d=vmware.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Cyec1X109nXfDP3CaBAon6V4mLUItT4b73iZ3ITqmlg=;
 b=GlYhQFBccD+Rv52Ur/XyugPUtOnLLtqE1tLBXU1Rr/n3+xGaTB0OMb/94WfULE9fD/SHGGYgIhS2X5tcVfh9ebJeqJlNaRmSYKlK0yjWToKSBEO4QtCZjgV0oZs/v+mFcnZNBYjQvkC9dxLBfQXkx5I8ltDXySvq2z8JB9Xz+P8=
Received: from MWHPR05MB3376.namprd05.prod.outlook.com (10.174.175.149) by
 MWHPR05MB3376.namprd05.prod.outlook.com (10.174.175.149) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2474.9; Thu, 21 Nov 2019 15:14:19 +0000
Received: from MWHPR05MB3376.namprd05.prod.outlook.com
 ([fe80::4098:2c39:d8d3:a209]) by MWHPR05MB3376.namprd05.prod.outlook.com
 ([fe80::4098:2c39:d8d3:a209%7]) with mapi id 15.20.2474.015; Thu, 21 Nov 2019
 15:14:19 +0000
From:   Jorgen Hansen <jhansen@vmware.com>
To:     'Stefano Garzarella' <sgarzare@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "syzbot+e2e5c07bf353b2f79daa@syzkaller.appspotmail.com" 
        <syzbot+e2e5c07bf353b2f79daa@syzkaller.appspotmail.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Dexuan Cui <decui@microsoft.com>
Subject: RE: [PATCH net-next] vsock: avoid to assign transport if its
 initialization fails
Thread-Topic: [PATCH net-next] vsock: avoid to assign transport if its
 initialization fails
Thread-Index: AQHVoEr3gbB/ABgYRUWOC82bK3DwS6eVurcg
Date:   Thu, 21 Nov 2019 15:14:19 +0000
Message-ID: <MWHPR05MB33769A7039F0862F581BF176DA4E0@MWHPR05MB3376.namprd05.prod.outlook.com>
References: <20191121090609.13048-1-sgarzare@redhat.com>
In-Reply-To: <20191121090609.13048-1-sgarzare@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=jhansen@vmware.com; 
x-originating-ip: [208.91.2.1]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: cada2032-9b7a-40da-5bac-08d76e957b80
x-ms-traffictypediagnostic: MWHPR05MB3376:
x-microsoft-antispam-prvs: <MWHPR05MB337630CCDC56BF5799C71CC8DA4E0@MWHPR05MB3376.namprd05.prod.outlook.com>
x-vmwhitelist: True
x-ms-oob-tlc-oobclassifiers: OLM:1186;
x-forefront-prvs: 0228DDDDD7
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(376002)(346002)(366004)(39860400002)(396003)(189003)(199004)(76116006)(76176011)(186003)(66946007)(5660300002)(2501003)(26005)(81156014)(229853002)(81166006)(8936002)(9686003)(74316002)(316002)(54906003)(52536014)(305945005)(110136005)(446003)(11346002)(55016002)(8676002)(33656002)(6436002)(86362001)(25786009)(2906002)(66066001)(7736002)(478600001)(256004)(14444005)(99286004)(71200400001)(71190400001)(7696005)(6506007)(14454004)(66446008)(4326008)(66476007)(66556008)(6246003)(64756008)(3846002)(6116002)(102836004);DIR:OUT;SFP:1101;SCL:1;SRVR:MWHPR05MB3376;H:MWHPR05MB3376.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: vmware.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: P1JgPG+m7tWQ0mMW4rTuSb0RVlULels4i83CKOq05NuHCjplZoSliOfFhNI1sZ8Xq0380TtMqoTWB4H/qD/ZVvUO0kiVi5OA2/FhLoqZHVZAY9BkNoE4z2Y1adGrAYF9T9Qkwgk5b/paII2V/JgtcQ/MXevVGNgIsSNcEQ4juOCUMzhg+h7cfyn7TL9DKV4rvT+RnzyvTDsi1pQvzRn79FAsf/7kyKiOM1ymqN9DklkZm2L7Jsl9LvHxeHV1kiZNnc098o22JbKPUW4XErNwUg9KH2H4XVRRqP//vl1p+CsN1fdM0yAQzCZNeMQMyUtM4Va53xbq9f9n8THRPw+raO53+s4XkSaLy/07k25TPDYJJrE4ViDez1lMBX6tcnDtCSDPydTMijrOJyZ4U3zqKKYHqnnEYtgDqQL2k5cAm8YQC8IakytBz7VWHBjKUBUe
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cada2032-9b7a-40da-5bac-08d76e957b80
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Nov 2019 15:14:19.6697
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TrdcvRpS0ulmYRE4xBynt881EcAI/0B1lVJ/BA6z5iecVRwkt6IpADJe0ketf7auA4Q44xX/4pydNA/bwfntpg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR05MB3376
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Stefano Garzarella [mailto:sgarzare@redhat.com]
> Sent: Thursday, November 21, 2019 10:06 AM
>=20
> If transport->init() fails, we can't assign the transport to the
> socket, because it's not initialized correctly, and any future
> calls to the transport callbacks would have an unexpected behavior.
>=20
> Fixes: c0cfa2d8a788 ("vsock: add multi-transports support")
> Reported-and-tested-by:
> syzbot+e2e5c07bf353b2f79daa@syzkaller.appspotmail.com
> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> ---
>  net/vmw_vsock/af_vsock.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
>=20
> diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
> index cc8659838bf2..74db4cd637a7 100644
> --- a/net/vmw_vsock/af_vsock.c
> +++ b/net/vmw_vsock/af_vsock.c
> @@ -412,6 +412,7 @@ int vsock_assign_transport(struct vsock_sock *vsk,
> struct vsock_sock *psk)
>  	const struct vsock_transport *new_transport;
>  	struct sock *sk =3D sk_vsock(vsk);
>  	unsigned int remote_cid =3D vsk->remote_addr.svm_cid;
> +	int ret;
>=20
>  	switch (sk->sk_type) {
>  	case SOCK_DGRAM:
> @@ -443,9 +444,15 @@ int vsock_assign_transport(struct vsock_sock *vsk,
> struct vsock_sock *psk)
>  	if (!new_transport || !try_module_get(new_transport->module))
>  		return -ENODEV;
>=20
> +	ret =3D new_transport->init(vsk, psk);
> +	if (ret) {
> +		module_put(new_transport->module);
> +		return ret;
> +	}
> +
>  	vsk->transport =3D new_transport;
>=20
> -	return vsk->transport->init(vsk, psk);
> +	return 0;
>  }
>  EXPORT_SYMBOL_GPL(vsock_assign_transport);
>=20
> --
> 2.21.0

Reviewed-by: Jorgen Hansen <jhansen@vmware.com>


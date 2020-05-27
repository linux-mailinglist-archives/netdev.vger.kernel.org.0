Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFC2C1E3C68
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 10:45:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388233AbgE0Iop (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 04:44:45 -0400
Received: from mail-bn8nam11on2041.outbound.protection.outlook.com ([40.107.236.41]:35072
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388215AbgE0Ioj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 May 2020 04:44:39 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lVKKsmkP8qAecNXmBK3ICa+09LpIz1Myb0JLXHjFO3K6/Lu9gPgUgExrpDGe2yDbvDgj+0XVSE6HzmGWk6eVqLjGRaiEOoGlrajjSseaUcU4uxcYAs1VmUFwZ8vuD8rys/xZq+k6o5MSkPMWItVpQaA2w8KQF8l7nl4iqnWi0BZzHKyi12RC6lIhDAH0Hd9wYyRsis9dV6kJ8WA8lW7nUAhdppajEfgDeX6M2mF8ujTYUXXFudl5F3o/9Ci6MospVXI4LjtvS9D9TpKkQTCH/VS0eipufpCN2WZt4zuh8eYqveH5mqBkOuI+43BKCo6lMKALHjz5By6SQoLXmulIFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hAagga99GFN+ODWjfqYd82ZIzQuKXuON23XxpS8BSnk=;
 b=D/rIzPuxW2FFbL+GB+9bBeBl9YWd0ZzgVPjEpDUuQIjosm6i2cQ0Bvp6/b30PBQWNg2Y+yPx4RGz36WC0aGNcgepGw0CQ2iTHu+nqYVGrhtTDMU8J6DISot+Xc58Nf0nYgKhsSxdmp/AYhzxhBFm5o5j4CsMQM1Qpke6BjaikJ14DMSfkvE+Lj9zvkkDsbBOLOpe8y/KHdbIfLMmWb4kc7MCjQhPmBHUls7UBKFTt37AYj/vg0zBFrGGKHAzJurWG8wjDFyUCHPrUaMoIcDLXnqb0dzTuMlJhpFQtbm2GClIggXoAdZ37M4LmdqSxylh/eylPfhQprNyS7Dq8z/WOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vmware.com; dmarc=pass action=none header.from=vmware.com;
 dkim=pass header.d=vmware.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hAagga99GFN+ODWjfqYd82ZIzQuKXuON23XxpS8BSnk=;
 b=rcYYLmkDawIvsqz7LYH48W1lkBWxyZc//XyhIfDHBlUvKXbP6XKpGaTDQBG0LS+3nx+BeYi0ObOgZkwe1OWJ3aAlvWCy4O7i3MRUyfnDY17RWIwCsiJmy0e3fP4irw0ACUbeg/2rkKEVkeFAtmLeS5N5IWImQoj6fukq96vd1kg=
Received: from DM5PR05MB3452.namprd05.prod.outlook.com (2603:10b6:4:41::11) by
 DM5PR05MB3017.namprd05.prod.outlook.com (2603:10b6:3:52::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3045.7; Wed, 27 May 2020 08:44:36 +0000
Received: from DM5PR05MB3452.namprd05.prod.outlook.com
 ([fe80::2d96:bf09:a581:8b60]) by DM5PR05MB3452.namprd05.prod.outlook.com
 ([fe80::2d96:bf09:a581:8b60%7]) with mapi id 15.20.3045.014; Wed, 27 May 2020
 08:44:36 +0000
From:   Jorgen Hansen <jhansen@vmware.com>
To:     'Stefano Garzarella' <sgarzare@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     George Zhang <georgezhang@vmware.com>,
        Andy King <acking@vmware.com>,
        Dexuan Cui <decui@microsoft.com>,
        Dmitry Torokhov <dtor@vmware.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Subject: RE: [PATCH net] vsock: fix timeout in vsock_accept()
Thread-Topic: [PATCH net] vsock: fix timeout in vsock_accept()
Thread-Index: AQHWM/xtrRnaG233x0K8YqiP0g9JX6i7nX0g
Date:   Wed, 27 May 2020 08:44:36 +0000
Message-ID: <DM5PR05MB345254AA5CAE454B47E11DEEDAB10@DM5PR05MB3452.namprd05.prod.outlook.com>
References: <20200527075655.69889-1-sgarzare@redhat.com>
In-Reply-To: <20200527075655.69889-1-sgarzare@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=vmware.com;
x-originating-ip: [208.91.2.2]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 398622d1-e3c7-4e30-ce7b-08d8021a2fe0
x-ms-traffictypediagnostic: DM5PR05MB3017:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5PR05MB301736172FF64E283AFC205FDAB10@DM5PR05MB3017.namprd05.prod.outlook.com>
x-vmwhitelist: True
x-ms-oob-tlc-oobclassifiers: OLM:3968;
x-forefront-prvs: 04163EF38A
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: NMRshgNuAhf+tRW+J1rRHLZUQgOa1/QN8lhGLJYvoG8JqLZE+2HDqoGJAGAO/8a6vb8cSUS5xQx/cUGmaYIZKqLS+gPLwFtPjiqM1WVa0UrrFWNb67ST1rgpK7DBd8TnpbPY3kiCf/nLovMIM4QXHINVsZkSfdEwBY+uGD7s3Rdct840e9ctbUlzqY23UdWxMaA0HrUQb9LKUE/e5Jwd6Pv94QVIX+AwTK0d/5IJOssh+CuFeZaA1roBian+iNS3hWwdNdxD3jAHtsAxBg39JDQT1XEUVIv1c81ps6MA99DfrIDNyuw/PJv0a6CTRN8o+XRj8kuEMkwJx84Mjr5Ixw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR05MB3452.namprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(376002)(366004)(346002)(396003)(39860400002)(316002)(2906002)(66556008)(66946007)(76116006)(478600001)(66446008)(66476007)(7696005)(4326008)(83380400001)(26005)(8936002)(6506007)(5660300002)(64756008)(186003)(71200400001)(8676002)(110136005)(54906003)(86362001)(33656002)(55016002)(9686003)(52536014);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: 3Rzey7yd6Awvk7tZSoFxVvmfYf04L7mQx94x4CnLbJ/IViHD97F6j9pVo6cSlI6F1psyALc4qrI1DZPN0EfO8n0YGrqgZGOvV5R8sOEFDdrOEMRXOEJ7nX1LHzdTpQmeB6EEncnV+BlGUhpEwy6mX8ipqWUo/wHk+n4Fi9F3NKrDYExmP/YbDkIic5nDT3Q8O0qur1M5RIsrgcA0WwX5mlMm+LAzu/IcWOcjwvQAxzg/ClDiMQwVQMPEYQjz80oy7bT/3KU01dk1Wu/FVkSKmQrR5Pcyd2IqbgFEpRqAxTI5taoK509W80bTp6buYF6bGvdLknhRRi7vyh+ku1ixltvpG+ii8uWL/+uFZjtmcXeXbVJKuI3zvFdc5iVEqwSyTwvAtIsOJGD2ZLtcEmTntEKZoKZbN81LRYCq7H/YHeLBNTCNcF1vPtDlqLy7vpGYfbd26lNObYOBoJu3X+P3dyGSl+BMqxYTNOPtBQ1X4MM=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 398622d1-e3c7-4e30-ce7b-08d8021a2fe0
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 May 2020 08:44:36.6603
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WXxZOdorDDkI9gePZ4uyTFmlckeefr90jcQu4qKO/pf9K+ONTgSyrgsMxELzMFk1r8j95L+xLpR1V98Z+JZRsg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR05MB3017
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Stefano Garzarella <sgarzare@redhat.com>
> Sent: Wednesday, May 27, 2020 9:57 AM
>=20
> The accept(2) is an "input" socket interface, so we should use
> SO_RCVTIMEO instead of SO_SNDTIMEO to set the timeout.
>=20
> So this patch replace sock_sndtimeo() with sock_rcvtimeo() to
> use the right timeout in the vsock_accept().
>=20
> Fixes: d021c344051a ("VSOCK: Introduce VM Sockets")
> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> ---
>  net/vmw_vsock/af_vsock.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
> index a5f28708e0e7..626bf9044418 100644
> --- a/net/vmw_vsock/af_vsock.c
> +++ b/net/vmw_vsock/af_vsock.c
> @@ -1408,7 +1408,7 @@ static int vsock_accept(struct socket *sock, struct
> socket *newsock, int flags,
>  	/* Wait for children sockets to appear; these are the new sockets
>  	 * created upon connection establishment.
>  	 */
> -	timeout =3D sock_sndtimeo(listener, flags & O_NONBLOCK);
> +	timeout =3D sock_rcvtimeo(listener, flags & O_NONBLOCK);
>  	prepare_to_wait(sk_sleep(listener), &wait, TASK_INTERRUPTIBLE);
>=20
>  	while ((connected =3D vsock_dequeue_accept(listener)) =3D=3D NULL &&
> --
> 2.25.4

Thanks for fixing this!

Reviewed-by: Jorgen Hansen <jhansen@vmware.com>

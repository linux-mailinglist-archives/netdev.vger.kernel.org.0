Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F2902F502F
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 16:50:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726741AbfKHPup (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 10:50:45 -0500
Received: from mail-eopbgr130074.outbound.protection.outlook.com ([40.107.13.74]:51470
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725941AbfKHPuo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Nov 2019 10:50:44 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B4etbo3y+hbJQKIcGpXffxwxnAp3U22sq/1ggdvtrAKQavapNyPHmt7NVYrRJTsWXjxl1/ZsUa80M1E8aZVIg12Z0hZ/WN2yYpHGnVEoMuXZ0S0zXlg1HF2W2l9TmMkCo25T6ZSCn82sSIS82lrL0mHjFpB/30UrRL6TEjfNVRs1tiePS4C0wnVYztqbYVEuC/Mn5YNmIOrXGW+9dgBt+8Ev1C/gmUUEB765LnOmLiScGBsQPzB11Q36wCrrsFfRpqW6Ra+BAAC+gp3oBzW30FscacGrkU72a1YYMER4S9QClA/qYHPx9vH12FSNi/YeGMb2Yofob6NWXw9cfwFbPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QO79Q9aIdklXy0Vy4ycPU0R/oKSd1rG5fljBXHpr6tY=;
 b=oEjkbFFXEtL9sH/cDuPveouQNzx14o6Z/8EN/SJUPPkexD9QDcKIdQ9sa2YCuYzVpWFO9J5hfZfoaPOD6k0GEW2USbEEel1vn//RgnR2KF6QAnMXIDBG/Un6qrgi9QQgnefVf8rzPT9tF9Pf6kpisvD0/hv8E7B8JdS+m7TZS9J7r0kDKmNHXKw2T6RMNnhc2eZcbkIrGU5AwvsJbwAZ6eei/pCh0uIQbLe+aWZm2dTfAbg3qDmv3Afc8XtqzogiQpNZQwEEwb+buLLIgSsI4P6i3nqGkqpb+idRpX+q/wD1IRXIAkvB+2/u6M+l08pLkKW1UUKlDLKZ0xlG7NjcqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QO79Q9aIdklXy0Vy4ycPU0R/oKSd1rG5fljBXHpr6tY=;
 b=WuKxI4bBT8BpGB0cWUYp6/hPQmS/TfGOJOARDdUzTmrYImtEwHA7uVDqZg0ajjVW9Gp7z/rOOgmhCfgEigzVPDu0aN1rfXhhA1uIkdqcwfCucvcpKcjGiUFaDfjtB8ExtS4dIy5UdquNrKtarAGdnM6Vzdx3za3Wk90rA4n49eg=
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com (20.176.214.160) by
 AM0PR05MB4609.eurprd05.prod.outlook.com (52.133.57.17) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2408.24; Fri, 8 Nov 2019 15:50:41 +0000
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::e5c2:b650:f89:12d4]) by AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::e5c2:b650:f89:12d4%7]) with mapi id 15.20.2430.020; Fri, 8 Nov 2019
 15:50:41 +0000
From:   Parav Pandit <parav@mellanox.com>
To:     Jiri Pirko <jiri@resnulli.us>
CC:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "leon@kernel.org" <leon@kernel.org>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        Jiri Pirko <jiri@mellanox.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Subject: RE: [PATCH net-next 01/19] net/mlx5: E-switch, Move devlink port
 close to eswitch port
Thread-Topic: [PATCH net-next 01/19] net/mlx5: E-switch, Move devlink port
 close to eswitch port
Thread-Index: AQHVlYWm7joB7S0cVEKHHNmNbXCxV6eBCQ0AgABjACA=
Date:   Fri, 8 Nov 2019 15:50:41 +0000
Message-ID: <AM0PR05MB4866A725E486A79B02261009D17B0@AM0PR05MB4866.eurprd05.prod.outlook.com>
References: <20191107160448.20962-1-parav@mellanox.com>
 <20191107160834.21087-1-parav@mellanox.com>
 <20191108095110.GD6990@nanopsycho>
In-Reply-To: <20191108095110.GD6990@nanopsycho>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=parav@mellanox.com; 
x-originating-ip: [2605:6000:ec82:1c00:9dfd:71f9:eb37:f669]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: e7a51a3e-76b6-4b59-9e6d-08d76463686a
x-ms-traffictypediagnostic: AM0PR05MB4609:|AM0PR05MB4609:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR05MB4609E0864078879F993AE528D17B0@AM0PR05MB4609.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4502;
x-forefront-prvs: 0215D7173F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(376002)(366004)(346002)(39860400002)(136003)(189003)(199004)(13464003)(25786009)(316002)(229853002)(14444005)(478600001)(71190400001)(6246003)(102836004)(81166006)(2906002)(11346002)(256004)(71200400001)(66556008)(64756008)(76116006)(66476007)(55016002)(66946007)(66446008)(9686003)(99286004)(33656002)(486006)(86362001)(7696005)(76176011)(446003)(46003)(6916009)(8676002)(8936002)(4326008)(5660300002)(6116002)(6436002)(52536014)(6506007)(53546011)(476003)(14454004)(7736002)(186003)(305945005)(74316002)(81156014)(54906003);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR05MB4609;H:AM0PR05MB4866.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xy/E13YnrZTLfroA6ZJqndm+f4XprOPJtbyNx2KdyUSmtcC8/2E2nun8JS9jLXKVVWq7efXVBVYUy26qwehp4CVcdRHbixjELO5O3saCeJzSQJ8+ZST4mwrKs+/6/K1haEwHsyweQVx0dQmvTeZC0NDk4V2UaerCHiscfGT6Omz2vh+LLpxDu8u9BsAeSvo8xZXC6JOP6nkUcSLmE8UbmRMAgn0/SV/Tel1YyaPAo+UbxP1Ql4sRwK9jV25mfKFPNXT5AZhZd09raTc7BhAysFhGuF1TtyYUNwc+mjczcz2x/3YXedY64/ZGV8ppoLv1n45J7cMNYz+U9WamfGlWYcdTofXYH1NHMs8ujAmk5VBz6tJ9+hS9wZRJbJuufxyl1IENV4UmW4xkZHE1CC9LBfw2A9xws4fdEuYiGHlbmJyCl31dmF4gXgRGzm+L1bHu
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e7a51a3e-76b6-4b59-9e6d-08d76463686a
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Nov 2019 15:50:41.1712
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4wvwoM/EQn2+K8Hx4JYQPlrdPSNxoKMYTzHfq7+c1tQ3bTMN6mmopnZmVNd8Of9usxH1ABUXIVw0xJo7qkGPCg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB4609
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Jiri Pirko <jiri@resnulli.us>
> Sent: Friday, November 8, 2019 3:51 AM
> To: Parav Pandit <parav@mellanox.com>
> Cc: alex.williamson@redhat.com; davem@davemloft.net;
> kvm@vger.kernel.org; netdev@vger.kernel.org; Saeed Mahameed
> <saeedm@mellanox.com>; kwankhede@nvidia.com; leon@kernel.org;
> cohuck@redhat.com; Jiri Pirko <jiri@mellanox.com>; linux-
> rdma@vger.kernel.org
> Subject: Re: [PATCH net-next 01/19] net/mlx5: E-switch, Move devlink port
> close to eswitch port
>=20
> Thu, Nov 07, 2019 at 05:08:16PM CET, parav@mellanox.com wrote:
> >Currently devlink ports are tied to netdev representor.
> >
> >mlx5_vport structure is better container of e-switch vport compare to
> >mlx5e_rep_priv.
> >This enables to extend mlx5_vport easily for mdev flavour.
> >
> >Hence, move devlink_port from netdev representor to mlx5_vport.
> >
> >Reviewed-by: Saeed Mahameed <saeedm@mellanox.com>
> >Signed-off-by: Parav Pandit <parav@mellanox.com>
>=20
> Since this patchset has 19 patches, which is quite a lot, I suggest to pu=
sh out
> some preparation patches (like this one) to a separate patchset that woul=
d
> be sent in prior to this one.
Some of us have been doing that for a while now, that made it to 19. :-)
We can also take out 5-6 patches of mdev as pre-series, if Alex and others =
are fine.

Please review/ack this patch, so that I can queue via usual Saeed net-next =
tree which are already reviewed, and this series depends on that esw intern=
al refactor.

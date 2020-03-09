Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1573517E815
	for <lists+netdev@lfdr.de>; Mon,  9 Mar 2020 20:08:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727510AbgCITI4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 15:08:56 -0400
Received: from mail-db8eur05on2067.outbound.protection.outlook.com ([40.107.20.67]:35169
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727431AbgCITI4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Mar 2020 15:08:56 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GBC9BR1ZOJbyKFxrqYxdado1mzcXXn+B66GUcFc4pDzHYMnsQqDJl446+dAcp3I7Z05IplZhr7XVRCq++CQYTGds7TQYYXXbG/A4jUEjDd4dfY2MrHWwl9hHz08PsUPhRe/wU7uYjT0YUACBsWURJgandp6AdDU9652dLr6f9bFxtL5+2MI1Td5Wuk7Qdc2YkzERjQ7FiEfNwxMTICDIBozyFrU1Vwe2K5+BkNNG41hgrtOXTb+OWVMy8qkFemDpCYht3Aj4elvWEIX4hL3bcbpc0ONEBSvB4U3Jgcv098ELKjXg+Xny2ETG05Ps82HvpYvBG36MBFeg15glrUbL6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Dliffnjq+DUE2Qkakq81T56mwCXEfTEb3R51tLq0gwg=;
 b=UiSTNy+Xk3lGPwFuqNyQ5w5SetK2AlkNk1u5ANwyOnF2pgMJrCU/sW/t9vSfiS9fabMU77GnLMrE0FYvcI2PX1v4YRPu7nkMRLBMY93L7SVp1ff2QUKqy8rZZtE0wcxmwqMMTXtrj4I7QeGhgD9mudFYqAAqqTyhheA02VwlPe8PxzJHGyuF1CJgb6RWhBZvjK4E/qB7u/hTouI7cR0tOPeaTzJ2lJ2mE+cSa1oeUbMIQTgZaSKaH6xWN7QC+QfEDHO4wG/dolE/13Y/cl1chkIAdZPGQM6RS/vQkBd/mFdjkWRbebkOi+HXM2ZgizFLYiE+RKYCydo8W8IzJEQ9Eg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Dliffnjq+DUE2Qkakq81T56mwCXEfTEb3R51tLq0gwg=;
 b=Dte5gjG7wxZf93u+9kA0cPgxsM4/t5ihKrvHaxPZ2l6lu6LwmGruOnB+jGJJC3g/8Scwt1CtJrPWaNzG50g4CLbibnfSnEiapu2p/WAc1X4XybVwq/owtU8otOKHAXb2HlpZ6IQF5abdh2n/mN/La5KaNe7ARcPRXs4F5/Wi+kM=
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com (20.176.214.160) by
 AM0PR05MB4500.eurprd05.prod.outlook.com (52.134.124.153) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2793.17; Mon, 9 Mar 2020 19:08:52 +0000
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::8c4:e45b:ecdc:e02b]) by AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::8c4:e45b:ecdc:e02b%7]) with mapi id 15.20.2793.013; Mon, 9 Mar 2020
 19:08:52 +0000
From:   Parav Pandit <parav@mellanox.com>
To:     Saeed Mahameed <saeedm@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Eli Cohen <eli@mellanox.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        Raed Salem <raeds@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: RE: [net 5/5] net/mlx5: Clear LAG notifier pointer after unregister
Thread-Topic: [net 5/5] net/mlx5: Clear LAG notifier pointer after unregister
Thread-Index: AQHV80RcIa+mDAbZX0anrkadtTlTxKhApJVg
Date:   Mon, 9 Mar 2020 19:08:52 +0000
Message-ID: <AM0PR05MB48660149DA366D89137CADB4D1FE0@AM0PR05MB4866.eurprd05.prod.outlook.com>
References: <20200305231739.227618-1-saeedm@mellanox.com>
 <20200305231739.227618-6-saeedm@mellanox.com>
In-Reply-To: <20200305231739.227618-6-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=parav@mellanox.com; 
x-originating-ip: [208.176.44.194]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: dc375bc5-c20e-45f5-7678-08d7c45d4eb0
x-ms-traffictypediagnostic: AM0PR05MB4500:|AM0PR05MB4500:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR05MB45000994E208E578CCE3CE43D1FE0@AM0PR05MB4500.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 0337AFFE9A
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(366004)(396003)(39860400002)(136003)(376002)(189003)(199004)(54906003)(71200400001)(6506007)(107886003)(2906002)(110136005)(316002)(52536014)(478600001)(7696005)(76116006)(55016002)(66476007)(66946007)(66556008)(33656002)(86362001)(66446008)(64756008)(8936002)(81156014)(8676002)(81166006)(9686003)(26005)(186003)(5660300002)(4326008);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR05MB4500;H:AM0PR05MB4866.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: YCbpUfXdhymdpEM8qdjt0q9xhb8sETXSDQk5x++pNoL0tcYwXRuBpoJsfXuBLfqz0hcAd4AsfFNenXtYGDyedOJqQpb2jQroddZFhbo7sTLKqOQDWQXuNLQy/nQmDoyEUfVxpuEKJbJGbJOcUlxakN7BChllYHbSrJXQdG1UOHpf/ZN91yd1r9+DqkgOM5KegsCWXmsfNtWQFPQKHHYH3p5PLAMgn8jF7yYsn8X11IW2QoGlBLGoXyQOSaV2fHb45xDsuEq+gdfFHmNtARCho0mPa0AlO5BSLfSqs4BtUYYjrC6FTTc1UXV/AWlw8Bd3g04SCOZbuPfOka6VBhzFhkSY/1NPHqYEdwP6MSMqATW6Ya1i4O2H2mBiJ4VvqXA59t7TzSvaeQlWPyfrIRTooMzd/mn5wZBIBUjbZ0AfG9Kn+ORLkK8UOWrRX/nNMoFs
x-ms-exchange-antispam-messagedata: y18G9RrByiSrLT2wr61rRUP2V1PWckM/5f23qNjpqwzBZ6x19AkBkqFT3uT/Qcz4MhxAljNk431f7SRT/q3OO7lGj/vbBZtw8EjOOxZDxHTbJe0uGCsCrkJzvM3qYitY+kU5vEMVgn8smt3c+bz3rw==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dc375bc5-c20e-45f5-7678-08d7c45d4eb0
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Mar 2020 19:08:52.6375
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 15G89CGtYICXUUZd5PkhkUDNfZmDbm27wNJER1X4nQoscvpXZaKLUhooD/wYv55BiPv0joxIuqQ4qMJ9xTCSGA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB4500
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Eli,

> Sent: Thursday, March 5, 2020 5:18 PM
> To: David S. Miller <davem@davemloft.net>
>=20
> From: Eli Cohen <eli@mellanox.com>
>=20
> After returning from unregister_netdevice_notifier_dev_net(), set the
> notifier_call field to NULL so successive call to mlx5_lag_add() will fun=
ction as
> expected.
>=20
> Fixes: 7907f23adc18 ("net/mlx5: Implement RoCE LAG feature")
> Signed-off-by: Eli Cohen <eli@mellanox.com>
> Reviewed-by: Vlad Buslov <vladbu@mellanox.com>
> Reviewed-by: Raed Salem <raeds@mellanox.com>
> Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
> ---
>  drivers/net/ethernet/mellanox/mlx5/core/lag.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag.c
> b/drivers/net/ethernet/mellanox/mlx5/core/lag.c
> index 8e19f6ab8393..93052b07c76c 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/lag.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/lag.c
> @@ -615,8 +615,10 @@ void mlx5_lag_remove(struct mlx5_core_dev *dev)
>  			break;
>=20
>  	if (i =3D=3D MLX5_MAX_PORTS) {
> -		if (ldev->nb.notifier_call)
> +		if (ldev->nb.notifier_call) {
>  			unregister_netdevice_notifier_net(&init_net, &ldev-
> >nb);
> +			ldev->nb.notifier_call =3D NULL;
> +		}
>  		mlx5_lag_mp_cleanup(ldev);
>  		cancel_delayed_work_sync(&ldev->bond_work);
>  		mlx5_lag_dev_free(ldev);
> --
> 2.24.1

I have noticed this and applied this local change to avoid below call trace=
 and reported it to Leon few days back in different discussion.

But I fail to justify that this was/is the right fix. To me it seems to hid=
e another bug.
Can you please explain the flow why mlx5_lag_remove() will be called twice =
with i =3D 2 because of which null check is needed to avoid unregister_noti=
fier second time?

RIP: 0010:__list_del_entry_valid+0x7c/0xa0
unregister_netdevice_notifier_dev_net+0x1f/0x70
mlx5_lag_remove+0x61/0xf0 [mlx5_core]
mlx5e_detach_netdev+0x24/0x50 [mlx5_core]
mlx5e_detach+0x36/0x40 [mlx5_core]
mlx5e_remove+0x48/0x60 [mlx5_core]
mlx5_remove_device+0xb0/0xc0 [mlx5_core]
mlx5_unregister_interface+0x39/0x90 [mlx5_core]
cleanup+0x5/0xdd1 [mlx5_core]


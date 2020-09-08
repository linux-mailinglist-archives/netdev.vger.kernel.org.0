Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB70D26215B
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 22:49:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730111AbgIHUtV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 16:49:21 -0400
Received: from mail-bn7nam10on2108.outbound.protection.outlook.com ([40.107.92.108]:30176
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725997AbgIHUtU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Sep 2020 16:49:20 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V9c69PlQpfyCIXImEvVzA/ZcXsAYnDZ4k+7x+DKrNcd+ccSrD5R1Mf6He23VCsOjxkCLt7k/GSB8mYP+HT8PKJtfboOx+g1NRxN2jcFcEE5wjgORMFWl85+0ejGQFeewI4TcFpspQAzk+aHscGD+5pPv4FZsaVYaMXsnNY7htWh7rUObkz4v3bH8gqOUUqu/wHKobLR9T4SMysB84Ku3NHqA3XvpYRSWAZlnQ02jByaMPgDnoMNk7KfsACffT1jwB4oXF4bXuxkichNLaAExk+bzlDfd0QUbZ/kIDCdlMmEMLELL22ar01S9mArY6HmOCoMmWAe6HJXtdRrXYPwLKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a1gyQXigo6eaha9NKVAEl6SafSxN9h92pdBjMX3Id18=;
 b=iOVz2gazY/89pB7hBo1islOmjPT2jPaRxvZZlPIFYlCjjEX+sl9NjwMASHqfJUQPvP2JYovEmpj45YiAMk8ox9plwnXsknqDcjIChKD02x++ujVbr7sGrPcvVaZRiRL5j89ygjA2rnbZffywWZd7Q3y5cHxBmISuLA6oR4/VlWYvHDMLmuc8wYFD6YG7yfuu3vUR17KC1jFAGGI4IID7acd6BR282m3YqZhtqOmOeKEAxZ9nKsr5Jv05lz3hZ7zduPYruskhH2hahybodFu4goQVm7pBHjB56S5xpFXC/BVuMoGX2cizgWzZ17X+OXTkmrGcpU9UUJ/G7nO8LCq7NQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a1gyQXigo6eaha9NKVAEl6SafSxN9h92pdBjMX3Id18=;
 b=ZldKkz1lNYsb/LfBUeKuPsnwGpW5Uktz9xqzr/PUsiF6q4LkmLxzSK+ZB/kB2XoYxyMzJX4AT6ydjeCcsFqp7vmtDeKtV7/x8ZEriiUovDTH5Pzu854zuzw0/fmV2TxsFnQ8mwgC+LWy/cr1aj/5M9adgB0UMQ08E5jJLCd1myM=
Received: from MW2PR2101MB1052.namprd21.prod.outlook.com (2603:10b6:302:a::16)
 by MWHPR21MB0798.namprd21.prod.outlook.com (2603:10b6:300:128::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.4; Tue, 8 Sep
 2020 20:49:14 +0000
Received: from MW2PR2101MB1052.namprd21.prod.outlook.com
 ([fe80::d00b:3909:23b:83f1]) by MW2PR2101MB1052.namprd21.prod.outlook.com
 ([fe80::d00b:3909:23b:83f1%5]) with mapi id 15.20.3391.004; Tue, 8 Sep 2020
 20:49:14 +0000
From:   Michael Kelley <mikelley@microsoft.com>
To:     Dexuan Cui <decui@microsoft.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net v2] hv_netvsc: Fix hibernation for mlx5 VF driver
Thread-Topic: [PATCH net v2] hv_netvsc: Fix hibernation for mlx5 VF driver
Thread-Index: AQHWhOZ3aJ4+rg54iUOHrDzCz+q7FKlfN90Q
Date:   Tue, 8 Sep 2020 20:49:14 +0000
Message-ID: <MW2PR2101MB10524833244E1E0AD68A12D4D7290@MW2PR2101MB1052.namprd21.prod.outlook.com>
References: <20200907071339.35677-1-decui@microsoft.com>
In-Reply-To: <20200907071339.35677-1-decui@microsoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2020-09-08T20:49:12Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=d449b8a8-9a67-46f3-b3d6-3fdc37ab3b4f;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0
authentication-results: microsoft.com; dkim=none (message not signed)
 header.d=none;microsoft.com; dmarc=none action=none
 header.from=microsoft.com;
x-originating-ip: [24.22.167.197]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: fd464ad2-55fa-4f8b-fce4-08d85438a55c
x-ms-traffictypediagnostic: MWHPR21MB0798:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR21MB07988FA80E0CD59AE9A9B7AAD7290@MWHPR21MB0798.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Wv+h4X/YiCYfr0P7SSK2N6FjY5bQoP9vnKyajNXF5Qkxy+gK7qiSrbdyYWSXLDYB7jUmyE+VX3IF/icxCMO6sxMJm/Gxsq4edYNqrMBUSDVBnHxrL5FZJdjREqtNyQFQMDW57vLtJL4cgdMMwYV15Qss3L23QVSg6EOSje36KQHcZYdifweB7VccFtTbfDgg4hTnmYW7vivFPllA+eGdZniLqffQ1xsAL7A9qdg0bjQ2bTdFgpEBP19quDVPP2ZQQBhnuUzcSnPglJGMKBLXQCn1+fsJPS9BaH/YRTRWu1cGbipv0+e5VSaJ+24awAKcE3KJb+Sz9FG0zOIFFwsD79JdN11t/b4oC0TpwBPvQOoJq59KmHB87IM2bp5Y0ZjuM3w8FHbGwduDXXjUpq4zPWBdy+7lUkOMScLsbslaACM=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR2101MB1052.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(366004)(136003)(39860400002)(376002)(396003)(186003)(26005)(8676002)(8936002)(83380400001)(7696005)(110136005)(6506007)(9686003)(76116006)(66446008)(316002)(64756008)(66946007)(55016002)(66556008)(66476007)(8990500004)(82960400001)(10290500003)(478600001)(82950400001)(2906002)(33656002)(86362001)(71200400001)(52536014)(5660300002)(921003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: sk0XPGW+IquIokkY2+mi7gL+6sAKKoQwJIm9x/J5Fn4cCo5iV1APIQHch8X+dahVdjG+u4pNR7Nmjxpk4yeJW70nSH0tzURPrRMDKir1cvU+KcFUJCW47AXdsmq/HjHK0ntoQmo8v0MdxIt5CLG0zm3t2dwA9h0DIHFjw8q1gfKtR1fuvHaFZZ4/pEB6WI6CVZ83KBWMBSqjLxTnltijEbXqJn7G2BK8SBQNmgAEIsdHw35en4/1UPSUomOS+L4Af0u/57AvgchyrOF+3EQnw6RqvX+zk+m++479VgBbY38WvFtS+3WDpMH/l7vNhqHa8WB+hV3fXtHltlwH3GlhNmJ3q73wyonXg6euUoA1Mi2nRRaDEEfEgP21K3/++dcQTlgPT6l05qumkurWo0H8whVxU7bLc7b8H8Pv2DapDb23WYjCY29RoZYO7joGlVjrwhoAw/XW8PhvEzzYI1bvCqJFBkLnQHtx0XgLz1vcjydSmVFMSDZdn5b+2TJ4BPj1bzT0/57Ej4JkFHVwIMPV73CPhNcQutfUVNc6xERP78K+5ptd266npDPhflvfU0/N0SiXfYqq5x3+nvcwJmv1kpYq26c4Vt/7MoHN5kqlnx6kR3Vk7OnDU9o4WFwMQ5ByNL4pbixcb6isCYT1P0fWnQ==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR2101MB1052.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fd464ad2-55fa-4f8b-fce4-08d85438a55c
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Sep 2020 20:49:14.0742
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 576aVqzALQc7guswR+tgODHN/vQ9qgrO7VXGPBtmp6W7iQAjytmcUac42+fsezr2EnNYKjVlUljfwPnBvHAFXefjXxXmY+8aJpOIxJKY09g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR21MB0798
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dexuan Cui <decui@microsoft.com>  Sent: Monday, September 7, 2020 12:=
14 AM
>=20
> mlx5_suspend()/resume() keep the network interface, so during hibernation
> netvsc_unregister_vf() and netvsc_register_vf() are not called, and hence
> netvsc_resume() should call netvsc_vf_changed() to switch the data path
> back to the VF after hibernation. Note: after we close and re-open the
> vmbus channel of the netvsc NIC in netvsc_suspend() and netvsc_resume(),
> the data path is implicitly switched to the netvsc NIC. Similarly,
> netvsc_suspend() should not call netvsc_unregister_vf(), otherwise the VF
> can no longer be used after hibernation.
>=20
> For mlx4, since the VF network interafce is explicitly destroyed and
> re-created during hibernation (see mlx4_suspend()/resume()), hv_netvsc
> already explicitly switches the data path from and to the VF automaticall=
y
> via netvsc_register_vf() and netvsc_unregister_vf(), so mlx4 doesn't need
> this fix. Note: mlx4 can still work with the fix because in
> netvsc_suspend()/resume() ndev_ctx->vf_netdev is NULL for mlx4.
>=20
> Fixes: 0efeea5fb153 ("hv_netvsc: Add the support of hibernation")
> Signed-off-by: Dexuan Cui <decui@microsoft.com>
> ---
>=20
> Changes in v2 (Thanks Jakub Kicinski <kuba@kernel.org>):
>     Added coments in the changelog and the code about the implicit
> data path switching to the netvsc when we close/re-open the vmbus
> channels.
>     Used reverse xmas order ordering in netvsc_remove().
>=20
>  drivers/net/hyperv/netvsc_drv.c | 16 +++++++++++-----
>  1 file changed, 11 insertions(+), 5 deletions(-)
>=20
> diff --git a/drivers/net/hyperv/netvsc_drv.c b/drivers/net/hyperv/netvsc_=
drv.c
> index 64b0a74c1523..81c5c70b616a 100644
> --- a/drivers/net/hyperv/netvsc_drv.c
> +++ b/drivers/net/hyperv/netvsc_drv.c
> @@ -2587,8 +2587,8 @@ static int netvsc_remove(struct hv_device *dev)
>  static int netvsc_suspend(struct hv_device *dev)
>  {
>  	struct net_device_context *ndev_ctx;
> -	struct net_device *vf_netdev, *net;
>  	struct netvsc_device *nvdev;
> +	struct net_device *net;
>  	int ret;
>=20
>  	net =3D hv_get_drvdata(dev);
> @@ -2604,10 +2604,6 @@ static int netvsc_suspend(struct hv_device *dev)
>  		goto out;
>  	}
>=20
> -	vf_netdev =3D rtnl_dereference(ndev_ctx->vf_netdev);
> -	if (vf_netdev)
> -		netvsc_unregister_vf(vf_netdev);
> -
>  	/* Save the current config info */
>  	ndev_ctx->saved_netvsc_dev_info =3D netvsc_devinfo_get(nvdev);
>=20
> @@ -2623,6 +2619,7 @@ static int netvsc_resume(struct hv_device *dev)
>  	struct net_device *net =3D hv_get_drvdata(dev);
>  	struct net_device_context *net_device_ctx;
>  	struct netvsc_device_info *device_info;
> +	struct net_device *vf_netdev;
>  	int ret;
>=20
>  	rtnl_lock();
> @@ -2635,6 +2632,15 @@ static int netvsc_resume(struct hv_device *dev)
>  	netvsc_devinfo_put(device_info);
>  	net_device_ctx->saved_netvsc_dev_info =3D NULL;
>=20
> +	/* A NIC driver (e.g. mlx5) may keep the VF network interface across
> +	 * hibernation, but here the data path is implicitly switched to the
> +	 * netvsc NIC since the vmbus channel is closed and re-opened, so
> +	 * netvsc_vf_changed() must be used to switch the data path to the VF.
> +	 */
> +	vf_netdev =3D rtnl_dereference(net_device_ctx->vf_netdev);
> +	if (vf_netdev && netvsc_vf_changed(vf_netdev) !=3D NOTIFY_OK)
> +		ret =3D -EINVAL;
> +

I'm a little late looking at this code.  But a question:  Is it possible fo=
r
netvsc_resume() to be called before the VF driver's resume function
is called?  If so, is it possible for netvsc_vf_changed() to find that the =
VF
is not up, and hence to switch the data path away from the VF instead of
to the VF?

Michael

>  	rtnl_unlock();
>=20
>  	return ret;
> --
> 2.19.1


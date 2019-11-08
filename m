Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C4EEF4EEC
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 16:08:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726199AbfKHPI1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 10:08:27 -0500
Received: from mail-eopbgr30077.outbound.protection.outlook.com ([40.107.3.77]:59108
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725970AbfKHPI1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Nov 2019 10:08:27 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kcPnZC/r2cFSrNDQ1bSKBZDOFBH+6PyEJxA9+riQUjMN4coF3o+/WaXvpyvkC14cM+LN9VYNipoW7LgohPK5Pjd481eFX2iFtSpo8Rv5DcvRakwj0cn+R3NLQHq7m68tubnlCMtPGmCUj/ty8XTHRieA0Bd4mvL1LX9IZS7UI+kqeZUwpp+SSphYZitGrHzVHCkZwapz3ZK7D3Vn7k+5353qG9+00b8Nzrx1nRS3ySw6XdX03ePzV1HLo+hjj2Xyi/e09mW42wXXutNPDSGscAs2oym3YRceQVMP/Leb2TViINAVYEBnpHsRXBFSihV/L2X1XKopk0gFpJtiwuDp+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AsgMCfbr9Le+GLuzMnNykruFjM8OsygeuTHtqyd8vQk=;
 b=HM5SNLqBEE7TK/zTM7lUGzWgjwCNEf1UzouxWAUV+YtvJ700mZK6papIiidGk5NFUDex3Jbj0hCTza3ZgRW/swFmLQ28JW0/8fuyRIZ4l5QuGVbJxlnADWhSBZm+wuQczNrw28JW6mQd61/mdnQpigJaAqcoN8Ek3zm5j0DzFwSWWq/ScsJAkWB0kIwkw9HsDaLxhNx+OTp/uRd2HJMS2vV0tHWeylg9CXYB30fbSpj0BP//FHqJNqILIZ+a57SuZE3yIHV9smyjW1aYEzsgQ/WauMslOAUSOxBMoBcmvketBa0rWsGTVmKNEng8V1UnToO6Nx9Kzd2zRHUfa3nw1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AsgMCfbr9Le+GLuzMnNykruFjM8OsygeuTHtqyd8vQk=;
 b=JL0dqQ5Xl91MrpnM/IW22d22uzR5hrVKQRe9FIrirFS6aIEUSbmnRVdR+LvgBcK99WvPnEHpUIbg9WKSpE8nesIaZregOiOnYbP4fc8+rb8KEoKYeGGV2DXARYwBHCy47urYXHx23MPkLEW4JQKzINi2clUtFuY/pw3PoNlRd2E=
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com (20.176.214.160) by
 AM0PR05MB5955.eurprd05.prod.outlook.com (20.178.202.222) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.20; Fri, 8 Nov 2019 15:08:23 +0000
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::e5c2:b650:f89:12d4]) by AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::e5c2:b650:f89:12d4%7]) with mapi id 15.20.2430.020; Fri, 8 Nov 2019
 15:08:23 +0000
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
Subject: RE: [PATCH net-next 19/19] mtty: Optionally support mtty alias
Thread-Topic: [PATCH net-next 19/19] mtty: Optionally support mtty alias
Thread-Index: AQHVlYXKCkwgRpy5N0GblxIWUl4Rt6eBGB2AgABHxXA=
Date:   Fri, 8 Nov 2019 15:08:22 +0000
Message-ID: <AM0PR05MB486674869FD72D1FCE3C7B53D17B0@AM0PR05MB4866.eurprd05.prod.outlook.com>
References: <20191107160448.20962-1-parav@mellanox.com>
 <20191107160834.21087-1-parav@mellanox.com>
 <20191107160834.21087-19-parav@mellanox.com>
 <20191108104505.GF6990@nanopsycho>
In-Reply-To: <20191108104505.GF6990@nanopsycho>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=parav@mellanox.com; 
x-originating-ip: [2605:6000:ec82:1c00:9dfd:71f9:eb37:f669]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: fe27f9ef-bf3a-4949-a090-08d7645d7f7f
x-ms-traffictypediagnostic: AM0PR05MB5955:|AM0PR05MB5955:
x-ms-exchange-purlcount: 1
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR05MB5955B1C06D0684060F6879E8D17B0@AM0PR05MB5955.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4125;
x-forefront-prvs: 0215D7173F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(366004)(136003)(396003)(346002)(376002)(13464003)(51444003)(199004)(189003)(6916009)(71190400001)(486006)(305945005)(46003)(66446008)(4326008)(25786009)(186003)(256004)(446003)(14444005)(478600001)(7736002)(8676002)(71200400001)(476003)(81166006)(966005)(52536014)(81156014)(5660300002)(6246003)(14454004)(33656002)(53546011)(86362001)(2906002)(229853002)(6436002)(74316002)(76116006)(99286004)(66946007)(54906003)(66476007)(316002)(11346002)(6506007)(102836004)(8936002)(7696005)(76176011)(6306002)(9686003)(55016002)(64756008)(66556008)(6116002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR05MB5955;H:AM0PR05MB4866.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 5EAw3sa53hWXfHNcnNZhECq3teM0+eyJkkMolR5eMIJppqR4EE+JJMEMwXs1Nn/NrzTglRMApGEjs68Sd0gr2U2cg2zDi34HClNbKLHTj00xM1MriLPzLs3lmWdWq1a96sm379WAwjRul27sImCperJ89QBGpYzEavSGk0ftA17irFWlTayUgSYA4rtUECgp6ESlyK3aysSTvYVHqaIrO17h98J7KkV1d6e0JUqcytkxXB02uyVEzKWGfTFbhkAhe/hTChk2yWpGjVVCNYdoonp2rgAyR52rMCrvuWDaVwi3rK8TvJOWxmLCocG3yzMZkzyxEvnwY3dlewpgzzhk48akpuB5rMV5l74+IAjId3rBOwEw5dPKCe0enoy5RQ2sfZf0lUHQOAkWrRmcUWqEKl8FpntpVxxjj6EhpJU9wopmc7x1Q/Jce8Lam8wjjsT/OOgHAhzewkZoGhqX5KdCWPIhtHZ/CwlG9aFBHcEQYi8=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fe27f9ef-bf3a-4949-a090-08d7645d7f7f
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Nov 2019 15:08:22.9421
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0zlaeFUH/8dVgfksyeWpU64XkQI8oHNyveFYZijgOCZ7SKLeAGZHh/F2vsYq1iK3Be6bwXxKCPuxSRT2Slh1VQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB5955
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Jiri Pirko <jiri@resnulli.us>
> Sent: Friday, November 8, 2019 4:45 AM
> To: Parav Pandit <parav@mellanox.com>
> Cc: alex.williamson@redhat.com; davem@davemloft.net;
> kvm@vger.kernel.org; netdev@vger.kernel.org; Saeed Mahameed
> <saeedm@mellanox.com>; kwankhede@nvidia.com; leon@kernel.org;
> cohuck@redhat.com; Jiri Pirko <jiri@mellanox.com>; linux-
> rdma@vger.kernel.org
> Subject: Re: [PATCH net-next 19/19] mtty: Optionally support mtty alias
>=20
> Thu, Nov 07, 2019 at 05:08:34PM CET, parav@mellanox.com wrote:
> >Provide a module parameter to set alias length to optionally generate
> >mdev alias.
> >
> >Example to request mdev alias.
> >$ modprobe mtty alias_length=3D12
> >
> >Make use of mtty_alias() API when alias_length module parameter is set.
> >
> >Signed-off-by: Parav Pandit <parav@mellanox.com>
>=20
> This patch looks kind of unrelated to the rest of the set.
> I think that you can either:
> 1) send this patch as a separate follow-up to this patchset
> 2) use this patch as a user and push out the mdev alias patches out of th=
is
> patchset to a separate one (I fear that this was discussed and declined
> before).
Yes, we already discussed to run mdev 5-6 patches as pre-patch before this =
series when reviewed on kvm mailing list.
Alex was suggesting to package with this series as mlx5_core being the firs=
t user.
Series will have conflict (not this patch) if Jason Wang's series [9] is me=
rged first.
So please let me know how shall we do it.

[9] https://patchwork.ozlabs.org/patch/1190425



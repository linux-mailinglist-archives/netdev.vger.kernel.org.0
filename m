Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B2B12F4F06
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 16:13:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726152AbfKHPN1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 10:13:27 -0500
Received: from mail-eopbgr50053.outbound.protection.outlook.com ([40.107.5.53]:54919
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726005AbfKHPN0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Nov 2019 10:13:26 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jz4B5ekHW+HDoRYDd+/OGwX8G9e09+XRi1EvkOQrqIae4zz2eGJBg8lvludri7shJT8xRj1jpnJCxqVbQC6QdKer4giBXX1XHbRe0wgNd5IuyawgVO7mLg60ZB2Yx+UEjef+4Fj1xM9KJUKuGJm+sVJM1dekVpuySu0QoiOtSSpMghWTN7NFBYnn+zrLh5cRFevKP4OCj9qQIKd/+azbwb9x6PC6I86ZPvguEEkRGqs3Dw8ZamLUyTijRUisOsDgWv3wny4O/DRXlLCy1+EzUVpP3876t5pT27gSofKCzsXtnGL/kCosrTcD0xXMsmmMdtHzTJa2MSuvQnCtu/GwZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=865KBx/7DUUTLSzzJsSa/NzN9qnCtG7v1tMVXqgCiJ0=;
 b=FX/weqWEiBQs3gxzis89WzDVvTsm7luiXaPUcjlf2jo/GbNy/0UcM6lbg39nfc8UZ2vnp+dtdmPDea8dvOqos6Eg+fwiMe3ie7PFV5H1MMXniyxRZUztHAWsHUIsCE9PbMpLK2+2WN2iulHlF+fQVpGbewiTm8XJ/E9Rfa81fjeR5JJjDuYFXSLMqduWg0BiXzSjljxQWTtO05l0lA0n3d+QQAoELWDEEVqwiXdkshbhrUEK3Y5psS72LGRcJuYk6Cxti9ChfOdtsGZAc84pTICtx+HJKNQngwPQVa+EXHyQddprXq2aA5T67tFj3zQXJuRC+Rt1SWa+8sF3d3Z20w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=865KBx/7DUUTLSzzJsSa/NzN9qnCtG7v1tMVXqgCiJ0=;
 b=O8nXllHSyQjvxc0CSlY5HTo4ekjklRNhBHTT0992043/vaR/4UhN3NGQ1eG23TK/OXEunQsImYOiO63jLZoKPzWAIi2FDqf2G5W0Z/cCKeImHSRPIAAHjkaJedryCoWeLdn1PXVPYMq+OY6Q1a2taGJjPKz4TblEW2qA2OljaJ0=
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com (20.176.214.160) by
 AM0PR05MB5955.eurprd05.prod.outlook.com (20.178.202.222) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.20; Fri, 8 Nov 2019 15:13:23 +0000
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::e5c2:b650:f89:12d4]) by AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::e5c2:b650:f89:12d4%7]) with mapi id 15.20.2430.020; Fri, 8 Nov 2019
 15:13:23 +0000
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
Subject: RE: [PATCH net-next 08/19] vfio/mdev: Make mdev alias unique among
 all mdevs
Thread-Topic: [PATCH net-next 08/19] vfio/mdev: Make mdev alias unique among
 all mdevs
Thread-Index: AQHVlYW8aJYNvuSOqE64/Lmie9ItTaeBGXYAgABI+FA=
Date:   Fri, 8 Nov 2019 15:13:23 +0000
Message-ID: <AM0PR05MB486646314DB2873779F87991D17B0@AM0PR05MB4866.eurprd05.prod.outlook.com>
References: <20191107160448.20962-1-parav@mellanox.com>
 <20191107160834.21087-1-parav@mellanox.com>
 <20191107160834.21087-8-parav@mellanox.com>
 <20191108104954.GG6990@nanopsycho>
In-Reply-To: <20191108104954.GG6990@nanopsycho>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=parav@mellanox.com; 
x-originating-ip: [2605:6000:ec82:1c00:9dfd:71f9:eb37:f669]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: bce18573-55b1-49a4-68b7-08d7645e3265
x-ms-traffictypediagnostic: AM0PR05MB5955:|AM0PR05MB5955:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR05MB59550CDFFF95EFC90BB17559D17B0@AM0PR05MB5955.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 0215D7173F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(366004)(136003)(396003)(346002)(376002)(13464003)(199004)(189003)(6916009)(71190400001)(486006)(305945005)(46003)(66446008)(4326008)(25786009)(186003)(256004)(446003)(14444005)(478600001)(7736002)(8676002)(71200400001)(476003)(81166006)(52536014)(81156014)(5660300002)(6246003)(14454004)(33656002)(53546011)(86362001)(2906002)(229853002)(6436002)(74316002)(76116006)(99286004)(66946007)(54906003)(66476007)(316002)(11346002)(6506007)(102836004)(8936002)(7696005)(76176011)(9686003)(55016002)(64756008)(66556008)(6116002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR05MB5955;H:AM0PR05MB4866.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: POjolzwSY1vfB1aDGmhDzA04ru3AuE9YpPUBtXrEupDljUUO5buqC9X7fdvaREBA6NtxwXuN0xwAux4ouWL6B6Gu/lw1m23YNBGusJSO2uoYosMDgM2A6luXY0Rjc2sElGJJb43ND/+ZEgC9lS8kjPDYMfydrrdsi4H1I8H7kJ1PFJZkr2vVF9+3AtuajmPFsO2tFcsEPDw+mjJUYWVdUT6MQnRlp9qnYXz6TteYPKubauNAR2qL/JJNPRX39AzYKjuhlbr4DmLMz+g+2WAaHS0/q0LUlWI58pwqyVJJFpOtGIplhSXOFfvNPKlNIFby6ID8txmPq4YUZqQ2EE7BBQPhTU8mEfUNXXVwCkf9Tpl2lDunP1VD2TYipanYOi66qZuR9D/yeCqrze3jucZzeGBXRC5LHBErmaZwuyMCF6Y7ms8QqN/eICoSZT32skCS
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bce18573-55b1-49a4-68b7-08d7645e3265
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Nov 2019 15:13:23.0705
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: blPDhFTQgXA8p89BWiVpMLFIdHf6Njl8rqy+CwAWNZoEKwE3uPkm3JuI1q9r9Mk6vteHYomHrkLehX7buOeTdg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB5955
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Jiri Pirko <jiri@resnulli.us>
> Sent: Friday, November 8, 2019 4:50 AM
> To: Parav Pandit <parav@mellanox.com>
> Cc: alex.williamson@redhat.com; davem@davemloft.net;
> kvm@vger.kernel.org; netdev@vger.kernel.org; Saeed Mahameed
> <saeedm@mellanox.com>; kwankhede@nvidia.com; leon@kernel.org;
> cohuck@redhat.com; Jiri Pirko <jiri@mellanox.com>; linux-
> rdma@vger.kernel.org
> Subject: Re: [PATCH net-next 08/19] vfio/mdev: Make mdev alias unique
> among all mdevs
>=20
> Thu, Nov 07, 2019 at 05:08:23PM CET, parav@mellanox.com wrote:
> >Mdev alias should be unique among all the mdevs, so that when such
> >alias is used by the mdev users to derive other objects, there is no
> >collision in a given system.
> >
> >Reviewed-by: Saeed Mahameed <saeedm@mellanox.com>
> >Signed-off-by: Parav Pandit <parav@mellanox.com>
> >---
> > drivers/vfio/mdev/mdev_core.c | 7 +++++++
> > 1 file changed, 7 insertions(+)
> >
> >diff --git a/drivers/vfio/mdev/mdev_core.c
> >b/drivers/vfio/mdev/mdev_core.c index 3bdff0469607..c8cd40366783
> 100644
> >--- a/drivers/vfio/mdev/mdev_core.c
> >+++ b/drivers/vfio/mdev/mdev_core.c
> >@@ -388,6 +388,13 @@ int mdev_device_create(struct kobject *kobj, struct
> device *dev,
> > 			ret =3D -EEXIST;
> > 			goto mdev_fail;
> > 		}
> >+		if (alias && tmp->alias && !strcmp(alias, tmp->alias)) {
> >+			mutex_unlock(&mdev_list_lock);
> >+			ret =3D -EEXIST;
> >+			dev_dbg_ratelimited(dev, "Hash collision in alias
> creation for UUID %pUl\n",
> >+					    uuid);
> >+			goto mdev_fail;
> >+		}
>=20
> I don't understand why this needs to be a separate patch. This check seem=
s
> to be an inseparable part of mdev alias feature.
> Please squash to the previous patch.
>=20
Ok. Cornelia had the same comment too.
The previous patch had relatively more delta, and since this patch can be s=
plit functionally,
I kept it as separate one.
Either way works.

>=20
> > 	}
> >
> > 	mdev =3D kzalloc(sizeof(*mdev), GFP_KERNEL);
> >--
> >2.19.2
> >

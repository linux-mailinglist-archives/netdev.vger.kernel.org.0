Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CFAA31D7CB
	for <lists+netdev@lfdr.de>; Wed, 17 Feb 2021 12:03:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230488AbhBQLBM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Feb 2021 06:01:12 -0500
Received: from mail-eopbgr30073.outbound.protection.outlook.com ([40.107.3.73]:15780
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230336AbhBQLAl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Feb 2021 06:00:41 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XmJeWBg2Cw4Azwyuuq1PUB4J6oDuvpzeQCAwVz44QNh5TeJIYovidIPGAIWsZFK3DohGgpJYXf8JKJCPQ/bgwY0ckQ11oRYGnli+374D8RqahJrcDkH/1IGGvQCwkYjOv68MpvFiJAg3a41WabqUnBJq3khatiYiba9/ny+d2848EdHhkouiaO2fjXCvP0b+uDfvdJWSTsZL8Si6Ub4UYcpPipaseXjQEf/LiOoRX1wc6OLhmIcg16SVKSrpXCdZ/VDg2KBVqepPNM/e4VPXgbu0s73yyvdaj30Q079A+FsIEtZTGurOAoQ8PKB+XtvTTlF4ctDzG3aZRCd+0YpQ8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z8ojTnqodtnJGj9tpT7QuxC+KIVhGhgUQB0KDBTVJcM=;
 b=ISGm64wcV0OELl3daD5l1upMbWmup0mK78U5QelKEjGcMMFsEqcF2AmQ166AQC/aOAiaO8nADZXz/fg2rq7xDWkMGhMdepxB+TI19j1lKwCNGSquY7lU3XunDwqYTkwNGXO4rQi8fMporpIIK/vYICNYuUCVdnI7NoGhVPhHBNbGY0LwZ/CnZFm7dDIoovFszs7UOJzx/5mxeLk0vCCIUhnvIRxKU/tnmA2q0dZWeAtz50hGPURypjwbH4gm0/1+RukksqK0f42n3B2j50C0ePzmX9yCWiXGMGqBviJ2YVMbyA44EnJPCQf68gDgWOK1ZIfiZ4T2QXVAODhwR8BLGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z8ojTnqodtnJGj9tpT7QuxC+KIVhGhgUQB0KDBTVJcM=;
 b=Bsp9Cy7jjt3n3gxSjf85Cjnb3+Hd7DhPoqxFmxeskjhmBtKg4zi2q8JEwaDw/OK2lpgnrFZ+oNmyyE53CNFoWlKa9xbBGnn2zOIVve0b45dD/mcO+9est1xiASELN1GZ0Y21vb42oB+espoefT+MgevWrowO/Mc1tOcA4FD602o=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB3616.eurprd04.prod.outlook.com (2603:10a6:803:8::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.17; Wed, 17 Feb
 2021 10:59:52 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3df3:2eba:51bb:58d7]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3df3:2eba:51bb:58d7%7]) with mapi id 15.20.3846.042; Wed, 17 Feb 2021
 10:59:52 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "jiri@resnulli.us" <jiri@resnulli.us>,
        "ivecera@redhat.com" <ivecera@redhat.com>,
        "nikolay@nvidia.com" <nikolay@nvidia.com>,
        "roopa@nvidia.com" <roopa@nvidia.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        "alexandre.belloni@bootlin.com" <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "rasmus.villemoes@prevas.dk" <rasmus.villemoes@prevas.dk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bridge@lists.linux-foundation.org" 
        <bridge@lists.linux-foundation.org>
Subject: Re: [PATCH net-next v4 5/8] bridge: mrp: Update br_mrp to use new
 return values of br_mrp_switchdev
Thread-Topic: [PATCH net-next v4 5/8] bridge: mrp: Update br_mrp to use new
 return values of br_mrp_switchdev
Thread-Index: AQHXBKzIpNFdzzkilUKmoPsYhJWnlapcLq2A
Date:   Wed, 17 Feb 2021 10:59:51 +0000
Message-ID: <20210217105951.5nyfclvf6e2p2nkf@skbuf>
References: <20210216214205.32385-1-horatiu.vultur@microchip.com>
 <20210216214205.32385-6-horatiu.vultur@microchip.com>
In-Reply-To: <20210216214205.32385-6-horatiu.vultur@microchip.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: microchip.com; dkim=none (message not signed)
 header.d=none;microchip.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [5.12.227.87]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: fbdb015a-cf81-4cc4-be92-08d8d33326d1
x-ms-traffictypediagnostic: VI1PR0402MB3616:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0402MB3616039C952845B6CE51B5E6E0869@VI1PR0402MB3616.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: FScPFxL+FvDvNeHlHN+DOp0NlPkmJ9BKoZJKj+UX0lW866u9FM+BRhTM1cx+YfC8GqiN/YIRN8vaoMbbPU1R5HsghWkspg8g/mJ+zl31ptZ1UeQ+FvduvSBdnxjOl9DX5paDW3P1ul1hyAo3NUHfsKgp1r0lX39QA/ukH064zUzLYspq4+v9N81hOhRGUJLRwi1I6svyuMuENaZPxiqb8LRlu8Fg8jV8gk9tumER6QTCoLS7vTnuDbns4zhjQHc14GjUVyRVXaOl2Sae9a57nfXAeETSFKzqAqCSwD3DPTjZ2IFb0wbfFPNRkL2amMwebKbN1nKqQWbjRtEcR/8ipDN/0AJGZ2SYFQu+FXRoZvC6IQ8NQqZnkYljr0hn62H9CCqGVeQonEbfHytRdquNUtViu0AYE3wTZSYnoMNauSDwdpM8r/TRhLCB8q+PTEwvhHO5RSSDgI7n309MuqlJxMLnpF34pcte0tMKCeghfp6AiVj0Jg8+oHXwkiMzeAkkzo8YIebkGfQa3YXs9k0BHw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(346002)(39860400002)(366004)(396003)(376002)(136003)(54906003)(478600001)(76116006)(8936002)(7416002)(9686003)(64756008)(15650500001)(6506007)(91956017)(66946007)(2906002)(83380400001)(71200400001)(8676002)(186003)(1076003)(26005)(6916009)(4326008)(66556008)(6512007)(5660300002)(86362001)(33716001)(316002)(44832011)(66446008)(66476007)(6486002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?LoERQDYPKJn74+8R5bp3J3Pqbf6z3scGIk0iRRoMrfKhTkYmzlKGcY2i+ihI?=
 =?us-ascii?Q?S0T61EU76f4jGC9Me5S44PjX7RrNliyUu8IdZ2x6hZXVm0tQwxrFWctUN03A?=
 =?us-ascii?Q?GrmqxkyXi5IiwbLH4WdLWr0eFwOovvdFUvsWMlma5OnuewCbg8mFjFN4AkdL?=
 =?us-ascii?Q?CJN0ng7DudFa8KLX/XM6VLqS8whUKk3ivwaOPQqROAvZafnqk1litHZMFZiG?=
 =?us-ascii?Q?YglKOtU2AAIHoy8qWfmwZ3NTF+tXyRO86H0Wer+Vz3XflhHfaYDDQEMUt+92?=
 =?us-ascii?Q?gDToobFcbRHAGPaNMf8S6mM2STthvYja9PjtJpsyw+84DbkQpHC/fBokl+DP?=
 =?us-ascii?Q?scciJccrWIk3KbYw57gP0d5CvXuUPE5Yaj0qnteJNYhqPMo9xmXIZFT0Gtld?=
 =?us-ascii?Q?P9gLU6DOHVEFbxuWaNS/XYOB0Frq3ieC6rhgN2wsXWcWFBe6cFkgWQe98FWX?=
 =?us-ascii?Q?zckCmMeDhPPt7lZG2U3xOJZ8O6Hw+f67DP0Mq8pHTT5NNkZKdMwd2dtHrHZm?=
 =?us-ascii?Q?xslhvCFTTpw+wtg5BloINWmhfotC1hb+BJNgcciAa5Hz/Xk35SkzEWAFoV1/?=
 =?us-ascii?Q?4wE4LoJDvH+iZKd3xZMzKTh1LE8e4ujKK80iTlzMNca9IOEJDnD5hxTbxYkp?=
 =?us-ascii?Q?HRPVlRYO+gEAWq9ACNIhxkJL+RqUgyYRn+vckeASCTJPJUQejiHG9wmeLiOn?=
 =?us-ascii?Q?c5MOO8j9QudAtyZoIxe5nOnd3QSigPC01Evgp+miVNWo9wnZUN6h9cyiq/6T?=
 =?us-ascii?Q?CfRW4DYQ5MZelHt18xbfgIq594mXZDSxE+k/4NyqyCTZ5PvHMaUXNBJYcUfz?=
 =?us-ascii?Q?y2q1+d23AwRjnhHkb4ZOrxTykLvgrDuEDauBXy+CfW4XHHSHm30tE39A2q/M?=
 =?us-ascii?Q?ZMemXSGMOZ7nGUwy1Hx4P/nFZN6VN16vV8n/K7TsXb77OF91pJqooTbyrsw3?=
 =?us-ascii?Q?IIparDjlxcQH1pMHgewCJIEpjoMIWc/8KdM+fMhCNwBHqSQaOeecNpHYT3Qg?=
 =?us-ascii?Q?j+UznmVYbnBm8FORtmY5FzzclzUc+FOxH/Ce06jmmegC6nrytch2ikLrz6AM?=
 =?us-ascii?Q?Qj5yYcKPiivb3Xub4KhpAaWLgVLMRk5EytnB05YkUgzsGtHeOY66pZPKTZNs?=
 =?us-ascii?Q?EzRZzh+Ucf15AfmCHpAYCgI1UYHk7TtrGz3JnR4EgpDSJD25iAU5RPgsCmjE?=
 =?us-ascii?Q?9coG7rVV5xTqEydfWdIZRs1Lqq281pqOSGvMxplCLZqveIZgcgLu661MDBoQ?=
 =?us-ascii?Q?DpGDL7d/WkF9lp42NVtgkGVxb/vdj/iGQROJnZ+wsdgSn2XwwdS7j+cVnYQr?=
 =?us-ascii?Q?S6qkMeYf3xWL+vJIoadpzqdr?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <7FC3E7294BB39C4C8F6B740EB1077ABE@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fbdb015a-cf81-4cc4-be92-08d8d33326d1
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Feb 2021 10:59:52.0118
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: L79TfGRLW6mreVFM2i6XhlYG3clCbA51uahKUFFTRx/Q0d5wEFdbLM4BDRCvqOSX0T71H2zoAhj+nSnTNCmtCQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3616
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 16, 2021 at 10:42:02PM +0100, Horatiu Vultur wrote:
> diff --git a/net/bridge/br_mrp.c b/net/bridge/br_mrp.c
> index 01c67ed727a9..12487f6fe9b4 100644
> --- a/net/bridge/br_mrp.c
> +++ b/net/bridge/br_mrp.c
> @@ -639,7 +639,7 @@ int br_mrp_set_ring_role(struct net_bridge *br,
>  			 struct br_mrp_ring_role *role)
>  {
>  	struct br_mrp *mrp =3D br_mrp_find_id(br, role->ring_id);
> -	int err;
> +	enum br_mrp_hw_support support;
> =20
>  	if (!mrp)
>  		return -EINVAL;
> @@ -647,9 +647,9 @@ int br_mrp_set_ring_role(struct net_bridge *br,
>  	mrp->ring_role =3D role->ring_role;
> =20
>  	/* If there is an error just bailed out */
> -	err =3D br_mrp_switchdev_set_ring_role(br, mrp, role->ring_role);
> -	if (err && err !=3D -EOPNOTSUPP)
> -		return err;
> +	support =3D br_mrp_switchdev_set_ring_role(br, mrp, role->ring_role);
> +	if (support =3D=3D BR_MRP_NONE)
> +		return -EOPNOTSUPP;

It is broken to update the return type and value of a function in one
patch, and check for the updated return value in another patch.

> =20
>  	/* Now detect if the HW actually applied the role or not. If the HW
>  	 * applied the role it means that the SW will not to do those operation=
s
> @@ -657,7 +657,7 @@ int br_mrp_set_ring_role(struct net_bridge *br,
>  	 * SW when ring is open, but if the is not pushed to the HW the SW will
>  	 * need to detect when the ring is open
>  	 */
> -	mrp->ring_role_offloaded =3D err =3D=3D -EOPNOTSUPP ? 0 : 1;
> +	mrp->ring_role_offloaded =3D support =3D=3D BR_MRP_SW ? 0 : 1;
> =20
>  	return 0;
>  }=

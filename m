Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FFF041AD30
	for <lists+netdev@lfdr.de>; Tue, 28 Sep 2021 12:41:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240274AbhI1Kmr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Sep 2021 06:42:47 -0400
Received: from mail-eopbgr70079.outbound.protection.outlook.com ([40.107.7.79]:10686
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S240199AbhI1Kmq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Sep 2021 06:42:46 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JPJg3ftAT/0rVDkk+DZsrD8xgrUv2Vdxs6qSj5b268svYNxZC9uIZTnLU6QvMMNMjjG1+Fu806d/QUljfB9yIa+LXqteZUcOIBRL6nGwRniy/85qBGJn3Ffpu8C5IQPuWwpOUq2ZVA2G9q6eZLUc8t65KkZFyPWs78pLJ0BmAHo8zs3RWh5RJpWTz7YTNIXXoE4HBr/7x78iACiR7pN+eCK28+r/G1hGY4UhALFWv4rHvFNHcSEDmS7Tt8uiZC1Bd/Z4bCjEI5OLZXelvCmpcDHqGkx1y0t+bRoJrnp9lFbA+O8hy3ItdwAYgRa9/dDqwVAyB+DhbcgA3sX7ENhKdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=3OG0aklxP7KClmbmEeBOrI/SEyBgrZnh/2jkoHGgnF0=;
 b=O+/Os3/xl9mZMctq2FKPHkBr1Z7fYmA15rrLyCwPxv8/qP5s77z5EdFw2QzpLpk8YEiM0FM4rvgEc3IUhyE3LlEMHjG7d3dNd2MqLaiOFj+O3S/cVcweW5uXOWXSXx1ihHTmA+d8h4JRFTgwdEEGE7iEaugsmPUPAW9pAGh+dr4J+Rq34LfgYAByfNtyfSADAJdv+ozhvlPHca8kUDpsEuHB4bclN5BK7wL1KpPchYsCzGmNj0Ze0+3iIxNKsdH1FcIyRajHyNZMDbi+A/N4Co+mY+X5NfmyE6XSk4LJoNoeDylPO8vfM8QVl61g7lPn+wXhPzVNkT6mkEtgIj64xQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3OG0aklxP7KClmbmEeBOrI/SEyBgrZnh/2jkoHGgnF0=;
 b=Tzl5N3VUCeA1O29SO0FMA9NMUrSdR93V7SBaAIR5fbALoGUYKfMxSxuNA0clxDUvf5RP/eYIpXLcTcWCKPR4DDV9c6fZHwDRmKm6m9tLfD4uM7ujkLnIy8khNq0QyJ1L0HMyta4x/vhetopPgX6x/aZ103U9oyGizIXtLeMUyd8=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.20; Tue, 28 Sep
 2021 10:41:05 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4544.021; Tue, 28 Sep 2021
 10:41:05 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Wong Vee Khee <vee.khee.wong@linux.intel.com>
CC:     Andrew Lunn <andrew@lunn.ch>, Jose Abreu <Jose.Abreu@synopsys.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Wong Vee Khee <veekhee@gmail.com>
Subject: Re: [PATCH net-next 2/2] net: pcs: xpcs: fix incorrect CL37 AN
 sequence
Thread-Topic: [PATCH net-next 2/2] net: pcs: xpcs: fix incorrect CL37 AN
 sequence
Thread-Index: AQHXtB86VIvr3ExuHU+3raGaTBurpKu5Qm0A
Date:   Tue, 28 Sep 2021 10:41:04 +0000
Message-ID: <20210928104104.etfxxaeuwk2has32@skbuf>
References: <20210928041938.3936497-1-vee.khee.wong@linux.intel.com>
 <20210928041938.3936497-3-vee.khee.wong@linux.intel.com>
In-Reply-To: <20210928041938.3936497-3-vee.khee.wong@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: linux.intel.com; dkim=none (message not signed)
 header.d=none;linux.intel.com; dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d362f354-6b42-4ed6-6999-08d9826c792b
x-ms-traffictypediagnostic: VI1PR04MB5136:
x-microsoft-antispam-prvs: <VI1PR04MB5136ABF27B6386A39ADD00ECE0A89@VI1PR04MB5136.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: hmaXFbN1W32b4K+43o+BWLwvQvRyow8hMF20evRTCkmENxiMnHptbVqLEN31ckmxE+T5sxibvjofCm2WDy54WFDhR29AEcsatKyNTcg8ugYCO7tjLiovTA6bRoS+GZR78PZq7Lw3okBLyPusjktk9aYdwi5VZOrNQKs7RR+Gj1SIzuAjRBGgq558J88bIaFKaV5HXP/nHejpJV70OTvLGyfWH6sV77yI1TBX4J0IZjmSNjuA3kh1bvB4DLvomsPQfqGz4EJXjNACfYzZj2MLKSh94T+/Kd5BYwek0QOIrKIJsZ74sHZrEPJBQRtofxVBTOVUn1LfHtbeMf+QC7MVuKcZXyeL+P4/53DZ6TlqIWTxXsKewYJX/7RukBW41AcUkcoR+o9jZL0MqG2+z9Wb1CWMenKWMhZy0wA4mdUNmAfNLYbN3XwRPieb/mPHqWykTjHJCKvX/WtkCqBesEmfGLjPohjwO+vKJOX0JH/bYCiIEUQFHacHVPoaIyYKvZsmdDuJXPRAQGZBFvdxy0DAYdKX42gm/cIYxeI3SYtgrFDedF2MjIvM9t2liFr2LsWy5IWrBYcv6ZDIzT49r1JN7OPQoqepQwR0iD+rXBHLcoBrhQqLUJ21m1z389QbXdn8qpxoKu21hdSLjFBe6yDGI5GQQIYi+6cUxjtTr4tl88ufmC5eGE1BAV5ucdBp4YA87AstBIXri628LKQdNeKVoQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(366004)(6916009)(7416002)(6512007)(71200400001)(9686003)(26005)(8936002)(38100700002)(66556008)(6486002)(186003)(8676002)(122000001)(44832011)(33716001)(38070700005)(2906002)(508600001)(6506007)(66446008)(66946007)(5660300002)(66476007)(54906003)(64756008)(1076003)(76116006)(86362001)(4326008)(316002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?/k8SyQFbsGgX2NtMXPOUafcdXSyn+ySqt7jJk8akv+qId2L/vVjNx7Cxxz+J?=
 =?us-ascii?Q?JEBhFIccc0h4DR3RUrVRoHbyYiqhj4OlDLwmrVo5qMZMsbpMbx7nnGZyJ+gv?=
 =?us-ascii?Q?OLgmdMaF8I1YhJlF2q/dJJZVk5AoNscEf2Dpmkv2XezneGzfBKpeiJsa1ykj?=
 =?us-ascii?Q?u73D3BDDcZhrhSn0SPgKGMLcf1h/R+USFWd1nl9Ciw/WRMQSbcee6+9kYhMQ?=
 =?us-ascii?Q?A6aPZWGKOfAITKbMpgQW+mkFDLcFf2CgwMQSgaeeiHM982a2zSSeXApTEn36?=
 =?us-ascii?Q?r0Q1SWww/B1i6vT6hUJy768YZdJI/Y1VLwqQuV5F5PyPR7vcdTUNHfXDO7B1?=
 =?us-ascii?Q?Ar/sGPavM4Dw9czgtGwhkqGapeqADI8QysayfOjulTLagTbNgMAqiMhI2p+h?=
 =?us-ascii?Q?AhgLKD2QZseJG2KnH8BNfr9tD0ZsC6qH3UxYOBqbPTmcY9iVubZYebAClcmE?=
 =?us-ascii?Q?EJQlRZfWhfnfgf4dGJt8FToEDNb9rlRcVRq3gYEiSHpZ6GYnw/HmVVF2Nkpt?=
 =?us-ascii?Q?iCsdZ4I+RdslhuJsxhSUtrilI7M27uElzsN7gQJtn7vqnXwo3w3N15zyVwQF?=
 =?us-ascii?Q?sAIK6ALY5gp4Xo/ARa0N/DLOzqNT1+1OA4ZJQnDPc218OMg302PJFsCDfy8m?=
 =?us-ascii?Q?yXxVg1chf90/IAH+3PL03tw5Lnba+lSacZLwiidHL6UDc+/uYZUPjj5tBD5/?=
 =?us-ascii?Q?hJsYeoqzFjoBV+nWDP9VHNGQO8mrReU66llACg7IwZQy6RU5X5WIjdT8pGJ1?=
 =?us-ascii?Q?fQwBtvChgqxCUZiV0HZUQIiiOzOvbohC72Nx3iLI8Y9gm83u5QVHbbk9GY99?=
 =?us-ascii?Q?KOXsA8nNvTzV9xZbV/3oxpsmsMRyJICdZQ0nxLmOldhPb+UuVNhQVHH6DbD/?=
 =?us-ascii?Q?ShVPwV7xeg1aLUkeneNvMxt6N23f/7DH4Xc2Y8YDDjvwGApCovtpJSO1shxM?=
 =?us-ascii?Q?QHJZpuciyQz0l7iJ4mHZzTaTn8Kr6h9gIhNVS31cD0iLdpZeEFg6qYYVHP1P?=
 =?us-ascii?Q?rv5kkqYsmqfrqHLm90hj5uZUXmjHsX5xK2HXNfSk0ytx9zS1TUqTF9SdARj2?=
 =?us-ascii?Q?C7EPbpXjqX6GyehxzYrr2QFLSCWxQbIPEEGzkuOJrBqxNiDBY/cDhvg7sjTN?=
 =?us-ascii?Q?5wHHBCG+56I/lhlf1mZqry6iawa5wtR4pUDCFzj1PieebXPMQzOZUDy7fEYJ?=
 =?us-ascii?Q?+0OXYw+fSugcoPrES5mMOdvlMZR7ifvlOsyeoz0a87H18ESRDmjQsZa9uEUD?=
 =?us-ascii?Q?cdZZno8LuJf/6ClSjm8NTypWb4MrsKsAKqA/h9hux5wwiM0GVX2WKq1x8lng?=
 =?us-ascii?Q?qkk0qDFZNytgMC+ONIm6QI3U+KB3InItmmc7BB2ohJcwIg=3D=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <A17DAE00EE4EF1439964612DB27075FA@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d362f354-6b42-4ed6-6999-08d9826c792b
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Sep 2021 10:41:04.9433
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: C5Fn3jz5L71O1B6j4UmN8iIxOftqtB4Fx9yogjGvF+DmG1B/00CnpRNnGlOA5Lk2K0f2kwZmdenJwxFi+MOamA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5136
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 28, 2021 at 12:19:38PM +0800, Wong Vee Khee wrote:
> According to Synopsys DesignWare Cores Ethernet PCS databook, it is
> required to disable Clause 37 auto-negotiation by programming bit-12
> (AN_ENABLE) to 0 if it is already enabled, before programming various
> fields of VR_MII_AN_CTRL registers.
>=20
> After all these programming are done, it is then required to enable
> Clause 37 auto-negotiation by programming bit-12 (AN_ENABLE) to 1.
>=20
> Cc: Vladimir Oltean <vladimir.oltean@nxp.com>
> Signed-off-by: Wong Vee Khee <vee.khee.wong@linux.intel.com>
> ---

Other comments:

- please provide a Fixes: tag, like:

Fixes: b97b5331b8ab ("net: pcs: add C37 SGMII AN support for intel mGbE con=
troller")

(just like that, not split on multiple lines)

- please target the patches to the "net" tree. I see the xpcs_modify
  patch has other stuff in its context (nxp_sja1105) that will conflict
  with the tree in which the bad commit was originally introduced, so I
  think the easiest way would be if you could just open-code the initial
  clearing of bit MDIO_AN_CTRL1_ENABLE. You could then wait until "net"
  merges with "net-next" again and do the other cleanups afterwards - it
  looks like other places could use a _modify method as well, just
  looking at DW_VR_MII_AN_CTRL, DW_VR_MII_DIG_CTRL1. Also, the complete
  replacement of DW_VR_MII_MMD_CTRL with MDIO_CTRL1 can also be done in
  net-next. Just try to keep the fix minimally self-contained.=

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C19D631D795
	for <lists+netdev@lfdr.de>; Wed, 17 Feb 2021 11:38:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230336AbhBQKf1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Feb 2021 05:35:27 -0500
Received: from mail-eopbgr20081.outbound.protection.outlook.com ([40.107.2.81]:42563
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229707AbhBQKfZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Feb 2021 05:35:25 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eBaJ9BCPcZ6PUr1C2kzCg/LfGUaqAr40g5vbvBerKeNU/LtbU+2BkDc4GrrrMlNcwl/LdS6cayuVFCD7aUjqnLhhJZiVaI2vf4srkud63e5i2gU5v7HiyuAovcZ+bbTGz5NgOVavXwzJiXjS9kPyaJLAOa7/cJja1jMMuP41eFdu9r17BH7lyeQMQ+rAh/4iiS4vtaos0aEbEP2k8u0A6RtXuIBt9EoIxD9Jy5VSeEy8+rMp9Aoq6LWpMAXVLPaEd5CDBMvR1D4F3/6v6LH0m6f1+Nx3xGKuZUNRCvLyvxeKczec/xrPFFqL+UjTo23Jf4ukjOCSa9vxiJpZJ4ETsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YgYq+W/f18gklNVQ6Bb3hF2UicLJIt0+ZfKeoXIr6YQ=;
 b=M7Vp/Yy9VrTJvczE/VeU1tF3Wt76I6vgwwQRJvdPJsnLfYTF2hdZylDSEZBmniwZYV2yNQd1AnKRya3enwXObLtuJUPbFZuOA9kzukoEUo0SB+ukMDicC/kxPld/atWl9QGirl99w3iW6TuhIJXv4x1jrslu6+SxXy8FGMnjwW8nUUpZv1DRDDAiUcdITb7bL3TW4sItcnpIrBe60YwOoU9BAveXzEwU72nBMD+fRrpGBVQXiklpvoVk13XMw/dSRjMZqIP5IWW9eez1xmKqbOUFSo3HMhcOZt38yDTSLHKPHLH8eZ/r3+FdhUTsvgemuuNbk7tbay98taLrepXZlg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YgYq+W/f18gklNVQ6Bb3hF2UicLJIt0+ZfKeoXIr6YQ=;
 b=bZkedfRa+VjHRFa/gG/aHP2jPyiGhwj6LDlBUuanSuzR40gWZEJMn3RcimO7SU+pN91kQoVee+CdBi4hl2xn/M/7yxVZy9ZrCZj9EwVTbF3JcPRcP5Ar4csOnL1aoH7c0DUsubJl85w2hFeNOyIObYjUlA6K6Q/dgi7jo1wJR1s=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0401MB2685.eurprd04.prod.outlook.com (2603:10a6:800:58::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.34; Wed, 17 Feb
 2021 10:34:35 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3df3:2eba:51bb:58d7]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3df3:2eba:51bb:58d7%7]) with mapi id 15.20.3846.042; Wed, 17 Feb 2021
 10:34:35 +0000
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
Subject: Re: [PATCH net-next v4 2/8] switchdev: mrp: Extend ring_role_mrp and
 in_role_mrp
Thread-Topic: [PATCH net-next v4 2/8] switchdev: mrp: Extend ring_role_mrp and
 in_role_mrp
Thread-Index: AQHXBKy9eGp+yjutnkaeTLTu5mS83apcJ5yA
Date:   Wed, 17 Feb 2021 10:34:35 +0000
Message-ID: <20210217103433.bilnuo2tfvgvjmxy@skbuf>
References: <20210216214205.32385-1-horatiu.vultur@microchip.com>
 <20210216214205.32385-3-horatiu.vultur@microchip.com>
In-Reply-To: <20210216214205.32385-3-horatiu.vultur@microchip.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: microchip.com; dkim=none (message not signed)
 header.d=none;microchip.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [5.12.227.87]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 93e66119-a137-4e1b-142a-08d8d32f9ea7
x-ms-traffictypediagnostic: VI1PR0401MB2685:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0401MB2685C6A0CD21C1E8E66AAE07E0869@VI1PR0401MB2685.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: wyQ+ap8qeGXRBe9+04FF3tr0W5Zg1lcCPByW3zvRQajmYWfQQwS2qhrg1bULJJrgS1o2WUBxWn8BErvsyPYT4uXw+pNasXwOigecRSYrfJ0jqi4qTGW6EKp6g/Q77NHqDN3R4TQHxYJrhZ3lhddzu42U/khGXAUciGqhn7zY2+8/3+iZ6UENn2YikEig4QLtXlyNUdxSkP9KRyJnbeERFT5FM27zK82h9dr4JQDPYBqOxZA68ZCGqe9bi4LovZLoqOrgnMBrRdpvdE+G/EaaEONwC7w8M3HbbVeQAH97r2QZQavQwFR9ISOwTtwBeEJ4zINz1YVKDL+G15Lsj9tChmUEfZFdr+F4vv9KwsjzO6rgLBUsJrveZG8Y/apMdPOE95IybAygZwL7muFU2hyYj8CIKmqVEmGM6EUbMI+rPTMQloWaklAth3rQFZkptd5205WIilhqSzk3W5u1ai5E3FNN7jHnunqXeWxnr7nXK4S9tH8OuiqtCsFrlofLWm7NZgMaP0XpUi8ILG8hmzBU1g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(136003)(39860400002)(366004)(346002)(376002)(396003)(33716001)(1076003)(66946007)(83380400001)(91956017)(66476007)(6512007)(8936002)(8676002)(478600001)(66556008)(76116006)(64756008)(66446008)(186003)(9686003)(5660300002)(26005)(44832011)(71200400001)(54906003)(6486002)(7416002)(6506007)(316002)(2906002)(4326008)(86362001)(6916009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?ybtClpW9UcY6t+nAtU8oIs4HzBxmU6QW876scBhfFz/LC9OQ5D/+DfqJo/mx?=
 =?us-ascii?Q?sqzueUfNtAasGEcvqTKN5CSBLQXbs4ZRFxUft51Hn3COvwcmiu3Nsphmz1xN?=
 =?us-ascii?Q?6o8xWu2iw7200HP0rWZEyyxHI47NMJowhUxQNevdDuTzYQEUIsh/7vX5cBUt?=
 =?us-ascii?Q?7BBSHIALNnAyZYLyGLVYqJ6XRmDcQU3K9z3BiNNuRVJaLwQvEzMdwJA7sOZW?=
 =?us-ascii?Q?Xa3QK0VSUxqnvP2c5oiRVWka24ZDuDyDXFIaOlMmQSznEZETU2ubQhhFHCws?=
 =?us-ascii?Q?/wXmzBJ8s7anTggV59ukqtKSEEFOg+muH2O1cls/iOReCcjxLorz1AT2FOoo?=
 =?us-ascii?Q?fxgBBc+jk6l+rHMl4rboC9G9O5HfPy9rJ7pY8sE/Rvv4kUY8PZlnaZjLM58I?=
 =?us-ascii?Q?4yeg97TsD1JG3T835e3PmKPTurXLTgKskrszWR+wwtwCfrzzYfKrQXx9huRL?=
 =?us-ascii?Q?gWd5njO2CcYJYWmWKuCabY/o4VayOhStavD8LpGtDYH+GIPQyREvoM3tskCW?=
 =?us-ascii?Q?dOncTAgXbyalZot9f+UPndW+odyVED1qeG0Kvz0ZIgl/SWnDvYGmnqEvod4a?=
 =?us-ascii?Q?0/aXZRHt2Ga/mreOnhGIG2887cZtbSbVIaO4aersS+dN8rzMIaCxpNvPVl+F?=
 =?us-ascii?Q?Fo2gQA97V4IJm5mrPDZjJmvJFWCtuwsBG7Dcuc2eat9AyJjfzy3omKmfWiJi?=
 =?us-ascii?Q?y0Y5b65n5JNK422iOdo4GTh9qKWHqJe9dskLvDXxLWOht4naRzBA3PzvDeN7?=
 =?us-ascii?Q?w392M+87OB+08fixZXg+UxtR4PQW6ZV+PsbkObrmO1cyF7PMsx3Jx/7oaUuu?=
 =?us-ascii?Q?M7D0jdA3CH43bdL2jOiZ05ZglzWm29cMxSIzmJq1mtSIBFMOqsApZ8eEOOOL?=
 =?us-ascii?Q?VPOIPKJ/90jToLMrHaon3l5656I9Y0oLbmJQqjBKLrimYm0DDsPTyt6VwM1s?=
 =?us-ascii?Q?Vh6hXiCtv640UO2+b63gPDWByzlqvpjQDQ3jary2ig+TmHnlRfRwBgj7hL9Y?=
 =?us-ascii?Q?kqUTXjRSqt+cHU1ZFK/N8IIJloLNbnGnLjaeAUmWBrL++RejGi6GR9fcDP3W?=
 =?us-ascii?Q?IkfMUYbq7/RsyPlVJ21m+o4WTPqOGlnD0UioD5gLshP8QbOuHzGUANoa15vc?=
 =?us-ascii?Q?W92Ef09LYetLRFtykqrb8X7YSaaRfLMLzg5ngEODWaka286Dn0QItLbiElqA?=
 =?us-ascii?Q?IJJpjluhB8lsgV/FJnO+jfqR4fD1KQiNe0BerJHCNqzWwQYMwadqfarBcoJR?=
 =?us-ascii?Q?D2cU7+xbS86nc9jgdzcSoZpP8SyXpQcULD6+m7VcPXBP/fDcY1PJ/VVT+kff?=
 =?us-ascii?Q?lwS7z0unahUdbcyXPbI81X6Y?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <CFC55FEA90267D4AA2BEFAB1247F9073@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 93e66119-a137-4e1b-142a-08d8d32f9ea7
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Feb 2021 10:34:35.0889
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ODDt1TgyUOMRJ5IaJVD1vWRz+/BJpqC9g1EJk+icpwf4ex89gpQXcl4xTb76sNigFB9wri7iJztTvvUJIDcSOA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2685
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 16, 2021 at 10:41:59PM +0100, Horatiu Vultur wrote:
> Add the member sw_backup to the structures switchdev_obj_ring_role_mrp
> and switchdev_obj_in_role_mrp. In this way the SW can call the driver in
> 2 ways, once when sw_backup is set to false, meaning that the driver
> should implement this completely in HW. And if that is not supported the
> SW will call again but with sw_backup set to true, meaning that the
> HW should help or allow the SW to run the protocol.
>=20
> For example when role is MRM, if the HW can't detect when it stops
> receiving MRP Test frames but it can trap these frames to CPU, then it
> needs to return -EOPNOTSUPP when sw_backup is false and return 0 when
> sw_backup is true.
>=20
> Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
> ---
>  include/net/switchdev.h | 2 ++
>  1 file changed, 2 insertions(+)
>=20
> diff --git a/include/net/switchdev.h b/include/net/switchdev.h
> index 465362d9d063..b7fc7d0f54e2 100644
> --- a/include/net/switchdev.h
> +++ b/include/net/switchdev.h
> @@ -127,6 +127,7 @@ struct switchdev_obj_ring_role_mrp {
>  	struct switchdev_obj obj;
>  	u8 ring_role;
>  	u32 ring_id;
> +	u8 sw_backup;
>  };
> =20
>  #define SWITCHDEV_OBJ_RING_ROLE_MRP(OBJ) \
> @@ -161,6 +162,7 @@ struct switchdev_obj_in_role_mrp {
>  	u32 ring_id;
>  	u16 in_id;
>  	u8 in_role;
> +	u8 sw_backup;

What was wrong with 'bool'?

>  };
> =20
>  #define SWITCHDEV_OBJ_IN_ROLE_MRP(OBJ) \
> --=20
> 2.27.0
>=20

If a driver implements full MRP offload for a ring/interconnect
manager/automanager, should it return -EOPNOTSUPP when sw_backup=3Dfalse?=

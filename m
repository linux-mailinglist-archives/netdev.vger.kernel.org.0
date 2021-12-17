Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDB704793A4
	for <lists+netdev@lfdr.de>; Fri, 17 Dec 2021 19:14:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240066AbhLQSOj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Dec 2021 13:14:39 -0500
Received: from mail-eopbgr150047.outbound.protection.outlook.com ([40.107.15.47]:39219
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236375AbhLQSOi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Dec 2021 13:14:38 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NN1YAP2ZUPBmtiY/BCDoIKlVKUE/leGoSfi7BSBNHY8SECA8uigzBu942CicwVfTVF+4/pWodJqQFPrwllMbNRUhKxqOk1APi8jZlztTJ1f0Anymcl23FABZIEZa3D6nlRwojO+eZ03AYL6BU0bsiOGcEVA0Gh93adRMYfoi2s44A4r5ONCHBzLu0npdbuaHD2qaQRCWbVulb2NBLtENfZRqdJ7iH9mqFvCzDPY7Pl54bDpAAqd1LNmGXn6a3nyK0EJ5fA/BF7DVrNimy2QR0JCM9bNy1AlUk0txdIf9yXVcHGAD0wboRrkullgqXl99oBA+oGHsBelpQ3lwmUU8ag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=J/CETgTipIu7guc9ktZxFATB/X4zEqiY/NhXkF/9GyE=;
 b=HKj0ScO7yP8Ji31WiBzBOuvErDjbJRIs3ullZZOE9y0Bhcl+AF1apDAyYeBblau7Lw/XRPuDKnJ51zs4iVQ2VKoDQirV2b+meCE3ndQSIdUIv7CEAqUGIGjKogQmlWEq+MYuenvvpp7+CWhbbOjSsKvBhxFMPnip4vrjigN02RN4FuvgcfcKzNvKXRSrLzx1JvuRVpJtxL6RwRfficwvB7oTGwhmvxOIHhg71QKaopfApuIRDUdn7CxInLXUe9t3k6POowagu8i2du254rS0uqNKObq29CFA7wcN+OwCN9hii/3M2cd9YWI1mZR6OW+oYTEzeqdYb/X39N+4Dgkl1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J/CETgTipIu7guc9ktZxFATB/X4zEqiY/NhXkF/9GyE=;
 b=GnaZEVyWrf0YJQqc0MCwAK4Kn3/SsWYXDrcwc4GpL6EAdIvYEvwE+2a9pB+xT1qrpivIJjAjyRNX+ogIvxyFyGFFPgh4SFLV6GjoDJGWWRyW/ggWU+GuYQHD+LAgyUsWiwavxYsZoCpVb7oxlYo3x4HarP74SPdddXs0c9rZq2M=
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com (2603:10a6:208:c1::16)
 by AM0PR04MB6465.eurprd04.prod.outlook.com (2603:10a6:208:16e::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.14; Fri, 17 Dec
 2021 18:14:35 +0000
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::8d61:83aa:b70c:3208]) by AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::8d61:83aa:b70c:3208%6]) with mapi id 15.20.4778.018; Fri, 17 Dec 2021
 18:14:35 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>
Subject: Re: [PATCH net-next v7 7/9] net: lan966x: Add vlan support.
Thread-Topic: [PATCH net-next v7 7/9] net: lan966x: Add vlan support.
Thread-Index: AQHX81427TYphMdvnUaVtzKVd/dm2aw2/SYA
Date:   Fri, 17 Dec 2021 18:14:35 +0000
Message-ID: <20211217181434.mfnur3nucfiykgto@skbuf>
References: <20211217155353.460594-1-horatiu.vultur@microchip.com>
 <20211217155353.460594-8-horatiu.vultur@microchip.com>
In-Reply-To: <20211217155353.460594-8-horatiu.vultur@microchip.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f6000e43-3ace-4a0b-a4e1-08d9c189151b
x-ms-traffictypediagnostic: AM0PR04MB6465:EE_
x-microsoft-antispam-prvs: <AM0PR04MB6465916C122D1F1161FF6C98E0789@AM0PR04MB6465.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: FO8veFaYTt8NETPXrVFOKytdjm7APIDnuInWWNcmoLJzJaQJTd8naiilsA2sDMNNhRg8mdu+haaxKpw/R53lwhhY0wF8E7rAOp3cAB5F1KvsIpvQodBM6toV2hSqJjDsPNUzj0OLRPRh+m4FJyEuQN4TkkISD7TNKwyuOl0uZfKWb5bD7GQqTQVn5Eixzli1dvu/+GD0i1Ejks68oDEC/0zsDNHKZRlwcmDQKBE0wVjTziPFgKKpqbQ1GtMlpF5a90tmHj3WakwB38tqPgay1Y94onjRppucxPnXv47h6eokyzLdJo9Ht+l0uj/PXs7zuaYQkHHAfcAxcDyD6LSFYDhA5UmmVAe8GgstYrDVBQaIkL7bRF8AGcl3ewqm+i/PTG5KddVc4U6dff+CwuUki2M/Eq7T1RBiH5DINGfXYU91BFAEi7WcdnvGHT7Hn6S+86nUMepsoknoT7VDFdDjfonhSswq3J3LVXODBmEfljhxPL1jBRonY9e1CmsuF/Y6oY7NxqYPToOXw71JoacBL/IK2KoRb7EJYE7232JgQxWHM/5RrDknS4m7VoTn/lpy3XxLYPm+EN5flYCdJ8wp/XcXMZ31PLerbRIHfcl8oPKF4zDjeSRWF4ZEjcm6dgTKpiC2nA5db2WaGwBEpMcSVw9zA5PBTtMV5e6wC4H96VYncgPFIqBsXWn5UeauzRTYVXsy3JjuDmHjDQoRGUBHxw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5121.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(366004)(2906002)(38100700002)(6486002)(54906003)(122000001)(8936002)(6506007)(33716001)(6512007)(9686003)(6916009)(316002)(7416002)(38070700005)(44832011)(86362001)(76116006)(66476007)(4326008)(91956017)(66556008)(186003)(5660300002)(508600001)(71200400001)(66446008)(64756008)(66946007)(8676002)(26005)(1076003)(4744005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?x4ChnQtEOfOn7c2ZDY/FV4rOmMPMZwgluVgq0F7+qhIJy6SUF6+TG4kZHhZ8?=
 =?us-ascii?Q?4xC3uie68gy6iJPMqstAwTBAjH2FpN882MtkrNYCII/ztWkew5Tu0rySXrYS?=
 =?us-ascii?Q?oJOEWn1Mwsjg7nuq4dNbiYDPyZuIDWj/YaXMPLLZsw+8iCZBtryqzT7x7vfz?=
 =?us-ascii?Q?1fJXGLrMzTrDl2PcTY5XrsFxapM4gabe46VbUF+BJu1KsNqG87tiN4VtjFTq?=
 =?us-ascii?Q?tKJ+3Ux973eF9HZF5g+PFJNgi8Kmqmy/L9wtx/mns22ao2v0g5uAHhCRKRX0?=
 =?us-ascii?Q?UHpsCEO8xyKEDU/dE8iV9Iir5MRB5+bj2GUMZhBVSVyw0YKIbTfs5yvwZiAG?=
 =?us-ascii?Q?YZ1YEmo2Z0t4iVZru99fncIMBOcdZOCpfHVUWuy+xf7/QtHoMoH1KzVa9qZB?=
 =?us-ascii?Q?tpXh99/twbFTeq8xDSL/9/Jmc2GlURGKbhDaOQzF+4G2skN+cdmlXrgXJc5V?=
 =?us-ascii?Q?6dTGRI55xuzWXKVEiomAmqrZ4wwEy4guQGr7a9mup9/kgBbc2i/+caN7oI9V?=
 =?us-ascii?Q?pP65OfqCwLm66nnGsCFhncYxmye9sLooLU39A2pOJ62DazOOO5o+pRP5wB3W?=
 =?us-ascii?Q?waHF2vvx0sCwh99Hd6QC0TOG8B/N+g04HAQ2V3D0QO8shQfNwQDmvD2ZcFAA?=
 =?us-ascii?Q?DbiocyvsXQK7afmR9d7j2ODGeSCYgKOMRON5n7WD6Pnx38jjAwilLWlao0BO?=
 =?us-ascii?Q?azC44QEyduavTlo0kLZ4uZ+8ul+KJP21VpjippPjOJ2wCyBGqRa4TVFXmNnf?=
 =?us-ascii?Q?1mzJ999pJ6W+8Rw+jHEzwYW0DvAXeK2jI0yRZLs3KvzFbRDbN9sqySDfCSnk?=
 =?us-ascii?Q?wQezeKOlTcC1xjxRiryIWRlKbPoBeEJ6znMXc37GBlSF1YbIUJwhFyWDeQXn?=
 =?us-ascii?Q?RY6qwiGl6nSZTZxJ2ibuTLrkK0mStfdFfqeMQv06bPgjreHSNDsYf248s0NY?=
 =?us-ascii?Q?/+uXStOM1cYM//SpdYxdHs4yHShtNDNLX+RD7Z3sLvumxg8o2bi45xkh4uGq?=
 =?us-ascii?Q?Qw0Wt9vW2wJo0x4i9cd4VVnRKpezoLa2xp3DMIuals0vFFCKOKCczjvitVUp?=
 =?us-ascii?Q?o9YMIChC/VFvF/6IO9ZuRg/wKQWiUD6z0KPTia62Nt+jn9shbnC2XJp/ymNE?=
 =?us-ascii?Q?vEPZts61lUu2uNF6lHgjE5sBYP9TIEy6LdFlBVE1+HKPXtZ7XiJpg3HhHW0g?=
 =?us-ascii?Q?7Oo8XJaIFY3MR3xFDt1wgOW/F7oh4trqdO3F7Nx9RbSiD+wru8VeL78MQM19?=
 =?us-ascii?Q?mQEzj+jsuW81+wcAXYIyDt88CtiBdnj4zR0nB+WFHganff05tMI3E3YJggiL?=
 =?us-ascii?Q?CG8sp24oS0KYl6d6R8xl4XL/OLSPNOxt9cq673nzqCFyUJBanCFToTUaYTVF?=
 =?us-ascii?Q?GFy0aAtKGv7uMrVknRInGSDqZyetVALOdemuMWcry1CcsOcemLf7xlxf7ex5?=
 =?us-ascii?Q?ZtQq5wAzZKsbiOSpJYZb4cEy7pTiE9iuPmhOiMtcrVhkNXAumDHSQruEGhIt?=
 =?us-ascii?Q?B5nFCq+dGQ+yBHm3hd8NNpp5GS3iZ5AwDE+xR6KmWoZkvy4eiz2P1wiJOQ60?=
 =?us-ascii?Q?tK/pNj+ccoBMpKI/IWNF0Ztly2+eVP5KN6jFGwL20hN8cFpz2FQRmsDcCjpU?=
 =?us-ascii?Q?a4YkL8+4lHhcPb01/ixj6G8=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <9EF1BF9161A137479DB948D2622B182B@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5121.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f6000e43-3ace-4a0b-a4e1-08d9c189151b
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Dec 2021 18:14:35.6860
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 67aAr5x/qg64BMv3iZqoFMbFJaZJbgaH8pgROnioVDrKaQArzheM3jQxvC57iQOhJWAYKflPBABH6tWohcPyxQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB6465
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 17, 2021 at 04:53:51PM +0100, Horatiu Vultur wrote:
> @@ -120,7 +124,12 @@ static void lan966x_port_bridge_leave(struct lan966x=
_port *port,
>  	if (!lan966x->bridge_mask)
>  		lan966x->bridge =3D NULL;
> =20
> -	lan966x_mac_cpu_learn(lan966x, port->dev->dev_addr, PORT_PVID);
> +	/* Set the port back to host mode */
> +	lan966x_vlan_port_set_vlan_aware(port, false);
> +	lan966x_vlan_port_set_vid(port, HOST_PVID, false, false);
> +	lan966x_vlan_port_apply(port);
> +
> +	lan966x_mac_cpu_learn(lan966x, port->dev->dev_addr, HOST_PVID);

Do you still need to re-learn the port MAC address?

>  }=

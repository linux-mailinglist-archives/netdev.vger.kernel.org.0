Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE4CA46E98B
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 14:59:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238289AbhLIODF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 09:03:05 -0500
Received: from mail-db8eur05on2074.outbound.protection.outlook.com ([40.107.20.74]:52667
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231816AbhLIODF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Dec 2021 09:03:05 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MymyuD1OOCR5KU9lHhFwAA/0XgwCSCCvlPtaKAR/fKMRGmYsKMVFATDunsmS94Yadejmo3H7yBw6nm8t9ZzLjczCltLv2YxAsfc0hxNVRO1Pl1ZExsPWSdEaQyrxg9Q7OoLOuYAfx//PKK7yj8DFJogx2x+TXNjuselthP8z2/P/CH5fEJaGa8nzJdQgT2J1swQm7Rf2Dm76Ld38BoEf7sOF7Uf/MC8jZlL9JqKb4IHbBphkVRIVvMzS9V/eAOWaPoyW/cBPWK8haX9cdIoVxyoH+2U9NV4/jda43sdkLndbkpvuL6zrKymXsBjUQ3BFrMSTr0uIicfRWTLXp3bgUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Et//yr+GNvr8bJJYna8JU9dBQGURINV8aje0mdYoFhM=;
 b=FVXPhqeLU8kfwi23G2fdTI9eDEWm016wXvE13COhncPMEv4UncuPKWrngAYJIGz6BPVYABi9iIvmTWz6Gf6aHBajey/7nQ8ck2Hs9NhvrW0tYM9CoQk5tB6T0k7dJ66kGuAWP/p9/a0A45Fx4FDZ+vM1/SJaBJ0ZykB4xwlgsH6H8REKAmur+yrjDRtyws3wr+2iJznkfrs5ceCC5iJDKhtRv/ngyTSoV1g/4Wvk6UplnzYMfMDutrQESE+7/w2d4DHxRoY8GPi8Ufzkka6QZDekzapVG/tLdfpIYeQOhIFKttqNZiwoMkAwLV+5iYTLZ9Q8OskApnr0HeTQUmTaRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Et//yr+GNvr8bJJYna8JU9dBQGURINV8aje0mdYoFhM=;
 b=JNRNGPw33kAyHryiwFh+Lp3ko5oo4Huy5Fzfy5v9zNcmN72q+Ii0+yo0VbKhuNEl+6/DhydjQnUR8QKLYkCMkvWlvXCIajuclY7CfZuhfztZfVW1Db5EjvHoFdsnwtItqD5XbwVDcXPqTpxL+KkoBQYBEnWbqIVduaRZ+DM79/k=
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com (2603:10a6:208:c1::16)
 by AM0PR04MB5891.eurprd04.prod.outlook.com (2603:10a6:208:12e::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.12; Thu, 9 Dec
 2021 13:59:29 +0000
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::8d61:83aa:b70c:3208]) by AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::8d61:83aa:b70c:3208%6]) with mapi id 15.20.4755.022; Thu, 9 Dec 2021
 13:59:29 +0000
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
Subject: Re: [PATCH net-next v3 5/6] net: lan966x: Add vlan support
Thread-Topic: [PATCH net-next v3 5/6] net: lan966x: Add vlan support
Thread-Index: AQHX7OGlYEp5PrNq7UKGxDy/7sGvF6wqMDMA
Date:   Thu, 9 Dec 2021 13:59:28 +0000
Message-ID: <20211209135928.25myffd3xzcnmndl@skbuf>
References: <20211209094615.329379-1-horatiu.vultur@microchip.com>
 <20211209094615.329379-6-horatiu.vultur@microchip.com>
In-Reply-To: <20211209094615.329379-6-horatiu.vultur@microchip.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 23b74328-4ec1-4125-6800-08d9bb1c1e3b
x-ms-traffictypediagnostic: AM0PR04MB5891:EE_
x-microsoft-antispam-prvs: <AM0PR04MB589116BA15A2F2BECDB34086E0709@AM0PR04MB5891.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3173;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: k8kgiK1FfiWHs9WNYy/Rj36wQYL5m2dvQc3vFEkdtUdRK/xagsex8sjg3bKbm4gl7KUT0EVWN+oMZ7CxjLg+IzdJ80Wu8S3ptLc5TOo2kkFVAeQumGJuN8tqz6tgH7puxXQ2snnsyigGruWlFd4z7fRczu9zd5awFC9orHxqnNfAMFDv7lK3pF7FJApUqutlgft1UQ/tPsaKeXnMF39p4Hhd6JDl15et0kGuL4JzeF0EwwKe8cYsuIMbENcRYQRPlf3tkYTFuDpkTfBcUVnV9B3uZYHqhnsmp/uO9MQqz8rjI20ZFaCnrKdkpQYSLVUUPN3NCiY/S2GJk1RLcAvmVmJkM4sPvlUAp1TqOETxoMrfF0mRkWmyWrIDx+PH+gtnFIbsT/Euzd3h7iKvgk1qeeUglZnVG8baKaMyBfqkdSCV9YuihudYqcguO/Pocify1IU3fFiIPickGVJ6PUYXk8zxc5FdkCrDLY8lyp5P59PigvPPjHPxASHGOVmqDdkz9pKe86CVte/8RmDRcdjDDZ8sce+7IQLM2NifU9RtomAEk49zWPvWom2Tr+4Lrep2dR13OlB3uiQJuTOhljHTMH/HC6sG+SF+W14YE7jeNMv1oO50Wx7bFAbAEFl+NPHJ/fVobG4Sa0BCz1sHXl29GTXlvd5URRVvGbup60FKHTb6W9cFivd+oHms262JUBxYMrfYWa54jXMhgBDrNc4MIA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5121.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(366004)(66476007)(2906002)(6916009)(38070700005)(4326008)(66946007)(54906003)(71200400001)(186003)(508600001)(6512007)(7416002)(9686003)(64756008)(66556008)(33716001)(38100700002)(86362001)(122000001)(1076003)(8936002)(6506007)(66446008)(8676002)(26005)(5660300002)(44832011)(91956017)(4744005)(76116006)(6486002)(316002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?77/834Y473qxC2RTRWjsXLzNY3zznTyN/x/679iTYh+V4NRSTSM+oL7+TTjK?=
 =?us-ascii?Q?wj1Z52COQBsOAFM0rWQ2xJA+09EaGFQgxfLNfcnnKB4g2nZ+uDLU9ZBM1hPW?=
 =?us-ascii?Q?Pq49AoPfzrEtGrTRXWblaNT8WOopKS0LWue98CkcXMys2c3XbQ6nGJVWZswR?=
 =?us-ascii?Q?xO5Q4inUD9D/lisSjKRcGAcahAzexSBJycw0c9NgqQKQjLAwcdG8sBG85iIy?=
 =?us-ascii?Q?vFD0uMAcsvKzqWIoG5U7qoNc4Em+c2pUDRDgLR4oZphU+tcJDCO0+sv4+hRM?=
 =?us-ascii?Q?jAtM/KMCelReQQ7HlSqftaszG09S5nnPyhJYA2Uo4L+RYiGbBPzUIUsu6FHS?=
 =?us-ascii?Q?NXULPa0I3ktMf6J4yg/W8mxv3fDqX4ukpyqOJZSsgYcVSm+itIKxQOkxPwmA?=
 =?us-ascii?Q?g7KYbdAKDZEaoD/WhVM/UXUaNidYSdojFdOrHKofStyYQWGeV+00634lvl65?=
 =?us-ascii?Q?PV1y8WRhkeNv8ZuL1m1bxA5vfCRekCm4Gll8HNHFIDkQFIbR6QQ2rk1pBiMd?=
 =?us-ascii?Q?EiNDuo0L73dyH+BKR7Iaizp8/23OfCBAvjD5ymVfLo22SUdRZx77oOr5vNmg?=
 =?us-ascii?Q?JpAlg0fi6lyaGDNJ284KfZoo2dLLh3E3qxL5zOZCA6CGEBdR6urIkdBXkLYK?=
 =?us-ascii?Q?V6itMLB6lPklW4o5HDMNx/OFSJ6lYPh08sBffp3+LXMuB6mEoOD3WHXXUvGR?=
 =?us-ascii?Q?jVgJ0kmW+r0rC8uutXXnBGXAQi/dEQubR8wgwLTmEQCAVcuygNzK7zeouOge?=
 =?us-ascii?Q?y5OCHKKDPKljU6y+V6ckM/IPCqucGc01njir5PYssG2ZaFmv100MgDa7ydgF?=
 =?us-ascii?Q?sQx4LzI5B2lo7nEpsO6I239trvzM/9xDEMkfg1/qyzZ08DJERB/n2p8D8wgV?=
 =?us-ascii?Q?WSbB/OhzCGfBCiFxE8LkRYipOloM6xilX3Qifk60Vz9MrL+QuL0HWBWs/BbW?=
 =?us-ascii?Q?iat8w5AZarrDJQwNICBvRxmZSJJH9Nsw67kZogWTbPIYwz8txEiD0OECwBqM?=
 =?us-ascii?Q?WJSeuqkwakKVaRuDZhnl2WBRoYDd9DUeMSneU2/SMMED6ZkR7Rf2y/0/6QrN?=
 =?us-ascii?Q?o8jqxigyr4bC0PhcKHrEQ3jqpT3Fjnu4n8ZRE4p0ZKI+EJrkmZVTPl1Bsarq?=
 =?us-ascii?Q?RA9WcvYw69dCSq2HEhuiIwM5rEa4luT94MnRjDR7H0UCZwynds/QgKOh35UO?=
 =?us-ascii?Q?+ld8cgT6onFqDsltFbl+qKtNPqt+IcjB2fyM3Fp2RsW74CDm1nD3fOsiiD5J?=
 =?us-ascii?Q?Im5U6OsT39LIONK67K9k8QAkFphe9QfhjwNCfM74sQ1OOpWXy7hLiF5fyAqX?=
 =?us-ascii?Q?pq332iV1wIMyu2nwsBDUGkGv0oo6WsoPsbpvembKBb47MaFmpk27MYGxJ3Oh?=
 =?us-ascii?Q?HtAFy3MBr/zp8PhTaWVajkcykikjNuoSvBWDxQ5WF5y6MsU3EfBCz6S6d/DC?=
 =?us-ascii?Q?yTomOVi6+SMHbCC2sB/ktxTfXPjhe+A6VOdvQmDQkaV+tIKrQuP6WWHYZsRz?=
 =?us-ascii?Q?8s56x6jRDqfarErraKqSAaGutNTVvYd2mngQEkzwsvlJLXzM29McEgo8KkQQ?=
 =?us-ascii?Q?x0yCdW0ymVygxJVW5Z+fciMHUxRB6OR4UZtZNsJX42MQQUEHdI/9fX+0sY/W?=
 =?us-ascii?Q?oTbW1HEqkI4t+JtJfIn6U8U=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <69A8819DF5FA2F489BD10B71AE9DCCFA@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5121.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 23b74328-4ec1-4125-6800-08d9bb1c1e3b
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Dec 2021 13:59:28.9264
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XGNO0pKfYs6f2KNPe500aMNoCRBE3e4//kucNGl1bgK2W1u+NMYORBJAIsYvQ97V9vrYvaFUMmvsYeLoGIhkZw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB5891
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 09, 2021 at 10:46:14AM +0100, Horatiu Vultur wrote:
> +int lan966x_vlan_port_set_vid(struct lan966x_port *port, u16 vid,
> +			      bool pvid, bool untagged)
> +{
> +	struct lan966x *lan966x =3D port->lan966x;
> +
> +	/* Egress vlan classification */
> +	if (untagged && port->vid !=3D vid) {
> +		if (port->vid) {
> +			dev_err(lan966x->dev,
> +				"Port already has a native VLAN: %d\n",
> +				port->vid);
> +			return -EBUSY;

Are you interested in supporting the use case from 0da1a1c48911 ("net:
mscc: ocelot: allow a config where all bridge VLANs are egress-untagged")?
Because it would be good if the driver was structured that way from the
get-go instead of patching it later.

> +		}
> +		port->vid =3D vid;
> +	}
> +
> +	/* Default ingress vlan classification */
> +	if (pvid)
> +		port->pvid =3D vid;
> +
> +	return 0;
> +}=

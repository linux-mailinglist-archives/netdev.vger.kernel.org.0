Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFA1D4684F0
	for <lists+netdev@lfdr.de>; Sat,  4 Dec 2021 14:08:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384996AbhLDNLy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Dec 2021 08:11:54 -0500
Received: from mail-eopbgr00054.outbound.protection.outlook.com ([40.107.0.54]:28486
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1355001AbhLDNLx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 4 Dec 2021 08:11:53 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TkSLAZjCIoCk0sa6FwMMMNhsF6O/FeTEfSr5wZodDnNaYT+5RKunobjQmy/PgGhI4uVet6wA+CfFEaT1QbONlspR3h75+Mv6/W1CvGGmZePJLDnkHQfRJA0rR8kr3tfzSQ59UVQGnkYIOOJ9gwjY04Yp7WQJGNb9Sh1Iv3jpIfBwhLrkt6gzxiTjRS6UuWLs83NNfCoACSQlVw+gvtjffQ1ru7XWnzBglf4axzcl4bVhjHwh5+7pjluP/f2WRksJm7M9kySXNTzQc8jMpiG/a6mynWioHmOR+v/INSAmqAKL5H6MTgkBDf8Lb8hL5SMM3I8AU8wVPPESZ00Gbd3vXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IzLo5uQkueAt34RubRqe1eMpmhjwPT1Rs4pJ9CtpjBo=;
 b=UdHEAozscbicQ9qxGoyZI2tzeJm37u5Fjpht56zFO66v8GfNm1HwXhwPAIySoQuTGwyAjzlRP8R0nenywpFBEMiYVn0S/iAylpz9gCgoBd0NBQmQSeZA+1+eWZoO311cc1AAUtK0ou+CDTCBIz78kcFLvpHU+SXiNK4b7bvnViCINGORTV3RUjMDekQIeWZymgJHClWoajHKLr3m6vJHE1xWdUbESdfqgQR7zV7KctX0qUbP39/CKxq+C+vNHJZs4W3D9igVanS0+a7f2qTZGA/L4Lh7PRYQyQfuY1+UxW6h5ZUBVOXVwVgGEPtr+llv0GaDQQZzYb7JBTfd65eqjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IzLo5uQkueAt34RubRqe1eMpmhjwPT1Rs4pJ9CtpjBo=;
 b=W6JtAXGgH/IP7jRu+QH8GX+uHXzjRyKV/I5Q5IHD/0NI49Ncw6a6PChfu5pzAfIJ4oqMSW7DXEZel9CPBfj54mlF1q6NQHDBc8sTRDUDJndnA7mCqwH51IlKzuC9XQdQ7imNnuI332Qq4p1BaA+hW980CnMzYX4+hanRw8tZsU0=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB4685.eurprd04.prod.outlook.com (2603:10a6:803:70::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.23; Sat, 4 Dec
 2021 13:08:20 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::796e:38c:5706:b802]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::796e:38c:5706:b802%3]) with mapi id 15.20.4755.020; Sat, 4 Dec 2021
 13:08:20 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     =?iso-8859-1?Q?Cl=E9ment_L=E9ger?= <clement.leger@bootlin.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Denis Kirjanov <dkirjanov@suse.de>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: Re: [PATCH net-next v4 1/4] net: ocelot: export ocelot_ifh_port_set()
 to setup IFH
Thread-Topic: [PATCH net-next v4 1/4] net: ocelot: export
 ocelot_ifh_port_set() to setup IFH
Thread-Index: AQHX6Gn/FbL7frqUIkGKruPq0taeVqwiTy+A
Date:   Sat, 4 Dec 2021 13:08:20 +0000
Message-ID: <20211204130819.3sclg4jnnqlyjqfw@skbuf>
References: <20211203171916.378735-1-clement.leger@bootlin.com>
 <20211203171916.378735-2-clement.leger@bootlin.com>
In-Reply-To: <20211203171916.378735-2-clement.leger@bootlin.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fbf069be-b9c9-48ec-75f7-08d9b72724f5
x-ms-traffictypediagnostic: VI1PR04MB4685:
x-microsoft-antispam-prvs: <VI1PR04MB468545B6B25DB499B5E5C8AAE06B9@VI1PR04MB4685.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: BT9TeBdg+0b1eP//1eN3bGvN7NCoo07eXmaYgga2+ZPXYCqvRIQeEStLpNNVQ7Mj3/VFU10oN7iK5eCcM0HY0/SXwaoDLc9S05+kl+AeFiJkSpq5I1TakgPi6tE8Jyk3h+f/dxzi7DGZ7pH1/q0H32EJSeWaMEhzrF9575+qo8EAGA0mSv8SCs0EyaL7qS+C+d9rtQSJ6gq0Yyk78sqQpCSTd0eObBtAKIbVSpFiAK0kvoLl56F/XGHI9wacf6EWjrCt0m4nvm73qLxIpmJd95Nn+lKnui7ammP99XvxO4M80Ba6Jpm7Tr+Z63ewbzk1BfA+4nGzfspzUTeq1IkYel7xApRuZsPs6r0hV5dkutH94U2srb+MZw8DpLuaxRQZtgufr8JVjXqtgFhcGnpTvJYVfQj4UUTcy4x1O8pgy+L6BF9CSN9JmdsSlyg9cAbLoMfrIkXiS75LDpSy84pEW5HkgaKnSTpD8NzXblATtEYYCU8NUCkX74Vcr0kX2QjrYrEb4Ps5ti6yw+8aVvieZx6wUlxGcezbHbtyW4efA0IoeOCSY884eM4IAsq8PYWv2LNl5wvnt4Qd+GW6ID1bTQTB4hUsoa/Znd9RWU/8PdqQNug7+cmNgJh5rptvC3EWxpnE5TV+XPrfNUmVsq7ccUzJmkmdQx8+09qAXurADHswrygKUhlQxlCn1MCP+tMUrXmafo54qiXHJU9rfUYNfA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(366004)(4744005)(33716001)(44832011)(8676002)(64756008)(186003)(8936002)(6506007)(91956017)(2906002)(66446008)(38070700005)(1076003)(26005)(4326008)(6512007)(6916009)(86362001)(316002)(508600001)(122000001)(66946007)(7416002)(5660300002)(71200400001)(66556008)(54906003)(66476007)(9686003)(76116006)(6486002)(38100700002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?G8Ml417ktaVMh8aPTc4qAzdqGQmdkJDFe61y6rIXoKIrt6chhsBE25MaKb?=
 =?iso-8859-1?Q?h1DFoCXRwPiKWxDI5U3INtKQ3GpmL0QkMpxxv8lD4uoKRMVsgFp6HP4rU8?=
 =?iso-8859-1?Q?cShn4zOjqJeca7o9tlzuv4sR+a0CB4eOXwyavkU//gFcCzRHxzA6YbZs4c?=
 =?iso-8859-1?Q?vm2AoTjjGboSjwX7+yjYup0UQTcimZ3FZYhqNSHKNsf9HyNfpyb2BWJ463?=
 =?iso-8859-1?Q?K8CO+x/KvT349uc54Ulq0v5dO5cFuzI4CjMRjgD7E66DPm5sEwgwQvDoSS?=
 =?iso-8859-1?Q?Ks6xD4nL+fBxSHyClLvkOnOlfFRGteydDhapGDKXyX8ZD0sf/torR3H5yZ?=
 =?iso-8859-1?Q?W61/+pxL4NKK77cw3hYzlm/Utj4f9jBcEJ533nKF57aLmrJEIVpuvEp2wk?=
 =?iso-8859-1?Q?pi17mtSKYDA0j6eTLRPkSAFb1uIEUOp1ZNdx0BHnG/VRXSda/MraBA0auX?=
 =?iso-8859-1?Q?/VEHVNHapNQyJaPC4fxD+ssUfIIwyAczRhf8PNAVX4m40Mtt6QiWm3Xr8S?=
 =?iso-8859-1?Q?tr1SlfirAltfB3RwjhZeprGTRNwrtCz2l99HdCC14jATRaqhFaZqTjR7it?=
 =?iso-8859-1?Q?94OToXNhr31Wx25imnjnGglM0TtSNBgu8oGGkqcisB2TwrNvJ8dW9y5cKm?=
 =?iso-8859-1?Q?709JdUUJd0b+IYv7YzQwoNsLUBuagdJO4DyZakG4yRLkJCDWMZjGRTzsJ0?=
 =?iso-8859-1?Q?AJpPCC375IB0xeRqXLHSzgysyRXq75zlW23ZkXLqpzJpp4JDYepNZ4aOvE?=
 =?iso-8859-1?Q?+ByNAt0Po8oK45Ce3gA//RT75IQFJnBaIHISlaNUnqOLVmpj6v89Bxl4fc?=
 =?iso-8859-1?Q?zTo4deYsLVnuYw9++4CuNrGxz6f1miYaJpP3WK8GCWd4VEC3iMi2RJc6Y5?=
 =?iso-8859-1?Q?bo3ygt9yWtIxxRBLOe05B2gz3WDiIX7A3hYLncJH61IEn3eNtY3N0TDEeU?=
 =?iso-8859-1?Q?SiNDWjBqR5rrFA+jymn7Qd/E6BGQNIig9I3zPEmDcvBBiF+gPTNXEf8guh?=
 =?iso-8859-1?Q?W+LlhDOuSWS17TI6H0azB2Ze8J+h6HU5InEdnvJ6UEhXGADvrzAq/R3Jop?=
 =?iso-8859-1?Q?ob3Xyj21YPRAChgUcaVu60vwL/w+aeMrs45H6pJS9cbB04ibN+B87KZ0I8?=
 =?iso-8859-1?Q?/NyvMvsXwy5oUdUI2q3I/vFxBEvxiKCHK7KJWcAy2M5G7SP9q+yp0PoPhw?=
 =?iso-8859-1?Q?Chn8nTk10PhPKpdRx0XpBvbAVyWhNEyN5R0ngJAmoKDYBC0ghRtbj4mZoU?=
 =?iso-8859-1?Q?3fHoyiHtoNMvnCzHGKXRn6Ksl2ukvIKNVV8zHQb+3U3XP6RUSon6LVOmMl?=
 =?iso-8859-1?Q?xLgF4klYcT4TbH7Iyz+CqZjQSnYElkBKypAJOyGZJsFz1jl23TlMyZuAGt?=
 =?iso-8859-1?Q?ryoxsWT9IFChESbKoOugolVACSvl6VeCnPKPIhPRx+LR4YDJyjY6kfZ2g8?=
 =?iso-8859-1?Q?Axz9sxeayZYhLyEPo2D+jRmcjTE76iK0CZWVITE5QQ9Mat/LT0jQdafcym?=
 =?iso-8859-1?Q?5tqUa1BY29Uf8eiKx/p47R51FzlcSv4mYcVLlL8MpOkNeZ/aWHilrc1dbI?=
 =?iso-8859-1?Q?3hMtQdK6JoMdzsw2tVGXw9l+rD9nE4058HxWInlhZEOKsBvxXmbugQeYbc?=
 =?iso-8859-1?Q?V/pEagdQWOqGVs6sO27dj8FW/o9xSo9v2CqH/oocarARYrguaLgH8G4nUM?=
 =?iso-8859-1?Q?8LbPUJQ9UOCQz7thvTI=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-ID: <595C55A8C0855E4BB494D455D4A5A861@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fbf069be-b9c9-48ec-75f7-08d9b72724f5
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Dec 2021 13:08:20.0840
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: eReNu4zeWnQ8on2VpcaKCuih4ax5ztW1oNHghpE7vXSDby9PVmyWJwWYIgV1vAUkr56cOxYSQGjm1PmeYQ350g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4685
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 03, 2021 at 06:19:13PM +0100, Cl=E9ment L=E9ger wrote:
> FDMA will need this code to prepare the injection frame header when
> sending SKBs. Move this code into ocelot_ifh_port_set() and add
> conditional IFH setting for vlan and rew op if they are not set.
>=20
> Signed-off-by: Cl=E9ment L=E9ger <clement.leger@bootlin.com>
> ---

Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>=

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BB5331A2D0
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 17:37:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231210AbhBLQg1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 11:36:27 -0500
Received: from mail-eopbgr70058.outbound.protection.outlook.com ([40.107.7.58]:30947
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229602AbhBLQeW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Feb 2021 11:34:22 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YCjHkvLQ63jf3XYh8E1VjlX9ysfiM8TmdIgRDM0ra6jrxITus/42NeWw/aG49z0tQ9piTJCU2obiQefeXNTSexalKiqywt/2n1AE97jfU27MVKSPRbw5O3hsN4c3PN9swZINr9TJtgOvXhsg7HeT/UGbamdDSIIlIAde6pCdfE71xSMatRfliI+7EudnbUBUGUtlX5vcVL+B1MJPQ7Z9CXE5d5F0CZ99Mocwnj105jPJl9O08JUbg9HjDkAIlLEOJv30WLQ6fsGevP/QmXAqTWBFXq9H3T8mo7iPtbftR+dbBVFrBqPTREZvgV6HCYqV/l3VipM8QuNVsyX9gNwk7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uFXlEjGDjw+/NgrWW6rUIoZ+ml8+DpBPQVhHMRUPv7w=;
 b=MFSISoeGgPtDjElnP/MO1kxpyPiIZn79QeJRyWDfM3CjmXrrGi+kZTK853PBVVg+piDvaBEyjQyw+zBCYxCdec2OKnmXeMHHor9b/CjqWIob+Bjm1YBazj2AFvrx4NRMXmcADWoYFbYB2Zt4vyy5wrFjGvD9TdpI3Ez+BrOo3dmlAe8yWvUUQ/GiTld/hoGEbwb0wafXS6b1VfSVCkkF2xzU28cJWu31zsn6yzGheTzmu+asnUEJCxGyNNHd0Au9ilfti1uQreO4J7XiImLHv+WTdtmKPfNhToTeoMUk7W6B33aP0RDm0kUJpkE7SwcWjgJcS1xk782esrVXg0qZqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uFXlEjGDjw+/NgrWW6rUIoZ+ml8+DpBPQVhHMRUPv7w=;
 b=NmqmyGUVjTXIryuzGR/mb3IZV7/7mC5avRVyYXC03dxBIuxluvDV+Ly5EJo3n3dtClPHcsjA1YXPIFzMxigu3cPS36RFZuZjYbYOiQ7IACFt4Xwm8v67MEXetdWj/qofVU+MbYBYn0iu2ltbiqo+0g7TxC2Kto3Bwu7l/GV608o=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB5854.eurprd04.prod.outlook.com (2603:10a6:803:e2::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.30; Fri, 12 Feb
 2021 16:32:42 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3df3:2eba:51bb:58d7]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3df3:2eba:51bb:58d7%7]) with mapi id 15.20.3846.029; Fri, 12 Feb 2021
 16:32:42 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Bjarni Jonasson <bjarni.jonasson@microchip.com>
CC:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Antoine Tenart <atenart@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Steen Hegelund <steen.hegelund@microchip.com>
Subject: Re: [PATCH net v1 3/3] net: phy: mscc: coma mode disabled for VSC8514
Thread-Topic: [PATCH net v1 3/3] net: phy: mscc: coma mode disabled for
 VSC8514
Thread-Index: AQHXAUhluUesuHE2zUKvpf4QrFwfPKpUtsyA
Date:   Fri, 12 Feb 2021 16:32:42 +0000
Message-ID: <20210212163241.kbx5eqyaa32js7mp@skbuf>
References: <20210212140643.23436-1-bjarni.jonasson@microchip.com>
 <20210212140643.23436-3-bjarni.jonasson@microchip.com>
In-Reply-To: <20210212140643.23436-3-bjarni.jonasson@microchip.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: microchip.com; dkim=none (message not signed)
 header.d=none;microchip.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [5.12.227.87]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: b22b669a-26c6-45ab-e782-08d8cf73d1db
x-ms-traffictypediagnostic: VI1PR04MB5854:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR04MB5854B004489D154D3729C65BE08B9@VI1PR04MB5854.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: UcSursQ3Sidb6fy55B1kTI4FhLa7QQP7rspU0/G/qwhiW04LoiNuhUkJ41PMysqW1TpMF9x9qTdYelKrlrCBSOirHR8oS0Y9honlrXY07dqNgY1r8qGFLzmhEJElUS4UYiS0TRdxR3b07+I+LeY/6gehpxhyVMjZiaGX/yESiZd3Y0nrmS1guKKSZ98hAZ2VBGLIZCs1XeIdLRDxLSjvgerHTKxDmiKiGuMYkEnnDYcKy1ForwYuKCwhws6pcrqMMXyr2zip+iSjSrAasNyHIxnRsdAboOFWD1PDTInrt/CfvIFr0mHnshXpiH9sUuUxR90IoGByOVAl0b4bIlORrmAGtndbuSoIYU5H9Bj7cwVgqINRcOSfk4qQ0NNFPPUeeg+lO3NS8KK/vHsEOTPJeAZCjIhb8PiV6naEfFELzr7TTmy907V24DpNhqSXeFK32mTMj0FMbJ2d8svMczxmLtaIPtHSQWgb22Op95rWix5TpBiGjFmejHYglNZiYvLmTm4IkGmLLP0VMQvqIgVq2g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(346002)(366004)(396003)(376002)(136003)(39860400002)(8936002)(316002)(66476007)(186003)(66446008)(54906003)(4326008)(2906002)(26005)(66556008)(64756008)(76116006)(1076003)(6916009)(71200400001)(66946007)(7416002)(83380400001)(8676002)(91956017)(5660300002)(86362001)(478600001)(6486002)(44832011)(33716001)(6506007)(6512007)(9686003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?V3gPboX7CoJIpqMk46eVtofh7QkAKiH+Br8w6tYk1hD8zLczVEOCSBdNh8tO?=
 =?us-ascii?Q?CBU/w0zOehTBp6PHvopTgl3dbDPJXUsjUyjontXqQcYJEJD2Uz13/heE7Rqo?=
 =?us-ascii?Q?IxIenza+S8otZqUmF39vpdfuYwEndUKDyyQ8IqEdsrxDeB1bnXLlhXhHfz8g?=
 =?us-ascii?Q?xVqFpGH2lYXES1Wvbl1oiwIEji3PcWccYZgyenT+0a3Z/3c0l1Oz38HIaYAS?=
 =?us-ascii?Q?QsVyb9VmKKWEn/rdEakiFIj6fYNiJTxVqDX0bL9FPY/GoZZK4JssE7j0nsj+?=
 =?us-ascii?Q?GFLtkTGWEiAQRtjquHlZYyulaReNTZjS/b+BO7Cq1C+C0QL2RKT3P7q1HTiV?=
 =?us-ascii?Q?t5bQIbv/opRKT+MoqrSnej+gE9JKH1X80U7TDHOoJXxeUS07RdvnJf8Ii7oE?=
 =?us-ascii?Q?NT+VGjStgreDJS3tlbm2TGYeKzUvgJRBZLnOthvWIjKbVQPfKXB3fhT7XSOZ?=
 =?us-ascii?Q?ekSjW/S5ny4wsabYKlyi+LqffcPfMBM41kj7K/H2Hu2hjdwSKAyXJaY1XEVV?=
 =?us-ascii?Q?LAjstb7XL8V9fPZ0WdLPtpTjfc2i7eK+GQCkMtSlnhjgt0dhqkSXUiWIj2w5?=
 =?us-ascii?Q?exYmors8EWzX714z1jmlU3W8cmnBIjV/M2W6IV925W94rHbSmlJ4941dqltE?=
 =?us-ascii?Q?AVJF+NtWTA81uIcgQ7JGp5aRvUH5t6P1knb3LUr3FQkXjTTn7HW9OY5ngWKD?=
 =?us-ascii?Q?xsYQOuxjZ1qaQZ5XVCiqzu6YyR1hIzfcwd/BY7/0EteXNRnwyRp92Zbr47hu?=
 =?us-ascii?Q?u7vWn3xdy2kFFOiqJxqXRdIj6OkpfgUM9N2pMFSBOtteWywH2p7Tc4S93CcM?=
 =?us-ascii?Q?dYhFlwhQzfhUGzZjrYkc6bKUMDnadorSDtkHWIukTTI4O1x1LuSjr3HtDIp7?=
 =?us-ascii?Q?wa7MxbEhTw3agWdlZMaC6XQNT4HG8E7/k6/Nbxg3bLxYGAuLO2uI9hG+rrZm?=
 =?us-ascii?Q?dOJoDCt7GZ+bQpsuJJArKX4dvMu6thLHMlwergzwxxXCJzhIp8JWuM1m4/+0?=
 =?us-ascii?Q?sJPZBtp7j+yIj/Q9zcFBJIiLQKXXkG3csQsKBHSO8SePKQBjyFW35AOc1uIa?=
 =?us-ascii?Q?TZAdpCf8et5MkIGP4XAjN7YRETJhQqiyaFFFku1Al6JkJHXbAIq49OcHQoM1?=
 =?us-ascii?Q?0O87EdEawX33Xk9kX62X1EVzg2V+afgJiOna1kGYnkIzRTKvdbSmjGyuJ5z7?=
 =?us-ascii?Q?RCdlFrsua1GQFqPWw2U0WfJ9Cty9P3LNFiYODdgx9aakRyp0kWnT69TjE6HB?=
 =?us-ascii?Q?+y8P1dw+yT1fUMZAbK+vKjqej/1kkU4uxuHzxlh6U6OaaIplDHtdNT2+JWm7?=
 =?us-ascii?Q?ppdAkaPbhsV+mV/GL3Cv4Fbb?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <9C89C197BF28B24FADF2FDF9F452D43C@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b22b669a-26c6-45ab-e782-08d8cf73d1db
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Feb 2021 16:32:42.1383
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kticSPGaIZyhJbmANweyEu1VcLLqX+K00kdceaK6VN5rqkPPKhuhWNh3Mtc7/Ynv50v+zre++CjZfPjXExBTBw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5854
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 12, 2021 at 03:06:43PM +0100, Bjarni Jonasson wrote:
> The 'coma mode' (configurable through sw or hw) provides an
> optional feature that may be used to control when the PHYs become active.
> The typical usage is to synchronize the link-up time across
> all PHY instances. This patch releases coma mode if not done by hardware,
> otherwise the phys will not link-up.
>=20
> Signed-off-by: Steen Hegelund <steen.hegelund@microchip.com>
> Signed-off-by: Bjarni Jonasson <bjarni.jonasson@microchip.com>
> Fixes: e4f9ba642f0b ("net: phy: mscc: add support for VSC8514 PHY.")
> ---
>  drivers/net/phy/mscc/mscc_main.c | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
>=20
> diff --git a/drivers/net/phy/mscc/mscc_main.c b/drivers/net/phy/mscc/mscc=
_main.c
> index 7546d9cc3abd..0600b592618b 100644
> --- a/drivers/net/phy/mscc/mscc_main.c
> +++ b/drivers/net/phy/mscc/mscc_main.c
> @@ -1418,6 +1418,18 @@ static void vsc8584_get_base_addr(struct phy_devic=
e *phydev)
>  	vsc8531->addr =3D addr;
>  }
> =20
> +static void vsc85xx_coma_mode_release(struct phy_device *phydev)
> +{
> +	/* The coma mode (pin or reg) provides an optional feature that
> +	 * may be used to control when the PHYs become active.
> +	 * Alternatively the COMA_MODE pin may be connected low
> +	 * so that the PHYs are fully active once out of reset.
> +	 */
> +	__phy_write(phydev, MSCC_EXT_PAGE_ACCESS, MSCC_PHY_PAGE_EXTENDED_GPIO);
> +	__phy_write(phydev, MSCC_PHY_GPIO_CONTROL_2, 0x0600);
> +	__phy_write(phydev, MSCC_EXT_PAGE_ACCESS, MSCC_PHY_PAGE_STANDARD);

Can you please do:
	phy_write_paged(phydev, MSCC_PHY_PAGE_EXTENDED_GPIO,
			MSCC_PHY_GPIO_CONTROL_2, 0x0600);

And can you please provide some definitions for what 0x0600 is?
My reference manual says that:

Bit 13:
COMA_MODE output enable (active low)
Bit 12:
COMA_MODE output data
Bit 11:
COMA_MODE input data
Bit 10:
Reserved
Bit 9:
Tri-state enable for LEDs

0x600 is BIT(10) | BIT(9). But BIT(10) is reserved. Sure this is correct?

> +}
> +
>  static int vsc8584_config_init(struct phy_device *phydev)
>  {
>  	struct vsc8531_private *vsc8531 =3D phydev->priv;
> @@ -2610,6 +2622,7 @@ static int vsc8514_config_init(struct phy_device *p=
hydev)
>  		ret =3D vsc8514_config_host_serdes(phydev);
>  		if (ret)
>  			goto err;
> +		vsc85xx_coma_mode_release(phydev);
>  	}
> =20
>  	phy_unlock_mdio_bus(phydev);
> --=20
> 2.17.1
> =

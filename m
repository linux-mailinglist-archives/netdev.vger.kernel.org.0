Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 960D841ACEF
	for <lists+netdev@lfdr.de>; Tue, 28 Sep 2021 12:27:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240193AbhI1K3P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Sep 2021 06:29:15 -0400
Received: from mail-eopbgr30087.outbound.protection.outlook.com ([40.107.3.87]:38403
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S240055AbhI1K3O (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Sep 2021 06:29:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NZqwvm62NnHBdioo066UWhXDrwC9tj0zUbzf50Pk3ERKXsSLsz/lOZUUvwDUNB0NpTeuiIR2/QTJxOsGJIXUGUnzW0OBZfNjnhgGEfwqmNENj0y0NDmw42NJ6hUL+s0Ci9b5Jl8vaUWl4syCSUyiopcFPDqCVbSL+dH0FgCgpBl5lBZi7Mi6z5JdjZ/4fsdIYsprUAjsaxvBIbmrgT5nihwHWZG4VOQ3LMhGQ80lVNt+rOELPDfAcZdMSvqv5pAa8sZn+MB1dEligCLgr7o6NHo6CQjLjo0Wps0+rpHQTY0ni4r3cn1CMMX+T/nCd5yPH4Bh/ZYgwQeFZokiL9ZmzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=VfylMUuyod+ExBTR3moEmBPIrLXv+Xqd/E3xI0ngMqE=;
 b=SgX9jUCluiFQxtZJca4vtzrYai9SulCsHrvOxeMVCZpvyZTOs8V0KKynqdLeoNEUDEJWj5eJdME/D/zmXeRB8NpW9+aB8l6Nnm1nXasoX1O4aYkx9giCF4NGgoNSgjm193oEmwqXPMIA6MBFbwCnCzyeQPsYnfUC8LuHTYikivxqt1wv1fYjXdg0nu7jemZ0pC9LYuHLbuNmQ3NWbJy9rumhK3wxlqVgfPFFixhHeskm8rn+tmgzjb9d4LT79g9Jl45VkAPH8E4BdpPMG9Z9eThAO4/V7m+Mb6aWD0yzzlRpnmL7WMndAnzJqlYmUp/yWCXDN7TA+4Nwa7arB3lfMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VfylMUuyod+ExBTR3moEmBPIrLXv+Xqd/E3xI0ngMqE=;
 b=k3Yf2QTuNSA/4sYDer/nsoOWyDWasrB0pvzkSBNZzUDyiBPAR6dJ+l6d4A6p/XG8wDKdK61T/t9Th9EzgCRLSM986uciAQdGxY12CmcaSgom7rGuwMAzt+VgeLC/ABXEo3mBbacDque7MY9u0LRNhhelP7wUDKx/+CaFCWi1Ee8=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB4223.eurprd04.prod.outlook.com (2603:10a6:803:41::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.18; Tue, 28 Sep
 2021 10:27:31 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4544.021; Tue, 28 Sep 2021
 10:27:31 +0000
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
Thread-Index: AQHXtB86VIvr3ExuHU+3raGaTBurpKu5PqMA
Date:   Tue, 28 Sep 2021 10:27:31 +0000
Message-ID: <20210928102730.72vays22sulixodb@skbuf>
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
x-ms-office365-filtering-correlation-id: 4943a547-1f3a-4936-2753-08d9826a945a
x-ms-traffictypediagnostic: VI1PR04MB4223:
x-microsoft-antispam-prvs: <VI1PR04MB42237395B02353D5FC0DBB5FE0A89@VI1PR04MB4223.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: RCjSIdnWFj+NiAyOqGhjzzSc78S5Dz6COWg9ecEdvLAcm6QkATWntmxdot2xcZBSySi0KWs1jCiAQTfRugfuy+L4tuQ58wNlJgCY9mz6TpEbEAwr3wdL8TEn0FExmRLOlQFutZJwynK/KO+SdJPnFrQ/qqqamUkAcpKirweVMYyzvmY5IwtrfOYDpVva1slxPla466iNTzc1yU5ssF3AXyD/3wQG5NcMDWkWkr2mGOX+m7VxVO5czTjhGOP+4okBwKbL9/UfmGev4nu6nJ3AXdREQ/D7VBCEgPWUJ4WRG2ZafRs1zn3t1VlhiR6s7CVPNx2QknN2ZUm9pkSYZ94P38qrXe3jc0aebXnnP0arEWMqNNi6KekOkEJ+DzxNMbEwDPYgQWSATaNm5862+5//w9bbBIeLgjpHfskEF/Fdf2nW/8fj/xWDCyOx6YtNz1xWbYGcJf6BCUXI0hAnJpHofOR+ATGZQPfWvQW6Ts6+b6Ha0Dxh6dySGRTJ9KUW/J50OhCEi3ZAUQNs7XniW1gCfdwGb9+IoCYO9GOCL3idZ1Yqy6Tlb7Z5u3/sSW4P1OmnQLSl+xehVd7RUpWjdchE4z38oWxnKlZbCH5hjOxEt5rYF0u+dfZEm0A8KN60PYBM6r6bfQ4Cj0xvxB6jYHjf3XpaqWSDHjKtaDJIUbT6hWLr00RLFQDcflu7Ik4tpES6/5VhPYKeNm/d7YAsV4aQQw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(366004)(316002)(186003)(66556008)(66446008)(6486002)(66476007)(64756008)(86362001)(4326008)(38070700005)(54906003)(2906002)(6916009)(6512007)(66946007)(76116006)(9686003)(5660300002)(38100700002)(71200400001)(8676002)(122000001)(508600001)(1076003)(6506007)(7416002)(8936002)(44832011)(83380400001)(33716001)(26005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?TI7W1l+n8CFO886lmYnBOiLX94c6jhgFAdvceAC4+3ir23wPS6Y48LulaYhp?=
 =?us-ascii?Q?fb6+FbJe0UJcrSjM5Euh4h61esVFu923t3Hvw8n6395HZia48Q8tmWC9U2F4?=
 =?us-ascii?Q?o3GjPNaECOC+uVS/8B4v2WTcMl62BlJxj3M07gvfQNwnfUseUtoe7cesOsFv?=
 =?us-ascii?Q?kC/de18byKivnvohxtguIac0LYUymfTNvlmGMkQeV6o5RVUfYDrvYBlxfCmJ?=
 =?us-ascii?Q?hxwRCxpurTQzwiNrWFkHcU6YJx2lZDOVuxvWxX1MeByj6jFElfpzqFJSqFo9?=
 =?us-ascii?Q?24s1mXUrxQEuvv9TjeFYKbSapTJBhW9HnDEyDOQxDydtaFcDqQE/GL9NlYY3?=
 =?us-ascii?Q?K9ZrYqc+/M2H0Ra98ppHKPjgWttCZxFLnh1QVc4+YBYQJgUY0sJPhycqy4X5?=
 =?us-ascii?Q?QnMT3jyJtunntJ80qdH1elW//dLvRerqgTL6ikW9eWuSit+P7529rUHL1Fz+?=
 =?us-ascii?Q?rz2leEcOvdZ7v1ev01HkSoM+JoRbWERJMNiY2ACFH1c2/VVYl8ndie7HrZhr?=
 =?us-ascii?Q?ysmuxagIgOwGa2vRjuG68sVTbPtR2gn0/CkDHuM/sK7AJj+fpH+qXMxs2S4h?=
 =?us-ascii?Q?rSeR6+EtH67RRIDF+M9Yg+OaTZSDJtTxKHX67SoTW8RTHjekuy3yOf2WVDPH?=
 =?us-ascii?Q?uSfuMuEBh5kic79lYu/9Qyv29zAmdBOyuLgAL/DW3jD5Omt5/hh1cUjknNCR?=
 =?us-ascii?Q?HL6I+Z6VnkU7b9cTirmCKr0gwY9g/3p4LpTxm8R0C0h8pFWdbuIk1WIxKCu1?=
 =?us-ascii?Q?x7cqQrPN0SRMNqnMEfhv55u/HLC+PaEOOOUum9PpSATJrgCcBaERG9Dw1vV7?=
 =?us-ascii?Q?9igZZjxxxknKgoVklkv1w/fPu3wWtTmocU8hXSAhWz4F02rwFhXb/whUIVub?=
 =?us-ascii?Q?CSCkd/LsVpUBDlH1fTKC53UapUsIrVO+JjSvNsPilNVhcIzdyxYHWxM3briV?=
 =?us-ascii?Q?fe3vc2bZOz+cEh6woeolLM+oTS7DRYhaDYxOG9oS2MutSbFQnWA5FK4gUsNO?=
 =?us-ascii?Q?9WiQUm3WpnkoOteXqzs9mbPIQ05FHjh0bFeZDDnwqswm4d6PQ569nhNEWmhp?=
 =?us-ascii?Q?ky5FKr6k0LEEoFSS1XeRg0EteOmlyD5aB3pmcltMQ1rp9Np08c/oV/AwUehI?=
 =?us-ascii?Q?hx8DdqY8EbIHj6qjLuP7FRInoSo3c3Wfpe0FXNv870thOPVINzUQFH7HheSd?=
 =?us-ascii?Q?OEqBvKGmQp2IY/haI/uIsQoqvzrV0JJJnKU1NHmstFk9mA8sktiGPR3QAokF?=
 =?us-ascii?Q?pk0iU7zkK4Efbj91o0mZKI65VvEUA/akh62q6SMFqsziyo/0AIP+OEXp/sR8?=
 =?us-ascii?Q?NJ+PQ6dLm3QA/7w+CTs0T/pA?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3D7170FEC53D044A94491DE4069CEF44@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4943a547-1f3a-4936-2753-08d9826a945a
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Sep 2021 10:27:31.5746
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vSyFQC5g+T2rf8x3Eo+05QnzoilVz3Qy6Y5Ykt88NSi8dWVk6Piv9SQnLS57Mn7hprfBRi1CIQGOMwaCN/dmDQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4223
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



>  drivers/net/pcs/pcs-xpcs.c | 24 ++++++++++++++++++++----
>  1 file changed, 20 insertions(+), 4 deletions(-)
>=20
> diff --git a/drivers/net/pcs/pcs-xpcs.c b/drivers/net/pcs/pcs-xpcs.c
> index da8c81d25edd..eacfb32bb229 100644
> --- a/drivers/net/pcs/pcs-xpcs.c
> +++ b/drivers/net/pcs/pcs-xpcs.c
> @@ -709,11 +709,14 @@ static int xpcs_config_aneg_c37_sgmii(struct dw_xpc=
s *xpcs, unsigned int mode)
>  	int ret;
> =20
>  	/* For AN for C37 SGMII mode, the settings are :-
> -	 * 1) VR_MII_AN_CTRL Bit(2:1)[PCS_MODE] =3D 10b (SGMII AN)
> -	 * 2) VR_MII_AN_CTRL Bit(3) [TX_CONFIG] =3D 0b (MAC side SGMII)
> +	 * 1) VR_MII_MMD_CTRL Bit(12) [AN_ENABLE] =3D 0b (Disable SGMII AN in c=
ase
> +	      it is already enabled)
> +	 * 2) VR_MII_AN_CTRL Bit(2:1)[PCS_MODE] =3D 10b (SGMII AN)
> +	 * 3) VR_MII_AN_CTRL Bit(3) [TX_CONFIG] =3D 0b (MAC side SGMII)
>  	 *    DW xPCS used with DW EQoS MAC is always MAC side SGMII.
> -	 * 3) VR_MII_DIG_CTRL1 Bit(9) [MAC_AUTO_SW] =3D 1b (Automatic
> +	 * 4) VR_MII_DIG_CTRL1 Bit(9) [MAC_AUTO_SW] =3D 1b (Automatic
>  	 *    speed/duplex mode change by HW after SGMII AN complete)
> +	 * 5) VR_MII_MMD_CTRL Bit(12) [AN_ENABLE] =3D 1b (Enable SGMII AN)
>  	 *
>  	 * Note: Since it is MAC side SGMII, there is no need to set
>  	 *	 SR_MII_AN_ADV. MAC side SGMII receives AN Tx Config from
> @@ -721,6 +724,11 @@ static int xpcs_config_aneg_c37_sgmii(struct dw_xpcs=
 *xpcs, unsigned int mode)
>  	 *	 between PHY and Link Partner. There is also no need to
>  	 *	 trigger AN restart for MAC-side SGMII.
>  	 */
> +	ret =3D xpcs_modify(xpcs, MDIO_MMD_VEND2, DW_VR_MII_MMD_CTRL, AN_CL37_E=
N,

Would you mind using "MDIO_CTRL1" instead of "DW_VR_MII_MMD_CTRL", and
"MDIO_AN_CTRL1_ENABLE" instead of "AN_CL37_EN"? After all, the
"SR_MII_CTRL" naming from the data book comes from "Standard Register".

> +			  0);
> +	if (ret < 0)
> +		return ret;
> +
>  	ret =3D xpcs_read(xpcs, MDIO_MMD_VEND2, DW_VR_MII_AN_CTRL);
>  	if (ret < 0)
>  		return ret;
> @@ -745,7 +753,15 @@ static int xpcs_config_aneg_c37_sgmii(struct dw_xpcs=
 *xpcs, unsigned int mode)
>  	else
>  		ret &=3D ~DW_VR_MII_DIG_CTRL1_MAC_AUTO_SW;
> =20
> -	return xpcs_write(xpcs, MDIO_MMD_VEND2, DW_VR_MII_DIG_CTRL1, ret);
> +	ret =3D xpcs_write(xpcs, MDIO_MMD_VEND2, DW_VR_MII_DIG_CTRL1, ret);

There is an interesting note in the data book about the MAC_AUTO_SW bit:

| This mode is valid only when DWC_xpcs is configured as MAC-side
| SGMII/USXGMII/QSGMII and should be set only when Auto-negotiation is
| enabled (AN_ENABLE bit is set to 1).

With your patch, it will be set while the AN_ENABLE bit is zero.
I wonder whether that's a poor choice of words, because it does
contradict with the sequence described in section "7.12.1 SGMII
Auto-Negotiation", and if it just means "only set MAC_AUTO_SW if you
intend to eventually set AN_ENABLE", not "you must set it only _while_
AN_ENABLE is set".

> +	if (ret < 0)
> +		return ret;
> +
> +	ret =3D xpcs_read(xpcs, MDIO_MMD_VEND2, DW_VR_MII_MMD_CTRL);
> +	if (ret < 0)
> +		return ret;
> +	ret |=3D AN_CL37_EN;

So this is the part that really confuses me.
The xpcs driver did not use to do any configuration at all for this bit.
Am I right in assuming that we were all operating with the default value?
Because in your case, the default value is set by your bootloader
(AN_CL37_EN is set), and in my case, the default is the hardware reset
(AN_CL37_EN is not set). I think (haven't tested) that this change would
actually break my setups where phylink_autoneg_inband(mode) returns false.

So could you please add this conditional?

	if (phylink_autoneg_inband(mode))
		ret |=3D MDIO_AN_CTRL1_ENABLE;
	else
		ret &=3D ~MDIO_AN_CTRL1_ENABLE;

> +	return xpcs_write(xpcs, MDIO_MMD_VEND2, DW_VR_MII_MMD_CTRL, ret);
>  }
> =20
>  static int xpcs_config_2500basex(struct dw_xpcs *xpcs)
> --=20
> 2.25.1
>=20

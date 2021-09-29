Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9C4941C54E
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 15:13:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344085AbhI2NPX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 09:15:23 -0400
Received: from mail-eopbgr10083.outbound.protection.outlook.com ([40.107.1.83]:48213
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S242801AbhI2NPW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Sep 2021 09:15:22 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SH+RfhgBjfifJz12ycCQpHbll4HhknUEaGC6hod9J3OkTNaz3lECp76j7yfsXrMb45y/7ZA+sgtecFe5n1AuH5HkH6jxIVl7sZNsrnBsazcMGobZKP8/vSThs9bF69sq1tpiFsfIy844K9eh2XedD47VJYZU2PD+cHWDVAcZHlvmK4dTaGDmPeubWNC284qcolysYdIma4ULOuyQSjBPHPmlY4huO9GHEGdwBoc5SHhnz27LbRlaAvzaLHDcoez/jFLhkOIp1MUuyotocpQaRtSlx8SpuDUZDgqjSdfpbhZ2+3LUE0Zb1u6vc6Pslh0Nd9MQ5qUV6Y3vQ/FCjdfkgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=ZgGMh6Uf4WVLZj3S7XFvc07ggDmBp0n2KcKOwlme0p8=;
 b=CAyLtncTojqk1PQmzav+ds76KqReW4vFti57bt7WYyY5PbkswpJyG1ITtuCWcND5C51MRe+N0VdjwfHkUueuOJuTA8Td7r1kAVDYLjJmcdLr3FXiBy+VCy2IdJI4Q8mw8CodoTeNG2lqEojx2G1l+MJzkq519WwGPAd+PlZbf0iDgG6v998tyCRDqLF2N6mp4s2B69+5rDFJ0sRRx0bP8ZiGlbovh2ANVM6/7idUyRh7YnTrltsz7MlhbPhjC4Zz+f0TtxmoIJYlMudvU/eLvQQme+b/OsFUGta2GeKT9HSTrTXJUlKS425i23KOn2YCJHUMAbPEwrpYJrn99m22Og==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZgGMh6Uf4WVLZj3S7XFvc07ggDmBp0n2KcKOwlme0p8=;
 b=ZF6My701i1IdhB67WkgdPLJgsm8DXmhxqtpHx4oQ3VwZ6BiQRxkpaIS92LsCk/7j4K40S6xFYIWlpwyfETB/DGZERF+iyK3V/WEmF6mTUJdwAo6iVcIeqlIprFXPeyyGQ6KZJXwotpi2v+qk2vJ5mci/6L19sivCixtUlcA9mv0=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB3839.eurprd04.prod.outlook.com (2603:10a6:803:21::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.20; Wed, 29 Sep
 2021 13:13:39 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4544.022; Wed, 29 Sep 2021
 13:13:39 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Wong Vee Khee <vee.khee.wong@linux.intel.com>
CC:     Jose Abreu <Jose.Abreu@synopsys.com>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Wong Vee Khee <veekhee@gmail.com>,
        Wong Vee Khee <vee.khee.wong@intel.com>
Subject: Re: [PATCH net v2 1/1] net: pcs: xpcs: fix incorrect CL37 AN sequence
Thread-Topic: [PATCH net v2 1/1] net: pcs: xpcs: fix incorrect CL37 AN
 sequence
Thread-Index: AQHXtSl4a239mcncK0mfav8TFg3Mn6u6/U4A
Date:   Wed, 29 Sep 2021 13:13:39 +0000
Message-ID: <20210929131338.6zppmzraznym5rsv@skbuf>
References: <20210929120534.411157-1-vee.khee.wong@linux.intel.com>
In-Reply-To: <20210929120534.411157-1-vee.khee.wong@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: linux.intel.com; dkim=none (message not signed)
 header.d=none;linux.intel.com; dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9e6ef338-bb1d-48c7-37ab-08d9834af3dd
x-ms-traffictypediagnostic: VI1PR0402MB3839:
x-microsoft-antispam-prvs: <VI1PR0402MB3839F8B4C950163EFD900AFBE0A99@VI1PR0402MB3839.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: dPl/sklC8tlkUWM/cwqbCcjCpeirJY20UXYJi4lypommqa2LghJ8z7usBBvZA8YPGRVyKxu9wTnEKY/kVitwtVDVOzsPZIPK1lDCN5SANtg7SJlOgH4jrmTK/5k/tUInwcFRAv5IcLfPYzbVVfdTkO5SGPWyBIMbB7IjMRkCwPaMLhZkWmxndkTcmTrbhMFt9J9i6QHykJSDsnlGDH7sPUSRJWpstaECM27OWXzTGzyodI727K2ZyBACPuUa7oCnZq/UWS4x3dMvV0uWxdd24NrHV69PhQ1irmEUZduIbemMUrQXyqnTSkVhHqkCHEaEwB557A76/yYBztxvwQBhj7QUfrKDAtaqZPV5KH3/K8TGu19m7PG82u2131lHlI5PI5c5YB8dQxLCd0HaUk4KwrMfszHywvIfsFlnBJqojNBR79z+JkUiU65gFfHyvA0sPpLYYvLQCnE9JR0ksK0WvEav2kYHN9Gf3ptGWf0vuNlUhmOoEQL+nac3zxG4gz3jAQK/TapkIa4POhLFYmCMKHAI9AfaUxSwTNdFo05rT9q3Pd228WFKxoSlkroX6MugHT0LAbsg7wETe3INqXJvulcowsxnVjMqgVQr6B7e6rr+aA28hn1+wxaV8o6mjsRf6HYBdvxsshZOYd7YE0ex3Apz/bKPQNBFpZ9vXSmd0fehcwMc+b5al6VrU6StT9g9zCqNaJ0cakGmfgjnt4N9Q7eooyrFtjav6agenNb2pZVudH+6lYV5MQ2sUs02CMkFwID52c12779ZdwxGGuFq6Z1DcPlsBIRk/Ejg3HlMgQ8=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(366004)(66946007)(66556008)(83380400001)(33716001)(66476007)(6506007)(44832011)(2906002)(5660300002)(186003)(6486002)(122000001)(508600001)(26005)(6512007)(1076003)(9686003)(38100700002)(71200400001)(966005)(38070700005)(54906003)(66446008)(8676002)(4326008)(91956017)(76116006)(6916009)(8936002)(316002)(7416002)(64756008)(86362001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?8fl6LCxITtQ5vVBRuXOZm8GsJGYPahk8yTpIXPqzSMkfaxDeqCKI8W7fe+ak?=
 =?us-ascii?Q?ns0drIQB1jsoK3lfTCT1NEQSnKkcSxfzGPuJMldy6IXX2jshIa9HUngLue55?=
 =?us-ascii?Q?nh/ex4iRJlcghQKf34r35P69vNJB2/3otb65AQiMkr79p48K4tFDhB/9aolC?=
 =?us-ascii?Q?HLXzek6pP4sudaOLcgXzEsevOLQ+ZFQ6kv4LeB+P4QtAR7f9AB+tlbW11nd/?=
 =?us-ascii?Q?kfq6u7N5QgWCU6oq+mZqJ+cMESuHI349YRfWcJbeopRqjqTryqRkK1VUmmlm?=
 =?us-ascii?Q?tW+ZUlp4X3WN4vLra7AF+Vr6l8eX4NFlK+NAEZ2v0cYAUf+kOHQs58Z60gzj?=
 =?us-ascii?Q?T26+xMFYznY/oBfmLluokVIHrFa7nDOc5yUMiKEDBBVoF7RjV8ki7K5dEY6k?=
 =?us-ascii?Q?92ZomdCBRjKre0ZZby+iLlve4aQ02nO6x1QN4DMxDwCqMKv+ZREsiTKOkr4U?=
 =?us-ascii?Q?nqgpP3cDeAzqUZb63udeGZDjAoa1FMK3U+nZ178pQ9k27yFC03UKnlau1S7Q?=
 =?us-ascii?Q?Ep+9BU0zkgwlv4CgZdGzoIPrfX6PR6MXPebJRcqz6DHkXZafVZbi+IlysV/1?=
 =?us-ascii?Q?U9QvLpvPwXc3sK3r8wfv3mSNw2m1ZVSPFNh41LF2Qo+hqnafF5OaKPiWcxik?=
 =?us-ascii?Q?/Dkr7pnkqfZp0RBdQyncLinxWbckxEfw3Mje32rMFyoWklUyiuNTd5HIBzMw?=
 =?us-ascii?Q?lrdo5dIiPjUA6MycX5ZU0KFiUY679nSRWgA7v+31bBVA0sAgIv9/3JiKUPIQ?=
 =?us-ascii?Q?1QVDuVXcr0I5vX4B0yMeND7BMq5fD29qHqydNxyyQWC6fOvPTG9JvCsBodp0?=
 =?us-ascii?Q?Bawgqs0VZ/Ln+DphICoKFqOaGBPNJ+w2BRtqyp1lat0imBz4nu61oTYnGVmg?=
 =?us-ascii?Q?SspGtEY38Aks5LJHBgkHfYY7soaTRIGLRbP6fCsFAswdYUB6m73kzH5laFj/?=
 =?us-ascii?Q?DHOXRTm/Mydky4hDub+RspQj4NXpRRnoMx2+hqQYQ2GlWQ5dlOaS5MEl70vF?=
 =?us-ascii?Q?dxyfNgA0ABbYJ9q6O4Yp3GvH1k+2NcdC0GrqwkgWYa6iSXZ1OpsQG1+J5rjq?=
 =?us-ascii?Q?bTF1PplhsM35NO9iJNqLZlMdlA5I4vcIi5X6JRhP+forqiis3ijGOpbHp1hI?=
 =?us-ascii?Q?hK65RJe86uqgclDT+uOi1nA+U/QbdsW5oCsqTRzmeIm9zw4v8DFX/2vDuaTG?=
 =?us-ascii?Q?cq9WrWeYWypdN+AtEeAcKH2QyzQKVTRsLEbd+zJU0QICuBAeGRB7SEjzj7hZ?=
 =?us-ascii?Q?MI4eZHylg2LMqv+jQtTAIkoOYTY7bHvw+4Z/zgQanKALiVJw1KaoOy4p2gSS?=
 =?us-ascii?Q?bcblVxNLLZsuYe2fnL8E7oA2?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <F70B8BBEE5975D49B06DE4CC4A79515A@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9e6ef338-bb1d-48c7-37ab-08d9834af3dd
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Sep 2021 13:13:39.1255
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cCN2yRp8IuRsviBgIfk7X3Sq9FenHJyTogsm497Jz+spiXF1+djUhqYcY9syz9EVl1hUNwJATeOS/nsS5GUnMw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3839
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 29, 2021 at 08:05:34PM +0800, Wong Vee Khee wrote:
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

netdev/fixes_present 	fail 	Series targets non-next tree, but doesn't conta=
in any Fixes tags
https://patchwork.kernel.org/project/netdevbpf/patch/20210929120534.411157-=
1-vee.khee.wong@linux.intel.com/

> v1 -> v2:
>  - Removed use of xpcs_modify() helper function.
>  - Add conditional check on inband auto-negotiation.
>=20
>  drivers/net/pcs/pcs-xpcs.c | 30 ++++++++++++++++++++++++++----
>  1 file changed, 26 insertions(+), 4 deletions(-)
>=20
> diff --git a/drivers/net/pcs/pcs-xpcs.c b/drivers/net/pcs/pcs-xpcs.c
> index fb0a83dc09ac..f34d5caeaba1 100644
> --- a/drivers/net/pcs/pcs-xpcs.c
> +++ b/drivers/net/pcs/pcs-xpcs.c
> @@ -700,11 +700,14 @@ static int xpcs_config_aneg_c37_sgmii(struct dw_xpc=
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
> @@ -712,6 +715,12 @@ static int xpcs_config_aneg_c37_sgmii(struct dw_xpcs=
 *xpcs, unsigned int mode)
>  	 *	 between PHY and Link Partner. There is also no need to
>  	 *	 trigger AN restart for MAC-side SGMII.
>  	 */
> +	ret =3D xpcs_read(xpcs, MDIO_MMD_VEND2, DW_VR_MII_MMD_CTRL);
> +	if (ret < 0)
> +		return ret;
> +	ret &=3D ~AN_CL37_EN;
> +	xpcs_write(xpcs, MDIO_MMD_VEND2, DW_VR_MII_MMD_CTRL, ret);

For consistency can you please check the return code from this xpcs_write t=
oo?

> +
>  	ret =3D xpcs_read(xpcs, MDIO_MMD_VEND2, DW_VR_MII_AN_CTRL);
>  	if (ret < 0)
>  		return ret;
> @@ -736,7 +745,20 @@ static int xpcs_config_aneg_c37_sgmii(struct dw_xpcs=
 *xpcs, unsigned int mode)
>  	else
>  		ret &=3D ~DW_VR_MII_DIG_CTRL1_MAC_AUTO_SW;
> =20
> -	return xpcs_write(xpcs, MDIO_MMD_VEND2, DW_VR_MII_DIG_CTRL1, ret);
> +	ret =3D xpcs_write(xpcs, MDIO_MMD_VEND2, DW_VR_MII_DIG_CTRL1, ret);
> +	if (ret < 0)
> +		return ret;
> +
> +	ret =3D xpcs_read(xpcs, MDIO_MMD_VEND2, DW_VR_MII_MMD_CTRL);
> +	if (ret < 0)
> +		return ret;
> +
> +	if (phylink_autoneg_inband(mode))
> +		ret |=3D AN_CL37_EN;
> +	else
> +		ret &=3D ~AN_CL37_EN;
> +
> +	return xpcs_write(xpcs, MDIO_MMD_VEND2, DW_VR_MII_MMD_CTRL, ret);

Not sure whether this is too much for "net" or not, but I suppose it is
pretty much relevant.

Clearing AN_CL37_EN during the first step is only necessary if it was
set in the first place. Otherwise, you could do only the xpcs_read but
not the xpcs_write.

At the end, you don't really need to read DW_VR_MII_MMD_CTRL again, you
just read it above, didn't you, can't you save it in a local variable?

And you only need to perform the write if the state of the AN_CL37_EN
bit changed, i.e. it was 0 before, and is now 1.

What I'm trying to say is that for the sja1105 driver, the XPCS is
accessed over SPI commands, and I would like for the number of those to
be minimized if possible. Thanks.

I've tested the change and it still works, by the way. I will add the
appropriate tags when you resend the v3.

>  }
> =20
>  static int xpcs_config_2500basex(struct dw_xpcs *xpcs)
> --=20
> 2.25.1
> =

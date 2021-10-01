Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D7DC41E57D
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 02:19:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351137AbhJAAVj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 20:21:39 -0400
Received: from mail-eopbgr140084.outbound.protection.outlook.com ([40.107.14.84]:22755
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1348319AbhJAAVi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Sep 2021 20:21:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WQE0y1veRbLszgITDhRLixtI+DA4V2eXqyX4m/+nW1Byymv8R0aOK+MK1HpqghLRglbRCFcNTd1sQJnb5jKcrccI90avr/4adI9+uBB2QEWUsXIob/scgM4sAzr7spW0X195K/ZouUP9MtXY9IbbSr8Z3XAvqF5QW37gjsfRnOUwSnTZVsNNAqoA2k1yB2iBJwFLGD65SoRRg6t0n7KsgzHplvLilpSMWs/Bweb80EAzrhMOixvCbE8TZVjitLmhGlEtngNvqwbm2W5MS511kt9Cv8u4YKqtJ7OQTy2/pW8bryV/K7GdyjrApQm1EfKbeYdbULY4PO5kzEvlIcGlaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=A5pdub+alIjScpvvrqS72d5PMpmti39kGVTOi/Mcaik=;
 b=jsuXoL/hmZnaAYN/q5EP2uDWns9NUCNekwdF02xWQyZ+3wNjDD8s8zNpBzkm5Cb+kZ+XAiry30SLSqg9HrG5aNGUy4cKgu771OSJwV1sKnlv2eoD6wPZh69lBBytdc66Yn9U/EZp8A9pbiwbj0Y/MsI+jgwe+TOzS20GjO0W+ZIp015oIcUOvW1QA22s8D5tMcWQ+xiGiolvx57rZqfl4Hy3j/ApbFSWDXBN8CzOXVnY67+4RqCtdIarimiL5GcAoYE4hZNZtcpFzu+c0xkSw4lt9pXgS5SW73hwgh+VRodvyR25Jgh6M7VliY5YW+iw9vjMyv8XPG2cbY4x2X5hEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A5pdub+alIjScpvvrqS72d5PMpmti39kGVTOi/Mcaik=;
 b=fje0Fnyn4MDYZaXVVGIIYRmbHV0qZ+TyLM8St6z5d8EaRDeEaaIg2ISSRUlt7FQVlUBWlEe+zqqmHrltPF1OCClTAyosoj/8kdlyWQXXtOWWSwY9FZfhYPQ7zH1AfUcSF9LP2TbE1xoEMQ8zAZeaOZIMoiG4KRZEqhml8labpWM=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VE1PR04MB7343.eurprd04.prod.outlook.com (2603:10a6:800:1a2::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.21; Fri, 1 Oct
 2021 00:19:52 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4544.025; Fri, 1 Oct 2021
 00:19:52 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
CC:     Wong Vee Khee <vee.khee.wong@linux.intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Wong Vee Khee <veekhee@gmail.com>
Subject: Re: [PATCH net v3 1/1] net: pcs: xpcs: fix incorrect CL37 AN sequence
Thread-Topic: [PATCH net v3 1/1] net: pcs: xpcs: fix incorrect CL37 AN
 sequence
Thread-Index: AQHXtbUKKyhIRXal/0mOmtJkI1WPdqu8TpGAgAD6HoA=
Date:   Fri, 1 Oct 2021 00:19:52 +0000
Message-ID: <20211001001951.erebmghjsewuk3lh@skbuf>
References: <20210930044421.1309538-1-vee.khee.wong@linux.intel.com>
 <YVWCV1Vaq5SAJflX@shell.armlinux.org.uk>
In-Reply-To: <YVWCV1Vaq5SAJflX@shell.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: armlinux.org.uk; dkim=none (message not signed)
 header.d=none;armlinux.org.uk; dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c33a2552-1a53-4f6a-734d-08d98471300f
x-ms-traffictypediagnostic: VE1PR04MB7343:
x-microsoft-antispam-prvs: <VE1PR04MB73438DA0AF354C5379C123D9E0AB9@VE1PR04MB7343.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: T7+906GJjVpbMZak++FTmRlBAcFpWgvxokTxrqD7k0pTrM/eG2h+ZERrQhJ/6LlmwCKhd7EYmeQQgmYBnV3x2nPs7NgRtir9QBGGjgK4SEQbXhiMfZ41DzSzUYCPb8Q8v9vXyV9z2hjQVNeiVtvSpZhP3t2fFZmI8EB1PCG4ypWmKD6BjojTTfm62aaJnTADIhMlNlO5/SHm2kJsPahFldtgvoxoJoxg8aIvTR3Y79I1M7z7Ys4G9NnTdIKCO7jLwPKAjmSWJlagZ4VeSK09fqu9ZfbgH3r/yXFs6bjm2Rc8bNv8xY8yl3PB4YYw/okHo+moG3QsmA4jRbDvONalWMbQQT7oRZLntk3mynoNv1CYL6ppRT4iJnP/f03IBsiHb1PJ5/2zpOsO1yv+WKLGvJcYAFIYK6nBD6RSrJExvncJ7mkdA7/QBSAb2JjQd0qcqlMFEnC4b0BRShWE41/Us/1DyLD3FB0OsnSi13kPDVackpa5N0xO7urEdobSkEUpGkgV5msGURk9oa9Zw8Xilfg3s3Ys7MDQw+wxZaWBk1oxtuvmRdFTtpoqfCzYktvz2N0zeJ2Bqfy/duoD4nbFJ8NL45AuEvUeYLQjsuod8B8C+cB4e219dmy5wBjqCF8H3bj2hha6DBIMIrVMipm++kfh8qrypWCSQMSmKIMRPOmSpW1ZzMmHMtEzvZo5o5f3obD/wdNo7mfQKZG7G2P+qA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(366004)(86362001)(122000001)(66556008)(6486002)(8676002)(83380400001)(44832011)(5660300002)(26005)(8936002)(6506007)(38100700002)(6916009)(33716001)(7416002)(6512007)(66946007)(38070700005)(66476007)(9686003)(54906003)(66446008)(186003)(71200400001)(316002)(2906002)(1076003)(508600001)(91956017)(64756008)(4326008)(76116006);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?OPfQC/rKdSLreXawf78I6j8/SQ75qBwpVSK91zKgoqgrnODMVldGN3j/CjIT?=
 =?us-ascii?Q?EwCwWLV4/6YGgB0VY4wxnPTpVjf9RZz82sNoUU+5IXrRCyWdzHeV8g85twIw?=
 =?us-ascii?Q?38oAhZsgm47oeH2VOYiXta4fa8Kn+HCTUy4W/TiN/bi1hvNY/jfRX10mpkYu?=
 =?us-ascii?Q?BYLnRdrUoHdXRsEhaJWqp8GFSpbLA1T3JOWLpkcTZZze92CbNP/qEjSRKI38?=
 =?us-ascii?Q?8ah7JfzNH3Bnn3UajBMn98VyU3ZCrj9W93H/7HUrRczkywA/NhCR/yYMOi7A?=
 =?us-ascii?Q?CUE3A5fz5S/RgNKZtPZRVhATvXeKAZtF5zZmx/uU3a0vjI/7DMOksXAP9icD?=
 =?us-ascii?Q?MKr6NH4A5AGj9fIwDeGI8hQxxVnUTPLI8P4FuH7OMQ/XQFv0urV9SjRjqHKX?=
 =?us-ascii?Q?aiG6CvsPuQ8iejDp/vbBC8TTfAPpVBCTSAnRDzisyclk8zdixb7viQLW95GQ?=
 =?us-ascii?Q?0fgkySCIjd3IKTrC7D4FJywxCKJnP02pU7ULnEOm6bC6GNhJUhLtoMPqG6zg?=
 =?us-ascii?Q?OmG1t2IcgBciXZYu0k3j9TcJUVQ7zfnfBe1mYAHZ/H+XCYP3Y6aGJqcdlRbu?=
 =?us-ascii?Q?KZSnwFykK84NybRDa/xLpvLpIlEPuS2r3TNZhAAQovSKRKP//tqKc2T+jxgo?=
 =?us-ascii?Q?nyu+jQBhSBzrFB6AJ1jmkcTwtpHNPJ7KLhEdJ1ZfkMq5MlNon8mMzAGmVMw5?=
 =?us-ascii?Q?fEXv6OUWarsoCBbVmY7+Oakda2XqucPb1CE6FCMX06b/QzLc+JBlU2PPcYnz?=
 =?us-ascii?Q?ptYLd/VpPH1pFJUWE9tIv6ZmYWNL6OojJV7YbsL0TMCZgRn72+PMdwPqqTAY?=
 =?us-ascii?Q?wmJo2HF6jz7eEqGHmA5/QufJPpZp/MawbXgxoXndp+pWG8cLy1hR1wyVwYIm?=
 =?us-ascii?Q?ScIi26RQPLlXvDLBTMo2YKRuj3hjdVmWbFLKiW06ev1RSeoKu+0IbzagDsdi?=
 =?us-ascii?Q?OXTLkc6NWtZXmkv3tGWmDPoKe0lWfdSxPo2dLWsUGm+Ql7Ypwuvl0ZRyBQ86?=
 =?us-ascii?Q?u3gGwG7fdMxRaQbhFMFiu/D0+i1rBrS+U+Z45+kNPoHNhAF9ORvioynha7G2?=
 =?us-ascii?Q?aWMJQJ/4v2utjA8BQFc25Snr43/Im4k31eVIkTxcKDmHMD5Bv0BcC16Las8Z?=
 =?us-ascii?Q?vpoywdBpg04dYKwMnwQC3iGT97InQprPRuZYYwiXtsuYM/j4j8RHdhW/fZT8?=
 =?us-ascii?Q?UQwVrRf8FHeXrXUgVPDo3kTkosiRKkUUNy02fdLHiUHDzRlPhZFLnC3WVTcA?=
 =?us-ascii?Q?0astoPt2fdg9tvQKMa532wsh+ky70p5zpSijbRSodJS2XEWtZNGZ0dngKoKA?=
 =?us-ascii?Q?xPooKdhL+7LAF0jIGzC6SGBi?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3FD29DC988C90C4492096D43026192AF@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c33a2552-1a53-4f6a-734d-08d98471300f
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Oct 2021 00:19:52.0716
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FotauQTc0uQ7ZjphTlPRC9wxRG2wC+/8F+9+SFvNTPSUG/rZ+0VM/80YWSfK8gWkOJlk8KYggKjteRz4hkqplQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7343
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 30, 2021 at 10:24:39AM +0100, Russell King (Oracle) wrote:
> On Thu, Sep 30, 2021 at 12:44:21PM +0800, Wong Vee Khee wrote:
> > According to Synopsys DesignWare Cores Ethernet PCS databook, it is
> > required to disable Clause 37 auto-negotiation by programming bit-12
> > (AN_ENABLE) to 0 if it is already enabled, before programming various
> > fields of VR_MII_AN_CTRL registers.
> >=20
> > After all these programming are done, it is then required to enable
> > Clause 37 auto-negotiation by programming bit-12 (AN_ENABLE) to 1.
> >=20
> > Fixes: b97b5331b8ab ("net: pcs: add C37 SGMII AN support for intel mGbE=
 controller")
> > Cc: Vladimir Oltean <vladimir.oltean@nxp.com>
> > Signed-off-by: Wong Vee Khee <vee.khee.wong@linux.intel.com>
> > ---
> > v2 -> v3:
> >  - Added error handling after xpcs_write().
> >  - Added 'changed' flag.
> >  - Added fixes tag.
> > v1 -> v2:
> >  - Removed use of xpcs_modify() helper function.
> >  - Add conditional check on inband auto-negotiation.
> > ---
> >  drivers/net/pcs/pcs-xpcs.c | 41 +++++++++++++++++++++++++++++++++-----
> >  1 file changed, 36 insertions(+), 5 deletions(-)
> >=20
> > diff --git a/drivers/net/pcs/pcs-xpcs.c b/drivers/net/pcs/pcs-xpcs.c
> > index fb0a83dc09ac..d2126f5d5016 100644
> > --- a/drivers/net/pcs/pcs-xpcs.c
> > +++ b/drivers/net/pcs/pcs-xpcs.c
> > @@ -697,14 +697,18 @@ EXPORT_SYMBOL_GPL(xpcs_config_eee);
> > =20
> >  static int xpcs_config_aneg_c37_sgmii(struct dw_xpcs *xpcs, unsigned i=
nt mode)
> >  {
> > -	int ret;
> > +	int ret, reg_val;
> > +	int changed =3D 0;
> > =20
> >  	/* For AN for C37 SGMII mode, the settings are :-
> > -	 * 1) VR_MII_AN_CTRL Bit(2:1)[PCS_MODE] =3D 10b (SGMII AN)
> > -	 * 2) VR_MII_AN_CTRL Bit(3) [TX_CONFIG] =3D 0b (MAC side SGMII)
> > +	 * 1) VR_MII_MMD_CTRL Bit(12) [AN_ENABLE] =3D 0b (Disable SGMII AN in=
 case
> > +	      it is already enabled)
> > +	 * 2) VR_MII_AN_CTRL Bit(2:1)[PCS_MODE] =3D 10b (SGMII AN)
> > +	 * 3) VR_MII_AN_CTRL Bit(3) [TX_CONFIG] =3D 0b (MAC side SGMII)
> >  	 *    DW xPCS used with DW EQoS MAC is always MAC side SGMII.
> > -	 * 3) VR_MII_DIG_CTRL1 Bit(9) [MAC_AUTO_SW] =3D 1b (Automatic
> > +	 * 4) VR_MII_DIG_CTRL1 Bit(9) [MAC_AUTO_SW] =3D 1b (Automatic
> >  	 *    speed/duplex mode change by HW after SGMII AN complete)
> > +	 * 5) VR_MII_MMD_CTRL Bit(12) [AN_ENABLE] =3D 1b (Enable SGMII AN)
> >  	 *
> >  	 * Note: Since it is MAC side SGMII, there is no need to set
> >  	 *	 SR_MII_AN_ADV. MAC side SGMII receives AN Tx Config from
> > @@ -712,6 +716,19 @@ static int xpcs_config_aneg_c37_sgmii(struct dw_xp=
cs *xpcs, unsigned int mode)
> >  	 *	 between PHY and Link Partner. There is also no need to
> >  	 *	 trigger AN restart for MAC-side SGMII.
> >  	 */
> > +	ret =3D xpcs_read(xpcs, MDIO_MMD_VEND2, DW_VR_MII_MMD_CTRL);
> > +	if (ret < 0)
> > +		return ret;
> > +
> > +	if (ret & AN_CL37_EN) {
> > +		changed =3D 1;
> > +		reg_val =3D ret & ~AN_CL37_EN;
> > +		ret =3D xpcs_write(xpcs, MDIO_MMD_VEND2, DW_VR_MII_MMD_CTRL,
> > +				 reg_val);
> > +		if (ret < 0)
> > +			return ret;
> > +	}
>=20
> I don't think you need to record "changed" here - just maintain a
> local copy of the current state of the register, e.g:
>=20
> +	ret =3D xpcs_read(xpcs, MDIO_MMD_VEND2, DW_VR_MII_MMD_CTRL);
> +	if (ret < 0)
> +		return ret;
> +
> +	reg_val =3D ret;
> +	if (reg_val & AN_CL37_EN) {
> +		reg_val &=3D ~AN_CL37_EN;
> ...
>=20
> What you're wanting to do is ensure this bit is clear before you do the
> register changes, and once complete, set the bit back to one. If the bit
> was previously clear, you can omit this write, otherwise the write was
> needed - as you have the code. However, the point is that once you're
> past this code, the state of the register in the device will have the
> AN_CL37_EN clear. See below for the rest of my comments on this...

VK, I don't want to force you towards a certain implementation, but I
just want to throw this out there, this works for me, and doesn't do
more reads or writes than strictly necessary, and it also breaks up the
wall-of-text comment into more digestible pieces:

static int xpcs_config_aneg_c37_sgmii(struct dw_xpcs *xpcs, unsigned int mo=
de)
{
	int ret, mdio_ctrl1, old_an_ctrl, an_ctrl, old_dig_ctrl1, dig_ctrl1;

	/* Disable SGMII AN in case it is already enabled */
	mdio_ctrl1 =3D xpcs_read(xpcs, MDIO_MMD_VEND2, DW_VR_MII_MMD_CTRL);
	if (mdio_ctrl1 < 0)
		return mdio_ctrl1;

	if (mdio_ctrl1 & AN_CL37_EN) {
		ret =3D xpcs_write(xpcs, MDIO_MMD_VEND2, DW_VR_MII_MMD_CTRL,
				 mdio_ctrl1 & ~AN_CL37_EN);
		if (ret < 0)
			return ret;
	}

	/* Set VR_MII_AN_CTRL[PCS_MODE] to SGMII AN, and
	 * VR_MII_AN_CTRL[TX_CONFIG] to MAC side SGMII.
	 */
	old_an_ctrl =3D xpcs_read(xpcs, MDIO_MMD_VEND2, DW_VR_MII_AN_CTRL);
	if (old_an_ctrl < 0)
		return old_an_ctrl;

	an_ctrl =3D old_an_ctrl & ~(DW_VR_MII_PCS_MODE_MASK | DW_VR_MII_TX_CONFIG_=
MASK);
	an_ctrl |=3D (DW_VR_MII_PCS_MODE_C37_SGMII << DW_VR_MII_AN_CTRL_PCS_MODE_S=
HIFT) &
		   DW_VR_MII_PCS_MODE_MASK;
	an_ctrl |=3D (DW_VR_MII_TX_CONFIG_MAC_SIDE_SGMII << DW_VR_MII_AN_CTRL_TX_C=
ONFIG_SHIFT) &
		   DW_VR_MII_TX_CONFIG_MASK;

	if (an_ctrl !=3D old_an_ctrl) {
		ret =3D xpcs_write(xpcs, MDIO_MMD_VEND2, DW_VR_MII_AN_CTRL, an_ctrl);
		if (ret < 0)
			return ret;
	}

	/* If using in-band autoneg, enable automatic speed/duplex mode change
	 * by HW after SGMII AN complete.
	 * 5) VR_MII_MMD_CTRL Bit(12) [AN_ENABLE] =3D 1b (Enable SGMII AN)
	 */
	old_dig_ctrl1 =3D xpcs_read(xpcs, MDIO_MMD_VEND2, DW_VR_MII_DIG_CTRL1);
	if (old_dig_ctrl1 < 0)
		return old_dig_ctrl1;

	if (phylink_autoneg_inband(mode))
		dig_ctrl1 =3D old_dig_ctrl1 | DW_VR_MII_DIG_CTRL1_MAC_AUTO_SW;
	else
		dig_ctrl1 =3D old_dig_ctrl1 & ~DW_VR_MII_DIG_CTRL1_MAC_AUTO_SW;

	if (dig_ctrl1 !=3D old_dig_ctrl1) {
		ret =3D xpcs_write(xpcs, MDIO_MMD_VEND2, DW_VR_MII_DIG_CTRL1, dig_ctrl1);
		if (ret < 0)
			return ret;
	}

	if (!(mdio_ctrl1 & AN_CL37_EN) && phylink_autoneg_inband(mode)) {
		ret =3D xpcs_write(xpcs, MDIO_MMD_VEND2, DW_VR_MII_MMD_CTRL,
				 mdio_ctrl1 | AN_CL37_EN);
		if (ret)
			return ret;
	}

	/* Note: Since it is MAC side SGMII, there is no need to set
	 * SR_MII_AN_ADV. MAC side SGMII receives AN Tx Config from PHY about
	 * the link state change after C28 AN is completed between PHY and Link
	 * Partner. There is also no need to trigger AN restart for MAC-side
	 * SGMII.
	 */

	return 0;
}

>=20
> > @@ -736,7 +753,21 @@ static int xpcs_config_aneg_c37_sgmii(struct dw_xp=
cs *xpcs, unsigned int mode)
> >  	else
> >  		ret &=3D ~DW_VR_MII_DIG_CTRL1_MAC_AUTO_SW;
> > =20
> > -	return xpcs_write(xpcs, MDIO_MMD_VEND2, DW_VR_MII_DIG_CTRL1, ret);
> > +	ret =3D xpcs_write(xpcs, MDIO_MMD_VEND2, DW_VR_MII_DIG_CTRL1, ret);
> > +	if (ret < 0)
> > +		return ret;
> > +
> > +	if (changed) {
> > +		if (phylink_autoneg_inband(mode))
> > +			reg_val |=3D AN_CL37_EN;
> > +		else
> > +			reg_val &=3D ~AN_CL37_EN;
> > +
> > +		return xpcs_write(xpcs, MDIO_MMD_VEND2, DW_VR_MII_MMD_CTRL,
> > +				  reg_val);
> > +	}
>=20
> As I say above, here, you are _guaranteed_ that the AN_CL27_EN bit is
> clear in the register due to the effects of your change above. You say
> in the commit text:
>=20
>   After all these programming are done, it is then required to enable
>   Clause 37 auto-negotiation by programming bit-12 (AN_ENABLE) to 1.
>=20
> So that makes me think that you _always_ need to write back a value
> with AN_CL27_EN set. So:
>=20
> 	reg_val |=3D AN_CL37_EN;
> 	return xpcs_write(xpcs, MDIO_MMD_VEND2, DW_VR_MII_MMD_CTRL, reg_val);

I will only say this: modifying the last part of the function I posted
above like this:

//	if (!(mdio_ctrl1 & AN_CL37_EN) && phylink_autoneg_inband(mode)) {
		ret =3D xpcs_write(xpcs, MDIO_MMD_VEND2, DW_VR_MII_MMD_CTRL,
				 mdio_ctrl1 | AN_CL37_EN);
		if (ret)
			return ret;
//	}

aka unconditionally writing an mdio_ctrl1 value with the AN_CL37_EN bit set=
,
will still end up with a functional link. But the only reason for that
is this:

static void xpcs_link_up_sgmii(struct dw_xpcs *xpcs, unsigned int mode,
			       int speed, int duplex)
{
	int val, ret;

	if (phylink_autoneg_inband(mode))
		return;

	switch (speed) {
	case SPEED_1000:
		val =3D BMCR_SPEED1000;
		break;
	case SPEED_100:
		val =3D BMCR_SPEED100;
		break;
	case SPEED_10:
		val =3D BMCR_SPEED10;
		break;
	default:
		return;
	}

	if (duplex =3D=3D DUPLEX_FULL)
		val |=3D BMCR_FULLDPLX;

	ret =3D xpcs_write(xpcs, MDIO_MMD_VEND2, MDIO_CTRL1, val);   <- this clear=
s the AN_CL37_EN bit again
	if (ret)
		pr_err("%s: xpcs_write returned %pe\n", __func__, ERR_PTR(ret));
}

If I add "val |=3D AN_CL37_EN;" before the xpcs_write in xpcs_link_up_sgmii=
(),
my SGMII link with in-band autoneg turned off breaks.

> If that is not correct, the commit message is misleading and needs
> fixing.
>=20
> Lastly, I would recommend a much better name for this variable rather
> than the bland "reg_val" since you're needing the value preserved over
> a chunk of code. "ctrl" maybe?=

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 901093F1CC7
	for <lists+netdev@lfdr.de>; Thu, 19 Aug 2021 17:29:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239863AbhHSPa3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Aug 2021 11:30:29 -0400
Received: from mail-eopbgr30072.outbound.protection.outlook.com ([40.107.3.72]:49998
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232821AbhHSPa1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Aug 2021 11:30:27 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BMMqck00KRrq9PcIKvtwVddTKIkLpiIW3VfwVVXu4caozY5O9pD/YOwTqOmD4KfgyEsdpABdhiibFEx54e9wE431x0mhWbHYajbkFs/Zl22j0EGoboNpNmKFxE+uwwDB1GV1LAUegXZFPchbW1HqWsG3QrszV712DsOzxRGOXB437XQtzdMzA4rTXUWhC1NKvZ87jSnyJEkz9tES3I9C8ZbydqkicPKA0zhE6ubyq4d/nc2PIOI9cTgsCB+9k9kIJmLyBu6CIlii73qD178AzLt3z6LeXeS95/pecSvTxe40dSi51Jr8UcbcpcYRLu2wJfSmOc/eTrH20OGvXKrzAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6KFzLA8GKO2Nj07E+qdNteFWPcUL2hNmP6M0V5zzSU8=;
 b=UEDlPTfGVuSanMdQePr8T3L6PV2gEaObfljS5Jd8c13kKlKeM5yh00G+5eI7GvVmJKPjjFjJxxpaYR+hsFfO/uWqyDYcj0MtgB0guuHSp5oWeKndBRN13JbfD48pQB7kceM/biUneN1pcdx4SByhIGTmTNhO3B8mKngbs91vhuUaw7bm1+sSN66EIK+9bEyjWcIMRXUSqqw0hecJXVEijehm4dTkE3o4sEPIWk2EwAkgG9HmA74/s1ykSG5dTDBbxjJZs9E6+ozHiwv7gSNW09oZtdos6CZRzVj/+W0ab91aG/rThCbmg7w70YCgN1aG99ksUVXmumMuEdz6FPPMfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6KFzLA8GKO2Nj07E+qdNteFWPcUL2hNmP6M0V5zzSU8=;
 b=NZh7NOpcTgxEwC0cWAyWl2Ay0Zf66OdjThCpcU/MPiFjIfleO2PbPvn3uAAcciVGI7jntJ46yA1UNRRskYqjh7U1Cvbcq4iQxLbskHFc5vLLMBKXz5e6KCPmUF03p0kEAPuptDQwLpa50T7gZKaXchYakJHUiKpiftkZrKk8dhY=
Received: from AM4PR0401MB2308.eurprd04.prod.outlook.com
 (2603:10a6:200:4f::13) by AM9PR04MB8193.eurprd04.prod.outlook.com
 (2603:10a6:20b:3ea::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19; Thu, 19 Aug
 2021 15:29:49 +0000
Received: from AM4PR0401MB2308.eurprd04.prod.outlook.com
 ([fe80::99d8:bc8c:537a:2601]) by AM4PR0401MB2308.eurprd04.prod.outlook.com
 ([fe80::99d8:bc8c:537a:2601%3]) with mapi id 15.20.4415.024; Thu, 19 Aug 2021
 15:29:49 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH net] net: dpaa2-switch: disable the control interface on
 error path
Thread-Topic: [PATCH net] net: dpaa2-switch: disable the control interface on
 error path
Thread-Index: AQHXlQUJxDaRKHSmlkC0nko/f8H/jat69AuA
Date:   Thu, 19 Aug 2021 15:29:49 +0000
Message-ID: <20210819152947.cnx3vyueud6rfupn@skbuf>
References: <20210819141755.1931423-1-vladimir.oltean@nxp.com>
In-Reply-To: <20210819141755.1931423-1-vladimir.oltean@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8af59689-9e30-4016-37f0-08d963262ed7
x-ms-traffictypediagnostic: AM9PR04MB8193:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM9PR04MB81937F08BE8E7F8B5F66F4D6E0C09@AM9PR04MB8193.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Bj28LuS4RqXO0A0ZlmFGgrPyE0XMaNVRguI29Ytu6/+PQRpYleNM5VYmHt4/H/UToZx4keHdcpPil/V0HbZW7yH4bePdwluPF2mGeT5c98O37JaNaTzpQe86VQ0LSX2BY6PHm/yd2BngqlDDHZHESrCQG9ZmPs2vsopsTAIEIfxabQAMg9xZ87VYMdGVkhBwQzvZxCfbqtIqQl6IOAyiITJtJr5keNk1t20UxlKLejwxn6cjuoDV4EPgTgoXjMAmwVgj5RhlydCnr3NIAwth9HmM7YaYUGE7RHjyo93WR7d34ltnPDGFCYwKZNBOrChvx4m1zw0OxhY3EyMZ3xkBgkXg3MViLsXaVcGMOEPY3KLAHf43j/choAXIgz/22g+L3/F3Fbv9xtdPQs05FDyDMz4TgWzNijSaGvnm/uEl2J+oLkwP2TCClJwJt6+Bp2AXEYYFKoqPQ8g/UIehrnxcL5r1deoh6mjw/CQMa9aYmxr+AL4en/rdHMwUjRTGir96DyIuJOzDcBJoQKQqRBVm0wH28MoyvcGE4NwjeXaOLd65FU7vAhgLB1ThVC2EUO1zBoglo6meB10DneUEd9B7PrWaN7AbdQ/qY4tsgIwkuZZ1WlkIFvbY0nSaVcFLtSlG+OWigIMm+IBYqkz+drYt5dY6a4emoGviCEAHgq4rNOUD4G6DrZP+onCOx9csGJlK4cVQv/VJbn25U/zXDJBdiw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM4PR0401MB2308.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(39860400002)(396003)(346002)(136003)(366004)(376002)(478600001)(66556008)(66476007)(8676002)(76116006)(186003)(2906002)(26005)(66946007)(54906003)(9686003)(6506007)(6636002)(71200400001)(38070700005)(66446008)(5660300002)(33716001)(83380400001)(122000001)(38100700002)(6512007)(44832011)(64756008)(6486002)(316002)(1076003)(6862004)(86362001)(8936002)(4326008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?FddKn1LX2Py7icnpsnA00Un3Av8rJFiPE4EyinGeuRJKUmRyIXogp75msq+w?=
 =?us-ascii?Q?lwLZbYTtauly7uwHaXX4yEQf9USM6YK5RuJ/uXfW2ILHSXMhXxOS2TuQfElS?=
 =?us-ascii?Q?D+wNIfjDR52A/AGzbmiW4NxL055I4jqhcwr7G3b6/TmEkrt+bYzUMXKiPX9U?=
 =?us-ascii?Q?GwWqz9XvwHrTI56Zp72x28+Ck1du4Npgx+Y+To7v/JDZxI0805HAjpb37rm6?=
 =?us-ascii?Q?1ENPBpiKRtpjHxftFlMLhYssua8To0qghRDupzZoENBUSeNUGvB/2aLPx+Mw?=
 =?us-ascii?Q?xnLOchVN4iUc78ErxD9w960ykUFyjWDtvYPEwgA+LPKs//DofTuzlsots+R7?=
 =?us-ascii?Q?gH8VhHvdjQIvGnfXDpsC/qiWAYoRy0FzH0zKdzkFd4xZdoIbjrVZZtTBJ8PS?=
 =?us-ascii?Q?6zbMLBi15VF0PuWD7lV2WJCNOc4mlrcX1pV/Rr5OggCRYc4Bw3oRnKSKl3ob?=
 =?us-ascii?Q?W/INpNaAwQmglFHt/ZCwE+401beBx0Tew6R2kUpay11X8rFHryLmObXtmGR7?=
 =?us-ascii?Q?NdUuXt4ENxraI1JpLARMpa0rcrhGXwLQv4mLgIUfBHL8lpHMRfWUdts9IKOP?=
 =?us-ascii?Q?bR2fX/NZFBFiqsJvdbHAR1vRstjZk6sv/2NqABmCCq2yGdTS6d4PvTC6k407?=
 =?us-ascii?Q?37D24x+/rzZF02bTyMWe7+DpwZsmbNT4faUqSyCUJYnVGpTKm4sawZ/kZSR7?=
 =?us-ascii?Q?ZEUJ0CBl8IA/gweYlUzN4rCUOHFBBl5EBP3nEZY1corBQtosOz/3/T1fyPg6?=
 =?us-ascii?Q?Goe/2s3piDhJ1QbxF8LZ74ZmNrANMx/wW4TQ9ruSqwIBf9KPDObFvj1l/dAV?=
 =?us-ascii?Q?RgdiczHlOe/D0ycK83pcPf2XSaz036RMDEIj5YL+q3fum13Sc7u//aLniBQv?=
 =?us-ascii?Q?0i6Ww1mEsc91efj26WGpTT405qbsfuNSeSzq4LIrlLqirzysCfIqTmJ0Q2KZ?=
 =?us-ascii?Q?/9kd7+trlDt1bTRI+fVJOa7eWbXTtngbmbS26Z2yB43SHvGyfZ0HIbgPosNg?=
 =?us-ascii?Q?ufTDjOlsKmO/Vd8gRby2aIKlNAscBwH8TYk5yODAnS9ECJIIs/HjMwMRD23I?=
 =?us-ascii?Q?RDDPgBx2yOr5S99q3tE7Z46o0iCRf3/wqcpzU3kL+jfJX1pziOY42a1n9otu?=
 =?us-ascii?Q?s+zBDBDOXiP4Ouc1EGFyqFxY0ehLrAK1+vobwPIBtwkS5SkDgs5FFMQI/6X5?=
 =?us-ascii?Q?IS9/JrBebzoJKcdu4ouigYGpZfRh3sMM45Nps66Y9Dq3u0jEH/bB8sndT/uU?=
 =?us-ascii?Q?CF3DGgJDF5XsjhKjJkx9pmmrXAnD3WFp66sE3UNffWvMJlJh1YKjF0tcltmE?=
 =?us-ascii?Q?y5ri71twehfAF8W6xfMtXIqV?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <5BD354D953F792449BD7AB4AB2FCF422@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM4PR0401MB2308.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8af59689-9e30-4016-37f0-08d963262ed7
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Aug 2021 15:29:49.4429
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LIL9L/gr7hqUZeaWZuykLCQEiEolJ6yoHIV6PV7KEcPXQDdf0L+JkOhO+Bz6mXlL/cp5rkKwPF4Nfwh00ATyvA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB8193
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 19, 2021 at 05:17:55PM +0300, Vladimir Oltean wrote:
> Currently dpaa2_switch_takedown has a funny name and does not do the
> opposite of dpaa2_switch_init, which makes probing fail when we need to
> handle an -EPROBE_DEFER.
>=20
> A sketch of what dpaa2_switch_init does:
>=20
> 	dpsw_open
>=20
> 	dpaa2_switch_detect_features
>=20
> 	dpsw_reset
>=20
> 	for (i =3D 0; i < ethsw->sw_attr.num_ifs; i++) {
> 		dpsw_if_disable
>=20
> 		dpsw_if_set_stp
>=20
> 		dpsw_vlan_remove_if_untagged
>=20
> 		dpsw_if_set_tci
>=20
> 		dpsw_vlan_remove_if
> 	}
>=20
> 	dpsw_vlan_remove
>=20
> 	alloc_ordered_workqueue
>=20
> 	dpsw_fdb_remove
>=20
> 	dpaa2_switch_ctrl_if_setup
>=20
> When dpaa2_switch_takedown is called from the error path of
> dpaa2_switch_probe(), the control interface, enabled by
> dpaa2_switch_ctrl_if_setup from dpaa2_switch_init, remains enabled,
> because dpaa2_switch_takedown does not call
> dpaa2_switch_ctrl_if_teardown.
>=20
> Since dpaa2_switch_probe might fail due to EPROBE_DEFER of a PHY, this
> means that a second probe of the driver will happen with the control
> interface directly enabled.
>=20
> This will trigger a second error:
>=20
> [   93.273528] fsl_dpaa2_switch dpsw.0: dpsw_ctrl_if_set_pools() failed
> [   93.281966] fsl_dpaa2_switch dpsw.0: fsl_mc_driver_probe failed: -13
> [   93.288323] fsl_dpaa2_switch: probe of dpsw.0 failed with error -13
>=20
> Which if we investigate the /dev/dpaa2_mc_console log, we find out is
> caused by:
>=20
> [E, ctrl_if_set_pools:2211, DPMNG]  ctrl_if must be disabled
>=20
> So make dpaa2_switch_takedown do the opposite of dpaa2_switch_init (in
> reasonable limits, no reason to change STP state, re-add VLANs etc), and
> rename it to something more conventional, like dpaa2_switch_teardown.
>=20
> Fixes: 613c0a5810b7 ("staging: dpaa2-switch: enable the control interface=
")
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Ioana Ciornei <ioana.ciornei@nxp.com>

Thanks!=

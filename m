Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8EBD40C52D
	for <lists+netdev@lfdr.de>; Wed, 15 Sep 2021 14:26:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237095AbhIOM1P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Sep 2021 08:27:15 -0400
Received: from mail-eopbgr80073.outbound.protection.outlook.com ([40.107.8.73]:19936
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232816AbhIOM1O (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Sep 2021 08:27:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iUJVZGuHMfYeHIr3+p6lAJF/sV6gzXnxI5kLwaQhmIt5cIV+Qt+MX4vkxuhDIjGh82fYCLiFCKMo25uhaxJtPQCKycOTQ7M9IaspSOu4u9wlpIsEy9l1R5tkOBxjUzmwxTLwXmCXDN2G6W17aNd/6Ki8H/cIVI9/D+xQ/XV/iAz8AaXO1Of1SiqhZLFJvc2VI2gblLGHbQh4vKbtQs6VsLu9/TLJbfKeEYaJ766qscCEyvtj2bsH9EsFBdg1RLNHJrk4xijF8HDB1lONiCsgAZeQWVBC2ipc7ZpTEkGS+ARLi23S8HfmKjv/Vs89s5qboWrwPKMtGjilKPEYWpOt+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=qM3YoQZRkOL2HEn5vkNfLhqjRbuRhxjkXVDNJDiiMeU=;
 b=oeaXjj4IHSI7fMEEDlvtUmexcJKLd9qmjylq/pxUkRpPM856vgl6/DXRBbOA55Zfgc/ZMQemk1IJxfN+Nrk8KtDWS8Jop8RBJQurb1e34AONOrNSMLxj3zkJ8SCqhB9+9NAy7PC2atN7VFvxw3UzTBQ6ir/QvV1s3NvpxfRUUXL2s1SUW+dIMOUjKtk1c6KH2ShMCVmxc7H/Ym/6S/mDpKGEg1l1FECQJ9UoX4gXi0yB7FisZnUUN77JmRUXCfp2quurChaG1QqMnnXWR3n/Rx7xgTjtV0oyTXwdG0akAiQwZb1roKuaLXdC1saN4ljxuGLecy1oRKOLm+MGo9Pozw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qM3YoQZRkOL2HEn5vkNfLhqjRbuRhxjkXVDNJDiiMeU=;
 b=hbHj5OAmemJeqhf3i6ltFXJlpWqr9zaJtU4HXSRnlMp3gFpr96nZCRChJGuLoqm+ZWUlp+gUElk+1v3nI1AqK5tVkY+c65qaHbgb1WuRjGyp7biboVMPIQw/x8La9EmM/vZXK/9YFacJzLfwDayxB0XMgqDh7PYIjxHV0cROrJk=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0401MB2304.eurprd04.prod.outlook.com (2603:10a6:800:29::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.17; Wed, 15 Sep
 2021 12:25:52 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4500.019; Wed, 15 Sep 2021
 12:25:52 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Colin Foster <colin.foster@in-advantage.com>
CC:     Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v1 net] net: ethernet: mscc: ocelot: bug fix when writing
 MAC speed
Thread-Topic: [PATCH v1 net] net: ethernet: mscc: ocelot: bug fix when writing
 MAC speed
Thread-Index: AQHXqfnm86w4MNSgi02/MgrVZkbyjqulBbCA
Date:   Wed, 15 Sep 2021 12:25:52 +0000
Message-ID: <20210915122551.kol3f5jz4634nvrm@skbuf>
References: <20210915062103.149287-1-colin.foster@in-advantage.com>
In-Reply-To: <20210915062103.149287-1-colin.foster@in-advantage.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: in-advantage.com; dkim=none (message not signed)
 header.d=none;in-advantage.com; dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 12893d24-5263-41a1-46f9-08d97843f594
x-ms-traffictypediagnostic: VI1PR0401MB2304:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0401MB23045D25C1BB0F567984335BE0DB9@VI1PR0401MB2304.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: dBCVT40ZKKRXSYypNaj4dzmfargju7lYgGWPNRo/WyhdbpkManImG3hCvuIRuyNrzPQPMkRwH6WTDOz/bEqf1Ae/bQ9piFbAJvFM6xNWli8KGxr/Q17HTzgd/YcvcVA0plN2lrdlH3VdPiw0BaCK4mMFRtoWymWbry0YzeSeBO48tUf7COUBNC3BDPDbLzHobURdiY5Y2LZv8iJidP42NQ6Trw76G+QmEVTmr8Mdy/KdQLa3jScFjFSg4p1alZn5G3TnyT9DVJReLkC7LSUoCktq0LfQGUqbT0RlBDJ8gq4lyaAZ4WD6+IXQCEWn7Y/I8q/PtFcPvegVsaSmdvEQP++2Y7MeKi9NyG8mZIS8kzk88XxIM24sDhpUFmCTeY58E1WyNRgwALpupKv5lGQobpT8tp2uE8se1h8xcvW+wiRlCuXzVZYiGEFkb0d9nkKPfzws3wOpZeDojDuLj/tq8hcWEJihFNOP0j006sVgLcoOqQ2gY+e2xk1Pld1PyI3b38MjUDyrCKm2SyvmA0bFPlkd5veCzqMTZHFnbR8mxtfBRcsDkKA2i/49BKNKnAUV2KwmAolUGDnthUnCbfsfqhpkrjhG/McguT8C6RyxB6mXKOR/McOcGbrwpZKpCySHDjv+OJzwGne+eWwKD9to4aQoi5lUVpGGC4B2WA/Z2FHHqXDAgsCqdXxkPknY57FqH2LuazivYhmrZ4CvBP/YYg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(396003)(136003)(376002)(346002)(39860400002)(366004)(9686003)(54906003)(38100700002)(33716001)(38070700005)(122000001)(44832011)(6486002)(5660300002)(4326008)(6506007)(6512007)(186003)(66446008)(1076003)(64756008)(91956017)(66476007)(66946007)(83380400001)(8936002)(478600001)(71200400001)(316002)(2906002)(66556008)(86362001)(76116006)(6916009)(26005)(8676002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?MZtbVhcnEeD3oB+LMzss0f4NHqn/a7zPkxIX/l7COESTEIhnsbjoPXhKAIl6?=
 =?us-ascii?Q?z4chntXFoeDzZXfqbviff+iCn8BNVj/9RV3qbTus24Ix8P6+DsbZaWIUJg0A?=
 =?us-ascii?Q?DPB2rF2C/fbH4IRWenkZcx/wYmwk0gadDy8HA8N3gi4BACmGNl/OYopnK9Np?=
 =?us-ascii?Q?+WNap6oyQsRRgL9xfZRpyST+tM7EpmmREoOn6v2lf/52rB1gEuoga3o9BB9i?=
 =?us-ascii?Q?I5PxfNlKoq+O/rBYQLbdB5eYieJi5jSleh9sGcE7NdfPBsN+cotfZupy2JWy?=
 =?us-ascii?Q?dyzkPh3X1G8dUgDHMWvJ59I4XpThjr8dy4JE2f3vMgEObfW4VRZGW09rnlZb?=
 =?us-ascii?Q?fUVNVj8RaY7nF24T77Ou6CxvF7zGv2vJaNvBZIlw6mV/Ukdk86HFjgW9flRz?=
 =?us-ascii?Q?/mYonBMECWoZzNB2vhCIzs7cTRhI6c07+8N3tCTiB0EigoiuZOJTtqfd9DP3?=
 =?us-ascii?Q?tYvwIQ7l2gvmJCXtKOrpct0Y45yZpHxFFn/q9tJiinS5rV4ZgaHwR6dcRULn?=
 =?us-ascii?Q?R7lTNpnhiLfQMVK1GjIG6aeiZUzfmhtiCnTF/eCjaCftEWVkx/gEVladkmtc?=
 =?us-ascii?Q?drUnEMAsq8fLGbf/9ft/zBTvNQ+oDgbSS9bs17/NNnbUsPlNMoTDaBfWQbRM?=
 =?us-ascii?Q?xmuXpbQ4Idm7M45Wl4bUmR+jDgf0aRsj3cgMrDXNlYQVZOoW8fJtrhmKWVyl?=
 =?us-ascii?Q?MP5uTyD6XmI69Z7X3F0sG+rHt04AH0jtgXJ9sE33oF4O4awxyyLsc3Kt1H1D?=
 =?us-ascii?Q?bA7RizgM3M3Q7PzJSb7RnVUOia4jleKvxdtDMhTMea/nEI/a5hlooX431z5L?=
 =?us-ascii?Q?G+evVx+dSO0OMKb9yr/5kZoovBhPnSl/ooy3asn1CUGEMPjc1Yfm0s1ySSPD?=
 =?us-ascii?Q?HmWlCXOrB5JjDfcjvftyz5n4r/3gWRGUch3i1/E0bDnBK63ne0gTFLSxt8uq?=
 =?us-ascii?Q?DOdo8N9c2JYxgzUAArFMK1hbQWe3fFEQGXrmF08CMdCaxJAxLHk7SiFsTXbb?=
 =?us-ascii?Q?k/KHGBXHNu4kXBMAAOM0N9hxVcMPHa/ceq5TIOkrIB5GMhRjdLbY2c3e2aDm?=
 =?us-ascii?Q?g0R1xI86jKVJtoti+8S/cCPw3q6oHEXxJfRwBswiCdLF2PXQ8vceLXZZFkkT?=
 =?us-ascii?Q?IoSetL97UAG6JYYcMEqbbweKupC6YrrWncc3z220DL/3JjaEk5SIXp9f/0pj?=
 =?us-ascii?Q?O5A/zPZQMgzIR5wWp7VyMhL3sRJui6VIDw7JCPDSaDEWygY2wx+A9gACYPp4?=
 =?us-ascii?Q?jW//6rgKmFh+Ij4YGuDIpPvilgXlKsEtM/QPkPmaah/roScFI4AmpJh+/IbO?=
 =?us-ascii?Q?imRw9MVp6Em6tNN2oUtm4Ql5V/b7N/ce51tOrwYlYFlf3Q=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <D5E3FD2BEFDB9B4D9077E0FA2B818062@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 12893d24-5263-41a1-46f9-08d97843f594
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Sep 2021 12:25:52.6234
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ou6EcBcJZxaQ2+ITqNSRY0Bg1ERaYyDzwOwDbaT1JAJy6PhKMJF7Wda1DdPV1C5RatvZ+HSW5+ysNpDW/xC6fw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2304
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 14, 2021 at 11:21:02PM -0700, Colin Foster wrote:
> Converting the ocelot driver to use phylink, commit e6e12df625f2, uses ma=
c_speed
> in ocelot_phylink_mac_link_up instead of the local variable speed. Stale
> references to the old variable were missed, and so were always performing
> invalid second writes to the DEV_CLOCK_CFG and ANA_PFC_CFG registers.
>=20
> Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> ---
>  drivers/net/ethernet/mscc/ocelot.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/ms=
cc/ocelot.c
> index c581b955efb3..91a31523be8f 100644
> --- a/drivers/net/ethernet/mscc/ocelot.c
> +++ b/drivers/net/ethernet/mscc/ocelot.c
> @@ -566,11 +566,11 @@ void ocelot_phylink_mac_link_up(struct ocelot *ocel=
ot, int port,
>  	/* Take MAC, Port, Phy (intern) and PCS (SGMII/Serdes) clock out of
>  	 * reset
>  	 */
> -	ocelot_port_writel(ocelot_port, DEV_CLOCK_CFG_LINK_SPEED(speed),
> +	ocelot_port_writel(ocelot_port, DEV_CLOCK_CFG_LINK_SPEED(mac_speed),
>  			   DEV_CLOCK_CFG);

Oh wow, I don't know how this piece did not get deleted. We write twice
to DEV_CLOCK_CFG, once with a good value and once with a bad value.
Please delete the second write entirely.

> =20
>  	/* No PFC */
> -	ocelot_write_gix(ocelot, ANA_PFC_PFC_CFG_FC_LINK_SPEED(speed),
> +	ocelot_write_gix(ocelot, ANA_PFC_PFC_CFG_FC_LINK_SPEED(mac_speed),
>  			 ANA_PFC_PFC_CFG, port);

Both were supposed to be deleted in fact.
See, if priority flow control is disabled, it does not matter what is
the speed the port is operating at, so the write is useless.

Also, setting the FC_LINK_SPEED in ANA_PFC_PFC_CFG to mac_speed is not
quite correct for Felix/Seville, even if we were to enable PFC. The
documentation says:

Configures the link speed. This is used to
evaluate the time specifications in incoming
pause frames.
0: 2500 Mbps
1: 1000 Mbps
2: 100 Mbps
3: 10 Mbps

But mac_speed is always 1000 Mbps for Felix/Seville (1), due to
OCELOT_QUIRK_PCS_PERFORMS_RATE_ADAPTATION. If we were to set the correct
speed for the PFC PAUSE quanta, we'd need to introduce yet a third
variable, fc_link_speed, which is set similar to how mac_fc_cfg is, but
using the ANA_PFC_PFC_CFG_FC_LINK_SPEED macro instead of SYS_MAC_FC_CFG_FC_=
LINK_SPEED.
In other words, DEV_CLOCK_CFG may be fixed at 1000 Mbps, but if the port
operates at 100 Mbps via PCS rate adaptation, the PAUSE quanta values
in the MAC still need to be adapted.

> =20
>  	/* Core: Enable port for frame transfer */
> --=20
> 2.25.1
>=20

So please restructure the patch to delete both assignments (maybe even
create two patches, one for each), and rewrite your commit message and
title to a more canonical format.

Example:
"net: mscc: ocelot: remove buggy duplicate write to DEV_CLOCK_CFG")
"net: mscc: ocelot: remove buggy and useless write to ANA_PFC_PFC_CFG")

Be sure to include this at the end:
Fixes: e6e12df625f2 ("net: mscc: ocelot: convert to phylink")

So that it catches the stable maintainers' eyes.=

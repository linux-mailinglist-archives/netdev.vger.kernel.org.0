Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB01840D90B
	for <lists+netdev@lfdr.de>; Thu, 16 Sep 2021 13:49:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237739AbhIPLuo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Sep 2021 07:50:44 -0400
Received: from mail-eopbgr70079.outbound.protection.outlook.com ([40.107.7.79]:47171
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235695AbhIPLun (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Sep 2021 07:50:43 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UM8uI63b4n9E8pzDkrYnh+AR5Y1seBgA+/m3fZMfvZqmJzU4foIY0cSMVCHeT8mIxbS63JY1kDYUzT/U4CcimMUv0vDIQBinNdG/MwYJGTBA/tbOMQY0V9pJtbTUc+TmWc/EXNe839c6ZZIEJwu0U6XlylblAhOCJ5HMSqHtx+hRVW82wu+Cbr8Y8KIjaRuxVuPtc/5wJlxSLhwxGvXlzv0Q9wCMq98Kj8mmgn8t4TCV+/NpLaF5hpVfiAXknwAxyeWs6YiIh+KGgGba49NGGzmZ4pP2GZnv+8AlL+k6XSwt5hRI+dlXFXWWyP8L2PSnAj4iDUxv4llHVLDZ1DAqyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=gA2npQw2LSOfzhlScfgmB7ZM3HvJy9lwBXCvD1GMbw8=;
 b=lbkciYYT6iUBImdUPcrvNv7x1D2g/7kXfrDwEB2xMYbm0haB3cLtSSanZsSNOolEzYx7ML5MBnh+CAi0LCtD85FrHFlmAYvlRWSVEz2iv6YH1o/QYNA41RgHqmKF7yCM0X8KeuCuGpfffj/lOA5mLv75IgOcxo+zBJkAnzBBJi3kEzL1yCu5bhhr+WIYhPIaHAuNAS8bSli27bK0HGHa2607Kzx5hgrohEmIYOYore4Wcbgw6eILYwh54yg51i2/a5QpRcqk93p3cr6uOY1+uw+rybDFBXsiGx9d+U9gcvf8ey5EsyxvAJ0gm4ARxWsLaT2uhJwEn2uepqBAWvyQxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gA2npQw2LSOfzhlScfgmB7ZM3HvJy9lwBXCvD1GMbw8=;
 b=pPHjymkPADM/Xr0CDb4I+zZUkcBbWJlYcfTtYjyOUSDwkYwygDduriMRQr2Sjc/w3XXVr0OJU4ZNXEuXU57XKZT0UxMRl5HI1Nf7c+/FpsrS3DWSVZcdQvF+B38Q72+IddLWKYxylXoWjM/AGxOejgz1xT6h6BYDRagyEUa5cjA=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB3069.eurprd04.prod.outlook.com (2603:10a6:802:9::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.16; Thu, 16 Sep
 2021 11:49:18 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4500.019; Thu, 16 Sep 2021
 11:49:18 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Colin Foster <colin.foster@in-advantage.com>
CC:     Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v1 net] net: mscc: ocelot: remove buggy and useless write
 to ANA_PFC_PFC_CFG
Thread-Topic: [PATCH v1 net] net: mscc: ocelot: remove buggy and useless write
 to ANA_PFC_PFC_CFG
Thread-Index: AQHXqpeh6y6SRE8JykW9vsuy+tc/X6umjJKA
Date:   Thu, 16 Sep 2021 11:49:18 +0000
Message-ID: <20210916114917.aielkefz5gg7flto@skbuf>
References: <20210916010938.517698-1-colin.foster@in-advantage.com>
In-Reply-To: <20210916010938.517698-1-colin.foster@in-advantage.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: in-advantage.com; dkim=none (message not signed)
 header.d=none;in-advantage.com; dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8d367b1e-e3d1-4e17-91cf-08d97908045b
x-ms-traffictypediagnostic: VI1PR04MB3069:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR04MB3069B7730057CA9E40F7EA84E0DC9@VI1PR04MB3069.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: blns6/QWGsd1MAREeiWceog37eaQuMzbLZvvSBFaohs9Q7EvuzgUl6SQRlqYwgY9SXfyx5KknBTJZzrXTfY9fnzzQ0aoAvUagJlmFXlBqmYv/k7m6ge6IMP0MfysI8gfUbkVdICe7fmMxBvF88eNf/ncTUqcFiuyjoS4i2PNxiQbzc2+cGI8a/ldfeuo5FWvAiE3o1cmJGqdaCbqNp1qmazEkbn/3xTp9yF8JFElphtJ95wst5bc4lJ2MIdlr4eNd4LjamwaJguK3o+I8wZKSDq401OwtreGXp2emj1HSqGjaCAL5VCXPfOtf1JRP1quFIPqPbJUuW472C+R+SdfqVQ1FKMZ94yCxZaubKFFbYzoazEElhxMOE6YsxrBfLEnBwBcalpUowHM13S9UCIkAoPmCFiOKJlCoPVklsYKfNZoXANC5b5gQqdACPBKCygR18i5qaGstqGXU1E6hoijY5SRqbGd4+hc7g6KHkjOdotHWLkoo3099BirkwM7uxhq41omWY/TDBS1A8bG9zqpLhhFeSZJ5Tinp4QmzzxdguXKB6/UMqgBKAtdXs4Twi8NYv4kDE2oxGYLgNBVSpQFL5tawHgR9NwpAB7uWn22KFqnVwmq6O8jXo58fnIZb7KDXKUk9Tcq+JvG18U4Jh3MWvG4aHgD5cLIOO4W7ofD2yRVcFgl2t31xojX5T/5Rxtf9bHCVDqUJmR9Yz7FMCKJHhIIYOWp5S7i6YjPGv/dwlp5J2gR1Aqo7NAynpCiBJs/ubkRatJQf5/4+I/ayL8rY3z2LIgvtuxVQitPm6BZHRutTbOaEHGSSoAMfbIv7puLfBQAUtapeGUttGL8ZrsSQw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(366004)(136003)(396003)(346002)(39860400002)(376002)(6916009)(26005)(8676002)(122000001)(38070700005)(38100700002)(186003)(6486002)(966005)(44832011)(64756008)(86362001)(66556008)(66446008)(66476007)(8936002)(33716001)(1076003)(5660300002)(54906003)(478600001)(83380400001)(6506007)(4326008)(6512007)(9686003)(2906002)(76116006)(316002)(91956017)(66946007)(71200400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?x5fHgbyK0+3mRyHKJW8V4xhKtvhE9LV72Ii0hXhgjPLCLrJre1ZJclBo9AJB?=
 =?us-ascii?Q?MuSSvXQNU8nKGg9JRgCpY0azB13f3cUCQWMg6jQMwkUIhQhCkEcXvZAmZZ9r?=
 =?us-ascii?Q?Bg1Wabx2OdNyS9GlD25kEIeevKvYhksFx47fslD2tWr8JZUenZOM+9Rc2vOr?=
 =?us-ascii?Q?yrc00pIYhiB3QR55LNDeDd1pH6fKluQkDWH3YxiNkm+oa1Ec0YNYOX4TxnYC?=
 =?us-ascii?Q?IHrCTo9WWD1I3yzmDMQfYiwzsFODZCxt07JJih6YkfN1/5Lhz+gqbKMtnRQX?=
 =?us-ascii?Q?4tF/EAWGQzZauNjcAXqFoBEMlWL8z3wUCbkZiKlAnddgIyb+UM7qkS+5mlMI?=
 =?us-ascii?Q?smgyyNXc0VuXWN5hmD1+zpsUh+23tQrffW5mfKVnSbXCDFtjM8KqOwXT/gYu?=
 =?us-ascii?Q?iza7ZJeHAhZVhZw1Dov0m4Vkyf1BFwLzDfiHk/EX5zHma68r5Cbt1891gLx+?=
 =?us-ascii?Q?IOr8Wka4abN36W6gufxxopLmXWNVv5+jaOV9JPoOlm/iCT8H31rifT5CTQK/?=
 =?us-ascii?Q?HyEQwgvhTwDerVj4YksCVOdNPV3MilKk9Y6NLrw+fM4zdPuSojO1fUd6sHnK?=
 =?us-ascii?Q?A5X/zGsmixPRZWGIOPHf9EVbI0GGRSNn0QAiigUETYSwcB7pSN8IIhBY0MvY?=
 =?us-ascii?Q?E9VUQew4S92qnieZxzl5zVRsb8UMlT+ZKORlXvVClbkQ8Hwa2lrmZeYbTjNQ?=
 =?us-ascii?Q?Q9RC1KwhY4cUzkVj5uEBCEsl/IcC1xD9PPL93oEoLJAGMqjUvU9nEma00Y0Q?=
 =?us-ascii?Q?VOhK9/jJ9E8vvDDCI1N8hj7qeUtSgZDngPv0DqPBJI3AXqzqUwAoZxn+fIBN?=
 =?us-ascii?Q?QLsnTacL1ISPHWfmDUSYQjKNtD429Axbsj8DnyIzw1w5aN37sYZv3cI6Nbcp?=
 =?us-ascii?Q?VH1WyF/KYM0ZCIjEqxjtZbVOgx/aUYmR6yIo+gRfOTtOB122AzMlruJAhCNg?=
 =?us-ascii?Q?Z0/WI9Wurifp/i7wpPx5GaIuhyrL/b710LYV+hLHYZLBd1rnW+dEnwdjW18A?=
 =?us-ascii?Q?JvmY/HJHkl3nVNtMmLlE/ARL3SZNO/5JHKIqyvtJ2NwIYj/TuYwD54zHLA/d?=
 =?us-ascii?Q?x7nlC2VKD3NPFsTxO9O9KHyF6u9a47Iyh9TjVifs+nvNj0PvyOrKaLlgTXLm?=
 =?us-ascii?Q?XldOPa0hW2pyGR5M1E0PHWeGdOUH0u6LGwjOelNI2g2vjdsLI00Mp1ofALa/?=
 =?us-ascii?Q?mgyW/0Ri+UN7Wl0zBnjfEcRpom1D0nIJlAM/otRZjQ8pC/Zro6oxogoeXDel?=
 =?us-ascii?Q?nHPeGUZo74uf/YrH3uV4fsYiYg23xydxisysr77mfTAjAIlk+JbSar71VJGx?=
 =?us-ascii?Q?Zc3hKu/GV9MlWGPg9T5YVHk4?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <38C4B60FA475244FBA3F3993BC8A000C@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d367b1e-e3d1-4e17-91cf-08d97908045b
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Sep 2021 11:49:18.8365
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3idKFQH+zNZYR/kGMbq+DnyM0tAqDaZjeBEs+gn2hRSeMa5Zshe02iYiJiZQJ7y0b/w2mYrfyeAenwkxLFKo4A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB3069
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 15, 2021 at 06:09:37PM -0700, Colin Foster wrote:
> A useless write to ANA_PFC_PFC_CFG was left in while refactoring ocelot t=
o
> phylink. Since priority flow control is disabled, writing the speed has n=
o
> effect.
>=20
> Further, it was using ethtool.h SPEED_ instead of OCELOT_SPEED_ macros,
> which are incorrectly offset for GENMASK.
>=20
> Lastly, for priority flow control to properly function, some scenarios
> would rely on the rate adaptation from the PCS while the MAC speed would
> be fixed. So it isn't used, and even if it was, neither "speed" nor
> "mac_speed" are necessarily the correct values to be used.
>=20
> Fixes: e6e12df625f2 ("net: mscc: ocelot: convert to phylink")
> Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> ---
>  drivers/net/ethernet/mscc/ocelot.c | 4 ----
>  1 file changed, 4 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/ms=
cc/ocelot.c
> index c581b955efb3..08be0440af28 100644
> --- a/drivers/net/ethernet/mscc/ocelot.c
> +++ b/drivers/net/ethernet/mscc/ocelot.c
> @@ -569,10 +569,6 @@ void ocelot_phylink_mac_link_up(struct ocelot *ocelo=
t, int port,
>  	ocelot_port_writel(ocelot_port, DEV_CLOCK_CFG_LINK_SPEED(speed),
>  			   DEV_CLOCK_CFG);
> =20
> -	/* No PFC */
> -	ocelot_write_gix(ocelot, ANA_PFC_PFC_CFG_FC_LINK_SPEED(speed),
> -			 ANA_PFC_PFC_CFG, port);
> -

This will conflict with the other patch.... why didn't you send both as
part of a series? By not doing that, you are telling patchwork to
build-test them in parallel, which of course does not work:
https://patchwork.kernel.org/project/netdevbpf/patch/20210916012341.518512-=
1-colin.foster@in-advantage.com/

Also, why didn't you bump the version counter of the patch, and we're
still at v1 despite the earlier attempt?

git format-patch -2 --cover-letter --subject-prefix=3D"PATCH v3 net" -o /op=
t/patches/linux/ocelot-phylink-fixes/v3/
./scripts/get_maintainer.pl /opt/patches/linux/ocelot-phylink-fixes/v3/*.pa=
tch
./scripts/checkpatch.pl --strict /opt/patches/linux/ocelot-phylink-fixes/v3=
/*.patch
# Go through patches, write change log compared to v2 using vimdiff, meld, =
git range-diff, whatever
# Write cover letter summarizing what changes and why. If fixing bugs expla=
in the impact.
git send-email \
	--to=3D'netdev@vger.kernel.org' \
	--to=3D'linux-kernel@vger.kernel.org' \
	--cc=3D'Vladimir Oltean <vladimir.oltean@nxp.com>' \
	--cc=3D'Claudiu Manoil <claudiu.manoil@nxp.com>' \
	--cc=3D'Alexandre Belloni <alexandre.belloni@bootlin.com>' \
	--cc=3D'UNGLinuxDriver@microchip.com' \
	--cc=3D'"David S. Miller" <davem@davemloft.net>' \
	--cc=3D'Jakub Kicinski <kuba@kernel.org>' \
	/opt/patches/linux/ocelot-phylink-fixes/v3/*.patch

Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Please keep this tag but resend a new version. You can download the patch w=
ith the review tags automatically using:
git b4 20210916010938.517698-1-colin.foster@in-advantage.com
git b4 20210916012341.518512-1-colin.foster@in-advantage.com

where "git b4" is an alias configured like this in ~/.gitconfig:

[b4]
	midmask =3D https://lore.kernel.org/r/%s
[alias]
	b4 =3D "!f() { b4 am -t -o - $@ | git am -3; }; f"=

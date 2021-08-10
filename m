Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83F8E3E5511
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 10:25:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238108AbhHJIZz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 04:25:55 -0400
Received: from mail-eopbgr60087.outbound.protection.outlook.com ([40.107.6.87]:54116
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237542AbhHJIZx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Aug 2021 04:25:53 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=leEMsuicpOOlf1F/vVaS53LzkUg3ghRGwnDFw6HDQBY1dmgOBvgCS1ta+PNnWOjr1nmTnmn/tTNyN4qALqm9aPnKwprLKYx+qFvaAYv7XWbh5y4xRY9BfxCFargjfY/2o11IC5c3lWv/DeU7A8bc/A/59UBmZWxLYZSamCQhQysjWBjse6jbVvYgKwaiSarg6otfST5xh9l1dChY7r5Ird4Ywr0EPyRMSbCBxwKjFJ9IUsjqBxYPBnK6kBnSqHfJMIsFeW1mSxO5fJpWcNb9k8qoI/lZCQX9Xhdvn42VkYix7o0GEXXdcARzneQ+mKeI/c7oirzu8KCeZSKt3tf/oA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=38JoN34xqgLlL7laiJg64AKB0mAJh8k61jXzy1IpwtA=;
 b=SsGgS6H72Ik+lOdz+JJbVWrSf7Tt+zE4Z7umR2IXLmXN3DcM0+ge+9N8e6PE2gfIbfbbIznWb3rqA9OK7qEn88X5njE00YyVwPjnTuIzlQqoM0bP0CsJKDxcf2ky7b5d2qpvtNrPGaYDqr0les0za7sqEc+JCtICgpgipHkKEZj6mEY9K+O3zpgFNlDWWirxHE3VXbq7DVHOSuCVAv6tpiIQeAQ2GIdHV9GG6v3SVX6grD4uW/TEpH6Ina2lRdfEVM0jx7q+Ps1lh4rV8m6X0BmqbCQSTAuVPAMHaObChueIpkxn2JUTnCUhBQJnm1T7iSIuWhgegIt+YTFxiVnLsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=38JoN34xqgLlL7laiJg64AKB0mAJh8k61jXzy1IpwtA=;
 b=KGi/Q89o/fbWPx4ZwAcraIT6Z1AlQ31lkHtcF5yvFghLOfvJHHjd/eXQwMAxqhH0tJLrqQpWwuxjmp0tBZVBtudV1lSxCEAhqA/MQcS158D30Hqv/MfHBq0cO8h0deNrkXDnw+vzKWRg56nhgcUlLvI0033gCqcVKLwyrOiZUj0=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB3070.eurprd04.prod.outlook.com (2603:10a6:802:4::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.21; Tue, 10 Aug
 2021 08:25:29 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4394.023; Tue, 10 Aug 2021
 08:25:29 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Wong Vee Khee <vee.khee.wong@linux.intel.com>
CC:     Vladimir Oltean <olteanv@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net 1/1] net: dsa: sja1105: fix error handling on NULL
 returned by xpcs_create()
Thread-Topic: [PATCH net 1/1] net: dsa: sja1105: fix error handling on NULL
 returned by xpcs_create()
Thread-Index: AQHXjbEf97MxzK96ykqwDh6cpjl/jatsZyoA
Date:   Tue, 10 Aug 2021 08:25:29 +0000
Message-ID: <20210810082528.rff3aembgge62pd6@skbuf>
References: <20210810063513.1757614-1-vee.khee.wong@linux.intel.com>
In-Reply-To: <20210810063513.1757614-1-vee.khee.wong@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: linux.intel.com; dkim=none (message not signed)
 header.d=none;linux.intel.com; dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 10e379a5-b813-4edc-3185-08d95bd86993
x-ms-traffictypediagnostic: VI1PR04MB3070:
x-microsoft-antispam-prvs: <VI1PR04MB3070C82811589257ABB65A7FE0F79@VI1PR04MB3070.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: IPb/8EmFcCFjtccDKXaDsM2Y2hDXuiAO7uj2Qrf1K6gDminE9FqPRM+smDGBfa85mE7thJ3T/u8t72XS3ZiDzSNH5gPYT7Bu8IO3pruzti1yi+9J0zuo6xpe21UEFUV0abM/h4dFyVc4IaIrvchB2kTZBJp/mz/BB7nTkmVsqSf5jAZaxHO4MgA4OqLxJXSjYM7001FGknRGxobdI4BaFa/ZZ7buf7KMGQONOAuTVRLPPf6KXrC5Mi1Bubjn4bV3Ja5/uHi9j0cZ976mAW+zKbeTMMig+yWXUF8dq9Msz168jWPLJCGtyV5dO2rWQVF1JeD+Qk5BZh39ZUCBpSodq7TX635FuTmP6Cb+HcBReD9YHr1PEVIJ1gEuu/ve5T1bgbD6VqEVD6gNc4PzZScEzYxri8yQocjwbiQwmf0sub/AACvUWpwWxpS5jZ12vQ5aNu4PZyIC/RYzAw37pJqpIbcO7phgNbFzieuF88N+ih6JRs2UhaSBoF+oyhCVTe7fbOpGUIPcgeP2eM5QBHQwmc3H/HVcalGRzQ/lL5lihlPnbi4RTxLG9tG9yfj8C2u/wzneIxAobRxAKNRnWrDwqa16/duhl/YKULrV1zQpaaNzl3vTpnuxmm7RmMFn9S7ZaaandQcxom9p40jdB/coBotLY85UMpArIoNIOB4enzkKE3T61/VmlQ7Oo75OlSkDt+HcN0cpk9g7m/DNadG0ww==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(376002)(136003)(396003)(39850400004)(366004)(346002)(66946007)(64756008)(86362001)(91956017)(66446008)(8936002)(66556008)(66476007)(6916009)(76116006)(316002)(478600001)(33716001)(38100700002)(83380400001)(122000001)(54906003)(4326008)(6506007)(8676002)(6512007)(9686003)(6486002)(38070700005)(44832011)(5660300002)(26005)(71200400001)(186003)(2906002)(1076003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?X/f6qE3UsAN4HepdB7yh9m3eMXVhG0I14nAIwTyYnptJ53MB+KdlI0Pe/4lD?=
 =?us-ascii?Q?TbmKkaSN7U0oVNOjZZb9kaA429NZv196cyxfiEsZj/cODuZvh16+9pthRBFy?=
 =?us-ascii?Q?K+HHrrVHeU7FOdO54jKXvfVURb7EynEAAAgYGfxGEERvHZ+pxJU/ZIn+bXUu?=
 =?us-ascii?Q?sxY/vOfqOdXTbiOHn0Ay0/c+VmNp/6pktLtg7736JJazKK4nrjqTombq4DdW?=
 =?us-ascii?Q?uatamDbQN+bfOWQqDj2wXwSaJrYrsyFAmXGCk6mJILAVAHjicWxfvb+Oa802?=
 =?us-ascii?Q?BUKOzXcf3FLM3IjB/7cFF7032HDqYVSLZ4xW4e+1KNxSUEwi0h61spG7KzC/?=
 =?us-ascii?Q?a7s5oxXb47z+u1mw/ytjqRGfXQoltrv7LTCV3wdqKM/PdIDZd4zFyCu7DimN?=
 =?us-ascii?Q?JKc/qtT7bYRq3FvpGwQYEbVeJkHTE2rC1oWNz+aR72Kckgk+ZT+IOc0XYLEv?=
 =?us-ascii?Q?kpYaMQzkJRmz6QC1HweiRG+A+Jf5ux0cf9oE5F6t1SWNH9MvraeaS+mEsLEC?=
 =?us-ascii?Q?lKv+Hxg0mnjoSBVdAsO6GDGMXAKToMuSXSgk02om/SmlRtCQdiprGTsdVvKT?=
 =?us-ascii?Q?/AH9eSYP7kk1DTFCymik49aZGSChSqc9e8pon0h0gSEgWohc9KTEDwWLVo0e?=
 =?us-ascii?Q?hOMucllFVM4/TjuN2gSVzcR1aFM7gXD73VF06FnbJY8ouc2VueFyDhWLPENB?=
 =?us-ascii?Q?NS6IQjiNrWFUupBgEbHtfIB/oX1dtxlHkMvEfzsfFOON8Q6BlAwcFnoVWQXB?=
 =?us-ascii?Q?gfib0wz0Tu+GZKeDpRF13EtdB7m4WEuyZnO/fhFptetdlzJIPeuqVngbXdw5?=
 =?us-ascii?Q?Pzer+ygxi3C/jL83eER5/IJ0HpzCF7amBXQ2QXaKyLogv6QmxK5hOoEjqCys?=
 =?us-ascii?Q?NRkxUNOpmW6Mq1uyC43ahSoKa5HBuP4H0GDL3tJnGihAhmmzdZ47QgVPfa3e?=
 =?us-ascii?Q?u89yR6N3KV5XTTwuhJ5e3+9N2hiC7tyvvyNaf5qSGXnLbu8rVn5y5gH0I/tU?=
 =?us-ascii?Q?x8C9u9BUcyAoTNmBattsIUiZ169shR4ZYB524+RQJAcXdvbZ4B46jAhfMeD9?=
 =?us-ascii?Q?uuOgrUCa0+TWgS6VysMLd6+cChFajA5RuCLicPrRhcm5lt15gRdbzPmNg4iH?=
 =?us-ascii?Q?+oS3bjm+Ws9LT6N4E87vzwyE+vAuKNTauCr3/lLfjXQau/DHEAc8L50EOP0R?=
 =?us-ascii?Q?8hvTE0YYeK57o875l5VYRikvxT+FKlAgs3EHxVJtegmH7kXqDoUmExkZ2ltH?=
 =?us-ascii?Q?ntosqv3Yo5985AXLtgI1GTMryWzkPpHuMLpaHnXi97mvXeKFuDQ9+/4RdwZi?=
 =?us-ascii?Q?sRpnW9miJITp3FEThXFB2Rc6?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <04C31B26DBAD834F8DC02C5439A0482C@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 10e379a5-b813-4edc-3185-08d95bd86993
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Aug 2021 08:25:29.1144
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4/qxEFluWh2k9pMI6WmWOGuuOk4WlfC/mM+UFn0bzVpTJ0fRqPkHbWm8IxRRztZAxvzes1svxYY1jRldC9u/ng==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB3070
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi VK,

On Tue, Aug 10, 2021 at 02:35:13PM +0800, Wong Vee Khee wrote:
> There is a possibility xpcs_create() returned a NULL and this is not
> handled properly in the sja1105 driver.
>=20
> Fixed this by using IS_ERR_ON_NULL() instead of IS_ERR().
>=20
> Fixes: 3ad1d171548e ("net: dsa: sja1105: migrate to xpcs for SGMII")
> Cc: Vladimir Olten <vladimir.oltean@nxp.com>
> Signed-off-by: Wong Vee Khee <vee.khee.wong@linux.intel.com>
> ---
>  drivers/net/dsa/sja1105/sja1105_mdio.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/net/dsa/sja1105/sja1105_mdio.c b/drivers/net/dsa/sja=
1105/sja1105_mdio.c
> index 19aea8fb76f6..2c69a759ce6e 100644
> --- a/drivers/net/dsa/sja1105/sja1105_mdio.c
> +++ b/drivers/net/dsa/sja1105/sja1105_mdio.c
> @@ -438,7 +438,7 @@ static int sja1105_mdiobus_pcs_register(struct sja110=
5_private *priv)
>  		}
> =20
>  		xpcs =3D xpcs_create(mdiodev, priv->phy_mode[port]);
> -		if (IS_ERR(xpcs)) {
> +		if (IS_ERR_OR_NULL(xpcs)) {
>  			rc =3D PTR_ERR(xpcs);
>  			goto out_pcs_free;
>  		}
> --=20
> 2.25.1
>=20

I think posting to 'net' is a bit drastic for this patch. I agree it is
an issue but it has bothered absolutely nobody so far, and if sending
this patch to 'net' means you'll be blocked with your patches until the
'net'->'net-next' merge, I'm not sure it's worth it.

Anyway, I don't think that PTR_ERR(xpcs) does the right thing when
IS_NULL(xpcs). So how about you make this change:

-----------------------------[ cut here ]-----------------------------
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c b/drivers/ne=
t/ethernet/stmicro/stmmac/stmmac_mdio.c
index a5d150c5f3d8..ca12bf986d4d 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
@@ -415,7 +415,7 @@ int stmmac_xpcs_setup(struct mii_bus *bus)
 			continue;
=20
 		xpcs =3D xpcs_create(mdiodev, mode);
-		if (IS_ERR_OR_NULL(xpcs)) {
+		if (IS_ERR(xpcs)) {
 			mdio_device_free(mdiodev);
 			continue;
 		}
diff --git a/drivers/net/pcs/pcs-xpcs.c b/drivers/net/pcs/pcs-xpcs.c
index 63fda3fc40aa..4bd61339823c 100644
--- a/drivers/net/pcs/pcs-xpcs.c
+++ b/drivers/net/pcs/pcs-xpcs.c
@@ -1089,7 +1089,7 @@ struct dw_xpcs *xpcs_create(struct mdio_device *mdiod=
ev,
=20
 	xpcs =3D kzalloc(sizeof(*xpcs), GFP_KERNEL);
 	if (!xpcs)
-		return NULL;
+		return ERR_PTR(-ENOMEM);
=20
 	xpcs->mdiodev =3D mdiodev;
=20
-----------------------------[ cut here ]-----------------------------=

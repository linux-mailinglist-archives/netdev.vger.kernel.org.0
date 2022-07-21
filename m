Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7837E57CBF1
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 15:30:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229630AbiGUNap (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 09:30:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229549AbiGUNan (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 09:30:43 -0400
Received: from EUR01-VE1-obe.outbound.protection.outlook.com (mail-eopbgr140051.outbound.protection.outlook.com [40.107.14.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0647633E22;
        Thu, 21 Jul 2022 06:30:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JlrGt85k0tAVtrU1cGtqdI3F/E2aqfvHCx0cF9ARrnfDjRM6roypx+mpfhg2d3e8nDHECTqNtmLZDYyl4Y/GRiPDEBs6orrN7KMLNBsB5ufs6fLBdQRB2fzVdZurRgge4X19/wbfJGHvELWjZ9UmyYIhTo75qsMb9UR5E/3HcFuwpXjKQtw4YFsVd7u2SR6ES1lAqIjqJWxn+e+zECOvLx9TF1AeCpkbRFfa2usFe3/4AXluGQ17S5bNw0SPl0fuE/j6rJ3elrrOsk5H6w+rQn6HmQ2HkVpdBwCl6mmXDkX7neSe86nvqD0I8uGY8l7wzXSiScatKlyfsqL8ptoa4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9n/zxedwQEhjwdlYgb4QcReutgQKxUTTm2aIbiZeIS4=;
 b=EIcxAIrkWf5LYr7DcEGyP8HMOi8SNiPI9kXUgbx4VWWL01Z1mYhx7k8l73U8VLbhsoqHokuW852DSOpEC/7kCT5wvr32gkdfO/qLuST22KbthpnUBOsT0DcWtdl5TgNfWyLWwV0pKb7URdarBrDSOXdEQrXjzf9qMVi+P5nF3wARAF9kYh5mJznNsMp0w2HhK/uj1CkMPinnuAXq9dyYGq+7cYXAtydHRKYVJWpGrvpiRvme29XBrJjhkJs8jBD9kBqwlvXbl+cEdBMfxMeZAIvInxEGOIzaBy7CFuauj9jN+yd4JlWtnIgGuh0p6r562y37pv7/AMSR+TazjdrQ7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9n/zxedwQEhjwdlYgb4QcReutgQKxUTTm2aIbiZeIS4=;
 b=SD2qVz90CdzuAdIog8upJaeE8VGvQksoCopYQgexFDcb/UN3OldAzKJJDN6w1fgMy16+b1z5VYt+/4RcS1hWIE3ZU70cU3W1w2LcpWbeEv613Z8h8itArNMPuN/ijpe/SBZjdtgma4WYzOmHrAe+2hK9g6VT/tY7pE4U8dF08zk=
Received: from VI1PR04MB5807.eurprd04.prod.outlook.com (2603:10a6:803:ec::21)
 by AS8PR04MB8401.eurprd04.prod.outlook.com (2603:10a6:20b:3f3::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.19; Thu, 21 Jul
 2022 13:30:38 +0000
Received: from VI1PR04MB5807.eurprd04.prod.outlook.com
 ([fe80::1df3:3463:6004:6e27]) by VI1PR04MB5807.eurprd04.prod.outlook.com
 ([fe80::1df3:3463:6004:6e27%4]) with mapi id 15.20.5458.018; Thu, 21 Jul 2022
 13:30:37 +0000
From:   Camelia Alexandra Groza <camelia.groza@nxp.com>
To:     Sean Anderson <sean.anderson@seco.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@armlinux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sean Anderson <sean.anderson@seco.com>
Subject: RE: [PATCH net-next v3 39/47] net: fman: memac: Add serdes support
Thread-Topic: [PATCH net-next v3 39/47] net: fman: memac: Add serdes support
Thread-Index: AQHYmJcSjDRhpKy6Qk2ihwHZ5ZBFnq2I17xA
Date:   Thu, 21 Jul 2022 13:30:37 +0000
Message-ID: <VI1PR04MB58071192E279070C90F81843F2919@VI1PR04MB5807.eurprd04.prod.outlook.com>
References: <20220715215954.1449214-1-sean.anderson@seco.com>
 <20220715215954.1449214-40-sean.anderson@seco.com>
In-Reply-To: <20220715215954.1449214-40-sean.anderson@seco.com>
Accept-Language: en-GB, ro-RO, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d142825f-c703-49ab-5ea5-08da6b1d32d1
x-ms-traffictypediagnostic: AS8PR04MB8401:EE_
x-ld-processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: CiIgsNueOg1aacCBqvqjIhx2Lk0Q5W+/bTBI9jk8OFUoi6OGmnmkwgpTWVNZk9/wvef5N+haQ/GPTtt9vRzz1Ktp4r3iiS40oBB0bBlceNQ/rKn7FKZfn4tg2SFjeRmCMDFqE+jcDxQf0zaoVH64qY6iesaz6qleI/cAm3mJEjoPSCS+76bQZ4x9N22nTfdirf0OAIQ04GOhnKdMxOMWasCgOxw45kgjwxEgoUK7/4G5pbQSbT+kvJdWyLFK6lmU2QrN+hAa15w9I7yVmw2XwBBeNDHXgJRrsiuX/rLzzSDPlsKr88UjW1ZUwflavF8IFuF19Cz5GzgavPEFiZwMqz4crpUkHDeDB26ZrE2eG7RbRVYcpRZv2sB2cc5BVRhecWBn3ji4ofpGdP9nQJJRW4lsLx+OjSwWGsbYPyOusioIUALuQ+14VoLKDZ06M3hXk3rA368HhJAM/nV9svk7f4vwZxtSNpqkLwi8eIW20llGUseaR33CNaXfx6+M/AGD2jMpOP4cQRRdzOX3ejewwWZ4U4T32Gib4Ib42IKDtDUj+3PVfoe/Q1IQTC2EUfhAsctnIDLYdFUwnvYGq/xoNvaPbI0HoFUzpcLX98gQ17mtqhStbKnoHMQ5nt1TPLrD2XW+wuVbMPZR/fBrwQkX/JS2TJbw85oZiNrk3VUj/A9QQqfiu/6N3HKsHXcpj185BkbgbEyNCWydX5AArTQicnMZ0+Dki0todNCZN1VnYBOtGEZQo9/uLt0qo+ssfiDlCm177hCcleQB3CfaTWjJ54z0EQLEPwnBHP/8znV2iHU2as+rXMZBa5k+ZQWaSPMg
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5807.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(136003)(376002)(396003)(39860400002)(366004)(122000001)(33656002)(2906002)(110136005)(54906003)(9686003)(316002)(38100700002)(478600001)(53546011)(7696005)(186003)(8936002)(55016003)(76116006)(8676002)(66556008)(64756008)(4326008)(5660300002)(66476007)(71200400001)(66946007)(26005)(66446008)(38070700005)(86362001)(6506007)(41300700001)(55236004)(83380400001)(52536014);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?AUWKVo7M4HmBNta+L6UMzdz3nfjmIm/J8Vo+KMdDBinUDblU/0QwEe2vWeDu?=
 =?us-ascii?Q?RppSs2zGKUVa853YgSgnfCAzYmBxjn4GyM7GY3HLxGYqv40iqlDoYcwQ79gv?=
 =?us-ascii?Q?+5KJ0UBrzoGgKLO4v/KatkpImsefi1fCmv3oQm/yPNMTFK1srxCxnZMrHdt4?=
 =?us-ascii?Q?OxYdU5g2KJ0CSpDcZS6WI6PKq5Rdp5VEZmBcYgDV3MRXWF0I91/+Dn8NA4Bs?=
 =?us-ascii?Q?Kw5lRLbL5qnKt7MDiy3FowNn4jqsi07aD7V47cJyBne18IhPBntXI5JDhqqf?=
 =?us-ascii?Q?3WRlxdh1TJD4iSeRIGIhs70EhHaC2aB9Z7n49PEfs4nvwemDrjMVgqDsrPOX?=
 =?us-ascii?Q?my4rF7d1JAy//8tJRQnvUS7gQgAMt7pim8J8UMdccGxyetQktrxi3d193hqv?=
 =?us-ascii?Q?74xo51wtnwUL8zQGNhjp+vNlg4WOloUznp4+QVcKk1Lp1di2Zu9EJN1+35NW?=
 =?us-ascii?Q?AtYlBlkebFaq0GvA7gGOWxUAOyKbWN7grb8FvJF6BT1scz+5H4BPld1N9gtD?=
 =?us-ascii?Q?0o25Q2xI6FqpxMkM2hOq5UsAOOWgdojeDEbzfXMbgEi01x1PYwSl5rVJC22q?=
 =?us-ascii?Q?8eHJ7zbM53JfNjQDoAi7uQe8bjgxTnKSGHkBpQMfqZzNpfVb73TduHFcQ47I?=
 =?us-ascii?Q?NzGQnyX2L4nCvVzDRNijdeqZHFnbhGCCAKn3/zkC1oEbaQTgm4FOYKrfnZB5?=
 =?us-ascii?Q?AayhPCd7wbBmWDzsRTe+yfp02GPXk8X8QHFhsF8LSt/UJ9Hnqd2vpTR5wW+R?=
 =?us-ascii?Q?qQ9YHcoopnrkTC05M4mVIGhJ5mWYFNNdVp9scPMIfE7JpqbcKZO642xxR4bb?=
 =?us-ascii?Q?Ys4QBTH9BF2vpTMbYharVwJNndLntVSq0ZWqZabKHMsE9NMtkypMW9n94VUt?=
 =?us-ascii?Q?Etei3vu7cItfe9cW1Vw4fm9kK/NwOHrQvjstbgpPvS/6AxMlU2Sb7WIk+SAj?=
 =?us-ascii?Q?zRPHGY0Sw4tSQo40BmT9GW9HjOiXFzDa08VGv+zauHC3QxhxZ9KjT/3l9vRa?=
 =?us-ascii?Q?KM7G/KIys2sGfd2+07ChdLolzBouAEBOgD58KoL+wmA57QqTNdnSrAcuEpp4?=
 =?us-ascii?Q?sVIFYJJbWLGJ16ATIQ+Y9Rl/dKcpDpzx4iDrHkmm2qsdXByjFM7b1++C8Vio?=
 =?us-ascii?Q?RVY8fpRaOHJjto6W7GYb8CvYqsD31Ra2mAIr4mhHirs3f4fVb/Y891E7EaAF?=
 =?us-ascii?Q?mYJS5U2aJzbdHtiVTA0dchCild/NYDdqmCa2EPVWtN4CH5UYPCesgH7gLkgM?=
 =?us-ascii?Q?sCifHN9WljjbD4Mei6LEj3DDYjjndnJv+kvPGYbZleFAAJBo4CD5uZUVI8ze?=
 =?us-ascii?Q?O0/EpwMRevlSISlvNLnOcDG8+wPjeQrPtC+Yu3RSwRrzou8ke9E9F8ukJ/LR?=
 =?us-ascii?Q?ZXTgVtHhJQUrpb+nYgqbiWvb4M6CERhUFq5BdsxCQJ3wzcTFTr1NEgeA4i7H?=
 =?us-ascii?Q?tZMRUjbS7pske0phYYC3+AdIDvF1Nc3aytcmHT2QjnlZAJmstUi08yRZ4HFA?=
 =?us-ascii?Q?uAvT5EByYrp7Nt9A8oB6OWgz+E1kdF4M9yxJxkX/xOPH34MQFecbq+wggDI+?=
 =?us-ascii?Q?1N4PlxjvrxLUtOHrZHbBdOwhgoskihVH/FoM/cp0?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5807.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d142825f-c703-49ab-5ea5-08da6b1d32d1
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jul 2022 13:30:37.6527
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5rTbba5Lwp94ejpL4yaEVQk25r7hQ/dMGCBaQC4lYGQn5GmcaGX3aXdaJyT5+jjWODiuRdLQgzuojF3Xd0vxxA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB8401
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Sean Anderson <sean.anderson@seco.com>
> Sent: Saturday, July 16, 2022 1:00
> To: David S . Miller <davem@davemloft.net>; Jakub Kicinski
> <kuba@kernel.org>; Madalin Bucur <madalin.bucur@nxp.com>;
> netdev@vger.kernel.org
> Cc: Paolo Abeni <pabeni@redhat.com>; Eric Dumazet
> <edumazet@google.com>; linux-arm-kernel@lists.infradead.org; Russell
> King <linux@armlinux.org.uk>; linux-kernel@vger.kernel.org; Sean Anderson
> <sean.anderson@seco.com>
> Subject: [PATCH net-next v3 39/47] net: fman: memac: Add serdes support
>=20
> This adds support for using a serdes which has to be configured. This is
> primarly in preparation for the next commit, which will then change the
> serdes mode dynamically.
>=20
> Signed-off-by: Sean Anderson <sean.anderson@seco.com>
> ---
>=20
> (no changes since v1)
>=20
>  .../net/ethernet/freescale/fman/fman_memac.c  | 48
> ++++++++++++++++++-
>  1 file changed, 46 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/freescale/fman/fman_memac.c
> b/drivers/net/ethernet/freescale/fman/fman_memac.c
> index 02b3a0a2d5d1..a62fe860b1d0 100644
> --- a/drivers/net/ethernet/freescale/fman/fman_memac.c
> +++ b/drivers/net/ethernet/freescale/fman/fman_memac.c
> @@ -13,6 +13,7 @@
>  #include <linux/io.h>
>  #include <linux/phy.h>
>  #include <linux/phy_fixed.h>
> +#include <linux/phy/phy.h>
>  #include <linux/of_mdio.h>
>=20
>  /* PCS registers */
> @@ -324,6 +325,7 @@ struct fman_mac {
>  	void *fm;
>  	struct fman_rev_info fm_rev_info;
>  	bool basex_if;
> +	struct phy *serdes;
>  	struct phy_device *pcsphy;
>  	bool allmulti_enabled;
>  };
> @@ -1203,17 +1205,55 @@ int memac_initialization(struct mac_device
> *mac_dev,
>  		}
>  	}
>=20
> +	memac->serdes =3D devm_of_phy_get(mac_dev->dev, mac_node,
> "serdes");

devm_of_phy_get returns -ENOSYS on PPC builds because CONFIG_GENERIC_PHY is=
n't
enabled by default. Please add a dependency.

> +	if (PTR_ERR(memac->serdes) =3D=3D -ENODEV) {
> +		memac->serdes =3D NULL;
> +	} else if (IS_ERR(memac->serdes)) {
> +		err =3D PTR_ERR(memac->serdes);
> +		dev_err_probe(mac_dev->dev, err, "could not get
> serdes\n");
> +		goto _return_fm_mac_free;
> +	} else {
> +		err =3D phy_init(memac->serdes);
> +		if (err) {
> +			dev_err_probe(mac_dev->dev, err,
> +				      "could not initialize serdes\n");
> +			goto _return_fm_mac_free;
> +		}
> +
> +		err =3D phy_power_on(memac->serdes);
> +		if (err) {
> +			dev_err_probe(mac_dev->dev, err,
> +				      "could not power on serdes\n");
> +			goto _return_phy_exit;
> +		}
> +
> +		if (memac->phy_if =3D=3D PHY_INTERFACE_MODE_SGMII ||
> +		    memac->phy_if =3D=3D PHY_INTERFACE_MODE_1000BASEX ||
> +		    memac->phy_if =3D=3D PHY_INTERFACE_MODE_2500BASEX ||
> +		    memac->phy_if =3D=3D PHY_INTERFACE_MODE_QSGMII ||
> +		    memac->phy_if =3D=3D PHY_INTERFACE_MODE_XGMII) {
> +			err =3D phy_set_mode_ext(memac->serdes,
> PHY_MODE_ETHERNET,
> +					       memac->phy_if);
> +			if (err) {
> +				dev_err_probe(mac_dev->dev, err,
> +					      "could not set serdes mode
> to %s\n",
> +					      phy_modes(memac->phy_if));
> +				goto _return_phy_power_off;
> +			}
> +		}
> +	}
> +
>  	if (!mac_dev->phy_node && of_phy_is_fixed_link(mac_node)) {
>  		struct phy_device *phy;
>=20
>  		err =3D of_phy_register_fixed_link(mac_node);
>  		if (err)
> -			goto _return_fm_mac_free;
> +			goto _return_phy_power_off;
>=20
>  		fixed_link =3D kzalloc(sizeof(*fixed_link), GFP_KERNEL);
>  		if (!fixed_link) {
>  			err =3D -ENOMEM;
> -			goto _return_fm_mac_free;
> +			goto _return_phy_power_off;
>  		}
>=20
>  		mac_dev->phy_node =3D of_node_get(mac_node);
> @@ -1242,6 +1282,10 @@ int memac_initialization(struct mac_device
> *mac_dev,
>=20
>  	goto _return;
>=20
> +_return_phy_power_off:
> +	phy_power_off(memac->serdes);
> +_return_phy_exit:
> +	phy_exit(memac->serdes);
>  _return_fixed_link_free:
>  	kfree(fixed_link);

_return_fixed_link_free should execute before _return_phy_power_off and _re=
turn_phy_exit

>  _return_fm_mac_free:
> --
> 2.35.1.1320.gc452695387.dirty


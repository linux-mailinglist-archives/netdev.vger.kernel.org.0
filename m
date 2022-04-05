Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7993D4F42E6
	for <lists+netdev@lfdr.de>; Tue,  5 Apr 2022 23:52:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235290AbiDEOWr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Apr 2022 10:22:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357271AbiDEM5b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Apr 2022 08:57:31 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2073.outbound.protection.outlook.com [40.107.236.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F39AD6F49F;
        Tue,  5 Apr 2022 05:00:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IO1nE3l+1szmvrijggntt9Ar/aaXvjhVPs7NZwHkpGc5HZW4bxeKjP7beZQG4wXL7GW+tswFuzsgPB8l75SwD65AVG6M90+mqxCYhadDWbfmAOLa/S0hyHdH9xNjh1Jkz1K5HZBte4j8oZ2e9x6WthDh10lnGix0J26BWEcbxaeVWoqejg08FU+yuSg6a1fs0HwTIwlmRZZi8cX4/bdpkyeGLPbrbNY0CI0AA7fe0GtSO9dkGuZuM1YaSLIn3vJ8nLEFfW13ZE/GWsne7Cc9ATAS+mQqw5r/7P86H/1RCrPCZGWtwHlaYePQruNBIV154KSV1AQKGIWA5SK3ZC3irQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=W3vawUHpoQkgZFwy6m70zJKZcdewOxi44jvaLYUFnmY=;
 b=j9TEGKHjN9+aRuNOGISfS1RhhmYTh0dn17jka8MFjZ0UsY1E3b6iTXBVeJzWPpDHG/1L2WbY57ds6gsEc63mkc8l8xzD3elmdiWonsulozdu0YuJcLGgyyErjqlQNtALUw6Ry/f9TmK+ru4kF56XNrol+3yEfTiaAvtfEoUeGg7PLCDpt8awJ3wEaVeQNhfS8/k3thiARKrRdGKNyfIkJXVPfjx3Ya/9HaJ5l60qnvkFB3OVUlWOaucEmr5k7G1Olvf1tKZeYLiaBLHQ05+Pw5CaJWl0hDgJef5UP85DgHZkbsIGobIZllLMOl0CRfrUbc+ngnD/UK/gMv/CoTGj8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=xilinx.com; dmarc=pass action=none header.from=xilinx.com;
 dkim=pass header.d=xilinx.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W3vawUHpoQkgZFwy6m70zJKZcdewOxi44jvaLYUFnmY=;
 b=DOe7ot1yfgraBjMBf4NMhYEneb/dcwlEkph23tJ0lpELJfd7IyrWtJuNV2MpxBhufKCjv+W2sPL+/F/F4nfQE3zu6WOtlb9r3zWjPHYTAdqcLs4mXLzCPO5PUrQaztdc9Fxdxf8x9ZmGnk2H/JM5xkLjILvk+o0XnuKOeRPavzY=
Received: from SA1PR02MB8560.namprd02.prod.outlook.com (2603:10b6:806:1fb::24)
 by BYAPR02MB4152.namprd02.prod.outlook.com (2603:10b6:a02:fa::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.31; Tue, 5 Apr
 2022 12:00:00 +0000
Received: from SA1PR02MB8560.namprd02.prod.outlook.com
 ([fe80::e099:e670:bcf0:a434]) by SA1PR02MB8560.namprd02.prod.outlook.com
 ([fe80::e099:e670:bcf0:a434%7]) with mapi id 15.20.5123.031; Tue, 5 Apr 2022
 12:00:00 +0000
From:   Radhey Shyam Pandey <radheys@xilinx.com>
To:     Andy Chiu <andy.chiu@sifive.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Michal Simek <michals@xilinx.com>
CC:     "andrew@lunn.ch" <andrew@lunn.ch>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "krzk+dt@kernel.org" <krzk+dt@kernel.org>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Greentime Hu <greentime.hu@sifive.com>,
        Robert Hancock <robert.hancock@calian.com>
Subject: RE: [PATCH v8 net-next 1/4] net: axienet: setup mdio unconditionally
Thread-Topic: [PATCH v8 net-next 1/4] net: axienet: setup mdio unconditionally
Thread-Index: AQHYSM9PmQgYuILVHUOoK5UhMKMwEazhNxMQ
Date:   Tue, 5 Apr 2022 12:00:00 +0000
Message-ID: <SA1PR02MB85607E415BBAD581AD02DE40C7E49@SA1PR02MB8560.namprd02.prod.outlook.com>
References: <20220405091929.670951-1-andy.chiu@sifive.com>
 <20220405091929.670951-2-andy.chiu@sifive.com>
In-Reply-To: <20220405091929.670951-2-andy.chiu@sifive.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=xilinx.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0b33c9e0-7dc7-4c96-4932-08da16fbcfe0
x-ms-traffictypediagnostic: BYAPR02MB4152:EE_
x-microsoft-antispam-prvs: <BYAPR02MB4152BB2E9AFC244C34AABF35C7E49@BYAPR02MB4152.namprd02.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Jq1hUi2O6iXiN7Xt/rSRZutYLn6EI8CXDI/KeUQcc6kMlY78g5SxUI3sbr3UCKjvhsPH16Hhis1HeMtKuRKuZzp36d9bD/jh5U79beazJ0aQtCn1UuJ1QA2H5RuPDI7z3QDfg8de3uP+p3IeeU72/wDx0kyvlzGpmVSh3XmiJp1SV8ZMopAmY35akDzk8cfIxi7bAwtRsfANk9jtLEVXePjGiOwCrluJMUTS9jIE/tfK4Qyrk7ZdO/NtVT7q2MuADMWsiXeJm04lVzAA+MWngCImRo3nPhTddfN+Q/b1T3CUr+u6kpGACWUNUkTrbNuPpPGmeFxOdEORgOwBFB7om7dbN6RYrEa9ZeyX91lnNECljJx+WcrXsEkWvSCML30cWFdTa4tHnKBi+xNsm2saf/OOVpq+us+NruoZVKBPORP0ajZrDzB8Ms1J87wV2dqz257AOlSzAPMs1NNHyIYgWc6UqLpgRMPYEjVPLgdHp81KNCZAoHs4IKsKzlNlaOo7BkK81+ybYjPYYZnhzNrmDP66XJot9IwoOzXj8LRHy4HME2443KeWXQCGlkucb1rqRPF0HgjNYAt+r0ndkqGDZh3XM8acFJMiRXZSOyre7Bm6LifhLg/IUoIgEmxnxsylAScUHHFOA5iEjMkar7l6fKrrPSdjIzhmRF9CQPrTxzOWyqO+TyZLFArbt6Q7V3B1Pxx/2Vk2VA+8+pPbpNIufA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR02MB8560.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(38070700005)(66476007)(6636002)(64756008)(8676002)(186003)(66446008)(66946007)(4326008)(66556008)(55016003)(110136005)(71200400001)(76116006)(508600001)(316002)(54906003)(52536014)(86362001)(2906002)(7416002)(6506007)(7696005)(38100700002)(53546011)(33656002)(83380400001)(8936002)(9686003)(5660300002)(122000001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 2
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?ULZu+k4koZfpajEk+ar5ZrIRCeVtNPKoXM9zYkPaDwjMB+uWwJyhrhmqKEpg?=
 =?us-ascii?Q?Wy9xUNNl4AHYUlBoPGGLTN49X6wEscMxlcBEydlWE25DumCUsjuwX/Oo1+ZY?=
 =?us-ascii?Q?Ny5gJzXLSAmh+kBrmyfhtAKz4MsnxUCDlBncMmStudivAUoJi+mAJMKqz/B3?=
 =?us-ascii?Q?4bLwWZahrB580a/xOTT7wNSsxvMaKE/CigOjgON3XmS0j49wLcE+AoIxRrME?=
 =?us-ascii?Q?QgfLro3ssxNoXAEFqwgHf1hSlP5u+yAv07AQ/993Jl9hpqMhctH5gYDI558d?=
 =?us-ascii?Q?/5jt9fZVazBe9imySndovadv4R4cndiwGMcEAXyzPYbfJ9OZ9lm6AgM/MgeI?=
 =?us-ascii?Q?llKEhj8KvcMo1FOVHzFPRwm0INwNstmYFoTeXtR/pU8SSlleN4dHBqxRNeHl?=
 =?us-ascii?Q?D6eA2wjYbo5OJa4rWAp+fM3vpjK0PrsJheMtA4hnjRcye/0poF3SeD+56jQG?=
 =?us-ascii?Q?gazVftv50J6QraOIgo7aIyk6Uxj4rGwdfB+tMs0kY9+LQVIP1XnhSsImHdVe?=
 =?us-ascii?Q?ZzTE8sv9uGQm0/BH/Dtcfzg1Rt8lS+T3f7YHBPyxZ0vUZIEHh+TdVorbe4gx?=
 =?us-ascii?Q?8bBMkrVzoErd+2RPhNHp5lH2O3MN741PcsxmP+7eoCX1W/VURV4OsMRTBNM+?=
 =?us-ascii?Q?HKEaX3f6RI6QZRsk/Tn6vaMRWgNumu8aM++FWLwcB/bFxHuYsEFjxezbthtN?=
 =?us-ascii?Q?uQmnOueh12pn+sW17lFDkoDL4XmbosYprJvaSnOracMAQEHbSwT4sADMTuxL?=
 =?us-ascii?Q?Bsbr5CArgxAT35Uc96UcDh6rX3mZhtO4FSz92u/wPffefTNA238om450FMes?=
 =?us-ascii?Q?L4jUOuanJ0G+rXAtsRqTcwV/Q5oU2TXAGx7ob3+m1ce/wNiXP/ifEy/DlEAN?=
 =?us-ascii?Q?xFHUES+ChlgmNrxHSMWAa/HUjuHtzPzZtHWIBwoA6xvycriE9DKhx/Y/3p9f?=
 =?us-ascii?Q?oFnNFVaX4cdRaTvZNjaFTE5ZYW5VWxUXUyoBtN3ftFB/9EK3tERWUaxXBufL?=
 =?us-ascii?Q?XRgYI44XJjh1bFJwHPNe3m+oxrJfNuF9AHk7mQ+yNWtlEwU69uFY+onMhTts?=
 =?us-ascii?Q?qwlQprIkEGvFgw2zLxkQJ2b3OB7UCO4mi1DgwKYwv4QvRBn3ctIGn9eq/UEz?=
 =?us-ascii?Q?KXtoj3CIUg/5Iqg57YuJWrDKJkvD6EGjKQnRecpExU6SOZ/uou/Ol6q+2IN6?=
 =?us-ascii?Q?hnlTDckyoxALHwOidEmmwD+ToIVgOsGxrSedwtjn1uBUQjlUiV3d0hVRAq2G?=
 =?us-ascii?Q?G97f5ouBnFKKrs/+DBan0LDQll3S4d1Zb1MNP2saXIz6xXMZpT5Ecg+y393m?=
 =?us-ascii?Q?MQAcXd3HmsyhYs4s0VFmdhn1WkhufJV9jBU9flEQVa2C8NhR9ZxLURC2xGP/?=
 =?us-ascii?Q?eF3X6BWzQeXEdVG6Ez/dCxoXoba8sQM9YheVdYgMdgm0vhYBSfNgfx54g2kS?=
 =?us-ascii?Q?oPGGISaDwMr0VR8ckGlm3bc3bvrj9i0IogtSvz8Rp5m+xBfOJVP6ViQvo9cr?=
 =?us-ascii?Q?5Vz3PnxQ1vcAK1F61qUNzZSg9zJlY0NjtjGDRS2fpTiAbnyNzKVzy5cGf4YE?=
 =?us-ascii?Q?+OYYDRghV8kZ1tAvoq7mBFDbHrdcelRfWG8zIQ9ckYZWSLOqWiLcAk+JsAgw?=
 =?us-ascii?Q?BLyK036kJy8od5TK6bWtBV9f0JC1Fl4NE/JIfRKKXAjyb/b/ewSbaPA6K55F?=
 =?us-ascii?Q?1pkkSKZLZAR1Iy958pr67C09zghIt6itZ0hTp5WC9U+rHG4BjL9oQzi5E5lt?=
 =?us-ascii?Q?ecKEln2unPUlLVjCxPttpMt2dO8X/yCZ+930hLeHap9E0yqK832UG10W67T0?=
x-ms-exchange-antispam-messagedata-1: B1DAb/UV+4vryA==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR02MB8560.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b33c9e0-7dc7-4c96-4932-08da16fbcfe0
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Apr 2022 12:00:00.5594
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: abdp0xe26eoX2fFaSW2sYKza4Gw/DaTr91f8EC5B21unvUHpK2LGv8fBcFOvOvXdWAe8F0sKdN5CMRcyZrYoTA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR02MB4152
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Andy Chiu <andy.chiu@sifive.com>
> Sent: Tuesday, April 5, 2022 2:49 PM
> To: davem@davemloft.net; Michal Simek <michals@xilinx.com>; Radhey
> Shyam Pandey <radheys@xilinx.com>
> Cc: andrew@lunn.ch; kuba@kernel.org; pabeni@redhat.com;
> robh+dt@kernel.org; krzk+dt@kernel.org; linux@armlinux.org.uk;
> netdev@vger.kernel.org; devicetree@vger.kernel.org; Andy Chiu
> <andy.chiu@sifive.com>; Greentime Hu <greentime.hu@sifive.com>; Robert
> Hancock <robert.hancock@calian.com>
> Subject: [PATCH v8 net-next 1/4] net: axienet: setup mdio unconditionally
>=20
> The call to axienet_mdio_setup should not depend on whether "phy-node"
> pressents on the DT. Besides, since `lp->phy_node` is used if PHY is in S=
GMII or
:s/pressents/present

> 100Base-X modes, move it into the if statement. And the next patch will
> remove `lp->phy_node` from driver's private structure and do an of_node_p=
ut
> on it right away after use since it is not used elsewhere.
>=20
> Signed-off-by: Andy Chiu <andy.chiu@sifive.com>
> Reviewed-by: Greentime Hu <greentime.hu@sifive.com>
> Reviewed-by: Robert Hancock <robert.hancock@calian.com>

Reviewed-by: Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
> ---
>  drivers/net/ethernet/xilinx/xilinx_axienet_main.c | 13 ++++++-------
>  1 file changed, 6 insertions(+), 7 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
> b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
> index c7eb05e4a6bf..78a991bbbcf9 100644
> --- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
> +++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
> @@ -2064,15 +2064,14 @@ static int axienet_probe(struct platform_device
> *pdev)
>  	if (ret)
>  		goto cleanup_clk;
>=20
> -	lp->phy_node =3D of_parse_phandle(pdev->dev.of_node, "phy-handle",
> 0);
> -	if (lp->phy_node) {
> -		ret =3D axienet_mdio_setup(lp);
> -		if (ret)
> -			dev_warn(&pdev->dev,
> -				 "error registering MDIO bus: %d\n", ret);
> -	}
> +	ret =3D axienet_mdio_setup(lp);
> +	if (ret)
> +		dev_warn(&pdev->dev,
> +			 "error registering MDIO bus: %d\n", ret);
> +
>  	if (lp->phy_mode =3D=3D PHY_INTERFACE_MODE_SGMII ||
>  	    lp->phy_mode =3D=3D PHY_INTERFACE_MODE_1000BASEX) {
> +		lp->phy_node =3D of_parse_phandle(pdev->dev.of_node, "phy-
> handle", 0);
>  		if (!lp->phy_node) {
>  			dev_err(&pdev->dev, "phy-handle required for
> 1000BaseX/SGMII\n");
>  			ret =3D -EINVAL;
> --
> 2.34.1


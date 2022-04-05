Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5F344F3FB2
	for <lists+netdev@lfdr.de>; Tue,  5 Apr 2022 23:04:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1386690AbiDEOY4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Apr 2022 10:24:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1387927AbiDENUE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Apr 2022 09:20:04 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam07on2050.outbound.protection.outlook.com [40.107.95.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFA15D8F79;
        Tue,  5 Apr 2022 05:23:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IMheclv0ajVXVvVZRLNs/mcmUIi+Z0XU848D3Ddezr6OT53iu5U87U2yIyM6ksWCvbjCzj3YXReh6IXa3rcyrWp8KX5w8+1sHo9ePRcmCTXv6BtpPpoSZ2bVQtTmOqyEnvSem+RaEZxYX7l0tVb/gyuPHykpey9vyVm4lg92LwkM0Z0zd5HhRdfT3MIODyZ7Ol7/qAL3W1pLQC2F7gjnSyeT9BkOm5DytyUQSmKGUvHQQqmQFk8BasoYevNw2SUl6Owi8lPX81Zw6JodA+rvriQftxABtq41Nznanxej2f6urGmIiP5ey3EROQcYisxEhf9bkojOCVWgdyEKgpPgeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wsjho3S897RGCNl33dTpQyQ6qUpxP2ZBge2gw/AAxNU=;
 b=jqKfcEjhKmB4DZBqcy1RFQfI8+YH/Um/+jVYuleYIOiACoKISckBYkFqP5SHGbF60tXtWSz7AKco8Sk80ieTW05WNuR2wuO7Jz0ApicTLH42cI1sdq45fkvVTTIK3OZ/mIQ9Mc4kDddjWMgGza/lpeMrBOFlVat7z8AH2tWZMKpVEmx30vYAID44FbdRx7BVh3dJ095Bk0AJZ0KggCngZ/2jQBgB4dYmAoOrHQG/KK4bdl2/DmToD1kOgvfMHclDvrVz2i7VHYeaifW83UJaIUOrRm4YEnXYEaUiADGXVrkvEVzbSFbn7syAGVh4PKnSr5nbhhZ6DnKvfUBHox0nOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=xilinx.com; dmarc=pass action=none header.from=xilinx.com;
 dkim=pass header.d=xilinx.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wsjho3S897RGCNl33dTpQyQ6qUpxP2ZBge2gw/AAxNU=;
 b=rzQtBgoSFmX3Aqtyp9S0wY23cbeHTs8q91CAW74jz1r79eF4ENwDY6diWma8Bp2TnQYUs6zns1cSaKwVzIddBeI+fuuolvkOSqTbZs/sSl3EqQkeBCyqgTPuuUdFQKntADsY/vL+K3dZDd8dSgE7pvE7+briLroQAMDox6kbzC0=
Received: from SA1PR02MB8560.namprd02.prod.outlook.com (2603:10b6:806:1fb::24)
 by CY4PR02MB2406.namprd02.prod.outlook.com (2603:10b6:903:b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.31; Tue, 5 Apr
 2022 12:23:28 +0000
Received: from SA1PR02MB8560.namprd02.prod.outlook.com
 ([fe80::e099:e670:bcf0:a434]) by SA1PR02MB8560.namprd02.prod.outlook.com
 ([fe80::e099:e670:bcf0:a434%7]) with mapi id 15.20.5123.031; Tue, 5 Apr 2022
 12:23:28 +0000
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
Subject: RE: [PATCH v8 net-next 4/4] net: axiemac: use a phandle to reference
 pcs_phy
Thread-Topic: [PATCH v8 net-next 4/4] net: axiemac: use a phandle to reference
 pcs_phy
Thread-Index: AQHYSM9VGN8whaVs50yl0hdiIozB1qzhPg2g
Date:   Tue, 5 Apr 2022 12:23:28 +0000
Message-ID: <SA1PR02MB85609D7ECEF5454B6D84BAC9C7E49@SA1PR02MB8560.namprd02.prod.outlook.com>
References: <20220405091929.670951-1-andy.chiu@sifive.com>
 <20220405091929.670951-5-andy.chiu@sifive.com>
In-Reply-To: <20220405091929.670951-5-andy.chiu@sifive.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=xilinx.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d75e2620-2892-4289-3897-08da16ff16df
x-ms-traffictypediagnostic: CY4PR02MB2406:EE_
x-microsoft-antispam-prvs: <CY4PR02MB240683E766F2213FE9519C66C7E49@CY4PR02MB2406.namprd02.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: UNdG5Hn8CYMr8+owtz+0tmszp5REhOI+vVBhVaHKYG4DsSDif0CxvBVJE3o1mnvoapobb6ewAg7zQ0zXXTIpuFMwH+xEV0fohDgIZAMZqpwyNDv908qHsuaFSely0RR0Skjnc/Mdwpvn40EgeGn/Ft9j2S8i4Kj9Pxtu71+DHCqL+3Q4zrAFfVapAoNm+P5M2BDOhiDa2VXYcvqlF7Jnc0YXNhChgS7NtR1ClR9/qcWPBP4Orcga9QSXt0d0shaln7KNSBHX9YIIVCAddpWCpNps+Zn4QlKsTnZ6spbQ7xl1rBeZ3Ka9pZSEiXC+xcbQtmjzbIBBP7AFAkQNOOHE2FWwGrZZifIiye80mtExGjI5cVgRCWEVQJOl9VbG9BsuiQUgY2xLMvnOxO7DY6diOpZ9XX8aNvZ5uI0+p73qpa4w4ekOKZou4vcSau6w5dEacWR9grX8O4u8/nw5MsKoHYxwPu5acrZMkN2wr8e0WQ7EyOq30WnTSVyMgVPxmzaM/aADSx1HFiweKvi488nmLkAQ+9bslg+EqJpDjn0ROmhUqHG3nOK3/9T7bmJcuVvtgr4eRXRXbVv0aHcWI2X3YmMFI5WOCqg5qE8C9nrtCL35oNNCeoeBr1z1GHb8fvXMlTcQz6YjJKxmLoNJL9lTg80TWUnN2D07cAUlUxvlGEccaBqW/IiI7ziAs6bZ4t0y4TqKzt9gEgyBQLJxUAfPSg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR02MB8560.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(33656002)(186003)(66946007)(38070700005)(6636002)(110136005)(8676002)(316002)(54906003)(508600001)(38100700002)(66556008)(66476007)(66446008)(53546011)(7696005)(9686003)(4326008)(76116006)(64756008)(71200400001)(6506007)(5660300002)(52536014)(83380400001)(8936002)(7416002)(2906002)(86362001)(55016003)(122000001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 2
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?gAKppmXM+SvHOfQDdb+GwrC5jGyXbYDsZQaYatOSRhQ8cqZuBbwyeds0T9bX?=
 =?us-ascii?Q?i9UoJ3/NH1KNKjvpJ3+9H1Sh8v6Xn/tT3/aXX0l6gJI6DATQ8chZLKosgHJS?=
 =?us-ascii?Q?PQZLBFPwPjIlBw+BzfndSeMQkJ1a0nAUcZJ3a3aabMoe5GcoSbWfPdxuXBgp?=
 =?us-ascii?Q?TuuRIyRvsbq0oHcaKH0G6C6vY2qlKwM1jYioZdxdahxCvJoAMSszNiNaDyCu?=
 =?us-ascii?Q?hjJLuE5dJk+3FxampcH+pqi9l2Ysuh12AgJACpjXAduHS/rk+Uaywu9HHWza?=
 =?us-ascii?Q?+KA0dzMUGT8RoLPnY/RsseUdfuYEJKwyxip4kyf4QGACtlmUicTpsVp2EajB?=
 =?us-ascii?Q?LKqI6QZJPwNO46DXx41+ciD65iE2hlaa6HhNhInCFibTdZVzjWg6tnmv9ntK?=
 =?us-ascii?Q?KM/kaI6NmoQkX1TYNuoeSxNgt+vWBRNBta349vscigg/ZXs3IFS6+uOemMIM?=
 =?us-ascii?Q?vwr6yxnYwI9z4e7pdMlOdlM+akiZonfLpaorxJyzOi2q/KPRxRZmu8kc/XEa?=
 =?us-ascii?Q?fPXAChrYDpLMjFKBQReJJGoVbl7jU3e8xYGEn86NKbKAF25c6wI+KdHnCRJ3?=
 =?us-ascii?Q?/ifjz+Jz67DkQbUZgKb5SwgLLZ7zflC/sBBlnqblU8GxN5hpAmoTeDq18rlu?=
 =?us-ascii?Q?xSyaxlvnbcBgWF3Fnjhv5+8pyZ6/ucTPtpmgSqYaBGKjf/V/dufPt3jklFK+?=
 =?us-ascii?Q?b97N+MV0nbKO7VLYGE+yuCXCVIjzRZUcsLVZnWYnO5DT+LxApCCKsHe9pSbt?=
 =?us-ascii?Q?I4m98NWfEdz/nmDs0vz2pf2lS6LUoetL4vEzFp7Wyefdn8DNULQrTxWW0TKN?=
 =?us-ascii?Q?F9WIX0tApXSDCzlDILwhNiVYbqmAIi2TOP+ZwBiJrYLUjArR86F5JxCIZeoj?=
 =?us-ascii?Q?PbgfyPtmPjf/lbOWrAnFgL9VG5C8PvYYZzitVkTuZENYyWkIzQm7pGJB3J/t?=
 =?us-ascii?Q?SSyA3U+zQSiOjrmn5E1aZgm31aTkcAHgl9xueq4MqvLDbVyttsQd7ecDD51t?=
 =?us-ascii?Q?7ZY5NwhllyC2X5meImX3bgWfQ8ERI5CZkVvmrz5UxObsLUFwU83zUqWyt4W7?=
 =?us-ascii?Q?lvyF/T7vbhxNyvFCDuirA503NA4coBKg+eUfBuA5kd32kizzz//tdw4cQNqW?=
 =?us-ascii?Q?Eyqc0Li63jRTa/3w1K+gMqgRLedYBkZZTLXK8zMtL+pJPaGBLTCcY8eVAtRZ?=
 =?us-ascii?Q?GFOJjAkJkpZIIoeBzJWN4hVzdeYp2OIVTVg3bzrA5rCr0SqL46a2fGHKO+CX?=
 =?us-ascii?Q?yy4dzFHPpk9lWQlzw7duyfdUtE9oL474eMwO7qtLm1UPzBinvgi7cK+RwT0k?=
 =?us-ascii?Q?VcjRksYG9ZS0GRisbtvenl200X9cMa0BIg0iZTTPYzJicGe0L5EzpYIkGxdK?=
 =?us-ascii?Q?+pTf+R828wfsv4Gv4d7ZwtBWKTB9ISITIlaTaA4MzRBIqY3WBMfqJRBlHawj?=
 =?us-ascii?Q?o+c25k2Uk8nxSLhbs3rSXpJwJNhNODbCfeCdZ+pmdw8P6J+8m5qW2/TJ/9uW?=
 =?us-ascii?Q?idl6c2Kg8ON9EfWTjvAGbhBfVWIMjBLj17odYlk8JYVUZ0xpEX4sDJWE8JCD?=
 =?us-ascii?Q?D7I65uOtAYcUEBwKZv0ramonIs7AEnFzomSplt6cKI4fLBGR5ScfTDfXVIYn?=
 =?us-ascii?Q?BNjNDCt3fhFd4gQ9k9rZ1Qhk2Sqgk8GfJFSCZrNOnpbrJPfEmec4qLLE4SMZ?=
 =?us-ascii?Q?xW+4FL8QBVkli1FtTwkrpa6AH5tK4jBjnzcwX/gHM0x9+V2RMiNhFKyaKJA9?=
 =?us-ascii?Q?rSpXMT3qTH/Yt9oMRX4SOO06NcKNjAjnveGkq1rd59VHgisUaWExsU8YgX5e?=
x-ms-exchange-antispam-messagedata-1: qG/hhuRJ43dnKQ==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR02MB8560.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d75e2620-2892-4289-3897-08da16ff16df
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Apr 2022 12:23:28.1764
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: capCyNepoaZQFN6MQrY7lm61gi3lycFjheV6mUZ5YKY0w7BW3M6mPIrHJKEao5pVERfFmsRKCX0sZylh6ajprw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR02MB2406
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
> Subject: [PATCH v8 net-next 4/4] net: axiemac: use a phandle to reference
> pcs_phy
>=20
> In some SGMII use cases where both a fixed link external PHY and the inte=
rnal
> PCS/PMA PHY need to be configured, we should explicitly use a phandle "pc=
s-
> phy" to get the reference to the PCS/PMA PHY. Otherwise, the driver would
> use "phy-handle" in the DT as the reference to both the external and the
> internal PCS/PMA PHY.
>=20
> In other cases where the core is connected to a SFP cage, we could still =
point
> phy-handle to the intenal PCS/PMA PHY, and let the driver connect to the =
SFP

Internal

> module, if exist, via phylink.
>=20
> Signed-off-by: Andy Chiu <andy.chiu@sifive.com>
> Reviewed-by: Greentime Hu <greentime.hu@sifive.com>
> Reviewed-by: Robert Hancock <robert.hancock@calian.com>
Reviewed-by: Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>

> ---
>  drivers/net/ethernet/xilinx/xilinx_axienet_main.c | 11 +++++++++--
>  1 file changed, 9 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
> b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
> index 3daef64a85bd..d6fc3f7acdf0 100644
> --- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
> +++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
> @@ -2071,9 +2071,16 @@ static int axienet_probe(struct platform_device
> *pdev)
>=20
>  	if (lp->phy_mode =3D=3D PHY_INTERFACE_MODE_SGMII ||
>  	    lp->phy_mode =3D=3D PHY_INTERFACE_MODE_1000BASEX) {
> -		np =3D of_parse_phandle(pdev->dev.of_node, "phy-handle", 0);
> +		np =3D of_parse_phandle(pdev->dev.of_node, "pcs-handle", 0);
>  		if (!np) {
> -			dev_err(&pdev->dev, "phy-handle required for
> 1000BaseX/SGMII\n");
> +			/* Deprecated: Always use "pcs-handle" for pcs_phy.
> +			 * Falling back to "phy-handle" here is only for
> +			 * backward compatibility with old device trees.
> +			 */
> +			np =3D of_parse_phandle(pdev->dev.of_node, "phy-
> handle", 0);
> +		}
> +		if (!np) {
> +			dev_err(&pdev->dev, "pcs-handle (preferred) or phy-
> handle required
> +for 1000BaseX/SGMII\n");
>  			ret =3D -EINVAL;
>  			goto cleanup_mdio;
>  		}
> --
> 2.34.1


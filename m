Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 282304F4381
	for <lists+netdev@lfdr.de>; Tue,  5 Apr 2022 23:59:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346024AbiDEOXm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Apr 2022 10:23:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354873AbiDENH2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Apr 2022 09:07:28 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2088.outbound.protection.outlook.com [40.107.92.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A728E205C0;
        Tue,  5 Apr 2022 05:09:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nPZOEnsp1i36mBnks/17kC2uLLwNM2m89LRkYYOkaKn7jVyQ0WerU/LLKpq4JINuQ9QOsMmiwZJpyMmOaWJXxYLU+Vxr09/ko2Wrba55q9rmAVil1v22NYuUHgbCoSSLCpLx7/WZ7AItqg0NzpdPSAfidM/bh2jxl512cAxC2ycqQd0TkvFnATepZLARczG0RNWJCXn2rhRtmzqsJFt1fSmS3ziqMEcWDUDV5vJWySqdRyqSx9NHs5j/R9idmv8ks2u+FgNvgIUHLqiHZscn12hyXOuFDKZaZIg+EoBPISk8t3HSV2HCi0b4lxhFqPWfbejo7CP7llhpl6QSYRT6VA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=km/3o5lSoLF5wj+JOW73SlRGF31zGU7XN8lk/59MzO8=;
 b=UAvjQpSnsNcvXfh40trGCZGqJR2kA74mPjRskxLrf7vjJu7eRrlBt/YbzKOPjvpsmwz3U5hri/g/Jie+EroGOdvWO5ZA7SwK4j0HE3Kw+KB0vHeuE5LpFFxUXhxAPztzTebRdpSHA7XYDhAUlTOYavHgAPTdc3O0RHSIPGKN/fQSfnXLLdEiIfI8hscMxpfl+H8TJ8Y+h9EF/YS+aPVUkdtWPP2BhRcl7BQIsW5Z/TQujZFTrZxb9mEYdcj6cMo2ReupjrTmIqZeBDedDn7mX6rtGTVPLvCI0rTCUJOWQFw3i0XL4Bzdk0g4EUWJXakJ7sS3ZYzepSuJmkktt8Chrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=xilinx.com; dmarc=pass action=none header.from=xilinx.com;
 dkim=pass header.d=xilinx.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=km/3o5lSoLF5wj+JOW73SlRGF31zGU7XN8lk/59MzO8=;
 b=quVjyWNcVjWoonN1LtzBYR76/y9ev02TeuNd7mxLgdWO5nan3kmALjE6n9OCtSXB6CAUI18O+5/IqzKky09z1IyT212cKgghorBOKuymSqIUa14btABQ1QBCbejhnMJ5N2vcaVm34KPMUA+6hZhWctORtN3RItwU9GU2ynF2a4k=
Received: from SA1PR02MB8560.namprd02.prod.outlook.com (2603:10b6:806:1fb::24)
 by SN6PR02MB4560.namprd02.prod.outlook.com (2603:10b6:805:b0::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.31; Tue, 5 Apr
 2022 12:09:40 +0000
Received: from SA1PR02MB8560.namprd02.prod.outlook.com
 ([fe80::e099:e670:bcf0:a434]) by SA1PR02MB8560.namprd02.prod.outlook.com
 ([fe80::e099:e670:bcf0:a434%7]) with mapi id 15.20.5123.031; Tue, 5 Apr 2022
 12:09:40 +0000
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
Subject: RE: [PATCH v8 net-next 2/4] net: axienet: factor out phy_node in
 struct axienet_local
Thread-Topic: [PATCH v8 net-next 2/4] net: axienet: factor out phy_node in
 struct axienet_local
Thread-Index: AQHYSM9TpeJKHeypBkieda1LhENo/6zhOj/A
Date:   Tue, 5 Apr 2022 12:09:40 +0000
Message-ID: <SA1PR02MB856090D65A74C6A47A7D80FCC7E49@SA1PR02MB8560.namprd02.prod.outlook.com>
References: <20220405091929.670951-1-andy.chiu@sifive.com>
 <20220405091929.670951-3-andy.chiu@sifive.com>
In-Reply-To: <20220405091929.670951-3-andy.chiu@sifive.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=xilinx.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2e9a3192-4732-433d-cbb4-08da16fd29a1
x-ms-traffictypediagnostic: SN6PR02MB4560:EE_
x-microsoft-antispam-prvs: <SN6PR02MB45605B79F2B2865D72D68382C7E49@SN6PR02MB4560.namprd02.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: m8MOoGCVSWIJMUTUA2tkC2TMwUon0mJSYrevRJGs49bSkhR1ptqHXULriYTDMC10cvpMmn/WRMt6Tm1fLd5r13NNiRUPenAoUS/IC6NzqAcQE6xRsbjlg5TyI6re0o6xWi37dbqcJy8uHAfJXWDKE5XqGaWCaLHYMLUKdy6WWhLSmyCCUXiMXxLjNFmth+EuF481h1mBdzrgYGhY4KFE5p1YtlDLkFwHiTY5DlolY9mQLQ7uTuOf54xJdfDgIuySAjNNSKqft4peUNUlRn1RI/pjQEtHEQIbwqnRKpicOF1+TIyWMBXUodFTSq3v7hBMSNvh6Kx5CBD0lwUodKyL8vJufQ/M5KVITRSztFSUFcrgb48uOU369fe4wXYdmv3AZPQeehiYTuWbSPJhSaqy5tfE/98DgufA8Vh9Cof8mU8cwWVAWLMuyBsJDw1sBsqO1N4pJuq8phZym3k3gQLxa9RI60BJyz2RKI/JflOEOYcoXdpgBmIufNfwNlf/oEbdJgOF/kFUSzM2xY8eIFP+HvTQyvCAEQoG6guTwlnFgktKxfV2UrMOprA5TiJ+4fr5c6ByHrMCb0fFrkqODjIjhYsqjzBWCjx7qp4K2uNlc7NK+DtbcF4gLx9jTSMR7TxN0Hzsg8ll+OSgU6jusG3kU0rSYc+jrsAOYE3rhit9h3208MK04cV1gyA4JXuXXxecGVSWV9Hita8lJApyBaG75Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR02MB8560.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(52536014)(8936002)(38100700002)(7416002)(33656002)(110136005)(316002)(38070700005)(7696005)(508600001)(55016003)(6506007)(5660300002)(71200400001)(54906003)(9686003)(6636002)(186003)(8676002)(53546011)(122000001)(66946007)(66446008)(4326008)(66476007)(66556008)(64756008)(83380400001)(86362001)(2906002)(76116006);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 2
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?HpGckH/AeVWQhb7t0iB263uyT2MPSIY5awZh0vsEGPWpH02kzw3cImo2F0uJ?=
 =?us-ascii?Q?5GYK+4qVnSEBoqHi2LASLfZxcJEoYeGdYpav/RK1zcvk5/kkLHzpwNJ/nc1a?=
 =?us-ascii?Q?VFPZx4ybWcbSwfLTRr9TcVfFO6TtHxWpG4tlQw+3MIPf1WnRa3wL1NopY2hf?=
 =?us-ascii?Q?0aKm2YmKaHqziJ/zOF93gc30ZNrrQ+x+p0SpAXPtwr7zlh3JTPAnhADe6dKl?=
 =?us-ascii?Q?LslgWbBuQXFXnjyzRPYXZi14aGOtd+Vt4/GJtgXhw0sPcHLiKF8Uc9DR26ky?=
 =?us-ascii?Q?2UkQdkGi7y1AJ87p/zz4Xv58XzqkArpkGbUnIBBn5VIzXDFQzornrUMs81qL?=
 =?us-ascii?Q?d819fPwal/GEBtaimNM0UoatP569a3B74UyYkSKJoDQF5uivwWt0G03yiSQV?=
 =?us-ascii?Q?YPhEx28J6g2PZXqE/bjDYUa6yAIrxIrsXxAug/deu252PClt/o419p+KKawM?=
 =?us-ascii?Q?lLLQKN9LbMVC28yH0f5Bnc//LdgrXuLfqufoCZkq2fRl8NmKud/6Rf1J3v/6?=
 =?us-ascii?Q?wlrw0fN9AH31QEwSgklcPFa3fofEPCgLckUtps/zzXvlpCRhVOdnYUdXI1dP?=
 =?us-ascii?Q?S/4uVTdJBN756M44z6lcRDQGSrIHfT5S+jDurEWcVeAaAGCdC09fXTmRN1JD?=
 =?us-ascii?Q?lrdb+hjGVb5uBIkpszkUyvEaPd/DJWJRL1VbAlcPHbw7VuiGZzl4bRVj70Tj?=
 =?us-ascii?Q?O+uWqrjPm4+2zi5KEPnJPxsofAShDWr7qXCQrSiEpb1+m/u3ORFbf6KPMDhB?=
 =?us-ascii?Q?uGkoUWhx1KKyWG2ubJmrxBr4Siow3pJTZS6IJ1YGcEMTS96DiQ1sjL0F5h3b?=
 =?us-ascii?Q?4LASTHpZuXTyhpKtRGagr67pZcANVeTW3wgeuZz69+2WDlmASdKrO08nMMQl?=
 =?us-ascii?Q?jvmCIGGtFxW88dR1sjxmHG71B0mN5EqY2GL76GJJFEjbKHkucGI+A7wT6YNQ?=
 =?us-ascii?Q?VaqQfIGy0h6BP0DR70w9mNHHeik80puWmIvKOHsaIkw3O/tUXQPnBsaCdsUC?=
 =?us-ascii?Q?7E88rQlEc0m83X9U1HKd/qCYW4Wm2PAmUE01ofKa+NLO7DrFV9TMprEEc3zx?=
 =?us-ascii?Q?r1zX92G6BUSHYalu50397zPACQvhfxh7i+g4VEgMlNDc0kFZkY44LEgxEEh3?=
 =?us-ascii?Q?bexo9kON5vcm/gYZBaZ3xxmOhDDbl2IsxSq7go2qNm++UlpnbUKC2PA2+HgR?=
 =?us-ascii?Q?Lb9Ip2fqDLnBNHmDbfD0FRYyMnRQFrpQILMYQIdMUNloZmIHzAIYhYXI2Lnh?=
 =?us-ascii?Q?HblWH8tTZWjokUZ7hutL8uhO9F69OodhAdu5eDylWwGTz3y6PXKkDD3+1dTs?=
 =?us-ascii?Q?AAsiHEzf+eBehd6gcTEEKzRTtyB39FK0y30RXmVjbse3kO4ApSR1CQUvM2Ql?=
 =?us-ascii?Q?MYpUCZI0Tf/vL6n/0iA7BCF7huiClDcsHaSbGtnagTcfZjzQaR6ymObylPaD?=
 =?us-ascii?Q?BLryX4s7Zgaj1bNVp3NCMufyAw+5Iv35YO7yFhHoikUOzBvAWiyW2evt8aIC?=
 =?us-ascii?Q?e+Ny4V1zb+kWVauP90NCWRGlsFaZ4wkZ1YqguC5ZztnBnnR8Expl5giJ2EOJ?=
 =?us-ascii?Q?yhcplpGV+lFSeIn0yWCUwOgds8i4DnJq38UbuysMq15PL70BdKW+YkmJ1s29?=
 =?us-ascii?Q?bDcOECTskfNyg//KNdssuKeWiCsTTAfWf83JAoQOAy6PZ0i5+PbeC0Rkh0dF?=
 =?us-ascii?Q?d0geZIam4UvZ4I4k4rez5m9jsZFtWXup1jzUTCK5QN1JKcrsGGSnm+Bpbfl+?=
 =?us-ascii?Q?4V1vvQXobuQm/EBHdwo42dv0Kpn785ENgNMeO4SEzIiO1KE9CAGT5i+uuwHE?=
x-ms-exchange-antispam-messagedata-1: a246tJcGkTtWfg==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR02MB8560.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2e9a3192-4732-433d-cbb4-08da16fd29a1
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Apr 2022 12:09:40.6571
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XqQKq727+SFGPRig59iDi7DbMWyyKvKPeMeOmXX537uyVchuxK3iZXbqwnykUNJmyoI0bPV7eDM89T+Aog9K+A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR02MB4560
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
> Subject: [PATCH v8 net-next 2/4] net: axienet: factor out phy_node in str=
uct
> axienet_local
>=20
> the struct member `phy_node` of struct axienet_local is not used by the
> driver anymore after initialization. It might be a remnent of old code
> and could be removed.
>=20
> Signed-off-by: Andy Chiu <andy.chiu@sifive.com>
> Reviewed-by: Greentime Hu <greentime.hu@sifive.com>
> Reviewed-by: Robert Hancock <robert.hancock@calian.com>

Reviewed-by: Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>

> ---
>  drivers/net/ethernet/xilinx/xilinx_axienet.h      |  2 --
>  drivers/net/ethernet/xilinx/xilinx_axienet_main.c | 13 +++++--------
>  2 files changed, 5 insertions(+), 10 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet.h
> b/drivers/net/ethernet/xilinx/xilinx_axienet.h
> index 0f9c88dd1a4a..d5c1e5c4a508 100644
> --- a/drivers/net/ethernet/xilinx/xilinx_axienet.h
> +++ b/drivers/net/ethernet/xilinx/xilinx_axienet.h
> @@ -433,8 +433,6 @@ struct axienet_local {
>  	struct net_device *ndev;
>  	struct device *dev;
>=20
> -	struct device_node *phy_node;
> -
>  	struct phylink *phylink;
>  	struct phylink_config phylink_config;
>=20
> diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
> b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
> index 78a991bbbcf9..3daef64a85bd 100644
> --- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
> +++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
> @@ -2071,17 +2071,19 @@ static int axienet_probe(struct platform_device
> *pdev)
>=20
>  	if (lp->phy_mode =3D=3D PHY_INTERFACE_MODE_SGMII ||
>  	    lp->phy_mode =3D=3D PHY_INTERFACE_MODE_1000BASEX) {
> -		lp->phy_node =3D of_parse_phandle(pdev->dev.of_node, "phy-
> handle", 0);
> -		if (!lp->phy_node) {
> +		np =3D of_parse_phandle(pdev->dev.of_node, "phy-handle", 0);
> +		if (!np) {
>  			dev_err(&pdev->dev, "phy-handle required for
> 1000BaseX/SGMII\n");
>  			ret =3D -EINVAL;
>  			goto cleanup_mdio;
>  		}
> -		lp->pcs_phy =3D of_mdio_find_device(lp->phy_node);
> +		lp->pcs_phy =3D of_mdio_find_device(np);
>  		if (!lp->pcs_phy) {
>  			ret =3D -EPROBE_DEFER;
> +			of_node_put(np);
>  			goto cleanup_mdio;
>  		}
> +		of_node_put(np);
>  		lp->pcs.ops =3D &axienet_pcs_ops;
>  		lp->pcs.poll =3D true;
>  	}
> @@ -2124,8 +2126,6 @@ static int axienet_probe(struct platform_device
> *pdev)
>  		put_device(&lp->pcs_phy->dev);
>  	if (lp->mii_bus)
>  		axienet_mdio_teardown(lp);
> -	of_node_put(lp->phy_node);
> -
>  cleanup_clk:
>  	clk_bulk_disable_unprepare(XAE_NUM_MISC_CLOCKS, lp->misc_clks);
>  	clk_disable_unprepare(lp->axi_clk);
> @@ -2154,9 +2154,6 @@ static int axienet_remove(struct platform_device
> *pdev)
>  	clk_bulk_disable_unprepare(XAE_NUM_MISC_CLOCKS, lp->misc_clks);
>  	clk_disable_unprepare(lp->axi_clk);
>=20
> -	of_node_put(lp->phy_node);
> -	lp->phy_node =3D NULL;
> -
>  	free_netdev(ndev);
>=20
>  	return 0;
> --
> 2.34.1


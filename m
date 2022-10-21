Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E80F0607949
	for <lists+netdev@lfdr.de>; Fri, 21 Oct 2022 16:12:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231377AbiJUOMk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Oct 2022 10:12:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231339AbiJUOMi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Oct 2022 10:12:38 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2043.outbound.protection.outlook.com [40.107.20.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABA9127BB19;
        Fri, 21 Oct 2022 07:12:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K7dPddLK8heAhMJn5ypMt868u0eweifI7IfBlNuERI7gpC1eNijGiJ38vdmWp7JSk2grToDre3HbWcaCJHTplj7e4T2MAcfIDzNl62QkjtYG1XB85YbTn2DSuI1AwUABFrsGKRdJ519Hk2/kuod4lzOqIFOY2lvw+B4uvkf2qpMCqHLDjW6kcuDd5teDbg6ZGicWJDG2pXiOM3aoghrsjC5ATnFxaJIaep7qanTjmOlrqH06S3MgjsQNXxV02T+15XNITRNdOqM+E2kbZonjbHCdpK/JHProMqhGbxk33orwZEkwo33anXUwj4H6Lso5IR7sn6u1U8E8Vb46w9d8lQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YQihd/9TpOkqE4hyzar68xHe+Upy6lCp9gQdTxIdsNE=;
 b=hjNykVlytLIKAjcN889efbT0UcbwwOxKUJi0CxLmDvYKzdqIMrYdzQ6ggOmQrhARoOtH2NpZl+DQgK5ZySV/SLM5h9Zz3i7kWovd/bnu6umYxEfiCDkOYR1gnKvqeKO0suWLPPRs8UnT8MlQxIWL9rp8eeihxmridYdSzP3ctMqdUegvQi7Tyc10a15Ab5XKUeHO7ly9eLWhudDExh51Yku5mbwZ/pe8oLX5aDwDVVL/2FJd7+B2Ylu8ozvrqpWV73bj2Hnk7NXztT7rghNg+2xf1jqpqVUXnERQKQIIJpXqZJBtXeACU1Zl9ILiRGRRFcENoJXTYBgq+3rbILr48A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YQihd/9TpOkqE4hyzar68xHe+Upy6lCp9gQdTxIdsNE=;
 b=YOREOEnf9cjq/TZAHKlIdn8L9r+iCz041SKw+ekkTNAjQl16dZmJxFXrfL6lqVGyPVoGs3cLGfGv0YUS6dKahNQB5b+Z6aorOFgDvSn/AbuxfziFIfE8+vD8K1tNacuDQ4dkwHmiaoDGNvY1jWaKPiGAzoomrjX9U0df54tIYmo=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DB9PR04MB9377.eurprd04.prod.outlook.com (2603:10a6:10:36b::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.30; Fri, 21 Oct
 2022 14:12:35 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1%7]) with mapi id 15.20.5723.035; Fri, 21 Oct 2022
 14:12:35 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Maxime Chevallier <maxime.chevallier@bootlin.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "thomas.petazzoni@bootlin.com" <thomas.petazzoni@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        Luka Perkov <luka.perkov@sartura.hr>,
        Robert Marko <robert.marko@sartura.hr>
Subject: Re: [PATCH net-next v5 4/5] net: ipqess: Add out-of-band DSA tagging
 support
Thread-Topic: [PATCH net-next v5 4/5] net: ipqess: Add out-of-band DSA tagging
 support
Thread-Index: AQHY5UsYuAuylYj1TUe2Wb346JRkWg==
Date:   Fri, 21 Oct 2022 14:12:35 +0000
Message-ID: <20221021141234.rgzd3znogpmm26tf@skbuf>
References: <20221021124556.100445-1-maxime.chevallier@bootlin.com>
 <20221021124556.100445-1-maxime.chevallier@bootlin.com>
 <20221021124556.100445-5-maxime.chevallier@bootlin.com>
 <20221021124556.100445-5-maxime.chevallier@bootlin.com>
In-Reply-To: <20221021124556.100445-5-maxime.chevallier@bootlin.com>
 <20221021124556.100445-5-maxime.chevallier@bootlin.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: VI1PR04MB5136:EE_|DB9PR04MB9377:EE_
x-ms-office365-filtering-correlation-id: 54d0c949-01e5-40ad-e38d-08dab36e4d56
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 5I7jF8NWnM2esboxCwTgkPdATChc0H3wMyvxFqsjGDBVYGCkO9+eVE4456O85J62EZe5WQIv6p598EAMTXrkiWD9gwh+GxnbvKRa4n9u2Q72fnWba0B8EZ84J+o8KI1bqFz2ZpObA+42+bGnHWDDS2hGuvEnHjwgqZqShXO2dtOG05N+TIS+wIrZGio7mYCqnSny98BD5nQ/hmLLv+t8cg47jsnO9Wb8UrEq+MDyQGFo+CIlQecxU3kIC2jigY4iv/Vslg2tdMK8n7s5++TO5Uup3+BsNk1XL9qvgelb4zdp68EbXOfCm5b6uwRqxznjsX3dU20krhCdmsxpWf0qkBPrUq7attVwnpcNX5n6NSdXVWH8+U8aBlt5qtI28oqjgreIAwK7OhZzXiciwp5SfkgZRZw8c/4Irn82ZY4G4i16COztfcVG2neywptW/PBPpBwSo8vS5p/pf8H/O2jjqpyA65NAAE1WYMyv3IFxVY2mIimEzwErcfzAN8zSSufovdL0e/Ub9XCtVUe59Q0aDFQOvrGO3NwKv96EMy0nI9+PKEwMGYhe5N0fIEo+ltXtCrIepm0nTVDmJ8+AVPVNsrj3Sa56vHoR5OYSxhgIUStDhuDampEuPhcf+OMAXNZrJDqaEy+SUATBUJs/RYE4fuGZJtsZXIW54IjE0s3wVA4wN/52HL83nApbrJkG1YOzrBBGbOLnW8UYl+9HKU+ypQTG5wFLsxfW1JeRr/wvjirIfLTnVKiGVFhtsDTF83ymKyKI+Y3HtDItdb4lnqcdpg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(4636009)(376002)(346002)(136003)(396003)(366004)(39860400002)(451199015)(1076003)(33716001)(38070700005)(83380400001)(122000001)(86362001)(38100700002)(478600001)(6916009)(316002)(76116006)(66556008)(7416002)(66946007)(5660300002)(2906002)(186003)(44832011)(64756008)(71200400001)(8936002)(54906003)(66446008)(6486002)(6506007)(8676002)(6512007)(66476007)(26005)(4326008)(41300700001)(9686003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?ge+rfPnGUZlKuMMu3tBtYZeVovgvrfVJtwTXJ0Dew5qAkZUcT2qTWm6goeHT?=
 =?us-ascii?Q?1ZvXamKMhjriLtUqXbc70dKBpHyvOPZd395HGbVrPB1fGR1mLY//BOLy9vX9?=
 =?us-ascii?Q?2t5LMbF6+5qOu1LfKJo+faTselY9019wd5AkPGB3uhKFLgv5+xJF7ISorR4T?=
 =?us-ascii?Q?3+enNpgPE9bd5TLuNe2IdPgOOiMcMZYsYoZ22hhgyjSMgyMyVC1fQZl74j8V?=
 =?us-ascii?Q?ox5zYnEfOatnV/AaMXwaBbjC/DPcwKWK8bW2YC/rZnr9wHqQ9MdwDWgQOuBJ?=
 =?us-ascii?Q?7moO6SgcNpUIfj7l1ZOLNEiqGPGWOI+oPdcE6boYMFmuvRd49MFeTPChXVnW?=
 =?us-ascii?Q?c/8WHp3T4eDlkFDqA6fuE+lX2x9aNXd+jQAJ4kKW7RwEJKILxVFTTK9NdWHo?=
 =?us-ascii?Q?vMK0JnlnnvWRyQPFi7AZXERP0XjVKcgt2tCE/XenRnA4bl1o4QfuXex3PzSm?=
 =?us-ascii?Q?fcTuxq8FMlCve2AwJ0/lxJmqRlIrOZmTWTlNOtSpOqG0PVtEOT1mzF2dGMZb?=
 =?us-ascii?Q?hyiniJO+HZjeabbBCuVhmKb7cgPgyLJX24pm89iA9yUeu9JtnJrJ4EJOrEnt?=
 =?us-ascii?Q?QOjB6pNr9IXgmpfNTsoMBTP/9U3JVNFjCd6n+DgS1fEjCcaF5aEKqMFQSW4d?=
 =?us-ascii?Q?6Wry5c5wAQPcIpKxy7gW0I9mQmXQAXOzb3+IQaei6XgJAdwwtV0JNeatPwg5?=
 =?us-ascii?Q?fFRjt4Jf5YfL/1BYJmpnAT1dOSAgucYGWRxK77QiwFnghTKCgQBqwvfmjOcE?=
 =?us-ascii?Q?FwX1KQKUEjHKGsKq3zVyiwfiEKGqSaOh0R+y6ey7W/dKfwJzAirnRUu1jNsV?=
 =?us-ascii?Q?KxmW5rqBOLOtUqo2rSyctkBIVB5oJos9Q+xV/yA7s7V4Q6ykgIWUqGN/oNFU?=
 =?us-ascii?Q?zevdFdxbW0RgmRnWeAn1+gsgMdzkgsIRFjtPDXZxnghZg3e4p4EyN+5FO4LW?=
 =?us-ascii?Q?G6u/7uLcSNMUW+htxikoLRSxxSbwrMAe6g04/SCZPb5nINc8bqr5shbhp0RC?=
 =?us-ascii?Q?FU7cDEu8t17lQn2jdGkcogmfEtgwgmP/bOVaUm86C4Sf/ghb01FWXh0fi7p5?=
 =?us-ascii?Q?4pd/HcrmNBSJ1/pVo1FFxMieFJIiCLjB4zsVz3N4WLUXPjcRS3f/pDRLrJRs?=
 =?us-ascii?Q?7xGDNNRiIgvjxK6dT+UoSMdpgIs+gO+syZS/l5lVePMmswFVsz7oIJKDVObB?=
 =?us-ascii?Q?G2q4A52YcfgIcT6S8ScctNjUyeR2lbZow2pixyjC44zCR5n06B2VjC2j+xoS?=
 =?us-ascii?Q?AyawVU/CoEwWW0ZajVd58RtbxyZHWsH46RSoRsmukDTkegtJChyWlJLOyQt8?=
 =?us-ascii?Q?Vg0hahUpFDMnQZ8LN3Mbh6BxAt1GndNPNUmt1k2eDRgGWzvGDy1i4C/aGiZT?=
 =?us-ascii?Q?MmuYSEAuyyu/BdKDqLw0Tuj3in23rgJ4gTLq6UxHB1v5vUpTc4zAMIh6+NjW?=
 =?us-ascii?Q?aRY1cXKU/keQx9PAOJNtQgiz1BTFBsHWbw2K/37b1oBJIzQ4ZzdLcoswqc5A?=
 =?us-ascii?Q?xUCh2dqXhy9m5zjJCgZLtIcXC8GGsd/k9UtoxcWrlIgvbGBGBlmDWZBVHILD?=
 =?us-ascii?Q?ZqqTNpG+rVKgynzMbuwq7bozlEuOhbztdmH1VeX/s/oEaA2FHDogFr29QYRs?=
 =?us-ascii?Q?/A=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <47381449673B5E48B7667B1DF2DD94D8@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 54d0c949-01e5-40ad-e38d-08dab36e4d56
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Oct 2022 14:12:35.1035
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: v+a7j+KLTVqle9QDV+d2tQyllXI+culuItDxDf2WJhr4cWLrycrV6qkyu/Lf2hZVHll30x2ZB/XnIzPSh06pnA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR04MB9377
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 21, 2022 at 02:45:55PM +0200, Maxime Chevallier wrote:
> +static int ipqess_netdevice_event(struct notifier_block *nb,
> +				  unsigned long event, void *ptr)
> +{
> +	struct ipqess *ess =3D container_of(nb, struct ipqess, netdev_notifier)=
;
> +	struct net_device *dev =3D netdev_notifier_info_to_dev(ptr);
> +	struct netdev_notifier_changeupper_info *info;
> +
> +	switch (event) {
> +	case NETDEV_CHANGEUPPER:
> +		info =3D ptr;
> +
> +		if (dev->netdev_ops !=3D &ipqess_axi_netdev_ops)
> +			return NOTIFY_DONE;
> +
> +		if (!dsa_slave_dev_check(info->upper_dev))
> +			return NOTIFY_DONE;
> +
> +		if (info->linking)
> +			ess->dsa_ports++;
> +		else
> +			ess->dsa_ports--;

How many ipqess devices are there in a system? The netdev notifier
should be a singleton, meaning it should be registered at module_init()
and unregistered at module_exit(). You can then get the "ess" pointer as
netdev_priv(dev), once you ensure that dev->netdev_ops is what you expect.

The code is already wrong: you take *ess from the &ess->netdev_notifier
reference, then you increment ess->dsa_ports based on the sole condition
that "dev" (the interface on which the notification was already emitted)
was an ess netdevice. But the "dev" pointer could be ess1, and the "ess"
pointer could be the netdev_priv(ess0). Your logic would increment the
dsa_ports of ess0 when a DSA switch joined ess1 (because all notifier
handlers see the event).

> +
> +		return NOTIFY_DONE;
> +	}
> +	return NOTIFY_OK;
> +}
> +
> @@ -1201,12 +1255,19 @@ static int ipqess_axi_probe(struct platform_devic=
e *pdev)
>  		netif_napi_add(netdev, &ess->rx_ring[i].napi_rx, ipqess_rx_napi);
>  	}
> =20
> -	err =3D register_netdev(netdev);
> +	ess->netdev_notifier.notifier_call =3D ipqess_netdevice_event;
> +	err =3D register_netdevice_notifier(&ess->netdev_notifier);
>  	if (err)
>  		goto err_hw_stop;
> =20
> +	err =3D register_netdev(netdev);
> +	if (err)
> +		goto err_notifier_unregister;
> +
>  	return 0;
> =20
> +err_notifier_unregister:
> +	unregister_netdevice_notifier(&ess->netdev_notifier);
>  err_hw_stop:
>  	ipqess_hw_stop(ess);
> =20
> diff --git a/drivers/net/ethernet/qualcomm/ipqess/ipqess.h b/drivers/net/=
ethernet/qualcomm/ipqess/ipqess.h
> index 9a4ab6ce282a..33cccaf6f143 100644
> --- a/drivers/net/ethernet/qualcomm/ipqess/ipqess.h
> +++ b/drivers/net/ethernet/qualcomm/ipqess/ipqess.h
> @@ -171,6 +171,10 @@ struct ipqess {
>  	struct platform_device *pdev;
>  	struct phylink *phylink;
>  	struct phylink_config phylink_config;
> +
> +	struct notifier_block netdev_notifier;
> +	int dsa_ports;
> +
>  	struct ipqess_tx_ring tx_ring[IPQESS_NETDEV_QUEUES];
> =20
>  	struct ipqess_statistics ipqess_stats;
> --=20
> 2.37.3
>=

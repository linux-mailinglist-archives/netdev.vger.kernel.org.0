Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 603F6522D56
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 09:29:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237260AbiEKH2u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 03:28:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242964AbiEKH2k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 03:28:40 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2054.outbound.protection.outlook.com [40.107.22.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9631C59943
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 00:28:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DVwRaYhUyN2OCJU2V+JX6/zr6H3n2bcGKJOt0l4chEBgiWIxcTT40sbPyDzOTlYS3ubII88I7QyDR1uB2WuL1Yl/Sb87YPQTbzHTtvilWMvo1yBcmO9sEmMG/xtYV3lLePBafs1B2QvPDutE2AXnkW19GrYKChsOkF/37Exn4IchpSMqvYxJDHUQN4ytEieNJ34AnsYhAJfxejYeBZyKFKCN+J7qKzvEjsOKz/dYQBjfEC56t1DRnoajnL4mPNmB3UPj+H2rBbYOCx02ek3Nti4+yaPq0tXkIH5lafwKLxygPOfoPUWcBOv6BqTIYmi25v7HMy+ecAs4zRcqWAB32w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=02MZS3ZxSDreWc0c0vDAOFy89h5kzSFZqYo5zccaM8c=;
 b=T+Nn/9f6qrmfdyHuCkfrSV+AShW839mn9CoMiP1mV8FrQkABcYKmCc5Vffj94LbFDCrrpEkfHEZ7frjt7uBLo4R6pWDdsQHDHzm/y2dwEcCzJheZbx74QinMcK4QhyL9BINTktF7Unb5cdvIqZukOSpPTocSXUy5P5Ts+hZ1ts/gIRL2Bo9Oxe26HOx3d3urg4Pw9R+r6PdtkI6iLdtGm6K5sfnlhCPvgUoYyov/kwOWABocohI9or+Mnr/855Iooyk2T4Nkqcfizyf04fesauSOF8USEExyPWnyzq8CL22pD+371VUsKbU6d4d544PiAVjG5VBkuKcAYXL7t+cLuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=02MZS3ZxSDreWc0c0vDAOFy89h5kzSFZqYo5zccaM8c=;
 b=Tbg8OS4B0XXNkqWruAthepTXll6wLx1XgIC0fux+b+PfUT2/l+v0/EBIqGbns1jrjNVR0IP/3t6/2CzE49xLJ0nQ8SgPpI4J0dlFebitbXa72jfzBjkTHV51i0AcuDz1L2aj1QpWi7k/uidP8eXQ+uKUxE9CYNuVgGH8PEtPJqo=
Received: from AM9PR04MB8397.eurprd04.prod.outlook.com (2603:10a6:20b:3b5::5)
 by AS8PR04MB8385.eurprd04.prod.outlook.com (2603:10a6:20b:3f3::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.23; Wed, 11 May
 2022 07:28:36 +0000
Received: from AM9PR04MB8397.eurprd04.prod.outlook.com
 ([fe80::951b:fded:c6f6:c19d]) by AM9PR04MB8397.eurprd04.prod.outlook.com
 ([fe80::951b:fded:c6f6:c19d%8]) with mapi id 15.20.5227.023; Wed, 11 May 2022
 07:28:36 +0000
From:   Claudiu Manoil <claudiu.manoil@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Michael Walle <michael@walle.cc>
Subject: RE: [PATCH net-next] net: enetc: kill PHY-less mode for PFs
Thread-Topic: [PATCH net-next] net: enetc: kill PHY-less mode for PFs
Thread-Index: AQHYZIyXyMQhOJN2ZE6GlwBxFlYvtq0ZRTRw
Date:   Wed, 11 May 2022 07:28:36 +0000
Message-ID: <AM9PR04MB8397286D5D10B0432D1457F296C89@AM9PR04MB8397.eurprd04.prod.outlook.com>
References: <20220510163950.8724-1-vladimir.oltean@nxp.com>
In-Reply-To: <20220510163950.8724-1-vladimir.oltean@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e6081f17-14ed-43e5-b72f-08da331fdcbe
x-ms-traffictypediagnostic: AS8PR04MB8385:EE_
x-microsoft-antispam-prvs: <AS8PR04MB8385EE47347B73EE2E106CC096C89@AS8PR04MB8385.eurprd04.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 3hcgkkY1Xg0jgIgT77AkDUpKzy51WQYmg3yVdaA3SmlRaaILKmdNmDy5zXfWmZZT6UafISNYk2KhajHpqFQk3mczOKp6XAQVjhdX9rGPvAsFhdt7srs15q7OihLbk4P+5Ai1P940SyC8sKsxxeObKlSAfLuBSK/DhPdxpJcmD9KHd7F7Lew65lWcaLXkSMZLahK1OIBVLpJWxgG+/k+kXoQprKHHD2PWE93p1cY+CouU7qusMvFMwTL+tATf+haGMTAktHJGTHX50DN0iVIW4iOjuFJoyX8cl1FTuEIpHXvvO3QgSn16J+eRwjGnTl5fnE0K6dQZxBC/1vpdNGqPda7/fuYHix03OprvgBzvg1QnGc9ZFtvqh10/mC11kfO6HKxscnXYpv7ALkQdW5wXISl5Y139N18V3rDiQc8z6dkLp75PHIwpSuErHG0NJztOxetjACsgJlKk+VhJ+FDfBJiIPSAQEQyWlj/5535GxH+6iOWRAx6zLTm0IdbG3f7/VJzbqGKAlYGmMhBxPOubGE4Iu20ve/NMBg6D+4BYJa7s0Kh2u2OTZn7oVnDUM65bh+LVly+cYrx1il3sbsEelXQwoUezILutXqPrfDvgi9TaiYw04iJ0cQvYf+pSW29ER9GTGJFv0I4YvoSQmsPym7zpWm72LQ1NRPPeJGXo4lKlR361mrf7pdZAmOKl9aNATgLyyoJS5TXMWFUD9yPtdg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8397.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(8676002)(55016003)(508600001)(66476007)(66446008)(66556008)(38070700005)(38100700002)(52536014)(8936002)(4326008)(64756008)(5660300002)(76116006)(66946007)(33656002)(122000001)(71200400001)(44832011)(9686003)(83380400001)(4744005)(53546011)(186003)(2906002)(6506007)(55236004)(316002)(26005)(54906003)(110136005)(7696005)(86362001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?rAlal8YSj2AoW+68z47ir44fFJWNeonm+6egE8aH6dgtm5gl5VM2IQ9RqZUS?=
 =?us-ascii?Q?YIDhW33KgORlHFPPi7yAFe0Trp4mmRCKMV2YWeFcKaRcVkoPQsqv8S/PkCY0?=
 =?us-ascii?Q?O2/KewxXRc61gy98saASqQfxcKKw8Kmf8x54DbFCMsIWbf9uGeFIc/7/5ZOL?=
 =?us-ascii?Q?UYXUxDB8dpIe+kD9EmBtFb4UMG+crXiNq2+WWlkINvayXm/v37jkxPG2HzXD?=
 =?us-ascii?Q?swGXztVNcxHx8Dpua3NY9LqLaGVsrYH6+gqNReuPAuMHjihwQtsRsaehQf0A?=
 =?us-ascii?Q?1wW5HNcVQWWHXfUmvA9Yglr2uyfh56rvKOLrhuPMemwt0e1nO/D2+pOLlN9n?=
 =?us-ascii?Q?qa3mdME2nXKIwJehYVYDi4CU08Gwd6cCSfQSZxgNke4qn8Xkm/HUW3RDn+u0?=
 =?us-ascii?Q?kbAFji29MlhA+VdKA04im6g4AedI7W59PorHv26gSz4OEwON+9KzF9B1dCN2?=
 =?us-ascii?Q?TWYlnDtntR1nE6LOJPRLIgVFETWWpWGHfPL0B4oi2ItSFPynfXWv/4v5nxpE?=
 =?us-ascii?Q?o93jjTKtv4VZiSmxTZf73peBR7ZwW49T+OyBbOfVReae3CvOf1EgJYjUn3op?=
 =?us-ascii?Q?RpBnHQ6WykifoY/CEaF/FbqQbIqjxwIsQ5rVNa6DeAqIUhAZwOdwjpid022v?=
 =?us-ascii?Q?sZw+bO5h4jpV2bH1s4FhEsBifh2GBUD3I4tRWMR2L5py3RFXsdHmoStgu6Te?=
 =?us-ascii?Q?FBmPc2KAlKT5tGQIIxJLfTM04C1a3pDNejij2s7WyeXJG1PmHbc61AVVr/FG?=
 =?us-ascii?Q?UDw8QAKz3HM0k9AJUCi9Fia+G0Y/TUZY2H8SQWbLURQWhXpHmAHfdgHzW8VF?=
 =?us-ascii?Q?xgsr1XleBkqI5poiGUjAlFTEVurrXnbnwtgVybmwM9NXEKXeFiIYcAXelIlS?=
 =?us-ascii?Q?WUfZUTxCaRnqCkxA3+4/LTa4hJQyyyNo50bWhgvKtY6qqE6BN4OkJs4vlCpj?=
 =?us-ascii?Q?Cbz05O2LR70kumn8OizqJCiqDZkHcCdYOtrs/k75pZyNOmVrQR9ARQuv/azc?=
 =?us-ascii?Q?M2/fPKKbcl/WQ5lNFxTd8kzm1AAI0eQhqmmZsVBKYU5QY873RkcYhNGKsGM0?=
 =?us-ascii?Q?VS/b+J8fNtc4xX1rCjG0iZubBrAaDH2Ihc/xzAzjAasVL9MMA4IU1/L3mSev?=
 =?us-ascii?Q?tQw+tj9UIYcc9IwUEOiXExNmrKhv9n2wpKar/Wy0RO4ScwKH4ALEqmwxYuu3?=
 =?us-ascii?Q?/WONArDOt5QI5tHJqRsQyQ04EpnNlHIKXIahMjxSzh/DbJ0JfzcI/k/zV2Zk?=
 =?us-ascii?Q?G666wj80dSXOuppHlGkeALLFJRtiDdfHtHrbSZ6nufFkKte10ijAsMdIk8S7?=
 =?us-ascii?Q?tJzJ5020A7zDK23+tUxsFRhZ7McrPcaR2+BJykK8grXKfBv02xqIAJPeZ8CF?=
 =?us-ascii?Q?nq4bN1o5uhwk/CGnivpfGAF06jRJmL8iZDEKJYicG11ZczSsuEatal7sgLjz?=
 =?us-ascii?Q?PeMBoa+TeJ6dWbwLBRLFaktvokF4da3Tsi3FYSiSVo5KxmtNIPZv8eT4iK4O?=
 =?us-ascii?Q?QrOUcrvlVdflKyUdsi3jYJa70oScwsjrS+xzZXNCkICDFzaMC3j6ZfXjbH5o?=
 =?us-ascii?Q?v6xRy7I99tbgZoXrMp0SoGy2f8LfBrbnb3lSAe5SyBN5/aBlzfRShwvmGoLQ?=
 =?us-ascii?Q?C9V1pPi4MZcDGGiIj3JPq4Sagz0AtmUoEpyP10P1aduSHKmapgCyjog//u4v?=
 =?us-ascii?Q?Yc4WScsbnBrFg0BKmjKeL1a+Vsw9ZQYAT9XDnop13NlIp+nSW1QNA8qHh4h3?=
 =?us-ascii?Q?Ev2+j3VmeQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8397.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e6081f17-14ed-43e5-b72f-08da331fdcbe
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 May 2022 07:28:36.6366
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vHd3llVb90ytZE1Lr8l57AFWGH7pCg4ExpGjwRn1vEeNn+1VWueEyHOkU42VHtinVi0+sOw1H1RCfrWnjd3u7g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB8385
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> Sent: Tuesday, May 10, 2022 7:40 PM
[...]
> Subject: [PATCH net-next] net: enetc: kill PHY-less mode for PFs
>=20
[...]
> +	err =3D of_get_phy_mode(node, &pf->if_mode);
> +	if (err) {
> +		dev_err(&pdev->dev, "Failed to read PHY mode\n");
> +		goto err_phy_mode;
>  	}
>=20
> +	err =3D enetc_mdiobus_create(pf, node);
> +	if (err)
> +		goto err_mdiobus_create;
> +
> +	err =3D enetc_phylink_create(priv, node);
> +	if (err)
> +		goto err_phylink_create;
> +
>  	err =3D register_netdev(ndev);
>  	if (err)
>  		goto err_reg_netdev;
> @@ -1296,6 +1299,7 @@ static int enetc_pf_probe(struct pci_dev *pdev,
>  err_mdiobus_create:
>  	enetc_free_msix(priv);
>  err_config_si:
> +err_phy_mode:

err_phy_mode should bail out at enetc_free_msix()

>  err_alloc_msix:
>  	enetc_free_si_resources(priv);
>  err_alloc_si_res:
> --
> 2.25.1


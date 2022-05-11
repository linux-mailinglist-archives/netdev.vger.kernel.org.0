Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8547522FB6
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 11:44:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243745AbiEKJmC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 05:42:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240976AbiEKJky (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 05:40:54 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2083.outbound.protection.outlook.com [40.107.20.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4886BCE89
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 02:40:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Kuav6uu53QlUJi9DxO3Pt/AUnJRszuZheBjZWDWA61m8Rbb+kKdL4b3iwffME6EVzp6y2carJnfZ8h42qsJrMyJHxfFuIrdZi+X2qUwDNCe7usXjMliNAve2imBB06zR5zeaGBygjBlT8asy0ldEoGh5dsd10vnbSGrSibQGqnyveKTvafS9kefSs66DQS2vEs5Fhji9PnucNI5eG9hr9y/bG6cd2HRYF0xMmcGJuFLPRzeFKUAg4X7M6bRB/kJj11n/Xrur6TMUpnA+4Vi0cMHuU8cEd8cy+Y55rTt37zr8AbCE4K92Rg2olY89L9b0e9uhaVdmxgwy54l9oTE/gA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=S/z0vCFofIqygwYVA1VRsfXOWtMMFRSj/Qb+jldyuyQ=;
 b=c57UL5Tsi+OCuDdkxid2SFjkXJzNpLWLBEqCOrsbzufD5QQx0U3RyCJopsydiCR7o6VYuAtXI/UXSVKOavUKaCRV+21Ng+YZdcSBF31BWsi3DOjg1dvjerjTd30YBy4LkgpaYw87+aNPO8RCHgdhH9VU3KngrvreI2kJH8LoC/XHEBJJQS74u5A74oGtN5rPjZWkO0pT8hkK5ckoSPEwvyXAUbGlisBcovReawSKqLeXvBMhueIBORuZmQ56Lorhe4TALS0l7iOlp8Y3edcwOEhylJO9G0mYdnrZXXVyP4nQ1jEe1NgslydgGR4wRJg8ZRlBsFSufJULIW1Tzi2cIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S/z0vCFofIqygwYVA1VRsfXOWtMMFRSj/Qb+jldyuyQ=;
 b=SYuEIPBB79AOBD5a8ujbhqk7/jpoAHIUKGx3KGv+k3SRqPStHf+78va+5N1vzXjm2RA1md09xQajbSELdCxWaOwAIPCHzf18NUmOdD1YkoCDur+n39rU2qiIlByiYU5XXSSuuskpkhPrzE5iXOfBOWXkXk8bT0o0ziHFD+9MYd4=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DU2PR04MB8728.eurprd04.prod.outlook.com (2603:10a6:10:2df::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.23; Wed, 11 May
 2022 09:40:02 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::fd1f:cc16:dafe:4bf5]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::fd1f:cc16:dafe:4bf5%5]) with mapi id 15.20.5250.013; Wed, 11 May 2022
 09:40:02 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Claudiu Manoil <claudiu.manoil@nxp.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Michael Walle <michael@walle.cc>
Subject: Re: [PATCH net-next] net: enetc: kill PHY-less mode for PFs
Thread-Topic: [PATCH net-next] net: enetc: kill PHY-less mode for PFs
Thread-Index: AQHYZIyWuPO2uSkCSEaYBLrUtmOXwK0ZSFoAgAAktwA=
Date:   Wed, 11 May 2022 09:40:02 +0000
Message-ID: <20220511094000.yxmrwc6xntnci5k6@skbuf>
References: <20220510163950.8724-1-vladimir.oltean@nxp.com>
 <AM9PR04MB8397286D5D10B0432D1457F296C89@AM9PR04MB8397.eurprd04.prod.outlook.com>
In-Reply-To: <AM9PR04MB8397286D5D10B0432D1457F296C89@AM9PR04MB8397.eurprd04.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f8548a50-fc65-4e6b-b9a8-08da33323924
x-ms-traffictypediagnostic: DU2PR04MB8728:EE_
x-microsoft-antispam-prvs: <DU2PR04MB87285E8C0E2C1A97C1532A24E0C89@DU2PR04MB8728.eurprd04.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6L4G64BmbdPW2107P8EhBioJZf2twsmSMXvYmdEZXNM6Ej6GxjqGbGwV8QAKFmxeA+jkwvzM4J+KMYP/8scXO8ggFDHgXWvYLZH5RSKwI46Fm+7ebTdyNghaCL3kCx9TiqoN6/8seHoM1wlmNd8QCoCuHSqp+WPbqcihM4uL8+WeaE2wwpO4Nw8+inMnVCeMuTvdT1/yWybMFNlhzVg6MdRqc7q4qIHeZggXKOd7aGUSc4dwC1oaQ4IX7FXqoof4XQM6ioiSC6JJ6748mfPCPMxvJSactbqden3lmZ5zvHJVDpez3YoGJtAAilHC0k85xwncGXts8OIxZrYLi/i7k2MBzTScmEfbL/wnhPuQ57gcZqV/XsrD37IenJDrygrWlUdbOy/Kp6hJ2Qb0DPOQLBR/OukueXy1kFXW4759n8C6ksiVnhVsi7uK/0M/4TmIxbnxQX69X64LGiNT+BTyKChpRUGujv7IHuSxhf4lDTC9xSDQMj/17qob9/0Ittx4XtGZXOsq7JibcRgJqZabk1K1kksBYvWI/BlS9II9qhDMTfxPNSRJE8RH83i0M5bAU4HppopYjPNUu96LnVEd9kMNzQcAkz3y3qqmNimZzjiv4i5kuWdeDXxS1VvqqSk7UD4beN836vcd252qu4CDKS/QRrih15J8casleibDiU2IzpHKY+07A4Med+cqvhHw/9H/SAnA4Dt6P5k/y/y1Bg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(4636009)(366004)(38100700002)(6636002)(38070700005)(54906003)(33716001)(508600001)(44832011)(8936002)(186003)(1076003)(2906002)(316002)(5660300002)(91956017)(66476007)(8676002)(66556008)(66946007)(71200400001)(86362001)(66446008)(64756008)(76116006)(6506007)(4326008)(6862004)(122000001)(6512007)(9686003)(558084003)(26005)(6486002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?tZrTvNGX3JMMf7LD76EwkWCXA0h5s9mH62tHJK2c1zYZlwfCFZbUuvCBLkUo?=
 =?us-ascii?Q?IVxrYjs6EE7u/YtlWBAKaFNQXrXhVjsCDWja5Bv8MmxBDFskWyob3D7ODSgD?=
 =?us-ascii?Q?CEiRbkZ1JbyMqon0tMj2GNIJI5kZ3Cfa8lZ8iwSVwuRjRpv2zY7bFSjsm9xG?=
 =?us-ascii?Q?OcKvt06Sp6t71iHNH6EZUCT0w2D77sPR1ENuFldZvGRH0bxwURSvhGLLzNmk?=
 =?us-ascii?Q?s807fPNVttyTCEv5KFmj3LUnaihysaJcy2DKinmYjF4bRGkXuZJ2B2j7uLAI?=
 =?us-ascii?Q?kRZwi6uqFAELqkNomTi8vYehZQ6I+j+nOVeZt7bya2zDP3FDbAUl5yzaPYyE?=
 =?us-ascii?Q?8Ytt7974SoqvFpRk1ZmMb6qLTtfXo/1LDQzdUlhMlf1Q5Y2zPZA8mOHv7D7x?=
 =?us-ascii?Q?BOPCQ9gICfn5fFPrjoe4qaDOzIWHF667EwpA9hCYVJ2ws6qKaFneKvOaQRHU?=
 =?us-ascii?Q?0pa1SNA2PU8jmmDyq/3MHRcXFDFUYVwl1EYJs9CBLQc8CKk3zmnSKoO72g8g?=
 =?us-ascii?Q?7LKCcEYZAIoKtQwfAA8vzyDY+dgJ/RPhlXITU1q/D65vx5YJPIBsKE46vNHj?=
 =?us-ascii?Q?3P/kvNFI6ReHGJmITVf/VEI/FSJnKiJQL89UDpp0BFvN/QEVxG3ELTYWKgYk?=
 =?us-ascii?Q?bTJFL8ODC+z5SQcPKQq6yklvk1hE4oGHLRfC0uMoBYkWDY5qGZ3IxaFmqZbj?=
 =?us-ascii?Q?7ZEA6kdqXPHma7OvBcPyCGaS90a3ZBLt/rZggQ7uq7vyfK4C4k0RgPw6SoN8?=
 =?us-ascii?Q?c9sOFsnHIpdXjck+AlhzQagtLJsrzK1uxNyWLBUYwIdqEz2/F9vKvnBlit0K?=
 =?us-ascii?Q?KkLCeCqdWbW5zV8ptffTYaAjMDY4go6ITiOHGsa+ZOa/hR6eXDzwtbUFySaj?=
 =?us-ascii?Q?4av8oXogDFcx3IaT6Rc1CKJBstH/ZNaZsNvzVb6J7xpTeR8sR2Yv3QA8DcTC?=
 =?us-ascii?Q?9DYV9PYzsK32YVhIA3pkAvWoOTdDrS7VrUt/aaXO/sa1a0h2s4h2wbYvqpRH?=
 =?us-ascii?Q?5JxJcNws0tFKiMY3niAnxvyHYhFHwpPwde5JU86SEnEp4O3rdNfgaII3/cZ+?=
 =?us-ascii?Q?tAGxlRIp9soIRsZNeF+kWcStfwqxlsaGxM2UNQUGr6b21CNcvyBQ7rZx0x33?=
 =?us-ascii?Q?WRdFivP8JI3pdoWMY+boHEGv7Z0CI7ycf7r3+O9lW60qzhpdqQkQgGjWRAJl?=
 =?us-ascii?Q?LmSy4tK4Zgnrtg/t3vWUihwQ4D6hr+Ul2/rQrvHRQw/rhoQLrDSVDZpx1xmR?=
 =?us-ascii?Q?Ir/B5GkjmSy+vT9ncv+IH4xJAcepVmdpjzUUnbPk9MfJEal8AMZp4jYL8ANI?=
 =?us-ascii?Q?6TQt2Vgtu+0rUpv020DlR+B9JiAFikRDsNS8wOZxGWIxClpdKDl48wsV8z+u?=
 =?us-ascii?Q?tbkd51ptp8dUVp0F4wHB4O1E1aoDjWIecd56H470YP3KW7jleFf3ov64KDem?=
 =?us-ascii?Q?KGfxIjG/ARXxDAhCphiuBR/sLefLMe/xTfvB9BDQiGXwk+POgv0KGkRc8rrA?=
 =?us-ascii?Q?nM+BV4RSMFdwWC/b3YspnKa91WJGlHUb5RONToCCdQwkNhql1duC9Pu5Bt+T?=
 =?us-ascii?Q?vGmexdrn20Qsq52mZmzKz0fOzxu3OtxERfixOM2sR4Fczwn6FBaDEci/I0qB?=
 =?us-ascii?Q?20LX8+EMt7IWFy2EnbGIP+sRX1Ziybe0s65/JrQJJTEP9HK/g9Nttf1eronH?=
 =?us-ascii?Q?HLlcZUVvtBxc5/bxF9OhdOlLCqq3H2TFlgX73hOs5wNoZEVh8cF4M//Jd0XZ?=
 =?us-ascii?Q?JsmKvWDz9rRN73fOascuP4TEj3lNMw0=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1849E78C4C6254408A60F4446D783BF9@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f8548a50-fc65-4e6b-b9a8-08da33323924
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 May 2022 09:40:02.5811
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LRaolsdOooFBJ9qTYYgDlZdkQawiX1YAHqeGS+YmusaiiqiynNziVmnhSUKsOd71kjeVJI8OvSqx6bq7pr576Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU2PR04MB8728
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 11, 2022 at 07:28:36AM +0000, Claudiu Manoil wrote:
> err_phy_mode should bail out at enetc_free_msix()

thanks for noticing.=

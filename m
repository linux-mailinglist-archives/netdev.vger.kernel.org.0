Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D20257CBAE
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 15:18:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234194AbiGUNS3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 09:18:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234198AbiGUNS1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 09:18:27 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2081.outbound.protection.outlook.com [40.107.20.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A61741F2FF;
        Thu, 21 Jul 2022 06:18:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CtbA8ReePFNkbLBMM4QqD3DxCR0tw8slfFueVtOP/VbaZ11PfsitYNHRRALaqew5M3inDF84kMWb3rGPVFqVH/t691Ks86mcTjAqmlwGPXtGPKfWQacLLSGVPSbwTPI1BT6nJ1/r8FIsRCvt7KYKGI9FeEej6TzTb/xfROb+cKJ2TypRdYgY3P9OgTHxbAunwN3yUldp8eRVv+DdiFrK3zU2u9qD1i5Z80jpE7cQ1L9+ur4t1SZajOLW26yFYvlUGlufL+ckoVjox92H84zoAnzQC54z/kKjWzfGBPoz48n0J3ABQmWEFrSq2sIXmLM6B25sh5ErRLn9OER8SySzBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mFmBkYSXPfFs/xa2pjAhTJfizbjqZOIYxeGhUbRj3B4=;
 b=NbRnr9wcrtM95qikFI4jBEiQSnWyXQzQ1yDWz0Tcovq1ytexW5YGi4bdR80yZC1t/8eC6tsbTmb5fknZE4iPUsAoaV7D8vGnZE5J1idR4r6c49q44/22cg4rbKNRPvh6VuR22G89b5Mf8ZVPlqYIebZN37PUpid/0lGWYLANslyi0T7zVMb+Gntew4gQqO86wtQEhAqL0ihh9ww6/4WqQWQ/JFo/84pBwNTwOQAaDYTMQ0UXG13dbLm97jY56KRVV5CCM2od2qzQebB4FZsjPJaOWFUdi73o4sw4Ae6UoAn7QfRgv9hZXCVpVo2uHMn30XlyYTnzhxEA348UYD9zhw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mFmBkYSXPfFs/xa2pjAhTJfizbjqZOIYxeGhUbRj3B4=;
 b=aOv2SR1BX/LhmWslz4I0XaBDC2Gw4egD3NrRMwztMd3WVFbdYFAMlHxbCa766DJ0VP4re/fmGwTGROMP/IqFS1akVZPctBb2RuGwKL8gfeGGKMscbda03tKhrm2EwU/uPfMq1eBikw1MJi/4NMlraW175+Mz7xMD2aWqgxh5gAI=
Received: from VI1PR04MB5807.eurprd04.prod.outlook.com (2603:10a6:803:ec::21)
 by DB6PR0402MB2856.eurprd04.prod.outlook.com (2603:10a6:4:9a::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.19; Thu, 21 Jul
 2022 13:18:21 +0000
Received: from VI1PR04MB5807.eurprd04.prod.outlook.com
 ([fe80::1df3:3463:6004:6e27]) by VI1PR04MB5807.eurprd04.prod.outlook.com
 ([fe80::1df3:3463:6004:6e27%4]) with mapi id 15.20.5458.018; Thu, 21 Jul 2022
 13:18:21 +0000
From:   Camelia Alexandra Groza <camelia.groza@nxp.com>
To:     Sean Anderson <sean.anderson@seco.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Leo Li <leoyang.li@nxp.com>,
        Sean Anderson <sean.anderson@seco.com>,
        Russell King <linux@armlinux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
Subject: RE: [PATCH net-next v3 37/47] soc: fsl: qbman: Add CGR update
 function
Thread-Topic: [PATCH net-next v3 37/47] soc: fsl: qbman: Add CGR update
 function
Thread-Index: AQHYmJan+BDlp+aVWkmgVySjKM2SXq2I1ypA
Date:   Thu, 21 Jul 2022 13:18:21 +0000
Message-ID: <VI1PR04MB58075DFACE3A36F4FDCF7ED7F2919@VI1PR04MB5807.eurprd04.prod.outlook.com>
References: <20220715215954.1449214-1-sean.anderson@seco.com>
 <20220715215954.1449214-38-sean.anderson@seco.com>
In-Reply-To: <20220715215954.1449214-38-sean.anderson@seco.com>
Accept-Language: en-GB, ro-RO, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b0f154b5-c22c-4fed-bab7-08da6b1b7c31
x-ms-traffictypediagnostic: DB6PR0402MB2856:EE_
x-ld-processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: P5UYhjGazqbN/O8qJtTj5HXTIUBcPQ7NmcT+PmJM7AVraxRfGHj4HsjDcbcY3j47jVgP7pWRwKvpzxknbzvwxltI+oY6qE8gKqrBtrj0byFA59PFT2dQDj4RYAtKcc05ts2JrDYSG2u43qMpzZWnEnstZNfgCZUMNkyY6i2dPblBsoVINeKxFUICcK1lXvF2bJ7ze//9T5XKw/3BSAlTre+IH7sDnV5QTbj++gMTICZjAjcAdRZTo02HD4ERmTOM/CnOjxw2TOTFyhlXNSkCgdTTDQxxzqKOj4443avLZfwg5yx1cP0PPgvpPH4ceU4Sj5CIzlV65982rYoKoq48TRIn2An107B57Mt1aAYLrkub6p9/NQAX4ju5PHDAn4rOj5vH9R+HWHFqULWBt7Pu5oCEC27FjkgOTfMtD9mY+Yz0xQsIFR1WS38VMNnkWIroQtOcpxTAbRE+0c2DUJS7ffpQ9ULHYhEI/sYTHeQ8rBT1utPIzihyuW3KVYYROyq4tL/MIfaI30TwfnD3FzFLjWZNysyoMisBppCZj2ifOqbmXxtyAsbCHGpsjN45XCqe2n8aXyM8C7VKiaLAPwKBtXfh8v23pcwjFr8J3uqsq2BCaFn1fuZ4D9rC0+/lz4eV1QlsGBxRI2jNom0huubDc4wge03fvHGc6qrv0G+6NF7nemJoF+IPlQsiksC4WgQIJxIQEm3Tym7t3ymQ5h3WzAP0Sa664lflB+mhyAeOexpxLfQ8bEzSIs4sQxTzucv8Y/uAwfejWlXMqXflq3u6PxA7ZL9efjJhDBQNLR/QeyTOYwlCO1GeFN6Oak6o320V
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5807.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(39860400002)(376002)(366004)(136003)(396003)(186003)(76116006)(38100700002)(55016003)(66476007)(86362001)(316002)(8676002)(54906003)(122000001)(71200400001)(66446008)(110136005)(66556008)(38070700005)(64756008)(66946007)(4326008)(52536014)(7416002)(33656002)(53546011)(55236004)(4744005)(15650500001)(7696005)(6506007)(8936002)(26005)(83380400001)(41300700001)(2906002)(9686003)(478600001)(5660300002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?jIJOjuqk5MqU76KNMXYogw8pKRnNFhyCy5q05CUQWav4ImUpxkt1tX+GOAA9?=
 =?us-ascii?Q?vIkEZOwNgmBWhIqZln+wLiYbZ+ML+6+OEbA7VsvlLyFUW57GQt40QQ4DHRfW?=
 =?us-ascii?Q?tP6TkQsrB4zRjOgB3bfTfd6X7uSpK6ElmuyhmIUm1FrbgN2pV/bP6ZTVdJX3?=
 =?us-ascii?Q?sWDWX7Lmab6FKQ1EFY1M9H6YmqtUulHNva7A5DS5bfoB/4pgKIYjhLR0MWvK?=
 =?us-ascii?Q?lAp4lmIqh7XBYTJUYjvZj5imhvmNfdnaaws0UmpPrBLlku7wdzKXmIeaS0DF?=
 =?us-ascii?Q?5Fw5UIhUJep+qtPhaSUlM0kaszsAdQfnBFmpyvhMDe0K5YM3CAqBrSfgwGNx?=
 =?us-ascii?Q?W4QEjAzJ2UfRkcq/+Rf8CmJhURcl4niqC9mkcZAGclt4xq28Wq7ZPDTUPWHe?=
 =?us-ascii?Q?5eMnsomHeIvnU83sqMKsFTci+eKDkP8GuurSf1zepoavIq447JrEi0gbhPYl?=
 =?us-ascii?Q?/ZI4bGXU9wK6JsqcWUlfM1hzFLOltI0+5DksTr7xs++PwYOkhAiila1LIhlH?=
 =?us-ascii?Q?3mVQQmZAjqc3TiPdk+D6JT1on1v4fX35px1czhutkILCBgqLWxENLSZeL0bd?=
 =?us-ascii?Q?HtBB3neHT04jOiK/ygIvBh6pUKQCHrZnjcHDsy1zRd+ty2jNsN2m6c6hoWCS?=
 =?us-ascii?Q?8NaPi66YrJnJBefJZJa6MY21WM5rPw07K8AQ4VIx+gSktnkCQvxEiQdWj731?=
 =?us-ascii?Q?VShIr1T7OAo7VTUvY3ugKlYtSUh6GuTCerm4Ae7IZ/U5WoLM+Wlnw6x3CZLR?=
 =?us-ascii?Q?n8wFV+2oPAms4rFW0eYC218BWLP/FD2rS9bUbfkXPbK23XT1DLF7OL60G7S/?=
 =?us-ascii?Q?cU8OJuXvF1ZfPh0Q1zuWM93hT4bkPLzVpe9xNSyu81nLnyLtnf+VK8hYqazQ?=
 =?us-ascii?Q?/9uHtyY17hHGcDq3p9nvhZ581C0+A9LbwEroktMJco0NT/bcTLyHInD9IUGI?=
 =?us-ascii?Q?iJ3iqOiOg74Ks/cyG0QEjiWV8tSJRTGD3kaIzXV0Z1ycFY+wslchzrep773r?=
 =?us-ascii?Q?HPeovA8Y1IXlKtdtL5x5E6fK5YSVol359YORh2vHSQcanuZ1rSAdnUPzQH+n?=
 =?us-ascii?Q?N86xhUjJqgu/LYmkmkyIAvmFnavvzhscXk93Jw79Z4nVJV02ZqWeZHT2k5yk?=
 =?us-ascii?Q?bF/L75Mmuw/tWdK/UhGeL6tPtkyAgcs+9DnlvQ4Qu7f/bEDrt6JyA1B7La/f?=
 =?us-ascii?Q?+V7zGeDqTtOAIv2RMg/8HAa2YXU0KpSrQ1hYcJVFpQPM+HZnE5NdD45RinFj?=
 =?us-ascii?Q?gU/VlBiudwY3cYsQMsmyx2tLKeALBm/+P+IXwmmHyOHMRIgprnuXS7qD6387?=
 =?us-ascii?Q?YcI/cV+FLHSLJM9yER+S6NR1WoVsD9xXfViqynmFZEAWbeeusAojouACRIMe?=
 =?us-ascii?Q?k4qaaX7xmzjD/b4ew2rb/DONq8kgtbeat6kw4poQJHaNoQGUU4bcluAN/LY7?=
 =?us-ascii?Q?EC7NOnrnJp6DXYUXHn7jWgLRN2VQ9D80EOS38uqnCR2s/JgkT89Rf2UpJUju?=
 =?us-ascii?Q?G28kHuP0X0CsNbeZVTKPPzFtmgQd911Qg+EPRyYTYacbIbRIUlPXnGVuWgDF?=
 =?us-ascii?Q?TZ7zJM/K480tzd4bGo4pG0fl4DhN1jnCPh4CfHBg?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5807.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b0f154b5-c22c-4fed-bab7-08da6b1b7c31
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jul 2022 13:18:21.8269
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PBBpFMQPtpHsaVlPZ3DXYFWnksldjyCZCLvn5xHjabCNVnIW43o1dk7rzdljiq29sPLGtppcUSXXI8X6Stdv1g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0402MB2856
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
> From: Linuxppc-dev <linuxppc-dev-
> bounces+camelia.groza=3Dnxp.com@lists.ozlabs.org> On Behalf Of Sean
> Anderson
> Sent: Saturday, July 16, 2022 1:00
> To: David S . Miller <davem@davemloft.net>; Jakub Kicinski
> <kuba@kernel.org>; Madalin Bucur <madalin.bucur@nxp.com>;
> netdev@vger.kernel.org
> Cc: Leo Li <leoyang.li@nxp.com>; Sean Anderson
> <sean.anderson@seco.com>; Russell King <linux@armlinux.org.uk>; linux-
> kernel@vger.kernel.org; Eric Dumazet <edumazet@google.com>; Paolo
> Abeni <pabeni@redhat.com>; linuxppc-dev@lists.ozlabs.org; linux-arm-
> kernel@lists.infradead.org
> Subject: [PATCH net-next v3 37/47] soc: fsl: qbman: Add CGR update
> function
>=20
> This adds a function to update a CGR with new parameters.
> qman_cgr_create can almost be used for this (with flags=3D0), but it's no=
t

It's qman_create_cgr, not qman_cgr_create.

> suitable because it also registers the callback function. The _safe
> variant was modeled off of qman_cgr_delete_safe. However, we handle
> multiple arguments and a return value.
>=20
> Signed-off-by: Sean Anderson <sean.anderson@seco.com>

Acked-by: Camelia Groza <camelia.groza@nxp.com>

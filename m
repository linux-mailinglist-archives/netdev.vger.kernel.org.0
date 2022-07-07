Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB1F456AE3F
	for <lists+netdev@lfdr.de>; Fri,  8 Jul 2022 00:20:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236759AbiGGWUO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 18:20:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236101AbiGGWUM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 18:20:12 -0400
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-eopbgr80041.outbound.protection.outlook.com [40.107.8.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 175052C651;
        Thu,  7 Jul 2022 15:20:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B8BrnZb+z1yoe0cUzYQuPRJxfPeZeSXBlJrqOUnz88L7di2ZOZNRRpSEqqv1U3hEJsMvm/T0KUYTa1C5HQLI5I1RT0RDo2KknHKDdfcwAz10UR4pNXX00DWSe/5Et9HH6GKWI5TrEUkH7ehufCPStvoDCT2sNbxTvyppfgZ/Z/CBaqxJFXIWrjnnF9rxnQFYALC9/9RWcCJfECXkvjANMzYaLLxv+jcvetz31dxBRzUlZJLWlXiOQIQaOD+MlElbmcS8clCL3hGRIF3EJrlF+QYXYkm8BbjualNjVXhz9DHU4/qq3cClpUqu2FsExalLbM+xe71ersSliuchvnCA8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=P4kHLTecolmODfMY7UZp/5fV61FpNHAuvoqgHtlBKas=;
 b=l2KbSOEJhlB40Y3Z5iGykiPCWHwxfVrLZQjPewiLZQx/Xxa8ZDM1Bm5q6wL5SJgZwbApWx2Kb0m83f/KAZc/YewMndZrK8H5cTS4GS/bOKHDhiZ0oSIDQyQYLLB6Twg0GmFOySgviELScOg02RrUbiPJNt/Dz4KYYLZcwOIa+WuMvaRRyPsUBnTx6ePebpT2DLLJDtCUcCXW7arm5x4b61QuGdwK3TYSTvUiitrF95+iHXoxd7TVOIQY2vpheEp/+1Tt3pn+zxho9iAOUsydT8N+nvw6Z4rJQNelqUyx5pDaNo4ZTs+vPURg6uAuxC/v4eN51cqKxQZYa+gSGPXwig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P4kHLTecolmODfMY7UZp/5fV61FpNHAuvoqgHtlBKas=;
 b=lXmVnZyKJPI4NbkFzKrTxvnadhK5BGqXe4pK8tPKtcJqFnhtwMcOLJPph+CqbgTwQW95uLn1OB2VeNTxHDy3Ha1yqLkHYlCTSqAjbasubR9NugUXbCOqppUZMxKG4PUF4BrOFo6HMZF4qri6gj+sSWKHL3gcgCHf/JENtGrrcKg=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DBBPR04MB7898.eurprd04.prod.outlook.com (2603:10a6:10:1ed::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.16; Thu, 7 Jul
 2022 22:20:06 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857%4]) with mapi id 15.20.5395.021; Thu, 7 Jul 2022
 22:20:06 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "edumazet@google.com" <edumazet@google.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "shuah@kernel.org" <shuah@kernel.org>
Subject: Re: [PATCH 1/2] selftests: forwarding: Install local_termination.sh
Thread-Topic: [PATCH 1/2] selftests: forwarding: Install local_termination.sh
Thread-Index: AQHYkglFOirDc8ejk0+bKe8cGnRUAq1ze1iA
Date:   Thu, 7 Jul 2022 22:20:06 +0000
Message-ID: <20220707222005.mhcwxsijt2boxex2@skbuf>
References: <20220707135532.1783925-1-martin.blumenstingl@googlemail.com>
 <20220707135532.1783925-2-martin.blumenstingl@googlemail.com>
In-Reply-To: <20220707135532.1783925-2-martin.blumenstingl@googlemail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1370bb69-cb56-4f59-7f54-08da6066d8c7
x-ms-traffictypediagnostic: DBBPR04MB7898:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: HOU/7SbN408NSzbge6H1W5NnlfduU1+lZK+xqKUsfjM8DheAB0cR39FN5CoO1miXc/1QNXaeTP3D3wiOzkV+tDqZ9hDT95bPn2GuNV7MULZ7m8GhYtzSENovOaDxhiAi32srhhl7tNAiao8RRn/eINWI3afy/eC2p8lol1jZK6SEqHUhSqssxKwos3Z9xJ0LtwDjO5/7u+gOAzKJ/DOkPu6Ap15eafm23uZSVFp+V8lm0brskVXnB9gVZrY/tJlfuT5oudTwQDLPktSIxs0fjM0lMtdFhJkaumNsryojg47gtiDxCayN3LIX54TfwYeDHJ6dF09IjNrhPaOjy1aco1zDDz8gVpGNjw+mXvZMI52COySdeAXmY93uasX8hGPLrxd6OvLJMCLCaagi3XCucLHtp3za763+o6Y5H5PnDzh5wIsz8saxwLGisqIsW0s6Kq/KTlD0nQCLr4PdjWu3d3EeRiDjo7KKdoTcTs0M31c4+aon7hcxD5H5q1Y8ZfHtlTaJFZOcwriVxjKpl2bs9Q8vSOP3Z0UozvYxHEsIE6t1MHHJIljrBoVfnJKNXORvFiqlYjfpu4jkTk7bQFxbyT64yjmUZZvaxTpq6JwoomtEZckqkdgrpt2u1YJuxe394S3Q/qekJWZo6MQpJHmxYi4JkisGdELVrcrHffucMNUxt+4z7NBYdSStMisSaOlD6YbqV4Q9XUbo6/KaPvonzSyBsXKRP+iKpBzwjBPc/cUm9w2izpdDumQwe2DMeXD0MEkZ3j8WN5eaadbINSa3axfL/KAMT9uu68z9Zrd2pduLnAybq9vdzz5tP5Hm9y28
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(4636009)(346002)(39860400002)(396003)(136003)(376002)(366004)(86362001)(33716001)(38070700005)(8936002)(38100700002)(5660300002)(122000001)(41300700001)(44832011)(478600001)(2906002)(316002)(4744005)(71200400001)(66476007)(66946007)(64756008)(91956017)(66446008)(76116006)(66556008)(6486002)(8676002)(186003)(54906003)(26005)(6506007)(1076003)(4326008)(9686003)(6512007)(6916009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?5/gdFiwHyFtwo+TJirgvLU51fvXH0Uucw6IycwQjgjy6OlDHMNQt/oixKnxj?=
 =?us-ascii?Q?Kbs6dXHiK9fl4CJhwJaSDE2FCZpB3z9YfsN/EYeZCQ5WowpQhJHfcxLq12En?=
 =?us-ascii?Q?cSLl3L3K0obuk9/reh/uhozajO1KCONNbity2wcpn8BfR2a/bqaVVaV07IOf?=
 =?us-ascii?Q?QEdvy/SVNHpPi1gdBL/HgGkVCqOP92nw4Fq0hwgAoVSru/13Klfpp5bF0hD3?=
 =?us-ascii?Q?OxDP5xcbUuqRalF+omHb5iwgYetRq2xzc/64G2DjgxtOPoci1cjz1aaKbGJC?=
 =?us-ascii?Q?2ilpORVkuSRHKMh1onBoo4f75ofgGbWRVQegGptwGeYXHPbo/MTQgGRqI23a?=
 =?us-ascii?Q?MI7oIguXi4B4coCIMBU3XdR+igk3008u1RsuJMm8182p6FaZx53im1EpZ97O?=
 =?us-ascii?Q?wQoeB8UgaEL/JRLx/ZG4eP4hlqwr1VrOWZbDPQsLBUE3K4wusSFRw/lD0L2D?=
 =?us-ascii?Q?+uFgb3VSdxtd8nfR8q50+X8V/Jt0Nfbf914U21WzerA65txepLHjVGTW8hPH?=
 =?us-ascii?Q?1gNdulfDIfB8ReMwPwFXq1ro8ljVsZlzdWZNHuTb5oN183JrzaA8X3d6Gbl/?=
 =?us-ascii?Q?tf2dxLiNy1NXAiUvBXp+PgMDTee6Q/m1swBQGllfHiwzepBfAZKr7N+x9oTT?=
 =?us-ascii?Q?XJTJUq7aJzn3ZgkaWDscrDrfQwKAPD3n9umzicoeAZM/VAj4G0KhfFdqHocm?=
 =?us-ascii?Q?bk+pFdf89iZpIxqHXTrooLKC4jHaLaM2yDsDqSPNmCkT+4kvnfGLoDuY142V?=
 =?us-ascii?Q?vmpkl3Vtd4KAjaETJbvzC8W0liMLnEI/55i8AnFaLUxNVeyrL8hreOa/Vfea?=
 =?us-ascii?Q?jAaXhHskF0GGconit/jQrSiZW5rh3QX7l4FKnmKSiRkTi2kalHmQiIqp2AzY?=
 =?us-ascii?Q?Lk6yPaLtWWNs3cxEDnXRM4t5kC/AHTpAQGiQcrrFBq/93BE8v7BJlPi9TVg9?=
 =?us-ascii?Q?4COU3k7g9hs98teokXo1wZnHHboj89N6/9CAI7/Ur1i097wH8GTvvHGL43kI?=
 =?us-ascii?Q?QkdJg4bwbWODQpcBOrdYV6KFjQpx5JeJSb5JkkMpHpzCp++6EI817+MeSn4/?=
 =?us-ascii?Q?uZz8neQkUUwKSpy5ai7zx5accdH4rxAvSgv2GXzL2gFvdfgtvh5HB4h5ec8a?=
 =?us-ascii?Q?Fzq9QppHdvqlZan4q1DiRjNjtAgcCUTfNcg60CR1fYysjd6O0vnyTQddiESU?=
 =?us-ascii?Q?IPR2cUo82QFxjxT7tJG3xNX4Ei1Bh84NVipumklSlqFQe3Bp86PZToX8Ca6E?=
 =?us-ascii?Q?AIVvmLI5Y9Ytm4Em4+qD4+7PyO1LPuWIOd3qGbZlg2hw3AnLFX6LEzqf10vF?=
 =?us-ascii?Q?X6wXdTOHT9Jp+mq6lwrcVvCTI9yEU17mKcizBbMCs7Onil/uw1lCTmOmOvhk?=
 =?us-ascii?Q?av3zaI0foDsv2eE1p+TBgQfMNnuEaKZgwLcgIp3THAdYzpJQzsoFxZND0J9N?=
 =?us-ascii?Q?2vmBARueBBXlPmI3/d2pX3uV/+nzY8OQ8gRYqAJghU+F4XOFWlCcLh58gcu/?=
 =?us-ascii?Q?fx9herWZQ32Gw0L11kSaS5+rq81n30zttFJyrKfBk7eZoSWl7ANvwyb9OS0w?=
 =?us-ascii?Q?vqv0bJREQ7KXWDI1nyBrXX5czweSGt2rgYWG+inZH5kdBBmt9k0iAd6w/iZd?=
 =?us-ascii?Q?Cg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <10BF4A4806F04543B607E6802D973EFA@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1370bb69-cb56-4f59-7f54-08da6066d8c7
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jul 2022 22:20:06.5917
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: I73UM/PE7l4TpW+QQu3I5SMPaO5HpnUcfFK/DvnHkO7HJtDXe7Mgh77ucJRC84WruitPWsASCTR1mcmJHtel9A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR04MB7898
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 07, 2022 at 03:55:31PM +0200, Martin Blumenstingl wrote:
> When using the Makefile from tools/testing/selftests/net/forwarding/
> all tests should be installed. Add local_termination.sh to the list of
> "to be installed tests" where it has been missing so far.
>=20
> Fixes: 90b9566aa5cd3f ("selftests: forwarding: add a test for local_termi=
nation.sh")
> Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
> ---

Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>=

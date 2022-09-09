Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5B115B3AC9
	for <lists+netdev@lfdr.de>; Fri,  9 Sep 2022 16:37:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231826AbiIIOgs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Sep 2022 10:36:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231650AbiIIOgl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Sep 2022 10:36:41 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2079.outbound.protection.outlook.com [40.107.20.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4938128C20;
        Fri,  9 Sep 2022 07:36:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Kxcz/OpRBQFY6LImGGSlPsDOI34NL8TmhrMUejazQhLJLJFDehIhLqwi9YSPgHuPFq9w2FaA5PdFxDrews7nsMjlm5FlhFV6ZujaA5tnP6trlqaVvPNpOQLiHk4cK5+54VN3eDYSX1fZXittBUCyIk52tvaJxyktjGftVEGo48NkLWHD9ZZNsoqMijuvDeM08/FBO6nbO4n0XlvP7KOhlervaOP7TbU7l3sbgQDtZL4x9LBBRnVs3aKzrpcDvKIG+MbEgpoiWL0y3GQrmDFaxdR/L7PErrDVSjQ470HGjQAAcQp9v+zZ17KYnLEvEfSdP6xnL9cNaBTr/mKZc2rxkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8h13pN17nwKkosapmrQb8KrrX6dM0ZhQARIxWDr/YAE=;
 b=AOvqSGAyYJyL1HlDeaSynnd5LzzL/d5A1MusC8UdId5hNAd+af4suCilZ2aheN8t40IufcxMc99i/wDgv6ftKklubnTwLO7xXoUPBZewzXJE3VYfIIXdS6PBCtcCKSZbxnhJ7lRxUO/Ao+GbYYoLcY31sRTb7+L1LDezSbmBripweGJwoeHN1+F84R5/upPce5k12spAlnJIobFkF4mfR39RDEKJ+d31/MwwFArRr5A31fbrgcP2JnhKBMF6ClMRGWR0Euxt8jxUZlaydo9ZKCCT08bhMTkHo5D8k6nPFIVW4kPlTS1FVEYLi7dg5cSsfscHuYcX1YF0k0G9cjHFqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8h13pN17nwKkosapmrQb8KrrX6dM0ZhQARIxWDr/YAE=;
 b=UQmKp883fhB9IO6dntBzUscVOKW+IhXLJjIuTmbwVRQ9G4Au9wL51/FVuCHFRdhAqMq1B2Ui2ZjZYr1bi3VUZq8Ty/5jr7e/B+2tii57k2ZX2Rw99ZASjuXKgvOmPyCUK6hWjCPyLfnYv+K3PgUehLrrmgMpJGeX+8nnC8cz2Wo=
Received: from AM9PR04MB8397.eurprd04.prod.outlook.com (2603:10a6:20b:3b5::5)
 by DBBPR04MB7802.eurprd04.prod.outlook.com (2603:10a6:10:1f0::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.20; Fri, 9 Sep
 2022 14:36:37 +0000
Received: from AM9PR04MB8397.eurprd04.prod.outlook.com
 ([fe80::950d:bfe8:d27f:8981]) by AM9PR04MB8397.eurprd04.prod.outlook.com
 ([fe80::950d:bfe8:d27f:8981%6]) with mapi id 15.20.5612.020; Fri, 9 Sep 2022
 14:36:37 +0000
From:   Claudiu Manoil <claudiu.manoil@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Richie Pearn <richard.pearn@nxp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net-next 2/2] net: enetc: expose some standardized ethtool
 counters
Thread-Topic: [PATCH net-next 2/2] net: enetc: expose some standardized
 ethtool counters
Thread-Index: AQHYxECk5ZldNY/NRU2E4Z4g0qMhsa3XKk7w
Date:   Fri, 9 Sep 2022 14:36:36 +0000
Message-ID: <AM9PR04MB8397A3D2CDD3217201AD6CA196439@AM9PR04MB8397.eurprd04.prod.outlook.com>
References: <20220909113800.55225-1-vladimir.oltean@nxp.com>
 <20220909113800.55225-3-vladimir.oltean@nxp.com>
In-Reply-To: <20220909113800.55225-3-vladimir.oltean@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AM9PR04MB8397:EE_|DBBPR04MB7802:EE_
x-ms-office365-filtering-correlation-id: a7c2e422-ac28-4e84-55b4-08da9270b35b
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: DU/1a5I/aVLQtdAsuKsPqWtfw0qe1ql7eax7NZvjAIcJidZ8KCs7fnbOahwHNm3vLYg7/QzFJFcEfMEwQhT1zd0gDIv9YZQLoWdPAwGceB+ts4fPtamuUbSW8L43oopq+ptwVEZf0cF6hUuiGSeEcvvimGPXTNSJQMds/NtLbkXeGHRjLRoxgiXlXJm3zwmcUbfAaI+nE2XqU1fyQhmxmZYeaHYqN46v1ZdVhEt3CHIHVksxGUTaYgVpIzvqPAZhmthLx72PJHuxdtIGdhGcpeLjmTDaSepGr/tGe1HyZBmcB7OiKxnKMe0R8xuGOxVAPQzJu/Dp2a6/pVBDLl3JbjB5hNQzrttfFMbsR+N37ZlzvUjq3pTqSwswnQ/7iW2a0bHmw3feJbhH5XvMXQhzI4vdsVy1702JJMazgWGC57j4qhmZlkiLBNfB6uz1FfAkkpYUVuxUoaPWGCRwYC5qPjimua1J8GT4bCHELcKBVzJg2EeS9dWP0/GPsKZtoJ9iMmYa6ve3A3eNYhuhrMI25p+pcQ0pazMQiQkA/gsK+0H6UAI+ffw55IykEj2jWjdYblOdNCr0T5HqKZETbIwfjUXUJPczE6pS+wvtJhdu6VNLmCPKdaT9OeQZ1XbNAV1mmVC8OhkqcP9vO/Cks244yJ5IZNcR1lqR9tIV/62SWDNkFUecuyQ9gMLLbsFt47suVE7s9+Ni3+v4LQhk0dXh530w2SHH7w0JVOVND7Tqx9au5oSMFwykgMtAJy6nR0wFf2/+H3Pn3of20tZbzefu6w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8397.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(346002)(136003)(39860400002)(366004)(376002)(66556008)(64756008)(66446008)(66476007)(52536014)(38100700002)(122000001)(5660300002)(86362001)(38070700005)(83380400001)(186003)(53546011)(6506007)(9686003)(7696005)(41300700001)(26005)(71200400001)(478600001)(316002)(8936002)(66946007)(33656002)(76116006)(55016003)(8676002)(4326008)(54906003)(110136005)(4744005)(44832011)(2906002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?zUWpD8Mze2h9Bu7GhvL6BJeuSF3edWuH38Ktgzuv4GTK2QQ7SYt3dg5Jm9t9?=
 =?us-ascii?Q?WP1oUsGAStUd4QcRInt99acLLvk53rtTYK0zDGCr+novZWwHDA2ZUF0l0fEV?=
 =?us-ascii?Q?x9aHdOHlhgUbGm6sTcH7V3tO5LXuO+mvpwYWlw5A8CqrmoQSLHlvoIeMz6hN?=
 =?us-ascii?Q?8qMllqHT5IxV0bvNBgbxQoG+RY6E+unY7XE1Kh89hzD0s4RDjWTXBxeRHYgn?=
 =?us-ascii?Q?33fMON7DhHsVV07iyeGkXkOPmFBpXt/056Cdmu8MvGXX1n5jj86qVk/0gQm6?=
 =?us-ascii?Q?iOqkJD29E0Ooa/kHUf5TLDNYz/VjYtsZJ2HX4kirzn96aYqQh3M1SL/CGu+r?=
 =?us-ascii?Q?tVDjHvwULZt6q9w2wqZRyQsjOQd7KTh5fhq8SUEgEtxIZrQScsHha1j038jb?=
 =?us-ascii?Q?cPije+vxLpqerpmPIzVk/5rCSC/hNQ4svnmS1/vqjQp4zZFgGNuFbEB3zKJ8?=
 =?us-ascii?Q?WeKXcMUhNN7S3EyDJ0Ycz/bLdGBVwf3oKSeetx2SV3FEMQlmcT0eDtDbK8kV?=
 =?us-ascii?Q?8o2/nkvgykOTsKznv22LqtGPJSnZSAbU+BFF+gpDljx+5Z/iTYsSaSOZGE2d?=
 =?us-ascii?Q?0Wmn9OOF4kEhL6a7Tsle8I90aZgxq00CqylgNPfFNcHfwDeiExAK3qbT5BY3?=
 =?us-ascii?Q?xMX1qZqSvzHsm5RtUKq4kdoad+D/F6EgxR3EaUB6X+mr4w2RWqaQuJDzP/pm?=
 =?us-ascii?Q?BdQ+dZxUhrMJ0F/HYXUKHP5ZoyfYb5aH2j319LF5RkJgyzIC+zvgolq4EUbu?=
 =?us-ascii?Q?xvVUObve0a05fIWwHM323j8F9ZEydmekTDT7krFMBMpMimrqsFsf66294tYG?=
 =?us-ascii?Q?GFZiQlhRem8+CCd+p5ZOkWZhnlQF8ItrAIjelYTsZiS2dwYdAKoIsGQm2XU5?=
 =?us-ascii?Q?zZEcp9Lqj3sqTSnTuNWG4bUROSQnBEsyyc39Xtanm1VvXCED7BoJo7pz5tnj?=
 =?us-ascii?Q?oEzPAynS/H/5NuC3YKmFAZQaZhHEEUPdxBjjjd2UZCRNttcR8UaqF/DarLnJ?=
 =?us-ascii?Q?6GSfXv1X06b4aKazAQLZyJ3F+0x4Lztt/SOCes1UeIBgzXrEo4ec+Wq1CQYY?=
 =?us-ascii?Q?x5Y/bqMOtqOt372mT7zwSwz2rR4Cj5H5mc/cKdJ8HBSl8FdTXO0pvCLa/pMP?=
 =?us-ascii?Q?mGlb9ebSGdRBPg+Fey2gn/I5m976bKa/2NWiLtzMh31yE2Ji9LIUFsfmHUAn?=
 =?us-ascii?Q?/PjBM3a9zEyrdmjaPFzca8tC40puoXsrdpd8u/bPewFg1tbyp8FOgK6pdB4m?=
 =?us-ascii?Q?Wcv/tlfEDDkYRiZ/+alEdrIh0V3wMJ71EASilnumPSaXGgMVmUU7kABP8OoU?=
 =?us-ascii?Q?RFCaotmL8g+SVihZiyyCDL8gGqjcOa+eFkgZ7gDMj9P1mRgv9HU4qM/VLfYA?=
 =?us-ascii?Q?YBIGR0AA4CUXVCF+7aUov3ZQn5r3efKYyXXhcrz5JanLCMAfmwZwzU2BSb8e?=
 =?us-ascii?Q?icjWKzv06Nn49q9qs9ddr8AvKxeoJouutfbwyGtsbOedwIk/CqH0Rq8VoosW?=
 =?us-ascii?Q?mgGogKiNeXin8kqvrJJ/QoATQoeg/5oh9rJa1rSRnBI9wKS6g+XrUDPq1hVg?=
 =?us-ascii?Q?rTt4MYbDtmhOReaWhbZMTz8k2eMX/JBcENIIJUHr?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8397.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a7c2e422-ac28-4e84-55b4-08da9270b35b
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Sep 2022 14:36:36.8977
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Ea3M9pE6jXjujyhhBvoGqEGpGAd/sp8bVAP/uqeMDcLYxauJB1NE21QE0INy1jRXfFPm+FxHYu/3mUem5Xt0cw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR04MB7802
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> Sent: Friday, September 9, 2022 2:38 PM
> To: netdev@vger.kernel.org
> Cc: David S. Miller <davem@davemloft.net>; Eric Dumazet
> <edumazet@google.com>; Jakub Kicinski <kuba@kernel.org>; Paolo Abeni
> <pabeni@redhat.com>; Xiaoliang Yang <xiaoliang.yang_1@nxp.com>; Claudiu
> Manoil <claudiu.manoil@nxp.com>; Richie Pearn <richard.pearn@nxp.com>;
> linux-kernel@vger.kernel.org
> Subject: [PATCH net-next 2/2] net: enetc: expose some standardized ethtoo=
l
> counters
>=20
> Structure the code in such a way that it can be reused later for the
> pMAC statistics, by just changing the "mac" argument to 1.
>=20
> Usage:
> ethtool --include-statistics --show-pause eno2
> ethtool -S eno0 --groups eth-mac
> ethtool -S eno0 --groups eth-ctrl
> ethtool -S eno0 --groups rmon
>=20
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Claudiu Manoil <claudiu.manoil@nxp.com>

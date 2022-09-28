Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACD245ED795
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 10:21:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233301AbiI1IVv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Sep 2022 04:21:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233055AbiI1IVt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 04:21:49 -0400
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-eopbgr80072.outbound.protection.outlook.com [40.107.8.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B99A32D88
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 01:21:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RiMbcGw3UoJpxxX/RqrDQKWytFFodr+LqOY5cu5GEOG5PZaotL10zrvADBgwM1ymh0VhxGA5Xf3KN2whKf9MHuN1xxyJzCaemcFRTylvAXwOgajax/KHFlyc7eJmB6zaLVcxIARlCWdvbDZf5xgbMoOPXu9y3+YH77gGU9ppxXn35qANdfNTYenga9Pz2l93U4E6d3mOFnCRekFQnWdFa3OgYd4Lby6Az489wCHQMtoE4noHC7gciqcJwrSueQiQDzU4Zj2WiIpei2wWs9gjxKU8ZqmgWP++rTqEC7UDhQDESkDPwBam/3LegAXD5VPeSXr22UWldImXwnG8bvyl9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F3+Wb1gYKao9mBOFjA0lihcFQRONAEuuDcTZkqqWqHo=;
 b=bMNKgB0KLd1nBQU+K/dUGrjSUwygwrfBRSJksHFMq37MlOvlo2BaJa2AED57Ac2KAWrmsq9LlY11N1vsu8Jzs3mHbTOYzH52CszL+1HdbpUPQBa0eloWXoINdfSWNmP28PqgMRjC+/jeI/guMPwwNRZtmfmlQaawc9SzvsbA6AfpTsYnjNfAzKqPj2yUPgSmr1flEsLQZIcsvjD3pf71kvicZEZzm8vFC75NxZhSVzbDmHYk8sCTZOmEn1P6JqvRLVUMeaLcFRfG9Rn/fa8BwEix4Ir2MrNSfKinQFQJ42BI1ipiPhocpiZEU4u+pEMTp29dwIW5AzIGqp+cGQ91Tg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F3+Wb1gYKao9mBOFjA0lihcFQRONAEuuDcTZkqqWqHo=;
 b=hEzzIGwM1LUcT7QkAWlre2CZWY5Kpls2I0uX5sG4CO0SpiEynELzYZzG37I6ec5Yr2HaJNRX6EkIOvIV8jp6NCOA8avcUH4hUMNi1/i1zigIbeUFciais4X/OBQ7IqnyWhjZ3bCZtRs4krbzihpCBbKo3+xE5lXNxt3SA1fcdJE=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB6927.eurprd04.prod.outlook.com (2603:10a6:803:139::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.26; Wed, 28 Sep
 2022 08:21:46 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1%7]) with mapi id 15.20.5654.025; Wed, 28 Sep 2022
 08:21:46 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     David Ahern <dsahern@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH v3 iproute2-next] ip link: add sub-command to view and
 change DSA conduit interface
Thread-Topic: [PATCH v3 iproute2-next] ip link: add sub-command to view and
 change DSA conduit interface
Thread-Index: AQHYzs+rqryJG/wc00aau8OfmVsVHK30M80AgABVRIA=
Date:   Wed, 28 Sep 2022 08:21:46 +0000
Message-ID: <20220928082145.graecwgfrsnblv25@skbuf>
References: <20220922220655.2183524-1-vladimir.oltean@nxp.com>
 <8eb279e1-07e6-4326-7d81-8b7e4edc968a@kernel.org>
In-Reply-To: <8eb279e1-07e6-4326-7d81-8b7e4edc968a@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: VI1PR04MB5136:EE_|VI1PR04MB6927:EE_
x-ms-office365-filtering-correlation-id: 9ee5e91f-92f8-4edc-10a2-08daa12a7ba9
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: bhSpLTLYQxSIev2rokoh/caLSWODrnfCzK6sT+lGvFfJ8LxnGqTNsBUw2qwR7JjLrU/oO+RHQcRArxnU6/SZVFN0+RN2UJJNRevDE95WOgLDgHtReYAV0tpj6QhqwzCsKLORuMEWH4fVMkvEcMBi+8pMF7OAbk0Dllu4dCpND9RovZrZzU4pdxS3DQ6ghpwoteWOw+9EogE8sr+7sVlVKJB4+gANeH7uhUSKVFNuRQan4M2JLBvvyuYpEmOd7qFuuiYisTKwCe7iBGjvMVNXzJy4faj8xMrYK2M010pl8Kj2/g7rOgfS1YDbMz1bxbHubVQXnx3zFauvdn4EBYqpNyFP55/0B8c1z2mE2fGuUDOQ73KLiZbazSPY9igbNBC8qsKDJV/yM3A1fOShKb5I5H9G1p+RZTvsBdekX6fNzn3DMqKGbBIweSbGxhqdHjjppct2cV4b9hJTwYUhW6IYVVip9Sp4M01TDqonUHtXRRW2q3sqoS7t8mm1xgxomw7tLqQk+/Jo6DZEBdEngnoB4ObFVejdw9AyrI338fhHtKJwNZxjYMx/sFlOaqQ9+sdDb1u/bB8vH03PN/bgPYiiRaGMpviFvR2MutUcDBhJt/4hKrnAq3iZ/uRh5W5izYuf2sMuhI9QZlpn7bH+htb/Eprt2r9Qy5J2y1fMMGmQcXkSt7YjMnXHWQq0NRNiRwlTNEGERbYGA8SjQMSGV9O+I6eETB0q18gs+R7smaElEOl0m1IBS9HyyiXIng4oJ/gu
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(4636009)(366004)(396003)(376002)(136003)(346002)(39860400002)(451199015)(9686003)(66446008)(66476007)(86362001)(66556008)(558084003)(5660300002)(8936002)(6916009)(41300700001)(4326008)(2906002)(76116006)(66946007)(8676002)(91956017)(316002)(44832011)(64756008)(54906003)(38070700005)(122000001)(6486002)(38100700002)(6512007)(33716001)(26005)(186003)(71200400001)(6506007)(478600001)(1076003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?vmj52VUm0xIJRqIMGEiQnaEIveJq6lG0Bbrmp8Wf4raA5cvXs/dcTOso9DdH?=
 =?us-ascii?Q?/olQ18XYycwGMHru4TJ3sDgJrTor4g+Li5wqxJ3mHVgn6WLSHoUTjlZZ6F3m?=
 =?us-ascii?Q?OHyWHvenDZ0loNpfF20A9G+FLZ50YmTOzaWzIXpRmcFQRVBpL0YO6hW/T9Z8?=
 =?us-ascii?Q?Mst32Ni+TqLWn7KjNmSNtSaR9rlGDzPIOMzG1RXn6BQddJ42wIZPCbZBbvLR?=
 =?us-ascii?Q?17MdzQ8Vn3VWJDkDhnIHYc6nBHobcfhuUiC0jFYBimOGEYwDDnZ+L4j93Pq9?=
 =?us-ascii?Q?/JFm9CdyHumpEIB6YnGm6a72rqGTVsp97SKJqTL7VMbjY9m9NYWg3+qNL21w?=
 =?us-ascii?Q?kgGKHOjJyy1ad+EWOqrUazlIpPDRRxMlxkAxPZsuSZSyQqL//a2+1v4ZzVao?=
 =?us-ascii?Q?xwjpOP8D9cmZNqshLT2O5zxHt7hK3V4F9rd1wOK81WMKnd5zbo56xiNnnA5F?=
 =?us-ascii?Q?57Yz9hQ4LcNaignVGmtyN7YMNjCAkn5kty9kztcyGb/5BaLOKHak45nlqwkX?=
 =?us-ascii?Q?U5EWs+aaMpeTPGXv4LBQ0rqqdoUeFfkO9Dg6M/ILM6Fypm4Y6+9p4IWgQoFk?=
 =?us-ascii?Q?7qSimguNR3H+2tYBxR456jWjE/UY1pab7n8M7TVKqtQ4/rzIxX15eZeWMW/W?=
 =?us-ascii?Q?73vsNPiZGPvADDxq0zSzMmAyydQvAM7IX/YxwBZuw06CxkmGQnJm3WxcOi13?=
 =?us-ascii?Q?fFGOyYyPKPQvvnI1u4ABepHMiZN3Ob59LKLVFtdV0RET6APAevbbqxazQrtt?=
 =?us-ascii?Q?djkLA0g5HWqo8p5/7cC3NROb8rTMHLMx5lCpgO/HkkMgFpQsBfxa8k8fdSgu?=
 =?us-ascii?Q?lMtz1xv+vMBfRg4i/4J6RfhfJX7NCsTdEF0QrziDWsk1CCtbH7+1NI9uOCm8?=
 =?us-ascii?Q?Oukcx1GdKdk0H5LdM42W5l/5Kqdw6ps8SjO/rI3Mf2uVz3QBt7Z8rQ/72+sV?=
 =?us-ascii?Q?4nosEJ2GHwjLjdpMdIiWkfzkjRZ1LI+LDrj0tKeNi8XsoRqjHRsY2C3AXAlv?=
 =?us-ascii?Q?v86uVEV077ehIZAlpT/IynIssUqV6knHf4qPnOGkd/lw+I6XTS4MWwVaIqHy?=
 =?us-ascii?Q?Eh0oaSUh+C79PYcjWbOjpz9qsrapLtFyLc2x3VVDyX5KYL2o6ux6WGlMDXcj?=
 =?us-ascii?Q?k1SCTHM/4SO3Mf8CXeMYwFEo9yVMF4CiOEIyZwqr9eiGfaFi80fZeVEu3kUO?=
 =?us-ascii?Q?BR3x7m9CdYjCXryHdznZTB3BwzobCqS/gZXfkImX/+5mPeh/VLfn7dzZf/EA?=
 =?us-ascii?Q?k6fG6LoOFrSCFdyCq4KD3RodFOn6e2fzjKBeQsniDLzoRrEXRseN3otiY3bB?=
 =?us-ascii?Q?ytoAWq7Rw+Il/uZGpwU9fkgQwMnIQWMGmp180qRj6WrSzulGrF3bGVRTPWG5?=
 =?us-ascii?Q?nVhdanK8nKLyA8SUh8TwmgNFM308T3vFoSt3WxbwYk71AgfSmytVWdML8Nad?=
 =?us-ascii?Q?ml+/y4FY5iggMAatNsJZM+F6Ywk7el1acjiw3BrDoWbn6hkDPoZeNdcZ9G6k?=
 =?us-ascii?Q?2IQtAx0VYr69Wfjg4UjRTuuqTFwNImov6wV1WaA5j2I4BAG+BMRyyaIU9Mer?=
 =?us-ascii?Q?oN0ost9G0Z1XIbEgXbRXgocp9j6iTVcDtOY/LgacI7VXAFgGCaCWJyItKCIH?=
 =?us-ascii?Q?aQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <F836B3611DAD2549977FD98B155A1505@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ee5e91f-92f8-4edc-10a2-08daa12a7ba9
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Sep 2022 08:21:46.1409
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XUspw5+1ewiVJCs015N6ovTIAfb+IOFqApfZHRDfYRMLpt7KjyUp1kr1G374D+mrkPikXM+q23yMsxDHLDk1jg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6927
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 27, 2022 at 09:16:34PM -0600, David Ahern wrote:
> applied to iproute2-next.
>=20
> always create patches against top of tree. had you done so I would not
> have had to strip the uapi piece since it is already there.

I don't know what went wrong, sorry. I suppose I forgot to rebase v3.=

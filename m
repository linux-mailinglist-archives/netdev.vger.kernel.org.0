Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 133A5614F16
	for <lists+netdev@lfdr.de>; Tue,  1 Nov 2022 17:21:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229828AbiKAQVM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Nov 2022 12:21:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229587AbiKAQVL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Nov 2022 12:21:11 -0400
Received: from EUR03-DBA-obe.outbound.protection.outlook.com (mail-dbaeur03on2060.outbound.protection.outlook.com [40.107.104.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89ABC1CFC0
        for <netdev@vger.kernel.org>; Tue,  1 Nov 2022 09:21:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CiFMbGRO/5Cip3vpUX0/PgNEkO3CjY/vCcRnqE+6NUsjde9Z9761yZn/IpqhBvewDNyXEqEb5jWF+pdQ37tZx8lcTtwxjsDgcm2q4W9FZvHa7j4GPvokVdKjwvznbIJidm0D2biScE3ORBJq8uglJMQJXm4774VYqPB5eQtVGrq2Af8SGXrSXQ1O102+DHYwLgGHX7oDESHp7JGKITuQoZBHsU5o3ppJTTLBt9ysS8Wcn37PhtGJH4CrceADBLca4FdKjAHXCmJd/A+Cp17OIrBs2TMoCwEa48LJglbuiWVLPr/HI1ssbruKZHqJI/Pme7tDVAaCRaGUWLZY42nXxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=puflJUGk2Zt2pIQLztl4/zhZZqzu2bYCoTKGiTdMPrE=;
 b=nmmVuMpyFn9VNeLytnWZoFfTyd6aEM6y/jCB6E+pCkFb4kTBiL+vJh5PNJTaPFuXXtzkdL8f8WeGZkVEaYTqxjrKgEjQNAYYoKLHEmVI5xFh/gq2fnhKg4qn7k2sdtdCuHc+ymcEFyz2ql811pV+FTxaKwafr28MI35Jzy5bH1qvLR+PL2HLx3YL+Gp6vK/dIaR5iYLr1uFLYyFdWVjXjZr0fJH11K0Xdam+6GUaPs1egNYHYv7+gqEZYQcelNtFUnjicBfJKlwPHihsI47Rzi62FyRxFHtZxzYKqqY4ABZMDcWABhcAhrB1Bnryceq/1KNEOToNW15mAGW7Gxz75Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=puflJUGk2Zt2pIQLztl4/zhZZqzu2bYCoTKGiTdMPrE=;
 b=orGiGcNxM8ysFYIugYXDjZh+eiGYf5jD5i3CqrxloX3+7pcctyJAAVRUn5smFL9iIPgtrAfdam59Jom3BRo074bmr9dXmiVfnLrDzioqZniNacayLfzpEEtXS4ikkOAk8e8VqNpxvgvPKrPOQvO+Cyi3GONUiZ3R55emQ2kUueg=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DBBPR04MB7593.eurprd04.prod.outlook.com (2603:10a6:10:20c::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5769.16; Tue, 1 Nov
 2022 16:21:07 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::df5b:6133:6d4c:a336]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::df5b:6133:6d4c:a336%7]) with mapi id 15.20.5769.018; Tue, 1 Nov 2022
 16:21:07 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Ido Schimmel <idosch@nvidia.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "jiri@resnulli.us" <jiri@resnulli.us>,
        "netdev@kapio-technology.com" <netdev@kapio-technology.com>,
        "mlxsw@nvidia.com" <mlxsw@nvidia.com>
Subject: Re: [PATCH net-next v2 1/2] rocker: Avoid unnecessary scheduling of
 work item
Thread-Topic: [PATCH net-next v2 1/2] rocker: Avoid unnecessary scheduling of
 work item
Thread-Index: AQHY7e8RR91ebiz/l0G/tRTmURrfjA==
Date:   Tue, 1 Nov 2022 16:21:07 +0000
Message-ID: <20221101162106.xaikqelommua5xib@skbuf>
References: <20221101123936.1900453-1-idosch@nvidia.com>
 <20221101123936.1900453-1-idosch@nvidia.com>
 <20221101123936.1900453-2-idosch@nvidia.com>
 <20221101123936.1900453-2-idosch@nvidia.com>
In-Reply-To: <20221101123936.1900453-2-idosch@nvidia.com>
 <20221101123936.1900453-2-idosch@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: VI1PR04MB5136:EE_|DBBPR04MB7593:EE_
x-ms-office365-filtering-correlation-id: e2d09e3b-0534-4265-198d-08dabc2514c9
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: LD8rqISEbhkrD3f/mhIWkHSEPh+fcfjc6mxM9AlXmn8AUG3BI0euf/tx/8ACRTIDmaB6UAQv9DWqH4Jc3/jITdqVlcDGdi+R40ZFv53ZQP1ac9pWl3rgqr3iJpU3AM/7Sck4CrJC64g6DevR9UBl0XV7Li1ke0Z3I+w/ExTrzsxF1d7N1AvkY1VgkAC1pg51rGhurDZP0DdtSK7N0vnozAEbrPvUB8nOaS+hTSfiuCFluL9LQ/EON6MtTQKeUsqMHwn75+h1/X1t5dhTE9ohVJgM2k4xhxoi0z1KTR/FoJTVy7yfcyUu8f0MtwWMeDaUdfjycjTT0fsDrNy86s050TrmPSE0zD2HB3t462I1IPO8/xMpt3vXkGtZXQOaSdkBmYXdPQyEdBBvQhpZxyFHw7zm7lOlj/wSPXKSXMDmp6n78sZohd0UKdUScYEqz95yUYN8D1xRzwP95WSLzC6dxs3ArnfluY/X+HbbtMtUa933QdqIKPjOZDHr+jaa2neAkJVU77kusrUPIi7npbYeVZZ5FM3mvq2cy+jRdheABEm5wz/jxIOJjVDQvKhPHPMSPh9qCh6OPxy9V7dbhw06x5xH4sz8OWFTfjTvxaGtsHy6LJbptM6U3ja/N3ujdZHFHD2YFhPvb2zNS5nV5S+arHCPKSsy01YSJESTzU6v5lsgn0KiR/E4mf2SduCAnmAfumc+ZfHOcQNoYg1EY+qm1JZzxzuyosPOyHGjjQ0i0y1bKsrQStCXhNzMk/6rPqXXIIO/YUgaYN3sBI0LPfkTcA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(7916004)(136003)(376002)(346002)(366004)(39860400002)(396003)(451199015)(122000001)(44832011)(38100700002)(38070700005)(4744005)(33716001)(6486002)(2906002)(71200400001)(316002)(478600001)(66476007)(66556008)(66446008)(9686003)(41300700001)(64756008)(66946007)(8676002)(54906003)(8936002)(5660300002)(6916009)(4326008)(186003)(86362001)(76116006)(91956017)(6506007)(1076003)(6512007)(26005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?6E4Ljtl1VlS1ZXE8oatJNgdT8HSomVKTw2DyiHAGmSnuu53erOX8nSOeG/pT?=
 =?us-ascii?Q?aQNN8p6qPO/zJO8MQIt4sArMQfNzKwYORjTx37XCIk21QkipVx4Ozcv7BcAH?=
 =?us-ascii?Q?b2BpWumIDtSNsI8Nnmg1PtaNl4FlJJCe1S6Ae5ezqNaJ3FHYpWPib7pz3ld/?=
 =?us-ascii?Q?h1JkhsPiCS0TE1tAEwm6Dv/mBoGHdPRc+zbz46qm4KwLfSsJ3nS/HLXM8jQH?=
 =?us-ascii?Q?Fjq+yljAXA+IgdipNbWyrhnTOeTuSya8LqayyVTpPW55Y9Wj4/OVPuCywatK?=
 =?us-ascii?Q?JIwzCw+h/Vc6x9oJ6xpMUnqWXZzao4rg8UtqLHxOLDZVaWyY0edPVlUyzbIy?=
 =?us-ascii?Q?PEYxZlJR8YxZa/tbx5b5nnz+cAVp9riFhajtJ5ZnGQVI/XOLV0TVvFaApIjY?=
 =?us-ascii?Q?lkN5U1OrBhs7fnM6wK0TPCcRiFrAs6agxMGpRMB+EtWm2eSRWwutxY5dMU7X?=
 =?us-ascii?Q?TdYx/P/LUUVDSXngoO3Zv1w+rXMox9JDygBZmbNdiOeB8Xdc87O20hYxN1sf?=
 =?us-ascii?Q?JT/x248oNwxnSbelt5qalEDUNUm1yqDVZjqag5b5oaHF0WjK5j138RLGGGih?=
 =?us-ascii?Q?kiD7/ATdN2JWefKumlFoq140tUq2W6zgOio0LOJP9OsGbxuW5hIbUi/pLxzz?=
 =?us-ascii?Q?T2iio69U+0Zz1CgltfnZZuQ2Im4uOvoq2A7Q1gTNbaSg3AOq+FdyHWBiv+6/?=
 =?us-ascii?Q?v8JRYFBGEUwGlhhVbDTYBzkd/D4G8bqpGoxYLaeBhZXQ9JegNN3zJAnO9OV/?=
 =?us-ascii?Q?FzQg2ciuqBo1Ku+D6ZnNmqURTE9u7jCLy7TJWky1uhJN4z3lezQBnvenpOMH?=
 =?us-ascii?Q?xt8icC/tHAaM1jD0qhMFbLhSe3pnAzlpY5Bza5AyneoifiSHyfB1gtWdHhOM?=
 =?us-ascii?Q?Zx2slRjIeKmeSkPPNcHq+Lc0ZEm+YhXkEVlI/OpwhG+Q4g2a+jbaz6HQ23Am?=
 =?us-ascii?Q?gUA+gCjTsATUhFVAkaIFWgU8CPeAHNYn/TJJna/fR5lCPQjcafXp31xEq5cP?=
 =?us-ascii?Q?3TU7nssZ9P8Hff+q+T6Ar0AXnL9TG0o3zbwOxzvAirMTBYopQGYM0YF8FmXx?=
 =?us-ascii?Q?F/POIRZ+7B5qjVbLPHBshrj9KpLxQ0lNH3PaRjr+5b6vHbvzGu2VKv4mNc43?=
 =?us-ascii?Q?Juu8T/9qb8DKwbk2m1h5cLKFiz0vdn59gjgOehJxtGYiXZvPSrPVFxSiGUdo?=
 =?us-ascii?Q?5HoLrAUVJHfTifbJzYDEIX3liy/FzeeU+3v1wn0aUyLw3SuSuyapad9YKZey?=
 =?us-ascii?Q?sNEE7qmak4jjIE1H2/9iCRdpQNZS8w4K6aF73uLsrwawNDTSu1qQ5UD563Kj?=
 =?us-ascii?Q?YV/banOhllG9qkHdXP/ipOU/s7CLAYV02ccaeVQCNkN24tYtK52Y/DaAvg4v?=
 =?us-ascii?Q?fTCXb9SktrxLvkcW9LMvMEO+ZemqlEpqpiF6ciC4OyuSDHOoQT8TpCakxyko?=
 =?us-ascii?Q?IPKPbhr+z2vbQTwnmCoc6Wrs6Hb37vRVt8kioAY2278PkNXcNtINfrfVHvja?=
 =?us-ascii?Q?Bu97GeJaOv6KA3T+NUCaVzM9kohfsxKTgPw8UqwKj1lz91u2TKf2glJmG+2N?=
 =?us-ascii?Q?1chkSZjSf3ZvsBv/U0U1VXXbxfPMy747DdeMy+hHPo/+5dPkkh27mjYKHEjF?=
 =?us-ascii?Q?QA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <40EF72DA00AB2648A774CB9BE6134F2E@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e2d09e3b-0534-4265-198d-08dabc2514c9
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Nov 2022 16:21:07.4413
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dkWGkTQqrbUp9cTvE7mbJNkuEfcSzBe/TeLj2eltjzkZJgSu1RV3QZxLPoYvMk3EHWl56E9M1x7e0DFxzcw4JA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR04MB7593
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 01, 2022 at 02:39:35PM +0200, Ido Schimmel wrote:
> The work item function ofdpa_port_fdb_learn_work() does not do anything
> when 'OFDPA_OP_FLAG_LEARNED' is not set in the work item's flags.
>=20
> Therefore, do not allocate and do not schedule the work item when the
> flag is not set.
>=20
> Suggested-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> ---

Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>=

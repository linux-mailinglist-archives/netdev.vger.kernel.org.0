Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3D2B511D8A
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 20:35:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240201AbiD0PuV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 11:50:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240256AbiD0PuU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 11:50:20 -0400
Received: from EUR01-VE1-obe.outbound.protection.outlook.com (mail-eopbgr140072.outbound.protection.outlook.com [40.107.14.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25C7E506FD;
        Wed, 27 Apr 2022 08:47:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MaSjOhP49sra+25WxPbvX5MNS86Aq0wLDEvBVO2EWoDJKzoZvT2qglNEkJPARcGl0l9Z++u9Md0Myc51zmRKCNyywwUCKHrTfw0dUUt0k3yIq1OTFFC0hWuyVDkDWyczhYr8+G19HGtszmuYRJ9slpS3d8mTqEB8kBsyeA3CR17MGVCX7NIC7V7eJzOe+NyUuqaMxXe9TH9NIwJnpYgQQBf5MKJZnB8qj3EE6FW8gR2Z+T/IV25sQ6z8Is3kSPh6OoOqHbXoexE1ULoNBQBi4NWwCMQOnbJQ3J0Y8HyqmVPRz19I5bI9u89EB6QIrkldcTKXxzUmXYJ0bzwrrWnshQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zqprnRiMa79x+c0EPgRIbwGEynoKGAQyne3/nFUGuUg=;
 b=QVMyCqVQmb35kWg3LS3P5z5ha/6gYGoXFzLyfEeEkKs1AV9Z+LXWDOy4lzNGeZ9aKXq4MDP1Qx9JS01X6tD4oKliHtTfdXoemytX/C1DMUNXlQLhma5JKcIMUb2o4DQwgWdSy8UFPj53PwAqJKxxmDHFmZRwTMSx55wJguoQ6dKtcpoNw5LowDOTYswmXSbTdyJ9q6Ffp00mNvECqYkq2uMeJrPHKeoVqw0getUw1lymwRv4p3XqjDvXUJUmLMzgDyfluxf6vrXYMggCmOJwfh1xufp3R7sRSHY4DLvTCKr9H2fNX7oCbBYKSUKVBnmKWbbJKLS+GtWYm0RDBHfgYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zqprnRiMa79x+c0EPgRIbwGEynoKGAQyne3/nFUGuUg=;
 b=OhA1liVqO8wfotGkDqiKk/aoOjX9nHu6u6w4KROG134x7aZRezdbswx6ICGKEmueZZZTKLbMOapVRWYO08AL2WZOACidmDAuSb/QGXhq0+p2VPk/Q/EI7vmcAghHUOwf8d3CDNdsm1UOXxd+BveJoET4qBbwJiMwvIK4ePHa3nc=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM6PR04MB5349.eurprd04.prod.outlook.com (2603:10a6:20b:9b::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.13; Wed, 27 Apr
 2022 15:47:03 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::8ed:49e7:d2e7:c55e]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::8ed:49e7:d2e7:c55e%3]) with mapi id 15.20.5164.031; Wed, 27 Apr 2022
 15:47:03 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "grygorii.strashko@ti.com" <grygorii.strashko@ti.com>,
        "chi.minghao@zte.com.cn" <chi.minghao@zte.com.cn>,
        "toke@redhat.com" <toke@redhat.com>,
        "chenhao288@hisilicon.com" <chenhao288@hisilicon.com>,
        "moyufeng@huawei.com" <moyufeng@huawei.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Subject: Re: [PATCH net-next 03/14] eth: cpsw: remove a copy of the
 NAPI_POLL_WEIGHT define
Thread-Topic: [PATCH net-next 03/14] eth: cpsw: remove a copy of the
 NAPI_POLL_WEIGHT define
Thread-Index: AQHYWk1CLMHtk+WZGk67j9eBjXAa660D53gA
Date:   Wed, 27 Apr 2022 15:47:03 +0000
Message-ID: <20220427154702.fbpxfjp4h7ey5ea2@skbuf>
References: <20220427154111.529975-1-kuba@kernel.org>
 <20220427154111.529975-4-kuba@kernel.org>
In-Reply-To: <20220427154111.529975-4-kuba@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b10d7e22-fecb-4815-b6fe-08da28652cca
x-ms-traffictypediagnostic: AM6PR04MB5349:EE_
x-microsoft-antispam-prvs: <AM6PR04MB5349508B9FD9C9D36B3EAC76E0FA9@AM6PR04MB5349.eurprd04.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: m5QW4HaufYfCoFQZNMSxg47qx+qOjy5NiGRm3NFnkL0BBLz1vb6/NMX4wqK5A/jG7Pm2KmqI90VVKDc7Ugh+29bc5ib1PtWUScozJGyv7B16osXMnBrsqsQzux3DWAsCkrLBvxFPw3Tm42NlaLdHjCRh41mc8sJyB/1oGm3cTpuobm0nedbYJL4n6DrLVWXaUUmkVl6lJbV+9f+OTSCqctM8pOPtBAvaQUbrqDQQ+ACLXijkt6Mp0yDm9sxFFgmtt7cSHjQPEuN+3rdVXuB4nX7DmxfgIHjLEla5rxyEA4Wlz+3HpZDsFfr5ZQcFghddhdgMVHB3t6psfkWowYXV5T/v76AXMcc3cr0uUvnqG+/0ymMiuFo1dGTUbMfQ3z213hinTiZTwNh+EJEnHVCEscIWfs2YtQwBUZYPO6UbX6zkZyFrIHHkIJZgocVamjaxYXmIxLPKtR+iNV42I9Bfzdbqwx8lfwITtB1G/4CxX4LFHZOsSpCYL1ZCroMauQUsx5OgZAmb6Ol9iRBzd1VfALC4A9rZ59p59Da4ovesad9BJlwjbca7NcKyhtnOIgB7gCkEpD0IIw4i6cSxyFcFcrc862yX0Q4BbaDiVNPTDLIY1ZNHeIhy8mYd/uuglM3rKWkIyKlQG8jdEseOQ2tdOPW76BfdnYAtNgTcT8sLTYHypSO1ynkJdkrh1oE3jzyWOaw73j5uCFBd1yQfEWGzcwjY4WK3yZt3ZyIbVt5ejn4=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(4636009)(366004)(38070700005)(38100700002)(9686003)(1076003)(6506007)(6512007)(26005)(122000001)(5660300002)(7416002)(44832011)(2906002)(186003)(4744005)(508600001)(71200400001)(6486002)(54906003)(6916009)(8936002)(76116006)(86362001)(91956017)(33716001)(8676002)(66946007)(4326008)(66476007)(64756008)(66556008)(66446008)(316002)(16393002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?MxQuT4jjr1XsdwTStEFoeGVxyRwFKZO1Uol8Pn3fgfd2Vz1i6CYHoU420YGt?=
 =?us-ascii?Q?eR0mwLPWy0rFPHcIjPTnvVqvIzzU4A5pFTiswn4MLy83d5PAbnAbM9dRzMZw?=
 =?us-ascii?Q?sVJkaBcpPxqBXqCCW+SPJoetCjHOk1rVxy6cH5R6lp2/eZrRX61MTC3PWIwK?=
 =?us-ascii?Q?vyob9eTRKmYLvrvsMhUNFM5FZwfX/GgKNivcd4h1Qc0dTAdV0bHjQy/7e3Ei?=
 =?us-ascii?Q?20gi/SZNfS0UWcmp6Q03uU92ZBv5fS7VweALp2dOmlpmxeyVnxR4/KGvi+0B?=
 =?us-ascii?Q?ucJQSYsi3rJv/1Sbw5PENXlfQVsncYKRYziukw4WsbLxJ3gvrkfPUJlHNId6?=
 =?us-ascii?Q?LWkGZNhc8styijq9U/R1lWeChuQbAWRelr0m6PaIpNuSbGlnvcgLel2Fnu6v?=
 =?us-ascii?Q?XFeBy9T/97oDZT2sVvCFPgXpZ4HTSO+M1fBCNMrJBvrkEYV9Bwcfp44pDQ5K?=
 =?us-ascii?Q?8G/SzFR9gLOkYQd2qoAwhev+zQb9MsayQDDjZAA0Bha8NtoWVWUnpZX0G+rQ?=
 =?us-ascii?Q?/5LvAHyMvlHeF7jpdJ000jEjucdQ4CzxsNWLaV6zibGKdTLO0mSmyUcISzxI?=
 =?us-ascii?Q?MLhnEEN0/OKf9Up72tJqEaZMYkNZQjCZUhB8KZUk6iiBdS9bVQjnShDlPiag?=
 =?us-ascii?Q?KhfTBxpNrp7NE+F1sJ51ZxicX+bm9lkuUpLpZUXTFBUK7GRDJJvKosjeOoXF?=
 =?us-ascii?Q?EvSfxC/vFTxTV1K0lVWEPohB4xk8AIjbLDMeiIzmxu0Zj/Jr+nlQJPdZvyAW?=
 =?us-ascii?Q?oqkVEOgcClqTdfRa6FkG/NraqjGC5GNPwuCk0Bq3L0onYnzVTtVa2w7Nyb/P?=
 =?us-ascii?Q?NRPivOeaOkgAtt851ZBwccQVG5FvZXvwliQ20iQJ4j0gDPQd5nR4ayy8cFcl?=
 =?us-ascii?Q?PyzvoIuPJ0MLyM7OOfvioeHhp1StIl1js6omOr+ShJM1yzM7F83Tces3G3qm?=
 =?us-ascii?Q?QDJ/U0U0Pc0ZiM8P57zIXQLzi9oIZvOzCJ+LMGhBOK3EMkZeusvghTz/X2fY?=
 =?us-ascii?Q?4OwHmJwTfmKkGKvv9phQygcQi8uthrKbZIHJNJ6DkM+0vBEvn3ES3R6VzpY2?=
 =?us-ascii?Q?521ioDNpYjaSZ4Uc6KzPwe3bmwCUdtwbqsfh69DeL4wr05MgCrNN0PCM2h6W?=
 =?us-ascii?Q?voxYMMv6Y2/hWL+CgLV4PZiC60Ix4FRsjqS+o+SmGj+G1KjQsyJCZ9RhXKhF?=
 =?us-ascii?Q?cTMCFfUobNKiWW2vzAENEOrJkJVddXoKaXlkjCOzaGmJVr20ijtP4daZn7+W?=
 =?us-ascii?Q?Le9w/EL4AEUw54Eq2j2DJmWHlG4a7tQi7LuaVvg3m3ohTfXiRcEiLJJ5CpPf?=
 =?us-ascii?Q?VjZZ70o+y5gLne158Tn0Mg3O9OmhjXY6RXLe5xsHokWwOb556k5iKQDHfHt2?=
 =?us-ascii?Q?r2Q/tdszyaTV0E3oZYqLUAy8EGT/KezWMCP8laQ6Rx+9ad6ZLSx7W0girmjd?=
 =?us-ascii?Q?uDGyB6MJu2WAoc9NbaOLK5L6RLmgRoLX49YBndJKDa29XziNbxaf46htK4jC?=
 =?us-ascii?Q?2Zd7wNE8JSXaziyHlbl4DKU8BvzaIhDIBtiCbzgG8iHpB0miyfiNa+tS0xbe?=
 =?us-ascii?Q?8nVofwbBp8dAn+YyCy+uTLWmsuOxoaGeP0tw6tDpYySM/cJAtsGWtIOogK0i?=
 =?us-ascii?Q?nVzIjlALlpJuSmnSbfmzbLqy9VwmhH8u+G/0w5WQwzPQAn/Ebd9HXcFIPyGO?=
 =?us-ascii?Q?t4gx6Iqphm058SWCoWMq5tqgVgsgYQ3e0BsEmfgAqrBp7RGj4t7fJ4RGYLKU?=
 =?us-ascii?Q?tlzO3Bgqik0PUpqgj3vokT+GlmeK7O4=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <77CD97BBC4E7FC4F881BC15AF64CE48A@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b10d7e22-fecb-4815-b6fe-08da28652cca
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Apr 2022 15:47:03.3543
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bsEk9KmT1GRrEP/c1t+0hVvcZiZQw+gnhA9AoYM+NI+aiq8WLr46ag551wD0+riaP7H8r9R3fMzl45nepdqicA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB5349
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 27, 2022 at 08:41:00AM -0700, Jakub Kicinski wrote:
> Defining local versions of NAPI_POLL_WEIGHT with the same
> values in the drivers just makes refactoring harder.
>=20
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
> CC: grygorii.strashko@ti.com
> CC: chi.minghao@zte.com.cn
> CC: vladimir.oltean@nxp.com

Fine with me (I mean, I don't even know why I'm copied on cpsw changes).

Why is the weight even an argument to netif_napi_add() anyway?

> CC: toke@redhat.com
> CC: chenhao288@hisilicon.com
> CC: moyufeng@huawei.com
> CC: linux-omap@vger.kernel.org
> ---=

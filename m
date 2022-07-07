Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CA5356AE40
	for <lists+netdev@lfdr.de>; Fri,  8 Jul 2022 00:20:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236885AbiGGWUm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 18:20:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236101AbiGGWUk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 18:20:40 -0400
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-eopbgr80079.outbound.protection.outlook.com [40.107.8.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D60E606A8;
        Thu,  7 Jul 2022 15:20:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FnzZXhjkiCfi4zi5VDkJ88lU47vgAfdT/ltnAn/qvAw7beI5ZDDjZ9lIB6wVVAhiXAC1QKDMVQ1H094dVbAlDO60RYLttg/jEkov3j90ymduwzaseIxZMRHbiXcq80qPkl7ogDxl9oy8XHCMuvw6i0PIvUUHb/wPseRV/FEJvi3uTVQuh1cdCnvrnCzQ6Zuoz94l5Cfih1uRm96xUXnFpocOPedyQqwc4pMEdnP7kTYO3f20HsLFHAitgAfJ/dXe+drfV+QNHHni5HcnSuvFxASoPJUZzGOYhGf58mMXcUQde4n4z4nlrBOMjmvGqFEMFxf2DnmmtteMQM8526UL9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=S9hG/wZuBy10TgTWKVcVgFxS6rpSGYo9tHXjdVuwINM=;
 b=Of2ToSyeva59Hov3A3BHvxxATSQkfq3HCKZoTpcOYiu0o7hPs3GtGWsXutfxNuPBw0TROoC96WWNEA4RfzegGLG9cAsZ0pymYGkgWMXOkhNvsZvOR5TI6B4lnQlEw9OrZReXLIYGFKMCQoJoA9hobhfjJRfBfV+IkxUGRD3w3ICNHgPsDjG4Nhuq0bqVTu8y7MMk7ykzpr5HvpdHr0PegyKIgRFQw2r3e7UQVa5xigGlDwISTdmlS1DvWES7TFTPtCkmSHZHtkn1wMnl3qR2oDPpMmhDzOpmv+UvS5j9z4/gxmQV608I6YGOQua8u9iWKYcCLWVPAx7RWWdrDJADUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S9hG/wZuBy10TgTWKVcVgFxS6rpSGYo9tHXjdVuwINM=;
 b=qrv1/OILCsSGCzuq3E+X0u9RRUuiucEC+/cdJgA3OAx3yyeWJIOswJu8MjmOmatrMuZGpYPmH2/uEe67F0ejJNJxzQ2EJQZNg9QUMLbqSHOXtxuFrkYqXblBZilPFPXMrlc9M1zH3L76clmACn8tbDnz6nd+b1Skej23LM60O1Q=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DBBPR04MB7898.eurprd04.prod.outlook.com (2603:10a6:10:1ed::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.16; Thu, 7 Jul
 2022 22:20:36 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857%4]) with mapi id 15.20.5395.021; Thu, 7 Jul 2022
 22:20:36 +0000
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
Subject: Re: [PATCH 2/2] selftests: forwarding: Install no_forwarding.sh
Thread-Topic: [PATCH 2/2] selftests: forwarding: Install no_forwarding.sh
Thread-Index: AQHYkglGkL/K9N5BxEqRZcDKIJ8gXK1ze30A
Date:   Thu, 7 Jul 2022 22:20:36 +0000
Message-ID: <20220707222036.ptyaqh7xv6vhokqi@skbuf>
References: <20220707135532.1783925-1-martin.blumenstingl@googlemail.com>
 <20220707135532.1783925-3-martin.blumenstingl@googlemail.com>
In-Reply-To: <20220707135532.1783925-3-martin.blumenstingl@googlemail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 561b230d-31e0-4464-e1be-08da6066eabb
x-ms-traffictypediagnostic: DBBPR04MB7898:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xAGhf/QxyHKA+PxX1JgSKz0nuch/G7Tv90QOl0UG4aCFRP4eID1JzZqlwj7oJY6iOBGOG8XnkZpRpBC+qfJr8Dau+g1ajjmCmiKvEDnXucBmTM5EbEMw92UNsyD5TY6DtW/Wjd3Qj9cXfs2BMNBeqaFwJHopQbtMw7oOFlarTVVT8X4qqf2N8v1WYd3e76khtMYE0OHZlNPEzFxGBOT9voYSgzTDk2imMkPJOnh9jP9gCQlttRP3RNpyKwV6UE5iYZDetBuM58pSDtkNCKnCG9q+BhfrzLH6jGiUKPwdfwgJBFqsxH2uRFVp5ddrIUT4uTZDzVTz7HxZtUGOW+yvt4ZDA1fNXRbVSIF5qTXuNpP2It2MDpoLrv5FrKExEWgWU4BEXlW8R8Rq/3wIKaXGlNa/RBmCMggAsfcv3YFfvDD/Vt36145zqD/EjqJe+qUoIc4Pu+Vg7KolcDbf3DwnamrN+WaTbESHYZ3/XnLck1a4PPsV9Z42ttNp9TjJrF1HzjFPrbKQmVX9jD0GKvBysQZu1bSQjtgnz9bzzTVhXBvXVBMHAYo9JnPVUK8uCk431rI/hQtp2RAslJ8n/ijODTRID22hm4shYAzNacD3gHGDuyzLDTjz6oEZS6JW12lUSWbJzpZAMhbsQKg5HwzFEgp1927D36HZV/7mHpJALj3xGJM732yw7HtnXuy57PvhM5Cn+SB8KWwWhCRP53fmZ/kY13Thl2z4K0Y3vC9e6oZ+fxWH+0rSrQuiGb6oH1G6ILS23WAgPFLVMLF5BjkM/K8IVOvdbjjBteP8XFNwybDYQPVTH3GMTv3TDpNZqWId
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(4636009)(346002)(39860400002)(396003)(136003)(376002)(366004)(86362001)(33716001)(38070700005)(8936002)(38100700002)(5660300002)(122000001)(41300700001)(44832011)(478600001)(2906002)(316002)(4744005)(71200400001)(66476007)(66946007)(64756008)(91956017)(66446008)(76116006)(66556008)(6486002)(8676002)(186003)(54906003)(26005)(6506007)(1076003)(4326008)(9686003)(6512007)(6916009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?h/AKEDg8T2ZB+JsJxbdoQtieil/5G9PH0+mwEo87tibQQkCIY0x62nQiIoIK?=
 =?us-ascii?Q?Je4F2eeQIJBzE9nD8hFPS1KwXBrWzOgAjjcE0LUJej+nbH5JGxb4mQcUgevc?=
 =?us-ascii?Q?voLoEFHS4eN2VW87vK63xykNrQvQHc61UIV+wyXsZavmJoTjEu2QOS+XrcSP?=
 =?us-ascii?Q?QLiFrBNPHDcj6I5K+X4TMzfJH2Qt5C3VpKqOypPvRAxMrtomWi2ZT6LJlgZd?=
 =?us-ascii?Q?SSMDUfDM3/5D1mHiR8vxbjK+vZfpeEVOSxKbJdZyzqCOZTJDiMGM7FSNQFyy?=
 =?us-ascii?Q?AlYwo/Xxvnhs46v+Ki9m8LMDKL7QaJ6AU0h+ktuoTMgSkJZxuvCjup4ARud7?=
 =?us-ascii?Q?tryDmVcKZ0brKW3cBRPYyOPOZGthEvduf2WijdYBGidpSnO3B26KQJKe13vt?=
 =?us-ascii?Q?BJLWFMl2AQ8bvC24upuI8ps52ArBff082hLoCmK0U34uRhTd8ILh0Ebf/pzc?=
 =?us-ascii?Q?BYg5AW7aGtVrN6Pk9b1CHzHG3uXB8YJq1R91/u+rgiRnmFwY5eA2N9r6dx+Z?=
 =?us-ascii?Q?eAmCSWrg89OLB0rGLyVmtG7V/Rkw93RUP/BRdzUeOZQGLHdUqLnc9f7F/Qrl?=
 =?us-ascii?Q?YHvhY0WuV1IVOT6KdeDVRD5ejqznrdOXNd+1t26thhVbAL9FV9lE3MhulxuE?=
 =?us-ascii?Q?gnZK0zquhsGVA4m+f4eneFcXP032Y9LWqCQBJWdfsbB9ClZXVsueBxDpDRXS?=
 =?us-ascii?Q?DO0xMm0Me+rsNa4Wtt0wEm1ERFxJCpqTVCvkx7ZKKGWMSLeZCQobOiIz9ZwJ?=
 =?us-ascii?Q?eKknMDO9Goko7JNv4GuG2CuImY9Wd44yxHob4k6rS4zO42SfETn/gI4NWbbg?=
 =?us-ascii?Q?JdfnflmzszdKCEzfXQ9M1VHYvZqxJo/zxbm6CgsXqrPPBKFCPz1nIqpHHJh/?=
 =?us-ascii?Q?lV3qc5RuIfYlcTYm7f+uOAw8Gs9Skp+CjNtj4qVy62XmZXQWxWFKblDsBAu2?=
 =?us-ascii?Q?hNOB7cdKkYgBBwxyhzOM1FGG14U4yE96X8W94j0wzDp24hFMO07ohlQXj2BC?=
 =?us-ascii?Q?k+X0CyB0IjUImYmPL+iJkEBbY13ykwq8SHoUp4PMe95E7fCJXakZ64NTBf0Q?=
 =?us-ascii?Q?VwtseLnudh2RQdPXg8VEuo/EZb0kU7TuY6V+/zn2ighH6oDcNKhYmFh6JFDE?=
 =?us-ascii?Q?dBAQ3K6uh8WO6xH4Us+CSKnNI1DUOhDSoyvN3OOa9lzxV1Pzw3P2gm78ruRy?=
 =?us-ascii?Q?mMn7iGohP8kna48aZtCJgkbsJ8gPrD4TrPmu2RGKMPM90T7xUylaVkKXzla/?=
 =?us-ascii?Q?R8Gim56aics1/21LL4tTljxWM0NSXpztTnI/RX6P9Pd/okK5r90XmYMbxvV9?=
 =?us-ascii?Q?K43OOvDufwlzQXJV0ii4bAvd0wIm5ozLm5/q97veO0IlFwmBAasjx975zVFY?=
 =?us-ascii?Q?GtNNpUkQb51Kqnvz/tCbLEdgmkVB/LXJYmgqIeV/1D50YmUUWlqBeZX9yemQ?=
 =?us-ascii?Q?fN+F1N646rbTJz3sMyl94kr7t0okMFlzOEowzqVWoKlhi2rhF9pKDRAo7c2r?=
 =?us-ascii?Q?4/Cm6PnyVJoT0dh2t+6xovvhvuQO8C2ip8wvbQBb43/ICsnlTPzY7stu6VIR?=
 =?us-ascii?Q?JC6IOJj+tDk2EtOHBhJa0AEQtR3wLUgraKLWz2B/2jL32t5ZXkz5ByInXhN6?=
 =?us-ascii?Q?gg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <80399C52F392944CA4D56C85308B9219@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 561b230d-31e0-4464-e1be-08da6066eabb
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jul 2022 22:20:36.7302
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FWVccW2rVJqSDYilt6sKCBJsf7buFXFLIO8DbLCWEXXuDNfOVxIbAlMuXxu0GSLgf8M3XzmcVja0EHY7wgbSNQ==
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

On Thu, Jul 07, 2022 at 03:55:32PM +0200, Martin Blumenstingl wrote:
> When using the Makefile from tools/testing/selftests/net/forwarding/
> all tests should be installed. Add no_forwarding.sh to the list of
> "to be installed tests" where it has been missing so far.
>=20
> Fixes: 476a4f05d9b83f ("selftests: forwarding: add a no_forwarding.sh tes=
t")
> Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
> ---

Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>=

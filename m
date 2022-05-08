Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2271951EC24
	for <lists+netdev@lfdr.de>; Sun,  8 May 2022 10:09:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230193AbiEHIMp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 May 2022 04:12:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229933AbiEHIMn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 May 2022 04:12:43 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2089.outbound.protection.outlook.com [40.107.93.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58161E038
        for <netdev@vger.kernel.org>; Sun,  8 May 2022 01:08:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QMvEY31GXhPDvu1EhnWYVISCDBAZZOJzKFyzzFHxwRpXq/b5M2B6ussgPZLVtyrh2W1nifHxOfNRm2Z5ZkxGL07c8fQiQFvDeRiehxxFCWZMTjakkwqbZ5foYVfUAk1fZxJLhF/V7C0vb1/+yIsnpj9+rmD4uWaQwQPPpQ3QWiwvahZ/asL0DR0mCHWSC2Ufdrm+UR8+EPPqvUXBUKVzF+FInUsQnoGFCYqytGEWk6g53TXTzck5OQelM3zrEUn3uICEkT2kc8LMjXYOcpTSbTYTB7H4pUqs+0lHNXgDWT0c8nlxytYQxKbWwemY3DxHa23ufTxBH20t53WTOXWEig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xkFZd0fp0PnRgP+wlgHbI1gctK27nkm89nb/qvVsI/o=;
 b=RWguEhqITJTPriX3hLgBmQxj9l4kmPE2A4ZaiG1y+wFLBle/N16UwwCgKGX07f9hitm4XXLF6DSOMjgkQeGTjxGsA0iR1sAqhJoHtRC5RXuoNlQFXM0JDLfSzHusoGns4qLvj+68kb4lZjAlpx2r82w69rMsFuMy0UA47tQ2vb4DUh9A44g5WqO2JpRW9W+Qg2fjMqkjAbGMH2rRVL6BAbkJVEwCFB+b/pGIcIpGzzNO2NQshapBBH+dqJuOir2nllIY1rqlrY9Yd9xayFbtU8KcJiOeQoAAzs8qepPP5zuScUKznZvdrhf9PhNe44tOMwtE36k1k+wMrty8lD0oVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xkFZd0fp0PnRgP+wlgHbI1gctK27nkm89nb/qvVsI/o=;
 b=YJ4l3HDfztUGX76HN6cmbIKWsebMWsp0IQZo2JqN41FEAY499ohc92XFIafCeq/i+9dFxwBXDWnGEoTzp8xk/FrfxuwAcX753jD77rDxCK2i5voUgHRRqt6AxM0HQR3owdxeg6GxvGrg/Dw+2xqC00b516acKWtEGo1qFfuX8+7U2AdmbRIc/AgYNBzbQ9/B/eI4Ryyu7t61MOtUOHzlyf4502dkxr22tNCqKWuSHMJNrEDyxHl0MIkdHgkYDP/Gla0yyTcjdWazwSHolKuBkv+jPXoXfDyYxUqsohg/6/ujIl5b8+CqKZpZTarryFzyK8VypWo/Gmk3Kdx/IIctSg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4337.namprd12.prod.outlook.com (2603:10b6:5:2a9::12)
 by DS7PR12MB6096.namprd12.prod.outlook.com (2603:10b6:8:9b::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5227.22; Sun, 8 May 2022 08:08:51 +0000
Received: from DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::45b7:af36:457d:7331]) by DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::45b7:af36:457d:7331%7]) with mapi id 15.20.5227.023; Sun, 8 May 2022
 08:08:51 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, petrm@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 00/10] mlxsw: A dedicated notifier block for router code
Date:   Sun,  8 May 2022 11:08:13 +0300
Message-Id: <20220508080823.32154-1-idosch@nvidia.com>
X-Mailer: git-send-email 2.35.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MR1P264CA0024.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:501:2f::11) To DM6PR12MB4337.namprd12.prod.outlook.com
 (2603:10b6:5:2a9::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f0f8ec24-3e0a-490e-0df5-08da30c9fcc1
X-MS-TrafficTypeDiagnostic: DS7PR12MB6096:EE_
X-Microsoft-Antispam-PRVS: <DS7PR12MB6096B9810F3D50C4FA17795EB2C79@DS7PR12MB6096.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BlEqGgh4wU+M2/xyo7aKjBhPQVAA0XmIBXxFZKHZKqV59oxbeZqCseRWVazQKefM52ivY4FL+q1L30R3BxKYVKZtsJFpig+2Ydpr707uaRKbdhnL1Tohod5y+nWGmXg5s0Y2bn3b8PXGEYvN5aAe1lVRnXJrZRUuAMMH3kB3HvKgWnVVz3oPqjyHZEYRcHUZmPuWZ2+HgUSsEW4FHuvmTRO0y0y/b+JbldJdIcBQYZW6dQw56yeZRPsdColrQCH3d/9tfSnwAXKXG9k0NoMAtC1eL7F1EOzAsg7xRHvM9GJzPkAm2SmGHEJ8WOhrlQ3xiRyBNe8t4X87KttMyVrZYkDC2J71s2uU4z3gUHFFpzW/2QA12GloPSqANh/12HXy2ixAGZm2+1OGoj+VOdqQstsdUQ4SWKEhOabD7DurGI/BB+iACd0M+Gj0xTRG7xGSJ3B72ScmbUQKjYzZIMhr+mqx8WpnN6QrcZl1y/EWEIoLHiavGzvybvk5w7e3+m/ZbQWDUvwm3ZFfnKhEhHD12QM8ztaqmACr6lEcTlO9/SO4uUK5t6horsLVj547nGnIcmQqCkxaFipJGJLO6DuPvcIyPOCZKZ2yf4cIvqqkvPgMHKiM+sb5yMAPpbFHcKv95zrnrbaAOdYqLex9+mzhFg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4337.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(1076003)(6916009)(2616005)(36756003)(316002)(6666004)(83380400001)(66574015)(186003)(107886003)(8936002)(86362001)(4326008)(26005)(66476007)(66556008)(6512007)(8676002)(66946007)(38100700002)(508600001)(2906002)(6486002)(5660300002)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?bDECRAyB2VSdupiFgxEvZnlgiDEABITSEIPnJb45bcfDsa2NqNOIB/nK87os?=
 =?us-ascii?Q?vWlMwd6zC9WDDR5C+a3IMDAMSwHEd1cHjYcOh87A/qhPfVhoMuCg/JgrJ6LM?=
 =?us-ascii?Q?uvR4dUu+rtsJCWBJmv2P+crXoS4jBcQvyVA4VdPhFGk/aOeaAiWl8g2x9nve?=
 =?us-ascii?Q?W8pSnsMbiKwoZC4DKxSKYGn6Q+0vG4xAcbeM75ZFIe8a9915swHYoiQk2gzH?=
 =?us-ascii?Q?vp2qqG80bcnxWg7Fv16LrVBjj+HNqBMhNfr+lS3z3ULC4x2+Zy6EYE/qjnae?=
 =?us-ascii?Q?UpYh+SYh0IM9ASJrkztnPb+TzjOnEBcUOORqHKKMrinvxp3bbnj235rBHbOn?=
 =?us-ascii?Q?qTnkZkd4eC3kuSryWRDA/ReOzD1Foa2UOEMufYgWEKOlxXEdPX2X6hMs106K?=
 =?us-ascii?Q?5u2N4OKQQPQ9Wus/fWfkesrnMdmAgp/ojMkdkjIFCZWurqeGQJ+yxd7og4fA?=
 =?us-ascii?Q?8Lv0ItorlrSSNIs0n90XpZSjpijeI/ar47MoMpoqlAz0XPceTWKdAqoIfgGI?=
 =?us-ascii?Q?4fMbff2sjTx6zxjW48aG8lj8gkYbISkD5EmLw7sx9JqivKq92TyP3rqkWYGY?=
 =?us-ascii?Q?TpNPQJUPiTX2MF3xGtmuF1aUO5RW7TN1aOlcWFd//NUi2VYFe8h0UvXFE+mN?=
 =?us-ascii?Q?e00QZQrHS61VPlj+JE1gkgwfP/hREwBsk/V6Uzs8RhHjiCel2iKrT10w57YQ?=
 =?us-ascii?Q?6jkm/JzEE9j/R7Ch14Uee9oCd9ACY1BXDlZPan3hZrDHqyMUtZuy4vdBtHTx?=
 =?us-ascii?Q?V9SrbRwjtYrPfjcv+QsScjwXRBR20zjV781Wou0YMzOBTWti2ck4xa/aZSDe?=
 =?us-ascii?Q?QP4q8VfrX54ygPGsLdc9R419UArFppEiDHpfP6y098YaQpFs0rIUOCoavsNz?=
 =?us-ascii?Q?1PcL2rj0n00GVJadcIRxfyaHCEhmbXic8pCRItYEtwN/f2KoM8WDIPszI5sj?=
 =?us-ascii?Q?exWJlmJPkvzVXrf2Q23HuqTvzjrz/DR54dx47gAmR9tna2YsLK33cCBqXii6?=
 =?us-ascii?Q?zk2egtstq3H8MRZrMGQz4hiY1xRyyki/BYvMdRC0uk+mgFUtzx/+3cOgEkGU?=
 =?us-ascii?Q?w76Rk1iigu6jmn9BTdDRB1uj+OwQPbzSvoMRk1VH5ROSGchdTsUZ0OdHXnq4?=
 =?us-ascii?Q?GszE4uPiUJpMuYyGYs7nuQnne5YGttqDMyXndOnMWpjrqLjedjhTGDZgO5hV?=
 =?us-ascii?Q?FSOvREYvSZz5pArdNWXetou+3GXv4C49gdFyOhEGiSehpuXuLYtUeGRSbH5E?=
 =?us-ascii?Q?o8KwwBZK+KVQVPxnsPHdVUtDe0wsLB2FVW0BGcLPMNekzwP9yEURm3UcdazP?=
 =?us-ascii?Q?X3pQHphi4FE+xfZMoJhTTF/RLHh/EaxpuuBzCG4Ge4N7tcpUolzNIjFUhTMv?=
 =?us-ascii?Q?PvIkO6OQlT3/o/yrQHk6VODQhQYEGJIOXplx7STOaLVOFhWQTY7hZBOaffYP?=
 =?us-ascii?Q?M3P0M+HZmuyNzEhSaDzhnicuNur1GeGrtHPmq7jlVWJG2qo0DYimoqNl0uhD?=
 =?us-ascii?Q?nfsdBAVUtGo+l1ZZ/T6rd9B9aTjapst3jeUQ/jGgIHbesAViw27weLlj2/Aw?=
 =?us-ascii?Q?c3SViR0DTiIU9N6mBLuaoHEcf7eWkPlSTlrfG68P0PsQdycmBh/IxqTHFLq8?=
 =?us-ascii?Q?UHmyJjypLrHcwEknJKMFzdFZGQHc6bcLkMUXvZK/QXfI1J857IjY4qgjWLjy?=
 =?us-ascii?Q?pnvN4c1om1XxgqKGbCgWQL7PpD5bJKFCNSsDF7RIwoTY5TDZNoltJDt3xO33?=
 =?us-ascii?Q?/52TblXCiQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f0f8ec24-3e0a-490e-0df5-08da30c9fcc1
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4337.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2022 08:08:51.4510
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VLWD9Y4VORAitR7qcKM6hwyjviqaaSqNWrWXJuc50nKR1gxjTYcgpHCeszXq9FldyBPjdplziG9aIFLrBx5jSg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6096
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Petr says:

Currently all netdevice events are handled in the centralized notifier
handler maintained by spectrum.c. Since a number of events are involving
router code, spectrum.c needs to dispatch them to spectrum_router.c. The
spectrum module therefore needs to know more about the router code than it
should have, and there is are several API points through which the two
modules communicate.

In this patchset, move bulk of the router-related event handling to the
router code. Some of the knowledge has to stay: spectrum.c cannot veto
events that the router supports, and vice versa. But beyond that, the two
can ignore each other's details, which leads to more focused and simpler
code.

As a side effect, this fixes L3 HW stats support on tunnel netdevices.

The patch set progresses as follows:

- In patch #1, change spectrum code to not bounce L3 enslavement, which the
  router code supports.

- In patch #2, add a new do-nothing notifier block to the router code.

- In patches #3-#6, move router-specific event handling to the router
  module. In patch #7, clean up a comment.

- In patch #8, use the advantage that all router event handling is in the
  router code and clean up taking router lock.

- mlxsw supports L3 HW stats on tunnels as of this patchset. Patches #9 and
  #10 therefore add a selftest for L3 HW stats support on tunnels.

Petr Machata (10):
  mlxsw: spectrum: Tolerate enslaving of various devices to VRF
  mlxsw: spectrum_router: Add a dedicated notifier block
  mlxsw: spectrum: Move handling of VRF events to router code
  mlxsw: spectrum: Move handling of HW stats events to router code
  mlxsw: spectrum: Move handling of router events to router code
  mlxsw: spectrum: Move handling of tunnel events to router code
  mlxsw: spectrum: Update a comment
  mlxsw: spectrum_router: Take router lock in router notifier handler
  selftests: lib: Add a generic helper for obtaining HW stats
  selftests: forwarding: Add a tunnel-based test for L3 HW stats

 .../net/ethernet/mellanox/mlxsw/spectrum.c    |  66 ++------
 .../net/ethernet/mellanox/mlxsw/spectrum.h    |  17 --
 .../ethernet/mellanox/mlxsw/spectrum_router.c | 160 +++++++++++++-----
 .../ethernet/mellanox/mlxsw/spectrum_router.h |   1 +
 .../testing/selftests/net/forwarding/Makefile |   1 +
 .../selftests/net/forwarding/hw_stats_l3.sh   |  16 +-
 .../net/forwarding/hw_stats_l3_gre.sh         | 109 ++++++++++++
 tools/testing/selftests/net/forwarding/lib.sh |  11 ++
 8 files changed, 259 insertions(+), 122 deletions(-)
 create mode 100755 tools/testing/selftests/net/forwarding/hw_stats_l3_gre.sh

-- 
2.35.1


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5EB986423B9
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 08:43:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231720AbiLEHnW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 02:43:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231349AbiLEHnU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 02:43:20 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2061.outbound.protection.outlook.com [40.107.243.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF27C13F0B
        for <netdev@vger.kernel.org>; Sun,  4 Dec 2022 23:43:19 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FBk5VoaPThOwr3VxgBlTIkI0Pc6BKiwsryGzpg6DH3bxxRpxYwcnuAEtiNq22xuJOBaAlx1bDkP7TV0PVNds4xqf2HU1kuP/ppbFYLCazwOkzmEYMrkAK9zzNwhr41dIoPRKRGYgQQ8RbpZlZB/rqjA3IQoIF25V49yylbxg8nqOvFxbCGqZTYlFCr/NNI6rxJLCVDPfnk+DLNqK5XkIUZ7jpiAfrbIETphIvHKUrKRbTb2cmtDHl/2p8EMThAJPk6seDFgmCPazMYd1UsRcZ5LB3Chr1wqSW/PAj3sZHlW9k9HbndeIaFBzYwZs7j22x3fEQEG/jlzVdPMAHUwKNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kjS9aGsGx4YbQiLY0sTiMku2ZELoS5l/XzWb4p/TRFs=;
 b=lPW8sbbRPczEYlDBycltkYvIkiugnElFpdNxxezqsMAvZ0cbYSGNq2xzOMuPT2BAbagw9xGvbvFBGwS4NYgAhOb+DdEuTg58YEk7atRKQaSug2xf+YaafPEUPeU2b/6oiVchwiCDWYll16ukbaeaZv2+kQPeWoKQldaqh9zjDw8VY8wx94X3ZDmAcSJsJMoraoA898REdlwjRc/UADZa+TuWxcws5J0FTsZlEmUjrMJhdp80OCViZrk06Jb/D4hOk+egn7OzaC+AIG2cS2abyYu2uBJcEsw+1TYU758jChhkMXObE1m9jF+i3NWvJnqbXmpaSAOy+mEUHthLyqez5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kjS9aGsGx4YbQiLY0sTiMku2ZELoS5l/XzWb4p/TRFs=;
 b=udHwcQ0+5THTQ3FelC894ZwemG9xObXl8o6uXIoti8i/Op8MzjcuXrDMO74m6UJG+vk9Mcy92hD+7yp4UOEYG6jw5DvQFyAoURjwMojMGdtc7HcM8WCyQtt8tLsC31CknYNRBT8qXLDKvq6nQ5BY0KXq1RAsruKN8JLhW8bcpoj0CzSon7LGOneP0IbNkkhYZMOrmJrt688JGFDP/N+B/S9m8/KxfJvfxwRDGdomssmI60XR1b+CBr2EO4nZ1OG5jDi63x/GD5H2rmiC+VSKVkQfHDoX4vgxbzP8wH0pSwyo4sIO8Gv9kkD3TgIXmKhMmB+jSJa0xSJCbgMG/mnrdQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from IA1PR12MB6163.namprd12.prod.outlook.com (2603:10b6:208:3e9::22)
 by SJ1PR12MB6265.namprd12.prod.outlook.com (2603:10b6:a03:458::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.11; Mon, 5 Dec
 2022 07:43:18 +0000
Received: from IA1PR12MB6163.namprd12.prod.outlook.com
 ([fe80::193d:487e:890f:a91d]) by IA1PR12MB6163.namprd12.prod.outlook.com
 ([fe80::193d:487e:890f:a91d%4]) with mapi id 15.20.5880.013; Mon, 5 Dec 2022
 07:43:17 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org, bridge@lists.linux-foundation.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, roopa@nvidia.com, razor@blackwall.org,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 0/8] bridge: mcast: Preparations for EVPN extensions
Date:   Mon,  5 Dec 2022 09:42:43 +0200
Message-Id: <20221205074251.4049275-1-idosch@nvidia.com>
X-Mailer: git-send-email 2.37.3
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P265CA0254.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:37c::18) To IA1PR12MB6163.namprd12.prod.outlook.com
 (2603:10b6:208:3e9::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA1PR12MB6163:EE_|SJ1PR12MB6265:EE_
X-MS-Office365-Filtering-Correlation-Id: b8bd73f6-ca4e-4fba-ac26-08dad6945f11
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OPkVaB3a3a5UVoGl+7D5NmcAGgZUFVTa9sbscYV0mx6QFPVwFUsikokNKQJ7y+87FyEgibFo2ngHCzC0/BpVgDykIsGnr1BdAjGsg2pIqRBZ3C0BYQsfzwZsKqswGS5BtLB+6E1FZBbKjloiXa3hRgJUYZORhuLDiSJGjNyORzu/yo5v+7GA0y3yWSk1tMxMEgvVTgKSIHXes1Ha0gwzXQMbs/zITdKNLlPtbqn+D3DPLm20A5gBT+W8B7GA32oGxl6o2crCIQ637+t1XQ6uqKiiB74AHFYaaGdBpNAhH0o7iKdvwO5keqPTiDr+q60O3Nd7Ti0G5lRqK5722mwto7ABpnlgh1oDEfX+MKD6fpCUuyTXbvyAMJZWhO585B0nhZ6ViGHYrBH1f0gKE4TJfChhUupAN1Idk91s/UuqJgfuSKoa2pLDTh7n6BSLpx1B3aFKg7nxy6RypaClxlt++8zOZ7eHRwG7GMF6fCv7XYlf9ht/amCgb43l0f9GDncnBzOhvXB2QsxNO1/cCGS/jyPoSQ1pirP07KVRcnPRd4w0T+R4hiZj/oxkZdB6y57ZoexBS1M1wwCH0cJuZZ6AW5ffwDPXdsRG2wTyBvlF07dpzClSRNA1Gdyc/b69jfpc0C/hxmGHCsIPZ4E/edq37EoPFxFhjTuu/BmW6hykaabAGXdmP/MI0/i/A7E9MpgJx3Ea1IhlNaXSdIPQjYBM98O305ojHjBk1O0OhhWjiO84ILZTJ0rnkpv4FigtKZDb
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR12MB6163.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(376002)(396003)(39860400002)(136003)(346002)(451199015)(2616005)(1076003)(86362001)(2906002)(6506007)(5660300002)(186003)(6666004)(107886003)(316002)(6486002)(966005)(38100700002)(36756003)(8936002)(26005)(478600001)(6512007)(41300700001)(83380400001)(8676002)(4326008)(66556008)(66476007)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4ClebEnyPkt27XP7Kim4VxI+5RyN4AuX418Y2KZ9MceUKAtXfQiIqnS4XncX?=
 =?us-ascii?Q?fPGnS8tLhFwQSFP0QGysiM0grq1o1OuGPncqYBUi3S2RRtumqk6t1JvcR5LD?=
 =?us-ascii?Q?SBsshoN39qE6YzFmSpG8zCmrP2tElWhgG0s9CIeAssZxZMeeyFntCXwfPD0k?=
 =?us-ascii?Q?+j2fYy2mp7DWlu5qt1+8+lEh4NvSY+vklO4tsC9eNEa2CGjMHiat+bSUVYu8?=
 =?us-ascii?Q?ViDik1nxXd55D+v0wMzGI5SGnMKoFkzCqy5TpnothUSHUaiLwvFz9olB6eKE?=
 =?us-ascii?Q?NR/+byzD0G+T+08O7Zo0rfiuzxIc/UTh7/eloMweA4gBxxoqfij6EleR0gfl?=
 =?us-ascii?Q?6dNUgLB9csiehODGHNmm6+SrnpRn28iAE+g2omxeJoOUueG3JZl1OTU5w+Y9?=
 =?us-ascii?Q?UaDWkLbXS3/vh6hjTnrpA7FGbOF1EOdoV4U8emYIdlgJAE3nXCoeTP2q3pvs?=
 =?us-ascii?Q?4creVGvjGaMdiUQ8LetP8OJzTzdpgy3pXoDf2VgWwl+mz3F0CwkRWYCbOcZ3?=
 =?us-ascii?Q?CbNOs730IFQuYQ7jaN4VMbfmarX1mTo0k7VsoXgBGIftok7ebZxHxYRw8J/h?=
 =?us-ascii?Q?gVz+gAQbrposQFavVIZGud6T0eioTTwh2Thy4AGZ2EMX+rmZmHqIygbOncXJ?=
 =?us-ascii?Q?X4Hr3YFnJcTIwesc3/AnnjND4lsE/mabMgor/noGQrQPatb9ceDTvHr+lf34?=
 =?us-ascii?Q?IuAxjb4BoO2SQBXo+vH5+Cc8R45cXF90z7TErMkdSwjksXh7ks2DSnFWI3Cw?=
 =?us-ascii?Q?b2EvDdLST1fRxP9v58imW/9kg0Zd0zB9/qpZ9sygD2enZK0yP5HjlpknwwSp?=
 =?us-ascii?Q?vYvr3uOwe2jqDb9b3OmCDKI3GRKXu6z2ahhxnF3UY3LVL1TdRaxd/T+8Un7t?=
 =?us-ascii?Q?U9f0dDv8Pv5k0HHYs8gbKJvLC8qvwbMqfkqCRH3yYQGVDBFO7eecNHdEFORi?=
 =?us-ascii?Q?4VxwnkldUtB6RJATte+onVPd8PcPZHp1lC86EjjObDJJK2jzcAb2rnACM/Uy?=
 =?us-ascii?Q?omQRVQ67L3SZ/sSa1axj93sDXRcwW3zzBCGxJOblIF6sflvX+dkdnveubixg?=
 =?us-ascii?Q?f2XpVg2+ClNjXLQHP74gl7a/cXV4K46hww8zkLsZnWA4ZdM6B9+Q5DBUsFr1?=
 =?us-ascii?Q?rZZ8H2bgcwWp1ymHBH1v6TREhfErcHWbAfICU/W7/pOwWvtq0aKInvrvwlx9?=
 =?us-ascii?Q?Sde0HyIVZdCLN81hpBIG4X2dZk//cf4iJuS+/OEv6ZTmlqCWRVxv5Ty4GK1q?=
 =?us-ascii?Q?HwgNTHP9yR9MG+iRPMDGV2H1QpR85z37LnXMu5L21MrNbxAB2Ui8gJ4TjRg8?=
 =?us-ascii?Q?fVPHuCJ9pwNGoSjWVjnJWxY+bRmchAJq7/IuBLu9c7YyADGw5ze3j0d7LtXa?=
 =?us-ascii?Q?6sV0UC2whcZqzW11NCX8XdHbPV+vzqR1HxPhsVUDu7ZnzkZR6jeFEuNnhoZ+?=
 =?us-ascii?Q?+ZKTPbJjJtkDRJlJwUsGVQrNRNK6yk8rs5iYmAIGOxGuI0vzbjeqndwaMiyP?=
 =?us-ascii?Q?JSOLrBF+lF7bWapfpvdTcA0KGDqF01+gWj0jM31Ks/xOzPYZ8JLEG3Qzu/Yj?=
 =?us-ascii?Q?IS0WK90piHGc5xTC885CDo5EgtYJ2d4u5p9oTcFi?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b8bd73f6-ca4e-4fba-ac26-08dad6945f11
X-MS-Exchange-CrossTenant-AuthSource: IA1PR12MB6163.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2022 07:43:17.6872
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /HUTZCVCZKii7IYuukzetvjxSpm1TKKl70PkdbicBL5BP41h7RiMOFeKNw4NvHSLcXP1rENKISwMw2AjYMLAZw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6265
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset was split from [1] and includes non-functional changes
aimed at making it easier to add additional netlink attributes later on.
Future extensions are available here [2].

The idea behind these patches is to create an MDB configuration
structure into which netlink messages are parsed into. The structure is
then passed in the entry creation / deletion call chain instead of
passing the netlink attributes themselves. The same pattern is used by
other rtnetlink objects such as routes and nexthops.

I initially tried to extend the current code, but it proved to be too
difficult, which is why I decided to refactor it to the extensible and
familiar pattern used by other rtnetlink objects.

Tested using existing selftests and using a new selftest that will be
submitted together with the planned extensions.

No changes since initial RFC.

[1] https://lore.kernel.org/netdev/20221018120420.561846-1-idosch@nvidia.com/
[2] https://github.com/idosch/linux/commits/submit/mdb_v1

Ido Schimmel (8):
  bridge: mcast: Centralize netlink attribute parsing
  bridge: mcast: Remove redundant checks
  bridge: mcast: Use MDB configuration structure where possible
  bridge: mcast: Propagate MDB configuration structure further
  bridge: mcast: Use MDB group key from configuration structure
  bridge: mcast: Remove br_mdb_parse()
  bridge: mcast: Move checks out of critical section
  bridge: mcast: Remove redundant function arguments

 net/bridge/br_mdb.c     | 312 +++++++++++++++++++---------------------
 net/bridge/br_private.h |   7 +
 2 files changed, 156 insertions(+), 163 deletions(-)

-- 
2.37.3


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 952574FF9D7
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 17:18:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234340AbiDMPUe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 11:20:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231537AbiDMPUd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 11:20:33 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2055.outbound.protection.outlook.com [40.107.243.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 238DA252AE
        for <netdev@vger.kernel.org>; Wed, 13 Apr 2022 08:18:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fY5beNGbgzzFgAN9dGf5T40NP0mb84pqL/DaTwMvoysjC3CkjiXCwUCg7R5Tz1sbwajgnEvNxETc1sEplNNa13Bf++CYSTaltR6bGsPUY/ZhQ2KAtma3OejF07Kqwbp4aVtaYCbJlBYPBxHZkvXSFKqnE/y+C+VJt4B0pHZY4rgftiy/iccrLzS+lsfcL+jlSzH8v46COxVBurHFb0FH/+jEO6Jqqf7Ci3RgU1mK/mQIwawD28oy+dLcnEi+2MZuGnWg+NeFhFr8V+1DGQYNy5ME9VhjIWkJYwWB7hCw+TX4N+lWFHkT2RcpDN062D4h02tW5AERVkY5+IWSjPVuew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aec4CA79dCvhFIG5LsPmX0TK0ewyXysjg3RmeIq9SNs=;
 b=f7wEjSkIgGN7JK3WtLCXivlyIz+Jz6j2F+ERMc520YYcdWZIUY4ERi3Sy0Va+8G1WUhEKsg7zeHOoweohzFcbZ54dxBDuqW5osUc/8Ne7IQhPcnMndS4Y9ZTSPEs5i1OM/ajpXuEuK1VdpC/qUvlH1YHvriVsQVOnqgyzHdVIstjyuuyqdDrmNvTPxfjh+2ARNtERfpcgM7OrMVmvSAuMy9cviFxBftfzUB2tXloTcgiBORCKyPDBLZRw2Wk5rrRDhHKctnNjLo2LhRnfVtcI7Iww0wjHUzxphis4X4oqaT6h9pZOIQnU8TxyZ/lWBs0vo3ZuhMoWv4lF7w5gX8Zcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aec4CA79dCvhFIG5LsPmX0TK0ewyXysjg3RmeIq9SNs=;
 b=TsSfflF2jrAXXgdUxdGvT0E/jheHVskoeRGhJsMxA1m9GFlWkJlRbPl11f+xSO2Ly3GLWJyL9ymRThdAD6nrAkx27T0o9oQgEU5Brhdr8HTmJZbFcN8pa3+2Lg0ER9gafsTvsiSlcIex9If6NjXn9bLMVzhqthv+7P8Pz+Not9BDSdvVCnWEDjuT6HJepF2TJvt47kHiboTAIMcJ7oja+jwzHJSQVyOY1sRKFYl+/KzZL4Io7So+r0w6A+a+03H1jnX7pVZ8jBDz+ni0Xs2swo18caX/En35IejLH0J445UFiZdN9P1MQkipfpXbr4FKIGCFH/dxRsexVRZUnHbRaQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4337.namprd12.prod.outlook.com (2603:10b6:5:2a9::12)
 by BL1PR12MB5238.namprd12.prod.outlook.com (2603:10b6:208:31e::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.29; Wed, 13 Apr
 2022 15:18:09 +0000
Received: from DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::6131:18cc:19ae:2402]) by DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::6131:18cc:19ae:2402%5]) with mapi id 15.20.5144.029; Wed, 13 Apr 2022
 15:18:09 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        petrm@nvidia.com, vadimp@nvidia.com, jiri@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 0/9] mlxsw: Preparations for line cards support
Date:   Wed, 13 Apr 2022 18:17:24 +0300
Message-Id: <20220413151733.2738867-1-idosch@nvidia.com>
X-Mailer: git-send-email 2.33.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR04CA0086.eurprd04.prod.outlook.com
 (2603:10a6:803:64::21) To DM6PR12MB4337.namprd12.prod.outlook.com
 (2603:10b6:5:2a9::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c3e7c462-83a6-4b8b-bec8-08da1d60d16d
X-MS-TrafficTypeDiagnostic: BL1PR12MB5238:EE_
X-Microsoft-Antispam-PRVS: <BL1PR12MB52380F066D7B64A1F119B38FB2EC9@BL1PR12MB5238.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: czAZ4mEZkN+u4GGpqaamzZPtUvBIyF8hAe3Pt5NsgkHNy030eLhdkmQeROmyDmRPifvRTWfgKjrRF7MqGR7a2ycUoE/6t+tkTWWpFQMZINXRCWxUop3w3mLq2vUDjQsUEkMi4X4dEwYgq7NM0U3ujwdJLvuiZhaQw6MofCMYbzk8i2ZSK4OT2/Xkw5+q66josn+ZIlOpIUXAEdSov7P6gD3L0NHB9QooP/L4K8xjH5Ax0tKOdyLnmza6/z0171AmICsUUXHLkeBfrdj0jh+m6kbsF7rtz2J3t5BsBGuV5vYZquNqDXNtTQf9OSAbImHpmGot+m4McgAQD6V/7jU32/XY60wyZ4pX74kUKv2gkm4fWRN01My786iesqZN1diP5tguUtyMgl6GdPuXIku+bAIlWhaucS3+einQU6PPpZCBLB4PAfRAE/Qzp70E2l7aL/4IGOACbGFu2Onbyix2Ssa+bVGdEis54CmxVD+O5B/lHabYgkygeRqhKUbGQ8CCO7c4geWf49G/PG4J2tkLg+O3fhk3W19o99NzvltwoVULzWrNhK724GRBS0QEPmNYxOAEiZ8JX0N49tu5f0QLp9HZpU9dlckJkABICrrXNnac3HAO8R1ptNGzvd4JpDWb5OtAetKmwMf3YZSMlu5eCQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4337.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(508600001)(4326008)(1076003)(316002)(107886003)(38100700002)(6512007)(36756003)(5660300002)(83380400001)(186003)(26005)(2906002)(6666004)(8676002)(86362001)(6506007)(2616005)(6486002)(66476007)(6916009)(66556008)(8936002)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?mHypnQR4I2dMQS8/lrrsgyy4r9ZVsfiGBFKuDHVujrXjZTZkzQ1JbP5LFtp6?=
 =?us-ascii?Q?5h1JVJ8TJbHge4bw7qozkds967f1uHxTeRSBn0zBVnLErbJYH6KuxMxaBVoA?=
 =?us-ascii?Q?8Bhn3jO4UShZ8yss/yFsfVKFtW2CKT8LFhso/689447DQgkX6Ls9ZYtRUATI?=
 =?us-ascii?Q?D+otH6dfR9ZUp80D3rdJ7omNuPwDzAwCUVz/SZM0yJfIWESRnYneI79jT2yB?=
 =?us-ascii?Q?Irk4bfgmlV7LKq4vAKIAVPiexva6Od/JItWtnbJuvfXaJdDCtLd8I6fdrQ7x?=
 =?us-ascii?Q?zZXLmPvWY3xRK7VSC6pnZCOTg3Vp8T8BLAj8VTO1Gorb1mdGfbeQgSgT2rEL?=
 =?us-ascii?Q?LSuXrbRR+W3E9Oj6k6au8FYQN5kRJOspNCOxgCpRpMVOL+Sm487j/mBas+Fi?=
 =?us-ascii?Q?KN2yn8G7Q30HmSNnyDpW3FNEv96JA86HZ/XyhJ8EKg1OCJT1DD8nkOgAGwUo?=
 =?us-ascii?Q?w79YrdFv7TY6Lqwn9ZfRINSH6CHn7EqRMNJ+pBL52HFDAcFgAaBqAdqmzLkZ?=
 =?us-ascii?Q?FtuJcU5HW4a/hrvm1FHYSmvUM2V1tS+y7K6CqyobCrfLUDqpAwkUmIvvAtib?=
 =?us-ascii?Q?pboyKvsA8TSZtIdkSr3UZw8EnAnySF3QUVKXHEGjMu/jAaYqmpDoESmAtuk3?=
 =?us-ascii?Q?1rpnNAyZRqppppW5qi7si0rdMSokGnxFUHjQgbPti7oZKur/UZV1KG+BCtN3?=
 =?us-ascii?Q?Yij3rwT/S2iI8+xPafPn4ccxMiwTCJjW2dfl07G5W09SUZT90lUXbhHKStA+?=
 =?us-ascii?Q?OLV5Ig4btEj2erynF1dZmJ0o4Z2ozVTSFd9v+a3/nJrccNsCpXsqZepKmInm?=
 =?us-ascii?Q?rabPQJUmnswwcCCUXzOynBeajGFspnEQ5JuIg7cCiJJbHJTyM8gj5Vvx7Y3i?=
 =?us-ascii?Q?29EpEwOKO2PM4vl0aVaaMAULRTTUF3bsDu+5B6ZWRAYLhctocxplhyGp9W6u?=
 =?us-ascii?Q?C6fGfxtG0i5iO/Eg63NGqMi7R3r93pvFm2eNWMqB00VgcaWCw8i/0P4R5uID?=
 =?us-ascii?Q?H5Lp7JjGa6Iv7cnviiKNfy+7kB7RjsbDbzlYrF1sFLBUan3PIySDIegT8jNe?=
 =?us-ascii?Q?aXZamzkhO+msdJV4WiJGCiUJpV91iMc9antVTwrCrwFdO7CNMmbwZFK4AbA9?=
 =?us-ascii?Q?74/MnF4Z3qmyvOkvM72+XKRaGxhKlBU/oIOIAT+C0DO21Iz4eafzdC5v+zTP?=
 =?us-ascii?Q?BMpAvFQB/Ah6bP+MVvF8OdCQV++5XPwW0kakhuPVqEQwRLUkFbBfC93Pz/JT?=
 =?us-ascii?Q?m/9qFocAOCcP6fuF7rXsHcMR5hWkPDEPbrJP9/hdxeyGysoCeNnBqUfCTeUN?=
 =?us-ascii?Q?RjZjRjRC3X+sP7KrmxntYCmyIM9BeSBd5MmLPAJ0zmSAS3CAjC1SnGfiALpB?=
 =?us-ascii?Q?KdxHnXWmr1GFugrJOBT3cvWgUMOMEhtJaFFnlSG4CDThzNm0Wye0cZKxIv4D?=
 =?us-ascii?Q?9N8gGcAUpasj+rAocm5RC56CsXNkI9iJ6FqWLDj2WTiOEXgiAg0jCtQ74mG7?=
 =?us-ascii?Q?AxrkUUdA7KH0dVg3NN1F/VAxHjRYGarWCpVXuYei6E1rEDNwwBX2rPkayObw?=
 =?us-ascii?Q?9rSBGNX725O4sZkRkNN9Ku0kGLFP7amvb9V+bqae0V6X9vl8XPPvpFonATpI?=
 =?us-ascii?Q?AL72IUGjReR3lVFRbOQSGJF7CaWR94rvYdNP7Pe7SE7nXWBeHADAUGpg28ti?=
 =?us-ascii?Q?hVKi9ZNbsvQmT39ga1eLL/t4oX6yMWF005xZgW2woV8FDs2QmneJ/v1bLrV3?=
 =?us-ascii?Q?EXReiB8q6Q=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c3e7c462-83a6-4b8b-bec8-08da1d60d16d
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4337.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2022 15:18:09.4980
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TV/bry/eYw0EONSaccOs3tTArwhQyOMts2yePKmXuvFftpIf1hSu6chFXrgohOLpT5GI3IpWU2cJ8DtiUiPtWQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5238
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, mlxsw registers thermal zones as well as hwmon entries for
objects such as transceiver modules and gearboxes. In upcoming modular
systems, these objects are no longer found on the main board (i.e., slot
0), but on plug-able line cards. This patchset prepares mlxsw for such
systems in terms of hwmon, thermal and cable access support.

Patches #1-#3 gradually prepare mlxsw for transceiver modules access
support for line cards by splitting some of the internal structures and
some APIs.

Patches #4-#5 gradually prepare mlxsw for hwmon support for line cards
by splitting some of the internal structures and augmenting them with a
slot index.

Patches #6-#7 do the same for thermal zones.

Patch #8 selects cooling device for binding to a thermal zone by exact
name match to prevent binding to non-relevant devices.

Patch #9 replaces internal define for thermal zone name length with a
common define.

Vadim Pasternak (9):
  mlxsw: core: Extend interfaces for cable info access with slot
    argument
  mlxsw: core: Extend port module data structures for line cards
  mlxsw: core: Move port module events enablement to a separate function
  mlxsw: core_hwmon: Extend internal structures to support multi hwmon
    objects
  mlxsw: core_hwmon: Introduce slot parameter in hwmon interfaces
  mlxsw: core_thermal: Extend internal structures to support multi
    thermal areas
  mlxsw: core_thermal: Add line card id prefix to line card thermal zone
    name
  mlxsw: core_thermal: Use exact name of cooling devices for binding
  mlxsw: core_thermal: Use common define for thermal zone name length

 .../net/ethernet/mellanox/mlxsw/core_env.c    | 473 ++++++++++++------
 .../net/ethernet/mellanox/mlxsw/core_env.h    |  43 +-
 .../net/ethernet/mellanox/mlxsw/core_hwmon.c  | 217 ++++----
 .../ethernet/mellanox/mlxsw/core_thermal.c    | 172 ++++---
 drivers/net/ethernet/mellanox/mlxsw/minimal.c |  24 +-
 .../net/ethernet/mellanox/mlxsw/spectrum.c    |  21 +-
 .../mellanox/mlxsw/spectrum_ethtool.c         |  18 +-
 7 files changed, 611 insertions(+), 357 deletions(-)

-- 
2.33.1


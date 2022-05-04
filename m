Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 860BA51975A
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 08:29:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244700AbiEDGdZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 02:33:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235785AbiEDGdX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 02:33:23 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam08on2088.outbound.protection.outlook.com [40.107.101.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 659DE1FCDB
        for <netdev@vger.kernel.org>; Tue,  3 May 2022 23:29:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SE+keV2xFAuuEq1ALDzfP1wNTs9Hsc0Z7/UKgHkqpP3ALlwSsNx3AIgveRAb6JIxSdubHWycJQJi1rnqZN3gzNKB9kw3w0bGc1OEHDZfVYzXZkyGbb4nnalj4fsBRtTufQJDezU4h/aSh9Ru58BXAvoaHwC4qU4hnai11Prm8UmJVQzXU+ndwGwq8eCGAMuTUiWH1h5G3URapBlSBSaSfAwBclxOdFcyCelxgI7pH13S0qYw9m2f5daF1E/Ar/FSy2D8FqnNXhBI4gH6nPR8c+c7/klcgfg4bzOEr8iHEGXCrcz99Rq9/AA1uAuEvyMS3nb1tb7iUoUqdjyk41Z97g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ALAOjyowVEGYATje1pJphUQbB5Dzu3iSzKmUU8cL/Lo=;
 b=P39+MbPbZT9OkCYCEwP1SsbfM5ibqFiEJnSGZbj2++81qgVCLjiD+WU0qmo74JC8eXOi2PUhwHYpLW8vTnP5XZnhYnRXZYUjN/MAfwlJU9hSdt19YoSa6T7fTvYNOFV778pRe+eb2QXCJ4qpb5Yusv4pIlnX1QBecC5Z1GXMRX8TngrXo9olgqaKi/EgDVT36RnkvKDd7wmDSKbjINxDcGEdvzYfkEm6HMb3qRxCV+cO6wJmhVoOH9E2MZYt/g4iTroFV+M89ygFIs6EcXijsRx+8XD1/d6E2zdLizIWRXhClUQFdtkW2lGekydbpJp1nw+CtsJR3Y9MQu6ef36+iQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ALAOjyowVEGYATje1pJphUQbB5Dzu3iSzKmUU8cL/Lo=;
 b=r26FLjd3/ArgvYVIrbSlJJXnvcoclCTljs6dtOMlsLDFrOP9WHmarvHEFBmRd1bh4MVz6lbnOiIxNDX0qbDc2pSzAn9UiF83qqNWF9IU85eiSeKL+/0gGpFNnMK6wo5Gxty6c3Rc3pFNy+yUJqjvF5AzzcYhPnIcu2xLIvBNooTZT0Wc7koLksgqBzcL0eiKpzQ59he55IQZbMcV+DX6uFwxkGJasmR1C0JftCmBct9ECbqqrDFNJAXkThFRhL8fLtAADx71GEHm5qsRojSlsGj5PGcDD3DNHEyJEJZxVneAGrtrBZtEGk93Pt11ExkwvSCMFtrebZ9jZgwYwwiiAQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4337.namprd12.prod.outlook.com (2603:10b6:5:2a9::12)
 by DM6PR12MB4745.namprd12.prod.outlook.com (2603:10b6:5:7b::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.15; Wed, 4 May
 2022 06:29:45 +0000
Received: from DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::45b7:af36:457d:7331]) by DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::45b7:af36:457d:7331%7]) with mapi id 15.20.5206.025; Wed, 4 May 2022
 06:29:45 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, petrm@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 0/8] mlxsw: Various updates
Date:   Wed,  4 May 2022 09:29:01 +0300
Message-Id: <20220504062909.536194-1-idosch@nvidia.com>
X-Mailer: git-send-email 2.35.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0502CA0028.eurprd05.prod.outlook.com
 (2603:10a6:803:1::41) To DM6PR12MB4337.namprd12.prod.outlook.com
 (2603:10b6:5:2a9::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a6c5cf6d-b929-4d8e-76fb-08da2d977b26
X-MS-TrafficTypeDiagnostic: DM6PR12MB4745:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB4745D3C4C7958BCD18B77468B2C39@DM6PR12MB4745.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mhB4pJWZ4Z4z8HDciyAT2f6nout6pGXe3UOIc55cWr85SNIJ8eJgkdWtUxZgptNGck5ewHmQ7GbtmpkShFh7LT69LR/qTATiIw7W8SyuEU0HN3kJbSX+555A0g7/o2G/D7I4CEprX7X6+MPO/rZhlYrWTyLLPwmCtjRNrHDokdJ4VF2zk1L7DEd1S1HJM11vQfhh4MDmBV6LvW5jLEMoEJ9s2PJo2kWXTOdnfqRyJZV4tIJ3R6D72kJ6z8iQVlM/KAL29qHeffMD5Hx5T1/68fuOR9/jS3asIoS3BhN1MyvUOY8xT5EY7cXoA63uYxUSRhJhEjLF2tAwK8EuWC07ABxPClM2ch8+BoEMlvqBEtQ0IDN305qQiFXSCeCQoYRAS73baKO39tCbzVuKIk6c7wC+8u8i076gqDv+aISHtagrAMdGOSCGCh1btfPehxxdXlTmCaCaT1o7CbCK16gPks7iXfNZMj0tOFYUx5NtrWU2lXkuaMKJj9x5rM2hPp1UpWxfHCjEPUZNJhRC/xhCsSO1DxlXKfY67BZDBin9OSfE8cfUDhInfH/zY2Rzh1azw5OECZPGCASJyRekRwBdyYAInTHfCL34pWFo99d/U1RYEhaUETGCJ1mq6HTa+9s1tNi3sq8K5FcNgkozaYsU0A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4337.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(66946007)(6486002)(316002)(66556008)(8676002)(66476007)(4326008)(5660300002)(6506007)(6916009)(508600001)(86362001)(36756003)(38100700002)(1076003)(186003)(6666004)(26005)(6512007)(8936002)(107886003)(2616005)(66574015)(2906002)(15650500001)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?qXy9xR8Is/xasEzOOtr+3/cZbqFqnj5XcwUzP/Sg5HPwVspQjrt80Wq8A+Mt?=
 =?us-ascii?Q?WJ3xis20P7BvpXoaIlsumkjW8B9NS1AEcykD3nQg8SPElDhTgy7te0NRWWlm?=
 =?us-ascii?Q?vd+rZGa/mOe/xCLAn/92ZWSXnTAXH+58Pk9OUzc8GPW82W86i5nq6/pEgjva?=
 =?us-ascii?Q?/4x/pB7B7L20XTFzUsXp8Gu+gSNntivEY2MD+YSCPqwv6dchUm3om+woLYCq?=
 =?us-ascii?Q?3YRSaIomgTMlq4DxAavdCNcg+S+fAO9piQklfVr8RrmSgKdLLgAVeGA1U11f?=
 =?us-ascii?Q?mquWLEVWhj3P3/nLCjhGMxTdpWa0ietqaVJdoKpC6H6BPjITFRvuEwQpYotZ?=
 =?us-ascii?Q?dgVKkkzAB+SSnKyi5NidE+vUgoxjdrLlIKtdxHYGIm8do9GrGCyIGHmoEHpB?=
 =?us-ascii?Q?egH4NZtIvGY+WamINann/nRyDJSJWxRtMvfvpJQJfESNhZag9QO+GkbBhBEN?=
 =?us-ascii?Q?/IX5e5MdDw/548AsqRdUvUsrcuRBI38Cb4hf0JWTHJL5jkgSDHVpoKMBCXK1?=
 =?us-ascii?Q?bDkRKD5JQTsP88HLm13VrfXrtK5cuMR3n30onv9K3k9zmAJj7mxFfVmXc5NP?=
 =?us-ascii?Q?BmDArs8b1HrX0uAAFlhQnpWekEXVtWW0IjCmg/bmB3q6eqg2R2zgJVN86jjr?=
 =?us-ascii?Q?98kz1PcALR58hcxc0LGwOc56qlq3Ta9OXGNmIlboNL4Zi8DrWoH4gmQpq/bt?=
 =?us-ascii?Q?ENRcljUf4MrWIWkIo18emt6lpGgaEJhNktC+1ga3SLGfKmYH9E+6MWjJ9eRO?=
 =?us-ascii?Q?aTRjilqU4ychDdrl7SzK2pjSgecVyKl+qQ9RXGTKWV/Q9mfTSgfIJ3szYWzh?=
 =?us-ascii?Q?oIXnY2aBv2kmt2DQRUS8JntkwiHTo0ZEyRXO/u9fph82igBchYXDx0tciG+G?=
 =?us-ascii?Q?TsNQZL/bBiGwD/MSKkcm+ECkD4wKGXnfZnAIXuFO5lNTrS/o8KT6D+xn8rxj?=
 =?us-ascii?Q?vlscM4qNGy81gkY6u7gyQILh7IN/nM1Oe5dW7AGTm8431nbO7oPDCc8QyoQp?=
 =?us-ascii?Q?gkCH8xmzuehtNUJWM1AfBcf8FFCtRQDwFWxhE5RIeGCI5fgH7lDCuwOFwdlt?=
 =?us-ascii?Q?rbGwvS3lC2Ps3sp6RLU8rz8KAdqD0w9fNTFklf6ZIMpx+w/XLf8n50Y2QCOR?=
 =?us-ascii?Q?VqymM01psPpufnk5O10VglDrveCXepbMIhQqQOUQ9Vlc99tdmJUk5ZSNjAI/?=
 =?us-ascii?Q?uVHoGurDsEyO7+wf0otLhWmUjOUGUXX+fP6KUWgl2fh0BeNuODEas0gzvXIE?=
 =?us-ascii?Q?Ic4KAP9p+apFA/Hxoa/UKOpdLjptan/z8i851Vd5nMdGZMsj7tthpeSAr0Vy?=
 =?us-ascii?Q?lCWEMcD0cDckB8184wZnIgLz/6Ujf5d/oJv01+YiHF9goFN69vnAtpKuaaA8?=
 =?us-ascii?Q?25qen0NNqAxrSD9Y6RCuAGXq4wwgAZ3KQmrYi/FIa+l/Y/wiWk3D5c2t+Evr?=
 =?us-ascii?Q?DgHfTeobUaLMpWAGaBWAx0AFFcnCplQ1bBghpp9OF9TnPt1AIdpBbW0RrqpR?=
 =?us-ascii?Q?TNKbUDcjV3SYyT4iu1EJjcrXGWZTNgwtpdpLyUvVsfdTm7IT219ggqw15Efo?=
 =?us-ascii?Q?mE+J09mlWaGkFcU6FDyN5GYNjbPIe+2wc5Myds6vaqVeksrDqUGoCohcNv8E?=
 =?us-ascii?Q?dkyphOeHfDLtT7JPHlUA6pEacNYQSvs1GaF+KMHTqtY68NMp8krUUM1HDx8L?=
 =?us-ascii?Q?y8GnZ5UbKuUv8Drg8hEtQa5eDUI/NclRC9Rcdh8z+Xa1KSUDz0HkVL4BZhr0?=
 =?us-ascii?Q?vgPV9cRhcQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a6c5cf6d-b929-4d8e-76fb-08da2d977b26
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4337.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 May 2022 06:29:45.6869
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1QO7EYEl1qEzNUYd7qd1ZYSGC7GpIZSaUX496X6S/Dcv29fsaNeFuBbIuKzUAEIxIeTlVytd8JF/RP5AZ6/udA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4745
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Patches #1-#3 add missing topology diagrams in selftests and perform
small cleanups.

Patches #4-#5 make small adjustments in QoS configuration. See detailed
description in the commit messages.

Patches #6-#8 reduce the number of background EMAD transactions. The
driver periodically queries the device (via EMAD transactions) about
updates that cannot happen in certain situations. This can negatively
impact the latency of time critical transactions, as the device is busy
processing other transactions.

Before:

 # perf stat -a -e devlink:devlink_hwmsg -- sleep 10

  Performance counter stats for 'system wide':

                452      devlink:devlink_hwmsg

       10.009736160 seconds time elapsed

After:

 # perf stat -a -e devlink:devlink_hwmsg -- sleep 10

  Performance counter stats for 'system wide':

                  0      devlink:devlink_hwmsg

       10.001726333 seconds time elapsed

Ido Schimmel (3):
  mlxsw: spectrum_acl: Do not report activity for multicast routes
  mlxsw: spectrum_switchdev: Only query FDB notifications when necessary
  mlxsw: spectrum_router: Only query neighbour activity when necessary

Petr Machata (5):
  selftests: mlxsw: bail_on_lldpad before installing the cleanup trap
  selftests: router_vid_1: Add a diagram, fix coding style
  selftests: router.sh: Add a diagram
  mlxsw: spectrum_dcb: Do not warn about priority changes
  mlxsw: Treat LLDP packets as control

 .../mellanox/mlxsw/spectrum_acl_tcam.c        |  5 ++-
 .../ethernet/mellanox/mlxsw/spectrum_dcb.c    | 13 --------
 .../ethernet/mellanox/mlxsw/spectrum_router.c |  6 ++++
 .../ethernet/mellanox/mlxsw/spectrum_router.h |  1 +
 .../mellanox/mlxsw/spectrum_switchdev.c       | 31 ++++++++++++-------
 .../ethernet/mellanox/mlxsw/spectrum_trap.c   |  2 +-
 .../drivers/net/mlxsw/qos_headroom.sh         |  4 +--
 .../selftests/drivers/net/mlxsw/qos_pfc.sh    |  4 +--
 .../drivers/net/mlxsw/sch_red_ets.sh          |  5 ++-
 .../drivers/net/mlxsw/sch_red_root.sh         |  5 ++-
 .../selftests/net/forwarding/router.sh        | 18 +++++++++++
 .../selftests/net/forwarding/router_vid_1.sh  | 27 +++++++++++++++-
 12 files changed, 82 insertions(+), 39 deletions(-)

-- 
2.35.1


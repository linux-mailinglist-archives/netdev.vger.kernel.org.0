Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E16115E5B43
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 08:22:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229901AbiIVGWQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 02:22:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbiIVGWP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 02:22:15 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2085.outbound.protection.outlook.com [40.107.92.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A897751420
        for <netdev@vger.kernel.org>; Wed, 21 Sep 2022 23:22:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iHQuL3+dM64p3Z7aIVwddfOzDsY3SQMzwhieRwKwatg6rCCyqITPvFrndwkclCSkVej2cek+UksCE0068DsV9MC3cN5K9JFDTh/UVR3RUUk5UXh0Cltrjr9Sq33zB6vdp3f4d8uRo4zcXyjlL4KKVnrRHZsZ3XrptPEQpQewDNdN/MSx8gTkle4f0wJnjNRxwkM91RgsY4ZFcX1CYg6Zolp7zlplyKDQFwpg219T3XeILZO9gsdO0HpGWZAHWht9Z8XQOLPnnyuLvm4sh5bqfX+eCBH2aPAykEqIIFvWRFmMQDk3HTQJMEvPrsxC/oXi7soss9KT99L2ZxstaJpyBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Mfj4w1QjVBPlYI1/B9CCXK7lIGHnMQH6YaiOULHsZI8=;
 b=e98L+FKO64OOr54iAe2MiTVK5Nq8IswwUnemg44QNlsRvQJwhSI9u+PluJHHW7CAoCvWrwmgJHx3kl5suC6z0/eNIKlshrUQ1qrjag0iVP3PykhJyxK5wvv965M2WmAXVCQfuTv7xwJ4j8ZiZh4sqdvZo+Gkta1pioc0rw24Jk0zHdf/irh9Uy7yrXOum8a/ADnCOdjL4N5aWHfJUQvVFzV4XkKpcEL6MELD3ma6IaBry4LDxFN6igGlZmYTsfBVFjRw0TBpqbMQc5G8Z3wEUt0UMWIKJqax5iiJhsSrKfNxQL7x7PHjK9ld88hPcISK508qkqtPVOHX9Elnz9YUUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Mfj4w1QjVBPlYI1/B9CCXK7lIGHnMQH6YaiOULHsZI8=;
 b=dhL9beCmvwHSnNE2cndmKaMxLKECllBPmGddHKFus7VrjQE5sx5JilSfiuf5y9je0ug4jAMfvzKmua2kdS9r25r0mE4zqmRgzbO9a4e0i/DYsDgYFf0vdrBOX5az9c9YHYR6G/1Z+o1kfk5gwHiTHi+Fga+OrYVt0CX/qBqoW36tgnu5s928XftqwAL4cgdy/x3vpYh+4xLSeaVg9HC7o0qorLzwy2QqOvrjKpBOWLMgz8XOEr95NP/DXFMMwLHx+XVmuyA7AHKCHsu/R3S5g7qBzFON5f785SxHcd8k2LyKUOqrOfaYchBrWh2shmwkgVgTh7Q/+jYdeqUURS9mlw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4373.namprd12.prod.outlook.com (2603:10b6:208:261::8)
 by DS7PR12MB6237.namprd12.prod.outlook.com (2603:10b6:8:97::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5632.16; Thu, 22 Sep
 2022 06:22:13 +0000
Received: from MN2PR12MB4373.namprd12.prod.outlook.com
 ([fe80::4842:360d:be7:d2f]) by MN2PR12MB4373.namprd12.prod.outlook.com
 ([fe80::4842:360d:be7:d2f%4]) with mapi id 15.20.5654.014; Thu, 22 Sep 2022
 06:22:12 +0000
From:   Benjamin Poirier <bpoirier@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     David Ahern <dsahern@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH iproute2 0/4] monitor command fixes
Date:   Thu, 22 Sep 2022 15:19:34 +0900
Message-Id: <20220922061938.202705-1-bpoirier@nvidia.com>
X-Mailer: git-send-email 2.37.2
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TY2PR0101CA0002.apcprd01.prod.exchangelabs.com
 (2603:1096:404:92::14) To MN2PR12MB4373.namprd12.prod.outlook.com
 (2603:10b6:208:261::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR12MB4373:EE_|DS7PR12MB6237:EE_
X-MS-Office365-Filtering-Correlation-Id: a7417e9a-beda-41f1-efe4-08da9c62c95a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FaHGP6vlfVR0P6tWjuGGFJH81XhQjNBRrXGoZ71NL/RQGalWv19lMfONXAToc+OgagURrwX0YFIxgH0JX4RQD1aF3XQ4F9Awc7rbVF3PuVlwTiuMowGyBgSASrB6lsC+eR6UIDTm93BebVFdi05yyUBITrc9ozt7xiJ8wf3shCBP/nbEdMijTDMli9SQr+nLXKv2Jw5t9DYuAwGyFUKyAzqYJzmt3GUP/DKoeP+vakMLjXj53XqsNSVdagYYV91IjZEb2QBVOr3s0L0RaOfnrhAEhUnUfbSe6Az/AiX/q45bFXDlc/AIbgMT+zBcwS/rY8CEk3XMbjcSWMll4YkPcOg47hkwBipnEryLEvZQz5TPF8wk11dX1bctJCI37X7/7fl/D0BMVp7NxPfaJhQvoEJ5pBbpixWM6hszaj+T39UUoypz/676LLjjGOOomi0fK493XVl6LSOslMN6t91d31Pe2PIJB0hrU/WMz9P8vW9+VTmUm7JC4eRFS6yzi7SzKhrDe+oNDs0sXwXvBBmi6q+haZox14JMTHkf8M5Nx7riENdsCPoGP3O4fV2hD7LyC0KfqBsI29FljPEtBdeW6sbKkbEDjMrhKFExKjFpJ1bIrdmwBry2SRtbFLDzYLNlh7q9Y6W5QMk06UDtgfd2eZS5tZWpl7NdmOyunJpa2c1MiolsyIFrYmHMhqQrDoEueHdSZnjFMl0tZDk0i81mgg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4373.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(346002)(366004)(396003)(376002)(136003)(451199015)(6916009)(54906003)(4326008)(478600001)(4744005)(316002)(6486002)(86362001)(8676002)(66946007)(66556008)(41300700001)(66476007)(8936002)(83380400001)(26005)(6506007)(186003)(6512007)(6666004)(5660300002)(107886003)(38100700002)(2616005)(1076003)(36756003)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Rd2PUJA7wf0xnsy2w8CLfW0Hct7uRLt3jrUuDyVYffvZQVjq0pinhY5Dh/WM?=
 =?us-ascii?Q?FL6POmiGYcmyCW58HxBqIZWcaS9plvg0IeDRxSEHW2nYAxpPzwyQCIKOGBZJ?=
 =?us-ascii?Q?VqrrnAnhNXP8Bv89ZPe46E33JWQ4ZHQGJIuxrp8T5HQxC3zfICtC5C+EVNwk?=
 =?us-ascii?Q?3T/tNbMsImOelSH4Ix1L0Lc+O96cnPLvWpXrei0eQhWjUDQ9m30fNti0z5Ts?=
 =?us-ascii?Q?eRGOu12rV0Z1njjR0XUOdN0DoDoq2bzfBueK4s01fbp6/HPA3o3DbB2qT/pY?=
 =?us-ascii?Q?AJl2mIyOhn7vMOfcCACkSBs2nAlpGMb9BSyyUH5HUgpb5lchwzZn+hbtpgJl?=
 =?us-ascii?Q?N3+EGba30u4E2zzry9Cmti5R+AAsn7wawS2+GpJRc0G0Dg5RE67pkVEGCSCY?=
 =?us-ascii?Q?cVG0kjtj3U4kRMFf2jEUua+uNt2TmBnYniH9Pqyp4VXIHaId8T35dieGvEHE?=
 =?us-ascii?Q?LUAgrCHoL59rZQwhcFn/PTXjfEqX5JKM6lQftPESlLFdAMfEi5jFdE5uZGQ6?=
 =?us-ascii?Q?T9iUoAFdIhorGdUvdhRtOD3NMqvCS8y9k24eoNCsmfgSL3fenA+kSKNMcai3?=
 =?us-ascii?Q?1Sj1+cI2glLvbQa8WZQytOYCSIKDgMB6EajFTVy8hfOzHPOvtgbxbSCbh4QR?=
 =?us-ascii?Q?auXJNhM/doL8yKJBdW/ZuVC7vCjcme7pGsilv9MPChThYCctiUjhQCadbT3k?=
 =?us-ascii?Q?rBgzwCLUl+J16jocSEODzlV4h8VDnK2DXTuzEng1NUSTUX+PAWvAQtFs/iHY?=
 =?us-ascii?Q?RKkaikK54XM0zG4Y9LV1DuNwfXT2HGPRi5AD93ZCOv7iLun35QaSlov/iWtm?=
 =?us-ascii?Q?93TiAnjkKDuZ1ncZnaS0CFGw5Ev5L1Ef8FYF+kmiBSNwMhsWOt0uZEL4sD+U?=
 =?us-ascii?Q?4OydoJ2SNUwM83Ivz7/BKe/WR+MUZxFjylyj634sYlD24oqlBocX9RDDg6S8?=
 =?us-ascii?Q?7P5EVnEOc2BPyY6Iybq4alcmEN6Vv121HKFV4uLcDSYMYRPOrHA+St5uJ4dB?=
 =?us-ascii?Q?uP5AhESvdYPodQHaq6otdTm6t/7mzNHvM2cTo5lWkkieuufVwKNn7cMQ5Odi?=
 =?us-ascii?Q?1GOWl8K5NNIEQnhZ5KM8d/4LQB9rdLbemjG1kVlQO+rIJ0jzFxjpwXZEasrg?=
 =?us-ascii?Q?T+VBRNBCMq2j2wbxgmXlghXY0KHuptWa4YsS2KyQHsdDOYIuNQpFMPKSyI25?=
 =?us-ascii?Q?MTBVNF8yzmhfOHqFUTgLenzCL05BOOuGSWIsl5ej1QeXRujZqjBY3VZ5TTws?=
 =?us-ascii?Q?55sdnAQXmk4VjA45k0ZzLPdoHq4Yiv6anWaFJJVY/Om8XRHxku3NVOZPTyJq?=
 =?us-ascii?Q?gVUz51bmXZLPJXmC9HK7GviQMI32GKDXob7+AudPizXM+pwieyhKljN+WBMy?=
 =?us-ascii?Q?05o+k38kWuZP6w9gyRjKQdVQwP1IqSIgnftuQmWJaXTt6Row2Ftv/dTwQU+w?=
 =?us-ascii?Q?E9MO/o9FJnGqZYkfwwp3wbUmJkuD/emHvrvGYeYzbyN8j+ioi2WuxMCfQmC/?=
 =?us-ascii?Q?4XoqVE+AuxDJYla9lk1uWGPwQzwOmGYEYcF3bbWHOuXQCh4t8J9OusOWPrt9?=
 =?us-ascii?Q?/2ojVdL425FLyduMdHzzJ3bY2ek3vf7FQv1BNXVU?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a7417e9a-beda-41f1-efe4-08da9c62c95a
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4373.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2022 06:22:12.6348
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: A6QoNvBlRhK/S21N8AWMvVcyf/fGg+JKZvWKXFN52uyKbqZrLGaOOGfn3H+fthCz17ve3/g7tlk+KqHrSsoZrQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6237
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix problems in `bridge monitor` and `ip monitor` regarding the filtering
of object types and address families.

Benjamin Poirier (4):
  bridge: Do not print stray prefixes in monitor mode
  ip-monitor: Do not listen for nexthops by default when specifying
    stats
  ip-monitor: Include stats events in default and "all" cases
  ip-monitor: Fix the selection of rtnl groups when listening for all
    object types

 bridge/br_common.h |   1 +
 bridge/fdb.c       |   3 ++
 bridge/link.c      |   4 ++
 bridge/mdb.c       |   3 ++
 bridge/monitor.c   |  35 ++++----------
 bridge/vlan.c      |   4 ++
 bridge/vni.c       |   4 ++
 ip/ipmonitor.c     | 115 +++++++++++++++++----------------------------
 8 files changed, 71 insertions(+), 98 deletions(-)

-- 
2.37.2


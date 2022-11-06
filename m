Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F80261E1E5
	for <lists+netdev@lfdr.de>; Sun,  6 Nov 2022 12:40:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229832AbiKFLk3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Nov 2022 06:40:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229783AbiKFLk2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Nov 2022 06:40:28 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2078.outbound.protection.outlook.com [40.107.237.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8491644B
        for <netdev@vger.kernel.org>; Sun,  6 Nov 2022 03:40:26 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LQiAuc9AqQlyCrRchYOLjWqAtG5rtZQsuiu8gfB7RAz9r8mQ4t0Qz9JZj0R0/MLz44H9A3U6Ra5RTME3F9tS71Wu2DB3iuuc5Mmspdxjp2BGzofHEqq9c7epb7lPHYT6U4ZKLJ7aPXqti+cc+dYciVW6f92n+lG1aQ6Gt43TvJIhCR8GJu7oVtVZaixjPlKDp9x5WmV15cBB661k07J8xbJlQig8MKVkUnMXrJ/6py6Gc+P0zQxV8IZ4OZ+/t/hZgq3sbBZM6VXO67RvfPLMM6C6lQNgFgSSst/NwEdFT+xrH/lnq88pZHFsNuUEVKdu0L83cBcfSzU5TJJq4CnM2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=shzOhTgV63vYG0FCtJugRj1RbHocDFWOljNGYUWr/zU=;
 b=BgT1b5NjeExO4GkCvEh9xE6RiWeLPcO3WqlXx57vfTlczXWPbn7Rl8VexsyJ57GO3whNgM0jdOWl+Yb3M9v6FN5PWhfS1g7+KKn8g1TNIKmXi/Smt2OzA/Blgr8Z2WYL/K0lPefpIRuraJE0IRiyoQfcZQMwgpbv9B3WC+TPoec3oXxb6yix7HJcGzNcypDmao06xzs9RHJyLN5P9bAvZ65gYzC6wDRe5ZSh5lK7Zj7U+jYGUBw/3JIuAZyVDM7qrq7uV+6zNx/8B6GjEVLQKmViivyUBsLCiqtHFsCDIeqyrR3IlV9NCyqrw3sOcDLw10jpMz7MOdAND9QVcr2MqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=shzOhTgV63vYG0FCtJugRj1RbHocDFWOljNGYUWr/zU=;
 b=OIYC3Ygh0ylnRVq0X/jvfmLNNxjr7KUoai5ojC6scb8cg7cs1q79dc+6KeHIBZIRI4ITCKKIpmfQoTTJCRw/pSSrZ6PsJn6f7f9CgbCUzjQM6jkEB5Wbja7imIGuvsOlDdl7o6QfK6rdH9w2UT46KG2csCG9+E55dTeDgjzcd2QsupTad5LkO6vR7aNDUipILEIJUf+2VbZFPuOTDyehXG5TW7K0iia+BYS/zujp1OwQ/vKb0J4/LGC02oGTKCDj76B8a1ldPKh4VphFOG1+l1agGzdZ1DWTMskHZMoqp3s+3w1E/yhsRjql+CT86JCc+JazOrWSQhg0ReZF2sRc4Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by DM4PR12MB5867.namprd12.prod.outlook.com (2603:10b6:8:66::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.25; Sun, 6 Nov
 2022 11:40:25 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::3409:6c36:1a7f:846e]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::3409:6c36:1a7f:846e%4]) with mapi id 15.20.5791.025; Sun, 6 Nov 2022
 11:40:24 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, dsahern@gmail.com, razor@blackwall.org,
        netdev@kapio-technology.com, vladimir.oltean@nxp.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH iproute2-next 0/4] bridge: Add MAC Authentication Bypass (MAB) support
Date:   Sun,  6 Nov 2022 13:39:53 +0200
Message-Id: <20221106113957.2725173-1-idosch@nvidia.com>
X-Mailer: git-send-email 2.37.3
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1P191CA0014.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:800:1ba::14) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|DM4PR12MB5867:EE_
X-MS-Office365-Filtering-Correlation-Id: 6ca4ee58-b49c-4cff-a436-08dabfebb16a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pGvYrUWNAx8Zo1vqNH5uk6OGnSYegkRKv8A+L33frmIsScW3zRhJytxpfKON9eWP7JcmeyXjsFwqXnPSN9BRGZLyLFCjrb0PDOA7p3XyAE/9iMq4gV65+Ph+6aQBsWIsjpDCaHS2MHb27gyfgHAlE44XVe3ZVBLJTRwGc5co9B6ZoC6qiPyPFh8+BVXv9NhGTKIEgEEqEvFc54w0r8sokv1gC/7ta6PihwnrDpQAxfK//cya1uuJsM6PDW5ic61E73crBnauCYTxy5v8JgiYqA9bjVlYh2XImLMrEiEdtzLxzL6ka5AK6bXX32y5wMlJ3GvWM1S4qLR1SKhwdujawO6tvnR08tZy3ZUrn/rfRlSlRWesUhzNmBshCQ1cwtZ0xfBm2xlskYxwpNMkyV/8DyFc3XGavUTRnkeyupBXkV/NJ2bJ2ruoj4n+I9r8z2P+PyN5QUsFP6Q/NuIVjVD37/0whnTW3B7wD/TdPNYwfloWDu4aZF7gFasS9+BZMX6bzDoRrqaVd+W4+vBkl/8htrBtk+P1yRTkPQzrmYncrsLMkz/At3u9lbaWegYu6oSvudys0R3aDvO2LE53r63Gd0Hl+T2kCoQ6LjmOpSbhXxGM6Lb+YB3vcRI396XkCZXzGARAhqjckHotP1VC81pjkqQdhb2NUiQyg9GQwiZsrJSaCL/CLcl53UsMlariNNkD6t+nbiRd4NY16ktRSYDd6w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(136003)(396003)(376002)(346002)(39860400002)(451199015)(26005)(41300700001)(6512007)(6916009)(2616005)(38100700002)(107886003)(36756003)(6666004)(6506007)(4326008)(8676002)(86362001)(66476007)(2906002)(66946007)(66556008)(83380400001)(316002)(186003)(1076003)(6486002)(8936002)(478600001)(4744005)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?F3T/3w7sQPw+eAe2SDw3Nezt4Ab0v/cSQU31lxfKwLT4F6XL0CELL3lU6uwL?=
 =?us-ascii?Q?tzhWf9rGBRgJtVkUBQArN0LH8zhnyJCTI0bsCqYOMKccz3vznmuJlEw9nbuc?=
 =?us-ascii?Q?Aq99XrQb2vBoGaV4lLSJnvNUHEoHGgLvA8xomSX2H94dPv6lbMRUpZtB0KEd?=
 =?us-ascii?Q?WIt7StFw9vn1ipWklo6uwCxKCOMBju+lvJ//I/g2A/bovwSaNqoJYZC9H8R2?=
 =?us-ascii?Q?JrAnQhcCnw3f6xCrKp6D8twippNYxO7SqWXBMZxkn6STMY12GLOl9AVr8DP1?=
 =?us-ascii?Q?UpNeB/WtphkYedHgdbsBwvT2iz2B844v1NE3P7P0KFtqJsck8gCzSa8YRLlA?=
 =?us-ascii?Q?KfFPEasjtd64AGuNkq8IydCWfvbOrxBnrpK1hqp8C9KTzenywUn+EYXiTDvk?=
 =?us-ascii?Q?8LpTVEatq5kwGg0ZMHh1rwavVy6z51mXBq8toDwFpSCpOEgfjpTeEt513UwR?=
 =?us-ascii?Q?g2g0mp7bdpJ1S/kPv82cVa5oxIrDlOXYmHDv12erjOfONoRIRDTARhpIuYS9?=
 =?us-ascii?Q?uT5gMWOm4xQl9nOa48h/45O3zzTo67sm5BfI/jcOsoxPK6MKDutVPdtSAPsU?=
 =?us-ascii?Q?SyvnDidN9ZoxuTsHKAN89zsgZcT23R89evlulDssk/oyuqm4euJQQaNkPmZC?=
 =?us-ascii?Q?B44U0Tl00rVQ0l/5j/JYHXkruEDjtaU+ZTaUP2IGAM+fdszWtLYdyN1lqN92?=
 =?us-ascii?Q?ReHeRGNMkPD+0iwSaMFfQW6yWh9IQ+augqmtSH0ClVsyFDgMznjYIHevY/7P?=
 =?us-ascii?Q?ry4DFZiCusWqjUgOElPtVz5qFavbMJcBCEWe2ebZjePmPpT7EainO7fbWN9Y?=
 =?us-ascii?Q?hJjSE+n08QoFQYMHCbJ+YBr9FnQB5ujszlsL43UVwzRkT/EmfFmiWDiV2NI4?=
 =?us-ascii?Q?iXs1JKx/jbQ9su1iPIhg6lUF+O+nKAC1hsASJqXMcFUTcQdJ39/Wcnn4qtWp?=
 =?us-ascii?Q?hqMasIVsksyowl1fcSFsUvXUOixvhVv8ji8Li49v/IJPatHmsRNqQxtAWp0A?=
 =?us-ascii?Q?/4Iug64NSyI+3UBTYATTEJVkuJ/w1AMEbCsjRAgX86+MSv/uUKUvuY+VIEhh?=
 =?us-ascii?Q?uzMpVhNQQPWrl5k9Y9SRNn0MbsWhooBMaAR6DeONWVnOOzWg/qWFvG28HG5Q?=
 =?us-ascii?Q?xjvOKxhjUcP2SB/bVc0htRvzyVGEVOQHGq4tXh8d+kb+mVTNj8vE8ofMn9mJ?=
 =?us-ascii?Q?X3+wNuNp6ff295I1tzGxDIgTca/MXtfyvwBOnIoT/3yrwIJcaDgdufNrCDGS?=
 =?us-ascii?Q?PR48XNqBZBcAIr7qpIwHR+Fai2OHT5proiM3SgahrAoVZzGurQsjOSwBcGcP?=
 =?us-ascii?Q?oJTBj7rGN8e1iOXI+PJM0DeJw4I05QlZ4avUthoCEWWr5JCc5eU2StUanJna?=
 =?us-ascii?Q?5H+V2+riePaBRsboT8O+iUB7QNxtdGB4jEMku/JBWHuFJ1LGAGMHT2wzEeRZ?=
 =?us-ascii?Q?sL4ebz3osEJ/Ggeu53nLxFEQ0DrDXFklJVfzKerGvYJqW4UoIEwY5jo1OmRt?=
 =?us-ascii?Q?LGlqplSguHOADvMMb+L6DAARiF263DOEKD0y3sv1ixfHdwTmSceVK/5hKvgP?=
 =?us-ascii?Q?tbkLZmnXfjgQsULwbrLITrd18ITuy5ciADU39Gzc?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ca4ee58-b49c-4cff-a436-08dabfebb16a
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Nov 2022 11:40:24.3466
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ow3OU3/grwU626Y711e9//eiX1wlcRYsdECtPlISasFvkd2B+fhQrBUoP7rdb9/alIum6wi/BwbO8UaNyW8jcw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5867
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add MAB support in iproute2, allowing it to enable / disable MAB on a
bridge port and display the "locked" FDB flag.

Patch #1 syncs the kernel headers.

Patch #2 extends iproute2 to display the "locked" FDB flag when it is
set.

Patch #3 allows bridge(8) and ip(8) to enable / disable MAB on a bridge
port and display the current status.

Patch #4 rewords the description of the "locked" bridge port option.

Hans Schultz (2):
  bridge: fdb: Add support for locked FDB entries
  bridge: link: Add MAC Authentication Bypass (MAB) support

Ido Schimmel (2):
  Sync kernel headers
  man: bridge: Reword description of "locked" bridge port option

 bridge/fdb.c                   | 11 +++++++++--
 bridge/link.c                  | 13 +++++++++++++
 include/uapi/linux/if_link.h   |  1 +
 include/uapi/linux/neighbour.h |  8 +++++++-
 ip/iplink_bridge_slave.c       |  9 +++++++++
 man/man8/bridge.8              | 34 +++++++++++++++++++++++++++-------
 man/man8/ip-link.8.in          | 31 ++++++++++++++++++++++++++++---
 7 files changed, 94 insertions(+), 13 deletions(-)

-- 
2.37.3


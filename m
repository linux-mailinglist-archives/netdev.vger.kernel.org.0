Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9857641B60
	for <lists+netdev@lfdr.de>; Sun,  4 Dec 2022 08:53:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229908AbiLDHxI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Dec 2022 02:53:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229630AbiLDHxH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Dec 2022 02:53:07 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2081.outbound.protection.outlook.com [40.107.223.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4A5D1106
        for <netdev@vger.kernel.org>; Sat,  3 Dec 2022 23:53:06 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Nkp6MGqCMQgcZNKDXMFRLJP6BURRozcIslN+jUSizXfLfvjr7su381SxieAIwVWzSY5EJIwwaFMNmceQtkXigWDPjKDRAceEXI6OOZrtD5jHIFrGzHk55tSxefpC2qIeYIFfSZT0/ByfVAh89POhO3PF5XD3eYnd4apo/Pxbret87QXbB2m5ZYdWBl0guS2+Y/od21IeMBbaBOXPB0D3y0bXCoZ9FNrfdKK17O81+wK0beLasSjsiYYVAJ7/EBqzPLZtKopgab3TwQw3rSZ8TA0XnLUm3Q4xyBWf38AP+ibfM86L+4rk43yevWujafo/e0jB8uB97TYREL/LirfFPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SnJRGc4upBnHrI5FNc0DDEP8qTZlgt+uBBeWPm7IIbI=;
 b=ecY3aI7VieAstswmg+PEgnOb47DyeCKfyesJKCVLJ2g1XTp4JINOwta+23L/6/5khB0GNCVo3mXN1Ytn+kYEXO+JYuvK52BAUgUsaikzdCjRABVr2f0qJjdg33ewaSz/pyHvNeD59M576w9AsgXvPYJlzw1EJX3pFGLo27LK8olh1eWBOHuzOqHBZjHHCVzvteWO+dCSC230j730ck3GFarfeH+v3LktEPuWLzjRIRh9kqEJah2WBP01+I2fLwmmpL9eaRBT7Aw/VKSten/gAidLbZUVqO3GCsb1CAp1gYypVVKCpRCidm3Kr0PtrezmTLosWX3diCSYQSF/huXekA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SnJRGc4upBnHrI5FNc0DDEP8qTZlgt+uBBeWPm7IIbI=;
 b=fqmxTTmuqqQra4ppIY0HKcIcUAiOjFRWQYiQZCF/qDOHcDRtpZBIaU6kXm0GUbLTtDuyURZRYG6dR3hqdZxUoxRhDLm72DHeoJIrr7RjyMEdAlx8akjGEdmAzt6qEo1fZJ4NVO15zRH1HRZYR+VijYNsu6ydTLxtRylFZMieazBYy3t8yOol9VKlxDEqufaSOLCPybNgsNw8kBg0RQ9GiKoHHNNBVei2ZX7u+GKjLEzhRx/nKupDw/lZR2ltii96wG4shcCckO4PgIMurY1TeQ/Bm17XqLeHL0J+gAVhd25CulhSWa153Gau9DGVAL/YZMzNGaeAsneTDucE2T1Vew==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by SA1PR12MB7296.namprd12.prod.outlook.com (2603:10b6:806:2ba::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.11; Sun, 4 Dec
 2022 07:53:04 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a600:9252:615:d31a]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a600:9252:615:d31a%3]) with mapi id 15.20.5880.013; Sun, 4 Dec 2022
 07:53:04 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, dsahern@kernel.org,
        mark.tomlinson@alliedtelesis.co.nz, sharpd@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net 0/2] ipv4: Two bug fixes
Date:   Sun,  4 Dec 2022 09:50:43 +0200
Message-Id: <20221204075045.3780097-1-idosch@nvidia.com>
X-Mailer: git-send-email 2.37.3
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LNXP123CA0003.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:d2::15) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|SA1PR12MB7296:EE_
X-MS-Office365-Filtering-Correlation-Id: 0d0d54d7-bc87-4580-1a79-08dad5cc934a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0A8z4QSUmVjQBbJqXcfkJS3i09jfA47SQJRjy2PHtfRCjBU+j+fTzjRRfbhboY8/AHZLNY5sUzCgm1yp5JaShiQhtWCUjiAPhJcYx4AuaUO2JghhTzsvX6CqwuefztlFMiSkI70DJYoehDcDBzB+H6x/PJPDz79dC77MFnQQweNEhv0fxHTE/IBN21PrDXV/t4znGUyQ4TFNxvf9t0FkHKXceOrqlu0m6gSXA8e/pJ/SWS9hvJVXbep9J6qlSyo8TvNa7C5LxomRT0tkMVmg/M/9wizIAmZwdd5NUXaubkoOStJQQVaUgSs+zadZ0CgZcXRLx4WBgurDoIZKDFlC+k6SoMkf8LFIBiFYGlqdZFhz8e+no9Dd+giEtVVsxTB2NLn4x/rFCCZHIdt167LldKodkP2rO5Sl30KpO8BpPTzUqM90RJtJSSChLOJqp3EBvIzfdptpc0Yy+5zWpvRQgw3fr/HAkqMLsvEymT6swSpDiEtCycvR3VOM1GgmuKcsuLNM1XtxvCIXN9JCDE3BijeP9IA2GV73znxo5hCmq5+z99GXXOxsqx7oUnvdQQIev1WxyHTAnZx+UxuQhuiOPUidWFfneG5FF1w3MnODCBZikqCrTANSd2RwOEFvDUkDJKUdNacBAYiuUACD/fuo8w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(376002)(136003)(396003)(346002)(39860400002)(451199015)(36756003)(316002)(83380400001)(6506007)(186003)(6512007)(6486002)(1076003)(26005)(6666004)(6916009)(107886003)(2906002)(86362001)(66476007)(66556008)(66946007)(38100700002)(4326008)(8676002)(478600001)(2616005)(8936002)(41300700001)(4744005)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?aqdhrKKP36QQ/ugPTzCZIhsb43+rMTsPoUXjClKOGyc7cYByqQa/kJD+ZgMj?=
 =?us-ascii?Q?4yMzmkvh9y5QglgLTcvU1Uh4ECEVcoIFFBbM7HoXm0J0mRqmFYxMHwuWzDxo?=
 =?us-ascii?Q?3W3CLJG0GRqKrXTSFsi4NrbOswPuXlkSZvcJzlkbw+bKOhaRjpvnYqCaskTO?=
 =?us-ascii?Q?4hh5luATt+Z5QCHyWKabN6w8ZdKuehy5/m2We1+2Ue334agwvVMEZeXlnzf+?=
 =?us-ascii?Q?ouubvT0BMMnRJUxGa5t6Lo/v74kv5n35KECNxJZ4v6R0jNlH38WzICVYmX++?=
 =?us-ascii?Q?5mljQOe4dub+EyC2L/jcxvFFlYi10jFSAij8eupDeVGMtfjPDgdVUoE6PsjE?=
 =?us-ascii?Q?StNiTdmL3tL2j+vxzH+mzuz5VBKTN5mgBRUfuj2SHWpLMNTilMmpI8EC4ziX?=
 =?us-ascii?Q?UKn+PTp/mBPOrUDnhaJU/hV53uS8pDgbGuRWWeYUnIt/f4ENRYY1HEtGCv2t?=
 =?us-ascii?Q?3BvRNb71b3UFzcbzUOp9Bs3m8u9cU+SFNjaeb2VNEPGH9vwly5qfgjZkgxJZ?=
 =?us-ascii?Q?B0/3j4nl5V5fmsGON9qWslSh/PfRRVfTi3JM46co7jc7nCZiyGsHDEOIGONW?=
 =?us-ascii?Q?v0htJkHiP7Y/OOT0UsBCWhiL/xVA7AVTEbcM1+a8HjMrpKtibZcqmtR2L/oD?=
 =?us-ascii?Q?jYw5CUhgHt9itRIcUwzjH35DQshOWvUbzWMVn353i9+Be14P3O7FMe33s2mR?=
 =?us-ascii?Q?daIP3E0BbymojzqwhiiEtGQMLJ1nS3UphVyvUusQQhLyicyBZr0+w/3X5tO/?=
 =?us-ascii?Q?0kdFEy3dKnFWNLYCyiVk76HSwZDvMZcThtpiOYaXquVYZBL4pdhq4Pt7/bty?=
 =?us-ascii?Q?21VXHDVUqk9HLKdj5bKF+4jAe1Olr/cZAbKsJ08iRPLYB1muDRDNbg0iPWkp?=
 =?us-ascii?Q?GbaQSqQDpiDiNnGOmzfT+GnKBOItGjvu9GtHrNx6VStv6aX58NKoRO3PESRZ?=
 =?us-ascii?Q?NoEd7hCiZwo7Pf2wfjqd2P8cLoO149qrPI0dQ2rnoozN9btmgohTkjAq0899?=
 =?us-ascii?Q?RjyWb8uLDnWG93Kh/miHDav4DYQD14SC/PdSjL/mQuzJLuwWP/nrGqTSyPFA?=
 =?us-ascii?Q?eAYD9qps0kHK+8r2TrN+Nyf/JM3201qDJ+EipAsXdiKJZ73SGp+hw3K43W6S?=
 =?us-ascii?Q?zt5uIZLLS2ol00N42n4/C8D+x/imzDqqHaD8C/hgEMb3L8ptCJlypMK8QX+J?=
 =?us-ascii?Q?Gzgh4s4UEEAyt01esr6O/FKjdAb+6PBx/ev/RrxlvDqxSZssvfpHRW8MQhvm?=
 =?us-ascii?Q?vEh8FFVOHkSpzbZf39i7fF0g00I05Oyi/WY5ElTSLVpkQ1S+SQ2VuPD8Tv/x?=
 =?us-ascii?Q?7tG+ACO7lCIrY2tMTNvTP+fgjaPX6v1AKjWdRfqvWoxnTUdg88m/+JMxQySD?=
 =?us-ascii?Q?7Mpg0tBE/FZMvYM9+tC/3a5JhZA0vyDo34g3qNtek7VZI797U1aaz+mUPH+V?=
 =?us-ascii?Q?Yn4jobPoRUHtsNr3i6PUEE7yU+SV133DlI6wXFPKboJVj1i+M3lagn07DWBw?=
 =?us-ascii?Q?7kUUq/UHIsIgG+sXWO0Z/eFWvHZvEg9vS52Xaa8BSR28OHw/jromyHNwzEtN?=
 =?us-ascii?Q?f1zAwaNV8bN1UlHkQ5AJzcs5QTwRo7xXTV9OsBoC?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d0d54d7-bc87-4580-1a79-08dad5cc934a
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Dec 2022 07:53:04.8435
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3EjZxULvcYdo8OYo/HsOehN5229mVRGki/5lYBIIBgTGA9LrM8x1ZdWw8MncI1LuZrTvMOei42HsgolgMMBo0Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7296
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Two small fixes for bugs in IPv4 routing code.

A variation of the second bug was reported by an FRR 5.0 (released
06/18) user as this version was setting a table ID of 0 for the default
VRF, unlike iproute2 and newer FRR versions.

The first bug was discovered while fixing the second.

Both bugs are not regressions (never worked) and are not critical in my
opinion, so the fixes can be applied to net-next, if desired.

No regressions in other tests:

 # ./fib_tests.sh
 ...
 Tests passed: 191
 Tests failed:   0

Ido Schimmel (2):
  ipv4: Fix incorrect route flushing when source address is deleted
  ipv4: Fix incorrect route flushing when table ID 0 is used

 net/ipv4/fib_frontend.c                  |  3 ++
 net/ipv4/fib_semantics.c                 |  1 +
 tools/testing/selftests/net/fib_tests.sh | 37 ++++++++++++++++++++++++
 3 files changed, 41 insertions(+)

-- 
2.37.3


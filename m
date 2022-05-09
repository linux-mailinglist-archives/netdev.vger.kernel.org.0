Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BF5351FF12
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 16:08:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236839AbiEIOFh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 10:05:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236808AbiEIOF0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 10:05:26 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2071.outbound.protection.outlook.com [40.107.92.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 555E326564
        for <netdev@vger.kernel.org>; Mon,  9 May 2022 07:01:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cJeRMoC5r6R3Jkje0Ej7/OhkpOEUhTgBeU0NROfAvZ0lb6NZ18nEhXO1geRCB2MlD7U//8IUcxO1QqXftnrPOSbQalSG7V5pCMw20XoaLodkZeoZX/QZHMMY5fwXi/znIk4gReLbFaZ4VexA7Le/tr9pPdzSHcFTXUwMGpZ3sMQHJtKztYbU4rY41POTdytXStylgAZUs6/sdGiRh1uCV206b7gHk5x9/JNjQbjzo1/ofHnBGpYLqgXpnWbkKob9BWFoXCYPPc6cmuCQzcXCdgtrC1zdcEjkA/GJbfpuKbxnpFs5d9Ph37CCo+cU8cKvqjzxxs9vJB9+TF+3GAK1Ew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fgNCi1/rMNire5ZRPVP4tCIkFPqZo/A760/FGcYmi2I=;
 b=FQUnhd3N56W3hcyR+CgUgUJZ3L1GxjWNPoswvAMcXjesgKLWV81LSJujjYp9f25pjxs+psy/lsGf+vZ30vaeBt4Dt7H0q61lcpDOg2Z8kSsx1KAI5XyPkre9be5gPhi8gvPzlD+a9PMF83xwBEXY2ar1SGwRr6TObPMhYyoki7+zZfPOPjTH7vLdSlRgt3TO7Gqo3nDCitIU0wpRpybIeoP93V1k6W2VnJisHRb9d3EYvsl9vWC2jAwTaGQ2oStvNp4vureexJsyu08BPsNFyHy2TYGRjdtIFf4F07SpXRwHEhwWwfh9kx4rHJd9naNlt0+WOc4FmvnLbyQ1NSzAkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fgNCi1/rMNire5ZRPVP4tCIkFPqZo/A760/FGcYmi2I=;
 b=YMB0/04NpmZAElYHFkePGA9MiRaI7EGzsb1MZSigwSgOplGhj7yS1e51NkbpacTPR9kHkREpvq7LRJq5ijdZJEEKO508ZNX9FOHJOjyMllf7nsn8WEC0lpeJxH0Bn5qkz3RNR3JV6P4fr/yhReuZW9GKyryh+IIu0MrnLnj0FBgpW7RIU01h4yyySwAgjCgy5Q3SqguK0K72eE1jJu12H1w74je+PwOPMqRejICgSB2ZkM4pl4hQtjdk5s7oDeYLO2N60I/I8zyzbvSulCD3sqqQfv5XZH00EIZE2qCY3gGtfz+fFez0vLm1xUWc8uhamrzRXXcKvujcBfaREv7owQ==
Received: from MW4PR03CA0047.namprd03.prod.outlook.com (2603:10b6:303:8e::22)
 by MWHPR12MB1789.namprd12.prod.outlook.com (2603:10b6:300:112::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.18; Mon, 9 May
 2022 14:01:24 +0000
Received: from CO1NAM11FT022.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:8e:cafe::f) by MW4PR03CA0047.outlook.office365.com
 (2603:10b6:303:8e::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.22 via Frontend
 Transport; Mon, 9 May 2022 14:01:24 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.238) by
 CO1NAM11FT022.mail.protection.outlook.com (10.13.175.199) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5227.15 via Frontend Transport; Mon, 9 May 2022 14:01:24 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Mon, 9 May
 2022 14:01:08 +0000
Received: from localhost.localdomain (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Mon, 9 May 2022
 07:01:06 -0700
From:   Petr Machata <petrm@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     David Ahern <dsahern@gmail.com>, Ido Schimmel <idosch@nvidia.com>,
        "Petr Machata" <petrm@nvidia.com>
Subject: [PATCH iproute2-next 00/10] ip stats: Support for xstats and afstats
Date:   Mon, 9 May 2022 15:59:53 +0200
Message-ID: <cover.1652104101.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d44d2b99-a18b-4d58-cff5-08da31c46759
X-MS-TrafficTypeDiagnostic: MWHPR12MB1789:EE_
X-Microsoft-Antispam-PRVS: <MWHPR12MB1789DB526BC28F0104318355D6C69@MWHPR12MB1789.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RGWFHZU8/IJuRn1w7Z8x/EP/f57WjGYC0b6qOjD+IGGDwr49dreVJ6+i9RDhoWxe26Bxpojng3ZA8NVLFRPfNdiTEhcVic7h8P2dyPoNuFE0U62sNEDif28cbjlYT+bMgYIwtHX1VWuXb36XjAvd4lyPlkpWUOxeEUKjd6InFr7yfZciRid/vJ9pa9mCd44kPnMieDXgwVJgaY+oc6wZK4PsKzzWouCXoZ/yU0Fxz9pFSj9GMTUTZ5DVGKTlov9A7Dq0Tl7CcOeywYisTMCL5NDzo0UrfrvxTyNx9ZCoaob0VbYvcCl37RSy6tPV52AGF8FmIIKt+RpEQbUU6vxy2T3EzbePd9qCuQOSufS7yhGJt+rEAruNosfyaFyCTLQSlOs0BrayTm4rfvgIlIL1r4T8ClCKYsPZvMPeBBsd77bGqGQ7AOUCboJ7AvboZT/YuTkly48onfUZaCG9jz6iFLqt4m6SjCPRqzzXFkbWiwt8T17BxnXHZEuiVpevTV3wYqDgshe9g89V4s5/PtwugyvwFBKMowmTpkLq98izXPH2ySfXbM1LV0o5HvpAoG7hkoNs+eRKHlKU3lYad4mulQS8yyryOZW+sxOrikTMB0qsNUdeFmpyBgRmYU9zvFPy5oP7lGs2XkmWPZBoko1VON0o3fuaI4QxP2eSQzxIg2Z1/Lae0ifAFX40pMRGzzQ/883LPY8nJWHbDdOpRt+SMA==
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(46966006)(40470700004)(6916009)(8936002)(316002)(508600001)(40460700003)(5660300002)(107886003)(426003)(47076005)(54906003)(186003)(16526019)(36756003)(82310400005)(70586007)(70206006)(86362001)(36860700001)(26005)(2616005)(81166007)(8676002)(4326008)(2906002)(6666004)(356005)(83380400001)(336012)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 May 2022 14:01:24.2542
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d44d2b99-a18b-4d58-cff5-08da31c46759
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT022.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1789
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The RTM_GETSTATS response attributes IFLA_STATS_LINK_XSTATS and
IFLA_STATS_LINK_XSTATS_SLAVE are used to carry statistics related to,
respectively, netdevices of a certain type, and netdevices enslaved to
netdevices of a certain type. IFLA_STATS_AF_SPEC are similarly used to
carry statistics specific to a certain address family.

In this patch set, add support for three new stats groups that cover the
above attributes: xstats, xstats_slave and afstats. Add bridge and bond
subgroups to the former two groups, and mpls subgroup to the latter one.

Now "group" is used for selecting the top-level attribute, and subgroup
for the link-type or address-family nest below it (bridge, bond, mpls in
this patchset). But xstats (both master and slave) are further
subdivided. E.g. in the case of bridge statistics, the two subdivisions
are called "stp" and "mcast". To make it possible to pick these sets,
add to the two selector levels of group and subgroup a third level,
suite, which is filtered in the userspace.

The patchset progresses as follows:

- Patches #1 and #2 fix up MPLS stats formatting and expose the helpers
  for reuse.
- Patch #3 adds ip stats group afstats and a subgroup mpls
- Patch #4 adds support for JSON formatting to MPLS

- Patch #5 adds support for the selector level "suite"
- Patch #6 adds groups "xstats" and "xstats_slave"
- Patches #7 and #8 first prepare helpers, then add support for the
  "bridge" subgroup of the xstats groups.
- Patch #9 adds the "bond" subgroup.

- Patch #10 adds manual page coverage.

Petr Machata (10):
  iplink: Fix formatting of MPLS stats
  iplink: Publish a function to format MPLS stats
  ipstats: Add a group "afstats", subgroup "mpls"
  iplink: Add JSON support to MPLS stats formatter
  ipstats: Add a third level of stats hierarchy, a "suite"
  ipstats: Add groups "xstats", "xstats_slave"
  iplink_bridge: Split bridge_print_stats_attr()
  ipstats: Expose bridge stats in ipstats
  ipstats: Expose bond stats in ipstats
  man: ip-stats.8: Describe groups xstats, xstats_slave and afstats

 ip/ip_common.h      |  22 +++
 ip/iplink.c         |  75 ++++++++--
 ip/iplink_bond.c    |  55 +++++++-
 ip/iplink_bridge.c  | 334 ++++++++++++++++++++++++++++----------------
 ip/ipstats.c        | 126 ++++++++++++++++-
 man/man8/ip-stats.8 |  50 ++++++-
 6 files changed, 522 insertions(+), 140 deletions(-)

-- 
2.31.1


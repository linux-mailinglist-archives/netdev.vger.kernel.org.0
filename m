Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93A3C6CAA0A
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 18:12:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232459AbjC0QMf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 12:12:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229767AbjC0QMf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 12:12:35 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11hn2235.outbound.protection.outlook.com [52.100.173.235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86704269D
        for <netdev@vger.kernel.org>; Mon, 27 Mar 2023 09:12:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PZrSLvSfJdkXoaJkNtZwKqUFCereRKd2zx+SIpFpSZz+bGIIfMwtzUSzFEW1nNw1bPQHiO4HZAJ1YOmjWESx+a6tFt7IvSOQg1dl2V8BjuaUJaqGpifodN+kXdbk0ecmvNXr22EDli1SUu3jMdOwrRcv3MFL0EDag6g+x38QF3wuJiqlZ+C9QlsyjSvgHLSgwJ96AiQhtHk9sCws3lfPREb64/aZFqZAmF1HlZE7rEKwh3Bej7/a6BJEG6uwwf/dtdAULlhAhnu8XH9bDfkhk9v6cCAPdnA2UO/EukQpsApECacf3s9qmicFrrSj8cmtATFmTQ55M8Z8ZIC5W5p0+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=unekT3+EHcZ3LIR4ZxZsy9rNPJV61Jj4z2dWi7YTGrc=;
 b=R47Pb7nsxwVVWb20M5e/SGrfXCDYLY6iTWEjtaYysipU+zyoaUZknxwUlRjd/94a6px5R1Ounv5hsQBDXWZ8NZ/ZhdYEmlxh2NrV9gtRBH/c2DjFcle292XYvRZJVBS4zs/quaBuMmtwie8NWPkMzgak0ZUoQUGUqkn8QcaxgR3N319MJBY0DBU6vAsliruxA+arGLeKdu98mFrqJ2ThlEI3X4sbdHM87BANb1PVql3WEKYoPklYMDdJPK57zRttzIqd0yk6YtrJ9lmwhg3ZoeF4QlYSQzIYXpp/YgM3kSU9cato39rzy78AswsMTEgnl/sY4e5e316xSK+ZYduAhg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=unekT3+EHcZ3LIR4ZxZsy9rNPJV61Jj4z2dWi7YTGrc=;
 b=WzzLKe8SO0nxlMtybZgREmOrygpIsGgSnyJQVLqG2HuQd9lYh1c8XBNDKRsPf3eKRTCZr/Aw0xcLBXuaTa4wTp8zOwL8aJQ1CxjpRas409r2NsbNaHALfU5fNpJ6O5emsCfBkWanxvfaz5JoRVmw/8zPeZLHC+ad2kri3eputZJY+1nP3zTkSHEw/b8Peq6cKQfGFddZJqxlbv1gkpJBIWLXQb8SElKINjT6AdTUzLGKcLfH8sXwahgD5YSkvOcTU5CmdkgF0mGkhHYIeo/QD73fsJnyUG95ysfWUPonXJ82Tg6JgXAhW2ieuSXNgjDr4bhGfeHzkKnuMe+XjtUD0Q==
Received: from MW4PR03CA0356.namprd03.prod.outlook.com (2603:10b6:303:dc::31)
 by MN0PR12MB5859.namprd12.prod.outlook.com (2603:10b6:208:37a::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Mon, 27 Mar
 2023 16:12:29 +0000
Received: from CO1NAM11FT074.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:dc:cafe::14) by MW4PR03CA0356.outlook.office365.com
 (2603:10b6:303:dc::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.43 via Frontend
 Transport; Mon, 27 Mar 2023 16:12:29 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CO1NAM11FT074.mail.protection.outlook.com (10.13.174.254) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6222.21 via Frontend Transport; Mon, 27 Mar 2023 16:12:29 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Mon, 27 Mar 2023
 09:12:20 -0700
Received: from yaviefel.vdiclient.nvidia.com (10.126.230.37) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.37; Mon, 27 Mar 2023 09:12:19 -0700
From:   Petr Machata <petrm@nvidia.com>
To:     <netdev@vger.kernel.org>, <dsahern@gmail.com>,
        <stephen@networkplumber.org>
CC:     Petr Machata <petrm@nvidia.com>
Subject: [PATCH iproute2-next 0/2] ip: Support IP address protocol
Date:   Mon, 27 Mar 2023 18:12:04 +0200
Message-ID: <cover.1679933258.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.230.37]
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT074:EE_|MN0PR12MB5859:EE_
X-MS-Office365-Filtering-Correlation-Id: b583b0a2-058e-4d1e-197d-08db2ede102c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FGlodADmIRhc0hV3JO180BgblC7D/+O8zxxwtPX44A/iQMDnOFt6kKvlKhm4N4Wtx6fxWsgC3NhCcMq3eukp5YSG6XzZx/xuzev+sRUu5cnBR2Ze9RscNNF6MDTyl2npGJDm5xUR+8qnBkBokerGb9Boi8tb1VgJbuXH3DE+z4k76V+BH15cBMbEzntWgUNyO+awBzsVWrQCwgfGhjA+1SrTGsJ05FAlsosx1Ti64F7A+7XC+g9vXfNiFmtDIYCWr52r+VEqfBJY4dXcE/jEB/MDlojfsn0ZUnQnFaWXwi1SGXNtkt470AI6H8c4S9S1xcWEXaRdoA3uaySHoYH9SaQmtTtExWN5sRgjGwZF9zmkD7Xb9jTWcrm6k9y5GNIn+yS1WiFswJiHYKGrEnb1j8lHKQRbxaFz69JcvH/+FaPFXVfd731T3E8tqJz1ow58EVOxlznkkvZzTOCZyDSKzqXjr+sYbYdW+3qSpBVPSQrV/YbBUeqJGXDwb2ljybmJ9R3tenrswOdJc9HV2jUQbitOZjZisWhAtbZOv0mXnaTi6NrChj2hgfC9c8pLvnAMnsA62jSvTf+YzLBqHuBWhMCwSSqj1eI+UJeBm5uwRwNC5C0xJkYHOaoYm11KeL9F89mkz2H9/aL93i3lAv9CKL9+5uOXk6/uVeyU9gGBfKOLyNUEJFAJAbL6CVL0cvNAjaO/g/zLYpXzny3oUQmNdsszX7jFvc2qeQbzZWMSQVvpKPrFEvdx7icbsbfsFLo7Ac1Ch23IN9jp0h7tcwbVBuakKoyMCJF/zv4BTE2Ji8Yopv+6S4lwG8y8sBC1X+yx
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(346002)(136003)(376002)(396003)(451199021)(5400799015)(46966006)(40470700004)(36840700001)(36756003)(8676002)(83380400001)(16526019)(356005)(316002)(40480700001)(8936002)(70206006)(34020700004)(47076005)(82740400003)(36860700001)(70586007)(41300700001)(7636003)(2906002)(5660300002)(107886003)(7696005)(6666004)(426003)(4326008)(2616005)(82310400005)(336012)(86362001)(110136005)(26005)(40460700003)(186003)(478600001)(12100799027);DIR:OUT;SFP:1501;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2023 16:12:29.0906
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b583b0a2-058e-4d1e-197d-08db2ede102c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT074.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB5859
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

IPv4 and IPv6 addresses can be assigned a protocol value that indicates the
provenance of the IP address. The attribute is modeled after ip route
protocols, and essentially allows the administrator or userspace stack to
tag addresses in some way that makes sense to the actor in question.
Support for this feature was merged with commit 47f0bd503210 ("net: Add new
protocol attribute to IP addresses"), for kernel 5.18.

In this patchset, add support for setting the protocol attribute at IP
address addition, replacement, and listing requests.

In patch #1, the code is added. The commit message at the patch lists an
example session including JSON output. In patch #2, add the corresponding
man page coverage.

Petr Machata (2):
  ip: Support IP address protocol
  man: man8: Add man page coverage for "ip address add ... proto"

 include/rt_names.h       |  2 ++
 ip/ip_common.h           |  2 ++
 ip/ipaddress.c           | 34 ++++++++++++++++++++--
 lib/rt_names.c           | 62 ++++++++++++++++++++++++++++++++++++++++
 man/man8/ip-address.8.in | 49 +++++++++++++++++++++++++++++--
 5 files changed, 145 insertions(+), 4 deletions(-)

-- 
2.39.0


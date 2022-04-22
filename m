Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC52E50B2F5
	for <lists+netdev@lfdr.de>; Fri, 22 Apr 2022 10:32:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1445479AbiDVIe0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 04:34:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1445056AbiDVIeY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 04:34:24 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2056.outbound.protection.outlook.com [40.107.237.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B76B44A11
        for <netdev@vger.kernel.org>; Fri, 22 Apr 2022 01:31:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OATz+O6LPd38zexeBPRl8sZRQOLr2psuUeCa24CZCWFfsU+u/hSj6+tdr4W+NVSGwLiSYhRbSDhlkCXRtAoIkv+i/kFchjf8uDMYWMlGzNtojI8e/WCoMBQa80uIMF9+zANvkzj9VB6r7426rGdNjkytGXL5U9suaamVFmU8/087ltVE3snDnFwUBhIAcYvCc5Hb+5IlWOKbueA1/Xwhyq1CzVyNL4c6aaobE6e1/c7j2IJr5Gg6SQuWfpFh36Icka+oNVTtEVadZACWPluRXddKEG/SlfZGXvSBSYPmM7eLHNTcK4nfwJXtUxl/nQR+t2++xJoy1t+EVPcbXc4pSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=B6RnO6mBS02VFalT6bu8unDUOWQFvagSb/3XG/AwKTw=;
 b=afx5JEKS7Q5ulXydIngb2cpDoityYlxF5EF1iWd+SersCGULBvOak7rmmHO+ifsM4jhIqFNDxRVA0UtgRkNn3d7Xzsx6+UXJYuJ8qpXNWnrarK5ZARXS9QQW9c+KO9eRRQB5kBJw5S2OpexxR+9txbWwY1knXZyKbSvXsXKkF9+xm8cRdmFTH7EplOIB150PkOpj86K0W2mf7ZJ/j5BwsJgPqiBrWoh52/cIDRk1lfF/4R7P9UwSls+mldaA1au4+mZwJAr9PMC9KHYP2yJQMDooM78NGpR9j4m6xUj/1+SDKg6XH3ogf8gwPH41x8OeH5GCukanyNdYY/M6eYu4YQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=networkplumber.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B6RnO6mBS02VFalT6bu8unDUOWQFvagSb/3XG/AwKTw=;
 b=duUH43LGXeYZmjScuPCpwJ77wbxbm3jqGiJ4CsayJfDN7dHpDXspgj+yfQqHO1aHjumKGM7OhLCPKJgT25dGPyw2KfApHAK8zFksTVv1d5Ia9r6CH21+6gZc3whRLQW0ask/oRelAkIpXBZjlzeENdhRdJtcBJGE2OTcd0yslF1RM6fZqRKkaD6ly/WmhKHs9TPHdzhR/PUA6JTkJ5a2y3+nMfclpYADm15cdf6hkPAZMVhox5WYkIeuFbkp2tENYoXikONJYOr6QTHJ/4EBFnPft/yhevGe4ylL/n/pWW8CjdFt0xrWD9T2rYfgubz/+nwCpVTDMp5u0PcyMdUEVw==
Received: from DM6PR03CA0079.namprd03.prod.outlook.com (2603:10b6:5:333::12)
 by SA0PR12MB4400.namprd12.prod.outlook.com (2603:10b6:806:95::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.13; Fri, 22 Apr
 2022 08:31:29 +0000
Received: from DM6NAM11FT040.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:333:cafe::f7) by DM6PR03CA0079.outlook.office365.com
 (2603:10b6:5:333::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.14 via Frontend
 Transport; Fri, 22 Apr 2022 08:31:29 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.235) by
 DM6NAM11FT040.mail.protection.outlook.com (10.13.173.133) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5186.14 via Frontend Transport; Fri, 22 Apr 2022 08:31:29 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Fri, 22 Apr
 2022 08:31:28 +0000
Received: from localhost.localdomain (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Fri, 22 Apr
 2022 01:31:26 -0700
From:   Petr Machata <petrm@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     David Ahern <dsahern@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Ido Schimmel <idosch@nvidia.com>,
        Petr Machata <petrm@nvidia.com>
Subject: [PATCH iproute2-next 00/11] ip stats: A new front-end for RTM_GETSTATS / RTM_SETSTATS
Date:   Fri, 22 Apr 2022 10:30:49 +0200
Message-ID: <cover.1650615982.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a631ea73-13aa-4f60-d298-08da243a7f8c
X-MS-TrafficTypeDiagnostic: SA0PR12MB4400:EE_
X-Microsoft-Antispam-PRVS: <SA0PR12MB4400926A0CBE90270854441DD6F79@SA0PR12MB4400.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: B7/U51AEHmeEFjFwh3nA2/pfE5zHmwPGT7P7eWO7dlTIgQdUXaFHqz/JEZpAYHoQhpC7MbN5T9nW+MSPBOX9NyoG0Q9UQCBlpKNraO4AjtMBxuavlHsJDpujIZ9ADATpJ3BUGuxNq706q4yKf1eBD/zmdfCnK7EF2IsWsAsKqyPpihpaz+GTagVu6Mf1XOspnP0Adu5EtFbsfse4U9P9+IyS9CqhNGsdeZre33RzLKdeQrA8IAcEYgyq58TPgBjewt/E3LizuINFyW2WMrAYd+rcDjkOgb/klE2a0zLNSWiTxxET2pBJpNbzKX9czDnDnZcjTD8r+Kdzctm7Oe1xWVC9j4nTz5Gx7Nr27Yt0DikxM/gWAG/ukTZa3xxmcBg9DNrd84Oo5+4MONz9CRCpAJsmXHkKhnC9DWrDCN1ITMcKRiJLewyW0boFqZPniUxYLyOSdswgFmwQApFRo2z6wcEDQfllJuCST3weiZJGZMw58qSONi6dzz5oUX4psPJ7Uly0yk5DkUys8AnWzuakRYB1x5+WSGfZwrk70WIFi+VzpqG147iPsqbrbDEoWjnbp+tJ9hBusfXr0PF2AE1mB5mFfu6WbkjWnzjTxg6CINQ+W2289C7ar5D8iScMrX7w/4PWIW61j8gapEmMzjLJssp6pbxpZfLzYxoqfv5CbChPk6WyR/M4xieUtAuzidtF7zcTmJdJxhhptsuo+3z9ew==
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(40470700004)(46966006)(36756003)(2906002)(8676002)(2616005)(316002)(40460700003)(5660300002)(6916009)(83380400001)(54906003)(26005)(36860700001)(508600001)(6666004)(86362001)(336012)(186003)(426003)(107886003)(356005)(70206006)(70586007)(81166007)(47076005)(4326008)(16526019)(82310400005)(8936002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2022 08:31:29.1735
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a631ea73-13aa-4f60-d298-08da243a7f8c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT040.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4400
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A new rtnetlink message, RTM_SETSTATS, has been added recently in kernel
commit ca0a53dcec94 ("Merge branch 'net-hw-counters-for-soft-devices'").

At the same time, RTM_GETSTATS has been around for a while. The users of
this API are spread in a couple different places: "ip link xstats" reads
stats from the IFLA_STATS_LINK_XSTATS and _XSTATS_SLAVE subgroups, "ip
link afstats" then reads IFLA_STATS_AF_SPEC.

Finally, to read IFLA_STATS_LINK_OFFLOAD_XSTATS, one would use ifstats.
This does not seem to be a good fit for IFLA_OFFLOAD_XSTATS_HW_S_INFO in
particular.

The obvious place to expose all these offload stats suites would be
under a new link subcommand "ip link offload_xstats", or similar, which
would then have syntax for both showing stats and setting them.

However, this looks like a good opportunity to introduce a new top-level
command, "ip stats", that would be the go-to place to access anything
backed by RTM_GETSTATS and RTM_SETSTATS.

This patchset therefore does the following:

- It adds the new "stats" infrastructure

- It adds specifically the ability to toggle and show the suites that
  were recently added to Linux, IFLA_OFFLOAD_XSTATS_HW_S_INFO and
  IFLA_OFFLOAD_XSTATS_L3_STATS.

- It adds support to dump IFLA_OFFLOAD_XSTATS_CPU_HIT, which was not
  available under "ip" at all.

- Does all this in a way that is easy to extend for new stats suites.

The patchset proceeds as follows:

- Patches #1 and #2 lay some groundwork and tweak existing code.

- Patch #3 adds the shell of the new "ip stats" command.

- Patch #4 adds "ip stats set" and the ability to toggle l3_stats in
  particular.

- Patch #5 adds "ip stats show", but no actual stats suites.

- Patches #6-#9 add support for showing individual stats suites:
  respectively, IFLA_STATS_LINK_64, IFLA_OFFLOAD_XSTATS_CPU_HIT,
  IFLA_OFFLOAD_XSTATS_HW_S_INFO and IFLA_OFFLOAD_XSTATS_L3_STATS.

- Patch #10 adds support for monitoring stats events to "ip monitor".

- Patch #11 adds man page verbiage for the above.

The plan is to contribute support for afstats and xstats in a follow-up
patch set.

Petr Machata (11):
  libnetlink: Add filtering to rtnl_statsdump_req_filter()
  ip: Publish functions for stats formatting
  ip: Add a new family of commands, "stats"
  ipstats: Add a "set" command
  ipstats: Add a shell of "show" command
  ipstats: Add a group "link"
  ipstats: Add a group "offload", subgroup "cpu_hit"
  ipstats: Add offload subgroup "hw_stats_info"
  ipstats: Add offload subgroup "l3_stats"
  ipmonitor: Add monitoring support for stats events
  man: Add man pages for the "stats" functions

 bridge/vlan.c         |    6 +-
 include/libnetlink.h  |   11 +-
 ip/Makefile           |    3 +-
 ip/ip.c               |    1 +
 ip/ip_common.h        |   31 +
 ip/ipaddress.c        |   33 +-
 ip/iplink.c           |    3 +-
 ip/iplink_xstats.c    |    3 +-
 ip/ipmonitor.c        |   16 +-
 ip/ipstats.c          | 1241 +++++++++++++++++++++++++++++++++++++++++
 lib/libnetlink.c      |   19 +-
 man/man8/ip-monitor.8 |    2 +-
 man/man8/ip-stats.8   |  160 ++++++
 man/man8/ip.8         |    7 +-
 misc/ifstat.c         |    2 +-
 15 files changed, 1512 insertions(+), 26 deletions(-)
 create mode 100644 ip/ipstats.c
 create mode 100644 man/man8/ip-stats.8

-- 
2.31.1


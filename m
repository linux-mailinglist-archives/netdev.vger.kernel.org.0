Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29BF151FF09
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 16:08:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236863AbiEIOFn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 10:05:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236826AbiEIOFb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 10:05:31 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2089.outbound.protection.outlook.com [40.107.220.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 218BC106369
        for <netdev@vger.kernel.org>; Mon,  9 May 2022 07:01:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VZoN0MAwsd7eVdfHb6wjOoM+1//9LQw5C7BKa4B6GJ3v/3ckqXybC2bQXedS/iiGkgORI26b1ZrXX+8TGoBut+CMUgI4i77L6NBNW3l3rflLeJ4mf3vX4Nb5xuQMtSftdhY8MRPJfBtWCPLJ7pTMJBEcJRk2iVKj0y6RVqHogaN20jcISGRGhHh/ZNC+2BC6KA96fRzjIuS1jRSD56YQ7yeTMK/SUHEDYcNiE4fas53kMNa1emMlQCAwsZKpXs+RNH/jjot6zr/tivKzS6MEZlq0eDDjronkBvncLjg3EsqD45dpTjz7gTJXkKnVeRLg7CSGTVkhBzppib/jNyOZHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PVabmntvvWxAdolbhoSb3iWR+Rt2fYGWRunTaTrFQgA=;
 b=CZPGOnuSpKYnLpdEbMcvpJDYi0Jf93Lfl9efyzpgeyOWEB1g1Eu+gkftFUo5182K+7TtKQl+ijxZEoD+Gq8Xil/AGTVP6DzXnoRPvNPr8zPPGx/TnzzblWIqfc08bYxAIpbo3Uu6rApevlB7hZoA/nIzNHZy320xP5bgySy/gZVJCu0KmNJmy+rrme/u0rV/nTQLAUBNCdoiQFSyIW/52YH0mVcUqOj9ZTSiGbGZVkEuzp8nqe1Jtl8n02V+NhSImiuwVOkYgFkTvxmap0d8/F557y6FJBzCvQiz0ngYtmQCENY88J32LvUAd2CFpko9vPbil1CAu4VFa/z5j3Qrvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PVabmntvvWxAdolbhoSb3iWR+Rt2fYGWRunTaTrFQgA=;
 b=Rh3Vhfo7t9923VWnMvNOg454ICy9QvzjEthaNLY2xDLC7u0yvGe1sI6RZxyVPo44VEYmOj8W+EXtUlxA2ONUQ6q0BWYQDvP/QoPd1VfcX44gmpzB2WpdL2XQzwqtbdxR0B6FcMQvQQCzHGaHccvyN83RLqkMc0yyD5uIXfDqwdxyx2aYjCsEGCjQrQ3TsVN0J4XyQgpbHjEUIGIixXIiNhdagHnguXh12/exlH7dcc7ZJ1KY4G+UQE+CnPHrS9+4sfcmfit6VhRZ6KpcG59p/pIPcrohFyyPCHvyuD6TQJWndELzVMhwvP89M1qS3HXzhpXu1k6lO9ZgCnC101/ouQ==
Received: from DM6PR02CA0164.namprd02.prod.outlook.com (2603:10b6:5:332::31)
 by DM6PR12MB4140.namprd12.prod.outlook.com (2603:10b6:5:221::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.21; Mon, 9 May
 2022 14:01:35 +0000
Received: from DM6NAM11FT050.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:332:cafe::24) by DM6PR02CA0164.outlook.office365.com
 (2603:10b6:5:332::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.22 via Frontend
 Transport; Mon, 9 May 2022 14:01:35 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.236) by
 DM6NAM11FT050.mail.protection.outlook.com (10.13.173.111) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5227.15 via Frontend Transport; Mon, 9 May 2022 14:01:35 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Mon, 9 May
 2022 14:01:23 +0000
Received: from localhost.localdomain (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Mon, 9 May 2022
 07:01:22 -0700
From:   Petr Machata <petrm@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     David Ahern <dsahern@gmail.com>, Ido Schimmel <idosch@nvidia.com>,
        "Petr Machata" <petrm@nvidia.com>
Subject: [PATCH iproute2-next 10/10] man: ip-stats.8: Describe groups xstats, xstats_slave and afstats
Date:   Mon, 9 May 2022 16:00:03 +0200
Message-ID: <57a3cc7e722151ad66c84291f292eeb13328c5a3.1652104101.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1652104101.git.petrm@nvidia.com>
References: <cover.1652104101.git.petrm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: eba3c087-8072-494a-59f7-08da31c46e17
X-MS-TrafficTypeDiagnostic: DM6PR12MB4140:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB414023186637C6D9A27A5F63D6C69@DM6PR12MB4140.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7ZIMNPj81penukmzewS5TTyOmv7m03762ApZXquYAGXpBo9g7gfEsA3PPMh0+mLpQCSRpT8nBmqMuQfqbnbZAYF0qNLY7gltDhrMWIhgZh3Bl5FsGKljHoZH9tRl5aNiuUYbItW58TwO95nX/6VKedgPJLxb5eoUXHlqTBFh7ApMabWMuOLoiON8v6o9UlotX4gQDT6dvsCKfXgZQuUHHWK2wvFf1lQBTXikN0c9rT2YJ1Z6vF6a9uR4d+7hYYhfWkBrgcnf9x+djpfSz4iMMzL74pwB29oAVAzH5KH6gAhDdLoPaQvyHcLJCK76HpU56RCdK8sLSy7LZUGtSGfWaqTblgWuilCopY9ZKpS+WcGSvETasdlV1UPf6WkhYrlhNjrruBZiKUOrbmlYnvagbdMk3Kefenb9laVcUSHcYmOq+1kSOEfxQuIvDTEKQmQLs3wuDRRfyjIJpE0eJpWgvCOkwOnuH34jWMsppZV6wBDBuyESnQ9g+XqJRqjGSH778S97+jlmk1qy7N9Qo6vuhut781CaiWR3roUlEvucA3KfHzwzSpN6XU8VfNaaMR56imymmpcHmtoOiU/iMbn/+nWgQGzQp7Dk0lHesw+55XzYzt7NWqD9PqTtO3KzOMA8ktYO0NV8fLSDCuKbiIkDqCu1m+XccbGA9y3kCSyM5pkCB5tJmE1KTgZa4/jxiY/7QKLWp5Zx9POkPQYfsaMZTQ==
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(36840700001)(40470700004)(36860700001)(54906003)(316002)(6666004)(36756003)(86362001)(2616005)(6916009)(107886003)(16526019)(47076005)(356005)(186003)(426003)(40460700003)(336012)(82310400005)(8936002)(8676002)(70586007)(81166007)(4326008)(26005)(70206006)(508600001)(2906002)(5660300002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 May 2022 14:01:35.5471
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: eba3c087-8072-494a-59f7-08da31c46e17
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT050.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4140
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add description of the newly-added statistics groups.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
---
 man/man8/ip-stats.8 | 47 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 47 insertions(+)

diff --git a/man/man8/ip-stats.8 b/man/man8/ip-stats.8
index a82fe9f7..26336454 100644
--- a/man/man8/ip-stats.8
+++ b/man/man8/ip-stats.8
@@ -68,6 +68,20 @@ The following groups are recognized:
 - A group that contains a number of HW-oriented statistics. See below for
 individual subgroups within this group.
 
+.ti 14
+.B group xstats
+- Extended statistics. A subgroup identifies the type of netdevice to show the
+statistics for.
+
+.ti 14
+.B group xstats_slave
+- Extended statistics for the slave of a netdevice of a given type. A subgroup
+identifies the type of master netdevice.
+
+.ti 14
+.B group afstats
+- A group for address-family specific netdevice statistics.
+
 .TQ
 .BR "group offload " subgroups:
 .in 21
@@ -133,6 +147,39 @@ For example:
 
 Note how the l3_stats_info for the selected group is also part of the dump.
 
+.TQ
+.BR "group xstats " and " group xstats_slave " subgroups:
+.in 21
+
+.ti 14
+.B subgroup bridge \fR[\fB suite stp \fR] [\fB suite mcast \fR]
+- Statistics for STP and, respectively, IGMP / MLD (under the keyword
+\fBmcast\fR) traffic on bridges and their slaves.
+
+.ti 14
+.B subgroup bond \fR[\fB suite 802.3ad \fR]
+- Statistics for LACP traffic on bond devices and their slaves.
+
+.TQ
+.BR "group afstats " subgroups:
+.in 21
+
+.ti 14
+.B subgroup mpls
+- Statistics for MPLS traffic seen on the netdevice. For example:
+
+# ip stats show dev veth01 group afstats subgroup mpls
+.br
+3: veth01: group afstats subgroup mpls
+.br
+    RX: bytes packets errors dropped noroute
+.br
+            0       0      0       0       0
+.br
+    TX: bytes packets errors dropped
+.br
+          216       2      0       0
+
 .SH EXAMPLES
 .PP
 # ip stats set dev swp1 l3_stats on
-- 
2.31.1


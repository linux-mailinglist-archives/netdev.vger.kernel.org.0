Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 058374FE985
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 22:38:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230158AbiDLUkF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 16:40:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230045AbiDLUjf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 16:39:35 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam07on2057.outbound.protection.outlook.com [40.107.212.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2301975E7C
        for <netdev@vger.kernel.org>; Tue, 12 Apr 2022 13:35:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dapt+nKc60oq40t1l1U/qdXNsG3xrBEXfllKcLOm0Vw178IQ1oU7izwEFnCz6g9jJddBnNsg/hMfF2j243sF8i/eKA90CETbI3BrgzrUFfvHglLOyjOb8qaumyu0hvQqE//EA90Isa/mMcAHtdBmSJBCnEcBPCKx9zgeD1120NHmZmMp3cgVTvCyMVqx1l6ofk4oM/gprm5YMFxpu8obRqcoiSApaHMHwC9H7HcnjWJ8nHiOfQdNQXT0S0fiXp+cSFIksRq6p3XW9z9FizXEeyDV1+5wNxclHAQF2Esl+mf3EQ5OGnDQELSuKZ8IIGPHWQPTRGgNuCtx5V1pzSlpZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OFG308hyNeumBcMJqZ3yx9g55rh7duK1KCBKPvq3uBs=;
 b=ktVVBhs5bj/RB0si+vy74lwdkR+D0wIlf0SbsRGH2KAx1i0ThUC0WvWPuMAs1poitqa6mGK0LKw2djeT6XIH2nOKeA0f5QpQsMS21jpHRQ21NGmCW4HgfZyokFCpBLtVBWGsQR/q7Bew6tMOW2auwTU+AzSa++8WFZJmDG7+56E1qg3R1Ql0QxD4AZjOsAorqv5lfrZSVYwx7dlmYgyiMFIz3IdrmL+s2duG1Ce+navXpzQ1lyGgkMeho7dXM7LVbF6iol3klF5Fma8iVHiy/NlSGOetiTPf8ADrp0CM4mg2gXhZ33lsfrJ3WqBF1nphE+DRkmeyksj1dKYNzyglhw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OFG308hyNeumBcMJqZ3yx9g55rh7duK1KCBKPvq3uBs=;
 b=fWpWQDRgb40ZSvTgoqdEKM2b9Dm0WwIWUQRwS8NJ7nrc8eTY+55MnhrLNVj7nCxViMv05z4J2HIIEWmSXQs1J6l2yHtTvBWOdOxs1IVXdP5bwoiuDo4eOGuHMm43PvZTYZvz/eKOWI+N7i4jATkfCZKnCZgb177DcQpJ0HPjw6CIQ63igz5nceOowoLVbMclNglGcmI5ksgBWyKa49vo1kT/3AZt1yICg3PidCIHHDtt7+sDboWtmE8r0ZpZ5NlyUUZXI+jJIK4Iu13pvFI8SFCpajCi5MJ89Xj3YvvZUDOFmAi/90rBL6RPjrXsHFwjZPMPrDOZcm2PwaWv90Q4XQ==
Received: from DM6PR03CA0008.namprd03.prod.outlook.com (2603:10b6:5:40::21) by
 MW5PR12MB5624.namprd12.prod.outlook.com (2603:10b6:303:19d::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.29; Tue, 12 Apr
 2022 20:25:47 +0000
Received: from DM6NAM11FT052.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:40:cafe::2a) by DM6PR03CA0008.outlook.office365.com
 (2603:10b6:5:40::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.31 via Frontend
 Transport; Tue, 12 Apr 2022 20:25:46 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.238) by
 DM6NAM11FT052.mail.protection.outlook.com (10.13.172.111) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5164.19 via Frontend Transport; Tue, 12 Apr 2022 20:25:46 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Tue, 12 Apr
 2022 20:25:40 +0000
Received: from yaviefel.local (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Tue, 12 Apr
 2022 13:25:38 -0700
From:   Petr Machata <petrm@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ido Schimmel <idosch@nvidia.com>,
        Petr Machata <petrm@nvidia.com>
Subject: [PATCH net] rtnetlink: Fix handling of disabled L3 stats in RTM_GETSTATS replies
Date:   Tue, 12 Apr 2022 22:25:06 +0200
Message-ID: <591b58e7623edc3eb66dd1fcfa8c8f133d090974.1649794741.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 35937562-2c18-4e85-aa09-08da1cc2a076
X-MS-TrafficTypeDiagnostic: MW5PR12MB5624:EE_
X-Microsoft-Antispam-PRVS: <MW5PR12MB56249D8EB67531752AE31C64D6ED9@MW5PR12MB5624.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xwuTYyWLQLmg2p93en9zaLG4XtbyqAgZydPkNznIjVOf29PG8Cu3lsQzW6OVpo8oI9xdSahstq/YQRYaM5sqH27IsLXFJ+H4XEuSM2I2KA4lmkX4ZwjGMM5+LZ2rDXDszr1hggYRih+tqckn6RFTsgW48sjT+fBKNN5nSFSckU35RD1rGHWUt9qwiOoycRwklc98kwh8ZJ152aJA4LVlu+f4Hdws0SslcoYttt3ak4JdY90HTzZQ5K8LZjvJenYcMZ2YWVaoJNqYvae3zCq9TJUTyHOjwyih4uUwjotveuo8eJ81SYCUVnWmLN3sfxrn/tGtpTUaGYHFUxaP3FO35hQsGrhqzlYnG7g9RKuzuylNg7mrAsbX9XKPx3rzelhHtC6inz8HNOx2A2csgqRzjEnzvatoEiIWIyv/QWdoe/RoqhdUZWJxf34VisA0mP6guvDMrJf0nFqLb6gKpew4dhsrM7CthmgA5XS8M91xTJy4W6aLTCkS12ikzM9yZB06242LFaj13uISRW9Spl2dszAsGUfn/blxRbQh+Nxin/9ozyLQmVYwrToLL4JSfDbdFvXREU3Vf1/325WmdHpfBfxu4dXR7+EMNPYOf3Fa5ufrZY841h1PBMhmWHMfPjwHpFK1k2qf83LVrAxaQAjabAl9FxZQe8BShAmvnjdkuBl4LQCh1VH0cMsJ752zh1udC7vLMpOXf4xdX8i8Bg220g==
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(40470700004)(46966006)(186003)(5660300002)(82310400005)(40460700003)(70206006)(54906003)(6916009)(81166007)(8676002)(508600001)(4326008)(70586007)(426003)(316002)(2616005)(356005)(336012)(83380400001)(2906002)(107886003)(26005)(47076005)(86362001)(16526019)(6666004)(36756003)(8936002)(36860700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2022 20:25:46.6461
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 35937562-2c18-4e85-aa09-08da1cc2a076
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT052.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR12MB5624
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When L3 stats are disabled, rtnl_offload_xstats_get_size_stats() returns
size of 0, which is supposed to be an indication that the corresponding
attribute should not be emitted. However, instead, the current code
reserves a 0-byte attribute.

The reason this does not show up as a citation on a kasan kernel is that
netdev_offload_xstats_get(), which is supposed to fill in the data, never
ends up getting called, because rtnl_offload_xstats_get_stats() notices
that the stats are not actually used and skips the call.

Thus a zero-length IFLA_OFFLOAD_XSTATS_L3_STATS attribute ends up in a
response, confusing the userspace.

Fix by skipping the L3-stats related block in rtnl_offload_xstats_fill().

Fixes: 0e7788fd7622 ("net: rtnetlink: Add UAPI for obtaining L3 offload xstats")
Signed-off-by: Petr Machata <petrm@nvidia.com>
---
 net/core/rtnetlink.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 159c9c61e6af..d1381ea6d52e 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -5242,6 +5242,8 @@ static int rtnl_offload_xstats_fill(struct sk_buff *skb, struct net_device *dev,
 		*prividx = attr_id_l3_stats;
 
 		size_l3 = rtnl_offload_xstats_get_size_stats(dev, t_l3);
+		if (!size_l3)
+			goto skip_l3_stats;
 		attr = nla_reserve_64bit(skb, attr_id_l3_stats, size_l3,
 					 IFLA_OFFLOAD_XSTATS_UNSPEC);
 		if (!attr)
@@ -5253,6 +5255,7 @@ static int rtnl_offload_xstats_fill(struct sk_buff *skb, struct net_device *dev,
 			return err;
 
 		have_data = true;
+skip_l3_stats:
 		*prividx = 0;
 	}
 
-- 
2.31.1


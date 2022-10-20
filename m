Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C776606440
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 17:22:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230003AbiJTPWn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 11:22:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229992AbiJTPWj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 11:22:39 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2079.outbound.protection.outlook.com [40.107.237.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2D1E1645F4
        for <netdev@vger.kernel.org>; Thu, 20 Oct 2022 08:22:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fcpbTunKV+u+oJvI8fhTH2A91qHr0xRqDuJPIYE4MoCRyCegy4kWFFcXGE8cnsZXeHcErZG1kWQGL6KNFKpqXPyRAmpQkRlnz0YNTp20DsYbr2PYWLWYGKMhPq8EItqa0LxLhq7RYMZjCHjgkBZot6GsMUXdTg13zf0fiHFb61D2p9y3PGcvxHMUeMILOOp5C7++U3ecdKSyN4QE+WReMr/p4WOVRW/uUKzlwWH/LRvNK3X0xyG+/Qd/xg9f8Ef7kktp3asiQVxTMfpeyzO3/h9hBY723+zxB5mRnrt2ELXm0nnVhAINI3UWPIPuPC0u6TrvKLGI2HU9u7abLNEnag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4YuBKnLn/qjsBy82u/keBsyoa7JiylaARsj7OX4nff8=;
 b=b54feuYa7Lo9ps0r5D3IQUdVUZvDs+dFSMKm4VfsgqAvdhr19bXxGOjC59qV9K0uc6qKCPOB/yum6N50yJEFCN1Vtk0r1BKmCasY8G1t4GdXjLB9S87P5AdwnIh3m+eBFwvJmCZqcCJkQQiq76mo4HOx2f+04rSAvPq10KYMdCahd9Zaw4073uDJgB00Qzj7rR5Yg62LimPzZRRW7om6CJLNvKcmoQ+geb5aBEh7gR/aevX2oUrAkSqjvPd87BXOwb600kEWa6HM3cdubXv7utU7G4Pe2ugMK2ZuAkXRQh5uhrZ52K6CULuT7xZe+SN/Oqbc5u4j9oO8ybxR7vCxGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none (sender ip is
 216.228.117.161) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=fail (p=reject sp=reject pct=100) action=oreject
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4YuBKnLn/qjsBy82u/keBsyoa7JiylaARsj7OX4nff8=;
 b=MENT6jDl2kzwtQhmBlyRBCeqIuoyM6oCRwcEzjDkYb6eQXBaD2dP0J8S1THFN4J2+/4n1ywvqB8EOl/GfyZDJBi133Bkp14VX84DVeI+orrxWPLSZY0C2gSiWCTduUaDslihdq/imXPBR6IAy5GPaBfNLijGcrJT3d/jL5bZDNpBVxJRRsj9pwdjw9946um67etL6XtkpkF7q1mPFPuXOMl6Y5+O2vvbkGtBv/6h3ErQVav1eQ+ABJFZ7SPNJEO2cu5rs74L6lKCbPdtU6trdo3Jz//X4nSikbRgBPYYZNjoENKl56P/0c66XxVQ344cMCQFP8rjTQI07foslgj+Ig==
Received: from DM6PR04CA0016.namprd04.prod.outlook.com (2603:10b6:5:334::21)
 by CH2PR12MB4198.namprd12.prod.outlook.com (2603:10b6:610:7e::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.34; Thu, 20 Oct
 2022 15:22:26 +0000
Received: from DM6NAM11FT055.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:334:cafe::72) by DM6PR04CA0016.outlook.office365.com
 (2603:10b6:5:334::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.35 via Frontend
 Transport; Thu, 20 Oct 2022 15:22:26 +0000
X-MS-Exchange-Authentication-Results: spf=none (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=fail action=oreject header.from=nvidia.com;
Received-SPF: None (protection.outlook.com: nvidia.com does not designate
 permitted sender hosts)
Received: from mail.nvidia.com (216.228.117.161) by
 DM6NAM11FT055.mail.protection.outlook.com (10.13.173.103) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5746.16 via Frontend Transport; Thu, 20 Oct 2022 15:22:26 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Thu, 20 Oct
 2022 08:22:19 -0700
Received: from yaviefel.vdiclient.nvidia.com (10.126.230.35) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.29; Thu, 20 Oct 2022 08:22:16 -0700
From:   Petr Machata <petrm@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, <netdev@vger.kernel.org>
CC:     Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Ido Schimmel <idosch@nvidia.com>,
        "Petr Machata" <petrm@nvidia.com>, Amit Cohen <amcohen@nvidia.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        David Ahern <dsahern@kernel.org>, <mlxsw@nvidia.com>
Subject: [PATCH net-next 3/3] bonding: 3ad: Add support for 800G speed
Date:   Thu, 20 Oct 2022 17:20:05 +0200
Message-ID: <9684b0698215ae746447b2d8b4fd983ad283ce0a.1666277135.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <cover.1666277135.git.petrm@nvidia.com>
References: <cover.1666277135.git.petrm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail201.nvidia.com (10.129.68.8) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT055:EE_|CH2PR12MB4198:EE_
X-MS-Office365-Filtering-Correlation-Id: aabe2ab4-3c01-4f7b-c89c-08dab2aee54c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eshhPC63FJ9AO4+pyJ2h0Z/RKT+ltkJiabrfYivaytMdF0ASkP9JWVXsqpA/6smn+5386/DXyfDNpkCQeCB7e/DH7VBlomDayOW3y+RNFqbZyVl8b2Y14p2Z/cC0bWyeX/w1PZVDMHpqh2n1e8pDHGvpyLfPgzn5KTih55hnrLh1FM8nnbVGt/uOrV3symq3JQ5l/XeWy3zwF8k7AhD3w/7Oz9wP5UxhC9awwwAYBCILqA0C4YaSQQXc3K2iv3OWk19PMG8S9xdBdCqxa79ssCFrkJaWcm5a3/NKfF4aqVGLbt+wjhDWDjn3gfjsutaTR53cTA50WuqJQ0PjJVD2SGx0d+qPDCNrKA31fho+aovxoW3qe2evcxbFRZ3Jy1/M5b27epSYtER3CoGTYJMGLufdqpqQqNWdxJrKXKIJjRORA22+z+D+4A1E8Hpl8QCmkdAkDet02xb6voq5CE5NU7cWzgT+CXwIYSl+TIkBIeiq2GIvFpgMul4kkAnd004XPJJZbMicNM7ddvQ9BTKUERYRt6eE+WSdauOat5ZIu4EEJVoay6/EeE+ZIx8Xp9KKUtxr3wBS8MHUtKPmaRQrB2ItqHY3WDmBlbwEGvgL3tkbj9x2TVxkjauyBc+LDJ4hExF5BK0ocL52IRWQgvB7a93S24EnyJUJ1S0uOoPs1CWk4JBpLdcMiUy4GhlpJKyoc4gZbBZbGqTJCGkgSvF5Ez4cdsrX86HU8VrvyIEordcwx9nI2kEXlsg+g0fvQ1bju9NYZaMKVp9eiDeOhHXuRQ==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(346002)(39860400002)(376002)(396003)(136003)(451199015)(46966006)(40470700004)(36840700001)(54906003)(2616005)(110136005)(26005)(8676002)(426003)(4326008)(47076005)(36756003)(41300700001)(86362001)(70206006)(7416002)(5660300002)(70586007)(316002)(7696005)(8936002)(36860700001)(6666004)(107886003)(40480700001)(336012)(16526019)(82740400003)(186003)(2906002)(356005)(7636003)(478600001)(82310400005)(40460700003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2022 15:22:26.5696
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: aabe2ab4-3c01-4f7b-c89c-08dab2aee54c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT055.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4198
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amcohen@nvidia.com>

Add support for 800Gbps speed to allow using 3ad mode with 800G devices.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Signed-off-by: Petr Machata <petrm@nvidia.com>
---
 drivers/net/bonding/bond_3ad.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/net/bonding/bond_3ad.c b/drivers/net/bonding/bond_3ad.c
index e58a1e0cadd2..455b555275f1 100644
--- a/drivers/net/bonding/bond_3ad.c
+++ b/drivers/net/bonding/bond_3ad.c
@@ -75,6 +75,7 @@ enum ad_link_speed_type {
 	AD_LINK_SPEED_100000MBPS,
 	AD_LINK_SPEED_200000MBPS,
 	AD_LINK_SPEED_400000MBPS,
+	AD_LINK_SPEED_800000MBPS,
 };
 
 /* compare MAC addresses */
@@ -251,6 +252,7 @@ static inline int __check_agg_selection_timer(struct port *port)
  *     %AD_LINK_SPEED_100000MBPS
  *     %AD_LINK_SPEED_200000MBPS
  *     %AD_LINK_SPEED_400000MBPS
+ *     %AD_LINK_SPEED_800000MBPS
  */
 static u16 __get_link_speed(struct port *port)
 {
@@ -326,6 +328,10 @@ static u16 __get_link_speed(struct port *port)
 			speed = AD_LINK_SPEED_400000MBPS;
 			break;
 
+		case SPEED_800000:
+			speed = AD_LINK_SPEED_800000MBPS;
+			break;
+
 		default:
 			/* unknown speed value from ethtool. shouldn't happen */
 			if (slave->speed != SPEED_UNKNOWN)
@@ -753,6 +759,9 @@ static u32 __get_agg_bandwidth(struct aggregator *aggregator)
 		case AD_LINK_SPEED_400000MBPS:
 			bandwidth = nports * 400000;
 			break;
+		case AD_LINK_SPEED_800000MBPS:
+			bandwidth = nports * 800000;
+			break;
 		default:
 			bandwidth = 0; /* to silence the compiler */
 		}
-- 
2.35.3


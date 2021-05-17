Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EF37383C0E
	for <lists+netdev@lfdr.de>; Mon, 17 May 2021 20:16:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244200AbhEQSRs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 May 2021 14:17:48 -0400
Received: from azhdrrw-ex01.nvidia.com ([20.51.104.162]:1787 "EHLO
        AZHDRRW-EX01.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239242AbhEQSRo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 May 2021 14:17:44 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.172)
 by mxs.oss.nvidia.com (10.13.234.36) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.858.12; Mon, 17 May 2021 11:16:27 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VXUkxUAX+D5Vsk8lYJclnC4g3d2aAwT4xew3AoG18yNxx8uvrugWYd8qyHyj/xKRkuX/84yPBI7zlw9BzkjsyV+C1QQeqhPKF18iYED/bMp5JXyZDaVMP6raKsr7vBsDCmTbSgH3zSz2IR8ThjlPnDG6SVukJ0ttjGKY2aCqyhXyUzUJjw2vC6Cr3MnsY7HQ/73y2jFtRO+M3ljyzTfg7ZTSDTXrKnvRXT0fz1s+3EmCGymIvpESjWv10ekaGSO+5DYXsltosqmqBG/Lv5vK+BWUhnNUTdXsniXY/+1CFkpsCikPK2Ywa98vxx8vQ//jhrn1oZ5lkLmeFle6DKJeFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GA9Tr6pM2ivNDORdm3IGg2SXWOfZuen93zMvMIa3WZE=;
 b=jJjN3QInjxckzc3bfzRpweOf3+Qh2GPGrWCxkwI32Ptg8nc8WxGJDp7l0LPWN57wG3yO3eFJQW9INDiGuhX67ws3M0KA1DgFWqrlAAoocX5sHpGwojqYYBtAUrBgXtNNZUGS04bQu24rsrYCCX6QwQm8q/v/UuNqqGqDRpLsIUzlha/Z/jIC4nLFrlr2QJmX3n05hokYzdeCvt2xsVn0tK7UjbTEWy3Fcpih6qyquA5KHb6hT7vmP1AH+gpH4AO5vVW76j37ohaHF0ZVY8Iu3fmv3+Fg296GzXMFFU/eOm0f37QINQ0kXhwo8+SGduPwIIkPa1es+HG5ru8dfuJpPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GA9Tr6pM2ivNDORdm3IGg2SXWOfZuen93zMvMIa3WZE=;
 b=M6W+JM6IQas0i2duDLtgIWfSUbyaC+ltht8FLNTPgjtf1uDAdN/HYYIDuiCKQ5AZ5dNWjjxxjpeIQTwhjZ632DyEVOUq+5xLSjRiogLfnkqFfnveW45sOLJ1ns4GIlSBu2PGne7M5SCd2mM0D34ZZzIzwOwBZxexb5EEG+7t5DmP4Ei92qc2pQ+chD9fJ+z96r6WQ+PoCaN5r8oAeZ94QtuE8QM4mU+Qy64WiCmYDYKsK49pG4wmlYagFyBFMyxvc/4RYgxtxKGsbWNZROeiSxuaYi4/nbvB1OtUFFMtlOD6SpmoaV7NFSVMMBr0PJ52a4yD9wdawlwjzbvOiQrqqQ==
Received: from BN8PR16CA0023.namprd16.prod.outlook.com (2603:10b6:408:4c::36)
 by MN2PR12MB4344.namprd12.prod.outlook.com (2603:10b6:208:26e::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.26; Mon, 17 May
 2021 18:16:26 +0000
Received: from BN8NAM11FT040.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:4c:cafe::59) by BN8PR16CA0023.outlook.office365.com
 (2603:10b6:408:4c::36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.25 via Frontend
 Transport; Mon, 17 May 2021 18:16:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT040.mail.protection.outlook.com (10.13.177.166) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4129.25 via Frontend Transport; Mon, 17 May 2021 18:16:26 +0000
Received: from shredder.mellanox.com (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 17 May
 2021 18:16:23 +0000
From:   Ido Schimmel <idosch@OSS.NVIDIA.COM>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <dsahern@gmail.com>,
        <petrm@OSS.NVIDIA.COM>, <roopa@OSS.NVIDIA.COM>,
        <nikolay@OSS.NVIDIA.COM>, <ssuryaextr@gmail.com>,
        <mlxsw@OSS.NVIDIA.COM>, Ido Schimmel <idosch@OSS.NVIDIA.COM>
Subject: [PATCH net-next 05/10] ipv6: Calculate multipath hash inside switch statement
Date:   Mon, 17 May 2021 21:15:21 +0300
Message-ID: <20210517181526.193786-6-idosch@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517181526.193786-1-idosch@nvidia.com>
References: <20210517181526.193786-1-idosch@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 61f81863-be20-446b-e9bc-08d9195fe2df
X-MS-TrafficTypeDiagnostic: MN2PR12MB4344:
X-Microsoft-Antispam-PRVS: <MN2PR12MB4344B9158A5A609E140E19C8B22D9@MN2PR12MB4344.namprd12.prod.outlook.com>
X-MS-Exchange-Transport-Forked: True
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: N9wUpZm4YglOeZ//L8IbqMmjER2k4THy/xFURgRMpe5MJEpRMYDi+MJ1FqW3GiLw3xmLs8YxmC1sFd7IIAx/bdGcB43t9CASeDoO7lGWR93LGoPAhFMMloWXD6mGesknK1GVUUDVsyJ2zB5/NGn06b5PUi+Sx7eVmNGOjvXpInVU2ORSgQO6xXZQ0gtmAi+QlFKiwqDC+mSlQngF0kcWIMG7iPl1jj2aQXbDagQu5KfvIwDtxTrrRBJopAEhhnEXzCKPBTdIxTUM3apGKgUTF/9qW8qozaeKfvGhlgk1REdbsJoqdSBB3jjxAuUreBI0/n8ZHLZb/9Q8h48JIwHhmnEB9w50U6tE8QfJk6WJhzMVMV4KAmH7+EK28srV7S2odouF3Q9QaqJ1UHuhXQmYsL0C/5QNSxFQNATWHLtMpm1TLlZUOK/eJWIP/QIaK6/n5WSYdpzgzvqsEiDsj57d+QuLFPSUT/T75cBnrv7s3wBAGUiOXI2i18dXZcnAK3xcvMajTZGS90O/H5nl3b/X+XUtvforpwG5KRNrWl5jKDTCTaRJ7x3FAWSnmodKHh5pjAbs6w7gu3pl5ZILNL9W+DFxjym73x82kTWqofOJUliH4LcOxeWzPnAN1A1Nq9vMQ+vRbOnzOnb9JjlCsCEROQ==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(136003)(396003)(376002)(39860400002)(346002)(46966006)(36840700001)(316002)(36906005)(5660300002)(107886003)(4326008)(1076003)(54906003)(36756003)(70206006)(16526019)(8676002)(70586007)(2616005)(426003)(336012)(6916009)(8936002)(186003)(26005)(86362001)(82740400003)(7636003)(47076005)(36860700001)(82310400003)(83380400001)(356005)(2906002)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 May 2021 18:16:26.6559
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 61f81863-be20-446b-e9bc-08d9195fe2df
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT040.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4344
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A subsequent patch will add another multipath hash policy where the
multipath hash is calculated directly by the policy specific code and
not outside of the switch statement.

Prepare for this change by moving the multipath hash calculation inside
the switch statement.

No functional changes intended.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 net/ipv6/route.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index a22822bdbf39..9935e18146e5 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -2331,7 +2331,7 @@ u32 rt6_multipath_hash(const struct net *net, const struct flowi6 *fl6,
 		       const struct sk_buff *skb, struct flow_keys *flkeys)
 {
 	struct flow_keys hash_keys;
-	u32 mhash;
+	u32 mhash = 0;
 
 	switch (ip6_multipath_hash_policy(net)) {
 	case 0:
@@ -2345,6 +2345,7 @@ u32 rt6_multipath_hash(const struct net *net, const struct flowi6 *fl6,
 			hash_keys.tags.flow_label = (__force u32)flowi6_get_flowlabel(fl6);
 			hash_keys.basic.ip_proto = fl6->flowi6_proto;
 		}
+		mhash = flow_hash_from_keys(&hash_keys);
 		break;
 	case 1:
 		if (skb) {
@@ -2376,6 +2377,7 @@ u32 rt6_multipath_hash(const struct net *net, const struct flowi6 *fl6,
 			hash_keys.ports.dst = fl6->fl6_dport;
 			hash_keys.basic.ip_proto = fl6->flowi6_proto;
 		}
+		mhash = flow_hash_from_keys(&hash_keys);
 		break;
 	case 2:
 		memset(&hash_keys, 0, sizeof(hash_keys));
@@ -2412,9 +2414,9 @@ u32 rt6_multipath_hash(const struct net *net, const struct flowi6 *fl6,
 			hash_keys.tags.flow_label = (__force u32)flowi6_get_flowlabel(fl6);
 			hash_keys.basic.ip_proto = fl6->flowi6_proto;
 		}
+		mhash = flow_hash_from_keys(&hash_keys);
 		break;
 	}
-	mhash = flow_hash_from_keys(&hash_keys);
 
 	return mhash >> 1;
 }
-- 
2.31.1


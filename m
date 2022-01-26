Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5487E49CA6B
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 14:11:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235024AbiAZNLG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 08:11:06 -0500
Received: from mail-dm6nam10on2068.outbound.protection.outlook.com ([40.107.93.68]:16481
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234995AbiAZNLE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Jan 2022 08:11:04 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T+An90OzFhm2mS1sbgip9i7jMlqwytty0jcpifx3Utpl1ida7Li2iVaIqb4DMCnWXHGfeUiiegUUrtAw+yXleZ5j9eRH9m3QKqBfPKYFmhstpp1lw9kGAocPSarVQadeNUQb6XYAOS5UBDTFGi+wJSp+Y0PLDoudR4/Wwk5obJRxWUt2QslVGrdNnIQmpBqgM3o3Nn57RPS7JKe0ek0XZ3ao+iIJ1ZplSSxvcLbYe/vBKsGwPf4JWhFmkQhsmnoUo0j92hfds+4/PGNL4PRTFaUtUxHsjWIyFJbfXlfvRVl6GDdfF0YhF7GT2tXMbLuw9adslP5/YrXAqnj8x0t+Pg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=17BXUWiIYguEMGJokIrCTOxccvtI2kyM8Bai3DCFDYQ=;
 b=UAnnIWrQnNdp7spNzsB4IRauqvepSbEjEhYTa53oVCz9ha+gi0twBU0ZfZ6p2uIJ5UE5OqmLyxnG0aBQ03O3v67FeThHB/sTlJHlrperbcXNFvBm8JuyTsGE+4DZZvLHkd5FzUy5tkQd6evNEx/WZ3x9Us39MQfqWcyu58wHqICuzsu6Uq+pEDaSmhVVPOsLvg3Wt9c5OBlzaOjRgQ1dT3wvsZd2hZH+POkZO+wW0b2FzkALZNI0grJK38Cs/3dRAZMvFJTc+Qs+ZKo3XWQXovsF02/MhQyIl8jlSVhp9lPMtiKfocAkFrLsgOQkOKqN7ReYWcclEx2K5S3dwzaQew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=17BXUWiIYguEMGJokIrCTOxccvtI2kyM8Bai3DCFDYQ=;
 b=OznK617Nr2luBli1ad7a5RwxE5IiAbmq0F3vASgKKmFyWe4haBo/UqUwJawcS/RdX8j4Ga3P23H0SrdW1qjZjlqdt1zYz1fQXnOEodhYRkzS9Vrmoij/YqDUx52HayXdu+Mf1uKCEsAyjPA8lsgGdc5P6ViG7qUxT2CenzoHEfQZUoO4Yp8mVgWNwHSDBoXgWoMidjeF7RxwFlAgcoqlax+8vP3ZNbNleU40Gif0Io7zbJmDBax/lfCT8BEGOe8Ugu9p9iVfXIopAwYLd9R44dUCz73OwkkI+s7lVkQ5o4+lDJjBo36oTIIrzi5yuDBUjxjj2/znguy3u4MAX65b4Q==
Received: from BN9PR03CA0802.namprd03.prod.outlook.com (2603:10b6:408:13f::27)
 by CY4PR12MB1846.namprd12.prod.outlook.com (2603:10b6:903:11b::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.12; Wed, 26 Jan
 2022 13:11:02 +0000
Received: from BN8NAM11FT035.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:13f:cafe::a1) by BN9PR03CA0802.outlook.office365.com
 (2603:10b6:408:13f::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.17 via Frontend
 Transport; Wed, 26 Jan 2022 13:11:02 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.234) by
 BN8NAM11FT035.mail.protection.outlook.com (10.13.177.116) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4930.15 via Frontend Transport; Wed, 26 Jan 2022 13:11:02 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 26 Jan
 2022 13:11:00 +0000
Received: from debil.mellanox.com (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Wed, 26 Jan 2022
 05:10:56 -0800
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>,
        <bridge@lists.linux-foundation.org>, <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Benjamin Poirier <bpoirier@nvidia.com>
Subject: [PATCH net] net: bridge: vlan: fix single net device option dumping
Date:   Wed, 26 Jan 2022 15:10:25 +0200
Message-ID: <20220126131025.2500274-1-nikolay@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <YfC37T23elbsAD0R@d3>
References: <YfC37T23elbsAD0R@d3>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: drhqmail202.nvidia.com (10.126.190.181) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d41208d2-903b-4039-5ca0-08d9e0cd4d72
X-MS-TrafficTypeDiagnostic: CY4PR12MB1846:EE_
X-Microsoft-Antispam-PRVS: <CY4PR12MB1846CC0E31793274E5C7A76FDF209@CY4PR12MB1846.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fao+ENjsKGvgynn0Pl4ywvcN82GYsSQtJc3VMBR4qAzik/XdPtP4M3fwnInT/QGsXJ2BVYREcX3Odz8Z7SZf5h+vfyYuKku3eWEubtgFHzCwGo+8FSZF7U8Ep46VEHR3Ax/nTbR+d0UB3q1FxT/2SLRZ77NE9veMQnD4m0CKSSwCDMqMcm15aBH4+jNxXOTaamc+ZLMbu758VXaK5YtI71+CX6CuOmOS3jJaH5Av6+LHR8owHo45CEycIhOmEcH3uO9TYT0pUE7W4wiYuV+ovnBr2MIXIgnO3/i9mAe5eaDv5YdnRTjBD9FwMxBsElCEGNIZY3PiKIyftBrfvR3eR62Hx/66JL2rXu7SsvM5OCJoUq0blNC/Zg2yPx9Jyg39hh3LpSRT/u774fJof8H95oURR+cHnnJX7f+7iYVlPPti8jzPzBOEDB6YIj2qyXeXSdw9uOSGg/geczfqNTufYist5+GqCWmAWM/wQtSeqekMJXMhwWVnrnljwV+j2r5UJwQPM08+IXd/ELZQPWEeOvOxBQFsLJKIzWR4zZl6FNpCHP1OEgGDrD7bvkv2+e9nMWRH3/h9nWNBCsyKLcc2PqsTxBeGUembiPHGNJA25PF3o+S3cZjo129mI8JpZqP6SCQOiS5g41NzNKPdHffzMVG7VWmlPZycsFchMHcL5Q1N1/rB6A0JG9cFL+VxZKqcLtM05Wq7N+1TF/ahvlLZlJvQrbBwtGbZGovympz7vCZYNkup4p2T2dnXCF64FSF4ZPbEKA6a7zG3rKsJP5Ac4rGQyr9daVyrJU0KHvC5alM=
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(4636009)(40470700004)(36840700001)(46966006)(316002)(107886003)(4326008)(54906003)(356005)(86362001)(40460700003)(36756003)(81166007)(8936002)(426003)(82310400004)(336012)(6666004)(70586007)(8676002)(47076005)(508600001)(16526019)(36860700001)(2906002)(186003)(26005)(70206006)(5660300002)(83380400001)(2616005)(6916009)(1076003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2022 13:11:02.0175
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d41208d2-903b-4039-5ca0-08d9e0cd4d72
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT035.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1846
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When dumping vlan options for a single net device we send the same
entries infinitely because user-space expects a 0 return at the end but
we keep returning skb->len and restarting the dump on retry. Fix it by
returning the value from br_vlan_dump_dev() if it completed or there was
an error. The only case that must return skb->len is when the dump was
incomplete and needs to continue (-EMSGSIZE).

Reported-by: Benjamin Poirier <bpoirier@nvidia.com>
Fixes: 8dcea187088b ("net: bridge: vlan: add rtm definitions and dump support")
Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
---
 net/bridge/br_vlan.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/bridge/br_vlan.c b/net/bridge/br_vlan.c
index 84ba456a78cc..43201260e37b 100644
--- a/net/bridge/br_vlan.c
+++ b/net/bridge/br_vlan.c
@@ -2020,7 +2020,8 @@ static int br_vlan_rtm_dump(struct sk_buff *skb, struct netlink_callback *cb)
 			goto out_err;
 		}
 		err = br_vlan_dump_dev(dev, skb, cb, dump_flags);
-		if (err && err != -EMSGSIZE)
+		/* if the dump completed without an error we return 0 here */
+		if (err != -EMSGSIZE)
 			goto out_err;
 	} else {
 		for_each_netdev_rcu(net, dev) {
-- 
2.34.1


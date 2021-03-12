Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 917743393E7
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 17:52:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232653AbhCLQvt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 11:51:49 -0500
Received: from mail-bn7nam10on2061.outbound.protection.outlook.com ([40.107.92.61]:45633
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231597AbhCLQvZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Mar 2021 11:51:25 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U6penWJhPzBTiZo05LIdvGSkp4+CsMFFfPUuvMVmuT/PWz0PaX2s4WLxg83i0l74KkQpAkIF0NbA2vTAxRwbOrUklZyf4KOcgqHrcPMqrdRlC06OX71CeunoA3RNvPcNCC+ExmWT7V/mYLlMbevXfmDOgoVfrsbeqcdoIT5l4fAVng414DTIhqE4Dsj+QabQWT8Tr+d5wZVaHuP5BaT4v7xwjDWE+7lLrqq6v8bu0HQxzx/Y5nKzCJ6skp0IFlcriba65VkzK5jjTTNn413GYzWYVMwWhqFjPkg6NHYcpc9hLafXUjRODGY2erZ9qQ+xR4OpnDWYhgBgXZ+/2Y5SsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1pBiwSJ2h6Aa5/9ZhM5NVHiRBNDHI2IgNZzvDn12uJI=;
 b=Ihy9MM+Zu7mS5C/FhDRMHrPVTXbIWQUPsxga9kvEwWAv0+OSzY+gkE2wHoHZXaG1f70XctdQ2Fb6yX70hn1JUZdMjnO6SCazyCr0xpADojEz3IcPtmYfuPc/qeNV8CtCwd7nI4TAvgsR9s5CPpNVRovNGBilrgEzbHfco313OINQLRhYFJ0WwFUtSO0NBhUn5m9dYdGXEOGd56zW1+0CjeYi1Q4PKGFqclrQga6rGMIthE3NEoEzvdLOXn4mDLRGCSoylv4x/k7XPZ678p+a5kPiWr2t5wLmbO3YThg3T8GVxNLSaEsLFIudqPnGxc+8cHcwYP5ngmlG+Df0ys+26g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1pBiwSJ2h6Aa5/9ZhM5NVHiRBNDHI2IgNZzvDn12uJI=;
 b=LoFNcLLt8UlSmQVccskHc+95WJbpG6+Hv4+0rxpMr42k79QRWYI7NH6HAbmilgFh9W7Kfz7+SUPwhPa0sEElfQANrFqAPpHt8QUjE0Ikmobx3khilGRQh3PqBLuRdEWpIRfMLu4s71C0ve655reG+Jxn2/USAQi1ZOssBaOJ/NtbblDvbqGDJOyoXV6RG8y7mE6/4hUrLUp476p5LvlcWPMc9YFhXgRnolnSOTsIz3BGY8K6F3WYrN1UEz7wEGYVmBqxDYQCqDiJ6P8yJZ/CYximAmV8yAQuBDP5EsTBwjOJxKBve343lpoecjs3Xee/NK7kEF5bEpz+IGN+mexWUA==
Received: from DM5PR04CA0035.namprd04.prod.outlook.com (2603:10b6:3:12b::21)
 by BN9PR12MB5210.namprd12.prod.outlook.com (2603:10b6:408:11b::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.8; Fri, 12 Mar
 2021 16:51:23 +0000
Received: from DM6NAM11FT036.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:12b:cafe::b) by DM5PR04CA0035.outlook.office365.com
 (2603:10b6:3:12b::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend
 Transport; Fri, 12 Mar 2021 16:51:23 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT036.mail.protection.outlook.com (10.13.172.64) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3933.31 via Frontend Transport; Fri, 12 Mar 2021 16:51:23 +0000
Received: from localhost.localdomain (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 12 Mar
 2021 16:51:18 +0000
From:   Petr Machata <petrm@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     Ido Schimmel <idosch@nvidia.com>, David Ahern <dsahern@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Petr Machata" <petrm@nvidia.com>
Subject: [PATCH net-next 02/10] netdevsim: Create a helper for setting nexthop hardware flags
Date:   Fri, 12 Mar 2021 17:50:18 +0100
Message-ID: <165107c301e027fcc515f103cd8881fd1484c62e.1615563035.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <cover.1615563035.git.petrm@nvidia.com>
References: <cover.1615563035.git.petrm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fa38da76-a49a-4589-ada7-08d8e57711b6
X-MS-TrafficTypeDiagnostic: BN9PR12MB5210:
X-Microsoft-Antispam-PRVS: <BN9PR12MB52109EA140D5933BC6B4D779D66F9@BN9PR12MB5210.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:334;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2FmswdJs5DBqTwYuUJaxS4W1RHtoZW9uQMmsYE1nVs9I2WbYTjcZvE5bW5ef+EjqsgUSHCd3uf6QG2xvpKIdnutVMtpJLs0gCVIFoY3TcEzsMzB91gLzcizqUBL8A+560PXb7IkamjCzls7U6d0QqSGD3vQLJdbfDBPts8vAgIEGE8+sodmYh0x/LfK9/I9d8ZegLoog3Z6RaO87TP1AHdU6sLNhvGXYudy5lajj6MW9P9svoeMKME8u3+9Jt1Wa/R+Rv3kNQ/yl6XcLjc40/3QtxkS1wz0KNcrwaF2/HGONhw/qIf4VfWfUw0zLg0ktvZjVjoD9DcqjtOjlLdKpzFqR/9BjnzUR5suQbnCutMBiZBCDGZalZphFgOrQxazXyPNgKwbSMsZWnHNjFDVRmJsKgek0Frb2tmeLeVDYT0SeO1coiQiFBeEdaQkUwPVTETN0r1g7h6bMYcWRkJrbJLkv6BHCj3/Wf/qf3SZxgkKt8mWoPgdSl/GIWYIYSXThdyeMr0u9allHFKvev57NVERMnQR60m1bMWlUdSXt5I30td1IjU1Jbb12m91PKCn71xgJaiHkByp4zcO4o95qMhL4aa01wD+50/iOcrm/vCytT1Q4jJyzwF360B9WpecJ6WyDbCq3ojSXpg/WIiYqRYZj/06/dOS3ofutS0uwNw6wTKyQaE1gkMwvh5ONw19X
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(396003)(376002)(346002)(136003)(39860400002)(46966006)(36840700001)(8936002)(7636003)(82740400003)(426003)(356005)(478600001)(107886003)(70586007)(34020700004)(336012)(36756003)(82310400003)(316002)(16526019)(6916009)(36906005)(70206006)(4326008)(26005)(8676002)(47076005)(186003)(2906002)(2616005)(5660300002)(83380400001)(54906003)(86362001)(36860700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Mar 2021 16:51:23.2809
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fa38da76-a49a-4589-ada7-08d8e57711b6
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT036.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5210
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Instead of calling nexthop_set_hw_flags(), call a helper. It will be
used to also set nexthop bucket flags in a subsequent patch.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Petr Machata <petrm@nvidia.com>
---
 drivers/net/netdevsim/fib.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/net/netdevsim/fib.c b/drivers/net/netdevsim/fib.c
index ba577e20b1a1..62cbd716383c 100644
--- a/drivers/net/netdevsim/fib.c
+++ b/drivers/net/netdevsim/fib.c
@@ -1157,6 +1157,13 @@ static int nsim_nexthop_account(struct nsim_fib_data *data, u64 occ,
 
 }
 
+static void nsim_nexthop_hw_flags_set(struct net *net,
+				      const struct nsim_nexthop *nexthop,
+				      bool trap)
+{
+	nexthop_set_hw_flags(net, nexthop->id, false, trap);
+}
+
 static int nsim_nexthop_add(struct nsim_fib_data *data,
 			    struct nsim_nexthop *nexthop,
 			    struct netlink_ext_ack *extack)
@@ -1175,7 +1182,7 @@ static int nsim_nexthop_add(struct nsim_fib_data *data,
 		goto err_nexthop_dismiss;
 	}
 
-	nexthop_set_hw_flags(net, nexthop->id, false, true);
+	nsim_nexthop_hw_flags_set(net, nexthop, true);
 
 	return 0;
 
@@ -1204,7 +1211,7 @@ static int nsim_nexthop_replace(struct nsim_fib_data *data,
 		goto err_nexthop_dismiss;
 	}
 
-	nexthop_set_hw_flags(net, nexthop->id, false, true);
+	nsim_nexthop_hw_flags_set(net, nexthop, true);
 	nsim_nexthop_account(data, nexthop_old->occ, false, extack);
 	nsim_nexthop_destroy(nexthop_old);
 
@@ -1286,7 +1293,7 @@ static void nsim_nexthop_free(void *ptr, void *arg)
 	struct net *net;
 
 	net = devlink_net(data->devlink);
-	nexthop_set_hw_flags(net, nexthop->id, false, false);
+	nsim_nexthop_hw_flags_set(net, nexthop, false);
 	nsim_nexthop_account(data, nexthop->occ, false, NULL);
 	nsim_nexthop_destroy(nexthop);
 }
-- 
2.26.2


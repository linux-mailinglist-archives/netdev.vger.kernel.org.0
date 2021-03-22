Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55C40344250
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 13:40:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231676AbhCVMkW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 08:40:22 -0400
Received: from mail-bn7nam10on2044.outbound.protection.outlook.com ([40.107.92.44]:9889
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231181AbhCVMiz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Mar 2021 08:38:55 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kAUC5KnVfIl12DSpEsENEcfDrWeaDv6Fu7r/RAdj4m+C0q9UXyzvViDX9CwisOSWNOI8PgviMABGCL0IIIcPxPMNizAc0lrSgIyyYKOrK6IH8zaharnxCmYENYeMBNB25RrdNUObSsJYZIKwU+QXa5zoTU1G0yENSLoj4/n32kxYpSKENwL2hXBCDVIKnLJXOw8SKLnGrfcqyv6NclZnEhjCLVB06gyjMHqrjGzgAtsP2zuOKrGfZ7g2KhPM/Q5v0AoXC4KnKpRmjYsbuseJRXGemmlBw4NKX49qqHl1cQTPKncILLDx2+7tv+/ox1QNyty9xfEWkolWkb2dyjyJhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XLQc4SuSbpmKSn5iGZYW6X0ywu+BLplR7xJsRilWmSA=;
 b=I2xZyl4xqnGIE5g0iDZH3Fh7N2WD4JvlJbRbFzfpqJdgKfjS0SE1Bz+Fl7ZrzCv+o1Q7lZX60EVc4z99JQccfAQNPZU4wjIUYi1xX5H0B22BrBMbuSuhe1H8rALA4LVMEq33dHHPzw3opLWaNIIFZVNLzxgHVmJZmtzQULK8FzlnFrANdaPn9kUYH3OBTpHCn4EMcspTMc6BxLJrwszEt4vD4WGiaVW6m+xns43CYDHgoKg1JY+18xCarfoCN+XSWLljRnosjVT3vKv54G7AeH9lVHqLq2+9CQIp8liHUDaFpV9ArGbJBemDkOVmJCz6DCSWAF68ngGpaOB2V101JA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XLQc4SuSbpmKSn5iGZYW6X0ywu+BLplR7xJsRilWmSA=;
 b=Q+v8fTN1w2kslgk/8qyaqk41UCW5Ui9OYK9XlWSTIcomw7Q2oRsxCVLDnucvRqwOPU1AJe9f3UgEa+5TlHd4/DmGqNPD5BZViiDWKrHmYQHQxrxX7MiZsvRfWmVaNlgSqZrDX6kTibaNkO+oXva8K4p5p+8mrNj0bzCmySfpBNlJiI4d3urBb1Q1NBW/N1sXTs8y8vFSk3myXZ0ak4BFJUG5UX00W2UNKVhip4UZj9qfgT/viIi6+t8397PQ3OkJMMfJ7Y/WJvbd3IfngCRr3ueC/D+betVBkboS509JIlViEEOpWcJ4t0MjhufR7udBrp8djuotj4yaR6Q/jdXeaw==
Received: from BN9PR03CA0957.namprd03.prod.outlook.com (2603:10b6:408:108::32)
 by BN6PR12MB1905.namprd12.prod.outlook.com (2603:10b6:404:fe::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18; Mon, 22 Mar
 2021 12:38:54 +0000
Received: from BN8NAM11FT060.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:108:cafe::20) by BN9PR03CA0957.outlook.office365.com
 (2603:10b6:408:108::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18 via Frontend
 Transport; Mon, 22 Mar 2021 12:38:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT060.mail.protection.outlook.com (10.13.177.211) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3955.18 via Frontend Transport; Mon, 22 Mar 2021 12:38:54 +0000
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 22 Mar
 2021 12:38:53 +0000
Received: from vdi.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 22 Mar 2021 12:38:50 +0000
From:   Maxim Mikityanskiy <maximmi@nvidia.com>
To:     Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Mahesh Bandewar <maheshb@google.com>,
        Nikolay Aleksandrov <nikolay@redhat.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Tariq Toukan <tariqt@nvidia.com>, <netdev@vger.kernel.org>,
        "Maxim Mikityanskiy" <maximmi@nvidia.com>
Subject: [RFC PATCH net] bonding: Work around lockdep_is_held false positives
Date:   Mon, 22 Mar 2021 14:38:46 +0200
Message-ID: <20210322123846.3024549-1-maximmi@nvidia.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bbb6c46b-cd81-4820-d744-08d8ed2f7455
X-MS-TrafficTypeDiagnostic: BN6PR12MB1905:
X-Microsoft-Antispam-PRVS: <BN6PR12MB190507223FDAB469403DA817DC659@BN6PR12MB1905.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WLlZjWDcX6sf/mBCzey0L+hzi0ReTU28vLb4q53hAPy8Y0aUZZvALJ9r3OPPHfQnMW5U8eLMtJcPwfJA1japxkewWHErSkiQUe3Vg2twDVo8XuYDeB7WFGCqlLOlPRVHogNXAdGQu/bU/SIB99vE7yK1omQuuQdFk4nvvJ3w3kWvzCXiRG+sLXdZa6DIVEq4VsMmrE9YXf3AFvFXtLSyXJm2KfiKCQ234d7Ihar/x369x1y0D9EO5vVIVSUAUON413MIfQ4OSxpZxi79NWnuE5Hdp/KZ6w3F2HGydxdjNloB4lk6U4mbw0RcOmPguz7x4agQ5UO1V8fcYBcy2Ni2AslT8axoaqFEvtgUHxYustgdXk83VqBFylkHjPKt+Eaa1LUbc7+41lc8xle0ATqDVgLxRYcQjuP+7blQF/6w8L9W3eXA8ZLSOJ1RNhpEmHiPzyiJb3RpjYwV+7XbFBmBA668676Q7tAQOtcxGRqKLSUCPVKQUWe2ELKjIexnxYkjm6JAFI02I50dvHsypDfdVkdmRwWNwOf1aWWduC38/GaJJeuReHk0gpYs2xK2CeIhgNV3izX3ZluKOCAxV5hCWtROeBXk/DBBJRqkWTQ3lt1rjeIq3a+Y7A08oxkUy0dQXq5Zc7ROchlx+VflUYD4+3W2cpCeyCLTbNsUxD6Vszk=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(396003)(346002)(39860400002)(136003)(376002)(46966006)(36840700001)(82740400003)(110136005)(54906003)(1076003)(2616005)(2906002)(478600001)(107886003)(36860700001)(36906005)(83380400001)(5660300002)(316002)(356005)(7636003)(8676002)(4326008)(70586007)(47076005)(82310400003)(86362001)(186003)(36756003)(426003)(26005)(6666004)(7696005)(336012)(70206006)(8936002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Mar 2021 12:38:54.2334
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bbb6c46b-cd81-4820-d744-08d8ed2f7455
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT060.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR12MB1905
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After lockdep gets triggered for the first time, it gets disabled, and
lockdep_enabled() will return false. It will affect lockdep_is_held(),
which will start returning true all the time. Normally, it just disables
checks that expect a lock to be held. However, the bonding code checks
that a lock is NOT held, which triggers a false positive in WARN_ON.

This commit addresses the issue by replacing lockdep_is_held with
spin_is_locked, which should have the same effect, but without suffering
from disabling lockdep.

Fixes: ee6377147409 ("bonding: Simplify the xmit function for modes that use xmit_hash")
Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
---
While this patch works around the issue, I would like to discuss better
options. Another straightforward approach is to extend lockdep API with
lockdep_is_not_held(), which will be basically !lockdep_is_held() when
lockdep is enabled, but will return true when !lockdep_enabled().

However, there is no reliable way to check that some lock is not held
without taking it ourselves (because the lock may be taken by another
thread after the check). Could someone explain why this code tries to
make this check? Maybe we could figure out some better way to achieve
the original goal.

 drivers/net/bonding/bond_main.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 74cbbb22470b..b2fe4e93cb8e 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -4391,9 +4391,7 @@ int bond_update_slave_arr(struct bonding *bond, struct slave *skipslave)
 	int agg_id = 0;
 	int ret = 0;
 
-#ifdef CONFIG_LOCKDEP
-	WARN_ON(lockdep_is_held(&bond->mode_lock));
-#endif
+	WARN_ON(spin_is_locked(&bond->mode_lock));
 
 	usable_slaves = kzalloc(struct_size(usable_slaves, arr,
 					    bond->slave_cnt), GFP_KERNEL);
-- 
2.25.1


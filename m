Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62CE03B1B6D
	for <lists+netdev@lfdr.de>; Wed, 23 Jun 2021 15:43:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231153AbhFWNpz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Jun 2021 09:45:55 -0400
Received: from mail-bn1nam07on2057.outbound.protection.outlook.com ([40.107.212.57]:11143
        "EHLO NAM02-BN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231209AbhFWNpp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Jun 2021 09:45:45 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DGRS1ytgs2mE3mLw92QgzXhoPZge00HfC01q5o9X0B7+lz+6BHUU3Otsz0qXj7iYWt5UWy3LuFp/EZPReERBTllQlWmuvF1w6hGwv1Pv5K35O6/ydB5H1I7Z3PV9ts0+MZWgEmW6zQxWS6UNYCmYWq1eL3qSrERP0pN7EY+MreqLTP2V/sNoetCWllioe9ePx/Hl86NE6Qh6wwUYqw3Hkiyp0GFOM+W56iYk2vUP6DG+Soz5qRBEJT1ilGH7VfgamUt0MMoS4vebg4Q796ftfV4OxADZQgca9KlARxqfCQLXawxOlaUKp462SqGfijHbVK48G+iJFbLh6TGVe6Pfhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=74qUbhn9H8Ql2jWOi112DyTyr79jLQl30D87ZqL8HJ4=;
 b=mrkihIkv2RZOfp2KtzfNtRU9EktpizpeiRoPMLL65La5+DqfZ89gZ1pUUWCg2kUtHRXqGgZpe4Zud7F/xAR7KInZ5xmYbS26UAMIVYtwh8c0fkweeT49hNQjW4UxAPh/g5PSEb+eVjLu7+PGcirZ2gEXZ6w9pCyNS411nSBAUk0YJOvcJHYKMPzNzOks9+syRFKF+XLc2Qx3ILhSRdoIpthKddf/UqbCNBDkfsDN6i44yr/rhzPHyBA9kiQZeM/Ijy5tLyl7xzf0m5BLCSc5Vhm/PmY+Q/zUq0uby3xQsYeEm2j8oAbVgWm5R7V8a7XoLu5IM5kOqFL48Xhzuon9qA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.36) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=74qUbhn9H8Ql2jWOi112DyTyr79jLQl30D87ZqL8HJ4=;
 b=bpxYELmkCxVH+RQ4rM5EXe+7OCLvpQE5bhx1T5oS8r7kBiiMxtbsKavvZ4PWIEjWARQNGP8m/nLZIEIc6jFzhTTR6GADg/qhYhbeXTCwZlYf5yJQ42NEX+zSbSulAXQ9SVjG5s7fAz4iJZzzbW5xgUYpZfADDPLOsJRYNosSelEGObGL7k/8m9gRlgQzjNTSOAbJw+LaqWms6fNEmim4Jvn5Dg+2wG8suDt8W0E+FxrcAoum1ZIHhmoEpFCks6j2BL9gscepdYHi8S7dCdnqqGlFPpy7GiY+77/YY9klpFzudzsvzVEqDCq9HgiWIz2UB9dL1dbV2S7nb+ekuUBmPw==
Received: from MW4PR03CA0164.namprd03.prod.outlook.com (2603:10b6:303:8d::19)
 by MN2PR12MB3759.namprd12.prod.outlook.com (2603:10b6:208:163::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.19; Wed, 23 Jun
 2021 13:43:26 +0000
Received: from CO1NAM11FT047.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:8d:cafe::8d) by MW4PR03CA0164.outlook.office365.com
 (2603:10b6:303:8d::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.18 via Frontend
 Transport; Wed, 23 Jun 2021 13:43:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.36)
 smtp.mailfrom=nvidia.com; kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.36 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.36; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.36) by
 CO1NAM11FT047.mail.protection.outlook.com (10.13.174.132) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4264.18 via Frontend Transport; Wed, 23 Jun 2021 13:43:26 +0000
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 23 Jun
 2021 13:43:25 +0000
Received: from vdi.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 23 Jun 2021 13:43:23 +0000
From:   <dlinkin@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <jiri@nvidia.com>,
        <parav@nvidia.com>, <vladbu@nvidia.com>,
        Dmytro Linkin <dlinkin@nvidia.com>
Subject: [PATCH net-next 3/3] devlink: Protect rate list with lock while switching modes
Date:   Wed, 23 Jun 2021 16:43:15 +0300
Message-ID: <1624455795-5160-4-git-send-email-dlinkin@nvidia.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1624455795-5160-1-git-send-email-dlinkin@nvidia.com>
References: <1624455795-5160-1-git-send-email-dlinkin@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 25338f63-6cac-4136-682b-08d9364ce0a1
X-MS-TrafficTypeDiagnostic: MN2PR12MB3759:
X-Microsoft-Antispam-PRVS: <MN2PR12MB3759386C996AC97640E35B4ACB089@MN2PR12MB3759.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1468;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7oiJfCokiaNxJCt0PALf8hPcq55sSIfZHXABBScf1smYKqyOkCn+JpvIRIFu4t+cBr0j5HHm6fhZXU+nSYb32Urs7uUyKnwJjWvsXVFZ8tjuAhL+fK78zyIJi8G/gnORfFGevAtQpJIZlJKwM0UvO4Ag+4fJYL9ZkT2hag0vL3GN1pN5Eo6dSNrKmYrX/1gTyTxT0BfLLUkcGAAtXI9d1Wq1SncEoIgx018YxJYZb0YoWnum6UV3U3K3FGLjjDAs6rXPB4sFE2E4NFlJjNfZqw3IPj/hYoRsyjqGg2qr2CPCr5veycuV31JO3Ni6anRb1jk9Hbz8eruv6uMQwSfzcIxjE3ZIaf/KfW8ZUkggYf7k/iKkaKi9G97je5ktAkTK/thDAla1czjqqwEjoOeS+LvB5kuLGGSbhjMDGa5/YOH7cNGjFG/92r3kAsuHLWMni24e1hQobIq5bfiD6KjD9/2loDBv5UouhSe5CbysD/VKJsYZafx+5X//MQQAcxQdAysH/NrgaK29jpB5lVxsn4IeKHQEzcKyO/vrmvvf0rW9nLjPAZOEhgKSYKrao+nHEziaEvEZgRpH7+nBFAgkVGyufFjiOs7WOo6aEOuhmA84iPhuXMhcwGne7Y+e0ZiCh0e2KQGAfAtzfbKV5R6cz2w2smyBISUbzB+ySmM/vU4=
X-Forefront-Antispam-Report: CIP:216.228.112.36;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid05.nvidia.com;CAT:NONE;SFS:(4636009)(376002)(39860400002)(396003)(136003)(346002)(36840700001)(46966006)(47076005)(86362001)(426003)(5660300002)(36906005)(336012)(316002)(36756003)(2876002)(7696005)(107886003)(4326008)(8676002)(26005)(2616005)(186003)(82740400003)(8936002)(6666004)(2906002)(70586007)(356005)(6916009)(478600001)(70206006)(82310400003)(36860700001)(54906003)(83380400001)(7636003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jun 2021 13:43:26.1096
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 25338f63-6cac-4136-682b-08d9364ce0a1
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.36];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT047.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3759
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dmytro Linkin <dlinkin@nvidia.com>

Devlink eswitch set command doesn't hold devlink->lock, which makes
possible race condition between rate list traversing and others devlink
rate KAPI calls, like devlink_rate_nodes_destroy().
Hold devlink lock while traversing the list.

Fixes: a8ecb93ef03d ("devlink: Introduce rate nodes")
Signed-off-by: Dmytro Linkin <dlinkin@nvidia.com>
Reviewed-by: Parav Pandit <parav@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
---
 net/core/devlink.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index 153d432..8fdd04f 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -2710,11 +2710,15 @@ static int devlink_rate_nodes_check(struct devlink *devlink, u16 mode,
 {
 	struct devlink_rate *devlink_rate;
 
+	/* Take the lock to sync with devlink_rate_nodes_destroy() */
+	mutex_lock(&devlink->lock);
 	list_for_each_entry(devlink_rate, &devlink->rate_list, list)
 		if (devlink_rate_is_node(devlink_rate)) {
+			mutex_unlock(&devlink->lock);
 			NL_SET_ERR_MSG_MOD(extack, "Rate node(s) exists.");
 			return -EBUSY;
 		}
+	mutex_unlock(&devlink->lock);
 	return 0;
 }
 
-- 
1.8.3.1


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CA8A3B1B6A
	for <lists+netdev@lfdr.de>; Wed, 23 Jun 2021 15:43:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231224AbhFWNpp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Jun 2021 09:45:45 -0400
Received: from mail-bn8nam11on2056.outbound.protection.outlook.com ([40.107.236.56]:54240
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230464AbhFWNpl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Jun 2021 09:45:41 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VEswaknKXzUjkDpxU6PCvuDeI8JPevkh2PVxbKfeRQ6+Va12XB5BNWwL6zXwARC0qNcLsPH9W5MZzTGZ/+GcvGL1cXBlmSA5jEzIr6zEXnTICDdfp7TDOls1MzG8NyFXg+NGRkXTF2Q1JQ/g46DcoxkcoAAytVn5VC+HzNlQJPHAjiS649S3eNRyihYepUnP2+hc1jB4fK/Gt4a5RSPE+fHISF/0+M/bYP76qgExiOmd8oqrDDZ0YPCZaoCR6h6cHKxpD/DZ8XKurv0ar6WlvQGCERKwzvixpGkdCkMEs81h6gVopnqufhJxamB5c6qgmID4s5KRlSMeln91gZDrCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tojI/rD7s0IZUvNhlezGb+Yb1jI3Vhnrg2yFoWY0bAY=;
 b=kvQy3YwFCYOSrRkkUBlSjIL+z74stJQxuFIXZRPEJj8dXoUnXe34aEV2Hs5/t2sMStGdxOU0f00/ZPItpDTSqKMY4BjrXHlk7E6LCUEBBVns7lL0JwKz267aAXmoPgs2Ds8bc+LKflXlXcsk4Sgt3D5HbuLas96SgqTIiMtJ6UZrxCIy/NDPPWqq+ISjH/yOqMltSQSSYIhNfpOU7zAl9aS6qNLWHYOChz4eC2KeI3tPoKsMqESKNHHqo96H5tieXZcUFbh3/bcHAXC4YghRhmxKHT6OMU483ncrJChy4n8jzZN1hCqwdEDIIPESryMFZZslEhQdngyeSUPgBpkefg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tojI/rD7s0IZUvNhlezGb+Yb1jI3Vhnrg2yFoWY0bAY=;
 b=GOXWuX/sdhEksnNon1kvsx9dqcYnd+D5Aju8vwkcfPgmJgMqpxGMiKz+BjSuWCJopCMo4g3g2mryNzR3dYOk0BkTNKNgBDEPfQtrpuDsw6iw9V26n5e4ZvlMlmNWs1XgW87y7CFl9PDiBAvY4xFIp1WeyAGdN3BNZRWxIMgIRIw/r0gGMnMxKtR9pUd2x6n0CT9SWHGy/+o6vKRfJy3wLPyjUvZwDFmtJhz7mD3K8DOFfHmVqW+KZlw6Suyley+UDR6fONEstnloQBY67AdMcMdE2Clkf219ShxdizcKHocSWkH8FJIp7FYgYKLP4vqQgOgFQMD6klCM56fPSyfK5Q==
Received: from DM5PR15CA0040.namprd15.prod.outlook.com (2603:10b6:4:4b::26) by
 CH0PR12MB5026.namprd12.prod.outlook.com (2603:10b6:610:e1::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4242.21; Wed, 23 Jun 2021 13:43:21 +0000
Received: from DM6NAM11FT011.eop-nam11.prod.protection.outlook.com
 (2603:10b6:4:4b:cafe::3d) by DM5PR15CA0040.outlook.office365.com
 (2603:10b6:4:4b::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.18 via Frontend
 Transport; Wed, 23 Jun 2021 13:43:21 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT011.mail.protection.outlook.com (10.13.172.108) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4264.18 via Frontend Transport; Wed, 23 Jun 2021 13:43:21 +0000
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 23 Jun
 2021 13:43:21 +0000
Received: from vdi.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 23 Jun 2021 13:43:19 +0000
From:   <dlinkin@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <jiri@nvidia.com>,
        <parav@nvidia.com>, <vladbu@nvidia.com>,
        Dmytro Linkin <dlinkin@nvidia.com>
Subject: [PATCH net-next 1/3] devlink: Decrease refcnt of parent rate object on leaf destroy
Date:   Wed, 23 Jun 2021 16:43:13 +0300
Message-ID: <1624455795-5160-2-git-send-email-dlinkin@nvidia.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1624455795-5160-1-git-send-email-dlinkin@nvidia.com>
References: <1624455795-5160-1-git-send-email-dlinkin@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 80128804-e6ba-4c36-e494-08d9364cddd8
X-MS-TrafficTypeDiagnostic: CH0PR12MB5026:
X-Microsoft-Antispam-PRVS: <CH0PR12MB50262EE204586EE68920E031CB089@CH0PR12MB5026.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2150;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aX+V1mNRv8WIcaqwZs3jBIBHKokLFCjeaHs/ikcy4JRG5eEUe/v05EtYcRDOae4o43egTSnDFGBgEXcUki/3vQcKqCKvw/BiUrB0vRZ/cY6hpG/5/cDfQUZIZluZGEywGyNBROSvzGxpfBSZ4MSG4WouU1KeKCvu90/YESmQxwv/w+XxfKyCXLWTaKFXYRH3On/JE0YgNBhQien5eyfuUZE1nyqNZvVaytkiLvxLR6zKUNXbc5baUCvXmGEerwBBAQPu5cBTWICUXy2VThdaQ6zxqs3fGWPO1Vo2TuCQSrt+Xg9CjvCNKp7cJLsITH6caVsbWafGfmlryvnvpWPrI+IOUj564ijbUvf18goSsylF/r0dEl2A2qJr0xOPYbBhdXtS0WiZLK8pAOkV+whIR7UUtQbeeDaj/iRdkMRXrm/GWmNaGQ2pQd+kBIe8ZHhUoHWVqLoYfyiWO0xDTNwYwbzDew+N/rJOwXdMvJ3Is7etMlVjfJCPXTW8Biior+oKiL2BLx3kwnnVnunQto1//CPqw3oQfKrB0HMNzFYwN9sp6fxsCAwTCA1/wvw2zXiJZJ55JKoD6XmQoHe3h3QJukQ6iBXW9p98yz79mKfRHZzB1pF7XMt9ibJzinRJgzbn8XE0UsMLEV0u/cWDm/hPDYKwzRcWmoAGzkz+loeNKxFdFTkSr/11mJxc/cHnPst+vKM3I3i4tqScLgIN6R+hjQ==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(346002)(136003)(39860400002)(396003)(376002)(36840700001)(46966006)(478600001)(8936002)(356005)(7636003)(36756003)(316002)(82310400003)(82740400003)(54906003)(6916009)(36906005)(86362001)(7696005)(5660300002)(2616005)(47076005)(2906002)(70586007)(83380400001)(107886003)(336012)(6666004)(426003)(8676002)(186003)(36860700001)(26005)(70206006)(2876002)(4326008);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jun 2021 13:43:21.4460
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 80128804-e6ba-4c36-e494-08d9364cddd8
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT011.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5026
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dmytro Linkin <dlinkin@nvidia.com>

Port functions, like SFs, can be deleted by the user when its leaf rate
object has parent node. In such case node refcnt won't be decreased
which blocks the node from deletion later.
Do simple refcnt decrease, since driver in cleanup stage. This:
1) assumes that driver took proper internal parent unset action;
2) allows to avoid nested callbacks call and deadlock.

Fixes: d75559845078 ("devlink: Allow setting parent node of rate objects")
Signed-off-by: Dmytro Linkin <dlinkin@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
---
 net/core/devlink.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index 566ddd1..ba27395 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -9275,6 +9275,8 @@ void devlink_rate_leaf_destroy(struct devlink_port *devlink_port)
 
 	mutex_lock(&devlink->lock);
 	devlink_rate_notify(devlink_rate, DEVLINK_CMD_RATE_DEL);
+	if (devlink_rate->parent)
+		refcount_dec(&devlink_rate->parent->refcnt);
 	list_del(&devlink_rate->list);
 	devlink_port->devlink_rate = NULL;
 	mutex_unlock(&devlink->lock);
-- 
1.8.3.1


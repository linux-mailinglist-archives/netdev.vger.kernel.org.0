Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7D2C48FE35
	for <lists+netdev@lfdr.de>; Sun, 16 Jan 2022 18:40:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235887AbiAPRkF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Jan 2022 12:40:05 -0500
Received: from mail-dm6nam12on2051.outbound.protection.outlook.com ([40.107.243.51]:32104
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231224AbiAPRkF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 16 Jan 2022 12:40:05 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YC8+/jusihOw8ncy5mOEO3xIAl/9/0AwYCgD3ttLZubz3SZcBXwX/XKpUwRaVvA0K9cNsG/Zrg0TQwffMmsPNxPRcDUjGHu9ferLDxZbJnz4pM2eqHE+QTzCRoB9TxrlCTCWn9z4sivm2AaE194sy80VCSq/rad9I9UT9HIZxVS3J2Ww8Yg85UAwUnAgO67AoGuwBMpFpuM4T/rqnbd2uPx53eR4H/zZu5piLsJ30ZCR/bXTW6mMoGbqRzV0g1P0T/d/mdu+KiWv65MhW2+Fjq4PdDbxuJ/ZK12opnHCTrujCFfv8ZvdCcanm9yEAGR7yXCpFEmG6DIgcfgWU0XSGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vwWyJRvczryHGHLgexmsAYdJVqikZ/j2otsgKtiaknA=;
 b=eW9zQEJmpg8p7lAj5o0rCh2awRvv2XWj5JGBEXLZWnrDBYCeVlQufjvwxGZfTmLopGSAFeamLurNL3g0CzqAx67c4xswQBImbSxWmqCP8laQZAmV5jwgMa7aDr5yMXD6SanAxNwCkQD0oCBGlkK3Rq0eLzgIikq0A+w+wHoNiEfYOZu7vjHvgY9Fj9SRHxRPMVIQzrr1AslKIJQD+CNi2w40ODhBZhxWwN9FQu6zipVlTDq4FVf4m7DQW19aW2AKbQvwp4sAnGUYbmV4FoMEIXj+StHf21vZAC/9FqSsLUZYb4Er/G/xUpcpY0x3RRYL6yX9wwC/sgO+24K6jV2tTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vwWyJRvczryHGHLgexmsAYdJVqikZ/j2otsgKtiaknA=;
 b=lsIZiYwBCi4tgV9YfTIBkw/f0SZI+pTyswFn+MSli8MH62M84h2QmAtnU4O0lgLDtBT3D+zPbX6I+rAIwybCo7XFzOY0vKzb8quSZXnih17v8bzq+fFv7Dq6mGZcR6/5LhbO61CNC2d+N8SS2Qs5YiGV9qTRiNAh58C2hx7oObe2uXIHNZHQQBjUx7O5q3qaSQhn0ZgE6I1qCInNLyjIvQ3SInaqnoD+WSw2K3TfELwe/ken6XfRdWidIXAZQmd/iLETBl1qC9BJ27vKA+ADyCobIX2Yc0sZQJNiYL2E62Jk/z+YJU8HAeUyUgBOCgir/Ky6k6cxrdITjbei9e2rfg==
Received: from BN6PR14CA0036.namprd14.prod.outlook.com (2603:10b6:404:13f::22)
 by DM5PR12MB1564.namprd12.prod.outlook.com (2603:10b6:4:f::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4888.10; Sun, 16 Jan 2022 17:40:02 +0000
Received: from BN8NAM11FT021.eop-nam11.prod.protection.outlook.com
 (2603:10b6:404:13f:cafe::fb) by BN6PR14CA0036.outlook.office365.com
 (2603:10b6:404:13f::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.10 via Frontend
 Transport; Sun, 16 Jan 2022 17:40:02 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.235) by
 BN8NAM11FT021.mail.protection.outlook.com (10.13.177.114) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4888.9 via Frontend Transport; Sun, 16 Jan 2022 17:40:02 +0000
Received: from HQMAIL111.nvidia.com (172.20.187.18) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Sun, 16 Jan
 2022 17:40:01 +0000
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Sun, 16 Jan
 2022 17:40:01 +0000
Received: from vdi.nvidia.com (10.127.8.13) by mail.nvidia.com (172.20.187.13)
 with Microsoft SMTP Server id 15.0.1497.18 via Frontend Transport; Sun, 16
 Jan 2022 17:39:58 +0000
From:   Moshe Tal <moshet@nvidia.com>
To:     Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, Jussi Maki <joamaki@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Tariq Toukan <tariqt@nvidia.com>,
        Moshe Tal <moshet@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Gal Pressman <gal@nvidia.com>
Subject: [PATCH net v2] bonding: Fix extraction of ports from the packet headers
Date:   Sun, 16 Jan 2022 19:39:29 +0200
Message-ID: <20220116173929.6590-1-moshet@nvidia.com>
X-Mailer: git-send-email 2.26.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 83a2e343-6703-408e-0091-08d9d91739c5
X-MS-TrafficTypeDiagnostic: DM5PR12MB1564:EE_
X-Microsoft-Antispam-PRVS: <DM5PR12MB1564C5E160C7B238BD0F04BFA0569@DM5PR12MB1564.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3968;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: L+6tBTbPs/OGIgqhK35Oas+vvt0KnksLG+lt8uUtnwm7kwT3UsVUF0lAVvDuYSGFNffP7V7xPB9W/9dX0xJ4syn8Bg2Ibg9gul3OofrYCYwPnOtxqhfMLWSQKw1H2FnnDy8FKq9ZGJj6zO6gqUd9kzNvgRQhD8lczEvor9l7mdLgEhWkeyQiMhVEdMS18PeeOU5kZAioUCwTHs5Mj/45e3BqntVibEqzsRzuKRL27O+gEKI1vSVbl1wkeAs1/H/lYSjQkxC5nEO8+TLf9jSgK8tcb4wzMvPH4FdzokXxxVW9/xX0pGL4Q5Te6H5+g+YlbJQ2vM3I3LhZ5lRgI5tUoLP8sLCXc87R9VnhnGb3SwvgasSq+LXDgS8VZNzljzjFUNr6Eh2gX+qsZl9rzkqdpWpUL2KXaCzu0QScWAP9CpoLeKiaBExBCQ+yD7wQADWcFigdUWhMW5aWb104jof7AnISvUWBRaxcpIKxXEiyqXdEWxgwrBuiOfQMUc6cwiwb7Esq+pxODAJeX7AeMS4lUgn99xgnvvYMW0J39is623cD+rzmWw6KhdtNWJSE3y2i2KlO8sLvLzBXy/CbJ2U6p9DMKJ3tPSuj5USyIMKk4QYhKQR2W7DnXaCuV6LmlhsecYLkKxy8MOGGrTv36fu+x5d+V+vvr4KHxhCcArhX97/gPScTCB5ozAC59vuF7LHtVYmEREOUuvaZuvHVfFzmiD6WfKRVo33N/e7fGyP57HiW6k52GYcdmR9WYbGhMCp5M1gBANBhZiAGJdk11ZWu/UXlBrIHqFj5qvpgfHeIGHo=
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(4636009)(36840700001)(40470700002)(46966006)(7696005)(83380400001)(47076005)(86362001)(8676002)(186003)(426003)(5660300002)(6666004)(4326008)(8936002)(70206006)(40460700001)(82310400004)(70586007)(110136005)(54906003)(26005)(316002)(36860700001)(508600001)(2906002)(81166007)(2616005)(356005)(1076003)(36756003)(107886003)(336012)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jan 2022 17:40:02.4604
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 83a2e343-6703-408e-0091-08d9d91739c5
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT021.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1564
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wrong hash sends single stream to multiple output interfaces.

The offset calculation was relative to skb->head, fix it to be relative
to skb->data.

Fixes: a815bde56b15 ("net, bonding: Refactor bond_xmit_hash for use with
xdp_buff")
Reviewed-by: Jussi Maki <joamaki@gmail.com>
Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>
Reviewed-by: Gal Pressman <gal@nvidia.com>
Signed-off-by: Moshe Tal <moshet@nvidia.com>
---

Notes:
    v2: Change the offset to be relative to skb->data in higher level to
    handle the case when skb is NULL.

 drivers/net/bonding/bond_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index fce80b57f15b..ec498ce70f35 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -3874,8 +3874,8 @@ u32 bond_xmit_hash(struct bonding *bond, struct sk_buff *skb)
 	    skb->l4_hash)
 		return skb->hash;
 
-	return __bond_xmit_hash(bond, skb, skb->head, skb->protocol,
-				skb->mac_header, skb->network_header,
+	return __bond_xmit_hash(bond, skb, skb->data, skb->protocol,
+				skb_mac_offset(skb), skb_network_offset(skb),
 				skb_headlen(skb));
 }
 
-- 
2.26.2


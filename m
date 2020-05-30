Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64FEF1E8DCF
	for <lists+netdev@lfdr.de>; Sat, 30 May 2020 06:27:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728724AbgE3E1S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 May 2020 00:27:18 -0400
Received: from mail-eopbgr130058.outbound.protection.outlook.com ([40.107.13.58]:61765
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725889AbgE3E1Q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 30 May 2020 00:27:16 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hJnd8gIGTirP2/mMNf4m1AwbbZ+eH0bVbXaY95GQmnSA/DLH2QQbMFLnKF+0gBsNtlfjwL+cBOQbaYKn26vg0pmqbysnW43QvVDjC/wRcoWMd/0hrkqDqU4IPNHaHzkfGstBVAa0M13ju9qvc+bn4gp/pvyqvma6QFzqrK4L6HwNE3XNrMVQrhdfEv1VwciDu2OYFkBObPAWn72IXX0wbQQOgTlgn8F72LXk0a03IJ9u9wT2msaRzSdf9wDh+PfxITCXNjmSbN4NMPX+kZvEAnhYwuxscMZxLdQaTZqtRkidKNMYLcyilPuqH064HkU0BKRrV926ohUjAiy89Lg9Hw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XRggQkwFSp80gouhgTnGMhw9i4LFy1lAHt4XLrhQo9o=;
 b=OG7aR1N7UM0UOuNpZhEYrxX86loxfss1d3DHqdSJbW3VSzix5XeW0x+DBrxf0VC0rm4UdR0a23/hia5Zcpm+RZmAy09L00O0a/7SVauS8yhc9NoFZ1a7o2xkQVAZKaCfA0S4jjX1wPvktFR+0D4nYJI/GfmIa8EReFxIRnDaCKcGHVLZwsx7tdw7cOvyJiQ/GgtAllzM5tAnrqPU0z88LR9OszAb3Hc1F3FBvOxPUZLL+uIWXHKZtJfFHs1DmaU+KOQQTxmaTcAP6ri6LJwbxQK3s48fPl4vWqGN4QvrNUfnMeE1fb3kiH8w+FEoF8/mzarXKJIfLTF2Kaayjv8ULw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XRggQkwFSp80gouhgTnGMhw9i4LFy1lAHt4XLrhQo9o=;
 b=GJRf0xdeiHZh8K+ghE+WkBjvFmn1XJBwNt7JyfknP5YzI703wmHtSJ1dgVMyGwfDbUMT8F9y0hIJHvGFt+FMxISm5iaP6dsdc/Ed94EiMvXV5pg64TQr8KX/48sGAYD4JwsmQ4A2VbxBT00y5Nfzk+V+T0SLn5d6hhV+ax7tsEs=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB3408.eurprd05.prod.outlook.com (2603:10a6:802:1e::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.18; Sat, 30 May
 2020 04:27:05 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3045.018; Sat, 30 May 2020
 04:27:05 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@mellanox.com>,
        Mark Bloch <markb@mellanox.com>
Subject: [net-next 08/15] net/mlx5: DR: Fix cast to restricted __be32
Date:   Fri, 29 May 2020 21:26:19 -0700
Message-Id: <20200530042626.15837-9-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200530042626.15837-1-saeedm@mellanox.com>
References: <20200530042626.15837-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR05CA0004.namprd05.prod.outlook.com
 (2603:10b6:a03:c0::17) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR05CA0004.namprd05.prod.outlook.com (2603:10b6:a03:c0::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3066.7 via Frontend Transport; Sat, 30 May 2020 04:27:03 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: ea497bd0-25d9-49d2-1587-08d80451b4dd
X-MS-TrafficTypeDiagnostic: VI1PR05MB3408:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB340801406BDDC84434E759CBBE8C0@VI1PR05MB3408.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:569;
X-Forefront-PRVS: 041963B986
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QwP8SMC/aUg0CNK4c7LYD5ZaTr9mXBRem5zXH27O3DQpXG5ANeKhhJG+yC+FHgBbTJd5FoPTDD33/gnCYezghswFC6zQWNnkpyhsd0wa35fllg9t65jdyxW0PmD9mS2cBvYTssBOMZeUtrwZF32ll2GennoFnL6NyZyfxsnXdgUUhbx9hS8MxwisqFykcTVdKouy8UwKuc7Z9yeULxF/Ezsrfiz+tTHY5sf3/EzLzwWbPb3oJvENvAAThwJgTwMZeTT6KnLC0N1Sf9YPcNs6lNZIFc665pdIIhfK2uiaqyljD4EIX+xLst/hV3s8mXGAncqYyJupjnL0HF3fKMCEOiiAWcw2LGMqpn3UCedHFI/Zg42bbmniSyauzGPxOU+6
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(376002)(396003)(136003)(346002)(366004)(52116002)(5660300002)(6666004)(107886003)(186003)(66476007)(26005)(16526019)(66946007)(478600001)(1076003)(4744005)(8676002)(4326008)(6486002)(66556008)(2906002)(956004)(86362001)(6512007)(83380400001)(316002)(6506007)(36756003)(2616005)(8936002)(54906003)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: IoKX3Zrv0WRfat/x6cn7AH9EYsbegebTMhNXxcTXeVvBRj9WZieJjrFdpKPqA43Cwvds9Dp0sFqX842KjpZD7iKY61hr92jTGkLfZtwJQKi2z5dEoKf/odQpLnBXQm/DPuwy3sG/1z9u830Vr1MgCOYZnpVhjhCzZg7N/9wzegfzpB261KNXt9gMfRQodjyMG8gYm3drMwgIILW1TFwW7GctSEmvZBLOG94zqXOB78NBQnADR7bhOI48h68wJNaOU9cqHOLSQSfOY0KXUh9wXL6uvDuSeleahOfDboz5+WKAAdilXqAu2RdIGqPbRV8RQjGXZllWVJGgGaz0udI3l3FmZJGA/SPHnCR4W7hOE3mRmqjUXRULLowhPSsKOc839Gb5j40CP344lbwix2ihxBBKD165MCAtiU2l8s5M07Ge9z4gi98pmT3mEqOWYzOdxmzvalukXdUncpCgGDrNQqyuR3V4/a6ApTwD+icP/w4=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ea497bd0-25d9-49d2-1587-08d80451b4dd
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 May 2020 04:27:05.0082
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WQJeDdRoDbvH6LF69KhlPc7MlXxPUYT5Lt+1RVoHcpwJ1CF8eQeqPEmTnlbTcPS8FHnNAJbwkBCi4sfjvjuVzg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB3408
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

raw_ip actual type is __be32 and not u32.
Fix that and get rid of the warning.

drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c:906:31:
warning: cast to restricted __be32

Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Reviewed-by: Mark Bloch <markb@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c
index 78c884911ceb3..4708950166930 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c
@@ -869,7 +869,7 @@ static void dr_ste_copy_mask_misc(char *mask, struct mlx5dr_match_misc *spec)
 
 static void dr_ste_copy_mask_spec(char *mask, struct mlx5dr_match_spec *spec)
 {
-	u32 raw_ip[4];
+	__be32 raw_ip[4];
 
 	spec->smac_47_16 = MLX5_GET(fte_match_set_lyr_2_4, mask, smac_47_16);
 
-- 
2.26.2


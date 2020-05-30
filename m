Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D3C91E8DD3
	for <lists+netdev@lfdr.de>; Sat, 30 May 2020 06:27:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728798AbgE3E1e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 May 2020 00:27:34 -0400
Received: from mail-db8eur05on2070.outbound.protection.outlook.com ([40.107.20.70]:36101
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728772AbgE3E13 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 30 May 2020 00:27:29 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a8Kxj7O0EnURNHT7mm+zDQEqu3HEIy+eklpGfatoh9s51bkqTeEjaByMfOYKnjbl25uefg8+ReNCwbQbc9DUI+tyO0a8ECvt8P+OQPEh67pF/brEn2tk5FZyrUpBgHSk+JOIzZdJBXHCO/qf5RuXkWzG1Geanohc9y5jFOKZGvhGOlBmZrZQouh6PkTn1vNQ3lAIwt4ajO747ggUhk5P2Jm3q7J/WGEMdRdRtFFmLj+7Oxb89m//L/QXD7fxYRwMxSPXdRaOWYee9zpxJ2WvzrY18nAcH8nVx4zcpuMf2G1KUT2GBcyi3BoJkM1cJ+i9yqiL444H6APsJ9U1UivN2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oGwErllm3G2QOT6zWeKgsMbnwUVVT8jWgN0TMqTW4LY=;
 b=IeP+3INB/qzUsAmehZJ4fZ6KZ8/2RuX8YYVzyklqbzE6ttbDKNzYF/JxbzOJMXcyyspZdlzQ6oSWV5utavWH+jvZ2azXE9xAooW6hLrtnJaSpSuBrLJxYdCIgYkK2sVM0UXb8uRDNwyUeX4OAVfgCFnyJgyijp76F5G7HnFxa5ZcJ2c5yqaDCIX7WzD9dYoYWkXghwPAGY13stDj7eqAuWCM7rP9ct7PxrXUXmx1bFbqxpKjrNzoz15xL+sIJ5+WSpOjpdkor+wKJOcCY4Qf+ODPuILFW9RcFE4NrIWtm5pYsGs0yjv+Ro1JORvfzYACmCtLCfEhrCdx9d0e0Ne1Ug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oGwErllm3G2QOT6zWeKgsMbnwUVVT8jWgN0TMqTW4LY=;
 b=Iqnx1SdmHMpqIa5C2dnlmd9/JfLts3EhR6K+HeiTTWNyofE+eALMKetLmK58pkVpRpVlO/zQ2WcPKPQGUF9MzMRRmu0cI0zet6RM/LsLzPKnOUIwH43uLk+TvO03keBAotegfr9B4S/tBvBUCZ2wMwMkrkARnKEjjXzHhth70To=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB3408.eurprd05.prod.outlook.com (2603:10a6:802:1e::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.18; Sat, 30 May
 2020 04:27:13 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3045.018; Sat, 30 May 2020
 04:27:13 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 12/15] net/mlx5: IPSec: Fix incorrect type for spi
Date:   Fri, 29 May 2020 21:26:23 -0700
Message-Id: <20200530042626.15837-13-saeedm@mellanox.com>
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
Received: from smtp.office365.com (73.15.39.150) by BYAPR05CA0004.namprd05.prod.outlook.com (2603:10b6:a03:c0::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3066.7 via Frontend Transport; Sat, 30 May 2020 04:27:11 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: fabc2a69-ad3a-4e42-884a-08d80451b9ce
X-MS-TrafficTypeDiagnostic: VI1PR05MB3408:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB340811881B2C7E025B0A1BFEBE8C0@VI1PR05MB3408.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:326;
X-Forefront-PRVS: 041963B986
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6gXsmN09lY2f3jBddciJpCef4mHG9vr4ODFw3UGYwLYdJeumzmFW/Y9vkPuWOanDQz2srbuJrC7Xx+5aCGVBEiDMkRJuOVEVlGuTfe0L+j18rjPmj7XmHnftG8G9T8oMmzlDEogCz+kzTGjVqmacE4hSjNNy/+hQGSq1LlWiUPPAZuXS+ke8GL+RIFAEJl3ZSHTH4y30gxDAImZnKAbfnZwb5c+90gz28UOtzMuRS9W5PRUaT3AgwfcXWpfuqlujRFLXPDfBBmj2LtVBOh46oh9vvjWkqrFDnmE53276nloAGMYKiQiYjVKQ1VI2pfsAUfSx8LxGJCqF/HgW6MUZl/leHrVhaZ+xOBtODDV/SwfN67uI5cQtukOGHu3tfske
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(376002)(396003)(136003)(346002)(366004)(52116002)(5660300002)(6666004)(107886003)(186003)(66476007)(26005)(16526019)(66946007)(478600001)(1076003)(4744005)(8676002)(4326008)(6486002)(66556008)(2906002)(956004)(86362001)(6512007)(83380400001)(316002)(6506007)(36756003)(2616005)(8936002)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: ssE8nByyTX1Ui+XIp1VbtYMVoS5wCHfh/xqnEyCJGeC3V00YR0giRu1/MKJQ2ebOPIK6c0k2HvJTGsFmlflSdhk4UL7aZInZR7uEAaH59zwHFPZ7UK8pbU6XOfVsVsuB76kyn51Ut94e8Y4fo5uLO9D7aTIHfDWO/Ww97z05g9VD8+kSLv+GHjQw2Rxl5i2eEIkfeFcnRU2uJucNLSr+d3ltIu2OSZ1eNwmfoKGXkBGwKcZ+7E0NvQuUW+F+F0RT6+sNx/R5T7UIRAU53IRa98COp5aFVWEQMcyIBxk8dv10yIrUUW5M7jNVsBPtfneBKDkxRccPwYTvy+Ewrx/tIwXKRVf6RRrw5Y9Bmku7Lu9EM6qzZuCFXLW5WMbtHVKi+9frBxxWRY9M787aG31Kh5Rp48Yhbmzuaf6S6vkEHEUmY/3pqIrIIWpqyzWrys2UYpPnX0bKjWQNrgsS20a5QjYSBE/I2SDwRsNufcoACeQ=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fabc2a69-ad3a-4e42-884a-08d80451b9ce
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 May 2020 04:27:13.3584
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tdZBNbH+q85o6SQlBMaBFHzszEAiSCJZPVA41P7HNl6JM8buo9jNaNCKrFlMxTwoYneu72rV79k7uahjtCvY+w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB3408
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

spi is __be32, fix that.

Fixes sparse warning:
drivers/net/ethernet/mellanox/mlx5/core/accel/ipsec.c:74:64
warning: incorrect type

Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 include/linux/mlx5/accel.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/mlx5/accel.h b/include/linux/mlx5/accel.h
index b919d143a9a6e..96ebaa94a92e5 100644
--- a/include/linux/mlx5/accel.h
+++ b/include/linux/mlx5/accel.h
@@ -76,7 +76,7 @@ struct aes_gcm_keymat {
 struct mlx5_accel_esp_xfrm_attrs {
 	enum mlx5_accel_esp_action action;
 	u32   esn;
-	u32   spi;
+	__be32 spi;
 	u32   seq;
 	u32   tfc_pad;
 	u32   flags;
-- 
2.26.2


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B7EF1CBF0B
	for <lists+netdev@lfdr.de>; Sat,  9 May 2020 10:30:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728027AbgEII3z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 May 2020 04:29:55 -0400
Received: from mail-eopbgr80054.outbound.protection.outlook.com ([40.107.8.54]:50670
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727981AbgEII3v (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 9 May 2020 04:29:51 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hsLP5pVOb7724GNI78uNpiMXksw8lxtJMujQpjkNS8aLqd22C8OW6tvmGr8MgdLQ9cIzivDxPZ9gxdSkHJEkeieJ2lILJpAWrpnv314ORC0oJ+GDp6rmF+5fywpVT3rGTmgtf6HfP2bsJmTlklIyRtrlQ1C1UG4b1+PoGb7s4CKK/AAEHHTcAatj5z5/vcppxb8IDM0o7JWtUHcnIT3+bjVcziMp/CPn/K7eF7mW4zGiQeJ6U0QlIM5+B1KvfaVAnIBynW/OPBZl/e7bR47M1Sw755Muiq5xPZRnSyWVRlG0nnIWqAz6TzguvwyQLA2iQCvMXZGLcC259d9Wsu7FIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EndDOgl8ZugdWANxnVnChhYIYBZa5VhyVVnmCLgtXpY=;
 b=F3Tt7duouZqmfR2oHXs5Omih66fcHvz6DA5Ib+Y7sVXxOJ3258hc+7GSEWhhzbnOFqKZH4ZeScpcDfZ8qeaWpxtVo3t58e5RIBckmXN1UZ0VVlfvqUxPzcrvNKNhLVCi8dZ0GdR3h10O1oSrrqZk14K7DvktuS9xxypXCD8WIJWpHf7CdR7jQl6JC+U+4Rmw41UkqTO75FqvIpccRAB9pICHbtiYSsIF/SI5KGarksjEBfpsExO0Yj7EPwWg7TfQ0ykh72QGjFj5Aovvls+vKkzsja3WRWB7h39vwsM1oJb21IT8HaoqHokXRo8D7GAL+qMGrbCduW/+VtZw2LkIWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EndDOgl8ZugdWANxnVnChhYIYBZa5VhyVVnmCLgtXpY=;
 b=seGskRBZeT3pSqxC2KzIMTsTJYdtIBWnm0SwV11EkGEocYC2LE8DgYQP7VdQqrJb57wsY9pqdOxWvcHl2X9G2FZkg/3ETmedfU7ktmU9hOAv2H4SFr2Zu/BjUAyhpZIbIQxvwMCmI3qvKXUWlm/1FX/YAe+nE/v7VxdWdiKvOe8=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB4813.eurprd05.prod.outlook.com (2603:10a6:803:52::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.29; Sat, 9 May
 2020 08:29:42 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19%7]) with mapi id 15.20.2979.033; Sat, 9 May 2020
 08:29:42 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@mellanox.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 12/13] net/mlx5: Accel, Remove unnecessary header include
Date:   Sat,  9 May 2020 01:28:55 -0700
Message-Id: <20200509082856.97337-13-saeedm@mellanox.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200509082856.97337-1-saeedm@mellanox.com>
References: <20200509082856.97337-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR07CA0011.namprd07.prod.outlook.com
 (2603:10b6:a02:bc::24) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR07CA0011.namprd07.prod.outlook.com (2603:10b6:a02:bc::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.26 via Frontend Transport; Sat, 9 May 2020 08:29:40 +0000
X-Mailer: git-send-email 2.25.4
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 5a72c512-19dd-4913-6a57-08d7f3f31eef
X-MS-TrafficTypeDiagnostic: VI1PR05MB4813:|VI1PR05MB4813:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB4813283A739657E034AD9833BEA30@VI1PR05MB4813.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2657;
X-Forefront-PRVS: 03982FDC1D
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Wib3QGWWoSynXwsasehl7iHks1bge3lRa6A8jQt6ClGA2up0B8QOE/YmtWZuNrU+p6hELbqUYluBGCVPF3XJRxAcllw0NeUy10X7tlFbHKQonW4KvP2Fv0KEt1UcCq2iX+oR6EfS2hxbgkWxeyNR6AF3IQsvO4IpX/fETooSg9Q0wKQPpP5gjXUDyO6Jo9/0Fzg9ziN/BpJOb/Hw2NYMsK4cr/RI71rvAH9D4kFdKuw5LV+QXd25ukRL2I2BURUZ80zeLNIiQ+IPzDMyfyTP9LLjREFbY1PM0WRntv2UgkDvrue8Nam7NzEXzljbqqx4VMKuEVFK3TbWenbRNrquBoZ6AMA1fOPknNYM78baIKvizflHWhz3J1M5uOnmMGBczkaAUU4LetH/NbT7DrFm2FtqsIZNdTZMFYKTYyLUEhCG5gaD+BvATq/tKOMwOtNUfPo/IoAsNC6PbAlRL2Hfe0yrvjnUEY4Q/y1ib1ml9kmBINTGfhUrnrwIMZdNn5arRPWv4N8sJHzNJPXBTZ+ES3zi/PDnORS7QZl8u8ClgA0G7fHV8nBVDFFMvP15kAW9
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(136003)(346002)(39860400002)(396003)(366004)(33430700001)(107886003)(66946007)(316002)(2906002)(16526019)(8676002)(956004)(54906003)(66476007)(5660300002)(186003)(478600001)(52116002)(86362001)(4326008)(6512007)(6506007)(2616005)(6666004)(26005)(33440700001)(66556008)(36756003)(1076003)(6486002)(4744005)(8936002)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: uAJjTCX2PWrlrXHddsLIejXBT5XHFDLJoq1K83BEgPlIM4XIj5+ZDSmxMJ8Ul+SupWdIZXaPRvPG9JyrpDyq6g4qiuWdIDPwOQQcv4vnihoZAql89j94s1ELCNEW2w4EAb432+n7fljQb0U3EUq2s43tlxxYbEwKVCOckO3eQtfM2F19NtFz2jBcE038UxY5yF2gUUepwd0cO1A/OZ3RRhYmAbmnzuaoAiXmrEDlMvdBB0V/lEQjuhUm5cJfjhbPyZi7JC3ECf6AFhhUZOhsFIMQtJJFE/GYawhcefBaYpBrlYjgp3ZBG+b4HcqZnXpglj1J4CzW4sx0/BskhAhqcL9aFEkm48t3BGURMpPMtkfYrCPOgwdXIObc2KEQ/H4yxIHIqRbDoEhwajig4LxzzsFnR77I+v1uszU8z1116gSVSAyMOepFzeZDXzjCTY1mJ4fHeNVt2xl8JCMykNn6pUmERCJzAimFK3tTpvagtO8=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a72c512-19dd-4913-6a57-08d7f3f31eef
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 May 2020 08:29:42.2011
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EYITzRTKDlIHRJGUDL0EB2pUL4N6Wdi2QXY7qA14fQPbxPPfjAYDYglA+Y6XGA4yqDgdW1PawZQNlwzGXAdvAw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4813
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tariq Toukan <tariqt@mellanox.com>

The include of Ethernet driver header in core is not needed
and actually wrong.
Remove it.

Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
Reviewed-by: Maxim Mikityanskiy <maximmi@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/accel/accel.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/accel/accel.h b/drivers/net/ethernet/mellanox/mlx5/core/accel/accel.h
index c13260467750..82b185121edb 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/accel/accel.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/accel/accel.h
@@ -5,7 +5,6 @@
 
 #include <linux/skbuff.h>
 #include <linux/netdevice.h>
-#include "en.h"
 
 static inline bool is_metadata_hdr_valid(struct sk_buff *skb)
 {
-- 
2.25.4


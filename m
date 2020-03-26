Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D0F861938B6
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 07:38:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727677AbgCZGig (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 02:38:36 -0400
Received: from mail-eopbgr30065.outbound.protection.outlook.com ([40.107.3.65]:59543
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727655AbgCZGif (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Mar 2020 02:38:35 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZsZBaUnpISry9eJkgQxWzMeJBUJ686LcoehMnP7TaIbDCX0HsbIFQlwqowzF9jYdPFGPWUylVvISo76HjLm1SdTd8Lr6+4b0YlA5yTuytmJdWf3hMUzBNVGNkXO4RsZ1SVdM0R7wtm5jim5TwkxWPrX1mzsm4PMO95HrU0jxWuJWpzLMXDYtD38WWpvJeMOAGdfLgas2lmfizqIlv2seVgFpRsWPrDV7wbIaOpYWlXFgXSjGwCaV13xx17NqpFTpXumgu+ob+TkYoVKrA6ldTGi0eWYt2/kx8uDuiUhNFk8Etn0zje50kp4OyRAMJ4mJIsEI/gLJwqFNUq95LUOTKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IyEqJHf7UM+siLE1EFs0jXf+F+O/MEHm6u8Te33hcNg=;
 b=Y/1cCQhYzGvn968q9YuDahy2MQ5nvf67K/eOYhkKk8CVwFLHYQww+VpZR2OOarmEKo3nYovseNRm7CifZe3WOXUnJAwaH3O/Rma5HQCyYQs44FV1IfKpX59b+BFTFKlUB2eJEDOMRNISqRqcJ/VW/9MZlxRmZbnIpEX6HKSmq8aTZD7HoJ4zPL2qDf0jaTy1C287zOjiVRJNY336yyKjt6jRqV+hrzKxTDC92nQMaiGU1a7L3QwYUWuzXrWMWYwrIs8HAw3bGb/g4vq5F7eC4fUIgijzyLcHZEV6GiCWk65E7FBFhXa6LsCCtOQjTut1lWJWVI3dZicR8JNnHGtOPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IyEqJHf7UM+siLE1EFs0jXf+F+O/MEHm6u8Te33hcNg=;
 b=g4dtjgAIvEQcnQbBstnwrFIP7Kdoz4cXf/4DVQAh1sqTpPTMnkacw5lc4OaCp+Aqiii3GbLRIK0tB6OKLaLekI8uxWWxTnaYfoQtgqTT9iQkIhu73tk0MTD6D6rV49frbluoyC/ero4vHDfJpfjbsYdAC0C1SisIZSuJfwZbDAE=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB6479.eurprd05.prod.outlook.com (20.179.25.23) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2835.23; Thu, 26 Mar 2020 06:38:33 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2%7]) with mapi id 15.20.2835.023; Thu, 26 Mar 2020
 06:38:33 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Jiri Pirko <jiri@mellanox.com>,
        wenxu <wenxu@ucloud.cn>, Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 02/16] net/mlx5e: remove duplicated check chain_index in mlx5e_rep_setup_ft_cb
Date:   Wed, 25 Mar 2020 23:37:55 -0700
Message-Id: <20200326063809.139919-3-saeedm@mellanox.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200326063809.139919-1-saeedm@mellanox.com>
References: <20200326063809.139919-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR03CA0020.namprd03.prod.outlook.com
 (2603:10b6:a02:a8::33) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR03CA0020.namprd03.prod.outlook.com (2603:10b6:a02:a8::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2856.19 via Frontend Transport; Thu, 26 Mar 2020 06:38:30 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 7dddb1cc-afd1-49c4-86ac-08d7d1504d94
X-MS-TrafficTypeDiagnostic: VI1PR05MB6479:|VI1PR05MB6479:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB6479A0766A649C1D56AA61A9BECF0@VI1PR05MB6479.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2043;
X-Forefront-PRVS: 0354B4BED2
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(39860400002)(366004)(346002)(396003)(376002)(136003)(478600001)(107886003)(52116002)(6512007)(4326008)(86362001)(6486002)(8936002)(54906003)(6506007)(36756003)(4744005)(1076003)(81156014)(81166006)(2906002)(316002)(8676002)(6666004)(66946007)(186003)(16526019)(66556008)(66476007)(26005)(5660300002)(2616005)(956004)(54420400002);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1zeJqZGxFGQ0JHRoMURqSx7rerhZiphMekqyzZGE3BdHoh30y8jL3xFJOfTcPFPlD66KXmBjM+Sp+27XgKtGoAnylukc0RrX47o6Wkv8KLpseCHr/0+/OWo+WqODq+tb1ja79sGZ59lRZ/FEL5dNNZPmji7CAXVXv8QeonR2A/cvouoi2j5xKbKljjrd7fM2fvx7xFCNFl9I6Jiw7QfR/JzxusrZdETxHtAGbOXH4tzNlQRhOQdqhsWJ7aTo2LLesZ+1334QISlzNALx8t3GXAlOWIhV5jE5BlcNE/w1KS2NcCR5ho8rz6uqAhigjz6ic3jysIWe/wX/NH2u77M82h2DkEspSHPJ+mSQiH0XtgQqhHTmBGVXnQAnwTyQAgsXz4XnSZ27P6Apu/kMUXCmMnzZME7qC+N8F45zTjG0KdC0jCe5p4fNB6T6vWHfbMd5kGDkREq6LdjbEEGG2HXt5FndpySexU7gp2KYnQp31FdBzp6zDsq0Ip8jamCzD9sl
X-MS-Exchange-AntiSpam-MessageData: KCDBEivSMS+5bEnRtuf5BM4AaUXg0dBD2djEET7k+HEqL++KY0z3MaL3xZa3D8stmaB5V2VUP3mS1nSPR7tFDsjxs9LahSQZ7vAcmjDvMIT878Sv67M6in5r/KYBWy0qMvj51/bagB0gbd0bX+nu5A==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7dddb1cc-afd1-49c4-86ac-08d7d1504d94
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2020 06:38:32.9820
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IzSt6+/FSZ1AywKqmST7KBnbKAOXj5U22gcLIdRkw4pWnDyQEB1GO/uSAqgJovQvgfqR/IbiTXQZOImzd/quLA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6479
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

The function mlx5e_rep_setup_ft_cb check chain_index is zero twice.

Signed-off-by: wenxu <wenxu@ucloud.cn>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index a33d15156ed5..d7fa89276ea3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -1246,8 +1246,7 @@ static int mlx5e_rep_setup_ft_cb(enum tc_setup_type type, void *type_data,
 	case TC_SETUP_CLSFLOWER:
 		memcpy(&tmp, f, sizeof(*f));
 
-		if (!mlx5_esw_chains_prios_supported(esw) ||
-		    tmp.common.chain_index)
+		if (!mlx5_esw_chains_prios_supported(esw))
 			return -EOPNOTSUPP;
 
 		/* Re-use tc offload path by moving the ft flow to the
-- 
2.25.1


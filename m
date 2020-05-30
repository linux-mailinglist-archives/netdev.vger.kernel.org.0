Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0E671E8DD0
	for <lists+netdev@lfdr.de>; Sat, 30 May 2020 06:27:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728753AbgE3E1W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 May 2020 00:27:22 -0400
Received: from mail-eopbgr130058.outbound.protection.outlook.com ([40.107.13.58]:61765
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726193AbgE3E1T (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 30 May 2020 00:27:19 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JPLsumyu/FkhsD9Fc7dqoVmRHS9FBPD4xCuBHwA0NYbGp6tSv3EY23ljSoNVPLjSYfTzuksbRBHfBVXI0qCcXrJp0ocTT6tKAK/WMaKkvuz4o1/fJ0vxJW9piVlqh+mUhZjRnLcxhyz86NEeFgXhJoPr8v097OHJeQkxXaY/g6xWYaWcaIi08G7wPhlcnh7roFsRextAdx+bE35XEEEcBigq2EvYWQlNjw+yiuC6G1/YhIF0dDr/Z/fjs6Ygj6Q/fOUG8s2f1wDkdSp8IA/5Imfmq8lrx2kUnDtfzuk6iG05bKXJdgBbbVkVcOYa4tG18jgOB/QAfz6a2HdbA4Txsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BXK2utUMK1yA6ac8AHOgfy4UGHXgg/xIwlPH06pXDy0=;
 b=FJIhf86qD+gP2Mg6Zb2I88sVRArlr4jaeke6Hmt5iDpsTsJTUcXFfvZoQ+1Tv4xXmNwUD+NbKiuheXnXu3Vw/ZEIHHcmxvvRdXCmVjCp9xTeD5yt7D4K2J88IQXnU/YtdiLZL9HaZlLjWXwZYT23cMXBkX+7WVXfuWKPwE+TAY+ORdQ6P9BoHeIkSEmmOxJBRHxfAxslOsM2WiasoXEY8T0GVsE5i2ueba/6kmd0stOznSFz+Ev+ON3cUCEswbmcTGByv27YOjIoZd5bS4KJzdp70r4CLltFnE6EZFKOtZIoJ382gGG3qubOqOSOMqrmfdv4AL35tvjOipogz0rzeQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BXK2utUMK1yA6ac8AHOgfy4UGHXgg/xIwlPH06pXDy0=;
 b=cUEhw0hTIyWD8ydB5+zAxouDdXjPyXPuNmMzc3Dt+obt4bfk3RAV0UAkUMvuz8VkTo9ssD1QpDVpi59Dns8v41V1bK1f0bH2EdU921TFCktiMKZ7cL5Ohk5mpeAsOIh6gEw7fER36o1dxVBOmRsY9YasqVgND92SisJG1wf/5P0=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB3408.eurprd05.prod.outlook.com (2603:10a6:802:1e::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.18; Sat, 30 May
 2020 04:27:07 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3045.018; Sat, 30 May 2020
 04:27:07 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@mellanox.com>,
        Mark Bloch <markb@mellanox.com>
Subject: [net-next 09/15] net/mlx5: DR: Fix incorrect type in return expression
Date:   Fri, 29 May 2020 21:26:20 -0700
Message-Id: <20200530042626.15837-10-saeedm@mellanox.com>
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
Received: from smtp.office365.com (73.15.39.150) by BYAPR05CA0004.namprd05.prod.outlook.com (2603:10b6:a03:c0::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3066.7 via Frontend Transport; Sat, 30 May 2020 04:27:05 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: c519e3b6-b6d3-4c0a-2001-08d80451b635
X-MS-TrafficTypeDiagnostic: VI1PR05MB3408:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB340874CE26EE5DCCF4DD58B9BE8C0@VI1PR05MB3408.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-Forefront-PRVS: 041963B986
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ouNwgZvhCvxDiim/Q/JKPk2UOCcStvGdwER2d0C0lKwZ7JuFTSYqRhNSQCGeD4TS33gnXRfZL1QvRFRyKP2EfkTRUwEeIUncXMCTFqIB1Jy6idGRoaSoraW/CnhfVx4yfBkgdjCIH5FKGBSXbTBDXOCXdBhcyP45eck/IVPwUt120r94Z9Vmg+SbpldFrfy22BiYSoO5NCFsRXC83pXhKkESFQLZqjkKYxPiNxcI8T836xVAQ8mUlw5Pw48h31MwRShL2fuDEjT7qRD6Z1VzD1x+c9bGyaHb02d4TC2Or3E6cjM+aQ71nI89rz/ZZ08MhONjd4WMgp2+5bkvbKLCCW50RQFFCHwNJRM/YWP+Jx75KUdQMqpnrjNwd3YkV//o
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(376002)(396003)(136003)(346002)(366004)(52116002)(5660300002)(6666004)(107886003)(186003)(66476007)(26005)(16526019)(66946007)(478600001)(1076003)(8676002)(4326008)(6486002)(66556008)(2906002)(956004)(86362001)(6512007)(83380400001)(316002)(6506007)(36756003)(2616005)(8936002)(54906003)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: dn5MKA9LoFvb4GDHpxSupFjEBCGEFh1T46zfaMeJd3lz30U9PGgvVexrJfTpCIVUSjbd3p3E4Hs8W7Uk8NFBYmtR2kTH1x021wQVFoV59ZJ8bsDHq65vb7pTM5/Ru+sx0D73f8A1/+YerX2FzyNxGSPAzPkBWYfSSwBVVIPhjB/28HjKWZ7uiA+6bg0/sF54P5wIBFSMPZ6NYEOLjBivJXziGLD51+MQNFDBOnW3SLrSFlsk1mTl4TozOadeEEE08MHWqYjK4yK5Nvl9uFIlrAA7Xb5f0Rq363wqFH3H7Zi3N0HyZTrXypyXvtVGXj4F3T9lg4tfUlSsvmz3v9Iu7VWI5Jip0jEzP3jOeA9Edo0Cg8Ww6tmCoglpZ2entf7K19VVhdSQSTFpta+GMtiOccc5kHfwTiyOLHq4QFg8jDsRQJgsJ7+pYSyr4B2QOcazMSgXLHs6l45xEShJ37M6G8fapjGegUzhPuf7nmbSKSU=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c519e3b6-b6d3-4c0a-2001-08d80451b635
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 May 2020 04:27:07.2789
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YcDrC12p0KnUt2lm/ub8AA8lg0YNCsD8Bppwi5O5+J1EZhNd2/DZOMTA1s5qPS0t5+ZEXkPOYRK0eY41Wf2ESg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB3408
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

dr_ste_crc32_calc() calculates crc32 and should return it in HW format.
It is being used to calculate a u32 index, hence we force the return value
of u32 to avoid the sparse warning:

drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c:115:16:
warning: incorrect type in return expression (different base types)
    expected unsigned int
    got restricted __be32 [usertype]

Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Reviewed-by: Mark Bloch <markb@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c
index 4708950166930..00c2f598f034d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c
@@ -112,7 +112,7 @@ static u32 dr_ste_crc32_calc(const void *input_data, size_t length)
 {
 	u32 crc = crc32(0, input_data, length);
 
-	return htonl(crc);
+	return (__force u32)htonl(crc);
 }
 
 u32 mlx5dr_ste_calc_hash_index(u8 *hw_ste_p, struct mlx5dr_ste_htbl *htbl)
-- 
2.26.2


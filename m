Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC9D32286BD
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 19:04:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729290AbgGURD5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 13:03:57 -0400
Received: from mail-eopbgr30041.outbound.protection.outlook.com ([40.107.3.41]:19076
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730263AbgGUQzW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Jul 2020 12:55:22 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C0LVvHxWCDwSFh5qWiDO1i9ugeVY8VkPJdhhttHBvdLyvQIhSRbCwXk1EVTAn3diINOaJZoq7MSG5UUAQPx224kbwjeSiMBC4VqHSHBGDwwI2yiGn1RpKY5+xwhFX+LsJgGV5J8fEutITH/iMwWEKuvSsp0Qdbbg4CjPtaK5oa8MspQepigU72zY0cuBNH0dQApAOhcobq6F9s+1/+KzIaglhxdwCKfe0LTwk2PIuxDsHPf2H3/S2o60pl+LEStSZrmpXbFDz0iUEr3ex6X43+BRDNidb681QNCCTKjoC5YolS+jYn9nE0ECI34mgN+lp1kuHrKkCJLnI8ZHE+Hv6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ax3QS0wIGk8aXSIqmLJDjVpFpIziO4J4E4PcEtAuX0I=;
 b=Vh37kez5Cp0bQauNrKGb8tWeZG0pFNf6MZ9koSl4TX8htvTZGw6vzGUiztru2RXPgkbLi5y9jjyaXVmPxullE9E5Gw2m3hx8EXvsGaFZ1mldx8+qZG3bl/IODL4h2uNknbxMN5ti49VlhdoCDXI8ogo1NUOlQirBMkPO5xj5H25RAbeiQpvUBozivRR+IQnX116lB+FhjQGy13QkbeYeAu+Mk5XE3LIBCRCmWXQbdl3Dr+c5dPqKVXMbni/zGGK8t2z66eDuIjqvVhwKnrvIqAwWYvw6x1fyUu3ol3hUKTJIu5lCMZeuRdrA2hyLWqd8BNX+8MVFFlHL9r82PITaMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ax3QS0wIGk8aXSIqmLJDjVpFpIziO4J4E4PcEtAuX0I=;
 b=FbnadgO4DYHKmiRFhmbOGdJg8c0/A5d0XBj/oT9+wyAB5HidISHbe3pX7/3VSvGwCayeirC4AEAAJvSUnWHT0/LS1sSeZ+8qtYuhRVb8zlZQbAGJEPAWej++35//e0OtxQAXvrkzGaHGCkbMGqVimE588Ec6f/PR/toKLRsgsSA=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=mellanox.com;
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com (2603:10a6:208:c0::32)
 by AM0PR05MB4739.eurprd05.prod.outlook.com (2603:10a6:208:ad::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3195.23; Tue, 21 Jul
 2020 16:54:11 +0000
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::d44d:a804:c730:d2b7]) by AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::d44d:a804:c730:d2b7%2]) with mapi id 15.20.3195.026; Tue, 21 Jul 2020
 16:54:11 +0000
From:   Parav Pandit <parav@mellanox.com>
To:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net
Cc:     jiri@mellanox.com, Parav Pandit <parav@mellanox.com>
Subject: [PATCH net-next 3/4] devlink: Add comment for devlink instance lock
Date:   Tue, 21 Jul 2020 19:53:53 +0300
Message-Id: <20200721165354.5244-4-parav@mellanox.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200721165354.5244-1-parav@mellanox.com>
References: <20200721165354.5244-1-parav@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR04CA0073.eurprd04.prod.outlook.com
 (2603:10a6:208:be::14) To AM0PR05MB4866.eurprd05.prod.outlook.com
 (2603:10a6:208:c0::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from c-141-251-1-009.mtl.labs.mlnx (94.188.199.18) by AM0PR04CA0073.eurprd04.prod.outlook.com (2603:10a6:208:be::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.20 via Frontend Transport; Tue, 21 Jul 2020 16:54:10 +0000
X-Mailer: git-send-email 2.25.4
X-Originating-IP: [94.188.199.18]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: a5924e88-8bfc-4140-8532-08d82d96b139
X-MS-TrafficTypeDiagnostic: AM0PR05MB4739:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR05MB47390285E55D6339DE456D0ED1780@AM0PR05MB4739.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1360;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CPK9E02r7tPtSY1q4Dao2qL2StKnRpGWiv3ojOOxSB1xi2XFZ3VjPYtXzw/2sFhawDOWqaf3D2II4XoauWcAIbXpBAIAMPkl86HEiIB89pkfmi3G5LX/4K+7eHNPiMQ91j1RDDhbxDGF2lI5+WBurImhc7gqGrhd13KlqJloC8bO1oBfsWRAGRzd3jPPIZKyEI3rvEmLq4oaQXEsoF4RCM8oPC+awd5iqMovhDdDBptidWbtyYXjT7K3AGgaYVxu3z6B+CJesQLvVtzSX5yhjL1bJfKBfB3fGKYUp+aDV1ZUPy0zGEZs1s/XuEoyJGoMalJWyqs3Ij5cBXTvyWnXbA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR05MB4866.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39840400004)(366004)(396003)(136003)(346002)(376002)(316002)(1076003)(66556008)(2616005)(956004)(4326008)(26005)(186003)(16526019)(107886003)(8676002)(478600001)(8936002)(66946007)(66476007)(5660300002)(86362001)(6506007)(83380400001)(6486002)(6512007)(52116002)(2906002)(6666004)(36756003)(4744005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: qm9B1CDOrqK+/GVGHZCwnb3j+CWBph5HCR57EjkwmcztADcShW8/+Hh27JW8+kWu0M6d4u7Rk9FFCHPJIr+VqmH3QyeE2YkksawZNZAA+PIT3vS4ZZZWCm8oC0bREglS845JhVri+g1SX1R4H7ulyTcOR60Wed0h3es+c+Y1D6L9keWGL1E6BooPJl/Ytk2che6DBYsGVVsl4fcfj25ddPMtIk77Ni2VVNt4iT8HtXVT8Xu1uEyUXmbBC2oNugdxA4RUgpyx7NL1x1FoWJ7aNajYVdC4tWyVRf5LEIeR1KX4d2/COqYbYmvYfgzx74903Lzo4OaIct1pQyUJdBqIwggJM5RqK6zwjM6Ar01Q1u9GUzg7rj9X0qhlU59cJMQKMn8uNDQPc6epedsCYCCLjSa/XD84RFrccY4ZD9NqO5wSKAZi5smxogdJExpNBRH/WH/sYbUyQUHECXrxfsb5+6c+jVyYWbg2SdhozTYHc4soltuwo9RIjES2ujTPlzYD
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a5924e88-8bfc-4140-8532-08d82d96b139
X-MS-Exchange-CrossTenant-AuthSource: AM0PR05MB4866.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jul 2020 16:54:11.7254
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5shwVPr1glYEoHQ+N0D9CG0IuGcS+LHm7UlsKOE+XFu5N2kEqk5BvJt+52NHZGFO/MCTtR9nDm3hZl3NyP2gsg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB4739
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add comment to describe the purpose of devlink instance lock.

Signed-off-by: Parav Pandit <parav@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
---
 include/net/devlink.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/net/devlink.h b/include/net/devlink.h
index 913e8679ae35..19d990c8edcc 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -40,7 +40,9 @@ struct devlink {
 	struct xarray snapshot_ids;
 	struct device *dev;
 	possible_net_t _net;
-	struct mutex lock;
+	struct mutex lock; /* Serializes access to devlink instance specific objects such as
+			    * port, sb, dpipe, resource, params, region, traps and more.
+			    */
 	u8 reload_failed:1,
 	   reload_enabled:1,
 	   registered:1;
-- 
2.25.4


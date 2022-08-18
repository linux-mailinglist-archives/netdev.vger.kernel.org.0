Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B4C659878D
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 17:35:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343705AbiHRPcy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 11:32:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245577AbiHRPcx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 11:32:53 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2079.outbound.protection.outlook.com [40.107.243.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71565B9594;
        Thu, 18 Aug 2022 08:32:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RZEltwThCbSYGJyK7r6Hvb5g3eB4+S6H9kb6Z0io8var590ezUr3lkY4z8Le1sgMpxVWM5kBOzdOUwMVSqTNRHM9chyNzRzWNaKIBMty48cjsnfHARjXr8/1Eg6HtLIVUr3aW6I+Y51r9+AlTM2ZCWiwbjO91OoXcVo822x0OAxvRqZlTCBnw8Ch6MG5RGRPuBnXbX697zhdIgGTW1FmitYDyV03tonaJF6tEsqOjIjuUlsX5jvY19e1yRyiWbOgt5D1MHtjA2PyYHVpWMLCxQ9LD0d0C0Hz/+mQGb0mBn3nZjEtpsCQJ3TZ8UKCM0MiQqTpR917nehiQKSovZ4bkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9CezxcxS6YYfC9k3Ofr9G0IyE/LOb+gQJiOLzVz5vpw=;
 b=PDPUsgTu2UQCMpnHWTeQGq2stlDoANzXBiycp2x7aNyyUuwemWK3tYrVxxEkZ2kM8qZWmcgUJqE0g07XC7+nZnkr7FX04ZMWNIEn3uaFTTzUzscviYBrbcnFgvl5ckLnHDj0Sc82erk9xxIknPmht0x8Fip7ep1AGliOcBzlBy3yb2B8oogRidGQH7h7wRFmRj30dXv0pys4vVZvnG9VLMlycOLaTRk0C6SOkFEQjlr06odjncDf74USwK8Q/gisy5Jh/qcyR2WBWnF4m5EaUfcW4ghXxvoRaHc9yYUtmNiqMWpcaQIzkKEReyDUrAO+FULn3rXtgfHi7ypg1A0iPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9CezxcxS6YYfC9k3Ofr9G0IyE/LOb+gQJiOLzVz5vpw=;
 b=qO6LNcFybhYnoiOnwn4/y8BStcig72PX11oYQwdKdRBVVi3c+e4b9u+UjAmntWIGYTV/wAtIhMkTYVKtDQ2z4j8VoFfpfa4k5V7LYGLaBKefTiAkSf6W/KTu29YNLG7J+L1NqJipJkXuyF2zkxXtSaLTY122KoD47F2MWZSiRW+oxH2TFRDVYD0ZkLcTqVOeyDhMhjzGSSBYq88ujjB4Ekz3rENM7FwRP7MNDKUeGEJ//sJGTBZAx+XP9l/Eo2lMBT52+b0nn+/UKr+NJLlPc5qpxFClmkaIEOm24QeWNuyP9jY769PJ5o/5/m0UmPtDB75Pq7AFYeq82NvVu3eelg==
Received: from BN9PR03CA0349.namprd03.prod.outlook.com (2603:10b6:408:f6::24)
 by BL1PR12MB5876.namprd12.prod.outlook.com (2603:10b6:208:398::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.10; Thu, 18 Aug
 2022 15:32:50 +0000
Received: from BN8NAM11FT021.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:f6:cafe::fd) by BN9PR03CA0349.outlook.office365.com
 (2603:10b6:408:f6::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.18 via Frontend
 Transport; Thu, 18 Aug 2022 15:32:50 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.236) by
 BN8NAM11FT021.mail.protection.outlook.com (10.13.177.114) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5546.15 via Frontend Transport; Thu, 18 Aug 2022 15:32:50 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 DRHQMAIL109.nvidia.com (10.27.9.19) with Microsoft SMTP Server (TLS) id
 15.0.1497.38; Thu, 18 Aug 2022 15:32:47 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.29; Thu, 18 Aug 2022 08:32:46 -0700
Received: from vdi.nvidia.com (10.127.8.9) by mail.nvidia.com (10.126.190.180)
 with Microsoft SMTP Server id 15.2.986.29 via Frontend Transport; Thu, 18 Aug
 2022 08:32:44 -0700
From:   Emeel Hakim <ehakim@nvidia.com>
To:     <edumazet@google.com>, <mayflowerera@gmail.com>
CC:     <kuba@kernel.org>, <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Emeel Hakim <ehakim@nvidia.com>,
        Raed Salem <raeds@nvidia.com>,
        Sabrina Dubroca <sd@queasysnail.net>
Subject: [PATCH net-next v3 1/1] net: macsec: Expose MACSEC_SALT_LEN definition to user space
Date:   Thu, 18 Aug 2022 18:32:30 +0300
Message-ID: <20220818153229.4721-1-ehakim@nvidia.com>
X-Mailer: git-send-email 2.21.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e38ac41e-001b-4800-f709-08da812ee941
X-MS-TrafficTypeDiagnostic: BL1PR12MB5876:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QSuhwOwEsy08YNgLYrqb2TSFraAXzAkNe/KC2PcBH9Qhr3dlkof2B5Eo5MLJMGs1JiZjk72nIaxM1jx3Xlj+y80RXwLMFHYhpyHf6mDInovWooOMG4BFaayTCu8/y5fp2eX25OECoMj8tjM0+bM+Ay7Q0vN7nOqZLPcBAOSL4AYTBrIl+DZ2zCaR1q9d22oOceNsA8zygHeH0fg/249dz8UaqoyS9P89y6rDsYuP9UJiqC5TVWnfdoi6fqHNEEFHU/NzHYWR7FH6zN2nY9KtEQDfYoowJvlBUTRyHif+bBLV+us0RRrgRbHSpUnpJepSg07xMSNkR8B5JT6SlOt4RAJQAXML3Yrz7zWYF8p2zwXZZNYZo6Aql8rInXu6ZJBCxoc2U+2znKxjUkJcYWoHQJ420MoRtZNyWIGhsh9snb64iL0H1DXuNc+HhPY/Mhr9iZZoFzf7GXreDAlOrBIdSmPkTpRb0hOaHfXgDsLFGEE2aiLIhWcjpaZapmdCY1N6Wr7jmjzc4JqY70+b6Y+sAOZgmzKLlvvOvRbcAPehBAXpZH8cemzI7I/9RYbKb6K2UBVR1QKOcgNcIeGosI6db7Ea9pcbMqBkr2+1i51uMRH/l63/S2sx4Pq3GfKd0x4StQHa2I+LeQ3nsChCrPOxQ05dGefticnLqjpJtovfvItzoWi9ehZKplGcAgZg/MzJlcAJfpJOtP5zRJLsUyIQFpL3apK65WUOJ28mkBp8afB+EV0/hQ0BNYNm7eF/bDwDjC6QReszyE7BK/K5ZWcEl/qoo7fhDwB26wI6leLGp7qRepB8xXRBwsvU9wmY3Auv
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(396003)(346002)(136003)(39860400002)(376002)(36840700001)(46966006)(40470700004)(186003)(336012)(2906002)(2616005)(1076003)(86362001)(41300700001)(5660300002)(6666004)(82740400003)(478600001)(7696005)(26005)(81166007)(82310400005)(356005)(110136005)(83380400001)(426003)(47076005)(8676002)(8936002)(54906003)(40480700001)(316002)(70586007)(36860700001)(40460700003)(36756003)(4326008)(70206006)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2022 15:32:50.6521
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e38ac41e-001b-4800-f709-08da812ee941
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT021.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5876
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Expose MACSEC_SALT_LEN definition to user space to be
used in various user space applications such as iproute.
Iproute will use this as part of adding macsec extended
packet number support.

Reviewed-by: Raed Salem <raeds@nvidia.com>
Reviewed-by: Sabrina Dubroca <sd@queasysnail.net>
Signed-off-by: Emeel Hakim <ehakim@nvidia.com>
---
v1 -> v2: Typo fix
v2 -> v3: The "right" typo fix

 include/net/macsec.h           | 1 -
 include/uapi/linux/if_macsec.h | 2 ++
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/net/macsec.h b/include/net/macsec.h
index d6fa6b97f6ef..73780aa73644 100644
--- a/include/net/macsec.h
+++ b/include/net/macsec.h
@@ -14,7 +14,6 @@
 #define MACSEC_DEFAULT_PN_LEN 4
 #define MACSEC_XPN_PN_LEN 8
 
-#define MACSEC_SALT_LEN 12
 #define MACSEC_NUM_AN 4 /* 2 bits for the association number */
 
 typedef u64 __bitwise sci_t;
diff --git a/include/uapi/linux/if_macsec.h b/include/uapi/linux/if_macsec.h
index 3af2aa069a36..d5b6d1f37353 100644
--- a/include/uapi/linux/if_macsec.h
+++ b/include/uapi/linux/if_macsec.h
@@ -22,6 +22,8 @@
 
 #define MACSEC_KEYID_LEN 16
 
+#define MACSEC_SALT_LEN 12
+
 /* cipher IDs as per IEEE802.1AE-2018 (Table 14-1) */
 #define MACSEC_CIPHER_ID_GCM_AES_128 0x0080C20001000001ULL
 #define MACSEC_CIPHER_ID_GCM_AES_256 0x0080C20001000002ULL
-- 
2.21.3


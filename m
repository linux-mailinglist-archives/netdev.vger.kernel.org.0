Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5184238910F
	for <lists+netdev@lfdr.de>; Wed, 19 May 2021 16:34:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348092AbhESOgM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 10:36:12 -0400
Received: from mail-eopbgr130127.outbound.protection.outlook.com ([40.107.13.127]:11181
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1347957AbhESOgH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 May 2021 10:36:07 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f3U6j/7AuDNIQQNQ61ruqQ1XLmnG/x7U9gpCfB3us5JP3WG5Sgsp9akWoXmHbQhH3S26i2N2/RywVGG7KJMbXTtiGqPetlESLR+6AoWQ8xtbnG9seqBS7nPga9VDaabtKd6jNTD3o8XkzQC9XFAWd7PlFGljOva2t8MKxMmFinwcl0wZgM6Qmnoq2M389foW8YRCHzfjugg9Aagfd1uuOPAXJA47tYBC+wJmqvZs+8JrZxgz0wUdeXuVpBtsRycicuiDtx6kRs2P2FvttKJjMYCw7fgPTR2fFRu3KLbshRlL6Dg5bDbwk1wDIjktNXOLKnGkezrZE+19VrDZ/tk0Jg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gWBw7raq9qTGbUe6nLBfmXtp4IZ6pjhcD7FKWBOlyMk=;
 b=BmvBuIuv6zzGdaaX9F8rWVN67gCgFq5enZD237d77fb3HUYKfXhj8jsLyNearDmIXmHd8dWL88heyMjWLvV6w7GfNcnbZ2WeGRVsTmD+/+MZ0m1lvJoWGzFreKPnJXgKQSE+/m5M/qty+xB/iRQRQjKhKFULW5RUJwLHGemcm2fkKSvho3qlIwObDjHPA2JcTJMZDBlNHlOxWXP1nAv2WPEthsxINe2Gyoc/PxUUsHoyQO9clGrfhyi3g73i1QtMhAj/EKt6VBLtC6a6nBDqwSXTqQOUKd3Ww1GVQRwCLU/nQPEPcaQZ1qXDOqGdJqX9E8bFvi6vA2pCyAPIXH57tQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gWBw7raq9qTGbUe6nLBfmXtp4IZ6pjhcD7FKWBOlyMk=;
 b=RlXMfWNjGPxenHGsaXNm2ODbmzCeqY6WOeL+WZtdDWqZL7nYJYgKrGf2L6Zea7aZ3jHkZ/OoG3P0uF2KEE7xIz5FSR4WiEIwTXW5RjV8cTor+cnfk+MjXmxz9+P2tj2nzy9lxM/y4cJnAdHfxBvGAoagL79rZSsWh241VfRr/5s=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=plvision.eu;
Received: from HE1P190MB0539.EURP190.PROD.OUTLOOK.COM (2603:10a6:7:56::28) by
 HE1P190MB0025.EURP190.PROD.OUTLOOK.COM (2603:10a6:3:c0::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4129.26; Wed, 19 May 2021 14:34:45 +0000
Received: from HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 ([fe80::edb4:ae92:2efe:8c8a]) by HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 ([fe80::edb4:ae92:2efe:8c8a%5]) with mapi id 15.20.4129.033; Wed, 19 May 2021
 14:34:45 +0000
From:   Vadym Kochan <vadym.kochan@plvision.eu>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Vadym Kochan <vadym.kochan@plvision.eu>,
        Taras Chornyi <tchornyi@marvell.com>,
        linux-kernel@vger.kernel.org,
        Mickey Rachamim <mickeyr@marvell.com>,
        Vadym Kochan <vkochan@marvell.com>
Subject: [RFC net-next 4/4] net: marvell: prestera: bump supported firmware version to 3.0
Date:   Wed, 19 May 2021 17:33:21 +0300
Message-Id: <20210519143321.849-5-vadym.kochan@plvision.eu>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210519143321.849-1-vadym.kochan@plvision.eu>
References: <20210519143321.849-1-vadym.kochan@plvision.eu>
Content-Type: text/plain
X-Originating-IP: [217.20.186.93]
X-ClientProxiedBy: AM5PR0601CA0074.eurprd06.prod.outlook.com
 (2603:10a6:206::39) To HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:7:56::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc60716vkochan.x.ow.s (217.20.186.93) by AM5PR0601CA0074.eurprd06.prod.outlook.com (2603:10a6:206::39) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.33 via Frontend Transport; Wed, 19 May 2021 14:34:44 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bbc9823f-9f0b-4d8e-2d38-08d91ad33f1e
X-MS-TrafficTypeDiagnostic: HE1P190MB0025:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1P190MB0025255B89BF2E39B35BD974952B9@HE1P190MB0025.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:102;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /WoKp8XNmGiPikXnYTk6aD6/+w4aJ7emdMUYyiZ/IZoWQsHDq/wnpu1/h52BUuEEHnnIXQ4u7qcih07WAzSkbqk3GGmLT7iuVFuHAv/bDf2nZefWlOfBK9+3c7uSEuwh/nxsrUR7aNQG+QEPaRbZn8TFMjCGqwFFca9o+IUuKQORiF3DucJnnr2W4TjofshF2VK8bwx2f08nuQGiUlV5RNRXRZU7gNMH+zEehHtnr01aKVqXwZcBapkqzSXV0/UMTv1joSVniOA8nlpmkcJ1W9iWWsANvkWENspWhpMWksacywyJfYPwnP4dQMuKg7j7IbGms8XBTGaE/Mo8gUykQl7l0YjRPdIBw86Ey9qdecuGfF5SiWT1FaQv9AS0eTyhbgMpfHGetk0/u9IabJrvCy1DNzWzXCcHDxUNFTLGv2dpj6QHBVBagKaRmN1jOWo1/cKVQn9nwnC7goH3gfEw9+5XqaWIJq93+YbII7iYaDWG1VpUIGs+2RdSejW2YJE7AAtUiMNdyn8jDDU0gRSlsX3hVgNUembgPJTtOoKh31cncRn1YcKySVZ8vO7y1egl/0u3Pqc88aTWuopB/y20rXkWcL260quLPm5PLh+LKGu8oknpCO+/+izmInReAk1LUg96Yzg0MOEtUkYJMr2GTw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1P190MB0539.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(396003)(366004)(39830400003)(376002)(346002)(136003)(66556008)(66946007)(38350700002)(316002)(66476007)(38100700002)(4744005)(5660300002)(86362001)(52116002)(8676002)(54906003)(6666004)(1076003)(8936002)(478600001)(26005)(110136005)(44832011)(6506007)(6486002)(16526019)(186003)(956004)(2616005)(4326008)(36756003)(2906002)(6512007)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?gtbHhvJPFf89vounfO76wuQ5UExbhYEkGZjrTZJ+Sj6+EVenVonhgOmwFf67?=
 =?us-ascii?Q?aym+Sycp2/li45peN2UCgvnWZF/WHcCskTt/L4ZJ3oCNwAMgfEz44H9KzlwT?=
 =?us-ascii?Q?ReMlTwHv5QOMHyUL20Pynq+n30MNi+jFck+AnZx5+kTDcdDTDXCJB70e22wy?=
 =?us-ascii?Q?ngPaCpLkF5WrHFAaqtXmcPpJeV07Xrb4P4HWxoTczO7xgoyZR97uqevJAorO?=
 =?us-ascii?Q?Ho5QZnWO/3Oqq6EevazQfc7SuHVwPaBzaO7XcyH0Ko1JtYWS04pxF5D/tRrB?=
 =?us-ascii?Q?sWHpnl1ps5O21qlOYnUaTkXNhO/YMcyFcKiYmA7+gpD5xhQlCiUju9R2GIHO?=
 =?us-ascii?Q?D+7Q4OfHRGX5j5Qvh5hQkgZmo6W2+MiUMwlFpGNzVAavSfoyIsCK6gDZn9NP?=
 =?us-ascii?Q?rXiTGrudsYrMCBSBf+/GyRGvpni8MdtOxoi3+HVN7jr3EVWP4aE5NxdxcXGD?=
 =?us-ascii?Q?pCAQ4pQaXwOGTjr8+DyOKg+Cf0bnbAG6msbDHf6GEGx/Gqnp32UbVUZLd/gX?=
 =?us-ascii?Q?Dn2YZD3eCOEUJ5XMWCcUsl9dVTYKF+R+tEEjcsRTjf4F8vRhPwx60+l7Xv/G?=
 =?us-ascii?Q?HdFx+WIX8liWu8wnT8jISTtpFJEQTjL+LVD6r7wodrR5O8k/SMSry/a6gK0E?=
 =?us-ascii?Q?ReEUd1lkCEbkwZbRpvRePJZWZhzH17YK7ry0Zq8zl8T4OYfqk0gsOuuGfsFQ?=
 =?us-ascii?Q?kbFAd8wJ1yDl+f7EPGR1Xz0LgsBAKlBX15EGbFsVC5uaOzeh/1ZucU8ctjh0?=
 =?us-ascii?Q?vrXXLWfpWRdEtjn/n4+S9agxZZRXcVIhTrNOBNbvi4hJAtpfH+Px7lzaFM6X?=
 =?us-ascii?Q?UQBM8H7l4sGz/rmtKZmF8H23hFZGsrDRmwkmswteIKHsfh52ghbu2lF8tuFn?=
 =?us-ascii?Q?yLus/eIf4/AUBXaWKm1h/7t+gjM63ItGtoAPkiPBEECpmlILTEkeSX8XZOZn?=
 =?us-ascii?Q?5aUW2DJeh+7T20tS7Qsgsrh8JPuiNQI+h66jL91tHfr+WLRxhs+uzkcAnAA5?=
 =?us-ascii?Q?O2m8voD+znkabkTGFdNfQq06K1cpTVV+Sd8LtFBvwg18OsZVASeem168l9Gd?=
 =?us-ascii?Q?+evc90AAM0okrE+3BS1hhkvyIvH+vXxzxRo6e80u5mZJu+STiNQt0l/N8Wka?=
 =?us-ascii?Q?WQfMLpwNmqx6+q2oVqz54njaPfZoSc75hdBr+zNvdW3Cs2STmSpBVgyw7qvC?=
 =?us-ascii?Q?/+4mhoCSTXYFin/J3Vf22K5W8S1syKARqbjPXXTPmdoq1vhQVt2o7JDfjD4i?=
 =?us-ascii?Q?S0nSpOPgtUkjGJeQH0LbxAjyjzkN+l7vxKCPFub9RnMEkvjNhK/Z83VslHi/?=
 =?us-ascii?Q?L74YKp8PgMfzhhQleqh/+lw3?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: bbc9823f-9f0b-4d8e-2d38-08d91ad33f1e
X-MS-Exchange-CrossTenant-AuthSource: HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 May 2021 14:34:45.1238
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: P81jmp6zl880mUY5+hfNzylN5WQm4vKsiXh0zs4rbFZZVOitMZ19OE2E7bJ/Aj4N2xSDbe1ocTjSQXa1UEBR+L336riFfIwTZ00NMhHfzeg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1P190MB0025
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vadym Kochan <vkochan@marvell.com>

New firmware version has some ABI and feature changes like:

    - LAG support
    - initial L3 support
    - changed events handling logic

Signed-off-by: Vadym Kochan <vkochan@marvell.com>
---
 drivers/net/ethernet/marvell/prestera/prestera_pci.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/prestera/prestera_pci.c b/drivers/net/ethernet/marvell/prestera/prestera_pci.c
index 7ac045e82fab..e26f1d93606a 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_pci.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_pci.c
@@ -14,7 +14,7 @@
 
 #define PRESTERA_MSG_MAX_SIZE 1500
 
-#define PRESTERA_SUPP_FW_MAJ_VER	2
+#define PRESTERA_SUPP_FW_MAJ_VER	3
 #define PRESTERA_SUPP_FW_MIN_VER	0
 
 #define PRESTERA_FW_PATH_FMT	"mrvl/prestera/mvsw_prestera_fw-v%u.%u.img"
-- 
2.17.1


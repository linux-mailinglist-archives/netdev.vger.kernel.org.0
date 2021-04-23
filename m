Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A9AD36968D
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 18:00:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243227AbhDWQAh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 12:00:37 -0400
Received: from mail-vi1eur05on2101.outbound.protection.outlook.com ([40.107.21.101]:55911
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231401AbhDWQAf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Apr 2021 12:00:35 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O9XYV1JHdTVto0ydv9flGQlWGejGHrc1OgcwUOvej9H7/AGebLGWXv0eqOUC9PNkVRXDhdnimUiEMlA/ct9r9Jav1h8ifYvQ/mZCeKda4x8dGC31LVweNzIYwCQdkWum4DNlTqNjER57FfgEbesUjYYWMgLpbxMIBbzpfgH8EFbb3ZNQirg073RQ3+4BuBD8VAdOInj+I+agrMrwQ9t3Lj+RpIZFFanewdxEYw95AKmpInW5RTMF+RKurCLUGf5K2uD46NQZuXUaXfYvTr1Q48h/sXtgMEf0jBwK8ANn6JLuOawSo9UIjJ8JpQTdb6MaFSlPwkzQ9AgajFaQ2DVptA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5NKXDFpJvS5LZiIYIqD/TwjKaHwmi/y80w80rBqpHiw=;
 b=BoAqkpP6uvAfK3Ic+/juHFhxJYTqbhX5N8WB3nkEHllgf/tijNjLG3AIOhUhAeiiRPRRqSZ7lJ5reyLJE3c058H1/hRCNSRWQRemTar2nWkPW2IISr4HVKYYg4PNFKLs8DhgmmYo4Mmb2jMfCIqTnQriKScKIL4kcMxqcwxruyDjx8JHCx7NR7GN9vQgRKgPS5YKa1DchzzJ9+T0vKVWY7e5BWuuDcAYN7h7YBhWZuPf/0ZhvldCFXHYLgZr40gqJKCFkkjPuciZRyZxu+UqP/G+SXuH7fq3VSTF0hrtjSl6W24kTjOhHYTv6XMVwlTW23mdak4kVnZUBPs3q0XUIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5NKXDFpJvS5LZiIYIqD/TwjKaHwmi/y80w80rBqpHiw=;
 b=i9eoXHYgqbWUjzIqXRfiavEcHWGb9sAeYI6hdpVGY4W7ZvSwRsYq15Kl1t91vzXcpNRDKQnbSLSq2Cvp2G52mSeoFvng76zO+y0yjZ6DWf3RHyowBYIw/RKD8ibK5GZUOaraeQ/rJAPk0t5WczB2UT5TmbcI4eOOqKzAX/OhrKM=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=plvision.eu;
Received: from HE1P190MB0539.EURP190.PROD.OUTLOOK.COM (2603:10a6:7:56::28) by
 HE1P190MB0187.EURP190.PROD.OUTLOOK.COM (2603:10a6:3:cb::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4065.23; Fri, 23 Apr 2021 15:59:55 +0000
Received: from HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 ([fe80::a03e:2330:7686:125c]) by HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 ([fe80::a03e:2330:7686:125c%7]) with mapi id 15.20.4065.023; Fri, 23 Apr 2021
 15:59:55 +0000
From:   Vadym Kochan <vadym.kochan@plvision.eu>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Vadym Kochan <vadym.kochan@plvision.eu>,
        Taras Chornyi <tchornyi@marvell.com>,
        linux-kernel@vger.kernel.org,
        Mickey Rachamim <mickeyr@marvell.com>,
        Vadym Kochan <vkochan@marvell.com>
Subject: [PATCH net-next 1/3] net: marvell: prestera: bump supported firmware version to 3.0
Date:   Fri, 23 Apr 2021 18:59:31 +0300
Message-Id: <20210423155933.29787-2-vadym.kochan@plvision.eu>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210423155933.29787-1-vadym.kochan@plvision.eu>
References: <20210423155933.29787-1-vadym.kochan@plvision.eu>
Content-Type: text/plain
X-Originating-IP: [217.20.186.93]
X-ClientProxiedBy: AS8PR04CA0147.eurprd04.prod.outlook.com
 (2603:10a6:20b:127::32) To HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:7:56::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc60716vkochan.x.ow.s (217.20.186.93) by AS8PR04CA0147.eurprd04.prod.outlook.com (2603:10a6:20b:127::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.21 via Frontend Transport; Fri, 23 Apr 2021 15:59:55 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4a4f458b-6804-4e53-24b9-08d90670d6ab
X-MS-TrafficTypeDiagnostic: HE1P190MB0187:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1P190MB01872769BCCB9BEFE61A806E95459@HE1P190MB0187.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:102;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HWK6oKZ0wlVX7qOmrziDs9eYH9RIA4vXvw7toR6AEp8bbPTlmKaCCXf1dcfIXO28A1l+pKpI1pwU6IcZEYVSr8/bK9Xhb08FoZsSZS/hcvoXtjFJIXPjW3WEMtlIVvLa49aNspfikEkp8Pd6EiXr3eWE7taWOe7a+0y0FIOXpPzskPrZYS/ndVsfYxYiMGj/x8A/0Irby9qVQqK5CfhrSxvA3IpbW3s+7zgYJ9chpz1d5eWbjvelxAqqpKRzSY6JzB/NEVzN6+qp493SFzuA6/z9Pi0w1MEkWCyBr0dwki9KDoSQHvI0fOkpnIwJCr6duAAxJLwiGbREhP4LQHrQi4Mka2i5viG4U+2v6I7fcC2oVpP7ZQNzRqLM15PoGImgYFyeUEzfNRbaE7lO3RYM5qz66ex0OCrrE93CHs/8757mTQKI6ZiD0gq5FBmYdVYtCF8db4k3eqZUGEKNVFEJQBxSolimUGSLQjYSdDeR7sCVrWOnAEu1uDExRuMTRUCKMxTnWxoL8B7uUuDBWtDvs1zYyvFuC7Cv859X1fwqGz8O2OczXF6aBEt7CjDFjjAwu17tXNZ6QdEO7JuNzyITM74ukM43/apOAed5+hnnGers+QgBcbFNyTNWssZs3qPd9nqidjsRzzbXtmYEVDfCAU6PJY9LCqnfC/0513bSuEs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1P190MB0539.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(39830400003)(136003)(396003)(376002)(346002)(366004)(86362001)(66556008)(66476007)(6666004)(5660300002)(4326008)(66946007)(186003)(2906002)(316002)(36756003)(1076003)(6512007)(478600001)(54906003)(2616005)(4744005)(110136005)(6506007)(26005)(8676002)(16526019)(8936002)(956004)(6486002)(83380400001)(52116002)(44832011)(38100700002)(38350700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?jvZjQH6foBClTlGFnhwUsWTAmIs2FBbpUTYedaPid9sAJC+NMap4He+qcQKU?=
 =?us-ascii?Q?o6a5xIKtCNVgO1muiveejQItT2vZweHprV32PxqU8exVlURbmwOEFVQjHbDM?=
 =?us-ascii?Q?NDi5NGlabM4uB+p8/7WRwfrI7DptobYniZhoA3a8XG6KgRyge1e/JUaxUPF0?=
 =?us-ascii?Q?ygKLDj2hIcRf2xtqP864vkt8916jkQkzW7rcyqAl3ROgxo4pYtMnMz5Bg9Od?=
 =?us-ascii?Q?cUGtRNA9usp1jyaIlW01e9AX9sokwcPiFXiiQI1RmFfBpNz6bjTyYIWexJgg?=
 =?us-ascii?Q?Qdj16z6Z36ceQ8eHBFyPYmusxtlfFvzQ9h07fPaq9CDKiM0KFGryQqCU5Ffh?=
 =?us-ascii?Q?sYER677QBTKO0eZS8K9J0zdcs3vQjm3Ya6WY6RmuHtdfczKBQIFXqGr+hdDo?=
 =?us-ascii?Q?tYI3I2jJk+E+ksiBv+NH5nQEqsrRWzNIfap8C90WXYVRTYwPqY7SETEmlcQM?=
 =?us-ascii?Q?cJ5MtS9ZDdKQeG05E1u81AXJx4hDSkP8AKdYeSSQakYa/evd+jVfq+eG4lFK?=
 =?us-ascii?Q?VzfGPLSbS4oDhY7hvSyobfFv+a3Q1xgnRq1QXhgNgPF3IHP8rgoqoA6rjo61?=
 =?us-ascii?Q?p4lifIbrwK16j8kQx0JuKQfPPeYWZJimgLe0oD8QvZ+7tXu1UEXl/q23PPxJ?=
 =?us-ascii?Q?+jdRsYz0EN4yhoe5b1hcAharFDUQToWd0FrRjBNZ38POk1yCgPL3TG5eT4jB?=
 =?us-ascii?Q?Yd9C3J6HnTdFmqpEUafCg2xxiXquv/H0Kx+icc87Xt2q6JYYNvGJ878jhw73?=
 =?us-ascii?Q?zFpxbgcH13swapW1pDU1EcEQ49nQaPd4BK2sJDtZgrZIlC6q3MmfrqZeQiCr?=
 =?us-ascii?Q?q/HQRniKOBsIWELwjfdh2SuaVAhpFrti0RXRyVJFWKiZ76SiOCPuUVhLVquA?=
 =?us-ascii?Q?6QLvhQTqlLSIapwsFqQuF7Pz/BnIQGIa7oV3Ie4Oh3X2QfszoP+sF67Bnk7b?=
 =?us-ascii?Q?gwQR/DQxszwwckDks+WU12lEuH2ZEO4H9FZOuqsysK8Ali3etYX962961z+e?=
 =?us-ascii?Q?tckm6bURrRx8ZhZdkMfhzU9VXsNBlHopt1KKjNVotGgb5mCEQfTaktoa+TgD?=
 =?us-ascii?Q?R13f1nIZ+dcXY6Zk9mQso65fT8DaaRgTj/B/AcuP7SB5Lgb+S6ExRo4L1cKP?=
 =?us-ascii?Q?QZaePSOK8zd/cZ3moZBegB76ZzR92Bu2F+6YPx2mNxBWKFfGWVeB/Zc2C+v1?=
 =?us-ascii?Q?ydyBKVI6HCMsZ4gVzuqNVVegYkaW7QtSXblp0OctFECS75qVNaT0fwEIE/xk?=
 =?us-ascii?Q?jqxUoinvw3hBUNYSKmEyXUBKBBM4G8f0Vxyj7hc/ZKMPD2ik78ZYDDc+7tck?=
 =?us-ascii?Q?0xo3Cgm0hIKZ/QBL9vfJ/cCu?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a4f458b-6804-4e53-24b9-08d90670d6ab
X-MS-Exchange-CrossTenant-AuthSource: HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Apr 2021 15:59:55.9108
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: a0+Ng55XPC14LcReiaL6Lbr0oavDofcLltWR0g7kirkC9hDMKlJdne0AkWalQGg9sMrf2hrWqDeWfxmA3RhHSpY2ZX3nRflJYKOnNXwezVk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1P190MB0187
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
index 298110119272..80fb5daf1da8 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_pci.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_pci.c
@@ -13,7 +13,7 @@
 
 #define PRESTERA_MSG_MAX_SIZE 1500
 
-#define PRESTERA_SUPP_FW_MAJ_VER	2
+#define PRESTERA_SUPP_FW_MAJ_VER	3
 #define PRESTERA_SUPP_FW_MIN_VER	0
 
 #define PRESTERA_FW_PATH_FMT	"mrvl/prestera/mvsw_prestera_fw-v%u.%u.img"
-- 
2.17.1


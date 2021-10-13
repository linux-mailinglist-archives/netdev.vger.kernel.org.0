Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AF1842B380
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 05:27:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237561AbhJMD3p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 23:29:45 -0400
Received: from mail-eopbgr1320105.outbound.protection.outlook.com ([40.107.132.105]:6144
        "EHLO APC01-PU1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237554AbhJMD3n (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Oct 2021 23:29:43 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nDIZ5LU5aQhyDfmK+50ro6PLmvtjq77e8B3LTdtiIRc6IIv0giDzhIXQTx+5bWVcS3kPKeL0xhspYphfncmaTEzq77xoEzVXqW2tLM7mHOzymkHOU9TYraX4ZVxWZvxLbZiTMNCTtopBozBwYD7zpZFUtVcV2gTZEQQnjMwbpFf7N29fa30gP2/Wg/GNS6iqAkF2yzTntmdLPirOIxP+Lg7Y4FldfjytgSU3wmFxiF85kpxX+VhpzcPKjapO6hve1jkoWX3bl21vO6EisxXHcgONicKteQ6qPY85tyQjcxA5mtLdkArWn5d9OCyvo8+TcLoVa7a7sNd73LZotk5E6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=njn5pXB8NVpeFF71Ozdeu7nXhkWZ0xqMzg6S5xs1qBM=;
 b=dU5NUZBrPIzPp4l0QXkvfnIkQFIdCrx+2Lm6NgRfKK8NbI/KsIgfjGG+Si01bDKnNMPgcQ4ltRYcOB5Kf5+BIlJpoqZMrCXe7/jMfZ9lgUk+aW8F2gLXpUeWZKqDNG/kcYXZb5QLJT8b+imbnEM+NsWW6Vrk+cHhP6ARzxRrVs/K1EkRWkfMOVt4ULb6mZWghiZ0Q+SH2SxGFHIEjZbKAtERUwKo17msn9F4UywUaLGQuD3jJSpuboYaL7zOqtvp5dgGbKmi3RbpQBjmbfSK8JccwPyCQf/31qRAoxHU62X9aFNlFUO/vINBY+CerQwccUUEaoA9fprgZNTvrzvaxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo0.onmicrosoft.com;
 s=selector2-vivo0-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=njn5pXB8NVpeFF71Ozdeu7nXhkWZ0xqMzg6S5xs1qBM=;
 b=Ksr6oWZ205RqdG5KHCyntPPRKWOD52bXnHlzw9T/82MB8mZciIGUaFZU98cN5PZD15X2hmw/n2Ip+UpeKK7aOs8eZmy5T3io867moL1IY+ebUEROKKCdX8qNdtchPVNsVVwR7UroeeE4YvjDgfxTUce6CXrnn/GGGwL9tiPpCoU=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=vivo.com;
Received: from SL2PR06MB3082.apcprd06.prod.outlook.com (2603:1096:100:37::17)
 by SL2PR06MB3243.apcprd06.prod.outlook.com (2603:1096:100:35::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.18; Wed, 13 Oct
 2021 03:27:39 +0000
Received: from SL2PR06MB3082.apcprd06.prod.outlook.com
 ([fe80::4c9b:b71f:fb67:6414]) by SL2PR06MB3082.apcprd06.prod.outlook.com
 ([fe80::4c9b:b71f:fb67:6414%6]) with mapi id 15.20.4587.024; Wed, 13 Oct 2021
 03:27:39 +0000
From:   Qing Wang <wangqing@vivo.com>
To:     Jiri Slaby <jirislaby@kernel.org>,
        Nick Kossifidis <mickflemm@gmail.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Qing Wang <wangqing@vivo.com>
Subject: [PATCH] wireless: ath5k: replace snprintf in show functions with sysfs_emit
Date:   Tue, 12 Oct 2021 20:27:31 -0700
Message-Id: <1634095651-4273-1-git-send-email-wangqing@vivo.com>
X-Mailer: git-send-email 2.7.4
Content-Type: text/plain
X-ClientProxiedBy: HK2PR02CA0145.apcprd02.prod.outlook.com
 (2603:1096:202:16::29) To SL2PR06MB3082.apcprd06.prod.outlook.com
 (2603:1096:100:37::17)
MIME-Version: 1.0
Received: from ubuntu.localdomain (103.220.76.181) by HK2PR02CA0145.apcprd02.prod.outlook.com (2603:1096:202:16::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.4608.15 via Frontend Transport; Wed, 13 Oct 2021 03:27:38 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2620a300-fc84-4273-0892-08d98df96890
X-MS-TrafficTypeDiagnostic: SL2PR06MB3243:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SL2PR06MB3243FA0C16B64D66565A59F1BDB79@SL2PR06MB3243.apcprd06.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3276;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZJyXdJH8j+NetylAC7mf7TAuHmaKgVFjVFX3/I97nkddvzoGVryUog0ilTyp7yswGVHXNF/3n+7Qo5mRlmmDFRtASG4OD6elBlCINdnvtTG8MVMquCIzYNwmuW5OyDs4FCTgd1Hqq4LRkWrjF3NJxT/aJ9V6sT8eqgyQIOyCbbPLk5FRVZb2ojB2qKjid9W/DkhP+g1Q/zoqLnzZC5bHgg20imKhEx7lXJjNWzl502mWwmFeykpvjFdhHDXhveVezpaYI7eQJBuDLEkZy9jOmn2xBMEXf4mckZW5GXpSsbgTL+CG1qzYK1rnlW469U542DBozR9LVYAnH5TNWW7DJDK0japp5iOlQOu8wmJVqqTHY0TK1HwXqYnuVVUHYs/XyOneZQScq0meSOKdLFzug8gX+jZ0PoLahHDO6t8ct9cGMn8jqgdNZI+zF2X+AoKnYaWFJ2/jBEHnULEyHeymDd53MJlg0Nzs0c6sf9Fd/RXFN22DLZOD3X3Seh/6RYDJHIlAmY5xKeIfiGE0+Zvs43tdLKlf1kg4DCDvh8zbA75FyTkgjhlvafTjGxZSpy8eKCPUlyPJr+X9N4QqL+N2b/J2iS11eL1kU7gY4znIRMCWKtusx3cnZn4M9qRvCCZdOWlyzkM2J0CPtiZYB4TUrMzB5DYVCxNuHPg9gurT7l/7c9+sOUts47CgaifLaI+CQoRVtvGkEtN/55abpRvOc8FfzUc83mrNP0fn0U2dnVQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SL2PR06MB3082.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(508600001)(2906002)(26005)(6512007)(4326008)(66946007)(8676002)(36756003)(66476007)(83380400001)(38100700002)(6666004)(66556008)(38350700002)(107886003)(316002)(52116002)(186003)(8936002)(6486002)(5660300002)(6506007)(110136005)(956004)(2616005)(86362001)(32563001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?nOhKilepihBeHhVJwqGyI0GW8EDLdwoS0kaceJHYxl0MJ5t8yx1ZGUD3QVDf?=
 =?us-ascii?Q?tShohGSar0Q/9I6dO7M6+TEXQ0XmECHCGxht9ak0VQ8gte3HZWVttaAy41JC?=
 =?us-ascii?Q?imR5ZVhu5f3pRqbzoLVVD7vaaP6WEdgXYuu2MDjUZAnNX/fNh3C/rtG1gGxY?=
 =?us-ascii?Q?sdZck+NWN5xNgXZH4q23LeBZc76KsTm9aX575qqF61lSpuFC0Kn8YNbM9jwc?=
 =?us-ascii?Q?KSz6IYAIX7PJRKAADkUdTlit1EAa3noyOUuxh1v2uIYsf0Qb7KpTYRH3buzl?=
 =?us-ascii?Q?FC2DBHXmiN9BiHywEAyUAyeOAIw8bRfnIn5k2tQnMR5+9Ch6GGaaCbHaeXgo?=
 =?us-ascii?Q?MJ+PjZstIuTxl17T5/qp+qnAi96zzXB0RAx4N9q9xQucv2sfg8fpBsJ5AsCs?=
 =?us-ascii?Q?1tlplnyjOdRzDFXzE0+9mUUpL6QEMwmCr9c3BAvE7iSVZxHaWZqquYiPji8G?=
 =?us-ascii?Q?MhkxrFgZxT0HKtBuWXp/PNDB4lJqJ14Ou91UPaBELMqqHpGzn1V3qKi9mmgN?=
 =?us-ascii?Q?y5P5QxB94x4XXeD2wdtMMAE37v5DqAgO+lfq4bIp+IGZH1EoLhhXe0KeqbRQ?=
 =?us-ascii?Q?QzgIsV+v8mKGNu6mjVaCe+naKCnDGPy5/BehgaFLsFcIQVnBAssjKQhmFYWc?=
 =?us-ascii?Q?h+jPo2Hroj1a4Y+Oa0/VQB1WXt7MlWnjxxHFzQGLM+hYXN8Vlquf1oW/wKTu?=
 =?us-ascii?Q?uV7iknRDGa1LNQCZwEywWh0SwC/lU/6Nga3Qh3FqC8Feik0a1eFGssx6U57R?=
 =?us-ascii?Q?/UbwQsg3Nd07VUxix82XmoYevLW8ukgWyKXbnCBCG6GN1FG7Kobyx4VsZJVN?=
 =?us-ascii?Q?DH54Kbub4XuBWlpWRkkPCF0s6/nAC9YZ/VTXNb1ogD6FH2wgSEr/erGKCHsB?=
 =?us-ascii?Q?FF4siPA7mYxlwGmIIy70hX66ONjLkmXD44OUnsnaiQxxYLXaWJYrV0BQCbb4?=
 =?us-ascii?Q?aec2UgMedt597/POt5C6OvpumuYYt0ESKmeusULj1Pvgl/+xR2R3vaRrdVdI?=
 =?us-ascii?Q?OiXxPA2K8titfS6yqG5v9Nr5pwcCojAVPcFWQX4/biuydrGPnK7ppPEc7Ckc?=
 =?us-ascii?Q?NVuriM2fF2E0S24HZ2W5PYRCqbmtHH4uU1GMQMu5iBiDnlHqjnyLaZbVWJIZ?=
 =?us-ascii?Q?S9Faqufus+w8iCH6NewJg3jELu2l3xmSAAUeQuRhUTeT82jdNk0WMo9g6Uxz?=
 =?us-ascii?Q?rx99NwNx5D71EVf6m+qWPcVs199mFXGOs4x1GW6IK25QzGrDoe48GS0OaQJa?=
 =?us-ascii?Q?LwXgi39PQAIjU1aPdkKmAnA80+uK7AptqbEj41vb6s+2/TPQbCQhGR1YXWUG?=
 =?us-ascii?Q?mm+5sDYJm6Uj/YO3QyIlzQUk?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2620a300-fc84-4273-0892-08d98df96890
X-MS-Exchange-CrossTenant-AuthSource: SL2PR06MB3082.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2021 03:27:39.1608
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BAM9H7yVpaucayd4rQ16Br3gLOF5lUzIWyoOvUFrmV+3rI9Ft1eZCj8tj9bhuvYe1BlEaGP5MH9pu7FoF8E5ww==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SL2PR06MB3243
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

coccicheck complains about the use of snprintf() in sysfs show functions.

Fix the coccicheck warning:
WARNING: use scnprintf or sprintf.

Use sysfs_emit instead of scnprintf or sprintf makes more sense.

Signed-off-by: Qing Wang <wangqing@vivo.com>
---
 drivers/net/wireless/ath/ath5k/sysfs.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/sysfs.c b/drivers/net/wireless/ath/ath5k/sysfs.c
index 8113bad..37bf641 100644
--- a/drivers/net/wireless/ath/ath5k/sysfs.c
+++ b/drivers/net/wireless/ath/ath5k/sysfs.c
@@ -14,7 +14,7 @@ static ssize_t ath5k_attr_show_##name(struct device *dev,		\
 {									\
 	struct ieee80211_hw *hw = dev_get_drvdata(dev);			\
 	struct ath5k_hw *ah = hw->priv;				\
-	return snprintf(buf, PAGE_SIZE, "%d\n", get);			\
+	return sysfs_emit(buf, "%d\n", get);			\
 }									\
 									\
 static ssize_t ath5k_attr_store_##name(struct device *dev,		\
@@ -41,7 +41,7 @@ static ssize_t ath5k_attr_show_##name(struct device *dev,		\
 {									\
 	struct ieee80211_hw *hw = dev_get_drvdata(dev);			\
 	struct ath5k_hw *ah = hw->priv;				\
-	return snprintf(buf, PAGE_SIZE, "%d\n", get);			\
+	return sysfs_emit(buf, "%d\n", get);			\
 }									\
 static DEVICE_ATTR(name, 0444, ath5k_attr_show_##name, NULL)
 
@@ -64,7 +64,7 @@ static ssize_t ath5k_attr_show_noise_immunity_level_max(struct device *dev,
 			struct device_attribute *attr,
 			char *buf)
 {
-	return snprintf(buf, PAGE_SIZE, "%d\n", ATH5K_ANI_MAX_NOISE_IMM_LVL);
+	return sysfs_emit(buf, "%d\n", ATH5K_ANI_MAX_NOISE_IMM_LVL);
 }
 static DEVICE_ATTR(noise_immunity_level_max, 0444,
 		   ath5k_attr_show_noise_immunity_level_max, NULL);
@@ -73,7 +73,7 @@ static ssize_t ath5k_attr_show_firstep_level_max(struct device *dev,
 			struct device_attribute *attr,
 			char *buf)
 {
-	return snprintf(buf, PAGE_SIZE, "%d\n", ATH5K_ANI_MAX_FIRSTEP_LVL);
+	return sysfs_emit(buf, "%d\n", ATH5K_ANI_MAX_FIRSTEP_LVL);
 }
 static DEVICE_ATTR(firstep_level_max, 0444,
 		   ath5k_attr_show_firstep_level_max, NULL);
-- 
2.7.4


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A9F052697F
	for <lists+netdev@lfdr.de>; Fri, 13 May 2022 20:42:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383253AbiEMSms (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 May 2022 14:42:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348518AbiEMSmr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 May 2022 14:42:47 -0400
Received: from IND01-BMX-obe.outbound.protection.outlook.com (mail-bmxind01olkn2085.outbound.protection.outlook.com [40.92.103.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36F82BE0B;
        Fri, 13 May 2022 11:42:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lbTN6sOaPVFx79bMqFMJeImYxbLZi5Vr/vuMMhkNFG4hSRAc9s7GuAtJ48zd5mDPm8MHUPq0yNflgyTwWXjUUQv9bf8QZioP000gFIjItV7AhyRZjJJ5C6Q8iWvkKMgk4Cz5dkKjJa/N5HKsfeh9iFuGBaA/dONJqY1jaosEVeWUMauBxK7VTWwCnhiE93W16n6WFGuq6CHgCyuExx6HFx/Ie8FO5lCtNozPcmHhBCjBFBOqU+YeHISSk084T0fS0OBuBMNxv5DealoDWsmCLbwIelNysXKlI2sMiksStMD47+u9ErqNq2nlTgK78tAkNMWJxf1EahcPaIIRStmvNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1mF8aTcZQd/8S8CC8mOSx3C0tXDgJc2YfYKQlVJ6nn0=;
 b=ZmOrOwHvjSQzcj2faLbXDwRmXVl/FqzIeE1RhYpqgd1bW2dO8MBbuVDUvW7uz/SqRSHTQqvUzW3jH+qJwaD0qkxIC09Fb7kBrXRLtpc6nd1QBteaGo4vKU8mtxWoNdmOrsabrxoEklqlIQLnqvyhggw8Bmi/YuAIqSehnd1YbsGh2zJMqt+aEjh++QfcO4ob6A1hb2BQXf/CveJ3zEN3aXqb4UoNlzXU2BRnMUWidoHYRowHE7KIdqhxA5Qx1rwvkn0syg5DSRFMrNvMjGwyDyGWt4EHh5n88fq8jSmnTLiPhQeSnRRidXndnwE3iUWzchkiQ9WbUZVS7AU1bLUjwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1mF8aTcZQd/8S8CC8mOSx3C0tXDgJc2YfYKQlVJ6nn0=;
 b=clUgWsax1GOt/DuUyDa+WGa0fULhfyYKOfK405ny9JsP1sCV8m/mezVDklXi01Ht5FNHZjEtbss/9Z1VnDGdZS5rGv6K/KI71+Fs2IuKkR14VrAmBRL8GzTCHnuxnDXYxcZBHXLWHka+N2y/6RR0YgDD8AmHQLCphA1tnKvTmQgxgqNUB7d84Ppehwr4pZ57wOc6af6kgZL5uslDBirZ4AXPH91I/HNXeRR5xc10qgv5y0e8g9TK9n8KFeE0/M16JqFjFtLRTUlA1VGLYwgAZRhRTPYAlU+A3DhTuMHvda87nX5/5sp6rKUS49xq35H3DR/uhdofDHoZX8dDUoGPcA==
Received: from MA1PR01MB2699.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:3f::13)
 by BMXPR01MB4870.INDPRD01.PROD.OUTLOOK.COM (2603:1096:b01:17::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.24; Fri, 13 May
 2022 18:42:40 +0000
Received: from MA1PR01MB2699.INDPRD01.PROD.OUTLOOK.COM
 ([fe80::5d49:a134:d234:58f2]) by MA1PR01MB2699.INDPRD01.PROD.OUTLOOK.COM
 ([fe80::5d49:a134:d234:58f2%4]) with mapi id 15.20.5227.024; Fri, 13 May 2022
 18:42:40 +0000
From:   Srinivasan R <srinir@outlook.com>
Cc:     Srinivasan R <srinir@outlook.com>, Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-wireless@vger.kernel.org (open list:NETWORKING DRIVERS (WIRELESS)),
        netdev@vger.kernel.org (open list:NETWORKING DRIVERS),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] wireless: Fix Makefile to be in alphabetical order
Date:   Fri, 13 May 2022 19:42:20 +0100
Message-ID: <MA1PR01MB26992E104B006B340C3C3A84C1CA9@MA1PR01MB2699.INDPRD01.PROD.OUTLOOK.COM>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-TMN:  [eJfLUKHqTDCs7xOpCVGMpU9avnVwk4u2]
X-ClientProxiedBy: LO2P265CA0120.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:c::36) To MA1PR01MB2699.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:3f::13)
X-Microsoft-Original-Message-ID: <20220513184220.15086-1-srinir@outlook.com>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3241f213-f080-409e-7485-08da35105bc9
X-MS-Exchange-SLBlob-MailProps: mBRmoEB1kyL0YvOEiR9yBstXttwQywY+o0uPrARMIdrSWdLN3OwdPgZ2Cvxdyz0jQmI/a9o/Ode5v9KHSFi8gHsmPuAwRdauDJ9j7+LfSOwEyURTayyCdHhf85zdOnPIF9xsebjYnT/ebSBAAZY+vKuxKc6ybscgq3ns1SgDPgDXbpAMdjdoaWBx1uyUfhWTdLtmOG5Gw2IqLj6e4fFH7DLqhXV8QZmjuc6Jm3Fo9AobgWG2LOjDHtsf+2aHM1K4LHarEjmG2fcJlkgSfus5tG4Xlpfv8EGYxejQ3cXVvY4Kv1txAsr/lVVkRrtjzYtly38JxOPLSxtvR80g4hVDXAWkQiloyJ4WLEOlITLzyaX7tlMvBUKzoJMH7a+/f5n1OowaZ1DvbH7PWOzRC3QT1tvj5iu9yTli3XJfkY7Jol3B3kvejO3hcGwSHseqt3gUtyTYpc1jVMMDvDZaAcSHi1fGBrv0XXyNhiMg/EaHSXN0UYBSGmPBO0M351j4PYotl/LxX04xNOvkvr9ekSSyMv6Ql+7Xbn5fbTD2MBcle0lQttdHnv0ouCiMLsH4qVCP2Fz7VG7qWPa8gRiB+N4mOtVKOJ01coGnkNd8v+Q1vQo4SVTfiT1dfz5r509HKqjvYWvvfCf60qhUifv/pIx15PIZQXOkup9uJdt473ARTvBm61E0d+Ez0ePqcpJIP5FdlN1WpyAmmyheneQiV9vfOtfVmJLmnAkx1+rM1hgHgn55WGxqS/ikOvHok3EtmWJrAM/mFMHojAw=
X-MS-TrafficTypeDiagnostic: BMXPR01MB4870:EE_
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /hH8J1DP/4lKn3N5wQ4ZuDcUkHfihqtMl28+nk3wojNPL27J5I7xXiEUQK5Du3RUR2I1ePGhh47SQ2vCUasPSIkBzRsMp5KEjkUMp0QSuint6bXbas0Zh8PMQHW2GWtk1XeqrJd3KGjQCpaLuiRsGXFg9uzG8nzb8lCx6ki/0FmCglIEFQp087yJEc8Ooo5wgSo+N87Nrqyl3cphEGmXVg/8h+QKU3ddHqseJAf6aHvcpa3y23TXzcWoYu0YEWx4U0HRSX9mYp0rOrGJvhfxBAikimta63UBXtcPOkvtsM9shuvd8ik84zSJDYrZqfz8P7TIzhGuA7VPHuX1jtlxSu2I/hlB8Z2Wve2dwwA3JHnuLJ2/7nCIta2soWoXFe3ImL7UA9VObn8M4/ccyRgNOhgXQvDkSK2b/AHk/Pe7QMhG0zp+J3n1MktsTGHVHZ2A7Hg7CKHTsNjfxARVPBTCQaZmYFiQENhJK+IL3tSj9cQYRxw2d4VBUUVcn5nmuGTN4gVb2I3Atm/jeAaCvsrv501i0fAwntC1fAlOjs/VxqHf0ntVrep+oHaEZDZgV96YNkN1rCSX1g+ul6qjDS7i5Q==
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?GV/Q0VXuApsqWxm5ByhZ15yaf9T4Dhsubgl4JXbHH27vpgxrDuUqiEmTqxb6?=
 =?us-ascii?Q?D/fr5zxIMqjAg77TMEOxVFHm4g59wy9EbBWgk0Q0eF8zCOGkdCh+5iJ2EX1p?=
 =?us-ascii?Q?nn8rCltFeSsx3HhmuFenP8P805k1dlP/HBqPKIR6Ie2VCggWEopb3DYxFbx5?=
 =?us-ascii?Q?MMQeudsenKOOc1a3qNC9swa++jgM+RJVDZhNS53hf+FPTMHkmTmxu5TLds9X?=
 =?us-ascii?Q?WEJtMawDfHwcb9jO/mFItiS0SzC/Ph/0vGkr8fQOiq7WDtb0pcyXmO77tGDn?=
 =?us-ascii?Q?5VWGuHC0UV+AobKYRj/NNhIGNCAKi0e/D5bJteg0ykmAAWfTu06zG9xw524n?=
 =?us-ascii?Q?QRBE06zCXLGNGZN5pM0YlbFCvXIG7H3PuxJhjs/lff2SM8KBn/J7fNlaYyzZ?=
 =?us-ascii?Q?HWtDU5miK9HjZ+Q2qLRYxcM2zDJDeQe7KS7orrxuDFa6Big37o4RkHXJJT9+?=
 =?us-ascii?Q?ufJEXNPE087BQWt+FfC4dVGk5ef+XjLI0svnodGG113RgmuHFfp+pNBWgtlZ?=
 =?us-ascii?Q?aAxqjE5B3HJTH1ZQd32UojfjgW5/6kzUpD0N9EdPwWr+Z5fMqYbkouWBTNnP?=
 =?us-ascii?Q?XP198vSBafSU6PuUFoIdK8IUdneRHaSGcgc/c6Hzf9r7MdE82lrl1KXsbqJu?=
 =?us-ascii?Q?7O0/g/pgOKnHfDXO1STg6KXBJZLe7efdirSEV4vFt7Lax7TBZ20lXHQaTud8?=
 =?us-ascii?Q?fdTYI4p/mGZ9keiMNAJ5TDplIUi7SLAXsGIi2bEw2oAwubF2LgwhkLuze5Nz?=
 =?us-ascii?Q?fwSgMeQ9RvZ+Tw66zMSuP575F4jJjd7mpbUyrUduW77i5+X0Z6TrSCiVNAe+?=
 =?us-ascii?Q?KUoc/BvIgOQhmxzUlR4S0e0CA4t4ZLLfpc1n5+605ZTzGL5dEWFBz83Pl8ed?=
 =?us-ascii?Q?boh09XVUVt9VnzZ54hKw/tWEfJlKIXDB3t9BfhK/Z9csQ1biwC2meZ3n1D/F?=
 =?us-ascii?Q?ZweG/xHcv1ZGVHgM8Wx4/OfrzS3/QLXbZLCNEutPUVOm8+4wwK7PLL3sQDk9?=
 =?us-ascii?Q?BlR/44B25Hk/UgIww11K401YfCj8wJVW5UdfFdGzCHPVdwYv1a7Hpqw6nEvv?=
 =?us-ascii?Q?KyY9TCO04PntOW+abw3Kug0er2X3dWyi7m0+Bi7sBDUBU3k535dsRz9Raeyn?=
 =?us-ascii?Q?wTIw6UteMFYVA6biKgFmXb+oLd8PAioay0PdrLqhA5kDBkAs6tGam+/YeAFU?=
 =?us-ascii?Q?f7fdOje9IrcYxzudG4ym2vZDbmASIGG2uuOCcp+2L0ly36ze/WQ7lr6/duam?=
 =?us-ascii?Q?aWCeMu8O0fIzlDulWaBLtqD+eCru51P1IpNX4H0JMNzvFqm6Rz2Axfyk5VIw?=
 =?us-ascii?Q?Hagj1mGE05G2uBVBQfC6Q0COqTbKAyaK9es3qyuqQxdFL2qaDOh+dehq9e23?=
 =?us-ascii?Q?/Xl0FisHKWap1SdvclHOw5ygdSaNysi07iErBzqKQXxQn8Fdn1b2CQNJJbfH?=
 =?us-ascii?Q?BSl7tQq/gdw=3D?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3241f213-f080-409e-7485-08da35105bc9
X-MS-Exchange-CrossTenant-AuthSource: MA1PR01MB2699.INDPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 May 2022 18:42:40.7961
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BMXPR01MB4870
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix quantenna to be in the right order

Signed-off-by: Srinivasan R <srinir@outlook.com>
---
 drivers/net/wireless/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/Makefile b/drivers/net/wireless/Makefile
index abf3e5c87ca7..a61cf6c90343 100644
--- a/drivers/net/wireless/Makefile
+++ b/drivers/net/wireless/Makefile
@@ -14,6 +14,7 @@ obj-$(CONFIG_WLAN_VENDOR_MARVELL) += marvell/
 obj-$(CONFIG_WLAN_VENDOR_MEDIATEK) += mediatek/
 obj-$(CONFIG_WLAN_VENDOR_MICROCHIP) += microchip/
 obj-$(CONFIG_WLAN_VENDOR_PURELIFI) += purelifi/
+obj-$(CONFIG_WLAN_VENDOR_QUANTENNA) += quantenna/
 obj-$(CONFIG_WLAN_VENDOR_RALINK) += ralink/
 obj-$(CONFIG_WLAN_VENDOR_REALTEK) += realtek/
 obj-$(CONFIG_WLAN_VENDOR_RSI) += rsi/
@@ -21,7 +22,6 @@ obj-$(CONFIG_WLAN_VENDOR_SILABS) += silabs/
 obj-$(CONFIG_WLAN_VENDOR_ST) += st/
 obj-$(CONFIG_WLAN_VENDOR_TI) += ti/
 obj-$(CONFIG_WLAN_VENDOR_ZYDAS) += zydas/
-obj-$(CONFIG_WLAN_VENDOR_QUANTENNA) += quantenna/
 
 # 16-bit wireless PCMCIA client drivers
 obj-$(CONFIG_PCMCIA_RAYCS)	+= ray_cs.o
-- 
2.25.1


Return-Path: <netdev+bounces-1577-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 472C56FE5DC
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 22:58:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7BE09280C5A
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 20:58:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 132B321CEB;
	Wed, 10 May 2023 20:58:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFDC1168D6
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 20:58:22 +0000 (UTC)
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2060e.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe5a::60e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C0EA1998
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 13:57:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kJy32RGFt7UPmQtNCkYqz4Q10C48dlytaXcjDMdHsB3boCYHMNFo7mYaMLIcA+OgKuOCRt+nBpxJKcIQOZ4u18tLvYBopKn68mIGSGq3fdTdJJKsK7AK2B/dGMQu1qpozAO+AO+506ip0zbu+irFaZPUGaUi0g0MJ72VrTziaPnHtHqZvByre2EjCWymYYzCQQWMCnrCUpmwXme1TiJaNGBpG1nUzVwEwTqcJvRyVzj8Cp+BUjHCD2lIUZuBXaXu7FcC7mru+hxh0XQvfAbWj/qa7fcMpEcsulQFLCCi0bUVgXec32Kq2TZ/uRE3i4p1KPWcj3fUsVl0P7tF9KuU5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CIz6FjYJvU9aKk1zEaIYCJqwEg84tC/Okf7qwQ8z/oI=;
 b=b5TzZY/FbLx1Ku8+n74a8FC09NNPSA/Jhou/jrUNezDYs9g4OAawwzoaiaXRwbufdmc1r86BNbTJbmmBXFGSyastBrFPifV73kIvuUHsZlLAHHdDj273LJMbIzoUoIy48vO55PMoDd5t4n9FZrfDpneMfRAj+ZTG5EHv5P+obCktNiltMW3E6I1qZDpXQfvnaQ+prkvvJFjPjZcpyO9SE7uw4MsrQKhusxRZKGmef6fJD/n2v2bLnVnzHmW5YCOpJsyU6HHjiCIDpWEfhcWVsYQGKDqPNVEJb8GLRWFmjKN2KPgYBJvqXjwS9OqeZBdQAO0dZiOG1Zq5gpQrKPbfXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CIz6FjYJvU9aKk1zEaIYCJqwEg84tC/Okf7qwQ8z/oI=;
 b=QTBIIkwTtlALQRDrs7VKfTgA8xiiu62YTEnFvcBeE2b45nc82Uw3tq7ts+x4iWBnbwBS7+hmL07iv0CQE5yrLxzRjQY47NE8i2NsTxXPZU4OWVkxUOtIi+qX7lGMjKGSa7mUpSvPH9CP9i0jreA1DRTHVqDm5zeKLoswmbgZMjZB6mNB+3QUl2czfDJrmkRdlJ4uaB2POaK5XkaM3ULTEyqaJc9R5wzPycudOA4gbMmi/Bo7ze+hk+gpOEInUoACOGVNq789jyowzYG8ULKZKxkguofNXTs/C9R1L+ZmyAvUncGpcEGCsLvLo7fWrIwLQj5VS5pG2+Foh4X5NE70hQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BYAPR12MB2743.namprd12.prod.outlook.com (2603:10b6:a03:61::28)
 by MW5PR12MB5624.namprd12.prod.outlook.com (2603:10b6:303:19d::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.18; Wed, 10 May
 2023 20:54:00 +0000
Received: from BYAPR12MB2743.namprd12.prod.outlook.com
 ([fe80::de5a:9000:2d2f:a861]) by BYAPR12MB2743.namprd12.prod.outlook.com
 ([fe80::de5a:9000:2d2f:a861%7]) with mapi id 15.20.6363.033; Wed, 10 May 2023
 20:53:59 +0000
From: Rahul Rameshbabu <rrameshbabu@nvidia.com>
To: netdev@vger.kernel.org
Cc: Saeed Mahameed <saeed@kernel.org>,
	Gal Pressman <gal@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Richard Cochran <richardcochran@gmail.com>,
	Jacob Keller <jacob.e.keller@intel.com>
Subject: [PATCH net-next 7/9] ptp: ptp_clockmatrix: Add .getmaxphase ptp_clock_info callback
Date: Wed, 10 May 2023 13:53:04 -0700
Message-Id: <20230510205306.136766-8-rrameshbabu@nvidia.com>
X-Mailer: git-send-email 2.38.4
In-Reply-To: <20230510205306.136766-1-rrameshbabu@nvidia.com>
References: <20230510205306.136766-1-rrameshbabu@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY3PR05CA0040.namprd05.prod.outlook.com
 (2603:10b6:a03:39b::15) To BYAPR12MB2743.namprd12.prod.outlook.com
 (2603:10b6:a03:61::28)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR12MB2743:EE_|MW5PR12MB5624:EE_
X-MS-Office365-Filtering-Correlation-Id: d2a3e447-b016-4d2f-c9bb-08db5198adda
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	zsf4IePCJRIzrhSCCTVSeHAJ66GA6aaIC9kyzQkCgcqLmW+OOV25qO7GwN++zTSGGI/J+QMynIBGtL/rDIXvQr7nn9wI4m2PDSYYQwy5tHJYNEdyUEHOybCQ9uvBgrUYTsXS6MJxlR6gqPI/BqUYqOqFi1ZfdCD9++Ih9cJSONd0DOtUihMKLYaYQsEIQh79CDjUs4i+5O6I9d8usrBLIU7KJ3L+8j0Ps8QqU7r+nmTIwSdqmKQPMNDs0PMgMIPK/CQtO7a3muk3iyFCbuXEi4efyfduYrj/UKjp2dKHtEu6B5MqdA7057r3EI5WOPJH94uPDkOzZJPId/XmrWNqgNAd423wNdBLO3QUy/Nl4b0lIEtKOFQoQSQFK9pm5koPqeNJz4kCGPlwv4BBjLDpnW+T34C7NogRvJ9nCnzwFn6xlwx/pbUXIXzL1/xraL2w8+626+SB1xzLYtLuggyxzmu+O+fDc0lh5PbQVqi3cbyU9oX1NY6RiMFOukzm0UNAuJyrmw5X8S/Nz37+HcPcK/5XTF2N3xGKrMIXHumPDokE+rr/uUaNFohaAFOCeX+XeccJIhV+pmwdfu4ZstlIu3EKQAZV6t285JDETQx2iDdzA8Bx36lWaCmJYPfyH5wm
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB2743.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(136003)(39860400002)(366004)(396003)(376002)(451199021)(86362001)(5660300002)(41300700001)(4326008)(6666004)(38100700002)(316002)(6486002)(6506007)(6512007)(26005)(1076003)(478600001)(54906003)(36756003)(2906002)(8936002)(8676002)(186003)(83380400001)(66946007)(6916009)(66476007)(66556008)(2616005)(142923001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?W5bcAVeToVneiwp70Yxuc8bYOOaVS8YZ6WaGgyUay/Jy/mFk2P3iIBKS0uY5?=
 =?us-ascii?Q?c+AyiIga7ACK7V5INluP9NZvpuLdKctJg+flM6ha+KXfIiy+lyCQdHp63dBn?=
 =?us-ascii?Q?Te8H8EmYGC+CFv1H59UA2pY7Fr1WnCBa7YUElv0Ne6Y9PWRHwJUrVGFAolcQ?=
 =?us-ascii?Q?NcoRHAogPlInEC1uZnurDa5hfgmOIL1uWFBgh0aq+Kqw21FG19Ke9H/e9vdu?=
 =?us-ascii?Q?Hx6yTM/8+ypd+0q9JDIlF88Mv/KHxcwNitGM/mxukZnXsr288TylKsDZ4qDm?=
 =?us-ascii?Q?4TnEuYjhTJ33ehHB2Bxr5AvJ8zfdl9OHEpS0v9DdpkyTk+fehRRL+Ml7HUv3?=
 =?us-ascii?Q?15lClTPHILAX3lfm820PGfLdPO/zd4GzBDCdLfG9o1mgdgnXKxDahoK5vNcf?=
 =?us-ascii?Q?Tw3Vqsj+Ey1FBJO7uUuZyINyi1XK4XHZKEYW5wxKnhaQRmcqMa1eS+/WaycI?=
 =?us-ascii?Q?ptCQzgvMV3R3tb6Bh5HDS2WvpwyubYgZ9ZtusixrFZO8F22aBP2PJoKCJZ0p?=
 =?us-ascii?Q?zNmtdruhSBWQ9ys5Vdcb7yWG8YcUW5NVttyuFXiV0lDj/Nx2IRIQ8g3cyuLt?=
 =?us-ascii?Q?SlliGNx7eXKeZf9bD6Cp5KDjb257UYS+9muqKQGwf9QqW94BW4IbCvFYU6zj?=
 =?us-ascii?Q?sTMFXo4aR5LoR4r5+zrgk8YVy1k7gn4mQ1gBulMUtTP1w4bH1ONZ3g3RmOkq?=
 =?us-ascii?Q?H9jqZCKQ53yYE86NNzjIeZgDix8BsAXQGuH4zVn+E9qRqcDm6hXJjkjh4Nqw?=
 =?us-ascii?Q?9PzMabcMUmZKD8HE4V37BUQ37MPUx8+hY9yw+MKVcj6X8EUDMtkGV3Ai1Mbu?=
 =?us-ascii?Q?aW4shPyDckKMTHDUxQeLK35VkP5Q/xj51CZlo5r71Vm1xPwAXIVoFzkK6m3X?=
 =?us-ascii?Q?TojZTSDf3dozeST8vC6h8lepLyDZYFrm0Rjxbm+2GMLFartPzq+5H/6UjOsJ?=
 =?us-ascii?Q?/34FZZdJ6en1Q/R1IZAGRfOk/nruu++wWqlNyq27LS4OGY+lBzteKN+NssQx?=
 =?us-ascii?Q?q0Gh5A/Kx1QLMg1r4iaEuM1IW7wjF4mnTTi8B11a6IBbDQ/DfQmAXNxDkl9w?=
 =?us-ascii?Q?MKEdvXNf7e0SuH63pHn7y36bA/ArENAoM47mrO/0HP2yBQQZ8PONfvdmOVOs?=
 =?us-ascii?Q?uw58INU4HCK5pDuWW8WzB/mATTNgKZ46snUK58U4rWk1jkHi1Q3FL6BhTibH?=
 =?us-ascii?Q?D6iC4zEhYSBT5dTVBFUf9NwprdZ11qFh6ppCyIkSwzzzhxEW/asa0s/HRGug?=
 =?us-ascii?Q?hqllwJSevkC2sPJb6VMwJjyID6UG8RSHphqna50q/shd2Iw16qoGaeHXKpe2?=
 =?us-ascii?Q?bOVNJf/zKX6jrANMMYJMQ1+pShwS7oCCCpAcjGwclvR+uCxQX+K+KM4mPsOo?=
 =?us-ascii?Q?31I2LpTHl1B8ChRzeWIeU0AVdMcIj81CMnw1Vbj2md3vTKk5TW/UB4eH1lBE?=
 =?us-ascii?Q?Zzb0HVq/rH3nrMzX4rF4i0cA7DyJxU/aRNeqv0A3MZRFZl6RBJFm5vc2cwCh?=
 =?us-ascii?Q?Q9fdggnFrEknkcLOc987+mxJ7L0UOB6hrdhDRGRxm82f0/8s+KXZBV+NhDKM?=
 =?us-ascii?Q?QVzVnBCP45QtoH1GZMjiPROvVI3NHoz3IKBkSNP5w76Q5kIQVy9ekzfkrdCH?=
 =?us-ascii?Q?7A=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d2a3e447-b016-4d2f-c9bb-08db5198adda
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB2743.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2023 20:53:59.8681
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: u/FqTl/vGzem1u/0WN6zDBDJ5LoEQTAor2mAj5CMuEdsl6iJGH8e/5KPcZhh2Skt6ycA9BrshC5J4jQKohaG5Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR12MB5624
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Advertise the maximum offset the .adjphase callback is capable of
supporting in nanoseconds for IDT ClockMatrix devices.

Cc: Richard Cochran <richardcochran@gmail.com>
Cc: Vincent Cheng <vincent.cheng.xh@renesas.com>
Signed-off-by: Rahul Rameshbabu <rrameshbabu@nvidia.com>
---
 drivers/ptp/ptp_clockmatrix.c | 36 +++++++++++++++++------------------
 drivers/ptp/ptp_clockmatrix.h |  2 +-
 2 files changed, 18 insertions(+), 20 deletions(-)

diff --git a/drivers/ptp/ptp_clockmatrix.c b/drivers/ptp/ptp_clockmatrix.c
index c9d451bf89e2..f6f9d4adce04 100644
--- a/drivers/ptp/ptp_clockmatrix.c
+++ b/drivers/ptp/ptp_clockmatrix.c
@@ -1692,14 +1692,23 @@ static int initialize_dco_operating_mode(struct idtcm_channel *channel)
 /* PTP Hardware Clock interface */
 
 /*
- * Maximum absolute value for write phase offset in picoseconds
- *
- * @channel:  channel
- * @delta_ns: delta in nanoseconds
+ * Maximum absolute value for write phase offset in nanoseconds
  *
  * Destination signed register is 32-bit register in resolution of 50ps
  *
- * 0x7fffffff * 50 =  2147483647 * 50 = 107374182350
+ * 0x7fffffff * 50 =  2147483647 * 50 = 107374182350 ps
+ * Represent 107374182350 ps as 107374182 ns
+ */
+static s32 idtcm_getmaxphase(struct ptp_clock_info *ptp __always_unused)
+{
+	return MAX_ABS_WRITE_PHASE_NANOSECONDS;
+}
+
+/*
+ * Internal function for implementing support for write phase offset
+ *
+ * @channel:  channel
+ * @delta_ns: delta in nanoseconds
  */
 static int _idtcm_adjphase(struct idtcm_channel *channel, s32 delta_ns)
 {
@@ -1708,7 +1717,6 @@ static int _idtcm_adjphase(struct idtcm_channel *channel, s32 delta_ns)
 	u8 i;
 	u8 buf[4] = {0};
 	s32 phase_50ps;
-	s64 offset_ps;
 
 	if (channel->mode != PTP_PLL_MODE_WRITE_PHASE) {
 		err = channel->configure_write_phase(channel);
@@ -1716,19 +1724,7 @@ static int _idtcm_adjphase(struct idtcm_channel *channel, s32 delta_ns)
 			return err;
 	}
 
-	offset_ps = (s64)delta_ns * 1000;
-
-	/*
-	 * Check for 32-bit signed max * 50:
-	 *
-	 * 0x7fffffff * 50 =  2147483647 * 50 = 107374182350
-	 */
-	if (offset_ps > MAX_ABS_WRITE_PHASE_PICOSECONDS)
-		offset_ps = MAX_ABS_WRITE_PHASE_PICOSECONDS;
-	else if (offset_ps < -MAX_ABS_WRITE_PHASE_PICOSECONDS)
-		offset_ps = -MAX_ABS_WRITE_PHASE_PICOSECONDS;
-
-	phase_50ps = div_s64(offset_ps, 50);
+	phase_50ps = div_s64((s64)delta_ns * 1000, 50);
 
 	for (i = 0; i < 4; i++) {
 		buf[i] = phase_50ps & 0xff;
@@ -2048,6 +2044,7 @@ static const struct ptp_clock_info idtcm_caps = {
 	.n_ext_ts	= MAX_TOD,
 	.n_pins		= MAX_REF_CLK,
 	.adjphase	= &idtcm_adjphase,
+	.getmaxphase	= &idtcm_getmaxphase,
 	.adjfine	= &idtcm_adjfine,
 	.adjtime	= &idtcm_adjtime,
 	.gettime64	= &idtcm_gettime,
@@ -2064,6 +2061,7 @@ static const struct ptp_clock_info idtcm_caps_deprecated = {
 	.n_ext_ts	= MAX_TOD,
 	.n_pins		= MAX_REF_CLK,
 	.adjphase	= &idtcm_adjphase,
+	.getmaxphase    = &idtcm_getmaxphase,
 	.adjfine	= &idtcm_adjfine,
 	.adjtime	= &idtcm_adjtime_deprecated,
 	.gettime64	= &idtcm_gettime,
diff --git a/drivers/ptp/ptp_clockmatrix.h b/drivers/ptp/ptp_clockmatrix.h
index bf1e49409844..7c17c4f7f573 100644
--- a/drivers/ptp/ptp_clockmatrix.h
+++ b/drivers/ptp/ptp_clockmatrix.h
@@ -18,7 +18,7 @@
 #define MAX_PLL		(8)
 #define MAX_REF_CLK	(16)
 
-#define MAX_ABS_WRITE_PHASE_PICOSECONDS (107374182350LL)
+#define MAX_ABS_WRITE_PHASE_NANOSECONDS (107374182L)
 
 #define TOD_MASK_ADDR		(0xFFA5)
 #define DEFAULT_TOD_MASK	(0x04)
-- 
2.38.4



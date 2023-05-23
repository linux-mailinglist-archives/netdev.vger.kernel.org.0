Return-Path: <netdev+bounces-4809-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 18F8770E702
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 22:57:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C7FBB28135D
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 20:57:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D12E2AD57;
	Tue, 23 May 2023 20:56:47 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C38AB947F
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 20:56:47 +0000 (UTC)
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2068.outbound.protection.outlook.com [40.107.94.68])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7982EE42
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 13:56:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JAke74a/QzPL/3uHa+XQuG2hD1YyLoJOHBVPaIfrE8OPuY7crd6aXVVYU/95FakbrR1iYx7BjdnaLdqplbFDvRQL+TClOuSKOMss3UUU+NG3yfi3sdOmb/PZkOw/dj9gPWP1wiuE0ARYjMXZT2R/t2bLBSrpmLrCV5Plq4u/Bg3wSDYiFd3yywp+a19i/8Geyfek30jkHTTg52q5TFln52Wm5BLwYDWKYjIAgZ0Brmx3RPcgCvwvUXGIX2oHNCg3sEN+CJ+4Z8sSbQICrZMj1pm76VsQDUpcKS808kOHcPtN3s6TuxIv9SKfuIBVovPtXCFeZlPG5DbsJ/BBl0Hyzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CIz6FjYJvU9aKk1zEaIYCJqwEg84tC/Okf7qwQ8z/oI=;
 b=HM2w6yiQy9bEdgeEB6Ybt98Jtqdk3ZvSF20+URtNKEaaSHuBegTB6kFcWpkR2a/sZJa+RDyEplameg0+S8Z5RuUoQcRDxdnTxHiUNvTAvu4N0EHTAz84hwIRXkPC1wMW8DuZ9duYJEorst/cGf7nNqYqhrjHLsVUCmaNLrd/EoOK3oM9jPq94Sl/lEqVAfjND4SJ4fnAXsN0IIbYVwPa3Otk4sJi2yMRS5mI85+WzOQfvL+NLfsOcFrfFJ2x/9ffwRQcwZ3/1j9eph6kdANvqjnv1aJdjdZc5LGB/H+a0rZEp5fLZ8A3CwyeGlOh1u4zKtfHxBIs/QF5hF18hgbZFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CIz6FjYJvU9aKk1zEaIYCJqwEg84tC/Okf7qwQ8z/oI=;
 b=XMDui4oQNZ+Owpd9DUGC3JuOkFh4SAxowLk2X9R2BzZQlKWESdT4UWcaL6KI2A5Ue2Qrb8JW5DksQXT4NOdkFuUy5rIzCW/AdM+FXdz/BH089peUE5WA4cM4p3+VC2UmVxOJR8sl8f/iWffURTkhN313o+w8Vnen0UQUwwC/CJBw8Aimj6CP+XLkYO1FpcGNcezXmh1LKTSAx8T19qedoTRnAMs4nfUQktMMR52YnwM2epzyqlpfrrYInpuvlqZm2meJii2t0MhxOpOSjFWdo8GrhXjGNpHL7yG82O7lC4mUGkNVr5kwqHNEmI0IeSQYTHli886zNRxqaQrqW+G1xQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BYAPR12MB2743.namprd12.prod.outlook.com (2603:10b6:a03:61::28)
 by DM6PR12MB4337.namprd12.prod.outlook.com (2603:10b6:5:2a9::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.29; Tue, 23 May
 2023 20:55:55 +0000
Received: from BYAPR12MB2743.namprd12.prod.outlook.com
 ([fe80::f3d4:f48a:1bfc:dbf1]) by BYAPR12MB2743.namprd12.prod.outlook.com
 ([fe80::f3d4:f48a:1bfc:dbf1%5]) with mapi id 15.20.6411.019; Tue, 23 May 2023
 20:55:55 +0000
From: Rahul Rameshbabu <rrameshbabu@nvidia.com>
To: netdev@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Gal Pressman <gal@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Saeed Mahameed <saeed@kernel.org>,
	Rahul Rameshbabu <rrameshbabu@nvidia.com>,
	Richard Cochran <richardcochran@gmail.com>,
	Vincent Cheng <vincent.cheng.xh@renesas.com>
Subject: [PATCH net-next v2 7/9] ptp: ptp_clockmatrix: Add .getmaxphase ptp_clock_info callback
Date: Tue, 23 May 2023 13:54:38 -0700
Message-Id: <20230523205440.326934-8-rrameshbabu@nvidia.com>
X-Mailer: git-send-email 2.38.4
In-Reply-To: <20230523205440.326934-1-rrameshbabu@nvidia.com>
References: <20230523205440.326934-1-rrameshbabu@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR07CA0036.namprd07.prod.outlook.com
 (2603:10b6:a02:bc::49) To BYAPR12MB2743.namprd12.prod.outlook.com
 (2603:10b6:a03:61::28)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR12MB2743:EE_|DM6PR12MB4337:EE_
X-MS-Office365-Filtering-Correlation-Id: 206c38b3-6e8f-4ca8-2f9b-08db5bd019d3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	vhbM8+exY3LDsi/XKF5tu1Jodahn6huAFQFAeOpZwb5e+30UGG+ZknH15oevGimMt7x18J7Y4llS1eK4qZBiJDua88cUILWzbkIehIcSyVyGJzpHuEHr63FOg9xCePYYftwWPvK5Sq165dF0BLVaC9qaPQbc48HP7r+04F2sEtLX7PyBPKIXkeXdNXSD2NPXMBDhl2x3O3ztEvJhR5oNisAL5sVGyHaMyFyRJ4NysrVEQd224LgzmO/WurNuygB/W0y6/QqdkZFEl+WatZjTIUP0XvuB2W/YkoYYIOhpJvIKBo7DkBAmdjPkCbd0G9lEUxu/WFaNg9vYNo4bEoIZI7Uv9dATiNVtWfIV/lrX4CFzA5jZGvPUzU3cgN8Day9xn2Q9QmzAmzQlLiS9Wq+c/PgFs7itOQ0E9wJM3oWgycXkza+aGeqLRtV9dfT1FuVOlsx1ria6IvjvZFzu7mIPuAyO2piuvlZbzL9yXH4S4dwJANjEvXB4ers1FciEJuZYXkqmlIb1Wz8HBvrXZ34UnWHQ9B3r33zSaMvwY6lkT2SPxxb1b/WMc5h7Apmb0ImhuSs9ESJo4xAyyf5+jtdCFhNTCnOT/rRljCbVSSrx26Izo/ftLhFzIrPsHemEj6/M
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB2743.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(376002)(366004)(396003)(136003)(39860400002)(451199021)(26005)(186003)(1076003)(6512007)(6506007)(2616005)(36756003)(83380400001)(2906002)(41300700001)(6486002)(316002)(54906003)(6666004)(38100700002)(478600001)(66476007)(66946007)(66556008)(6916009)(4326008)(86362001)(8936002)(8676002)(5660300002)(142923001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?EY8hPDZf6DliRpvRodulP69xPFde2eB6hGwjM1Jt/N6eEoP9qR0Tb+9hOkIe?=
 =?us-ascii?Q?9WZiBa3Obs9Jz6Pxs6DCTWRX9t7TQ12B+tSmL5hYJQD0nZ0qXY4+lKkWFbiD?=
 =?us-ascii?Q?u5X0myVGOHjrzEawYAUYqgOYthKkoO0p5HLdVqh/nKaYyflrRP3xgqhReRcB?=
 =?us-ascii?Q?6H72NZEO6ZvnFHDZ3qextHXyRnGpbq4ZzRgzyEY/dhBir6D1D0aDysi0Df0X?=
 =?us-ascii?Q?FMqKnl86e/vqLN4L20rn3ULIloAFVJO+41kVdIYIz1GNWV1tsiQF4XATARxD?=
 =?us-ascii?Q?ImaJ1ujWKAulzAjWMibNfAekWuZ7uJoMUS3NekxFbkQDg8XHJl/b0Utacs0y?=
 =?us-ascii?Q?fgvFGLdS5I1ybeowEP2HApl89+mL0R8Qi80iSWZ8MXXikrvNyOGyrCfMT0s9?=
 =?us-ascii?Q?qUq+h07qfJwucUyQuu0LBNJYe5lA4wGjjKwbtm0lt3EJ9zzdq31yAp6t67he?=
 =?us-ascii?Q?DvfVEPUu3CJxoIkQmXz77xa1XgpzM6ayj4YlKF97RPZgrsOsXO1qDa/oTpt1?=
 =?us-ascii?Q?CI1AMffCjw7KFWbS8fqH5M3+wIoXA9Wf0Mckrf0JOSTTAQ9OuSgdUp965mbP?=
 =?us-ascii?Q?WBs+mltFw4Bf/TXKwalLEaPw0ZB147iPVnCG8mVPJ8HijW3NjWko7yX5ZSlb?=
 =?us-ascii?Q?NfUAxj8nYSKUDBVCMfI6PbYfO5N/DkK+tS9EECsVNcxbZ7mznyOulcAaw1WA?=
 =?us-ascii?Q?hyVXL91YsTvZHbeDnbTVeg5ukM+r2rvR4lNnzC2izRAH2hwAVV0/LxMUprxD?=
 =?us-ascii?Q?Am6ftDOmXl31MjKxILLTqcnOfAFchXPgTywk5Ov54ePTAC03YlBCm408aElp?=
 =?us-ascii?Q?GgI2WWMko9vkOIsEpCSw89LZRNNM+46HmcveQzG/MnTqdVV+VzKcNEmsv3pM?=
 =?us-ascii?Q?+8eMYDhiXbhcnU5Ui6++bizQC71/7VRC3Ag47na2vsLATwIJI1n9pnuw1/vA?=
 =?us-ascii?Q?M09/1n3aENuhgBCyG7MJA8AxjFnj33wb9Ol6lYVwzDAv0/5qDSSGwcBzUXFE?=
 =?us-ascii?Q?4Cd52srMFpqJIVU/aU9q6mEOROXL76kWjWnd8sq6w6FIp2RyBOACgVnNVx3B?=
 =?us-ascii?Q?xpi9eVt59RTY3d0K0VvpRHiZrSkF2JB/HdIiaZBBIDdCd6D68chdDQ+ut34Q?=
 =?us-ascii?Q?jwJroANJJoVrMd9DAyJdBaxcw2ss6oHgxO5Tj2Lc+I3UiwP+ByK9xnfo5tTK?=
 =?us-ascii?Q?8nFS8I5xl/H2afcw4QUky5w+T0IA2EgHiisS0t3pYALd+NzJnJTCH38tuxI9?=
 =?us-ascii?Q?1AgAr19SzmgUb6ZvHUWdlmoQRoMoo1inT+YHc7eaKSjLrmCiCLDu5PSQ0XUH?=
 =?us-ascii?Q?OX2kcevK9ZzBoNf2/dVzqVpm6CqkzePac5fx74YtQ+H98+c9Z3we94G0FHII?=
 =?us-ascii?Q?COE//ciSib0WV8ODh4twBS1GybWYFzC5k4n/n2Q3GyCC8WFxdpbIflG2FyhW?=
 =?us-ascii?Q?SqjDk9cn2omS/WEKisUqr5WbabJ0t3IHxLwH7gp+pn3XYFtleEKRllpGdBr9?=
 =?us-ascii?Q?i7DUSYqqPwg1gR+90DiFjStnGyFRfGId2YZIbfTBlIiQxiVbbTPvXvvYVbBy?=
 =?us-ascii?Q?Kea9Urx9TF95sNrFAU3EShoimldBfCo8JiBOi03IxN/adflYREly8vxSHxy4?=
 =?us-ascii?Q?7w=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 206c38b3-6e8f-4ca8-2f9b-08db5bd019d3
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB2743.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 May 2023 20:55:54.9222
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: M7dliFVLI89DRU5dDsIZ+TgqeaQM8135j6GtFQV7fkizDSMvF1ts/DAfmJZ1ekYJYIiMAhHMjIBLViQhd/CWug==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4337
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.6
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



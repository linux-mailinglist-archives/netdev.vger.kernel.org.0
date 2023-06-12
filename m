Return-Path: <netdev+bounces-10241-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AD67872D318
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 23:17:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EB0F71C20BEC
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 21:17:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B508E22D5E;
	Mon, 12 Jun 2023 21:16:57 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EC35C8C1
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 21:16:57 +0000 (UTC)
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2045.outbound.protection.outlook.com [40.107.94.45])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6650B83E3
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 14:16:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mX5nG8CcQu1236bgYBlJhf1D5REpMUTsRszC6EoyuK5PymO6CNOYvT5FNDBBswEc/MidIaVwzTMlVOOzwPLC2ZDDfrwZPACqD1iexzW/rVLiGmwjEYoRe8SZMll9VMN80B9quBd9/Z+ico4Z6TcZFy7isN9yVfQZwiVzHT44jRxBu4oDOuwAzfPGyUxukUQKWJ2nLM19utOH8COWEI48CdHFZFHOCScj5jFl2NDtcIG44PE+Db0GiRYj6vtp11LZVApZhqAydzaZIbNN4zIoakY5xeYM1JAptxlZ9qIABygQjDAQa6pozZmdvuDW3rMokjKFhiPV8csfwnEGjbdwcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OAlMhxjK3o1Oa8Uw2BkEhaakSrNFPvbihuYAYiLEtyg=;
 b=P0Bgc91JhBslE7q+rCP8gpNyR5O6j7bQAviaLqfWznkNEHPcRO/J0tzEM427Nsa+9c6bDBA5Q5UOI8nFKsuq7I/WxNvvD/07jhxhxCztLJLooCWwBtvPDn9yj3VSuyR7Ug0t8hyI8NwkZBU+xcxhhnkCtyBL8qnfOIFHBzgUKXYz10GBasNwON28r6Bs3ZYhARDMXUqQw0Ow0aREn0Nh48wKfKKgazvHdTIL8QBx/RNat+Q95nhGYTxRDqi7L1JZgCWhD1Mey10IY95pbvfJTvaJTySyfT045qZMcYOfTA63xHnqhVaUcF9+hQvA6hhT5z3R1ek+czveEN/AgOusiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OAlMhxjK3o1Oa8Uw2BkEhaakSrNFPvbihuYAYiLEtyg=;
 b=udiIHtMORFxaHLgTqbxM2XgadfRQMIbq0pAUL1peacgERVAidDxGhCedQ98ko4FpuOx6jXG/0zUhv0mtHC04ApyOT1SWGMYUZgXrp3+JDr1cOdmn8OuWV04Yus9sZC2CBPkIw4sQFmNSMEKvW+hcGVcznB6waMTjknpId9dZXuWsqtE1OfjsOoBhqi6G41J4mNoJF64nPa5ooc6kFMeg+lfq/NowWDHugw8K6i4KwBspKIhJi8mR3ESXfPE0DlymLSU2KCaa6DbKZrvDm4uBxpE2Cx/ux3VSm2YQNaNQQ9lZ6Z5JBtPERYP7DJRIumCuSnFxu5oyvFa/x7IO7WrdMw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BYAPR12MB2743.namprd12.prod.outlook.com (2603:10b6:a03:61::28)
 by CO6PR12MB5441.namprd12.prod.outlook.com (2603:10b6:303:13b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.46; Mon, 12 Jun
 2023 21:16:05 +0000
Received: from BYAPR12MB2743.namprd12.prod.outlook.com
 ([fe80::ecb0:2f8e:c4bf:b471]) by BYAPR12MB2743.namprd12.prod.outlook.com
 ([fe80::ecb0:2f8e:c4bf:b471%6]) with mapi id 15.20.6455.030; Mon, 12 Jun 2023
 21:16:05 +0000
From: Rahul Rameshbabu <rrameshbabu@nvidia.com>
To: netdev@vger.kernel.org
Cc: Gal Pressman <gal@nvidia.com>,
	Saeed Mahameed <saeed@kernel.org>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Richard Cochran <richardcochran@gmail.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Rahul Rameshbabu <rrameshbabu@nvidia.com>,
	Vincent Cheng <vincent.cheng.xh@renesas.com>
Subject: [PATCH v3 7/9] ptp: ptp_clockmatrix: Add .getmaxphase ptp_clock_info callback
Date: Mon, 12 Jun 2023 14:14:58 -0700
Message-Id: <20230612211500.309075-8-rrameshbabu@nvidia.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230612211500.309075-1-rrameshbabu@nvidia.com>
References: <20230612211500.309075-1-rrameshbabu@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR04CA0012.namprd04.prod.outlook.com
 (2603:10b6:a03:40::25) To BYAPR12MB2743.namprd12.prod.outlook.com
 (2603:10b6:a03:61::28)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR12MB2743:EE_|CO6PR12MB5441:EE_
X-MS-Office365-Filtering-Correlation-Id: 4f854348-ae69-47fc-e326-08db6b8a3b8a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	NUeXsZas/mvmoRZVym+RxCFe2lJfFdTxUiL6aKK6sF3Y41Qjz0cSRZfnlSpE8bNF/unEpSM3FaD+eKpIdy9omcmXOjefRR7uYObmQo9ZpsiKzbeT8tlsJ9SlkuTHQBl78u2QHQ5LW1ZNpBlJqU0g1JpLmWS2HcShPgW5k5ly5FOkn7QqctY2+Ng9Ha/r/j5a3Q+NMOBrKk5fq6jXxmfLIabdUpr1av5IRO28J9LA0dNKrYV6BDobRc1clT6A2TZrZQ4O24/7X4KMgwpL38TCmhoJv6CeH4ARVGLZhBl0vwIMfGIUiSlrSJW1GHx/NjgfsAQmc8OcoZuwIloCjS2QOPvMGuA68Tzq0jXTfYCSO9Q3KNnRqI3nVR5Z9TX6j3o9sajBf5/EmsVlkeQUs+3c9kwjpDd0szAcgxM5KcD1VW9t1k4CXQApjZYQq1nRdNiN1sv/QXYI4huqUZzCU3M/v0RMyG8iwXpVtP4M6Cto8UpPUiyTUMpQn3aBrzdn/xKWhEEpA8orvdb8ewFNvyShqYnTz71S5vlYfCvoma7AHZEcz9bWPhVLtP560G3B1Cgho+Uh8jdFMOc3DM2yRQZ1TlvjKkStqDRAcuCEc8YZqXFG1rufUPJI4PAIPVaAn3WV1YVIMId9CNoPzPYMch+pFw==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB2743.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(366004)(39860400002)(396003)(376002)(136003)(451199021)(36756003)(2906002)(86362001)(5660300002)(966005)(186003)(83380400001)(6666004)(6512007)(1076003)(6506007)(26005)(6486002)(54906003)(66946007)(66556008)(66476007)(4326008)(2616005)(316002)(38100700002)(6916009)(478600001)(8936002)(8676002)(41300700001)(142923001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Py9SS/oHyiTiUvVeM0nL+crvnU8nI2LIFLyAAlslnY+D25StLHJCvlO8ce9u?=
 =?us-ascii?Q?ouh7+AK7113SVFXHbFcwNnFb0qP5rVBmnMRrF0FZyyXZkrpZ3z41P551tld4?=
 =?us-ascii?Q?/JesbPkiqJtxl4UoOtkNhv3TaPlGJsz7KwWwsEaIyqtwovRXPPIdJgcL4e5J?=
 =?us-ascii?Q?QDasEi4dQ+psqUBh4epFfRsCQaLTAlPPokF2wnNvvQ6PHX/CQFQ7w3CDAHdb?=
 =?us-ascii?Q?yukWJEd1hfWYDY3JqUi6SV2sBTIzqDtjBBFVV8x6qNwuHI+lcwHjN8uQJqVf?=
 =?us-ascii?Q?tvDUdCAkryO4/CJ6wUeJcjxBVQlOQB26i3jaZKyY2OjnohjUaztC+P2ILixF?=
 =?us-ascii?Q?IIcnOOmLxL8zh9NnFzNxy8IparGxHT/NGtoeykMZ5GvEZ2mveoHasrJfyqeG?=
 =?us-ascii?Q?ip4x7CF8I6OTOpQ9sb7h2QGxKIa6D33E5q7tVYa1BXc4Whwif8s2Uj2oRN4p?=
 =?us-ascii?Q?IPkNiukdTIaGh+yaZ9+rh8NAB9nf35Sfkw8yY+zX357/LxMmWjUrfm+Oto2R?=
 =?us-ascii?Q?0lDuIuELx1xOXf6Tc79N5UC3k8OJufcXVPamDQRwhV9PnUlFXBIoaNZK0yo1?=
 =?us-ascii?Q?Cg2g9vnszLsQgyN54AorRlgD5rDbbYkTkzvVmqk6iRgORrYqmdfwlUubDrQE?=
 =?us-ascii?Q?ML/Lr27IPdKkz89tR4gcC/toGjkO8ajLw2FkDPY6dQsbwRQgCUB09H642RW+?=
 =?us-ascii?Q?ZS8GNuAqIYU7A0C8LMNn5NDJBOKQND4QltP0ScyELuiZ67lyw4TuHP1Hfs/w?=
 =?us-ascii?Q?jTYgUzxDasRETf7CRZRYSLS1+HFRXwMRx8mtIGdhNDHLNFWJ14niOr08NqOh?=
 =?us-ascii?Q?Rls43Wih+Ri/VWG5QfC/Tr0VySFfc/s05l00YVFHcqDEx+1AHZyUJQVXdQ+j?=
 =?us-ascii?Q?JQ9kLlUq8NOTa2xQrkF+WKOOh+UUCHsF9fPDV1CHmtDh/nHRGbPkS3loXWV2?=
 =?us-ascii?Q?lUuP0MXKxgQEXr/UNjAJKKRnY2W+/rT4R6G8krGFtQy2TEz/dy4OOlm8R2bh?=
 =?us-ascii?Q?LW8oghRwk6zBdu7fdhfzLlV9rXP/OBo3wOF6yvQ7cNBUHjfwRYucoIJFBOma?=
 =?us-ascii?Q?OyJErvQBKRSEyRoHvhgt+usvqC80EvCALC1GJ+3vK1CXJo9ohGXOmTp2t/kB?=
 =?us-ascii?Q?9GegOB0372kjKy3rD/yj0/NvpirG+Emjvd8ssEwTeBj8kXgbWs3Gd5qEqzRj?=
 =?us-ascii?Q?NXMdGf1PiexT8hq57UKC+KusNlIZVrP79S/z2oMTlARN+MogjhB69nrOsqIt?=
 =?us-ascii?Q?+Yo4CphCYM8XvWaG9FzWEh7Z+8ywRR1L1cupu1IgESpun7foAHoPlTH0XOag?=
 =?us-ascii?Q?CmdxCi2kcMznOg3s0KJ1rhCvwezcSxG6rjqV/2BNDTIQB2WWrn5K5YUnVYrx?=
 =?us-ascii?Q?e4OF3kXFOAh9/xKb4TqMnK+NXKjMzurZWgM0BS5z4Hte6+S4+nOF+TQXsoNH?=
 =?us-ascii?Q?Dl3GE+VVkzN8akA+knSNBeRQVSYPrVAf+dMKWk7uBj8nUHNTb/dcxK99hLnp?=
 =?us-ascii?Q?Ddg0asuIVF6i9MqhLYcdHul5ZR8nz0EGzGlHA0ne1iOWUbtpkcDBuCodiY7o?=
 =?us-ascii?Q?KqOhyDtjCTPb1p+N13jiHiGjUJPQJZt/exDchtN5c/jqUwblbouo2JA5RzOR?=
 =?us-ascii?Q?8Q=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f854348-ae69-47fc-e326-08db6b8a3b8a
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB2743.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jun 2023 21:16:05.3341
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hw3kvwWwz/JWqALqa2DzY3LHb4FpiiuepnPPQSFRT6RPzViwNiCdTJLXtp1DmYOhp2yz6EFYG683BMrhMe+W8Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR12MB5441
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Advertise the maximum offset the .adjphase callback is capable of
supporting in nanoseconds for IDT ClockMatrix devices. Depend on
ptp_clock_adjtime for handling out-of-range offsets. ptp_clock_adjtime
returns -ERANGE instead of clamping out-of-range offsets.

Cc: Richard Cochran <richardcochran@gmail.com>
Cc: Vincent Cheng <vincent.cheng.xh@renesas.com>
Signed-off-by: Rahul Rameshbabu <rrameshbabu@nvidia.com>
---

Notes:
    Changes:
    
      v3->v2:
        * Add information about returning -ERANGE instead of clamping
          out-of-range offsets.
    
          Link: https://lore.kernel.org/netdev/13b7315446390d3a78d8f508937354f12778b68e.camel@redhat.com/

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
2.40.1



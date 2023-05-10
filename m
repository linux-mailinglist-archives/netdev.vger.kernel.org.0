Return-Path: <netdev+bounces-1579-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9DF1B6FE5DE
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 22:59:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5527C28156F
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 20:59:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C0B621CF3;
	Wed, 10 May 2023 20:58:53 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87D22168AE
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 20:58:53 +0000 (UTC)
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2060e.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe5a::60e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1D977AA7
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 13:58:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GHSHBnlLgAR3okbfafosu4gX3ePF2p37Mym+/uU8YfyyHdndJ6LJt8NeUX0dbFuXlYuOkm8faBRLI6ltMwpF34txqNb1tt9JIcU82xXax5TuWRdGAPEBN/foC/859gSdKH5xJZ1YTL7s7H/3NpQMdi0lBHiWDP7n+5IU6EyW8OQlhnC0HfVI+MlxY1oZVKBAZWTN8gVPdg49jOSax7+QzAB5zL0OIht9F6N6euZc18r5GkN17Z2iY9AEqUFmVBbJhr+FmYbW+/hm/a4JxDhInpJzlTIbPXtUITyLfHho4zVtU7ni+ClKOC7G/S3tGztjwigyCmwGHWPNGco60u8yIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=frxpCCCzUClrSmSWVChBKmih7shCvwrrejg/QVAtzKc=;
 b=lhTvIr8fMu1DZX46lKSQxz11G94k3bfxyd0JFXYzTPA9Nmjcnw6Oq5xLdD3n6bcFE/z3lI2A3W80VCFnZvXSZ6MQCkxcsGyx61Zo3g9cbKGGwJdNuUceXScDfO4bDFSDn/bVnPdNXki/lmHymLVd1jNyrg71XOlyHeyKkPpqZ9325eo6vZkcCf9reZtMR4dKOh4btxP3TgvV9ETfis9ue4lPzMkvNAE3nWmB4KU23hBwVIpOJvg5Uv7yiyboE8K5nPT192IZv4Pzbce8SHArLqQ/mFfcUUKpd8I6I1adr4vM2f08BRpI5uC52J5wznUjQ5R/k+wkqhBezSR2fopxAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=frxpCCCzUClrSmSWVChBKmih7shCvwrrejg/QVAtzKc=;
 b=s8+fP9OOVxKUN7yOt9qNZ+JH8y0NIHBdp8KV5NKNGVQEqQop6f2R27o40naYVUp0kbfuSdaFoSyznZ8De+VznugZpR8jcuuaDX8e5mEhXYEcPLdnF5iEKdYUoAQZGzEOoK9tmy4CfedfPOSmFhsodTGQICtBuo7bDB6SNcHMdrbGipo44gqbXwculLrUpLM+ojN7G6O1BYKWhUxDEUd1SNgE1w6ybl/VHcI1Ap+JAokoMeawaxA3v7GdVfCWSLG1xSxCcCHpiqIOEf+Qobw0fWKOJKE4ZB8lemkZ4nYnQgCM+NAT2ejPhypKCJPFvl4RnD+XBuhDBWvrXeVk4Q1QBw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BYAPR12MB2743.namprd12.prod.outlook.com (2603:10b6:a03:61::28)
 by MW5PR12MB5624.namprd12.prod.outlook.com (2603:10b6:303:19d::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.18; Wed, 10 May
 2023 20:54:07 +0000
Received: from BYAPR12MB2743.namprd12.prod.outlook.com
 ([fe80::de5a:9000:2d2f:a861]) by BYAPR12MB2743.namprd12.prod.outlook.com
 ([fe80::de5a:9000:2d2f:a861%7]) with mapi id 15.20.6363.033; Wed, 10 May 2023
 20:54:07 +0000
From: Rahul Rameshbabu <rrameshbabu@nvidia.com>
To: netdev@vger.kernel.org
Cc: Saeed Mahameed <saeed@kernel.org>,
	Gal Pressman <gal@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Richard Cochran <richardcochran@gmail.com>,
	Jacob Keller <jacob.e.keller@intel.com>
Subject: [PATCH net-next 8/9] ptp: idt82p33: Add .getmaxphase ptp_clock_info callback
Date: Wed, 10 May 2023 13:53:05 -0700
Message-Id: <20230510205306.136766-9-rrameshbabu@nvidia.com>
X-Mailer: git-send-email 2.38.4
In-Reply-To: <20230510205306.136766-1-rrameshbabu@nvidia.com>
References: <20230510205306.136766-1-rrameshbabu@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR02CA0038.namprd02.prod.outlook.com
 (2603:10b6:a03:54::15) To BYAPR12MB2743.namprd12.prod.outlook.com
 (2603:10b6:a03:61::28)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR12MB2743:EE_|MW5PR12MB5624:EE_
X-MS-Office365-Filtering-Correlation-Id: 73352d99-af16-46f0-e5f0-08db5198b219
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	JzYsZABU3dx5WdZRYd69L0JuLAmaMQsX/rUoFJ/CnfnrFCdEwMFQw5aPKM89ey115SAXMG2ThfHKiGiNgEPYdDen5MbKornEjWF5p86XE9AkNMXbpI4pXnY9NhjUmt5E1saKwH6Yk/jdMT5Q//j9tsDPVjYYHwvziMlUE7Lakj/rlquZbIffSGW1KdseRnqyM8uRvEz1zVFs7BpCyGfq6DkGPQXrq3Y7GZ+t5vZLOfFKz7oIkAL+kw3RYscFgVPIQRdnSKf50cCC56mCnr2nWZOh1tUwexiwmuKsJVONtkGOgClwLM3ApZnd0b1dRmyzk4D7QLA3+2oYnEWWMZiJ+eSf/ZPjQnAiMsRC2tcvCmHuoOLSY+RjuwpK/upKVehkPmgZOa7PLlVEAnFfHcP6KYUX5WX9Js6VSX8uACS/xxp73wlMRsOShpeAx17NoE6E2KgjMhK+4rqiduVQ0SSJEcwshP7zVXhVdh02HvBU/ghse448KZRNQoDaF1JLFWAeaTHXhC/eAIZvPNOtqlSHAp90SY2RF07HOtc+wtGM7YflDZHLLAMSVVe88W8+o4zrhRLNiSXWCQCvWL3v288j5eU0s5v6bN0t89BYimaOqAmp+FdDBSrWT18hEI0MzEdv
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB2743.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(136003)(39860400002)(366004)(396003)(376002)(451199021)(86362001)(5660300002)(41300700001)(4326008)(38100700002)(316002)(6486002)(6506007)(6512007)(26005)(1076003)(478600001)(54906003)(36756003)(2906002)(8936002)(8676002)(186003)(83380400001)(66946007)(6916009)(66476007)(66556008)(2616005)(142923001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?UWpe9+7WFfImC5OFmkTK36ERTgv1paIoWkYB/laqsFw8axDwiyjDiOWgJVSS?=
 =?us-ascii?Q?vw3Dwi6mRtNlFv6g68Xte/qQYh4F7nZ0ReVq1NhdVaUTOkF4+NEjaURiSf3Q?=
 =?us-ascii?Q?pV3CtVYvTlYNew1EheotvdcWD0iBt5hV085TKP+kVLeDkQGKRoY2QyiZlBvE?=
 =?us-ascii?Q?UBkq6Pdw3VM+e4YDZW8eUKPStgo9HcWFizKVr1QcuiBwQ8RqeM6dpJ5jmoni?=
 =?us-ascii?Q?70C1kfRKZCCjA5BXpZsdl1uEAkPhWl1XK4fIzo/xo4b/LGXyGt6wqd1ialKz?=
 =?us-ascii?Q?9DdAID84lWvkXvOq/z80zNqD2ZVOYGu/I+iTgdWanAfanEKmLVS+eLggjPu/?=
 =?us-ascii?Q?tYc8+BbCF++PvaqV6BEXd6KS5x8NcSRjSgfJz7R4kabMviRom3OexwCou12V?=
 =?us-ascii?Q?hpiTGTTW5yEEIThnFy/uTi5N5HelTA03oClVibGctkrIWlmjereFUksdjAST?=
 =?us-ascii?Q?95AkjKKDPKL1IJJGnTy/Ht5fUt4YpVQxBCjL6rqM5SZ49nAKDaTMcqveHUG+?=
 =?us-ascii?Q?yrdNcRdThX+OKUgoseI+8p3cpNLYS0SBmlGjiNZGQ0nOvPMtRrJo+7d51IiI?=
 =?us-ascii?Q?fMX9kKXLtbA/xxRsYAJy2NDSCM2XzuovChGtCazko4Ua7NlKUgp4cTsVuGuv?=
 =?us-ascii?Q?oNLZmJVF0D2KY+VCW+U3nQJtyS89T+VHu/ZNog+h2DfdEs3u/Dmm3R7p7guO?=
 =?us-ascii?Q?+SnfME6v5Y7e08UGYpYqsR/YLz+1Er4Acmdy45IftJtguZ1hjRCQ1W0fht0R?=
 =?us-ascii?Q?g0LYdU6oZ+lKcP7tSV4kV3HZCmMx0h2va22Pt+ENnwTafZZM6yYnojNDeZfK?=
 =?us-ascii?Q?XMURUfkzQ8mpaYXoL6v/2xIow9tHpb9ak1s5xXul8yyeQ3XIlTxxKq8xtV5Y?=
 =?us-ascii?Q?iXtrLw0RgVAMX5MAOHq2ESb+49i+UvGYooqO1WqDI4n2UXerJxkG88uPyISI?=
 =?us-ascii?Q?m3m+XN1hkaOFjK9zkjVTpUXRSm/kPfD/Q8yuYac21b5d07LKWp1Gkkzy5ijs?=
 =?us-ascii?Q?uNn37Vart6djac/LchpoOgEJtNl8V9P8k/et+bqOhs2cjaB8NI0v83vWzpll?=
 =?us-ascii?Q?Js1qW+svTPDm5WDXOUkcGCEdvl1MYRASwSvlwUSkvfEgYoL3v/tdmbilUT9o?=
 =?us-ascii?Q?yay73YrTC71d1GWMPiZJvAJ9UTfIDFleHvSDuCDzVuTGZHLzYeLkobx8Jv4b?=
 =?us-ascii?Q?KYIkZ8SPVYS0R1YjSeiMYJSR1ioVAyxUBc+YYvgdCNpKEt05p8IooT4oQSL6?=
 =?us-ascii?Q?TA0GiEQXRP7dR6RFYAdhc/lyOyuiUk13+LzuA8/FUNWO7Y9EB/8cM2QLImo7?=
 =?us-ascii?Q?qnsAUK64hr2kFW/AjJn4XetDlUN1QDVCO1JiDCiN4TIAnHmMWI9H+WDt9tCz?=
 =?us-ascii?Q?WA+wqheQuuS5uuD+gr6dFs8FBye0vpaSiCzVdkCTXveQsAwRZN131j88UelD?=
 =?us-ascii?Q?rP1kuaYANSCvQAvuSw7LQemexRswsaBqNedvNrIirmeyx7b1Drwo3Zc9unEz?=
 =?us-ascii?Q?dFGrkTb6PEmMEX2w/Rt2jQUes5FSPJ/aY8bVFS2Dkg6yDh+3sn1mMzt0jsjF?=
 =?us-ascii?Q?xEjwed9Bm1UXLPH4rACpv7Gv+SgRayV0THUbSuv3ZnJUPOQbaIk/Y+2nKISg?=
 =?us-ascii?Q?Pw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 73352d99-af16-46f0-e5f0-08db5198b219
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB2743.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2023 20:54:06.9994
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AEEZttnh+BJQIekCnltheznZMvLO2qnb7qfEqaugBYJfACfubcdv4yokdLIpJ57xOoAorVLQ4mPU4XF/HbaQpg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR12MB5624
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Advertise the maximum offset the .adjphase callback is capable of
supporting in nanoseconds for IDT devices.

This change refactors the negation of the offset stored in the register to
be after the boundary check of the offset value rather than before.
Boundary checking is done based on the intended value rather than its
device-specific representation.

Cc: Richard Cochran <richardcochran@gmail.com>
Cc: Min Li <min.li.xe@renesas.com>
Signed-off-by: Rahul Rameshbabu <rrameshbabu@nvidia.com>
---
 drivers/ptp/ptp_idt82p33.c | 18 +++++++++---------
 drivers/ptp/ptp_idt82p33.h |  4 ++--
 2 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/ptp/ptp_idt82p33.c b/drivers/ptp/ptp_idt82p33.c
index afc76c22271a..057190b9cd3d 100644
--- a/drivers/ptp/ptp_idt82p33.c
+++ b/drivers/ptp/ptp_idt82p33.c
@@ -978,24 +978,23 @@ static int idt82p33_enable(struct ptp_clock_info *ptp,
 	return err;
 }
 
+static s32 idt82p33_getmaxphase(__always_unused struct ptp_clock_info *ptp)
+{
+	return WRITE_PHASE_OFFSET_LIMIT;
+}
+
 static int idt82p33_adjwritephase(struct ptp_clock_info *ptp, s32 offset_ns)
 {
 	struct idt82p33_channel *channel =
 		container_of(ptp, struct idt82p33_channel, caps);
 	struct idt82p33 *idt82p33 = channel->idt82p33;
-	s64 offset_regval, offset_fs;
+	s64 offset_regval;
 	u8 val[4] = {0};
 	int err;
 
-	offset_fs = (s64)(-offset_ns) * 1000000;
-
-	if (offset_fs > WRITE_PHASE_OFFSET_LIMIT)
-		offset_fs = WRITE_PHASE_OFFSET_LIMIT;
-	else if (offset_fs < -WRITE_PHASE_OFFSET_LIMIT)
-		offset_fs = -WRITE_PHASE_OFFSET_LIMIT;
-
 	/* Convert from phaseoffset_fs to register value */
-	offset_regval = div_s64(offset_fs * 1000, IDT_T0DPLL_PHASE_RESOL);
+	offset_regval = div_s64((s64)(-offset_ns) * 1000000000ll,
+				IDT_T0DPLL_PHASE_RESOL);
 
 	val[0] = offset_regval & 0xFF;
 	val[1] = (offset_regval >> 8) & 0xFF;
@@ -1175,6 +1174,7 @@ static void idt82p33_caps_init(u32 index, struct ptp_clock_info *caps,
 	caps->n_ext_ts = MAX_PHC_PLL,
 	caps->n_pins = max_pins,
 	caps->adjphase = idt82p33_adjwritephase,
+	caps->getmaxphase = idt82p33_getmaxphase,
 	caps->adjfine = idt82p33_adjfine;
 	caps->adjtime = idt82p33_adjtime;
 	caps->gettime64 = idt82p33_gettime;
diff --git a/drivers/ptp/ptp_idt82p33.h b/drivers/ptp/ptp_idt82p33.h
index 8fcb0b17d207..6a63c14b6966 100644
--- a/drivers/ptp/ptp_idt82p33.h
+++ b/drivers/ptp/ptp_idt82p33.h
@@ -43,9 +43,9 @@
 #define DEFAULT_OUTPUT_MASK_PLL1	DEFAULT_OUTPUT_MASK_PLL0
 
 /**
- * @brief Maximum absolute value for write phase offset in femtoseconds
+ * @brief Maximum absolute value for write phase offset in nanoseconds
  */
-#define WRITE_PHASE_OFFSET_LIMIT (20000052084ll)
+#define WRITE_PHASE_OFFSET_LIMIT (20000l)
 
 /** @brief Phase offset resolution
  *
-- 
2.38.4



Return-Path: <netdev+bounces-4808-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 73A4670E6FE
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 22:57:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3E3CF1C20A33
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 20:57:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9132FBA31;
	Tue, 23 May 2023 20:56:31 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DA189465
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 20:56:31 +0000 (UTC)
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2042.outbound.protection.outlook.com [40.107.93.42])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BAC1E5A
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 13:56:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ckhWOgeWKd9X+bBWSMxY5Pxq4+2J6KOldQSz/dYk3JzP2y4UdPOXru6a+Hb7nxiRys9OV+ChH8XQI5uIsHHcid6p28JZT7wy1bGz88lQ8tjoW2DlsPas5NGMHAMoTtmfwVX8TaFPiL2MZLMmmHOdTlgOM37Am3ueiKyUAoE6m++da9Ltpl88+UDzYbSMcr09v25XBKOCvXXLiGcN1RBpLPZz7NaXOqB3ce7tbnhU5pTYLaX8bk+fQk/eWiJKvmfCcmnLJeWBr2eG54EprtMQI6fLrlrk13IotqcEQENHPoMRZck2/Xon6Lz5XTb/7oWMysQhQlbdHsgyVA5IjHWKzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=frxpCCCzUClrSmSWVChBKmih7shCvwrrejg/QVAtzKc=;
 b=mvYelfzgqhe434i/Uj5i0CRGHT8JT0hO7MKWP/cz3bPrLPXZ6Dgyd0MCBzcAZ1MJHP8YoVcFhex13F/bIvZzguPNEpRY+QYBqC9ZJ9wyArSahLuFzq4NfPfR9NXy8ZXFK2VmJORYsERWZKL//Qq79if8t/X3goDMw5GIBU4WF1mCZRA4SMa2Ab4A2CtvBuhQr/eaUQ3WHamzQwSteEdnjjP5rxlPBSdhbzN0evtbnAaezp6DvGCteWzOrnaetrd6SpegxFSQmh2PKPsZJv9Sj7h6vz1eFhr3Kk9kH4VNrnjkO3IWUnb7bxurs0HisHckdNF2k0+IPzt2DUZZA5+M3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=frxpCCCzUClrSmSWVChBKmih7shCvwrrejg/QVAtzKc=;
 b=tjkFyQgQX/zNqksFFMJfoCDgnWoWRRTEFtIblJcDLVykjmUGarON5TSLnsKUozI9BPYyknPGa3ocfz54pJHDDHWzziuUH93e/xJ4150nmJkEs8XRLbTXKi7nB7La5uct18BmVKmbxJnoZ4ePzPZXtRH4yl6wsrNAw5Ss7I9FyI0z2v1JTHdmU+AuLrNayRyRdMtzQGJuGIML7eNyHj5VASCLoIN2DhXuZN7fQXItLdEg5Znul7AtonooE2N0DOQLP81McmaKEfk7sTrFk0TuPK8SLjDhR5TcDjG79HnGNCAMxg7omu4t6o8p452KTw1qZDtbeIPYLv+LVLQjUb0+iw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BYAPR12MB2743.namprd12.prod.outlook.com (2603:10b6:a03:61::28)
 by CY8PR12MB7193.namprd12.prod.outlook.com (2603:10b6:930:5b::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.28; Tue, 23 May
 2023 20:56:00 +0000
Received: from BYAPR12MB2743.namprd12.prod.outlook.com
 ([fe80::f3d4:f48a:1bfc:dbf1]) by BYAPR12MB2743.namprd12.prod.outlook.com
 ([fe80::f3d4:f48a:1bfc:dbf1%5]) with mapi id 15.20.6411.019; Tue, 23 May 2023
 20:56:00 +0000
From: Rahul Rameshbabu <rrameshbabu@nvidia.com>
To: netdev@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Gal Pressman <gal@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Saeed Mahameed <saeed@kernel.org>,
	Rahul Rameshbabu <rrameshbabu@nvidia.com>,
	Richard Cochran <richardcochran@gmail.com>,
	Min Li <min.li.xe@renesas.com>
Subject: [PATCH net-next v2 8/9] ptp: idt82p33: Add .getmaxphase ptp_clock_info callback
Date: Tue, 23 May 2023 13:54:39 -0700
Message-Id: <20230523205440.326934-9-rrameshbabu@nvidia.com>
X-Mailer: git-send-email 2.38.4
In-Reply-To: <20230523205440.326934-1-rrameshbabu@nvidia.com>
References: <20230523205440.326934-1-rrameshbabu@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR11CA0092.namprd11.prod.outlook.com
 (2603:10b6:a03:f4::33) To BYAPR12MB2743.namprd12.prod.outlook.com
 (2603:10b6:a03:61::28)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR12MB2743:EE_|CY8PR12MB7193:EE_
X-MS-Office365-Filtering-Correlation-Id: 2ab014e7-3245-4494-ae02-08db5bd01cea
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	ZB+uPjXDa8oFpmJAFKOLf0fwRN7YkADq2OKL0M4D15g3xx5yuMVDLtDb4u2jD9xNdGUZJ5pDWKk9BhcmHMa+ggQxXb7z5rSb4NqYJ7xBt2xhEgIMkXIJjVgvvRZk/pJr1h5J8e4AR0m2kuyA2ycRtUofEWDA1ZAp7SmsKXfie9adO1GC0kNKdY8vp+OLyREiqNUXqDRiv3x96CECdbxdLnd4G8/2mhAyC10yjINzFQ6lX+RRvwzlbqxOlQ5VmeAnh10YjkyqQEnBLLvWmnlgdNP+MtZ0YmKwoIa6xexzcXNHI85TWaoXzc7j+b4TRPTWxJSTGCz3q6Sctwea5Zw4zcU5w9k28AVOWjfyhi0rQbVDKicQiO4WnViXzG2ic19zbd2mO28bfmKO5MrgxEaRKATwRa+vEYY4nInr5+1dSa2Mpy7TeCwJAnMpfcxG4+0SbCYaqbVKSHBrj2LjsbImNzl09Bi4qNvTYzhP95BrnUTKVvozVE9zUexgKqu/VWnNBdF1/LS4gzvhpPFkmyHvZIi+ggEBFP6FEthRDKzfcJQW9n5801Ou+iJsTUSqmZ8A0oeVEzJ0+H+Us7HPBokcMmvFaZ05Sp5TppWnF7BP9ncxZ3FSTdnbUxDFziEngRVE
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB2743.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(396003)(136003)(346002)(366004)(376002)(451199021)(316002)(54906003)(66556008)(4326008)(66476007)(6916009)(66946007)(41300700001)(6486002)(6666004)(478600001)(38100700002)(86362001)(5660300002)(8936002)(8676002)(186003)(26005)(6512007)(6506007)(1076003)(36756003)(83380400001)(2906002)(2616005)(142923001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?DmnGuMH/FjoxUnoFB2DgEUgWPEX9/ORMmlync17mCDCvnp82ktSgtDVe3CjB?=
 =?us-ascii?Q?KZ79yCm78G6G3etkhSmtWyOQ4trPAeXc0zmKnZucG2mri65tbEx9AMcp68Z6?=
 =?us-ascii?Q?JAtaVQ7ZCHx7grHAyurkpJY5u2lf2nphsYWTKRehArlrG+GIF+W4zXNz9N8P?=
 =?us-ascii?Q?Dh3W72iDS6jnM+pMslzvIV+GJGBs9JaF5O1Z+T6l7h46bQGBNQarBR6WENbI?=
 =?us-ascii?Q?Aw104t9b0duN7KEQUbiI19Y27mXbe8UFig4zVnozP9J0MM0SmXBwaMH7CyBN?=
 =?us-ascii?Q?VJCdvlEMoK46U+RpspNb0+ChTX8TefHlRfo3I+ddV6LvXT5QihWGnkTDGoTr?=
 =?us-ascii?Q?RY2gtysbAGOvsdfD4ET55mMBxZJMpTbRt/HBRvl5sXjq0Bca6uu34DfRDioA?=
 =?us-ascii?Q?Dln0L2BglQUUTHoY/GGLtZT0LNrfNix2mVcgXMLNJDatmva2/1kOs8OPL9Pm?=
 =?us-ascii?Q?ah8g+6kheSxTtgVTo4HfQpFYvXjiwiEpK4dmJTC/Ai6QoTr61RBJ8OBxalpT?=
 =?us-ascii?Q?wcocSPQplD3HiJL0wZk6QMuTYKw4+sqeiwX4PPUdoDXFZYNQFss6Sjog/sod?=
 =?us-ascii?Q?bOWsIYqkAo9yEsknjhZorjfmCS+tJC3R5flq4U1yH3Ljkp7rnpYEmgv+hC2u?=
 =?us-ascii?Q?bvgTpfs3KAQ+9t3vtjmWiTUOVCjFpxwRhOtSCE0ZzWhkCKUma6dAGfEXkFl0?=
 =?us-ascii?Q?ZUR4+Cug2C6S4WC9tw2fyfV4z9mI8o36YTFAcJf/Nac7fwbL94iKGlkStHNK?=
 =?us-ascii?Q?uxXILjw3goZ7erk+vC5Igc9QNYiX+0r50k/+L5NCl/1VQkZVhbVxUG9YiphK?=
 =?us-ascii?Q?VuAXf8ZC0eW9LHuHEjdTPJLBkYfxIkwdjOE5QIlLJFLKa9Tibj1uT1/ylJLE?=
 =?us-ascii?Q?9lryKvHN94wYbxnjtR8rj8wg0GmbxtSv5VRxjn/b/l33xpcyx2MeDxto8/gL?=
 =?us-ascii?Q?3PbCNRraoYvXtJZh6m5WDxK6mR7tjlHz4xTBEGZwgNxpgs6ZfhsXcnWVcPSG?=
 =?us-ascii?Q?MdKriG5+//4m5z7kI4dI+5TbzyzSkfpJYb22ZgBFCEIAqdbPRMyWBOSX+lED?=
 =?us-ascii?Q?0tIK7nknU7hSEYDU+f7WSF+YbkvOTW3PtN2X3g3/ulR+yBYn5vgcLYY7xrd3?=
 =?us-ascii?Q?sM5HSPsWhQLi1fxgNwFMtVqrDEvIPajhtwiiTvVHwqO4nWXa7EV6wya5Xy2A?=
 =?us-ascii?Q?sZIr3vfwRBaXP4/RXdG0EEB70jRS8RH6AF9mPaKYknS+/3kpjpwHhLdFHbRN?=
 =?us-ascii?Q?lq1nkflzdMFNsg3QFstg8eTNs/8Rjs0Cd5zRK6eEm1Ts7wQNgRMCp+LsFZfb?=
 =?us-ascii?Q?ZCSRR2vBA0Y15/UJoWOCdhBjbCv/cPyfJzQkdx++fzBPTqLR5JAmetL4HYv1?=
 =?us-ascii?Q?X1Jhd0Ffi8DA+4ixUhAJc9ENkhJCNdrVzkV5N1H8AsXcuFV3j5UAC4iljZgI?=
 =?us-ascii?Q?nGmhyx58FYheSzIlP7Ejd1h9tf4eXYBJJFQmlUotgRkjQLhbCbeVjRjBzEGV?=
 =?us-ascii?Q?VjioTkZhHJ4F0cncqUcqc0odaBiUPYPxF5OkEmzJ/Hv85/5BjqcuJKxE8TBq?=
 =?us-ascii?Q?fDaAC5u0eH+GtlvTK9jTqYxcYVTSXA0g0WSyNpNpvlRFM/o/PDCydA+jE6NB?=
 =?us-ascii?Q?JA=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2ab014e7-3245-4494-ae02-08db5bd01cea
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB2743.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 May 2023 20:56:00.1210
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: p4bhIlEeISOdMnZgwZ53VBgT//VEDkhrR2ksqCp5nv9nMRgyfDVNEjatYC/GjFLQgvoLoxNbvvZ2KSCnQaVaoQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7193
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.6
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



Return-Path: <netdev+bounces-10240-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BAAB472D317
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 23:17:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7722D281074
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 21:17:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A8E4522D49;
	Mon, 12 Jun 2023 21:16:46 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A688C8C1
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 21:16:46 +0000 (UTC)
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2079.outbound.protection.outlook.com [40.107.244.79])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33C245247
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 14:16:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c2c3IgJvgLPMO3js7VQL8cl7Pdf2TMgO6cJcnCor2ugkEsY7IEnDCckzx417Z+h2Mes14vTkHy4HmoyHLpK2nU9fVRL9ZCvuTuzvRTqBbfPXjtUpHqpYDgEH9si+HNdAOFTZoagLckfIT75GNsPdoRE5sA6SdYRov6ZN3TAFcOEpsRTFqrX5sCK9ZeR9ZV5FwI+JkTM+15x4TlVh1Sdi8sTjW+giR41kPk5Y+hAqJ/w+AJCe86mL3ZXpPUzP0TL51J3FBQS+rPef/VvM9aiJxXWVZiwG1KN4HyXCjRH7frdiHA6O3VMSp4VvwrIK99uxTpdpJc5OmvgXcTQHrn5aDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4p4lCisKZhGltqqTYeqbMUd9BsCO3YBBtYlK2L/W218=;
 b=JAsChBZZ2w2zlQnvOOP7/+J9ptLtorm8WNbGfeysf4DDsIZbII5tQvOoZjDJvBNKc0lcFaAGZrNMGhDzcEZUOk+HTgM4I8SrSvDDn24fQfiTX6BMNMSQwBNygW1gLbbHDf2/anEbKrE5Z5qQbWIdjupaj9Sf+yl3mqs/dPUNKr7rcf2MkDjDafr8X9NN/cuE8JvCHHTFQ6APLGuOjG992pWMqmnEGRka5I8xVcTSYe/VWIGjI+UGzwOD7bHSeE/XxKqipn6Fck5DE5iZ6Mc9iGRs1+XtIxrFxnQyJzZuYjNuN/dd52adiL+ZpPS6LBv7ovI+/NRfIdFFZQel9YjufQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4p4lCisKZhGltqqTYeqbMUd9BsCO3YBBtYlK2L/W218=;
 b=mHAu7FtFkSPjKEuaLgN/gK0aLa1Q645/6hKx31VNSG/7HdrECihNKfSMoZ/dygiNbW0T6gZvqsoQBNtdBjdjqGoO8/ERjqKMZE5lKGFZ4BN3jx+C1E0EiArkJLw+xC4RN3xwlX69KuHNEwBhqPZPaBEoKSLuceX69G312xw/GuzvUQPK+E0ADPK9nyJcHCZ3NIMia2x/ehb9DAjuBoe4sZY0JP7xjwoRnanPW9FhoB4SGDIoK1yND9F+adRs39FS8JhhbAm0o21oCXTAR98Q+HWhcQlcT7j+8JqZvyJyt8sZiyjjYjsHEiyaAnoVHtEEp+U54kJeulP3Dqbc20UBog==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BYAPR12MB2743.namprd12.prod.outlook.com (2603:10b6:a03:61::28)
 by MW6PR12MB8733.namprd12.prod.outlook.com (2603:10b6:303:24c::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.29; Mon, 12 Jun
 2023 21:15:59 +0000
Received: from BYAPR12MB2743.namprd12.prod.outlook.com
 ([fe80::ecb0:2f8e:c4bf:b471]) by BYAPR12MB2743.namprd12.prod.outlook.com
 ([fe80::ecb0:2f8e:c4bf:b471%6]) with mapi id 15.20.6455.030; Mon, 12 Jun 2023
 21:15:59 +0000
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
	Rahul Rameshbabu <rrameshbabu@nvidia.com>
Subject: [PATCH v3 2/9] docs: ptp.rst: Add information about NVIDIA Mellanox devices
Date: Mon, 12 Jun 2023 14:14:53 -0700
Message-Id: <20230612211500.309075-3-rrameshbabu@nvidia.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230612211500.309075-1-rrameshbabu@nvidia.com>
References: <20230612211500.309075-1-rrameshbabu@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ2PR07CA0005.namprd07.prod.outlook.com
 (2603:10b6:a03:505::29) To BYAPR12MB2743.namprd12.prod.outlook.com
 (2603:10b6:a03:61::28)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR12MB2743:EE_|MW6PR12MB8733:EE_
X-MS-Office365-Filtering-Correlation-Id: 0a52be43-56b4-431a-8c62-08db6b8a2c79
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	7MOA6S21hmgBTOsmYwa2UjEcc3qsUFJMrWSk2xGodRWYk7oPdJZ6oaEp2933tCuq4K6Pf4oRceNgn/kyKmnIlA1CN9h3IggH1EXV7vcRS6mP9viJ0jc4YX9JE+sOOHyb3qj3FRKbVg0dnf120eLfBkB1ymBzMAkv4nwfZdD02BzbmFgHisiDQjHHL4VUIPvdMrhXi5TzeCLVMoHzgWeqe31zcwyzIgddM+sA/ekne/Ze57rLJfnWDZJ+fuHI+kzulf+OYrllt4V0nWw/HhUe5jYvMqVrhy9+5DHW0tz8pslkbyGeaoObOckf1QBmrJYYORbO8EHRuWjSX8UHDH48xhT8Om6oNibpI7cNww5L2shhk7WLZBTqeX8aLrSRawz3fd8DCcda7+v5IUzhQ+UmwhpwyQHJUukP4pYQXUoWUbcPGn66fT0uVbVvwGacll18xVfwfrzABdlkwidvX3C7aCzvdJvd1Vx9dMlG8NLM3LexZeOHOYmbGwjqPFVGHNJfIhbq6QkCG/9CvsMwf+FnWhU8h+4hUQpgEKcZtZvHG+bNuvRlyt4ZJuuPcvloIH/9
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB2743.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(39860400002)(396003)(346002)(136003)(376002)(451199021)(6916009)(4326008)(66946007)(66476007)(66556008)(36756003)(186003)(478600001)(54906003)(2616005)(2906002)(8676002)(316002)(41300700001)(107886003)(86362001)(6486002)(6666004)(6506007)(1076003)(8936002)(83380400001)(5660300002)(26005)(38100700002)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?SEYIdMt1A2ShzQHwIxY/fduKXXQOUsYO7d9sE3MG3iY4rryV2qbAkE9azIWo?=
 =?us-ascii?Q?1t7pi5B9wFGokPS/pj8zA5OT7rtzB3wIg6/Rq764k34Ee7+yYik7EBqqey73?=
 =?us-ascii?Q?Tq/UoiECPzKqgsyqDapnIg3pNEk+YbR8ublU4cH0CJhwWltthYr8QQcTf+as?=
 =?us-ascii?Q?F3H95ntZU2RgheVBQBjhz9q/GvVZjr7LCFMi69m5j6LPzLUEbqGNT4tlSM7u?=
 =?us-ascii?Q?JJ6kmzT+v5+tSZfR43CDAIwzIFwoLunB53KqxqODdMLD9qvml873pXhAgAyb?=
 =?us-ascii?Q?ImtEFfZomaupDzbKmjPoNF6iTrPpV7xyTRt0QctSsdLZjFscCKaQRmu7zpPo?=
 =?us-ascii?Q?kv4jmlNX5OwriZpK/qP3o3YgToO9d06Zj8fwP6u6USZb5f2kCjxnWq+PRodW?=
 =?us-ascii?Q?GADD7/7i8iW4UOAJZHL+oIoBuChVTqpSYHixQ4SBbyCnv89/XM6H6OF95FYH?=
 =?us-ascii?Q?2yO1kFS2TH9nG9H7ECAyc7xueubcGr4BWTMT3BbOnGGe6pojyW3NZsd+ieI2?=
 =?us-ascii?Q?SLfXbfn8bYiaBrCnAuoJwqbDIbIMyTVX06XaJzHtVMwnPO9kmH4pozn4RNEU?=
 =?us-ascii?Q?rWTVM9mevOH5QRv4vGPo3DD5npPOD8wO2uOBbkvzksMKblbTucCtJumE2VRs?=
 =?us-ascii?Q?if1TB6VhTwc5TuS+11lxVHNCDEXSSp7PErstqWauR2Vu6TnSqkZwjaox7HX8?=
 =?us-ascii?Q?LS3dzOWKy+02k4FRG0DxTyg90qmLIH/JuXhdYRqrp4Bpgmp9sBQWU1OsL2/3?=
 =?us-ascii?Q?vy3zeyrBN9uqCIknEsEPGSab9phvDMtlWRRM66WOENEikzHGd4CKsnZYAB81?=
 =?us-ascii?Q?R9UJExwxZZyColrCn8Q/qgDkegJsHmNr/qxzRzI6rMMftVHSChxRHqKqx1bc?=
 =?us-ascii?Q?gTLyvP9AiSi4K2KzQ/tv/QN4u8SS8oQrrlDPdV7d6QVYTJbNdPggp3ve7yNQ?=
 =?us-ascii?Q?A+LiPbWKYiSeBaShU0sxCssmYKUbwsATSrUBN3KJzdfv1qqP693EwxvZd6by?=
 =?us-ascii?Q?LLfqAWepJl+LgaWPwpsDhqbLtwbcFj/3i2YZB+jVRwppefCoZD4HuSWTol2Y?=
 =?us-ascii?Q?b87WKop4TgRI3LUwu+o4gt5iSoEUTg0ZAh4ddr3zZ4Nul7Nj1c0Va1wBI4Tz?=
 =?us-ascii?Q?eapmdpe8w86VNomv880R9Bcm2ec8ssZTMvZSvmGEqMybfPWYAyxmRtq5Gz2E?=
 =?us-ascii?Q?pByy94WG69SGeeHvKv7bPIWFwNBB3NGyMsxEt4z2NL+SC8xqNBwvJE2y3uIn?=
 =?us-ascii?Q?u+0B4I/N0gAKnlEJpa5MtpjwkWxy3bAsiGZTj91xvvE9z4zEtitBMxQt8U7/?=
 =?us-ascii?Q?4ZsjqxMkiU53Pr1u5cUODQIMA/DeGshjoHFKO858cYo3yRryPdwHwdafuB7P?=
 =?us-ascii?Q?CcaX+f7NFuM94V1t/8wYPXGLPhW1+Zbpqq8E6eLh+FHVmi8BuObq1qyfVv1o?=
 =?us-ascii?Q?sqKCpTOcMkhZYV7T7XDZcbUYzCdzdInwKU8xJ3ia7B6af0z5EBrM6ATv5wCD?=
 =?us-ascii?Q?6+XxVsYlyitHTLJDVDqrY6INjeCV32Gd6p7qzLzqIaIsXgsVlf96DUd+/wFk?=
 =?us-ascii?Q?KxSdxWl0aN5eNOetyhzP0geznvv1gX19b91JBfBRFoIZbyD6ktqyaUGxCgHY?=
 =?us-ascii?Q?hQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a52be43-56b4-431a-8c62-08db6b8a2c79
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB2743.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jun 2023 21:15:40.1114
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hFHT7YB8gAs0LHPNcYoF1hFX8Tws3fXF9Y1Pz763iRk/MqaLGBPsXfSx/f2M8i7IngK77hFOP7RlPG/nRVSWVQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR12MB8733
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

The mlx5_core driver has implemented ptp clock driver functionality but
lacked documentation about the PTP devices. This patch adds information
about the Mellanox device family.

Signed-off-by: Rahul Rameshbabu <rrameshbabu@nvidia.com>
Acked-by: Richard Cochran <richardcochran@gmail.com>
---
 Documentation/driver-api/ptp.rst | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/Documentation/driver-api/ptp.rst b/Documentation/driver-api/ptp.rst
index 4552a1f20488..5e033c3b11b3 100644
--- a/Documentation/driver-api/ptp.rst
+++ b/Documentation/driver-api/ptp.rst
@@ -122,3 +122,16 @@ Supported hardware
           - LPF settings (bandwidth, phase limiting, automatic holdover, physical layer assist (per ITU-T G.8273.2))
           - Programmable output PTP clocks, any frequency up to 1GHz (to other PHY/MAC time stampers, refclk to ASSPs/SoCs/FPGAs)
           - Lock to GNSS input, automatic switching between GNSS and user-space PHC control (optional)
+
+   * NVIDIA Mellanox
+
+     - GPIO
+          - Certain variants of ConnectX-6 Dx and later products support one
+            GPIO which can time stamp external triggers and one GPIO to produce
+            periodic signals.
+          - Certain variants of ConnectX-5 and older products support one GPIO,
+            configured to either time stamp external triggers or produce
+            periodic signals.
+     - PHC instances
+          - All ConnectX devices have a free-running counter
+          - ConnectX-6 Dx and later devices have a UTC format counter
-- 
2.40.1



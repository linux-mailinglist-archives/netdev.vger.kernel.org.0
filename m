Return-Path: <netdev+bounces-10243-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7429D72D31C
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 23:18:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2A2202811D2
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 21:18:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F0A1722D4A;
	Mon, 12 Jun 2023 21:17:28 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7780C8C1
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 21:17:28 +0000 (UTC)
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2045.outbound.protection.outlook.com [40.107.94.45])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 586E519A8
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 14:16:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JS8oDFlfGrnPETkZucq2QeFdltRNUe1JH43jz6xpGGcL+KJj3o+b5Rx8rB0UDJZKQ+Omq2VNfQFKUHbqPNC1hoIn9be93GX4Eo6+HBiiz/BdGuoX6u2HX8tFItpZNzzXMsqJDLN4WAma/lmUOwOIafN2wO7Vg8GrdRksI/t5uAyVV86G5P9/kZPZHCAvK5liPcT8yUWxV3JIac1yaUgrzH/IWD0qgUWFP2lH8SzOs6hAMtYvW1K8xmF/6fiu9MOeVW2UEZhlN8m+yu7AAqKUp2Mq9KIRsz+yufjJHXi/vbe+jFnFIwat6o2n5rrNwbyJBrgUTb7AkE0263VCDxpWyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PFM1f92U9hdT0xdRvZRhlkBEasPPgOajlyfZvpJoMLU=;
 b=MGaS5sBok6/lqaNP+SMq14BjTeMlI/a/oAAtKBqXYPo9B7I2Z9X9sZFkDnjShxBnHuZTICL2rWwyalw402xFhkHln1GJrqB6ioEOyEwp+QW/YQSNoK8GaXzxKyQd6Zfd/QezBi+RClPKFTa7uGdiMFphtb+p8yWY0DdLmXPcKm3kZrAQeS3iHl2AH16N6h/pEBk/lvVMlld3h/zGnIrM51SpZl7apTH72ufGtynVg2uvQJoINNz5BHq+NBuaw0EbkvGlmP5oYv2mHgpwKfqQmCWQouLP696DzJhNiDFeraiBaFT03LUX5MICWh8mNOaJX0402M6rMUdKusePmQvlvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PFM1f92U9hdT0xdRvZRhlkBEasPPgOajlyfZvpJoMLU=;
 b=O4ckKA6l9tL2bKKIUCHKxh1qJazmXYosItP3tGD59W3Zyy4r4FPRdHkko9sBIMzTGhdv8j+YrVeghpO5Lv6eaRJ8etCC/n/Op6kc94t2uIl7rbHdrp8bsZTfvRxBvoKa2VDCIcIrrDa3w1GoAH5JS7j3RX/xFclXPgTy2MXrvfeT/M6jUZkfswnwfpehztVdM/ow5Ww+F9b+lawMco6/N9Tmavtp2J+/LNamlOtL/BKv2Jc0qqjVdpETORUfY+Dtze46D5aZF4TLr2ooc0iqmS4vpdhK6Uic7jXkJuICKylkOL4HF+82pf4byjQ1F23Ihfy2yFpiXLH53jQz6iAw/g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BYAPR12MB2743.namprd12.prod.outlook.com (2603:10b6:a03:61::28)
 by CO6PR12MB5441.namprd12.prod.outlook.com (2603:10b6:303:13b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.46; Mon, 12 Jun
 2023 21:16:14 +0000
Received: from BYAPR12MB2743.namprd12.prod.outlook.com
 ([fe80::ecb0:2f8e:c4bf:b471]) by BYAPR12MB2743.namprd12.prod.outlook.com
 ([fe80::ecb0:2f8e:c4bf:b471%6]) with mapi id 15.20.6455.030; Mon, 12 Jun 2023
 21:16:14 +0000
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
	Jonathan Lemon <jonathan.lemon@gmail.com>,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>
Subject: [PATCH v3 9/9] ptp: ocp: Add .getmaxphase ptp_clock_info callback
Date: Mon, 12 Jun 2023 14:15:00 -0700
Message-Id: <20230612211500.309075-10-rrameshbabu@nvidia.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230612211500.309075-1-rrameshbabu@nvidia.com>
References: <20230612211500.309075-1-rrameshbabu@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0275.namprd03.prod.outlook.com
 (2603:10b6:a03:39e::10) To BYAPR12MB2743.namprd12.prod.outlook.com
 (2603:10b6:a03:61::28)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR12MB2743:EE_|CO6PR12MB5441:EE_
X-MS-Office365-Filtering-Correlation-Id: 129afd0b-396d-43dc-9bf6-08db6b8a4110
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	awLyTozg4nrKUQAUNBiutFq+AeSijhTGlRGbt+xsJ5Tnyq+mxb2UkoO6AboFaGTBNhoe8lcQ4Ud6/y0Qx53aZLI75gn5VopRju4PrgHpSUJ/eR4PJvTgdfwwSHyWUx3lbpMS3WMOjRsPUZwOt2bKKDvQZFYTaTv26WYPGfDMa2bgXDnhki7prHuvmupvVr+Fcm0tstj4c/n6/Py5zVSGQUhOkLpQifbxFAgprKacYhgB7U6HNoOTW3D8swMy5cCwdHDqIeYOK6161YZ4B9StW1sLXi3rKIrPRz7SS6DsGmyfrZp4c5Cbboh+w3+5R29QWNIor6fsrx+ImmhH2KA43iufswdzE8tk6J9gNXMCjxmi0EiYcKeBPIbkDLb1Gsand0lKH236Up2mS+b6NGVFRt4ptRnAkWCQEKkDTP/FyCL4XyxU4IlwQOPGqPzvJ8ulfJNF1Vem9Y4UW1ViI+suL777U+DS0RhkG+a3Dx7fq0dyC0xSzQsXZeHMtuxSgoRkn1jQK6Zc20PS5jXdhJr6MaLcSi8QVhD/KF0FAqLGnHR2UARPP0ItRtg9x2iF4b110TOIfGZch+wN44UKrAUYPwOeLqdyYhkJK/Gy/sA3mC+0RetXUpy6+urnAeq89q4P
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB2743.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(366004)(39860400002)(396003)(376002)(136003)(451199021)(36756003)(2906002)(86362001)(5660300002)(186003)(83380400001)(6666004)(6512007)(1076003)(6506007)(26005)(6486002)(54906003)(66946007)(66556008)(66476007)(4326008)(2616005)(316002)(38100700002)(6916009)(478600001)(8936002)(8676002)(41300700001)(142923001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?I1JbeS3tgGKGWr7m/+DJjLdrYbXPnym+a6/GsocR+ee/XvObtsYF6946+ri7?=
 =?us-ascii?Q?mSzhno3Sq2nn6zugQnUywMG0lr4JaWB1a/hsr0l3zO8Hte7lTsBqPvFZhdXK?=
 =?us-ascii?Q?rajRLwRij6OEcGirY47TEKg6isBOu+DGY9w3vt7HQjut9BiL/ZV8jM8tk2AZ?=
 =?us-ascii?Q?fGAu5ncFVGiQlu9I5oY1UOWFemNzz10pbNBOCHbtBXPSuUcBm+wDciceDlKW?=
 =?us-ascii?Q?fvj2WNBbU+e2orRgrLPDzTj5qwmqiCKywBgE9xHnfdhqjO6QyJs/fCe1pGho?=
 =?us-ascii?Q?tCKdOwsy3rTAmgGR3PxLlccIZ2GNKBXchRcGVuXLxVnlIi0KUQ/0At6JduL+?=
 =?us-ascii?Q?N9338IS841eCYmlh4UDp61C+w0c9Lt/m2DSs27T6PNzZ22D8U6niMHXI9oAB?=
 =?us-ascii?Q?fdf2tUbjbCqpC8dZLRkrPx0cLUbUqlwFLRU4wnj+63ITaE6OsvWUoETzCc7H?=
 =?us-ascii?Q?bOGnLUDetimwo28GIuMlX0DiOIAkFz8qXgL49YpOuwPFGUwYuRkhq2rxKHTB?=
 =?us-ascii?Q?rSvNKPkcuYQbOgsKR8mJ5DHwu270AzdqOvR0orescwTtx/5bJgHB8kaRT6S/?=
 =?us-ascii?Q?84+MYgsARASV81zQGrnVEykjIhIs40f0EaecoKpimdQbRE22444iZVxn7H7/?=
 =?us-ascii?Q?Tao/wGYl/7gQOdn1IjJVTtAQUsWbc5Fb1+nL9egHNwmhDi9M4SqGHZqxqLIw?=
 =?us-ascii?Q?7R4Aec8In/fLWXN5Z1JoyM/o+89+/94hAgq9O4FPkGoCLg9MOE7ErPmXrzBN?=
 =?us-ascii?Q?n2XO8lCdt7daaZFpDl3k5gaUHf/bRyPjQCPAAyW+/Cpmq2z/PJWOixo0WgQP?=
 =?us-ascii?Q?tM8c7h0qBdA8R+uWunRuv1pDrd2qSDKDoLHnZqm8ySSDxbtScYooRBVF1JDM?=
 =?us-ascii?Q?VqdGulhGxUDGHm+7AHI02pwZn07RWc1COyOoc0xb6Cbd089LDXjeCyA2FXOG?=
 =?us-ascii?Q?7YwUogDa2fs7c32tb1wpQ2vrbIGn3gq8GD3H6XzXWHmqBCJA8qvvOc7l+sJp?=
 =?us-ascii?Q?rSarnOuypCAxtQqLl5C9VLK0VAReGRz1n6Q2Ausq8P11459+iswfzwIEu6lD?=
 =?us-ascii?Q?6wNLnFQfGv8aIsMVEVgKNhosltj8WwqoJrSuObKIjVtQkQ+Q5n32kU2cbYUx?=
 =?us-ascii?Q?evm1pF19jwRD4jSDaUwqttGArqmBCUJcGJPAUwd0xXjTrNyW7qX4wbOJvUEm?=
 =?us-ascii?Q?rEUP78/7XIjept/eNzA3hUqdXa0cwt56d+dWR5XHxNUvu7p+YMfZuqRcsbEm?=
 =?us-ascii?Q?29xNjU7sPIKswlCxITJP+5P0Y5uUH/pT46cqQRMtp0QNBILzyuDKf18E8Hwt?=
 =?us-ascii?Q?YeXw5GL6yqF6L+QPeNlm2YKu6Wu3sN3JN7CGfeDX9CoV2EDXC8E+S0uQ2Ef6?=
 =?us-ascii?Q?qRgpCt/v+yTPg3uKp6uL/M9WDB0PUs6oJ3B6/J7AjbxfD3j6Qj1aZNbfjN5T?=
 =?us-ascii?Q?mkeaiuHNLMHie/hGnmMeJfcU5qhJYzt9hw6DHdTz5J5X7SFiEUqSl5aX0Xmm?=
 =?us-ascii?Q?GFbRO85jjHY3jRQ9iI+siquOsv67PYpB7gXyATsPe+wX+NXYe3vOMgGqG6Kp?=
 =?us-ascii?Q?KOiw/VT+NjNhiXgMb7ZIV4+TptNAvUSfAgZkr42y?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 129afd0b-396d-43dc-9bf6-08db6b8a4110
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB2743.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jun 2023 21:16:14.5548
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 25FwI7/GLh6W9y/a/Dphq2nLryRtIK5yvZ+WqbeCKmCZKCXl3s1YZeuGvCM2KB4btXwRn81KDCRLKD2GhtLPRg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR12MB5441
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Add a function that advertises a maximum offset of zero supported by
ptp_clock_info .adjphase in the OCP null ptp implementation.

Cc: Richard Cochran <richardcochran@gmail.com>
Cc: Jonathan Lemon <jonathan.lemon@gmail.com>
Cc: Vadim Fedorenko <vadim.fedorenko@linux.dev>
Signed-off-by: Rahul Rameshbabu <rrameshbabu@nvidia.com>
Acked-by: Vadim Fedorenko <vadim.fedorenko@linux.dev>
---
 drivers/ptp/ptp_ocp.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/ptp/ptp_ocp.c b/drivers/ptp/ptp_ocp.c
index ab8cab4d1560..20a974ced8d6 100644
--- a/drivers/ptp/ptp_ocp.c
+++ b/drivers/ptp/ptp_ocp.c
@@ -1124,6 +1124,12 @@ ptp_ocp_null_adjfine(struct ptp_clock_info *ptp_info, long scaled_ppm)
 	return -EOPNOTSUPP;
 }
 
+static s32
+ptp_ocp_null_getmaxphase(struct ptp_clock_info *ptp_info)
+{
+	return 0;
+}
+
 static int
 ptp_ocp_null_adjphase(struct ptp_clock_info *ptp_info, s32 phase_ns)
 {
@@ -1239,6 +1245,7 @@ static const struct ptp_clock_info ptp_ocp_clock_info = {
 	.adjtime	= ptp_ocp_adjtime,
 	.adjfine	= ptp_ocp_null_adjfine,
 	.adjphase	= ptp_ocp_null_adjphase,
+	.getmaxphase	= ptp_ocp_null_getmaxphase,
 	.enable		= ptp_ocp_enable,
 	.verify		= ptp_ocp_verify,
 	.pps		= true,
-- 
2.40.1



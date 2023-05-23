Return-Path: <netdev+bounces-4810-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6C6FE70E703
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 22:58:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2766E28134E
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 20:58:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C0B74BA34;
	Tue, 23 May 2023 20:56:51 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD412C134
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 20:56:51 +0000 (UTC)
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2042.outbound.protection.outlook.com [40.107.93.42])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45665E4B
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 13:56:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D2DTPsYY5zh3eQac7d9rHOIJTw4jc4POqz3yzl9BdrH3VJhVawFm0IT9RNCHtn0CIaVxkwA2HGXhdLbBJEts+PjcRNTgvAGzZEuUaXrP9Du3rsz3CQyJpRMcAnsAVA8FFkChih/QZe/JvBVgginrKyrXj3tfJVujb7Kdgq3JmT7qImSO9yShF8YK7OBqwQznViJIXsWQdlhHdu/IxCykQhdHVCbN0jKyeCaJUt41Eh1DEnWa4iCaXDAzmfSkK3nuv5OA5yqreDAVZA0vb0tnVuwD5X0P8G8HEwRuxw4xsBgKWPI4vcDoMMcjnz8ioWeNx4+8lqRsYc1EuzDuHPKyvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GPmxFngQQgr0kN3qb8mmzaK0A2nMHAgmaVGtoKkoqXU=;
 b=YMA6GMii/kdFc27+piGU8KR56kkNSGbaJIJme/m99SSNHH0/BrKkx750oJLc0W9xBeVJmtl4jXZ7atNzKOP+Szdsmo0tIIEHpivntkczXTV2FOeH31D0vRVvO8HeW4h1/+Oo4FIKG4TR//0PI75adQ8jCCkl7QioRx2oijmXPrzb2flvbTsATetBroFFLN6Efk8e37goopPncak8OYNhdkn/iMm3Nl1whIbGjZcG/mjmlVumbciCs4UNFq8GjeJ8yPoANUM/Uqvezxh1/Rs0fbFIg1mw8WmPjOmGTeb8f8pyh6fv7pW8qg5hfXfnxBS8cE2du25ofOIlXV/I44V5yw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GPmxFngQQgr0kN3qb8mmzaK0A2nMHAgmaVGtoKkoqXU=;
 b=LNJrOsdWw3k5ee9tzLv5ExtA2ovhMezvK6lTnjRWi+t0xFxK7NcdHinEersZk6a9C6t+95RlmKU3OeDNuHhcpdOP2VSZcdieDxDpKkEkiM9WxXQdypMYedKCsnRwZFTd1Grihz0GYSaQRMcyBruhEkYk7e38LozQP+MdEOtDLpCBifBqPkuXiyDZ5PIMAy4Jp5roEI1e3LOGido26HyC7N7ZSgk6rIz0dJVqa1JUirruvru4QjRo3tSJpRqyb4da5UBnWGLQ3MIfI5iZ19oUNJT4dUWbLB1I6Iu4h30S0wsrUSFEbsoqG0HOv3PJRFwWQRS3jXo/kQJwnj1fIKqWSQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BYAPR12MB2743.namprd12.prod.outlook.com (2603:10b6:a03:61::28)
 by CY8PR12MB7193.namprd12.prod.outlook.com (2603:10b6:930:5b::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.28; Tue, 23 May
 2023 20:56:05 +0000
Received: from BYAPR12MB2743.namprd12.prod.outlook.com
 ([fe80::f3d4:f48a:1bfc:dbf1]) by BYAPR12MB2743.namprd12.prod.outlook.com
 ([fe80::f3d4:f48a:1bfc:dbf1%5]) with mapi id 15.20.6411.019; Tue, 23 May 2023
 20:56:05 +0000
From: Rahul Rameshbabu <rrameshbabu@nvidia.com>
To: netdev@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Gal Pressman <gal@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Saeed Mahameed <saeed@kernel.org>,
	Rahul Rameshbabu <rrameshbabu@nvidia.com>,
	Richard Cochran <richardcochran@gmail.com>,
	Jonathan Lemon <jonathan.lemon@gmail.com>,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>
Subject: [PATCH net-next v2 9/9] ptp: ocp: Add .getmaxphase ptp_clock_info callback
Date: Tue, 23 May 2023 13:54:40 -0700
Message-Id: <20230523205440.326934-10-rrameshbabu@nvidia.com>
X-Mailer: git-send-email 2.38.4
In-Reply-To: <20230523205440.326934-1-rrameshbabu@nvidia.com>
References: <20230523205440.326934-1-rrameshbabu@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR11CA0107.namprd11.prod.outlook.com
 (2603:10b6:a03:f4::48) To BYAPR12MB2743.namprd12.prod.outlook.com
 (2603:10b6:a03:61::28)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR12MB2743:EE_|CY8PR12MB7193:EE_
X-MS-Office365-Filtering-Correlation-Id: 5e306b13-2b57-44d1-40d3-08db5bd01ff6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	q1AhNeq9NRZngWtZo69KnVl0jrB4pKXRZVDcJwyYYqQBRNADcRphi8KbDpvVvXP91cNMEtsVAfQUyc/ibzLLUv16qV4ktMmA7C1cyFs7UtStewYMDQ1IOTrAWu7YkUkbMs1QhOnOmJbgdMLUu5Tjt20lx2URdQuYzXTJQH+SlwiWxOFNh5wPPIAhRyesbl4lBifJNjjNSpVk2ZJaWcnLcvda3Ag6BOWemUgWCEAkzwtljcZjV6QfN4ap59I9W0e284KaIgrkNkqIE9Ih0Np+/qCBrJF4ZDcMyKLSqNK51KV5+lPSEQSm9lyDmU88o57HlwGxSWKN12/+QyiMywrl0KAgnSpY90fZlXUKjReJTnR8YdfCO+kOgBBbmDZPdkLKQWwKnL7PUA1sEjzJyKFuGkHWm9k3Ak3HXsyhfVRumF0d0KweIf4tiHVM5g/DSHeucwqsIi6td0IOUNic4dkVlcdQvaVmBhBozQs2aDAlxvjXO9ENnpFkItWZzzrhIw3/O8YItF9ZxUdTCkeSJtsZ226NgMdUwc1E12QhqbMW/ojPnb0VeRDxOzDbobf2CwMsbXGvMcwPbSt8TSgI2GCasOCvdXBHJO5RKKlZEwqB8YjKoghIxZ+g/qa2G1fghVFO
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB2743.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(396003)(136003)(346002)(366004)(376002)(451199021)(316002)(54906003)(66556008)(4326008)(66476007)(6916009)(66946007)(41300700001)(6486002)(6666004)(478600001)(38100700002)(86362001)(5660300002)(8936002)(8676002)(186003)(26005)(6512007)(6506007)(1076003)(36756003)(83380400001)(2906002)(2616005)(142923001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?RPGI3DKQztiMsgQmP8Ktmc5+4op8clC+d/THYTbH4xxjg/xpfGYoVKbhs5Jx?=
 =?us-ascii?Q?LjLanmLLU4YZd2OVwt+l46EW2OGfZH4hvrrGSAH3uKHpUKQSkGjDy0VFUmKX?=
 =?us-ascii?Q?GVBCg8KI/4bVRWwX6pn2fN7Jm6R91571QjMfN5orJfqq3Vmfu5CDmUsZbuHt?=
 =?us-ascii?Q?82t5p2J1ZF6IWbet5J8Byfy/5oZz340sGTrWKQUatrd/BLjbYJLtGPgII72C?=
 =?us-ascii?Q?AymZgtzJ24nhfWh93E69ycu2FlSqYbzd6375YlxoZOHqZBgY9pIIoOF+8QNz?=
 =?us-ascii?Q?TR8Ro+/m0iBC+UAi94kXGfy/1cuC7uFki1iaA/O53ibfbGVJCKI3fFJR9XqM?=
 =?us-ascii?Q?A6ceArmy77ee/kLcx4YDGaD/Y/xkgRuZb/0cO8SFi/Q0QGR3H4QWgnbHDChq?=
 =?us-ascii?Q?qBQ1ByK9iWp7zik3RfnI7yp2TV12q0AYqbVwNQrWevwvUQ5fOMUArAPV5yBH?=
 =?us-ascii?Q?HgCcmnorSG0hkdFo0zfw6i28ZTYgsNyIu5cJNyytEzsWXsuWTAaxqoplkI/b?=
 =?us-ascii?Q?b7mqsQtRFMqsC+3j9LbtuMlzgdHYIwnKb6FNirKQz/8quWwp3G/utPOAMXVP?=
 =?us-ascii?Q?K3ZwIes1oZ03mv92e/cEtetFFkSI0Sg2eU+B2UvG/Oe0yK9G/90yk1QoNeWG?=
 =?us-ascii?Q?GxNb4Iy9e1VMLp5t3lPBpc0TptwrLXuvZKzOZWrtHqUjQDLVy0fTf3FAQWm/?=
 =?us-ascii?Q?DCQ78o+JxViK5dA7848vXx/Dpe2Z0HcMbqnD6ryqqHFrBQz9gMPrW6bYOiDn?=
 =?us-ascii?Q?bo/i5X1F4pgEV9GMvCMOY6JIyMsoxjLwyd6acblczvuhtX15R20rmkPYr/J8?=
 =?us-ascii?Q?v91XQo9q34sXSycTC/zsXEEU0YSd3/5YrGF3wxhKaEu2avqZM8smv5CiygDH?=
 =?us-ascii?Q?yMOVuUNimxv4o3I0ahXuKlMe3ljdtCLEyaOHpZE/s89rk1h+wvBBKHumau3f?=
 =?us-ascii?Q?0+nj4dNUA3kVioJv9EVs0tRul95LylSpUQI9wyjzWDIpcdgHBG+XzHc8m1WF?=
 =?us-ascii?Q?mGki6ZpkF4WAI+Fq9E9UU0hyAi1rFVcM8x/la3F+OhYdAeZLMrCpo9B/NPxE?=
 =?us-ascii?Q?AGfU2mwTeTxbGccRCnSR1OBOvR9bTgY+U4kxkusNHFqRQSIDVUUYKa2KzFAM?=
 =?us-ascii?Q?SP4NpQTW5Ba9vByMskex3rwM2HRwC50jxqtGiGziab+is5oQHZygdo+40k0M?=
 =?us-ascii?Q?5mqoa8amvcwi/xnf1wY7D75ZK9QJVqcOxKoJF3Fpj9ElFYBI7eN2oS8lek0C?=
 =?us-ascii?Q?0akWZkUHkVDHr0fhqfQ/F+SF/R3abPUyE/GZvkvJGYUY/p2Y8AcNKqyEXFtx?=
 =?us-ascii?Q?ccRdsbbqS9eq224weWbwlXq+av44oUQSgpTOzbn+MdQMk1lJ6JHw+D1CuOfP?=
 =?us-ascii?Q?d0aM2T2cZtvYmlSUr+MnI9D+7T/0bxehjQcXjTzMAK8/35fab1Tg24KxRBE+?=
 =?us-ascii?Q?SCzEsyC0tlKY6U/cf1cY92fkDJYHbnDEF05Iuymu4SW/hF0PJKvRVA6Xox68?=
 =?us-ascii?Q?z+oM+Nfas5PUl1OhNzRg4qIzgjnfvt63OeMkXK5vg0/qssbqTlrlxlHmcGXA?=
 =?us-ascii?Q?gOKxo2NfO1p/Xb0uL2xR0TPBwDY4dMJAH1knbhGAyzLkHgjVXDMWJcY0asSg?=
 =?us-ascii?Q?6A=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e306b13-2b57-44d1-40d3-08db5bd01ff6
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB2743.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 May 2023 20:56:05.2254
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HDl+XkKBMhVz1wXRMFxFubMs4xMIHWSYLUb9f1/+KzORivSX/r99mtrDtRnRRZJrZN922OzpzqG4sLw4JvC//Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7193
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.6
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
2.38.4



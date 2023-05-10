Return-Path: <netdev+bounces-1580-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5250B6FE5E1
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 22:59:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8915B280A52
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 20:59:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 11DCD21CFB;
	Wed, 10 May 2023 20:58:54 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0025C171BA
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 20:58:53 +0000 (UTC)
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2070.outbound.protection.outlook.com [40.107.244.70])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF4837DB9
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 13:58:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YjkRzGsr3YxzkXli55gX+TO7YAz1h4srrTbfDAblttrZeSO5nTM4pLbEz2rwdCtxAtzani7EFNiEis1gLOz+pEl6mMmEjtlVhoZMvmBKly9Nl1mr8QD+Ql6JnGwNkWjxCvkDphlSK96oTVOJ8Na+P4gp5Kv9UjgdcCj9S7+sNFcsUXw2ind0U4cibY232tPpOu1bosRAQhet32lsquCQ0N1gjH7PomOzL9l6tFtYDN/Sjwv7mfANwtCcBWJXRQOle0GIQOuwWb15UNbtolZqEd5tytfs9KLhPKotduRofen8KOK+VD+rXepn6pyqHlGKn+CyxrljSAXYB5e7i2isVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yFDnnQ4asilKB368ly68+XirCAEeJV59SUVtuMjeg74=;
 b=fscA0Zmf+T9XRfuymJISqtUQ1mXV672iMxh81tTDy4EYbvgzCl1VYHGBKrwLDTzeecq4ubmB7pXOY5yMfar/bi9LufgFpMLvIFfzl6FrFJqecrA/nnNPKzy7J7ksJ9WqeE+ZkYnZuqV3JrmofklN8TZUatrnlHMWRi7h1afC31K+XdyX1Ox2UHvvun8HJuAd2dlRkCtJsX6+Rc2AYXokm1lFbi/kb3x+jvK6hnM9mv7AsvtPfMRgVMfU6ccUBC4NV2myBdI3fXfL05ba15v2b6rIBD3g4pCUyW7iTVZ7C/AUvXL6ebwPOJwec5c2OCJtdx9wCOqEVZ4xBo2Q3QAf7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yFDnnQ4asilKB368ly68+XirCAEeJV59SUVtuMjeg74=;
 b=YG3l+aQnhyUF4yY0NwrCQucK1PM2eiD8J8CEBwW6cKdPJTVYm0Mh8sqsVB2E/URVL+mnrY3pwzTMTSuj4wOLVg2egEZ6rfIjmSviCl0FkTKOKJJ2O5y32ESNcvnSAhOOiU8UDrTSCKuhkrCQ+TqMOSiZCmnvc0rrPmF+HM/0II0QEgMxNija0rvBN1s9BjbeSh2c7/ik09WZRp6JePNPQ68T83B2mEajtjcha5toldmDrKUh5UXLKa+yGcqFl0avkb+wZTY11oaxfEx/sNbGJhqlaQ3+TTuAb9RU5t7W3VyXEINRmrV+npJmcx7J3jzELwwhcdn77t4GOzOUo+eeRg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BYAPR12MB2743.namprd12.prod.outlook.com (2603:10b6:a03:61::28)
 by MW5PR12MB5624.namprd12.prod.outlook.com (2603:10b6:303:19d::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.18; Wed, 10 May
 2023 20:54:15 +0000
Received: from BYAPR12MB2743.namprd12.prod.outlook.com
 ([fe80::de5a:9000:2d2f:a861]) by BYAPR12MB2743.namprd12.prod.outlook.com
 ([fe80::de5a:9000:2d2f:a861%7]) with mapi id 15.20.6363.033; Wed, 10 May 2023
 20:54:15 +0000
From: Rahul Rameshbabu <rrameshbabu@nvidia.com>
To: netdev@vger.kernel.org
Cc: Saeed Mahameed <saeed@kernel.org>,
	Gal Pressman <gal@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Richard Cochran <richardcochran@gmail.com>,
	Jacob Keller <jacob.e.keller@intel.com>
Subject: [PATCH net-next 9/9] ptp: ocp: Add .getmaxphase ptp_clock_info callback
Date: Wed, 10 May 2023 13:53:06 -0700
Message-Id: <20230510205306.136766-10-rrameshbabu@nvidia.com>
X-Mailer: git-send-email 2.38.4
In-Reply-To: <20230510205306.136766-1-rrameshbabu@nvidia.com>
References: <20230510205306.136766-1-rrameshbabu@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR02CA0067.namprd02.prod.outlook.com
 (2603:10b6:a03:54::44) To BYAPR12MB2743.namprd12.prod.outlook.com
 (2603:10b6:a03:61::28)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR12MB2743:EE_|MW5PR12MB5624:EE_
X-MS-Office365-Filtering-Correlation-Id: e87162e3-3603-4a90-aa5a-08db5198b6e5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	7LmH91RtnjZ3nT3tJvpeRZT5JSBltCINwRHFlA9E2mLD6O6gLrWCKCKc1vfHdJTucAtF+cy1rEDfeAhaTQeCW42GA7GXsFfj3pgc09n0L/QW7mkvHMfO5FbuBcuTP+hpnQi3N0wVtDHIsFlH5e2rW6MQhWZbb/Wp1PtQLnBiprWv0EofRWLp7z8bUkoHLHVmbCkIx0bgoseKR0zDhuiwC6zdmlMh5sJX3JXm7FTDKrdrjWsP7ybivRQIgl8WKj7y7PoDioFf8EePFJAFIFKbM8Q4i8C6wPnicJPL2nk1cAieSkVinyEVuLv5Rfte7V4mrY+y+cnX2hFpYzENWx5PT8xcCon/0hhKh/VvYHnRDO70Ua+uQKLwqXhe7Bmz7LqNvv5JqNbYTPwaUZcyDgaFy1vLG1988tpov3ywkuP0KRA4yn1bUQkqciNk2p0Gj3QqTdqtPDq+yXO+UZEZpCBk4bBAZl2PrXkuHOfq4xqDqMXXdvsXrerywFqGMFGEuQzoGuDOtE8jsFa4CngQIjFB64m9lR+gq13cTdLIrei2gq4SNJMzq1yXgheu3YTua2bJzDKJGwMctQjLwWqEy7LUDBo3X/SawWTl7/5N8MruVpxXhK/I5jVw/AsLKj0lWsq0
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB2743.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(136003)(39860400002)(366004)(396003)(376002)(451199021)(86362001)(5660300002)(41300700001)(4326008)(6666004)(38100700002)(316002)(6486002)(6506007)(6512007)(26005)(1076003)(478600001)(54906003)(36756003)(2906002)(8936002)(8676002)(186003)(83380400001)(66946007)(6916009)(66476007)(66556008)(2616005)(142923001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?PvTtxtVUBKGa6dVOCuTEQCPuBltUKoK29p0z3bwbI04CfhaGS2/q5SKvRYus?=
 =?us-ascii?Q?islviQI23bR+dUCiNWOb2E/ZbZR2cLwK3CU9wgwc7XiZ0oAXVTejUk7ypRNO?=
 =?us-ascii?Q?/dwoi7QIz2aVnW5h5g/DgOv4qFR/SSt/S/suOLerQqo9FXrEfd4j6443AJIS?=
 =?us-ascii?Q?3VkVywjKw99iYTxTFr7lyUlj2td9mTYffwE9lTDPIdC2GJ8Hu08YaB/kREzP?=
 =?us-ascii?Q?marYPHv+BPEREJQXJvqZ3SVjxYFKle9ne57EQBwecBon2NPGCysMf5T0Eaz9?=
 =?us-ascii?Q?wF6js0BmQEKMufISxRKDTSywCV1P1F8tsQKt8Pn6VSDYp0LYFiBFRD9s64Ko?=
 =?us-ascii?Q?fkIAR3EzUM9wHR1Ziva+gw80AsXxn3lYt6FJopNJ5x3dqTD1DwJKRnlNXLuf?=
 =?us-ascii?Q?vl/Odl/ngLNAFbSX5T5Hy3BOobdp1Gd51Sow8hI7eG/aCHr399mBJJ15OaJA?=
 =?us-ascii?Q?Bt4VhaSOxU9fadubOyUFjybq6nrp9GDQW34axHM5K9mX54Y07QSicoV8FPfC?=
 =?us-ascii?Q?zWAxTqmgPR+zzgfZwx+kG1IGcnXO3E/mckw49iBjj+Vikhj0atOtUxeo9ifs?=
 =?us-ascii?Q?Sdqwwu1JL5GXrFaXD0xaA+BAy8Fhr4McByr/kdZwpexJzW1DML7JLZStHwpz?=
 =?us-ascii?Q?O5sftD4XRYatdj3Z1J2yZZ/GO2Rks0rv5kKHrAbcbQHdLk+kBG2ZgDXGibDA?=
 =?us-ascii?Q?j9Z1+qa1Xy9o9lg6Vn/GBr8a5tmRGsvwMTVTB9hBC5+ER3TyO1KlU8oudAhX?=
 =?us-ascii?Q?CJMCvzAtSEbKvLkRLXXh+aAz7C5iRyls8n88o0NIh7BXF5F+sGNMYk+o2tWm?=
 =?us-ascii?Q?CRKzyOh4CCWGo9rneHAm08neJir9V8tbFMirOSFMqXWL8rjoiQSyVosvNVXI?=
 =?us-ascii?Q?PyUTeGyt0S9Ndp3jCwtVyD0ojGWLC+tPdvSnferbdYvEzqRozlL3mVf+tRok?=
 =?us-ascii?Q?JgBrZXbh3xNvgvygbWqjEIGS0wN+j5aMCI8cvotf7HD2VwkLGLKuUKeE7q5l?=
 =?us-ascii?Q?1aOJSrmY0gRJl1l+myNA7F1jIkvzzVgPkLKzptSpcEeNrUwX5c1wTTFQuu6b?=
 =?us-ascii?Q?kL9vwdYoN2ZfB1KFBDMKLKqKp1gdtaBEgrVclNjVZXRQ+p2zD7bkEOWUHK/M?=
 =?us-ascii?Q?0FGGPUR+7/QPkggjVnGJcuSUfW6CRc18YtRsxVYeeDIIgjCdWbfRqYQYk2je?=
 =?us-ascii?Q?PKr7k6rsMlx6B0MxTfOL29UzPL+w/yNeFD+hEt+iBPf4/QxchXyuzn5JJcsx?=
 =?us-ascii?Q?q/HaWm+9xCRjLae/ZgctUbhWidUQwHADQ05ptplt2+KRfDlNjmmU9WEj7cvA?=
 =?us-ascii?Q?/goQLIzvp2HW0gddswd+tfybaoWH7K0y5RaVx4l3x5QhYRYt1SKAZLqFK46J?=
 =?us-ascii?Q?D7DtTLamdCOp7BBnp0eswK0q1rfg8AiJUZX8scMBhzxvXky3YXL7Xnu70S2d?=
 =?us-ascii?Q?Xgj8C57ly8B9tFPhHWosBnL/zyrxoTifQkXV6cV8Xsp953nIO66CCIA+MaJg?=
 =?us-ascii?Q?zc84iQdyFfZ+rNMDm72ud4bO87JEOK+FlO7SbUFgm2+3PI2gbMvaMdszqwsd?=
 =?us-ascii?Q?m3vgsASezS2ehAl5CZ2HmsBEA8p5xlsgWfYrolQNY41D6qcaYURG5VPZYp23?=
 =?us-ascii?Q?Wg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e87162e3-3603-4a90-aa5a-08db5198b6e5
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB2743.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2023 20:54:15.0252
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lp+Yoyua4h7UNJ/FEtR4WBbT1UGYxRM9glMECh4jKim7wstVzgPlMLJ2e7+XfaCrN00LMeAquUcMlSQiVydr3Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR12MB5624
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
Signed-off-by: Rahul Rameshbabu <rrameshbabu@nvidia.com>
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



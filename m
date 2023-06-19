Return-Path: <netdev+bounces-11976-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BA35273591C
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 16:04:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 884E31C2037C
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 14:04:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6095011C8B;
	Mon, 19 Jun 2023 14:04:44 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AED31119E
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 14:04:44 +0000 (UTC)
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2124.outbound.protection.outlook.com [40.107.100.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AE16FB;
	Mon, 19 Jun 2023 07:04:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CHcZLDU57uCUmpHFpuA0VdNQLgxWo7iEPPVrKiqP+GRZWFdYjSpcGhTjQfL0qwkL+FUMSUiPe9ycw4t0vf1wKePaUIPfC6DgcXALizmFxYC+0F5KpgQQ0igMPhj/MsOF/DmNHHpdkhKlmTOLxfqZO6lj4UqfHtYE4oS1sQa+zS/KmwvbK85qURKzQBX+4LDvN/QcwY8tqgwHCMnqSte78gsi9VOKzPb7+F7odgC94fSqcOO8bXhQYgmk5DYOgnwJZE0XCLj7Jw8dCIgjuePoKP1hUWQxWME4qRbly2BJ/Gu6qgvPKmjzulPyj7XF6lUWZiS+9yzHi/1pc2+BuQUAow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EyPOyztnqaoTeEkmFDGUawDZaPyUeAJpdHLRbbLSUws=;
 b=nPu4GM/eI/7RI0XdyZ7Rvrx2Gh6IaoWNXVNtzZBMhGyxupUni9V25yNCSjzMr3rO9pNuK4JR5bEsIwMiz/bLmtKplnsX9ZpvzeodVkqP7vy3F4JUZ/ZDquWe9FPtG/Q+k7hmf2bCddSRICGBqh9xRv1OBMt3YE8lnEAa6VAOp+IKlRy4v5yijnEifVE/d608KbnjoYg7++ZTWoAGjsqHo+8sxYP9nxb9x6XKMvK7+mBHbITJeNvHXdEgHx9tYZeN5ibtkQso4fwBjnUzhvsS/t3CzyNwv4YMqBOjXD9eh+YaZ1I9Glf4x2NPtwpoZTe8LLLDAv29c+/MhZnHusuWdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EyPOyztnqaoTeEkmFDGUawDZaPyUeAJpdHLRbbLSUws=;
 b=b9xHnWNhDWTsDA76DOFDYgES6i42OrElpUsoPUpUDAPWPlVrtHcEC5D55xH95VXEQIdntnPync2+pmXfIPCFP/fOlk82K7v6ZeefwqilMxazZvznQeF4SPT+MlubFc3Opg+KcvXi3/fMCBVHZa/5f2SU45knMTorvE/AAi5+IfA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by DM6PR13MB4084.namprd13.prod.outlook.com (2603:10b6:5:2a3::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.36; Mon, 19 Jun
 2023 14:04:39 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e%5]) with mapi id 15.20.6500.036; Mon, 19 Jun 2023
 14:04:39 +0000
Date: Mon, 19 Jun 2023 16:04:32 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc: Jeremy Kerr <jk@codeconstruct.com.au>,
	Matt Johnston <matt@codeconstruct.com.au>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
	netdev@vger.kernel.org
Subject: Re: [PATCH net-next] mctp: Reorder fields in 'struct mctp_route'
Message-ID: <ZJBgcOWNJiSpf+4K@corigine.com>
References: <393ad1a5aef0aa28d839eeb3d7477da0e0eeb0b0.1687080803.git.christophe.jaillet@wanadoo.fr>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <393ad1a5aef0aa28d839eeb3d7477da0e0eeb0b0.1687080803.git.christophe.jaillet@wanadoo.fr>
X-ClientProxiedBy: AM0PR02CA0117.eurprd02.prod.outlook.com
 (2603:10a6:20b:28c::14) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|DM6PR13MB4084:EE_
X-MS-Office365-Filtering-Correlation-Id: 114e37fe-341c-40cb-52a1-08db70ce1f3b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	3jQvzoL6DcIj39cgLqxpnlQ+RADg0sSsz20idqaId4yiHk+QRg/5CL1k68Q0LMbFWA6b4AzWg8diFthB0EOuxHJxNVT9Iz+Nbbfj7IwavtLs+hox2x9pKsF2jQ6bwVf0ZtrGaraJOqxDxKerol0AtGcAS94LALwGQOQ63mDSuB5CNj67p4blIORGil9HBHZCQ0CjyFnUSnXih0FkPpMbwlLvlPtMOViB+nJELuFSaeLCXGaAnFgaMPKprjSdULwqRJx4x+pDFVHCHSJ08bIQttQ9WXz+jfxmBxa1tIQLxSwKRdDrRqeXZiREQsIx7kpkx+b/wd7Pg+ZpAU9+Gia5NyGPXA2W6l05XyMfuPIpKBwGVOjCyOC7t8aIK7KJRutfSBU+nbbWVbjlZrtSvCJrnnE+bJwQC2yxxl/qAqoRmN0WAo8gBgUPRZzwbnBBLtd1XPYU09xeeut8qxALO7rp+NvNi8UzyvmmTD5AilAYzHFwbfNSYUeE94YbGq/uXv9Ak/anU1Ui8/yMIEu3rTfogrmr7n2xBy+cms+Eo//KAEJnEOBZCxhW30rGqyQhjDfB3+kDWgcBBGmcIs4anxj4JP6w7ZHpipXqv1hb2MwlzAws375xSegcFzKaRR9mFOKiSLrmXrN8WXp4rLR2yCLB/jpsCfoAjSnWEd+Pc1WBGc4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(366004)(346002)(396003)(39830400003)(136003)(451199021)(478600001)(2906002)(4744005)(54906003)(6666004)(6486002)(2616005)(86362001)(36756003)(186003)(6506007)(6512007)(8936002)(8676002)(66476007)(66556008)(7416002)(66946007)(5660300002)(38100700002)(44832011)(316002)(6916009)(4326008)(41300700001)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?dP4iNvE+J059zQ2LntOydum8nROveFAlgVKYqsxVosTyuHx8Fouvrh0EHosj?=
 =?us-ascii?Q?KdbcT054YQNj3UcG3+ghMer4CH/qbqzsaubkdEY8bDVPFmnkG8GEIeC6MiLO?=
 =?us-ascii?Q?AyLrpo66NqDBT2EuGtWCjrjmi0SHg8rObV9fJD8zxF10XhIqInpsP+/I8Blq?=
 =?us-ascii?Q?ol1Rh8ag6h1nHgQ4lRiQBTwjAJTu9RU0EOBqxS47s3948yoNrcBGHdnjdxKY?=
 =?us-ascii?Q?gk2tJxeRb5c9dQI+qP13kkM4Cl5YMl9HUi/Jyrs89F8tc13O6MFFSIgj+mnQ?=
 =?us-ascii?Q?cTltFH7YR89ZEdGqfJdP0AgvvvnnrOAvAw5OTMpxMhH2KAVJvbZXtGdczlsr?=
 =?us-ascii?Q?s175YqEHzDk2hOqa0U5OZGezZtd4866pgm8M9eCO9lg3pdZUwiacwnkKm8lt?=
 =?us-ascii?Q?GPJ+nBfvbUtAvQyziTUny3TGRwc7TOjl/mF1qkY45t4tzADPvDYZfTQJbxX8?=
 =?us-ascii?Q?fAgJIJCbcqmYnGZfB2yPylgYK1sXRYog+Y7/F3rozD6ZTj1DLdDZu+mtKIQr?=
 =?us-ascii?Q?m+OxqCMghQjrgVFZFtWUm+eAzjfoxFHwpRjCrxXwuRwghkMhxtZf5wc0LERI?=
 =?us-ascii?Q?uTrCSf5PkC9a5cWOYk+JMnO8Ofl/kyMBNtlOwmsUMBMeqeUCg9uopnjWq82c?=
 =?us-ascii?Q?sPTdnUy7ZvaJVriwyBkgU9y8mkIFfNaMB9Y0pZYocSxaNwBPPza+sPTOoGeq?=
 =?us-ascii?Q?fz/3IGNj0OfImZOnhmBvt6UppAYiGD73h0PrTBBgejoTgSFXfeP4mYgjT1Na?=
 =?us-ascii?Q?t8C0YQ4AkA4T2EQIuBuB7FALcMnerRxthi8uBsZEdfNlO21igbY3MdXF+iV8?=
 =?us-ascii?Q?l4iUdEzJG7tTNkHQy9YvmfEtmzGvKKHcJmS4ibwrZ40wSAzeEcml9fCv0zw2?=
 =?us-ascii?Q?jM9UbYliK4V+KpJ8MRh+h7q14C/KDQ38UQwcwg8k56ZAgFmhJ/mo9xVUevT1?=
 =?us-ascii?Q?skAIm5EZ1kg4VNSl88TbQFenPXSyRh106IMZ5qrbzZoZQ/CyOGsPhuO56NgO?=
 =?us-ascii?Q?ZQyolWEgG6zUF3zbAEeGQeZdni9ugueRlraNyx/df7Rq6o7RpYihz8n4E8VB?=
 =?us-ascii?Q?aSt5fokQM4EiraWZlKBFNd4+lmiLxQL99KRdfzBgIa3LYHzVeKEZFXK/LZXx?=
 =?us-ascii?Q?YI5RTNfFkZzmI8ercs42+cX2gpchMgtq7sF8bTwniNtbNfZF547ROtpJg0XU?=
 =?us-ascii?Q?+Z5r5WzmZcmPtIzuCAMc1M2/gTaEgXygVxeO4MecqhVlWqRs+vCckRTeWeqE?=
 =?us-ascii?Q?Do+0WFYf6WQR6plkFIchn+WAmKl/N1zDINk+zMp/XJ25Xfhr0O6VozaFLWLG?=
 =?us-ascii?Q?z99D3JPDYITcaSuUl+4cbC9g+fZ4Qgm9cOhXq2yKmy7gIBBF3Z0Lev8m9QY1?=
 =?us-ascii?Q?xvOB47EDuiryHyXtU6Mh6m9CuSC1G4uHj5oS2nvgazvaj4GP7M6qXCCsv5WD?=
 =?us-ascii?Q?BFTdRLlVfW07VKNpObcsITh3f0jmV26Upn+lhjtxh/WlN4AH42Ggfx9CTpqx?=
 =?us-ascii?Q?b5VhbL4oQRa/fe/9qJHJdcw/0eKhe4zFi/CdY8s6U+RqPDJDQXZJPdUYtHw6?=
 =?us-ascii?Q?jQ9eAxUoR8qnQQOWU5TAJECXbHu6MVS1xF56EvUnzgbHGOYLnX+f9ubMm6Sz?=
 =?us-ascii?Q?pz75Pjef2j3YimRVgt1VCYWCC1riO+4/bA0qrg0YpoyeI98YOWSKcrMW8P95?=
 =?us-ascii?Q?wDK6mA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 114e37fe-341c-40cb-52a1-08db70ce1f3b
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jun 2023 14:04:39.4028
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: x2b8zGc83HKLV659zBzlxV5OpGagtT6YuSrFJRNNq60WOdEnBPWA9Dg8OWILDJT/cnmHEc2FbjRhp/C0H05TxKZgw8sMjPum/Dv0gPqtqxA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR13MB4084
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Sun, Jun 18, 2023 at 11:33:55AM +0200, Christophe JAILLET wrote:
> Group some variables based on their sizes to reduce hole and avoid padding.
> On x86_64, this shrinks the size of 'struct mctp_route'
> from 72 to 64 bytes.
> 
> It saves a few bytes of memory and is more cache-line friendly.
> 
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

Reviewed-by: Simon Horman <simon.horman@corigine.com>



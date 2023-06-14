Return-Path: <netdev+bounces-10846-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9A038730884
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 21:40:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AAC091C20D23
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 19:40:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 30D8011CA5;
	Wed, 14 Jun 2023 19:40:31 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E76511CA3
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 19:40:30 +0000 (UTC)
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2101.outbound.protection.outlook.com [40.107.92.101])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 589101BC3;
	Wed, 14 Jun 2023 12:40:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f10C3dFT2ytRiA8A+nVWEGOBFq3FLMSbm5WMWd/iuiqlcsw4Odd8y/XSK9ylZpEx1DodoFtdi2eOpASXqXi375IZ0VshXgYQT42dVDnieJj9i7adMgwTQk61+jIbjTYYfR3ZYqKKLJFyuxdqldj0KNMgYv2KwT7YhaW1Evw5EKwOP4aJaR/xNeamt6k18wow2c2OYRlIVn/6mjE11xJZgFlDllZC7U2Kew89lpAwnddVbLuR5tH0JvKqbaitW1png2tPQ14qbJdVnl97YHpVozLhbMIvZiZSn2rLD+aHoI9d5wT5OkpTzY1/XFIQPYzgvHLBQ5pgGfrXHMn1iXdyvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=o2qCzjZDbbYCQBB1lZjjrdCfawqH1NukbRRRyHWTSfI=;
 b=m2krnCfskfBzXjYs1F31jJuVSbfdc7md0/bq/XvE8VrgwFGwATq5EfXohAlXa87v3UerikhPhz/O2YVajbcXQZMFgGFecHTAHg+eh+PLZuS5dspV4W5btBQLsBMF345vIZCGegCe+ZYaPg10zGj7WIQzmTvXwhybCbIYazHz8/w2uk3iefHGC/ge3qSmluTDmnjVXKN4OoCxSGpNmXwFWFSzyPHyIbA96yg26/ZzfE0gmXwlxaOuFqp6VA/PnZvs2mBu0XL5OzPAplGzLA2ik55PQn777xojhnVKMWt1IxZPOG7a6MzwBhanQGxl9zZtRTQ47JV973YVRdZYg3JD8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o2qCzjZDbbYCQBB1lZjjrdCfawqH1NukbRRRyHWTSfI=;
 b=FEk+ZsBeXEOCdQrVW2+qzLDsJ676Qs6IWNsQC6ZtvH48wRyV4xwq9ZPVCs2OytIwRYeYYV2eHZrxLaD+GtLHnVU9KSZqduEeqCcHBNPys6w3T9/GULIIyRWdxZkvVSUVx6oKVNcMidnjvs74a5UMezrNBRIvA8D0hjYlUKR8sI4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by DM6PR13MB3938.namprd13.prod.outlook.com (2603:10b6:5:2af::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.37; Wed, 14 Jun
 2023 19:39:25 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e%4]) with mapi id 15.20.6477.028; Wed, 14 Jun 2023
 19:39:25 +0000
Date: Wed, 14 Jun 2023 21:39:17 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Jisheng Zhang <jszhang@kernel.org>
Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Jose Abreu <joabreu@synopsys.com>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Maxime Coquelin <mcoquelin.stm32@gmail.com>,
	Chen-Yu Tsai <wens@csie.org>,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Samuel Holland <samuel@sholland.org>, netdev@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-sunxi@lists.linux.dev
Subject: Re: [PATCH 0/3] net: stmmac: fix & improve driver statistics
Message-ID: <ZIoXZQXLTWKF8nCZ@corigine.com>
References: <20230614161847.4071-1-jszhang@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230614161847.4071-1-jszhang@kernel.org>
X-ClientProxiedBy: AM3PR07CA0133.eurprd07.prod.outlook.com
 (2603:10a6:207:8::19) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|DM6PR13MB3938:EE_
X-MS-Office365-Filtering-Correlation-Id: d71390d3-7a86-49a4-6be2-08db6d0f0f67
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	8E+gi8qaGWM0cXghz7vDDtN/3jjMSQGylsy1DMX8/L7hEDEpzsMkRkQzcDonYJdKs7aS1QnwblLQpCybEmNDKkxJgImuL4olSTVIkRyofjOuxckXkUEelTRsGlct7h0x/CAfzthtXK3jBsi/ya20epfgEndb4x0/q+hWDfOiFEH665fnbILkqD/21sCgLFi46k+siiBBdM2WwSoNhAfTUygH3f96/LAI1DLZbc/lKLVOuLT3aeUAoMC/jK/ZBJmI1XWfQULmQcaq6m2tro7LLNySTFc/aTd3OBbSFtWC2aQJ6uPjoeL0c9ky9Qo7lsKAXakQL3G7a4mV96+aUi0bZjfjKTsmAKkUgtaQNceqL9fvmJWAGQBHjCJ28syz27CjLJ218KIPey3x8pnOag878UE5MOuv38zOV6WWfku1cXs79BVywhS04xImVpg8T6XlzALSTk5ie1kelTHK8x7cnBq2bYZfRQx5Y2PNq+0sjpYCJaKEZQyt83gspsD7GrtE2JroJ2wAR9Jl0JFE7rL6TGNh/LOlpoaRKmwSKae16tWUeh7JX2xjxxcGUeGiLRbTTvJIicuiWeSTA976NONTyLhhTze9rx8DkdXrPfRsVG0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(346002)(366004)(39830400003)(396003)(136003)(451199021)(44832011)(6486002)(6666004)(478600001)(2616005)(186003)(966005)(6512007)(66476007)(8676002)(8936002)(6506007)(41300700001)(4326008)(316002)(5660300002)(36756003)(66946007)(54906003)(7416002)(6916009)(66556008)(38100700002)(2906002)(86362001)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?2Y5CitNe9MFPXZ5Mb5ayiBUWJFvSVFL6Vmf3+TV8PmHCKJdHDOLfewAF3eCL?=
 =?us-ascii?Q?dS6BPE/d8FK536jcfR/NXs4u5+Mr+N4T/lwKdlVcFidMkMo+KfWt0cHzSSh9?=
 =?us-ascii?Q?w1kwEBE7pFYPaYV2flj0cUodfAU+U3a9ZrzBW+fRQ+jirZrfN1Z/iJHHjNKA?=
 =?us-ascii?Q?B1y8ECjkspAUihMvzD+fXJmNZa48eONNr+oy99lZfhsAjqTmB+wqZ2A3iF9W?=
 =?us-ascii?Q?fGRMpCsWgcw+/O4rkLnM/169cbpgmYCdqcqnAskGD9DGroGhgDSWnm3no15n?=
 =?us-ascii?Q?rnMCr33ZgRd+Gbz+oObND8UfhBYs1o1gcNYmYKHOEbyOsUFjA+ecIIhunFbl?=
 =?us-ascii?Q?mR9YNQWXgmE1rUOIjI9p4FP2s4mmz/C5deozN+WRN5GbTRAUi5TamW3roOmU?=
 =?us-ascii?Q?qipi98Hlc3A+pEf5+EUteCU9LxH6m8O7TPLz1j+rAft4plJR3Bur12O3+K6m?=
 =?us-ascii?Q?23LwvOZ+hWt75WnKgTFU+XELBuEUxekc3NNUm8SiT65sqScF2m2CUI5Z2uUi?=
 =?us-ascii?Q?w/Opqej+lgGiU3YmTlXA36tU556gZV7gZDWUPwabxzLH3UduurWc+zLvMepI?=
 =?us-ascii?Q?e3Fdm40IIdASMCjPMTd26TQFaS8iDo47wlCepb8v5IwzA6u3m9z+1E85BkAR?=
 =?us-ascii?Q?6hhf3i4vUcR9XjHS4EDjoEqePnhcBKAU7U6CuF69imTf3Skngp3+QA07u3QB?=
 =?us-ascii?Q?NXzbyTpMvZrsnbzbLmC4qCJ0wkErCftAviKDU2/oGb4NtlKqMKm4D6tRSYhV?=
 =?us-ascii?Q?/M28C6mCcJBrYiEMbbWhr9GdXaH0fFhIJE3bnJ+sHfLhLUwPkEn9qzI8KTPN?=
 =?us-ascii?Q?rIVOI7v+ZOJiKNyfWXT/6Yg38RekcFwCXn0zqY20nPnvXoaXHR1vuyZjfk9T?=
 =?us-ascii?Q?Hm2iyvHC1kW63V4tfuhA3t9c6cFa60TI5XYLZbhOGDhXH2puomAb1yleOAKl?=
 =?us-ascii?Q?sYGZQ8X0UKR+A0mXOnzl18miS0dYxJTEB7CE7YRwRchmLrs7SFKEotpkVyUk?=
 =?us-ascii?Q?7ZilFaUKkuGJXInG5Ai8p6BkNzjO0iIOQNvDZdWk4QWF8uHP8TWUYXiH90rc?=
 =?us-ascii?Q?48lpmO9zin6IsqHvPwBxwzdXTDDscih6YdW/gpD68ARP2Uqo7Z4ZMBnonA9a?=
 =?us-ascii?Q?A8O8jIYKDC1EGAI+1SSvwodzKopjkMK41yp5uYbtfKdvKTnwiJyuYTJWWZWJ?=
 =?us-ascii?Q?hJPgVz5EloiFBg25S+iFCqxLh2Ogq20PIaDSyS4uAguqU/aD1KKUy4kqyEOI?=
 =?us-ascii?Q?S+swhoyZOhdE//VCsvGHoJBfBGnq4y7VjS1jgQ6emT9ssd2j+pVbZPuAzj72?=
 =?us-ascii?Q?7jRsT4kUDa0GSPyQ/vg3p7lKXmC5SLxi0zs2wEKuf5XS3rZs++fXKQH3L+oV?=
 =?us-ascii?Q?PmW1kos2gqGxaBHYEP22aCi+7AL66WzAgmb6wDuPoP7UecliRpGCgOXJgNAd?=
 =?us-ascii?Q?kuR2saoBrPgX1ZKO4e8FOSaXPj5E8HIOyE6vUhDQR4NF3bH+qLAqJrT6vPU2?=
 =?us-ascii?Q?k119IDXO31JMA+97Pm92IDDTTmx/Hu2yh0CgB5TAC7hN2n5NNREQXCXv8a+r?=
 =?us-ascii?Q?LXupXJ6kYsS3q4CO3EPfHE3HPvrQbBQj8dTAazWn6Cod5Ibh+eWgSwglJKgq?=
 =?us-ascii?Q?DR2gKuihl+tESV9rf4dSCztv2c7WbtxVIu3yTrwgYhWHazrDJCOtEyNpP60Z?=
 =?us-ascii?Q?rM5ExQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d71390d3-7a86-49a4-6be2-08db6d0f0f67
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jun 2023 19:39:25.5521
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hAhh4OzMwyF981WpkO28KERr+XHJXeoB4DtNPfIW/DOiREh5/fpiDZnW0TJgn5/WWnZZtg9e2RvWy81wqxo59MEunZ6fJkCWN85YScp9s40=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR13MB3938
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, Jun 15, 2023 at 12:18:44AM +0800, Jisheng Zhang wrote:
> patch1 and patch2 fix two issues in net driver statistics:
> 1. network driver statistics are cleared in .ndo_close() and
> .ndo_open() cycle
> 2. some network driver statistics overflow on 32 bit platforms

I would encourage you to describe these as enhancements or similar,
but not fixes. Because fix implies a bug, such as a crash. And
bugs for fixes are handled by a slightly different process which
often includes backporting.

> patch3 use pcpu statistics where necessary to remove frequent
> cacheline ping pongs.

Assuming these are three enhancements, then they should be
targeted at the net-next tree. And that should be noted in the subject:

	Subject: [PATCH net-next v2] ...

Unfortunately the series does not seem to apply to net-next
in its current form. So it probably needs to be rebased and reposted.

If you do post an updated series, please observe a 24h grace
period between postings, to give reviewers time to do their thing.

Link: https://docs.kernel.org/process/maintainer-netdev.html


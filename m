Return-Path: <netdev+bounces-7666-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 64003721057
	for <lists+netdev@lfdr.de>; Sat,  3 Jun 2023 16:07:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 28D53281A00
	for <lists+netdev@lfdr.de>; Sat,  3 Jun 2023 14:07:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 54540D2E0;
	Sat,  3 Jun 2023 14:07:32 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41D5D1FD9
	for <netdev@vger.kernel.org>; Sat,  3 Jun 2023 14:07:32 +0000 (UTC)
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2090.outbound.protection.outlook.com [40.107.220.90])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0916D197
	for <netdev@vger.kernel.org>; Sat,  3 Jun 2023 07:07:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VfmhIxT6vZXqphFNFTbU/DpUu8Vyil55rcBULtGZseq9tBjnR0wchnyqh0LTBZlcFY/yLrhCLUj1xv73Qhv4Zcp56t7TLhQeNJuyM2QPmhBrv6zXpRHcpywOhVtJwQ4CligmvAibMaub3NTj5IBm1TF6YbGPByEXsKR86X/Ri/eg1na78gkyZnzsExaWPMzJSCbWTuZRRnsOqWDg3pUsG0fhXUo1xmJRq/NSP7sDtzBU1FCMANdTu1TwidcZ1iUYAH3JJlKKndbS9/jNE7gFRtfzzrzCRpf/5FxDfzIvlnsNmF4FcNMorovXdEy/vY9+VIlAt0/T+GFv91jUtXuTHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QX0eRspISZeJw+qo8++S+JWGNyaSclP1bQhs7QBvTIw=;
 b=Ckts3FRo88rsZIzH+0+arwEu8IUmgRxshmRJJkSNu6RSAzAEeR87rscFrU9dPzhgVU9j8+zcNCdzP7fYZKQpdqM4vNzKnTx1uKJWE7GWXBfyXOLPWwvaywP9+hceeC7Ppr4RSYiihf7dvZJSgZ60peCqboqSAMakrscWIYGCJoBhjJJ5Z7DY3UPb+Xmh4FkLjx99NtHH2w3JvzaTyo7NwPr6sXUlRq80NL5sKJfr8FHPJxNfOIYWI+pU8a3MxhSqmdJ4TDwaGM+Cf6aZSqESW8GFP6qaXdevlaCWODJGpuhOL45/4Czbnwu00jBW4/obiYs+pNdgRt7wYdCOFOGW1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QX0eRspISZeJw+qo8++S+JWGNyaSclP1bQhs7QBvTIw=;
 b=giD1ri+qKJxtE3tPTRL3qY+SWoP9o07vPbzcI+1vrHnoLBqLMKJJMeHedBSjje1p4tXpeKrEjB7X2pTk2aVUrFF7tCjZIJPiXS55JAh82WuO4r7rs6AAgJVYmm2NF1sbU9BL6ZiBt7Aq3CJ9QFLfsLQcsc7V8s7IHarquPvU1ow=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CH3PR13MB6536.namprd13.prod.outlook.com (2603:10b6:610:1ba::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.10; Sat, 3 Jun
 2023 14:07:27 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6%3]) with mapi id 15.20.6455.028; Sat, 3 Jun 2023
 14:07:27 +0000
Date: Sat, 3 Jun 2023 16:07:20 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Tony Nguyen <anthony.l.nguyen@intel.com>
Cc: davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
	edumazet@google.com, netdev@vger.kernel.org,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Piotr Gardocki <piotrx.gardocki@intel.com>,
	Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
	Rafal Romanowski <rafal.romanowski@intel.com>
Subject: Re: [PATCH net-next 2/3] iavf: fix err handling for MAC replace
Message-ID: <ZHtJGHnNui8ZRUwk@corigine.com>
References: <20230602171302.745492-1-anthony.l.nguyen@intel.com>
 <20230602171302.745492-3-anthony.l.nguyen@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230602171302.745492-3-anthony.l.nguyen@intel.com>
X-ClientProxiedBy: AM0PR02CA0170.eurprd02.prod.outlook.com
 (2603:10a6:20b:28e::7) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CH3PR13MB6536:EE_
X-MS-Office365-Filtering-Correlation-Id: 7a884650-4c7c-433f-4989-08db643bdc8c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	+i7vZohXDZH1X+vT33fUzQ98xQ/bdlOHvwYgiu+Y8Mypve7Mq62Ous+d/bpACd7dKBmy88wnZQd049g7n5EjedxfssSUrXuGFEz8LIWPf5Nr0NQ+cPlsLmMgvZL07NovCbAqtzZRjOJFg9BS5HuCfFrT1q6IybBzLfZobYMx2GQ0FqPcrpl7nY5S0ZlFdQY91hheRYzIgwYwag+8fDWd8oA0Nv+tFTYSvf8yaoIwvoI5rllvxqqan6cVKOtR0XkGzsVkJbHZrbK0E2uYf9/C3vXq1mxSsxWIr+XzMYQxtrIiq6MJpQ+V2sYhjJi9X73Ggbr3MO5dlce6rX4lQYJLpn8W4xp9AliUXyYcnZKeVFbOFberj4goyWHjm+F+0y7JIYLG4+fglcAgYMKzNVP8DNt9IDAujr+i8rda1NAjeUArFUg1D1FQTCXUQGEUncYuG7FegaPTvzWOUTuwvBGQT1A17Wu/WVg58i8CS4fPdj48WcRZXIl6qeZp/ep+TmvppNkJuZnS5VT8LLrTqfwlMLbZ7Gu5KGIwhLY75BnoiHLsdcFg20BAIETwvL+Rvqxxm4Ce/I+//xN0l4jPjGw7O3C8LTbK8MVnX4biLUHrkWI=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39830400003)(346002)(396003)(136003)(376002)(366004)(451199021)(54906003)(478600001)(8676002)(8936002)(4326008)(316002)(41300700001)(66476007)(2616005)(6916009)(66556008)(66946007)(38100700002)(186003)(6666004)(6486002)(6506007)(6512007)(36756003)(86362001)(5660300002)(7416002)(44832011)(4744005)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?8lDfzTas5xHOlEEl363lhSwAvSJpe1W65FVLrCoX4aEn6w4m26aB8gKkmWaL?=
 =?us-ascii?Q?0Dq/0C35m6pCGXSASlFTYuhs+mV/p26utq+o+9niQn+95zJSz8zpjS2uWrAA?=
 =?us-ascii?Q?lCfDh0eKieW1DfTID6wZ/pY0+vU9HCHuu4FQ6BTN/70Nhso7w2usnihcQmG0?=
 =?us-ascii?Q?p5LRRT7dmWKdQHminN6FFZfUpr4ytiNIYAIn9f/eOYW5b1pWgZOv7oR29y55?=
 =?us-ascii?Q?p5VrcwBCSeIm6S6aHkXFikFiI4MpvTTMzR2j59ovpxl/fkk3naU1fy3INkJM?=
 =?us-ascii?Q?YIpqiR1JT0xpTstFNqaQifCfqVN7zhocMHexP1fvVrX20LFhC/EJtpZC/pe8?=
 =?us-ascii?Q?nL9oy1dJfsggnw4XUyL8yoPwzU+VI0wPyuj+5OZWWelvMxkIuedadYoaA5tk?=
 =?us-ascii?Q?VndzG+66vrkO9OJ+9v10wUYGTI81iyZQ8hQV3//u2qLtjtcpZdxeA1F3edUp?=
 =?us-ascii?Q?H4ElLg28arp8Bt8V3P2DCeoXqCKlUr1/9IhuWj/u1+lRC289sOJqHWkSPFqG?=
 =?us-ascii?Q?z/QoCt+DsTWsus3w2tznsMhxwvVdR/S2sySRnSLjmYnqlxKcN9ocgLghibGy?=
 =?us-ascii?Q?eSuWTDhsXugCTAHuzhgP8MQpXGrh94UR37kh7gztiHZWQz5r6rqilvesrM+R?=
 =?us-ascii?Q?oZNqZJi82nKo85obcVgIDgaLPc6qVAjqeW/BqW/jT7AhpFcXJcIusnciUVWT?=
 =?us-ascii?Q?tiaUuBXXZhmge1RAC+VlJD873V/VVqcPSEtKwXp5+W5JyLd/RUC7zRXBnUsC?=
 =?us-ascii?Q?5BddPqyKOMTpfkUX8WfIh1K3jlDVCtrLj5QXKkkvcVpyKLPRLz6FmBsgAGVm?=
 =?us-ascii?Q?jKn0EX0XkgFbvhyMWsRyySQTRR2IKCaVPqAD6az1isBMAczdI1CJ3/KBCGhx?=
 =?us-ascii?Q?Td8L0s+WRWWEcGbxIFcK//BHcevTS5nmXRhxIe6fMrlahFwhsi6k2S3+FurB?=
 =?us-ascii?Q?oX/zTI/+Yp0e1WIo4uqT9eRqvDdDgqLWQp+CP9nvPghKDfekM4huGXQGXE4S?=
 =?us-ascii?Q?Fmy4pr1ngVAV74cQZMR907J0SIifppM2oUnvN4ml+GPRuvMt0csUvV9bSvbH?=
 =?us-ascii?Q?z1OfodJVlXNibQtMW1NMR9/rGKq4s89xbSt5gN+ZIXS3UbhyEnpKm2I7kaGw?=
 =?us-ascii?Q?Hd9TgXfBdKxv0oiz1VT774kZI7pNoz+ezPZtqZtc0jFvwYHsdz7l+1i3/MOs?=
 =?us-ascii?Q?oSAjoXc7xlfCucn6H05/HTn8ejKZiZQ0LEUeECcvxuGfHUtRVYHBosyMRHUp?=
 =?us-ascii?Q?bGT2EVTIU1TgrygACv4RFNrNrp8XVHi8c1aMDv3ttyIakP0Djbcq2ajYOgvg?=
 =?us-ascii?Q?8EZKj6al5/TiSuGr1Dh3FNY9DLBCpcALUJeVyBqABzWPfWQ4ZWrVq3xrqtpY?=
 =?us-ascii?Q?TzUSWoR9/K7bjbinVLfgsTDz7TvEAUighSCspNDeLBVx3ClV0Y8HNauU6XTo?=
 =?us-ascii?Q?M84eXvsOBeX+UB1LFCU1XxIg4VNd/4cK5NDX+0qYLVf1P/HVnZJFXRAE55MO?=
 =?us-ascii?Q?9kWWolRmWkf7paN/G8kRkh+gQmbczrlZXY/gO6VLzI07naduw22rfYmPkylB?=
 =?us-ascii?Q?tNkbl2oNUYvVe1E9VaQinV4fdOpPM26pdBXu/grOeGsF8jXvof+l8IaY/gj/?=
 =?us-ascii?Q?ls5RZXBJ06ZGi2drxzmDV2AovHgm5dlU6HldCCkR4bo/ys/BlYDzM+WLX4B/?=
 =?us-ascii?Q?kDHaJA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a884650-4c7c-433f-4989-08db643bdc8c
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jun 2023 14:07:27.0576
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: U5zKOHI/s1tRVredH1Du5Sh9Ypka4MgQssBFOtkGRFHZ9X4DONv77U6VhEO8VyvzAZ4J7l17YYWM+TVsVOZQhUFHuOcGqyFc34tZ5SqmG8k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR13MB6536
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, Jun 02, 2023 at 10:13:01AM -0700, Tony Nguyen wrote:
> From: Przemek Kitszel <przemyslaw.kitszel@intel.com>
> 
> Defer removal of current primary MAC until a replacement is successfully added.
> Previous implementation would left filter list with no primary MAC.
> This was found while reading the code.
> 
> The patch takes advantage of the fact that there can only be a single primary
> MAC filter at any time.
> 
> Signed-off-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
> Signed-off-by: Piotr Gardocki <piotrx.gardocki@intel.com>
> Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
> Tested-by: Rafal Romanowski <rafal.romanowski@intel.com>
> Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>



Return-Path: <netdev+bounces-5893-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1B9EC7134A9
	for <lists+netdev@lfdr.de>; Sat, 27 May 2023 14:25:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BE5B8281807
	for <lists+netdev@lfdr.de>; Sat, 27 May 2023 12:25:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6430911C91;
	Sat, 27 May 2023 12:25:14 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5469AAD31
	for <netdev@vger.kernel.org>; Sat, 27 May 2023 12:25:14 +0000 (UTC)
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2111.outbound.protection.outlook.com [40.107.244.111])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88FBEF3;
	Sat, 27 May 2023 05:25:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R6UwMUBSa/SDh664K8NvK9q8T5ZKP4AFyabSrhMueBeEm6t9zN0J3ZLlzyjiIS2dFQP3HDm3MRlXNLYND23qve5M5F5qI1w9HghRg42NX6AYxZIp/CD8xmMu6W0Sw/LKg8biiox+ycegJc6bhK2rqTkkpDRGBvURCAYPg1wAQppfvK2IYWcMkU2n9c8ruZj2pUwj9w7zgzrSGzQxpNLchj+kiYeG5QKkH2Is5vg8YehEUuAU2gik63wvPq/7ui6wjzLSvxaaZlRmkLJ63ES3aaZIhao8n/zF3xRKmZCIzm5L0z59q6WdW1klf1nzjO4CA9sHC8pS1jDY01x95KpocQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fizieVRhPX3hj13JBmTQ5Gv/nPYafPqwV7hC0mC6chI=;
 b=RgW2wbAOAQxxrMToxRrRVBYuDSp90hiBjWIATd/3lTuBxmgRfrbeu22/FM8tBZbVG3JqOwHjO1ZxrXYkSGuRHY6Ce+ANSjRfaz3+dGTZEdINAFVM+jNAaBVVwcGKXzh8L1sX0pV3tpccSuMjXUtAsoEyTaG1yIRsPPqyHmcEjILJX4N8cX/UGGYYK91rmr8vabLEEHVxqlvWBb/gMobtrGMyC58XysxIKRMPZt6gLrcws1J7mUdlgTBJOk1vuq1BFAOQ7BxrFI9VFU97KdEm7IdftPeWy/7apUQqPOFKDEjnF5SKfUjntSAzx89Ayc4BhkhH+1sj0MrMUmOaw3HUGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fizieVRhPX3hj13JBmTQ5Gv/nPYafPqwV7hC0mC6chI=;
 b=v31KmmquKvSIju5QOQAymwxYKwOPAnU/Ogp0tkzf2kSp/hO7QC0RevYeTVBSq7uhQx58pOSNHwTM5kz+r5AFoGv2KLKLCn2GtyScoi+M081RqqtyffAs/BnW5aJSgItMtVXL3kQ4Y6JN/uCrpFce9hrZozSN79tFMofmy2NevBU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB5471.namprd13.prod.outlook.com (2603:10b6:510:12a::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.18; Sat, 27 May
 2023 12:25:08 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6%3]) with mapi id 15.20.6433.018; Sat, 27 May 2023
 12:25:08 +0000
Date: Sat, 27 May 2023 14:24:57 +0200
From: Simon Horman <simon.horman@corigine.com>
To: David Howells <dhowells@redhat.com>
Cc: netdev@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
	David Ahern <dsahern@kernel.org>,
	Matthew Wilcox <willy@infradead.org>, Jens Axboe <axboe@kernel.dk>,
	linux-crypto@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Jeff Layton <jlayton@kernel.org>,
	Steve French <sfrench@samba.org>,
	Shyam Prasad N <nspmangalore@gmail.com>,
	Rohith Surabattula <rohiths.msft@gmail.com>,
	linux-cachefs@redhat.com, linux-cifs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH net-next 2/8] Drop the netfs_ prefix from
 netfs_extract_iter_to_sg()
Message-ID: <ZHH2mSRqeL4Gs1ft@corigine.com>
References: <20230526143104.882842-1-dhowells@redhat.com>
 <20230526143104.882842-3-dhowells@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230526143104.882842-3-dhowells@redhat.com>
X-ClientProxiedBy: AM0PR10CA0123.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:e6::40) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH0PR13MB5471:EE_
X-MS-Office365-Filtering-Correlation-Id: 55200223-d275-414b-eb58-08db5ead68e6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	y3+MoLq/14Ctzcat+G/USt33jdvYtkVasElOTf42r13hXoerUfrJHCRrvcWiaVAFmI3emFb69Rs1Abhoc+EzGgg2nD1h8u92t0McuCCh8cnFY0JPio77bP/P14mKHy79u/ONF4IIpqgeJR/OMCMRvOkeoMELLk1gpvO2UYYgFNmXWKId6dqLVSTUPmWfWKdA0Rlx9SF+qq7VKAKnuirvgc8o2kNA6BGWMzdZ4FFWsWyuuIkODaYkIVx05ZUWFHX979FURBrKT00HZVE7mOfNd3NkBndxcitnaBGL4uVh44GxwfwGpbwTSwUqvp2upjPt4uGmligskk41dJAnEivSjp9UWVfmVepkiUZBQGfx+DeViIAmJ4WHrxU3Y9Hfj76W3ia53VhQXWHNbcK2et7C55zklTdnHrIyqPANL+ObIqkctLT7VDG5qdTHqtV9JLFCJ8pnhjkcxmPgJPUIW8sgLq78Nr8s5x3vrDnCpQ0dAftQQmIdLbPQMIgAiGVjSIzBpK1QYsjIvecpvFpTajfRp6XEJhK7xgdS4ScICytc8MH6m5v90BcaEENaOPqSq7w7
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(39830400003)(376002)(396003)(346002)(366004)(451199021)(86362001)(2616005)(2906002)(4744005)(186003)(4326008)(66946007)(41300700001)(66476007)(66556008)(36756003)(6916009)(6512007)(6506007)(44832011)(7416002)(8936002)(5660300002)(8676002)(38100700002)(6486002)(316002)(6666004)(478600001)(54906003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ZzarhNN+vecew2zpFG7ovDCdHs/ZI+5MT3rGhzw2HSUymuonsU6I61SJzcFw?=
 =?us-ascii?Q?L08Dxf8MLcO0AcanKzn+TAia37eSgW8UKkjBe3K9wr0kOtVJKJVLCriR1vmf?=
 =?us-ascii?Q?OYi5Eq27K+j1qhURDnAZfk/th52gF2arvRSp4PoiinSqXLr9zQoz3iv1a/um?=
 =?us-ascii?Q?bXhBfXPHJ0cleT4vNfVWo3Nf9IGWB4UalV/5tebIUxPmY4SFM3FmQrTyy/lm?=
 =?us-ascii?Q?TzoO4kAeGetjqzU3a/gSYIr+b2iPbsNdEbrnDdLiTlKPfwWPdRf0JwUfPw6Y?=
 =?us-ascii?Q?3/CU7wvJKAwMeUA1KGfPqYfDfUX66C+TKfmc5qoPhMJjH7f3tjvEYINWcdxm?=
 =?us-ascii?Q?JCQt+libUg5KoXRLG5td4MO3THl5KQei2PbKCNpdCphTjkPZdnXTiLvkYuGN?=
 =?us-ascii?Q?jy4Jt4UXEJcXBlyp+8Ft32saZgeuv+A8McKoeKQBuFDzNRypIfJwPqHQQDw+?=
 =?us-ascii?Q?r6KpC51ASqAC22htGb1YbLoKSt/3FdlJIw22mHnAvoTfa1IIwVEYmRa91ym0?=
 =?us-ascii?Q?wmbGYNCipmvgmghxgS7HofKo7lV14GJyoQlrawenWBak1HrhoomCYMaa3SCN?=
 =?us-ascii?Q?UL4KeHLxq6D0Xglv39JBWt1xjkPjCNTya7nT2NBTeByFGWg8zqSWv6Yc88qn?=
 =?us-ascii?Q?vpaxKeXzihc4oIW4mA+NE4Htye3+IiTFm6MlAM7SKuvQI+VicJuGWvNe2goD?=
 =?us-ascii?Q?bEoYX/u41+wS3D0dJ5cDvzk4PUXcPmqrjIzYKRY9tvcXOrEMu7GX5RRb8sF7?=
 =?us-ascii?Q?aK5HkOqvph2kVGFFYU9SpVkRryguZZ2lqklf6N6kEes+pcD92aamQPcRCV7s?=
 =?us-ascii?Q?a+vsgwy3OCkoLWCB0dkWdIFnIXJxg64BbGmqQ1+Hj89tKXQBzcZdcAKgzGxj?=
 =?us-ascii?Q?YQ4SBpSMJvKUxy1d8Jez6Kh8gWEwSQHBri3eWpwoUyLaFm75JB08I4tOBUUC?=
 =?us-ascii?Q?IfWfPhMsTK8Wakwgg2+Vzwgj0ekPCRYUnvSEUcWJQSN4Uv5AEIEJdIKs5jIh?=
 =?us-ascii?Q?TQewNV6Ks+bCiVWQkRR7xYwLf00PlYzWLGIfDrgWJMu2MhUkpxqpQAWoio/R?=
 =?us-ascii?Q?0Y8idv6jjdzoMOItS6Kl7WDzG6f1A7znR3TIouoSaDGa9swn2Mli5tI9mmvZ?=
 =?us-ascii?Q?iRkjaktQ089AX6lgg5fBiR8Bq5T+bJo+rMlfF8F80+tlgpufWfYbarro7bm5?=
 =?us-ascii?Q?kZWuUjn8tS7cHMBGyPTrhL/juJLhniIkid6ukh7r//1c4lNU1+Rj6mRdQdbG?=
 =?us-ascii?Q?Jt+IuTmQHrfpTr3KPpBLEzDEu/S15Z4ajDEWfa3VEXnZFLvpEDx1zfSsr3hx?=
 =?us-ascii?Q?GS5PiD9OMi0DxmI4UhhfUI1oREAe5V4rORiaBFcCMaSCBka/q66Tudp2sOZu?=
 =?us-ascii?Q?JnMEsxoaZ/RWWXNByXUwnP90esiE7RRNPYt/g37ya6ffzEvpMOqXCcdsiO7U?=
 =?us-ascii?Q?NqwH6qRHozT3BuLN0kTuxQH7WgL/U7TLHOJtCVShNpPCk162hQF9EBS0KgLc?=
 =?us-ascii?Q?6lC1vPuMa/Ms61TmPf/9Xub3HVSSQ7U0J2P9Ha8r1UL12ZXeiplzVH25d2A0?=
 =?us-ascii?Q?sfK5mN5ynrmuGyRAd8svZyNGG7RPqDzK0yr8VZzHHHZ5ldtAvVvdYBS16sGX?=
 =?us-ascii?Q?14S+WkibBairQ6bknYOy++o8NUFZ8kPJq6Z2Kz8NVd/oJgmrwq+OP5FHxSh5?=
 =?us-ascii?Q?KZBVbg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 55200223-d275-414b-eb58-08db5ead68e6
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 May 2023 12:25:08.6580
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pLIHxkO10a28tXCgyB5GWmYYchoFQ/f0CGtqxDM6NuUPVvMgj+p1oMJK4nASZwfONJLfBut+UmIte3lrRUOS8E9A3RcrleaFgaF0F1LGwaA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB5471
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, May 26, 2023 at 03:30:58PM +0100, David Howells wrote:

...

> @@ -1307,7 +1307,7 @@ static ssize_t netfs_extract_xarray_to_sg(struct iov_iter *iter,
>  }
>  
>  /**
> - * netfs_extract_iter_to_sg - Extract pages from an iterator and add ot an sglist
> + * extract_iter_to_sg - Extract pages from an iterator and add ot an sglist

nit: While we are here, perhaps

     s/and add ot an/and add to an/

>   * @iter: The iterator to extract from
>   * @maxsize: The amount of iterator to copy
>   * @sgtable: The scatterlist table to fill in

..


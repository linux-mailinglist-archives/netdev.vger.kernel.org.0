Return-Path: <netdev+bounces-5892-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 987017134A1
	for <lists+netdev@lfdr.de>; Sat, 27 May 2023 14:21:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 51C392817FF
	for <lists+netdev@lfdr.de>; Sat, 27 May 2023 12:21:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 350E8101E7;
	Sat, 27 May 2023 12:21:00 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26981D52C
	for <netdev@vger.kernel.org>; Sat, 27 May 2023 12:21:00 +0000 (UTC)
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2111.outbound.protection.outlook.com [40.107.102.111])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 905EAF7;
	Sat, 27 May 2023 05:20:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cY4S9yraUOv3WHc/hRmL248v1THImThq2cp2waGoOnswMx98JC1zBDmSsGs8Y6CkPbeUzV6ujCNQKglelghUuV0j1SDdIXXUSFb3M0JKa3cIQU7kzJghTxTaJZdSnx00TVmYhtttnmKMING+8pMKcL5bqfqRDPJyb/UI7wY9XHpnsYXvEI9uKPgSPD6vZ6iAKjnpAaJsnBCSqJt7PhV2bNYzl7d8kNbhshqogRKsBPGpL5zlaEXjAtlVjEZG1QVJDuURVcs6RgjOwimDSeZzlpzDnhf7Vbh+WkqYqpNk0AnxH7Z612eTzDYd2xYBWi8Q4Nm2xfwo4jjc4FWtHwWvpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=k53bNaCHg+WYrnuEYz4n7xSO1EeB/nZBSkS0KtMPTsU=;
 b=Cb2Bp5xE6Bqha5Skm/jJ1rW9bzeOPzpkedH/My6Jwth1Y2et4l1v+dVYmneeBlLmYnt4uXmWRXkyt0vKpy4pknxItfN+xlPBeL64mLksCv6q7kg7orlAON6l+q+rqY6u9F25lGwEuk0DV6abKt++re0gLmwm5ar/eQkpi5RyBnKsrKavA2gvlIuYb3UWNgP7ziWPnx4WKX4TpNgG0pX14zHyTkRi82TT/Ot5/ZeIsL8qmr+GtPeNXISWHQHGaqe9aNUT9LyQi87ePh+9VKCDhLeNkH/jn3qZk3OrTMSDpw+jafcbTWHkNVAUjR26XbuX2kYDP0HOmU0IwwAihmiTyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k53bNaCHg+WYrnuEYz4n7xSO1EeB/nZBSkS0KtMPTsU=;
 b=mk+zsTnTcMI39S3zjvB07th1fwCPwJoXRrxN1rMIOH6FWq02mhK95SNA15ZKlCioKQzssHMHY8yDeXEZfA/lp6ayhTgdl9QHYpuCR0bruqCrfi2ydjMKVNeeuc6sVhrVnK5g6gXvwYyr2dKz1czhQXjWc3jS0gWFkuCgVVEu42U=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SJ2PR13MB6143.namprd13.prod.outlook.com (2603:10b6:a03:4f5::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.19; Sat, 27 May
 2023 12:20:54 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6%3]) with mapi id 15.20.6433.018; Sat, 27 May 2023
 12:20:54 +0000
Date: Sat, 27 May 2023 14:20:46 +0200
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
Subject: Re: [PATCH net-next 1/8] Move netfs_extract_iter_to_sg() to
 lib/scatterlist.c
Message-ID: <ZHH1nqZWOGzxlidT@corigine.com>
References: <20230526143104.882842-1-dhowells@redhat.com>
 <20230526143104.882842-2-dhowells@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230526143104.882842-2-dhowells@redhat.com>
X-ClientProxiedBy: AM0PR04CA0048.eurprd04.prod.outlook.com
 (2603:10a6:208:1::25) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SJ2PR13MB6143:EE_
X-MS-Office365-Filtering-Correlation-Id: 6a2b2c9e-1703-484f-3077-08db5eacd16c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	gnQJUwfhWb/6yyHot4adOrlymOrpRdyALlTpKkHNw0L5hGfD64UqALPIfDNR6qnTlReIBXaLUdBFHiUd6nLefz3RmevdwCCZzXOxbVgZB+v+9hOIwGINzawt2LwHW+QNdgbhUHfeNxy1qZrBqIUrj/zMEQ0Joze0I26MxgRJua1VyNbmtmCx190LwSlmN32NyLCwF5WgJsdaf9dbfoNtcW0kUoQ2if5G+FLKwL+K1aBx9UqdNOptrexuIRJ67/zdhNep82ayhupESnbDI45Z2PIV8BIOcR1AkMhAVtTPWvreuEEpeuXAOl0NBens6slHYI6q+19fqD3aYY6Fk8yTyMfy/l+Cj2z+H0+keXWBwvNsVfjNY1p3O58FJVRteCzw9N7Iu+eUoxiaRg2yQkIMfxdHpk5VcGxwkrTkzIYhuWm6YdKDU8VfPo9B4qaBySDfYFdgMQ27FjU1z37GOMiPU0zaIsxYQm76Sk2aY0n0VFxIHvYm1aQO03KSLBR7lmWNrkSAyH6bsDT+byMo/DXfLpLnaO1FXgDWiQE611U+fWW99haU0kQTzPnIxjkMHntU
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39830400003)(366004)(396003)(136003)(346002)(376002)(451199021)(4326008)(86362001)(36756003)(186003)(8676002)(8936002)(41300700001)(83380400001)(6512007)(6506007)(2616005)(7416002)(5660300002)(54906003)(478600001)(6916009)(66946007)(66476007)(66556008)(316002)(6486002)(6666004)(38100700002)(44832011)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?k5f0cerJ30/hXpQz2q12q1QpqrKX/KBfnbgRDORHvUewXNM5RmdqdRQg2Hbn?=
 =?us-ascii?Q?/Ha485msQpZxB/WWJg1gh12VJAPyhLYawBCE7MGwnM3YfUnZBEGpWjVsQuTZ?=
 =?us-ascii?Q?/Qv/sqCQhJleQ+rZvyiw+E/AMfivjIX4vPLB4vLU+qpOuFhF9PwDZn+ox0LH?=
 =?us-ascii?Q?6NcnPUaGJvHCUU7aogUovg09ylYUbTRFJ/RkIn3OsesNRmNZPHHXdnR97kaX?=
 =?us-ascii?Q?lP4y8qnF7B47ekLVIMg7M104tHP1BxcsGP6ZuLrvWmpNIOl1/k4/eI5/vuhy?=
 =?us-ascii?Q?k5bB8P/Iz3c5mq7nTjLD3Sf/9ZLvuwMxZOP/xaqXldiMyzP/06wtSpjoTUy9?=
 =?us-ascii?Q?wf6MwsgnukoQLd6OfnGXqT8iw/qWDzizrY0K6ZeH3VS0HaMDHweQSNpHW6fx?=
 =?us-ascii?Q?YbQ1T9XQeuD3OP1HBiDZtLEGek9USF47aDp1BLSZRgOr5/vnKv/cnPAqzEP8?=
 =?us-ascii?Q?JuRBXXfRw1rhopnLqzo1so83K0L3Or+Zgr1IOzy1Gfb4RhSZxhRWnWTEeRkD?=
 =?us-ascii?Q?s/4mxuf9+7qV8AkdAnSgNVdVVigE7R5iTsz0aMkNd5PVtU37DqkKNd9o9UBa?=
 =?us-ascii?Q?tLcfIST+0HUoQ7CyvT+X4wJdnwyQ0nkB9X3S6QfPgvs3jbX7M4YOokwwr9fs?=
 =?us-ascii?Q?TCzax3IUKUTo7kcP/C+FOfODKEwXvtszG/IkFibK4tHM2hvnDsFQxOC5rrSe?=
 =?us-ascii?Q?39IDbz7ov6DqJVWLLMPHicgBjLsxdUJ6egcLWaZ9aOSbot0c/IMm4d442lcv?=
 =?us-ascii?Q?oe7LxYMBfTsOw0WitkfCVQ/AeqA48aWtesECNhsA21aJw9CRa7PulJGxq6SL?=
 =?us-ascii?Q?+9K9C3PXD6vH3Dd73TY7aSnWeWjZ9S8lf2X2B6nqxOJMOW/uBW5bdn7HuM5K?=
 =?us-ascii?Q?q3AlQuOjYryYHf5zbnnTnXhNh3yOnE0nQU92DY+413DJ8e8F8Nxhb48x81h5?=
 =?us-ascii?Q?4QHBj7ZkPBJmGdVJsWCfrasFPQL99b4RBUm3FuCt4W4ETSvIgSMZF79hGtj4?=
 =?us-ascii?Q?XVMtaocGEdpELsRShp5OQjcBfZVnM7weAfoR8+NnPDpDSMHPu9RP42HeQ/MM?=
 =?us-ascii?Q?6VifeUqkjebcZlbmYbb21M/M+VaYRirfzCNfLkRxrNK1nnPSTisqbLjn+VwD?=
 =?us-ascii?Q?iRdAgaod5RwmvQEAIfKJ8U2q7Bi9TDXj3gsjIBffB3qSM0LGrATisI9vgvLC?=
 =?us-ascii?Q?6eNrUpSrPCR96/+HnX7anSfZrmoSfPAI2dOeor6i9zg2rCnSr3wSTSzSt/7N?=
 =?us-ascii?Q?JtCScNE9vekzVFMMXi/U4GX0F0qBXpZcdoBn5C25J/s/lqfjaxjFSNEPCpRo?=
 =?us-ascii?Q?um2bJB058q+AhvBFqLNezgy63wrLtedw699955M5tEUTy00+xO3TU7Lw977g?=
 =?us-ascii?Q?Ki7wThY9wgxv4IdVb2krplfmVCOTUfBpXsBZtKHokodOkIQ3W+i4G8URoOvf?=
 =?us-ascii?Q?wBR+IqGhEwuXgCW21R/NlYVtsnfd5Zd20V9O4L0N4XnHzy2steFpwykcXqAb?=
 =?us-ascii?Q?0IyGaifUL/BbUuih7yDDcAFpstJmv0Orvb5RVOW3Mssw37xDIsKOaHD6n6j8?=
 =?us-ascii?Q?L2dxNkPprEyqVgXvyeX5I23C7ansEOGT2yxFE1kfBjGtJoKpVWVpD+i/Lt8s?=
 =?us-ascii?Q?o1TWEn99DqNi00m3fmPLMqk8ywhkZCZUV2Jav9E4txLTH7t7wKwUZKROGMPK?=
 =?us-ascii?Q?rOiJvA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6a2b2c9e-1703-484f-3077-08db5eacd16c
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 May 2023 12:20:54.5261
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Qif1qLOblT+2Rt+zeOY2vOcnWyv8g80QjRNKwzZ+GNdgt14Epf0u0eDelBDo8YJxlyg8lzsZyOv9Bb+5JFGuWEN0Wwm8hqdIIIF1MxNTQ3U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR13MB6143
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, May 26, 2023 at 03:30:57PM +0100, David Howells wrote:

...

> +/**
> + * netfs_extract_iter_to_sg - Extract pages from an iterator and add ot an sglist
> + * @iter: The iterator to extract from
> + * @maxsize: The amount of iterator to copy
> + * @sgtable: The scatterlist table to fill in
> + * @sg_max: Maximum number of elements in @sgtable that may be filled
> + * @extraction_flags: Flags to qualify the request
> + *
> + * Extract the page fragments from the given amount of the source iterator and
> + * add them to a scatterlist that refers to all of those bits, to a maximum
> + * addition of @sg_max elements.
> + *
> + * The pages referred to by UBUF- and IOVEC-type iterators are extracted and
> + * pinned; BVEC-, KVEC- and XARRAY-type are extracted but aren't pinned; PIPE-
> + * and DISCARD-type are not supported.
> + *
> + * No end mark is placed on the scatterlist; that's left to the caller.
> + *
> + * @extraction_flags can have ITER_ALLOW_P2PDMA set to request peer-to-peer DMA
> + * be allowed on the pages extracted.
> + *
> + * If successul, @sgtable->nents is updated to include the number of elements

Hi David,

I know you are just moving things about here.
But if you need to re-spin for some other reason,
perhaps you could correct the spelling of successful.

> + * added and the number of bytes added is returned.  @sgtable->orig_nents is
> + * left unaltered.
> + *
> + * The iov_iter_extract_mode() function should be used to query how cleanup
> + * should be performed.
> + */

...


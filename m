Return-Path: <netdev+bounces-11566-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 391AA733A2D
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 21:50:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6A1761C21002
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 19:50:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F11FC1ED2A;
	Fri, 16 Jun 2023 19:49:58 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFB7A1B914
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 19:49:58 +0000 (UTC)
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2119.outbound.protection.outlook.com [40.107.93.119])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DA2310D8;
	Fri, 16 Jun 2023 12:49:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Qpv41IaBJrXJk9bvzhAoL2Xg46Cu1qduB7su+PWzfL2DK4qrNvcx0P1jU440pVzXseq4NuINxw65TQeg274xDxqZx4VFNS4FHV5afcoiBwwK9Z11bJuh/NLKH5YGBZZKsPWngpX/UW9jEeGPk9IBIZ/08S4ABszPscrcl+trzvbb7Z+5M9/ydKYTXJHTZXgJU3AEYClsPO4AdIy/wXNkNh1ZptZ52M1BD45f3voNqtMZy+7aISOC8pJiGyR81dxzLEwOyi9gGqcAcTsvg8+3GEkVxMdJ5/XlP6AaDmluQAzWD7oCigVkokILLwJb0sVE+/QHzfsmEGeCl/weWC8kOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xk2aH9j7TaYKdfYmMySLNO3laJ1BpxRYBi/wyTzDez4=;
 b=NJmM57IeCyrdiDM38iOJffVyQWRPSatx51uwzevme5FR3VtLcGSkP0Dzy3XCr+1r73dzoRUD1MsT3nTJagKRneAO9y9g5SEtQJrxNuUlKwB4JmeZv4p3ZBTIku9qB2E5kniLnR/SyF17jSWS2sREy3/DkkA5lu6eFR7kevtFsCOMc4Dk1afSROJTDaczFm1/mbR0NdfT3ZCstiDKRt4SGxoOPGSphv6RlZL7U0iKJHCznjLGkDcXj0xO9Q8bn7Tv12KE7lEzl4HVOqOxmm05psyPGZdsf9v7gtz9lfQ9qbvJl1/zotKPmrY5wKySYU3s/a4onz3CdF6n0LYYgA8x4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xk2aH9j7TaYKdfYmMySLNO3laJ1BpxRYBi/wyTzDez4=;
 b=vNasRzJZSm5BDWey9MCFIf8YOUkBw1QTKn0KJ4XBbikjD3Hii+zoagbYNGlVHlYxFIFfcl38fwVSly0sx6ItHVK4B98khV8rPzNj0M8tQPV8pzgPaQw+vlsRBs8pORoj7Q/ZoOmkha8V5MzbJxYP6Fk18OFtQk2kneevuR1Ahms=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MN2PR13MB4037.namprd13.prod.outlook.com (2603:10b6:208:24f::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.29; Fri, 16 Jun
 2023 19:49:53 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e%5]) with mapi id 15.20.6500.025; Fri, 16 Jun 2023
 19:49:53 +0000
Date: Fri, 16 Jun 2023 21:49:45 +0200
From: Simon Horman <simon.horman@corigine.com>
To: David Howells <dhowells@redhat.com>
Cc: netdev@vger.kernel.org, Alexander Duyck <alexander.duyck@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
	David Ahern <dsahern@kernel.org>,
	Matthew Wilcox <willy@infradead.org>, Jens Axboe <axboe@kernel.dk>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Menglong Dong <imagedong@tencent.com>
Subject: Re: [PATCH net-next 01/17] net: Copy slab data for
 sendmsg(MSG_SPLICE_PAGES)
Message-ID: <ZIy82RjpmQMTNafS@corigine.com>
References: <20230616161301.622169-1-dhowells@redhat.com>
 <20230616161301.622169-2-dhowells@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230616161301.622169-2-dhowells@redhat.com>
X-ClientProxiedBy: AM4PR0302CA0011.eurprd03.prod.outlook.com
 (2603:10a6:205:2::24) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|MN2PR13MB4037:EE_
X-MS-Office365-Filtering-Correlation-Id: bce14373-aea6-43b4-ae89-08db6ea2da70
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	ETsZMFkyS7j3I9hQxVsRv+Okmyy6oEpYBmphs7dyhIUPMLmYaLtBcpVBITM1Afh7xUM6sU9kTiCQKWamJ/CBEYsNYRyxEu8KCViENnfO5up3JFD5IcLB/arLEah6HI9Mgnxg4gaF78pOFZBHSAho608/ciwcWH4thmJCRG7iDZNrua7bdIGKQvF6Ctsh+ytktNxZObSaf4Sa4PO26zPmPb5V+OFjPJJeYRZBtSKRB7y4RL+TRpJWlhOhOEsiPJhFtzdPV+1tAxWzSE0JQQpvs2xz4qFMOCW608PxPUMyKyJOJAAahTzVkG5G4Jya6ghvTsqmbDFAcepfKfNDuMM1TtiRBSG5mIJTI5aYorYXa2CiYxaQmwnFzF2nCwNVL9MMW6pFYOspWWbwdFNhHgB/TrXGoS9oP/QWX8h2dvNBH7z0vFTpovbk8fhIuKRBNlv4NwfNUkXs7JuirOiCX072H7Epg55QfVkRdz30bmRIEUgClU7Wtgxqv1iKGFnHeOZOlSZMx2i0VkllAgLH9qgvqR1xtV47p7YDXFRO843MfJHFJ6DWzdmyuWHw7uEF9zz2sNjbO8+n4hRgpSvUsi0r04QD736CKj+UQ5herZPdwZE=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(396003)(39840400004)(346002)(366004)(136003)(451199021)(6512007)(478600001)(36756003)(6506007)(186003)(6666004)(6486002)(4744005)(2906002)(316002)(41300700001)(44832011)(86362001)(5660300002)(8676002)(8936002)(7416002)(38100700002)(2616005)(54906003)(4326008)(66946007)(66556008)(66476007)(6916009);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?7sHqMvRM3PTiHT5VWFmvIcaPGEOeVNSchiIrYaZUp5TAQBy/+iA2hR5yE7VP?=
 =?us-ascii?Q?UQSblo8cqUAgOCFQrEiA8N6YArZeaPN/6j1Uq/Xj/2lRvqxd74RFTRFCzXsk?=
 =?us-ascii?Q?KcG93Z3NX5Gnsv5JrCWdolKkheUgh2f15aYqUoYuxmPNdlQQYNRNPeXWOkQf?=
 =?us-ascii?Q?f0Gh+n39chpjLGhnqtQ4SBWFow8MHYMUMg4lq3gMCOX8isEoH/8yFk9YJpXZ?=
 =?us-ascii?Q?9DIxLb/PELf/wH/h1aD7R9gMXr/doKS2Xpo3Qp9MPLdUpv/sSu/gHcF7SE2p?=
 =?us-ascii?Q?ktNeYiv5GUmi5nn3IDrIq4TQdnzW9DPc/jF+0LMscFniWm+yMu3JHdmLj9KF?=
 =?us-ascii?Q?0bMXS41OW4I6a8/ccWnd+b+29uI5IKcRuAtEEcQ/uDCxq3YONI4dsrgbhn1R?=
 =?us-ascii?Q?qwW18prch79OD4IMxVYVNqXWPFnkLXGuC4D+oQ4grnDSLDtot9HeKLpECU7j?=
 =?us-ascii?Q?iKTEjdlqtCqQiR50qir5KPw8ZJCdUyaUsvi6hdCr5fIYGNAhikvFwhnH/oME?=
 =?us-ascii?Q?5ZeRat9a6NoMmjmdmw+esjUvfhSHxIOpnuj00QnsL76E8ABQggL6ZH+7Sjq6?=
 =?us-ascii?Q?n3YY6N9nEjFOwRPug52q9lg00jFXvoAjVx2lUI7RdzKkpI+bUJVlj+LAx2fV?=
 =?us-ascii?Q?J5sE+VlsAfvCaOkQ4y71t4AVDjXibHjehsLhL6JFjvMj0EpozMhWc3ueTdQm?=
 =?us-ascii?Q?K3fz5eMgcd9r/OCXBXkWozmi1pNo+aBJ+CuueK7XA30aLTYgQhGvSWrmTom5?=
 =?us-ascii?Q?XlCmzP5h3iQG+lkdEF/DAqA001lawFvGZw0uDJo0KKWceDBEkCh3WYdx0hYL?=
 =?us-ascii?Q?IOeQuZv4EmCwCAHYp0SALcMBgIVIFttjxeIH2nT7GpHMKup2lfxSoSqPv8e2?=
 =?us-ascii?Q?wCsJ3XyrTGazMHJV47757O4WIwVbCIzf75SmtXvGhiGTlemS+SJLqr5mRedU?=
 =?us-ascii?Q?dY+fK64u87cQd7T67Hrc2N/GkuTzRAN6A2M+ZFOfhOaEf+Swc9CjYY1jV9SP?=
 =?us-ascii?Q?0GHVtdyxmPMiegVgcPwbMtJcWlNOn+uFY02IveJTc9ngpARpeAArVE9UE7qp?=
 =?us-ascii?Q?4sxtWOmTyJrcRGFLj4ENLYm6Ak57EGpmfrdc8FBJ27xwgN/72o8hzIAvzcil?=
 =?us-ascii?Q?mLnGcq3w/+n8vc+JSHjP393Z5Slt+QkwHtg5tpHzreRfP6kH+Gma/0kAuhTG?=
 =?us-ascii?Q?o4s+jm89klwrzyISBTWOxlG+QlWvCkHUdntU9OY6IKRUvgYzzuH49CYBoaKp?=
 =?us-ascii?Q?2GutbaJiTUoI+4wGLTRR4HEnSvulatbzWWLhMhi13Pdb464NGi6IfQmJd47+?=
 =?us-ascii?Q?qsgi3acAiuwVZl8hpjkCy6JT3vbrx0AfhyTlw1K25bDbMDHUtXnf4d09q4Eg?=
 =?us-ascii?Q?cS/GFH33/eMw8qU4p7fmwb5ruzFe7pXcwx8x9XXo/21x7WIt7upBygig4i9W?=
 =?us-ascii?Q?ITVNYctO+OsEZ+9I6n4iOu1297K+Rf8I+S1Lcpla1jEZz5kYZXnQ6ViczcLz?=
 =?us-ascii?Q?QqfdDlPsxaPcdzlwmW0/lWCAxaSEqrQgwUsIk/vp4Lk9g7Ieb25JpUl1oKig?=
 =?us-ascii?Q?zhF/0WfX5EHzPy2u0TqcDzVOHcclHADp9UnMggAodZ0X3JnRsk6fcSoLVw2O?=
 =?us-ascii?Q?tgWoz+JEi1EPNUW+wAaqphZRX7Ky1OTKrzPaYVs+AAQAmghMF7o4rFrxlHY0?=
 =?us-ascii?Q?1mL/fw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bce14373-aea6-43b4-ae89-08db6ea2da70
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2023 19:49:53.4116
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AhVrALmfh7TF7n0HlM9pdGXhIq0XHaMjpJT/+uQrWc2MD2Cl1K3y3rgV8qM2oQ7SpkFY0CK1WgSk3RH6lPmb/BrZpyRNRKvjXd+GfTeuoeo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR13MB4037
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, Jun 16, 2023 at 05:12:44PM +0100, David Howells wrote:

...

> +/**
> + * alloc_skb_frag - Allocate a page fragment for using in a socket
> + * @fragsz: The size of fragment required
> + * @gfp: Allocation flags
> + */
> +void *alloc_skb_frag(size_t fragsz, gfp_t gfp)
> +{
> +	struct skb_splice_frag_cache *cache;
> +	struct folio *folio, *spare = NULL;
> +	size_t offset, fsize;
> +	void *p;
> +
> +	if (WARN_ON_ONCE(fragsz == 0))
> +		fragsz = 1;
> +
> +	cache = get_cpu_ptr(&skb_splice_frag_cache);
> +reload:
> +	folio = cache->folio;
> +	offset = cache->offset;
> +try_again:
> +	if (fragsz > offset)
> +		goto insufficient_space;
> +
> +	/* Make the allocation. */
> +	cache->pagecnt_bias--;
> +	offset = ALIGN_DOWN(offset - fragsz, SMP_CACHE_BYTES);
> +	cache->offset = offset;
> +	p = cache->virt + offset;
> +	put_cpu_ptr(skb_splice_frag_cache);

Hi David,

I don't think it makes any difference at run-time.
But to keep Sparse happy, perhaps this ought to be put_cpu_var()

...


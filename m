Return-Path: <netdev+bounces-8382-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 50075723D9F
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 11:34:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B66E81C20F01
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 09:34:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C0D4294DB;
	Tue,  6 Jun 2023 09:34:01 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B73029117
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 09:34:01 +0000 (UTC)
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2122.outbound.protection.outlook.com [40.107.244.122])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4131210EC;
	Tue,  6 Jun 2023 02:33:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=liuSLDBiamhIZ5jg5+vw64WlyVOlv7iH5tTPMhaR1A79s3AqMSdd9XcsXzU6aC10Z1Nu3ryePES6eu4LgFh+S5BxrhJYv1lg2XmRGaOC0xRJyLRW1jnFLSd5hsps8tc12Cvf8SlGtMgfIy9gskHDsMkuKn5NA/AGuhGmWsQ9MOAnHstYwsfh5cuzHCW0CLllvhBdE50iKwA0bjBjMqo13rSgCcSXc2p2lTZFhh3/L+7DaK9fQG6tYgP8j3vplRHT7c0FbaOXfrwkACgU5TbCfT/CQoCHEXbqO5T1d0CcthxHgAePLQL4bwSYbnDRE1r5n9RxLTeF6oHdaPWDyJKb+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sXlgWIuBdU9hzuQYERmWPkOip+VPvR9sbeicuTbMGPY=;
 b=l/VKvj/vk1HtfDqjWVDd5rxa6NWp4ABb0xkDZKqzZJvWOl2yac4BZl6EVM6U2KjPSUvdSlFo9lWTFE1SFRDlMdKDPdfV1oe24RRnwfd6wvM3OlD28h9L0STJqtF2ag+ddim8r8Jp2gbMeGzlpTgG9pDpz2R6Ff9xq/RBWe3l0+P00n8gunFnhAwYTfERORmySJezLUK3ET55NE47UMqnYdM2Hq6xiSjK0x+2IbHc8xJezG4Lq3K0+tgEhFlGya3Ul3e6dThN5L/pMN0LDTHhhhg+X+T9tmM0CiXYrIfkfEwDKHFO7shMTazthXRTbx0/Fw2yh+8FivRw+yzkv7ko1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sXlgWIuBdU9hzuQYERmWPkOip+VPvR9sbeicuTbMGPY=;
 b=JIs9jhk90fHQ+XpUql8Cd6V4La3kX95BwvJWEUhwy0JZLsUA4oQ3A2cjX7CDF8jftAsjVt5Bq5ye9duxVbjg+O5DYMANcitMP4EcgxZJTaFMdaN6n8v/dcICsQW67vkm8LobsCr7N0Aj/NeH2CbCEOK1eBgFywziML5bKj1ru58=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MW5PR13MB5946.namprd13.prod.outlook.com (2603:10b6:303:1c3::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.32; Tue, 6 Jun
 2023 09:33:41 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e%4]) with mapi id 15.20.6455.030; Tue, 6 Jun 2023
 09:33:41 +0000
Date: Tue, 6 Jun 2023 11:33:36 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Hangyu Hua <hbh25y@gmail.com>
Cc: jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
	davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
	pabeni@redhat.com, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net: sched: fix possible refcount leak in
 tc_chain_tmplt_add()
Message-ID: <ZH79cGajWJ8qKj3N@corigine.com>
References: <20230605070158.48403-1-hbh25y@gmail.com>
 <ZH3Vju3D3KCKAkCO@corigine.com>
 <1626a8b8-ae7a-a110-44a1-24c8f600822a@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1626a8b8-ae7a-a110-44a1-24c8f600822a@gmail.com>
X-ClientProxiedBy: AM3PR05CA0124.eurprd05.prod.outlook.com
 (2603:10a6:207:2::26) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|MW5PR13MB5946:EE_
X-MS-Office365-Filtering-Correlation-Id: c9b8d720-5cae-4554-4ab8-08db66711d7c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	5IGEU8+j39DG9xgwd4I1oB1PSmlr++ozNXGKDNyqxjo/VuahfldPPXiwSz1VD8KB6x/dPX3ay6THyxmDdCYJUl3kcCzjv5ryAoUHyuAMW9GWaHW4+PVJA2wUGGeiOqVdw/YcZl7k7HW0ldAuhbPyOZIcRsW9o1TcefGYpU5h0FFrL1NNB/opKmPIvTWVNcTO7xrs/xMfLgD+tEgN/XILZ2+L8uc01Tti8MS5Qq/e9GZoKNj4dBdYClC6cjQ9MnJYFfsQGlA2AcDPOap7RzmDpwwkYZXtFRsdRMnKWtEY7+pxyfG3m9p3O5ZUt9y77hnncPg+VvqSXxbh0oO1L/jUpCUMMdl8indr4oP5JaUFmEb8xJddGAZKgD5WIYIw6PLyFHbkoPXeusSBOOGn0Mob7Nv7mDMvoT6w28JhJX9rQ5AP0onwNG9hZt2zJnAZZaY+S3qTdJ8lSI9RjIEmYR5C7jpll4FNYa4J1u/oMGZJTtgXBuWP1lASG+E0vZg7T+N5L8pEno5kK+aMshA4NFC9eCg0dCHOAse+l60pRX/Tx8aA+E059C3Q6JL696A8xab3
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39840400004)(346002)(376002)(396003)(366004)(136003)(451199021)(44832011)(2906002)(4744005)(36756003)(38100700002)(86362001)(186003)(6666004)(478600001)(6486002)(8936002)(7416002)(5660300002)(66556008)(316002)(6916009)(66476007)(66946007)(41300700001)(4326008)(8676002)(2616005)(6506007)(53546011)(6512007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?QT2eFZeTHJUQNe3NbY04wnVJTj3cE2CfvESPdiSFFGmP51NDL1+AkXXxXpsW?=
 =?us-ascii?Q?pjrc9RZhClJzhqbd2JsKmb63Gp84OTQmT6alHRDxdF5UVXV3VFDAugvaAEaj?=
 =?us-ascii?Q?UopK/ZNKAecIPc2g0YazBXdCQlpdelh8A5XZBh0MC9ql5JroPTZW+hnoMQXS?=
 =?us-ascii?Q?ssOjDYt4PJbCfhw0XWWPWn4MnMrYRkXRa1r31qobUM9Ua/pOXK0KttbyXFXL?=
 =?us-ascii?Q?az8A9VsZRG5AtDiwlUVj6Vw3jxkISkPnix+RmV0gB/4zQAJ0LLBIOimpEnDX?=
 =?us-ascii?Q?7Yz6KwOxZrYYWiLhwhtRYu/VXmZDskZNf+vmYnWvPrxZ2laAGKuU3A74LJR3?=
 =?us-ascii?Q?760FGNe2UhXzBWBhFtpdEdmU79/hFglRyyiANL8+Zr5EPHjQJihcLb8E1cFD?=
 =?us-ascii?Q?aSH+vw36oweaKG/NxhVFnB0slmhKlaI2xgIrbsjE8MK+uhnMkS7h0kZgpvgN?=
 =?us-ascii?Q?XBm8torhDBa15BivO7RiTBNdx+JjDMzqvHltMLh/61bfoSHEIW1JIwxDLhm1?=
 =?us-ascii?Q?tjxlCKTHRKw3XAEeII/MbJRIoGbFRwScPVg9RoDAvKoPVzTceqCpQHdUMAHp?=
 =?us-ascii?Q?NrsHZx5witX/mWSHDdhQ268gSjbf3KPZu97vliISpAQTUUZUva4DKmEZrZHR?=
 =?us-ascii?Q?rollq781U66nErEJM42hCUZA9LVjMaRkgQ0ywrISHOkM6YcOy6w+ZxGrMut0?=
 =?us-ascii?Q?RRUdgtSHdoPQiVwLgxozbLkrLr0N1TmQFx+M1TrtvV4j7DZRy5ODgUoveGGp?=
 =?us-ascii?Q?C8S2hQ+QKrOfxSdnGtY24q1RkTDZoJX2w2W5/NufLadDXVln06XSFIeXAbv0?=
 =?us-ascii?Q?v/jga+BPuRafj7L63TTWJ3MY4v10MHQpAV3qLqsc8gBiaHCTC86aFa7nl51e?=
 =?us-ascii?Q?uYHyRoYST0CsE3kRvya8d8LxK1UF+mVY8JGuMPCI7TLorNXGry2CvAQlSHt+?=
 =?us-ascii?Q?f0c1WrCbkbpoETtFzRY2UOgNeBzwDMg568dM6ufS5f9KBdOoPtD402CK9lse?=
 =?us-ascii?Q?c4FSK6IfFgSlyaKk7yjurFu6pmpR7tIajLa8rjFRN1WoLr34qWHyZjW8OQ97?=
 =?us-ascii?Q?mpbrXszhn9bGGVpVsTsXukxh3bjoINzL2tPaxM7iXLLocMJQveG4iZYcdM9g?=
 =?us-ascii?Q?a7pQS6rKzRVHKAyAR0v4iwePDLg1HAu0D3OjSmk2cjNDUhadmVSK2QG1akoa?=
 =?us-ascii?Q?anfdlnSibz4uFpktgMBtLw6U8canITcZ/jPqG5lBAkBHco5v6n+BISsFGqLO?=
 =?us-ascii?Q?Lp/BHw7tlO5lmpXOG7tOwomh3mo+SUBqjCJYrxNAOUbWb7bLM8KVWMaZLxW3?=
 =?us-ascii?Q?LK1ykklP2e0Xvv+nLDXd7hSEOkYoWm4QKd0Ow1HRNfnbsCl4wc34sw/iuT9H?=
 =?us-ascii?Q?LOZN+pNS4IBRscTbO2msJhv32H14CQuD6YDa41t9lAYf+JzgGlfk+LffPDkl?=
 =?us-ascii?Q?bvHM8FJH+eZctYmGTBzzjTcIMdjynGJ8HQg+PlKhIx43+wmXno7rrUd4FXMt?=
 =?us-ascii?Q?BDZrJb+MWInXMdLYjJEL8FPVyHfWKZbPdr3oKYTWn1HDFsM2/YLwMka8r4Ms?=
 =?us-ascii?Q?na3EpL3nrEh1vRMAA2PvwFQNjHN1y772FXBhkQzrVdl4G4MXltjkG+pNg7mD?=
 =?us-ascii?Q?zgSnh+hlmaDzbPl1f9DuCTxeEjWAz3lLH//sIfhWt+MgASz1VPgoN9gdAQ7W?=
 =?us-ascii?Q?ETTDWQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c9b8d720-5cae-4554-4ab8-08db66711d7c
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jun 2023 09:33:41.6414
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TXyb6nNCTKb9/HZZe7YZZGbk5y55UkNW8JP25oNLzCjf7SlPy4hqgCpqJccuQ20AObSC4tENmY9ntjbgKi5mtBsQd3Co5ciI11LukS4mLRA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR13MB5946
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, Jun 06, 2023 at 10:13:44AM +0800, Hangyu Hua wrote:
> On 5/6/2023 20:31, Simon Horman wrote:
> > On Mon, Jun 05, 2023 at 03:01:58PM +0800, Hangyu Hua wrote:
> > > try_module_get can be called in tcf_proto_lookup_ops. So if ops don't
> > > implement the corresponding function we should call module_put to drop
> > > the refcount.
> > 
> > Hi Hangyu Hua,
> > 
> > Is this correct even if try_module_get() is
> > not called via tcf_proto_lookup_ops() ?
> > 
> 
> tcf_proto_lookup_ops will return error if try_module_get() is not called in
> tcf_proto_lookup_ops(). I am not sure what you mean?

Thanks,

I think that answers my question.

My concern was if there is a situation where module_put() is
now called, but there was not in fact a reference that should
be released.

...


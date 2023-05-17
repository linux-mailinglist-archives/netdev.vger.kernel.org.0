Return-Path: <netdev+bounces-3261-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F41A570643B
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 11:35:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AF83D2811E8
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 09:35:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E444D15499;
	Wed, 17 May 2023 09:35:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D12DC1548D
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 09:35:23 +0000 (UTC)
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2100.outbound.protection.outlook.com [40.107.236.100])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B54B273C;
	Wed, 17 May 2023 02:35:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kVsY2pr0Tiz1ER6wZEKONc4mzT89XQSUxVrBQAleuRXf3SKEeneEtLizxofWyQlh689TrpAwIpyFNhJdIWzqObvwWZkBB86nQHvAjg+GFba93Jt71kx0cgS4usM5KaRugq5xTCSisBULSvknXvoOnd0UZHXoKYtuj1I0lvzY1tMpxgwgqbK1Fu4i/Ofx06W3uiCBy4fhPjkErQsWgAdFr/zROOOm7f5v8lU6YX1te2IyunPEg7F5q7TUqEEgKyuBNusmp4nkLBjmV2BP6vYVMKZXkmGPbmIMujz3EFrvNj5Bnr6SWhvG0Q9fsNdbXEuybjDNNOQCBVE3cXAdHD4m/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HaTON/429Noqt7WMHLW6QEM8oHffMSc652jCQylvyK4=;
 b=XZHvnN/VfoRk1D3amj+UVuZARoiHp1T+RdcYzINU+1EJLsry2OQ0PyArlBlKpJ/UgZ/FyqGbH9mryw4vedYhj8QAneHgL540XPTTFSwmRGMxBgw80+pZXK3uoKC2FUg7o5FETFHzQJ4vIL4Xyb17rVjsGIb+t72fq/cfjisRiD3XEh9gv1n4q1B9nwd/pbSlBit7xmLLNA5qIY/+999JgNxWRvv3aeBreQ96gLuJt+LEeM4kjmYFC8B+q5+lEliXr2yO9ktknN5mtGirypRTk5nFJTjWDt2YeAV2WNnECOBM7VLHs4GlYKeb2auGhWbI6mR1hTQAv2gLg7njYS6QMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HaTON/429Noqt7WMHLW6QEM8oHffMSc652jCQylvyK4=;
 b=EUuBI2m6ROGYqw9lZd3tFwsKdaxiOa8ADVGZ1EIT6q6ingNX4TQW9ogSGPkmWFMZ3oOT3WjzdhRvkuYcBCrgpTxXwA7YlYgXOoKpE94bPMLYnoWpzW+o4MI9JgbePeKlOMbxAEKZ0T7IPO0wN7+wK82qdiYtmQkp5HFQf4yVx5M=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MN2PR13MB3632.namprd13.prod.outlook.com (2603:10b6:208:1f1::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.33; Wed, 17 May
 2023 09:35:18 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6387.033; Wed, 17 May 2023
 09:35:18 +0000
Date: Wed, 17 May 2023 11:35:10 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Jakub Kicinski <kuba@kernel.org>
Cc: Dan Carpenter <dan.carpenter@linaro.org>, wuych <yunchuan@nfschina.com>,
	dchickles@marvell.com, sburla@marvell.com, fmanlunas@marvell.com,
	davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net-next] net: liquidio: lio_core: Remove unnecessary
 (void*) conversions
Message-ID: <ZGSfzrWHpNf7PbmZ@corigine.com>
References: <20230515084906.61491-1-yunchuan@nfschina.com>
 <61522ef5-7c7a-4bee-bcf6-6905a3290e76@kili.mountain>
 <2c8a5e3f-965e-422a-b347-741bcc7d33ce@kili.mountain>
 <ZGKT01kLOQNRqx9I@corigine.com>
 <20230516202059.09aab4d0@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230516202059.09aab4d0@kernel.org>
X-ClientProxiedBy: AM0PR01CA0149.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:aa::18) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|MN2PR13MB3632:EE_
X-MS-Office365-Filtering-Correlation-Id: f0491d8a-5607-4d14-3dbf-08db56ba06af
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	E1yOd5D1krAzAAZQz7I+yfp0ecmXfLxvC4zZczG6uknSrQCr+NUQW7bS3QsRYk4MFpH+1nEVLk1zWDe4aR3ZhhgoudoqIwXZfcNmdwFchfCpd1aDSRRDR2+nsvbffYjQ4D25gkIz2eVZg43CKyr9ZB+cnoIHvCn9KrcLI1GgjVZDrSj/pzSFGgslP2EYEN++REy7GbUNZgpvN1b2yKbQDNkPmGLGV2vs6IhpTMwZ43bm5w1phNLSn2QaYJrYOLE0RxDPq5Lm2I/S31T7bVBwhOnuztJmS0zUQmh7xl6GjQ6lWUQsM7+mwCiEnaqa10uURWHWNx4vGO7/5Ycpoqu5lBVaWsM5FiyhqeHRiUdbKvdEg0DKRfEmZ6Vo3Erje1zeMZn9nDgWoZbnNbMrQ6mV4F9vqkQQOq31/qvdniGRIB7B65E7eWE3WPOmPlNdbYXUg32JzffYtn+WWuZmELgBi6u/wRaWJ+uTPEGJIZrN6an3x30nNHao6Vsqgjubb+lsk/Nd1pr652td1YybPNCNwy3TOeQzuMGBQJ6J3NpyKEqKVCGxVPTulb7MbIES6RI9ZXdWvc6aGS/6XG6W5goheW/Dp/WqTqbylkAb1am3YE8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39840400004)(346002)(376002)(396003)(136003)(366004)(451199021)(38100700002)(6506007)(2616005)(186003)(4744005)(83380400001)(41300700001)(8676002)(2906002)(44832011)(6512007)(5660300002)(7416002)(8936002)(478600001)(54906003)(66946007)(6666004)(36756003)(6486002)(66556008)(66476007)(4326008)(316002)(6916009)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?s0WFeE3IjHF9kL3jjKtCln/f18QDLMlJOragrcyq+cp3bMsM3Q0/IcZeRYRO?=
 =?us-ascii?Q?jwisuC8yQ6m+uxHDCOpyNyoXjpKAK3U2Y1zjWLCkXpvuLp98vyVRZ+sdYUHD?=
 =?us-ascii?Q?47+neGa0PONUgopDj9FqaBGKdLe/SqY1Krsix3RbMXCrGPmI+Fnu9HCMgYHp?=
 =?us-ascii?Q?UMY3WdRdg8ssyDAKniybCsY64ke7/Pk4KAwKC9h83v4BsCUt5rj/X8LFpQot?=
 =?us-ascii?Q?JuOgwuMmZooYdIhem0knFEXovJV+3cS1Xiq7NGZFih6X7lZ+S4+WEEAWKzFV?=
 =?us-ascii?Q?uAE0TxfCM5huLXuH3IYWWStLAJi6Ez59PLiU1eJYV107VKKh9wvHhcqsQFIc?=
 =?us-ascii?Q?iNm7OlIeAN3jkCCTDTS7ENZ/2srz9bO2hFdrIj6LA+kdgQARduXJn9RE8loG?=
 =?us-ascii?Q?qVi9QZln+pV+vI2dCRHVVxcdtc0qEwugl/xx62jinQ1StwNufrXdTxUeGZ/7?=
 =?us-ascii?Q?jivMYIYR7cYZfPo0E9VZrvTIE0gPki0L0Eovi+KtGlDO03i3D/oYf2zzzIBC?=
 =?us-ascii?Q?U/cosh9oGiXmBlFZk1Wo/KZ73A28zssynVFxIF6PJypMkB5YXVxQ6oRMnsdY?=
 =?us-ascii?Q?wNZuYevD5W5XX1U6Qp0puHi03flOIYZlYl9CwCPIQrUNI+v0Nm6wgnwagTtB?=
 =?us-ascii?Q?5P6P7dFiaZgdMaZVh+ZwTB050VAjCiwVlzB8PItL1c91L6K/rCVDYNgxzdgG?=
 =?us-ascii?Q?0T1zqj9Bssh2ZFyIKajTr0bC0M3GPt+b6Y0EV9YkwKuakTfCi50YLc497IgE?=
 =?us-ascii?Q?ipwme4DhkQTyo4EK1UHOoOf+1yLHGv/Cbpdia9hkiLPTREj1EU3yCSvEzV6v?=
 =?us-ascii?Q?g9VTQ42K/sm3pKgsmufB4zIpFk5d5ueaWx3O+4crTsUq8KNF2jrbkgwLI56H?=
 =?us-ascii?Q?hNXtIkfR8n89miw1MQggJZs04C5QmZY+WIdSE1oxVciPNF41YO7hzovfxm1F?=
 =?us-ascii?Q?m7qmwMVCXurMsEU+ZJjKlbhXdp1C52Sj3pkLIEdQoVvNIFx2SFiuh34jTmoe?=
 =?us-ascii?Q?MgKzszdHcySp5u23kWifxmgxLmGqzLTLBL41ZLY47koizV3aZnFWvak1V0Qo?=
 =?us-ascii?Q?1/dme3esOsTOZKR7dysOrFCjo1mHxbDWYoe5EL7yqVMRZvPy2NnYvq2J5oI6?=
 =?us-ascii?Q?HdX0flHLEFhwlH6tn+7J/ik562mD6jgA4hLAgqCeWjYIkIWE/oH7bsV+lp02?=
 =?us-ascii?Q?D2+XO/Thf0clkdGj+6kRxulnfhj5S3agk1g7zPuJZNbhJUmVdUU0rTNBvkjr?=
 =?us-ascii?Q?FbPrZ6eNw2e7WCPUc85jkG+H3Pz2XzHG4Q1Q3iw5k4+T1mxKEbtsooHoNJxk?=
 =?us-ascii?Q?3gnX+eUDxzBD/z7OfZFX7EfaLAl1gUW/tbqaXKOXaZzzL91IqmGJ6AmY2g4O?=
 =?us-ascii?Q?Wq+Mv52/fFgvSWFsX2LO/TAXSH5FIB/XC9cyD8sXE6HD/V7SExAinRT0HSWD?=
 =?us-ascii?Q?0zFu45jJNpN/YCu7nFnywm0ccB8jqoSwYIo8h1ux3/473507WSEsORCS2uk9?=
 =?us-ascii?Q?lszV362YYN8Hvu7ZI8mY7a5P6blK4yeQOCv7bQaQQsj61MUUzsbve0cyW/66?=
 =?us-ascii?Q?wJjd82jSo+0i06qOD1/7Vkxg41up5QeDKGx3T9sCODFoXNReXKNw4iX0qTG0?=
 =?us-ascii?Q?qgQFZsCamnP/rh7wajqPiZrzrI60UCQb320QWQ4k8iyp0GEZi5uIkR/C99/h?=
 =?us-ascii?Q?+1yqpg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f0491d8a-5607-4d14-3dbf-08db56ba06af
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 May 2023 09:35:18.0699
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: krrS+b1z6AQiPOdKdXaNqOi+S3UBYMxrx1uU/XS04BtxzuchWaJkWv7GkX/E4YBWiNzbImEJPgu0xpKOfux2dcBX2UgqhmSIfSZDM3g1iyc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR13MB3632
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 16, 2023 at 08:20:59PM -0700, Jakub Kicinski wrote:
> On Mon, 15 May 2023 22:19:31 +0200 Simon Horman wrote:
> > On Mon, May 15, 2023 at 05:56:21PM +0300, Dan Carpenter wrote:
> > > On Mon, May 15, 2023 at 12:28:19PM +0300, Dan Carpenter wrote:  
> > > > Networking code needs to be in Reverse Christmas Tree order.  Longest
> > > > lines first.  This code wasn't really in Reverse Christmas Tree order
> > > > to begine with but now it's more obvious.  
> > > 
> > > Oh, duh.  This obviously can't be reversed because it depends on the
> > > first declaration.  Sorry for the noise.  
> > 
> > FWIIW, I think the preferred approach for such cases is to
> > separate the declaration and initialisation. Something like:
> > 
> > 	struct octeon_device *oct = droq->oct_dev;
> > 	struct octeon_device_priv *oct_priv;
> > 
> > 	oct_priv = oct->priv;
> 
> I don't think these changes are worth bothering with at all, TBH.

Understood.


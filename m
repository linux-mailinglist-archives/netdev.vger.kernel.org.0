Return-Path: <netdev+bounces-1113-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AEF436FC3C1
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 12:21:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8086B28129B
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 10:21:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B9B28DDD5;
	Tue,  9 May 2023 10:21:54 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1B89AD39;
	Tue,  9 May 2023 10:21:54 +0000 (UTC)
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2100.outbound.protection.outlook.com [40.107.236.100])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84AED118;
	Tue,  9 May 2023 03:21:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VaZmotxgAugRIDYUe6a86eKrSuKS6vn8vunqwzIUw6ZpkXwV4C/HYpMqRsHAS+97nMyWDx/SKs7KrksWEPxkmNq18AoS1xY8lTFrH5bYBaSZ435FWbNECFz0atSwf7aIPP1whrATohicddhNI+NRxnwt8eD5m7n70+BzfwH/lUKY75ETd0Vfny8Iip2wJ73ifUcdqWZnbxtUc4nHRXa+yRxpummWtPC08C6ThVagkBYCJm3ymrX0Y1gyoJ3Q6yysR95HRJ0eOBWIYCQ0BaZAZNxhKARqgZd5fJneCGz/LlDVLQwhBSlWtgUrHwNFysFhsnYH16yjg9TJH5NAAAdtQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ibcbBp9vrSUD6rZhVPaMCC8qLzQISxggwS9DQ+hZ4zM=;
 b=IOzPierpbgZBV2M3KTJmSaOt++C+O8QsXk2bNkgYRhZW1ucXA6Z+c3w6dhdKJu3yjED4g6QG3+IFzvX4ZP+MFh/Lvr095OV7mdXYUoGKuZqxWKGwZQzrYLcGbeIWXZrntf7tffIbh43dJOwUtrdcwmODOHZFu+U0oAhecPCx/iTJA8248/UilEgoJ1XO7UhqVT7oTE041cJPbzgCIgjJgmCzRRACc+VBA7nJCn5ZYee8iVOM8l0MIx4/ytZIj9S8gt4WGhKI3vh8ZPRw89I+Hd78tmR1U6hmKgEteI8fuoyUb+0Dmoe9DRCx8wsC3xt0AQkjufeJQaBnLcAGrd53VA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ibcbBp9vrSUD6rZhVPaMCC8qLzQISxggwS9DQ+hZ4zM=;
 b=u2noIJ1yHwPSyyFOr04KBgCljskiKik2gTP+MW7fqU6h6fDu3lKlcDIDP0wyTbUb/l5Qp9hBlU/ZWQZTGvubNyOFkd0zWNmLpj+iIRuge4WayMUdIahrt3h1RJ+gtY6DWVxtEo+ki6vlj/+2r7c1fHFpibVnVyrKKYyOmPHkMwM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CO3PR13MB5669.namprd13.prod.outlook.com (2603:10b6:303:17f::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.33; Tue, 9 May
 2023 10:21:50 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6363.032; Tue, 9 May 2023
 10:21:49 +0000
Date: Tue, 9 May 2023 12:21:41 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Lorenzo Bianconi <lorenzo@kernel.org>
Cc: netdev@vger.kernel.org, lorenzo.bianconi@redhat.com,
	bpf@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
	kuba@kernel.org, pabeni@redhat.com, hawk@kernel.org,
	john.fastabend@gmail.com, linyunsheng@huawei.com, ast@kernel.org,
	daniel@iogearbox.net, jbenc@redhat.com
Subject: Re: [PATCH net-next] net: veth: make PAGE_POOL_STATS optional
Message-ID: <ZFoetW/oIbXtSf1s@corigine.com>
References: <c9e132c3f08c456ad0462342bb0a104f0f8c0b24.1683622992.git.lorenzo@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c9e132c3f08c456ad0462342bb0a104f0f8c0b24.1683622992.git.lorenzo@kernel.org>
X-ClientProxiedBy: AM9P250CA0013.EURP250.PROD.OUTLOOK.COM
 (2603:10a6:20b:21c::18) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CO3PR13MB5669:EE_
X-MS-Office365-Filtering-Correlation-Id: 02f1be65-1ffa-4160-f55a-08db50773344
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	1eFNMOK/pDjUWAglFjP/mIyT+kDYsGye5tcXE1z+EDopgKJY34l8dfFKPtdPTt5zQuDALm4AokAnp65WU5MeONgzgZTJuVfZjubtlS7PN7vhoCMaQh7GJWji+UButJJ7MsAdotmDYWQ5lQuo7ruFRHCg9E9p/32NBIn9yVPohyIRLQfCl+YgvVZJbw9BpTCPlpAcLHFrlJ13hORvbLhguKfTVCSAgv07rbrtUbdGm4FzjBGfhHz2AB5X8ddGtpXhB9OjPuenvQX+bzPaqYETzmB1WX2T8sk3srDlacx9OuOcMnhptk4ws6ZZ2djkgNJv8iml+yjeWNwIJWhxtAtDPQrDwZACoBc2G8isaT26m4Jog8FXvG+eUhpe9hjhB8q5fGHaGYsZZ50RfwnuVzEiQtbTGgQYKsCWkMMkTmnVZTdoBe+XhVRbT8wuwdYJ3q9np0mwCh/F8XNDZr3pBfl8/FBjBZVtWhoqkuCeGSx38soWqMi49odW9l3nEhicTTWhbOdPcdgTVU7iqRuIpMCktYqDqUWeZof8RarFLOvKKeqUDUx+yura8MwDJLKGsS6p
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(366004)(39840400004)(376002)(396003)(136003)(451199021)(6486002)(6512007)(6506007)(83380400001)(36756003)(2616005)(38100700002)(86362001)(186003)(316002)(478600001)(2906002)(66946007)(6916009)(5660300002)(66476007)(66556008)(4744005)(4326008)(8676002)(41300700001)(8936002)(7416002)(44832011)(6666004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?bFHm7NbCsFixA5hjwSeb6JPf8a/GEF+oIkBA2vzNUqf6LAqxiumctgPXYfRV?=
 =?us-ascii?Q?1FcN1SqDzLNoyoaILkrOtbttUm2vdF4ztCVvw9EQ314e3mzgeIFBo6elKvZ5?=
 =?us-ascii?Q?vfJ99xSGVPeiPwl8fnizHdd4HIaU8wOkHeRZjFoYYVPtqyGA4vHoGUqVAL9g?=
 =?us-ascii?Q?n7tqllbeh/4jj5eRMshe2oOiLwa9WxSasP8wBhOF0iEkOb3ukn60+DWcdUXx?=
 =?us-ascii?Q?sBxcJ36RE/gVROjA7vxKow77pqf/1KiR97AhVE8hqs8rGEjoQNTvkP8vX0dz?=
 =?us-ascii?Q?1judmDbnDBHV/9XUXTzo/uDpptczUfFnauygpdF2w81L2OC0bnpJZ2cwqrkx?=
 =?us-ascii?Q?px9eG1HNEllDLnpktvTPA2LSMH3DvslAYTYzZqEmaEQCQdtkzpbKJbT8y0vJ?=
 =?us-ascii?Q?wvIDp+uv5Zns9RcGgjp6ixnNLjyCKAD0aIZ0b3GwF53YHY4bCIJxDUqyCCoI?=
 =?us-ascii?Q?pZIGZrTUvNjJrhEMME60x0aeHbeQW5jLyJkTGFX3HOal/tCj+5t5y4fdC8oH?=
 =?us-ascii?Q?XQl/S83QteTCnOrxud0ZngJueazNSonJATto4tbBfnCL2d2D+zq2+hraqjTf?=
 =?us-ascii?Q?MuXnxndb4mM2ME+RsoHkzPDaLdpwaq3lR7t0GqBrLBXbEQG4VXXTGUFzxW2z?=
 =?us-ascii?Q?b5dbdGAMiRavkcV/xNG/Qavzu44OvcVHaQF4Ijmw3eVxO2Fl36H8Gu37KvcX?=
 =?us-ascii?Q?MEmoQeB3C42UwrKV5sEdA+VExgkjgpY62THCQxzVNe/I1j9XHcwU69DEkLg9?=
 =?us-ascii?Q?L2KlAGjEhG5UJ9NyHiQefoZ7BLjheTnfpgqp/zKKb043hMG0kguJ45d9oWjR?=
 =?us-ascii?Q?PLPxitABwWBTABE/hMdxLZOtEZV+KOKZYqjE4Fy+jYTF0DEOyW5KnEjeNq3O?=
 =?us-ascii?Q?crflOCvWKHWsK7AVq67KDyusZuQDNkvEd9VlUn1CppW0LUwkZpoP2EbANZK5?=
 =?us-ascii?Q?FqNbFWikGuEYdDQt3Yj9n9wmRN78J24fQ1tDmz3pCvfeJO21f7+hB7YHu9zf?=
 =?us-ascii?Q?+YlUeRONHWf8Z6vWBYA5m/4hsMysiY7ion4Yr60dVKi3tRRGe2i2CSwOYJGf?=
 =?us-ascii?Q?CIrMOXgO5I91ythfGgrHUo/fhlhwsYffIMf1xH1L20gfjXO1G30Rur9lYSKj?=
 =?us-ascii?Q?eS4bc26U7gU7jH/IYYfW1M3ntVTkGcs2EQacOh0X6CPTQnGkf9CZoMsrt2jj?=
 =?us-ascii?Q?lBHHXmpIWdVieAzHsPdVZsgo96HgLtjLruXvlSwjYKOX8iNHcwBsnhz5dElL?=
 =?us-ascii?Q?8YczFQva9Leb5Ru+RDp7zIsmEp/pY6TJZrdEdVybWpEzI1wO/rVDpFnK1KW1?=
 =?us-ascii?Q?/qXjAZ9Yvkaz19m7daZ4tiKgBkCtb2BNDVgtLZJ3hPUtbuj0bCMVp/wrludS?=
 =?us-ascii?Q?T0fSITGXt2Pxe+qt1GzzrWhJQRERim9c1tH3NSwe47BuOaY1KnSnFu2JEpW3?=
 =?us-ascii?Q?7VQWicEzMFKt08P4d8/Zehttu2CQQmhRdiedCZrutYcOsHOoaSREYcnl5nEt?=
 =?us-ascii?Q?llRSRhHZaeAdRp8kVqvAvrsh+kRnWyWzPx2Uti7fgqSIJbeW1Y0bgMixdy9U?=
 =?us-ascii?Q?uEKOptb63Fy+gDyjeHIuKUip0DMHtI7idluAvRSkILH3SbbSY5y1BmWaHeRA?=
 =?us-ascii?Q?wOv8zlqQuoT4UXXpOev17MB9cW1PduaJiBjMWEuJASn+trPLewqBUusve32P?=
 =?us-ascii?Q?gPezqg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 02f1be65-1ffa-4160-f55a-08db50773344
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 May 2023 10:21:49.7012
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FhRP4XCA5u8y8RrNVqVL8c3R+jBYQeYeSnklLQ93z260/dQxMFLrUobdn07zxtjWLfd+/RqewEkSvw86/NhG1MCQqKnfSRE8ldQjO/980dw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO3PR13MB5669
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 09, 2023 at 11:05:16AM +0200, Lorenzo Bianconi wrote:
> Since veth is very likely to be enabled and there are some drivers
> (e.g. mlx5) where CONFIG_PAGE_POOL_STATS is optional, make
> CONFIG_PAGE_POOL_STATS optional for veth too in order to keep it
> optional when required.
> 
> Suggested-by: Jiri Benc <jbenc@redhat.com>
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>

Reviewed-by: Simon Horman <simon.horman@corigine.com>



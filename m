Return-Path: <netdev+bounces-8324-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 241D7723B0C
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 10:12:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7DEB91C20D69
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 08:12:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0FACC28C16;
	Tue,  6 Jun 2023 08:12:34 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2AF25660
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 08:12:33 +0000 (UTC)
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2094.outbound.protection.outlook.com [40.107.102.94])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 730E9C7
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 01:12:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n0SdLcuUbJ88BN3bWnRmVXpOb698EUJOcKgEOa3cBECBU98JLmQCpFOfqQ5kFEnGgq38v8SK80lpJGp1N8+eX8Um0BZPC2E8L75XJWPR2OIvQCFPA7rLVrQChYaP2cZi00o2AlyqO/BAeVH0Xpbyo8fmhmvla6/ZyUpfCqxuz9xwfOxuMGdNKTeK+4ipFKk28uRLswdZE+yzyHXxhqVVBqVekmtC8neBPbKBj80l8YfJPtv2Wh2V0hiyVMHF15aDntM2EAFa9iLv2VDr5dXGFlQICla5GaAqpLAALnK9GGbFLsYWH1Dg80mr+uX5/bWwRn1xsBpLU9JJy9tYPXjuuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qUEDBsZ9nzrgFjZkAxQFTEY2PSWGRO5bggHXkYOC+uo=;
 b=EoYDXv1ldEN0ZA2bgSawsStFMmqGCA0QYHBzmndFgOC60TdOJMtWYgnGPrZO8XA2uoh1O0bnDwVTF5yDn3/ES+5va0SxKp2NUy1BnpuTBP6hdcUyAmgHIqGjCOVJtWRBOr+vLzKWXqx251Xw63VIRan4UE0ExCaRGcgZLxLT0D2YO6rymPTHGu2gC0IivQunGUxgHFzqn7w2sQCg9kvv82O0eEQNIG3+qQHEJHKx3A+dEbM6LR7oPUUhP7vXbGrnLI7LDzmaiVa8Yl2CP7a842EbrpfVbzMdTfwPLLqfj3ptHub6iXCmyFVgbHJ/oh+uvCihjWZkW0QlwbmMUEKSNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qUEDBsZ9nzrgFjZkAxQFTEY2PSWGRO5bggHXkYOC+uo=;
 b=A8nzglc48UXM7qNDkN29d1E59Fo87JXEhwlC5YexqJbI2uzHdIjOLaU/likhfWs4em2VBqMt39O3k9shBS98Jk7Y7MHhbEN+0yBDvpolGDkfVqp9NXaRR+ThF/kNzna38q4z3ZYpJ0aUTwWYtPwUqQGjKLJ7rx/n/mX8kRkreTI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB5730.namprd13.prod.outlook.com (2603:10b6:510:121::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33; Tue, 6 Jun
 2023 08:12:29 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e%4]) with mapi id 15.20.6455.030; Tue, 6 Jun 2023
 08:12:28 +0000
Date: Tue, 6 Jun 2023 10:12:21 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Eric Dumazet <edumazet@google.com>
Cc: "David S . Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	netdev@vger.kernel.org, eric.dumazet@gmail.com,
	Alexander Duyck <alexanderduyck@fb.com>
Subject: Re: [PATCH v2 net] tcp: gso: really support BIG TCP
Message-ID: <ZH7qZZA438952N1a@corigine.com>
References: <20230605161647.3624428-1-edumazet@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230605161647.3624428-1-edumazet@google.com>
X-ClientProxiedBy: AM0PR10CA0038.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:20b:150::18) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH0PR13MB5730:EE_
X-MS-Office365-Filtering-Correlation-Id: 4cb0aa46-acfd-4d07-d08a-08db6665c4fa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	uW6EGG1JTK2vLofcIqohS79tiK2BD4CyvcnT+NvYsE0CWt1XCPRaabC5u1DPMmrr3uzAvJ0PRQZjM32/VmNVGBWeJ19fVdI/HLRMBJvxeRF7dgp6WL+a29oUxX7ApkoYO9xK2QyZeQSvyJYZWMBgq4CmaGDA6pcoW3eXvsdyJO1ryrmXYWlM+c/TkrA8PDuXrerH/bysxOYLy7p83h2bzGSp7qW4uJKu+ZjfhR11ROtKxmIzRGUgtGuYbjD27Ng2VELGc2wmA+ym4DHqNByLyFrGgpM1+OF4mHNadt2dFx1LQEH23Vnvs7CbK/wrI7CXDaKfsL2DuQy5gqxxaOZ7dj99HJwMkJJxoMfSCs8X1XC4ZEPMYm4y1YleimBmvv8YVyDKmc4KzY7DhvKaUSCOrFpzBIeESn45R3E8ilfPtG3hfEpMPA+ESQr3+N7+OGibGZybrjSjDvfyDVL7HBDr64W8+UfATT5vsutGNmV07fBXirSG52IaFeIHwIJGhBv4eGbfBOFt0pAK02MEIq5NCIAeoI44+e7AtsBgGcRTvWf7Fe9+dLIzOq8SiZBPA0GH
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(136003)(366004)(39840400004)(396003)(346002)(451199021)(66946007)(66556008)(66476007)(4326008)(44832011)(38100700002)(6916009)(2906002)(36756003)(4744005)(41300700001)(5660300002)(86362001)(316002)(8936002)(8676002)(6666004)(6486002)(478600001)(6512007)(186003)(6506007)(2616005)(54906003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?XgIdsK/HXiWFfTf/57M+s//4OkAHnfAvZcRC7bLZxnRgF0aAzQ1GFGzbgoVe?=
 =?us-ascii?Q?5SkZyS2c8kbpQNqo2WYd+IODN+LN0wK99COTj9xNy/KG57Es4jqfH9QB4sbf?=
 =?us-ascii?Q?ogFRTCtojrjPRj/zmxICPWG633Y3sjE6fRQydZy6bkgq9PzVFFsLXaqmKqU5?=
 =?us-ascii?Q?NxUn/6Z61irHcUSu83CHqCD8oQkQJuTIflLe4cJMmkwsnv4ifW544kFVpXnL?=
 =?us-ascii?Q?G2lPIMokOk0QqLMvszhhWno7Ym4Ofc/YdnNjIK8DwDiMsr3/xKH0745Iby6Y?=
 =?us-ascii?Q?gtFMJ57HfPax6kSZbsAh/oZUMjP5cVKrB5WTRo64JF2yRyC2hY/h1Dq8DI16?=
 =?us-ascii?Q?AvDJc407X41IsmJnwsSg/AEgnZST3NDzrVY3cJzM+L49It4sONWSBQW8XFKk?=
 =?us-ascii?Q?v9sm3ZE8HEK+vdrIjVzEFx/ZEmrvplOAUVsI9YCYjy15HpX9uC4pY61FVgqQ?=
 =?us-ascii?Q?rRpPDVP6ic7B6Ht6pGdY7G3W4LC0bNNsWg0gy3ITu0imCN9/bL2jQdcN0yjQ?=
 =?us-ascii?Q?p/ofT0jcQv1+3X1VIjoNuLJC/eQcWGoaW10KSUErhX0m8Qch4SWRhWgcSlf6?=
 =?us-ascii?Q?XUYo3P3UmJuU/RMoUEnLHvUdIYU2h1u9KvhccuReY+F1NYAcWjQTlw8+ImHr?=
 =?us-ascii?Q?1lWSD7umCo52d+2xNrGoyv5NKfhUYEkyrRka3XQpTPf4c2Awpme2xtEowsV0?=
 =?us-ascii?Q?p0a74HkwSFsENHjv+RoveAPTN9ewsI3rFOnOtX2hEzB3RRymh3nQkplcr3Li?=
 =?us-ascii?Q?L8/+Y4LMt76klZ8h4Q0++9h3ndIVAZYL6JufO+I2pLmOLZlD+Ms/7n/F6bui?=
 =?us-ascii?Q?DEueaVsEHwOVr5udGFFeWdGzIM9ls07tGxZ85r7/jOe1PhPFT0j2kbWgwb7e?=
 =?us-ascii?Q?RK8BwKF9+AE0BOp+YbtpJphTx6NpTniLMdxOu5HN7sAM1jErPKqJ7WNUNrOW?=
 =?us-ascii?Q?uQ0bNDkxXj1pry3CBuq81vbIhAwcPVwwFJ39WyC88ScYA8ZucVUtWC9F1Gb0?=
 =?us-ascii?Q?ug0h0QTJctINeWpIe678aAZauh9sCgPe8c/IAXe8d6wImvA4Qlna31gYrrDz?=
 =?us-ascii?Q?JMrQEvmV34q80S4RPny6NHgxyS1TT1YMyh66LONLBToQyNgA2VwQQu7yrGzr?=
 =?us-ascii?Q?0NB/sFUGmeFEiDSGyJXPvJl6Bc5rlu3H3t22QV1jhqcVK5XB+zzJvPpxEOld?=
 =?us-ascii?Q?1HLWxh704j4iZXBd/c4Df/JGSZgX9c24jZo5uFQvW5qyWJ7FGFAQ1YP4whlK?=
 =?us-ascii?Q?sA7cj9jV4IBH5Qmp0yhLybeP2DW4ZQqWXV8AZ7dFmGCXotaHun61QtY2ZvQS?=
 =?us-ascii?Q?2EDMyrcThp62URgUqDSVYAA2f521d4YdhlhVUqpAsywcwyI+v4eF217iZE5j?=
 =?us-ascii?Q?94Gq3eikm6YTD/CBRGBcYUs6AwPjEFRGyGi0s7dGEXX7FCiYMdTS5Bhc6w25?=
 =?us-ascii?Q?2J1l1m74EWpbLJRJzlrcFGY8V90jLBGMZ0QxQSBF74TQN0ss7oHpjHpjUu5O?=
 =?us-ascii?Q?z8feR4mNySoDWnDQ9O5tPwLf/JHBe8NKPsdgC4rPw7bs4xW9LCQEEqooeEG7?=
 =?us-ascii?Q?5/ekwStgzTAouOcb1YxrtAJRH3kcPMw9/nzKbh3nP2o0rR0A3aecgcg/t+ZA?=
 =?us-ascii?Q?fXfRu9vjquFYJlMxdske9J3ai15ydonojqFNzGi+CY4YMaESOioOu+0sY7o4?=
 =?us-ascii?Q?Ib9gAQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4cb0aa46-acfd-4d07-d08a-08db6665c4fa
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jun 2023 08:12:28.8686
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UIiAYs1I30C6n6Xtty9EFJciMBWT1gYuRCGDhsBtV0uJ3onI6jBTL7bie++sFsY1QYrWQBV3gxnW2Loqoey6nVzNZdddPAYo7EeKWKHQEYc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB5730
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, Jun 05, 2023 at 04:16:47PM +0000, Eric Dumazet wrote:
> We missed that tcp_gso_segment() was assuming skb->len was smaller than 65535 :
> 
> oldlen = (u16)~skb->len;
> 
> This part came with commit 0718bcc09b35 ("[NET]: Fix CHECKSUM_HW GSO problems.")
> 
> This leads to wrong TCP checksum.
> 
> Adapt the code to accept arbitrary packet length.
> 
> v2:
>   - use two csum_add() instead of csum_fold() (Alexander Duyck)
>   - Change delta type to __wsum to reduce casts (Alexander Duyck)
> 
> Fixes: 09f3d1a3a52c ("ipv6/gso: remove temporary HBH/jumbo header")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>



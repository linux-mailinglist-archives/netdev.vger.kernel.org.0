Return-Path: <netdev+bounces-3013-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0A5C8705041
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 16:12:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BDCD01C20E71
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 14:12:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE32628C04;
	Tue, 16 May 2023 14:12:15 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D975E34CD9
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 14:12:15 +0000 (UTC)
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2126.outbound.protection.outlook.com [40.107.212.126])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98A5110F5
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 07:12:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xt7reSBwjwgY+cosTaZ6T7XIVo286Vxi0Wu8hnd5aPzIPEdIWmt71TUtlvTwkVHl7cDb91Y/Masn6IvBryFNUHNTGyJoJbmWKPSq1+pzjpZv+CYBZ65ViJSfsf07HAhttr4DoDzDXkqaaUNiizmmy/8b2RfEejGrPVzWBVqzm5X605QNh+i+TBCldIYl7R24qjcB8fuHPrzHK3KSFpqAXXU8peCmdsQbL2hi6QwaPsiZnZN838jpAPLUuuGaLr64sRYi2yDpbQ+mM8LIaiW/3R24nmXBJvSq3vdpmKExToRBs8jr3Q8shyBvBXOjZbZy1/uUFKS6A1Goq0wb5SIeLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wr55U3DO3WeYlsocO1hE+nhes/smIuXrZ4vWCJu1pLw=;
 b=GRjAX98XE2B5c5xhnjf8JyccrW/F5TDdt77YKKPBbWHX2PFdXpp8VlKsTT4fpDakKkIWEUqpQdrDN7FauhrLrBDWp4xcuE1bRAeN6tZfE+puKX+42f3vnlAClSgrrCt3yCzM39JtnuwxRdl+C+suP2BwZPPL62mtWw3JDikrE3gzsojJ6Mi/nJPfy5bLtKLXKUdxCFoece+0+2QsrfNHIRVdfMOuYi+7XQAsjw4Mk8BD+9eMvQ6gB3ZsVcE7NBOGw5OoyLVRmCdrxO1PpqpZcT00RiaBgFMWRy932HkXSy+6qbfgeYYSPobeQ0cWHQ8WSiHhor49VaGU9L+aCUNzAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wr55U3DO3WeYlsocO1hE+nhes/smIuXrZ4vWCJu1pLw=;
 b=oKzBcp9+WOe/38JhIxJDOdbOu/k5ISQqrCF5hYiqzdgJQiXAW1VqrCQ3YrAReNz/ZAkZiL2B7eZEQT/96aHLQG1DxICl/yeILmGRo4NNsAE71uGI4zT/1kP5Ii44XuurF6RivI6Vt7mNRmo6sS4ItIJL36y84gXAcodi093nrw8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MW3PR13MB4140.namprd13.prod.outlook.com (2603:10b6:303:59::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.31; Tue, 16 May
 2023 14:12:12 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6387.033; Tue, 16 May 2023
 14:12:12 +0000
Date: Tue, 16 May 2023 16:12:05 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Hao Lan <lanhao@huawei.com>
Cc: netdev@vger.kernel.org, yisen.zhuang@huawei.com, salil.mehta@huawei.com,
	davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
	pabeni@redhat.com, richardcochran@gmail.com,
	wangpeiyang1@huawei.com, shenjian15@huawei.com,
	chenhao418@huawei.com, wangjie125@huawei.com, yuanjilin@cdjrlc.com,
	cai.huoqing@linux.dev, xiujianfeng@huawei.com
Subject: Re: [PATCH net-next 2/4] net: hns3: fix hns3 driver header file not
 self-contained issue
Message-ID: <ZGOPNftCoTFk4YGo@corigine.com>
References: <20230515134643.48314-1-lanhao@huawei.com>
 <20230515134643.48314-3-lanhao@huawei.com>
 <ZGKP1PKCocTAplDN@corigine.com>
 <727ba36c-234f-f17f-f696-47627b8450c8@huawei.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <727ba36c-234f-f17f-f696-47627b8450c8@huawei.com>
X-ClientProxiedBy: AM0PR02CA0018.eurprd02.prod.outlook.com
 (2603:10a6:208:3e::31) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|MW3PR13MB4140:EE_
X-MS-Office365-Filtering-Correlation-Id: ba7fd0c1-8dae-41dd-0ed1-08db56178b51
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	KzoJ0qndhUAUFglUUd4ZCPPVxFfcns6cKXjzsm2yReAoNFjou1aQ8HVT1jvo0/ohzcb/SMYQOavNOOQiUlXbgYJc4lljDvWkgpjIr42A20WJKX/ty9ZJtsmDQIDAJrc+PPD6nVWyTt8Y0zF/oLEy8ZjBPPoP5XzsM3E6MNgBSrjqfsJeAe4zn/NwKgNZlQs/KkVaj2KLvdngkdXPhxKLRtoIF3PDYaO6JkJAeVMxlBnHZui6E/pvvTo+Eed1hWJvRtB7Qcz9LuU1QSbhZFjuwk0XYIE5G7++g8wgYxk3ITck35nQyc/gphuHrri2A3hMztlg0KpzTIT5PA0TEO9A9vc68SKzFvPLD62JcPYNtNplR4CgWMCTRFPGNrp4FAto7annpmBN6r58ie5L72qKremLklppn8Hu6flTYCNWCOY2MfbSl5Ix6QlLxzH1cpPyl6dmFWGvlVbAxGJ2sKVpwyMO5vreOQzJdLVt1aV78ZMstmGpNUQmo86t0zuQLGnqDyOJSDT0wk+GoNuVYpfjC1v5y6I/kbZJ1VX5kixK1RUmbJG1O7Y6eqVfR/Zz0HjX
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(39840400004)(136003)(376002)(346002)(396003)(451199021)(478600001)(4326008)(6666004)(186003)(2616005)(83380400001)(38100700002)(66476007)(66946007)(6486002)(66556008)(6916009)(86362001)(6506007)(4744005)(2906002)(53546011)(36756003)(41300700001)(5660300002)(316002)(6512007)(7416002)(44832011)(8936002)(8676002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?QRs9bgBd/0WrfpLm95iyxbqqzgRn+u2a7Rqx786Subxxn0XTns5FE25gmtbE?=
 =?us-ascii?Q?ud4HqnyJdhQk/UIK9RWCP1FLNz8HW5WOAeZLm9bUoF6dIQiRlgEIAgNx74p5?=
 =?us-ascii?Q?d08/8yUFKPw1/+gv6YO4W/Y0Wk2XSWAPxgBKWiEDg+zpJ9f4+ZLcSkrjvWqt?=
 =?us-ascii?Q?y0tF5NVFRHycetFZQm5W5vmsEBiVJiwUWS2VuChCakSDAYL46rOUP1joEeej?=
 =?us-ascii?Q?pmVNpshXFJa/i5Ze4p7JsYB95+Slkt0oUWT7C7arDZg+LBHTE00D6bXhD40b?=
 =?us-ascii?Q?JWfe8yqv4Y0aO/leAkgxq0apYEGASmGPqDg6rbij1+/m9CgX5uaZW4WeXXKu?=
 =?us-ascii?Q?xWzdIfDyD+tBPEVWy+Uo3oXzfYZDTJ7WQvso9TL3rNyinU6Db4EYuorVMUpl?=
 =?us-ascii?Q?UBqvQEpgqMhPZMxiMhuQP7N7YHLpQIK/qSzfCxaVI/1VP3jfmkFodoxfykul?=
 =?us-ascii?Q?vJae/n4HeubzS8VWzuSZXTKbJ4FUIrG6Yz9Vzdo6j8K2HXnTJxJXJ6YJOwnq?=
 =?us-ascii?Q?h8mPq1+bZrMS5QgH/yfPFq3bIGHRbPROVVXnOHub9HOzIX6ItOP6ikqdQWCt?=
 =?us-ascii?Q?oFoHqMyD3fr17m3b8QaQRwJ2me8+PSRaQ1kXxIcTlsvMI1HLPJfyA4inVJ8M?=
 =?us-ascii?Q?5WaxZRtG/pm/5Blyu50BbM+suyqVAgeGteCSlGc/bMMV9h0B00Pjwoh85KY4?=
 =?us-ascii?Q?HWGflMwoVPzMwqyDox2FVxDM5PB5xm742tPnchIP75WNbf6ILYlsi5HPXJtl?=
 =?us-ascii?Q?RV40D3OhEzia585c+0Bwl3qPKRV1ixm60ZUgeNAtNazW2ytqp4pYUdAbBGap?=
 =?us-ascii?Q?33LmUoN4mVIHiQOH/LWpP5CIgh4QZ+aXKZbCIb19OSJUg3AgDr6UZenWRHiM?=
 =?us-ascii?Q?Yeo595lr4gvR7Ypx5+C7Bbrw5WBxrJcQBv2kzcNtmdRVEOTBHso2B9mW0HQW?=
 =?us-ascii?Q?xC4k65eaplDrAJT5yNzhiaE0kwykdSyY658/w0+TDXjc8jLhhqu3kKjKEAC+?=
 =?us-ascii?Q?YidQPuKp7IiZBJnQu454Y6BVgt8ldJ90k7iGmpr8B6GpoFJG9Op0OH+jroni?=
 =?us-ascii?Q?UtQCIHlf1xUXa01EL4mcyeAUjMyR0zOmoni6DiuZpFUDfNYBiDLDHdjo9UZ5?=
 =?us-ascii?Q?PG0lLY5lPJV0N/0WuCwHss5Xm4bD2HDiJisiyprty5/gwykT/QzB2/aI/oOl?=
 =?us-ascii?Q?ructA/vnRTtusaMQZNXQU4iurnficM9ZKej8cC0dl+yw9EYdyNsP3YuNwRRW?=
 =?us-ascii?Q?tC/hFn2Uwp+zrYyo8mblRIJ0FsDccSUI8Ur88+3YB8++ZUqwpBBlbq7ePgvU?=
 =?us-ascii?Q?GzBlY2OOrKPIptEF4vT+M0npC7OU5ASgRrSomLzkwNiEmaA6w8PjM4T5HTK8?=
 =?us-ascii?Q?T1DYWI9AtoN667N+LS+A6JKjjvK6y1zNkqHZcsrMYdVmb2sg2uuJX+0yMwA6?=
 =?us-ascii?Q?/WYNoBNbOV4YbR72VHjdut+5t1QX5q3FGtKA1dq3H2wy9E0cXxCRbQziU1FD?=
 =?us-ascii?Q?Gkgv2Kv603V8r2sGSd4ucj3AmBl0JAFBP61GLvqlC0TLvwYRHm+qbz+3J0KC?=
 =?us-ascii?Q?UK4J1iLiiKzIQ5BXQhdtcmclfp8eSWi0GPcs51dGKLhnB3nJqTnIG0epZOff?=
 =?us-ascii?Q?ZGnZfcR4smN85r8ZUWv4tT7ODfbnE3Lchf04qGcrSTQ0uzjzRRDrmPdNSkqX?=
 =?us-ascii?Q?aTyH9A=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ba7fd0c1-8dae-41dd-0ed1-08db56178b51
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 May 2023 14:12:12.6317
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7kzMFvnusHm+aWKTIq5sKM9+pfKQVJU6bN44dOS74vC/xvB8tzrZShmFv/uGqraXXX8DLN6L6gvn8tSzrUw82kWEqx2pB69JTTmh74L+920=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR13MB4140
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 16, 2023 at 09:12:57PM +0800, Hao Lan wrote:
> 
> 
> On 2023/5/16 4:02, Simon Horman wrote:
> > Hi,
> > 
> > out of curiosity I'm wondering if you could provide some
> > more information on how you generated the warnings that you are
> > addressing here.
> > .
> Hi,
> Thanks for your review.
> We will attach the warning details in the next patch.

Great, thanks!


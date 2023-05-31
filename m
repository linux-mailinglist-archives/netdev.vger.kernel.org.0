Return-Path: <netdev+bounces-6841-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E4D59718642
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 17:26:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9ED1C28153A
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 15:26:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD459171CE;
	Wed, 31 May 2023 15:25:58 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6071171C5
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 15:25:58 +0000 (UTC)
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2100.outbound.protection.outlook.com [40.107.236.100])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37F6D180
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 08:25:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E7lG00WZ2ITKrJG9A2t1ScJPGTqCIbz5TqYlYm2swKeLf7i3ic0YpwDSwgfVQNyOVnjIWP87fwnZOZ0fsLoyDXT6T9XJorS/pW6uJfJrz8+KUuxvp7dv5govilMlSYJDI5USqkOCkm5y7Py7u7nk1lAJmnVtCP4SBP7fkVhDffhPpCWQ0Y0cR3z0C4LQzcpDVPZhgknYIN/3eB4ZHW5qQbvMp/X5wUX3xevdbKRxgQuAbeZoj8pCznqhKd2GSY+dAFCIE3GxKSBeupQzWNAy7TDgRoQyKHsJnnUSekXyhT46G54yXYrY0g1M4aFGJnnJDhaWNZyUW2pirj0L7Rjy/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9BQ9LuQm2QqW+sX8i9KJd+lR7K9URH2K/d6AkvLTqLw=;
 b=HmoKzrHqd7UVFDJ0lKc/N1+F7/RwgXa0KoaBJ4e2KeN8Bo3+2uPdniDk+rhY6Kz69AMqmCYNTQPv6I0cepSRbJcnvs3lE1mTc7v7d0UBCh7NlyBeQYPF6IAqgMSnyzG9qU7vBCGuw934bLY29ax885vn+jrI2H012p9+kl0xTxUnraaMGDxxJLFen/jy2L3NJfqy2G6WGrj4j9u6oaICLAEyY6D8oYVZeAyLHurf/vh489H3hpOQs07cqPfdyiTQlqgrxos6TFnk0hU9G1yQ3HmCQJaq/VtdEBkYjgCuS1Ak+C+vs+1h5RixvKE9ID1waExnqTDAfpMaiyDsgavKVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9BQ9LuQm2QqW+sX8i9KJd+lR7K9URH2K/d6AkvLTqLw=;
 b=GZLoy0uC+UlHpOpiFY73O0a3Um4udrJKR7lHw80+c8kDnKteIMOmXE/1lar1nB0Cjlm+WOdjrwRApzKVkafM0ftHZ/s19GSknVfey5qu14yIvtSHBe15ydRPpdd9FkMLBg4S2LvdNqkhKzoY1I0cDQmLLjXPhKkeBJH/5/9o8cE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CH3PR13MB6534.namprd13.prod.outlook.com (2603:10b6:610:1ae::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.22; Wed, 31 May
 2023 15:24:33 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6%3]) with mapi id 15.20.6433.024; Wed, 31 May 2023
 15:24:33 +0000
Date: Wed, 31 May 2023 17:24:26 +0200
From: Simon Horman <simon.horman@corigine.com>
To: edward.cree@amd.com
Cc: linux-net-drivers@amd.com, davem@davemloft.net, kuba@kernel.org,
	pabeni@redhat.com, edumazet@google.com,
	Edward Cree <ecree.xilinx@gmail.com>, netdev@vger.kernel.org,
	habetsm.xilinx@gmail.com, dan.carpenter@linaro.org,
	oe-kbuild-all@lists.linux.dev, kernel test robot <lkp@intel.com>,
	Dan Carpenter <error27@gmail.com>
Subject: Re: [PATCH net] sfc: fix error unwinds in TC offload
Message-ID: <ZHdmqtuCtat4x9vD@corigine.com>
References: <20230530202527.53115-1-edward.cree@amd.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230530202527.53115-1-edward.cree@amd.com>
X-ClientProxiedBy: AM9P195CA0003.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:20b:21f::8) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CH3PR13MB6534:EE_
X-MS-Office365-Filtering-Correlation-Id: d48899c5-d885-4841-b131-08db61eb2298
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	wKI7BcZvK9UR+04rrgzjBpn76roxUYPJIxdEDF7jPHT5x1EI3N92/0LUbvIsOpl6AN8L9SEguxzQeocZTSy5NWvWPLIUSDXTNf7fyXyz8HPEbjcMpZlZB345he03u0rwoFxd0iqK3wGk91Y+iJBLapBqWOdPbwCKi5ngbNJWJUOXTYvK0Q2kVKZkjuE+kU10xBwjNNuzUxqyNxgXThlx9TAxc2IU8kEpRkkexmy2CV0GDQ8F6M26wOK5HqMP1FQ1fj8Ccj50GcOtFJqoWpo9ZOMqr9BILWauoUBOEsg1Mwnz26tDZpxkLI+WkslivDF/7wbnZCiboC11VMfis4vTPkDC9Ek5SYS/UwUO6muMryPVkJtw7TnLlx0BOx0YisCTqCw2JWQPzWzXeqpqfThby/kQvJ45bxUkUQqIZeN7aYcBJqqc0BDVCMWkp+FQVJqmy52LQKkzSmpSNMtvK3EXhFSTJOCi5LtH/J0LNauTK40NDbcWRmCDMOUchIXHOVd2BeoS67hGfoo7ftWmzMZgppQ80kwitbXwW4kEh5Hp/ta9kPYULziDy9OtAEbaltJcEbqaeKQ6iIcMkxbug+BpECw8rvXQUQYosfLtmWuf9m4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(366004)(346002)(39840400004)(136003)(376002)(451199021)(478600001)(54906003)(44832011)(5660300002)(8936002)(8676002)(7416002)(6916009)(36756003)(86362001)(4744005)(2906002)(4326008)(66946007)(66476007)(66556008)(316002)(38100700002)(41300700001)(2616005)(186003)(966005)(6512007)(6506007)(6666004)(6486002)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?0u0LvAUSAb3zq9mcN0AhkR674yNmLgez3xplFGVwDRK6ijqbz7w6O9HeeEW5?=
 =?us-ascii?Q?vMKRvel9541d5TAIgpULgj4vxasTVDGReISL52yKu44xbY1V6OUdwIo0YN0K?=
 =?us-ascii?Q?K6ZLgiwniTEgohT2lzfy6xrVijxjblmooLSLY0lN/paO3JnmtMT9eWJS3Co4?=
 =?us-ascii?Q?SSamvnfWpiyTCyIP+NOG1IHF2EeCYuGAimbfCytYJ1Mi6eAwHzbtrpaxzqer?=
 =?us-ascii?Q?48/bZ0gmNSP8yvyhV0LUz6Tm8XfaY5iTQXQsg7vvYrkv5NiPkFoedqLWYe/N?=
 =?us-ascii?Q?2fd3hKOyE3iSza5kB2198f1kVT0LmoS79fDVOuTerVXmUJvzBYQuHlBppaK8?=
 =?us-ascii?Q?GTOhb0RPby/QMb5DPomaYWM+SZHbm6e+ec/HSuc84x4sYXCuEEevqhVd5i49?=
 =?us-ascii?Q?KJwiTDD/ZEC0WD84a6IA1xyWPCt5LB5fXVEb+AFvPl1Xuw1C6qmNKkwnqluu?=
 =?us-ascii?Q?8A+wvE4q0Oqf6nOV0jvfTZYgr6IU8lnbhFsJnAi/Ttq6yW8m9fOoifFz1yIQ?=
 =?us-ascii?Q?1fb0j8GSc2DbbSQaQ0wW/1/GrruBL5OrQZo87JOobZ7TnUd12rT6sUdDRFkk?=
 =?us-ascii?Q?EqEH4j99vskeYBIgZypSYrjr8Ge6v91OXvSbQaOFxyyg6rR+y1qiEICN4LnH?=
 =?us-ascii?Q?vPT3ySBdBKE2vdj6Zy/8+WwzWIcBLgdPpTaJ+wZ9MOKPGKhpVAcqi7TrQMSY?=
 =?us-ascii?Q?3/fzTuDFjo0fh7ksFAMzRwpA/xP9aYeliaYlN/hcwVMVSor+MkN/nJpmUsn7?=
 =?us-ascii?Q?L57rDxF2+0UHgiBTW9sKYlQALyvZv//2iXSEn7Tkruj1nfpSCZgaNxZKPbaV?=
 =?us-ascii?Q?dF42RAlAfsZYTk0nUx/VzxJtQtjs/noLauObZ9xLDIYrqUYzTRzdCn4QVwdq?=
 =?us-ascii?Q?fp9JZPhHoR4vOEk/7CtCXzVawnzPkhoMtLiQT/ZiHtSwh0gDLmuJlhCEpNRk?=
 =?us-ascii?Q?iVJmYV2GETgwpe9D7z+XnpZTuEdqdmJd3EA/tNa2ylgyUStJsImoJWpFT9v9?=
 =?us-ascii?Q?jzyuUKEMLB/YsEeZ/ml0XnpLCQjmNCCJS4xw1H0BlP+eSgpCTRYCTMQtvtCo?=
 =?us-ascii?Q?2msyIzsPoqW6Fodh2WW4BKaLJ9vZOo5NoHCKfjuk0B0OSdeMi6bkKSf3VOeZ?=
 =?us-ascii?Q?nPAZ85qEt3L4voiHQ0bQrADwryRhzcX0PlV6yELJXN74g/bXH9XneW6D34Z2?=
 =?us-ascii?Q?o+W1/yDw0V537WRRH0oMZH2y83Bg2F7TDPLWk/4WMlUTi6SmaoayUeDc7Eih?=
 =?us-ascii?Q?S6Iuk4Ng0BZSM6PZIexWlCFF8o+C9MbTrzOa45w7D7ghEjlsUhPxBkf2oTWy?=
 =?us-ascii?Q?bCR+l2ed5/Gtf9A8a2kW08OoqPSUzdLybxUieGsByM4tyidvTVaygpy2o8EP?=
 =?us-ascii?Q?GSnsrDpxMyCtfqHFaF7eIZo0CSxII8w3UyTX92gVdumKYC4MAQwmeKPIZSGl?=
 =?us-ascii?Q?+0t9HdUauk+xkpWPYL6QQYxWbN5LmMruDFbgeD2Uzip8QLsIDhI7Zo9gZxUO?=
 =?us-ascii?Q?RNwLH7OpChcwNsApeaYHLIaKRBVSilmB9rCBDABvArDsFDOJqOcxzecnWh3e?=
 =?us-ascii?Q?IcAmFrg/aadcgUfbwSABwWSh4tCgD1IH8r8SkWv302kMEJNTfRdJzHn2CJM+?=
 =?us-ascii?Q?Zq5p3+t3fBkZfgKvI8f/zazpzb+LLa5aZynK/JOjfohL63n+OOIyD6vfImdC?=
 =?us-ascii?Q?ffAHnw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d48899c5-d885-4841-b131-08db61eb2298
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 May 2023 15:24:33.5868
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wESmYYHoTdOeBu71jx5q3a8/fdK0DXtxnpqpf48W/S6yQKyQlMSiWXT55BfsL94czQRypSgJBxx/wY6+/+8ftKjZhu/Uk+GDCvjCYnqhyZA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR13MB6534
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 30, 2023 at 09:25:27PM +0100, edward.cree@amd.com wrote:
> From: Edward Cree <ecree.xilinx@gmail.com>
> 
> Failure ladders weren't exactly unwinding what the function had done up
>  to that point; most seriously, when we encountered an already offloaded
>  rule, the failure path tried to remove the new rule from the hashtable,
>  which would in fact remove the already-present 'old' rule (since it has
>  the same key) from the table, and leak its resources.
> 
> Reported-by: kernel test robot <lkp@intel.com>
> Reported-by: Dan Carpenter <error27@gmail.com>
> Closes: https://lore.kernel.org/r/202305200745.xmIlkqjH-lkp@intel.com/
> Fixes: d902e1a737d4 ("sfc: bare bones TC offload on EF100")
> Fixes: 17654d84b47c ("sfc: add offloading of 'foreign' TC (decap) rules")
> Signed-off-by: Edward Cree <ecree.xilinx@gmail.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>



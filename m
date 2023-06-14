Return-Path: <netdev+bounces-10722-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8297172FF9F
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 15:12:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 42C8528142A
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 13:12:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 632B2AD2E;
	Wed, 14 Jun 2023 13:11:58 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56B3D6FBB
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 13:11:58 +0000 (UTC)
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2100.outbound.protection.outlook.com [40.107.236.100])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F468A7;
	Wed, 14 Jun 2023 06:11:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D/jRbs39a38VUqM6HWNld1Q3pFGisqXjz5UtUWir3a2rA2JqOwH783ECLis+2q4RNyl1949vKTQv5Ltbtqa4yUxDoOO7WunLCuDSXHcfhSg5v6fHXr0FZ1bCgVA/AUo2o/TNzu5L40mBtlkSGBEBiGKCKy8Mi8xeQVgphU5PGchKH1nrPCGV1Cvo8btUDeqFo8El70M5g6sbfhhUjOT3uTUL04u2LEbYYVzYfE4/Q8MaBvKfDhdkH4jQ9U5goDPmIW5n7hZTld/70h0LibOZavte9XN9uZ85pNPEkcTwxHjSaSQygVDRPh1yP5zbOrl4aLCFo3glbp4NC8oD14NlNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZruOZS8Uc5sE+2liwFpHtUe3HSdzoEqMyQutFdLhgiU=;
 b=GUi3CUnKJt5HDM+h50OH34C3GW6uHjokNoJl9iaqZ3E3fd30LUWJUCiwj5Rw+VggJ9TBbok7puf5+U47GPShbpCbiZzqE2WyIgoZVaJoiprGyyL8aJImDHtt3WV5Dfp7v66l/Nt5Q/m2WWdvcskmp6oD0YpqsWJMjkrdi/d0Yu0pyFMCrJaIbm3yzPEhrABBqXVjJxOBFuYR1PFLZ90tsRpQaQihVbevCEaxoVDnGUH5G4CVPRYqWLgK/NgPCLljFqvYz21hF/Q0PykcsnqEYH1xd9JnLwE+QyV8jsqdFLn18T754Gv+aSswOC1bPm9wzwA749ffspz3K1CtABWFWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZruOZS8Uc5sE+2liwFpHtUe3HSdzoEqMyQutFdLhgiU=;
 b=Z6iyGzw1DcprkrwnRBJ0slX6U9CnvE5od7FmuDH0R1k5rWcsYBtbbPhtM1DFEdU4MPB+jG69Jaj1cGH3vfwKEYGtYzTDRvuWS0lwbj3l6SRSvsQywG0YmuG2zU6J5avYxBLKNlgicVFHtuaVTHaCwfsXA6FdAq6jJLtN+pOyzdE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH7PR13MB5405.namprd13.prod.outlook.com (2603:10b6:510:138::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.39; Wed, 14 Jun
 2023 13:11:53 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e%4]) with mapi id 15.20.6477.028; Wed, 14 Jun 2023
 13:11:53 +0000
Date: Wed, 14 Jun 2023 15:11:44 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Vladimir Oltean <vladimir.oltean@nxp.com>
Cc: netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Cong Wang <xiyou.wangcong@gmail.com>, Jiri Pirko <jiri@resnulli.us>,
	Vinicius Costa Gomes <vinicius.gomes@intel.com>,
	linux-kernel@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
	Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>,
	Peilin Ye <yepeilin.cs@gmail.com>,
	Pedro Tammela <pctammela@mojatatu.com>,
	Richard Cochran <richardcochran@gmail.com>,
	Zhengchao Shao <shaozhengchao@huawei.com>,
	Maxim Georgiev <glipus@gmail.com>
Subject: Re: [PATCH v2 net-next 6/9] net: netdevsim: create a mock-up PTP
 Hardware Clock driver
Message-ID: <ZIm8kK7plae8CLvV@corigine.com>
References: <20230613215440.2465708-1-vladimir.oltean@nxp.com>
 <20230613215440.2465708-7-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230613215440.2465708-7-vladimir.oltean@nxp.com>
X-ClientProxiedBy: AS4P192CA0002.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:20b:5da::9) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH7PR13MB5405:EE_
X-MS-Office365-Filtering-Correlation-Id: c402e377-9332-4f21-806b-08db6cd8ec03
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	gLDB2hLJ7dVFPGKu6iOUJqEHGCoLbIZ80dmvvOSqyGdLDzPTOR5mRhmoovCQu/p8BLt35HKocU9nzvK2Roa7yw/JZjQ65hX9JBXfkxmq38XBSVLr5oxNDjAQjs4PREqI5ec2dBSaVdCz9Du0EPobxUG6zk7HGFjJEqa0JdRoyRkxQ7DBEyBh5o4d4P7tm1W9I0Nw9VlkRjIbtAhoHK/ogTgTRvwaE68wM6TqwUQcvIr4SvrQlic5OwyQYUn38fpUnMABrIcr6i+Ygw7TWPnfyANlqXlm86ZPbdfkW8QHBPidzjh7mbFa5Wgk/AN9QNnI67wmB+8bRURnf5XyTxQ3rmugdaAZQkq0n8aDEMscWB8P23xJwn7MusGW8WGLu8XuU0TnfGNO0LzCWHJjYCUzQjI9JrXhzIUKSoX/oBcjbG2rFbbD9n6Ss3dxg23zHQcgFkmWgjggJ0vUXFYmYpkas2L8MFRF554f4rx30eun6rJtM0Cyc9OgvIarjQFBtAeNMzFR+PSu9qzrUGdOAdiZoU5F2f1W4aGfJswJlnLRWGNrypEpcyvQqAH0FouyYNbmPAy33X+oIwE90FMYHFtGLfBt1eQRlwKnJek/IZ1Vjwg=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(376002)(366004)(396003)(346002)(39840400004)(451199021)(66476007)(66946007)(478600001)(66556008)(54906003)(8676002)(8936002)(36756003)(5660300002)(4326008)(6916009)(66899021)(6666004)(41300700001)(316002)(6486002)(38100700002)(6512007)(6506007)(44832011)(7416002)(2616005)(186003)(83380400001)(86362001)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?oTeK6w/68X+Hzl5t3EBLDRniKkGGL4EbYbbpJcUrGzDdvC9zutKVmafiupzB?=
 =?us-ascii?Q?m2TMzMimTrmQCPs2oHf/zAh6xxeCazwLrt4OJS9gfyKawc4zlhJhI69uaWQR?=
 =?us-ascii?Q?wWdL3EeuTMAseZV4VMqqzwlCT+ppd0BA10b4L5jqd9iE6vqHmujk+VQNrBZ9?=
 =?us-ascii?Q?IeOsb46mqUIW4reVuuvajdmaMXa+4LTeg+DohAaDywqjGwuDjQJ/G/j7dCpW?=
 =?us-ascii?Q?8+0fvnec/rPHGPdG9NtAQO3FaIzafeQ3g6S/91oiMta8I2UY1p/rjDpOqpL2?=
 =?us-ascii?Q?7F/b6Rz0Eg644GG8ByIYXIF5ZZqKeQ1ePSrK5GFgnbca/kdG6rjkeThWLSym?=
 =?us-ascii?Q?F6S8GiPWTkDKh+f4OL1G6SAWLiDWdCgp7m1D5r9ydYVjacR2fKFLiqn9GMc7?=
 =?us-ascii?Q?jhSnDY6ZWaKoApeHDwq9/gCt+pEbc39Z7Nxa65BsSd+Juh7YkmEoZo8kIJCC?=
 =?us-ascii?Q?vDvfzlLSozRAQ+mbjCfxSqBsoJwo8udq4VafVbyDlQkZGZ93+NK39bXDJFjs?=
 =?us-ascii?Q?MGnt4pZsm1yyyHjYSV8WvCFZD0/m0+lqWuGZVN0CkCyZ0AkBK4YrRlJ+f9jU?=
 =?us-ascii?Q?p5fUhxbtMXW51hAwkeFbkemfz10v76nvge60P15J6CQVKzC+MWp/sqs0lst0?=
 =?us-ascii?Q?ak38/4O+n6TF45LhRx6tFILvJ2FRlmf/q3tkU1KXlNk6Zu1m/RIAzbk/tSyV?=
 =?us-ascii?Q?jMs76P2WVkFs9MXaC+O6SuBYN+fi8kC9ygffDothJkN9yinsqvN8FVo/sNeA?=
 =?us-ascii?Q?/yhtJI/fRTNny5bl1FxyNfFCmFooA4QUH17MS78AyLxzXPho4bOr9hUYljYJ?=
 =?us-ascii?Q?dgxTb3iJX96bRUv01/VDOVUqBqWN8RMphJ5o69bZeCEm5kBxU6J3Wlsy3Lvi?=
 =?us-ascii?Q?cNKTMAJQpyTSl7kLpFyd378Q8gQ3U1+oKcoWxrpC0kl1i7Bz2NxMI9ac4IHi?=
 =?us-ascii?Q?avYHtI5O/G0iR+msj7clViUOWOoOwdSbOzj1Y5nHMEN2TMEBs7XwxL0V4X+f?=
 =?us-ascii?Q?hSRgimAdywhS1zGdDpZwOquzaUAPZBLJMu13sO8SeFZliTsmdTYMFj0vKuyZ?=
 =?us-ascii?Q?/6ILMNk8MDLeHSKJsbrMC3doQQEzmUD+9rLwBCTSZNyZPZ8ah0LrMo8fVfjM?=
 =?us-ascii?Q?+9l5VSTVHtEUUXmwliNM3Z6c3wL07Uw9hnNPE8JEIhmOoRH4zkRykUMFx/iq?=
 =?us-ascii?Q?NwLl+7EEQF3n6i7JLV5yFA9MfbpmmSpgjL7OoCEbavNywbn9O3F9lgT/bOgv?=
 =?us-ascii?Q?GanQHDOgQBIA/tljYTmaM7jn+rapiDqitslknEjG6ApHQk4ctxqjxmNOVkoU?=
 =?us-ascii?Q?cp61pFNnu+AhXKsnlP9aLrcHLVBCm5khrE1vAmCHXDz/FLmy32+iDzv7N4Iw?=
 =?us-ascii?Q?V8dl5/dgzgXmWIpdDqt2MRJ3tEFGdFCxF65Qn5qBY9ntTILeUUIJdnS8mLRw?=
 =?us-ascii?Q?8PDr+156LPU6aDIPRNI+bRZUnmTn3futRdddov3O4V1EpmNheaRPtdc7ru9W?=
 =?us-ascii?Q?jxVH4O7KQ5KQRHgGIEtj/CRidB/XeXdbGbRM/hfvVluEiz6P/yZ6bnQshWRu?=
 =?us-ascii?Q?MKJgYEw2G/zDojn99SIsgClEicr2dyNcsr7Ujg3Na5gNz6nYSH5RtqSj7n+k?=
 =?us-ascii?Q?rHnWmtn+z/B7SoWjly1ZTYnNcDqSDYGUIA8kNKjKNMwVkl/TIG1Ot/+XN0Ge?=
 =?us-ascii?Q?flQ/Hg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c402e377-9332-4f21-806b-08db6cd8ec03
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jun 2023 13:11:53.2792
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7uCUSBJobED3jAP30/XAfaFyi29//iQ4bIgeM7mQoGsnxNYwcLKkoRpye64UnmHQs47TYi/5LzjH0+2TynS96cPK2eRJ4wNOVjedmfA1UAk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR13MB5405
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, Jun 14, 2023 at 12:54:37AM +0300, Vladimir Oltean wrote:

Hi Vladimir,

some minor feedback from my side.

...

> diff --git a/drivers/net/netdevsim/netdev.c b/drivers/net/netdevsim/netdev.c
> index 35fa1ca98671..58cd51de5b79 100644
> --- a/drivers/net/netdevsim/netdev.c
> +++ b/drivers/net/netdevsim/netdev.c
> @@ -291,13 +291,19 @@ static void nsim_setup(struct net_device *dev)
>  
>  static int nsim_init_netdevsim(struct netdevsim *ns)
>  {
> +	struct mock_phc *phc;
>  	int err;
>  
> +	phc = mock_phc_create(&ns->nsim_bus_dev->dev);
> +	if (IS_ERR(phc))
> +		return PTR_ERR(phc);
> +
> +	ns->phc = phc;
>  	ns->netdev->netdev_ops = &nsim_netdev_ops;
>  
>  	err = nsim_udp_tunnels_info_create(ns->nsim_dev, ns->netdev);
>  	if (err)
> -		return err;
> +		goto err_phc_destroy;
>  
>  	rtnl_lock();
>  	err = nsim_bpf_init(ns);

...

> diff --git a/drivers/ptp/ptp_mock.c b/drivers/ptp/ptp_mock.c
> new file mode 100644
> index 000000000000..e09e6009c4f7
> --- /dev/null
> +++ b/drivers/ptp/ptp_mock.c
> @@ -0,0 +1,175 @@
> +// SPDX-License-Identifier: GPL-2.0-or-later
> +/*
> + * Copyright 2023 NXP
> + *
> + * Mock-up PTP Hardware Clock driver for virtual network devices
> + *
> + * Create a PTP clock which offers PTP time manipulation operations
> + * using a timecounter/cyclecounter on top of CLOCK_MONOTONIC_RAW.
> + */
> +
> +#include <linux/ptp_clock_kernel.h>
> +#include <linux/ptp_mock.h>
> +#include <linux/timecounter.h>
> +
> +/* Clamp scaled_ppm between -2,097,152,000 and 2,097,152,000,
> + * and thus "adj" between -68,719,476 and 68,719,476
> + */
> +#define MOCK_PHC_MAX_ADJ_PPB		32000000
> +/* Timestamps from ktime_get_raw() have 1 ns resolution, so the scale factor
> + * (MULT >> SHIFT) needs to be 1. Pick SHIFT as 31 bits, which translates
> + * MULT(freq 0) into 0x80000000.
> + */
> +#define MOCK_PHC_CC_SHIFT		31
> +#define MOCK_PHC_CC_MULT		(1 << MOCK_PHC_CC_SHIFT)

Maybe BIT()?

...

> +struct mock_phc *mock_phc_create(struct device *dev)
> +{
> +	struct mock_phc *phc;
> +	int err;
> +
> +	phc = kzalloc(sizeof(*phc), GFP_KERNEL);
> +	if (!phc) {
> +		err = -ENOMEM;
> +		goto out;
> +	}
> +
> +	phc->info = (struct ptp_clock_info) {
> +		.owner		= THIS_MODULE,
> +		.name		= "Mock-up PTP clock",
> +		.max_adj	= MOCK_PHC_MAX_ADJ_PPB,
> +		.adjfine	= mock_phc_adjfine,
> +		.adjtime	= mock_phc_adjtime,
> +		.gettime64	= mock_phc_gettime64,
> +		.settime64	= mock_phc_settime64,
> +		.do_aux_work	= mock_phc_refresh,
> +	};
> +
> +	phc->cc = (struct cyclecounter) {
> +		.read	= mock_phc_cc_read,
> +		.mask	= CYCLECOUNTER_MASK(64),
> +		.mult	= MOCK_PHC_CC_MULT,
> +		.shift	= MOCK_PHC_CC_SHIFT,
> +	};
> +
> +	spin_lock_init(&phc->lock);
> +	timecounter_init(&phc->tc, &phc->cc, 0);
> +
> +	phc->clock = ptp_clock_register(&phc->info, dev);
> +	if (IS_ERR_OR_NULL(phc->clock)) {
> +		err = PTR_ERR_OR_ZERO(phc->clock);
> +		goto out_free_phc;
> +	}
> +
> +	ptp_schedule_worker(phc->clock, MOCK_PHC_REFRESH_INTERVAL);
> +
> +	return phc;
> +
> +out_free_phc:
> +	kfree(phc);
> +out:
> +	return ERR_PTR(err);
> +}

Smatch complains that ERR_PTR may be passed zero.
Looking at the IS_ERR_OR_NULL block above, this does indeed seem to be the
case.

Keeping Smatch happy is one thing - your call - but I do wonder if the
caller of mock_phc_create() handles the NULL case correctly.

...


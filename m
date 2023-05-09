Return-Path: <netdev+bounces-1207-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E87FE6FCA47
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 17:32:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B7B7B281341
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 15:32:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D330318010;
	Tue,  9 May 2023 15:32:25 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE79F17FFC
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 15:32:25 +0000 (UTC)
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2126.outbound.protection.outlook.com [40.107.223.126])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28AAEE3;
	Tue,  9 May 2023 08:32:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VPGGxd1TKt4M55s6GOhs81n/WpgkEMDqgtSZwD+X+tiAsTyfppJLmd4RPpbSqGJ+4uIdsYU45B9zn1BvehbvEOxMUQlMrU8pVVlOk38BkOaGyqjn4UHwA2+iCHd5Ly6CN+5rI/D1JrPDL/3/SN4XWHCMmnK2Pfsi5V4O6XUnzhHJsh4r14dxz0wRz/pGOSMOSvjK1li2Au6dzoZovAZRNhoV2YvBIBq7+ORt4fEcjVKHi4rgmIJRVJpvUGLJ23W1bmhA9+ds2pLVYCS1b355SwHQ8yl9B4gq4d4h5qymenRxQbGsmpeBU1xeVxzeBDuL8Lz7dt+jWjxguLF2mGN17w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8omDBpoApxd6ihGMNg456OUHsUDUl+6RPhj8VpBBfP4=;
 b=bS/GAiZhMw5uYTbZkVhUCCeIvM9qSi4LiQUg4hh+ctsksWuSucA2zBgXLEEkgTV0s14G+QA9UuiPmZ65NXrCL9JYZZ/ZK2C3I7ZLg/WEMv6s3h0JJlEI5nQrL62svVBl64LYk8gJPt/EwEr0wog7LBv98VMjkIvXx1XF9Ok6NIIRgNGPqlfjPGOW6zDCjGvQptlZm0QVDMQuXvKitKnwpToLHn64grQiFnhuoL1XbS3RUgAeKYM/e3fx/sUsWyZ1EpiCUPOVxrMYpO24QfOEnfgiFJVeP8abTkSgtxFYWrubEL1LbQMrpdBjZLPunEmR5a2xtDVdRY5ZpVapc7bY6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8omDBpoApxd6ihGMNg456OUHsUDUl+6RPhj8VpBBfP4=;
 b=B0H5HKdPlfjW9McmufyotflNeFYFlv5kcG01YgLeUa2IbvpGscqfjPGipgJKP/fptWkrkOWrDWYH1+DTtFpqr4UpNgCxoeD2YzwrU3aVy2Z5TMz8NX8KmJBTBdZxpHI4X+hTjsrLEL1Y6tub97xhI/UobNJKXpJzgTBiBMqCxEw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB5332.namprd13.prod.outlook.com (2603:10b6:510:fb::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.33; Tue, 9 May
 2023 15:32:19 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6363.032; Tue, 9 May 2023
 15:32:19 +0000
Date: Tue, 9 May 2023 17:32:12 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Jiawen Wu <jiawenwu@trustnetic.com>
Cc: netdev@vger.kernel.org, jarkko.nikula@linux.intel.com,
	andriy.shevchenko@linux.intel.com, mika.westerberg@linux.intel.com,
	jsd@semihalf.com, Jose.Abreu@synopsys.com, andrew@lunn.ch,
	hkallweit1@gmail.com, linux@armlinux.org.uk,
	linux-i2c@vger.kernel.org, linux-gpio@vger.kernel.org,
	mengyuanlou@net-swift.com
Subject: Re: [PATCH net-next v7 3/9] net: txgbe: Register fixed rate clock
Message-ID: <ZFpnfNy2NSYNwUyI@corigine.com>
References: <20230509022734.148970-1-jiawenwu@trustnetic.com>
 <20230509022734.148970-4-jiawenwu@trustnetic.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230509022734.148970-4-jiawenwu@trustnetic.com>
X-ClientProxiedBy: AM0PR10CA0036.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:20b:150::16) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH0PR13MB5332:EE_
X-MS-Office365-Filtering-Correlation-Id: 4de23eb7-12fe-4e11-9111-08db50a2933d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	OU0GSMU6mqFKeeQTE4hoYSx3/k0CawmwFNYadoRwFpLENfjmObqPd8qw3wPfeQrSpfyxCOf9nsqXgNa4MjXbzAP2euZRbzQwSUv/xt3lZT3Y/Z1GsAgJEhKcCcvqAKc88uGetpWLo4hGzr9oDbroBB7H8aVImcX6Y2t66YzP3tuqfelnGqGGb42x5HXM/fxYUgqAICI6DhlTK8Kn5zDvU+t/oXyKC1f6a/x0YINum2+JXbe7rPE1fU+1laIJ0y178YQnzrxDyc6PJILivV8rjed0Tuh1vtw1XPv94tGb7zWfzzWfBAo3rAehR8HF9xb3PYrYMW58mHmTRj1jzs7cAk/f75h3E/GN6KdRBe6jG4wPT8RCVcm1SK7+jGc+pPql+4IBKU6L4dQ2s66Jrt8x3RzcxZqpZe3x/5rEiW50koIGj8agKqjRuhWxWE2fIk3gJh94JdANBRewcsjI5oNfIm7s1XZ+MCgg/6LaC/mqW91dHol92rQKEhtY+YTIQ70QGbsiSGkiCxM07L+ZTujM+NduqFV3elcX/eP8ggyat3Kgjn4J4WtLHAIYNhIoKGMY
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39840400004)(376002)(136003)(396003)(366004)(346002)(451199021)(4326008)(6916009)(41300700001)(316002)(8676002)(8936002)(2616005)(66476007)(83380400001)(66556008)(5660300002)(66946007)(186003)(7416002)(44832011)(6512007)(38100700002)(6506007)(6486002)(6666004)(36756003)(86362001)(2906002)(478600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?hrRQ7tcxcSXaBhDLbafR3Q8pZGnQqtU/sm5D+j5tgdsnXQK7XRH0AvOYHJsD?=
 =?us-ascii?Q?75rLT7Isxn+5yKBbZjcKdZTCH1artwQTw+olYYEd0364bK61Sz4kIZbLNN+k?=
 =?us-ascii?Q?xa8zN6ru7cajplEyP3MRpitSxGPX8iGUmWwQ3C7jnLSHfNPoHWGOTYPrc+0o?=
 =?us-ascii?Q?l0Ng5ku3JLQdF3RziMTJJsLMkyuL2P67tDj4vm0ecEr8qz2pyDp/MmfK8rOf?=
 =?us-ascii?Q?1xWEH5SpjB3ghV35WFfrAy7M6Buv3g49+bAppVAtEdOzwE2hH+6PpAG9zImE?=
 =?us-ascii?Q?vsQCyv9iDUql7LkjN/55X6xuh+b4KrNwfC9g16ho9QTD0BWrcJHCn50/+JAE?=
 =?us-ascii?Q?4R3XPmgHxtH170s4/uNh4dkt9cWWPoLoir7WOXE0+89+w2z1RJkzAPkwwjXQ?=
 =?us-ascii?Q?0zn2F8xkFYKz0e9yUBSrK0U7nMD/feFHzmqKIXi1csmMocscbmLVVQBdr4Gn?=
 =?us-ascii?Q?QMRpbbdyy4L0cTOa7FxSeF55h/MsIg+P/08YGeeta/XSKei8pG0BsKGetE3m?=
 =?us-ascii?Q?SCAawI20V5IJrWFnO6j5+k2tqyf1Hvvl/iQ8UWWzlkhRw0pMsXaGtWQnzV/F?=
 =?us-ascii?Q?6ko7RXM6FpHsuPPYMgU1CUl6ncKy+HRZKRtRsxDWeTB7SsnAcTbYWU6vKcIU?=
 =?us-ascii?Q?RHnMcfc1nfAKlf7dqJpvXPn6Tc2hF+MkhUoCRvtmb8j0TdWBnZE3zALD+5D4?=
 =?us-ascii?Q?ocJAr/pUlaZpbyzlezxmFHDYOXMmZRe9yPtPtpuFOWXbDVhqoztfovECHU7C?=
 =?us-ascii?Q?mCVQ7tCNLBPFC+qN5kqZtl67/U5LDg/rtTEfD+WZEB27iea10IwdzCKPne6s?=
 =?us-ascii?Q?b/W5ZIkTAqSpOP79dBMQPhn0wy+xhtQLDkGOkS9/EZ9U6EwRJiluoHwEMzgA?=
 =?us-ascii?Q?S/EIsqUe7TbmGF1jn8h/AMhjICx00+mRrfHkdApQWofND76LxMq13VmVhikz?=
 =?us-ascii?Q?USI4+Qej2SbltK8kZjNyNgh95oBg97VQUlq1X5sW90Km9N2V77Q2ti6XQu5j?=
 =?us-ascii?Q?XV5QdA0RPWIlRspV6fF/uJ7bXOxzH+57dmmk1injUGbFkF8ZKP3hyb5CMGlT?=
 =?us-ascii?Q?yqSKHnZE6tZ5+1MHyYMqsiJFGSnCrHFhZwlv6JOE1Onk6Qn3wDjaq/7MgxGz?=
 =?us-ascii?Q?HrUDfyOD+bnR1od8IVAodSUlUcKjp1Mys7Dq6F0hDDLXidpgDIULzIg8Yo+3?=
 =?us-ascii?Q?DVW8PDWN9qgAgRCeZ2xz8+JjtTddLPKgkukL+foHZTRVR6dg8ZnRhvV6ZHKV?=
 =?us-ascii?Q?nNqgaCuGtC7eSgfzJLsttlRa3jjBax5Ya2Isv3DfR4tDd4cYEbZVcYORkVVe?=
 =?us-ascii?Q?GrJEvUMDPX3IwpudUMPMWA8tLzSk4XiIx4HbupWtaJ/5ndNBaedlZugPA1ZI?=
 =?us-ascii?Q?BhlQQEHblEUNuDhlRKKc0b7pFXQhMRK1ElLsKZfxiIc18c3waT+ogoxKFNL4?=
 =?us-ascii?Q?asHKoLud210pTWIX+q40VBUzEXFwDLWxCg7X9NzKowCGhGMyLZZW5MHuHZxS?=
 =?us-ascii?Q?lTfPdf4QfaRXQVVNfIRuaZxGs3DHl7r0yokZLZaMwlAIsPgJme1XIdfjJpoc?=
 =?us-ascii?Q?n2rz++Ua4028+2YaTiG3NRNaPio26qy7LWTYDqZELq7rK2MwrT2ISkqQqU5H?=
 =?us-ascii?Q?jyprqePjNWCJ+70QO1oIhrv6ABioc5wp1m/p7LWWPvC8nTqu6sEJShOM5rRU?=
 =?us-ascii?Q?UJlK/g=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4de23eb7-12fe-4e11-9111-08db50a2933d
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 May 2023 15:32:19.2049
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pi0p5ddJItV9YaOrc+qicEsZzZImP+kwNXAxzsU3SQ/zkRghKw62+fGrv5w2IW7pMuB3OQimAr3mbYPvzMvUI1FX1SEHJkwh4fM213mazTg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB5332
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 09, 2023 at 10:27:28AM +0800, Jiawen Wu wrote:
> In order for I2C to be able to work in standard mode, register a fixed
> rate clock for each I2C device.
> 
> Signed-off-by: Jiawen Wu <jiawenwu@trustnetic.com>

...

> @@ -70,6 +72,32 @@ static int txgbe_swnodes_register(struct txgbe *txgbe)
>  	return software_node_register_node_group(nodes->group);
>  }
>  
> +static int txgbe_clock_register(struct txgbe *txgbe)
> +{
> +	struct pci_dev *pdev = txgbe->wx->pdev;
> +	struct clk_lookup *clock;
> +	char clk_name[32];
> +	struct clk *clk;
> +
> +	snprintf(clk_name, sizeof(clk_name), "i2c_designware.%d",
> +		 (pdev->bus->number << 8) | pdev->devfn);
> +
> +	clk = clk_register_fixed_rate(NULL, clk_name, NULL, 0, 156250000);
> +	if (IS_ERR(clk))
> +		return PTR_ERR(clk);
> +
> +	clock = clkdev_create(clk, NULL, clk_name);
> +	if (!clock) {
> +		clk_unregister(clk);
> +		return PTR_ERR(clock);

Hi Jiawen,

Sorry for missing this earlier, but the above error handling doesn't seem
right.

   * This error condition is met if clock == NULL
   * So the above is returning PTR_ERR(NULL), which is a yellow flag to me.
     In any case, PTR_ERR(NULL) => 0 is returned on error.
   * The caller treats a 0 return value as success.

   Perhaps this should be: return -ENOMEM?

> +	}
> +
> +	txgbe->clk = clk;
> +	txgbe->clock = clock;
> +
> +	return 0;
> +}
> +
>  int txgbe_init_phy(struct txgbe *txgbe)
>  {
>  	int ret;
> @@ -80,10 +108,23 @@ int txgbe_init_phy(struct txgbe *txgbe)
>  		return ret;
>  	}
>  
> +	ret = txgbe_clock_register(txgbe);
> +	if (ret) {
> +		wx_err(txgbe->wx, "failed to register clock: %d\n", ret);
> +		goto err_unregister_swnode;
> +	}
> +
>  	return 0;

...


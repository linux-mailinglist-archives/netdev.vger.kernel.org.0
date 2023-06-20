Return-Path: <netdev+bounces-12212-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 80D56736BEC
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 14:28:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A7FDF281237
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 12:28:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E751915491;
	Tue, 20 Jun 2023 12:28:37 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D17EE101FA
	for <netdev@vger.kernel.org>; Tue, 20 Jun 2023 12:28:37 +0000 (UTC)
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on20720.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e88::720])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A53211B4
	for <netdev@vger.kernel.org>; Tue, 20 Jun 2023 05:28:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JFwlGnM4xUsECuA1c/bXbAOMiAx+46bF+oEPUbGwdF7zrIvPItjfSSUrSgVuQlAYoe8upPcHjncCUNMYPR/bTU0dBKLtpfPETgFubOkp8XzwKt2sltQxd+wJ7C2Skbk9RaH1J+CXEvCwuxJR8U/97ltQWSavtNYEVncEEoX7hCFkwvS0/kx2F5OIXR2p6aF+MX5bB44omApAE3p7c6PP+l2ra2wd+thjgIOgld++HJsgJ5x+EMaes2MEY3vQldR4SQWjUC/N/qLZ/BDNatNJuLMBdJ6K17rcHX85OaG9XD8MtCHyS0Oud0c30sJty2cZfx7hA9NzSl/XCyXCp1dSfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yJQRbLt8xS/Q6trKcI/CswyaTgatAiEHkReUafDk4Zw=;
 b=SUvQUbcKz2PH0EFxKJo4y3aHzztvTUgrW7YQC/9Q4S3WegnJ2YJTedNSmGBA0NEVlUxKGa0inxkyJj/BH+wDSKb3DslggS2Jed75dKY4eHqx4pMQUz2/517KfCVXSzv6VxS6A3ilAbfdoOYMziAP6fC8wIWgnMGPNexMoHDE9/T7WUMQzLcXkpQLfiKP+VxURHe9qUFmABJ4dS3nvn8LZDtYWU6NQCcKW+f5G5Qt0BMcl3D73Y1xsFFFuZS+n3ByAbmuOsPjhJJnnHnu2byyS4GwGa2FV6hJdG48JzvEYxJb9rSKjYGG95mfrj7zNX+z3J2pKA8+xSbuOgXMbJUk8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yJQRbLt8xS/Q6trKcI/CswyaTgatAiEHkReUafDk4Zw=;
 b=d1lWUKdA/Cn0Ee0bYZs35NuyiUZ6vPtl0agt2JqTddE3d6DHOFvPqtIY22jHVpYUw7dl/zM9z3uZL02gKMjANEAHHzD/gqHdXn7j4A9rhqWTFLv6LyyE7xFRxGyA+fxsiD4ifMo5wztvyxK4w9WJ5jffZXN/uKXXibnFdFModVc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SA3PR13MB6345.namprd13.prod.outlook.com (2603:10b6:806:397::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.10; Tue, 20 Jun
 2023 12:28:33 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e%5]) with mapi id 15.20.6500.036; Tue, 20 Jun 2023
 12:28:32 +0000
Date: Tue, 20 Jun 2023 14:28:25 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Zhengchao Shao <shaozhengchao@huawei.com>
Cc: netdev@vger.kernel.org, jiawenwu@trustnetic.com,
	mengyuanlou@net-swift.com, davem@davemloft.net, edumazet@google.com,
	kuba@kernel.org, pabeni@redhat.com, weiyongjun1@huawei.com,
	yuehaibing@huawei.com
Subject: Re: [PATCH net-next,v2] net: txgbe: remove unused buffer in
 txgbe_calc_eeprom_checksum
Message-ID: <ZJGbacYs+L3OFeAu@corigine.com>
References: <20230620062519.1575298-1-shaozhengchao@huawei.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230620062519.1575298-1-shaozhengchao@huawei.com>
X-ClientProxiedBy: AS4P195CA0025.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d6::20) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SA3PR13MB6345:EE_
X-MS-Office365-Filtering-Correlation-Id: 5375c9d4-d231-4c88-760a-08db7189dc69
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	l+fmSZJw8l+irdAZvG7iHgG++bwQPr/P7CbSzvpTSbxQVunAERhQ+CR9o2yDaovntP4kd5K2TrRaINyxR6FeHaRRy6gq5c7B5BoDHVLfThFMMG1F7k4tIhIGB7j696QdqfcMByS0oDEtbS/c9W0YiHsm3xi2yia+a8EbV7Ff/LV52UK54VNbHfhsxBGtTvRUvZAx9gpKjGj/A4u/KoTe2Ym9bFrifC61OLhjfIgSNRcyfbuFuVlXOnjetcz1KJ52mEFxws/DvAlmCfU3SOWJDI5j6GD6b+40oIHunDquijE5YNeRo0w3yS3LsIJNaRqTafWKm3p8aDueiSdD+icWoABPApoxCEFLuD4mW35WdQzZQ0MRMdNpkW56HAa5yroY21s5l65nNtvp2lHfmYfZfsawWeTQoEcw05LFkD79k3oojJhxuLNe04tMieEQf/2HziWqH4SIk9OYucZVY4V1EJykSedN3+7O8lNTCnIBdtCfBEXr0cXCl1I270n6RBryHfrOLSEh/74c9Y/rm3kZkphWaXl/8U0hyXV79yVlp1yZM/pWsnZ0rw9NRRW+SO3weMWfAaVwSJeyErdMKJMR2dsta2ifQe2mF4lqdsmdPglwHpzeCjUI7TWtOoqGbkleprxD4zOxLSCmL/jWieUjUg==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(366004)(346002)(136003)(376002)(39840400004)(451199021)(4326008)(8676002)(41300700001)(66476007)(86362001)(6666004)(6916009)(316002)(66556008)(6486002)(8936002)(66946007)(36756003)(7416002)(6512007)(44832011)(478600001)(2906002)(966005)(5660300002)(83380400001)(6506007)(38100700002)(186003)(4744005)(2616005)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?FPPK79r+nBQr58ivO+4ueeZvsYWd5hPWnf5baxzezf1ewtF5fkvSnVNx2gzp?=
 =?us-ascii?Q?0iSBIcCJ0vsLu59DicDYtDfU+rrrvWanHDIFUFZ1CqZMF1V4WjkG3Wt8KCfV?=
 =?us-ascii?Q?lG/ul+w9U4WYOZRTTFjeliMjHNFH/TaI4v6PNaQLuPd0q1RN04v7LqjCRsXk?=
 =?us-ascii?Q?0ZFmZWR9z78pQ/VyNAcJJTEUmUihHHSBMv6MtGqh2KjEMzWiRneNsG/jJyHw?=
 =?us-ascii?Q?Hp1O6OALGwll+3aAmSLwnfHpGHgukKqZGsvUOAWQAXT24N6jfZjz3e+BF5tl?=
 =?us-ascii?Q?RfvuEketPg7R4VbledntJMVK6MnQYXFV6pv/RMdf/9fDRtq7MGhgD+ta0txv?=
 =?us-ascii?Q?9wwA8GjQdaSmNORYXWU5KPbWMuv3svbti2unHMQGB9KcboYcJv5RLBmzPZvo?=
 =?us-ascii?Q?ZZiwVmctIVtZ/Zm2phz3Lt8AU3LLRaF309e58k214hGJnUE5IUHkQL0SW1tk?=
 =?us-ascii?Q?iOjUPtNYkWA3DyerpnKPr6/ygZEkbiOm3RrszIGDMKBvGHnY7tClLuzsgAuB?=
 =?us-ascii?Q?UW5KB4EF+dj9i5U1XnnutKb0EanC1wQsn3Wx+4b2qH8CCssWs0jPFKsJwkVW?=
 =?us-ascii?Q?6o6HgPQQkL+jOfgsqARxFgBimfY7TDjkuUy58qp5YTIjXQwJXWQD4vGEcGEl?=
 =?us-ascii?Q?5kX2MpAUZHRoOiWEPMmrkg+Luq6iRZ9UFlsSHYTjnFCIUzk4uTPYaiE9img6?=
 =?us-ascii?Q?e3UtCtL/Cuph3fHNaOYewWmnJfmHUWFxoMDaPnuIv0gPoEQPE2bT/uK/p5yd?=
 =?us-ascii?Q?sUrYh500mtELjqy2DcraZ+1Wwk1Wi9XktU1xVR1JNyF+u4NIVK2pXuxgiNwj?=
 =?us-ascii?Q?aP7gX8b5HMaiDDoMrV3zTQs4cXD2y4aKM6FotmtioPxUSQLVhDLvhUF18YV5?=
 =?us-ascii?Q?JFZvz+Mqz8LKxjZ/Natu2wfvdlw13yK4//ogpEEGyMa8I26EHKdvz2Rkfb2r?=
 =?us-ascii?Q?tMfSzvz8yJ26YR6JleBLEHxSToqe4w2jWjt3mSmsuFbZneoabU6Mmn8Z84Uk?=
 =?us-ascii?Q?JY68E9jPsiWO7wviuvey/sI023lQWK4ImHLNcMvS0Ivado8UdNLWflRZwZw1?=
 =?us-ascii?Q?7AtfzUhQJx26cAKQN9MVcLE1T9kMNST083/1h6KjyBsoDVTFrPdqHnDQSbbn?=
 =?us-ascii?Q?cHDFhPxdX1O+AY5eHyM6NidpBZkGzfFAVmqcCNUpDZcuAYBNXJDptUHfjK90?=
 =?us-ascii?Q?EmswMI3YbmM9cyoTPE+aBHa5YFFd8r/k9zX2q26aaerDruuBhthxQLMVfHt8?=
 =?us-ascii?Q?L0ETm2cHEzfEJgNuGtNzKXgigOQ2DWJbK8ClCCts7if79gZogijZ+PF2FbyW?=
 =?us-ascii?Q?0uOEJH8mUsE55q3lbAxkVdVqhmD3OsoN8jxEA4YUheH1jdVYE4ClwxQES+Dn?=
 =?us-ascii?Q?50Ql2sxChvGZ+Uz4+/k/1WZjLtRQcspjTQs6dYDjL9DcEXSKz/3l7dU48jFC?=
 =?us-ascii?Q?Lgb/Ve85dUbk3voEMjHKBuKoQWwsDEjhOsN2ep23Lm2MrwSjyfKmYz1boWpG?=
 =?us-ascii?Q?94SGDDB4ooO9GlKsuE5m+snNtM+oOuCSmmYLIp1Omx0pd8YJIZVRdQhJPCiK?=
 =?us-ascii?Q?INQ1hqlxW0QUHlj6ZsVkurKx1qKUqwWXPzUh23sYd/+HHFsZW301+43JOdZb?=
 =?us-ascii?Q?IO6wzLjxP5mqR1enBFTdICyY8AFQzUbZ+Tj6Yuda80mlIOpbG+NmxQ9YCnQJ?=
 =?us-ascii?Q?bEXLWw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5375c9d4-d231-4c88-760a-08db7189dc69
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jun 2023 12:28:32.8316
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: q4/+jQjIHzhwqwAbX4OXkZV0eCxnV5Yfts6MkBoLyaUIQ+2tkL5Br1575fMROaGxHBgdwJQI17PsihNZPDwlNt2VibmX9uhefvB3CSRZ/2Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR13MB6345
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, Jun 20, 2023 at 02:25:19PM +0800, Zhengchao Shao wrote:
> Half a year passed since commit 049fe5365324c ("net: txgbe: Add operations
> to interact with firmware") was submitted, the buffer in
> txgbe_calc_eeprom_checksum was not used. So remove it and the related
> branch codes.
> 
> Reported-by: kernel test robot <lkp@intel.com>
> Closes: https://lore.kernel.org/oe-kbuild-all/202306200242.FXsHokaJ-lkp@intel.com/
> Reviewed-by: Jiawen Wu <jiawenwu@trustnetic.com>
> Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>



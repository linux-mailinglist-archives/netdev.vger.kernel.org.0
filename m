Return-Path: <netdev+bounces-10841-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 738B37307EF
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 21:17:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 62A091C20D8F
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 19:17:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E5DAD11C82;
	Wed, 14 Jun 2023 19:17:41 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3F642EC2A
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 19:17:41 +0000 (UTC)
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2100.outbound.protection.outlook.com [40.107.236.100])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3550C2137;
	Wed, 14 Jun 2023 12:17:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l1zp3rQU/r5qw5x+Y1xFIgaws4RO6hC6fYFPKV4WFBaMz6z71ivmp3y8IfmMKeEwV1iXzJQ6qHz8XBH5O70cUDxnVqlN7x/tfRrzmwra9WR4qzujSq8a6DV34KGwYG7ubotfLybvviEWHzAAgjAbkAezWtuMhocrTRvJ4HMuMwowO0rPCQFfkxDkbiaddfrAI6KQIQnLXaUUozBiDUzOYyfJo/0eEK1Eh2bz4cGNMvjobG1qZD8In5erKJr7w8D2UcJfgw0TzMKz6AHc/HZzSizKsxIXLoGurVcSBRRseyumMY7vs7ma1s84iNq45uQhD/s72PG7xM1Zj1junQy+hg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=puxTxows1gFF2uogeohUQQjfwtiEirRAeME6nBKCmNM=;
 b=kpzri6ULeoMIJpWwxhfOLqjTgqKOqrrW603Fn0ICeqd/65E8ghcmfMUMubIm5+mCu2LtcYBYKl/9suixgDUVysDjf0Y3AtXPuOvVKjgjEhcaO3E3x6+JjY6Nn4s0XPHxTw70ndiEhtikDi3EZu/eJBR33H45nDcROr2uwZ9yuVfSb6CGphBFBidFQufLrPirg1xJSjpkB7mcRPYnIJyfMuHeiuIWPFh6KQZAorrEiz7ttPyuMHwVrNm9Kbgo82fo+jN/H3tLt1E2wnmsmJVWlBNCZl7Ooumw1dJ+DwyMabb9hHIS85f2WtQw69vCkIG2WGJVkX1FIrpJg3YAjdUnsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=puxTxows1gFF2uogeohUQQjfwtiEirRAeME6nBKCmNM=;
 b=FL2kje/uk2TYR41qKoXxG8iX4I2bEqdYHr5YdoDrWxoeD6wUZqupU8ukLbLYEq3xYM4ThT8nU2ctDUiam/tnfAzCL0Ixjy4Cqv9xKkHd2QD9VvvLEOI54KJ5Bqh0cDcSqHqxlKC39ocMXzo0NucHyGfKJanrXxWjk5adddXTtos=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MW4PR13MB5627.namprd13.prod.outlook.com (2603:10b6:303:181::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.46; Wed, 14 Jun
 2023 19:17:37 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e%4]) with mapi id 15.20.6477.028; Wed, 14 Jun 2023
 19:17:37 +0000
Date: Wed, 14 Jun 2023 21:17:30 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Christian Marangi <ansuelsmth@gmail.com>
Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Jose Abreu <joabreu@synopsys.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Maxime Coquelin <mcoquelin.stm32@gmail.com>,
	Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
	linux-stm32@st-md-mailman.stormreply.com,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	Jose Abreu <Jose.Abreu@synopsys.com>, stable@vger.kernel.org
Subject: Re: [net PATCH v2] net: ethernet: stmicro: stmmac: fix possible
 memory leak in __stmmac_open
Message-ID: <ZIoSSgNr2qus5Ok9@corigine.com>
References: <20230614091714.15912-1-ansuelsmth@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230614091714.15912-1-ansuelsmth@gmail.com>
X-ClientProxiedBy: AS4P195CA0034.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:20b:65a::22) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|MW4PR13MB5627:EE_
X-MS-Office365-Filtering-Correlation-Id: dc863c04-b0a2-4ebb-0bdc-08db6d0c0354
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	k8noXfJMPgFTVSSPwlUBNI5zoaoV61leQT9vJbIzK8sO1+Nt9olk8frUBM/PtwRyaAB5/ly9bQDAsoe8GpvmQbY/+Tl60EIbRSgBEX8LbdvREHGTKA01msWB4eHte8X0ZO8/tPkXSt0wLuGaugbrkcnZZLElcBGi8iULjm7H+uZdOA942kz2MKMyB4eSAJ17j3ch8NOlF/FXAeGFuCpnwmJubgaI9xF7zRID+0c33Z7MBb9clJKPEC9Gtd25Es9NKpxDtMMAwy099TwjFz0sawSJNYwfVDcp7NiTk+5TfuNZFyRcYXbJYsJkQWiWjWnt8Bzo5TGxGxvWCWU7IOO5p8dmyfnP/anXiUAMSVWObCNIArVX74WUrtbeERXKYED/6OOVcKBmUvxAHsOM7Mk+z+380Xy0Qh5DYpETYWeReVHgISNrGqeHDmdyX2z9y9oNL7NNIi3pCMw3RsYNJtNJzQnuZ6rmVN/fKlDUffgO4dK6qm5uLLNWdn3HUljCRf8VZGydGfRR6EllA379SzEL/27QQSAe8fMLEr+XEwN0+tv70SWjfGd86SZoASTXHYlK9ON3JIpACRqwLVnhgO5heQG1KMNCDDmXGUo9OuEeVZ4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(376002)(396003)(346002)(39840400004)(136003)(451199021)(478600001)(6916009)(6512007)(6666004)(6506007)(54906003)(2616005)(186003)(4744005)(7416002)(86362001)(44832011)(6486002)(2906002)(8676002)(8936002)(41300700001)(4326008)(38100700002)(36756003)(316002)(66476007)(66556008)(66946007)(5660300002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?J7+TYQZMcKYgp1+aiRUoDEWP/B0oUFJ9REUF9gKD9EqA1wcxQfo7fcjKleY/?=
 =?us-ascii?Q?uoT1NTfwmU2x0nyrUbZyujKMD6ZPkXIXdR4Zkq8S3i0bGqu2qYVObaEEdewL?=
 =?us-ascii?Q?H88ir2vO2uZtRhsc0LSyugtzuhjgoneAct3Nus6HVygY6wexrwclQmf9Nv+q?=
 =?us-ascii?Q?W0B0DtI8jD70ILHwxFl1Ec1zjtV8IZBS+u+HiRIUxV5AEMTJTcYaUx9Ve4bt?=
 =?us-ascii?Q?K+bPRHhXDD93l73bO1FLgk8PxgcV0NEs0MKhfAUrtbjdIm+1vd7zjIAPs6Jl?=
 =?us-ascii?Q?fl1/TFJiBcPLUemT5fSb5ITp0Hx5cMlEaYB5y4N0Pnln7/nhZO2W0z+Z1Lj2?=
 =?us-ascii?Q?lDo6gaXKMOFlv0oNA/kKbYhI5cWMy5wW2OcCdnxL7kN40LGYT5a2iIxAG1+f?=
 =?us-ascii?Q?iLXA4CH0+E0kfbk2LwLEx9INie9S5M32XYSpzrLWtTqJiJ4Rb70NBYGR4+M7?=
 =?us-ascii?Q?qZN6ijJ/OzokeUANww5WfhJ0XY1NeJ6mMfV588mqC3yX6fxHB+0Ynk+CIkeT?=
 =?us-ascii?Q?KFez1TamhKSE/cBF96ycR/EYm7ZvgWt1ptiO1CFvROUh0bauOSJRNoln/FH7?=
 =?us-ascii?Q?A62fs7JnMNGO9APseYLZozvPJ4J9t2M0rC8szJc/3hcPtwPCQ3g9400MeM48?=
 =?us-ascii?Q?FyNMdBm0QGz5LpXQfVDH9BkajxLOuUviwOoz2AbTyqkeuqp68LpQJr3cYV1S?=
 =?us-ascii?Q?9sSwoo8lGPxoudR69Je3UZ+gMSFFEPSAUIUi8u9qpZnilpSaI8OdW3BKcFBH?=
 =?us-ascii?Q?1Lp0uBJpP1hAV29WLQKKcl59BtfDnrQfXwD6feUNC4IyCrpv14pk/smqRIi9?=
 =?us-ascii?Q?7W6p6jwcNsMIAfnrFPeza5Ad10FqUOMpS9TdR5mgxhur84ZdWGVclsOwlnM0?=
 =?us-ascii?Q?+rgMrcQSlCOsho/HRDMHx/8S+94mVOknIMJlcLIw9j7Wef6F2nQiePkvwGVa?=
 =?us-ascii?Q?YLAD9xT5pbyP8kmYoIyTeshaFfGFGJ6/iBOvUPWovTNkNz4qsNVJsJqbm1YT?=
 =?us-ascii?Q?X38UIj3d5Cv8aUru7qJ0xpZL/NM6UOGyCdeILixJJsmw52uDyx/qXzi4RcGm?=
 =?us-ascii?Q?PgaUm+Z+jOLaKHLHgrvxOLQK5Vnlm4c7zwu+9bOgURW6nkp2412wNfta5Jjx?=
 =?us-ascii?Q?2Mn1U6rhrUOCi9P88GxAhlZ9CfvGqgjC1u1zXpnUZQsay/1isK3LiMp2hHKy?=
 =?us-ascii?Q?G2yiuCpaf0URCfmKAM8yLJ7HvXMTSiAiqpSzTuoHZiCO7HB++Ad1yjndBnno?=
 =?us-ascii?Q?zeibfXF4mLzqgFABEPrErdqMn6U0B5HP5p7L7lZaGsoZG/GYo1zYgI1uhd7l?=
 =?us-ascii?Q?YHWDD7PqBdmVbtPUqPeSKcs+HFr3KztMMVkfScZqILNq4Trv+g8tHyxwbi5a?=
 =?us-ascii?Q?3MWzNdqlqxkce6iMCEit4kSfBjuiDBu7oc5/n2oo03pfUE605NjI0DVRxh07?=
 =?us-ascii?Q?lxHY1xFb1fIw00fcERYklfh8oRRDDxl0mZP6TiECePYBfuBg9ypHHJm3gfrQ?=
 =?us-ascii?Q?9WYMAX5kfSvXuc3cU/p9FU2X0RF122dRoZs0USJaVtjerh4ohj+ohnuRUNfJ?=
 =?us-ascii?Q?3yHKMql2s69dJs8Npz5S0VgmiXT3kRM7C6NEoLfwF6U/DqHsy+9rYOQAdyho?=
 =?us-ascii?Q?eXouwh8CdA/TI0e8UlN8OyLWyXKLLR2KTt+nHFpsGKkE0oHNEk5swheFbwIN?=
 =?us-ascii?Q?6DOuGg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dc863c04-b0a2-4ebb-0bdc-08db6d0c0354
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jun 2023 19:17:37.0562
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KBYcj5gXgc7nQ1IR+lbB7ztL/emgYFg959xA+UAtA59gCeJVonj72T1yNJRw0EQbuZHByUcx/EROg35STIBIcRIszSdFoEEaFuVNMb0PYGE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR13MB5627
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, Jun 14, 2023 at 11:17:14AM +0200, Christian Marangi wrote:
> Fix a possible memory leak in __stmmac_open when stmmac_init_phy fails.
> It's also needed to free everything allocated by stmmac_setup_dma_desc
> and not just the dma_conf struct.
> 
> Drop free_dma_desc_resources from __stmmac_open and correctly call
> free_dma_desc_resources on each user of __stmmac_open on error.
> 
> Reported-by: Jose Abreu <Jose.Abreu@synopsys.com>
> Fixes: ba39b344e924 ("net: ethernet: stmicro: stmmac: generate stmmac dma conf before open")
> Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
> Cc: stable@vger.kernel.org

Reviewed-by: Simon Horman <simon.horman@corigine.com>



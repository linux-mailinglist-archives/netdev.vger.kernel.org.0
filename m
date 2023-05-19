Return-Path: <netdev+bounces-3905-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id ECF14709812
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 15:17:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7DE151C212D1
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 13:17:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F5B6C2D4;
	Fri, 19 May 2023 13:17:45 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A8867C
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 13:17:45 +0000 (UTC)
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2118.outbound.protection.outlook.com [40.107.96.118])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E09C7134;
	Fri, 19 May 2023 06:17:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eWY4CoUiKInQiJEW1m3jP8FdfMO4v86pzRxB9KOdL2Hv7fdpH1JMLTuAcIDF6JGsPy3Jxc2rQkQe71/RQbxQOi1inDU6TyHgI8Ml9UJJHfICvAR4pmEMFFmqpDraEA1nnXdiaXWgnQt0Evo+xN+xVraDiyjYa0vpCjjjFUzvFX//4qPGjBvwt8ImvLMyKg4e6MC/JbyEAtSvZvpW1XiGMWsXmTsRx90RydrQsdSPaverRtclmvswsKp8v6RkcCA7PP85X0m9IHkZ7KZJdJogmmvThLNTPmTBO30Cm6/KC4+J3tz8uMHpRV29cEwTwWR+3/xjBmOtqXJmpJ6YdM/gNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uflacbdZQ6gMgM1UqyxZNBLI8r7F5AL2cLmJtFwxV/w=;
 b=k2al0W6kDL3vR91LycGWWBQQBFxOfy/DA0XEeUm7mWMYl1GFUD+lLfON7Md1H4VVqOGDJg2+DZwZxFI3Gh2elG6PHBSMB2chPmGo6dMNbUlTvLWStB1jRZe8U8KYqx/kHtEKzPb6nz/LVudInog9E7luUEnRhoztLnnr5Edy9FpOL9+gaB8A5rGrg1pGz0we6qBLiSZHaDy6IBWPxOzcAU2PKHIBh2M8qbhIXSfBNzYuUhoWhOdy27NCl8gmkk20gS0/C2Z/y8dBT6oeKtHtwDQ49kSlVX9xfr/qyElOxpryMHYtEXolvY74DHP+/l5kSkJ0TZ/JFAfZc44jEaVFMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uflacbdZQ6gMgM1UqyxZNBLI8r7F5AL2cLmJtFwxV/w=;
 b=PkkFWBBVP72He8DRU6UpzFBIPHplFNNvIMiBkCSZvHSIJiiDc5Ie1tPeN98GSahuJAmH+8rLwqidHKgxWA3jmBinOIE7C3pZ8qU2nFYSiot7fuDqtTtFxZC3RNetCwAyVrjnk9AGDLjNH9x/Ahev5MJXNPFqf2IqkC+hNLpw2Jk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SA1PR13MB5537.namprd13.prod.outlook.com (2603:10b6:806:230::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.17; Fri, 19 May
 2023 13:17:41 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6411.021; Fri, 19 May 2023
 13:17:41 +0000
Date: Fri, 19 May 2023 15:17:34 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Min-Hua Chen <minhuadotchen@gmail.com>
Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Jose Abreu <joabreu@synopsys.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Maxime Coquelin <mcoquelin.stm32@gmail.com>, netdev@vger.kernel.org,
	linux-stm32@st-md-mailman.stormreply.com,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] net: stmmac: compare p->des0 and p->des1 with __le32
 type values
Message-ID: <ZGd27iXZnqm/f96r@corigine.com>
References: <20230519115030.74493-1-minhuadotchen@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230519115030.74493-1-minhuadotchen@gmail.com>
X-ClientProxiedBy: AS4P189CA0029.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:20b:5db::20) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SA1PR13MB5537:EE_
X-MS-Office365-Filtering-Correlation-Id: 788da2f2-4388-4669-8c74-08db586b6cbf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	5h2AdjGM+ORJFZL4RXFe+T84I5eUqWtJ3dVkBmhbBl2/kB9TpGE9TXw10VGoQA8Q+sM9Rbzy1qEsxSpijcDoPLffoYV7A9byC2lqYNeSDERqSIBZT2MIwRmA28Q1Sg1Yh738ufUzDDlImGT+ZCL3X1U9KgIgiFWAvm3uo2ouIhxrx5AqW6Ew/GaNM4PCbqfaVAYt8kpXgw7SvcfBEKxjhgRjkMs4SmSEyI6rX/ABRbKmjiRdw9s9GJjTcr5orE6szu0aoR9e+2KalNJMIhNnKh8omDEWA7sNvmLVMBMCv27ajUSMGQzqcgrZ8kfQNZ4vVOzYxQbv6P1qlHv6OZKgx5+nAatr0KcZXISWlkOIStxilHSS8btqm/wNx5CfKVrf6Yw0RbD+tysEC9GEXe1sM2vXy12tVZHFLfkP/I81M5XBReUtz4/TE0IcwqpBgr1eVXs8hbY+aLsTuQTkuWp0ncNvXx/TQ3HWdXs8ZczSyDJOmh6wsaHQOPA/ecK00gak8f1zUfWogyJBDDT2+iO2DDASV5e32KXqeIJ1J1AE2oE99qOqP4t3DXJulG/6UHpN
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39840400004)(376002)(396003)(366004)(136003)(346002)(451199021)(38100700002)(7416002)(41300700001)(5660300002)(36756003)(8676002)(2906002)(6916009)(8936002)(4744005)(4326008)(316002)(86362001)(66556008)(66476007)(66946007)(966005)(186003)(44832011)(2616005)(6506007)(83380400001)(6512007)(478600001)(6666004)(6486002)(54906003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?zKzxmENcOQoCFnwPIIdBFdy5R6ewRTKjT6115sBr2cGhHVGSmfRkMxobkvPV?=
 =?us-ascii?Q?NncE6lx4bac118K4bBTZGSbT18W+1YZXZj2L/3JMlnmEGe/z5KvH3KZfN/+6?=
 =?us-ascii?Q?1dsHxUCTZloQseIbE4R5qXebpc0iWF8fttsxsqb9YVvi6SDuoXLSwQP3is63?=
 =?us-ascii?Q?QTehmdjGYQax2y5f3u40ng4t4cxCfi7NfPGyiUYg5Y1O8CRH/RcrQ5CoTkOV?=
 =?us-ascii?Q?vhV9Je+0NCep7sT9tiKPx29E7RrI4+lz8T1JyotDJGK+fi4nFzSyhSMWAXgy?=
 =?us-ascii?Q?SYEguEY8yyeXNHpHcoZkhHIze9znYYvNzDbQMg9FVaYhotEbSDbu1cYny4wQ?=
 =?us-ascii?Q?3MnZlyxevmzEfRnVglqklHurC7EwjVtHzi0DE6FNxgOagoc4h73lEkT5B4gc?=
 =?us-ascii?Q?7PZ5YRAagsdgpmYP4jyBSVB5OCDRYRSXrWNz1oTfd4K/nPbWcbEbVWINULku?=
 =?us-ascii?Q?XTffPJSAgRSd/ruQYGdJ7d7EV4ctvwLdDhO3CrR6QzHn+WgGX52/GDpLZli7?=
 =?us-ascii?Q?QhkCJtR78+qNHRI5VvIznleTuwswdaON5eAhL1HYF4UREnVaVThOLhoMuhc5?=
 =?us-ascii?Q?b29MZVVyHOMdQaymdQgqFORPOdDY0cy1C8dOOCsBEkUa+/GSaJcL9iX8aoKm?=
 =?us-ascii?Q?oy5ykYUAEjT1iqlUowKanXgB5ysDz4OIa2HYgeyAkjH2mOpDmJz6UZTOVr3k?=
 =?us-ascii?Q?mEHk+85GudFB2DHBS/XgToM8KdpcLcMMaRkPWZlb0u+6pKz9jNt0b4LNR/CX?=
 =?us-ascii?Q?vErGCNtS7+DkpF0k+7jOpW3oZewflUEPKZ4GQhN5DJC1n0UiwYmlheRBdhJW?=
 =?us-ascii?Q?MMEKPMfremonmzU9XazzU9oRmW33rWu/G+NDbXlGUpRMK0FumQvCAInve9hm?=
 =?us-ascii?Q?Mexhat/enuLOawNirEEjb7xm/1wWKphn72CChtyHN1kZ1Q52PTK6LYqTV+r7?=
 =?us-ascii?Q?1ZgjXQAPXsw9RK3sXrs3G6oxEMpAyxvfn8O4/ZNE89g44gFtcTJy3vJGoXqc?=
 =?us-ascii?Q?O6QSxdTDh5M4XtPeSvp3NB2XEM5rAnWy/47nzO6WRbfaSgHusN5+Rec0Xm8K?=
 =?us-ascii?Q?MGRwHjcyhHldvoRvpTx2OXDgVy2z/HpyTtW6djFvM3kN96K1P9XFdymi8QRw?=
 =?us-ascii?Q?uvoEC/H1zzzJulKnty2XcojhY0d3ZcaO1qzNcTG84+KZyNgc3TUcfTWXULeQ?=
 =?us-ascii?Q?ckqf+iWRlUxx9oldlZ4Lk5Rlop+SLuNtraUefTZoIRRDzmqKhmBZYXhEpWTY?=
 =?us-ascii?Q?G81vgqwchLUW9zBJ7DIk5KhVxMo38AiF0omutBgnYagzS1WrpxnqHV9mSnGh?=
 =?us-ascii?Q?lTOv8vxzUoNXyNvr9Q+EKqT72FNcqtK1jZgaMLP5rSoB9zdi2FQlgGBOxgEN?=
 =?us-ascii?Q?YzQHNvShNTrWxUGCnSNZQKJKB6+1rgwWqSjzuNeq8sRtybBOulLyaAEJVKdy?=
 =?us-ascii?Q?GTzCVzrlgevI+NwARSE/ED9BK2yjTYHbdSZ/k9CmAfg2dO/SZHqiJr2AtGWP?=
 =?us-ascii?Q?WrGaGMARqHcd72qQh8qTiCkEeyGWxoc9DHg6Es5wjQZN5FGz33dij7lzyxch?=
 =?us-ascii?Q?sS+X5j7FznA6ODGTutaBeD/LQ+0kXgJxhEdiwO19ybmdc2lo/ER/o94OpzgZ?=
 =?us-ascii?Q?ZcMzIYrr78JMLVi2FA134UFx414H5fFgUZEcIels399d4pwt5AKY7ygFI2Io?=
 =?us-ascii?Q?F7JeXQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 788da2f2-4388-4669-8c74-08db586b6cbf
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 May 2023 13:17:41.3198
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oPvC3LY9O1YkGxw3ZuM/LehVKdCzpEjxqCgFnrOZmmjArP8pPqXbB5hCg10jPrCA+Q2yCeBGx7MiXjWBZ9GAJEeas6qnsJ5cPMq/Hcz4kHM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR13MB5537
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, May 19, 2023 at 07:50:28PM +0800, Min-Hua Chen wrote:
> [You don't often get email from minhuadotchen@gmail.com. Learn why this is important at https://aka.ms/LearnAboutSenderIdentification ]
> 
> Use cpu_to_le32 to convert the constants to __le32 type
> before comparing them with p->des0 and p->des1 (they are __le32 type)
> and to fix following sparse warnings:
> 
> drivers/net/ethernet/stmicro/stmmac/dwxgmac2_descs.c:110:23: sparse: warning: restricted __le32 degrades to integer
> drivers/net/ethernet/stmicro/stmmac/dwxgmac2_descs.c:110:50: sparse: warning: restricted __le32 degrades to integer
> 
> Reviewed-by: Simon Horman <simon.horman@corigine.com>
> Signed-off-by: Min-Hua Chen <minhuadotchen@gmail.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>



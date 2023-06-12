Return-Path: <netdev+bounces-10005-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BCA5672BA23
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 10:20:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1E6782810FD
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 08:20:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 40307FBFC;
	Mon, 12 Jun 2023 08:20:41 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BFB2C8D8
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 08:20:40 +0000 (UTC)
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2069.outbound.protection.outlook.com [40.107.100.69])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 949FEE41
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 01:20:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MOTux0h2ryjoJK7rRmTGIponYOwjA9tFOvtQMRhLiFM/j2nXONvKdwyuG48rIlLXsPxswaZZNLLfiWYNjgXCLVPLd0m1PFqZgi+2LTpAoNJHFfiEqIDxYfK8wIdD+gVR/0fSbBllUZ0TlGp4kBPVyB5CvfX/MThLdezAPKgkEWzhsUj0HqmU4dfKkYpwndnMjn+SWIxOmtxfPiO73wbwxvUSBkC4CJnjN9XHyJazw4UGZZe7KuXLLWPQTW/9xJHXEDdkzgbREUzKhQnD2IDp1TLE19sRZVXfBvgDyULwQXd6L3632YVSsq624otQhSYFRljsH5Q9xv/XvVGevX+4Rw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jrNDF7ySgMvXeR0zG0J7aizqlscZhFA3iVQYPKqFdXk=;
 b=EqTXyphbxUDCSsyICLKb7ioECFpNNFkltVxw8tm25nUm4eBgLnYBwXKfUVwguFD9pHFx4E+Irx0d2wNV5rTDNrdmqf6FZS+V/vo/A2CIDV0r3UyfeRPhqBUIIiuYPY6CCNRkm61jOnnHqO7I3q86QG8fCKZh7cp6BdiVVDOCV/R5fMB1rm0gp1LAfwNdvFgA4SV4rqGB4AOB/8SBLqpJnq4lpyMbkpgRX9iLAh0o9n8/bWgXuZ1SEnIEuqa/auYo33FiUG/GkHYCNE6MfYm1nwIhIZ0wXeooos8cRzuFamwMDanzZZnEGlvrl7LrqRbrhIah2pkYLOIaQNFcz40Bfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jrNDF7ySgMvXeR0zG0J7aizqlscZhFA3iVQYPKqFdXk=;
 b=XcZ/EdPLdkqLIDu7gBbt61LnkUenzWbEpqVdrziLIJCHj940ugZfpzxc1FJ6YrhsaZGo3j6+g5MpcBGhTGtuiW2e4jRFVVB6daa8bb/LApmhLZGr2oCb3Xd3688OLRDnynOT/ZVvj08cTajy0xT7gYdV3Aayi9+wkyrJQkNlsX50Fsl9piDb568lnU3QVH5mhxCyIdfFgqDF0qSPjbQm/LcqkXSLE5V/a1H3IRUyGYraOUL+0IX6oNexydx+TyREKV2QfpZkuYgy96y3B32opaQJlrSqVaB135i9S5NOZFkuZFNfBl0U3WowHdMlF+XoQ+VtH0B37YG47jmjMhMgsA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by CO6PR12MB5394.namprd12.prod.outlook.com (2603:10b6:5:35f::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.46; Mon, 12 Jun
 2023 08:20:37 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::66d8:40d2:14ed:7697]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::66d8:40d2:14ed:7697%5]) with mapi id 15.20.6455.030; Mon, 12 Jun 2023
 08:20:37 +0000
Date: Mon, 12 Jun 2023 11:20:31 +0300
From: Ido Schimmel <idosch@nvidia.com>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <u.kleine-koenig@pengutronix.de>
Cc: Petr Machata <petrm@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	netdev@vger.kernel.org, kernel@pengutronix.de, vadimp@nvidia.com
Subject: Re: [PATCH] net: mlxsw: i2c: Switch back to use struct i2c_driver's
 .probe()
Message-ID: <ZIbVT+1PgXtElVs3@shredder>
References: <20230612072222.839292-1-u.kleine-koenig@pengutronix.de>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230612072222.839292-1-u.kleine-koenig@pengutronix.de>
X-ClientProxiedBy: LO2P123CA0066.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1::30) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|CO6PR12MB5394:EE_
X-MS-Office365-Filtering-Correlation-Id: e9d0e23e-1087-44ce-689e-08db6b1de69d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	wBo5wC8Ha7ilCEGkwLvcph7IVDD2zWPkCKulHUWDI/sMkKlhdtRaaWTWBvJvHjkABYrA5q0leg6z1zPt8KRNymojq5w+HjtohOgMLRlWgdWtZk8OoNiFQeTLKI+ntWEIakZ7/s8LnTi7X3Pb078udydRgK9cxC+b8IeXLt0SIWRQ3SiHUucGBt7UeoZ2+km8M4jp1BhuyH2nAGKscpmcPzoaL+LMF2wO7fGQ1PTGde4jEkfosMFELCKSXE2zpWA4FEK+ZO3eegLe2TCgIaIDgH2VKlXeTl7jPPYJdmnughhckGXnpGUvYoC1GSedRLp6XHWsQKBuiwew38r5IKBEAXRavho4XfdX/T2/5suVVuGfkWDT2vR1uihZveMQ6cvswl3zzg74i+rxxxkK2Z727h5qCzrFLzPrezy1noeWRzeUsdL1r7Thecpq5mjR1tFu6vWXRyhM6hlKV9DyxLrnhTXRPDTkH29K1+3udY77K5PdCMnip8aD99BfbLEn5Wpsj7nlWcqJNBpyq+nql8Itin+RjnoqhNeAAuFCpR6Qdnbtgq6pMMZPMHq4NeinmrURKwpVbb0GRegai93qXFEh38lQ38EO9/YaxjsJuqXuIxQcjrfqUUGmIePQcx9AtbGdRIsKJxCeKrsy16aJxPpdYQ==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(7916004)(39860400002)(366004)(396003)(376002)(346002)(136003)(451199021)(66574015)(186003)(9686003)(6512007)(6506007)(26005)(38100700002)(33716001)(86362001)(107886003)(83380400001)(2906002)(41300700001)(6666004)(316002)(6486002)(54906003)(4326008)(66476007)(66556008)(66946007)(6916009)(478600001)(8936002)(8676002)(5660300002)(142923001)(67856001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?iso-8859-1?Q?dKBxoHWZUsmKPEowRPUAx5trZddbeJGHsyhm+ghiwxgduqjdbp67sgJ19I?=
 =?iso-8859-1?Q?tpa+3y3qgMEPMf1D9rr3AEd7ssWrBmQQwfPgFMyIeR5X2Ih8Fkni88+SOa?=
 =?iso-8859-1?Q?NXdOr3DPIlZKDDxRjjRFMdsaOp6LNFt3EEn4N7XoxrSEIL96h7r1BD6E3M?=
 =?iso-8859-1?Q?8R1XPJTVEmBWNRpdSsazJkWWhdC+m4MlL+MnkF6zz5SqpobmzOAFXy2gA/?=
 =?iso-8859-1?Q?5oDzx3M0vFEFrvc3CH0mr9Vk+3oj25qFxRsRyNP6nmDwJ6pD7+70eN+RHW?=
 =?iso-8859-1?Q?BtdFqfxJ8lzabQF3y4a+1vTOn6y3i1lMFr7YWnoug3Xu9vdE9touHdjIBv?=
 =?iso-8859-1?Q?ELlO4ltKZqfH0V9OAME/6rsuz33tNCyE8+lYJWcp1BSw+PXfuxbau5csiU?=
 =?iso-8859-1?Q?6dIWJWksnuevZOOKqbQPQJNymWAILQU03oLPAstbBDu7Zgom9fywTfv495?=
 =?iso-8859-1?Q?iHEYrYVahanozkbfwamPJWyfjD5stz639Dbo0OAPRwYwsqF7ma36Nf3H+J?=
 =?iso-8859-1?Q?S2+8E5Tmc4js+Yb/U0JW6XRWtBO/YQp1S7EJpNit4WaQt+yJlwfHYNMZnb?=
 =?iso-8859-1?Q?jAvCd72+Yy8uygfsL70C6DH8rnt3GZ/lwBbi56P61r53YK3IxpXyBaCenJ?=
 =?iso-8859-1?Q?CoCPMtzDea1dfJeU525yInqGDKiuRiDgWost8nM0x1SzY/6vWqznyt4j1n?=
 =?iso-8859-1?Q?ToFrmmIEf/pUsrgVXL+caWxR6anJ+J/DubBTMaEpykTP1GrhpavFjisqQz?=
 =?iso-8859-1?Q?mNPorOI8w3sRVApk9O1TWAr+B1aT7jjrfZ+3gJTq9yJQy1IwcNvtqwjIMD?=
 =?iso-8859-1?Q?gR1CwP44NiX26RU3bV9OkciWa4pzeyxaAjlU96qQIxb9Ce+QtOuDphrp8Q?=
 =?iso-8859-1?Q?452iV8uWOpmlws80W/PTjPEOFi3H80dggD9AaPppNNVWMCNZ14DYQBt/cV?=
 =?iso-8859-1?Q?AeokI5z3iI8cdRaMVu5oq+JnAKu9EHsqfpWVTVDKEDMFoAJ8CP4hSo6C/H?=
 =?iso-8859-1?Q?9HHMGtzJ/+HG75o9Zh8z2ktDp62eYMrTvEN2/HrWnkOMEhJ894MkJPTPkO?=
 =?iso-8859-1?Q?/bappw7y/1BpINpP+WRsmeyjEKYUZuBRU/y73Ro8mBBGprc49aVcnAZENF?=
 =?iso-8859-1?Q?LrOdH9585b5xrQ7a1XoFNNmJ1JmXscv2xiCzxO3GPnjt7TFkXCx32O28x0?=
 =?iso-8859-1?Q?dyhzUoi93Rk/18Vk6gpVe4zYIwP+yPNTJ/giceMwPF0ZtfAtjRp80xMdZV?=
 =?iso-8859-1?Q?KH9+vnUI/HA9y51h0j3Dx7gi8kE/5R5U9ShLC0U+eaa+j4CDt9k8q9vW8l?=
 =?iso-8859-1?Q?S2QvKPYO28V/Q4amJVF5v2DrhgzQJPcsjDYpYcF4IX/u/iBbXogDNwfoK5?=
 =?iso-8859-1?Q?Pji8qxRkrXUj/BZkoGEoV/fsTPYLhtwnSl1b/Oiabn835/xd92x7d54ZPf?=
 =?iso-8859-1?Q?SdfvINXaUF/vlzmbpWnuCeetUwZwdCJEdqIEilNyB7TSSkoDUdAKoOYbjn?=
 =?iso-8859-1?Q?o75VSAgbvdJKVEHsvWiVY29QcL8GL/SP/LbGdzA1Y77hA0KnMSOWQJwcrZ?=
 =?iso-8859-1?Q?Ck+h+TdUlMVffrlqwQgCrgJ+kwrHqiCTvOXkK8itehAxWNoKrsD+NmlWsd?=
 =?iso-8859-1?Q?PgVThQPOHAb/0zuTXzOwD2Gubjv2FGRC8A?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e9d0e23e-1087-44ce-689e-08db6b1de69d
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jun 2023 08:20:37.1790
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xGAtiCU5IxlRTv6ZUbORmiMbCb+Dfg5fr+bl/PDHdqcsS10LOAuY5X2sZaIxf+euiHE/PfrHl9NHaDz7LP0qLg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR12MB5394
X-Spam-Status: No, score=-0.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,FORGED_SPF_HELO,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
	SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, Jun 12, 2023 at 09:22:22AM +0200, Uwe Kleine-König wrote:
> After commit b8a1a4cd5a98 ("i2c: Provide a temporary .probe_new()
> call-back type"), all drivers being converted to .probe_new() and then
> commit 03c835f498b5 ("i2c: Switch .probe() to not take an id parameter")
> convert back to (the new) .probe() to be able to eventually drop
> .probe_new() from struct i2c_driver.
> 
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Tested-by: Ido Schimmel <idosch@nvidia.com>

I assume it's intended for net-next.

> ---
>  drivers/net/ethernet/mellanox/mlxsw/i2c.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlxsw/i2c.c b/drivers/net/ethernet/mellanox/mlxsw/i2c.c
> index 2c586c2308ae..41298835a11e 100644
> --- a/drivers/net/ethernet/mellanox/mlxsw/i2c.c
> +++ b/drivers/net/ethernet/mellanox/mlxsw/i2c.c
> @@ -751,7 +751,7 @@ static void mlxsw_i2c_remove(struct i2c_client *client)
>  
>  int mlxsw_i2c_driver_register(struct i2c_driver *i2c_driver)
>  {
> -	i2c_driver->probe_new = mlxsw_i2c_probe;
> +	i2c_driver->probe = mlxsw_i2c_probe;
>  	i2c_driver->remove = mlxsw_i2c_remove;
>  	return i2c_add_driver(i2c_driver);
>  }
> 
> base-commit: ac9a78681b921877518763ba0e89202254349d1b
> -- 
> 2.39.2
> 


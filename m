Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B996B40869D
	for <lists+netdev@lfdr.de>; Mon, 13 Sep 2021 10:32:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238171AbhIMIdE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Sep 2021 04:33:04 -0400
Received: from mail-dm6nam11on2106.outbound.protection.outlook.com ([40.107.223.106]:5601
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238152AbhIMIcs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Sep 2021 04:32:48 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cDYqUBH5dYYKHAodg6tMdGXR83GrIt1iTbaNCVI96Pdh/yaGWAhwK8ZRE6DQLVtrL88OpJFWb9icfn7Uljwx2GlDuhx50dja1pJ1ATLOWLYfC3MZ40y11m5ap9IU8b9dQvpX5ElU9AKyHhLgW3cnlzSQrpOYcGOeuDzHNsELttF6O6h2nSdm+X5QwAI9P713Rt96hPbnBETfI5MyvIFaPX/fKuA+EM4Bfpx30mjQ5MoMFLWKb9ACpu6RIYBtcxkTTkHG9n+SzEZUrrvGwhqjdiUiIqHmJmAldx1S3BQTm3cBI71/LwuEXcyPQ9Q/OSxkR1hkxNES4qF56zC6dyvyPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=3pw8PRHgYZSWyr4uqLGmozteCtT2035EaAez7qeai0o=;
 b=XPNivy2cePvQ6lQDOZlDcZt1K3lyNjcEWiiPiF1C0d2Cm1H+dcZ8HGxdk5v22QmG3lS4PDH8q8o/fLfk0Wbau5Fu1O4ovOOpV12KvxjgXsI0OVw+h5Ex/pi2xr8XehmRwH4H0MauiIFyzWNUNAxZk9SwdyaJkMIZQzOOgoRx3G57zXqAm6qZ/Jw3Y35Pl5yzgB4uIwRb7g60WEaFcw7D2DSlZ1uRmtLti0F7uJGDPFVOL+m7fFRAoXpPCyhqKA6i9IwNf4SCxrVSbtQJtw9nrsTLXakUOhTncW2k8WUlX9cgb6C9vCG7yHGvrRBg67n5d89BubZN//EufaCHDgQ6Qg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3pw8PRHgYZSWyr4uqLGmozteCtT2035EaAez7qeai0o=;
 b=ukP0YMkmtK9zt31gbr5nikZJquGncmU25DSo2s+Pr38zJHjUBO6bjM6962F75an5uTTS8LZDmrfsj5sCxU8iQw/SuTHm3XGmYxgv5D6anjzGDdj74kFjguyfARSG8b9H7mDW068XYgvGgqiOiY2lphBMhoohN5sX3gq5thtsSII=
Authentication-Results: gmx.com; dkim=none (message not signed)
 header.d=none;gmx.com; dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB4780.namprd13.prod.outlook.com (2603:10b6:510:79::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.10; Mon, 13 Sep
 2021 08:31:30 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::e1d9:64d0:cb4f:3e90]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::e1d9:64d0:cb4f:3e90%7]) with mapi id 15.20.4523.013; Mon, 13 Sep 2021
 08:31:30 +0000
Date:   Mon, 13 Sep 2021 10:31:25 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Len Baker <len.baker@gmx.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Kees Cook <keescook@chromium.org>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        oss-drivers@corigine.com, netdev@vger.kernel.org,
        linux-hardening@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] nfp: Prefer struct_size over open coded arithmetic
Message-ID: <20210913083124.GB30223@corigine.com>
References: <20210912131057.2285-1-len.baker@gmx.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210912131057.2285-1-len.baker@gmx.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: AM0PR03CA0103.eurprd03.prod.outlook.com
 (2603:10a6:208:69::44) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
Received: from corigine.com (2001:982:7ed1:403:201:8eff:fe22:8fea) by AM0PR03CA0103.eurprd03.prod.outlook.com (2603:10a6:208:69::44) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14 via Frontend Transport; Mon, 13 Sep 2021 08:31:28 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1c5ff7dc-5157-4631-be04-08d97690e303
X-MS-TrafficTypeDiagnostic: PH0PR13MB4780:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR13MB4780E73F5A501211D8FEB145E8D99@PH0PR13MB4780.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aVSHL+HFOozNPsVwrFGNC8gTSK8nEzMCpgAEPsS+rjkxOekL0vmgtk+Gq403zKzQYLt3uMdS36Ev0q/ZoISHWpRvKfTmNmhrcbngEUWoIwMO7lqv5Cap6Xg7oXNKvEEWWNmFwnFWNgwJyT/ntELzmlfexRTTA3j77ofY14UCqzW1BzJYChJFFbaggT7a94XzP2OWAMjsQjxNmmJh4r4BelU0KMwqL9KQ5/m/iGIWl9GudE0xkdaTKTat8Lmuj7dvALcIui8Kuyl19RVo/2BMRBIym0WGrH0rqf8Dj/rDG77WSt+q0E+fYdNOWwor/KKDc9s7IQOkgz62RQlDMhWw3VoCwUVofYy79FyGt+0eD1eMBlc5cuPeXJrky7Q/Mnu3vb1IbHUZQoobR9X7sDZFizbqRAm/RQgTnBblHyeT5JD5F+WZaEBEFV+k8W6VXV+XUaRdjLNF00iPZxOM+9jlASp29UfpoXF+YtJoG6NGFQoIA1JflAgoVe1+FLU++y2gkrtWy3QpPXKMvNIeheNzk/bc33FAKZH6be2CwHfNpHDUt6sjDSqpfg5C/tWjMLn79mFQpVTov+Tz7DX/pooqnX9Tc2MN2kcCniL319ZWXmbG+MGBGbAat51U8IF3JjJvTlDHyCK9GaFjI5RuocHVYoY2nyBnjtBxCrw5p63BGkAGFJEtkooKzRSEWHfkIU0/J02+pVVs7SsjKKkCfJ0sJyJKA0nrwuXfqkWOhTkzb5WmzGC+fW140x8yy9ZLTyWzkZkVlsxmuDwxH3FE8Rtg32x4YLF4E4e4uoAL29f8rbE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(39830400003)(376002)(136003)(396003)(366004)(52116002)(2906002)(4326008)(316002)(6916009)(33656002)(2616005)(66476007)(66556008)(8886007)(86362001)(83380400001)(6666004)(36756003)(54906003)(1076003)(66946007)(8936002)(55016002)(38100700002)(966005)(5660300002)(7696005)(186003)(44832011)(8676002)(478600001)(518174003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?GZd69KRbXK5ZE4BSiFn7a44UZIPKIK0QNrZdFUn5d0rewOYio/TIIW3nvTMt?=
 =?us-ascii?Q?q4sG7FaGeamK34ax4M2gIRwTRWsbdtqMY4al2lzMB+sr7ri5vng+IKOlNVbJ?=
 =?us-ascii?Q?UhvvUlQYpAXTtZI5IpB5qIeEsh0X5m4/9tuesLp0KewxAwQhXWm3vMTD12EG?=
 =?us-ascii?Q?igBoKHh+ruB91Kq8o6sAAmsFw3Iwvrjyhh66wRZNNCYT7eJyA/o5pGU88tYU?=
 =?us-ascii?Q?n2OwOZFbYj34NzolAkg///FIA1maptf9d5A26Tus3BIHypHmrTGZF/k/Hukr?=
 =?us-ascii?Q?lNjw8JRkG6p/tmQ41+wfIrepuaEfus0I0Czjd5WFTJvqcf4JhDJe0rvhqjcf?=
 =?us-ascii?Q?3Rk0/v9k/IE+g0cuDh1cUCPrcnsbvCBXpMV7JE/ogfJT4nNhzia8R6Ddi5TL?=
 =?us-ascii?Q?QYi8rACYQCzTBbzgxLtDynvezWBgRYIFPz9/S+GtlTpIabhfA3zEqNkhLaLF?=
 =?us-ascii?Q?YyZwrydTxnLCfnCtSndpP1mdDstDLu7Zwnsa4KT8+HxkWf39h6Avh1dIs77H?=
 =?us-ascii?Q?Rv+jXP8Ol6iVLFCMLw/yhVsiC8ERvPcS6kpoV3+A2j9xaclze+9Y7vUYoREF?=
 =?us-ascii?Q?fhxCO95ilZqw7NnVRIk85xzWkfhJSIffhMtXlKADbPcJTHdEhrABlruXkOxn?=
 =?us-ascii?Q?c9xseF6TDXe7gCbkFum5pg7yl5MDrGUU5KKRP8Iex9uUPdNtV5NUHDfos/zE?=
 =?us-ascii?Q?gnl87egfsN0Mwjo/d6O8gKAba5+MgqA2zZksaJxaiBInSQajZv7b5aaC/z5P?=
 =?us-ascii?Q?HPeVxQ7gstbbWh98HJ3Ps1wkvQJiUhQrX1MaY7Bo5z1QH5e7Hz78H37DpESs?=
 =?us-ascii?Q?1XmFKBUvDerESaznWnGlbbWSieofZBAz2kYEhmDosiRZ2FBcFf9UP9gCy7/9?=
 =?us-ascii?Q?JZXe83dfETS7Gfd3+ZhKAT+sN1iUbVMRoKJGtR25xWU2cMMzPkUhh/FDGjTQ?=
 =?us-ascii?Q?CJiiPttQijqJ8VctEv9q+GSl8imBEH1hj1iF9ZyJDq9ZyaoxxamqM2XAEwwP?=
 =?us-ascii?Q?gDtnSmAWVFUw1/xyMNMRgS6gKtWmo1r3nho6+w7FRmuqpPY0qKw2twmLVrS6?=
 =?us-ascii?Q?nxGxtu6VmIqYs3JMDL6dZRCXhMG+ggx9kR8ncoXE1JGIZwudVEsoGwZu+itC?=
 =?us-ascii?Q?atrFEzil/jFYV5paKDW/F7t4mQFtcc0JJE3W4UiYeCd6W+J6zYgCoS6aH8Wm?=
 =?us-ascii?Q?sE+dB/JKpD/DdgMEJN+pEQphj5itZNGWjessU57pAj4GrgGPqrawJVVT5PXF?=
 =?us-ascii?Q?Sffef97BnWlOvhmNmPA39+bPxKPwR26L4RroeC+4OlN1K+kFtMuCmXrTzPfb?=
 =?us-ascii?Q?SzYqDrCbEtiz92Tfkv5gT8aoZ2ExaGzV13F02h23fXFbJUMOMt+SpHnwavEx?=
 =?us-ascii?Q?U02XkaypcF0oeHyNK5yzDXRdwnsL?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c5ff7dc-5157-4631-be04-08d97690e303
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Sep 2021 08:31:30.6882
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: j9aKx0PsDpDLXckZLDNffHx5iQea/C6GWr8W99m2kq400VYqlDJZ7C9wgqLYmiZe/4p/G+Nb3JK4imOUHta0PTZwMPmT9Ss3C52u/+RbDaw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB4780
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Sep 12, 2021 at 03:10:57PM +0200, Len Baker wrote:
> As noted in the "Deprecated Interfaces, Language Features, Attributes,
> and Conventions" documentation [1], size calculations (especially
> multiplication) should not be performed in memory allocator (or similar)
> function arguments due to the risk of them overflowing. This could lead
> to values wrapping around and a smaller allocation being made than the
> caller was expecting. Using those allocations could lead to linear
> overflows of heap memory and other misbehaviors.
> 
> So, use the struct_size() helper to do the arithmetic instead of the
> argument "size + count * size" in the kzalloc() function.
> 
> [1] https://www.kernel.org/doc/html/v5.14/process/deprecated.html#open-coded-arithmetic-in-allocator-arguments
> 
> Signed-off-by: Len Baker <len.baker@gmx.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

> ---
>  drivers/net/ethernet/netronome/nfp/nfp_net_repr.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_repr.c b/drivers/net/ethernet/netronome/nfp/nfp_net_repr.c
> index 3b8e675087de..369f6ae700c7 100644
> --- a/drivers/net/ethernet/netronome/nfp/nfp_net_repr.c
> +++ b/drivers/net/ethernet/netronome/nfp/nfp_net_repr.c
> @@ -499,8 +499,7 @@ struct nfp_reprs *nfp_reprs_alloc(unsigned int num_reprs)
>  {
>  	struct nfp_reprs *reprs;
> 
> -	reprs = kzalloc(sizeof(*reprs) +
> -			num_reprs * sizeof(struct net_device *), GFP_KERNEL);
> +	reprs = kzalloc(struct_size(reprs, reprs, num_reprs), GFP_KERNEL);
>  	if (!reprs)
>  		return NULL;
>  	reprs->num_reprs = num_reprs;
> --
> 2.25.1
> 

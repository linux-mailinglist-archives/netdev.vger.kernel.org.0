Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B29449C531
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 09:24:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238393AbiAZIYO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 03:24:14 -0500
Received: from mail-dm6nam12on2137.outbound.protection.outlook.com ([40.107.243.137]:27361
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238378AbiAZIYN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Jan 2022 03:24:13 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y8rEUjSrjLZhUGAdWNgDfwhIJt9oiJ6+u9XMZaROyM87aqec/su0uxFmoqaBm5kVJa7BaNZrHkdlB2QorfjkPtx+6col0x80KKpNhdSHjirklmP62zDtiWHIaFZCfLKlaKf21ZTN5KegzYymgNzVOt/+a371+JfEmHL3voJJqOK1DBpTWYF3DjDMm12j50N0MIXYss7SD2jFGiByX6deQu+s4Fpbc2x4dUBb3UozRxXLQbONnmPrj20kDC9OPUhXOW5Qi/+NlorS7uMkrSOvG+8/Sd+TXu7Kt1+TAU6S3Fnj2uHiv6/fssJHgJEDJa3cPA38KDu8ynLJJPPH4vPmRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GX0N6vbMZQdrhYZw+HpqCmqFIdiSjLTHQS4EjxOg22c=;
 b=Wfi5R9ZH/uzoyGebsqjMs8e9DToAEo0qweuF5jkGOzGv3tepJy0ZxW1Fu+HGSgjoTc6HqBOkk27K+UPDl2lxgffrJMpSCcx5EjFfv/cc+dk+xHrhK1AwEXuvKBsxN5HvE1gQOQnQZf65Vbm+UsVbkTOeFwSa1Qep6K/kGJcNSCxQ00Kvx6CSg1tCWBW3W+MH3DdSFrbQ7gjb6JULr3mVrSSWzwrL3w3MedZQSqzqBljq8NIi3D+7vYqj1/EKazkyK/oPMIqwO3BD8eXV6J92Eoh03rnOmlD0aUK9IfS/bbGHxDQbwjOUr5zo7cc/rXkZJqOKn8xonrZMgKmEERO79g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GX0N6vbMZQdrhYZw+HpqCmqFIdiSjLTHQS4EjxOg22c=;
 b=t25INnG/O1pbJxXl/EMH8x2oOFubZdtCtq/B+73eBez4TP5vrx/N0ViVOsg8phWXq3QG9plpUj+646IjVrvHEroP/Jg/6qdE3aOYqA4kMfXCMRnbNpWiBDacVlR147eIPAqaDDiYFSyniK/AtOhn1VCxVKWxBDhikoJd2YcSqJU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MW4PR13MB5937.namprd13.prod.outlook.com (2603:10b6:303:1b5::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.10; Wed, 26 Jan
 2022 08:24:10 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f486:da6a:1232:9008]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f486:da6a:1232:9008%3]) with mapi id 15.20.4930.015; Wed, 26 Jan 2022
 08:24:10 +0000
Date:   Wed, 26 Jan 2022 09:24:03 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, oss-drivers@corigine.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org
Subject: Re: [PATCH][next] nfp: flower: Use struct_size() helper in kmalloc()
Message-ID: <20220126082402.GA29381@corigine.com>
References: <20220125193319.GA73108@embeddedor>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220125193319.GA73108@embeddedor>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: AM4PR05CA0010.eurprd05.prod.outlook.com (2603:10a6:205::23)
 To PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0b0199ac-085c-4356-b885-08d9e0a53a66
X-MS-TrafficTypeDiagnostic: MW4PR13MB5937:EE_
X-Microsoft-Antispam-PRVS: <MW4PR13MB5937A3699A2FD43F937DF471E8209@MW4PR13MB5937.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /1nS7fd4lAb4XMnG1c7cP24bdNpiPm/3JxjzKITxExUirQxRfWABCinmxE4pv8cHiZnXwTMJ7d0abDjXnzPPTyW+aj0Car8IFgzliTnwF5n3eiS761O/yTEH5yvPeTplA648UdqCWTGMH0vwgVkxs0WVMzReW4ahUeYXsilR4ncrj3GNzFBL4zCLhELXPeHZ8fUpvstNcMKciLpETvl8iuz3Cdtmd8+5yzZi8RYrEqn2UWLNi2GZl7VeSibVpwjg5sUGyqbwDNI2bZVBB70VymbZiNTdwK/aGmrm9OpH3fdDPvaUOlsNO7wbRVfmN9IAilhnC7ETDWAesBdg+wMvEIGqBVfJH1iiqytwDbXTU5l1zRiFpNHgf0Lm+iW+7VeNjf1RMTjI5NQP0DrQqejnwOWfmKLLh7m2+b05e9gosLTDzG5h3yf/t3hy2yM/jvqMWlx6edgVZCwECBix+hcIi9TD3bcM9eGRByZVWeZVeJohCY7M2Or3G2EMdpFQmrmbePIfY+IdeI9JcQ8WsaxQhY4xyxVmUMYYgSDbc2Q8LVtOouqUNSr5g493CDInQsguRisNrFpl8KevLcHDhwr94F0LDVYkebmcoDhvplEq7lDNi8KGsCIGekauH1AJArMXr5Ga4RrpaqTV+Gb3jztsSaG1nm6LwEEcobImtDFxp/OtJjjPz86600FVNiY6INciz+WBm+VbWUdJkB/Ivx2e3klUNDI1HzlGjCMEs5e/GFTFvQvq1/cHk6VYY1v92VtCIKFR+a1seiGLuhQDXsB0LQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(39830400003)(136003)(396003)(376002)(366004)(346002)(1076003)(2906002)(66556008)(8676002)(66946007)(36756003)(8936002)(66476007)(2616005)(44832011)(5660300002)(4326008)(38100700002)(186003)(83380400001)(6486002)(54906003)(966005)(6916009)(86362001)(316002)(6666004)(33656002)(6512007)(6506007)(508600001)(52116002)(20210929001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?0WATtZaRK0TpbS4quDs5oQOsOVMlffN3ZsFSXEybQS0EHtqChLxIvNcg4X6Y?=
 =?us-ascii?Q?K+zDJ3cDAvgm1w5PZIjBr/hu80jCim637V/6AHNW/voW6ricNKbR3d/GlzAg?=
 =?us-ascii?Q?Tkl7soWTe07faHqm92fwcO6Ko0NTsZXN0ZjlbvQg0Bz9kcn5KLN4LY3XNkgF?=
 =?us-ascii?Q?ytWYzhyDeyYG8eAK+KTjlt3A3gDlyPGb2Ofa5Gngd/IzD+0TWDMyd9sgEETx?=
 =?us-ascii?Q?uLjfo8gi9I3G/SdbKx87htcXoN07s3RF2fGB2VbhPQxJtPdD9RoXQGwPuDDr?=
 =?us-ascii?Q?CsPTHcVaf3c/4IPTtN8WU4dDsjv18crMPXFe+14a7Web6fP7ZKV18cn4EqVq?=
 =?us-ascii?Q?JzkINxeRCNmDFpDQ1zrHw9znWqxsi/rQdCQWKU+JGH2H2Aq9MjmFyIoT7sd7?=
 =?us-ascii?Q?RTnH7CHBptsFwtWUOqz9OkFTAVU0Y+lHLgk4qL1x8TF7tRI0asaY8tP7BcCI?=
 =?us-ascii?Q?IbWLfwbzdEHXqrsZMFOJ/pMHmjMA783Y17jkfc54hAWzfdxbOKgDXpFWF7LX?=
 =?us-ascii?Q?Yk/4lVnql97o/1MqaVIB3E7PNxT6klQB1ntP+Y7VJC6Wp39SXSzCiRPdZK2A?=
 =?us-ascii?Q?cyf3U85EEGLRXC1Q5egL0Ah3YsWvRhCpb+LzDHi8fewrPd1/EPM8TzrJrwZy?=
 =?us-ascii?Q?iorgzgOBhs1V8jXfRl9SAHfJiuwNQubVz8fAI+OsCh6vY7zFNVbkCBvfjm7H?=
 =?us-ascii?Q?mIPR67Ucmavh7U+83Pm06w6DwZeSPiDZb9AHx9cRZs/0bJ+79gr8jnz/3B31?=
 =?us-ascii?Q?gd3fqIX9wOp09oLi/isEio7+8vXYu/uEmEYGAAKXIZYv+U3lIYWuh31cADC6?=
 =?us-ascii?Q?QkeGrOSc9bKs1O62jpGppyADdGLDYBbtgpoUkl/IkjwMonyZixppShIRB/oa?=
 =?us-ascii?Q?NqYbhyVDWAY7ebELCwrQIRRsptAiDkxz+bTwhn62uc7BGW7kzk3thcY6Tpf/?=
 =?us-ascii?Q?jWxDSNFsWkIxagME2tOube7Sap0B9MYEIvpgGlrdysO+y3Ukc/EJbXMzXvhd?=
 =?us-ascii?Q?ObWO36vRiwSaLwy6BctwexRwznjEctkOzwhtBhFoAgj5k0HEZihR4bH/QHug?=
 =?us-ascii?Q?HOBnqIpJGrYVtDKSuxcdbGZajRAO1NTThxfn07j7IyNDe7dnMD/kLdrH31bC?=
 =?us-ascii?Q?6Qt1GTM9/Q2FYkFdSP+74dOC5S11ZzV0mZdgEGvqGuOkaqKVSpYiE1EcdmSY?=
 =?us-ascii?Q?iAJfNIc2WEPTxU4tfFGVXm9ONf7DAKoxbucqLA7Cs16W09LJrNu1AnfRH16D?=
 =?us-ascii?Q?c+r5KhXXCjDG3I5q3B5fChCoIDjTCKdMJoIk3FDTzd9WLd4eaG5LQnk9/ToL?=
 =?us-ascii?Q?GVu9GNmkm+pJFdvo5+xi42Dkc6WBEg3XcwRCyCegiZRrCE1nyyVy0z0bv7zu?=
 =?us-ascii?Q?8XwUtiyCoOCT8um+kgBhkqinRKw0RV52/nQXeYL+mOBS3exg5k2PmPpjBA4i?=
 =?us-ascii?Q?2NvjVe6XQRRDXYpH3neV6qjYtZBKp42UhgAJ8OAbk4pDk7nhNaftiRgA/zK9?=
 =?us-ascii?Q?6lYBEZ4hniqSUQMIbhwH4d9QzOhN5Xxaf+705mGjF5isDXxatFSg+IHz/BUJ?=
 =?us-ascii?Q?776wRKAVve3gJTnGllfxFp7YvlKc7TUAUl9X9RCsOOXsvnc/0DMTqhDGquIS?=
 =?us-ascii?Q?NANg8JCGpfivrjAOBaABSyQDoggb2+nVqnJ0FjwhzqRlRktmLI9BE3G05jO1?=
 =?us-ascii?Q?8KlBG0Obzj7/CnaHmKgZh9I8UAMTGW7NFgpDACF24jlPhsAYOt354/5fj7WT?=
 =?us-ascii?Q?8MrOeSr82Q=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b0199ac-085c-4356-b885-08d9e0a53a66
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2022 08:24:10.5234
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jw114JF7EZXrQakAbKU6Bj/4K/idjZxKYTxE7mi5KpSceAd9iMV4Ylkxjavbc7df7yYMdHEIV3JHq6k4M97Yn+mnnIDkqvbAc2xZlJERNmY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR13MB5937
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 25, 2022 at 01:33:19PM -0600, Gustavo A. R. Silva wrote:
> Make use of the struct_size() helper instead of an open-coded version,
> in order to avoid any potential type mistakes or integer overflows that,
> in the worst scenario, could lead to heap overflows.
> 
> Also, address the following sparse warnings:
> drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c:359:25: warning: using sizeof on a flexible structure
> 
> Link: https://github.com/KSPP/linux/issues/174
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>

Acked-by: Simon Horman <simon.horman@corigine.com>

> ---
>  drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c b/drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c
> index dfb4468fe287..ce865e619568 100644
> --- a/drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c
> +++ b/drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c
> @@ -356,7 +356,7 @@ __nfp_tun_add_route_to_cache(struct list_head *route_list,
>  			return 0;
>  		}
>  
> -	entry = kmalloc(sizeof(*entry) + add_len, GFP_ATOMIC);
> +	entry = kmalloc(struct_size(entry, ip_add, add_len), GFP_ATOMIC);
>  	if (!entry) {
>  		spin_unlock_bh(list_lock);
>  		return -ENOMEM;
> -- 
> 2.27.0
> 

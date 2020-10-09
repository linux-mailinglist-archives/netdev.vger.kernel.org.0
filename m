Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3030288618
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 11:40:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729639AbgJIJki (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 05:40:38 -0400
Received: from mail-db8eur05on2108.outbound.protection.outlook.com ([40.107.20.108]:43744
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727560AbgJIJkh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Oct 2020 05:40:37 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BgshwXa2h1yvtrxidxwXhfJgegcegKjgOByGJBaXE77PVIOCXi6AEog0h34Z/+sfCrFtVxeyq5mikCXuVO9Xx+iAglsjeRTLUcBwF4qEJeqk+RlLFsbWlxUKy5+tsc17Ud9tGW4cPfnHcyTJY3Bxka7u6nTUJ+AtVlGwq2BKJWmp/LGU+b21mR0V456eHYQzyjufgD7zKJiQ3e3eGWSI9rm9SyaGUH+jImila2qkiwX5Hk0zdw8mXjAmDcr0h3o8eLO0I1yf3A/8U7kgCj3UpBNSBCBrISjfBB19bXC5Rj0VGjOa7+pxNRauzuUZ3iYOWpDsJ+FW2N89bcai2KqMdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7nllrdx9AVbDLRlAW9VxAVjNP5H2uwZOrSWhoHlzVIE=;
 b=SAWW6BBqhEhwvqJs26949KWRzNJd3/U0d+37AUwcVI25fN7teDNfCSnSJmYLM+Vai39vLm0pikeVB30ZgghWLWgQGXIM0EWvGVVtJ6oaYhroop3faQrOm9OSIluXDM+FHCs5HKN1K/Nimj08raebgc08I4woHlMeEkgdUmKAOiUGmRpQMlFho1WcXmp41OcW4RafdhAlsccyIBsEqfZe78gO0M1F/aKPf9H/QvGT9sp70+oKwj0kBynw2T5y9Kqyfm40pWruyU1DD+j4j/V1pgTfWZ3SVM6XT73FYLi4tbhcCBDNKmyovchXUpr/yhzI8TcW8BtJkxvcHdEll5N70g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nokia.com; dmarc=pass action=none header.from=nokia.com;
 dkim=pass header.d=nokia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nokia.onmicrosoft.com;
 s=selector1-nokia-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7nllrdx9AVbDLRlAW9VxAVjNP5H2uwZOrSWhoHlzVIE=;
 b=UmOSy1Wjru38tquI/D7MoEWHOM0RI/8Aw2lRZi49KIDqaBOp9HgYCuDt4t9/l6I2leedlnykv7O3eJj0AjP/PWl+aUAAc16eci/WQwo8Mp710IeMsZ2wd+0C0/98EYUydD46wWKtEHTHc26MxApaInvWMZGYJBWkAgywqFuuu2o=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nokia.com;
Received: from AM0PR07MB4531.eurprd07.prod.outlook.com (2603:10a6:208:6e::15)
 by AM0PR07MB5556.eurprd07.prod.outlook.com (2603:10a6:208:104::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.11; Fri, 9 Oct
 2020 09:40:33 +0000
Received: from AM0PR07MB4531.eurprd07.prod.outlook.com
 ([fe80::acf4:b5f7:b3b1:b50f]) by AM0PR07MB4531.eurprd07.prod.outlook.com
 ([fe80::acf4:b5f7:b3b1:b50f%5]) with mapi id 15.20.3477.011; Fri, 9 Oct 2020
 09:40:33 +0000
Subject: Re: [PATCH] staging: octeon: repair "fixed-link" support
To:     devel@driverdev.osuosl.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        Ralf Baechle <ralf@linux-mips.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
References: <20200108160957.253567-1-alexander.sverdlin@nokia.com>
From:   Alexander Sverdlin <alexander.sverdlin@nokia.com>
Message-ID: <d86d096a-c62a-88fb-c251-6a991b26ddd8@nokia.com>
Date:   Fri, 9 Oct 2020 11:40:24 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20200108160957.253567-1-alexander.sverdlin@nokia.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [131.228.32.167]
X-ClientProxiedBy: CH2PR17CA0020.namprd17.prod.outlook.com
 (2603:10b6:610:53::30) To AM0PR07MB4531.eurprd07.prod.outlook.com
 (2603:10a6:208:6e::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ulegcpsvhp1.emea.nsn-net.net (131.228.32.167) by CH2PR17CA0020.namprd17.prod.outlook.com (2603:10b6:610:53::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.22 via Frontend Transport; Fri, 9 Oct 2020 09:40:30 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 9a84e902-4726-4fcb-47dc-08d86c375e13
X-MS-TrafficTypeDiagnostic: AM0PR07MB5556:
X-Microsoft-Antispam-PRVS: <AM0PR07MB555615D64DEFFACEC07F063D88080@AM0PR07MB5556.eurprd07.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7FSYrbBvaSlY3tQDn9KVBJaoiqYSAD2MWIb+GOqlTnwTuraKFJlqZ5VOazXD+pDqr8yiDOd/O7fpH725iBs5P6jOLBYpwI58u7am4Yk4oq5HuwkwZINbHIjAPwWZ3Gx1ZyjMCrbAzYS2f++Qyi/xacqn5Unox447wjoWW/Mbb6s2Ydto4xEeWrDGM034mMCvb2VPfGNQq0lXl7R+1DG7WAjXcHPQDUmCoDuxe+8GMmvwt3ySot+Pf658PU0lC8R/oJHEJT0QyQr1HLmuOzkWm1lgdI4dg5lQvyp+xb8glPX3fGy3i/68iao7aDqjy72vrhVBUlzmzH3CvU54Sg7mWNeYGwTdORZXB3xoJicaw73F0A3ghew3utTLscirvzJk
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR07MB4531.eurprd07.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(346002)(136003)(366004)(376002)(39860400002)(5660300002)(8936002)(6512007)(6666004)(2906002)(83380400001)(8676002)(44832011)(36756003)(26005)(31686004)(54906003)(16526019)(316002)(478600001)(6506007)(66946007)(53546011)(66556008)(4326008)(66476007)(186003)(6486002)(52116002)(2616005)(31696002)(86362001)(956004)(6916009)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: jRMpNGCRhhREXX1bVDezn/JfzssZ0Z0KMRHzWpfHHhIK/44gdsTCBK0HBbbiH9+zptSgiEh4pyM7ycoilPApvDPvDqv4/YmMXz0JKqocG0PAv3NUhCn9THPYjGYyhz/TtpRsqbLYdS6VIQlKFpV72ldZtjQ0aYRKMls8oSZss07w9kwqVmP7VKf/EwzZ9R9rQ/zo7pdGhFb7CqZa5VqCzBYQIwRwxTZOXf/rQz7RxwpKnLebYfBrnTxS6J6ScE9QFcTfDfzJFR9U0I9q4N+9fmH6j+//L7p59Xw9eN2dIgD2McPi8a1GCtetpatmVarWYn+y2RLdaWhWKz4E/529M7fw3IywcLRHdnOizE55Y0/khOR8cT5VGO9hn3yIXCd1hWL5fl+9hDPMkCEoWqLgozm+t0b3EhTziVT3DCukugfqpT1rMiA8E/Qs1544k9d1MExrZr2aCq5imM4Ssa/mAn/rHC68wE3zgGbFvB3CMX1bpqR/68cZTXGvEEbLHdo1XG7T//UYhQM9APhQwM67YicnjngAW8C2OmldoE4NCovY2E9QkYVlz3dZISIbwUEg5/m3h97hU3auDHheZwTfJdfEvONEuJZhpP4h8Zt4+D6f2fGhMPzft+z+FfED8CSUxFaiFfgGrD1XzkCR0WRBJw==
X-OriginatorOrg: nokia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a84e902-4726-4fcb-47dc-08d86c375e13
X-MS-Exchange-CrossTenant-AuthSource: AM0PR07MB4531.eurprd07.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Oct 2020 09:40:33.1537
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 5d471751-9675-428d-917b-70f44f9630b0
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: amdQx6GZYpuR/bgHZEMJVUZF48CPgLJXUm1GXbaAPu9owXNU8KBC7MApo+ECR9rHi8KHSg2D8ljrSrSo73VVd1vSHz9R7o/M6SfzTFdW6Mk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR07MB5556
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Greg, Dave and all,

the below patch is still applicable as-is, would you please re-consider it now,
as the driver has been undeleted?

On 08/01/2020 17:09, Alexander X Sverdlin wrote:
> From: Alexander Sverdlin <alexander.sverdlin@nokia.com>
> 
> The PHYs must be registered once in device probe function, not in device
> open callback because it's only possible to register them once.
> 
> Fixes: a25e278020 ("staging: octeon: support fixed-link phys")
> Signed-off-by: Alexander Sverdlin <alexander.sverdlin@nokia.com>
> ---
>  drivers/staging/octeon/ethernet-mdio.c |  6 ------
>  drivers/staging/octeon/ethernet.c      | 11 +++++++++++
>  2 files changed, 11 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/staging/octeon/ethernet-mdio.c b/drivers/staging/octeon/ethernet-mdio.c
> index c798672..d81bddf 100644
> --- a/drivers/staging/octeon/ethernet-mdio.c
> +++ b/drivers/staging/octeon/ethernet-mdio.c
> @@ -147,12 +147,6 @@ int cvm_oct_phy_setup_device(struct net_device *dev)
>  
>  	phy_node = of_parse_phandle(priv->of_node, "phy-handle", 0);
>  	if (!phy_node && of_phy_is_fixed_link(priv->of_node)) {
> -		int rc;
> -
> -		rc = of_phy_register_fixed_link(priv->of_node);
> -		if (rc)
> -			return rc;
> -
>  		phy_node = of_node_get(priv->of_node);
>  	}
>  	if (!phy_node)
> diff --git a/drivers/staging/octeon/ethernet.c b/drivers/staging/octeon/ethernet.c
> index f42c381..241a1db 100644
> --- a/drivers/staging/octeon/ethernet.c
> +++ b/drivers/staging/octeon/ethernet.c
> @@ -13,6 +13,7 @@
>  #include <linux/phy.h>
>  #include <linux/slab.h>
>  #include <linux/interrupt.h>
> +#include <linux/of_mdio.h>
>  #include <linux/of_net.h>
>  #include <linux/if_ether.h>
>  #include <linux/if_vlan.h>
> @@ -894,6 +895,16 @@ static int cvm_oct_probe(struct platform_device *pdev)
>  				break;
>  			}
>  
> +			if (priv->of_node &&
> +			    of_phy_is_fixed_link(priv->of_node)) {
> +				r = of_phy_register_fixed_link(priv->of_node);
> +				if (r) {
> +					netdev_err(dev, "Failed to register fixed link for interface %d, port %d\n",
> +						   interface, priv->ipd_port);
> +					dev->netdev_ops = NULL;
> +				}
> +			}
> +
>  			if (!dev->netdev_ops) {
>  				free_netdev(dev);
>  			} else if (register_netdev(dev) < 0) {
> 

-- 
Best regards,
Alexander Sverdlin.

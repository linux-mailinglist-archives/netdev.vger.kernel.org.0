Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F9606905E0
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 11:58:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229479AbjBIK6t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 05:58:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230223AbjBIK6V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 05:58:21 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2072e.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e8a::72e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41B824C0C6;
        Thu,  9 Feb 2023 02:57:48 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Eqf1X9X7Qcp3ofp9aK74fshc55imQVcKtbFFkb5rkIBb7tVUZJ35HTxFk3RNxWww8t8wzcCU6bRI3kHLGfRWqiRv5p2gsrBjOzOrmxAmCaI5Z/+Xt7BqUyhoNUsd9inK6PYEPWETeH16Pkhx4WWDuij8nrcawvni1WMpXx7FHghNYf11o8RLeItMNmyMpBwL0qbqsIfVRFMd5XV8xLX3e7KIIPsFjTpX+VI1PM9XEgckX+yC4Us0jVv3swo5nuVgpLrPQ4XZ1N+XW6qeRI88OLfw7A3+y5RwV3LKgvGj2iswqxIWzu4RFvSlt/Q/QFXsbeZcwy1G7q9+DVbSUGy39g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CvJ/QB9QfNvVlXpM1X0wqbR7zxcze1UE7rDljMoGq24=;
 b=ZycSEE8Jocivo0/r6qPjDNx42zHU5sT3lCb3Di9eEiRvrWZS1k7bLJxIIHkkXZF2Kxx0lrH4Z6tDipGIMKV6YsCNRA6Wgw270+bqQkCcAi2RdTyF+pWYbP5Oqzam0FxGnN4DqGPUb0b/0VKXNJk6Ca7UrfNAxZ5mScg3qQbMiVOvXVNZlHv15pWrJwKJsfcca50/xCgpU0UyFtS7Zpt/3OkA4uFT4R1fxpBgL8AT+jEKuqVRGH1q8NJcz6u5DY2V6C5F1SE+yhPuR01dvYmz8WcyDFVt/FyneA1zFDWgtvHdVsn1XcUr3PZ4a7G/3Kxpts8oNMTb6MXVaT7ekpEYQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CvJ/QB9QfNvVlXpM1X0wqbR7zxcze1UE7rDljMoGq24=;
 b=ARrh5i+abRir/f888nml4FbAvmuvB115157nlVtzMhSqiI4Ho+dJw0IKd9NVjQqWvf8IoaNJFWwhTDr0RXbQlvRzo3O0fCEQiukNNwGIInWrxcBp/JC5PPVvfZC/dYfUZd7DgZBdlBblQy9Z0oalfTco4Im6ZUqvGiI/eoH0RV8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SA1PR13MB4974.namprd13.prod.outlook.com (2603:10b6:806:1ab::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.17; Thu, 9 Feb
 2023 10:57:26 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65%7]) with mapi id 15.20.6086.017; Thu, 9 Feb 2023
 10:57:26 +0000
Date:   Thu, 9 Feb 2023 11:57:19 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Oliver Graute <oliver.graute@kococonnector.com>
Cc:     andrew@lunn.ch, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH RFC] linux: net: phy: realtek: changing LED behaviour for
 RTL8211F
Message-ID: <Y+TRj2hehU76+Ytu@corigine.com>
References: <20230209094405.12462-1-oliver.graute@kococonnector.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230209094405.12462-1-oliver.graute@kococonnector.com>
X-ClientProxiedBy: AM9P250CA0024.EURP250.PROD.OUTLOOK.COM
 (2603:10a6:20b:21c::29) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SA1PR13MB4974:EE_
X-MS-Office365-Filtering-Correlation-Id: 058e1db7-53ea-4a1e-b3d8-08db0a8c6dd6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /jin8/M73PApyr6qrj49wNTIVO3lrIZIqEPEEkuy8qICcY+fXWLicKHkCxKJnpO4VA+FeKxaG6sm5YqfQ5xjfYG1HcTrnuJJ6ctuXH7HA3+P/ZIYLwSDuj/qRQZMgoh0hNgq1H4R8JF1IZ+Zjru/qAAjMvILDEfnPZgffLmvqzrYs/VVK4sBGQFJnz9LP3kS+Xvy5CoJgQBKQ+eVTma0tEHOt8vqsoBidVI8TEkwc8jSxm3URDFzRbuqMOUrxE3uR7uwiVkEgtVBN2AytUmCJlaiofkG/sHeNMDrFd8kFvFKx+pUeUE6a7ZGpUXs4+GOGe31I08/KwEKMEjq98gOCyxXvAi42AQYqG81TFX7u61bIClv8TzbL3J+lcXx/Z94AGbkMooShdewQ0dIDU+OSP06hIxAt3ufa4Cn2KQZ8lQx+tUanNa7gCmo4kKSZB8Se21Txgdz25oy9yaQzzPKuvlishrUKDgGFMW5BUU4wTXafWIYfQVMQYFqGf51e1h8qRUOqC3ZU6z4wYbna3c8Wu4x9EEqbDdn7fXi1DyaL55KL80nriRfGlHjWAyviK9hW+ka5NQrjqYhME0vvOPKaxFF/g8f8OYqGKoG5LU+35NtLRIGUyagrxvCGDWB0QxwyiBMiuthHz4pGM+D2+0H/g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(39840400004)(396003)(376002)(346002)(366004)(451199018)(66476007)(66946007)(6916009)(8676002)(4326008)(38100700002)(316002)(66556008)(54906003)(86362001)(5660300002)(7416002)(6486002)(478600001)(186003)(6506007)(44832011)(6512007)(36756003)(6666004)(2906002)(4744005)(41300700001)(8936002)(2616005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?jBYeNMFqE06phw8b5E3O+/MYRUC8VZQcJDOYbOmgiY65PEEFmy8IQGlwIt/X?=
 =?us-ascii?Q?w5wuD1jLPMi1bUNmU8fRDqyPDnKtoLh1u8GzsDZ8XSL0zlMZzN5C7ntl2/bq?=
 =?us-ascii?Q?2nbMZmHRnIY6EAt5VPyGJ8y5QZg6luX/hptYtz0mlTFI/QdfAqWg7t+pkZuP?=
 =?us-ascii?Q?qGjs4e5RUhycuLNvKaHs21+Dpb2v3rjjpnDZqGudpl6bo4TKmb20wRNShRWT?=
 =?us-ascii?Q?hj0omQ0731F+gWaBDluVOG2AxF0ZhxO+uT41hS42oGvajVtAFaooX42SOYr7?=
 =?us-ascii?Q?hUarNy91wHwdnyZWpiZzMSEu5FsA1Azi3JP0B7qPTkM0qpYFG2RyKVfMncOL?=
 =?us-ascii?Q?xy5orqFjAfpcWMUtUEFPQMXBat97tFjHR5azok+UCUebT7odd8RFD+xtvJoo?=
 =?us-ascii?Q?yp+LsfLSMP5ATPakx8ERi6PE2Wk2PIt60RvUQCxLxN03eYgDN7Pupl8tOqTv?=
 =?us-ascii?Q?mZXpz4qsqA094ae3uYbQ6Mf8/T/RgLNt+pkmuyfIR32BX9//oRMlDccOWE7h?=
 =?us-ascii?Q?ZfFG81zFbkPwuqcS5ddSgqJVoW7NBg8Cad3b+SuptEW6swZXwXx0bQ+dGXHm?=
 =?us-ascii?Q?fwfjK63dm+ujgLB6GqOlyFzvFpSwFiIHIdtyAJo++5VCCUJQctIX3gvOdyLu?=
 =?us-ascii?Q?E73tcsAfp5vHhqecYci4V9L99gEu+cGDrXEMLXPZgokHbBb+E+xwx7NvryH6?=
 =?us-ascii?Q?WTnfJiQYPKPrNfrZTt4EaIYOJGEs93EjqbL0q9U2v+HRMB22tt6Nm3bZjQVN?=
 =?us-ascii?Q?ljBx+YOshSFy9FMu/fnt8gKjOg4rEgL8l36IEQ5Nl6OqvmD3r3eXX+zN5/Bs?=
 =?us-ascii?Q?2BNlXyLH7OsXYMEmSUV9NkI2XxPSkcllXj562SyOV5HvxkJCBgbcAdvO3XXh?=
 =?us-ascii?Q?wkaUeIW95gMS+lHp+HZnY537j0hl5jLxFIPzw/IMXHTxmyK5L5zrfjbCmzMs?=
 =?us-ascii?Q?c1UJpRTiYcb+/dv7dF6GeGnl6SBp9PpEEjqQ7KMgkWfJjQAIyPl47ysLqYC9?=
 =?us-ascii?Q?pW8vWZG+5OTHhdImJOWMxphX50wFad38L2s/j+zzjOI0iNOPlsdiNHnVvXHu?=
 =?us-ascii?Q?Tm8a8Ky8dslW2z13ICufvS52FzIcUCdW8fZy7yVmwqm8hLRVipMtOkm/1MSh?=
 =?us-ascii?Q?lbOvoqmPrk5drm0Nq5rdxIOOFxq+f5gYoxbVRKJBetIxA+V05XhQBppWseII?=
 =?us-ascii?Q?x61ZSA4quKIhjpYH7RYOAuBZpRcV7TDREjgu03BUcC6F6B5C0nMFo/mG+XUE?=
 =?us-ascii?Q?HllyU2JXW6nHEhdbD9Zq9/+1jGMcYJlYJXj9QIPWWp2RKnk2enYaN9Fq+92g?=
 =?us-ascii?Q?gfd6uU5nJUWA4PyBnsx6f6Hx8TlPSTMr12wLlePF+63z3Frep24lzELe9Rn0?=
 =?us-ascii?Q?ZOwlkHFm6cK9CJzMpkR0RVTPnMkmlq4l9IRR85LKidH7ZoE5P3mY+ckaNPaX?=
 =?us-ascii?Q?e6HzlUlvDdc9aN96PsX/ddm6mErQDkQZnVJRDqCbM0YpxeJi6tgmpCxLyHH/?=
 =?us-ascii?Q?jep1ZIFvkh750KP7vkwnCMOGC1WAETqSIDMbFfjzCx5ej3TZ7J8/6FqwQK76?=
 =?us-ascii?Q?yI1sRClqJOkTsYr/KQ1FKoGxjF1V1edFtgt6T2mUibOcYN3kxuAnN1HkglTU?=
 =?us-ascii?Q?Y4df1HxM0ElooY2A4JSlMdKpeFE4jhVsHxvffH83uerZo+E2EzHhJiQo1d47?=
 =?us-ascii?Q?Fjllew=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 058e1db7-53ea-4a1e-b3d8-08db0a8c6dd6
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2023 10:57:25.8962
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NPoxQpiSCS9NvqameoTNQQna2Vc0iwYOVn9261+2Vv8y00/GlGDjgpX337QNPF+djM+89NsJlCDrQHgHMLl+pI5OTbhfNRbRsijEZWdWxHA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR13MB4974
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 09, 2023 at 10:44:05AM +0100, Oliver Graute wrote:
> This enable the LEDs for network activity and 100/1000Link for the RTL8211F
> 
> Signed-off-by: Oliver Graute <oliver.graute@kococonnector.com>
> ---
>  drivers/net/phy/realtek.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/drivers/net/phy/realtek.c b/drivers/net/phy/realtek.c
> index 3d99fd6664d7..5c796883cad3 100644
> --- a/drivers/net/phy/realtek.c
> +++ b/drivers/net/phy/realtek.c
> @@ -416,6 +416,11 @@ static int rtl8211f_config_init(struct phy_device *phydev)
>  		}
>  	}
>  
> +        phy_write(phydev, RTL821x_PAGE_SELECT, 0xd04);
> +        phy_write(phydev, 0x10, 0x15B);
> +
> +        phy_write(phydev, RTL821x_PAGE_SELECT, 0x0);
> +

nit: it looks like the indentation in the new lines above should
     be using a single tab rather than 8 spaces.

>  	return genphy_soft_reset(phydev);
>  }
>  
> -- 
> 2.17.1
> 

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFDBF423AB4
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 11:40:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237914AbhJFJl5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 05:41:57 -0400
Received: from mail-eopbgr40131.outbound.protection.outlook.com ([40.107.4.131]:49710
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237676AbhJFJlz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Oct 2021 05:41:55 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DoobGiJSBWgwEh+n33nVyQz+v4DjTDt6kHcm16Gyob+Ag4un4g/KT4eYpemDf6jNtk9osDASY0tFAHcgC86YKh2GyYpDEUnI3FgNgZqgmXnhBlvFST1KFNEYsOE6yJL7VBVbzYgUtgOT1QKYGhDpEJROXVqH5Z/mY8GuTpxm6cK29YLQ+Jc/gvbysIAWqQgZjEACsoe0qtHIRNHVGI5N6QeiQQMJEyPDnbMcao2IAOqnIjr9sr4vO5ySqkqVEHmCUGq0Rkqzex0G/h9+GQjvE6qp1wtHn9RY0M8tPzg5U8m/n7YaZH/Dp7RVLSzVtetQ/cQyJqHb5ccFstUKvUM78Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nDSvDCHzZ9M5Jw7k0zGShXQU+GtLGYQgV1z9zjgV+gU=;
 b=VwXNJ6zv/Slg14mJo5lvnkDGp6R16bpWey7515UNZr5MO7FI9xUt8b1TjXh6teya/rIitESp+hKoixeFs4hvD7uQXVPXgyrZNOvTmrtPWDdhZZ+1T+yUIRS8x4yvrYIHEHZfYHAqHbUsSgK9YXXTtUX9gyUIIfPu0s2UMgMltBuzsBz8E/wvkXr66iIP7tt8z/oFrD/RWzJhJsKTf0ClDTFsUTvApAU9itcm5g1B0t3k1DLguM1xvJ3Rd/nH411EGpjEfPU1TA1bVVQzVmwGkE0wYa4HIk8jJDQJxqEeJCzxRjyJHUHKR9yZrmhv7B8zZU0TrFse9CBajPNRPdMJ4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=toradex.com; dmarc=pass action=none header.from=toradex.com;
 dkim=pass header.d=toradex.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=toradex.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nDSvDCHzZ9M5Jw7k0zGShXQU+GtLGYQgV1z9zjgV+gU=;
 b=jFWO3v6pGo3MObNjeO8iAgyZTNElW+t8LabEKkmgNMjmO7oiFvFaG//2DrcwaZiQmf35nynjNkReGmF+JNlrxncffsO/Kvj6HMJmFAZPHS2XBX3RgRxcbhjtVlCLT9lnf55qqgM/q4oyACfW+eFwxcGYKLYWdvV1GdJDqTKkDfw=
Authentication-Results: armlinux.org.uk; dkim=none (message not signed)
 header.d=none;armlinux.org.uk; dmarc=none action=none
 header.from=toradex.com;
Received: from HE1PR0501MB2602.eurprd05.prod.outlook.com (2603:10a6:3:6d::13)
 by HE1PR05MB3355.eurprd05.prod.outlook.com (2603:10a6:7:34::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.22; Wed, 6 Oct
 2021 09:39:57 +0000
Received: from HE1PR0501MB2602.eurprd05.prod.outlook.com
 ([fe80::8463:d3:5cb2:152c]) by HE1PR0501MB2602.eurprd05.prod.outlook.com
 ([fe80::8463:d3:5cb2:152c%4]) with mapi id 15.20.4566.022; Wed, 6 Oct 2021
 09:39:57 +0000
Date:   Wed, 6 Oct 2021 11:39:55 +0200
From:   Francesco Dolcini <francesco.dolcini@toradex.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     philippe.schenker@toradex.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: phy: micrel: ksz9131 led errata workaround
Message-ID: <20211006093955.GA428529@francesco-nb.int.toradex.com>
References: <20211006073755.429469-1-francesco.dolcini@toradex.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211006073755.429469-1-francesco.dolcini@toradex.com>
X-ClientProxiedBy: GV0P278CA0050.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:710:29::19) To HE1PR0501MB2602.eurprd05.prod.outlook.com
 (2603:10a6:3:6d::13)
MIME-Version: 1.0
Received: from francesco-nb.toradex.int (93.49.2.63) by GV0P278CA0050.CHEP278.PROD.OUTLOOK.COM (2603:10a6:710:29::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.14 via Frontend Transport; Wed, 6 Oct 2021 09:39:56 +0000
Received: by francesco-nb.toradex.int (Postfix, from userid 1000)       id 5644710A3887; Wed,  6 Oct 2021 11:39:55 +0200 (CEST)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bb9ed309-2549-44fa-d752-08d988ad41f1
X-MS-TrafficTypeDiagnostic: HE1PR05MB3355:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1PR05MB33550EE205D7381B733B121DE2B09@HE1PR05MB3355.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:605;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RrPX2O6H1Wj6iQrljRHt3+c64he2LnM7VYTe9RGTvZoF4ztfc2lSK8y4gCoRUNmZeII+pms1cPt+RK8cUM8AL6XReEKgOs60dx+2fIN5fyyDrY5IQh8QmrYDAjGyNTPhEJimvDIM95Iachz8L6YUSHdFMJSFGuaRGN90Lr6VhcvPouGkkO+JR84zvJmytDiIROBqwrTaUKNN1Gz9L+QZM4uBG9TeWleCOSRn37GLrXj3qp6l7Cjpn8it0Sytju69Uhl78iWuzutVkq+GLesqUADR5EawHS0bsHQDMHrNCuxnhAbICir5vZ3Nr7JpKAx6MYRJ9TRTovFPj/a/qs4Rt6+xsKX+a1Apl1luadomJ695XNmSnlqu2wUsDLPc2N5w0PTFqbZbn/be7S+vQsWUqatlijPgkZ20hNSna8WMpMChPTVviSx9uWOHjHKr7mHAayhA8qi2DhnIX8GjM8p59Yu873jkuuoOZNZumAOZxxSUPpzNFIUvLuPXt0Bj4daSQb1o0u0GAexVClWZJXvoyo7bxMS5BNTVbKM/Sgq907ZOyPBwZa7Ytd1CxCp8Z5VMumqg7UWwlnXNiOYhKARlip3xGuL4YeOJxjEMOQRS11/3TnNwZnveRTPCWOPjVaNJqgEYSVTqFfty7KIyLOnuEV9orWJ/YP1M6ZA0Tj773NKVs/BgS3KfDfUSIucUPL0tqBdVWQnEBJ8RQI6OqqigggP/huA5C/zBS7E0UpsAU8n1TN33cUwekGO0q7n0yJMj7s5kUKHakTag56t7tN1wZ8BDINit5gpj8ZayyQOoqcc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR0501MB2602.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(136003)(39840400004)(366004)(396003)(110136005)(42186006)(966005)(316002)(1076003)(38100700002)(4326008)(186003)(38350700002)(5660300002)(83380400001)(2906002)(33656002)(508600001)(86362001)(44832011)(6266002)(8936002)(26005)(66946007)(66556008)(52116002)(66476007)(8676002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ujolzAyrTdqwLNOicX1EVaywmV7+67CZA96WwIbmP210c4hYVWUi9Eo+fMH9?=
 =?us-ascii?Q?5LcbwMWFxFUsPas0imlCM/TuycfV629QbCC8qkpViriDz+Fg6eADPGfxgVp/?=
 =?us-ascii?Q?2YtfXUbGd69fbGh0hv8t3vsbng1hAPP1B9dmogP7iCpG9EJH09wGgFrD3Fkm?=
 =?us-ascii?Q?FOho5fUVfbEv+ywyuxPFETAPA9ey1SKpLlBXJdSMNFmSmUdRJGpbrKFzCNSg?=
 =?us-ascii?Q?b6OG2xwoUkSG9WzXiJ/DHZgEL3wTqTJRDWT+xGAJ03lXanEwBvkrY31pXUP/?=
 =?us-ascii?Q?bp75w6aDc2ZoI+vhruyUj6mwLBh42G07EdyMf75blSNK1vdIRPtBfxSz9LxL?=
 =?us-ascii?Q?cMKaKO/fPIP2LdEBgjjNbSpMp97mGouAp9ivF7FjsLaa6qqt0hyngVuB1PqH?=
 =?us-ascii?Q?qntRkl9u3D+ANkOt2yTdBormqKJ031hX1jBvyUYov7x/Grg3fd9zxg6LCH6m?=
 =?us-ascii?Q?0LLUY6JEXaczrSr0ZsHU8oRrVBSNz0eUG0e3Dg/T0lnUd7p4lnHkxHTSYv9G?=
 =?us-ascii?Q?sW4lRZWg1Lgxusoi7qJ68bRxsAHPeLS7SUMwoN+QrYi3sTcimoHqIeM893VH?=
 =?us-ascii?Q?P+O1WWC4SAbXs9sYFOaQ3Vym+aF/X7imutz3xTY+hpBHvJfBw5N4a3D01LHJ?=
 =?us-ascii?Q?cxG3G4u1k+vMfJ0d9J5wfUu21x22WAi/49o8mTf7ldMjUWDuZQA5CexHLMdN?=
 =?us-ascii?Q?GthjHYLmvvayiteSjS61ldvxvzI03vJ5DwtYh8yLQokvz1yZ0K0J+F+mHDT7?=
 =?us-ascii?Q?0bArwK4V/vi2jMfFa8ZCvVFhKIvUNQ3eT3b4eux3DEwbXU8qXOCoFAaoagMW?=
 =?us-ascii?Q?WApM7EjrI0jBCwhEuvq4diANDBV3CSLfc46nLZ+zywIK+x54HCAsMA0sh3tV?=
 =?us-ascii?Q?YQW2CAlHmWyUpa/7UpMhSTv3NBO8HRnS2mPPMH80oAmgaZg/+ISY4gchWuz0?=
 =?us-ascii?Q?U2gCmzBtOcw5627xxoxtuZNVBHLEmvosAO8rw8ocNnkUqMa4/nElbYgdhawN?=
 =?us-ascii?Q?Fx91aQFtiOfiK6OOlqH+/csrtYu3Z07IVxbDLK01mutwdZW+AdD9kHSX9BT8?=
 =?us-ascii?Q?dulTkDoRRKZuW4fE9HcQXdKXDPZ3R5HyynEfV5wtqXGj2HCuojeLpi4b2ILk?=
 =?us-ascii?Q?RuHi8T/eweT8rfjgcannLv+2fZ3qfiOJDkomR0hZmQfCEWe4p/CInH6CXiks?=
 =?us-ascii?Q?zruYcjm6L/mTYqfzWYMq7uDcDuH2OlDvmQpIKuTutuaJwCB8jDNPDmD9Jkmn?=
 =?us-ascii?Q?VlW1RnwIZnE9m5+rUZFoW5Q0vsDplfFZ66jmcL9KZjoD5EvSeVzi6+pFqpta?=
 =?us-ascii?Q?xMlIonAF1DnAl97bXDHibaoU?=
X-OriginatorOrg: toradex.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bb9ed309-2549-44fa-d752-08d988ad41f1
X-MS-Exchange-CrossTenant-AuthSource: HE1PR0501MB2602.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Oct 2021 09:39:56.8563
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d9995866-0d9b-4251-8315-093f062abab4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zYevCTqz4wLsTTvcn8XKwq92uXq0QqyoWILYQxlKToy8hXisYvYBE2GHixX0drzSLIGTAnT0iUD7r1STBRJVjsx9wAfi5PAobdzw6oFJ5zo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR05MB3355
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,
the link to the errata in the commit message is wrong, the correct
one is https://ww1.microchip.com/downloads/en/DeviceDoc/KSZ9131RNX-Silicon-Errata-and-Data-Sheet-Clarification-80000863B.pdf, I will fix it in the next patch version.

Francesco


On Wed, Oct 06, 2021 at 09:37:55AM +0200, Francesco Dolcini wrote:
> Micrel KSZ9131 PHY LED behavior is not correct when configured in
> Individual Mode, LED1 (Activity LED) is in the ON state when there is
> no-link.
> 
> Workaround this by setting bit 9 of register 0x1e after verifying that
> the LED configuration is Individual Mode.
> 
> This issue is described in KSZ9131RNX Silicon Errata DS80000693B
> (http://ww1.microchip.com/downloads/en/DeviceDoc/80000863A.pdf) and
> according to that it will not be corrected in a future silicon revision.
> 
> Signed-off-by: Francesco Dolcini <francesco.dolcini@toradex.com>
> ---
>  drivers/net/phy/micrel.c | 21 +++++++++++++++++++++
>  1 file changed, 21 insertions(+)
> 
> diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
> index c330a5a9f665..661dedec84c4 100644
> --- a/drivers/net/phy/micrel.c
> +++ b/drivers/net/phy/micrel.c
> @@ -1003,6 +1003,23 @@ static int ksz9131_config_rgmii_delay(struct phy_device *phydev)
>  			      txcdll_val);
>  }
>  
> +/* Silicon Errata DS80000693B
> + *
> + * When LEDs are configured in Individual Mode, LED1 is ON in a no-link
> + * condition. Workaround is to set register 0x1e, bit 9, this way LED1 behaves
> + * according to the datasheet (off if there is no link).
> + */
> +
> +static int ksz9131_led_errata(struct phy_device *phydev)
> +{
> +	int ret = 0;
> +
> +	if (phy_read_mmd(phydev, 2, 0) & BIT(4))
> +		ret = phy_set_bits(phydev, 0x1e, BIT(9));
> +
> +	return ret;
> +}
> +
>  static int ksz9131_config_init(struct phy_device *phydev)
>  {
>  	struct device_node *of_node;
> @@ -1058,6 +1075,10 @@ static int ksz9131_config_init(struct phy_device *phydev)
>  	if (ret < 0)
>  		return ret;
>  
> +	ret = ksz9131_led_errata(phydev);
> +	if (ret < 0)
> +		return ret;
> +
>  	return 0;
>  }
>  
> -- 
> 2.25.1
> 

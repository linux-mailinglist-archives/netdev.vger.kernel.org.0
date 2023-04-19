Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DB376E7B12
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 15:40:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233059AbjDSNkT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 09:40:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232035AbjDSNkR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 09:40:17 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2070d.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e88::70d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08418E60;
        Wed, 19 Apr 2023 06:40:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NWYZaDlF7+FG3oCvdlfBveLdj4gj+LZ/1kbVV9/RXV6JDqW/byADFy+Teb02AIjk5jD0REsySMcmiorr5XmQg3j4y9eZVKHLQH+lHYnTf9ZJzP1AMo6Bnj68H7MZyonRhOz5g8mZV9HB6cKNLK0ofRZ3wFtE+7sRQzVDmTPB1QWDWfJvMMZhIqqzJMt9VYv3QeTQCVlRgJqukO6cEv7y7vb/jE9eI5oTQpG6eaplDHeq21xg+8f3K/11FdB/KuLvK6L62OZjCbiiFGJCjR8vt7WX5/Mh30suskJuUHkGPvXEAQbwaxle84HcyQQcwXx7UA+wsIhhC93KVitjS8oLgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=o+T3pLetO2l+CdiEwir+gsOw0aGAznBx911zCyiGR9c=;
 b=b7b9z58DPbD+pkZAwVNczP2oI8EnCZYDBVpn8pGdluFlskCeuiZdDlXye/xW9VKJywX1jdOEreILURmjSnoUdykyAVZ4nVgQeeB3aBF9/iHxEcA6p+JIOc6EQ3SHX2kWklNBhQo5wVlnMiWuXSvd69lo+8fHKtaSCDJoLaUKF36gwgiAkMT6z77+J9tjQBrnPRTr/UCannN2I7MOQ4Xecx9s07q5iVYcDvpuWbgz1sPvQ0rPlXEHR9ILRG+9vskWdnAG2zzPToC7MGddQu65k2LbcDNxLbZr5kvyPJGLVRuagYanoY+4dDlR7E6+0VO0XU/xGg0dePZN3xwJoOUwtg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o+T3pLetO2l+CdiEwir+gsOw0aGAznBx911zCyiGR9c=;
 b=FgQee1gODycMCU46DwmY0VNNvSLkl1QSe1WhWQnh6jOKNQ2G//Z25M+lwCwDFHFahgr74KFf0el9gIGHCroJ6HzOG+RdApIuGFzEj+Z2CN+Z4NiKu7lIbqOBcIMEztfQsI7IriMtr27Ehgj6PHgD5L1BeHb6hTlfa/hDWVj/ZSc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SA1PR13MB5587.namprd13.prod.outlook.com (2603:10b6:806:232::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.22; Wed, 19 Apr
 2023 13:34:36 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%4]) with mapi id 15.20.6319.022; Wed, 19 Apr 2023
 13:34:36 +0000
Date:   Wed, 19 Apr 2023 15:34:29 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] wireless: airo: remove ISA_DMA_API dependency
Message-ID: <ZD/t5VARDjrloYdG@corigine.com>
References: <20230417205131.1560074-1-arnd@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230417205131.1560074-1-arnd@kernel.org>
X-ClientProxiedBy: AM0PR04CA0025.eurprd04.prod.outlook.com
 (2603:10a6:208:122::38) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SA1PR13MB5587:EE_
X-MS-Office365-Filtering-Correlation-Id: 6023e358-99b1-4403-94ac-08db40dad108
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VhVwWxx+1a+Wmoj4+2IQqSjByLGjNsNtPNlTIGOCOsi/0RFzFdXcyoJXGmho2DMSJCMr6NIPIAFZx9kvfrXRFuu2OtvPtl+zu0trzUYxXSxrEUsjg11HmYT66TTKYiXSoV9txi6vLXvlvWcJS61lwqWjOPelHZQNgcllDqejyOJYyth6kIZ5LadmM7zKR+cDUif1WxJY0H0+Ej9eHyYP9zMK8OE1TRuCdIUfYev4o9Pzjekcc3anva96YDyJnmliu8QfTyrf6mVvRpu7TgJDimO6CXcx+UZLAKMH2Jf1BlvCl+7SCwUyTn/ZRPruvRsnqbHAaHOS7VNyH0DQTHWDJ3kLYU2NhCOwGsG4maaJ9eatp3c38dDVZgyvYugwYRImc1sR0kcMbc99Q9cjHDgCJ/LlFSl8X/IrZy7Tz/qWIKlTw1904jVViG4wcj6G7wExOK0aq2Bz6IN+6RL/R+bqXvs4a7kcFKv04Bm68rclxufC1MzasDvQtnEcMODr6r2EqfoNwBzkFYoupvMnWNmkfL5NIWaLuODPcdLPsmd4wD1A1+I056QmhsCn4G3zzwHq
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(396003)(346002)(376002)(39840400004)(366004)(451199021)(2906002)(8936002)(38100700002)(8676002)(7416002)(44832011)(5660300002)(36756003)(86362001)(6486002)(6666004)(6512007)(6506007)(54906003)(478600001)(2616005)(83380400001)(186003)(316002)(4326008)(6916009)(66556008)(66476007)(66946007)(41300700001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?phWA0Cs27Skzyc5fVynh8cFXzjxud51wnamhs/iEJcjbNI5Sxah+wK7+dwE0?=
 =?us-ascii?Q?IJRzJU2QylqLHPOFaEUTNyRBakN6IH96vuCbUjF/wj3me37+ooP+XjZ/ppx7?=
 =?us-ascii?Q?sm8R64nyvasYsuS0WhiIyK2EzyzqhqArcHlu7s0lIhsWvmNntodtfidgSrYZ?=
 =?us-ascii?Q?kq2jVcFxdxPR9o04Mg14+vfoomPXACi4PEYs+j8UlyzyqOdwag85LIiFgXyc?=
 =?us-ascii?Q?3lO9enx0K4j18TwElY9ufYmEfX8kLL1FhZAhogJFVlQ4UDmP6wmDxz0kPuP+?=
 =?us-ascii?Q?4eRej8QlO32iRhFSXkCDUjdpd0fDNWH/MADC3Tm5Usa6YM39xt4LE0JvoNl3?=
 =?us-ascii?Q?Kt8QvrviKpYgIxs6OF2IFxUpUrPsGjDH4SZaocLC0FMdIGKxmZ0CIN23cGvW?=
 =?us-ascii?Q?OnqnAArJg/3amF190XhD9nUrHR2pHAPXe9nVs0v/dg40SCXAQ/kkm23oJ+EB?=
 =?us-ascii?Q?zUsrag6y4kNHAJDFRycvqT9UHUc2O8UCQ+5KgZAkZtYc3aox1sd7y2b2dUxS?=
 =?us-ascii?Q?P9XxPFqTDnTK8w9DWjS8rt3S+pjpXETwn7SERxxNk3y+qiMUkNDzmCSrTh/J?=
 =?us-ascii?Q?ZOIIkYMMVORHzzPIcP0FbroLZfgwtUiCDMfpdk/WEHF1cxzS3wD03rOXUsyP?=
 =?us-ascii?Q?LcbYnGQ3PwZh0QLXaUTQVsp8i7bc6vDJ1+vrb/Xprcam2hBuUZ9KsAVuXm68?=
 =?us-ascii?Q?HHNOVoQNpy9M5RVBhMixbr4k5B3yH7UQrDdJfDMwK94AYWGwMWtnwkQD8/Mh?=
 =?us-ascii?Q?8pPXi2yEbRpCFtYAmUJ9dZBNwHe7c/PNTaYCgTLjhCiE9eJlw0eEDJsB3xaA?=
 =?us-ascii?Q?XTrzlgZ1ACPZxByp0/EOEmViVuWppyAEgdSI3mNB/Eo0j4jYE/HEl/xk1mcM?=
 =?us-ascii?Q?EqGADg4oKfdLTw1K/HjiC73bEXJdbrCkRNVX00KUWc0GkNahd8gRE+BmSLi7?=
 =?us-ascii?Q?Yl+otJ/ftTrFbXq3iBu7+8ThDZYCxKXX0FWRi48h8ScQ6ph9FLkc5PL8aB4B?=
 =?us-ascii?Q?oq31JX3K3MZDLQvV/IRLwLPO7yRWqyOi0AwyD5q03IYfzrUoVuR1WxT2RKUe?=
 =?us-ascii?Q?GVAl5WFvJwwEasbFxVnYgLOihvGPQffNk/AZiJCkON9SYXQQ65RKoxIjzrO+?=
 =?us-ascii?Q?/ANgdo8DQN/UmKZY/5S0X+3Te0mqNLBTm6wDJzFDVdJn+esx/JyNzxtGnRl1?=
 =?us-ascii?Q?xaq0gRlp8iddXumJQKmAczmbeCJ+Tuy0BYxEp6LTdia6Ngr+5GQusQnxzWyV?=
 =?us-ascii?Q?HaVNXjSGkW3IUiny6FB3La8YHU+cip1FWjObv2n0hQceeOHFJeaNHYV1wyse?=
 =?us-ascii?Q?cm9Fzj3xBE3QGZKaFXfRsXsVUkEKgoDJxRYLWkxPQTFw4CAamFiM8og1ewLc?=
 =?us-ascii?Q?y0yQbxV6IguAWIbKb6gKuJrdXD2GAmnXsfbVAkyvFPSzicw2hasz6UliBzaI?=
 =?us-ascii?Q?tkPkRZpkt907wCFykOlOlV5KDahs5hx00Fc8uII1xq0/DLmGOOxDANce6srg?=
 =?us-ascii?Q?u7hH1BwbFeSOzAUtoYyGjTrnPuJ8fkpz6ZKTj3XVTOQ58M1F+wbw9VWG2saM?=
 =?us-ascii?Q?3ppafGIQnwOYcSCCtnlk0frkJx9uSFCKv7ZpUC002dp8L4wqMu5fFprt5l89?=
 =?us-ascii?Q?CrhQTW6xKs/vdXbIjTNCJiPKpbTE5HsglcCs3vUm8VGmJu9tpg3SWwu57DV7?=
 =?us-ascii?Q?Y429QQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6023e358-99b1-4403-94ac-08db40dad108
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Apr 2023 13:34:35.9798
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2HellXFCCiErxG4LU8D/rUPa9Pxt9R4pP4ECCLlwTLtzhI2ZUwH7rXukrbKc5AICbDSudMa7jakUOvaXY2JVno+lj5XzGv+guPAC64m0yuw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR13MB5587
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 17, 2023 at 10:51:24PM +0200, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> This driver does not actually use the ISA DMA API, it is purely
> PIO based, so remove the dependency.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Hi Arnd,

I think that the subject prefix should probably be 'wifi: airo: '.
That nit aside, FWIIW, this looks good to me.

Reviewed-by: Simon Horman <simon.horman@corigine.com>


> ---
>  drivers/net/wireless/cisco/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/cisco/Kconfig b/drivers/net/wireless/cisco/Kconfig
> index 681bfc2d740a..b40ee25aca99 100644
> --- a/drivers/net/wireless/cisco/Kconfig
> +++ b/drivers/net/wireless/cisco/Kconfig
> @@ -14,7 +14,7 @@ if WLAN_VENDOR_CISCO
>  
>  config AIRO
>  	tristate "Cisco/Aironet 34X/35X/4500/4800 ISA and PCI cards"
> -	depends on CFG80211 && ISA_DMA_API && (PCI || BROKEN)
> +	depends on CFG80211 && (PCI || BROKEN)
>  	select WIRELESS_EXT
>  	select CRYPTO
>  	select CRYPTO_SKCIPHER
> -- 
> 2.39.2
> 

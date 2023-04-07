Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A097C6DB037
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 18:08:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230340AbjDGQIt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Apr 2023 12:08:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229539AbjDGQIs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Apr 2023 12:08:48 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2093.outbound.protection.outlook.com [40.107.93.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19317B755;
        Fri,  7 Apr 2023 09:08:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OqJlYYxtpJv3fhot2e008aaASVqR5PJz4wo41vFvPFBYUAUbzcIMu3WP0IZerCW0SCMGFjZxG2GhOaKlinV/NdL7gNf6QFWC3Tgxe2NHraGAl1qRl2KV5N3lD3geWzfPxkCZZGDnvbJ5iEf5dOZjT+YOKnPVriSRlN6dXV0lz1OdLZfOvz46gJMVQ5TzooRL+TamRTNuwfBFWN5hTcXg+RqaWKouTI2ZKstKCzaN/9G0F0vVuWKTMK/GMlmx6T4/d1MEocKe1/W4fSpUV8R29q0ZzVG5FnylthZkigutXpFpYg8cE8bAHhJnl9DA00xg0nwpHWZMwkSkxvz9GGbIig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+C5i57nCdW9tCLrg0EeO+N/yFksbBLVQlwyydD47dGQ=;
 b=JyrsHbMCL6V+hRlc7gKYXN3ReEg/D5viRi9TXMpusDkLJIgr/2F8yyMyn5H1ne5tjCrTTiVLAT81Rzsu00oEhBAJ/5KgE1uLBpp3k6NgyBC4zKXDAkY0BlwkQ1/3CJD09iuX569v4QhqpwZUwtJ2Do2oKl1xvb0mgGHUvojlvDsIrghhATcmAvmAXlx7vQizrm/nExn7lmZCUv7ZWshqsFO2cBJwUc4BhBrRpdwuF/bq9f2cxCNSEFQHkAYr3xcne9R6gXH4ssUI70Y7c7PqL/E3Kv2B9a1G8SvtUto48wJTjDaMIGYBXeQZZsYaoLOB8ZEJDSkY3q6Y+4aG++rdZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+C5i57nCdW9tCLrg0EeO+N/yFksbBLVQlwyydD47dGQ=;
 b=WNZhIl9vc02gRFwgzP/YnPmSn/EcTVPZuM/H9f2dH8OcTKrFJQwVV70/mM9HHEM66lOZsVol48daO7jdHPNiMe49hpnHg6a8a7X48/rSvovJZ7/XUZ4VGL1vOdNq3j12Wa2XtygcRD/zbeax7lN1NgQzWkkM1rvx1Im+HCJHLVM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB5377.namprd13.prod.outlook.com (2603:10b6:510:fb::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.38; Fri, 7 Apr
 2023 16:07:54 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::89d1:63f2:2ed4:9169]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::89d1:63f2:2ed4:9169%5]) with mapi id 15.20.6277.034; Fri, 7 Apr 2023
 16:07:54 +0000
Date:   Fri, 7 Apr 2023 18:07:46 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     Igor Russkikh <irusskikh@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Broadcom internal kernel review list 
        <bcm-kernel-feedback-list@broadcom.com>,
        Marek =?utf-8?B?QmVow7pu?= <kabel@kernel.org>,
        Xu Liang <lxu@maxlinear.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, oss-drivers@corigine.com,
        Jean Delvare <jdelvare@suse.com>,
        Guenter Roeck <linux@roeck-us.net>, linux-hwmon@vger.kernel.org
Subject: Re: [PATCH 1/8] net: netronome: constify pointers to
 hwmon_channel_info
Message-ID: <ZDA/0qvfO1qHMoEJ@corigine.com>
References: <20230407145911.79642-1-krzysztof.kozlowski@linaro.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230407145911.79642-1-krzysztof.kozlowski@linaro.org>
X-ClientProxiedBy: AM0PR03CA0108.eurprd03.prod.outlook.com
 (2603:10a6:208:69::49) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH0PR13MB5377:EE_
X-MS-Office365-Filtering-Correlation-Id: a8a48841-d55b-429d-1d3e-08db37823e88
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wV6xb/rn2gaL81qRWZpOug7qBrGmXA4aaIBBJtKluUrQlVApGKNGRJR7FviOrRhPKQXjU+pn4Cxv1h8Kfua6d1F9IEWfpdqbV6Ck7zpxuUNP34dB0ddv/RJyO9n2Z7bDys6F+++u+Y/OnDI3sHPEAnd2sZG5kFYyZAi/ncMh/Vo9howx7Y/GXw+az3wK+m1uAZrtSTwo13gd35zbs3XN5UMbTXEehO5cQg+axkem3/pGaajQiWQO1RiApZifuQhsmGJ5QbWNzriHCWl8iKzDXKODeQCbtJkW5kulTc4ZKGb8n14dld/P2e2MRvm+COmI1xmvKM7V0xX8rvhXXT5UgT3ChMKPRqQ96yw6yS38Vvpu1IQhOREexaSxwuiSqa0O9TayEVeg5M+8KIR+nS6WA1h0kV3o2EkciwUULkWtNO0i+Zsygkvqf4NtQx6CILvF9cJUT7YhqY9GSBzSjSwuengE9IqAkaMtFChgSEiwwxejPR7vfo7WXSs1l+vPkAFTXkYb9yl3kr3gf3QQUksIQBZdv/p/KTYqviSqln3Hiyc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39840400004)(396003)(376002)(136003)(366004)(346002)(451199021)(2616005)(83380400001)(6916009)(4326008)(66946007)(966005)(66476007)(8676002)(41300700001)(66556008)(316002)(478600001)(38100700002)(8936002)(6486002)(2906002)(44832011)(5660300002)(7416002)(186003)(6506007)(54906003)(6666004)(6512007)(36756003)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?mzaz8nda2/+tO4helyGtb181uDG0E6jmmJ9gIJjOBY1Qt1N5Ssg+u00ZxQ6N?=
 =?us-ascii?Q?IW9GeKth344nZXURwnJJfe0i5JG5hTWvO1sbwly/EqH4Kuxe+kInMhm7BEKL?=
 =?us-ascii?Q?eL0jgmwNsndBvVojzlOrerpebvwXDMkuarWks2yqLGyVgswipqX1iJLdvMUL?=
 =?us-ascii?Q?zyXMe9SgK2hnRxM2BeEQ61u0ty1E+lg3oi0ezVeLIBZhPq/F0m1PZhFBeDH3?=
 =?us-ascii?Q?Rmu/F/NcgoCwZngYbZFHuYPst0K4y3H0B5xVh979LNtNQWQPHXJMQgRooBb8?=
 =?us-ascii?Q?LhWCGEmwT+HoEVzu0NFz5pg/IkY/yMFFLlQV4Gqs3T4rmvaqejFwhtIxMe67?=
 =?us-ascii?Q?lR5gIDVL6GdLnrFRfVc50R2iNZG2EALvc6dQmcN8medCOfaUO4WSC3U3Ahgc?=
 =?us-ascii?Q?ESDu+yYhdVFGs3/zZijed1EGl1kBZfaaY0E8NAT15jvVs0hdctYHj3W1mnY5?=
 =?us-ascii?Q?lmlNfv9qIoh8FFqhP+WgS+V/X6rf9bN2MYJlYGmluNhP3d9cJsAfYWwvpFFc?=
 =?us-ascii?Q?NqQIVzdnCzKe1B7nnMSvO1eLwNVuaxFLSD/kp0Z1DrDtR6OgCGi2IiIeJMNd?=
 =?us-ascii?Q?KCHpvgoFt7fGlbb7Jb0n6Wo+4CVLtpFRYZEKqQR0hqtMJqf8oK3ylfsPqK7i?=
 =?us-ascii?Q?0Ftdj0b34rc7VhjzwgrtMKMnJ/htgCaLZfEkQ0jBi6kWZKnlGU3q8611qRaE?=
 =?us-ascii?Q?fNjEdnfTLtaGAddjrAaohFRYQbxT7nyblHUr6t0V/IW8wAe0M6iWILANHxOf?=
 =?us-ascii?Q?GJqgyekI0sGo4ohb3BK+4gFCSeBs2L4hOaqJIXxQHOry4VvaemccB8Pl0q4n?=
 =?us-ascii?Q?TkFH9KqJFnkEDyUdvyWZYCvEQMI60XRCQPbMlUXgwXCiqSYpMzzq4eb5/M8b?=
 =?us-ascii?Q?FS2geQ3uWFbOWwtRJK8hozbi+NA4WpRaCh0Q8YC//9HScFPjgCIBFUxk2arP?=
 =?us-ascii?Q?PG67xZISs9sZy+J6hV3fY6ZcOCF0g/dQ7tpfPvPRLjaSAQvL7R8U+onjZOM+?=
 =?us-ascii?Q?tmvk1mjroHdw/tFBdWI7D6vMahlo0b81Xb3+F2lL0Snlj7abrRMg33NwMihu?=
 =?us-ascii?Q?4pHiWVwVlvrq8t+7z9ZDQ6VNPWfZZEEIW5YYT0b8kkccIxr2mc7Y1QYNP8H+?=
 =?us-ascii?Q?8yMX2en6AlOvptjH0/dNaUIZsn96lfIxlu/v2Bxdl5UQHpS7RGv/yLiul6eH?=
 =?us-ascii?Q?1HlFxHBXa16ojD9ZfRzWWKs46o3zqv31ixCee+xbKpM7PrzQ/KVtzGJMty0N?=
 =?us-ascii?Q?z/mZl4PCQdCGqIp1B97mh+A3tCWCUlS2gzoM+q33UdUnDNl/9S9olpmaAbX/?=
 =?us-ascii?Q?cD6SYU/lw9mr8v1+reIR57vTRyKAtLDKwDEvgLcMJO2/6wER0XMDJY241K3y?=
 =?us-ascii?Q?qVZ+YbzXgZknbMWsSlyUTYQhTMeT6uLqXkHbBmn3chgFfBmLibdg7ML1V/NW?=
 =?us-ascii?Q?xvtp4W8gXk81AYpUM9tozm8dZ10eTKCnw/m3KVibxcYcxOPTyZFnmnBCIPJc?=
 =?us-ascii?Q?2Y5h6NALM9JOSY635YoqN3f2PvElpIug4+cLF8yg2etn636wO9r7ZOnJrAMa?=
 =?us-ascii?Q?BIOYseNkmrv2hnOrnXkLO9lqoAD49QFQbDz6EVBXDUqiAImZqtukYsy/EnCP?=
 =?us-ascii?Q?7rh2Qe8Fo++Fw9Ddx4nQEvrd8HaUvkKKZj+TNI+Q2PrdhGvzN/wvGa/pJMKf?=
 =?us-ascii?Q?jRg9fQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a8a48841-d55b-429d-1d3e-08db37823e88
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2023 16:07:53.9271
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KcfxlLG63fJ0MDI1okzWJGWhs+Gjh1OKkJA2pyKovaHfufLXqUNMvwKeNGOIry5VhK9wFu9FD/VB0TrjJMj1xzBlQ3mCnIB4Yx2zYMWGZZA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB5377
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 07, 2023 at 04:59:04PM +0200, Krzysztof Kozlowski wrote:
> Statically allocated array of pointed to hwmon_channel_info can be made
> const for safety.
> 
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
> 
> ---
> 
> This depends on hwmon core patch:
> https://lore.kernel.org/all/20230406203103.3011503-2-krzysztof.kozlowski@linaro.org/
> 
> Therefore I propose this should also go via hwmon tree.
> 
> Cc: Jean Delvare <jdelvare@suse.com>
> Cc: Guenter Roeck <linux@roeck-us.net>
> Cc: linux-hwmon@vger.kernel.org

Subject prefix should be 'nfp: '

Other than that, this looks ok to me.
Though I am at a loss as to what tree the patches at the URL above apply to
and thus am unable to verify this code in any way other than visually.

> ---
>  drivers/net/ethernet/netronome/nfp/nfp_hwmon.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/netronome/nfp/nfp_hwmon.c b/drivers/net/ethernet/netronome/nfp/nfp_hwmon.c
> index 5cabb1aa9c0c..0d6c59d6d4ae 100644
> --- a/drivers/net/ethernet/netronome/nfp/nfp_hwmon.c
> +++ b/drivers/net/ethernet/netronome/nfp/nfp_hwmon.c
> @@ -115,7 +115,7 @@ static const struct hwmon_channel_info nfp_power = {
>  	.config = nfp_power_config,
>  };
>  
> -static const struct hwmon_channel_info *nfp_hwmon_info[] = {
> +static const struct hwmon_channel_info * const nfp_hwmon_info[] = {
>  	&nfp_chip,
>  	&nfp_temp,
>  	&nfp_power,
> -- 
> 2.34.1
> 

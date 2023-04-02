Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 761076D391A
	for <lists+netdev@lfdr.de>; Sun,  2 Apr 2023 18:44:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231197AbjDBQoj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Apr 2023 12:44:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231187AbjDBQog (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Apr 2023 12:44:36 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2072b.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e88::72b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3337A1A979
        for <netdev@vger.kernel.org>; Sun,  2 Apr 2023 09:44:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=COBKsMLZQXiWWZMSBrD4dWv2MVg5T9rYIenrjm4Jf4JRTXvB3hTPPwqu3K5BKwNC+ZU5QoAt+gTvsFNgdmvEdwqclZ1uTSJm6ulnsbFzI8ByojyARRTAumvi+XUqLfbDKMnHGVLQwYJ1ehNbmfz53e6vWJJno/Jz6YTtW6HV8vhU5jpDNbI9PLbfqqnyKZdnopCecpkDMN1FFZKv4NhG6DgmGBDTL1zXNjPj7Gt6tSSH3ohvagM8ZR0iX1hOgD0YIb3gEq5FtULjxfwHISbctU+2FmisB4ICFov3bmPJ8rNOJiW2F2NZbu2vxW1Ftw1n3b48Kjv7ZeHueZDACIXhKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=a557bj/f32umh7O5U1TF/s04MPVtSrMckagSsAa1W/o=;
 b=QyrvZfawSWuVjj3SxmQI/+sE7/G4DWRrcAL+URC9wpox80ukYtrnw9xp6OYOxw1dzbUGie2x8nPDKG9IfNfXEFfjUv9OdvJVCfEqR0OYnTSAzRgiY1uk01UeeptGxdRkXA9ILaEjUIx91uydp+5TVQO/b80rEl7sVd9HBGZpIYa0fvWC9nTSOMyTkUYXZGQZlI20GQEMO0LU6WHd+1EiSX6THIFFtQMZ7h89Gs1f5xd7yVgpAOkMPG6A2P8WJ5k35Q17J7FWnxK4OLajSElSDHxUcA4Snlrjrv/CMQ20/p65XlCIVMRPXuRNUpJZ3b6mTzKFMMMxAcnvgegzPbDp0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a557bj/f32umh7O5U1TF/s04MPVtSrMckagSsAa1W/o=;
 b=KKfz+U/CzecMAxIpZaDHRScffnhDkTRyMkXFyCONcA/DDHxykLsKeH891J4ntC5BvY+Nbo8GKaOW2cHF9RGh0mSz2LhI9BDc1WpgGjXYA57GlClwxPWH1wqMWsRIXTfSQB+MsPwzBrO1oFUIiqzPzY/icII4gHqQMuzrnwSV+gM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SA0PR13MB4160.namprd13.prod.outlook.com (2603:10b6:806:93::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.30; Sun, 2 Apr
 2023 16:43:53 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb%5]) with mapi id 15.20.6254.030; Sun, 2 Apr 2023
 16:43:53 +0000
Date:   Sun, 2 Apr 2023 18:43:46 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Chris Healy <cphealy@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next v2 6/7] net: phy: smsc: add support for edpd
 tunable
Message-ID: <ZCmwwnUsiJtG3uHW@corigine.com>
References: <d0e999eb-d148-a5c1-df03-9b4522b9f2fd@gmail.com>
 <f47ac853-a413-1cf7-15d8-2e4400740510@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f47ac853-a413-1cf7-15d8-2e4400740510@gmail.com>
X-ClientProxiedBy: AS4P195CA0043.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:20b:65a::11) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SA0PR13MB4160:EE_
X-MS-Office365-Filtering-Correlation-Id: b1deb8cc-af0e-4c94-b019-08db339971b0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vkYVi+6OfexWaKpnjKWLkrmBYXrSxQZKsgFyAb/k3ebOEEJtyVR1ddMyeE2dVAs9y0DlB5q1/ElmDNQp9qwQlbLuJsn3HEg0ndFNKl2w2HOSIEl7M2J7R3MM5SPVnDgqomyL7RNGcRl6jKn2u0gbOr8n0kWB/to9mr89D2fgJmf4t97T/pYxrCDisy8cuFwMd9zGaxeuB0tQYODS6SuCdmud0yuwx4/jqr5o8b1nQXFhtyjgB+y+4vIGf2mQBFoqiFOyBvI/Wlt489Xj1SuPsZ0Bosq3OnyWI4MfW+4fishMGCxIodYQeecyI1bxdEripNkGQ09rh51Y5oiuj0pTJKUrKRDTCB/dJsH1WIMjeWjVESc5PufZ5XrnogLGam8aqcKihgZhyMe73ymvsA0bwnOQfFPvVcbSCXSacIR+Tur35+Q0iQKbbHDOzQKwvDYOCPwgIkZrZ3cI575LMrfeLimvM0hT6VBKfLCSgdTMXKycergZV64HR16C6w+pXfJauhC1Nfc/RAGZVHfkUag0YhUmBEZf2+P6t3yn7xxdFf7c+CPpexBlLLSCn0wBhDYGmFa264oBBeKURoW6SOTeUve7QFSPj+MamNLuqBpFC+c=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(366004)(346002)(396003)(376002)(39830400003)(451199021)(4326008)(6916009)(8676002)(66556008)(66476007)(66946007)(478600001)(316002)(54906003)(8936002)(4744005)(44832011)(5660300002)(41300700001)(38100700002)(186003)(83380400001)(2616005)(6486002)(6666004)(6512007)(6506007)(86362001)(36756003)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?z3zT28dt0OvK3QzISjEbaTdRa3CDr4YXPBDsYQYs+9fRw9YHBsDsWrNgsvoo?=
 =?us-ascii?Q?3hK+OKBtvfjQu80X3mIom+qrQLXDypWZU3TmhZAuGMySw2t8q/VZmyW+j6aN?=
 =?us-ascii?Q?kBIgF4KKOAykFHqdnfabLlpLsTmAv/8t6Y1BS40a3y7+dynxEpsq95RDlCo7?=
 =?us-ascii?Q?8cVJCMrAvJJLv40YnEoto4Yg84vLJw9v0Dp5BwhtKOjtjQ/ZUlUdiRZoAAwT?=
 =?us-ascii?Q?YsUOL+lpLpYzWEJmI0EowFLq6qzs2z5NyIFspS/C7G0NrqNur895zkTrFxSi?=
 =?us-ascii?Q?jb6xSV5u54LQJ8FYIh05kx9y/7/Vu7Sw6E0o9aHU4hHRrifGAZojOZfAb8zF?=
 =?us-ascii?Q?H7byv1Q057Q9HSYugKPPdvtD0Mk0kl3dDhUFIMyi0oGI1wUiauPn11eAV1Ud?=
 =?us-ascii?Q?wnq9xxZgTGiCX83iBczs04t0OIpqXaaV9cIanKs8FQcLmWHuHBisWDo8wDVk?=
 =?us-ascii?Q?b2c4sXQGHb/H0hpqH1pgphsKj866vj7k1yk81Smt6C/Jv5sa/KTWWc/v6UmF?=
 =?us-ascii?Q?mGVwIH9LkeqcvgJz6MCdlCtoO/ZmM4lAqsdrdv9CjbJzPPdgK1DjdlVZJ4BI?=
 =?us-ascii?Q?qxo9Uc/FR0RnK+/LNGVKNC+DugcvJ/RdeP6gn3TH8X4TvUnNGgqgEBfuk9GH?=
 =?us-ascii?Q?mDNshrSFplkBQ630jaH8E3/gUJqBmDA0ITZ+dFvSOYzTF04X8GNgCmNWIFkU?=
 =?us-ascii?Q?9JdD9Vef42PwaYge0feRgL+MNJkoj7U8B09e3RRgERe929UPQH04qPhDZGZ5?=
 =?us-ascii?Q?VLG2hPppk79GRwxpMWH5eWijskps0QedYImc82HKj49rknajoUE1L/7jFyTq?=
 =?us-ascii?Q?obUu8P9yf7lFTu6hfk/kPBcHke7zCFeW5zD0vC312hsiD43b7mLEFbCrRNu3?=
 =?us-ascii?Q?YN9qTcn1EliquACRZnPg6FKUKt3ukfVnXI0oJo7AFDopanGreHwOuDbj3fjH?=
 =?us-ascii?Q?h9KwCYCuKhpWpS3VEQQlMlcWWrF2Yj9d/FWPKkQz6l9+umN6/HLaCGT4xLrR?=
 =?us-ascii?Q?uEvQDAeb5+mr7aYr0JD+jPAsF5ktXw3uTphOauZYiaLZsjepwmicmitzvbu3?=
 =?us-ascii?Q?vVAntgJOT9itaZHLIXJGyfru5OEY/EUDLEsZ97Og1Ogig+TnvcC15yPPq+h1?=
 =?us-ascii?Q?mUlk1SdF2VS7jClDlX+MGpdpLlda/YJdJKa3b9UQwQh4zNXxYNAVk+745QX+?=
 =?us-ascii?Q?15+n9QETk53ziQHlNv2BjLpTHPQMkOmSKNgVUVvlLKtgEiJPjlndB4KKrBSp?=
 =?us-ascii?Q?mNLyIChGqlQK+IN+SgbA83t/ppsASj6yjuqPAboQmY2z/E5/3n+BBDnfMOKB?=
 =?us-ascii?Q?j4sNaxw72xh0GCDdUeE88L1SAYn2leR4FfzjUCgTXTGsCnNRc28wjm31iUO3?=
 =?us-ascii?Q?92KejRMicAzBQAXtaqrWuDlTc17NRlgmpxp/ixC2/xcjE8DIP1ULhtkmcm6b?=
 =?us-ascii?Q?5qbF++m2wv1aK91rwVaHVxoHSfp1ELue/RuhyRHPZf8iRm43TI4WI++edArF?=
 =?us-ascii?Q?/2wWQqWnCi3mW8D82rAhyzLlnwBaXXxryYXb3q29kajBqPFQOsvjv6dZIB6Q?=
 =?us-ascii?Q?frWtOxmjP8HndasManclDvJGHBTr/pTdQPqChEQ/VtN56vNTLeB3111bHJ6k?=
 =?us-ascii?Q?q/5i+IpsJULxhzoYf5cP2rXenbQ6MbRqorMkvnCPjQZJ8sDx4Aa2NutCsp7H?=
 =?us-ascii?Q?hlOqzw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b1deb8cc-af0e-4c94-b019-08db339971b0
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Apr 2023 16:43:53.5158
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: A99QL3oMwc1QZ7yJKkIKTTqSuaKjciBbBXRAsBK8ywsO6nipNzlT+ndn4pqYaXRUGhgUli2kxagwvUJM3eLBRX9OGzujYwpv87vJWrPNxR8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR13MB4160
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        SPF_HELO_PASS,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 02, 2023 at 05:16:56PM +0200, Heiner Kallweit wrote:
> This adds support for the EDPD PHY tunable.
> Per default EDPD is disabled in interrupt mode, the tunable can be used
> to override this, e.g. if the link partner doesn't use EDPD.
> The interval to check for energy can be chosen between 1000ms and
> 2000ms. Note that this value consists of the 1000ms phylib interval
> for state machine runs plus the time to wait for energy being detected.
> 
> v2:
> - consider that phylib core holds phydev->lock when calling the
>   phy tunable hooks
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>


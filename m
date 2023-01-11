Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDCB6665C47
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 14:17:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229709AbjAKNRH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 08:17:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232227AbjAKNRG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 08:17:06 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2122.outbound.protection.outlook.com [40.107.243.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5AD060EE;
        Wed, 11 Jan 2023 05:17:04 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BYM2HloZVyrzHmD0Q1SXbcALyctFkMQf21OJ4UINrDdsnIaJZPhCON6GH608fJNcNv85ri00ulrx0n3HY8Lh9+/9J6z8tUbrY1UzS/zeD3NfR1DCdTUulHkHeR1O0FHqo3MCoBJVEWmq7Sj3byX+lxAenyxIZEdz5kTIJpwxhItBU+T738BGqaZq8JUObJcm9nUBv9MfUqt4/eCDZVXXiHcOTAontCkze9JyzLkvKBw8E+h1yTlU1A5a5juWB0Csb8Kfr3hbBy9YbyUvqMHAPGBy2A6KA2MxfMK1uHjr+LDF7XzcwnofqHk0fGmO62y+WSmHLGZF3UABaa3pZqA14A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BCFOAmyRgIErWsJWsDvNvqsfE51Z39vHkVLACPmVFUA=;
 b=jmvaxbu9/Ftn0RrUv6B2t60mV2drQWm4HSr5ZqQ1r5Q1WM3Vtiu+qZJS8Qce/G1vnnobDn0mAz3ipx+oCh5t5/XNyVj71xd8uL9CLwBiyGrRVEFaAsUE8PGRwxrYaMGOn//JPE/88fTwcBGEWe87P8cOedt3A1iJ+bQwPicG7o7/x3pLuXphQ9khj9gpwf1zedUeJcylM+rqBdh2FpLhPnd8mPlnPG7w+Cxh8n7us/q72CPCVNNs3KNJv6DRRI3riBg3x/0pgmflQVhzLivNkV9ua9EASDTh4C+9U8xpandn83Jr6ifFXUKtMX6V1HqhRzOs2oISRHR6yFe66s77Kg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BCFOAmyRgIErWsJWsDvNvqsfE51Z39vHkVLACPmVFUA=;
 b=EKI2kcIRi76hsQ5hdtYHORdSr+wRa9Id1gytvFwSRSdkiibohCqTDs4RhKAMptHdjWCmHvR+ZKR5LFoZeKXWK1gcBisozdKpFt2KR49UHB7ovamQW+ldGGfE5YIYIS2N1hdL+e4453A6Ghd7CWR0V6tym+TSh6soZNbbdiNd0Ss=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB4988.namprd13.prod.outlook.com (2603:10b6:510:94::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.13; Wed, 11 Jan
 2023 13:17:02 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65%6]) with mapi id 15.20.5986.018; Wed, 11 Jan 2023
 13:17:02 +0000
Date:   Wed, 11 Jan 2023 14:16:40 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Lukas Bulwahn <lukas.bulwahn@gmail.com>
Cc:     Dimitris Michailidis <dmichail@fungible.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        oss-drivers@corigine.com, "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: remove redundant config PCI dependency for some
 network driver configs
Message-ID: <Y762uPnsRuwKi4is@corigine.com>
References: <20230111125855.19020-1-lukas.bulwahn@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230111125855.19020-1-lukas.bulwahn@gmail.com>
X-ClientProxiedBy: AM0PR04CA0056.eurprd04.prod.outlook.com
 (2603:10a6:208:1::33) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH0PR13MB4988:EE_
X-MS-Office365-Filtering-Correlation-Id: b631d5e3-4520-4ca8-4299-08daf3d62070
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Rz6i/vnGCvJvL1ynwVXzjX0VkMShhKPX2eDpB/x/7TGEbt3Q+F85fnZRNgqzl47POfkBIAz8aiB4f9BAjgJM9G7alwlZ9zvrYe3E3SZ18rK45XHNwn/01UZCgSJoxHZTdxBCiKWWC4XlCz7tKw+9Uw+Cvd/fFdqa5Uh+cmiqFW5LvRYmcL2H8OK66iedYpTR/RPeemMoS9h8xRLrO/MYDGdQUqqLb29z7jJbMbXZCu4dcXpSLwoW54zQhPxzLrlac8L4tl4tSHiYlSEWcB2cQO0iVxpCVX8OW5iZbhpR4Lp9+9SqP1n5ceLBXkPEThdUU6hlFr9r1MYlLKWaceLsYrOZBwryPO1K9UXYRzufn+QZLTomd1WFq1v5syS7nxZEOXi5kSm5NFpAYwo+v9fsj6SRsPHKYF/0thw5y+bsqAn2IYlQnizJ9t4BVA2b8F3G+wLZe6c4RTtKFMISJjvZ5IARzRJmggwrVOCyodB1fuGSXS6qyioxaB2r+unMwLmfz1bftA5A1Nk/5cUmZy1Ap2IiOtzWmrAsGHtBQnDYaDzaSxnPE0alPAKgMAfMkACdnB9PkXNOyJrH2+MSQhXI3kFHN27SHlg4ObOlEJrILTtVO+M0aJLDjpFyEMD4cWm/Dgb3oD3Bc8un8c6fs+NY0wdD/1nvLswX1SJ3maWbbEN+ZvvJCgL30AFk6264dsgG
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(136003)(366004)(396003)(376002)(39830400003)(451199015)(38100700002)(83380400001)(86362001)(44832011)(5660300002)(7416002)(2906002)(4326008)(6916009)(66946007)(66556008)(66476007)(8676002)(8936002)(41300700001)(6512007)(186003)(6666004)(6506007)(2616005)(54906003)(316002)(478600001)(6486002)(966005)(36756003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3UG10at55H9AHxD5DNO9ystBvMuOawdVHdm0Qw5UVfndG52wW6sABEN/enbg?=
 =?us-ascii?Q?JAhe2UqU8/6W8jK4NpcZOTTNVsuOrr5ahEndiP9Vw4xzAHVVe348fuQXI5d/?=
 =?us-ascii?Q?rtoMLefubrGqbVWiskLUVdwuFCnL5WNM4nZXKx7irQU07mDR8zbX23du6sjP?=
 =?us-ascii?Q?8ya4b+HSJNTMKJVNrX7aWhCVCnq4vNCA7ol8HynPgcYefVafxpBcZxpjjOUb?=
 =?us-ascii?Q?ynrppLJgRnuIffB3EnSGyH+kgLeEP6bVQkVRreB7PFe11SiXObfaTQRsO4+q?=
 =?us-ascii?Q?L+j7PRlxHt2CSBKn3YcDpubu49f50YHTvW6KswRZgJap8lNfAE1HLZk6f8tk?=
 =?us-ascii?Q?dj9l7IA1vnMMnMl785uuH2n+S/YiB8cUbdJWYzCQnCIcLZzQt9B1OyS4MWOP?=
 =?us-ascii?Q?8TmTwujdQf9HvSZtHkJMSezAoxneesK+51vf4o711hKTbV29U8qhgd6jODS4?=
 =?us-ascii?Q?LxyUEQb5DjtwMwS7TxAdAC0EU9FY3vGtOQ4xEPFMP1rll04ZCKS7+lw7Ja2I?=
 =?us-ascii?Q?Jz8fT2K/6jimx93ZbZsBpZr5c8Z/fy9oEDEp+XbLr5elRCxzOhkhCY6mALoJ?=
 =?us-ascii?Q?Vgj/QdzashJ6t1hUJxbFBuVuSHbqmWik99+ogp2l1PnNGts8RPhExjslZJ32?=
 =?us-ascii?Q?kgmVFVQ1Tcyxtkl2S4sfZsvuvmY/kzuRXT7WCxf5T9rllmPbOQboDqP/GgDW?=
 =?us-ascii?Q?o4yOFI1vuW2fjVAJ0iPZQz2CgabT208pX836Vpd0ne1vJ2cyar/yXWu0rpKq?=
 =?us-ascii?Q?Dx/t1wNoSxm5aDKTzFCag//EcyXyagCoC1JePNLkrz2heficwBYP+qtY8IgN?=
 =?us-ascii?Q?3dG3FtQSU/IhBzJUtr0G01Cx+dIJFR5wQBagoJmk5T43GNEQ+e/qcHW4Rn86?=
 =?us-ascii?Q?PohmrOpScBk0XB/EEXN4bwyfL1bZ65lwhqbAvv0zo4RZtnRhIbqEpkRvyJbs?=
 =?us-ascii?Q?M+KZMV8gTh7r0n3jrSt2mgvt2BYHScczugrt9SLNVV8ClsoKngUpN5Mq+Eee?=
 =?us-ascii?Q?ykHiL4Ex5yrhMZtOjcjOQvNJVx5lF53RUuR2FhV/Mwme4rjPFpsJAthEpGgy?=
 =?us-ascii?Q?659u3EvfzpvmOzR9040dnS68MgErMKNc6YdnAwC+3XeuHOV7++4Mh7/7t8Sd?=
 =?us-ascii?Q?KrXJ3bBlYenwvsv/ezGrleWqSBVHdHdfngxWMY82xS4RX/4+Qcd8OCwZ6fzo?=
 =?us-ascii?Q?H5MtR0XjJQ6FKbMJV22n7/1nU7hpzrdDs++UHkIGGv/XQrL3nS+9+XidZUjd?=
 =?us-ascii?Q?OC7sZFSThGPXN7Noi96RRm/6suxzkrOiYsUiSy3xQwEnSy3vOpQhE/jN34Bj?=
 =?us-ascii?Q?iawt7bAuw2QP5opQvV2C8ECiv0wDZXfjUBuFp52kYsOJhZA5bxDR+q+Kp8IK?=
 =?us-ascii?Q?/kLU/OhD+fIh7q/otJyrSbknpITJ+iPM9Fk+QqONVr1pX34e2k7C6oD2y6aw?=
 =?us-ascii?Q?NGA2REnTaj1T41koXqzRiY5slDHTpLLcEmO7tiWTMo1JK+/OiAslu8ZlUscw?=
 =?us-ascii?Q?ObZzRnKE1vlBb0ILdZdhclUvQCfgN24m8FzetQ5WhmgjkJXjETMZS++ACaWj?=
 =?us-ascii?Q?zHsWvYMoLMKdeN4NRp/NXiqC0lRNJqGZCEdCgCNQSYpdznQpb7GRg0+UCoA/?=
 =?us-ascii?Q?gDcVDvqQBg+EHDm7ieQY7XWsJarp+sQqlsSOfVUZYbPIP2T1YSnbD5/C+TBM?=
 =?us-ascii?Q?kedg5g=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b631d5e3-4520-4ca8-4299-08daf3d62070
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jan 2023 13:17:02.1156
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Yv0a6FjIjoKxSKxasP702kNpNwJSVdhgUI8tXCv0SbhYvaRmH9OxPPIzGgK3M1rhdrqRRwp09a3ISVQ6nKSGcdM+YhObT+CKoWkuY+yYiVg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB4988
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 11, 2023 at 01:58:55PM +0100, Lukas Bulwahn wrote:
> [Some people who received this message don't often get email from lukas.bulwahn@gmail.com. Learn why this is important at https://aka.ms/LearnAboutSenderIdentification ]
> 
> While reviewing dependencies in some Kconfig files, I noticed the redundant
> dependency "depends on PCI && PCI_MSI". The config PCI_MSI has always,
> since its introduction, been dependent on the config PCI. So, it is
> sufficient to just depend on PCI_MSI, and know that the dependency on PCI
> is implicitly implied.
> 
> Reduce the dependencies of some network driver configs.
> No functional change and effective change of Kconfig dependendencies.
> 
> Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
> ---
>  drivers/net/ethernet/freescale/enetc/Kconfig | 4 ++--
>  drivers/net/ethernet/fungible/funeth/Kconfig | 2 +-
>  drivers/net/ethernet/netronome/Kconfig       | 2 +-
>  3 files changed, 4 insertions(+), 4 deletions(-)

For nfp portion.

Acked-by: Simon Horman <simon.horman@corigine.com>

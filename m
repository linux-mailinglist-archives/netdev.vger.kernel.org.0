Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 756216E7DF6
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 17:16:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233617AbjDSPQH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 11:16:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233607AbjDSPPu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 11:15:50 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2136.outbound.protection.outlook.com [40.107.94.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10D829ED8;
        Wed, 19 Apr 2023 08:14:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dSvCdLQ3H6SHC4svEscAI49cM3SyJO6ER6Qs61WA5CYQ+42WUzm4nLpP7MXpWRL24d9oMvRQP7xr13DNGNjiyZd1D51ezhi/JbR1din40xyjMFdDEZY+Vnkc/7lPxwvUN43lp2HBenLLecrYERgZ1UZRMRMjr/RgT4bDinKB2sT+YVmfHrNgTt9R5Natm9hhDUdi1zRQNreTBhuZ5Zx9X3jZwgcZEY5rWJRljKn2Pw/9rEY0u60CtFnDA/7JMLY3WGXY387ky1SuxKVs0MtnOi7rtYqj2SQMKeC7a2w77iUwizcnkl2U5KIpBN9lhb0av5nXTdh3KwnPiGrISLSEJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=S0fVQ4ZQfy7FAMPbiStFU3EFc1OJ7hODWTnGKXJFIi0=;
 b=iWtkXJr1e5WinGvhv6JQBhG3ANcmgd6l6JJxjDFy4OzQZ7SdJv4Lyay5H3/AyFaJR5hEfF/ZRPPA3OFsauLswA2BXA6MGzljCJp08zswyCpnR0W7rjPBX+KRAmH1SY5ApDXT5nXJ7VbPz6K5wGOU/IqYnUqfKOH/jhVArDg70qgLcBD00Wk5AYP5+Hrjg1uKEqkuJ254rI9jt314XG6ypBU3ozgpGQKbIG0mGuvKPuMVMXxGXkRx57Al4nv5gAupGmHKNhCOHLlTwGGNkS0F7kL1hv68qNdvxVC0K/D6aLFIVVQr0aKOJ4ZI3JKsknwzBqTnpN8+JQxRDElfpI3XOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S0fVQ4ZQfy7FAMPbiStFU3EFc1OJ7hODWTnGKXJFIi0=;
 b=mJ1iwIhJ2bk73UO2dXK6aVas2h1S/nwuDEJarMN9DhqPZMDlp+sT5Gd6miTreqUQJjenUmbhgdBC+1Rpn9kuAELdruT78rExtw4mK/yUKUa7VNgODYgajzk0Fv3LtRE9zjOh9WvAS35YemmZIQtZCJt9YLeqw0mwvfSX8i2gizw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BLAPR13MB4706.namprd13.prod.outlook.com (2603:10b6:208:322::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.20; Wed, 19 Apr
 2023 15:14:53 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%4]) with mapi id 15.20.6319.022; Wed, 19 Apr 2023
 15:14:51 +0000
Date:   Wed, 19 Apr 2023 17:14:43 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Arun Ramadoss <arun.ramadoss@microchip.com>,
        Oleksij Rempel <linux@rempel-privat.de>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH net] net: dsa: microchip: ksz8795: Correctly handle huge
 frame configuration
Message-ID: <ZEAFYwrReNwcNl+d@corigine.com>
References: <43107d9e8b5b8b05f0cbd4e1f47a2bb88c8747b2.1681755535.git.christophe.jaillet@wanadoo.fr>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <43107d9e8b5b8b05f0cbd4e1f47a2bb88c8747b2.1681755535.git.christophe.jaillet@wanadoo.fr>
X-ClientProxiedBy: AM3PR04CA0131.eurprd04.prod.outlook.com (2603:10a6:207::15)
 To PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BLAPR13MB4706:EE_
X-MS-Office365-Filtering-Correlation-Id: 1ceca81e-e276-4d19-ece8-08db40e8d248
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ii8PRK3S+ToN66klZlVHeN3U8pNQ48cAircTdCJOLq7CyTZ3jGa4/H49Dd0Ad1FL98Pp9fj3YSJP4uyBr1m2aZE6LeYh+/5Avr4sk9nseNKHdZtGa6qHs9jWgjZ58rTs37ypWHtmstEjYzIm4gdGxAUjYBR8K+oSZtlFaVrREUmPW3xSTsBgyGu+daXyYPy+kwihfLXeI/OJEv8tKUfGcPvLeJ552cjobaQ1u8VkDhsItMmQn17x04tzBqOResk3xLRFIYb96ZzIRWG3LPH8cZlCkRn5wYQP/YF31bA+f/vcAOpDcWlGAKUHdLeFFe6j0SD0x89k5xGDVBKKHWTVauxaycWfcnBiE+o06AE7X0eIhz8wmwOPLK4tBMG4fZjxlaqV9/Yc4hKxI++/riRPC/iUgC9348NfWFnLvUYIWdFqNMZjS5BteVo83YX/VwmZkOEut0pIoqp4Bc3VeHzelfxyoKj1vtxWWIhP9tEAM7bHbp0HjckVV7fo/1iayDqY6XDImmSpNNFb4bbn5Zw2+Z2OJpKbElforKccqvlc9yVTdUpIaPRZC1cBzIsR+bhZfG4xHb8OxqpP2OJgdqpORyy1YLPjR05A1eaLiMPxy7yT5hFBdQ9AhKL6lldzpZPHZ6RdbovPYfQeDBmYZj4JMiOjU7NhKcDgRaNfOLl831Y=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39840400004)(396003)(376002)(366004)(346002)(136003)(451199021)(6666004)(6486002)(478600001)(86362001)(36756003)(2616005)(83380400001)(6512007)(186003)(6506007)(38100700002)(316002)(66946007)(66476007)(66556008)(4744005)(2906002)(6916009)(44832011)(8676002)(5660300002)(8936002)(7416002)(41300700001)(4326008)(54906003)(14583001)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hfDF3/SMBbb1BMMn29FiJosIqhMI3FDRl3tYdfcALo9eLBtitIMsouZ0Jff/?=
 =?us-ascii?Q?jyqpoJu+kphGp0XPD1ZYKbeqDn+wmQfWVDJA7tHmv1+a4xJq87bxKyRIuhFT?=
 =?us-ascii?Q?hAJ2Wh3TLKQiEs7WyowihzBjpF+3SotUApnltizSagUgDVdy8eqtjhe3txJB?=
 =?us-ascii?Q?qZkQ3J2cJHTSWabUBjaquuEaAKELx61yhDQKT4ieRhBcw1k9jZVQ/66OISn5?=
 =?us-ascii?Q?AaRXuTWlHSjR6YdUWOcMpyhgFUZAnl0iJuF21/lVTGoBZzG0c9HLq1iGPbWV?=
 =?us-ascii?Q?8F0MCfXSL+ZyUd+p0OsC1JlHTEBoHh0UoF6Nxf14UZiyxOj7oDZtyHEoxB+k?=
 =?us-ascii?Q?bwwgIjzRFXW4xdRk03nU+ze4tBggt2UjU5VzFoNxT/cTUgWE7DzEjUqh2mzc?=
 =?us-ascii?Q?5SdLKpqP+yP+NSV2KBhdM4wnH6Sa3qBmkps8jVPwVwbPpwUl6SneiSZuChHn?=
 =?us-ascii?Q?SNXlD1QB5juI4Isy1vjuPSymmmcoxPRiRzJcIABHByJOSEZy54soNeGDy2wH?=
 =?us-ascii?Q?dMWo0BlRYj4/QLZQSzESb7K9ZQVSyDXFIRhNQZcTOOMLS2o9CDFPRkG3HknW?=
 =?us-ascii?Q?xdjXurlXiEH8R12yq4Il6Jdzr/wVzZr7h8DHoOdloWBH4Rts2e3M85ubwpRh?=
 =?us-ascii?Q?qxqmxSQwFJQwR+bE5seJUCyvlwNqGrBVrWtWa9pkLp3/eKVptsMM3ecRid3r?=
 =?us-ascii?Q?d4eKnEN2zCuDgjJOJzZ1G+S1sLZvjKNjGYgbQyuV78Mzs4A0JIK7weSoVf1d?=
 =?us-ascii?Q?Rtyd+/iFJiCYWfoGoFCub+2z+Yso8ODjHyut16DN96GD9EzExrLadJd4N1cr?=
 =?us-ascii?Q?Ec4yNMeVM0iEaPKZvmQg2IT/mQwj9viEKJQmmObzsz6Eaj7lUshzsZEZ74fi?=
 =?us-ascii?Q?1GiKZ7g2XUhMtErH8ZgwTgXWPvolmzg9I9LJI7kAXTJL4GcNOCFqRkkgpt2o?=
 =?us-ascii?Q?9fF6cmXNgo+0aVOTicDBWXzEpjh4c/W25K1tBsmANUofqK8ecF0G62+6M/hq?=
 =?us-ascii?Q?4hUhwvLEVURJDRVDgVQwi00st0vhAwWGdhELxTOyKdgHqhpELM1h7N7tlf+4?=
 =?us-ascii?Q?NhP17sjhsHR84Bvllq/GG++HPXMo8MdyVXEaPvguz6Uk+cf1K6X0xNOgamsc?=
 =?us-ascii?Q?jII3UL9HjEs/WIwkn6J6/TwwSSd9O3ms96whOlBCUy9sY/+/CNyU730WDZj4?=
 =?us-ascii?Q?DEidT8uQBE3HE9qnbdnWh0LiFRXMPhqSMTxRoh5seUrA+IA99ZD19SkJD5Gr?=
 =?us-ascii?Q?BnewMtOnlRxMymR4FA5tr+39ZAz+4WLSpRg/rHpW91NuSfkg4Y2/oJPKTE5X?=
 =?us-ascii?Q?G0eZkK4Qz1a1euCXrj//BNJJozDVHWx0j8ctXHDfSlCLRE/4MLbYTTFML/93?=
 =?us-ascii?Q?dQUPXzHhcT9P5AfEskEzexaFKTti/XTMSfeU1BYOC037YlencgYimiXLlw54?=
 =?us-ascii?Q?2VRFSD2UCwAwuu/wf46lhf2M7ttsCnvRTjJZQEHdWNzZrlaHBSoBZetp5pxQ?=
 =?us-ascii?Q?t09aESZa+k4DuqJabha+WzLzPH/vTMN+sd6gTZCiRFadUfv5F02RLiar8LvQ?=
 =?us-ascii?Q?eplnJr0N5RsB9om/NyXYpQ2sQdSTfUTuwHsugK2fPwdPjbhoiZPTprBsoZMN?=
 =?us-ascii?Q?xmJ2/IGfIajAdmWFpN4PmHJfHo1qLKMzp2AIJ23+AOb6Fao6C+Oj58JxubSH?=
 =?us-ascii?Q?PoC9eg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ceca81e-e276-4d19-ece8-08db40e8d248
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Apr 2023 15:14:51.0763
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OnPLKwjQdupoBfAZJc5r2Tqna14+4W6G2bJod5eo/uIQ1CPMAr5iAJw6iqSycFbp3Sz6xIXDfFUEt5Iuz3+Av00cn98pdK0GsPgCTrYCSsg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR13MB4706
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 17, 2023 at 08:19:33PM +0200, Christophe JAILLET wrote:
> Because of the logic in place, SW_HUGE_PACKET can never be set.
> (If the first condition is true, then the 2nd one is also true, but is not
> executed)
> 
> Change the logic and update each bit individually.
> 
> Fixes: 29d1e85f45e0 ("net: dsa: microchip: ksz8: add MTU configuration support")
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> ---
> Untested.
> ---
>  drivers/net/dsa/microchip/ksz8795.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Reviewed-by: Simon Horman <simon.horman@corigine.com>


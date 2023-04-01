Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D303F6D3317
	for <lists+netdev@lfdr.de>; Sat,  1 Apr 2023 20:22:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229475AbjDASW2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Apr 2023 14:22:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbjDASW1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Apr 2023 14:22:27 -0400
Received: from EUR03-DBA-obe.outbound.protection.outlook.com (mail-dbaeur03on2060.outbound.protection.outlook.com [40.107.104.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26C801A96A
        for <netdev@vger.kernel.org>; Sat,  1 Apr 2023 11:22:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CgAxNYXWpKjKJeco0heJBL6KeeSKpoutkd9cfMG7y1ErPI1159sdBRTgLh7BfJgCoqpH9V1igHQO8bI2Cmgr+66kMTjpX7qb5Ue/I0bKWh64pWOe+NXzUbUeK5qD8a7obnWaMdJ74gW1E6HD1tPsSgNgJK/fW4CrMKSie67rmTh+HWZFlh/TUhwzZS+NvV7G5tCeleB0wXJFPPPvZo9uOKt14uQjOf5z9RcovO7pFOJA/QMZ9PoZR66sk9NJ1l18jizE5dT5vdqRdncb6Z9Jh3q4Hheo/SUQ45vW3hYDqzbcRs9bvsck2NHO9bjBnoBfxtkPt+gQm0g8D4qOb/qCmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dWHxv2iftQzRXgio6s3xX/CWLC2TSAv9gMwd0XJaE3E=;
 b=UD4yt6BisOMaASJVwnArmf3ZOb1ZRkDZW0D1EmmH0rI1+6MyAY/KIG2J2tZJjFDYfzsxa7YW8Pk4L4Jj655FQNGdSC82h/fKRQQpIEf1G/ZMwVA2WT2Q9pUR7ToPTj2WEjUYClBxYkT4fQ3sXhQ9si5kTEhGV2JozfvngxUKmT6MnZc0yaMzsz96Uim6J8DSzDvh6EDKQyodEKeKdw/5mR8i74b/VnxrkwOXLBiK+RUq6iKT8/LnolB2KARywvJCHuzcmaWrABGbpa7kM6tn9pMX+9gWL9vvLfebDqhYnQh+Gh1na9HwJhyAKUCeLtQWRW0oiz27DSjT2nSfFXl4eg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dWHxv2iftQzRXgio6s3xX/CWLC2TSAv9gMwd0XJaE3E=;
 b=eguSlgQhl+nzprsMEkuN3/yPekN0XXSPWv6YGed6054hrB9jSc9w9yInvAB/fAQuWz0WzvQEAXSNC35nxmjl4seQT/+E6F9mMMT4XXNkirc51PbTGTmGH0GU45KvCOvolQLtc0wfvorGKoqiwNFlHojRQ+kwy/qnuLwPmHZVYiw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by VI1PR04MB7055.eurprd04.prod.outlook.com (2603:10a6:800:123::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.28; Sat, 1 Apr
 2023 18:22:24 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::dfa2:5d65:fad:a2a5]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::dfa2:5d65:fad:a2a5%3]) with mapi id 15.20.6254.026; Sat, 1 Apr 2023
 18:22:24 +0000
Date:   Sat, 1 Apr 2023 21:22:20 +0300
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Maxim Georgiev <glipus@gmail.com>, kory.maincent@bootlin.com,
        netdev@vger.kernel.org, maxime.chevallier@bootlin.com
Subject: Re: [PATCH net-next RFC] Add NDOs for hardware timestamp get/set
Message-ID: <20230401182220.u6g3246zvna4w25i@skbuf>
References: <20230331045619.40256-1-glipus@gmail.com>
 <20230330223519.36ce7d23@kernel.org>
 <20230401160829.7tbxnm5l3ke5ggvr@skbuf>
 <20230401105533.240e27aa@kernel.org>
 <20230401182058.zt5qhgjmejm7lnst@skbuf>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230401182058.zt5qhgjmejm7lnst@skbuf>
X-ClientProxiedBy: FR0P281CA0172.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:b4::14) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|VI1PR04MB7055:EE_
X-MS-Office365-Filtering-Correlation-Id: 4abdbd0e-9bd7-4eee-f887-08db32de0a2d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TwsRjlrdAKc9VW723Gl1psPvHoh/Qd6+Jm5dgGWj46YGgGBOdEr5XKjPcF4Z5zxPTpgKwThboY6OZgpT/3gqbqtNk+VMq3XPHgsSoVpk/JdFnij9YsOZ5CvK7Piy9NXjPqN8u/Ia1CtDsIJb8dq1XnYhFKcRLUAeLDM2z5aw6NwSYD6paTuHuXbUDjcDEx9VUIfnHK2xo4orIlDMEF79Poz8i0OXlB5gINJRgmdJE3sW24qe+D1EWYcCFoswmqsH/Cb1KpHArQ4UIMPjuQjLPBaxMCWyPdKCdquk+70RUPNeEo+seKvrT8a/9xmeOinFNkC/UUq6B/LASL5OKoOieVV5XAiSV+kRmJUTHE6T9kcdjCvdaQtao0rp6IyVkaPn0IdM5zAQhDvhrM9xSYPg28KXhfpwr9if1QyHuHdL2zTHI7/2iCXk8lHzN8NfiObIZr14Iwxfd9bVbgJ+GHGBTNXlAXfikozAGoWdYGeqx9kWsq0NyE5+6bZ/2i5ahgiqTKnMb4Vpk9qnNySNy2CSkNR+47a0OOWalWzWUxIM/fb4dK7p9BKh+ctvUOcSK3zh
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(4636009)(136003)(366004)(39850400004)(346002)(376002)(396003)(451199021)(4326008)(8676002)(6916009)(6486002)(316002)(66946007)(66556008)(66476007)(558084003)(9686003)(6512007)(6506007)(1076003)(6666004)(26005)(186003)(38100700002)(5660300002)(41300700001)(33716001)(8936002)(478600001)(86362001)(2906002)(44832011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ScKgVd3VpY2XCz5iGVWJiCHRamV7PKDEUpK6UEZvNjv38LVmlFfy9S/vL4v9?=
 =?us-ascii?Q?KJg1BnjN7QLCZp8SgNqnS1TC11cUim0kSMek9Kvgh3eBUGdjTWu/9DuqEpQJ?=
 =?us-ascii?Q?PWucEJfPTK0nM1fQi5FZQQKIlGIANDCE6rQbAavyqwT4o5i22owle3+pLbwO?=
 =?us-ascii?Q?pErX/UFN6geqfOeRICpFindyozRc4cdfCqEi0jaNsNmIL6ddFClMBxeyO7ov?=
 =?us-ascii?Q?B6oAkYRhQNbd0Pf4DP+cLH00wy+caYmNFu2WcvvkxjXYFqP/UpxhY7YNUyVh?=
 =?us-ascii?Q?eWAqgD061O2184zvvL7A1rMH+IhA0dIh52qlmDXMdUNp9LCx7tBeHtdEFEIS?=
 =?us-ascii?Q?Q9dXnzgOaK8ie++veSADXHgyw+2xaCQDqVLxtdnvh9KH+r8xEgDVH5xWV/v+?=
 =?us-ascii?Q?NDg1si345ntVt7nHJYhMWcOzcky0+Z48boTlORzeutajsTy/PglIGMCvQeC3?=
 =?us-ascii?Q?cYVEgyvJEzmzVb5WSUOmuMjN7mzH0Qn5dWPJjDMvtJFgQVeDSYB7J8c0mpit?=
 =?us-ascii?Q?zQM4HrFUWX8K/NhuIXd7kx0MG6DzZ2GDov241pIf9TnhSM/o0it9tnxK+4BB?=
 =?us-ascii?Q?fnYOMQPlALMpPEZk24ZSQSU1A2yBbTTNr+7adXFQh7n4UFgZHWPxDYEled4x?=
 =?us-ascii?Q?KCfaP+w7KcjsbqfsaqAnbvuVIzlKA+mcwPyd4HNhEcncdtu3cIxykli4pBp3?=
 =?us-ascii?Q?Jet3nlyL1y7U5d+4eplQXVcOPR+K4pWUqoVMpnJvv2/jseMboSU3UBsqnGuw?=
 =?us-ascii?Q?SoWuvFhA7c73t6toIcnBMJ1A6jskK2DZdt2ogDJ1Yk7KYAcdGgMpmJJD2S/8?=
 =?us-ascii?Q?KIqjO9aIbKCidSww1GoxlgwmNy4OO/zjfYCizf9SU59hweMH+We6tJGRa+ZI?=
 =?us-ascii?Q?gmgeGCOKyiwqYyULyNAvr85bWD2Y/MNcc1NuGMCZHo5ptjh6/UqB7sNBXCkZ?=
 =?us-ascii?Q?xUz6WQZmwqdoXisiFFy4Fklrzs2qivekVCTsnulRT551H5/M6jcJYWAFLsEQ?=
 =?us-ascii?Q?P027SEiAD8LWQPb1H7XJ239f3IeVFCv9HCD1INM7zIsBjEK6+2Cov9Q8Fw0i?=
 =?us-ascii?Q?7HEVwwqxl6/kGmEM4+nblt6aNmR4p6YPbj/4UUVwcYFRHqimtTL2bvQ2pMKi?=
 =?us-ascii?Q?+ddz2t95QlvZNsJ5MqavwxlhnekLDRE10KHOV5hgPfM43zin3b8NBSlUdomJ?=
 =?us-ascii?Q?6PztXLM4CVAhHw1aLVYy/eLoG81jQBi9ITR1wCdnNxG6AdIx1DQ3bIwCPHhM?=
 =?us-ascii?Q?yuOUrjdEJqukYzU58ZsE2nyRy14Wh7c5oRRdU+jX444R4DQfzt9GL4jenKb5?=
 =?us-ascii?Q?FJUrQvfzD4lHX3CVigxBqb85mNgtYBGxAZaXz8zt1mg6sAjcR0qkxRaFqkIY?=
 =?us-ascii?Q?JbtpufdBk9q44BQfd+D1+MARhieDHED5PW9iA6GeJcomT2kHFp0MzzEELNoZ?=
 =?us-ascii?Q?D8yVMTwP9Yt2tjH/RYRrcw8N5n0a9XMDOG6meHHhsqddx5aORCPegDzaJaXc?=
 =?us-ascii?Q?bOtdM9Cjs9bn7+bS35hYuNLjrtqJTbV587TP67pejMphpD147oCwmF2gk2UE?=
 =?us-ascii?Q?6d3xX0Hkkf9oMRRMvty2WHs721X1NoSRu3okvbIf20/0l5OaMtOqTIsJCwJE?=
 =?us-ascii?Q?ow=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4abdbd0e-9bd7-4eee-f887-08db32de0a2d
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Apr 2023 18:22:23.9405
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dVc2jlBBMIMoj5D6CtiqyrYGMb1etBBKbcrt5OmrFWY7fE1FBJH5SC6+VqITYzfPI8ehsml2qhNBby5gqhrPTA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB7055
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 01, 2023 at 09:20:58PM +0300, Vladimir Oltean wrote:
> I don't disagree with minimizing the number of copy_to_user() calls

from* user

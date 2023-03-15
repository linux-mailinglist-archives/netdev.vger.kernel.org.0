Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AF9C6BAA15
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 08:54:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231142AbjCOHy2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 03:54:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231334AbjCOHyZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 03:54:25 -0400
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-he1eur04on2120.outbound.protection.outlook.com [40.107.7.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FFE63A96
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 00:54:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xt7izf9QHB4KU7Hye7Og0M5H0oAX4ydGC8m3hC8xbI9ivMuqXc4hAG0ngBYT6HiKMEYpSyPE70+yRbG+ZSXcjPKpsqnmGTeOyePABUa+ei1jvY3M3aKBFlOltfmzAELNvyXZyXicO9It/OZ6jPAssSMEkFI99Bmb4+uk8gqxVTh8gspcohyxURVG522GFgPLrQ8KKuJGxFH4GGZT4w1DaEn++q9JI+N85/YEn5v9hKYTCGitGmlo2PKcikv+0hVXxVdNT6YaAb3VoCVYlC3f4yN+K0TjUAplkPrHDBWpPZDAV7bzgRcfW8XiXd4xwXWJDQHyVTx0QGl0w06DGv9FkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=O54LfVig4JGxreMIW2JYjs6bjMFB0C03LzPuTu3uNS0=;
 b=QGD30mdfjVU1HOcXWkJ/pjH8CfdVJn4RwZRY04l3r0u0KamDlFJNIh4sskdsAsViLNfS291LxHXXqhDzqgmP1kw+T8ADpD4NtlIfTRW9HXuBNxuM6w6xqMqYaWe7MfPwW+/A09ADVd1uv+0/eC4MjpE3tyVpWNun/X1YELKoF1Qtppyt+1cHnHy4C8KqF1j4nphnK63u9kTPQzsLcUA5XieUtwXLwLo9SbYoVA9oTR580HfIA4HTfZp1uoj6mUaJ78rlMtWL/oOm0htFhy/x7siD20rMP28T2M7HC8PGfcY5z40KjFbyD7podtFMLhJpsXk0tPSgY4HxGbckvJw4JA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=voleatech.de; dmarc=pass action=none header.from=voleatech.de;
 dkim=pass header.d=voleatech.de; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=voleatech.de;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O54LfVig4JGxreMIW2JYjs6bjMFB0C03LzPuTu3uNS0=;
 b=LCPdCwuATH6T5JoNk9Gl2/Tw+uoQvPH7WTKF0OuKQ187WuP4Deb/CzWr77ZYZn8gTYhQf29FKvvoyAMmvp6iKNzufQQ38OsjyvBGS4rHmXtIRGwoY9c+WHiY1t9ajLCHDhkI6TXDEr9wq0EjLzxmHGaf5yd+FCdWH6Y9nRx1rRA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=voleatech.de;
Received: from AM9PR05MB8857.eurprd05.prod.outlook.com (2603:10a6:20b:438::20)
 by PAXPR05MB9640.eurprd05.prod.outlook.com (2603:10a6:102:242::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.26; Wed, 15 Mar
 2023 07:54:20 +0000
Received: from AM9PR05MB8857.eurprd05.prod.outlook.com
 ([fe80::3fdc:3007:ffee:3c4d]) by AM9PR05MB8857.eurprd05.prod.outlook.com
 ([fe80::3fdc:3007:ffee:3c4d%8]) with mapi id 15.20.6178.029; Wed, 15 Mar 2023
 07:54:20 +0000
Date:   Wed, 15 Mar 2023 08:54:17 +0100
From:   Sven Auhagen <sven.auhagen@voleatech.de>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, mw@semihalf.com, linux@armlinux.org.uk,
        davem@davemloft.net, maxime.chevallier@bootlin.com
Subject: Re: [PATCH 3/3] net: mvpp2: parser fix PPPoE
Message-ID: <20230315075417.6q7wspgokuufo7fp@SvensMacbookPro.hq.voleatech.com>
References: <20230311071024.irbtnpzvihm37hna@Svens-MacBookPro.local>
 <20230315000043.05475d9b@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230315000043.05475d9b@kernel.org>
X-ClientProxiedBy: FRYP281CA0004.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10::14)
 To AM9PR05MB8857.eurprd05.prod.outlook.com (2603:10a6:20b:438::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM9PR05MB8857:EE_|PAXPR05MB9640:EE_
X-MS-Office365-Filtering-Correlation-Id: 3f6e3847-4faf-45c0-12ff-08db252a7c3a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xp7pxVQF491onYplkmVRIGTJ06iM96DvdVeiJYN0D0BSZCwB4Fp9H9xMN1iX5ArwRLvA6fNT1E2zetQvIbLqYADvm+A6yXKmYmG0ca4aFqCzGHP85JzcOresk39F6k1Z1O48TcnmNrBxSHObug1p8Ig226XjlBz7kK91yz4ye8yrgKcM4OXPHJbfn5xTXaJ6SFkn3K9Mg/HEOJqHLz13TZYYIVyJ4V8HBZk5WlglDrS13xhQl9VfkMqld7zaduMapqGfeLGXRpxzt/UshFLk82h2BvjsTJE4z2WNy6ng2u2iLdhq8E13ef/XxG4zBfHrG3RXsnVpN3xdXiKI1yp6o53u2vwFqGxQgL7Pq5MzaZKPegZR7O3XMAVehf8LbzUdRNG0na0LU1BQMG7X/8PQfhJ42fLfZszkQxTmwRqfDztEun3qjHFuoRRq9NfwwWA5f7YT49sykoKzy8P8zTpIjP6faTaP0h59P4ujXDParJ0aoYpy1aytTHI2oeYeg+KHl2L/0HfeK6IpiVvT/HCTl+mGiKNlX91qHQYCbaE/yT9X2y8FmZdVLGQ6CCLjgjrZ8x5PpWXagRWW9vFuzpYBK1G92gbtmh8cCnWVcgcFu6Zt591UOO7AgByxH/DqCxeUjhjCdp1VBdpkA8xlsy4s7w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR05MB8857.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(396003)(366004)(346002)(39840400004)(376002)(451199018)(38100700002)(2906002)(86362001)(316002)(478600001)(6666004)(6506007)(1076003)(26005)(4326008)(66476007)(66556008)(6512007)(8676002)(6916009)(66946007)(9686003)(41300700001)(6486002)(8936002)(186003)(4744005)(44832011)(5660300002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?E3VNWq/Bo1Mc8RfFEbdCNR53++KwpekbXCHYpsWWZCrmjhGR6QEo45BTii4H?=
 =?us-ascii?Q?WC4GJtmjLmuWycn1Nq7eEtViwHMReNlwvSbjrbas6QyLJJubVXm/0ocF06ha?=
 =?us-ascii?Q?FJMLP93mldpWCVQAGk5TKBoIp8nnQQl+ycoX/+CKsexGfc5pQ0oxZTas6OJC?=
 =?us-ascii?Q?Seq3F7TNl8VzzK1reYu0cW0X5+MHAworNeSghdgAp34UBILUb6e+ailaUdNt?=
 =?us-ascii?Q?SatkDiHnyXzC8wRjOTHN4BFLr3fLPNVMc1K5rdazoQRzkq0wnl1rnPZt6Ce4?=
 =?us-ascii?Q?Ocfx84PfMcZ25s42rADUbDJtO+ngylDWqKLCiV0CdDgJoD58FStFdKQfXQUK?=
 =?us-ascii?Q?vkNBhBNsQxUdJzSRsHRycb3peehJJQGimIcok51U0FDtsHd7jc8PlzaeJa+X?=
 =?us-ascii?Q?aNK8jg31IYug03Bg4ESCYqUgk01keRCfhJWeWLnhLTAVGJ/JePeyHeUhy/el?=
 =?us-ascii?Q?KlAlUKOK07/Y1pimB932oe30J0jk7NMRhxqclzgbEVJJXdzroDvFn+FetLCO?=
 =?us-ascii?Q?W7X6N/U/PUcMeag3ILRlPoxE6j41UbBlVGndGiiLrvlbxwhWI7SbVxW8aAf3?=
 =?us-ascii?Q?75d1Q4KCoGODFJwUQl9uhZr5e5PjZLb1P4LK8/XKSaZaEo/H4x3LSEYC+pBg?=
 =?us-ascii?Q?fSq9qONzOb7pWhr9FRqkbQh4YseIYRTlts9Sa3jbbzIaMBBcVih9MQehiqU5?=
 =?us-ascii?Q?AcuMjnQc2nV5ETLrx8RNJcgEo3ChwIQ6bFZwHXMA56a7/XGqKcoGYzjhkLlV?=
 =?us-ascii?Q?RzRpgL+dEBgDnhIkIAPlV7Mc0hLQZGCfI2xEl/2KF5lCOxRW6b3waZLHBBmU?=
 =?us-ascii?Q?P+zZ8+yHn7+6GXD5LZzefTIPzuDQ2Cx26mTrXZbZq0L9CkLilbzwe+E0jcDK?=
 =?us-ascii?Q?BFNzpQFxosqEEe3eJnEh2KhyCH5AcJwS/q++8XrmwMlHZ6T2eZJfVFIR/Fbm?=
 =?us-ascii?Q?e7BlfDgHhgWlCMz3Wpuw5AKnIRC3VGa7reTDzlewSbzmsT+wg9PoyPRkBVoy?=
 =?us-ascii?Q?d/TFmjBR32U2jvwEaWha9tlgdN6Yk81VRuxj2A+Lka3xho95HUQTHSMDYUzb?=
 =?us-ascii?Q?ADDgpdE7q2+Rg/haE8hT7Peresl43fz3WQX4rjV1GwyO3N8hSUKad1UiaTIK?=
 =?us-ascii?Q?nZOeQkrRGMCFomojgLKkX8eEgJqxeJ/0UaUrb1zXFOeEGSkpMV293UstiQVs?=
 =?us-ascii?Q?nE1ZUEUC78/iluGOCq05pueouMwaOjGwY5gwd4iUp6jTtV47L7bCt0AypARZ?=
 =?us-ascii?Q?E38Et+0jY+vQefOWPcVtaQzV2VK+2FlLydRiu6BRuVxN5qQAMvnueWCUgZWW?=
 =?us-ascii?Q?Vvf5gg0jwF4uGjVvRdV0z+IxN0EmT5RDCeJt9+x05LXsjM572WK4LEoPvXkk?=
 =?us-ascii?Q?X0gLdASAKoW6oE81hjee8xsc9Z3g8VbgKlZ6MsYwLjffHXbmUlUuDnPzqtHj?=
 =?us-ascii?Q?/cwlEcXnL2F0Y/+4eCZ9zr0Mo0uiCbAL/h3qdXSGSOT5tnZSlcE7L80UsSGW?=
 =?us-ascii?Q?QFJj7OKQYgAOP70mAdDgq4GIaccQC10J3AvXGN10ekuUYQmakMiMH8RsVHqH?=
 =?us-ascii?Q?qUC9f+C5kSASyUr0r6jtrUUENw643i/OnHMIg6xp3F70OeapcWQb4A1RPGq0?=
 =?us-ascii?Q?Jw=3D=3D?=
X-OriginatorOrg: voleatech.de
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f6e3847-4faf-45c0-12ff-08db252a7c3a
X-MS-Exchange-CrossTenant-AuthSource: AM9PR05MB8857.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2023 07:54:20.7966
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b82a99f6-7981-4a72-9534-4d35298f847b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sxZNngV+Pa6HsMHXU15Rh2nD5vlSUO4cpr2VQoAtPPPrOYT7CYrwC9ZyZC1UVE0ZrGOM1xtmfwuWHK0Ci5MF7M8cQES/c3DZH0s0uXrX3Ig=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR05MB9640
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 15, 2023 at 12:00:43AM -0700, Jakub Kicinski wrote:
> On Sat, 11 Mar 2023 08:10:24 +0100 Sven Auhagen wrote:
> > In PPPoE add all IPv4 header option length to the parser
> > and adjust the L3 and L4 offset accordingly.
> > Currently the L4 match does not work with PPPoE and
> > all packets are matched as L3 IP4 OPT.
> 
> Also needs a Fixes tag

Yes, I will add it in v2.


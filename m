Return-Path: <netdev+bounces-7113-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E7A5B71A20E
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 17:09:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 252EF1C20EEC
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 15:09:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7ECD921CFB;
	Thu,  1 Jun 2023 15:09:51 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C4142342E
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 15:09:51 +0000 (UTC)
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2100.outbound.protection.outlook.com [40.107.236.100])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F9E213E;
	Thu,  1 Jun 2023 08:09:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=miKQnn+Aa0qOsoWOLqplcPNY5AMCvatbykd7HlvGdqC5PgLWmqKOuZGDD8Zl0hc1teUdsHjTNSdvK9HDMA1tetV5kBLf3rSy/IlWwjQ+3kRJ4Sw9aP56wuWTLXvBCFiuyvGvwlDCtXRnd2K0txO7f528tA2uR5m6FFSD0TR9BO7R/PjPr/GCGBJQp+O3CjRpAybe7qwyAqUkWepbC3R3ZB0H2LenzXRuvzCh080eRLQprd6Awrlut7HfUj7pm3sk344wpZzbWgIDlUsTTbTwLlKxl6bsL6FWdCBuhbpNPzZuH8mx7WTiHKj7YT1EyMqX3Fb4zXvDYjCIr2FKEg8ung==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mXbKKOmhLoLJTjl5ubSlKCH3SaWmZ+Rl9XZdFWzo+Nk=;
 b=KJKKIjW/HoumYpVT2Ahmye9w3O3/8zdTwzrOQWpplgNKp+0+c1U5Fb9CixaZ87w6c3JgCx0DYq/XdgkjiMd72X2n8J8y1zHVepioWAfAFlKtU6ZHpMhSa5RWpvZYYkCReZKKojNts4UlNAAJB1FGGciHnt/LvfSNM6V0V1F06hZ7SzidBtZT4CuyYEpJatJ2+6UIUiAo9QUyJOJExxIW7wiioSmuUJ71grwUmBY5Y7BLD8OwtmswRaCsG1kiApY8PumoHahboD4og/IQukjbsR6e7yLhrvL6B8xxz6StQE61cjnQzwSg/ncv08AJJQBn6bovcd3SObkuRIoHoSawCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mXbKKOmhLoLJTjl5ubSlKCH3SaWmZ+Rl9XZdFWzo+Nk=;
 b=KhvN6uo+uhSksN3+j7nCE/VPNC8dPslrqB8YB1ApbtYFKgx1MFMLpIWIHoAXp5k9xHFUyYBbqaIMp4/Pguj8afE0V1u5iXvoK4qZLDDYjUHDRNZnWkfMRp/gQYziFz7Po0HaHcDEia9DoVYoyBm2pPXsxRrRqb3bw/N1ejmh66s=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB5517.namprd13.prod.outlook.com (2603:10b6:510:142::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.22; Thu, 1 Jun
 2023 15:09:02 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6%3]) with mapi id 15.20.6433.024; Thu, 1 Jun 2023
 15:09:02 +0000
Date: Thu, 1 Jun 2023 17:08:54 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Jiasheng Jiang <jiasheng@iscas.ac.cn>
Cc: kuba@kernel.org, davem@davemloft.net, edumazet@google.com,
	pabeni@redhat.com, davthompson@nvidia.com, asmaa@nvidia.com,
	mkl@pengutronix.de, limings@nvidia.com, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mlxbf_gige: Add missing check for platform_get_irq
Message-ID: <ZHi0ht8efLmgJTgQ@corigine.com>
References: <20230601065808.1137-1-jiasheng@iscas.ac.cn>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230601065808.1137-1-jiasheng@iscas.ac.cn>
X-ClientProxiedBy: AM0PR02CA0129.eurprd02.prod.outlook.com
 (2603:10a6:20b:28c::26) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH0PR13MB5517:EE_
X-MS-Office365-Filtering-Correlation-Id: 613fe8d5-a319-44be-ae85-08db62b22217
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	9GF96b8GdslezHu124uQ2TLZmg3KXnCQDKhakDMEdepCLZGFWy2Dcp4dY4TDX7iG7j1BaoUxozwBfFiyKDeD4oOkje7IyyZNziIwQCSr7Viu1ARLYiu3ZdbfUeawLRSx0QtFmrmn/KYdh9/WzfMAfe0t6/ZXpf26U/ND28QCAfVh7lNKq1PiHwIe4OeC5EGXDISHcavj29Ey6JickA/TtjnOAnnssVZAX46eMfhfckkI31nOPHW2A1GtfCz5x8eLiAJ4zkjhOjClPGYjmko/yryTTOU0qC4nQYcvXw3b8uoeIqjbDVZ3/gepTTcDVz1H7Piw3qfWZkcKrCUQqeK3BrODNZoISM+A23GQ4sl+yuMDw+4nL+cJIaZW5DaxfK9wEO00pl1nA/OE+8aGCVQuW0j6wEiOGmg672L+AsEI5SibYNcneOSCbqXv7N1y4tXNFu996viBzVdtkyay5RvEpFLg01Y17UZ/vu8zeMnmBAQbGfvJoxYLuWJY+cWaWbv49IdKJSXfVKA9TBVqsSLWOxqCM/J0mxc7NVwMwjGLOUlR1WSl8RTKVG9LYYgvbp96r/C+FI6VGpSAEIjK80a8ATQiGPMhuyXjUmlKLEE//zjZYxIE9D+DT2edn7pGmXMtC4x/aOmKinJb88xyi+TzdQ==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(396003)(366004)(136003)(39830400003)(346002)(451199021)(6512007)(6506007)(44832011)(7416002)(2616005)(83380400001)(2906002)(26005)(186003)(8936002)(6916009)(66476007)(4326008)(66946007)(316002)(8676002)(41300700001)(478600001)(66556008)(6486002)(36756003)(966005)(38100700002)(5660300002)(6666004)(86362001)(478994003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?pXcE4fY/s4+lisu/3k/2Uj2M5NW9MJ/8qJKwJVS9tJ2KjR/g13zXJafTuO6x?=
 =?us-ascii?Q?QRwPhSWXStAfHSoFNVoAEAWbWdUJhAg/k9dEFDoOZMp2XY0IoIF/ATmHB8Gd?=
 =?us-ascii?Q?G2xw6DsjK7BuZyIGdwXmpfc/HouRhbMIMcsSeqsrIE3oqt1Kff9I+FGijv9V?=
 =?us-ascii?Q?31E8KnoeVk5PWCgLKFJ0AMpgFvUt1XkRlTRQGoQBfiB0wcx6uhDbbcNvR39M?=
 =?us-ascii?Q?Qpyoiyg51JY9ahNbWH4JBxZKDqukf4W5Pne/4k1I8LYxIOW9rPq3Wlx5f570?=
 =?us-ascii?Q?1LhxFxJ19olT6blsnEf1EDXBtaSMUvnXMMJ/hN+DGwn5kV4ISCzngAMh9aNC?=
 =?us-ascii?Q?QTeAKQiBa3cNGV4K+O80TvgSJ6U/us6z/RaN1WlLSqLT+QjssmWKNNNm9UNo?=
 =?us-ascii?Q?sfV4EjiZYe4NyYpkO5Z0ySCvAIXG0jY37jxtFP9UOjDpwlfqlvIAvXu3LGtA?=
 =?us-ascii?Q?irrzPtVhtal03GK9qL6hqoRmNd7bkCFY4S76qlpqyGJ/tHHfYp3gEl0j/raS?=
 =?us-ascii?Q?3e7A+waFmAKUgzhS6Aua+za838yEcmA8xdCVCK07WBYeJwvKEIOEHjxvbB7R?=
 =?us-ascii?Q?xkPAvYV+XbzC6+QqcRUQDKTNb4q7BWKC7kW8FQi90c7ve1f4tjSJuZRa7Tbt?=
 =?us-ascii?Q?p8VjzCs4vY+fQh2GGi+BjdarUsHCw0cr6vaRTNOn0jhAaFcLBGYHmW+5LhtR?=
 =?us-ascii?Q?8S0qjTa2WI858AGk+sBwdSjcZ1I0P7zqLUYgKV7n8T/UeMEQEh6gUzG0DXom?=
 =?us-ascii?Q?uBPIz4tdZ9y1VkW4adETxqyzj9h69FWdlrJX/gA2PovLzbk+YuTriKT13C+H?=
 =?us-ascii?Q?t6+DMBRhZcNQmd0T23woUOKSB7MLoaDpN10VY/QgZY7b/yQeI1eJiNW/gIb7?=
 =?us-ascii?Q?UBWkEha6TwFOdHRzoqbM/kNH24U84X7iYT2me4ZiCTGTOcfvq1yq9k1XLyOL?=
 =?us-ascii?Q?/fyl9pyq4+dj11iTIbBy9a/OUMnVWXWVE0C+I1TvIz5VGKoVJ6fyNwONaevA?=
 =?us-ascii?Q?7t0fsWVwVgaJTj6+xZxtJaPJ3qHSm+A6Y53l8v7WKgu72g/dauT08DX1gUCA?=
 =?us-ascii?Q?3lAE9/E1DZi1EtsGkYA1tWkXJ7ZF4LGKwsE7MF7TC6M9KDEzguYbK+CqeDT8?=
 =?us-ascii?Q?sMqS4P8OOeMehQdDImod66LKbA5BL+6EqAV+4/DPPRI6L/OkP34MlJv2EO28?=
 =?us-ascii?Q?CgnusvIYKCJakX7M4FEm9VGnlQdmPxPWHqGGx3YOyRGPPS5U0lGvwwZrAJWy?=
 =?us-ascii?Q?WShAihuqaVRIvFyaErf2Oe+jOVPtgwoKA5XyieExvGL49CQJnQJFeMXjwx23?=
 =?us-ascii?Q?kt378lY9KDIsIfGAKxnRVd7yMtrQQ/gXC79QI/PJ8PsXXnaxbndtXWFq8sDf?=
 =?us-ascii?Q?87Nk3vnBA8SeAdxMj2y5GL9Miu8Of1Xl0zuwWCaV9K1wIFxPzVAm1IoUXQs/?=
 =?us-ascii?Q?2bg3JxjS71qCTNZT9eQlz8/WRZOSxHBjXvn7WsnY2mSPweGIeqwiPmhz45Ir?=
 =?us-ascii?Q?CTA4yZGiS5nVkFQawHDPcthDVGPX6ANHHaWfv9WNjPYb/6Xr7QONBDMHHuxF?=
 =?us-ascii?Q?3zEtewh0sozrv4HKZLAWpq67cwKCZREyl/sQrbTS8ZJbG5zIZjQNA+L9BdjX?=
 =?us-ascii?Q?Cg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 613fe8d5-a319-44be-ae85-08db62b22217
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jun 2023 15:09:02.2134
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zqDHSnrMk5tDeIlmw4rimlelDhu4GDS2DAdKoqlwDfJ2SKpw8io1hPuWriqq+HqWq1opFJ7qPfIcLTizNorHs5PYoDSgsujzKZ4Qlho2CYY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB5517
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, Jun 01, 2023 at 02:58:08PM +0800, Jiasheng Jiang wrote:
> On Thu,  1 Jun 2023 14:27:21 +0800 Jakub Kicinski wrote:
> > On Thu,  1 Jun 2023 14:19:08 +0800 Jiasheng Jiang wrote:
> >> Add the check for the return value of the platform_get_irq and
> >> return error if it fails.
> >> 
> >> Fixes: f92e1869d74e ("Add Mellanox BlueField Gigabit Ethernet driver")
> >> Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
> > 
> > BTW I looked thru my sent messages and I complained to you about not
> > CCing people at least twice before. Please start paying attention or
> > we'll stop paying attention to your patches.
> 
> According to the documentation of submitting patches
> (Link: https://docs.kernel.org/process/submitting-patches.html),
> I used "scripts/get_maintainer.pl" to gain the appropriate recipients
> for my patch.
> However, the "limings@nvidia.com" is not contained in the following list.
> 
> "David S. Miller" <davem@davemloft.net> (maintainer:NETWORKING DRIVERS)
> Eric Dumazet <edumazet@google.com> (maintainer:NETWORKING DRIVERS)
> Jakub Kicinski <kuba@kernel.org> (maintainer:NETWORKING DRIVERS,commit_signer:5/6=83%,authored:1/6=17%,removed_lines:1/20=5%)
> Paolo Abeni <pabeni@redhat.com> (maintainer:NETWORKING DRIVERS)
> Asmaa Mnebhi <asmaa@nvidia.com> (commit_signer:4/6=67%)
> David Thompson <davthompson@nvidia.com> (commit_signer:4/6=67%,authored:4/6=67%,added_lines:94/99=95%,removed_lines:19/20=95%)
> Marc Kleine-Budde <mkl@pengutronix.de> (commit_signer:1/6=17%)
> netdev@vger.kernel.org (open list:NETWORKING DRIVERS)
> linux-kernel@vger.kernel.org (open list)
> 
> There may be a problem with the script.
> The best way is to fix it.

Let's take a step back.

The script is here, so you can take a look at what it does.
And I dare say that changes can be proposed.

  https://github.com/kuba-moo/nipa/blob/master/tests/patch/cc_maintainers/test.py

I'd also say that the problem here is that Liming Sun <limings@nvidia.com>
appears in the above mentioned commit that is being fixed.

I think that get_maintainer will dell you this if you run it
on your patch. Which is what the script appears to do.

Locally, I see:

  $ ./scripts/get_maintainer.pl --git-min-percent 25 this.patch
  "David S. Miller" <davem@davemloft.net> (maintainer:NETWORKING DRIVERS,blamed_fixes:1/1=100%)
  Eric Dumazet <edumazet@google.com> (maintainer:NETWORKING DRIVERS)
  Jakub Kicinski <kuba@kernel.org> (maintainer:NETWORKING DRIVERS,commit_signer:5/5=100%)
  Paolo Abeni <pabeni@redhat.com> (maintainer:NETWORKING DRIVERS)
  Asmaa Mnebhi <asmaa@nvidia.com> (commit_signer:4/5=80%,blamed_fixes:1/1=100%)
  David Thompson <davthompson@nvidia.com> (commit_signer:4/5=80%,authored:4/5=80%,added_lines:94/95=99%,removed_lines:19/20=95%,blamed_fixes:1/1=100%)
  Liming Sun <limings@nvidia.com> (blamed_fixes:1/1=100%)
  netdev@vger.kernel.org (open list:NETWORKING DRIVERS)
  linux-kernel@vger.kernel.org (open list)

N.B.: The script excludes linux-kernel@vger.kernel.org


As an aside. This patch is missing v2.

  Subject: [PATCH v2] ...


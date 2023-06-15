Return-Path: <netdev+bounces-11014-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8FF7B73116E
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 09:54:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C1F691C20E4B
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 07:54:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A08A62109;
	Thu, 15 Jun 2023 07:53:42 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A10F20FD
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 07:53:42 +0000 (UTC)
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2100.outbound.protection.outlook.com [40.107.93.100])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1C712955;
	Thu, 15 Jun 2023 00:53:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GIEYhBfgf0d4VsvLD6BTYTf5KekwMNq2B4t3mnw8kOoziesk+SFOYg4egrdLcHy8zPN8gz6/bJEpGKOF6cx5B/pC5ClLm7/aq19XKT3m1+MVS3mWQWXvzOENtZ03wMmt5bcvMhZGCF0UbQWPe1Ogsk8rLotFTVdYE6g6IJwTae50ma3bFtrT4S3UYWEJuHARrcVOjeq0/DKU7GrSwR6lviG9RhQ7hznqPCvohzqyppQFqij7+91wmRkEzGVuBKiADURRitUiE5+aieuDe1cS4WTw2Vz3URJjVBubhergyeqjfqrPGTjCtuUYTfWD67ddgILjP/4iheIof7Z3pxxgQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DG+QFPoARYOFY+8QlBIq5dOtKNpJw6O+eXuwqBxSi08=;
 b=AW/60XE9pawfzHXAvZaLgfL9YLuy2kKvDT0gglUZuYQNqQOgi3lkmQR4xnT01FpxNxzBofRBkwWptQf6B1aWPSNNGHv/2EtI5wbuhOKRUFCJLZlk7aIRK3R0IRbKycvJ7eeiOIBQQoSbQyZMwRmuDepqVseQ/xEVIO0hjs/lKxgI373wk4QqhFyA3VdVXaK7I5eycEpc4ONMgk7mWBRPQJ5Q9mMEgQJ29i9jtnHYFwaOq1//BgYXOSy4JqQJhELHrRQWvew8A31bm1NzpSrJ3f0RQW7cPrVM7RR+kVHPTokC6dfhsjCZvI/+/V6QZjo95Nl12yqJX/kZSC2ImaFt5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DG+QFPoARYOFY+8QlBIq5dOtKNpJw6O+eXuwqBxSi08=;
 b=lNpxqEtWRwgY0oQNF4DpkvB4LOeRQJAY+haI9ze13hZ1uJG2cSM7O8cmuNxVxyybdMJaIMcn6IlV9JFxwBCwgxis6/cM96wAAl27m4j3Tp6TOEhZo8pcA9iE82jLofmYyHyLw6tBH+l1goaxxlzV+68aAwQcOLlBZy0XQTYPWM4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CH2PR13MB3702.namprd13.prod.outlook.com (2603:10b6:610:a1::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.27; Thu, 15 Jun
 2023 07:53:22 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e%5]) with mapi id 15.20.6500.025; Thu, 15 Jun 2023
 07:53:22 +0000
Date: Thu, 15 Jun 2023 09:53:16 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Stefan Wahren <stefan.wahren@i2se.com>
Cc: Stefan Wahren <stefan.wahren@chargebyte.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net resend] net: qca_spi: Avoid high load if QCA7000 is
 not available
Message-ID: <ZIrDbJzbBaYeCLUz@corigine.com>
References: <20230614111714.3612-1-stefan.wahren@chargebyte.com>
 <ZInxqMtr4Gk4Kz0V@corigine.com>
 <3452498b-b89c-c72d-d196-950520ed8c50@i2se.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3452498b-b89c-c72d-d196-950520ed8c50@i2se.com>
X-ClientProxiedBy: AM0PR03CA0098.eurprd03.prod.outlook.com
 (2603:10a6:208:69::39) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CH2PR13MB3702:EE_
X-MS-Office365-Filtering-Correlation-Id: 7e4f103d-7740-4dce-c6c4-08db6d75978b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	S3qAqnZkVIOzByDyB51GIuFqqh/XeumKy1g5Wbyh5I8ShZW89nRgGAAqcwfBP7vDtr0w1hTzVohxVomMY+BgHSRfXeW4Lpi/ExisJaU/nQTct4v1iYXYh1pzi/4redygnKBR45hV6un6S/YNosjia1zjC9Csjm/PsZI7WBZrJBeasgmZJTpcduFdHPYRaeCuNgb72oRg9uO7ta7Tio0xd5enabI1exw8Dm66yp3UgnaF36xhWelMW5jXNA/fIfCLfpOf5a1Q62oZlzzyVyO62hwx5xD7jIpzJtaLRMyAaIWpK6lbM4afyEwpXSo7bclydWosGR0Dl9f2f75AbCnDG/EwYuf8xQuCG2onQEYjPd4MmrjFfaYGBI3efaWC7n0nO/0kl/KVkuUZxwZ+sjYLGiQHcRlseUMvMkZD9ir+P81sDAxBb9KbFlcw68bt951acNb2Aicfay+5o+PBqjRpm9TqqZ2bp7pBnXHhlDP2TGJ9J3s7w/Ey+IXTlC/IARvHFwUXtXE379Hl8al/v6gwOVLaYMuJrDRIALpk9FmZx194Etxf5Qxi7BehKTBOEGHJzHIkd/C9zWQNqo9rkYeOdKO/FKW/Rl2DSye2dB++Z8g=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(346002)(376002)(396003)(39840400004)(366004)(451199021)(478600001)(6486002)(6666004)(38100700002)(83380400001)(2616005)(186003)(6512007)(6506007)(36756003)(316002)(41300700001)(66476007)(66556008)(66946007)(6916009)(4326008)(44832011)(86362001)(2906002)(5660300002)(8936002)(8676002)(54906003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?519kH7VqGPTL4VQIdZYmWZx+W3Nsk0c6TDrdPZft12mHKQLmAMeagSSFZyKg?=
 =?us-ascii?Q?UJP8JHlXTKBnjCt0uuyTsBo79D/apUAkj0ZXMVqPc+FjREfIzb+2P5C6al1f?=
 =?us-ascii?Q?yQ4nHLV4Mh8Q0Um7A/RgcquTrgwoe1TlNd7h4bpFHyybykSrfPrg3IUh/0GR?=
 =?us-ascii?Q?RKxOLYp2yJSCqK9DRZvF44tJugax9pEZ5RoiPL3xjDZij9vh4lZJkOCNxXV9?=
 =?us-ascii?Q?M1y/U7anm4sVL7I8iyukYjTSk1B/EIy2q+7m0DqxkuUMrgM4lo5Gu/ZupFj8?=
 =?us-ascii?Q?hJcjlm+iYbeZmfkAmVyj7bKP0jFdyY49mFiEiYeK2xUD9QUH46+BfzfCdkkT?=
 =?us-ascii?Q?qxIqaMTkFNOh7/EwwBd8yvDf6SGYyIn18temzJkWZr7eurF6uu0g7UsjOL5o?=
 =?us-ascii?Q?f/0Z7DGIokNLRvSe9GmJ0HIcJpYV/CHEJZ0EGW6/7WKMM3x8Cgt078ymhDuY?=
 =?us-ascii?Q?2mkzIz+xTbHo9Ue3ODE3DLsvN7CXja+PfOkw3xbdZJ8XqCVzLthRqot/6T6t?=
 =?us-ascii?Q?zY6A+ptV2nQonFlUNbP5Sr1MWPRkwb6X+VSMZ4E8WS36/lMOs6dUxROX72xl?=
 =?us-ascii?Q?tyRd7FpDt8t35zOJ2QfVvAA8e2ywX2nDY4gZYOckrGUnOhhT9dhuDCLxL2Tl?=
 =?us-ascii?Q?HAtGvRtT9TYuOV8BeqwcK4YoWIl5BCUMY6oy4iWZ+hwKLsztnfddqNjqfVQG?=
 =?us-ascii?Q?ovM+rtcODcwXwoQDwp7o5U/XaratrL3CYKaVeO31FfyD1pYaJiM7P7uTLO57?=
 =?us-ascii?Q?sgtAXdRLUpZc2e2JPFQcY3p+kHBFkDhFbfLaB6u42e8yf5b+W+JqAf9SMKfx?=
 =?us-ascii?Q?CW7Xz/grC1ntapU2u/grhh7+WP7R277BKMpG2BcqiMeIaaGnqagGzmBeTAa+?=
 =?us-ascii?Q?C7XJa3KczkrVTpXqFR7Plvh/UDbxnBL7BNeISvsuE2VSHuA1TK9eqBsbmi9e?=
 =?us-ascii?Q?8dA6du9+TO5p3RiF2pLC7EHCOyAYQdp8/7AKujRMqdiEkjEdEN4sAbkgTeW6?=
 =?us-ascii?Q?WAdOAkRGRvqK69qx9Cg5S95f/doteOYIjjtJBTvLyefUItDgDeqNSlP8n+dW?=
 =?us-ascii?Q?oot6Igcq/NKAvXNmFT3Hzwfkeqh/Z1SFPPoORv16ZbqXtosQIaZ5D28YRhSd?=
 =?us-ascii?Q?OsNupdlVcVfNVKimbUa0TkBr1dqFR2G1R6uHnAoGRZuLaa54vFEhgIbiGzkL?=
 =?us-ascii?Q?bGp25gA0pmFbKLDYn27xeNm1YolKWVePOygIAD43KS7vBUCO+SQS0F9tSUzF?=
 =?us-ascii?Q?qYzeGvDQMP5PMJ0Fn0KCYAgV88WEWKjdoIYaPd20vXS+AZlbA3zTvAqTJON9?=
 =?us-ascii?Q?MPSzvwQ2+aVV/bnYdYmcb2zYsCNZtNutXGjnccXsr4OOyNQ0LXXqna3HWJqB?=
 =?us-ascii?Q?0JQ6Q2betz2Aa0+SnmfWrDi28jb+sGyL7RludOKP1nu4YrMOvaZpo6uExN7E?=
 =?us-ascii?Q?S2K9UQfLRTzpoCUMiC9eoofoRrmc4Bkxr+BWMiV/m4JgSxsuOmKrRzaCtTqG?=
 =?us-ascii?Q?wplbvR6TwqNBlFZnQLF4k5IBs95HG9HVrDf4sSQdtZUD28ZMQg3SIfhEAhfO?=
 =?us-ascii?Q?Zt2oWB0OqE/ULlFL4ajnBmGfQ9oVXm2nZD+QCxCLQzVSgcbPz6Avv3pqEdyY?=
 =?us-ascii?Q?iOl0iB5rnhBNFKBBUs7ugBUjmk4G+v/5xrEHemS7MUZmAZVi3/9FlLJSy66p?=
 =?us-ascii?Q?rBepXw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7e4f103d-7740-4dce-c6c4-08db6d75978b
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jun 2023 07:53:22.5357
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ma0mQ9sLL3E1bYdS7LhdbXl52U0R1jVx99R3bw2mMRZPT8XbEpKa04r97Cim739anie/sYYxN/i0PSgQhOs0ONcWZRJqDQwW8Qd8tK/7b4o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR13MB3702
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, Jun 14, 2023 at 10:40:57PM +0200, Stefan Wahren wrote:
> Hi Simon,
> 
> Am 14.06.23 um 18:58 schrieb Simon Horman:
> > On Wed, Jun 14, 2023 at 01:17:14PM +0200, Stefan Wahren wrote:
> > > In case the QCA7000 is not available via SPI (e.g. in reset),
> > > the driver will cause a high load. The reason for this is
> > > that the synchronization is never finished and schedule()
> > > is never called. Since the synchronization is not timing
> > > critical, it's safe to drop this from the scheduling condition.
> > > 
> > > Signed-off-by: Stefan Wahren <stefan.wahren@chargebyte.com>
> > > Fixes: 291ab06ecf67 ("net: qualcomm: new Ethernet over SPI driver for
> > >   QCA7000")
> > 
> > Hi Stefan,
> > 
> > the Fixes should be on a single line.
> > 
> > Fixes: 291ab06ecf67 ("net: qualcomm: new Ethernet over SPI driver for QCA7000")
> 
> thanks for pointing out. Unfortunately this comes from the mail server,
> which line warp here. I will try to use a different account. Sorry about
> this mess :-(

Thanks Stefan,

I thought it might be something annoying like that.

I see v2 and it seems clean wrt the issues I've raised here :)

> 
> > 
> > > ---
> > >   drivers/net/ethernet/qualcomm/qca_spi.c | 3 +--
> > >   1 file changed, 1 insertion(+), 2 deletions(-)
> > > 
> > > diff --git a/drivers/net/ethernet/qualcomm/qca_spi.c
> > >   b/drivers/net/ethernet/qualcomm/qca_spi.c
> > 
> > Likewise, the above two lines should be a single line.
> > Unfortunately it seems that because it is not git doesn't apply
> > this patch, which creates problems for automation linked to patchwork.
> > 
> > I think it would be best to repost after resolving these minor issues.
> > 
> > > index bba1947792ea16..90f18ea4c28ba1 100644
> > > --- a/drivers/net/ethernet/qualcomm/qca_spi.c
> > > +++ b/drivers/net/ethernet/qualcomm/qca_spi.c
> > > @@ -582,8 +582,7 @@ qcaspi_spi_thread(void *data)
> > >   	while (!kthread_should_stop()) {
> > >   		set_current_state(TASK_INTERRUPTIBLE);
> > >   		if ((qca->intr_req == qca->intr_svc) &&
> > > -		    (qca->txr.skb[qca->txr.head] == NULL) &&
> > > -		    (qca->sync == QCASPI_SYNC_READY))
> > > +		    !qca->txr.skb[qca->txr.head])
> > >   			schedule();
> > >   		set_current_state(TASK_RUNNING);
> > > 
> > 


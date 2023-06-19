Return-Path: <netdev+bounces-12074-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0A269735E77
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 22:27:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 43547280F62
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 20:27:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 614BD14AA2;
	Mon, 19 Jun 2023 20:27:16 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D76CEA8
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 20:27:16 +0000 (UTC)
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2099.outbound.protection.outlook.com [40.107.93.99])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14C12D2;
	Mon, 19 Jun 2023 13:27:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UJpmusm4pQ40SdIY9bd3zzltd4SuxP1nZ4d1GYmNopgSlWMfjQoEpMy1sbzIhB2X/l7srsAMzO8WuKFILv8rvDvTdZf0zkjYym2yv5hpM5goBKN2NniPLz8qRWtK5ETOVTvvA6zvkr2InW6cKLl+ezzlkqC+mPOa6mlLoCerDdGOHPsWMw8znZY6zaT+0kK6UA+1+ZxxvHC3RZgDkkDaNzXlV9C7GQo0G4tfJSszVbmj8+KCUZ8eb9JNaQjhGQ9KxUifACzyy/fPNr7lQ9mEn8ecqPe8u74qjeSeebqHHYjPFFlMooqgCz9dS1d+dkEdMCMG4yn4gQdHGqokzK+kKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HevRcZ0tszKIa2+bUxaw96zPKBv2Aviw7lp3sgLHs1w=;
 b=XGOnVvPBhzesEo7x1d0V1B1In0KqybALS7OJybgo9vOwKHWmPpl666YuOnASv7POlkBihpcOYMMZJqr7/UWvbySMzd/fJy6IxVg1r92GB8aWj0GcuWltvHTjgiWmhpRo+K74SaHOkGuUMOWe4PU7I90HkNwvAWY2EwVeCoSoYNLWcNg5G6hB1919xDW0XLYZrrKSifLnwZdGlpBxr3AvX6Bvwadz2S0rV5oAokrWv312TEra0aBy8/XGbGI6xBzc+3KZ90qjua/I5RpAanWAfSUSjfF1Vm0PiVmz+55hF6v+wuUqZPeapK9V4K71xZtuuPT59OGDH32tS7UqCAEQTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HevRcZ0tszKIa2+bUxaw96zPKBv2Aviw7lp3sgLHs1w=;
 b=a9TntZOYMH4rK3mAl9WuGcW5dVVHni9va+YuwNEWkZJ7XItaHc3TORFgFC787Dkz7LcA7nt6p3JOA1EI9dcejCLx4hmCn6QbNCsO4FDT6bNFVDPJTCaE5s7W7YnNb2MGicYTR33wXlhxIe630Q20DyulAJ7oXU0IWW69AovXOfY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CO1PR13MB4822.namprd13.prod.outlook.com (2603:10b6:303:f1::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.36; Mon, 19 Jun
 2023 20:27:11 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e%5]) with mapi id 15.20.6500.036; Mon, 19 Jun 2023
 20:27:11 +0000
Date: Mon, 19 Jun 2023 22:27:05 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Christian Marangi <ansuelsmth@gmail.com>
Cc: Pavel Machek <pavel@ucw.cz>, Lee Jones <lee@kernel.org>,
	Andrew Lunn <andrew@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Yang Li <yang.lee@linux.alibaba.com>, linux-leds@vger.kernel.org,
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [net-next PATCH v4 0/3] leds: trigger: netdev: add additional
 modes
Message-ID: <ZJC6GaZO7DgdMmIv@corigine.com>
References: <20230617115355.22868-1-ansuelsmth@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230617115355.22868-1-ansuelsmth@gmail.com>
X-ClientProxiedBy: AS4P251CA0027.EURP251.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d3::13) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CO1PR13MB4822:EE_
X-MS-Office365-Filtering-Correlation-Id: c6da2f92-0d17-425c-2dff-08db71038fd0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	OOJOOt8WtMgT0egIfiE50LGWbXyXn25K+8JefuZ4YYNQBMYgJ1+7n18QwfNQcGRyNi0rTEVZ4/VHu28DMp2Al49rLqECl/9b/+lWGocBSTkLJpe9v21ZU8rIYQmej2XtgYBza5MYMXz8yQoYhK5ClyO70pKBUSK/r+HN2AcLR1sKjgGlIyiLqIOUXVo3gjfMbThFcTA7GXu56HjCSwXxUg4FGGfXmD3sIEWtJhn+w/NQW1BT0Id2TKi2OfPb9eoFoG4o0MobD1mvrjlXqSU5TIOWbgilY1WDWba9AveBNQl2pIJ2U2jfHs7GqUJ4L8yb5bJuzujekMGZpXt+eDyzVRSeNfO3FM7cZy74TIp4ZlH2sHetrDyeK0GWyA2io/WduEZACE1YXA5w8RtcU/WQZ4QkSvnQIo2h3bW8dXVO9Vuq0C6UNyJJakVRt56PWOkCnwiQr1qdI1gSR59zRdHyamnsyOC0p/oOUluz4zSkP0yLBELwmLUobom/VM2v06qXaN5bBh+IW3C8TCKE6ftyaZ0SHOwRGoDlJycYqLPAENa5tHQAeMvWK8XkZqlYq567+FVq/WT4tG3SmJj549lx/7pJ0JwEPmIUeg2lSiPIK4M=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(39840400004)(136003)(396003)(366004)(346002)(451199021)(2906002)(41300700001)(5660300002)(44832011)(8936002)(8676002)(36756003)(86362001)(478600001)(6506007)(6512007)(186003)(54906003)(6486002)(6666004)(966005)(66556008)(66946007)(66476007)(4326008)(6916009)(316002)(38100700002)(2616005)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?75hStyMPx2dgK8g+gJkclu0b58KvCeI86SFWzcM9QdEP7ldqMzhYXNR2YQ5X?=
 =?us-ascii?Q?2G251CY8uC0PeGTor6Io8jtvg5RioG/K6OstPbjj/mWpRDIM8083Bmo9EBWP?=
 =?us-ascii?Q?pxczwHp4GDVJbYqEhjXN70GK4j1Yz8XTgMVVnuttGj9BU+AXnvbLmjogKkVW?=
 =?us-ascii?Q?QCX/N7MhOnzX68QT112IgW43dg1+AapaCHUVSZBI9rbHNrOD5Z6pXVoIugsD?=
 =?us-ascii?Q?uTEmvaNMzDPB9YZqtC4raXq0Ad5rzJY59ljGKBASFvhsDBin+NBQBNJAI6gl?=
 =?us-ascii?Q?1mmJae2A1+gufPFuLekt7a9dVVt0kiJsB8IlycPVhssu9/Avqh0eiHowQPAe?=
 =?us-ascii?Q?eICzLq9Svfc+MAYX7IeL3U5LkVLqDaW3UCF3Sg4eLF5yXZCjHU4DL3F/FugY?=
 =?us-ascii?Q?JnO+zx1EYyj34UBbhgdoZQombA9rUe4yJ+Kxp1qZok+LhFzcmTE8Fu1IboW9?=
 =?us-ascii?Q?ag/56jgz3IuCF0HxYOpbgpvmZBMGikkk/Q8tQIYYg5el7nCoSSCtZ2mIEV1b?=
 =?us-ascii?Q?nxpCgx8IBPTWZ7Ag37gZqvrUU/4dbIEc+BHADntWmgium+lyZund49hsC3Av?=
 =?us-ascii?Q?0Ysa6Ae0kaXXcu5OwbVs7uV3S2t6219Nul1QHoxhLDCXhYO7qc7hbOmS0Y6+?=
 =?us-ascii?Q?VCpC3V+Suns6uJVevswfgBLfp96O6mV5XtinJGtkUvmxKKsccFNBDt4OrgaJ?=
 =?us-ascii?Q?pRvj1LO3ZXvCZkuUxDGD0vW8wigjTjDLeMvtkUrJnAyCkUJN6d0zGtDcIVPD?=
 =?us-ascii?Q?RLBh3fAHts1imW5F9hfOlRpLFiXK8Oniq9+aIrkqJidUpbpro+i2LOhy3Glf?=
 =?us-ascii?Q?Okp+3FxrvDdiUjwtLJjNAionme18hxWZFpjzj5K7CEf8YbbjV7pGZ2GHg0jR?=
 =?us-ascii?Q?sDEnIbEuaYu3UTO0b5tlzoGU4zQCvQL78jsDpDkc6L3wy/MKgLvUuYg3SNmp?=
 =?us-ascii?Q?Qn/NpcsNPRMew0cgCM028p2zHmESrrjhEnA/XdeYC73aOSln4y4ANEaaW+oc?=
 =?us-ascii?Q?8tfhPvthrCb47af31+MS7hXIqFJcc96A5cN4Lo32ZmpcZQrsDWsu+e4K1p9B?=
 =?us-ascii?Q?vLzJeEkv694Cvc4UDXfwE2l8noucUtrE5aF+fWtdGq0e4HCLRG71ockBQF18?=
 =?us-ascii?Q?Q1cZCKhvAm5jH6zOfYvUAbhM1aQh9PkpjZTBKGS+SpmOE6S13/uWhNccTIwX?=
 =?us-ascii?Q?CNg/KH9jObxrLmWF1+J0BAw5mMhAhw+wnX1l9rHd6VAVWjeHiYnqTDwzRXwr?=
 =?us-ascii?Q?qGIhj4VkabuJBTwC0KdYdhtkQBiuknfsys5PTZNwEbiKMYcpqo9TSAlUH//G?=
 =?us-ascii?Q?9WLpvwlp/L60FNLVvgmfkHmA+KA9uJ9URdQYieIPSqewccVHexJeJ6Qf5vbo?=
 =?us-ascii?Q?Pj/MBxL2J91DPfqR6f8XFGJEBsviW7aB1LEINgpMzlycAtZUHvhxE2B11zmP?=
 =?us-ascii?Q?v5YO6PScnetn/UqVIRaMIGgvVpsAOLQMI/mcHWqXfp80kvi3W6gbrW4pX+DM?=
 =?us-ascii?Q?rjN9tThdOtfa6LfDA7blmFjVA7F8vVUjfUszCEfUhSm/9toDBdz4d3cnORCy?=
 =?us-ascii?Q?PIDOB0Re3L17JzzwqcNpUQ/JGpLIDID4tF4NutzkSruJs3DBRSnOOfKfzNlf?=
 =?us-ascii?Q?m5YUuExX5LR1lPJdxw7gKB3JbX2unOslVIK0i16NtycBDQUf7PSMxoPxdA1J?=
 =?us-ascii?Q?4ZiW7g=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c6da2f92-0d17-425c-2dff-08db71038fd0
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jun 2023 20:27:11.5805
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: X3ezvm4pJ0H9Mij5Jbv68tlSrupvcKxnhgmQbqBSRArmMt/6+lXnLhd4rU+2X/mOxDQ49HVkP9Mg5fgbLE5lifDogjuFU9AUBtXnDGuQyGk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR13MB4822
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Sat, Jun 17, 2023 at 01:53:52PM +0200, Christian Marangi wrote:
> This is a continue of [1]. It was decided to take a more gradual
> approach to implement LEDs support for switch and phy starting with
> basic support and then implementing the hw control part when we have all
> the prereq done.
> 
> This should be the final part for the netdev trigger.
> I added net-next tag and added netdev mailing list since I was informed
> that this should be merged with netdev branch.
> 
> We collect some info around and we found a good set of modes that are
> common in almost all the PHY and Switch.
> 
> These modes are:
> - Modes for dedicated link speed(10, 100, 1000 mbps). Additional mode
>   can be added later following this example.
> - Modes for half and full duplex.
> 
> The original idea was to add hw control only modes.
> While the concept makes sense in practice it would results in lots of 
> additional code and extra check to make sure we are setting correct modes.
> 
> With the suggestion from Andrew it was pointed out that using the ethtool
> APIs we can actually get the current link speed and duplex and this
> effectively removed the problem of having hw control only modes since we
> can fallback to software.
> 
> Since these modes are supported by software, we can skip providing an
> user for this in the LED driver to support hw control for these new modes
> (that will come right after this is merged) and prevent this to be another
> multi subsystem series.
> 
> For link speed and duplex we use ethtool APIs.
> 
> To call ethtool APIs, rtnl lock is needed but this can be skipped on
> handling netdev events as the lock is already held.
> 
> [1] https://lore.kernel.org/lkml/20230216013230.22978-1-ansuelsmth@gmail.com/

Hi Christian,

I am sorry if I am missing something obvious here,
but this series does not appear to apply on top of net-next.

Please consider rebasing and reposting.

As you probably know, you can include the reviewed-by tags
provided by Andrew for this posting, unless there are
substantial changes.

-- 
pw-bot: changes-requested



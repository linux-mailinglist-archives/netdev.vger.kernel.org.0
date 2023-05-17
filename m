Return-Path: <netdev+bounces-3257-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 01B97706409
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 11:24:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A55B51C20CAB
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 09:24:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9EF1010967;
	Wed, 17 May 2023 09:24:12 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 850E85249
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 09:24:12 +0000 (UTC)
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2107.outbound.protection.outlook.com [40.107.94.107])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F3C31BCA;
	Wed, 17 May 2023 02:24:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MgSgTlTBBntSM66BIa4ZxV77ORq0ARqCxc5JkiOB5yAZ9g8dqjBlscd8EBgN6TVWgVY2A41ahgKIFzdcBSJQ1QHjaHe2kAAGcF2RXdJLXhJVfEylQMA8RhLAINYHhYokcnpvGST2gXL82KCdNZApDXYwfmtnAfaRmTOJydP9+BkIJpvJk0ZoVaw/TapBU+3oHBVZGO8a8+UuIf//tpfLpfHC4QQoWX9xDJFE07D/O4lj0H/SZoeQVBWOzhok63JZgdWGwYC4kNYs6k12juOJ+xleykaej1iJUVeLVYV1JQQQXpZMmn+JRf9AFlcMQASM1aHWGRMNj28DSAwGgpS1Vg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=y5ca8aR54pYCwXSttAQWqHJ/XFWWSw72owOYLt4cl0M=;
 b=T5gkI7yagF0kcdknyhryn5Qdd/8+b61bg6XV/5nPg1dz0Woeef+xTVwcJ+DgquQqar5dc7MP0kFge/uwGEbbyB/Kf0wtGppEvCR0zcOhQwGWI8GFvfmq8ecdSLrkf1HyKKjo734Ds89Bd/SrjwHpv940bmilXHgi9mbquhcSmBzWTPrGtLNndeUqeRMjC2sK3vE7j3v9zYJt1nnmIII7D663lwEzCVbV/T9YsRXq/np29JcNiUvHCF97S5lFnoz6qtUafTqQwXEh/ho39jzRkBWg6FrX4veL2IOvrXQKkFNSBj52/62iS0tKpsLwj/+4cZ3DjTGBXLmnD3BVNTJoLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y5ca8aR54pYCwXSttAQWqHJ/XFWWSw72owOYLt4cl0M=;
 b=AeRImus437inmxWNsQ/vQneaLQDms1S6PBwgGN9B1KJlhClPjjo2cMp6ZXcfQXzwdP8dpB7u55kpjYGHRXPuRq1pZmURxXuLYH81To51/ERhm9YbtwJ+WvoxY0x7CvDJxHBVHDNGBQ2Wu8jiGKMLSaX2J8x55MtuJVXcqZINrXE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by LV3PR13MB6359.namprd13.prod.outlook.com (2603:10b6:408:19e::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.17; Wed, 17 May
 2023 09:24:07 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6387.033; Wed, 17 May 2023
 09:24:07 +0000
Date: Wed, 17 May 2023 11:24:00 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Florian Fainelli <florian.fainelli@broadcom.com>
Cc: netdev@vger.kernel.org, Doug Berger <opendmb@gmail.com>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Russell King <linux@armlinux.org.uk>,
	open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next 0/3] WAKE_FILTER for Broadcom PHY
Message-ID: <ZGSdMM32YnloAlIf@corigine.com>
References: <20230516231713.2882879-1-florian.fainelli@broadcom.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230516231713.2882879-1-florian.fainelli@broadcom.com>
X-ClientProxiedBy: AM0PR04CA0052.eurprd04.prod.outlook.com
 (2603:10a6:208:1::29) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|LV3PR13MB6359:EE_
X-MS-Office365-Filtering-Correlation-Id: ec5c38c2-3700-4f7e-0f17-08db56b876ee
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	lNBfOh29Oj3H5mxqUptfWcRMs36tGXTTYmKumXHogt322Iyn001+zXiylmLSAd7L4HNYMc8HMHjB1asF3x9UapObQxaWPr2730grP/9CccBQM3YlOyo7gnyDpWq9tFgR0oUaaCtCQgqrgCxJP5qq5hbNNw8dZqAbSSV/Yvtz0z+loU/PKi8AIEC46I7JS/T/udqjqciQzgHJb0uKe+7BbjUGk3EabpMGbKsGcV8O4C+9hKf8WptAD/gX0HrwW/Vgzpn2yi7AE581N5hpUyk/OiFGcLEluHwYCXb22QpBLkFn9mP5KZGZybxKQyy2rDLu3zVHGyJjTauIPt9Yo/LRyuhjzNttX4JECQrrp5NdB8J1rV8R1sa/YexlWTRUYoPoiwDh7vGrlUMqBIbm22B76aWY83BlK6kejWvNbmpash8ulbhMl38KYoX6AKFsJ2uNRQHA/MOYBn9Q/P34+QWc4N37LSIEl2m6OXpipnIYgSXfZ1AQGLLvX4sDq1JihEd+XsaNOwcrHKyfROgxi5aeSNtmA9a2wH/IMpRpddGAqF5QJZkxBHNjnm2yGCv5hz9h
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(136003)(366004)(39840400004)(376002)(346002)(451199021)(86362001)(36756003)(54906003)(66946007)(66556008)(66476007)(6916009)(4326008)(316002)(478600001)(6486002)(6666004)(8936002)(8676002)(5660300002)(41300700001)(4744005)(2906002)(7416002)(44832011)(38100700002)(2616005)(6506007)(6512007)(186003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?1S12yPYrPfilDe1f6xySGZ2G4m8SGbXJRyN145xMkEigHr32JbCWA6Y8MAyz?=
 =?us-ascii?Q?tZIIV/rMZretySfXz121SrMPDVAgyzZ2LUeB/gpL8Egs0zfSr+Mw6GunS2og?=
 =?us-ascii?Q?b5K72Dxt7GQOyVcYwuSwZIf5XRzqaRjaH8DbTE96Zx0gzHYJNdPbaNlZQU65?=
 =?us-ascii?Q?ZrnUGOTePIzGGfwTVPYXKK5CF1x12wmFBHRsS4S53N//krGrZke0MJgZDlpA?=
 =?us-ascii?Q?KXrkYhogfsESU3qEnnTAagWxRMkGQzQ9pj+ct+Kn3RJI5kuqZOR7tx0V3D/0?=
 =?us-ascii?Q?k6CEWdbUHNW8GHmdHOTUx3045r3yeJAV7M5PP5H9oLRm50zQhkT4SYA3/ObY?=
 =?us-ascii?Q?EylUGGHMn0yuDSRVNt39dCX21YTh2yoz6PZTV9iaDyIcNAJjhZMGfHablUn1?=
 =?us-ascii?Q?Zijt4HnQ+5FCgPMbp93roR1+kMTo5VE968zeCZe9zbwJ1lPsnxm3Ws9HqZ54?=
 =?us-ascii?Q?2dzxbTL+7323rberos/qfwHJvuhlZosWYJbZNWrzc2dfNHZ4bi+1E+OxVK3J?=
 =?us-ascii?Q?6zEb8CxqGzblKA4ZnkCcGbUgQHtydijM8MzoclTMVI+j5AFBFktHWWJ8r4UL?=
 =?us-ascii?Q?wZ7UcpJL7dg/iUGh7JaIalSKf9N5bbSk9UwYyzWMQg0olNOFKVcmMOWmSOLn?=
 =?us-ascii?Q?E8J8PxK2Ag8bifPKSClNtn4STBIuM2g4hQ4NBJMByFt6LaQ4/HxCyrvHRxOO?=
 =?us-ascii?Q?5yws3NHyv3MIjtFQvNjPJnpe1eE8s+9wGBb0lR6afY2haPirdZNnqeu+KmX6?=
 =?us-ascii?Q?qZvmNzAEa6GKeRXBmyTABeQ5sseJ1eGcPCgwqLNGQa1eBVxocQEX5sVKBmAP?=
 =?us-ascii?Q?pkn/1IZHhSvYrhA+GQnci1w/BjnI6CVlB0WQjgA9KcfVvzLnaZ2L5xGkLnEt?=
 =?us-ascii?Q?v9L5ZAm7klgBjYxxEEyRS5VOXMW6lu79D/A6w9zXnQppBw8QWuYUrNGzQ6n/?=
 =?us-ascii?Q?AN8WWDsnrSuGJkyZHbjuMSqbhWMC/u9KatqIoXC0x8XcC9tQtP8GS8VLAhjv?=
 =?us-ascii?Q?7se9Y7njbwwRABOebSTwYqcRBX9SLhNDdTbLuxpWuIG1zaWnhsz0fsHzR22D?=
 =?us-ascii?Q?45h1acEQid9jsCGIgoI5I9jsqnbb28xYmw0lMF1MkiwVlDJxrwaG682pXCml?=
 =?us-ascii?Q?hLmx+VtwpWF1XhwLQftOdjmD0w/TJ1cKvgNDwJgmK0Y31J0pz5oaMUdAHbmd?=
 =?us-ascii?Q?VLP6EKBe8fouSEIiLPgqjSQ0ybSF/BXaxj4u2R3Om9DWNts5Z3w+XwigwmnG?=
 =?us-ascii?Q?1nudfGurs8p/builtV7YYFGW01z1DOaSzFCJJ4epbcPg93LApos9Jj5FW0Kh?=
 =?us-ascii?Q?dBrmpQp7jOPJnwlpPxUhVYGikCsVGrLIunLJh1nj7NWIV04bl+c3PGI70p4x?=
 =?us-ascii?Q?ldyopvw73sa6oOgSOPRBGWTUatIha2kpDPI/+XDH8eSDejdqlppNPTn0HZOL?=
 =?us-ascii?Q?BkxucrIKNfUcvsOgP6ysfz+0O40kOQ9qf1dV+naeS+aJPUxh5AHHhEXIsgra?=
 =?us-ascii?Q?BeuP80n6s4aLaP3PJqefanwY7+vhBgZs+a7gmY8fzqx3FQvCL88n8w4zbS5S?=
 =?us-ascii?Q?SK8NupVC3NhhtegbQv1aRKEkSH5MhLImNLh2wAf2swoCrSOEj+ko0UKt1IfN?=
 =?us-ascii?Q?bGZiWy+bbTOt7vSnntnSUcL1JBQ/9v9JIhMmpB6jnKdhHeq3gbuTFRwXKRVL?=
 =?us-ascii?Q?ePX3tg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ec5c38c2-3700-4f7e-0f17-08db56b876ee
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 May 2023 09:24:07.4661
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5WhYO+po4CBfsK0IErDHQz2LnL9KQQ2ltR7OwjSh7QHq6qC9VDhxy9KSEjyveDFcQFtxd/QZ5coDTWdtnwPyLk8oRQW2yajfib3EZo0jUJM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR13MB6359
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 16, 2023 at 04:17:10PM -0700, Florian Fainelli wrote:
> This patch series adds support for WAKE_FILTER to the Broadcom PHY with
> the narrow use case of being able to program a custom Ethernet MAC DA to
> be waking up from.
> 
> This is currently useful for Set-top-box applications where we might
> want to wake-up from select multicast MAC DA pertaining to mDNS for
> instance (Wake-on-Cast typically).
> 
> The approach taken here is the same as what has been pioneered and
> proposed before for the GENET and SYSTEMPORT drivers.
> 
> Thanks!

Hi Florian,

I hate to be a pain.
But this series doesn't apply on net-next.

--
pw-bot: cr



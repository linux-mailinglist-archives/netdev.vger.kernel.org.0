Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DEA8C16BB29
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 08:43:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729607AbgBYHnu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 02:43:50 -0500
Received: from mail-eopbgr10079.outbound.protection.outlook.com ([40.107.1.79]:39781
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725837AbgBYHnt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Feb 2020 02:43:49 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iFSfrvhsBTgH1lpv/aplhQaLYNNw9ZdxEQWUggdj2zKCA+NcEAUe49yNF4Xotm+MfIzf7KtcBTi/GuxaSntJrssu+3D6vT/OKmZefVHvfWmBmE0xnOj0oWyzuGdT+VOwT0uQczMxsRRkRZP0GmqBblvLvpdiqtOBBVWKf/EYMQeZQJHlxIKyh6L6m/PLeL5IZhyVpIofqitqj2AgpfZFOdWvT6mScIASlQDb6+6OZ2xBLxYwoRtjLdle+7GrLt8DyZeJ0xPQo50IWeKcmy/inZ10/6du143LdUO9f+WpBRGyBfmHHDCnCLltZxtTZO2rPsMxEMretdmVWT91kraxCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cYKAf/7XmNkyMTt/YKnkO11BBIZuyBa/WyYdPoRJKeU=;
 b=A224SpITi9FCwLgYUjph6sGoVG8yWNoCZOmU/9o0RzNDAzLo/EHKv010t5qvoXrJelVb9JEAmwu44ZxxOhOMtt+XKPbJzhPhbyQUa64p+TB7K32v37vVwWJZpQfQaJnP4okrs1CKw9Q7Nqm14fqfxoMOCv0iC9TBUKp/mhV5inbotIVm/Ztv8ihmwV+yQkSB6eHPeQebSlHTfKHC1yonhN3v9+9LPXSfd4OUV1s/DQSjM3BZTRfuJ+tB+TiGBSzXJpa5YYeOKYsJFnPG2u+fMsxtZspoOHoFjh10jBSwacSWBywPSA5TxIgQEjSjfXws+bxo7tPw+yKwkuJ3JP8zHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cYKAf/7XmNkyMTt/YKnkO11BBIZuyBa/WyYdPoRJKeU=;
 b=MI3MzjcO72jimTkSL5nYAxnuyswe670XcGt9XVXk+hGGv2Vvox9IO3TTMvVnRT5sEMXZOdv/dsULFCq1JVyg8IUKR35k8yp+vUgKnDZwXTqWUe2fYK9KWB86lN37d1vzx3eJOoqe+tSvmOrIkJ4SwrlAnogQcakOmEgoFihAvAw=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=leonro@mellanox.com; 
Received: from AM6PR05MB6408.eurprd05.prod.outlook.com (20.179.5.215) by
 AM6SPR01MB0033.eurprd05.prod.outlook.com (20.177.117.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2750.22; Tue, 25 Feb 2020 07:43:44 +0000
Received: from AM6PR05MB6408.eurprd05.prod.outlook.com
 ([fe80::c99f:9130:561f:dea0]) by AM6PR05MB6408.eurprd05.prod.outlook.com
 ([fe80::c99f:9130:561f:dea0%3]) with mapi id 15.20.2750.021; Tue, 25 Feb 2020
 07:43:44 +0000
Date:   Tue, 25 Feb 2020 09:43:41 +0200
From:   Leon Romanovsky <leonro@mellanox.com>
To:     Saeed Mahameed <saeedm@mellanox.com>
Cc:     "yishaih@dev.mellanox.co.il" <yishaih@dev.mellanox.co.il>,
        Jason Gunthorpe <jgg@mellanox.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "rosenbaumalex@gmail.com" <rosenbaumalex@gmail.com>,
        Yishai Hadas <yishaih@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "dledford@redhat.com" <dledford@redhat.com>
Subject: Re: [PATCH mlx5-next 1/2] net/mlx5: Expose raw packet pacing APIs
Message-ID: <20200225074341.GA5347@unreal>
References: <20200219190518.200912-1-leon@kernel.org>
 <20200219190518.200912-2-leon@kernel.org>
 <ea7589ad4d3f847f49e4b4f230cdc130ed4b83a8.camel@mellanox.com>
 <449186ce-c66f-a762-24c3-139c4ced3b1c@dev.mellanox.co.il>
 <df68bb933da1c20bbd1c131653895f9233249c9e.camel@mellanox.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <df68bb933da1c20bbd1c131653895f9233249c9e.camel@mellanox.com>
X-ClientProxiedBy: AM3PR05CA0101.eurprd05.prod.outlook.com
 (2603:10a6:207:1::27) To AM6PR05MB6408.eurprd05.prod.outlook.com
 (2603:10a6:20b:b8::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (193.47.165.251) by AM3PR05CA0101.eurprd05.prod.outlook.com (2603:10a6:207:1::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2750.18 via Frontend Transport; Tue, 25 Feb 2020 07:43:43 +0000
X-Originating-IP: [193.47.165.251]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: e6556f94-0276-47ff-1672-08d7b9c67094
X-MS-TrafficTypeDiagnostic: AM6SPR01MB0033:|AM6SPR01MB0033:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM6SPR01MB003395D3F9FDBCEACAC8F4D2B0ED0@AM6SPR01MB0033.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-Forefront-PRVS: 0324C2C0E2
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(7916004)(366004)(199004)(189003)(6496006)(52116002)(956004)(66476007)(16526019)(6636002)(26005)(186003)(53546011)(498600001)(86362001)(66556008)(33716001)(66946007)(5660300002)(81166006)(8936002)(54906003)(4326008)(6486002)(6862004)(8676002)(1076003)(33656002)(9686003)(2906002)(81156014);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6SPR01MB0033;H:AM6PR05MB6408.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vCSx53w+7+njhj1iFVktZgMTv9WtllDygorhqq40z/oV9bA/P3ZXpROgD5vvH99beblQlUZ5cJ8Q1zMaKhWc/d2rpbyXZ2v9v26K3HT5mXFB+sCfdF0aGtEZBZqP9awxaDwlCAvKnGFD0Q7T6bdkECCpFu0AltEcKefb9Eiv6yy57j+hiTXLvLMkIWpyJPgo0UNGjYBkPs6KPusCD5XjK5uvq7g2V4GiMFhNYy46UehaLnUYo12mNafBtj2LJx1nNS8PBpG5dsgpQLyK+kBS1+DaMeKrlnZdvL6NgG9k54Hhz2GptuCgybISuYuwt5+2s5nz/OH+eaZiXHWO8k8fizXWaa9jr0rm21qhu5qUATzKcHnYpx3DOblib9XIda8mYg6almTfBm1jKR6qWi0jEUDURHH0pIAsYdrOuh7COi6czLGz0ZQZzexrOd18rrs2
X-MS-Exchange-AntiSpam-MessageData: wNZqNPFX3D9Gx3tcG+/y0xJRefoLB/TcaoLfHPJ5eJ0i/hv2NA2veIYSQgwPE/wQ18TDYng7pZxgHPBuEcDf1SjaeUt+sSQZrNzOAuP3LKgAk+e+JL+i8oUbgn8LqMrHoU2uzuvjJNoNynn8cWaxHw==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e6556f94-0276-47ff-1672-08d7b9c67094
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2020 07:43:44.2549
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DupfrntN3bvt2vGqKMKMhGBHq3nop4howyLRfdBbpABtdMi7kisHk7sH65thXvVufeJmFHyDtw2yLd+4yjzCIw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6SPR01MB0033
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 24, 2020 at 11:32:58PM +0000, Saeed Mahameed wrote:
> On Sun, 2020-02-23 at 10:53 +0200, Yishai Hadas wrote:
> > On 2/21/2020 9:04 PM, Saeed Mahameed wrote:
> > > On Wed, 2020-02-19 at 21:05 +0200, Leon Romanovsky wrote:
> > > > From: Yishai Hadas <yishaih@mellanox.com>
> > > >
> > > > Expose raw packet pacing APIs to be used by DEVX based
> > > > applications.
> > > > The existing code was refactored to have a single flow with the
> > > > new
> > > > raw
> > > > APIs.
> > > >
> > > > The new raw APIs considered the input of 'pp_rate_limit_context',
> > > > uid,
> > > > 'dedicated', upon looking for an existing entry.
> > > >
> > > > This raw mode enables future device specification data in the raw
> > > > context without changing the existing logic and code.
> > > >
> > > > The ability to ask for a dedicated entry gives control for
> > > > application
> > > > to allocate entries according to its needs.
> > > >
> > > > A dedicated entry may not be used by some other process and it
> > > > also
> > > > enables the process spreading its resources to some different
> > > > entries
> > > > for use different hardware resources as part of enforcing the
> > > > rate.
> > > >
> > >
> > > It sounds like the dedicated means "no sharing" which means you
> > > don't
> > > need to use the mlx5_core API and you can go directly to FW.. The
> > > problem is that the entry indices are managed by driver, and i
> > > guess
> > > this is the reason why you had to expand the mlx5_core API..
> > >
> >
> > The main reason for introducing the new mlx5_core APIs was the need
> > to
> > support the "shared mode" in a "raw data" format to prevent future
> > touching the kernel once PRM will support extra fields.
> > As the RL indices are managed by the driver (mlx5_core) including
> > the
> > sharing, we couldn’t go directly to FW, the legacy API was
> > refactored
> > inside the core to have one flow with the new raw APIs.
> > So we may need those APIs regardless the dedicated mode.
> >
>
> I not a fan of legacy APIs, all of the APIs are mlx5 internals and i
> would like to keep one API which is only PRM dependent as much as
> possible.
>
> Anyway thanks for the clarification, i think the patch is good as is,
> we can improve and remove the legacy API in the future and keep the raw
> API.
>
> >
> > > I would like to suggest some alternatives to simplify the approach
> > > and
> > > allow using RAW PRM for DEVX properly.
> > >
> > > 1. preserve RL entries for DEVX and let DEVX access FW directly
> > > with
> > > PRM commands.
> > > 2. keep mlx5_core API simple and instead of adding this raw/non raw
> > > api
> > > and complicating the RL API with this dedicated bit:
> > >
> > > just add mlx5_rl_{alloc/free}_index(), this will dedicate for you
> > > the
> > > RL index form the end of the RL indices database and you are free
> > > to
> > > access the FW with this index the way you like via direct PRM
> > > commands.
> > >
> > As mentioned above, we may still need the new mlx5_core raw APIs for
> > the
> > shared mode which is the main usage of the API, we found it
> > reasonable
> > to have the dedicate flag in the new raw alloc API instead of
> > exposing
> > more two new APIs only for that.
> >
> > Please note that even if we'll go with those 2 extra APIs for the
> > dedicated mode, we may still need to maintain in the core this
> > information to prevent returning this entry for other cases.
> >
> > Also the idea to preserve some entries at the end might be wasteful
> > as
> > there is no guarantee that DEVX will really be used, and even so it
> > may
> > not ask for entries in a dedicated mode.
> >
> > Presering them for this optional use case might prevent using them
> > for
> > all other cases.
> >
> >
> > > > The counter per entry mas changed to be u64 to prevent any option
> > > > to
> > >                     typo ^^^ was
> >
> > Sure, thanks.
> >
>
> Leon, Other than the typo i am good with this patch.
> you can fix up the patch prior to pulling into mlx5-next, no need for
> v2.

Thanks Saeed, I'll apply it once Doug/Jason ack RDMA part of the series.

>
> Acked-by: Saeed Mahameed <saeedm@mellanox.com>
>
>
> thanks,
> Saeed.
>

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0EB34189D7D
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 15:00:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726979AbgCROAK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 10:00:10 -0400
Received: from mail-eopbgr20046.outbound.protection.outlook.com ([40.107.2.46]:61763
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726877AbgCROAK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Mar 2020 10:00:10 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TsYpgJC8CYYCx4ETICJloZE5BTwB0KE2MHYZzBLWcG5umYsl5jEzM2bg5DbPfzPzdLB+z4E0Ao2bAxglzeHCs51czWmtOj0pI3s74mkp3mGUSSW8qbV/SFNLIEuaCBe/GWEYKSi6ImYFrcj57NZHeatwyyXbvx54s+Wb7+9PsTFwochi6bmcFwdJuwgN84fF/9wROuRQ7aSanTIUyq/dxv55t0c3C1kXZlzbpjfPd1hX1GTLFpWIq09qCApzauakDivRTGaeX2vdnrUdtcsqaEvfMLJShI4A+vXTzWFyCsIw83OdxV/jAZqAEnVC4sbjl3EReHNnmJ/2rKoJJ9JyjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HY7JQMToyJ5Td7SCL9NPeyrogS2jhvCpLZaCz1SCpR0=;
 b=JLb+Zyz0XCYersy89AeGbyF22nht3io4AdWe99r8DmdUdQhB1w0XyRNstcMBuTTaVPuiypUSzjOGO7tnznxP3XHCPPPYx7bH2zhw4f3Tc5gsYfaJzNz49D2jj2s7AiHWV7987KQb3Z9pFNoBAmhS/bbp0bgFcR4YcjwHcHO7OdvhqlzMxTrksohHFYStgUgrNvl/NH0lhcfT0eOXpKtow8Qh/PaaHx2wdRJN9KSjlzBjKdp88MAhth5fg+/hZ6cn+UyHNHrwPGDaieNnFUt+4vCNjlQBeS/zN8K/qmFrBwn4sbgzJXocvuhj+dsuOJ8RtixsQ/rZl7yd78QMqJ2YRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HY7JQMToyJ5Td7SCL9NPeyrogS2jhvCpLZaCz1SCpR0=;
 b=A0YnTyILsRpKWnvvJHcTAm7s8Y8xxwrS/2DF6D+cx0pX9BKYIkOgJ8fQv0/wQ4F4UK3Roxtrr8k2C+lAsuGrcrfMOUoBfnXg76LeG2PwQ7orZmOP0yAI7HwspXANfOfVrOtPTujhjgqZQxyMk/q0zV5L7aXUE4rRSjOmUWHiBt0=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=jgg@mellanox.com; 
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com (52.133.14.15) by
 VI1PR05MB3183.eurprd05.prod.outlook.com (10.170.237.152) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2814.22; Wed, 18 Mar 2020 14:00:05 +0000
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::18d2:a9ea:519:add3]) by VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::18d2:a9ea:519:add3%7]) with mapi id 15.20.2814.025; Wed, 18 Mar 2020
 14:00:05 +0000
Date:   Wed, 18 Mar 2020 11:00:01 -0300
From:   Jason Gunthorpe <jgg@mellanox.com>
To:     Leon Romanovsky <leon@kernel.org>,
        Doug Ledford <dledford@redhat.com>
Cc:     linux-rdma@vger.kernel.org,
        Michael Guralnik <michaelgur@mellanox.com>,
        netdev@vger.kernel.org, Saeed Mahameed <saeedm@mellanox.com>,
        Yishai Hadas <yishaih@mellanox.com>
Subject: Re: [PATCH rdma-next 0/4] Introduce dynamic UAR allocation mode
Message-ID: <20200318140001.GL13183@mellanox.com>
References: <20200318124329.52111-1-leon@kernel.org>
 <20200318125459.GI13183@mellanox.com>
 <20200318131450.GY3351@unreal>
 <20200318132100.GK13183@mellanox.com>
 <20200318135631.GA126497@unreal>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200318135631.GA126497@unreal>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: MN2PR02CA0027.namprd02.prod.outlook.com
 (2603:10b6:208:fc::40) To VI1PR05MB4141.eurprd05.prod.outlook.com
 (2603:10a6:803:44::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.68.57.212) by MN2PR02CA0027.namprd02.prod.outlook.com (2603:10b6:208:fc::40) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2814.19 via Frontend Transport; Wed, 18 Mar 2020 14:00:04 +0000
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)     (envelope-from <jgg@mellanox.com>)      id 1jEZEn-0008VH-7a; Wed, 18 Mar 2020 11:00:01 -0300
X-Originating-IP: [142.68.57.212]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: b8b802c5-695d-447b-7c9e-08d7cb44a8c4
X-MS-TrafficTypeDiagnostic: VI1PR05MB3183:|VI1PR05MB3183:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB3183A2843458AA5E4C62E690CFF70@VI1PR05MB3183.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-Forefront-PRVS: 03468CBA43
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(136003)(39860400002)(346002)(366004)(376002)(199004)(1076003)(81166006)(4326008)(2616005)(66556008)(66476007)(2906002)(81156014)(66946007)(36756003)(110136005)(54906003)(33656002)(9786002)(9746002)(107886003)(52116002)(8936002)(8676002)(186003)(26005)(478600001)(86362001)(316002)(5660300002)(24400500001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB3183;H:VI1PR05MB4141.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YY15LRXSl6JEM9/23hXpH2za0tcvGOXlwYvGJu4q8LrsfpMGrdUrg19SFqH6f+l5EJn3gD3Ir4BSzVUk7fyACdpY+Ux+bt41z6VQ88r9vKpL4Sf2uk38tsKg79ghUsz43J/rZBl2B5XJJTeX6lSEWrYOJGHJij9VZ38YjdCnMnEjWrJPhf/YrDtYXoDAZpZ2N2WhFwTcqC1WYxrPB7PvwQkSJbvwgmd05GxmMas4KIYQ29jSjQeYDyWaP0lbQbk4inB3AJerPXrsH7wW97EA8Ta3AnmR5V0IA1VdQy/YZ9Kf07SKPMFuh2ZOub9paWmhbRbAQdJuZgMjTfuWkS9KHX/0jL/pXtYrlQVaXDbzCT0eJ17p9qrJIEQ9045xSAIZNbmwLfctaOBI/YseunimLw9DtIpXntAfCyIa+4N2DZpqrXrRzEfNQPxalEXkQ68unJBixa+78YXWFk2276Fzvo8riIL3rZHMAdI0STS6AjIFWyVMyLk9Xklr26W6z5fy
X-MS-Exchange-AntiSpam-MessageData: w35R3l5REcJ8uYIvxIJTETyoub7wDZzvPbPbpCf380LTbwzez9anUXPI3O8/DSOoNA52w5RDsY8aiXmNXMp8Ouscix3Kt5IuQ29FcZrJ3IWMnv3QVzpq6kjVpKh48FpWO050A46bqyd0Tr6oMy0UJw==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b8b802c5-695d-447b-7c9e-08d7cb44a8c4
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Mar 2020 14:00:05.2014
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ECBBj1owc8mUV+ArkXLNThgjB2hoxeeu5XKsMHAiRCFBMs55Za4gV9a4hmYASV1T/jtntGk1aBZVtD49i8Qd3g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB3183
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 18, 2020 at 03:56:31PM +0200, Leon Romanovsky wrote:
> On Wed, Mar 18, 2020 at 10:21:00AM -0300, Jason Gunthorpe wrote:
> > On Wed, Mar 18, 2020 at 03:14:50PM +0200, Leon Romanovsky wrote:
> > > On Wed, Mar 18, 2020 at 09:54:59AM -0300, Jason Gunthorpe wrote:
> > > > On Wed, Mar 18, 2020 at 02:43:25PM +0200, Leon Romanovsky wrote:
> > > > > From: Leon Romanovsky <leonro@mellanox.com>
> > > > >
> > > > > From Yishai,
> > > > >
> > > > > This series exposes API to enable a dynamic allocation and management of a
> > > > > UAR which now becomes to be a regular uobject.
> > > > >
> > > > > Moving to that mode enables allocating a UAR only upon demand and drop the
> > > > > redundant static allocation of UARs upon context creation.
> > > > >
> > > > > In addition, it allows master and secondary processes that own the same command
> > > > > FD to allocate and manage UARs according to their needs, this can’t be achieved
> > > > > today.
> > > > >
> > > > > As part of this option, QP & CQ creation flows were adapted to support this
> > > > > dynamic UAR mode once asked by user space.
> > > > >
> > > > > Once this mode is asked by mlx5 user space driver on a given context, it will
> > > > > be mutual exclusive, means both the static and legacy dynamic modes for using
> > > > > UARs will be blocked.
> > > > >
> > > > > The legacy modes are supported for backward compatible reasons, looking
> > > > > forward we expect this new mode to be the default.
> > > >
> > > > We are starting to accumulate a lot of code that is now old-rdma-core
> > > > only.
> > >
> > > Agree
> > >
> > > >
> > > > I have been wondering if we should add something like
> > > >
> > > > #if CONFIG_INFINIBAND_MIN_RDMA_CORE_VERSION < 21
> > > > #endif
> > >
> > > From one side it will definitely help to see old code, but from another
> > > it will create many ifdef inside of the code with a very little chance
> > > of testing. Also we will continue to have the same problem to decide when
> > > we can delete this code.
> >
> > Well, it doesn't have to be an #ifdef, eg just sticking
> >
> > if (CONFIG_INFINIBAND_MIN_RDMA_CORE_VERSION >= 21)
> >      return -ENOPROTOOPT;
> >
> > at the top of obsolete functions would go a long way
> 
> First, how will you set this min_version? hordcoded in the kernel
> code?

Yes, when a rdma-core release obsoletes the code path then it can
become annotated.

> Second, it will work for simple flows, but can be extremely complex
> if your code looks like:
> if (old_version)
>  do something
> if (new version)
>  do something else

Well, we'd avoid making such complications, it would be something like

if (flag & foo) {
   if (CONFIG_INFINIBAND_MIN_RDMA_CORE_VERSION >= 21)
      return -ENOPROTOOPT;
  [keep going as before]
}

At least we now know this conditional path isn't used / isn't covered
by testing

Doug? What does a distro think?

Jason

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E079189DA1
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 15:12:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727002AbgCROMQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 10:12:16 -0400
Received: from mail-eopbgr10049.outbound.protection.outlook.com ([40.107.1.49]:41566
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726851AbgCROMQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Mar 2020 10:12:16 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VVM7Jtug3MnRvSM/ge6lsfstRdefdGOt23Xn8FclVn6NolzbBf7H7oEzHCK3xf1OkyDMqv+1fKKim9Ezi5HnwACmIu24nmJ4wLkL3NUKFEOZKgwSkZ+qABEVBMisTPZ9hW6a9DrLNZKmVNx+CBSdr+vKtgev4dzyD33/cmzxqM8hrXgv7ERk9cH0mupSlFP9UUd3Qld6C/6ihza48hSKCOo+nSFn/TQf06uViV1odWfHlL2lPgoJR9+LBu9s0i5frWdrsWl3hACdr4w75C8o7Lrh6JRlzEUOJqmYrz0KMu9FJAHFDTKY4fOToyFZWSCGczvjvekvuCIPI5PfRmZlrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PcJlCpNhCLHX9s8xyn1lk+dxMUYgGfUbsoC47kk/wFQ=;
 b=BjoREtzYf6CnPhzTpDXixXX59bhDEAOp5qufO+ZE3+k84X1w3DPBTWMowkS/gWSJr4Syju/Z95UIAOLHUpP0cOlP9BqeRhngw+wyuhVdOYW0JJ8OsGPtRr/tKR+qSImpCDgGzafhJPhpgHNNJF1xIUOkDTiTr0QxNzpLQVi8XSK4yVQNtWYLmO6WDKvXnU6mqP685ZLdCog/U8jPPla1XHSvNyJxo3D73I4pe6wl58DIl6hHObTp3TZuEg4hTBCJaOEJ+b/mR26+9gDBXiGC1AV7W2CLc0yfGR+9XxoA0uoc8l6DtHdyz1ob7/DaSW1DTqPPDFPS/rAo4zPtinDHhw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PcJlCpNhCLHX9s8xyn1lk+dxMUYgGfUbsoC47kk/wFQ=;
 b=NrVmq9q1q7D5FQnEerE67hnujfuytOpJoYBGsS0Y+F3GvAJRpYmZp/KWoPStJffDDAJEFkxCPRNa0OJ9kiPDQN25hlW7JkPjNjd4Fcwr609ws5L+YhAVETV3hWFestQYyjRFTxhH8AfF/LxJvGWUFUdn/0c2Eb6EW1y9MaJ9BVs=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=jgg@mellanox.com; 
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com (52.133.14.15) by
 VI1PR05MB4320.eurprd05.prod.outlook.com (52.134.31.154) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2814.13; Wed, 18 Mar 2020 14:12:11 +0000
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::18d2:a9ea:519:add3]) by VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::18d2:a9ea:519:add3%7]) with mapi id 15.20.2814.025; Wed, 18 Mar 2020
 14:12:11 +0000
Date:   Wed, 18 Mar 2020 11:12:08 -0300
From:   Jason Gunthorpe <jgg@mellanox.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Doug Ledford <dledford@redhat.com>, linux-rdma@vger.kernel.org,
        Michael Guralnik <michaelgur@mellanox.com>,
        netdev@vger.kernel.org, Saeed Mahameed <saeedm@mellanox.com>,
        Yishai Hadas <yishaih@mellanox.com>
Subject: Re: [PATCH rdma-next 0/4] Introduce dynamic UAR allocation mode
Message-ID: <20200318141208.GM13183@mellanox.com>
References: <20200318124329.52111-1-leon@kernel.org>
 <20200318125459.GI13183@mellanox.com>
 <20200318131450.GY3351@unreal>
 <20200318132100.GK13183@mellanox.com>
 <20200318135631.GA126497@unreal>
 <20200318140001.GL13183@mellanox.com>
 <20200318140932.GB126814@unreal>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200318140932.GB126814@unreal>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: MN2PR19CA0017.namprd19.prod.outlook.com
 (2603:10b6:208:178::30) To VI1PR05MB4141.eurprd05.prod.outlook.com
 (2603:10a6:803:44::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.68.57.212) by MN2PR19CA0017.namprd19.prod.outlook.com (2603:10b6:208:178::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2835.15 via Frontend Transport; Wed, 18 Mar 2020 14:12:11 +0000
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)     (envelope-from <jgg@mellanox.com>)      id 1jEZQW-0000Ed-27; Wed, 18 Mar 2020 11:12:08 -0300
X-Originating-IP: [142.68.57.212]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: d07b3180-7c21-4c3b-4b60-08d7cb465a19
X-MS-TrafficTypeDiagnostic: VI1PR05MB4320:|VI1PR05MB4320:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB432047702F4880F70215AC05CFF70@VI1PR05MB4320.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-Forefront-PRVS: 03468CBA43
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(396003)(366004)(136003)(346002)(376002)(199004)(9746002)(9786002)(5660300002)(52116002)(107886003)(1076003)(86362001)(66556008)(478600001)(66946007)(66476007)(33656002)(2906002)(2616005)(4326008)(8936002)(6916009)(26005)(81166006)(81156014)(186003)(54906003)(316002)(8676002)(36756003)(24400500001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB4320;H:VI1PR05MB4141.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fUJD5JH/CWpw2igrP73CEPvxzZD2xf6n/l5TktxhKv6cmXbZTiIJfYAx0BOB4/Onw/PnxyMLZgucVdsri+SdYzhz1RM8lB5aP9vEeBR0sEwO+yTdrrHhPSwuN8A7MEm40MqbSSsEPyPYzkM494iTBj+f2Ti5rC6hfdqSu6ym9/MZnCTe68ICqcK4vjkoXKRISThvXPUGKyvG4Xw9Lipa0jeWrk0H3CSVwQ/5ywAdyXxLlyiszjk26TmpuFZwKo2qh/mMe8uJ8s7vs564f5aEUDyPqnVwQcx99Gae04aHpACX8fSSarnopEEphjKu+V0+UY4Nb/EppQVJa0uVmGgvYd2J96gbsho4NtV9ocUIB6Rv5By5TKs++BDKQINFdHak9PnxIOqWLi7ebKaOwf7UIXVl1BnX5giAMzzmcnh0JdZ3bn/0qF1W7Y64UHqqNJi8Z3rNbEa3/HiEooqdAQ/TJA8iPhH61QRAx89+a6gj7HQxwH9VzMuDoUr5eyLW8pqx
X-MS-Exchange-AntiSpam-MessageData: 5dvApDfHX2GgeXpGTmsVU4VMQ3fafp8QTaa1LuR6h4fEUdlkpSYnSbsHiolXRmLlWY1S+CtXU4pLTVy0lXhs09OhvQiDqlFRdaB6jNDiOQp/EZYVr//Hyz6nt2vvW4Qr75V47d+Xw25gPJGMW5dG/g==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d07b3180-7c21-4c3b-4b60-08d7cb465a19
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Mar 2020 14:12:11.7350
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5cP6ID40dzZ34HolHw3JZ/7Gd7JzUIAAq0KNKyjaFUcobuDC4Ydh86+vawK+g6vaNlk1J1yjtVapBOtE/saa2g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4320
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 18, 2020 at 04:09:32PM +0200, Leon Romanovsky wrote:
> On Wed, Mar 18, 2020 at 11:00:01AM -0300, Jason Gunthorpe wrote:
> > On Wed, Mar 18, 2020 at 03:56:31PM +0200, Leon Romanovsky wrote:
> > > On Wed, Mar 18, 2020 at 10:21:00AM -0300, Jason Gunthorpe wrote:
> > > > On Wed, Mar 18, 2020 at 03:14:50PM +0200, Leon Romanovsky wrote:
> > > > > On Wed, Mar 18, 2020 at 09:54:59AM -0300, Jason Gunthorpe wrote:
> > > > > > On Wed, Mar 18, 2020 at 02:43:25PM +0200, Leon Romanovsky wrote:
> > > > > > > From: Leon Romanovsky <leonro@mellanox.com>
> > > > > > >
> > > > > > > From Yishai,
> > > > > > >
> > > > > > > This series exposes API to enable a dynamic allocation and management of a
> > > > > > > UAR which now becomes to be a regular uobject.
> > > > > > >
> > > > > > > Moving to that mode enables allocating a UAR only upon demand and drop the
> > > > > > > redundant static allocation of UARs upon context creation.
> > > > > > >
> > > > > > > In addition, it allows master and secondary processes that own the same command
> > > > > > > FD to allocate and manage UARs according to their needs, this can’t be achieved
> > > > > > > today.
> > > > > > >
> > > > > > > As part of this option, QP & CQ creation flows were adapted to support this
> > > > > > > dynamic UAR mode once asked by user space.
> > > > > > >
> > > > > > > Once this mode is asked by mlx5 user space driver on a given context, it will
> > > > > > > be mutual exclusive, means both the static and legacy dynamic modes for using
> > > > > > > UARs will be blocked.
> > > > > > >
> > > > > > > The legacy modes are supported for backward compatible reasons, looking
> > > > > > > forward we expect this new mode to be the default.
> > > > > >
> > > > > > We are starting to accumulate a lot of code that is now old-rdma-core
> > > > > > only.
> > > > >
> > > > > Agree
> > > > >
> > > > > >
> > > > > > I have been wondering if we should add something like
> > > > > >
> > > > > > #if CONFIG_INFINIBAND_MIN_RDMA_CORE_VERSION < 21
> > > > > > #endif
> > > > >
> > > > > From one side it will definitely help to see old code, but from another
> > > > > it will create many ifdef inside of the code with a very little chance
> > > > > of testing. Also we will continue to have the same problem to decide when
> > > > > we can delete this code.
> > > >
> > > > Well, it doesn't have to be an #ifdef, eg just sticking
> > > >
> > > > if (CONFIG_INFINIBAND_MIN_RDMA_CORE_VERSION >= 21)
> > > >      return -ENOPROTOOPT;
> > > >
> > > > at the top of obsolete functions would go a long way
> > >
> > > First, how will you set this min_version? hordcoded in the kernel
> > > code?
> >
> > Yes, when a rdma-core release obsoletes the code path then it can
> > become annotated.
> >
> > > Second, it will work for simple flows, but can be extremely complex
> > > if your code looks like:
> > > if (old_version)
> > >  do something
> > > if (new version)
> > >  do something else
> >
> > Well, we'd avoid making such complications, it would be something like
> >
> > if (flag & foo) {
> >    if (CONFIG_INFINIBAND_MIN_RDMA_CORE_VERSION >= 21)
> >       return -ENOPROTOOPT;
> >   [keep going as before]
> > }
> >
> > At least we now know this conditional path isn't used / isn't covered
> > by testing
> 
> I'm ok with this approach because it helps us to find those dead
> paths, but have last question, shouldn't this be achieved with
> proper documentation of every flag instead of adding CONFIG_..?

How do you mean?

The other half of this idea is to disable obsolete un tested code to
avoid potential bugs. Which requires CONFIG_?

Jason

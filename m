Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C52B144B073
	for <lists+netdev@lfdr.de>; Tue,  9 Nov 2021 16:33:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235217AbhKIPgb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Nov 2021 10:36:31 -0500
Received: from mail-dm6nam11on2086.outbound.protection.outlook.com ([40.107.223.86]:58144
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231176AbhKIPg3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Nov 2021 10:36:29 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oaKecwY6N44LbKCR5xwxTytzk1tYf28tupyd1+qBjDbsFXKtQmGqhZoa82SWFjXvY2OtrVkN0rezZNLHIB8RsekgWbJPSlO8rbVxmUDlL5UEstGAthmibxIK4ixsrSGVP1ReLYYlGyi8wejZExlsUcqQbTmHFHLsNBP49VHIgcxTm2mK3MTgZ/TJZlFy0cK/C/6vX9gM4+7rleug/j3q1yu/sWu34L6kXpNGBuUqCORbi/3fI56Fle/ryRpdjvt9fY4jCumEzNMYghaJ++m9IcGZ38ByqdE7zDac43AzboPg/VZeZd5TbuUtR2v+eFOLowR8JzTPHoFlmXw4Wj0J4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oX3MUfZgsF4T70nWqu46c9zAQavB+ke7+21ywisOCXE=;
 b=O9tUPnVIlUvDO+Dc2y5qMsymSTFfP9dA5G7NndQznRnONUxchfnB8xHFq2angJXqek6B+/YbQfu62VGzNwG3Qs23j4Ou3x73BsC0MEPngqy1Iwymsr27ZxbUn+2ZK93bql8sF5B+kSvRlXPEiSyWerRkCjCY6NLjmFeAA7vDa+9L/dQ7MeVH457v9QP95CCilVfd+1wJI0+ns3q8Bxh96aifZX32aoAjoBbIOgELCrDtvVtZ8wz5ok1JoaAXdQi4GF6FcC21TESeOjkpQ8KtOyg77ShxbVwJ9+b9WfRhoClKUI17PnjYPoy/69DLcxZo8nC+wJKqAcJUAiMwxvnHqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oX3MUfZgsF4T70nWqu46c9zAQavB+ke7+21ywisOCXE=;
 b=beBLCFC37RbnuW9TStWBX/aYg2DOY+496PoYmCQdhzAVD6LBA+UdDmfBjyEmyUPDJkYTSY8sqUW0/fr1VK9PjonUumQgtez2kUc1KyD3Oin/K+MuG/vSJNbgzPu8IrV508vKHgCJ9DMiM2ZnWEbNw62k/LIkQgyJxYvaWxpDjqvvoeuYrvQTztwzxpYSAB8PlomPnchF8dRn+9qROUqGDhDQMb6oLVpsS5Gj/MDHUfB2HMhIMOqCoasBXaz6foINyegFqy97izA7jdTRy3uCBS6Ka9jSPeEJiWfTQU02s4gNTWues86qW3slkBH8qUtoMMgyb7zBUThvC19gMH1emA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5351.namprd12.prod.outlook.com (2603:10b6:208:317::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.15; Tue, 9 Nov
 2021 15:33:36 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::5897:83b2:a704:7909]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::5897:83b2:a704:7909%7]) with mapi id 15.20.4669.016; Tue, 9 Nov 2021
 15:33:36 +0000
Date:   Tue, 9 Nov 2021 11:33:35 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@nvidia.com>
Cc:     Leon Romanovsky <leon@kernel.org>,
        Ido Schimmel <idosch@idosch.org>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S . Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        edwin.peer@broadcom.com
Subject: Re: [PATCH net-next] devlink: Require devlink lock during device
 reload
Message-ID: <20211109153335.GH1740502@nvidia.com>
References: <YYgSzEHppKY3oYTb@unreal>
 <20211108080918.2214996c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <YYlfI4UgpEsMt5QI@unreal>
 <20211108101646.0a4e5ca4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <YYlrZZTdJKhha0FF@unreal>
 <20211108104608.378c106e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <YYmBbJ5++iO4MOo7@unreal>
 <20211108153126.1f3a8fe8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20211109144358.GA1824154@nvidia.com>
 <20211109070702.17364ec7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211109070702.17364ec7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
X-ClientProxiedBy: BL1PR13CA0305.namprd13.prod.outlook.com
 (2603:10b6:208:2c1::10) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (142.162.113.129) by BL1PR13CA0305.namprd13.prod.outlook.com (2603:10b6:208:2c1::10) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.5 via Frontend Transport; Tue, 9 Nov 2021 15:33:36 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mkT7v-007fei-SJ; Tue, 09 Nov 2021 11:33:35 -0400
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3237987e-64f9-4a61-2c40-08d9a3964c13
X-MS-TrafficTypeDiagnostic: BL1PR12MB5351:
X-Microsoft-Antispam-PRVS: <BL1PR12MB53514BB9322CB1D11405F7D7C2929@BL1PR12MB5351.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KAR6nQbRfZw9dTuEPTLXARkDWyJ4TD6uNU94cXvvji0WvBwETF9yrxNgBCYfAfnQJp2ooTqNKJy1ltIthOz0G9GSdOZNdxaVM1tyZRUpD1G9Rjn1IqroqXWVhtQEeHDrSdSHh84H87xO2SuIMhtaUQPTMVjv8YeKmzlYNIp4WmIVF9rlWGd8drF/bldLdN1P0BnslSSqM1wLdNj+gmKXBALGV72Z5O7KdiA4ipgIq3Ov/1S09e3WdWvpt8LaloEi9UtsBSAoejhJ1CJy8xj7Fk6zBSuKQcPIkMY2k/I8X4XN6PeH2mPxYs31ya1Y84H1aXRO4E9hp7AkX22QVz1LpkgqKeamTdqE808YkYcXM8eAvJcN4AWA6dEOJB/SnXP4LoQxdk1Y01r+EwYVh/HE3AvqgqCdDx5FcNoSHuyjXIQdtj0dekHDHEa284T0UUiWVL1/1mX6WnxXmvaMfnkbZy45Z4iMUcabREprnDNLh4n3vQnqKgbPh7y8ZSzbyyzb+9XiEoCR7vAFrSZVEsgse69aYwQ5kEblICps7HS3mcDMV+kopVaZYY+yGHKHO4/tziOTe92Gj6uHpQplQIUSBdZ5XaqR8xVwU7ZRB51i+qR4AFymqOcfkQFBVWKKls9RDUxpqLilWaxq9SAj3ougYw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(9746002)(66476007)(66556008)(316002)(26005)(5660300002)(54906003)(38100700002)(8936002)(9786002)(110136005)(8676002)(186003)(6636002)(66946007)(83380400001)(36756003)(4326008)(33656002)(86362001)(1076003)(2616005)(2906002)(426003)(508600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?xi+W98VTCTxcWjtelFSefqu6A9l1lF6XXvzym+x25vNmgeXpGlUlmecCR3fQ?=
 =?us-ascii?Q?jrk5kQ9j4Sw1FtVLiHZBaF5YeJiSm8bT3xzGV4UP09e3S6M8CNpbCpjd9Wph?=
 =?us-ascii?Q?nKNbRGMsMyR0q6vnmH0oNx3UbNBnwqUHOrmll5RNqvf8xvpZpNw+ISt15ocV?=
 =?us-ascii?Q?JW9GtduNWi/lPAO8clNWKDB3BPtczf02uOfyOosAHq/aez34qmXS1xgYz5Mg?=
 =?us-ascii?Q?lvq4TzJmXZhEk3nenJYKz7XJzEYr4L0mvlRcMByKqlw3kKHTdEXLPrZyDk69?=
 =?us-ascii?Q?nmfATQWYLGmxDP1N4NUCHDseiKiwPQv7D5zJj2V3S+1dTqzOcy8QEw3kD7TU?=
 =?us-ascii?Q?m4BF+0+IaMHvEkDeU8yqLJsKn607aMjG2gyCEREL9VBd57X4z21RFKf4cJO/?=
 =?us-ascii?Q?9VjHuRftetfS6xxCVbY7CWDfXLoVEN72/XJ6mMSUa1cpHESq0olmShExhBc8?=
 =?us-ascii?Q?nNIQ61zl3CqXekBjAHd5SQHHq1I9PG6OOnW70kWvN0D31R0NQvH//5dzJoul?=
 =?us-ascii?Q?fiiwyg0wvqLd96AkGelCFnj1x3uml6/U1JaevLhfYv4GSEsiD+YeqwS1m8qK?=
 =?us-ascii?Q?ufWlSiP7drY+ubn5IqPMkg14DqDksCwJiWhAEkU38htLBRt/LxhtSlXRB6D9?=
 =?us-ascii?Q?Fx7reU1Y1GU4Z5d4ENcDeQlOQn/QXCNhHY/mx6LmEhfuOefd6OtVm4sT3NAg?=
 =?us-ascii?Q?u2OxcSNJpPTojD0VWaxjFZ5XSjoDh/Ia7kE/3EwqqB4t7EY4jsEebKOk80Tu?=
 =?us-ascii?Q?mBBGH5ne0dUXlgSPXLkoIxQ+3B3yGEYdTpYuqSWgmDDNYoaMJC9X+54Lf2yE?=
 =?us-ascii?Q?tgqqIBkf7XswaNTlQjS1p3mQhQ3O8r/gjAcjGNVHURfQ+2L7DcL2lrolWC0c?=
 =?us-ascii?Q?ul+mb0aLUfhr1uBDkNo/TpLB8FTl+qkcUTFNVNKC6ziaIt5TKvxsuVn6hcLq?=
 =?us-ascii?Q?LXTQG0bMlbKJ9eSZSiX/QPWJ2ExqKK6q8lx6XdyWtwgfVwH/R3+BBfUZMpTv?=
 =?us-ascii?Q?bzojE713QKoLKaC/YaPUK4h+5nmYartrfJ6IMhTDPaE6WpYMLJUp80LXWa5X?=
 =?us-ascii?Q?NfXrtqCDgJMsscZ26Rq/0gXomouzdf6w79TwCjo3CdK1Ac1fCun9DMI6SRzA?=
 =?us-ascii?Q?7CBaZO4rwOnGbx/XKD7Qj+gVGZJRbxKtOOMcw+EIGbCZ2edqEX9kpCKS6y1a?=
 =?us-ascii?Q?jDXqmmOCHJ/aqVJKJ3yGTILHB6T+hPKhy94iC/j4h7+rBupZ6TVSFhjGQTeU?=
 =?us-ascii?Q?6BvDJvY8erTQdYQe3O3w/uKmzyYYELB1TAT1UyxeHnTLTZTT+nAHcxh3OZI4?=
 =?us-ascii?Q?YtYvX41vTIl+yh+PoDPUsuWuVOCvlXb97l95Y2pCyRVs2TRUqKQQQfOZnUDe?=
 =?us-ascii?Q?kqa4GfLGCQkCogZQ2iKAU+udehD6UMWCp+HP8Cy8JLRVkwUIrgh/fhbjtJZw?=
 =?us-ascii?Q?nYzihbr1OL9y+qC8s4J4eMyrwMCvBHsqTxx8apm9VTKRZ3y5qN2wDk+s83/v?=
 =?us-ascii?Q?NAEI66BsaaPE8A/nMzgHEb2pUa+ErGLIMw3AU5xiVlS1fmXRnT+IZU/rq46R?=
 =?us-ascii?Q?9YweaAkBftuIoDCYHjs=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3237987e-64f9-4a61-2c40-08d9a3964c13
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2021 15:33:36.7955
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KK74hnxeoXoFqT/UjT4T8+VFoBdSF+8iGgMI7J7dHn30DtWE2HSf/Dp3Q15cUiXV
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5351
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 09, 2021 at 07:07:02AM -0800, Jakub Kicinski wrote:
> On Tue, 9 Nov 2021 10:43:58 -0400 Jason Gunthorpe wrote:
> > This becomes all entangled in the aux device stuff we did before.
> 
> So entangled in fact that neither of you is willing to elucidate 
> the exact need ;)

I haven't been paying attention to this thread, Leon just asked me to
elaborate on why roce is in these traces.

What I know is mlx5 testing has shown an alarming number of crashers
and bugs connected to devlink and Leon has been grinding them
away. mlx5 is quite heavily invested in devlink and mlx5 really needs
it to work robustly.

> The main use case for reload for netns is placing a VF in a namespace,
> for a container to use. Is that right? I've not seen use cases
> requiring the PF to be moved, are there any?

Sure, it can be useful. I wouldn't call it essential, but it is there.
 
> > I once sketched out fixing this by removing the need to hold the
> > per_net_rwsem just for list iteration, which in turn avoids holding it
> > over the devlink reload paths. It seemed like a reasonable step toward
> > finer grained locking.
> 
> Seems to me the locking is just a symptom.

My fear is this reload during net ns destruction is devlink uAPI now
and, yes it may be only a symptom, but the root cause may be unfixable
uAPI constraints. Jiri, what do you think?

Speaking generally, I greatly prefer devlink move toward a design where
the aux bus operations that must be connected with devlink reload are
not invoked under any global locks at all. Not per_net_rwsem, rtnl, or
devlink BKLs.

We know holding global locks in open-ended contexts, like driver core
device_register/unregister, is an dangerous pattern.

Concretely, now that we are pushing virtualization use cases into
using devlink as a control plane mlx5 has pod/VM launch issuing
devlink steps. Some of this stuff is necessarily slow, like attaching
a roce aux driver takes a while. Holding a BKL while doing that means
all VM launches are serialized.

IMHO these needs demand a fine grained locking approach, not a BKL
design.

Jason

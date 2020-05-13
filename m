Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 651C61D1E67
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 20:58:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390595AbgEMS6G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 14:58:06 -0400
Received: from mail-vi1eur05on2070.outbound.protection.outlook.com ([40.107.21.70]:6136
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732218AbgEMS6F (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 May 2020 14:58:05 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=abYiEo8Lppbtg6lAz4F0Wy8NO1oJ3/9C1ifj/4itrsWQhoc2auXPFMtAmwORSxpPm1tIvpyk3L9htSYboFNq7axTle7v2siSYTvbIc6xqz0gkomvQzJLvlHg+OQQqWbRcH6U4dkv/xhnsN+R4jaaaeJkTyx2hRqkOcHgPNl/sJrEVb2f9DHDNylmqayki/ZETtb6stEqSVkA6UNCAkcM6dQG6BFXQvjkTATh26jKp6NyaKx4oOJpdfzgA0TdRQb4r8hx7JRaylFliP/p4irbriNIV8RAKn3wbd+gP3r6wD/X+2wdYwe/ztpyLHYtIzbC1S+Wi+8HEnymVMxShakktA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HFcKFPlIcv363YIY+MVDVKRcXc9h9jMljud67Bjb9gQ=;
 b=QdBdtwtHdjkKwBPUsz0/VwQVk3gl0pwNfC1e3RX6GMp8wILTecwZU4ZEzQR5PdrT5PPl7VRkOYycKyly+E62YBsaBdL5RVbpJIZJN5jWdqGSh4QnJCb/vy4/Ea8PMZxjrdGBEOJBwW8IF4A5B8pwjYDiAf+wxUh4j7Es9dybwUxkDndii7nPaEHIjMpijzZSJCGSvX+VAdH0ooSt36e+dqBc+uR4oFyjHWVe1o6b4dZ977nlsFRHbn85nKw0lkHLsLkgciIr+EpZH12oxGw1DlA11eDVkfhphAmmZEaRtmnR6ownJbGxvBU8uCaNHPbD7NwXGsf5fpHm8XChXqbuqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HFcKFPlIcv363YIY+MVDVKRcXc9h9jMljud67Bjb9gQ=;
 b=LsrGg0QQFpoGt7X0eSxSdEErxSJ19h23mVatJm7NbSS0wgBbPvUQhW8qLwG7EOMveOVDzKETjjVqLRby/THnCPEAL2iw65+ZEMZrPPUytfyj+iE0KNuKbRCywu9QFeHGfZ8zlCWnQ9TSd6TaTJHNf3edLmrTtKUJ0iCz/r5fBsY=
Authentication-Results: mellanox.com; dkim=none (message not signed)
 header.d=none;mellanox.com; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com (2603:10a6:803:44::15)
 by VI1PR05MB4799.eurprd05.prod.outlook.com (2603:10a6:802:61::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.20; Wed, 13 May
 2020 18:58:01 +0000
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::a47b:e3cd:7d6d:5d4e]) by VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::a47b:e3cd:7d6d:5d4e%6]) with mapi id 15.20.2979.033; Wed, 13 May 2020
 18:58:01 +0000
Date:   Wed, 13 May 2020 15:57:57 -0300
From:   Jason Gunthorpe <jgg@mellanox.com>
To:     Leon Romanovsky <leonro@mellanox.com>
Cc:     Doug Ledford <dledford@redhat.com>, linux-rdma@vger.kernel.org,
        Maor Gottlieb <maorg@mellanox.com>,
        Mark Bloch <markb@mellanox.com>,
        Mark Zhang <markz@mellanox.com>, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: Re: [PATCH rdma-next v1 0/4] Add steering support for default miss
Message-ID: <20200513185757.GN19158@mellanox.com>
References: <20200504053012.270689-1-leon@kernel.org>
 <20200513070559.GP4814@unreal>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200513070559.GP4814@unreal>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: MN2PR20CA0055.namprd20.prod.outlook.com
 (2603:10b6:208:235::24) To VI1PR05MB4141.eurprd05.prod.outlook.com
 (2603:10a6:803:44::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (156.34.48.30) by MN2PR20CA0055.namprd20.prod.outlook.com (2603:10b6:208:235::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.29 via Frontend Transport; Wed, 13 May 2020 18:58:01 +0000
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)     (envelope-from <jgg@mellanox.com>)      id 1jYwZp-0005ff-MD; Wed, 13 May 2020 15:57:57 -0300
X-Originating-IP: [156.34.48.30]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 32bc9e95-3de5-43a8-d2cf-08d7f76f8f42
X-MS-TrafficTypeDiagnostic: VI1PR05MB4799:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB4799BD73E411484820DFF864CFBF0@VI1PR05MB4799.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-Forefront-PRVS: 0402872DA1
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jVhPBSoGho+HLt70iV33cjVAaKju1VKknRRRk4DaKqIo2p6g/qOgb+FEVtPnWSPSHAj4Fk4khb4uTcbKCHIC85r+VoWQuTxQrOVJHtYsAChYpRKsC4r3WCssz7GfXEsUH8OsNdH0jKCRGQ8VHKJm99QZNsYujAHOeMJoefKYxZLPLEBEOQNg3srOfFIPlu82rAPs8moZcdgNsG8BWAOoDerg6UCvGVakjW8IkjQHmydm0Y5Mgxzdgn7Ky1j2KupFIJWnumidZFcAaRrAkdzUrx0Lj4XPtYdlVXVWHUJdZ57WaRTcu9q46sgg98WiWYQK8bSxIJu5BuXELFky9CMHKC2DnoiGBX9uig7q/Y3HdyY4Spb0ZbSMi1z1DQ16k1+yCMaa4CXgjjGA11bXikl8sNxAazmpOA75g/axjcxCyPPGckh77VES12WvYGH5EZLKRtPXqXdOHyR3m5Eek7sNjqbgYkW+4DCshhJ0vXKQGF7QYPsuoPuk/8PZzM5s1TvDZr0I1/mdTxOFmD6kjl/J2YdUE7on6rw/NK1v46ixRyjIgnIqF76HqWliqX4c6dbpRCBGPacq46IjGDNKCsUiM20QyKsHyG7Q69Zl/ggkcPzR/jhN0sPmD0V9VIB8F8hCb41ezVDh5kOL6iHK/xtTBw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB4141.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(396003)(376002)(136003)(346002)(39860400002)(33430700001)(8676002)(478600001)(186003)(52116002)(5660300002)(86362001)(4744005)(1076003)(33440700001)(26005)(2906002)(966005)(6636002)(107886003)(9746002)(54906003)(316002)(37006003)(8936002)(9786002)(4326008)(66946007)(33656002)(66556008)(6862004)(36756003)(66476007)(2616005)(24400500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: BkwEBk82t2HpuhTKd45NRNEYB5iYNXsQij97r2cSepGKvmAXfF0xZY+EdPzGskBbTh+rszuvoq9BISr5hnVp/C0AAKcwZUwvMS5K4QvZVTveBNP3jfH44OZlkFVD6flGRvX08PQ0yo0YyMmW7COHAo9en//hTZJ+dV7A1rDEOo+w5Dt4QiEyQwvtNH1INwMTUTgmcmcqtCKj1Ymbmg/rhoX5hCRKcpWo2ySwA7Lfza5oCj0XYohmg0qZ9Zdpm7MNUudX3H56cgWrBap67F5/WDVcxgfb83gkze4Z/AeksjuhAn73C+ktJwe8hrM3Ue+EE9g6scUZVNkaJcjW3D9tx+NoTlmunzQZ9GujrG+3IFDWfglvfc1+KRD/vjc7q7JyMhGPDAtJM0gu2kNdvlLHDpTmBeYusa9+A+lHbPsF5ZffrPMLLTdg+TU5NtQFkMMN9fdz5HQ+spd7cJ1Jbvf7tfshy9+Kkr+7qZk6/zDVJA8=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 32bc9e95-3de5-43a8-d2cf-08d7f76f8f42
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 May 2020 18:58:01.5534
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yNHV1zR3pCaJnv7zhy7Da1MzQKMb7Qd0LVQYLiL1vjbM/+eVlq77XRjlY7rHbJpN7R6TETXNORwm3VFKCzUocQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4799
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 13, 2020 at 10:05:59AM +0300, Leon Romanovsky wrote:
> On Mon, May 04, 2020 at 08:30:08AM +0300, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro@mellanox.com>
> >
> > Changelog
> > v1:
> >  * Rebased on latest rdma-next
> >  * Removed attr_is_valid() check from flags
> > v0: https://lore.kernel.org/linux-rdma/20200413135220.934007-1-leon@kernel.org
> >
> > Hi,
> >
> > This code from Naor refactors the fs_core and adds steering support
> > for default miss functionality.
> >
> > Thanks
> >
> > Maor Gottlieb (4):
> >   {IB/net}/mlx5: Simplify don't trap code
> >   net/mlx5: Add support in forward to namespace
> 
> Applied to mlx5-next with change of IS_ERR_OR_NULL().
> 
> 19386660212d net/mlx5: Add support in forward to namespace
> 8e14c75c999a {IB/net}/mlx5: Simplify don't trap code

Ok applied to for-next

Jason

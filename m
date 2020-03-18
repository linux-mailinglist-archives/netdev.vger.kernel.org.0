Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E19D6189CBD
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 14:21:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727002AbgCRNVX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 09:21:23 -0400
Received: from mail-eopbgr60048.outbound.protection.outlook.com ([40.107.6.48]:48960
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726638AbgCRNVX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Mar 2020 09:21:23 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OCtXyy9s29xpTuh0JM/2mu1HRj77Oy5F4N7n8lkyUN+InAfaNMNJQJHocr6qYUobpU57fc9QO1DFmDGvs61Bcr84XobtuUhW+5dV4E6wHXXB2NrG6uSKuSBX0jkh3Ypn29vwFzEglRn5J8UTW2NbfnBAMhusvvxXL4ttPutLN1flduSbc+H2pFo4QbATR9rlvYkD5RZEj6lSsgQObaHnHltFZFw3tqcm0d4wA036Xnb/rDhcNaFlf1JywUaKjVIAhRzRrrKbwSjuYShqDmlCdoVuyGviJygUo/GLcwWf5iRTPAIreiLiQYr6vhJy9ap3zxdOmL59c6GHkOrMyvPUVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h1pZp62DBYAgSl2mesasgr9V7m/Tjgv4qxp/ThFVtJo=;
 b=cq5fsQAg2JpJdlU004ghu2O2tEO127i2abMKoQeVmbW86wg0kNmSr7IDQUXCS2vN4bH22zMb2lbk+fSvuf0+whSNZirvGLzzWt+he+81Hqjqm4zqYhpJuyCPJHuuVrb2JKvfQs+CL3yKyZ1SIVDQ87iS2Rg9NSWBz4Ec7jvcb2h7887IJLsCKvbzw51M/tmkqyh+aZMpGpsEZZfmVU1nf6JM6lfjytZ0RjjmJ1Onh8Kvs0875SNQFl2RgqkIf1orHOfh1ZsDL9jpmFKWYpjCENA/p1cqLGxPeGSdH2Ihqj3dSFAsb27AtwLmvFKbgPlhwCe4iZuuCy/a5IDai0lH+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h1pZp62DBYAgSl2mesasgr9V7m/Tjgv4qxp/ThFVtJo=;
 b=MYRIvQ7Prd8ugHrllj8SjIQvcGmFaW9LcP667iAG1bdUuyPuo/iiv16EBEcr/B/toSoAw/N7VtBkQa7zx75hsQQeaOg6bcaqPpMwXQ9+Z6vF4YZqi2DeM/73aFc+jFiZBg/OUbpELsfzELFfiJ5bBMKdhbwkgobFp2Avt2aU+ek=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=jgg@mellanox.com; 
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com (52.133.14.15) by
 VI1PR05MB5262.eurprd05.prod.outlook.com (20.178.10.155) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2814.23; Wed, 18 Mar 2020 13:21:04 +0000
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::18d2:a9ea:519:add3]) by VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::18d2:a9ea:519:add3%7]) with mapi id 15.20.2814.025; Wed, 18 Mar 2020
 13:21:04 +0000
Date:   Wed, 18 Mar 2020 10:21:00 -0300
From:   Jason Gunthorpe <jgg@mellanox.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Doug Ledford <dledford@redhat.com>, linux-rdma@vger.kernel.org,
        Michael Guralnik <michaelgur@mellanox.com>,
        netdev@vger.kernel.org, Saeed Mahameed <saeedm@mellanox.com>,
        Yishai Hadas <yishaih@mellanox.com>
Subject: Re: [PATCH rdma-next 0/4] Introduce dynamic UAR allocation mode
Message-ID: <20200318132100.GK13183@mellanox.com>
References: <20200318124329.52111-1-leon@kernel.org>
 <20200318125459.GI13183@mellanox.com>
 <20200318131450.GY3351@unreal>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200318131450.GY3351@unreal>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: MN2PR13CA0026.namprd13.prod.outlook.com
 (2603:10b6:208:160::39) To VI1PR05MB4141.eurprd05.prod.outlook.com
 (2603:10a6:803:44::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.68.57.212) by MN2PR13CA0026.namprd13.prod.outlook.com (2603:10b6:208:160::39) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2835.10 via Frontend Transport; Wed, 18 Mar 2020 13:21:04 +0000
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)     (envelope-from <jgg@mellanox.com>)      id 1jEYd2-00051G-O0; Wed, 18 Mar 2020 10:21:00 -0300
X-Originating-IP: [142.68.57.212]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 5e08f6b9-e427-4b62-df39-08d7cb3f35ed
X-MS-TrafficTypeDiagnostic: VI1PR05MB5262:|VI1PR05MB5262:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB5262E15A97CECF0514F90447CFF70@VI1PR05MB5262.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-Forefront-PRVS: 03468CBA43
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(396003)(39860400002)(376002)(346002)(366004)(199004)(9746002)(81166006)(36756003)(81156014)(5660300002)(66476007)(8936002)(66556008)(54906003)(1076003)(9786002)(66946007)(8676002)(52116002)(316002)(186003)(2616005)(478600001)(4326008)(6916009)(2906002)(33656002)(26005)(86362001)(107886003)(24400500001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB5262;H:VI1PR05MB4141.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lrITy3Pad88YMNYILvYpjPmrNGXjpflbmqczJAXAXD35SsdDWZ/XsfbTOTnLYq3Ub1V9/W5nX2rPnplu6hzEv1tSk75p7muzHu1IMkExbIuKfe2TAxCAHXGGcxW0j36kE1pdTDZqckK7uRl/OzTwlyYJK/Sr+MQ/P+190lw0LBy3icA9YBaiiwg29oA3rvC1btHtRr5xh5jIfCH67kvtRdpAqkJtywN66Pokx4EaTqI6d1onmQhniDHGHyxWSkhyWKjb7ADOL91O8shEtfOv2+FUh+0qsCuFjk4SVFpu2+tTFxy2RX+TvaG3Bx7GykEZg8rli/mzMNmDwPzPXYUfik8Ou0D2lJDonkkclXHE4hVs960+ZxpotQsWt3DlXEtSibF2xhEMcsOO5yCrfMBR1DHAKASaUUj9hk+HHJQX3hyVRqPPVNP1YPu3+R47SSnwk6kfXw+3nuSWa7uJGfWVJ+m5/acTF+m0zLHbQ19E+75VFlE0NHnhBXQJ6/35s9cX
X-MS-Exchange-AntiSpam-MessageData: o9sZYPFHp6n0qVjaueLM/G0yyIcOk5B57sDHSRkpCqNFQtiM/Vx6LoW8fOddNVGlS2aW7DqotFslB6C9HN0iibopaVa8FNVUaw6RZfho6E3ZCfzCsOSiIwxJz/HFikABJvINaxruguQffN/V0s2EDA==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e08f6b9-e427-4b62-df39-08d7cb3f35ed
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Mar 2020 13:21:04.5743
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: s1qWNfV+z2UT6RxpdtM7YWP7sEFefBEgD6JFbJiyVqBAklNRnWOGaDUwZMdSxrbGYzAYjv/IXLTnVVcG47sYZA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5262
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 18, 2020 at 03:14:50PM +0200, Leon Romanovsky wrote:
> On Wed, Mar 18, 2020 at 09:54:59AM -0300, Jason Gunthorpe wrote:
> > On Wed, Mar 18, 2020 at 02:43:25PM +0200, Leon Romanovsky wrote:
> > > From: Leon Romanovsky <leonro@mellanox.com>
> > >
> > > From Yishai,
> > >
> > > This series exposes API to enable a dynamic allocation and management of a
> > > UAR which now becomes to be a regular uobject.
> > >
> > > Moving to that mode enables allocating a UAR only upon demand and drop the
> > > redundant static allocation of UARs upon context creation.
> > >
> > > In addition, it allows master and secondary processes that own the same command
> > > FD to allocate and manage UARs according to their needs, this can’t be achieved
> > > today.
> > >
> > > As part of this option, QP & CQ creation flows were adapted to support this
> > > dynamic UAR mode once asked by user space.
> > >
> > > Once this mode is asked by mlx5 user space driver on a given context, it will
> > > be mutual exclusive, means both the static and legacy dynamic modes for using
> > > UARs will be blocked.
> > >
> > > The legacy modes are supported for backward compatible reasons, looking
> > > forward we expect this new mode to be the default.
> >
> > We are starting to accumulate a lot of code that is now old-rdma-core
> > only.
> 
> Agree
> 
> >
> > I have been wondering if we should add something like
> >
> > #if CONFIG_INFINIBAND_MIN_RDMA_CORE_VERSION < 21
> > #endif
> 
> From one side it will definitely help to see old code, but from another
> it will create many ifdef inside of the code with a very little chance
> of testing. Also we will continue to have the same problem to decide when
> we can delete this code.

Well, it doesn't have to be an #ifdef, eg just sticking

if (CONFIG_INFINIBAND_MIN_RDMA_CORE_VERSION >= 21)
     return -ENOPROTOOPT;

at the top of obsolete functions would go a long way

> > So we can keep track of what is actually a used code flow and what is
> > now hard to test legacy code.
> >
> > eg this config would also disable the write interface(), turn off
> > compat write interfaces as they are switched to use ioctl, etc, etc.
> 
> What about if we introduce one ifdef, let's say CONFIG_INFINIBAND_LEGACY
> and put everything that will be declared as legacy to that bucket? And
> once every 5 (???) years delete everything from that bucket.

It is much harder to see what is really old vs only a little old

I'm not sure we can ever completely delete any of this, but at least
the distros can make an informed choice to either do more detailed
test of old libraries or disable those code paths.

Jason

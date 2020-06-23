Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78E52205835
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 19:04:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733060AbgFWRE1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 13:04:27 -0400
Received: from mail-eopbgr20054.outbound.protection.outlook.com ([40.107.2.54]:13189
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1733043AbgFWREW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Jun 2020 13:04:22 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ism7TNWVI4Bo7tv1Fo4uqLAOprJgTu5gZtBGoiDUP7/i21eYY+2GlwiP5buPR8tFwH5IyzJARQQW987evMcjAm/5QxTCtICY4aqEI/AST9OP/q+3gTCRaGLZckWWBkqXiSMYAU4lRnNFrtvBDZImjmR3GjTcIuttEx8ewU3gE/0OK7DnFVX3v+yc6bYI/Mc3M7yERXwO462JbbpFlaPiJKCAN+seoIv4HRgzkOr9Cne/4+Od5c7yKgUN3Fhdr3hhM9L/OxzRaweGOXpcuEQVIW8dZOTZKxY7zPbDoupQ3KIHDJioXD3T2h2Fng+n6zm9HlywY58yUXCt+Ypga3Zl0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nmL5LUrvGNv+E+YzcrkzJ9/zwWMeTn3ON9VMJEaHw7U=;
 b=G0iP0vhTfHb5EjK5FpdxJZaYAQAgmyvolEH/hraPbskudDX3jQhhEDQledWHhyw2c95/QpW20uMHY2u1JolW2advVxiNg2cgUf53PiraE+J4swWdcHusi5yR6vTm5uf0j6YW+EYnbwyGRPAc1yPg+aAeYZrg3spwDzdrVRTQvNcd3COjnrap43lWoiDaZlE5jv4kBzYvX0l29dYGqw3q9immy4iO1NyS7PxwaycUienrWPuwrGJYtB8XIwekMUFIvBh8NtVXnzbhXZUIHcDuJYVQlmBoYtOfyqnELy/Ubel/RIuW4o436XFXNyvdSldK79UOBC7bQfcFefWLDv64oA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nmL5LUrvGNv+E+YzcrkzJ9/zwWMeTn3ON9VMJEaHw7U=;
 b=eeU6cLhHg23/d/f/3AY18DjaQMZ57ZcUd4YKhnpcUpEx7HMY7lJbzdMsxcMR6KpqQ6PZ2oBoyj6Ivh0eNcZwNkLN/VbAbZVL6KGzj+rOrGN35eUrLG22wZx9fjHSa+ySxj4r0d0EWgzE7LfTeWRVxjY1/sEcK7OuqcCklXerjX4=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com (2603:10a6:803:44::15)
 by VI1PR05MB4783.eurprd05.prod.outlook.com (2603:10a6:802:5b::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.23; Tue, 23 Jun
 2020 17:04:17 +0000
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::848b:fcd0:efe3:189e]) by VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::848b:fcd0:efe3:189e%7]) with mapi id 15.20.3131.020; Tue, 23 Jun 2020
 17:04:17 +0000
Date:   Tue, 23 Jun 2020 14:04:10 -0300
From:   Jason Gunthorpe <jgg@mellanox.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Doug Ledford <dledford@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Lijun Ou <oulijun@huawei.com>, linux-rdma@vger.kernel.org,
        Maor Gottlieb <maorg@mellanox.com>, netdev@vger.kernel.org,
        Potnuri Bharat Teja <bharat@chelsio.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Weihang Li <liweihang@huawei.com>,
        "Wei Hu(Xavier)" <huwei87@hisilicon.com>
Subject: Re: [PATCH rdma-next v3 00/11] RAW format dumps through RDMAtool
Message-ID: <20200623170410.GI2874652@mellanox.com>
References: <20200623113043.1228482-1-leon@kernel.org>
 <20200623141957.GG2874652@mellanox.com>
 <20200623142727.GB184720@unreal>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200623142727.GB184720@unreal>
X-ClientProxiedBy: BL0PR01CA0020.prod.exchangelabs.com (2603:10b6:208:71::33)
 To VI1PR05MB4141.eurprd05.prod.outlook.com (2603:10a6:803:44::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (193.47.165.251) by BL0PR01CA0020.prod.exchangelabs.com (2603:10b6:208:71::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.22 via Frontend Transport; Tue, 23 Jun 2020 17:04:17 +0000
Received: from jgg by mlx with local (Exim 4.93)        (envelope-from <jgg@mellanox.com>)      id 1jnmLC-00CxEv-L4; Tue, 23 Jun 2020 14:04:10 -0300
X-Originating-IP: [193.47.165.251]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: e2d614cb-c1f3-4ff8-3281-08d8179776c9
X-MS-TrafficTypeDiagnostic: VI1PR05MB4783:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB47831EC3CA44BB748A2AE3CACF940@VI1PR05MB4783.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:820;
X-Forefront-PRVS: 04433051BF
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fY685WE4JUX4qJ5DjnhUtTBfbjEpwNA/rcS1+6fGIOsvd9atpj1cUNOEEBFJK46XEmWjs0OPP5zic0iFmBHHVDhDKgOCWZHqbyGmJZHY4QsEJmp5icXOO5bMDI5dMYd93m7e7IfRRNsu2yg/E0Y5YElxNEqDKi2iQCtKIiXNZnQ07i0EhqmFTj6lICTosX+DgPBbXfMarrYyaShgQpTdgDYbggEKcyKd8MEplKPaLhX9OwRgzwY1Zxi/UPmsr9iWX3NmOebDDERXJ0eMAZ1eJiPa07IoeQin5709foFHDg459Rxf26Z0T2HAvV+YpBbZVQ0KWEYfdHa3uAlKanvJZ5b9gu4yfsr7Oxe6yDqVxL6sLALXHwGQO4tmie2dMYJ60MgobgyPfKLe9rvUvqun6g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB4141.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39850400004)(136003)(346002)(396003)(376002)(366004)(316002)(26005)(33656002)(54906003)(66556008)(66476007)(66946007)(86362001)(5660300002)(426003)(4326008)(966005)(478600001)(186003)(6916009)(1076003)(2906002)(2616005)(9746002)(9786002)(8676002)(36756003)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: XxS354DRTz65+C9xvsPakQnR5cYP8pNF+zH2zb+XdIkuCFCdcpk7M1LWbKqIH0d/MdeqhxQO1JvClDD2t3OftrDZQkdUFG6UXBDzebd2WC0d6Y6ZpCG+zijHQkqpVUbM1QS0EjIn5+Y87TOshDSEaRJrdf8tTqsLAt4UjhhEbhm6/tlP0Bf5DRjsaP1crblYZpJMIZ7Xo9SXZ/Hx0c7CV86amVrhwsMjTKt5RBdBZngteJK5E/zxsHmmCrUZi9QX218mHR8ms2+vzCsLmHn3jo8sRuKJ6EhEj+Ly0BFUQPyi+mapg5l8UVjznd1LcpOEMzxhQ8boU38KD4jEQLE0mGg2KTIlpTI9Wylrn4s5nQaxZAOd6eepyM1BJBeXK2SmP9+HMs3DcdIud3L3XOVTzeBzf9flA6s1/qAEefYz5FZ6c7YqzU6jAUI7fHoejvBGF3U0Y6I/Pn+vI84enh2yw/oC5lR2G0x6JomFqtivRk4kl7rKG2170dwwu1EeXhat
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e2d614cb-c1f3-4ff8-3281-08d8179776c9
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jun 2020 17:04:17.5011
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Rs5dK6/ivAS8kTfPfABdV6i+DkkR81/0hcgtOxe2ZObTJnCdj5E2N6W8ewt8ieA0oRhCal4Nh4HM6xouphKKFg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4783
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 23, 2020 at 05:27:27PM +0300, Leon Romanovsky wrote:
> On Tue, Jun 23, 2020 at 11:19:57AM -0300, Jason Gunthorpe wrote:
> > On Tue, Jun 23, 2020 at 02:30:32PM +0300, Leon Romanovsky wrote:
> > > From: Leon Romanovsky <leonro@mellanox.com>
> > >
> > > Changelog:
> > > v3:
> > >  * Rewrote query interface in patch "RDMA: Add support to dump resource
> > >    tracker in RAW format"
> > > v2:
> > > https://lore.kernel.org/linux-rdma/20200616104006.2425549-1-leon@kernel.org
> > >  * Converted to specific nldev ops for RAW.
> > >  * Rebased on top of v5.8-rc1.
> > > v1:
> > > https://lore.kernel.org/linux-rdma/20200527135408.480878-1-leon@kernel.org
> > >  * Maor dropped controversial change to dummy interface.
> > > v0:
> > > https://lore.kernel.org/linux-rdma/20200513095034.208385-1-leon@kernel.org
> > >
> > >
> > > Hi,
> > >
> > > The following series adds support to get the RDMA resource data in RAW
> > > format. The main motivation for doing this is to enable vendors to return
> > > the entire QP/CQ/MR data without a need from the vendor to set each
> > > field separately.
> > >
> > > Thanks
> > >
> > >
> > > Maor Gottlieb (11):
> > >   net/mlx5: Export resource dump interface
> > >   net/mlx5: Add support in query QP, CQ and MKEY segments
> >
> > It looks OK can you apply these too the shared branch?
> 
> Thanks, applied.
> 
> 608ca553c9a2 net/mlx5: Add support in query QP, CQ and MKEY segments
> d63cc24933c7 net/mlx5: Export resource dump interface

Applied to for-next, thanks

Jason

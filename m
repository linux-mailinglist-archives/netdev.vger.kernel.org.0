Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5AA71EC5B9
	for <lists+netdev@lfdr.de>; Wed,  3 Jun 2020 01:29:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728460AbgFBX3Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jun 2020 19:29:16 -0400
Received: from mail-eopbgr60084.outbound.protection.outlook.com ([40.107.6.84]:42626
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728322AbgFBX3P (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Jun 2020 19:29:15 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c+BdHcH8meSYJvFSt98z9zR3Abk261BRlHv9ezUcbpW5G/YvkJGRs96eQflZJqDDgixmysHOTSqWWfyOX78zOscw9GLiywQZFZPS0SXxV4qSPZr6pXxD7g21X2h+bVtzklyfs+sFNsmswc0uDBPeB9LBEiAgfICImsdVj0PpKvrPYE9sjUU3j2baEMypL8I3+2cFgxxq1Ect1EK6QPe74LxsR0gV0LpVh/9V/WilLUmpCQkveJtkxYTa8tEzbgwKFWLU7parNgyixkH+iZr34rdEm0sReg3TT1CTAaUfj3mhSGjlMjPfQthPYo+T+B8yTJLXNLdi5+6qg9ZOWhFDGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YoPXYxQqGuwNJlfaIxOayxMfh2eXz4lIVV7Z/S5V/1U=;
 b=ny89+/Bw8PWzMC9lo8V75kbtMWmnu/KMeOsAUViLhXd7nMMylXyNa5v7L35iMteFZovzGPPwIc1cq7cQ1if178f3bJ56Ys4DK7TMG4/kBGz7mBee98Q+MtiXqzEz4e+cHBiUXCyGi4TP6Z+Lo4rOuBapREZ+aHMCm4grsBwWDvK2Qgf7UBQh7UHK/gYCeTl/OsT8Om3kp3WWz+CpUharUKBZ8O/1Kik4YVEgBfs3cJb2C46nklHdXX22yOFsiiJ9q6mjDscHO+KdAx+aCgwXEyxp5FyKmuUZ4rtP5fDwB9AjxcyLHEi/4gai8ZehVcItrIvo0nv+gyO7J8xxgDO8nQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YoPXYxQqGuwNJlfaIxOayxMfh2eXz4lIVV7Z/S5V/1U=;
 b=EKJgoAyXuXqx3u0HOV6hRlKCP9PVVVCwgtyCsiX5+DCZFYThHkIAPIyC2luzC1sbZfILYNN5SPglj63/GQpaamYqwC6EZWllNDmjejPdsxK9Z+jknts7OvC3tIWiBkVEoMrbVvw6SLbq1BZfovYO/Yh27pi5hsZQk7YyNQuGS1o=
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com (2603:10a6:803:44::15)
 by VI1PR05MB5759.eurprd05.prod.outlook.com (2603:10a6:803:cc::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.19; Tue, 2 Jun
 2020 23:29:10 +0000
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::848b:fcd0:efe3:189e]) by VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::848b:fcd0:efe3:189e%7]) with mapi id 15.20.3066.018; Tue, 2 Jun 2020
 23:29:10 +0000
Date:   Tue, 2 Jun 2020 20:29:03 -0300
From:   Jason Gunthorpe <jgg@mellanox.com>
To:     "Saleem, Shiraz" <shiraz.saleem@intel.com>
Cc:     Leon Romanovsky <leon@kernel.org>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "dledford@redhat.com" <dledford@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "poswald@suse.com" <poswald@suse.com>
Subject: Re: [RDMA RFC v6 00/16] Intel RDMA Driver Updates 2020-05-19
Message-ID: <20200602232903.GD65026@mellanox.com>
References: <20200520070415.3392210-1-jeffrey.t.kirsher@intel.com>
 <20200521141247.GQ24561@mellanox.com>
 <9DD61F30A802C4429A01CA4200E302A7EE04047F@fmsmsx124.amr.corp.intel.com>
 <20200527050855.GB349682@unreal>
 <9DD61F30A802C4429A01CA4200E302A7EE045C3B@fmsmsx124.amr.corp.intel.com>
 <20200601142840.GE4962@mellanox.com>
 <9DD61F30A802C4429A01CA4200E302A7EE04CC42@fmsmsx124.amr.corp.intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9DD61F30A802C4429A01CA4200E302A7EE04CC42@fmsmsx124.amr.corp.intel.com>
X-ClientProxiedBy: MN2PR12CA0013.namprd12.prod.outlook.com
 (2603:10b6:208:a8::26) To VI1PR05MB4141.eurprd05.prod.outlook.com
 (2603:10a6:803:44::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (193.47.165.251) by MN2PR12CA0013.namprd12.prod.outlook.com (2603:10b6:208:a8::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.19 via Frontend Transport; Tue, 2 Jun 2020 23:29:10 +0000
Received: from jgg by mlx with local (Exim 4.93)        (envelope-from <jgg@mellanox.com>)      id 1jgGL9-000Mq2-3d; Tue, 02 Jun 2020 20:29:03 -0300
X-Originating-IP: [193.47.165.251]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 793a0f5d-1bf2-4f39-60c7-08d8074cc0a7
X-MS-TrafficTypeDiagnostic: VI1PR05MB5759:
X-Microsoft-Antispam-PRVS: <VI1PR05MB57595A2DCCCE0B7ABD464B35CF8B0@VI1PR05MB5759.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 0422860ED4
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EL4PnhlaByMbN+K3KmIN5TF5CV1DrrIAP/jC3zRQY7RX2W8ip8UG3OZmG+O1onwLhC/so9ExDmNtOQA6j5Msitt688aQuMFov1Nlp9nLB5mIh5ucDkaWAsGudFPjTBdr/RjNfKdy0lo1OdpcuhbhuD8YkmqIY+bPUOAriQ/iaHAfJtyaPyE/+s/QQSp2YAXYVcy11Gk7Cl/H7/2qpchDaCqM6EutL+bCXOqMpbmWKWC9i45ujXuJ5q4cJOStA0avoD5JofdoIFoVV5O57wLWqEebc34HJtI3AauZf3X3/tDfU9sT2O026nJTfO9jI0cP8KZKbpiHO5rm/hEGlziQWg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB4141.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(376002)(136003)(366004)(39850400004)(396003)(8936002)(1076003)(7416002)(36756003)(5660300002)(9786002)(66946007)(66476007)(66556008)(33656002)(2906002)(6916009)(316002)(426003)(9746002)(2616005)(54906003)(478600001)(15650500001)(83380400001)(86362001)(186003)(8676002)(26005)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: sXM9XZUpdGLqJb8+djdDqVcSmCLbruVKa+2Qmr9Lj5E2QJYq3Kl8wFnw+WqImc+QXqzog4utqnoC9Ttpq7vd/UEBaAsp/ezZVyRlKvHBTywI6Ot8e91HLXrIU3+guChoXcYmqNg2KOXN0bQ6G21YreN+OZsD6J5MBfRVLEv5c5ZFRKpGjicza+m9Bl9i5M2YBrsC4pyMyt/cXQh3FIdbTqAJoo8L+L6O9HjWWhV3JhbVf8+U5S/0ImdZ6kEzYoLTXxN8xh16w6i3SeMs0TCdLrNmtrbO7XJtTl5APJc/KqujzTqTegsxvcGLCzJFrpL1B9JyLGHu92r4GmB/78Eb//oAMpMDGBNA9fJ35U1jGuKyjI6+qXKjDtXexSaTWscDHUUebgSs1t13JRzElbI0UkJAr9RsIU8Btc/E7dRwZp65j8V0huZ9XsLykkx2A5gZG3pmWM9QSdGk8em9d6WNd8ARJHqhQDHiGR42fk/lQ09OoXOLUvMjb/KIZ5hp3GYE
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 793a0f5d-1bf2-4f39-60c7-08d8074cc0a7
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2020 23:29:10.7446
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cIDhby2pvmiFP6XFoAU/bHRmWXqeux/35qHp+0rNSB8w8s9tEKxG8SFyjCBSunARMek4Lv8+s4Q1aWGtQ1d+CQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5759
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 02, 2020 at 10:59:46PM +0000, Saleem, Shiraz wrote:
> > Subject: Re: [RDMA RFC v6 00/16] Intel RDMA Driver Updates 2020-05-19
> > 
> > On Fri, May 29, 2020 at 03:21:05PM +0000, Saleem, Shiraz wrote:
> > > > Subject: Re: [RDMA RFC v6 00/16] Intel RDMA Driver Updates
> > > > 2020-05-19
> > > >
> > >
> > > [......]
> > >
> > > >
> > > > I'm looking on it and see static assignments, to by dynamic you will need "to
> > play"
> > > > with hw_shifts/hw_masks later, but you don't. What am I missing?
> > > >
> > > > +	for (i = 0; i < IRDMA_MAX_SHIFTS; ++i)
> > > > +		dev->hw_shifts[i] = i40iw_shifts[i];
> > > > +
> > > > +	for (i = 0; i < IRDMA_MAX_MASKS; ++i)
> > > > +		dev->hw_masks[i] = i40iw_masks[i];
> > > >
> > > > >
> > > > > we still need to use the custom macro FLD_LS_64 without FIELD_PREP
> > > > > in this case as FIELD_PREP expects compile time constants.
> > > > > +#define FLD_LS_64(dev, val, field)	\
> > > > > +	(((u64)(val) << (dev)->hw_shifts[field ## _S]) &
> > > > > +(dev)->hw_masks[field ## _M])
> > > > > And the shifts are still required for these fields which causes a
> > > > > bit of inconsistency
> > > > >
> > >
> > >
> > > The device hw_masks/hw_shifts array store masks/shifts of those
> > > descriptor fields that have same name across HW generations but differ
> > > in some attribute such as field width. Yes they are statically
> > > assigned, initialized with values from i40iw_masks and icrdma_masks,
> > > depending on the HW generation. We can even use GENMASK for the values
> > > in i40iw_masks[] , icrdma_masks[] but FIELD_PREP cant be used on
> > > dev->hw_masks[]
> > 
> > So compute the shift and mask when building i40iw_shifts array using the compile
> > time constant?
> > 
> 
> i40iw_shifts[] and i40iw_mask[] are setup as compile constants
> and used to initialize dev->hw_masks[], dev->hw_shifts[] if the device is gen1.
> I still don't see how FIELD_PREP can be used on a value and
> dev->hw_masks[i].

Well, you can't, you'd still have to use this indirection, the point
was to make the #define macros consistent 

Jason 

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C98441C9EB
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 18:16:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345703AbhI2QRs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 12:17:48 -0400
Received: from mail-dm6nam11on2042.outbound.protection.outlook.com ([40.107.223.42]:59136
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1344370AbhI2QRr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Sep 2021 12:17:47 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XUJwEJKYJUhBUTPFqd25oEFOfQHepnPGHqlQDwPB/Uq2GzxGjWIvpx7qRTrWLnMLe+cEq0u0zrN3JKan4MwEJqvqRfXLt2f8G0CFL/wiuDrvZXiEF0CvB2cedPW5RpBPtzwepI+0xghQL9PeXjK0sw68FwKk4FlD0SC6DD8iEVB51Lp6i1YO8XqV68tGL1nNctu4qXis3xjrrJBYZf+auYYJ4xwSlq9FkokZBa/qzbo/OPM9c45AgBB//7l7IC3RB2l36IWPR4jbO9nlC5kvzMfcFq26J6J3DTdbVglJ9Ia05hB0XPMFWZFSSCARrxccJQnsZGFhmTXZ3A1U4IKE7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=lE2xREPngNQ9maEpbpANEkwpIcbzNSqUFFQHF9gVA50=;
 b=RjtI0TMjDj9ZI/KtJBzWH5O5fLVgAKktAs5d1XhMx7Hxj+kNtTPsfSZHbxFneI7P7pCTyseBtPLZrl7UnnCQn9sAzV6zuULkmteP7sEflYRA/N0mUavzFp1aTfq+AMYLTw47rD1WK/yDXL+X8udWfvBflC88z0NaXFKa/s1SaBI+qz+/XrBgyeWEGlNwRPT6+CIYLRvWCHGarTHHxfJtonXAtwZo5Z7OecMN3Ou034JLGGjlhXlEYki+fH9sD/YFYeK8yWgscV294gS83XydW/9UTjrSrzCqo+t1uIcsAbxPff/S2kAaHilUjr7wto52TMayPbEGiytA7sqdiHJ07Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lE2xREPngNQ9maEpbpANEkwpIcbzNSqUFFQHF9gVA50=;
 b=K3rlsgdYwaba3o06iE5mHO/vPFsaTE7ZIfWkjsIAqnkZ8kdOWacdYvZ4xsi7dQFT9PDVeECSZIQKPlo7xTchH9aNBVIlcppLriBf5akPsu43s11dvN6V+VEy1sZAbMeZ6hHL9wjaRHaUQsT/YfoQ6G8bY7gqTTRWUdQdR7BFVvQcuUrIwPZe3DsrUoYynWlUBamckFK3NVejnFBqXr9TyugR3MP+TWnLjiQUefNGG8PKmLXGz7zdjB5uIWbe+HnQ3oRgWMkqgO1AxdBBIACpP27vuFU9oWhJHlkrJUHcGsMGJ0l5p15MMXe4EJLNVpGY1tBjLz90NNCU+llEYD2J2Q==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5253.namprd12.prod.outlook.com (2603:10b6:208:30b::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.14; Wed, 29 Sep
 2021 16:16:04 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95%8]) with mapi id 15.20.4566.015; Wed, 29 Sep 2021
 16:16:04 +0000
Date:   Wed, 29 Sep 2021 13:16:02 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Leon Romanovsky <leon@kernel.org>,
        Doug Ledford <dledford@redhat.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Kirti Wankhede <kwankhede@nvidia.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>
Subject: Re: [PATCH mlx5-next 2/7] vfio: Add an API to check migration state
 transition validity
Message-ID: <20210929161602.GA1805739@nvidia.com>
References: <cover.1632305919.git.leonro@nvidia.com>
 <c87f55d6fec77a22b110d3c9611744e6b28bba46.1632305919.git.leonro@nvidia.com>
 <20210927164648.1e2d49ac.alex.williamson@redhat.com>
 <20210927231239.GE3544071@ziepe.ca>
 <20210928131958.61b3abec.alex.williamson@redhat.com>
 <20210928193550.GR3544071@ziepe.ca>
 <20210928141844.15cea787.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210928141844.15cea787.alex.williamson@redhat.com>
X-ClientProxiedBy: BLAPR03CA0038.namprd03.prod.outlook.com
 (2603:10b6:208:32d::13) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (142.162.113.129) by BLAPR03CA0038.namprd03.prod.outlook.com (2603:10b6:208:32d::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.15 via Frontend Transport; Wed, 29 Sep 2021 16:16:03 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mVcFW-007cFl-RS; Wed, 29 Sep 2021 13:16:02 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2b7c946c-315c-4a3b-04ab-08d983646f6d
X-MS-TrafficTypeDiagnostic: BL1PR12MB5253:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB5253F6FDCED6FAF31DC73BF5C2A99@BL1PR12MB5253.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tMPtC+LRLn8S9MyTyQc7dlryeA9xnw5reYHXzRFhOPxLCSz6fZtIro5OTLdemyPGtadeynAPbfoJjwmDlrdeYQVb/QBRs2xxrtJY9BO2if045Vr7mJIx4qqpL09xgsEZZAChDkbjPvEdPgiH/DAA2Z5pTWMSbtxT+L+2irECYBkBG8dWJe+2RWoo3zDhJWT1jRNj7qYSskr8Chvu/KuhEMHLk4OrNM1+ULvdCONwM44FPtHzHXfDfDNSAUp6aKLpcpOcMtF06QHkiifJN19+zSMQJxHO7cpyeX7HYVI7Txrz1n1YspbfCxzB8NdwfQCm37DkUmgf/RywysgjoDWJh5yXWVoW8mpXeCRAWs6Uy1GzJHSyZ0Lt9kfWYH/rzy2bsthQO7nXaToorsOIMlp6zMh3RpSxuh27FKAie8k9Szu6gUlWA1pCQ8n4of4EzBtKdC6f9coB1HYe3GQ7DKWt7TdBS+1ilIqTt24ZwWVQJlSVNoxbUCWHzC4g+If4V36zaPUNyoOnryLUiShhN+z93WiszQ+vh6tt76yGpkj5l7bR91mf1swGTYTbjftMgWERDJqlaNUSrHr2BeiAjQbW22E0HDeNdAQGg+aBmJEcbfAVytWhvpDyYWcebo+1vlcJDC9/FuKa6guAUcEGmJlhGA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(33656002)(38100700002)(54906003)(186003)(316002)(6916009)(8936002)(508600001)(36756003)(1076003)(426003)(66476007)(66556008)(7416002)(4326008)(26005)(86362001)(2906002)(5660300002)(8676002)(83380400001)(9746002)(9786002)(2616005)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?nEi71eORGmJAjO++tEt+pG71h/C60x8yAsMTHkmh9GPtCyc00mb7YYw4vL5g?=
 =?us-ascii?Q?tx8o4wQ69kWT06BPJfID5xMKDFKMYcQecE/mOuWHymbBnJNY+rZHEi9OP8HX?=
 =?us-ascii?Q?84Gj+AhnTP72O+mps0/h7YqXSM6KMkFOCgN9kQ5HnNW+x8lVdrSgPapB9EuI?=
 =?us-ascii?Q?9pFA5gwXkneIaxnDtmm0YPszzNthDnfu9Xe8uTNlf/E3W1NhLOV9Cfh0QoyS?=
 =?us-ascii?Q?YNAAo/q02Mgzbsxx9dQ5E9OJUAor25v4FVtOLzAHcd7n7niEi9GyW9xZTOe6?=
 =?us-ascii?Q?8fRes5h3JgRc9uqK4m2Qt/Ex9en/33cA4ZRFclXx5hz65/KGkjGvUOujL6mh?=
 =?us-ascii?Q?rtvmXPnfz+xJchqaVH5Z4iRwH98ScqsLMYUTZffxUXS1iuIvSO1YzdI4wjid?=
 =?us-ascii?Q?z4uVUljqbYHoTRhOfCVgTOHX3mx00OVvD5O8tLiL7EO52u2DW1nij/ZcahCa?=
 =?us-ascii?Q?p8YaIa2wefu3hBJFg/om5TpF+JUUEk/b2XWHeffjgOp7QB8qZT5fBKjl5m2K?=
 =?us-ascii?Q?DNRsmU0LghEgqtyp2IgbWcyVYl4kpXX90kri80dcWQgORi41DjPhOZVcVRgO?=
 =?us-ascii?Q?uUyZKshYyJuHMzexbbAwEDmGI87fRet5iw0OdC9nIVEJZDtdM4c5izyAIKbT?=
 =?us-ascii?Q?XxY2kKltqTOTnkTMcGsjzC/P5dB2lTQ2UVGlcrknOLgALBRYWdtR+E9nesiR?=
 =?us-ascii?Q?BJxGq4xgu3BKiUALVS5PB74sppfOI9QKuC83M698zxK3hPH+f7xcKhvHRr2r?=
 =?us-ascii?Q?dxSUL/oT/z3F2D+hKDwUymbKDfXpy0d6OI7mq+4I6isHcPYjL/uv+1AwXI8v?=
 =?us-ascii?Q?vVNdkelJVGA4Mw395YJsINs5J25afSTsMQ81Wl4pvO6C86tr2RFMvJrygdpY?=
 =?us-ascii?Q?Jt8jFNg3NOdUxlkrSqyxJsrQ7a+8maTft5DhH/7mJNeuDlMFkP+zGWd3xmYB?=
 =?us-ascii?Q?NYgC/2rx1a9cA1nDfoYuu1WZiCwIqFMkgtcCgI09eD2qMoreoen9Ce1x57m3?=
 =?us-ascii?Q?zlxjexUQTwYOmFHnHARYuPE0jEjIjPgyUR/+ih6I5qNOsXuvw+NiKTKaK8a5?=
 =?us-ascii?Q?aLhMasSeu8af6Otco5Y6e2C4mtj3l5s+cUHa+yipZWPZYtOu4Gqy6DDTnw0v?=
 =?us-ascii?Q?iCOPG/2vLxte6Ba4k3UAmdu5ALYa1FtRlbssGVNGfM0i5dMhCUCXFF1dc2Uq?=
 =?us-ascii?Q?BkHB4LR4UtRZ7M6XbfRFhmcWbqHO6dRexu+lRHS6dy/TETO+rsT3meXL2aah?=
 =?us-ascii?Q?M0QZxKKYSxpPlW2SVIWazg1eE8YM5oj2jKF2iE9n52EI+2COQCLCQ1nguTOU?=
 =?us-ascii?Q?sJiHtIFdBJL6sEci4NM3uu9p?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b7c946c-315c-4a3b-04ab-08d983646f6d
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2021 16:16:04.2056
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8VWUHSiGrzhUS4wB2VBTFv0cJm1WcKVExee6YVFQ8iNbWHjhld0Mh9BqpayL3rRt
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5253
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 28, 2021 at 02:18:44PM -0600, Alex Williamson wrote:
> On Tue, 28 Sep 2021 16:35:50 -0300
> Jason Gunthorpe <jgg@ziepe.ca> wrote:
> 
> > On Tue, Sep 28, 2021 at 01:19:58PM -0600, Alex Williamson wrote:
> > 
> > > In defining the device state, we tried to steer away from defining it
> > > in terms of the QEMU migration API, but rather as a set of controls
> > > that could be used to support that API to leave us some degree of
> > > independence that QEMU implementation might evolve.  
> > 
> > That is certainly a different perspective, it would have been
> > better to not express this idea as a FSM in that case...
> > 
> > So each state in mlx5vf_pci_set_device_state() should call the correct
> > combination of (un)freeze, (un)quiesce and so on so each state
> > reflects a defined operation of the device?
> 
> I'd expect so, for instance the implementation of entering the _STOP
> state presumes a previous state that where the device is apparently
> already quiesced.  That doesn't support a direct _RUNNING -> _STOP
> transition where I argued in the linked threads that those states
> should be reachable from any other state.  Thanks,

If we focus on mlx5 there are two device 'flags' to manage:
 - Device cannot issue DMAs
 - Device internal state cannot change (ie cannot receive DMAs)

This is necessary to co-ordinate across multiple devices that might be
doing peer to peer DMA between them. The whole multi-device complex
should be moved to "cannot issue DMA's" then the whole complex would
go to "state cannot change" and be serialized.

The expected sequence at the device is thus

Resuming
 full stop -> does not issue DMAs -> full operation
Suspend
 full operation -> does not issue DMAs -> full stop

Further the device has two actions
 - Trigger serializating the device state
 - Trigger de-serializing the device state

So, what is the behavior upon each state:

 *  000b => Device Stopped, not saving or resuming
     Does not issue DMAs
     Internal state cannot change

 *  001b => Device running, which is the default state
     Neither flags

 *  010b => Stop the device & save the device state, stop-and-copy state
     Does not issue DMAs
     Internal state cannot change

 *  011b => Device running and save the device state, pre-copy state
     Neither flags
     (future, DMA tracking turned on)

 *  100b => Device stopped and the device state is resuming
     Does not issue DMAs
     Internal state cannot change
     
 *  110b => Error state
    ???

 *  101b => Invalid state
 *  111b => Invalid state

    ???

What should the ??'s be? It looks like mlx5 doesn't use these, so it
should just refuse to enter these states in the first place..

The two actions:
 trigger serializing the device state
   Done when asked to go to 010b ?

 trigger de-serializing the device state
   Done when transition from 100b -> 000b ?

There is a missing state "Stop Active Transactions" which would be
only "does not issue DMAs". I've seen a proposal to add that.

I'm happy enough with this and it seems clean and easy enough to
implement.

Jason

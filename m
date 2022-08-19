Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C3E3599FE4
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 18:30:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352091AbiHSQVN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 12:21:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352280AbiHSQU3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 12:20:29 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E495D109593
        for <netdev@vger.kernel.org>; Fri, 19 Aug 2022 09:01:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jXzmL0J9vRxw8t7kND3pB/hgyz7xkbkDd8VG5HEiGqbKyOSJxjEekvnDf2/p3+xfxkl4mz2ownJ4/nQH5FvF8o+m7/WUl1SmCMhCdgs0kXuJxhfkJBYMDXQfS7lpdEtf3b3X524XDwrGZYuIfz1RWs4/zZMkg9l8Lzz27xCtd6bAc3zCDEYWPRdryoStyyBqD9qqNsU/RbOFMl9szwi4HlLoM4CNYz373MQej2Aj901fDTMknsn5jSBxSBwSXw7UATtW+V+IcgO1b7r5+WCC/p1tRPOHogBx14Hstr9A9KIvJgeNn7UDehjX6+UbLE2RtpTgbmZQAaq4/nh86xi2mg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eQDVu1G8qdX6bJcgqCuRmg/EnQhmi1Ggxv7WstMnL5I=;
 b=YFtT3thCvVhXHmShhoftyMWllHzT/KDZyS3XtWkXsLMElde71bJ08MH9/rbtT5TwjEGfhxgJyociVH10sSXTdV4BDcG/LXO22xPEekmxraSO0mmFFcveyF+IhZzY4/FlIRZ1yCTfQCpiiOyMuMbvxDfUp87ikHXpoCXaASs3V8Fd+aL4HcGShgGHpjfA52RFzbB1Uy5BxnU6SX/3PQdMdiYlVLB9gsGuIwX1HlOLJb52PjaRFF3/ztZQw4i1J/xKg3PZnl2rGImAEelf9ID7nW7mWnprlNskaQi8QoeMJJU1wrjkxe7aMdRF14qQ2CgglwwqEoH+yh3kVBn5r5o3ug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eQDVu1G8qdX6bJcgqCuRmg/EnQhmi1Ggxv7WstMnL5I=;
 b=Dlg42ISF0+eTAZj8n643c9UKTiX5VF3Wr9IAj86JWKecM3asi39fvKITUG0AuA7qsbQJvNa8+ITpnRNeGOMm1omqZtM+HnZNDDAWTK+SqN8KGx0z36MF4E2ESLql20IwuN0R5asS9R67q6uVlWuvw/cIDJ/CGoSBLw49r8aCMAGJ9OXpWfDWxrajL6OdXIcOMrjBUcJ5ABB5tufhJ6Kjwp+64GteIHqstuXF7ZdvVmn/RSSRhlKlM9mCtdf6pSucTHm7gmQXqYXwYQHrRobm1ig1uD/aWve2Mro9k5RhaOQTVxHKymEV9oI/tGpCrDzeAejlQ6qxnS/+sNp7Os/tZg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by DM6PR12MB3354.namprd12.prod.outlook.com (2603:10b6:5:11f::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.15; Fri, 19 Aug
 2022 16:01:24 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5%6]) with mapi id 15.20.5525.019; Fri, 19 Aug 2022
 16:01:24 +0000
Date:   Fri, 19 Aug 2022 13:01:22 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Leon Romanovsky <leon@kernel.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        "David S . Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        netdev@vger.kernel.org, Raed Salem <raeds@nvidia.com>,
        ipsec-devel <devel@linux-ipsec.org>
Subject: Re: [PATCH xfrm-next v2 0/6] Extend XFRM core to allow full offload
 configuration
Message-ID: <Yv+z0nBW60SBFAmZ@nvidia.com>
References: <cover.1660639789.git.leonro@nvidia.com>
 <20220816195408.56eec0ed@kernel.org>
 <Yvx6+qLPWWfCmDVG@unreal>
 <20220817111052.0ddf40b0@kernel.org>
 <Yv3M/T5K/f35R5UM@unreal>
 <20220818193449.35c79b63@kernel.org>
 <Yv8lGtYIz4z043aI@unreal>
 <20220819084707.7ed64b72@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220819084707.7ed64b72@kernel.org>
X-ClientProxiedBy: BLAPR03CA0078.namprd03.prod.outlook.com
 (2603:10b6:208:329::23) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cc4917bd-ad15-44dc-0b4e-08da81fc10ce
X-MS-TrafficTypeDiagnostic: DM6PR12MB3354:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: M0Ac/8z4+aC746L6LLT8JwIWSAzyAfEWYMHC27UYBclpJtAzJygGLfYxZyuiVtxNhqpChlD4VdBUWJzx6zroGFBr9KQWRhz9Z7fUTAlP+MiwhLiW/ceuBs+z41Lvs3JJ1eSuL7pDSyVsrnZ8faBelmhMuZcwnApigHFH1nGzwDEqqq8B6AEjWhIzWQEI6efaC7fIblVu9A568r/IQ0cqLPr0r4bovw0AYrrWTLjIAahRj+d2BT3BY4J908OUGR4t+NbylLL8QaNWpzYMKPfzEmeiuiusJ6o6czYorquJZbZKx7LStO0UayKquymaC+FXhyX77xfAamM7kMepjTD2szELU6HGHf/7CLWb7puQitCDkIGnWbrteZ8oB1x1UmZ3l49JWdaClAypBfk5aYOQxlYsqLq7eSZEnU/ZS32LJ4LJGrFWZDz4i+L4UMGPLvIJQGLmVn5WTITYCdz3d+5trVQjwL/bVqmALEu9SLSMYQfvP99fRAn4wwa+pXIGXgGGU5Hosqqpn4Jmsl/2PxfYz2wqLdbpoXAxwNME9ofXjX453KIoQc1admJvRLE3v/VlTFt8qidHEvo3IfgbduaToI0mf9h2SO/GDtADWzAq030g/sw0uuONpUG6cP4/GQ6ISuHe5ZrBzBT5oOIPLeg170N29TFBmUVzf2JkeX6TnPAvn5dkkpy6qjBfkL6UDmImF787bjM4XQy61v5zZ5sU3CQSGwHQ2KVAOA4akzSM6E0pHWq+1gaDGGturVilL8/osvKnd5xl/HfWzlTurxdDIpYwZiSwFXk9e1OTjiF3EWtCX0X0frlyuxvzmIhDNeFXozT3LkRRzwK0kwkL92H66g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(366004)(376002)(346002)(136003)(396003)(86362001)(8936002)(5660300002)(966005)(6486002)(478600001)(8676002)(66556008)(66476007)(6512007)(26005)(66946007)(4744005)(186003)(4326008)(2616005)(41300700001)(6506007)(38100700002)(2906002)(54906003)(36756003)(316002)(6916009)(67856001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?sQnCV3Y044CyUH0oy3Ef6aDwbzmS96aEYAsuy0owtKNpbCEIYHAKG0JqSqN5?=
 =?us-ascii?Q?Kl7nUd21jN2HpPticYoAqumqgT2beS3IdgowAkPFkeP02SyyBbgXC+UfD8UC?=
 =?us-ascii?Q?z+rworg6X/NYAnKLtl2ErE9ovEZiY2AnKRsoj5xWjkzeFTnd2Da7g1NN1faX?=
 =?us-ascii?Q?/PvHD1ckGWqGVvH+/pTzjTIzYOz0n5soahKIvgPY9XrUhWOlvUZG0P/j5KTQ?=
 =?us-ascii?Q?W8J0jZCyzKKHmzCRhOVswDc6t9u0DmRB2IB+vZD0qP9zid35JuYIs93GNaS1?=
 =?us-ascii?Q?pWaXgblKdQieIpE4Ww90a+HI1+n8hHKqadLv2g+GFWqvzTEIAhGzAYfkMXqN?=
 =?us-ascii?Q?QKKkqJ25MXdWGS3Me1sic6L6/TCssIiv+pwQhsOOra/yZSkvxAkMjHyRe2hq?=
 =?us-ascii?Q?6U3zwQ/UyC7sXdAohYKo7+MCSjnyXBQUBP0bW89wlgXsZX5mBEL0NKNmUGtm?=
 =?us-ascii?Q?wrpAv1kFsGioZtQ+Q2men/J+PCHWrgpzU+VW8g0qpqCoNfY0Ixk8C/nkW68p?=
 =?us-ascii?Q?AicMTj42RiDGMZGLfIMmxAIFIL+YbjT8/2iR3pNJJj3i3q5yDvPAAmYxaK+a?=
 =?us-ascii?Q?XYPDVwwOQ02hZibkTat8nvJShVYEtvy+8xwO8aJFU9oR400C0JeNGl9ZfNjj?=
 =?us-ascii?Q?/+VeumvMNwc4Qnj/kqfTv3REW14GEfhLOvw8iZ/47Z8ba8tLXTr8v7w0BAo8?=
 =?us-ascii?Q?ptM2LS5mFNPBHF//f6fIkVLXYme4nAPR35A0AjAZTBDXiD25Jfa/u8EZ7MvI?=
 =?us-ascii?Q?0bBG6DrmmtL1dN/ZeXcHzyFBDV8KGJWCoB/dhdqhtrveas4oyQyepgufNmHG?=
 =?us-ascii?Q?hUZ1p5Qyj5HTBjOO0KwSoBlz1zK8zK8JZabILSgX4EDS2VM3Q+sP/OkCro3o?=
 =?us-ascii?Q?40j+B3mVzxjOC40kZmTrWIRy07PjO4djpjj1Xm49RcFJCFdymStFiTt1/VMc?=
 =?us-ascii?Q?pJpIGaSgYeNdPvsPBswkQQVjvhIoe0FhhbFLkIgFP/TP75Fa4pT++fnT1Icn?=
 =?us-ascii?Q?EyHfvHOw2RGsKxvRtkYOxww5IPtzPhKsePdE37MoeZMM9o132i/iiyGq5Wik?=
 =?us-ascii?Q?ENIqstsLS3sGhx9ZJEM6r8DNGB2pYk5J9J4sE22rwNrO7Ran3gVwPdMQGcmq?=
 =?us-ascii?Q?sTJ5H/ToQB5Z8hlp/769MvyUmUDHPizzEx+Xs1SP72BgsKNnya9Szsobxkyp?=
 =?us-ascii?Q?69TYi0lEa34RBtIf7tI8ZWTEpWF9ODeVKsEJ/MSC/dcfst24rQMP08fiJ9FJ?=
 =?us-ascii?Q?brESwFdC1g0QYvZ/yw62fgOsoAsCz3XLYIKqPzUl37xwNMIkCPHzggAbV/FC?=
 =?us-ascii?Q?SsMN9cVd7ran0GS+2vOcKIztYx0jiEu7kvuLbIifsoSYH2RHgj1wAT4sR8kS?=
 =?us-ascii?Q?FJ1J+owSlGHWRGkqpxg2mjeiNll42vzeYeoD0wIKYnO07IYUFnhDino0oydv?=
 =?us-ascii?Q?K6oaBsGadxegKr3HAEhGICU1H8/x5P82C1vuRHgE0lIpRhFdQaldFbrdQwCy?=
 =?us-ascii?Q?wN8bBy5w7Sf1/srHTH2SBCFAugt175yq92JMLzRiwjrXEhU7BwnEv++U3M8L?=
 =?us-ascii?Q?F5Bp1Q/WpxBu6gDmVFwAD0EGZOam3eH7pjP990YB?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cc4917bd-ad15-44dc-0b4e-08da81fc10ce
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Aug 2022 16:01:24.1432
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eqlvmPUF8Avwq/MZ3tuYC9xAnbanTXGPTc1LouGish1y9h/E22sIPqmnj3poaqEz
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3354
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 19, 2022 at 08:47:07AM -0700, Jakub Kicinski wrote:

> > I invite you to take a look on Jason's presentation "Challenges of the
> > RDMA subsystem", which he gave 3 years ago, about RDMA and challenges
> > with netdev.
> > https://lpc.events/event/4/contributions/364/
> 
> I appreciate the invite, but it's not high enough on my list of interest
> to spend time on.

Regardless, RDMA doesn't really intersect with this netdev work for
XFRM beyond the usual ways that RDMA IP traffic can be captured by or
run parallel to netdev.

A significant use case here is for switchdev modes where the switch
will subject traffic from a switch port to ESP, not unlike it already
does with vlan, vxlan, etc and other already fully offloaded switching
transforms.

Jason

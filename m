Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 291B16E1051
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 16:47:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231365AbjDMOrR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 10:47:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231349AbjDMOrD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 10:47:03 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2050.outbound.protection.outlook.com [40.107.92.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA674B446;
        Thu, 13 Apr 2023 07:46:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fVyhiBZLem0Er8D2BnASVFcTvGZNMb7wOeYLuM226qyDUn2s9NMHhuDEhZzdZ4g27u0JA4v+ox36e4s2cE1MMeM+E5/fIMSRkyAZ/ALyC+nLeLp3VXTSL/L46YmMBGBSOrYp6zrn5lv0Gg3tRM2YMzViZg2j8eCp6yWedU/G3Xsm4f2NJwe9GfonIhaQBVQE3wTb9zwK2cKyZOvXmMGZr2E7ZXsV1RpNWE2XPAbPbOZtwpf1JTfLtjqjCKMvFNV/xazZ/CWnuuP4GtViOTPZD4J/MJ/6kb9IhozedrgO6VA8Mfs24M3Lr7HwKrcHkMZ3mQ7iZZcBVnz0WkXulLS0wg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hg0TVVSVmHoCSq09o8YMzNbDqlSes+QBzk9rIF6C8xY=;
 b=AEQtHKU0dVO2/qNHGLcbAEyCyHVTLsY/mdiBxDswp86wsLbAQcaaHfnpdH7xtc3pn8PxWELy4HZmTe17B46tGWMqKMAuj1NnHYLw0vpQIqo0NiQvDhPLlo0kg0umXtv0eJNYbdHZNf3bY0DrRMpC0hGV2MvutMPshQsJ6GZgzm0GxWPps/+lvu+nc82SWwkf+12dyY0pO+ApRjcVCYIq0wycYDZz82le5fnEM8maqXI4fFFu27MU1LRLyql+O2zFz+aGqBTuci7dyM4m1GSPFJIi1437CLTVSGGkg+ZLKYJS7ogN/bf7swixlGwuOdWRTaZvHtbvgRiOvsXbdE/tcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hg0TVVSVmHoCSq09o8YMzNbDqlSes+QBzk9rIF6C8xY=;
 b=Z2adElvWUdQfnx4UuIK195UHkBzHEGALffcGI+FwiQYt3QL20eJX6au+XT6pD0fyi/8Az76I4MSuIG+E9LA0SyVH4BqbOZjTA6IcGi72Uca2PxXiyPCfyjrKWna1bcEQZYgdSmmLZMeTtt4yiSLh47R4QAjd7amYL6sR8xkphqHccDgg3M/wHr6e1d3cMwMqW6y2K6ROUansuO5yRkGdJv89pG3UTR96nPbp1bU9PP7GJja+FCJ4cnqWkiu/6+MH4SR1bs8Dcy50L/Mw73s/vaQ2lVZQIRfx7tqihAabBP+zB8qNTcRXM/ihQtwwi0WztHmOIuYdgNBWSniEztcYQw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by BY5PR12MB4210.namprd12.prod.outlook.com (2603:10b6:a03:203::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.30; Thu, 13 Apr
 2023 14:46:20 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::6045:ad97:10b7:62a2]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::6045:ad97:10b7:62a2%9]) with mapi id 15.20.6298.030; Thu, 13 Apr 2023
 14:46:19 +0000
Date:   Thu, 13 Apr 2023 11:46:16 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Jacob Keller <jacob.e.keller@intel.com>,
        Avihai Horon <avihaih@nvidia.com>, Aya Levin <ayal@nvidia.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, Meir Lichtinger <meirl@mellanox.com>,
        Michael Guralnik <michaelgur@mellanox.com>,
        netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Shay Drory <shayd@nvidia.com>
Subject: Re: [PATCH rdma-next 0/4] Allow relaxed ordering read in VFs and VMs
Message-ID: <ZDgVuIbnTCPYVVpa@nvidia.com>
References: <cover.1681131553.git.leon@kernel.org>
 <ZDVoH0W27xo6mAbW@nvidia.com>
 <7c5eb785-0fe7-e0e5-8232-403e1d3538ac@intel.com>
 <20230413124929.GN17993@unreal>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230413124929.GN17993@unreal>
X-ClientProxiedBy: BYAPR21CA0013.namprd21.prod.outlook.com
 (2603:10b6:a03:114::23) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|BY5PR12MB4210:EE_
X-MS-Office365-Filtering-Correlation-Id: 35d65baa-9e13-450d-3b8f-08db3c2dd7e3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: l7w+Z1zC5j4eOg3C3G1p6vKDxKxvqedJVtcNSFBNAdEecKQOHq1q+6D7uaxhv2D6l9TuOBOovYdaJyjrhKSmu7cIOcRwsgvSET6txF0OwotIk0ingmXued6OwdpMGjpN7RaJX6EnnLsQt+z1HmalKJIQel7WKnFOlt1I9PmY/qdw74AwzPDuUW5RiaNuMO49RBtW5AeQbygm3ST30VkInfZDb01nW5cQKfKy1nWdPT0ueM5eaX09QyjErDB9l6lZmSsMF/peAjBHJmMZDUCUR2//18Mnc9Zsin7cL9fqi+z8X0vkKpq3UXWsmFBqsiM3UW4tN9FvEN02We8v/b+OSWHp4lpn5ZPNGtfI/BSb2Tsr6vfBpwZKvFcojZ9bBw4+wWii+jUYbh9oCBeVAbugo4z9k81lcKQK+QYxqDAwkU1wfpWTVtJYkN2MR99ryaVvEgU5WItDdh+0lLyJT8KD6eYkrs1QtHpwlFNzJi/98jHIFrX0wqGrD1+L/OrXRueakyoY0DK83V7Et33zYKReQt61wi6/UMuP0cPizBAGmG5IStnbjVGmig2eEHflEgek
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(346002)(39860400002)(366004)(136003)(396003)(451199021)(38100700002)(5660300002)(36756003)(2906002)(316002)(8676002)(8936002)(86362001)(66556008)(41300700001)(66946007)(6916009)(66476007)(4326008)(2616005)(83380400001)(54906003)(107886003)(6506007)(186003)(478600001)(26005)(6512007)(6486002)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?lw5n2a4D4Wc8rAcYqGZC7zZ4hM6ONzVHUTqepsGcWoilgtZ4ceDE3VAMFM6p?=
 =?us-ascii?Q?sjcT6Xc0Hy6kWL5kt/T3NLKi5fXh4y9ZtZvpXE750zlq1ZoAmN7gaFh7gLg1?=
 =?us-ascii?Q?9aHeiZdV+6Q5aDQB0Fw5iuzFDBm550m3h/cck5cyIzex/y1osGGyi6KwA0jf?=
 =?us-ascii?Q?IZkaz+3m7PKWFDzmn+fJ5FmsVogRKl52Lvx761zGPUqJobzmB/EYyM9h2K6w?=
 =?us-ascii?Q?Y2J0NtTeyU+ll7ywA6Kg6OLOqHGE8GZxA+y0zNYZCP8fzyOBh/fFWUKrRvE7?=
 =?us-ascii?Q?eJGhX1vaClsveXicZ/2N+X0H70gaW6iiogHJ5YFAfUKT4TrPKw+7x64pUniG?=
 =?us-ascii?Q?cSWnHduJ8zHuMPcEJ1EFZEiJ/naDhkUY28etxvRKA+ilWQrzmuG3KzOuX9vI?=
 =?us-ascii?Q?WHt7tgd3aXdoTKMWtI3N4OVsgVpnkZpCt7rqT14SstvjVEkPfXZ3SoGq/25Z?=
 =?us-ascii?Q?9uYDEvHpzI8/5Ufe7sWJG/4HJ/0saCdXgwwzFwoztODBXpqKYsIN0yuq2pjA?=
 =?us-ascii?Q?vD95MlGskl9x+8FT2qj4jpwOdYrxkUO6iLU8zgdNbeg8jOkSin6maZZ4kmsM?=
 =?us-ascii?Q?20V9IZmdiI3bRZLNJvVOu2+C9m0nv9sd4uLiRyAnvyrhWjzfGspJS4prMVJK?=
 =?us-ascii?Q?7VsM2ikd7S2EcJdN1d0DLAbpQthtDHyFi5OjprllRa9m3BuDGonFOnhAhuZh?=
 =?us-ascii?Q?JOBeAZBUTEYUdBd3P/bHjZO1VcnDmoUysgHwlkRVcktTTeGU1tmjHS2WbVId?=
 =?us-ascii?Q?3vL8zO7etdzKooenkox1EDC9EeYhMyLFrM2WahIn1oMdmieL+GrszqBpPya/?=
 =?us-ascii?Q?9LoNDr4mRZdfhNTTpFQwW6ad6xxCByg8sAKkH7Ha8MR2enBYl9nFO+quY5AW?=
 =?us-ascii?Q?zrkjEeWNpQG/WinqfnMQpV1W3UgkmXXGUHJPyyp0bAArVGodS0+YWfHUV+SN?=
 =?us-ascii?Q?urGLl+eOcqbqmHcPxg2SinKPyU0OhtD3YwXgbxXeB6FaA/DmrhCaM7AOl83w?=
 =?us-ascii?Q?XcdsciQpfWQ+pu5SXUuX4LhTC0EV0l56rze0Ek/ViMsF7PgIrSJ4azSt01ee?=
 =?us-ascii?Q?Fka7sdI2DfpH4UAcE2JcjA4oT86gbO0XjPNBcbWcV8Ic9WEiAyvU7I840+EX?=
 =?us-ascii?Q?PPm76QzkOhEV+peumkZpLLeB8NX14pLlMM8AuScHgkl5qR78HF7CJnq0D9i/?=
 =?us-ascii?Q?ryZXytKkdOF11Bvi+y6C7ce6Xm6V993JytOYArr5aFvGBbda3LqpnI2YlcVb?=
 =?us-ascii?Q?SFSGU7x2YRl8rmM36Mqs1Cl9QC52Zt/PE4ichyXoUq3mcPBeDVVFCmzCK2Lg?=
 =?us-ascii?Q?KiSFBZrn0deYskzgTU4X+i16MWIquByQs5M9aWAzzdFI6JEm/w6JGB6Bi9SO?=
 =?us-ascii?Q?bs0UTMq43WU7ypuRD/CR0fFbOGg31S7VmBUZScYwtlN4wLSKzxo9UWta6aMT?=
 =?us-ascii?Q?DSsotQmv6Y8rvKAqgDmGNuB7Rso32U936nctWcOiLK4J8e/EHEoGJIX5AFCW?=
 =?us-ascii?Q?oi1gDqA2HLGivN8ARYzJVsNEjpQB2V5A8VtK6SxJLlVPRgkuU9Vekpdrb9p2?=
 =?us-ascii?Q?HlO2bOeasIFihnOgiHC6Yr7M5O8NBFDe0LVsPXWT?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 35d65baa-9e13-450d-3b8f-08db3c2dd7e3
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2023 14:46:19.7766
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uMysEmbYXft9Nmky4kka+Tn2IuGU1OoTQqlzwgFEB7GKpubH4Kq2LTP/pilbiDJZ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4210
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 13, 2023 at 03:49:29PM +0300, Leon Romanovsky wrote:

> > that it fixes a setup with VF and VM, so I think thats an ok thing to
> > call out as the goal.
> 
> VF or VM came from user perspective of where this behavior is not
> correct. Avihai saw this in QEMU, so he described it in terms which
> are more clear to the end user.

Except it is not clear, the VF/VM issue is more properly solved by
showing the real relaxed order cap to the VM.

This series really is about fixing the FW mistake that had a dynamic
cap bit for relaxed ordering. The driver does not support cap bits
that change during runtime.

mlx5 racily bodged around the broken cap by by protecting the feature
with the same test the FW was using to make the cap dynamic, but this
is all just wrong.

The new cap bit is static, doesn't change like a cap bit should, and
so we don't need the bodge anymore.

That the bodge didn't work in VMs because of a qmeu/vfio issue is
another bad side effect, but it isn't really the point of this series.

This is why I'd like it if the code was more closely organized to make
it clear that the old cap is OLD and that the bodge that goes along
with it is part of making the cap bit work. It kind of gets lost in
the way things are organized what is old/new.

Jason

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42148581627
	for <lists+netdev@lfdr.de>; Tue, 26 Jul 2022 17:12:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231845AbiGZPMj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jul 2022 11:12:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229976AbiGZPMg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jul 2022 11:12:36 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2084.outbound.protection.outlook.com [40.107.237.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C767292;
        Tue, 26 Jul 2022 08:12:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TIU7AZzGshuk84PlxYsVgooCu4kW3OpMKCKTtVRAb9OnH2yBk9+shfP9HbxVSTlbblAbTH2hjuJSK9VkogEPMnmG8yNRzk7bcmRhvcat3Bl1Oprkd4OLAxiUlZQl7svS+I03k7jQ57jIliiITJJcHQOdGyD7595D6jMBC3obtj+9CiNYR/Kp+OUqC/t2t6f5smdoC3bw6jTAhm17wXoblkNopZX8wAlzBFoa9sPqYzbVyNVnEHtOAM7kwdiWsX5RwaOl4M0lfrD0vw/rPmo1/Gm83kwP4iq9iqC1pf0UsYKOX3RrkWVhOXxp9nfJMjOCudHn/IPslZQX7E5cYPGoOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NduJvfwsztRDPNoFWjTzeLLyuLssfUHIBFjE6OjCOJ8=;
 b=AdFPbcz9QmkaN+R+YR/T3Lyt+Qb5xmyuuf1b547Bp0pnUrKde0KMFf9R6rwg2fs7YDCdczgcpkhEDYMyPtJgxE8WVP9VgqV2zAT4nuvheKHoOrR4OBY577aKi8lZ+KKChwrKJwE9E+6ImeBYFKdeA0g+jpJhMr01wEZJG0QLaMkUu6b08K2VQ0+N5YkgdpeHLx5SCdXDsG3HOqvy/t9r/lzVB75XIYgUBWIKqnWRmVpfstX2O13VdOI/JVTFRLlL3Rcjr3BoI/PwFTc7dNJpecb5i2rxNYSIsBoYGjuABQO6tNKETZ6IGJbNsZZRrhuf/Ud/rQ+KBf378wjUvoFZ3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NduJvfwsztRDPNoFWjTzeLLyuLssfUHIBFjE6OjCOJ8=;
 b=ds+upC+pmn/yv0TAWNirp4SbzV32z1XMjlFimht0x6pY9KT4XD5cMuySgI6MmEYYGDv+1pdzfl0Gh8tewsIs7TrdKcJeAIlftVmIRETAImZ0fIZPwhgdqyq/Z57vKjScZTMvjE4DMgHxhp1Ikmm/s0IxzdJNwtSO/WYRUh5tvtHJc0xdZc7AmJMCIa7IsTjAkptxusvyia3yXsiojSUpRJeX3ImOcWlIPEnJ0+7eu6C0TdreFuKHD5UspVSxi2oLI0T+96UXYJHbcbL/zFnyg4P55FTHKSZLwBsp0P1w6k+o/UcWg68AhkSIYXjmbAKHwwTLHKTnDYmX5OC9JlJuqw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by MN2PR12MB3408.namprd12.prod.outlook.com (2603:10b6:208:cd::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.19; Tue, 26 Jul
 2022 15:12:33 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ac35:7c4b:3282:abfb]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ac35:7c4b:3282:abfb%3]) with mapi id 15.20.5458.025; Tue, 26 Jul 2022
 15:12:33 +0000
Date:   Tue, 26 Jul 2022 12:12:32 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        "saeedm@nvidia.com" <saeedm@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "Martins, Joao" <joao.m.martins@oracle.com>,
        "leonro@nvidia.com" <leonro@nvidia.com>,
        "maorg@nvidia.com" <maorg@nvidia.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>
Subject: Re: [PATCH V2 vfio 06/11] vfio: Introduce the DMA logging feature
 support
Message-ID: <20220726151232.GF4438@nvidia.com>
References: <20220714081251.240584-7-yishaih@nvidia.com>
 <20220718163024.143ec05a.alex.williamson@redhat.com>
 <8242cd07-0b65-e2b8-3797-3fe5623ec65d@nvidia.com>
 <20220719132514.7d21dfaf.alex.williamson@redhat.com>
 <20220719200825.GK4609@nvidia.com>
 <BN9PR11MB527610E578F01DC631F626A88C919@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20220721115038.GX4609@nvidia.com>
 <BN9PR11MB5276924990601C5770C633198C959@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20220725143706.GD3747@nvidia.com>
 <BN9PR11MB52765A281BFF7C87523643BB8C949@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB52765A281BFF7C87523643BB8C949@BN9PR11MB5276.namprd11.prod.outlook.com>
X-ClientProxiedBy: BL1PR13CA0239.namprd13.prod.outlook.com
 (2603:10b6:208:2bf::34) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 50ef5b71-5cb8-461f-e585-08da6f194407
X-MS-TrafficTypeDiagnostic: MN2PR12MB3408:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: o2A20YYj+512+RkVrOyurxQ9v0UgVd1ZpAXIKwvZEJomV6T+WrssBvl3M1G6+1SyHQT1x+aJW2MXT0HZSIuXBk9vdWtuub6fxZXlBlNq/9HjNd6B8r/IhHrZCGQV6c6O6wV8JKn6TvC/STrP1BokR8TyJRvDrNmG5llstz02shzTbo9Qd9HFH43smRPAEWDoMabu6ISpqEzPGkYhRzPrijOiF43iykjoW7jPJxQFlutPkQp0ANpxU3TRyoFl/rmo90uwLAb428Ry/Z5l80QbScjCJs4Kt3bqmkcZeSBGGBLq5XGut0h2rZSbQBFSULM4iKHeoDG5Mph8E474ce1K+jPDXhzAlkayWsigPgz94BOr4Dx+LgM1rG0ofolOxSYtHMy1yICH8zcxu0MxeXZzcS8FD2NCbUzDUXKJxDJyJEi41uHzdw7qC0XTsedgG7UReAN/JUWBtvfV2IFXey+2e7CLT4HPhtayjxucxQOtKHl3/g7eK6hDzH01WVSAk9gChQg2jy+ei3uyD80hJYiB58E1nGmjRxYU0P+md0jN/Bo+7FHXVDi1N1Fnbx+3X7OmkrBen1eb736H12Hv9+lNvbkFbXDpacafaqRQ/5iiNu+0CmyjdCL4bqRr4oN2sfoKfs3u8JDfaFoKHaSwIBW6fxQdwV2IsnTW1Rv3v0Jt1qx6N3UthfYYzsvq4ADRqqQI4tZMsOU/DoxK1dCFob66wILHfhO1vMAQ6NSY/FjNeGyDnmWJU0YKppukmFuLWPlZ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(346002)(136003)(396003)(376002)(366004)(186003)(1076003)(2616005)(83380400001)(8676002)(4326008)(54906003)(66946007)(66476007)(66556008)(36756003)(6512007)(6506007)(41300700001)(2906002)(26005)(33656002)(86362001)(5660300002)(38100700002)(6862004)(316002)(6486002)(478600001)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Og+q95jTWjHCXw1+86GAYFzwQ6yVIO9VvRZQKLI/nmxKFdqVas53N7ebMfcv?=
 =?us-ascii?Q?QdM+tTCUp3igSgUiN+oq9tOBH3hiMzSv4Qtx8/AKEJp2zkgIP4vPzpw8zWzz?=
 =?us-ascii?Q?8Y/gIcdTfybetZM4WnYWnq8mdpt/sOyMvwtgH8t/EfoIMGPpVAewRppiJkxc?=
 =?us-ascii?Q?+FUTDXTIE6vovJBIN0aMQI7BuxsQX+p2pz/hSMpO2N5SlCjtREiCAybu4iFu?=
 =?us-ascii?Q?lE7A+MRbFb+qidC9rc+LuI1RTJk34TYudm7W+QI3A1JGs6wrKSjIf3KL+Zus?=
 =?us-ascii?Q?NhBuXLt8katJW3ujAE5Lc7efM/0bOEJdF8BPzNivtgjUNcfJD7wCZ3/F0Q0x?=
 =?us-ascii?Q?6U05KT9SOIDivbwmKCZHfYshDnwlq//xR0aFBJQmBz6WBC+ujXpZxr2e/8tV?=
 =?us-ascii?Q?nSp4UlgWoBdutocgDCyZDEn6h4LW2azzWJWgoSQGxh2EIwfh9bAj4IjdKH2K?=
 =?us-ascii?Q?iTAxQXDB34/9Y/6nQdDvFI0Vn25HueDLcdcwRftTEdAM/+mbL3FZcTbKqsW/?=
 =?us-ascii?Q?Ij5Aci7vT4uBDpjzElyef2hbskFWviF1vBP3BschPpuvKIaawmqXnj6fbYJ5?=
 =?us-ascii?Q?Kc8MkfmAQyp6GwvChhsiGcOxWyXLm0EBtBWDFxOO017MW8fl/4OaZEpIvvRY?=
 =?us-ascii?Q?5VwS31YhVlxdB6/u0EGuzO1C2yHv404kgd3+/vpVUl0Ep4WCitd6ij6bN6R0?=
 =?us-ascii?Q?QrQrsd/TKbuRYcLqGXajjRR3nhGhLsi4tZMYOc9/0ZMcUSajMcJxuje9lMuJ?=
 =?us-ascii?Q?TIeJp5AOBGjLAr0U5ZQPvLEn8+qwvryMbqHUMPXDCDGsr8h5Na3Xkv5dnBIY?=
 =?us-ascii?Q?SB8naZ7HIckm/M/as3wo+B9wddLKzeD35lmoGlhzsZv8xCDGq746Lec0aI5Q?=
 =?us-ascii?Q?xfkBbnXy+dUWaB4VXVy/k7qf6lDsbeJk7fwf8F0gI6ZCCu9C7fgzpOGWvaqH?=
 =?us-ascii?Q?lfJvU8BH6Oo0xYRdHWIL4ZTZqWSUoJJ/qJy/5pSdx50GjVUhq15bSTDZeUEp?=
 =?us-ascii?Q?7vb5h9Fg3YNw+sl4gQ8RUdd1ikQbMAxQSW5TrMJoBweMAyEd9cFLFeB40NCd?=
 =?us-ascii?Q?jP+hu8NTg3s0jFXQZAWhHPlYP/OEYEYWidKblTgA41Fhm40fYtcdxYAbuKFz?=
 =?us-ascii?Q?v2t4Kk5WkJZVKc2dUBQBIvo2wfCoIN+vCQKvCBvWBhcR8DgjYH8pS6Aj8M9C?=
 =?us-ascii?Q?GZTlmzPqVokOUVm1zvaxbrlRIdhadL2ZHgHJRepRmX+Pk6FF0FnFMLJhCkhS?=
 =?us-ascii?Q?us79Ngk6UR3ix6a2psP/Xc/L3SXkTAqExoeHzYCWeUwcTeuelYqba3QjiuB6?=
 =?us-ascii?Q?7vkQP2rze9llG8riXdC7yvNku/lsqzAUW3C2NGwNQKVne/FzH+5zQ3GNx3tf?=
 =?us-ascii?Q?pDP6q0LOHElA/VlN73WFSBQ5TSFa2IonFoZUOgEjEZIyjRIE39Z1lwQFYbp6?=
 =?us-ascii?Q?fdxp1TuW2ZwiAWjEKGKvYUVqEdPFcIEOntDbpmzeFl/C6uZRGkMiYPr2/32+?=
 =?us-ascii?Q?V+H1kYibhT5sER7o2QCdr1zNud7lMIhu/64l3hPcAIgYGosrrVKwExZnFxpn?=
 =?us-ascii?Q?utaSMZ9Gzi+47m8p/36qLugv7om45fyRXdX/87S2?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 50ef5b71-5cb8-461f-e585-08da6f194407
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jul 2022 15:12:33.4298
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WXDY+gpZTN3r1drNlzhPZ1Vw5vdrKlO1PdL+k/w97mKsdybq2tCmuRSuZgSEOPEi
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3408
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 26, 2022 at 07:34:55AM +0000, Tian, Kevin wrote:
> > From: Jason Gunthorpe <jgg@nvidia.com>
> > Sent: Monday, July 25, 2022 10:37 PM
> > 
> > On Mon, Jul 25, 2022 at 07:38:52AM +0000, Tian, Kevin wrote:
> > 
> > > > Yes. qemu has to select a static aperture at start.
> > > >
> > > >  The entire aperture is best, if that fails
> > > >
> > > >  A smaller aperture and hope the guest doesn't use the whole space, if
> > > >  that fails,
> > > >
> > > >  The entire guest physical map and hope the guest is in PT mode
> > >
> > > That sounds a bit hacky... does it instead suggest that an interface
> > > for reporting the supported ranges on a tracker could be helpful once
> > > trying the entire aperture fails?
> > 
> > It is the "try and fail" approach. It gives the driver the most
> > flexability in processing the ranges to try and make them work. If we
> > attempt to describe all the device constraints that might exist we
> > will be here forever.
> 
> Usually the caller of a 'try and fail' interface knows exactly what to
> be tried and then call the interface to see whether the callee can
> meet its requirement.

Which is exactly this case.

qemu has one thing to try that meets its full requirement - the entire
vIOMMU aperture.

The other two are possible options based on assumptions of how the
guest VM is operating that might work - but this guessing is entirely
between qemu and the VM, not something the kernel can help with.

So, from the kernel perspective qemu will try three things in order of
preference and the first to work will be the right one. Making the
kernel API more complicated is not going to help qemu guess what the
guest is doing any better.

In any case this is vIOMMU mode so if the VM establishes mappings
outside the tracked IOVA then qemu is aware of it and qemu can
perma-dirty those pages as part of its migration logic. It is not
broken, it just might not meet the SLA.

> But I can see why a reporting mechanism doesn't fit well with
> your example below. In the worst case probably the user has to
> decide between using vIOMMU vs. vfio DMA logging if a simple
> policy of using the entire aperture doesn't work...

Well, yes, this is exactly the situation unfortunately. Without
special HW support vIOMMU is not going to work perfectly, but there
are reasonably use cases where vIOMMU is on but the guest is in PT
mode that could work, or where the IOVA aperture is limited, or
so on..

Jason

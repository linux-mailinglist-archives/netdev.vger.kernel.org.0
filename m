Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 167FD4C05DF
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 01:21:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233996AbiBWAWH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 19:22:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231765AbiBWAWG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 19:22:06 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2069.outbound.protection.outlook.com [40.107.244.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 309BC4EA0C;
        Tue, 22 Feb 2022 16:21:39 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Iugr5Agfgq0WcTMM2mktFaZhzvT7xY2sJyCMEILP1aWp/sukSXI/eCxkofNjDZGb4KcNzpZPgJ5EUJWH4jZ2HC46saKZ3jUWauAYFgNZzoe9mx4Pl7cRIqCdnCROYq3zHAa+rWGnqFzWKPnEr9mXXSIzndzXAr6CjoaXHrsCbZyJmkNRLpWFgq5PUyyyJuraKpuDZ5oyVoskqu2dJ9HWOPooTwoAkd9rlphwFdQPWkMGlxBsNcy5xNAYyYN00Bi4NIGarfoXNzUdFRgCKem+pgOBHr5A5LBVzwYXBDfRb3RY5UbQOMw0By7Se+npoXcZ682/XuYDE1tfZMp7CTmCkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=v5XS8tmbTqGrqSCRzib8D6YUwWxh3E4+h2DTzQekVE8=;
 b=FN5gACyDAMnLgWpGfD1TuP9bTcWWzn7rrejkFji6Drqn0bFTumzCyo0yphhDCzS/d4hBHVd+JD40xbetrfCxl6pPHMMPJ0dqYhLePH+fUwsM85bSkAB7rPzhto3gXRn3rvQwOsQYFNUVz0Fz2xZXlWXWRuNeD5O0hpCItn0NLcbD/2oCfPUTB6ICBHLQKgyxHfvgKIleG29ZaN1A376lj+rtOFZLhivJa0PKmV0OmbqQT1+LBp4YNDez4uLz69YqAraKsfVZKge0EuD3vulEmOAgjYsTCZKD6b+gQH2TzEy8NcIyY/MwxgyoHH+JWUdx2md8GIAY8rXhaP8r3YFSTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v5XS8tmbTqGrqSCRzib8D6YUwWxh3E4+h2DTzQekVE8=;
 b=Ko9KI5yOsNDguu8PEfCuGzEU3p1VxtSeQEjfp4uK+AHobHeTwRJm7r1dOvRSPX90eko6k09tSAluKraIBurpfZ/aMfm3XZt+tep9Io6gG6eNdzq9yTsalWaidhqxS2QjOEtvGM88o2a9QET7W+J1X3fWMMFLgmXsP2bYzvVNXtPsErQjGnZSqYkhsMZ/pl110NVPjK2XgsqhAH3w79znF0jst1m6Mwi/tbiOEjCCq/eHLsMaHn5X6QsyaQRZfktXO+FqclZxQuD/CRnpdifBJXkKTBIf2cPQSIfe/H5Ibu1XBs6v1K8VSkNqKOK3tgp/v+irJPOa/CHq0UQr4UVx6A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by DM6PR12MB5552.namprd12.prod.outlook.com (2603:10b6:5:1bd::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.21; Wed, 23 Feb
 2022 00:21:37 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::e8f4:9793:da37:1bd3]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::e8f4:9793:da37:1bd3%4]) with mapi id 15.20.5017.022; Wed, 23 Feb 2022
 00:21:37 +0000
Date:   Tue, 22 Feb 2022 20:21:36 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Yishai Hadas <yishaih@nvidia.com>, bhelgaas@google.com,
        saeedm@nvidia.com, linux-pci@vger.kernel.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, kuba@kernel.org, leonro@nvidia.com,
        kwankhede@nvidia.com, mgurtovoy@nvidia.com, maorg@nvidia.com,
        cohuck@redhat.com, ashok.raj@intel.com, kevin.tian@intel.com,
        shameerali.kolothum.thodi@huawei.com
Subject: Re: [PATCH V8 mlx5-next 09/15] vfio: Define device migration
 protocol v2
Message-ID: <20220223002136.GG10061@nvidia.com>
References: <20220220095716.153757-1-yishaih@nvidia.com>
 <20220220095716.153757-10-yishaih@nvidia.com>
 <20220222165300.4a8dd044.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220222165300.4a8dd044.alex.williamson@redhat.com>
X-ClientProxiedBy: BL1PR13CA0356.namprd13.prod.outlook.com
 (2603:10b6:208:2c6::31) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5f3fab47-49aa-49f6-fe79-08d9f66274bd
X-MS-TrafficTypeDiagnostic: DM6PR12MB5552:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB55524074D700D03C4D1B80BBC23C9@DM6PR12MB5552.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: o3wn0KtNrPN+Ckg8ma50p7ie3flpG3i7TJ2IQx+rLL4eOVV0QjK77ZyFfxfsD596gV8zS4ZFk5YPh7lgV5zz6ASCf6pXdhm61DO6AohBjxqzNGFrs/jsJHd4AKflTvtUMpVyjKHL1v/Wf4TDxK7HSlIMq23YivuHx31kb/0tQT7obLQuPIzmKBlE/KqqInfuqZuV/5MH/1MpqPXetv9jWJ3HQmRw3UTsOsUEitdTZjUQuFbWlKJti4DKR0XoG9H51Uf03MB/ORVB0ZCsSwJelVaWZXAQrLTw53nr9YY5PE+BYu5/HKZi7u4agxQBTfBQfnowx82usB+kl4tigkRP6H4P8+fu7csu8z983ZpuFvZOmRHpzl4Gm4sF2qE1L8L38gHQnCjRXHWt7iE4NOkOlzBQ5OM6t/Xn4/RPt1ZsXaIBvlW0XQQmhdTa95AP177RVdhB4HBPju77RScMiQ+HIazFkUvn+l2/5MQ+g7N7QzVA6Q7qttUbO0R97Apk4vyOJ0Rx0ATAf6uPJWNzbnThd8VK9eUHgyyosb9bcY1DHoGG+Kvp2easiT37dhETG2teCj+PN3vv5dRHuz5E7OzdEwOtglRZoj3QqW2b9fT988ratSOZ1nhHlpnxSgshIf/ucSz6h5o5eucIf5Huea9HbgmHkkdsvaK9bpu8iotOgarMus6tK63LxOcYZdldzxdBYefxZfgczgP01DeBBxM2jgZrTGshq5OFyZH7x3BcUTE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(38100700002)(6486002)(966005)(508600001)(5660300002)(36756003)(86362001)(7416002)(8936002)(316002)(6916009)(8676002)(66476007)(66556008)(4326008)(66946007)(33656002)(2616005)(1076003)(83380400001)(186003)(6512007)(6506007)(2906002)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?59Q40OCyK5OiCQ7Kw8po08EJtHtB5z7A7qvUXg8IYnY1t5QSUii9H2NdyGbg?=
 =?us-ascii?Q?DcfyQrjMmyG5gBsP3GohxAAplJzNtZUCNEfoZKOpKq1eNi6U+okLq4oEAPuW?=
 =?us-ascii?Q?y6SJVnJ9mQV7nrbyUQM4Cb10BlEY6C4rzMjeG498pa2GHS18NHokCtbmcOn3?=
 =?us-ascii?Q?JtZNOPESQGY3oeKzZPzl5E8Gu6ajmwI/39dI5kCg/YRCt5Soeuaymarfixid?=
 =?us-ascii?Q?VhiINh+8XuevSSe0qraX1SCA8zuasCDfOCXjYvyDyZmjNAvz7csZdJp4yw55?=
 =?us-ascii?Q?65cQdadUax3L8vY5uETadFfb0xPxj1dcy7rFPSKe0rvjVrUWSbekA+cBz5bv?=
 =?us-ascii?Q?g7ijz+M2S95CjMvoJEk9r7KS79Y/Rpn2CXr2ypdBD8yeUBEBF8ZlE3+lUzEe?=
 =?us-ascii?Q?/3AIPi97kRpnjHY+CGCHmwDxRuztfJnxvdCyKTAJfFsooMNgcMg49T1ZFWxn?=
 =?us-ascii?Q?X3CMC6x81+8Yp+re4VZj5mWqzLko1PIJ4gZsCCtDA4mPGnd+Ffawd+fsMavw?=
 =?us-ascii?Q?wAGA8Qa7dpMDiStmG8vV+oR8ueCDyvJXnOeG07U+UQYbc5YX0HYMuk+LVpdD?=
 =?us-ascii?Q?1QWkQIvBbLvtrxu5aR9YVYTajcOH0u2+SqTyemfdHtcGowkP9zJeknK2c0Lf?=
 =?us-ascii?Q?d5HTVbtXtzAuqPhG4nm3CN5YXusr5pjIZMSk2/h5SD387uvCKKOOUMEG/sfV?=
 =?us-ascii?Q?rXCpqaA6gizxxywzQF4OMasJGSBTwJaV0h6pYH1kcYS7KFnMCZTvCekDZbX9?=
 =?us-ascii?Q?9LowxIP+m1KycqVYbLi9Hf37CGr1urcKCSobvAN66dTt3ocBAOGv0lVc2Osi?=
 =?us-ascii?Q?xfjhQwhoSSyimB78RqdK1PnHDg6tFK6eQGcGPedbTkSdVBqX5pibe52w2+rj?=
 =?us-ascii?Q?3TlRi6wihyJPtdtgStgeFKbOJ2HmgGxhGvL6aK6e/9+OfALvxEAusD9mHqXZ?=
 =?us-ascii?Q?pR32UjJof+Z60y9bkrGXwaMLvmQUS6Y6lU2WWR2ss0T67BmC55Vz2/Gb0PEP?=
 =?us-ascii?Q?j+at8GqQ8K+Xe/jYHvbeQzyFv0ny55AuFnYTq+4QfGSwS90vagHFeMglGmED?=
 =?us-ascii?Q?EW0ZUrjWb6Zgsm7NaLt7jV79U/FNuWTyjqewTFENfF6GfVwECPEgY3vgrAXY?=
 =?us-ascii?Q?lD+8vmiANuTXkCG9pBJz0hk5y0RnRC8TL8etKTLux0+DXcVduYxnMQIb5/jo?=
 =?us-ascii?Q?9CtwxEje8Q/R6DRu8lk3ynTb7Nx7JPk/BQYHaUFEEKkQUQmbf5z3QTnWphX3?=
 =?us-ascii?Q?f4RHS3fX2qjdb+6p3DDp4Xi8mGT1hUNnqMSP+m1SPMhS3tCuTHvdy4YShgyh?=
 =?us-ascii?Q?sRL9hnUpXdrusbbnZ0jT0gAczCBmrNM1M8nJlXu3YDR6iKo37VhCqBzAaLuJ?=
 =?us-ascii?Q?PR09aKFxn85eGX1KAMspcrMun3WFqv5fPiPnks4+3epbwuW24jdz/y1bsDec?=
 =?us-ascii?Q?aPPA5LQzpsQvbPcCLvpYLeHLDENjeFn/6mVOo0JVqJRZNOTiThxNTWjwHGxh?=
 =?us-ascii?Q?yPTueTNzh0vQ5nHuyTYUg4KKCoGR5EyLVw25hqa2JTbkMm5g9twWszX+X1X8?=
 =?us-ascii?Q?YHDM1R+eUtX5OgVAwCA=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f3fab47-49aa-49f6-fe79-08d9f66274bd
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Feb 2022 00:21:37.7034
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: G5Z9kyHo/L/1OV105mcNl2chbQroEj1djLP9KJgsvF1xIc1MmjdPwlGybg9aaFB+
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB5552
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 22, 2022 at 04:53:00PM -0700, Alex Williamson wrote:
> On Sun, 20 Feb 2022 11:57:10 +0200
> Yishai Hadas <yishaih@nvidia.com> wrote:
> 
> > From: Jason Gunthorpe <jgg@nvidia.com>
> > 
> > Replace the existing region based migration protocol with an ioctl based
> > protocol. The two protocols have the same general semantic behaviors, but
> > the way the data is transported is changed.
> > 
> > This is the STOP_COPY portion of the new protocol, it defines the 5 states
> > for basic stop and copy migration and the protocol to move the migration
> > data in/out of the kernel.
> > 
> > Compared to the clarification of the v1 protocol Alex proposed:
> > 
> > https://lore.kernel.org/r/163909282574.728533.7460416142511440919.stgit@omen
> > 
> > This has a few deliberate functional differences:
> > 
> >  - ERROR arcs allow the device function to remain unchanged.
> > 
> >  - The protocol is not required to return to the original state on
> >    transition failure. Instead userspace can execute an unwind back to
> >    the original state, reset, or do something else without needing kernel
> >    support. This simplifies the kernel design and should userspace choose
> >    a policy like always reset, avoids doing useless work in the kernel
> >    on error handling paths.
> > 
> >  - PRE_COPY is made optional, userspace must discover it before using it.
> >    This reflects the fact that the majority of drivers we are aware of
> >    right now will not implement PRE_COPY.
> > 
> >  - segmentation is not part of the data stream protocol, the receiver
> >    does not have to reproduce the framing boundaries.
> 
> I'm not sure how to reconcile the statement above with:
> 
> 	"The user must consider the migration data segments carried
> 	 over the FD to be opaque and non-fungible. During RESUMING, the
> 	 data segments must be written in the same order they came out
> 	 of the saving side FD."
> 
> This is subtly conflicting that it's not segmented, but segments must
> be written in order.  We'll naturally have some segmentation due to
> buffering in kernel and userspace, but I think referring to it as a
> stream suggests that the user can cut and join segments arbitrarily so
> long as byte order is preserved, right?  

Yes, it is just some odd language that carried over from the v1 language

> I suspect the commit log comment is referring to the driver imposed
> segmentation and framing relative to region offsets.

v1 had some special behavior where qemu would carry each data_size as
a single unit to the other side present it whole to the migration
region. We couldn't find any use case for this, and it wasn't clear if
this was deliberate or just a quirk of qemu's implementation.

We tossed it because doing an extra ioctl or something to learn this
framing would hurt a zero-copy async iouring data mover scheme.

> Maybe something like:
> 
> 	"The user must consider the migration data stream carried over
> 	 the FD to be opaque and must preserve the byte order of the
> 	 stream.  The user is not required to preserve buffer
> 	 segmentation when writing the data stream during the RESUMING
> 	 operation."

Yes

> > + * The kernel migration driver must fully transition the device to the new state
> > + * value before the operation returns to the user.
> 
> The above statement certainly doesn't preclude asynchronous
> availability of data on the stream FD, but it does demand that the
> device state transition itself is synchronous and can cannot be
> shortcut.  If the state transition itself exceeds migration SLAs, we're
> in a pickle.  Thanks,

Even if the commands were async, it is not easy to believe a device
can instantaneously abort an arc when a timer hits and return to full
operation. For instance, mlx5 can't do this.

The vCPU cannot be restarted to try to meet the SLA until a command
going back to RUNNING returns.

If we want to have a SLA feature it feels better to pass in the
deadline time as part of the set state ioctl and the driver can then
internally do something appropriate and not have to figure out how to
juggle an external abort. The driver would be expected to return fully
completed from STOP or return back to RUNNING before the deadline.

For instance mlx5 could possibly implement this by checking the
migration size and doing some maths before deciding if it should
commit to its unabortable device command.

I have a feeling supporting SLA means devices are going to have to
report latencies for various arcs and work in a more classical
realtime deadline oriented way overall. Estimating the transfer
latency and size is another factor too.

Overall, this SLA topic looks quite big to me, and I think a full
solution will come with many facets. We are also quite interested in
dirty rate limiting, for instance.

Thanks,
Jason

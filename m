Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B0704B7C81
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 02:37:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245385AbiBPBRQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 20:17:16 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:40976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245368AbiBPBRP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 20:17:15 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2062.outbound.protection.outlook.com [40.107.220.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6993EF65EF;
        Tue, 15 Feb 2022 17:17:04 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OmmJvZKEo88vPuHc2Y0oBBxGh/uwzr5ooaeZFlKDhn0pCvMCDNlpT1TaYidelp36yJoi0CAQUPtqCuEf0JZxEWA5sEw68jBgN4WteuM0w+1wlb7IixVzbCLjwHYRj0HEB0JywtSCo9eQbwjAXzjyf73UjB7KxhZQYB/JICnFKyM/e15qMIroNvDdP0rvL7iWnlqwwJUqc2X/dVRSU0G7nHMG6ak6Q4k2qN2qET0eCf2E5PKBjOFdJVfoKuDZo5QxKZzf4XUi6sFJLF8hUGxML96ogjjSjdiXnGmiSDHOUt8gwzTTlZTp3t3xVufkYcgT8jLx5YUTArRz2NPxw2YjGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jChVXXrRcVZr9d19WM3LA4lq5xX8LdwLi6lptGpuTyw=;
 b=gWOhOHJXahtI5j7byU01wBJGXLUz5tdLuT6oqtupo3ULfYMldWLo/Em3gvHtFTsaemWv9xDEtpz29AS3lLC1CRLRJtZ0IbAcRqLtofiMK0zDXteTl5YtJshFpTD1Feea/xpZBEGPHxiXKXqwziCneMlFXOL5Vp5+5xs/tq/vHGJ+Wy6Fqe1ucF5ET+Q84Iz66DHYl6+Omnmh0w6KhGvuBTa9KUBqwecVOnsbJ/kD8GhlBaW7vYVUaQlsqZtzauE51zBPtNF6Rr4Ydc8xq+jlob22LDbabr1iv+1vsbZ9ed2B8rPzhi/exGXLRhAeJJGhc29M/GNVvvN6E3cf5+6pIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jChVXXrRcVZr9d19WM3LA4lq5xX8LdwLi6lptGpuTyw=;
 b=AG5xxdXoqsFRhM40BTS0lwUrk7dXH2V4taA+dCtUXmv5bzLuJ5mvOTe6p9pokSqodd6wi5bQh5nDh3avymxyxYBrg+xLcmhj4jC2q15cXH1Xmur6Q0bWgqjN+qXFJ/xoel2wCHK3/m5UAqGwyPVPtbwD5I3JmF9vGn5j84Bv9PNfdPCwWq8U9Hz+KCHbw7q7+rF3efmXxMCw8HssjelN51JvWuZ17/4bHmeC12WHMVEPSNqj1a66NHGPba/c0CRxN6Z56Izy1Wk9H051qAUMmcWJeGKK1dhkvI408Zxu2UetZ7mUlbxky/UShonXiwDEt1DftEvSfJtk7GRsrePeag==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by DM5PR12MB1388.namprd12.prod.outlook.com (2603:10b6:3:78::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4975.15; Wed, 16 Feb 2022 01:17:02 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::e8f4:9793:da37:1bd3]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::e8f4:9793:da37:1bd3%5]) with mapi id 15.20.4995.016; Wed, 16 Feb 2022
 01:17:02 +0000
Date:   Tue, 15 Feb 2022 21:17:00 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "saeedm@nvidia.com" <saeedm@nvidia.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "leonro@nvidia.com" <leonro@nvidia.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "mgurtovoy@nvidia.com" <mgurtovoy@nvidia.com>,
        "maorg@nvidia.com" <maorg@nvidia.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>
Subject: Re: [PATCH V7 mlx5-next 08/15] vfio: Define device migration
 protocol v2
Message-ID: <20220216011700.GB4160@nvidia.com>
References: <20220207172216.206415-1-yishaih@nvidia.com>
 <20220207172216.206415-9-yishaih@nvidia.com>
 <20220208170754.01d05a1d.alex.williamson@redhat.com>
 <20220209023645.GN4160@nvidia.com>
 <BN9PR11MB5276BD03F292902A803FA0E58C349@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20220215160419.GC1046125@nvidia.com>
 <20220215163231.57f0ebb6.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220215163231.57f0ebb6.alex.williamson@redhat.com>
X-ClientProxiedBy: BL1PR13CA0437.namprd13.prod.outlook.com
 (2603:10b6:208:2c3::22) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a08a54bc-018e-49fb-ce3d-08d9f0ea0966
X-MS-TrafficTypeDiagnostic: DM5PR12MB1388:EE_
X-Microsoft-Antispam-PRVS: <DM5PR12MB1388B1299CD4401A0CD2D838C2359@DM5PR12MB1388.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0XSr0FOZWrIP/AdiEuwP2kWOAXT3SYqo+uX6dGOnICbXltBIKzDqf4hLwWFnuZ9FbIuko2dTN1GqYFeJxX4jsqx635WS0ANW4r3IQU56P2lO6lhGvuXE2CnhINT3SRGWd/m36dEsIm7huYKOjHoZdYbHy4IDDVgv5AvBUPeITf1IvcmxeMvmMlujzNN2oUO3VRXClTdVvi9AOSGwhR32UwQ0OodU1b0ket7F2EH5Ru0TYm8zWKeZqf+w0MI4k1a0Zcf1/OxdNH59ulTFDHeQp4SYalsHTPL9oDtnQD6N01Li0+37swvACfDMQobjvQ7SW9/XBjcbQCojb/ohMuzEkXLVrc+lVlgiJsWlyHEUJI6AIUUXEdZrP1bZCCeqK940lf3LIYnhAXwtSMayaIin1milLU1OhQqi02JSEqAxmIP6DLweltoCYl/RAZM06Exb2XvmxKIvihcLscMVf4Y0GRomTnmhy5R0Fc2x1B/W4+Q7v6n6StR9IerKdL1HJkwqnig8Psb2l3VHzleOTL4IxdunnDZ+s8FUmKvmoqaL3B37AUm9Xqdv+9bEbPo4WGtxBfOoOb9JZsWwMUaZ6F7ecnyxPXkQGZbmAXsfY5oAe6WqWrmV3jPD4nGcJG+x9+jGMzGiltxhF6OYZGllaeRbUz0sU1azIYBP2uBbDREIJTVn9K/Gjy7ttoyE45nVP/UP6XyXGcAN2tQTXvbcKWSbB9utO/FPTJRI8b6FsTFZ09k=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(66946007)(36756003)(2616005)(316002)(4326008)(38100700002)(6486002)(66476007)(966005)(6916009)(66556008)(33656002)(26005)(1076003)(186003)(86362001)(2906002)(6512007)(8676002)(54906003)(508600001)(8936002)(6506007)(83380400001)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Jsyw9RxLOFaifwdLMrEpgS6VMt7MaHBhRBVktAQktBea52MErkuc9gHHBcu7?=
 =?us-ascii?Q?iiHnTK9qxjGg9RP8CruTHtN+sWhXQYqrOjMcFC8sAhrbDQUQC2fK7fR2QeO6?=
 =?us-ascii?Q?M8/GRBOK6JfxElmHvnz1hAsZnwe7MuvqAycz9z4HE+/Dr0HqBgfAv2tVzOny?=
 =?us-ascii?Q?K30N/c2Uo0NrstdvJO1q+AxKugN9nrv7TEUZ/jIWaZhIZCw5RsYNjhuWdKIJ?=
 =?us-ascii?Q?P799mVaHrSI2EaycygWyiueZhXseoDKDClPaI06F8BzJiI3bIkCZa74BUytM?=
 =?us-ascii?Q?IW5dbxfPLOuDoESFOniOGWruuQtNM947MPZkxub6zwS9XTZnBSjHvS6MHypD?=
 =?us-ascii?Q?NCiLOCPUOETS4G2l8yI8ajSVHJp49KQ6yBDsRgderlTClq2Ba8+NBP4kOCGH?=
 =?us-ascii?Q?S7VI4MYha3WD7DWCUOdw76HUemsdlyPLOb+fQrKyOJIMfQRTWU8buCmGeKi+?=
 =?us-ascii?Q?EGApVWFOVpmyV5USwDIwrR7Sd8pjQfo7exzF/Mgl89LWCHlQ1caalzGsuX/3?=
 =?us-ascii?Q?BgNrNKsATU3O4j1oJhAn9zAXLjH4vsrjll4rQ7yvZ0uT5Twt2LjXVr5joDws?=
 =?us-ascii?Q?yHWpN3mxCpZSe1sluWPQmWImtc3knDKV/fdMVG/UcwJSVOn4YpFdPHfWwd9U?=
 =?us-ascii?Q?69UgFkj1lZQYQ2wBLGurpZHhiNWuhEOjK8jcJcQ86R4lMND5J81+/hBywdug?=
 =?us-ascii?Q?caUndLQECcd4aP9bcBAX49OloP+3xI39AjU+gG8/k1/lHIcCkKv6lXz53XkQ?=
 =?us-ascii?Q?UrSmujxChMAmXIRuw/vL5DJAZk+3Qvru315vDVSf3emsCyGAXNgbwlaa5kOd?=
 =?us-ascii?Q?CO3Iq20m941uShvhNpVEgfDPsD8MLgYlwdQw+MYiD7jA6imHAy84sc20gH4U?=
 =?us-ascii?Q?kUkSPh0K/iv7SW7+N2samJhT/dTIVa6IACAA+FjBDbGzPKenQ6n+j3i01cxB?=
 =?us-ascii?Q?95ukSG6NJvLToXt2C65t0pCD6wep9oCbzVidPTwL7iXdi3wBIokb9x8bz8D6?=
 =?us-ascii?Q?rk4SpHTgxCEWi9unsk7vgHc/FdaT+6rdP8fyxPjQ5Y8WPH0DY/Sk6kNsDAZm?=
 =?us-ascii?Q?f7NeQUFrd79QGwoP7XFnkP7HjCVpI0GntZfMIewO4J4XC5lZcaPVosj05p22?=
 =?us-ascii?Q?rWmqaJv/Nxvzs2bUb4R7BvxibqaPoPhf1jRmpkGlsbezZworhtjyxVgWmi9h?=
 =?us-ascii?Q?uoy3wcZS/NuBH+qgHSu0meXV3VHHv1M6pZzWOxv3KfZNmg00ATuTSnIHcSIc?=
 =?us-ascii?Q?b5nCZQm1vQO726RagYIiDH/cWQJsA0rg9gSHlbgdVi3zvU5Gyque8ep9c24o?=
 =?us-ascii?Q?NisabHWVmtMlq/Kugt5/jlnp47BoGMOVW3MKG01xaJqB3s5quk6KUMg3G5EB?=
 =?us-ascii?Q?dLrFgOvTPbhZuUR7ODHMoIyXrIilYc/QPP3kxoeTI4rWHfPORy6356PXxBwv?=
 =?us-ascii?Q?6dvE1/6a7tbGOCZ7Qn8aaGRXmdrTYWM5LGzXoeaqK6qHAs7UH1x9qcPdGYOV?=
 =?us-ascii?Q?8naYVFtOLmgdBdMpX01yVvwTGzwAYsG/HzfQcl5CBpUexAv5ARzUVQBoBvRM?=
 =?us-ascii?Q?2FRJIvBuDQ0Z3Njb8rc=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a08a54bc-018e-49fb-ce3d-08d9f0ea0966
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2022 01:17:02.3662
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tBB2hYJTj+N/aQrD2fJ70IyejfIHE1bYZCmUCSnOvQmbWFtkHnvyb0xIbTnGoHbv
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1388
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 15, 2022 at 04:32:31PM -0700, Alex Williamson wrote:

> > I suppose you have to do as Alex says and try to estimate how much
> > time the stop phase of migration will take and grant only the
> > remaining time from the SLA to the guest to finish its PRI flushing,
> > otherwise go back to PRE_COPY and try again later if the timer hits.
> > 
> > This suggests to me the right interface from the driver is some
> > estimate of time to enter STOP_COPY and resulting required transfer
> > size.
> > 
> > Still, I just don't see how SLAs can really be feasible with this kind
> > of HW that requires guest co-operation..
> 
> Devil's advocate, does this discussion raise any concerns whether a
> synchronous vs asynchronous arc transition ioctl is still the right
> solution here?  

v2 switched to the data_fd which allows almost everything important to
be async, assuming someone wants to implement it in qemu and a driver.

It allows RUNNING -> STOP_COPY to be made async because the driver can
return SET_STATE immediately, backround the state save and indicate
completion/progress/error via poll(readable) on the data_fd. However
the device does still have to suspend DMA synchronously.

RESUMING -> STOP can also be async. The driver will make the data_fd
not writable before the last byte using its internal knowledge of the
data framing. Once the driver allows the last byte to be delivered
qemu will immediately do SET_STATE which will be low latency.

The entire data transfer flow itself is now async event driven and can
be run in parallel across devices with an epoll or iouring type
scheme.

STOP->RUNNING should be low latency for any reasonable device design.

For the P2P extension the RUNNING -> RUNNING_P2P has stopped vCPUs,
but I think a reasonable implementation must make this low latency,
just like suspending DMA to get to STOP_COPY must be low latency.
Making it async won't make it faster, though I would like to see it
run in parallel for all P2P devices.

The other arcs have the vCPU running, so don't matter to this.

In essence, compared to v1, we already made it almost fully async.

Also, at least with the mlx5 design, we can run all the commands async
(though there is a blocker preventing this right now) however we
cannot abort commands in progress. So as far as a SLA is concerned I
don't think async necessarily helps much.

I also think acc and several other drivers we are looking at would not
implement, or gain any advantage from async arcs.

Are there more arcs that benefit from async? PRI draining has come
up.

Keep in mind, qemu can still userspace thread SET_STATE. There has
also been talk about a generic iouring based kernel threaded
ioctl: https://lwn.net/Articles/844875/

What I suggested to Kevin is also something to look at, userspace
provides an event FD to SET_STATE and the event FD is triggered when
the background action is done.

So, I'm not worried about this. There are more than enough options to
address any async requirements down the road.

> and processors.  The mlx5 driver already places an upper bound on
> migration data size internally.

We did that because it seemed unreasonable to allow userspace to
allocate unlimited kernel memory during resuming. Ideally we'd limit
it to the device's max capability but the device doesn't know how to
do that today.

> Maybe some of these can come as DEVICE_FEATURES as we go, but for any
> sort of cloud vendor SLA, I'm afraid we're only enabling migration of
> devices with negligible transition latencies and negligible device
> states

Even if this is true, it is not a failure! Most of the migration
drivers we foresee are of this class.

My feeling is that more complex devices would benefit from some stuff,
eg like estimating times, but I'd rather collect actual field data and
understand where things lie, and what device changes are needed,
before we design something.

> with some hand waving how to determine that either of those are
> the case without device specific knowledge in the orchestration.

I don't think the orchestration necessarily needs special
knowledge. Certainly when the cloud operator designs the VMs and sets
the SLA parameters they need to do it with understanding of what the
mix of devices are and what kind of migration performance they get out
of the entire system.

More than anything system migration performance is going to be
impacted by the network for devices like mlx5 that have a non-trivial
STOP_COPY data blob.

Basically, I think it is worth thinking about, but not worth acting on
right now.

Jason

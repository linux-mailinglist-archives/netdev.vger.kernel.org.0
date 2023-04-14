Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E27106E2C71
	for <lists+netdev@lfdr.de>; Sat, 15 Apr 2023 00:27:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229815AbjDNW1K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Apr 2023 18:27:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbjDNW1J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Apr 2023 18:27:09 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2089.outbound.protection.outlook.com [40.107.243.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FB23BB
        for <netdev@vger.kernel.org>; Fri, 14 Apr 2023 15:27:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I6RSviaqRLxIKhrAviStZ34Pjk601l7hsI0oQyejzigIj1qNGGH9EacR1NHphASMvn1KDqb7oHza7f88gJaymSx4wIuZTGzhpbq4fXSXU0vXxK6BHWVtxbTRi+n8nJpmiRTi/WR2MAcM0i13x1ERi6HrxYyYPIpykQ01vg9UaAr763xs8xmHb/XUkW4ymlYrF4k1jfxuULDhkRJQ31ijG72TeWsj7L0ZK7yGYBka7vRgSSWZNMdycVS8o4jmhibxyuHE62CwfNkPj3Xi7Pjx71UR/Sp83vyCSTJKPRXzWLDpjU3ijj8vUhXmIdlgSjjUAxW5As43XmyEByxaF5Lt3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zOfY1pcuwm6R3UUl3GBTbDEc0HBks8bbzvtseUPt0b4=;
 b=YOiNM7E2D+5ikXsGZRo0VgUBk9AKRHFknX29Oew87dMnHv378l+OboZL9hWPbg0qSUCL4TrbpirEhsbUtHpg00+jkpxbQtvhWpkE0mOd2adP3qktRl5DjTADDHGoxbLHdzEhmr8srk0q5f39mJubnxPGYHQjBMKvZIdSSJW5/muncTrFYmRen9HNPMuIWHFatWD7NMG4ZEfpU1OahY/ODTLaugQZWr3Pes+8PGUxjJyuhIj9E9Ej+GvJy90F3QLUYalP3UNPO3SOHA+TiNmqQAg2FOIxYzifXaSZJ9Y7nDMcXvcye474CyKBZLgQZGoPdDoBF6Ne9aIgPpRgpLeWtg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zOfY1pcuwm6R3UUl3GBTbDEc0HBks8bbzvtseUPt0b4=;
 b=d/ak8GS0VNPGpQ4nhNaIbC0al7jpOZCFGZ9/fcsGfu8jl+tiMSPfzocQYGvDpOiFKglCjqateGcyF1RKdLpIn56hCb1ueCJIL3/6gUqwPVwMu0BOV6bUJMp2VAvlqcgfkgDsQULYVwS/A2f3mAMHNopNXDrXpNSc21wBoVmtRAwKOaZziuJ0/lu2I1pZ3e2SO6jsSf3R2+QZB3h07uydZ8si8LU1Chps+lzR0GEa+zs69Di+rq5Q2XMe9zmsrzBVBQsuY9LVCrq8Liob54iNsp7vW7PialM6MV6ssLJ++uJB4LRKk7T9VQe/h78vVbav6+0oDEmyF9gszHgJUFAxIw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM5PR12MB1340.namprd12.prod.outlook.com (2603:10b6:3:76::15) by
 DS7PR12MB5958.namprd12.prod.outlook.com (2603:10b6:8:7d::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6277.38; Fri, 14 Apr 2023 22:27:05 +0000
Received: from DM5PR12MB1340.namprd12.prod.outlook.com
 ([fe80::7634:337:4a71:2b78]) by DM5PR12MB1340.namprd12.prod.outlook.com
 ([fe80::7634:337:4a71:2b78%8]) with mapi id 15.20.6298.030; Fri, 14 Apr 2023
 22:27:04 +0000
Date:   Fri, 14 Apr 2023 15:27:02 -0700
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     Niklas Schnelle <schnelle@linux.ibm.com>
Cc:     Saeed Mahameed <saeed@kernel.org>,
        Leon Romanovsky <leon@kernel.org>,
        Gerd Bayer <gbayer@linux.ibm.com>,
        "alexander.sschmidt" <alexander.sschmidt@linux.ibm.com>,
        Alexandra Winter <wintera@linux.ibm.com>,
        netdev@vger.kernel.org, rrameshbabu@nvidia.com, gal@nvidia.com,
        moshe@nvidia.com, shayd@nvidia.com
Subject: Re: Kernel crash after FLR reset of a ConnectX-5 PF in switchdev mode
Message-ID: <ZDnTNvKUGla8Y27E@x130>
References: <90e1efad457f40c1f9f7b8cb56852072d8ea00fd.camel@linux.ibm.com>
 <20230413110228.GJ17993@unreal>
 <ZDh76MSj0hltzxwP@x130>
 <e5633e29d989ecd998ee5a9bf9ef89d987858821.camel@linux.ibm.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <e5633e29d989ecd998ee5a9bf9ef89d987858821.camel@linux.ibm.com>
X-ClientProxiedBy: BYAPR08CA0047.namprd08.prod.outlook.com
 (2603:10b6:a03:117::24) To DM5PR12MB1340.namprd12.prod.outlook.com
 (2603:10b6:3:76::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR12MB1340:EE_|DS7PR12MB5958:EE_
X-MS-Office365-Filtering-Correlation-Id: 05133a65-9f56-47cd-ba43-08db3d375fe3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EByYiZ0qFugr7Ah56nqt7KVcl3PG+Hwn1/leW/WBMZ3/HrlU1UTZSTKJRKHA1myfcVDI5d5+qI/rwrvgEa2lPHa1t+xCvmuxXH/4VuRC7H0Q2fIGXbc5OlDyKeeLEtPoTKeUao+Kdj5OR5FPBbcYW7jdnMMv3zsfUvcfRqOqmGvimN6Xl7M/oI4qVM+CB6ynTlUKKSpmPoa9ZlFB1H7OYX2llsVANHQcZIVk/wlwRC8mi3h3MMl3shNwe0nG44CjKKqcqq6WLGS47iACV/1qPKqf8mJKfyLf/Zd2/q0gQNNZCJbwPDbBulAbLm0CZf39gLBVdfmgpysDsKFK3LlRghOCJlBDUlSpEG/H3agE2wsPPR2NT8oFfblSauOYYYDz0nOTIJ+n9jx/p0vZEzgyRfz746zSqf39TKEWf0cI0DMicVE4tbLCc4ILebMfZ65eBT06I7dSnLT9YVoOtJyadzmgPnghXNAgTlf8sLaaIXqKZhW8LEpMZq/Yz/dIKgC9o/HgK6PjwU5I4DIL/3WY8EAr3PUdMv5DEBZcxTwfBU6UvEUzKA3NtcB1e1HvTlG3
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1340.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(7916004)(39860400002)(346002)(366004)(136003)(396003)(376002)(451199021)(66556008)(41300700001)(478600001)(6486002)(107886003)(26005)(54906003)(6512007)(6506007)(9686003)(33716001)(38100700002)(8936002)(83380400001)(8676002)(2906002)(6916009)(4326008)(66946007)(5660300002)(86362001)(66476007)(316002)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3JWyDWTrt98ESS6XBDup6pJQgO2mW1tOXZqq1dYDG8G/0RzP3DsPzeXEE5xj?=
 =?us-ascii?Q?pV9aNlp2KralvAtbgoXJULrI4edOD4J07C2UTVEN8YHxEyQyQ5SnZqxUX39B?=
 =?us-ascii?Q?2WJkm+ofOpdZottYldXcxgoPYv29/ecoKwf4UNFHm4/jlb0Edr+SSs5BcwGQ?=
 =?us-ascii?Q?vDOUVHJmQSom7r22Ko4DAfZtN3/1wjMny1QO9MiQTJ+ytfljqP5eHbkxH/4S?=
 =?us-ascii?Q?Oqr1QiSINB/QrAygySgL3ARLineADczuh+Cdi3oBjl4BjaXalagwd6sKwk4k?=
 =?us-ascii?Q?6F8rNfyot5KhZ7dTF++C9QFnk0OyMbv8QrXRrDbcPyK22EdNHMzng1yxD0Gu?=
 =?us-ascii?Q?qgFNbKKhmry7rLCbFZVv0aYFkXdrs0HiTfZQ1E1L0UnNqEgLlrpLshqQjIoW?=
 =?us-ascii?Q?gpILWCDp3rc3WVgepnbXyJqWsCHyOCroH+ugWpSCAEGJBB6PdeaNhHvjnsO6?=
 =?us-ascii?Q?YgUEwEWGQ4R7Q6LSm3pIHU1sNptC9WzFwdlzYed+f+f8bhxU1r0hgBxXtv3E?=
 =?us-ascii?Q?BWYfbFS96jjE7GCdbKm5mtIsP1K6j1l4n+9ToMqU6Pmx5ehmaqIKTUGnzYZ2?=
 =?us-ascii?Q?M/quRJYRBlHX4ocLV6fmYp/rnL6FZCa+9reGExMXfOGs0/zy5ZiSpFyOeIof?=
 =?us-ascii?Q?ItjMtyOWHpj3yGxwkyVhE/mIdD8R3XYe1ZaDaWVkzFmcxKTkZYJmvoaktpEn?=
 =?us-ascii?Q?8ShVY7QksTDNpKLqIAbADzGxO41Rbbc5CiwYSqf2bv7yfCkix7K7CbltcVd6?=
 =?us-ascii?Q?e3z1qg2wVWNgy+dEQAsC/ttPxzyUnx3DDQY2DljcOCBCJ8cO3/Kxa1wD6WI4?=
 =?us-ascii?Q?HMtIWWCG32/thryLhAon4oN5Joi1d1cbem4GCpx/aMyE9S3E4Afefg5I6UWl?=
 =?us-ascii?Q?meg2xyJYPZk/KiJMKAAelLt9eR8A9dCt7VCTxcbMjKue6enIj/7dXvtap1K8?=
 =?us-ascii?Q?YXKks52ggtrHwYYmqo109/Zdea8oJzqlfpLZqTz2r1D09FUxOe/7xf5QqgGD?=
 =?us-ascii?Q?GzY3jTd/pysqfB4dNxE21YMT24Dw0w2mpe1zcYoqo3125mVkyroDHus1x9gt?=
 =?us-ascii?Q?Rt/i17F8gm3ggB9hZtTHCad5ZqKRsL77mEh72TytMsI2tcfJv2gQpgLjf0UL?=
 =?us-ascii?Q?NqAhzlmhleCJ7Ix6w9NHJIDiT+GcP0F0HQV9DqGVRPE6NavJNjaKQYcr7BL2?=
 =?us-ascii?Q?u6s12hqEOXgxgPAge10Z+hJMrUmfF4A/AhcLDhjCPlfb3X7KlSlDeGvi4d17?=
 =?us-ascii?Q?FMbTTAaEZuBOBZwYUiAb3XW3OmNvX+tEFXPImWiqbzt2oLljpWQMsxixcPGL?=
 =?us-ascii?Q?TkG0q+5GOelHqAughxyZ7Lz364gwdDTzYxnnu6fD3Eu/xallHZ8YAQbTqQTO?=
 =?us-ascii?Q?sDCutZ3ryf8sGiRGgkwribCYN6rxDeheiIvmYbx5i5Y8NuHpv/9/Au1ONrbj?=
 =?us-ascii?Q?Nn5YSOhPNmAUAkmoQDYYmq54FdF7rQsfJvR12e8T3MKhOMpR3R8X0XlytgMJ?=
 =?us-ascii?Q?FNLkrPebHAaEp3U49N4bBZTfoKEpSm/OnkE0TCf2IjuHpdJtSMdzWvi2hjXf?=
 =?us-ascii?Q?EiDA57ljGEo0UnZg2lHupLDkqV7LtJZBLkPiLvoo?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 05133a65-9f56-47cd-ba43-08db3d375fe3
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1340.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Apr 2023 22:27:04.6518
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oOA4kJi95WWc4mfP/DbB0kNokLkgMyOGcjV38BjTFThd7qE3+qiRv2ZBJfdIOsPDmDEjJb7Nn057jgiQ1wpzKQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5958
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 14 Apr 09:12, Niklas Schnelle wrote:
>On Thu, 2023-04-13 at 15:02 -0700, Saeed Mahameed wrote:
>> On 13 Apr 14:02, Leon Romanovsky wrote:
>> > On Tue, Apr 11, 2023 at 05:11:11PM +0200, Niklas Schnelle wrote:
>> > > Hi Saeed, Hi Leon,
>> > >
>> > > While testing PCI recovery with a ConnectX-5 card (MT28800, fw
>> > > 16.35.1012) and vanilla 6.3-rc4/5/6 on s390 I've run into a kernel
>> > > crash (stacktrace attached) when the card is in switchdev mode. No
>> > > crash occurs and the recovery succeeds in legacy mode (with VFs). I
>> > > found that the same crash occurs also with a simple Function Level
>> > > Reset instead of the s390 specific PCI recovery, see instructions
>> > > below. From the looks of it I think this could affect non-s390 too but
>> > > I don't have a proper x86 test system with a ConnectX card to test
>> > > with.
>> > >
>> > > Anyway, I tried to analyze further but got stuck after figuring out
>> > > that in mlx5e_remove() deep down from mlx5_fw_fatal_reporter_err_work()
>> > > (see trace) the mlx5e_dev->priv pointer is valid but the pointed to
>> > > struct only contains zeros as it was previously zeroed by
>> > > mlx5_mdev_uninit() which then leads to a NULL pointer access.
>> > >
>> > > The crash itself can be prevented by the following debug patch though
>> > > clearly this is not a proper fix:
>> > >
>> > > --- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
>> > > +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
>> > > @@ -6012,6 +6012,10 @@ static void mlx5e_remove(struct auxiliary_device
>> > > *adev)
>> > >         struct mlx5e_priv *priv = mlx5e_dev->priv;
>> > >         pm_message_t state = {};
>> > >
>> > > +       if (!priv->mdev) {
>> > > +               pr_err("%s with zeroed mlx5e_dev->priv\n", __func__);
>> > > +               return;
>> > > +       }
>> > >         mlx5_core_uplink_netdev_set(priv->mdev, NULL);
>> > >         mlx5e_dcbnl_delete_app(priv);
>> > >         unregister_netdev(priv->netdev);
>> > >
>> > > With that I then tried to track down why mlx5_mdev_uninit() is called
>> > > and this might actually be s390 specific in that this happens during
>> > > the removal of the VF which on s390 causes extra hot unplug events for
>> > > the VFs (our virtualized PCI hotplug is per-PCI function) resulting in
>> > > the following call trace:
>> > >
>> > > ...
>> > > zpci_bus_remove_device()
>> > >    zpci_iov_remove_virtfn()
>> > >       pci_iov_remove_virtfn()
>> > >          pci_stop_and_remove_bus_device()
>> > >             pci_stop_bus_device()
>> > >                device_release_driver_internal()
>> > >                   pci_device_remove()
>> > >                      remove_one()
>> > >                         mlx5_mdev_uninit()
>> > >
>> > > Then again I would expect that on other architectures VFs become at
>> > > leastunresponsive during a FLR of the PF not sure if that also lead to
>> > > calls to remove_one() though.
>> > >
>> > > As another data point I tried the same on the default Ubuntu 22.04
>> > > generic 5.15 kernel and there no crash occurs so this might be a newer
>> > > issue.
>> > >
>> > > Also, I did test with and without the patch I sent recently for
>> > > skipping the wait in mlx5_health_wait_pci_up() but that made no
>> > > difference.
>> > >
>> > > Any hints on how to debug this further and could you try to see if this
>> > > occurs on other architectures as well?
>> >
>> > My guess that the splash, which complains about missing mutex_init(), is an outcome of these failures:
>> > [ 1375.771395] mlx5_core 0004:00:00.0 eth0 (unregistering): vport 1 error -67 reading stats
>> > [ 1376.151345] mlx5_core 0004:00:00.0: mlx5e_init_nic_tx:5376:(pid 1505): create tises failed, -67
>> > [ 1376.238808] mlx5_core 0004:00:00.0 ens8832f0np0: mlx5e_netdev_change_profile: new profile init failed, -67
>> > [ 1376.243746] mlx5_core 0004:00:00.0: mlx5e_init_rep_tx:1101:(pid 1505): create tises failed, -67
>> > [ 1376.328623] mlx5_core 0004:00:00.0 ens8832f0np0: mlx5e_netdev_change_profile: failed to rollback to orig profile,
>>
>> Yes, I also agree with Leon, if rollback fails this could be fatal to mlx5e
>> aux device removal as we don't have a way to check the state of the mlx5e
>> priv, We always assume it is up as long as the aux is up, which is wrong
>> only in case of this un-expected error flow.
>>
>> If we just add a flag and skip mlx5e_remove, then we will end up with
>> dangling netdev and some other resources as the cleanup wasn't complete..
>>
>> I need to dive deeper to figure out a proper solution, I will create an internal
>> ticket to track this and help provide a solution soon, hopefully.
>>
>
>Thank you for looking into this, do you have an idea what got us into
>this unexpected error flow. This occurs very reliably for me but I'm
>not sure if it is s390 specific or just caused by the switchdev setup.
>It's also unexpected to me that the code reports -ENOLINK does that
>refer to the PCIe link here or to the representor device being
>disconnected?
>

I believe this is not related to s390, and should happen on  x86 as well, 
I just learned yesterday that you already filed this issue through our
support and we already have an assignee working on this, let's work through
the support ticket and reduce clutter on the mailing list, I am sure we will
come up with a patch very soon and will all learn what went wrong :) ..
I have a clear idea what the issue is, but the solution may require a
bit of refactoring.. 

-Saeed.

>Thanks,
>Niklas
>

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 263DB41CBCC
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 20:26:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346082AbhI2S22 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 14:28:28 -0400
Received: from mail-dm6nam10on2078.outbound.protection.outlook.com ([40.107.93.78]:52417
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S244341AbhI2S21 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Sep 2021 14:28:27 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VZxtCazgrGicd0BO3DU+g4nGW7tSSAYtLQzTz3KBE+fvAItAz9a56JHi3ac4ZIMKpr9FweflqVJJvWtwMJHdeg/gf6K+ILvAS6FEDzrf3re7j7oh8GHBABTfMhJQh02Xq+6jMMH4ZBZNR9TOf8CkJRt9I5LIINKJcfFlPMy/z/baYDEs1ytc65oOfneWo6GG+0Y9BkrNhv2iamS5D0Zw/VTpR7xRvUdv5GVKh37gVhZlDpi9adA0etimZrClXOv9rr/1fQuTUcuE1wUD2p2PXzGI2KVyT9haAC+UW0FSdmbwyeTC4hAyI9hyAz7EFd/lpcBPGFW67vHkh+7yp6Nq0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=+unT1saw24HGZctLPemyH5FTXidrSoVe8MnnmqM/uFQ=;
 b=KoAgsFibIgY1cr1gR0A8mf37QFU1d+HRRfjfO3hVPEGd+bhqHQjEjn9STQlw01QIVL3U6uhNZHjcVch0j9llPgSTXDWklNsv32Qay/f8DsbGYbPzKf4CdhD0kugEYosXuoUCmtXjQM6/EpM3k7AI/qvAytJrmA9PUTIOLE2Tgxq30Revlm4HKATWdUIiBAu4gfhfH6kayMBtgnmNxnVhkZPbGYNzS0TDLcWxYo2ZUkQbSn+KxL5oFSA/yDPbUdIpqfXcq05EfOUk3OT6+QwlmE3CRlddIsNXBbF8h2wV66U5JedTyRiQlYcMgRmUHn2eg635aKg/JY3RIOs1aktijQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+unT1saw24HGZctLPemyH5FTXidrSoVe8MnnmqM/uFQ=;
 b=rt1O9BM0MrW+790SKvOx6e/LkijFC2AVKFyduEfCpHwHwCTVkPuAOJsZT57vF/YvyC/HNXlB/YyJ2TWtIqPbtkPf/+kbRQ06XKReR9fB7D1q0uqWGh0SUgd20daumgd+jtK57YmhwDodi3n2kixNUE+xejls/04VsMVWt8Sb7VC/DKK59Lj0h88LDp4XjtGaFWSDbn3C3d/WLEKccEffTiZAgQHbtYIh32O0KMSt/6a9D4n1fZXCrFpavAXI48mAvXfemwpbvTsCFEQvAHljS0v43DwoiEJbCrrpO9UKlSqnOYPUIkIQ49p3U26l8egxIE1/g7Xkj8gDzAt4J8XzUg==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5207.namprd12.prod.outlook.com (2603:10b6:208:318::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.14; Wed, 29 Sep
 2021 18:26:43 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95%8]) with mapi id 15.20.4566.015; Wed, 29 Sep 2021
 18:26:43 +0000
Date:   Wed, 29 Sep 2021 15:26:42 -0300
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
Message-ID: <20210929182642.GV964074@nvidia.com>
References: <cover.1632305919.git.leonro@nvidia.com>
 <c87f55d6fec77a22b110d3c9611744e6b28bba46.1632305919.git.leonro@nvidia.com>
 <20210927164648.1e2d49ac.alex.williamson@redhat.com>
 <20210927231239.GE3544071@ziepe.ca>
 <20210928131958.61b3abec.alex.williamson@redhat.com>
 <20210928193550.GR3544071@ziepe.ca>
 <20210928141844.15cea787.alex.williamson@redhat.com>
 <20210929161602.GA1805739@nvidia.com>
 <20210929120655.28e0b3a6.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210929120655.28e0b3a6.alex.williamson@redhat.com>
X-ClientProxiedBy: MN2PR18CA0016.namprd18.prod.outlook.com
 (2603:10b6:208:23c::21) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (142.162.113.129) by MN2PR18CA0016.namprd18.prod.outlook.com (2603:10b6:208:23c::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.15 via Frontend Transport; Wed, 29 Sep 2021 18:26:43 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mVeHy-007dsJ-6j; Wed, 29 Sep 2021 15:26:42 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5a23037b-c773-41f4-a13b-08d98376b02e
X-MS-TrafficTypeDiagnostic: BL1PR12MB5207:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB52072F63A0685C50F7B0BC7EC2A99@BL1PR12MB5207.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vZBJJiUpZ15g9ncFRwmvW8SgSlu2vdNiMhSE4kDrDcRbgW5iYiVcdLQnaZHfaU+5lvFXQlVmo80Ftp4a11x8iVVdHXv4136YufKq7kdYu1PiLmb8c2zLr6NosamD4I6p8ezoUkikNWa5fgXogCsNZIWJnMg8jTPVOTnuOINC/2d9UUJHmFuOHwtAzaJnQ308kS6CPhGTGw6jne+fwD+P2RNU4QeWJ/HLk9PZU/gKCytDtcxc8pUq8+I3pUd5S73mgnjHMbo3xtiFY8yYDaaaC0/xGe/QijwQOTp06OWHLBYC/VCxkSYzZb4Wip34lsyOQFbs4oxR5eOTha3MCnvCIN+TXJjvdafnO0jDjkpFQ8LwzgA5eaNRCEjtNWxkhc2yDQJBg4/3457nDVTj10LJ7OEMSA/B8pFyrvYAST1bhC1HgKXJ7pRZE6lauwSF9ZdHuud0FKStstqckfVzratsEZ1+FBeDgxXOQlj6E9eQpEEQ3GE395vQzORHhsw8SzqcEyCRnNnAIh5W2t0Zwl17VRiDAgDM5VvdQ9RNVLCqFXvfV2BAeO76qqAma3t+JsuO9lP2Qx4Ck1vRrniJRRmW9pFq/6XQ/we8ugBsW3NdCnDg96gI0YnENY0cBnPltSfmYSH8R9zIUsg5EtFn76uepsrzyOQOn9PpTm54wli4sidpsPqEZLqy2SwLbRQfuQKI
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(2616005)(7416002)(6916009)(86362001)(83380400001)(508600001)(36756003)(1076003)(9786002)(33656002)(9746002)(186003)(426003)(38100700002)(26005)(4326008)(54906003)(316002)(8676002)(66946007)(2906002)(66556008)(66476007)(8936002)(5660300002)(27376004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?uoB6jI/WzW6+wd+IWRE8fTkD9g7tnzeRj+dKl+vtOD3eszdSt6W45gPOCPb6?=
 =?us-ascii?Q?9LHsGFAmoRjtWLoRIqLciazINR14WQOWBueIPbcCdVPaCsgdoTrztlpMUPHj?=
 =?us-ascii?Q?vNc6mnopiiYgw3pBi5Rhc14Kj/hfuF3jHiuBgK2f9CCExEme5ozZkQage35L?=
 =?us-ascii?Q?zKwFEoxNpZUUJ/m7B8u5hi7i05yx4xYP1Np6u087x6TP7CT2eIxjtWClcAdP?=
 =?us-ascii?Q?JdgCYEokUNYr69Eb5uB/vT0SOfYfKz8jaeT/L8ZV6yok8fBp3UarE2dKE/dQ?=
 =?us-ascii?Q?6k5IYQxNB+FlcyakhRq3TxosPEwILEGMM3FnKbLMgqX7WpdoJ4R/JLrKQdVM?=
 =?us-ascii?Q?IkXDYMxH/HZANIUYImZrEe0sapX/OPg2f+TlMhggrhXAObOn2PzEL14JIECF?=
 =?us-ascii?Q?oOtxWEnjDoSmzTr/3LSq/gdesxR64NhHiasw0YeroKHf73w7wa1myzAt9zDS?=
 =?us-ascii?Q?PxfNDU6wpPCuE1Jtj+0PbCs2+j7w0nNZWeVYXWLnYg+1t5nWV/S2/fTLmDt8?=
 =?us-ascii?Q?xEtwSLoSt4aShFpyP962+W1wdUXc1eCu0R2jDlvn/to9QOGOLuCR35EA2Dvy?=
 =?us-ascii?Q?JMF484OAGvSiE7Bu1YrWwa0hylhVVEznxbAXdG/iOi00G8CjABQ1x5Hy9ZvI?=
 =?us-ascii?Q?y1uZGevfHoeuFZX/vc/Ms5AECcxTdRKcAyV74eedATEDqFNhvMx5A0NCODgf?=
 =?us-ascii?Q?LL7Xse4Qh3KPsDoxUg50lK/DeyvQ0NtEz1WtJhbhurn2TZpiXITDT5SljVFY?=
 =?us-ascii?Q?pG9BWpjDqkPn33hPS1ChsyRK0tCApkoNqZPo4zmbkbVVpfgbBnbzamshFa+K?=
 =?us-ascii?Q?8pkptL2kkb+8+g9tT0uBnki6OPE2C54lhsJU4wTW5tzFZwe16Qzq5QLaeNfn?=
 =?us-ascii?Q?wHwSm91ojfkB3keQ7+XbXYFrK40vjOxGTV8FlbDAftkyF99O/S4yPBuTdOtd?=
 =?us-ascii?Q?kcu1HetYPE1HxPZcjOWtQJTZ03pKgFuiCwh7wt7iF+JegU7LSwxw2plyKaXl?=
 =?us-ascii?Q?nB/8NlSCvA03U7KJyTtpMawylcNjaivjm/OpDLawEN3j9l4EXZTQjT0uZYJ4?=
 =?us-ascii?Q?aQh7ac9s3PkQbOjpNW8HOuVW75KsRonjlvtvvaCrjWOkIHGmUKjzCzb/kv9a?=
 =?us-ascii?Q?aAvrhQrcWZ7qyjAN0Y8tpuuTmCdOhFX6VTOG7IAZpoO/yFFyXt4GWujfWs7z?=
 =?us-ascii?Q?JPi1CPAd7aoAqm2rDpYHtd4WkX+nFXdTCwxi3gVOSE614L+DzQGTOikoFZjS?=
 =?us-ascii?Q?4gd4YSPd04/bbKSh4VH+nS1WLSi1d28xavwjEik3rKcRfWC3fvLowcaokLcH?=
 =?us-ascii?Q?cvsRL1oii6UeTzgGyygpeYE0?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a23037b-c773-41f4-a13b-08d98376b02e
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2021 18:26:43.6673
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9mv2YyptJMLikFD+jyFFgmJlKPXXgufo5uVfAZJaXoIbbUAbqzmTrjOaUkBQBLwn
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5207
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 29, 2021 at 12:06:55PM -0600, Alex Williamson wrote:
> On Wed, 29 Sep 2021 13:16:02 -0300
> Jason Gunthorpe <jgg@nvidia.com> wrote:
> 
> > On Tue, Sep 28, 2021 at 02:18:44PM -0600, Alex Williamson wrote:
> > > On Tue, 28 Sep 2021 16:35:50 -0300
> > > Jason Gunthorpe <jgg@ziepe.ca> wrote:
> > >   
> > > > On Tue, Sep 28, 2021 at 01:19:58PM -0600, Alex Williamson wrote:
> > > >   
> > > > > In defining the device state, we tried to steer away from defining it
> > > > > in terms of the QEMU migration API, but rather as a set of controls
> > > > > that could be used to support that API to leave us some degree of
> > > > > independence that QEMU implementation might evolve.    
> > > > 
> > > > That is certainly a different perspective, it would have been
> > > > better to not express this idea as a FSM in that case...
> > > > 
> > > > So each state in mlx5vf_pci_set_device_state() should call the correct
> > > > combination of (un)freeze, (un)quiesce and so on so each state
> > > > reflects a defined operation of the device?  
> > > 
> > > I'd expect so, for instance the implementation of entering the _STOP
> > > state presumes a previous state that where the device is apparently
> > > already quiesced.  That doesn't support a direct _RUNNING -> _STOP
> > > transition where I argued in the linked threads that those states
> > > should be reachable from any other state.  Thanks,  
> > 
> > If we focus on mlx5 there are two device 'flags' to manage:
> >  - Device cannot issue DMAs
> >  - Device internal state cannot change (ie cannot receive DMAs)
> > 
> > This is necessary to co-ordinate across multiple devices that might be
> > doing peer to peer DMA between them. The whole multi-device complex
> > should be moved to "cannot issue DMA's" then the whole complex would
> > go to "state cannot change" and be serialized.
> 
> Are you anticipating p2p from outside the VM?  The typical scenario
> here would be that p2p occurs only intra-VM, so all the devices would
> stop issuing DMA (modulo trying to quiesce devices simultaneously).

Inside the VM.

Your 'modulo trying to quiesce devices simultaneously' is correct -
this is a real issue that needs to be solved.

If we put one device in a state where it's internal state is immutable
it can no longer accept DMA messages from the other devices. So there
are two states in the HW model - do not generate DMAs and finally the
immutable internal state where even external DMAs are refused.

> > The expected sequence at the device is thus
> > 
> > Resuming
> >  full stop -> does not issue DMAs -> full operation
> > Suspend
> >  full operation -> does not issue DMAs -> full stop
> > 
> > Further the device has two actions
> >  - Trigger serializating the device state
> >  - Trigger de-serializing the device state
> > 
> > So, what is the behavior upon each state:
> > 
> >  *  000b => Device Stopped, not saving or resuming
> >      Does not issue DMAs
> >      Internal state cannot change
> > 
> >  *  001b => Device running, which is the default state
> >      Neither flags
> > 
> >  *  010b => Stop the device & save the device state, stop-and-copy state
> >      Does not issue DMAs
> >      Internal state cannot change
> > 
> >  *  011b => Device running and save the device state, pre-copy state
> >      Neither flags
> >      (future, DMA tracking turned on)
> > 
> >  *  100b => Device stopped and the device state is resuming
> >      Does not issue DMAs
> >      Internal state cannot change
> 
> cannot change... other that as loaded via migration region.

Yes

> The expected protocol is that if the user write to the device_state
> register returns an errno, the user reevaluates the device_state to
> determine if the desired transition is unavailable (previous state
> value is returned) or generated a fault (error state value
> returned).

Hmm, interesting, mlx5 should be doing this as well. Eg resuming with
corrupt state should fail and cannot be recovered except via reset.

> The 101b state indicates _RUNNING while _RESUMING, which is simply not
> a mode that has been spec'd at this time as it would require some
> mechanism for the device to fault in state on demand.

So lets error on these requests since we don't know what state to put
the device into.

> > The two actions:
> >  trigger serializing the device state
> >    Done when asked to go to 010b ?
> 
> When the _SAVING bit is set.  The exact mechanics depends on the size
> and volatility of the device state.  A GPU might begin in pre-copy
> (011b) to transmit chunks of framebuffer data, recording hashes of
> blocks read by the user to avoid re-sending them during the
> stop-and-copy (010b) phase.  

Here I am talking specifically about mlx5 which does not have a state
capture in pre-copy. So mlx5 should capture state on 010b only, and
the 011b is a NOP.

> >  trigger de-serializing the device state
> >    Done when transition from 100b -> 000b ?
> 
> 100b -> 000b is not a required transition, generally this would be 100b
> -> 001b, ie. end state of _RUNNING vs _STOP.

Sorry, I typo'd it, yes to _RUNNING

> I think the requirement is that de-serialization is complete when the
> _RESUMING bit is cleared.  Whether the driver chooses to de-serialize
> piece-wise as each block of data is written to the device or in bulk
> from a buffer is left to the implementation.  In either case, the
> driver can fail the transition to !_RESUMING if the state is incomplete
> or otherwise corrupt.  It would again be the driver's discretion if
> the device enters the error state or remains in _RESUMING.  If the user
> has no valid state with which to exit the _RESUMING phase, a device
> reset should return the device to _RUNNING with a default initial state.

That makes sense enough.

> > There is a missing state "Stop Active Transactions" which would be
> > only "does not issue DMAs". I've seen a proposal to add that.
> 
> This would be to get all devices to stop issuing DMA while internal
> state can be modified to avoid the synchronization issue of trying to
> stop devices concurrently?  

Yes, as above

> For PCI devices we obviously have the bus master bit to manage that,
> but I could see how a migration extension for such support (perhaps
> even just wired through to BM for PCI) could be useful.  Thanks,

I'm nervous to override the BM bit for something like this, the BM bit
isn't a gentle "please coherently stop what you are doing" it is a
hanbrake the OS pulls to ensure any PCI device becomes quiet.

Thanks,
Jason

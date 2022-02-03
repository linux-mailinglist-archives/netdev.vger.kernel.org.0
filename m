Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C73A34A85FE
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 15:17:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351078AbiBCORJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 09:17:09 -0500
Received: from mail-dm3nam07on2087.outbound.protection.outlook.com ([40.107.95.87]:60897
        "EHLO NAM02-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235184AbiBCORI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Feb 2022 09:17:08 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hRYdmERi7RWGr05lJPCHxBzErfY8gaiMNq2HbG8kSFN9Q5R4lLK00MVrY4Pr+KT+HoI1PNYMJrfyVJYxxmRZUGfJPRf01k9pye+nSfEOCTBulSBq7FNJLKk1qLji6hJffNv/ZAt2QNA962lBeJjdwiLeCFTJv3jcbyCE47dvd68x80mdyAT6+sccITIWocEu5QgA1OyqXvNAhNBRssISMGTkoxiL2+nV6TlLGIYF2Md5iln2Zsi8U3Dw32bsjyUe3Z0NeBf7Kl14Ct8T/xioZkyU4l1b0KqHWhQOzhQQjNg/b0evfDaF8/XytKOewELeklXuLKHR0IulFeMESP2jyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hQI1Ufrov9GlZ/lz+Va560Ijmwl3mLTJ/WtdIsZ0UTk=;
 b=ZHhd3WxCnHL4c8tS4homh88zbNpnMrF1iJR1vaMMeIeglYQT20WhY2BnNYJ59Kjcz3BCZ0lNucKN+1hLDvQ1s87MWSwxnXvoZOp/n6SRSivVv3weTeyjA2E2gNcr7DSSq+NhY+jFptaAkFqb0Zpukl8omo2TdI/cpysqsFHBxbq0FGjwvxykZHlHv8i7O2NtFq63d4I8c3ifX8F1vGgvTBqLos2wNQ8udZkwY20TzDY67qNl3HO4zp51z+GcXbLb6zt6Yk7t6tyZ23uZcqKsQVosUC3ur5xS1P+Yh6Max8Z3CYLJd3V2INIrVipTIpQE2Y5JMDSDBl7OSTJewyOQtQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hQI1Ufrov9GlZ/lz+Va560Ijmwl3mLTJ/WtdIsZ0UTk=;
 b=EcnICLmn943OICUdAZLMciDNIroLzJGEDsijPvRRtq+y7s/1KM4pLsSU+t8TH1DGUH3MIkEGa/hhehLWuUlhflcz05jNySYsNnMMekhpTMgjlunm53uyt66LnLK4KAapIrblI6HcGtwMwr17jqP9qS2dQ/ix7hEZaE8uPNdfskjZ9q5NrjGgzgzlSM6E/yy77+GyWJvVgYx6/SQj9B/0M/jMHMWknFXm3zbflQ/8tILwJEcDk806FH7MzBjUVsw+odFqR53qn2gOShfBAp7rXNUTkyY7eR6LiYcMST6D80lOMWzu8m5AFQsnMJmDmhjGQmx3tdnbORQXNqJHi7Hwag==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by BL0PR12MB4929.namprd12.prod.outlook.com (2603:10b6:208:1c4::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.11; Thu, 3 Feb
 2022 14:17:06 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::e8f4:9793:da37:1bd3]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::e8f4:9793:da37:1bd3%4]) with mapi id 15.20.4951.012; Thu, 3 Feb 2022
 14:17:06 +0000
Date:   Thu, 3 Feb 2022 10:17:05 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Yishai Hadas <yishaih@nvidia.com>, bhelgaas@google.com,
        saeedm@nvidia.com, linux-pci@vger.kernel.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, kuba@kernel.org, leonro@nvidia.com,
        kwankhede@nvidia.com, mgurtovoy@nvidia.com, maorg@nvidia.com
Subject: Re: [PATCH V6 mlx5-next 08/15] vfio: Define device migration
 protocol v2
Message-ID: <20220203141705.GA1786498@nvidia.com>
References: <20220130160826.32449-1-yishaih@nvidia.com>
 <20220130160826.32449-9-yishaih@nvidia.com>
 <20220131164318.3da9eae5.alex.williamson@redhat.com>
 <20220201003124.GZ1786498@nvidia.com>
 <20220201100408.4a68df09.alex.williamson@redhat.com>
 <20220201183620.GL1786498@nvidia.com>
 <20220201144916.14f75ca5.alex.williamson@redhat.com>
 <20220202002459.GP1786498@nvidia.com>
 <20220202163656.4c0cc386.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220202163656.4c0cc386.alex.williamson@redhat.com>
X-ClientProxiedBy: BL1P222CA0002.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:208:2c7::7) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6e174d46-59e5-47be-1ec6-08d9e71fdb94
X-MS-TrafficTypeDiagnostic: BL0PR12MB4929:EE_
X-Microsoft-Antispam-PRVS: <BL0PR12MB4929C38B1C62B8A34C634F68C2289@BL0PR12MB4929.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CK5GCo252/xZ0R5WcreXxE4mcnhUxja1cVl2kll2kea94n/EDytFK2S+3Uonop5kbG+4XSHb8IAWSQG75oCK/YJ/Ma7Cipbicnbu389aYOxCf8TnIWG3izrOfj3S3M5fFii9e+p+sinXUKiABAVESAFuoGiF4u0pNptDn+KGihwVgZN1PCA/k9IJY9eIwrKjIObAV56SjN6Nqk67E7jYnpZ0x6Czf8pADD1q+cutLaFuO139ue+9VT6sk6eYhGxoE99mPwofgOwW+EQU9qh+v0ESoumxKu3bfIs6KDV6ZkAigYblolmZOqhLvFpls5siLRMHcNQBp0hqDDG2a/kKxZfI4rDZtW4QE3/5V+D/myiiMiUM6U7p95hqgbltLWs/W85w79sM6JCp/FPoWbBw2f+JzKokxJ/r2g3k0H6A5A9levNaQa0aNPP75Nb1pcAL7TCLuItRVDSZv1Vm4Rl2xzwegJjwwXyqkrjUnjShfEEMy6rGqVgojD46zr0v+r2DnG1edn3Uc81sXv/g5GUQUkleMz1PDsAk8W3OnVnmw7zTujvhfihJP0WEqWpirSgXJ+LnKNX3NKcx2pezeACUFdp89e/TzUMD19FzN+BK1LFzIkEVlcplbtNneByJL5jjFDMefrKbqe+704vHFLZ1LH3zvxTXmfi2FMH3AhlfzaQRd7QvdjBGQc9nYq3NGFTc1Y7VU5tgZAj2p/0tsAhK/A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(2906002)(5660300002)(6486002)(86362001)(316002)(6916009)(83380400001)(36756003)(4326008)(66556008)(38100700002)(66946007)(6506007)(6512007)(8676002)(8936002)(66476007)(508600001)(1076003)(107886003)(186003)(2616005)(26005)(33656002)(21314003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?pvBI3S/uCxySOSoMYg5kqlZvkw9tKV8gbNXfiK/KgTlCU85cnahyViRbs05O?=
 =?us-ascii?Q?GIL+G5x1KDOVboVg49Z1pcbvxKDLm7M0yjCUXMXHprZ37OPRagn+HLLcl70Y?=
 =?us-ascii?Q?vZwVjpuPKjm/VpULDR48pu/2hLK3MPnk40OIz+sLndDDgr7wlOikLFUfBwd/?=
 =?us-ascii?Q?k3+p2V4z41b+j9Qt3hrt2y5a8nStdg0ZuU5yVm0Y3Gdiqs+ynTIytDQyb13s?=
 =?us-ascii?Q?VxZStharBbhWyHQDsE5TkThgEJLI3cGp3wpe0i7n4KYtm4ZqWZmfb0Vl0eO9?=
 =?us-ascii?Q?AThywmUiY3UenxIzKsbKfXjjBw+vBJT/cc7hn74kET/U2G3bbe0+Jsy05oS/?=
 =?us-ascii?Q?47cVuA812Z7QQut1jHYTZ6SG6CJIZoSftF6HQTBTsIs9bCNjEMjILKH01FK/?=
 =?us-ascii?Q?dj3ZP5pf4BnZyBTlJ8ronKjFncn46a4Iy7elvd81kcxwgLkHb1UfNSQi+731?=
 =?us-ascii?Q?Zjqh1ExUtgzRtVt+IFia0gszJ4Qe69zAMSDuWqbWBHensY9wG6DfD5L20opA?=
 =?us-ascii?Q?z9IHuRo2xGMoovG4eYcp02arC2byJenJVgH4y5XybC8+lOMU6CvLJ0IU0Ogr?=
 =?us-ascii?Q?c0zKwLMZBjvG2UDru+U8tV0Rt5hOGOY+KO4ojLL/OjhGKKTM7xQ9LpzxxxIg?=
 =?us-ascii?Q?HIJRbJzspotBseR5jdZTwzL3pu9uS9NPmUjpwGDDee/mNH17XPmv5R02G3yi?=
 =?us-ascii?Q?Le+wbPLjCfRjFde7tRCFQWPbKlO/qg5g5MW20zh+M3VWN+oPSWZIzutgCoHA?=
 =?us-ascii?Q?NeYOH31mQCz/chsWJ8wNPli6tW4GDOKMntd7eKmAHYdEysPVA8dG045LtijX?=
 =?us-ascii?Q?noQaZTOkompT4gr12L//yfeK8bSTpmOah8KrSpzmCvOROUaFFuD7MeFfFS4s?=
 =?us-ascii?Q?ZN2djHXE/QzMBl3KX2MetGIek+mFUXpicyGjcu6iicaEL3jRwtsb/jD4FnOV?=
 =?us-ascii?Q?oTgk1VZ25FS3jyjMUfnEM1PZNAUtikxPdnDm9fiBP15trc8etlLQXj8YBh7N?=
 =?us-ascii?Q?4pnFkqRrMLtOM9LNUusOHvZQsfpxAhDduNhTVmKhy+vC0mz1EHZKE4dhQIGn?=
 =?us-ascii?Q?TbwYWIRnX+P2v2imulMogWXMyGuKzLutTbbKbSgTuKF0Y6TOqZqU3RphYdmg?=
 =?us-ascii?Q?R2qJZtENUkTeext8uxo/vsK5VnKs2NQgYxECMBMACNWa2WJ5KDrEtRFpxBA6?=
 =?us-ascii?Q?OLiH8ogjYv42A3X0FVCbSD6MvS70wnvtEowg93G26qxdzwTgXY4SWH7+IV7C?=
 =?us-ascii?Q?R9l6xYT966u4qUsM9eFR1KsQ4vIxZOGWLRt8hf0G+EVGDZsaLRGpGw7XyeOD?=
 =?us-ascii?Q?0nnMroki43FBZ8Tx8tTvryXoECR9wlG5Ajc7knFNgzTIJGmZkSxOovXDHcVB?=
 =?us-ascii?Q?dv3nBxvILllx7gkBjKGMG4OofywyYi/ROP7B5/nHfHQIDxjjcPOAYyzHmkK2?=
 =?us-ascii?Q?6rviT2XSgWSTMslMljbSD2jmn9B3l0I207TVGZQORuVxWwr7CiRMMWuErS2X?=
 =?us-ascii?Q?Mrz413qE4iAxt3tluUlilFZw1+JC5WxLBd5ndajWSJ1AYP6vkn2sf5WAcYIV?=
 =?us-ascii?Q?fnn38iC2IO9wpdIpSeM=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e174d46-59e5-47be-1ec6-08d9e71fdb94
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Feb 2022 14:17:06.6680
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GGbX5k5QR8fRkbWXExlSwfaXICFZ91r3xq5asUsVWAkr50CILaXwhKByAiEEl2t0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB4929
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 02, 2022 at 04:36:56PM -0700, Alex Williamson wrote:

> > So you are asking to remove "is not reliable" and just phrase is as:
> > 
> > "device_state is updated to the current value when -1 is returned,
> > except when these XXX errnos are returned?
> > 
> > (actually userspace can tell directly without checking the errno - as
> > if -1 is returned the device_state cannot be the requested target
> > state anyhow)
> 
> If we decide to keep the existing code, then yes the spec should
> indicate the device_state is invalid, not just unreliable for those
> errnos, but I'm also of the opinion that returning an error condition
> AND providing valid data in the return structure for all but a few
> errnos and expecting userspace to get this correct is not a good API.

It was done this way because we didn't see any use case for the
reading the device_state except debugging, and adding another ioctl
and driver op just to get the device_state without a real user looked
like overkill.

As you already analyzed, despite the scary label in the comment, this
return is actually fully reliable so long as the userspace is
operating the API correctly - eg checking the feature flag and so on.

So, it is not as scary as you are making it out to be - and yes maybe
GET on FEATURE is cleaner.

> > It is allowed to transition to RUNNING due to reset events it captures
> > and since we capture the reset through the PCI hook, not from VFIO,
> > the core code doesn't synchronize well. See patch 14
> 
> Looking... your .reset_done() function sets a deferred_reset flag and
> attempts to grab the state_mutex.  If there's contention on that mutex,
> exit since the lock holder will perform the state transition when
> dropping that mutex, otherwise reset_done will itself drop the mutex to
> do that state change.  The reset_lock assures that we cannot race as the
> state_mutex is being released.
> 
> So the scenario is that the user MUST be performing a reset coincident
> to accessing the device_state and the solution is that the user's
> SET_STATE returns success and a new device state that's already bogus
> due to the reset.

Er, no, you suggested the core code could just cache the return since
it cannot change and then use that cached value as though it is
correct. As reset happens outside the core call chain's view it means
any core cache becomes out of sync. It is not a race, it just means
we can't cache the value in the core.

> Why wouldn't the solution here be to return -EAGAIN to the user or
> reattempt the SET_STATE since the user is clearly now disconnected
> from the actual device_state?

This is just a race that the user inflicted on themselves. We protect
kernel integrity and choose to resolve the race as though the
set_state happened first in time and the reset happened second in
time.

The API is not designed to be used concurrently, so it is a user error
if they hit this.

> > We can do this too, but it is a bunch of code to achieve this and I
> > don't have any use case to read back the device_state beyond debugging
> > and debugging is fine with this. IMHO
> 
> A bunch of code?  If we use a FEATURE ioctl, it just extends the
> existing implementation to add GET support.  That looks rather trivial.
> That seems like a selling point for using the FEATURE ioctl TBH.

We didn't even define a driver op to return the current state, trivial
code yes, but code nonetheless.

> > Things like the cap chains enter a whole world of adventure for
> > strace/syzkaller :)
> 
> vfio's argsz/flags is not only a standard framework, but it's one that
> promotes extensions.  We were able to add capability chains with
> backwards compatibility because of this design.  

IHMO the formal cap chains in the INFO ioctls were a mistake. The
argsz/flags already provide enough extension capability to return the
few extra fields directly by growing the main struct through argsz and
that handles most of what is in the caps.

The few variable size caps, like iova ranges, would have been simpler
as system calls that return only that data. This avoids userspace from
having to do all the memory allocation stuff just to read a single u32
when they don't have an interest in, say, ranges.

> initially did not see the fit for setting device state as interacting
> with a device feature, but it doesn't seem like you had a strong
> objection to my explanation of it in that context.

I don't have a strong feeling here. I think as the maintainer you
should just set a clear philosophy for ioctls in VFIO and communicate
it. There are many choices, most are reasonable.

We tried the FEATURE path, and it is OK of course, but it looks weird
as set_state is in/out due to the data_fd but it being used with
SET. I can't say that it is any better, and diffstate says it is more
code.

> > > Should that be an ioctl on the data stream FD itself?    
> > 
> > I can be. Implementation wise it is about a wash.
> > 
> > > Is there a use case for also having it on the STOP_COPY FD?  
> > 
> > I didn't think of one worthwhile enough to mandate implementing it in
> > every driver.
> 
> Can the user perform an lseek(2) on the migration FD?  Maybe that would
> be the difference between what we need for PRE_COPY vs STOP_COPY.  In
> the latter case the data should be a fixes size and perhaps we don't
> need another interface to know how much data to expect.

I'm leary to abuse the FD interface this way, we setup the FD as
noseek, like a pipe, and the core fd code has some understanding of
this.

> One use case would be that we want to be able to detect whether we can
> meet service guarantees as quickly as possible with the minimum
> resource consumption and downtime.  If we can determine from the device
> that we can't possibly transfer its state in the required time, we can
> abort immediately without waiting for a downtime exception or flooding
> the migration link.  Thanks,

It is an idea, but I don't know how to translate bytes to time, we
don't know how fast the device can generate the data for instance.

Jason 

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FBD046A098
	for <lists+netdev@lfdr.de>; Mon,  6 Dec 2021 17:03:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348969AbhLFQGP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 11:06:15 -0500
Received: from mail-bn7nam10on2079.outbound.protection.outlook.com ([40.107.92.79]:63645
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1388526AbhLFQEN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Dec 2021 11:04:13 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cgCYRpeS11HuwIKZiiR5PTSQrYCPxRCnWsNnGuvNiKs1Dq0M6rkhq0wdgDzkMaLaex7CknYFup3XI5xf4wlk6El9uFho+m5xhumTk9gUmO/NqJ4tZQ6bAPe+3Wn525oNwn1Y25Li9w/l8Zj1YoQ1tN3wKaVlt6poqesAcN13potOnnqYlhVUsYQrGJRGQa+9uDdozZIm7Pyjjr8paeKLBy1wRdC3O0JPBgr76BzztzqoBLtbSE4NGXKEgjGSUh3FADX+x3Ke01b1IkwN77VSVFfTRHsHnx5ujXyFlV0oBdvaCXIXxTr3GSrf19jfhd2raW4GcuN06gp1ydXg3S3S6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1+T/E5P7m0zbVhcNjfbD5ONbqQspYl+6rSaqUTA3L/E=;
 b=nJy8j7OL31JKdFVMpveGnbWfcXR807Ofnk0kJs0csYZD0pw61kLoy+1ZxzeJtoYB/z2TTcXk4+MunJd2/LSvBXCu4RgwAom8mQwNo/DOujEMcqVCEXPvk5Q7nMwAW5PqZ2mc9XWB6LCdQST9G2ShDwyt+AVgreSr1/RjlG6FF2VZAKYalIgb2SbQ82qzig1s2ZZnyEjR9Gi0llZbyAy47nAFCURB9+PC5qKcME/WISzH0vwqwfLTNBmO+lWIFvp0JQC4IX9zbR/01AAPup4wwHvj1NVBX54YoYO20o87mNRS5LfUgWrHL/VTdqQeU2pKn4xxWmW0yHeygywTFItr7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1+T/E5P7m0zbVhcNjfbD5ONbqQspYl+6rSaqUTA3L/E=;
 b=p3GW4P2AQ2uhlZn/jl+FpytFyxETlJ9HQgTY0ZVBbmCkd2YgrVP8UmJbSetktUWaqn1z2F92jVaOudgAjNKxz/e+LAwr/B3fsMz2Dr9nmHrYgUnYqmMzymgasRjxeCAqvBjRWeRcxZlh/OlKdnDE1YV4NqA4esLnSwWWTWkXd290jYFgE1CiTWJHT8y7Z9OBzo53shhN6KGnD7Uj22Vj8ffcR8/DoTBVzdfmOagmqBQwRC7kKUaKsaTGfpGvOb0+3g4hLg81TGE3V3C7ztGqv5ge8K0zH+mYigZHdjoP9Xz6++SkEJM+mxJA+yYuR/w4XZggPnJs313tXU/C+yFohw==
Received: from MW4PR04CA0215.namprd04.prod.outlook.com (2603:10b6:303:87::10)
 by BN9PR12MB5305.namprd12.prod.outlook.com (2603:10b6:408:102::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.21; Mon, 6 Dec
 2021 16:00:41 +0000
Received: from CO1NAM11FT055.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:87:cafe::52) by MW4PR04CA0215.outlook.office365.com
 (2603:10b6:303:87::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.22 via Frontend
 Transport; Mon, 6 Dec 2021 16:00:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 CO1NAM11FT055.mail.protection.outlook.com (10.13.175.129) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4755.13 via Frontend Transport; Mon, 6 Dec 2021 16:00:41 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 6 Dec
 2021 08:00:33 -0800
Received: from yaviefel (172.20.187.5) by rnnvmail201.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.986.9; Mon, 6 Dec 2021
 08:00:28 -0800
References: <20211201180208.640179-1-maciej.machnikowski@intel.com>
 <20211201180208.640179-3-maciej.machnikowski@intel.com>
 <Yai/e5jz3NZAg0pm@shredder>
 <MW5PR11MB5812455176BC656BABCFF1B0EA699@MW5PR11MB5812.namprd11.prod.outlook.com>
 <Yaj13pwDKrG78W5Y@shredder>
 <PH0PR11MB583105F8678665253A362797EA699@PH0PR11MB5831.namprd11.prod.outlook.com>
 <87pmqdojby.fsf@nvidia.com>
 <MW5PR11MB581202E2A601D34E30F1E5AEEA6A9@MW5PR11MB5812.namprd11.prod.outlook.com>
 <87lf11odsv.fsf@nvidia.com>
 <MW5PR11MB5812A86416E3100444894879EA6A9@MW5PR11MB5812.namprd11.prod.outlook.com>
 <87fsr9o7di.fsf@nvidia.com>
 <MW5PR11MB5812AA2C625AC00616F94A2AEA6A9@MW5PR11MB5812.namprd11.prod.outlook.com>
 <87czm9okyc.fsf@nvidia.com>
 <MW5PR11MB58121BF596AB9C501F900887EA6D9@MW5PR11MB5812.namprd11.prod.outlook.com>
User-agent: mu4e 1.4.15; emacs 27.2
From:   Petr Machata <petrm@nvidia.com>
To:     "Machnikowski, Maciej" <maciej.machnikowski@intel.com>
CC:     Petr Machata <petrm@nvidia.com>, Ido Schimmel <idosch@idosch.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "Kubalewski, Arkadiusz" <arkadiusz.kubalewski@intel.com>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "abyagowi@fb.com" <abyagowi@fb.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        "mkubecek@suse.cz" <mkubecek@suse.cz>,
        "saeed@kernel.org" <saeed@kernel.org>,
        "michael.chan@broadcom.com" <michael.chan@broadcom.com>
Subject: Re: [PATCH v4 net-next 2/4] ethtool: Add ability to configure
 recovered clock for SyncE feature
In-Reply-To: <MW5PR11MB58121BF596AB9C501F900887EA6D9@MW5PR11MB5812.namprd11.prod.outlook.com>
Date:   Mon, 6 Dec 2021 17:00:26 +0100
Message-ID: <877dchoh9h.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.20.187.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 484bc8b9-a266-4e05-d442-08d9b8d18d91
X-MS-TrafficTypeDiagnostic: BN9PR12MB5305:EE_
X-Microsoft-Antispam-PRVS: <BN9PR12MB5305C95E42D7A5EBD64CE2DED66D9@BN9PR12MB5305.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UQKir9eYDm1EwJJQkpbXGse5X27u3dC9a09PEYW4eMAOWdUK0PRhvOmDqSlXT88O3XkiDqNiC/vbQ/kw+dO09GLVMFwGcT80FSBzWNHdl9IzKgPy4iHDJGZ7XcJLEGmFAGQptQYNVzRm+3Jhbs76fm8CUoU2azHEgJyTxbpJJLhFP47F8uqwJ6SA107CYsIpL0C0fVW8R9kg9LTSB0+1V1hxAcKRdwb3Ql3b5JzZ/REESVrHShgb/9euTzjlk9kb04TLnEQj3OwbiLcsp6nQt0z50nP//rPCGKdrT8cvjcZwcePaOZaCEqzYxeisLuWUoWKPf6RVdmV+ZwJH1+DZIpiykoWNK8Y2p5AGZ2EmVEOw2jcoN5lHrI+4S0RRONGtRtwFBjs5Is3azOkDtlIj9FKHV407AW49Yn16X4LFbl41G0E0oQq+n0UWP1cSNfxkz86k7D8dBTD41eitqxWOihQLVbZWHRmhbC5Ylt9OwHQWwseZ02raStJxFd5pU8z5CG0+9UgCP/Yy1TDNIJbYRinw7n0BSD/DV1idk6xiTnzum1tHtyatNlfFO9BGL72XrrTu5XWam8c8uhH/HuzDybEEWScuaATbAhx4ORmBsSaT87stNrIdjlFjj6SwpyevzD3/6prMavd4UJLsZXuSjywBv7JFl6UNncG3G4WQ2giG67k61tKIU6ljpQ9Ee+zlTpz8XVu1XxuaHLiVs15PdyOT+r/p65BLj9uB6Xpt93p/Z+LX/jdZcnDC/2Tn7zMYrv3QTVOvCOBR39+D10lPjA==
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(40470700001)(36860700001)(54906003)(53546011)(316002)(86362001)(7416002)(70586007)(70206006)(5660300002)(2906002)(508600001)(7636003)(8936002)(4326008)(8676002)(40460700001)(186003)(82310400004)(16526019)(47076005)(336012)(356005)(2616005)(83380400001)(426003)(26005)(6916009)(36756003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2021 16:00:41.0268
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 484bc8b9-a266-4e05-d442-08d9b8d18d91
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT055.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5305
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Machnikowski, Maciej <maciej.machnikowski@intel.com> writes:

>> -----Original Message-----
>> From: Petr Machata <petrm@nvidia.com>
>> Sent: Monday, December 6, 2021 3:41 PM
>> To: Machnikowski, Maciej <maciej.machnikowski@intel.com>
>> Subject: Re: [PATCH v4 net-next 2/4] ethtool: Add ability to configure
>> recovered clock for SyncE feature
>> 
>> 
>> Machnikowski, Maciej <maciej.machnikowski@intel.com> writes:
>> 
>> >> -----Original Message-----
>> >> From: Petr Machata <petrm@nvidia.com>
>> >>
>> >> Machnikowski, Maciej <maciej.machnikowski@intel.com> writes:
>> >>
>> >> > Additionally, the EEC device may be instantiated by a totally
>> >> > different driver, in which case the relation between its pins
>> >> > and netdevs may not even be known.
>> >>
>> >> Like an EEC, some PHYs, but the MAC driver does not know about
>> >> both pieces? Who sets up the connection between the two? The box
>> >> admin through some cabling? SoC designer?
>> >>
>> >> Also, what does the external EEC actually do with the signal from
>> >> the PHY? Tune to it and forward to the other PHYs in the complex?
>> >
>> > Yes - it can also apply HW filters to it.
>> 
>> Sounds like this device should have an EEC instance of its own then.
>> 
>> Maybe we need to call it something else than "EEC". PLL? Something
>> that does not have the standardization connotations, because several
>> instances would be present in a system with several NICs.
>
> There will be no EEC/EEC subsystem, but the DPLL. Every driver would
> be able to create a DPLL object so that we can easily use it from
> non-netdev devices as well. See the other mail for more details.

Yes, this makes sense to me.

>> > The EEC model will not work when you have the following system:
>> > SoC with some ethernet ports with driver A
>> > Switch chip with N ports with driver B
>> > EEC/DPLL with driver C
>> > Both SoC and Switch ASIC can recover clock and use the cleaned
>> > clock from the DPLL.
>> >
>> > In that case you can't create any relation between EEC and recover
>> > clock pins that would enable the EEC subsystem to control
>> > recovered clocks, because you have 3 independent drivers.
>> 
>> I think that in that case you have several EEC instances. Those are
>> connected by some wiring that is external to the devices themselves. I
>> am not sure who should be in charge of describing the wiring. Device
>> tree? Config file?
>
> In some complex systems you'll need to create a relation between
> netdevs and DPLLs in a config file, so it is the only way to describe
> all possible scenarios. We can't assume any connections between them,
> as that's design specific, just like PTP pins are. They have labels,
> but it's up to the system integrator to define how they are used. We
> can consider creating some of them if they are known to the driver and
> belong to the same driver.

Agreed.

>> > The model you proposed assumes that the MAC/Switch is in
>> > charge of the DPLL, but that's not always true.
>> 
>> The EEC-centric model does not in fact assume that. It lets anyone to
>> set up an EEC object.
>> 
>> The netdev-centric UAPI assumes that the driver behind the netdev
>> knows about how many RCLK out pins there are. So it can certainly
>> instantiate a DPLL object instead, with those pins as external pins,
>> and leave the connection of the external pins to the EEC proper
>> implicit.
>
> Netdev will know how many RCLK outputs are there, as that's the
> function of a given MAC/PHY/Retimer.

So... spawn a DPLL with that number of virtual pins?

>> That gives userspace exactly the same information as the
>> netdev-centric UAPI, but now userspace doesn't need to know about
>> netdevs, and synchronously-spinning drives, and GPS receivers, each
>> of which is handled through a dedicated set of netlink messages /
>> sysctls / what have you. The userspace needs to know about EEC
>> subsystem, and that's it.
>
> I believe the direction is to make the connection between a netdev and
> its related DPLL that's serving as EEC in a similar way the link to a
> PTP device is created. Userspace app will need to go to DPLL subsystem
> to understand what's the current frequency source for a given netdev.

But the way PTP and netdevs are linked is that PTP clock is instantiated
independently, and then this clock is referenced by the netdevice. I do
not object to that at all, in fact I believe I mentioned this a couple
times already.

I'm objecting to accessing the PTP clock _through_ the netdev UAPI.
Because, how will non-NIC-bound DPLLs be represented? Well, through some
other UAPI, obviously. So userspace will need to know about all classes
of devices that can carry frequency signal.

Alternatively, both NIC drivers and other drivers can instantiate some
common type of DPLL-related object. Then any userspace tool that knows
how to work with objects of that type automatically knows how to handle
NICs, and GPSs, and whatever craziness someone dreams up.

> That's still independent uAPI from the one defined by those patches.
>
>> > The model where recovered clock outputs are controlled independently
>> > can support both models and is more flexible. It can also address the
>> 
>> - Anyone can instantiate EEC objects
>> - Only things with ports instantiate netdevs
>> 
>> How is the latter one more flexible?
>
> - Everything can instantiate DPLL object,
> - Only a netdev can instantiate recovered clock outputs, which can be
>   connected to any other part of the system - not only a DPLL.

If the frequency source devices are truly so different from the general
DPLL circuits that thay cannot possibly be expressed as the same type of
object, then by all means, represent them as something else. DPLL
frequency source, whatever.

But don't hide the API behind netdevs just because some NICs carry
DPLLs. Non-NIC frequency sources do exist, and the subsystem should
support them _in the same way_ as the NIC ones.

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E0B04B5414
	for <lists+netdev@lfdr.de>; Mon, 14 Feb 2022 16:02:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230297AbiBNPBm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Feb 2022 10:01:42 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:34466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349841AbiBNPBm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Feb 2022 10:01:42 -0500
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam08on2081.outbound.protection.outlook.com [40.107.102.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 857004D26B
        for <netdev@vger.kernel.org>; Mon, 14 Feb 2022 07:01:27 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RJxsOQZ5FaqKeqW0VdzU+kcpoGQGcP9OhQh7AhNx8xMtlmzfuVkjSBbrX2TZ+TBdR9CxExEisAL08+3+6Izjw15TiJRaYqQjHlxwsTNYbQ2pfj/0BY6mig+FvyPjN+ewDQovkSfy3HEUugiYkiMBG3NDG5xOYvGg7eJNmCzkh7EM2htIpSawgkDPOJXrpBFfYz0FDbYT4o/P5rf2gcE9QD5AI43bsRnUBFAE+nenYzsjT17yGY92EqnI+IJu3MXjOVPBX3BgwqL8K8rtIu13Fezj5nUXu0VpROcdZ9fAcb7C9XGD8gYXy2ojISSowyevGH9u3kGyINVRMk5raxzmlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JMB5Xo6/VSaxEzMe3i/b4eWDkQFpQm+oMs0LPhvF3YM=;
 b=Zd9pejd4OrvGABP0P7R4EjAiCQg54gy4Y9pfXdCVs1Y+sttOeDtsg87A84rJyHvaQ92ROHSEqNNjihvU6AtCz6Uxp4z2/UX4TJt3yXf7qDQn7c5IYmZPetxR+dHd/tCUzf/f1vnhUzg14n0MoBGhYNueHo89UKMHCWdkpdsxFbhEnqXLdpPLXJenMQvvgSjzuXScZNf066KlPZPimw/5r/FnlThxDEa0YwIR0PChtLoija4d8lDVBPeW/zuVtbcfkBGt5KIfnZ2GCvf6RH06YOU80jU1iCrEOAH9o5ybuIAUUQpdUfpCZ+TGo4VA4RimcquYCcvCunMO6kgjvR0Y9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JMB5Xo6/VSaxEzMe3i/b4eWDkQFpQm+oMs0LPhvF3YM=;
 b=bs1B/+l11xvwC0r0+qyDTH3KTbkonNHu7hUZyVW0YJLWRwWrpqt97lJG6Y0jhJWq7uk8RhyGJyQlj18DHrDF18ph38AisbTp3zQW7W3/0lfofqcWGBMDVlzhhl5mJkq8N24DkKrWDfMFnBm2sItIfFy5ciPB3IV1Xk5+DnLoyJcGS9rJVwlINrecly+tLZGTXob0sFRb5FhyesX2nZjjK56yDd1u6OVlMZjwjvlRL6vsvfYfhR+dyse+tnjQAkNJOfMWkIcKWTa9Y6TK1L1U0pYN6BiqEopHBv8Q/f9sQmuGGoCIgM2kLPn5i0TzsVQoxR68DNSFaWpCw/kJPThang==
Received: from DS7PR07CA0010.namprd07.prod.outlook.com (2603:10b6:5:3af::29)
 by BN6PR12MB1331.namprd12.prod.outlook.com (2603:10b6:404:17::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.11; Mon, 14 Feb
 2022 15:01:25 +0000
Received: from DM6NAM11FT054.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3af:cafe::f9) by DS7PR07CA0010.outlook.office365.com
 (2603:10b6:5:3af::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.14 via Frontend
 Transport; Mon, 14 Feb 2022 15:01:25 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.234) by
 DM6NAM11FT054.mail.protection.outlook.com (10.13.173.95) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4975.11 via Frontend Transport; Mon, 14 Feb 2022 15:01:23 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 14 Feb
 2022 15:01:23 +0000
Received: from [172.27.14.193] (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Mon, 14 Feb 2022
 07:01:16 -0800
Message-ID: <c1ce21c6-1d9c-90f3-fef0-b023730bf271@nvidia.com>
Date:   Mon, 14 Feb 2022 17:01:13 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [RFC PATCH net-next 0/5] Replay and offload host VLAN entries in
 DSA
Content-Language: en-US
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
CC:     Ido Schimmel <idosch@idosch.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Roopa Prabhu <roopa@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Rafael Richter <rafael.richter@gin.de>,
        Daniel Klauer <daniel.klauer@gin.de>,
        "Tobias Waldekranz" <tobias@waldekranz.com>
References: <20220209213044.2353153-1-vladimir.oltean@nxp.com>
 <7b3c0c29-428b-061d-8a30-6817f0caa8da@nvidia.com>
 <20220213200255.3iplletgf4daey54@skbuf>
 <ac47ea65-d61d-ea60-287a-bdeb97495ade@nvidia.com> <Ygon5v7r0nerBxG7@shredder>
 <20220214100729.hmnsvwkmp4kmpqwt@skbuf>
 <fb06ccb9-63ab-04ff-4016-00aae3b0482e@nvidia.com>
 <20220214104217.5asztbbep4utqllh@skbuf>
 <bee3d33c-1c66-2234-2be2-f0a279bafc42@nvidia.com>
 <20220214120427.gngyotzetmj6b3c2@skbuf>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
In-Reply-To: <20220214120427.gngyotzetmj6b3c2@skbuf>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail201.nvidia.com (10.129.68.8) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 01afdb15-ac9b-4c11-59f6-08d9efcade65
X-MS-TrafficTypeDiagnostic: BN6PR12MB1331:EE_
X-Microsoft-Antispam-PRVS: <BN6PR12MB1331EED5EEDEE4A2F806A95BDF339@BN6PR12MB1331.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mIXbKh5rd/Gp0fe3NVNwwKLgnKoo1seGDlBWnXsSEW19Vfxtpjc7d+cU6mygOpPZs6J2SVTqZIJXxcUDOCvk2C6vyK7vUj8gGUg/9IR65e7Lt/kL+X7p16qfPXp6lWmWpdi7HD0kdhwfJ884+BkpjOwAIaGhoJKptsp69wThozVeDQBwwOubbLEhG9tDRRDkrZ9dvXkIES2pGCZgKgbrEAe17YTyD8wQLsmVx8iVDxJOj7P+VxccM8xQhzhRclPfwZcTeDqiPsPFhzXGs3/GWG0HbggcswVFNu/KQZDmW9fnk5DIiavtkVBlMdfWdWgZdV+NJAkMA/M8a9Y72wZCTo/anTrF09D6q2pxfqb0cWUNW95I8Z4Xang0OnDf5LGwOOrxgH4hva8nCdC2RWN2v2eJyhW0a88szpQ7zT/Pmzcmag96UhisAs0Nhe6ndWRLlLTU229CSCDLvVmMOhozUd1IUJV2syWMfuLQG+nLbnLdjG6XlmVtskyEcHTCwJUkXEJlp833PaaC6Zka8RZCDEDvVp7qEbrasn76liFb5+FJI8rAFUbJHw3/t/XIxsJc47QbmPCZVRyPVbUhXmf0aQqUIiDJljtc7vYJ66WSbLrVMYdNvaNvVmuMxkZJ5NlEK2OB3WbWbJeD7M7NnkoDvT4+En5v5KFwvA5JSu1XYro+niE/lOyYtVyAeKjT5Ww7DSr5Vlwuj8loTxHmzLjHEDTxiHA6JMTo6V9eHKtZ2GXB3TWx0qhFtcX9oVV9Uc1e
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(46966006)(40470700004)(36860700001)(82310400004)(2906002)(316002)(16576012)(6916009)(81166007)(8676002)(4326008)(70586007)(70206006)(356005)(54906003)(31696002)(40460700003)(508600001)(8936002)(7416002)(16526019)(5660300002)(83380400001)(26005)(53546011)(31686004)(186003)(86362001)(336012)(2616005)(426003)(47076005)(36756003)(6666004)(36900700001)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Feb 2022 15:01:23.9971
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 01afdb15-ac9b-4c11-59f6-08d9efcade65
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT054.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR12MB1331
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 14/02/2022 14:04, Vladimir Oltean wrote:
> On Mon, Feb 14, 2022 at 01:11:01PM +0200, Nikolay Aleksandrov wrote:
>> On 14/02/2022 12:42, Vladimir Oltean wrote:
>>> On Mon, Feb 14, 2022 at 12:27:57PM +0200, Nikolay Aleksandrov wrote:
>>>> On 14/02/2022 12:07, Vladimir Oltean wrote:
>>>>> On Mon, Feb 14, 2022 at 11:59:02AM +0200, Ido Schimmel wrote:
>>>>>> Sounds good to me as well. I assume it means patches #1 and #2 will be
>>>>>> changed to make use of this flag and patch #3 will be dropped?
>>>>>
>>>>> Not quite. Patches 1 and 2 will be kept as-is, since fundamentally,
>>>>> their goal is to eliminate a useless SWITCHDEV_PORT_OBJ_ADD event when
>>>>> really nothing has changed (flags == old_flags, no brentry was created).
>>>>>
>>>>
>>>> I don't think that's needed, a two-line change like
>>>> "vlan_already_exists == true && old_flags == flags then do nothing"
>>>> would do the trick in DSA for all drivers and avoid the churn of these patches.
>>>> It will also keep the order of the events consistent with (most of) the rest
>>>> of the bridge. I'd prefer the simpler change which avoids config reverts than
>>>> these two patches.
>>>
>>> I understand you prefer the simpler change which avoids reverting the
>>> struct net_bridge_vlan on error, but "vlan_already_exists == true &&
>>> old_flags == flags then do nothing" is not possible in DSA, because DSA
>>> does not know "old_flags" unless we also pass that via
>>> struct switchdev_obj_port_vlan. If we do that, I don't have much of an
>>> objection, but it still seems cleaner to me if the bridge didn't notify
>>> switchdev at all when it has nothing to say.
>>>
>>> Or where do you mean to place the two-line change?
>>
>> You mention a couple of times in both patches that you'd like to add dsa
>> vlan refcounting infra similar to dsa's host fdb and mdb. So I assumed that involves
>> keeping track of vlan entries in dsa? If so, then I thought you'd record the old flags there.
>>
>> Alternatively I don't mind passing old flags if you don't intend on keeping
>> vlan information in dsa, it's uglier but it will avoid the reverts which will
>> also avoid additional notifications when these cases are hit. It makes sense
>> to have both old flags and new flags if the switchdev checks are done pre-config
>> change so it can veto any transitions it can't handle for some reason.
>>
>> A third option is to do the flags check in the bridge and avoid doing the
>> switchdev call (e.g. in br_switchdev_port_vlan_ calls), that should avoid
>> the reverts as well.
>>
>> If you intend to add vlan refcounting in dsa, then I'd go with just keeping track
>> of the flags, you'll have vlan state anyway, otherwise it's up to you. I'm ok
>> with both options for old flags. 
> 
> I understand it can be confusing why DSA needs to keep VLAN refcounting
> yet it doesn't keep track of flags, so let me explain.
> 
> First thing to mention is that VLAN flags on CPU and DSA (cascade) ports
> don't make much sense at the level of the DSA core. These ports are
> really pipes that transport packets between switches and between the
> switch and the CPU, so 'pvid' and 'untagged' don't really make sense.
> An unwritten convention is for DSA hardware drivers to program the CPU
> and DSA ports such that the VLAN information is unmodified w.r.t. how it
> was/will be on the wire. The only important aspect about VLAN on DSA and
> CPU ports is the VID membership list.
> 
> This isn't the major reason, though, so secondly, I need to introduce a topology.
> 
>                eth0                                           eth1
>            (DSA master)                                (foreign interface)
>                 |
>                 |
>                 | CPU port (no netdev)
>         +----------------+
>         |     sw0p0      |
>         |                |
>         |    Switch 0    |
>         |                |
>         | sw0p0   sw0p1  |
>         +----------------+
>             |       | DSA/cascade port (no netdev)
>             |       |
>             |       |
>             |       | DSA/cascade port (no netdev)
>             |    +--------------+
>             |    | sw1p0        |
>             |    |              |
>             |    |   Switch 1   |
>             |    |              |
>             |    |sw1p1  sw1p2  |
>             |    +--------------+
>  user port  |       |      |
> (has netdev)   user port  user port
> 
> -----------------------------------------------------------
> 
> Example 1: you want forwarding in VLAN 100 between sw0p0, sw1p1 and
> sw1p2, so you issue these commands:
> 
> ip link add br0 type bridge vlan_filtering 1
> ip link set sw0p0 master br0 && bridge vlan add dev sw0p0 vid 100
> ip link set sw1p1 master br0 && bridge vlan add dev sw1p1 vid 100
> ip link set sw1p2 master br0 && bridge vlan add dev sw1p2 vid 100
> 
> DSA must figure out that the sw0p1 and sw1p0 (the cascade ports
> interconnecting the 2 switches) must also be members of VID 100.
> So it must privately add each cascade port of a switch to this VID,
> as long as a user port of that switch is in VID 100.
> 
> So the refcounting must be kept on the destination of where those VLANs
> are programmed (the cascade ports), not on the sources of where those
> VLANs came from (the user ports).
> 
> In this example, sw0p1 and sw1p0 will be members of VID 100 and will
> have a refcount of 3 on it (it is needed by 3 user ports).
> 
> -----------------------------------------------------------
> 
> Example 2: you figure out that sw1p2 should in fact be pvid untagged in
> VID 100, so you change that:
> 
> bridge vlan add dev sw1p2 pvid untagged
> 
> DSA doesn't care about a change of flags, so it needs to change nothing
> about the DSA ports. It just needs to pass on the notification of the
> change of flags to the device driver for sw1p2.
> 
> -----------------------------------------------------------
> 
> Example 3: you realize that you know what, you don't want sw1p2 to be a
> member in VID 100 at all:
> 
> bridge vlan del dev sw1p2 vid 100
> 
> DSA must decrement the refcount of VID 100 on sw0p1 and sw1p0 from 3 to 2.
> 
> -----------------------------------------------------------
> 
> Example 4: you want local termination in VID 100 for this bridge, so you do:
> 
> bridge vlan add dev br0 vid 100 self
> 
> To ensure local termination works for all DSA user ports that are
> members of the bridge (sw0p0, sw1p1), DSA must ensure that the CPU port
> and the DSA ports towards it are members of VID 100.
> 
> So sw0p0 joins VID 100 with a refcount of 1, while sw0p1 and sw1p0 just
> bump the refcount again from 2 to 3.
> 
> -----------------------------------------------------------
> 
> Example 5: you actually want to forward in VID 100 to a foreign
> interface as well:
> 
> ip link set eth1 master br0 && bridge vlan add dev eth1 vid 100
> 
> DSA must bump the refcount of VID 100 on sw0p0 (the CPU port) from 1 to 2,
> and for the cascade ports from 3 to 4. This is such that, if we decide
> that we no longer want local termination (example 4), VID 100 is not
> removed on those ports. Local termination vs software forwarding is
> identical from DSA's perspective, but different from the stack's perspective.
> 
> 
> The way this worked until now was by an approximation that held quite
> honorably more often than not: whenever a bridge VLAN is added to a user
> port, just add it to all DSA and CPU ports too, and never remove it.
> However, it gets quite limiting.
> 
> 
> 
> So the way in which VLAN membership on CPU and DSA ports is refcounted
> makes it not really practical to keep original flags of each VLAN on
> each source port it came from. Your suggestion of keeping each vlan->flags
> in DSA practically boils down to keeping an entire copy of the bridge
> VLAN database. I hope it's clearer now why it isn't really the path I
> would like to follow.
> 

I see, thank you for the examples and the detailed explanation.

> I can look into pruning useless calls in br_switchdev_port_vlan_add()
> itself, if that's what you prefer. Before looking closer at the code,
> that's what I originally had in mind, but it would pollute all callers
> of that function, since we'd have to provide a "bool existing" +
> "u16 old_flags" set of extra arguments to it, and most call paths would
> pass "false, 0". When I noticed that the call paths I'm interested in
> already compute "bool changed" based on __vlan_add_flags(), I thought it
> would be a bit redundant to duplicate logic from that function.
> Just reorder the call to __vlan_add_flags() and I have the info I need.

You already have to add "existing", so I don't see why not add
old flags as well. As I mentioned it makes sense to have it for pre-config
veto of unsupported state transitions. I think it will be simpler and
we'll avoid the config reverts and more notifications.

Cheers,
 Nik


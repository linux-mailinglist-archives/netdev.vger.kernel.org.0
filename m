Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C17224A8807
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 16:52:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351979AbiBCPwL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 10:52:11 -0500
Received: from mail-bn7nam10on2066.outbound.protection.outlook.com ([40.107.92.66]:55968
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229481AbiBCPwK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Feb 2022 10:52:10 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Zicus8qDgwBm9PeVtqhwzXZqhkWcv6QQuzTk9eD/2XkN9rQLSDbuzso4J3jOFeKJX7w6oSB1duZxBJtaUPGF29RmpihW7Dx1yKiaNKtnGEmDFoqUnsyA6phG/E6UKgEpG6YlGweVlETZRJhoqsgFLEv2Y2a9D6zBOGobZWdVZTgUCn/NOEN39FAav/S53HXp9XKnnoaVu2ZctpG7+20DX9gvyWcmeiT6EaOYhE0aus5jnQTGOFY9ALGcHidWZbeyrL+prePwgFrdwM1gHrT1/g8nx+gboAmYr0q7VIbN9/WILodCRRIWxLLLn4D4LFezORvwDmVCbxfCYuTWb245BQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1a9p+u/4F181PxbBD/GA20PdcZKdAQybku7/q3NTYCU=;
 b=MZpni/hWU1sesbmi37Hby+3JsmLk3By2AwzwXb/PAZlwI9xYiXUol3X2MWAhuJ3o3HAZlVP54MnjX//Kvy5p1fnrGiaMnHHmBlwx9yhZWAAFDwvQ/uncRBJ82fEpf6gCnAPSEQp4smAxrus8cV1bnwl+ULDFv9LedCS/gvQLnzgl8GYuVWPHulg/gIMhhxJQrB4BZ/wXY6EX42a/Ip/MU/Z1HXFsJCbU7AuvgrzaUSp30DL4uuBiSUj+tBx3yoVfhOraSRw56ty+DVfpuyYFlumuhfNSFBwDU/OpiBnNWwh8zf1xtCGEFJmGw5jw1G2tVjf133mrVyslOb8EE6+rhg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1a9p+u/4F181PxbBD/GA20PdcZKdAQybku7/q3NTYCU=;
 b=RqyHbf1WAXxWGEqzXiWloK0vX+AP76vcRsmId6lv5ZLW4NC6Hl6/xWqEBpR0QODsNDlmKkfO1dRzBBxHhRrVNuhzYPSqKhP5PvVXl8sf214QRbh66CPEFTcvuqLFUpZ4GbSJs75LHvSmcVp4vHWc2YQnMi71jetJUU1T8T/e6o/uFr31F3ibRuZk4KwsS+LUYrnazTYbAtYIMZDze1ahnuR9gFXVkJcBgN68R7by/w7/UvWWZSXP45YVD013Eu3441xZC/dJmc7BALwBsuFcoVbR+gYkhvt6vZdybY7DDomAXcDzraWIdZD0dR3OqCgDawVq9taqgU8oNov8tI3AqA==
Received: from DM5PR12CA0018.namprd12.prod.outlook.com (2603:10b6:4:1::28) by
 MW3PR12MB4522.namprd12.prod.outlook.com (2603:10b6:303:5f::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4930.18; Thu, 3 Feb 2022 15:51:58 +0000
Received: from DM6NAM11FT068.eop-nam11.prod.protection.outlook.com
 (2603:10b6:4:1:cafe::9b) by DM5PR12CA0018.outlook.office365.com
 (2603:10b6:4:1::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.11 via Frontend
 Transport; Thu, 3 Feb 2022 15:51:58 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.236) by
 DM6NAM11FT068.mail.protection.outlook.com (10.13.173.67) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4951.12 via Frontend Transport; Thu, 3 Feb 2022 15:51:57 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 3 Feb
 2022 15:51:57 +0000
Received: from [10.40.103.223] (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Thu, 3 Feb 2022
 07:51:52 -0800
Message-ID: <7fc4c60f-f7cd-6f02-7824-2d79871acb5d@nvidia.com>
Date:   Thu, 3 Feb 2022 21:21:49 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
Subject: Re: [PATCH V6 mlx5-next 08/15] vfio: Define device migration protocol
 v2
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>
CC:     Yishai Hadas <yishaih@nvidia.com>, <bhelgaas@google.com>,
        <saeedm@nvidia.com>, <linux-pci@vger.kernel.org>,
        <kvm@vger.kernel.org>, <netdev@vger.kernel.org>, <kuba@kernel.org>,
        <leonro@nvidia.com>, <kwankhede@nvidia.com>,
        <mgurtovoy@nvidia.com>, <maorg@nvidia.com>,
        "cjia@nvidia.com" <cjia@nvidia.com>
References: <20220130160826.32449-1-yishaih@nvidia.com>
 <20220130160826.32449-9-yishaih@nvidia.com>
 <20220131164318.3da9eae5.alex.williamson@redhat.com>
 <20220201003124.GZ1786498@nvidia.com>
 <20220201100408.4a68df09.alex.williamson@redhat.com>
 <20220201183620.GL1786498@nvidia.com>
 <20220201144916.14f75ca5.alex.williamson@redhat.com>
 <20220202002459.GP1786498@nvidia.com>
From:   "Tarun Gupta (SW-GPU)" <targupta@nvidia.com>
In-Reply-To: <20220202002459.GP1786498@nvidia.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail201.nvidia.com (10.129.68.8) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2204b3b6-2b18-4061-dbec-08d9e72d1c13
X-MS-TrafficTypeDiagnostic: MW3PR12MB4522:EE_
X-Microsoft-Antispam-PRVS: <MW3PR12MB4522973F5EF2088484DFBDA1B8289@MW3PR12MB4522.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2512;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WFjd2uSMa1pWjSL8DT+nspnSQZ9YGeYNRZ5fA7KzkdFsFUB/WDd4CHaobeTzeiDSzkxE8MX64YT5rTBOvp6ImFN0J6c1V6Cv/WMHJXdXzLVPfzaqOMDftEUKIFrADe48vc/NJpJpWgBKRrDSzkt4NIdhBSmwn9pA//3eeC+cs+CF9vMQ2uH1qz5V0k3+wSj2PcE9Pr9ubYGybguF+XyHP/8rsQyFZTIiYqGILPPrGnuYnD1IAv4/SNLfuRiPUc7ZzqnwqoIo2v+yQDyagtnCmZa8w8Qzi4mj7TY0Yl9gOwWmU44x7B0cVs3WesefDFIGBRHCQehe0q2NmA7F7Q9naVDfltkAq3uniyNtjWjSMOEEl3glb9pbGKVLtja+NsjUPbIo6lJPnCl/B0FtHsctxA1ZWrJtM0JGQFVNQAAmSoPjpXi1Ppss9ze6q0u5LWRakH8Tk78HhNH1Mv2LjGKUUNrnynLdDiyDPBLNmXZ6/AdZpFNmmDEePMNbArgHBJK6Il5mwQXa69CmKcK1L5oKcV1puhrDiBPhCGRgv2AosdKAwk3deC0B4lrZrZVDYbiBXgYrTHKRN4S0LUOX5jUbepeGvgur6/3kdqFfXc2XW3NtER+HRrdWK40J8WtJG4QkYm4Keu+pIRvrer9BT7fekCJiIeFb+m7VfrGGobEQ8jXio0ucPCEzXBWG/H4ximqW2Exh/HgGugVsrhHWubYazIKK+WfEt0BqD21tg7ojkfbL6MP8KVDOgjJW4BE4tUNbGiUCjBeYnXPlsG9ovn4yPg==
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(40470700004)(46966006)(5660300002)(508600001)(8936002)(4326008)(36860700001)(8676002)(83380400001)(81166007)(54906003)(31696002)(86362001)(47076005)(36756003)(2906002)(2616005)(31686004)(336012)(107886003)(53546011)(82310400004)(70586007)(356005)(16526019)(316002)(426003)(186003)(16576012)(26005)(40460700003)(110136005)(6666004)(70206006)(21314003)(36900700001)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Feb 2022 15:51:57.8994
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2204b3b6-2b18-4061-dbec-08d9e72d1c13
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT068.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4522
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/2/2022 5:54 AM, Jason Gunthorpe wrote:
> External email: Use caution opening links or attachments
> 
> 
> On Tue, Feb 01, 2022 at 02:49:16PM -0700, Alex Williamson wrote:
>> On Tue, 1 Feb 2022 14:36:20 -0400
>> Jason Gunthorpe <jgg@nvidia.com> wrote:
>>
>>> On Tue, Feb 01, 2022 at 10:04:08AM -0700, Alex Williamson wrote:
>>>
>>>> Ok, let me parrot back to see if I understand.  -ENOTTY will be
>>>> returned if the ioctl doesn't exist, in which case device_state is
>>>> untouched and cannot be trusted.  At the same time, we expect the user
>>>> to use the feature ioctl to make sure the ioctl exists, so it would
>>>> seem that we've reclaimed that errno if we believe the user should
>>>> follow the protocol.
>>>
>>> I don't follow - the documentation says what the code does, if you get
>>> ENOTTY returned then you don't get the device_state too. Saying the
>>> user shouldn't have called it in the first place is completely
>>> correct, but doesn't change the device_state output.
>>
>> The documentation says "...the device state output is not reliable", and
>> I have to question whether this qualifies as a well specified,
>> interoperable spec with such language.  We're essentially asking users
>> to keep track that certain errnos result in certain fields of the
>> structure _maybe_ being invalid.
> 
> So you are asking to remove "is not reliable" and just phrase is as:
> 
> "device_state is updated to the current value when -1 is returned,
> except when these XXX errnos are returned?
> 
> (actually userspace can tell directly without checking the errno - as
> if -1 is returned the device_state cannot be the requested target
> state anyhow)
> 
>> Now you're making me wonder how much I care to invest in semantic
>> arguments over extended errnos :-\
> 
> Well, I know I don't :) We don't have consistency in the kernel and
> userspace is hard pressed to make any sense of it most of the time,
> IMHO. It just doesn't practically matter..
> 
>>> We don't know the device_state in the core code because it can only be
>>> read under locking that is controlled by the driver. I hope when we
>>> get another driver merged that we can hoist the locking, but right now
>>> I'm not really sure - it is a complicated lock.
>>
>> The device cannot self transition to a new state, so if the core were
>> to serialize this ioctl then the device_state provided by the driver is
>> valid, regardless of its internal locking.
> 
> It is allowed to transition to RUNNING due to reset events it captures
> and since we capture the reset through the PCI hook, not from VFIO,
> the core code doesn't synchronize well. See patch 14
> 
>> Whether this ioctl should be serialized anyway is probably another good
>> topic to breach.  Should a user be able to have concurrent ioctls
>> setting conflicting states?
> 
> The driver is required to serialize, the core code doesn't touch any
> global state and doesn't need serializing.
> 
>> I'd suggest that ioctl return structure is only valid at all on
>> success and we add a GET interface to return the current device
> 
> We can do this too, but it is a bunch of code to achieve this and I
> don't have any use case to read back the device_state beyond debugging
> and debugging is fine with this. IMHO
> 
>> It's entirely possible that I'm overly averse to ioctl proliferation,
>> but for every new ioctl we need to take a critical look at the proposed
>> API, use case, applicability, and extensibility.
> 
> This is all basicly the same no matter where it is put, the feature
> multiplexer is just an ioctl in some semi-standard format, but the
> vfio pattern of argsz/flags is also a standard format that is
> basically the same thing.
> 
> We still need to think about extensibility, alignment, etc..
> 
> The problem I usually see with ioctls is not proliferation, but ending
> up with too many choices and a big ?? when it comes to adding
> something new.
> 
> Clear rules where things should go and why is the best, it matters
> less what the rules actually are IMHO.
> 
>>> I don't want to touch capabilities, but we can try to use feature for
>>> set state. Please confirm this is what you want.
>>
>> It's a team sport, but to me it seems like it fits well both in my
>> mental model of interacting with a device feature, without
>> significantly altering the uAPI you're defining anyway.
> 
> Well, my advice is that ioctls are fine, and a bit easier all around.
> eg strace and syzkaller are a bit easier if everything neatly maps
> into one struct per ioctl - their generator tools are optimized for
> this common case.
> 
> Simple multiplexors are next-best-fine, but there should be a clear
> idea when to use the multiplexer, or not.
> 
> Things like the cap chains enter a whole world of adventure for
> strace/syzkaller :)
> 
>>> You'll want the same for the PRE_COPY related information too?
>>
>> I hadn't gotten there yet.  It seems like a discontinuity to me that
>> we're handing out new FDs for data transfer sessions, but then we
>> require the user to come back to the device to query about the data its
>> reading through that other FD.
> 
> An earlier draft of this put it on the data FD, but v6 made it fully
> optional with no functional impact on the data FD. The values decrease
> as the data FD progresses and increases as the VM dirties data - ie it
> is 50/50 data_fd/device behavior.
> 
> It doesn't matter which way, but it feels quite weird to have the main
> state function is a FEATURE and the precopy query is an ioctl.
> 
>> Should that be an ioctl on the data stream FD itself?
> 
> I can be. Implementation wise it is about a wash.
> 
>> Is there a use case for also having it on the STOP_COPY FD?
> 
> I didn't think of one worthwhile enough to mandate implementing it in
> every driver.
> 
>>> If we are into these very minor nitpicks does this mean you are OK
>>> with all the big topics now?
>>
>> I'm not hating it, but I'd like to see buy-in from others who have a
>> vested interest in supporting migration.  I don't see Intel or Huawei
>> on the Cc list and the original collaborators of the v1 interface
>> from
> 
> That is an oversight, I'll ping them. I think people have been staying
> away until the dust settles.
> 
>> NVIDIA have been silent through this redesign.
> 
> We've reviewed this internally with them. They reserve judgement on
> the data transfer performance until they work on it, but functionally
> it has all the necessary semantics.
> 

Yes, we're reviewing the proposal from vGPU point of view and will 
update here once we have it figured out for vGPU.

Thanks,
Tarun

> They have the same P2P issue mlx5 does, and are happy with the
> solution under the same general provisions as already discussed for
> the Huawei device - RUNNING_P2P is sustainable only while the device
> is not touched - ie the VCPU is halted.
> 
> The f_ops implemenation we used for mlx5 is basic, the full
> performance version would want to use the read/write_iter() fop with
> async completions to support the modern zero-copy iouring based data
> motion in userspace. This is all part of the standard FD abstraction
> and why it is appealing to use it.
> 
> Thanks,
> Jason

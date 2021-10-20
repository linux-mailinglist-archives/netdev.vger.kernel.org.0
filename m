Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A99E34346DF
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 10:28:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229900AbhJTIab (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 04:30:31 -0400
Received: from mail-dm6nam11on2064.outbound.protection.outlook.com ([40.107.223.64]:5985
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229503AbhJTIaa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Oct 2021 04:30:30 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lLb6kIp1UP+yqY/HMYGSNOk69YzG/ZkOW4yx3+jeVp/ibjsbOwjNxIP+2qK9RsbjvpO2OtzHNEkq7tFG6K94ejFsUPIrOoHlwsOdi7xImthiO2ekKyfqGcgFrnuW0EVdRN9umuHz/bJl4KpqlLzQmCEDfG9+qRQAGpuOQ8Rmv7EC2aPA8m3K60/6OLOopJCnaPbHCZAdsO2OuiLkcjffzLI+k/mklSXFzUxQ9RCdw3jJaeK9MWsHOTzLYom9b1adj9GDmpivURyuul0YVoAQ5vcQvUW7t3nnUALgV4BHOoewTmU7CG4qQLiu+DjrfoCl97TjjeE6iT6jpdaz2cZRig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CW/ote3WFl4itqrDc26KbutDFzbrUX4Y+zujR8l+sqM=;
 b=GK2MkniMdzResZQDcaBjgNZZoW1D5Xzgiz1GGhUNhNKwPWMGHfSuDBGRHEQ2l/RqPovhHhD38dvpZadW8V1Dqlpm+ISxRoirzidyqsApV8n5s6szRv5aaNuv5o16FTGepiaf7YY/lRtXnZo9GwuSeFyLj4jGCrmC93vftSnIvMTgYjNx+c4PjZKKq3WodBEFE56hrRfht4igJlDDAZXPgb+gTMm4cXx3IfBol/uYfayehv7+g4WSnzFf5CL/D/U2caeDgvuwVn0UQtSnbmBo1b8nUhMf7xy0Rqg7WnRpdP9x1jWEQCceBrtNZH8ahwQAhsDPgDI5yRyxyt87gWmCnA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CW/ote3WFl4itqrDc26KbutDFzbrUX4Y+zujR8l+sqM=;
 b=cTQ58PcQNr2268KwT+bKFNEp42adjOK/bPWkHk0U7y45X2L2sBG0gEUH+6UsA6KjLBivT+1q9SLVpFeAxl/slb4vYA4mVPWNRg4CjtFk5bzgHrsMLScvkbeqnV+cQiTPCW7+NvftCg5pLIOwXWmFHCarUJ70usgWOfEhm990GO5tkhXFq0n8P54XeG/euE0RfWqOyvP8ePHVJ+z0nOiThf7lb2V/RtmuC9By5C1bcyPCY7VA8oLhhPD00HR2E8nE8fHxsKn4DbC5OaI180PLB5W06z1a0ykopjKp+ehJUy+F9Y6jehe9f3gTZMwf25u80lHTBw4p7a7rbXmfzkPyyA==
Received: from DM6PR10CA0021.namprd10.prod.outlook.com (2603:10b6:5:60::34) by
 SA0PR12MB4510.namprd12.prod.outlook.com (2603:10b6:806:94::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4608.17; Wed, 20 Oct 2021 08:28:15 +0000
Received: from DM6NAM11FT024.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:60:cafe::e3) by DM6PR10CA0021.outlook.office365.com
 (2603:10b6:5:60::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.18 via Frontend
 Transport; Wed, 20 Oct 2021 08:28:15 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT024.mail.protection.outlook.com (10.13.172.159) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4628.16 via Frontend Transport; Wed, 20 Oct 2021 08:28:14 +0000
Received: from [172.27.15.75] (172.20.187.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 20 Oct
 2021 08:28:06 +0000
Subject: Re: [PATCH V2 mlx5-next 12/14] vfio/mlx5: Implement vfio_pci driver
 for mlx5 devices
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>
CC:     <bhelgaas@google.com>, <saeedm@nvidia.com>,
        <linux-pci@vger.kernel.org>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>, <leonro@nvidia.com>,
        <kwankhede@nvidia.com>, <mgurtovoy@nvidia.com>, <maorg@nvidia.com>
References: <20211019105838.227569-1-yishaih@nvidia.com>
 <20211019105838.227569-13-yishaih@nvidia.com>
 <20211019124352.74c3b6ba.alex.williamson@redhat.com>
 <20211019192328.GZ2744544@nvidia.com>
 <20211019145856.2fa7f7c8.alex.williamson@redhat.com>
 <20211019230431.GA2744544@nvidia.com>
From:   Yishai Hadas <yishaih@nvidia.com>
Message-ID: <5a496713-ae1d-11f2-1260-e4c1956e1eda@nvidia.com>
Date:   Wed, 20 Oct 2021 11:28:04 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211019230431.GA2744544@nvidia.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [172.20.187.6]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1f9b5e43-2916-4a30-65d8-08d993a38fb3
X-MS-TrafficTypeDiagnostic: SA0PR12MB4510:
X-Microsoft-Antispam-PRVS: <SA0PR12MB451015C9F46FB90EDAB7C210C3BE9@SA0PR12MB4510.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3aXvfHQprVqVpH/cK5ZWpKk7kuO2r/Kza1NG+nw5U9GnRoqqa/CGVhWS4nHeYb/aiFrcBHX8BgUrJn0WuH99RbdrWW65MtP/9d3eMJQ8YmfiK2ZvbJk/TfzNxwP+sUakEKNdR6RndS0OMd+1uxAfEhrCe0c8LxQ10DQnj1AJuOfG8wSp+Ixl9+PsQoWUHvJWJYqNTaRGCyli4BZn6gi4Qzu95kxr3RFz08qYcQJomrumkbtMvdIltV1w/NegyNTkpQHFOjgY8LTmDEAAsJ/C/RWX87ZF2axmeErdgnFP4W+8UoYmVjwcsXqlzMhboi3pM9FNTToQYmTbReTGTVCL2YqXgDpBr3NCLteNw74l7P77yb0kiPzaeYO60p5yTz/XgK8Wwdp8q4+bPp+MHrD13CE+W/CHNdUWI3gaP6L9ooMKdJASR0FI/qN4cwc0SgSxLqgmuZm0zxztO792vR0bkk9IK11/3Z7fQI96XvbesvB5TFHQJJD11hEcZnH4e6csyUnKTPoTxuv8oO1Qc9hrvnLLpMmBd+njiFf8gdpbcmHcLGzIHat7Sfhq6upqCc9s/JBboMIzRbu0rOLyur5lxXmjQceFNGMsGT1/4YKegTzUrTRQAqWaQqMFJmv5KJky/0tDCJMB/XgwHgQE4tJMpCyF/hyyeOZ1qovQ/M5p6s6mtm9dTXcQeoIpNgdvrxDY5vXBpqNVmAPOLKCYrDy+BWv1Lk6QnQjTveU9g29K7ZI=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(26005)(16526019)(53546011)(36906005)(8936002)(31696002)(356005)(70586007)(70206006)(107886003)(16576012)(4326008)(82310400003)(508600001)(83380400001)(47076005)(36756003)(186003)(316002)(5660300002)(336012)(86362001)(2616005)(110136005)(31686004)(54906003)(8676002)(2906002)(36860700001)(426003)(7636003)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2021 08:28:14.5109
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f9b5e43-2916-4a30-65d8-08d993a38fb3
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT024.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4510
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/20/2021 2:04 AM, Jason Gunthorpe wrote:
> On Tue, Oct 19, 2021 at 02:58:56PM -0600, Alex Williamson wrote:
>> I think that gives us this table:
>>
>> |   NDMA   | RESUMING |  SAVING  |  RUNNING |
>> +----------+----------+----------+----------+ ---
>> |     X    |     0    |     0    |     0    |  ^
>> +----------+----------+----------+----------+  |
>> |     0    |     0    |     0    |     1    |  |
>> +----------+----------+----------+----------+  |
>> |     X    |     0    |     1    |     0    |
>> +----------+----------+----------+----------+  NDMA value is either compatible
>> |     0    |     0    |     1    |     1    |  to existing behavior or don't
>> +----------+----------+----------+----------+  care due to redundancy vs
>> |     X    |     1    |     0    |     0    |  !_RUNNING/INVALID/ERROR
>> +----------+----------+----------+----------+
>> |     X    |     1    |     0    |     1    |  |
>> +----------+----------+----------+----------+  |
>> |     X    |     1    |     1    |     0    |  |
>> +----------+----------+----------+----------+  |
>> |     X    |     1    |     1    |     1    |  v
>> +----------+----------+----------+----------+ ---
>> |     1    |     0    |     0    |     1    |  ^
>> +----------+----------+----------+----------+  Desired new useful cases
>> |     1    |     0    |     1    |     1    |  v
>> +----------+----------+----------+----------+ ---
>>
>> Specifically, rows 1, 3, 5 with NDMA = 1 are valid states a user can
>> set which are simply redundant to the NDMA = 0 cases.
> It seems right
>
>> Row 6 remains invalid due to lack of support for pre-copy (_RESUMING
>> | _RUNNING) and therefore cannot be set by userspace.  Rows 7 & 8
>> are error states and cannot be set by userspace.
> I wonder, did Yishai's series capture this row 6 restriction? Yishai?


It seems so,  by using the below check which includes the 
!VFIO_DEVICE_STATE_VALID clause.

if (old_state == VFIO_DEVICE_STATE_ERROR ||
         !VFIO_DEVICE_STATE_VALID(state) ||
         (state & ~MLX5VF_SUPPORTED_DEVICE_STATES))
         return -EINVAL;

Which is:

#define VFIO_DEVICE_STATE_VALID(state) \
     (state & VFIO_DEVICE_STATE_RESUMING ? \
     (state & VFIO_DEVICE_STATE_MASK) == VFIO_DEVICE_STATE_RESUMING : 1)

>
>> Like other bits, setting the bit should be effective at the completion
>> of writing device state.  Therefore the device would need to flush any
>> outbound DMA queues before returning.
> Yes, the device commands are expected to achieve this.
>
>> The question I was really trying to get to though is whether we have a
>> supportable interface without such an extension.  There's currently
>> only an experimental version of vfio migration support for PCI devices
>> in QEMU (afaik),
> If I recall this only matters if you have a VM that is causing
> migratable devices to interact with each other. So long as the devices
> are only interacting with the CPU this extra step is not strictly
> needed.
>
> So, single device cases can be fine as-is
>
> IMHO the multi-device case the VMM should probably demand this support
> from the migration drivers, otherwise it cannot know if it is safe for
> sure.
>
> A config option to override the block if the admin knows there is no
> use case to cause devices to interact - eg two NVMe devices without
> CMB do not have a useful interaction.
>
>> so it seems like we could make use of the bus-master bit to fill
>> this gap in QEMU currently, before we claim non-experimental
>> support, but this new device agnostic extension would be required
>> for non-PCI device support (and PCI support should adopt it as
>> available).  Does that sound right?  Thanks,
> I don't think the bus master support is really a substitute, tripping
> bus master will stop DMA but it will not do so in a clean way and is
> likely to be non-transparent to the VM's driver.
>
> The single-device-assigned case is a cleaner restriction, IMHO.
>
> Alternatively we can add the 4th bit and insist that migration drivers
> support all the states. I'm just unsure what other HW can do, I get
> the feeling people have been designing to the migration description in
> the header file for a while and this is a new idea.
>
> Jason

Just to be sure,

We refer here to some future functionality support with this extra 4th 
bit but it doesn't enforce any change in the submitted code, right ?

The below code uses the (state & ~MLX5VF_SUPPORTED_DEVICE_STATES) clause 
which fails any usage of a non-supported bit as of this one.

if (old_state == VFIO_DEVICE_STATE_ERROR ||
         !VFIO_DEVICE_STATE_VALID(state) ||
         (state & ~MLX5VF_SUPPORTED_DEVICE_STATES))
         return -EINVAL;

Yishai


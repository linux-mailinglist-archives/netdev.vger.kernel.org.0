Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 226844345F3
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 09:35:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229771AbhJTHhy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 03:37:54 -0400
Received: from mail-dm6nam10on2070.outbound.protection.outlook.com ([40.107.93.70]:56128
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229491AbhJTHhx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Oct 2021 03:37:53 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TyuOnR3a3SQWLvCI/MOzC5p+/30ARWeSiJvXKLjCagTop8Bg8gxL3oovob06hOsvCpSbnZIOqTezABVN3L953FzBq6e8T1967QEng9kEp+HywDOtYmB89ySo8qNqBAdqM2Eno4wA3vNKk93zQ3Qgna7mZy81n1qExchjLSDLD8PI8PxHANwHXUrdC7MNbX1uNRTRKVdlB4+v5byj3HKRGpbOfBi+bk8r+YSPefbFHhykMqGst8nxws/LT07VLSH0wplv4scC7Vz8+lQ6DJi0z8etBUbzxshqHfHfX124teZgybLhRDtZ8gxHDHsvXG7MrDqA22eVschryUXkDKJAsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=l8jGuxMyjyNQPAmfXwRcn0wgEI4hH0HIKPGw0V/kGQw=;
 b=UiMllgNz6fwLTnGWvMQJYABPm6wpPwK0RvEa+nH8UyI/5RJSnPjwyrGO1XiG7eUIzZKUaQvomi+2PKuzlj/xNKo33dOsgyuHEKlIlVxKBHXf+JqUDch9QZEwgT/JdPYaIXL5ty9dIhAQRRAE35YQ4KM0hJuO73d8E34EMoR06h/uk3+HwpgnmJsQi/hbLBCPmP7U/c7iqsz27m48NJGKMwjuLYJccyQNML/YA/cB3AqAdAhcg1MV/j2ZWlPokecmFiOkLZcNdEfRhGoGt1y2TgM4b9D6vPWzkvd8gCSemFrKuFTRAWpr/cxhYkM8vrkCAklX3kittr6Ulxdd/hTbGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l8jGuxMyjyNQPAmfXwRcn0wgEI4hH0HIKPGw0V/kGQw=;
 b=TxCOlg8jG0h9kzcPODbF3euse2DfDXam9FDMoTwcvoEFQnJGHJZ0CR7x3+BoqWM1X8sxLP6dmBQoRdWagwWeljoU7sIW6yUj/FmW0BoeHeKmVal/EuJq9nOscUIjqPfqtB0WCGj4sZnpqTTvbOCh6ujblRwBMsI7EKyDc7axVMLVWAXEznYgFBIr8Xy/+F5/AQjvNMlQVslEFvNoFOgutWGmP6Zq6tSDmmstHbSjmW26ZAFqFItZZqFRN0N2DY0dmy9m4ZmmWUtroGexTs20mnTxlxEcR8TM/1ratch5TLOlpaeuwubcIuj8Jw6oVv97UnAkExVWINBHqxc0niAUNw==
Received: from DM6PR14CA0058.namprd14.prod.outlook.com (2603:10b6:5:18f::35)
 by DM8PR12MB5480.namprd12.prod.outlook.com (2603:10b6:8:24::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.15; Wed, 20 Oct
 2021 07:35:38 +0000
Received: from DM6NAM11FT028.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:18f:cafe::7e) by DM6PR14CA0058.outlook.office365.com
 (2603:10b6:5:18f::35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.15 via Frontend
 Transport; Wed, 20 Oct 2021 07:35:38 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT028.mail.protection.outlook.com (10.13.173.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4628.16 via Frontend Transport; Wed, 20 Oct 2021 07:35:37 +0000
Received: from [172.27.15.75] (172.20.187.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 20 Oct
 2021 07:35:30 +0000
Subject: Re: [PATCH V2 mlx5-next 08/14] vfio: Add a macro for
 VFIO_DEVICE_STATE_ERROR
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     <bhelgaas@google.com>, <jgg@nvidia.com>, <saeedm@nvidia.com>,
        <linux-pci@vger.kernel.org>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>, <leonro@nvidia.com>,
        <kwankhede@nvidia.com>, <mgurtovoy@nvidia.com>, <maorg@nvidia.com>
References: <20211019105838.227569-1-yishaih@nvidia.com>
 <20211019105838.227569-9-yishaih@nvidia.com>
 <20211019094820.2e9bfc01.alex.williamson@redhat.com>
 <20211019095054.396b4f57.alex.williamson@redhat.com>
From:   Yishai Hadas <yishaih@nvidia.com>
Message-ID: <155bb1c0-359b-e8e9-97de-e0bc25196eb8@nvidia.com>
Date:   Wed, 20 Oct 2021 10:35:27 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211019095054.396b4f57.alex.williamson@redhat.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [172.20.187.6]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 50f5273f-2885-47cc-1d8c-08d9939c3620
X-MS-TrafficTypeDiagnostic: DM8PR12MB5480:
X-Microsoft-Antispam-PRVS: <DM8PR12MB54806037353A165618979974C3BE9@DM8PR12MB5480.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8VznKQRd12+gTZbHu3cTAojnzcBBAfDBQwFELfwb3Cox4767adSwOBmtZy4tunDTLKA6B8i5H6AQYfAsfdu8j4PrDSh1UgzLg9hY4yBECvKccMZYUHBwwIt4gVlmtwyn8i2o5EksgnnCgxOa1GNLaZ+RGS13UXA4O/nrmQAPvVG53LAuXTJ/w5AMMn3E5eH++h/geew8xnAq9KKlvbB2KFMcR/R1KO+M9H3SsibAwOIQuZ8mD60U+0MOwieYKNFfy9MeB8uaoj8iYncHYV1215bj0mIiHpXfng74iCHaxqY9lc0hb6Y9wBD0GPi1yIZMLlV+54CPKZDWuS0eyOdI9jvFeeE8TwxeuiwgFHmiBZXtJ9h8mGDVSz7RqKKLVIlBpGhlr0z+oZbzcAEhWG71Jit5+d+iWoZjOiPlFsRoqNBpyn2uaeqTZpJDaGZkYgcM5zzrsMzjNqdTub1In/kALKzkNycPXsJ8VSy1tEcJ1ePmgIK3brCWYf8bJdbDkOfH05XXjEWUXvJK2jHgMyvJAoHSLlEjdZMaoJDyhR2Upw1PuQuV7fMJ8/Ic2FLUnFCgRUdJGDi2qalZnKffp2Wui59PTlyrHNxBDea6gcMyNuLLvY205zyOW72t09B78csuUdWGZjW+us4RMgXRSlGN2zP3djSG3Mpi3Ss6pxHwbW7JvcwlPM4e5dtdm21awYArbXWG8wKkkV7hp87a4ETffGdJPaVhHEeh1PbF97pKKHg=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(508600001)(31696002)(8676002)(8936002)(53546011)(82310400003)(26005)(31686004)(2906002)(2616005)(36860700001)(356005)(5660300002)(36756003)(7636003)(83380400001)(54906003)(47076005)(426003)(6666004)(316002)(16576012)(336012)(86362001)(4326008)(107886003)(6916009)(16526019)(186003)(70206006)(70586007)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2021 07:35:37.6644
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 50f5273f-2885-47cc-1d8c-08d9939c3620
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT028.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR12MB5480
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/19/2021 6:50 PM, Alex Williamson wrote:
> On Tue, 19 Oct 2021 09:48:20 -0600
> Alex Williamson <alex.williamson@redhat.com> wrote:
>
>> On Tue, 19 Oct 2021 13:58:32 +0300
>> Yishai Hadas <yishaih@nvidia.com> wrote:
>>
>>> Add a macro for VFIO_DEVICE_STATE_ERROR to be used to set/check an error
>>> state.
>>>
>>> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
>>> ---
>>>   include/uapi/linux/vfio.h | 2 ++
>>>   1 file changed, 2 insertions(+)
>>>
>>> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
>>> index 114ffcefe437..6d41a0f011db 100644
>>> --- a/include/uapi/linux/vfio.h
>>> +++ b/include/uapi/linux/vfio.h
>>> @@ -631,6 +631,8 @@ struct vfio_device_migration_info {
>>>   	__u64 data_size;
>>>   };
>>>   
>>> +#define VFIO_DEVICE_STATE_ERROR (VFIO_DEVICE_STATE_SAVING | \
>>> +				 VFIO_DEVICE_STATE_RESUMING)
>> This should be with the other VFIO_DEVICE_STATE_foo #defines.  I'd
>> probably put it between _RESUMING and _MASK.  Thanks,
> This should also update the existing macros that include _SAVING |
> _RESUMING.  Thanks,
>
> Alex
>
Sure, will do as part of V3.

Yishai


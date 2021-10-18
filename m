Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F709431AC6
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 15:27:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231919AbhJRN3H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 09:29:07 -0400
Received: from mail-mw2nam12on2059.outbound.protection.outlook.com ([40.107.244.59]:51777
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231548AbhJRN2h (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Oct 2021 09:28:37 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J/TLvzLz9MaITQhhN27KsRT39jTjEuoeNTjnmwMledNNCJG34vAkQPdWnwYLCUWdWwFsCGPfVXlk3pPbdTmgg5X9dPo1eylivCnEZ8uTG+DAopOMVdiQuS8kEoKTUfxvOXrGxgQ3iP+8UXjKIG4XaVx9QhCaUMRoeFoP0ND2/Y/NlFuQHwiNHeEADDGIHfkQ3li3mSlGySHjypBwgKlp52z89HYooXTHnJ+CBuzauYtl1p0wsSvyaRS8L+4T0K43BIgAiLlfksFZ7H2kfhvFq6EGB9CK67ojOg37MUryPt9EqgXOp+jdtL1bcNm5vgShE+npD63ye/VpV/+ouwAfsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2EG3922+/l+1A7ZAMw1FN4JECWOzmSFWYJ6qfvb0cCg=;
 b=ZD603vC+Qe7XbnevuA8G8r2wU2mdZfAG/Zi7nW5JgjYFTZA9yJqzxkxlu2giWDX2TnIw0/rCiFNxmsaeqG1Gav2fXaccAOeVWubh7dRZRbWk3VB7nWUjhRLD5QUNC9dfecpmL9zzWHvkVvdgXZ6ap/CLv4ydxNUViEge8mExQ+HvWdHqOkCoZARLXaaQEV0Q5tp+b89S7AkwqKOYUaoSyQoQkMK7XLWBA+nd+CIPoeZyRM+mUSqvbDUzkY9r2ySJ8LDGcDZdRG5rc7JLiy0oUt61FMT0+7oU6mJXryeuQbCGv3HiR++L9F4orlSfaKymrRWaioXLNZ2xArk476FUfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2EG3922+/l+1A7ZAMw1FN4JECWOzmSFWYJ6qfvb0cCg=;
 b=qEdnIdxauC7Ba8Zv+jU0qeDWXhMW8Ux3xTm7Qc/EFL3H7pm1VZI6tJ/4lQ/kobt8n78RX7FLDkK6MasDK8qf3LsU1G+1HKHBPFSzwWXph+3v3R92J0SH7k8FVcZGlJXJTqB6dV+gbcTA9G5dvfLGjKNg+0ONhR+4SqqJHWnK8i3L0u63ymXIJuEbIk2LjJn76tzTkkc4uZk6ehUMkJ9TKRft2JNduLaxN/W3tm6FPxYiRdbaLhpYG4zW1i1nrevvtA2Uf3WYpDldm7RKWf8lMIyo76RCsZmgLAG0yVHpx69O5nQ13Iy6EV1Gpk1lGJmO90XUP+YA29odyX6KU7kzNg==
Received: from DM6PR08CA0054.namprd08.prod.outlook.com (2603:10b6:5:1e0::28)
 by DM5PR1201MB0027.namprd12.prod.outlook.com (2603:10b6:4:59::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.17; Mon, 18 Oct
 2021 13:26:24 +0000
Received: from DM6NAM11FT026.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:1e0:cafe::2e) by DM6PR08CA0054.outlook.office365.com
 (2603:10b6:5:1e0::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.14 via Frontend
 Transport; Mon, 18 Oct 2021 13:26:24 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT026.mail.protection.outlook.com (10.13.172.161) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4608.15 via Frontend Transport; Mon, 18 Oct 2021 13:26:24 +0000
Received: from [172.27.14.240] (172.20.187.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 18 Oct
 2021 13:26:19 +0000
Subject: Re: [PATCH V1 mlx5-next 11/13] vfio/mlx5: Implement vfio_pci driver
 for mlx5 devices
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>
CC:     <bhelgaas@google.com>, <saeedm@nvidia.com>,
        <linux-pci@vger.kernel.org>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>, <leonro@nvidia.com>,
        <kwankhede@nvidia.com>, <mgurtovoy@nvidia.com>, <maorg@nvidia.com>
References: <20211013094707.163054-1-yishaih@nvidia.com>
 <20211013094707.163054-12-yishaih@nvidia.com>
 <20211015134820.603c45d0.alex.williamson@redhat.com>
 <20211015195937.GF2744544@nvidia.com>
 <20211015141201.617049e9.alex.williamson@redhat.com>
 <20211015201654.GH2744544@nvidia.com>
 <20211015145921.0abf7cb0.alex.williamson@redhat.com>
 <6608853f-7426-7b79-da1a-29c8fcc6ffc3@nvidia.com>
 <20211018115107.GM2744544@nvidia.com>
From:   Yishai Hadas <yishaih@nvidia.com>
Message-ID: <c27a775f-f003-b652-ea80-f6ea988c0e78@nvidia.com>
Date:   Mon, 18 Oct 2021 16:26:16 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211018115107.GM2744544@nvidia.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [172.20.187.5]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 29cf26ba-2ac7-4922-616c-08d9923ae1e4
X-MS-TrafficTypeDiagnostic: DM5PR1201MB0027:
X-Microsoft-Antispam-PRVS: <DM5PR1201MB002762D7E15152942D2EB939C3BC9@DM5PR1201MB0027.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qrOMt+v6mlq5juOHN48SjnZK3O1msnNxGO76XJHRN4Y3lxAM8iUqXEABrXgJREyNsX7rE/2Ldz9to4wXW0VsTbgSQpdtjnC6PnyW9b7IqCOSRiVdRP3pSd9ZA4tT9znueTaHwoMXlP6nM5w2pvHctGk2jXvaAa5KnDvSrkqzi/o8XpxL6NK+G4rfeKcoSOhbfuOsb7E5ziIAZ4bHltfE2FL7QgEEzo4lgofRVa3j7YJksl2HQbu+VROzsv2J/8MecqqW4zh9gFBpjqQ2yTaTC0NYBS4kl7DMUOxPNcDqbghDtkla9w6CtojYKa49hQhmxxMBKCJIM12WHSqQ5RRF8TktpN+YdDnMSx9ikWE8Cjv+JD3/V18zSJxneHv96Bl0TsFIfYPZ8IiCGSw4EERrw9IOFfDd5EK/KTRf+x5K9ebVw46mWitluChziFlZZqs166dRYzYmyUCMMA+6wAg0lYsR0888PgzWQ5khoEt9rgIY4OkB8N2EXgPvWd+E8r+3O7JuAtz5Q7KbNSPHuxk3LUu9UupCR/EpVgTf7FnpuZkeOUvYuZ5DBMm4VBCSq2T3oR3LrEpPerORmAwboE4TuF/UPwC+b5hpGg2LEDo6zpbrTjhm/HmhDVdjYgc83z51yN4OWvBx3fWhjWV/YcwGRKtapq7jmHuq4qXUjAhasc5sw9xPtHzpasrqB/HSq7lIYICgNFlSKpi1EVaynDbQwlGCWj7lC2cFOBxAJUiZ1dE=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(356005)(8936002)(70206006)(426003)(86362001)(336012)(2616005)(70586007)(8676002)(36756003)(47076005)(26005)(110136005)(16576012)(5660300002)(31686004)(82310400003)(6666004)(2906002)(508600001)(4326008)(316002)(53546011)(54906003)(7636003)(36860700001)(186003)(16526019)(31696002)(107886003)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Oct 2021 13:26:24.4201
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 29cf26ba-2ac7-4922-616c-08d9923ae1e4
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT026.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1201MB0027
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/18/2021 2:51 PM, Jason Gunthorpe wrote:
> On Sun, Oct 17, 2021 at 05:03:28PM +0300, Yishai Hadas wrote:
>> On 10/15/2021 11:59 PM, Alex Williamson wrote:
>>> On Fri, 15 Oct 2021 17:16:54 -0300
>>> Jason Gunthorpe <jgg@nvidia.com> wrote:
>>>
>>>> On Fri, Oct 15, 2021 at 02:12:01PM -0600, Alex Williamson wrote:
>>>>> On Fri, 15 Oct 2021 16:59:37 -0300
>>>>> Jason Gunthorpe <jgg@nvidia.com> wrote:
>>>>>> On Fri, Oct 15, 2021 at 01:48:20PM -0600, Alex Williamson wrote:
>>>>>>>> +static int mlx5vf_pci_set_device_state(struct mlx5vf_pci_core_device *mvdev,
>>>>>>>> +				       u32 state)
>>>>>>>> +{
>>>>>>>> +	struct mlx5vf_pci_migration_info *vmig = &mvdev->vmig;
>>>>>>>> +	u32 old_state = vmig->vfio_dev_state;
>>>>>>>> +	int ret = 0;
>>>>>>>> +
>>>>>>>> +	if (vfio_is_state_invalid(state) || vfio_is_state_invalid(old_state))
>>>>>>>> +		return -EINVAL;
>>>>>>> if (!VFIO_DEVICE_STATE_VALID(old_state) || !VFIO_DEVICE_STATE_VALID(state))
>>>>>> AFAICT this macro doesn't do what is needed, eg
>>>>>>
>>>>>> VFIO_DEVICE_STATE_VALID(0xF000) == true
>>>>>>
>>>>>> What Yishai implemented is at least functionally correct - states this
>>>>>> driver does not support are rejected.
>>>>> if (!VFIO_DEVICE_STATE_VALID(old_state) || !VFIO_DEVICE_STATE_VALID(state)) || (state & ~VFIO_DEVICE_STATE_MASK))
>>>>>
>>>>> old_state is controlled by the driver and can never have random bits
>>>>> set, user state should be sanitized to prevent setting undefined bits.
>>>> In that instance let's just write
>>>>
>>>> old_state != VFIO_DEVICE_STATE_ERROR
>>>>
>>>> ?
>>> Not quite, the user can't set either of the other invalid states
>>> either.
>>
>> OK so let's go with below as you suggested.
>> if (!VFIO_DEVICE_STATE_VALID(old_state) ||
>>       !VFIO_DEVICE_STATE_VALID(state) ||
>>        (state & ~VFIO_DEVICE_STATE_MASK))
>>             
> This is my preference:
>
> if (vmig->vfio_dev_state != VFIO_DEVICE_STATE_ERROR ||
>      !vfio_device_state_valid(state) ||
>      (state & !MLX5VF_SUPPORTED_DEVICE_STATES))
>

OK, let's go with this approach which enforces what the driver supports 
as well.

We may have the below post making it accurate and complete.

enum {
     MLX5VF_SUPPORTED_DEVICE_STATES = VFIO_DEVICE_STATE_RUNNING |
                                      VFIO_DEVICE_STATE_SAVING |
                                      VFIO_DEVICE_STATE_RESUMING,
};

if (old_state == VFIO_DEVICE_STATE_ERROR ||
     !vfio_device_state_valid(state) ||
     (state & ~MLX5VF_SUPPORTED_DEVICE_STATES))
           return -EINVAL;

>> diff --git a/include/linux/vfio.h b/include/linux/vfio.h
>> index b53a9557884a..37376dadca5a 100644
>> +++ b/include/linux/vfio.h
>> @@ -15,6 +15,8 @@
>>   #include <linux/poll.h>
>>   #include <uapi/linux/vfio.h>
>>
>> +static const int VFIO_DEVICE_STATE_ERROR = VFIO_DEVICE_STATE_SAVING |
>> + VFIO_DEVICE_STATE_RESUMING;
> Do not put static variables in header files
>
> Jason

OK, we can come with an enum instead.

enum {

VFIO_DEVICE_STATE_ERROR = VFIO_DEVICE_STATE_SAVING | VFIO_DEVICE_STATE_RESUMING,

};

Alex,

Do you prefer to  put it under include/uapi/vfio.h or that it can go 
under inlcude/linux/vfio.h for internal drivers usage ?

Yishai


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 627A8431D65
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 15:48:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232533AbhJRNus (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 09:50:48 -0400
Received: from mail-co1nam11on2088.outbound.protection.outlook.com ([40.107.220.88]:30689
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232543AbhJRNs5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Oct 2021 09:48:57 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PrO0A3M41bUOA/J3Kg/eq6XFZD+kLEzK4CFUr3fTGK+rRzjpzvjf3J6GSSDHsbqY4dcbg6LuGPkuT3vBM2eQQVRRzNwsZsbguOJ65+8EUbMRdPFW4JBkXU4wja2oRcZ1JRcdP4uNnANuAjg8rHNiDw4B8J7bSgoWe+dc29wVTNTXjYyuZfY4MvCtTlhxidaZM0RrGqSl20KIj6fntaZM+AbXndkRxm/fR0z/WKrNlGvzRTM0fVVOOLGRd9tdTIi3N9Uv8esRJGJUTmQX/KvRxkuisbnEaMeqrwL3exAQEsJboNA4Xvp4nNlIn3ph4PBRnf7t/6WorCmcNFZuqdLKMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8T7NYLEJV+mTyhrh00eso4lWbt/Twh0+Z38jz03ALLs=;
 b=Ig7UWL0NlU8bD5bX/dk77kTvJo9+gIbc5K6NxNOTTdf7FbARicRkAgP7iGJwAa+GQXIaDFQtuYXsH71OyIP7FBYXS3v1Qg5QDpGzjkTOARxpSpY8igTuguCE4Str1pFE41VutcUWrHT51UA5BSYR5atLcObe/HjGRELFnRgkaKyGIhMn3BRQiagPNPFC9CBvTvIkc8OPigDvqi5zYNMYi/0ECSF/v3yn9kJw9AgHyWa/NcZjZ5xGFxx0IH/Kezh7Sex5MwN2EX+tL7h7GEAMfDvsRpcnZR+T24kxBb9CPL4D2PMmeU8Cdr0qIbDvkl14zOIceWL3VZT8bIMoD01ZoA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8T7NYLEJV+mTyhrh00eso4lWbt/Twh0+Z38jz03ALLs=;
 b=ge5P/3qc1NH5esYQd2g4lxfmw3JCO7mhwoqLK+Y6fqMjkgaZD6al8+6O0BB2lVF2BywA8oKWwKUOqtLHs1S5ab3HFCYgeGTpLYE/OpVrleQ5kFCNBhr/ZSraJ9/t2u41DPF4K83znW9oTEcBAUZUOCjssRzCSzTGW5zz93HgyTXwVBTyGp5OsVZqRPbh85w+6x61cjVQt+tcQrospKPiJp0qmMyL9jn3oxVPKw7qtGjatHr07fV9bdD/wy4X+uvMTsESAIQD0nQq7fbCk5gemEjDuGmTQArpLj2K375LNQPiaDGmh9aAuH66TkAWKJKSPDOVz+E518lgtIIg4tqqgQ==
Received: from MW4PR03CA0054.namprd03.prod.outlook.com (2603:10b6:303:8e::29)
 by BL0PR12MB5555.namprd12.prod.outlook.com (2603:10b6:208:1c2::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.16; Mon, 18 Oct
 2021 13:46:44 +0000
Received: from CO1NAM11FT068.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:8e:cafe::dc) by MW4PR03CA0054.outlook.office365.com
 (2603:10b6:303:8e::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.17 via Frontend
 Transport; Mon, 18 Oct 2021 13:46:44 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 CO1NAM11FT068.mail.protection.outlook.com (10.13.175.142) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4608.15 via Frontend Transport; Mon, 18 Oct 2021 13:46:43 +0000
Received: from [172.27.14.240] (172.20.187.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 18 Oct
 2021 13:46:37 +0000
Subject: Re: [PATCH V1 mlx5-next 11/13] vfio/mlx5: Implement vfio_pci driver
 for mlx5 devices
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     Jason Gunthorpe <jgg@nvidia.com>, <bhelgaas@google.com>,
        <saeedm@nvidia.com>, <linux-pci@vger.kernel.org>,
        <kvm@vger.kernel.org>, <netdev@vger.kernel.org>, <kuba@kernel.org>,
        <leonro@nvidia.com>, <kwankhede@nvidia.com>,
        <mgurtovoy@nvidia.com>, <maorg@nvidia.com>
References: <20211013094707.163054-1-yishaih@nvidia.com>
 <20211013094707.163054-12-yishaih@nvidia.com>
 <20211015134820.603c45d0.alex.williamson@redhat.com>
 <20211015195937.GF2744544@nvidia.com>
 <20211015141201.617049e9.alex.williamson@redhat.com>
 <20211015201654.GH2744544@nvidia.com>
 <20211015145921.0abf7cb0.alex.williamson@redhat.com>
 <6608853f-7426-7b79-da1a-29c8fcc6ffc3@nvidia.com>
 <20211018115107.GM2744544@nvidia.com>
 <c27a775f-f003-b652-ea80-f6ea988c0e78@nvidia.com>
 <20211018074232.1008f54c.alex.williamson@redhat.com>
From:   Yishai Hadas <yishaih@nvidia.com>
Message-ID: <17cd04da-7fc5-0c62-20bc-bb62f4a5d621@nvidia.com>
Date:   Mon, 18 Oct 2021 16:46:35 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211018074232.1008f54c.alex.williamson@redhat.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [172.20.187.5]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 01fcb5de-330a-4490-9650-08d9923db8b1
X-MS-TrafficTypeDiagnostic: BL0PR12MB5555:
X-Microsoft-Antispam-PRVS: <BL0PR12MB5555710E2829948DB0D4A419C3BC9@BL0PR12MB5555.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HKbW7qgbJ7fz4MltFElCYr5vY8lf/HWNOAoHXQmAGyBrZvhC8mw9R1t41CzBTSm307doIQkQEYQohduKN77UAftZYHJrxSHL8/hzhyIeq6qtAEOzTXoaDqoVpj/9I3c8a71nHKIC7C04p4DkaLx8kcjBpGaMFa3pIe2Ie66pW9QY8lz9vJpV1djeab+6i8jTCgLvkZD9WZAgyiut4jOsOCAvTBfO44CX54Z2uMqBCkiY0zdx/g8gwOZl2JGvR5rLIEQTWhlUo9Rn3/VedoBxjddt8hv7OubSNymkJG+1LOHmkDR7Ks/L6xkTjl4nZL2kdh8kqKl9KNYBANY0yuwpW1+TNf/J4O14Lcm+7COqsPTU8rk/Nalsap3uJnK8lTuh3rsgbSeCdt7LRRaSUdWIEjc2DI5hsS+NVsm98mKpRX434d1t5T9I5r1NBRg+LUyP5VMHlz5UYwoIm8YCbjPJYeZojxAJxkGcWaknfqWH5C0YF78yXr8qFTCv2IorV/qtTIfcoLrim9+eJCZ810rcNkcFQq4RDke1eIKY+1TNAuXMtw8cT7hCl9kBLbGIRwr9nDzLt0AGWZOF0TVYAjDbK/fvnXyEd9NppS2LaQL0obpIPqSDIwJ+sDxHzoJgApGcsDFpLP5tFynNOlPW5O58Q+AmpW4zeXGQBytLmQkBgtfUph7eCNnTzMeIpZoYdVOCcGDt4Ky/pgOwF0iXkKS1/7+DkacI99YQhyzuXVQuoc4=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(8936002)(508600001)(426003)(53546011)(356005)(4326008)(31686004)(107886003)(5660300002)(2616005)(47076005)(70206006)(6916009)(70586007)(2906002)(336012)(8676002)(16526019)(82310400003)(7636003)(16576012)(36860700001)(31696002)(36756003)(316002)(54906003)(186003)(26005)(86362001)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Oct 2021 13:46:43.4085
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 01fcb5de-330a-4490-9650-08d9923db8b1
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT068.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB5555
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/18/2021 4:42 PM, Alex Williamson wrote:
> On Mon, 18 Oct 2021 16:26:16 +0300
> Yishai Hadas <yishaih@nvidia.com> wrote:
>
>> On 10/18/2021 2:51 PM, Jason Gunthorpe wrote:
>>> On Sun, Oct 17, 2021 at 05:03:28PM +0300, Yishai Hadas wrote:
>>>> On 10/15/2021 11:59 PM, Alex Williamson wrote:
>>>>> On Fri, 15 Oct 2021 17:16:54 -0300
>>>>> Jason Gunthorpe <jgg@nvidia.com> wrote:
>>>>>   
>>>>>> On Fri, Oct 15, 2021 at 02:12:01PM -0600, Alex Williamson wrote:
>>>>>>> On Fri, 15 Oct 2021 16:59:37 -0300
>>>>>>> Jason Gunthorpe <jgg@nvidia.com> wrote:
>>>>>>>> On Fri, Oct 15, 2021 at 01:48:20PM -0600, Alex Williamson wrote:
>>>>>>>>>> +static int mlx5vf_pci_set_device_state(struct mlx5vf_pci_core_device *mvdev,
>>>>>>>>>> +				       u32 state)
>>>>>>>>>> +{
>>>>>>>>>> +	struct mlx5vf_pci_migration_info *vmig = &mvdev->vmig;
>>>>>>>>>> +	u32 old_state = vmig->vfio_dev_state;
>>>>>>>>>> +	int ret = 0;
>>>>>>>>>> +
>>>>>>>>>> +	if (vfio_is_state_invalid(state) || vfio_is_state_invalid(old_state))
>>>>>>>>>> +		return -EINVAL;
>>>>>>>>> if (!VFIO_DEVICE_STATE_VALID(old_state) || !VFIO_DEVICE_STATE_VALID(state))
>>>>>>>> AFAICT this macro doesn't do what is needed, eg
>>>>>>>>
>>>>>>>> VFIO_DEVICE_STATE_VALID(0xF000) == true
>>>>>>>>
>>>>>>>> What Yishai implemented is at least functionally correct - states this
>>>>>>>> driver does not support are rejected.
>>>>>>> if (!VFIO_DEVICE_STATE_VALID(old_state) || !VFIO_DEVICE_STATE_VALID(state)) || (state & ~VFIO_DEVICE_STATE_MASK))
>>>>>>>
>>>>>>> old_state is controlled by the driver and can never have random bits
>>>>>>> set, user state should be sanitized to prevent setting undefined bits.
>>>>>> In that instance let's just write
>>>>>>
>>>>>> old_state != VFIO_DEVICE_STATE_ERROR
>>>>>>
>>>>>> ?
>>>>> Not quite, the user can't set either of the other invalid states
>>>>> either.
>>>> OK so let's go with below as you suggested.
>>>> if (!VFIO_DEVICE_STATE_VALID(old_state) ||
>>>>        !VFIO_DEVICE_STATE_VALID(state) ||
>>>>         (state & ~VFIO_DEVICE_STATE_MASK))
>>>>                
>>> This is my preference:
>>>
>>> if (vmig->vfio_dev_state != VFIO_DEVICE_STATE_ERROR ||
>>>       !vfio_device_state_valid(state) ||
>>>       (state & !MLX5VF_SUPPORTED_DEVICE_STATES))
>>>   
>> OK, let's go with this approach which enforces what the driver supports
>> as well.
>>
>> We may have the below post making it accurate and complete.
>>
>> enum {
>>       MLX5VF_SUPPORTED_DEVICE_STATES = VFIO_DEVICE_STATE_RUNNING |
>>                                        VFIO_DEVICE_STATE_SAVING |
>>                                        VFIO_DEVICE_STATE_RESUMING,
>> };
>>
>> if (old_state == VFIO_DEVICE_STATE_ERROR ||
>>       !vfio_device_state_valid(state) ||
>>       (state & ~MLX5VF_SUPPORTED_DEVICE_STATES))
>>             return -EINVAL;
>>
>>>> diff --git a/include/linux/vfio.h b/include/linux/vfio.h
>>>> index b53a9557884a..37376dadca5a 100644
>>>> +++ b/include/linux/vfio.h
>>>> @@ -15,6 +15,8 @@
>>>>    #include <linux/poll.h>
>>>>    #include <uapi/linux/vfio.h>
>>>>
>>>> +static const int VFIO_DEVICE_STATE_ERROR = VFIO_DEVICE_STATE_SAVING |
>>>> + VFIO_DEVICE_STATE_RESUMING;
>>> Do not put static variables in header files
>>>
>>> Jason
>> OK, we can come with an enum instead.
>>
>> enum {
>>
>> VFIO_DEVICE_STATE_ERROR = VFIO_DEVICE_STATE_SAVING | VFIO_DEVICE_STATE_RESUMING,
>>
>> };
>>
>> Alex,
>>
>> Do you prefer to  put it under include/uapi/vfio.h or that it can go
>> under inlcude/linux/vfio.h for internal drivers usage ?
> I don't understand why this wouldn't just be a continuation of the
> #defines in the uapi header.  Thanks,
>
> Alex
>

Sure, let's go with this.

Thanks,
Yishai

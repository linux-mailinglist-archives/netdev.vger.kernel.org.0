Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B34C41D647
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 11:25:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349384AbhI3J1Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 05:27:16 -0400
Received: from mail-dm6nam10on2045.outbound.protection.outlook.com ([40.107.93.45]:36082
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1349293AbhI3J1P (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Sep 2021 05:27:15 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZmQFC0IP5q0M14gkGFEIS7CuPwMP/q4XWySC2jM968rfAx9uTBtBv6LcY1gJPopJZQKRkrrKzt7Mi8UWTLWNcMebGGBJcwM7lmt6AfTwWtAhRUYZcxwPJEJg+4w/6BAkyqe4KYSvVfNqzDVl8KuvXHXfPsfrLr9vH1cpgdFka8KGm15Ao9NYEfcPcxGRv/BeVAqwaGsF0IX4utYrpkmccqbnU7AzVf1w7tspJCHhp6z8uEVS5pKbCeODZwweyNYU5d48Ze+aOFs7GwLbc1bPgkL2EuzilusajWAhF/3JPTHKFPBqF1ne7jNQMi/yKOu3y6IXutNJyrAjwI+nvVPZpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=9S3wZBv0tNdr+hHbKqEsV2JMFySlS+AJHHTdkyTfl1E=;
 b=FVZp5/22n+Vp3UZun2YGuwM/VT/BG4WDNsHw7UkpVMQGAgVH+MoHtWtAv4vZHnPhmwopmTNchYVG41zLpEFIkXpZs1CinorbMJTKtJangJypaAslZJsQ0H9PQoWQVKcuIgXBzjNV9TzYqohHdHbhRaZlNnJqNmKYFIFECPxLTuh3PgWVuiNlgSX9aNir+FLln1UFGGV07wUiQhP6MKEK/lcuPFLA+JHpKrUu34uQ8C2BBCupHO8xebNJogsYCTPaNldSslsVGf/lcQX52un1di8LQ31CT+iSw5R/57ZH7lqDc1m0mqEqVuYfUCc7pHmEvM9NPHq6mvyYueqlb5gYiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9S3wZBv0tNdr+hHbKqEsV2JMFySlS+AJHHTdkyTfl1E=;
 b=PWTreCsQTZVfqS6lxuHZNu4ph+z2pH5rla7fvA/pBZRNCYR3Qh54bD7EWMsLFTp5oLZMSQE1S/wQXgrWxRgc8VOyX66YMrkb3WwzblUZf7d0o94mS8F+RLStZ/vEweWYF/dC1YGlEwstaanZWPUBQptKvwpiZPJujvq8CDl7jKkhHyms0fxYuaSN3rUaeKixURKGNrDSo8ZFWgESlnzMIKVXtY1g9qL3XvHiwBgxgt9u5HZcvivg7Nuy2kwFFbVR3SkPPPz0dmg5lc0Mi5nyFcjpiRNNb9UkvlWgFDAYwwSSTWGOgJ/ykVkJAQWvYNLN1GWWgdbBjZT53KWgVkvP3w==
Received: from MW2PR2101CA0027.namprd21.prod.outlook.com (2603:10b6:302:1::40)
 by DM5PR12MB1706.namprd12.prod.outlook.com (2603:10b6:3:10f::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.15; Thu, 30 Sep
 2021 09:25:30 +0000
Received: from CO1NAM11FT055.eop-nam11.prod.protection.outlook.com
 (2603:10b6:302:1:cafe::5) by MW2PR2101CA0027.outlook.office365.com
 (2603:10b6:302:1::40) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.1 via Frontend
 Transport; Thu, 30 Sep 2021 09:25:30 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 CO1NAM11FT055.mail.protection.outlook.com (10.13.175.129) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4566.14 via Frontend Transport; Thu, 30 Sep 2021 09:25:29 +0000
Received: from [172.27.13.136] (172.20.187.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 30 Sep
 2021 09:25:25 +0000
Subject: Re: [PATCH mlx5-next 2/7] vfio: Add an API to check migration state
 transition validity
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
        "Doug Ledford" <dledford@redhat.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        "Bjorn Helgaas" <bhelgaas@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>,
        Kirti Wankhede <kwankhede@nvidia.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-pci@vger.kernel.org>,
        <linux-rdma@vger.kernel.org>, <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>
References: <c87f55d6fec77a22b110d3c9611744e6b28bba46.1632305919.git.leonro@nvidia.com>
 <20210927164648.1e2d49ac.alex.williamson@redhat.com>
 <20210927231239.GE3544071@ziepe.ca>
 <25c97be6-eb4a-fdc8-3ac1-5628073f0214@nvidia.com>
 <20210929063551.47590fbb.alex.williamson@redhat.com>
 <1eba059c-4743-4675-9f72-1a26b8f3c0f6@nvidia.com>
 <20210929075019.48d07deb.alex.williamson@redhat.com>
 <d2e94241-a146-c57d-cf81-8b7d8d00e62d@nvidia.com>
 <20210929091712.6390141c.alex.williamson@redhat.com>
 <e1ba006f-f181-0b89-822d-890396e81c7b@nvidia.com>
 <20210929161433.GA1808627@ziepe.ca>
 <29835bf4-d094-ae6d-1a32-08e65847b52c@nvidia.com>
 <20210929164409.3c33e311.alex.williamson@redhat.com>
From:   Max Gurtovoy <mgurtovoy@nvidia.com>
Message-ID: <bad28179-cbca-9337-8e6b-d730f06c6c58@nvidia.com>
Date:   Thu, 30 Sep 2021 12:25:23 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20210929164409.3c33e311.alex.williamson@redhat.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [172.20.187.6]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ea141835-a751-4bf4-ab95-08d983f43eee
X-MS-TrafficTypeDiagnostic: DM5PR12MB1706:
X-Microsoft-Antispam-PRVS: <DM5PR12MB17068E15FE4977A7BF6B4FAFDEAA9@DM5PR12MB1706.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ijkGxaWglL0cE+tNSWAcCH/WG2LDI2PRjeRGYaeY0G48ux2xh6RyD9Jbb7Tsev1SoZXD9UWXrczUsNA6DEZvV3WmiZ7DNR/eRxm0B2JP9Xkg3dRrEHXztDgRchfmrKqZmjFf3ELMf3smjXwX7v75DFTkaO4E9YwVhqec5XwyKoVHyx1bMQMz0VqzevpHAz7qyPJUQXjoOQt9oUiO9cduD8VSuMJdORaZcZDZAeMC05M1aMRN4BQ1+O1dd+goMsiZOpPvpbsvNvCsKJn9pMGX2nko/1mM0Yt6qNgauf6hWa9KHPJ3VMkulkF6YGxbzMKKKKAAoc9RH13BWsWV/9R8TWtGbz5L0Rb9+9D7taBqa7PfCFWDMuaoPb+YeQ6JEjvyEfQMvXu3bWeB+8TfEMt0+qQmxP1DrkfvwgpxhH1cGZGuq1qprTvOeFVtiJECLmeg3xWonuQ0d+XKNgfMDtFlJopLNpiyMmedQmH45dYIW4/JrcJ5lzeBvw2vafDFBy2CJachRsGFZgTGMp7X2RFD9ekQeikdsV3wnzcsA/cKDnZ6weXIim4L3K+4rtOlBOela7Fh6xPBJqhkjoK8xhAul5X6N2jBo/DNX17Jv34HMnqLMDinp8krK1Qq1r6yZav16ZNtkMReIfCWw8HbvSLvbvZTXbikUWfY6T8fyUVrfkSBKOs7XtWIXtZ60Q6/WVvF+Efre0/t51cuDIvVo6MrEqutg/1o4JEXHPdhj2n3Q8U=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(16526019)(8936002)(508600001)(186003)(36860700001)(316002)(26005)(7416002)(16576012)(5660300002)(54906003)(31696002)(426003)(336012)(2906002)(82310400003)(4326008)(2616005)(36756003)(53546011)(86362001)(8676002)(7636003)(31686004)(47076005)(356005)(70586007)(70206006)(83380400001)(6916009)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2021 09:25:29.9594
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ea141835-a751-4bf4-ab95-08d983f43eee
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT055.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1706
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 9/30/2021 1:44 AM, Alex Williamson wrote:
> On Thu, 30 Sep 2021 00:48:55 +0300
> Max Gurtovoy <mgurtovoy@nvidia.com> wrote:
>
>> On 9/29/2021 7:14 PM, Jason Gunthorpe wrote:
>>> On Wed, Sep 29, 2021 at 06:28:44PM +0300, Max Gurtovoy wrote:
>>>   
>>>>> So you have a device that's actively modifying its internal state,
>>>>> performing I/O, including DMA (thereby dirtying VM memory), all while
>>>>> in the _STOP state?  And you don't see this as a problem?
>>>> I don't see how is it different from vfio-pci situation.
>>> vfio-pci provides no way to observe the migration state. It isn't
>>> "000b"
>> Alex said that there is a problem of compatibility.
>>
>> I migration SW is not involved, nobody will read this migration state.
> The _STOP state has a specific meaning regardless of whether userspace
> reads the device state value.  I think what you're suggesting is that
> the device reports itself as _STOP'd but it's actually _RUNNING.  Is
> that the compatibility workaround, create a self inconsistency?

 From migration point of view the device is stopped.

>
> We cannot impose on userspace to move a device from _STOP to _RUNNING
> simply because the device supports the migration region, nor should we
> report a device state that is inconsistent with the actual device state.

In this case we can think maybe moving to running during enabling the 
bus master..


>
>>>> Maybe we need to rename STOP state. We can call it READY or LIVE or
>>>> NON_MIGRATION_STATE.
>>> It was a poor choice to use 000b as stop, but it doesn't really
>>> matter. The mlx5 driver should just pre-init this readable to running.
>> I guess we can do it for this reason. There is no functional problem nor
>> compatibility issue here as was mentioned.
>>
>> But still we need the kernel to track transitions. We don't want to
>> allow moving from RESUMING to SAVING state for example. How this
>> transition can be allowed ?
>>
>> In this case we need to fail the request from the migration SW...
> _RESUMING to _SAVING seems like a good way to test round trip migration
> without running the device to modify the state.  Potentially it's a
> means to update a saved device migration data stream to a newer format
> using an intermediate driver version.

what do you mean by "without running the device to modify the state." ?

did you describe a case where you migrate from source to dst and then 
back to source with a new migration data format ?

>
> If a driver is written such that it simply sees clearing the _RESUME
> bit as an indicator to de-serialize the data stream to the device, and
> setting the _SAVING flag as an indicator to re-serialize that data
> stream from the device, then this is just a means to make use of
> existing data paths.
>
> The uAPI specifies a means for drivers to reject a state change, but
> that risks failing to support a transition which might find mainstream
> use cases.  I don't think common code should be responsible for
> filtering out viable transitions.  Thanks,
>
> Alex
>

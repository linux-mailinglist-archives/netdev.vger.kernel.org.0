Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE9F041C861
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 17:29:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345281AbhI2Pam (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 11:30:42 -0400
Received: from mail-bn1nam07on2080.outbound.protection.outlook.com ([40.107.212.80]:36485
        "EHLO NAM02-BN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1345157AbhI2Paj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Sep 2021 11:30:39 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M7yE+3O25T4AcrkFRBqwxab+KX2nsT8LFo6lq8rkahtgHo/9+TZgF2ua1P0Gd+v60H2EPNdfKul2CFDR1YvVj1vvv9VrVmqBwYVtD3NEN9xuUCKqjWyeXO1h39t8EfPt4RsbTOLs/481f5i1eRhbvwOorS7+gHruyLkwveAlc0N6rHyWBvx6FIGIgWSfJCt8DwnnC60JetQvqyOLD8JHQe5WlKFni/nfM/1cGB27c45+Pd67BTM0HZq5N+YGBW0XEUXvohSbJT6x/YD7HiegeL0hWFuypjmF1IwjmKTj+PuJd7wsAAogG+o/tVHM2MK6kY0egB6crnO4+Jlp4/1WYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=9eel/MIbwZKsfy83C/KpYV1scUursh64yFpzJy4PeKQ=;
 b=lyv2ynuSv0lVmB3vXaECbIdTHDo+AFW/tBnMBlWooAhfIzVBj5fN3LZuVzurbI+pbXlDEgo3I9cld8QAXpM1KZysaG0e7UiAIqaeAfXx/rC2LiX2hHsOEec340pk8unjco1L4WEmeLKkLgjDo+w25WYPPg4wrzH+FX1Lnl23fdwXs1mBCJ7UaNZj/0Af0EZivC2kqqEznrV7f88mLm0A9uGmoGqTm6Sd+T0FwupkodtPVzXEsQab01mR3RTjOHx0eRbjkMcyH43d2O4NGvOCABI8fhbdZorFOthTPO2pRcyTIryBaFESISNEEEj5gS4ut05ECSTIk1JOpJ8L+fNdsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9eel/MIbwZKsfy83C/KpYV1scUursh64yFpzJy4PeKQ=;
 b=kh+mws043f07pa63ABZmDmVH7BdpSuBmhXxzgkY+4x5EhmYIm54L14DintFozJ8ODV3MLWzvYM2kSMFAjzC1SMRWpSdIRSQEnd7F5aMKGhok0yY+jcB+Z7FnAgqnps4qP67pa8sqW/plRgDpwLkqLBwHcLVBlYvgIgx4Jc+on3rWChyIFG7jX5n7S05XHUhw2LouubuIJdJVhdvZgiKGHHbNVH+WpB+rAW559HH/jP9EF1Tl0n0hT7uSFVLaj76dPRmzqBEf0IGKQzsnHdURt3lbmHIu7+ccqPs0ss23V4ABpPj5HMUb2EVZC284CzwtpXQH55mDJMRgGP2g1hoAaQ==
Received: from BN9PR03CA0366.namprd03.prod.outlook.com (2603:10b6:408:f7::11)
 by DM5PR12MB1162.namprd12.prod.outlook.com (2603:10b6:3:72::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.14; Wed, 29 Sep
 2021 15:28:56 +0000
Received: from BN8NAM11FT060.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:f7:cafe::cc) by BN9PR03CA0366.outlook.office365.com
 (2603:10b6:408:f7::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.14 via Frontend
 Transport; Wed, 29 Sep 2021 15:28:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 BN8NAM11FT060.mail.protection.outlook.com (10.13.177.211) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4566.14 via Frontend Transport; Wed, 29 Sep 2021 15:28:55 +0000
Received: from DRHQMAIL107.nvidia.com (10.27.9.16) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 29 Sep
 2021 15:28:51 +0000
Received: from [172.27.14.186] (172.20.187.5) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 29 Sep
 2021 15:28:47 +0000
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
References: <cover.1632305919.git.leonro@nvidia.com>
 <c87f55d6fec77a22b110d3c9611744e6b28bba46.1632305919.git.leonro@nvidia.com>
 <20210927164648.1e2d49ac.alex.williamson@redhat.com>
 <20210927231239.GE3544071@ziepe.ca>
 <25c97be6-eb4a-fdc8-3ac1-5628073f0214@nvidia.com>
 <20210929063551.47590fbb.alex.williamson@redhat.com>
 <1eba059c-4743-4675-9f72-1a26b8f3c0f6@nvidia.com>
 <20210929075019.48d07deb.alex.williamson@redhat.com>
 <d2e94241-a146-c57d-cf81-8b7d8d00e62d@nvidia.com>
 <20210929091712.6390141c.alex.williamson@redhat.com>
From:   Max Gurtovoy <mgurtovoy@nvidia.com>
Message-ID: <e1ba006f-f181-0b89-822d-890396e81c7b@nvidia.com>
Date:   Wed, 29 Sep 2021 18:28:44 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20210929091712.6390141c.alex.williamson@redhat.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [172.20.187.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 DRHQMAIL107.nvidia.com (10.27.9.16)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c087cda9-6f94-4634-659e-08d9835dd9f1
X-MS-TrafficTypeDiagnostic: DM5PR12MB1162:
X-Microsoft-Antispam-PRVS: <DM5PR12MB1162DA3E7D855678B0EEA62EDEA99@DM5PR12MB1162.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JSYVwHFEk0SSay0hP518DVStgWGhJi7O2UKbHYtMXGv53QxFAO+U1lLjjn47hrwXgsN9EPC1kmck09bAwM3lEsxiIpQLJc39syA7eRXE4pb62B/3o5KAx0w/xFgKUnz6g6Ybjq+T4j+UZ4XVOP9B/BvxoL8ZCVTVShuBc9qhAd8GRknt9anLLKp8RaSilt2MlRcJgumDKIa1rPYMkZ7DDPdPGB0euhe3pYyOW9ypF/8vq5uoT3L5fQQ/Fp+feh8sP0jJQQb7OwxAu/rHSd9E2uaInSAmLhMun7jVvTKL7frw1m3o02QsTA65R0qcs8G+fXHfG6X3o1zk3jS1llaE6yfYSxmgtEOzq29vZTakphf6oAWQrp5SgDM0OF/rsvpS0eNC+5+cjByH+rKe2Neh/+xCyYMvWQBTCPLumwWXAbswW5alKOmD9Hj3qno2tkNzWXnfnvTre7w0WuOcpPRUvRc5IAZFSWvo+Gay+3/0ISpSVLegHexloutc6WlM81MKtbL4uIo4mWgVLm7N7McrWP9gBCV+F62XI3JmturCChaZ3cuWAFcqEt8sYHHYermULMcqDuWMoFCv5mSZspDOLkv/M1t0EcFbysXCYXd8gPqXh3J/TSi3xn84ogzuvXFvkPk3KBefenuslwjoexYEh2SOo3D0aV4vhV+uwItmK77V4FTv7udTzXszgR+syoYGczYnUaHkRz8gXv4LsrcVDwEOqQDckAF2XCU7BSlk+k0=
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid02.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(6916009)(47076005)(508600001)(82310400003)(356005)(16526019)(7636003)(5660300002)(36756003)(6666004)(54906003)(336012)(426003)(36860700001)(83380400001)(31696002)(8676002)(186003)(86362001)(2906002)(70206006)(70586007)(53546011)(2616005)(8936002)(26005)(316002)(16576012)(31686004)(7416002)(4326008)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2021 15:28:55.9719
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c087cda9-6f94-4634-659e-08d9835dd9f1
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT060.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1162
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 9/29/2021 6:17 PM, Alex Williamson wrote:
> On Wed, 29 Sep 2021 17:36:59 +0300
> Max Gurtovoy <mgurtovoy@nvidia.com> wrote:
>
>> On 9/29/2021 4:50 PM, Alex Williamson wrote:
>>> On Wed, 29 Sep 2021 16:26:55 +0300
>>> Max Gurtovoy <mgurtovoy@nvidia.com> wrote:
>>>   
>>>> On 9/29/2021 3:35 PM, Alex Williamson wrote:
>>>>> On Wed, 29 Sep 2021 13:44:10 +0300
>>>>> Max Gurtovoy <mgurtovoy@nvidia.com> wrote:
>>>>>      
>>>>>> On 9/28/2021 2:12 AM, Jason Gunthorpe wrote:
>>>>>>> On Mon, Sep 27, 2021 at 04:46:48PM -0600, Alex Williamson wrote:
>>>>>>>>> +	enum { MAX_STATE = VFIO_DEVICE_STATE_RESUMING };
>>>>>>>>> +	static const u8 vfio_from_state_table[MAX_STATE + 1][MAX_STATE + 1] = {
>>>>>>>>> +		[VFIO_DEVICE_STATE_STOP] = {
>>>>>>>>> +			[VFIO_DEVICE_STATE_RUNNING] = 1,
>>>>>>>>> +			[VFIO_DEVICE_STATE_RESUMING] = 1,
>>>>>>>>> +		},
>>>>>>>> Our state transition diagram is pretty weak on reachable transitions
>>>>>>>> out of the _STOP state, why do we select only these two as valid?
>>>>>>> I have no particular opinion on specific states here, however adding
>>>>>>> more states means more stuff for drivers to implement and more risk
>>>>>>> driver writers will mess up this uAPI.
>>>>>> _STOP == 000b => Device Stopped, not saving or resuming (from UAPI).
>>>>>>
>>>>>> This is the default initial state and not RUNNING.
>>>>>>
>>>>>> The user application should move device from STOP => RUNNING or STOP =>
>>>>>> RESUMING.
>>>>>>
>>>>>> Maybe we need to extend the comment in the UAPI file.
>>>>> include/uapi/linux/vfio.h:
>>>>> ...
>>>>>     *  +------- _RESUMING
>>>>>     *  |+------ _SAVING
>>>>>     *  ||+----- _RUNNING
>>>>>     *  |||
>>>>>     *  000b => Device Stopped, not saving or resuming
>>>>>     *  001b => Device running, which is the default state
>>>>>                                ^^^^^^^^^^^^^^^^^^^^^^^^^^
>>>>> ...
>>>>>     * State transitions:
>>>>>     *
>>>>>     *              _RESUMING  _RUNNING    Pre-copy    Stop-and-copy   _STOP
>>>>>     *                (100b)     (001b)     (011b)        (010b)       (000b)
>>>>>     * 0. Running or default state
>>>>>     *                             |
>>>>>                     ^^^^^^^^^^^^^
>>>>> ...
>>>>>     * 0. Default state of VFIO device is _RUNNING when the user application starts.
>>>>>          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>>>>>
>>>>> The uAPI is pretty clear here.  A default state of _STOP is not
>>>>> compatible with existing devices and userspace that does not support
>>>>> migration.  Thanks,
>>>> Why do you need this state machine for userspace that doesn't support
>>>> migration ?
>>> For userspace that doesn't support migration, there's one state,
>>> _RUNNING.  That's what we're trying to be compatible and consistent
>>> with.  Migration is an extension, not a base requirement.
>> Userspace without migration doesn't care about this state.
>>
>> We left with kernel now. vfio-pci today doesn't support migration, right
>> ? state is in theory is 0 (STOP).
>>
>> This state machine is controlled by the migration SW. The drivers don't
>> move state implicitly.
>>
>> mlx5-vfio-pci support migration and will work fine with non-migration SW
>> (it will stay with state = 0 unless someone will move it. but nobody
>> will) exactly like vfio-pci does today.
>>
>> So where is the problem ?
> So you have a device that's actively modifying its internal state,
> performing I/O, including DMA (thereby dirtying VM memory), all while
> in the _STOP state?  And you don't see this as a problem?

I don't see how is it different from vfio-pci situation.

And you said you're worried from compatibility. I can't see a 
compatibility issue here.

Maybe we need to rename STOP state. We can call it READY or LIVE or 
NON_MIGRATION_STATE.

>
> There's a major inconsistency if the migration interface is telling us
> something different than we can actually observe through the behavior of
> the device.  Thanks,
>
> Alex
>

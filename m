Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 690FB41D66B
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 11:34:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349421AbhI3JgM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 05:36:12 -0400
Received: from mail-co1nam11on2065.outbound.protection.outlook.com ([40.107.220.65]:5089
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235235AbhI3JgL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Sep 2021 05:36:11 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CECVZIJa+jWUKC5mRoMM0+j1Me1fcviTYFEAqe29yepcODQ1gVundG/CvveVN8BV6ZX7apqEnAfOzzhnQzPe4YkWzIFikqUpvu35o4j04UT2AsOKyTdvQhPysODBdULvYwnSnGYaZc2uAi3IU8AuX0YEwW/n451sgDf/bttTtJ7NM+5BwJ5+wE3It+zqIbVCUCtCQknTozvYuWZ1hyK70U8CmAdULo+0WNXPrN30AHcCQJfHtZKueAHS6+miuzSdkssXVzl32uSIjK40xbBoxKhT6pbZHIP4v5xUwgRU1wPU30mDL80w4q9TctTOUneVNwRp15uozQageYQ84abrGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=ijri/PxkXxKPdkZWJpqGwge79cWqWrLvK+Kv3RCmEok=;
 b=f5b8rN03f8PjdFartePM6cziQEp0TkqocSR+p9rOEhftNUBpbfQXJHoDaPEK3H3XIQ2fwFIkI6lrwkYx2aBUkLlUQAjuNfgm9dZlC5+axe2YdP+Qk3jioftVs9QhwMeITbOMuxvQofy6Ht8+1Mqp58vmQtUiXl9uk/+p5YZK3ZW/GBeBuYU5hrFltR5W+mt/XQC5+TgHgyPfH0cR6y8JwJt70kLirpi2/x2phVy/3JqGbZQnpl8w28nN3SbcDgaM2vCGPmcyT1aADQKYpclbXNmffQHFH12WOvKLosj9VP3vWuLA9LNV1lRS34NwGdUwWxWjiODu1JGGkFu4xht2xA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ijri/PxkXxKPdkZWJpqGwge79cWqWrLvK+Kv3RCmEok=;
 b=M1R17RfXl2bxAcUy4q7xVMbt3Naa8M4F6ZvEd2dAG2CDkPLp/o66EDSAfDrHmvIX8Lt2xqjmEq9b3S0Qzfcb4wHa7WnbCx//SSiOhWKxhAaenruecc7sedOTa1vCsqJ0ujFS3uOZQYVsIk1bppYZ1s0odoaPdpPmFHS8LfE3lLLe1khZczK3ndDsDmjbefnahDltI2MnMwf4YKKGBO4XnRDFqRmjDObhpdDlUr3Mt6ZJvwX9+3wc3lKTkIxwUUpOzwpsP0y4mP0tpSrsj5dmOqrJEXGcGJQlhnG7vWFC0eTH2ntCOU9CV034qKoW4u84QEmwyy4WVrLF5guf8w++0Q==
Received: from MW4P222CA0005.NAMP222.PROD.OUTLOOK.COM (2603:10b6:303:114::10)
 by BN6PR1201MB2528.namprd12.prod.outlook.com (2603:10b6:404:ae::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.13; Thu, 30 Sep
 2021 09:34:27 +0000
Received: from CO1NAM11FT054.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:114:cafe::bc) by MW4P222CA0005.outlook.office365.com
 (2603:10b6:303:114::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.15 via Frontend
 Transport; Thu, 30 Sep 2021 09:34:27 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 CO1NAM11FT054.mail.protection.outlook.com (10.13.174.70) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4566.14 via Frontend Transport; Thu, 30 Sep 2021 09:34:26 +0000
Received: from [172.27.13.136] (172.20.187.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 30 Sep
 2021 09:34:22 +0000
Subject: Re: [PATCH mlx5-next 2/7] vfio: Add an API to check migration state
 transition validity
To:     Jason Gunthorpe <jgg@ziepe.ca>
CC:     Alex Williamson <alex.williamson@redhat.com>,
        Leon Romanovsky <leon@kernel.org>,
        Doug Ledford <dledford@redhat.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Kirti Wankhede <kwankhede@nvidia.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-pci@vger.kernel.org>,
        <linux-rdma@vger.kernel.org>, <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>
References: <20210927231239.GE3544071@ziepe.ca>
 <25c97be6-eb4a-fdc8-3ac1-5628073f0214@nvidia.com>
 <20210929063551.47590fbb.alex.williamson@redhat.com>
 <1eba059c-4743-4675-9f72-1a26b8f3c0f6@nvidia.com>
 <20210929075019.48d07deb.alex.williamson@redhat.com>
 <d2e94241-a146-c57d-cf81-8b7d8d00e62d@nvidia.com>
 <20210929091712.6390141c.alex.williamson@redhat.com>
 <e1ba006f-f181-0b89-822d-890396e81c7b@nvidia.com>
 <20210929161433.GA1808627@ziepe.ca>
 <29835bf4-d094-ae6d-1a32-08e65847b52c@nvidia.com>
 <20210929232109.GC3544071@ziepe.ca>
From:   Max Gurtovoy <mgurtovoy@nvidia.com>
Message-ID: <d8324d96-c897-b914-16c6-ad0bbb9b13a5@nvidia.com>
Date:   Thu, 30 Sep 2021 12:34:19 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20210929232109.GC3544071@ziepe.ca>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [172.20.187.5]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9bb305a1-0fde-4212-7f44-08d983f57ece
X-MS-TrafficTypeDiagnostic: BN6PR1201MB2528:
X-Microsoft-Antispam-PRVS: <BN6PR1201MB25288A320723329A4C604AAFDEAA9@BN6PR1201MB2528.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: D67NUIGm3gOPpaR2rnYTD+ZBpR8tfg8hMqoTcm85T4PxGVErhrZDnJOkX6rkm8psbzDV/T8PyX7KSm8/glla40UGSkfr7T7Ve0+RNAouB5Q8yATvp0CUCV4rXWUysw1Od938Z0pmfFbDMQtZLJFF/eYCLbHykLtI1zuSB5qfBfLl9DSo+Z24gA4NkzTRlhAauDjoeU1dQbfGNZf3TDveuqDwHXdq0c/2eM2raaL5et4YujTw/KvyA54n2uRvsFkHsSQg55t89EddGTPHaH2U/l+y5KMGNWJMDdgjwO60nUndW9B+R7lWtaXkDgQC66x6IjWK4pqTzdnygnzncUOpvwP38WMTVyDvpQ4UfY18j0LTQ3Z7sHu/UtRwKpa56GZ3picMLZk65CONmJI/ea8aTkVg/mKyvRGi2hVu/24ZVFreTo7Zjyk/ZQG0oA448o0N/14kk1btBuLJu3zYmIz63Zln64psxPeChmzFYvQS9eXdAZ0/N81MEw/Jt73Yfd7AKlp9yTKlsllhz4n7wBv8l5w4fC1CI1ZHhKJWr1bVjDOPjJOgHlBx4gOUnMaDY3lZF/5zQmrMFanXVRV3bZobaaZGO9lADUaVZ/1TXSFBV3QrZnLeR8xCcRX8nG90RsHMHblkLRq1/ZRZj/NU49igg/xV5AXsnpiIjbowyvDQENM6s2QAiiMQ+vGpmojuK1LwDCJCubWkdtcjPex43sfRpYXAhd3ltk8HL4RnPJ3lukA=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(4326008)(8936002)(36756003)(8676002)(16526019)(86362001)(186003)(356005)(7636003)(36860700001)(426003)(6916009)(83380400001)(70586007)(70206006)(2616005)(7416002)(5660300002)(31686004)(53546011)(31696002)(47076005)(54906003)(26005)(2906002)(82310400003)(6666004)(316002)(508600001)(16576012)(336012)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2021 09:34:26.6271
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9bb305a1-0fde-4212-7f44-08d983f57ece
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT054.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR1201MB2528
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 9/30/2021 2:21 AM, Jason Gunthorpe wrote:
> On Thu, Sep 30, 2021 at 12:48:55AM +0300, Max Gurtovoy wrote:
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
> Yes, when a vfio_device first opens it must be running - ie able to do
> DMA and otherwise operational.

how can non resumed device do DMA ?

Also the bus master is not set.

>
> When we add the migration extension this cannot change, so after
> open_device() the device should be operational.

if it's waiting for incoming migration blob, it is not running.

>
> The reported state in the migration region should accurately reflect
> what the device is currently doing. If the device is operational then
> it must report running, not stopped.

STOP in migration meaning.

>
> Thus a driver cannot just zero initalize the migration "registers",
> they have to be accurate.
>
>>>> Maybe we need to rename STOP state. We can call it READY or LIVE or
>>>> NON_MIGRATION_STATE.
>>> It was a poor choice to use 000b as stop, but it doesn't really
>>> matter. The mlx5 driver should just pre-init this readable to running.
>> I guess we can do it for this reason. There is no functional problem nor
>> compatibility issue here as was mentioned.
>>
>> But still we need the kernel to track transitions. We don't want to allow
>> moving from RESUMING to SAVING state for example. How this transition can be
>> allowed ?
> It seems semantically fine to me, as per Alex's note what will happen
> is defined:
>
> driver will see RESUMING toggle off so it will trigger a
> de-serialization

You mean stop serialization ?

>
> driver will see SAVING toggled on so it will serialize the new state
> (either the pre-copy state or the post-copy state dpending on the
> running bit)

lets leave the bits and how you implement the state numbering aside.

If you finish resuming you can move to a new state (that we should add) 
=> RESUMED.

Now you suggested moving from RESUMED to SAVING to get the state again 
from the dst device ? and send it back to src ? before staring the VM 
and moving to RUNNING ?

where this is coming from ?

>
> Depending on the running bit the device may or may not be woken up.

lets take about logic here and not bits.

>
> If de-serialization fails then the state goes to error and SAVING is
> ignored.
>
> The driver logic probably looks something like this:
>
> // Running toggles off
> if (oldstate & RUNNING != newstate & RUNNING && oldstate & RUNNING)
>      queice
>      freeze
>
> // Resuming toggles off
> if (oldstate & RESUMING != newstate & RESUMING && oldstate & RESUMING)
>     deserialize
>
> // Saving toggles on
> if (oldstate & SAVING != newstate & SAVING && newstate & SAVING)
>     if (!(newstate & RUNNING))
>       serialize post copy
>
> // Running toggles on
> if (oldstate & RUNNING != newstate & RUNNING && newstate & RUNNING)
>     unfreeze
>     unqueice
>
> I'd have to check that carefully against the state chart from my last
> email though..
>
> And need to check how the "Stop Active Transactions" bit fits in there
>
> Jason

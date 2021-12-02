Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 582CA466123
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 11:06:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346286AbhLBKJe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 05:09:34 -0500
Received: from mail-dm6nam11on2057.outbound.protection.outlook.com ([40.107.223.57]:35041
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1346225AbhLBKJO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 Dec 2021 05:09:14 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fIeyL8n0TrVqPg1Wu5jxGgoAnPwb/qHtpyPyqBqQrqxu3vvhY/NhY3gBB5qdX8kILgnF6+SEslBmwn4dDKnOGIY9iZ0oXllrd2KvaQc0X1jekf+V5g2ZcU3XAJrb3ZwFzRE41zIasE1uT8BCoRX6kSNwa1DvBlRf8jSvwbBbMIprCNxlRitIN4RviS7m8a8oCYJQL6qbQnOjO1J1aRbNLZp8HNQMPhwAxefRiwEzGklbKtMpN6H7m4tZ8JSL/NIU1yEIohQm3VY8CEbMPMrw9pgTAwdOP20MkwhAq+gpIOreAxFxMo1mhPRD3ND/pNUmOoeDdtfKLZk2aNbI31G6WQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6kniN5onZ0ch8aUT+hKSWvvBAqTYZ4vgiceUigDTnGs=;
 b=ApffogKLZb7A3UCT2c/oo79yTubOBIx/ZSOekKwoBSeIJIjPhzIDWW0WQvP5alRp6nYA2zL5gmEiKuv+iiVRvsGazLatoeGtYoQyIWHUUPB5WU8EpaPn1VTWd/WNQyE5YgrlqYVHAeirfO/s3S85ySanWTh50P0NBqj6ciMI3Xy9cKMUVs6dQkvvNrC5joyvTHb9sdSE3sR1UVBCXpplEM2JiU6971OxtqmLBwP4p1XsSvwGropvU1l9fHfLjIdYKvEDTa7g4emUeykF9olZs6kQp2TahcVOGw0NX1/VruxBf/qft3wlQT8FwQffgG78oFV2tct5CpI8WIrgzIeesg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.36) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6kniN5onZ0ch8aUT+hKSWvvBAqTYZ4vgiceUigDTnGs=;
 b=Xw/EdqyUSjULKBYV05mzkPjmVLSXohQTehYb8ayKELHRI2vED1C/mBczU26aqhGHgCaVGQ/6VoWFIEE8Gg6yRC7SAs9IzuNmNsQA0pcYdwI9XzyjVI4UFhEeVH3fVKUl7Q2XvaPKLQcWz/m4PtpYe/KKfzGPYrTkxvh2fhYiKvM7n/JHq3jQXs51nuLV0Ucu9NAh41Fih6azCeprJkUDgujMGXbQm3zC4B5X6d5plQBvPcHvntmf1HsJ57Z7JGTyFJwbbFQm3mai03IQSy79wdZXIq6NAwIgJCk4r7kY8CXU96Djz2Hlj9t6ZR+A4eJVW2MqOe9cNnpDfFllKaMYAQ==
Received: from BN9PR03CA0347.namprd03.prod.outlook.com (2603:10b6:408:f6::22)
 by CH0PR12MB5057.namprd12.prod.outlook.com (2603:10b6:610:e0::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.11; Thu, 2 Dec
 2021 10:05:51 +0000
Received: from BN8NAM11FT007.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:f6:cafe::d2) by BN9PR03CA0347.outlook.office365.com
 (2603:10b6:408:f6::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.22 via Frontend
 Transport; Thu, 2 Dec 2021 10:05:50 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.36)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.36 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.36; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.36) by
 BN8NAM11FT007.mail.protection.outlook.com (10.13.177.109) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4755.13 via Frontend Transport; Thu, 2 Dec 2021 10:05:50 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 2 Dec
 2021 10:05:49 +0000
Received: from [172.27.1.92] (172.20.187.5) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.986.9; Thu, 2 Dec 2021
 02:05:46 -0800
Message-ID: <c8cf2b24-c790-fa70-c2c5-474201743b4d@nvidia.com>
Date:   Thu, 2 Dec 2021 12:05:42 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: Regression in v5.16-rc1: Timeout in mlx5_health_wait_pci_up() may
 try to wait 245 million years
Content-Language: en-US
To:     Thorsten Leemhuis <regressions@leemhuis.info>,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        Amir Tzin <amirtz@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
CC:     netdev <netdev@vger.kernel.org>, <regressions@lists.linux.dev>,
        linux-s390 <linux-s390@vger.kernel.org>
References: <15db9c1d11d32fb16269afceb527b5d743177ac4.camel@linux.ibm.com>
 <129f5e00-db76-3230-75a5-243e8cd5beb0@nvidia.com>
 <68f2163e-63a2-c6dd-1491-fd748a92ac36@leemhuis.info>
From:   Moshe Shemesh <moshe@nvidia.com>
In-Reply-To: <68f2163e-63a2-c6dd-1491-fd748a92ac36@leemhuis.info>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.20.187.5]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f37a891a-f956-44be-57b6-08d9b57b51cd
X-MS-TrafficTypeDiagnostic: CH0PR12MB5057:
X-Microsoft-Antispam-PRVS: <CH0PR12MB505773BD4267A1C1019A5447D4699@CH0PR12MB5057.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 48BuVsHeLiWUehjfiq++rc0UyKLxPDJL4vv5HOpJE0I+ewWEv81KwjndmtEOLdB9yaKPDPeOO+8ix9feQx67UO6MYUM3egPq6b9weq37Pb4BTLflC2ezP6FS9ABcfdQeIsgqSVBJH+53yPNlBdcq/oV8y9w8sBMDe7zRDo7r8Q5zOF/kJ0hNhIhg49myLCX9Pcr44rx4nIQO3e6nr+hLdCY3hs390ot3vwVVPj+sxB/C4bQCGDWGAuGg13SdsRFLxGm4faGDx9BnB3M06QjGusJCFn6obO8V4vWJutKDwmmXHcGz4KXCWrOLkkCMlqH23PGYX+PvZu3i3jGgynEUoTTrJod1hl7BVoeoAe6nsBoAIxFsqAStkTFmCbwHkPjRU8vOmI+cGn5H34+uspw8cpMQ3aBoSXWNREXTruKWqWOkPmxA1N/EvOsezdBDdRFMEJtd7Uj6t1VBy4ddYERXTkYDqznSk1LDm8LGqCTRewg9YFl1NQXvZTrZ2oZDPykPmQlk217GJ5VLLKMjfHCJsU+jw2ZzFDE+vvSj6M0rkXIKRj8MBuE6rG1fkX/uNIBaQuK/ZKiHImqiOeIlFB6UxS35O6GLXpnm7kN8orHAw+B42jnVpmaJoP6Xwk4kaYROjYgzV1Rus8mStWtgd1Jpbb4vJA0qhXjv5wAVGiNtHG8kNwy5smw54b/TsLEBckTUINN4hQELPI1KkmFdLJBdm0T9OW9+ayeEh9m8fvjcGhBrSZHOA5qHiMD/W2lnlgxKezPg6FHkohNU99S7plAMaZeEaPUn2yMrakMlDZscB053i9HOt1UTC75maHfBX5IzMITvGws9tXZ8JDKdHSWvs1g43C8gS8cT5A9GRkW2Dvg5g5oDvtuf+9B4fqw9PHaw
X-Forefront-Antispam-Report: CIP:216.228.112.36;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid05.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(40470700001)(36756003)(31686004)(16576012)(4326008)(8936002)(16526019)(70586007)(6666004)(53546011)(47076005)(70206006)(6636002)(83380400001)(316002)(508600001)(45080400002)(336012)(2616005)(2906002)(426003)(186003)(82310400004)(86362001)(356005)(110136005)(5660300002)(26005)(31696002)(8676002)(40460700001)(7636003)(54906003)(36860700001)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Dec 2021 10:05:50.5777
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f37a891a-f956-44be-57b6-08d9b57b51cd
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.36];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT007.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5057
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 12/2/2021 8:52 AM, Thorsten Leemhuis wrote:
> External email: Use caution opening links or attachments
>
>
> Hi, this is your Linux kernel regression tracker speaking.
>
> On 20.11.21 17:38, Moshe Shemesh wrote:
>> Thank you for reporting Niklas.
>>
>> This is actually a case of use after free, as following that patch the
>> recovery flow goes through mlx5_tout_cleanup() while timeouts structure
>> is still needed in this flow.
>>
>> We know the root cause and will send a fix.
> That was twelve days ago, thus allow me asking: has any progress been
> made? I could not find any with a quick search on lore.


Yes, fix was submitted by Saeed yesterday, title: "[net 10/13] net/mlx5: 
Fix use after free in mlx5_health_wait_pci_up".

> Ciao, Thorsten
>
>> On 11/19/2021 12:58 PM, Niklas Schnelle wrote:
>>> Hello Amir, Moshe, and Saeed,
>>>
>>> (resent due to wrong netdev mailing list address, sorry about that)
>>>
>>> During testing of PCI device recovery, I found a problem in the mlx5
>>> recovery support introduced in v5.16-rc1 by commit 32def4120e48
>>> ("net/mlx5: Read timeout values from DTOR"). It follows my analysis of
>>> the problem.
>>>
>>> When the device is in an error state, at least on s390 but I believe
>>> also on other systems, it is isolated and all PCI MMIO reads return
>>> 0xff. This is detected by your driver and it will immediately attempt
>>> to recovery the device with a mlx5_core driver specific recovery
>>> mechanism. Since at this point no reset has been done that would take
>>> the device out of isolation this will of course fail as it can't
>>> communicate with the device. Under normal circumstances this reset
>>> would happen later during the new recovery flow introduced in
>>> 4cdf2f4e24ff ("s390/pci: implement minimal PCI error recovery") once
>>> firmware has done their side of the recovery allowing that to succeed
>>> once the driver specific recovery has failed.
>>>
>>> With v5.16-rc1 however the driver specific recovery gets stuck holding
>>> locks which will block our recovery. Without our recovery mechanism
>>> this can also be seen by "echo 1 > /sys/bus/pci/devices/<dev>/remove"
>>> which hangs on the device lock forever.
>>>
>>> Digging into this I tracked the problem down to
>>> mlx5_health_wait_pci_up() hangig. I added a debug print to it and it
>>> turns out that with the device isolated mlx5_tout_ms(dev, FW_RESET)
>>> returns 774039849367420401 (0x6B...6B) milliseconds and we try to wait
>>> 245 million years. After reverting that commit things work again,
>>> though of course the driver specific recovery flow will still fail
>>> before ours can kick in and finally succeed.
>>>
>>> Thanks,
>>> Niklas Schnelle
>>>
>>> #regzbot introduced: 32def4120e48
>>>
>>
> P.S.: As a Linux kernel regression tracker I'm getting a lot of reports
> on my table. I can only look briefly into most of them. Unfortunately
> therefore I sometimes will get things wrong or miss something important.
> I hope that's not the case here; if you think it is, don't hesitate to
> tell me about it in a public reply. That's in everyone's interest, as
> what I wrote above might be misleading to everyone reading this; any
> suggestion I gave they thus might sent someone reading this down the
> wrong rabbit hole, which none of us wants.
>
> BTW, I have no personal interest in this issue, which is tracked using
> regzbot, my Linux kernel regression tracking bot
> (https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Flinux-regtracking.leemhuis.info%2Fregzbot%2F&amp;data=04%7C01%7Cmoshe%40nvidia.com%7C33857ebcf13946a09c6408d9b5605f19%7C43083d15727340c1b7db39efd9ccc17a%7C0%7C0%7C637740248366231179%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C2000&amp;sdata=Fuqme7inI68fhvGfPh2WPzvussq1awkqxFLqKHm%2FSmQ%3D&amp;reserved=0). I'm only posting
> this mail to get things rolling again and hence don't need to be CC on
> all further activities wrt to this regression.
>
> #regzbot poke

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A61F41DF99
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 18:51:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352417AbhI3QxT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 12:53:19 -0400
Received: from mail-bn8nam08on2042.outbound.protection.outlook.com ([40.107.100.42]:36032
        "EHLO NAM04-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1352419AbhI3QxO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Sep 2021 12:53:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S3Xi0VYnMy4oEUtXZrx7WX/w8DQYaOZ6DonHHz3qBtIVoy6TN34Yea2KAYHDq+DRBAb4yLg7U+oBk49N8t/t1x4AhKHT6FLfWhLNeRROT3iKc3GwJ746LhKMkor08AS2dMSDALqc5thsFhEiPLq38dBqyrwV2CbwUfYqYlvzp8tO0JdS6MtBUlM0H5EsCENlyomTsMGgXxOiYcnYwG4tvMS089WXSmwTM3+k6m6x/XOZyZx5mOr/JF+66i9pyzolsHTiIjotTmxK1x2OzjtgGgB01qMz9nLpHTSvoyo9UK4d+bJCDbkJjw9d13g9+V3DMtX4jkW1IpWOJQtJ3FRlPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=C+Vdy5kiiDYxQAWolO6PXlgR52bLolA6OuKiabJWXUY=;
 b=cMi6xKBFVVfFun08+riZSD34orOeMEAvClugIyyschFP/IHEs4pKa0GZv8qh5Jcd29UOQ7XDcniqOY1sGV04Gz9rIO2PKMPpndmKhdbn+AXHG+0O4E4df5zRIg2LUTv4iYYg2fBdpUk6U0XtPTRioPianjTDjXgt+y8uoEu4SZlbjgkrXzYPitV6fT745WAvuKZS82P8sa8hDgCp8MJGuHKHzg6RmxkXRoPWMpiGQCWcs3BkG1k6Qye0/fXmoWhXnx4VqXK9kAE+5t61CTWT9fRaRMA8v6dAOiywyqZva43AfFIncPdyT9RAJ+0R/3UasW51IolhbePCl2lPm1K5PA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C+Vdy5kiiDYxQAWolO6PXlgR52bLolA6OuKiabJWXUY=;
 b=oINJYTyCRR/DY2OgDEuWsFoAL3K5XLB0+szf4q3qKrXGpFMQUfVI03BycWy5c+yOatlqJfAvE45GYga9AwLmrUyW4k8aAvFyVSlZGaYzdYpQXWNG6afl6Vs3dRAO/VU31LGMSK8OtNaCbdpx+O3fgH++PMp3XpBLPiel3NmKErKZ2v59g164blrAdaYkyxryNfNczIhhtowm1SmKI8NXoxqi+UyelQJ8N/sFj+ACDNjNMU7ES1XVMfeCxqRvi/d7GY3EINeXy9G+Ku5i+gQwMP0ahxsUZUfihD2WkmYltPOEebVO4qtrA3Wu7ymUXU/0T8zy3ke1jhQzePJWB05T6w==
Received: from DM5PR20CA0041.namprd20.prod.outlook.com (2603:10b6:3:13d::27)
 by DM5PR1201MB0217.namprd12.prod.outlook.com (2603:10b6:4:54::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.14; Thu, 30 Sep
 2021 16:51:29 +0000
Received: from DM6NAM11FT027.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:13d:cafe::15) by DM5PR20CA0041.outlook.office365.com
 (2603:10b6:3:13d::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.13 via Frontend
 Transport; Thu, 30 Sep 2021 16:51:29 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT027.mail.protection.outlook.com (10.13.172.205) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4566.14 via Frontend Transport; Thu, 30 Sep 2021 16:51:29 +0000
Received: from [172.27.13.136] (172.20.187.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 30 Sep
 2021 16:51:25 +0000
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
References: <20210929075019.48d07deb.alex.williamson@redhat.com>
 <d2e94241-a146-c57d-cf81-8b7d8d00e62d@nvidia.com>
 <20210929091712.6390141c.alex.williamson@redhat.com>
 <e1ba006f-f181-0b89-822d-890396e81c7b@nvidia.com>
 <20210929161433.GA1808627@ziepe.ca>
 <29835bf4-d094-ae6d-1a32-08e65847b52c@nvidia.com>
 <20210929232109.GC3544071@ziepe.ca>
 <d8324d96-c897-b914-16c6-ad0bbb9b13a5@nvidia.com>
 <20210930144752.GA67618@ziepe.ca>
 <d5b68bb7-d4d3-e9d8-1834-dba505bb8595@nvidia.com>
 <20210930162442.GB67618@ziepe.ca>
From:   Max Gurtovoy <mgurtovoy@nvidia.com>
Message-ID: <c7a18080-3ffc-488b-577c-1e3b356bf66e@nvidia.com>
Date:   Thu, 30 Sep 2021 19:51:22 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20210930162442.GB67618@ziepe.ca>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [172.20.187.5]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c64e0dfd-630b-4e26-2350-08d984328cb6
X-MS-TrafficTypeDiagnostic: DM5PR1201MB0217:
X-Microsoft-Antispam-PRVS: <DM5PR1201MB0217228F28BB847CEA8FBAD3DEAA9@DM5PR1201MB0217.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LMzFQaKWXumMt5+hX2d3jdplGEdX2SxJp15vBAjgaVhXnw7ruKiJo+aUhKX0CG16PweCkUWXPAiEPbtU+xmid2vHxvmF7v61EnZXn7Tp2OkWemRMfkhhv0sSnNcqlE0m8iWxvTsp5m3YYamWdzZ1YBNDw/nGQmYbQIaJ3Fg4UY2IKEdjQlJwHHI5EBW22iBv3ulriQGBq26eq6T6lGS8OXfSdHQX5Z2QNvTULEsKz92AK2L96kY5WmIS3Dowx/9HgstZ/GIiRTD2jCtW+lDpI0oRyDcpfeHSoWXeerm671nz8PIjeECYoysh9MZTuMq/B3ZZKscyeUKbvmphy2CnGgK1PoRBNHrH6hjMfxFX01aJqORguhXr7rW3Nu2Z6bPlLXVmvCqk7dJSI3LnzPFte5fETHhiGg/ImBjwSUOFq3ycoyuIwjMPHHvQ33UswrZ1FArKAw+amf1+Aw8KjmW9eEkgajVHgKCtuqaptZ+a4MyhEAxjGL+AIb4x/oLnBD2o7w62FPm1nteHjvoo9iAWYMnIbzRs0Rv4b91m3f1TO4RB4cJtgCYZUbL87SE290RTj0V5oeLCeA/6UNiMABmLaYimiYTWGvnbiIAR0u+/Et0I+50+Ab15TEwbnqJS9FpWYmyDG9VpdWl8kVLHV5aAmmGZyO4hthjZ2y5/S/BtQS/N7H5I2MrQVaFYr3vBJlhgk5ErcdOSiFLSGUF9uj5KehWV/Z6FH+pGscbnswTB8dE=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(16526019)(7636003)(5660300002)(31686004)(36860700001)(7416002)(8676002)(426003)(86362001)(2616005)(186003)(4326008)(316002)(36756003)(31696002)(6666004)(356005)(6916009)(16576012)(336012)(82310400003)(47076005)(8936002)(54906003)(26005)(53546011)(2906002)(508600001)(83380400001)(70586007)(70206006)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2021 16:51:29.2505
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c64e0dfd-630b-4e26-2350-08d984328cb6
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT027.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1201MB0217
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 9/30/2021 7:24 PM, Jason Gunthorpe wrote:
> On Thu, Sep 30, 2021 at 06:32:07PM +0300, Max Gurtovoy wrote:
>>> Just prior to open device the vfio pci layer will generate a FLR to
>>> the function so we expect that post open_device has a fresh from reset
>>> fully running device state.
>> running also mean that the device doesn't have a clue on its internal state
>> ? or running means unfreezed and unquiesced ?
> The device just got FLR'd and it should be in a clean state and
> operating. Think the VM is booting for the first time.

During the resume phase in the dst, the VM is paused and not booting. 
Migration SW is waiting to get memory and state from SRC. The device 
will start from the exact point that was in the src.

it's exactly "000b => Device Stopped, not saving or resuming"

>
>>>>> driver will see RESUMING toggle off so it will trigger a
>>>>> de-serialization
>>>> You mean stop serialization ?
>>> No, I mean it will take all the migration data that has been uploaded
>>> through the migration region and de-serialize it into active device
>>> state.
>> you should feed the device way before that.
> I don't know what this means, when the resuming bit is set the
> migration data buffer is wiped and userspace should beging loading
> it. When the resuming bit is cleared whatever is in the migration
> buffer is deserialized into the current device internal state.

Well, this is your design for the driver implementation. Nobody is 
preventing other drivers to start deserializing device state into the 
device during RESUMING bit on.

Or is this a must ?

>
> It is the opposite of saving. When the saving bit is set the current
> device state is serialized into the migration buffer and userspace and
> reads it out.

This is not new.

>> 1. you initialize at  _RUNNING bit == 001b. No problem.
>>
>> 2. state stream arrives, migration SW raise _RESUMING bit. should it be 101b
>> or 100b ? for now it's 100b. But according to your statement is should be
>> 101b (invalid today) since device state can change. right ?
> Running means the device state chanages independently, the controlled
> change of the device state via deserializing the migration buffer is
> different. Both running and saving commands need running to be zero.
>
> ie commands that are marked invalid in the uapi comment are rejected
> at the start - and that is probably the core helper we should provide.
>
>> 3. Then you should indicate that all the state was serialized to the device
>> (actually to all the pci devices). 100b mean RESUMING and not RUNNING so
>> maybe this can say RESUMED and state can't change now ?
> State is not loaded into the device until the resuming bit is
> cleared. There is no RESUMED state until we incorporate Artem's
> proposal for an additional bit eg 1001b - running with DMA master
> disabled.

So if we moved from 100b to 010b somehow, one should deserialized its 
buffer to the device, and then serialize it to migration region again ?

I guess its doable since the device is freeze and quiesced. But moving 
from 100b to 011b is not possible, right ?

>
> Jason

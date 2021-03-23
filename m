Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6B5A346677
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 18:35:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230196AbhCWRev (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Mar 2021 13:34:51 -0400
Received: from mail-bn8nam11on2048.outbound.protection.outlook.com ([40.107.236.48]:56544
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230218AbhCWRem (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Mar 2021 13:34:42 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WQOjaTC4k2YrzlB3M90PNi8bfMsdZSDqM7wG+LmOqXrHt2KIWc/bsoxxy+oNSYT7NG8SXNHlhZ8MZJSgHFh6KyRMx0yo9HCKOhA3RmxrEC1HLndu+d6VKxBRWQdUrpSrQZfZlHSCvQ5qFKhwefVjXpdkvd1ULTXI4gkdCf1BR34O31cwmqetpCHSPyLtGJpzui2ivhEN9rbvbmkFtp+/JEsYWMgSt/G8V3n7IaG59wsvnQv0F9o0V6qrngudJAmUvX8tnnPd2iFr0YyubUXBLqUQHWN5xmUaXGbHAMQ8iCW0zB8wIMg4r8+AC5WlTUaZLM+q7iGgtEcwb0cy6yOc5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FIUCOLDTBnMUwbluoTqcorLOSztKzV1R7pEd3hO7RJY=;
 b=HoO5llBx5dM24G2jOvnzECNeO7OTZZNRuLB0GwSV6WGV1Mo8yPv5BxiMt9/BuVYIYdjmO5bcV8p+dTaixEbclXVjD1AP1DF9PisifBRAvIY5gVpmLxWnIYpike53a1G2uLMOf1vnS8NvLOskw4bPd3POIgWIL89LG0hC/nqsY9jyCmlH7944VS35ICbse8EUhvnlqxMGXqXIUJ5FEQ4nduGAKIjQKCg8uhaUNMt7NX1u5qRm+bhnkVPddc4WCuTPCYuwTkZ03WMATfYb70vSGbk6soycD1N+J48jz7d67iCWc3mk6PscOjVgcDBtLocNbSzTPNUFm92Aw+1Q+0pfAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FIUCOLDTBnMUwbluoTqcorLOSztKzV1R7pEd3hO7RJY=;
 b=BxZWmLVBWtmZCCd60T5GR0j0P6ueyrxkU+i1lt4rc4mIs83y2OkQP6f+5g03PyV64UXQsgH+EGZ8xeMpDCup2GIbAvWOYeTZDBMDJdV75Vz7WcA8r0kIUAY0NL07+P7JI9dQk1aocTbZnll1Yh73VDk5SPCq5TQeE2zwC2AABSaGWlCCa1k1LvvAvv8viJn+3sTWP2WSA7yfOk2mTBwrdzLeqH2OgLe+fpjaqE16ZGQCA3BkgLJj5RqosMzuczgrvadbk7MNj3MgOO9RrV+aGZFXWB2rOGKm4VFKZqeGl4LghYFCPkk6IAe/o+YKFYexQSAciFR8/ZOdvtGyxLyG8g==
Received: from DM5PR05CA0016.namprd05.prod.outlook.com (2603:10b6:3:d4::26) by
 MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.24; Tue, 23 Mar
 2021 17:34:40 +0000
Received: from DM6NAM11FT006.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:d4:cafe::fa) by DM5PR05CA0016.outlook.office365.com
 (2603:10b6:3:d4::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.10 via Frontend
 Transport; Tue, 23 Mar 2021 17:34:40 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT006.mail.protection.outlook.com (10.13.173.104) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3955.18 via Frontend Transport; Tue, 23 Mar 2021 17:34:40 +0000
Received: from [172.27.0.234] (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 23 Mar
 2021 17:34:36 +0000
Subject: Re: [RFC PATCH net] bonding: Work around lockdep_is_held false
 positives
To:     Leon Romanovsky <leon@kernel.org>
CC:     Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Mahesh Bandewar <maheshb@google.com>,
        Nikolay Aleksandrov <nikolay@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Tariq Toukan <tariqt@nvidia.com>, <netdev@vger.kernel.org>
References: <20210322123846.3024549-1-maximmi@nvidia.com>
 <YFilJZOraCqD0mVj@unreal>
From:   Maxim Mikityanskiy <maximmi@nvidia.com>
Message-ID: <0f3add4c-45a4-d3cd-96a3-70c1f0e96ee2@nvidia.com>
Date:   Tue, 23 Mar 2021 19:34:32 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <YFilJZOraCqD0mVj@unreal>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1238146f-28aa-49ae-402c-08d8ee21f020
X-MS-TrafficTypeDiagnostic: MN2PR12MB4192:
X-Microsoft-Antispam-PRVS: <MN2PR12MB419206C4191EE1C7A703BF84DC649@MN2PR12MB4192.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Nl/BmDabm3HrFPG9ZYuthqAhxquCfwVzoLW+xfyuB7u1Gy5iv56LjVibjmiUakkPRm6NBhSzQ+iHelDw/12+6lM32kE7O9SOK65bm3o5L/33zyIsm5w8GFWvZx3i7i9u2mMO0Dk1DYfJv+0iYYbBRj0cX7SO+a7s5JHBBlenf3TaLPsrweIBorttN+elM0iz0fbvRpxZj0MQ/6PpeEx+2ItTpHeJo1QtxVheQJaGyEyBHHtSRcaM+LT3oOo7TZicPBhK3HnateylDX3rYO/CrOvaqTrpg0CCbeuKsRyOTpFLlODb5KESAFnDijxvn8AQfcHm28JC5gXxPctY6bQo7KlRro1pUA70xEkFcXXQBBVHkCO9UJNNd9j4PlAGRJONkGIgPo+eRQQHaM87ygVIAs46N4qdn4XBH06DjHi1eSPvMOSYSKggcY7ihVy1IwRNQuMvLDf4t8UnOcp6VmxKOLPZ+f5xoxfyQAaRchcDwQs+uCB5EBc5AXlponJT+gfTl8ecw9J42AnSvHIvLmBjeIyzuh/6v7h9d7Abk3CrS0xNCl/VQV4jHy6xzRT+tGLtsQvR5fs7GVw5jlWFQDaYFpR+y+zojdYoo7ubyd3xLnAGJtsL9arqUeRrxpOY13B2CMMuU99EPazWTFnXZKvf/O+GYsdlzWwIyEjh1JufxMyPzZkJ8T0ny03qIPi4ZsIipj/F3VeRcegukfrPfCzUk9qI/6E5yq8oziqVZn5mBt+nQYu/hMJe9m6JoMsdLIIhekoeFNBFCiwYHmhs40AZZQ==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(396003)(346002)(376002)(39850400004)(136003)(46966006)(36840700001)(70586007)(31686004)(6916009)(6666004)(31696002)(4326008)(8936002)(186003)(5660300002)(83380400001)(82310400003)(70206006)(8676002)(36756003)(16576012)(316002)(26005)(2616005)(426003)(36906005)(2906002)(54906003)(36860700001)(478600001)(7636003)(356005)(47076005)(16526019)(53546011)(86362001)(966005)(336012)(82740400003)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Mar 2021 17:34:40.1852
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1238146f-28aa-49ae-402c-08d8ee21f020
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT006.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4192
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-03-22 16:09, Leon Romanovsky wrote:
> On Mon, Mar 22, 2021 at 02:38:46PM +0200, Maxim Mikityanskiy wrote:
>> After lockdep gets triggered for the first time, it gets disabled, and
>> lockdep_enabled() will return false. It will affect lockdep_is_held(),
>> which will start returning true all the time. Normally, it just disables
>> checks that expect a lock to be held. However, the bonding code checks
>> that a lock is NOT held, which triggers a false positive in WARN_ON.
>>
>> This commit addresses the issue by replacing lockdep_is_held with
>> spin_is_locked, which should have the same effect, but without suffering
>> from disabling lockdep.
>>
>> Fixes: ee6377147409 ("bonding: Simplify the xmit function for modes that use xmit_hash")
>> Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
>> Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
>> ---
>> While this patch works around the issue, I would like to discuss better
>> options. Another straightforward approach is to extend lockdep API with
>> lockdep_is_not_held(), which will be basically !lockdep_is_held() when
>> lockdep is enabled, but will return true when !lockdep_enabled().
> 
> lockdep_assert_not_held() was added in this cycle to tip: locking/core
> https://yhbt.net/lore/all/161475935945.20312.2870945278690244669.tip-bot2@tip-bot2/
> https://yhbt.net/lore/all/878s779s9f.fsf@codeaurora.org/

Thanks for this suggestion - I wasn't aware that this macro was recently 
added and I could use it instead of spin_is_locked.

Still, I would like to figure out why the bonding code does this test at 
all. This lock is not taken by bond_update_slave_arr() itself, so why is 
that a problem in this code?

> Thanks
> 


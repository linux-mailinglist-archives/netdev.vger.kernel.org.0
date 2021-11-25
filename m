Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B476545D950
	for <lists+netdev@lfdr.de>; Thu, 25 Nov 2021 12:35:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237344AbhKYLi3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Nov 2021 06:38:29 -0500
Received: from mail-mw2nam12on2070.outbound.protection.outlook.com ([40.107.244.70]:25298
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229597AbhKYLg2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Nov 2021 06:36:28 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cS7vesFKttigNgGTTMFqS1NLdg0TnQ/s0HIKg2uPFVdRe4TrN05DjVcACfDkrXcV1KTWysnHjJ4QSkUoxMtAYPL/OenLqw9rN4WR/thaAW6JdoZwulfBKbJrFP7mHmjtdN3hoY7zoCx05HsIPebHvXiP4CfQrc/YDW+DP/aaQX9N0ocPuf/YlN7pAcUsGittKoqAxEeacOj4eGjjyIyhkp4+Y2hu8TUpt/5X71dUDXR52xNgSMvriwdf+1HLU29rK4EZ9PPPU0TmqPIj2jg2xPEP2d23msZNVQLgbZKSOVvjJ41DTWPssR70GtosF55IR2gFbM5fdWAD68WlClFW5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3lsX5ZNoQEp2Ab7SbZI7MpJFvaF9dXgi9S+TUtT/Whc=;
 b=mV3SelaAwJZMCietECHHpPLuF3P4seeHS/N/7kyaOrjBHSLLIGf8GG0zKHZHWy94JPZQZXU/IL7Xzix/kU4EDldgOi7IbpC1hqq+be3yfgHjDUUNOLZssEReYGAV04XuM1gzOjQln9B6F/GZmiRHn0WiuXIGu6lCRK542AqGyZ+kdZirYRFtyPz+PTeFdYfKx3+0TbazbHIftlYYKK1b2Cx85k28raBbJG5/eie4Tnz65YgcewwuT0zL+/LNd/4hCQURZERVUFZUlVSaBkBnJ9kZZQjuAE+vr7/w67gpv5izOobPDkkSqyfJqCjxbuRLfSek8L70du0M6O3qD5SkNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3lsX5ZNoQEp2Ab7SbZI7MpJFvaF9dXgi9S+TUtT/Whc=;
 b=AHHdqyxY7t/4NSUKYOi3DSibVHrm42OcDLDXK93QKosjzyw9TqYWDmZbpg5+6zfjhei8pouwCGvvavuVtb/kSwZ405nCV0+8s+uYfjmYaf0wernxnFu60i3aOxRKeF3Cn3kE/2x6PifYlOdU9vONFBTNsgjUIEXvEqRYf3LgdPhhVODJcDqGUMryf1q5vWmE8Aay0x1nI/6vjdajoZgxBCAZ5eod6PjcUP5KGC82Tv8QSZrR6I2qHXSk/4S5whK2IRHjyf1UjcLvPfC59ReZB+40De6lxsqrwjG4dsjquvTJcM/TWfgn9Vyx8kcRej3lKXvpq2cWJ4FbScG+xVJP0A==
Received: from CO1PR15CA0094.namprd15.prod.outlook.com (2603:10b6:101:21::14)
 by SA1PR12MB5587.namprd12.prod.outlook.com (2603:10b6:806:232::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14; Thu, 25 Nov
 2021 11:33:15 +0000
Received: from CO1NAM11FT015.eop-nam11.prod.protection.outlook.com
 (2603:10b6:101:21:cafe::7a) by CO1PR15CA0094.outlook.office365.com
 (2603:10b6:101:21::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.22 via Frontend
 Transport; Thu, 25 Nov 2021 11:33:15 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 CO1NAM11FT015.mail.protection.outlook.com (10.13.175.130) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4734.22 via Frontend Transport; Thu, 25 Nov 2021 11:33:15 +0000
Received: from yaviefel (172.20.187.6) by HQMAIL107.nvidia.com (172.20.187.13)
 with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 25 Nov 2021 11:33:13
 +0000
References: <20211102021218.955277-1-william.xuanziyang@huawei.com>
 <87k0h9bb9x.fsf@nvidia.com>
 <20211115094940.138d86dc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <87a6i3t2zg.fsf@nvidia.com>
 <7f7cbbec-8c4e-a2dc-787b-570d1049a6b4@huawei.com>
 <20211118061735.5357f739@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <c240e0e0-256c-698b-4a98-47490869faa3@huawei.com>
 <8735nstq62.fsf@nvidia.com>
 <daae2fe3-997c-a390-afae-15ff33ba3d1c@huawei.com>
 <87k0gzrqw8.fsf@nvidia.com>
User-agent: mu4e 1.4.15; emacs 27.2
From:   Petr Machata <petrm@nvidia.com>
To:     Petr Machata <petrm@nvidia.com>
CC:     "Ziyang Xuan (William)" <william.xuanziyang@huawei.com>,
        Jakub Kicinski <kuba@kernel.org>, <davem@davemloft.net>,
        <jgg@nvidia.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net v2] net: vlan: fix a UAF in vlan_dev_real_dev()
In-Reply-To: <87k0gzrqw8.fsf@nvidia.com>
Date:   Thu, 25 Nov 2021 12:33:11 +0100
Message-ID: <87v90gqxl4.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.20.187.6]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2563e9c6-2843-4270-f577-08d9b0075f17
X-MS-TrafficTypeDiagnostic: SA1PR12MB5587:
X-Microsoft-Antispam-PRVS: <SA1PR12MB5587C8AE33C3193AB9D4BC81D6629@SA1PR12MB5587.namprd12.prod.outlook.com>
X-MS-Exchange-Transport-Forked: True
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kHEdWdMV3N3qu1nVQ9ve5mGaFT6U7l2DxH/CTPiWaHP7kbPCFz03pKCzY0aI55k6dYsNn52crRoCGBohju7wr7ZrTZ0GJOgt9eYZC590dsjgSv+XhuQ+agLiLtU+ARQppIgUGaoeUQGOsikibWDu++EQeSMVODoUk35rC0/gflVTpOl4VGAoI455ufGl5VXQud/803i2jaDa1GcMqyjfxugSX+HkWH/j6I6i0LKOe1EmuvtVmGeWyKYiQYFni+/tv1Ok4lfXMll14xCZzyEw6Q44HL9S62jGTlyHOUgHoALn2nA5km0Ilrpk4tYGKYM8LQUSBAd4AJDpuM3kIRphBNYk5qMmIst97jAZfXgJR7F9uDndvX9DleiVkylJqQ2p44k68eTemWAI4Sqo9IcRPwMVJ6WsgGsn+w8dfwLaUc/66hKJuugxW7bTG+sW4ilGGM6/zObNDENxJQVweLGxVLL1cX3eWyGsT9fHm8wjo1Dj7O4mUKFpohuO4FPGBPuQcTFmGWj0Fwm58exnBEB/m0TjfVSdrj9jGRKCG0GSk8sR9EVBjzPLvl3I/Axf3XWlEcP1yqSKAIB02BKWgTHlPzZRN9dNlpo5eXvK39RzSu34nHreJZ+fq6bRBZMHyNoQRiY7uy5cWGBli6WAswg9zCi29I7vCuz/7RFP99jNqkAw0TuO3jBPxJtWewSuX2Yr20bBFjHMXPSEC5M9RHPU8A==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(36860700001)(8676002)(36756003)(16526019)(37006003)(7636003)(356005)(70206006)(26005)(2906002)(316002)(6200100001)(82310400004)(83380400001)(86362001)(54906003)(508600001)(8936002)(426003)(186003)(2616005)(6862004)(336012)(47076005)(5660300002)(70586007)(4326008);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2021 11:33:15.5151
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2563e9c6-2843-4270-f577-08d9b0075f17
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT015.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB5587
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Petr Machata <petrm@nvidia.com> writes:

> Ziyang Xuan (William) <william.xuanziyang@huawei.com> writes:
>
>>> 
>>> Ziyang Xuan (William) <william.xuanziyang@huawei.com> writes:
>>> 
>>>> I need some time to test my some ideas. And anyone has good ideas, please
>>>> do not be stingy.
>>> 
>>> Jakub Kicinski <kuba@kernel.org> writes:
>>> 
>>>> I think we should move the dev_hold() to ndo_init(), otherwise it's
>>>> hard to reason if destructor was invoked or not if
>>>> register_netdevice() errors out.
>>> 
>>> That makes sense to me. We always put real_dev in the destructor, so we
>>> should always hold it in the constructor...
>>
>> Inject error before dev_hold(real_dev) in register_vlan_dev(), and execute
>> the following testcase:
>>
>> ip link add dev dummy1 type dummy
>> ip link add name dummy1.100 link dummy1 type vlan id 100 // failed for error injection
>> ip link del dev dummy1
>>
>> Make the problem repro. The problem is solved using the following fix
>> according to the Jakub's suggestion:
>>
>> diff --git a/net/8021q/vlan.c b/net/8021q/vlan.c
>> index a3a0a5e994f5..abaa5d96ded2 100644
>> --- a/net/8021q/vlan.c
>> +++ b/net/8021q/vlan.c
>> @@ -184,9 +184,6 @@ int register_vlan_dev(struct net_device *dev, struct netlink_ext_ack *extack)
>>         if (err)
>>                 goto out_unregister_netdev;
>>
>> -       /* Account for reference in struct vlan_dev_priv */
>> -       dev_hold(real_dev);
>> -
>>         vlan_stacked_transfer_operstate(real_dev, dev, vlan);
>>         linkwatch_fire_event(dev); /* _MUST_ call rfc2863_policy() */
>>
>> diff --git a/net/8021q/vlan_dev.c b/net/8021q/vlan_dev.c
>> index ab6dee28536d..a54535cbcf4c 100644
>> --- a/net/8021q/vlan_dev.c
>> +++ b/net/8021q/vlan_dev.c
>> @@ -615,6 +615,9 @@ static int vlan_dev_init(struct net_device *dev)
>>         if (!vlan->vlan_pcpu_stats)
>>                 return -ENOMEM;
>>
>> +       /* Get vlan's reference to real_dev */
>> +       dev_hold(real_dev);
>>
>>
>> If there is not any other idea and objection, I will send the fix patch later.
>>
>> Thank you!
>
> This fixes the issue in my repro, and does not seems to break anything.
> We'll take it to full regression overnight, I'll report back tomorrow
> about the result.

Sorry, was AFK yesterday. It does look good.

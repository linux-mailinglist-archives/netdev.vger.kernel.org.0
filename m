Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21D892CD3BE
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 11:35:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388822AbgLCKfL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 05:35:11 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:19909 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388706AbgLCKfK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Dec 2020 05:35:10 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fc8bf350001>; Thu, 03 Dec 2020 02:34:29 -0800
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 3 Dec
 2020 10:34:26 +0000
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.46) by
 HQMAIL111.nvidia.com (172.20.187.18) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Thu, 3 Dec 2020 10:34:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hXSzrXh62XSo2ZG5p3+vJnoWCxoPLhNCGLpArZiHsw6v0rodhLf4D6Hw7lWx2MhcI0DYLVFtypvOTP966SjVmazIi70NyLpJtNZl7mBxvIKJYTcBuYWplJFhFfGhGExCMOb9cIO5dukjlgvLdxPNlJDvALBPOnk2QI92/s6gBNFXaJCf86v7OFEKY7zNoCdkpKZb7yly558jN3XhEZfiS2uu/+Bxr/ZLnrqVgF+cW7iI9IceoFjPB6QxRUOiD4Hs2s2kWFWAkOKrXqJzWoJA1QFaNMC32v3NAa0DU5PjZgArszm0ZFnR5Ak00Kb0Eb1NIok0TMIVEJJOo1PMiofQ0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+y/0+N9NwpUl6dFJRCFrASL5EjS0UIZ75SWw0EFsyio=;
 b=JA4ZeMwNjl8UvD90PyAj3x/ri7/+TY9Ope/Zq8QpIceawINS3IbR1j+4Uhw4xoMEZUsnFyx8OMgqoWk1vkke4OLj4+4prwozMArUJUrL04mmmvjCsuXnBYU/t8XpPymAjfK/o7rNPur2G4d4xHTIMpP6ljj5Dy4d6aIxjT099iDpdkccxjdHZmwWnm/BRZruoiniLp8xsyMrGT9fruk3mxoYLf0Sa+95yTQq5LdpY9lHVb1zOIXryGiD0fdeTuFMiYcfYIMbNXLzpdj38U9CwCxKp5+oBGpPYOgOC4YPeC9G9kuFrpVVOjmIvqQvL0ocVT+b8Wn14Acb31b1ZnYzjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nvidia.com;
Received: from DM5PR12MB1356.namprd12.prod.outlook.com (2603:10b6:3:74::18) by
 DM6PR12MB4516.namprd12.prod.outlook.com (2603:10b6:5:2ac::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3632.17; Thu, 3 Dec 2020 10:34:25 +0000
Received: from DM5PR12MB1356.namprd12.prod.outlook.com
 ([fe80::3cc2:a2d6:2919:6a5a]) by DM5PR12MB1356.namprd12.prod.outlook.com
 ([fe80::3cc2:a2d6:2919:6a5a%6]) with mapi id 15.20.3632.017; Thu, 3 Dec 2020
 10:34:25 +0000
Subject: Re: [PATCH net] net: bridge: Fix a warning when del bridge sysfs
To:     Jakub Kicinski <kuba@kernel.org>, Wang Hai <wanghai38@huawei.com>
CC:     <roopa@nvidia.com>, <davem@davemloft.net>,
        <bridge@lists.linux-foundation.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <20201201140114.67455-1-wanghai38@huawei.com>
 <20201202170359.19330bda@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
Message-ID: <3d3c0206-c8c4-8a19-c821-2a0cbb941c6b@nvidia.com>
Date:   Thu, 3 Dec 2020 12:34:14 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
In-Reply-To: <20201202170359.19330bda@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [213.179.129.39]
X-ClientProxiedBy: ZR0P278CA0006.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:16::16) To DM5PR12MB1356.namprd12.prod.outlook.com
 (2603:10b6:3:74::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.21.241.129] (213.179.129.39) by ZR0P278CA0006.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:16::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.17 via Frontend Transport; Thu, 3 Dec 2020 10:34:21 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 08bc43a0-79f8-45ba-d0e5-08d8977700f3
X-MS-TrafficTypeDiagnostic: DM6PR12MB4516:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB4516690150FC5B01069FB872DFF20@DM6PR12MB4516.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Nm7iKKxo7QB9ZGRrKId+9isHO1Yqm8LzJoTCDfN3beyiuvIapbj416gNklHF1Aly9jGnpr5MMS3hXJECm+FpUqfEFHkxDxH3M20lN4xKE5byyr0YiL3w2+Y0eV+1JxEaubxv59Kkj84wBKTLadQXVRl9FOT1GGqWOA0PeHfX/cjz0RqO46Xi3CreF+zhdIjTXkXZXb4onEgYDj19hZVIyCRQpwLQ/M/gmslU7W2dTmToMI+1XIyntGlTuP0YZEEWICpUiVQs7swjdTKmG3ltZ3+X7Fqb5MVdVV0TIENkW8rKImZGNiOYvioWVPUZ2mI8BgUb1OBJRdoixOGTEb55hq+B8viKgXPWo17qD07puinfUZMsp6+SXcPCGK2zMHvlaIm7l4fG7Y7MvJ1YvOFOz4Ej6mNnPesCIfHKUr6Tsho=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1356.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(366004)(396003)(136003)(39860400002)(36756003)(66556008)(66946007)(4326008)(31696002)(66476007)(2906002)(8936002)(8676002)(5660300002)(6486002)(6666004)(26005)(83380400001)(2616005)(53546011)(16526019)(186003)(45080400002)(31686004)(956004)(110136005)(86362001)(478600001)(316002)(16576012)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?WWQrT09mR0d4NXFxMW5KTzdnVWI4c2RJbzQ5S2ZNbjJJc3RDNVdKMlB2UTFB?=
 =?utf-8?B?UVhUcXcrOFdpejBvZTJ6WEJ4d3NkUFd3ZU1rL0l3R3FFdE01YUVxaVZOQ2xw?=
 =?utf-8?B?MHZqM0pJeCtNY1FyTzU2VWwxSGV5OEtZdFlCc2ZsSGNCNW1zUTR5alFzakdT?=
 =?utf-8?B?Q0hWb3NsaFVYdTlhQ0hFakFKTTYrK3diZForTW9lVkwzSlptV1F5NmxRM0RG?=
 =?utf-8?B?cVloMGFDVVhOc0Q5ei9vbFNkRnc2RUhPeEo3bzdMVWdRandyZ20vN1lyUWFz?=
 =?utf-8?B?QkJ4NmRjOFM1Qmp5eWlaTVpITndkaVlLUTFrVGxwTmt5bmxuNWJGMlhCdHhQ?=
 =?utf-8?B?S25EL3piaVI1Y0JmRjRJeWhNckFrNWpXeEk4MnVvcm9LL3pzb2ptczFwSGJh?=
 =?utf-8?B?RDV5U2IraUx6UWNtUnpvSXkvS3Rla1o2SjBjL0hSN3EwbnVHK1YrWXRUTjJo?=
 =?utf-8?B?NmdxUXA4WlZhbzNNUXdoL2UyVTh6RHNBMHpnNi9ESGsrbVp3QmtrRUhReHll?=
 =?utf-8?B?SVJmd1BSZHNoZWJ2Qkw1elZCMlFKY3BCWkhrLzduTFNLLzdWbWx3Qmg4ZXU4?=
 =?utf-8?B?b2ZIT1BzSXVaQ0I3TmF1a3plZTJlRU1ZUk82Y2dHOERvMm5EMlRtWGFjd3RB?=
 =?utf-8?B?NitsZ1E2VFpQeUxGUDkxOVIwS2hycHE0UXJ0aW55WE0wbmdtU0kyZEkvRU8x?=
 =?utf-8?B?b3dlbTdlaFVYQTk2ZENXMlRlVFJsdWEyZG5WZkRGcjZ3MklSemFEY3ZjTXBv?=
 =?utf-8?B?VklISUVpSzY2SDdYdHc0eXpueWZsemJabkJmdzU2Q3pEWExGakk2RWFuV3l6?=
 =?utf-8?B?Z0FrSEVWM1pvaUo2emROc3NUN21lV3c2bmdCQ1lYL211V3BrOXZmbjNBUVlS?=
 =?utf-8?B?LzZicVdJV1l5YmhWdFNINEt4WWtFV1l1UnloOUF4ZUZ4SDRxUFRwbVFCdEYx?=
 =?utf-8?B?aTFzanhOKzZoNHQ5eGhiUDhrSzBSREhvNjJWU0VWSVpJL0xzNFZXUFJBMDhN?=
 =?utf-8?B?NHVpUkRRdGFaa0gyemtUWmJSeloyR21FL3ZKZldTV01KRXRnVVNpY2taMG92?=
 =?utf-8?B?MWVBZjdCSkNFQURtTFMwclg2SlhqMUhHbnd3Z1pCcXAxMUdKUnIrZm1qNUxz?=
 =?utf-8?B?dVlTQzg4QjhEWnlrK1lLdk9yWUtvdTFlQjZWY2VYQjRYc294dzFtL0FwUGc4?=
 =?utf-8?B?YllCU1A1elFrNlZLeU5NcW1CeEdIMkVjeXJBdGN3T1hub1NZeXdSNjlJL1BP?=
 =?utf-8?B?a1RZdmt0dGd1WHhJSitXN3dPODNOaUtmcXNieEtqSHB6R25heDVJamZaKzRy?=
 =?utf-8?Q?pAShN61yT8bConI5ghb+cZKI35kuiHrscQ?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 08bc43a0-79f8-45ba-d0e5-08d8977700f3
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1356.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Dec 2020 10:34:24.9374
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yDICxkHv75ZBfH/9jCE39Zb/flMOV+c3SwPm+T444kVfyKxSGXzHOEDPG7dYjryS4RkarZQWh96RJ8mJMsTd4g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4516
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1606991669; bh=+y/0+N9NwpUl6dFJRCFrASL5EjS0UIZ75SWw0EFsyio=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:
         Authentication-Results:Subject:To:CC:References:From:Message-ID:
         Date:User-Agent:In-Reply-To:Content-Type:Content-Language:
         Content-Transfer-Encoding:X-Originating-IP:X-ClientProxiedBy:
         MIME-Version:X-MS-Exchange-MessageSentRepresentingType:
         X-MS-PublicTrafficType:X-MS-Office365-Filtering-Correlation-Id:
         X-MS-TrafficTypeDiagnostic:X-MS-Exchange-Transport-Forked:
         X-Microsoft-Antispam-PRVS:X-MS-Oob-TLC-OOBClassifiers:
         X-MS-Exchange-SenderADCheck:X-Microsoft-Antispam:
         X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
         X-MS-Exchange-AntiSpam-MessageData:
         X-MS-Exchange-CrossTenant-Network-Message-Id:
         X-MS-Exchange-CrossTenant-AuthSource:
         X-MS-Exchange-CrossTenant-AuthAs:
         X-MS-Exchange-CrossTenant-OriginalArrivalTime:
         X-MS-Exchange-CrossTenant-FromEntityHeader:
         X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
         X-MS-Exchange-CrossTenant-UserPrincipalName:
         X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
        b=Wf8ULNWTIyI1s5AIUK1APLOM1YbVCO8FqNQ9vQ86XP1Ihe+a0UP3JLlajBFhDiXmb
         vSVyiG9vC+i7ACFlEhu86LvBFWGuc/qzlF8Pc4/9Pz1t+0l4Fh2I9cbjeRfGNpZCit
         28i2qAKMVuiLQKamBWYcvdPyFwTqMAwXhyX9dzpwq/Qw/InoRMqh7xJJJJzXh7A3OO
         2T+IUwJFXM0qYvsbuyNx6NZRUnI7ELGCYdjct0x1Pgik1xkhrILw9NUa401MhikDlS
         UAMGFMFewgSJf3Bm6Y6yA97D0coSG+cyCUK/38hCfzJZnAik+zaZ/+C+B8H4gX/JRm
         ILdTy4sOb4jHg==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 03/12/2020 03:03, Jakub Kicinski wrote:
> On Tue, 1 Dec 2020 22:01:14 +0800 Wang Hai wrote:
>> If adding bridge sysfs fails, br->ifobj will be NULL, there is no
>> need to delete its non-existent sysfs when deleting the bridge device,
>> otherwise, it will cause a warning. So, when br->ifobj == NULL,
>> directly return can fix this bug.
>>
>> br_sysfs_addbr: can't create group bridge4/bridge
>> ------------[ cut here ]------------
>> sysfs group 'bridge' not found for kobject 'bridge4'
>> WARNING: CPU: 2 PID: 9004 at fs/sysfs/group.c:279 sysfs_remove_group fs/sysfs/group.c:279 [inline]
>> WARNING: CPU: 2 PID: 9004 at fs/sysfs/group.c:279 sysfs_remove_group+0x153/0x1b0 fs/sysfs/group.c:270
>> Modules linked in: iptable_nat
>> ...
>> Call Trace:
>>   br_dev_delete+0x112/0x190 net/bridge/br_if.c:384
>>   br_dev_newlink net/bridge/br_netlink.c:1381 [inline]
>>   br_dev_newlink+0xdb/0x100 net/bridge/br_netlink.c:1362
>>   __rtnl_newlink+0xe11/0x13f0 net/core/rtnetlink.c:3441
>>   rtnl_newlink+0x64/0xa0 net/core/rtnetlink.c:3500
>>   rtnetlink_rcv_msg+0x385/0x980 net/core/rtnetlink.c:5562
>>   netlink_rcv_skb+0x134/0x3d0 net/netlink/af_netlink.c:2494
>>   netlink_unicast_kernel net/netlink/af_netlink.c:1304 [inline]
>>   netlink_unicast+0x4a0/0x6a0 net/netlink/af_netlink.c:1330
>>   netlink_sendmsg+0x793/0xc80 net/netlink/af_netlink.c:1919
>>   sock_sendmsg_nosec net/socket.c:651 [inline]
>>   sock_sendmsg+0x139/0x170 net/socket.c:671
>>   ____sys_sendmsg+0x658/0x7d0 net/socket.c:2353
>>   ___sys_sendmsg+0xf8/0x170 net/socket.c:2407
>>   __sys_sendmsg+0xd3/0x190 net/socket.c:2440
>>   do_syscall_64+0x33/0x40 arch/x86/entry/common.c:46
>>   entry_SYSCALL_64_after_hwframe+0x44/0xa9
>>
>> Reported-by: Hulk Robot <hulkci@huawei.com>
>> Signed-off-by: Wang Hai <wanghai38@huawei.com>
> 
> Nik, is this the way you want to handle this?
> 
> Should the notifier not fail if sysfs files cannot be created?
> Currently br_sysfs_addbr() returns an int but the only caller 
> ignores it.
> 

Hi,
The fix is wrong because this is not the only user of ifobj. The bridge
port sysfs code also uses it and br_sysfs_addif() will create the new
symlink in sysfs_root_kn due to NULL kobj passed which basically means
only one port will be enslaved, the others will fail in creating their
sysfs entries and thus fail to be added as ports.

I'd prefer to just fail from the notifier based on the return value.
The only catch would be to test it with br_vlan_bridge_event() which
is called on bridge master device events, it should be fine as
br_vlan_find() deals with NULL vlan groups but at least a comment
above it in br.c's notifier would be good so if anyone decides to add
any NETDEVICE_UNREGISTER handling would be warned about it.

Also please add proper fixes tag, the bug seems to be since:
bb900b27a2f4 ("bridge: allow creating bridge devices with netlink")

It actually changed the behaviour, before that the return value of br_sysfs_addbr()
was checked and the device got unregistered on failure.

Thanks,
 Nik



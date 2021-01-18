Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C8742FAD78
	for <lists+netdev@lfdr.de>; Mon, 18 Jan 2021 23:45:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389712AbhARWnk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 17:43:40 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:11486 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388864AbhARWnB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jan 2021 17:43:01 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B60060ecb0001>; Mon, 18 Jan 2021 14:42:19 -0800
Received: from HKMAIL103.nvidia.com (10.18.16.12) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 18 Jan
 2021 22:42:18 +0000
Received: from HKMAIL101.nvidia.com (10.18.16.10) by HKMAIL103.nvidia.com
 (10.18.16.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 18 Jan
 2021 22:42:17 +0000
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.47) by
 HKMAIL101.nvidia.com (10.18.16.10) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Mon, 18 Jan 2021 22:42:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GlevyfNG6eQoOe2CvU0CgUAhnEgeAUhLfP3Dj6iuxgkRGOGq/Xf7tHuBLvvBB3wISlRCuxDGIeMPVhL7KJ2kyiDMDvXEeyy/zBlEHktqbgVU53FaOjAFV1bln1PFpob8n8YvU/FMXyIQvrnE6KMUXUDBK+HrZ2+zODQDaa9vXB6UC8jREAFmPjN24KIqd6gZNrGB6FdB0e9xM/nyIrUNhdPZk+xlkNRYGYSocCV3L8L8nh0OfEXoK6MtQPUJs6NFJPlBoy7SZYRDG+j5mIYKgRABVS85TBh5yTxR9d53IIrPWLO5/RelTbGomnX99vOD35YJehB879km789z/DgXtQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iBPVbE5XMiQBYwMB+nPno+vHoWNTO3L4UFDTRRJQ13c=;
 b=jPV2urDr56dyXOJRjosAc20bNavkhpgi/IreLQn+7Ke49nBQ30OPwC3ow1sXN5xkh+9jnqQZR+p5NiAujyZGbJYvpr8GXdW2lorhVIvjQ8AA28B5ER01wXSTK0vrP+zebc8l4Gbagu8TDRKKqbzssvw8xCFgG3d84sQZ8FT5jD5fL56boomHXv67botSlbptWcAspEH9m4TmgK8ZMYXozFKntqT3hGMZG5eIxxD0KeFoWRrLtzBfjkgds4RtoEe0308bw99WeLqrEt4HQ7ozS35nmjTZnUlHY1PU5zSrjAKuMgL9ltY4PYap+A8WLBCq1cS03zFS80Jo4G6O28iIRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Authentication-Results: networkplumber.org; dkim=none (message not signed)
 header.d=none;networkplumber.org; dmarc=none action=none
 header.from=nvidia.com;
Received: from DM6PR12MB4403.namprd12.prod.outlook.com (2603:10b6:5:2ab::24)
 by DM5PR12MB2408.namprd12.prod.outlook.com (2603:10b6:4:b9::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.10; Mon, 18 Jan
 2021 22:42:14 +0000
Received: from DM6PR12MB4403.namprd12.prod.outlook.com
 ([fe80::6:2468:8ec8:acae]) by DM6PR12MB4403.namprd12.prod.outlook.com
 ([fe80::6:2468:8ec8:acae%5]) with mapi id 15.20.3763.014; Mon, 18 Jan 2021
 22:42:14 +0000
Subject: Re: [RFC net-next 2/7] net: bridge: switchdev: Include local flag in
 FDB notifications
To:     Vladimir Oltean <olteanv@gmail.com>
CC:     Tobias Waldekranz <tobias@waldekranz.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <andrew@lunn.ch>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <roopa@nvidia.com>,
        <netdev@vger.kernel.org>, <jiri@resnulli.us>, <idosch@idosch.org>,
        <stephen@networkplumber.org>
References: <20210116012515.3152-3-tobias@waldekranz.com>
 <20210117193009.io3nungdwuzmo5f7@skbuf> <87turejclo.fsf@waldekranz.com>
 <20210118192757.xpb4ad2af2xpetx3@skbuf> <87o8hmj8w0.fsf@waldekranz.com>
 <75ba13d0-bc14-f3b7-d842-cee2cd16d854@nvidia.com>
 <b5e2e1f7-c8dc-550b-25ec-0dbc23813444@nvidia.com>
 <ee159769-4359-86ce-3dca-78dff9d8366a@nvidia.com>
 <20210118215009.jegmjjhlrooe2r2h@skbuf>
 <4fb95388-9564-7555-06c0-3126f95c34b3@nvidia.com>
 <20210118220616.ql2i3uigyz6tiuhz@skbuf>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
Message-ID: <32107e93-341f-aff8-a357-dd03e69d3839@nvidia.com>
Date:   Tue, 19 Jan 2021 00:42:04 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
In-Reply-To: <20210118220616.ql2i3uigyz6tiuhz@skbuf>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [213.179.129.39]
X-ClientProxiedBy: GV0P278CA0053.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:710:29::22) To DM6PR12MB4403.namprd12.prod.outlook.com
 (2603:10b6:5:2ab::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.21.240.90] (213.179.129.39) by GV0P278CA0053.CHEP278.PROD.OUTLOOK.COM (2603:10a6:710:29::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.9 via Frontend Transport; Mon, 18 Jan 2021 22:42:11 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 80c38bc6-5aa9-4c88-1669-08d8bc024d34
X-MS-TrafficTypeDiagnostic: DM5PR12MB2408:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB24084C3CF8F77A9F5DB537D5DFA40@DM5PR12MB2408.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1ueTRNFAEp4qIX15xPrByHNz1ChR2sphiDDar2nlb56aaU2Dp2tenBbw0BOENkP2knspqkSKjTjLlksOIfTJ9AAuH1b0xN5LV6HAtW/SUJmZRWwmIY/3SZnjY4vmw8GStoTAJz/9fIpniqaJ5kLa1JOy9tFq+AfqfX9c9Wib0SaSHMXUJjiGyT+eUUiM7v+rY5HnAEeU23VwNInoGeUordetpn+vyinEetdKwSyeBFuMOxt9B19peMIeOkGnVMLjjG+jCm+EwydrrepNMQq9CMmYNMT5a63QWrVSNA4ERGSErt+q9Nhg3nyPtNaH0nM+rSbRLykpdPh9vZ1DXX6EeTPPdxqwCmXEwY3kUGTtO+7Dh3KKaP8hYvIxw5JxJKqF+o5y8lgA0DB2/MQlCKMb1uKBHLOX/90Ity0+mCA2NbUDcX/gGOHizWfo4yUNHQQlD4H8YABZQaFzyGAB7dK9N8un+N8bgVedlOPfUhpow9g=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4403.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(39860400002)(136003)(346002)(376002)(366004)(5660300002)(66946007)(956004)(31686004)(83380400001)(4326008)(66556008)(2906002)(8676002)(66476007)(6916009)(2616005)(31696002)(6666004)(36756003)(478600001)(316002)(6486002)(186003)(8936002)(16576012)(53546011)(7416002)(16526019)(26005)(86362001)(15650500001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?a1R3MHRkdEh3VEorbVpzWUttV0JTM2lVNVUzdW53c2k2SGtRL0VKR0Z5emk3?=
 =?utf-8?B?Y2cwYndYNTJYYWpBcVpKVkFPTXVHeE5VaURwbVBHbHlZNWxTSkI2enhJalhG?=
 =?utf-8?B?OHp3cFB6N1MrV2NrNUd4ZXJXMS9xZGpZTjNVREdKb3E3TmZVZ2ZKb2ZVVXRy?=
 =?utf-8?B?UGRlakkzcUM2TXRtc0tocWY2MUZUaGt1UVd2a2V2cW9oc3BsOTJBbUgrMEdm?=
 =?utf-8?B?VmxyNlloZWRJM1gxMExmQUlHK0U2SVpWUHhsV1VFUnVaQXk1ODNwejRkalFy?=
 =?utf-8?B?Ukl1eVdKWjRWejJZM0ZmcHFUQjcrb3NjVVZuK2tnbU5pQ2tPUjMvNlU2T2sx?=
 =?utf-8?B?SmE5UDNIRTg3dnBzYllydlRZT0c3b3ZlZGtTVkh6REhwQUtLZnNSelhIZTdM?=
 =?utf-8?B?SWFMdGd0RjF1ZHpJK0h3ay9pWGs2VGs5RWhLTWsxQVVpY00wNnhjTWdLRDR5?=
 =?utf-8?B?VS9sNGtqcXJFMlM5WjYvQVJCVlVqSEVUTG1NaW5HeDVsSndOdHlVY1NwdVBR?=
 =?utf-8?B?am8weVIvOVJZZlFRQm5Yem8xWVlDdEt1cng2dGE3MURtZzlWQVNQc1JnczdL?=
 =?utf-8?B?cmtVTElMcmlhaEFTY1c5RnpMcUdVMUhlcjJ1clJ2eWlsUWE1RUNTY3p4SzJN?=
 =?utf-8?B?Yk1WMThlamlMMDdwMk1SV0ZSTjJ6MWJVQW12SjBZZkUwWENyTitldmZKNU9s?=
 =?utf-8?B?TkZVZkNCL09HUmdQcHF3SHVxUHYzbEZqVkNHSHFTSjJ3bU5vZktRc0tTTzRs?=
 =?utf-8?B?bnBBb0JjNHE5R0crSEVvcHJtSnJSVU9LU2kwSUhPRWl4RjFWa0dzQUg5aUlw?=
 =?utf-8?B?bC9rZTNYTnlZT2JaM3VOcy9mUUp4QnJJM1hvR3NEcDd3b0J0L0xPY05GMDVu?=
 =?utf-8?B?QmQyN2E4WTZLTll0eTdNRzNMeVFOTUtza3NCUklJZ2xPdlhKU05tMzV4ang1?=
 =?utf-8?B?TERzTWVKcEFOUkJaVmJjQ2ZsbGlLbTYxZTJwblMvL0diLzhRNHI4eE9qVFov?=
 =?utf-8?B?a2Z3eHk0cm50QXR1bzZiR0J4UnQxeGxwMndPN0VvUzdjVHpOZWdqOGFGUmNE?=
 =?utf-8?B?ajRFY0hnc2RORmRyV2d4VENySnBGS2JudlFQOWtwVWQrcnJmdUoxaVJhVzhD?=
 =?utf-8?B?WmthV0pHZy9HcE92TFNkZGVHZk1nWkF4UHJmcjJRb1FxbVdHSHllWEtEQkls?=
 =?utf-8?B?MndFcndJZExTUjFwL1hDWXMvd0NnZkQ2dHVDRnoxdWxMU25zeUNxRElPek44?=
 =?utf-8?B?ai80UG1Nc1lNUCs5SzVQSTZzZW1mR3RQaEVOZU9hS1hxeUc0V1QvV1YrYjZy?=
 =?utf-8?B?aElLSktWNUF3dnQ4eGFMQm4xOW9RN21NZXpFQWVldnFqQlVBdytzdi9qM1dx?=
 =?utf-8?B?N0VBZE9yVFZTNzhUMHZJazRoL2Q2YTV0N0JHT0lDb0d5T2FsS1UyOGJGUkNw?=
 =?utf-8?Q?opcEV40B?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 80c38bc6-5aa9-4c88-1669-08d8bc024d34
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4403.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jan 2021 22:42:14.6769
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rof8ilG3nxA2lM9ZOw6Q0cKJC90WXat0yW1AmA+RqG6cBvCXDxuduqmx60+4X+HIGbK7VbtCVMw9xtQjrw3Vmw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB2408
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1611009740; bh=iBPVbE5XMiQBYwMB+nPno+vHoWNTO3L4UFDTRRJQ13c=;
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
        b=CdXGYKFXi+qg2wCHgQG5cWXNbJOckAR+LWp12p4YZ+m+/djHhtupqcA23UnPDnJJd
         gNR/GrbvZRXZLEJjz5lwVHW3HavEiLSADVWnwTHTQTcqXkkVBrkDQsjOomdKb7E1Jn
         BG1/beSxTiams9YcO82jeKtO4rVl+e6wREI6tbOD/3U0oaOQwt7LaXoBcBCyuMwTVu
         Sd4I172Wu/71eYUHKu5v1zgHn7q3qCNs2KFw+gDSuYNhcm2d6HrRJ71ifDmeMmGXPk
         Zpy40HLSKfyK4pPvPZhiZCCiRCmTFln9S8GiPld4rNaE+UP17q7h3VXvT9Kjnfvdv4
         dXQ4s2Drs6p+w==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 19/01/2021 00:06, Vladimir Oltean wrote:
> On Mon, Jan 18, 2021 at 11:53:18PM +0200, Nikolay Aleksandrov wrote:
>> On 18/01/2021 23:50, Vladimir Oltean wrote:
>>> On Mon, Jan 18, 2021 at 11:39:27PM +0200, Nikolay Aleksandrov wrote:
>>>> Apologies for the multiple emails, but wanted to leave an example:
>>>>
>>>> 00:11:22:33:44:55 dev ens16 master bridge permanent
>>>>
>>>> This must always exist and user-space must be able to create it, which
>>>> might be against what you want to achieve (no BR_FDB_LOCAL entries with
>>>> fdb->dst != NULL).
>>>
>>> Can you give me an example of why it would matter that fdb->dst in this
>>> case is set to ens16?
>>>
>>
>> Can you dump it as "dev ens16" without it? :)
>> Or alternatively can you send a notification with "dev ens16" without it?
>>
>> I'm in favor of removing it, but it is risky since some script somewhere might
>> be searching for it, or some user-space daemon might expect to see a notification
>> for such entries and react on it.
> 
> If "dev ens16" makes no difference to the forwarding and/or termination
> path of the bridge, just to user space reporting, then keeping
> appearances is a bit pointless.
> 
> For example, DSA switch interfaces inherit by default the MAC address of
> the host interface. Having multiple net devices with the same MAC
> address works because either they are in different L2 domains (case in
> which the MAC addresses should still be unique per domain), or they are
> in the same L2 domain, under the same bridge (case in which it is the
> bridge who should do IP neighbour resolution etc).
> Having that said, let there be these commands:
> 
> $ ip link add br0 type bridge
> $ ip link set swp0 master br0
> $ ip link set swp1 master br0
> $ ip link set swp2 master br0
> $ ip link set swp3 master br0
> $ bridge fdb | grep permanent
> 00:04:9f:05:de:0a dev swp0 vlan 1 master br0 permanent
> 00:04:9f:05:de:0a dev swp0 master br0 permanent
> 
> And these:
> 
> $ ip link add br0 type bridge
> $ ip link set swp3 master br0
> $ ip link set swp2 master br0
> $ ip link set swp1 master br0
> $ ip link set swp0 master br0
> $ bridge fdb | grep permanent
> 00:04:9f:05:de:0a dev swp0 vlan 1 master br0 permanent
> 00:04:9f:05:de:0a dev swp0 master br0 permanent
> 00:04:9f:05:de:0a dev swp3 vlan 1 master br0 permanent
> 00:04:9f:05:de:0a dev swp3 master br0 permanent
> 
> Preserving the reporting for permanent/local FDB entries added by user
> is one thing. But do we need to also preserve this behavior (i.e. report
> the first unique MAC address of an interface that joins the bridge as a
> permanent/local address on that brport, but not on the others, and not
> on br0)? If yes, then I'm afraid there's nothing we can do.
> 

No, it shouldn't be a problem to change that. We should be careful about the
way it's changed though because reporting it for all ports might become a scale
issue with 4k vlans, and also today you can't add the same mac for multiple ports.
Perhaps the best way is to report it for the bridge itself, while still allowing
such entries to be added/deleted by user-space.

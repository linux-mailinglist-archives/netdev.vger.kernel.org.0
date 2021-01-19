Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9A862FB8D4
	for <lists+netdev@lfdr.de>; Tue, 19 Jan 2021 15:34:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394894AbhASNs5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 08:48:57 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:1053 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389737AbhASKPe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jan 2021 05:15:34 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B6006b1090001>; Tue, 19 Jan 2021 02:14:33 -0800
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 19 Jan
 2021 10:14:32 +0000
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.40) by
 HQMAIL109.nvidia.com (172.20.187.15) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Tue, 19 Jan 2021 10:14:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S4j+hC6gLT3b8hKFvLSm+XKa7qn/tkiar1188ieoO5EKB9PHCqWYRl0cX+V0swgHj30fmbN/IVmLKYE2rwSBzSScuw6rHjuhefLXZHi2jsuroLkquMaMbQ80rqs1SHXHcW2eNqCWPl1n8Vwt2wyjTyUxi5Ph9gOIRqAbqh3Rl5n+kdlwC5MZJ3CIqsYldUVNb2ooSFE/97y1U5kYvoOq0JOsRQmsCJ32GA+44aYoyMejH4ydyrcam1NCZQki1+BoTLfmgv51pLQ/tajDh79scQW3Icz5t+GSOzp957VHjHBUnWSihqrrA6vyWgpwcU5dO4dtFkxDGEtv+LDMChsYXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2SolrzaSI73BK3g1RT2FrTOR8o/ZLEXkDGA489Iojrk=;
 b=VisQArZpoA/2X7aRRYQl91TRJuEh0y/lnBwli7dMVwod5ek3Tt3Z0eP5x3n+Iv3M2ZY69DaXbC2lcF6iEZJhIZrRxrAVTFx/C/Cv986IS0KfEmrz4jvHnP+sfLEm2vFvS0Sw0+zWlbzAhVuIfwtUUjWNg2efrOYSwAULcV0tBsBemOHCVxsHIhIIq4mJCNmYEWuOaia0gdYTBsQ3UWyTr5GFT70aNcGX9fPzE0+PkAdLhvuM2BYSaXs1wSFxLRCTzQz1SXGqJ6/fc646cs6uvbKFubIo2vaUIShf46xwY0uv0zj24qeIUJ/0a2KyzpGR4HKNKy4Img5wWr7pNn/UYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Authentication-Results: networkplumber.org; dkim=none (message not signed)
 header.d=none;networkplumber.org; dmarc=none action=none
 header.from=nvidia.com;
Received: from DM6PR12MB4403.namprd12.prod.outlook.com (2603:10b6:5:2ab::24)
 by DM6PR12MB3451.namprd12.prod.outlook.com (2603:10b6:5:11d::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.11; Tue, 19 Jan
 2021 10:14:27 +0000
Received: from DM6PR12MB4403.namprd12.prod.outlook.com
 ([fe80::6:2468:8ec8:acae]) by DM6PR12MB4403.namprd12.prod.outlook.com
 ([fe80::6:2468:8ec8:acae%5]) with mapi id 15.20.3763.014; Tue, 19 Jan 2021
 10:14:27 +0000
Subject: Re: [RFC net-next 2/7] net: bridge: switchdev: Include local flag in
 FDB notifications
To:     Vladimir Oltean <olteanv@gmail.com>
CC:     Tobias Waldekranz <tobias@waldekranz.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <andrew@lunn.ch>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <roopa@nvidia.com>,
        <netdev@vger.kernel.org>, <jiri@resnulli.us>, <idosch@idosch.org>,
        <stephen@networkplumber.org>
References: <87turejclo.fsf@waldekranz.com>
 <20210118192757.xpb4ad2af2xpetx3@skbuf> <87o8hmj8w0.fsf@waldekranz.com>
 <75ba13d0-bc14-f3b7-d842-cee2cd16d854@nvidia.com>
 <b5e2e1f7-c8dc-550b-25ec-0dbc23813444@nvidia.com>
 <ee159769-4359-86ce-3dca-78dff9d8366a@nvidia.com>
 <20210118215009.jegmjjhlrooe2r2h@skbuf>
 <4fb95388-9564-7555-06c0-3126f95c34b3@nvidia.com>
 <20210118220616.ql2i3uigyz6tiuhz@skbuf>
 <32107e93-341f-aff8-a357-dd03e69d3839@nvidia.com>
 <20210119004200.eocv274y2qbemp63@skbuf>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
Message-ID: <98dce26e-f292-1c71-9d74-9c0cbd1f3da5@nvidia.com>
Date:   Tue, 19 Jan 2021 12:14:20 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
In-Reply-To: <20210119004200.eocv274y2qbemp63@skbuf>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [213.179.129.39]
X-ClientProxiedBy: ZRAP278CA0008.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:10::18) To DM6PR12MB4403.namprd12.prod.outlook.com
 (2603:10b6:5:2ab::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.21.240.90] (213.179.129.39) by ZRAP278CA0008.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:10::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.10 via Frontend Transport; Tue, 19 Jan 2021 10:14:24 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 32cbb875-78d1-49a2-4a14-08d8bc6300de
X-MS-TrafficTypeDiagnostic: DM6PR12MB3451:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB3451168DD033F2CBBA01F55ADFA30@DM6PR12MB3451.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1KGiYxO8KPD4HvKJed/XAGBbWNg9WNdo/8+pEc8RPCk3WOt+5/mFr+4+nOMAaVuzXioRBLpoM5EmZpS8uVD3QtPyzvguQ+UyCobEd8U4/TlUto0zTA7rTv7J2xWo5SMO/xdzrd5AcDlBhZyRBeOqDd+jQdwqGHn4+YKutLMZxwauEkHVGqoqPlVvz+c1jB6+czFO0HbMXgFDRS0Efy3r+Db6IPjL3A0G12qliGfT8x+aFkEP4U6L4GqVHKqCdm3g8xYs0A+u8Ycyzff96B2OVusS7+mg0l1Q9weUQiCf4k3HCkcR6yFPfi/zXA2pAOLW7lNUCIjkdZKDa/YzdxnwImxh6eglqjy5LDQsHf0FmuZvcIfqMFgbMr1LhMPCVhwvfCYDbRBs9um4CnMQD8hCY35+NrA/k87JejQ9i1BLCF187VNLCB9lUwOGTw8Ogt7WQs7QR1klrM9C4l55oVCokRuTjzTmxGGThfOCG4h1eXk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4403.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(376002)(39860400002)(346002)(136003)(366004)(15650500001)(6666004)(2906002)(4326008)(6486002)(5660300002)(36756003)(31686004)(7416002)(6916009)(2616005)(16576012)(83380400001)(26005)(8936002)(86362001)(16526019)(186003)(316002)(956004)(66946007)(8676002)(478600001)(53546011)(66476007)(66556008)(31696002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?QkMwUUo4TjNrRWpERHQ5bE1uWmlRV1NYRkxneXR3WGNxVWNwUjNMY0w2Tkg2?=
 =?utf-8?B?b2ROczdBbnhpaGl6Mmk4Mk9acFRCMk5Jc1hxUTdwcGxNVU82RVh0QnJmN3BD?=
 =?utf-8?B?aGNRSEJhUmFPeUVPaUxOV1o1YnlkcVl1T0FXNkhWMU9ibkxldEk2MG1qREw0?=
 =?utf-8?B?WVduN1hSSXJDUlJUSkZCU1BKT0pKNUJMeE5BMUExVzBTNTRPblVXd2huV0Rz?=
 =?utf-8?B?L1pPQklIUXZObzNQSGxqdCt5NmwweE81OG03bUp4THFleU1Kakp6M2pHMHlJ?=
 =?utf-8?B?YVM2ZFlvaUZwV2NQTys2OU8rdW5JZEtSL2FmRjdqVUJlNlY2bW9BeDBmZ2Nx?=
 =?utf-8?B?RndEaE5SVUN2V2JqbE54bkp4Tk1ZN3BFZTdwMDgxM2Y5c3BIdHNMb0wvVUdF?=
 =?utf-8?B?NFM5MnZ5cFZjTWk5WlBENUFtdndMWGgza1RmZWZUWDhtMzNlRmRFWi9OUGtp?=
 =?utf-8?B?OVdGWm5GZE4vYkQ5MDRqbkk2dDlhemVwa2d3eHVCZHh0Vzc1SVE5Y2EyNHVU?=
 =?utf-8?B?MzJYUXJQU1hMVXJTTmRXay80WnZVeUF0N25uMG84VnJiWkVRUVYvL29jbUhU?=
 =?utf-8?B?R0lmLzNSazBiSjJnWDR6c2ZPYWYyVEpGaUJrS1Z2cGJwS3RWcnAyS0IrTUx3?=
 =?utf-8?B?dGE2b3Q3WUNhY21ZRzExaE8ydnhVVFdJajN6ZC95QzlYeTVtOGt5STB3ZzBN?=
 =?utf-8?B?T1g0T1NXMjJZb0FDRTVLRnd4SFA5T01FNXRkR0dyRk1GZmJtSlF2ZEdiSWkz?=
 =?utf-8?B?YWZXUy9RZTYyT3VzNjN2dmJHd3FPOUJjajgrVGpCMFFLTjhyMFUzV1R3aUpT?=
 =?utf-8?B?TzRwaE40YVp4RWw4T09YVzUydVpmWjl1aU5Zc2Y1MHhWQk41bHlHa2doQ0pT?=
 =?utf-8?B?WnJVczZvUFMraldLK3U5WUl6U1A2REVtVVprdFVQVXZrY2dJRnlWdGdhQmx3?=
 =?utf-8?B?cVJOYjhzTXpKa0F1U0NvRVNhNVFCYlkwYnMzUlBOeUUvVVEwOHpTaGJxY254?=
 =?utf-8?B?NzV5a0F3cG9QZ2VuZ1lMZ0dESlVFSW10R0d0U014Q3dMOUdSV0tKUzliY3hJ?=
 =?utf-8?B?QzYyMm44VGdRN2tjSjJuMnY2Z0dzYWt2NEUwdmdVQW52VWJhUnU4Q0lTOCt1?=
 =?utf-8?B?aUZzV0RKcXRWSXN5bVl1bUp3YVNhS21jem5OVk1CcWtoUDFoYXpTSks3OVMv?=
 =?utf-8?B?dzYxTGpmZHBLVDR6dWZCTXgxNFl0RlIyOGFwQ1NUZ1RXYU1kcFJGaUxsNTBB?=
 =?utf-8?B?d0F1TUwxNGlMTGhyVWNMVjFDNG5LZkVBbkRHT2JQU3VNb2JsaGNsNXl4dWxF?=
 =?utf-8?B?RDhsdVBxcmtkb2d1REtsYnNyRlNmcDdKaENScE9heGUyRkI5NGtNRHdOemdJ?=
 =?utf-8?B?WWlPOExnSzFUWkMxRTVzeTZrYWZqS0hXM1RqV2E4M2NMOWxMZWM4SjhhQ2JT?=
 =?utf-8?Q?3QID3I+v?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 32cbb875-78d1-49a2-4a14-08d8bc6300de
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4403.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jan 2021 10:14:27.6999
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6j6Yft3+fBWh6dlabHXSkYMj93tDero3x/yxSWaap6En8cdHjLxsm2n4YzP/kQ8P8eosUW3lyyddFrRw9Ny/gg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3451
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1611051273; bh=2SolrzaSI73BK3g1RT2FrTOR8o/ZLEXkDGA489Iojrk=;
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
        b=YENVRYM2bS59a6bu5OaiQqcoIlXAfmhiPWatqY896faGhKjHbHrV5ivcqNWRF7nUE
         Pdi9t5vEKYrj3nHxeng0TWvpuZvnQg1teHjLP7wS6/9o1uQcgEk7ohJE0p6DqxrJMn
         A5OEIDNokWI7XlUzG+HnByM8EQMqBIFKEFMHAaKbHCKY/+d5DGpmdZTgPoPiTp6FGX
         UpZDvywGedpCWeHzVU53clK6lG3duQ8eAMfQr2qA8M7SA7/6M/gA8VFjjTzaLtTaRP
         Aav0eWuFn+mO7YKVaste8qrqAW+LU8+tmxxwLzU9CsUP+wMxjML6VV5HDgyW0axkhC
         P7Be1Mb+SYm/Q==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 19/01/2021 02:42, Vladimir Oltean wrote:
> On Tue, Jan 19, 2021 at 12:42:04AM +0200, Nikolay Aleksandrov wrote:
>> No, it shouldn't be a problem to change that. We should be careful about the
>> way it's changed though because reporting it for all ports might become a scale
>> issue with 4k vlans, and also today you can't add the same mac for multiple ports.
>> Perhaps the best way is to report it for the bridge itself, while still allowing
>> such entries to be added/deleted by user-space.
> 
> I think what Tobias is trying to achieve is:
> (a) offload the locally terminated FDB addresses through switchdev, in a
>     way that is not "poisoned", i.e. the driver should not be forced to
>     recognize these entries based on the is_local flag. This includes
>     the ports MAC addresses which are currently notified as is_local and
>     with fdb->dst = source brport (not NULL).
> (b) remain compatible with the mistakes of the past, i.e. DSA and
>     probably other switchdev users will have to remain oblivious of the
>     is_local flag. So we will still have to accept "bridge fdb add
>     00:01:02:03:04:05 dev swp0 master local", and it will have to keep
>     incorrectly installing a front-facing static FDB entry on swp0
>     instead of a local/permanent one.
> 
> In terms of implementation, this would mean that for added_by_user
> entries, we keep the existing notifications broken as they are.
> Whereas for !added_by_user, we replace them as much as possible with
> "fdb->dst == NULL" entries (i.e. for br0).
> 
> I haven't looked closely at the code, and I hope that this will not
> happen, but maybe some of these addresses will inevitably have to be
> duplicated with is_local addresses that were previously notified. In
> that case I'm thinking there must be some hackery to always offload the
> addresses in this order: first the is_local address, then the br0
> address, to allow the bad entry to be overwritten with the good one.
> 
> Finally, we should modify the bridge manpage to say "we know that the
> local|permanent flag is added by default, but it's deprecated so pls
> don't use it anymore, just use fdb on br0".
> 
> How does this sound?
> 

We'll be supporting it forever, I don't see how it's being deprecated. :)
Either way I'm ok with the above, but I'll be able to comment further when
I see how exactly the code would change. We should be very careful not to break
someone who uses these entries in a way we can't think of, for example we use
permanent user-space added entries combined with ext_learn for mlag purposes
which is a stranger use case, granted it won't be broken by the above.
Perhaps we should consider making the new behaviour optional instead, then
we can completely switch between the two modes and drop compatibility.

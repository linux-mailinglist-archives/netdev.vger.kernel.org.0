Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CEBA3F0E8C
	for <lists+netdev@lfdr.de>; Thu, 19 Aug 2021 01:12:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234669AbhHRXNQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 19:13:16 -0400
Received: from mail-bn7nam10on2070.outbound.protection.outlook.com ([40.107.92.70]:40640
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231976AbhHRXNQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Aug 2021 19:13:16 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iVxSOcWT5hc1Dfd5K3n3Vwral7laeHsLq/1DkZIccUawNR+g1/AzYBc6GYFLr7u0EEcu+3Zx6exoBY7Fz8TfeIpmJt3wkngq5CgYnVFLEDw4kknR7k8U9yh7Cx6qtk8if1Iwc0VJrHEKcGxS4zM2MdtzGAB8uODpGKe51vrBN9LDundZDdMmVVj606s2zQowH2RuLDRv6BEp5mc0snInIsZnTvleUusP5kYv75ZQpQ/zYikenz6K9c8cT0niX5UhWZA6mgl+x3dwT7+IXY7ELxP0tQw5cKnmWYXD062WUQC0A5aV+oU1kmythPxiWqKisWQBYH//iiOUu56v4vATmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I/4SzJxSpEcMd9uLyPOtJwgUBmI5knnATIiDKbeBLkg=;
 b=VbiDCdi2voXgZZK9T8HKEhbB6kQ3lw5XspK16KcSKFU0szAeiXrzp+cBF0OtF2xdVEtNAuhSxOrHx3TMIhsbezcK7IWKhx0hAkoYFUVTbILzXyYsI5lZN04HzUlRH1oXGd5aKq+vF6udlbe1EEtfCbJ4DECmu9xZ3h2E62FOmQErp8ngiFO9uyqypVz5e3S0lWk1Xiye2HIrPZhhnIICYAMCQdzAJJS1A3NtqSP3eqvGszvEB9SY5pI55jz3COauAlq2eIhvi+AVAAFV8os2ofNgNSXWM4Oeq4jq2tNmHku4Zg3wiJHZ7KNJiwSeCmTNzqoFzIazpH7jzhJh6Kgu3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I/4SzJxSpEcMd9uLyPOtJwgUBmI5knnATIiDKbeBLkg=;
 b=FDAGd5MkNR5pu1JVNxaK60fqUsw76IyGERC24waTAOn2JS+Eajm4G2X3ZWbqHvTjmoupHrqJoJ6cc1rV/8gow+Nfh1bewak9YIcSBbqPDgDWgX+o3LHLDtakFLR19/Tr6hTgibdf/sljNBXIBPkthzQR3wPMaTjxgbV0iBto/QC2A2lNuwTGxaU7o+Bbk4hLsrYNj9zB1dQhKzXWzlDpPqVdKTGrGwFOFygh726f3iyqfxxCkMvhraXIuVfRShungGaNYK2xGOPnyhTdzLaE1w192sMt5cMe6skrSnlYQA+wsd1PnX0tDCfhLdpKsB9MWwPRsR+KlBnk4gH1BIakzw==
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nvidia.com;
Received: from DM4PR12MB5278.namprd12.prod.outlook.com (2603:10b6:5:39e::17)
 by DM4PR12MB5055.namprd12.prod.outlook.com (2603:10b6:5:38a::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.16; Wed, 18 Aug
 2021 23:12:26 +0000
Received: from DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::c170:83a0:720d:6287]) by DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::c170:83a0:720d:6287%6]) with mapi id 15.20.4415.024; Wed, 18 Aug 2021
 23:12:26 +0000
Subject: Re: [PATCH net-next] ipmr: ip6mr: Add ability to display non default
 caches and vifs
To:     Stephen Suryaputra <ssuryaextr@gmail.com>
Cc:     netdev@vger.kernel.org
References: <20210818200951.7621-1-ssuryaextr@gmail.com>
 <912ed426-68c3-6a44-daec-484b45fdebde@nvidia.com>
 <20210818225022.GA31396@ICIPI.localdomain>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
Message-ID: <e7a1828a-d5bf-fa88-1798-1d77f9875189@nvidia.com>
Date:   Thu, 19 Aug 2021 02:12:19 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
In-Reply-To: <20210818225022.GA31396@ICIPI.localdomain>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: ZR0P278CA0059.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:21::10) To DM4PR12MB5278.namprd12.prod.outlook.com
 (2603:10b6:5:39e::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.21.240.22] (213.179.129.39) by ZR0P278CA0059.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:21::10) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19 via Frontend Transport; Wed, 18 Aug 2021 23:12:25 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 25464927-c30f-4cbe-a08f-08d9629da482
X-MS-TrafficTypeDiagnostic: DM4PR12MB5055:
X-Microsoft-Antispam-PRVS: <DM4PR12MB50558CCF26AE77E9C717B048DFFF9@DM4PR12MB5055.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: y6tmJBvqLsvLk5jeN8VdjaTZtB0j92JhHrDFzkIHoEjZIGU5xIrACQ5ii4ilHZPfqPp7eBCNxREEFIQHiAI3Aa9LLixMsZUdWy4CFcwbKFNs3+ZdP7W9Wz7kjXDiurm0thlQmUMB5TfLJOstIqT89TtW3CoNgXl8qbcQ3xQufoZQFu67zxR/jooICY+X5d9TgicMOSJjRHAuXeUAYASe662hBY4ZMuNEY58r+hO/vPy2tKASm4RiMY6Dj3yDMwYh66DNgu7bWlZ7ec3KvpWISuzpG6R9jCq/UeQiAuyRblG8cnx5bRX2FkxENeWCz5J0R/H3OeNVHMBXfvvhPL/KXDKr4TCtp1V76CLVm8BDl/SOK4nimr52W0GU54T6dED0PPepZIyJoVd16N2bWT61jeh9P5sDG01j0cfO9ZsKlmt/ni6cPL9c+gefzl0zsc93/DFnJTe4Ln3iKss1G9EVji2hDYsCc7RjjfzlSYNzcGdgvjZOUB5e56UgRsi0oNOa/wPDGWAQmQcwEpS09P5dppkCN8pedA2fRnPx0sdYLeKJ4BYVrRW+ISaKUb/QSEEmine5aA6Wa1UBjtjDfZc4PLdnShTNQ1T6KXGmt66Eg5qD55lpCf0fLUNuwW0sHWWbKmKEzy32Ey1+tAEUFC2cZNxV17KkEpV69KApV5hCFVQo22XLvOAtwurBaH1Ywc6DbbYLW+BL7ChHAGJwEzt9QYUsto8zEvJkoSNEI5f7vPmWrQDVN+I61ZYaO2QnzBByqOrWzP+1pZp0Lfr2sIc4uA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5278.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(366004)(376002)(346002)(136003)(396003)(6916009)(8676002)(16576012)(316002)(66946007)(53546011)(956004)(478600001)(5660300002)(8936002)(26005)(36756003)(6486002)(2616005)(6666004)(31696002)(38100700002)(31686004)(4326008)(2906002)(186003)(86362001)(66556008)(66476007)(32563001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SmZHUHdwcVQ2YWcrT2l4alk4ZGFQY2RvNnVKcnc0clcyUGhHTFo0aG9oMy8w?=
 =?utf-8?B?WGdFZ3BoT041UC9TSG0zUkRoR1I0OXA0NU9yTXVRMGRXbC9pV1IyQUk0VG9n?=
 =?utf-8?B?WGtsNlZPV0lETUdjUmdwb0t1THFNanl5cUJRZ3N0UGN3SkxEN1FTVmJQc3F1?=
 =?utf-8?B?SVBZL1ZsSVRMaEhWb1F0MU45QzFmb2hBYnpGaEZhYUdwYklHUS96QW9xQVpv?=
 =?utf-8?B?WW85QXUxV2lEbjdLaktRQzk5L3FaSnozWWxqYXc5aTFrbXNTb3lhNHAwMkZ3?=
 =?utf-8?B?YjRYcEdyRVlRT0J3RXZHR3VRN1dzNUZLZUtLemE1Q29BenJLSzd5RUM1ekRV?=
 =?utf-8?B?UlhIbXRETGI2WUIyWG5JOGNMOTZLNzJ5QjFmSzkvd2NpVDc3S1JoS1drUHpq?=
 =?utf-8?B?Vk5wRG94dktuNDN0QThPYXFiM2dXR2Vxd1lxdkNjaE5jSjVGVTh0NWtBZnZy?=
 =?utf-8?B?cEZKSG9Id0x4bXUrMUx5MVU3bUd1ZWljNUxGLzVrVXE0WHlXclBrbHBxTmVC?=
 =?utf-8?B?OE53RjVnWDhsbUwzY0FEYUpReml0eittNTVGQUovNXdNdU1jV0dFYWhlZE5i?=
 =?utf-8?B?MHNsTVFlZWhhYkRKcjlDKzBNTzZUeXJQM1VEQTlTWUVhU3pKUVRIVEh0NXJF?=
 =?utf-8?B?SUMyVWpqUklKaVBEWGZSd2UyeUsyMzlTczF5MUpsWVRHbUJhT1lVU1ZER2ZZ?=
 =?utf-8?B?WkFwNloyUVQ2MnlVOGhjK3ByWGJXTmc3QXVyODBsR2NYdmNyUWhzRGtuOGNK?=
 =?utf-8?B?RXVHcktvTTRlbmplYVdSWEE1Wk5INFh1OXc1dXR3dHI0RG1ndzBWRDRBeTJ0?=
 =?utf-8?B?dWtpWm5obktNWnl6VEw3K3NIN2lWUnRicDVFcFNoZWEydEUrRERMNllhMUtn?=
 =?utf-8?B?UVVISkJFUzJrdExIdDU1dUNqa2IzdkluNXdUc05hM3ExcExjb1M5cmExQTAv?=
 =?utf-8?B?V3dJbWpFL1dWam93ZnkyWDI5aU5GZjVXS3k4aVBzSmh4TFVaZkVDb1B4a3Nv?=
 =?utf-8?B?Uk10Y3BlVE01MndzOUkvOTZleFVsVWloSTViNUdEQVlxVWsrbnJNNUJ6bDVJ?=
 =?utf-8?B?Y0RjQWpvSEVEOFEyTk8wa3FTRGJUOGtFWU5pU3ZrMUtxSWpHV1hod2Z5a1hn?=
 =?utf-8?B?WGZFd0kvVzNJbm94NUd0L1BmTmhXdWdpck1vRnpDMUtOVUZ4ZjBZaStsa2Vh?=
 =?utf-8?B?VGVITmhja01qRzE2bzdENitpeEhDVU1NQloyeEg4cGxGK1pnZjY3R2VYMmo4?=
 =?utf-8?B?WXArWHp6dXhKZXlWN0NPa3JsakExSVdxVzJxZFRVVFBXTHBrdExDZVFGa0Iz?=
 =?utf-8?B?Rm5ZUEhzYjh2a3FHayswaEhyd2xyNk5mTzZJTlVSNzRVS2E4cWlWb3BPM0Rh?=
 =?utf-8?B?eDRSeXI0cTV5cjVhdDBqQmtaZDg1dnRhVlp4c1E4VzNDQUlIS2dzNmJkWTkz?=
 =?utf-8?B?RzFYdER0UkxXekVENFFqcXMrVnpZNThVeWtpL1Qvc01BMThxSEdrS0crRG5p?=
 =?utf-8?B?UjBmd0hwUDNhWCtDVURrdSt2VkZpUmwwaGdOa0M4K2NudFg5aEszUjlaRWNG?=
 =?utf-8?B?TktTcDRDSXFoeXNRQ2dMYVhKN0NNSExNY1ROUmhlUnpyR1lCL09KRU9KL0hr?=
 =?utf-8?B?dWdRcHhaTnZBaytWUHJNTTBzL3ZiRWZYNFI4UkswZmYySExTTFk4NUg4U3pI?=
 =?utf-8?B?Vi9idWg3TTI0bGJiS1luSVIvdElSRFozTnRTRWFaZzFneDNpUUFyVjBINzFh?=
 =?utf-8?Q?u8KkygC84MH73lk695nsQL4edn/6MG8uLvTgsxv?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 25464927-c30f-4cbe-a08f-08d9629da482
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5278.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2021 23:12:26.0033
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QKm8SpWwRHOmBSszvdxm7MrUEiq35/vYNWNUljiI6gDdfgsf6p5xJsZpWdAdcjCxEB2ZyRFDfIxsgFFYTmZWdQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5055
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 19/08/2021 01:50, Stephen Suryaputra wrote:
> On Thu, Aug 19, 2021 at 01:37:21AM +0300, Nikolay Aleksandrov wrote:
>>
>> Sorry, but I don't see any point to this. We don't have it for any of the other
>> non-default cases, and I don't see a point of having it for ipmr either.
>> If you'd like to display the non-default tables then you query for them, you
>> don't change a sysctl to see them in /proc.
>> It sounds like a workaround for an issue that is not solved properly, and
>> generally it shouldn't be using /proc. If netlink interfaces are not sufficient
>> please improve them.
> 
> We found that the ability to dump the tables from kernel point of view
> is valuable for debugging the applications. Sometimes during the
> development, bugs in the use of the netlink interfaces can be solved
> quickly if the tables in the kernel can be viewed easily.

What does that mean, are there bugs in netlink dumping capabilities?
If so, fix those. You can already dump all kernel tables via netlink, if there's
something missing just add it.

>>
>> Why do we need a whole new sysctl or net proc entries ?
> 
> If you agree on the reasoning above, what do you recommend then? Again,
> this is to easily view what's in the kernel.
> 

I do not. You can already use netlink to dump any table, I don't see any point
in making those available via /proc, it's not a precedent. We have a ton of other
(almost any) information already exported via netlink without any need for /proc,
there really is no argument to add this new support.

> Thanks,
> Stephen.
> 


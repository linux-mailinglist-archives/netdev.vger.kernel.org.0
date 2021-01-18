Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 101052FACFC
	for <lists+netdev@lfdr.de>; Mon, 18 Jan 2021 22:54:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732635AbhARVyR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 16:54:17 -0500
Received: from nat-hk.nvidia.com ([203.18.50.4]:12744 "EHLO nat-hk.nvidia.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727415AbhARVyO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Jan 2021 16:54:14 -0500
Received: from HKMAIL101.nvidia.com (Not Verified[10.18.92.77]) by nat-hk.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B6006035c0000>; Tue, 19 Jan 2021 05:53:32 +0800
Received: from HKMAIL104.nvidia.com (10.18.16.13) by HKMAIL101.nvidia.com
 (10.18.16.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 18 Jan
 2021 21:53:31 +0000
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.42) by
 HKMAIL104.nvidia.com (10.18.16.13) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Mon, 18 Jan 2021 21:53:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gv0mYdUbqWdh+gNYvNUCin/KBy3uuGCNxrgD/jTi8D10Oya2bCDe5bpPeVy43oT6AwfInC/oCuBGFzI2SpaXIs8tsBJKUobqDdsuosXKJrfQGEEwOc87KFVYapyGs9nnGmeyNz2DMHG63c6ekBL7VoYGTVcfnCaUj4iHQoZBImwf2WNkx3lcOT8492zsv+TaU2wwKOr+QaCp4EcDqlzTeRYWrCYlgfLf0EDmg6ZA5ksJPKpGOJLUun1GMuzrnMYvombE7qNNkC51/EF7eczE5cQY0gEEXjWqIJgDN2fU/U1LRYRl+5IbZps0RBFFUWPDD/mdTDptVvINBBQ7NdXWPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jb/C7E8/MOD5lUe7VYoBN3pqDHbtqVxHvOBdmk+HaPM=;
 b=RFBFUNthyXoDn6Yfs271F2yZr/wAiwaBetFZ87TKkhPciUYnNanDDV7qbJ0ELrxXfPvFKNqUCidr4r4thJMRIQauVw9X0X2MGRTdiK98A3KL0pFfnMq15ATy04agPwOH02o5+eSGmkU/L1rDJXmzmi4IzLYoDkG//fZRVyCqSlpVYzTh3LD7W+FNeVnLVadhMKBOqF3Hnmr1Rpp30opgQ81VaA+jFJzNbK1ABoHGULn+9cj4IRdz9fWevBD07uqXHRDPqizzgV6EMd6e8dnmRClx52cOxvvoyKrv1rIo7+Z3xl8ZCoFpZDGN9jNVXYGWJ2a8UgUDg9dEiOzndcrjjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Authentication-Results: networkplumber.org; dkim=none (message not signed)
 header.d=none;networkplumber.org; dmarc=none action=none
 header.from=nvidia.com;
Received: from DM6PR12MB4403.namprd12.prod.outlook.com (2603:10b6:5:2ab::24)
 by DM6PR12MB4894.namprd12.prod.outlook.com (2603:10b6:5:209::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.9; Mon, 18 Jan
 2021 21:53:29 +0000
Received: from DM6PR12MB4403.namprd12.prod.outlook.com
 ([fe80::6:2468:8ec8:acae]) by DM6PR12MB4403.namprd12.prod.outlook.com
 ([fe80::6:2468:8ec8:acae%5]) with mapi id 15.20.3763.014; Mon, 18 Jan 2021
 21:53:29 +0000
Subject: Re: [RFC net-next 2/7] net: bridge: switchdev: Include local flag in
 FDB notifications
To:     Vladimir Oltean <olteanv@gmail.com>
CC:     Tobias Waldekranz <tobias@waldekranz.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <andrew@lunn.ch>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <roopa@nvidia.com>,
        <netdev@vger.kernel.org>, <jiri@resnulli.us>, <idosch@idosch.org>,
        <stephen@networkplumber.org>
References: <20210116012515.3152-1-tobias@waldekranz.com>
 <20210116012515.3152-3-tobias@waldekranz.com>
 <20210117193009.io3nungdwuzmo5f7@skbuf> <87turejclo.fsf@waldekranz.com>
 <20210118192757.xpb4ad2af2xpetx3@skbuf> <87o8hmj8w0.fsf@waldekranz.com>
 <75ba13d0-bc14-f3b7-d842-cee2cd16d854@nvidia.com>
 <b5e2e1f7-c8dc-550b-25ec-0dbc23813444@nvidia.com>
 <ee159769-4359-86ce-3dca-78dff9d8366a@nvidia.com>
 <20210118215009.jegmjjhlrooe2r2h@skbuf>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
Message-ID: <4fb95388-9564-7555-06c0-3126f95c34b3@nvidia.com>
Date:   Mon, 18 Jan 2021 23:53:18 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
In-Reply-To: <20210118215009.jegmjjhlrooe2r2h@skbuf>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [213.179.129.39]
X-ClientProxiedBy: ZR0P278CA0083.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:22::16) To DM6PR12MB4403.namprd12.prod.outlook.com
 (2603:10b6:5:2ab::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.21.240.90] (213.179.129.39) by ZR0P278CA0083.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:22::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.9 via Frontend Transport; Mon, 18 Jan 2021 21:53:24 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a821d6cb-94b3-4cd2-6911-08d8bbfb7d4b
X-MS-TrafficTypeDiagnostic: DM6PR12MB4894:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB4894606247B174DBF43F5F6EDFA40@DM6PR12MB4894.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 89RfhAljtfNPxcrHsoDxRteX5CA2B5L4MTw8Q2bro4jnti6cbcafsXV+AGFvtdShMhl5ZhtCvB1JSUZrG1o8Khm1QUN91DZo5RYTN+PkMR6FjMmb2naGIHGCV5AItj6oaaWhNKEHENBMPSCMhH7mGDupikvdiseKn3kDBV/wt0Kz/RMmtCb5sSaLmNPe56JcN9n+px7M63qUCHRh2O/vjnganNuwE1s9bTZLxtQGdL6P4wX4tlujn4+r19dYpVGLl6bjMpv2B+sTMf8ZofA4lAQ3+i5ZQdp44nmMutX8gGaCXnT4NgB4fb+LGFJIMvpcCw4HFzFYn9EQPRdhJyFCbHjXwON7BVaYHhCiga6u4ZM3GZrMboctNKnQkc+jUbTpkfnSmgLdvs6wHZ6/OPhvYedP0MYIGWjoHtgF35XPXmeEL6Izw/qQEWG11hxbimbvSIaNbFoMD62iWP2JxnhK7Miv+ZY6+mbb2qXAMAo89Es=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4403.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(136003)(366004)(396003)(39860400002)(2906002)(86362001)(8936002)(478600001)(66476007)(66556008)(26005)(31686004)(6666004)(16526019)(31696002)(16576012)(8676002)(316002)(66946007)(15650500001)(4744005)(7416002)(53546011)(4326008)(6916009)(5660300002)(2616005)(956004)(6486002)(186003)(83380400001)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?WmpBMUNlOFIrMTcxTkFHamxudlZYSkFQTmNhL29OUi9kT29VcWg1bTZaVStO?=
 =?utf-8?B?THNXTE94YldxUzBUKytnOStraVBEVjRlMWdlVGNnaDV3ODlYbzAxdkVVWHdC?=
 =?utf-8?B?aFd3WTJhWFRRQ1hXU25rUUhTZFNPRkhQUTl2ZmtrTDg4YnlWQU85WjdpZnZ0?=
 =?utf-8?B?ejgydTZUdmg3N3FtaHBZU1R5MW9BMGpXLzBLNGs5dU1CdUszZjA4VFFBcktJ?=
 =?utf-8?B?US85YWlVSVJuQmVMYXdNSCtMb3p4Y0l0U1B4bGJkME1EYXlNODMrTm1mcVRX?=
 =?utf-8?B?TW5Pa1VzcEpnOTQ3R2V5NUFvNlZmQlFaNGxxWjY5bjZQL3Z4WCtIZzV4OW9q?=
 =?utf-8?B?ODlBZVgxazFrcXRIc2NBNTJBRUx1a1Y4NjJYQTg3QVpRcXdONFZKWndBZjYy?=
 =?utf-8?B?YVdvS1kvVXpLeCtFVFh6S2wwVFIyTm5PV21pSC80YmNrbC9aTG52cHFnVzIy?=
 =?utf-8?B?M21xZnBOMFE4by96Z01VMDRiRUQ3V1hKR3pPZVYxejlxckVLcXlDbWYxb014?=
 =?utf-8?B?ZURIelJiclJuMkVyK0cyajBrVUdPUXV4RnZacVpjblBkYmRPM2ZDdjVNZDRW?=
 =?utf-8?B?ckRFVFFDNWkvL21oeFd6Z1Z3RGxkQ1hTNFlmNDBWUWhlOWVQT2xDa1NKUFdv?=
 =?utf-8?B?RVNzeVFUQWNqYy9way9lT2FVUk42OS9uaEtPcEJiTW45VkkzbisyOXNseisz?=
 =?utf-8?B?M3NhbHhLWkZEUU1HSWNVeW0rK1VHNVo5RFZqNHlLa0VGT1ZxZzRmRHNTQ2tM?=
 =?utf-8?B?bTl0ZndVb2h3UjBpU3Y3NDVyZUFzdHpiWk5hS21qSnBaNHg1ZHNrSkJyMHFw?=
 =?utf-8?B?RnpLOE5iWFdUaDdFZ1FIMmpoZzJocm45ZmMzaGRUbHhlaStNK2hkNWJNWlkw?=
 =?utf-8?B?c0hXK0pxWkdESENPMVdWajBlSkp3K1lqQVlnZ0drZWdUdWkwQXV2S0FsZUNy?=
 =?utf-8?B?NTl4NWZSY2J4ckQ0d09veXJoSWZjdGxVQ0phaHpoV1l5cDhjUDk2UkNteWJH?=
 =?utf-8?B?ZnNpVWFaTTZ4bzM1TzdIbDd4UFFUQm0ya21CRUgyVm9rYTd5YVFjd0dWUEdD?=
 =?utf-8?B?aFlrMjdBclRoTkVQODcwV3lUMFdJNnVXcXBYZko3ZkpoUXhWRFcvbi9LVWxt?=
 =?utf-8?B?aXd4VFhHbFk2YzM5ZG1CZEVyenhYT29vZS9UWnRaa2JWRUl6N3JHT04yMW9L?=
 =?utf-8?B?cFZaRU9ZbXoxRGo1NHNOMlFKSmFmTFpiWGVGczVHMW1qdGdobzV3TVVOMThq?=
 =?utf-8?B?UVNDM0pwMHJENGY4WVc2Z0M3VWFJbGkvMDB5NW5RVGE1VjU0STZkeUk5Snlk?=
 =?utf-8?B?OTFVUGRwK0NNWGVtOTdjbUQxRCtFMjBMRnRXTmxsa253c05ZZ0VSZHVoSk54?=
 =?utf-8?B?czluaG1LR2FMd0ZhbnNIRmZIZWdqNXJyUlAxb2lIU0lTVFRoV2gvQXRwZWVq?=
 =?utf-8?Q?cVOyz/sb?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a821d6cb-94b3-4cd2-6911-08d8bbfb7d4b
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4403.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jan 2021 21:53:28.7648
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Q14BPoh3lhhqA/9fvqFh1W0HtKTVaMl8Grx2eBkLpneLhvJuBri16kvAqVDKc+wnKtiLeUZDW/851YH5A+hEtg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4894
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1611006812; bh=jb/C7E8/MOD5lUe7VYoBN3pqDHbtqVxHvOBdmk+HaPM=;
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
        b=KCkJAgeee/Adk+xKg+1VQXzkfCEKDNFS7ekIWBbq0pYevM1vY1icvkF1ejgYnYQWM
         2sPdYvXJrh1Zb7+MKEal/TZJM3n4Sj0CNf1a5bkfaTwOu68f2WKlSeWqtnW4iwXIKJ
         dQL8u1fKl1tp53YSsx5wVvZxYXaSch4jV+a28mjF99z8l/IF09isscnoJK+aQ0W9ji
         Fr+OLBWu4H2hPai979DzKlN4I8iQ7gU/Zbc0Ojll4yp8BSvqY8jnmL7qgkhRtld+ep
         8in4iIgGuYLVb/GP/P45x+Pb9zC5XKnHN+ucEpHbEpcNAvrMGgiW1kq0meNkz/NChE
         bObXjkWYGFJWw==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 18/01/2021 23:50, Vladimir Oltean wrote:
> On Mon, Jan 18, 2021 at 11:39:27PM +0200, Nikolay Aleksandrov wrote:
>> Apologies for the multiple emails, but wanted to leave an example:
>>
>> 00:11:22:33:44:55 dev ens16 master bridge permanent
>>
>> This must always exist and user-space must be able to create it, which
>> might be against what you want to achieve (no BR_FDB_LOCAL entries with
>> fdb->dst != NULL).
> 
> Can you give me an example of why it would matter that fdb->dst in this
> case is set to ens16?
> 

Can you dump it as "dev ens16" without it? :) 
Or alternatively can you send a notification with "dev ens16" without it?

I'm in favor of removing it, but it is risky since some script somewhere might
be searching for it, or some user-space daemon might expect to see a notification
for such entries and react on it.


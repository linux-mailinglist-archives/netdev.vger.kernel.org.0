Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEBE4412FA2
	for <lists+netdev@lfdr.de>; Tue, 21 Sep 2021 09:43:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230271AbhIUHpK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Sep 2021 03:45:10 -0400
Received: from mail-bn7nam10on2077.outbound.protection.outlook.com ([40.107.92.77]:50784
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230172AbhIUHpJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Sep 2021 03:45:09 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KuWbj8T7u8QpS9Q6S6HPXPRztbpLC3KXs5/Alck+mYALhvJhf/Q3X5ge+5Z8t81NBPrNpAe4Ynkcpw4luS2su1MUc3bxigwqyOjyLyKAiW8smFQ5wAPpcHAI7a+OdiiGR7K8NSEZsAzsVL6kbyzjxM/IFOat2n2y5Jsz3Q9vV71/5O2vzUpsk532QkPDk/yvDhWqk/izYgFkzSWGo3Z1H4t1N4HSjeJe6JePrPXkmeOF+vfiokMCOb+OyCOkLlFcdTJN3qX7B5kWEm1wZZSH/fCGyS5iH9nOtMgeDDNze4MMU64SnVylcsbjxZnLU8Ks4+DdMYm3L+gkjXRze4VwNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=7M21dL3PJeP2QpDKsAMgWQdeY75fmMsnvVRBRMLp9PY=;
 b=WlZT87ckYRo6diCm8i8OUWNgz2ZWDG4/qalnMbRnxXQCwC1ANJd/bJXgUaf1Fg43WOm/BTAkTfQtrYYc1nhrkLxrvqXWTlsy8f4hopWFsqehFmuJXwUxbYkih8AMdLF/eNkF3SrX2atpqOjmQSKRIFoLC+KUMxG+soGx1HB7m3Ce5pqarE9S5Z8mDjkp8WikDT8HFTzEmMcsyMXt4+DgFnkYVgRGL7xdDLDL74ZHbSA+FrDAVlwodaa9zl+ggDIvID/qyU0j7fMbtXSdyBOSjzM45Sogdshi7VdN8qPVySIM2O3VWJcLFYb+rypAhnRUetj2AmJYpXT4eH5jhdP7DA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7M21dL3PJeP2QpDKsAMgWQdeY75fmMsnvVRBRMLp9PY=;
 b=GcJ4ntt045TVwXp6JX7YgwhCOAgQzb8jc6mwJVSZPAyDVl/EP10qc6YP/KbhxO65FeauhDaSO7CCVHIYi6N30bq9w1Z5Mwnxvq66IpidXIMQXI2j2IvS7dOpN4t0LCABljxc/LRCaLWELWIcgNLCQoWlhNQnllj+TfuiK5nihgnPaWu5pmtY25yWb7dK29W5bDtrae+HRKd6sUI87zfqtUaP2Evqzrc6GPVthE19m3bfPQ3d9iWsW76r/NsIN7phgoxW0qigs1HArcTO2lwb8ZVmTc8CqofGMLz8Mv0syh8DY7/vpfLPUAwVjxgGBNVFJJWYSHEUouMwjp0WUCcNtw==
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nvidia.com;
Received: from DM4PR12MB5278.namprd12.prod.outlook.com (2603:10b6:5:39e::17)
 by DM6PR12MB5518.namprd12.prod.outlook.com (2603:10b6:5:1b9::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.18; Tue, 21 Sep
 2021 07:43:40 +0000
Received: from DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::95f7:ab4d:a8e6:da7c]) by DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::95f7:ab4d:a8e6:da7c%9]) with mapi id 15.20.4523.019; Tue, 21 Sep 2021
 07:43:40 +0000
Subject: Re: [PATCH net-next] ipmr: ip6mr: Add ability to display non default
 caches and vifs
To:     Stephen Suryaputra <ssuryaextr@gmail.com>,
        David Ahern <dsahern@gmail.com>
Cc:     netdev@vger.kernel.org
References: <20210818200951.7621-1-ssuryaextr@gmail.com>
 <912ed426-68c3-6a44-daec-484b45fdebde@nvidia.com>
 <20210818225022.GA31396@ICIPI.localdomain>
 <e7a1828a-d5bf-fa88-1798-1d77f9875189@nvidia.com>
 <44c43842-2e5a-4e20-b2e6-9f2f2ae6cf0f@gmail.com>
 <20210920234909.GB5695@ssuryadesk>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
Message-ID: <f67bebd9-24d8-69e1-0239-f4bc79ca0116@nvidia.com>
Date:   Tue, 21 Sep 2021 10:43:34 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
In-Reply-To: <20210920234909.GB5695@ssuryadesk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: ZR0P278CA0060.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:21::11) To DM4PR12MB5278.namprd12.prod.outlook.com
 (2603:10b6:5:39e::17)
MIME-Version: 1.0
Received: from [10.21.241.228] (213.179.129.39) by ZR0P278CA0060.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:21::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.16 via Frontend Transport; Tue, 21 Sep 2021 07:43:39 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f572d9ba-7838-471f-625b-08d97cd387b4
X-MS-TrafficTypeDiagnostic: DM6PR12MB5518:
X-Microsoft-Antispam-PRVS: <DM6PR12MB5518099EFBECAB6DED76B78EDFA19@DM6PR12MB5518.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ULfYtB7XTYHtvz24juw4595YnlTaMFltt463vs80BBv55lLzktdURaG9qUmdb0oxPUcJEEsGvV5SEp/Yjv9pLJmoexAdK48AE1vw7zeOjNvGP/BJIAZQbYyFUk5xR9MoPle1vaihZWdg7ZwYjRY73927UM4WPpsgPKiJOdbG0yEUwRnxEv+WyG9NSFz/GILcJjtXQ18DQ9YYjtQgpiHljhNg5hnZDQOgQzeeLw58kyPxTsKekgumvjejN7p7FYSvT00oNmVf65KIXhhK5yXkHWskuipWaQTvSVBAqRv7dVLW/wq1slEslLJ5S3AZDU2dKBRR+FSiNhmhvli1EHohv0vvm+foeu2+pxXntqD8iqenPKM0VmASyfH3PdcOvt4iFCaFKo/GWvyA2GUX44baWrB/yDtDhqxxbGZLTkF/pHlob6zBhrezmY/ScOSRlZ+yyjcSQq8swOgitH8uc4q9Xdd1dbfZEpcaVaf/p8HLp7Cca4iSvBsl0ZRn1OshaPVWMchwJ2bzh4duxO9zFecO1zconNqr958q7SHDEO/J99zGgDAjbSpfoKGTjeWtbqnItrsVwlw2Spj+MorleLByTeaydjdNFPs5XPIPcEzWpxNPzbY9iWnO9h0QnPiVRvzhfn2VfI6waxim4cgoZ+tBNMfjyDBeauUJV4EIhzAhkh8tNCUCvV46CWHFhCdSqbDtANaA3BodBlA3y6FT8de4EvDiYJFmGmYOyxoRt3uYXozAdn/rqCe6W/EHfaM0r4S+
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5278.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(83380400001)(26005)(31696002)(316002)(6666004)(36756003)(86362001)(110136005)(66476007)(4326008)(16576012)(53546011)(66556008)(8936002)(186003)(508600001)(6486002)(2906002)(5660300002)(31686004)(8676002)(956004)(2616005)(38100700002)(66946007)(32563001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Um1YZ0MveXgyTXJGSzQ3WnZIYUNnRS9nWElPZE5WZmEwV0NxMThDUVpLRzZ6?=
 =?utf-8?B?d283V3ZjalNVT04zdTBtQjNQdGUyVkVGQVpQQUY2Q0hFYXcwalN3OVgyZ2w2?=
 =?utf-8?B?alVUZmNqSEZGbW9Yenp4TC94TWlGZTlZejlpeEZIdFpNWjU3VmZaeklHdGJD?=
 =?utf-8?B?bms0VlptTUNKTnpQenI3bVRtRDdMdzFlT2pUeUpkQU5JaFJvbFQzRHRvZkJu?=
 =?utf-8?B?TmVkRDV6MkRpT1VUL0NVUFhOR0ZZaFVHeVNUTTJUWjQzMXFFL000NnVVcmw3?=
 =?utf-8?B?RFZ1akFRR0s3SC9DbnBBSENTKzYrckxTR1EzUXpTM0ZyQWNXWGd3eENEa1cx?=
 =?utf-8?B?SjZhYVo5dkpRcEs3elRtR2NNUUdKMXV5bEczUGNwWHBKTmR4WU5MM2YrZTJl?=
 =?utf-8?B?ZFRRcjRUUkxyOVJ2ZXlQYVhFUXFYOXpabmFSYUlGKzlpci9na1hVRUVHVHJw?=
 =?utf-8?B?Ty9aT2xxTG5OMG1wK3NYMmovTUtKckJoU1doVjRXNDRob3hZQzJJTjNqR2R3?=
 =?utf-8?B?eGhoL3NZelQvbFUrRjl5QWROaTlyQXpuc3UvWVJDUGppMnBocGpjOU1ibWp1?=
 =?utf-8?B?KzJQQlpISXM0SWJpMHl1VmJoMkRPMzVwMHhlQkxiZHNNcnFRTjdwU2R1Y1Zi?=
 =?utf-8?B?dDErS1VCa0VBTkVZY2JGeFdpMGdJeTVPK2ZBODcwUmd4UzRrc2JkYU5KRytV?=
 =?utf-8?B?RWY5RmczaVNxYXZJeEhXbXlTREVacUFuQ3RqUGhEWlJoTTlsK0kxMFFJY2xC?=
 =?utf-8?B?VjR0ZmRFaEM3UzdsaFpDMWU4OXhxWi8rOXd4V2thTVNJZXB4bnlwcTIzNE1n?=
 =?utf-8?B?ak5OYkJmSjJxSm82Y0orU1lJZlVCUHlBbXZidFNnVnU4dXRKM0RhbWZlL1Rv?=
 =?utf-8?B?aFdPV3FDYVlhM2toN3NucEpiK3ZKWDl3QnFPRmVvYW9RSzFiMHAyUStlb1JG?=
 =?utf-8?B?amE0QytqZ2s4RlFGTHZzYkVVZHZlU1gxZEh3RlN3ZnhMMXM4RVdiRHp4VG9o?=
 =?utf-8?B?a0lnUGV5akx6c0J0MHduOHR5NDFQWTFEc21RNXNiWk9GZWRlZmQvNVhVLzBW?=
 =?utf-8?B?ZFh4cEswWVpzcVlZNS9zQlY0cDJSQjJLMWlzWHY4QWUySFVnWERaNTRsdGs0?=
 =?utf-8?B?RUk2c0E4d0t1MlR4N0oyNFVJaWxuQy9ac0thK0dsbyt0Sy92SVdvaURYR2xU?=
 =?utf-8?B?cHNyNGVYUTFTRVpIUUlibnFiTyt1czBmd1JnNFdTUy9INWVqTm4xcUp5TUFw?=
 =?utf-8?B?S0tCWXdIN2ZPNUJzZU5yN2tXSGYzNTM0bGtTVkVYL09RbHg2b1o0YmJ1ZXBl?=
 =?utf-8?B?VUJhRVNHUzJOYTN1MWdXNDlJSmhnYnk3WUxmWEwxZUVFaUM0SjBscWxWNnJ1?=
 =?utf-8?B?TWRjeFloWUVaRUZMUnZtN3dNQW9jTE5ZaXpjaUd5WUIzWDdybWtnQXJ2bW5Z?=
 =?utf-8?B?RitFM3NwVWQwdnBUUktVM2FGQlRBR1FtVk0va1ErakFNQmF2UUozM1U3Q1Rn?=
 =?utf-8?B?amcvbkhMN3h0dGdwQVNqT0NQOHpGZmIrNlUyNExxTzcxSUtyZDRPQzB2ZjF0?=
 =?utf-8?B?ajJsc1VQQXBmc1NGNkJSZ05hVFdVOXRTY29hblF5M2Flb3d2VGZkc2RKSlJ4?=
 =?utf-8?B?UWY0YVNIUkVZQU1jSytpeE1STEtCUVJZcXJuM20yR1h1cHlxVEZ0UXJvamZ5?=
 =?utf-8?B?NnlnMHZlaCtWNFAyZTBLMUVFaEZZZDYvNWJiUGFWS2QvWE5NTmxHNkl5ZEVy?=
 =?utf-8?Q?nqz1obvGTsc1jIuGAwnBdT95QIq4MCKF+cgMUP3?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f572d9ba-7838-471f-625b-08d97cd387b4
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5278.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2021 07:43:40.7699
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mU9ykSy+hhZBKcg/YWh/QLepaeeZAj3ZqnueF3dDV3fxSQGkdX3KkrqHC7txvN6ZFC38HF+w/dLWisu+xdvZBA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB5518
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 21/09/2021 02:49, Stephen Suryaputra wrote:
> On Wed, Aug 18, 2021 at 06:04:12PM -0600, David Ahern wrote:
>> On 8/18/21 5:12 PM, Nikolay Aleksandrov wrote:
>>> I do not. You can already use netlink to dump any table, I don't see any point
>>> in making those available via /proc, it's not a precedent. We have a ton of other
>>> (almost any) information already exported via netlink without any need for /proc,
>>> there really is no argument to add this new support.
>>
>> agreed. From a routing perspective /proc files are very limiting. You
>> really need to be using netlink and table dumps. iproute2 and kernel
>> infra exist to efficiently request the dump of a specific table. What is
>> missing beyond that?
> 
> On this, I realized now that without /proc the multicast caches can be
> displayed using iproute2. But, it doesn't seem to have support to
> display vifs. Is there a public domain command line utility that can
> display vifs on non default table, i.e. the one that uses the support in
> the kernel in commit 772c344dbb23 ("net: ipmr: add getlink support")?
> 
> Thanks.
> 

Not that I know of, this was supposed to be used by FRR but other things were
eventually given higher priority and it got sidelined. I'm sure at some point
we'll get to using it in iproute2. The netlink interface can also be used to
extend the number of vifs in a dynamic way, it'd be nice if we finally deprecated
the old static and non-extendable interface and started using netlink for ipmr.

Cheers,
 Nik

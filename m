Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70E4642ECED
	for <lists+netdev@lfdr.de>; Fri, 15 Oct 2021 10:57:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235885AbhJOI7Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Oct 2021 04:59:25 -0400
Received: from mail-dm6nam10on2046.outbound.protection.outlook.com ([40.107.93.46]:60096
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235827AbhJOI7Y (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 Oct 2021 04:59:24 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XhfnSheHzEHz0oWUVqk+bLjZKLAQq6NYYv/oQlF3jnw271Vi7w9/ucig2yhJQgjwxm82e3wigvx5/Z0cAoHQW1qV85cBWgbdKn4Nk8Yva2mNcLmVzmidnYApjDGVypG3FKqLndgp3Vb4pkb2LDUy1ksq5ApA3Ckt0Rz2tNsFOM0elej0Mdi+w/A3Yr+XOPw4K+gi2G8X9mDQxc25IZ9Lzxg2K58Vb2f32wre2ZDM2EkPfnEbgSpMIK+rIWJRyWUCR7v1687KCWgEHVdnOQueqfba36YhE0GA36a2LPmC/3t3wHWSnWgeEVHCdUHXd+wG3YVcfnZ6xgZ1piBapQAd8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OxwfMucszAHmFn0SxPBFzomXvRwRf/HVQvasE15qa6M=;
 b=g15XT0L+igPy4sa5o0ohYToUTuRLNMb1ogCoQe7XVNGWgvOYwIhYcvA0uqqoK6Mqv+WAyvpvMyGPJT9zuaUFa6C/RSXjMu+In5ncpwfY3uwtNP9DG2Zk6KnXOiTACKFBCG6fDTGJQZDkPQTiFgotu95VEY1IBzMuu+z0BNrRjs6tn09uNy4Kfw5KfpM9+Mowb7CjUmOZBiy+uwNbUne3QYvcfLn5vWQKPVx8w3OsnNKqq4NQPADa+tnO7bnDPh/TISQiwE3N/253fYso8R/WwV+z9gPhu6wD+ksopqF3I4BA7Bja4wGmRB3ZWQXLZF+jYuA4wUMg3NdCeVTzKqH/Ig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OxwfMucszAHmFn0SxPBFzomXvRwRf/HVQvasE15qa6M=;
 b=B60ZqjvipXML8Pb7Y088vwFpqTjPBCtSKGhNrR1qM3es02JDmitGMK7FzvJUZQrD/GDjgZe42BlFSn63KvXtFPm4zDWZApMB7H3uXsImqi7ob4CZMXLEgG8aCCV88XQaDRxUSz00LVYWGF2+47Boi91vF8kr9YybGyMxHKUL9Uj2PvG3JkCyoDvC8sixxe5TH3um7tb+S7Ard+YhUC9v7olU3uibcB3CWX91B/4dooTaFsw86XgPjFcTjrykrs3lEdINJQJLpHkEopnDtPXW/nm0pfhdVOraExQs/aOQc61M0F4pxaWRThfo97PMM6kKL9UFszx+ujpgCcq8x4WkaQ==
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM4PR12MB5278.namprd12.prod.outlook.com (2603:10b6:5:39e::17)
 by DM4PR12MB5151.namprd12.prod.outlook.com (2603:10b6:5:392::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.16; Fri, 15 Oct
 2021 08:57:17 +0000
Received: from DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::513c:d3d8:9c43:2cea]) by DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::513c:d3d8:9c43:2cea%8]) with mapi id 15.20.4608.017; Fri, 15 Oct 2021
 08:57:17 +0000
Message-ID: <357fad9e-581e-7b71-9b32-aac77d5d13c1@nvidia.com>
Date:   Fri, 15 Oct 2021 11:57:06 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH net-next v4 10/15] net: bridge: mcast: support for
 IGMPv3/MLDv2 ALLOW_NEW_SOURCES report
Content-Language: en-US
To:     Hangbin Liu <liuhangbin@gmail.com>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Cc:     netdev@vger.kernel.org, roopa@nvidia.com,
        bridge@lists.linux-foundation.org, kuba@kernel.org,
        davem@davemloft.net
References: <20200907095619.11216-1-nikolay@cumulusnetworks.com>
 <20200907095619.11216-11-nikolay@cumulusnetworks.com>
 <YWjsyk/Dzg2/zVbw@Laptop-X1> <YWkhi7iABEKygKaL@Laptop-X1>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
In-Reply-To: <YWkhi7iABEKygKaL@Laptop-X1>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: ZRAP278CA0005.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:10::15) To DM4PR12MB5278.namprd12.prod.outlook.com
 (2603:10b6:5:39e::17)
MIME-Version: 1.0
Received: from [10.21.241.24] (213.179.129.39) by ZRAP278CA0005.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:10::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.14 via Frontend Transport; Fri, 15 Oct 2021 08:57:14 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5ae099ea-f4cc-44e9-f14b-08d98fb9c9d5
X-MS-TrafficTypeDiagnostic: DM4PR12MB5151:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM4PR12MB5151BBADD8BB8106D3E1D3E3DFB99@DM4PR12MB5151.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Bf3JqKULo0F0vY41ZPzEZ2OOye3+1LCvtUpJfecqAtttK/ohZN0uKR5RSvk0D7VfykAWps2TsGzuKf4gVJr3siWh4kgiBNPKqkiKHu2nm+4wn/Qmq5MojU49aVVgJ3l3DMoGd1X6F5e+8ifoOAZUsaDdChFa8h0p0OGplfLXFkMeDNo41Af4wDX0chviA+MUAhdUw7UED/792IWtCTdKHcbJnbf8/fDT2Z2IHPjRktYHMFSlPMmduk997cv5aHtNL7B1XEPIS6xlmyt3ahqjc4kIwo/8oSNoSorF6CBVB8jyznJxXTuCfO7mz610tGssA8O5Owna1LwOT0EtGrsvrWdhw2ECqYh64OIo1YbGTroBSFj4cQAzuiSdTIMn5keOO62ukhdGkjGILAV6+15VC6tvmDW22z08navMUxKYATYiuk4zx26Dv3amcV3mW7+YPZkJiEIvMFhCBd+JGWiIElhUBo3ZWEGg1Czts2ZDpVTtTdijS1sOYLD/T+azctN1Nk0MmlGfCNQkiVnKovY4FsbOusQku1PL3PUulON/PURunPMP0RrZWPOtRA28bZ0DntjaBeV7Q9omKssmBpXUevHlvxXKRSAwMxfC+paoQFVXjpD3xmyMAwb21Pf64dbHWL381EvY6acvQAfrl02YICgvG5SJSMmq5JPDWZ4gdpIHFiTF8HH2zmEVku6E3vC/OacfcLmPNsVIN90rnQ5ChazkgvNhv1G6XBXx9zGpbb4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5278.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(38100700002)(6666004)(6486002)(26005)(53546011)(186003)(83380400001)(956004)(2616005)(66574015)(2906002)(8936002)(110136005)(31686004)(508600001)(36756003)(66476007)(4326008)(66556008)(8676002)(66946007)(16576012)(316002)(31696002)(5660300002)(86362001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cmpEU0dSeUlwdC8ydjVSTjg4T0tnWjlYb2hLK05RNmFqUlpMZVJyeTBISlJL?=
 =?utf-8?B?WVZ4MzNPK1NoZ2czWjVTWFcybm1ZeEZaN2xwdmtvMnBkNU1wdDl3eU1hNFA1?=
 =?utf-8?B?QkFQOFZKZU9XRU1iUHFrUWRoQWFVWkt5K01qZThHamZwdzk3cHpCbUR4ekdj?=
 =?utf-8?B?QTlveWJicER6L1E1Z1VuNFBmVFRYeldndGpkb3l6bFZ0UHhmcklDNGNtUlMw?=
 =?utf-8?B?YTF5NVZiTnJGQ0JOZDcvb3d2cHV0dmtXU2toYmJ6a2tQTklRclNYUkJoZE1O?=
 =?utf-8?B?RnVWY2E2c3ZIY0ZUUENJOEFxbWttOVpRY3ErRlczc2ZMeWt1REU5cGg1SkI2?=
 =?utf-8?B?bCtsaWFReFZNTDFPeWpDb0czRDdyZXlNclpoQlhORUNIam9sK3MwTUFsZmNW?=
 =?utf-8?B?bFQ0V2RnQytBdG1BcFFSQmlza3Qzak85RVJsOXN5RERMVWxUNG9SK0VXUktq?=
 =?utf-8?B?QkhtZmNORWR1SVRvZmd2Yk05akhxbkp1VVpNM0x6c213MXNtK0pSTGM0TFdB?=
 =?utf-8?B?bTJzbGZFajVaRFlTMDRGeDA4YUNxQ2lSbHZQNlk4aWtwSGxoLzBqUjNyOXhT?=
 =?utf-8?B?dHZwMnpwV2NwaENndnBuRXNWQnh3MHJ6Qmt4UFZUbnBmVXNYcVl5YnJjUTR5?=
 =?utf-8?B?ckZZbVNtOE9MOFZRa0Z3MDhxTGx3dkQwVEhyVElPY0pTVytnZ2ttUXBZTkhD?=
 =?utf-8?B?cHYxbkdvWmVLbnc3UXo3YWRodkVJajUvdmc3UE5vUmVocXl3N05BNUpYZzZi?=
 =?utf-8?B?Y3JNc3E0RWJTa0VKaERkRTZxUEI4N3VpcDhOSWJDWE92QzNGTUFDcTgzQlVo?=
 =?utf-8?B?VHhKQmI2aTYxZVQxa29IQkIvNlN0WHIyZkVjdjdxdktSS3dxRDg2TEJlQ1lV?=
 =?utf-8?B?WGNEUHMxZmFDY2k1MXpjajk0YnF6eGNLZnphVWhsMEVnNlVxSnNZVHRSVTVy?=
 =?utf-8?B?ZndCZ0hYOVB3QWdJVXNqNWJLU1VCSGdzRG9xRHJVdi9zdzRTd1RKa2k1UUt5?=
 =?utf-8?B?VXNta1BaYVhzZFVBaDZRd2IyZjhoU0xQdFl3eENHcHQySVF5QXlpeUU4NnRo?=
 =?utf-8?B?WXNmTXZQTEszaVI3cUx4ME5WSk9hR0NMTnZ4MUZnOVlhT0xidWV1cWxKU01i?=
 =?utf-8?B?OFdBQjB6N3VkbFZ6ZHpxRmZLWHUzYkF4N2l2Y2xzcGJTTXFlTVhvbGFINlVT?=
 =?utf-8?B?cjlYekZVWTVDUjJVcFlzZWVLSVh3bFdvQnlhYzFWd3dabThkcVlpMkZLMFlE?=
 =?utf-8?B?QmRBS3k2MFgxVGhvT0pJVzdxTkJmcmFIU3ZMR3lBTStEVGFGR2QxWmptKzhn?=
 =?utf-8?B?bzNMRzRVN2JlaGQ2RzJuOXlnaUF5akh0NXRoQ0xGY2RvenV6cHFscVc2RXp5?=
 =?utf-8?B?cjZXdUpYWUFKY2w3N2g5SWRxVENQN0M3R2J1RGxBaHhRM2ErdDNrRzEzZk5X?=
 =?utf-8?B?bFdUbXZPK3FLMXdZZ0tiaVcvQ2I0ZmdnQkc0Ulcxd0NKenl4N3hrMm51Vm95?=
 =?utf-8?B?QUg3OUFPQ2NLRVhoZnM3cWg0UzViUCs3a2V0aENPa1RXQldac3lpNkRWUEdL?=
 =?utf-8?B?WDZnMitXWUlCaXB2aDRnc3V6Tjl5TmpOZHkyeEhQZ3NtM05KeWVKRyttVmx5?=
 =?utf-8?B?blNZT010azVwTXhsdkFXR2JEM2JMR3hOUmZXUlV4aFdrK1F3YUYycENUWmk5?=
 =?utf-8?B?Y1FoaldaSHlmbXRlWmM5cWk2a0EwUThFTVBoQUxSUWloUktWT2dmaG9SQWdI?=
 =?utf-8?Q?Fj+F/JMESZPRGAJTcgBj36Cj2ewU78bYjo37JW7?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ae099ea-f4cc-44e9-f14b-08d98fb9c9d5
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5278.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Oct 2021 08:57:16.8723
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QkavayOnebDmkT0lY1C9PlXz7ODa1pYcLcx8ixRi8RLErdIoCNBop74mBcyJ+02rkL9Lq6i7rF1W5YDjRKQg2w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5151
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 15/10/2021 09:36, Hangbin Liu wrote:
> On Fri, Oct 15, 2021 at 10:52:00AM +0800, Hangbin Liu wrote:
>>> -	mod_timer(&p->timer, now + br->multicast_membership_interval);
>>> +	if (igmpv2_mldv1)
>>> +		mod_timer(&p->timer, now + br->multicast_membership_interval);
>>
>> Hi Nikolay,
>>
>> Our engineer found that the multicast_membership_interval will not work with
>> IGMPv3. Is it intend as you said "IGMPv3/MLDv2 handling is not yet
>> implemented" ?
> 
> Ah, I saw in br_multicast_group_expired() it wait for mp->ports be freed
> before delete the mdb entry.
> 
> And in br_multicast_port_group_expired() it wait for src entry freed first.
> 
> But when mod group src timer, we use
> __grp_src_mod_timer(ent, now + br_multicast_gmi(brmctx));
> 
> instead of user configured multicast_membership_interval. I think we should
> fix it. WDYT?
> 
> Thanks
> Hangbin
> 

Hi,
I did that intentionally because of how RFC 3376 defines the GMI:
" 8.4. Group Membership Interval

   The Group Membership Interval is the amount of time that must pass
   before a multicast router decides there are no more members of a
   group or a particular source on a network.

   This value MUST be ((the Robustness Variable) times (the Query
   Interval)) plus (one Query Response Interval)."

So it is computed properly and the RFC says "MUST" be. The only thing that is not
configurable is the QRV currently, if that is added then the GMI will be automatically
correctly computed as per the RFC. I get the inconsistency though as we don't compute all
timers as the RFC mandates, I'm inclined to revert the GMI computation as it was before
and possibly fix how all timers are computed in the future as that may require more work.
In addition this could've changed user-expected behaviour when switching to v3 queries which
were supported before IGMPv3 was added, so yeah going forward looks like it'd be better to
switch to the old GMI behaviour. I'll send the patch in a minute.

Thanks,
 Nik





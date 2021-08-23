Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AFDE3F4737
	for <lists+netdev@lfdr.de>; Mon, 23 Aug 2021 11:16:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235803AbhHWJQu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Aug 2021 05:16:50 -0400
Received: from mail-mw2nam10on2043.outbound.protection.outlook.com ([40.107.94.43]:54689
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229967AbhHWJQs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Aug 2021 05:16:48 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eDFkae3Kgzgltfmf9FtG1ncAYhWBgwWsN42zJjItXdHSQqTrxfrnF0SPZhipHECWGQTZDp+XkjjSRG1K989Cfoylt8qqsH1b/SlKPpjT3FixGcg5+uuZgtOB7yTOBCS4XGx0LhzREVUmq5lWIYBVylhOgXbjoUW/5tUerS0SC9HHEWhj55n/98Fa8XvUFdT/VpiGN7RLve24jddA7ZOK7K5y7PFT94VezCWrh8g0ivKVUdnLCNNE5Us4Kqt2lGPBse2U2ZyF5BZV99ZTx5ul7MnFlgtQii5CeXqi+gY6+jYkpOgCEbcB3dgdKYpaV84PKJ7s5zRfeCwmyw3JGhnE+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5zL48a7kmtmLk6usN932oMzweoz48ciHE2mkqawibyg=;
 b=dL5CxBQYdcgb8StIaDjIt/0WgR2wfkU9Ewvw+AdtMZ2TAo/S0XWpRked35z06JGAgNt1TtydByVFryiUgD4RdpThAVzyLsMfEN8sDaUOomVrlr+lSBbCzCqHBt1znuthlx+tKPZeS3gSMwB8mjnmfHevijlP7Q/Db0k4iQWrwwxf//ZuOz2QgvcVCLrnWVoJtMlFJysQN7Gs+SB9/V/3lyK4dj1i0H1N3/1ssUWDRsnd+2U01DKeGml2m7HgzuB7PD0BHQB4m1RZNvugA7MxaZFY8qiXiBxOgwQL6C8A0Vn0XnXzWe3wy+d6WyoAq0CqnW5mOBOdJyWtjUO679YbYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5zL48a7kmtmLk6usN932oMzweoz48ciHE2mkqawibyg=;
 b=rVx9VZz6saJ8swyG4p55stwnr3Dir6PmHUU70KKMCxtYlpYcbQCewPRYXCjM1j8WtW4Spvx+2SIn6mLRG+wzJAG1tj8ELi/n7FyT9neZj98W376B1eRXFSH/NJc8BaciyPeYA6xLW8GARF2n44H3f4tgvv70dduTpdtnu+5m33ADiBxNGD0q0ztYDeI/Kf4zZ2LM1BvDF7IdYV4Ub5MG2c8VV875OpnDmB8DdBVXgjpqjOfknZF1/eflcVbeAER2ZYNl7FaHXscoPMSWOK3j32uMPNqVyQNqfHL/YDt0aGlFPrxZ1BFIMdsFse1JMVZE1/WWs1ht9z15mrV0pWvy2A==
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nvidia.com;
Received: from DM4PR12MB5278.namprd12.prod.outlook.com (2603:10b6:5:39e::17)
 by DM4PR12MB5280.namprd12.prod.outlook.com (2603:10b6:5:39d::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19; Mon, 23 Aug
 2021 09:16:05 +0000
Received: from DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::c170:83a0:720d:6287]) by DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::c170:83a0:720d:6287%6]) with mapi id 15.20.4436.024; Mon, 23 Aug 2021
 09:16:04 +0000
Subject: Re: [PATCH net-next] net: bridge: replace __vlan_hwaccel_put_tag with
 skb_vlan_push
To:     Kangmin Park <l4stpr0gr4m@gmail.com>
Cc:     Roopa Prabhu <roopa@nvidia.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bridge@lists.linux-foundation.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
References: <20210823061938.28240-1-l4stpr0gr4m@gmail.com>
 <13c1df91-be22-f4e0-cd61-7c99eb4e45f4@nvidia.com>
 <CAKW4uUyPdQ9hXeyjnC+5VS7zDaw+3sxy53HwOv2AxEZ7tngT=Q@mail.gmail.com>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
Message-ID: <5e721a04-0be5-af91-055a-caf023cf6437@nvidia.com>
Date:   Mon, 23 Aug 2021 12:15:58 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
In-Reply-To: <CAKW4uUyPdQ9hXeyjnC+5VS7zDaw+3sxy53HwOv2AxEZ7tngT=Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: ZR0P278CA0070.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:21::21) To DM4PR12MB5278.namprd12.prod.outlook.com
 (2603:10b6:5:39e::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.21.240.23] (213.179.129.39) by ZR0P278CA0070.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:21::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19 via Frontend Transport; Mon, 23 Aug 2021 09:16:03 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4ac10c2c-9d1a-40a6-e62f-08d96616a23e
X-MS-TrafficTypeDiagnostic: DM4PR12MB5280:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM4PR12MB5280F3E5B6C962A7F1538FBADFC49@DM4PR12MB5280.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +BYETkxMNOmjKUVEf0O0hfjLi/PpXlLcuz9BYxuXSZBxKIeXu5xjOL6vF+1t3FVuqI4ALbv3933IMRyDB6R2O7/g2gKdWBs/WYBxtRI9fWxxuKlhSVrADMYGsKeU8vaodlX5IvZ7uvGY07iXeY1E401ScXyyHlYvDS88xwfElnDXm4RMTcqZAy1xNQ38G42x6Nv1bWccLGAaqsM9CQXcPcf5W9qDboYIs2f8NnigXFmH28et+FYk4eEGKb3yJQhOZc4QuOHiLmMMMZfjHhmsff3QxKKetCw+1FTA8kFWK1cOGIcD90C5fSjjKNZAnOpM6Li6gNafsrWwy5XERmboBy15WP4rbkUyo/DJg59DNbkKyScJt3axg1wWhHEslNvCNAi03BBNRzJURYYtHj9LJ8llX40KKg0QcBfbo+QqpPfLxmkhLy/1C3+w+MWQFRsyb0LYiGcSEXLAZB/YBMjLJSMFSm31djy7oWLq42zUT6zKukhsFoUNzGRqRDnKbUHgWT0BNBdLzyKJQZEsjjq47CMVQTZ0vhDj0XtAUYYNio2hRwGbavX50yiPaG9Yuea5Q+JAJwiliYRcc6F+IXrA1rkbGPLa92Y4NKUCzcw3/3GN4bh3TcjrdVv+6Bicg6DwOx6NWsHMRzilB/LAvfv6T9+re+VUJCZd5MOZjt3RT94wnTuez+f9Vp7OYXSXFrHRey3XHEcPdAt/6tnfhRF/R1pYClHKuwRq2nfNzoMFpxA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5278.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(39860400002)(136003)(396003)(346002)(366004)(26005)(186003)(478600001)(66556008)(956004)(2616005)(6916009)(16576012)(316002)(66476007)(66946007)(6666004)(31686004)(54906003)(4326008)(2906002)(5660300002)(8676002)(31696002)(38100700002)(53546011)(6486002)(8936002)(83380400001)(36756003)(86362001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TDFIL3dnSVdyNEk5L0RvdVRSUU1WK2hRUmpyeEU5WW1OVnpIMUxicXdzQ1oy?=
 =?utf-8?B?cHdTajN6d1k3K3VKM3ZYZ3RlbmxOenRtUkVCWWZTeHJKcEFnbEtSaGFsTFl2?=
 =?utf-8?B?cjZkTmVncS9rZXBlcndRcVFIZ09MbUpVK0pHN1A5TElpbUVNeHlrZHZTMytB?=
 =?utf-8?B?MVZZV2xmNVJITHFTSHBMTmg3UEhDSEJ1c1lWUmw5dW9VYnNBbTQwWDI0WTVB?=
 =?utf-8?B?MmhldzJVNXJrMUd4NituRE53WHVOZGFrcUozRHJQL2NKenluVUVUSDN5S0pt?=
 =?utf-8?B?aVcwSDhrQldBcVFEbHYvTmRtamIzcnpGR2gvTVc2aHV3NnhVbWEySmtDYVYr?=
 =?utf-8?B?elI5a3J2UlZRbUZEb0VVd08zQWYvQk8vQldmQzJZaW5lM0FpWFZpSzhzWVFz?=
 =?utf-8?B?aW9FKzhqYktYdTQvU210d2pWbHdYT0FnaHZYeHUvRTZwdlBlTk94U0NDRHdB?=
 =?utf-8?B?QmN4LzhLa2Z3Nk1pSklPaTRPTENaMHBDTnE2aVdiRStmbUxRTjhHSjV6Kzlm?=
 =?utf-8?B?d05jVXVEWnFPNmVnOHJueG5wRlFrSklJdW85YnZmbmhXZGlkUExTRC9Hbmhw?=
 =?utf-8?B?SHJYTzJRMHRrM1RjSnZBenFuOWdyNk1yZUVySHNabnhIRWl0T1hlUFphcUxN?=
 =?utf-8?B?WGMwUS9oNS82RWRaSVlsYnRmY3BtZ1I3QVpWR3ZLRUdNZTZCd3AvK3Y4RXd4?=
 =?utf-8?B?Q0oySk1SeWMrSkpRYVdQSTc2Zyt1OWN5RStHWGlsTXhES2p1YVV4d3k0SHlW?=
 =?utf-8?B?cWhOQ3ZzZWM5YTBTZUl3MU8wSlJLR1V6K2xlQXppOVVqQVl4eFM4RGg4T2Fw?=
 =?utf-8?B?OVByNDdlcFBiaW9DZUlSSTFodHhGTW5XNUdpa2R1NkJXV29NYjRtdUdUb3hE?=
 =?utf-8?B?cWFTemNGR3BROEx6NHlIdm81QytBZEdKRjZ6dS9sVWlxMkhWU1dqMTZoUGwv?=
 =?utf-8?B?VFdLQ2JLbzM0QWJrcXI5QTQvVXM3dHNkaUJKV21PS0thck1wOGkwdnlTbG94?=
 =?utf-8?B?Z2VtejRDTGhaaWlyaFBpZGxJM2s1K3BHUy9YWlEwWWR3dDUyOVRJenc1aWQv?=
 =?utf-8?B?ekVORWhXWkUrd29KMm5FUFRMaFlNYk13WjBNeHoydG5BL0VMdFFhUWROdnJK?=
 =?utf-8?B?K3ROdFBzblhaTkJHbUd0MkRKYVRkUFJaSnVjWTFIV3VmT1EvMDVjSXF0bWts?=
 =?utf-8?B?ZzBQeUpzVVVvbnRZYmFPQkVKZWlqaU00RXhObW9JR1NMUTl6Wk5pY01uK1Z6?=
 =?utf-8?B?bUlRVEhXOStwUzR5ZnRFeHJjZDRhemNqdzdTa2M5S3BvbFBvOWNmMW12MHor?=
 =?utf-8?B?UmQ3OHBoTEN0NGtDTnVwNFZ1aFA0NEFJSFR6MFdWMm9oY0c3L3ZQQmhESmQ0?=
 =?utf-8?B?TzJNNDhVR0pvN05GUVZsU1JRZ0NnYXNWVVZVamdlRVlGL0R4czI2OU1Zdm1x?=
 =?utf-8?B?NE9yU3FSMGM1b0ZmOFU3bGNLYWp5eXRtYi9iZWs5L3dLS0dQWFZLMUI4OU5u?=
 =?utf-8?B?UWM0S0FpZnF3aW1LWEh3RjF3dTB2OU9GNVNIN1FaTHZqTGpacHBTZzd4bFhM?=
 =?utf-8?B?Wm1lVWlQVlhDcEVZeitEak9aU2Z1RmN5THVZeFEzMkNzbzU1OFN4ZVBtNEll?=
 =?utf-8?B?MWQxMGJsU01Gb2ZYcVpSYVd5MW1KaDlVazFJL0tjMXpOUUd1R0ttMTg3WFZN?=
 =?utf-8?B?U2luSzdHNEx2TTFnZEtqUnRBMTRzelRzQUNkNmtSWWs3ZVp5ODNaOXkxN3FX?=
 =?utf-8?Q?ZyvmAfcyCtzL5Epo7nW55MVF5kbgzrmHAJ+W+9S?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ac10c2c-9d1a-40a6-e62f-08d96616a23e
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5278.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Aug 2021 09:16:04.8374
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VXHCXLjC5ZhzT+52whk1TEoyOO37R+LegAYfunAcjIT07BDUVnN4WApWEIclWJ19k5VXLOaIpB2BFrvrnlECwQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5280
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 23/08/2021 12:12, Kangmin Park wrote:
> 2021년 8월 23일 (월) 오후 6:00, Nikolay Aleksandrov <nikolay@nvidia.com>님이 작성:
>>
>> On 23/08/2021 09:19, Kangmin Park wrote:
>>
>> This changes behaviour though, I don't like changing code just for the sake of it.
>> Perhaps the author had a reason to use hwaccel_put_tag instead. Before we would
>> just put hwaccel tag, now if there already is hwaccel tag we'll push it inside
>> the skb and then push the new tag in hwaccel. In fact I think you can even trigger
>> the warning inside skb_vlan_push, so:
>>
>> Nacked-by: Nikolay Aleksandrov <nikolay@nvidia.com>
>>
>>
> 
> Thanks for the review. I got it.
> Then, how about cleanup by changing return type of
> br_handle_ingress_vlan_tunnel()?
> This function is only referenced in br_handle_frame(), and goto drop
> when it return
> non-zero. But, the ingress function always return 0, there is no
> meaning for now.
> If you think the cleanup is worth it, I'll send you a v2 patch.
> 
> Regards.
> 

Sure, I don't mind that cleanup.

Cheers,
 Nik


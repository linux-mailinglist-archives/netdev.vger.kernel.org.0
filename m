Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B3C1672A78
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 22:28:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229651AbjARV17 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 16:27:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231164AbjARV1m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 16:27:42 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2053.outbound.protection.outlook.com [40.107.223.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EE073D920
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 13:27:35 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kYeVySH7aWHT7oyNuaqxN7sTWW/i6zaEGuZuPCdH7L9zB64ybg4hHYPfdhhck/9lHVFZkvM/gjnB4J0k2mocTEUFwyMzJFhUZ6NLKGTJQmQybqqL11JtwfnejvNwHF7azslMGY8Txl9RosJ5GrOmIaI4YasHBq9ipAQWKtvwJfIWiVwf/wS/a6TEySOgk1pchs3c4R8c9kgLM5aaRa6H2nPU45kVjJ9KkIGk1UFj3Qpnr1vQIElgSRIeCYYLafY1f9TRCW+YfbdMYAc7yD4QQc91RnvUoW6rK4NMbKKksdBE7d31IC42/DOg/f5oOQFoMYnkL6MB+7ltU1s4OoBUTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1pP/zIbMgJhCVscO6qJ8aaD1GFKLrb1CV25TfAYuQAU=;
 b=JmBIUURP00W1zj5w7LzpbKHCz0F5Q0hEcWFawu27WD3432ePStGWMHFZFGyqNhQVEUnF0uzEUlBsOC2lnBTCzG490xiyano64K+NrewOd9GiS1QcrMS9lYH+7vpz9KSPxWYbbi3JHIBEZDxKmSpXOUnUZ1Ke92P4k2snRC+OeaEClSCfHjqcDgP50NuDdymbqOjhzGvqeZ9Ev4bYMALJAGs64aUGbaGorUcymvGX1VNBG6qQ7igpddzp1bMpjOJCECBytY0rGODTTzX6qdug4DTxjD1FOW5Zndchuik2BI8/22Xqzj67+aoIy/gTR9ijrREZEySzbq7pUdt622uHbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1pP/zIbMgJhCVscO6qJ8aaD1GFKLrb1CV25TfAYuQAU=;
 b=tMEIxu4Jmm2kXMJA9aghObv8hQGJrfZw7bA4vGzjrm3Gh6Mm+t0Z6dXXSrwWcGoTAQ3r+JjnONhSxhgJurlqKXCHVFMWKIoL60ma7gOVVVWm+X4KThcixTCsVK3mIEtGm/lWcT6XvbbvpaLpOvJHMzRdcELR4w1s8n1/ySVX0q5n5n5TeupiS6Jo2Gz9t3ElhUzUKOXFzFk6/ZfxGjxoIC0tWMGpnN6oNo3VaBtYKF6mJrKkYnkbc2rlll42JSTFSnjW5LykqDtjCv2UPw6W+K7Cg1OTkGn6kiwxfae0yoINKJROxl8WHv1DZuyDMdVE/GSHfn4DIGarA7euuh/yrA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from PH0PR12MB5629.namprd12.prod.outlook.com (2603:10b6:510:141::10)
 by DS7PR12MB5720.namprd12.prod.outlook.com (2603:10b6:8:73::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.23; Wed, 18 Jan
 2023 21:27:32 +0000
Received: from PH0PR12MB5629.namprd12.prod.outlook.com
 ([fe80::5e6:6b81:fa63:c367]) by PH0PR12MB5629.namprd12.prod.outlook.com
 ([fe80::5e6:6b81:fa63:c367%9]) with mapi id 15.20.6002.013; Wed, 18 Jan 2023
 21:27:32 +0000
Message-ID: <d7404d79-1d3b-9392-7911-1851f1c37cbf@nvidia.com>
Date:   Wed, 18 Jan 2023 23:27:21 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH net-next 0/4] net/sched: cls_api: Support hardware miss to
 tc action
Content-Language: en-US
To:     Jamal Hadi Salim <jhs@mojatatu.com>
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Oz Shlomo <ozsh@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Vlad Buslov <vladbu@nvidia.com>
References: <20230112105905.1738-1-paulb@nvidia.com>
 <CAM0EoMm046Ur8o6g3FwMCKB-_p246rpqfDYgWnRsuXHBhruDpg@mail.gmail.com>
 <164ea640-d6d4-d8bd-c7d9-02350e382691@nvidia.com>
 <CAM0EoM=FaRBWqxPv=jZdV_SZxqw26_yhK__q=o-9vqypSdMV1w@mail.gmail.com>
 <8f9ca91e-1f3f-c3c1-cbab-4f9af3884b43@nvidia.com>
 <CAM0EoMm-YVTKWwTEEACjEuyh8C+tWiEWFurPB=F2JUT72nZp4A@mail.gmail.com>
From:   Paul Blakey <paulb@nvidia.com>
In-Reply-To: <CAM0EoMm-YVTKWwTEEACjEuyh8C+tWiEWFurPB=F2JUT72nZp4A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR2P281CA0004.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a::14) To PH0PR12MB5629.namprd12.prod.outlook.com
 (2603:10b6:510:141::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR12MB5629:EE_|DS7PR12MB5720:EE_
X-MS-Office365-Filtering-Correlation-Id: 1a52cdb7-0c13-49ba-2443-08daf99acf1e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: o2KWY1Nd6p+bMu6HGWvuYNwEVF17zMybgLEabIUo0Yijr1To8dUtUaH3JyCFMjvOEUNBes52OZbUMA61zqdcJWQR41uRMw2RZ4fen5zroSYIj1K0hskRqvvAu3K1zn9+nabLuaW6W6kvC2wG+DDxeVgYyTRKSi0lveuXEvcJzKtf1I/LKzC/V/OT0E9r9CO3MnsEU87S+T47jCtSbM9Lh5B+V1N9rQ5CFAVBacBmAIT2zf1Wb6bwlPQluA+f17ZOC0dC6OOQ4QvctOyOdgSqy5XsWpm9X+UaiLPeJ3utdNBYVLfvCixGRcR4HJ0G9wlD2e8lZKiP4K39afvpp21F+LbQeB84xkYKvg7rdtKi1FN7/RsXy/qoOjrTVUNDl35TNb4IO4Hf2edqnkV2rNZRb2/wvwI0YnCYfIP+mjYcfls+ng3yFFEnlV7viBvalxZZ+9++xjQx0wbqg1IGjnhw52TmQ6IeFe59e09KUa529iLy/ZxuhLJsAVs5SAkKjkLlSCqhEmc5HmbKTHbQ4MT6YXSEBF8hotCbnboY/j48w81mqXfQqgkczmfZssdCGs79X3GRtprPBUXlV14OQ09faT0rlKoalCzXmo5vZdafBsvEhKp37WHe9HltkL1lb+Qy9TwLaS29YO7OGxbo72w8/V7ro53pld3kzU3tCOCBIpQKBWTBj+XsQnBeS/qMggVjhL2hP/Xy4idocvhS9IHAFnMksXmOsGy/8bKdx0GHpvA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB5629.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(366004)(346002)(39860400002)(396003)(136003)(451199015)(86362001)(31696002)(8676002)(66476007)(5660300002)(53546011)(4326008)(26005)(66946007)(6916009)(6512007)(66556008)(186003)(2616005)(41300700001)(83380400001)(478600001)(38100700002)(2906002)(6666004)(6506007)(107886003)(54906003)(6486002)(316002)(8936002)(36756003)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OVQ5V1VXdlpXN1FsZi82bGQ4blgyRWpNeFArcUFsUXdRVmdMN3I2aWpsTXlX?=
 =?utf-8?B?SFRuQjB5Qm5PU2VwSU1JUFZwc0JlMEtaRU5PNWxRcGoyRjRPaE5NcThHNTdu?=
 =?utf-8?B?emZ4VUI3b21JaWMrRHBIMDNqYlFkSEcvUXZ6WGxHWTFabEMzMmZKL0dseDFP?=
 =?utf-8?B?SVZuMysrTkpOMlBsTUIrcUo1cEcvRmFEckxpcmlNbmpNeUJaWXJyVFVqNjl5?=
 =?utf-8?B?VlQ0Zy91RGNWNEZjZ3NyNy9xUXFsT1Q1am4rOE1LbHNzdUUreHoxRVY3VXBP?=
 =?utf-8?B?dnRab1lBQnV6RHEySWlaaEdXN0ZtbFpMWVFqZVBISTNsVHdYTlhGaGxOelFy?=
 =?utf-8?B?ZzVSdTFqcmJINHl3TnpDcmZDdXhmUnFFRUpYTUhvZTR2ZENDZEZZK2M1VldP?=
 =?utf-8?B?Vm1WOXgrRFVab1ZQVkc5ZDdMeDVOWE9SUy9aOW8zMXRrOFNXY2pTL2JTc25i?=
 =?utf-8?B?RittWDBXdnc2QjFQV2IvSW5odFBFTEFoYmJ5WG5WVzZKVER6QUNUR0R3LzBM?=
 =?utf-8?B?UjBCWTBPT2dGL0x6QUNCb2h5eTdoL3dKL24rNmNlUEJ3cFZIbmN6QTJDZUMw?=
 =?utf-8?B?dUMydlVhTzE4SUxxQkFJNG40dlY2NGVTNXFRaVd1ZGxacElzcEl2VHlSOUsx?=
 =?utf-8?B?MGg2LzVzRktFb1ZrdldLWmNtV2d0RlVRNjUzUXo2UXdpU0tHMm95QkVUcnhY?=
 =?utf-8?B?NnJXR2JNazlvR2ppa2IvVFdEdTFJOFpZcGFXVGJNamRhYm9naGpMNGVNN0N4?=
 =?utf-8?B?Rk9Ga3JXN1pHZ3NhNWtBN1dSeVR2aFZlQ1pEN0k2ZFFqWUdwdXMzSWoxamxr?=
 =?utf-8?B?NzlpNTJhTC9QT29RUk5OOUpUNTlDbWYvaGlpd1dsRWRlaUtsWngxaEhBRDZh?=
 =?utf-8?B?S3FDVWxjTyttVFpUdzJ3b2tUaWFPdWh1UTh1QkNCazg2Z00ya2xDV1RFYWY2?=
 =?utf-8?B?bzR6eFg5ZklzTld4SExHcm5VMjg3RGZWazhGU3BLQmZ2Z1Z6ZjZLbGppZ0Vv?=
 =?utf-8?B?V3dFWUIvbW1jZm0vRTVKeis5TndmWWdqU0EyMmEyYTQ3ZFVKK3dnbHNmdDE1?=
 =?utf-8?B?NGg0U0ZmajFrMVNNNWZ4RlI4WHpCZmJSVTREREFiOXB1bVBLcVB1aXMxeWdN?=
 =?utf-8?B?UnpTOTVJWTUxM2hHaHA1ak1xR1JwTWNuKzBsM2RuNk9FMStEblNtc1FOS0tx?=
 =?utf-8?B?VnVXWW9nYzBNVHhwelpteVVreVcwdExvaTFrRldqLzJmajF6V3l4aTluTHIz?=
 =?utf-8?B?MW1qYXUxOHdZUWVPU0orSStFK3hmNktYbkVmWitEYW05OEpBbFBsVkZmTmlC?=
 =?utf-8?B?NitISXNVSDcyK01XdnBFMTY4SU9xajFrbEFBWkt2VHcwcFp1VVdxUXQwU2Er?=
 =?utf-8?B?b2MxaUNpa2J6Q3VKQkpNY2hHS3NTcyswaXFtdHNRbyt5N3VVUnZUSEJKKytM?=
 =?utf-8?B?cW1RaDZGbEp0TVJYUmpYc3NUYWNaSXhOUTNENDJ2VUNtWHV0RVc2dXVwNHNB?=
 =?utf-8?B?N2o3R3ZJQzYrRk81RVRFTTZPdXhyU0t6NWVNMENXNC9tV1d3VWUzUWJCNG1P?=
 =?utf-8?B?ZnlUVHFEenRkdDNIVmJMSllsSUtQSTlkKzZSTlhQVkw0WHNTc1ZjOHQ0SVRC?=
 =?utf-8?B?elBucXI3Z1l4NzVKVjJ5clNSQ2I5TDJRZkd4NGphZFdjU0JnUXpRd3hjS1Vu?=
 =?utf-8?B?RjdLZHB6VmpQaW12S2JuSVAvQmRWSElRVEdpUnVVNTVPTEpOWVhPbklnUFlw?=
 =?utf-8?B?YnF4YXR6QVZyZDNiQm1qK2tUMEhrMHdIOTBPdFUyaWtFSHl3VU5yU01Edktk?=
 =?utf-8?B?NzhCbDhhdlNLaWV5Y0kzQnVpT2Z0ZmJiSjZVbEZjMmZ6S0JmUGdnWmFRMitS?=
 =?utf-8?B?Tm5EQ0pCbm40QmUvMmlBQWMvdW1BTU9MUWNZY2E5TUYzZDdVdHBGYkdMYysw?=
 =?utf-8?B?bDFodW5LM3hCZjdWU2hDSVlnMEoydHNxMS9Ic29IazRKZGZVUEhCOEtoenVS?=
 =?utf-8?B?TVV3L280eXIzaExSMFdTQ2xmYlZXWjJYQ200YkZJSEdCVUdlWWNNQ1ZSSmRr?=
 =?utf-8?B?OXBEemxuNFhmRUM5QjVoSVRQbUs1YUZyb1hBYWNaYVRlYXoxVTRCY0VPUVRI?=
 =?utf-8?Q?sZfcfU5nIIXV7yjw2uftJrNNS?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1a52cdb7-0c13-49ba-2443-08daf99acf1e
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB5629.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jan 2023 21:27:32.4778
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xBp40drOW4DTXXqzWc3dKEV391lR4KZaeVPKFRzNmknfyQEPYLGrsgAKmQvElTgMPeGinxkAXKq3fu7YvNpmRQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5720
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 18/01/2023 14:54, Jamal Hadi Salim wrote:
> On Tue, Jan 17, 2023 at 9:48 AM Paul Blakey <paulb@nvidia.com> wrote:
>>
>> On 17/01/2023 15:40, Jamal Hadi Salim wrote:
> 
> [..]
> 
>>> Question: How does someone adding these rules tell whether some of
>>> the actions are offloaded and some are not? If i am debugging this because
>>> something was wrong I would like to know.
>>
>> Currently by looking at the per action hw stats, and if they are
>> advancing. This is the same now with filters and the CT action for
>> new connections (driver reports offload, but it means that only for
>> established connections).
> 
> I think that may be sufficient given we use the same technique for
> filter offload.
> Can you maybe post an example of such a working example in your commit message
> with stats?
> You showed a candidate scenario that could be sorted but not a running example.
> 

Sure Ill give it as full example in v3.

>>> It will be an action continue for a scenario where (on ingress) you have
>>> action A from A,B,C being offloaded and B,C is in s/w - the fw filter
>>> will have the
>>> B,C and flower can have A offloaded.
>>> Yes, someone/thing programming these will have to know that only A can
>>> be offloaded
>>> in that graph.
>>
>> I meant using continue to go to next tc priority "as in "action A action
>> continue" but I'm not sure about the actual details of fully supporting
>> this as its not the purpose of this patch, but maybe will lead there.
> 
> Yeah, that was initially confusing when i read the commit log. It sounded
> like action continue == action pipe (because it continues to the next action
> in the action graph).
> Maybe fix the commit to be clearer.

I don't think I mentioned it in the cover letter/commits, or did I miss 
it ?

> 
>>> Ok, so would this work for the scenario I described above? i.e A,B, C where
>>> A is offloaded but not B, C?
>>
>> You mean the reorder? we reorder the CT action first if all other
>> actions are supported, so we do all or nothing.
> 
> Let me give a longer explanation.
> The key i believe is understanding the action dependency. In my mind
> there are 3 levels of
> complexity for assumed ordering of actions A, B, C:
> 
> 1) The simplest thing is to assume all-or-nothing (which is what we
> have done so far in tc);
> IOW if not all of A, B, C can be offloaded then we dont offload. >
> 2) next level of complexity is assuming that A MUST occur before B
> which MUST occur before C.
> Therefore on ingress you can offload part of that graph depending on
> your hardware capability.
> Example: On ingress A, B offloaded and then "continue" to C in s/w if
> your hardware supports
> only offloading A and B but not C. You do the reverse of that graph
> for egress offload.

This is actually the case we want support in this patchset.
Assuming a tc filter has action A , action CT, action B.
If hardware finds that it can't do CT action in hardware (for example 
for a new connection), but we already did action A, we want to continue
executing to "action CT, action B" in sw.

We can use it for partial offload of the action list, but for now it 
will be used for supporting tuple rewrite action followed by action ct 
such as in the example in the cover letter.

> 
> 3) And your case is even more complex because you have a lot more
> knowledge that infact
> there is no action dependency and you can offload something in the
> middle like B.
> So i believe you are solving a harder problem than #2 which is what
> was referring to in
> my earlier email.
> 


This is something we currently do but is "transparent" to the user.
If we have action A, action CT, action B, where A/B != CT and A doesn't 
affect CT result (no dependency), we reorder it internally as action CT, 
action A, action B. Then if we can't do CT in hardware, we didn't do A, 
and can continue in sw to re-execute the filter and actions.

If there is no action dependency then let driver take care of the 
details as we currently do we mlx5.


> The way these things are typically solved is to have a "dependency"
> graph that can be
> programmed depending on h/w offload capability and then you can make a decision
> whether (even in s/w) to allow A,B,C vs C,A,B for example.
> 
> Note: I am not asking for the change - but would be nice to have and I
> think over time
> generalize. I am not sure how other vendors would implement this today.
> 
> Note: if i have something smart in user space - which is what i was
> referring to earlier
> (with mention of skbmark) I can achieve these goals without any kernel
> code changes
> but like i said i understand the operational simplicity by putting
> things in the kernel.

Yeah that would work.


Thanks for the comments,
Paul.

>  > cheers,
> jamal

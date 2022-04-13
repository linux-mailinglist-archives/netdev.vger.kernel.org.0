Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D61B94FF4FB
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 12:41:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234430AbiDMKnN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 06:43:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235205AbiDMKnI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 06:43:08 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2069.outbound.protection.outlook.com [40.107.220.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 127C458822;
        Wed, 13 Apr 2022 03:40:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QxMu8oMHgk0ga1gpin2NuaRCfA+80Xjq2Gtp/eaPTBR0bZRRbwAjkYoOXasrkTkQGINAVgzC1hVu3/kA0i8mvATu2An7yw+HjJP/KuqkNG7zGhErmk4FPiaklwWs4ks+IPy2uUs3tJQsHdshWWo+Nbhvdf/xJUDLlnCXIcdiT5NBI4rG7Z4sTEarVDW+AzSKuk3tBlOSZgefainxLi1yvAZEs7BHna6fC9ZF4sQ+cx7zUiot8zxQEZpxQQf9fEovPqOVXOGV8upmFagVYSAulNiTjRKYKMK6D8ctocivPfSgD/FFSD9FcAyjHrhsdDa/81Aoo2niQ0dg5iQ6ATnKSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0aOd2hKsI8aNPVwAjaUeUSs9Re3oL0BclJayVcaWljU=;
 b=jvnHXUhhBC4i8FEqI2MKmZmiMY8syXuFyPY4L6yaz09NkglAjkDyh7bFnEr4NTdgwLSDQYThzqIFZxsW6v7hlbeE2YXOiwihJxFEYR6xgAy1L6fTU1lRvd+d91VFcstBR9pGxAYugbWpmp9Gss2/mWQh0vKgcdsB850r834CQ+FoAGajO9aCgfQLZ5KJhJyK4yzBmXtIyrp6vEb69JANswTgkAHgtV9u99xDk+OFa9alMDyZThB9pnWW1wJIs1l9Pd090MDTHCoBHnnW7TuuM5lHkvDqASBTUeuXvIomufKMR1PQozRxcr2zwawpesGSAM/IsGdoBlmS1PFbCr3LVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0aOd2hKsI8aNPVwAjaUeUSs9Re3oL0BclJayVcaWljU=;
 b=SsIBk2qvG+RYGRApIyaTCuM9R0TSBczLmw7W7otjnOMJXUSdwvZaiwvYLEHpHXwzBWtDurT2AwJMeOL/xCBgaZWsM+9EKlcLGE2P0jkN9ZbbhZjovAxoE3ZjDw7N4KBUYErocxc9xZNvs5mNMz0aNG0OFGZQT5sXwod7H8sKx8vdNbm+dQ1Zc/wgrp5bQy50mLH3fEPFxYXunGlsv57NyolILHwCLkAUo0V+um51aremJT04MJ3ZLNDM5jvtEmR5d1nA+RFSIwafmU34/CFeqLE4Jc9v+whgGJX2fn7xrqRZcJ7NdS/5Q5w31pHaYWjg9e+jE9YXvu663EgvxSxzKw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM4PR12MB5150.namprd12.prod.outlook.com (2603:10b6:5:391::23)
 by MN2PR12MB4991.namprd12.prod.outlook.com (2603:10b6:208:a4::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.29; Wed, 13 Apr
 2022 10:40:45 +0000
Received: from DM4PR12MB5150.namprd12.prod.outlook.com
 ([fe80::a186:70f2:4280:14df]) by DM4PR12MB5150.namprd12.prod.outlook.com
 ([fe80::a186:70f2:4280:14df%7]) with mapi id 15.20.5144.029; Wed, 13 Apr 2022
 10:40:45 +0000
Message-ID: <5864171b-1e08-1b51-026e-5f09b8945076@nvidia.com>
Date:   Wed, 13 Apr 2022 13:40:33 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH bpf-next 00/10] xsk: stop softirq processing on full XSK
 Rx queue
Content-Language: en-US
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        magnus.karlsson@intel.com, bjorn@kernel.org,
        netdev@vger.kernel.org, brouer@redhat.com,
        alexandr.lobakin@intel.com, Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
References: <20220405110631.404427-1-maciej.fijalkowski@intel.com>
 <8a81791e-342e-be8b-fc96-312f30b44be6@nvidia.com> <Yk/7mkNi52hLKyr6@boxer>
 <82a1e9c1-6039-7ead-e663-2b0298f31ada@nvidia.com> <YlRKxh0xKDfOHvgn@boxer>
From:   Maxim Mikityanskiy <maximmi@nvidia.com>
In-Reply-To: <YlRKxh0xKDfOHvgn@boxer>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO2P265CA0093.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:8::33) To DM4PR12MB5150.namprd12.prod.outlook.com
 (2603:10b6:5:391::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e2a4c7bd-45a9-4803-9d22-08da1d3a1097
X-MS-TrafficTypeDiagnostic: MN2PR12MB4991:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB49915550ADC4D086838BB1A5DCEC9@MN2PR12MB4991.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Xd89dmNqYsPbIjhC2FHFJupPLxYryK4MpSFa7pYfbusFghXXrhESQ2A8M3E6yQ0EV7XPKOJUjiviQD4urslBrpS0IecPo4HNlywRwdTE+D5T0zaBNFJQJFwQ1FXdKjrnf9wf01zZJyHmm7Z2oHNY4IRiDc+aTxzlNnGCiL5sOKvl60ATFcF0tb8RIPE0uPOc08UjyX2OFRBpFlaz9fusDoy/qJIsTzgLnlzcXkuJOMgwufgO7p+MaJJZ9cwUBwMDkga7IlYrLWRM40BWepjlDFT1486eNZtiFO8kMYDZPnTgyzC42osUp6Jw6G9Ky8gWlYLfqzwUX57P0+cbIjHPCrcSqKMf7+kBoyZrPZJbPshD3WafGQVxEY1Xh4frO4HVDLRryLt+4I/yj3xLjIHLvaduiBA1g3+FxByBA+3+Xf3n2LdQ8isTOH2kH+i6hWXwSRKGZdMIyMR5BVftSbdcAluryKOBnayvMkqjzNACdK4vq/Y/urdS1+nVRsgxBR03wcEQ/4R26CCd73dhnrKShSHcQjl6IxEwUFU/qfAhyYlRw6heRgCDHl4z85oSUEgUxeOwfP7XaK2YmIYH8DSmXBzSMJtXhmnxNs7ZxqTnk4JAh22QA5ziWNyh5YCQUcwKWCvsfxmUUwZIXYFOq/YfQcn1A2NAgphjH+MGjiuGyPCseML1vaDXoqNfrWwOrYhDNDO5CmQW4IgMy9lteD5tR8/l2rHvMs4FZsTtTsXhP5D3XSRZbkyTf7eaGdb9egu6RLEctFaSISEVA4RcFaQ9ibTa/W7VxIYTjrpblUHYPOTyzjbd7OEwLnPlr3KYerZ0KtTmxxac5BJ6g7icnN+Zcw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5150.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(186003)(6506007)(5660300002)(26005)(316002)(107886003)(83380400001)(53546011)(38100700002)(2616005)(4326008)(6486002)(8936002)(31686004)(86362001)(8676002)(66556008)(6512007)(66574015)(6666004)(508600001)(66476007)(66946007)(30864003)(2906002)(54906003)(36756003)(31696002)(6916009)(966005)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dnN3TVlJRy9KMTcwRGR3Nlo2ZXZzL2lxT0k0a2p4SXYvYlFkMnpPN0YzWjRp?=
 =?utf-8?B?MUFwazIvY2hlV1dnM2ZpUGFPUXc5MUxjcmdVcU9BY1JNNitkdk5DL1lxQ1d5?=
 =?utf-8?B?bnFqR2xDbEJvRDVjRlBpdzI1VFpKY1VzbFpJdDJxZTdGMnRxaFZGOVYzc2V2?=
 =?utf-8?B?Q01zakpsQ081ZWdtam5XajdYUXlJTUsrQ0VWMFdmMzBQTEh4RXNZQjFMUjk4?=
 =?utf-8?B?elNiWjlhRUhFaURiZjBILzRyWU9IVndFa0Fadk9HMjU2T0pYMVVJRVhJajF3?=
 =?utf-8?B?TkMrZlYrcmZKZXVtSE13YStqUXRTMDRYRjd6S3E2Y1d5NmhhZlQwYXl4Ni9z?=
 =?utf-8?B?Z0xtMXpYQ1RvZG80RXlBSjAxRHFtUWxZS1g3V1JZOHRHTnE5WlczblRyTmRG?=
 =?utf-8?B?bWRnV244azl3WVZkK3QxU05idStVejQ1NXMralpUNEdjcG85MVI4bWV0MEMw?=
 =?utf-8?B?ek50QWJNbVZuMEticUlXclhVM2NaMUo0azlDMjgvV08xNXppKzRCWGlHZHVz?=
 =?utf-8?B?dGNhUndDd3VYZzZIQ2hFMkNCMDhJZWlvK3MrK2RTTk4rTm9YcGlicEw0Vkpm?=
 =?utf-8?B?WHZld1VWMVdkdm1QVk93YkRuVU5lam9tcjYybEptTk5YZDBRNDF4Ri9jNDZB?=
 =?utf-8?B?d1RLREk1RC9JM0tad3ZrcUIrNXVLQTNsMFlCVHhSakxrNUpVbnFpZ1E2MThH?=
 =?utf-8?B?Qm96K3pvR3M4cmYvUlZNTTVSRUlJRXdDUzRUWmVlZ3hWMU5BRzR3NU5TdVB4?=
 =?utf-8?B?RUt0MENzeGRWVGM1WThxOVVIK1pFRG9odlBQUDFZTldlTjd3YjRNT3NrN3pP?=
 =?utf-8?B?MzVCWE4xemtWSHdjTU0wdnJoeS9WUWNlWElOcEF3VHNFQUhIWlJEaEpSVjY1?=
 =?utf-8?B?c3k0UFdySVVRSXNpMWVIejhaMFpGTkh5dWVNbVliR0xLMXp4UXRqcWlWV25J?=
 =?utf-8?B?Ynp5ck9tUHVDYStMaDB3dytYY0hTN29xUFB3cFZZUm9IM0dwWkNRS2s5M3lY?=
 =?utf-8?B?Ni9lUFpKTnN4b3V2aEx4d0hZOGJtVjBXVTlKMVhyT1liZXZ3Sm9KTDZBaDZ5?=
 =?utf-8?B?QldBY0V4T3FNNUo1aTBLR3hCM3FKbSthb1dWblhCdHhDR2xMNmlmNlZMNVZE?=
 =?utf-8?B?K0ZpYVkxb1pGVGtxYnJJZXJDT2RkbHNwYnFhUldBdFFqQmx6eExscHdReTBM?=
 =?utf-8?B?RnVydkF3bDVXaFB3N0FVTmxNc1hTTGtoa1ZPVTBmODlNcEVXbmJqTkNiekRS?=
 =?utf-8?B?d2RIM1lza1JPaHdDc2NYWHFXOXFta0x3R09lS1luZmN6a1lOUU5HVXp4dFhY?=
 =?utf-8?B?TDZma3dVSnNFRGtLL3Z2VEUvVUIwWUFCcWR4YitVS1BzRzZHUDg2Mmt5azFG?=
 =?utf-8?B?R2h6ZFN6blROZFhSWUNDVVhEbEtRWXo4SXgwZnIyeHJEd3B1TzR6SzJYMUNm?=
 =?utf-8?B?WXRFQ3R3cmZEMWE5eVkzZDhPZFM0NzZ1Q3JGbHJlNE4zbmM3SXpBQjlRZDhk?=
 =?utf-8?B?Uk14Q2lqcTBDMExENmltTlo1alRlbEhFT2dFUFlha0ptcm9kUHp3eEQ1Z1h4?=
 =?utf-8?B?ZGpBWnExeSszQ2Ricms3aUFLTVhWbjk2T25TekdFcjZYQmtDcFMvbHY0Wm1V?=
 =?utf-8?B?WEtQQXd2UmNCekFjUjZDRkd4VmV6eXR6UmZwcW5JZzV3K0ZickRQaGVzZ2VM?=
 =?utf-8?B?M0swdEdzYlVJQWlTZ0k3VXNTVTllTWUvZVBkN0Mwcm8rSnkyWFVSMXJrRldL?=
 =?utf-8?B?MHpINjlGWEpxVGVoSllBWGExV1cxMVYrWlFQclNieTVKb0xTOC9VRTZTMjBF?=
 =?utf-8?B?VHhYVFg4SW9NZE95a1Q4TWM0eHZFYndzWmhwZko4OEwzU2VveW9Xb2Z3eHRS?=
 =?utf-8?B?dDhiOTkvdnR0TjZscmRpampLTngwNDQ4VkswSmR5THdXbHpVbG43RHY4cklY?=
 =?utf-8?B?c1dMZnpCVUJpQ2Y4SHYvb3QwaEp6MUlJQWlQQXE3OFJWNWNZeHNaek0wTWhj?=
 =?utf-8?B?QVR3c3lKSWVzQWtVZmFReXRNN2hNcnFrN3o5SFZUeWx5KzdXOVdVMUpkNmxK?=
 =?utf-8?B?S3NRNUJoSWxIYkhZWlJic3RXM2VDdytHejRzNmdZNHIrYzE5WThNNGlCUCtn?=
 =?utf-8?B?RjRMQzZCS1RMTE1Rd0RwQjdWWlZOM2NWdENxaklFUldIYVNVZHdVZmQ1SHhK?=
 =?utf-8?B?SlFuN21qQVE3dTZoWmlROWR0WUkrRUFlUGxvU3R3NUtieTlCbWRxTzgvb0hY?=
 =?utf-8?B?TUFxTE1BbFdPSWxVT3ZjcUpCK2Mrb3FWN0JHQTJOSVNmaGFWQ3pMNCtXZWk0?=
 =?utf-8?B?Wjc2eDNOSnQyVDFEa1VFSmtPcXc2U2J0OXF0dUJlOU50SlZtT2JvUT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e2a4c7bd-45a9-4803-9d22-08da1d3a1097
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5150.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2022 10:40:45.1745
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8muuNyz0740NnkdM1/SpHTR7lebUc766BVqXNN3bqSjWAZncVtemN1XHPEebpmExTw9vDnvLcitptetZlfcZAg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4991
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-04-11 18:35, Maciej Fijalkowski wrote:
> On Fri, Apr 08, 2022 at 03:48:44PM +0300, Maxim Mikityanskiy wrote:
>> On 2022-04-08 12:08, Maciej Fijalkowski wrote:
>>> On Thu, Apr 07, 2022 at 01:49:02PM +0300, Maxim Mikityanskiy wrote:
>>>> On 2022-04-05 14:06, Maciej Fijalkowski wrote:
>>>>> Hi!
>>>>>
>>>>> This is a revival of Bjorn's idea [0] to break NAPI loop when XSK Rx
>>>>> queue gets full which in turn makes it impossible to keep on
>>>>> successfully producing descriptors to XSK Rx ring. By breaking out of
>>>>> the driver side immediately we will give the user space opportunity for
>>>>> consuming descriptors from XSK Rx ring and therefore provide room in the
>>>>> ring so that HW Rx -> XSK Rx redirection can be done.
>>>>>
>>>>> Maxim asked and Jesper agreed on simplifying Bjorn's original API used
>>>>> for detecting the event of interest, so let's just simply check for
>>>>> -ENOBUFS within Intel's ZC drivers after an attempt to redirect a buffer
>>>>> to XSK Rx. No real need for redirect API extension.
>>>>
>>>
>>> Hey Maxim!
>>>
>>>> I believe some of the other comments under the old series [0] might be still
>>>> relevant:
>>>>
>>>> 1. need_wakeup behavior. If need_wakeup is disabled, the expected behavior
>>>> is busy-looping in NAPI, you shouldn't break out early, as the application
>>>> does not restart NAPI, and the driver restarts it itself, leading to a less
>>>> efficient loop. If need_wakeup is enabled, it should be set on ENOBUFS - I
>>>> believe this is the case here, right?
>>>
>>> Good point. We currently set need_wakeup flag for -ENOBUFS case as it is
>>> being done for failure == true. You are right that we shouldn't be
>>> breaking the loop on -ENOBUFS if need_wakeup flag is not set on xsk_pool,
>>> will fix!
>>>
>>>>
>>>> 2. 50/50 AF_XDP and XDP_TX mix usecase. By breaking out early, you prevent
>>>> further packets from being XDP_TXed, leading to unnecessary latency
>>>> increase. The new feature should be opt-in, otherwise such usecases suffer.
>>>
>>> Anyone performing a lot of XDP_TX (or XDP_PASS, etc) should be using the
>>> regular copy-mode driver, while the zero-copy driver should be used when most
>>> packets are sent up to user-space.
>>
>> You generalized that easily, but how can you be so sure that all mixed use
>> cases can live with the much slower copy mode? Also, how do you apply your
>> rule of thumb to the 75/25 AF_XDP/XDP_TX use case? It's both "a lot of
>> XDP_TX" and "most packets are sent up to user-space" at the same time.
> 
> We are not aware of a single user that has this use case.

Doesn't mean there aren't any ;)

Back in the original series, Björn said it was a valid use case:

 > I'm leaning towards a more explicit opt-in like Max suggested. As Max
 > pointed out, AF_XDP/XDP_TX is actually a non-insane(!) way of using
 > AF_XDP zero-copy, which will suffer from the early exit.

https://lore.kernel.org/bpf/75146564-2774-47ac-cc75-40d74bea50d8@intel.com/

What has changed since then?

In any case, it's a significant behavior change that breaks backward 
compatibility and affects the mentioned use case. Such changes should go 
as opt-in: we have need_wakeup and unaligned chunks as opt-in features, 
so I don't see any reason to introduce a breaking change this time.

> What we do know
> is that we have a lot of users that care about zero packet loss
> performance when redirecting to an AF_XDP socket when using the zero-copy
> driver. And this work addresses one of the corner cases and therefore
> makes ZC driver better overall. So we say, focus on the cases people care
> about. BTW, we do have users using mainly XDP_TX, XDP_PASS and
> XDP_REDIRECT, but they are all using the regular driver for a good reason.
> So we should not destroy those latencies as you mention.
> 
>>
>> At the moment, the application is free to decide whether it wants zerocopy
>> XDP_TX or zerocopy AF_XDP, depending on its needs. After your patchset the
>> only valid XDP verdict on zerocopy AF_XDP basically becomes "XDP_REDIRECT to
>> XSKMAP". I don't think it's valid to break an entire feature to speed up
>> some very specific use case.
> 
> We disagree that it 'breaks an entire feature' - it is about hardening the
> driver when user did not come up with an optimal combo of ring sizes vs
> busy poll budget. Driver needs to be able to handle such cases in a
> reasonable way.

XDP_TX is a valid verdict on an XSK RX queue, and stopping XDP_TX 
processing for an indefinite time sounds to me as breaking the feature. 
  Improving performance doesn't justify breaking other stuff. It's OK to 
do so if the application explicitly acks that it doesn't care about 
XDP_TX, or (arguably) if it was the behavior from day one.

> What is more, (at least Intel) zero-copy drivers are
> written in a way that XDP_REDIRECT to XSKMAP is the most probable verdict
> that can come out of XDP program. However, other actions are of course
> supported, so with your arguments, you could even say that we currently
> treat redir as 'only valid' action, which is not true.

I did not say that, please don't attribute your speculations to me. One 
thing is optimizing for the most likely use case, the other is breaking 
unlikely use cases to improve the likely ones.

> Just note that
> Intel's regular drivers (copy-mode AF_XDP socket) are optimized for
> XDP_PASS (as that is the default without an XDP program in place) as that
> is the most probable verdict for that driver.
> 
>>
>> Moreover, in early days of AF_XDP there was an attempt to implement zerocopy
>> XDP_TX on AF_XDP queues, meaning both XDP_TX and AF_XDP could be zerocopy.
>> The implementation suffered from possible overflows in driver queues, thus
>> wasn't upstreamed, but it's still a valid idea that potentially could be
>> done if overflows are worked around somehow.
>>
> 
> That feature would be good to have, but it has not been worked on and
> might never be worked on since there seems to be little interest in XDP_TX
> for the zero-copy driver. This also makes your argument about disregarding
> XDP_TX a bit exaggerated. As we stated before, we have not seen a use case
> from a real user for this.
> 
>>> For the zero-copy driver, this opt in is not
>>> necessary. But it sounds like a valid option for copy mode, though could we
>>> think about the proper way as a follow up to this work?
>>
>> My opinion is that the knob has to be part of initial submission, and the
>> new feature should be disabled by default, otherwise we have huge issues
>> with backward compatibility (if we delay it, the next update changes the
>> behavior, breaking some existing use cases, and there is no way to work
>> around it).
>>
> 
> We would not like to introduce knobs for every
> feature/optimization/trade-off we could think of unless we really have to.
> Let us keep it simple. Zero-copy is optimized for XDP_REDIRECT to an
> AF_XDP socket. The regular, copy-mode driver is optimized for the case
> when the packet is consumed by the kernel stack or XDP. That means that we
> should not introduce this optimization for the regular driver, as you say,
> but it is fine to do it for the zero-copy driver without a knob. If we
> ever introduce this for the regular driver, yes, we would need a knob.
> 
>>>>
>>>> 3. When the driver receives ENOBUFS, it has to drop the packet before
>>>> returning to the application. It would be better experience if your feature
>>>> saved all N packets from being dropped, not just N-1.
>>>
>>> Sure, I'll re-run tests and see if we can omit freeing the current
>>> xdp_buff and ntc bump, so that we would come back later on to the same
>>> entry.
>>>
>>>>
>>>> 4. A slow or malicious AF_XDP application may easily cause an overflow of
>>>> the hardware receive ring. Your feature introduces a mechanism to pause the
>>>> driver while the congestion is on the application side, but no symmetric
>>>> mechanism to pause the application when the driver is close to an overflow.
>>>> I don't know the behavior of Intel NICs on overflow, but in our NICs it's
>>>> considered a critical error, that is followed by a recovery procedure, so
>>>> it's not something that should happen under normal workloads.
>>>
>>> I'm not sure I follow on this one. Feature is about overflowing the XSK
>>> receive ring, not the HW one, right?
>>
>> Right. So we have this pipeline of buffers:
>>
>> NIC--> [HW RX ring] --NAPI--> [XSK RX ring] --app--> consumes packets
>>
>> Currently, when the NIC puts stuff in HW RX ring, NAPI always runs and
>> drains it either to XSK RX ring or to /dev/null if XSK RX ring is full. The
>> driver fulfills its responsibility to prevent overflows of HW RX ring. If
>> the application doesn't consume quick enough, the frames will be leaked, but
>> it's only the application's issue, the driver stays consistent.
>>
>> After the feature, it's possible to pause NAPI from the userspace
>> application, effectively disrupting the driver's consistency. I don't think
>> an XSK application should have this power.
> 
> It already has this power when using an AF_XDP socket. Nothing new. Some
> examples, when using busy-poll together with gro_flush_timeout and
> napi_defer_hard_irqs you already have this power. Another example is not
> feeding buffers into the fill ring from the application side in zero-copy
> mode. Also, application does not have to be "slow" in order to cause the
> XSK Rx queue overflow. It can be the matter of not optimal budget choice
> when compared to ring lengths, as stated above.

(*)

> Besides that, you are right, in copy-mode (without busy-poll), let us not
> introduce this as this would provide the application with this power when
> it does not have it today.
> 
>>
>>> Driver picks entries from fill ring
>>> that were produced by app, so if app is slow on producing those I believe
>>> this would be rather an underflow of ring, we would simply receive less
>>> frames. For HW Rx ring actually being full, I think that HW would be
>>> dropping the incoming frames, so I don't see the real reason to treat this
>>> as critical error that needs to go through recovery.
>>
>> I'll double check regarding the hardware behavior, but it is what it is. If
>> an overflow moves the queue to the fault state and requires a recovery,
>> there is nothing I can do about that.

I double-checked that, and it seems there is no problem I indicated in 
point 4. In the mlx5e case, if NAPI is delayed, there will be lack of RX 
WQEs, and hardware will start dropping packets, and it's an absolutely 
regular situation. Your arguments above (*) are valid.

>> A few more thoughts I just had: mlx5e shares the same NAPI instance to serve
>> all queues in a channel, that includes the XSK RQ and the regular RQ. The
>> regular and XSK traffic can be configured to be isolated to different
>> channels, or they may co-exist on the same channel. If they co-exist, and
>> XSK asks to pause NAPI, the regular traffic will still run NAPI and drop 1
>> XSK packet per NAPI cycle, unless point 3 is fixed. It can also be
> 
> XSK does not pause the whole NAPI cycle, your HW XSK RQ just stops with
> doing redirects to AF_XDP XSK RQ. Your regular RQ is not affected in any
> way. Finally point 3 needs to be fixed.
> 
> FWIW we also support having a channel/queue vector carrying more than one
> RQ that is associated with particular NAPI instance.
> 
>> reproduced if NAPI is woken up by XSK TX. Besides, (correct me if I'm wrong)
>> your current implementation introduces extra latency to XSK TX if XSK RX
>> asked to pause NAPI, because NAPI will be restarted anyway (by TX wakeup),
>> and it could have been rescheduled by the kernel.
> 
> Again, we don't pause NAPI. Tx and Rx processing are separate.
> 
> As for Intel drivers, Tx is processed first. So even if we break at Rx due
> to -ENOBUFS from xdp_do_redirect(), Tx work has already been done.
> 
> To reiterate, we agreed on fixing point 1 and 3 from your original mail.
> Valid and good points.

Great that we agreed on 1 and 3! Point 4 can be dropped. For point 2, I 
wrote my thoughts above.

>>
>>> Am I missing something? Maybe I have just misunderstood you.
>>>
>>>>
>>>>> One might ask why it is still relevant even after having proper busy
>>>>> poll support in place - here is the justification.
>>>>>
>>>>> For xdpsock that was:
>>>>> - run for l2fwd scenario,
>>>>> - app/driver processing took place on the same core in busy poll
>>>>>      with 2048 budget,
>>>>> - HW ring sizes Tx 256, Rx 2048,
>>>>>
>>>>> this work improved throughput by 78% and reduced Rx queue full statistic
>>>>> bump by 99%.
>>>>>
>>>>> For testing ice, make sure that you have [1] present on your side.
>>>>>
>>>>> This set, besides the work described above, also carries also
>>>>> improvements around return codes in various XSK paths and lastly a minor
>>>>> optimization for xskq_cons_has_entries(), a helper that might be used
>>>>> when XSK Rx batching would make it to the kernel.
>>>>
>>>> Regarding error codes, I would like them to be consistent across all
>>>> drivers, otherwise all the debuggability improvements are not useful enough.
>>>> Your series only changed Intel drivers. Here also applies the backward
>>>> compatibility concern: the same error codes than were in use have been
>>>> repurposed, which may confuse some of existing applications.
>>>
>>> I'll double check if ZC drivers are doing something unusual with return
>>> values from xdp_do_redirect(). Regarding backward comp, I suppose you
>>> refer only to changes in ndo_xsk_wakeup() callbacks as others are not
>>> exposed to user space? They're not crucial to me, but it improved my
>>> debugging experience.
>>
>> Sorry if I wasn't clear enough. Yes, I meant the wakeup error codes. We
>> aren't doing anything unusual with xdp_do_redirect codes (can't say for
>> other drivers, though).
>>
>> Last time I wanted to improve error codes returned from some BPF helpers
>> (make the errors more distinguishable), my patch was blocked because of
>> backward compatibility concerns. To be on the safe side (i.e. to avoid
>> further bug reports from someone who actually relied on specific codes), you
>> might want to use a new error code, rather than repurposing the existing
>> ones.
>>
>> I personally don't have objections about changing the error codes the way
>> you did if you keep them consistent across all drivers, not only Intel ones.
> 
> Got your point. So I'll either drop the patches or look through
> ndo_xsk_wakeup() implementations and try to standardize the ret codes.
> Hope this sounds fine.

Yes, either way sounds absolutely fine to me.

> 
> MF


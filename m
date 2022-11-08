Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E08262059C
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 02:08:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233202AbiKHBI1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 20:08:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232083AbiKHBI0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 20:08:26 -0500
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EC90638A;
        Mon,  7 Nov 2022 17:08:25 -0800 (PST)
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A80V31G008193;
        Mon, 7 Nov 2022 17:08:09 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=s2048-2021-q4;
 bh=7W+gwr2dcQrulshbGi2+OY9QzIrrtCXswWLTZLlv6aU=;
 b=OG3SxCmCCT/uJ3Wdilykl6PHTzePGhBNfgkMyNHvrQ5iJ11OgOM2TFmINJ/cghFH0lt1
 oWLmRqArb5IvYHDuOWrtHXezMI0qpXl9wCsvFYZ+n/emVKoV+ik5QiiipGtzxFablrpZ
 M88+s+S+XoDyyhcFoAsrhrch8GO+qVT+S9VeyIWrtyuuBwWRnMu1iSZVesi0EPVTgRh2
 i3oqruHvbxqh1yeYrTYVMMUJRRvPJVXFyB7YQeCfmVANNMIM9AY8Q3Lmg9amAM+Ew6Gt
 GlMbGgcl/8LhIBFKwk7ZDJWExX4dKfM860IcX5DmEkH5aXSYshHc3XCbcys9kWEkUQSa 3w== 
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam04lp2175.outbound.protection.outlook.com [104.47.73.175])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3kqcmqr8pt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Nov 2022 17:08:09 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JUEzUIussHAbRp+x+rf5PF2MFHXDQgy39aejgOiLkiaJANFQEFweVqGQkVS5C3sRgaZ1EqP+frvw/UO946gdUPdfabUgLZ81j6D5g3x4wxBJ33lE6EhK0fYMIsVg5FINdPYAtSr1KrHgwADf4fWHfMfd5vusOggC8x863Mqq8UqLrma9aX2s8megzx+WWCRyVXOjOdh1jTQX7yfhI7NKTHw+vzZ0O32VqKyvz/BqDm0udHihqnlIKIp9izsu1phC4gBfk5C724N8Jm1g+wMp/ivcYPDYbivaWbysG810YwTt5EpmBi7wTKUZ3ZzVkxbculr6hwCTi1k0XIo08AS0cg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7W+gwr2dcQrulshbGi2+OY9QzIrrtCXswWLTZLlv6aU=;
 b=SFYdNSSSJtqx33LMU6anwa16CrTIJN39J58GkW9yWGxoPuyq7YGhz/varVmBFCIUNqUbSmGIleIsT8TgOu+MdLepn/K/CZairV/rXWusmWel0oo61jsiAySbpnGSF6AFNYcrPERjWAXx0mz+I2Fz17xnYl61rMxkrGpOxNbuY+YTilN+1I7k1qr8FoqGbOonozC8DUDEnXMP+cN8TUXLrEWZbmCiv/tiGRW0o9XcGP/WiCICutOLpASZNg0UWn7tx1jtDrSZBK6A1WMcYdi9ICs9cVD7qzp2/DVTQf9hjoPk5WhTnhy+tYzqAyy6SbJhz5qTeKw4wFywB/nKOJtT9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SJ0PR15MB5178.namprd15.prod.outlook.com (2603:10b6:a03:426::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.25; Tue, 8 Nov
 2022 01:08:07 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::1f2:1491:9990:c8e3]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::1f2:1491:9990:c8e3%4]) with mapi id 15.20.5791.026; Tue, 8 Nov 2022
 01:08:07 +0000
Message-ID: <97333915-9a71-1c6d-aae5-5813e1828f84@meta.com>
Date:   Mon, 7 Nov 2022 17:08:05 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.4.1
Subject: Re: [PATCH bpf 1/2] net/ipv4: fix linux/in.h header dependencies
Content-Language: en-US
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     patchwork-bot+netdevbpf@kernel.org,
        Andrii Nakryiko <andrii@kernel.org>, bpf@vger.kernel.org,
        ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        kuba@kernel.org, kernel-team@fb.com, gustavoars@kernel.org
References: <20221102182517.2675301-1-andrii@kernel.org>
 <166747981590.20434.6205202822354530507.git-patchwork-notify@kernel.org>
 <1db13bff-a384-d3c8-33a8-ad0133a1c70e@meta.com>
 <CAEf4BzbuaTk1KdYJ5w_8wQLo01i_+js-jvYbTZ_zeWwGm9Zu=A@mail.gmail.com>
From:   Yonghong Song <yhs@meta.com>
In-Reply-To: <CAEf4BzbuaTk1KdYJ5w_8wQLo01i_+js-jvYbTZ_zeWwGm9Zu=A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
X-ClientProxiedBy: SJ0P220CA0005.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:a03:41b::12) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR1501MB2064:EE_|SJ0PR15MB5178:EE_
X-MS-Office365-Filtering-Correlation-Id: 7340fda5-869c-4cac-4d9c-08dac125b240
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Q31vOSf27oDGhv/za1acOX9wCKkh2HZQuWQwvglAnPYY7qUJlwh82KpMJ8OQBfOPd34HtIliBl+ICVmdbEsUpLMTBqd/aFzbDJwlbxNkGRqYAH/cKzAyWp3tSdhoJs5oEYDKVpowFnTHHVWsz9k5sCqhY0fzJTJ0BhmQqm60vEHIP5IeAhXtdLsn8OkzfnQuVNYzCXafhoPdb8GNdKw9Ck0DObqIpfa3DlTfUN8esDzNf1MR6ke/ZYHHGvl+zR2yOvn692e6dA+/F5L4/NQWXKnBiBRSYgsKMK/rnQsWdJObIp7nNi9own/nFMhOn8H6Ag4q2Pcif/N7LvH/pjwFG6FVlV4dcyriyDlywIzmBHUU2WS4d8+Y8CvyDsLJRwKHm6Ju2U7LoqDhfVe8maaMfUPZ8WWAUSfBOMV7inPqdM9mK8Vlp+BxORn+GlmZOgxWcD/pMg04pHGoNSsKRH7OXFLv57qxLTy1pXr94V9j5A6Gd3DmVYLNcAXb+88AsDkcgFGoEC5HUZIq4prpiPJlTMJepzkRsalZ7wekAFhyzTP+GVrWr/G52wocxVQmEcKLx/T9IhFzvoDUMV1Ia2ggKpgg0i1sxE+A/mJSyMQz2/KVqOTWYTH414ucH/BMdDj81ogzWsnNtk6WPkcYrQYDz5/KvrLHCz8qpkieEbnHlEwcx55m2UyGPwIo8hlVIRI6EaphB+dULXaW4ILWrjuWmvbUl2L2TLmyesEUuLzzYSOHJrBFxPM2gS0Htx+cy6I9KdChel0qzLLwMmhnEzpkDyB2ATA012r1P/PbWoVUCpUrEiH1AWZ8cAiFPA/lcqqD6o9OrJUfGz9JJ6bnmMP8Q6fv7eYeA8bLaxf0tVJWHwOPBFLwjsUGhRq6cLfdV0ZZ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(136003)(39860400002)(346002)(366004)(376002)(451199015)(2906002)(66946007)(66476007)(66556008)(8676002)(4326008)(6506007)(53546011)(478600001)(31696002)(86362001)(6486002)(186003)(2616005)(6916009)(36756003)(6512007)(5660300002)(38100700002)(31686004)(316002)(8936002)(41300700001)(966005)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eFY5dG1vSThwV2pTemJXdDBvQnpKbnF1NGxHcHJlaUlrcE9leWdUTzVEOG53?=
 =?utf-8?B?LzVRenhqclNWZnJtQmozRFp0TE04SFlUQXdXM0FkOUNseUlPTW9mRGsvb2Zi?=
 =?utf-8?B?V2s2TGFCYVZqbC85enpXbzdxWVRwVnhFNHZLNHRYbnRLK3JyNEJWQll2M3Fx?=
 =?utf-8?B?dldCZnVCcTVPMDkwNzUwd3BHRGNRKzBlallRZlB0aGZPa2dIVFpWTjdSQlA5?=
 =?utf-8?B?NjdPOFdRQXVXQUZLclJuWFM3L1RiYmMwRFFwVHZIaEFWVmxXSEx5eW5rMmxt?=
 =?utf-8?B?ZlE3WDBpTjZyMmVuL211R05UL3JMeS8wY096VEZXSkxzVlFSckoyMmtOMCtD?=
 =?utf-8?B?a2o3Y080WCswaU8rN0RVZnYrVGJ4eTZiWStuLzkwTXNjL2ErNjNHMEh1MFdP?=
 =?utf-8?B?VUMvb2hzVXBwMWpDT0hwdmo5TUJOZlJTNzQwbUxzS2prT0hQam1IRW1nNk1F?=
 =?utf-8?B?K3ZZUkpqWTZiOHBMZnhMVERMdmpnWENLc1RGM1dnU2RlNDhtOGh3c3Q4R0Np?=
 =?utf-8?B?UUovdXFKcTNpemJYcVhhY1JvTFd5UDdDa285My80QjYrd2RtUm1oL2dBUm9M?=
 =?utf-8?B?clNUVTZZcW1YUGxldmNUV1VlQXJUN1gveEV4UXRBSGowWG1IZkVOeEFNb1Ji?=
 =?utf-8?B?K2VPUnVtcVlPc0xLKyttYTA1SytOc0Vtd3NFR0czdjlHSkg3L2xwQWsxck1y?=
 =?utf-8?B?QTRLZnJsaVAxY2dJK0R1cnZ4UEQ2b01wY1p6SkV3SXNQbjZVTEg4Mmg1YVRv?=
 =?utf-8?B?ckl5SS9jeGVQNUs3bTAwaE9SSi9RY3VOejhva0MyZTlTdGZ4VTZjRUpLdXl0?=
 =?utf-8?B?cjlFSnFPa2I4TmVoZ1VNU3pwbTdHS0l4WXdDU2lON1FyVnlDT1Z1T25UN05H?=
 =?utf-8?B?b3p3SkJSQWphU3BWaE55SENZYWo0YU1sTXkwV2dCRzN0MWE1MUlvTHFmUlNP?=
 =?utf-8?B?RUhNL2lzOTJLQ3BZQTlGRlQrdldmaXdkc3dzdmV3ODI1VXd4dER6MUc3YlM5?=
 =?utf-8?B?SGp0a3k5R2xBTTQzbFlva01RUFlxNGpweW1ITkVFNU9nalo1dUkrZ0RuSFpD?=
 =?utf-8?B?bkZkcVd1RW8xYjdlZExVVkZVcFpWdTNNcE41STJXVm1qdXNLbVgxWkQ4azdZ?=
 =?utf-8?B?TGdydnBtUDF5VEVqcWRtd3NVTDlEV1ptWmJtZzhuQUhmdTZyWUxuRitKdUhQ?=
 =?utf-8?B?c05MZFVaZEZUY3pZeGlKVFNUanlHK3lpUE1jbmdBVi9iWFNUUFVwcGRoV1lS?=
 =?utf-8?B?T0ExUmloSVpDVVRzYUQrK3V4WUNNa3Z0VXNzK1JPVTZ4U3J4S0ZEL1NRNHhs?=
 =?utf-8?B?RVhZMFY0TjVxellCTGhtNEhGc3dUc05kK0htYnJGcExxZXZpaE54N29UTm1X?=
 =?utf-8?B?UmZRMDVkTTgzL0dmbC9OVHZDNzk1N0IrWFI4SGtBNC9TLytrVHBDSTZlZ0lN?=
 =?utf-8?B?b045amwzVlRGYUlabnRhd1BGd1ZGR1dVSTFVa1NUMlFBSS9WRXhhKzNjS00v?=
 =?utf-8?B?Y0hNOUlpWk5JcUdUZWVRR3hXeXlOQlkzOTNlWUMrV3Y3YVYyazRFT2owaUs0?=
 =?utf-8?B?OCtBNEJsVDRQY0hYQU5jTDB2R1N6R2NZNjY1eFFxcGpDbE0xWkxnbEY0Qzdp?=
 =?utf-8?B?dEg4alZjOXlGZVR1b1BwRHh2ak9IQjRJMXAxeFYrREpvMEhuZE9ZQVpYTkpI?=
 =?utf-8?B?VFVYRlN1YXpqcTNNWmxUSmFsL0Fvb2pmUnFxZEU1OGpEUHZCdkUyR1ZHOEJp?=
 =?utf-8?B?eWZFRytQcWJjaEVxUS9nSFpLMGdhckwzb1dCZmtiOWlwSDRSbjhkeC9jclp2?=
 =?utf-8?B?SThweStacjUwckJ6Vkh2WWluU3ZNL3VKMGRjRWt5ZmJwSDUvNDJ1SlZkaFJK?=
 =?utf-8?B?ODhmUFRnRis3VmJRYlI2ZjlFSU1KMnVHdHF3ZEN1V3BWb1lwRURnY3Z0K1lm?=
 =?utf-8?B?U1NvVUhjaDc3cGFTbWtzUFFiMkRGUGxxMytGZDRqYmN0eGJ6RGZKVS92SVlL?=
 =?utf-8?B?TVhkR2p1TmJaK0FSRW9HMGhaNGZZVEJOaHg1bUhTOWhCOU44bDA4a1EwNUE5?=
 =?utf-8?B?OHRxYVh5ZVZwcnRhbmd2T3o0TWFWUmxqaFpiVlNieFJ0bG5aZVZyamJKcCt0?=
 =?utf-8?B?ZTAyU0FTaHZGR3BoaXorSTZreStSTG4xMUxYaE5ZeVJHMlUwVWJETFR1R3Iv?=
 =?utf-8?B?M0E9PQ==?=
X-OriginatorOrg: meta.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7340fda5-869c-4cac-4d9c-08dac125b240
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Nov 2022 01:08:07.6261
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: a+o2WgHgGpN+kEmkrUQ9oj5oPtSiufV7J9euUFus+b/dwE/K0QLaD/ICFbVGSRni
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR15MB5178
X-Proofpoint-GUID: UC0P92qYmmzyMW6N50DqRFSe7ouJIUO4
X-Proofpoint-ORIG-GUID: UC0P92qYmmzyMW6N50DqRFSe7ouJIUO4
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-07_11,2022-11-07_02,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/7/22 4:56 PM, Andrii Nakryiko wrote:
> On Thu, Nov 3, 2022 at 9:18 AM Yonghong Song <yhs@meta.com> wrote:
>>
>>
>>
>> On 11/3/22 5:50 AM, patchwork-bot+netdevbpf@kernel.org wrote:
>>> Hello:
>>>
>>> This series was applied to bpf/bpf.git (master)
>>> by Daniel Borkmann <daniel@iogearbox.net>:
>>>
>>> On Wed, 2 Nov 2022 11:25:16 -0700 you wrote:
>>>> __DECLARE_FLEX_ARRAY is defined in include/uapi/linux/stddef.h but
>>>> doesn't seem to be explicitly included from include/uapi/linux/in.h,
>>>> which breaks BPF selftests builds (once we sync linux/stddef.h into
>>>> tools/include directory in the next patch). Fix this by explicitly
>>>> including linux/stddef.h.
>>>>
>>>> Given this affects BPF CI and bpf tree, targeting this for bpf tree.
>>>>
>>>> [...]
>>>
>>> Here is the summary with links:
>>>     - [bpf,1/2] net/ipv4: fix linux/in.h header dependencies
>>>       https://git.kernel.org/bpf/bpf/c/aec1dc972d27
>>>     - [bpf,2/2] tools headers uapi: pull in stddef.h to fix BPF selftests build in CI
>>>       https://git.kernel.org/bpf/bpf/c/a778f5d46b62
>>
>> Can we put this patch set into bpf-next as well? Apparently we have the
>> same issue in bpf-next.
>>
> 
> Unfortunately we can't because they are already in bpf, and if we have
> them in bpf-next, they will cause merge conflicts. So I currently
> cherry-pick those two patches locally when compiling selftests. This
> should hopefully will be fixed soon and bpf and bpf-next will
> converge.

Thanks. This should be fine. I guess most people will do the same
thing (cherry-pick locally).

> 
>>>
>>> You are awesome, thank you!

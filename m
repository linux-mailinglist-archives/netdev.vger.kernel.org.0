Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C714577312
	for <lists+netdev@lfdr.de>; Sun, 17 Jul 2022 03:47:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229772AbiGQBr2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Jul 2022 21:47:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbiGQBr1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Jul 2022 21:47:27 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22B271262A;
        Sat, 16 Jul 2022 18:47:26 -0700 (PDT)
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26H0pHmD009631;
        Sat, 16 Jul 2022 18:46:40 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=Qkyl1pUpRYebTRuwr9oQQ1AySEpE4rmKhkgAwLYBv8w=;
 b=BkSJ0EqFKBaUnDFIoa8YZM2IzEhn2IwW6KPvNsqov+D/8ywo1pjP3uuV3jQqi0VPgS7e
 lK52+WlvxxnJ/5xPpL4dE0adUIhqAig56I01w5BTXjvLYu0eyzmipS2xc32slCIYahib
 3kZ78S6Nr2dJ1SCF2QqqRjj+94kydfCZHUA= 
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3hbtuyjaea-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 16 Jul 2022 18:46:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y/Y5GjPDv6IDD7svFrNs+8QT4CnvLCLE00t63d3p/YwGBk1bF15rmv1Shq4t3m11jPhCyEfrFILzRJM9O4zc9wae9TU2RuuRxB4iHWR2pIQcweMLhtAm4zYgPvYFBwRPdDDjmG49uOE7AlsI9ys0Jlu83t/ZrOcVmWTjimMp/lWHvKAvPyOvrGBM/OEYvSqLmr/tV2QHfP2GvZNvF9TnfPV5J+qzPP22govOl8F1tNlYm8ohtBU+xQPCCL/vRoxExtVhmKRMImlHXAWYwYS0jtnVH07OtxaT8QgAoTWLKOBBiEbBwhoMkT3bi02PTqK4SsgsxbtjjPohNNvg+bIWdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Qkyl1pUpRYebTRuwr9oQQ1AySEpE4rmKhkgAwLYBv8w=;
 b=Jn6JUlRopaqfC2KfkIhUk2/GrGJ6qL/NEWedv5QwtNz28bUm3kO1XRFpY3//39Bb7n9/R3ObWG+0MxG0E4JMzbxPFfkkKlrIaQdlom2cm2Gz7Vht567Cl+y2A6OIAeOAk3RtlYWm5wmvp04kYsZlHdI3aYgzXIoGT3ChEcXwCbQt+FirLWf/EMwZpIyLF8GmmWhYw2ax574GU+EnSuHVEkxtv4yvpQibfufis+/w8oxUCFtR+h7K6fqk0yZovACbPGPyJU3ptNsRXsR2t7+qZR+fLHAfIKYjilUWQMW6EpfgNpPwohM4E8/H6ZIHpp1rfjG0axJbdb/8KjfUNxUwvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by MN2PR15MB2639.namprd15.prod.outlook.com (2603:10b6:208:123::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.22; Sun, 17 Jul
 2022 01:46:37 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::9568:e5d9:b8ab:bb23]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::9568:e5d9:b8ab:bb23%6]) with mapi id 15.20.5438.021; Sun, 17 Jul 2022
 01:46:37 +0000
Message-ID: <f0f31c00-c4a2-1df2-01f7-4e74685ee019@fb.com>
Date:   Sat, 16 Jul 2022 18:46:34 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.11.0
Subject: Re: [PATCH bpf-next 5/5] selftests/bpf: Remove the casting about
 jited_ksyms and jited_linfo
Content-Language: en-US
To:     Pu Lehui <pulehui@huawei.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Quentin Monnet <quentin@isovalent.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>
References: <20220716125108.1011206-1-pulehui@huawei.com>
 <20220716125108.1011206-6-pulehui@huawei.com>
From:   Yonghong Song <yhs@fb.com>
In-Reply-To: <20220716125108.1011206-6-pulehui@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0201.namprd03.prod.outlook.com
 (2603:10b6:a03:2ef::26) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 05b122b9-0f08-4d8a-10dd-08da67962ff0
X-MS-TrafficTypeDiagnostic: MN2PR15MB2639:EE_
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lfA4WXBBXPBpKTDvTPYvZJxLcTLgi17icNj8x2s+glfPRyv/woEdZHjLzbdDFNl5kYlD2O0z8B8KaZSnoN6Oj8BYI6uNkuIdccXCVO6lCfrt4JiyKRktT4NfpzFMoC470S+wiRCZYWoVcOhey7xuaHSFXbF8Js7J5dumNZLbkqk4btkwnjPTbfJYGL/uOLoFU67TyJi/JUxx0n2BQ+SXMzcduV8xjNzNgHArOOM+dQ8rQ/YG+I3vsSY9HZnm9OQkrKMUwRbtZf5OChv1kMJnNqoXEwlJK2u+3PwWTN5Rsz9288JFgyOitUCPKrHYGduqMx8WbXSve69BgkX9/L3IqfrL31+pf8sq2u7PlynQkEtB+Sbpf4CuOEmrIb4ME1mqVZoOKuEjiffGzjcu2EnL4H/PA6fTw31fJh3ehAqKJIDQodTCJTUeaT0wxaXjtk1PQ3pfXr7hBCngzY9k/yGlVFx5xiCVMl4DFipazzxNct8ODaV61XGrhINAQMYcmfyo0nYaJ5mt1PUs/cPWaDkZ15T1g0jEdVKucTSie+hzzI+/NbxALrojkotJZowla68Y4wzTx0TVMFbaQ0Xl1kA/UuFASjYqpfdzXz/8+xAbu1uxM/S0kXACnfCRjlHP0URpgL+/cdpoOPtN6RrktZw1MYHcLiUmm7/3WSuuR1UVvdqyovO1JtO6Hl7PcVn8hZuPDdljiM9RAKNcuR+bMrWUi2sxx5MNV9Nb2aVZR3RWRG1SnqvuPF3LyA8In20+auusMkO9Tz2m8BpSuJiPfVsWheKXVFO3+Os0LhrIW8K/+EOwlccMywD7uoDGtOgzMjOzLv55osakDBt0vBU2+SPf+sFHw4CE/D9/PTSoprkCtwU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(136003)(366004)(39860400002)(396003)(346002)(6666004)(41300700001)(6506007)(31696002)(6486002)(478600001)(2616005)(186003)(53546011)(6512007)(38100700002)(83380400001)(2906002)(31686004)(7416002)(86362001)(8936002)(5660300002)(36756003)(316002)(66946007)(8676002)(66476007)(66556008)(4326008)(54906003)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RDYrNUpFZ0VqQlFQazZiT0ZZTTdjZURnanIrbGFyVUxPL3crNE1hTm1oYmtZ?=
 =?utf-8?B?N3hpazA1TjFGcjJSK0oyV3ZOcWdNbkZRaTdRQ3FEUlBiOHFRbVEwUGltbmk4?=
 =?utf-8?B?Sm9GM2dnR3lzNkRCNkdQMk8rTW5FVUhIU0xXOWp4SFN0K0pZTG1rR0JLa29r?=
 =?utf-8?B?MVZKYjRUQTR6Zk0xVDVpNGRVVDk1Smk5VDhONm95WDNXMUJQL1BnSjZ4TVlE?=
 =?utf-8?B?L2h5Z3N2RnNOZzFWTDVhellJM1RWcXlaQUk3eTdpRm9xVzhhQ3E2R2ZnZEU3?=
 =?utf-8?B?Z0hIcDU0cmZLeFVlM2hnS0hyclQ4Q2tnanlVcURXVmdpc0tDWWc4dmVmaSs4?=
 =?utf-8?B?VTR5bUpYV0x6Q3JLN0FzL0NEVVNtY1UzZjUzN0NveFFnWlV0bjFtL1VCSVdZ?=
 =?utf-8?B?QThiWll0b21Fc3FORUorQU03YzFXdWV3QlFMbkg4SDNLQ0dSTTg4MnNmUFVx?=
 =?utf-8?B?NW8zMHBvWDE2NmlJS2wyT01mQW0rQ3B4Q3N2OTJnLzRhRm5lRVowOVpMcWxI?=
 =?utf-8?B?Njd2UEpRVUxpbEl5U1MxN3ZHdU9ieHgxSGV5MSs0WkJMdXVwckY0UlFjdjVh?=
 =?utf-8?B?SGVLU3FMN05meGhOZG56YWNIaFRZbk52a1hPR0dobUpJRnRyZG1iSENENE5o?=
 =?utf-8?B?cEF0enJYR2ZNOSs1T0lsaFNrREJ5dmZuNUpnVEdTWGwvUE82NnM1Vit4S2lD?=
 =?utf-8?B?aWp1aU9peU9MbFYzSmpid3JrNGdZMUpGUytWR1dOOWRaZXorczF0Z3ZiRmI4?=
 =?utf-8?B?WmZXV3JTKzRjbm5jVmhMTko4T29ocmFtaCtUdFFINFJjYk9GdkV3ZExNQ0Jq?=
 =?utf-8?B?NFRlUDIzWUl0S1RXVm8zOWFRdk9iSUtyZG55dGlvZi9qcVNjdzlxUldFdGNS?=
 =?utf-8?B?TUF3MzlPdFVIaE9QelZwNjR4RTJPZkJHT3Y0WjhJTFEzb1E5ZGFoZ0cyMWYr?=
 =?utf-8?B?YVhLa3ZlMUdSZ3ZVNksyN3VLd1Z6R3FFMzNWZkk1M1RHalhDdE50RGtDOThn?=
 =?utf-8?B?dXJSZFBhTDFSYkJhY2pyR3hSd1FuRVBXYnV0K2ovL2pIMTk3cU1lS1p0WTdC?=
 =?utf-8?B?SXdPU1JQeEJNVG5Ra0U4YmdZZHNLdVYxMEZ5cjI0VmNDeWZtSkFjYk8wNURY?=
 =?utf-8?B?a0xWbHJMUkpBU1RQdHVZR0hBV1g3c3N6MGVtZVNJQ0FOYXV1R2d4Wjh3WXFr?=
 =?utf-8?B?QS9JdnhveEhmVGNXeUt2U1NyaWFGUTc2SmhFRy90ZUFvNDVTYlVFSmdKdEI2?=
 =?utf-8?B?aE4yMm4vV1RDYVhBelA3dzdWeVc3SUd0SnF4SVlwNW1iQjZxK0lKcmxqSWFT?=
 =?utf-8?B?dWFYeU1jUXlleE5xL0U2bk8rN1pKUy9mNGxBZ3NiZ3M0RHQwazFMb1h3VkEx?=
 =?utf-8?B?NjlqNUdqVzJrWWpJR3hIMzhXZlkxOEZuNTVNTHhYcHliY0xJRDVORWJqZ0xH?=
 =?utf-8?B?SmZPdUNxZjFzY0kxSVBubk00b21qT1VmTnJnTEpqRFd2S2dpMkJ0VmtDT2Vm?=
 =?utf-8?B?M3pBWU51NnpXeGpxVU9STVI4MUpwVGovS25wZnFSUzdNa3hVYkEvbzZlMUQv?=
 =?utf-8?B?ZVpMUnRWTTJDRkYrR3NKY21iRWxrYnBVeDBreTduSHpBT2RRL0FhN09zWHRx?=
 =?utf-8?B?ajJhRTBNK3FsZWQvbzk0dk9zcnEzc0w5VUFuVHMzMVI4dml4ZzFsZ2o5Ui9E?=
 =?utf-8?B?R2hGdDM2cXNlMG9vV0NjQzloUDlNOFJkYTczMmlEMUhDVVZvT2xDdlNTTGwx?=
 =?utf-8?B?azJOcVpKNGhWK1UxUllEWnMwaUlPajdYTU95WFRoa1pFaFdrcG5McGtvTWEw?=
 =?utf-8?B?ampYTVBwc09HNlV0YXhEa3Ixc2NjK0FCcllEdXdnUVZNb0pXc3JtR1lQNHNX?=
 =?utf-8?B?RUZpVDJoMlNLRXNyZngxTVFJS2xicWxRSHV0MXZzb0NNQWU0YUNPaTc1em5r?=
 =?utf-8?B?TzMvUXQ3K3MwU0JoaUw3V2h1WDF1YnFNak5ET1lsdFlCcFZZZzQ3UU1idmZj?=
 =?utf-8?B?S2pPdlJ4ajZsVmJIdmk2L1FnL3oyMnFpTllqQkFkTEU2WEVLWDdoM2cwcEtk?=
 =?utf-8?B?TTFZRDBYRDdvTWRDelRiVEozRnB0Z2JrWkNscEF2ZXduaTZielAvdWh4aU14?=
 =?utf-8?Q?krZoNoAcK3EGCuMUwGGNaB4EU?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 05b122b9-0f08-4d8a-10dd-08da67962ff0
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jul 2022 01:46:37.4613
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lPb+4mph4tNfk7jwP6K0lOfKhWcGDDXpvHhK8LvrBdmqX2O3W0jqNmt32BDc2+X+
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR15MB2639
X-Proofpoint-GUID: GeJeDQCudw0oA1oYfwLiv_t6hJoIXRiM
X-Proofpoint-ORIG-GUID: GeJeDQCudw0oA1oYfwLiv_t6hJoIXRiM
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-16_21,2022-07-15_01,2022-06-22_01
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/16/22 5:51 AM, Pu Lehui wrote:
> We have unified data extension operation of jited_ksyms and jited_linfo
> into zero extension, so there's no need to cast u64 memory address to
> long data type.

For subject, we are not 'Remove the casting ...'. What the code did is
to change the casting.

Also, I don't understand the above commit message. What does this mean
about 'data extension operation of jited_ksyms and jited_linfo into zero 
extension'?

In prog_tests/btf.c, we have a few other places to cast 
jited_linfo[...]/jited_ksyms[...] to 'long' type. Maybe casting
to 'unsigned long' is a better choice. Casting to 'unsigned long long'
of course will work, but is it necessary? Or you are talking about
64bit kernel and 32bit user space?

> 
> Signed-off-by: Pu Lehui <pulehui@huawei.com>
> ---
>   tools/testing/selftests/bpf/prog_tests/btf.c | 16 +++++++++-------
>   1 file changed, 9 insertions(+), 7 deletions(-)
> 
> diff --git a/tools/testing/selftests/bpf/prog_tests/btf.c b/tools/testing/selftests/bpf/prog_tests/btf.c
> index e852a9df779d..db10fa1745d1 100644
> --- a/tools/testing/selftests/bpf/prog_tests/btf.c
> +++ b/tools/testing/selftests/bpf/prog_tests/btf.c
> @@ -6613,8 +6613,9 @@ static int test_get_linfo(const struct prog_info_raw_test *test,
>   	}
>   
>   	if (CHECK(jited_linfo[0] != jited_ksyms[0],
> -		  "jited_linfo[0]:%lx != jited_ksyms[0]:%lx",
> -		  (long)(jited_linfo[0]), (long)(jited_ksyms[0]))) {
> +		  "jited_linfo[0]:%llx != jited_ksyms[0]:%llx",
> +		  (unsigned long long)(jited_linfo[0]),
> +		  (unsigned long long)(jited_ksyms[0]))) {
>   		err = -1;
>   		goto done;
>   	}
> @@ -6632,16 +6633,17 @@ static int test_get_linfo(const struct prog_info_raw_test *test,
>   		}
>   
>   		if (CHECK(jited_linfo[i] <= jited_linfo[i - 1],
> -			  "jited_linfo[%u]:%lx <= jited_linfo[%u]:%lx",
> -			  i, (long)jited_linfo[i],
> -			  i - 1, (long)(jited_linfo[i - 1]))) {
> +			  "jited_linfo[%u]:%llx <= jited_linfo[%u]:%llx",
> +			  i, (unsigned long long)jited_linfo[i],
> +			  i - 1, (unsigned long long)(jited_linfo[i - 1]))) {
>   			err = -1;
>   			goto done;
>   		}
>   
>   		if (CHECK(jited_linfo[i] - cur_func_ksyms > cur_func_len,
> -			  "jited_linfo[%u]:%lx - %lx > %u",
> -			  i, (long)jited_linfo[i], (long)cur_func_ksyms,
> +			  "jited_linfo[%u]:%llx - %llx > %u",
> +			  i, (unsigned long long)jited_linfo[i],
> +			  (unsigned long long)cur_func_ksyms,
>   			  cur_func_len)) {
>   			err = -1;
>   			goto done;

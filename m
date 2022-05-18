Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BDEE52C4A0
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 22:42:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242730AbiERUmX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 16:42:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242709AbiERUmW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 16:42:22 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 779F07093D;
        Wed, 18 May 2022 13:42:21 -0700 (PDT)
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24IHDXpi017347;
        Wed, 18 May 2022 13:42:05 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=KCC+OpjXDf1I6aKkfDAjyB69RB68xJQKfLKiFam82Mg=;
 b=Vyu2/19DHbkqg8GOSaUBvXkQY5kIW3MnFq+fk/K196jv7fX6chddLowrTAhZU5+aURop
 V8lcqjFhasHvUJilf+ziIUsUtrXbNOrNWvHStj+kFpXs1MuunzanokI6aFpRINdq7NZM
 gCcWCQakDfP6uDh5xrQPFdgdttnqlpZUaOE= 
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2044.outbound.protection.outlook.com [104.47.51.44])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3g4frt9ms4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 May 2022 13:42:05 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MQEdE7ukpU8Vu0piW2zVtQFKaNuQ5pUDClIlXDiSl9OBF4L40F1/CaCMJNmtXJ5JSHnokmwlDoOMYm+n2ogqFHkrREYiyw4nbwofIPDhx7pzDbd6h+QEmwV6ur83BTP0wBii/4/PjbgJWAgdWlDQMNkXDX1XJjTuZnpEqIb2eYaLnkAcd0ku8tKq0ykQ5SYr5SZw3C3Phox9Szz1c5IRvA0TKaaJarJnjFfqwo38zsvc3EHsIDD1P0R/WE/ts3syv9V/wqn769/4AlXhotKs2xfCpH57sqvVOIeaqkAPgGPV3GjxUwsvEvglgM9sj0aTQDyb0Fet5Hqo9cfQ3z0hhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KCC+OpjXDf1I6aKkfDAjyB69RB68xJQKfLKiFam82Mg=;
 b=J7ybweE6FZ7Oq02ZDx1VFs8ddT5njrmeWESDr+XsvPmzaa/y5OoYzWGo8qEzxqa6hypzSupcA6OnTf7kNozrK4gxpOyg8EY5DkmNO4QfckIUnUpYn51bFP1z5e1j1ffFExo8zkqsPyyCoPnvWvMzqfFgHbLmUUTr9HOW22nvtgvgQsyz9MhEVbDcFKJ1PY/lEiza5RZumwqXKyWbQ0Q2P5c7Jg/w9ZdiwumjmBqNlV2wdJHws2Zl0CU+cd3QIuY9cXs0KPNaIC4GgiWSwqFupwkt7V66SwQqSKHWG1kyDTNtwmBgRS8owlBP1sZ6li9uUisabbEZGVp1nqj77Nz93Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by BY5PR15MB3716.namprd15.prod.outlook.com (2603:10b6:a03:1b4::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.15; Wed, 18 May
 2022 20:42:02 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::5811:4996:bbfd:3c53]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::5811:4996:bbfd:3c53%7]) with mapi id 15.20.5273.015; Wed, 18 May 2022
 20:42:02 +0000
Message-ID: <cfe6abea-8d00-8f8c-f84c-e6f27753b5d1@fb.com>
Date:   Wed, 18 May 2022 13:41:59 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.0
Subject: Re: [PATCH bpf v3 1/2] bpf_trace: check size for overflow in
 bpf_kprobe_multi_link_attach
Content-Language: en-US
To:     Eugene Syromiatnikov <esyr@redhat.com>
Cc:     Jiri Olsa <jolsa@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
References: <cover.1652876187.git.esyr@redhat.com>
 <39c4a91f2867684dc51c5395d26cb56ffe9d995d.1652876188.git.esyr@redhat.com>
 <412bf136-6a5b-f442-1e84-778697e2b694@fb.com>
 <20220518200010.GA29226@asgard.redhat.com>
From:   Yonghong Song <yhs@fb.com>
In-Reply-To: <20220518200010.GA29226@asgard.redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR03CA0032.namprd03.prod.outlook.com
 (2603:10b6:a02:a8::45) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a13f4880-7067-4c76-cbfb-08da390edcde
X-MS-TrafficTypeDiagnostic: BY5PR15MB3716:EE_
X-Microsoft-Antispam-PRVS: <BY5PR15MB3716B25E30C765F149D78760D3D19@BY5PR15MB3716.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Co7b8GuvY1gCn0d45nOFoB5qGSxiaW5rC8X23wBoi38eNbD8MPIfy2HWro8MbG4NA4dLazrVeiToEGa2io+pBhfPU1NN3MIXqOHyTgFf3PfyV3c5LLVT77uK3YqFPLy7OzLVNrGLk4xjztIybRcQ+/5XgKjqoz+MoaiUBOSJgdN7ndV4w2vi7R0xP8yiRixjYZQ97leOpWJm3zAxTuO0o8BuDdFidpIYiFZlWhjhW/WEDdGUz0NW009mPG5GZ2j3XjXONgLn+g4m9XQklzi/VsKLoUZ5zdmwqeQuHgM4DqAKOCh1r6e2BO9D6uPd+6Iurta7M7BNYq9+/wdNij5ig4sSe68h8N+zKJcuZ1SwiqcctXyY4UvXTV3mD7mj1Apb20BESrWc3ITI4PK+ZGPwB//E0LwSf+PX1X/SXv3/ZCdbZqjdNPu572ltVFPc9w07RBPo612p8gYhMepuGPMoXPlvGWUQRFAgG3MybVH6yE9TcYrd6vAOHy0NhUsFdjW56UCicuXlOqzC/csbQuh5iZsKSCDYhaDaVi98I6TkF4dQPOsEMo7UE8lG65+qsmlYWOBxOCPcV6lvWiDDFAKmOh+NYZiKzw1RC4NC6f0w0stOJS7yghuDTOyq6mD8zxAt6PapwTEWeUcgiv15hj0wUFzb3WCiRuUIDlyGQKU7llk8vZRL/SFLGDfDwPq/OBthJVTPnVOVp76tV4Qb7Gz3xneiGHyqh3Evsq2SmEFEu3z3f21yPHFuEcmv74+XUrj3
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(38100700002)(53546011)(6506007)(86362001)(6666004)(52116002)(2616005)(186003)(2906002)(66946007)(83380400001)(54906003)(31696002)(66556008)(66476007)(8676002)(4326008)(6916009)(36756003)(5660300002)(7416002)(8936002)(6512007)(31686004)(6486002)(316002)(508600001)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OFBwb0NOdXJSQ1hjcDNIcFp3MEdrbGlTK0NRM1VLZzZud0JCa0ZvV1RKckxO?=
 =?utf-8?B?cmZsU3BhNWQzeHk5dmlpNHBUL3U0M2hKTmttcWxLOHpybEgwaXJyMFB2aDFS?=
 =?utf-8?B?TVp0QXhYdGtyd1c2QllVMVorb1dTZHh2OVA5eUlNRE1Ub0pYeEdON3NuNDBP?=
 =?utf-8?B?M0hqUDdCbmt0aXhXMmNjcHFlZUhLQWs1OU9IUFUxNVZYN1lsSEMyaDFxeXJE?=
 =?utf-8?B?ZDcyeXNkbDczdEtwY2d4Vk9BemxSb2o0TVNNa0t1MFZQNUxzTXpHckRGYUw2?=
 =?utf-8?B?SjllTEtzOVNvMHdvUTUzYXRiQ2YwRkxrUkszTWpNMFdrYllKODhPcjFuUEFU?=
 =?utf-8?B?bjU5TnpiZjdvUTVWUnFhc0J2WnkwUG5TQjdENEpLQWcyT29DQVdDYS9lbFJu?=
 =?utf-8?B?Tzl4bmN6MVdVVUVwUjJ4bzN6ci96dXRCWmtGbENNaW80UUNTYjJuSzhOeUJU?=
 =?utf-8?B?NHlJckVOT0REazNYdEpxT1RFMUhSdTJvWGY1RytCMmdXWUZLSlhEb3B4eTdZ?=
 =?utf-8?B?aE9ybG04bUNJN3EwRWpDaEhrbWFJZVR4c1ZTQmtVRVZFK1RFcnFuR0dOK3Fr?=
 =?utf-8?B?UTdJc3BnV0Z5TzBIRVBzNWtkelFGU0RUUnJHSzhjUHFqWHBpRE51MzVVdWNo?=
 =?utf-8?B?NkZpa2JwSGEwcFMzRkRHY29WOXpmZE9QZjBua2ErNm14VVBQQ3RHQXloYklU?=
 =?utf-8?B?Z0hHSWhhVk00ZWVKZ0JHRlBiTnhjUjZ5VFBtRllZVnlBTDJjZTliRFpKcVhR?=
 =?utf-8?B?UmJWZ2trRnZkbExCNXQ2S242Y0VreWJGYnlOeFMwSWhObE1RZFRWcUc5U3V6?=
 =?utf-8?B?eXBTV1AyS2w1bk0zNEZheHhHbmx2bithT2JwUjI3OWpkRlNGaDVOUDQ1dVNv?=
 =?utf-8?B?aSs5REsxRThKUE9uYVdCclp5M2xERjVLaThzdUN4M1pRU1QrSGxsUWF4N01F?=
 =?utf-8?B?OHRyeGVCUHA5VFl0SUpYR3AzOW5veDRWT3FYbzc1RTUvdzY3OXFVMDNXZUtk?=
 =?utf-8?B?L2VvNmIzSUxmWHF4bEJWckd1SExEMVF4TVZNeXJQM1pweG55YllhRzYvZk1F?=
 =?utf-8?B?YXUzQjdYSW1OSW5hS3hHN2EwQWxBVjdMSTJzLy9WTVNoa2wwUjlHckVTaFhy?=
 =?utf-8?B?NXgzZjFJSWZzSFZVL2ZhVVkxQ3AwNk1rdEJraEdiSnNBNy90RS9XVXdEbFM4?=
 =?utf-8?B?dnVJc1ArQUJoRTA2bnpGUWNkUGxReFpzOGVBS0xMdkl0U2JEY1N4Vk5walBa?=
 =?utf-8?B?c0ZwWmwvQVByK1Q0N1ZmR1E3Mmlka3JRZmdsOWhrYTVxSEdsamFTWC92T1dj?=
 =?utf-8?B?RVBlb0E1eTlQajRqYkI5UW1INzh4eXUvYkxNMjIvWnpWblpweFJpaFFNd2xp?=
 =?utf-8?B?YzhzUnlrVVVDbFZPWjg5L1c1TDJYMmVESnF0ZGE1SXBscVJGSWJBa1ZVSHdM?=
 =?utf-8?B?OVgwWjdvaGRBcUgzV0VQS1lEWVQ1UUdUdm5uWVVoZHlUZ2hBcTgzdFg0Nkdk?=
 =?utf-8?B?VmpwZFJBaXFnbEVNWFFMRktXdkJJWmh0Tkp0Y1JFUTFIVHdQT09KN1IxeGlW?=
 =?utf-8?B?Wis4R3g0c0F0MHByNVhVdVVuWXAyNlN1QnZYNng0TlB3Rzl0V0ZGdFYrOGlB?=
 =?utf-8?B?bWlDcFlYSnpWODZtQ2pSenA3L3AxVUxNVHJ1VjdzSmRtREMxY0NOQjJFLzMv?=
 =?utf-8?B?cUdnQTdLRzgwZjdwM0pMZ21HVFU3WVhmM1E4a0hZWlNaWXJwd1lpdmpiaTVo?=
 =?utf-8?B?cVV0QzlSTkdObEZHRE52ZEN3b0laOWFsUlM0a2M0MDcwWWZyVFJjcWsvOFQ3?=
 =?utf-8?B?Q1FnaHp6WHcvemwyRVJXbGNyZ0xzRXNFcU01b00wYlRObFRubVFzVTNFRDZa?=
 =?utf-8?B?TjFzalBjcmFrT2Z4RVBhN2xQa1dhYWxOU3EyaHBsakYwYjN1V2h1bVp0ZS9K?=
 =?utf-8?B?c2RQbmJMdUhmOVMwSTBMYlhURWVmcmFnVm05aHl1UFIxdkdOTjlVRnl1NHBj?=
 =?utf-8?B?aDNIYURLMmdBVXdnVStwZGVQU1QzMFdHTUphRldkWTdhaElNSVNIY3dWN0FW?=
 =?utf-8?B?NGxEdDEzRm5VZkVVWHRrQlMyVm16emgvMldXbnJodWJXdTVXYmM5ZUo1cTFL?=
 =?utf-8?B?REpLTUZnN1drTEJXR3A2Q0I3M1hVUWQyU292L3MyNnNBekZUQjBqM0ZvSno3?=
 =?utf-8?B?MXhyRWlXcjZaem16dTJWdHBlVHArR3Q5WmJ0VGxFZzY5dG13Q3ZlNC96UkZk?=
 =?utf-8?B?dE01cG9mYjU4QTlHL2hCYUpQZ0N0U2V3L3VyemdRWVBZaEhERGhmMXBKZC9P?=
 =?utf-8?B?NHIrNTdGNHVqT0Uzb1lVVDZNdCttNmdoQXlTNnFXWU1pd3BzenlKWXllWjJO?=
 =?utf-8?Q?sRlL/3rONCmbd30A=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a13f4880-7067-4c76-cbfb-08da390edcde
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2022 20:42:02.5979
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: i2Qon/rFqfkPv1cL2vPrWeuFRLlUOIB8RHnQd7YaM0GhoDA/eyVnAMq1ncxBnTnn
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR15MB3716
X-Proofpoint-GUID: hlJCNmH0NPI8ZeRgDnCEGPez6cO-PIAV
X-Proofpoint-ORIG-GUID: hlJCNmH0NPI8ZeRgDnCEGPez6cO-PIAV
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-18_06,2022-05-17_02,2022-02-23_01
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/18/22 1:00 PM, Eugene Syromiatnikov wrote:
> On Wed, May 18, 2022 at 09:34:22AM -0700, Yonghong Song wrote:
>> On 5/18/22 5:22 AM, Eugene Syromiatnikov wrote:
>>> -	size = cnt * sizeof(*syms);
>>> +	if (check_mul_overflow(cnt, (u32)sizeof(*syms), &size))
>>> +		return -EOVERFLOW;
>>
>> In mm/util.c kvmalloc_node(), we have
>>
>>          /* Don't even allow crazy sizes */
>>          if (unlikely(size > INT_MAX)) {
>>                  WARN_ON_ONCE(!(flags & __GFP_NOWARN));
>>                  return NULL;
>>          }
>>
>> Basically the maximum size to be allocated in INT_MAX.
>>
>> Here, we have 'size' as u32, which means if the size is 0xffff0000,
>> the check_mul_overflow will return false (no overflow) but
>> kvzalloc will still have a warning.
>>
>> I think we should change the type of 'size' to be 'int' which
>> should catch the above case and be consistent with
>> what kvmalloc_node() intends to warn.
> 
> Huh, it's a bitmore complicated as check_mul_overflow requires types to
> match; what do you think about
> 
> +	if (check_mul_overflow(cnt, (u32)sizeof(*syms), &size) || size > INT_MAX)
> 
> ?

This works for me.

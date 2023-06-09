Return-Path: <netdev+bounces-9431-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6C49E728EEE
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 06:30:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6A8581C21051
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 04:30:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C1D5EED8;
	Fri,  9 Jun 2023 04:30:11 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A44E5A92E;
	Fri,  9 Jun 2023 04:30:11 +0000 (UTC)
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 065DB30C1;
	Thu,  8 Jun 2023 21:30:10 -0700 (PDT)
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3592HDck031344;
	Thu, 8 Jun 2023 21:29:24 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=s2048-2021-q4;
 bh=Vt7kyDgJX1zPXAy3RccHC/D8aLZm4ZPCapeFdKXaMys=;
 b=MuCQNSmfsJvQILUO5FGsOuEVYRSDk2iCNktQ+0vhH8UTMcWiEHZWpq6xmXhp6jmgRZJc
 c+DZVXcnwdEiCLrCZAg0ClPz2y/Goc6cZShwYYDQLKDGzDd8Id+d0vkA1rrrsEWeQdJW
 PNOhb/LcHmUh+0N3/xkhn5M2OI8b6NEn9X9VG1tX3lhu/zj+ENuot+Ldno1llxFC7GAj
 d7Aow7Xegxdtr/raDgdGgsFfxhXyrMG0inydOGqcCn03b7j7REXyevGDHVoM6LmpNWYU
 Yb7hus8k4dnjQNVQWO1IdWJkIJqks3VcKTkqJFb1EoGO+LWjJn/AmdpOFSj9hMUbCkim VQ== 
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2176.outbound.protection.outlook.com [104.47.55.176])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3r3cynewum-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 08 Jun 2023 21:29:24 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HYchyGvmfcEH3a4gb8y/I2YYF249K/6MqnUyT6+0ZSK0NulsFEM/NfaQApfk65ZbRnEUcAVaKYALQPn2eVdwqDJE0t53p0z1dVhYNFDA3b+iDtRimh9gvTu0qN5CxqMpNVi7B+2LFgLcsEeYFIibJSdGk6tZe/7vA7UYWyBCXW5GVSBGMieH5/DU1FjEEJTBaTXGbvzroH/Uzh87DZQVxhhGVu0fzEdBEJSY6oaWFd3x0ptdWKjgNlW5u4XnFUt37Bx+i/H+aTx6J/aT64uF/byZUbkdYuJ8t/1/nZqh06630dSdoZ3sLC5VApexxQetD3Dl7QRHFsn/WOqa4g4yAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Vt7kyDgJX1zPXAy3RccHC/D8aLZm4ZPCapeFdKXaMys=;
 b=nwZYTHnikHltIYP+wlEvUZmPKNm3oTsXI32iF1afNlkNRGEv69Wu/9tSV3IJNOe2Ji63rfoe5UYU91vOke3SDHiPvMNQmyaqs6qkRY1PohMbXXGdHgCxr6WKa6Nmvj87cFTIF6R+kyM2bausvraP9UjzDuG0GnFQPaHuoz2NBt6xUw3Did1FBvafj9UMW1cHlZRSBYcKPEjO6NoEUvp9rbqefQYiwyzrHprnKwXp6LGuqgF5B+s1frXFMz/yt9HylfUio0DJsoGBQ/zKPtCAQ8E/b0mtcn0cpaF5s3gCEQqa2HUopoOvWFUsAAx9utZVjabm3b7whCxlXmdKtl1XzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by CY8PR15MB5604.namprd15.prod.outlook.com (2603:10b6:930:9c::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33; Fri, 9 Jun
 2023 04:29:21 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::bf7d:a453:b8d9:cf0]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::bf7d:a453:b8d9:cf0%6]) with mapi id 15.20.6455.030; Fri, 9 Jun 2023
 04:29:21 +0000
Message-ID: <38957384-2129-4440-5e82-37f8afcf23c3@meta.com>
Date: Thu, 8 Jun 2023 21:29:17 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.11.2
Subject: Re: [PATCH bpf-next v3 1/3] bpf, x86: allow function arguments up to
 12 for TRACING
Content-Language: en-US
To: Menglong Dong <menglong8.dong@gmail.com>
Cc: alexei.starovoitov@gmail.com, davem@davemloft.net, dsahern@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        martin.lau@linux.dev, song@kernel.org, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com,
        x86@kernel.org, imagedong@tencent.com, benbjiang@tencent.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
References: <20230607125911.145345-1-imagedong@tencent.com>
 <20230607125911.145345-2-imagedong@tencent.com>
 <4ca27e23-b027-0e39-495b-2ba3376342cc@meta.com>
 <CADxym3a=_FF3NUG3-210GQN0JSvbcsGdYRiVwBEQzGTtqN3kVQ@mail.gmail.com>
From: Yonghong Song <yhs@meta.com>
In-Reply-To: <CADxym3a=_FF3NUG3-210GQN0JSvbcsGdYRiVwBEQzGTtqN3kVQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BYAPR08CA0003.namprd08.prod.outlook.com
 (2603:10b6:a03:100::16) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR1501MB2064:EE_|CY8PR15MB5604:EE_
X-MS-Office365-Filtering-Correlation-Id: a5ca161a-1eac-4fae-e81d-08db68a218cb
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	kqUuRGuYRK9CD9IHKG2ZrFVJhGJsArdRDgjbY3y4B4tbTWeJ0u8GjOllfJI4Qo3Sqq0H/4g+bGiSFttn1XBFh2YWLN5Hf7KkmB2JMeO/ygIILpO57Ji93RAsOpgTDF0AIjU76yjIMZ20A6MD29pOKwvABaSySqAIF5NgxdQraUXDGjmmotkq5SOwpSojcXyBWeDL7YMnmOBHIbN09bQh1w9JpPajXXZ1YcBaPdbvEAwQcsgT9wDT/dO+j8LYVZJE1dZHXLo18aFjJb12hGYTnc4IePnBrx8MzukY+lDUTBbNH8ecXWcsQsxu8CoSHk3ziLOyuCfem872dWrwMMi2IbBQkcgQ2Lo84GLzOOidT6q1gwYIQnaXAD1FtEeYbmi1ay02l/yxf/nIU4DPAQGGI5A8qlehgv+kJJ7lQVn3YEdY8hY6c9+pWLmiDqMfG+SQYfYDUFJoD7/y9PGUNRu/QdDzu6xSLYLOsIVJ9WykEvlSKcr0+lLKV8FIn3wREv89SovxnmyL4hCYPLD6CKHbnwX+yZR5YHEtzrbe1K6IbBbROMuN3+bBgdFD95aRjT+HAYZcbnxoAvhs3M8livvK2ABOXoKJR1Fz55Ai8/NMTkg+X9IUZlucGWyK5XgM1l/4zh37yFJAkVg/xG76icNnaw==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(376002)(39860400002)(366004)(136003)(346002)(451199021)(2616005)(6512007)(53546011)(38100700002)(6506007)(41300700001)(31686004)(6486002)(6666004)(83380400001)(186003)(478600001)(4326008)(316002)(66946007)(8676002)(66556008)(7416002)(66476007)(6916009)(8936002)(2906002)(5660300002)(31696002)(86362001)(36756003)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?RHVnV0QxQWxOZzZSVjcxdlR2K3BZM282VUljTjVib2dLZWI2UC9MZm1nQnV5?=
 =?utf-8?B?bE9UZmFROVdaRDlhUTJuci9ybC9wVmpuSk16QzMrTTg4aUpSUHVBZ2t4ZFEw?=
 =?utf-8?B?TTdqYk1MS0x3U1dEQjFxRWxYakxPYTE3V2tJdjM4dnV6NEFHZXJ5OTVQVFIw?=
 =?utf-8?B?aDZOa1Fqd09HbkE3N0E1QWFNS2c5eG5rUTBieG5sNjdSSUpYT1pVeFBEOVFm?=
 =?utf-8?B?MUY0M0VBVW1oaUNMVnM0ci82akN6bllOeklsUUx4L0ZLUmVJRTVGdFk2TlV3?=
 =?utf-8?B?eHFyc2lFVXU0QVVkQmtCMW1RdmRDMkE0Qmtabkl5aDBjcXhVeTBPS2VVRTRu?=
 =?utf-8?B?TXN6ZjNsZllNRXUxZEdDSklndEU0UnZ1RDdyZ2VMcVBWdDZRRmNlQW9Yc25F?=
 =?utf-8?B?VUdua2hpVDd5V2JXMmZGeWwyRk14Snc1akJtd2VwbVBiZXJPenBDVW1tYVNi?=
 =?utf-8?B?ajIrUFV1T3RoWUpoU3BoWis5OWVIQ1BBZm8reDJtcEVqeXY4NkU2QmtTNHgy?=
 =?utf-8?B?b3VTWFZ0VXA2ZGUxd0FjWm5UZFFEV2NsRlc2VDFXTVVmTTF2dm10WHFuakZy?=
 =?utf-8?B?UTI1bzJrTm5YU2FJS1V0OWxKQWhOYk8zbHI4aHZvYnFzbFg3V3FRVUNsVjRj?=
 =?utf-8?B?ajliS1dTRjNuc0ZZdFlzQzQ5ZnRENVZFZUtSRVdnK3U1cjFjNktxUTR5b05D?=
 =?utf-8?B?Mms3Tlp4dXVyb2YvRW1ka01WT1JqMWFPaGZIMk1uRS9uMENsODJjaWpPbmNr?=
 =?utf-8?B?L2orVldVSGZoZld1eXFKTHViMDZpdjZBVnlhRlJ3WFdENlFDUjZ0VHZnckN5?=
 =?utf-8?B?WkUrK1ZJQjlOTUpLOFJ1N2tPZEpEeG1EQ1A3REwvaFk1RU9KRG5mYU9xbXRB?=
 =?utf-8?B?VEFWYW1ialNUTkxNd1c1b1J6bGJlU3dPOW9nS1EzeUh1cVp6V1lGZ1pzWnRi?=
 =?utf-8?B?OFF0K1M5MkNlOEF2cmROOStZMDhCd09NaG9mNWNjYnB0YThFNzgzazlnRFRp?=
 =?utf-8?B?Skc2UTJDU1hEL3JvZ0J2aE9vQlBZbC95M2MrenQvaEVBTUxTQnJuYVpJdnRE?=
 =?utf-8?B?Ym54c3ZnS042U2MvRDRIQVI5NHFSWFBtZVlrNUdJRWx4SXZYMllYR3RVd0RU?=
 =?utf-8?B?R2lta3ZCazdncG9KQnRqNFFBVmN0VTBSN1NCN0EyVlU3VW9yZWNpbGcrVFZn?=
 =?utf-8?B?UmdtS2Fqdm01aWFNY05QZjFvblFwMnBkYXdUK2dWYVllVHFyTmdDZjBzR3BO?=
 =?utf-8?B?K0VmdkwvZXB0ZXh4UXF3YUlYVk5mK0ZSUWNuT05sVWo5Q0RML3k1MEw4V2tj?=
 =?utf-8?B?K1BmQlcxS1lOMWxGTDZkZzNWYjIxUjhPbTkvSHhYY2xnSFArRnAvaUR5VEYx?=
 =?utf-8?B?Zng0a3dtTmhLN204TXJ0dU9wdU52eTlXOHFacUVBbVRTZ2hwSGVmS1NoNXJJ?=
 =?utf-8?B?OGNLdEVRNFMzcjdQaUdsT0FiS01TSk54OFRhQzhPaFM1T05uaDJhc2dHR0N1?=
 =?utf-8?B?ZHJtczdXL3M1MnR3K0xKelBmbjZ3cmtNa2JkLytZbGtVWXFyRVlGYjFYdklZ?=
 =?utf-8?B?cWxWVkN2NDBoUW03TGpwNXluMXQvWnFTRmRtb0FTc2d4QUo4Z2t3OHEzaDRp?=
 =?utf-8?B?L0tOV2tQNnAxY0g2eGNFSHlDb0pwUWxacnRNNG1oL0V5dTUwZUJ5bVFQcllB?=
 =?utf-8?B?SjZIaHFJVG1UWlVrRnk0ZWh1VlpXcDNocnRSZVB6b0hSbzd4a3lNaEFJaFh3?=
 =?utf-8?B?WUlMVmt0SDJ0aE9tTk9oVngzVkRlZEROQ0NmQXkwK1lUalpuaGwvbFM0OERC?=
 =?utf-8?B?M3FhbzFmV28wUlcrbU9vR1l0cHF2VkVGaWxDUHZNdCtYMC9ucnJwYXZiUGwr?=
 =?utf-8?B?eHRVRHV4dlJRMnBZSXZHQjExNEU0dkVIVHBqT3AzcE4rM3E3ZXltVktTR3dF?=
 =?utf-8?B?R2VieWdTL2E3T2RreVB2WXNiM2hlZnp0cHROTTBnUnpxekpqQlBMQ0N6WGdl?=
 =?utf-8?B?K0R4SjNtN1BYUU1SYVViRVA2bHFnTXF4VHhRV1Nud2N0NUZLY3h3aE1xTXVs?=
 =?utf-8?B?d0lVbXIzM2RJL08wK0U1NlhRN05zSGhENUNxYWZUbkJDL05oZHgwVVNvbVJB?=
 =?utf-8?B?dzdVNC9rMDFsOHVRRWErMWFNbUpkMEl6OVZ0R1NiS291RjFvSlhWZHNyZ2R3?=
 =?utf-8?B?akE9PQ==?=
X-OriginatorOrg: meta.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a5ca161a-1eac-4fae-e81d-08db68a218cb
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2023 04:29:21.4592
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KKHMukAUjBgexhoKfUvooKCOijLQJEv37T/SnoX96CkZI+AaUAH9bxjHGP79jK4S
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR15MB5604
X-Proofpoint-GUID: puWXXHbHXaAZpCd6P7ICHNK7vl3bjClX
X-Proofpoint-ORIG-GUID: puWXXHbHXaAZpCd6P7ICHNK7vl3bjClX
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-09_02,2023-06-08_01,2023-05-22_02
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
	RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



On 6/8/23 7:12 PM, Menglong Dong wrote:
> On Fri, Jun 9, 2023 at 5:07 AM Yonghong Song <yhs@meta.com> wrote:
>>
>>
>>
>> On 6/7/23 5:59 AM, menglong8.dong@gmail.com wrote:
>>> From: Menglong Dong <imagedong@tencent.com>
>>>
>>> For now, the BPF program of type BPF_PROG_TYPE_TRACING can only be used
>>> on the kernel functions whose arguments count less than 6. This is not
>>> friendly at all, as too many functions have arguments count more than 6.
>>
>> Since you already have some statistics, maybe listed in the commit message.
>>
>>>
>>> Therefore, let's enhance it by increasing the function arguments count
>>> allowed in arch_prepare_bpf_trampoline(), for now, only x86_64.
>>>
>>> For the case that we don't need to call origin function, which means
>>> without BPF_TRAMP_F_CALL_ORIG, we need only copy the function arguments
>>> that stored in the frame of the caller to current frame. The arguments
>>> of arg6-argN are stored in "$rbp + 0x18", we need copy them to
>>> "$rbp - regs_off + (6 * 8)".
>>
>> Maybe I missed something, could you explain why it is '$rbp + 0x18'?
>>
>> In the current upstream code, we have
>>
>>           /* Generated trampoline stack layout:
>>            *
>>            * RBP + 8         [ return address  ]
>>            * RBP + 0         [ RBP             ]
>>            *
>>            * RBP - 8         [ return value    ]  BPF_TRAMP_F_CALL_ORIG or
>>            *
>> BPF_TRAMP_F_RET_FENTRY_RET flags
>>            *
>>            *                 [ reg_argN        ]  always
>>            *                 [ ...             ]
>>            * RBP - regs_off  [ reg_arg1        ]  program's ctx pointer
>>            *
>>            * RBP - nregs_off [ regs count      ]  always
>>            *
>>            * RBP - ip_off    [ traced function ]  BPF_TRAMP_F_IP_ARG flag
>>            *
>>            * RBP - run_ctx_off [ bpf_tramp_run_ctx ]
>>            */
>>
>> Next on-stack argument will be RBP + 16, right?
>>
> 
> Sorry for the confusing, it seems there should be
> some comments here.
> 
> It's not the next on-stack argument, but the next next on-stack
> argument. The call chain is:
> 
> caller -> origin call -> trampoline
> 
> So, we have to skip the "RIP" in the stack frame of "origin call",
> which means RBP + 16 + 8. To be clear, there are only 8-byte
> in the stack frame of "origin call".

Thanks. It does make sense now. So we have
   caller -> origin call -> (5 nops changed to a call) -> trampoline
          8 bytes                                    8 bytes
and inside trampoline we have 8 bytes in stack with 'push rbp'.
Yes, it would be great there is an explanation in the code.

> 
> Thanks!
> Menglong Dong
> 
> 
>>>
>>> For the case with BPF_TRAMP_F_CALL_ORIG, we need prepare the arguments
>>> in stack before call origin function, which means we need alloc extra
>>> "8 * (arg_count - 6)" memory in the top of the stack. Note, there should
>>> not be any data be pushed to the stack before call the origin function.
>>> Then, we have to store rbx with 'mov' instead of 'push'.
>>>
>>> We use EMIT3_off32() or EMIT4() for "lea" and "sub". The range of the
>>> imm in "lea" and "sub" is [-128, 127] if EMIT4() is used. Therefore,
>>> we use EMIT3_off32() instead if the imm out of the range.
>>>
>>> It works well for the FENTRY and FEXIT, I'm not sure if there are other
>>> complicated cases.
>>
>> MODIFY_RETURN is also impacted by this patch.
>>
>>>
>>> Reviewed-by: Jiang Biao <benbjiang@tencent.com>
>>> Signed-off-by: Menglong Dong <imagedong@tencent.com>
>> [...]


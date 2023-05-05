Return-Path: <netdev+bounces-601-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CB3736F86CF
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 18:34:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 917151C2193A
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 16:34:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ABBA1BE7D;
	Fri,  5 May 2023 16:34:46 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90A252F33;
	Fri,  5 May 2023 16:34:46 +0000 (UTC)
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33E88A255;
	Fri,  5 May 2023 09:34:45 -0700 (PDT)
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
	by m0001303.ppops.net (8.17.1.19/8.17.1.19) with ESMTP id 3458cLWC027303;
	Fri, 5 May 2023 09:34:28 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=s2048-2021-q4;
 bh=WBRGvmXE1RqQviQBvbhPAR67YkOfkum+vvSDpk1xvao=;
 b=OtJ9zytIPm75828nQ9m9x1YmmTNhtSOA/WJPq6CePb/NY4UU7rETYRBMBFbBvHrbRRbW
 1W1krrOD207tQIT/Zd3SOd7WDbxuEH0m5gliyiZHoFpm6uQ8R3ezaGUqq9FP5BtDFFhS
 DEmPvTJDP1NO9tlTnfqcztB7DabFu70xbHtFAlOBoi08BejjnWQKXEJul1eHaO/jY18a
 wqGmmLEP1loUUmEXxbvpyo5XF6zZfncO0Q0Txyau6JkodSHlmeWoPjiXZy2ykqjXMT2z
 ECxpRWgPeXqXJ379PGcdR3aKjgfy5ZOKm7NhgboGyNdCx5CKHl495qVC9EQmFLjClAqb bA== 
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2042.outbound.protection.outlook.com [104.47.73.42])
	by m0001303.ppops.net (PPS) with ESMTPS id 3qck50xs47-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 05 May 2023 09:34:28 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XOQkxo8ItE/M/Na5rTxTixElGvbc32dpkGX3DvNCETU+dSSun/FYGywJMwWaZ1Stia3J2HGkLk4k9fUtgBfp8IeHFx0F32BBm4ZP7jO3mrNLM8UMcf2r/h5mk/9FdMIGqy/IV+RUHVZuxyGhHiktp/cMBKGc9KJ+ec2lcPouUaGmvv4Bu+bcGn6EGNzmXwz7NLkEiEmJNkLNpcZY3DZzIsG8Pw9a53rR3bsQD+ggVMUfX290j/2icU2ynF3LDdyA5WcKHkt/ECD7bWUM6LQr9YekiygdPSO+lHu19A9Tm8+vIXUewUbYByP7AC+tOzKnjpxiDzCSt72FKxXzDwjrzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WBRGvmXE1RqQviQBvbhPAR67YkOfkum+vvSDpk1xvao=;
 b=iuE92N5yvF+eWSUVnK1At0JwIrYemdh3+E602ro/T88+kZPJ12G1Ow/3hpk7sO8bkss8cVMU0Y7gugc4VPgQfApS2I+/wPbtsfiJz8e6zVVFPSXho+dKliw3UTrI5s2fNR6ow5a4s4FAySqbI6cyyiddXdjpWhbNVDM0itmxOfvI01wMz6u1bI+EW0WCxpF/lWKVA4rDiWs9CPzRvPO6rF4P8gGNUmbAG15v7G8KSPFyXByQgaNyu0eE+pnwQa3NOeke/I2IEqfNUxEU1dYZWCDiPikIhn48gEaW2jwxgw89eXkOw74nunE2O6MA0tKoZRwRE4rGj/NyNENBL+2Ifw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SA3PR15MB5702.namprd15.prod.outlook.com (2603:10b6:806:31b::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.26; Fri, 5 May
 2023 16:34:24 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::589f:9230:518:7f53]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::589f:9230:518:7f53%6]) with mapi id 15.20.6363.027; Fri, 5 May 2023
 16:34:23 +0000
Message-ID: <d94da8f2-79a8-3797-4425-98015b2a0993@meta.com>
Date: Fri, 5 May 2023 09:34:21 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.10.1
Subject: Re: [PATCH] bpf: Fix mask generation for 32-bit narrow loads of
 64-bit fields
Content-Language: en-US
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: Will Deacon <will@kernel.org>, bpf <bpf@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Krzesimir Nowak <krzesimir@kinvolk.io>, Yonghong Song <yhs@fb.com>,
        Andrey Ignatov <rdna@fb.com>
References: <20230502165754.16728-1-will@kernel.org>
 <2cb24299-5322-6482-024a-427024f03b7d@meta.com>
 <CAADnVQ+m_jJHTpYDvOuD1LOvgKgGPD5VHfUobMa3NF+uyu7Sbg@mail.gmail.com>
From: Yonghong Song <yhs@meta.com>
In-Reply-To: <CAADnVQ+m_jJHTpYDvOuD1LOvgKgGPD5VHfUobMa3NF+uyu7Sbg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PH8PR02CA0018.namprd02.prod.outlook.com
 (2603:10b6:510:2d0::8) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR1501MB2064:EE_|SA3PR15MB5702:EE_
X-MS-Office365-Filtering-Correlation-Id: 153537f4-4b02-4957-b5ff-08db4d8695c4
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	Wft3m7Hl+tM2bm1JJbdXzMVzSFf6bdLNDAXB2whpUAuy/gdIP0k+zP+hn7sBpspISaFt+pN1xf23IBNDoPCEbVPyMRxfd9sEn47IMDBqgVbVSVQG3fqPMMjQ4GXE2hdicd4sMHmd0r13U26zTzzr19tPocUh/rM0A07bsHKxZTLLVV+8PEehUCUR5NTNuHKagZbkytXrCqWyDBFkGGikzCMLLpJhkY90ZZYBKJnWEjNtleMikB6qT2EhYfzjFy8uxylPITsABpLFBVkqYLwSmVgRXyNwg/QOxmfLUdqupUAYXp5JUXUpJeSyy7UcMgIHfcfBiinMtzT1D2Iq/RG2VNIFDuUMZGTO9xwjxybqJUO4GbS1QryY4pg4bKU99LYK4bbMBltrpZSU9pdx8pxloo1OmhZubpO0gVB53FKMlXr19WVkFJhS0rX1jz0sGi/Dj5xK1V8deM/NNL51/swKwSKrKYLJYMsh3FCCPthhfGhRnlFb4NogtAzeANkRp6pn5z72la9KJKBdYrxh8abX643OFRhvwQ/fZ8o1ifphokBEMCJljzKHleSLUNCbgwuLQjMcNjYMNMYori0XYprNnucoKn/il+6FnFpeOrThkRaQ2hqqXqygfpN1M2sALHxcCNPOGnOSV+EpHz+p/C+rNA==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(136003)(376002)(39860400002)(366004)(396003)(451199021)(5660300002)(8676002)(8936002)(316002)(4326008)(31696002)(6916009)(36756003)(6486002)(41300700001)(86362001)(66556008)(66946007)(66476007)(478600001)(38100700002)(31686004)(2906002)(54906003)(53546011)(2616005)(6506007)(6512007)(83380400001)(186003)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?bVRuU3pXRWhpS0lOMmxsdEhBaXNRR1kxd2tqNmJaK3lIMitNdDZ0amZWazhK?=
 =?utf-8?B?dEc0MGsyOGc2dUdDSk01cDAxRjRIWVpUdzJuaHZmR2U1YnE2SE8vSGdsZEJ5?=
 =?utf-8?B?cnZGZWd2bkk4Ni9BMGR0clZ1L01KSFlsbldyaGpia0VpVzRxV245ZTAzR25H?=
 =?utf-8?B?MndMem91TU1DZWQ4ejNsUXZnM1YzaXk1eXBUYkFTeEg5cFlMeVdGb01YRXUy?=
 =?utf-8?B?S05RY29vNmxJZGhobFAzTldNOXdaMTNOVGRsU1d5cjdrbmcwT0c1YWF0ZkhM?=
 =?utf-8?B?L2ZKNmg2THpGdzBXbHJINkhnRHRHS2NnMVREODY1ZFYxaC83b2tJNkRrMzJC?=
 =?utf-8?B?WTVNU1BNcXNhREtXVVpIcng0VWRMZkFFS1Y1ejhaTU5aNlovRjVjWXpHMkRm?=
 =?utf-8?B?WTZpUHZmYzh6S2VWSi90ZWpnY2xUWE1MR3JZRU4yNm10d1VvVGg2alRTRGs1?=
 =?utf-8?B?dmhGSVJMMHhHcHlwWVlIaDV3WlJEY0xkemMybXBLcFZVY3NmUXZlM2NEVm1G?=
 =?utf-8?B?Nlg2RzNRbmhML1N5RldvbCs5V0ZjRVI3enBlR3p1YVJIeFZlOFNpVnBsQ24y?=
 =?utf-8?B?anp1anRJcDY4WmR3eDRxV2ZFLzVqczZ2Y0xTMndHeVVXZ2l0ZGdtMnBYVmRM?=
 =?utf-8?B?VjZWVE5vRi9NRENzNlRNbEFQMzlhemVaWitJZWpGMHRXZmtzR3pwZ1JWQ0Ux?=
 =?utf-8?B?aDRpY0pUOGdpMFdnRk5XWmQwNllxUTdUeFJ1TDVjRnYycmVoOVVGYUlWMVls?=
 =?utf-8?B?dm42WlFOaGJQdUwway8vanhCQjlhZ1JZY1RacWpHNVBlVS8rWlFXeE4ydWE3?=
 =?utf-8?B?Q0ltMUxKNDUxakYwaC9NZitrV2RPc2loQ3dmMGZBOXNTSk1GM3NEOVZ0SmVN?=
 =?utf-8?B?cmJwYkF0bWpwUk5FeFhIVTdRRmhGd2Z0T2N1NFllUjVTYzRDaTUyQU5RUzha?=
 =?utf-8?B?VmxjdGZsQ2hXMERGN1NTWXM4UUFSbVVQS29RTGc0anhaRVRXZCtOMGsvT2FP?=
 =?utf-8?B?QnpuTTFwaEFaNDAycnh3dlArNVRMMGNUcTA3SDRxUGNQOTVaZDVMRFNHc0My?=
 =?utf-8?B?NVZlUVFFcFpsdTA3RFM0MTFqWngxaG1MV0wzcElsWHU4ank4Sjd3T1VPZW1p?=
 =?utf-8?B?Uzd1TnAxMDMrUWVLWWs2bjJ0d0t0NjJwZFIzRllkOXh1TVd4ZDBmVEw3L2xW?=
 =?utf-8?B?djAzNmtKZ3ZlbkhGVm5NeFJSNjBSZGZzaVlQK3ZuNEs2UmRKOUdaOUpCbW50?=
 =?utf-8?B?NFlhSFZwYnU4VEpXSXNOK1VxT0RQVmhOVHdsZlhTVTBlUEtyaE95U1RoTUwz?=
 =?utf-8?B?bjRXTWE0RFpMWmgyeWxHeFdRdGJzZXphbzluenRUdC9IMDBUZktlTURUWjIv?=
 =?utf-8?B?cG1aL2NSYUREa2FxQ2NxVHB0bU9KekJlRXVpRjU4RU1DbmFDT2RGOHBQM3Rk?=
 =?utf-8?B?MmUra0t0ZXNUUDFFN2pFaVAzOGJCaUpkaXJFUzF0M1RtL0xmTDdsa3ZEL25B?=
 =?utf-8?B?ZlhJNjlFcGFUZitudGxhSE1acXhTaG1uOGZoOE9lVkM0NUV3OXVKUWowR1Mx?=
 =?utf-8?B?R08yRktWM0JLRjVvUlJVZDB3TjFES1FCNnFZSVhxcjdmR3JBNUpBLzBJZFdx?=
 =?utf-8?B?T1dqMGVacEYyWlh4RlhDTk1HR21PUzBFUDZxcjVLelZmdVRkVWVPeWcrdVNZ?=
 =?utf-8?B?T3hiWW92MFpnZk9ua3J6K3g4ZTZPN1R1TFp6Z2RPSkUrUEZqNDJSTmQ3RXh6?=
 =?utf-8?B?eVpnYkkrWUx5VFVpYzdUekdHTVRETDJLTnR2QVU0QnhzWHRzUkxjSlpYcVpk?=
 =?utf-8?B?SnVUei9WdGxuM0k3VW1DQnpNME1YRi9wTDJXTlp6Vm9sVXdZTk1LczR4RENx?=
 =?utf-8?B?Z09qZGhxb0szYXFJMnBRc0xqb0h2cEh2RVlRTGNCZGN2cWxWN3hFUWNmOE9B?=
 =?utf-8?B?STkzbSt3WTFiYWJOOHJCSHJEMWZ6OWFUM1VNblpsbGNIeGpCa0J2aHZzeTNp?=
 =?utf-8?B?QXBxeG1QMFl4L3pCVnVwNFRTSnAzU2tQejdpbGVjRFRGQ3J0aE1hM2NobTVl?=
 =?utf-8?B?aGVnRHhNb1Vocy90bXg4UjJIWWlkTGtZQ1pmNmRRSFNUczVFdkVsVm9UbFZL?=
 =?utf-8?B?cnVQN2pzMGFQcXE3anR3M1FOaVZTcHBjQk1Za1BxejJEWFRVbnRDS1pHTisx?=
 =?utf-8?B?TFE9PQ==?=
X-OriginatorOrg: meta.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 153537f4-4b02-4957-b5ff-08db4d8695c4
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 May 2023 16:34:23.8149
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qYJgifEEd2fHzvhT2TWffJb6XKif8dVTI3AB6Or5pvdQh7ZGIl5CHTyPG619vUK0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR15MB5702
X-Proofpoint-ORIG-GUID: tQF4Hvehk78NiRdgylcUfa1woX16TVhR
X-Proofpoint-GUID: tQF4Hvehk78NiRdgylcUfa1woX16TVhR
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-05_23,2023-05-05_01,2023-02-09_01
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
	RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



On 5/5/23 8:30 AM, Alexei Starovoitov wrote:
> On Thu, May 4, 2023 at 1:18 PM Yonghong Song <yhs@meta.com> wrote:
>>
>>
>>
>> On 5/2/23 9:57 AM, Will Deacon wrote:
>>> A narrow load from a 64-bit context field results in a 64-bit load
>>> followed potentially by a 64-bit right-shift and then a bitwise AND
>>> operation to extract the relevant data.
>>>
>>> In the case of a 32-bit access, an immediate mask of 0xffffffff is used
>>> to construct a 64-bit BPP_AND operation which then sign-extends the mask
>>> value and effectively acts as a glorified no-op.
>>>
>>> Fix the mask generation so that narrow loads always perform a 32-bit AND
>>> operation.
>>>
>>> Cc: Alexei Starovoitov <ast@kernel.org>
>>> Cc: Daniel Borkmann <daniel@iogearbox.net>
>>> Cc: John Fastabend <john.fastabend@gmail.com>
>>> Cc: Krzesimir Nowak <krzesimir@kinvolk.io>
>>> Cc: Yonghong Song <yhs@fb.com>
>>> Cc: Andrey Ignatov <rdna@fb.com>
>>> Fixes: 31fd85816dbe ("bpf: permits narrower load from bpf program context fields")
>>> Signed-off-by: Will Deacon <will@kernel.org>
>>
>>
>> Thanks for the fix! You didn't miss anything. It is a bug and we did not
>> find it probably because user always use 'u64 val = ctx->u64_field' in
>> their bpf code...
>>
>> But I think the commit message can be improved. An example to show the
>> difference without and with this patch can explain the issue much better.
>>
>> Acked-by: Yonghong Song <yhs@fb.com>
> 
> If I'm reading it correctly it's indeed a bug.
> alu64(and, 0xffffFFFF) is a nop
> but it should have been
> alu32(and, 0xffffFFFF) which will clear upper 32-bit, right?

Right. This is my understanding as well.

> Would be good to have a selftest for this.


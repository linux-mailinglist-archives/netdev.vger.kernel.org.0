Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C0E96450AA
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 02:01:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229607AbiLGBBq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 20:01:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbiLGBBp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 20:01:45 -0500
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D873146658;
        Tue,  6 Dec 2022 17:01:43 -0800 (PST)
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2B6Nloa6012188;
        Tue, 6 Dec 2022 17:01:22 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=s2048-2021-q4;
 bh=ewEdK6dLf9uzSn7L3ZskHv5Rv2k4Fmgp2yS3iRBEYXk=;
 b=Dap0o7qfoCOQQy4SbramLdxSSQujUuJDFDCs76xRQoMHt7IlVPEruHJF8unn/jaC/D3M
 scTVHlXVmRT9NqKRBdfElerIYROgy+nGcVVDmb+8ZgxyyOGt0JzZlOWt3Zh3XWurJyq6
 tbXRFkhYulDkog3jg7nvI8Oo65FiW9TGt8FiDR1pdp5FKG1/tvwUe6Ln23oscJbx8CAj
 n1F+5QXREDZuo/fPvJRZkSwgI7b63IhusuJ0tUL9KWK0C2a37df+ahcUeE2xQhqk8IyD
 ESz3GYUg0fMPJ/UxkA49vtEnFmw7cxP2vox/TrxxLU381ALiI6Xy6IBBmJPNH0Uvd61S 5g== 
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2046.outbound.protection.outlook.com [104.47.66.46])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3mafq98a41-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Dec 2022 17:01:22 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZjR+b/EzJazoIASy8QR+kRPModyaDT/30BFie6s3OV2oTTGwfwBiXSHBWQxkfZGulhfTq6MyMfEfwuxaNN6bsG5X5Qhr6z0x+CQA+IwQLYZ4EhAol275ln+7vtZXpnsTM2zXrmYYyJNIXJrd7AMgZn/wNmfXXqxWusN/2YMYQ5PH7i0UveGYjL7gtPI1UY4Xm35LX/Pxdou6LySCmxFKZwu3qYd/twsU+Bdbrp5Fb9s/+qFiuz6C8Gq8GXk6l+v5QCWbO/Lvb6Y3MpRPwhrLBPjj15ho6uKOVz+fZt42cuSJyRGtA6cn061yqaIn/We9Dv9dB37sH32dTX85clhK2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Dr8CIdcr5snyq+vX2jjwJ/w2Lx4HTPkICRvBco2wSos=;
 b=gXahQFITpHLvCueNVs4g9JeZKoxtGdr5LUCMfq+kdL/36K3kXyDgUR2zejZ89L7seXTFhyALrKOaltcYPey6kxFBrb9ttk3XEY911yolqOgbGiTdBA3OLID2YmDjqtvWmzpPGPf89ofOkAw2RXMLtwBj0Gq48ORB/W0fhGvSuoUUhSo39e+eNqcO2ERt1r2mqsfHcl1m1HvVVDWM9FTxQZ9BacvjR2c/vgx5PXKGo9ywonrpFPUhBuEJ3uVdUbkEf9gVnOos9do93/QOvZdmfdoCvdclE5ZJpMGyKX2lH8IR8zoxG15H/MH7RAF3Pj8qnLkIWaivljCB6eVdCN3cwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by CY8PR15MB5577.namprd15.prod.outlook.com (2603:10b6:930:98::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.8; Wed, 7 Dec
 2022 01:01:20 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::d665:7e05:61d1:aebf]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::d665:7e05:61d1:aebf%7]) with mapi id 15.20.5880.014; Wed, 7 Dec 2022
 01:01:20 +0000
Message-ID: <cd7a6e8d-2de1-d5a0-cf4a-09188f01fa7e@meta.com>
Date:   Tue, 6 Dec 2022 17:01:17 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.5.1
Subject: Re: [PATCH bpf] bpf: Proper R0 zero-extension for BPF_CALL
 instructions
Content-Language: en-US
To:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Ilya Leoshkevich <iii@linux.ibm.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@rivosinc.com>,
        Brendan Jackman <jackmanb@google.com>
References: <20221202103620.1915679-1-bjorn@kernel.org>
 <3b77aa12a864ab2db081e99aec1bfad78e3b9b51.camel@linux.ibm.com>
 <d26622c6-d51e-e280-6c8a-38c893c49446@meta.com>
 <9af1b919-ea15-e44c-b9cc-765c743dd617@meta.com>
 <87v8mos7gw.fsf@all.your.base.are.belong.to.us>
From:   Yonghong Song <yhs@meta.com>
In-Reply-To: <87v8mos7gw.fsf@all.your.base.are.belong.to.us>
Content-Type: text/plain; charset=UTF-8; format=flowed
X-ClientProxiedBy: SJ0PR13CA0132.namprd13.prod.outlook.com
 (2603:10b6:a03:2c6::17) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR1501MB2064:EE_|CY8PR15MB5577:EE_
X-MS-Office365-Filtering-Correlation-Id: d9e18913-07b2-4b95-26a1-08dad7ee8d50
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bil49yMds3pBCl/h+DqO5g93zdgGJLU7pMLDwGJTn8MdrY6NusYdIm2r8rle0cd1UN1BqNvt1XYqV+W81SF/Kw0iUAfpx5nvSKYCQrHlo9heOBupmFRiW5pQdxdduAg98MFfd59VzZYIX2qk66IKUAPfSBHW5MtqKyiyIzCRmHvtFFD1aZ+HmhdGz6VbsiADMBZdEOD8f8C5GazDBpBms27T9MCP7/q+PJiEkveQFR8Mcph73RGqWoWmijPXQdDMgYG060QxUb7rWi1zyCLf1Bs4jLsbSIdfLGkpKFp3fT2mKcdgHJaNozqi3NJrl/QiSVakGTONWmsYZHRGQi4T6rPFl6bGSNFRiswCQwpsT0lU6opL3nFWNSrPT6Q3U6fw1VrKBnfZke10+h/QL/yoHLShVqP4aHxSSc63eJ3KK9Xk2WOCwdlqsmc0/UQoC6dqLt3FJ2i9lxqpQyOUgUjq+yo2CTP5npy1wwCuZMJs3Etxdv4wNFYt+DyAK3H+72//4x1u779Yb8WWVOcmME8+MNtt0twtqlpxMb5ijok8tyfLMngWbU1t3iEyXAGkAPBlvX/wu12euZODseNDTEDOAgKkdCaUQZsXBrBObrXKrfVmMV3e0ISIGFxyGUpy3YqRh02rL/vUgJKFg6pHm8UB8Hic35y0C6Je99HuHGSsiCbJd9sQdQEYNszyl3MAIQWl4o9SWfFpecz8qkB11PjrPrgbYNcvr+Djp3x4CNfehU2jkvHUSx4X+re9H41EPXXc
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(39860400002)(366004)(136003)(376002)(346002)(451199015)(83380400001)(86362001)(31696002)(5660300002)(66574015)(4326008)(8936002)(2906002)(41300700001)(8676002)(6506007)(53546011)(6512007)(6666004)(186003)(110136005)(316002)(66556008)(2616005)(54906003)(478600001)(66946007)(66476007)(6486002)(966005)(31686004)(66899015)(38100700002)(36756003)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NDFLbjlpek9sYndjaW9XTmxFa0Rna1Y5R3hGWVZMajUvQ1lpRHJtWXF6ZEhI?=
 =?utf-8?B?Zkk2TUM4cldubmFJVDc4ZWtzeGIyYkMwQUZKcGo3STZJNG50YWI1WVdyT3FP?=
 =?utf-8?B?WW1KWXFQc3hhNWdaTEdieU9iWUdwSzRvQjFVS05JNUJPRndtNzJUWnE0Y3Nk?=
 =?utf-8?B?eUtKQi9mZGFmbGl4Vm5HUCtUVTcvNGFBM2pmRzg0S3RqMC8wbFpydlJFYlZ2?=
 =?utf-8?B?c1hSUnQyNXBYaGZqRmY0Q0xlNmZyMzRMcGg1VGVsUVBaSlp5S0U3dDN3dWNs?=
 =?utf-8?B?dm8rTUVOQVBhQ1hESkx4bmYwdFd5S09lZjI3RWlEaDh3T1ZZaWFmd2t6emNQ?=
 =?utf-8?B?aElRVHBmbGpYQlNkWldlY3NsaENVRnNVOVkvYkZrZDFtN0xJQnNSRTErMUZj?=
 =?utf-8?B?Nlo4L2FMQm02WlNoT3FBNnZFM3hrVUR2V2I2UnhDWkI1a2NmT2NkTVd6bnI5?=
 =?utf-8?B?alVrMnp1UitmanlVZ05yZFlKOEVDcER3cm1GUWVIeTFZNzJjdTVZNExwQ3Vu?=
 =?utf-8?B?bUJqdU5KZlU2SVB5QStLN2tEVFVNRHJ4Wk5FODNpRytsMVgxWWdCb3BTTERS?=
 =?utf-8?B?ajUvQVFMSitzcGM2RnRuMTBYQWZJWGJ2QTJRcHRiQnlhWHNzTmdFTjFmRUtL?=
 =?utf-8?B?RjR0WjBiemlxK0lGU09ab3k1aFdya2RZTEJTNzFUeFdFaFZadTNPTkErRkww?=
 =?utf-8?B?THdiS0o3cXJpTG1ZSnA3ZmtoVkZSQzA3eTB0UFJuKzFMU08wWFp2TS85UE94?=
 =?utf-8?B?dEhMN0hUTURHWk9TKzdZYzZUdDFpY2l2ZFZkeldWajFOc0RXeHhSbzFhSFM0?=
 =?utf-8?B?UzRJNzZpWUJuUTJpakZWdjNCQnluM1FsdUhRUDRMN094UDBma3g4RUhJWDlj?=
 =?utf-8?B?Q2RXMkg3NVRrQkxaZVlEMFZXZ091b0RjLzlrUXV3MDZvbCtPenYxWDd5cnY5?=
 =?utf-8?B?bG9kQk1pVTVSYXI0UEp3VDJLczNJdkptT0RWUFV6NXNHZWtwYkk5NWRhcVRQ?=
 =?utf-8?B?UUhUSDBCK29vM3B4VnZCOC9hdUI2eitxSDVPblNEbW9PNVp0K21tK3ovUDFS?=
 =?utf-8?B?cks4SEFEUExSWmhmdUpkZVJ1K1NzTXRkaG01Y3FndDVRelFTd1ljR0JGUFBW?=
 =?utf-8?B?NHdJQVVENk5BMXBDUDFBOCtRajBDdFpJYmh6a2RLWmtqSzhTTzRjUmRER09G?=
 =?utf-8?B?WTExcitkMHlCdWZWcmRidVV5c0pOaUhjcTVsOVdoWlZQZXYxSml0Z3E3QzRE?=
 =?utf-8?B?QTNYWjhYUUt2bmRYOFJzeHlJck9rSW9ocUd6bHRhU2srT0lPQVZ1SU1NUitI?=
 =?utf-8?B?bGpIS2VhUlNhM2xRYlVocHdWcVpEZXBzeDhBbXUyQnRzWmE0L0ZkYW9aMGJT?=
 =?utf-8?B?aGJxRGlDRUJzRVFBWG1mcERjZlY3QXNxZkxXWGhVSEhmUmU5RkJFTmsrWGl6?=
 =?utf-8?B?TlFHVUE3Z0QwWUI1ZU82OXVham5NbkVCa2tPMjkrNjdDZ2JkZUwzL1BqKzVO?=
 =?utf-8?B?YWJYanV5TDFNVHBEVHZiR0N6Zkk4Y0UxL29SdU9QREJYSVh0NFd4ZXZ2dTBl?=
 =?utf-8?B?Uzh0d2hQelh3KzZqNDZsRXpOQ1BxUmJRSTk0dDgva2J2Rks5dXY1V2RZQ3dK?=
 =?utf-8?B?U2Ixbm5PVE95eENUN1grTUlkZml0eEFVOHdVZnp6UWlINk5taExOeVVzSWMv?=
 =?utf-8?B?VEhCdk1vNGlDRmZZNkdRRmZQWEdrNGVJbFdYT3RidXRDci8zcXhzMHhnMFFU?=
 =?utf-8?B?Zi9KZDJCb3V6c0tpNktSUHRmNUk1b3ZXYWJ0MjZBdEZyWDhPWS9MNEdGdFIz?=
 =?utf-8?B?VEtTVjRhTWcxTHg0dVkwZTdBRE5saVFwZnlaSThibW9qV1BQalJvYllDMVAz?=
 =?utf-8?B?U1l5YUd0NHZyN0RZRjVaOXk5RE9JbTUwTWJHVWczT2swSFhFeGZvSnZVM2tn?=
 =?utf-8?B?V1NnOUZTaW8vV3pXT3hHelRqdC9PNThLbnBoQThHMUhRbDU0ZHFaeFdrS05R?=
 =?utf-8?B?aTZsVllvZ2UveG9EYW9PQW5HSkltbHZXdUVkOGZJcHR2aExlbXpCQmN0cStt?=
 =?utf-8?B?dWQyR0MyNjByRUVOeFZGck1NaFVEbWxKc2lyTDdDU0J6ckhwNjVwQndWM1JF?=
 =?utf-8?B?NEZLSDY1TFBmUkNwakdhczA4MUVaQzJ2R3VWSXQyWG9ncm56cXJCU2E4UGFQ?=
 =?utf-8?B?UUE9PQ==?=
X-OriginatorOrg: meta.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d9e18913-07b2-4b95-26a1-08dad7ee8d50
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Dec 2022 01:01:20.1562
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xUUOurkh3CUe/H0SsdKoftFmFO7BscyjaOA4BrtEXGHq7z7mTpSWTx/PURHlJSmb
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR15MB5577
X-Proofpoint-ORIG-GUID: LR26J9cYVdRXSvd-LeaJGebKrpjbaa6D
X-Proofpoint-GUID: LR26J9cYVdRXSvd-LeaJGebKrpjbaa6D
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 1 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-06_12,2022-12-06_01,2022-06-22_01
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/6/22 10:38 AM, Björn Töpel wrote:
> Yonghong Song <yhs@meta.com> writes:
> 
>> On 12/6/22 9:47 AM, Yonghong Song wrote:
>>>
>>>
>>> On 12/6/22 5:21 AM, Ilya Leoshkevich wrote:
>>>> On Fri, 2022-12-02 at 11:36 +0100, Björn Töpel wrote:
>>>>> From: Björn Töpel <bjorn@rivosinc.com>
>>>>>
>>>>> A BPF call instruction can be, correctly, marked with zext_dst set to
>>>>> true. An example of this can be found in the BPF selftests
>>>>> progs/bpf_cubic.c:
>>>>>
>>>>>     ...
>>>>>     extern __u32 tcp_reno_undo_cwnd(struct sock *sk) __ksym;
>>>>>
>>>>>     __u32 BPF_STRUCT_OPS(bpf_cubic_undo_cwnd, struct sock *sk)
>>>>>     {
>>>>>             return tcp_reno_undo_cwnd(sk);
>>>>>     }
>>>>>     ...
>>>>>
>>>>> which compiles to:
>>>>>     0:  r1 = *(u64 *)(r1 + 0x0)
>>>>>     1:  call -0x1
>>>>>     2:  exit
>>>>>
>>>>> The call will be marked as zext_dst set to true, and for some
>>>>> backends
>>>>> (bpf_jit_needs_zext() returns true) expanded to:
>>>>>     0:  r1 = *(u64 *)(r1 + 0x0)
>>>>>     1:  call -0x1
>>>>>     2:  w0 = w0
>>>>>     3:  exit
>>>>
>>>> In the verifier, the marking is done by check_kfunc_call() (added in
>>>> e6ac2450d6de), right? So the problem occurs only for kfuncs?
>>>>
>>>>           /* Check return type */
>>>>           t = btf_type_skip_modifiers(desc_btf, func_proto->type, NULL);
>>>>
>>>>           ...
>>>>
>>>>           if (btf_type_is_scalar(t)) {
>>>>                   mark_reg_unknown(env, regs, BPF_REG_0);
>>>>                   mark_btf_func_reg_size(env, BPF_REG_0, t->size);
>>>>
>>>> I tried to find some official information whether the eBPF calling
>>>> convention requires sign- or zero- extending return values and
>>>> arguments, but unfortunately [1] doesn't mention this.
>>>>
>>>> LLVM's lib/Target/BPF/BPFCallingConv.td mentions both R* and W*
>>>> registers, but since assigning to W* leads to zero-extension, it seems
>>>> to me that this is the case.
>>>
>>> We actually follow the clang convention, the zero-extension is either
>>> done in caller or callee, but not both. See
>>> https://reviews.llvm.org/D131598   how the convention could be changed.
>>>
>>> The following is an example.
>>>
>>> $ cat t.c
>>> extern unsigned foo(void);
>>> unsigned bar1(void) {
>>>       return foo();
>>> }
>>> unsigned bar2(void) {
>>>       if (foo()) return 10; else return 20;
>>> }
>>> $ clang -target bpf -mcpu=v3 -O2 -c t.c && llvm-objdump -d t.o
>>>
>>> t.o:    file format elf64-bpf
>>>
>>> Disassembly of section .text:
>>>
>>> 0000000000000000 <bar1>:
>>>          0:       85 10 00 00 ff ff ff ff call -0x1
>>>          1:       95 00 00 00 00 00 00 00 exit
>>>
>>> 0000000000000010 <bar2>:
>>>          2:       85 10 00 00 ff ff ff ff call -0x1
>>>          3:       bc 01 00 00 00 00 00 00 w1 = w0
>>>          4:       b4 00 00 00 14 00 00 00 w0 = 0x14
>>>          5:       16 01 01 00 00 00 00 00 if w1 == 0x0 goto +0x1 <LBB1_2>
>>>          6:       b4 00 00 00 0a 00 00 00 w0 = 0xa
>>>
>>> 0000000000000038 <LBB1_2>:
>>>          7:       95 00 00 00 00 00 00 00 exit
>>> $
>>>
>>> If the return value of 'foo()' is actually used in the bpf program, the
>>> proper zero extension will be done. Otherwise, it is not done.
>>>
>>> This is with latest llvm16. I guess we need to check llvm whether
>>> we could enforce to add a w0 = w0 in bar1().
>>>
>>> Otherwise, with this patch, it will add w0 = w0 in all cases which
>>> is not necessary in most of practical cases.
>>>
>>>>
>>>> If the above is correct, then shouldn't we rather use sizeof(void *) in
>>>> the mark_btf_func_reg_size() call above?
>>>>
>>>>> The opt_subreg_zext_lo32_rnd_hi32() function which is responsible for
>>>>> the zext patching, relies on insn_def_regno() to fetch the register
>>>>> to
>>>>> zero-extend. However, this function does not handle call instructions
>>>>> correctly, and opt_subreg_zext_lo32_rnd_hi32() fails the
>>>>> verification.
>>>>>
>>>>> Make sure that R0 is correctly resolved for (BPF_JMP | BPF_CALL)
>>>>> instructions.
>>>>>
>>>>> Fixes: 83a2881903f3 ("bpf: Account for BPF_FETCH in
>>>>> insn_has_def32()")
>>>>> Signed-off-by: Björn Töpel <bjorn@rivosinc.com>
>>>>> ---
>>>>> I'm not super happy about the additional special case -- first
>>>>> cmpxchg, and now call. :-( A more elegant/generic solution is
>>>>> welcome!
>>>>> ---
>>>>>    kernel/bpf/verifier.c | 3 +++
>>>>>    1 file changed, 3 insertions(+)
>>>>>
>>>>> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
>>>>> index 264b3dc714cc..4f9660eafc72 100644
>>>>> --- a/kernel/bpf/verifier.c
>>>>> +++ b/kernel/bpf/verifier.c
>>>>> @@ -13386,6 +13386,9 @@ static int
>>>>> opt_subreg_zext_lo32_rnd_hi32(struct bpf_verifier_env *env,
>>>>>                   if (!bpf_jit_needs_zext() && !is_cmpxchg_insn(&insn))
>>>>>                           continue;
>>>>> +               if (insn.code == (BPF_JMP | BPF_CALL))
>>>>> +                       load_reg = BPF_REG_0;
>>
>> Want to double check. Do we actually have a problem here?
>> For example, on x64, we probably won't have this issue.
> 
> The "problem" is that I hit this:
> 		if (WARN_ON(load_reg == -1)) {
> 			verbose(env, "verifier bug. zext_dst is set, but no reg is defined\n");
> 			return -EFAULT;
> 		}
> 
> This path is only taken for archs which have bpf_jit_needs_zext() ==
> true. In my case it's riscv64, but it should hit i386, sparc, s390, ppc,
> mips, and arm.
> 
> My reading of this thread has been that "marking the call has
> zext_dst=true, is incorrect", i.e. that LLVM will insert the correct
> zext instructions.

Your interpretation is correct. Yes, for func return values, the
llvm will insert correct zext/sext instructions if the return
value is used. Otherwise, if the return value simply passes
through, the caller call site should handle that properly.

So, yes changing t->size to sizeof(u64) in below code in
check_kfunc_call() should work. But the fix sounds like a hack
and we might have some side effect during verification, now
or future.

Maybe we could check BPF_PSEUDO_KFUNC_CALL in appropriate place to 
prevent zext.

> 
> So, on way of not hitting this path, is what Ilya suggest -- in
> check_kfunc_call():
> 
>    if (btf_type_is_scalar(t)) {
>    	mark_reg_unknown(env, regs, BPF_REG_0);
>    	mark_btf_func_reg_size(env, BPF_REG_0, t->size);
>    }
> 
> change t->size to sizeof(u64). Then the call wont be marked.
> 
>>   >>>    ...
>>   >>>    extern __u32 tcp_reno_undo_cwnd(struct sock *sk) __ksym;
>>   >>>
>>   >>>    __u32 BPF_STRUCT_OPS(bpf_cubic_undo_cwnd, struct sock *sk)
>>   >>>    {
>>   >>>            return tcp_reno_undo_cwnd(sk);
>>   >>>    }
>>
>> The native code will return a 32-bit subreg to bpf program,
>> and bpf didn't do anything and return r0 to the kernel func.
>> In the kernel func, the kernel will take 32-bit subreg by
>> x86_64 convention. This applies to some other return types
>> like u8/s8/u16/s16/u32/s32.
>>
>> Which architecture you actually see the issue?
> 
> This is riscv64, but the nature of the problem is more of an assertion
> failure, than codegen AFAIK.
> 
> I hit is when I load progs/bpf_cubic.o from the selftest. Nightly clang
> from apt.llvm.org: clang version 16.0.0
> (++20221204034339+7a194cfb327a-1~exp1~20221204154444.167)
> 
> 
> Björn

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 056961C7CC9
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 23:47:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729822AbgEFVrv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 17:47:51 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:45920 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729114AbgEFVrv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 17:47:51 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 046LlYuG004224;
        Wed, 6 May 2020 14:47:37 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=t8g9/9R2j7gITe4KiApfc58SMEKGaTDO1KeajpNfDy0=;
 b=Viyu/kCT/vHMHjcp8C8/lZrD+X3aWRUBm0szSftFDHkuY4HzaKVP/0yDraS4tlnpl5g6
 Tg3NT26xsRspraSRGN96ORHo2VXa9ScItWPZ+7lh24zl3AKrX4AhvnvbNFf+TQRISz1F
 beoSglLRdXPhHF/UiI2Hctr38+BJBIH4RR0= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0001303.ppops.net with ESMTP id 30ufak6fg7-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 06 May 2020 14:47:37 -0700
Received: from NAM04-BN3-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.198) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Wed, 6 May 2020 14:47:08 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c3Sa6YlCVgsMXepp6dnSrvFd8b5kD6EIYeJ9UBwwdj83LMEOw6bGz54LGNpzfhLB6zSCFh2G9A9FafStS66JvvoO8/q8DsKW1xk0YnJzWKLcVIn1QqO/ZWDrooEVUmGxLtD2FxgmgqgYlODeEyVbSSgt1vrt97sc4SBImj0VzfWcU+1hfiYH5d8dezdpavN2Wxuotyf7X1As5CK3USGHyx2mAaBdEyL4BmZmVJ1l6aRnP7ILFE6EkR1cmhbugm7QDutBGE3CP/fkLWCeD64xZumzDfZ7FWrXLM/HMtHkopEB+8lbMBJ9XGwR782jVC4FCxbhb13LPMM+ZaMCWneEFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t8g9/9R2j7gITe4KiApfc58SMEKGaTDO1KeajpNfDy0=;
 b=E/cyeNu2gNXdjisAv0w8PAestffbnWovjUI/USUhHKLjJXCNYNkFwWORMtdgOwVN+C/Cy80+x9tu7TSUWyMgChQ0KNbF2S4xl7pwtur5DqmVsymO8vFd4to68JlwV0CSwwrVcxYag20GpawP7n0K9WYRYr2aMyHBVwiVPiNtapqnNnzcVXpU3GhLxhyQSfHnJOlfjj9fj6qsCHoT2bZAVG7HwqTsZBiNNlWtoYgcGD5Q5Iw041JB66lBVbM4PRp8E2nu6e/sxWNdc0DFBAUzy0B2LELAnJSf9YHW3dnnAMfeh4OK7/qdXNQcDn67bTrOCnGPhl70QsHlVJinkCXYrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t8g9/9R2j7gITe4KiApfc58SMEKGaTDO1KeajpNfDy0=;
 b=KjJzh59iS6t+z+Ep5ArqwwMeE7GR02T0fNpH4S2bCic3l/FdiRjcRZYYasZpuFBkKh7OIMYgM0zdbaWdxRmqIszzZWgMWg1oM+SqZ7OwRqsVyeusQvF0mi/c81/R9OV/4B3RV4iwwwjbrjJDJm5weM9IBvyJc6Z4RHwwL7+rUQY=
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB3493.namprd15.prod.outlook.com (2603:10b6:a03:105::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.20; Wed, 6 May
 2020 21:47:07 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::8988:aa27:5d70:6923]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::8988:aa27:5d70:6923%5]) with mapi id 15.20.2958.030; Wed, 6 May 2020
 21:47:07 +0000
Subject: Re: [PATCH bpf-next v2 14/20] bpf: handle spilled PTR_TO_BTF_ID
 properly when checking stack_boundary
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
References: <20200504062547.2047304-1-yhs@fb.com>
 <20200504062603.2048735-1-yhs@fb.com>
 <CAEf4BzYkuiCf0Wo7vQn03kiW_L7t_tica87HcOmYGHWwK+ipdQ@mail.gmail.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <7e074d58-3d5b-0e83-aa3f-df5441753239@fb.com>
Date:   Wed, 6 May 2020 14:47:04 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
In-Reply-To: <CAEf4BzYkuiCf0Wo7vQn03kiW_L7t_tica87HcOmYGHWwK+ipdQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR02CA0005.namprd02.prod.outlook.com
 (2603:10b6:a02:ee::18) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from MacBook-Pro-52.local (2620:10d:c090:400::5:66a9) by BYAPR02CA0005.namprd02.prod.outlook.com (2603:10b6:a02:ee::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.26 via Frontend Transport; Wed, 6 May 2020 21:47:06 +0000
X-Originating-IP: [2620:10d:c090:400::5:66a9]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 192fc1a5-1823-4b65-fa8d-08d7f2070573
X-MS-TrafficTypeDiagnostic: BYAPR15MB3493:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB34939CE980EA69F4C4D65DA1D3A40@BYAPR15MB3493.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:1303;
X-Forefront-PRVS: 03950F25EC
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: V2bp13ckyREWvkLIdf1Xky5tUC7Byy00d4/m0uoZ99hScTSbUj0DM19yi9Er4h5rFa25tS+lVaQjZLNZPx/tjnf+LCtmBaLIuvYloHXIrWZJT6Ex+bZRC3WT0ORpDl4CBJhuW+AnNld6Es98Qw0pjwsBzw4bRYwj21AxxRg7meFzsC0u0lbadCuWg3reFldtt6lYXHCCzZjJzbGJr41aZ2jvpLN8OzxYZ1xl3RoNJTZ4WDDUZON9Dq9AkG2BZ59nrsPT9nHSQbWGHLtYxRFfR2uNeuBWtksrABd+g5gbppZoN4fvosJI8gFX6wFTYNLVOb7B5A310ZcFZ3L46t8MUySOpeK/gL5uGVj5CXFiMeUKbY1LSU/UYHgQUkkYIpJxSP9A62MyFlYYQgWu8/SVgvlGHBReWRva85jjrR6UGe/CYbwHUNcdWZ3pQxRZvrj5BsQQX3uT8sGblQZQzpLUO2d7CQAq+4hooU3yKee/ouAZ5vE6cFQIsf/KcWjfaesAJT1Gilv2vF7xsdXX79jsMJ4gIiw3hNTMCW2Me9SQsCpm+nHiIvWsVGScKsE87KzM
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(39860400002)(346002)(136003)(366004)(396003)(376002)(33430700001)(31696002)(66946007)(66476007)(6916009)(4326008)(6506007)(86362001)(53546011)(33440700001)(66556008)(52116002)(36756003)(6486002)(8936002)(5660300002)(8676002)(31686004)(6512007)(2616005)(186003)(478600001)(316002)(2906002)(54906003)(16526019)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: DyypaJnTNgpWlxRvexwndO96m6zEYyPhmjmXZGUhmcIvjpl7lBhukzDBy93o4ZlWd/s+nBbkv0zVRMwDbmy0BnTNuERjKJmrsc+eZ1yk3IZSBCuDdtooI/FUiM7YlSYQ1Pk/EXAhDRq4CIx+5k9hpRQb8tTzOGoy3R2MRTqpfGvWtv27Z6is3mfsXxmX7jPftUiZCp1bpkFlr0LBycVdj7XHdcqanSyuwqrshOsMEjBzW+HJYvhd6E+W6DWAYSMQkesl1CB5WpS4rGGCBwHUTwf7nwnlCARbDnS/VsIPVHL0L1nDqidmYF70c6qVmapk+NliGhheBa877yRjTUrda7tkpIodZGUtF1JcdbMCA99v9R3iNtuAMlMnxg7lbZbefBX4TvWdwXpO2uVd2wq86HTjJJCChG0bdtV5qo3ORSGtQDtS2m+5xTQT935L1A5aQjpxg/mzSD7IzQ89mF+UPDQnN6EQ/h6ONv02uIlrJXjFBQfR209vN2Un00Mh3eKF4tVxbe2KGxa91a7k2Y2e/BLWrsMEhjOb1Tetvt05OiQhtejT4Fqr3Bb5M0XwePQ4PDEp4hbMN3zI5vST+5i9zLumP/kGiy7VNFkzPn63bd/hWJrbHnLP6FFl2/4SPL2SYsG+Zz4XXRsk/3ggsqqftOo93cW4aOynx1UApPyP4890YfVJkuxvOOEC1/T+Y54qc9rURjd7NXiKE19Sk4Z17HfiUs6saL7f6xBGGfT9qVsvPx1jSW08D3HQWXEwFuUq/HLbLZHYW3OBQnagkiXMibaQZkxGvC3YCFl+xhbNMYgO+OQYBwvf0DUB644jN8+xo79aip/cXzuEywYTtlqbZg==
X-MS-Exchange-CrossTenant-Network-Message-Id: 192fc1a5-1823-4b65-fa8d-08d7f2070573
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 May 2020 21:47:06.9391
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DYcC1RZlsj9bVCRDXhC4uk4yCCBuwLZutoycZxLlp0m0LTyPz5KR/+cwRMiVMhtI
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3493
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-06_09:2020-05-05,2020-05-06 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 mlxlogscore=999 phishscore=0 adultscore=0 impostorscore=0 suspectscore=0
 priorityscore=1501 mlxscore=0 clxscore=1015 spamscore=0 bulkscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005060175
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/6/20 10:38 AM, Andrii Nakryiko wrote:
> On Sun, May 3, 2020 at 11:28 PM Yonghong Song <yhs@fb.com> wrote:
>>
>> This specifically to handle the case like below:
>>     // ptr below is a socket ptr identified by PTR_TO_BTF_ID
>>     u64 param[2] = { ptr, val };
>>     bpf_seq_printf(seq, fmt, sizeof(fmt), param, sizeof(param));
>>
>> In this case, the 16 bytes stack for "param" contains:
>>     8 bytes for ptr with spilled PTR_TO_BTF_ID
>>     8 bytes for val as STACK_MISC
>>
>> The current verifier will complain the ptr should not be visible
>> to the helper.
>>     ...
>>     16: (7b) *(u64 *)(r10 -64) = r2
>>     18: (7b) *(u64 *)(r10 -56) = r1
>>     19: (bf) r4 = r10
>>     ;
>>     20: (07) r4 += -64
>>     ; BPF_SEQ_PRINTF(seq, fmt1, (long)s, s->sk_protocol);
>>     21: (bf) r1 = r6
>>     22: (18) r2 = 0xffffa8d00018605a
>>     24: (b4) w3 = 10
>>     25: (b4) w5 = 16
>>     26: (85) call bpf_seq_printf#125
>>      R0=inv(id=0) R1_w=ptr_seq_file(id=0,off=0,imm=0)
>>      R2_w=map_value(id=0,off=90,ks=4,vs=144,imm=0) R3_w=inv10
>>      R4_w=fp-64 R5_w=inv16 R6=ptr_seq_file(id=0,off=0,imm=0)
>>      R7=ptr_netlink_sock(id=0,off=0,imm=0) R10=fp0 fp-56_w=mmmmmmmm
>>      fp-64_w=ptr_
>>     last_idx 26 first_idx 13
>>     regs=8 stack=0 before 25: (b4) w5 = 16
>>     regs=8 stack=0 before 24: (b4) w3 = 10
>>     invalid indirect read from stack off -64+0 size 16
>>
>> Let us permit this if the program is a tracing/iter program.
>>
>> Signed-off-by: Yonghong Song <yhs@fb.com>
>> ---
> 
> LGTM, but I wonder why enabling this only for iterator programs?
> 
> Acked-by: Andrii Nakryiko <andriin@fb.com>
> 
> 
>>   kernel/bpf/verifier.c | 8 ++++++++
>>   1 file changed, 8 insertions(+)
>>
>> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
>> index 36b2a38a06fe..4884b6fd7bad 100644
>> --- a/kernel/bpf/verifier.c
>> +++ b/kernel/bpf/verifier.c
>> @@ -3494,6 +3494,14 @@ static int check_stack_boundary(struct bpf_verifier_env *env, int regno,
>>                          *stype = STACK_MISC;
>>                          goto mark;
>>                  }
>> +
>> +               /* pointer value can be visible to tracing/iter program */
>> +               if (env->prog->type == BPF_PROG_TYPE_TRACING &&
>> +                   env->prog->expected_attach_type == BPF_TRACE_ITER &&
> 
> What's the problem allowing this for all program types?

Just want to conservative here since we may leak kernel pointers.
But probably we are fine since the spill type is PTR_TO_BTF_ID
which means tracing/raw_tp related bpf programs which should
be okay. Will remove the above additional check, which I added
in v2 of the patch.

> 
>> +                   state->stack[spi].slot_type[0] == STACK_SPILL &&
>> +                   state->stack[spi].spilled_ptr.type == PTR_TO_BTF_ID)
>> +                       goto mark;
>> +
>>                  if (state->stack[spi].slot_type[0] == STACK_SPILL &&
>>                      state->stack[spi].spilled_ptr.type == SCALAR_VALUE) {
>>                          __mark_reg_unknown(env, &state->stack[spi].spilled_ptr);
>> --
>> 2.24.1
>>

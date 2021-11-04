Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59333444DE6
	for <lists+netdev@lfdr.de>; Thu,  4 Nov 2021 05:24:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230119AbhKDE0f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Nov 2021 00:26:35 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:3192 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229866AbhKDE0e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Nov 2021 00:26:34 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1A3KFulf001411;
        Wed, 3 Nov 2021 21:23:43 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=aK42H2oUY2L4ISdkxfGrlDjzn2eDg/Uc0xXnbCssV/8=;
 b=d0Yh9ZEsAicgqqfG4C+HaCA0o85a2lWpPfCAn+U2yTDgQzmkapBMQA2cRg328XyVhjTt
 kFZcNoQ2oYfxubnsnQix3PJFD7C4ocLQsnPLIuxWPp8FznH8acOMNe+F/MevzQfoyeQe
 Py5CgjtUmrsikEWa9k526ELet/uZEqyPZ6I= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3c3vds541y-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 03 Nov 2021 21:23:42 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.196) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.14; Wed, 3 Nov 2021 21:23:38 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JgLawlFr6EoUVN1/HSz0JRSmtlL81eqcj7CQjBesg5Qmv0vo2mzHcukwY2vrz1Wh1owz+helVypvS3Mhr7Ao4mbwaZBXYztxPvXTdJ8BQ804LMaHWBl3JJmlurLv7hE+QLhm6Xpn1yrkgAAULdlUsP3yNUH4Xk3BNRubcPxzM2yuncUBoNlg0e3UVrzvZ44Xite2+NGWNV1S9soGDLpN4/3uci7eNV2zrCVcsCQZlQigEblXBxfBNSqtNFsNEliDdCqI/3S+YYC3I/HGIntl2hlZtz6X7aoO92jx32K2ZB1t32Hk3t6/9eSwCAf2jVfADXljiUta4mxqtiTQMqpCmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aK42H2oUY2L4ISdkxfGrlDjzn2eDg/Uc0xXnbCssV/8=;
 b=Y1aNvPF5IqTFlS8wM80IpTKZTH2BtCQHg1JuDZgdf7oEFUQWXb6rYkal+IHf8CRHee6Dt/y+vT+g/k+rwRt59Prn3f+iACWwyTxkI1gAZNjy/PT/dPNCVIhpGoM0Fu+e59XYe/TMeyzmmdfyuEF5vUillPvY+ScALmRPAxHjkM/mzbyd6c50+Hq/qxPI2OTj0vsqDY8DO7bXHsG/W8Ik0pqp8QzbK0wiByOpE70fiPKZMMloJZfIqJPOKjs5uauliO76NWQifXsUoprJXm3fWiyov1STYYv1Eq/8cmfTmVNGwsNaWmJfVa4LS8tf7ZltUyUP6a+iHpbW+0mH/8Ri9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SN6PR15MB2335.namprd15.prod.outlook.com (2603:10b6:805:24::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.11; Thu, 4 Nov
 2021 04:23:32 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::51ef:4b41:5aea:3f75]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::51ef:4b41:5aea:3f75%6]) with mapi id 15.20.4669.011; Thu, 4 Nov 2021
 04:23:32 +0000
Message-ID: <55c95c15-ccad-bb31-be87-ad17db7cb02a@fb.com>
Date:   Wed, 3 Nov 2021 21:23:29 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.2.1
Subject: Re: [RFC PATCH v3 0/3] Introduce BPF map tracing capability
Content-Language: en-US
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Joe Burton <jevburton.kernel@gmail.com>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Petar Penkov <ppenkov@google.com>,
        Stanislav Fomichev <sdf@google.com>,
        Joe Burton <jevburton@google.com>
References: <20211102021432.2807760-1-jevburton.kernel@gmail.com>
 <20211103001245.muyte7exph23tmco@ast-mbp.dhcp.thefacebook.com>
 <fcec81dd-3bb9-7dcf-139d-847538b6ad20@fb.com>
 <CAN22DihwJ7YDFSPk+8CCs0RcSWvZOpNV=D1u+42XabztS6hcKQ@mail.gmail.com>
 <CAADnVQJ_ger=Tjn=9SuUTES6Tt5k_G0M+6T_ELzFtw_cSVs83A@mail.gmail.com>
From:   Yonghong Song <yhs@fb.com>
In-Reply-To: <CAADnVQJ_ger=Tjn=9SuUTES6Tt5k_G0M+6T_ELzFtw_cSVs83A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MWHPR15CA0031.namprd15.prod.outlook.com
 (2603:10b6:300:ad::17) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
Received: from [IPV6:2620:10d:c085:21e8::1253] (2620:10d:c090:400::5:d1a6) by MWHPR15CA0031.namprd15.prod.outlook.com (2603:10b6:300:ad::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.11 via Frontend Transport; Thu, 4 Nov 2021 04:23:31 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c157623b-94ea-4445-5a41-08d99f4adc5f
X-MS-TrafficTypeDiagnostic: SN6PR15MB2335:
X-Microsoft-Antispam-PRVS: <SN6PR15MB2335A1818DC3F33DBE84E824D38D9@SN6PR15MB2335.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: v6na5QLxnJaPTewgoi6EXOJHbDOy+G2xkI0+p8eZ6WNQsrTyyg2w4OJ44OhW43kpHzeOy/gUFsbYtJpXKGzDYS/AJxIuuP045swogjgHxFRmK5DVBtmT42mS+A1Icn4v39Ptl34xhCWKl8ztyWFmNxnHJyBAMg8xEYdw/cZcJSEQednVPl4d9q0P1cCWGNhkJm7w5XdekAm0OJs222q5oL94KCmsqm/lSpF344zQSWV6MXQ+F9sgbBIOeFgugAN+yuhChXMHYiCySo2OXTU/cBfTAWlkonIUYBMIW6XybrOdhjVGehTEW2loJz89LKhCzzT1C1qQtLektzPkS0roEajBcFZyxY05I4AJ5dRexCy5LG/lRpNqnS5vfVul3siu15Li9yKE5c9NbZGPnfiv5+kk27uATROGCD4dXVIP6WNExdUjx2zck71KJDrGrIiIdtOP/2VIeinXvEjxO6whcfiMKwiuYf/RhpdFIvNPJl3I8BaC/kW4kB57I2k0aoVvEG4PPR8jICmVH+CCADeD1Pq3LpY1NIm332m36Za0hVr+hequhvAjlBq4/j59KgDkCa3BVoXrYPS91cbVWnPtbFBv35YVsiKeaOA2b9o16lGAwBu3ffsndHUfufsI9cIOzTk+xjJr1bJHIdcLbXMjYeWlEYzaL7lByDcO/S+Ans+guEGHi/rPEsykOXcThBISD2/s2uZYBD3+GEddN7+31dPEnE2ToASVoih47Xv0+60=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(8676002)(86362001)(186003)(38100700002)(7416002)(8936002)(2616005)(54906003)(316002)(6486002)(110136005)(31686004)(36756003)(53546011)(508600001)(52116002)(66946007)(83380400001)(5660300002)(4326008)(66476007)(66556008)(31696002)(2906002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NUJrQ0VTa2ZIY0ljQ2RWeWFza1VkaXltS3RNaVRhWmpUOTF0Q0hDbGF2L1VD?=
 =?utf-8?B?aFRSNE9jU3VOTHlpUnlNdU9nNEJidlRnWUFlVkovOWJXS0ZHZ0ttUEpLb0I1?=
 =?utf-8?B?YU9HS2d1dkZYYUNqTXAwS3JLcFFQNDJkaHA5My9nVFFmOE9OK0pSWUpRZ3pv?=
 =?utf-8?B?WDlaMnBOQ21sRUFyVWVxS1B4U1loMCtTdUNSaDg4Sld1aDUvT2ZzdmRmWDFY?=
 =?utf-8?B?bzdBVkJRNS9XYzViL0ZPU1BSeWlVcFV5QjFLLzA1MVgvN2ZVb1lBN3lLMEdO?=
 =?utf-8?B?M1pTeVQrVGhIVEozMk5obDRTTmpyZUlPZUVDamZ4S01KcVdQOW5ReUo4L0Ey?=
 =?utf-8?B?WWZRMFl1OFE2ZTBaUU9mQVN1cWg0dEFxbHNrYkh5cERVYnZSSlE3NHVBQVNR?=
 =?utf-8?B?aENqVFQ3WDFaVzRHUEs2dkJxNk1RbUY1TllXM2VuQkpGTW1CTHZ4WEk2UTRV?=
 =?utf-8?B?aDk1WU1EQlo0NVY2Yk5aNXJvd2NnUTlZb0MzOWxLSStBV1dzK0RCaU4vS0JH?=
 =?utf-8?B?Ni9aMGdIQ3RYYzB0Z3RoTi9xbU1vVmoxd3YzK1JUNzhSNjhjSC82VXZJSUVN?=
 =?utf-8?B?eXBmMWpxZUR3WjI1U3dldHBWZ1o2RFc3V3lXTzl4ZExudnp2Vkhqc1BiaENM?=
 =?utf-8?B?dEVqOUlMRUVjaGthNnVBVXhyankzYXplVzlxSVBBL1NpeHB5Q1VOQVhFekpM?=
 =?utf-8?B?MjRtYXFUcENqK2dQSTBVaVA2NnNFR3BTdUhpd2h2ZmNOa3BxYnY4b0FGY2dw?=
 =?utf-8?B?blk2NVUvYklZUVJxUytDb3prTTJlQVM4c1JQMWJCR0s5K1ovc1VMM2FnNHF2?=
 =?utf-8?B?VWJNd1N5Tm9lZnp5bTl3ZFp6amwxcHRwZG1SSE95M3p0M0VlY3djemRpV3hD?=
 =?utf-8?B?VExFUEZjeTNtRlRYblhGemRhZWhvRDlXWVZqbFM4QVQ1eDRsOHNMWFhqS0dJ?=
 =?utf-8?B?L25ueVZlejZ5ZTVKOGlrQTRzQlJtOStzaUpSQloxNlowNFYrNHJWeWlMMEYr?=
 =?utf-8?B?Q3ovRDUxMGlTR1QxNzBDN2NKZGdLM2QzbTB5TS9YZEZ1Nk1IVFZ4Y3M2UlND?=
 =?utf-8?B?TDdCR0Q0cXQ1OFR0M1lNdkRvYm5NcVhadG5jdW03RXVvaUpCSVBlancyTmcy?=
 =?utf-8?B?SkNTM0p0cXppWGFkeTRRaUtTVGVCV1BSb1NyWGhpMUtEenlxMHJKeFV5Qml2?=
 =?utf-8?B?dVBBOFByZ0Z1OVNlaFFtOEZQcUtvK3NFZmJaUlB2Y3ZaWWRQSlFXZ3B2SklC?=
 =?utf-8?B?b0NIT0ZhUGc2enRWUjRFckdybm81cWRBcndUMTNERXZOdDBGQmdwWGVBZmI5?=
 =?utf-8?B?RFdYbXRVa1ZYbmxCVTJQeHNWWXduTmtuNU42SWxsZkNqcXpZR3hIaXJZaU1o?=
 =?utf-8?B?Vm5BWXloRWlEZkthTWZrK0F4WFZwcEJvS0tpU2NNaEVicmQ4K01pOXk5T0Fo?=
 =?utf-8?B?c0JvMUZRd1dGUXh6QzdnR3ZXbHY5L3hkUk5CL0FXU3lWK254K05kN1Z1K2dt?=
 =?utf-8?B?czZrOVBHZ3BzdXdsWnQwd0NZQUlMZzVjOWhsdGhyN1p3cXlzWGJsWnN1Q0Rm?=
 =?utf-8?B?RTNtRXJSUFZNQkpmTDg5TTV4VmtRbVhXOEx2TG9RbHFiR3ZiOFQ0TzdjVTVn?=
 =?utf-8?B?aEo5alVUMDJnaFBSaGpoOWRtSktwN2FyZ2ZIVjU3bnN4eGJYVEMrcmZRVGFS?=
 =?utf-8?B?ZUhvUWd6ZjRmemlTWEs0SlprcnluYkNkdzhFQWpJZllTMXJOV0pHWDEyM1pJ?=
 =?utf-8?B?c2FLcXhsMGpJNlNGNHNqWS9ZVndSNnEvZHFyMVRNZEQ0SDFUYzB2V1pFZ1Ey?=
 =?utf-8?B?Nnl1M3dBK2dJa1dTUmVGSU1LUGp1Wk9FQ2tHUzZ5WUNsOC9DdElxdTE2NzFO?=
 =?utf-8?B?aTNYbVkvSHFCeHpGajlpc2lyYXVsMU90eVdMK01OUGV0OFZWNmRmZmVUWTVo?=
 =?utf-8?B?ODdrL25WNjM0ZE1obW4yYkJnOWhnUmd3Zml4cEhhaFlvQjBLNWNGejJLZmhq?=
 =?utf-8?B?SDlRaXQ1UDBPNDlHcDl5NFh1alcwVWFFR0ZLYVpleVo2R3Z3aFR0VkQyUEJk?=
 =?utf-8?B?aXdrSVF5cFlSQkNpN1hkTytmcFRlOXFWY21xRlZlalJPZDhQNHR5VWxjNk04?=
 =?utf-8?Q?y1AwVKKLG3q2TIBUFzCehEYBL?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c157623b-94ea-4445-5a41-08d99f4adc5f
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2021 04:23:32.4817
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kJbycH5s4fn6TDHxAIIkyn4Wqkz1ujx4xwr0+AHWYbi7+zUdezmo4js2glbsV2n9
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR15MB2335
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: 30u3QrGvVm6NTE2wXVBe_QtqZzPx8VHY
X-Proofpoint-GUID: 30u3QrGvVm6NTE2wXVBe_QtqZzPx8VHY
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-04_01,2021-11-03_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0 spamscore=0
 clxscore=1015 malwarescore=0 phishscore=0 mlxscore=0 impostorscore=0
 lowpriorityscore=0 mlxlogscore=963 adultscore=0 suspectscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111040024
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/3/21 10:49 AM, Alexei Starovoitov wrote:
> On Wed, Nov 3, 2021 at 10:45 AM Joe Burton <jevburton.kernel@gmail.com> wrote:
>>
>> Sort of - I hit issues when defining the function in the same
>> compilation unit as the call site. For example:
>>
>>    static noinline int bpf_array_map_trace_update(struct bpf_map *map,
>>                  void *key, void *value, u64 map_flags)
> 
> Not quite :)
> You've had this issue because of 'static noinline'.
> Just 'noinline' would not have such issues even in the same file.

This seems not true. With latest trunk clang,

[$ ~/tmp2] cat t.c
int __attribute__((noinline)) foo() { return 1; }
int bar() { return foo() + foo(); }
[$ ~/tmp2] clang -O2 -c t.c
[$ ~/tmp2] llvm-objdump -d t.o

t.o:    file format elf64-x86-64

Disassembly of section .text:

0000000000000000 <foo>:
        0: b8 01 00 00 00                movl    $1, %eax
        5: c3                            retq
        6: 66 2e 0f 1f 84 00 00 00 00 00 nopw    %cs:(%rax,%rax)

0000000000000010 <bar>:
       10: b8 02 00 00 00                movl    $2, %eax
       15: c3                            retq
[$ ~/tmp2]

The compiler did the optimization and the original noinline function 
still in the binary.

With a single foo() in bar() has the same effect.

asm("") indeed helped preserve the call.

[$ ~/tmp2] cat t.c
int __attribute__((noinline)) foo() { asm(""); return 1; }
int bar() { return foo() + foo(); }
[$ ~/tmp2] clang -O2 -c t.c
[$ ~/tmp2] llvm-objdump -d t.o

t.o:    file format elf64-x86-64

Disassembly of section .text:

0000000000000000 <foo>:
        0: b8 01 00 00 00                movl    $1, %eax
        5: c3                            retq
        6: 66 2e 0f 1f 84 00 00 00 00 00 nopw    %cs:(%rax,%rax)

0000000000000010 <bar>:
       10: 50                            pushq   %rax
       11: e8 00 00 00 00                callq   0x16 <bar+0x6>
       16: e8 00 00 00 00                callq   0x1b <bar+0xb>
       1b: b8 02 00 00 00                movl    $2, %eax
       20: 59                            popq    %rcx
       21: c3                            retq
[$ ~/tmp2]

Note with asm(""), foo() is called twice, but the compiler optimization
knows foo()'s return value is 1 so it did calculation at compiler time,
assign the 2 to %eax and returns.

Having a single foo() in bar() has the same effect.

[$ ~/tmp2] cat t.c
int __attribute__((noinline)) foo() { return 1; }
int bar() { return foo(); }
[$ ~/tmp2] clang -O2 -c t.c
[$ ~/tmp2] llvm-objdump -d t.o

t.o:    file format elf64-x86-64

Disassembly of section .text:

0000000000000000 <foo>:
        0: b8 01 00 00 00                movl    $1, %eax
        5: c3                            retq
        6: 66 2e 0f 1f 84 00 00 00 00 00 nopw    %cs:(%rax,%rax)

0000000000000010 <bar>:
       10: b8 01 00 00 00                movl    $1, %eax
       15: c3                            retq
[$ ~/tmp2]

I checked with a few llvm compiler engineers in Facebook.
They mentioned there is nothing preventing compiler from doing
optimization like poking inside the noinline function and doing
some optimization based on that knowledge.

> 
> Reminder: please don't top post and trim your replies.
> 

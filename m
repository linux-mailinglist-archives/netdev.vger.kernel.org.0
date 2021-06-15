Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2E513A75BA
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 06:21:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229557AbhFOEX5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 00:23:57 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:55956 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229463AbhFOEX4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Jun 2021 00:23:56 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15F4KIHS020050;
        Mon, 14 Jun 2021 21:21:37 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=aPewMbt1AdRl34nTgLc0dq+tKH1iKJP/ksOqyx1Ixl4=;
 b=QG5mWis8lbuXwOjHNDV5SHI3fqGhMAAEq8W5VnRnJl+c0nF9AKpGqNKGoFvikk/T/JJF
 6KY17YbzR6o9tglH4rmEUfV3OQ+sHE4H63v3nFzwouCymFvG5cfwAFEbi7NSVtxMHtGK
 hWk3xMwCaGcn0TSFZ8FR5BHEBm2op2HILXc= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 395d0x1q1x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 14 Jun 2021 21:21:37 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.196) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 14 Jun 2021 21:21:36 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N0jW5QkAnEELTLAemE2BqPvCWj1ZUq5w60JUICJjOSmUgbxaoet8APh861KUVkyF5vJX6BgJsflR/Hf4nzIJZ9FX+a3h0zmStFkmgX+2jSRLUnT7YYrdKDUPhZVH++qUkVh3dyeNyVpBtYrhZHQTAlqb7rFUhpgwQ2ve171AVxBo/AKpuFwIL7tXZu8z+B9S0LpefeKOWMp9rm4iLa8pkGsgfNwawQDJoxn+FieHHUujnCkB9jAyC0NVF8yivpiVErtBwOCiGLP7ooYIXki8nztkNw8JhOhL2vAkcN+S6edRaFi1mKOQTOVG85DpmATl5iVlKaTUgvU6oZjx2s6V+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aPewMbt1AdRl34nTgLc0dq+tKH1iKJP/ksOqyx1Ixl4=;
 b=iCYV7ziGlDeo1aAMe8q66kSTpvN52CKyfmA8iSMu419gEdlJL96Tp3vj+Y+z24HtWoLps2BN31KsP65FJt2soQ2zO1SNi/sstvWUmp6Ko8bJm9jBSxDMLEJ8TSeq7BcGz2Qn6sCdcjMr/AR8SKcL6wJ9srMNeJ4lwe+aZs3lbDkt9Hx09WhOKszC9Kchi3xixKT0TPHr3p0K+wutyFqEcoX9/aNLZWvCfUW29OHbtY86aAoLbhx+Wor9rAyFNL5i5VxMcssgWZSXTB7vCUowAKZYy13G/75KEkJ8tHete+OaqDrl4Sxkdp9Z+RnWRlYHJLLrmFZ4EkcTTCNMy1mTsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SA1PR15MB4418.namprd15.prod.outlook.com (2603:10b6:806:195::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.21; Tue, 15 Jun
 2021 04:21:36 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::d886:b658:e2eb:a906]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::d886:b658:e2eb:a906%5]) with mapi id 15.20.4219.025; Tue, 15 Jun 2021
 04:21:36 +0000
Subject: Re: [PATCH v2 bpf-next 1/3] bpf: Introduce bpf_timer
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Kernel Team <kernel-team@fb.com>
References: <20210611042442.65444-1-alexei.starovoitov@gmail.com>
 <20210611042442.65444-2-alexei.starovoitov@gmail.com>
 <f36d19e7-cc6f-730b-cf13-d77e1ce88d2f@fb.com>
 <CAADnVQKKrb1kz_C-v7RcgYgEe_JPhhpL4W6ySM28HcE_g=ncVw@mail.gmail.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <09936db4-c94a-98f9-0b2b-01d398676db8@fb.com>
Date:   Mon, 14 Jun 2021 21:21:32 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
In-Reply-To: <CAADnVQKKrb1kz_C-v7RcgYgEe_JPhhpL4W6ySM28HcE_g=ncVw@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2620:10d:c090:400::5:1623]
X-ClientProxiedBy: BY5PR17CA0052.namprd17.prod.outlook.com
 (2603:10b6:a03:167::29) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21e8::1139] (2620:10d:c090:400::5:1623) by BY5PR17CA0052.namprd17.prod.outlook.com (2603:10b6:a03:167::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.15 via Frontend Transport; Tue, 15 Jun 2021 04:21:34 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 80fa4375-71bf-416d-2a00-08d92fb51052
X-MS-TrafficTypeDiagnostic: SA1PR15MB4418:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA1PR15MB4418A792048681ACF4E98AD0D3309@SA1PR15MB4418.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fQ0YvHE/cLafpOWkHvsPT+ME/Xg11fPB53MnOU1fu0bda1BcMzqyTVuMLq1x/hUE4ZqRsTBilwavmMY6c8L2g4SuQESgF4pZNTLa7lVY7SZgUKrIRsPKq6WY68BlCN6S8NCwwcYcnZLfJSkAY36O7bfXzDCTtbqh1EmU2/8RLrKrPICuNoERlhzXiyEAhj+TYoQdBwz/4/2LJw3GRSAfUtcjoReXrF341/yvZKAuTRIYWXJYZr3a3Zu2AmzfFospxYcSXh0qn+XtLSWdFWK5P1CIH7Y6nZ8lGUTF2KJDcKuFZWxtbLB+xN1moRyEVYnEUWxhU8Ey9SRaK4nQkZIVNmeZt2+8fkfBoiLVIqxwLHUyhWTbqV5TVXbjh8r67UPaRRgriP5VI6No2Rjy3Ou1kl1Bwnav4lhSAAiVE3qRtlmI5ByU1XZsxrbjo2lRTqsX6/x2k/nZV8JrdzZSHktxncUrYVAw/nq8p7ehBMFAQLGimXe2d05+Ri90PWuCTDqPJ1tsL1Jirfc9WgJNubm6zMQ7Xd+pFmS0YRctWGQKKUCCENtVhxNyN1dgQLFN3iDW6AME2KhOp3eszT2cEb5Gt6l5CxWj4APOCXS+b2NUuUjeAuKSkhpXdMdeUlhMcagm7cBFl3r6FVUGDnC2RMayYna26tYk+Z+l3dg0fEj4few=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(136003)(39860400002)(346002)(376002)(8936002)(316002)(54906003)(31696002)(53546011)(86362001)(38100700002)(2616005)(83380400001)(2906002)(5660300002)(52116002)(4326008)(8676002)(6486002)(66476007)(66556008)(16526019)(186003)(6916009)(66946007)(31686004)(478600001)(36756003)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZjBoaXg0QTVEV05kYW51UFJlSHI0bVovRWVPdkV2cUJjSEkxaEJXaUZYV0NT?=
 =?utf-8?B?KzdRWmszUUJla2oxRU9DNWN3NW1wYlZyNmVKTUFrb3Y2bDUzMzN6c1ZXZjRR?=
 =?utf-8?B?V3VPNGc2NHgrYVlMektMWW1FTkV1bTQwZ0NIMGJVeDJlbEY5bGNmaHVBbTU3?=
 =?utf-8?B?OUJ4aCtvMVZCUU1sQUk3TkFTdFdPUjRseG02eWlFd2xsTlRrRCtpV1dyRFd6?=
 =?utf-8?B?RVkzV0FTT2VZSkdFei9BTzJhWHFZbmVadzNvbkZMY1ZUb1ZNbnJ6NkZHejNT?=
 =?utf-8?B?RnpndzhldUYyQkNDOVJrdWZqSjV5V3V2UjBJU3didEUvUVlDS3cvNWIxV2Ux?=
 =?utf-8?B?Sm0vdVVwc2ZVTHNadjlTNzR5WGs2ZVJTUHZFbG56NmdTalh4L29mRGF5T2Vv?=
 =?utf-8?B?Z3pWUk1CcFF6U1RDWjZuR0E3Lys4SWx3cWpMYytRSTVPM3Qza3ZPOHBXWWd5?=
 =?utf-8?B?TURidEN1Ync3ZGM2bEdqZ2NOejNhdXJDcGM5eVF4Q2p1WXp0SWlSV2w4eUNS?=
 =?utf-8?B?T3c1WjR2MStpR1lwVFBxd2FnRFo4Sm12MDJoYnVITWtKQ0lGZUMwaElRcnJN?=
 =?utf-8?B?Ky9UT3hKQS9hUVVQVHMzK2FMSllPOXBRSlI3OXJ3UjlFemFWaVErb0FjN2hT?=
 =?utf-8?B?UDJmUkZwWVo0QklRL0VqM0pCM1FpY2JxSUdjZmova09xb29xdDVJc084dTVL?=
 =?utf-8?B?eFY2dkRhV3VWN0xVaGNjR0V4dm41aTZ5OU1sK0lTbURTTmxVVS92aUs2ZEVp?=
 =?utf-8?B?QWN2aVhMR3kycnM3NHRrUS9iQ3RxTlBBZUFvdXAwZkNUQnpZN1dQSFQxeXRz?=
 =?utf-8?B?UFhyTFo3RmdOZm9sWkE4bHl1WTJTSm5UT1I4ajBOZWJ6ZExqaGdDQmtJb0li?=
 =?utf-8?B?RDFNUE9yQWx4bjQ4bDdLeFN4ZTBJMTdpNkthSEJxQ082UzBkZnRqcEdKREJT?=
 =?utf-8?B?NXJCTkhtWm5xUE9COHRZZndmUjVmQXlrWnc4d3VDajJ6NEhsR1pjd1dYWUh3?=
 =?utf-8?B?QkJWUmFYaHZIcDdqblJibXo1d3BQMVRrdWdZSk5XY3YwOTM2RldkQWtHVUtB?=
 =?utf-8?B?OUs1RXZ2S25RbnVMdm9iSVFRNzdvK252VjlqTk94UHZ4VWdpcjdPWXkybWda?=
 =?utf-8?B?L04reWFoV3kxSTJHRFE3VWVXVHJpU1UzMGFDR05UVUs4UjZsUXYvZkUxNFVZ?=
 =?utf-8?B?RGtZWkVkWlBrVUxma1JBUVVEMkFXUlNKQWtraUtxWkttNVVCdFBwS3NST1Fk?=
 =?utf-8?B?QTR0U0dMZ0o1c1JIRTVtYWhoR0E0WjlkYkRmMlRtMVhpYXRuV1pHb1F6SGY5?=
 =?utf-8?B?L1FnS3NreUNtcjZtQ1Iwbmx3ZkQxck5jeDIrbWM1TFN5d3NESTNaNFhoRXJp?=
 =?utf-8?B?bGJ4Yyt2S0dVRTFkaHRZY0RCc1B5Q2YrYnRaWVF4MlAwazNGT2JSTlAwVXd2?=
 =?utf-8?B?WXpVZXdpSjE0aGJBWkM4QmFtNnlwVFdFOEYxZ3FUNVkyN2gwUTRDOXg2R0Vv?=
 =?utf-8?B?SzZ2Nzc2WGhMN2gwM2tBV2FyNWxFNHUwVERrQmRDK2lRaEo1bTBVZEwrSS9T?=
 =?utf-8?B?SjluK0xCb1Bsb3JjZ0RIZXNld0lVb0VnbWdlMVNkdkdaMVBkWEJhd1BiaWRO?=
 =?utf-8?B?NnY4M0hYd2R2d0xGWFZWNTltZW5EOWNHdzFJUGZiQU8xWEpqNlQ1cVdjcnN6?=
 =?utf-8?B?dXpGS0lWYXdkYlZBeU0vOWRSSG8vWU9zd05BN1BZQTZUemhIMm95WTlKUEF5?=
 =?utf-8?B?SjZqeDNBN0pQYzQ5MmF3YkhhQ0ZlZlhneEJOZ0VDQy9zZGZXMldjdTFFaGRx?=
 =?utf-8?B?T1RzK2EveU9vOU8wdFhxQT09?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 80fa4375-71bf-416d-2a00-08d92fb51052
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jun 2021 04:21:36.0841
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PohRbuVQQ6VBbMtDzWKO4aifBJ7DaZeum+Q5szmAhpsRF6ndAzDtM7kDkY+51K9p
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB4418
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: vF92IO_dF5KjVI2mIJaEkiigtZetKwG9
X-Proofpoint-ORIG-GUID: vF92IO_dF5KjVI2mIJaEkiigtZetKwG9
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-06-15_03:2021-06-14,2021-06-15 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0
 mlxlogscore=999 mlxscore=0 bulkscore=0 priorityscore=1501 impostorscore=0
 suspectscore=0 lowpriorityscore=0 malwarescore=0 spamscore=0 clxscore=1015
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106150025
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/14/21 8:33 PM, Alexei Starovoitov wrote:
> On Fri, Jun 11, 2021 at 3:12 PM Yonghong Song <yhs@fb.com> wrote:
>>> +struct bpf_hrtimer {
>>> +     struct hrtimer timer;
>>> +     struct bpf_map *map;
>>> +     struct bpf_prog *prog;
>>> +     void *callback_fn;
>>> +     void *value;
>>> +};
>>> +
>>> +/* the actual struct hidden inside uapi struct bpf_timer */
>>> +struct bpf_timer_kern {
>>> +     struct bpf_hrtimer *timer;
>>> +     struct bpf_spin_lock lock;
>>> +};
>>
>> Looks like in 32bit system, sizeof(struct bpf_timer_kern) is 64
>> and sizeof(struct bpf_timer) is 128.
>>
>> struct bpf_spin_lock {
>>           __u32   val;
>> };
>>
>> struct bpf_timer {
>>          __u64 :64;
>>          __u64 :64;
>> };
>>
>> Checking the code, we may not have issues as structure
>> "bpf_timer" is only used to reserve spaces and
>> map copy value routine handles that properly.
>>
>> Maybe we can still make it consistent with
>> two fields in bpf_timer_kern mapping to
>> two fields in bpf_timer?
>>
>> struct bpf_timer_kern {
>>          __bpf_md_ptr(struct bpf_hrtimer *, timer);
>>          struct bpf_spin_lock lock;
>> };
> 
> Such alignment of fields is not necessary,
> since the fields are not accessible directly from bpf prog.
> struct bpf_timer_kern needs to fit into struct bpf_timer and
> alignof these two structs needs to be the same.
> That's all. I'll add build_bug_on to make sure.

Sounds good to me. Thanks!

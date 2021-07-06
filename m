Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E8743BDB2F
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 18:10:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230263AbhGFQNN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 12:13:13 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:40670 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230232AbhGFQNL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Jul 2021 12:13:11 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 166G67wt031845;
        Tue, 6 Jul 2021 09:10:17 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=c9x7bPF8kTMJ2vlWrNFNYwxwz888YHfXTr0+uqW+SII=;
 b=Hc8zCczZ1u8LmY6Gr2ODDCHk69Jvw/vFBRM3BJ6eeyRF03wzkxxvq8bE47RTjgMhaLdf
 Sj5r/Au9HR9GkTV/JQcz228VXUcMG+Zvv+ieP408e92DKl7F/Ik7THvZcQDX6vgoy++d
 A5NU8xArj0JDnJSsj29cgVFJiSHsLfU51DQ= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 39mfunkd86-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 06 Jul 2021 09:10:17 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.172) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 6 Jul 2021 09:10:15 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NF0DY38qrF5ipjmwdHrMSS3aZhQPYKSS7+MXyzVy0iKq4TcmfK/GGf/spmkTOs071eT8ie6RIUtLQwTxaS2lboChBH8vgAyoQ31+ebkBGW+LBGsMzAkyRC/uaFvVIjMCKjc9F48USzBFsv3DSQsBatgNLjzoru4UXtRJOOva79CFSxWM/AkYipPwd74c4ibZR7gtE2bRSq0RzV3pW+Uz0OyLIYOccxJA8OxqMzhmPhagRrTzJm6qZPSK4exxO4f0PfXScSVSAFHahSyygXiH9c7HJcqU5LxAAD/nn9nOZqlN9+rVwhupYpWPqKrr5RO4NL1llC+x47JCCXhIECz1cQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c9x7bPF8kTMJ2vlWrNFNYwxwz888YHfXTr0+uqW+SII=;
 b=mMF4z+W06DZxtMwn9Zadg9xpoKJwLDrrKQoCcOtjmyKpqHaySLSRCSUUJXs0LTCwLEIIgggAr5v4K0Lo39w4wS9Aw4zgr5nkmJtq6767Ko9VmaZPLPTL+pZJazuTtfl3nIO4YKxbrap8a1XiXDd4qwj87I6kVpFc8Zm73IBnOMeEzhVjpZghCnPeL4dV6VQj5esBL18ZHA9pAzCqViZnjq5M47hPJY+jdpNNBRNLgYxUSv/Q+V+62PaJn/xumZFjg6SwEZ5CcB8yVIE23i5D2emuMqLZm0As2/g5mMZeWmHIUwNSYvIYUc6ypFBXsyV6oPPk8S3yGZSsVlGUlyH4wQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=fb.com;
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SA1PR15MB4740.namprd15.prod.outlook.com (2603:10b6:806:19f::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.19; Tue, 6 Jul
 2021 16:10:13 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::d886:b658:e2eb:a906]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::d886:b658:e2eb:a906%5]) with mapi id 15.20.4287.033; Tue, 6 Jul 2021
 16:10:13 +0000
Subject: Re: [PATCH bpf-next] libbpf: ignore .eh_frame sections when parsing
 elf files
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
CC:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
References: <20210629110923.580029-1-toke@redhat.com>
 <ac14ef3c-ccd5-5f74-dda5-1d9366883813@iogearbox.net> <87czrxyrru.fsf@toke.dk>
 <e8385d06-ac0a-de99-de92-c91d5970b7e8@iogearbox.net> <87k0m3y815.fsf@toke.dk>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <ebd98acb-1b54-cf8f-19cf-13ba3d575c27@fb.com>
Date:   Tue, 6 Jul 2021 09:10:11 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
In-Reply-To: <87k0m3y815.fsf@toke.dk>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BY5PR13CA0019.namprd13.prod.outlook.com
 (2603:10b6:a03:180::32) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21c1::19fa] (2620:10d:c090:400::5:e2df) by BY5PR13CA0019.namprd13.prod.outlook.com (2603:10b6:a03:180::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.8 via Frontend Transport; Tue, 6 Jul 2021 16:10:13 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b699366d-67ea-4f27-5bb9-08d940988988
X-MS-TrafficTypeDiagnostic: SA1PR15MB4740:
X-Microsoft-Antispam-PRVS: <SA1PR15MB4740AAC1D75B673EACAA30A0D31B9@SA1PR15MB4740.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: C00vhzO9JlXyhtu/yJif3B0szTtOKps9HCPWjtwPK+ZV6ubGD5KCXJwCyd1ihvLZaduIAhz+fj1bxnod6EYyVriSOJxsTj3/KmJveq2tDXyOXWl4rfFuA1FsTOfZD0R3TveLi3vGjRVVgVVHiCM2/n3kAMKrAYpMFD4dVFxs4SDKBKZ9j2hj0X7FWj0aFXAXO0ecXZQr3OVXEhv/dEw/4j2JjRTBVQyjSR3QAJVY3vXmwNFlDXnlvI7oSJEzdZ/Le7YS9pWc6wRhOIcffI6eobcGaE/J58xWWpaFHMfHKJpIeYZCB0+PK7ZyBfeG+rYGc7wxqS6Ux+XctlAT0FKDYbkmFaxN5mw4uyi3bsAa2NCNIDBDrhideJxBWPWiv40FzqMyuu7Ke4dEFUN1KDpXmmRl95HbRQXK9jEJi645CpDP1RhYxuIujGJwitvMmFtnIvl0laamER3B/ommY+8dp5Wp4k60bN7poq16p3QuHefn7BhxHhwBblV12PG3ZtduA+rIytvZX3E8idAlPDb7gvW+OnIkhVRSaFpbw/4X1mwXPFWEBNIFpmksKzHWGSwvZA+Ry2Nw6xKKBSBPEHKGXDfHxm15t9VLBRT+PS70Z7w5Q1OQlq7qx212xA84rygrwSetgUwS/TE5dDUclsCZh3XOB9SIiArTk/NrGYMskL5ilmOpj+ugPjEEFcSYZBMItlVarbHlIIATI2I+kBJTn2/dIYWSWk/9ZT1dgjX0sNjI7zuGkXm5ksB5kyMzcK+j5YU1s3Qrp/DpUYau+Y2nBg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(396003)(346002)(376002)(136003)(366004)(5660300002)(478600001)(2616005)(38100700002)(36756003)(66556008)(66946007)(8936002)(31696002)(66476007)(52116002)(86362001)(31686004)(8676002)(4326008)(53546011)(186003)(6486002)(316002)(110136005)(83380400001)(2906002)(142923001)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TDBSVjlFVVdWWjFwczkvQjkvbGcyeGRzZjMranRvMTRRR05mQVhGbGp5bitG?=
 =?utf-8?B?TFZ5UTcxVDdWd2xFUms3bHlPV3IwMDZpM1FtZ1YwSi9tWjF4WmdrN3B0V2NE?=
 =?utf-8?B?bC8wM1ordFhiYXlUZ3k2YUtnM0JzRzJiWTNSRjJvM1F3QkNsN3B4dUk2U2kx?=
 =?utf-8?B?UE8xeVMvNEpET3NTR29IeDNMYkV4bGYzd1A1bVYvOWZacVZhT3hoME1ZamtW?=
 =?utf-8?B?bVN5dXJGWE9ZWUY3TGtLN3ZHQVh6cE93UjRycFJkZkpqN2l5QWs2QzZCQjdD?=
 =?utf-8?B?QXp2MGdjZUxVTHRRZGJROXFZd3JuaXJUMmxteDRuSlFHRS9GVlF0S2UzL0xD?=
 =?utf-8?B?MjZKa1pkZ05NbGIyNjYveTdRMUJPbVRUVWx4aDFma3pwMko3N0NvcVRlRE5y?=
 =?utf-8?B?ZmhtL2g0bGdWQXo3WXBzRFptYUgxSVEzRXpQdVoxUDBRTUNQNW9IRHJEdk96?=
 =?utf-8?B?d2dwdmpRNUNWQ3kwY3ovcWJ5V0IwNTdtd1RzM3duS3I0bHpsWlhvWFh1dUNa?=
 =?utf-8?B?N01ZU001VUU2WSttM3NuVittVVFBNmRPWHV5UHlvbnU0NHB3L3JtUTlta3NS?=
 =?utf-8?B?ZzBLWUp4ZTN3WTlnUCtJL2s0dzJSTzhkcGxVWlRFVUN3dXJ3UGVsbWVwQkFo?=
 =?utf-8?B?Ty9nZy9sTWVFVTlRdWt3YXBtbVBmRDhiV2c5eC9SdTZCaDVQTHE2SEgwTSs5?=
 =?utf-8?B?R1JHbVFvVFFhL3R6T3FwNUtpYVRlY2VCQ2U1Q0MrTFFxTFJlNnBjeitwNGlJ?=
 =?utf-8?B?VmE0bUQrWFNEd04wZCs5RDhZSUU1VjlORVF0Z2pjVW9OelVscjg0REJPLzQ1?=
 =?utf-8?B?TWM4ZDVCaVo3aEpwOWxqQjNibkNIelNLZXpUdVNNWkFRNnpUd2tYUnRnSEFI?=
 =?utf-8?B?Z1Vpc3VJNS94VEdFUjFuQW02OHdWZmdLUzErQXFHRHRLYytiRTZhYWltd0ln?=
 =?utf-8?B?NGRQNExuclFySGZHUVo4cjVHWVgzNWVJNW8zMjRxWDJOVHIrWC9SSXNwWTc4?=
 =?utf-8?B?c24yWS9OY0k5T3dONUxMRWhkd1ZJc2l6NndJWno5bFBJQXdEODRvU1Z1b3NK?=
 =?utf-8?B?MFB4VG5odElKQUIxbUNHS1BtUzRrbzJiK2w4d0NXbTRUMlM1T2YwdXV4R2tG?=
 =?utf-8?B?d3Yrbll2SUtpdDljdkdUaXFwbUZLc0dTaWdWc29FemNnODV2L3Awa0hPOFo1?=
 =?utf-8?B?VUlUMk9tcEFHVHVmekdJd09aM0Rmei91M0hTWG1HRzUyQkdIMTl0M1R2UHJ2?=
 =?utf-8?B?V084Z2hyUzdYWTlWeVdjczlsbHViQ0Y3bFNpUFdvcitBVEt6RkZUYTVMeENW?=
 =?utf-8?B?U2hMeTkzVkdWclJORWlnbERnem8rd2NHenErQ0kwNnY5M0lHMnNDVUxsRHJl?=
 =?utf-8?B?SFBOdlR0WCtGWmpGUDF5aTFOU0xPYk9uSll6bmt0b3FSNHg3ektScjhwYmNQ?=
 =?utf-8?B?VXhjK3NDa21YakUrZzJOKzYwSUUwR1I5aW1mVjlyU2VtYXJlSU8zME5kd2lI?=
 =?utf-8?B?UkZXc0VvVU1wdk82TGV2UzRESFR1WWV1UTZNRm9uMFFhNk41NzBZdHFWUG55?=
 =?utf-8?B?VUZnZnhvZnB2TGVUbjFSbjU2MHB3VmRhVUpVVXNYd2pxNmFtMGVSS053ZGhr?=
 =?utf-8?B?RStJMXNyTUhlWElmdHFsemI3YlF3TXBuQm5FbE1YVi9NU2IzZklHTWhYNG9k?=
 =?utf-8?B?MXpRZFZIUjFWYnliUlQ5R3lPVjBVSkxpbU9CY0g5RHlKWHpUcE9jUTRsOXBD?=
 =?utf-8?B?bmZBSEk5UExiU1NCdHl2S3pyVVZRMXRSWm5hVXlGUlhneGdrZlpGV1Iyam1C?=
 =?utf-8?B?NWJtb2wyd29vK0tjeVBCdz09?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b699366d-67ea-4f27-5bb9-08d940988988
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jul 2021 16:10:13.7326
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CAdQrS4ZUGx85XPg0TDYgRr42ThRM19Qqkz26d/w802Z3kREYe+kpmL9ggJh1dOj
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB4740
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: Z1KxxrguTlqbU9bMsViCmOLiPOvlkRhg
X-Proofpoint-GUID: Z1KxxrguTlqbU9bMsViCmOLiPOvlkRhg
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-06_09:2021-07-06,2021-07-06 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0
 mlxlogscore=999 bulkscore=0 malwarescore=0 priorityscore=1501
 lowpriorityscore=0 adultscore=0 clxscore=1015 impostorscore=0 spamscore=0
 phishscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2104190000 definitions=main-2107060075
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/6/21 4:51 AM, Toke Høiland-Jørgensen wrote:
> Daniel Borkmann <daniel@iogearbox.net> writes:
> 
>> On 7/5/21 12:33 PM, Toke Høiland-Jørgensen wrote:
>>> Daniel Borkmann <daniel@iogearbox.net> writes:
>>>> On 6/29/21 1:09 PM, Toke Høiland-Jørgensen wrote:
>>>>> The .eh_frame and .rel.eh_frame sections will be present in BPF object
>>>>> files when compiled using a multi-stage compile pipe like in samples/bpf.
>>>>> This produces errors when loading such a file with libbpf. While the errors
>>>>> are technically harmless, they look odd and confuse users. So add .eh_frame
>>>>> sections to is_sec_name_dwarf() so they will also be ignored by libbpf
>>>>> processing. This gets rid of output like this from samples/bpf:
>>>>>
>>>>> libbpf: elf: skipping unrecognized data section(32) .eh_frame
>>>>> libbpf: elf: skipping relo section(33) .rel.eh_frame for section(32) .eh_frame
>>>>>
>>>>> Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
>>>>
>>>> For the samples/bpf case, could we instead just add a -fno-asynchronous-unwind-tables
>>>> to clang as cflags to avoid .eh_frame generation in the first place?
>>>
>>> Ah, great suggestion! Was trying, but failed, to figure out how to do
>>> that. Just tested it, and yeah, that does fix samples; will send a
>>> separate patch to add that.
>>
>> Sounds good, just applied.
> 
> Awesome, thanks!
> 
>>> I still think filtering this section name in libbpf is worthwhile,
>>> though, as the error message is really just noise... WDYT?
>>
>> No strong opinion from my side, I can also see the argument that
>> Andrii made some time ago [0] in that normally you should never see
>> these in a BPF object file. But then ... there's BPF samples giving a
>> wrong sample. ;( And I bet some users might have copied from there,
>> and it's generally confusing from a user experience in libbpf on
>> whether it's harmless or not.
> 
> Yeah, they "shouldn't" be there, but they clearly can be. So given that
> it's pretty trivial to filter it, IMO, that would be the friendly thing
> to do. Let's see what Andrii thinks.
> 
>> Side-question: Did you check if it is still necessary in general to
>> have this multi-stage compile pipe in samples with the native clang
>> frontend invocation (instead of bpf target one)? (Maybe it's time to
>> get rid of it in general.)
> 
> I started looking into this, but chickened out of actually changing it.
> The comment above the rule mentions LLVM 12, so it seems like it has
> been updated fairly recently, specifically in:
> 9618bde489b2 ("samples/bpf: Change Makefile to cope with latest llvm")
> 
> OTOH, that change does seem to be a fix to the native-compilation mode;
> so maybe it would be viable to just change it to straight bpf-target
> clang compilation? Yonghong, any opinion?

Right, the fix is to fix a native-compilation for frontend with using 
bpf target as the backend.

I think it is possible to use bpf-target clang compilation. You need
to generate vmlinux.h (similar to selftests/bpf) and change Makefile
etc.

> 
>> Anyway, would be nice to add further context/description about it to
>> the commit message at least for future reference on what the .eh_frame
>> sections contain exactly and why it's harmless. (Right now it only
>> states that it is but without more concrete rationale, would be good
>> to still add.)
> 
> Sure, can add that and send a v2 :)
> 
> -Toke
> 

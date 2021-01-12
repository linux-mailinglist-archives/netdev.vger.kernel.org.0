Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88CE92F255A
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 02:18:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727735AbhALBQ5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 20:16:57 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:50782 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726246AbhALBQ4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 20:16:56 -0500
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 10C1E8mM014889;
        Mon, 11 Jan 2021 17:16:00 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=o7QtDiUcRD5WmoNYgi/E2lgMLwKJQ4Ukau/+bxf0gKk=;
 b=KV4U+KM3LOvCHE5l7XimzDU5+d+seu3BpR+RbVdQvobtDNCChkjECQp/L7Y28qvNPMwj
 zS3Z5xg96U8as1fnQe7IJ2nnuJ4oBM9OgSoFFzmIhCuZ+vYKSt8Ex+jWNOORxbRfqhes
 z5KF9fUVkqAvwSw2bRyQmXaBkmKea7z/kFk= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 35yavt2sq5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 11 Jan 2021 17:16:00 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 11 Jan 2021 17:15:59 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k6WrR6KiX8sXOPgRbI9rTdGOX8rPqbgp2Zaweq3r/kql0yusQ6F1ZA9dZ3Em5KP6858HpuoSqNM0nKW+ZYtBxcZK/H8duy/sipJ9BVMxp5Hj255gAVVacTOYEQYea2vdEnrGggvsJ5vJOXxBoXHD8Z79dwE+g/Pm35mZBcJBxIngt4nZy0+pUZcKpt25DuDGmNf1UHZiXSUI+qqsz9uq+nk/vo703DE3mtnrz1FTeINQZbxgh4dutyB33WuUUpDpdrVIeOJLU6MisxLA+B7LAKh33tB7949jCkSLdTvmgQ6/VUEuIxcuklNzkQVDHhS0EDHWIO7pz1ASZ65VqdzAQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o7QtDiUcRD5WmoNYgi/E2lgMLwKJQ4Ukau/+bxf0gKk=;
 b=ASfPPPiUKN042d4TT3styqcfMOC8hdR8hNGTtB0l+yDZLxnLAKYpdEsn0QCyqjozebACwH+sFvXHFxsVcG4hyHLXqFOBVXRJVva4pc81o/7AzTZ+POocFnXB35UzP9/xKNS+RQtCZ8rCAWn5AXDUol0l7QZKS9ijL3IG7N6LkxnzvZN7jF4iQIQMdA59bM7J/4TW2VxnDXsutMvhrScI8xI4AVcA0su78teY55/Vpfu8AmX8h8ocjXGj7qbN80m1OXSTdRc3/I8IDeILKJQSUfN501uPDZwq3sd1w7G6ljmUdekcc1g9e93sG1VY7ET9w7QRL/w3pwyZk+SdxfmxCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o7QtDiUcRD5WmoNYgi/E2lgMLwKJQ4Ukau/+bxf0gKk=;
 b=NwIv1yTb6vtQqsR/eikySATN8EEtL16T089RmAL7ibJzxhrWOyFQmP8lIaU3GJEW4xs+o8Q/+mlTtHiFOem5armg+Amg8RWmaOxKLRsVKwg36YH1yf8OaFu0KykouQS4KRfTWorYaR35MSs6mimwfA1I6fBxnsioCR3q3s+2/1w=
Authentication-Results: kode54.net; dkim=none (message not signed)
 header.d=none;kode54.net; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB2840.namprd15.prod.outlook.com (2603:10b6:a03:b2::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6; Tue, 12 Jan
 2021 01:15:58 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::9ae:1628:daf9:4b03]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::9ae:1628:daf9:4b03%7]) with mapi id 15.20.3742.012; Tue, 12 Jan 2021
 01:15:58 +0000
Subject: Re: [PATCH bpf 2/2] libbpf: allow loading empty BTFs
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Christopher William Snowhill <chris@kode54.net>
References: <20210110070341.1380086-1-andrii@kernel.org>
 <20210110070341.1380086-2-andrii@kernel.org>
 <e621981d-5c3d-6d92-871b-a98520778363@fb.com>
 <CAEf4BzZhFrHho-F+JyY6wQyWUZ+0cJJLkGv+=DHP4equkkm4iw@mail.gmail.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <31ebd16f-8218-1457-b4e2-3728ab147747@fb.com>
Date:   Mon, 11 Jan 2021 17:15:54 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.0
In-Reply-To: <CAEf4BzZhFrHho-F+JyY6wQyWUZ+0cJJLkGv+=DHP4equkkm4iw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2620:10d:c090:400::5:7b7c]
X-ClientProxiedBy: CO2PR04CA0059.namprd04.prod.outlook.com
 (2603:10b6:102:1::27) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21e1::190b] (2620:10d:c090:400::5:7b7c) by CO2PR04CA0059.namprd04.prod.outlook.com (2603:10b6:102:1::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6 via Frontend Transport; Tue, 12 Jan 2021 01:15:57 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0df25ab5-f196-4711-cc5e-08d8b6979e06
X-MS-TrafficTypeDiagnostic: BYAPR15MB2840:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB284001DE6CB47DE1FCC234D7D3AA0@BYAPR15MB2840.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +6Ar0Bm4dVATDs3vAE0wZ7EQlOdcYaWaZ1zYiy4qoekZGzembP7VTi3WftGvhJza9lquk2vmd17goi2VE9HnWuOclmxNy9BIsuGWpVX1qHa2fIzkuS3eHUpP2J5m3KKrjGw1kHzZMhFEjvlOo2ftTMIbm5pslgvoIpDsvtYSnulkTUtO/gV1GrKcrLWsTZepWn0m9VznXxK8l7eUMsFfZ7fg9RZiB/RHXZf1EOqs73AwGDrmEKLYV6vUa5S4mMVhq6+aUgRVdJmIdd53jioYR1PgK/+h6/nv5jVfk5U6my5P19HF/ZjjkMhhiaSM6QYcWhJ5bsm2U8V2eFNVSX+8CC+vCdHn56vmB8MX8/DXRCeY0GYiX2XfEmYfpNzRw8tkhZ2+liL2URgOXKFrxvVx4c3TR0Gea75rNRS5crUYVT8rFzgfL/c1OKbgNRwFtgnHauOmndMWmtgy4U/aJASl9c3bkcKsn80eslqqrmN6yQE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(376002)(136003)(346002)(366004)(396003)(83380400001)(16526019)(478600001)(186003)(86362001)(2906002)(66946007)(53546011)(2616005)(31696002)(52116002)(8676002)(8936002)(6916009)(6486002)(36756003)(31686004)(66476007)(54906003)(5660300002)(66556008)(6666004)(4326008)(316002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?R1pQemJ5MHo1SkFIMENKb0huYXkxRmdNcVNGT1ZlTkdUM09YUVh5am1hNElF?=
 =?utf-8?B?M3pkbVRpcnUvcGZkVEdaZ0tvM3hXOGgyUVA0UEc0UEhBL1FPcFpodi9TeXpu?=
 =?utf-8?B?OGk4eGpoc2pHMGR6WVMvanBlalhYRlRwQld1blpsMDFxWWoxUTJRbStCNFZy?=
 =?utf-8?B?SUhkb3FJZlRrWkl6Z2dnRmdOazRmai9zeFBrVElxWlhzbXJ3Z0RNR1NlVk5S?=
 =?utf-8?B?ajVNNXgzcjBpdFBaWE1LWk9mclBXaHArSloweHdnVGYxOUxHNkFqbEFlSjkv?=
 =?utf-8?B?bVJEaEdtWGRVV1Q3WWRHMEJzWTVlSUFRTXZWOXRPVTBYS0JvMzY1V3pRanZn?=
 =?utf-8?B?aG94aHQ0aFJHYXZ0cEM4eDBhVlpWemV2Zm0wR01ML0dYS3lqYy9TMUdzVEEw?=
 =?utf-8?B?UHFVNkYvQXNMTGFtVll1aTl2RXRtV0xCUFVKRkZiMHI2K0hldFFvcUlCTGV4?=
 =?utf-8?B?alpPa2NxRlNieUh0SHdtMXhNNHRPdllGYXVHVEJOZkR2elFhdGhuWUM3ajdp?=
 =?utf-8?B?UnlCU2RIVjVheUl4dWF3YmRIWjJ4NVVkYVBxYlVYS1EwanhqM3pmZy9Vd3dE?=
 =?utf-8?B?dUh5TEtoazJhd1pWVklVQjExZmZ4Nk5PTmNmZW04N2xQU3Zoczk4WjdNU2pq?=
 =?utf-8?B?Y3VNdU1FNHRNeWdibWV0S3lXTXVtcmtxOXE2bkdQRzNzNWdyN2dGM2V1YkpH?=
 =?utf-8?B?M3FueVduREZtRUcrWGdRenpTWTRaQmlpM0poWWtTbC96TnNWczgrc3dDRnNj?=
 =?utf-8?B?a2NZT3RBMkdPS0h0TEZJc1R1YTE4OEhseldSR0N1ZVNERjZaUUhuTy8wS2Fs?=
 =?utf-8?B?RUxOVVg2YXZSeTZacXhIdENLTGFra3kzdDdPOVE5LzlBTWc1dCt2WmpDaEVk?=
 =?utf-8?B?VkQyMTZabWpmTmI1K3ZhTElPZUtzNzAxR1d1OExNVEloVnZ6OVRJNWFTVmNL?=
 =?utf-8?B?bVI2NTI3NnZ6OTNwMWZBNWlTeFA3NlFCamtJdStRT3ordTZKTU42ZmprUTBu?=
 =?utf-8?B?NjloRTJiVE5pS0luZ3pORTVuZW1zTlBENUN0QXByWDdNQnd6VmFFT3JJVWh2?=
 =?utf-8?B?YS9sNFJJMmZvZ2U3SmJDdGNYeXhOdGd1cks0bDk1OUw3UDNCZEt0YkVEMTln?=
 =?utf-8?B?RE4vazVBNFFoZnVTbXVyN3JpbUNPTUNuTW9vZ3U0LzVjZ0lxZitMdmdyWFUz?=
 =?utf-8?B?eXoxaTZwdml3N1FMUnh2cGVzNWh6MDhkNnVHb01mR1FyWVpwQzZpRVNudW9S?=
 =?utf-8?B?YmRKRndtZm1ON3RFM2xrdE5vVzFuTE1DZlAvekZjVldsUWxvbTYyNFN2NWZ2?=
 =?utf-8?B?Nk9SVmRtOXY4TWdzVTY5R21DdnBoelpsZjRMTndMa1JIdkRHeG12TzF4L1VO?=
 =?utf-8?B?aUEvUUFJM1NaOUE9PQ==?=
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2021 01:15:57.9698
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-Network-Message-Id: 0df25ab5-f196-4711-cc5e-08d8b6979e06
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5VcVKsXNmtTeQ0CBKD4DKDHSGauJ5f55i8PfMacWZcCV/Bgsyl4wfclt30IDy7VH
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2840
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-11_34:2021-01-11,2021-01-11 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 suspectscore=0
 clxscore=1015 priorityscore=1501 mlxlogscore=753 lowpriorityscore=0
 impostorscore=0 adultscore=0 bulkscore=0 spamscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101120002
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/11/21 12:51 PM, Andrii Nakryiko wrote:
> On Mon, Jan 11, 2021 at 10:13 AM Yonghong Song <yhs@fb.com> wrote:
>>
>>
>>
>> On 1/9/21 11:03 PM, Andrii Nakryiko wrote:
>>> Empty BTFs do come up (e.g., simple kernel modules with no new types and
>>> strings, compared to the vmlinux BTF) and there is nothing technically wrong
>>> with them. So remove unnecessary check preventing loading empty BTFs.
>>>
>>> Reported-by: Christopher William Snowhill <chris@kode54.net>
>>> Fixes: ("d8123624506c libbpf: Fix BTF data layout checks and allow empty BTF")
>>> Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
>>> ---
>>>    tools/lib/bpf/btf.c | 5 -----
>>>    1 file changed, 5 deletions(-)
>>>
>>> diff --git a/tools/lib/bpf/btf.c b/tools/lib/bpf/btf.c
>>> index 3c3f2bc6c652..9970a288dda5 100644
>>> --- a/tools/lib/bpf/btf.c
>>> +++ b/tools/lib/bpf/btf.c
>>> @@ -240,11 +240,6 @@ static int btf_parse_hdr(struct btf *btf)
>>>        }
>>>
>>>        meta_left = btf->raw_size - sizeof(*hdr);
>>> -     if (!meta_left) {
>>> -             pr_debug("BTF has no data\n");
>>> -             return -EINVAL;
>>> -     }
>>
>> Previous kernel patch allows empty btf only if that btf is module (not
>> base/vmlinux) btf. Here it seems we allow any empty non-module btf to be
>> loaded into the kernel. In such cases, loading may fail? Maybe we should
>> detect such cases in libbpf and error out instead of going to kernel and
>> get error back?
> 
> I did this consciously. Kernel is more strict, because there is no
> reasonable case when vmlinux BTF or BPF program's BTF can be empty (at
> least not that now we have FUNCs in BTF). But allowing libbpf to load
> empty BTF generically is helpful for bpftool, as one example, for
> inspection. If you do `bpftool btf dump` on empty BTF, it will just
> print nothing and you'll know that it's a valid (from BTF header
> perspective) BTF, just doesn't have any types (besides VOID). If we
> don't allow it, then we'll just get an error and then you'll have to
> do painful hex dumping and decoding to see what's wrong.

It is totally okay to allow empty btf in libbpf. I just want to check
if this btf is going to be loaded into the kernel, right before it is 
loading whether libbpf could check whether it is a non-module empty btf
or not, if it is, do not go to kernel.

> 
> In practice, no BPF program's BTF should be empty, but if it is, the
> kernel will rightfully stop you. I don't think it's a common enough
> case for libbpf to handle.

In general, libbpf should catch errors earlier if possible without going
to kernel. This way, we can have better error messages for user.
But I won't insist in this case as it is indeed really rare.

> 
>>
>>> -
>>>        if (meta_left < hdr->str_off + hdr->str_len) {
>>>                pr_debug("Invalid BTF total size:%u\n", btf->raw_size);
>>>                return -EINVAL;
>>>

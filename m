Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 083661C64EF
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 02:15:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729565AbgEFAO6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 20:14:58 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:40224 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727989AbgEFAO6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 20:14:58 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0460EjgJ010888;
        Tue, 5 May 2020 17:14:45 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=nW4jXnIdb2DvIasZSoDeQxw+dpIV5dD8YZEQOLgoWlU=;
 b=OL6nWQuHaxiPyAe41jVu/eLyyEoCkJPiYVqp8PiuBDT7NsR1gnQQGJewj82fhLf65mNj
 3CZJ3ftkiB8eCHaKdsmqyqCBVqzH/Mir+hSZyMfjdZEGxfy0p3mrv6b8tgHTdFnFoC2I
 0T/QZdbi1+ZTtjg5npdRhn2E29Cl1wChMX4= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 30s6pg9gp9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 05 May 2020 17:14:45 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.175) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Tue, 5 May 2020 17:14:08 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RlVWkQ9DeL8Me7H0dvKbKtpSpYtEaTfT6af2PJb/V/CNGfyan9cxHhTDYb+E1verurcw4O+FegovxJzSXsBTvb8Z+Kxck7K9Ag+TCsYP5pidm23fypw8UwHRgVyI2bEI4toOrlN6MxWZ34MiA+jQ2LVFXTuBQP4Bh932u/DE40e3C9EWu1YmZ9tRHna+cr8wS6veXOKzMxmczaoSNuwvntgMYQL0WnPD2N/Uc7UM+izIrA3jkGp2Awvx3fJ7pbABEgFcsWOji847iZisThzJgBI/CTETl5c+e93X8SesO62rvG6yCxyrOaa+9vLC/brRy71ulUTQUni03B4hZTXb3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nW4jXnIdb2DvIasZSoDeQxw+dpIV5dD8YZEQOLgoWlU=;
 b=RH8j9VcUFLPKtFL85EWuqpDZ/cRQO1d/pJa3vXtTGyot/fS5UZQEDrQUhlk531TBZia0wLcAtzIiCDBtQhOnEwuA0m8b374VBAUwMFJ2jNa/8c3DXcLjAjnfwDka4sIbyes2btbA7K6FJldeBC1XdFwF9T8cuR6atj+mNWOGlEMyJv59FjaShyJ7RXCw5ED/FCDfOVSAQ+23M/vKGIEKG/TkNWJTED416urmss5Yvnwdwq7b8k6rI8NA0tg7m70bUSZjhZ6n+BN0uRoE+EmHrjKptIvMC/aJO6Qp81ZcIXkNx/+DiRq8twaf5EJo71+Jb8JekKqkgsMNKtKYjmwjfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nW4jXnIdb2DvIasZSoDeQxw+dpIV5dD8YZEQOLgoWlU=;
 b=HLxN/ylEgOLcjS4NKsUc9ZgsGQajimK1lB+qvaZkk8gsKsCpt8Ybmqcd5VqBFMxKGdtxwE09LDzb/r7YEXnx/U/gUEOZVlGBcDUDPjpf2JSJuslNwu0IFCk3PTPWmOHiVkz3oU3Whi6sKaMSaC92ZT6B3KYBPFGktjv0wV0V/e4=
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB3448.namprd15.prod.outlook.com (2603:10b6:a03:103::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.19; Wed, 6 May
 2020 00:14:05 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::8988:aa27:5d70:6923]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::8988:aa27:5d70:6923%5]) with mapi id 15.20.2958.030; Wed, 6 May 2020
 00:14:05 +0000
Subject: Re: [PATCH bpf-next v2 03/20] bpf: support bpf tracing/iter programs
 for BPF_LINK_CREATE
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
References: <20200504062547.2047304-1-yhs@fb.com>
 <20200504062549.2047531-1-yhs@fb.com>
 <CAEf4BzYxTwmxEVk6DG9GzkqHDF--VqvZWik0YJigzdrn3whcXA@mail.gmail.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <e71a26e7-1a78-7e4d-23d6-20070541524d@fb.com>
Date:   Tue, 5 May 2020 17:14:03 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
In-Reply-To: <CAEf4BzYxTwmxEVk6DG9GzkqHDF--VqvZWik0YJigzdrn3whcXA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR20CA0011.namprd20.prod.outlook.com
 (2603:10b6:a03:1f4::24) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from MacBook-Pro-52.local (2620:10d:c090:400::5:f717) by BY5PR20CA0011.namprd20.prod.outlook.com (2603:10b6:a03:1f4::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.26 via Frontend Transport; Wed, 6 May 2020 00:14:05 +0000
X-Originating-IP: [2620:10d:c090:400::5:f717]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 20000bd4-2fff-438e-9165-08d7f1526398
X-MS-TrafficTypeDiagnostic: BYAPR15MB3448:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB3448CDF76C77104A99516CB7D3A40@BYAPR15MB3448.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-Forefront-PRVS: 03950F25EC
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pevda1yVpus0jnC0rD0SJItm5p3GFrv6njwMNu54yIc3FOBWdcfEFEa23mjKmtPftQNaOnE74KpmLEbPruvvYkEpZayA+x+hfpZEKuN5gNIBf7oY6xKOHcMIcHVXdfVH1DyJ5UrqXr0FYBeR25zA/0jMAUclxCExKfxCMuwd0a+LeHUUfRM8xHZhs2cRIjidzHOOoVJcDlOEKRwO02WTXNIwjmtncGX5JC8v2F29tTYyKGHJEzJYXsdTQwAYh542NvvK9Uzhp8mGOj5BzpzhvpSokgCGMaO/u1v5zLS5KfpOtgEOz/kLLyrVlvIVDeh6N0Q4jd9DrZbeZ0ew2+aO9lRiZT66fIhp4oqIwEMfHJQZREz6YeRvEcs2hK1R395KwkYhck4xFIrdkPtm+QtjgLNf0+PzecjVwFlHY6b65T/gEByHeIZoM1Fzl5zQTpWGM5OeX22rX90lK7GXgDSUquzCXsNRGeQPjKPtn2zXMHBU76XvtUaE7ELNdV+Re+6885+RABCqOsZERY0nNM/bAkIKsTw0jKdfHejOHc0EJK/hyk93cDlQdbLdiZDRiVD/
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(136003)(366004)(346002)(376002)(396003)(39860400002)(33430700001)(66556008)(66476007)(31686004)(66946007)(6512007)(6486002)(5660300002)(36756003)(52116002)(54906003)(53546011)(2906002)(6506007)(186003)(86362001)(478600001)(16526019)(4326008)(33440700001)(8676002)(31696002)(316002)(6916009)(8936002)(2616005)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: nLjJcbYgd7fnaKaTQqB6GHGfVUqEjBLkVjxe1m51T83Z2xYpdBZwxPS7zd4Oae3q77mX2We6P+9lKPevQLg9y30rvVyGkfQlNYDPS4ioqOQRF/MBqfFzs4+NYPG6ZNgsydR3f9jVbGULMO1cgjrNcDAw4JCvhzxeGLmdH6RSpH1Xo5e8Ok+n/UAyhXJTXNpC8hxaNXPdchNUJZh3pQYYgP1Sn9Jq3OiNjHkKprnWBDafW7j4ePjTK1Gy+dw9P6YGwFfazK3Z7NYFqHb4w8591gPqI+eLGtVRpE7cHIN+MRRMqfkWHh8cNhUNvSINJ0tlF7EwocACGDnLSehwXDcWLzPiwYyzeH1U8xn7ibB6s5e/KdkRzE+ij0GcuBN0CY/ghqj9pBb4Eox7wJxRWDG5lPaQC8HEIZUCLE9v/GFrYzHqcHWX9dxRkfw/XLNlSFjamKDup/2owZs59eefTNRxMeu5ySobZfKZZgCPtuPBogrBJcTBdDsnX0QjSxmrMre2oZTeeOi7ARTwY1K/8XBMZwnJ6RHugz5TF8aJTYKPZkrDrmb5evv9uk4rj46kK15p0Yv92Y8qFwwucxqEiLLkO+zGtU2I4cOvaIztRsXuuAeisEoLPol8mVstPDSu4gl53Pfv46GR0wZwwpN4LN3JkbyfaBDdX2urmQEmdmcz9pKlCzfiQqUw5GxddfKZaunzVpuYyT/l1IAUbC0BxOOMy5vMLKtlDFMzOxLfJykWd6Rop4ZtZGtWbZsm6r+IrqIkQR10tnSpy+9S063/TeNUQl4TiBfqDPlj6LPjyzO+rrPPcSe58aIHwr/PSSMSgtH2ZAOh2Cugkm4AGrWEVJrltQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: 20000bd4-2fff-438e-9165-08d7f1526398
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 May 2020 00:14:05.7599
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: E+tDULkJjERaLNFC6tDJ8Hy5w0zrL7YnU2MB+GPCbC1tMioCdGbl83uxbqQnN3P6
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3448
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-05-05_11:2020-05-04,2020-05-05 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 adultscore=0 priorityscore=1501 mlxlogscore=999 mlxscore=0 malwarescore=0
 impostorscore=0 suspectscore=2 bulkscore=0 clxscore=1015 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005060000
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/5/20 2:30 PM, Andrii Nakryiko wrote:
> On Sun, May 3, 2020 at 11:26 PM Yonghong Song <yhs@fb.com> wrote:
>>
>> Given a bpf program, the step to create an anonymous bpf iterator is:
>>    - create a bpf_iter_link, which combines bpf program and the target.
>>      In the future, there could be more information recorded in the link.
>>      A link_fd will be returned to the user space.
>>    - create an anonymous bpf iterator with the given link_fd.
>>
>> The bpf_iter_link can be pinned to bpffs mount file system to
>> create a file based bpf iterator as well.
>>
>> The benefit to use of bpf_iter_link:
>>    - using bpf link simplifies design and implementation as bpf link
>>      is used for other tracing bpf programs.
>>    - for file based bpf iterator, bpf_iter_link provides a standard
>>      way to replace underlying bpf programs.
>>    - for both anonymous and free based iterators, bpf link query
>>      capability can be leveraged.
>>
>> The patch added support of tracing/iter programs for BPF_LINK_CREATE.
>> A new link type BPF_LINK_TYPE_ITER is added to facilitate link
>> querying. Currently, only prog_id is needed, so there is no
>> additional in-kernel show_fdinfo() and fill_link_info() hook
>> is needed for BPF_LINK_TYPE_ITER link.
>>
>> Signed-off-by: Yonghong Song <yhs@fb.com>
>> ---
> 
> LGTM. See small nit about __GFP_NOWARN.
> 
> Acked-by: Andrii Nakryiko <andriin@fb.com>
> 
> 
>>   include/linux/bpf.h            |  1 +
>>   include/linux/bpf_types.h      |  1 +
>>   include/uapi/linux/bpf.h       |  1 +
>>   kernel/bpf/bpf_iter.c          | 62 ++++++++++++++++++++++++++++++++++
>>   kernel/bpf/syscall.c           | 14 ++++++++
>>   tools/include/uapi/linux/bpf.h |  1 +
>>   6 files changed, 80 insertions(+)
>>
> 
> [...]
> 
>> +int bpf_iter_link_attach(const union bpf_attr *attr, struct bpf_prog *prog)
>> +{
>> +       struct bpf_link_primer link_primer;
>> +       struct bpf_iter_target_info *tinfo;
>> +       struct bpf_iter_link *link;
>> +       bool existed = false;
>> +       u32 prog_btf_id;
>> +       int err;
>> +
>> +       if (attr->link_create.target_fd || attr->link_create.flags)
>> +               return -EINVAL;
>> +
>> +       prog_btf_id = prog->aux->attach_btf_id;
>> +       mutex_lock(&targets_mutex);
>> +       list_for_each_entry(tinfo, &targets, list) {
>> +               if (tinfo->btf_id == prog_btf_id) {
>> +                       existed = true;
>> +                       break;
>> +               }
>> +       }
>> +       mutex_unlock(&targets_mutex);
>> +       if (!existed)
>> +               return -ENOENT;
>> +
>> +       link = kzalloc(sizeof(*link), GFP_USER | __GFP_NOWARN);
> 
> nit: all existing link implementation don't specify __GFP_NOWARN,
> wonder if bpf_iter_link should be special?

Nothing special. Just feel __GFP_NOWARN is the right thing to do to 
avoid pollute dmesg since -ENOMEM is returned to user space. But in
reality, unlike some key/value allocation where the size could be huge
and __GFP_NOWARN might be more useful, here, sizeof(*link) is fixed
and small, __GFP_NOWARN probably not that useful.

Will drop it.

> 
>> +       if (!link)
>> +               return -ENOMEM;
>> +
>> +       bpf_link_init(&link->link, BPF_LINK_TYPE_ITER, &bpf_iter_link_lops, prog);
>> +       link->tinfo = tinfo;
>> +
>> +       err  = bpf_link_prime(&link->link, &link_primer);
>> +       if (err) {
>> +               kfree(link);
>> +               return err;
>> +       }
>> +
>> +       return bpf_link_settle(&link_primer);
>> +}
> 
> [...]
> 

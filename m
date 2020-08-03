Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28428239F99
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 08:23:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727920AbgHCGVd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 02:21:33 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:49170 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725965AbgHCGVc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 02:21:32 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0736F7Vb010086;
        Sun, 2 Aug 2020 23:21:18 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=LF61cqba1Zy49YQAZFaPiE3fm8U/mHzjXSiQ8K12Gvs=;
 b=IqJeDK1w8cNtwWuxkgJIOiq4N4lM4muUJSvEmmKRdQW6t9NrnoWLMEW5x9IQILVP5xkT
 5miuCKsN760BwzOC2Ehzao1UpBzfo6h9CruW6ta0N4Q6VK4F1s+b/PGBBt6xSi02vUm6
 iYVrRegI7VFukSEcNkukO1dBleT0xFEneBg= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 32n81jddk7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Sun, 02 Aug 2020 23:21:18 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.197) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Sun, 2 Aug 2020 23:21:17 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lvEmeznRjC53nVvEbK2Px7uNydo2FUhL3KyBj8jzwG705lqFhLrB3a8/lc1aM9y3AvWBXvLXzfbnNDVEnltebblJFZffuiBcKeMDT/2XZHxgVQjt7IpOLVkOUi/EEWqoku1e9nWEtrdm+Cf/YW9WHS8CFUajMU9ZYyKqYg31dE79VUNQKSQQSi4SNppfIhD3n2aRTry1P5XLe2oW88uDRn+nAAgaof1zS8ALxG2LyP5dwZYTP3Ieu0cTUFEUz9GJggqOwG1thNVKT7tSPMd/whmlL9FYw8LV9/Q/W/TJ6Fh8ulpd/oh5sHQy8TQTIawyaDmM5VyjHUngaz/8jKB4fg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LF61cqba1Zy49YQAZFaPiE3fm8U/mHzjXSiQ8K12Gvs=;
 b=FkZ0euoLMU2bxIqFUBwCYFOpMt9SAzeKaHjNs29l/bhntmUR7BP341R+s8aeB1uc87h/cI8CWd17X1Lt6Qfh34PKFut4o6kJBCxvSMTjfzswIVLv/CDjLRhRXhy3bUU2AqtOqiJpEX0du05Hp7SiMDjbB5dcRdnFTyYcpFGSxIRB7txC/pwGxhqwPaUbV34kBdjENHF1JFJOe/1E+ChUjz8fjwOtbDb4loX/0UdeT+uByHZPxUhOrs6FFRTH+cD32PEu2RDhEgjfi1nWH8wt9p8VYbUeQf6XqqNSLo6VFpWqZuyHVIEjycIvNjz5oPvJ8aYoZPADcWB1FObxNJcS9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LF61cqba1Zy49YQAZFaPiE3fm8U/mHzjXSiQ8K12Gvs=;
 b=j8cFkl7mhtij81CuoRpyd0t2jKk7bl3KocBuSAfx/eWDApmmhbZGDcIpmDALLmwgXGACHBllAE3YMYgDWu1xnOGk75biO9l0JsNXwWgE17fU1aX9J8frr4i0MhTgy+Hs9RZpgN4F7wJVWJGJSmbPx9Ui3HQz+DeaJW2iRilJZa4=
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB3510.namprd15.prod.outlook.com (2603:10b6:a03:112::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.20; Mon, 3 Aug
 2020 06:21:16 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::56b:2925:8762:2d80]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::56b:2925:8762:2d80%7]) with mapi id 15.20.3239.021; Mon, 3 Aug 2020
 06:21:16 +0000
Subject: Re: [PATCH bpf-next 1/2] bpf: change uapi for bpf iterator map
 elements
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
References: <20200802042126.2119783-1-yhs@fb.com>
 <20200802042126.2119843-1-yhs@fb.com>
 <CAEf4BzbaRXHpZ5b_6rojnk2dQxLFCOEwtGjNExdg5FEWadF+9g@mail.gmail.com>
 <bb01225b-d4a4-c76b-5e1f-3dc37135f637@fb.com>
 <CAEf4Bzbr--=tbmLqrgbtA4ERy8KmCYvBDfP5PciXx9x3yWpmsQ@mail.gmail.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <b9cbedf6-e407-51d7-53f5-fae7b91905e8@fb.com>
Date:   Sun, 2 Aug 2020 23:21:13 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.11.0
In-Reply-To: <CAEf4Bzbr--=tbmLqrgbtA4ERy8KmCYvBDfP5PciXx9x3yWpmsQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR17CA0033.namprd17.prod.outlook.com
 (2603:10b6:a03:1b8::46) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21c1::1092] (2620:10d:c090:400::5:c987) by BY5PR17CA0033.namprd17.prod.outlook.com (2603:10b6:a03:1b8::46) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.17 via Frontend Transport; Mon, 3 Aug 2020 06:21:14 +0000
X-Originating-IP: [2620:10d:c090:400::5:c987]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a9600211-a5af-4a2f-aa66-08d837756ce0
X-MS-TrafficTypeDiagnostic: BYAPR15MB3510:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB3510D750820512B1E3C31291D34D0@BYAPR15MB3510.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oU5rF8XlCRYvoIVRIsUGt8OgaJgQo9yu2qafHHt0ELlBIwVayQP864emYiZ/z2PVSfYzxIpT5UvBBcNUdb2Xeyn5/5wd9csI/Gw3sVDRzsAE90VgE88sFnuVuWG9b/tuNBJINsGcKKrE549ieypIlXsVBJWGRiiesF3q/PZvtqF1B32FcmwMRbApXgr3KEOazhUat2eRYhhgNTXbks+HXG0UHDCjaOi5MwOir1GBlDexVQLaUF2daTN98+SyysEKFz2B9UFdZD7b9ALcz+IYrRUv2cKLSe4MPsYPvj3Ueej4wDb6pncqcrBjLWASIt6PW/QR7xfK8kjGvBtZit2n8iZQbWnI8oZwjJI8ugp+U0FIPOAouyJw5iTP5ohxhbfH
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(396003)(136003)(376002)(346002)(39860400002)(366004)(6916009)(66946007)(8936002)(66556008)(8676002)(2616005)(66476007)(478600001)(36756003)(4326008)(86362001)(16526019)(6486002)(2906002)(5660300002)(54906003)(316002)(31686004)(53546011)(186003)(52116002)(31696002)(83380400001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: LZcf0+FypoDvF8r+V82FiKikZ+Er6H9eCQ87Bz/SP1w9zTicLDBRuuK8pzfb/owEvqkGyxKT/IqwYdIdOYCfOwLncPBjluiXJeEp4VfIL2j10TghiCs1dnf8PN5kKXWkar84hZtrrw1qQKr0ezNAInWzNIb8YsoVUfQ6M6mkK4w3tbD0e6oe6C3MQ1WUw0xGtPLW48GLH1AWF23UkCOKlwEe3Q0SbMW1K0dKN59ZqmXA6ucqwVK/Xh7/Fqw/R2mSCZ/Q1wszS7jbYn8mYo10ILOZuglkMIDglQs+yi5bUOSouXlVHLqPSw57b+IjkRDKzwSBruHaxitV1XIf6Kh/vEq6OXTu9nx89sPdTIY1DW/MBfXnJE01cD7amz06MEncyS3yD0CzYo6wqb2/AB/RwME3J8xHNysQvYb0/ZPyAUeQgGxFQexudK86cWFzS1EBUqbHHgXPxUVSqoSYGXdM8/P5U4CFYHPQMtj5N+c5Xwqduaq7glESbivD9R9NqevyDclAMnYIUqSMNuMV/FB7CRtX7vDuw+LKQ00+XAlOukO2Nqpa91aJ6osIugyddSx01L+cBN7uatF/UY9ZS0OO2XgDxfutmGe4QX2eUe9ny8ZoOwVdzUexoNmhAafnwjRVU0YUUduWYHOKjPASh9GZa8vLD5Oe+WMUGd++YRTYgAE=
X-MS-Exchange-CrossTenant-Network-Message-Id: a9600211-a5af-4a2f-aa66-08d837756ce0
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Aug 2020 06:21:15.9034
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WmeQPBoQhIhgEAVUKLPwvpubR7W5+doyRvWeGZZ2VzkbTThSQ50mLRM3CfShYwfi
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3510
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-03_04:2020-07-31,2020-08-03 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0
 impostorscore=0 spamscore=0 suspectscore=0 lowpriorityscore=0 phishscore=0
 bulkscore=0 malwarescore=0 mlxscore=0 priorityscore=1501 mlxlogscore=999
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008030045
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/2/20 10:11 PM, Andrii Nakryiko wrote:
> On Sun, Aug 2, 2020 at 7:23 PM Yonghong Song <yhs@fb.com> wrote:
>>
>>
>>
>> On 8/2/20 6:25 PM, Andrii Nakryiko wrote:
>>> On Sat, Aug 1, 2020 at 9:22 PM Yonghong Song <yhs@fb.com> wrote:
>>>>
>>>> Commit a5cbe05a6673 ("bpf: Implement bpf iterator for
>>>> map elements") added bpf iterator support for
>>>> map elements. The map element bpf iterator requires
>>>> info to identify a particular map. In the above
>>>> commit, the attr->link_create.target_fd is used
>>>> to carry map_fd and an enum bpf_iter_link_info
>>>> is added to uapi to specify the target_fd actually
>>>> representing a map_fd:
>>>>       enum bpf_iter_link_info {
>>>>           BPF_ITER_LINK_UNSPEC = 0,
>>>>           BPF_ITER_LINK_MAP_FD = 1,
>>>>
>>>>           MAX_BPF_ITER_LINK_INFO,
>>>>       };
>>>>
>>>> This is an extensible approach as we can grow
>>>> enumerator for pid, cgroup_id, etc. and we can
>>>> unionize target_fd for pid, cgroup_id, etc.
>>>> But in the future, there are chances that
>>>> more complex customization may happen, e.g.,
>>>> for tasks, it could be filtered based on
>>>> both cgroup_id and user_id.
>>>>
>>>> This patch changed the uapi to have fields
>>>>           __aligned_u64   iter_info;
>>>>           __u32           iter_info_len;
>>>> for additional iter_info for link_create.
>>>> The iter_info is defined as
>>>>           union bpf_iter_link_info {
>>>>                   struct {
>>>>                           __u32   map_fd;
>>>>                   } map;
>>>>           };
>>>>
>>>> So future extension for additional customization
>>>> will be easier. The bpf_iter_link_info will be
>>>> passed to target callback to validate and generic
>>>> bpf_iter framework does not need to deal it any
>>>> more.
>>>>
>>>> Signed-off-by: Yonghong Song <yhs@fb.com>
>>>> ---
>>>>    include/linux/bpf.h            | 10 ++++---
>>>>    include/uapi/linux/bpf.h       | 15 +++++-----
>>>>    kernel/bpf/bpf_iter.c          | 52 +++++++++++++++-------------------
>>>>    kernel/bpf/map_iter.c          | 37 ++++++++++++++++++------
>>>>    kernel/bpf/syscall.c           |  2 +-
>>>>    net/core/bpf_sk_storage.c      | 37 ++++++++++++++++++------
>>>>    tools/include/uapi/linux/bpf.h | 15 +++++-----
>>>>    7 files changed, 104 insertions(+), 64 deletions(-)
>>>>
>>>
>>> [...]
>>>
>>>>    int bpf_iter_link_attach(const union bpf_attr *attr, struct bpf_prog *prog)
>>>>    {
>>>> +       union bpf_iter_link_info __user *ulinfo;
>>>>           struct bpf_link_primer link_primer;
>>>>           struct bpf_iter_target_info *tinfo;
>>>> -       struct bpf_iter_aux_info aux = {};
>>>> +       union bpf_iter_link_info linfo;
>>>>           struct bpf_iter_link *link;
>>>> -       u32 prog_btf_id, target_fd;
>>>> +       u32 prog_btf_id, linfo_len;
>>>>           bool existed = false;
>>>> -       struct bpf_map *map;
>>>>           int err;
>>>>
>>>> +       memset(&linfo, 0, sizeof(union bpf_iter_link_info));
>>>> +
>>>> +       ulinfo = u64_to_user_ptr(attr->link_create.iter_info);
>>>> +       linfo_len = attr->link_create.iter_info_len;
>>>> +       if (ulinfo && linfo_len) {
>>>
>>> We probably want to be more strict here: if either pointer or len is
>>> non-zero, both should be present and valid. Otherwise we can have
>>> garbage in iter_info, as long as iter_info_len is zero.
>>
>> yes, it is possible iter_info_len = 0 and iter_info is not null and
>> if this happens, iter_info will not be examined.
>>
>> in kernel, we have places this is handled similarly. For example,
>> for cgroup bpf_prog query.
>>
>> kernel/bpf/cgroup.c, function __cgroup_bpf_query
>>
>>     __u32 __user *prog_ids = u64_to_user_ptr(attr->query.prog_ids);
>>     ...
>>     if (attr->query.prog_cnt == 0 || !prog_ids || !cnt)
>>       return 0;
>>
>> In the above case, it is possible prog_cnt = 0 and prog_ids != NULL,
>> or prog_ids == NULL and prog_cnt != 0, and we won't return error
>> to user space.
>>
>> Not 100% sure whether we have convention here or not.
> 
> I don't know either, but I'd assume that we didn't think about 100%
> strictness when originally implementing this. So I'd go with a very
> strict check for this new functionality.

Agreed. This should be fine as the functionality is new.

> 
>>
>>>
>>>> +               err = bpf_check_uarg_tail_zero(ulinfo, sizeof(linfo),
>>>> +                                              linfo_len);
>>>> +               if (err)
>>>> +                       return err;
>>>> +               linfo_len = min_t(u32, linfo_len, sizeof(linfo));
>>>> +               if (copy_from_user(&linfo, ulinfo, linfo_len))
>>>> +                       return -EFAULT;
>>>> +       }
>>>> +
>>>>           prog_btf_id = prog->aux->attach_btf_id;
>>>>           mutex_lock(&targets_mutex);
>>>>           list_for_each_entry(tinfo, &targets, list) {
>>>> @@ -411,13 +425,6 @@ int bpf_iter_link_attach(const union bpf_attr *attr, struct bpf_prog *prog)
>>>>           if (!existed)
>>>>                   return -ENOENT;
>>>>
>>>> -       /* Make sure user supplied flags are target expected. */
>>>> -       target_fd = attr->link_create.target_fd;
>>>> -       if (attr->link_create.flags != tinfo->reg_info->req_linfo)
>>>> -               return -EINVAL;
>>>> -       if (!attr->link_create.flags && target_fd)
>>>> -               return -EINVAL;
>>>> -
>>>
>>> Please still ensure that no flags are specified.
>>
>> Make sense. I also need to ensure target_fd is 0 since it is not used
>> any more.
>>
> 
> yep, good catch
> 
>>>
>>>
>>>>           link = kzalloc(sizeof(*link), GFP_USER | __GFP_NOWARN);
>>>>           if (!link)
>>>>                   return -ENOMEM;
[...]

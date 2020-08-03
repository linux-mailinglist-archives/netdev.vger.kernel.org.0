Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49EA4239D7A
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 04:24:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726750AbgHCCX6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Aug 2020 22:23:58 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:23222 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725820AbgHCCX6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Aug 2020 22:23:58 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0732NTWL028707;
        Sun, 2 Aug 2020 19:23:42 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=pRsYV2rO2Pwu3pKMHtQdohkcgZp2VBpBHSkSdtmS/gQ=;
 b=XtxPRCvVotFG3mmSxA0scPBEFcQ1CgwehctNQ+zJiuawmseI+WKEE6NsDvAFEEjV1E1J
 Z9cdE9CbvZxLURY1kldzdC2hQidZhLuZHIWyMJfxfXrEmD2G20quk2as4NR+tnQWh+b2
 Hr+XbNMIkms6iuW65P4jgznkfDgE6yWHOWQ= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 32n81fmxg8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Sun, 02 Aug 2020 19:23:42 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.228) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Sun, 2 Aug 2020 19:23:40 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eqp8VxA9/BamUzY0+gI8uVOqN3ml+X1835gMNHVMZj+gy+BJeP3r4othvUzPWrusdRiZ+V3+V0ykluw0M+TahyvsnfEzxybBuXJxxmN5PiLzO7xqolQoEfARLh7mk1FvRJK2wC9rm4lbH6mzAA4kZ9Pa6G8H4nDzJ72VQgsMXdTADX9c6mLOYU3SfqEWbEYGwMsCzquTRRlO9fGyLKO9Dmlo3vMsNOsW0k260FfHgWH84ulSl8GVs+TObvteQOsxZe7bZ4qvNRn/giEZTs6WzLodv9AIHT2fjfs7BoWOaaQcZdsJL84ZfuSdguOlwHwx9gJ3GLr8WQxhpP6E61TO9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pRsYV2rO2Pwu3pKMHtQdohkcgZp2VBpBHSkSdtmS/gQ=;
 b=VUMQWta/0RGmNgKJG8FWvZbG9wQVgH7Ed+OmhsNpkqZq/JaxKj3gUjLsiqIbr2qKFkVNzFVez1SwOIYrI5qrwttRXzhXhS86O+Apjoqw4fD6xGJQSGzlJfJOHoS/qC2uDSQlamtWwFtn8azJq4re1JmWN/apIdTSLe9tvGveLrybfLUMK2mDGRJ0H7BfIUjXoOy0vwWDCKPZtCkcpLRgl4qrIUXyJ53RjRSEo3YdBnHftTRkixOMUFf1ByRAvoOvAusGIDuOxX/C7YNsS5BfuC2QPcvjLLK+VMMlkudCk9K/uPWZT7v/mc9cnVlIx4IvDdjjnZ2MgSOVJvTFAw4AUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pRsYV2rO2Pwu3pKMHtQdohkcgZp2VBpBHSkSdtmS/gQ=;
 b=Jdb9/8oBM62LRjG/y4KrKThxCLlKENIpSha360JOo4/r/gr/PqjjzKxazKi5uH6cYno/ydr8sdNBIkcu2QNlus8nYCw0NPT46clspU6OFuw26ZJ+x4uvwykz2BAZWfHPTMi2TmzeUD7KvqkaKkojuwEsOzIRbNTXhH11nk6R49s=
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB2328.namprd15.prod.outlook.com (2603:10b6:a02:8b::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.20; Mon, 3 Aug
 2020 02:23:39 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::56b:2925:8762:2d80]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::56b:2925:8762:2d80%7]) with mapi id 15.20.3239.021; Mon, 3 Aug 2020
 02:23:39 +0000
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
From:   Yonghong Song <yhs@fb.com>
Message-ID: <bb01225b-d4a4-c76b-5e1f-3dc37135f637@fb.com>
Date:   Sun, 2 Aug 2020 19:23:36 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.11.0
In-Reply-To: <CAEf4BzbaRXHpZ5b_6rojnk2dQxLFCOEwtGjNExdg5FEWadF+9g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR01CA0068.prod.exchangelabs.com (2603:10b6:a03:94::45)
 To BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21c1::1092] (2620:10d:c090:400::5:342b) by BYAPR01CA0068.prod.exchangelabs.com (2603:10b6:a03:94::45) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.18 via Frontend Transport; Mon, 3 Aug 2020 02:23:38 +0000
X-Originating-IP: [2620:10d:c090:400::5:342b]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 746ed0f7-3446-4d46-97d3-08d837543b87
X-MS-TrafficTypeDiagnostic: BYAPR15MB2328:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB23285860C87163E6ACCEE8B5D34D0@BYAPR15MB2328.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EFm9S55WOs9QCnlGoIXBBTwQz31rd3140MyFynMts/JNkZQyB/fpeIsSe2+ktXBLycOrsW+pNdhpHy6jk5L3lCnkJdLO6SIreDKPuTiRGBytjdFK9unUslKEAQ25o++5u5JjVWICe3QLv+DQUTFKBf4eFnP5XvfLJLn+yoqYW6LXJnOWbrLdCoXNBY4ZWqMKlL/iRgIzE/E1ZWBa+WsyTW6qcjB8H7JOwee+zGt5Jk2EF+0mPXYw/WEoFFANOxQyJ4S9E/cksfnR9kuI5kc8LQHvqrMFOQgmXEHClaH8gRVj2bI06+KGH22HutbevGYtC33X/rGZj12Uz51OcrcBM7M7NpbLKfUkfWovyurwR3siLktiWhsHVY/K9cP87hgB
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(39860400002)(366004)(376002)(346002)(396003)(136003)(6486002)(186003)(53546011)(86362001)(16526019)(31686004)(54906003)(2616005)(2906002)(66556008)(8936002)(4326008)(66476007)(8676002)(36756003)(478600001)(66946007)(6916009)(31696002)(5660300002)(316002)(52116002)(83380400001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: rkuTy0IPy4IcHkOnVe7TVyLvHEHFBTSGUmrPI0jpaKN9PLsTHcg99O90AuCcoO7qDHebZde0N12ndVN3NQSEVZ5ZD+az1zn0P66sgAl6jcuxPWS8NI++r5E3c3fTQDmpcRZ2makVoVcc7omfoD+fCEz0nGW9zCoANrTIun/ogHniCJpciC53yu2muN/uA/UA6v8bRykQ5SjLCCdAV+yz431gzAiN6xKEd8PBkV6DwVDJORnnuPmZLnVz/LxyaDl0JUWGVurcPGUJitgSZ4OB+V1Y1VUa2MHptzIcTc1UgKFDpZIlEXq8sQ1Y6/zhg+PGVUtWBP54gy89Nm+FTgH3XeT7qhsJFEuQWUyPQxVmk6VTZCgQYDXTSuaatPlt4IHX6rgNwgqJRwRV6K6KBpEVNVEiVMxJ8rcjINaDKDLCiTyfAR12Usi6OZzlCaSecR4/ZXoCKO/gtMwGZts0x2M1Xl7lh2SGaQdeK+TwBgW76FEno2NbBKUZMwEls/VtdVKjtwnhzPOeFI7Wnwonm7FIvfBi+/ptLqkHS1crqMPjMuMgOqHyOzcYoUeZtuwhVM4VFp37unET7qOCVZI2flQ4vbgEIAXpun+jzRwSyk7cE2KLWJIq0B4HKyRSKT87hWckUvKcxgTyx1HuHBlHK/c3A9yYgqZx94AQ3TAa/27rv+8=
X-MS-Exchange-CrossTenant-Network-Message-Id: 746ed0f7-3446-4d46-97d3-08d837543b87
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Aug 2020 02:23:39.0536
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: luzGus6NZby1+NRAZsroVW1zHrgaBUllke5+hr29LAFfenku8RJcee+b4Cv12gla
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2328
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-03_01:2020-07-31,2020-08-03 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015
 priorityscore=1501 spamscore=0 impostorscore=0 mlxscore=0 phishscore=0
 suspectscore=0 lowpriorityscore=0 bulkscore=0 adultscore=0 mlxlogscore=999
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008030015
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/2/20 6:25 PM, Andrii Nakryiko wrote:
> On Sat, Aug 1, 2020 at 9:22 PM Yonghong Song <yhs@fb.com> wrote:
>>
>> Commit a5cbe05a6673 ("bpf: Implement bpf iterator for
>> map elements") added bpf iterator support for
>> map elements. The map element bpf iterator requires
>> info to identify a particular map. In the above
>> commit, the attr->link_create.target_fd is used
>> to carry map_fd and an enum bpf_iter_link_info
>> is added to uapi to specify the target_fd actually
>> representing a map_fd:
>>      enum bpf_iter_link_info {
>>          BPF_ITER_LINK_UNSPEC = 0,
>>          BPF_ITER_LINK_MAP_FD = 1,
>>
>>          MAX_BPF_ITER_LINK_INFO,
>>      };
>>
>> This is an extensible approach as we can grow
>> enumerator for pid, cgroup_id, etc. and we can
>> unionize target_fd for pid, cgroup_id, etc.
>> But in the future, there are chances that
>> more complex customization may happen, e.g.,
>> for tasks, it could be filtered based on
>> both cgroup_id and user_id.
>>
>> This patch changed the uapi to have fields
>>          __aligned_u64   iter_info;
>>          __u32           iter_info_len;
>> for additional iter_info for link_create.
>> The iter_info is defined as
>>          union bpf_iter_link_info {
>>                  struct {
>>                          __u32   map_fd;
>>                  } map;
>>          };
>>
>> So future extension for additional customization
>> will be easier. The bpf_iter_link_info will be
>> passed to target callback to validate and generic
>> bpf_iter framework does not need to deal it any
>> more.
>>
>> Signed-off-by: Yonghong Song <yhs@fb.com>
>> ---
>>   include/linux/bpf.h            | 10 ++++---
>>   include/uapi/linux/bpf.h       | 15 +++++-----
>>   kernel/bpf/bpf_iter.c          | 52 +++++++++++++++-------------------
>>   kernel/bpf/map_iter.c          | 37 ++++++++++++++++++------
>>   kernel/bpf/syscall.c           |  2 +-
>>   net/core/bpf_sk_storage.c      | 37 ++++++++++++++++++------
>>   tools/include/uapi/linux/bpf.h | 15 +++++-----
>>   7 files changed, 104 insertions(+), 64 deletions(-)
>>
> 
> [...]
> 
>>   int bpf_iter_link_attach(const union bpf_attr *attr, struct bpf_prog *prog)
>>   {
>> +       union bpf_iter_link_info __user *ulinfo;
>>          struct bpf_link_primer link_primer;
>>          struct bpf_iter_target_info *tinfo;
>> -       struct bpf_iter_aux_info aux = {};
>> +       union bpf_iter_link_info linfo;
>>          struct bpf_iter_link *link;
>> -       u32 prog_btf_id, target_fd;
>> +       u32 prog_btf_id, linfo_len;
>>          bool existed = false;
>> -       struct bpf_map *map;
>>          int err;
>>
>> +       memset(&linfo, 0, sizeof(union bpf_iter_link_info));
>> +
>> +       ulinfo = u64_to_user_ptr(attr->link_create.iter_info);
>> +       linfo_len = attr->link_create.iter_info_len;
>> +       if (ulinfo && linfo_len) {
> 
> We probably want to be more strict here: if either pointer or len is
> non-zero, both should be present and valid. Otherwise we can have
> garbage in iter_info, as long as iter_info_len is zero.

yes, it is possible iter_info_len = 0 and iter_info is not null and
if this happens, iter_info will not be examined.

in kernel, we have places this is handled similarly. For example,
for cgroup bpf_prog query.

kernel/bpf/cgroup.c, function __cgroup_bpf_query

   __u32 __user *prog_ids = u64_to_user_ptr(attr->query.prog_ids);
   ...
   if (attr->query.prog_cnt == 0 || !prog_ids || !cnt)
     return 0;

In the above case, it is possible prog_cnt = 0 and prog_ids != NULL,
or prog_ids == NULL and prog_cnt != 0, and we won't return error
to user space.

Not 100% sure whether we have convention here or not.

> 
>> +               err = bpf_check_uarg_tail_zero(ulinfo, sizeof(linfo),
>> +                                              linfo_len);
>> +               if (err)
>> +                       return err;
>> +               linfo_len = min_t(u32, linfo_len, sizeof(linfo));
>> +               if (copy_from_user(&linfo, ulinfo, linfo_len))
>> +                       return -EFAULT;
>> +       }
>> +
>>          prog_btf_id = prog->aux->attach_btf_id;
>>          mutex_lock(&targets_mutex);
>>          list_for_each_entry(tinfo, &targets, list) {
>> @@ -411,13 +425,6 @@ int bpf_iter_link_attach(const union bpf_attr *attr, struct bpf_prog *prog)
>>          if (!existed)
>>                  return -ENOENT;
>>
>> -       /* Make sure user supplied flags are target expected. */
>> -       target_fd = attr->link_create.target_fd;
>> -       if (attr->link_create.flags != tinfo->reg_info->req_linfo)
>> -               return -EINVAL;
>> -       if (!attr->link_create.flags && target_fd)
>> -               return -EINVAL;
>> -
> 
> Please still ensure that no flags are specified.

Make sense. I also need to ensure target_fd is 0 since it is not used 
any more.

> 
> 
>>          link = kzalloc(sizeof(*link), GFP_USER | __GFP_NOWARN);
>>          if (!link)
>>                  return -ENOMEM;
>> @@ -431,28 +438,15 @@ int bpf_iter_link_attach(const union bpf_attr *attr, struct bpf_prog *prog)
>>                  return err;
>>          }
>>
> 
> [...]
> 
>> -static int bpf_iter_check_map(struct bpf_prog *prog,
>> -                             struct bpf_iter_aux_info *aux)
>> +static int bpf_iter_attach_map(struct bpf_prog *prog,
>> +                              union bpf_iter_link_info *linfo,
>> +                              struct bpf_iter_aux_info *aux)
>>   {
>> -       struct bpf_map *map = aux->map;
>> +       struct bpf_map *map;
>> +       int err = -EINVAL;
>>
>> -       if (map->map_type != BPF_MAP_TYPE_SK_STORAGE)
>> +       if (!linfo->map.map_fd)
>>                  return -EINVAL;
> 
> This could be -EBADF?

Good suggestion. Will do.

> 
>>
>> -       if (prog->aux->max_rdonly_access > map->value_size)
>> -               return -EACCES;
>> +       map = bpf_map_get_with_uref(linfo->map.map_fd);
>> +       if (IS_ERR(map))
>> +               return PTR_ERR(map);
>> +
>> +       if (map->map_type != BPF_MAP_TYPE_SK_STORAGE)
>> +               goto put_map;
>> +
>> +       if (prog->aux->max_rdonly_access > map->value_size) {
>> +               err = -EACCES;
>> +               goto put_map;
>> +       }
> 
> [...]
> 

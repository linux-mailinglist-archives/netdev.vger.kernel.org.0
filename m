Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D4C724DED7
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 19:46:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726858AbgHURq4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Aug 2020 13:46:56 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:29436 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725948AbgHURqz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Aug 2020 13:46:55 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07LHiApt018368;
        Fri, 21 Aug 2020 10:46:41 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=S/bHFZe6BBWTdW7KvL1F7DyQgso5Q0+rXPpSnaG6fJQ=;
 b=TPjtBcElat98pc/py1dLuxsF+jxXByoE0TlaKJybArsTAkOcFn/sJmtZtZ6zd5lZ+dJc
 vZC+iSw87RizUZxpA23OMj3c9YitmVULGN3HltmQ9vBRdH2tlnYtzSzLFB4pG4MyH4Cq
 dVstoaeuyKRDyQ8PJksFeItZPyKe/YISUvg= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3318g0v7q7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 21 Aug 2020 10:46:41 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.197) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 21 Aug 2020 10:46:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TTbtRufZnT6++cniAG4M2g+fr9+uDbqPHIBz8ws6wkuVi3v57OFr7LoIqV8TkoSXT5IQ3JfP9tUrgoCB2QgpuSvsRczVx+OR6sXkNVtN+YaUUDcqZuteE7QPXjGaCEh2gzrXpaRrWu3ydks77udv2uhs12mDPCEisvoWGTmZpsd0MEvOI3orIJ4o44jSrpDy830HWltbs9SsrrPtUhSvfO0CNhzcuk7RCb4RO2Qi96PdkBkZYj5OU3gEwcra3FgCDYfCv0NN+KyHUJdGyOkvfbzzjcGek1M4lOwG1I9AMtVkH9CwH5qia6X7VKnJL7GlPJOvS4ejbzRIQ7kF3cFDBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S/bHFZe6BBWTdW7KvL1F7DyQgso5Q0+rXPpSnaG6fJQ=;
 b=HFBk+O7vS6HZqquU7F23y4ojyuEhajbtc+Pm9PfUt9BfGpDajQYCXLhtShIqeZlOpzoZWQX0x0WIPNFPOFOrID5iF3pLt9DW6Ze86cativhT8FOK76JfKJXajIuCptXMEmxr/EgddnjDfEmvwEMNlj1QGvaUOyTaaQcrIEk7JsmLXE5+Q9+HE+VA675usrrB+ljnTcf2wSJ3zMVHPyQ/ck3O5sA1QhGl1EVGV5i5w85N08J81IF+YG8yTS8ZCqZgnWO/DUXVEwckesySnwczktt5ptYM2A2pn/ikJ+CN4C97h+7WUCxb/crF8z60scff1L1mS7GVxIbq0Za7Vjg3Iw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S/bHFZe6BBWTdW7KvL1F7DyQgso5Q0+rXPpSnaG6fJQ=;
 b=CbgyzGxmkdtWVX5lINpqjXGTzEMSPv8C5bULoAfdASYYBcZBsrrt711mhO1RAYUxQ9S3KsQHnuYbk7rinB/UaXeP4ompIXgv5ETR1gott1S92qfFqWCcXtq1HPjDlUx7K69FZqFnyNfPOqY+t4PzaJXzoE93fusjChS3TjkFzpg=
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB3511.namprd15.prod.outlook.com (2603:10b6:a03:10e::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.25; Fri, 21 Aug
 2020 17:46:38 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::56b:2925:8762:2d80]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::56b:2925:8762:2d80%7]) with mapi id 15.20.3305.026; Fri, 21 Aug 2020
 17:46:38 +0000
Subject: Re: [PATCH bpf-next v2 1/3] bpf: implement link_query for bpf
 iterators
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
References: <20200820224917.483062-1-yhs@fb.com>
 <20200820224917.483128-1-yhs@fb.com>
 <CAEf4BzZ32inDH2MhLFv5o8PiQ9=4EGR0C75Ks6dWzHjVsgozAg@mail.gmail.com>
 <08982c2f-b9a8-3d30-9e4c-4f3f071a5a58@fb.com>
 <CAEf4BzbF_KURy4CusoCND6-agPc8SgFAtKDhcwYC8jP=L1M50Q@mail.gmail.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <d0b44fee-97f4-05bc-90b7-0b47f238ab37@fb.com>
Date:   Fri, 21 Aug 2020 10:46:34 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.11.0
In-Reply-To: <CAEf4BzbF_KURy4CusoCND6-agPc8SgFAtKDhcwYC8jP=L1M50Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR16CA0031.namprd16.prod.outlook.com
 (2603:10b6:208:134::44) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from 255.255.255.255 (255.255.255.255) by MN2PR16CA0031.namprd16.prod.outlook.com (2603:10b6:208:134::44) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.25 via Frontend Transport; Fri, 21 Aug 2020 17:46:36 +0000
X-Originating-IP: [2620:10d:c091:480::1:8457]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 421d0869-5e8e-4251-69c6-08d845fa2771
X-MS-TrafficTypeDiagnostic: BYAPR15MB3511:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB351187DF4544A7B1FF799774D35B0@BYAPR15MB3511.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FwSyieb6th99+kKKwqUn4BFgiA4xZDD0LhrdY58BhRhSJXajfyh54lVWVdCVnqmJ+idOq5LwEAPFoqx9dEcOyLfYtJNfpZIi5F1lcgUxdI3qeWDA8xLTpljj982yhuNepgXvxdcTU6kb5J1qJG1yyZ27xCzSWHv4GXm4MxdS0jTab7aeRjdrgj5ADL77h0oJbliJyPnDlDMKiqkbAOvkRQ3n6etMH/gMnVPz1LZP07ZHGOLx9DkdF9clCFnRuwnYW0EapajbqKTOiYn/nzXQlYJJh7N5QDK3Bsg9mg5VFNYGwGldp9k8xg7NGDTSboEwAUWKR84hG6nx8DJgxfKDNoB5+sxTYMmJFSEa60ipMskgV10oRUb8GGRkMl6F4qizZ9EMmeQQW3eIxm8n/mFjjmhtN+JB4KcxFpUGpYvhWQM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(39860400002)(376002)(346002)(396003)(366004)(2616005)(8936002)(6486002)(4326008)(110011004)(5660300002)(53546011)(956004)(83380400001)(52116002)(66556008)(186003)(6916009)(66476007)(66946007)(8676002)(54906003)(31696002)(31686004)(16576012)(86362001)(478600001)(316002)(2906002)(36756003)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: 2WIqkWpHlzTMHLJcJMrDVrDtz3GfVagxA4UYRoan5Fg+8+RKuq0KRWamGKYuZa7I1PyheFE30xw00uxwunWSDnI0pEseh/9h8fVqIhLQjCNM3te1LRKFfZNyozRZFoQov5msX9VtMA5qWR9szHnjLPY6hol8ISVv6cbLN7w2jltH7SYWbrjXLwvN3Itym93GqTDFXrZkC/pIHeKxFydP7QOmFrpC7/uDZva5pscz8RRd0FrwHWerNJmNPFqtmdIcdcMZs1Y1SwWZKI1uWnES15ZEcxkQUV7v1+Ou9BkkiT5pqfL/Qb4kfsXO8P/t3RAj9j6F293S/HBfivsrRCe2ShR0ngp7sVdqa/grwKJHto6bi74hMDe1mizSRq2l37IA/6JsOVh2uQ04Brqi/jBFvVZT+54X1IpaESo4mpVHiWX8/j6XzuKZWsvUGLcqnsEBnxOfl0IsmcxP62hkjGruZfi31E73rHVXEG6e7prK5PRlyArTGXzhRY0Ofms6kbqtWytCa7RZwOALu7Ob58zs6mg1mXIV4Fq3dzUl+q2NbSrvd5I9t35Fntjtfrg1WZlX9uSRZEU+N9bKjJ40w6bKyAEElMKkX6aQjk8hPl0BBuZMa7xYb6/mjQJbK/AoVsHrRE65udRHa2Z4+rB309dPg1LWbO5PdhMr6B2VijpvRPU06KPod7hNf9PnyR8xZyY8
X-MS-Exchange-CrossTenant-Network-Message-Id: 421d0869-5e8e-4251-69c6-08d845fa2771
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Aug 2020 17:46:38.1128
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: m6FpDIlCMNoBuZ7syHX6wcMdj9RpfRulmVH5X33bJZQIoaqc86ctGUB3A2qc4FAa
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3511
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-21_08:2020-08-21,2020-08-21 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0 spamscore=0
 lowpriorityscore=0 clxscore=1015 bulkscore=0 priorityscore=1501
 mlxlogscore=999 suspectscore=0 mlxscore=0 adultscore=0 malwarescore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008210168
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/21/20 9:44 AM, Andrii Nakryiko wrote:
> On Thu, Aug 20, 2020 at 11:42 PM Yonghong Song <yhs@fb.com> wrote:
>>
>>
>>
>> On 8/20/20 11:31 PM, Andrii Nakryiko wrote:
>>> On Thu, Aug 20, 2020 at 3:50 PM Yonghong Song <yhs@fb.com> wrote:
>>>>
>>>> This patch implemented bpf_link callback functions
>>>> show_fdinfo and fill_link_info to support link_query
>>>> interface.
>>>>
>>>> The general interface for show_fdinfo and fill_link_info
>>>> will print/fill the target_name. Each targets can
>>>> register show_fdinfo and fill_link_info callbacks
>>>> to print/fill more target specific information.
>>>>
>>>> For example, the below is a fdinfo result for a bpf
>>>> task iterator.
>>>>     $ cat /proc/1749/fdinfo/7
>>>>     pos:    0
>>>>     flags:  02000000
>>>>     mnt_id: 14
>>>>     link_type:      iter
>>>>     link_id:        11
>>>>     prog_tag:       990e1f8152f7e54f
>>>>     prog_id:        59
>>>>     target_name:    task
>>>>
>>>> Signed-off-by: Yonghong Song <yhs@fb.com>
>>>> ---
>>>>    include/linux/bpf.h            |  6 ++++
>>>>    include/uapi/linux/bpf.h       |  7 ++++
>>>>    kernel/bpf/bpf_iter.c          | 58 ++++++++++++++++++++++++++++++++++
>>>>    tools/include/uapi/linux/bpf.h |  7 ++++
>>>>    4 files changed, 78 insertions(+)
>>>>
>>>
>>> [...]
>>>
>>>> +
>>>> +static int bpf_iter_link_fill_link_info(const struct bpf_link *link,
>>>> +                                       struct bpf_link_info *info)
>>>> +{
>>>> +       struct bpf_iter_link *iter_link =
>>>> +               container_of(link, struct bpf_iter_link, link);
>>>> +       char __user *ubuf = u64_to_user_ptr(info->iter.target_name);
>>>> +       bpf_iter_fill_link_info_t fill_link_info;
>>>> +       u32 ulen = info->iter.target_name_len;
>>>> +       const char *target_name;
>>>> +       u32 target_len;
>>>> +
>>>> +       if (ulen && !ubuf)
>>>> +               return -EINVAL;
>>>> +
>>>> +       target_name = iter_link->tinfo->reg_info->target;
>>>> +       target_len =  strlen(target_name);
>>>> +       info->iter.target_name_len = target_len + 1;
>>>> +       if (!ubuf)
>>>> +               return 0;
>>>
>>> this might return prematurely before fill_link_info() below gets a
>>> chance to fill in some extra info?
>>
>> The extra info filled by below fill_link_info is target specific
>> and we need a target name to ensure picking right union members.
>> So it is best to enforce a valid target name before filling
>> target dependent fields. See below, if there are any errors
>> for copy_to_user or enospc, we won't copy addition link info
>> either.
>>
> 
> You are making an assumption that the caller doesn't know what time of
> link it's requesting info for. That's not generally true. So I think

Based on my understanding, most users for bpf command
BPF_OBJ_GET_INFO_BY_FD is for tools, not the original application
which created the original link.

But I agree there are certain use cases where the caller has
much more knowledge about 'fd' than bpftool and they may just
want to get one particular piece of information.

> we just shouldn't make unnecessary assumptions and provide as much
> information on the first try. target_name should be treated as an
> optional thing to request, that's all.

Okay, will do this.

>>>
>>>> +
>>>> +       if (ulen >= target_len + 1) {
>>>> +               if (copy_to_user(ubuf, target_name, target_len + 1))
>>>> +                       return -EFAULT;
>>>> +       } else {
>>>> +               char zero = '\0';
>>>> +
>>>> +               if (copy_to_user(ubuf, target_name, ulen - 1))
>>>> +                       return -EFAULT;
>>>> +               if (put_user(zero, ubuf + ulen - 1))
>>>> +                       return -EFAULT;
>>>> +               return -ENOSPC;
>>>> +       }
>>>> +
>>>> +       fill_link_info = iter_link->tinfo->reg_info->fill_link_info;
>>>> +       if (fill_link_info)
>>>> +               return fill_link_info(&iter_link->aux, info);
>>>> +
>>>> +       return 0;
>>>> +}
>>>> +
>>>
>>> [...]
>>>

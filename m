Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9B1C1C78F7
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 20:09:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730213AbgEFSIp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 14:08:45 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:21460 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729301AbgEFSIm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 14:08:42 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 046I07KL021272;
        Wed, 6 May 2020 11:08:29 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=RnTyspSYNB0UzVtDvMZdvTcWcKLT+xOVi4nEhfX8bqc=;
 b=HdNrG5TJPk2gRmG/66fj51IWXVF/3Y0H54aOVtkv6XGISd8Xwqb5m6Byi4OIeGgFFNYI
 6p5YtQLm0Ayb0Itz2jQg9Os7PfGmfylzf4ixIon87ynAjmvYa+pmdkLO2iBOXs/c9P9t
 iyw2g/POHizDj2S/SEffrADcN7lecdowMZ8= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 30uxuxh743-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 06 May 2020 11:08:29 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.173) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Wed, 6 May 2020 11:08:28 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fNRCkyNWx5tvOLEroeL5oB94v3Tq9h9KubYBBp632nEusqnu9Asiph3ERSpyXhGNu/ZPU2dolzIi8gTB/+tzqteweMnd1wyyB6agEp0U68kIUGzrogaJc3fFlGY44vCjG9atp/lZDkgGmfU5OZHBjFg5JprYUY7bXjAmj35CRhgg2zJJNDo2k7kXKXR5MQ4rWyVc8S5C8TTpnMKkB4Tk9yZyGFz9ome8Qw/ddpylN3XjGtvqu3MaDlF6iB2OBcgsfhUOR7arUgL8tlOcie0PaEtmcp/Rs42xtpdIifvHzxGmsY7AL9am/E8lsqfYTB2G1P58dK88EUgppFc2xBd9Fg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RnTyspSYNB0UzVtDvMZdvTcWcKLT+xOVi4nEhfX8bqc=;
 b=nTIPE23i5O/1aFxubl7bx0j+anfmvf8qOWDsZp4yG5hrwfsMA4hkUsgScEA46gAZkTv+1MyVSzB3d54YRNvnsokdOYl2oliAYyo7enTyctzrOD5dzNCAhjBLn4/42FBLLQ0OTFPRt/62ZOQv+w4ChuRc81JjTxFxhfM9OBpZUT45eFekkidXFQJHf9drl4uRZnhte7sg9SkDSir3pTcXDVxj62F6BiVt/6GZP6ZsYKluUhVw+DAzH4uYWuxrqyqdl+4BkJuvCPYqqAO0O+FdLNIA+dXAlKTuKr/jITgPcA2Vq0QbW1XvQFxUGwaHPOTrdgrCZX7IanP8W3NxdThlTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RnTyspSYNB0UzVtDvMZdvTcWcKLT+xOVi4nEhfX8bqc=;
 b=OyHPlyk/2eGASmN8K1O5Z1/WwDkrBKXPnLavK34FzJjLmqvFCfSy/O2ab3e2bC+HQaqcoFcr8tcuOgyHOEMLcoy/fKXdV0eK+K7lO4p/GRSngUx+cORmEs26YKDKysSHQ20662WiZplajqDwvD6m7IKzT5ySQILzqext21Gqf5M=
Received: from MW3PR15MB3772.namprd15.prod.outlook.com (2603:10b6:303:4c::14)
 by MW3PR15MB3820.namprd15.prod.outlook.com (2603:10b6:303:4c::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.29; Wed, 6 May
 2020 18:08:26 +0000
Received: from MW3PR15MB3772.namprd15.prod.outlook.com
 ([fe80::3032:6927:d600:772a]) by MW3PR15MB3772.namprd15.prod.outlook.com
 ([fe80::3032:6927:d600:772a%8]) with mapi id 15.20.2958.030; Wed, 6 May 2020
 18:08:26 +0000
Subject: Re: [PATCH bpf-next v2 03/20] bpf: support bpf tracing/iter programs
 for BPF_LINK_CREATE
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     Yonghong Song <yhs@fb.com>, Andrii Nakryiko <andriin@fb.com>,
        bpf <bpf@vger.kernel.org>, Martin KaFai Lau <kafai@fb.com>,
        Networking <netdev@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
References: <20200504062547.2047304-1-yhs@fb.com>
 <20200504062549.2047531-1-yhs@fb.com>
 <CAEf4BzYxTwmxEVk6DG9GzkqHDF--VqvZWik0YJigzdrn3whcXA@mail.gmail.com>
 <e71a26e7-1a78-7e4d-23d6-20070541524d@fb.com>
 <fe5d8d02-b263-c373-9ab8-c709f4c5841f@fb.com>
 <CAEf4BzZFqPkq=E0c1eMFoKzUQF7h+aMufE3XEpcXXEQkTvYEPA@mail.gmail.com>
From:   Alexei Starovoitov <ast@fb.com>
Message-ID: <84f179cf-6c88-0190-153a-d7eaf5bac52c@fb.com>
Date:   Wed, 6 May 2020 11:08:24 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
In-Reply-To: <CAEf4BzZFqPkq=E0c1eMFoKzUQF7h+aMufE3XEpcXXEQkTvYEPA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR06CA0067.namprd06.prod.outlook.com
 (2603:10b6:a03:14b::44) To MW3PR15MB3772.namprd15.prod.outlook.com
 (2603:10b6:303:4c::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21e8::1333] (2620:10d:c090:400::5:4461) by BYAPR06CA0067.namprd06.prod.outlook.com (2603:10b6:a03:14b::44) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.28 via Frontend Transport; Wed, 6 May 2020 18:08:25 +0000
X-Originating-IP: [2620:10d:c090:400::5:4461]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ffaa3eb1-d109-4f1d-c18c-08d7f1e8794d
X-MS-TrafficTypeDiagnostic: MW3PR15MB3820:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MW3PR15MB38208706F739EE9AD1A6A30BD7A40@MW3PR15MB3820.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-Forefront-PRVS: 03950F25EC
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EJBb8C5OPhNgzl/V3pw9vDShUp4/lHbiYkHYH3AmsMDT//2NYg1XSKwKtGKzJNiLiocD7KfuqFHHBkzXs9Tt2Zom2OAjwPglr+QG3Pi6y6iFjjBkmIRs9IJ4x0gSxcrpHjTEVYL/cHs9NUbKEiLvnB8l+X7UcC2v8TR4iE+Dq8JWs7B4QdzjEsvdDKf/dJNONFoha1JlkEIgwO7Y5M9pDVGZA72tVlOfipVRTlm5h+EopfKY3wHwur8ZgL08vkrAKvBdK9WEXQhfwBLctTV+WVZfSOhyiChZqN6GMCbpoRDWNxFiElyqhlD1CacWnQxu8H3LxhrmKv/GjEguLryQzy3mtgJmLjVgKGvX2O/PmgHJ9qmSwHlDte3I/KGmMpZpIpBKXkUNl0bvQQq2uce9NNqUuDn742C7pU6GDSySbSqSlETczzDqiheOCS8Gcm+pCNxYdhj4QCQu78aZPkblIC1X0aPJ+wkDTfTNXa0DlJUjVwqxPaNoJHYWbKbwsQL26N8eitV4B+30u2sEoElXYt4Am7M31REeyKbksqXBaAODjgesB03+IR093FfcMP6u
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR15MB3772.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(396003)(366004)(136003)(39860400002)(376002)(346002)(33430700001)(86362001)(2616005)(36756003)(2906002)(6486002)(5660300002)(478600001)(4326008)(66556008)(66476007)(16526019)(6916009)(316002)(52116002)(8936002)(53546011)(31686004)(31696002)(54906003)(8676002)(66946007)(186003)(33440700001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: azp/ICEJq/P1hF5fCAIB3mv4fw1FdFOJlPOqvbBEmSCJZYv0NGVOst06E8teEXWs00ZONM73jV4X+Rt6dSw1vcR2YohzbccR7g7TV5pDjtZ+OuJAbgtWE5Pb0F/WQl+Zt8s4uQgr1OjhmK+c6zjKe0sgQUEvr4pDsKnN201EGW1a+eK5JvwLbwzK6jY5UdztG6vAaCMpRboi3yB0l1eiLZ2n95nUBuR70H9APWg/cft03zQzp33lrQIrJNaE0Vwwl0Ge6/FBhMI3idlZOIf3EJQKd2TngttJUa9RPHl4QmlJgmbzbQvc+TeOTN88QGNDhGydCfyCaZ/zq0ScYQbIpsbyRLk25uY6mkIdjpqdi7hePHux4Y4jZaSzLWaHpsR78mWuomZd0KCaeM+Tcs96ionX6zXNkW3dI9S2ii1Fp8OciH5YN5olzo0yzJMpUad9/2BfQP/hjt4FF1C2Vb9/9vI+5C0rVaU+wXLCgfXRjpANkhajmBxZ03Pmkdz32KAnIenQLbpA00RxTIo+2OpTL/Ld3WRwEUy70o2KgW4lKOzhuhWN6srNHz3NL7ji/NsbrvjovenVzgxUTTN7hg7Vz9Dd3S+z/16Z8V9oLWpbGZDeJ+f1xg8qtZhfkwJkpLaRxdoTIGrs196GQTnq66+WtOY5DrJ4XOOBfXCTe0zFFS1P1KXXAN0svOGgzxCMyfDssh9MhxKKAf8CpbPezrvOMPtqHpKhIPbcscpZY8NojUHAbM0lXsuM03AfDFKtTwjycU925LDEpEST7bhMncWmR+xUd4RXcd5YTXx8sf4GV6i5cxqkTw9QWhT6Oecg8YjLIV6HcBPUG2PgnDx/RVY+rg==
X-MS-Exchange-CrossTenant-Network-Message-Id: ffaa3eb1-d109-4f1d-c18c-08d7f1e8794d
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 May 2020 18:08:26.8121
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oVLy/N1YGzn/RZseCss6d+hSPqordCUAzOpDVjPYAt47YJ53GlTGTVjFJK40c47p
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR15MB3820
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-06_09:2020-05-05,2020-05-06 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 adultscore=0 malwarescore=0 bulkscore=0 spamscore=0 clxscore=1015
 impostorscore=0 priorityscore=1501 mlxlogscore=999 mlxscore=0 phishscore=0
 suspectscore=2 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005060147
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/5/20 8:09 PM, Andrii Nakryiko wrote:
> On Tue, May 5, 2020 at 5:54 PM Alexei Starovoitov <ast@fb.com> wrote:
>>
>> On 5/5/20 5:14 PM, Yonghong Song wrote:
>>>
>>>
>>> On 5/5/20 2:30 PM, Andrii Nakryiko wrote:
>>>> On Sun, May 3, 2020 at 11:26 PM Yonghong Song <yhs@fb.com> wrote:
>>>>>
>>>>> Given a bpf program, the step to create an anonymous bpf iterator is:
>>>>>     - create a bpf_iter_link, which combines bpf program and the target.
>>>>>       In the future, there could be more information recorded in the
>>>>> link.
>>>>>       A link_fd will be returned to the user space.
>>>>>     - create an anonymous bpf iterator with the given link_fd.
>>>>>
>>>>> The bpf_iter_link can be pinned to bpffs mount file system to
>>>>> create a file based bpf iterator as well.
>>>>>
>>>>> The benefit to use of bpf_iter_link:
>>>>>     - using bpf link simplifies design and implementation as bpf link
>>>>>       is used for other tracing bpf programs.
>>>>>     - for file based bpf iterator, bpf_iter_link provides a standard
>>>>>       way to replace underlying bpf programs.
>>>>>     - for both anonymous and free based iterators, bpf link query
>>>>>       capability can be leveraged.
>>>>>
>>>>> The patch added support of tracing/iter programs for BPF_LINK_CREATE.
>>>>> A new link type BPF_LINK_TYPE_ITER is added to facilitate link
>>>>> querying. Currently, only prog_id is needed, so there is no
>>>>> additional in-kernel show_fdinfo() and fill_link_info() hook
>>>>> is needed for BPF_LINK_TYPE_ITER link.
>>>>>
>>>>> Signed-off-by: Yonghong Song <yhs@fb.com>
>>>>> ---
>>>>
>>>> LGTM. See small nit about __GFP_NOWARN.
>>>>
>>>> Acked-by: Andrii Nakryiko <andriin@fb.com>
>>>>
>>>>
>>>>>    include/linux/bpf.h            |  1 +
>>>>>    include/linux/bpf_types.h      |  1 +
>>>>>    include/uapi/linux/bpf.h       |  1 +
>>>>>    kernel/bpf/bpf_iter.c          | 62 ++++++++++++++++++++++++++++++++++
>>>>>    kernel/bpf/syscall.c           | 14 ++++++++
>>>>>    tools/include/uapi/linux/bpf.h |  1 +
>>>>>    6 files changed, 80 insertions(+)
>>>>>
>>>>
>>>> [...]
>>>>
>>>>> +int bpf_iter_link_attach(const union bpf_attr *attr, struct bpf_prog
>>>>> *prog)
>>>>> +{
>>>>> +       struct bpf_link_primer link_primer;
>>>>> +       struct bpf_iter_target_info *tinfo;
>>>>> +       struct bpf_iter_link *link;
>>>>> +       bool existed = false;
>>>>> +       u32 prog_btf_id;
>>>>> +       int err;
>>>>> +
>>>>> +       if (attr->link_create.target_fd || attr->link_create.flags)
>>>>> +               return -EINVAL;
>>>>> +
>>>>> +       prog_btf_id = prog->aux->attach_btf_id;
>>>>> +       mutex_lock(&targets_mutex);
>>>>> +       list_for_each_entry(tinfo, &targets, list) {
>>>>> +               if (tinfo->btf_id == prog_btf_id) {
>>>>> +                       existed = true;
>>>>> +                       break;
>>>>> +               }
>>>>> +       }
>>>>> +       mutex_unlock(&targets_mutex);
>>>>> +       if (!existed)
>>>>> +               return -ENOENT;
>>>>> +
>>>>> +       link = kzalloc(sizeof(*link), GFP_USER | __GFP_NOWARN);
>>>>
>>>> nit: all existing link implementation don't specify __GFP_NOWARN,
>>>> wonder if bpf_iter_link should be special?
>>>
>>> Nothing special. Just feel __GFP_NOWARN is the right thing to do to
>>> avoid pollute dmesg since -ENOMEM is returned to user space. But in
>>> reality, unlike some key/value allocation where the size could be huge
>>> and __GFP_NOWARN might be more useful, here, sizeof(*link) is fixed
>>> and small, __GFP_NOWARN probably not that useful.
>>>
>>> Will drop it.
>>
>> actually all existing user space driven allocation have nowarn.
> 
> Can you define "user space driven"? I understand why for map, map key,
> map value, program we want to do that, because it's way too easy for
> user-space to specify huge sizes and allocation is proportional to
> that size. But in this case links are fixed-sized objects, same as
> struct file and struct inode. From BPF world, for instance, there is
> struct bpf_prog_list, which is created when user is attaching BPF
> program to cgroup, so it is user-space driven in similar sense. Yet we
> allocate it without __GFP_NOWARN.

For tiny objects it doesn't really matter. If slab cannot allocate
another single page the system is in bad shape and warn is good
to have in most cases, but when it's user driven like here that
warn won't help kernel developers debug ooms. Most likely NIC driver
is spamming page alloc warn at this point.
In this particular case bpf_iter arguments will likely grow
and struct will grow too, but probably not the point of kmalloc_large,
so it's really fine which ever way.
Personally I would keep nowarn here.

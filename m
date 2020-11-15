Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5423A2B321A
	for <lists+netdev@lfdr.de>; Sun, 15 Nov 2020 05:17:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726621AbgKOEOp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Nov 2020 23:14:45 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:60414 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726177AbgKOEOo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Nov 2020 23:14:44 -0500
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AF4BVnG021705;
        Sat, 14 Nov 2020 20:14:15 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=ZNyhOMka/hgXg57x0X/kSMLwTbHMHkOtWlxThuycihQ=;
 b=erBwoyvkB2D/YOd5Z1bD5+CfmhL/TvYG3KVmi97MCxk9n9SngNgUVT2Imhibwwc8rKUl
 y8t81poLEXwTh5SUDQ1/qGkA3YRTWi7VAG+UPq2HDEVhcUVxnNOg7ADg3F30tVikkVTY
 txgm+U85ehytJBK+dP5RYrJswxFDK1ZYUw4= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 34tbesjnbt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Sat, 14 Nov 2020 20:14:14 -0800
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Sat, 14 Nov 2020 20:14:13 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VydRfMkLCWs+GPF0R46QgbXNLg1Tzp68zG/OHWsz7cPrg/SStVYHr8hFLJPKUD9mcgNwT0ISiIWtzNK6bAqSCr54U9n32DEJ1DsW0533/RqykON2Z08GcfgUN1y0yuwPY43T6wf//XtSybnDNzIb4HHFqj/c6QGPeDOkSUuW78BH8/bf1z9IuApE81D7bb4rrQ7e1hEtNprHIi4x30r7ZXMFY20DET3/iDbQ9SOg4qzb7OfFw0lDyftNsaps1cPPJLQ3BTv9T17W5c1bfS5bQDBMucFITPritdOeZOz3ZH3kNU9vOqDdWo48K6g3wdmKxI/wmMxVuBm+AN0iuZw18A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZNyhOMka/hgXg57x0X/kSMLwTbHMHkOtWlxThuycihQ=;
 b=QHmTJo1C1OneF+v0+BUqPExvqCqM/POVbROWYmxbBhMraxZBBvYC8My2K9zPdPx4AoEUNbiQQ3vZbGibTvoBDmMYHqfv+1i6tFhGa1XeaS6Ze7IUsX/1HWwAeAtSnICMGcx9PuRrCz9MaXYaomnC8OBqH1KrEiP71zb3UaBYExQXqr1L0jPB4BWD5NemVRGuCuiCBld6UpfqQg+QMEmEMz/jWsyFt1fyGwmMnZmQJhzbk/NwvnQS1dnbA1R5b600v2Ue+GrqhrOW93A1LUYgpSnY80JTYWhqXniUtRfo9zn0opw6pdOAqvDLRWXwg2jgNJ5hyliUARQebiEkqF18Ug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZNyhOMka/hgXg57x0X/kSMLwTbHMHkOtWlxThuycihQ=;
 b=dcu+WGnpjmNWsLuPyYJpZLoabvvPy339XxQTdBHU0HL/H/1c5KA/q9hO5fVz2LvOmJabxbw1O1dGZZZk4FiU1c3xhyBiX/M4DUh9ymNdrNM4KSp6Xmhvb941viFhgSl6pL0RLdXGU6wpFf85XT4EIglrmzyS1kH7ynO4bDOkJwI=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BY5PR15MB3666.namprd15.prod.outlook.com (2603:10b6:a03:1fc::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.23; Sun, 15 Nov
 2020 04:13:58 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::8887:dd68:f497:ea42]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::8887:dd68:f497:ea42%3]) with mapi id 15.20.3541.025; Sun, 15 Nov 2020
 04:13:57 +0000
Subject: Re: [RFC bpf-next 1/3] bpf: add module support to btf display helpers
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     Alan Maguire <alan.maguire@oracle.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>, Hao Luo <haoluo@google.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Quentin Monnet <quentin@isovalent.com>,
        open list <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
References: <1605291013-22575-1-git-send-email-alan.maguire@oracle.com>
 <1605291013-22575-2-git-send-email-alan.maguire@oracle.com>
 <CAEf4BzaaUdMnfADQdT=myDJtQtHoQ_aW7T8XidrCkYZ=pGXuaQ@mail.gmail.com>
 <CAADnVQK6PFAHQMBgQ=Xp7tUFkUBg5yUgBM+r5mi-Kd5UWNWHzw@mail.gmail.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <778cc9b5-2358-e491-1085-2a5c11dbbf57@fb.com>
Date:   Sat, 14 Nov 2020 20:13:54 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.4.2
In-Reply-To: <CAADnVQK6PFAHQMBgQ=Xp7tUFkUBg5yUgBM+r5mi-Kd5UWNWHzw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
X-Originating-IP: [2620:10d:c090:400::5:7186]
X-ClientProxiedBy: CO2PR05CA0107.namprd05.prod.outlook.com
 (2603:10b6:104:1::33) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21e8::1073] (2620:10d:c090:400::5:7186) by CO2PR05CA0107.namprd05.prod.outlook.com (2603:10b6:104:1::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.15 via Frontend Transport; Sun, 15 Nov 2020 04:13:56 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 41d37001-c23d-473c-a2e6-08d8891cdf7b
X-MS-TrafficTypeDiagnostic: BY5PR15MB3666:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY5PR15MB3666AF956C67DB1130C1AA4CD3E40@BY5PR15MB3666.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2E8IVcJbjElL0y6Qi4nyhrMofpGd0+WXrJrb9tuYRv5QVO74mZZdE6zGitnbkHS7/0m7cidzb8lJCYrK7myIUZZiyi00vpspAP2DHRwuH+WA5ySL0wQ4sb8A6smyjZOFdIfgFpCkcahR5oL0dn1eJl4whtlmtBN2bbI1d+FDaNPDrjzrr8iLNGYlCSxkYiZri5O9YYzLh5OHpNEKjTK6s4oKDFCOagKIynTk/mHsO5KUx7jh9pe+e1bqECXinv/Jsj9CsMsvZ7mhg+t0QfMxiAdojNOkwheh6MvrDljUdeal3ijujdX9EmHLYfjWQeGNHaKQ3iI7DeC7l1Q6g+er1oTA3DMEmpYzwvrVC49HCHGUZSmxTc4zhMtg38DtPLeCChercA++rw3rclIXg3+U5Lb4t7JggLSrNqT3iNQ/h4BEWSSEIhilH93pbGweQGYYg+/VX+iAZTN3BZL7a/ED0g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(376002)(39860400002)(396003)(366004)(346002)(6486002)(31696002)(54906003)(110136005)(8676002)(36756003)(966005)(5660300002)(186003)(7416002)(316002)(66476007)(66556008)(66946007)(83380400001)(52116002)(2906002)(53546011)(31686004)(478600001)(2616005)(16526019)(4326008)(8936002)(86362001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: d/8zFt6EXG9mdbr057sufBCTdZVF4R5g+tLLSMR4C0hddJ8hjHqnynptLc0Y7zKgeVUgMFj1zaJeooPxMYitqIHPyT1rihJY4hjeKjXj6GAtTleDNG+qt8brB2ha3IoWb+m/DEvxZOQuJ+VUrw5xShgWmgnpClIvut7udE00+J9gcov1CfWLzQHgydN1IOiXpDAdRK0/wJu49fg7vQrnVPdzabEqgvSARfsp2bd4ddHLsXlUUX99T2FHPWli6ehd8uLbVRfHsVexk2QOcTAwYOzhJtjIrNo7GLnB6GqjI8Kc/AQ14lDnFl3a729pzvJ2s4EGvW5IL57mWwl2oAuPT5nMt4EOk4EpL2QSFpT7q57V+MZ285desoumaGtqS9Lvnjl+sPxas69QoC/5+9/Wmf0P7xRxqHeSqZuPDf40ZGItn2yg8ESZm/nFQPOFUGu4tj2GIK5qFefXA9lfQXzGQchtGRO26OlY6zOI1MbJ2KtFgDuIoUZWKVhrQwbq4pCa/lgHTCOWa2P+wsU2OorPXY9+/1n8m7at+LU2n1xwDry+eJrq6B+eLYvoefsQNQe11BlpydDZZr913U/bJd28BSk3a9Ao6sm0sKAqzc1l/LIRKC8xVY4coHGPkUrl4ucBva/9umpJ6SGtgIpaW3xhwexBZJFQp7T/nhayRNrVQ6ZKra1Sjm2F1ILPtR9a91FVDTQ+gIG4F2luzvZdJscPo3AheI32Mpu2lgJj80ATW0Nbri8G90e25WLTeZuBlWs3uuRyryxI2YspAgKCj22IRs0yhw83thtbr7jqBXLh2pJ77H6vLpADUzjsMilzAoha4LU1x/nDHG+pr8bmOL0jEyTe1pLC6a4TtE488NGwzxua8hSggWjhbJv0fZLRUzs+kL8oOp8DuNrv+MQ++mB6s4kmE9HoeEMLMpjw2LM6aL4=
X-MS-Exchange-CrossTenant-Network-Message-Id: 41d37001-c23d-473c-a2e6-08d8891cdf7b
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Nov 2020 04:13:57.6945
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 78eDkI2gI/5+w9/oy6yvlFP8HU+WkQ3eZpGAKJjZym7xUBZHIoLcY9G3fRYE4S2v
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR15MB3666
X-OriginatorOrg: fb.com
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-15_01:2020-11-13,2020-11-15 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0 bulkscore=0
 impostorscore=0 malwarescore=0 mlxlogscore=999 lowpriorityscore=0
 mlxscore=0 spamscore=0 priorityscore=1501 adultscore=0 suspectscore=0
 clxscore=1011 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011150026
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/14/20 8:04 AM, Alexei Starovoitov wrote:
> On Fri, Nov 13, 2020 at 10:59 PM Andrii Nakryiko
> <andrii.nakryiko@gmail.com> wrote:
>>
>> On Fri, Nov 13, 2020 at 10:11 AM Alan Maguire <alan.maguire@oracle.com> wrote:
>>>
>>> bpf_snprintf_btf and bpf_seq_printf_btf use a "struct btf_ptr *"
>>> argument that specifies type information about the type to
>>> be displayed.  Augment this information to include a module
>>> name, allowing such display to support module types.
>>>
>>> Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
>>> ---
>>>   include/linux/btf.h            |  8 ++++++++
>>>   include/uapi/linux/bpf.h       |  5 ++++-
>>>   kernel/bpf/btf.c               | 18 ++++++++++++++++++
>>>   kernel/trace/bpf_trace.c       | 42 ++++++++++++++++++++++++++++++++----------
>>>   tools/include/uapi/linux/bpf.h |  5 ++++-
>>>   5 files changed, 66 insertions(+), 12 deletions(-)
>>>
>>> diff --git a/include/linux/btf.h b/include/linux/btf.h
>>> index 2bf6418..d55ca00 100644
>>> --- a/include/linux/btf.h
>>> +++ b/include/linux/btf.h
>>> @@ -209,6 +209,14 @@ static inline const struct btf_var_secinfo *btf_type_var_secinfo(
>>>   const struct btf_type *btf_type_by_id(const struct btf *btf, u32 type_id);
>>>   const char *btf_name_by_offset(const struct btf *btf, u32 offset);
>>>   struct btf *btf_parse_vmlinux(void);
>>> +#ifdef CONFIG_DEBUG_INFO_BTF_MODULES
>>> +struct btf *bpf_get_btf_module(const char *name);
>>> +#else
>>> +static inline struct btf *bpf_get_btf_module(const char *name)
>>> +{
>>> +       return ERR_PTR(-ENOTSUPP);
>>> +}
>>> +#endif
>>>   struct btf *bpf_prog_get_target_btf(const struct bpf_prog *prog);
>>>   #else
>>>   static inline const struct btf_type *btf_type_by_id(const struct btf *btf,
>>> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
>>> index 162999b..26978be 100644
>>> --- a/include/uapi/linux/bpf.h
>>> +++ b/include/uapi/linux/bpf.h
>>> @@ -3636,7 +3636,8 @@ struct bpf_stack_build_id {
>>>    *             the pointer data is carried out to avoid kernel crashes during
>>>    *             operation.  Smaller types can use string space on the stack;
>>>    *             larger programs can use map data to store the string
>>> - *             representation.
>>> + *             representation.  Module-specific data structures can be
>>> + *             displayed if the module name is supplied.
>>>    *
>>>    *             The string can be subsequently shared with userspace via
>>>    *             bpf_perf_event_output() or ring buffer interfaces.
>>> @@ -5076,11 +5077,13 @@ struct bpf_sk_lookup {
>>>    * potentially to specify additional details about the BTF pointer
>>>    * (rather than its mode of display) - is included for future use.
>>>    * Display flags - BTF_F_* - are passed to bpf_snprintf_btf separately.
>>> + * A module name can be specified for module-specific data.
>>>    */
>>>   struct btf_ptr {
>>>          void *ptr;
>>>          __u32 type_id;
>>>          __u32 flags;            /* BTF ptr flags; unused at present. */
>>> +       const char *module;     /* optional module name. */
>>
>> I think module name is a wrong API here, similarly how type name was
>> wrong API for specifying the type (and thus we use type_id here).
>> Using the module's BTF ID seems like a more suitable interface. That's
>> what I'm going to use for all kinds of existing BPF APIs that expect
>> BTF type to attach BPF programs.
>>
>> Right now, we use only type_id and implicitly know that it's in
>> vmlinux BTF. With module BTFs, we now need a pair of BTF object ID +
>> BTF type ID to uniquely identify the type. vmlinux BTF now can be
>> specified in two different ways: either leaving BTF object ID as zero
>> (for simplicity and backwards compatibility) or specifying it's actual
>> BTF obj ID (which pretty much always should be 1, btw). This feels
>> like a natural extension, WDYT?
>>
>> And similar to type_id, no one should expect users to specify these
>> IDs by hand, Clang built-in and libbpf should work together to figure
>> this out for the kernel to use.
>>
>> BTW, with module names there is an extra problem for end users. Some
>> types could be either built-in or built as a module (e.g., XFS data
>> structures). Why would we require BPF users to care which is the case
>> on any given host?
> 
> +1.
> As much as possible libbpf should try to hide the difference between
> type in a module vs type in the vmlinux, since that difference most of the
> time is irrelevant from bpf prog pov.

I just crafted a llvm patch where for __builtin_btf_type_id(), a 64bit 
value is returned instead of a 32bit value. libbpf can use the lower
32bit as the btf_type_id and upper 32bit as the kernel module btf id.

    https://reviews.llvm.org/D91489

feel free to experiment with it to see whether it helps.

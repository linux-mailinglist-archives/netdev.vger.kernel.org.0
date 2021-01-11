Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9A822F1A4B
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 16:58:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388240AbhAKP5e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 10:57:34 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:32238 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729200AbhAKP5c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 10:57:32 -0500
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 10BFnRRO029209;
        Mon, 11 Jan 2021 07:56:28 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=QAbyt3grpHYuKmPM0Ly4TrpMsznnYWFLNtxkDeMrgLI=;
 b=YyS+Lbr0owa3Skx9ais68u8mK4Fg+dTnwpZndYGq7fK9obbYga0idsVC4b54ng1JRvB9
 XF3A8o53WNC5zWqSWd1pEO4qE38itCLW55Pqp66WjI/BTvrU8jO3XVOXwJo38DXwsN+G
 ivK4jFPw6eG1W5XABzvxggwWhuba9hMdOGQ= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 35ywp9581c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 11 Jan 2021 07:56:27 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.228) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 11 Jan 2021 07:56:26 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C6WOe7k2O8Kbn1bVlil7xZd1LNnnYIP9LLwlImCCwvvvCx8oCLVbOmhOSHK0vF44AMZTaj7qyQHkRwB6Wzasrj0tt8PAyx2BUpaUkvHA621obYwWo74ZqOBLBrOKLZTNSgWD9A6wEBsa80XSqd5N56/qVvH+f+dJWf/yYKWrkcHH6zhH/jgSLkf2D1wtLxG44hMM4f/Qi+gB/DxXR/ZPyefOzKtezlABstAkmu3TJfo6j8GIArX7GhV7lfNXKDnc/qAb6Ly85j3w/yJZYxTbtvEk+MHGn9b3c0fSSb+sRT0DyfFDQJ9xiEKlC/ksJHAIO/aBoHCzLZadM5sy0/Ib+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QAbyt3grpHYuKmPM0Ly4TrpMsznnYWFLNtxkDeMrgLI=;
 b=WWt0qm7n2p0koBEU9gEC6G9KStjBm+J36nb7nYg02hHkI/eZIfqgNuVNqO/Auv9kpKmxK9yN8Js8iKe2U7ten16omCSKCmny6nm77tJY9LVsjrVXSXtkJ31cvhNnALR8YVf/N+hvj+Y4YA4NGuA/9Pn0v+J+FxGrZwshrTiGUD484YNhiD9/EgCDr2hcGmsXQQFvdlOuDmKqoQ1zb48hggZ/o/q47zEiKXlRdpc3EzvccR7VGi9xIikCjIm1EU5d3MlK+i50Dq8YaTxwrGwsFDDnaxigOT6JC7YZjX6oXGqQgZzJax2HQbU08dcd4GsOEc59Mv9J2Dw5rTvOlN9e+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QAbyt3grpHYuKmPM0Ly4TrpMsznnYWFLNtxkDeMrgLI=;
 b=I60BU4jKZjbuOshmzRIjBmX2Fjp3qR59g5D/NBbBuyQ+NjbTCoTk45f+DOndWBPhGU2wcJ99O06jIpYqWc7LJKmosj2XSRgGGqDflClq1zPWYSjXVKJ8NGfmuIu4U4/6EqIrDRG9Sx1j/fmQJb7XxZPnlJrvCZh432DURTckxOE=
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB2775.namprd15.prod.outlook.com (2603:10b6:a03:15a::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.12; Mon, 11 Jan
 2021 15:56:21 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::9ae:1628:daf9:4b03]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::9ae:1628:daf9:4b03%7]) with mapi id 15.20.3742.012; Mon, 11 Jan 2021
 15:56:21 +0000
Subject: Re: [PATCH bpf-next 1/4] bpf: enable task local storage for tracing
 programs
To:     KP Singh <kpsingh@kernel.org>
CC:     Song Liu <songliubraving@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>, <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Kernel Team <kernel-team@fb.com>, Hao Luo <haoluo@google.com>,
        kernel test robot <lkp@intel.com>
References: <20210108231950.3844417-1-songliubraving@fb.com>
 <20210108231950.3844417-2-songliubraving@fb.com>
 <733ebec6-e4b0-0913-0483-c79338d03798@fb.com>
 <CACYkzJ7eJa7C8=eRL3XoRjmccgD0udoyoi38MOjo7H0rsnZOYA@mail.gmail.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <8b8e687d-b572-ab12-8595-3ab14d58caad@fb.com>
Date:   Mon, 11 Jan 2021 07:56:17 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.0
In-Reply-To: <CACYkzJ7eJa7C8=eRL3XoRjmccgD0udoyoi38MOjo7H0rsnZOYA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2620:10d:c090:400::5:6450]
X-ClientProxiedBy: MWHPR18CA0027.namprd18.prod.outlook.com
 (2603:10b6:320:31::13) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21c1::1158] (2620:10d:c090:400::5:6450) by MWHPR18CA0027.namprd18.prod.outlook.com (2603:10b6:320:31::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6 via Frontend Transport; Mon, 11 Jan 2021 15:56:19 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ce158028-6d8d-4301-5a39-08d8b649709a
X-MS-TrafficTypeDiagnostic: BYAPR15MB2775:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB277566A34026C1A514103F55D3AB0@BYAPR15MB2775.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JnFSCXWs9pAGZGzcUrZvEi68qUL5xqlcrf25hFnH11HMdsqEBrrXoLmI4WRL+zraYte82ih4Hv+l/FEXDLW3r5b7Ww/QgpTVCmO574x/FmEof/82BOZYl3khdqg/CdaNA0cwjDRhaY8AUnB/bLxZWK6nJxHADH9fYkjnQPPfkR9erPpujlCiDXEmwwKhQdq9MKUlJsl6/cqhqWHng3JsN7xBjLZuTSPTZwE84+xZwt7NgeHazp62HandAyS2jfLuAwWev0RsY79HMGRS4cVbFt7BzLyY7mXNc0kLWwCtp+nrf5kKOLay7fWWgS7pJqLOC530GLa4kU6VZBSgKpVj1SxqdsPLqrhcUGT7Oz+IxV9fwOym9IhoNHwpCsVA4xdflXZVwFvRZ/Oz1cnUbm/lodCEtc5fsQXJQsJCqwVOVor0Ci7dD7zzcUrJU9AffLngnkIqga7eicCWT3qPPh48l3N2esfNf8/BxhuPDJQrpWM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(396003)(39860400002)(376002)(346002)(366004)(86362001)(16526019)(2906002)(66556008)(66946007)(66476007)(316002)(54906003)(6916009)(7416002)(53546011)(186003)(4326008)(8676002)(5660300002)(6486002)(31686004)(52116002)(31696002)(478600001)(36756003)(8936002)(2616005)(83380400001)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?N3ZpTm91aTEwandya2hRa0ZWNGxOSzV1OXFCL1R4MXozYjM0dVpnZkxBNHFY?=
 =?utf-8?B?ZVdxZXMvazA3MzdLSS9EWU9ySlZoT1krcEN2RGJGOFlGWkd4VlJERTFocm5y?=
 =?utf-8?B?SnRlQ2hwV3ZqSE0xdnBOZXl6aW9nelRtKzZoS1liOHA3aVg0NEs5amh3d1JW?=
 =?utf-8?B?dE5iM3Q4dFViRWFtRGp2YWVJZUxBNStkLy9rY0NXRjBzRXhaUkhnakNweHN6?=
 =?utf-8?B?Sk5OeGc1ZTZmZVpEZmxhWXgyakt1NWIyTGVVR0hHUnRuRUsxREd4NzdySVp4?=
 =?utf-8?B?MHVycVFnaE9iQ0YvK0tobmwwVm93MWhuUE1vRGN1cUUwSDNVMHhuc3Z0bFdU?=
 =?utf-8?B?UUM2b1JsY0ZFSFBrU0YwdktOWUNEVFFvQ21VWllncjVlb1UrMnpoVWRtZkZ6?=
 =?utf-8?B?Y2drMXFjRFdubjhYekNQUHpPMU1XQzhJZDl4TWZvKythTFhsTDhmdnJOMmU4?=
 =?utf-8?B?c2krOW1majI1MjVaOHlKZ2JDSU81VlVHRU9HYlZ5MjRVL24yRGZqNkxVMk9h?=
 =?utf-8?B?MlZISnV5YjM4NlI2ZGF6Zk5scGoxcUg5UjAwYXl3UUdBOXJKYjZaTlZCbFpN?=
 =?utf-8?B?Vkw5UmRsZTRHLythN0VHeEpHblpsQXZrWGd5aGdVdEVtVGRHOFppZTNpendp?=
 =?utf-8?B?cnhldEV4d2NwTExwTHdra0JPZDBwZFMzNXBWOGJLMXcxZmVNTVBsajJhaWU1?=
 =?utf-8?B?VWNiMnE2dWIrMlFGTzZJNS8wSjIwckh1b0VkOUhSeVh2N0djdUJ3TmsxNmNp?=
 =?utf-8?B?RjBsN1FSZEdTTzJxb0FGVVVOcldhL1ozWEJISHEwS2ROME1EdE1XMjdoTW9k?=
 =?utf-8?B?cmtpalBIQTlCdmpPMkJ5OFg1OGVvVEozUXhZNExvcm5qN0oxZ0xGQTluTlQv?=
 =?utf-8?B?eFNNM2ZNRkJiODZISkNFcDZyRVJTNys0L2IzckRSYktoUnM3RmNPSHBPdzVq?=
 =?utf-8?B?VmxCN0lqYjRFKytTQ0tXQTVnaWVjaTFBODhQbCt1eStuems2QlJ2R1BNbE9Y?=
 =?utf-8?B?QWRxY0N6NVVyVXRPU0lYazdmaE1aM1dIRU9jaWVBbGFuaXBzUWZJWTR5ODgw?=
 =?utf-8?B?TVV4bTVyNGVuSVlWVVBVU2NXMDJYNGJJN08vYXIxMGk3ZEtra0lTbytFaHNF?=
 =?utf-8?B?Um5YQnF4MkRkMUZjekdLeFo1Wi9pQmVMeTdrTW1kTEE4MHp5ZmZudmJXdmZD?=
 =?utf-8?B?UWx0VXhCbDRBUVF2d1VnaE5kY0xjU3kva204QUVJcVFEcm1PSklxUUlON21P?=
 =?utf-8?B?bjZkNVI2Z1J5bGdRK2ROZ0RteHNzWmNiWEpaTng5dnVEdFJKeFJoRGN4UGFi?=
 =?utf-8?B?Q1ZMQmdFUThwWDdTbFA3YnNjdE5xMTR3Tm03eWJTYTlCYWVRNzk5UjV4QTFM?=
 =?utf-8?B?QnVlUjh2SmoxVFE9PQ==?=
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jan 2021 15:56:20.9867
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-Network-Message-Id: ce158028-6d8d-4301-5a39-08d8b649709a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UUi43F0G8W/sEgyzQg3b8E5BSdsfjCu/B4Vh2zpVqsg2AjWDflUg3mrpkwKyTvxm
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2775
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-11_26:2021-01-11,2021-01-11 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0
 priorityscore=1501 suspectscore=0 clxscore=1015 malwarescore=0 bulkscore=0
 impostorscore=0 lowpriorityscore=0 mlxlogscore=999 adultscore=0
 spamscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101110096
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/11/21 2:17 AM, KP Singh wrote:
> On Mon, Jan 11, 2021 at 7:27 AM Yonghong Song <yhs@fb.com> wrote:
>>
>>
>>
>> On 1/8/21 3:19 PM, Song Liu wrote:
>>> To access per-task data, BPF program typically creates a hash table with
>>> pid as the key. This is not ideal because:
>>>    1. The use need to estimate requires size of the hash table, with may be
>>>       inaccurate;
>>>    2. Big hash tables are slow;
>>>    3. To clean up the data properly during task terminations, the user need
>>>       to write code.
>>>
>>> Task local storage overcomes these issues and becomes a better option for
>>> these per-task data. Task local storage is only available to BPF_LSM. Now
>>> enable it for tracing programs.
>>>
>>> Reported-by: kernel test robot <lkp@intel.com>
>>> Signed-off-by: Song Liu <songliubraving@fb.com>
>>> ---
> 
> [...]
> 
>>>    struct cfs_rq;
>>>    struct fs_struct;
>>> @@ -1348,6 +1349,10 @@ struct task_struct {
>>>        /* Used by LSM modules for access restriction: */
>>>        void                            *security;
>>>    #endif
>>> +#ifdef CONFIG_BPF_SYSCALL
>>> +     /* Used by BPF task local storage */
>>> +     struct bpf_local_storage        *bpf_storage;
>>> +#endif
>>
>> I remembered there is a discussion where KP initially wanted to put
>> bpf_local_storage in task_struct, but later on changed to
>> use in lsm as his use case mostly for lsm. Did anybody
>> remember the details of the discussion? Just want to be
>> sure what is the concern people has with putting bpf_local_storage
>> in task_struct and whether the use case presented by
>> Song will justify it.
>>
> 
> If I recall correctly, the discussion was about inode local storage and
> it was decided to use the security blob since the use-case was only LSM
> programs. Since we now plan to use it in tracing,
> detangling the dependency from CONFIG_BPF_LSM
> sounds logical to me.

Sounds good. Thanks for explanation.

> 
> 
>>>
>>>    #ifdef CONFIG_GCC_PLUGIN_STACKLEAK
>>>        unsigned long                   lowest_stack;
>>> diff --git a/kernel/bpf/Makefile b/kernel/bpf/Makefile
>>> index d1249340fd6ba..ca995fdfa45e7 100644
>>> --- a/kernel/bpf/Makefile
>>> +++ b/kernel/bpf/Makefile
>>> @@ -8,9 +8,8 @@ CFLAGS_core.o += $(call cc-disable-warning, override-init) $(cflags-nogcse-yy)
>>>
>>>    obj-$(CONFIG_BPF_SYSCALL) += syscall.o verifier.o inode.o helpers.o tnum.o bpf_iter.o map_iter.o task_iter.o prog_iter.o
>>>    obj-$(CONFIG_BPF_SYSCALL) += hashtab.o arraymap.o percpu_freelist.o bpf_lru_list.o lpm_trie.o map_in_map.o
>>> -obj-$(CONFIG_BPF_SYSCALL) += local_storage.o queue_stack_maps.o ringbuf.o
>>> +obj-$(CONFIG_BPF_SYSCALL) += local_storage.o queue_stack_maps.o ringbuf.o bpf_task_storage.o
>>>    obj-${CONFIG_BPF_LSM}         += bpf_inode_storage.o
>>> -obj-${CONFIG_BPF_LSM}          += bpf_task_storage.o
>>>    obj-$(CONFIG_BPF_SYSCALL) += disasm.o
>>>    obj-$(CONFIG_BPF_JIT) += trampoline.o
>>>    obj-$(CONFIG_BPF_SYSCALL) += btf.o
>> [...]

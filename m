Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38AFC205525
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 16:52:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732877AbgFWOwa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 10:52:30 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:19532 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732801AbgFWOw3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jun 2020 10:52:29 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05NEowID010450;
        Tue, 23 Jun 2020 07:52:13 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=uvFRh88/3WSntSAi/NC/ibwWDKHkQ+3zmvepgeuqkJg=;
 b=F4RX0qYksvIGlPL58XbU5pyFzBmiWAjdMSQPPG5zjFfvwSuYCwr3GNldwGdsWMOqGgHo
 E2t145fAwRxOsksW7IHFEA5ooFU2tMQ2JlqYxPH/2+43O4eypCxpjCX699CH2J7S2vAs
 svhij8ndoJCCYMs1BqQGLKaswymtY/T6QCY= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 31uk3cg8f3-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 23 Jun 2020 07:52:13 -0700
Received: from NAM04-CO1-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.230) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 23 Jun 2020 07:52:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IPzoHZT4hc3Np01/QRVdJouFZ8zlIH8T7Rbo+EOsG8yyGOiHJbZoACiFRw8uxA1nDtnbNbI9uaiC8TOmso5+0u+jOBbP2dzixV+tzdld3XRlavOBtemZXb4FfmSnXU+WOaujqsqR4Q9p62fMEJtl6ToNH5ZBGWxVfoGvEj1uK9VR9YaEXUSSw+dnuDSWr6ZW/b/YjPNXZmrjJtyGdEARECFyO3nL+EX7bXqOg8mEAXr43laRgTpvTx7U/yB/QsiymgWSWAOYgSvqU7xsKS9RRuroXy2/TeqdzgZ3G70T1fQDp3vM8RTo5EBCDjulhFQjVEEyBXkf0gNMO/ojHbfGzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uvFRh88/3WSntSAi/NC/ibwWDKHkQ+3zmvepgeuqkJg=;
 b=HU0A44B6fOTXV36uXi06Rd1yOggmxhFqj/KnkFqEc7XWzOLrTyx/Xz+Qmh6k/Y6cXTB70/cLz+7LN4kIvG+FIxJN4NnRBr5D6H+F0/dqs/ffhVYdcrivk6Qa0Uc9YKn20l09zufeDPGREYjKQzsj6qhB7N9aSHWrj0lfukM+q807DOrrVzrDQSGrMS3FlEbuvBRYra6xlKYpUqYOa3m8WS5r+zM//E4rtq5x7gTDw0Smgt8olqAyRyEKGUxbtyKcwjsx31myYg7mW/qRtEB8y5wmKp5hJ1Kc+xTwINALmZNuB4R7nG6z1J2vTKKDIb7e9W75iUVMw9woQLCXOZKZaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uvFRh88/3WSntSAi/NC/ibwWDKHkQ+3zmvepgeuqkJg=;
 b=iocvpwuOamDr4no66vOeB6imvsNFPWXg0otZSBq62gIEt82wa+i1TmPmphJKDYIBc9abB5EsEJk5t5Aoz7SSDSD+An0aIaSRyHZVHvF/3Pxsiy6B9WvbPq5Tb05h6oxtWKoukPh9DZr4v20fxkcwfKvxnudnL3/Jxxf3LhmXUS8=
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB4120.namprd15.prod.outlook.com (2603:10b6:a02:c4::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.22; Tue, 23 Jun
 2020 14:52:11 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::4922:9927:5d6c:5301]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::4922:9927:5d6c:5301%7]) with mapi id 15.20.3109.027; Tue, 23 Jun 2020
 14:52:11 +0000
Subject: Re: [PATCH bpf-next v3 05/15] bpf: add bpf_skc_to_tcp6_sock() helper
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Martin KaFai Lau <kafai@fb.com>
References: <20200623003626.3072825-1-yhs@fb.com>
 <20200623003631.3073864-1-yhs@fb.com>
 <CAEf4BzaGWuAYzN2-+Gy9X8N2YPb341ZGugKzk78qiPURMgv7rw@mail.gmail.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <26d6f7ee-28ea-80ba-fd76-e3b2f0327163@fb.com>
Date:   Tue, 23 Jun 2020 07:52:09 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.9.0
In-Reply-To: <CAEf4BzaGWuAYzN2-+Gy9X8N2YPb341ZGugKzk78qiPURMgv7rw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY3PR04CA0004.namprd04.prod.outlook.com
 (2603:10b6:a03:217::9) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21d6::1377] (2620:10d:c090:400::5:7789) by BY3PR04CA0004.namprd04.prod.outlook.com (2603:10b6:a03:217::9) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.20 via Frontend Transport; Tue, 23 Jun 2020 14:52:10 +0000
X-Originating-IP: [2620:10d:c090:400::5:7789]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8a12cb82-27ce-47fa-f928-08d81785024d
X-MS-TrafficTypeDiagnostic: BYAPR15MB4120:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB41209AD9EAEC6BCC1322ECE8D3940@BYAPR15MB4120.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:3276;
X-Forefront-PRVS: 04433051BF
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SXEcSZGTeq8xwTUmos2bX9wSbtJ/Ya8qF1wdsJpJrj1aDZJl9xdWvjVMGpqPSTByln1AMPMBn2xBGwCEuuDotulTAIqmAGX7VJlb/Rxs+GBYozF3Av9tORSUe0HdacTJzPC+1Ivy+jDUc7Cu0RHTKDgj1eQnVdcKmf9najsz1FasnZ8jIS3+uKzBf7poP7Yctn9JXP8c0sPVMn3dxCFYpMsKk4Zih8juTZrH6NZZ8Tth2cFBcvQZJGy3VH++jGl9dFOlEpfUYchLoCGdvebtsnEqUhRzNuYnvID56hFbjDv/YWpDLakA5JqAH0okdBwp0CP2lNdAgWKqPHmWrXwLc/Oge/2nNsVb/ZSyEmEN1YsAEFTmxbUIEsiewEUx5WuU
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(39860400002)(396003)(366004)(136003)(346002)(376002)(2906002)(4326008)(53546011)(16526019)(186003)(31686004)(54906003)(316002)(52116002)(478600001)(36756003)(8936002)(5660300002)(86362001)(6916009)(6486002)(2616005)(31696002)(8676002)(66556008)(66476007)(66946007)(83380400001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: d512F+AOktUVI+jiDhoUGmo/uSwJgpxOLavFM21UjXr+/6snZ3JQwb/zkOHaKfPeooB8ghmu3OdbSnbwsTIR2w8thztDpRoK3J+F60aK4ECuzuRBRypuRe9vYqxaOrl4+W7bnJBk962DgcmggSLs2u26xacgpUJxUIKWjCOJzy/xHqYRXFDqjt9MnUSfJxW3oJ2Mp7KoDpNvtXqsPOPli1XYJ2RtBU04Ky8hC7w0eKUs30w2zTIS6bqO1VjuG+4Ypox/L+kQfw4c/Ud3Acq1GmgSQt5xn4frSv1332Br/yifYKH0MjjvlSCGkf4KRyjviWtainjbmYyn1W0NtkMgdrs456+WPkDKYrABDnf8Xt+962Q8xl3Xum5a97y9qCCkAWNEEpGSJxi6XhREmWuAVITkEJOnVRbVaIK6WzQUFQCWstlmVtxCwDSRMT3ADbN1rAELE53zVWSNWwzmrZYD6DxpZvvXlka+Etzo6tKAD5zsxEoeps1SvDvjnUcrhSDaJNrL+bkLYc+Qw+LQVG+NCw==
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a12cb82-27ce-47fa-f928-08d81785024d
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jun 2020 14:52:11.1617
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PHuozTX1p9GP1TTfIFNJplrFim3iiWpoU4iHGO/dwJKT1g6bD/L3nJmMlFHkArcB
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB4120
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-23_07:2020-06-23,2020-06-23 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015
 impostorscore=0 suspectscore=0 phishscore=0 mlxlogscore=999
 priorityscore=1501 mlxscore=0 lowpriorityscore=0 adultscore=0 spamscore=0
 malwarescore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006120000 definitions=main-2006230117
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/22/20 11:39 PM, Andrii Nakryiko wrote:
> On Mon, Jun 22, 2020 at 5:38 PM Yonghong Song <yhs@fb.com> wrote:
>>
>> The helper is used in tracing programs to cast a socket
>> pointer to a tcp6_sock pointer.
>> The return value could be NULL if the casting is illegal.
>>
>> A new helper return type RET_PTR_TO_BTF_ID_OR_NULL is added
>> so the verifier is able to deduce proper return types for the helper.
>>
>> Different from the previous BTF_ID based helpers,
>> the bpf_skc_to_tcp6_sock() argument can be several possible
>> btf_ids. More specifically, all possible socket data structures
>> with sock_common appearing in the first in the memory layout.
>> This patch only added socket types related to tcp and udp.
>>
>> All possible argument btf_id and return value btf_id
>> for helper bpf_skc_to_tcp6_sock() are pre-calculcated and
>> cached. In the future, it is even possible to precompute
>> these btf_id's at kernel build time.
>>
>> Acked-by: Martin KaFai Lau <kafai@fb.com>
>> Signed-off-by: Yonghong Song <yhs@fb.com>
>> ---
> 
> Looks good to me as is, but see a few suggestions, they will probably
> save me time at some point as well :)
> 
> Acked-by: Andrii Nakryiko <andriin@fb.com>
> 
> 
>>   include/linux/bpf.h            | 12 +++++
>>   include/uapi/linux/bpf.h       |  9 +++-
>>   kernel/bpf/btf.c               |  1 +
>>   kernel/bpf/verifier.c          | 43 +++++++++++++-----
>>   kernel/trace/bpf_trace.c       |  2 +
>>   net/core/filter.c              | 80 ++++++++++++++++++++++++++++++++++
>>   scripts/bpf_helpers_doc.py     |  2 +
>>   tools/include/uapi/linux/bpf.h |  9 +++-
>>   8 files changed, 146 insertions(+), 12 deletions(-)
>>
> 
> [...]
> 
>> @@ -4815,6 +4826,18 @@ static int check_helper_call(struct bpf_verifier_env *env, int func_id, int insn
>>                  regs[BPF_REG_0].type = PTR_TO_MEM_OR_NULL;
>>                  regs[BPF_REG_0].id = ++env->id_gen;
>>                  regs[BPF_REG_0].mem_size = meta.mem_size;
>> +       } else if (fn->ret_type == RET_PTR_TO_BTF_ID_OR_NULL) {
>> +               int ret_btf_id;
>> +
>> +               mark_reg_known_zero(env, regs, BPF_REG_0);
>> +               regs[BPF_REG_0].type = PTR_TO_BTF_ID_OR_NULL;
>> +               ret_btf_id = *fn->ret_btf_id;
> 
> might be a good idea to check fb->ret_btf_id for NULL and print a
> warning + return -EFAULT. It's not supposed to happen on properly
> configured kernel, but during development this will save a bunch of
> time and frustration for next person trying to add something with
> RET_PTR_TO_BTF_ID_OR_NULL.

I would like prefer to delay this with current code. Otherwise,
it gives an impression fn->ret_btf_id might be NULL and it is
actually never NULL. We can add NULL check if the future change
requires it. I am not sure what the future change could be,
but you need some way to get the return btf_id, the above is
one of them.

> 
>> +               if (ret_btf_id == 0) {
> 
> This also has to be struct/union (after typedef/mods stripping, of
> course). Or are there other cases?

This is an "int". The func_proto difinition is below:
int *ret_btf_id; /* return value btf_id */

> 
>> +                       verbose(env, "invalid return type %d of func %s#%d\n",
>> +                               fn->ret_type, func_id_name(func_id), func_id);
>> +                       return -EINVAL;
>> +               }
>> +               regs[BPF_REG_0].btf_id = ret_btf_id;
>>          } else {
>>                  verbose(env, "unknown return type %d of func %s#%d\n",
>>                          fn->ret_type, func_id_name(func_id), func_id);
> 
> [...]
> 
>> +void init_btf_sock_ids(struct btf *btf)
>> +{
>> +       int i, btf_id;
>> +
>> +       for (i = 0; i < MAX_BTF_SOCK_TYPE; i++) {
>> +               btf_id = btf_find_by_name_kind(btf, bpf_sock_types[i],
>> +                                              BTF_KIND_STRUCT);
>> +               if (btf_id > 0)
>> +                       btf_sock_ids[i] = btf_id;
>> +       }
>> +}
> 
> This will hopefully go away with Jiri's work on static BTF IDs, right?
> So looking forward to that :)

Yes. That's the plan.

> 
>> +
>> +static bool check_arg_btf_id(u32 btf_id, u32 arg)
>> +{
>> +       int i;
>> +
>> +       /* only one argument, no need to check arg */
>> +       for (i = 0; i < MAX_BTF_SOCK_TYPE; i++)
>> +               if (btf_sock_ids[i] == btf_id)
>> +                       return true;
>> +       return false;
>> +}
>> +
> 
> [...]
> 

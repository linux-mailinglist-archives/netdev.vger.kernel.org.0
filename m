Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94C22259D4A
	for <lists+netdev@lfdr.de>; Tue,  1 Sep 2020 19:38:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728928AbgIARif (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 13:38:35 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:50246 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728312AbgIARic (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Sep 2020 13:38:32 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 081HXDAB021881;
        Tue, 1 Sep 2020 10:38:17 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=w999yw0n3LPDVJWNJfOi6WuI4FWPNYlO0OEpIKfrukM=;
 b=ftMIhrzrRuQX9i4/jWfbJHx8d4X2K46q+GrCFYbjKh4sZEzdjqgybDOlOI9RN3keDJpV
 67WlFRXk925DFxV3HvU9KjjPm5l/ENXktqYwNVYTqgLCt5xZxSdMtvhpFdLD6rW5Bq9h
 d9GmC+fphjcDXpTkDHqbhcFTlHp0tBwrhWw= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 337muh70xh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 01 Sep 2020 10:38:16 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 1 Sep 2020 10:38:16 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XGysxusAvKRaN6l3ite4XAWKfmaBt+CTBulCd/wR5LZPbYneWAWuquZwOqZ7F2iJnxy7JKlGPc7fTtim5dltan21y8hquPQ4Dw5yIV4aym5g56ZMHX8SF4zWXpE/8eaQB/HLneyzQvRYZLBt3zKXhdZBHdN9At/HQhAkS7CKGH82/xwnTM6vwEiAiPTP9Fwic0H5Sx9/BCDjfqEQGb9KQDO19hr8YlY3/SYaxBgXnNgNnXwjMUNCHfSRD4apRB2eXeWVMze27qiVu64CvjqTB78tnIRi8CBWdpPc71KRhOcQReFa5e9QpeHdIFO+7BHf9oP/O3uN2L1Xy+8PJenCWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w999yw0n3LPDVJWNJfOi6WuI4FWPNYlO0OEpIKfrukM=;
 b=DPP99a3491IJ588Wh/p6/2YEqIlUbDRD7xy9xbiRI/AGnIo1+V0F1+BVuEpaSCMhRgzj+eOBVbeGDabOOygiYQ6YqMQd+AP1Lt+vPZC/NzvBG38AZ8xkByjavCq+st1CRATbVwd8BY6TNKS9BPR8V8TZRVO6Z9XXMGQxBwpE2VCocwhFKkolHnApI9Pd92Zf58GvckKBWMdZ4Z/YyIMb/PfxCZF+uAlZWGvx7ZxeOROCYTHvrZ125zLqLKIHBWVAVcTuvg6oYYH9SzvT+EuXBmvrxwxtUona4ybUFAcXLqlYJT2iHHERxLeHtlGjy0Id046hA7ChxSSULaz8yXTpXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w999yw0n3LPDVJWNJfOi6WuI4FWPNYlO0OEpIKfrukM=;
 b=QeI79gEbjVVEmC4nn6x63Otb1GwybZfw5DFD/K7B0PyszyWF3g+xFaiXlCSxI8cXeSmc7lkQyRp6/ncX6qB9slKU8ZMv2BiiaFb6p9C6CkJruqn+o7kQxmCBRVJUZAAu9BmZlDqTys66UnyTTgapKrPyYvqsSCoUGgfnsDKj1eU=
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB3046.namprd15.prod.outlook.com (2603:10b6:a03:fa::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3348.15; Tue, 1 Sep
 2020 17:38:15 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::56b:2925:8762:2d80]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::56b:2925:8762:2d80%7]) with mapi id 15.20.3326.025; Tue, 1 Sep 2020
 17:38:15 +0000
Subject: Re: [PATCH bpf-next v2 1/2] bpf: avoid iterating duplicated files for
 task_file iterator
To:     Josef Bacik <josef@toxicpanda.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
References: <20200828053815.817726-1-yhs@fb.com>
 <20200828053815.817806-1-yhs@fb.com>
 <01bc7a06-e294-7cfe-d284-1b7e834ba90f@toxicpanda.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <31e47eed-0ac0-b221-16ba-5284c1ec6386@fb.com>
Date:   Tue, 1 Sep 2020 10:38:13 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.0
In-Reply-To: <01bc7a06-e294-7cfe-d284-1b7e834ba90f@toxicpanda.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BY3PR10CA0002.namprd10.prod.outlook.com
 (2603:10b6:a03:255::7) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from 255.255.255.255 (255.255.255.255) by BY3PR10CA0002.namprd10.prod.outlook.com (2603:10b6:a03:255::7) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3348.15 via Frontend Transport; Tue, 1 Sep 2020 17:38:14 +0000
X-Originating-IP: [2620:10d:c090:400::5:f95]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c5352d97-0520-4299-7c68-08d84e9dce41
X-MS-TrafficTypeDiagnostic: BYAPR15MB3046:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB3046871F3809336B18848A03D32E0@BYAPR15MB3046.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Vsu4bnmkwsgVq9rAFgfbWULqKmAongfAIuxPq1P+LT2fS8WQuNEa8qkC8jZFRKV7rEahNoFhzdlY2abE10qGrgHLaJE7bJKG5z2JSsY/eHHvh/Uc2+/eHssia9XQeoI996r1a621ItBboJk3CDF/LlGj1LnNThrKBmAqHX3jJhlaNeH9x0C9aAXdBcNedqDDAbkFSX1eyBGjW9ur4RzMJGH9nUTbJoRtYWMYOYxa1Cc91uYXWazJ8+8tBZJ4xrUuWTgYbrKRx4cm32Tsq+o8K8ZoTn9nWrxTab7gSOEcoYIrPZsMvOmhGg9vPyrjC+9Uu0tGXh4irAacHkqAucC0UfLYOYhdlQkHzFwJS4UAMPch5P+oB95nXM2Uxd6eHnmy
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(396003)(136003)(346002)(376002)(39860400002)(16576012)(54906003)(52116002)(316002)(956004)(2616005)(53546011)(83380400001)(2906002)(36756003)(66476007)(186003)(6486002)(31686004)(8676002)(4326008)(8936002)(5660300002)(66946007)(86362001)(66556008)(478600001)(31696002)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: lzJMPaHv1h7lxi9gARmO+v5FHBQAuNs4ryLYsEfoZ+c+N/381qkCm53k2SkV1wmZ/cXHrdZ82PTU8my+x6UKuitTpJoEmGFW1DtFj6hXGksR8B4zlwmkBULMLr1uTJJnicgpvb2uotlldsDtTbwJXkg7Yjg+5/91na/+6EGtkKCnp28DvbDbeei5+kmnZykqH7ahYZQJsQs3JxwiL+A51KUdJRFmTXy75NK6BPRIIgxaaUQsj0MnFZpLQ87QyOrbhm+/ba9r21xiHpdFyGFD9ADjl8LG9f5zE/0dlrRPmsLLaDsrUedZ+yYFHV7zm48S1zSHBJKDRII5xI+IIqmUEWThgpko5eoJZZziAdVW1XbrwNfwO+y2GK7N9DMWYxS++gCVS+wAi3UaTNOpf4S/WgU4X/wkqMRQGVB87WICvQLY8lVikWExvGWamWn8U8KTDb/LINF6pCtLob2XmYeEQ/mUIVLs8Cxzr9GigD+yYkXhMlx110O6C2Y3fV5RTwHi1JTvCwMpBgzckPhHiZh6WclHrXu5xDLLBN8Kn+Egnj8zTiUVCORF0OrMB6Bqa1BWccF3K8qVZ8tCwUu+WnKqJichHzmVU7AmdgrYysJmt80x/yPubIVU4a3DdyY2xGKnCdm297ROFXJ872AtUZhfNkdHMYYgs4xOwYkjxHbl3rI=
X-MS-Exchange-CrossTenant-Network-Message-Id: c5352d97-0520-4299-7c68-08d84e9dce41
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Sep 2020 17:38:15.2474
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QPEV4zcDl6wNdDIElcD5Hw9ls3Parlzj+8BtF5Adj+fkEpImgHGPzKA4yvK856ST
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3046
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-01_10:2020-09-01,2020-09-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0
 lowpriorityscore=0 priorityscore=1501 mlxlogscore=999 suspectscore=0
 phishscore=0 adultscore=0 malwarescore=0 spamscore=0 clxscore=1015
 impostorscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006250000 definitions=main-2009010147
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/1/20 10:18 AM, Josef Bacik wrote:
> On 8/28/20 1:38 AM, Yonghong Song wrote:
>> Currently, task_file iterator iterates all files from all tasks.
>> This may potentially visit a lot of duplicated files if there are
>> many tasks sharing the same files, e.g., typical pthreads
>> where these pthreads and the main thread are sharing the same files.
>>
>> This patch changed task_file iterator to skip a particular task
>> if that task shares the same files as its group_leader (the task
>> having the same tgid and also task->tgid == task->pid).
>> This will preserve the same result, visiting all files from all
>> tasks, and will reduce runtime cost significantl, e.g., if there are
>> a lot of pthreads and the process has a lot of open files.
>>
>> Suggested-by: Andrii Nakryiko <andriin@fb.com>
>> Signed-off-by: Yonghong Song <yhs@fb.com>
>> ---
>>   kernel/bpf/task_iter.c | 14 +++++++++-----
>>   1 file changed, 9 insertions(+), 5 deletions(-)
>>
>> It would be good if somebody familar with sched code can help check
>> whether I missed anything or not (e.g., locks, etc.)
>> for the code change
>>    task->files == task->group_leader->files
>>
>> Note the change in this patch might have conflicts with
>> e60572b8d4c3 ("bpf: Avoid visit same object multiple times")
>> which is merged into bpf/net sometimes back.
>>
>> diff --git a/kernel/bpf/task_iter.c b/kernel/bpf/task_iter.c
>> index 232df29793e9..0c5c96bb6964 100644
>> --- a/kernel/bpf/task_iter.c
>> +++ b/kernel/bpf/task_iter.c
>> @@ -22,7 +22,8 @@ struct bpf_iter_seq_task_info {
>>   };
>>   static struct task_struct *task_seq_get_next(struct pid_namespace *ns,
>> -                         u32 *tid)
>> +                         u32 *tid,
>> +                         bool skip_if_dup_files)
>>   {
>>       struct task_struct *task = NULL;
>>       struct pid *pid;
>> @@ -32,7 +33,10 @@ static struct task_struct *task_seq_get_next(struct 
>> pid_namespace *ns,
>>       pid = idr_get_next(&ns->idr, tid);
>>       if (pid) {
>>           task = get_pid_task(pid, PIDTYPE_PID);
>> -        if (!task) {
>> +        if (!task ||
>> +            (skip_if_dup_files &&
>> +             task->tgid != task->pid &&
>> +             task->files == task->group_leader->files)) {
>>               ++*tid;
>>               goto retry;
> 
> Sorry I only checked the task->files and task->group_leader thing, I 
> forgot to actually pay attention to what the patch itself was doing.
> 
> This will leak task structs, you need something like
> 
> if (!task) {
>      ++*tid;
>      goto retry;
> }
> if (skip_if_dup_files && etc) {
>      ++*tid;
>      put_task_struct(task);
>      goto retry;
> }
> 
> otherwise you'll leak tasks.  Thanks,

Or, yes, good catch. Thanks! I too focused on task->files == 
task->group_lead->files and did not think deep on leaking
tasks.

Will send v2.

> 
> Josef

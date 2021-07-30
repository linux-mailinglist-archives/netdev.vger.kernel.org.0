Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B22653DB446
	for <lists+netdev@lfdr.de>; Fri, 30 Jul 2021 09:09:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237632AbhG3HJg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Jul 2021 03:09:36 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:5234 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230226AbhG3HJd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Jul 2021 03:09:33 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16U75HOt017082;
        Fri, 30 Jul 2021 00:09:14 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=PnyGmCu9rBLZ9oKKIfcr4i1iExwV/uTH8K0sBzmDKrw=;
 b=n98MQbwxrTnWlP8uOCRa6faz8Sg2KgXSS6TABezvHbb4/1sMo9IPWQibKZ/D2w8lz8uE
 hdyN+gHS981/LB7RaQASaafwz3qh+Bpgxq5AqSYrj7OylqnNCPRqbzrE1WNvM3UYnP8Y
 TrFe3uRhgWLxAdK2jKspuJRpfquuIIh3Ejc= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3a3vrteaex-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 30 Jul 2021 00:09:14 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.199) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 30 Jul 2021 00:09:13 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Kx3TFeIF4w4YZunsq14FXGNo/anSAgIqfRBk8iZBnkL1HrwAi2UKjmR4HUzkSNwXkHdXKKnasmYTeJnq21hLfRae8KbUKVXIZftx0E9LhfPma5EyzxSPP/3nWYkV46YAJM+ZVrGAfcEt4Xg15TwlyLZ5IDaQJi2uYCoBSwfc+gAxp20K0WJL/Z4mEn+Np9OaK5YhpkXrZVU/F7UmeYgMLp+6IJb2NrCaKcxpG8FXK6T4Xi6jbT43byAmpqFq/QGIdf+dEDt2CFqycQ2vULQ7aXmMeXareGVhik+iIxkaqO1G694zXygdJuJNc4GKAjymQ02yRn8PB28Tt/Fntjnbbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PnyGmCu9rBLZ9oKKIfcr4i1iExwV/uTH8K0sBzmDKrw=;
 b=iAx6NVTgJuZqfjLMTI91cm+w9+zJUe1F+FvlHcRH+QUKmdGx9zkDKocZyiOvP8DzNkxWdObZYHS0DeY7ZMGVD7fSgI5J1KY2WR6JSIJ8mmdFSdMfmiLwJmRhQMWjQFokKuT/UDYoaXyAtJ81muROE4cJu8eXl2n0PGkivX4F0YP3A7AyJe7X4jFdKhgU8NpOipoadz6EiQa98MsXsubuufzdZ5OfI9/h6DeGqHuqpiaCvRio4IjPsg0n3ikZkRmh8/FY0Iw3DJ7CZ7kV5h3I1drhXNsHlOHXWS5nxiFlY+BhUZ6pBlmTYfSZ1sn+RjCMp3iCv6StMTMQXNa02KFhaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SN6PR15MB2413.namprd15.prod.outlook.com (2603:10b6:805:1b::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.18; Fri, 30 Jul
 2021 07:09:11 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::c143:fac2:85b4:14cb]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::c143:fac2:85b4:14cb%7]) with mapi id 15.20.4373.021; Fri, 30 Jul 2021
 07:09:11 +0000
Subject: Re: [PATCH bpf-next 1/2] bpf: af_unix: Implement BPF iterator for
 UNIX domain socket.
To:     Kuniyuki Iwashima <kuniyu@amazon.co.jp>
CC:     <andrii@kernel.org>, <ast@kernel.org>, <benh@amazon.com>,
        <bpf@vger.kernel.org>, <daniel@iogearbox.net>,
        <davem@davemloft.net>, <john.fastabend@gmail.com>, <kafai@fb.com>,
        <kpsingh@kernel.org>, <kuba@kernel.org>, <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>, <songliubraving@fb.com>
References: <bcdc1540-c957-51b8-2a94-1b350a1a5a6a@fb.com>
 <20210730065359.43302-1-kuniyu@amazon.co.jp>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <65fa9a82-6e1b-da0f-9cad-9b26771980fd@fb.com>
Date:   Fri, 30 Jul 2021 00:09:08 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.12.0
In-Reply-To: <20210730065359.43302-1-kuniyu@amazon.co.jp>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0336.namprd03.prod.outlook.com
 (2603:10b6:a03:39c::11) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21d6::1130] (2620:10d:c090:400::5:1fa2) by SJ0PR03CA0336.namprd03.prod.outlook.com (2603:10b6:a03:39c::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.20 via Frontend Transport; Fri, 30 Jul 2021 07:09:10 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3328d127-1c5d-413c-9566-08d95328ee6f
X-MS-TrafficTypeDiagnostic: SN6PR15MB2413:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR15MB2413F7F89D31AFCD6B4759BBD3EC9@SN6PR15MB2413.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:2201;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +nPkkBCvUJXSgs29ssZizfVnwDbosleQBhDVNHlmjHlBYLAUQhXkqyaReaLTBHofQ9e9HJ3Q2ROwwVfiQNBxzaTCAYNaRz2A9BUvIlUXbE19jtW7EnoOMJr355m4C44jFxAiWE+7rbvhBm/k5m7fl6x4oS6qGXs9RTaoscY5cubwCyXr2DDl8aEbIYIClbpfi2tWvoG/EiygOaXH6BB4qth3v8G9gvm3kZvRpL5WhGzk2cDyrm2tX6y8feQtPa4jjJ5GX0ToGd6bjigdZcht+W4zEFFJecq8mCXoOjDp58/vzF5wuHzZQHMPSbxPkBpMb6NzwaSD+b1NkJD0t4DzuQOX3t0v8ecnpVhF1ij4C1FY+jORUyxjSs64TrRVIXjSzGIixzmfKCXrFqyi1TkwPSQhlce1LnxOKqhg3FRgVSr5QHWUAWldOrsU2wuI4OqAgA8/fHrJoZwO7FEAbLOOp7LFCplWgtPLTrVmGDSObHioqxUqEFIDlSuJnLmWOt/6kRpNFcElbHe+I1SezvORCsX5svW/cO80cDp93VkZplT6WBWXGzjHuc6WV0qLoAq6BhhLUFugfndndjn7vutztEkAd5Gb23DlPTeMA9LOoT8OdETpQLtn/HFK1NMP2t7UFMgVA49JAEb3XKC7mY2uIX9Kam+n3RMCI0DwAATpt/ROfAdwzg7G2n8ZdtNPvSp4BQ63vss6FpgzD2lSEOMZfCWosmPrMZd66xFOHmRw0lQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(4326008)(508600001)(2616005)(66946007)(316002)(5660300002)(2906002)(8676002)(8936002)(6486002)(7416002)(66476007)(38100700002)(66556008)(6916009)(186003)(52116002)(31686004)(83380400001)(53546011)(31696002)(36756003)(86362001)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WmgxTDVNMDdrc05sSC8wNDg3N2ROK2o0QTF5WmRGRUJaeXF6RW1WcWF4aXNa?=
 =?utf-8?B?YW51TVhKZFF1RkFIcFFCeXU3T3Y4T01kVEJNQXBDSTRndDA2ejB3b0w0Lzlw?=
 =?utf-8?B?U1ZJbDY5K0NXSEhIQzBKM25scTdreGFwclQxZ2NKem41OXpBKy8yUjdTS1lh?=
 =?utf-8?B?MnJnK21XdGRLSlRLY0dPcmt2Z2M3czl6MnNnUHg0Um85ck53NG9qSU0yaWgw?=
 =?utf-8?B?TXB6ZXU3aEhBMGZIbkpBNGZrRTkrSTNjdXk5YzVKbHFyOEFwdDJlblFaRHlF?=
 =?utf-8?B?cFpoUlp6RUF3QWthbnVqSFNLVFY2ZEhhbS9yRUNpL0QzMkhxVmZ4anAxT3NP?=
 =?utf-8?B?djFaNzgxcmtXc25nMFg4TjdNcmtyaWRJMDlpczhLYThVeWMwY0RZbDNZR09x?=
 =?utf-8?B?WmZwYjFXK0NWb292VU1tM1VKTko4ZlZnYVRhSHdxWk51TGV2SElkVU1rMk1U?=
 =?utf-8?B?K21KTFVKNUhFcklQYUw5WTJTRUpvQmViZTNoVWpadHdjNnhJYmtkSkVqRjNx?=
 =?utf-8?B?NTFUYk1Kam51dXFiK3JkK21OVGRpbEtPZW5LSnNtdUVlK3BPY053eTkyZFha?=
 =?utf-8?B?ZHJOTVhiRXZTM1RqWEpTeWFZd1ZGaFpDVGRZZkc1UzRkMjZBNEQvV1E1TXU3?=
 =?utf-8?B?Y3IyVUl0dUNtTCtudDI4L1hkbE9YbEJGcE9NWHg2blJDenJpRU1vN05tUC9v?=
 =?utf-8?B?VGVWSlN4VUFRenhSd1hNSC9QVEJMUWpFdDlFcDFka0tSUVJ1WitIL1FicFo5?=
 =?utf-8?B?Q3F4b0VwQ1JYalAvNW9rQlc4TzVnQWVSRGlFZkg5UGlRSnhDRk1WUkhoZWFp?=
 =?utf-8?B?Wi9oYW5lNzFZNlhKRDM4bzBKRWtNMzl4M29rYmxtUzgvaGJ0a2UxbUp6NnMr?=
 =?utf-8?B?OHhtK2RsWGtkSzd2RjVKVExscHRKdEVVamlSaUE5RzhwYW5JR1V4WjdVZzlt?=
 =?utf-8?B?NVc2emVEUFd6Rkdvd2pPZVAvUFZVZ1kzY2VISnBvalgya2hyWmJ3OUh4U3Vz?=
 =?utf-8?B?NGVvL2l1Q3IxeWVDUEIvYnlxQkc0T3VMM3d4blJmdTFoRm9VZVZUb3IyalVq?=
 =?utf-8?B?WXRBVXlIbVBWcG1rK2pHakZhbXgxTkI3b2pNVk0xREV4THpBVXl4cVhnQmVp?=
 =?utf-8?B?WmVLR3FBZWw1RjZwUEFYNUtVT3VMbklGRmprNER4L1I2YktLNGtqZDE3R05G?=
 =?utf-8?B?ckNvQlRSN3lsdTVhSUZoM0xxN3JSWmlqY2NpTzAvalpoY0lwNlRtWCtTbjhX?=
 =?utf-8?B?NThCdHdlbGlxZ3BraWIyVEZGREFKVENmcnB3dVR2OHRpejBRcVlhK1J3cUcy?=
 =?utf-8?B?RjY3Q2VvQkQ0V1Y0TUgvekcrUzcvVlp4TW1IV2tkaFBadGZCNVNpcExkVDBC?=
 =?utf-8?B?RUdMeHJHbXk3S1hDMUlya0FGQW01MXJDbGxTNTdTV3ZNeVdUWWRDVE9JSW1S?=
 =?utf-8?B?MUp6aVp2eHBHclE2czN1R3dYNytjejh4RmRBMnZXRFdUT3NVKzA0RE1HYWFR?=
 =?utf-8?B?djBkRXdZVG5CUzVmd3NLcTZKUzdHeXFTRmo1R21vbmtZSEZVb2o2NS9YSDNC?=
 =?utf-8?B?S0svZG0wUE53YTczSHVFQWJEQjg1QnZDZzlmSXFENHE4OG04M0dRQ1RyMlFR?=
 =?utf-8?B?K2xTUExaS0dTcWtCazlJVHVIbllkbGpuREx0MzBaeVpjUUJ1Z3g2UjVpUzhw?=
 =?utf-8?B?cFFoL3VkR0ZHWmRtZlhNQ1VUdmE5UGtXaWZockhBSmp5WjdXcnM1RDMxcDFM?=
 =?utf-8?B?c21pK2VETThTYUhGbEw3MVV1dG9XbVd0REJqaGQ0UnhWR3IwTHowTC8zMDJq?=
 =?utf-8?Q?m8Py+TOYM+WaA0aVfM+naOe0rZGJjFFHkXVJU=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 3328d127-1c5d-413c-9566-08d95328ee6f
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jul 2021 07:09:11.4902
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pDBWF9jKWyx+49wMu2yahLNVd/3pFHrs4Kfbv9BDU/NGAVhbfb0ahLooBnAyaM+J
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR15MB2413
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: VoqwfkLkJvu9fugDeJa32zKv7tG9gAcs
X-Proofpoint-GUID: VoqwfkLkJvu9fugDeJa32zKv7tG9gAcs
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-30_04:2021-07-29,2021-07-30 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 adultscore=0 priorityscore=1501 mlxlogscore=999 impostorscore=0
 clxscore=1015 lowpriorityscore=0 spamscore=0 mlxscore=0 phishscore=0
 malwarescore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2107300043
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/29/21 11:53 PM, Kuniyuki Iwashima wrote:
> From:   Yonghong Song <yhs@fb.com>
> Date:   Thu, 29 Jul 2021 23:24:41 -0700
>> On 7/29/21 4:36 PM, Kuniyuki Iwashima wrote:
>>> This patch implements the BPF iterator for the UNIX domain socket.
>>>
>>> Currently, the batch optimization introduced for the TCP iterator in the
>>> commit 04c7820b776f ("bpf: tcp: Bpf iter batching and lock_sock") is not
>>> applied.  It will require replacing the big lock for the hash table with
>>> small locks for each hash list not to block other processes.
>>
>> Thanks for the contribution. The patch looks okay except
>> missing seq_ops->stop implementation, see below for more explanation.
>>
>>>
>>> Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
>>> ---
>>>    include/linux/btf_ids.h |  3 +-
>>>    net/unix/af_unix.c      | 78 +++++++++++++++++++++++++++++++++++++++++
>>>    2 files changed, 80 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/include/linux/btf_ids.h b/include/linux/btf_ids.h
>>> index 57890b357f85..bed4b9964581 100644
>>> --- a/include/linux/btf_ids.h
>>> +++ b/include/linux/btf_ids.h
>>> @@ -172,7 +172,8 @@ extern struct btf_id_set name;
>>>    	BTF_SOCK_TYPE(BTF_SOCK_TYPE_TCP_TW, tcp_timewait_sock)		\
>>>    	BTF_SOCK_TYPE(BTF_SOCK_TYPE_TCP6, tcp6_sock)			\
>>>    	BTF_SOCK_TYPE(BTF_SOCK_TYPE_UDP, udp_sock)			\
>>> -	BTF_SOCK_TYPE(BTF_SOCK_TYPE_UDP6, udp6_sock)
>>> +	BTF_SOCK_TYPE(BTF_SOCK_TYPE_UDP6, udp6_sock)			\
>>> +	BTF_SOCK_TYPE(BTF_SOCK_TYPE_UNIX, unix_sock)
>>>    
>>>    enum {
>>>    #define BTF_SOCK_TYPE(name, str) name,
>>> diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
>>> index 89927678c0dc..d45ad87e3a49 100644
>>> --- a/net/unix/af_unix.c
>>> +++ b/net/unix/af_unix.c
>>> @@ -113,6 +113,7 @@
>>>    #include <linux/security.h>
>>>    #include <linux/freezer.h>
>>>    #include <linux/file.h>
>>> +#include <linux/btf_ids.h>
>>>    
>>>    #include "scm.h"
>>>    
>>> @@ -2935,6 +2936,49 @@ static const struct seq_operations unix_seq_ops = {
>>>    	.stop   = unix_seq_stop,
>>>    	.show   = unix_seq_show,
>>>    };
>>> +
>>> +#ifdef CONFIG_BPF_SYSCALL
>>> +struct bpf_iter__unix {
>>> +	__bpf_md_ptr(struct bpf_iter_meta *, meta);
>>> +	__bpf_md_ptr(struct unix_sock *, unix_sk);
>>> +	uid_t uid __aligned(8);
>>> +};
>>> +
>>> +static int unix_prog_seq_show(struct bpf_prog *prog, struct bpf_iter_meta *meta,
>>> +			      struct unix_sock *unix_sk, uid_t uid)
>>> +{
>>> +	struct bpf_iter__unix ctx;
>>> +
>>> +	meta->seq_num--;  /* skip SEQ_START_TOKEN */
>>> +	ctx.meta = meta;
>>> +	ctx.unix_sk = unix_sk;
>>> +	ctx.uid = uid;
>>> +	return bpf_iter_run_prog(prog, &ctx);
>>> +}
>>> +
>>> +static int bpf_iter_unix_seq_show(struct seq_file *seq, void *v)
>>> +{
>>> +	struct bpf_iter_meta meta;
>>> +	struct bpf_prog *prog;
>>> +	struct sock *sk = v;
>>> +	uid_t uid;
>>> +
>>> +	if (v == SEQ_START_TOKEN)
>>> +		return 0;
>>> +
>>> +	uid = from_kuid_munged(seq_user_ns(seq), sock_i_uid(sk));
>>> +	meta.seq = seq;
>>> +	prog = bpf_iter_get_info(&meta, false);
>>> +	return unix_prog_seq_show(prog, &meta, v, uid);
>>> +}
>>> +
>>> +static const struct seq_operations bpf_iter_unix_seq_ops = {
>>> +	.start	= unix_seq_start,
>>> +	.next	= unix_seq_next,
>>> +	.stop	= unix_seq_stop,
>>
>> Although it is not required for /proc/net/unix, we should still
>> implement bpf_iter version of seq_ops->stop here. The main purpose
>> of bpf_iter specific seq_ops->stop is to call bpf program one
>> more time after ALL elements have been traversed. Such
>> functionality is implemented in all other bpf_iter variants.
> 
> Thanks for your review!
> I will implement the extra call in the next spin.
> 
> Just out of curiosity, is there a specific use case for the last call?

We don't have use cases for dumps similar to /proc/net/... etc.
The original thinking is to permit in-kernel aggregation and the
seq_ops->stop() bpf program will have an indication as the last
bpf program invocation for the iterator at which point bpf program
may wrap up aggregation and send/signal the result to user space.
I am not sure whether people already used this feature or not, or
people may have different way to do that (e.g., from user space
directly checking map value if read() length is 0). But
bpf seq_ops->stop() provides an in-kernel way for bpf program
to respond to the end of iterating.

> 

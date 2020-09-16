Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C884C26BC3E
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 08:09:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726387AbgIPGJy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Sep 2020 02:09:54 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:22830 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726129AbgIPGJu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Sep 2020 02:09:50 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 08G67Jng028155;
        Tue, 15 Sep 2020 23:09:35 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=JfrqgjQk/98rwWFY8kl3JhtmIeuHJVjQcLr69q0+WDk=;
 b=j4Fanj1vNq8kEWz6yZUMFtRv1tm/eKNVPvzYiuR2QM9ieHYR43HKHC/BYHWxVezPTryS
 qiFFxDDOYzzg3ngERN1Ljvukb1cUnDKRqI8ID3Hk2GbsgQllOoZYp5wmZD+gDORQQY7C
 5p84lNP43tR593zsvTohNhhZ6sV/WTJmBmo= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0001303.ppops.net with ESMTP id 33k5n79vv3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 15 Sep 2020 23:09:35 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.198) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 15 Sep 2020 23:09:33 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K4f8HXyV3TLO8bil2AR5wen8hE/g6h5S8IH4wWvJXmoUog3nOS+cjkYyYQC/BRbBSEoHS+sALe/6zZvstlzuzA2x6sZi+UEudd7pq97C3ECyLhJWsTDZR1joCleN9Wafgjsfz6YdPtBE+v+5tR8DEXJD3TS2d0QaPza04D9UHxZt7vZLhAiilKeo7n71ozilDtkWmv2l8FQOkhTD4iXqNhwNjnMxR8YH024wYUozzT/B2UJX5YjtVPEPlfvEGFlsfRrYFuz8bPLfTEkCLl+sWfLBoys/b3qiWRGLzbStQz+oyA4SbkDRXnVh6iDx+e0XfURojXhR6yErhcsQD3NJEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JfrqgjQk/98rwWFY8kl3JhtmIeuHJVjQcLr69q0+WDk=;
 b=DU6eXgcbz593PkJkr7WHjEcR7qRL7+2qvOZ2TZwptzN70uQBVnKVgnkgSi6UEaOEsveDpU4s1F+P1CgLXm2L/1Vqjt7pQ4tIdZVlx9i81ln9ltNdtSTiHfvFVhkNYv68tyrwI6IRBiFlPu84qz4WAb9uzFlA14i9kIpZKLPkYr/kUhjPRKW4iSGiSEP3WPY409jJZuCKrHrLt1KD9J9kcNycwF6WJBFv5N+P/DBF6LLqnRMetcNWU1bu/EXulbCWv6gAFo4nNMIq8FdyOQyj31bwopnXG7DZWY7dMsPQfR2QBquJDMnisZHOjg713vM+iGClMSf7xgTiektD7mdRtA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JfrqgjQk/98rwWFY8kl3JhtmIeuHJVjQcLr69q0+WDk=;
 b=icMUIJpsrBncnSTT5+1icYm/sTIzok338GuMLQmXLrJ5DQLQq7KsFetqKZQhz+qmJ95WVnw0+ZVYMyJlLC6l/crQ/t4QGaVh1FKJ+WHR4KH1E6+auIyFpetHSde51XoKlA0vFz5LFeZB5a+p0dRaBVmS/UJoOvr9S9CCFSqvOto=
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB2648.namprd15.prod.outlook.com (2603:10b6:a03:150::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.13; Wed, 16 Sep
 2020 06:09:32 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::8887:dd68:f497:ea42]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::8887:dd68:f497:ea42%3]) with mapi id 15.20.3391.011; Wed, 16 Sep 2020
 06:09:32 +0000
Subject: Re: [PATCH bpf-next v2] bpf: using rcu_read_lock for
 bpf_sk_storage_map iterator
To:     Martin KaFai Lau <kafai@fb.com>
CC:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        Song Liu <songliubraving@fb.com>
References: <20200915223507.3792641-1-yhs@fb.com>
 <20200916053720.zzdaasvxoqptyb2a@kafai-mbp>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <24a16da9-a783-dff5-fcc4-75532bb05f1e@fb.com>
Date:   Tue, 15 Sep 2020 23:09:29 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.0
In-Reply-To: <20200916053720.zzdaasvxoqptyb2a@kafai-mbp>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MWHPR14CA0046.namprd14.prod.outlook.com
 (2603:10b6:300:12b::32) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21c8::1005] (2620:10d:c090:400::5:4ec9) by MWHPR14CA0046.namprd14.prod.outlook.com (2603:10b6:300:12b::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.11 via Frontend Transport; Wed, 16 Sep 2020 06:09:31 +0000
X-Originating-IP: [2620:10d:c090:400::5:4ec9]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: de93d294-f2c6-43fd-5d11-08d85a071406
X-MS-TrafficTypeDiagnostic: BYAPR15MB2648:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB26481B0A2958F5AC6E83B8A6D3210@BYAPR15MB2648.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HNdm5B99+1REYeDsctRGUKlKe4AQ9XSqPrtZsQNQiaOiZ1dc2KbnIvJ4zRO5aLm+o38vg65bEvvB0gVyXvjSHAgsEu7tOZToyGNct4QXjCGPGbjUQ+v7iVfyJtPoOyV+HHOu2Rvp9Mx6qJLEmbBQFxxTcRL9b9LywTE+ZT5pjP/UtxYivXDKyLfefxIw1ffhKHVi6qz/8SplL+Cj4NGbppXdmAadoxpIUoWbhGukFI6W0efeP3zqb8vUGA5tDJhHfH0WbjHLw2bow+b93Z6ctZbogg6C5ysvWgp+aWUEy3mXKrrYdma8Ayef4hF3lAvkHF7ndbH6ediHDcLqxDRby0QxGNVcjnyDkhEB97bx4C5wqDLlF97FdgfnNtFv3KmN
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(136003)(39860400002)(376002)(366004)(346002)(478600001)(36756003)(66556008)(66946007)(6486002)(2616005)(66476007)(316002)(8936002)(37006003)(86362001)(6636002)(6862004)(4326008)(5660300002)(53546011)(8676002)(31696002)(2906002)(52116002)(83380400001)(54906003)(31686004)(16526019)(186003)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: h3vHfsUqxQJntx8M+OyWIYe9q6XzOW6zUeAXxssuCueJeMf3cD7uP6OD1vwLdenMklL6Ih/yiSoAOS86vlxwczUC8Q9zxm+i7f8blMzGeAAfhOQJUbxRZN66W+ARM6kef51Z3coQgXO5rixxqSMA4HRxcl9c7pHFeNGQKCkhinesLZQWKWB5AM4B1WrUPllfleCitQD8vXypqm4QBv7H/AafH6J5myEIO02OVdaFQOpx9Ncd2pnuQ/yelH8m6xG6ikRXLa6JFFRYxGW0ir69Pscxqorzy/UliYCcGKy64Go8TLC4aWN/PLR9gSl5ClBXS0QUYVbQsLmOIdnTc33/XwE2+ywua2eP1snyimQLPhQNFBocVo00QZQsGeNn5D0dVqbZTi5klBwl16Oq3Y/ciZCFlumrVaKRW/SVG9MC+xJnV1tUYIw1guZvyDZfUSrvfSh9jl87UinImWt8F1THCPhXyMNqULK5N7iXz2CFro0xqnqLWO4BoTfyl+mBEOaRXyAJvdPZyAj5efIQAe+JsgKJHPF6+7U0fym4FgCtGeP54TRxAmPmfS4wmdcetpm25eZM9RDoAYE87AMuBS5huM816MlxkxDo6mRP9NF/h+h0krZUc1xoQ0dSZk+NqiJgaaFzT+AIjPA1RHaPGYrhmBfW7aCIGWBC7sxI2XM2Qlw=
X-MS-Exchange-CrossTenant-Network-Message-Id: de93d294-f2c6-43fd-5d11-08d85a071406
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2020 06:09:32.3565
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: f+H+XvTaf+z3g12W9ZjfYSwLwkerMi2jABdJ75pZLHthcvl65Bc0L6FE/PXevsHA
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2648
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-16_02:2020-09-15,2020-09-16 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 mlxlogscore=999 adultscore=0 impostorscore=0 suspectscore=0 bulkscore=0
 malwarescore=0 priorityscore=1501 spamscore=0 mlxscore=0 phishscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009160046
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/15/20 10:37 PM, Martin KaFai Lau wrote:
> On Tue, Sep 15, 2020 at 03:35:07PM -0700, Yonghong Song wrote:
>> If a bucket contains a lot of sockets, during bpf_iter traversing
>> a bucket, concurrent userspace bpf_map_update_elem() and
>> bpf program bpf_sk_storage_{get,delete}() may experience
>> some undesirable delays as they will compete with bpf_iter
>> for bucket lock.
>>
>> Note that the number of buckets for bpf_sk_storage_map
>> is roughly the same as the number of cpus. So if there
>> are lots of sockets in the system, each bucket could
>> contain lots of sockets.
>>
>> Different actual use cases may experience different delays.
>> Here, using selftest bpf_iter subtest bpf_sk_storage_map,
>> I hacked the kernel with ktime_get_mono_fast_ns()
>> to collect the time when a bucket was locked
>> during bpf_iter prog traversing that bucket. This way,
>> the maximum incurred delay was measured w.r.t. the
>> number of elements in a bucket.
>>      # elems in each bucket          delay(ns)
>>        64                            17000
>>        256                           72512
>>        2048                          875246
>>
>> The potential delays will be further increased if
>> we have even more elemnts in a bucket. Using rcu_read_lock()
>> is a reasonable compromise here. It may lose some precision, e.g.,
>> access stale sockets, but it will not hurt performance of
>> bpf program or user space application which also tries
>> to get/delete or update map elements.
>>
>> Cc: Martin KaFai Lau <kafai@fb.com>
>> Acked-by: Song Liu <songliubraving@fb.com>
>> Signed-off-by: Yonghong Song <yhs@fb.com>
>> ---
>>   net/core/bpf_sk_storage.c | 21 ++++++++-------------
>>   1 file changed, 8 insertions(+), 13 deletions(-)
>>
>> Changelog:
>>   v1 -> v2:
>>     - added some performance number. (Song)
>>     - tried to silence some sparse complains. but still has some left like
>>         context imbalance in "..." - different lock contexts for basic block
>>       which the code is too hard for sparse to analyze. (Jakub)
>>
>> diff --git a/net/core/bpf_sk_storage.c b/net/core/bpf_sk_storage.c
>> index 4a86ea34f29e..4fc6b03d3639 100644
>> --- a/net/core/bpf_sk_storage.c
>> +++ b/net/core/bpf_sk_storage.c
>> @@ -678,6 +678,7 @@ struct bpf_iter_seq_sk_storage_map_info {
>>   static struct bpf_local_storage_elem *
>>   bpf_sk_storage_map_seq_find_next(struct bpf_iter_seq_sk_storage_map_info *info,
>>   				 struct bpf_local_storage_elem *prev_selem)
>> +	__acquires(RCU) __releases(RCU)
>>   {
>>   	struct bpf_local_storage *sk_storage;
>>   	struct bpf_local_storage_elem *selem;
>> @@ -701,7 +702,7 @@ bpf_sk_storage_map_seq_find_next(struct bpf_iter_seq_sk_storage_map_info *info,
>>   		if (!selem) {
>>   			/* not found, unlock and go to the next bucket */
>>   			b = &smap->buckets[bucket_id++];
>> -			raw_spin_unlock_bh(&b->lock);
>> +			rcu_read_unlock();
>>   			skip_elems = 0;
>>   			break;
>>   		}
>> @@ -715,7 +716,7 @@ bpf_sk_storage_map_seq_find_next(struct bpf_iter_seq_sk_storage_map_info *info,
>>   
>>   	for (i = bucket_id; i < (1U << smap->bucket_log); i++) {
>>   		b = &smap->buckets[i];
>> -		raw_spin_lock_bh(&b->lock);
>> +		rcu_read_lock();
>>   		count = 0;
>>   		hlist_for_each_entry(selem, &b->list, map_node) {
> hlist_for_each_entry_rcu()

Good catch!

> 
>>   			sk_storage = rcu_dereference_raw(selem->local_storage);
> Does lockdep complain without "_raw"?

It didn't. But I think using rcu_dereference() is better as it provides 
extra checking.

Will fix and send v3.

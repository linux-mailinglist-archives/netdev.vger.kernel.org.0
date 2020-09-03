Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D144525B8DA
	for <lists+netdev@lfdr.de>; Thu,  3 Sep 2020 04:45:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728043AbgICCpJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Sep 2020 22:45:09 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:13388 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726654AbgICCpC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Sep 2020 22:45:02 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0832eBwO024829;
        Wed, 2 Sep 2020 19:44:48 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=SemW161e497sg3Nk+v4fgqN4Vj9UOk+PNe+r8snVM4k=;
 b=EAOTCCShBfk132lnxKr7s33ODv9AWgNvQxqowF9yVkkrvxGR4pEAAMwgnr+F3aTHj4yj
 Gv7hX+kDJDekprme9zebC/atne2ww0vgVgs9djrbAB24xbgN9UTBYLLMi6Ofqvg+TEt3
 BLSzsUMobTRUarZI8c9wEN9svcWV0cJHbic= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 338gqnkhbw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 02 Sep 2020 19:44:48 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 2 Sep 2020 19:44:47 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=joevuKzFKE5mG1OFu/p9+vZ5HOwNJZfDPVmjk7Ty5xfdzIu08svOfQFnJdinMRpksq0XOomnMzdizaG6fDbxQtHWygF3Xvnj/UpOm7iyClbh8E+eN7h/YFSpvmqjy7TBHl//xsFUfcr6xD7Yw/tuFXmMlyw/ZUM273jOL0ch5ve8akTcFjS/3DymSJ9Qy6+M7i/Vh6u4UAJPO2+/cGHMWT18jUVlArbY3vxtuRdPgJ0gYtbyZU1JTL/ZOr3OAR/56aZuA+vzjrRapv08KIJqiNfn2y+z9IdeSqUjR7ytvHcGGPDIy/bZte6+ItM7HAM3p0ME4VPsgMTCn/4ZLMcKFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SemW161e497sg3Nk+v4fgqN4Vj9UOk+PNe+r8snVM4k=;
 b=f6C/ivHZE1he3Y65u776mtsSSXIy9gsLsnXI9QFA0s5jLNxOjW1i9JLcejLE5Wf6ZqKnqSljRpe7hTgxSOlcVd/IvYRRBF889v76/+h6D0NIWystqEZyiztu3Yxs+t/Zc/6ZQcG8DEEa/v25+gbsZh6ZrGFgstDtgunZC5B436Dh0bg/PTR+Mk11y0v83B/+748ZZPXDG7vFfyQ0thmOdmEeX5nXTDCs2saY9QNM1HqJxI3X8kolgs7xLHBWVym2MWk3LQVmtk0JdeWMQdhP2GNDJeIeAnNiEgMEKrf8fI3XqpkX5rMBbjavqufuerTClm/LH9UPkjdlV6jWe0sxwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SemW161e497sg3Nk+v4fgqN4Vj9UOk+PNe+r8snVM4k=;
 b=ewRyfAWd4oOkoQIIr14Jyns+fUDMwBSRn5J5ebY4nFOCR1vF4XRavO/wqW//S/T1c+01NRgKDu2hd2DWf7Ye1rRvngReRI9UfTnNlK488bth6STjY0jOSh0yqdl8pwV4IDFBJPwgLUd0s4Nl5zi9q3mh+ScfaS2oEIyk6Ht5uKU=
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB3095.namprd15.prod.outlook.com (2603:10b6:a03:fe::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3326.19; Thu, 3 Sep
 2020 02:44:42 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::56b:2925:8762:2d80]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::56b:2925:8762:2d80%7]) with mapi id 15.20.3348.015; Thu, 3 Sep 2020
 02:44:36 +0000
Subject: Re: [PATCH bpf 1/2] bpf: do not use bucket_lock for hashmap iterator
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     bpf <bpf@vger.kernel.org>, Lorenz Bauer <lmb@cloudflare.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
References: <20200902235340.2001300-1-yhs@fb.com>
 <20200902235340.2001375-1-yhs@fb.com>
 <CAEf4BzaBxaPyWXOWOVRWCXcLW40FOFWkG7gUPSktGwS07duQVA@mail.gmail.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <f93015c5-5fed-4775-93c3-6b85a8e7c0da@fb.com>
Date:   Wed, 2 Sep 2020 19:44:34 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.0
In-Reply-To: <CAEf4BzaBxaPyWXOWOVRWCXcLW40FOFWkG7gUPSktGwS07duQVA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR01CA0025.prod.exchangelabs.com (2603:10b6:a02:80::38)
 To BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from 255.255.255.255 (255.255.255.255) by BYAPR01CA0025.prod.exchangelabs.com (2603:10b6:a02:80::38) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3348.15 via Frontend Transport; Thu, 3 Sep 2020 02:44:35 +0000
X-Originating-IP: [2620:10d:c090:400::5:d32f]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a24c8837-500a-4de3-aba8-08d84fb34b85
X-MS-TrafficTypeDiagnostic: BYAPR15MB3095:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB3095BF179C3198D66346CA19D32C0@BYAPR15MB3095.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +nV8tazB742D/QtM9kTLmCzFbJCkopPfTa8opeIFA4ibwzQT8QAysTyDG1Ja9V8q4LCr3AKyGG88E1Wh3OmYkzLMj5bYUK8ydKjtBi/ua2lH6eV5vi2nIBN/eWU1SIKZBlTyw499EovCr0nAZXF5NJnXJ8L6CJmHim9zWP5iQmEqC/+whWcZDRpw4hElb4s9mHySHRUoKlTC04FN4gCs7WUNi84EGv/lr1UzYR41NNjgfM+dZIQV/9O1K2X4GLzwL9Ojm9PfOMt6qT05CvJUCIPa3rszZhbiLFrPSxGG6qxXf15KFQaJL1nJ5HmddNjwCoL6M8+BecuwbMOIPr2J9nm/9kHNJ2zPGJuedIw+kVBDFbnRQzuBPycd90yRUtJg
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(396003)(136003)(366004)(39860400002)(6916009)(31686004)(316002)(5660300002)(54906003)(2616005)(8936002)(66556008)(31696002)(2906002)(83380400001)(186003)(53546011)(66476007)(66946007)(6486002)(478600001)(8676002)(86362001)(16576012)(52116002)(4326008)(36756003)(956004)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: x4BEJLOI1N4Mk3pFUPDAunjtro+KZJGqtl/0RRgeWxAqhlTKlrES5h0bNxN4t5nNp8e4nsv+C2Wh2x+Ohyktd+dOhCc6O9MHhE1lkWQOrs7igAmoQYwvXr1sQ5tSZPdBPKbl/ekj+nkou2qFhrLQRerTC5mbOXKDyoX8zZwGpXC1T6AqkBq2jGrO7M0OixVvoqp54EK6ZJg8z0f1swb1ZYGNWGGleV+2ib5YTF9InY3cvKzikiR7D4aGHxgJ+Ulp6cGyWoDmO4KNxuDN5OsuO5T5QtYebhj6iSx71W/5z/AEGs7HXFXgsMMsx1g3Or3Zb9Wn4Ks9LcYmZgTIW3CKYhz7lQyCXonEletkN5133u+NSc9NspxvqfjecrLtuRKQj/l72rLRYllvH7Ehn3uRMb2IRzR9itj/Y+NGoTe9P9bfnXvh3YoBhcuw3PmL71N/96mDDr7USCB7rckK18CMiHvzPWSDkkq6XvvTI31IxtXwJ3duACYcT2flxqxhbPoShBkJlttToeR3+UgtwekgSPhGHOK9Dw/9/mvvQNlqKsFKRhyS99t+RHVAwl6AQFpUZVfSWxAMpLf3Ayo7sne20mczwNsF4nqbNHqjYr9KnNk/Kp3RUGAeX72J9ZRCQRqELPPtwxYvOimQl+ZiagseAasLi1UryHso025M72Kkjbs=
X-MS-Exchange-CrossTenant-Network-Message-Id: a24c8837-500a-4de3-aba8-08d84fb34b85
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Sep 2020 02:44:35.8856
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Y/4jMkQ52sLDtk3iwa/tkqSbhVPZijdOOQA4JNOxkgcXpl1i+gQUZGh4Z8XCdFQ4
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3095
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-02_17:2020-09-02,2020-09-02 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0
 impostorscore=0 phishscore=0 clxscore=1015 suspectscore=0 malwarescore=0
 priorityscore=1501 bulkscore=0 adultscore=0 lowpriorityscore=0 mlxscore=0
 mlxlogscore=988 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009030024
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/2/20 6:25 PM, Andrii Nakryiko wrote:
> On Wed, Sep 2, 2020 at 4:56 PM Yonghong Song <yhs@fb.com> wrote:
>>
>> Currently, for hashmap, the bpf iterator will grab a bucket lock, a
>> spinlock, before traversing the elements in the bucket. This can ensure
>> all bpf visted elements are valid. But this mechanism may cause
>> deadlock if update/deletion happens to the same bucket of the
>> visited map in the program. For example, if we added bpf_map_update_elem()
>> call to the same visited element in selftests bpf_iter_bpf_hash_map.c,
>> we will have the following deadlock:
>>
> 
> [...]
> 
>>
>> Compared to old bucket_lock mechanism, if concurrent updata/delete happens,
>> we may visit stale elements, miss some elements, or repeat some elements.
>> I think this is a reasonable compromise. For users wanting to avoid
> 
> I agree, the only reliable way to iterate map without duplicates and
> missed elements is to not update that map during iteration (unless we
> start supporting point-in-time snapshots, which is a very different
> matter).
> 
> 
>> stale, missing/repeated accesses, bpf_map batch access syscall interface
>> can be used.
>>
>> Signed-off-by: Yonghong Song <yhs@fb.com>
>> ---
>>   kernel/bpf/hashtab.c | 15 ++++-----------
>>   1 file changed, 4 insertions(+), 11 deletions(-)
>>
>> diff --git a/kernel/bpf/hashtab.c b/kernel/bpf/hashtab.c
>> index 78dfff6a501b..7df28a45c66b 100644
>> --- a/kernel/bpf/hashtab.c
>> +++ b/kernel/bpf/hashtab.c
>> @@ -1622,7 +1622,6 @@ struct bpf_iter_seq_hash_map_info {
>>          struct bpf_map *map;
>>          struct bpf_htab *htab;
>>          void *percpu_value_buf; // non-zero means percpu hash
>> -       unsigned long flags;
>>          u32 bucket_id;
>>          u32 skip_elems;
>>   };
>> @@ -1632,7 +1631,6 @@ bpf_hash_map_seq_find_next(struct bpf_iter_seq_hash_map_info *info,
>>                             struct htab_elem *prev_elem)
>>   {
>>          const struct bpf_htab *htab = info->htab;
>> -       unsigned long flags = info->flags;
>>          u32 skip_elems = info->skip_elems;
>>          u32 bucket_id = info->bucket_id;
>>          struct hlist_nulls_head *head;
>> @@ -1656,19 +1654,18 @@ bpf_hash_map_seq_find_next(struct bpf_iter_seq_hash_map_info *info,
>>
>>                  /* not found, unlock and go to the next bucket */
>>                  b = &htab->buckets[bucket_id++];
>> -               htab_unlock_bucket(htab, b, flags);
>> +               rcu_read_unlock();
> 
> Just double checking as I don't yet completely understand all the
> sleepable BPF implications. If the map is used from a sleepable BPF
> program, we are still ok doing just rcu_read_lock/rcu_read_unlock when
> accessing BPF map elements, right? No need for extra
> rcu_read_lock_trace/rcu_read_unlock_trace?
I think it is fine now since currently bpf_iter program cannot be 
sleepable and the current sleepable program framework already allows the 
following scenario.
   - map1 is a preallocated hashmap shared by two programs,
     prog1_nosleep and prog2_sleepable

...				  ...
rcu_read_lock()			  rcu_read_lock_trace()
run prog1_nosleep                 run prog2_sleepable
   lookup/update/delete map1 elem    lookup/update/delete map1 elem
rcu_read_unlock()		  rcu_read_unlock_trace()
...				  ...

The prog1_nosleep could be a bpf_iter program or a networking problem.

Alexei, could you confirm the above scenario is properly supported now?

> 
>>                  skip_elems = 0;
>>          }
>>
> 
> [...]
> 

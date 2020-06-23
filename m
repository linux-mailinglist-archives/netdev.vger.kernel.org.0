Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9245C20556A
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 17:03:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732910AbgFWPDa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 11:03:30 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:9010 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732862AbgFWPD3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jun 2020 11:03:29 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05NEsUei026226;
        Tue, 23 Jun 2020 08:03:15 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=A/VWfeLx8P0NxTEzcQUFMXuMubxuN/xLpwphAm9WASM=;
 b=IHBbaAfkiTppFMfMUoSDcgjsAVQJnENaYUFsETcDZYUJkEStAr/OhzVMl8Wano1N5O3r
 /DlTh1zJPOy4IuWJdcsZYuDb/lkc8llc+O+i3Wn9bXCrAzLfDEtM0z2QhPRJxPZ5jNVp
 VMk/c6AMVIX2kQxSSa3Js2RpblZx6mMm9JY= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 31uk208at8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 23 Jun 2020 08:03:13 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.172) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 23 Jun 2020 08:03:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m++BNDnwVm2Uc+gcv/QnDnRm4BVXKh+VxNFpcydf2yeYQCcFnqRFhakRMdynrTkc6+aRsB18Pom06KSMmMuvig3ImefSV6Q7+DYNadLZQT8mDQ1+Kzj3pjmyNTsd1hYBrKkR/Ama3SBCLPm/mK3YxAfwOe4CRVCIF63zNrE2q/+D0KbKqeFmKs+nLf6P3iKN8l/3+XWsExKQwZ1y0uXSeF6NWEvc0ztPkdt2cU17rBmVXZbPui3K/I61yn5zXCc40wDaeZo1OxoTcSztyq6yie+gawtN1EOCeGQY1R0btXmPziTceF/heGvkJpPoPknx2u9IhHgncPRT3IlnhjW/yA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A/VWfeLx8P0NxTEzcQUFMXuMubxuN/xLpwphAm9WASM=;
 b=Judb8gDvmRiQ4Zc8dv2QSKMH6dcdP8qPBjTk9iw3mcDx8q5DxMfVwjrEimh5f1OfhTtYynFBpz2CIfdDgUp1sLprC8OW2pbRkHm2vd2U3vdZoNGGi6SzYqLKQU1zSaaCabXhw+Fqh/Q5rXof4banQSIost+T0x7G2xjLe4VAQoDk0Vc19pyKyg27S/VcrqjlFijl7QaZNGknAzToRTKCIytzx/Gu3GQVzaN4bbyRxlaKPdpbW+awl5ucJ2e3qX3pPafZDkYvv1LB7u3F63nYrtCz4pad+S90Gph913npBWEppw65YGIKBmPzbNWQP+rTVIzT7UMrrA5OkVcF5IdbUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A/VWfeLx8P0NxTEzcQUFMXuMubxuN/xLpwphAm9WASM=;
 b=SyqsH5KTvK0FgIZAogOeQyun0Rr21WPM+2bnDxXv67R0vyKe3DXi4lVOIqDFdimwClbeUumY8X7ViYBMFRqz5QO+rbvbz4GPzPVjsuzlySrq3NnNayaSLw05Mo5LKSD2lh2lsJweikKtba216a7ksqWdZb7YzsALmdbAv/EacCg=
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB2694.namprd15.prod.outlook.com (2603:10b6:a03:158::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.23; Tue, 23 Jun
 2020 15:03:11 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::4922:9927:5d6c:5301]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::4922:9927:5d6c:5301%7]) with mapi id 15.20.3109.027; Tue, 23 Jun 2020
 15:03:11 +0000
Subject: Re: [PATCH bpf-next v3 13/15] tools/bpf: selftests: implement sample
 tcp/tcp6 bpf_iter programs
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Martin KaFai Lau <kafai@fb.com>
References: <20200623003626.3072825-1-yhs@fb.com>
 <20200623003641.3074883-1-yhs@fb.com>
 <CAEf4BzatNEOJSuM2t-1eLQuT4E8gcRLB38B=rqZU3G=vVGkizQ@mail.gmail.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <6ff28837-63b1-754d-17aa-fd5877409b64@fb.com>
Date:   Tue, 23 Jun 2020 08:03:09 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.9.0
In-Reply-To: <CAEf4BzatNEOJSuM2t-1eLQuT4E8gcRLB38B=rqZU3G=vVGkizQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR02CA0064.namprd02.prod.outlook.com
 (2603:10b6:a03:54::41) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21d6::1377] (2620:10d:c090:400::5:7789) by BYAPR02CA0064.namprd02.prod.outlook.com (2603:10b6:a03:54::41) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.22 via Frontend Transport; Tue, 23 Jun 2020 15:03:10 +0000
X-Originating-IP: [2620:10d:c090:400::5:7789]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4f619d05-1570-42df-e722-08d817868bc4
X-MS-TrafficTypeDiagnostic: BYAPR15MB2694:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB26946228F537E4BAD5C7974DD3940@BYAPR15MB2694.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-Forefront-PRVS: 04433051BF
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4ZbbH34an9X9Q6wncp8gjXyQekG+6x6d6h3IjLXwh3qE+vzks3GmRLlSsw9GtR5GXtXiqf12nyb5wzWi8KDxd2x7UasjcJySqp7PCVtna6PF4Bd6w4CGMozqvQ395dOOYis6F6HteC4e1coIbFvzMP1LyozQ9fGRy2JvStDmHaIa0wR54v4p8x07ZWWiPDybvNR/wtve0efOVLu8u4a02P+CpwuxCwVB7bkbVrkdvxjRxiYtbDRP9j6kE7k19ERL6D5fKhr2uWPxCRIiGGDMfMsuAK0gop1j+GAHaZ5Uzgb6eoibCkJukpRoFfghlhwlvBkSUekkciKj62OeB7rH/DtoF1AQ0eov4Y+HJriACflm30HltgYV5wDVuoW72EI8
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(346002)(376002)(39860400002)(396003)(136003)(366004)(8676002)(186003)(5660300002)(86362001)(66556008)(16526019)(66946007)(8936002)(66476007)(2906002)(36756003)(4326008)(31696002)(52116002)(31686004)(53546011)(54906003)(316002)(83380400001)(6916009)(6486002)(2616005)(478600001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: mOcXTyRoHp6N26Go/c88WkSGS6m1te3nMogdRonA7yyNdxN7QigeSwDNF3T3d2S0ICqkNx5+un/HHHcb7McEBFCSXW3UIihzOVhYmiHkqA3OVqUN7HsoMykK+xj7LiIwcMdchCQf4tO3fthxZNnDBweCUe8qkjq9ArDmPJzKMElZhjU73k2Cnxx313VEEkYLy8dU2XoeILOfWcAIdqwcAVQY/eWmkZUnCOWaNh8TWrhV0d5z4vzlY1nsLfiAwMBss0OOk5hegvfiJuWvpICFgxGcLgRVXB21bhSJ23bQWLX2Yq84NLl45FeTmhRcZ7AE6aMNL+G3AQ1Q+6GUgp0CZkonY2GyYMmZWh2Wz4QhVdagesA9tlWBBS05/LgLLC3kq4azreaYrIPLYT7JmPBtsuZ0r42HXYH9QoM55V2pR4lz4TBdX+zZZIUFy1oiLmahAAR2yVt+lbMFPw9ORlORZqpinryhATCmU9BekJhx1s+BVcG0reMc90Qu6lrdMuW30CCUt2Okph+jkNODituiug==
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f619d05-1570-42df-e722-08d817868bc4
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jun 2020 15:03:11.2498
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YSFvNzCg2VHEbeKwgbM/gDp9ZmSnybREe9zHrPGbftmHYJCMiK+X+TtY7Z9PESJH
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2694
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-23_07:2020-06-23,2020-06-23 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0
 malwarescore=0 mlxscore=0 adultscore=0 mlxlogscore=999 spamscore=0
 impostorscore=0 clxscore=1015 priorityscore=1501 suspectscore=0
 bulkscore=0 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006120000 definitions=main-2006230117
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/22/20 11:56 PM, Andrii Nakryiko wrote:
> On Mon, Jun 22, 2020 at 5:38 PM Yonghong Song <yhs@fb.com> wrote:
>>
>> In my VM, I got identical result compared to /proc/net/{tcp,tcp6}.
>> For tcp6:
>>    $ cat /proc/net/tcp6
>>      sl  local_address                         remote_address                        st tx_queue rx_queue tr tm->when retrnsmt   uid  timeout inode
>>       0: 00000000000000000000000000000000:0016 00000000000000000000000000000000:0000 0A 00000000:00000000 00:00000001 00000000     0        0 17955 1 000000003eb3102e 100 0 0 10 0
>>
>>    $ cat /sys/fs/bpf/p1
>>      sl  local_address                         remote_address                        st tx_queue rx_queue tr tm->when retrnsmt   uid  timeout inode
>>       0: 00000000000000000000000000000000:0016 00000000000000000000000000000000:0000 0A 00000000:00000000 00:00000000 00000000     0        0 17955 1 000000003eb3102e 100 0 0 10 0
>>
>> For tcp:
>>    $ cat /proc/net/tcp
>>    sl  local_address rem_address   st tx_queue rx_queue tr tm->when retrnsmt   uid  timeout inode
>>     0: 00000000:0016 00000000:0000 0A 00000000:00000000 00:00000000 00000000     0        0 2666 1 000000007152e43f 100 0 0 10 0
>>    $ cat /sys/fs/bpf/p2
>>    sl  local_address                         remote_address                        st tx_queue rx_queue tr tm->when retrnsmt   uid  timeout inode
>>     1: 00000000:0016 00000000:0000 0A 00000000:00000000 00:00000000 00000000     0        0 2666 1 000000007152e43f 100 0 0 10 0
>>
>> Signed-off-by: Yonghong Song <yhs@fb.com>
>> ---
> 
> Looks reasonable, to the extent possible ;)
> 
> Acked-by: Andrii Nakryiko <andriin@fb.com>
> 
>>   tools/testing/selftests/bpf/progs/bpf_iter.h  |  15 ++
>>   .../selftests/bpf/progs/bpf_iter_tcp4.c       | 235 ++++++++++++++++
>>   .../selftests/bpf/progs/bpf_iter_tcp6.c       | 250 ++++++++++++++++++
>>   3 files changed, 500 insertions(+)
>>   create mode 100644 tools/testing/selftests/bpf/progs/bpf_iter_tcp4.c
>>   create mode 100644 tools/testing/selftests/bpf/progs/bpf_iter_tcp6.c
>>
> 
> [...]
> 
>> +static int hlist_unhashed_lockless(const struct hlist_node *h)
>> +{
>> +        return !(h->pprev);
>> +}
>> +
>> +static int timer_pending(const struct timer_list * timer)
>> +{
>> +       return !hlist_unhashed_lockless(&timer->entry);
>> +}
>> +
>> +extern unsigned CONFIG_HZ __kconfig __weak;
> 
> Why the __weak? We expect to have /proc/kconfig.gz in other tests
> anyway? __weak will make CONFIG_HZ to be a zero and you'll get a bunch
> of divisions by zero.

Make sense. Will change.

> 
>> +
>> +#define USER_HZ                100
>> +#define NSEC_PER_SEC   1000000000ULL
>> +static clock_t jiffies_to_clock_t(unsigned long x)
>> +{
>> +       /* The implementation here tailored to a particular
>> +        * setting of USER_HZ.
>> +        */
>> +       u64 tick_nsec = (NSEC_PER_SEC + CONFIG_HZ/2) / CONFIG_HZ;
>> +       u64 user_hz_nsec = NSEC_PER_SEC / USER_HZ;
>> +
>> +       if ((tick_nsec % user_hz_nsec) == 0) {
>> +               if (CONFIG_HZ < USER_HZ)
>> +                       return x * (USER_HZ / CONFIG_HZ);
>> +               else
>> +                       return x / (CONFIG_HZ / USER_HZ);
>> +       }
>> +       return x * tick_nsec/user_hz_nsec;
>> +}
>> +
> 
> [...]
> 
>> +       if (sk_common->skc_family != AF_INET)
>> +               return 0;
>> +
>> +       tp = bpf_skc_to_tcp_sock(sk_common);
>> +       if (tp) {
>> +               return dump_tcp_sock(seq, tp, uid, seq_num);
>> +       }
> 
> nit: unnecessary {}
> 
>> +
>> +       tw = bpf_skc_to_tcp_timewait_sock(sk_common);
>> +       if (tw)
>> +               return dump_tw_sock(seq, tw, uid, seq_num);
>> +
>> +       req = bpf_skc_to_tcp_request_sock(sk_common);
>> +       if (req)
>> +               return dump_req_sock(seq, req, uid, seq_num);
>> +
>> +       return 0;
>> +}
> 
> [...]
> 
>> +static int timer_pending(const struct timer_list * timer)
>> +{
>> +       return !hlist_unhashed_lockless(&timer->entry);
>> +}
>> +
>> +extern unsigned CONFIG_HZ __kconfig __weak;
> 
> same about __weak here
> 
>> +
>> +#define USER_HZ                100
>> +#define NSEC_PER_SEC   1000000000ULL
>> +static clock_t jiffies_to_clock_t(unsigned long x)
>> +{
>> +       /* The implementation here tailored to a particular
>> +        * setting of USER_HZ.
>> +        */
>> +       u64 tick_nsec = (NSEC_PER_SEC + CONFIG_HZ/2) / CONFIG_HZ;
>> +       u64 user_hz_nsec = NSEC_PER_SEC / USER_HZ;
>> +
>> +       if ((tick_nsec % user_hz_nsec) == 0) {
>> +               if (CONFIG_HZ < USER_HZ)
>> +                       return x * (USER_HZ / CONFIG_HZ);
>> +               else
>> +                       return x / (CONFIG_HZ / USER_HZ);
>> +       }
>> +       return x * tick_nsec/user_hz_nsec;
>> +}
> 
> nit: jiffies_to_clock_t() implementation looks like an overkill for
> this use case... Would it be just `x / CONFIG_HZ * NSEC_PER_SEC` with
> some potential rounding error?

We really want to have the output the same as /proc/net/{tcp,tcp6}.
Otherwise, it may cause confusion when comparing bpf_iter_tcp[6] outputs
vs. /proc/net/tcp[6] outputs.

> 
>> +
>> +static clock_t jiffies_delta_to_clock_t(long delta)
>> +{
>> +       if (delta <= 0)
>> +               return 0;
>> +
>> +       return jiffies_to_clock_t(delta);
>> +}
>> +
> 
> [...]
> 

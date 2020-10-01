Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73B4727F6EB
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 03:00:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732305AbgJABA1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 21:00:27 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:14896 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731881AbgJABA1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Sep 2020 21:00:27 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0910kn8X017514;
        Wed, 30 Sep 2020 18:00:10 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=3BT4dLLITgqffW69jdoHe3+UzS+kRmqC/DX4p5tNVgc=;
 b=hDB9idnXaSaWkfywsiaGCLYki0ts/l+uIrqssgoJFVQsGGJ6O7iFYZQqRiQhT0Z878Km
 Jpa9hw5ZXMrxmW2fSfd2HYmLYe1E4AOJY6efA8wyWFy5yjcYxZoUg8jkUEkiCzaEitir
 3keM5Aa/S/jJJhw4zQpsogcIcE1HfVQS4J0= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 33v3vu2agc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 30 Sep 2020 18:00:10 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 30 Sep 2020 18:00:08 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gtxEQjDbjjMGAC+Wb2cM+Pjgg4Ynkjgmdx3EQzyEDh2IWOmkzRwyGjRaCUupc8pKvMunHUM6TD8/p26+mIuwEtt/ZqiiDUFNWuZI8RGxiKoGnE6y5LBUkh5wtLmjIVEvKRL700KB4g2QfSSSR2vbE3CNHQ/oqvBGeX+6bJTYAHjnFLBPdPQY8HZS+p3AmhIJjpM1PsSAPDsJCrCwHyS2VPxpKYRktsx9W+3jnepE0cENzX8DTnX3PLqwvhA6bqgg7BfXYMlZKX/6ApciYIqqp6H8AqxjIiATmq321BRCrKpBfelvb+h0kMmXB0B0iAswRCbBihNMRxyT6BiohoGPIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3BT4dLLITgqffW69jdoHe3+UzS+kRmqC/DX4p5tNVgc=;
 b=lPKKfJSsCX7pgZ/83gp33yHbg014I0EBWrX1rvRD/Z8bgioTnWHeKyJ2mrYhMX8VFUljb2ZkWxyZuMpDT7LBZQwE/UWeTaSTXDLhT3RL3X2zrZ3v5zoQTV6EkfIWQXtoXN3dsT9j7RGeTClf8avsGzlVILbdmzYTZW75ifneUZvn7S5e3f0KU708PylYpogLE1dTbACccy9h2ooFXW/A0unLstapYhY0Jdb8Ihx2JDm5ztz1Frhr1mBkM8U1jdxnRjVybJyyHqE1Z40RNaB7CNLPjKbSIEJLTBeS74Y0lIyvGdrSqWWLIf5zUuxhfxQe9a8piyBzoKM2ZL01rD8u8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3BT4dLLITgqffW69jdoHe3+UzS+kRmqC/DX4p5tNVgc=;
 b=gf+T7DjBAoYxzkrpsaQTbNID7xtenhz//m7sZDCb9j9mRekZ131scqKMfdM4Qs7jMZeNdTYGrgl+i2Roac7ijHu8WRveMyC2SVCcm0928jDM0hXyyM0YWe0UlhKZxLw9s3yG758XXvri8v1gi7TtBEjsbVOe8ZNSXgSN+ZFJsdw=
Authentication-Results: suse.cz; dkim=none (message not signed)
 header.d=none;suse.cz; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB3256.namprd15.prod.outlook.com (2603:10b6:a03:10f::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.21; Thu, 1 Oct
 2020 01:00:03 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::8887:dd68:f497:ea42]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::8887:dd68:f497:ea42%3]) with mapi id 15.20.3433.036; Thu, 1 Oct 2020
 01:00:03 +0000
Subject: Re: [PATCH bpf] bpf: fix "unresolved symbol" build error with
 resolve_btfids
To:     Martin KaFai Lau <kafai@fb.com>
CC:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        Michal Kubecek <mkubecek@suse.cz>
References: <20200930164109.2922412-1-yhs@fb.com>
 <20200930205847.7pj5pblqe6k6v64q@kafai-mbp.dhcp.thefacebook.com>
 <d5d8091d-e02e-3903-6203-c136b8d70c09@fb.com>
 <20200930225941.zq2vaxsuphfbga4s@kafai-mbp.dhcp.thefacebook.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <e43c8120-46d7-a390-e99a-569e39cd1f69@fb.com>
Date:   Wed, 30 Sep 2020 18:00:00 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.0
In-Reply-To: <20200930225941.zq2vaxsuphfbga4s@kafai-mbp.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2620:10d:c090:400::5:a1b9]
X-ClientProxiedBy: MWHPR10CA0069.namprd10.prod.outlook.com
 (2603:10b6:300:2c::31) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21c1::1992] (2620:10d:c090:400::5:a1b9) by MWHPR10CA0069.namprd10.prod.outlook.com (2603:10b6:300:2c::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.15 via Frontend Transport; Thu, 1 Oct 2020 01:00:02 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3ca99978-69cf-4d6d-9ba3-08d865a55475
X-MS-TrafficTypeDiagnostic: BYAPR15MB3256:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB3256B7717717076B18DC269BD3300@BYAPR15MB3256.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SV+ph40SXSeMIc2BW+htTfFAH9lMWn9eBj8XgatftrXZW7OhO2Hzj600Y9EW05KkeWLEVBKrp0LV5li6YbcBPRoOcrvhKqpfKfb4fLkouYo4WYwe57rmVIEFTXZHff0OMBLS+9Sau6TIqxLJbqC7cvlKrafimz8xDNB0waV9rJ43kPVpcZklTXLZy59VEtVDFa37uvGpWBqkW3l10ApyJ6Y8gtuqaIyxv1mKrE0dLWoraYHxHvv6KXVxWMCuRi4Xv+kYCApMi/Bff0ieyTGQkrlvyXc3+hfIg8/XYzZ4dTmCtzMZkBxT7vXHIGcwcTjzdFQ+NgcKRfYS0dgZOeS4lrLC4lox0NbyJaWtu5+SudBYVcNoGzvFYzOWkv9UGHO0C7uhT+WQMcoQecYR415RdPrJNJZy3thf1oI96OWv9wt9fkeXFkDPz1+DjXkeTwKE7QLY5BHqMz+8S0pHaJe0eg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(346002)(136003)(376002)(39860400002)(396003)(2906002)(86362001)(4326008)(316002)(37006003)(6486002)(52116002)(478600001)(53546011)(83380400001)(2616005)(31686004)(5660300002)(8676002)(6636002)(66946007)(8936002)(66556008)(36756003)(66476007)(54906003)(31696002)(6862004)(186003)(16526019)(21314003)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: /1JfYm1QHcLLMQkuuoc+uBQPFzFVofY7onTsuO0su72z08o/wK6ZINMq/hMAaE9BkYNEKgivnuLHyhXZJFxVqiQ89TrJtqFQaPYBTqf7f4MjPtO2S0x3d3cgpmdRI9Z+F+KqjVUHBHicHOFnmrNVXQSguytbGg+ZI8ev4uQMlda7JNRoXBpIYLqXe317ZhFPKXy/nHug/lUwJtpSHYcaEaF8baiMWm8xUvYdc7TJxNmO/unnsxpuc/H0RSeDpUW2qTU6cBm0Lva/gzoTU8HZEibp3HW7nIz0hksSGaPcPAuToCqSwBAaMkdzQy9BNx9WF6i4Qp9cl4zQpw/sF3IDljhw0nj2c3ci7au/shPZKCZSJ0QamEv5bLGmUB7rlHZyGVszpLRIu2DkbtqoIRcr5B3U3oorD5/d93CZr+KmMtMJk95o05KdDg8wUSzh4dcCqy2J5KctHxgmVlknbwwvez3D94xH21Lfd1I+MXg1lwRQhZwGUyi3QiZP5wyDmHN/hCoQWwGsoqGQXbczP8MQE/8BXvbkhQ3qgMtYpSG0t/yZ7eTDyj+KZRuiNVWxiZhjjY3KAZvW3KwhuAauBmcVT13MTQotWB19A4VX6u2EWBWTmrTuWfC20qsIMe2WnEu4Kl26q3jLYsIGsdbxuSN4j+wSbvkV/ALG4jy+qKiN8As=
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ca99978-69cf-4d6d-9ba3-08d865a55475
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Oct 2020 01:00:03.6666
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +rPpq2Bb1GD4W/JGVit+dmCh/Os3sAfohQM33ss7QS+6XuiI2jZOGYRyr2QGPy90
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3256
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-30_13:2020-09-30,2020-09-30 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 suspectscore=0 phishscore=0 mlxlogscore=999 clxscore=1015 bulkscore=0
 impostorscore=0 adultscore=0 priorityscore=1501 spamscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2010010004
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/30/20 3:59 PM, Martin KaFai Lau wrote:
> On Wed, Sep 30, 2020 at 03:50:10PM -0700, Yonghong Song wrote:
>>
>>
>> On 9/30/20 1:58 PM, Martin KaFai Lau wrote:
>>> On Wed, Sep 30, 2020 at 09:41:09AM -0700, Yonghong Song wrote:
>>>> Michal reported a build failure likes below:
>>>>      BTFIDS  vmlinux
>>>>      FAILED unresolved symbol tcp_timewait_sock
>>>>      make[1]: *** [/.../linux-5.9-rc7/Makefile:1176: vmlinux] Error 255
>>>>
>>>> This error can be triggered when config has CONFIG_NET enabled
>>>> but CONFIG_INET disabled. In this case, there is no user of
>>>> structs inet_timewait_sock and tcp_timewait_sock and hence vmlinux BTF
>>>> types are not generated for these two structures.
>>>>
>>>> To fix the problem, omit the above two types for BTF_SOCK_TYPE_xxx
>>>> macro if CONFIG_INET is not defined.
>>>>
>>>> Fixes: fce557bcef11 ("bpf: Make btf_sock_ids global")
>>>> Reported-by: Michal Kubecek <mkubecek@suse.cz>
>>>> Signed-off-by: Yonghong Song <yhs@fb.com>
>>>> ---
>>>>    include/linux/btf_ids.h | 20 ++++++++++++++++----
>>>>    1 file changed, 16 insertions(+), 4 deletions(-)
>>>>
>>>> diff --git a/include/linux/btf_ids.h b/include/linux/btf_ids.h
>>>> index 4867d549e3c1..d9a1e18d0921 100644
>>>> --- a/include/linux/btf_ids.h
>>>> +++ b/include/linux/btf_ids.h
>>>> @@ -102,24 +102,36 @@ asm(							\
>>>>     * skc_to_*_sock() helpers. All these sockets should have
>>>>     * sock_common as the first argument in its memory layout.
>>>>     */
>>>> -#define BTF_SOCK_TYPE_xxx \
>>>> +
>>>> +#define __BTF_SOCK_TYPE_xxx \
>>>>    	BTF_SOCK_TYPE(BTF_SOCK_TYPE_INET, inet_sock)			\
>>>>    	BTF_SOCK_TYPE(BTF_SOCK_TYPE_INET_CONN, inet_connection_sock)	\
>>>>    	BTF_SOCK_TYPE(BTF_SOCK_TYPE_INET_REQ, inet_request_sock)	\
>>>> -	BTF_SOCK_TYPE(BTF_SOCK_TYPE_INET_TW, inet_timewait_sock)	\
>>>>    	BTF_SOCK_TYPE(BTF_SOCK_TYPE_REQ, request_sock)			\
>>>>    	BTF_SOCK_TYPE(BTF_SOCK_TYPE_SOCK, sock)				\
>>>>    	BTF_SOCK_TYPE(BTF_SOCK_TYPE_SOCK_COMMON, sock_common)		\
>>>>    	BTF_SOCK_TYPE(BTF_SOCK_TYPE_TCP, tcp_sock)			\
>>>>    	BTF_SOCK_TYPE(BTF_SOCK_TYPE_TCP_REQ, tcp_request_sock)		\
>>>> -	BTF_SOCK_TYPE(BTF_SOCK_TYPE_TCP_TW, tcp_timewait_sock)		\
>>>>    	BTF_SOCK_TYPE(BTF_SOCK_TYPE_TCP6, tcp6_sock)			\
>>>>    	BTF_SOCK_TYPE(BTF_SOCK_TYPE_UDP, udp_sock)			\
>>>>    	BTF_SOCK_TYPE(BTF_SOCK_TYPE_UDP6, udp6_sock)
>>>> +#define __BTF_SOCK_TW_TYPE_xxx \
>>>> +	BTF_SOCK_TYPE(BTF_SOCK_TYPE_INET_TW, inet_timewait_sock)	\
>>>> +	BTF_SOCK_TYPE(BTF_SOCK_TYPE_TCP_TW, tcp_timewait_sock)
>>>> +
>>>> +#ifdef CONFIG_INET
>>>> +#define BTF_SOCK_TYPE_xxx						\
>>>> +	__BTF_SOCK_TYPE_xxx						\
>>>> +	__BTF_SOCK_TW_TYPE_xxx
>>>> +#else
>>>> +#define BTF_SOCK_TYPE_xxx	__BTF_SOCK_TYPE_xxx
>>> BTF_SOCK_TYPE_xxx is used in BTF_ID_LIST_GLOBAL(btf_sock_ids) in filter.c
>>> which does not include BTF_SOCK_TYPE_TCP_TW.
>>> However, btf_sock_ids[BTF_SOCK_TYPE_TCP_TW] is still used
>>> in bpf_skc_to_tcp_timewait_sock_proto.
>>>
>>>> +#endif
>>>> +
>>>>    enum {
>>>>    #define BTF_SOCK_TYPE(name, str) name,
>>>> -BTF_SOCK_TYPE_xxx
>>>> +__BTF_SOCK_TYPE_xxx
>>>> +__BTF_SOCK_TW_TYPE_xxx
>>> BTF_SOCK_TYPE_TCP_TW is at the end of this enum.
>>>
>>> Would btf_sock_ids[BTF_SOCK_TYPE_TCP_TW] always be 0?
>>
>> No. If CONFIG_INET is y, the above BTF_SOCK_TYPE_xxx contains
>>    __BTF_SOCK_TW_TYPE_xxx
>> and
>>    btf_sock_ids[BTF_SOCK_TYPE_TCP_TW] will be calculated properly.
>>
>> But if CONFIG_INET is n, then BTF_SOCK_TYPE_xxx will not contain
>>     __BTF_SOCK_TW_TYPE_xxx
>> so btf_sock_ids[BTF_SOCK_TYPE_TCP_TW] will have default value 0
>> as btf_sock_ids is a global.
> I could be missing something here.
> Why btf_sock_ids[BTF_SOCK_TYPE_TCP_TW] must be 0?
> How does BTF_ID_LIST_GLOBAL() know there is a
> btf_sock_ids[BTF_SOCK_TYPE_TCP_TW]?
> I would expect at least BTF_ID_UNUSED is required.
> Otherwise, the value will be whatever follow the last
> btf_sock_ids[BTF_SOCK_TYPE_UDP6].

Right, I realized later on when I prepare v2. Will send patch v2 shortly.

> 
>>
>> Will send v2 to add some comments to make it easy to understand.
>>
>>>
>>>>    #undef BTF_SOCK_TYPE
>>>>    MAX_BTF_SOCK_TYPE,
>>>>    };
>>>> -- 
>>>> 2.24.1
>>>>

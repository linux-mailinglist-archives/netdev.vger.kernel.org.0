Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E873927F28C
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 21:25:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729688AbgI3TZW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 15:25:22 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:17100 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725872AbgI3TZV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Sep 2020 15:25:21 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08UJH5lw010484;
        Wed, 30 Sep 2020 12:25:03 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=HKR3x6u29/xKOsdeiRGq89tazDVAUuj02KCJ1EUWW64=;
 b=G0zk0TOxyTSjZ9UpH+ELAB9b+dIV3uRzxAlDhwWTs/yZ6iR/O09xFsFzxNq5z7h5Hnmz
 vCDyX5pCs5me9XXHnvuzbeSueT7IgtUDimnnbHDUTeyBbq0H460WxuQcV5QT/ZWX3o/B
 v6ZfReJ4jFdwZ1d/Nnve/bd+cjJFhRGVDHU= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 33v3vu0qfv-8
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 30 Sep 2020 12:25:03 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 30 Sep 2020 12:24:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KDcye/7+7OjzdwZ0NUJO1eNHPzQVNe7eyK7iadqtGWqkduQ4Q41vmFVu1GRlNijY4S6sTkWCeCmgM6XwdjiG15LGHBaEa4w7Wv7KQE8tUPU/Z8JmR+r3uOvLad91rCUX8jT5lv9UdiiVvXigE/QyNBzkAHiHdpISPC99E6i3S4NcK9lSUyyQF1IpgueL+RLQd8SwUxvUgfhndb9e3gENC4FlARrMc2V33u00YShAJ+SVwlHdK0DQ9+bv7hQtFmzok1mN2s1NPtioMdTp4UfytmavGR8DptdvBQPNyouTIjhp+0Wu627zWWnK3ownEMWAj8tufwt3Ze3loaJcgz+1cw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HKR3x6u29/xKOsdeiRGq89tazDVAUuj02KCJ1EUWW64=;
 b=kImf6+/vGCdNjWRkpLgL+Kk2G4gjUcLw6PCMs7R2JMPHpfIbysnghdFwJsX2XK5NYAhAivnpG5VNJEcTCTbNVbx2U25Jlia9J5BEHzrbZgkVGYbj5hkubaJav56Rn1OVJuOmlm4kmPT30J1czQ42Mb+D16+i0fWg/NaAUXYLUpIThRaLelyAdy9+z1O/ZfvD9tykc+FlLMP+cGwLNJP2kaRIcyefVbgQnJgO4xGzrX5bMlvFIeNrUAKeIXPUykEzKLuTo950SWjRX0m0HoAbo6zc7gveiJI4myJZ+kzE3RfLuvATjtzDPN3zU07wEUBGFhs4Y6daX+ZcNqM0edBLZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HKR3x6u29/xKOsdeiRGq89tazDVAUuj02KCJ1EUWW64=;
 b=bDL5p07GWXntZNiWo+GDUK5+fO4kizcbGXEyUjAyqIm8fhmuZWqq4CTBd1HTMADofu9/gJD0jwYLkHpnQlLVY/Gp2Mf5q5NBFMyHw23dlFHoSRgVT4LD8FzUk6WNzP+TUyrf/PHgxJL2CkgvLLi9PmBBU8k1Jy+wgsFZrki1HKQ=
Authentication-Results: suse.cz; dkim=none (message not signed)
 header.d=none;suse.cz; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB2566.namprd15.prod.outlook.com (2603:10b6:a03:150::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.20; Wed, 30 Sep
 2020 19:24:51 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::8887:dd68:f497:ea42]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::8887:dd68:f497:ea42%3]) with mapi id 15.20.3433.036; Wed, 30 Sep 2020
 19:24:51 +0000
Subject: Re: [PATCH bpf] bpf: fix "unresolved symbol" build error with
 resolve_btfids
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Michal Kubecek <mkubecek@suse.cz>
References: <20200930164109.2922412-1-yhs@fb.com>
 <CAEf4BzZKqrKPifnJmX8fabmXCVRK45ERiEy5aHGFJ9dg0c2oAA@mail.gmail.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <db1cec73-a16a-5407-1bc5-cd7afd557771@fb.com>
Date:   Wed, 30 Sep 2020 12:24:48 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.0
In-Reply-To: <CAEf4BzZKqrKPifnJmX8fabmXCVRK45ERiEy5aHGFJ9dg0c2oAA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2620:10d:c090:400::5:e908]
X-ClientProxiedBy: MWHPR14CA0003.namprd14.prod.outlook.com
 (2603:10b6:300:ae::13) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21c1::1992] (2620:10d:c090:400::5:e908) by MWHPR14CA0003.namprd14.prod.outlook.com (2603:10b6:300:ae::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.20 via Frontend Transport; Wed, 30 Sep 2020 19:24:50 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a5fdd988-ec3e-437d-2ecb-08d86576809f
X-MS-TrafficTypeDiagnostic: BYAPR15MB2566:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB2566223AD045ED002B588589D3330@BYAPR15MB2566.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 09X2jryLrX/o7pbiMd7HQ68fAdaOqFphqGYfntB+A8Yg4xdFRi1J9P5fj9YoWiGzoF5yUd9Tsa6l4lB1wnHm8RyTFhFBVzoYOU6DnAKVAtOSBeS/5qB3S9xIVSaBsAZ8TSxb6Dll1jHejOk0FlvJ0oocYW9hxWbPSeSTP8LEZYk0PMXcfcJbF1vLwJFYw7DTVl1pxBg+s1tO8ENZsJ7OjJABLpH5utds1N9KuvwjFyoxTe1EjkcqZfmWm+53tqSo5F4oB/TPTQIFRufHk5XPDM8eCzWwuy7ZU4xAzaijToKtOPejmsmttmnU1uOFJz55T71MYpzY5wPqZZKwzvlYA5Ydj8cSd+bVPevZtWjFDACicUHw0HtuJ7HGLIg49+snkmeoga4osE5tlR/vwpLuGaSb5JMkkXXuUAfN54HQGU8a4sb646SnCF8vAaT5KecLuxkj7DOUvo03uBnFEbw9iQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(396003)(376002)(136003)(346002)(39860400002)(54906003)(6486002)(2906002)(52116002)(36756003)(4326008)(53546011)(2616005)(31696002)(316002)(16526019)(186003)(8676002)(8936002)(5660300002)(478600001)(6916009)(66946007)(86362001)(31686004)(66556008)(83380400001)(66476007)(21314003)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: a0XCV7W3fXD8qLB2VwlmWHT91bPGOfvIqZEMGxBw2g8Nz8pwenGuxYg63VZGIqb4/OGI+gzdZeeKxprELqDJLu0NdMOgyrFDohdtsrhcVjLYyYywRtqVJAiEZ6/BbMevfAbEz1bdRp7lWat8xrfIOUuI+GND+F6GW/nGgsJh0NwQmEc7He/iy5kR6juSZH1mtuNXuQxqo0+Q95UZruSec+BE3YXZSGpVs70n88m/OhrKu8aYZk3FPoKKBOzrrzoIeFwnnNvnDVlEqljUG8Wz9Ff6mE6CpQTeEu3E5gaU+Os4wPk7emWRnIDxMORuYZMupK1q34IAtTb0ks4W8iA4qeXUdlSuHPvyF9CjIz9leaoqU4eG7NEbj3HSkLW/48X07rlh3nUUoXPSfQyVrXTju1DhsaPmf0OeW3lTSPckFUnyXpNSAe1dpj3eRQGzsCrS/YeGiskhMzI2IkRePB5qq1RK7OVvInPO5vQ5qGiQkLlVsAo2swjN4iuPsPMTMofjDy1lO4tCSWOsxfw6advErOaIdEJRA2FYqVZ+uQq9L4JF8AU1I6l4/Guh2PXvBawp6exIZnAV3ueyhpEWl84mBvjZjETCH2PomPdYT5eQGh1wjS6nb9tFEx/8LJlEWZt9/Lg8+jg4n1lu0SAjvgKJ+QwrEftvxuIrwkmPwk3BCsU=
X-MS-Exchange-CrossTenant-Network-Message-Id: a5fdd988-ec3e-437d-2ecb-08d86576809f
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2020 19:24:51.3566
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4p4wHA0/n4QOo0LMgCDDRcbDrvQGA/0J+s1fT/QMG3xKnthj9SOi5UIpuMx13Ys2
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2566
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-30_10:2020-09-30,2020-09-30 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 suspectscore=0 phishscore=0 mlxlogscore=999 clxscore=1015 bulkscore=0
 impostorscore=0 adultscore=0 priorityscore=1501 spamscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009300156
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/30/20 11:40 AM, Andrii Nakryiko wrote:
> On Wed, Sep 30, 2020 at 9:41 AM Yonghong Song <yhs@fb.com> wrote:
>>
>> Michal reported a build failure likes below:
>>     BTFIDS  vmlinux
>>     FAILED unresolved symbol tcp_timewait_sock
>>     make[1]: *** [/.../linux-5.9-rc7/Makefile:1176: vmlinux] Error 255
>>
>> This error can be triggered when config has CONFIG_NET enabled
>> but CONFIG_INET disabled. In this case, there is no user of
>> structs inet_timewait_sock and tcp_timewait_sock and hence vmlinux BTF
>> types are not generated for these two structures.
>>
>> To fix the problem, omit the above two types for BTF_SOCK_TYPE_xxx
>> macro if CONFIG_INET is not defined.
>>
>> Fixes: fce557bcef11 ("bpf: Make btf_sock_ids global")
>> Reported-by: Michal Kubecek <mkubecek@suse.cz>
>> Signed-off-by: Yonghong Song <yhs@fb.com>
>> ---
>>   include/linux/btf_ids.h | 20 ++++++++++++++++----
>>   1 file changed, 16 insertions(+), 4 deletions(-)
>>
>> diff --git a/include/linux/btf_ids.h b/include/linux/btf_ids.h
>> index 4867d549e3c1..d9a1e18d0921 100644
>> --- a/include/linux/btf_ids.h
>> +++ b/include/linux/btf_ids.h
>> @@ -102,24 +102,36 @@ asm(                                                      \
>>    * skc_to_*_sock() helpers. All these sockets should have
>>    * sock_common as the first argument in its memory layout.
>>    */
>> -#define BTF_SOCK_TYPE_xxx \
>> +
>> +#define __BTF_SOCK_TYPE_xxx \
>>          BTF_SOCK_TYPE(BTF_SOCK_TYPE_INET, inet_sock)                    \
>>          BTF_SOCK_TYPE(BTF_SOCK_TYPE_INET_CONN, inet_connection_sock)    \
>>          BTF_SOCK_TYPE(BTF_SOCK_TYPE_INET_REQ, inet_request_sock)        \
>> -       BTF_SOCK_TYPE(BTF_SOCK_TYPE_INET_TW, inet_timewait_sock)        \
>>          BTF_SOCK_TYPE(BTF_SOCK_TYPE_REQ, request_sock)                  \
>>          BTF_SOCK_TYPE(BTF_SOCK_TYPE_SOCK, sock)                         \
>>          BTF_SOCK_TYPE(BTF_SOCK_TYPE_SOCK_COMMON, sock_common)           \
>>          BTF_SOCK_TYPE(BTF_SOCK_TYPE_TCP, tcp_sock)                      \
>>          BTF_SOCK_TYPE(BTF_SOCK_TYPE_TCP_REQ, tcp_request_sock)          \
>> -       BTF_SOCK_TYPE(BTF_SOCK_TYPE_TCP_TW, tcp_timewait_sock)          \
>>          BTF_SOCK_TYPE(BTF_SOCK_TYPE_TCP6, tcp6_sock)                    \
>>          BTF_SOCK_TYPE(BTF_SOCK_TYPE_UDP, udp_sock)                      \
>>          BTF_SOCK_TYPE(BTF_SOCK_TYPE_UDP6, udp6_sock)
>>
>> +#define __BTF_SOCK_TW_TYPE_xxx \
>> +       BTF_SOCK_TYPE(BTF_SOCK_TYPE_INET_TW, inet_timewait_sock)        \
>> +       BTF_SOCK_TYPE(BTF_SOCK_TYPE_TCP_TW, tcp_timewait_sock)
>> +
>> +#ifdef CONFIG_INET
>> +#define BTF_SOCK_TYPE_xxx                                              \
>> +       __BTF_SOCK_TYPE_xxx                                             \
>> +       __BTF_SOCK_TW_TYPE_xxx
>> +#else
>> +#define BTF_SOCK_TYPE_xxx      __BTF_SOCK_TYPE_xxx
>> +#endif
>> +
>>   enum {
>>   #define BTF_SOCK_TYPE(name, str) name,
>> -BTF_SOCK_TYPE_xxx
>> +__BTF_SOCK_TYPE_xxx
>> +__BTF_SOCK_TW_TYPE_xxx
> 
> Why BTF_SOCK_TYPE_xxx doesn't still work here after the above changes?

The macro, e.g., BTF_SOCK_TYPE_TCP_TW, still needed to be defined as
it is used to get the location for btf_id.

const struct bpf_func_proto bpf_skc_to_tcp_timewait_sock_proto = {
         .func                   = bpf_skc_to_tcp_timewait_sock,
         .gpl_only               = false,
         .ret_type               = RET_PTR_TO_BTF_ID_OR_NULL,
         .arg1_type              = ARG_PTR_TO_BTF_ID_SOCK_COMMON,
         .ret_btf_id             = &btf_sock_ids[BTF_SOCK_TYPE_TCP_TW],
};

If CONFIG_INET is not defined, bpf_sock_ids[BTF_SOCK_TYPE_TCP_TW]
will be 0.

> 
>>   #undef BTF_SOCK_TYPE
>>   MAX_BTF_SOCK_TYPE,
>>   };
>> --
>> 2.24.1
>>

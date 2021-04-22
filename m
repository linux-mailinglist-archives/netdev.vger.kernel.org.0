Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48E41367711
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 03:56:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231463AbhDVB5V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 21:57:21 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:36152 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229502AbhDVB5U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Apr 2021 21:57:20 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.43/8.16.0.43) with SMTP id 13M1nHpY031814;
        Wed, 21 Apr 2021 18:56:26 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=dZIU4zV6huz7GGKyC/oRWJhcBm76VJbY+cZ2OVrV1wM=;
 b=jDs4Pm96CF6Zids/36ucNsRd+/Ea6bjJ2jN1cpjMeJX/bQ8ZfTkkmuduChp+pNORKPpH
 Uw/lbEmQsUsCHnbsTkB88/Hrlf5id04GA/0x9YJcijDkxV/PHSROtBCia88DTmBdAbKF
 SaFoByBwVBruPD8ufEfe8Zqzuf0/yjN0rWo= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net with ESMTP id 382k2uw6kf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 21 Apr 2021 18:56:26 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 21 Apr 2021 18:56:25 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dl5aPq+Mu+p6mY51QiaV+utgjffo0VJTppFmNp1L4iGhH7N+THsqOy8sZhM9D7B67LnKjTLSq+RNPgEVJ7ZZjI2Dls0TtxW1XPnLJVlpq3J28mYlI4O8uOQl3OwCpc/zZNHkuRY7LN2E0pchGnCfAtl4XWvBf6HuzZu90FSzAqZ5+o3mEKtfttyoe6QiOPvuw+9oUAlpOsgZgSf6fTYvjZe6siIrZv82CFNXSe2UdX/0PmPctrrsIHE+SMt07MhwZReNNvsW/nfIVNEUjoaMEsMLzeehNbuDmTQ7uWIw3lIc5vyGyYcEpa5U8nAF3+I0IZlavM7NrAGF34b8kBPKjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dZIU4zV6huz7GGKyC/oRWJhcBm76VJbY+cZ2OVrV1wM=;
 b=GVHz7Spu+hfh+aHgLlOSA3r7IgZ7BwMrMhmkRQbz9CAzzmF0vnYRSa+Zhtt2Blg4Azff++n0omROibZDXohXbXAretxPUWmvU86BRyK3xSV8Q/3yjfoN/pRtWP4sux1druUpQ8pfOTybEEBCRciJ1AGqfLu+VfNO841CJqp3+c0Mf07V6mVN3QFrWutFmXnkGdydM6D9NucX7RyQ0vj8RBB+YmoSJmo48Jb2OPrgv+KdzLH5UqStt2O34rMgR4FBoLx0ekZ3ZjKBmmo+Xpw9BAAzGD07EQ3MNcHa2iuA8Sitgd8plQmDMiK5EoFGOaQI+SgFEtzAXTAdcqN8DpTq4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=fb.com;
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SN6PR15MB2415.namprd15.prod.outlook.com (2603:10b6:805:1c::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.19; Thu, 22 Apr
 2021 01:56:24 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::f433:fd99:f905:8912]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::f433:fd99:f905:8912%3]) with mapi id 15.20.4065.021; Thu, 22 Apr 2021
 01:56:24 +0000
Subject: Re: [PATCH bpf-next v3 2/3] libbpf: add low level TC-BPF API
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
CC:     <bpf@vger.kernel.org>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        <netdev@vger.kernel.org>
References: <20210420193740.124285-1-memxor@gmail.com>
 <20210420193740.124285-3-memxor@gmail.com>
 <27b90b27-ce90-7b2c-23be-24cbc0781fbe@fb.com>
 <20210421170610.52vxrdrr5lzvkc2b@apollo>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <aef5670f-f3b8-7ea8-28eb-247c814fd005@fb.com>
Date:   Wed, 21 Apr 2021 18:56:20 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.1
In-Reply-To: <20210421170610.52vxrdrr5lzvkc2b@apollo>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [2620:10d:c090:400::5:6133]
X-ClientProxiedBy: MWHPR18CA0039.namprd18.prod.outlook.com
 (2603:10b6:320:31::25) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21c8::16ea] (2620:10d:c090:400::5:6133) by MWHPR18CA0039.namprd18.prod.outlook.com (2603:10b6:320:31::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.20 via Frontend Transport; Thu, 22 Apr 2021 01:56:22 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 53167d74-1d71-4182-516d-08d90531d544
X-MS-TrafficTypeDiagnostic: SN6PR15MB2415:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR15MB2415F7241368C97F9167392CD3469@SN6PR15MB2415.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: j3OSZyL+XSUzgF6zVQrPyeii3XhFUeWkXH2NOHZETuSHM9bshHWrIktdEfSbRIaqyXbneOZOxqvz0GYeBHdQ59LW6DjcU4sJ/VpnQPguj0vlHBef5TnIRyGb/6lU+L3LGi+RN2SLr/MMAuS5yP6uCbfQbVkhMCfpTafjyxA6pdrohpFPN85oTz844k+gcPPIxQO1gzqvXzI6QljoFWQn3M5XbmTqhfV7/tis2H7cXd8BdyMzr8WQV+jjWCYRrEtLtZy4jnf5qksiggiNjDC6COtU4+GxojtIGL81l3J6I2jcKd+QT8+PZ+hDOGiBSwU5IvudCAE2/MgOpKq3tY7xFGKtmHURTCDpGSoYGFMsN52fCToZfH53y/Ps+nbVTB8gwLsIRILz52wqpwxBkBAHLP1r5JDFF2jRZHUM6xz3yVCdVpeRbZ9tnxoPDTpnc8ydQzen2YsxWv/4LIgr9GPykrKP2PVOYH5C4D13oUafo3eiE+QZHvcnMrdCIh+JSkt+b2MXVkBgBe6PpaqMmBGCF3PVF6s9yPw2fs95Tgukx7ChuNbzdJRnl+UJHeZ/qhCt7f6wGn/VYq2XeYzX04+Cu1CmVmQzIXRy4d47MY17HfIlRXrMhhgY1OAv6qBFhGE1JG44Ejl0GdId22nFHCiczlu4J4lF1nMC/aylmAB33S9K4gPhjratQ01KQWEtQshg
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(39860400002)(346002)(376002)(366004)(136003)(6916009)(2906002)(4326008)(31696002)(8936002)(54906003)(31686004)(66556008)(53546011)(2616005)(36756003)(7416002)(52116002)(5660300002)(186003)(86362001)(38100700002)(16526019)(83380400001)(316002)(478600001)(66476007)(8676002)(6486002)(66946007)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?V3ZkUkdOR3IvUThtWFRHU1ZsV3V4aTVLa0NiY2JwT29HMzFnN2FIcmV3c3dt?=
 =?utf-8?B?WmF1WmV2S3VDcXBhU09EM3diRDdlUm84TEplQlA2aFQySjdhUTlCYWFLajFy?=
 =?utf-8?B?Z0s1OHRsVjhBOXN2MDA0elNuNFZFNnY4Z0RnNTNNQ2R3aEpKQUdocjdPUVdP?=
 =?utf-8?B?MWZFZXVVQUh4MS9rSWpneTFMNnhxN2xrdStiRlJvNUQwRm9Bb0RBRmc5emhR?=
 =?utf-8?B?WkN1OVF4QmN6clYwYlh2S1U0dnE4NnMxVXowYTZST2psWHlQdEdJcXRUcVo3?=
 =?utf-8?B?bnhPTlF1bU15Tk4xSnJtbStCVmhLWG5CeEcxTFd1OVBGdzRtV1ZzN082Yk1r?=
 =?utf-8?B?em41NmNJb3o5RE5aOERyazdXbEJqTjExR29MY203Y0ZhSUJBTVlreDF6UHg4?=
 =?utf-8?B?cVk0K05MV3QxSDd2K052TGdCVXNDS3VUWDVHRkp6N2phYWYrUnMzNERhTFdZ?=
 =?utf-8?B?dVRWbU9IS21UODVZVjkwTURHeHRGMElZb1FxTXBiajhwSk5UZlRoNERHaWk2?=
 =?utf-8?B?WFMxOWF0UzEvOVI4L1pLM0QyQmdQeDdrcjhFcFYzT0FoVmhzSEpweWJVTTF1?=
 =?utf-8?B?cGZNdy9mMExGWElnTWxiRVJuQW1MTXNkbUpLRXpvd29VMmVjOWhNK0c0eW9L?=
 =?utf-8?B?V3oxMTUrak9uRDE0NHFqT1FheFdXc2pxSG1pTjdyV0xJbDdpbVVjWE9OSWdS?=
 =?utf-8?B?eGRQckFtTERqUys2VDBqTmRhNkQzNFdtcW9WeFRkSDVPaXhmY3FwNmhQVkIv?=
 =?utf-8?B?L0E1K0gxQzREbWlyYkErWDJaK010ZHg0YURMczBZdjRxNzlmVmt3MTh6c01H?=
 =?utf-8?B?K2FlRWtUSWtCZ2lsbU4xSzZqYzZqb09QZzRiR2VYenZlOUYrMlZ2TnNQWTFR?=
 =?utf-8?B?Q3RHV2Y5Y2xvV21WalRlR2ViWXdsYUpBaFJBM08vcnovRnZiT3FmZ3hpbjBv?=
 =?utf-8?B?ZHdDaW5SOFJMclhNNHZzaGtObVZMNjVWdGgwMzlZNGVEWWdsUzN2UWRnZnlM?=
 =?utf-8?B?T1R1MjlxTjd2bGZCNUQycllSQ0JQMkJJb09MSlBUNktGc1MySUNtcmpNbkNB?=
 =?utf-8?B?T2NQblFnWlhRdzdGdE13Y29xRXNjazJhZGlmUG1LWC9NZDJHb0ZPRWtNUVdZ?=
 =?utf-8?B?a0hid1VyR01walBQdHMvZWdPZEhGWlovUXlqTlIrVC8wajJCOGU0ZU1oM2JQ?=
 =?utf-8?B?TnBnZnc3NUluT0RyK0o0TGMzcHVKVEhkckxtbnpITVl4MDRLb2x3NC9lR0NZ?=
 =?utf-8?B?a3JtOWxITnd6K01xWXE1NGIrM3dodVNaTi9DcWs0REptS3NMOUlHSmN2RjJp?=
 =?utf-8?B?dy80VlFtbEkxTWVvNDdkZWwvcm45Yk9mZkR3bWt6R2kwUkZTZnNZem5zeS8z?=
 =?utf-8?B?Ui9GRUpQUVFkNGMrdkRmTjl1S09QeGk0VDQrdnR4cHRCbmh4VUlVL2tGUisw?=
 =?utf-8?B?TWRmaXFVdzQ0REtEWFpBNW5kR0N3ZGZpK2xKZzNNQlRxNzY2anVDVzJlSVpr?=
 =?utf-8?B?L3hxWHl0WmMwcmRhOWlHejhmQ2dFd0xlVCtFb1BvVlE2U1RLWkdFSDJtTmt3?=
 =?utf-8?B?ZEVYN0R6aXk1OG1DQzRPc2hsalpub0NXMEk2ODhtc2tkZFVSV1BkMEdnTE1G?=
 =?utf-8?B?dWhMVlllN2RPQXpHRzNXWDVTdStiZy9FOUpxTUZ5UUp5dk1PVnRqZytmN1hu?=
 =?utf-8?B?SUZjUUJOZmxkaEdySWZrUkQ2VWZybnFnNEdOd1FOdFlWam5kZDJpNkk0SDhN?=
 =?utf-8?B?elc5NmhJOUhaeTZCRlo4dmFqRVk1VGxhUzhtekhUN2pJWEw2ZEkwSHU2ME9J?=
 =?utf-8?Q?XZkq5Vs8sIOsHJ2pIo+XdChQ9XdbI5piKZX1M=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 53167d74-1d71-4182-516d-08d90531d544
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2021 01:56:24.0785
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cXlpC+axCahnLTYT3MvzdmEO9VaPgptCQaRqq1K7aIz3fHQDqSV6F4WoiGCshUVP
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR15MB2415
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: 6mQ-m2XoaZpwsDde3IFlIy5qCPEiIP_4
X-Proofpoint-GUID: 6mQ-m2XoaZpwsDde3IFlIy5qCPEiIP_4
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-21_08:2021-04-21,2021-04-21 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 impostorscore=0 phishscore=0 mlxscore=0 mlxlogscore=999 lowpriorityscore=0
 bulkscore=0 spamscore=0 adultscore=0 malwarescore=0 suspectscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104220015
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/21/21 10:06 AM, Kumar Kartikeya Dwivedi wrote:
> On Wed, Apr 21, 2021 at 12:28:01PM IST, Yonghong Song wrote:
>>
>>
>> On 4/20/21 12:37 PM, Kumar Kartikeya Dwivedi wrote:
>>> This adds functions that wrap the netlink API used for adding,
>>> manipulating, and removing traffic control filters. These functions
>>> operate directly on the loaded prog's fd, and return a handle to the
>>> filter using an out parameter named id.
>>>
>>> The basic featureset is covered to allow for attaching and removal of
>>> filters. Some additional features like TCA_BPF_POLICE and TCA_RATE for
>>> the API have been omitted. These can added on top later by extending the
>>
>> "later" => "layer"?
>>
> 
> No, I meant that other options can be added on top of this series by someone
> later. I'll reword it.
> 
[...]
>>>
>>> Reviewed-by: Toke Høiland-Jørgensen <toke@redhat.com>
>>> Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
>>> ---
>>>    tools/lib/bpf/libbpf.h   |  44 ++++++
>>>    tools/lib/bpf/libbpf.map |   3 +
>>>    tools/lib/bpf/netlink.c  | 319 ++++++++++++++++++++++++++++++++++++++-
>>>    3 files changed, 360 insertions(+), 6 deletions(-)
>>>
>>> diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
>>> index bec4e6a6e31d..b4ed6a41ea70 100644
>>> --- a/tools/lib/bpf/libbpf.h
>>> +++ b/tools/lib/bpf/libbpf.h
>>> @@ -16,6 +16,8 @@
>>>    #include <stdbool.h>
>>>    #include <sys/types.h>  // for size_t
>>>    #include <linux/bpf.h>
>>> +#include <linux/pkt_sched.h>
>>> +#include <linux/tc_act/tc_bpf.h>
>>>    #include "libbpf_common.h"
>>> @@ -775,6 +777,48 @@ LIBBPF_API int bpf_linker__add_file(struct bpf_linker *linker, const char *filen
>>>    LIBBPF_API int bpf_linker__finalize(struct bpf_linker *linker);
>>>    LIBBPF_API void bpf_linker__free(struct bpf_linker *linker);
>>> +/* Convenience macros for the clsact attach hooks */
>>> +#define BPF_TC_CLSACT_INGRESS TC_H_MAKE(TC_H_CLSACT, TC_H_MIN_INGRESS)
>>> +#define BPF_TC_CLSACT_EGRESS TC_H_MAKE(TC_H_CLSACT, TC_H_MIN_EGRESS)
>>> +
>>> +struct bpf_tc_opts {
>>> +	size_t sz;
>>> +	__u32 handle;
>>> +	__u32 class_id;
>>> +	__u16 priority;
>>> +	bool replace;
>>> +	size_t :0;
>>
>> Did you see any error without "size_t :0"?
>>
> 
> Not really, I just added this considering this recent change:
> dde7b3f5f2f4 ("libbpf: Add explicit padding to bpf_xdp_set_link_opts")

Thanks. That is fine with me then.

> 
>>> +};
>>> +
>>> +#define bpf_tc_opts__last_field replace
>>> +
>>> +/* Acts as a handle for an attached filter */
>>> +struct bpf_tc_attach_id {
>>> +	__u32 handle;
>>> +	__u16 priority;
>>> +};
>>> +
>> [...]
> 
> --
> Kartikeya
> 

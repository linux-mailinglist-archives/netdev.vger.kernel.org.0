Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 447B027F57F
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 00:50:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731890AbgI3Wud (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 18:50:33 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:39946 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731866AbgI3Wud (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Sep 2020 18:50:33 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08UMo3Pv028508;
        Wed, 30 Sep 2020 15:50:18 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=PO8X4HvzM2Pi4jxX5l33QMPnfowFfXwTPnzopREnVBg=;
 b=VCTi9HTprOM/tvcwR+sAon39FajamXDcJUGaxPbdFZ88IfsSGFaHhPJjxn3EKD/XrLxv
 Vq48qLLuLG6e8OyeMt+JFln8qAlTbZUByRK6wkEbOo0anuQwqZ5CXQWo528M2wC26lHh
 EsQivsWmJ4ayDtxwqylBbIBZTAuIUR5V0RY= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 33vtgc39qk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 30 Sep 2020 15:50:18 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 30 Sep 2020 15:50:17 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jUZbuoeG/XD2rb8F2m7o4Ti6+NTHdh3C6gEhaD5KhPGGuQQqklhj1dqrwpp2pimpxJj2vog4rrYYDcPdBtkBb6JGy+unoesbN+e2ItHMB7ILnoPpJYFdNuDlYewxNGg2Pwv/YJA3l/rMjJjWikqbgCwc25S6LJ/SQArrhIeBHpOkZLaE3R4jWGfBcJoxS+9aJ6u2wetG3kMt+67HIj+h7DUL1iQsMGCmM/OGl+Or6Rz1KeCRNh+nPke/yn6rQHldECICDfqryBFc4b32Hq093pEr4+FmoShzmiG/Z0R41P4606CdijilItkgLL8bgW8RoxSh7ImC+v3mW8EIe0NV4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PO8X4HvzM2Pi4jxX5l33QMPnfowFfXwTPnzopREnVBg=;
 b=O2zA3G5gBzM0URV3C7EWVocsOD4VVZTHJlZdjpVMROEnS8wIWkBWnwx9uduYlmp3SLPqtwaA5/iYmVaV5V5yKVSxVGEGlmWFR7XaMc3fisIUXkR2I5yFgzN0B0ggISyPuTy7Kb3TnhiZXiai1K0IPvLemQtMycXhIVL3KfjQtbDMEMgRjNmPzv6BqzCk4xKfWA+/d6kve22RLk0izZBqIM5uFAMDst8Rb3AZ6y/ZDUPp+uEcYSwnAhaTQ5r2hOpzwbCIkC+K+C7QvjUdqupsF94RAkTNlfnA5+OGjRELvMq6V7Pl4T0a1lqCrJz1R8fsecj++4bYJeQio33fNSmnfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PO8X4HvzM2Pi4jxX5l33QMPnfowFfXwTPnzopREnVBg=;
 b=PJdEh2++iR3A1vNDWlCBL+nTBNGSYk7Fd80GqtCaqw27aWbI0rSpKve5fi5A/o7HnbLBFsz0r+po9VDUBbgMfULfGl/n4itn9zIQePysfKkWUnjVdSkFhNxfHoXgBJ/S+1bMjPnBCCENy01i+NeVEqSzuSzdIlgXc8L3DvHTiak=
Authentication-Results: suse.cz; dkim=none (message not signed)
 header.d=none;suse.cz; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB3189.namprd15.prod.outlook.com (2603:10b6:a03:103::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.20; Wed, 30 Sep
 2020 22:50:13 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::8887:dd68:f497:ea42]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::8887:dd68:f497:ea42%3]) with mapi id 15.20.3433.036; Wed, 30 Sep 2020
 22:50:13 +0000
Subject: Re: [PATCH bpf] bpf: fix "unresolved symbol" build error with
 resolve_btfids
To:     Martin KaFai Lau <kafai@fb.com>
CC:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        Michal Kubecek <mkubecek@suse.cz>
References: <20200930164109.2922412-1-yhs@fb.com>
 <20200930205847.7pj5pblqe6k6v64q@kafai-mbp.dhcp.thefacebook.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <d5d8091d-e02e-3903-6203-c136b8d70c09@fb.com>
Date:   Wed, 30 Sep 2020 15:50:10 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.0
In-Reply-To: <20200930205847.7pj5pblqe6k6v64q@kafai-mbp.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2620:10d:c090:400::5:a1b9]
X-ClientProxiedBy: CO2PR04CA0202.namprd04.prod.outlook.com
 (2603:10b6:104:5::32) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21c1::1992] (2620:10d:c090:400::5:a1b9) by CO2PR04CA0202.namprd04.prod.outlook.com (2603:10b6:104:5::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.20 via Frontend Transport; Wed, 30 Sep 2020 22:50:12 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6b7229f0-8ce4-45a7-1f59-08d86593313c
X-MS-TrafficTypeDiagnostic: BYAPR15MB3189:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB3189B557DD4422BA21C04830D3330@BYAPR15MB3189.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qaZpfVd7fct+7WgaB/saMPO914+XHSKXIF1ga/VShAPRxDmvtdaQ925CvOQ4nUlK//4GM9pGdlPGi1Nj5JYl0GTUcSxOP52+tFKXPCj5+IHMpyPMsTQqBo/S3aZI/q9RjzzLwlOZEXEdp4N5O8r5n95gDBDHRUwbi4LJ1PuWLPkfYfL1//+tOOaNje0Cfhnnzw+9aVDuMjWJSK/7w22uGYn+yT6t7Gubmb5P4ByZMjWIJ9KOW1KTGMnmE/CY16dpLqlIc2ZLfnabETLKNaNETEMdsUV7UFtuG9vI6Q6LrGQEcxrJIIJ9N9qJ9XyGslTRbzhb+fsqazU4QYiufyypk5jp3Um4d+I67VX5iFvSZLtW/NVypnYybCJUcZ/spAQxcNd8YMxIxSEoo9yXuGky0ASIcJDeXYBu9oaKdsIt1NHUSKpuJ/C3OuCvLg8PznQPKaz8M9S/cIUfnLE3r+AGSA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(39860400002)(366004)(346002)(376002)(136003)(83380400001)(53546011)(86362001)(478600001)(37006003)(52116002)(186003)(54906003)(31696002)(16526019)(36756003)(4326008)(8676002)(6636002)(6862004)(2906002)(8936002)(316002)(66946007)(5660300002)(66476007)(31686004)(66556008)(6486002)(2616005)(21314003)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: 4d6/cevjXOyaUFXfH67qTFnIJDbgn+NCWtW59bqGv0W7GtIIqQUiQWr9KG5sz6DyMs5SPPzh3S41n23mO2tDZL2O2Wf0DhWh80IqsXmw2c8f50xcXaDRMp5ucfjkJbCehM26WEYF8/lO5usfLuyY+yYb0sXl+x8xVUJwaSlMLIGu39udNG2AXeKxwPRXMfL42qdho4CX88UyUs7RsHofeyk3eey/uTxM1PMejfiElrLeYMNzK7nkKxYH5oO8EPcZ0Q9dD8MzBa/FTQlO+k7sJjLHHdRimD+vCRHqRvmOw2s9nnjDyfp8fOkZvZla/S/m9xuWul4F6WcdUqSFnEI2OoCEWqQqHeM41Uo7l3z9iwiKQzaBm7TiInbqR4KUVkmfHIouMI1YBMnlhlEFzAd8u6ImhwrMFA39qwkf7MC3aBG4h6gm3Rx/XkT80DrWAcAYLTVn/HmuKShcR1KYvrD9vBOoq+laliVsuZ5QIV9nLdH+GOraTo1F1Bh0DJ+rIM9uXeHzmiNLkUVcmenC++IORVMjJe8WoaB+2/6y7kQO//N0XSpqifvce0ybIBRr2yDj38+YTxrafz8ovP4ZK6+MmdKPKTn0HQsRGKGwDxVmmtBgNq4ISnc+3s4Cb4/wo20AapZmyQTmEuJJwzGF6fZ8KzE7iaMHXXYX0ht2JlaGsxM=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b7229f0-8ce4-45a7-1f59-08d86593313c
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2020 22:50:13.8473
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tqASSfBlpOqJl4aO098kZa5zCyV0v1J0EgcDYW1JN7LVWiUq3+n8RiAjFWNT5vZ5
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3189
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-30_13:2020-09-30,2020-09-30 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0 bulkscore=0
 lowpriorityscore=0 suspectscore=0 impostorscore=0 phishscore=0
 adultscore=0 priorityscore=1501 malwarescore=0 mlxlogscore=999 mlxscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009300184
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/30/20 1:58 PM, Martin KaFai Lau wrote:
> On Wed, Sep 30, 2020 at 09:41:09AM -0700, Yonghong Song wrote:
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
>> @@ -102,24 +102,36 @@ asm(							\
>>    * skc_to_*_sock() helpers. All these sockets should have
>>    * sock_common as the first argument in its memory layout.
>>    */
>> -#define BTF_SOCK_TYPE_xxx \
>> +
>> +#define __BTF_SOCK_TYPE_xxx \
>>   	BTF_SOCK_TYPE(BTF_SOCK_TYPE_INET, inet_sock)			\
>>   	BTF_SOCK_TYPE(BTF_SOCK_TYPE_INET_CONN, inet_connection_sock)	\
>>   	BTF_SOCK_TYPE(BTF_SOCK_TYPE_INET_REQ, inet_request_sock)	\
>> -	BTF_SOCK_TYPE(BTF_SOCK_TYPE_INET_TW, inet_timewait_sock)	\
>>   	BTF_SOCK_TYPE(BTF_SOCK_TYPE_REQ, request_sock)			\
>>   	BTF_SOCK_TYPE(BTF_SOCK_TYPE_SOCK, sock)				\
>>   	BTF_SOCK_TYPE(BTF_SOCK_TYPE_SOCK_COMMON, sock_common)		\
>>   	BTF_SOCK_TYPE(BTF_SOCK_TYPE_TCP, tcp_sock)			\
>>   	BTF_SOCK_TYPE(BTF_SOCK_TYPE_TCP_REQ, tcp_request_sock)		\
>> -	BTF_SOCK_TYPE(BTF_SOCK_TYPE_TCP_TW, tcp_timewait_sock)		\
>>   	BTF_SOCK_TYPE(BTF_SOCK_TYPE_TCP6, tcp6_sock)			\
>>   	BTF_SOCK_TYPE(BTF_SOCK_TYPE_UDP, udp_sock)			\
>>   	BTF_SOCK_TYPE(BTF_SOCK_TYPE_UDP6, udp6_sock)
>>   
>> +#define __BTF_SOCK_TW_TYPE_xxx \
>> +	BTF_SOCK_TYPE(BTF_SOCK_TYPE_INET_TW, inet_timewait_sock)	\
>> +	BTF_SOCK_TYPE(BTF_SOCK_TYPE_TCP_TW, tcp_timewait_sock)
>> +
>> +#ifdef CONFIG_INET
>> +#define BTF_SOCK_TYPE_xxx						\
>> +	__BTF_SOCK_TYPE_xxx						\
>> +	__BTF_SOCK_TW_TYPE_xxx
>> +#else
>> +#define BTF_SOCK_TYPE_xxx	__BTF_SOCK_TYPE_xxx
> BTF_SOCK_TYPE_xxx is used in BTF_ID_LIST_GLOBAL(btf_sock_ids) in filter.c
> which does not include BTF_SOCK_TYPE_TCP_TW.
> However, btf_sock_ids[BTF_SOCK_TYPE_TCP_TW] is still used
> in bpf_skc_to_tcp_timewait_sock_proto.
> 
>> +#endif
>> +
>>   enum {
>>   #define BTF_SOCK_TYPE(name, str) name,
>> -BTF_SOCK_TYPE_xxx
>> +__BTF_SOCK_TYPE_xxx
>> +__BTF_SOCK_TW_TYPE_xxx
> BTF_SOCK_TYPE_TCP_TW is at the end of this enum.
> 
> Would btf_sock_ids[BTF_SOCK_TYPE_TCP_TW] always be 0?

No. If CONFIG_INET is y, the above BTF_SOCK_TYPE_xxx contains
   __BTF_SOCK_TW_TYPE_xxx
and
   btf_sock_ids[BTF_SOCK_TYPE_TCP_TW] will be calculated properly.

But if CONFIG_INET is n, then BTF_SOCK_TYPE_xxx will not contain
    __BTF_SOCK_TW_TYPE_xxx
so btf_sock_ids[BTF_SOCK_TYPE_TCP_TW] will have default value 0
as btf_sock_ids is a global.

Will send v2 to add some comments to make it easy to understand.

> 
>>   #undef BTF_SOCK_TYPE
>>   MAX_BTF_SOCK_TYPE,
>>   };
>> -- 
>> 2.24.1
>>

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB9731D4234
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 02:41:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728400AbgEOAlE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 20:41:04 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:58286 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727116AbgEOAlD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 May 2020 20:41:03 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 04F0Wfdb031442;
        Thu, 14 May 2020 17:40:40 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=Zxn016M+5r2ZSv57GF8hIyjOTRxNxjLHSNF+F12zGSM=;
 b=egVYkxRQMmDT0Bmrhidef0L8EOUCI1s3ogAXBkVqfVXUdgd2uuqvSBk68CF3fHkdQX6A
 4LK+i1LNE3Tr/bEZm9KvCDKixNNggs5Bw1XUCtgTNvsUUcOFgnZAu+ftGHODDVc3HRfc
 D9gkyFgQ/wHhVWYL78z/GGb0FeCQns1FyII= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net with ESMTP id 310kwt18ap-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 14 May 2020 17:40:39 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.175) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Thu, 14 May 2020 17:40:38 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oFyuLgzmAlWS9WMlwTedL5T7bo6tDRkNc3yWTfbTZeczsiXOvauR6tKpPduNwa5IG9/esGsxqiGtZ82prYZ0WlaMt9Ys0Hcnw6w2QI6oKDLx+QhfookNPsR3MxIaE4Ef3FH15+m2QOMmpN1U5+mREfbzr7r9feA5pENmUCgvyCttKPvq6mQK8FfovysLaDZ2Sua4lKWRrzoKnaB0J6e61514rmh0Td7wTR5I+rDzfW2fsAnDEmUaBHASW2vdH4zZlyliBUpxfYA4uMDSxZtJbtoDFFBveVCLxMA9iMmJxWQ7xge0o128b5UlZW+WNlz7azk3Nh9ITaMT8q6BuvnfEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zxn016M+5r2ZSv57GF8hIyjOTRxNxjLHSNF+F12zGSM=;
 b=M3xG79CC7/WxvJPKPblznC/P8d6ZuKBEiqqQGgtlR+edzlo7tVWNJIcszAqV/+wDg2I1sa/+Jr3Q2iT/EQY/ARBwcZiBcNZmDsEhV3kKK3eB726oZUGW41Y2FtxlzPOYDVx/cms5w1um5sOAlnl1m5NTMWzvmbaAyD0M0aviIewzNybB+KJXP7/NZRbOhDcQwMMwZNVhSP5Dh1WW9XIo1o0UXFOwlFn/9M327XVb18mS+CpbmXAnIbqimS9o/F+JFXoiHk4juE/8ErLEhIfA5bKg/dkiN+1Rfe19yG6G+ymNlWoy3wvOjfqW19fHlNBkgSMXXuf51O0iZlv5ghFtVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zxn016M+5r2ZSv57GF8hIyjOTRxNxjLHSNF+F12zGSM=;
 b=ZmMSV54kxQfjjp1Fo851/yQ5CjrLccsBmJA3FHpvY0F2+PbEy8pSmALJd4GYgu8/0D5btaqIN3ECHAVyhMiRkjPuQP1mfZQxwUStP2azIA+PgSBZ3Ew0yl7S4rOpN1fVbg3Xp0fOzwzdL4yEckxi4prab1/jJTewmVINzlRC6Tc=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB2453.namprd15.prod.outlook.com (2603:10b6:a02:8d::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.33; Fri, 15 May
 2020 00:40:35 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::4922:9927:5d6c:5301]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::4922:9927:5d6c:5301%7]) with mapi id 15.20.3000.022; Fri, 15 May 2020
 00:40:35 +0000
Subject: Re: [PATCH v2 bpf-next 4/7] printk: add type-printing %pT format
 specifier which uses BTF
To:     Alan Maguire <alan.maguire@oracle.com>
CC:     <ast@kernel.org>, <daniel@iogearbox.net>, <bpf@vger.kernel.org>,
        <joe@perches.com>, <linux@rasmusvillemoes.dk>,
        <arnaldo.melo@gmail.com>, <kafai@fb.com>, <songliubraving@fb.com>,
        <andriin@fb.com>, <john.fastabend@gmail.com>,
        <kpsingh@chromium.org>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>
References: <1589263005-7887-1-git-send-email-alan.maguire@oracle.com>
 <1589263005-7887-5-git-send-email-alan.maguire@oracle.com>
 <51ac81f5-3d74-e394-3183-5d8366e2ddcc@fb.com>
 <alpine.LRH.2.21.2005142330430.24127@localhost>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <f067bbb7-ef0b-4809-3fa8-1666d03bcf5f@fb.com>
Date:   Thu, 14 May 2020 17:39:55 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.0
In-Reply-To: <alpine.LRH.2.21.2005142330430.24127@localhost>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR01CA0036.prod.exchangelabs.com (2603:10b6:a02:80::49)
 To BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dasneha-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:1b64) by BYAPR01CA0036.prod.exchangelabs.com (2603:10b6:a02:80::49) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.25 via Frontend Transport; Fri, 15 May 2020 00:40:33 +0000
X-Originating-IP: [2620:10d:c090:400::5:1b64]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d7876a54-35a5-4986-2b13-08d7f8689477
X-MS-TrafficTypeDiagnostic: BYAPR15MB2453:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB24536FBB180FAADAE1D5F788D3BD0@BYAPR15MB2453.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-Forefront-PRVS: 04041A2886
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KUhvVAgCUKZWszX2r+QWo0KqcC0r+6BzxCKxL5NEEKVoqus+r4NDLWMHFD4oDWLzJcQgfVjb9666yPY7TfWwVHhRxRjeGmNe2HXO0WAh74ALeFFLNEv2GReSCX/POsmNGUaXyg9W1zjq9mGw6U4ZWjiSqiAar4rXDjfGt8kngeqErqQokjqH0qIhyW8ctmSAENVICMvjoxMQW5qkDYUgEAuvWtP0Krz74Zj2H7qYtSTlpd3eZn2IAlSXO+BEN9PvbP0sYuxi9ZeijxAJrww3FH8/HjVhkso1MYegHHQ1+g7JEOZBBT8RMx0l19w1arUECVqDS9lJWah79NUj6miGEBOOChsl/UUfJAOyeUGKBw10c0c5u95GAYGGaqDhH/L1HgOA+DthOpCGWTZkGCJ476eh6AkXiYp2j0a4KQVCg6addRc2Z9EpbqGHpPSecfKcrCQlnIAhA8r2rymipJVVs3nSwVwNeOg+a1jPjEKyfgXM0aBZmtV36eSJJWRsmy4Z
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(136003)(396003)(376002)(366004)(39860400002)(346002)(186003)(31686004)(66946007)(36756003)(66476007)(4326008)(66556008)(16526019)(6512007)(8676002)(6666004)(8936002)(6916009)(316002)(2616005)(53546011)(52116002)(6506007)(6486002)(2906002)(7416002)(5660300002)(86362001)(31696002)(478600001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: aDFC0dNHGJQKgrJ4HTrCaR0NBazf6ROGKTT3IpMznJrqYhrshtYYZYvhohvFj6uNG3/jJVoddtwQyR3uJ2fxz8KksguB1wuUPWEhMZnTlhHyX7lm4/zG/UUpEPhwVl0w0vOIeu7lr757Ylpu0RvdVAOPydyjiqIB0ioIlCVKNbBfQmRDNWe+QOzOJnpQEL+kWN9Fnmp40X//iiUE0jZOA6ZrTcUvKTXsJ4l5EVs+Amr74FAcp1q3M4lxBTbQCZqJfq/yvwJR+Y3uJywm1oDWIIIxRiYyMHJmR+Ck9UZDzBpyj1K1B+hLe/o8jzwwuS8DOWatKmx+aE50UI/AnYbE+gX88LPP7om6My3HZzWAWLT3ys+BP+vbXobns7zRGNbMzsCB5cebK/+LEx+Dzbci+jeWOm3lE5Y2AZTgi5TIG87mu7WR1F+LWfF2iEBFrj4+32RmSK7RtUFm9JgNnas8rVo+r6/IyUwPepbCH3wn8PbN2Ljcxy6GvGsiJVV9S/eD/12zPgSDYVMgF0nutyLzPQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: d7876a54-35a5-4986-2b13-08d7f8689477
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 May 2020 00:40:35.0797
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Fb1GtQQRNdU5fmteuMRaSYp5AvXcOu/3XJLsyhoko0OyV2lhEQTY7iIv6qgWOUzr
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2453
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-14_08:2020-05-14,2020-05-14 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0
 malwarescore=0 impostorscore=0 suspectscore=0 cotscore=-2147483648
 priorityscore=1501 spamscore=0 adultscore=0 mlxscore=0 phishscore=0
 mlxlogscore=999 lowpriorityscore=0 clxscore=1015 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005150003
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/14/20 3:37 PM, Alan Maguire wrote:
> 
> 
> On Wed, 13 May 2020, Yonghong Song wrote:
> 
>>
>>
>> On 5/11/20 10:56 PM, Alan Maguire wrote:
>>> printk supports multiple pointer object type specifiers (printing
>>> netdev features etc).  Extend this support using BTF to cover
>>> arbitrary types.  "%pT" specifies the typed format, and the pointer
>>> argument is a "struct btf_ptr *" where struct btf_ptr is as follows:
>>>
>>> struct btf_ptr {
>>>   void *ptr;
>>>   const char *type;
>>>   u32 id;
>>> };
>>>
>>> Either the "type" string ("struct sk_buff") or the BTF "id" can be
>>> used to identify the type to use in displaying the associated "ptr"
>>> value.  A convenience function to create and point at the struct
>>> is provided:
>>>
>>>   printk(KERN_INFO "%pT", BTF_PTR_TYPE(skb, struct sk_buff));
>>>
>>> When invoked, BTF information is used to traverse the sk_buff *
>>> and display it.  Support is present for structs, unions, enums,
>>> typedefs and core types (though in the latter case there's not
>>> much value in using this feature of course).
>>>
>>> Default output is indented, but compact output can be specified
>>> via the 'c' option.  Type names/member values can be suppressed
>>> using the 'N' option.  Zero values are not displayed by default
>>> but can be using the '0' option.  Pointer values are obfuscated
>>> unless the 'x' option is specified.  As an example:
>>>
>>>     struct sk_buff *skb = alloc_skb(64, GFP_KERNEL);
>>>     pr_info("%pT", BTF_PTR_TYPE(skb, struct sk_buff));
>>>
>>> ...gives us:
>>>
>>> (struct sk_buff){
>>>    .transport_header = (__u16)65535,
>>>    .mac_header = (__u16)65535,
>>>    .end = (sk_buff_data_t)192,
>>>    .head = (unsigned char *)000000006b71155a,
>>>    .data = (unsigned char *)000000006b71155a,
>>>    .truesize = (unsigned int)768,
>>>    .users = (refcount_t){
>>>     .refs = (atomic_t){
>>>     .counter = (int)1,
>>>    },
>>>    },
>>>    .extensions = (struct skb_ext *)00000000f486a130,
>>> }
>>>
>>> printk output is truncated at 1024 bytes.  For cases where overflow
>>> is likely, the compact/no type names display modes may be used.
>>>
>>> Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
>>> ---
>>>    Documentation/core-api/printk-formats.rst |  15 ++++
>>>    include/linux/btf.h                       |   3 +-
>>>    include/linux/printk.h                    |  16 +++++
>>>    lib/Kconfig                               |  16 +++++
>>>    lib/vsprintf.c                            | 113
>>>    ++++++++++++++++++++++++++++++
>>>    5 files changed, 162 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/Documentation/core-api/printk-formats.rst
>>> b/Documentation/core-api/printk-formats.rst
>>> index 8ebe46b1..5c66097 100644
>>> --- a/Documentation/core-api/printk-formats.rst
>>> +++ b/Documentation/core-api/printk-formats.rst
>>> @@ -545,6 +545,21 @@ For printing netdev_features_t.
>>>    
>>>    Passed by reference.
>>>    
>>> +BTF-based printing of pointer data
>>> +----------------------------------
>>> +If '%pT' is specified, use the struct btf_ptr * along with kernel vmlinux
>>> +BPF Type Format (BTF) to show the typed data.  For example, specifying
>>> +
>>> +	printk(KERN_INFO "%pT", BTF_PTR_TYPE(skb, struct_sk_buff));
>>> +
>>> +will utilize BTF information to traverse the struct sk_buff * and display
>>> it.
>>> +
>>> +Supported modifers are
>>> + 'c' compact output (no indentation, newlines etc)
>>> + 'N' do not show type names
>>> + 'x' show raw pointers (no obfuscation)
>>> + '0' show zero-valued data (it is not shown by default)
>>> +
>>>    Thanks
>>>    ======
>>>    
>>> diff --git a/include/linux/btf.h b/include/linux/btf.h
>>> index d571125..7b585ab 100644
>>> --- a/include/linux/btf.h
>>> +++ b/include/linux/btf.h
>>> @@ -169,10 +169,11 @@ static inline const struct btf_member
>>> *btf_type_member(const struct btf_type *t)
>>>    	return (const struct btf_member *)(t + 1);
>>>    }
>>>    
>>> +struct btf *btf_parse_vmlinux(void);
>>> +
>>>    #ifdef CONFIG_BPF_SYSCALL
>>>    const struct btf_type *btf_type_by_id(const struct btf *btf, u32 type_id);
>>>    const char *btf_name_by_offset(const struct btf *btf, u32 offset);
>>> -struct btf *btf_parse_vmlinux(void);
>>>    struct btf *bpf_prog_get_target_btf(const struct bpf_prog *prog);
>>>    #else
>>>    static inline const struct btf_type *btf_type_by_id(const struct btf *btf,
>>> diff --git a/include/linux/printk.h b/include/linux/printk.h
>>> index fcde0772..3c3ea53 100644
>>> --- a/include/linux/printk.h
>>> +++ b/include/linux/printk.h
>>> @@ -528,4 +528,20 @@ static inline void print_hex_dump_debug(const char
>>> *prefix_str, int prefix_type,
>>>    #define print_hex_dump_bytes(prefix_str, prefix_type, buf, len)	\
>>>     print_hex_dump_debug(prefix_str, prefix_type, 16, 1, buf, len, true)
>>>    +/**
>>> + * struct btf_ptr is used for %pT (typed pointer) display; the
>>> + * additional type string/BTF id are used to render the pointer
>>> + * data as the appropriate type.
>>> + */
>>> +struct btf_ptr {
>>> +	void *ptr;
>>> +	const char *type;
>>> +	u32 id;
>>> +};
>>> +
>>> +#define	BTF_PTR_TYPE(ptrval, typeval) \
>>> +	(&((struct btf_ptr){.ptr = ptrval, .type = #typeval}))
>>> +
>>> +#define BTF_PTR_ID(ptrval, idval) \
>>> +	(&((struct btf_ptr){.ptr = ptrval, .id = idval}))
>>>    #endif
>> [...]
>>> diff --git a/lib/vsprintf.c b/lib/vsprintf.c
>>> index 7c488a1..f9276f8 100644
>>> --- a/lib/vsprintf.c
>>> +++ b/lib/vsprintf.c
>>> @@ -43,6 +43,7 @@
>>>    #ifdef CONFIG_BLOCK
>>>    #include <linux/blkdev.h>
>>>    #endif
>>> +#include <linux/btf.h>
>>>    
>>>    #include "../mm/internal.h"	/* For the trace_print_flags arrays */
>>>    
>>> @@ -2059,6 +2060,103 @@ char *fwnode_string(char *buf, char *end, struct
>>> fwnode_handle *fwnode,
>>>    	return widen_string(buf, buf - buf_start, end, spec);
>>>    }
>>>    
>>> +#if IS_ENABLED(CONFIG_BTF_PRINTF)
>>> +#define btf_modifier_flag(c)	(c == 'c' ? BTF_SHOW_COMPACT :	\
>>> +				 c == 'N' ? BTF_SHOW_NONAME :	\
>>> +				 c == 'x' ? BTF_SHOW_PTR_RAW :	\
>>> +				 c == '0' ? BTF_SHOW_ZERO : 0)
>>> +
>>> +static noinline_for_stack
>>> +char *btf_string(char *buf, char *end, void *ptr, struct printf_spec spec,
>>> +		 const char *fmt)
>>> +{
>>> +	struct btf_ptr *bp = (struct btf_ptr *)ptr;
>>> +	u8 btf_kind = BTF_KIND_TYPEDEF;
>>> +	const struct btf_type *t;
>>> +	const struct btf *btf;
>>> +	char *buf_start = buf;
>>> +	const char *btf_type;
>>> +	u64 flags = 0, mod;
>>> +	s32 btf_id;
>>> +
>>> +	if (check_pointer(&buf, end, ptr, spec))
>>> +		return buf;
>>> +
>>> +	if (check_pointer(&buf, end, bp->ptr, spec))
>>> +		return buf;
>>> +
>>> +	while (isalnum(*fmt)) {
>>> +		mod = btf_modifier_flag(*fmt);
>>> +		if (!mod)
>>> +			break;
>>> +		flags |= mod;
>>> +		fmt++;
>>> +	}
>>> +
>>> +	btf = bpf_get_btf_vmlinux();
>>> +	if (IS_ERR_OR_NULL(btf))
>>> +		return ptr_to_id(buf, end, bp->ptr, spec);
>>> +
>>> +	if (bp->type != NULL) {
>>> +		btf_type = bp->type;
>>> +
>>> +		if (strncmp(bp->type, "struct ", strlen("struct ")) == 0) {
>>> +			btf_kind = BTF_KIND_STRUCT;
>>> +			btf_type += strlen("struct ");
>>> +		} else if (strncmp(btf_type, "union ", strlen("union ")) == 0)
>>> {
>>> +			btf_kind = BTF_KIND_UNION;
>>> +			btf_type += strlen("union ");
>>> +		} else if (strncmp(btf_type, "enum ", strlen("enum ")) == 0) {
>>> +			btf_kind = BTF_KIND_ENUM;
>>> +			btf_type += strlen("enum ");
>>> +		}
>>
>> I think typedef should be supported here.
>> In kernel, we have some structure directly defined as typedef's.
>> A lot of internal int types also typedefs, like u32, atomic_t,
>> possible_net_t, etc.
>>
>> A type name without prefix "struct", "union", "enum" can be
>> treated as a typedef first.
>>
> 
> That's how the code works today; we start with a typedef assumption.
> See the comment below starting "Assume type specified is a typedef";
> we initialize btf_kind to be a typedef above; it's only changed
> to an BTF_KIND_INT if we find a struct/enum/union prefix or if lookup
> using the typedef kind fails. I should probably make this clearer
> though (move the comment up maybe?). Thanks for taking a look!

Thanks for explanation. I missed it. Move the comments up about what to 
support explicitly will be good.

> 
>> If the type name is not a typedef, it is then compared to a limited
>> number of C basic int types like "char", "unsigned char", "short",
>> "unsigned short", ...
>>
>>> +
>>> +		if (strlen(btf_type) == 0)
>>> +			return ptr_to_id(buf, end, bp->ptr, spec);
>>> +
>>> +		/*
>>> +		 * Assume type specified is a typedef as there's not much
>>> +		 * benefit in specifying int types other than wasting time
>>> +		 * on BTF lookups; we optimize for the most useful path.
>>> +		 *
>>> +		 * Fall back to BTF_KIND_INT if this fails.
>>> +		 */
>>> +		btf_id = btf_find_by_name_kind(btf, btf_type, btf_kind);
>>> +		if (btf_id < 0)
>>> +			btf_id = btf_find_by_name_kind(btf, btf_type,
>>> +						       BTF_KIND_INT);
>>> +	} else if (bp->id > 0)
>>> +		btf_id = bp->id;
>>> +	else
>>> +		return ptr_to_id(buf, end, bp->ptr, spec);
>>> +
>>> +	if (btf_id > 0)
>>> +		t = btf_type_by_id(btf, btf_id);
>>> +	if (btf_id <= 0 || !t)
>>> +		return ptr_to_id(buf, end, bp->ptr, spec);
>>> +
>>> +	buf += btf_type_snprintf_show(btf, btf_id, bp->ptr, buf,
>>> +				      end - buf_start, flags);
>>> +
>>> +	return widen_string(buf, buf - buf_start, end, spec);
>>> +}
[...]

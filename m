Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 083EE1D22AF
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 01:05:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732376AbgEMXEy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 19:04:54 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:52130 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731815AbgEMXEx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 19:04:53 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 04DN2SmW032436;
        Wed, 13 May 2020 16:04:31 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=ady+vDjUyQwPsebbPrYuGBqCHefEBa0ktB+7VIKu6as=;
 b=YaDjLzvyRhRZVhz+brrMn36fB5TjRWLnnrQ/pvm2V1xO9KRDoOF+9eHjSssDCtP9B1Gk
 Lhn4UaThOIs7UgLN6tNxh9xW/drcZ1BazSxXZdZzunCDstWvLrN9DqSDCuKpwXtIIxQF
 5p5sxyPVIFmnjktnwTBUVNRVe0/D+nn1lyc= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0001303.ppops.net with ESMTP id 310kwstb9n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 13 May 2020 16:04:31 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Wed, 13 May 2020 16:04:30 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cDTgQ0tXq9+k6q3ZzCZwpRmTvQUWLUccnsFv6ZOOMogk9FMV7rKhkHkHxSgM2yYO468CXLIB/Lc+y3xNqgTQNyL4ypXsb86S7BgbEVk9c3WfnhalF+dcc/m0ExErB0KJaXnvgsVVS/i/BD7r1Pm0eJ1KsayXbHkiqgUHDAlS4MusPK4nEshLcjRZ4f+oK/toCg6zd9MsQsd4SndTV4uV1sPeAtFwvJe737rm+bO4g7YAd0icJsDs9OrpT+htUlLRKpdEmhXRAMIDvvjZIf5YH2Dlw1qV4657hHrwlez/A3+jZVygozDb9M3CxGVv+uBxVp3kcMITwiN3y9iKCfHxhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ady+vDjUyQwPsebbPrYuGBqCHefEBa0ktB+7VIKu6as=;
 b=H6M8A49LLNNfACssO5BSPZei8zUWypss2UsCy8Dr0AOvdgjD1wbYVbC5TlsddaAP5fWncAfdbOxAN9dv4/CvRoq2l4ting6dR8Rt+X3CMpYWnhrYqRYFIw6/7Nn8iyDN3ZRukM09pwwjPb7TI9p4mQojJehVRWW7H/7OIoeg/HURz0gj8qIBz+bEYALVhATZGKFLcd4CwtPupP5ExqODExEEWJIvhxIsGIJBWA6Pt+RsL9BLnDCgMshZDBK/1C39Z7y0b3RmJpDI4XSNhuu3W9BbAs8Re8ttIj8VPGZeeFo4FN0FprzImRiM90Z3ayaaXaNt+LlgJPIS8au5uYrilw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ady+vDjUyQwPsebbPrYuGBqCHefEBa0ktB+7VIKu6as=;
 b=lI0xX70aNpQvOEu84n+cB0hPs7nQLDTc89EOIL5U97QirEoYGLGY2qOhuZWNNMEAWlpi8x7sVDz+TQWLzlgChSgXzQrW5jY6TUSNkbfhpi9A65w1t7vVGlJgChaFPZ/PFanki563KtzflEwQO/ikY+iKHS+2VAhLGWrXzDHgd6o=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB2647.namprd15.prod.outlook.com (2603:10b6:a03:153::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.34; Wed, 13 May
 2020 23:04:29 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::4922:9927:5d6c:5301]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::4922:9927:5d6c:5301%7]) with mapi id 15.20.2979.033; Wed, 13 May 2020
 23:04:29 +0000
Subject: Re: [PATCH v2 bpf-next 2/7] bpf: move to generic BTF show support,
 apply it to seq files/strings
To:     Alan Maguire <alan.maguire@oracle.com>, <ast@kernel.org>,
        <daniel@iogearbox.net>, <bpf@vger.kernel.org>
CC:     <joe@perches.com>, <linux@rasmusvillemoes.dk>,
        <arnaldo.melo@gmail.com>, <kafai@fb.com>, <songliubraving@fb.com>,
        <andriin@fb.com>, <john.fastabend@gmail.com>,
        <kpsingh@chromium.org>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>
References: <1589263005-7887-1-git-send-email-alan.maguire@oracle.com>
 <1589263005-7887-3-git-send-email-alan.maguire@oracle.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <2a2c5072-8cd2-610b-db2a-16589df90faf@fb.com>
Date:   Wed, 13 May 2020 16:04:26 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.0
In-Reply-To: <1589263005-7887-3-git-send-email-alan.maguire@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR13CA0021.namprd13.prod.outlook.com
 (2603:10b6:a03:180::34) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from macbook-pro-52.local.dhcp.thefacebook.com (2620:10d:c090:400::5:a724) by BY5PR13CA0021.namprd13.prod.outlook.com (2603:10b6:a03:180::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.12 via Frontend Transport; Wed, 13 May 2020 23:04:27 +0000
X-Originating-IP: [2620:10d:c090:400::5:a724]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 64668ffc-3800-45fb-568a-08d7f791fd56
X-MS-TrafficTypeDiagnostic: BYAPR15MB2647:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB2647FB1F33C5176028E131ABD3BF0@BYAPR15MB2647.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-Forefront-PRVS: 0402872DA1
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WOIQYFuiIzf/PnRbUjVFNN7MLH18AtRQbkSVquAUluC5JDjuUOaSNVkeVEVgLMWe43oXqibNlZqqrSLdv/8SuIlddxjBOQs/BXK8d1AuNcCFiflN3Pk87t+Mrz7qU8Gpr0hdtn1tkhru3G7e+m6/v2mzalyLKnJKxwgPMgI9vV9S7ce6CcKWFZOi461cJFWcnssao1YUgZN+TQ9paZuFLVDytxlUmWlY7lpXwAuYQJbzdOLYmINZLv9VPPgXRmE78iOEvft30ytaXQRbbrXe+cKjvX83Jng3CJbAK4F7MSZlbijSrki91oPAfevUu2eA7gm5EjJVuP6RU2sXzEE4fHzSy9aqovCptPmYPCJ/hch9qTe2Og61fzp+EW2EUD/iLiL0QV9KVE2/rKby6CtXq/9cWlv9KHgAyZAnhxdKTild4jAefGHkKUGALm4gunAljOiZ4FVMM/Acm4PKqmzv9m161IfVpn09Q4rQtyFujMsZgr3ks2H5BvzD1/JvaOKTc7Q4lKSjDgFiZupuPTJQxawcWEWUuiICD7dLoKiPuilc5qEm+6ifZ9+TZecT47y6gmtl50w2bsABB7QxT0HC3Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(346002)(366004)(396003)(376002)(136003)(39860400002)(33430700002)(66556008)(186003)(2906002)(316002)(31696002)(6486002)(53546011)(478600001)(86362001)(6512007)(8936002)(52116002)(33440700001)(16526019)(4326008)(31686004)(66946007)(6506007)(2616005)(5660300002)(30864003)(66476007)(7416002)(36756003)(8676002)(41533002)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: z+FlRnyGbC7KuKL11xk9kpAAJT6RvJL3AqWTirZqpeBP8n0ZR1TG45y82YyKhkGjhgQ0NqUuDmLsCAZtzD9c7YxPQ+ww7w1rgCASQOMiGo2eDV6yN9xutyH+tv7tfaZt9kRGy4GgTVdaqt0rWeAL/InTIzBZg+rq1Rx6sp+b8T9srn/5jwUjmISgZuwUR3BMOSiZMQbfF/zZjT8qVbU6mSuQ8LFo24a6pMwV6CoON/HzsTmJgE99Q80gsJcIObbWrCvcu9XyspQy1ibIJ3xTTvCLZd5iYQ+wKFHgCMOsjafF6Ap5Ta1DgLEH7byoGekfQ+QZz3GqkyULZhNVM8+v6CP2i0qTPDOMggRICcetTHWjxWFNm8tn1jFaHUM7G0V8KrmdhOLbnYv7y52TTmYSJylk4QsU/iYTLup/7Z/7LTvzNtpqYlDk44tRUo9Zrp58Lzj5mRE7KJapIkftjsU/L5F4Q+FyW+1OYNEFIWuxVg2FfTbjjzlLZO+4aZ/aaspZ2EqNFwZXmcFxuD9IiYeFYw==
X-MS-Exchange-CrossTenant-Network-Message-Id: 64668ffc-3800-45fb-568a-08d7f791fd56
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 May 2020 23:04:29.1815
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0yHrILYElhXcIgjGu/0rLUAODYX9OOKtyiSKUkPfNpcTzBNqC7gT6S+0wmyJXQjb
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2647
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-13_09:2020-05-13,2020-05-13 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0
 malwarescore=0 impostorscore=0 suspectscore=0 cotscore=-2147483648
 priorityscore=1501 spamscore=0 adultscore=0 mlxscore=0 phishscore=0
 mlxlogscore=999 lowpriorityscore=0 clxscore=1011 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005130198
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/11/20 10:56 PM, Alan Maguire wrote:
> generalize the "seq_show" seq file support in btf.c to support
> a generic show callback of which we support two instances; the
> current seq file show, and a show with snprintf() behaviour which
> instead writes the type data to a supplied string.
> 
> Both classes of show function call btf_type_show() with different
> targets; the seq file or the string to be written.  In the string
> case we need to track additional data - length left in string to write
> and length to return that we would have written (a la snprintf).
> 
> By default show will display type information, field members and
> their types and values etc, and the information is indented
> based upon structure depth.
> 
> Show however supports flags which modify its behaviour:
> 
> BTF_SHOW_COMPACT - suppress newline/indent.
> BTF_SHOW_NONAME - suppress show of type and member names.
> BTF_SHOW_PTR_RAW - do not obfuscate pointer values.
> BTF_SHOW_ZERO - show zeroed values (by default they are not shown).
> 
> Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
> ---
>   include/linux/btf.h |  33 +++
>   kernel/bpf/btf.c    | 759 +++++++++++++++++++++++++++++++++++++++++++++-------
>   2 files changed, 690 insertions(+), 102 deletions(-)
> 
> diff --git a/include/linux/btf.h b/include/linux/btf.h
> index 5c1ea99..d571125 100644
> --- a/include/linux/btf.h
> +++ b/include/linux/btf.h
> @@ -13,6 +13,7 @@
>   struct btf_member;
>   struct btf_type;
>   union bpf_attr;
> +struct btf_show;
>   
>   extern const struct file_operations btf_fops;
>   
> @@ -46,8 +47,40 @@ int btf_get_info_by_fd(const struct btf *btf,
>   const struct btf_type *btf_type_id_size(const struct btf *btf,
>   					u32 *type_id,
>   					u32 *ret_size);
> +
> +/*
> + * Options to control show behaviour.
> + *	- BTF_SHOW_COMPACT: no formatting around type information
> + *	- BTF_SHOW_NONAME: no struct/union member names/types
> + *	- BTF_SHOW_PTR_RAW: show raw (unobfuscated) pointer values;
> + *	  equivalent to %px.
> + *	- BTF_SHOW_ZERO: show zero-valued struct/union members; they
> + *	  are not displayed by default
> + */
> +#define BTF_SHOW_COMPACT	(1ULL << 0)
> +#define BTF_SHOW_NONAME		(1ULL << 1)
> +#define BTF_SHOW_PTR_RAW	(1ULL << 2)
> +#define BTF_SHOW_ZERO		(1ULL << 3)
> +
>   void btf_type_seq_show(const struct btf *btf, u32 type_id, void *obj,
>   		       struct seq_file *m);
> +
> +/*
> + * Copy len bytes of string representation of obj of BTF type_id into buf.
> + *
> + * @btf: struct btf object
> + * @type_id: type id of type obj points to
> + * @obj: pointer to typed data
> + * @buf: buffer to write to
> + * @len: maximum length to write to buf
> + * @flags: show options (see above)
> + *
> + * Return: length that would have been/was copied as per snprintf, or
> + *	   negative error.
> + */
> +int btf_type_snprintf_show(const struct btf *btf, u32 type_id, void *obj,
> +			   char *buf, int len, u64 flags);
> +
>   int btf_get_fd_by_id(u32 id);
>   u32 btf_id(const struct btf *btf);
>   bool btf_member_is_reg_int(const struct btf *btf, const struct btf_type *s,
> diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
> index dcd2331..edf6455 100644
> --- a/kernel/bpf/btf.c
> +++ b/kernel/bpf/btf.c
> @@ -281,6 +281,32 @@ static const char *btf_type_str(const struct btf_type *t)
>   	return btf_kind_str[BTF_INFO_KIND(t->info)];
>   }
>   
> +/*
> + * Common data to all BTF show operations. Private show functions can add
> + * their own data to a structure containing a struct btf_show and consult it
> + * in the show callback.  See btf_type_show() below.
> + */
> +struct btf_show {
> +	u64 flags;
> +	void *target;	/* target of show operation (seq file, buffer) */
> +	void (*showfn)(struct btf_show *show, const char *fmt, ...);
> +	const struct btf *btf;
> +	/* below are used during iteration */
> +	struct {
> +		u8 depth;
> +		u8 depth_shown;
> +		u8 depth_check;

I have some difficulties to understand the relationship between
the above three variables. Could you add some comments here?

> +		u8 array_member:1,
> +		   array_terminated:1;
> +		u16 array_encoding;
> +		u32 type_id;
> +		const struct btf_type *type;
> +		const struct btf_member *member;
> +		char name[KSYM_NAME_LEN];	/* scratch space for name */
> +		char type_name[KSYM_NAME_LEN];	/* scratch space for type */

KSYM_NAME_LEN is for symbol name, not for type name. But I guess in 
kernel we probably do not have > 128 bytes type name so we should be
okay here.

> +	} state;
> +};
> +
>   struct btf_kind_operations {
>   	s32 (*check_meta)(struct btf_verifier_env *env,
>   			  const struct btf_type *t,
> @@ -297,9 +323,9 @@ struct btf_kind_operations {
>   				  const struct btf_type *member_type);
>   	void (*log_details)(struct btf_verifier_env *env,
>   			    const struct btf_type *t);
> -	void (*seq_show)(const struct btf *btf, const struct btf_type *t,
> +	void (*show)(const struct btf *btf, const struct btf_type *t,
>   			 u32 type_id, void *data, u8 bits_offsets,
> -			 struct seq_file *m);
> +			 struct btf_show *show);
>   };
>   
>   static const struct btf_kind_operations * const kind_ops[NR_BTF_KINDS];
> @@ -676,6 +702,340 @@ bool btf_member_is_reg_int(const struct btf *btf, const struct btf_type *s,
>   	return true;
>   }
>   
> +/* Similar to btf_type_skip_modifiers() but does not skip typedefs. */
> +static inline
> +const struct btf_type *btf_type_skip_qualifiers(const struct btf *btf, u32 id)
> +{
> +	const struct btf_type *t = btf_type_by_id(btf, id);
> +
> +	while (btf_type_is_modifier(t) &&
> +	       BTF_INFO_KIND(t->info) != BTF_KIND_TYPEDEF) {
> +		id = t->type;
> +		t = btf_type_by_id(btf, t->type);
> +	}
> +
> +	return t;
> +}
> +
> +#define BTF_SHOW_MAX_ITER	10
> +
> +#define BTF_KIND_BIT(kind)	(1ULL << kind)
> +
> +static inline const char *btf_show_type_name(struct btf_show *show,
> +					     const struct btf_type *t)
> +{
> +	const char *array_suffixes = "[][][][][][][][][][]";

Add a comment here saying length BTF_SHOW_MAX_ITER * 2
so later on if somebody changes the BTF_SHOW_MAX_ITER from 10 to 12,
it won't miss here?

> +	const char *array_suffix = &array_suffixes[strlen(array_suffixes)];
> +	const char *ptr_suffixes = "**********";

The same here.

> +	const char *ptr_suffix = &ptr_suffixes[strlen(ptr_suffixes)];
> +	const char *type_name = NULL, *prefix = "", *parens = "";
> +	const struct btf_array *array;
> +	u32 id = show->state.type_id;
> +	bool allow_anon = true;
> +	u64 kinds = 0;
> +	int i;
> +
> +	show->state.type_name[0] = '\0';
> +
> +	/*
> +	 * Start with type_id, as we have have resolved the struct btf_type *
> +	 * via btf_modifier_show() past the parent typedef to the child
> +	 * struct, int etc it is defined as.  In such cases, the type_id
> +	 * still represents the starting type while the the struct btf_type *
> +	 * in our show->state points at the resolved type of the typedef.
> +	 */
> +	t = btf_type_by_id(show->btf, id);
> +	if (!t)
> +		return show->state.type_name;
> +
> +	/*
> +	 * The goal here is to build up the right number of pointer and
> +	 * array suffixes while ensuring the type name for a typedef
> +	 * is represented.  Along the way we accumulate a list of
> +	 * BTF kinds we have encountered, since these will inform later
> +	 * display; for example, pointer types will not require an
> +	 * opening "{" for struct, we will just display the pointer value.
> +	 *
> +	 * We also want to accumulate the right number of pointer or array
> +	 * indices in the format string while iterating until we get to
> +	 * the typedef/pointee/array member target type.
> +	 *
> +	 * We start by pointing at the end of pointer and array suffix
> +	 * strings; as we accumulate pointers and arrays we move the pointer
> +	 * or array string backwards so it will show the expected number of
> +	 * '*' or '[]' for the type.  BTF_SHOW_MAX_ITER of nesting of pointers
> +	 * and/or arrays and typedefs are supported as a precaution.
> +	 *
> +	 * We also want to get typedef name while proceeding to resolve
> +	 * type it points to so that we can add parentheses if it is a
> +	 * "typedef struct" etc.
> +	 */
> +	for (i = 0; i < BTF_SHOW_MAX_ITER; i++) {
> +
> +		switch (BTF_INFO_KIND(t->info)) {
> +		case BTF_KIND_TYPEDEF:
> +			if (!type_name)
> +				type_name = btf_name_by_offset(show->btf,
> +							       t->name_off);
> +			kinds |= BTF_KIND_BIT(BTF_KIND_TYPEDEF);
> +			id = t->type;
> +			break;
> +		case BTF_KIND_ARRAY:
> +			kinds |= BTF_KIND_BIT(BTF_KIND_ARRAY);
> +			parens = "[";
> +			array = btf_type_array(t);
> +			if (!array)
> +				return show->state.type_name;
> +			if (!t)
> +				return show->state.type_name;
> +			if (array_suffix > array_suffixes)
> +				array_suffix -= 2;
> +			id = array->type;
> +			break;
> +		case BTF_KIND_PTR:
> +			kinds |= BTF_KIND_BIT(BTF_KIND_PTR);
> +			if (ptr_suffix > ptr_suffixes)
> +				ptr_suffix -= 1;
> +			id = t->type;
> +			break;
> +		default:
> +			id = 0;
> +			break;
> +		}
> +		if (!id)
> +			break;
> +		t = btf_type_skip_qualifiers(show->btf, id);
> +		if (!t)
> +			return show->state.type_name;
> +	}

Do we do pointer tracing here? For example
struct t {
	int *m[5];
}

When trying to access memory, the above code may go through
ptr->array and out of loop when hitting array element type "int"?

> +	/* We may not be able to represent this type; bail to be safe */
> +	if (i == BTF_SHOW_MAX_ITER)
> +		return show->state.type_name;
> +
> +	if (!type_name)
> +		type_name = btf_name_by_offset(show->btf, t->name_off);
> +
> +	switch (BTF_INFO_KIND(t->info)) {
> +	case BTF_KIND_STRUCT:
> +	case BTF_KIND_UNION:
> +		prefix = BTF_INFO_KIND(t->info) == BTF_KIND_STRUCT ?
> +			 "struct" : "union";
> +		/* if it's an array of struct/union, parens is already set */
> +		if (!(kinds & (BTF_KIND_BIT(BTF_KIND_ARRAY))))
> +			parens = "{";
> +		break;
> +	case BTF_KIND_ENUM:
> +		prefix = "enum";
> +		break;
> +	default:
> +		allow_anon = false;
> +		break;
> +	}
> +
> +	/* pointer does not require parens */
> +	if (kinds & BTF_KIND_BIT(BTF_KIND_PTR))
> +		parens = "";
> +	/* typedef does not require struct/union/enum prefix */
> +	if (kinds & BTF_KIND_BIT(BTF_KIND_TYPEDEF))
> +		prefix = "";
> +
> +	if (!type_name || strlen(type_name) == 0) {
> +		if (allow_anon)
> +			type_name = "";
> +		else
> +			return show->state.type_name;
> +	}
> +
> +	/* Even if we don't want type name info, we want parentheses etc */
> +	if (show->flags & BTF_SHOW_NONAME)
> +		snprintf(show->state.type_name, sizeof(show->state.type_name),
> +			 "%s", parens);
> +	else
> +		snprintf(show->state.type_name, sizeof(show->state.type_name),
> +			 "(%s%s%s%s%s%s)%s",
> +			 prefix,
> +			 strlen(prefix) > 0 && strlen(type_name) > 0 ? " " : "",
> +			 type_name,
> +			 strlen(ptr_suffix) > 0 ? " " : "", ptr_suffix,
> +			 array_suffix, parens);
> +
> +	return show->state.type_name;
> +}
> +
> +static inline const char *btf_show_name(struct btf_show *show)
> +{
> +	const struct btf_type *t = show->state.type;
> +	const struct btf_member *m = show->state.member;
> +	const char *member = NULL;
> +	const char *type = "";
> +
> +	show->state.name[0] = '\0';
> +
> +	if ((!m && !t) || show->state.array_member)
> +		return show->state.name;
> +
> +	if (m)
> +		t = btf_type_skip_qualifiers(show->btf, m->type);
> +
> +	if (t) {
> +		type = btf_show_type_name(show, t);
> +		if (!type)
> +			return show->state.name;
> +	}
> +
> +	if (m && !(show->flags & BTF_SHOW_NONAME)) {
> +		member = btf_name_by_offset(show->btf, m->name_off);
> +		if (member && strlen(member) > 0) {
> +			snprintf(show->state.name, sizeof(show->state.name),
> +				 ".%s = %s", member, type);
> +			return show->state.name;
> +		}
> +	}
> +
> +	snprintf(show->state.name, sizeof(show->state.name), "%s", type);
> +
> +	return show->state.name;
> +}
> +
> +#define btf_show(show, ...)						      \
> +	do {								      \
> +		if (!show->state.depth_check)				      \

As I mentioned above, some comments will be good to understand here.

> +			show->showfn(show, __VA_ARGS__);		      \
> +	} while (0)
> +
> +static inline const char *__btf_show_indent(struct btf_show *show)
> +{
> +	const char *indents = "                                ";
> +	const char *indent = &indents[strlen(indents)];
> +
> +	if ((indent - show->state.depth) >= indents)
> +		return indent - show->state.depth;
> +	return indents;
> +}
> +
> +#define btf_show_indent(show)						       \
> +	((show->flags & BTF_SHOW_COMPACT) ? "" : __btf_show_indent(show))
> +
> +#define btf_show_newline(show)						       \
> +	((show->flags & BTF_SHOW_COMPACT) ? "" : "\n")
> +
> +#define btf_show_delim(show)						       \
> +	(show->state.depth == 0 ? "" :					       \
> +	 ((show->flags & BTF_SHOW_COMPACT) && show->state.type &&	       \
> +	  BTF_INFO_KIND(show->state.type->info) == BTF_KIND_UNION) ? "|" : ",")
> +
> +#define btf_show_type_value(show, fmt, value)				       \
> +	do {								       \
> +		if ((value) != 0 || (show->flags & BTF_SHOW_ZERO) ||	       \
> +		    show->state.depth == 0) {				       \
> +			btf_show(show, "%s%s" fmt "%s%s",		       \
> +				 btf_show_indent(show),			       \
> +				 btf_show_name(show),			       \
> +				 value, btf_show_delim(show),		       \
> +				 btf_show_newline(show));		       \
> +			if (show->state.depth > show->state.depth_shown)       \
> +				show->state.depth_shown = show->state.depth;   \
> +		}							       \
> +	} while (0)
> +
> +#define btf_show_type_values(show, fmt, ...)				       \
> +	do {								       \
> +		btf_show(show, "%s%s" fmt "%s%s", btf_show_indent(show),       \
> +			 btf_show_name(show),				       \
> +			 __VA_ARGS__, btf_show_delim(show),		       \
> +			 btf_show_newline(show));			       \
> +		if (show->state.depth > show->state.depth_shown)	       \
> +			show->state.depth_shown = show->state.depth;	       \
> +	} while (0)
> +
[...]
>   
>   static int btf_array_check_member(struct btf_verifier_env *env,
> @@ -2104,28 +2489,87 @@ static void btf_array_log(struct btf_verifier_env *env,
>   			 array->type, array->index_type, array->nelems);
>   }
>   
> -static void btf_array_seq_show(const struct btf *btf, const struct btf_type *t,
> -			       u32 type_id, void *data, u8 bits_offset,
> -			       struct seq_file *m)
> +static void __btf_array_show(const struct btf *btf, const struct btf_type *t,
> +			     u32 type_id, void *data, u8 bits_offset,
> +			     struct btf_show *show)
>   {
>   	const struct btf_array *array = btf_type_array(t);
>   	const struct btf_kind_operations *elem_ops;
>   	const struct btf_type *elem_type;
> -	u32 i, elem_size, elem_type_id;
> +	u32 i, elem_size = 0, elem_type_id;
> +	u16 encoding = 0;
>   
>   	elem_type_id = array->type;
> -	elem_type = btf_type_id_size(btf, &elem_type_id, &elem_size);
> +	elem_type = btf_type_skip_modifiers(btf, elem_type_id, NULL);
> +	if (elem_type && btf_type_has_size(elem_type))
> +		elem_size = elem_type->size;
> +
> +	if (elem_type && btf_type_is_int(elem_type)) {
> +		u32 int_type = btf_type_int(elem_type);
> +
> +		encoding = BTF_INT_ENCODING(int_type);
> +
> +		/*
> +		 * BTF_INT_CHAR encoding never seems to be set for
> +		 * char arrays, so if size is 1 and element is
> +		 * printable as a char, we'll do that.
> +		 */
> +		if (elem_size == 1) > +			encoding = BTF_INT_CHAR;

Some char array may be printable and some may not be printable,
how did you differentiate this?

> +	}
> +
> +	btf_show_start_array_type(show, t, type_id, encoding);
> +
> +	if (!elem_type)
> +		goto out;
>   	elem_ops = btf_type_ops(elem_type);
> -	seq_puts(m, "[");
> +
>   	for (i = 0; i < array->nelems; i++) {
> -		if (i)
> -			seq_puts(m, ",");
>   
> -		elem_ops->seq_show(btf, elem_type, elem_type_id, data,
> -				   bits_offset, m);
> +		btf_show_start_array_member(show);
> +
> +		elem_ops->show(btf, elem_type, elem_type_id, data,
> +			       bits_offset, show);
>   		data += elem_size;
> +
> +		btf_show_end_array_member(show);
> +
> +		if (show->state.array_terminated)
> +			break;
>   	}
> -	seq_puts(m, "]");
> +out:
> +	btf_show_end_array_type(show);
> +}
> +
[...]

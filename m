Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5119A1D8FEF
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 08:21:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728407AbgESGVm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 02:21:42 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:45352 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726605AbgESGVk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 May 2020 02:21:40 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04J6KVFD005422;
        Mon, 18 May 2020 23:21:15 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=gnUaIA2yNBSB3XFJIpgac+csWhoBV2fdFY7XlSyIXMk=;
 b=adlZSfQizUkT4PU+TKVJDql55DLl02F+F5XgsbkThL8Amiy86rh82bpldZHYwbqUNhMM
 Pt37Z0t/pxuaI7zPqEGYv67gA88n9R0PmPA3BhvllcY34fUQnCLxUKfHEIe3Y9u76p0H
 UJlLXfossI5MeaJxQLfe0zZEIVIhpcqT0/c= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 31305rwj36-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 18 May 2020 23:21:15 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.196) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Mon, 18 May 2020 23:21:14 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mchqTTnAcnMaJ4GNW/iCgSifeX0KJgsB9zDtryU+jjqrk/Mte8bPLWJmsZvxEmv6F9jbCoeDCN9xhLvP8KD2uFDjXF3BZMJ/3Rx8F2sbbEN9BDQlchv5w3KOAndSPAnjHCJHGiSHw8qKg3wpynSXl+dn34sEimvnu7cuuL4s+OXM4QZkIQcyQuMaCXBrn9K8V459RHcOBNSywxNUcvZmniuDDMAspn+P+C7uydDnMp63wyHOM53F8tcM4XcoUcYBJAnN41LQCYzHAqTf5NsWpbNycGZ3z+XsXn9lQ7Sgy8+jA80oLDL5OlHNkTXS4eVshtpuaaIMMiuWcBxrtmz78g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gnUaIA2yNBSB3XFJIpgac+csWhoBV2fdFY7XlSyIXMk=;
 b=Ea7E33PeyjlkabdLOlFz3B7KegXjh++yUxyvWeCOiHa1U+zDDHBUkOpFtihpFXKI/V/10fhxm9N+WnPJaUQB4zgbcYJWE9TdDK0bDIfGhXByjBSEbWJPQcSGiqapMr68fku1+BG5nnBw9gigHq8Sdl9HCWFVEm5f1N7njcdIcg+Gko5W6FURZ+0eDMlWtMR5sCRnd79A4SfcW3US7ujG5djIlPenryUFEiAY0E4wLweNshdOSiOrnPyBYBoz6KjiZNcHlnhfKkJwZu5v2nBLl1MvV6ZWAx9ljGqT6ahsHiBHbLfG8wlcDhHyDfmoGbu17SsrQuxrSN3tUQsziQiUkw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gnUaIA2yNBSB3XFJIpgac+csWhoBV2fdFY7XlSyIXMk=;
 b=FMiOAaJuJyxv+NaEQu2i7IlE8VKE90ldSv7ZLN8DRKtBIhvZKnylKEBWv+Z5thWbRIlh8ag/o5C/ECoyif+gvsqBzKEcRoH0dVwTaA0XCC6SQ8HAlZ/UuRwolzGZziTOi1vGpSVbhyLDg07ZB1xCe5dBXtHVtMS7nK1t5tFVBjQ=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB2616.namprd15.prod.outlook.com (2603:10b6:a03:14d::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.27; Tue, 19 May
 2020 06:21:13 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::4922:9927:5d6c:5301]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::4922:9927:5d6c:5301%7]) with mapi id 15.20.3000.034; Tue, 19 May 2020
 06:21:13 +0000
Subject: Re: [PATCH v2 bpf-next 2/7] bpf: move to generic BTF show support,
 apply it to seq files/strings
To:     Alan Maguire <alan.maguire@oracle.com>
CC:     <ast@kernel.org>, <daniel@iogearbox.net>, <bpf@vger.kernel.org>,
        <joe@perches.com>, <linux@rasmusvillemoes.dk>,
        <arnaldo.melo@gmail.com>, <kafai@fb.com>, <songliubraving@fb.com>,
        <andriin@fb.com>, <john.fastabend@gmail.com>,
        <kpsingh@chromium.org>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>
References: <1589263005-7887-1-git-send-email-alan.maguire@oracle.com>
 <1589263005-7887-3-git-send-email-alan.maguire@oracle.com>
 <2a2c5072-8cd2-610b-db2a-16589df90faf@fb.com>
 <alpine.LRH.2.21.2005181012040.893@localhost>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <a8dc7739-2227-eebd-1ba5-6b56d6188888@fb.com>
Date:   Mon, 18 May 2020 23:21:10 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.0
In-Reply-To: <alpine.LRH.2.21.2005181012040.893@localhost>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR02CA0053.namprd02.prod.outlook.com
 (2603:10b6:a03:54::30) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from macbook-pro-52.local.dhcp.thefacebook.com (2620:10d:c090:400::5:1867) by BYAPR02CA0053.namprd02.prod.outlook.com (2603:10b6:a03:54::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.25 via Frontend Transport; Tue, 19 May 2020 06:21:12 +0000
X-Originating-IP: [2620:10d:c090:400::5:1867]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4fd4967f-fd34-499a-c0c0-08d7fbbcd448
X-MS-TrafficTypeDiagnostic: BYAPR15MB2616:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB2616E9E0563218473B75BCA2D3B90@BYAPR15MB2616.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 040866B734
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 93cKEVO2i/MELVaq+mQB3WOhg+uUdNpTehusQD70w5uowDgsLrj3qYKF4ZA9C4MbxyuexuPiO9MzjaOWDBL/3dgvDeo6bmYCc1wSyt3jjlP/1lKaf9WqPPYLL9X9rEMiPm5AWim6fjxsuM/g71DE/qLJdqO7W+zYCLASNthGxVdkWASX92+G1Dp0OegF14hO3uh4cHpgs0Y3BGR6h66CTmRigKtabvMR/Jh/nHsOWk0u8X0Rq7flbTEFnuj3oRBQR3viK+d4ve11gRaYI1q/EY/ceQLCzFKDxQ+O4hrZwK/OwoV52vKA/32z/p0rfoh0uQdCOaCyOWbGckS6APZPSjgBiX/kNgSkmKF4HfPTjPzuAJlBtQKQ74KBAlf6iQFNb0jzsdMHOK584+q5FOERDzgaXtjv7sUVuPCF8aEGgKP89KFAofClY+wNtYvST1dAfBs96I5Sp9vClbJPc6PCOMhIBDwnOH1c8bQnJDa+TInXt0BUXCUYdPwvlLGN5rHqgtO9/ShFUH/59o3Bn3fnGQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(376002)(136003)(346002)(366004)(396003)(39860400002)(6506007)(31696002)(53546011)(31686004)(186003)(16526019)(6916009)(6486002)(2616005)(4326008)(86362001)(478600001)(6512007)(2906002)(52116002)(316002)(36756003)(8936002)(66476007)(66556008)(5660300002)(8676002)(66946007)(7416002)(41533002)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: ywG5SQYl93daDpQYqCzD0l7kRLkgyApPE4yYwJ9H0cB3yuNUJ1Vjoy4Qpj5ROU9b5fmdwzcL0LC1Rtreb/UDfPBgnClfAFWkyRJzIZ2oOnGzRm8ITgBUqB7odyGjNfMrjAu2+eNvPWL+tRcSu5moCxcgM9xfG5P3vrmrH/52P1Dnp/Ju1MhtG91SZReiCu2dtm0nb308lblYfFUhe5WkXwcMCrnDXviJS8Mv+lTDM+J2P9c92rneISCoOWD1R2K0Xhjmy1u2nKVof18fnOcx8PHtA89PrCkcT74dWevUyy661ajVlOUVWBBrBt/GfpnwjoVxijLKCHtMrp4JKAh7We7OGaaoVD7DdJD8SAXR4EaAEyIKX8u5VtJ1mIcNh95GNAxjfETXQIDfUJ8TTOxDuhLVgOZnlFpE2Px3xAjvijaTIiPIl17swY7XROMnqB82K+hchZmZNkKLHmqnmUHNri/6xWaAgY4QBnX6Qlr9o6/69kwT4YGUrtl98ASgcxFU6cMpPufCHUOFTNmq2I+t5w==
X-MS-Exchange-CrossTenant-Network-Message-Id: 4fd4967f-fd34-499a-c0c0-08d7fbbcd448
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 May 2020 06:21:13.2124
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: S0lMNMNLz2uoNQMhofCm3J5Wg3+gfy0BCaNmNT+E/iMIzICdKVqP3JQnXe/D3yvV
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2616
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-19_01:2020-05-15,2020-05-19 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 bulkscore=0 impostorscore=0 spamscore=0 phishscore=0 malwarescore=0
 mlxlogscore=999 priorityscore=1501 adultscore=0 clxscore=1015
 cotscore=-2147483648 mlxscore=0 lowpriorityscore=0 classifier=spam
 adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005190056
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/18/20 2:46 AM, Alan Maguire wrote:
> On Wed, 13 May 2020, Yonghong Song wrote:
> 
>>
>>> +struct btf_show {
>>> +	u64 flags;
>>> +	void *target;	/* target of show operation (seq file, buffer) */
>>> +	void (*showfn)(struct btf_show *show, const char *fmt, ...);
>>> +	const struct btf *btf;
>>> +	/* below are used during iteration */
>>> +	struct {
>>> +		u8 depth;
>>> +		u8 depth_shown;
>>> +		u8 depth_check;
>>
>> I have some difficulties to understand the relationship between
>> the above three variables. Could you add some comments here?
>>
> 
> Will do; sorry the code got a bit confusing. The goal is to track
> which sub-components in a data structure we need to display.  The
> "depth" variable tracks where we are currently; "depth_shown"
> is the depth at which we have something nonzer to display (perhaps
> "depth_to_show" would be a better name?). "depth_check" tells

"depth_to_show" is indeed better.

> us whether we are currently checking depth or doing printing.
> If we're checking, we don't actually print anything, we merely note
> if we hit a non-zero value, and if so, we set "depth_shown"
> to the depth at which we hit that value.
> 
> When we show a struct, union or array, we will only display an
> object has one or more non-zero members.  But because
> the struct can in turn nest a struct or array etc, we need
> to recurse into the object.  When we are doing that, depth_check
> is set, and this tells us not to do any actual display. When
> that recursion is complete, we check if "depth_shown" (depth
> to show) is > depth (i.e. we found something) and if it is
> we go on to display the object (setting depth_check to 0).

Thanks for the explanation. Putting them in the comments
will be great.

> 
> There may be a better way to solve this problem of course,
> but I wanted to avoid storing values where possible as
> deeply-nested data structures might overrun such storage.
> 
[...]
>>> +
>>> +	/*
>>> +	 * The goal here is to build up the right number of pointer and
>>> +	 * array suffixes while ensuring the type name for a typedef
>>> +	 * is represented.  Along the way we accumulate a list of
>>> +	 * BTF kinds we have encountered, since these will inform later
>>> +	 * display; for example, pointer types will not require an
>>> +	 * opening "{" for struct, we will just display the pointer value.
>>> +	 *
>>> +	 * We also want to accumulate the right number of pointer or array
>>> +	 * indices in the format string while iterating until we get to
>>> +	 * the typedef/pointee/array member target type.
>>> +	 *
>>> +	 * We start by pointing at the end of pointer and array suffix
>>> +	 * strings; as we accumulate pointers and arrays we move the pointer
>>> +	 * or array string backwards so it will show the expected number of
>>> +	 * '*' or '[]' for the type.  BTF_SHOW_MAX_ITER of nesting of pointers
>>> +	 * and/or arrays and typedefs are supported as a precaution.
>>> +	 *
>>> +	 * We also want to get typedef name while proceeding to resolve
>>> +	 * type it points to so that we can add parentheses if it is a
>>> +	 * "typedef struct" etc.
>>> +	 */
>>> +	for (i = 0; i < BTF_SHOW_MAX_ITER; i++) {
>>> +
>>> +		switch (BTF_INFO_KIND(t->info)) {
>>> +		case BTF_KIND_TYPEDEF:
>>> +			if (!type_name)
>>> +				type_name = btf_name_by_offset(show->btf,
>>> +							       t->name_off);
type_name should never be NULL for valid vmlinux BTF.

>>> +			kinds |= BTF_KIND_BIT(BTF_KIND_TYPEDEF);
>>> +			id = t->type;
>>> +			break;
>>> +		case BTF_KIND_ARRAY:
>>> +			kinds |= BTF_KIND_BIT(BTF_KIND_ARRAY);
>>> +			parens = "[";
>>> +			array = btf_type_array(t);
>>> +			if (!array)
array will never be NULL here.
>>> +				return show->state.type_name;
>>> +			if (!t)
t will never be NULL here.
>>> +				return show->state.type_name;
>>> +			if (array_suffix > array_suffixes)
>>> +				array_suffix -= 2;
>>> +			id = array->type;
>>> +			break;
>>> +		case BTF_KIND_PTR:
>>> +			kinds |= BTF_KIND_BIT(BTF_KIND_PTR);
>>> +			if (ptr_suffix > ptr_suffixes)
>>> +				ptr_suffix -= 1;
>>> +			id = t->type;
>>> +			break;
>>> +		default:
>>> +			id = 0;
>>> +			break;
>>> +		}
>>> +		if (!id)
>>> +			break;
>>> +		t = btf_type_skip_qualifiers(show->btf, id);
t should never be NULL here.
>>> +		if (!t)
>>> +			return show->state.type_name;
>>> +	}
>>
>> Do we do pointer tracing here? For example
>> struct t {
>> 	int *m[5];
>> }
>>
>> When trying to access memory, the above code may go through
>> ptr->array and out of loop when hitting array element type "int"?
>>
> 
> I'm not totally sure I understand the question so I'll
> try and describe how the above is supposed to work. I
> think there's a bug here alright.
> 
> In the above case, when we reach the "m" field of "struct t",
> the code  should start with the BTF_KIND_ARRAY, set up
> the array suffix, then get the array type which is a PTR
> and we will set up the ptr suffix to be "*" and we set
> the id to the id associated with "int", and
> btf_type_skip_qualifiers() will use that id to look up
> the new value for the type used in btf_name_by_offset().
> So on the next iteration we hit the int itself and bail from
> the loop, having noted that we've got a _PTR and _ARRAY set in
> the "kinds" bitfield.
> 
> Then we look up the int type using "t" with btf_name_by_offset,
> so we end up displaying "(int *m[])" as the type.

Thanks for explanation. Previously I thought this somehow
may be related to tracing data. Looks it is only for
*constructing* type names. So it largely looks fine though.

>    
> However the code assumes we don't need the parentheses for
> the array if we have encountered a pointer; that's never
> the case.  We only should eliminate the opening parens
> for a struct or union "{" in such cases, as in those cases
> we have a pointer to the struct rather than a nested struct.
> So that needs to be fixed. Are the other problems here you're
> seeing that the above doesn't cover?

A few minor comments in the above.

> 
>>> +	/* We may not be able to represent this type; bail to be safe */
>>> +	if (i == BTF_SHOW_MAX_ITER)
>>> +		return show->state.type_name;
>>> +
>>> +	if (!type_name)
>>> +		type_name = btf_name_by_offset(show->btf, t->name_off);
>>> +
>>> +	switch (BTF_INFO_KIND(t->info)) {
>>> +	case BTF_KIND_STRUCT:
>>> +	case BTF_KIND_UNION:
>>> +		prefix = BTF_INFO_KIND(t->info) == BTF_KIND_STRUCT ?
>>> +			 "struct" : "union";
>>> +		/* if it's an array of struct/union, parens is already set */
>>> +		if (!(kinds & (BTF_KIND_BIT(BTF_KIND_ARRAY))))
>>> +			parens = "{";
>>> +		break;
>>> +	case BTF_KIND_ENUM:
>>> +		prefix = "enum";
>>> +		break;
>>> +	default:
>>> +		allow_anon = false;
[...]
>>> +	if (elem_type && btf_type_is_int(elem_type)) {
>>> +		u32 int_type = btf_type_int(elem_type);
>>> +
>>> +		encoding = BTF_INT_ENCODING(int_type);
>>> +
>>> +		/*
>>> +		 * BTF_INT_CHAR encoding never seems to be set for
>>> +		 * char arrays, so if size is 1 and element is
>>> +		 * printable as a char, we'll do that.
>>> +		 */
>>> +		if (elem_size == 1) > +			encoding =
>>> BTF_INT_CHAR;
>>
>> Some char array may be printable and some may not be printable,
>> how did you differentiate this?
>>
> 
> I should probably change the logic to ensure all chars
> (before a \0) are printable. I'll do that for v2. We will always
> have cases (e.g. the skb cb[] field) where the char[] is not
> intended as a string, but I think the utility of showing them as
> strings where possible is worthwhile.

Make sense. Thanks!

> 
> Thanks again for reviewing!
> 
> Alan
> 

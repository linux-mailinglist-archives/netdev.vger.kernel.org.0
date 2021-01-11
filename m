Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC0522F0BBC
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 05:14:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726519AbhAKEOP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Jan 2021 23:14:15 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:56744 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726029AbhAKEOO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Jan 2021 23:14:14 -0500
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 10B448Cx001087;
        Sun, 10 Jan 2021 20:13:18 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=vAbOYH6pyEINfALHnF5uC9looXBkfRQn2aZWhNV5YFA=;
 b=OlIU5YT1XdbiAD6X139H2wBfbDKaIPcEWdct3bIDjenaNyUGasJ0YUdn/NShRS4qR7sE
 y278voQWk5ffGx9M5cTuxS5F6fLQGMhyCKBISl/YBBihOr0r19kqBge/PBKYShQfVCMX
 a4J5TkFjtIS7htQ4GIEW/GZqqcXSHTSNFK0= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 35yweb2rp7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Sun, 10 Jan 2021 20:13:18 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.228) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Sun, 10 Jan 2021 20:13:18 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LWzQso3ZI6Ba0MSZwoo2LNJH5bzyQjBA3i8ZOYSYacex1UPRblVc2C8A6T/B8lNL6ZzJCMbaagg2tvvqcCBFVHP9PBFkSfb30xkMr3uO9ofXs/kOFQ4qxqmWAcU1mO6m2DqQnvAtWkbT9kcreli2oUG9Dcd5cEe4RswTDSazp2HM6u3Kt1QdhQ8Hgxs/867FObPd/Kag8nA5jsFjhFjiTUPyi7QfLyNKBxkUIS5RRynExGSRcVXqhRo46Pz/sDUx6wpU1jyXLa8TVOp6rnVOMH/PI/hBadXoyvS7fGrGOUNCSj9q1bEs2Iw1l50jlKzKD/qf+XpJnfk0+nkAUPM5Vw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vAbOYH6pyEINfALHnF5uC9looXBkfRQn2aZWhNV5YFA=;
 b=KWZhJDbqCD6UHBIQRHrVPt8BGboK0OhQf0FKOHO0DUBp27wxuqGt4D0hSG/n+hBF6EzTT3XZZkNjRyPtvii/fR4HmsXqi5F7Mba/BbYn938+72ka5bx6a60Mx85aJqXRq9d2LfhfTd1xKYChoDuIezzw5HBgpBOmLMQPAIcM9Dpnequu2EV4Oayhj0f8/+sU3iGeaRJe4mZK2c8tfPtz4ELQz3LFBSB/KL+apADorwnfEKfHSN4dgIUAfBC427DAwF6GlAKWF2IigRzz/T41jx5wb446/B5KKtwebtpP4NhM6X32lupbwL13MfTGB7lWwl3IAIpnPSCdSD6MDhJ0Mg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vAbOYH6pyEINfALHnF5uC9looXBkfRQn2aZWhNV5YFA=;
 b=VxVS8pwMTsOw/03H2hX8MTc9tzDnk6jSfqbtiuycOIyqhB5BkkKsjXhQCvzKS2aLm0LGGgQDX6fuQfvp3RsdHDXUEPzYXhjDlqMrildDH6aILr3lS+wd4vWp2WYEe1Vht/zKnixzs38ZNwoC55IA+u8eK2m094gr2CKMS12qAds=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB3415.namprd15.prod.outlook.com (2603:10b6:a03:112::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6; Mon, 11 Jan
 2021 04:13:16 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::9ae:1628:daf9:4b03]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::9ae:1628:daf9:4b03%7]) with mapi id 15.20.3742.012; Mon, 11 Jan 2021
 04:13:16 +0000
Subject: Re: [PATCH v2 bpf-next 5/7] bpf: support BPF ksym variables in kernel
 modules
To:     Andrii Nakryiko <andrii@kernel.org>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <ast@fb.com>, <daniel@iogearbox.net>
CC:     <kernel-team@fb.com>, Hao Luo <haoluo@google.com>
References: <20210108220930.482456-1-andrii@kernel.org>
 <20210108220930.482456-6-andrii@kernel.org>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <b301f6b8-afed-6d55-42d3-6587b75fadb9@fb.com>
Date:   Sun, 10 Jan 2021 20:13:13 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.0
In-Reply-To: <20210108220930.482456-6-andrii@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2620:10d:c090:400::5:b212]
X-ClientProxiedBy: MW4PR04CA0075.namprd04.prod.outlook.com
 (2603:10b6:303:6b::20) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21c1::1158] (2620:10d:c090:400::5:b212) by MW4PR04CA0075.namprd04.prod.outlook.com (2603:10b6:303:6b::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6 via Frontend Transport; Mon, 11 Jan 2021 04:13:15 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 20a8691c-a3ee-4e90-d2b3-08d8b5e738c7
X-MS-TrafficTypeDiagnostic: BYAPR15MB3415:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB341588D73E971F6DF1C95830D3AB0@BYAPR15MB3415.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: efSXc6slqYTX/fd8jrfFSFt4PcyWUU+gC7+bjsP1SSJsOdDYgE0cdJw/bG9dl3CCBhXwCskVKKCdhh2hfZNAnupGlMsQSOm9pW69O9ugMy3N8wCzFOPpZdnPJ4PDhI1GTSZxMuUSGjXvhRmBoqibvh4uqsd3MEWsCRNwkIvTKMzhtewg/tHAxgfT+VRul4+A4PHIsGu5x9CeQz8APyWc8L18BLH1KozQWMjJnzBb6ZuPh3rfpXrW1WRHbDwDLtGHJixJSJQXGx3sU8KbC61aFhIXlVqJ/5OrISIO20GXthdkjv3iGQorgqG+RPspt5E8yz+TDGBeMm1xH3req3Z3JRXj1TlAthhBMg+JMPSuwqNNl+oZPBOvG86jTAjtA8Mhvofik8XyT8ryLhZ/HuUYPnwztu1rofBpYNVsZN6dA85Ubc5HdOb4BK6kS3SM3FQXLJmKKyOqWsUjodLW+96KkGKgWDI9xh8hMWrRxJHt3Y0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(366004)(396003)(346002)(136003)(376002)(8676002)(5660300002)(6486002)(4326008)(31696002)(478600001)(52116002)(86362001)(53546011)(316002)(16526019)(186003)(2906002)(66556008)(66476007)(31686004)(83380400001)(8936002)(36756003)(2616005)(66946007)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?NHJReDMrazJyMUw5RC9ObmViUlQwUUIwSUFSOUJ6MFRDN3hoL1ZBUEZ3bHgv?=
 =?utf-8?B?cTN0cU1RRWRYdzMzN0xCbnNLOHRwcjBySkZmTC84UzNadExicldqaXFDNDhy?=
 =?utf-8?B?K2R3aU4vaFRKTmR6VFpYVHQvMXAxVWZNdnFxYXRaSjMyS2t2NjBDaytETzVH?=
 =?utf-8?B?WHc4RWhMb1BHZUxyN2RmdWtLMWhpT1A2K1ZSSEgzNHc3ZnFBbFExVlpjNTRF?=
 =?utf-8?B?ZzhTU3kzUy84SFdNOHNwcXpaZDhZQUwvWTE3UUhxTlVHbnZUQkgzVlZkOHJa?=
 =?utf-8?B?d2cvU0xSbmwzZWVUdVV1U1RiN1A2cys2OFl5cWNMYnRiRDNEaWlQTmhmY0dO?=
 =?utf-8?B?K1k3NEg2eGQrc2hKS3UxcndsTm13TTgwakdRZm8xbVFmRWxna3NrNW42cWNz?=
 =?utf-8?B?ZG5TbVZ3NGVtbm9pMUZPM0QxN2ZLRU83aFFUYm10VVZ1MWE3NHRDYng4TURV?=
 =?utf-8?B?TXR6VmlRVW1zTTZuVXJGV0pTODZwZ2txclczT0tLMWs5MFhYWWFzVW1NOENH?=
 =?utf-8?B?QTB4Q1M5aXdqV1pDUGdkck4xTFBQLzRaUVMwVUZKUGw4NGlLb0FkeEhuN1F1?=
 =?utf-8?B?VDVCdDNBT1JOakt0ZzQ4Mk91M0dFUUM5UjlpZWpTcHU3TEFlRTllUjllRWxw?=
 =?utf-8?B?anh4OUhrTWdxZ1R3bEZMMU1nUERNU0xnNlJ6MlhaMWZjeG9ib3BmbHU1Q3E3?=
 =?utf-8?B?RDQ1b3VsR2JHbFUyOGJNeDJNdXpLUmdiRlN1eGx4b1BBRVpVaTZLelNSNGtC?=
 =?utf-8?B?d2NkZ2RaeG95djJoVkZhTEFVT3ZKbE1IcDAzYTBsMFdmeUdNOUEwLzlZVnNW?=
 =?utf-8?B?YWJZcVpvbDhjcm5PUDJ1ak15dlFQYlNPZWpTS3ZLcG9hVnNzcm96WjFYTG5K?=
 =?utf-8?B?d1hDVW44UG9TZkRBc2ozNklVY1ZMcVJaS0dRYXBsMHFQWGVOKzZsK2xReGxQ?=
 =?utf-8?B?aXlzQlB1U2lJclFLOFdDWkRvdW94UGRpd2pUM012eUFBa3grQ1p2aVRXSGRm?=
 =?utf-8?B?bVZiT2RXbzl0Z3lyZEI4ZUpxNnpwTWNtNit6czhkMkRNOGdocms5WjBIN252?=
 =?utf-8?B?d1VaNXpydDdITWJoVXprUHNCVlN4Nng0NmowYnNFbmI0bUVRR1dMWjFoUnZn?=
 =?utf-8?B?OGlLUUtGeXFtdVk5YUJmQ21kNzRrdDdVR096dUs3dndJUzhadUNmQVNNTTJi?=
 =?utf-8?B?VHU4LzZLYVJWMjNQTVJOcnd0T25PUkRnUUxSTC82Mlh2OEI1VG0vSFNMOGV2?=
 =?utf-8?B?Z1lDcHNEMTZieEdWY1BkM3QzWndISS95MWtaSExRZFhrbzA5T0NZT3NqRVBn?=
 =?utf-8?B?T3F1RVBDNEpHTmNlNGVqamdOSVBEbnhIZk0vVkhYV09ybnNnb09mWkVOSW9p?=
 =?utf-8?B?WkRuUXlNV3R5QkE9PQ==?=
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jan 2021 04:13:16.6688
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-Network-Message-Id: 20a8691c-a3ee-4e90-d2b3-08d8b5e738c7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: znizBIWmQVVEBMEPqtius2HD2jHJTrXiioB71E6UWONIvHDMZyDnwcqHBWhwDvya
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3415
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-09_13:2021-01-07,2021-01-09 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 malwarescore=0 bulkscore=0 phishscore=0 spamscore=0 impostorscore=0
 lowpriorityscore=0 priorityscore=1501 clxscore=1015 mlxscore=0
 adultscore=0 mlxlogscore=999 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2101110023
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/8/21 2:09 PM, Andrii Nakryiko wrote:
> Add support for directly accessing kernel module variables from BPF programs
> using special ldimm64 instructions. This functionality builds upon vmlinux
> ksym support, but extends ldimm64 with src_reg=BPF_PSEUDO_BTF_ID to allow
> specifying kernel module BTF's FD in insn[1].imm field.
> 
> During BPF program load time, verifier will resolve FD to BTF object and will
> take reference on BTF object itself and, for module BTFs, corresponding module
> as well, to make sure it won't be unloaded from under running BPF program. The
> mechanism used is similar to how bpf_prog keeps track of used bpf_maps.
> 
> One interesting change is also in how per-CPU variable is determined. The
> logic is to find .data..percpu data section in provided BTF, but both vmlinux
> and module each have their own .data..percpu entries in BTF. So for module's
> case, the search for DATASEC record needs to look at only module's added BTF
> types. This is implemented with custom search function.
> 
> Signed-off-by: Andrii Nakryiko <andrii@kernel.org>

Ack with a minor nit below.

Acked-by: Yonghong Song <yhs@fb.com>

> ---
>   include/linux/bpf.h          |  10 +++
>   include/linux/bpf_verifier.h |   3 +
>   include/linux/btf.h          |   3 +
>   kernel/bpf/btf.c             |  31 +++++++-
>   kernel/bpf/core.c            |  23 ++++++
>   kernel/bpf/verifier.c        | 149 ++++++++++++++++++++++++++++-------
>   6 files changed, 189 insertions(+), 30 deletions(-)
> 
[...]
>   /* replace pseudo btf_id with kernel symbol address */
>   static int check_pseudo_btf_id(struct bpf_verifier_env *env,
>   			       struct bpf_insn *insn,
> @@ -9710,48 +9735,57 @@ static int check_pseudo_btf_id(struct bpf_verifier_env *env,
>   {
>   	const struct btf_var_secinfo *vsi;
>   	const struct btf_type *datasec;
> +	struct btf_mod_pair *btf_mod;
>   	const struct btf_type *t;
>   	const char *sym_name;
>   	bool percpu = false;
>   	u32 type, id = insn->imm;
> +	struct btf *btf;
>   	s32 datasec_id;
>   	u64 addr;
> -	int i;
> +	int i, btf_fd, err;
>   
> -	if (!btf_vmlinux) {
> -		verbose(env, "kernel is missing BTF, make sure CONFIG_DEBUG_INFO_BTF=y is specified in Kconfig.\n");
> -		return -EINVAL;
> -	}
> -
> -	if (insn[1].imm != 0) {
> -		verbose(env, "reserved field (insn[1].imm) is used in pseudo_btf_id ldimm64 insn.\n");
> -		return -EINVAL;
> +	btf_fd = insn[1].imm;
> +	if (btf_fd) {
> +		btf = btf_get_by_fd(btf_fd);
> +		if (IS_ERR(btf)) {
> +			verbose(env, "invalid module BTF object FD specified.\n");
> +			return -EINVAL;
> +		}
> +	} else {
> +		if (!btf_vmlinux) {
> +			verbose(env, "kernel is missing BTF, make sure CONFIG_DEBUG_INFO_BTF=y is specified in Kconfig.\n");
> +			return -EINVAL;
> +		}
> +		btf = btf_vmlinux;
> +		btf_get(btf);
>   	}
>   
> -	t = btf_type_by_id(btf_vmlinux, id);
> +	t = btf_type_by_id(btf, id);
>   	if (!t) {
>   		verbose(env, "ldimm64 insn specifies invalid btf_id %d.\n", id);
> -		return -ENOENT;
> +		err = -ENOENT;
> +		goto err_put;
>   	}
>   
>   	if (!btf_type_is_var(t)) {
> -		verbose(env, "pseudo btf_id %d in ldimm64 isn't KIND_VAR.\n",
> -			id);
> -		return -EINVAL;
> +		verbose(env, "pseudo btf_id %d in ldimm64 isn't KIND_VAR.\n", id);
> +		err = -EINVAL;
> +		goto err_put;
>   	}
>   
> -	sym_name = btf_name_by_offset(btf_vmlinux, t->name_off);
> +	sym_name = btf_name_by_offset(btf, t->name_off);
>   	addr = kallsyms_lookup_name(sym_name);
>   	if (!addr) {
>   		verbose(env, "ldimm64 failed to find the address for kernel symbol '%s'.\n",
>   			sym_name);
> -		return -ENOENT;
> +		err = -ENOENT;
> +		goto err_put;
>   	}
>   
> -	datasec_id = btf_find_by_name_kind(btf_vmlinux, ".data..percpu",
> -					   BTF_KIND_DATASEC);
> +	datasec_id = find_btf_percpu_datasec(btf);
>   	if (datasec_id > 0) {
> -		datasec = btf_type_by_id(btf_vmlinux, datasec_id);
> +		datasec = btf_type_by_id(btf, datasec_id);
>   		for_each_vsi(i, datasec, vsi) {
>   			if (vsi->type == id) {
>   				percpu = true;
> @@ -9764,10 +9798,10 @@ static int check_pseudo_btf_id(struct bpf_verifier_env *env,
>   	insn[1].imm = addr >> 32;
>   
>   	type = t->type;
> -	t = btf_type_skip_modifiers(btf_vmlinux, type, NULL);
> +	t = btf_type_skip_modifiers(btf, type, NULL);
>   	if (percpu) {
>   		aux->btf_var.reg_type = PTR_TO_PERCPU_BTF_ID;
> -		aux->btf_var.btf = btf_vmlinux;
> +		aux->btf_var.btf = btf;
>   		aux->btf_var.btf_id = type;
>   	} else if (!btf_type_is_struct(t)) {
>   		const struct btf_type *ret;
> @@ -9775,21 +9809,54 @@ static int check_pseudo_btf_id(struct bpf_verifier_env *env,
>   		u32 tsize;
>   
>   		/* resolve the type size of ksym. */
> -		ret = btf_resolve_size(btf_vmlinux, t, &tsize);
> +		ret = btf_resolve_size(btf, t, &tsize);
>   		if (IS_ERR(ret)) {
> -			tname = btf_name_by_offset(btf_vmlinux, t->name_off);
> +			tname = btf_name_by_offset(btf, t->name_off);
>   			verbose(env, "ldimm64 unable to resolve the size of type '%s': %ld\n",
>   				tname, PTR_ERR(ret));
> -			return -EINVAL;
> +			err = -EINVAL;
> +			goto err_put;
>   		}
>   		aux->btf_var.reg_type = PTR_TO_MEM;
>   		aux->btf_var.mem_size = tsize;
>   	} else {
>   		aux->btf_var.reg_type = PTR_TO_BTF_ID;
> -		aux->btf_var.btf = btf_vmlinux;
> +		aux->btf_var.btf = btf;
>   		aux->btf_var.btf_id = type;
>   	}
> +
> +	/* check whether we recorded this BTF (and maybe module) already */
> +	for (i = 0; i < env->used_btf_cnt; i++) {
> +		if (env->used_btfs[i].btf == btf) {
> +			btf_put(btf);
> +			return 0;

An alternative way is to change the above code as
			err = 0;
			goto err_put;

> +		}
> +	}
> +
> +	if (env->used_btf_cnt >= MAX_USED_BTFS) {
> +		err = -E2BIG;
> +		goto err_put;
> +	}
> +
> +	btf_mod = &env->used_btfs[env->used_btf_cnt];
> +	btf_mod->btf = btf;
> +	btf_mod->module = NULL;
> +
> +	/* if we reference variables from kernel module, bump its refcount */
> +	if (btf_is_module(btf)) {
> +		btf_mod->module = btf_try_get_module(btf);
> +		if (!btf_mod->module) {
> +			err = -ENXIO;
> +			goto err_put;
> +		}
> +	}
> +
> +	env->used_btf_cnt++;
> +
>   	return 0;
> +err_put:
> +	btf_put(btf);
> +	return err;
>   }
>   
[...]

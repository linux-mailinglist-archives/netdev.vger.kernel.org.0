Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2BBD1CE5E7
	for <lists+netdev@lfdr.de>; Mon, 11 May 2020 22:44:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731954AbgEKUna (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 16:43:30 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:48430 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729517AbgEKUn2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 May 2020 16:43:28 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 04BKc7us009456;
        Mon, 11 May 2020 13:43:07 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=3ouojI3PtA3Rq/u9TQ6YBdIpJHYd9Iqhxa5UkueGR9I=;
 b=RBQDLk0OsFXGA2+AzaqmshIskgpXgwjxXK+Fsujf44kCE2voBFAhQ8ahgZA+Tt1JfA3B
 HiloJ4HirJC3JiCbviCGwjyJYRUbW3h7neJN2iVGj+PuPNmv0v7hA9LpJu0CriJ7Z1gM
 tLUgfpBZqKYseXPTVsNj4VG4eZXHtuFRDWs= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0001303.ppops.net with ESMTP id 30ws21bxnu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 11 May 2020 13:43:07 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Mon, 11 May 2020 13:43:06 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RIMMo8wiIo6gwlpA/Ym+PzKxhFlu6dQ4BL7xm6ZvEgPk0To5xpJzRqjbqK9yZQTfxu3IIOGEe2NcN4xbB6mHy11jkLMHa54MuGjRJYzV+RtOnJwlGplmKW+MTmgmb5A4L0CQUK5xtOThklIZF/9Ekn2vpjZlSaJq1FWErQolDNfBmSr3EdcHDdoCk6gwZX4wBJLk5P7+wyCdB7yjmp0l6iLoEFev/bvp9H18RJrF+YZjoepOkLWAabzbqt8Mau1Zm7+SBnNY28IHpoSkyqPnZHBVmt8z9xdfdWIBQwZQSl+bz1/liu7KHLzrXyamcxD5vVtzG1KmDhPqjja+JofeMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3ouojI3PtA3Rq/u9TQ6YBdIpJHYd9Iqhxa5UkueGR9I=;
 b=T8He1IBF5t1zUfION8mfVG2tu/k9nHcw8EPtq0iDF6RLjPE2my9z4gMaHIA6A133JIg6I3epSQRY5PJddUVeoSfWFtf2K1n05FefheP0Rs16UVTD4SrSPnmYo8/s+FUCEnLW0jCOwbaVVjJsxTJJuO3M0O8URysFX1QJUQbB0vugtK03fH2FbWmQpjQ8/4zAaukCffmn4MnlWXuBZhxbSUhyg7GAlWgJILZB+O03TVeHWttGz42J8Mr7qYCRNEGYjiR8jkOQi7WohHhhGeIYZ6oVWDObgk85aAMTpmbZvnI4bkKHkxJSruRoeYZ9a7c4N/wT+pyqwaesUNxlzUbbEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3ouojI3PtA3Rq/u9TQ6YBdIpJHYd9Iqhxa5UkueGR9I=;
 b=G1MTJG2TJRbIHM1ZCWdBUXuWgRaony1jYFx5J/k7wF9y/aXl/96Hx79YSMxEq6DskXfsEjsA+ylv62qqo4u/LaSI1TWmwtaoS5nbt2oOLA1+uytI+m8F/y/94dljHh9X7N+DibwxsQEfz1U8xHPZvJKUxe+r1i0cxWDpwxs1iIA=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB4133.namprd15.prod.outlook.com (2603:10b6:a03:9b::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.26; Mon, 11 May
 2020 20:43:05 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::4922:9927:5d6c:5301]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::4922:9927:5d6c:5301%7]) with mapi id 15.20.2979.033; Mon, 11 May 2020
 20:43:05 +0000
Subject: Re: [PATCH bpf-next v3] libbpf: fix probe code to return EPERM if
 encountered
To:     Eelco Chaudron <echaudro@redhat.com>, <bpf@vger.kernel.org>
CC:     <davem@davemloft.net>, <netdev@vger.kernel.org>, <ast@kernel.org>,
        <daniel@iogearbox.net>, <kafai@fb.com>, <songliubraving@fb.com>,
        <andriin@fb.com>, <toke@redhat.com>
References: <158920079637.7533.5703299045869368435.stgit@ebuild>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <7008d545-ac78-3e22-aeaa-1d6639611225@fb.com>
Date:   Mon, 11 May 2020 13:43:03 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.0
In-Reply-To: <158920079637.7533.5703299045869368435.stgit@ebuild>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR11CA0080.namprd11.prod.outlook.com
 (2603:10b6:a03:f4::21) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from macbook-pro-52.local.dhcp.thefacebook.com (2620:10d:c090:400::5:3585) by BYAPR11CA0080.namprd11.prod.outlook.com (2603:10b6:a03:f4::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.26 via Frontend Transport; Mon, 11 May 2020 20:43:04 +0000
X-Originating-IP: [2620:10d:c090:400::5:3585]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 11f572d9-be73-451c-5ae5-08d7f5ebe7e9
X-MS-TrafficTypeDiagnostic: BYAPR15MB4133:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB4133E9AED65145996B92475FD3A10@BYAPR15MB4133.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:1091;
X-Forefront-PRVS: 04004D94E2
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: E3+/L7gHNkHO9ZiBZC7upWOqjL9nptTZ20PR03m0PWy2ny6FUkh9DizfIZ1PiYLZvArQBHMRh0/05J9KRAC28CWRJWyAkCv8twgUt+Y0yj88MhfMGVN6r/m2/jXrN+C4CMUZO5LJDlnh2tbjjVBDMdsyThvd52adPR0QMvx1MzleEa26C9BT8LZqlr7orx3LMvB+kFcrWpAKODoFtDW/42SVTwyH4vh1Pl8P81MhKeJuxRMUQGvBUFZk3YSTi6fr386DPicjdOHQu1GqCoc/Gvk4xgQ/RD0GBIabLLFYIZfJE8UCQJjeAt6xw3kShPbfqPkOTSme4xXNCgdVPvBgFuw0gTCr5PlrTOde9GlKCn7QSIm2a5jxnRGgseXMeSDWonPJs2LhijHdt3xKqlcXIWL1z9/nbVjYoYv4NtlpOTszs1Es5eC59xenw4+RvTfSOpb5fz5SbuwZJeunTQIy5C7B7FV1MPSTLCFuT0ab1TNE55/GXUd/RIZZi6VqU+ZP7gVGz0MZMasi0F2S+gq4UyhbMeQk+Ma3SC9BeSLghBL3B4HN80WR36TtB8hDga0m
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(39860400002)(396003)(366004)(346002)(136003)(376002)(33430700001)(8676002)(478600001)(16526019)(5660300002)(66556008)(6512007)(31696002)(66476007)(4326008)(66946007)(52116002)(53546011)(86362001)(6506007)(6486002)(186003)(31686004)(36756003)(2616005)(8936002)(33440700001)(2906002)(316002)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: yIplINE/UapyeUOhbK2l440oJ70duA7tNWjWXdOeZsB8ZY8ff+oxy7lb4b4SSnQ0SGSy5mcnJS7ByayR7JAAoUDjWpA+yqYThtEUDXmjpaRmFvKwIfo9Hetzi2J+rKGKVGJ1qxxjA8HQTEAU0TWda+dLXiLud2dxI1qIACLovaJ5xh39DP/n4jtXVROh0UK0PiOddAuyVFkAvT2Ivm2BhDiguJEAcBXUUf9CHJSsf/iW7ZaYHGwSjZ0zt5CxhbYzkbX1F6+vDrvnJxqSsoSI8ic413LnizaHmrbgIWcu1R3m/TSIqQg5kQdvxecK9ZgA/NiH2+9SDsWrd566nMPbkuWtFE6oxQZXTqzVg9RHAGW9srKydLvjvsa6Wn/AkR/WgNRosy09PGqxDhhwulO0oEma6F6eCVmRSQUuxcJnilrjYztLX4AExFbaJZrCOcQ8oGgjzb57U7CZ6w9u/EC/FZ1zqBsFMmq5IQznfKj9zAwl004uJhcYVEQQenTtbKlj86qMcXsNOtAs1iPZVTcdJQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: 11f572d9-be73-451c-5ae5-08d7f5ebe7e9
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2020 20:43:05.5223
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: skjxOSYCzKuPW6LuuXsO2+BK9eVLKPcsi4lIz9dHj6Lm/wj63cHPm056Wu4VeYMb
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB4133
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-11_10:2020-05-11,2020-05-11 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 mlxlogscore=999 priorityscore=1501 bulkscore=0 clxscore=1015 phishscore=0
 lowpriorityscore=0 spamscore=0 adultscore=0 malwarescore=0 impostorscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005110157
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/11/20 5:40 AM, Eelco Chaudron wrote:
> When the probe code was failing for any reason ENOTSUP was returned, even
> if this was due to no having enough lock space. This patch fixes this by
> returning EPERM to the user application, so it can respond and increase
> the RLIMIT_MEMLOCK size.
> 
> Signed-off-by: Eelco Chaudron <echaudro@redhat.com>
> ---
> v3: Updated error message to be more specific as suggested by Andrii
> v2: Split bpf_object__probe_name() in two functions as suggested by Andrii
> 
>   tools/lib/bpf/libbpf.c |   31 ++++++++++++++++++++++++++-----
>   1 file changed, 26 insertions(+), 5 deletions(-)
> 
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index 8f480e29a6b0..ad3043c5db13 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -3149,7 +3149,7 @@ int bpf_map__resize(struct bpf_map *map, __u32 max_entries)
>   }
>   
>   static int
> -bpf_object__probe_name(struct bpf_object *obj)
> +bpf_object__probe_loading(struct bpf_object *obj)
>   {
>   	struct bpf_load_program_attr attr;
>   	char *cp, errmsg[STRERR_BUFSIZE];
> @@ -3170,14 +3170,34 @@ bpf_object__probe_name(struct bpf_object *obj)
>   	ret = bpf_load_program_xattr(&attr, NULL, 0);
>   	if (ret < 0) {
>   		cp = libbpf_strerror_r(errno, errmsg, sizeof(errmsg));
> -		pr_warn("Error in %s():%s(%d). Couldn't load basic 'r0 = 0' BPF program.\n",
> -			__func__, cp, errno);
> +		pr_warn("Error in %s():%s(%d). Couldn't load trivial BPF "
> +			"program. Make sure your kernel supports BPF "
> +			"(CONFIG_BPF_SYSCALL=y) and/or that RLIMIT_MEMLOCK is "
> +			"set to big enough value.\n", __func__, cp, errno);
>   		return -errno;

Just curious. Did "errno" always survive pr_warn() here? pr_warn() may 
call user supplied print function which it outside libbpf control.
Maybe should cache errno before calling pr_warn()?

>   	}
>   	close(ret);
>   
> -	/* now try the same program, but with the name */
> +	return 0;
> +}
> +
> +static int
> +bpf_object__probe_name(struct bpf_object *obj)
> +{
> +	struct bpf_load_program_attr attr;
> +	struct bpf_insn insns[] = {
> +		BPF_MOV64_IMM(BPF_REG_0, 0),
> +		BPF_EXIT_INSN(),
> +	};
> +	int ret;
> +
> +	/* make sure loading with name works */
>   
> +	memset(&attr, 0, sizeof(attr));
> +	attr.prog_type = BPF_PROG_TYPE_SOCKET_FILTER;
> +	attr.insns = insns;
> +	attr.insns_cnt = ARRAY_SIZE(insns);
> +	attr.license = "GPL";
>   	attr.name = "test";
>   	ret = bpf_load_program_xattr(&attr, NULL, 0);
>   	if (ret >= 0) {
> @@ -5386,7 +5406,8 @@ int bpf_object__load_xattr(struct bpf_object_load_attr *attr)
>   
>   	obj->loaded = true;
>   
> -	err = bpf_object__probe_caps(obj);
> +	err = bpf_object__probe_loading(obj);
> +	err = err ? : bpf_object__probe_caps(obj);
>   	err = err ? : bpf_object__resolve_externs(obj, obj->kconfig);
>   	err = err ? : bpf_object__sanitize_and_load_btf(obj);
>   	err = err ? : bpf_object__sanitize_maps(obj);
> 

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEC61368361
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 17:33:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236397AbhDVPeL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 11:34:11 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:41284 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230005AbhDVPeK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Apr 2021 11:34:10 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13MFPr0t014255;
        Thu, 22 Apr 2021 08:33:21 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=5yq2kl60JdEDYb4WY1dy2k25b2OZuSGSg45TJHFyoMY=;
 b=KWKmu8+eng5gQc7klS6LXpPPpZSnB3CnqybG26tX18JgufkyZ40Bq5mivMJLMxvl+HB9
 TSnu2jy2DiQaBoZBsqOHKdFhjn2lUhpKsegPT5WrTwlvjyyWl5CsTBv+TgcN/WngtfDu
 zD4BXJeEzzwh9PQrQMru0TsSTRRlFODoFds= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3831khu2u3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 22 Apr 2021 08:33:20 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.175) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 22 Apr 2021 08:33:20 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eth2S9+rf3U1huJ8SSGTVGyeSpAfOEupaxzmOeMwhNy9vw/ysyoIDJK9S5n5aSuUsOk6glxQRIRFiw4LjODZi2F+8F+uNJHuYfwcWJzXmnWcgpPCZKKXqEG3pvr8cSUTFc+z60LNpu+zdu6TlhTg6+jWdiqaf3vFyHzoOsH7vAU9CGnSUcXgwDy/2RxNjKKBpGR2ri8YHuuRUHq4+zlvCFggJqmAGXIZg/e8QezUlsYQW4jak1FSVyIrz3WruSNYq06DEENaQuM072MfD57HtNKuD2eW2mZ1Xy2POWds79f5vwmgM9MXEQwvumnCRfFS14uVOrVrJvIWbB1pgpUOwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5yq2kl60JdEDYb4WY1dy2k25b2OZuSGSg45TJHFyoMY=;
 b=WskPekKXOBVH+1VjtNgVWP3i5OzAuOIO/COmjqAQl9eYF6gWkc8zubh7ptJdNllwLslKXJKmjJd8j5ao9KwANV2Q0749bb12hDnUzWPsVCpIhUkd+4N0Ku+kEn4EyHiWixr5rOgC7SXzKD6COZaSOYBi3DkIEo6KYs8btE3M2Y9XHpFEpo1f0Z6rAmwb+X44unL1B3ShVDG54SL7/fJXVcm3oVUgPjFuRbnECoV6rxH27karHTLNsJQ/xYuLEkBDHN+21OGLEFZOpkRln+Fio6HH9EGMnFAm4eiR+scENILXQ/FWbRq29Vwfus96Hu0ssvllsSTHzGdd+Ki7vPFuwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SA1PR15MB4642.namprd15.prod.outlook.com (2603:10b6:806:19d::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.20; Thu, 22 Apr
 2021 15:33:19 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::f433:fd99:f905:8912]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::f433:fd99:f905:8912%3]) with mapi id 15.20.4065.021; Thu, 22 Apr 2021
 15:33:19 +0000
Subject: Re: [PATCH v2 bpf-next 06/17] libbpf: refactor BTF map definition
 parsing
To:     Andrii Nakryiko <andrii@kernel.org>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <ast@fb.com>, <daniel@iogearbox.net>
CC:     <kernel-team@fb.com>
References: <20210416202404.3443623-1-andrii@kernel.org>
 <20210416202404.3443623-7-andrii@kernel.org>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <0ae37c13-e8d9-b0ca-00ca-1750dc2799c9@fb.com>
Date:   Thu, 22 Apr 2021 08:33:15 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.1
In-Reply-To: <20210416202404.3443623-7-andrii@kernel.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2620:10d:c090:400::5:427c]
X-ClientProxiedBy: MW4PR04CA0381.namprd04.prod.outlook.com
 (2603:10b6:303:81::26) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21c8::16ea] (2620:10d:c090:400::5:427c) by MW4PR04CA0381.namprd04.prod.outlook.com (2603:10b6:303:81::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.20 via Frontend Transport; Thu, 22 Apr 2021 15:33:18 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 924f2901-cfcd-4552-da4b-08d905a3f4a9
X-MS-TrafficTypeDiagnostic: SA1PR15MB4642:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA1PR15MB4642E8D7B6DF7E4685B9D303D3469@SA1PR15MB4642.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:175;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eDtV37g27Lq5jLcmrOOnJFtMyKUxG5jhANANVeGbKUPOZS1UGvYJ/xz1fyy8OLQIDI903myR5RvAj17IWTM0NSpGLjxj0R6wNaP2yuE45TC4NcqFPDLCxA2ihgHt+zsbf7gCUoh9/BnE/jcqpic/1AoPSM9+zgskGGbhRn6W32ZpoDu4Z0fwgfS4mc53Knv4HptEcoZh+ldXDBaXrYlR9/K8udWlj9P4jsH0+KuxjhhyWG7uwwxwBaA4kxyvogbL3ll10LzX1qxGCn49sZ51jyv43nsBxJ3AI029TWObpkWP8WSXLMJsUOS4eFKH1LXT1446TTMQuDf7dEmsKwJ+BGA6u9IwHkuJlLhJG4EU+a2DagCoTib5PWydHgtmijsPxAdkxNPY5w5avt61UnALKlGW0lNX9XZf6MU6xehdbEXmbsStAZ2D33OEmyvYiOs3hPuOvNMWQwYDJoNjS+kT5uzoBv0SgwC/n2SS6H5fgsWZYUNuLusn9vqwAp35XpWoINvCEBFl5DU9pAECuhq/InasOZlqzMf0iboBneeqJcJ9p7qtIEoDo3j2ylx7wcDZ6PcOtsZ2ZyFYD9/oqxnBir3kEjVqlT4G0zp2dRB511oxHdD1I3A3GoKzF8vrle2ZilfJ0bdl7my7BFslT6oI4pkCdGHrS6ZaWMehbc2c4tOsBqZuBzlQZNoBKBwATgkL
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(39860400002)(396003)(136003)(366004)(376002)(86362001)(31696002)(2616005)(8676002)(83380400001)(478600001)(36756003)(6666004)(2906002)(31686004)(316002)(66946007)(4326008)(66556008)(38100700002)(5660300002)(53546011)(66476007)(6486002)(52116002)(16526019)(186003)(8936002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?amsxb2s2TDUvZGN2ZWx1TUR4cEg4a2F6c2ptNER3L1RrRXBvSXo0L2Z0YlV2?=
 =?utf-8?B?WGwvbXRlMjBoQlAzSS9DaE9DYVZtN0pFUmhBdzcwTE9IRkFRVVdWY3gxYUxt?=
 =?utf-8?B?cWU2NTQ4ckFla1pCOEhKY2pSZ1ZqV0NvUlZQbHZkeUVNKzdrd3FJaWNiVmlz?=
 =?utf-8?B?UDdtODVqNGY1WWMrSUF6WXZhN05tTlFJV0MzMXZtdk1HMWtVaHpNdy9CWk5N?=
 =?utf-8?B?Ynp5NWxzOUxlak9mV1BYcjJqbkFiR1JFS2ZpQUZreGZlYzZnaVY3V0xncHV1?=
 =?utf-8?B?QkdJOGV4ejU0bkF0Nlk3bVhCazl2MDZSR0t0M09xNU1PWU4yWUJ5UmFORHls?=
 =?utf-8?B?QVJ2Q3VFWmx2ajVVNDNpMkFaQkZ6WFdXaGhGY0Y3YW5jYk5oOXR6dFJacFlZ?=
 =?utf-8?B?Z1NEK3F2OTNvdTJtTnZobTgvbDZKRXNjM2hYNktyZDZaK1Q0WmhmRWZBWjdM?=
 =?utf-8?B?NHYrN2FsU05jMExRYTNGS3lLZ0NkcW55YU56MU5HZWt5elF2dHZybUFMVE92?=
 =?utf-8?B?MUppbmRQSG1aMW1HY1N2UTRDbmthYTdUTXZiMDJZbWpPMHV3aGtXTUdsa1JH?=
 =?utf-8?B?aVJxcnNEUnhXY3Z6eFBBLzJWM2c2RUNoMDlUSHIzV25KQ3gzd0krZExZd2pR?=
 =?utf-8?B?VDhQa0xxc08rcGx3ejE4anZBNi91SlZjeVl1TXM5dXFCbjFGSmMvRm9yT0NU?=
 =?utf-8?B?SXVhdmZBbzNjY2VWeE9uSFhZRnJwUnBWdzZBZWJGcG9sVHdIbEtiK2dFQUJU?=
 =?utf-8?B?K09qNGRwNzErenhwc2N3d21sV0JRMlFVMEg1Wk0rYnZPa0lsZUhrOG5zVzgw?=
 =?utf-8?B?YmxsaW5idkRaaEpYMUQ0dmxRTDZLakJYMlZ2QkhtTWhCRU9ZTzUxUlNDM3hn?=
 =?utf-8?B?WlhiNWorY1hJVmd4N0F1Z0c0RHBLY3dnbUNwcjU3aDlIeGEwbHdvblNERlk5?=
 =?utf-8?B?OThjd3M1TWxTTTY1VW5sTGl5ZXdSajdRNkNVdXR0UkdtVnNrYU9XaHMwNUZT?=
 =?utf-8?B?SW9wL3VZMDY0ZWw1bnhDYUc5YlB4N2dJVS9Ed3E0cHREc1FGM1lSdXhsN1lr?=
 =?utf-8?B?WXJzaGRNSGIzWXpWN2NYRlJ4MmhpMkFpNGpObXBCekVoK3orTzFXTzBGc1dJ?=
 =?utf-8?B?eTJWbkdHY2VyRUFlZFBYSjFHemsvSkwrdzBmWUI5Uzk4RmN4bWZzeko0QWxw?=
 =?utf-8?B?bDRSV1lVbERpNDl4Z2twT0ZBYXpxeVAwTGJtaGVkSnpzYWpyNXJWcW5RZlBw?=
 =?utf-8?B?R01lZWNaN21IbEtURFNZWlJuRyswWUhtZkYrQmd5azQyOHVLZ1V2L1RiK0ty?=
 =?utf-8?B?L3BubUFPeDBrU1dEVW5tSDBObWUvL0hEVy96cWZpcGdVL1hOMGN5SnVjWjZM?=
 =?utf-8?B?cXhzYWxIdEVmQUE4dnVZVUl0SXp6TnlFRGlNbnZsZ2t4UmhuUlhydC9xeWZD?=
 =?utf-8?B?bmc5UEJlYm14UWlSOXhoQ0ZrMzBDRFNRVXdOeUpCdnhWcU9kZjlpOEFKcDB5?=
 =?utf-8?B?eWw5UFpzZFdzV2xaUFlMOW45T2dTdGVxeTJyOTAra0QrNkRmU1BWNnBlL3VV?=
 =?utf-8?B?aXh6VnU1anNFejIyYkRNU3VtTTk0SURDS254cUc0bklqckc3ZGJ3dzhWYWR2?=
 =?utf-8?B?U3lIV3k2ZDRQdmYycWJiaDg3ZzBXMjVMWUc5R3IzZE9UNEdxekprSEZRd3hq?=
 =?utf-8?B?MEszNE8rS2VpSTFMOWFSTWVVQ0JpSCtVcno2NGdCdklRc29ka25GQWZkckM0?=
 =?utf-8?B?aFU1YzBoYWUyNEdmUXZlNFhyTU5QSkxjTXpsZFRNOWZJd2lDWFpIOWxQZ3M0?=
 =?utf-8?Q?+UWTZStbxOM5XNl4Dt0s1BJLShK9W69eDmO2c=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 924f2901-cfcd-4552-da4b-08d905a3f4a9
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2021 15:33:19.3835
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hPZvWjp4FL8rVM0CTawSK2qERDI8ZlKYaRoH6c+s60hpwztSad8QK+1ojJJAAxqT
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB4642
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: JtZ-kP2J_ZZCjXpTyOLUGW8uiqSeB931
X-Proofpoint-GUID: JtZ-kP2J_ZZCjXpTyOLUGW8uiqSeB931
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-22_06:2021-04-22,2021-04-22 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 phishscore=0 malwarescore=0 bulkscore=0 adultscore=0 clxscore=1015
 suspectscore=0 lowpriorityscore=0 impostorscore=0 mlxscore=0
 mlxlogscore=999 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2104060000 definitions=main-2104220121
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/16/21 1:23 PM, Andrii Nakryiko wrote:
> Refactor BTF-defined maps parsing logic to allow it to be nicely reused by BPF
> static linker. Further, at least for BPF static linker, it's important to know
> which attributes of a BPF map were defined explicitly, so provide a bit set
> for each known portion of BTF map definition. This allows BPF static linker to
> do a simple check when dealing with extern map declarations.
> 
> The same capabilities allow to distinguish attributes explicitly set to zero
> (e.g., __uint(max_entries, 0)) vs the case of not specifying it at all (no
> max_entries attribute at all). Libbpf is currently not utilizing that, but it
> could be useful for backwards compatibility reasons later.
> 
> Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
> ---
>   tools/lib/bpf/libbpf.c          | 256 ++++++++++++++++++--------------
>   tools/lib/bpf/libbpf_internal.h |  32 ++++
>   2 files changed, 177 insertions(+), 111 deletions(-)
> 
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index a0e6d6bc47f3..f6f4126389ac 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -2025,255 +2025,262 @@ static int build_map_pin_path(struct bpf_map *map, const char *path)
>   	return bpf_map__set_pin_path(map, buf);
>   }
>   
> -
> -static int parse_btf_map_def(struct bpf_object *obj,
> -			     struct bpf_map *map,
> -			     const struct btf_type *def,
> -			     bool strict, bool is_inner,
> -			     const char *pin_root_path)
> +int parse_btf_map_def(const char *map_name, struct btf *btf,
> +		      const struct btf_type *def_t, bool strict,
> +		      struct btf_map_def *map_def, struct btf_map_def *inner_def)
>   {
>   	const struct btf_type *t;
>   	const struct btf_member *m;
> +	bool is_inner = inner_def == NULL;
>   	int vlen, i;
>   
> -	vlen = btf_vlen(def);
> -	m = btf_members(def);
> +	vlen = btf_vlen(def_t);
> +	m = btf_members(def_t);
>   	for (i = 0; i < vlen; i++, m++) {
> -		const char *name = btf__name_by_offset(obj->btf, m->name_off);
> +		const char *name = btf__name_by_offset(btf, m->name_off);
>   
[...]
>   		}
>   		else if (strcmp(name, "values") == 0) {
> +			char inner_map_name[128];
>   			int err;
>   
>   			if (is_inner) {
>   				pr_warn("map '%s': multi-level inner maps not supported.\n",
> -					map->name);
> +					map_name);
>   				return -ENOTSUP;
>   			}
>   			if (i != vlen - 1) {
>   				pr_warn("map '%s': '%s' member should be last.\n",
> -					map->name, name);
> +					map_name, name);
>   				return -EINVAL;
>   			}
> -			if (!bpf_map_type__is_map_in_map(map->def.type)) {
> +			if (!bpf_map_type__is_map_in_map(map_def->map_type)) {
>   				pr_warn("map '%s': should be map-in-map.\n",
> -					map->name);
> +					map_name);
>   				return -ENOTSUP;
>   			}
> -			if (map->def.value_size && map->def.value_size != 4) {
> +			if (map_def->value_size && map_def->value_size != 4) {
>   				pr_warn("map '%s': conflicting value size %u != 4.\n",
> -					map->name, map->def.value_size);
> +					map_name, map_def->value_size);
>   				return -EINVAL;
>   			}
> -			map->def.value_size = 4;
> -			t = btf__type_by_id(obj->btf, m->type);
> +			map_def->value_size = 4;
> +			t = btf__type_by_id(btf, m->type);
>   			if (!t) {
>   				pr_warn("map '%s': map-in-map inner type [%d] not found.\n",
> -					map->name, m->type);
> +					map_name, m->type);
>   				return -EINVAL;
>   			}
>   			if (!btf_is_array(t) || btf_array(t)->nelems) {
>   				pr_warn("map '%s': map-in-map inner spec is not a zero-sized array.\n",
> -					map->name);
> +					map_name);
>   				return -EINVAL;
>   			}
> -			t = skip_mods_and_typedefs(obj->btf, btf_array(t)->type,
> -						   NULL);
> +			t = skip_mods_and_typedefs(btf, btf_array(t)->type, NULL);
>   			if (!btf_is_ptr(t)) {
>   				pr_warn("map '%s': map-in-map inner def is of unexpected kind %s.\n",
> -					map->name, btf_kind_str(t));
> +					map_name, btf_kind_str(t));
>   				return -EINVAL;
>   			}
> -			t = skip_mods_and_typedefs(obj->btf, t->type, NULL);
> +			t = skip_mods_and_typedefs(btf, t->type, NULL);
>   			if (!btf_is_struct(t)) {
>   				pr_warn("map '%s': map-in-map inner def is of unexpected kind %s.\n",
> -					map->name, btf_kind_str(t));
> +					map_name, btf_kind_str(t));
>   				return -EINVAL;
>   			}
>   
> -			map->inner_map = calloc(1, sizeof(*map->inner_map));
> -			if (!map->inner_map)
> -				return -ENOMEM;
> -			map->inner_map->fd = -1;
> -			map->inner_map->sec_idx = obj->efile.btf_maps_shndx;

The refactoring didn't set map->inner_map->sec_idx. I guess since 
inner_map is only used internally by libbpf, so it does not
have a user visible sec_idx and hence useless? It is worthwhile to
mention in the commit message for this difference, I think.

> -			map->inner_map->name = malloc(strlen(map->name) +
> -						      sizeof(".inner") + 1);
> -			if (!map->inner_map->name)
> -				return -ENOMEM;
> -			sprintf(map->inner_map->name, "%s.inner", map->name);
> -
> -			err = parse_btf_map_def(obj, map->inner_map, t, strict,
> -						true /* is_inner */, NULL);
> +			snprintf(inner_map_name, sizeof(inner_map_name), "%s.inner", map_name);
> +			err = parse_btf_map_def(inner_map_name, btf, t, strict, inner_def, NULL);
>   			if (err)
>   				return err;
> +
> +			map_def->parts |= MAP_DEF_INNER_MAP;
>   		} else if (strcmp(name, "pinning") == 0) {
>   			__u32 val;
> -			int err;
>   
>   			if (is_inner) {
> -				pr_debug("map '%s': inner def can't be pinned.\n",
> -					 map->name);
> +				pr_warn("map '%s': inner def can't be pinned.\n", map_name);
>   				return -EINVAL;
>   			}
> -			if (!get_map_field_int(map->name, obj->btf, m, &val))
> +			if (!get_map_field_int(map_name, btf, m, &val))
>   				return -EINVAL;
> -			pr_debug("map '%s': found pinning = %u.\n",
> -				 map->name, val);
> -
> -			if (val != LIBBPF_PIN_NONE &&
> -			    val != LIBBPF_PIN_BY_NAME) {
> +			if (val != LIBBPF_PIN_NONE && val != LIBBPF_PIN_BY_NAME) {
>   				pr_warn("map '%s': invalid pinning value %u.\n",
> -					map->name, val);
> +					map_name, val);
>   				return -EINVAL;
>   			}
> -			if (val == LIBBPF_PIN_BY_NAME) {
> -				err = build_map_pin_path(map, pin_root_path);
> -				if (err) {
> -					pr_warn("map '%s': couldn't build pin path.\n",
> -						map->name);
> -					return err;
> -				}
> -			}
> +			map_def->pinning = val;
> +			map_def->parts |= MAP_DEF_PINNING;
>   		} else {
>   			if (strict) {
> -				pr_warn("map '%s': unknown field '%s'.\n",
> -					map->name, name);
> +				pr_warn("map '%s': unknown field '%s'.\n", map_name, name);
>   				return -ENOTSUP;
>   			}
> -			pr_debug("map '%s': ignoring unknown field '%s'.\n",
> -				 map->name, name);
> +			pr_debug("map '%s': ignoring unknown field '%s'.\n", map_name, name);
>   		}
>   	}
>   
> -	if (map->def.type == BPF_MAP_TYPE_UNSPEC) {
> -		pr_warn("map '%s': map type isn't specified.\n", map->name);
> +	if (map_def->map_type == BPF_MAP_TYPE_UNSPEC) {
> +		pr_warn("map '%s': map type isn't specified.\n", map_name);
>   		return -EINVAL;
>   	}
>   
>   	return 0;
>   }
>   
> +static void fill_map_from_def(struct bpf_map *map, const struct btf_map_def *def)
> +{
[...]
> +}
> +
>   static int bpf_object__init_user_btf_map(struct bpf_object *obj,
>   					 const struct btf_type *sec,
>   					 int var_idx, int sec_idx,
>   					 const Elf_Data *data, bool strict,
>   					 const char *pin_root_path)
>   {
> +	struct btf_map_def map_def = {}, inner_def = {};
>   	const struct btf_type *var, *def;
>   	const struct btf_var_secinfo *vi;
>   	const struct btf_var *var_extra;
>   	const char *map_name;
>   	struct bpf_map *map;
> +	int err;
>   
>   	vi = btf_var_secinfos(sec) + var_idx;
>   	var = btf__type_by_id(obj->btf, vi->type);
> @@ -2327,7 +2334,34 @@ static int bpf_object__init_user_btf_map(struct bpf_object *obj,
>   	pr_debug("map '%s': at sec_idx %d, offset %zu.\n",
>   		 map_name, map->sec_idx, map->sec_offset);
>   
> -	return parse_btf_map_def(obj, map, def, strict, false, pin_root_path);
> +	err = parse_btf_map_def(map->name, obj->btf, def, strict, &map_def, &inner_def);
> +	if (err)
> +		return err;
> +
> +	fill_map_from_def(map, &map_def);
> +
> +	if (map_def.pinning == LIBBPF_PIN_BY_NAME) {
> +		err = build_map_pin_path(map, pin_root_path);
> +		if (err) {
> +			pr_warn("map '%s': couldn't build pin path.\n", map->name);
> +			return err;
> +		}
> +	}
> +
> +	if (map_def.parts & MAP_DEF_INNER_MAP) {
> +		map->inner_map = calloc(1, sizeof(*map->inner_map));
> +		if (!map->inner_map)
> +			return -ENOMEM;
> +		map->inner_map->fd = -1;

missing set map->inner_map->sec_idx here.

> +		map->inner_map->name = malloc(strlen(map_name) + sizeof(".inner") + 1);
> +		if (!map->inner_map->name)
> +			return -ENOMEM;
> +		sprintf(map->inner_map->name, "%s.inner", map_name);
> +
> +		fill_map_from_def(map->inner_map, &inner_def);
> +	}
> +
> +	return 0;
>   }
>   
>   static int bpf_object__init_user_btf_maps(struct bpf_object *obj, bool strict,
> diff --git a/tools/lib/bpf/libbpf_internal.h b/tools/lib/bpf/libbpf_internal.h
> index 92b7eae10c6d..17883073710c 100644
> --- a/tools/lib/bpf/libbpf_internal.h
> +++ b/tools/lib/bpf/libbpf_internal.h
> @@ -138,6 +138,38 @@ static inline __u32 btf_type_info(int kind, int vlen, int kflag)
>   	return (kflag << 31) | (kind << 24) | vlen;
>   }
>   
[...]

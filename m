Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E3BE3010A9
	for <lists+netdev@lfdr.de>; Sat, 23 Jan 2021 00:12:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728360AbhAVXJ7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 18:09:59 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:45534 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730148AbhAVTiz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jan 2021 14:38:55 -0500
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 10MJ8oG3001228;
        Fri, 22 Jan 2021 11:37:29 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=HQS4HSF2Q/kZDh3Ba6iQ5L1/Y3PUQjgEOaHMN70bBuE=;
 b=k5yfHgsjcgI0S8iaF3CbXSPl+qRCsf/gekY6BKUUrDYSAe5P2ibvyS2ai0nQrJK+ervx
 AVIcIfBmcK/xV0nTBDw6xzJqN/hznugYBKwpSOvLie0wlLSbg/XemKy29ypGBnXhxRNV
 6wEe3tfd32ALWXVNkjtOYwg6W3rts5louBE= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 367scpuqth-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 22 Jan 2021 11:37:29 -0800
Received: from NAM02-CY1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 22 Jan 2021 11:37:28 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O66bbWM0Prk/88stZtc300ru9+EDB6Z+afGuNmjc015zlfpWtl1k+6I1Ud5Dm5FhIHaam8OYM18XbQS40I8M0vhKcnunE20nUYHJbP9I9D59A919aqXhj9G9e7IS2kJu0mJlCJOp5W1h3+/OOm/qVCQbto6HMK8FKX6l/pDcgbxKZYTP7VmGpfrISOKyk9jH7XL9UfsemnQr3utxPhPqYQSQNxbmvHigVQ0650Qa9vq56ITOfXoUXrerRgvwQr9sqLInwTqPz01FyctGwWQaeejmht85L/BIUp0Tizf+XG+XAm9W1qvG0L0pYCPR0AH7ihpQaBONxDw40TziVgmVwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HQS4HSF2Q/kZDh3Ba6iQ5L1/Y3PUQjgEOaHMN70bBuE=;
 b=CQkuTMZcwqNauoz39kDvQlS657+LsQ7K/nqezHsjRp6ptF4lD82sd/m9jPlYdzjHXIIYSfUn/RDmghwiIiCj02j8B9tkQzwB2ClaTm3/WoVNxPnDaOgGwEXHtbbt4DP8jpI9BBDibfk1FHnH3CwMne6Ex3lyYAnlYm0l0xyeT2JKTnHbak0HR0dIjkm77stz2s0+O1KH61VhqrUdMAIOXfkAxLgd4Z2qrcoasfMsYx0A2vM5rvaN/WpH8cuOv/L+Ol198RhS/vbHIZnOuHLMhbFUiFMIa9ZHOzEFmH2CTmkDLfOBb4FYWf1F0peVXHOdzBiaQIYdoQ8CBFJ6YMSxMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HQS4HSF2Q/kZDh3Ba6iQ5L1/Y3PUQjgEOaHMN70bBuE=;
 b=Jc+1DYMwcIXn/obzMYyV+LhnqbYBPs+0w7s4cZ8FjpBUdH2pVxY5kuReLCCS8/yvrbKTn6vHbYuFPV7vfSagTGEPBSoB4CJ0Y7pzlsYh74xqJczE2Sq+akxnSzp4cFnJLM/TK8a7NhwOBxU6Ehc8px8j5eLDLYFDBI1CYv4fO2g=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4119.namprd15.prod.outlook.com (2603:10b6:a02:cd::20)
 by SJ0PR15MB4201.namprd15.prod.outlook.com (2603:10b6:a03:2ab::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.15; Fri, 22 Jan
 2021 19:37:27 +0000
Received: from BYAPR15MB4119.namprd15.prod.outlook.com
 ([fe80::2cfe:c26b:fd06:6c26]) by BYAPR15MB4119.namprd15.prod.outlook.com
 ([fe80::2cfe:c26b:fd06:6c26%6]) with mapi id 15.20.3784.015; Fri, 22 Jan 2021
 19:37:27 +0000
Date:   Fri, 22 Jan 2021 11:37:23 -0800
From:   Andrey Ignatov <rdna@fb.com>
To:     Stanislav Fomichev <sdf@google.com>,
        Martin KaFai Lau <kafai@fb.com>
CC:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>, <ast@kernel.org>,
        <daniel@iogearbox.net>
Subject: Re: [PATCH bpf-next 1/2] bpf: allow rewriting to ports under
 ip_unprivileged_port_start
Message-ID: <YAspc5rk2sNWojDQ@rdna-mbp.dhcp.thefacebook.com>
References: <20210121012241.2109147-1-sdf@google.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210121012241.2109147-1-sdf@google.com>
X-Originating-IP: [2620:10d:c090:400::5:363d]
X-ClientProxiedBy: MW4PR03CA0126.namprd03.prod.outlook.com
 (2603:10b6:303:8c::11) To BYAPR15MB4119.namprd15.prod.outlook.com
 (2603:10b6:a02:cd::20)
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (2620:10d:c090:400::5:363d) by MW4PR03CA0126.namprd03.prod.outlook.com (2603:10b6:303:8c::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.12 via Frontend Transport; Fri, 22 Jan 2021 19:37:26 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8328dc6f-05ae-4101-1d49-08d8bf0d25fb
X-MS-TrafficTypeDiagnostic: SJ0PR15MB4201:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SJ0PR15MB4201A77C8413B6B9BED193C5A8A09@SJ0PR15MB4201.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7Utcw8V7nUGcavVg+d1ktkDl0VN1mWZ3svlsbfz1WYHQqZxqRnUXhlg2wETzfikjclAAVAQGBrbDItBz8zff2n7aQqcRmw2RV/WGAurludhc57KiUvbTIngWiVUqRgcCEL8NQip6LVvthnmxCnU/DpnHF8bSMmso9XtaGQASB8++SvTnhICCNcXARJ2HNj0ECBRbwd6LO+Fgpoik4ewdsFGs0Um/6qleLX38ft8LjGt4nJVLBKn9hXiC7hg3U0YOW9JGpLwHsIDAycTnYgUVqVZl+MzDCpv7XcZvwNs4fJ4eBxJVmX4zoUn4KZPA34KKezrVKVmsNFgHyJ3xmxDcjI8+vsrKutLAJ/YEAR1Y4djcF3IPsi+Y2aLpQvgDaVAC2lN5W1h3jYG/36nNJ1q6sKcG1n3+KpVoRXM06SvwXGDh03PkfblX4d4YeQX2nbqKmVJQuaJIYSknp9u8hqtd4A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4119.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(396003)(366004)(376002)(346002)(136003)(8936002)(6486002)(9686003)(6636002)(4326008)(6666004)(5660300002)(86362001)(478600001)(66946007)(8676002)(83380400001)(110136005)(6496006)(52116002)(316002)(66476007)(66556008)(966005)(2906002)(186003)(16526019);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?Y0dHcmYvYTRGcVN1ampNYnU4YlRGL3JXbnVxWUlIUjAwMCtqa2xFQWJSRnFx?=
 =?utf-8?B?OTEzYndFYlgyZHRCNXkyZWcwY0tqN0Fuek0vUFo5S25Ya012YTltR0pSdXBM?=
 =?utf-8?B?K21jMDNNNkVwWVlRUE1FVG9GNkxRMlRlTjIvQndxaG5CZ3Qzd3grbjU2ME9Q?=
 =?utf-8?B?SmE5Vzd6cTNQc2xFYW5rM1ExZTF2WWNyRlF6dkgvaldBNEZLUlQvMGxNcVZq?=
 =?utf-8?B?YnNhUEVhNVluSE9hUjQ4dG44bWUydU1RamJxVmNMeFRkdGpQWkIzZzVTRFh6?=
 =?utf-8?B?WDhzUzhqS3d4RVI2b3JqLy9qS2tpOHNpYTFyV01OZzAxUjl4N1lpbmp3ejRF?=
 =?utf-8?B?N2svd1N3T3pyODRFMmx2R2x2UmRtdHZCMHE4dlpSY2s2QWlIM3FhWFpCa3JP?=
 =?utf-8?B?eVltRkVmd3M5VW5QNTVPRkVscm43MDRRQ1FaWUhKTXdDNG43TUc4S0x2TEww?=
 =?utf-8?B?eThobG0rRTdYNHVGVk5DNkxQSHdyUGhsMGhIMkF1dnUrS1p1d3gyZm5xQkJT?=
 =?utf-8?B?T1VPdmZ1dkwvcFdmMUtWN1I1NkFYWFVpOHBHRUo5TmptSmxUcXhMTkxUd3FR?=
 =?utf-8?B?VzExLzF3aUJqdEtiZWlqU0ZLYkZzc0VEM1I4Y3ExL2gweTUwVTMxNGxVNUdt?=
 =?utf-8?B?Um8xdWF0eWJlWDVRWUhtUDlKR1VuaEVIUUc0R05RQStiMnZZTi9pNEhkZUdQ?=
 =?utf-8?B?RXBEQ3FudzF1aE1BRXQxVkQ3VnhjaVpwY1dScWRhMWNrUXNIUjhuNXRqL1lW?=
 =?utf-8?B?U0NBY0FRRmlrNFBVVkorYjVsTkZyZkc5NU1kR2FhY0lpczRHVjZFaFJBQWtS?=
 =?utf-8?B?TnU5Sm0xWWl5dWYvNWxVd3VoT1BPWEdCNXRSZzJyRXhWZ3gzUHl2UFZ5Vk5N?=
 =?utf-8?B?L3lIaGdUMXErK1pxWDN3d0ViRVVJN0NIK2dDemlVQmdpcGZDMmQ0UVdLS2la?=
 =?utf-8?B?b3ErY1FIV0l2QzFiVER4YkYvSGpmS2ZBZ1ZyYjR5TS9WQnJuUk5QOURyL25q?=
 =?utf-8?B?ck5CWXRVTkJ4UlYxNWo1T3B6dUR4UGVPU3IrM24zS0o4Q0tKMlQybnhiZHBE?=
 =?utf-8?B?T096ekhNZzNiT3kvdENRRUlrbkdUSUQweG5TMzNEVitYK09YaklCQ09udVdM?=
 =?utf-8?B?SHJsYTBjejNkL1EySDdJSENXYWJRTjR6cW8wbHRvSGZpMHFjZXhXSCtBN3Vi?=
 =?utf-8?B?UmZIbVlJa2dZbU1nbW5reXNpTlVJMjUxMEVpbG1hcjh1Yjl1MjNyZ3lFWGxM?=
 =?utf-8?B?R1VmWFdsZEJGMG5KWmR4UWdTWUdkRGZyVFdDbDAzVU80SUJDU3lEaXNSVmpF?=
 =?utf-8?B?SzlJMGd0RlJXQ0Y5aTBCb201dFdXaXBCL0tIL1hNblBrZmpxQW9ncTRlRFNM?=
 =?utf-8?B?ekk1c09WSHAzVXc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 8328dc6f-05ae-4101-1d49-08d8bf0d25fb
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4119.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jan 2021 19:37:27.0546
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Oou4Y/D0MTORwrEzwQemrAFGZR9XmJk0rrl4JUUBfb2K6Kyj5txiiiMRhsXrDK5i
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR15MB4201
X-OriginatorOrg: fb.com
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-22_14:2021-01-22,2021-01-22 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0
 impostorscore=0 priorityscore=1501 mlxscore=0 suspectscore=0 adultscore=0
 phishscore=0 mlxlogscore=999 malwarescore=0 clxscore=1011 spamscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101220099
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Stanislav Fomichev <sdf@google.com> [Wed, 2021-01-20 18:09 -0800]:
> At the moment, BPF_CGROUP_INET{4,6}_BIND hooks can rewrite user_port
> to the privileged ones (< ip_unprivileged_port_start), but it will
> be rejected later on in the __inet_bind or __inet6_bind.
>
> Let's export 'port_changed' event from the BPF program and bypass
> ip_unprivileged_port_start range check when we've seen that
> the program explicitly overrode the port. This is accomplished
> by generating instructions to set ctx->port_changed along with
> updating ctx->user_port.
> 
> Signed-off-by: Stanislav Fomichev <sdf@google.com>
> ---
...
> @@ -244,17 +245,27 @@ int bpf_percpu_cgroup_storage_update(struct bpf_map *map, void *key,
>  	if (cgroup_bpf_enabled(type))	{				       \
>  		lock_sock(sk);						       \
>  		__ret = __cgroup_bpf_run_filter_sock_addr(sk, uaddr, type,     \
> -							  t_ctx);	       \
> +							  t_ctx, NULL);	       \
>  		release_sock(sk);					       \
>  	}								       \
>  	__ret;								       \
>  })
>  
> -#define BPF_CGROUP_RUN_PROG_INET4_BIND_LOCK(sk, uaddr)			       \
> -	BPF_CGROUP_RUN_SA_PROG_LOCK(sk, uaddr, BPF_CGROUP_INET4_BIND, NULL)
> -
> -#define BPF_CGROUP_RUN_PROG_INET6_BIND_LOCK(sk, uaddr)			       \
> -	BPF_CGROUP_RUN_SA_PROG_LOCK(sk, uaddr, BPF_CGROUP_INET6_BIND, NULL)
> +#define BPF_CGROUP_RUN_PROG_INET_BIND_LOCK(sk, uaddr, type, flags)	       \
> +({									       \
> +	bool port_changed = false;					       \

I see the discussion with Martin in [0] on the program overriding the
port but setting exactly same value as it already contains. Commenting
on this patch since the code is here.

From what I understand there is no use-case to support overriding the
port w/o changing the value to just bypass the capability. In this case
the code can be simplified.

Here instead of introducing port_changed you can just remember the
original ((struct sockaddr_in *)uaddr)->sin_port or
((struct sockaddr_in6 *)uaddr)->sin6_port (they have same offset/size so
it can be simplified same way as in sock_addr_convert_ctx_access() for
user_port) ...

> +	int __ret = 0;							       \
> +	if (cgroup_bpf_enabled(type))	{				       \
> +		lock_sock(sk);						       \
> +		__ret = __cgroup_bpf_run_filter_sock_addr(sk, uaddr, type,     \
> +							  NULL,		       \
> +							  &port_changed);      \
> +		release_sock(sk);					       \
> +		if (port_changed)					       \

... and then just compare the original and the new ports here.

The benefits will be:
* no need to introduce port_changed field in struct bpf_sock_addr_kern;
* no need to do change program instructions;
* no need to think about compiler optimizing out those instructions;
* no need to think about multiple programs coordination, the flag will
  be set only if port has actually changed what is easy to reason about
  from user perspective.

wdyt?

> +			*flags |= BIND_NO_CAP_NET_BIND_SERVICE;		       \
> +	}								       \
> +	__ret;								       \
> +})
>  
>  #define BPF_CGROUP_PRE_CONNECT_ENABLED(sk)				       \
>  	((cgroup_bpf_enabled(BPF_CGROUP_INET4_CONNECT) ||		       \
> @@ -453,8 +464,7 @@ static inline int bpf_percpu_cgroup_storage_update(struct bpf_map *map,
>  #define BPF_CGROUP_RUN_PROG_INET_EGRESS(sk,skb) ({ 0; })
>  #define BPF_CGROUP_RUN_PROG_INET_SOCK(sk) ({ 0; })
>  #define BPF_CGROUP_RUN_PROG_INET_SOCK_RELEASE(sk) ({ 0; })
> -#define BPF_CGROUP_RUN_PROG_INET4_BIND_LOCK(sk, uaddr) ({ 0; })
> -#define BPF_CGROUP_RUN_PROG_INET6_BIND_LOCK(sk, uaddr) ({ 0; })
> +#define BPF_CGROUP_RUN_PROG_INET_BIND_LOCK(sk, uaddr, type, flags) ({ 0; })
>  #define BPF_CGROUP_RUN_PROG_INET4_POST_BIND(sk) ({ 0; })
>  #define BPF_CGROUP_RUN_PROG_INET6_POST_BIND(sk) ({ 0; })
>  #define BPF_CGROUP_RUN_PROG_INET4_CONNECT(sk, uaddr) ({ 0; })
...

[0] https://lore.kernel.org/bpf/20210121223330.pyk4ljtjirm2zlay@kafai-mbp/

-- 
Andrey Ignatov

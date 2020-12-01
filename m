Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32A542CABC6
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 20:23:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392324AbgLATWW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 14:22:22 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:3020 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731231AbgLATWV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Dec 2020 14:22:21 -0500
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0B1JK4s9030730;
        Tue, 1 Dec 2020 11:21:22 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=MnpIeuzBVTkzhzFrmvz//va4EBm7+fRPDvMGoZ3dTps=;
 b=jDrT3yIYHUvtUL2eooBXJBCEMw5liOgbx6ds6Ees9onMbOjrnhRPzlIrgK5Y5f1IUhse
 y/lxa2oYgCJ8ryPHuL4g2dGl5SwwK4i6O8rU9J0fWU5KXmTypAPFxrxyjvGuabXOzJ4g
 hYBX69egF/fRPmBj8bgJfecu+wkN/lv/3H4= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 354hsymjks-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 01 Dec 2020 11:21:22 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.196) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 1 Dec 2020 11:21:21 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PBZP4rCHP95DomsIu5DQ4Ui9bJ35izgZRXFMD0gWJG+vq0x8MBc/JlzyLfFjXQK+RdO2xk18+mE0y/0SsYBQHCSfFsOOVXKBCgtGn35kKeKgesFRsSRoYfGAJaXd1YgccHrEw3AmHff1gBHt3BLMkCeIyGEdFIcNlfUuNkIp7EndSDGN2RK9+XHjFzU4jem7MqdaAASxjpiXb3MKt12QtqqCNKbP6SF0mlNkLN+qeZop0gFgkF6JnVvQUPbkWeI5/oUBPk0esPlMKmWe0ckStZgxxGARox+VZIePb0HCDolpHvzCk6yV5qixxAlGgwhv/Tp3uyobodFW8dTKsMjqTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MnpIeuzBVTkzhzFrmvz//va4EBm7+fRPDvMGoZ3dTps=;
 b=kE7DWEq3nqEKi1D2JvHxpm5kPq9QDBlHpwJrDJJnDw9hDIVAcvUa1qQda0l5b3BcaH1UTlDZUrpYSgVB0CjhAIxUXXFh2eg0TvyfyJyZlPXVBAARR8ARm/+eRVA8j76IKnU8jW++9D9RgkI8vXh3yweA4NI8lzFIL42DSM7iupqyU1lhUxambBK6tOt/UGVlP0XTGMtbDcbNeorlrJ1qsuFbWIMzpk06tZZbmo0y6ig0Udz7nz+Nn12/M0Sm0u3JuQezYcu/NplJsUMTToM1UJh9I8o7uSxiMtFW0TUGacJJvITqoGq1gdOik5m88clupuFQoygyHBBunKBTNSmfNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MnpIeuzBVTkzhzFrmvz//va4EBm7+fRPDvMGoZ3dTps=;
 b=Jn7BkNinvyh4DVv1mrSfPp9e1qrSKCrJ9bzQolRddNguLWcQQhHtwFT8fw6bSSETKFB2q/P/FHu32tFa2Niaq6YPpG169wz+9Ceq9Vp1HRKbbZFoND2fWAdeqdQM+ZuzcORRiANVS/uO/nSmKV80juZgz4VFehIhDbjJ2BNlQT0=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4119.namprd15.prod.outlook.com (2603:10b6:a02:cd::20)
 by BYAPR15MB2568.namprd15.prod.outlook.com (2603:10b6:a03:14c::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.22; Tue, 1 Dec
 2020 19:21:19 +0000
Received: from BYAPR15MB4119.namprd15.prod.outlook.com
 ([fe80::258a:fe57:2331:d1ee]) by BYAPR15MB4119.namprd15.prod.outlook.com
 ([fe80::258a:fe57:2331:d1ee%7]) with mapi id 15.20.3611.031; Tue, 1 Dec 2020
 19:21:19 +0000
Date:   Tue, 1 Dec 2020 11:21:15 -0800
From:   Andrey Ignatov <rdna@fb.com>
To:     Stanislav Fomichev <sdf@google.com>
CC:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <davem@davemloft.net>, <ast@kernel.org>, <daniel@iogearbox.net>
Subject: Re: [PATCH bpf-next 2/3] bpf: allow bpf_{s,g}etsockopt from cgroup
 bind{4,6} hooks
Message-ID: <20201201192115.GA27988@rdna-mbp.dhcp.thefacebook.com>
References: <20201118001742.85005-1-sdf@google.com>
 <20201118001742.85005-3-sdf@google.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20201118001742.85005-3-sdf@google.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Originating-IP: [2620:10d:c090:400::5:71c]
X-ClientProxiedBy: MWHPR22CA0052.namprd22.prod.outlook.com
 (2603:10b6:300:12a::14) To BYAPR15MB4119.namprd15.prod.outlook.com
 (2603:10b6:a02:cd::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (2620:10d:c090:400::5:71c) by MWHPR22CA0052.namprd22.prod.outlook.com (2603:10b6:300:12a::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.17 via Frontend Transport; Tue, 1 Dec 2020 19:21:18 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dd59622e-c5a7-4de5-ff6a-08d8962e47ab
X-MS-TrafficTypeDiagnostic: BYAPR15MB2568:
X-Microsoft-Antispam-PRVS: <BYAPR15MB2568A3FDE4E98A299D404DA0A8F40@BYAPR15MB2568.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ydfCTgu14obplaylnLiYxIZJnpSYzqcb3FI+1hfnp2m7NbfVGJ4+/ao02T+nV26qw0rD/So46i0QBLUpkBHrikVNExY6O1ThxUEUnQQprlrF6TLNK3XNLzbQcfDZCKAd+M82q8r2ExoSORNOjmg9aKx2pcjlRu18XF5BEPRT/UO/NXAxbNOdY/e+IL/C3ddQnNGfAbr9tgC0mYWW6OLCM55vic2DQgkQVcE29x+/LnI7spBWDOXw6PRk9dI/kAgkP78WHn69FhIHRdrqPv7o6J/raiN5wqP7ATVg0ET+sfm2JeLMvnMPX+c5/wPW2OQnXnCg76lnLRPh8HI64FQgCg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4119.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(366004)(396003)(136003)(39860400002)(376002)(478600001)(9686003)(6916009)(186003)(16526019)(52116002)(86362001)(316002)(6496006)(8676002)(83380400001)(33656002)(8936002)(6486002)(4001150100001)(66556008)(5660300002)(66946007)(66476007)(6666004)(4326008)(2906002)(1076003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?UHM1QkxiYTlJWjFuWVhoTmV0VU1SNkNSU2tvVnVpalcxSkhQQkRYbDl4NGFw?=
 =?utf-8?B?eEd6TWczbzRXZlB2a1poOG82VGlUTVhpdXBHdnA2SzBuMVcwbHBvWWd5aVVL?=
 =?utf-8?B?Uk5FTXhzNHhiaENkUlZOREhxbGlZQ29NUzZBLzJTL0QvL040eVhJUmhFTEdM?=
 =?utf-8?B?Y1Fvc3JrbFF5b0pOT0pCS2k1Z04wcVVta245MXl4WU1EQWprYWJQWVB1bUtr?=
 =?utf-8?B?ZC9lNWJQamtjZlVyVXoxS3dnS0hHTlF2WHpUc2RMT1AwY09FNGhFa29kWWV2?=
 =?utf-8?B?UG1HdjhJVzZxTmVTd0ZsbWd3aUFrOVo3d2o2MGRPK0dpRnBhaDRhOEtpZUZh?=
 =?utf-8?B?blFkM0tYK2tIWU9XRXMxQWlwdHE3Z3lMQjdqY1ZUcTdGbVFHSkNCZ3kwRllR?=
 =?utf-8?B?YVdMazZNMEFjQWFZTTZIdXFnSjNQUTFTOFpPejBqdHZvamRrTnFET2laaGxG?=
 =?utf-8?B?WUEyVFM3bVl4ODdHQldmOU9mcnRtYWV5NXJNQ3Rad1RpTGhNdzZOU25qdzg4?=
 =?utf-8?B?SmdTNDNiK2o0NDhJRHhCS0J3ZFRBSkVSTVlnQmszRDR2TFNmOUZaZGlEK2xh?=
 =?utf-8?B?NWlLYVdkNnhGS3d1N21WRlBUTk5TdjBzU1ppSkJnM09EVXltYUZiSldudkww?=
 =?utf-8?B?MnZ5YW4zc05SQlVJSHFzOVRBcSs3MjZaUkh3T2tNOGlJUXo3cUk4YmgxQ2NQ?=
 =?utf-8?B?WmwwNHZtend0dU56empHQ3V4KytnRWRVcnRlNkkzUEtFdVJBNkQvSGJWbjV2?=
 =?utf-8?B?clUwK1BTUW52N0ZKbjRYZWRQb0hxak4waGdFa3A0bG5ld2JGVDdoa2poSUJu?=
 =?utf-8?B?NjNRdWV0YmtUbmxDc1VHMlNETGhWVW9iZEl1K2tDZ0VDZ0R1dExRblFsb0U5?=
 =?utf-8?B?UEVjeGRFMDVXOVNlZlNLcjBBTTBNK0FmZzZ6ZmFRbUFOOGo1YXZSZXhlRkxt?=
 =?utf-8?B?QjMwUmExejlGNmdoNmE0VWsyTTcyZ0NHYkZqTUR5MXpIU3ppVndtbm1VYkls?=
 =?utf-8?B?ZDhvQVkyUnJMd3B1aHZYRmtyVlFrOVRRd3VzSjQ4cG43dDFsK3FlYkJnZjRY?=
 =?utf-8?B?NDFodTI2NmRncmNacmh5MVkwTzVHRnQ5OWxmRDNBdjJ5UVBjNVlxMUZDbkJy?=
 =?utf-8?B?VU5NL0VKY0ZtWDZ4SFBmTTZpeHAvY25zcTNhVFA0emNia25OOVZvME9KeU1o?=
 =?utf-8?B?TVQvS0FQRlNDWlY5WHRQWU5INmo2SitOT2VtVVlhMjFuMGJ1RUtBSFJvdHhF?=
 =?utf-8?B?YmE2djl0ZURsVEovVytqMTFNQ2MyUDBuS29ZZWNtZTBUU0xza1daUU1CNjRQ?=
 =?utf-8?B?WE5hNUM2dE41UHFRUDUxT3gvVStPVHhoeGRRVno0aVRNRTBhMUc4NTZ1MStS?=
 =?utf-8?B?MkwzSkJ1T1hTQUE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: dd59622e-c5a7-4de5-ff6a-08d8962e47ab
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4119.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Dec 2020 19:21:19.1899
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: p5CHr5i0jMzl4swlr5oNF94+RyIF2Q3Hu8CCiPHeNUTLIECCt9C4Y8E7ZlcDp98t
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2568
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-12-01_09:2020-11-30,2020-12-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015
 adultscore=0 priorityscore=1501 impostorscore=0 mlxscore=0 spamscore=0
 bulkscore=0 lowpriorityscore=0 suspectscore=0 mlxlogscore=999 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012010117
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Stanislav Fomichev <sdf@google.com> [Tue, 2020-11-17 16:18 -0800]:
> I have to now lock/unlock socket for the bind hook execution.
> That shouldn't cause any overhead because the socket is unbound
> and shouldn't receive any traffic.
> 
> Signed-off-by: Stanislav Fomichev <sdf@google.com>

Acked-by: Andrey Ignatov <rdna@fb.com>

> ---
>  include/linux/bpf-cgroup.h | 12 ++++++------
>  net/core/filter.c          |  4 ++++
>  net/ipv4/af_inet.c         |  2 +-
>  net/ipv6/af_inet6.c        |  2 +-
>  4 files changed, 12 insertions(+), 8 deletions(-)
> 
> diff --git a/include/linux/bpf-cgroup.h b/include/linux/bpf-cgroup.h
> index ed71bd1a0825..72e69a0e1e8c 100644
> --- a/include/linux/bpf-cgroup.h
> +++ b/include/linux/bpf-cgroup.h
> @@ -246,11 +246,11 @@ int bpf_percpu_cgroup_storage_update(struct bpf_map *map, void *key,
>  	__ret;								       \
>  })
>  
> -#define BPF_CGROUP_RUN_PROG_INET4_BIND(sk, uaddr)			       \
> -	BPF_CGROUP_RUN_SA_PROG(sk, uaddr, BPF_CGROUP_INET4_BIND)
> +#define BPF_CGROUP_RUN_PROG_INET4_BIND_LOCK(sk, uaddr)			       \
> +	BPF_CGROUP_RUN_SA_PROG_LOCK(sk, uaddr, BPF_CGROUP_INET4_BIND, NULL)
>  
> -#define BPF_CGROUP_RUN_PROG_INET6_BIND(sk, uaddr)			       \
> -	BPF_CGROUP_RUN_SA_PROG(sk, uaddr, BPF_CGROUP_INET6_BIND)
> +#define BPF_CGROUP_RUN_PROG_INET6_BIND_LOCK(sk, uaddr)			       \
> +	BPF_CGROUP_RUN_SA_PROG_LOCK(sk, uaddr, BPF_CGROUP_INET6_BIND, NULL)
>  
>  #define BPF_CGROUP_PRE_CONNECT_ENABLED(sk) (cgroup_bpf_enabled && \
>  					    sk->sk_prot->pre_connect)
> @@ -434,8 +434,8 @@ static inline int bpf_percpu_cgroup_storage_update(struct bpf_map *map,
>  #define BPF_CGROUP_RUN_PROG_INET_EGRESS(sk,skb) ({ 0; })
>  #define BPF_CGROUP_RUN_PROG_INET_SOCK(sk) ({ 0; })
>  #define BPF_CGROUP_RUN_PROG_INET_SOCK_RELEASE(sk) ({ 0; })
> -#define BPF_CGROUP_RUN_PROG_INET4_BIND(sk, uaddr) ({ 0; })
> -#define BPF_CGROUP_RUN_PROG_INET6_BIND(sk, uaddr) ({ 0; })
> +#define BPF_CGROUP_RUN_PROG_INET4_BIND_LOCK(sk, uaddr) ({ 0; })
> +#define BPF_CGROUP_RUN_PROG_INET6_BIND_LOCK(sk, uaddr) ({ 0; })
>  #define BPF_CGROUP_RUN_PROG_INET4_POST_BIND(sk) ({ 0; })
>  #define BPF_CGROUP_RUN_PROG_INET6_POST_BIND(sk) ({ 0; })
>  #define BPF_CGROUP_RUN_PROG_INET4_CONNECT(sk, uaddr) ({ 0; })
> diff --git a/net/core/filter.c b/net/core/filter.c
> index 2ca5eecebacf..21d91dcf0260 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -6995,6 +6995,8 @@ sock_addr_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
>  		return &bpf_sk_storage_delete_proto;
>  	case BPF_FUNC_setsockopt:
>  		switch (prog->expected_attach_type) {
> +		case BPF_CGROUP_INET4_BIND:
> +		case BPF_CGROUP_INET6_BIND:
>  		case BPF_CGROUP_INET4_CONNECT:
>  		case BPF_CGROUP_INET6_CONNECT:
>  			return &bpf_sock_addr_setsockopt_proto;
> @@ -7003,6 +7005,8 @@ sock_addr_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
>  		}
>  	case BPF_FUNC_getsockopt:
>  		switch (prog->expected_attach_type) {
> +		case BPF_CGROUP_INET4_BIND:
> +		case BPF_CGROUP_INET6_BIND:
>  		case BPF_CGROUP_INET4_CONNECT:
>  		case BPF_CGROUP_INET6_CONNECT:
>  			return &bpf_sock_addr_getsockopt_proto;
> diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
> index b7260c8cef2e..b94fa8eb831b 100644
> --- a/net/ipv4/af_inet.c
> +++ b/net/ipv4/af_inet.c
> @@ -450,7 +450,7 @@ int inet_bind(struct socket *sock, struct sockaddr *uaddr, int addr_len)
>  	/* BPF prog is run before any checks are done so that if the prog
>  	 * changes context in a wrong way it will be caught.
>  	 */
> -	err = BPF_CGROUP_RUN_PROG_INET4_BIND(sk, uaddr);
> +	err = BPF_CGROUP_RUN_PROG_INET4_BIND_LOCK(sk, uaddr);
>  	if (err)
>  		return err;
>  
> diff --git a/net/ipv6/af_inet6.c b/net/ipv6/af_inet6.c
> index e648fbebb167..a7e3d170af51 100644
> --- a/net/ipv6/af_inet6.c
> +++ b/net/ipv6/af_inet6.c
> @@ -451,7 +451,7 @@ int inet6_bind(struct socket *sock, struct sockaddr *uaddr, int addr_len)
>  	/* BPF prog is run before any checks are done so that if the prog
>  	 * changes context in a wrong way it will be caught.
>  	 */
> -	err = BPF_CGROUP_RUN_PROG_INET6_BIND(sk, uaddr);
> +	err = BPF_CGROUP_RUN_PROG_INET6_BIND_LOCK(sk, uaddr);
>  	if (err)
>  		return err;
>  
> -- 
> 2.29.2.299.gdc1121823c-goog
> 

-- 
Andrey Ignatov

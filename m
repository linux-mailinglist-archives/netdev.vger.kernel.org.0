Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 495F018C613
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 04:49:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727005AbgCTDtl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 23:49:41 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:27712 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726603AbgCTDtl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Mar 2020 23:49:41 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02K3fLgp023903;
        Thu, 19 Mar 2020 20:49:27 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=Vr0SaDBIMnagFHX1O+jXJs3Mew+TUU8TepYls7RtNqY=;
 b=qBCuRB6pFZGIDClx2uzh693i1AOEIniOKwa4GrnGJvPMTELRklOd8BV9Ge9NXX+rCytm
 loWxWOdW4VCe2qrBTqbDMjMpRDtX8mgwtosFh8toElPT+U8/i9Xgz4MVY5hWVBV/iE9x
 TFARIgFXLHMiLaUCeHzVIRNLK4jT0RD0VCI= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2yv6hqcfkw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 19 Mar 2020 20:49:27 -0700
Received: from NAM04-BN3-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Thu, 19 Mar 2020 20:49:25 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hkCWqnmixTPBoufaiaN5ZBfqYDaCT1h6bswTkzrv6oBfnickKL79BTtOW/25R7JI6gYRt+WoC83Vc9FXwSxwW+PU+XAjZHilmdspzuiTkRNlX0untG5k45QFfSaTMycJND1m5nYhBbRmb8u68ncEyUsu6rnUVtwiPqLUegOjwLOtgDAx//UIRJ6p03VYK2mle4Hnrkk7DKNdc0VI0lQOPWt4ENYYi0r+T3F8/8tyqddLJd9yhtCquF/x+3+a++gMntaawlzcdVCX2R5XfoM3Y599OjOikIxRgOmx+YfJYrlG+8vUveUKCP11PtVLQEq2P8i+ncIOJqLYBGEgyBI6Zw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vr0SaDBIMnagFHX1O+jXJs3Mew+TUU8TepYls7RtNqY=;
 b=kZeOvlV88KzhfJbp2LIssrAo/l8XKcOkMXko4mm5CldBLGG70xeS0o0gZZPC3cO7TvrAdW9Gj+kBqjnUZ5q68UelNrBmvWqJBCW7lA73YrYHucnHaMN1Ql7S7vYY3XVZqJJI64tOd4NcxRqza6o8Vrr5F88lmmvPSiuDgz8vsgNIqb0R5X23x8rgB6Lsn/cO5YfIoIfp06RmBj2565gHobAINyOGsKA3oMb7nzikcH8PCOSH6B/lhYTsXIJ8PEGiVIfL3QHvFUC3b+v8E1TI/e55Uq/7bdstY3YjFFB0GUCEKUXi2+502DPGe1jTYXzAxg9rZsRJW9UiC0/ejR4RKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vr0SaDBIMnagFHX1O+jXJs3Mew+TUU8TepYls7RtNqY=;
 b=Wb5syLRtebsOdTRALkCtEFDcrq4f3ePWfQ6sFy45i0TQ4zklb9qleZg4A83QdokWDmI3t77pCbINiWgYhsJ7Hd0TCWshXfDaBeg+qnmOIiz9KrYs7Eg+mUcQR/gKY0iWBIIDPQwwaPbNje6KDFHW3eJPyB4rzorkTZGyc/LzjNU=
Received: from MW3PR15MB3883.namprd15.prod.outlook.com (2603:10b6:303:51::22)
 by MW3PR15MB3946.namprd15.prod.outlook.com (2603:10b6:303:4c::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2814.18; Fri, 20 Mar
 2020 03:49:25 +0000
Received: from MW3PR15MB3883.namprd15.prod.outlook.com
 ([fe80::a49b:8546:912f:dd98]) by MW3PR15MB3883.namprd15.prod.outlook.com
 ([fe80::a49b:8546:912f:dd98%5]) with mapi id 15.20.2835.017; Fri, 20 Mar 2020
 03:49:25 +0000
Subject: Re: [PATCH bpf-next 2/2] bpf: Add tests for bpf_sk_storage to
 bpf_tcp_ca
To:     Martin KaFai Lau <kafai@fb.com>, <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        <netdev@vger.kernel.org>
References: <20200319234955.2933540-1-kafai@fb.com>
 <20200319235008.2940124-1-kafai@fb.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <dbf97cdd-9daa-6164-50d4-576dbb9ed3e4@fb.com>
Date:   Thu, 19 Mar 2020 20:49:22 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.6.0
In-Reply-To: <20200319235008.2940124-1-kafai@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CO2PR07CA0049.namprd07.prod.outlook.com (2603:10b6:100::17)
 To MW3PR15MB3883.namprd15.prod.outlook.com (2603:10b6:303:51::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from MacBook-Pro-52.local (2620:10d:c090:400::5:c5b) by CO2PR07CA0049.namprd07.prod.outlook.com (2603:10b6:100::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2835.19 via Frontend Transport; Fri, 20 Mar 2020 03:49:24 +0000
X-Originating-IP: [2620:10d:c090:400::5:c5b]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 57679082-10b0-46f8-e9df-08d7cc81ae93
X-MS-TrafficTypeDiagnostic: MW3PR15MB3946:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MW3PR15MB3946FF66533397B19C7B0CEDD3F50@MW3PR15MB3946.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:284;
X-Forefront-PRVS: 03484C0ABF
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(136003)(366004)(39860400002)(376002)(346002)(396003)(199004)(6512007)(5660300002)(6486002)(2616005)(31696002)(86362001)(36756003)(2906002)(186003)(66556008)(66946007)(66476007)(31686004)(16526019)(53546011)(8936002)(4326008)(81156014)(8676002)(478600001)(81166006)(6506007)(316002)(54906003)(52116002);DIR:OUT;SFP:1102;SCL:1;SRVR:MW3PR15MB3946;H:MW3PR15MB3883.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
Received-SPF: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3xI+NjnEI9a6Hy3bSBcqENqTZiLDMrB2KN9SogrUVLKliED7hF9wOmUZQ9Ygh483cGQgAuAkg7KXm1CNTF4IVUWqRzWYk4DtP0Yqw4oPZ26XWCOBEab14EZrPytZScZv+m5FGd81t+LAvxx6IwWZ0VNnc0hX8r8RDwMvjCoBrlZ5GfthWuuM2BWy03bPZugVwiocITxa7rjIXCNfzesfrW6bpmbEKk4QBHC29ndPizpEiM0KmuGRYlQJlpfQFh40OeKY8e9mrjBurbPSMEic5SqXfk2zw3yxy6jbg4dNBz09pqyc/aEwh/0igRUlhPn8ymGjUBDGxAvZljNdwVZPtrbfaF+1dMVJKZds3UVd7WlYeB3yQlBMxLHGasoQ9QomCWFW4wn7ssNgW2wUtgIXmLqp9926nHfkisZVOelk419jV5NRDUWqkPuX5hWglwk9
X-MS-Exchange-AntiSpam-MessageData: iRX6L70GF5kou/n9MUC6f9jF2U4rB2XKss9v9SZnpSfpMqqeuMk0O8f52afj9bvJM5L2PIr7KmzTkYZfy/bF/ikQSjZ+rDTmUFL7nF4F5z/yCL8Z6brXFaB7bhiAmU/YcRRQCd9q0x2bS/xBK6ggrjhF5DE/exiXOPNLtIiGudmFBBVNQJ6aIRS/P6HiHbIt
X-MS-Exchange-CrossTenant-Network-Message-Id: 57679082-10b0-46f8-e9df-08d7cc81ae93
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2020 03:49:25.0072
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: adP7Xd8CWSx7sLLBeZ8fMAP6D5aUMdAORjMd5+ERUwcIniyTOTxzAcL5XEaDOKGD
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR15MB3946
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-19_10:2020-03-19,2020-03-19 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 suspectscore=0 malwarescore=0 spamscore=0 priorityscore=1501 phishscore=0
 clxscore=1015 mlxlogscore=999 impostorscore=0 adultscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003200015
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/19/20 4:50 PM, Martin KaFai Lau wrote:
> This patch adds test to exercise the bpf_sk_storage_get()
> and bpf_sk_storage_delete() helper from the bpf_dctcp.c.
> 
> Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> ---
>   .../selftests/bpf/prog_tests/bpf_tcp_ca.c     | 28 +++++++++++++++++--
>   tools/testing/selftests/bpf/progs/bpf_dctcp.c | 16 +++++++++++
>   2 files changed, 41 insertions(+), 3 deletions(-)
> 
> diff --git a/tools/testing/selftests/bpf/prog_tests/bpf_tcp_ca.c b/tools/testing/selftests/bpf/prog_tests/bpf_tcp_ca.c
> index 8482bbc67eec..9aaecce0bc3c 100644
> --- a/tools/testing/selftests/bpf/prog_tests/bpf_tcp_ca.c
> +++ b/tools/testing/selftests/bpf/prog_tests/bpf_tcp_ca.c
> @@ -11,6 +11,7 @@
>   static const unsigned int total_bytes = 10 * 1024 * 1024;
>   static const struct timeval timeo_sec = { .tv_sec = 10 };
>   static const size_t timeo_optlen = sizeof(timeo_sec);
> +static int expected_stg = 0xeB9F;
>   static int stop, duration;
>   
>   static int settimeo(int fd)
> @@ -88,7 +89,7 @@ static void *server(void *arg)
>   	return NULL;
>   }
>   
> -static void do_test(const char *tcp_ca)
> +static void do_test(const char *tcp_ca, const struct bpf_map *sk_stg_map)
>   {
>   	struct sockaddr_in6 sa6 = {};
>   	ssize_t nr_recv = 0, bytes = 0;
> @@ -110,6 +111,14 @@ static void do_test(const char *tcp_ca)
>   		return;
>   	}
>   
> +	if (sk_stg_map) {
> +		err = bpf_map_update_elem(bpf_map__fd(sk_stg_map), &fd,
> +					  &expected_stg, BPF_NOEXIST);
> +		if (CHECK(err, "bpf_map_update_elem(sk_stg_map)",
> +			  "err:%d errno:%d\n", err, errno))
> +			goto done;
> +	}
> +
>   	if (settcpca(lfd, tcp_ca) || settcpca(fd, tcp_ca) ||
>   	    settimeo(lfd) || settimeo(fd))
>   		goto done;
> @@ -149,6 +158,16 @@ static void do_test(const char *tcp_ca)
>   	CHECK(bytes != total_bytes, "recv", "%zd != %u nr_recv:%zd errno:%d\n",
>   	      bytes, total_bytes, nr_recv, errno);

Should the control go to "wait_thread" here if failure?

>   
> +	if (sk_stg_map) {
> +		int tmp_stg;
> +
> +		err = bpf_map_lookup_elem(bpf_map__fd(sk_stg_map), &fd,
> +					  &tmp_stg);
> +		CHECK(!err || errno != ENOENT,
> +		      "bpf_map_lookup_elem(sk_stg_map)",
> +		      "err:%d errno:%d\n", err, errno);
> +	}
> +
>   wait_thread:
>   	WRITE_ONCE(stop, 1);
>   	pthread_join(srv_thread, &thread_ret);
> @@ -175,7 +194,7 @@ static void test_cubic(void)
>   		return;
>   	}
>   
> -	do_test("bpf_cubic");
> +	do_test("bpf_cubic", NULL);
>   
>   	bpf_link__destroy(link);
>   	bpf_cubic__destroy(cubic_skel);
> @@ -197,7 +216,10 @@ static void test_dctcp(void)
>   		return;
>   	}
>   
> -	do_test("bpf_dctcp");
> +	do_test("bpf_dctcp", dctcp_skel->maps.sk_stg_map);
> +	CHECK(dctcp_skel->bss->stg_result != expected_stg,
> +	      "Unexpected stg_result", "stg_result (%x) != expected_stg (%x)\n",
> +	      dctcp_skel->bss->stg_result, expected_stg);
>   
>   	bpf_link__destroy(link);
>   	bpf_dctcp__destroy(dctcp_skel);
> diff --git a/tools/testing/selftests/bpf/progs/bpf_dctcp.c b/tools/testing/selftests/bpf/progs/bpf_dctcp.c
> index 127ea762a062..5c1fc584f3ae 100644
> --- a/tools/testing/selftests/bpf/progs/bpf_dctcp.c
> +++ b/tools/testing/selftests/bpf/progs/bpf_dctcp.c
> @@ -6,6 +6,7 @@
>    * the kernel BPF logic.
>    */
>   
> +#include <stddef.h>
>   #include <linux/bpf.h>
>   #include <linux/types.h>
>   #include <bpf/bpf_helpers.h>
> @@ -14,6 +15,15 @@
>   
>   char _license[] SEC("license") = "GPL";
>   
> +static volatile int stg_result;

"int stg_result = 0;" should work too.

> +
> +struct {
> +	__uint(type, BPF_MAP_TYPE_SK_STORAGE);
> +	__uint(map_flags, BPF_F_NO_PREALLOC);
> +	__type(key, int);
> +	__type(value, int);
> +} sk_stg_map SEC(".maps");
> +
>   #define DCTCP_MAX_ALPHA	1024U
>   
>   struct dctcp {
> @@ -43,12 +53,18 @@ void BPF_PROG(dctcp_init, struct sock *sk)
>   {
>   	const struct tcp_sock *tp = tcp_sk(sk);
>   	struct dctcp *ca = inet_csk_ca(sk);
> +	int *stg;
>   
>   	ca->prior_rcv_nxt = tp->rcv_nxt;
>   	ca->dctcp_alpha = min(dctcp_alpha_on_init, DCTCP_MAX_ALPHA);
>   	ca->loss_cwnd = 0;
>   	ca->ce_state = 0;
>   
> +	stg = bpf_sk_storage_get(&sk_stg_map, (void *)tp, NULL, 0);
> +	if (stg) {
> +		stg_result = *stg;
> +		bpf_sk_storage_delete(&sk_stg_map, (void *)tp);
> +	}
>   	dctcp_reset(tp, ca);
>   }
>   
> 

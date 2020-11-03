Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A091D2A3812
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 01:56:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725974AbgKCA4O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 19:56:14 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:62134 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725855AbgKCA4O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Nov 2020 19:56:14 -0500
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0A30kuM1004512;
        Mon, 2 Nov 2020 16:55:55 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=9LsMBzquP9Voeq+w7SMnh4QlPOiINg+C89y7ZuwdtI0=;
 b=PiUmVBGd3TpivFblAmh+l3fVBMWtrkK3HvBp65NNzeD11qtqh8VhexaEo+Vr+D3SK3jn
 m73qncI/e7qcFY9e3stVvV6ZcBFCdfRJN2WQAO5uHflVD+alAwjTnzPtZBEOoJZSeGTX
 OPOzwq29er2sHU43GJl0aSJsmbYoj5Fj1c8= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 34hqdu8d6j-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 02 Nov 2020 16:55:55 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 2 Nov 2020 16:55:54 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AuTTxGtr56YRZBk6X0il09lIZ8+1k9CFP6O5SpkgooThPBQ3Zvi/m5VDgqjMq9gCKHxWwz0wviJEbyo8JbTg2yD/fIjKiVJ80BfF+fqdswftBsEMDJhYSfWsBPNAf6dt7KciZWY1WJBLqHfYiXnu3TTtnREYyB+VBG68QkAmGRmPXSbm+6RVx0C/shFHwxyuooxoYMdY7BaNOiTJdKjUDk0FQGtaCK/hfH8wGeaZz8/ygn3qZIqUfBWS/U7UqYwqUm/aUCrCjqMTAl39KsK8asIWE30SzMn+sAmBhJSayjf38APfoW80fFdQZ681LAZ5XCGXE21+fBiduTc6y+1Jwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9LsMBzquP9Voeq+w7SMnh4QlPOiINg+C89y7ZuwdtI0=;
 b=JtSkOtUDx4a+pnMGk5ZooeSfT2zUXJ3hMYCalv3+745qX2uoyhrO+wCh6HN8qiTcM+kQFlRHGHydVkkvzAgFNs+mduOt8RTQKMxNjR8XheRfQXpRp9RswRGs/lcArbpqpWuwN76BKIgY9qyVzLG/YUmZerETNKT7frSdecdlqhyMoTDqe4WVi7BOzXgweVEESkAcZKYO0unrx8I6rHmc20FpOMtcxvgDE2ZRsaijsAJbZlPoEJUZWE3HcOjpV8zmJlsQDkCpt4NhWVPUsMb4GbneyBRyj2zoq9rnSvg0ixahVd5Wr5V6V4abjY6fdLXgvkUo96HmukdhUKNkIz2TUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9LsMBzquP9Voeq+w7SMnh4QlPOiINg+C89y7ZuwdtI0=;
 b=CrqLbG6cEms9JlBwy8/TlLdiB6NzaipHrKD/ex4qcNtjrC4kPHr01lpEYvtLxu9fPfzrXKSJhpdPKYoGOt7Dvt5QYzrdueC80wujXzN/ivq188WX39lkaK0v1NEU58nr3VmjnE4kaqodwswqdJUubSqvc1Wng54hOD4/e2nX+VM=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by BYAPR15MB3509.namprd15.prod.outlook.com (2603:10b6:a03:108::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.27; Tue, 3 Nov
 2020 00:55:53 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::bc1d:484f:cb1f:78ee]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::bc1d:484f:cb1f:78ee%4]) with mapi id 15.20.3499.030; Tue, 3 Nov 2020
 00:55:53 +0000
Date:   Mon, 2 Nov 2020 16:55:47 -0800
From:   Martin KaFai Lau <kafai@fb.com>
To:     Alexander Duyck <alexander.duyck@gmail.com>
CC:     <bpf@vger.kernel.org>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <john.fastabend@gmail.com>, <kernel-team@fb.com>,
        <netdev@vger.kernel.org>, <edumazet@google.com>, <brakmo@fb.com>,
        <andrii.nakryiko@gmail.com>, <alexanderduyck@fb.com>
Subject: Re: [bpf-next PATCH v2 4/5] selftests/bpf: Migrate tcpbpf_user.c to
 use BPF skeleton
Message-ID: <20201103005547.buhyl6tsi5shm374@kafai-mbp.dhcp.thefacebook.com>
References: <160416890683.710453.7723265174628409401.stgit@localhost.localdomain>
 <160417035105.2823.2453428685023319711.stgit@localhost.localdomain>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160417035105.2823.2453428685023319711.stgit@localhost.localdomain>
X-Originating-IP: [2620:10d:c090:400::5:8aa6]
X-ClientProxiedBy: CO2PR04CA0109.namprd04.prod.outlook.com
 (2603:10b6:104:7::11) To BY5PR15MB3571.namprd15.prod.outlook.com
 (2603:10b6:a03:1f6::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:8aa6) by CO2PR04CA0109.namprd04.prod.outlook.com (2603:10b6:104:7::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.27 via Frontend Transport; Tue, 3 Nov 2020 00:55:52 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 22b87a8e-c5dd-474c-a71f-08d87f9336ff
X-MS-TrafficTypeDiagnostic: BYAPR15MB3509:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB3509C8F802C8BB1A98FE31F5D5110@BYAPR15MB3509.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:337;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 07LMz+tI1jOzTmPq7w1OtcmcrHhgmWdL5oXOb95IzI0R2cjpGGSmLoDPJxIJN5XOidBk0MwlZSAytJMpb/7zRJRFEact/nmNKrvje9dNKfAIfJBGDkejNGkXdfwLJI5NKkhv5UhuM3I344965L82KnzMDf2uuJhqoptrVB8rfP9SoV3Gh8gNKH2Jof5dQ9L1j7I8txfYfkHT3ML1LZ2T2iAnvxgCtl8Ulsp38fec5FRWIQZDcyYS1BRAn1YKreyeekWxJxygvoS/ERaZwINE5cznS5OUajT36rwKUyJdiBZJgNcBZrWS2jlpFNWEk+iWjd9hxGAqBCdzufXytr0aGg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(366004)(39860400002)(136003)(376002)(346002)(52116002)(9686003)(4326008)(6506007)(8676002)(2906002)(86362001)(8936002)(16526019)(7696005)(186003)(55016002)(5660300002)(6916009)(66556008)(1076003)(66476007)(6666004)(83380400001)(478600001)(66946007)(316002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: 5E2JSBf769CyzArH6hpaI1aUQW5aHVBbpwudUvmk2w3BuTH6n5n5pFip14ujzCYUt5BkIKK0eyblZ6uYrWKHP2/LcKcMqorGc94SjXEXCKnziIGOcdimZDgir/YDRFeq2/ZqEg/rMMqJWDpCbHDwtLN+iXVAiL306TrO9lwoyBTQ1NLlpOeFKIO3TivbglFJ6zO9jvUIR2u946Dmsw3Br/LS218QNie90UaoUWNFcQD7+lSVQQuQHdpC/eV18uceHoHxSe0vmndxZwfmD7+LTiNYNIu2mySuFxLVhRYCmq7jpQ4u6uJdrlpMKZB2NpLPqT3KjvnkvStM7EZtgwLLEBcVNXauXR1s1xmO3ijDmpYkFfi8lWu7L1pdSgODO5XGgtbY3Fek+P6FjCCMCB9+2jN8+DVMZU8UqyLQZaT3IK9kkxjsAjcHJBge4KuOm3y3lY3C2y5yWH8LhM8gywywDw5DaZrL0x+91i1nasnDB8sSTa1BPIDz1fIm6mML8PPkyaeAOVXVTBoxpv219lTJc7x+Kw99ptYcxRsJAUllaW7gQHJZoPhNO3/r5Vy3Qg24kkOsAdhusil3/v0h+zOxYQT0B5MLxNJtoSZyzoZhylAr/6lFrkfdiN1hLGeqtQdXFffNIqdHF5sDVpyaypGzuu8WfsGoSYY1reHMXqs+CsLoreL8jXeguBjSkJY2ReNg
X-MS-Exchange-CrossTenant-Network-Message-Id: 22b87a8e-c5dd-474c-a71f-08d87f9336ff
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB3571.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2020 00:55:53.3958
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: h9wQiONETUhagu9lIB4yB9Cjd7PVaV3bRMFg9JykQ6B3qslM5+0N/eWmGYeCQIjS
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3509
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-02_16:2020-11-02,2020-11-02 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 phishscore=0 mlxlogscore=999 priorityscore=1501 impostorscore=0
 malwarescore=0 adultscore=0 suspectscore=1 bulkscore=0 mlxscore=0
 clxscore=1015 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011030002
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 31, 2020 at 11:52:31AM -0700, Alexander Duyck wrote:
> From: Alexander Duyck <alexanderduyck@fb.com>
> 
> Update tcpbpf_user.c to make use of the BPF skeleton. Doing this we can
> simplify test_tcpbpf_user and reduce the overhead involved in setting up
> the test.
> 
> In addition we can clean up the remaining bits such as the one remaining
> CHECK_FAIL at the end of test_tcpbpf_user so that the function only makes
> use of CHECK as needed.
> 
> Acked-by: Andrii Nakryiko <andrii@kernel.org>
> Signed-off-by: Alexander Duyck <alexanderduyck@fb.com>
Acked-by: Martin KaFai Lau <kafai@fb.com>

> ---
>  .../testing/selftests/bpf/prog_tests/tcpbpf_user.c |   48 ++++++++------------
>  1 file changed, 18 insertions(+), 30 deletions(-)
> 
> diff --git a/tools/testing/selftests/bpf/prog_tests/tcpbpf_user.c b/tools/testing/selftests/bpf/prog_tests/tcpbpf_user.c
> index d96f4084d2f5..c7a61b0d616a 100644
> --- a/tools/testing/selftests/bpf/prog_tests/tcpbpf_user.c
> +++ b/tools/testing/selftests/bpf/prog_tests/tcpbpf_user.c
> @@ -4,6 +4,7 @@
>  #include <network_helpers.h>
>  
>  #include "test_tcpbpf.h"
> +#include "test_tcpbpf_kern.skel.h"
>  
>  #define LO_ADDR6 "::1"
>  #define CG_NAME "/tcpbpf-user-test"
> @@ -133,44 +134,31 @@ static void run_test(int map_fd, int sock_map_fd)
>  
>  void test_tcpbpf_user(void)
>  {
> -	const char *file = "test_tcpbpf_kern.o";
> -	int prog_fd, map_fd, sock_map_fd;
> -	int error = EXIT_FAILURE;
> -	struct bpf_object *obj;
> +	struct test_tcpbpf_kern *skel;
> +	int map_fd, sock_map_fd;
>  	int cg_fd = -1;
> -	int rv;
> -
> -	cg_fd = test__join_cgroup(CG_NAME);
> -	if (cg_fd < 0)
> -		goto err;
>  
> -	if (bpf_prog_load(file, BPF_PROG_TYPE_SOCK_OPS, &obj, &prog_fd)) {
> -		fprintf(stderr, "FAILED: load_bpf_file failed for: %s\n", file);
> -		goto err;
> -	}
> +	skel = test_tcpbpf_kern__open_and_load();
> +	if (CHECK(!skel, "open and load skel", "failed"))
> +		return;
>  
> -	rv = bpf_prog_attach(prog_fd, cg_fd, BPF_CGROUP_SOCK_OPS, 0);
> -	if (rv) {
> -		fprintf(stderr, "FAILED: bpf_prog_attach: %d (%s)\n",
> -		       errno, strerror(errno));
> -		goto err;
> -	}
> +	cg_fd = test__join_cgroup(CG_NAME);
> +	if (CHECK(cg_fd < 0, "test__join_cgroup(" CG_NAME ")",
> +		  "cg_fd:%d errno:%d", cg_fd, errno))
> +		goto cleanup_skel;
>  
> -	map_fd = bpf_find_map(__func__, obj, "global_map");
> -	if (map_fd < 0)
> -		goto err;
> +	map_fd = bpf_map__fd(skel->maps.global_map);
> +	sock_map_fd = bpf_map__fd(skel->maps.sockopt_results);
>  
> -	sock_map_fd = bpf_find_map(__func__, obj, "sockopt_results");
> -	if (sock_map_fd < 0)
> -		goto err;
> +	skel->links.bpf_testcb = bpf_program__attach_cgroup(skel->progs.bpf_testcb, cg_fd);
> +	if (ASSERT_OK_PTR(skel->links.bpf_testcb, "attach_cgroup(bpf_testcb)"))
> +		goto cleanup_namespace;
>  
>  	run_test(map_fd, sock_map_fd);
>  
> -	error = 0;
> -err:
> -	bpf_prog_detach(cg_fd, BPF_CGROUP_SOCK_OPS);
> +cleanup_namespace:
nit.

may be "cleanup_cgroup" instead?

or only have one jump label to handle failure since "cg_fd != -1" has been
tested already.

>  	if (cg_fd != -1)
>  		close(cg_fd);
> -
> -	CHECK_FAIL(error);
> +cleanup_skel:
> +	test_tcpbpf_kern__destroy(skel);
>  }
> 
> 

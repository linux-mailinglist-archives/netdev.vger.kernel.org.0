Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 050742B7617
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 07:01:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726306AbgKRF7C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 00:59:02 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:3696 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725355AbgKRF7C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Nov 2020 00:59:02 -0500
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AI5iRIr023322;
        Tue, 17 Nov 2020 21:58:42 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=Aj+6Ahg4Y2GAfVxtBJAZX9eHUD2FsSzcllGn847u1y8=;
 b=TUipnZ3+2XJ9sI8bOJ5fDgRrRYiU9MQxvPanH+4I4zKRNUnx5WJ2ulwd1L/8y6rWKhv7
 bkEOYtLMeDXJgs02Hv7PGnwcQS5dmCE7hOuwK7rX46MEPMqPXSVPDkZcJ0B9Y9NFZQvI
 3MxICMjg1vf3Q07EygeUmW729qvfmYJSve4= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 34uphjcsyc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 17 Nov 2020 21:58:42 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.199) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 17 Nov 2020 21:58:41 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e4HxNbfbYY9i2vuR0uDtWl8aPCOCH9nJ7uJr/2PTtDQy0Qon+JDLsoWU3WT9y2gI6rnrgsJ5wx/OMsWWCItOoN6c3xn9gchv9IfeeRUIpzVJTz4RML9BpEB5FPAw1ulDKvAguTzHR87VhP3H4+osGBdDHSe4ZBwpGdgPD+1fB9E3uf69LTxRJzR3+LzSxML5CoUCoYvpKO/wjLa+gSfkhbuYiEJYieq4IQCzcwhkEXstfq5XNzqIW/M7XIBPI5T9VrYfa435fe/+0raAolvX4fOAahbjpUJl/5dq4FECy8JDpxWu4msHSk37AJ2tbltDecSCPKcwRs/iKQvuyEh6IA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Aj+6Ahg4Y2GAfVxtBJAZX9eHUD2FsSzcllGn847u1y8=;
 b=Q8TZz5G7l/F3mJwI+vvaCH59Z+gRNbfOcS380IfRFsvuLtd/Fw1o4TKZPrUrGjKWOrdXEaMEaMowrOzgcwGiFIR1PD97Wo9yALQyeNai+F0LkWMnX5I4HGT2G5sqfGzmpP1vMqO4BTnXwsUuzPVqWM/oHzvzRPWBoEOUGZaakJU+/36OfuKJVpzKkczHezW4INjpcwropEdrud71gdUnAt6mGgbCmNO5KbkCYepbIHuq3rIEZXM6maRHnVx3FpcnMahC2vhyyrniFZnYgcEHomv6+StiAFUtjt454ounaarpWA2UKak/981gUlesbBkgatS/T67zOKnIXcNJBY181w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Aj+6Ahg4Y2GAfVxtBJAZX9eHUD2FsSzcllGn847u1y8=;
 b=D0PmBke5YIQdvyS7h5+ctwZrhHa+ywUO703/4gxVrOwra6C5/U2ftFHSd8RGy3qangSE7vWJxB/mdx0cVjU3O33UsxoH17btARXsxnTlkGhV8DtSS0kSX121PxlHJGFZXvk3nlZbSXBnx1vSEqC9SRCNIDPiTwXf5ylyViIFhVE=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by BYAPR15MB3255.namprd15.prod.outlook.com (2603:10b6:a03:107::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3564.25; Wed, 18 Nov
 2020 05:58:39 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::bc1d:484f:cb1f:78ee]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::bc1d:484f:cb1f:78ee%4]) with mapi id 15.20.3564.028; Wed, 18 Nov 2020
 05:58:39 +0000
Date:   Tue, 17 Nov 2020 21:58:32 -0800
From:   Martin KaFai Lau <kafai@fb.com>
To:     "Daniel T. Lee" <danieltimlee@gmail.com>
CC:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>, brakmo <brakmo@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        David Ahern <dsa@cumulusnetworks.com>,
        Yonghong Song <yhs@fb.com>,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Ira Weiny <ira.weiny@intel.com>, Thomas Graf <tgraf@suug.ch>,
        Jakub Kicinski <kuba@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        Xdp <xdp-newbies@vger.kernel.org>
Subject: Re: [PATCH bpf-next 3/9] samples: bpf: refactor test_cgrp2_sock2
 program with libbpf
Message-ID: <20201118055832.q5zsgulnsbjawgyq@kafai-mbp.dhcp.thefacebook.com>
References: <20201117145644.1166255-1-danieltimlee@gmail.com>
 <20201117145644.1166255-4-danieltimlee@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201117145644.1166255-4-danieltimlee@gmail.com>
X-Originating-IP: [2620:10d:c090:400::5:603e]
X-ClientProxiedBy: MWHPR22CA0036.namprd22.prod.outlook.com
 (2603:10b6:300:69::22) To BY5PR15MB3571.namprd15.prod.outlook.com
 (2603:10b6:a03:1f6::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:603e) by MWHPR22CA0036.namprd22.prod.outlook.com (2603:10b6:300:69::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.20 via Frontend Transport; Wed, 18 Nov 2020 05:58:38 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fb39c8f2-3107-4350-5dac-08d88b86ff37
X-MS-TrafficTypeDiagnostic: BYAPR15MB3255:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB32553EACBF1AB4823C93093ED5E10@BYAPR15MB3255.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:1201;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: y+fjfLq1UNBOVqLPx6QG1H4JdyR8T2/tNMTeyrqw7UaD6GTAGdl44s6nEvDHrJUkoB4pWZhZKZ+2XMVjmq06D55Ums6MohvJDnvJAqWI7o79RIrpIa+w9itd95JmHwtPoGdn7OqzjV5hxBb5Xt7++hqDDtcvHKppBC1Kjema/mAyfBB/z8PksGKZ3LBoAEt7s9RDIFuGJWD0u9Eei5e8q854UZCD971Rs7wOrT/4f5sjeU9Ut9g37J1sF6jtj+pOkOn370cfnrD7rAzpmrlMvN/sXVrUELSUfigYW33Arz6HzIS1bhUkkZcQIvPaAFBskCZ7ZttfwgKEvOUqZKCD1Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(136003)(346002)(396003)(376002)(39860400002)(478600001)(86362001)(1076003)(6916009)(6506007)(16526019)(7696005)(186003)(5660300002)(52116002)(8676002)(2906002)(7416002)(4326008)(8936002)(66556008)(66946007)(55016002)(9686003)(6666004)(54906003)(83380400001)(66476007)(316002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: iFecb3RYxWtvdDfxw/3OHMnqU7T7jcV7txuHXSFVNP6KN97Rt3CoStc+s/R/DGZZgs3GcyGulhxrQ3D/bxALnG05NXldxWTrozO23EP2whkfZFYs3Ucth0PXmS/byDpX8LTqnN5aimFWN1uGn3X7kXA15BQKrUM6S7FlUjQS4dPeizWAxmJuzKDzOlnXLfsPkFywgU2FXGgFzvJ0M+DRRgUy7qM9EoX8zXqPo6viA902ywtd6MEsgJPhuOmZetNhHZw0D60aqOqAq0KI0oS5R0XpZD+G2/ewhLKn4bRfPYYndS1VtUn33RWYis1ZB1QO5AWCpyy2LCqEm2YNl82JfZf7hROum4aTIyCbc4Jg6k/7yitDgaW73GnYQUSY77OqR47wYHqwwtZupoLxX33foPkdZWpuyK32v5Q2guNxR1J1H1AbqdrxAeaxznJqDQg5yslh3Qt2rHVWmbGV0A+a6hWT2Oam+6VP+E8WH4jwDJrJmPIWqImX6RahVpUL0CWFV2H6D7fTXwR89Ap2gmjiKJklhBhjlvb+EWyBzwMFjNLBuQKAPlrPyG6FsMkUArCBmbPhxTm9Iz+js0xQuekJ3rM0FaxivWFYb9hTb2wLNVXj8Cp6lt2DxhDzrY6oS/EhU1tX7mcL9AIAPb5DFlZj2s1nTNiSLjzdSXtM0GpWOpqNu+fGNCJjYnF/DacE18K34Dz/calubjEaRRy/7OUCNtYaltp6pIUF3tDYsb84/xzKoIaf/7wV13vSlr05q8GTH1dvsZcHDSv/dONkRRerNpPm6cEJ9yrJ5ifb2YCENNwnhEqMNGw1U4jxL7Cosah96TvC3FEjW8KO35gymMUjGbJn6vSOhc4N4UvQJ19U6obYfsiHRvrU9H0VVMQFV3VOsK+iUsAlORMQmOCedGy3/DNuqJdiO0uh4zQRygiSdFQ=
X-MS-Exchange-CrossTenant-Network-Message-Id: fb39c8f2-3107-4350-5dac-08d88b86ff37
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB3571.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2020 05:58:39.8351
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1RbuPwXoiafHnEa9wl6ZeyovIvVOca/nmpkWOVSnbnru2zyxvtZTMj707dgz6k88
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3255
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-18_01:2020-11-17,2020-11-18 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 impostorscore=0 bulkscore=0 mlxlogscore=999 priorityscore=1501
 malwarescore=0 clxscore=1015 suspectscore=1 adultscore=0 spamscore=0
 mlxscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011180041
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 17, 2020 at 02:56:38PM +0000, Daniel T. Lee wrote:
[ ... ]

> diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
> index 01449d767122..7a643595ac6c 100644
> --- a/samples/bpf/Makefile
> +++ b/samples/bpf/Makefile
> @@ -82,7 +82,7 @@ test_overhead-objs := bpf_load.o test_overhead_user.o
>  test_cgrp2_array_pin-objs := test_cgrp2_array_pin.o
>  test_cgrp2_attach-objs := test_cgrp2_attach.o
>  test_cgrp2_sock-objs := test_cgrp2_sock.o
> -test_cgrp2_sock2-objs := bpf_load.o test_cgrp2_sock2.o
> +test_cgrp2_sock2-objs := test_cgrp2_sock2.o
>  xdp1-objs := xdp1_user.o
>  # reuse xdp1 source intentionally
>  xdp2-objs := xdp1_user.o
> diff --git a/samples/bpf/test_cgrp2_sock2.c b/samples/bpf/test_cgrp2_sock2.c
> index a9277b118c33..518526c7ce16 100644
> --- a/samples/bpf/test_cgrp2_sock2.c
> +++ b/samples/bpf/test_cgrp2_sock2.c
> @@ -20,9 +20,9 @@
>  #include <net/if.h>
>  #include <linux/bpf.h>
>  #include <bpf/bpf.h>
> +#include <bpf/libbpf.h>
>  
>  #include "bpf_insn.h"
> -#include "bpf_load.h"
>  
>  static int usage(const char *argv0)
>  {
> @@ -32,37 +32,66 @@ static int usage(const char *argv0)
>  
>  int main(int argc, char **argv)
>  {
> -	int cg_fd, ret, filter_id = 0;
> +	int cg_fd, err, ret = EXIT_FAILURE, filter_id = 0, prog_cnt = 0;
> +	const char *link_pin_path = "/sys/fs/bpf/test_cgrp2_sock2";
> +	struct bpf_link *link = NULL;
> +	struct bpf_program *progs[2];
> +	struct bpf_program *prog;
> +	struct bpf_object *obj;
>  
>  	if (argc < 3)
>  		return usage(argv[0]);
>  
> +	if (argc > 3)
> +		filter_id = atoi(argv[3]);
> +
>  	cg_fd = open(argv[1], O_DIRECTORY | O_RDONLY);
>  	if (cg_fd < 0) {
>  		printf("Failed to open cgroup path: '%s'\n", strerror(errno));
> -		return EXIT_FAILURE;
> +		return ret;
>  	}
>  
> -	if (load_bpf_file(argv[2]))
> -		return EXIT_FAILURE;
> -
> -	printf("Output from kernel verifier:\n%s\n-------\n", bpf_log_buf);
> +	obj = bpf_object__open_file(argv[2], NULL);
> +	if (libbpf_get_error(obj)) {
> +		printf("ERROR: opening BPF object file failed\n");
> +		return ret;
> +	}
>  
> -	if (argc > 3)
> -		filter_id = atoi(argv[3]);
> +	bpf_object__for_each_program(prog, obj) {
> +		progs[prog_cnt] = prog;
> +		prog_cnt++;
> +	}
>  
>  	if (filter_id >= prog_cnt) {
>  		printf("Invalid program id; program not found in file\n");
> -		return EXIT_FAILURE;
> +		goto cleanup;
> +	}
> +
> +	/* load BPF program */
> +	if (bpf_object__load(obj)) {
> +		printf("ERROR: loading BPF object file failed\n");
> +		goto cleanup;
>  	}
>  
> -	ret = bpf_prog_attach(prog_fd[filter_id], cg_fd,
> -			      BPF_CGROUP_INET_SOCK_CREATE, 0);
> -	if (ret < 0) {
> -		printf("Failed to attach prog to cgroup: '%s'\n",
> -		       strerror(errno));
> -		return EXIT_FAILURE;
> +	link = bpf_program__attach_cgroup(progs[filter_id], cg_fd);
> +	if (libbpf_get_error(link)) {
> +		printf("ERROR: bpf_program__attach failed\n");
> +		link = NULL;
> +		goto cleanup;
>  	}
>  
> -	return EXIT_SUCCESS;
> +	err = bpf_link__pin(link, link_pin_path);
> +	if (err < 0) {
> +		printf("err : %d\n", err);
> +		goto cleanup;
> +	}
> +
> +	ret = EXIT_SUCCESS;
> +
> +cleanup:
> +	if (ret != EXIT_SUCCESS)
> +		bpf_link__destroy(link);
This looks wrong.  cleanup should be done regardless.

> +
> +	bpf_object__close(obj);
> +	return ret;
>  }

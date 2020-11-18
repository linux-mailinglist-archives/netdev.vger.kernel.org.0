Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 132BE2B73AC
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 02:20:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727388AbgKRBUA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 20:20:00 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:25246 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725767AbgKRBT7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Nov 2020 20:19:59 -0500
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AI1Jb9g022686;
        Tue, 17 Nov 2020 17:19:40 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=KT5OUDRI++OJZeoQPVz3c4foFYfYYhGvGldzqw0iKq4=;
 b=kHJkMkawTNfvXPPLQKxmBKdKrfTVuNfrHG+a1QQFg+T00GLvTFDyViIZc0Dg0Anoq9Eh
 lELy9inhyG5YyCBoSsVdkGg1dQizqSuZZY/mQrMgHS3kS3iH3q+26AtIJJ1kJg7vFnW6
 n6UNAOjdJ+qJF1t/UiPlKC4ogvCWreg47Fg= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 34uwyg8wqf-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 17 Nov 2020 17:19:40 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 17 Nov 2020 17:19:26 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jLWqTkR4Cz8MXxsnoWhS5Zl/ZzgDlF0z/6G9mJuxOLM6lMJ8gquGGVMpf8TMIj8+cGWHScKV34wtI1CT6/H5grhN9YJsZhwof5im9yr02SW2krFN3UsmCszppAKAm6p20fmmcyG8cbqzfqfwzy/qJ2eeUiNeCnLS0WlRfJn7hXwlaqep3ISQHTnmmtom1nc/Vdu+kS6sOaE1rLIslcWhVQ0Uzb2NdR+s6dZH3oF0Igw9jb+qYApizniJLvklotk5J1UfgzA5Dh6/f4OqptywoIte5Lgu1uFvb5wHyFF72d2pYRL7ZEPcLCM+TXyI+diV1i6HbmIWDcj+PIBTS/m1XQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KT5OUDRI++OJZeoQPVz3c4foFYfYYhGvGldzqw0iKq4=;
 b=guK0aJN4BIfdfLTKMMLrGELvHdzfph8kFOFVk20G+3XvHsP5XU4zhvGeKL5Aa7ZCxFPIFBpw8iawnsSso4ciIR/mMBG3tpvdtTAETwogPCWojqFcm1hX8/crsMlvFRfF8O2aDdUUd5QCWIUcWSXkrSeuasFjEXdyd9o8/hSRwQ4XBCHYZYAzyBtAQaXMUNcVU8J3KOFY6nXjcYZURETA8k6Z5j3oKLls+o+j+yWiXteYKQ06mrAcLrw2I3AqsjdOxKle83g3/vvmeL79ECffhUGvaSa4kTSdUJi53DaKFdVpK6JrE9cvKali9wgnOHKL94qjMcitKsnWtLsdgU7pvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KT5OUDRI++OJZeoQPVz3c4foFYfYYhGvGldzqw0iKq4=;
 b=RwIu/h7dHbZDye7+YR9dok6Q2zpCJ/dS/tNo3D+KUwrnkxEZLMedK57qcTs6NRFbSvvTHffbxV5eZDf7l3B8GSlueGCwb5Jc9F7BWp6Khr4EHYN5nQzahq1rZKsCZlMFlXx4NSFAfB2PyQTuOR/bib8+EWvktxg9eS7D1fdOp1o=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by BYAPR15MB3415.namprd15.prod.outlook.com (2603:10b6:a03:112::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.20; Wed, 18 Nov
 2020 01:19:25 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::bc1d:484f:cb1f:78ee]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::bc1d:484f:cb1f:78ee%4]) with mapi id 15.20.3564.028; Wed, 18 Nov 2020
 01:19:25 +0000
Date:   Tue, 17 Nov 2020 17:19:17 -0800
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
Subject: Re: [PATCH bpf-next 1/9] selftests: bpf: move tracing helpers to
 trace_helper
Message-ID: <20201118011917.v5zagoksa4h2yuei@kafai-mbp.dhcp.thefacebook.com>
References: <20201117145644.1166255-1-danieltimlee@gmail.com>
 <20201117145644.1166255-2-danieltimlee@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201117145644.1166255-2-danieltimlee@gmail.com>
X-Originating-IP: [2620:10d:c090:400::5:603e]
X-ClientProxiedBy: MWHPR12CA0039.namprd12.prod.outlook.com
 (2603:10b6:301:2::25) To BY5PR15MB3571.namprd15.prod.outlook.com
 (2603:10b6:a03:1f6::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:603e) by MWHPR12CA0039.namprd12.prod.outlook.com (2603:10b6:301:2::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.20 via Frontend Transport; Wed, 18 Nov 2020 01:19:23 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: db9c0781-e0b8-4aae-0714-08d88b5ffc74
X-MS-TrafficTypeDiagnostic: BYAPR15MB3415:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB3415A35EFE33C06A4DB74A96D5E10@BYAPR15MB3415.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:195;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EphkDdnwagJkDq2La0zOCrat5Bs3LVvVIKff+GuJdhorbxzxMYYNBBe+Jqm7q6z2dsmPthcknYCDMziWALNSACQU1OSLHUBmtGCvbNSMA5YptHj/TX5xiExZ1epHgI2kzI0DXXVe+/36jateAjG2phxHhXGRJVILX1fxkMKntbD3zGGhQ63eYuHtSwa1dFW7cX4IyvA3P4+Ja3RKI5dYMD74MjsyJZNs3UD5mZEfcr0RuPmvuhjQPij2Kl4C9bNDQvcv4Ke7e9Y0bqN/bjrnJnQEXqRc6chmQvkFpNvd/JdiXHIbgT2kzhDkLMffnH5lUT/7PmzugoI6o35Qn/IpBQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(396003)(366004)(376002)(136003)(39860400002)(52116002)(7696005)(4326008)(16526019)(55016002)(2906002)(6666004)(86362001)(9686003)(1076003)(7416002)(186003)(8936002)(6916009)(83380400001)(66476007)(66556008)(6506007)(316002)(66946007)(5660300002)(8676002)(54906003)(478600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: MpwgGuGAiklWmimU6q5xCFngepFy4HjRpc9OqKHzGE1QmnUGN3O1w0jSBxEjzG3Y7NRi80SjAWBPJr8A4AdAynggXEb3Afjz2l/CMWQIv5kEm3kl0zz1+Qo+Z9xIU289Yiuv+jOW4D5qkjyjoVJcuG4OLJod8vqqaEXJm2o32MtoQTUL5QTzQtpmIThnoB71j7ncJxH1FWaLWDMvENYIFwEcHwGdHnwrDD5CaFKqNK6GnOJrV0FGfClHdZgZEnGzJmlTLSm+oacEp2LM416e1a5zfgrieHX6Mbj8vdmqVyyXFcJffPJkfSlXfVJYJmyBHR9glJnWt9cKyux5HrtoBBTDKPKYHD1ht6QcyEWn23i6SuGEHx1SCulIGoD6CXLBWgbrllDz0zkeAXZ/2v8QPYI/ll94vjfhzruomB+E+b7kP/5+fVpvXBORnMAoOpAM7wtJtDipc9FkoeZ+nb5RATga4QhG1Q3vzBTX4+9rvMnA+YElFjDyLEqXrGFDbfzPr/A8R1gDVUvb3IiJmw83Umk+X1BRGI0LNURNVkX2b3l4W6Q5gdHBWg+BTp6PQ6u7h23ledRHiq4LXLPxbcCDcaPmk6gFOdY3Y5ey3kFlR+2LxHtLNjTF4saZjkDrl1bmT1xy4PgBou8CjFgIA4UkfenfguRDDNWfW0xWmJ4DyXGWAvThIVUFL+0mN7cbM5wAeo8z/xm9Tleuz5tkVkujukBem4rqUfxPPAWhhFu8CNajhipfZ6J+v1Tb+jxk/dqhygRmN53jJ8z1Tg0ZHWKOwDh9xLkZJd19UVUhN7o+3rKCVs/nn1fEg7TbTgSDZBFEGp9gNDmcTfoM5NvRv8QHRH5t9vt6a5eH7f1WUoMsB1SPaaz1fFpOkGUH4mOTiMbmUOAbxc57rYOkQBz+uKXTS1So2mHPx+TJSWH8veUz/CM=
X-MS-Exchange-CrossTenant-Network-Message-Id: db9c0781-e0b8-4aae-0714-08d88b5ffc74
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB3571.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2020 01:19:24.9409
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: InKMZiHdSeO8T65QYgN5NgKQrNxlWZyVCccYA1yTA2kSE690s8Gmwqu8qEMOTx2f
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3415
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-17_15:2020-11-17,2020-11-17 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0
 mlxlogscore=999 priorityscore=1501 clxscore=1011 mlxscore=0
 impostorscore=0 malwarescore=0 adultscore=0 lowpriorityscore=0 spamscore=0
 phishscore=0 suspectscore=1 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2011180005
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 17, 2020 at 02:56:36PM +0000, Daniel T. Lee wrote:
> Under the samples/bpf directory, similar tracing helpers are
> fragmented around. To keep consistent of tracing programs, this commit
> moves the helper and define locations to increase the reuse of each
> helper function.
> 
> Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
> 
> ---
>  samples/bpf/Makefile                        |  2 +-
>  samples/bpf/hbm.c                           | 51 ++++-----------------
>  tools/testing/selftests/bpf/trace_helpers.c | 33 ++++++++++++-
>  tools/testing/selftests/bpf/trace_helpers.h |  3 ++
>  4 files changed, 45 insertions(+), 44 deletions(-)
> 
> diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
> index aeebf5d12f32..3e83cd5ca1c2 100644
> --- a/samples/bpf/Makefile
> +++ b/samples/bpf/Makefile
> @@ -110,7 +110,7 @@ xdp_fwd-objs := xdp_fwd_user.o
>  task_fd_query-objs := bpf_load.o task_fd_query_user.o $(TRACE_HELPERS)
>  xdp_sample_pkts-objs := xdp_sample_pkts_user.o $(TRACE_HELPERS)
>  ibumad-objs := bpf_load.o ibumad_user.o $(TRACE_HELPERS)
> -hbm-objs := bpf_load.o hbm.o $(CGROUP_HELPERS)
> +hbm-objs := bpf_load.o hbm.o $(CGROUP_HELPERS) $(TRACE_HELPERS)
>  
>  # Tell kbuild to always build the programs
>  always-y := $(tprogs-y)
> diff --git a/samples/bpf/hbm.c b/samples/bpf/hbm.c
> index 400e741a56eb..b9f9f771dd81 100644
> --- a/samples/bpf/hbm.c
> +++ b/samples/bpf/hbm.c
> @@ -48,6 +48,7 @@
>  
>  #include "bpf_load.h"
>  #include "bpf_rlimit.h"
> +#include "trace_helpers.h"
>  #include "cgroup_helpers.h"
>  #include "hbm.h"
>  #include "bpf_util.h"
> @@ -65,51 +66,12 @@ bool no_cn_flag;
>  bool edt_flag;
>  
>  static void Usage(void);
> -static void read_trace_pipe2(void);
>  static void do_error(char *msg, bool errno_flag);
>  
> -#define DEBUGFS "/sys/kernel/debug/tracing/"
> -
>  struct bpf_object *obj;
>  int bpfprog_fd;
>  int cgroup_storage_fd;
>  
> -static void read_trace_pipe2(void)
> -{
> -	int trace_fd;
> -	FILE *outf;
> -	char *outFname = "hbm_out.log";
> -
> -	trace_fd = open(DEBUGFS "trace_pipe", O_RDONLY, 0);
> -	if (trace_fd < 0) {
> -		printf("Error opening trace_pipe\n");
> -		return;
> -	}
> -
> -//	Future support of ingress
> -//	if (!outFlag)
> -//		outFname = "hbm_in.log";
> -	outf = fopen(outFname, "w");
> -
> -	if (outf == NULL)
> -		printf("Error creating %s\n", outFname);
> -
> -	while (1) {
> -		static char buf[4097];
> -		ssize_t sz;
> -
> -		sz = read(trace_fd, buf, sizeof(buf) - 1);
> -		if (sz > 0) {
> -			buf[sz] = 0;
> -			puts(buf);
> -			if (outf != NULL) {
> -				fprintf(outf, "%s\n", buf);
> -				fflush(outf);
> -			}
> -		}
> -	}
> -}
> -
>  static void do_error(char *msg, bool errno_flag)
>  {
>  	if (errno_flag)
> @@ -392,8 +354,15 @@ static int run_bpf_prog(char *prog, int cg_id)
>  		fclose(fout);
>  	}
>  
> -	if (debugFlag)
> -		read_trace_pipe2();
> +	if (debugFlag) {
> +		char *out_fname = "hbm_out.log";
> +		/* Future support of ingress */
> +		// if (!outFlag)
> +		//	out_fname = "hbm_in.log";
> +
> +		read_trace_pipe2(out_fname);
> +	}
> +
>  	return rc;
>  err:
>  	rc = 1;
> diff --git a/tools/testing/selftests/bpf/trace_helpers.c b/tools/testing/selftests/bpf/trace_helpers.c
> index 1bbd1d9830c8..b7c184e109e8 100644
> --- a/tools/testing/selftests/bpf/trace_helpers.c
> +++ b/tools/testing/selftests/bpf/trace_helpers.c
> @@ -11,8 +11,6 @@
>  #include <sys/mman.h>
>  #include "trace_helpers.h"
>  
> -#define DEBUGFS "/sys/kernel/debug/tracing/"
Is this change needed?

> -
>  #define MAX_SYMS 300000
>  static struct ksym syms[MAX_SYMS];
>  static int sym_cnt;
> @@ -136,3 +134,34 @@ void read_trace_pipe(void)
>  		}
>  	}
>  }
> +
> +void read_trace_pipe2(char *filename)
> +{
> +	int trace_fd;
> +	FILE *outf;
> +
> +	trace_fd = open(DEBUGFS "trace_pipe", O_RDONLY, 0);
> +	if (trace_fd < 0) {
> +		printf("Error opening trace_pipe\n");
> +		return;
> +	}
> +
> +	outf = fopen(filename, "w");
> +	if (!outf)
> +		printf("Error creating %s\n", filename);
> +
> +	while (1) {
> +		static char buf[4096];
> +		ssize_t sz;
> +
> +		sz = read(trace_fd, buf, sizeof(buf) - 1);
> +		if (sz > 0) {
> +			buf[sz] = 0;
> +			puts(buf);
> +			if (outf) {
> +				fprintf(outf, "%s\n", buf);
> +				fflush(outf);
> +			}
> +		}
> +	}
It needs a fclose().

IIUC, this function will never return.  I am not sure
this is something that should be made available to selftests.

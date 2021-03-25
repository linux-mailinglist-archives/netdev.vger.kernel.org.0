Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAA96349C9A
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 00:00:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231328AbhCYW7q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 18:59:46 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:41686 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231191AbhCYW7N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Mar 2021 18:59:13 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12PMwCtl012952;
        Thu, 25 Mar 2021 15:58:56 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type :
 content-transfer-encoding : in-reply-to : mime-version; s=facebook;
 bh=3cAcD593WHMX5NvYfilxGHubw5cIwIM/VPD6mC1A83s=;
 b=qRIsAWdgvkNJwDv4lEe++EszXG3KI/30ZAfK4UwFi4pJ3zm+HDxJnYTuuU/yhu7/wEdn
 uRdDB8dj0lhwbt2ftjKhTZy83hlahFDwO6EmCW7XJaeoPpH+2cGvs3TKYEKa382VgH8b
 hIKnfAjputIf+cBRU82xWJtTjA65ikoeEA0= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 37h13xgwnn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 25 Mar 2021 15:58:56 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.199) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 25 Mar 2021 15:58:54 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WCLFns7mU//uc3iafOmPNZwrY42B62dLIsjBNanuYVhzzblu/3GmB2qU0Vu0gkgJRL1JZlccOPUmBYdv1ONwwTGoCGwstgeV00quyxVtb6rD0Giruax91eqpONUrJi0/EsxyTQPFX0iQ8wV89Sxf4JlSVH5wcS3mErl7nNLpK6BLIYq8ISbLkOXjz+1zQmF0m32NL6wfe4h7k6mNuk/s9LHwAWkKNIc9QXAhQ1wls36QGnG4JpXVselZKLPiHbXOLWwB5McyzbPNXw3ZBUnRXLuslQX/mRWslgi73u0TrDvo0K1sONMFXGeOtZD0/dofDcR2D/lzw+Kw1BKtkQIxBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=67rTKp6ZmcjJSeIZ7cvDobs3SbMcXCKCd1BsmuBy2k0=;
 b=GEx8m+vt2wlLYqy0rswwxNxBA77kn0kKXvcokaEfUpsWeTAHzEfxbB8STAM7XzTEDqmJc9V/KIXbMGPE3l3Smnmn2J2+F7sapR/vUp0flmckEM4/8IE8+ehTvU41MO56ZZ9xfTL1W85FMtAUskj7FELUCkDfyiP4oiwxXypVM2H+2oW8y/gz92qv6dNKHHhrY7NZrbgQ6Jwcbysg15lQ2xrq/chpC4ieZuLV5b9yLmTksVkjw82HmlMu3iEWvJiqUnQz4x+/mcvV4wXCvIpvDsFEcmL7d0icz+eIZN0GMAv4G2JRdJmbGWyME11uIgP8AIPy+pxmDbaePabcxfZhwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=fb.com;
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by BYAPR15MB3413.namprd15.prod.outlook.com (2603:10b6:a03:10b::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.23; Thu, 25 Mar
 2021 22:58:52 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::2975:c9d8:3f7f:dbd0]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::2975:c9d8:3f7f:dbd0%5]) with mapi id 15.20.3977.024; Thu, 25 Mar 2021
 22:58:52 +0000
Date:   Thu, 25 Mar 2021 15:58:48 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Clark Williams <williams@redhat.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>
Subject: Re: [PATCH bpf v2 2/2] bpf/selftests: test that kernel rejects a TCP
 CC with an invalid license
Message-ID: <20210325225848.ygdkq7ak54wjh7z5@kafai-mbp.dhcp.thefacebook.com>
References: <20210325211122.98620-1-toke@redhat.com>
 <20210325211122.98620-2-toke@redhat.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210325211122.98620-2-toke@redhat.com>
X-Originating-IP: [2620:10d:c090:400::5:815a]
X-ClientProxiedBy: MW2PR16CA0067.namprd16.prod.outlook.com
 (2603:10b6:907:1::44) To BY5PR15MB3571.namprd15.prod.outlook.com
 (2603:10b6:a03:1f6::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:815a) by MW2PR16CA0067.namprd16.prod.outlook.com (2603:10b6:907:1::44) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.24 via Frontend Transport; Thu, 25 Mar 2021 22:58:51 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 189ce94e-48a1-4752-5152-08d8efe18f22
X-MS-TrafficTypeDiagnostic: BYAPR15MB3413:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB34130F4757B4D88A74E8CDF7D5629@BYAPR15MB3413.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:1417;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kGYIEENDbVNrI+C1/rtBGe2przN3GMco/HSUkn0fsh/9ZJLEwrEtu7A7EH1oJg0ghgl1JDxx13hiLQwch23Kuini+XsNo/JohHfVTBJzwel7N97WlOO/8IjdctKmQWSz83odT2sJLTcaeDXpwSp7oPZ2pkxlgO3egAYOOSOBfqccYiwvEPVAAvXWbrRBRjNSiK+UzVzZaYf9Abf2WFGWvu40oLsPy1YE6kCQke5NszIQzOsEd2uclKVj8CKsevCReBvhV67DNZM/D+LQ12FMSe2WJqQY0c0NNkWvvWGoG+rHrtnOqiJb3hbLPkWWkwvqApWODD/Lg9Dqa304uCNd9mQyoun8yw2WVvkM3TgsCkYuMIMtO1AXUTGihlwGQEOLijsnJ9DZYeaVmYgYniT2LYjfJlRjIF8MFNXgrlQz0Oe1by/uWVScu/gawNZzf9nnos+b2777zLGK0T4p+er/qGcPoYLmFk71sP9HLZzMgzXuJJCRAdG7beC7iVF49PX5HhS2Wppy4k+C0lxFFeo5T0VVhIFq9H/Yzy8qM6+oNHxdbWi1/lXyNi+lk0/QElfa0NziV1W/n9wbHjdYqMqe/CoHLMgdxtT1rMMRAUHqxvujrFhcqiyggH5Y3L5jJgj+00UGo39yKkl97s3ZprUZdA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(39860400002)(346002)(136003)(396003)(366004)(6666004)(54906003)(38100700001)(6916009)(9686003)(66476007)(316002)(8676002)(478600001)(5660300002)(52116002)(7696005)(55016002)(6506007)(66946007)(4326008)(16526019)(2906002)(186003)(86362001)(66556008)(8936002)(83380400001)(7416002)(1076003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?iso-8859-1?Q?YxKjYxp3Ks/Z5t/CPkHOOHrh4iB9Umy240QyVH7xqA38juux4h63inLfe9?=
 =?iso-8859-1?Q?Y5eIwg+3z40cPuZp4znJ4F30YiR+5X5aQMMg1BBLxHs2ILKyrGMUObsEJ+?=
 =?iso-8859-1?Q?Dxs8xjCzWlwosGy40njEI8t1OBDHv5kCB9PMcB3QE5q9AJRGgSsCsMnZMH?=
 =?iso-8859-1?Q?yP+77oX3PbvsBi4CLl7qxkuzSk45V2rJJOx8YGriT5Syq4WTVVLduaCK19?=
 =?iso-8859-1?Q?npCpmC2T1QqciVPQmrMYeOGrVHwWFBvSjAMJmmI7JRz35SUI/55b+Hj6C8?=
 =?iso-8859-1?Q?fsS67Le7jTQC/qX1iTHMTMA1Q+InJAy21ijiMuKCHxOuSHyedvTGrqApEQ?=
 =?iso-8859-1?Q?J/LHW5jJX85jZDaRkJpfNJ2OLTJrxIuPI26p8fxpn6nIMwvNzq/Svhgak2?=
 =?iso-8859-1?Q?XRUUHgUSRGSKKqyueSqnZr+hvd+9Y3PCIbtPJqCsUToWM/BxTD9Mz+ac8W?=
 =?iso-8859-1?Q?v4aRFHobch9PPmtHjeh7KzR+2yNJCR4lpANq2tKwtok+9JkJmk0MgP/J1y?=
 =?iso-8859-1?Q?BhfEt9+yty5HlNgVyVPNzbWa4EVks2ilAhcmCbVOyKhgD/OkuC2CeLCP5A?=
 =?iso-8859-1?Q?kJ6xlSne75BsxaMAVpoqBja812GVuU1N1gvxi+oJ3Q/kUts1tvFpbG8Gkk?=
 =?iso-8859-1?Q?sHC+XHppTUgu1Nu5VevRsXaHY2YBspqlX2Mk6p58LdTkaT/NbLvAC2ZBNl?=
 =?iso-8859-1?Q?F25tY63QutrQn1C28BOkVqpvzN17QsZiJdooSv0kgK5YGzYhHEIx5CHffL?=
 =?iso-8859-1?Q?3Lhm20w4jVe6/oJF8G2ScLXCI9dcgqjlSYfa2jAOaqgCUH5n2bgWVb1X5/?=
 =?iso-8859-1?Q?6koWy0cuTQKWv57RiLLDK1B4h51H1SDektPNCrx+aR2PNPV4Q3APN5Btdg?=
 =?iso-8859-1?Q?8lDln+CyUI5WxqoLYrtLoYA6trevzcF4jIH8ZlgfN9nZntD5Wqvnb1pC29?=
 =?iso-8859-1?Q?NzsgTAG/Ca7qMzuSBx0NffT32t9vxBE2k+ZqG1/TfvmV1572xfsSIvXLGP?=
 =?iso-8859-1?Q?2vijPjLQvIwUIFXOEatDjKJzwzOLyLf1AOHWAL8+aSkwy8ghnxxEIdMQHi?=
 =?iso-8859-1?Q?FrcLUDlHkqm9eZNfZE6/MNyMuLviiD+LdITiZZLOygMD+riiPFrAFzFBHg?=
 =?iso-8859-1?Q?i/7eUYd8y2i1dAWyDzDwbUngjeONdfYc2zRNoYnx/i+KXkkOzMuipviWEg?=
 =?iso-8859-1?Q?1aK7Y/5dvxMwOlWFCuxiTs+593TUP0lZzbD9cC/kwVSENLCgB7cPGkEhc1?=
 =?iso-8859-1?Q?bqBb2KG24znmbiDFvDdmV4E4Gj5vGS8PfeFqfR4G/WrAMf7ZH5If3TNPYs?=
 =?iso-8859-1?Q?QsRNxqBXck640wGTQI04i4eiSEiaMAo3e0FODicGtjNJprRQiAeE+A8lhK?=
 =?iso-8859-1?Q?YK3Rw5UR7AgUcnPWRoXMk4BJXtYWWvVw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 189ce94e-48a1-4752-5152-08d8efe18f22
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB3571.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Mar 2021 22:58:52.2095
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: H+xTsrO0eX4OBNCLG9CpKvHhHscq7BrcMMJBHViDAAA0Lxf+vVnzNZglCB0cyDIc
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3413
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: hIKNP55Znmbsk0rkgHBY2YjQteA6zPwU
X-Proofpoint-GUID: hIKNP55Znmbsk0rkgHBY2YjQteA6zPwU
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-25_10:2021-03-25,2021-03-25 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=999
 impostorscore=0 adultscore=0 bulkscore=0 malwarescore=0 phishscore=0
 lowpriorityscore=0 mlxscore=0 spamscore=0 suspectscore=0 clxscore=1015
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2103250000 definitions=main-2103250170
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 25, 2021 at 10:11:22PM +0100, Toke Høiland-Jørgensen wrote:
> This adds a selftest to check that the verifier rejects a TCP CC struct_ops
> with a non-GPL license.
> 
> v2:
> - Use a minimal struct_ops BPF program instead of rewriting bpf_dctcp's
>   license in memory.
> - Check for the verifier reject message instead of just the return code.
> 
> Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
> ---
>  .../selftests/bpf/prog_tests/bpf_tcp_ca.c     | 44 +++++++++++++++++++
>  .../selftests/bpf/progs/bpf_nogpltcp.c        | 19 ++++++++
>  2 files changed, 63 insertions(+)
>  create mode 100644 tools/testing/selftests/bpf/progs/bpf_nogpltcp.c
> 
> diff --git a/tools/testing/selftests/bpf/prog_tests/bpf_tcp_ca.c b/tools/testing/selftests/bpf/prog_tests/bpf_tcp_ca.c
> index 37c5494a0381..a09c716528e1 100644
> --- a/tools/testing/selftests/bpf/prog_tests/bpf_tcp_ca.c
> +++ b/tools/testing/selftests/bpf/prog_tests/bpf_tcp_ca.c
> @@ -6,6 +6,7 @@
>  #include <test_progs.h>
>  #include "bpf_dctcp.skel.h"
>  #include "bpf_cubic.skel.h"
> +#include "bpf_nogpltcp.skel.h"
>  
>  #define min(a, b) ((a) < (b) ? (a) : (b))
>  
> @@ -227,10 +228,53 @@ static void test_dctcp(void)
>  	bpf_dctcp__destroy(dctcp_skel);
>  }
>  
> +static char *err_str = NULL;
> +static bool found = false;
Nit. These two inits are not needed.

> +
> +static int libbpf_debug_print(enum libbpf_print_level level,
> +			      const char *format, va_list args)
> +{
> +	char *log_buf;
> +
> +	if (level != LIBBPF_WARN ||
> +	    strcmp(format, "libbpf: \n%s\n")) {
> +		vprintf(format, args);
> +		return 0;
> +	}
> +
> +	log_buf = va_arg(args, char *);
> +	if (!log_buf)
> +		goto out;
> +	if (err_str && strstr(log_buf, err_str) != NULL)
> +		found = true;
> +out:
> +	printf(format, log_buf);
> +	return 0;
> +}
> +
> +static void test_invalid_license(void)
> +{
> +	libbpf_print_fn_t old_print_fn = NULL;
Nit. Same here.  Not need to init NULL.

Others lgtm.

Acked-by: Martin KaFai Lau <kafai@fb.com>

> +	struct bpf_nogpltcp *skel;
> +
> +	err_str = "struct ops programs must have a GPL compatible license";
> +	old_print_fn = libbpf_set_print(libbpf_debug_print);
> +
> +	skel = bpf_nogpltcp__open_and_load();
> +	if (CHECK(skel, "bpf_nogplgtcp__open_and_load()", "didn't fail\n"))
> +		bpf_nogpltcp__destroy(skel);
> +
> +	CHECK(!found, "errmsg check", "expected string '%s'", err_str);
> +
> +	libbpf_set_print(old_print_fn);
> +}

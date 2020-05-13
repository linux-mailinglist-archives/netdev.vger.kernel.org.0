Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 923D21D046C
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 03:40:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731804AbgEMBkR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 21:40:17 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:3206 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731298AbgEMBkQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 May 2020 21:40:16 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04D1dE4J014358;
        Tue, 12 May 2020 18:40:02 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=v6c0WobBCmef0ZNXdnoQ/P1232DhaJoCqZISEuKfcXw=;
 b=Dcl9Scdsy0pAnIx7oqJCNLWWEqzFUU+4i3mz+n6rU07HJ/zh3bIEZphJb4PgEtUyjQLu
 Gf67DW2MJgtJYLH/4+z8oo9bSVt7J7k/aRz4jrk0RxjnfBoe4JhD2JEqc0H9MK5M77G1
 XkSzq1IRaq0JyQQGDZl6FWx2SHfELn3/etI= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3100x5t2n2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 12 May 2020 18:40:02 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.196) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Tue, 12 May 2020 18:40:00 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H1n6ZtH26dGkdlKLPQLX/OOGkPZbsD6/05wB+odFOdQv4mK5vRlF17iO9nasdKPZKeqtaXq+rQ0D+k1ngu+TQ6P5WoEN671J4t8zr+VNsHxsHnl4/V7F+XnMkPZ9hLFbVoJ6JAcifLmrOsdUTK0ANNnfmbiIo0n+ITPZA4kTzD1t+LeOhdoEfENl2szf4iUhkYB4NaScbZCXs3at/YgNQo5p3up97VNxgh37I/8K42IGTxjEoAVEIgBWpB7auAcb21KyfzzKTBH/iJbPZbFJCuZ9bTuTVSm2636mWSWFDB5Tb+6Fpe/a8Rw9JNkkzI4wV7AoiXARdLBcV780HSWiEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v6c0WobBCmef0ZNXdnoQ/P1232DhaJoCqZISEuKfcXw=;
 b=COINdsY11ZI1NRjLFbbYCWiWLEgfcskpFiO18l6fUErJFtOtRWS40r0DDok2w5qgyTEdqfZuaxtEPjBJktfUvmW6vOhhjmoofniRU9KgLSTcAUEY2T4kTyU6bu5wXcXsGSLTroLzs6SJ95Ks55kNuc879JQLEdfVIycUmzv35HgkMXfkZ17x9Ix7PkzpNdeJaDJDmp+BVQmbXqtG/uivLde/egq4u+JRzxhjgliCM14vIGNDicRhmZcxBhkr6tHxHVVnLiDTXdS5LwAH636zmUp9KBQxrQcegi9P7rxy8mfYrRoG3lGPSfn+U8Y8Sk9jwWUrm+c/I8vop7m1nDNjIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v6c0WobBCmef0ZNXdnoQ/P1232DhaJoCqZISEuKfcXw=;
 b=XqO5imH+seHRS/kqpeDFWUG5QdCu10rU67iJmdzf7xMxpKWekGRGOzOiMO5pmbaMiRTUS5KVXrqLZ+xHwdI/nJi5YrdzjmLX1Jzs0aBBCamHPYAunNpspcm9rs8zbUhSAsdnJaBI2nAgAeZRUUHGyC+ZEZA+L3AZK9uuEcw0CVg=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB3317.namprd15.prod.outlook.com (2603:10b6:a03:101::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.35; Wed, 13 May
 2020 01:40:00 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::4922:9927:5d6c:5301]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::4922:9927:5d6c:5301%7]) with mapi id 15.20.2979.033; Wed, 13 May 2020
 01:40:00 +0000
Subject: Re: [PATCH bpf-next 1/3] samples: bpf: refactor kprobe tracing user
 progs with libbpf
To:     "Daniel T. Lee" <danieltimlee@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>
CC:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>
References: <20200512144339.1617069-1-danieltimlee@gmail.com>
 <20200512144339.1617069-2-danieltimlee@gmail.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <f8d524dc-245b-e8c6-3e0b-16969df76b0a@fb.com>
Date:   Tue, 12 May 2020 18:39:57 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.0
In-Reply-To: <20200512144339.1617069-2-danieltimlee@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR11CA0072.namprd11.prod.outlook.com
 (2603:10b6:a03:80::49) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from MacBook-Pro-52.local (2620:10d:c090:400::5:dfef) by BYAPR11CA0072.namprd11.prod.outlook.com (2603:10b6:a03:80::49) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.28 via Frontend Transport; Wed, 13 May 2020 01:39:59 +0000
X-Originating-IP: [2620:10d:c090:400::5:dfef]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0eb9e772-cae5-492d-6966-08d7f6de8c7c
X-MS-TrafficTypeDiagnostic: BYAPR15MB3317:
X-Microsoft-Antispam-PRVS: <BYAPR15MB3317BE781258AC996B699779D3BF0@BYAPR15MB3317.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:118;
X-Forefront-PRVS: 0402872DA1
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tP43u4Gf2IKkqe8yqu0BQ9A4auPRNvohfgA7EI4VlAuWpOAnKZmEj5EI+au5kFM2Hs6daOpGfqkSvT2zB1lrp0kiqN0BEaBKA2maVMjCbSj7ZjVzRlNXUwxpnHXXcNM6MctzsgDzefUCf0rJ8YrHM4oSAuK5GM+FJfuYBgSoBo/Smp/gm10sZXFiEiVs0pHeH49P4A/9sz3+1woUCZSKQm8t+Owy7DpHZjkLVhnCApehKNonNHuK4mwcluvR5j9n+G3Gqpq+JpxC0Qf75PjtI57wwacj7d4t+36XQLfEtv0cODwNIY1UwK4pH19B6uTdrTCYjC2jR3BGQXBdhx6Cbmta578KJAdp4Yq7phaMuD+lIZLTEVpxZNoxPD/EMLLDdfTNIWYSTrKJJekjvvwi1LOC5wfh0uKEf4B2PaNTd45q2NKPzmdIrH34H5x0jnCZY/u50WbU+GtJX+I3PpwS2Ywcm1CQN2pnxNixb3vWPfDiVVAgd8T+p+eepByGy6fZKIaXcM2vnoYyp/vLTUXuGVUSKNlqYm0WtGeuUm4t0o7Lq/PYBTS8cd3SDyzj1vC9
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(366004)(346002)(136003)(376002)(396003)(39860400002)(33430700001)(33440700001)(66946007)(316002)(52116002)(110136005)(6486002)(54906003)(2906002)(5660300002)(36756003)(31686004)(86362001)(6512007)(31696002)(66476007)(66556008)(186003)(16526019)(8936002)(8676002)(2616005)(4326008)(478600001)(6506007)(53546011)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: gaVgNc4eVhS42eoP+QxMRksC8k3B2Vj80lQCrbCjUvLdKgCVZDxmkLbHKKvqIpkGKtKfuzQwlI4mnI54hpnPdrL44OnClcSALv+AEgyrkxYriFSRCLVkUMC2BsfS640SRFmt/77IF3cfnNHSKQK/n6+TxvO9/WzsBeQxbaxPfSJBIuAKldLEOiCivPGofJI45nua3JOR9oGGVXwYWxzHfNMMlnOzpQ8nxLZP9TnZyxmR4O/uT8oXbJYvO08xiZQFr+Frsmg2sheK4vJwO+CStdU9/dXXDnBypD51Y0BlVRmmASbzK1jIbU7NWcWRU2cNnI3kHFJB/a4fxcUhtFnrO6eLnV9BH18zZY4WQBz4HDKM4EkNG6QIm44MypqQ1YUyKuYuAghTksJ898ghx4CF5pwknnLZRpgioLipwOdhjAw5GIyO7jT5PhpAXR2P6sGLgXn1NeWSmCg0kprM0FsSNju1b26G2NAMkYx0F4kbvxexgPR4P69Nn9NchhMxZhyR06xVn/X5iiDrjF7hNXJ09g==
X-MS-Exchange-CrossTenant-Network-Message-Id: 0eb9e772-cae5-492d-6966-08d7f6de8c7c
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 May 2020 01:39:59.8319
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Deu7OwdJI5WLtdnTJYUoiFtyaz1zwzAivddBo/jTetljSxL5u/JFvaoxVYLD2PCZ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3317
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-12_08:2020-05-11,2020-05-12 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 mlxlogscore=999 spamscore=0 clxscore=1011 cotscore=-2147483648
 malwarescore=0 impostorscore=0 bulkscore=0 adultscore=0 priorityscore=1501
 phishscore=0 mlxscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2005130013
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/12/20 7:43 AM, Daniel T. Lee wrote:
> Currently, the kprobe BPF program attachment method for bpf_load is
> quite old. The implementation of bpf_load "directly" controls and
> manages(create, delete) the kprobe events of DEBUGFS. On the other hand,
> using using the libbpf automatically manages the kprobe event.
> (under bpf_link interface)
> 
> By calling bpf_program__attach(_kprobe) in libbpf, the corresponding
> kprobe is created and the BPF program will be attached to this kprobe.
> To remove this, by simply invoking bpf_link__destroy will clean up the
> event.
> 
> This commit refactors kprobe tracing programs (tracex{1~7}_user.c) with
> libbpf using bpf_link interface and bpf_program__attach.
> 
> tracex2_kern.c, which tracks system calls (sys_*), has been modified to
> append prefix depending on architecture.
> 
> Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
> ---
>   samples/bpf/Makefile       | 12 +++----
>   samples/bpf/tracex1_user.c | 41 ++++++++++++++++++++----
>   samples/bpf/tracex2_kern.c |  8 ++++-
>   samples/bpf/tracex2_user.c | 55 ++++++++++++++++++++++++++------
>   samples/bpf/tracex3_user.c | 65 ++++++++++++++++++++++++++++----------
>   samples/bpf/tracex4_user.c | 55 +++++++++++++++++++++++++-------
>   samples/bpf/tracex6_user.c | 53 +++++++++++++++++++++++++++----
>   samples/bpf/tracex7_user.c | 43 ++++++++++++++++++++-----
>   8 files changed, 268 insertions(+), 64 deletions(-)
> 
> diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
> index 424f6fe7ce38..4c91e5914329 100644
> --- a/samples/bpf/Makefile
> +++ b/samples/bpf/Makefile
> @@ -64,13 +64,13 @@ fds_example-objs := fds_example.o
>   sockex1-objs := sockex1_user.o
>   sockex2-objs := sockex2_user.o
>   sockex3-objs := bpf_load.o sockex3_user.o
> -tracex1-objs := bpf_load.o tracex1_user.o $(TRACE_HELPERS)
> -tracex2-objs := bpf_load.o tracex2_user.o
> -tracex3-objs := bpf_load.o tracex3_user.o
> -tracex4-objs := bpf_load.o tracex4_user.o
> +tracex1-objs := tracex1_user.o $(TRACE_HELPERS)
> +tracex2-objs := tracex2_user.o
> +tracex3-objs := tracex3_user.o
> +tracex4-objs := tracex4_user.o
>   tracex5-objs := bpf_load.o tracex5_user.o $(TRACE_HELPERS)
> -tracex6-objs := bpf_load.o tracex6_user.o
> -tracex7-objs := bpf_load.o tracex7_user.o
> +tracex6-objs := tracex6_user.o
> +tracex7-objs := tracex7_user.o
>   test_probe_write_user-objs := bpf_load.o test_probe_write_user_user.o
>   trace_output-objs := bpf_load.o trace_output_user.o $(TRACE_HELPERS)
>   lathist-objs := bpf_load.o lathist_user.o
> diff --git a/samples/bpf/tracex1_user.c b/samples/bpf/tracex1_user.c
> index 55fddbd08702..1b15ab98f7d3 100644
> --- a/samples/bpf/tracex1_user.c
> +++ b/samples/bpf/tracex1_user.c
> @@ -1,21 +1,45 @@
>   // SPDX-License-Identifier: GPL-2.0
>   #include <stdio.h>
> -#include <linux/bpf.h>
>   #include <unistd.h>
> -#include <bpf/bpf.h>
> -#include "bpf_load.h"
> +#include <bpf/libbpf.h>
>   #include "trace_helpers.h"
>   
> +#define __must_check

This is not very user friendly.
Maybe not including linux/err.h and
use libbpf API libbpf_get_error() instead?

> +#include <linux/err.h>
> +
>   int main(int ac, char **argv)
>   {
> -	FILE *f;
> +	struct bpf_link *link = NULL;
> +	struct bpf_program *prog;
> +	struct bpf_object *obj;
>   	char filename[256];
> +	FILE *f;
>   
>   	snprintf(filename, sizeof(filename), "%s_kern.o", argv[0]);
> +	obj = bpf_object__open_file(filename, NULL);
> +	if (IS_ERR(obj)) {
> +		fprintf(stderr, "ERROR: opening BPF object file failed\n");
> +		obj = NULL;
> +		goto cleanup;

You do not need to goto cleanup, directly return 0 is okay here.
The same for other files in this patch.

> +	}
> +
> +	prog = bpf_object__find_program_by_name(obj, "bpf_prog1");
> +	if (!prog) {
> +		fprintf(stderr, "ERROR: finding a prog in obj file failed\n");
> +		goto cleanup;
> +	}
> +
> +	/* load BPF program */
> +	if (bpf_object__load(obj)) {
> +		fprintf(stderr, "ERROR: loading BPF object file failed\n");
> +		goto cleanup;
> +	}
>   
> -	if (load_bpf_file(filename)) {
> -		printf("%s", bpf_log_buf);
> -		return 1;
> +	link = bpf_program__attach(prog);
> +	if (IS_ERR(link)) {
> +		fprintf(stderr, "ERROR: bpf_program__attach failed\n");
> +		link = NULL;
> +		goto cleanup;
>   	}
>   
>   	f = popen("taskset 1 ping -c5 localhost", "r");
> @@ -23,5 +47,8 @@ int main(int ac, char **argv)
>   
>   	read_trace_pipe();
>   
> +cleanup:
> +	bpf_link__destroy(link);
> +	bpf_object__close(obj);

Typically in kernel, we do multiple labels for such cases
like
destroy_link:
	bpf_link__destroy(link);
close_object:
	bpf_object__close(obj);

The error path in the main() function jumps to proper label.
This is more clean and less confusion.

The same for other cases in this file.

>   	return 0;
>   }
> diff --git a/samples/bpf/tracex2_kern.c b/samples/bpf/tracex2_kern.c
> index d865bb309bcb..ff5d00916733 100644
> --- a/samples/bpf/tracex2_kern.c
> +++ b/samples/bpf/tracex2_kern.c
> @@ -11,6 +11,12 @@
>   #include <bpf/bpf_helpers.h>
>   #include <bpf/bpf_tracing.h>
>   
> +#ifdef __x86_64__
> +#define SYSCALL "__x64_"
> +#else
> +#define SYSCALL
> +#endif

See test_progs.h, one more case to handle:
#ifdef __x86_64__
#define SYS_NANOSLEEP_KPROBE_NAME "__x64_sys_nanosleep"
#elif defined(__s390x__)
#define SYS_NANOSLEEP_KPROBE_NAME "__s390x_sys_nanosleep"
#else
#define SYS_NANOSLEEP_KPROBE_NAME "sys_nanosleep"
#endif

> +
>   struct bpf_map_def SEC("maps") my_map = {
>   	.type = BPF_MAP_TYPE_HASH,
>   	.key_size = sizeof(long),
> @@ -77,7 +83,7 @@ struct bpf_map_def SEC("maps") my_hist_map = {
>   	.max_entries = 1024,
>   };
>   
> -SEC("kprobe/sys_write")
> +SEC("kprobe/" SYSCALL "sys_write")
>   int bpf_prog3(struct pt_regs *ctx)
>   {
>   	long write_size = PT_REGS_PARM3(ctx);
[...]

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B2821DD605
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 20:32:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729504AbgEUScd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 14:32:33 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:23036 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728670AbgEUScd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 May 2020 14:32:33 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04LIUmHL011401;
        Thu, 21 May 2020 11:32:19 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=wXvlziOBgFn61qBc+Zj4Y6739F5SfRCrFlbSudJXfOc=;
 b=Mg69xmWrbPu7vCbZBssnFifajoscSIQjm9XVv+/8wNnqb7nIJ4UoiGTUo68r1Gf2X7Zq
 zwiavgJs8q66jEitCncOsfvfd4gFKOtdwtRa09/54bZ3SOwDXFNiqrgUt3Gk1TSoPaB2
 V5VxPCKwBaGh5r9FCUV7woAsLoo86lJDmlk= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 315uev9ycm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 21 May 2020 11:32:18 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Thu, 21 May 2020 11:32:17 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AlFU4k8AE31/K7avLVP8yLdvt5QGo9Qf6IXpqePFnKFGkWQwRjX6Qilw1aPZec+rj+icu46mS9XLxoqxVKxF6nKxCOiVt5qsYTldgxHjqKbITcpoJ0TvI8T4UhK5WOvevrCHCaUX9luIeXF67xUok38HrsgQ2rxgltQ1NrNADy6i9NhjZm6pGvEKiJzOzp0AMi+PumBjkLzlEpHIIaLqYMdyFepXPGd2PMUhPrAZmg3ATA+idO3gVxIrkHWqcC1JvDMigKEfWsiH1QUm2iguEii4zJWLR911D7F7FJL9StdzF7xOsDBRR+PnPcvQt/ce+mv0OaFmwcuJa/nHlpX4qg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wXvlziOBgFn61qBc+Zj4Y6739F5SfRCrFlbSudJXfOc=;
 b=e3Mxi0dbYeXHWajoB/dW1KZ7CK5uMhTve2h4+Vs0/H+gtWk2uLjKsCcOKf+UltGRfqYygpAMbwidDSG5/oe1wJdlviE1rodocZLkyCNI0gXAUjyb5IWcXPYj92Ix+BjEtavy4c7DkhcuVtV5gOby5a9+3xArI4mHjnQ8gxZFCqatWD/13gumCokhfmgnAJ29GWAZTf6H0q80zdWReb0BjVHyjkBhL0OBfnsFKJ4JPguyYWQRQfN3cpLDoUU/BPr7B3GbEj9fRXPuC66pT1ONo9KSQaVhzDITe4iXU3W1Kd+tLczTC+GYJ1SxgwxoRaExeTx9/hGX6hNdJXgW35GEbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wXvlziOBgFn61qBc+Zj4Y6739F5SfRCrFlbSudJXfOc=;
 b=ie6kGusxMSP5l8RzSAPBrGz0jIEwrgX61mQM34GHq2FQtNjINgOeLM89OtYJkrYMA8ZZLu8Oz/EI1MIKW9jkvaE3LfxEg1R6JDan3Ip1Xneus/ZUVgZ4fau20nHzk3kMSABZMeDz0L6ewz9LCQhw/fi/TFqL27pLDZOByvptqHc=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB2279.namprd15.prod.outlook.com (2603:10b6:a02:85::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.27; Thu, 21 May
 2020 18:32:16 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::4922:9927:5d6c:5301]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::4922:9927:5d6c:5301%7]) with mapi id 15.20.3021.024; Thu, 21 May 2020
 18:32:16 +0000
Subject: Re: [bpf-next PATCH v3 5/5] bpf: selftests, test probe_* helpers from
 SCHED_CLS
To:     John Fastabend <john.fastabend@gmail.com>, <ast@kernel.org>,
        <daniel@iogearbox.net>
CC:     <lmb@cloudflare.com>, <bpf@vger.kernel.org>,
        <jakub@cloudflare.com>, <netdev@vger.kernel.org>
References: <159007153289.10695.12380087259405383510.stgit@john-Precision-5820-Tower>
 <159007177838.10695.12211214514015683724.stgit@john-Precision-5820-Tower>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <68b320be-89e5-6b39-05c0-4edbda01f5d1@fb.com>
Date:   Thu, 21 May 2020 11:32:14 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.0
In-Reply-To: <159007177838.10695.12211214514015683724.stgit@john-Precision-5820-Tower>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY3PR04CA0012.namprd04.prod.outlook.com
 (2603:10b6:a03:217::17) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from MacBook-Pro-52.local (2620:10d:c090:400::5:741b) by BY3PR04CA0012.namprd04.prod.outlook.com (2603:10b6:a03:217::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.23 via Frontend Transport; Thu, 21 May 2020 18:32:15 +0000
X-Originating-IP: [2620:10d:c090:400::5:741b]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9a7f3016-8868-405e-8fe8-08d7fdb549aa
X-MS-TrafficTypeDiagnostic: BYAPR15MB2279:
X-Microsoft-Antispam-PRVS: <BYAPR15MB227945791BB6DEB3F2BADC40D3B70@BYAPR15MB2279.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:2733;
X-Forefront-PRVS: 041032FF37
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pJqowaaOV455IYVNwMnh5qEoI/xnNRGLXST9Mp6rlxWSDJL3e3LNrd8F+lV8+mQlxUmBZBdbsHiGZd28Ou2uewSgMtZDIFbrXG05uUGzsYi1Lpf9hHoUHrTmMttkf8sUI9ZtDdgW1g4v9eb5My3fuXKnGhRpS4f5NSs1MP6QxqgrlcfC1TJXLLVhjOrV9Uf2vIpxqEt6LodZBWUukxRXgJTqKoVGeK1eq0wTqHrb+FutA634KJ3ezdHQP3ym5+Kb1E3ih4ady7NkpZNk/Bjk1rRn/zB9RXEbpJ2ZmJVVdy04djSkeWP04/p1YzQObs5/xGsA7cV0GFMzCxmkI+IwkyunfgfE2cZ/c/LYt91FbHk14ji/YQqiWZ9e3npHrUjF
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(136003)(39860400002)(376002)(346002)(396003)(366004)(8676002)(66476007)(66556008)(66946007)(5660300002)(8936002)(186003)(16526019)(478600001)(2616005)(31686004)(6512007)(86362001)(31696002)(6486002)(52116002)(316002)(6506007)(53546011)(2906002)(4326008)(36756003)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: eQuZoTl60ZZikUL5bkJ95w5eFxe5puxsm3A7JBS5KrOaqgulVq78tkC4w3GBB35/P+uNV1cbkBoPMCWTQ/jdDXkIuFXjfxWaIYq7yydvXU4HfacteJ4L6IXk0BwwDycAW6+eanHumdKQr0FHQzMJUuCdLZaCBX8bkj6j2/T1ZQ4v0Kg+MSpJdxAWeTa5ufqrZQjrmp/BbK3p8UkwF2PNvp+p5dg2J0ZyiadfOPIHcDuhlNOM3Rogiylla44V9QOizApSs2k8Dz24xhQh1Yl8AkDQR2JDD4ZYZcOmNK6Eq1prYUkL1smY8bh82DoMru0n5Ry22PWIGWCvHAwM5wrfcjcKZE5LSYBGgRWia8qU1B6Wq46PdWdET0RWyulKUZSAM2yERMaACpqcT24wanF3lOYSFBmXj/HuEMGcSDo0rHAAnpBeKo/Qa4w5AS2/e/ULOA6nAT5jNCbOa+zxx2G00iEpWhO76eCXmm+wP+4nJ3bWp4hLD6E/y2zVGHdlQQKc5NC634iSoKbUZm9q9k+YIQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a7f3016-8868-405e-8fe8-08d7fdb549aa
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 May 2020 18:32:16.6015
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: T9cOlFHEOMcUf4Y9NBF0/Su2+SjVzH3jtxjQCYgeji4iVBm24dZyoJcjFiFaztDT
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2279
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-21_12:2020-05-21,2020-05-21 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0
 suspectscore=0 malwarescore=0 adultscore=0 cotscore=-2147483648
 priorityscore=1501 impostorscore=0 mlxscore=0 mlxlogscore=999 phishscore=0
 spamscore=0 clxscore=1015 lowpriorityscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005210134
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/21/20 7:36 AM, John Fastabend wrote:
> Lets test using probe* in SCHED_CLS network programs as well just
> to be sure these keep working. Its cheap to add the extra test
> and provides a second context to test outside of sk_msg after
> we generalized probe* helpers to all networking types.
> 
> Signed-off-by: John Fastabend <john.fastabend@gmail.com>

Ack with a minor nit below.

Acked-by: Yonghong Song <yhs@fb.com>

> ---
>   .../testing/selftests/bpf/prog_tests/skb_helpers.c |   30 ++++++++++++++++++
>   .../testing/selftests/bpf/progs/test_skb_helpers.c |   33 ++++++++++++++++++++
>   2 files changed, 63 insertions(+)
>   create mode 100644 tools/testing/selftests/bpf/prog_tests/skb_helpers.c
>   create mode 100644 tools/testing/selftests/bpf/progs/test_skb_helpers.c
> 
> diff --git a/tools/testing/selftests/bpf/prog_tests/skb_helpers.c b/tools/testing/selftests/bpf/prog_tests/skb_helpers.c
> new file mode 100644
> index 0000000..5a865c4
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/prog_tests/skb_helpers.c
> @@ -0,0 +1,30 @@
> +// SPDX-License-Identifier: GPL-2.0
> +#include <test_progs.h>
> +#include <network_helpers.h>
> +
> +void test_skb_helpers(void)
> +{
> +	struct __sk_buff skb = {
> +		.wire_len = 100,
> +		.gso_segs = 8,
> +		.gso_size = 10,
> +	};
> +	struct bpf_prog_test_run_attr tattr = {
> +		.data_in = &pkt_v4,
> +		.data_size_in = sizeof(pkt_v4),
> +		.ctx_in = &skb,
> +		.ctx_size_in = sizeof(skb),
> +		.ctx_out = &skb,
> +		.ctx_size_out = sizeof(skb),
> +	};
> +	struct bpf_object *obj;
> +	int err;
> +
> +	err = bpf_prog_load("./test_skb_helpers.o", BPF_PROG_TYPE_SCHED_CLS, &obj,
> +			    &tattr.prog_fd);
> +	if (CHECK_ATTR(err, "load", "err %d errno %d\n", err, errno))
> +		return;
> +
> +	err = bpf_prog_test_run_xattr(&tattr);
> +	CHECK_ATTR(err != 0, "len", "err %d errno %d\n", err, errno);
> +}
> diff --git a/tools/testing/selftests/bpf/progs/test_skb_helpers.c b/tools/testing/selftests/bpf/progs/test_skb_helpers.c
> new file mode 100644
> index 0000000..05a1260
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/progs/test_skb_helpers.c
> @@ -0,0 +1,33 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +#include "vmlinux.h"
> +#include <bpf/bpf_helpers.h>
> +#include <bpf/bpf_endian.h>
> +
> +int _version SEC("version") = 1;
> +
> +#define TEST_COMM_LEN 10
> +
> +struct bpf_map_def SEC("maps") cgroup_map = {
> +	.type			= BPF_MAP_TYPE_CGROUP_ARRAY,
> +	.key_size		= sizeof(u32),
> +	.value_size		= sizeof(u32),
> +	.max_entries	= 1,
> +};
> +
> +char _license[] SEC("license") = "GPL";
> +
> +SEC("classifier/test_skb_helpers")
> +int test_skb_helpers(struct __sk_buff *skb)
> +{
> +	struct task_struct *task;
> +	char *comm[TEST_COMM_LEN];
> +	__u32 tpid;
> +	int ctask;
> +
> +	ctask = bpf_current_task_under_cgroup(&cgroup_map, 0);

ctask is not used. Could you test ctask against expected value?

> +	task = (struct task_struct *)bpf_get_current_task();
> +
> +	bpf_probe_read_kernel(&tpid , sizeof(tpid), &task->tgid);
> +	bpf_probe_read_kernel_str(&comm, sizeof(comm), &task->comm);
> +	return 0;
> +}
> 

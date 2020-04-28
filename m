Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62DDD1BB62A
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 08:04:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726315AbgD1GEr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 02:04:47 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:29882 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725792AbgD1GEr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Apr 2020 02:04:47 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 03S62E0q032499;
        Mon, 27 Apr 2020 23:04:32 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=Yq5Y38SiL8lcxgXBu9aIuiHFphUi3+tLONUWLdLMxrw=;
 b=TwUkWD48IZAY8yUSPRfz8AWLn/EQfymgIKfHexzdv/PazQAFsMgvIPnDYJJrvfw7Z+78
 e40h9zFM9r17nD3prdcwwP68M9PTYYk375W2sVK2zyW7J5OxJrBl+JvYTJxEk2U2uHA3
 gJXUfyqyunPR94wJfyN0inqWSLqcSEubgbU= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0001303.ppops.net with ESMTP id 30mgvnh4ae-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 27 Apr 2020 23:04:32 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Mon, 27 Apr 2020 23:04:31 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c6iADcHAca0VcUKtocMQqPUn9R7o/OlBibeh1ZK5pVF1IRAx8Bi1IJ3YIyPseRwmO0/0lvgsF3NprFKWqwhHRIf5OgTqxi9nYG5bMrOpzoeSHngUDHNTQr72OvEq/yyyrDHKiX6ryoRGOw1oZr9Je0TkTz79bch6zwrTHYh0c7TRka3o8ZBy2M02iIZCRMt0K+9OFNIZoJ9YHUo/YC6BDdO6teLgKFML6D4FDloi4yJrg+P5/Ddc0l9gB/FzzPay+FBDLXhrmrp9hOi7h8WdwZRdibGUv6AGwZgszbxAOQ2bEQqZnen5K14cSRvd1iN5ce0GnylBkOSJy0Xzl7lAJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Yq5Y38SiL8lcxgXBu9aIuiHFphUi3+tLONUWLdLMxrw=;
 b=TGEOmZ8N4LrZ/26w/++nUzV0Y4dRrcLcDTPiaAqAHJ6+u/wXgzUIrG9LAFCtvZ4yquixLMp/eswQaGShZkGQCKCXSy7HtHCWzx0ZlayRyQ9DTKvVAg0b3SYZESGnlR+fDEmYUlMEZx1TXtubPy7r1UmBPhyL9QTtmBQtlBC2XUZooaQFizD8AnKwsALZxpm84XYswC5pQGdDShYl/Pd36fpA8FvPIcPh9I+OOJ/vJ03KsBaaqLLOeXuCJZJ+8INuDDmY2vPNhy9Vt5zrJbZsq/g0NCwwN77ag8wmx5+uNsfxsBXwr/meNz24IagHKVnoJgewrnKldjOPL8K/62snZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Yq5Y38SiL8lcxgXBu9aIuiHFphUi3+tLONUWLdLMxrw=;
 b=ebJdXvUNbjHN21Zn4osNFcKKIv6WUm9/guzzoUIluZrHrBJuZ7QocnFVx06xtBNukdKiYFqVN9zgeqfL0Pht7jnddRK43Fnk5kbHRKC0kfLemEDW0HPCRW1nRG0RxZae7SnM+EU+jmfD5xPLx5gS4WMCeBGETlS8qf/eXOGkQfs=
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB3477.namprd15.prod.outlook.com (2603:10b6:a03:10e::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.13; Tue, 28 Apr
 2020 06:04:30 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::8988:aa27:5d70:6923]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::8988:aa27:5d70:6923%5]) with mapi id 15.20.2937.023; Tue, 28 Apr 2020
 06:04:30 +0000
Subject: Re: [PATCH v5 bpf-next 3/3] bpf: add selftest for BPF_ENABLE_STATS
To:     Song Liu <songliubraving@fb.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>
CC:     <ast@kernel.org>, <daniel@iogearbox.net>, <kernel-team@fb.com>
References: <20200427234423.998085-1-songliubraving@fb.com>
 <20200427234423.998085-4-songliubraving@fb.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <09720b42-9858-0e2f-babf-f3cd27f648e6@fb.com>
Date:   Mon, 27 Apr 2020 23:04:27 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
In-Reply-To: <20200427234423.998085-4-songliubraving@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MWHPR1201CA0024.namprd12.prod.outlook.com
 (2603:10b6:301:4a::34) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from MacBook-Pro-52.local (2620:10d:c090:400::5:f088) by MWHPR1201CA0024.namprd12.prod.outlook.com (2603:10b6:301:4a::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.13 via Frontend Transport; Tue, 28 Apr 2020 06:04:29 +0000
X-Originating-IP: [2620:10d:c090:400::5:f088]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 303e8a8a-fb3b-4065-d8ce-08d7eb3a03d3
X-MS-TrafficTypeDiagnostic: BYAPR15MB3477:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB3477DDDA5BD6F18E403F06BBD3AC0@BYAPR15MB3477.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:935;
X-Forefront-PRVS: 0387D64A71
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(396003)(366004)(346002)(39860400002)(136003)(376002)(478600001)(2616005)(8936002)(66556008)(52116002)(6506007)(53546011)(4326008)(6486002)(8676002)(81156014)(16526019)(6512007)(186003)(66476007)(66946007)(2906002)(316002)(5660300002)(31686004)(36756003)(86362001)(31696002);DIR:OUT;SFP:1102;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hyMAdJ6MWzv3GB8hWGf2pzv27PxaGPC5sW06g+Y2JSFsQ6F116Stmny77AxOX2OjAMj05Va9QA0a0n0lVgqBXqT4FEtWIPk90sfaLcnbecUk02+IcDNsURyN/1g/yrqpWwOyanMM9Jm4l3s2wL0OVzP+NliGRFOHIo/l+cCVPlOKSZnDXvX8a23rlNjlYc2W3002229Ls42H7WSTf5gDn2SeWH8i6vDbu2HGwGBBrP8KpUnrCzVsZC1MnH+J3oo7vUT8Grq63Q2RckVbSYiSYipzzOW40A5fK8Kmeek4Byt7koeVNstmBs1F6lV8OtjhXCzuWT58VpjwWoW3MtIFkrGca6bfOYLqKsNb7MBYYvsAqAZFq7ah0N6NosEeJJ+Ao4jbbRCVt9q0t1tVLoeiMDxE+eghLHde6FbIoP7tNxemYGFloDIiRPF3rNY4JU7D
X-MS-Exchange-AntiSpam-MessageData: TulULqH1H/3f+TW0kNffsA4MyAOfmFgvdtVT8PA3NpNxYg0L3mclJv5ZO8k9ra4CFfJbSXb1EdmiBZKUF57Lr0tuvW5gPJCvSmB+IO29JuQ775Lf5+q1gYPcekTxsr4TDE3MXZ+36Ne0OlV92+wMsyjvzkY5W1oL4pi2TwG0mbW9UINj9J8oEBCVyTVVqIp3oGvOahm4k7Ff08NkgVlrjbe9XwVgRtux3FXJN7OCz9R5V54Ml32d9FJBf1NVK3zb7q58plP98Qv+BfE3Oitw7FGexHpyVQID3Ik2LZKBuchqmUXgrPIYSqc2kNyWtzN2xbQXUQDIGUdgjrlvUtJ5Yx7gX//vzW7ywyeEcOHfIVX0nu4xF33IyWgPLUrTMzWg2f4tylBuW8QJ67nGGN+LGr0NbfKAkFSA3mRCAkW6G2Wehdd2xUUueIfYCzfDnsgydOlFbXwc7WXYYS5AMU18ERKbmyzobCYjIc7gyelQLsE9vpCI3t+OWquVZgCkGW0XfMDiYfRuthYStH3XvI3LTH/wL0WinZvry9Df/VPE2oB6f1YBOgNhbb5d5+P1zznsnBhdNC7eLLPa7DvHxcYrQCdc+zms10xMWAV2wRaJ74AVRi5dqqoOYLztpTB0IVLh9zHRvLxm/z62bsKYCoWnYSSUsEmKos6hIageVjdFKW7zIR5RSSjGB2ZW9R7hvMt+pWKGyNo/w67JewtrlKuy3Xq2BBcqA0PtLL9Ku9bQVR/RP8mjzxTcPCVaJRFhJNq8iJKoiRoIFco1aX0K806UoRpFt5Rz++E+8kiuPu9ffIPyA7HJ6sAdWFPJ6/cO7Cg6TtviJ2ajy4SrP/Pg63ttgg==
X-MS-Exchange-CrossTenant-Network-Message-Id: 303e8a8a-fb3b-4065-d8ce-08d7eb3a03d3
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2020 06:04:30.3988
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2qSzazgUkOOkqPDYNWuZCo3FNXpgswx/IFm6+DuH6ra4ue55I+J5stOGIkU4U3N3
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3477
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-28_02:2020-04-27,2020-04-28 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0 bulkscore=0
 malwarescore=0 lowpriorityscore=0 spamscore=0 mlxscore=0
 priorityscore=1501 impostorscore=0 mlxlogscore=999 clxscore=1015
 suspectscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2003020000 definitions=main-2004280051
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/27/20 4:44 PM, Song Liu wrote:
> Add test for  BPF_ENABLE_STATS, which should enable run_time_ns stats.
> 
> ~/selftests/bpf# ./test_progs -t enable_stats  -v
> test_enable_stats:PASS:skel_open_and_load 0 nsec
> test_enable_stats:PASS:get_stats_fd 0 nsec
> test_enable_stats:PASS:attach_raw_tp 0 nsec
> test_enable_stats:PASS:get_prog_info 0 nsec
> test_enable_stats:PASS:check_stats_enabled 0 nsec
> Summary: 1/0 PASSED, 0 SKIPPED, 0 FAILED
> 
> Signed-off-by: Song Liu <songliubraving@fb.com>
> ---
>   .../selftests/bpf/prog_tests/enable_stats.c   | 45 +++++++++++++++++++
>   .../selftests/bpf/progs/test_enable_stats.c   | 28 ++++++++++++
>   2 files changed, 73 insertions(+)
>   create mode 100644 tools/testing/selftests/bpf/prog_tests/enable_stats.c
>   create mode 100644 tools/testing/selftests/bpf/progs/test_enable_stats.c
> 
> diff --git a/tools/testing/selftests/bpf/prog_tests/enable_stats.c b/tools/testing/selftests/bpf/prog_tests/enable_stats.c
> new file mode 100644
> index 000000000000..987fc743ab75
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/prog_tests/enable_stats.c
> @@ -0,0 +1,45 @@
> +// SPDX-License-Identifier: GPL-2.0
> +#include <test_progs.h>
> +#include <sys/mman.h>
> +#include "test_enable_stats.skel.h"
> +
> +void test_enable_stats(void)
> +{
> +	struct test_enable_stats *skel;
> +	struct bpf_prog_info info = {};
> +	__u32 info_len = sizeof(info);
> +	int stats_fd, err, prog_fd;
> +	int duration = 0;
> +
> +	skel = test_enable_stats__open_and_load();
> +
> +	if (CHECK(!skel, "skel_open_and_load", "skeleton open/load failed\n"))
> +		return;
> +
> +	stats_fd = bpf_enable_stats(BPF_STATS_RUNTIME_CNT);
> +
> +	if (CHECK(stats_fd < 0, "get_stats_fd", "failed %d\n", errno))
> +		goto cleanup;
> +
> +	err = test_enable_stats__attach(skel);
> +
> +	if (CHECK(err, "attach_raw_tp", "err %d\n", err))
> +		goto cleanup;
> +
> +	usleep(1000);
> +
> +	prog_fd = bpf_program__fd(skel->progs.test_enable_stats);
> +	err = bpf_obj_get_info_by_fd(prog_fd, &info, &info_len);
> +
> +	if (CHECK(err, "get_prog_info",
> +		  "failed to get bpf_prog_info for fd %d\n", prog_fd))
> +		goto cleanup;
> +
> +	CHECK(info.run_time_ns == 0, "check_stats_enabled",
> +	      "failed to enable run_time_ns stats\n");
> +
> +cleanup:
> +	test_enable_stats__destroy(skel);
> +	if (stats_fd >= 0)
> +		close(stats_fd);
> +}
> diff --git a/tools/testing/selftests/bpf/progs/test_enable_stats.c b/tools/testing/selftests/bpf/progs/test_enable_stats.c
> new file mode 100644
> index 000000000000..f95ac0c94639
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/progs/test_enable_stats.c
> @@ -0,0 +1,28 @@
> +// SPDX-License-Identifier: GPL-2.0
> +// Copyright (c) 2020 Facebook
> +
> +#include <linux/bpf.h>
> +#include <stdint.h>
> +#include <bpf/bpf_helpers.h>
> +
> +char _license[] SEC("license") = "GPL";
> +
> +struct {
> +	__uint(type, BPF_MAP_TYPE_ARRAY);
> +	__uint(max_entries, 1);
> +	__type(key, __u32);
> +	__type(value, __u64);
> +} count SEC(".maps");

Looks like a global variable can be used here?

> +
> +SEC("raw_tracepoint/sys_enter")
> +int test_enable_stats(void *ctx)
> +{
> +	__u32 key = 0;
> +	__u64 *val;
> +
> +	val = bpf_map_lookup_elem(&count, &key);
> +	if (val)
> +		*val += 1;
> +
> +	return 0;
> +}
> 

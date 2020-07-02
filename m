Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA49C211B86
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 07:24:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726241AbgGBFYL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 01:24:11 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:56078 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725872AbgGBFYK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jul 2020 01:24:10 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0625LqEj027363;
        Wed, 1 Jul 2020 22:23:57 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=D9XAoR3FLlcRcfT652zn8EE9W6b9dzIDEDa9JISFrpc=;
 b=UV2H8bsrDDK/tJ5jv/ysVZ8p5MLPrC6hMALwzMuq34nE9W/OMQ6KqokkWTqxnk8fPOlO
 SgOf5VIzS6+qPUQ4TvLOFNhkw5uw7TkCj8PfAFgWWITZnNiwrGQVY/NdXzYc2W5GOcd7
 5IWwlzSb41cbqooeXbWQ3jfsd3RKsbOyScA= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 31xny2k1rv-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 01 Jul 2020 22:23:57 -0700
Received: from NAM04-CO1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 1 Jul 2020 22:23:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VdOEETubTqLPJLKW6SH2IA+hyiNdTQMYzUZYFfLg05Dsq2o7LjztsS71PvyAp2HyEDdx/xvW8eFfRAr7FhXs0eVFBPvdXGozdtOunZM5UTDIgVnIRtRr5mP7CEsOxNp9y+cCeQlYeh+j0PIM592igsFsWyczDLL7NTPTLsMfS1i4TtQgQJ4rNUVlXJrVCipPiEH+46zfxhuuRtnr8uzOoA76a/yh/I2GBrMSauDrK3/M5l+xPpiviAQNu/0pPps7oPyXO7Fy7Z4NwCujbBxMHadcUD+q43uuOfFOlUeC8wUdCotf404ZwsP1F+r8DALzWzG6vtxB0aQRNUkphH1TiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D9XAoR3FLlcRcfT652zn8EE9W6b9dzIDEDa9JISFrpc=;
 b=cH4t8Qp5+vc8tktzZqgvJ7Zy25dWIiHqCn1oOULUSEZ8/js6zgyNmFOkIA7GiAyMvddQR3d++NRVYBK/Qcn0qkBtVpX7L2/v7l5GV4HaJXks7Z8p9KBGJCuN4IdYueW7f3dTa2/4kgwbGCMwVDyFnVeSZ5Kcy5U8nZGo7yNAa06/wM1wMe9c3FBTe64vNcXluznTny0phBJWR249wdQA4dBbPueJC1jjJXz/ORcwvCl3gb7sXIFSsKudUTW5lNj5GcXVElBOtqaCVxD0m+N9tjp1CgStfwgtiExGQWAqSHbkiMd/IjDT5CIdl8LkY5b/26IkDND8lBbMTQ3yPOutRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D9XAoR3FLlcRcfT652zn8EE9W6b9dzIDEDa9JISFrpc=;
 b=Wny/2C5TI/3o5VTs5ccJYU4BWvmQqkP/X9mj8uQZtFhJ5HPRmKEUPlH7WZWPgmGvqYKi8G4WU5X2qrcQndGTbM/Zx/4N3tqkzCICWM478hPM9Of3dDk6yY5PcYcRSb1xTyNGe6uDrr25hzmlktuzsj1IP27wSoE5zvaiuaBNtmA=
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB2407.namprd15.prod.outlook.com (2603:10b6:a02:8d::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.24; Thu, 2 Jul
 2020 05:23:53 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::4922:9927:5d6c:5301]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::4922:9927:5d6c:5301%7]) with mapi id 15.20.3131.027; Thu, 2 Jul 2020
 05:23:53 +0000
Subject: Re: [PATCH bpf-next] bpf: Add bpf_prog iterator
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        <davem@davemloft.net>
CC:     <daniel@iogearbox.net>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <kernel-team@fb.com>
References: <20200702014001.37945-1-alexei.starovoitov@gmail.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <e348c97b-bd8c-c24f-9287-f1c5341ddd4d@fb.com>
Date:   Wed, 1 Jul 2020 22:23:51 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.9.0
In-Reply-To: <20200702014001.37945-1-alexei.starovoitov@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR02CA0041.namprd02.prod.outlook.com
 (2603:10b6:a03:54::18) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21e8::12c7] (2620:10d:c090:400::5:6a0e) by BYAPR02CA0041.namprd02.prod.outlook.com (2603:10b6:a03:54::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.20 via Frontend Transport; Thu, 2 Jul 2020 05:23:53 +0000
X-Originating-IP: [2620:10d:c090:400::5:6a0e]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2c4a5c93-6440-4335-d2f8-08d81e481c56
X-MS-TrafficTypeDiagnostic: BYAPR15MB2407:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB2407F8F2D9193704A817EA68D36D0@BYAPR15MB2407.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:1417;
X-Forefront-PRVS: 0452022BE1
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NGYpydQH6KkfE6jZ+/a+io4ww4199+kMNePaC7AhZOBB8cQMqJVPSN1cWa4pRkdxMVBzKVBif07IDqz+m68GTPFj/pdQa+QTaDJLsUnpLMTJWvLAkEH6sOR3oSVDFXF+7lqfRAC8wPfYQE582AYShvtfrB95gimZxv9gZYX7hvtlolN21p+oC/7TiGb7zCoy8fY5mFuSvB5l4btVkKs2d7hwg92bh2UMfyob+wgm8mcSTFrJv49KZwUZnTxU74LnXM4nJSzq/xXqtMNaEylVW7oZZmKYm5IxOcXXx3x0jSdr5FDySTomHxshj7pHO9Lpcdr2ASzE/Oevq3LXsI1OHlzMYWfmIp/RzzB0j5Vhkl0HkdqIMrtRua/uTDyBhkcS
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(366004)(136003)(346002)(39860400002)(396003)(376002)(66556008)(478600001)(316002)(2616005)(66476007)(53546011)(6486002)(83380400001)(66946007)(31696002)(86362001)(52116002)(36756003)(4326008)(2906002)(8936002)(8676002)(16526019)(31686004)(5660300002)(186003)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: ZWMHwucdaxMTiVvQeB902x72m5OrQeZEM9bnuBDvmfovtncKy3Pdl7G9uW8PhDBh6FKvHOeUDDUMmWhO8kZ/1fCqH0wSjRyKyeLE3KccXVKYrMQ/FbJaT2sNvgSHgBeX1lKlJ3/6fFDRDJ4IIagUv0p/jFes54gsR+wC2yzT6de7v+xuXK0uttDnUTcTHPWVtsu7lAGZprMZq7eIK9IaEwTK5r+O31GiEAiDc6zybUfdjkqik7+MP75yTSU3BoDMzxIfYvi1sKN4PSYfHOW7+iZF6eheB82B8FY95oJ/WTVw523QzBAAVU4FF2wlYWvzf3sdg7PjFUFh/V+spi1vFWSbwG1D++QWLiw3awn1f6mBpRMvFqJOb5FFY5C7TfGxhineUxdXo20C+oQRRQIISuAlbyWSEQwK5aZeOkQZFnfRKsWFxUj5tkNUgCZDF/jEdT+tzAqrZKpp9YbUBMV+icNQYMAJKAysB5O3wRmWxvSDafDaBHBlkZ+0Nh8WipUk2OQ4SiHSDFp1DypQ2JDeIA==
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c4a5c93-6440-4335-d2f8-08d81e481c56
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jul 2020 05:23:53.6624
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vstOppL1potVic7uSn3959t1eeEAj3yJLZyvZgbSOzzyX/kcocIdGbGA7wNC7kLU
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2407
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-02_02:2020-07-01,2020-07-02 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 cotscore=-2147483648
 mlxscore=0 malwarescore=0 lowpriorityscore=0 priorityscore=1501
 spamscore=0 clxscore=1015 mlxlogscore=999 adultscore=0 suspectscore=0
 bulkscore=0 impostorscore=0 phishscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2007020040
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/1/20 6:40 PM, Alexei Starovoitov wrote:
> From: Alexei Starovoitov <ast@kernel.org>
> 
> It's mostly a copy paste of commit 6086d29def80 ("bpf: Add bpf_map iterator")
> that is use to implement bpf_seq_file opreations to traverse all bpf programs.

Thanks for implementing bpf iter for bpf_progs!

> 
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> ---
> No selftests?!
> They're coming as part of "usermode_driver for iterators" set.
> This patch is trivial and independent, so sending it first.

Okay. Ack only with a few nits.
Acked-by: Yonghong Song <yhs@fb.com>

> 
>   include/linux/bpf.h    |   1 +
>   kernel/bpf/Makefile    |   2 +-
>   kernel/bpf/prog_iter.c | 102 +++++++++++++++++++++++++++++++++++++++++
>   kernel/bpf/syscall.c   |  19 ++++++++
>   4 files changed, 123 insertions(+), 1 deletion(-)
>   create mode 100644 kernel/bpf/prog_iter.c
> 
> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> index 0cd7f6884c5c..3c659f36591d 100644
> --- a/include/linux/bpf.h
> +++ b/include/linux/bpf.h
> @@ -1112,6 +1112,7 @@ int  generic_map_delete_batch(struct bpf_map *map,
>   			      const union bpf_attr *attr,
>   			      union bpf_attr __user *uattr);
>   struct bpf_map *bpf_map_get_curr_or_next(u32 *id);
> +struct bpf_prog *bpf_prog_get_curr_or_next(u32 *id);
>   
>   extern int sysctl_unprivileged_bpf_disabled;
>   
> diff --git a/kernel/bpf/Makefile b/kernel/bpf/Makefile
> index 1131a921e1a6..e6eb9c0402da 100644
> --- a/kernel/bpf/Makefile
> +++ b/kernel/bpf/Makefile
> @@ -2,7 +2,7 @@
>   obj-y := core.o
>   CFLAGS_core.o += $(call cc-disable-warning, override-init)
>   
> -obj-$(CONFIG_BPF_SYSCALL) += syscall.o verifier.o inode.o helpers.o tnum.o bpf_iter.o map_iter.o task_iter.o
> +obj-$(CONFIG_BPF_SYSCALL) += syscall.o verifier.o inode.o helpers.o tnum.o bpf_iter.o map_iter.o task_iter.o prog_iter.o
>   obj-$(CONFIG_BPF_SYSCALL) += hashtab.o arraymap.o percpu_freelist.o bpf_lru_list.o lpm_trie.o map_in_map.o
>   obj-$(CONFIG_BPF_SYSCALL) += local_storage.o queue_stack_maps.o ringbuf.o
>   obj-$(CONFIG_BPF_SYSCALL) += disasm.o
> diff --git a/kernel/bpf/prog_iter.c b/kernel/bpf/prog_iter.c
> new file mode 100644
> index 000000000000..3080abd4d8ad
> --- /dev/null
> +++ b/kernel/bpf/prog_iter.c
> @@ -0,0 +1,102 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/* Copyright (c) 2020 Facebook */
> +#include <linux/bpf.h>
> +#include <linux/fs.h>
> +#include <linux/filter.h>
> +#include <linux/kernel.h>
> +
> +struct bpf_iter_seq_prog_info {
> +	u32 mid;

original field name "mid" is for "map_id".
Here, "pid" is a little bit misleading, maybe "prog_id"?

> +};
> +
> +static void *bpf_prog_seq_start(struct seq_file *seq, loff_t *pos)
> +{
> +	struct bpf_iter_seq_prog_info *info = seq->private;
> +	struct bpf_prog *prog;
> +
> +	prog = bpf_prog_get_curr_or_next(&info->mid);
> +	if (!prog)
> +		return NULL;
> +
> +	++*pos;
> +	return prog;
> +}
> +
> +static void *bpf_prog_seq_next(struct seq_file *seq, void *v, loff_t *pos)
> +{
> +	struct bpf_iter_seq_prog_info *info = seq->private;
> +	struct bpf_prog *prog;
> +
> +	++*pos;
> +	++info->mid;
> +	bpf_prog_put((struct bpf_prog *)v);
> +	prog = bpf_prog_get_curr_or_next(&info->mid);
> +	if (!prog)
> +		return NULL;
> +
> +	return prog;

You can just do "return bpf_prog_get_curr_or_next(&info->prog_id);"
"struct bpf_prog *prog" is not needed any more.

bpf_map_seq_next() has the same inefficiency. I think after a few 
revisions I lost the sight.

> +}
> +
> +struct bpf_iter__bpf_prog {
> +	__bpf_md_ptr(struct bpf_iter_meta *, meta);
> +	__bpf_md_ptr(struct bpf_prog *, prog);
> +};
> +
> +DEFINE_BPF_ITER_FUNC(bpf_prog, struct bpf_iter_meta *meta, struct bpf_prog *prog)
> +
> +static int __bpf_prog_seq_show(struct seq_file *seq, void *v, bool in_stop)
> +{
> +	struct bpf_iter__bpf_prog ctx;
> +	struct bpf_iter_meta meta;
> +	struct bpf_prog *prog;
> +	int ret = 0;
> +
> +	ctx.meta = &meta;
> +	ctx.prog = v;
> +	meta.seq = seq;
> +	prog = bpf_iter_get_info(&meta, in_stop);
> +	if (prog)
> +		ret = bpf_iter_run_prog(prog, &ctx);
> +
> +	return ret;
> +}
> +
[...]

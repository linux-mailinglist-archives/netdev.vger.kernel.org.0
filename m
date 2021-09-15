Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4604A40CE77
	for <lists+netdev@lfdr.de>; Wed, 15 Sep 2021 22:59:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232196AbhIOVA0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Sep 2021 17:00:26 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:59712 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S231689AbhIOVAY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Sep 2021 17:00:24 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.1.2/8.16.0.43) with SMTP id 18FKpfWY007038;
        Wed, 15 Sep 2021 13:58:42 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type :
 content-transfer-encoding : in-reply-to : mime-version; s=facebook;
 bh=2evzz/YqKbRW3fnNZGjWRmkgu26j85AGKmxy5pY7OIQ=;
 b=hQ9pnbtHmK5iTe0RVKF+JmBJndaLoF2mT1TlmzXlEnDpzgJ2QORweGccNccbwgvdbR3M
 /WtbWR0BcnKCZhlsaDNB9+8tEX19XyLAAYPni6NkBtWnsWqxAi2lyEEdI//7xSUc15q8
 bpywEiZSMdTn3insoQkETNfRBPCeg7KmKhc= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net with ESMTP id 3b3jkaatk5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 15 Sep 2021 13:58:42 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.14; Wed, 15 Sep 2021 13:58:41 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J/dapN27pBtozz7Mc+7gvDPG9c4PXctt3q1fRTpzdlfCDABwDRESaCt0KgX+EVzKTR/6qvXF7AjO6nJv03yjFuAqv1Hs0899BMNjXWauLM59zO1S0fmoScR+/+wSz7VnLCVBrzBRGNmeX//05BJzw2irn1P1yKcPJ4Kwa7b/CN+wlxsv8IGUoEFWtXTQf4I8JEXnZSna6roCZR0fCphe0CQGyelcRJ7a7C3ncjUR2fFCG6bvwbD3NpyQvfClC64MC7wTbndBkUlp1TcXxv933WjBfw0N01Y1126rhiJNa8lJr9rC4F8p5Vs+PcNVcIzgWAoPFY0tvyzJyAdONz+6Lw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=2evzz/YqKbRW3fnNZGjWRmkgu26j85AGKmxy5pY7OIQ=;
 b=RbqsYf1snaIjOXWyK2IYm2j2lLIARwbvlVrplfLvfEYjowMwIXKKSCXZRwdNS3zWZALAmK/nqYD8X5QznsDTpWRIHoQoUSgJtweUWrfCj08S4p+uZeel+zqXfdFtmQXL/+KDfczA7psaZrFXVo23o024ZLFae4bwSFjcRIPtjqwnzugORDqP6bj/kPyToEwaBI618YqUb8pZEkrFu3HkKbf+HBM4ydIOAlCvA3IRLZnwC8oyOqh8mxfE4pWA9PjNz/wBMf2ewNHtI93Ps22S6GpO1zd8fHRllXzyT1xTQSZYjv9DVfuCuoYmR64w/kTLhveFlx7yDkPOy2xnhMgxdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=none action=none header.from=fb.com;
Received: from SA1PR15MB5016.namprd15.prod.outlook.com (2603:10b6:806:1db::19)
 by SA1PR15MB4322.namprd15.prod.outlook.com (2603:10b6:806:1ad::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14; Wed, 15 Sep
 2021 20:58:40 +0000
Received: from SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::3c1b:1a10:9708:7e36]) by SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::3c1b:1a10:9708:7e36%8]) with mapi id 15.20.4500.019; Wed, 15 Sep 2021
 20:58:40 +0000
Date:   Wed, 15 Sep 2021 13:58:37 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Hou Tao <houtao1@huawei.com>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>
Subject: Re: [RFC PATCH bpf-next 1/3] bpf: add dummy BPF STRUCT_OPS for test
 purpose
Message-ID: <20210915205837.3v77ajauw4nnhnc2@kafai-mbp.dhcp.thefacebook.com>
References: <20210915033753.1201597-1-houtao1@huawei.com>
 <20210915033753.1201597-2-houtao1@huawei.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210915033753.1201597-2-houtao1@huawei.com>
X-ClientProxiedBy: SJ0PR03CA0030.namprd03.prod.outlook.com
 (2603:10b6:a03:33a::35) To SA1PR15MB5016.namprd15.prod.outlook.com
 (2603:10b6:806:1db::19)
MIME-Version: 1.0
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:120b) by SJ0PR03CA0030.namprd03.prod.outlook.com (2603:10b6:a03:33a::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14 via Frontend Transport; Wed, 15 Sep 2021 20:58:39 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9c9dc8d1-6685-4b28-970c-08d9788b987b
X-MS-TrafficTypeDiagnostic: SA1PR15MB4322:
X-Microsoft-Antispam-PRVS: <SA1PR15MB43221B5C89C4571F97F8D3BCD5DB9@SA1PR15MB4322.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6QksL2UruWtkdM/bdp/d/WrKpO7xQj/PspVdQsPm7vpUCRSr03Z4ETKldDkdKPhzGbVFG7ljKuIPiYg5DJ0dmHEt5P9YzMxA5TEzGP66hjZuFdDI/a4reKHUWlfYPl2Na9H7wJOxhhdcipduwVQYiwAk3sVSDPFhwOiiBzInzxr3KHyUTavk02EiludrePyD+irICYCqdDKPBTSadJYPKGxd5uU53mlK/KJkV1RXHL643F/cEPMxwSTPwJ/qEnZkcQseu3LJnD6/JKm5EzOVLTti0v+CzGHoVOHUJGu+VpOnciWUtX58ph5NIxzvJ9JLhj8Kj23bbz1PKNBgWWibTsi7gDPtrpWwaVwOz4oVDBqZvVxpQM1acIpl8mi/0h+kBO5Ew9qy/a9hdqL50O5UrRTbF68YuKRLZFen3tKyfsc1iPu2hLaKFO99tZ2n545E8zS8v1CgXvyl1oVXnd4kshJq+aUI7UFk1xS7UeJgzmr8OoYYLG4Ir5h7OM3tG6pVk9bQRHHX/eY1ApBFLSGbHkNG4DAB+h05FHYqxwjw/k8WMZk8roTpGm4fWPTAE5+YZEE0f7S1lfUDui3atZ0lUi24TnHN9/yBx1OBhs7boBzfB/7b/fBt9dhm6zPxsXQycN/KMfkc8K/rp8CYHLC60A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5016.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(396003)(39860400002)(346002)(136003)(366004)(6916009)(38100700002)(66556008)(66476007)(8676002)(55016002)(86362001)(66946007)(83380400001)(54906003)(7696005)(52116002)(316002)(9686003)(478600001)(1076003)(4326008)(2906002)(5660300002)(186003)(8936002)(6506007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QTRrSXhYUXMwZ2dDS0VLNTgreDBlclJjbjlBQzdZdTlVdU9udDdmckpsc0Zj?=
 =?utf-8?B?eDBIekdDWWFOVE5IU1N1TEdiaXFQeWpRUE9abGtnRlpzZk8wclR2d3RkbGJ2?=
 =?utf-8?B?MnFPTGJ5YXRTVFBnQU1STVFCVzJGcDkxMnZHZERsZjdZdCtib0ptQXYrd3ZC?=
 =?utf-8?B?QU15UmUrak9tbXhRd3dDVDhtckZKV1J6R0NXWjEvbnlaVDRib0JhNHRZTEZB?=
 =?utf-8?B?VzFua0VDUGxOOHBjZlBoVTkwQVI2MmxaekdCbWYwbXBycVh4VjJIQXNsQVBs?=
 =?utf-8?B?QmhKSWw5bTRyRDdKZm5aaG5MTEpyWVJrUUN1dEpmZE9KcHIvM2dIaG5yQVBr?=
 =?utf-8?B?TnZXSXIzYXlkOUF4OUlhUGd5eUJsWWhOaHBuZjhpY2poREZvTnM5MTc0VTZm?=
 =?utf-8?B?K3pISFpyK3hpM0RzcEYrWnBobUUxUFYrVDU4R1crUVpERVprREdXSENFR3Qw?=
 =?utf-8?B?V01jSUhpd0xudno5WDNWTUtOZDN4NzNkVVhVekcvN2JuWUxXNWd3Zng4a2tK?=
 =?utf-8?B?eS8wVkxwK0tZcWd6Q0dBQWwwKytkRmNySytxWFMyV2x6VXBKT0RuTlBlVTVx?=
 =?utf-8?B?QkxXTVJ0eVR4S2MyZXZJbzcxYk82NnFPUU5GS0sycG5SVjlpZVBqOWhuQkdU?=
 =?utf-8?B?RXhQOFJpZFc3ZnVKbGNGK0FTZ2dCUStOakhEZ2s0Y3VpbVh3eUV4N1RwSG83?=
 =?utf-8?B?NSt1QmxJcGJLRTVwTXhMVFJqNHZLVXdxQTVibG50UmZBNTc4V1MycjR5bEJW?=
 =?utf-8?B?MXV4UFVnUi9GUStKbkJMTmxMcGFzNm9HQUJHUXJXZXgrL2lMRFNtZlFaZnRp?=
 =?utf-8?B?MnRrc1lNWjQvaitUQ1BFV29Tc0I4ajNZaGwzYVdsay9MaElpL1lFazlyaXZZ?=
 =?utf-8?B?RDNDNmMvM1kyc1RlaEp6Q2I1YXhaN0ozUU00Y2RxbFROWWpBQy8xdlUyczYr?=
 =?utf-8?B?aC9qNmQxOXlJVTNlY3BodXowb0tqeEhWWnZzL1c1T3NzL2lOS0hpVm9ibHlv?=
 =?utf-8?B?TEx0Y010WVpxNTA3Y0VrdGRyVHFkVTQ4RnpnYnN6Zm1wUitsV2RpUk51NEpP?=
 =?utf-8?B?V1VDRzI2RU8vL1hxSldEeWpWYWJqVjIrajR5c2NvcFRDRnNiMVRPRjRadGFS?=
 =?utf-8?B?NUVhazM4T0ptK20wV3VLNXBvNHRLOTdkRnhxa1RJZndKb1Y4ZGNDRzJmSEJV?=
 =?utf-8?B?MTRaNEttU3VUUDZQQ21rT09DT2x1SnAvTkczc2d1R0xLTzNCMUZkTUF5eFZT?=
 =?utf-8?B?WUdTbUlaVXdGY2djTHFsb0srMURYWVUvUVJOcWRpMkNqOGZrUHJGN1hZeTdF?=
 =?utf-8?B?aUZsVXg3WWM0TVlHLzFrNUVZVlUyMzdQTDhlL1hkbGlyOVJGalcwVHRtUDgz?=
 =?utf-8?B?OGEvTGhiY3JESFh1MDMvb2p0MllKc1BhT1lhOElRdllzc0VDb1hVaDdaWnJn?=
 =?utf-8?B?Q2ppdTdub3ZBQ3JOblVXRUp6YWI3MjBjTkRFaUZLOEhMRHFGc2hMeHc3blM2?=
 =?utf-8?B?d3YzdHg4eDRlQmdmMFNZR1YyQWhzS1hWd2ZmemhQNkRiMGlFU210KzVzbnRQ?=
 =?utf-8?B?SXJNWEMrM2Q5V1k1NncvMkZNenRBN0V2UXBDanZMMFFyWGhzN2hPMk1xQTMw?=
 =?utf-8?B?QjZncWpvR2Jua2hjMldTdlBQcHZYMjVnbFJUbFdldFprTm16ZlZLSEJ6TGw2?=
 =?utf-8?B?UE4xaFRhNndveG01bGVXMjUxdEw0NEkyL2pGaXk4Mk9UZ2hlL1ZNcDZSaFVL?=
 =?utf-8?B?UUlsTFo0MzFrN0ZURXdIY2hvMW1MNVpmNHB3RklQY1E5OWhwYXJ0R25VUW9i?=
 =?utf-8?B?bmRnNG1veVRBREJGd3dNdz09?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c9dc8d1-6685-4b28-970c-08d9788b987b
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5016.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2021 20:58:40.5501
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: N8FmCkjHH5NfUN6J+Kfzu7DsoCrQ0kzLyTmdFP4r4cAHjJUfNHiOgzy3Km6fnrgK
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB4322
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: Au3z4nU60rTHMt7YNx07eGkLQfzZzFvv
X-Proofpoint-ORIG-GUID: Au3z4nU60rTHMt7YNx07eGkLQfzZzFvv
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-15_06,2021-09-15_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0 mlxscore=0
 lowpriorityscore=0 suspectscore=0 clxscore=1015 priorityscore=1501
 impostorscore=0 spamscore=0 adultscore=0 malwarescore=0 phishscore=0
 mlxlogscore=974 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109030001 definitions=main-2109150120
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 15, 2021 at 11:37:51AM +0800, Hou Tao wrote:
> Currently the test of BPF STRUCT_OPS depends on the specific bpf
> implementation of tcp_congestion_ops, and it can not cover all
> basic functionalities (e.g, return value handling), so introduce
> a dummy BPF STRUCT_OPS for test purpose.
> 
> Dummy BPF STRUCT_OPS may not being needed for release kernel, so
> adding a kconfig option BPF_DUMMY_STRUCT_OPS to enable it separatedly.
Thanks for the patches !

> diff --git a/include/linux/bpf_dummy_ops.h b/include/linux/bpf_dummy_ops.h
> new file mode 100644
> index 000000000000..b2aad3e6e2fe
> --- /dev/null
> +++ b/include/linux/bpf_dummy_ops.h
> @@ -0,0 +1,28 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * Copyright (C) 2021. Huawei Technologies Co., Ltd
> + */
> +#ifndef _BPF_DUMMY_OPS_H
> +#define _BPF_DUMMY_OPS_H
> +
> +#ifdef CONFIG_BPF_DUMMY_STRUCT_OPS
> +#include <linux/module.h>
> +
> +struct bpf_dummy_ops_state {
> +	int val;
> +};
> +
> +struct bpf_dummy_ops {
> +	int (*init)(struct bpf_dummy_ops_state *state);
> +	struct module *owner;
> +};
> +
> +extern struct bpf_dummy_ops *bpf_get_dummy_ops(void);
> +extern void bpf_put_dummy_ops(struct bpf_dummy_ops *ops);
> +#else
> +struct bpf_dummy_ops {}；
This ';' looks different ;)

It probably has dodged the compiler due to the kconfig.
I think CONFIG_BPF_DUMMY_STRUCT_OPS and the bpf_(get|put)_dummy_ops
are not needed.  More on this later.

> diff --git a/kernel/bpf/bpf_dummy_struct_ops.c b/kernel/bpf/bpf_dummy_struct_ops.c
> new file mode 100644
> index 000000000000..f76c4a3733f0
> --- /dev/null
> +++ b/kernel/bpf/bpf_dummy_struct_ops.c
> @@ -0,0 +1,173 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (C) 2021. Huawei Technologies Co., Ltd
> + */
> +#include <linux/kernel.h>
> +#include <linux/spinlock.h>
> +#include <linux/bpf_verifier.h>
> +#include <linux/bpf.h>
> +#include <linux/btf.h>
> +#include <linux/bpf_dummy_ops.h>
> +
> +static struct bpf_dummy_ops *bpf_dummy_ops_singletion;
> +static DEFINE_SPINLOCK(bpf_dummy_ops_lock);
> +
> +static const struct btf_type *dummy_ops_state;
> +
> +struct bpf_dummy_ops *bpf_get_dummy_ops(void)
> +{
> +	struct bpf_dummy_ops *ops;
> +
> +	spin_lock(&bpf_dummy_ops_lock);
> +	ops = bpf_dummy_ops_singletion;
> +	if (ops && !bpf_try_module_get(ops, ops->owner))
> +		ops = NULL;
> +	spin_unlock(&bpf_dummy_ops_lock);
> +
> +	return ops ? ops : ERR_PTR(-ENXIO);
> +}
> +EXPORT_SYMBOL_GPL(bpf_get_dummy_ops);
> +
> +void bpf_put_dummy_ops(struct bpf_dummy_ops *ops)
> +{
> +	bpf_module_put(ops, ops->owner);
> +}
> +EXPORT_SYMBOL_GPL(bpf_put_dummy_ops);

[ ... ]

> +static int bpf_dummy_reg(void *kdata)
> +{
> +	struct bpf_dummy_ops *ops = kdata;
> +	int err = 0;
> +
> +	spin_lock(&bpf_dummy_ops_lock);
> +	if (!bpf_dummy_ops_singletion)
> +		bpf_dummy_ops_singletion = ops;
> +	else
> +		err = -EEXIST;
> +	spin_unlock(&bpf_dummy_ops_lock);
> +
> +	return err;
> +}
I don't think we are interested in testing register/unregister
a struct_ops.  This common infra logic should have already
been covered by bpf_tcp_ca.   Lets see if it can be avoided
such that the above singleton instance and EXPORT_SYMBOL_GPL
can also be removed.

It can reuse the bpf_prog_test_run() which can run a particular
bpf prog.  Then it allows a flexible way to select which prog
to call instead of creating a file and then triggering individual
prog by writing a name string into this new file.

For bpf_prog_test_run(),  it needs a ".test_run" implementation in
"const struct bpf_prog_ops bpf_struct_ops_prog_ops".
This to-be-implemented  ".test_run" can check the prog->aux->attach_btf_id
to ensure it is the bpf_dummy_ops.  The prog->expected_attach_type can
tell which "func" ptr within the bpf_dummy_ops and then ".test_run" will
know how to call it.  The extra thing for the struct_ops's ".test_run" is
to first call arch_prepare_bpf_trampoline() to prepare the trampoline
before calling into the bpf prog.

You can take a look at the other ".test_run" implementations,
e.g. bpf_prog_test_run_skb() and bpf_prog_test_run_tracing().

test_skb_pkt_end.c and fentry_test.c (likely others also) can be
used as reference for prog_tests/ purpose.  For the dummy_ops test in
prog_tests/, it does not need to call bpf_map__attach_struct_ops() since
there is no need to reg().  Instead, directly bpf_prog_test_run() to
exercise each prog in bpf_dummy_ops.skel.h.

bpf_dummy_init_member() should return -ENOTSUPP.
bpf_dummy_reg() and bpf_dummy_unreg() should then be never called.

bpf_dummy_struct_ops.c should be moved into net/bpf/.
No need to have CONFIG_BPF_DUMMY_STRUCT_OPS.  In the future, a generic one
could be created for the test_run related codes, if there is a need.

> +
> +static void bpf_dummy_unreg(void *kdata)
> +{
> +	struct bpf_dummy_ops *ops = kdata;
> +
> +	spin_lock(&bpf_dummy_ops_lock);
> +	if (bpf_dummy_ops_singletion == ops)
> +		bpf_dummy_ops_singletion = NULL;
> +	else
> +		WARN_ON(1);
> +	spin_unlock(&bpf_dummy_ops_lock);
> +}
> +
> +extern struct bpf_struct_ops bpf_bpf_dummy_ops;
> +
> +struct bpf_struct_ops bpf_bpf_dummy_ops = {
> +	.verifier_ops = &bpf_dummy_verifier_ops,
> +	.init = bpf_dummy_init,
> +	.init_member = bpf_dummy_init_member,
> +	.check_member = bpf_dummy_check_member,
> +	.reg = bpf_dummy_reg,
> +	.unreg = bpf_dummy_unreg,
> +	.name = "bpf_dummy_ops",
> +};

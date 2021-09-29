Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8853E41CC31
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 20:56:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346387AbhI2S5p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 14:57:45 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:3784 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1346385AbhI2S5n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 14:57:43 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18THjU19011753;
        Wed, 29 Sep 2021 11:55:45 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=p7IRIzt7kxipjQsz/pv8c70SAfx+QZU2CQhjOdrySCk=;
 b=iFOHrXKhamN9Ik/X9HRI1IyQGBf5hNXCwE2+QBQnkn/cdtj6g8lPW3xkGYgjxclciFrC
 EO7uTCwyMmLmrbV+JJYn4bGGfxBFquEifUIugNuKSLAH3wjf+LBrjaT7El4PrHgrlUxA
 zp/4rYNiUSRKGV39flgw7ee+9qp2QXLq+RM= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3bcvtk0h4t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 29 Sep 2021 11:55:45 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.196) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.14; Wed, 29 Sep 2021 11:55:44 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BsfzqL8VGfjSTv9qdWoaR1l+dcIG3kT84bFBozqeKUGYlqz9eQZAATlK1DLa1FKLjJyoQLF86T1nG+btdwes1xwspy5Eir1ZGuLYJIGgNBWCLfo99eRmtyq7HyWlVjuUpeD+93b3+tiKsj6dq8cOmkvt0WkCI75IXBT42sD6641jbULaDfEx/4LKMI+M9Kn/Xtk+iZUQq24briU15/wTPt/0P6NmIBXPAghgXvAvXmwkXamG1Eefol4qXZm54N8VSdE8P/Z3MoVeg84LrIIcIM/38c45Ivgds/+7MjwAk5coxITujHYoP3cntq6Ez1n9vY2XUFU8D00aFpHE1P2kVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=p7IRIzt7kxipjQsz/pv8c70SAfx+QZU2CQhjOdrySCk=;
 b=GWy3oVZqKO3YEnCxRxsH307bzaAEYSDOaOQ/3tD7tPg9tHN0qNiLzUN/6xgxZ6pU+/+3mstktlxqQASvZtoaFnKB5TNi987I7wV3rf9w9bPGjeNCTArlKgzQ2CpkSZOp5wBoeh94I3lTv2eG5xZUiKRwDMPOxeQTheRe+3opFgqbuEnuoDLO2DGzmwkvFYDSCmJGrDlY5yoysZPFrls4z5o1NVss4HcoZceQrTORo0qfXFbuKTgbXl6WxZDknpY3q38fm1cgCYtnuaMCQQwT8IpXnsVc7cRKUeSDVDyuWZe0d6rTj41+JpLxKnXqdItIiKKh9Wd1Am1SXmVgLAw39w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=none action=none header.from=fb.com;
Received: from SA1PR15MB5016.namprd15.prod.outlook.com (2603:10b6:806:1db::19)
 by SA0PR15MB3999.namprd15.prod.outlook.com (2603:10b6:806:83::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.15; Wed, 29 Sep
 2021 18:55:44 +0000
Received: from SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::6c34:bcb:51af:6160]) by SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::6c34:bcb:51af:6160%6]) with mapi id 15.20.4566.015; Wed, 29 Sep 2021
 18:55:44 +0000
Date:   Wed, 29 Sep 2021 11:55:41 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Hou Tao <houtao1@huawei.com>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>
Subject: Re: [PATCH bpf-next 3/5] bpf: do .test_run in dummy BPF STRUCT_OPS
Message-ID: <20210929185541.cb5z2xnngqljkscu@kafai-mbp.dhcp.thefacebook.com>
References: <20210928025228.88673-1-houtao1@huawei.com>
 <20210928025228.88673-4-houtao1@huawei.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210928025228.88673-4-houtao1@huawei.com>
X-ClientProxiedBy: SJ0PR13CA0134.namprd13.prod.outlook.com
 (2603:10b6:a03:2c6::19) To SA1PR15MB5016.namprd15.prod.outlook.com
 (2603:10b6:806:1db::19)
MIME-Version: 1.0
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:d4e0) by SJ0PR13CA0134.namprd13.prod.outlook.com (2603:10b6:a03:2c6::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.7 via Frontend Transport; Wed, 29 Sep 2021 18:55:43 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d4c72897-cbbb-4dcc-8287-08d9837abd95
X-MS-TrafficTypeDiagnostic: SA0PR15MB3999:
X-Microsoft-Antispam-PRVS: <SA0PR15MB3999C741A203B45A433C2C88D5A99@SA0PR15MB3999.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0GtUt2+dp94wRbOcu5PyEthpbpjVO9Nu0ZmvfREs+ItiXXQeisg8V4rF+lWyUbPqGN9evEGouPt+KSG3M+Suy63Jsdr5QIo6VngUCzsgN2JLhvgEhbKmVOE93a4PzLfklprUpbuPMObpogyn0Fs9ezR0rNVCPHLQ90IIJAM/2FcwWTuNFRFR2Glv+B6hi4awEmgip6buASJxc+SzK0HEMGQjT7Z6eoXp1rRlVHB5rtn4Lc26P7N6F86KPTBqprsF6O7cXm9VNHojcIxs2Mq7bSy3UYrDRCaZOGdTIw/rRJL/AN2MCHwuRiMSZpFfjmpUrG8hEhA/0jO2cr/ZHG76uLdnNorAeGzT9SOrH+ka0cHQqT5lcZSdObzT4kaFC4YI8vT6AM+B+zr3g7KKUcuFZs8t7XFuU3CULkweUrX6QLGBI9+CXwYWpj7EkUHiU6y4WFKK4OJuMDX5SHNgq4wgotHiif4e40atq2XilvYytbDWsvH0bLYSgvzJQcmq3hENp8iWd3z1R12nwcsBB3xjWNUS2LXYOEsl5xb9hm4ts/hvwp+IMclMf6e2+9E4nOhRvuWsZz+ElyI/Wp2Mv43Ge/VglwgxwuOLDmLgYHshmCxWMcMjRs2MwjMd2NU+nkgqFSY0bwb/xanyFQkpD2ZiyjUU2jA+vtB0LlEwH/mQlam2ORm4kWLB9cqK/6xRk19AdJmZvr0q7nOhvWLOrQSvLg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5016.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(54906003)(6506007)(2906002)(5660300002)(8936002)(6916009)(8676002)(316002)(83380400001)(4326008)(66476007)(52116002)(66946007)(7696005)(66556008)(186003)(1076003)(508600001)(9686003)(55016002)(38100700002)(86362001)(142923001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?je4kCIGylazGc2lhHmMhQrKYy3+4ZyEhAm542ye3tI/B+4igbb5zuBXCqQ9u?=
 =?us-ascii?Q?avbLOtXqheIIhtOVjpSxoorlYv0HAmNoPlL60e3miKN2gV83h9SMgeRRNWv+?=
 =?us-ascii?Q?+oizRoetZgQIlqoKpDFhBTtYiRh+2lGBQAlxjXk1QVswSk/dea0coVTRCEyf?=
 =?us-ascii?Q?5xLBiNYXlyGF8tqORStGDYCMe/hzdPR2bakj9aLaq7hT5BWuMTWOIEYz3C2q?=
 =?us-ascii?Q?BbbA9iN0U6YKx9p6z1Qo6a3TyCB6rLCqt5S5aHpdMVMwSDzeM8zQmoWInIOB?=
 =?us-ascii?Q?ZH3xSwJoY0MqnpWGtSLBmV8I9TbM5NOzXVay2CJS+DDr4tFBJphbsMmLU+wE?=
 =?us-ascii?Q?S9csK4aBZcDEUPHeunGBtKgF40uUNLcOKz+e8tdZ2/g3I8qgZnsJr7rPr9J9?=
 =?us-ascii?Q?2XmfSZraYlIBQmVvoGlvRyWFA0DmKv1EgOyPG1COUDV9Z3LZ8RBlVWcJENQv?=
 =?us-ascii?Q?rzOGxGVCwePTAVHXA3Aw4IHIpCFbTiZc4Jx/DzKC67Y8X7GI9Ekq77kM1JBy?=
 =?us-ascii?Q?BYdO9L70pElsGiA8jwifn6qCGuh9ckleQVt+ftuhUxHKBk/nBA5j5tmCTKzO?=
 =?us-ascii?Q?sLJh93uOmoXl8XX1Ti8GEys3MYbzjoQbKFm+fq7Fipx+dCGtbOZ9b3xEn1KX?=
 =?us-ascii?Q?iFaWnLdNCriZUse7GRgkS86hTKpPbo0BKTiqoOR1Rr8UnMlLO5AT98nATDFa?=
 =?us-ascii?Q?4SzWKmSoFjjt8q7NiLWYorjcqOwZ4P3gEG8v8xtyTD7dKx5S4+KO1YiG7h7b?=
 =?us-ascii?Q?fSQH1chvcYecoYMgqmjeBcxqRyUqtCi8koLvuBzlHkM1q3l0cKEPb8khgVc5?=
 =?us-ascii?Q?QJdhhR+GkQscpzR3nxY44ngdT8CC6D+T4YAxMHdikAPfr6jym8nnZvj1Y4Qy?=
 =?us-ascii?Q?O5lNQMFfkYsW0RhPQWs+c237aTMe59kA+9hIsssoMODY7gAnetfQfG5uTCxd?=
 =?us-ascii?Q?JBkxngaQypUigSSdcqBg6DolKO7eXLyeQljASLwBkc26Y9p7IRreKYsn/IZY?=
 =?us-ascii?Q?YzLqusdtWV2b0mGT8jf1thNxXwpZsEKsKL21XKMPTCONmsntkThi20mO/Nhj?=
 =?us-ascii?Q?TI5xTilsVYw+BxvWosARYqi6QdoaWFGbKL3OtiQfSP+Zvi2OdnbsEds0ohtR?=
 =?us-ascii?Q?nZlsLqDBpfEoe93CCioWgCROfvUmCIW7N5EnDICS9XYgVaqa/wjN1c4vDokK?=
 =?us-ascii?Q?kotXvFDFC9rOLkTRT1TVvZNVq6eM9YR1ahIFc78ymaglIx2/rCiz7fwFXagF?=
 =?us-ascii?Q?VZdGs0m1kc2oq7WxnoMhu2/Qw++4VyzDyHBsCEXMptnba/Pml65ff+tA2BH0?=
 =?us-ascii?Q?r+qzoeHr06ncGv6N0c9X8jQpESeTSH68GHEqu6nKhB/qYg=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d4c72897-cbbb-4dcc-8287-08d9837abd95
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5016.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2021 18:55:44.0741
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oEpP43kQ37iOk8/T3nx4fobGUftpO+9FAO1RZF4CcKoGSLhaaLZqHu3SnqtqWb0I
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR15MB3999
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: N-gXdJOa6Ydio0AAZ7eEFiG3yuMztUs3
X-Proofpoint-ORIG-GUID: N-gXdJOa6Ydio0AAZ7eEFiG3yuMztUs3
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-29_07,2021-09-29_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0
 priorityscore=1501 lowpriorityscore=0 phishscore=0 mlxlogscore=999
 malwarescore=0 suspectscore=0 impostorscore=0 adultscore=0 bulkscore=0
 clxscore=1015 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2109290110
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 28, 2021 at 10:52:26AM +0800, Hou Tao wrote:
> Now only program for bpf_dummy_ops::init() is supported. The following
> two cases are exercised in bpf_dummy_st_ops_test_run():
> 
> (1) test and check the value returned from state arg in init(state)
> The content of state is copied from data_in before calling init() and
> copied back to data_out after calling, so test program could use
> data_in to pass the input state and use data_out to get the
> output state.
> 
> (2) test and check the return value of init(NULL)
> data_in_size is set as 0, so the state will be NULL and there will be
> no copy-in & copy-out.

Patch 1 and patch 3 in this set should be combined.

>  include/linux/bpf_dummy_ops.h  |  13 ++-
>  net/bpf/bpf_dummy_struct_ops.c | 176 +++++++++++++++++++++++++++++++++
>  2 files changed, 188 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/bpf_dummy_ops.h b/include/linux/bpf_dummy_ops.h
> index a594ae830eba..5049484e6693 100644
> --- a/include/linux/bpf_dummy_ops.h
> +++ b/include/linux/bpf_dummy_ops.h
The changes here seem not worth a new header file.
Let see if they can be simplified and move the only needed things to bpf.h.

> @@ -5,10 +5,21 @@
>  #ifndef _BPF_DUMMY_OPS_H
>  #define _BPF_DUMMY_OPS_H
>  
> -typedef int (*bpf_dummy_ops_init_t)(void);
> +#include <linux/bpf.h>
> +#include <linux/filter.h>
> +
> +struct bpf_dummy_ops_state {
> +	int val;
> +};
This struct can be moved to net/bpf/bpf_dummy_struct_ops.c.

> +
> +typedef int (*bpf_dummy_ops_init_t)(struct bpf_dummy_ops_state *cb);
If I read it correctly, the typedef is only useful in casting later.
It would need another typedef in the future if new test function is added.
Lets try to remove it (more on this later).

>  
>  struct bpf_dummy_ops {
>  	bpf_dummy_ops_init_t init;
"init" is a little confusing since it is not doing initialization.
It is for testing purpose.  How about renaming it to test1, test2, test3...:

	int (*test1)(struct bpf_dummy_ops_state *cb);

Also, it should at least add another function to test more
arguments which is another limitation of testing with
tcp_congestion_ops.

>  };
The whole struct bpf_dummy_ops can be moved to include/linux/bpf.h also
next to where other bpf_struct_ops_*() functions are residing.

>  
> +extern int bpf_dummy_st_ops_test_run(struct bpf_prog *prog,
> +				     const union bpf_attr *kattr,
> +				     union bpf_attr __user *uattr);
Same here.  It can be moved to include/linux/bpf.h and remove the
"extern" also.

> +
>  #endif
> diff --git a/net/bpf/bpf_dummy_struct_ops.c b/net/bpf/bpf_dummy_struct_ops.c
> index 1249e4bb4ccb..da77736cd093 100644
> --- a/net/bpf/bpf_dummy_struct_ops.c
> +++ b/net/bpf/bpf_dummy_struct_ops.c
> @@ -10,12 +10,188 @@
>  
>  extern struct bpf_struct_ops bpf_bpf_dummy_ops;
>  
> +static const struct btf_type *dummy_ops_state;
> +
> +static struct bpf_dummy_ops_state *
> +init_dummy_ops_state(const union bpf_attr *kattr)
> +{
> +	__u32 size_in;
> +	struct bpf_dummy_ops_state *state;
> +	void __user *data_in;
> +
> +	size_in = kattr->test.data_size_in;
These are the args for the test functions?  Using ctx_in/ctx_size_in
and ctx_out/ctx_size_out instead should be more consistent
with other bpf_prog_test_run* in test_run.c.

> +	if (!size_in)
> +		return NULL;
> +
> +	if (size_in != sizeof(*state))
> +		return ERR_PTR(-EINVAL);
> +
> +	state = kzalloc(sizeof(*state), GFP_KERNEL);
> +	if (!state)
> +		return ERR_PTR(-ENOMEM);
> +
> +	data_in = u64_to_user_ptr(kattr->test.data_in);
> +	if (copy_from_user(state, data_in, size_in)) {
> +		kfree(state);
> +		return ERR_PTR(-EFAULT);
> +	}
> +
> +	return state;
> +}
> +
> +static int copy_dummy_ops_state(struct bpf_dummy_ops_state *state,
> +				const union bpf_attr *kattr,
> +				union bpf_attr __user *uattr)
> +{
> +	int err = 0;
> +	void __user *data_out;
> +
> +	if (!state)
> +		return 0;
> +
> +	data_out = u64_to_user_ptr(kattr->test.data_out);
> +	if (copy_to_user(data_out, state, sizeof(*state))) {
> +		err = -EFAULT;
> +		goto out;
Directly return err;

> +	}
> +	if (put_user(sizeof(*state), &uattr->test.data_size_out)) {
> +		err = -EFAULT;
> +		goto out;
Same here.

> +	}
> +out:
> +	return err;
> +}
> +
> +static inline void exit_dummy_ops_state(struct bpf_dummy_ops_state *state)
static is good enough.  no need to inline.  Allow the compiler to decide.

> +{
> +	kfree(state);
Probably just remove this helper function and directly call kfree instead.

Could you help to check if bpf_ctx_init and bpf_ctx_finish can be directly
reused instead?  I haven't looked at them closely to compare yet.

> +}
> +
> +int bpf_dummy_st_ops_test_run(struct bpf_prog *prog,
> +			      const union bpf_attr *kattr,
> +			      union bpf_attr __user *uattr)
> +{
> +	const struct bpf_struct_ops *st_ops = &bpf_bpf_dummy_ops;
> +	struct bpf_dummy_ops_state *state = NULL;
> +	struct bpf_tramp_progs *tprogs = NULL;
> +	void *image = NULL;
> +	int err;
> +	int prog_ret;
> +
> +	/* Now only support to call init(...) */
> +	if (prog->expected_attach_type != 0) {
> +		err = -EOPNOTSUPP;
> +		goto out;
> +	}
> +
> +	/* state will be NULL when data_size_in == 0 */
> +	state = init_dummy_ops_state(kattr);
> +	if (IS_ERR(state)) {
> +		err = PTR_ERR(state);
> +		state = NULL;
> +		goto out;
> +	}
> +
> +	tprogs = kcalloc(BPF_TRAMP_MAX, sizeof(*tprogs), GFP_KERNEL);
> +	if (!tprogs) {
> +		err = -ENOMEM;
> +		goto out;
> +	}
> +
> +	image = bpf_jit_alloc_exec(PAGE_SIZE);
> +	if (!image) {
> +		err = -ENOMEM;
> +		goto out;
> +	}
> +	set_vm_flush_reset_perms(image);
> +
> +	err = bpf_prepare_st_ops_prog(tprogs, prog, &st_ops->func_models[0],
> +				      image, image + PAGE_SIZE);
> +	if (err < 0)
> +		goto out;
> +
> +	set_memory_ro((long)image, 1);
> +	set_memory_x((long)image, 1);
> +	prog_ret = ((bpf_dummy_ops_init_t)image)(state);
I would do something like this to avoid creating the
bpf_dummy_ops_init_t typedef.

	struct bpf_dummy_ops ops;

	ops.init = (void *)image;
	prog_ret = ops.init(state);

> +
> +	err = copy_dummy_ops_state(state, kattr, uattr);
> +	if (err)
> +		goto out;
> +	if (put_user(prog_ret, &uattr->test.retval))
> +		err = -EFAULT;
> +out:
> +	exit_dummy_ops_state(state);
> +	bpf_jit_free_exec(image);
> +	kfree(tprogs);
> +	return err;
> +}
> +
>  static int bpf_dummy_init(struct btf *btf)
>  {
> +	s32 type_id;
> +
> +	type_id = btf_find_by_name_kind(btf, "bpf_dummy_ops_state",
> +					BTF_KIND_STRUCT);
> +	if (type_id < 0)
> +		return -EINVAL;
> +
> +	dummy_ops_state = btf_type_by_id(btf, type_id);
> +
>  	return 0;
>  }
>  
> +static bool bpf_dummy_ops_is_valid_access(int off, int size,
> +					  enum bpf_access_type type,
> +					  const struct bpf_prog *prog,
> +					  struct bpf_insn_access_aux *info)
> +{
> +	/* init(state) only has one argument */
> +	if (off || type != BPF_READ)
> +		return false;
> +
> +	return btf_ctx_access(off, size, type, prog, info);
> +}
> +
> +static int bpf_dummy_ops_btf_struct_access(struct bpf_verifier_log *log,
> +					   const struct btf *btf,
> +					   const struct btf_type *t, int off,
> +					   int size, enum bpf_access_type atype,
> +					   u32 *next_btf_id)
> +{
> +	size_t end;
> +
> +	if (atype == BPF_READ)
> +		return btf_struct_access(log, btf, t, off, size, atype,
> +					 next_btf_id);
> +
> +	if (t != dummy_ops_state) {
> +		bpf_log(log, "only read is supported\n");
> +		return -EACCES;
> +	}
The idea is to only allow writing to dummy_ops_state?

How about something like this (uncompiled code):

	int ret;

	if (atype != BPF_READ && t != dummy_ops_state)
		return -EACCES;

	ret = btf_struct_access(log, btf, t, off, size, atype,
				next_btf_id);
	if (ret < 0)
		return ret;

	return atype == BPF_READ ? ret : NOT_INIT;

Then the following switch and offset logic can go away.

> +
> +	switch (off) {
> +	case offsetof(struct bpf_dummy_ops_state, val):
> +		end = offsetofend(struct bpf_dummy_ops_state, val);
> +		break;
> +	default:
> +		bpf_log(log, "no write support to bpf_dummy_ops_state at off %d\n",
> +			off);
> +		return -EACCES;
> +	}
> +
> +	if (off + size > end) {
> +		bpf_log(log,
> +			"write access at off %d with size %d beyond the member of bpf_dummy_ops_state ended at %zu\n",
> +			off, size, end);
> +		return -EACCES;
> +	}
> +
> +	return NOT_INIT;
> +}
> +
>  static const struct bpf_verifier_ops bpf_dummy_verifier_ops = {
> +	.is_valid_access = bpf_dummy_ops_is_valid_access,
> +	.btf_struct_access = bpf_dummy_ops_btf_struct_access,
>  };
>  
>  static int bpf_dummy_init_member(const struct btf_type *t,
> -- 
> 2.29.2
> 

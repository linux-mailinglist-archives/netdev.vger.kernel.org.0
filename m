Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 839854342D3
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 03:23:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229756AbhJTBZ1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 21:25:27 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:49318 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229653AbhJTBZ0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Oct 2021 21:25:26 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19JKfJ42014398;
        Tue, 19 Oct 2021 18:22:52 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=B4vN5Iesja0VFd7pI7nVVPsWB5rqKUUddSBrc33Nl2k=;
 b=P0pt2DKVFi/tErTj9GCympumDpYoPA6FPVQVPd577MJfy1USzCV57swRtE9LG4zFbaen
 h9DolSK+2P6Ef/4gO5TRW/b5BOQOxCdXwO1cEtt1T/gjEEIY4e/JODkF+uENW0wWqT6h
 BLqq2NsL2wDMIUbtZpvPOXo7LtcCtGk6ZAg= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3bt4rdht0y-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 19 Oct 2021 18:22:52 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.14; Tue, 19 Oct 2021 18:22:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kpH0j3VyDUaNdApoDtmyxie12fDA4Gi1Jo4w2kYMjKS+tlhi9XhphqC0KdT/l1q+JtB4irrJ4kWc2kGPCTj8aHXX166ckSEopEF644QvM+wn1Qz4CPhrzIXUnj5YjH35xohBH3qWKrCli8AwiYtFb9JjRYsYLCWpAJMNgCYLmYpTVfNLJXMDx6gr7/U6WEt871Xn0a8ytc99qzrDxp0FcOSw97u69JH/74FCbngMe45NM9YH3JphzWDsFmuO9PhuHTVrg/LqDJbqClALRabYDyUjdIsU6vGMYM9WjhAJeeQ+Pf2zcTqv4g7KkdU83kQmykjeGxIfpWOgBOuUVWBlUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=B4vN5Iesja0VFd7pI7nVVPsWB5rqKUUddSBrc33Nl2k=;
 b=J6v003WfjLKTJ/HH5CToiP7SljjGOlRC3xbDf5ZRgEMGdYVD+eKl6nr5ry+XFCMxfqCF95GSgQZiE170ByW1XVearv8dldxrHSGvfc0J56ZRUXds3gbbgISoUbN+CjQNgtrD/18LiySMiFiHWnlu28LJ2MKCtgMMLXv+BnoS+qvXBmUqAyWNcvsZt56tfoFLI+eA9aBqxM0LgtkJ3sb3y345+MI9dfKU+TWpq+fK+gmv8Qk2DMG/XuO5hzDQK4gDDU5AUc4VX+OSVtA5quvRL3GHG1v1CQ7ItvH8xnsBOA6wOHwhNuvjKul+YO97YOE6IBp8Ez4O3FIr1X8HREJtqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=none action=none header.from=fb.com;
Received: from SA1PR15MB5016.namprd15.prod.outlook.com (2603:10b6:806:1db::19)
 by SA1PR15MB5013.namprd15.prod.outlook.com (2603:10b6:806:1d8::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.17; Wed, 20 Oct
 2021 01:22:28 +0000
Received: from SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::6c34:bcb:51af:6160]) by SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::6c34:bcb:51af:6160%8]) with mapi id 15.20.4608.018; Wed, 20 Oct 2021
 01:22:28 +0000
Date:   Tue, 19 Oct 2021 18:22:24 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Hou Tao <houtao1@huawei.com>
CC:     Alexei Starovoitov <ast@kernel.org>, Yonghong Song <yhs@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>
Subject: Re: [PATCH bpf-next v2 3/5] bpf: add dummy BPF STRUCT_OPS for test
 purpose
Message-ID: <20211020012224.btbxirx4x7wuwkuq@kafai-mbp.dhcp.thefacebook.com>
References: <20211016124806.1547989-1-houtao1@huawei.com>
 <20211016124806.1547989-4-houtao1@huawei.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20211016124806.1547989-4-houtao1@huawei.com>
X-ClientProxiedBy: MWHPR17CA0065.namprd17.prod.outlook.com
 (2603:10b6:300:93::27) To SA1PR15MB5016.namprd15.prod.outlook.com
 (2603:10b6:806:1db::19)
MIME-Version: 1.0
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:1383) by MWHPR17CA0065.namprd17.prod.outlook.com (2603:10b6:300:93::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.15 via Frontend Transport; Wed, 20 Oct 2021 01:22:27 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5769ab9a-6cf4-4662-0831-08d993681493
X-MS-TrafficTypeDiagnostic: SA1PR15MB5013:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA1PR15MB501364788A46A75EF9D470EDD5BE9@SA1PR15MB5013.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UFQOfQNG2RqR91WNm70tl/vC1+1jGsLMZCqrqOxPDwXS8SFFBSoC+fe+Tj044f+0n4ZVvcibKr70f8KbW8HEUd++SAMtIH2ESqte10ieYq1MSqvZ32n6kU82ofNMPCuKRWDgBGyNfFPzITnDG1wHXFVQMU6bf34JDl60pf4YL7qoiOVvcbg90RNryPWYmLLTh5OcoiuFX9Qal+rhEzFQSoyCKnTYMZcbyK+xvOoD5ymGgBn2slSAxrp1HKEAlmv4080Q2GEbIakZrCkPj+xAngSTrWp356sm4tX8kDzMAGM0bd5Ikq2CvuU6bV6Q/my50G7t7vPHmhsf5G+Fwr3Jg1KGjO0I15iZLwcMxSoim1eaglC+/VK7g/qJJ9uO4TBbHFGL3OCJXW1cyXWR4SPFKUEKNbRwq48n3F2+egi2xo2GHXkBKCruYV1eOhnX57v48qrXHSjOaGF+lIajnnSHbKm1FLQ+I2vH05n71HMRetvtftJG5XqiTe15c4WSNlyYzgT6Bk7LhaP9FNGw4ewIcYk7sYtn2Mrm1IWPpfunqp7NhGdj5MZS1I4ZqevUm/KmUisUPY5K6n0uObykH7/HS1CrJ72Fh8WnmmXXo+WOSkvqeUwl+r7Fnt20ge9Ha8sa8H1HPBJ3RkQ5kFrQ6sUmvQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5016.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6916009)(66946007)(316002)(55016002)(8936002)(186003)(508600001)(9686003)(1076003)(5660300002)(6666004)(38100700002)(52116002)(83380400001)(4326008)(54906003)(86362001)(2906002)(66556008)(6506007)(66476007)(8676002)(7696005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6mbHCSXVwyEvlQ4/4MOwtQE5XlH0HWMXNJVh4RmUWx/4cf6sTa7+0pEdLOCq?=
 =?us-ascii?Q?PD5Npbcvevyx+rrFnwVLi1n6KelODKMtctAcNz+VTXRJ7hUvjryRqij/5YZq?=
 =?us-ascii?Q?gUwh2xXainZoTnGylm1KusPegrbHQ/Fq93+a27aW+CJSmpjaCPlFOZbKB/B/?=
 =?us-ascii?Q?g7mCZOcBELA2xM+cC/w/18ujva8yC55gCshgjWAzX+AZY1GQ9JhCamNf28VS?=
 =?us-ascii?Q?DXYtNQaaC6iDbemnXUui65/JNEDqTPI2Hme8SufyU8T+AFQPV/TJemWzzpZk?=
 =?us-ascii?Q?04hlk+ESld9ciS0fBRC3is35VM0IXYrko0AKGjT5kC8r1lNj1gxC12xvxhb3?=
 =?us-ascii?Q?MNsfMoo26Rf4Cy6vsUXbTExOGmqIQc2/26PDSbF7xVRq3uvcPTfLtFUjYhjZ?=
 =?us-ascii?Q?wDKEM4UIRMy3G3M2IO+TdjsO6oKqj7vJelak+1ZOjcUxLMfmLQljVqWXirkE?=
 =?us-ascii?Q?se+JCWO0vcblZXxbdgjSyLhRtDYL1Q2UIMfyeuOagpKodad07vp4OlMNnF7f?=
 =?us-ascii?Q?sY4xlPEF4xoTqofkbOeZxWfLGJMizp9n8SOfOPcyDPMYdKWkGiqfpKQQmkxX?=
 =?us-ascii?Q?tlY5+qknGKO5KqAsHqmktF8p3yI05zwyWzm+ujBSWICgbfTyt+SledY9QeHd?=
 =?us-ascii?Q?5wd/jzOUDdpQoHVAJJa1Q2Sc5VhGde4DDa/Z2RjXWdiXP6OClNBdIrh8uCUr?=
 =?us-ascii?Q?PpL1N3O1aezEHMXL12fNX/CURrn05/VQC0ymwuaC8eDn8zYaB/PRW43pvcNp?=
 =?us-ascii?Q?CAoQApWUotWts4LEHPaOEhNI3TtWcVALclL0Hff7wJnJGtE8H73qy3Pd/M/q?=
 =?us-ascii?Q?FT7s10AIRaDK7du3HepE3RbUpy98MrZMELe6gnvLu3xaKbseWSsxCuzP7wE8?=
 =?us-ascii?Q?GzCQv9OD7aP3EDKsCsyj0jOowHjhW/ybwEJof/Gl7RzHs83Bk3eg/gyBhr9d?=
 =?us-ascii?Q?dad9rQ9+zOOEZc6sSYKSvmP2guhsTZjWIqk6kZKUUodFZqhGnwebEQgO1VaJ?=
 =?us-ascii?Q?muxRFJIfnYfmqhcte0sQf8Vpt1a9bw7jl+OBFTH4F/9b5AABfbken9Rtbpp3?=
 =?us-ascii?Q?XbxD2gGzXtjcVFuJiJt+4IsJBw5e7C4LvAQwNYvj6uq0y18ioCKHyxuRNqyJ?=
 =?us-ascii?Q?Y+pvMQTkLp3VgN+aQEwpIIZxbxENzfuJ08R+sbrro0kFRN8Q5I4cER/U37pc?=
 =?us-ascii?Q?MQyaBf/X0WCAMeODNtnJS2aKkzwAMwzxHPTv7N77MnuSOFptm1h7x7DBN4yf?=
 =?us-ascii?Q?7wy3fogOT1RGM61C+MUUgDU3QZ6lBfEtBHzyBUX2EtD/petMiYFTCXWv+04V?=
 =?us-ascii?Q?isPJQB3zZbsP6qFf6H9DIAAjwP6aI8Z+8rOqKVV6a6kkWw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5769ab9a-6cf4-4662-0831-08d993681493
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5016.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2021 01:22:28.3097
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7UDnYqn1eUbb7jQCe2wvPoCkKv1wktCxgtjzRybBTjAxM1LVWae3cqgG8qSGNIU0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB5013
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: 0EnOtL9yHBpaEsbYyiNQpkXSDxitlxoc
X-Proofpoint-ORIG-GUID: 0EnOtL9yHBpaEsbYyiNQpkXSDxitlxoc
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-19_02,2021-10-19_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0 spamscore=0
 impostorscore=0 mlxscore=0 malwarescore=0 mlxlogscore=875 suspectscore=0
 clxscore=1015 phishscore=0 priorityscore=1501 lowpriorityscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110200004
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 16, 2021 at 08:48:04PM +0800, Hou Tao wrote:
> +static struct bpf_dummy_ops_test_args *
> +dummy_ops_init_args(const union bpf_attr *kattr, unsigned int nr)
> +{
> +	__u32 size_in;
> +	struct bpf_dummy_ops_test_args *args;
> +	void __user *ctx_in;
> +	void __user *u_state;
> +
> +	if (!nr || nr > MAX_BPF_FUNC_ARGS)
> +		return ERR_PTR(-EINVAL);
> +
> +	size_in = kattr->test.ctx_size_in;
> +	if (size_in != sizeof(u64) * nr)
> +		return ERR_PTR(-EINVAL);
> +
> +	args = kzalloc(sizeof(*args), GFP_KERNEL);
> +	if (!args)
> +		return ERR_PTR(-ENOMEM);
> +
> +	ctx_in = u64_to_user_ptr(kattr->test.ctx_in);
> +	if (copy_from_user(args->args, ctx_in, size_in))
args is leaked.

> +		return ERR_PTR(-EFAULT);
> +
> +	u_state = u64_to_user_ptr(args->args[0]);
> +	if (!u_state)
> +		return args;
> +
> +	if (copy_from_user(&args->state, u_state, sizeof(args->state))) {
> +		kfree(args);
> +		return ERR_PTR(-EFAULT);
> +	}
> +
> +	return args;
> +}

[ ... ]

> +int bpf_dummy_struct_ops_test_run(struct bpf_prog *prog,
> +				  const union bpf_attr *kattr,
> +				  union bpf_attr __user *uattr)
> +{
> +	const struct bpf_struct_ops *st_ops = &bpf_bpf_dummy_ops;
> +	const struct btf_type *func_proto = prog->aux->attach_func_proto;
> +	struct bpf_dummy_ops_test_args *args = NULL;
> +	struct bpf_tramp_progs *tprogs = NULL;
args = NULL and tprogs = NULL are not needed.

> +	void *image = NULL;
> +	unsigned int op_idx;
> +	int err;
> +	int prog_ret;
> +
> +	args = dummy_ops_init_args(kattr, btf_type_vlen(func_proto));
> +	if (IS_ERR(args))
> +		return PTR_ERR(args);
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
> +	op_idx = prog->expected_attach_type;
> +	err = bpf_struct_ops_prepare_trampoline(tprogs, prog,
> +						&st_ops->func_models[op_idx],
> +						image, image + PAGE_SIZE);
> +	if (err < 0)
> +		goto out;
> +
> +	set_memory_ro((long)image, 1);
> +	set_memory_x((long)image, 1);
> +	prog_ret = dummy_ops_call_op(image, args);
> +
> +	err = dummy_ops_copy_args(args);
> +	if (err)
> +		goto out;
> +	if (put_user(prog_ret, &uattr->test.retval))
> +		err = -EFAULT;
> +out:
> +	kfree(args);
> +	bpf_jit_free_exec(image);
> +	kfree(tprogs);
> +	return err;
> +}
> +
> +static int bpf_dummy_init(struct btf *btf)
> +{
> +	s32 type_id;
> +
> +	type_id = btf_find_by_name_kind(btf, "bpf_dummy_ops_state",
> +					BTF_KIND_STRUCT);
> +	if (type_id < 0)
> +		return -EINVAL;
> +
> +	dummy_ops_state = btf_type_by_id(btf, type_id);
Probably just do btf_find_by_name_kind("bpf_dummy_ops_state")
in bpf_dummy_ops_btf_struct_access() during each test.   There is
no need to optimize and cache it only for the testing purpose.

> +
> +	return 0;
> +}
> +
> +static bool bpf_dummy_ops_is_valid_access(int off, int size,
> +					  enum bpf_access_type type,
> +					  const struct bpf_prog *prog,
> +					  struct bpf_insn_access_aux *info)
> +{
> +	return bpf_check_btf_func_ctx_access(off, size, type, prog, info);
> +}
> +
> +static int bpf_dummy_ops_btf_struct_access(struct bpf_verifier_log *log,
> +					   const struct btf *btf,
> +					   const struct btf_type *t, int off,
> +					   int size, enum bpf_access_type atype,
> +					   u32 *next_btf_id)
> +{
> +	int err;
> +
> +	if (atype != BPF_READ && t != dummy_ops_state) {
I think this can be further simplified.  The only struct that
the bpf_prog can access is bpf_dummy_ops_state, so the
"atype != BPF_READ" test can be removed.  The log message
then needs to be adjusted.

Others lgtm.

> +		bpf_log(log, "only write to bpf_dummy_ops_state is supported\n");
> +		return -EACCES;
> +	}
> +
> +	err = btf_struct_access(log, btf, t, off, size, atype, next_btf_id);
> +	if (err < 0)
> +		return err;
> +
> +	return atype == BPF_READ ? err : NOT_INIT;
> +}

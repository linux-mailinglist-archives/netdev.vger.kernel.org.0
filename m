Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9765B434471
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 07:01:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229817AbhJTFDp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 01:03:45 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:56862 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229492AbhJTFDo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Oct 2021 01:03:44 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19JNwbU4021356;
        Tue, 19 Oct 2021 22:01:04 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=1hS1BmZLtGNcm5P526nssQnJfht5EaKr/fFc6e5L9t4=;
 b=Skm1oF/b5IYHY+vMV0P5T/yEnFBHnuASAvIx3rDBtLpq7+qRAQSjkroaaARRby4sEYLe
 cn7OOTBH4P5coQI/ORBzJneoWdmB/1R1oa5rRFmaPTzFEaNQ4jvXrkIaukuYQHA89uZm
 FM1x31zfFydxj/JA6rTBNsPwTQk1aQixOmY= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3bt85gha92-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 19 Oct 2021 22:01:04 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.197) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.14; Tue, 19 Oct 2021 22:01:03 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n2p+G4M7yw4TiwUXlL5iQ3bsMA7IL+wrOoVi+6e7Q0yp1A7+PgC1Ry3xzgFnhIxpLdgMBikbhG7+4O6yGyGG08Vl4bzmlG10H3dXN7l2cmzf/QsyIQ4PE8eQXQXX2bq1wzw8TNgEJPG561nHA93eGtLwi6obNYri+lTx29Q5P323ET2dnK9OkjuHCBYIHY/JIRKjdg7tT9V+Yvl2/tAz4qm+GHJDSKMNt+OS/ogSGxRnMMkH5uRBdQ8I+g5zhU+eknFmRwheHPvjEaG/54J4VYRIk+Yrx7lEnu7xSHrDpk0wfgvacIlJgWRYB8vfU7z9DKj2qz9OgmH3QfWFBnizGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1hS1BmZLtGNcm5P526nssQnJfht5EaKr/fFc6e5L9t4=;
 b=mQjnhC5TgiRAMySCP9AWpKWBdfo++pPiG3Rg+k1YvEEMHIZJo3WWqs9xn6yG63cOu6p2JH/FmkLzUSszVIQrCyIUeFlEAkrPy5UQqtr+qvWhjb/nZ1X4OsokdJWDGiDqez5HxXvfp6KLxe9IU2F3N1VondNCqd/pIox72LYgU7PnidEYFew/psH9XTCSNqFhVv2V0gZtcez3cQIYg2I6a4d8dnYqRc/ybghrWbt3kr9dpbjHNkIiFlTyEaTQuoprQixcIadSYRvxBeCrAHxE2wKH1Qf3lq63B+CixgKWoc7Uxdf/eK3M6awf1+Xozqd4ULop/ysrfpvWMRRuGkkx/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=none action=none header.from=fb.com;
Received: from SA1PR15MB5016.namprd15.prod.outlook.com (2603:10b6:806:1db::19)
 by SA1PR15MB4981.namprd15.prod.outlook.com (2603:10b6:806:1d4::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.17; Wed, 20 Oct
 2021 05:01:02 +0000
Received: from SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::6c34:bcb:51af:6160]) by SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::6c34:bcb:51af:6160%8]) with mapi id 15.20.4608.018; Wed, 20 Oct 2021
 05:01:02 +0000
Date:   Tue, 19 Oct 2021 22:00:58 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Hou Tao <houtao1@huawei.com>
CC:     Alexei Starovoitov <ast@kernel.org>, Yonghong Song <yhs@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>
Subject: Re: [PATCH bpf-next v2 2/5] bpf: factor out helpers to check ctx
  access for BTF function
Message-ID: <20211020050058.wpafu63ffwh5zc2x@kafai-mbp.dhcp.thefacebook.com>
References: <20211016124806.1547989-1-houtao1@huawei.com>
 <20211016124806.1547989-3-houtao1@huawei.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20211016124806.1547989-3-houtao1@huawei.com>
X-ClientProxiedBy: MWHPR1201CA0007.namprd12.prod.outlook.com
 (2603:10b6:301:4a::17) To SA1PR15MB5016.namprd15.prod.outlook.com
 (2603:10b6:806:1db::19)
MIME-Version: 1.0
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:aa06) by MWHPR1201CA0007.namprd12.prod.outlook.com (2603:10b6:301:4a::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.15 via Frontend Transport; Wed, 20 Oct 2021 05:01:01 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: eb968efc-9198-442d-df65-08d993869cec
X-MS-TrafficTypeDiagnostic: SA1PR15MB4981:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA1PR15MB49819ABBB6BBCE548E342DB4D5BE9@SA1PR15MB4981.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RyL73GEW62JaxLwXP6jukAQIQJUgQ7bUW+/j8EK+xYA3FSWdnJzfL+03cZZnE2v7ehpqspMbXDVF+F4/SBpupGQHO3l7Ewn5bSBokn3pwIHfBtx0eSJkNlmfQVTOGm7FOyvHoO/oN8AjJhD95ePODytTH/pAr/vJCCfdUdO7yo0HIkelioRNY+UHj7EWKp4bNzab3zCtMtt8KVYBP71SlxIfuzMTPgdohh0T6krQl0EcNwM55+g4QU2DvhXw17+8skvnF3IKZbI8GlgD9O40F3Hyc8Cnr1ZthcmBdwOVATIKB7+z8jWzwNRbim9ltZhGTIm4EeRicYRizegWFxhlKhkY4dnZShqc5W6enGDRHskBr/Trsh+5a9VfhphEjGmY86nFyDMd05YOFc+ln2ckJNK///FpRYu2KdmEv7AU+7GwcpREA4NUkZUUCEigHbRTe9XLCoYUj+Ba5lsjaava5qoVSgOwhG65+iAufnkeSVPn47FEM8Fzrc8lp3fHUo3HsNlsFdX04syxMvgBQR1bPZWCKbnwjgc+DLRgX7RI0BWnGts2pY6GKCWVMZw4qR+nP+facyaeKaSFAEjeKPglwGnloumWTKPKIHlpvlikULrBSAlNaUdE0QoSW5pWp4SKnWMbbEdwuwo1NxTLrI2GvQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5016.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(4326008)(508600001)(54906003)(38100700002)(55016002)(66556008)(2906002)(5660300002)(8676002)(7696005)(8936002)(9686003)(6666004)(186003)(6916009)(86362001)(1076003)(83380400001)(52116002)(66946007)(66476007)(6506007)(316002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?NbD7fNTPIkEbxalCAs06qU+Y8IdjZT6VWv/4HhqaLgPSTq7JLAatn0j1izay?=
 =?us-ascii?Q?TzK2voWnPOvDRyb+KTuyGqRcFbJgrjy+gzzH1B+LLDwijtr4U3MOF8Qs8aOs?=
 =?us-ascii?Q?R5v/rLNBm7SuoC+3nUK61gMi/zHntEaTJiNNU+PHCztSb4g/gU1gGXidNH7u?=
 =?us-ascii?Q?jjdX2LdQeyZFHWLfR9Zszp4dJnIgVUp2X8OaU60/hEBEqtyfQ5pAg92pHxtO?=
 =?us-ascii?Q?/Hr3EQeTeP1U3AFonRJ9gBAd+XFtnVWW9gOQpubzH1xsLnIxrRmkEEgv6fAK?=
 =?us-ascii?Q?zvIuyfE8i9EMmR9ZOCgS1/sKrLtGYHFjrvJyqgMbMtVwZg20UB/NyPkmfEo1?=
 =?us-ascii?Q?CuIZ48d8nsvFwABPvIm00lYC6xX05MMSOuh9lTgLUdS6iS/7RfEvUpSfEaCG?=
 =?us-ascii?Q?ds39SxoGMJy+BEpsw1kzjAlLCS80jmH5OVCFSdhE1cDCoImdwMwOGAxF1Nql?=
 =?us-ascii?Q?VZrYCVzk0mPGjjkw+6lnOQmbTviHwDyt/Y9LD7nMP592XxSM0ZDpSOnuI7yJ?=
 =?us-ascii?Q?7Z1l1cluXkcbFn4dbJsZwFoTY5i2MP5vvJBC26AcLgXOmhOvhMGbv/bTEva6?=
 =?us-ascii?Q?jOWIoJy3sD3D5NwX4chLKhz58Vm9232ps9duR1T6yxBa2EgQw7DNMJdNFwby?=
 =?us-ascii?Q?ANSjYqjgD4qKZzLCwzL6s0o8GNOQq28rCh6CfC93ub3/jaSsAX/CdlcvM3Bu?=
 =?us-ascii?Q?J6ISvJ9y5qPS5KdjnrousGTegQDw1MbvBqfYRvvZQp6uErRbnyWLys9o+uJu?=
 =?us-ascii?Q?qro1EHLhzkVrn99vElfBgl3Fs4+aXw34TmtR9w/1X/QaDCqvBaCiQuodKzs3?=
 =?us-ascii?Q?CdJribrdQcyijhRi39TotaStwb+oiLnGjFM5VBAvq6C6tEJvJhJlIIdRcxbF?=
 =?us-ascii?Q?KMnV+RFKM0CEaoNYhY/VfHWzLqKMs3uEN/AJVBc7fCcocrpdX6MJGrBFEaoH?=
 =?us-ascii?Q?mGp6QYXOVi6MmiyvC1fGtN1Skyc+Qboxg9yoecgravfuwHuok9KyI1c/cAZ3?=
 =?us-ascii?Q?PI1dt6uvvmPSQR9MRP4AcsvJvcYRjl3D6s531qGDxhgBtLmNQ668GNl40o03?=
 =?us-ascii?Q?YAvpYFzNmA2dKAD+7TxWRBG2xyWtrPqIXgKRGg6Tinar/tB2qQfYk/hAjQ6E?=
 =?us-ascii?Q?wmF4kUj2+j2vTIvl9XfyIjiQ2bZXUNk19se1gyeY7TwMPzp3UHq9b+URkA1w?=
 =?us-ascii?Q?OXiJ12mNWuZVzRUn0r9+Fw11p8BopOZ5cKvgY4VNMHGVcNuwffg7muGbO4yH?=
 =?us-ascii?Q?w0D0OmC2nU0BZ2X7suRb3T17AcYQcDE+5H5qWDgI8PyqriFF5Fx2b3KfY/6o?=
 =?us-ascii?Q?H3Y76PEHrq932bDX1gU0/n/7Xds699KIIGA9EH+g3s32tw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: eb968efc-9198-442d-df65-08d993869cec
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5016.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2021 05:01:02.3787
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: W3PzKp+V4b5wCpUj4Fr3R0ewTuUOLfX/ZgH2cIKxdQnqCChoD6x7j8tL5Hc044ib
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB4981
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: FOpQEYyf_1E_3N3cVemyE1szO-ZXmCvL
X-Proofpoint-ORIG-GUID: FOpQEYyf_1E_3N3cVemyE1szO-ZXmCvL
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-20_01,2021-10-19_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 malwarescore=0 priorityscore=1501 impostorscore=0 bulkscore=0
 suspectscore=0 mlxscore=0 phishscore=0 mlxlogscore=999 adultscore=0
 clxscore=1015 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110200025
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 16, 2021 at 08:48:03PM +0800, Hou Tao wrote:
> Factor out two helpers to check the read access of ctx for BTF
> function. bpf_check_btf_func_arg_access() is used to check the
> read access to argument is valid, and bpf_check_btf_func_ctx_access()
> also checks whether the btf type of argument is valid besides
> the checking of arguments read. bpf_check_btf_func_ctx_access()
> will be used by the following patch.
> 
> Signed-off-by: Hou Tao <houtao1@huawei.com>
> ---
>  include/linux/bpf.h      | 27 +++++++++++++++++++++++++++
>  kernel/trace/bpf_trace.c | 16 ++--------------
>  net/ipv4/bpf_tcp_ca.c    |  9 +--------
>  3 files changed, 30 insertions(+), 22 deletions(-)
> 
> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> index b7c1e2bc93f7..b503306da2ab 100644
> --- a/include/linux/bpf.h
> +++ b/include/linux/bpf.h
> @@ -1648,6 +1648,33 @@ bool bpf_prog_test_check_kfunc_call(u32 kfunc_id, struct module *owner);
>  bool btf_ctx_access(int off, int size, enum bpf_access_type type,
>  		    const struct bpf_prog *prog,
>  		    struct bpf_insn_access_aux *info);
> +
> +/*
> + * The maximum number of BTF function arguments is MAX_BPF_FUNC_ARGS.
> + * And only aligned read is allowed.
> + */
> +static inline bool bpf_check_btf_func_arg_access(int off, int size,
> +						 enum bpf_access_type type)
Refactoring makes sense but naming could be hard to figure out here.

"_btf_func_arg" part is confusing with other btf_check_func_arg
functions in btf.c.  e.g. it is checking an arg of a bpf subprog or
checking a bpf_prog's ctx here?  The name sounds former but it is actually
the latter here (i.e. checking ctx).  It is a ctx with an array
of __u64 for tracing.  How about bpf_tracing_ctx_access()?

> +{
> +	if (off < 0 || off >= sizeof(__u64) * MAX_BPF_FUNC_ARGS)
> +		return false;
> +	if (type != BPF_READ)
> +		return false;
> +	if (off % size != 0)
> +		return false;
> +	return true;
> +}
> +
> +static inline bool bpf_check_btf_func_ctx_access(int off, int size,
> +						 enum bpf_access_type type,
> +						 const struct bpf_prog *prog,
> +						 struct bpf_insn_access_aux *info)
and may be bpf_tracing_btf_ctx_access() here?

> +{
> +	if (!bpf_check_btf_func_arg_access(off, size, type))
> +		return false;
> +	return btf_ctx_access(off, size, type, prog, info);
> +}

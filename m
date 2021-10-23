Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B09484380EB
	for <lists+netdev@lfdr.de>; Sat, 23 Oct 2021 02:19:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232285AbhJWAVT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 20:21:19 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:40370 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232226AbhJWAVS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Oct 2021 20:21:18 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19MLBnUN013688;
        Fri, 22 Oct 2021 17:18:37 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=w2VvkvvGcvQ4k4IxHY5HFlVw2mElANhI3cGRcy7CeV0=;
 b=NFttLYd3ainQI2WrTRQiQYtuDWUtNABJemcJA8lQF03AzpMlAZF088o0GYd861IHIE3c
 4IC2fzqFwOeohLP3BvtWZAxV5/AA8KWTCizZNTcKxsYjgf+rSvAzKKNvT29cuvFEc0xL
 WQfKoJLAt1porzRaG9nFLZEl95f4i0mOlHY= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3buntg0nmc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 22 Oct 2021 17:18:37 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.14; Fri, 22 Oct 2021 17:18:36 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nTqCARRqFtFL+Xac/L4G2YGlin6f0LSpdJwmjEsODYeEAu3sUZtqAzkX+9/O7iNivmvrAHeT62rJWrBjhmFzcsUin070AUxKFo3/YieLu5RKctokjZYpGd5d6bOJjJsnTodh51CxvRQ8HptWMt/OiGhvkf44BiT6PPIOZlatdAXBR9FJZ8W4d0JsQsdgrbnqXxYY2+msp+d9ZFGboFZ/bf3YMxiBGnyAzu8qhKLIuUw31mDsP1tllkxYfOB0w1UAg4VMif5KNeCuePVjZ7MeZNZIP1b4T4Prm7PT5FarCLDhkmLwfjJoE/dbs74wPD4E7ol6wsSiyHMIPyFGwLA3pA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=w2VvkvvGcvQ4k4IxHY5HFlVw2mElANhI3cGRcy7CeV0=;
 b=H484PAdwLBmE654P04Y8KTj1tRQV/rq1uSafJaI10wh/XHsaH2mH6qZEIiLevQjJeW16xIsF1IBhz7kZQCLj24Ftuzr97f9aQRQW4dVfA9s9uukRi20hpsicCiDMGTZdod2N4dZQebhs4FBbzUIdODX9LiN8MR3AzOCP6yAMFrv4HkX2kRHVUxONXBTbdM6IgBddmUCL3iMkBkxipGKsHQw2FMa+2bwfV+1iEazxBQe11EM6FdAzkm7L0RDtdBnKz9SWh1sBfBySerz6AIJg4yGsnxSI9Um2Crw5zu0zyDlGjcVvMFj7Oa2oAFW5YZGF2wBCLieg/DBFOme0OPR/6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=none action=none header.from=fb.com;
Received: from SA1PR15MB5016.namprd15.prod.outlook.com (2603:10b6:806:1db::19)
 by SA1PR15MB4966.namprd15.prod.outlook.com (2603:10b6:806:1d5::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18; Sat, 23 Oct
 2021 00:18:35 +0000
Received: from SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::6c34:bcb:51af:6160]) by SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::6c34:bcb:51af:6160%7]) with mapi id 15.20.4628.018; Sat, 23 Oct 2021
 00:18:35 +0000
Date:   Fri, 22 Oct 2021 17:18:32 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Hou Tao <houtao1@huawei.com>
CC:     Alexei Starovoitov <ast@kernel.org>, Yonghong Song <yhs@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>
Subject: Re: [PATCH bpf-next v3 2/4] bpf: factor out helpers to check ctx
 access for BTF function
Message-ID: <20211023001832.jvz5lbnj33l4y3jb@kafai-mbp.dhcp.thefacebook.com>
References: <20211022075511.1682588-1-houtao1@huawei.com>
 <20211022075511.1682588-3-houtao1@huawei.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20211022075511.1682588-3-houtao1@huawei.com>
X-ClientProxiedBy: MWHPR15CA0047.namprd15.prod.outlook.com
 (2603:10b6:300:ad::33) To SA1PR15MB5016.namprd15.prod.outlook.com
 (2603:10b6:806:1db::19)
MIME-Version: 1.0
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:792e) by MWHPR15CA0047.namprd15.prod.outlook.com (2603:10b6:300:ad::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.15 via Frontend Transport; Sat, 23 Oct 2021 00:18:34 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d6fb8e40-9f51-40a5-ee25-08d995baa738
X-MS-TrafficTypeDiagnostic: SA1PR15MB4966:
X-Microsoft-Antispam-PRVS: <SA1PR15MB496662C5000759EF55F7E46ED5819@SA1PR15MB4966.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ls5Sbe5Zmb6SeT/kV6vt3sFjvITVgpaDCQZ0IiDALnpM9z/p68Zfo6sZbs4KdMQCq3Xr5tajzBdiyeTeaVgCM+vedX0eQHbnbh2kcf66hvAk0isTTfvYcW8G3tbg4xnGMjLH2CELAy8CQ2y7165OdURYL0WOYzCKHdJpqsi05tSVhSMDQZKMMN6m9yGJrX5FqllINFi/Y8od9SdihQKb0sj4MOi85tx2Q0esyyizDPITdkXBfa+s02AEdRCkwgvEIclcX22ojw7DksFKdJzuUpbigEWxCIFSh7ObOJd5tAAtYI/I9tep0SyoWm+TKFUYK2d7UjrOhYmK2N02TI0jubXRwgQQjK8FeP/fOfdoi0+boXfLeAhF1J5HQ9cYJl0+TGBijlwoAQ9BXcQE64uahqTXL4PLPa9Zd7iSJ8+ph+Q8/HbyfCp8h7pKfBzcETo5nB2AIz0tFXbbmdaecclMuBgSSY3rU/fWE2hU95O3ja4cswI8TfQ5NB8eNGj0KKJ9lbvoLf4HQtjuog7l8sN8w7WfY8a/xhdw6X7OqnXZoZqE7KAhG4YjlbbPZ3LYmS+E4Qfyxf9kFtDmlxw+zpvftSf3pUKNkdHBlziFhohuFTmpsdgQcWISm/z9urLH3mVL1+sqZBudXoWeT0MnkN+vAw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5016.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(316002)(2906002)(5660300002)(54906003)(7696005)(8936002)(52116002)(86362001)(83380400001)(508600001)(8676002)(1076003)(6916009)(6506007)(66946007)(66476007)(66556008)(9686003)(186003)(4326008)(55016002)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?f6gaS9hii+563QQcuVN+SIkOOehbxpbTuyMc+8sfbj54/Dauvm/K6u2MXuWf?=
 =?us-ascii?Q?RFQFEG61lSoAHPkQ7j72e4fMIU8zMn8xArz6Kg5dsv71/i9UUEovWdWvvacT?=
 =?us-ascii?Q?TrJYpCq27ypt/Pj9TTUCIZfe8OW3sSN9+G05Th9hP/ULPgbdiY8DX567Hqgb?=
 =?us-ascii?Q?aY2Un6YyWYvuaBT67jhsehSDVsBCwq5jl+4nn7HSU8AY0I+M8Kur6CsUCtIT?=
 =?us-ascii?Q?UykRNtXtmTUlneFHZh0ZuK3dEjlohvvCbMwny9M3UtzaHRWqdWu8hQiT8BtS?=
 =?us-ascii?Q?dXcstRUNFsIqSclJrfBBqLZC5tq4/yWAEVV95mzZNecKqjEUsM+hN041rBlN?=
 =?us-ascii?Q?eBsQ5Gido/9tYZK0fC+FWUKfaKToCEd6435L57DMm/nF/H8/hkX7VVQE2VfN?=
 =?us-ascii?Q?g7UmzaFmd9HoqBKRO0scNpukIzZ5C+spcxeLEY9rMZsAl+Pi6IQqVEB0gXlB?=
 =?us-ascii?Q?LqNcSAl8FEv9dcxiy7xX/qUqAivYKBFly4qR+Y+F2uHVXAe0UaBou3FTr+np?=
 =?us-ascii?Q?WyGKulvI47+hbJylRNdwSUHYNwwq0EMEKJk77SArq0DpjpesQ0HcjdWlMp7u?=
 =?us-ascii?Q?Cqtwe6ZkyFOxqVEsFQwCo+j2V77GXZIG0V8qMFRi1m7UmT6Puv6h2Wfgjm+p?=
 =?us-ascii?Q?sf5UHb1Hr8gGsD2x4zP8IC8sPW/hgrRrAPa5B1SM3NTfejNC6fjR8AvyJlkO?=
 =?us-ascii?Q?owcY/EdZUoOFln+LJccAJA7IbSqUaRy6cAuSh3EgODFhm6ulF8JAy/Hs62Lx?=
 =?us-ascii?Q?doYCXN1BdiBNN0ziarpMut9JFfiBS6TryRKrPJ6uzgsb1OzY7nesj2SvFx9q?=
 =?us-ascii?Q?h3UtFUQx6fdTU5Ai4gPwrEKU0tK5M87IiadNLBn+ud5fdkveVuSv7bjv4wxk?=
 =?us-ascii?Q?wKARgIk2DwCt831WUaB3JWw9hyU8hIpZ9gxqKxrUC6Pj2bifsbp2b9ovcdw3?=
 =?us-ascii?Q?1nJ+wJPIOfCukU4e25cPphVVXFLMLw9QXv+7Lmz5O53uKORA+UFcrMXLtihk?=
 =?us-ascii?Q?7Bmz7W/bX9n6ZNDZgy8rAQsm0gJTZ/AFoEwbuaKJrl4v8Cgh+gW5noUH54Vg?=
 =?us-ascii?Q?DHjqxpnre+3P55x2JB5puIA4aUp9+jfQdLHqYqG7DhBmqUzNMvqCcryMoAfW?=
 =?us-ascii?Q?8V+IPkv29+90KjRKbP2QTFl/PSaD4BDi9umWhx/NOfjy6YzF+E+5qvnso5+n?=
 =?us-ascii?Q?fy4Y/GxukAglqZE5DeFC2ZnDihtul/yaxU1NhPdHTja7pFfjB+MhmnwLXmbC?=
 =?us-ascii?Q?v2SdtQc7z2tPruxXxkyb+qKihGiKRKEBs/l5s5WtmgFHLX13q1AcT17PVgwe?=
 =?us-ascii?Q?O0hiD0uTbciAoeACWPTkSMQmL2bJ1/2Kk5EJkWtKRUik7dQO7SSGHVG8Z28g?=
 =?us-ascii?Q?XpiuyOdNAHEehl3A2XupXoOwsc3ic6Vvliza7ukSJAEZja+sKBFpTqcwIEoU?=
 =?us-ascii?Q?iLFygNSk8NYFJkypTXojhe2MxVzMest+rQz5853WrDosLLos8sX3WwafWajA?=
 =?us-ascii?Q?OfkUXqpnyW0kSDVCjU4PKCUPpey3kF83+K0jfN0ECS317CI/QEoTj6ccw9qL?=
 =?us-ascii?Q?1Ub/f7eKcA+47dhnxf3MmdzTFrcOYnjpmydYcNbGGgnck/i6Uu4XX339GVc5?=
 =?us-ascii?Q?Qg=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d6fb8e40-9f51-40a5-ee25-08d995baa738
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5016.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Oct 2021 00:18:35.3817
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7u+k3HmiO/LIr1wnyQjlB9eVqh1qqlARA3wTitxfCfY6Vkq4qPxkMI9Y+jOqp9ZZ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB4966
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: m9hJZMh4wc7h_MG3fqLhghk4Pu21ttzI
X-Proofpoint-GUID: m9hJZMh4wc7h_MG3fqLhghk4Pu21ttzI
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-22_05,2021-10-22_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0 phishscore=0
 malwarescore=0 mlxlogscore=938 lowpriorityscore=0 spamscore=0
 impostorscore=0 priorityscore=1501 clxscore=1015 adultscore=0 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110230000
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 22, 2021 at 03:55:09PM +0800, Hou Tao wrote:
> Factor out two helpers to check the read access of ctx for BTF
> function. bpf_tracing_ctx_access() is used to check the
> read access to argument is valid, and bpf_tracing_btf_ctx_access()
> checks whether the btf type of argument is valid besides
> the checking of argument read. bpf_tracing_btf_ctx_access()
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
> index 3d2cf94a72ce..0dd2de9eeed3 100644
> --- a/include/linux/bpf.h
> +++ b/include/linux/bpf.h
> @@ -1649,6 +1649,33 @@ bool bpf_prog_test_check_kfunc_call(u32 kfunc_id, struct module *owner);
>  bool btf_ctx_access(int off, int size, enum bpf_access_type type,
>  		    const struct bpf_prog *prog,
>  		    struct bpf_insn_access_aux *info);
> +
> +/*
> + * The maximum number of BTF function arguments is MAX_BPF_FUNC_ARGS.
> + * And only aligned read is allowed.
It is not always 'BTF' function arguments.  Lets remove this comment.
The function is short and its intention is clear.

Others lgtm.

Acked-by: Martin KaFai Lau <kafai@fb.com>

> + */
> +static inline bool bpf_tracing_ctx_access(int off, int size,
> +					  enum bpf_access_type type)
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
> +static inline bool bpf_tracing_btf_ctx_access(int off, int size,
> +					      enum bpf_access_type type,
> +					      const struct bpf_prog *prog,
> +					      struct bpf_insn_access_aux *info)
> +{
> +	if (!bpf_tracing_ctx_access(off, size, type))
> +		return false;
> +	return btf_ctx_access(off, size, type, prog, info);
> +}

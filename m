Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 334483EBCE6
	for <lists+netdev@lfdr.de>; Fri, 13 Aug 2021 21:58:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233874AbhHMT64 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Aug 2021 15:58:56 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:53262 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230440AbhHMT6z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Aug 2021 15:58:55 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17DJwFrH021749;
        Fri, 13 Aug 2021 12:58:15 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=8lAzDh2xjlHbluXgE62CjwDRFhQ0X4KQt0kYDWFKwvs=;
 b=LG+Tv2+z83k80rBoAuGuKrZ+hxj49NeETi9MlQsGlbSZGxcJd55tz+ne63PK7dbbPqA2
 rwj63anLrOMKkwUX3dKZ7mLuY1FaJ0YiqomfA9WSCRXXsJBBd5c0pdpQvoRf26kuei64
 VfgyUqBCpqv3ZjftNrme4UG6vHHKtbtcvwk= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3acy4pkkj1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 13 Aug 2021 12:58:15 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.199) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 13 Aug 2021 12:58:05 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=el8c9hEW1Amjn+nEYJHH9moB+6BJjorN/ETfN9osu9uj8nGpO9iVhQccxsafufkqy2Ew/5Azf70UKl7ViuT6UFYcXiUFuDqMi+/2PqFV4FTvKVvn1Jg0+i2c+t3qUEnefsMyF97UF9Q0heeRVAqEocZcc1y1W8obbztcwlWDIG6A8XH+chq/FC2hPSOotZcCFK85FP0BnbIRSYUDLp+yYITAbuLwaCK5AM7Qj/1xZxyzPzUwxoL4QJcQfPsKX4bf0pdbr7/9/rXXQJ1BhMN0erei/qtu9OkaNK/DkFsUnDLoA+e0Liev+NTJ0THBUCkBaoPyWezmIvrRPRkQ6PRpcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8lAzDh2xjlHbluXgE62CjwDRFhQ0X4KQt0kYDWFKwvs=;
 b=Z+g4EqrDG0QIJauBrKY9J4kKvYF6kJItnWAJ074lM9VwO2NPxs36L3VrTot41dppMOexhOy4FLK5TbUjWQm+YX3FfAX+QxbQRBx5uKAmJtukhruYBljWYOFEFZRgsGW+kzJphl+//sywZ/4hgW+WGjf4Hkv4wJMzYR9NLR/pXK4l01Yuc4KTvUxC3l65OgXkgW+YpJFhGnrhdAgEU6zlM95ONMnU1R2ZOsjPE5eNWFhESFdFSylspXufa3vJSr2kmzA62CAQBSe4XeR2HCrVHjb2cMiHAcdIQS6mkZiXqcDflIeZzvcwLPiJcdDzfx9lUF1YwZh1AsOwElqTBqUyQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=fb.com;
Received: from SA1PR15MB5016.namprd15.prod.outlook.com (2603:10b6:806:1db::19)
 by SA0PR15MB3807.namprd15.prod.outlook.com (2603:10b6:806:82::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.14; Fri, 13 Aug
 2021 19:58:05 +0000
Received: from SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::293f:b717:a8a9:a48f]) by SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::293f:b717:a8a9:a48f%4]) with mapi id 15.20.4415.019; Fri, 13 Aug 2021
 19:58:04 +0000
Date:   Fri, 13 Aug 2021 12:58:02 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Stanislav Fomichev <sdf@google.com>
CC:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>, <ast@kernel.org>,
        <daniel@iogearbox.net>, <andrii@kernel.org>
Subject: Re: [PATCH bpf-next v2 1/2] bpf: Allow bpf_get_netns_cookie in
 BPF_PROG_TYPE_CGROUP_SOCKOPT
Message-ID: <20210813195802.r67s62f5iwvnlmv4@kafai-mbp>
References: <20210812153011.983006-1-sdf@google.com>
 <20210812153011.983006-2-sdf@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210812153011.983006-2-sdf@google.com>
X-ClientProxiedBy: MW3PR06CA0023.namprd06.prod.outlook.com
 (2603:10b6:303:2a::28) To SA1PR15MB5016.namprd15.prod.outlook.com
 (2603:10b6:806:1db::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp (2620:10d:c090:400::5:e0ad) by MW3PR06CA0023.namprd06.prod.outlook.com (2603:10b6:303:2a::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.14 via Frontend Transport; Fri, 13 Aug 2021 19:58:04 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9a0c212e-a437-44bf-f3ec-08d95e94a9c9
X-MS-TrafficTypeDiagnostic: SA0PR15MB3807:
X-Microsoft-Antispam-PRVS: <SA0PR15MB3807F00744DF160909B9AC77D5FA9@SA0PR15MB3807.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:1360;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RhtcubLF0TSWzih6v/o/jZJ9ymDJhXKkfQNEmXczDDs6NglYg1hWymjRU/Z4FDG2wPdKQP0jBRl3Rwt7VcoTmS4T6YTRH4RFQGpDsWUCbm5ydzY7bOsjomJpn0kr2LQ8rpwiEujGxWObORvjf7CknrhP8xLqZDUnKzo/m21xhJun1uCuFgVGllLPlVbBZIZexfwVY4qcOsjZjT3GzWFSyExH/XX95/MlWjCwtyxIZ5aOMlHLO+liakztnUUWKm+xcUYWfnzDMqDnEnSZ5EHgIC0mrA20n3ZhJcARbbsS1aBTU1gs23ZHWHNXjZVETUMV/19KTRhpMGuCYFfye+k8jXIpFBG2plLjXY6FvYTHfkKXkQsA9F/ou2P5c6AMOV55c9vxNikdcS5hIrmIC+GEaBK8WSc46prW4KTB86WopZwikgQrCvhbABHfvwSh/8u/9kuDNrW7kHp4w/d70l0V24KktyaXimDhHR9Q2UerlePv1Kxp3+Lbfetii5CVKZJiiyzz/9RfBVxV+nFURnAakTgizAse6qFtyIZhnxHIYR384kAQv2IVDOGDJ8Sn6XO4Ae8/XRI0ISCHDlV1PbMSfO8wO2M/HCemMjxP7cv/ncz+r/hWe/28FieophQTlrcwaUV0HmQXdXDitzuCEyFsiA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5016.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(39860400002)(396003)(346002)(366004)(136003)(186003)(38100700002)(2906002)(8676002)(5660300002)(316002)(86362001)(9686003)(6496006)(66946007)(66476007)(1076003)(8936002)(52116002)(33716001)(478600001)(4326008)(6916009)(66556008)(55016002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?vlQsGLnlHM4pHrdsTyGGL6sWGg+Y7EJOZUyNWN9kvHPNvOdTU9/hLtUsYTPa?=
 =?us-ascii?Q?4UJgmmztCbt7AjP8spWmEEqRQZZS8BxM2NMtGvwfE9oudfhmdirIw/IA8XAn?=
 =?us-ascii?Q?5/ePVnkhGfphFY3XC0KE3rZEW9K6ZoBMy8891plloPKniRugM3mHLNGtmaPr?=
 =?us-ascii?Q?qbeohgKo3kmHbnLHk10kT0zYr9kNfO5KaurL90T6EFYgQJc7IAH+BvYjePii?=
 =?us-ascii?Q?CJluM143BGrk5zNKApAdWCAYsotFcoj6XUTgG9lPiFTHI3fiR2CmMK92pzO7?=
 =?us-ascii?Q?gZ7k1EAFEqa67UPprClquQoT+++XhJRBgttzHAQrNClgy9teC2XLHoeJVqZ4?=
 =?us-ascii?Q?rQHkEILlcMbcUDWaK3DveKClsTAJaSpwLcf42WpJpi6/IPaPLF8vV01gf5e8?=
 =?us-ascii?Q?WbL4+WJbTmJcZxSWnHsvwZO7UirWBJAz/klHk+AFE+nkM3kL09dpE1vgTq7R?=
 =?us-ascii?Q?OiSQ8lGU9ImxnPuPSQP7B/VeV5Z0OyRUMWdkp7LNz7wEMJWWDkJ/EGdk/s2f?=
 =?us-ascii?Q?Cpp7sNYjG9q2wtnwfCVq1yrktzDCsFz3bf0m8uKinSDUT+G47TAX8e0mF6aE?=
 =?us-ascii?Q?ZXslQsn3NeTMnd4KMnxpSd/05uBN4XokvdvBQVb6nBUFZaat4lwB2ughAOVA?=
 =?us-ascii?Q?scODycVcFUruTpDdq0FsW4NgfuJ4m0JUukM+BH2noV+mLlLAjckKHFstOk9h?=
 =?us-ascii?Q?bxdW24BB62KM+syGzyTPKL6zd1IfbM2Xr1uJ6TBPn+89iiBhnFarukdo+jN5?=
 =?us-ascii?Q?zrbOzyiexIenDRs0NcQaPDdlQ36HkibopryRfifFbSjxDQtuchySndfuPkI1?=
 =?us-ascii?Q?0tC+4CxoicehaNSBiizEitZ4Vesv/DZfTYHnOLbVZnOQAfIJI3k97AzEIF76?=
 =?us-ascii?Q?htkPHPUlIpMlm8qAOiIIgF1SyveLw5hScBe53zkbu/WvExU+sUdBsdegHwpR?=
 =?us-ascii?Q?FzI1ZlMIIueWy7EGIr9Hn/GDRsrULrEiLYuUYNthWRMOhc4GDy4OZh1Hd5Pr?=
 =?us-ascii?Q?EG8dS0wa0YIsUF3YtdwUvW1VX5ElwwtAccX9RFFd0SQui5veFE/jmh5m2VFP?=
 =?us-ascii?Q?/Pm/b/I4kfG5OZO8JDcgy8F+VvIVh91oAJaVGkbXeQihICM2Z0qFOq/He1xl?=
 =?us-ascii?Q?byHE0Y467w/k9SJPB3RnvbSyIA5qBLudJbr68LJ3Jq/3xU7AsB4VGgG3z/1l?=
 =?us-ascii?Q?y/nlNml8Dxna4EdFMHxlkKCkPOnx4+ZUWHuVgkTA0Nq2j7PVoJ9+NAvcwqSf?=
 =?us-ascii?Q?zCPGh/oejBgoyAPYj8Vu5gCwzVMT/qfKzp1KFyfCYoQrNG92fuxF67D64Iwd?=
 =?us-ascii?Q?IoVjWu8MdhBWDqsBtTUBj2R6/qqKcAaErpPgqJVgFFR2Mg=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a0c212e-a437-44bf-f3ec-08d95e94a9c9
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5016.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Aug 2021 19:58:04.8302
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: J+Bcu8qBQrTrcSFB2/3dL0xFFOkSW0QbdjGFWe3N+pvceTQVTgQH86sPdaaMPzUm
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR15MB3807
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: NceA4Yj0u0p8dc5a8NQ800VKp2XQ9xyd
X-Proofpoint-ORIG-GUID: NceA4Yj0u0p8dc5a8NQ800VKp2XQ9xyd
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-13_07:2021-08-13,2021-08-13 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015
 lowpriorityscore=0 mlxlogscore=999 priorityscore=1501 malwarescore=0
 phishscore=0 bulkscore=0 mlxscore=0 spamscore=0 impostorscore=0
 adultscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2107140000 definitions=main-2108130116
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 12, 2021 at 08:30:10AM -0700, Stanislav Fomichev wrote:
> This is similar to existing BPF_PROG_TYPE_CGROUP_SOCK
> and BPF_PROG_TYPE_CGROUP_SOCK_ADDR.
> 
> Signed-off-by: Stanislav Fomichev <sdf@google.com>
> ---
>  kernel/bpf/cgroup.c | 19 +++++++++++++++++++
>  1 file changed, 19 insertions(+)
> 
> diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
> index b567ca46555c..ca5af8852260 100644
> --- a/kernel/bpf/cgroup.c
> +++ b/kernel/bpf/cgroup.c
> @@ -1846,11 +1846,30 @@ const struct bpf_verifier_ops cg_sysctl_verifier_ops = {
>  const struct bpf_prog_ops cg_sysctl_prog_ops = {
>  };
>  
> +#ifdef CONFIG_NET
> +BPF_CALL_1(bpf_get_netns_cookie_sockopt, struct bpf_sockopt_kern *, ctx)
> +{
> +	struct sock *sk = ctx ? ctx->sk : NULL;
> +	const struct net *net = sk ? sock_net(sk) : &init_net;
A nit.

ctx->sk can not be NULL here, so it only depends on ctx is NULL or not.

If I read it correctly, would it be less convoluted to directly test ctx
and use ctx->sk here, like:

	const struct net *net = ctx ? sock_net(ctx->sk) : &init_net;

and the previous "struct sock *sk = ctx ? ctx->sk : NULL;" statement
can also be removed.

> +
> +	return net->net_cookie;
> +}
> +

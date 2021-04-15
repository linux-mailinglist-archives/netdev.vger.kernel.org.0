Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A45CF35FEC8
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 02:17:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231266AbhDOAR5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 20:17:57 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:47070 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231234AbhDOARz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Apr 2021 20:17:55 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13F09vQp020465;
        Wed, 14 Apr 2021 17:17:17 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=AIA7MEqqeFjq+IB75PKo85NA4450MfxRz7E0+bJ4TN0=;
 b=EHyOp2u8Za6ytLkoWdjvMBlC7VN9xZ29B1+b/K9UzJ8uH+GwejpZJMQe7UZNjjU0ilkT
 du48KE67Y26wCm/MDW+DD+9zzv3wLVvl0BLNnJRkJJqWtGN/jECRzu0OO0WrvFk7oxqJ
 P4SDvDLU7/RdHEvQVmR7B6k2TU9J/TLVNyE= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 37wvfuvp11-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 14 Apr 2021 17:17:17 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.230) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 14 Apr 2021 17:17:16 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XnR4cHVvtkTNPggO0/AV9qWQMTasjpZr1D/NfQIplqTjkzqOiuzszkqHAX3Z6/obX8JcSl9KhXrupdYBd9D4+NY9punZTfV/xcTFk+soomF7Im45FjyPl31HVB0ws6WRsUMZJwjBXJH6VqOuQoQ4Ya77jh6uy2MCTxqdTT+ErkMsyBCJnBa071lm+4FxiQy0+Pnzi6Rm001DJxBHnLm+OThKBpTIzdHOH+WHaNfYqgfOQuYMV1eR1/xB3+2QIHBe5iNpI60Px4tdupdD9+pVKCDDSlwJu5/JC3jCYd49nO7BuPcLdYTE7IyIiHjoiAF0dwHS1gAjvgIaj+1/NaGODg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AIA7MEqqeFjq+IB75PKo85NA4450MfxRz7E0+bJ4TN0=;
 b=ji0PUFsZ7v77xoAq4P7H60UB2/X6rlydwyoZ2/U8ZjWGajFer+dYDVvia906q98keGVHCQ+ttWm9got/n8xzbLfSc+XEh1w5EvQqbkZmHXI/SNZMnsNWPPnZ5MlRURvCxhUgK1S4j1f0BCyPhXWpjVenJKUbjVs4kH4Ds5pC8j2huQi5QjZlXOd509+6ps35CsJEbsxarHuzFZFknbXGRavjR3V+q0yYB3Cl+gqbPdx4wWk6wvF+96cywwqRRsAVWkgK0J+ICMcYu66VBgflhEVax0dZgEJVwqialaxPZFX6jM7GXFmI0X5MiQpZLeFJG259A7afhbxpwSqXLu80FQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by SJ0PR15MB4236.namprd15.prod.outlook.com (2603:10b6:a03:2cb::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.16; Thu, 15 Apr
 2021 00:17:15 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::718a:4142:4c92:732f]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::718a:4142:4c92:732f%6]) with mapi id 15.20.4020.023; Thu, 15 Apr 2021
 00:17:15 +0000
Date:   Wed, 14 Apr 2021 17:17:11 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Hangbin Liu <liuhangbin@gmail.com>
CC:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Jiri Benc <jbenc@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>, <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Subject: Re: [PATCHv7 bpf-next 1/4] bpf: run devmap xdp_prog on flush instead
 of bulk enqueue
Message-ID: <20210415001711.dpbt2lej75ry6v7a@kafai-mbp.dhcp.thefacebook.com>
References: <20210414122610.4037085-1-liuhangbin@gmail.com>
 <20210414122610.4037085-2-liuhangbin@gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210414122610.4037085-2-liuhangbin@gmail.com>
X-Originating-IP: [2620:10d:c090:400::5:1212]
X-ClientProxiedBy: MWHPR18CA0037.namprd18.prod.outlook.com
 (2603:10b6:320:31::23) To BY5PR15MB3571.namprd15.prod.outlook.com
 (2603:10b6:a03:1f6::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:1212) by MWHPR18CA0037.namprd18.prod.outlook.com (2603:10b6:320:31::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16 via Frontend Transport; Thu, 15 Apr 2021 00:17:14 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5a0da9f7-4759-4ad4-7a00-08d8ffa3d2d0
X-MS-TrafficTypeDiagnostic: SJ0PR15MB4236:
X-Microsoft-Antispam-PRVS: <SJ0PR15MB42363DB371A439702DEFE23ED54D9@SJ0PR15MB4236.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HAcpbs7mpmeaOWLfK1KW+19ep5o4aVQE1jNw9UnjiXOk0GFDbuUV9gphPg1Jn9Oi1W8q6iUbMn3MexW2xBc19UrMwZ1TyenI9W0Rab7IYeqkNrtGCL4uigIJW0c6MtKqSB8rP/F1ssBok3UgBhUS3lnPynqJGGUt1npfkDcG5yUfkUYld8NV6x+8Zb8uTFlsnasWOHAPHyWAQ7WI0LJoIEuiZpkMUScYwkAecWZrCiJZMA11nTMHcUcLlBujixcyh1ZrYuN1Jz/MAzUD/s6R9vLMzzvt0VxAltztfA47izuXpoY+eL3xhF+8Ulxt5IbUD7TjWZCcl3SYcutbqp1gmMNhI3VgMNz82MDPfsQZ0lfwHEpyMnkuTBnjDelAfj/ybOO7EjZPlFBlP0ElAWCpDf8FZv/iEyoj821iA5A58dGTveF9t1N6qb3xj9owX/5fHm9pjdNWCXH9/ouBJvQA8NlxWIOK2T16I3y/ruQrMAJr5GLakqd0myprYD6XZ5QaJKR7QxtyuCnHckHqkkcMHrC0k7DNVfkY4vLreddqEWk8jEtVEKh1Lll/mGlpcgqLDPEMbVH+ZwmIX3ZsjY2UpHNlq1EvR7IPUqdgJgvGF/M=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(366004)(39860400002)(376002)(136003)(396003)(6506007)(66946007)(2906002)(38100700002)(8936002)(83380400001)(8676002)(6666004)(7416002)(66476007)(1076003)(7696005)(4326008)(478600001)(6916009)(186003)(55016002)(54906003)(9686003)(16526019)(316002)(52116002)(86362001)(66556008)(5660300002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?UBHz9NIN4CDG620tFBmUH5Mrr4bnXgizmuRlOwx+9sv21E7gchQ7RqOYUbUP?=
 =?us-ascii?Q?5PIB2RFgHbAzNMpaxykXVQN2i0gbcoy0BcF4rCw+naysZ9qTbzV9vHD2TPim?=
 =?us-ascii?Q?srVGfvWYmh5cxk1QLehVN8b6TDm5OtpeqsjDjswlh94d2M+yD2NZKVOqcFiO?=
 =?us-ascii?Q?Nnb6KBgnxHSt1iH1iZVLwUi6yZrpC53i7ei8YpWz8j9Uao/cQd+JFxLh8+yC?=
 =?us-ascii?Q?+x1RJW45UCDg0zsFIr6IFSGW45ZXzPLg8d9mKk4GNilg/7Hh1hQGsWf27ZaQ?=
 =?us-ascii?Q?y/Bc2HYHFdrcQhR6MHGBOUo/UrpNrYcW0r0ipE4FfKV5XTaiHWR2GI41Smhg?=
 =?us-ascii?Q?hjOkbQ5OuVqsuW60Mg1MCbqztykeo4SwTmFRfwcZ53UjoUF/zVfKCHVwqCBu?=
 =?us-ascii?Q?1vFdHGL4TSrJTBD1lra2uAinNV2W9WXLZtwe+pg/bdWBSzHqyQr9sayZm/QI?=
 =?us-ascii?Q?B/gjOLkuOyS9FjyL8o8b2tZqNMAVSgETUxyJg/9fXQyTcy1wId5Bfjwjxcpn?=
 =?us-ascii?Q?AYIQoZbCN6LCP0ZY+HUciY1Y85IC2jOp6EzMYWHHdSUR5EbMyCXf90mKdJVX?=
 =?us-ascii?Q?XXK6qLq6ZPdPz7BF4nfiUXlCWH+xPBuV67R03cY98gK8Lj6/nzeQ30siDJht?=
 =?us-ascii?Q?+QCclp8uCx34lxXR1FOv9NWeRbGK2mysvFsuAG2uNr2u9sanvOAYOMYjv71Q?=
 =?us-ascii?Q?EP7t9Nl+SreMDvSAZkxYW8xfHP1nKwn6L+/wqRnEX6iFYtgdtrSXIPfGpG4V?=
 =?us-ascii?Q?sgDbkd7Vg7nE4bkWuAEyg0JdqKM69q47OW/HUkotG+z6HitVJjf0w0n+uune?=
 =?us-ascii?Q?Pu5q+9Whx4nd4kBs1MWULsvb9xO7KTOp5lYD4bbGa8s8pYWubQeEhw7rceIa?=
 =?us-ascii?Q?zdA9ff78dLgrTTvWuz9fpBDlX6uLz9WUWRRWBDNxJ4Ov3ZZ/TDhCBKqi6YAh?=
 =?us-ascii?Q?qEjyeQqsVPBP+PyQMEUum/5KLrqLkA5K1MN2Saea9OWWGvMCWxKUEXqKxLu6?=
 =?us-ascii?Q?8EIOYIJ0uAoYNyrbgJoZuLDOTzWsmSkDEejMndXtIob7SQ6lwnMmyqMdHlk0?=
 =?us-ascii?Q?zcX24bMxxHvT9diCoh4mMU9Y/GxcNTVFDotCeW3BUUG4Tsh7JpncpiRrvbB+?=
 =?us-ascii?Q?N9VTWP+QtVP2CynTAv0aoAuEtWQEh4K2in4OkUzXLx5Ej6ieWGzuMa/n6scr?=
 =?us-ascii?Q?SuOqWSRmpIAnY/dk7xdXcqBYXt17mU5aDgngxjOv/HaBGLfchbi0EPYWrqXM?=
 =?us-ascii?Q?Be53sFbz8KSGzcRVYrp7d2e+NEQi6ym5ZfqyJNZSY0/7rvff0FiXMNO1qEco?=
 =?us-ascii?Q?jjc8xV2W2W9IkMQodXP01+k95O/EHifwo+j3xcTz05jMSg=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a0da9f7-4759-4ad4-7a00-08d8ffa3d2d0
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB3571.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Apr 2021 00:17:15.6444
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zUOXqKQcw/4Dh3sHp6ulbuZ1AT7drFz6hbSTEYMcmB5gwjbNU2/BU5VoIlES34Z/
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR15MB4236
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: gOuBUnjAn5DZ--Hq1SZEtJTDNPzAptXv
X-Proofpoint-ORIG-GUID: gOuBUnjAn5DZ--Hq1SZEtJTDNPzAptXv
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-14_15:2021-04-14,2021-04-14 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0
 priorityscore=1501 malwarescore=0 phishscore=0 adultscore=0
 lowpriorityscore=0 bulkscore=0 mlxlogscore=999 spamscore=0 clxscore=1011
 impostorscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2104060000 definitions=main-2104150000
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 14, 2021 at 08:26:07PM +0800, Hangbin Liu wrote:
[ ... ]

> diff --git a/kernel/bpf/devmap.c b/kernel/bpf/devmap.c
> index aa516472ce46..3980fb3bfb09 100644
> --- a/kernel/bpf/devmap.c
> +++ b/kernel/bpf/devmap.c
> @@ -57,6 +57,7 @@ struct xdp_dev_bulk_queue {
>  	struct list_head flush_node;
>  	struct net_device *dev;
>  	struct net_device *dev_rx;
> +	struct bpf_prog *xdp_prog;
>  	unsigned int count;
>  };
>  
> @@ -326,22 +327,71 @@ bool dev_map_can_have_prog(struct bpf_map *map)
>  	return false;
>  }
>  
> +static int dev_map_bpf_prog_run(struct bpf_prog *xdp_prog,
> +				struct xdp_frame **frames, int n,
> +				struct net_device *dev)
> +{
> +	struct xdp_txq_info txq = { .dev = dev };
> +	struct xdp_buff xdp;
> +	int i, nframes = 0;
> +
> +	for (i = 0; i < n; i++) {
> +		struct xdp_frame *xdpf = frames[i];
> +		u32 act;
> +		int err;
> +
> +		xdp_convert_frame_to_buff(xdpf, &xdp);
> +		xdp.txq = &txq;
> +
> +		act = bpf_prog_run_xdp(xdp_prog, &xdp);
> +		switch (act) {
> +		case XDP_PASS:
> +			err = xdp_update_frame_from_buff(&xdp, xdpf);
> +			if (unlikely(err < 0))
> +				xdp_return_frame_rx_napi(xdpf);
> +			else
> +				frames[nframes++] = xdpf;
> +			break;
> +		default:
> +			bpf_warn_invalid_xdp_action(act);
> +			fallthrough;
> +		case XDP_ABORTED:
> +			trace_xdp_exception(dev, xdp_prog, act);
> +			fallthrough;
> +		case XDP_DROP:
> +			xdp_return_frame_rx_napi(xdpf);
> +			break;
> +		}
> +	}
> +	return nframes; /* sent frames count */
> +}
> +
>  static void bq_xmit_all(struct xdp_dev_bulk_queue *bq, u32 flags)
>  {
>  	struct net_device *dev = bq->dev;
> -	int sent = 0, err = 0;
> +	int sent = 0, drops = 0, err = 0;
> +	unsigned int cnt = bq->count;
> +	int to_send = cnt;
>  	int i;
>  
> -	if (unlikely(!bq->count))
> +	if (unlikely(!cnt))
>  		return;
>  
> -	for (i = 0; i < bq->count; i++) {
> +	for (i = 0; i < cnt; i++) {
>  		struct xdp_frame *xdpf = bq->q[i];
>  
>  		prefetch(xdpf);
>  	}
>  
> -	sent = dev->netdev_ops->ndo_xdp_xmit(dev, bq->count, bq->q, flags);
> +	if (bq->xdp_prog) {
bq->xdp_prog is used here

> +		to_send = dev_map_bpf_prog_run(bq->xdp_prog, bq->q, cnt, dev);
> +		if (!to_send)
> +			goto out;
> +
> +		drops = cnt - to_send;
> +	}
> +

[ ... ]

>  static void bq_enqueue(struct net_device *dev, struct xdp_frame *xdpf,
> -		       struct net_device *dev_rx)
> +		       struct net_device *dev_rx, struct bpf_prog *xdp_prog)
>  {
>  	struct list_head *flush_list = this_cpu_ptr(&dev_flush_list);
>  	struct xdp_dev_bulk_queue *bq = this_cpu_ptr(dev->xdp_bulkq);
> @@ -412,18 +466,22 @@ static void bq_enqueue(struct net_device *dev, struct xdp_frame *xdpf,
>  	/* Ingress dev_rx will be the same for all xdp_frame's in
>  	 * bulk_queue, because bq stored per-CPU and must be flushed
>  	 * from net_device drivers NAPI func end.
> +	 *
> +	 * Do the same with xdp_prog and flush_list since these fields
> +	 * are only ever modified together.
>  	 */
> -	if (!bq->dev_rx)
> +	if (!bq->dev_rx) {
>  		bq->dev_rx = dev_rx;
> +		bq->xdp_prog = xdp_prog;
bp->xdp_prog is assigned here and could be used later in bq_xmit_all().
How is bq->xdp_prog protected? Are they all under one rcu_read_lock()?
It is not very obvious after taking a quick look at xdp_do_flush[_map].

e.g. what if the devmap elem gets deleted.

[ ... ]

>  static inline int __xdp_enqueue(struct net_device *dev, struct xdp_buff *xdp,
> -			       struct net_device *dev_rx)
> +				struct net_device *dev_rx,
> +				struct bpf_prog *xdp_prog)
>  {
>  	struct xdp_frame *xdpf;
>  	int err;
> @@ -439,42 +497,14 @@ static inline int __xdp_enqueue(struct net_device *dev, struct xdp_buff *xdp,
>  	if (unlikely(!xdpf))
>  		return -EOVERFLOW;
>  
> -	bq_enqueue(dev, xdpf, dev_rx);
> +	bq_enqueue(dev, xdpf, dev_rx, xdp_prog);
>  	return 0;
>  }
>  
[ ... ]

> @@ -482,12 +512,7 @@ int dev_map_enqueue(struct bpf_dtab_netdev *dst, struct xdp_buff *xdp,
>  {
>  	struct net_device *dev = dst->dev;
>  
> -	if (dst->xdp_prog) {
> -		xdp = dev_map_run_prog(dev, xdp, dst->xdp_prog);
> -		if (!xdp)
> -			return 0;
> -	}
> -	return __xdp_enqueue(dev, xdp, dev_rx);
> +	return __xdp_enqueue(dev, xdp, dev_rx, dst->xdp_prog);
>  }

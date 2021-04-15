Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DF4435FED5
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 02:24:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231454AbhDOAYu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 20:24:50 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:44076 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S231334AbhDOAYr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Apr 2021 20:24:47 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.43/8.16.0.43) with SMTP id 13F0AUTT013643;
        Wed, 14 Apr 2021 17:24:00 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=xUi8m1tCCZDuleeiA5+syLfte9XMuCWYxxN6saKIero=;
 b=fHxxQ/bdjUjHxUKznPD6Q03PONKYF5rc+zLEYgryxMHKh/9AlzrWQADz2P/uDkMMzevi
 XE8OglImVFA7aLwHF7W/QI3Njtlghq1uk4gcLQV1sdzm5you/jQPJPAWmd/ZYX693yKq
 doSxm7F3qvamPXYBcXK1iML00j5PUQMUth8= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0089730.ppops.net with ESMTP id 37wvgk4pfj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 14 Apr 2021 17:24:00 -0700
Received: from NAM04-BN3-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.197) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 14 Apr 2021 17:23:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S18DGkyRqYPH+54DehIoOAil5CWr7a7KvdvIskIbZu+qflpAdO1BE3VRfy5FxaEHKE3VnunH+fe+UPUJx496O7grnzHw3Tc1az+t6UAldkmp91SCMs+zfq670kGLhwOaTzLvu8epcwi8H48KLKPvOZdDyiGSZXXm7v62MUBtxyrAyXWQ05YFJH0HPH3ARtH0vNXsJynJENdp5kFfxxTmEJKjQkQ6X/joVgeekHbDpx9iTu/7PaUvW4DJaNhbofI2peHweMRodvssVS9QeqG7u4Qx7yKsmlkCV8toOUwN/UGyzJOD+9AsAy+LHMyxU8Dmy8JREeo0suNbbw1MaHLRTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xUi8m1tCCZDuleeiA5+syLfte9XMuCWYxxN6saKIero=;
 b=I+zG8mTiwG5/JUDTy8TBN+D44nKnYf3fQW7vNK2u3BbTFcjEddDolSSXHfOoB/4z6v2d8wQlMJCKk+3Ng5fcS/TzGi5y9fAHuQCErm34TpExBxTg2J2DMN2qXCi+v1YSvtHHzrafk6n1/rbQgVE9ql83abiezbyGrh7jVWr6OHmzI4x48h03aOXU+Fm7SXymTeAdioM0k9n0lsIzyyW1gNPjx1pyMlqn8YMp/FhjBEZ9EIpJfKFt1C/1Mw02h31WJrfkHu8qHYoWW0k+gkWzrCXdmE+OjpYHXRQlSv1LvRWvCps+bJ3cWAz+JWfybq2i4UxZVEO9a7T+ZU0EDNvgAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by BYAPR15MB2584.namprd15.prod.outlook.com (2603:10b6:a03:150::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18; Thu, 15 Apr
 2021 00:23:57 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::718a:4142:4c92:732f]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::718a:4142:4c92:732f%6]) with mapi id 15.20.4020.023; Thu, 15 Apr 2021
 00:23:57 +0000
Date:   Wed, 14 Apr 2021 17:23:50 -0700
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
Subject: Re: [PATCHv7 bpf-next 2/4] xdp: extend xdp_redirect_map with
 broadcast support
Message-ID: <20210415002350.247ni4rqjwzguu4j@kafai-mbp.dhcp.thefacebook.com>
References: <20210414122610.4037085-1-liuhangbin@gmail.com>
 <20210414122610.4037085-3-liuhangbin@gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210414122610.4037085-3-liuhangbin@gmail.com>
X-Originating-IP: [2620:10d:c090:400::5:1212]
X-ClientProxiedBy: MWHPR07CA0005.namprd07.prod.outlook.com
 (2603:10b6:300:116::15) To BY5PR15MB3571.namprd15.prod.outlook.com
 (2603:10b6:a03:1f6::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:1212) by MWHPR07CA0005.namprd07.prod.outlook.com (2603:10b6:300:116::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16 via Frontend Transport; Thu, 15 Apr 2021 00:23:56 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 267f38a8-b8d8-4363-d5ce-08d8ffa4c24e
X-MS-TrafficTypeDiagnostic: BYAPR15MB2584:
X-Microsoft-Antispam-PRVS: <BYAPR15MB25841208110F2ADC7BA86BBBD54D9@BYAPR15MB2584.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TKInSc5xX6dUsFNNIuvjP3K4IMoyF03XAGbnNBhCnbCpOD7vvo5ljDNDviA6JKZsHD0vqD4cX9HPoJtlH/+DJyA/IqrY49Djcg/R8cttZT6lC91OaR2+DVkyXLNp2YY3niuMflyZziFHKUmBisUiEpFMLxIKVP6/UhFHO3pSdUx6wUclFTxRq3S15rq5JrkEnP9GgiESbfRIVAvpFSRPlpENNxi4aDAYZZj63gGk1Pn4PSK06/gyElsEDfP5OyubG7n8xpYHV9QNt9KC2GMe8sDHspx93vcPHs/KLtGuG3wegxoOvHUvr5O4ZqfAaf3pLldpiAEhfbAnc+IS9XtTzr16vldBE1ef8SEwJ0LcnavQgRH2WubJBYvIKKNqplBTjEp8XKOyw1KdjXbD2I2sCO5OZzmUsX2LMeUbRB6Ak8yvBze16QYX1Aub4iOEBsz+KvDlNcLznn4HWPibxN5GG+O0XwMvA5VnxakEskedOycNPQ0E0L2aJMwqmTxAOALcaY2b9Q8oqpPDbZVKBtJRSDPW8JzY9PHo2WEfcKzVhk4KUeX3stA4lqzCuutJfgPt+sEUv+GBGoCH1nLe18KNZSDCATe5Qvutv57EduAN/u8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(39860400002)(136003)(376002)(366004)(346002)(6916009)(66476007)(16526019)(66556008)(38100700002)(52116002)(54906003)(7696005)(186003)(55016002)(86362001)(5660300002)(83380400001)(8936002)(6506007)(8676002)(2906002)(478600001)(9686003)(6666004)(1076003)(7416002)(66946007)(4326008)(316002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?7gkpYED4abXunAdlovFOyasFWxQPG3z5tNyzd+QqR//bgBjE5ZzE5htJFcvf?=
 =?us-ascii?Q?G1jI8tkpAvrrYejDTo06ZbDLTgFaR3xFoVTeE0629NsIiVDZkRZBGjfdYbpt?=
 =?us-ascii?Q?FeqyA3WpRv90DnDcvTOIdlo8VlL2IfSki2asKhnhXZOBbmWTWEtpS+mj0Mp1?=
 =?us-ascii?Q?kTFogGaE+PYnytydhGmLMzndmUCMY1MDhbVpBzKL76u0leaXjH7K15LNHbWe?=
 =?us-ascii?Q?FIqZAWwXQJ7or5X7rCY1/A89kYEMdtjkLBPW56ptXRK11Xo5h7BJz1zhFuZB?=
 =?us-ascii?Q?1ww9VYMzkjD/TnSYqQGyKSpk40F1es5Z5YJApDrxb2CLkLUZEokLmL5i3xGM?=
 =?us-ascii?Q?8UswKBFu94wJjqgx+PTNSpZSgnDw2jWbli6R4YdabiSU8LWbsTwPDt/MI26/?=
 =?us-ascii?Q?QZzqLz3gmx7C60eFlKZKmwtNZPjWLSPqAxBF5bqTtJMegdniP4E1KfNxbWrp?=
 =?us-ascii?Q?ErwlSsk/okvBwPjecZnrdUT9MaurPUsDC6aY86oZFS0eV8POz8uqLtH48DX2?=
 =?us-ascii?Q?x+c4jo1U/n0m6+g3Xjqso5NW7Cj1m96fZtEr8QMlsdkQSTWHVTaerN8jtbou?=
 =?us-ascii?Q?nl7MhHwOEwgPOkPVON2p5tukcEUi3FgXZWoNA5+hKSWesmX1t1C7QDil4pNj?=
 =?us-ascii?Q?nF1iYNRHHHhW/j/wsKk5iE+YbrKG4m/absgNvh6ex0Ctd85HfiIGtaXGO6Ww?=
 =?us-ascii?Q?f6QbypIpmSwRhz2rim6WUY+gUnERhd3Grxz1SRgV5qrbyxmUPm7I9k8XJ48R?=
 =?us-ascii?Q?//5V8JjUUHHM9bVfJj9ioYcZvdvdCRsf2X+RPQosIddKhd6nWQPel86S81Pe?=
 =?us-ascii?Q?/ZY2Cj0W3Du9X6QwQ9M5qW6+wc2Cz8FMzjecL56jONGZnUPWlU+3B7deCflw?=
 =?us-ascii?Q?EfnbM1cqIQtT95YHmZat71QhyCLU1nk003A4Xc28Ok4iRz4K3gxed7BCecYo?=
 =?us-ascii?Q?TiTRzICeS5TH+jVm0IOMX9Bvf6mMhUwnepiyqMrefytctNggvPht2e/L0tUs?=
 =?us-ascii?Q?s3z0FKrDyGJ2VLx3fQNAnFmws+JorRtiHgG0mwYNf5886VTzHvYLZeLF84Vf?=
 =?us-ascii?Q?Dud9VYN9yofLBB1xAlzV47pcEZpmVXqk1rXaOuKlpzVp//KjYWDc1eoNngOi?=
 =?us-ascii?Q?4Rq9+7ywxVb84lQ9/DdW6iJWD7SMJqsmLdpzGaKH52TL1VA3BVynNFkW4MWa?=
 =?us-ascii?Q?vN3R2x49qvAKbROMZ4EnGOHquj9/3pyNrMeBLuGAY9I+nb4C3jl+F2mKOdXr?=
 =?us-ascii?Q?kX8+5YKk38GBUerajQ3BDBPld1o1iE8/h1OWOVZ6Gr4u3XQzSFGDv4Dm3cIO?=
 =?us-ascii?Q?O4ozZarxDlTWfIsF9WBZedz8XwzGCUqE16WWdEKzlTk12g=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 267f38a8-b8d8-4363-d5ce-08d8ffa4c24e
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB3571.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Apr 2021 00:23:57.4390
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0btwKoqPlbM+15Ox9n4OiK0sNc0AUynonE3dM4dOWAbH3dpo30ZoIMGkDuU4+eNs
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2584
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: C3xMJPGnFIIOAxctvMLwOp7NuGpBrDzP
X-Proofpoint-GUID: C3xMJPGnFIIOAxctvMLwOp7NuGpBrDzP
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-14_15:2021-04-14,2021-04-14 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 impostorscore=0
 lowpriorityscore=0 mlxlogscore=902 spamscore=0 phishscore=0
 priorityscore=1501 mlxscore=0 bulkscore=0 suspectscore=0 clxscore=1015
 malwarescore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2104060000 definitions=main-2104150000
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 14, 2021 at 08:26:08PM +0800, Hangbin Liu wrote:
[ ... ]

> +static __always_inline int __bpf_xdp_redirect_map(struct bpf_map *map, u32 ifindex,
> +						  u64 flags, u64 flag_mask,
>  						  void *lookup_elem(struct bpf_map *map, u32 key))
>  {
>  	struct bpf_redirect_info *ri = this_cpu_ptr(&bpf_redirect_info);
>  
>  	/* Lower bits of the flags are used as return code on lookup failure */
> -	if (unlikely(flags > XDP_TX))
> +	if (unlikely(flags & ~(BPF_F_ACTION_MASK | flag_mask)))
>  		return XDP_ABORTED;
>  
>  	ri->tgt_value = lookup_elem(map, ifindex);
> -	if (unlikely(!ri->tgt_value)) {
> +	if (unlikely(!ri->tgt_value) && !(flags & BPF_F_BROADCAST)) {
>  		/* If the lookup fails we want to clear out the state in the
>  		 * redirect_info struct completely, so that if an eBPF program
>  		 * performs multiple lookups, the last one always takes
> @@ -1482,13 +1484,21 @@ static __always_inline int __bpf_xdp_redirect_map(struct bpf_map *map, u32 ifind
>  		 */
>  		ri->map_id = INT_MAX; /* Valid map id idr range: [1,INT_MAX[ */
>  		ri->map_type = BPF_MAP_TYPE_UNSPEC;
> -		return flags;
> +		return flags & BPF_F_ACTION_MASK;
>  	}
>  
>  	ri->tgt_index = ifindex;
>  	ri->map_id = map->id;
>  	ri->map_type = map->map_type;
>  
> +	if (flags & BPF_F_BROADCAST) {
> +		WRITE_ONCE(ri->map, map);
Why only WRITE_ONCE on ri->map?  Is it needed?

> +		ri->flags = flags;
> +	} else {
> +		WRITE_ONCE(ri->map, NULL);
> +		ri->flags = 0;
> +	}
> +
>  	return XDP_REDIRECT;
>  }
>  
[ ... ]

> +int dev_map_enqueue_multi(struct xdp_buff *xdp, struct net_device *dev_rx,
> +			  struct bpf_map *map, bool exclude_ingress)
> +{
> +	struct bpf_dtab *dtab = container_of(map, struct bpf_dtab, map);
> +	int exclude_ifindex = exclude_ingress ? dev_rx->ifindex : 0;
> +	struct bpf_dtab_netdev *dst, *last_dst = NULL;
> +	struct hlist_head *head;
> +	struct hlist_node *next;
> +	struct xdp_frame *xdpf;
> +	unsigned int i;
> +	int err;
> +
> +	xdpf = xdp_convert_buff_to_frame(xdp);
> +	if (unlikely(!xdpf))
> +		return -EOVERFLOW;
> +
> +	if (map->map_type == BPF_MAP_TYPE_DEVMAP) {
> +		for (i = 0; i < map->max_entries; i++) {
> +			dst = READ_ONCE(dtab->netdev_map[i]);
> +			if (!is_valid_dst(dst, xdp, exclude_ifindex))
> +				continue;
> +
> +			/* we only need n-1 clones; last_dst enqueued below */
> +			if (!last_dst) {
> +				last_dst = dst;
> +				continue;
> +			}
> +
> +			err = dev_map_enqueue_clone(last_dst, dev_rx, xdpf);
> +			if (err)
> +				return err;
> +
> +			last_dst = dst;
> +		}
> +	} else { /* BPF_MAP_TYPE_DEVMAP_HASH */
> +		for (i = 0; i < dtab->n_buckets; i++) {
> +			head = dev_map_index_hash(dtab, i);
> +			hlist_for_each_entry_safe(dst, next, head, index_hlist) {
hmm.... should it be hlist_for_each_entry_rcu() instead?

> +				if (!is_valid_dst(dst, xdp, exclude_ifindex))
> +					continue;
> +
> +				/* we only need n-1 clones; last_dst enqueued below */
> +				if (!last_dst) {
> +					last_dst = dst;
> +					continue;
> +				}
> +
> +				err = dev_map_enqueue_clone(last_dst, dev_rx, xdpf);
> +				if (err)
> +					return err;
> +
> +				last_dst = dst;
> +			}
> +		}
> +	}
> +
> +	/* consume the last copy of the frame */
> +	if (last_dst)
> +		bq_enqueue(last_dst->dev, xdpf, dev_rx, last_dst->xdp_prog);
> +	else
> +		xdp_return_frame_rx_napi(xdpf); /* dtab is empty */
> +
> +	return 0;
> +}
> +

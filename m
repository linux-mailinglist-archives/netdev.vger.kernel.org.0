Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA80036112A
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 19:36:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234172AbhDORgk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 13:36:40 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:26916 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233395AbhDORgj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Apr 2021 13:36:39 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13FHT7Hb030781;
        Thu, 15 Apr 2021 10:35:59 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type :
 content-transfer-encoding : in-reply-to : mime-version; s=facebook;
 bh=BYrEi6cC3UwsTnMtdtSh8Eq+rSKrzgRmCqWNV5mXpbc=;
 b=eWIjET+KjRfmk6f76PdK1j8dX9BWXlQq50mNpxu5YdDD0RJrV9jDfQEOjJqSTef/F8pK
 YKIryt16jpDmpRFhrKdgezkkCBFHAFzkYvqVawi2DjdAhDBCLl4fSochVJ3oeuz6AJGZ
 gZH8DxsJsJXGjAqGH4EKDmgtXmwrd/+Y9WQ= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 37xesqkesx-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 15 Apr 2021 10:35:58 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.199) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 15 Apr 2021 10:35:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h/JiDWKmVTQMDYhADUEzGj847GD6oAIG3KA1yhA1w3HUvAHoBDN6oiMOjHCWe0TjH0Zr4NI/rcAjT7aigy9DRUTeBbGLwMR8wPBoQ8HfOx6SKhvggXIgbzTKE38bE2SqOqTzdRic09E3DXkBCCJ81P2o3aPWaMwZR54x0YvD68I/5N00ImxZ18su+7oMecM6G6vPQ9T3WhABi6HUpVyjqqtxhhsPe/1fZAAQ9tNOK/trVfaAHl2chQpx3xI6yCWS93YOzcHOVi8DSIxnH5ggBQLGmzu26RA7fzvlp+2EuWsYUcwg0JujOfGh/IDjJeQxNn8HOwK0FNPnplbwABE9XQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z8n25o+kWXiHRfKIHcNBmlbVqa0ILkK/hAqz8K0dWHA=;
 b=Yh1eC1YQs1I0n3H3j132Otx5e8Uq/ElooN5wXQRQDiqbMSEQwOM0/njFhwggMqj/baEWZCzcCxjlpGG1E0VfcTNVPYPDtf28YeFnVh+wEo20G5oXg3F18r6iMgResf+8QFiGo8QMuD0nIwiFSpMyn0Ayntvi+vkANvuGOv0HSPNBMZ4tdNNqQbL/6gZKqzKo3zCZeiyDFnnwmSD5CLM3Kk0voTzP6HQxmA/Ov5K7bPAtz7GW+stHpFk3rdA7ZIca+rBpz+DLE9B8mW9SJptsXIARrf8Y/varHd60aywU3rMiZOsJiYasNnRLsrrFojL3DGnIPJiNk0IA6NLUkrcOGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=fb.com;
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by SJ0PR15MB4486.namprd15.prod.outlook.com (2603:10b6:a03:373::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16; Thu, 15 Apr
 2021 17:35:55 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::718a:4142:4c92:732f]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::718a:4142:4c92:732f%6]) with mapi id 15.20.4020.023; Thu, 15 Apr 2021
 17:35:54 +0000
Date:   Thu, 15 Apr 2021 10:35:51 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
CC:     Hangbin Liu <liuhangbin@gmail.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, Jiri Benc <jbenc@redhat.com>,
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
Message-ID: <20210415173551.7ma4slcbqeyiba2r@kafai-mbp.dhcp.thefacebook.com>
References: <20210414122610.4037085-1-liuhangbin@gmail.com>
 <20210414122610.4037085-2-liuhangbin@gmail.com>
 <20210415001711.dpbt2lej75ry6v7a@kafai-mbp.dhcp.thefacebook.com>
 <20210415023746.GR2900@Leo-laptop-t470s>
 <87o8efkilw.fsf@toke.dk>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87o8efkilw.fsf@toke.dk>
X-Originating-IP: [2620:10d:c090:400::5:ed4e]
X-ClientProxiedBy: CO2PR05CA0078.namprd05.prod.outlook.com
 (2603:10b6:102:2::46) To BY5PR15MB3571.namprd15.prod.outlook.com
 (2603:10b6:a03:1f6::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:ed4e) by CO2PR05CA0078.namprd05.prod.outlook.com (2603:10b6:102:2::46) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.6 via Frontend Transport; Thu, 15 Apr 2021 17:35:53 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ddba799f-ffd1-4e47-c705-08d90034ebfc
X-MS-TrafficTypeDiagnostic: SJ0PR15MB4486:
X-Microsoft-Antispam-PRVS: <SJ0PR15MB4486183505EB593D94AD6BDBD54D9@SJ0PR15MB4486.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 49eD3EyUUz7IzIDKvN60KBq+UjD2iw8YkqYsfiXSj0B/QGmvwo/sLTm+22R5ov20/7BQ+beXBylVIqMhjYMa0HNx0hQMsF3fhsB5XFgHHLvxUMQ5Afo5eQKX+0BAHV9GWNnPJZiG22TLxX5oQBTtEaUiQ+AL3lsTnAD6c/MyPp9JSfWwOHZM1yFcd4jqXeD2pTFibaO9Sig7qPASU4r2LmvGejhMxfqgTRUI58o1fuO6EIabg9nCOr0UqHjSkQ1Ke1U/+mV+JIYMrQt0sPhGB75yhzE4Rc5oqHsPMDhz1gWlBQbVoCDqTW5Oiyco3G/EmHv7fBXBe8cvnW4V9E2RmKIUtaJbfrCw0ZJPTFc0OwlA012N6LiPZUsA8AtLRRF3h3zryvXiApHu7H0ZbMkywjb8a95dBEcLGT9IjuQ3OpZgKdjG11XUuivWC8X55uXPXtcmkS0CRQdZIb1cfOlg2EsHMFF8gp5F19h2kjvAHtZy6j4iv5lCxlXQ6vZiAGvhEqVoLQoBgv0P9zsnjt7pR3Wa9ig1kbIFTzi24O8mmd+3nFUHmS0CoAju2V9H7HenYUrkv9xqeVAlOsWCls37a2Sl+skVFWUOWMjg4jmLyU8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(366004)(39860400002)(136003)(346002)(396003)(16526019)(478600001)(186003)(6506007)(1076003)(54906003)(5660300002)(66574015)(83380400001)(7416002)(38100700002)(4326008)(86362001)(6916009)(66946007)(66476007)(316002)(2906002)(7696005)(9686003)(52116002)(55016002)(8936002)(8676002)(66556008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?iso-8859-1?Q?dMfAahV75aRVN1f2fYIbkW2h+GZxQH0VVqXY9GgmqlCotDkcvgTT9yXZit?=
 =?iso-8859-1?Q?aYgZeMqpyovAmEjnsAOf9Rrq9hsh66bxu8JBhZlY1ry1tHGwUfgPmOQ33q?=
 =?iso-8859-1?Q?r5i7JlwC9a66LMkJqxSUHBJPse8UNzC9atnVmLMYCe0hVXeUHoF2UumkLe?=
 =?iso-8859-1?Q?tEyWFw+kcRgJlP719suPp2nwp9vQB2aJ3rNWLKzEN0gIzb1gMNG3eoWo7/?=
 =?iso-8859-1?Q?EmdGBbRjLV0igyqQm1d45ls/X/FjA2dP76st7whb3LN9NscMStYgllzvZq?=
 =?iso-8859-1?Q?YVyNH5gPHM6v5NbiWlpoYJqTX99ie0fOCHVLXHZGBr8J6/zV9Kt3NjaPin?=
 =?iso-8859-1?Q?dH7yLmHgmzS90u6MP4dS5qWgtzI2Tn4BRq09Kkdd00uCvYNC2umR5nPT5T?=
 =?iso-8859-1?Q?bUFugwgbv+G0TjKQT7cHD3Bk8NTDiqFPSx3Xys62pFHxejBfGjeqBeVaUU?=
 =?iso-8859-1?Q?wNQs/uwInEae4Bg6Mzd5alFWWcDzegfmHh1++CHCUdYWYe52b6Ge3+OBzT?=
 =?iso-8859-1?Q?sO14cChUpnnraeVNdVJjF1H0BUbzQdJhF0RSxHNwLXDpuNcxXTBiUOxJJB?=
 =?iso-8859-1?Q?7b/hJxCOngsp7aTzse25nxRAbL+b3HP0Da4Y973Toj48HInzbdS6BKmifz?=
 =?iso-8859-1?Q?pzrvGqJkVhLkjeoEhn/q5M3FjDLfcp5EkzF5SsTcXo8YUtPKCyo5PJGJ0R?=
 =?iso-8859-1?Q?NskU/FSMUT9sCkLp7DH6utmXzyMEChbfEh0hCc5k290BfFUYGVpzS3Kk1z?=
 =?iso-8859-1?Q?p+BBVReiUBVByB05qY+IzGpKoGPWEnzZ4h1yKJABkuPL5nstXTfWErE/Fn?=
 =?iso-8859-1?Q?UgeBs6GgaYYK5jHpe6YSwkuTmoikr1Bl2VcqNhkeEfiwBwozFpJj3kK1OE?=
 =?iso-8859-1?Q?qT0H9zbYibYY5O19HD3M0n4/L9YpLluYIGFVW/4tKn49qq0d2+rIuHvkx+?=
 =?iso-8859-1?Q?B4LdSQKMvJ/3ArHrFMRzZLYPIXcAPKdW7Jme7tmZM+SqPgfsdnSxhTXKHv?=
 =?iso-8859-1?Q?7AAfx3sPCYTElWSn4/vjXy2wKjEU3kvef5DQ6GG9voaZSoiF6JcuMN9iBU?=
 =?iso-8859-1?Q?ng6dc/LcwACVqmG/AA0OkNC5tIciOKp5xPS/D+89MSkW4W8aVeBteignVP?=
 =?iso-8859-1?Q?+7iYTdnLjM+MU0+XwtDVBjLGXcghxTzFh3upocbPGVjdb6ftR1YH6/CFN4?=
 =?iso-8859-1?Q?RUwAShPF16YGblI4MyWrxCc7i1riyQgclRAvie2tSXBXUpyLH+JOh6Nnp7?=
 =?iso-8859-1?Q?hOkpOFeEsgHETNI25JuJEp7RhbiGU5TIbWzfJxzL5J6xfedk/p2lGLv2hi?=
 =?iso-8859-1?Q?/3SkkQRPBSd4t62ULPG/XvU6eh7YyCYEnTGplhCAKCuyOfi6kLBg94qu6u?=
 =?iso-8859-1?Q?sGfm0JIViT8kZn1syf4D68YA+C6lzF9Q=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ddba799f-ffd1-4e47-c705-08d90034ebfc
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB3571.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Apr 2021 17:35:54.9475
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qu77bsQTY+C5sCBLXH2g2S8gGaxjwVJcBe7pxS3y4mqAI+hYIC7eX5SIJpVH3npA
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR15MB4486
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: aK9NNkLhg04M_qLZRI0cuoCyUKu0m--c
X-Proofpoint-ORIG-GUID: aK9NNkLhg04M_qLZRI0cuoCyUKu0m--c
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-15_09:2021-04-15,2021-04-15 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015
 priorityscore=1501 suspectscore=0 bulkscore=0 malwarescore=0 spamscore=0
 impostorscore=0 mlxscore=0 adultscore=0 mlxlogscore=922 phishscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104150108
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 15, 2021 at 11:22:19AM +0200, Toke Høiland-Jørgensen wrote:
> Hangbin Liu <liuhangbin@gmail.com> writes:
> 
> > On Wed, Apr 14, 2021 at 05:17:11PM -0700, Martin KaFai Lau wrote:
> >> >  static void bq_xmit_all(struct xdp_dev_bulk_queue *bq, u32 flags)
> >> >  {
> >> >  	struct net_device *dev = bq->dev;
> >> > -	int sent = 0, err = 0;
> >> > +	int sent = 0, drops = 0, err = 0;
> >> > +	unsigned int cnt = bq->count;
> >> > +	int to_send = cnt;
> >> >  	int i;
> >> >  
> >> > -	if (unlikely(!bq->count))
> >> > +	if (unlikely(!cnt))
> >> >  		return;
> >> >  
> >> > -	for (i = 0; i < bq->count; i++) {
> >> > +	for (i = 0; i < cnt; i++) {
> >> >  		struct xdp_frame *xdpf = bq->q[i];
> >> >  
> >> >  		prefetch(xdpf);
> >> >  	}
> >> >  
> >> > -	sent = dev->netdev_ops->ndo_xdp_xmit(dev, bq->count, bq->q, flags);
> >> > +	if (bq->xdp_prog) {
> >> bq->xdp_prog is used here
> >> 
> >> > +		to_send = dev_map_bpf_prog_run(bq->xdp_prog, bq->q, cnt, dev);
> >> > +		if (!to_send)
> >> > +			goto out;
> >> > +
> >> > +		drops = cnt - to_send;
> >> > +	}
> >> > +
> >> 
> >> [ ... ]
> >> 
> >> >  static void bq_enqueue(struct net_device *dev, struct xdp_frame *xdpf,
> >> > -		       struct net_device *dev_rx)
> >> > +		       struct net_device *dev_rx, struct bpf_prog *xdp_prog)
> >> >  {
> >> >  	struct list_head *flush_list = this_cpu_ptr(&dev_flush_list);
> >> >  	struct xdp_dev_bulk_queue *bq = this_cpu_ptr(dev->xdp_bulkq);
> >> > @@ -412,18 +466,22 @@ static void bq_enqueue(struct net_device *dev, struct xdp_frame *xdpf,
> >> >  	/* Ingress dev_rx will be the same for all xdp_frame's in
> >> >  	 * bulk_queue, because bq stored per-CPU and must be flushed
> >> >  	 * from net_device drivers NAPI func end.
> >> > +	 *
> >> > +	 * Do the same with xdp_prog and flush_list since these fields
> >> > +	 * are only ever modified together.
> >> >  	 */
> >> > -	if (!bq->dev_rx)
> >> > +	if (!bq->dev_rx) {
> >> >  		bq->dev_rx = dev_rx;
> >> > +		bq->xdp_prog = xdp_prog;
> >> bp->xdp_prog is assigned here and could be used later in bq_xmit_all().
> >> How is bq->xdp_prog protected? Are they all under one rcu_read_lock()?
> >> It is not very obvious after taking a quick look at xdp_do_flush[_map].
> >> 
> >> e.g. what if the devmap elem gets deleted.
> >
> > Jesper knows better than me. From my veiw, based on the description of
> > __dev_flush():
> >
> > On devmap tear down we ensure the flush list is empty before completing to
> > ensure all flush operations have completed. When drivers update the bpf
> > program they may need to ensure any flush ops are also complete.
AFAICT, the bq->xdp_prog is not from the dev. It is from a devmap's elem.

> 
> Yeah, drivers call xdp_do_flush() before exiting their NAPI poll loop,
> which also runs under one big rcu_read_lock(). So the storage in the
> bulk queue is quite temporary, it's just used for bulking to increase
> performance :)
I am missing the one big rcu_read_lock() part.  For example, in i40e_txrx.c,
i40e_run_xdp() has its own rcu_read_lock/unlock().  dst->xdp_prog used to run
in i40e_run_xdp() and it is fine.

In this patch, dst->xdp_prog is run outside of i40e_run_xdp() where the
rcu_read_unlock() has already done.  It is now run in xdp_do_flush_map().
or I missed the big rcu_read_lock() in i40e_napi_poll()?

I do see the big rcu_read_lock() in mlx5e_napi_poll().

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0E8C3627A5
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 20:23:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237130AbhDPSXn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Apr 2021 14:23:43 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:2350 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235122AbhDPSXm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Apr 2021 14:23:42 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13GIABBe004612;
        Fri, 16 Apr 2021 11:23:00 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 content-transfer-encoding : mime-version; s=facebook;
 bh=Shv8qodD3lIH9fTlgbky08HJXq1ZGAOFgOUBhV3ki/A=;
 b=WSHaX6D3FkbIO6OeI47Tra4Y6RIJz3/7aMz/6h4rkrcwzHeYEijK1spkdqDe5a7txkIl
 UNLl45fCvQzo28IcNjHQOCU8MvtktA/QMsbBQrWTVBQxjNWbsnE7byD+Hf+HBDEyOE2A
 z0x5WcOdrc22DIGaJX7zRrcMx92UmzJIDFY= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 37yb5j1tjf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 16 Apr 2021 11:22:59 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.230) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 16 Apr 2021 11:22:58 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RJ+zNAAUCUnbKr+zxObCyUl2YvMR6stghFs/Y/S2shGeqif9R7kBjo36EsptE3cg0sEPqX8ECnul9Wv2juvbDPDXNw55Mo0MarYlPHmGvxmDFgdRl6yZAKnu6JFLOHUPRj5WY0x2q0wW9qyyywMom27q0QfTGzYEFs7q++jJbvBrJ9f5JWC1aPMXUOPgPok4XawvDWtuacJgTdfuC2xsrFk6JN4nbr/1UApj82Hhjxd65Z4gc31Geim56Ls7UQODBRk5wCJR0ICBMUa3dAbGksd0fc/G+Tr9GODnNjF8tq6V1VD6iFpyC6TcDkK3eibb/zjR+dtRfpZS4LyYV9JAUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MH8yXDZuUavTZA5flcdLowZXtnlpwSKVgjhWSlfU8tA=;
 b=MeMyQmECDbGhHqljISW2UmSfBk4RKH6lS+LyToGpxEtpQ8OHwyBf/DGKe1XGwcQPJ7Z0FLbrl0bAjy0VTslIIaXriatrr2xZYEC2mea3NuXfVTjDLYKgKFFaiJZj+BDRd+6HHIqbxINpe5BzU+CTDtEjzNG2jbsGJSEA/PYTSHFTxvNQ2WphTUxw+s6ToK++WC7F+wZsnqJFrfMyrpRX2+ryrSrfmri1ruWHVfWinGO0zO1XzOv8Ho1i+Gm5u8zMTgJYhFJkbBWRrTr3yx6eL6zeqm2Qnr18ZFjR29jbzswXsEfJijnbADowqh/KY7bqQFJM7DZaaSDguTxbVbNfhQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=fb.com;
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by BYAPR15MB3416.namprd15.prod.outlook.com (2603:10b6:a03:110::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.22; Fri, 16 Apr
 2021 18:22:57 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::718a:4142:4c92:732f]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::718a:4142:4c92:732f%6]) with mapi id 15.20.4042.019; Fri, 16 Apr 2021
 18:22:57 +0000
Date:   Fri, 16 Apr 2021 11:22:52 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
CC:     Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Hangbin Liu <liuhangbin@gmail.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, Jiri Benc <jbenc@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>, <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        "Paul E. McKenney" <paulmck@kernel.org>
Subject: Re: [PATCHv7 bpf-next 1/4] bpf: run devmap xdp_prog on flush instead
 of bulk enqueue
Message-ID: <20210416182252.c25akwj6zjdvo7u2@kafai-mbp.dhcp.thefacebook.com>
References: <20210414122610.4037085-1-liuhangbin@gmail.com>
 <20210414122610.4037085-2-liuhangbin@gmail.com>
 <20210415001711.dpbt2lej75ry6v7a@kafai-mbp.dhcp.thefacebook.com>
 <20210415023746.GR2900@Leo-laptop-t470s>
 <87o8efkilw.fsf@toke.dk>
 <20210415173551.7ma4slcbqeyiba2r@kafai-mbp.dhcp.thefacebook.com>
 <20210415202132.7b5e8d0d@carbon>
 <87k0p3i957.fsf@toke.dk>
 <20210416003913.azcjk4fqxs7gag3m@kafai-mbp.dhcp.thefacebook.com>
 <20210416154523.3b1fe700@carbon>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <20210416154523.3b1fe700@carbon>
X-Originating-IP: [2620:10d:c090:400::5:d4d1]
X-ClientProxiedBy: MWHPR14CA0039.namprd14.prod.outlook.com
 (2603:10b6:300:12b::25) To BY5PR15MB3571.namprd15.prod.outlook.com
 (2603:10b6:a03:1f6::32)
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:d4d1) by MWHPR14CA0039.namprd14.prod.outlook.com (2603:10b6:300:12b::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.19 via Frontend Transport; Fri, 16 Apr 2021 18:22:56 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2b92418c-f814-434b-16b3-08d90104a8f4
X-MS-TrafficTypeDiagnostic: BYAPR15MB3416:
X-Microsoft-Antispam-PRVS: <BYAPR15MB341620C539C858CF834CCC41D54C9@BYAPR15MB3416.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EL7rxRxf/FJrUvVkgkvQyEM1+RCYmooIJk8oro2MStHOxE3+a6u3pFV/TTieCBIQxaDSJuuYHL+VZixT9/CH960atishzSxNZxmGEvLWAO0L4v6mjIEy2Th4D2cQNgCd2eCHeTUK4QfvxQFZQdUenFYiBpK4DNMvBRV2J5f/IyfKoLQHQyuxFTM8vnXo+9ZwzcI5MnJljFs9ZyjLx44co5LIiJolIdAcEqucUfFaoBCsZb71HNsECrpg+/xbJKziby5uxk+ktEZGJmk9GWkGKTR64Dow4BZVfD/hbqWR7YB8H2a9ESHR80uD0AGoUDagv5MPHBiEYxIGgwYNOvfOy5ZtRSmWyNwiVa8H97ZHdHlfodKh4VH6Pt73GiSxqraZGrmxwrrCYpza0RWJNOoG2zTniLOm+7yVZeDr2O4Zo4R+lGIV5nMVMEIuxBoTjX+0SQ9oQS/mKyrlhnPyA199nuPo9Pm4Rw4cHMFqbZ4g+hdPeGtHeHWeXs92DwRnScUsbDvxXMgwiqzZX8USpMNvuQrZsngqhc10qj4U6MmD64py2RcNYSvPyALFBzG9SXx+Y+3PIwdmF00d2RjSeqkl/GMO6vCrho6m3XCaSokIRrVSmZ9mLtwh8eAnWwH2iusPAHQQ88TSX0ne8TBJ2yTuAO2gbduXT6bhyv1zx84AfzfuesolHIk7h6TkLKhUznHY
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(39860400002)(346002)(136003)(366004)(396003)(6506007)(2906002)(38100700002)(54906003)(8676002)(66574015)(478600001)(66946007)(83380400001)(16526019)(4326008)(6666004)(1076003)(316002)(52116002)(45080400002)(186003)(7696005)(66476007)(966005)(5660300002)(55016002)(86362001)(66556008)(6916009)(8936002)(7416002)(9686003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?iso-8859-1?Q?6R6P6TukkI0EKSdj1dKfYbs3lNe6qJNqOCQ8WQEZGMm7/l44hP4qQFVGVk?=
 =?iso-8859-1?Q?TpbgUedvh2HD5yfFcQp3FnrAZzsaCEYL5Kro9Zzb8oGinkb13D1FhgMG1P?=
 =?iso-8859-1?Q?/Oh/yOUT/uGNkiVXaPSFy+2Ncql6vtipm//hkiNt5pkDBs9EHgJG9hHXyR?=
 =?iso-8859-1?Q?iQbpgV1LEIeBdELUuMnEd7ErzGI0ZUxKjRF71tuGIY7v9uykCUhFv9ASE9?=
 =?iso-8859-1?Q?2wMm0kktqaChVtehZTXEnihF3Q5bTro6Tz3QwYHBWEbtHTxbZjafV1Y1yB?=
 =?iso-8859-1?Q?h0APG3sWZU+qwyQMhC2Vn6cnKxQsyREwJNBZjkz4X1WMK+xC1AO+AvwrkN?=
 =?iso-8859-1?Q?S5TU+f6C014+L/1fBWShzeERzn0pNMN+B1iNY7SIkiWbHNasN5IfOkkGB1?=
 =?iso-8859-1?Q?wJkfMc0FeRksXU63xM5qQ5uF2VjLqp4NcMlVow5WFU4pwQK01Pqjvp4AaI?=
 =?iso-8859-1?Q?KX3M1KHO9RVwf0gvu+qJ/kdwblUAMvGSFTd3xtnzhXPTH0GiVgol9r8EKr?=
 =?iso-8859-1?Q?0r5Pk+dPvTi43gdDhyD1CNuEmMsPgMfEyJ1/ls89ay5r2D1C/CkaNpY0Qz?=
 =?iso-8859-1?Q?AlO8GtRZl/5wCJpGtAoETG/xbHpYaSRlN9M24so+bHgeAFUFjaeWBThrFp?=
 =?iso-8859-1?Q?SiF2eShkEaDGtuJ3dLQnuNZpWCil8IQM9gpM3fEvBlHFPZBvoZmtDKtL+h?=
 =?iso-8859-1?Q?btKCKGFfqmr7LXmIxBxLRAoDWFbgvP3K6MwJ5Si9wBXgrhwq2J/9PVZD3Q?=
 =?iso-8859-1?Q?/2xj/ppLrtQ4iN3njwzceQaTtxYLiEIuYlBJPCncFt5rUJmOChTWMH/vt+?=
 =?iso-8859-1?Q?Qo4BKsTiCQz5KSTWZCJ+rPZZSFygTy0W+CPnRVGVJK5577Aug6RxBjw1C4?=
 =?iso-8859-1?Q?91bV7VN/5WSV6CSFEwhraCL1he7X/hqUphnRWhhWaRQkM1uhDQQ4GIUDcu?=
 =?iso-8859-1?Q?zS/5inN3bE8wqdvceJb4B/kTb23etklUzoz1vIvplhzLLNzukCgGxnmaCN?=
 =?iso-8859-1?Q?CXnXClZu3EvOd9XIGcbL/GnA+3d9Vi5XewdlEQwsiq9fDw+GRUlLot7Iq/?=
 =?iso-8859-1?Q?QW8vczJzLZBCRDiyhk1z8y16ML3+WV1TwUy+qqBfk+tBB9qnhh6+Pex+Tl?=
 =?iso-8859-1?Q?72dTwytas8rkf0zLUjiSWVXpQJ+RDr1CVuDSkvF7qRfklceyBv+A7yLPNu?=
 =?iso-8859-1?Q?biOy8XjTxGycY4kFmKOGHduoXLKe/z6TcW5XtQHZ5aJyqyAlApQ/gXUQpg?=
 =?iso-8859-1?Q?lduSjxaPAYpaEytynT7I42gFIwrxOx7jzx0LuUMaglDpiP8m7TA5tLQyLe?=
 =?iso-8859-1?Q?bHWbopcu9sBKxyO/1XcH2evvpZ5Udor8QZIgAGICymtIt00W/tc0hv9sLE?=
 =?iso-8859-1?Q?lWvhhfVGRdYFi2ovK3gieiw3wyeHhNhQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b92418c-f814-434b-16b3-08d90104a8f4
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB3571.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Apr 2021 18:22:57.7840
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BgD61lrKxoQMYuh0TWO8Wv2LC9UKs+AKlete5vpN65VEONYViEvSEJMSm3YWvUO4
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3416
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: UGFQjn9eIVL9_LtB6PqfE6pu2sMP9W_Q
X-Proofpoint-ORIG-GUID: UGFQjn9eIVL9_LtB6PqfE6pu2sMP9W_Q
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 1 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-16_09:2021-04-16,2021-04-16 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015
 phishscore=0 priorityscore=1501 mlxlogscore=999 spamscore=0 bulkscore=0
 lowpriorityscore=0 impostorscore=0 adultscore=0 suspectscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104160130
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 16, 2021 at 03:45:23PM +0200, Jesper Dangaard Brouer wrote:
> On Thu, 15 Apr 2021 17:39:13 -0700
> Martin KaFai Lau <kafai@fb.com> wrote:
> 
> > On Thu, Apr 15, 2021 at 10:29:40PM +0200, Toke Høiland-Jørgensen wrote:
> > > Jesper Dangaard Brouer <brouer@redhat.com> writes:
> > >   
> > > > On Thu, 15 Apr 2021 10:35:51 -0700
> > > > Martin KaFai Lau <kafai@fb.com> wrote:
> > > >  
> > > >> On Thu, Apr 15, 2021 at 11:22:19AM +0200, Toke Høiland-Jørgensen wrote:  
> > > >> > Hangbin Liu <liuhangbin@gmail.com> writes:
> > > >> >     
> > > >> > > On Wed, Apr 14, 2021 at 05:17:11PM -0700, Martin KaFai Lau wrote:    
> > > >> > >> >  static void bq_xmit_all(struct xdp_dev_bulk_queue *bq, u32 flags)
> > > >> > >> >  {
> > > >> > >> >  	struct net_device *dev = bq->dev;
> > > >> > >> > -	int sent = 0, err = 0;
> > > >> > >> > +	int sent = 0, drops = 0, err = 0;
> > > >> > >> > +	unsigned int cnt = bq->count;
> > > >> > >> > +	int to_send = cnt;
> > > >> > >> >  	int i;
> > > >> > >> >  
> > > >> > >> > -	if (unlikely(!bq->count))
> > > >> > >> > +	if (unlikely(!cnt))
> > > >> > >> >  		return;
> > > >> > >> >  
> > > >> > >> > -	for (i = 0; i < bq->count; i++) {
> > > >> > >> > +	for (i = 0; i < cnt; i++) {
> > > >> > >> >  		struct xdp_frame *xdpf = bq->q[i];
> > > >> > >> >  
> > > >> > >> >  		prefetch(xdpf);
> > > >> > >> >  	}
> > > >> > >> >  
> > > >> > >> > -	sent = dev->netdev_ops->ndo_xdp_xmit(dev, bq->count, bq->q, flags);
> > > >> > >> > +	if (bq->xdp_prog) {    
> > > >> > >> bq->xdp_prog is used here
> > > >> > >>     
> > > >> > >> > +		to_send = dev_map_bpf_prog_run(bq->xdp_prog, bq->q, cnt, dev);
> > > >> > >> > +		if (!to_send)
> > > >> > >> > +			goto out;
> > > >> > >> > +
> > > >> > >> > +		drops = cnt - to_send;
> > > >> > >> > +	}
> > > >> > >> > +    
> > > >> > >> 
> > > >> > >> [ ... ]
> > > >> > >>     
> > > >> > >> >  static void bq_enqueue(struct net_device *dev, struct xdp_frame *xdpf,
> > > >> > >> > -		       struct net_device *dev_rx)
> > > >> > >> > +		       struct net_device *dev_rx, struct bpf_prog *xdp_prog)
> > > >> > >> >  {
> > > >> > >> >  	struct list_head *flush_list = this_cpu_ptr(&dev_flush_list);
> > > >> > >> >  	struct xdp_dev_bulk_queue *bq = this_cpu_ptr(dev->xdp_bulkq);
> > > >> > >> > @@ -412,18 +466,22 @@ static void bq_enqueue(struct net_device *dev, struct xdp_frame *xdpf,
> > > >> > >> >  	/* Ingress dev_rx will be the same for all xdp_frame's in
> > > >> > >> >  	 * bulk_queue, because bq stored per-CPU and must be flushed
> > > >> > >> >  	 * from net_device drivers NAPI func end.
> > > >> > >> > +	 *
> > > >> > >> > +	 * Do the same with xdp_prog and flush_list since these fields
> > > >> > >> > +	 * are only ever modified together.
> > > >> > >> >  	 */
> > > >> > >> > -	if (!bq->dev_rx)
> > > >> > >> > +	if (!bq->dev_rx) {
> > > >> > >> >  		bq->dev_rx = dev_rx;
> > > >> > >> > +		bq->xdp_prog = xdp_prog;    
> > > >> > >> bp->xdp_prog is assigned here and could be used later in bq_xmit_all().
> > > >> > >> How is bq->xdp_prog protected? Are they all under one rcu_read_lock()?
> > > >> > >> It is not very obvious after taking a quick look at xdp_do_flush[_map].
> > > >> > >> 
> > > >> > >> e.g. what if the devmap elem gets deleted.    
> > > >> > >
> > > >> > > Jesper knows better than me. From my veiw, based on the description of
> > > >> > > __dev_flush():
> > > >> > >
> > > >> > > On devmap tear down we ensure the flush list is empty before completing to
> > > >> > > ensure all flush operations have completed. When drivers update the bpf
> > > >> > > program they may need to ensure any flush ops are also complete.    
> > > >>
> > > >> AFAICT, the bq->xdp_prog is not from the dev. It is from a devmap's elem.
> 
> The bq->xdp_prog comes form the devmap "dev" element, and it is stored
> in temporarily in the "bq" structure that is only valid for this
> softirq NAPI-cycle.  I'm slightly worried that we copied this pointer
> the the xdp_prog here, more below (and Q for Paul).
> 
> > > >> > 
> > > >> > Yeah, drivers call xdp_do_flush() before exiting their NAPI poll loop,
> > > >> > which also runs under one big rcu_read_lock(). So the storage in the
> > > >> > bulk queue is quite temporary, it's just used for bulking to increase
> > > >> > performance :)    
> > > >>
> > > >> I am missing the one big rcu_read_lock() part.  For example, in i40e_txrx.c,
> > > >> i40e_run_xdp() has its own rcu_read_lock/unlock().  dst->xdp_prog used to run
> > > >> in i40e_run_xdp() and it is fine.
> > > >> 
> > > >> In this patch, dst->xdp_prog is run outside of i40e_run_xdp() where the
> > > >> rcu_read_unlock() has already done.  It is now run in xdp_do_flush_map().
> > > >> or I missed the big rcu_read_lock() in i40e_napi_poll()?
> > > >>
> > > >> I do see the big rcu_read_lock() in mlx5e_napi_poll().  
> > > >
> > > > I believed/assumed xdp_do_flush_map() was already protected under an
> > > > rcu_read_lock.  As the devmap and cpumap, which get called via
> > > > __dev_flush() and __cpu_map_flush(), have multiple RCU objects that we
> > > > are operating on.  
> >
> > What other rcu objects it is using during flush?
> 
> Look at code:
>  kernel/bpf/cpumap.c
>  kernel/bpf/devmap.c
> 
> The devmap is filled with RCU code and complicated take-down steps.  
> The devmap's elements are also RCU objects and the BPF xdp_prog is
> embedded in this object (struct bpf_dtab_netdev).  The call_rcu
> function is __dev_map_entry_free().
> 
> 
> > > > Perhaps it is a bug in i40e?  
> >
> > A quick look into ixgbe falls into the same bucket.
> > didn't look at other drivers though.
> 
> Intel driver are very much in copy-paste mode.
>  
> > > >
> > > > We are running in softirq in NAPI context, when xdp_do_flush_map() is
> > > > call, which I think means that this CPU will not go-through a RCU grace
> > > > period before we exit softirq, so in-practice it should be safe.  
> > > 
> > > Yup, this seems to be correct: rcu_softirq_qs() is only called between
> > > full invocations of the softirq handler, which for networking is
> > > net_rx_action(), and so translates into full NAPI poll cycles.  
> >
> > I don't know enough to comment on the rcu/softirq part, may be someone
> > can chime in.  There is also a recent napi_threaded_poll().
> 
> CC added Paul. (link to patch[1][2] for context)
Updated Paul's email address.

> 
> > If it is the case, then some of the existing rcu_read_lock() is unnecessary?
> 
> Well, in many cases, especially depending on how kernel is compiled,
> that is true.  But we want to keep these, as they also document the
> intend of the programmer.  And allow us to make the kernel even more
> preempt-able in the future.
> 
> > At least, it sounds incorrect to only make an exception here while keeping
> > other rcu_read_lock() as-is.
> 
> Let me be clear:  I think you have spotted a problem, and we need to
> add rcu_read_lock() at least around the invocation of
> bpf_prog_run_xdp() or before around if-statement that call
> dev_map_bpf_prog_run(). (Hangbin please do this in V8).
> 
> Thank you Martin for reviewing the code carefully enough to find this
> issue, that some drivers don't have a RCU-section around the full XDP
> code path in their NAPI-loop.
> 
> Question to Paul.  (I will attempt to describe in generic terms what
> happens, but ref real-function names).
> 
> We are running in softirq/NAPI context, the driver will call a
> bq_enqueue() function for every packet (if calling xdp_do_redirect) ,
> some driver wrap this with a rcu_read_lock/unlock() section (other have
> a large RCU-read section, that include the flush operation).
> 
> In the bq_enqueue() function we have a per_cpu_ptr (that store the
> xdp_frame packets) that will get flushed/send in the call
> xdp_do_flush() (that end-up calling bq_xmit_all()).  This flush will
> happen before we end our softirq/NAPI context.
> 
> The extension is that the per_cpu_ptr data structure (after this patch)
> store a pointer to an xdp_prog (which is a RCU object).  In the flush
> operation (which we will wrap with RCU-read section), we will use this
> xdp_prog pointer.   I can see that it is in-principle wrong to pass
> this-pointer between RCU-read sections, but I consider this safe as we
> are running under softirq/NAPI and the per_cpu_ptr is only valid in
> this short interval.
> 
> I claim a grace/quiescent RCU cannot happen between these two RCU-read
> sections, but I might be wrong? (especially in the future or for RT).
> 
> -- 
> Best regards,
>   Jesper Dangaard Brouer
>   MSc.CS, Principal Kernel Engineer at Red Hat
>   LinkedIn: http://www.linkedin.com/in/brouer 
> 
> [1] https://lore.kernel.org/netdev/20210414122610.4037085-2-liuhangbin@gmail.com/
> [2] https://patchwork.kernel.org/project/netdevbpf/patch/20210414122610.4037085-2-liuhangbin@gmail.com/
> 

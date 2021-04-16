Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5FFD362799
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 20:20:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244658AbhDPSU5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Apr 2021 14:20:57 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:27466 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236112AbhDPSU4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Apr 2021 14:20:56 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13GI9SON027105;
        Fri, 16 Apr 2021 11:20:12 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type :
 content-transfer-encoding : in-reply-to : mime-version; s=facebook;
 bh=k80RXGmbij/IB4N6LkKnca9IhkzgWxarMBR7W4yawO8=;
 b=RnPx+PhLnwEnTNpEvAREI0S60HTXpdTEetbVCMMDB55IPiw2amTk5uBsRLFdFMqFoS7f
 zb1t7iiqJV8EmZrrYQsgLYFffRcCzNAKFUTLvzluXm7bhQcivHniY6/78y6c16QzcLAW
 22YfAdwn2SvEOWwq8vjH1O92uc+E1pFWSDU= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 37y6tyk21e-19
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 16 Apr 2021 11:20:11 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.173) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 16 Apr 2021 11:20:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PGWFBkcPvLaeJW7jmKl0T1h6sg/1mFyEBd6jdJhjRU4R1NumX2s5MYOdcVgKaRm42OA8dGAMjZis4YxgAFVghJ+7QQ6FvRqHfYekN7Zbht8mU3IQR6RZO++8qKbHLZLR9LjY32JuiVdKgCV9s8kjFldIkrosdrm/mZzFuVree9GaJyVaYe7EJHHksdnERUJQFTLpC9GhuXSjEPC8TDc4HsAz1C8+F+d9XEABCzs+UZ5LFQhVL5ZOFHl28vI4c2zD4P4nhJaKQ7vu9hJirqj0qqI4kHc8/XlBt5WMiQqjv8PJkzsUz6RlpmLJ8oDXxmzDAFFLBv5aW1kd3wXcUwHE5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dgWSAmyDYjnIruTszOrnIBycmPkfnt+iSNRIfJ8BfZg=;
 b=kotMrXb6Qjqq0ETctgOdRFk3VzOZLT8ypkj1ZZnoNXjRuV4BESxs9da/YIHYnAbgNOj6D1YXbz4VqTpqqHwy5f6iRexiXUyVBfK0fv8+5b4XYLs5SGD0HD14ZMpPHfjewCZIhh7MO3qgu/HiAStFqv4lA08jqhzxJ9a17kZCgwvx/HP4Bbscp7ka33HJ7tmW/+NVF6nacl9y948G3tzk9GSkLqI3C8TEETUNkPqCDfP8Qy4W7e+L4ZwzkqzXrJznNG1uaEPWe4sG/EOgocBrSMnm5qfMaT2PKU+fpQCv3aGgDj5Yz3zhHMh8g43roRgWbUruK0cyRD1YL/anazH/pw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=fb.com;
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by BYAPR15MB2822.namprd15.prod.outlook.com (2603:10b6:a03:15b::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16; Fri, 16 Apr
 2021 18:20:08 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::718a:4142:4c92:732f]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::718a:4142:4c92:732f%6]) with mapi id 15.20.4042.019; Fri, 16 Apr 2021
 18:20:08 +0000
Date:   Fri, 16 Apr 2021 11:20:01 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
CC:     Jesper Dangaard Brouer <brouer@redhat.com>,
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
        =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Subject: Re: [PATCHv7 bpf-next 1/4] bpf: run devmap xdp_prog on flush instead
 of bulk enqueue
Message-ID: <20210416182001.56dski6q6kmgr74f@kafai-mbp.dhcp.thefacebook.com>
References: <20210414122610.4037085-1-liuhangbin@gmail.com>
 <20210414122610.4037085-2-liuhangbin@gmail.com>
 <20210415001711.dpbt2lej75ry6v7a@kafai-mbp.dhcp.thefacebook.com>
 <20210415023746.GR2900@Leo-laptop-t470s>
 <87o8efkilw.fsf@toke.dk>
 <20210415173551.7ma4slcbqeyiba2r@kafai-mbp.dhcp.thefacebook.com>
 <20210415202132.7b5e8d0d@carbon>
 <87k0p3i957.fsf@toke.dk>
 <20210416003913.azcjk4fqxs7gag3m@kafai-mbp.dhcp.thefacebook.com>
 <877dl2im0y.fsf@toke.dk>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <877dl2im0y.fsf@toke.dk>
X-Originating-IP: [2620:10d:c090:400::5:d4d1]
X-ClientProxiedBy: CO2PR04CA0101.namprd04.prod.outlook.com
 (2603:10b6:104:6::27) To BY5PR15MB3571.namprd15.prod.outlook.com
 (2603:10b6:a03:1f6::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:d4d1) by CO2PR04CA0101.namprd04.prod.outlook.com (2603:10b6:104:6::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16 via Frontend Transport; Fri, 16 Apr 2021 18:20:06 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d7a179c4-f3e5-4cee-dc8e-08d9010443a6
X-MS-TrafficTypeDiagnostic: BYAPR15MB2822:
X-Microsoft-Antispam-PRVS: <BYAPR15MB2822FEF1F4458FB202898AD3D54C9@BYAPR15MB2822.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6xRoDq+HeS2VB2ehS5/Pt5XUL5kpjwLCbpy3Qm2cwzWm0Y6yHp+WEsTtLn5D7+SDUVQlUqAU0TNiu0c85/IykOE00yb/2S1apEBFsrIO6RmKWnUI/MD63E7ua19zmSZasLv/rPg4h+B76dlNPbmAIPmU3uW8F+fna+OrqxrFGKYmhf3JmgAjFJVCypjUmHV0C/s8HZ0ST3VV+NjFqViMMoXXm8zUzdIoTSG9mR8SaHRwQxcYQPhQdCYoXxu/OU9EpOUWJJpmdPz/ggpgzP/iB+A/eW3HL7g0e5LwUjd52hrjGdVWKZvOrTZAx8S/KEeKqC5VLxuCPJio3VMPjxYws7ffs/2NIgZP+28EWLWZkmBJfjnaOXs4+nrSHfZHyyU7i/IQuKmuvx5me0E6UZ5Hzt/KqWLYYT/mggfW+h915UGzs11iLVwlo/4eQAAIAiuLt3lFmbZ7S/Xkc0+2vh4Nh9n4Xy4LIAfXuISmZgX7evyqjmnZ1AtYz9iXNTpswocc1Oz0PN5LSJgSEDpB150tmia7aH3+khYFte96RSadlK45t39fvyG/q57RIs3CLg5tDJLoWSeaYm+zdpJFQbQe88DPh8rWJL4kDpoRYPOLBnY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(376002)(39860400002)(346002)(396003)(136003)(6916009)(2906002)(4326008)(16526019)(9686003)(6666004)(8936002)(66574015)(7416002)(66476007)(52116002)(86362001)(38100700002)(66946007)(66556008)(7696005)(6506007)(316002)(8676002)(83380400001)(55016002)(54906003)(5660300002)(1076003)(186003)(478600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?iso-8859-1?Q?AjTfZ4lJDnmAEQo8//6Qdhq9iWn5KDzY9wZh8PgX57dfImznbuCsIZTxrD?=
 =?iso-8859-1?Q?JBlUUhwO7iIV3uyFdVyjWvfdmptbZ4hSwPT0O4pZb4r/TvF5+lDnxotrLo?=
 =?iso-8859-1?Q?piLRvnTQ8FsFHsAdzR3tDYxww3/Dn0l/qzXIBJpVL0jPUnQ7Bcx4/bgxGx?=
 =?iso-8859-1?Q?qsNuDznhe+yAAglU2GTUYSCwM0mNPdbahpW62SNSRcmHuIyTz3kAoooqYf?=
 =?iso-8859-1?Q?oqzyVhSn1K3bS5oc8zXgVkHSukf6z0jewfNQyECYN3i1Z+TmV80+us1JDA?=
 =?iso-8859-1?Q?FKsxHwFfTDVoXusKPp+BPsTtG2UK21QpyQuXtcEYZaIBEftrr1x3KDtJnN?=
 =?iso-8859-1?Q?YWGBrkvr9+VaY6tvWzGGq7ZBhYykBVDmy9/uAvXyotFIk9co2gy76wvoGc?=
 =?iso-8859-1?Q?8mgjGYYtglmVj+GYne8WMRFy+7zPCOgZV1o1ZrKL7PujdYvpcpJiijxxC8?=
 =?iso-8859-1?Q?yaFb5hBs0lLQzQ887N7pMgznDTqa8exG9HUKZAs0/JmC4576DCtmf5poC0?=
 =?iso-8859-1?Q?6OloVK3kmv+KAKUpKaZ3AgnC12tQ36u4I0i+diehCqfyVGukuooS3u/eWI?=
 =?iso-8859-1?Q?JN8MxfIdK37z9ZQtD/GVWNh+jNzEVUZCMLRaB4wkVijLWC4S+vfx2vxhfS?=
 =?iso-8859-1?Q?UyWAS9hk+4tHqPEedmIfQbK5DLBakWDPg+JI25AejRevl0eVK7Wxrtngtc?=
 =?iso-8859-1?Q?1DJ5tGaDbkxHsJm1fw6bQLV9XScWY0w8cIWuZjoy4iEHRBAYZHaCx/37rD?=
 =?iso-8859-1?Q?0kG5HINcy0DqCRV3+JeKuxp2yqG7QHFUgPlOw6FqDGyBzNTqd4bUqzNS1C?=
 =?iso-8859-1?Q?KKg9athzMPbWiM6x+rDhpl4DNZh1F4P1Y070IGGdXuf9JHq15ph+J3FOVe?=
 =?iso-8859-1?Q?W4Cya7MpY/s8/FdlfscOBeNAtMcxBX57tnDt/7gWgDQ/YDL3Rk+xp7hq0h?=
 =?iso-8859-1?Q?litr6bi2BCHaoSZSiHLvvuGlpI7xnxTW7RX6dE/SIyk1gOlcODs6MstWPk?=
 =?iso-8859-1?Q?ptJCYHte5ZhEpY62xaX/HjcRgA+mMs0SjlKonZQqkUg/J/Hsl/GG5eG9DJ?=
 =?iso-8859-1?Q?vvDxmSmenZ5GNVkV2VcRugcXkVrrpTnZB5pWq+n2XHyoKJ5i/PDloPKzfl?=
 =?iso-8859-1?Q?WhIXY8RVRmRfgJLKlenselN7WQkxAgSpSXRxweDKl8kpD6/T0Rq9elm0PC?=
 =?iso-8859-1?Q?NyFDrJ4lrewQ9EwG7NXAYu5Tpjvh4BVFsYGha259jjlYaz3zG0w6pUtpfS?=
 =?iso-8859-1?Q?sLNKgfo38d3lEtJe5nnmTV3FZjvFf29DzGDfVpN65L0aXuB9ITGWm3M1qS?=
 =?iso-8859-1?Q?zLoLUJWJB7uSW5dOvgWMla/SV5Zu21yWUgAXqZ/uIM75WiNeEJPB0FAoGc?=
 =?iso-8859-1?Q?OK1BGKGX+LmJ0giqOGnVu8THSl4Fq3QA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d7a179c4-f3e5-4cee-dc8e-08d9010443a6
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB3571.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Apr 2021 18:20:07.8890
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oCeI8mn9lUDoJ5m+if1eMTLj7tT/c3piLixpaNENFUtDCo9gOHvFHyw6fMLM/yR1
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2822
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: m8bFkje3HBpjW9NEtLedkDWDKulvKXfs
X-Proofpoint-GUID: m8bFkje3HBpjW9NEtLedkDWDKulvKXfs
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-16_09:2021-04-16,2021-04-16 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015
 priorityscore=1501 malwarescore=0 bulkscore=0 adultscore=0
 lowpriorityscore=0 mlxlogscore=999 mlxscore=0 phishscore=0 suspectscore=0
 impostorscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2104060000 definitions=main-2104160130
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 16, 2021 at 12:03:41PM +0200, Toke Høiland-Jørgensen wrote:
> Martin KaFai Lau <kafai@fb.com> writes:
> 
> > On Thu, Apr 15, 2021 at 10:29:40PM +0200, Toke Høiland-Jørgensen wrote:
> >> Jesper Dangaard Brouer <brouer@redhat.com> writes:
> >> 
> >> > On Thu, 15 Apr 2021 10:35:51 -0700
> >> > Martin KaFai Lau <kafai@fb.com> wrote:
> >> >
> >> >> On Thu, Apr 15, 2021 at 11:22:19AM +0200, Toke Høiland-Jørgensen wrote:
> >> >> > Hangbin Liu <liuhangbin@gmail.com> writes:
> >> >> >   
> >> >> > > On Wed, Apr 14, 2021 at 05:17:11PM -0700, Martin KaFai Lau wrote:  
> >> >> > >> >  static void bq_xmit_all(struct xdp_dev_bulk_queue *bq, u32 flags)
> >> >> > >> >  {
> >> >> > >> >  	struct net_device *dev = bq->dev;
> >> >> > >> > -	int sent = 0, err = 0;
> >> >> > >> > +	int sent = 0, drops = 0, err = 0;
> >> >> > >> > +	unsigned int cnt = bq->count;
> >> >> > >> > +	int to_send = cnt;
> >> >> > >> >  	int i;
> >> >> > >> >  
> >> >> > >> > -	if (unlikely(!bq->count))
> >> >> > >> > +	if (unlikely(!cnt))
> >> >> > >> >  		return;
> >> >> > >> >  
> >> >> > >> > -	for (i = 0; i < bq->count; i++) {
> >> >> > >> > +	for (i = 0; i < cnt; i++) {
> >> >> > >> >  		struct xdp_frame *xdpf = bq->q[i];
> >> >> > >> >  
> >> >> > >> >  		prefetch(xdpf);
> >> >> > >> >  	}
> >> >> > >> >  
> >> >> > >> > -	sent = dev->netdev_ops->ndo_xdp_xmit(dev, bq->count, bq->q, flags);
> >> >> > >> > +	if (bq->xdp_prog) {  
> >> >> > >> bq->xdp_prog is used here
> >> >> > >>   
> >> >> > >> > +		to_send = dev_map_bpf_prog_run(bq->xdp_prog, bq->q, cnt, dev);
> >> >> > >> > +		if (!to_send)
> >> >> > >> > +			goto out;
> >> >> > >> > +
> >> >> > >> > +		drops = cnt - to_send;
> >> >> > >> > +	}
> >> >> > >> > +  
> >> >> > >> 
> >> >> > >> [ ... ]
> >> >> > >>   
> >> >> > >> >  static void bq_enqueue(struct net_device *dev, struct xdp_frame *xdpf,
> >> >> > >> > -		       struct net_device *dev_rx)
> >> >> > >> > +		       struct net_device *dev_rx, struct bpf_prog *xdp_prog)
> >> >> > >> >  {
> >> >> > >> >  	struct list_head *flush_list = this_cpu_ptr(&dev_flush_list);
> >> >> > >> >  	struct xdp_dev_bulk_queue *bq = this_cpu_ptr(dev->xdp_bulkq);
> >> >> > >> > @@ -412,18 +466,22 @@ static void bq_enqueue(struct net_device *dev, struct xdp_frame *xdpf,
> >> >> > >> >  	/* Ingress dev_rx will be the same for all xdp_frame's in
> >> >> > >> >  	 * bulk_queue, because bq stored per-CPU and must be flushed
> >> >> > >> >  	 * from net_device drivers NAPI func end.
> >> >> > >> > +	 *
> >> >> > >> > +	 * Do the same with xdp_prog and flush_list since these fields
> >> >> > >> > +	 * are only ever modified together.
> >> >> > >> >  	 */
> >> >> > >> > -	if (!bq->dev_rx)
> >> >> > >> > +	if (!bq->dev_rx) {
> >> >> > >> >  		bq->dev_rx = dev_rx;
> >> >> > >> > +		bq->xdp_prog = xdp_prog;  
> >> >> > >> bp->xdp_prog is assigned here and could be used later in bq_xmit_all().
> >> >> > >> How is bq->xdp_prog protected? Are they all under one rcu_read_lock()?
> >> >> > >> It is not very obvious after taking a quick look at xdp_do_flush[_map].
> >> >> > >> 
> >> >> > >> e.g. what if the devmap elem gets deleted.  
> >> >> > >
> >> >> > > Jesper knows better than me. From my veiw, based on the description of
> >> >> > > __dev_flush():
> >> >> > >
> >> >> > > On devmap tear down we ensure the flush list is empty before completing to
> >> >> > > ensure all flush operations have completed. When drivers update the bpf
> >> >> > > program they may need to ensure any flush ops are also complete.  
> >> >>
> >> >> AFAICT, the bq->xdp_prog is not from the dev. It is from a devmap's elem.
> >> >> 
> >> >> > 
> >> >> > Yeah, drivers call xdp_do_flush() before exiting their NAPI poll loop,
> >> >> > which also runs under one big rcu_read_lock(). So the storage in the
> >> >> > bulk queue is quite temporary, it's just used for bulking to increase
> >> >> > performance :)  
> >> >>
> >> >> I am missing the one big rcu_read_lock() part.  For example, in i40e_txrx.c,
> >> >> i40e_run_xdp() has its own rcu_read_lock/unlock().  dst->xdp_prog used to run
> >> >> in i40e_run_xdp() and it is fine.
> >> >> 
> >> >> In this patch, dst->xdp_prog is run outside of i40e_run_xdp() where the
> >> >> rcu_read_unlock() has already done.  It is now run in xdp_do_flush_map().
> >> >> or I missed the big rcu_read_lock() in i40e_napi_poll()?
> >> >>
> >> >> I do see the big rcu_read_lock() in mlx5e_napi_poll().
> >> >
> >> > I believed/assumed xdp_do_flush_map() was already protected under an
> >> > rcu_read_lock.  As the devmap and cpumap, which get called via
> >> > __dev_flush() and __cpu_map_flush(), have multiple RCU objects that we
> >> > are operating on.
> > What other rcu objects it is using during flush?
> 
> The bq_enqueue() function in cpumap.c puts the 'bq' pointer onto the
> flush_list, and 'bq' lives inside struct bpf_cpu_map_entry, so that's a
> reference to the map entry as well.
> 
> The devmap function used to work the same way, until we changed it in
> 75ccae62cb8d ("xdp: Move devmap bulk queue into struct net_device").
Got it. Thanks for the explanation in bq_enqueue() in cpumap.c.
I was under the impression that xdp_do_flush_map() should not
use any rcu object now since I don't see rcu_read_lock() there
and I use it as a hint in code reading.

> >> > Perhaps it is a bug in i40e?
> > A quick look into ixgbe falls into the same bucket.
> > didn't look at other drivers though.
> >
> >> >
> >> > We are running in softirq in NAPI context, when xdp_do_flush_map() is
> >> > call, which I think means that this CPU will not go-through a RCU grace
> >> > period before we exit softirq, so in-practice it should be safe.
> >> 
> >> Yup, this seems to be correct: rcu_softirq_qs() is only called between
> >> full invocations of the softirq handler, which for networking is
> >> net_rx_action(), and so translates into full NAPI poll cycles.
> >
> > I don't know enough to comment on the rcu/softirq part, may be someone
> > can chime in.  There is also a recent napi_threaded_poll().
> >
> > If it is the case, then some of the existing rcu_read_lock() is unnecessary?
> > At least, it sounds incorrect to only make an exception here while keeping
> > other rcu_read_lock() as-is.
> 
> I'd tend to agree that the correct thing to do is to fix any affected
> drivers so there's a wide rcu_read_lock() around the full xdp+flush. If
> nothing else, this serves as an annotation for the expected lifetime of
> the objects involved.
> 
> However, given that this is not a new issue, I don't think it should be
> holding up this patch series... We can start a new conversation on what
> the right way to fix this is - and maybe bring in Paul for advice on the
> RCU side? WDYT?
Yeah...it falls into the same issue as the current bq_enqueue() in cpumap.c.
I am fine to put them together into the solve later bucket.  I will delegate
this decision to the maintainers.

I would wait a bit on Paul's reply though.

Also, patch 2 does not necessary depend on patch 1?  Another option is to post
patch 1 separately later as an optimization when the rcu discussion concluded.

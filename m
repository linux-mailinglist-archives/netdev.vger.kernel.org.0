Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 636C83616DA
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 02:39:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236917AbhDPAj7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 20:39:59 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:17496 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234708AbhDPAj6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Apr 2021 20:39:58 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13G0a1lv019632;
        Thu, 15 Apr 2021 17:39:18 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type :
 content-transfer-encoding : in-reply-to : mime-version; s=facebook;
 bh=STrOTh5aZm3zI5tT2ojNzgLCxO2+hYo6UgcZwNKSRDw=;
 b=aj5cwc5UQ1tZvOaBVf/ZzMCcuAolunoiulALzvAH+z0ljm1wkRbueGqhhh4bm5YH2xpU
 EQboB+zNXQhzJTJoPnLaKuW0kLbHMUQbN8JwlZfcxzzoQ41S+PCdSdqn1ECldc8Pl4+8
 FFdb2V0tVPQ/Owf3WYQk2qjbOmo7+o3I/5U= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 37wvcmu5hh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 15 Apr 2021 17:39:18 -0700
Received: from NAM02-BL2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 15 Apr 2021 17:39:17 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gOC3QTI38JIl6JmWIC/jd57ZF3qgn6fQ0b7MWqM6kguHGKyZrJl4q7NT+4Y80Hre4mjnHtnPe1LeFN6vSk+iEVlL4ZqoknWOQnRVJvfhAb5eWzgrbFHnCTG7GSrNHs2skIyhYpIWDZ/z5mbU0iD42cIa0n7H35x3Kp54NFhG8EbWPhKkdDQnq78EmZXjeot6BAtMo5xGB4elVIt/jyDv1+5EQT9AoE8snLok2LsPMLCml/qI+ihdm2Bu2mh6aL0HeOnMdtKpIPCzBwKvzBFUIfreb67B2nPCfLhBBhXhtR/tFMhnF7Nu4fzmpqh7LKKmfofHO9MWkvsThpYk7wLFSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WhwvZhMEBYRfYVata24dyi4BuRdgOxWAfiTnnj+fkt0=;
 b=gvIZtLTWAVh0Q8G9BSnM925U92HNLbd2loeHpMABh9LIkHeL+SBhTa1luYIcdI8/svdniZDH1HlwamQ8R6D9ETbaXIHCf5magD70RipkZertDhfz42hs7ciOKoGsyt7ZX7Eh7pO2W3x0IHBeMBa9x5xNPk8zL9S+6uhxEOUp4P01cRDv7/Ad+R0/e6HeKj0JbvAmw1vHlsdlB1GyKGVXhZ0CiFAuwZv+gdoognoa2/cEcw7iGRupURUgH4Nlqko2CARIRuRXI2qKuwDXr8Ubl6EG2HOFktx9sAcjM80mdSHwdsDG7ezq1h6WbF+xwyRV+8pGqs7JVayS8gAHd8vmLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=fb.com;
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by SJ0PR15MB4568.namprd15.prod.outlook.com (2603:10b6:a03:379::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.16; Fri, 16 Apr
 2021 00:39:16 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::718a:4142:4c92:732f]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::718a:4142:4c92:732f%6]) with mapi id 15.20.4020.023; Fri, 16 Apr 2021
 00:39:16 +0000
Date:   Thu, 15 Apr 2021 17:39:13 -0700
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
Message-ID: <20210416003913.azcjk4fqxs7gag3m@kafai-mbp.dhcp.thefacebook.com>
References: <20210414122610.4037085-1-liuhangbin@gmail.com>
 <20210414122610.4037085-2-liuhangbin@gmail.com>
 <20210415001711.dpbt2lej75ry6v7a@kafai-mbp.dhcp.thefacebook.com>
 <20210415023746.GR2900@Leo-laptop-t470s>
 <87o8efkilw.fsf@toke.dk>
 <20210415173551.7ma4slcbqeyiba2r@kafai-mbp.dhcp.thefacebook.com>
 <20210415202132.7b5e8d0d@carbon>
 <87k0p3i957.fsf@toke.dk>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87k0p3i957.fsf@toke.dk>
X-Originating-IP: [2620:10d:c090:400::5:fefe]
X-ClientProxiedBy: MW4PR04CA0108.namprd04.prod.outlook.com
 (2603:10b6:303:83::23) To BY5PR15MB3571.namprd15.prod.outlook.com
 (2603:10b6:a03:1f6::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:fefe) by MW4PR04CA0108.namprd04.prod.outlook.com (2603:10b6:303:83::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.18 via Frontend Transport; Fri, 16 Apr 2021 00:39:14 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f82b7fc1-dfbd-4793-f754-08d900701072
X-MS-TrafficTypeDiagnostic: SJ0PR15MB4568:
X-Microsoft-Antispam-PRVS: <SJ0PR15MB45686283BD12B90CE1045FF7D54C9@SJ0PR15MB4568.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ca/5ZJvZZtjI1TeKRe8Mb/5cSUZFyQpTvfpXijLw36jGaHy+YJo/CG6a61+omK5yv+gOopgZYcDSxF6uG9UsWR2N6P0T4erG5X0d9CMHYGdg9SnfX2AgB0GDRGIlx/OGXoRmvfMfmpnrNZyIItPab6g0PNz2RZCQUl1R31IMppQXQtmh1msOFu0DGYUfzc0dnpGvAUxFDPMxEArOLly2C6tkN1UXfQ8eLCPHxTdadHCvErONpi/UUzRycrKceGg5sTe5PhpTf+acG/x+7OIANUE2Fush6GBfk0PvSS7HIrZ/P9LDNZA8N6kgevRDoQ2b0fJKvJv8vrw4EZf7VTA0/P+BZXon0jvyoqWcm+WjE86b2vvTcR7AnrmUSTq+b5DL+0YPiLe8aTW48RB45+oYPOEhuSbXjknteG83n1mafewBTGnzT79FNNOKsvDeQGToiA9lDh4Q1C8Aowpkc+rFhZDJT+07wEb0UwW74fYtjKtpFEKqzQx25g+qxGgEsyaY/vorgq8G+R6Bt3yBRcyD+A4cRRpvj0pIgF5w5SNbjAcd+Tqw9OY29CybtZL6tiQzfE7Q1PSZMgpZ7gHedlclP4t9rLnpkmEefgpWyujOR1g=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(396003)(366004)(39860400002)(136003)(376002)(316002)(86362001)(55016002)(1076003)(4326008)(7416002)(52116002)(16526019)(5660300002)(54906003)(38100700002)(8676002)(186003)(7696005)(6916009)(66556008)(9686003)(2906002)(8936002)(66476007)(66574015)(478600001)(6506007)(83380400001)(66946007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?iso-8859-1?Q?FHivjNowkf9tHJ3kR9r3wn5Iu8+8GzjMIT7eCqOAwdU1hyjYIHgsYMiivA?=
 =?iso-8859-1?Q?w+h3npfm5gd+eEC30BBpkJkwVCkJpc3msidlkwKlEed/VU3XSzDLkVRR3W?=
 =?iso-8859-1?Q?PTjUsW4Bdz3vYUsS+FTYapjInLxQCr0L8lgGoFjjKF87+PMI6CxP7RB2KU?=
 =?iso-8859-1?Q?ccNcuC8eTQmmVgqYbSPDBx2ZAHUpzavJPRiulIc7+A0rr/TmQT5y2MUPR+?=
 =?iso-8859-1?Q?UibJKDENPoLBVoCDgoCZRhX93FV+n83vKmjue3lecH1URqU/otVd0RYEn7?=
 =?iso-8859-1?Q?AUtQRiIAPuo6Gac1IaTbJRBZTJCeXq9l70mpEHs6ewgDMWvawkbpYu5KxH?=
 =?iso-8859-1?Q?EaYbys3E6HTS1QHl43wAD0vUbp/TwHhEpPof2Q+6EcfES6W2Cutoa6glvv?=
 =?iso-8859-1?Q?BhRY+p33k3x1UsRlsZCu/0RldPS9kSZpeiutb0sJawbykiaySfYS0g0etA?=
 =?iso-8859-1?Q?ObKcPOPCbudNdkRxC+POVqvKuwxxdYH4v4rJftA3SMRQGNxP0UNcq6jrLP?=
 =?iso-8859-1?Q?r3p0XKncbbeGpYVf4litR9XmrncPDz1TNLF0eqFi9wyiEntNXSP0wSyODq?=
 =?iso-8859-1?Q?fj8H1eASBvU8pGDXG2xPm9ofSHrZ2ITCdyygsDdaw3paaAocZffCfCU+Lz?=
 =?iso-8859-1?Q?UmYa0zUECGQyrNZCy15TUrPg0N/HclBh0CR+Ru1TnBznTggdHbqIjVWt4x?=
 =?iso-8859-1?Q?hohBJsf1uXF6aV7VL+RfO5K9Dat016z8PteZ7x9lpGolBx+gzcAUxpvK5Y?=
 =?iso-8859-1?Q?2aL5igAG5GU/ijNj3MtsTLSKnbVjBq7wxw2NPDOu0+tzHG3UFXtfNz8eL2?=
 =?iso-8859-1?Q?qwsh6PRJtsEclrNDQmfyZGQNMKvjiUUFQQEYaSr1OY9pzRjnfiD4qheoKr?=
 =?iso-8859-1?Q?0fwjrHvN4/LiGlWp1Fqs2xim4d0ahf7BdNZxsD/a4gbbGbLt0Jw8UQeg/W?=
 =?iso-8859-1?Q?ZjJs9i7ktwK1J4QS0A2N6dzqGqO5MdasP1I7qIhH0+5DSbuQAVXrO8kTtT?=
 =?iso-8859-1?Q?hjLddzkeYr3CsLs3OpK4OxV0214/aq2fP6339j43lz5unCiCAwHrmTSUno?=
 =?iso-8859-1?Q?oc09EJ2uurGWa0vwI60VKC3SVtRXy5HYNsiEWUmB33asjONcaZITx3oFm1?=
 =?iso-8859-1?Q?tFAVfypsepnYQB4hgkqhxHfVE5tolaVkPgk/bGp21cnFaq2rCn6RAzxwFQ?=
 =?iso-8859-1?Q?Sn9NmSopRncSBG4GhficvnXuwRdej/H4QL9LZL3X5zT9PcoNEXzFTQg/Us?=
 =?iso-8859-1?Q?8kxg6GHOY8sjVq0Zlncm3ydfWGr6KoA/yGWEx37FQBwfeu9HCn02SLS2mr?=
 =?iso-8859-1?Q?y6ZZ3DQyX2NWbY1fuOgYsX32ryoOsuBz3OMQON+s057mDSsoBVIVM0nIjf?=
 =?iso-8859-1?Q?gl+2LCmYQ9TZWZlD7QrCoduj6sNsT5NQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f82b7fc1-dfbd-4793-f754-08d900701072
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB3571.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Apr 2021 00:39:16.5740
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hhwKx6b06T8oLYvlV4MOMwiTgLGRoJeDraVZIIwqz3ZWwKmy1xM2Evec6sNVpXtI
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR15MB4568
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: vMITj_og_r5umu8lT3O1dHAB4EIrzkTr
X-Proofpoint-ORIG-GUID: vMITj_og_r5umu8lT3O1dHAB4EIrzkTr
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-15_11:2021-04-15,2021-04-15 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015 bulkscore=0
 phishscore=0 suspectscore=0 impostorscore=0 priorityscore=1501
 mlxlogscore=896 adultscore=0 malwarescore=0 spamscore=0 lowpriorityscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104160002
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 15, 2021 at 10:29:40PM +0200, Toke Høiland-Jørgensen wrote:
> Jesper Dangaard Brouer <brouer@redhat.com> writes:
> 
> > On Thu, 15 Apr 2021 10:35:51 -0700
> > Martin KaFai Lau <kafai@fb.com> wrote:
> >
> >> On Thu, Apr 15, 2021 at 11:22:19AM +0200, Toke Høiland-Jørgensen wrote:
> >> > Hangbin Liu <liuhangbin@gmail.com> writes:
> >> >   
> >> > > On Wed, Apr 14, 2021 at 05:17:11PM -0700, Martin KaFai Lau wrote:  
> >> > >> >  static void bq_xmit_all(struct xdp_dev_bulk_queue *bq, u32 flags)
> >> > >> >  {
> >> > >> >  	struct net_device *dev = bq->dev;
> >> > >> > -	int sent = 0, err = 0;
> >> > >> > +	int sent = 0, drops = 0, err = 0;
> >> > >> > +	unsigned int cnt = bq->count;
> >> > >> > +	int to_send = cnt;
> >> > >> >  	int i;
> >> > >> >  
> >> > >> > -	if (unlikely(!bq->count))
> >> > >> > +	if (unlikely(!cnt))
> >> > >> >  		return;
> >> > >> >  
> >> > >> > -	for (i = 0; i < bq->count; i++) {
> >> > >> > +	for (i = 0; i < cnt; i++) {
> >> > >> >  		struct xdp_frame *xdpf = bq->q[i];
> >> > >> >  
> >> > >> >  		prefetch(xdpf);
> >> > >> >  	}
> >> > >> >  
> >> > >> > -	sent = dev->netdev_ops->ndo_xdp_xmit(dev, bq->count, bq->q, flags);
> >> > >> > +	if (bq->xdp_prog) {  
> >> > >> bq->xdp_prog is used here
> >> > >>   
> >> > >> > +		to_send = dev_map_bpf_prog_run(bq->xdp_prog, bq->q, cnt, dev);
> >> > >> > +		if (!to_send)
> >> > >> > +			goto out;
> >> > >> > +
> >> > >> > +		drops = cnt - to_send;
> >> > >> > +	}
> >> > >> > +  
> >> > >> 
> >> > >> [ ... ]
> >> > >>   
> >> > >> >  static void bq_enqueue(struct net_device *dev, struct xdp_frame *xdpf,
> >> > >> > -		       struct net_device *dev_rx)
> >> > >> > +		       struct net_device *dev_rx, struct bpf_prog *xdp_prog)
> >> > >> >  {
> >> > >> >  	struct list_head *flush_list = this_cpu_ptr(&dev_flush_list);
> >> > >> >  	struct xdp_dev_bulk_queue *bq = this_cpu_ptr(dev->xdp_bulkq);
> >> > >> > @@ -412,18 +466,22 @@ static void bq_enqueue(struct net_device *dev, struct xdp_frame *xdpf,
> >> > >> >  	/* Ingress dev_rx will be the same for all xdp_frame's in
> >> > >> >  	 * bulk_queue, because bq stored per-CPU and must be flushed
> >> > >> >  	 * from net_device drivers NAPI func end.
> >> > >> > +	 *
> >> > >> > +	 * Do the same with xdp_prog and flush_list since these fields
> >> > >> > +	 * are only ever modified together.
> >> > >> >  	 */
> >> > >> > -	if (!bq->dev_rx)
> >> > >> > +	if (!bq->dev_rx) {
> >> > >> >  		bq->dev_rx = dev_rx;
> >> > >> > +		bq->xdp_prog = xdp_prog;  
> >> > >> bp->xdp_prog is assigned here and could be used later in bq_xmit_all().
> >> > >> How is bq->xdp_prog protected? Are they all under one rcu_read_lock()?
> >> > >> It is not very obvious after taking a quick look at xdp_do_flush[_map].
> >> > >> 
> >> > >> e.g. what if the devmap elem gets deleted.  
> >> > >
> >> > > Jesper knows better than me. From my veiw, based on the description of
> >> > > __dev_flush():
> >> > >
> >> > > On devmap tear down we ensure the flush list is empty before completing to
> >> > > ensure all flush operations have completed. When drivers update the bpf
> >> > > program they may need to ensure any flush ops are also complete.  
> >>
> >> AFAICT, the bq->xdp_prog is not from the dev. It is from a devmap's elem.
> >> 
> >> > 
> >> > Yeah, drivers call xdp_do_flush() before exiting their NAPI poll loop,
> >> > which also runs under one big rcu_read_lock(). So the storage in the
> >> > bulk queue is quite temporary, it's just used for bulking to increase
> >> > performance :)  
> >>
> >> I am missing the one big rcu_read_lock() part.  For example, in i40e_txrx.c,
> >> i40e_run_xdp() has its own rcu_read_lock/unlock().  dst->xdp_prog used to run
> >> in i40e_run_xdp() and it is fine.
> >> 
> >> In this patch, dst->xdp_prog is run outside of i40e_run_xdp() where the
> >> rcu_read_unlock() has already done.  It is now run in xdp_do_flush_map().
> >> or I missed the big rcu_read_lock() in i40e_napi_poll()?
> >>
> >> I do see the big rcu_read_lock() in mlx5e_napi_poll().
> >
> > I believed/assumed xdp_do_flush_map() was already protected under an
> > rcu_read_lock.  As the devmap and cpumap, which get called via
> > __dev_flush() and __cpu_map_flush(), have multiple RCU objects that we
> > are operating on.
What other rcu objects it is using during flush?

> >
> > Perhaps it is a bug in i40e?
A quick look into ixgbe falls into the same bucket.
didn't look at other drivers though.

> >
> > We are running in softirq in NAPI context, when xdp_do_flush_map() is
> > call, which I think means that this CPU will not go-through a RCU grace
> > period before we exit softirq, so in-practice it should be safe.
> 
> Yup, this seems to be correct: rcu_softirq_qs() is only called between
> full invocations of the softirq handler, which for networking is
> net_rx_action(), and so translates into full NAPI poll cycles.
I don't know enough to comment on the rcu/softirq part, may be someone
can chime in.  There is also a recent napi_threaded_poll().

If it is the case, then some of the existing rcu_read_lock() is unnecessary?
At least, it sounds incorrect to only make an exception here while keeping
other rcu_read_lock() as-is.

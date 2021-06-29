Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 166D03B7799
	for <lists+netdev@lfdr.de>; Tue, 29 Jun 2021 20:06:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234842AbhF2SIx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Jun 2021 14:08:53 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:37246 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234809AbhF2SIu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Jun 2021 14:08:50 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15THvsH6017353;
        Tue, 29 Jun 2021 11:06:07 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=YwnflZ9xnT2w/Ua/cFuBVsxouyDP9zkIV+ACi7qttK8=;
 b=dYx5dVzLjGEw5DmlBHhXNSjfo48PQu6/qakH1tl4OYT7Y2wXgnr5Bmh9HoJ2dlgHSbCV
 pQNwLgCXjEedPTOx+7wioyrXM2rgVnyFcmBr0Dn2tItzYJW/CWa/+/P2WeuXYamzbhtZ
 0DHaCeCl/iQiQlgR2WpJO5Sq0DQ501/8/8w= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 39fg3as8xk-14
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 29 Jun 2021 11:06:07 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.175) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 29 Jun 2021 11:06:06 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Yw/0O+9NgT/HC+6TbdJXS9cPV3niDbwUb9/Sy2j6My2ZksYusLyBKyU8DF3g7GlBb1yEgNeIEXuZankwC16mII1g8quijlg8GzLIeYCx8j/iQpYcsGDLrf+Bn2js17E2FcuqAG6e4DIZxLHVMVSbpckKsDi8cUrSxqcoomwg9QYQaLh/cvU6xmqXuoueK/8fRO9YhtD/5moMg2mlq7ugAhUyxPYMVFUBawLGMIBl5ePMDwOLRKC3LrhljEH62vBU8HaxdsPdL5Hn1WEOz8QA9tL0eWTdDwhm68z1dXpwzs8XxKXL0eGhxo1qCL2T+tMMqu6zfB0ZAn7510GxPwqGow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YwnflZ9xnT2w/Ua/cFuBVsxouyDP9zkIV+ACi7qttK8=;
 b=ZT5X2i6EF+3fvhX1DHI9LDDKEtKCSgeKc/U/avB9q6xdO34qooulRu32ZBmSa0B2SxZ7LjEMEU2V1WDvxG7tVLJzCTFzuxu7rEWu3O/d8nzf9LLCZmkgk6wn/sJEakAGulvWFpw6ZpTyUZiHM0rTmjh+Qfzt1NzLTj5Fk8ohu1UEpVXOng9YDxzhh4wt03JLoJE43pGx+HHNPQn+rEOwTKpzIOsB3OGzbblZKU3N+uqvd3gkt6TffMLHRwD9O6npdGESgPQJMqFESWplULt3RHJID50crR+EBJLt62AjUNf0McBkK9xGibvknS/SJYO7nwZ6WyO8oTXLqeHs8NSgaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5016.namprd15.prod.outlook.com (2603:10b6:806:1db::19)
 by SA0PR15MB3776.namprd15.prod.outlook.com (2603:10b6:806:87::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.18; Tue, 29 Jun
 2021 18:06:05 +0000
Received: from SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::803d:ce17:853f:6ba6]) by SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::803d:ce17:853f:6ba6%7]) with mapi id 15.20.4264.026; Tue, 29 Jun 2021
 18:06:05 +0000
Date:   Tue, 29 Jun 2021 11:06:03 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Yonghong Song <yhs@fb.com>
CC:     <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Eric Dumazet <edumazet@google.com>, <kernel-team@fb.com>,
        Neal Cardwell <ncardwell@google.com>, <netdev@vger.kernel.org>,
        Yuchung Cheng <ycheng@google.com>
Subject: Re: [PATCH bpf-next 6/8] bpf: tcp: bpf iter batching and lock_sock
Message-ID: <20210629180603.itvt3kupjnsexa7y@kafai-mbp.dhcp.thefacebook.com>
References: <20210625200446.723230-1-kafai@fb.com>
 <20210625200523.726854-1-kafai@fb.com>
 <6be60772-4d2a-30b0-5ebb-f857db31c037@fb.com>
 <20210629174458.2c5grwa37ehb55wo@kafai-mbp.dhcp.thefacebook.com>
 <387750f4-4610-0c37-60c5-06e5a1c98e63@fb.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <387750f4-4610-0c37-60c5-06e5a1c98e63@fb.com>
X-Originating-IP: [2620:10d:c090:400::5:75f3]
X-ClientProxiedBy: BY5PR04CA0009.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::19) To SA1PR15MB5016.namprd15.prod.outlook.com
 (2603:10b6:806:1db::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:75f3) by BY5PR04CA0009.namprd04.prod.outlook.com (2603:10b6:a03:1d0::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.19 via Frontend Transport; Tue, 29 Jun 2021 18:06:04 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: aa5090ae-fe72-4e22-1502-08d93b288fdf
X-MS-TrafficTypeDiagnostic: SA0PR15MB3776:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR15MB3776B5F60E31AB8DFF3D9DE7D5029@SA0PR15MB3776.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: E1XbFruihNm9tfiAHFbiN7UNshAr2mLeMVfPXaj6OyERRwzVUvmWcNd5L163XPOYzyF3TY6jwuFf92ZJTPsPoa57gK+PEti/CszwVOfyww06G5ksdseeZ9+FpgOnMgTmu5bF1aTfO04AuxqWcxjXWYx4eWnEAlNGUuEARlQS63iYmMdGdHytkD+uW+GHT4JOpK1Hk2+hzGzr+m/T+Pm+4VS21aErOIWjgnaJUwSS1lb/gHcU7Hcs1xQxPeJRXsSHTsaUrXEDVvoiPWfhDWKsOHJjlkyHAyR1Kq42U38U3lYldmEQoE7kIGdvkmMISxODS97rzcp6FU2GKEemVycn+9AMioXhOO7NkJRaDVQ+i5wjdp1M63Z8XxAp46IZqjPn1wrDaMoLdmJfGAIHphLFO75NlQRUsrw3uU8ELVrqWFPhQ6FKgXAaBIKZN7g9gd7ifdSX/ID0crlrChzlF2gtJPzWeoJWkWHJUTzUe1l9mXZHyrHnfYtkoMotwOGIT7i35Uga0R/yTGU5LZrzv2HNFErXzBg+XEN273jbiyp3SPT9uccAyLcBtY5848nVRB36YAGbmUnKtmXLeRBBsv3SYKh4gyog2XVH3joUl2c9tj9V97P+7ICsNEoWZLhHkQo5e8reiPxr+usYbONIRG5+ag==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5016.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(136003)(39860400002)(376002)(346002)(366004)(4326008)(55016002)(66946007)(16526019)(66476007)(6862004)(86362001)(2906002)(8936002)(66556008)(7696005)(1076003)(52116002)(186003)(9686003)(53546011)(6506007)(38100700002)(8676002)(54906003)(5660300002)(83380400001)(478600001)(6636002)(316002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/Ej6lHMQ0aCnWseV+s36TZYcrVSln+AqsH1rDg3kLqojS/WaJpfevIGxRbvS?=
 =?us-ascii?Q?Xu1lIgh8KKlT7qxQOS0zJFV5cm4ZhJperVrBVpOXaR35QufJlX0h8ts/Vq+Y?=
 =?us-ascii?Q?Kj7mxhiYXBVqe31zZHF2J1xV2ViPW0nErdvUOOiYYXKe26fk/8PGF4jucts8?=
 =?us-ascii?Q?DD2RC2K1ZfxPa3jo/GC5S02rev078gK+Po/M412lzDwqpJ8RvQqlqsOBhhJF?=
 =?us-ascii?Q?C5lBOltz1lQRNp19XmzHXpwoB8iYpPyMNXSpjEqtgwnyYK+N6NvQMHVgFayX?=
 =?us-ascii?Q?DBX5exO62GOAaSJS/L9yZRQqmtw0cA66kG4EpBmXE2R9sVQU3GoAN/5mTb1J?=
 =?us-ascii?Q?KqjHIn/hauGo5cc/45hFzEgAIlPDMFK0Yxc5s72fkTYUmZHgddd+INyiuNJa?=
 =?us-ascii?Q?k/xfK+BiU6FpG2JzkCyMZnIwW6PZk1DXSYv2+LpHBhdxIMapOr6vR/B5cfec?=
 =?us-ascii?Q?k/zUxlC2vI9jPBErYLF4RQN2qOO/h7PDUeIZCCBdHxILPjXKnmxjnZQ8JnSr?=
 =?us-ascii?Q?KeTCX1Mo7XeGEvCO6ia1WVpJ2GuWnAYZTVXxXdhSgUJuTVAlG3XG7qHb3ROr?=
 =?us-ascii?Q?jt79XyL6JSnJJPY5b+LPnos7JN9gKoP6Hnzh+gXn9169fkXtI9GFSxhDHb8O?=
 =?us-ascii?Q?5OGtbpznh7lY5ac01zWaKl9kU9XtYKBgcwm/Cesnfgj59bN85mRdqrMOE5eB?=
 =?us-ascii?Q?5Hyhe/evi6gHzJSpObQ2blLL09vANecX0pq1t7EUYqjQr3wXFw/Ztjk9nDI0?=
 =?us-ascii?Q?0c7Ts88G8G8jZtf+W9/FJib7bpWkAfPbcKWFJ5Ry4dXQgqz3IU3+WlVI1Ybf?=
 =?us-ascii?Q?C5IMOqoQwjrrByUeD673h8tonf9nXxi/FWvSFOABlRmHRo2pYRr2bg2hMc3A?=
 =?us-ascii?Q?+NFIkKE+pDkH7cB65LpzuWNxeGbax2ZozN9qCuhCVwWfjjldt7UzDcqtUhYd?=
 =?us-ascii?Q?iFz5FJtPM1iGXMd+er9f3lqhCQKnEFX2R8lXGiY9NuEMStnzqU38g1AMNO8u?=
 =?us-ascii?Q?EWabfPawaZo6YFNdWJWvCyar0rjKaZt5vh85mio5qKR2I1qlqqVAzS6pfwiO?=
 =?us-ascii?Q?sM0USOB7qyZ8Ehk3LCajA9k0bsKcRCE9DZ8IZQErADbDCRFzczc5ZO8t5nOp?=
 =?us-ascii?Q?cOFiYh/Nnr67CoJ11bjN8kzBNYJAA4ZdBm7EsQe+0XUKg1VnyB0yAdQvwu34?=
 =?us-ascii?Q?oAakFOgZjamuyoY5YT3E4x9ZsxpulmvyRpymuq/3b7AFe36lhW7BDK1Pw9Fy?=
 =?us-ascii?Q?0FF8z8Pe4dY2aWh7viAal0/9yN5ergKaOEiWwSmqz6rw4cS355+7DcdFQbm7?=
 =?us-ascii?Q?cqb4SonNnF0aw0+VzCSIup/RTQSGbwGnPQ1fcvIcCpMFoQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: aa5090ae-fe72-4e22-1502-08d93b288fdf
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5016.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jun 2021 18:06:04.9950
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7VgE5meWFFi4HcBUicSBwwXrO7/r8yha14Tor87TCptDKahuTyHfD7D6tSXrQR5T
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR15MB3776
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: _n4UPhJlDGxy2uTOAuqRcnsFkWmi_50e
X-Proofpoint-ORIG-GUID: _n4UPhJlDGxy2uTOAuqRcnsFkWmi_50e
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-06-29_11:2021-06-29,2021-06-29 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 impostorscore=0 phishscore=0 clxscore=1015 suspectscore=0 spamscore=0
 mlxscore=0 adultscore=0 priorityscore=1501 mlxlogscore=999
 lowpriorityscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2104190000 definitions=main-2106290114
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 29, 2021 at 10:57:46AM -0700, Yonghong Song wrote:
> 
> 
> On 6/29/21 10:44 AM, Martin KaFai Lau wrote:
> > On Tue, Jun 29, 2021 at 10:27:17AM -0700, Yonghong Song wrote:
> > [ ... ]
> > 
> > > > +static int bpf_iter_tcp_realloc_batch(struct bpf_tcp_iter_state *iter,
> > > > +				      unsigned int new_batch_sz)
> > > > +{
> > > > +	struct sock **new_batch;
> > > > +
> > > > +	new_batch = kvmalloc(sizeof(*new_batch) * new_batch_sz, GFP_USER);
> > > 
> > > Since we return -ENOMEM below, should we have __GFP_NOWARN in kvmalloc
> > > flags?
> > will add in v2.
> > 
> > > 
> > > > +	if (!new_batch)
> > > > +		return -ENOMEM;
> > > > +
> > > > +	bpf_iter_tcp_put_batch(iter);
> > > > +	kvfree(iter->batch);
> > > > +	iter->batch = new_batch;
> > > > +	iter->max_sk = new_batch_sz;
> > > > +
> > > > +	return 0;
> > > > +}
> > > > +
> > > [...]
> > > > +
> > > >    static int bpf_iter_tcp_seq_show(struct seq_file *seq, void *v)
> > > >    {
> > > >    	struct bpf_iter_meta meta;
> > > >    	struct bpf_prog *prog;
> > > >    	struct sock *sk = v;
> > > > +	bool slow;
> > > >    	uid_t uid;
> > > > +	int ret;
> > > >    	if (v == SEQ_START_TOKEN)
> > > >    		return 0;
> > > > +	if (sk_fullsock(sk))
> > > > +		slow = lock_sock_fast(sk);
> > > > +
> > > > +	if (unlikely(sk_unhashed(sk))) {
> > > > +		ret = SEQ_SKIP;
> > > > +		goto unlock;
> > > > +	}
> > > 
> > > I am not a tcp expert. Maybe a dummy question.
> > > Is it possible to do setsockopt() for listening socket?
> > > What will happen if the listening sock is unhashed after the
> > > above check?
> > It won't happen because the sk has been locked before doing the
> > unhashed check.
> 
> Ya, that is true. I guess I probably mean TCP_TIME_WAIT and
> TCP_NEW_SYN_RECV sockets. We cannot do setsockopt() for
> TCP_TIME_WAIT sockets since user space shouldn't be able
> to access the socket any more.
> 
> But how about TCP_NEW_SYN_RECV sockets?
_bpf_setsockopt() will return -EINVAL for non fullsock.

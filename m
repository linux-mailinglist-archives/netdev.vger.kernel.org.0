Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23F643B7760
	for <lists+netdev@lfdr.de>; Tue, 29 Jun 2021 19:45:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233897AbhF2Rrs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Jun 2021 13:47:48 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:55548 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232094AbhF2Rrq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Jun 2021 13:47:46 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15THeIQv009636;
        Tue, 29 Jun 2021 10:45:03 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=D07ZmSmaIn2mlV62/9FOz6MY8LiASNjM6fvu5GTSMc0=;
 b=bTzoR8BKFAcoQuNvfaB32tgbGdLOABetQuRbR3m4XRjeC/iXol7ZpAD3Q6h/rFM+jHXr
 TX+M22RcBw7nWunD3777Jk9zGKWF/ZmT4xXeIWtpzwiJoFbJw+CdtN2lPJwEKKAQtST1
 6Khpn8M6g5mPcqA5rTkO3xF99vkKUu/PMWk= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 39fkfgy89c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 29 Jun 2021 10:45:03 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.199) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 29 Jun 2021 10:45:02 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lCw7NN5YwH4Py7vDVnRWMU08GTwnuXSozJxG4SXfVqJsjzAcBiZlsuZEHeMapaB8I7QV6+xnVgbqcY0COfNGwQULlWxVBNF8qpyJ7VUi4iIxOgsFi4BiK0t0v14wUMNhNHpveTQE44KQmpGTBxGHYZMjJ1375Nf1/Yp74m56LG0si5DkvplCFY3D8+GCOCQzEFtIQYXxs3nt0mz4y2NS0fyx2I++OtLzJ1rWffVraQ+9l8X+SAhzslUyNzO24zJSSH1oFZFyVMdbRX8X1mqaz4FMUo9YkjxPtJ5C0qWqSCiXIhv4lciQ5YNAccIGUBAYov68Y7evl4JsPh+ZRllssA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D07ZmSmaIn2mlV62/9FOz6MY8LiASNjM6fvu5GTSMc0=;
 b=LK+hCZtfiVZaH0bv2RCPbt/AeYzHo6MuxjpphoM+HHaIPuE1+BAybyEp9zQ5v/EYn3n6vlzvu0ebKhtcDdybNOD0cSyFenl5914mTT7aUBXDe5liAaigFKUFiDz0gPnb8z9lMA6QfL3+zsTmEkTUvAy2gYVq/irIqCzX8Kb8tuA18QBNmhVgGoD3Eu5QqL9LPz6mGk/Leggd4uW5WcvGHvJQIN8BS/yk1kCMv/vzS1G9aw0sZKAO6M0NHmj0y3d2xbu4EZnmulUwb2QUFQW0VFPI+4oMbX5MwTBXzq9uV8jbAY3L3x6zRkBuaxo7zVhwTZcSdF1Q+UWa9CLeJrh35Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5016.namprd15.prod.outlook.com (2603:10b6:806:1db::19)
 by SA0PR15MB3984.namprd15.prod.outlook.com (2603:10b6:806:90::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.19; Tue, 29 Jun
 2021 17:45:01 +0000
Received: from SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::803d:ce17:853f:6ba6]) by SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::803d:ce17:853f:6ba6%7]) with mapi id 15.20.4264.026; Tue, 29 Jun 2021
 17:45:01 +0000
Date:   Tue, 29 Jun 2021 10:44:58 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Yonghong Song <yhs@fb.com>
CC:     <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Eric Dumazet <edumazet@google.com>, <kernel-team@fb.com>,
        Neal Cardwell <ncardwell@google.com>, <netdev@vger.kernel.org>,
        Yuchung Cheng <ycheng@google.com>
Subject: Re: [PATCH bpf-next 6/8] bpf: tcp: bpf iter batching and lock_sock
Message-ID: <20210629174458.2c5grwa37ehb55wo@kafai-mbp.dhcp.thefacebook.com>
References: <20210625200446.723230-1-kafai@fb.com>
 <20210625200523.726854-1-kafai@fb.com>
 <6be60772-4d2a-30b0-5ebb-f857db31c037@fb.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <6be60772-4d2a-30b0-5ebb-f857db31c037@fb.com>
X-Originating-IP: [2620:10d:c090:400::5:75f3]
X-ClientProxiedBy: SJ0PR03CA0308.namprd03.prod.outlook.com
 (2603:10b6:a03:39d::13) To SA1PR15MB5016.namprd15.prod.outlook.com
 (2603:10b6:806:1db::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:75f3) by SJ0PR03CA0308.namprd03.prod.outlook.com (2603:10b6:a03:39d::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4287.22 via Frontend Transport; Tue, 29 Jun 2021 17:45:00 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0b4dffe3-45db-4c50-fd6c-08d93b259e99
X-MS-TrafficTypeDiagnostic: SA0PR15MB3984:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR15MB398443A9E7F975639B440977D5029@SA0PR15MB3984.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: S0pXVepv9nD0psVC3YFi8RsYMHoWc34iDqYHccgu8XCEysHO1nNJxxSdeMi0e6ea+MyUXBx6lmAif/xgNOMMVjHbyKNAjB6fzDWlqnrI1MY7v0iYng84AigGbtae8B1OWOoP9BxfWNT7vL2e0e0ynPW0iR/F2lGhhXD718s18b2cRtLv4VZnkaqeXD/6Ah1hFuJEwz80mgxKqA0xn0lPEbG6/E2LWDDWlerPnLJfQ6eKYGzfKYE3IArCxMrfvs2u9Mam561xDMmJWpeZphHxZ1uZOZt6geuBTxPaOEZLiZO5D7oQyZ5FryP3+jVOlDcvR0Mm5vy8wKB7cNTHUrsYYN4zIBXRUeNxzvchT0YkoqOUDaQjSVm/oU/FMc0Z2CNXLaibD6yJ97TSCwJrzySk/eKsdDON31EkSUIwlVsjX/KpcKTiHa9SiP93gXFdENGoLE+ks9YgXoWxYTqIof3pLF/Meye6eX0alHYGsrEit4gK7d0rtwqa4NN9y8qftcUDmUPKAD+xuYtsT000gFEuioVZa8b3rmYgbgUL2zIctLVKg5+stpx5tQxMq9csk9Hfqvyu1NoJFxm7Z50odxUjgPAX7GecLJrYCwxnl5C90p78V9oWfOyXmblrAkprpDr+ofjvTiTb7qr0oVTbuQi8JQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5016.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(39860400002)(366004)(346002)(396003)(376002)(316002)(86362001)(186003)(1076003)(38100700002)(4326008)(478600001)(2906002)(6862004)(54906003)(16526019)(7696005)(52116002)(6506007)(9686003)(8676002)(5660300002)(8936002)(66946007)(6636002)(66476007)(83380400001)(66556008)(55016002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?kRDZIbd7CymKBaVetWa6jsBK7jakec6ept1rFJeOoev+0ZMjXivrAES50Ioy?=
 =?us-ascii?Q?sVdItNxB+dnJxvr/8NH4UXaXhoc1gxLKSAK0/ScuxpTj1UmH5q1IC8wnACt4?=
 =?us-ascii?Q?epIBfVvt3feD1TB1QEKH01ImOaTIdkCPECqC1sXbXf9VHYfjB7M3im+3D3Hm?=
 =?us-ascii?Q?aothsiVbD6O3d4xAGFzWEQ/tAOym8hQHqCicli90X7It4/OzlVi2BB5gWpcz?=
 =?us-ascii?Q?ZEiau4/oBP6SNRRp4wBr0Dn3LBINRwqjw9rDFfBCut8Q1/FnVoDhL1CvdsZd?=
 =?us-ascii?Q?hZEPX/DAZHnV2GgTK2i+6XPschtvhzZ1h3Uo27JluSphFdQVlHN2qpyX4KXF?=
 =?us-ascii?Q?KgA9M7p7qWwhQR0nRxh6jVm1zaCySugclk8bGZ7Midw1HQduKrrHQghgTlYf?=
 =?us-ascii?Q?hntJLiVX0fHFKA8ywes1+cvc8n1OvmRlnrDKgLdcE2P8aqXIF7CmYJRJcJOv?=
 =?us-ascii?Q?A7m1slIOn7DLoxOjtJQaLaHrCX3w1COT3tJSzpUKYFlnFVQIIQx/Tmq5uiLf?=
 =?us-ascii?Q?o/G5BfCwT/2iNHu9WNYStiVmrqcCUN7D+M6lyj7Z0pNjhs8mhoLjCou8LVuj?=
 =?us-ascii?Q?H9FWKm733IFuHg+sMnsCV+pgqHIRHvvEMK2pff4frwvruPQBxi6Zjh1wVZpO?=
 =?us-ascii?Q?mrOHbZgEnm37EhhHjWk2q+VwiYh7OzDeLl2/F8oCsIUrVe2nMogYBvHcRADy?=
 =?us-ascii?Q?xK7em2MgWfNufC2tO/Of1X9kZz+4jOobdwuDyGCIGRTJw2Ib2FJ30oZhZQkG?=
 =?us-ascii?Q?g4WR6uK+mhvAMn+pJL3m9VTngTjz3ci1xwsPMiDlVwLC+lZ6dJ2CXxhBdgA1?=
 =?us-ascii?Q?xl+8VpqUqM8tKL8A8AOQtDgmI3ae5G3OxT1pjlrRTYYFHFojUHtKE3p3c0O9?=
 =?us-ascii?Q?fK5A0/5svhr7fa8Nz37jB8STTmQ5HGwsVMKkMR62lwDhSUVY5GWtr3jGoenV?=
 =?us-ascii?Q?pB76G+i5Embo/jrByTlSAqf/NUCJCvd6A7yvSzAoWkFtdWAhTPi/9gTPdDMk?=
 =?us-ascii?Q?OQFcKHcryzKhM+Viz6MstHf8/YnceiRIIYnita5pS8Ml7GLc1+UXbMsDpvwO?=
 =?us-ascii?Q?nK1RpJLiDmE0p98UNNlu+JPDJ0SjVrsVAL9kUH8opGWdh5O3INsBoRXCp4WL?=
 =?us-ascii?Q?u2XyyDnxg+SLKtzGXvatMW6zTSVSHpUGiiit/sqqpplM4tJqIzdyRdILrcRt?=
 =?us-ascii?Q?QdzxAHvTQDgs3JPWdg8LMsv+wNrFY5KPgvkPXsVJsTgoI3O+dgqJudldeKx2?=
 =?us-ascii?Q?LdvpEtHmdSw+7ygGCVgiGiBiHMXgf9qFkkVe6Sn6Z7oYsTY/7QQH1lkzz5fZ?=
 =?us-ascii?Q?RPkS6TMJuO82Eer6O6imp12jlA9Gor1jTI17s7JV/LOYTQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b4dffe3-45db-4c50-fd6c-08d93b259e99
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5016.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jun 2021 17:45:01.2497
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: o5qWGgaDMkltn0fOJHYxHIr2Gr9MDlg+M3rC5T3nofpdm3M91AvtY4WCV60P3XX7
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR15MB3984
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: UU1D1GGeQ0poIpSZp0mLFRruVyNJa_0X
X-Proofpoint-ORIG-GUID: UU1D1GGeQ0poIpSZp0mLFRruVyNJa_0X
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-06-29_10:2021-06-29,2021-06-29 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0
 mlxlogscore=999 bulkscore=0 adultscore=0 impostorscore=0 malwarescore=0
 priorityscore=1501 clxscore=1015 spamscore=0 lowpriorityscore=0
 phishscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2104190000 definitions=main-2106290112
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 29, 2021 at 10:27:17AM -0700, Yonghong Song wrote:
[ ... ]

> > +static int bpf_iter_tcp_realloc_batch(struct bpf_tcp_iter_state *iter,
> > +				      unsigned int new_batch_sz)
> > +{
> > +	struct sock **new_batch;
> > +
> > +	new_batch = kvmalloc(sizeof(*new_batch) * new_batch_sz, GFP_USER);
> 
> Since we return -ENOMEM below, should we have __GFP_NOWARN in kvmalloc
> flags?
will add in v2.

> 
> > +	if (!new_batch)
> > +		return -ENOMEM;
> > +
> > +	bpf_iter_tcp_put_batch(iter);
> > +	kvfree(iter->batch);
> > +	iter->batch = new_batch;
> > +	iter->max_sk = new_batch_sz;
> > +
> > +	return 0;
> > +}
> > +
> [...]
> > +
> >   static int bpf_iter_tcp_seq_show(struct seq_file *seq, void *v)
> >   {
> >   	struct bpf_iter_meta meta;
> >   	struct bpf_prog *prog;
> >   	struct sock *sk = v;
> > +	bool slow;
> >   	uid_t uid;
> > +	int ret;
> >   	if (v == SEQ_START_TOKEN)
> >   		return 0;
> > +	if (sk_fullsock(sk))
> > +		slow = lock_sock_fast(sk);
> > +
> > +	if (unlikely(sk_unhashed(sk))) {
> > +		ret = SEQ_SKIP;
> > +		goto unlock;
> > +	}
> 
> I am not a tcp expert. Maybe a dummy question.
> Is it possible to do setsockopt() for listening socket?
> What will happen if the listening sock is unhashed after the
> above check?
It won't happen because the sk has been locked before doing the
unhashed check.

Thanks for the review.

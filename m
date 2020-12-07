Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CFC42D1A60
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 21:19:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726600AbgLGUPy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 15:15:54 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:49058 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725808AbgLGUPx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Dec 2020 15:15:53 -0500
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0B7KAfHm006398;
        Mon, 7 Dec 2020 12:14:53 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=uJBNZkYp+np5fY6eUDdh1KKhfwxsE2jVoicspORSJN4=;
 b=UIiTyeO9H+lxH84uvVlZ8xy4g5FKi1srRlK6o3jHie9DOdYkQJCjtEO5UwoyVeJjNams
 KJdl5oUsnINW4F2VfYWJtfebkhRl58AKZ4t+Mdo4scL3nvGNFq+gn9yWMSOkX5/xQkaJ
 8ZJh1KR/gR7ZJXGdk9x/W1++HO2Q/GapZC0= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3588ktuku9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 07 Dec 2020 12:14:52 -0800
Received: from NAM04-SN1-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 7 Dec 2020 12:14:51 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NXd0i1exXu67TeIbAyw7UJnw+oE5txZDbD9MYgTDRLdxjlvlNqhdu/8TcV170bKAFV5kVCt0OF2aJxpnDgDvzHEitSeIBPM7R8mzPKB/YR3SxG2Usg5oZjI4X3OgCWCp02kxGRO1s7q1ZC/oCZ8Nt7BjOXT5QLc8A8Cb/IMRCi7plnvCk32FebUJjkozkSfb+F2GhmAvD5eFkQ+sq1jAAfSulg8VsSQGrAQmMvWMF3Kd0bDE+vPDomvCkGg97i8uST/mZVyKW91+8p95eBa491RjfLVmnKjqVVyokVn9NdSShNcYnjrkd8AqXL67K5cip8sE4prKCc9WL+/dTWWf7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uJBNZkYp+np5fY6eUDdh1KKhfwxsE2jVoicspORSJN4=;
 b=keA1Kq5wh2r5beqPkFR2ABJ+CaX7S2uIO61SRBTQS1VNZZ0+O35tmdFzWcq6IhXkwc5bxdkMLDthf9ZpQ1MgJJx0uPuMEaAOuB+V3iqLA2at7ta3Z059OknXqCAb1wvFtBX1YuPNiTRcxfQ0ZZFvq5hYWG+MqTw4vc9+MGb0J2QlUm7Za258v0F4iD/8w8Llq7c9udKOHnAGfl+fhWoy8w/8a6U5jxJFa/b8q4trn7spws1NIlt778kFNisk1oxgL2Sqxg66jDh9PLfRKWp4pG6Ye5dgGHZIxYRFy7iCqHaloPqyaAP49nqtP85B/BTgkGUDqZRXwXDgA4nZ9kqx7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uJBNZkYp+np5fY6eUDdh1KKhfwxsE2jVoicspORSJN4=;
 b=Xb6qZESlXvftcGmfQIdZg6bNejLKXhYzuqVjGVayUuKcVd4eem2IpndXc88P2LFeo8iJgmy1gMpQO48HXJ8dGaxiauJPl4tiI1ICqyxWDgGF6jZkRGyAbnsh8fBmnGWi3XHzkPUyIIRjjlQl0CE6Fil2PUEeNaoNPvJsqvz9HXc=
Authentication-Results: amazon.co.jp; dkim=none (message not signed)
 header.d=none;amazon.co.jp; dmarc=none action=none header.from=fb.com;
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by BYAPR15MB2694.namprd15.prod.outlook.com (2603:10b6:a03:158::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.19; Mon, 7 Dec
 2020 20:14:50 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::2831:21bf:8060:a0b]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::2831:21bf:8060:a0b%7]) with mapi id 15.20.3632.023; Mon, 7 Dec 2020
 20:14:50 +0000
Date:   Mon, 7 Dec 2020 12:14:38 -0800
From:   Martin KaFai Lau <kafai@fb.com>
To:     Kuniyuki Iwashima <kuniyu@amazon.co.jp>
CC:     <ast@kernel.org>, <benh@amazon.com>, <bpf@vger.kernel.org>,
        <daniel@iogearbox.net>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <kuni1840@gmail.com>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
Subject: Re: [PATCH v1 bpf-next 03/11] tcp: Migrate
 TCP_ESTABLISHED/TCP_SYN_RECV sockets in accept queues.
Message-ID: <20201207201438.kdlfdspusadadfvi@kafai-mbp.dhcp.thefacebook.com>
References: <20201205014241.afrcicgewlnyrzfu@kafai-mbp.dhcp.thefacebook.com>
 <20201205160307.91179-1-kuniyu@amazon.co.jp>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201205160307.91179-1-kuniyu@amazon.co.jp>
X-Originating-IP: [2620:10d:c090:400::5:e1c3]
X-ClientProxiedBy: MW4PR03CA0077.namprd03.prod.outlook.com
 (2603:10b6:303:b6::22) To BY5PR15MB3571.namprd15.prod.outlook.com
 (2603:10b6:a03:1f6::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:e1c3) by MW4PR03CA0077.namprd03.prod.outlook.com (2603:10b6:303:b6::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.18 via Frontend Transport; Mon, 7 Dec 2020 20:14:49 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 231c3b17-c538-440d-7775-08d89aecc094
X-MS-TrafficTypeDiagnostic: BYAPR15MB2694:
X-Microsoft-Antispam-PRVS: <BYAPR15MB2694011B44121C42509994BED5CE0@BYAPR15MB2694.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pYdpWZsmybwA8pXd+H1FdPRugwTepJ3QRlpp8fmAym0Bq5F+Rg6GiMOIaIwuSCmAAOGJi0vkVag7ja6OUszTdVO3zSFExgE6+VmwQ+T0fGQ58mSEFWR4/3prxsMNvyCcc1ifTCdFQcJWRcj6OOa5QagRZuEbvaqBNExA/YDwh1PheWYTanoedkj/hjLGr/KX4yOm0Bqib/kMd8DkCXZeBkaXb/EhV+X7d2QB9sM+Rqzr1EmhBKmTajhc70H8FNwvvxB8e5tbnqqaUiVpAItLv8y7krjQEb/SF13DnipL79u0yAV+bkdULAVn4fYfAk35
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(136003)(346002)(39860400002)(396003)(376002)(478600001)(83380400001)(2906002)(7696005)(6666004)(66556008)(7416002)(4326008)(8676002)(52116002)(55016002)(8936002)(1076003)(86362001)(16526019)(3716004)(6916009)(9686003)(66946007)(5660300002)(186003)(316002)(66476007)(6506007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?09RkPHvZgjX8hQ52QWu07Zn0otbuwF2fnvkLVEdLcjCgxhThl3DdYuDds8g2?=
 =?us-ascii?Q?MXjAIADQ+jJ1Zlgi6ut9Yxp+qngLi+7RwV/w+HZGB1C8Ek9ZEZyFld2kl/dq?=
 =?us-ascii?Q?kbGCOeeady/7C2XW4/sXtGjY+nU5k/KVtu+ofkzd6mmB8b5f9g4JU0OtpQEc?=
 =?us-ascii?Q?xjQEqVMJ8Ab49p0BZtt8YSIBwqyDvVzH6QXKT9DaQUZUIJTArGTOkXPifz1E?=
 =?us-ascii?Q?XwNCbAb8ZFqlktf+Ds3ubuMxXXn8rE/mkVpyp5NkDFuuEbQzT8Wkus6f5Ub0?=
 =?us-ascii?Q?6/uTfhqy1jSaFpQvWvqNUbXQtdxb6u3tTf15DpyYou9WnTFeA6UZW2AVbmgz?=
 =?us-ascii?Q?GRYct9i04iET5mGJ8ZYbF5+SFmTqzjR7tVMA/UWPZa8wF2gKOiTw+aetL7CZ?=
 =?us-ascii?Q?z0lIIwXXheJ49lpo49rS223IbePKTTtDriNUId7mrrT2t4CK2QK0eh21n1VV?=
 =?us-ascii?Q?xCQZm9WPpyz7MbkS4u7Guc/0dy/NwBW5+E5yV029enmc29WHW/1nb89MyNe1?=
 =?us-ascii?Q?p1FSHWUKoBDina9xqTdfroXL95CyyKbimwziP3mCvZX5UFZ2Hi+f9cgDq7+y?=
 =?us-ascii?Q?vkV9gq3mE8jCZBBSycC8+4Ic2JX6RhRelQ/cT+lfKuVcgsuWfkr8iwVT5H2p?=
 =?us-ascii?Q?f3wAscPL83BTYndNkrwKy/ujeDpd8+ZIzySicyWvoP5HWHE1hy2eSzdMBuD9?=
 =?us-ascii?Q?3bE0rmtkTlt2jKgnFHWCCKt5w2jrW2NKDH2nrg1Dx2c83g0MTT/t6fHS/YU4?=
 =?us-ascii?Q?SH4pxO+v3tK5zuJhXKEPinlkbeWZxnLy+cUztN/xYnGmCi3R2robxXqu0mdq?=
 =?us-ascii?Q?ScOIf+1M0aZjFvEa4vQYgKKrzQp+XTooA7hUMEU+Ta6sEIxJO0DTF0qZGqlE?=
 =?us-ascii?Q?rjqVhCBSw0xtZHltLJd2TICMT82UvqT1hgdrLcKoUnXkDWMNsJsVjRRjP47Q?=
 =?us-ascii?Q?zxvJThrMewN/DgQJBryA7wJVNmyu2wq80a2VtUuvTgmahrfM2wCRZkibPkr8?=
 =?us-ascii?Q?ah+zRQrsadAojz7wlXWmuqhxkA=3D=3D?=
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB3571.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Dec 2020 20:14:50.4951
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-Network-Message-Id: 231c3b17-c538-440d-7775-08d89aecc094
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rPdPVA4xpaNvAf8jUDLeCVrOQdHPuadh2lVF0fhRso6BBnIrIbLlp7S+uFanuDap
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2694
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-07_16:2020-12-04,2020-12-07 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0
 impostorscore=0 mlxscore=0 lowpriorityscore=0 suspectscore=5 clxscore=1015
 phishscore=0 adultscore=0 mlxlogscore=999 bulkscore=0 priorityscore=1501
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012070130
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Dec 06, 2020 at 01:03:07AM +0900, Kuniyuki Iwashima wrote:
> From:   Martin KaFai Lau <kafai@fb.com>
> Date:   Fri, 4 Dec 2020 17:42:41 -0800
> > On Tue, Dec 01, 2020 at 11:44:10PM +0900, Kuniyuki Iwashima wrote:
> > [ ... ]
> > > diff --git a/net/core/sock_reuseport.c b/net/core/sock_reuseport.c
> > > index fd133516ac0e..60d7c1f28809 100644
> > > --- a/net/core/sock_reuseport.c
> > > +++ b/net/core/sock_reuseport.c
> > > @@ -216,9 +216,11 @@ int reuseport_add_sock(struct sock *sk, struct sock *sk2, bool bind_inany)
> > >  }
> > >  EXPORT_SYMBOL(reuseport_add_sock);
> > >  
> > > -void reuseport_detach_sock(struct sock *sk)
> > > +struct sock *reuseport_detach_sock(struct sock *sk)
> > >  {
> > >  	struct sock_reuseport *reuse;
> > > +	struct bpf_prog *prog;
> > > +	struct sock *nsk = NULL;
> > >  	int i;
> > >  
> > >  	spin_lock_bh(&reuseport_lock);
> > > @@ -242,8 +244,12 @@ void reuseport_detach_sock(struct sock *sk)
> > >  
> > >  		reuse->num_socks--;
> > >  		reuse->socks[i] = reuse->socks[reuse->num_socks];
> > > +		prog = rcu_dereference(reuse->prog);
> > Is it under rcu_read_lock() here?
> 
> reuseport_lock is locked in this function, and we do not modify the prog,
> but is rcu_dereference_protected() preferable?
> 
> ---8<---
> prog = rcu_dereference_protected(reuse->prog,
> 				 lockdep_is_held(&reuseport_lock));
> ---8<---
It is not only reuse->prog.  Other things also require rcu_read_lock(),
e.g. please take a look at __htab_map_lookup_elem().

The TCP_LISTEN sk (selected by bpf to be the target of the migration)
is also protected by rcu.

I am surprised there is no WARNING in the test.
Do you have the needed DEBUG_LOCK* config enabled?

> > >  		if (sk->sk_protocol == IPPROTO_TCP) {
> > > +			if (reuse->num_socks && !prog)
> > > +				nsk = i == reuse->num_socks ? reuse->socks[i - 1] : reuse->socks[i];
> > > +
> > >  			reuse->num_closed_socks++;
> > >  			reuse->socks[reuse->max_socks - reuse->num_closed_socks] = sk;
> > >  		} else {
> > > @@ -264,6 +270,8 @@ void reuseport_detach_sock(struct sock *sk)
> > >  		call_rcu(&reuse->rcu, reuseport_free_rcu);
> > >  out:
> > >  	spin_unlock_bh(&reuseport_lock);
> > > +
> > > +	return nsk;
> > >  }
> > >  EXPORT_SYMBOL(reuseport_detach_sock);
> > >  
> > > diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
> > > index 1451aa9712b0..b27241ea96bd 100644
> > > --- a/net/ipv4/inet_connection_sock.c
> > > +++ b/net/ipv4/inet_connection_sock.c
> > > @@ -992,6 +992,36 @@ struct sock *inet_csk_reqsk_queue_add(struct sock *sk,
> > >  }
> > >  EXPORT_SYMBOL(inet_csk_reqsk_queue_add);
> > >  
> > > +void inet_csk_reqsk_queue_migrate(struct sock *sk, struct sock *nsk)
> > > +{
> > > +	struct request_sock_queue *old_accept_queue, *new_accept_queue;
> > > +
> > > +	old_accept_queue = &inet_csk(sk)->icsk_accept_queue;
> > > +	new_accept_queue = &inet_csk(nsk)->icsk_accept_queue;
> > > +
> > > +	spin_lock(&old_accept_queue->rskq_lock);
> > > +	spin_lock(&new_accept_queue->rskq_lock);
> > I am also not very thrilled on this double spin_lock.
> > Can this be done in (or like) inet_csk_listen_stop() instead?
> 
> It will be possible to migrate sockets in inet_csk_listen_stop(), but I
> think it is better to do it just after reuseport_detach_sock() becuase we
> can select a different listener (almost) every time at a lower cost by
> selecting the moved socket and pass it to inet_csk_reqsk_queue_migrate()
> easily.
I don't see the "lower cost" point.  Please elaborate.

> 
> sk_hash of the listener is 0, so we would have to generate a random number
> in inet_csk_listen_stop().
If I read it correctly, it is also passing 0 as the sk_hash to
bpf_run_sk_reuseport() from reuseport_detach_sock().

Also, how is the sk_hash expected to be used?  I don't see
it in the test.

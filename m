Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8235F2D6695
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 20:35:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393442AbgLJTe5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Dec 2020 14:34:57 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:6454 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2390230AbgLJTex (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Dec 2020 14:34:53 -0500
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0BAJWUl1021432;
        Thu, 10 Dec 2020 11:33:50 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=jRp1mWiYAlpDCBfzDr0HF6o7h2Pw2lBJM/h3xa2AOqQ=;
 b=AoNBnQ4o2d0YrW33VqLxOhhsj6+b7p2Lxg8+JnAM22SNdfI12uJ7bIN0Oud5YY6HfIVd
 9o8mFqc3HkoGr70JIkDXutVBlDHZyRSQoSX7lfLRcXHTlei3a/6xdD1vArBNhKNHbgOs
 vjWnNMxKYE/I9KMk3Ds3pOF2y/wy9IqgSqI= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 35brnbghnm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 10 Dec 2020 11:33:50 -0800
Received: from NAM04-BN3-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.230) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 10 Dec 2020 11:33:49 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JqhmtIybrdIGQ+uGoPLIaqVqTIw4vBDeF3lOscB8ie+s1/oAdcnnEL87OH8KTgSQvJBqXz94U97B6utBS1/gR7t3utMpSmWMusGqvtYeXRe7fCptj/MSCQoXLppL0u4XutMMg67IQDtZ2PqMJ1ddGnx/o4dBuC2oY1DCP1+M6aiYmmZl6aI5py6kyIwZz6Qcw4unOSNboGcUc3Y0K0Z8F+Tfia1zEBW1h+oYCYhHJMJ5WYPaH8uS8sxf2Cfh+k6RvOgW+wIYGrP8xi8GmH2aDRPdXn9UZYR135vJYYpo7bJ73UNm9hknBswHutWwmG/SnWcBesybRhqipoUzHAL9VQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jRp1mWiYAlpDCBfzDr0HF6o7h2Pw2lBJM/h3xa2AOqQ=;
 b=ZQRp2rr03se07p8kJIi9TsNt+7HkigNwMzLwZDfFgDymyavwDFpU7ziR/IbN7gKQJc3HNbQqW2a6ZuAG1J9iRewitweJoJK+0K+ldU2uvTxzgv7rTVM7HNIRD1oupO+et/bBsk9WTXbkuFxtkmX9BpUi3TP/TMJX2Kq0JqR76TfXvPM3rJUKsFQREG7tZZQflxnJTe5wEUvdnIp1D66uHxDB01L0MEuMMUE64zkXRGzconE9BLfpNw4eyeVQENazgW6peiTZlb3eWt99ubVq8CL241+/Xk7THfC+zD0gA/LxIkni6JtSctU6CPyCAeuw0V2nfkFYorimNSrAt0wdog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jRp1mWiYAlpDCBfzDr0HF6o7h2Pw2lBJM/h3xa2AOqQ=;
 b=ZqzqcOinDMWVvzMeZSW4IXCYsMul5CqXHFDVjkFO6pverWanjac/ChYnL9lm/bUa/T7P9KQbwef5jR+scIA2oVJ7cOjPoFxIhQYKgdAPIESfIk6jnk29r/BxNgbAcQ/5o9OwwF6oMQCgQS8rXxAh8BLsioDVNsMOLXB7TbSr9mo=
Authentication-Results: amazon.co.jp; dkim=none (message not signed)
 header.d=none;amazon.co.jp; dmarc=none action=none header.from=fb.com;
Received: from CH2PR15MB3573.namprd15.prod.outlook.com (2603:10b6:610:e::28)
 by CH2PR15MB3736.namprd15.prod.outlook.com (2603:10b6:610:6::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.19; Thu, 10 Dec
 2020 19:33:48 +0000
Received: from CH2PR15MB3573.namprd15.prod.outlook.com
 ([fe80::81f0:e22:522e:9dd]) by CH2PR15MB3573.namprd15.prod.outlook.com
 ([fe80::81f0:e22:522e:9dd%7]) with mapi id 15.20.3632.021; Thu, 10 Dec 2020
 19:33:47 +0000
Date:   Thu, 10 Dec 2020 11:33:40 -0800
From:   Martin KaFai Lau <kafai@fb.com>
To:     Kuniyuki Iwashima <kuniyu@amazon.co.jp>
CC:     <ast@kernel.org>, <benh@amazon.com>, <bpf@vger.kernel.org>,
        <daniel@iogearbox.net>, <davem@davemloft.net>,
        <edumazet@google.com>, <eric.dumazet@gmail.com>, <kuba@kernel.org>,
        <kuni1840@gmail.com>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>
Subject: Re: [PATCH v1 bpf-next 03/11] tcp: Migrate
 TCP_ESTABLISHED/TCP_SYN_RECV sockets in accept queues.
Message-ID: <20201210193340.x6qdykdalhdebxv3@kafai-mbp.dhcp.thefacebook.com>
References: <20201210015319.e6njlcwuhfpre3bn@kafai-mbp.dhcp.thefacebook.com>
 <20201210055810.60068-1-kuniyu@amazon.co.jp>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201210055810.60068-1-kuniyu@amazon.co.jp>
X-Originating-IP: [2620:10d:c090:400::5:ad7]
X-ClientProxiedBy: BYAPR11CA0071.namprd11.prod.outlook.com
 (2603:10b6:a03:80::48) To CH2PR15MB3573.namprd15.prod.outlook.com
 (2603:10b6:610:e::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:ad7) by BYAPR11CA0071.namprd11.prod.outlook.com (2603:10b6:a03:80::48) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12 via Frontend Transport; Thu, 10 Dec 2020 19:33:46 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e6fb516e-24e2-4f7b-0f5d-08d89d4283e3
X-MS-TrafficTypeDiagnostic: CH2PR15MB3736:
X-Microsoft-Antispam-PRVS: <CH2PR15MB3736BA1D86EE385708AC629FD5CB0@CH2PR15MB3736.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bmB2BsopaBGt6b97aleCInGHyh29pc53QEZqmzBahpATYQiYyhQNntjKFQVMX+BVUw59XCUvEd0vN32o45OwNYqhj1aGHy1g/ya88zJth061lIhwLJtanAwn1L2l00bSlu2bECvnerOb6Z/OGMtbcvxMymH9YDuKTWTmVVlJhzZ8KC2L/B3PJ2gngI0JAYoUI3f+V1PebbgjfnhfYrEsLFyVzlkIwgJasBucLAudNL2me0ley4/nITha3/ziHiDPjf/V/u4WjUPcPTaWrIX3Cstr80MibyHuQrYjkD3/rNb/z03llFTVv9fOITvtJffujjKmwWPSOeAF8RLUYYLzcQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR15MB3573.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(346002)(136003)(376002)(66946007)(6506007)(66556008)(5660300002)(6916009)(8676002)(7416002)(16526019)(7696005)(66476007)(2906002)(55016002)(4326008)(186003)(52116002)(6666004)(83380400001)(1076003)(8936002)(86362001)(508600001)(9686003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?BsjyyJID4n6oxlN7lS+0El5PDuH6Dmdt0G0t5ClJHBURAIpv49v6CJ5OTqdW?=
 =?us-ascii?Q?wsuAmiouqomt3WyzKHdnJRhCL5+EdGiksrFOL1O4Kvm1dSUGlBzVyKOPKpHr?=
 =?us-ascii?Q?ILGzIOozHxIQvh5nOEwmR2QLEXHrjykR8T5vPKvYr4oCUyQbQovmWysffnGz?=
 =?us-ascii?Q?Lv+6c3/oA6yVxgOBCpnRGoFMfIhaoiZNQ5Rg+MrJQLMhBmiQPUKyD45pEiRf?=
 =?us-ascii?Q?UcLsOUeawybwqS0Weg2+f9yjgR6m4O2lVDKBbjN2HQyiQSRVPCeT/yto96yk?=
 =?us-ascii?Q?dgMDX7ufXDJvOPab/fgXeQTgrnnM7/KhhX4Z2eibtoaq1YHpjcrq9cD6ZrhY?=
 =?us-ascii?Q?TotKjGL43HrdVAfo3E3inoTy/wl+fjnmu/z7h7feckUP9RbOYbr6a1m7bC/W?=
 =?us-ascii?Q?AXdA7Sn0qyg2Ry3zluyB2KLvd4gKgXAsEpt6U/Bl2/BdMB/vGhntnSELxR45?=
 =?us-ascii?Q?b2mq1nCLcU2EEinUgV5TkAr65XLpHCL02s5BZSFrzadtHrvn4EVZLonGx9nT?=
 =?us-ascii?Q?r3M+DGVmP/nHMldQL49Fx6RigJmiakN/bWxS5BSBRoCexck16dFdKi2Re6vx?=
 =?us-ascii?Q?Kih1qOijv9zS933GVwVYmaJ4Q+jlkdfnPT1goqJ68irTK85qd3cyQO56kz/O?=
 =?us-ascii?Q?nmJugKn8J7u3a8dSZ8PRVZUcjQz3QNhDJv7rlhq3yui8dbYEkvKkdQQ6zgHe?=
 =?us-ascii?Q?fJDwnynq2TG1U7BswOnTNXnZ3XJE2CfIvfz3iSfNtVRjwNlegJxT2Tk7eN2n?=
 =?us-ascii?Q?kj+/g+XNEhZOB/AdQJ25bi96ISOv8vdpxiwMO2VuxL4jp2+mdqpk5LevjX8w?=
 =?us-ascii?Q?ovmeHqbP8zyi0wWTZdVuw5ZManwE7N52r0Ter9xqx2dNqSkf1s7mp64CbJBw?=
 =?us-ascii?Q?pwBiJTzrZ4urdcAjn7u2N6kPde1nSAOaGPKM9RiV2oT+F0s6oaq9DB26aot2?=
 =?us-ascii?Q?O++/0ginn3jD7+OeVtJf+Gv3J2sJhOg5QMpu6gdfcrg9zrBH6YPK6Nqn+yAi?=
 =?us-ascii?Q?2/FBX5A7viZR6B/gbYl9yF6c7w=3D=3D?=
X-MS-Exchange-CrossTenant-AuthSource: CH2PR15MB3573.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Dec 2020 19:33:47.8413
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-Network-Message-Id: e6fb516e-24e2-4f7b-0f5d-08d89d4283e3
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +SDFmZqNtwSAua76vHamaV7Jt24/MhTvPt1mZqV0xSH0hd85QNlXBP92TxFv5Jve
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR15MB3736
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-10_08:2020-12-09,2020-12-10 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 mlxlogscore=575 priorityscore=1501 impostorscore=0 suspectscore=1
 spamscore=0 clxscore=1015 mlxscore=0 phishscore=0 bulkscore=0 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012100123
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 10, 2020 at 02:58:10PM +0900, Kuniyuki Iwashima wrote:

[ ... ]

> > > I've implemented one-by-one migration only for the accept queue for now.
> > > In addition to the concern about TFO queue,
> > You meant this queue:  queue->fastopenq.rskq_rst_head?
> 
> Yes.
> 
> 
> > Can "req" be passed?
> > I did not look up the lock/race in details for that though.
> 
> I think if we rewrite freeing TFO requests part like one of accept queue
> using reqsk_queue_remove(), we can also migrate them.
> 
> In this patchset, selecting a listener for accept queue, the TFO queue of
> the same listener is also migrated to another listener in order to prevent
> TFO spoofing attack.
> 
> If the request in the accept queue is migrated one by one, I am wondering
> which should the request in TFO queue be migrated to prevent attack or
> freed.
> 
> I think user need not know about keeping such requests in kernel to prevent
> attacks, so passing them to eBPF prog is confusing. But, redistributing
> them randomly without user's intention can make some irrelevant listeners
> unnecessarily drop new TFO requests, so this is also bad. Moreover, freeing
> such requests seems not so good in the point of security.
The current behavior (during process restart) is also not carrying this
security queue.  Not carrying them in this patch will make it
less secure than the current behavior during process restart?
Do you need it now or it is something that can be considered for later
without changing uapi bpf.h?

> > > ---8<---
> > > diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
> > > index a82fd4c912be..d0ddd3cb988b 100644
> > > --- a/net/ipv4/inet_connection_sock.c
> > > +++ b/net/ipv4/inet_connection_sock.c
> > > @@ -1001,6 +1001,29 @@ struct sock *inet_csk_reqsk_queue_add(struct sock *sk,
> > >  }
> > >  EXPORT_SYMBOL(inet_csk_reqsk_queue_add);
> > >  
> > > +static bool inet_csk_reqsk_queue_migrate(struct sock *sk, struct sock *nsk, struct request_sock *req)
> > > +{
> > > +       struct request_sock_queue *queue = &inet_csk(nsk)->icsk_accept_queue;
> > > +       bool migrated = false;
> > > +
> > > +       spin_lock(&queue->rskq_lock);
> > > +       if (likely(nsk->sk_state == TCP_LISTEN)) {
> > > +               migrated = true;
> > > +
> > > +               req->dl_next = NULL;
> > > +               if (queue->rskq_accept_head == NULL)
> > > +                       WRITE_ONCE(queue->rskq_accept_head, req);
> > > +               else
> > > +                       queue->rskq_accept_tail->dl_next = req;
> > > +               queue->rskq_accept_tail = req;
> > > +               sk_acceptq_added(nsk);
> > > +               inet_csk_reqsk_queue_migrated(sk, nsk, req);
> > need to first resolve the question raised in patch 5 regarding
> > to the update on req->rsk_listener though.
> 
> In the unhash path, it is also safe to call sock_put() for the old listner.
> 
> In inet_csk_listen_stop(), the sk_refcnt of the listener >= 1. If the
> listener does not have immature requests, sk_refcnt is 1 and freed in
> __tcp_close().
> 
>   sock_hold(sk) in __tcp_close()
>   sock_put(sk) in inet_csk_destroy_sock()
>   sock_put(sk) in __tcp_clsoe()
I don't see how it is different here than in patch 5.
I could be missing something.

Lets contd the discussion on the other thread (patch 5) first.

> 
> 
> > > +       }
> > > +       spin_unlock(&queue->rskq_lock);
> > > +
> > > +       return migrated;
> > > +}
> > > +
> > >  struct sock *inet_csk_complete_hashdance(struct sock *sk, struct sock *child,
> > >                                          struct request_sock *req, bool own_req)
> > >  {
> > > @@ -1023,9 +1046,11 @@ EXPORT_SYMBOL(inet_csk_complete_hashdance);
> > >   */
> > >  void inet_csk_listen_stop(struct sock *sk)
> > >  {
> > > +       struct sock_reuseport *reuseport_cb = rcu_access_pointer(sk->sk_reuseport_cb);
> > >         struct inet_connection_sock *icsk = inet_csk(sk);
> > >         struct request_sock_queue *queue = &icsk->icsk_accept_queue;
> > >         struct request_sock *next, *req;
> > > +       struct sock *nsk;
> > >  
> > >         /* Following specs, it would be better either to send FIN
> > >          * (and enter FIN-WAIT-1, it is normal close)
> > > @@ -1043,8 +1068,19 @@ void inet_csk_listen_stop(struct sock *sk)
> > >                 WARN_ON(sock_owned_by_user(child));
> > >                 sock_hold(child);
> > >  
> > > +               if (reuseport_cb) {
> > > +                       nsk = reuseport_select_migrated_sock(sk, req_to_sk(req)->sk_hash, NULL);
> > > +                       if (nsk) {
> > > +                               if (inet_csk_reqsk_queue_migrate(sk, nsk, req))
> > > +                                       goto unlock_sock;
> > > +                               else
> > > +                                       sock_put(nsk);
> > > +                       }
> > > +               }
> > > +
> > >                 inet_child_forget(sk, req, child);
> > >                 reqsk_put(req);
> > > +unlock_sock:
> > >                 bh_unlock_sock(child);
> > >                 local_bh_enable();
> > >                 sock_put(child);
> > > ---8<---
> > > 
> > > 
> > > > > >   5. lock the accept queue of the new listener
> > > > > >   6. splice requests and increment refcount
> > > > > >   7. unlock
> > > > > > 
> > > > > > Also, I think splicing is better to keep the order of requests. Adding one
> > > > > > by one reverses it.
> > > > > It can keep the order but I think it is orthogonal here.

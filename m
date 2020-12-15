Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 274E52DA68F
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 04:01:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726986AbgLODAJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 22:00:09 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:19078 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726665AbgLOC7y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Dec 2020 21:59:54 -0500
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0BF2sUve027060;
        Mon, 14 Dec 2020 18:58:48 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=++a5M3ledHkDkUHyFMouzPrhfuI6NTjYbI92FIhQQNw=;
 b=HRoCMlARtGyK31U3G8kLl3jaLiRj8NJiF7mWIvYp9tLmZzC6HrrLIYmYKyigha3pvwwu
 ztEmrn4k8yU1i0SldED5SwxnbU8QFCct4GsM7cELi/fsn/8LTWERZB8NyZEssy6NqWgX
 7qmImNl8Y6A/unHSB10ww+cAJYzAS0peElo= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 35dkwqyy2x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 14 Dec 2020 18:58:48 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 14 Dec 2020 18:58:47 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RfEIMF/M3+25fquiESEAj+DBjgIzZ+lmegLy2Cr2sRlZwcDp92Sr7lQ6HUdVAh6XQ9jF9A7pNAV6plJDmldqptWIHcp3FIe+iy3dLY4dPxi9UzUjDdq3+wvY9qh+Gf+8Iu7KkBkT8eamBBIEdF4ZIvT1qTu/MgNw23PLJe0UZ/xfweikJIvl48Ny+vU1oRHNSw7Ou4TdpoXF6/THPduen2IFJcbFsCpmAGSgTaOjNZCMfrO3VlFqeyuhSPWPK3+i+AmxHgaHu7Md4lP7SvAzXEQxMSAf2pHT9OP/6HTYBAwI4ZiNUZ5soI55MSh0j0gx1GF09HjFeqBgtsz4Ifx1Zw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=++a5M3ledHkDkUHyFMouzPrhfuI6NTjYbI92FIhQQNw=;
 b=JMp/CxQGYrvVBBrs98E2YFAqEEPkp/yJHmB8UoPhTlnGMXqbgQ5XTxh9nkvkVZ5UtueB+cT9EpfYvbDbqqUQrOa41npRjJJ9w/pViump1yJqyQU+PS3oaXZkIyU/l6MYZqUDsh+pE6817p7VamVKRllSpKrfrcyt0YvMDx183JflM4RoDHen1cFoxJEnxQ7c5wkmd/ma3rFK+oGeFjI8e65hVKNFqk3dv+e8wPerNlH3znyZJZGz+v/d6+ArTWrFuRXDXknMV+39PmbS2gxZTrMEU03adbgTaQKrPsi+0sE8SX3r+IbZ+idBA9wdCDkZj9tjuDX+OFGgH4OdIw+V2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=++a5M3ledHkDkUHyFMouzPrhfuI6NTjYbI92FIhQQNw=;
 b=KqyfBwa3Mv9U0DNKIdRJ4aUIwOdmG51ZL/He7/5EnQqKV/ZpLOGsEMLRBnjopPDUwYJX/M8DhlLXsa+EhhwnDK8c61XM1gDR8vZNdbZv2SF0JgenSnzqld1IW0TW5U+O3WQjMMoz54nzL62e+m8scO0+de2Gyx+ukasuXSvor3c=
Authentication-Results: amazon.co.jp; dkim=none (message not signed)
 header.d=none;amazon.co.jp; dmarc=none action=none header.from=fb.com;
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by BYAPR15MB3415.namprd15.prod.outlook.com (2603:10b6:a03:112::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.15; Tue, 15 Dec
 2020 02:58:43 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::217e:885b:1cef:e1f7]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::217e:885b:1cef:e1f7%7]) with mapi id 15.20.3654.025; Tue, 15 Dec 2020
 02:58:43 +0000
Date:   Mon, 14 Dec 2020 18:58:37 -0800
From:   Martin KaFai Lau <kafai@fb.com>
To:     Kuniyuki Iwashima <kuniyu@amazon.co.jp>
CC:     <ast@kernel.org>, <benh@amazon.com>, <bpf@vger.kernel.org>,
        <daniel@iogearbox.net>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <kuni1840@gmail.com>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
Subject: Re: [PATCH v1 bpf-next 05/11] tcp: Migrate TCP_NEW_SYN_RECV requests.
Message-ID: <20201215025837.k2cuhykmz6h46fud@kafai-mbp.dhcp.thefacebook.com>
References: <20201210184915.4codwsoufxdhtj3o@kafai-mbp.dhcp.thefacebook.com>
 <20201214170313.50197-1-kuniyu@amazon.co.jp>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201214170313.50197-1-kuniyu@amazon.co.jp>
X-Originating-IP: [2620:10d:c090:400::5:2c43]
X-ClientProxiedBy: SJ0PR05CA0119.namprd05.prod.outlook.com
 (2603:10b6:a03:334::34) To BY5PR15MB3571.namprd15.prod.outlook.com
 (2603:10b6:a03:1f6::32)
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:2c43) by SJ0PR05CA0119.namprd05.prod.outlook.com (2603:10b6:a03:334::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3676.13 via Frontend Transport; Tue, 15 Dec 2020 02:58:42 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 547d12ec-55be-41ea-f7d4-08d8a0a55554
X-MS-TrafficTypeDiagnostic: BYAPR15MB3415:
X-Microsoft-Antispam-PRVS: <BYAPR15MB341531DE791D7DC690F8B412D5C60@BYAPR15MB3415.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:2657;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zxpzafPmGAWUcb45oTSYxnvDScDiOzMb/bgRCki5GxRsh5vn1gDTfOYIAwaNy9rVrOY99N1B8etog7fjS6O4uzDdg0tfmVHGGEl6yweZKxJEOnddXnQb/SPhmvqyJqjQR4CJCKyUTxmL6mjaNZkEp/O4pE4ETDdklVDia7hj1jg6SA5PsE9MFzN/AsGfhci1saj7EN4bQsQG1PvPJMaZQf6AdTA1nYE8l960oKMdN0gko1LcowBf05slRI32IlqS20Q2E88DwIHK1pMXHn4EGysZhLV4G5ozYg+TF57ZnLqun1K7R9JBQoSTGJsREtQ5hMz75T1VrRr2QiBy5LqiS2BbiKV+Mvt90SiV6pWxx8RVhhQCMJFRl6eoPz/f1atasN2Dq9PpHHHHMKpxCuVIJg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(366004)(136003)(5660300002)(7416002)(8676002)(6666004)(86362001)(16526019)(55016002)(186003)(9686003)(508600001)(6506007)(66476007)(66946007)(6916009)(4326008)(1076003)(966005)(2906002)(52116002)(8936002)(83380400001)(7696005)(66556008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?8YaR/z6UYcyf/cjdcYMmtvFuTOJKQbXIdaoAOBi3nlvdxxG/JF+wR3I3bgBY?=
 =?us-ascii?Q?vkbiidLJIcvdJbFwijCRR2hm1875F9YOM2NqMy2aFNoL/F2k/YrgGS97kFAr?=
 =?us-ascii?Q?o/JQQA2EBcONb03PiRw3AQutykxQ6tJhcyUstDsbIkViNPRqZmo6DAzJYCg8?=
 =?us-ascii?Q?9k6NS3CGBgE6qFSbV6dqHcW2eLjH8EQDWiDJ+51kYzojy8tEZaCSGND0CVQM?=
 =?us-ascii?Q?wMdkl1T+9zXRfbRjBZEHFn/gyLftdQ6gAlLJSpFsOfc1DCZqv3Rlc7Q31WVB?=
 =?us-ascii?Q?FIofpEXuMq5so4ujqig5dCykO/42FRrZRlu1Bfg9JHbAm4UFKI6bNfqmh2PM?=
 =?us-ascii?Q?NGmA4qei3Atx9TgO6OoLGW4AndJLwNz5FzndpkAxBGCi6DgfS8nfcnP5x3iR?=
 =?us-ascii?Q?toGfAixLcFnELzxWm9aYQKYERx5/5QoYG16C4T4hJ57VLOvT/O1y9fifHAFK?=
 =?us-ascii?Q?jEJrPLpuFZcMPumzVtllQL6JiBfoa+F1kEVr9qGCJg5LIbTL2+npHvuI/X5T?=
 =?us-ascii?Q?URSUfICPQjEIdfkaUd1aJePzZwm1edopKk/XkEm35Qix/9O+QqE5tMkpEn2p?=
 =?us-ascii?Q?6yuySr1kg7rxJRIhltXZgxXJSbZbPof36qLPx5TTaM1wrSUNGLPUDr+7y3Xn?=
 =?us-ascii?Q?sbZuaZA374lJd0EDA3ckKCzV+QYH/NVN1W+iu/O9WzAGbnaCw9G0n4/o9WaW?=
 =?us-ascii?Q?bViR+TRGxlumTIifvhqJosPM7sQWFyzIPcixYi2Vbcp1IQ5pl4Vlo6eYhuUG?=
 =?us-ascii?Q?HJy35Y9FXxN6/cus/yiWHndXwmDeCPMoFxRzt065If6umSUYJqNvcsnxZMMs?=
 =?us-ascii?Q?2MEvtNwfTaHer9dStOGyHeIrAHOpJjIk0LugRTnOQy2Tg2pvkwYINAwphz4p?=
 =?us-ascii?Q?MckncYV/+zQ1wZpCYzWvuuINl6fY5MH4AwJf40Rdviq2X9Y+EWO+hsiTCtHt?=
 =?us-ascii?Q?QqXM4JHjwW3yweRU6JmgTjnEdkb/F+IXQqo1NEhwy6HnU2xoPBMFcwrLg4CO?=
 =?us-ascii?Q?i1Ja3jkew5iOFLfmPe5JRLT/xw=3D=3D?=
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB3571.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Dec 2020 02:58:43.3545
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-Network-Message-Id: 547d12ec-55be-41ea-f7d4-08d8a0a55554
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UCiNOPRTk8ctkhLBFKGj32uYWFfj81JmmBsqc/DNjYoKJHSNGMLgzJtRBIt6wb/A
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3415
X-OriginatorOrg: fb.com
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-15_03:2020-12-11,2020-12-15 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0
 priorityscore=1501 lowpriorityscore=0 suspectscore=0 clxscore=1015
 impostorscore=0 mlxscore=0 malwarescore=0 phishscore=0 bulkscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2012150015
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 15, 2020 at 02:03:13AM +0900, Kuniyuki Iwashima wrote:
> From:   Martin KaFai Lau <kafai@fb.com>
> Date:   Thu, 10 Dec 2020 10:49:15 -0800
> > On Thu, Dec 10, 2020 at 02:15:38PM +0900, Kuniyuki Iwashima wrote:
> > > From:   Martin KaFai Lau <kafai@fb.com>
> > > Date:   Wed, 9 Dec 2020 16:07:07 -0800
> > > > On Tue, Dec 01, 2020 at 11:44:12PM +0900, Kuniyuki Iwashima wrote:
> > > > > This patch renames reuseport_select_sock() to __reuseport_select_sock() and
> > > > > adds two wrapper function of it to pass the migration type defined in the
> > > > > previous commit.
> > > > > 
> > > > >   reuseport_select_sock          : BPF_SK_REUSEPORT_MIGRATE_NO
> > > > >   reuseport_select_migrated_sock : BPF_SK_REUSEPORT_MIGRATE_REQUEST
> > > > > 
> > > > > As mentioned before, we have to select a new listener for TCP_NEW_SYN_RECV
> > > > > requests at receiving the final ACK or sending a SYN+ACK. Therefore, this
> > > > > patch also changes the code to call reuseport_select_migrated_sock() even
> > > > > if the listening socket is TCP_CLOSE. If we can pick out a listening socket
> > > > > from the reuseport group, we rewrite request_sock.rsk_listener and resume
> > > > > processing the request.
> > > > > 
> > > > > Reviewed-by: Benjamin Herrenschmidt <benh@amazon.com>
> > > > > Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
> > > > > ---
> > > > >  include/net/inet_connection_sock.h | 12 +++++++++++
> > > > >  include/net/request_sock.h         | 13 ++++++++++++
> > > > >  include/net/sock_reuseport.h       |  8 +++----
> > > > >  net/core/sock_reuseport.c          | 34 ++++++++++++++++++++++++------
> > > > >  net/ipv4/inet_connection_sock.c    | 13 ++++++++++--
> > > > >  net/ipv4/tcp_ipv4.c                |  9 ++++++--
> > > > >  net/ipv6/tcp_ipv6.c                |  9 ++++++--
> > > > >  7 files changed, 81 insertions(+), 17 deletions(-)
> > > > > 
> > > > > diff --git a/include/net/inet_connection_sock.h b/include/net/inet_connection_sock.h
> > > > > index 2ea2d743f8fc..1e0958f5eb21 100644
> > > > > --- a/include/net/inet_connection_sock.h
> > > > > +++ b/include/net/inet_connection_sock.h
> > > > > @@ -272,6 +272,18 @@ static inline void inet_csk_reqsk_queue_added(struct sock *sk)
> > > > >  	reqsk_queue_added(&inet_csk(sk)->icsk_accept_queue);
> > > > >  }
> > > > >  
> > > > > +static inline void inet_csk_reqsk_queue_migrated(struct sock *sk,
> > > > > +						 struct sock *nsk,
> > > > > +						 struct request_sock *req)
> > > > > +{
> > > > > +	reqsk_queue_migrated(&inet_csk(sk)->icsk_accept_queue,
> > > > > +			     &inet_csk(nsk)->icsk_accept_queue,
> > > > > +			     req);
> > > > > +	sock_put(sk);
> > > > not sure if it is safe to do here.
> > > > IIUC, when the req->rsk_refcnt is held, it also holds a refcnt
> > > > to req->rsk_listener such that sock_hold(req->rsk_listener) is
> > > > safe because its sk_refcnt is not zero.
> > > 
> > > I think it is safe to call sock_put() for the old listener here.
> > > 
> > > Without this patchset, at receiving the final ACK or retransmitting
> > > SYN+ACK, if sk_state == TCP_CLOSE, sock_put(req->rsk_listener) is done
> > > by calling reqsk_put() twice in inet_csk_reqsk_queue_drop_and_put().
> > Note that in your example (final ACK), sock_put(req->rsk_listener) is
> > _only_ called when reqsk_put() can get refcount_dec_and_test(&req->rsk_refcnt)
> > to reach zero.
> > 
> > Here in this patch, it sock_put(req->rsk_listener) without req->rsk_refcnt
> > reaching zero.
> > 
> > Let says there are two cores holding two refcnt to req (one cnt for each core)
> > by looking up the req from ehash.  One of the core do this migrate and
> > sock_put(req->rsk_listener).  Another core does sock_hold(req->rsk_listener).
> > 
> > 	Core1					Core2
> > 						sock_put(req->rsk_listener)
> > 
> > 	sock_hold(req->rsk_listener)
> 
> I'm sorry for the late reply.
> 
> I missed this situation that different Cores get into NEW_SYN_RECV path,
> but this does exist.
> https://lore.kernel.org/netdev/1517977874.3715.153.camel@gmail.com/#t
> https://lore.kernel.org/netdev/1518531252.3715.178.camel@gmail.com/
> 
> 
> If close() is called for the listener and the request has the last refcount
> for it, sock_put() by Core2 frees it, so Core1 cannot proceed with freed
> listener. So, it is good to call refcount_inc_not_zero() instead of
> sock_hold(). If refcount_inc_not_zero() fails, it means that the listener
_inc_not_zero() usually means it requires rcu_read_lock().
That may have rippling effect on other req->rsk_listener readers.

There may also be places assuming that the req->rsk_listener will never
change once it is assigned.  not sure.  have not looked closely yet.

It probably needs some more thoughts here to get a simpler solution.

> is closed and the req->rsk_listener is changed in another place. Then, we
> can continue processing the request by rewriting sk with rsk_listener and
> calling sock_hold() for it.
> 
> Also, the migration by Core2 can be done after sock_hold() by Core1. Then
> if Core1 win the race by removing the request from ehash,
> in inet_csk_reqsk_queue_add(), instead of sk, req->rsk_listener should be
> used as the proper listener to add the req into its queue. But if the
> rsk_listener is also TCP_CLOSE, we have to call inet_child_forget().
> 
> Moreover, we have to check the listener is freed in the beginning of
> reqsk_timer_handler() by refcount_inc_not_zero().
> 
> 
> > > And then, we do `goto lookup;` and overwrite the sk.
> > > 
> > > In the v2 patchset, refcount_inc_not_zero() is done for the new listener in
> > > reuseport_select_migrated_sock(), so we have to call sock_put() for the old
> > > listener instead to free it properly.
> > > 
> > > ---8<---
> > > +struct sock *reuseport_select_migrated_sock(struct sock *sk, u32 hash,
> > > +					    struct sk_buff *skb)
> > > +{
> > > +	struct sock *nsk;
> > > +
> > > +	nsk = __reuseport_select_sock(sk, hash, skb, 0, BPF_SK_REUSEPORT_MIGRATE_REQUEST);
> > > +	if (nsk && likely(refcount_inc_not_zero(&nsk->sk_refcnt)))
> > There is another potential issue here.  The TCP_LISTEN nsk is protected
> > by rcu.  refcount_inc_not_zero(&nsk->sk_refcnt) cannot be done if it
> > is not under rcu_read_lock().
> > 
> > The receive path may be ok as it is in rcu.  You may need to check for
> > others.
> 
> IIUC, is this mean nsk can be NULL after grace period of RCU? If so, I will
worse than NULL.  an invalid pointer.
 
> move rcu_read_lock/unlock() from __reuseport_select_sock() to
> reuseport_select_sock() and reuseport_select_migrated_sock().
ok.

> 
> 
> > > +		return nsk;
> > > +
> > > +	return NULL;
> > > +}
> > > +EXPORT_SYMBOL(reuseport_select_migrated_sock);
> > > ---8<---
> > > https://lore.kernel.org/netdev/20201207132456.65472-8-kuniyu@amazon.co.jp/
> > > 
> > > 
> > > > > +	sock_hold(nsk);
> > > > > +	req->rsk_listener = nsk;
> > It looks like there is another race here.  What
> > if multiple cores try to update req->rsk_listener?
> 
> I think we have to add a lock in struct request_sock, acquire it, check
> if the rsk_listener is changed or not, and then do migration. Also, if the
> listener has been changed, we have to tell the caller to use it as the new
> listener.
> 
> ---8<---
>        spin_lock(&lock)
>        if (sk != req->rsk_listener) {
>                nsk = req->rsk_listener;
>                goto out;
>        }
> 
>        // do migration
> out:
>        spin_unlock(&lock)
>        return nsk;
> ---8<---
cmpxchg may help here.

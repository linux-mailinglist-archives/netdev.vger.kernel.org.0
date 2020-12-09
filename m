Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A674C2D3924
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 04:10:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727136AbgLIDKX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 22:10:23 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:63216 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726867AbgLIDKW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Dec 2020 22:10:22 -0500
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0B9302s1016924;
        Tue, 8 Dec 2020 19:09:14 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=wlB43xq6JC1PnmltUKsQIr9vrH8vpRPM4ehqez/jCEA=;
 b=EQZAXrnUYMT+3sJ8RZC1zGk7wbhjYlPXvFpwp0Z8Kw5tpMZfv3pAwilZu+SdY4eewYxe
 3+uswH0mg5p30cz/9iLwWGWBCHmvEQ0/Hw8q8oDvs96g67jwtNCkkRCGNpMXs4IIi0jS
 NBPvVuTnilp15LWexZV/eiVSMMcjFEvLi5g= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 35a66wyhrr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 08 Dec 2020 19:09:13 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 8 Dec 2020 19:09:12 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CpAWlsR1xFhufI0Giy0TseonX0c1HepgiAhmsBSURYBT9nge/N7KOjg+KJ4tKxOyTBU8Bw9n38k7sdF60RRrvvXMe3UGhgmzdVGtewlHq9M7/zw6+8NXLGJvZFkPq5fe8B8z2FS+83Wn2T5AM8MQDnJWN/p7NYN88Oscm6W8868HkTt9IdBhhJ0C0Oe/U+Yc4lQ8WfpH1CSw/Qhw6tCyh1gSG4cp2j7dn/Fnb2fFvfgI110dZZ3VqOq8oGhjDGV8rRIVBXbWuPFKQZEtBpu8+QQisBcky0lkm19RGgpAy1AxUV4XEpl6B9lTqIK/LJDshNKz1leFA6EgV2Z+07w8RQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wlB43xq6JC1PnmltUKsQIr9vrH8vpRPM4ehqez/jCEA=;
 b=d5CcGwEWuUY+EhcZuvdo+i7HDeOh1VgUKIcva4Bo4kJDt/BqhVEUx/aL1oqeBoDejnqfXKSnQxtVSF9X7W5jfQQUwo1VPSqIkDtyLynQDXCUYBg4VgYGJPf6jSwzrk5gYMeXkcT+l7Ev9yLRbKoYJcYeyCh/qHrNrZS5VzXTzlQIXtNkPRRFzHZjRDnIioo+61A0VShzye/OWcpyRyspHFNX+fkKQqH9NbGU5u0XMluaxluuQHtAp3skqczSXtmKmiX4CRlKkjbhf/cFYgCtATHdzK3z2VGW1jlSCoZZe6rYdY5nxRpaBwyYbpuMY0eTLQQVnCGCrgwRbt1xpD0u5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wlB43xq6JC1PnmltUKsQIr9vrH8vpRPM4ehqez/jCEA=;
 b=B6Hy6A35ffZppu1HHk4LHhiunPwFcVhUmhxJMO9yQINTGnRYWXA5Q2+8C4VZv68cf6B9iQ4zZaCSM1sG8AqZ8OIYvB60vEydSeI42zlYjQ31Snszez21NnYoeVJ0SWwzuZ7GiFKQYLNev5IyE1sXbLLbut2btz8HFS/jKqUj864=
Authentication-Results: amazon.co.jp; dkim=none (message not signed)
 header.d=none;amazon.co.jp; dmarc=none action=none header.from=fb.com;
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by BYAPR15MB2373.namprd15.prod.outlook.com (2603:10b6:a02:92::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12; Wed, 9 Dec
 2020 03:09:11 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::2831:21bf:8060:a0b]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::2831:21bf:8060:a0b%7]) with mapi id 15.20.3632.023; Wed, 9 Dec 2020
 03:09:11 +0000
Date:   Tue, 8 Dec 2020 19:09:03 -0800
From:   Martin KaFai Lau <kafai@fb.com>
To:     Kuniyuki Iwashima <kuniyu@amazon.co.jp>
CC:     <ast@kernel.org>, <benh@amazon.com>, <bpf@vger.kernel.org>,
        <daniel@iogearbox.net>, <davem@davemloft.net>,
        <edumazet@google.com>, <eric.dumazet@gmail.com>, <kuba@kernel.org>,
        <kuni1840@gmail.com>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>
Subject: Re: [PATCH v1 bpf-next 03/11] tcp: Migrate
 TCP_ESTABLISHED/TCP_SYN_RECV sockets in accept queues.
Message-ID: <20201209030903.hhow5r53l6fmozjn@kafai-mbp.dhcp.thefacebook.com>
References: <20201208073441.3ya5s7lkqzed25l6@kafai-mbp.dhcp.thefacebook.com>
 <20201208081748.62593-1-kuniyu@amazon.co.jp>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201208081748.62593-1-kuniyu@amazon.co.jp>
X-Originating-IP: [2620:10d:c090:400::5:b7c6]
X-ClientProxiedBy: MWHPR07CA0015.namprd07.prod.outlook.com
 (2603:10b6:300:116::25) To BY5PR15MB3571.namprd15.prod.outlook.com
 (2603:10b6:a03:1f6::32)
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:b7c6) by MWHPR07CA0015.namprd07.prod.outlook.com (2603:10b6:300:116::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12 via Frontend Transport; Wed, 9 Dec 2020 03:09:09 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3ac9fe1a-cd17-45f3-9670-08d89befccea
X-MS-TrafficTypeDiagnostic: BYAPR15MB2373:
X-Microsoft-Antispam-PRVS: <BYAPR15MB237334A2E0B4C719EE75E875D5CC0@BYAPR15MB2373.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EHJ7Yu+cPWAWpKenu5BF+iuSAH2LIdaBSAb4QmhNtSqSFk6/jC0zG/VwljWa8CNzZyu0VVllasAAEgpLRiKKnQ1mICA6Wjh9Twe7PSAGgNSaASH7CnrYNXSnHNv7vE38L6boVr4T0PPmWtLpWo0x9wTDYusxY3TdfUTrkICt45jwuhNRwEJF285qULicqAZ/Qj7RQHXh0nkwShUG5XH05r7uBsLw0zBEYuLCh8qelgertFWnIGZXYYzsmL78s+6qaxaRejQMKvFGV3XnQ+KSZ36bmKar4oIa3c5un1iyfT7bskfWkA66II/nKyPIKC30YSFKO4uX819fp8c8spw6lWsALYCdx1MR2Hqru6jPLfLwefh52Ul0wCYjf3ZASidoJx9HQoYEletejVMQaUT1Hw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(136003)(366004)(6506007)(83380400001)(4326008)(53546011)(16526019)(7416002)(6916009)(8936002)(9686003)(508600001)(5660300002)(66476007)(66556008)(8676002)(52116002)(66946007)(86362001)(6666004)(1076003)(966005)(55016002)(2906002)(7696005)(186003)(30864003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?EeNhZtki4hBiLnZ2rOD4LrmRBgSPJMZmDDhrXwC1d7jq00lTyH13wxHcmwUR?=
 =?us-ascii?Q?xNNdpB2YBXcOmDnzmS8xCpyAmfCkv16WDxKDYiwZc67u7U/EqrAYnAWPw5ZJ?=
 =?us-ascii?Q?HAEXcXyKbLUF36YhTtfkorh7HTvQM9iNxvnzN4a21MJgavpKJZFGuKPr4TRF?=
 =?us-ascii?Q?tWJCjtYm5pCCgFmX+ZiNwqVHcVYtkTcAv6OEDlawdBl1SRY3ehPcttkoogUv?=
 =?us-ascii?Q?bj8tXenlAElMMJN78zjuD0VhxABjb/kjSLtf4c32LYRpstvFiRZNloBlph+y?=
 =?us-ascii?Q?0gUhT7U4oxjap3953nVtfN2tFPbxct8yQ/XyTxwKairrfPL6dPD5xpMjce//?=
 =?us-ascii?Q?mTlBNXKTSNcnYU4+jdJcgjKWy2Zw0O3iokPbtWfn2NGenrbn1OXAlwj8urn1?=
 =?us-ascii?Q?WHYCdfajq8+caZygseA0Hm1I0/Db1xh2gmKnO9ffw4IIPtJJzy25MOyLl9DS?=
 =?us-ascii?Q?Jv51dBWNx0MxpArKApjpKdumtQ1qjXd3uWfNUq4pIRUMZcCwHbKr7gGY5/JD?=
 =?us-ascii?Q?Wuzgd+0bkMvMAJryzyNZ8FOo9FMQoqk+Xy1mfzyd5bonh70voFcF8xdgmb6e?=
 =?us-ascii?Q?dYGO9J+koDbKUb9TcYM79b0Ew3UKYyovoZqcesEKEgirmxV47Y0L42nv0UYs?=
 =?us-ascii?Q?XuY14rvUcjdUCFkUngT7b0p2FGfu5SVI/ib29kHd1GlCq/FDlrqOkGeYhwVp?=
 =?us-ascii?Q?0bRmv5PR6Yp0x7T4QbY+5GI8w6I3/jtdkT8SA7/GWQICfTpcW8VaJvMr1VoI?=
 =?us-ascii?Q?j3XFCpdN5VcOQBbRwAJKZHM5cAVNVbSun9IP7EucRT1Jix/8ptQPsEZoICz+?=
 =?us-ascii?Q?tPEKl8C7Ut5w8zJ6dRt2txQP031VcrPLMuU0H3dSGOSVdj1wChP1zAEu2GOs?=
 =?us-ascii?Q?AeuxaSiv+dB7HEMnzQsQXw/6erH/dtzjNBCEgPv4+7wUJw64QIXIVEXsW+SR?=
 =?us-ascii?Q?HVLu07yCeyOxEciHhaJJYCUPlGeJ1/hpjT7Aqdb2uUK15KFqASzcJ6fkt3VP?=
 =?us-ascii?Q?GQWPviGFa2GlmAlAiNbY62p3eQ=3D=3D?=
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB3571.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2020 03:09:10.9250
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ac9fe1a-cd17-45f3-9670-08d89befccea
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: n+QeNk3eRGkRWSst6fGl3l0RrAlZ4HgGcM3tOa/mPd8HGqvBHg63wL4rqxn5wzD4
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2373
X-OriginatorOrg: fb.com
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-09_02:2020-12-08,2020-12-09 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015 mlxscore=0
 spamscore=0 phishscore=0 adultscore=0 lowpriorityscore=0 malwarescore=0
 suspectscore=0 impostorscore=0 bulkscore=0 mlxlogscore=999
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012090019
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 08, 2020 at 05:17:48PM +0900, Kuniyuki Iwashima wrote:
> From:   Martin KaFai Lau <kafai@fb.com>
> Date:   Mon, 7 Dec 2020 23:34:41 -0800
> > On Tue, Dec 08, 2020 at 03:31:34PM +0900, Kuniyuki Iwashima wrote:
> > > From:   Martin KaFai Lau <kafai@fb.com>
> > > Date:   Mon, 7 Dec 2020 12:33:15 -0800
> > > > On Thu, Dec 03, 2020 at 11:14:24PM +0900, Kuniyuki Iwashima wrote:
> > > > > From:   Eric Dumazet <eric.dumazet@gmail.com>
> > > > > Date:   Tue, 1 Dec 2020 16:25:51 +0100
> > > > > > On 12/1/20 3:44 PM, Kuniyuki Iwashima wrote:
> > > > > > > This patch lets reuseport_detach_sock() return a pointer of struct sock,
> > > > > > > which is used only by inet_unhash(). If it is not NULL,
> > > > > > > inet_csk_reqsk_queue_migrate() migrates TCP_ESTABLISHED/TCP_SYN_RECV
> > > > > > > sockets from the closing listener to the selected one.
> > > > > > > 
> > > > > > > Listening sockets hold incoming connections as a linked list of struct
> > > > > > > request_sock in the accept queue, and each request has reference to a full
> > > > > > > socket and its listener. In inet_csk_reqsk_queue_migrate(), we only unlink
> > > > > > > the requests from the closing listener's queue and relink them to the head
> > > > > > > of the new listener's queue. We do not process each request and its
> > > > > > > reference to the listener, so the migration completes in O(1) time
> > > > > > > complexity. However, in the case of TCP_SYN_RECV sockets, we take special
> > > > > > > care in the next commit.
> > > > > > > 
> > > > > > > By default, the kernel selects a new listener randomly. In order to pick
> > > > > > > out a different socket every time, we select the last element of socks[] as
> > > > > > > the new listener. This behaviour is based on how the kernel moves sockets
> > > > > > > in socks[]. (See also [1])
> > > > > > > 
> > > > > > > Basically, in order to redistribute sockets evenly, we have to use an eBPF
> > > > > > > program called in the later commit, but as the side effect of such default
> > > > > > > selection, the kernel can redistribute old requests evenly to new listeners
> > > > > > > for a specific case where the application replaces listeners by
> > > > > > > generations.
> > > > > > > 
> > > > > > > For example, we call listen() for four sockets (A, B, C, D), and close the
> > > > > > > first two by turns. The sockets move in socks[] like below.
> > > > > > > 
> > > > > > >   socks[0] : A <-.      socks[0] : D          socks[0] : D
> > > > > > >   socks[1] : B   |  =>  socks[1] : B <-.  =>  socks[1] : C
> > > > > > >   socks[2] : C   |      socks[2] : C --'
> > > > > > >   socks[3] : D --'
> > > > > > > 
> > > > > > > Then, if C and D have newer settings than A and B, and each socket has a
> > > > > > > request (a, b, c, d) in their accept queue, we can redistribute old
> > > > > > > requests evenly to new listeners.
> > > > > > > 
> > > > > > >   socks[0] : A (a) <-.      socks[0] : D (a + d)      socks[0] : D (a + d)
> > > > > > >   socks[1] : B (b)   |  =>  socks[1] : B (b) <-.  =>  socks[1] : C (b + c)
> > > > > > >   socks[2] : C (c)   |      socks[2] : C (c) --'
> > > > > > >   socks[3] : D (d) --'
> > > > > > > 
> > > > > > > Here, (A, D) or (B, C) can have different application settings, but they
> > > > > > > MUST have the same settings at the socket API level; otherwise, unexpected
> > > > > > > error may happen. For instance, if only the new listeners have
> > > > > > > TCP_SAVE_SYN, old requests do not have SYN data, so the application will
> > > > > > > face inconsistency and cause an error.
> > > > > > > 
> > > > > > > Therefore, if there are different kinds of sockets, we must attach an eBPF
> > > > > > > program described in later commits.
> > > > > > > 
> > > > > > > Link: https://lore.kernel.org/netdev/CAEfhGiyG8Y_amDZ2C8dQoQqjZJMHjTY76b=KBkTKcBtA=dhdGQ@mail.gmail.com/
> > > > > > > Reviewed-by: Benjamin Herrenschmidt <benh@amazon.com>
> > > > > > > Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
> > > > > > > ---
> > > > > > >  include/net/inet_connection_sock.h |  1 +
> > > > > > >  include/net/sock_reuseport.h       |  2 +-
> > > > > > >  net/core/sock_reuseport.c          | 10 +++++++++-
> > > > > > >  net/ipv4/inet_connection_sock.c    | 30 ++++++++++++++++++++++++++++++
> > > > > > >  net/ipv4/inet_hashtables.c         |  9 +++++++--
> > > > > > >  5 files changed, 48 insertions(+), 4 deletions(-)
> > > > > > > 
> > > > > > > diff --git a/include/net/inet_connection_sock.h b/include/net/inet_connection_sock.h
> > > > > > > index 7338b3865a2a..2ea2d743f8fc 100644
> > > > > > > --- a/include/net/inet_connection_sock.h
> > > > > > > +++ b/include/net/inet_connection_sock.h
> > > > > > > @@ -260,6 +260,7 @@ struct dst_entry *inet_csk_route_child_sock(const struct sock *sk,
> > > > > > >  struct sock *inet_csk_reqsk_queue_add(struct sock *sk,
> > > > > > >  				      struct request_sock *req,
> > > > > > >  				      struct sock *child);
> > > > > > > +void inet_csk_reqsk_queue_migrate(struct sock *sk, struct sock *nsk);
> > > > > > >  void inet_csk_reqsk_queue_hash_add(struct sock *sk, struct request_sock *req,
> > > > > > >  				   unsigned long timeout);
> > > > > > >  struct sock *inet_csk_complete_hashdance(struct sock *sk, struct sock *child,
> > > > > > > diff --git a/include/net/sock_reuseport.h b/include/net/sock_reuseport.h
> > > > > > > index 0e558ca7afbf..09a1b1539d4c 100644
> > > > > > > --- a/include/net/sock_reuseport.h
> > > > > > > +++ b/include/net/sock_reuseport.h
> > > > > > > @@ -31,7 +31,7 @@ struct sock_reuseport {
> > > > > > >  extern int reuseport_alloc(struct sock *sk, bool bind_inany);
> > > > > > >  extern int reuseport_add_sock(struct sock *sk, struct sock *sk2,
> > > > > > >  			      bool bind_inany);
> > > > > > > -extern void reuseport_detach_sock(struct sock *sk);
> > > > > > > +extern struct sock *reuseport_detach_sock(struct sock *sk);
> > > > > > >  extern struct sock *reuseport_select_sock(struct sock *sk,
> > > > > > >  					  u32 hash,
> > > > > > >  					  struct sk_buff *skb,
> > > > > > > diff --git a/net/core/sock_reuseport.c b/net/core/sock_reuseport.c
> > > > > > > index fd133516ac0e..60d7c1f28809 100644
> > > > > > > --- a/net/core/sock_reuseport.c
> > > > > > > +++ b/net/core/sock_reuseport.c
> > > > > > > @@ -216,9 +216,11 @@ int reuseport_add_sock(struct sock *sk, struct sock *sk2, bool bind_inany)
> > > > > > >  }
> > > > > > >  EXPORT_SYMBOL(reuseport_add_sock);
> > > > > > >  
> > > > > > > -void reuseport_detach_sock(struct sock *sk)
> > > > > > > +struct sock *reuseport_detach_sock(struct sock *sk)
> > > > > > >  {
> > > > > > >  	struct sock_reuseport *reuse;
> > > > > > > +	struct bpf_prog *prog;
> > > > > > > +	struct sock *nsk = NULL;
> > > > > > >  	int i;
> > > > > > >  
> > > > > > >  	spin_lock_bh(&reuseport_lock);
> > > > > > > @@ -242,8 +244,12 @@ void reuseport_detach_sock(struct sock *sk)
> > > > > > >  
> > > > > > >  		reuse->num_socks--;
> > > > > > >  		reuse->socks[i] = reuse->socks[reuse->num_socks];
> > > > > > > +		prog = rcu_dereference(reuse->prog);
> > > > > > >  
> > > > > > >  		if (sk->sk_protocol == IPPROTO_TCP) {
> > > > > > > +			if (reuse->num_socks && !prog)
> > > > > > > +				nsk = i == reuse->num_socks ? reuse->socks[i - 1] : reuse->socks[i];
> > > > > > > +
> > > > > > >  			reuse->num_closed_socks++;
> > > > > > >  			reuse->socks[reuse->max_socks - reuse->num_closed_socks] = sk;
> > > > > > >  		} else {
> > > > > > > @@ -264,6 +270,8 @@ void reuseport_detach_sock(struct sock *sk)
> > > > > > >  		call_rcu(&reuse->rcu, reuseport_free_rcu);
> > > > > > >  out:
> > > > > > >  	spin_unlock_bh(&reuseport_lock);
> > > > > > > +
> > > > > > > +	return nsk;
> > > > > > >  }
> > > > > > >  EXPORT_SYMBOL(reuseport_detach_sock);
> > > > > > >  
> > > > > > > diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
> > > > > > > index 1451aa9712b0..b27241ea96bd 100644
> > > > > > > --- a/net/ipv4/inet_connection_sock.c
> > > > > > > +++ b/net/ipv4/inet_connection_sock.c
> > > > > > > @@ -992,6 +992,36 @@ struct sock *inet_csk_reqsk_queue_add(struct sock *sk,
> > > > > > >  }
> > > > > > >  EXPORT_SYMBOL(inet_csk_reqsk_queue_add);
> > > > > > >  
> > > > > > > +void inet_csk_reqsk_queue_migrate(struct sock *sk, struct sock *nsk)
> > > > > > > +{
> > > > > > > +	struct request_sock_queue *old_accept_queue, *new_accept_queue;
> > > > > > > +
> > > > > > > +	old_accept_queue = &inet_csk(sk)->icsk_accept_queue;
> > > > > > > +	new_accept_queue = &inet_csk(nsk)->icsk_accept_queue;
> > > > > > > +
> > > > > > > +	spin_lock(&old_accept_queue->rskq_lock);
> > > > > > > +	spin_lock(&new_accept_queue->rskq_lock);
> > > > > > 
> > > > > > Are you sure lockdep is happy with this ?
> > > > > > 
> > > > > > I would guess it should complain, because :
> > > > > > 
> > > > > > lock(A);
> > > > > > lock(B);
> > > > > > ...
> > > > > > unlock(B);
> > > > > > unlock(A);
> > > > > > 
> > > > > > will fail when the opposite action happens eventually
> > > > > > 
> > > > > > lock(B);
> > > > > > lock(A);
> > > > > > ...
> > > > > > unlock(A);
> > > > > > unlock(B);
> > > > > 
> > > > > I enabled lockdep and did not see warnings of lockdep.
> > > > > 
> > > > > Also, the inversion deadlock does not happen in this case.
> > > > > In reuseport_detach_sock(), sk is moved backward in socks[] and poped out
> > > > > from the eBPF map, so the old listener will not be selected as the new
> > > > > listener.
> > > > > 
> > > > > 
> > > > > > > +
> > > > > > > +	if (old_accept_queue->rskq_accept_head) {
> > > > > > > +		if (new_accept_queue->rskq_accept_head)
> > > > > > > +			old_accept_queue->rskq_accept_tail->dl_next =
> > > > > > > +				new_accept_queue->rskq_accept_head;
> > > > > > > +		else
> > > > > > > +			new_accept_queue->rskq_accept_tail = old_accept_queue->rskq_accept_tail;
> > > > > > > +
> > > > > > > +		new_accept_queue->rskq_accept_head = old_accept_queue->rskq_accept_head;
> > > > > > > +		old_accept_queue->rskq_accept_head = NULL;
> > > > > > > +		old_accept_queue->rskq_accept_tail = NULL;
> > > > > > > +
> > > > > > > +		WRITE_ONCE(nsk->sk_ack_backlog, nsk->sk_ack_backlog + sk->sk_ack_backlog);
> > > > > > > +		WRITE_ONCE(sk->sk_ack_backlog, 0);
> > > > > > > +	}
> > > > > > > +
> > > > > > > +	spin_unlock(&new_accept_queue->rskq_lock);
> > > > > > > +	spin_unlock(&old_accept_queue->rskq_lock);
> > > > > > > +}
> > > > > > > +EXPORT_SYMBOL(inet_csk_reqsk_queue_migrate);
> > > > > > 
> > > > > > I fail to understand how the kernel can run fine right after this patch, before following patches are merged.
> > > > > 
> > > > > I will squash the two or reorganize them into definition part and migration
> > > > > part.
> > > > > 
> > > > > 
> > > > > > All request sockets in the socket accept queue MUST have their rsk_listener set to the listener,
> > > > > > this is how we designed things (each request socket has a reference taken on the listener)
> > > > > > 
> > > > > > We might even have some "BUG_ON(sk != req->rsk_listener);" in some places.
> > > > > > 
> > > > > > Since you splice list from old listener to the new one, without changing req->rsk_listener, bad things will happen.
> > > > I also have similar concern on the inconsistency in req->rsk_listener.
> > > > 
> > > > The fix-up in req->rsk_listener for the TFO req in patch 4
> > > > makes it clear that req->rsk_listener should be updated during
> > > > the migration instead of asking a much later code path
> > > > to accommodate this inconsistent req->rsk_listener pointer.
> > > 
> > > When I started this patchset, I read this thread and misunderstood that I
> > > had to migrate sockets in O(1) for scalability. So, I selected the fix-up
> > > approach and checked rsk_listener is not used except for TFO.
> > > 
> > > ---8<---
> > > Whole point of BPF was to avoid iterate through all sockets [1],
> > > and let user space use whatever selection logic it needs.
> > > 
> > > [1] This was okay with up to 16 sockets. But with 128 it does not scale.
> > > ---&<---
> > > https://lore.kernel.org/netdev/1458837191.12033.4.camel@edumazet-glaptop3.roam.corp.google.com/
> > > 
> > > 
> > > However, I've read it again, and this was about iterating over listeners
> > > to select a new listener, not about iterating over requests...
> > > In this patchset, we can select a listener in O(1) and it is enough.
> > > 
> > > 
> > > > The current inet_csk_listen_stop() is already iterating
> > > > the icsk_accept_queue and fastopenq.  The extra cost
> > > > in updating rsk_listener may be just noise?
> > > 
> > > Exactly.
> > > If we end up iterating requests, it is better to migrate than close. I will
> > > update each rsk_listener in inet_csk_reqsk_queue_migrate() in v3 patchset.
> > To be clear, I meant to do migration in inet_csk_listen_stop() instead
> > of doing it in the new inet_csk_reqsk_queue_migrate() which reqires a
> > double lock and then need to re-bring in the whole spin_lock_bh_nested
> > patch in the patch 3 of v2.
> > 
> > e.g. in the first while loop in inet_csk_listen_stop(),
> > if there is a target to migrate to,  it can do
> > something similar to inet_csk_reqsk_queue_add(target_sk, ...)
> > instead of doing the current inet_child_forget().
> > It probably needs something different from
> > inet_csk_reqsk_queue_add(), e.g. also update rsk_listener,
> > but the idea should be similar.
> > 
> > Since the rsk_listener has to be updated one by one, there is
> > really no point to do the list splicing which requires
> > the double lock.
> 
> I think it is a bit complex to pass the new listener from
> reuseport_detach_sock() to inet_csk_listen_stop().
> 
> __tcp_close/tcp_disconnect/tcp_abort
>  |-tcp_set_state
>  |  |-unhash
>  |     |-reuseport_detach_sock (return nsk)
>  |-inet_csk_listen_stop
Picking the new listener does not have to be done in
reuseport_detach_sock().

IIUC, it is done there only because it prefers to pick
the last sk from socks[] when bpf prog is not attached.
This seems to get into the way of exploring other potential
implementation options.

Merging the discussion on the last socks[] pick from another thread:
>
> I think most applications start new listeners before closing listeners, in
> this case, selecting the moved socket as the new listener works well.
>
>
> > That said, if it is still desired to do a random pick by kernel when
> > there is no bpf prog, it probably makes sense to guard it in a sysctl as
> > suggested in another reply.  To keep it simple, I would also keep this
> > kernel-pick consistent instead of request socket is doing something
> > different from the unhash path.
>
> Then, is this way better to keep kernel-pick consistent?
>
>   1. call reuseport_select_migrated_sock() without sk_hash from any path
>   2. generate a random number in reuseport_select_migrated_sock()
>   3. pass it to __reuseport_select_sock() only for select-by-hash
>   (4. pass 0 as sk_hash to bpf_run_sk_reuseport not to use it)
>   5. do migration per queue in inet_csk_listen_stop() or per request in
>      receive path.
>
> I understand it is beautiful to keep consistensy, but also think
> the kernel-pick with heuristic performs better than random-pick.
I think discussing the best kernel pick without explicit user input
is going to be a dead end. There is always a case that
makes this heuristic (or guess) fail.  e.g. what if multiple
sk(s) being closed are always the last one in the socks[]?
all their child sk(s) will then be piled up at one listen sk
because the last socks[] is always picked?

Lets assume the last socks[] is indeed the best for all cases.  Then why
the in-progress req don't pick it this way?  I feel the implementation
is doing what is convenient at that point.  And that is fine, I think
for kernel-pick, it should just go for simplicity and stay with
the random(/hash) pick instead of pretending the kernel knows the
application must operate in a certain way.  It is fine
that the pick was wrong, the kernel will eventually move the
childs/reqs to the survived listen sk.
[ I still think the kernel should not even pick if
  there is no bpf prog to instruct how to pick
  but I am fine as long as there is a sysctl to
  guard this. ]

I would rather focus on ensuring the bpf prog getting what it
needs to make the migration pick.  A few things
I would like to discuss and explore:

> 
> If we splice requests like this, we do not need double lock?
> 
>   1. lock the accept queue of the old listener
>   2. unlink all requests and decrement refcount
>   3. unlock
>   4. update all requests with new listener
I guess updating rsk_listener can be done without acquiring
the lock in (5) below is because it is done under the
listening_hash's bucket lock (and also the global reuseport_lock) so
that the new listener will stay in TCP_LISTEN state?

I am not sure iterating the queue under these
locks is a very good thing to do though.  The queue may not be
very long in usual setup but still let see
if that can be avoided.

Do you think the iteration can be done without holding
bucket lock and the global reuseport_lock?  inet_csk_reqsk_queue_add()
is taking the rskq_lock and then check for TCP_LISTEN.  May be
something similar can be done also?

While doing BPF_SK_REUSEPORT_MIGRATE_REQUEST,
the bpf prog can pick per req and have the sk_hash.
However, while doing BPF_SK_REUSEPORT_MIGRATE_QUEUE,
the bpf prog currently does not have a chance to
pick individually for each req/child on the queue.
Since it is iterating the queue anyway, does it make
sense to also call the bpf to pick for each req/child
in the queue?  It then can pass sk_hash (from child->sk_hash?)
to the bpf prog also instead of current 0.  The cost of calling
bpf prog is not really that much / signficant at the
migration code path.  If the queue is somehow
unusally long, there is already an existing
cond_resched() in inet_csk_listen_stop().

Then, instead of adding sk_reuseport_md->migration,
it can then add sk_reuseport_md->migrate_sk.
"migrate_sk = req" for in-progress req and "migrate_sk = child"
for iterating acceptq.  The bpf_prog can then tell what sk (req or child)
it is migrating by reading migrate_sk->state.  It can then also
learn the 4 tuples src/dst ip/port while skb is missing.
The sk_reuseport_md->sk can still point to the closed sk
such that the bpf prog can learn the cookie.

I suspect a few things between BPF_SK_REUSEPORT_MIGRATE_REQUEST
and BPF_SK_REUSEPORT_MIGRATE_QUEUE can be folded together
by doing the above.  It also gives a more consistent
interface for the bpf prog, no more MIGRATE_QUEUE vs MIGRATE_REQUEST.

>   5. lock the accept queue of the new listener
>   6. splice requests and increment refcount
>   7. unlock
> 
> Also, I think splicing is better to keep the order of requests. Adding one
> by one reverses it.
It can keep the order but I think it is orthogonal here.


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E0792D1A99
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 21:35:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726763AbgLGUeZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 15:34:25 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:5320 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726141AbgLGUeZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Dec 2020 15:34:25 -0500
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0B7KPTFl012207;
        Mon, 7 Dec 2020 12:33:25 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=/Od6LmDxkUdt+3ZfLKeWNEJCpwPG8i0/UruEDAmgFY4=;
 b=LwhOc5X2xaEWAJLlZGE/njFVeoOKA/6RsKehov4bMpWfEZUw7mdBOznchGz4cF0q29TN
 6ineEb3FzTnpI2a+i0SjgOnzHULl2wBWnVQgKndjEN5TGP7SY2r0JBUJtXxzKChF4lCo
 LCtHZUeGldIzBbDaRVH9f2V541nBJT7ioyQ= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 358ud9h22s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 07 Dec 2020 12:33:24 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.172) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 7 Dec 2020 12:33:24 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bzeikaEiqlJdGmvA5eIi5fLttZGMxReMh+pINC6TCvgRHgzC6zLi/aLpxRXTs+JoRZdiiD1kIgdWV42zPJNO1GhGrFjb7LPGnQGuN8j+vqpGwZhI6AXHS7lHvAAPGwUjdK8XiM9Z6C7fm5eO5rLfWHN5ijWNuLPo1HKBxp6Z3ewO2gioetrn9CU8ozFcaMNk5codvC4r1wnPJf4J38eW2id+jcHMBM/0R8n8hO8GoKceTKt2QWvU6uvTpSqbVJVTgsP4K5E7IDPOMrmjATpwLTIpf35dfIRdSvrR0vppZ8yiRcGJxanzm5TSZlgHPhupo5QuttVF/sI6fxFSXLjpog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/Od6LmDxkUdt+3ZfLKeWNEJCpwPG8i0/UruEDAmgFY4=;
 b=JKlJs9+rD9YILaGjlXNl4PIovBEGeK3A6wy9xLVjUcSvIWznh1zSIk/LqBvFdUIm1LM08oCfasyMmOgS94P+NRnEug65qUYwp99uo50liVtokcJ6UJMWSU8yFGnqQCnsz08quQW2rUmcsNkvNPUl8itamNluU2PyCvl71bbIZLSJdGguT8EFG9O2xp2sV8m0MuUk8Ig5NhIdv0YuJtp+DLwXbmZqXemUAwl42qmVFWwZyWrtfSfFKINI/hWBTiXJgFHUHKlQL7q8H5Hr33IMZASN/s6Nmz17PaUpG9WdCNdOA8gMgLrF5+K/SIaNWkngw5cq4KZFW2a2HE3WGJjpRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/Od6LmDxkUdt+3ZfLKeWNEJCpwPG8i0/UruEDAmgFY4=;
 b=AQ5FkaFnvzwelZ8spYRNZrxJ/rV4T53IksOtK74mX6PH0gXnPiKtnJ4ySRslEyVALIUsHEo6b17haipCY9KWSX7Fwm8MG83cZDMoQMPaMXRK59CYPgVDdhXHQ3JRl2dHsqpDcVBIOI3wkFRdVDmookGJDs0JYFilCQAXMe7OTEk=
Authentication-Results: amazon.co.jp; dkim=none (message not signed)
 header.d=none;amazon.co.jp; dmarc=none action=none header.from=fb.com;
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by BYAPR15MB2696.namprd15.prod.outlook.com (2603:10b6:a03:156::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.19; Mon, 7 Dec
 2020 20:33:23 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::2831:21bf:8060:a0b]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::2831:21bf:8060:a0b%7]) with mapi id 15.20.3632.023; Mon, 7 Dec 2020
 20:33:23 +0000
Date:   Mon, 7 Dec 2020 12:33:15 -0800
From:   Martin KaFai Lau <kafai@fb.com>
To:     Kuniyuki Iwashima <kuniyu@amazon.co.jp>
CC:     <eric.dumazet@gmail.com>, <ast@kernel.org>, <benh@amazon.com>,
        <bpf@vger.kernel.org>, <daniel@iogearbox.net>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <kuni1840@gmail.com>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>
Subject: Re: [PATCH v1 bpf-next 03/11] tcp: Migrate
 TCP_ESTABLISHED/TCP_SYN_RECV sockets in accept queues.
Message-ID: <20201207203227.lcwdihxfwral3uz7@kafai-mbp.dhcp.thefacebook.com>
References: <e47b903d-6e7c-a2a7-ccdf-d2c701986d4f@gmail.com>
 <20201203141424.52912-1-kuniyu@amazon.co.jp>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201203141424.52912-1-kuniyu@amazon.co.jp>
X-Originating-IP: [2620:10d:c090:400::5:e1c3]
X-ClientProxiedBy: MW4PR03CA0043.namprd03.prod.outlook.com
 (2603:10b6:303:8e::18) To BY5PR15MB3571.namprd15.prod.outlook.com
 (2603:10b6:a03:1f6::32)
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:e1c3) by MW4PR03CA0043.namprd03.prod.outlook.com (2603:10b6:303:8e::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.21 via Frontend Transport; Mon, 7 Dec 2020 20:33:21 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6c1037f7-609a-4845-b5d6-08d89aef579f
X-MS-TrafficTypeDiagnostic: BYAPR15MB2696:
X-Microsoft-Antispam-PRVS: <BYAPR15MB2696441FB5E0F1C0F4A81781D5CE0@BYAPR15MB2696.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NsdEm30DxtdGEyQH3DPxGUOXBcJdnbMJSEsCjMgGPJiqHPzPLdzBrwviEeuCShQ5B+Nyay2oWyGBnCdHCX17RY7eNpTY0855M38RoEooozbYB8pirZRgEj7MaUQNMrWuoeZE1rQP6OvNxha4bnTskoCztn31Sbms8uDWlzqmHsAlBuWjK1SwuDUTRHb73FXW83IicrB7cTA8BmB/+Vpjac/jPgHuznN/g5nzKl9TrF3igA9FpyyIoLmJZCwy2wEBunFvUve8dVZRxhmiXvQ0pfp9kL4ydW8LpsAOSRZ/yD+6OuW24Ukr2kvc8tTd1k5at+3nHFwd80GJqLE77lS+yy4CZqK5Kho74CZ2YSbi713pyJk5cMr1LAvcmnwxL7G4nqOY6sTITckqo59TB+cr3g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(136003)(366004)(39860400002)(376002)(396003)(1076003)(16526019)(8676002)(83380400001)(9686003)(66946007)(53546011)(7696005)(66556008)(4326008)(7416002)(52116002)(478600001)(55016002)(66476007)(5660300002)(86362001)(966005)(186003)(316002)(8936002)(6506007)(2906002)(6666004)(6916009);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?davW/Ro3eniUKMrke6qYA+MwCc1Dl2yq82pwZgESb4kOM0QkcP0L5DnymlVl?=
 =?us-ascii?Q?ebSIJccK23bO+NZ01Jrnp/YPy6Lymhaor5bSk1EWoTTQaBI9X6Wsu09YIatG?=
 =?us-ascii?Q?fIJAjb27p+G6WlVT5Nfn4X2qmjVNsf5iCdzLAzeVqy5TPLnYqmHfMcaVSICl?=
 =?us-ascii?Q?GI/lAsIwpkQcEXaMnk56fUPyjkn+S7VomW4/O0rL709JNwvS2cjowAnUiISN?=
 =?us-ascii?Q?TFZecanG8Ubkyyc5d3KVRGYBBvVeNeeKaIqHi07zQraesGJAD3Pe2PjUfCp6?=
 =?us-ascii?Q?l59oK3euQcqOQ2GNK0+naQfBwOH+T8LGTV2/hfKFHDYqV1x7FWosu3q5CTGU?=
 =?us-ascii?Q?/WGoV73NLoUM0UuV7a+tpwdI9hFBAFRfFl3g5bqCMgz8cnjs7crGB30UVBiW?=
 =?us-ascii?Q?zOv410M3qlSuMW7zyB9k+vyL/NpSfoGWzfy2sMfiZEcQR/sdF4gwGKlCuuZG?=
 =?us-ascii?Q?4t0lSeNaH0eKaZIje+9ryV7S+D9E/Y3954Owioakd1VCwp6PVU7Ndz5A9gdN?=
 =?us-ascii?Q?XAcdHNoXr8tOLFh6ht6/miv4QlmyyJvFgo0dc3oKa0Gly2miqiHoDQeSx0wX?=
 =?us-ascii?Q?zDv2+qdl1zVYEGm+xwh5ar0rwBTYxoZdlC6Z0LP93amCBmlztbnxFbo8qNWM?=
 =?us-ascii?Q?9iEaIDrolFoR5+oYLjZZslZ3x50lhFEAQftCr+2oXSfWBTyQba1UbvPnEIce?=
 =?us-ascii?Q?2r0GM6tLyR8lVoI3E5LbnTNULz3Fc2jDcFmPQfqqxuekPM4qv5F4y+9rRUmI?=
 =?us-ascii?Q?CapTSkQS4OHHAea+JuIzSfdx4pQclGerzRJRX4/foxWrLDb/TtlkT1f2jqx9?=
 =?us-ascii?Q?OruEN4K646AJJ3tyJA+fhTKBLu7sdrgcT1BGrym+nkGqT2283T0KkYU/FnRr?=
 =?us-ascii?Q?f8OAk7NOo2DV8jKMKnGLw5bOdj19oFrr+N0vFkwbA5HwWY3JJEFogNofjfom?=
 =?us-ascii?Q?fQQd6NOzRFR6U2/TT+BB0DEvgInP5HSz3Yo0ThNtlvBvjr29tuwHsPlq7U8n?=
 =?us-ascii?Q?PLFBn3/AYSplYtbSOnNrjEEKyg=3D=3D?=
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB3571.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Dec 2020 20:33:22.9961
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c1037f7-609a-4845-b5d6-08d89aef579f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NJPD9g7mA8cgF2Hm1ZE+KSN8nhfkNN/W+meKkd8V4+6yveDMAjr2661KANG0qTTC
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2696
X-OriginatorOrg: fb.com
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-07_16:2020-12-04,2020-12-07 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015
 adultscore=0 spamscore=0 mlxlogscore=999 mlxscore=0 phishscore=0
 impostorscore=0 lowpriorityscore=0 bulkscore=0 malwarescore=0
 suspectscore=0 priorityscore=1501 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2012070132
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 03, 2020 at 11:14:24PM +0900, Kuniyuki Iwashima wrote:
> From:   Eric Dumazet <eric.dumazet@gmail.com>
> Date:   Tue, 1 Dec 2020 16:25:51 +0100
> > On 12/1/20 3:44 PM, Kuniyuki Iwashima wrote:
> > > This patch lets reuseport_detach_sock() return a pointer of struct sock,
> > > which is used only by inet_unhash(). If it is not NULL,
> > > inet_csk_reqsk_queue_migrate() migrates TCP_ESTABLISHED/TCP_SYN_RECV
> > > sockets from the closing listener to the selected one.
> > > 
> > > Listening sockets hold incoming connections as a linked list of struct
> > > request_sock in the accept queue, and each request has reference to a full
> > > socket and its listener. In inet_csk_reqsk_queue_migrate(), we only unlink
> > > the requests from the closing listener's queue and relink them to the head
> > > of the new listener's queue. We do not process each request and its
> > > reference to the listener, so the migration completes in O(1) time
> > > complexity. However, in the case of TCP_SYN_RECV sockets, we take special
> > > care in the next commit.
> > > 
> > > By default, the kernel selects a new listener randomly. In order to pick
> > > out a different socket every time, we select the last element of socks[] as
> > > the new listener. This behaviour is based on how the kernel moves sockets
> > > in socks[]. (See also [1])
> > > 
> > > Basically, in order to redistribute sockets evenly, we have to use an eBPF
> > > program called in the later commit, but as the side effect of such default
> > > selection, the kernel can redistribute old requests evenly to new listeners
> > > for a specific case where the application replaces listeners by
> > > generations.
> > > 
> > > For example, we call listen() for four sockets (A, B, C, D), and close the
> > > first two by turns. The sockets move in socks[] like below.
> > > 
> > >   socks[0] : A <-.      socks[0] : D          socks[0] : D
> > >   socks[1] : B   |  =>  socks[1] : B <-.  =>  socks[1] : C
> > >   socks[2] : C   |      socks[2] : C --'
> > >   socks[3] : D --'
> > > 
> > > Then, if C and D have newer settings than A and B, and each socket has a
> > > request (a, b, c, d) in their accept queue, we can redistribute old
> > > requests evenly to new listeners.
> > > 
> > >   socks[0] : A (a) <-.      socks[0] : D (a + d)      socks[0] : D (a + d)
> > >   socks[1] : B (b)   |  =>  socks[1] : B (b) <-.  =>  socks[1] : C (b + c)
> > >   socks[2] : C (c)   |      socks[2] : C (c) --'
> > >   socks[3] : D (d) --'
> > > 
> > > Here, (A, D) or (B, C) can have different application settings, but they
> > > MUST have the same settings at the socket API level; otherwise, unexpected
> > > error may happen. For instance, if only the new listeners have
> > > TCP_SAVE_SYN, old requests do not have SYN data, so the application will
> > > face inconsistency and cause an error.
> > > 
> > > Therefore, if there are different kinds of sockets, we must attach an eBPF
> > > program described in later commits.
> > > 
> > > Link: https://lore.kernel.org/netdev/CAEfhGiyG8Y_amDZ2C8dQoQqjZJMHjTY76b=KBkTKcBtA=dhdGQ@mail.gmail.com/
> > > Reviewed-by: Benjamin Herrenschmidt <benh@amazon.com>
> > > Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
> > > ---
> > >  include/net/inet_connection_sock.h |  1 +
> > >  include/net/sock_reuseport.h       |  2 +-
> > >  net/core/sock_reuseport.c          | 10 +++++++++-
> > >  net/ipv4/inet_connection_sock.c    | 30 ++++++++++++++++++++++++++++++
> > >  net/ipv4/inet_hashtables.c         |  9 +++++++--
> > >  5 files changed, 48 insertions(+), 4 deletions(-)
> > > 
> > > diff --git a/include/net/inet_connection_sock.h b/include/net/inet_connection_sock.h
> > > index 7338b3865a2a..2ea2d743f8fc 100644
> > > --- a/include/net/inet_connection_sock.h
> > > +++ b/include/net/inet_connection_sock.h
> > > @@ -260,6 +260,7 @@ struct dst_entry *inet_csk_route_child_sock(const struct sock *sk,
> > >  struct sock *inet_csk_reqsk_queue_add(struct sock *sk,
> > >  				      struct request_sock *req,
> > >  				      struct sock *child);
> > > +void inet_csk_reqsk_queue_migrate(struct sock *sk, struct sock *nsk);
> > >  void inet_csk_reqsk_queue_hash_add(struct sock *sk, struct request_sock *req,
> > >  				   unsigned long timeout);
> > >  struct sock *inet_csk_complete_hashdance(struct sock *sk, struct sock *child,
> > > diff --git a/include/net/sock_reuseport.h b/include/net/sock_reuseport.h
> > > index 0e558ca7afbf..09a1b1539d4c 100644
> > > --- a/include/net/sock_reuseport.h
> > > +++ b/include/net/sock_reuseport.h
> > > @@ -31,7 +31,7 @@ struct sock_reuseport {
> > >  extern int reuseport_alloc(struct sock *sk, bool bind_inany);
> > >  extern int reuseport_add_sock(struct sock *sk, struct sock *sk2,
> > >  			      bool bind_inany);
> > > -extern void reuseport_detach_sock(struct sock *sk);
> > > +extern struct sock *reuseport_detach_sock(struct sock *sk);
> > >  extern struct sock *reuseport_select_sock(struct sock *sk,
> > >  					  u32 hash,
> > >  					  struct sk_buff *skb,
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
> > >  
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
> > 
> > Are you sure lockdep is happy with this ?
> > 
> > I would guess it should complain, because :
> > 
> > lock(A);
> > lock(B);
> > ...
> > unlock(B);
> > unlock(A);
> > 
> > will fail when the opposite action happens eventually
> > 
> > lock(B);
> > lock(A);
> > ...
> > unlock(A);
> > unlock(B);
> 
> I enabled lockdep and did not see warnings of lockdep.
> 
> Also, the inversion deadlock does not happen in this case.
> In reuseport_detach_sock(), sk is moved backward in socks[] and poped out
> from the eBPF map, so the old listener will not be selected as the new
> listener.
> 
> 
> > > +
> > > +	if (old_accept_queue->rskq_accept_head) {
> > > +		if (new_accept_queue->rskq_accept_head)
> > > +			old_accept_queue->rskq_accept_tail->dl_next =
> > > +				new_accept_queue->rskq_accept_head;
> > > +		else
> > > +			new_accept_queue->rskq_accept_tail = old_accept_queue->rskq_accept_tail;
> > > +
> > > +		new_accept_queue->rskq_accept_head = old_accept_queue->rskq_accept_head;
> > > +		old_accept_queue->rskq_accept_head = NULL;
> > > +		old_accept_queue->rskq_accept_tail = NULL;
> > > +
> > > +		WRITE_ONCE(nsk->sk_ack_backlog, nsk->sk_ack_backlog + sk->sk_ack_backlog);
> > > +		WRITE_ONCE(sk->sk_ack_backlog, 0);
> > > +	}
> > > +
> > > +	spin_unlock(&new_accept_queue->rskq_lock);
> > > +	spin_unlock(&old_accept_queue->rskq_lock);
> > > +}
> > > +EXPORT_SYMBOL(inet_csk_reqsk_queue_migrate);
> > 
> > I fail to understand how the kernel can run fine right after this patch, before following patches are merged.
> 
> I will squash the two or reorganize them into definition part and migration
> part.
> 
> 
> > All request sockets in the socket accept queue MUST have their rsk_listener set to the listener,
> > this is how we designed things (each request socket has a reference taken on the listener)
> > 
> > We might even have some "BUG_ON(sk != req->rsk_listener);" in some places.
> > 
> > Since you splice list from old listener to the new one, without changing req->rsk_listener, bad things will happen.
I also have similar concern on the inconsistency in req->rsk_listener.

The fix-up in req->rsk_listener for the TFO req in patch 4
makes it clear that req->rsk_listener should be updated during
the migration instead of asking a much later code path
to accommodate this inconsistent req->rsk_listener pointer.

The current inet_csk_listen_stop() is already iterating
the icsk_accept_queue and fastopenq.  The extra cost
in updating rsk_listener may be just noise?

> > 
> > I feel the order of your patches is not correct.
> 
> I understand this series is against the design.
> But once the requests sockets are added in the queue, they are accessed
> from the accept queue, and then we have the correct listener and can
> rewirte rsk_listener. Otherwise, their full socket are accessed instead.
> 
> Also, as far as I know, such BUG_ON was only in inet_child_forget().

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 947CA2D247D
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 08:37:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727386AbgLHHgB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 02:36:01 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:14272 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726299AbgLHHgA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Dec 2020 02:36:00 -0500
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.43/8.16.0.43) with SMTP id 0B87YLcM030582;
        Mon, 7 Dec 2020 23:34:57 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=b7OdMcgk2oWlTXOTUk1Odn+J2TcRp9egLz8p8Ka7itw=;
 b=Cf8tj+LSteTelQUKCIgyBEwL42X5p6Du9eMxGy83BfAyekWxAduVxGszZrLT2fBVr+dP
 km6ToDdloZWYBoTsVBPqZdEfDMAz4qHehwHtWv2nCLPvwex4mtQ4VplxZC7PYSguL3aV
 7g19iV92lSLQHbySf9CnSXr523hG4UaEphY= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net with ESMTP id 3588027bxq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 07 Dec 2020 23:34:56 -0800
Received: from NAM02-BL2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 7 Dec 2020 23:34:49 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nyG1W86nV5guydi6s7bYiLFFSM0AX4yG0GYYEHjvVSV932oh5P69hou50VDGS0ooIqu13oNwPCYQBYp5nQbKqhUN0E/D3tYOWWo8Ry/Yn4clblmZeSeG7t2yPfZdE0AfsyaU7/ps+jAfHDdsyp1bxThPPoY5PHgXn0UQJ9zrTWyF/F4Xv9kmyOh198Oa/itb/NMYzT0CtbpXDnfa4c9hxUMEbgK/bnzqmZEyG+zSDStHGQoRBCzvrxO5/RuF0aSGKRR5beAwHu1HbbCFSQYIv5ux1iMR2NxhNFaPCMvkMQ+RfLr3JxW3Fg9+g8hGmmorxtOv9BlTTptYATe3KmojdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b7OdMcgk2oWlTXOTUk1Odn+J2TcRp9egLz8p8Ka7itw=;
 b=nJKkVlhTn+F33Cob4EhLmhf9FajOuQU/4CmgbIebxE/X++kzd/xeIWIq/wI8Hy89MLPP0oNLAXSoUH+uD9P/P4n9ydpsE69cuvBEAajpP0xKct+Bwe+dsbJFfkzfsqVfWZa5oXjyHisdl50U6DVfCAKak51DIlVMoDAduv++zHsX2IMcHmIBW2K5sa0aBORrJFSbbN5Goi/5msSUGSCctqmlzaHS2oJ+MU/zFzha8Gpl3tHqYwzkR9W829D1o0Ck+YgUbV0GRPEDpne0s+u55PuVcc6mKhgAfAVyEFQ1Hyazn23+0k7dEviSMCxDygJHUuq2YMEuM+vHJKQh8pfyYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b7OdMcgk2oWlTXOTUk1Odn+J2TcRp9egLz8p8Ka7itw=;
 b=L3iBuCfuE6a/1hlQJ/ajOVQw9dTMXfzmKgwDzMV+tGKn+sF0MWf8SMNf05rzdtRhS3zWh+sCV3ek2cWYuWIxS4by09QbDvqeJ/rL5J5ZpPcWpkpt2DA3sPzHZ0iwyET1xNhhiqmW7I8WehkAYmVW5z8jWvwiYIKaFqIgCis6lAo=
Authentication-Results: amazon.co.jp; dkim=none (message not signed)
 header.d=none;amazon.co.jp; dmarc=none action=none header.from=fb.com;
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by BYAPR15MB2728.namprd15.prod.outlook.com (2603:10b6:a03:14c::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.21; Tue, 8 Dec
 2020 07:34:48 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::2831:21bf:8060:a0b]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::2831:21bf:8060:a0b%7]) with mapi id 15.20.3632.023; Tue, 8 Dec 2020
 07:34:48 +0000
Date:   Mon, 7 Dec 2020 23:34:41 -0800
From:   Martin KaFai Lau <kafai@fb.com>
To:     Kuniyuki Iwashima <kuniyu@amazon.co.jp>
CC:     <ast@kernel.org>, <benh@amazon.com>, <bpf@vger.kernel.org>,
        <daniel@iogearbox.net>, <davem@davemloft.net>,
        <edumazet@google.com>, <eric.dumazet@gmail.com>, <kuba@kernel.org>,
        <kuni1840@gmail.com>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>
Subject: Re: [PATCH v1 bpf-next 03/11] tcp: Migrate
 TCP_ESTABLISHED/TCP_SYN_RECV sockets in accept queues.
Message-ID: <20201208073441.3ya5s7lkqzed25l6@kafai-mbp.dhcp.thefacebook.com>
References: <20201207203227.lcwdihxfwral3uz7@kafai-mbp.dhcp.thefacebook.com>
 <20201208063134.97189-1-kuniyu@amazon.co.jp>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201208063134.97189-1-kuniyu@amazon.co.jp>
X-Originating-IP: [2620:10d:c090:400::5:565a]
X-ClientProxiedBy: CO2PR18CA0066.namprd18.prod.outlook.com
 (2603:10b6:104:2::34) To BY5PR15MB3571.namprd15.prod.outlook.com
 (2603:10b6:a03:1f6::32)
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:565a) by CO2PR18CA0066.namprd18.prod.outlook.com (2603:10b6:104:2::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12 via Frontend Transport; Tue, 8 Dec 2020 07:34:47 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c2c2278d-03e2-42b8-3f55-08d89b4bbe12
X-MS-TrafficTypeDiagnostic: BYAPR15MB2728:
X-Microsoft-Antispam-PRVS: <BYAPR15MB2728B4AF0C9954C668E9C0C2D5CD0@BYAPR15MB2728.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: v+2AzKuqWHHWf4N0cSPhY0i9Ld/yHhVLB7QXXhTyWM0ToPi7btJ9zmTo8Rbzo0PA5lg+e1TY1q6NrgAnDFPwNEfKyQKDS5P7r8HZiKlarUi5tuE5skeSnKsT+GvXWw4mMEp7fLqT+W5oU+aiXDfR3qNKv60anKP4bhLGUdDy2/UD/vQeavwNVWrQV9XVwYzMjyMvG2LQJYD9YyAGmkLPXXjrPXW1x0kUWugyeu9fH+xnnb01xlAy+39vkV7j/cFrf7Qr8OSPphOtV7Ng/phqA4CrzUepmM05yy/zxO+jFdwlECsdDEAehCSdLi7BmWp5Uhd4CDGNReml2hnDTYu9VdfePmx9OnMGwtksmFrHwXYsSWVD8E5DNC+M1GVCKn3Xnxow5smlKU9KV3rq5EBreA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(136003)(376002)(366004)(396003)(39860400002)(6666004)(966005)(1076003)(8676002)(6916009)(86362001)(6506007)(66476007)(66556008)(5660300002)(186003)(316002)(7416002)(9686003)(53546011)(4326008)(8936002)(55016002)(16526019)(30864003)(66946007)(7696005)(52116002)(83380400001)(2906002)(478600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?Szipn7ZFwU8Xx5IGHYlkfj/MhOi0FfG9Ypj/WC9ChV4jKs+DdMmm+jAO+dJM?=
 =?us-ascii?Q?eVgR2tEv2W2g43BP3Ijw0KuWxtTcdfVprfMxELbn/wYLg0FL/VAbWdUzwyAh?=
 =?us-ascii?Q?J0bKykTiFTpSbD5DGN5FkUIFjKTviYolxMLCHt6JrWFiUg/NW6UgD/pv6nWf?=
 =?us-ascii?Q?C5F+eeo1hrHAhyOoYZWyy+QsrSgJ04dwcd1GWgXlU9SEETeMKtuwdv+a5n0m?=
 =?us-ascii?Q?BQR07kJYKUCkj8+5hkqMNBFHHHUGAKET4c7Go1Ve2GHxzJIht660Gh/5LH/G?=
 =?us-ascii?Q?/hw5pFusv8QhbjMr8BXpzq+kd16E/l+xztepRm3iJdUH9NHoyKqpU9Ru/rVq?=
 =?us-ascii?Q?X/2GBHvPisTW2qjkRMi43BT2XkQUlqvg19u8XDxOFfeeYTzxHoEasbvKcKUx?=
 =?us-ascii?Q?hN7PkKrfZfffGseQFiq2Tq3iiYnTyhz7mBDtwwaQ35Lpdr76U6CygrpWfB15?=
 =?us-ascii?Q?Z4GliN16awLJVO1UmSjPjEuMS2tXmQ5ZluCpv377EsQEz2mDiY4/f+vFVC2E?=
 =?us-ascii?Q?XWhBLYfTP0vDsIuYQX1H0e98r4ZLoFmb+2g1expjxqht79nGePbtKzLtCQX/?=
 =?us-ascii?Q?ldXnNYYZTn+4v3B8B9UQwAsvAxdmzlR1kYT+pfQg+6pxI6Wvsj2tR+R3pGze?=
 =?us-ascii?Q?bAgmI1QlH6VeevVedUbXMnmO88KEwmoZuyDBoo3EOp9msu0vTuTIRd+i/ij3?=
 =?us-ascii?Q?SwwntfUlXNuIw7bCr3vBVobCrkbmqpOWuI/iRBsREL8tSSJ2wHTeIK44F/8E?=
 =?us-ascii?Q?5wa2kinYwrQGcUxpzJj/Bbb5AIF1dvhM21VlCzRSV6yjxDsI5YniZOxOABVK?=
 =?us-ascii?Q?PAJZpBwtGMhLr83JUSV2eTWXTf9JTYuw9lN7VjIPF84UcuAPQWOduS7tK/fl?=
 =?us-ascii?Q?wmtCYIJuIY4HxYYBgqUj2CzdSFXj/hLY0dsC2YnCdeFSI+GvQN20ibxvyNfM?=
 =?us-ascii?Q?RoGbfTvuHfP5kZi1OTMmCNPCtAEZOEjEoif5/rI3kwrjXoweLKvnlgRlAfUv?=
 =?us-ascii?Q?oGCJaN7bOqaLy0hTNuW0ENDbEA=3D=3D?=
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB3571.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2020 07:34:48.6394
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-Network-Message-Id: c2c2278d-03e2-42b8-3f55-08d89b4bbe12
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iO1c6alYVw15lTcVCVRjlopqW+w6Dh80S2F1nhYuSfxFDJWmpebp8Gz2Lm8m+Z7r
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2728
X-OriginatorOrg: fb.com
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-08_03:2020-12-04,2020-12-08 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 malwarescore=0 bulkscore=0 phishscore=0 mlxlogscore=999 suspectscore=0
 adultscore=0 impostorscore=0 spamscore=0 mlxscore=0 clxscore=1015
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012080046
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 08, 2020 at 03:31:34PM +0900, Kuniyuki Iwashima wrote:
> From:   Martin KaFai Lau <kafai@fb.com>
> Date:   Mon, 7 Dec 2020 12:33:15 -0800
> > On Thu, Dec 03, 2020 at 11:14:24PM +0900, Kuniyuki Iwashima wrote:
> > > From:   Eric Dumazet <eric.dumazet@gmail.com>
> > > Date:   Tue, 1 Dec 2020 16:25:51 +0100
> > > > On 12/1/20 3:44 PM, Kuniyuki Iwashima wrote:
> > > > > This patch lets reuseport_detach_sock() return a pointer of struct sock,
> > > > > which is used only by inet_unhash(). If it is not NULL,
> > > > > inet_csk_reqsk_queue_migrate() migrates TCP_ESTABLISHED/TCP_SYN_RECV
> > > > > sockets from the closing listener to the selected one.
> > > > > 
> > > > > Listening sockets hold incoming connections as a linked list of struct
> > > > > request_sock in the accept queue, and each request has reference to a full
> > > > > socket and its listener. In inet_csk_reqsk_queue_migrate(), we only unlink
> > > > > the requests from the closing listener's queue and relink them to the head
> > > > > of the new listener's queue. We do not process each request and its
> > > > > reference to the listener, so the migration completes in O(1) time
> > > > > complexity. However, in the case of TCP_SYN_RECV sockets, we take special
> > > > > care in the next commit.
> > > > > 
> > > > > By default, the kernel selects a new listener randomly. In order to pick
> > > > > out a different socket every time, we select the last element of socks[] as
> > > > > the new listener. This behaviour is based on how the kernel moves sockets
> > > > > in socks[]. (See also [1])
> > > > > 
> > > > > Basically, in order to redistribute sockets evenly, we have to use an eBPF
> > > > > program called in the later commit, but as the side effect of such default
> > > > > selection, the kernel can redistribute old requests evenly to new listeners
> > > > > for a specific case where the application replaces listeners by
> > > > > generations.
> > > > > 
> > > > > For example, we call listen() for four sockets (A, B, C, D), and close the
> > > > > first two by turns. The sockets move in socks[] like below.
> > > > > 
> > > > >   socks[0] : A <-.      socks[0] : D          socks[0] : D
> > > > >   socks[1] : B   |  =>  socks[1] : B <-.  =>  socks[1] : C
> > > > >   socks[2] : C   |      socks[2] : C --'
> > > > >   socks[3] : D --'
> > > > > 
> > > > > Then, if C and D have newer settings than A and B, and each socket has a
> > > > > request (a, b, c, d) in their accept queue, we can redistribute old
> > > > > requests evenly to new listeners.
> > > > > 
> > > > >   socks[0] : A (a) <-.      socks[0] : D (a + d)      socks[0] : D (a + d)
> > > > >   socks[1] : B (b)   |  =>  socks[1] : B (b) <-.  =>  socks[1] : C (b + c)
> > > > >   socks[2] : C (c)   |      socks[2] : C (c) --'
> > > > >   socks[3] : D (d) --'
> > > > > 
> > > > > Here, (A, D) or (B, C) can have different application settings, but they
> > > > > MUST have the same settings at the socket API level; otherwise, unexpected
> > > > > error may happen. For instance, if only the new listeners have
> > > > > TCP_SAVE_SYN, old requests do not have SYN data, so the application will
> > > > > face inconsistency and cause an error.
> > > > > 
> > > > > Therefore, if there are different kinds of sockets, we must attach an eBPF
> > > > > program described in later commits.
> > > > > 
> > > > > Link: https://lore.kernel.org/netdev/CAEfhGiyG8Y_amDZ2C8dQoQqjZJMHjTY76b=KBkTKcBtA=dhdGQ@mail.gmail.com/
> > > > > Reviewed-by: Benjamin Herrenschmidt <benh@amazon.com>
> > > > > Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
> > > > > ---
> > > > >  include/net/inet_connection_sock.h |  1 +
> > > > >  include/net/sock_reuseport.h       |  2 +-
> > > > >  net/core/sock_reuseport.c          | 10 +++++++++-
> > > > >  net/ipv4/inet_connection_sock.c    | 30 ++++++++++++++++++++++++++++++
> > > > >  net/ipv4/inet_hashtables.c         |  9 +++++++--
> > > > >  5 files changed, 48 insertions(+), 4 deletions(-)
> > > > > 
> > > > > diff --git a/include/net/inet_connection_sock.h b/include/net/inet_connection_sock.h
> > > > > index 7338b3865a2a..2ea2d743f8fc 100644
> > > > > --- a/include/net/inet_connection_sock.h
> > > > > +++ b/include/net/inet_connection_sock.h
> > > > > @@ -260,6 +260,7 @@ struct dst_entry *inet_csk_route_child_sock(const struct sock *sk,
> > > > >  struct sock *inet_csk_reqsk_queue_add(struct sock *sk,
> > > > >  				      struct request_sock *req,
> > > > >  				      struct sock *child);
> > > > > +void inet_csk_reqsk_queue_migrate(struct sock *sk, struct sock *nsk);
> > > > >  void inet_csk_reqsk_queue_hash_add(struct sock *sk, struct request_sock *req,
> > > > >  				   unsigned long timeout);
> > > > >  struct sock *inet_csk_complete_hashdance(struct sock *sk, struct sock *child,
> > > > > diff --git a/include/net/sock_reuseport.h b/include/net/sock_reuseport.h
> > > > > index 0e558ca7afbf..09a1b1539d4c 100644
> > > > > --- a/include/net/sock_reuseport.h
> > > > > +++ b/include/net/sock_reuseport.h
> > > > > @@ -31,7 +31,7 @@ struct sock_reuseport {
> > > > >  extern int reuseport_alloc(struct sock *sk, bool bind_inany);
> > > > >  extern int reuseport_add_sock(struct sock *sk, struct sock *sk2,
> > > > >  			      bool bind_inany);
> > > > > -extern void reuseport_detach_sock(struct sock *sk);
> > > > > +extern struct sock *reuseport_detach_sock(struct sock *sk);
> > > > >  extern struct sock *reuseport_select_sock(struct sock *sk,
> > > > >  					  u32 hash,
> > > > >  					  struct sk_buff *skb,
> > > > > diff --git a/net/core/sock_reuseport.c b/net/core/sock_reuseport.c
> > > > > index fd133516ac0e..60d7c1f28809 100644
> > > > > --- a/net/core/sock_reuseport.c
> > > > > +++ b/net/core/sock_reuseport.c
> > > > > @@ -216,9 +216,11 @@ int reuseport_add_sock(struct sock *sk, struct sock *sk2, bool bind_inany)
> > > > >  }
> > > > >  EXPORT_SYMBOL(reuseport_add_sock);
> > > > >  
> > > > > -void reuseport_detach_sock(struct sock *sk)
> > > > > +struct sock *reuseport_detach_sock(struct sock *sk)
> > > > >  {
> > > > >  	struct sock_reuseport *reuse;
> > > > > +	struct bpf_prog *prog;
> > > > > +	struct sock *nsk = NULL;
> > > > >  	int i;
> > > > >  
> > > > >  	spin_lock_bh(&reuseport_lock);
> > > > > @@ -242,8 +244,12 @@ void reuseport_detach_sock(struct sock *sk)
> > > > >  
> > > > >  		reuse->num_socks--;
> > > > >  		reuse->socks[i] = reuse->socks[reuse->num_socks];
> > > > > +		prog = rcu_dereference(reuse->prog);
> > > > >  
> > > > >  		if (sk->sk_protocol == IPPROTO_TCP) {
> > > > > +			if (reuse->num_socks && !prog)
> > > > > +				nsk = i == reuse->num_socks ? reuse->socks[i - 1] : reuse->socks[i];
> > > > > +
> > > > >  			reuse->num_closed_socks++;
> > > > >  			reuse->socks[reuse->max_socks - reuse->num_closed_socks] = sk;
> > > > >  		} else {
> > > > > @@ -264,6 +270,8 @@ void reuseport_detach_sock(struct sock *sk)
> > > > >  		call_rcu(&reuse->rcu, reuseport_free_rcu);
> > > > >  out:
> > > > >  	spin_unlock_bh(&reuseport_lock);
> > > > > +
> > > > > +	return nsk;
> > > > >  }
> > > > >  EXPORT_SYMBOL(reuseport_detach_sock);
> > > > >  
> > > > > diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
> > > > > index 1451aa9712b0..b27241ea96bd 100644
> > > > > --- a/net/ipv4/inet_connection_sock.c
> > > > > +++ b/net/ipv4/inet_connection_sock.c
> > > > > @@ -992,6 +992,36 @@ struct sock *inet_csk_reqsk_queue_add(struct sock *sk,
> > > > >  }
> > > > >  EXPORT_SYMBOL(inet_csk_reqsk_queue_add);
> > > > >  
> > > > > +void inet_csk_reqsk_queue_migrate(struct sock *sk, struct sock *nsk)
> > > > > +{
> > > > > +	struct request_sock_queue *old_accept_queue, *new_accept_queue;
> > > > > +
> > > > > +	old_accept_queue = &inet_csk(sk)->icsk_accept_queue;
> > > > > +	new_accept_queue = &inet_csk(nsk)->icsk_accept_queue;
> > > > > +
> > > > > +	spin_lock(&old_accept_queue->rskq_lock);
> > > > > +	spin_lock(&new_accept_queue->rskq_lock);
> > > > 
> > > > Are you sure lockdep is happy with this ?
> > > > 
> > > > I would guess it should complain, because :
> > > > 
> > > > lock(A);
> > > > lock(B);
> > > > ...
> > > > unlock(B);
> > > > unlock(A);
> > > > 
> > > > will fail when the opposite action happens eventually
> > > > 
> > > > lock(B);
> > > > lock(A);
> > > > ...
> > > > unlock(A);
> > > > unlock(B);
> > > 
> > > I enabled lockdep and did not see warnings of lockdep.
> > > 
> > > Also, the inversion deadlock does not happen in this case.
> > > In reuseport_detach_sock(), sk is moved backward in socks[] and poped out
> > > from the eBPF map, so the old listener will not be selected as the new
> > > listener.
> > > 
> > > 
> > > > > +
> > > > > +	if (old_accept_queue->rskq_accept_head) {
> > > > > +		if (new_accept_queue->rskq_accept_head)
> > > > > +			old_accept_queue->rskq_accept_tail->dl_next =
> > > > > +				new_accept_queue->rskq_accept_head;
> > > > > +		else
> > > > > +			new_accept_queue->rskq_accept_tail = old_accept_queue->rskq_accept_tail;
> > > > > +
> > > > > +		new_accept_queue->rskq_accept_head = old_accept_queue->rskq_accept_head;
> > > > > +		old_accept_queue->rskq_accept_head = NULL;
> > > > > +		old_accept_queue->rskq_accept_tail = NULL;
> > > > > +
> > > > > +		WRITE_ONCE(nsk->sk_ack_backlog, nsk->sk_ack_backlog + sk->sk_ack_backlog);
> > > > > +		WRITE_ONCE(sk->sk_ack_backlog, 0);
> > > > > +	}
> > > > > +
> > > > > +	spin_unlock(&new_accept_queue->rskq_lock);
> > > > > +	spin_unlock(&old_accept_queue->rskq_lock);
> > > > > +}
> > > > > +EXPORT_SYMBOL(inet_csk_reqsk_queue_migrate);
> > > > 
> > > > I fail to understand how the kernel can run fine right after this patch, before following patches are merged.
> > > 
> > > I will squash the two or reorganize them into definition part and migration
> > > part.
> > > 
> > > 
> > > > All request sockets in the socket accept queue MUST have their rsk_listener set to the listener,
> > > > this is how we designed things (each request socket has a reference taken on the listener)
> > > > 
> > > > We might even have some "BUG_ON(sk != req->rsk_listener);" in some places.
> > > > 
> > > > Since you splice list from old listener to the new one, without changing req->rsk_listener, bad things will happen.
> > I also have similar concern on the inconsistency in req->rsk_listener.
> > 
> > The fix-up in req->rsk_listener for the TFO req in patch 4
> > makes it clear that req->rsk_listener should be updated during
> > the migration instead of asking a much later code path
> > to accommodate this inconsistent req->rsk_listener pointer.
> 
> When I started this patchset, I read this thread and misunderstood that I
> had to migrate sockets in O(1) for scalability. So, I selected the fix-up
> approach and checked rsk_listener is not used except for TFO.
> 
> ---8<---
> Whole point of BPF was to avoid iterate through all sockets [1],
> and let user space use whatever selection logic it needs.
> 
> [1] This was okay with up to 16 sockets. But with 128 it does not scale.
> ---&<---
> https://lore.kernel.org/netdev/1458837191.12033.4.camel@edumazet-glaptop3.roam.corp.google.com/
> 
> 
> However, I've read it again, and this was about iterating over listeners
> to select a new listener, not about iterating over requests...
> In this patchset, we can select a listener in O(1) and it is enough.
> 
> 
> > The current inet_csk_listen_stop() is already iterating
> > the icsk_accept_queue and fastopenq.  The extra cost
> > in updating rsk_listener may be just noise?
> 
> Exactly.
> If we end up iterating requests, it is better to migrate than close. I will
> update each rsk_listener in inet_csk_reqsk_queue_migrate() in v3 patchset.
To be clear, I meant to do migration in inet_csk_listen_stop() instead
of doing it in the new inet_csk_reqsk_queue_migrate() which reqires a
double lock and then need to re-bring in the whole spin_lock_bh_nested
patch in the patch 3 of v2.

e.g. in the first while loop in inet_csk_listen_stop(),
if there is a target to migrate to,  it can do
something similar to inet_csk_reqsk_queue_add(target_sk, ...)
instead of doing the current inet_child_forget().
It probably needs something different from
inet_csk_reqsk_queue_add(), e.g. also update rsk_listener,
but the idea should be similar.

Since the rsk_listener has to be updated one by one, there is
really no point to do the list splicing which requires
the double lock.

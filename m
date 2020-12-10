Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 475742D6594
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 19:55:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393193AbgLJSvg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Dec 2020 13:51:36 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:51916 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2390870AbgLJSuc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Dec 2020 13:50:32 -0500
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0BAIitDf019591;
        Thu, 10 Dec 2020 10:49:25 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=IVMcHM+x2m9dqjfoowjg+nrK9EW3PSzfbSbBxqZAZq8=;
 b=PwN8cWJakM0Bv1838RK2tEBm9d8mCEMOlduosU5/hgu5qf0JcpsZAmt0qHZJrEnj+vAB
 WVfsqqkynHETkk4jU/11kiA8kY9cx6/2QDQnLaY10wXGqSUVUop63FvZlKBzFBqST73R
 ThD/SozgzB1GeryJJo/qR7CfB1br5CFoiX4= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 35avdhafsk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 10 Dec 2020 10:49:25 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.199) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 10 Dec 2020 10:49:24 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NiIgxIpZ78P00p4jN95azUNGiT0b1+14q8EfRBn0Ax7141gzpRmccWChJCgtWCWntG+EvzWbxZEQg5yhd3HMhgSbpsDbUoFze5Om8NJImeg3+Z9ZKbO4bjjxLt9SzMYoS2zKGETttUjU5Bz0AIBhSS4TxUVazke2BcvTtebe8URQlfijoq5gtoJ9fXggb3GADqACCqnNGYS4ZUllk12vc9nSeqLoU8mM+79XRwcv8M+A8FVDDgv5zkHvuGq8y3uGUjg96BKPoI+RfGIikswfrQDgjH3W5UTz3HGIUHo1J6Ypbs9TPUWImWIzHIo/vXULw1/OXdz+fZ5uKu0N74GBzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IVMcHM+x2m9dqjfoowjg+nrK9EW3PSzfbSbBxqZAZq8=;
 b=IXWgkQrtQ+/FE9xi8ZPn2pcO2bHN18bK2KgHG91DLaqsjX2HHV8VJXHnM8eYCBqbRPrprGNUSQjJdCq/tG056QgTHaXc/HKiUVeVRzAQI2xTQJH7hNl44Lw3TIcidZWlsKfCkmAbIVLVrI1TouuAV4WqMOeZxCcHW0m/kFMEVAmyDird+zic5ckCccKFbT/L54CIS9j1RHDyly/RWrHzpj4xKdy9hMQMCcnaqinNIUeIwMUN1/Cu/ESjHwcmGaexz17wWJzdF4HVPkhe65+UvgItfyKjbx/Z8eCfD2YbjMn73KEZRy1iHMIES2hPhEzpKUllHKz1YtRoqVPXzihimQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IVMcHM+x2m9dqjfoowjg+nrK9EW3PSzfbSbBxqZAZq8=;
 b=JuyeSd7riickxTkFgGvKesyEut1YJC+MXNQRaIqN4wiVc6nrlMUnZgidN/o041lC2omv5765r93EdOoIcQutwgbOHYl11ncTxsFA3qLr1UuclFXVePcu76NnPrM5swwO0ntWVg+4QINxxPuGJBgElRXLCdSmWT2rAzmGXlT0ZQQ=
Authentication-Results: amazon.co.jp; dkim=none (message not signed)
 header.d=none;amazon.co.jp; dmarc=none action=none header.from=fb.com;
Received: from CH2PR15MB3573.namprd15.prod.outlook.com (2603:10b6:610:e::28)
 by CH2PR15MB3703.namprd15.prod.outlook.com (2603:10b6:610:11::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.17; Thu, 10 Dec
 2020 18:49:22 +0000
Received: from CH2PR15MB3573.namprd15.prod.outlook.com
 ([fe80::81f0:e22:522e:9dd]) by CH2PR15MB3573.namprd15.prod.outlook.com
 ([fe80::81f0:e22:522e:9dd%7]) with mapi id 15.20.3632.021; Thu, 10 Dec 2020
 18:49:22 +0000
Date:   Thu, 10 Dec 2020 10:49:15 -0800
From:   Martin KaFai Lau <kafai@fb.com>
To:     Kuniyuki Iwashima <kuniyu@amazon.co.jp>
CC:     <ast@kernel.org>, <benh@amazon.com>, <bpf@vger.kernel.org>,
        <daniel@iogearbox.net>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <kuni1840@gmail.com>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
Subject: Re: [PATCH v1 bpf-next 05/11] tcp: Migrate TCP_NEW_SYN_RECV requests.
Message-ID: <20201210184915.4codwsoufxdhtj3o@kafai-mbp.dhcp.thefacebook.com>
References: <20201210000707.cxm2r57mbsq2p6uu@kafai-mbp.dhcp.thefacebook.com>
 <20201210051538.23059-1-kuniyu@amazon.co.jp>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201210051538.23059-1-kuniyu@amazon.co.jp>
X-Originating-IP: [2620:10d:c090:400::5:ad7]
X-ClientProxiedBy: BY5PR17CA0012.namprd17.prod.outlook.com
 (2603:10b6:a03:1b8::25) To CH2PR15MB3573.namprd15.prod.outlook.com
 (2603:10b6:610:e::28)
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:ad7) by BY5PR17CA0012.namprd17.prod.outlook.com (2603:10b6:a03:1b8::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12 via Frontend Transport; Thu, 10 Dec 2020 18:49:21 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 88438972-15bd-457d-29c3-08d89d3c4f69
X-MS-TrafficTypeDiagnostic: CH2PR15MB3703:
X-Microsoft-Antispam-PRVS: <CH2PR15MB37031F58534C4EE5BB51DB91D5CB0@CH2PR15MB3703.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:3826;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8N6OL+gxDHUbtFTeI3h5kBq8UnkdWVqFFuxQUv590VDLP1JJjz86c0o15KUJ9QnLlP0C30DkFs3+rob07CUcWjwyDhzU9GiPfDnkwKV/6BcqixRQ0/zb32KhdcO6Nl8vtKPXDKR+J3E+LTcSTejlJ3Hefqp6jnY+wl686arC/NxWjoXltGKg4JBef2QKE1OirfUdZkjcuuf7R3gxnckrXMmXODJ+h/4xIiP7kJjeGKLJAyrhEE0qKRNfu0IEKFzKApw8NHd66w20k9eP9MPLur0w0zVSaAxIO9o9y2CKU07yVTFwPQseKtEegx1EIWf+06Mw4o43IhI44hgc16lw7IKupBEqDu2bJMHz2dnhGEmKnbYDB6Y+M39Ax+O4Y0zs0B+lDInMmOaPnh7zQtzyYg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR15MB3573.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(346002)(136003)(376002)(7416002)(9686003)(66946007)(66476007)(2906002)(66556008)(508600001)(83380400001)(86362001)(4326008)(8676002)(6666004)(966005)(16526019)(5660300002)(1076003)(186003)(8936002)(6506007)(55016002)(52116002)(6916009)(7696005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?zwelcWiJiZXlL+LfpV9RiSwyGZ71sRP5VN7PeQQ0gmKcLuOMd2EowZ83ceJo?=
 =?us-ascii?Q?XyVcuZ48bX8e+AqtdSoMx8Ki9OdUlxGP+lnjDxrTdM7AODBPT4lJY2BxafDu?=
 =?us-ascii?Q?GMcEULHeimZkvo9AP96EYA++BbAmxDT5JOGZ2ncCX6xE3MXzIPNdbeh64cr9?=
 =?us-ascii?Q?/P3nhR6XAs0NnFgiACAVLfDnaIK9ROBGF76ozijPKS0/ocv+TUOBvUOWY0do?=
 =?us-ascii?Q?UlQp3e8Ez9pxc4tFOtyvtan0QNbUYKb7MpcAOdgfg6yq1PwEOHvjN6CBw4JG?=
 =?us-ascii?Q?Xzjx6ssvQSQSAR1Wboy7LJIaPEm3Oyp4ghcpVi0PgMwhm6K78w0C/c84mDOp?=
 =?us-ascii?Q?+TXUQcwsCsifI7QyFdXfDG3/CsQW92qukRWr74O/mlwLuspp6hot9CxRPn2C?=
 =?us-ascii?Q?ZDPCoR0BtP+LM25tD2Yo9LPCOG2Q1yy7O21Zs1JmhHjv87YgfuhPqW3J2QMd?=
 =?us-ascii?Q?mHWQDSJYmzDkHIfUjvrVonHXRWvLOi3jPoCvDXpoJTMXcb4aAfNRfaJbYc+z?=
 =?us-ascii?Q?44Pt4C2wYjVpkolV10YAfQ9l5KqVde/H4IVhKVpa4hCloYAz9ryrG3OJTWHQ?=
 =?us-ascii?Q?7WrNNAeSg/zHsEIGGmsJvJhkW/+IhKKAQ0cxH+0FQ6PY0kR3waWtkuX5pp50?=
 =?us-ascii?Q?4bA0Q0smMqu/37vj/88fmUOCTFwPLIFbcRzAHYKUrPbP3uWzAdmuMgTfsUMF?=
 =?us-ascii?Q?KmiHodyP2q+TWazeMQKPOxJDze9BsP9uNbhGOJz//rHusMnSn5E83ZczYX3M?=
 =?us-ascii?Q?KphwgBa8QcDOwZDmUeTYaOqZ8L2U4wdjUT5vbRf/fszwg7yB9neHgrO36lRo?=
 =?us-ascii?Q?VDQOZNScfG6uTVNdkq+g7DFwucRGGr8nIzkUL3ObpbJymBuAH2gp7f7DHG2m?=
 =?us-ascii?Q?/J2kPFBnecBRVSTnddH17MqYNiitnLLMPOQWD2+lalyUEybJmMIWOrFNtXCG?=
 =?us-ascii?Q?TRdPBq+WSCWodnA28XTfw4gIaShV/hxz2AOr6jXvuIOptgkZdZ/0wsJKGkE5?=
 =?us-ascii?Q?tf1CnN6SeT1yCiJXyxE7ntLDzg=3D=3D?=
X-MS-Exchange-CrossTenant-AuthSource: CH2PR15MB3573.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Dec 2020 18:49:22.8076
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-Network-Message-Id: 88438972-15bd-457d-29c3-08d89d3c4f69
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iAJv1TnkKR/NL5NkQOQ0EQqOH9Q7rts9EYUkYjsuYRAKtqIQLb3xdAOY6lYK6R6b
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR15MB3703
X-OriginatorOrg: fb.com
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-10_07:2020-12-09,2020-12-10 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0
 mlxlogscore=999 lowpriorityscore=0 impostorscore=0 malwarescore=0
 clxscore=1015 bulkscore=0 suspectscore=0 adultscore=0 spamscore=0
 mlxscore=0 priorityscore=1501 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2012100117
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 10, 2020 at 02:15:38PM +0900, Kuniyuki Iwashima wrote:
> From:   Martin KaFai Lau <kafai@fb.com>
> Date:   Wed, 9 Dec 2020 16:07:07 -0800
> > On Tue, Dec 01, 2020 at 11:44:12PM +0900, Kuniyuki Iwashima wrote:
> > > This patch renames reuseport_select_sock() to __reuseport_select_sock() and
> > > adds two wrapper function of it to pass the migration type defined in the
> > > previous commit.
> > > 
> > >   reuseport_select_sock          : BPF_SK_REUSEPORT_MIGRATE_NO
> > >   reuseport_select_migrated_sock : BPF_SK_REUSEPORT_MIGRATE_REQUEST
> > > 
> > > As mentioned before, we have to select a new listener for TCP_NEW_SYN_RECV
> > > requests at receiving the final ACK or sending a SYN+ACK. Therefore, this
> > > patch also changes the code to call reuseport_select_migrated_sock() even
> > > if the listening socket is TCP_CLOSE. If we can pick out a listening socket
> > > from the reuseport group, we rewrite request_sock.rsk_listener and resume
> > > processing the request.
> > > 
> > > Reviewed-by: Benjamin Herrenschmidt <benh@amazon.com>
> > > Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
> > > ---
> > >  include/net/inet_connection_sock.h | 12 +++++++++++
> > >  include/net/request_sock.h         | 13 ++++++++++++
> > >  include/net/sock_reuseport.h       |  8 +++----
> > >  net/core/sock_reuseport.c          | 34 ++++++++++++++++++++++++------
> > >  net/ipv4/inet_connection_sock.c    | 13 ++++++++++--
> > >  net/ipv4/tcp_ipv4.c                |  9 ++++++--
> > >  net/ipv6/tcp_ipv6.c                |  9 ++++++--
> > >  7 files changed, 81 insertions(+), 17 deletions(-)
> > > 
> > > diff --git a/include/net/inet_connection_sock.h b/include/net/inet_connection_sock.h
> > > index 2ea2d743f8fc..1e0958f5eb21 100644
> > > --- a/include/net/inet_connection_sock.h
> > > +++ b/include/net/inet_connection_sock.h
> > > @@ -272,6 +272,18 @@ static inline void inet_csk_reqsk_queue_added(struct sock *sk)
> > >  	reqsk_queue_added(&inet_csk(sk)->icsk_accept_queue);
> > >  }
> > >  
> > > +static inline void inet_csk_reqsk_queue_migrated(struct sock *sk,
> > > +						 struct sock *nsk,
> > > +						 struct request_sock *req)
> > > +{
> > > +	reqsk_queue_migrated(&inet_csk(sk)->icsk_accept_queue,
> > > +			     &inet_csk(nsk)->icsk_accept_queue,
> > > +			     req);
> > > +	sock_put(sk);
> > not sure if it is safe to do here.
> > IIUC, when the req->rsk_refcnt is held, it also holds a refcnt
> > to req->rsk_listener such that sock_hold(req->rsk_listener) is
> > safe because its sk_refcnt is not zero.
> 
> I think it is safe to call sock_put() for the old listener here.
> 
> Without this patchset, at receiving the final ACK or retransmitting
> SYN+ACK, if sk_state == TCP_CLOSE, sock_put(req->rsk_listener) is done
> by calling reqsk_put() twice in inet_csk_reqsk_queue_drop_and_put().
Note that in your example (final ACK), sock_put(req->rsk_listener) is
_only_ called when reqsk_put() can get refcount_dec_and_test(&req->rsk_refcnt)
to reach zero.

Here in this patch, it sock_put(req->rsk_listener) without req->rsk_refcnt
reaching zero.

Let says there are two cores holding two refcnt to req (one cnt for each core)
by looking up the req from ehash.  One of the core do this migrate and
sock_put(req->rsk_listener).  Another core does sock_hold(req->rsk_listener).

	Core1					Core2
						sock_put(req->rsk_listener)

	sock_hold(req->rsk_listener)

> And then, we do `goto lookup;` and overwrite the sk.
> 
> In the v2 patchset, refcount_inc_not_zero() is done for the new listener in
> reuseport_select_migrated_sock(), so we have to call sock_put() for the old
> listener instead to free it properly.
> 
> ---8<---
> +struct sock *reuseport_select_migrated_sock(struct sock *sk, u32 hash,
> +					    struct sk_buff *skb)
> +{
> +	struct sock *nsk;
> +
> +	nsk = __reuseport_select_sock(sk, hash, skb, 0, BPF_SK_REUSEPORT_MIGRATE_REQUEST);
> +	if (nsk && likely(refcount_inc_not_zero(&nsk->sk_refcnt)))
There is another potential issue here.  The TCP_LISTEN nsk is protected
by rcu.  refcount_inc_not_zero(&nsk->sk_refcnt) cannot be done if it
is not under rcu_read_lock().

The receive path may be ok as it is in rcu.  You may need to check for
others.

> +		return nsk;
> +
> +	return NULL;
> +}
> +EXPORT_SYMBOL(reuseport_select_migrated_sock);
> ---8<---
> https://lore.kernel.org/netdev/20201207132456.65472-8-kuniyu@amazon.co.jp/
> 
> 
> > > +	sock_hold(nsk);
> > > +	req->rsk_listener = nsk;
It looks like there is another race here.  What
if multiple cores try to update req->rsk_listener?

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DECA38BA75
	for <lists+netdev@lfdr.de>; Fri, 21 May 2021 01:39:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234353AbhETXkx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 May 2021 19:40:53 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:64650 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234066AbhETXkw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 May 2021 19:40:52 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14KNTWw5025130;
        Thu, 20 May 2021 16:39:12 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=2FC1Xwxqn9fA3zldUusNtb6TCrkpgqyvzx2lY3Z/Ou4=;
 b=HeVPQUpa+fw5tpRUJOgdBbz9RnM2dvt+agNxDdUNnpO34JN+bdPhkEfRWw4ltqy8lhr6
 TmiOft7eN0MepWr1ZWyjYIkLB9fxDkIwdOOeVEynAWgd3GI9yVjfAji/c5141XCJ6VDL
 uojQr0ic8QFGLj6w3EbAJE+INyztLQ40ABQ= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 38n6p31ev1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 20 May 2021 16:39:12 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.196) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 20 May 2021 16:39:11 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GUq5ptJBR/LpLeGKF4Mu1oPVMt0m9s8qpYGsrWci7BGytM6/IGF0k3hRUgSBEE9X6po53O2eoJ/mQaJEN/d/yt2ZTTxgKSv1om9WPAyVcYmM7mRRrqA39+0I5FEb3T3PikHgVddotm26POpzoJZYjDI1fC6UT/8ZJo9XiZgsqPqHzwK1D7XzeIFLplgCpqb24GyvPkR59DRe+xe1tH9EYXWiQaGyOkOaZtZMZ6tDQPmkVUvG9b/lmr+OTWwcw/AzGbBOjbWZj4XY3sGayoDYZDIRk+9AXyA7fv6ZjRrCYBIervbwlVh3jev6mJudBgplA7HDB496URkhJwOWzpHnaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2FC1Xwxqn9fA3zldUusNtb6TCrkpgqyvzx2lY3Z/Ou4=;
 b=H9i+FX7/tLw6NnSpOXPt1wBgUs9+09/ndOCVC1NuQwMiI9Xxu+c4nMaPMcbA4p4QtlcDhf8r3ux2RxcaQUHRAn6w9oAwKY6yliVrtoO9QYHR5RJHiWYQAZEVV5Vh5JpKWgO05ixH1uKzYU5nH3lpdmUgCUs8c7rGb/UqTfv7k2ygTEWAj4fa2NxHoQgh59OamKH13nLtgFqjeHcD3zAhvjWwPdkwPdRJRAdgZsXJZ0qPYbWmUifUvLhcQUMufuNzGNU6o3OHoyZFYha+jnEG6lP8BbjkWZZeBrySLNP7GDfdt3kB28hIhkANTkCFuZimbpi2EmoPMqjiSD9BXOpuQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: amazon.co.jp; dkim=none (message not signed)
 header.d=none;amazon.co.jp; dmarc=none action=none header.from=fb.com;
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by BYAPR15MB2583.namprd15.prod.outlook.com (2603:10b6:a03:156::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.25; Thu, 20 May
 2021 23:39:09 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::718a:4142:4c92:732f]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::718a:4142:4c92:732f%6]) with mapi id 15.20.4150.023; Thu, 20 May 2021
 23:39:09 +0000
Date:   Thu, 20 May 2021 16:39:06 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Kuniyuki Iwashima <kuniyu@amazon.co.jp>
CC:     <andrii@kernel.org>, <ast@kernel.org>, <benh@amazon.com>,
        <bpf@vger.kernel.org>, <daniel@iogearbox.net>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <kuni1840@gmail.com>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>
Subject: Re: [PATCH v6 bpf-next 03/11] tcp: Keep TCP_CLOSE sockets in the
 reuseport group.
Message-ID: <20210520233906.c7yphwjrstqmhfk6@kafai-mbp.dhcp.thefacebook.com>
References: <20210520212201.zq3ozwx3vrobd2ua@kafai-mbp.dhcp.thefacebook.com>
 <20210520225448.14157-1-kuniyu@amazon.co.jp>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210520225448.14157-1-kuniyu@amazon.co.jp>
X-Originating-IP: [2620:10d:c090:400::5:616c]
X-ClientProxiedBy: MW4PR04CA0158.namprd04.prod.outlook.com
 (2603:10b6:303:85::13) To BY5PR15MB3571.namprd15.prod.outlook.com
 (2603:10b6:a03:1f6::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:616c) by MW4PR04CA0158.namprd04.prod.outlook.com (2603:10b6:303:85::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.23 via Frontend Transport; Thu, 20 May 2021 23:39:08 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 60849609-4c09-467d-6c20-08d91be87720
X-MS-TrafficTypeDiagnostic: BYAPR15MB2583:
X-Microsoft-Antispam-PRVS: <BYAPR15MB2583A1664BDD581183D27DB3D52A9@BYAPR15MB2583.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Soo0CIm9XKQcXJnFRwQENF4o5qXDVuWWwTv6d/4ZrH0d84E89fGG+EU0L3GAavaPZG1JTXcd/cpmMi6R7A48AMpwtDWY5WKJinR8+AU6ewfpoNa9aT1HOgHNr34imeMikWYJqSlVNQcjhDBf6wXZb1URWRyI/v7k3hAVVWznp1xaM8rgUpnrIwPAp1zEIFVGasJxaZLe4qBU4Pbt7MxN1OA2mty5oErrqomqtYKg/bbo1WLKM7y0MItt2RZAsg8G/8LTVEF2lTLdlzVJJxjdxqsLThvgpuf2MLXY4z6wmzDpr1mjEedzdJ0RBG2FgWaXgWlf5BRVpZnP6OKqDT5yJf/+1OevRbPhbz1TqBRxk7APDrR1CsdBGwJyE4sFnzMUNENaHi12EI7Lg+ZZ2ptjtgFq1bphZAOyexhLEnhtgN7U05Du3tkqwr5mpQlISd/rYfayDUrDsWMegFbFgubqfPXRis7eyuO4MxTcGiiiYfD2UQzeB0Rn+uaQGzzFgCIfqYMla0Zb4uV8eXifcv9SX1Y5Erm406YPpX+GI6shQ4eKWmthb77KwTTtPr1Tc0JYAnKkZ8a2aT9wPSYEYDK5H6XbrIS6JpL6Pp8JmKLJk/w=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(396003)(136003)(376002)(39850400004)(366004)(66946007)(6916009)(66556008)(186003)(16526019)(4326008)(52116002)(7696005)(66476007)(7416002)(316002)(8676002)(8936002)(2906002)(5660300002)(38100700002)(86362001)(83380400001)(55016002)(1076003)(478600001)(6506007)(9686003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?o8X+n7h9/hLtLYbRjJyLwDPJUv21Be/YYz/byqjWOb2727wijyS8alLY8qin?=
 =?us-ascii?Q?8CzElX6N8nb9ix1P7cDvHq/KMtp/WxVu56EwDHEVa9KTdfLoPaOaqnmbA6n3?=
 =?us-ascii?Q?PHeOvM47t62Wb3yoaNgFn1SmZhzzVsvD9I7IkXcZKGUP2VYpA3pVNJQE78gD?=
 =?us-ascii?Q?biRzqHsakJr5i62VJ5PDCyYdT54teszVslD134ozqS/oRWmtcoicencIrerM?=
 =?us-ascii?Q?hNFREzFzZwDuCEAGzr5EIr4QeWwrC2T9T1InA1mBJilCLPS7tRXZFw7Ed+AW?=
 =?us-ascii?Q?7k1m6TLcBzwlP5+8PY8dwTbah7Oaia9hlT340xRgvc3UYgC8MDNjO9r+8SHt?=
 =?us-ascii?Q?Uw2euIqdYwLXP776WUUIF5HzWgW6unFzIkpeG1T+IG4CmoHj3+SDpT5YKtIb?=
 =?us-ascii?Q?Mu2Mm/xOgiK2C6+Lipok4PnnIQVIHpkPv7nVxPXz950eNUtRIXIB7KEHG9xh?=
 =?us-ascii?Q?AZKuzYLh1aiwW3nRsn0FEVDw/bNmqgUS4N9Ed8hr6nKrw7aVoAR37Y+5XMPo?=
 =?us-ascii?Q?PYNmS75Oz2alT21sJ/aZIf9DOwY9XB3IFTqwk46PDVCpYThzXWceFeXFc+Uo?=
 =?us-ascii?Q?lJubcr3zVX8QnNkA+ZE92JPj8nkIft7NPoq6icsNxje3OwxM+t0xZg8qRABc?=
 =?us-ascii?Q?9Q/p9ar4N7y4do98CvYJuIN6ZQeQDbm4uMIXQI5GCYQeCOQId0CT0uyZZp52?=
 =?us-ascii?Q?a1DK14UkqgyW3cJLdHIon03kDnPv9/GfoetSbdZkQ9EwcP5Ab6jeUqNfJcJm?=
 =?us-ascii?Q?Zs3dXHf8H7vMrOovTyIiQrUeMwosaBw1eDzaJFp0ByUpAyNNFZ2qXBclEqRg?=
 =?us-ascii?Q?6xrSAxZ3k21keAcCu/J32pHbJRhRduaLRCFvfwJ7QfZJ9/c7EtRXZbi1OeGB?=
 =?us-ascii?Q?YVsbawc/WnlS1z+02krtpcH5TbSeDxnL4OoSAxPOjyoXyUGGoCQHFkK4f1TR?=
 =?us-ascii?Q?AhUC59Nc1DDJG1GRJ3ZHfquqFrIXPsAhtMvcxf9ZOjwUWnsIAndv2T1zD+WJ?=
 =?us-ascii?Q?IpukNbFjmzZDAU6jbepDgz/T3RkuNcpYAhUZTd4izNw4mYri1/mbKlSvIVL6?=
 =?us-ascii?Q?WK1jIlEuKnRHdIrjcH7ReN1ZXFew4iI5Ed2iLg1d5J7maMmspkaIN5JwwR5/?=
 =?us-ascii?Q?WiJCtNOEZNkB3qeLesSpM55hYF5WdrO8oIYgJGMMltRbSlO3eRg1OrY6Ux87?=
 =?us-ascii?Q?jngYAScN/lmNvN3/4658V57EO5DSym9pbhzR0RfrhTFmMlI1J+5+VH4JYgoS?=
 =?us-ascii?Q?mIL/QwTRTNq+XwRpfYfVFFV4uZtCOcCjS8vTyKGUQqHzaVSPzp6+txWxdhcE?=
 =?us-ascii?Q?+8PHj47Fuf8qZd5f1qf8pksMZb0pNnuirrL0ropFab2sWQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 60849609-4c09-467d-6c20-08d91be87720
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB3571.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 May 2021 23:39:09.6510
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HDB67MVhDXALUGb5NXPjeCM7k/gHkb6Pn97Yo1K1bjJpnAfaTi1KIuh4foR4JMkS
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2583
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: 9nFXwtgYoprv2_n4My1q_hOujZQHBkik
X-Proofpoint-GUID: 9nFXwtgYoprv2_n4My1q_hOujZQHBkik
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-20_07:2021-05-20,2021-05-20 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0
 lowpriorityscore=0 bulkscore=0 phishscore=0 clxscore=1015 mlxscore=0
 mlxlogscore=999 priorityscore=1501 impostorscore=0 suspectscore=0
 malwarescore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2104190000 definitions=main-2105200152
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 21, 2021 at 07:54:48AM +0900, Kuniyuki Iwashima wrote:
> From:   Martin KaFai Lau <kafai@fb.com>
> Date:   Thu, 20 May 2021 14:22:01 -0700
> > On Thu, May 20, 2021 at 05:51:17PM +0900, Kuniyuki Iwashima wrote:
> > > From:   Martin KaFai Lau <kafai@fb.com>
> > > Date:   Wed, 19 May 2021 23:26:48 -0700
> > > > On Mon, May 17, 2021 at 09:22:50AM +0900, Kuniyuki Iwashima wrote:
> > > > 
> > > > > +static int reuseport_resurrect(struct sock *sk, struct sock_reuseport *old_reuse,
> > > > > +			       struct sock_reuseport *reuse, bool bind_inany)
> > > > > +{
> > > > > +	if (old_reuse == reuse) {
> > > > > +		/* If sk was in the same reuseport group, just pop sk out of
> > > > > +		 * the closed section and push sk into the listening section.
> > > > > +		 */
> > > > > +		__reuseport_detach_closed_sock(sk, old_reuse);
> > > > > +		__reuseport_add_sock(sk, old_reuse);
> > > > > +		return 0;
> > > > > +	}
> > > > > +
> > > > > +	if (!reuse) {
> > > > > +		/* In bind()/listen() path, we cannot carry over the eBPF prog
> > > > > +		 * for the shutdown()ed socket. In setsockopt() path, we should
> > > > > +		 * not change the eBPF prog of listening sockets by attaching a
> > > > > +		 * prog to the shutdown()ed socket. Thus, we will allocate a new
> > > > > +		 * reuseport group and detach sk from the old group.
> > > > > +		 */
> > > > For the reuseport_attach_prog() path, I think it needs to consider
> > > > the reuse->num_closed_socks != 0 case also and that should belong
> > > > to the resurrect case.  For example, when
> > > > sk_unhashed(sk) but sk->sk_reuseport == 0.
> > > 
> > > In the path, reuseport_resurrect() is called from reuseport_alloc() only
> > > if reuse->num_closed_socks != 0.
> > > 
> > > 
> > > > @@ -92,6 +117,14 @@ int reuseport_alloc(struct sock *sk, bool bind_inany)
> > > >  	reuse = rcu_dereference_protected(sk->sk_reuseport_cb,
> > > >  					  lockdep_is_held(&reuseport_lock));
> > > >  	if (reuse) {
> > > > +		if (reuse->num_closed_socks) {
> > > 
> > > But, should this be
> > > 
> > > 	if (sk->sk_state == TCP_CLOSE && reuse->num_closed_socks)
> > > 
> > > because we need not allocate a new group when we attach a bpf prog to
> > > listeners?
> > The reuseport_alloc() is fine as is.  No need to change.
> 
> I missed sk_unhashed(sk) prevents calling reuseport_alloc()
> if sk_state == TCP_LISTEN. I'll keep it as is.
> 
> 
> > 
> > I should have copied reuseport_attach_prog() in the last reply and
> > commented there instead.
> > 
> > I meant reuseport_attach_prog() needs a change.  In reuseport_attach_prog(),
> > iiuc, currently passing the "else if (!rcu_access_pointer(sk->sk_reuseport_cb))"
> > check implies the sk was (and still is) hashed with sk_reuseport enabled
> > because the current behavior would have set sk_reuseport_cb to NULL during
> > unhash but it is no longer true now.  For example, this will break:
> > 
> > 1. shutdown(lsk); /* lsk was bound with sk_reuseport enabled */
> > 2. setsockopt(lsk, ..., SO_REUSEPORT, &zero, ...); /* disable sk_reuseport */
> > 3. setsockopt(lsk, ..., SO_ATTACH_REUSEPORT_EBPF, &prog_fd, ...);
> >    ^---- /* This will work now because sk_reuseport_cb is not NULL.
> >           * However, it shouldn't be allowed.
> > 	  */
> 
> Thank you for explanation, I understood the case.
> 
> Exactly, I've confirmed that the case succeeded in the setsockopt() and I
> could change the active listeners' prog via a shutdowned socket.
> 
> 
> > 
> > I am thinking something like this (uncompiled code):
> > 
> > int reuseport_attach_prog(struct sock *sk, struct bpf_prog *prog)
> > {
> > 	struct sock_reuseport *reuse;
> > 	struct bpf_prog *old_prog;
> > 
> > 	if (sk_unhashed(sk)) {
> > 		int err;
> > 
> > 		if (!sk->sk_reuseport)
> > 			return -EINVAL;
> > 
> > 		err = reuseport_alloc(sk, false);
> > 		if (err)
> > 			return err;
> > 	} else if (!rcu_access_pointer(sk->sk_reuseport_cb)) {
> > 		/* The socket wasn't bound with SO_REUSEPORT */
> > 		return -EINVAL;
> > 	}
> > 
> > 	/* ... */
> > }
> > 
> > WDYT?
> 
> I tested this change worked fine. I think this change should be added in
> reuseport_detach_prog() also.
> 
> ---8<---
> int reuseport_detach_prog(struct sock *sk)
> {
>         struct sock_reuseport *reuse;
>         struct bpf_prog *old_prog;
> 
>         if (!rcu_access_pointer(sk->sk_reuseport_cb))
> 		return sk->sk_reuseport ? -ENOENT : -EINVAL;
> ---8<---
Right, a quick thought is something like this for detach:

	spin_lock_bh(&reuseport_lock);
	reuse = rcu_dereference_protected(sk->sk_reuseport_cb,
					  lockdep_is_held(&reuseport_lock));
	if (sk_unhashed(sk) && reuse->num_closed_socks) {
		spin_unlock_bh(&reuseport_lock);
		return -ENOENT;
	}

Although checking with reuseport_sock_index() will also work,
the above probably is simpler and faster?

> 
> 
> Another option is to add the check in sock_setsockopt():
> SO_ATTACH_REUSEPORT_[CE]BPF, SO_DETACH_REUSEPORT_BPF.
> 
> Which do you think is better ?
I think it is better to have this sock_reuseport specific bits
staying in sock_reuseport.c.

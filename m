Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B33238BDA2
	for <lists+netdev@lfdr.de>; Fri, 21 May 2021 06:48:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239206AbhEUEtT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 May 2021 00:49:19 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:52698 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S232956AbhEUEtS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 May 2021 00:49:18 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.43/8.16.0.43) with SMTP id 14L4idcn010720;
        Thu, 20 May 2021 21:47:33 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=oZTLwdTSqBiHK3kOXkK2n/XaJijMcps9iTsYl6uO0F0=;
 b=Axn6T7wYAz82Wud5IQTQYLthDoaYoQPNorYW3Xxpv9QV4uha0btsSUBi/lkBR8OdgDip
 YIlGS7d1ODYZRvwlfE3wFRO7fyrUNNDzdIjFX+7vPjozCC8E4qR84rOk459Ed/E5tg63
 w+jBZth5VllabQLu9h7JxLfIvrWxrqSsD5g= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0089730.ppops.net with ESMTP id 38p3a5gt4b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 20 May 2021 21:47:32 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.198) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 20 May 2021 21:47:31 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KD8+rwi7Aj2u8LTYD3MoIrjLYFDwpby8QTu7d+5zwZWDyij5bBB2JmEJN++pfwHDw5fz/5NYELWhVv8TkKtK8GeHtc9CGcWUrSFjqO4W9SDsE8qMrfpFe49JMryq2UFN9nuQW3WaRu2iDEXmM3zrS18qbK+hBQCSDDDe3MnWIU4HhYqVRGOIEAYWL35qRLlQb6byT4/pgAEnB5It7IE2VD5jt3alB+sCnnoNp5+SEgBCNzm9mvGzZutqm9kMwIecgllC8WScxwmZY0EigQ78LiNkqjJC3a0URG+BW8/jhacdMVe8yLhRFtE0VeRdzTQ2cJHuDnY7DW4cUIdjYYgZyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oZTLwdTSqBiHK3kOXkK2n/XaJijMcps9iTsYl6uO0F0=;
 b=Ue/GkwCT+xap16mf8D0yWz1XDyzsuOZ+EO9CUi0Yxyi3wAEKU9QNG269P9csmMk7zfBffuUJJqlN2OfsG5srFGlBBYfdfy4AIAxxg7Ktni8xcI5fQffpH65/bpkCpmlJxTdu+jrDjpufwTQ6P6X7KM+NRV+eD3zSusQ0xzpu+0tc/Jl0TYiP3RO3+SZJMeU6+2y6Debv7E+xbQPEKtNLtdR0QpK7T+5E8AEgIUZMgvpaHYxiiw8opm0Oixvf/AvM11y4/XSy3K8dGpUgKglhREGqbQeC32x2fCeCZtSMIkvpdhOszhRZkVy2JhXxZ1esnHGrdPQ6d+Kk2Bgm+u1Oow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: amazon.co.jp; dkim=none (message not signed)
 header.d=none;amazon.co.jp; dmarc=none action=none header.from=fb.com;
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by BY5PR15MB3714.namprd15.prod.outlook.com (2603:10b6:a03:1f7::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.25; Fri, 21 May
 2021 04:47:29 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::718a:4142:4c92:732f]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::718a:4142:4c92:732f%6]) with mapi id 15.20.4150.023; Fri, 21 May 2021
 04:47:29 +0000
Date:   Thu, 20 May 2021 21:47:25 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Kuniyuki Iwashima <kuniyu@amazon.co.jp>
CC:     <andrii@kernel.org>, <ast@kernel.org>, <benh@amazon.com>,
        <bpf@vger.kernel.org>, <daniel@iogearbox.net>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <kuni1840@gmail.com>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>
Subject: Re: [PATCH v6 bpf-next 03/11] tcp: Keep TCP_CLOSE sockets in the
 reuseport group.
Message-ID: <20210521044725.acvvp3qoj5tk4xts@kafai-mbp.dhcp.thefacebook.com>
References: <20210520233906.c7yphwjrstqmhfk6@kafai-mbp.dhcp.thefacebook.com>
 <20210521002639.20533-1-kuniyu@amazon.co.jp>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210521002639.20533-1-kuniyu@amazon.co.jp>
X-Originating-IP: [2620:10d:c090:400::5:e31a]
X-ClientProxiedBy: MW4PR03CA0354.namprd03.prod.outlook.com
 (2603:10b6:303:dc::29) To BY5PR15MB3571.namprd15.prod.outlook.com
 (2603:10b6:a03:1f6::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:e31a) by MW4PR03CA0354.namprd03.prod.outlook.com (2603:10b6:303:dc::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.23 via Frontend Transport; Fri, 21 May 2021 04:47:27 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cf2a4aee-b92e-41d6-187a-08d91c13899d
X-MS-TrafficTypeDiagnostic: BY5PR15MB3714:
X-Microsoft-Antispam-PRVS: <BY5PR15MB3714C8654B83CB1AF5317D26D5299@BY5PR15MB3714.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WKEW1m0RSA16VrTqs/tXk0zMwMbWcp7T2JCU5ufbd0mOmYG9OaAfzmfPqHoUnzgt4sM9z16ZXSttXHYVqmlyE7BBk5Kdhvy+QJdliPcEl2BVBTVZuwLt3kSIqGOrYBnK4myaMy1ghTp9FilTDX1tBVDy8/TFv9Lh7C7DbejDz3IpAhA2wZbJYYgaNvi84felGmsWDve8PxZwFcOuuX02EevpQfBujMYNIpZhP3EDQNVdTy7S5D6DCuv+aBpHpSBI8UM8bfMKv2APbP48FP3J+fCcpYw9lYk7q8kZH7uFYoPPq8Itm15cy6ydeQzfAzhjF43Esp35p77jGfgWCW0JIh2DqEkox1IX3YDoEvcIQnIfMVuda0JxSETw7p4vKyRPOmi0uRSgRhPi+qqgnsJcVOWrKT1+2cmXDvoTfe1GAwckJRKnZRziy8XJJVdoNkAVzbJv7gNlA88kWLEXB2oC6H9eki94EzdvCgpkpuQmNIVJXx5t//W912o1PyvOyjI+SVJA8zN/AnBSTFrBfjRXBl+DbyElnmH5gpJTdcAETa4BqorvahcGue4c+6eAXDOjbGDicd9GsMD16B+ucD4Sz2gkCRnnPR/RTmGv7sEpJn0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(39860400002)(136003)(396003)(366004)(346002)(86362001)(66946007)(55016002)(316002)(66476007)(66556008)(8676002)(83380400001)(9686003)(6916009)(1076003)(6506007)(7416002)(38100700002)(8936002)(2906002)(5660300002)(52116002)(7696005)(16526019)(186003)(4326008)(478600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?lw0i31avZL6p0vazG3Q1MHCZPxFyghQW9OxMUAW2Ozm8CYdGbNF2b7d4GwrR?=
 =?us-ascii?Q?/IMwkw2guMFT3/C1Ns1fr+EdBSNBBOT2IG5DKJUw072vTbIe7+h3cCBQThcT?=
 =?us-ascii?Q?sRIUSK9PdfsHB4m1NDl1bTCMvSUgzQvzK/klpHdXl+P545++YQeUt01HCfkS?=
 =?us-ascii?Q?ox1dTd6RcF80lwTIbd4PbjqKVYBETrbbTcVtcxzNy8Q/61BTNhbpBMhD8BxH?=
 =?us-ascii?Q?fm+f127L3cElmDhzduiexHt8x+Xarok75wXG1oVq4diNcGDqSifCSBU0wVK0?=
 =?us-ascii?Q?BMt99ss0xe59omvFbrPJNfrggVmu/vvQvvUwkj7ZbKb0IYclZmsRGEMbmTEk?=
 =?us-ascii?Q?r285xyvt12yi/jPNE3ZmdeZvDxHIcAi4UWZBri3EzlBuIOg4uunCZYe9H0HE?=
 =?us-ascii?Q?OENQPtSA//mV+nN273qZgFpgqPpmtSbw6+h+YSe8s4Nsfao2C42vRogCkHoy?=
 =?us-ascii?Q?8J9stYJLMuUClTic8OBF9uqwKkLBLIv5AxBlHyKFUUJD+CcT5H9JUsxQHO1y?=
 =?us-ascii?Q?ojbeTcd+uvG42NOtersFMUuBFWh1ZJcYoZyMnlcWnnS3MZAT7MCw9Tr2gd+x?=
 =?us-ascii?Q?9GZ66AtEhDbwN/jfbno6VZh10Uah2WIshgt/KmxUrfW+8hX5NpMzhp+VvVpk?=
 =?us-ascii?Q?FDUBkVbH2gKInnihm9VmxseaPfPdYZs92wmRSlNA1vODq3qGC4fDQ1fzTByd?=
 =?us-ascii?Q?Vo5yxFbCYxcKhCKRROx68UmXce4q3qii7w0DV4TU8RXIIh7HsvfKqxp/ZYk7?=
 =?us-ascii?Q?AGQrfJH5pJtpqmYV9ooz/4qHNjju2De8g8ECPtyVAnKOc3ZgH6xpCgX+21UD?=
 =?us-ascii?Q?gK5hej37rctl0MxF/CgZBB/ESjXCURMPJdyOrkT1syEvp42oqDg5/obFvS5V?=
 =?us-ascii?Q?Ldh2+OTEYgOjvZTBDvY67HQCnTEr8/ofcH+H59tvxgZ5TlfUGjL3z8iRDG5P?=
 =?us-ascii?Q?qrYGJfQF+1nZxrSKIhPOunPL62VbnHnTnEcU1WkBFvGKNYtsdx56lA9e+vQa?=
 =?us-ascii?Q?knU7hwDLYCQaq01iSN3XVI0jPmXmIU2pNZwPb70ecnKxXMqUHhq8Tw0TA2Rs?=
 =?us-ascii?Q?kSp7JKV5ZTQvfsgjsMsQwA8j/GOAh0n3wHngtSLVEQ7V4m0iykWp6YgrAjI2?=
 =?us-ascii?Q?7rP0GM2AeBYv3LtjaHrI42Vlp71w19LcA/3I4iUa3EyZ72qjtAw/DoM66Ny1?=
 =?us-ascii?Q?aqgHuuDdAThByPQqlLo8vOfKTWUd4x6nt3vqxvojuurycd74lXDUaJBOKwyR?=
 =?us-ascii?Q?Nw8Syjtw+GxqQLWVCGRTxZWK7DP87h6oLsN8CBZ0tiX/XYb0CY4BFECEJqnT?=
 =?us-ascii?Q?XlnoLNR7uEB2Sb/BqZuNfG3y9ms+oX+guKDqqOJuJuiZOQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: cf2a4aee-b92e-41d6-187a-08d91c13899d
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB3571.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 May 2021 04:47:29.1794
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bFOhTuyp14rqA0cWJf4AD8QunXnhJ9b/RltKHHZpXFKqygi1DFEAg0ntasFxfKMm
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR15MB3714
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: sNxH1-zCURWUwkznGd4u-8miNPQtYHH4
X-Proofpoint-GUID: sNxH1-zCURWUwkznGd4u-8miNPQtYHH4
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-21_02:2021-05-20,2021-05-21 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015
 priorityscore=1501 suspectscore=0 adultscore=0 impostorscore=0
 phishscore=0 mlxlogscore=999 bulkscore=0 mlxscore=0 spamscore=0
 malwarescore=0 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2104190000 definitions=main-2105210029
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 21, 2021 at 09:26:39AM +0900, Kuniyuki Iwashima wrote:
> From:   Martin KaFai Lau <kafai@fb.com>
> Date:   Thu, 20 May 2021 16:39:06 -0700
> > On Fri, May 21, 2021 at 07:54:48AM +0900, Kuniyuki Iwashima wrote:
> > > From:   Martin KaFai Lau <kafai@fb.com>
> > > Date:   Thu, 20 May 2021 14:22:01 -0700
> > > > On Thu, May 20, 2021 at 05:51:17PM +0900, Kuniyuki Iwashima wrote:
> > > > > From:   Martin KaFai Lau <kafai@fb.com>
> > > > > Date:   Wed, 19 May 2021 23:26:48 -0700
> > > > > > On Mon, May 17, 2021 at 09:22:50AM +0900, Kuniyuki Iwashima wrote:
> > > > > > 
> > > > > > > +static int reuseport_resurrect(struct sock *sk, struct sock_reuseport *old_reuse,
> > > > > > > +			       struct sock_reuseport *reuse, bool bind_inany)
> > > > > > > +{
> > > > > > > +	if (old_reuse == reuse) {
> > > > > > > +		/* If sk was in the same reuseport group, just pop sk out of
> > > > > > > +		 * the closed section and push sk into the listening section.
> > > > > > > +		 */
> > > > > > > +		__reuseport_detach_closed_sock(sk, old_reuse);
> > > > > > > +		__reuseport_add_sock(sk, old_reuse);
> > > > > > > +		return 0;
> > > > > > > +	}
> > > > > > > +
> > > > > > > +	if (!reuse) {
> > > > > > > +		/* In bind()/listen() path, we cannot carry over the eBPF prog
> > > > > > > +		 * for the shutdown()ed socket. In setsockopt() path, we should
> > > > > > > +		 * not change the eBPF prog of listening sockets by attaching a
> > > > > > > +		 * prog to the shutdown()ed socket. Thus, we will allocate a new
> > > > > > > +		 * reuseport group and detach sk from the old group.
> > > > > > > +		 */
> > > > > > For the reuseport_attach_prog() path, I think it needs to consider
> > > > > > the reuse->num_closed_socks != 0 case also and that should belong
> > > > > > to the resurrect case.  For example, when
> > > > > > sk_unhashed(sk) but sk->sk_reuseport == 0.
> > > > > 
> > > > > In the path, reuseport_resurrect() is called from reuseport_alloc() only
> > > > > if reuse->num_closed_socks != 0.
> > > > > 
> > > > > 
> > > > > > @@ -92,6 +117,14 @@ int reuseport_alloc(struct sock *sk, bool bind_inany)
> > > > > >  	reuse = rcu_dereference_protected(sk->sk_reuseport_cb,
> > > > > >  					  lockdep_is_held(&reuseport_lock));
> > > > > >  	if (reuse) {
> > > > > > +		if (reuse->num_closed_socks) {
> > > > > 
> > > > > But, should this be
> > > > > 
> > > > > 	if (sk->sk_state == TCP_CLOSE && reuse->num_closed_socks)
> > > > > 
> > > > > because we need not allocate a new group when we attach a bpf prog to
> > > > > listeners?
> > > > The reuseport_alloc() is fine as is.  No need to change.
> > > 
> > > I missed sk_unhashed(sk) prevents calling reuseport_alloc()
> > > if sk_state == TCP_LISTEN. I'll keep it as is.
> > > 
> > > 
> > > > 
> > > > I should have copied reuseport_attach_prog() in the last reply and
> > > > commented there instead.
> > > > 
> > > > I meant reuseport_attach_prog() needs a change.  In reuseport_attach_prog(),
> > > > iiuc, currently passing the "else if (!rcu_access_pointer(sk->sk_reuseport_cb))"
> > > > check implies the sk was (and still is) hashed with sk_reuseport enabled
> > > > because the current behavior would have set sk_reuseport_cb to NULL during
> > > > unhash but it is no longer true now.  For example, this will break:
> > > > 
> > > > 1. shutdown(lsk); /* lsk was bound with sk_reuseport enabled */
> > > > 2. setsockopt(lsk, ..., SO_REUSEPORT, &zero, ...); /* disable sk_reuseport */
> > > > 3. setsockopt(lsk, ..., SO_ATTACH_REUSEPORT_EBPF, &prog_fd, ...);
> > > >    ^---- /* This will work now because sk_reuseport_cb is not NULL.
> > > >           * However, it shouldn't be allowed.
> > > > 	  */
> > > 
> > > Thank you for explanation, I understood the case.
> > > 
> > > Exactly, I've confirmed that the case succeeded in the setsockopt() and I
> > > could change the active listeners' prog via a shutdowned socket.
> > > 
> > > 
> > > > 
> > > > I am thinking something like this (uncompiled code):
> > > > 
> > > > int reuseport_attach_prog(struct sock *sk, struct bpf_prog *prog)
> > > > {
> > > > 	struct sock_reuseport *reuse;
> > > > 	struct bpf_prog *old_prog;
> > > > 
> > > > 	if (sk_unhashed(sk)) {
> > > > 		int err;
> > > > 
> > > > 		if (!sk->sk_reuseport)
> > > > 			return -EINVAL;
> > > > 
> > > > 		err = reuseport_alloc(sk, false);
> > > > 		if (err)
> > > > 			return err;
> > > > 	} else if (!rcu_access_pointer(sk->sk_reuseport_cb)) {
> > > > 		/* The socket wasn't bound with SO_REUSEPORT */
> > > > 		return -EINVAL;
> > > > 	}
> > > > 
> > > > 	/* ... */
> > > > }
> > > > 
> > > > WDYT?
> > > 
> > > I tested this change worked fine. I think this change should be added in
> > > reuseport_detach_prog() also.
> > > 
> > > ---8<---
> > > int reuseport_detach_prog(struct sock *sk)
> > > {
> > >         struct sock_reuseport *reuse;
> > >         struct bpf_prog *old_prog;
> > > 
> > >         if (!rcu_access_pointer(sk->sk_reuseport_cb))
> > > 		return sk->sk_reuseport ? -ENOENT : -EINVAL;
> > > ---8<---
> > Right, a quick thought is something like this for detach:
> > 
> > 	spin_lock_bh(&reuseport_lock);
> > 	reuse = rcu_dereference_protected(sk->sk_reuseport_cb,
> > 					  lockdep_is_held(&reuseport_lock));
> 
> Is this necessary because reuseport_grow() can detach sk?
> 
>         if (!reuse) {
>                 spin_unlock_bh(&reuseport_lock);
>                 return -ENOENT;
>         }
Yes, it is needed.  Please add a comment for the reuseport_grow() case also.

> 
> Then we can remove rcu_access_pointer() check and move sk_reuseport check
> here.
Make sense.

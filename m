Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7121A38B8E9
	for <lists+netdev@lfdr.de>; Thu, 20 May 2021 23:22:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230122AbhETVXw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 May 2021 17:23:52 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:32054 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229655AbhETVXv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 May 2021 17:23:51 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14KLF4k8032380;
        Thu, 20 May 2021 14:22:10 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=Ww6VXUfs134oEvEPt1FmzgUpC4EIjqwaSV4UPfuRJY4=;
 b=Wx+4EJJEL9yujmki3r/+N0BlRp3aWlRsNJf449WqckO6Xee5NxAiW7lsGk9XEBHcu5QY
 Y8Q98w3UxrBbiI5tQgms2agaXVkEJ8utKSV5Z7PRN7BfgU6PKwy+lIW4TsV3TYCILuou
 zK/k5v1G6deQasmWm38/3BRgcLc2WWv8RVM= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 38n48j1spw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 20 May 2021 14:22:10 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 20 May 2021 14:22:08 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JyhIZ7abmXMkpbuw2SBJhgfU4J5K39Sdk8HLjrzTH1bn6+9OB9IE3SbahbQBv/t6rshoraz9JN9JBTFiQ4DI08MRkigbAzczuXY3hxfMBrZbVR/6FLrrDiiWUE/2eZ06Lvq5ns1jdagjhf7stpfl37ZSFEIY2WZ9vvPzUuD5I0I7rY9/WnUR8OLe7tuSUH+lHjgIc1WW1OznWNur4TNzTyV88fz83R0T+wMzPB3vB2TTYqrDhKnC4RxsCQ98Nridt64v/ieQENjYE9dmHZu1cJZyyuULHKLKabB8/sDcImU3P7FZe6o4wSSzzfg4YUJGZq4H8ZgvNwuk/45e6Vu0ow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ww6VXUfs134oEvEPt1FmzgUpC4EIjqwaSV4UPfuRJY4=;
 b=cCDxWCFAEW+DhP5OrRy2cZfNJKGqNwOx6qBAOamFxOnxZfTdGScIioeThhOrMQcvC+rNgVVgLTCw930EOM1OVyF3yphIPxpfxzMoM741MsReH1jMN6A8xEH5nPlB+590e4QypMPU/CCXDrdzhfdcsA1OUWqpUjxxl7az5veIZtPKTqcb69hEFbLLeePUMg3ZoCJYQrgBaznNQlikdIa3IkfHRhr/x91dYuuvDpVkZO50o0rQCuGZyCQw69rPdgxkVQJvlSfG4o5B/M4jjHm+/FKCPkB47Rz7MFFt6+cKgaVv1YPidvZO+rIuJE0sMliBs7qMvQtqo5U3L5wnCSunUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: amazon.co.jp; dkim=none (message not signed)
 header.d=none;amazon.co.jp; dmarc=none action=none header.from=fb.com;
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by SJ0PR15MB4488.namprd15.prod.outlook.com (2603:10b6:a03:375::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.26; Thu, 20 May
 2021 21:22:07 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::718a:4142:4c92:732f]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::718a:4142:4c92:732f%6]) with mapi id 15.20.4150.023; Thu, 20 May 2021
 21:22:07 +0000
Date:   Thu, 20 May 2021 14:22:01 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Kuniyuki Iwashima <kuniyu@amazon.co.jp>
CC:     <andrii@kernel.org>, <ast@kernel.org>, <benh@amazon.com>,
        <bpf@vger.kernel.org>, <daniel@iogearbox.net>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <kuni1840@gmail.com>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>
Subject: Re: [PATCH v6 bpf-next 03/11] tcp: Keep TCP_CLOSE sockets in the
 reuseport group.
Message-ID: <20210520212201.zq3ozwx3vrobd2ua@kafai-mbp.dhcp.thefacebook.com>
References: <20210520062648.ejqufb6m5wr6z7k2@kafai-mbp.dhcp.thefacebook.com>
 <20210520085117.48629-1-kuniyu@amazon.co.jp>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210520085117.48629-1-kuniyu@amazon.co.jp>
X-Originating-IP: [2620:10d:c090:400::5:59da]
X-ClientProxiedBy: MW4PR04CA0101.namprd04.prod.outlook.com
 (2603:10b6:303:83::16) To BY5PR15MB3571.namprd15.prod.outlook.com
 (2603:10b6:a03:1f6::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:59da) by MW4PR04CA0101.namprd04.prod.outlook.com (2603:10b6:303:83::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.23 via Frontend Transport; Thu, 20 May 2021 21:22:06 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c8ef5a25-8a6e-4b9d-29d0-08d91bd5521b
X-MS-TrafficTypeDiagnostic: SJ0PR15MB4488:
X-Microsoft-Antispam-PRVS: <SJ0PR15MB4488D675840CC44B9C488A33D52A9@SJ0PR15MB4488.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Qe3E/moT60xu+bm9gqaCiQsZrsfDQOGfxT2U2d7cQtVzQch99Lt68t6SDNrLkdkqg80SCBWLi4PPwywWp/Vgc48t/ssjw4sOddYD/q0ckncE2WJcA6LWdwWJ9wSRG9+ZHaQkYRtn2K/uqlp1+zo99LPnCzK0y+Ekof5aVDmqw5Pylt8e0XL2CuSdk5BZRZ/G4FTm+diosyU2m83M9F1EfzDwRqeEEAOdZwyi5PoxM2RIsSjvQSsFDL3+L4jKEElQuoYIgSJoaJe7yXEtUt09FONspFpeQw6cEvfe/anrfx5r2TusLBJS6RaEXLPu4bqEwQrOh4E6Q0/Ob6aip8DnEV6XSF8Mxqdu6ZGuFu8lKTUty2SpQsTx4tKO6xh03CUOgl5f0xGSexl7eG1mqbGsIPVdWrIIxeMGEIHo74Ukfkf+lk94mfSNTPeDYK0c+NXiu4SqFX78Pv/tC9lupUz+xPm/3wwSGrT6o9KdO+8ypXezMCJanZDUJ8JnrAH8HEAZoM7SKi3EhD1ykKEN0W5X0Tnc9eRqo02iyLd0U97EIk+6ZSpoHndMvRGMasYshuKVgjkNJFvmDvTRgEEkecrIk+3u2FLPFqYZ5BTR0OaSYMg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(136003)(366004)(346002)(376002)(39860400002)(478600001)(6666004)(316002)(38100700002)(1076003)(55016002)(7416002)(9686003)(86362001)(2906002)(7696005)(52116002)(4326008)(83380400001)(66556008)(8936002)(6506007)(16526019)(186003)(5660300002)(6916009)(66476007)(8676002)(66946007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?Du5DXZ3HjO2j5CTy6FayB3azLqXQ7MdL0ZjvyDs2zomJVCphfRpyZ7NXENet?=
 =?us-ascii?Q?1TrYa7kmrv9m2PBavok6518V1Ixstqf/jVbOu9RBRqJRTaSH0hWtvV5/pJu5?=
 =?us-ascii?Q?90TcyAzWTF7L9iYusytBQioEz/QSNggk17pLhRq3V04lKOSgAuE7PqC490ru?=
 =?us-ascii?Q?4nzftmpCskQ29s+rB7sPtPdNBFdYaRwDbjxHr48Bk71ljX8iDncvduI66fMG?=
 =?us-ascii?Q?BfIoLgWFnUoM3Jk3SeRy2j7SFdQRW5ZOhor7pVFa+oSdx5NXryTIVAWsE0yC?=
 =?us-ascii?Q?YcJCzu3p2/eSScS7rHyEuXd/lfUQQK4XEWXc5Vreyu/fYv9gtJ++/XmThEZW?=
 =?us-ascii?Q?cFuyipTK6ozoiTPhsTetIcN9C287leWU+afEVnWa4kYhz4HI3ZC4ttwMjohQ?=
 =?us-ascii?Q?lj1aEXnAcXKD6I/dYEwstf4mhhZOvqLvjphkswCrHkNdjaSJmSTjOzVR0XwD?=
 =?us-ascii?Q?jONYNO64GoD7RyIPdiD2Bh5Kn9Sj/AkF8qbLYEw3zcB/M+/I2BATR4OKDOIt?=
 =?us-ascii?Q?aAkrpZF5+/MR9JJGb4iTDGQffk/LD8jTh8RDbInKV7Yfjs2ChFDVZhmE1UXY?=
 =?us-ascii?Q?qGGQ/nAiQ8hS4SzS6vslLqCdU/K/rCiyn8D3n7VvzW0HOMSxPWncV3PSG8BX?=
 =?us-ascii?Q?8DuZTVGis8tkBxIqIAnFBF9bRVwzDN9L8cf5N714PnU/2jeTwdNNr60b+7p/?=
 =?us-ascii?Q?GDzIa9O2W/r/2A2/3fcE5JnxwACebqBWyNSe+ULCQE+quevzXqaGlusP9pl6?=
 =?us-ascii?Q?EjUMK+9+mU0T2cokgt38kS25BvBPsbjT/3ZOM0PwpA21JSESPW8yfyfhI7Wm?=
 =?us-ascii?Q?oliDS9vJMhbQi6kmNvzLSnObx0tagGkycwcR5j9TCFS+VocQVAf/q0K7VSef?=
 =?us-ascii?Q?YaMQsc1yyaRb/dSHbJYcoaFzbo6AkSlA78Jddr96iRQS5aas5WEITuip3M9+?=
 =?us-ascii?Q?hssH9tGT0xUvq0UsFqmiBGds9yUbFPazboXRmDSDAfTP8jFAFT+/b8UleEEx?=
 =?us-ascii?Q?S6nOlcC8ZORgHCj87UK479q2c89s2Kr2wWF3039qZiocpxk3v/fRRYN4nP1G?=
 =?us-ascii?Q?JAXrvvhsvP/mqh4SSdlEb3NRbobzGGLZ710vZxDxWC6JF7AO126FwU53/YjK?=
 =?us-ascii?Q?YRyjtYdnFJI7+gO2wDAHXlBPdAzomhTRdpYW5W0JvYLevyZw4nGx+qByv/Eu?=
 =?us-ascii?Q?NxBccr+geTDOq/Ttq4Cx/huT1ua0lmpnBuHIN4jLnwd5/wt2c0uG/J2QAiLX?=
 =?us-ascii?Q?Vk5JSuXJDy1ZFZ5YY0DWikKrcxO0KCG1bFoRSTlSZiEKn7MxZH5mK1hq+mOG?=
 =?us-ascii?Q?TnaJaMPcnvS2a6dbKUtR0YtjW4gpYCWXmcFRB4vBOSioDg=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c8ef5a25-8a6e-4b9d-29d0-08d91bd5521b
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB3571.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 May 2021 21:22:07.4048
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FXqtElbuJa4bhXP7yHn89sYCUlofDxh+Bn5+7+QwdQMYSEVBWQx2M7zF8o45RJam
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR15MB4488
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: jn2lk0KCabJekkL1QsWK75jFKeux_J2p
X-Proofpoint-GUID: jn2lk0KCabJekkL1QsWK75jFKeux_J2p
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-20_06:2021-05-20,2021-05-20 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015
 malwarescore=0 phishscore=0 adultscore=0 suspectscore=0 mlxscore=0
 bulkscore=0 spamscore=0 lowpriorityscore=0 impostorscore=0 mlxlogscore=999
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105200135
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 20, 2021 at 05:51:17PM +0900, Kuniyuki Iwashima wrote:
> From:   Martin KaFai Lau <kafai@fb.com>
> Date:   Wed, 19 May 2021 23:26:48 -0700
> > On Mon, May 17, 2021 at 09:22:50AM +0900, Kuniyuki Iwashima wrote:
> > 
> > > +static int reuseport_resurrect(struct sock *sk, struct sock_reuseport *old_reuse,
> > > +			       struct sock_reuseport *reuse, bool bind_inany)
> > > +{
> > > +	if (old_reuse == reuse) {
> > > +		/* If sk was in the same reuseport group, just pop sk out of
> > > +		 * the closed section and push sk into the listening section.
> > > +		 */
> > > +		__reuseport_detach_closed_sock(sk, old_reuse);
> > > +		__reuseport_add_sock(sk, old_reuse);
> > > +		return 0;
> > > +	}
> > > +
> > > +	if (!reuse) {
> > > +		/* In bind()/listen() path, we cannot carry over the eBPF prog
> > > +		 * for the shutdown()ed socket. In setsockopt() path, we should
> > > +		 * not change the eBPF prog of listening sockets by attaching a
> > > +		 * prog to the shutdown()ed socket. Thus, we will allocate a new
> > > +		 * reuseport group and detach sk from the old group.
> > > +		 */
> > For the reuseport_attach_prog() path, I think it needs to consider
> > the reuse->num_closed_socks != 0 case also and that should belong
> > to the resurrect case.  For example, when
> > sk_unhashed(sk) but sk->sk_reuseport == 0.
> 
> In the path, reuseport_resurrect() is called from reuseport_alloc() only
> if reuse->num_closed_socks != 0.
> 
> 
> > @@ -92,6 +117,14 @@ int reuseport_alloc(struct sock *sk, bool bind_inany)
> >  	reuse = rcu_dereference_protected(sk->sk_reuseport_cb,
> >  					  lockdep_is_held(&reuseport_lock));
> >  	if (reuse) {
> > +		if (reuse->num_closed_socks) {
> 
> But, should this be
> 
> 	if (sk->sk_state == TCP_CLOSE && reuse->num_closed_socks)
> 
> because we need not allocate a new group when we attach a bpf prog to
> listeners?
The reuseport_alloc() is fine as is.  No need to change.

I should have copied reuseport_attach_prog() in the last reply and
commented there instead.

I meant reuseport_attach_prog() needs a change.  In reuseport_attach_prog(),
iiuc, currently passing the "else if (!rcu_access_pointer(sk->sk_reuseport_cb))"
check implies the sk was (and still is) hashed with sk_reuseport enabled
because the current behavior would have set sk_reuseport_cb to NULL during
unhash but it is no longer true now.  For example, this will break:

1. shutdown(lsk); /* lsk was bound with sk_reuseport enabled */
2. setsockopt(lsk, ..., SO_REUSEPORT, &zero, ...); /* disable sk_reuseport */
3. setsockopt(lsk, ..., SO_ATTACH_REUSEPORT_EBPF, &prog_fd, ...);
   ^---- /* This will work now because sk_reuseport_cb is not NULL.
          * However, it shouldn't be allowed.
	  */

I am thinking something like this (uncompiled code):

int reuseport_attach_prog(struct sock *sk, struct bpf_prog *prog)
{
	struct sock_reuseport *reuse;
	struct bpf_prog *old_prog;

	if (sk_unhashed(sk)) {
		int err;

		if (!sk->sk_reuseport)
			return -EINVAL;

		err = reuseport_alloc(sk, false);
		if (err)
			return err;
	} else if (!rcu_access_pointer(sk->sk_reuseport_cb)) {
		/* The socket wasn't bound with SO_REUSEPORT */
		return -EINVAL;
	}

	/* ... */
}

WDYT?

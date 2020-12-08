Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B79A2D257A
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 09:14:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727982AbgLHIOm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 03:14:42 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:64972 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725927AbgLHIOl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Dec 2020 03:14:41 -0500
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0B88AtnU017078;
        Tue, 8 Dec 2020 00:13:40 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=rFtFa4m7Z2spdZyiBJFMKt2KWA0HjSpg/OUXUxCn8Ew=;
 b=X/rz2hhEoRea2jHAHEHLekGOMU7DcguQuiPWGqKonNswMObI0o9ICmeq+fUQZKenjY5q
 V1frknMIiQjO+EsHr49xW2DaI7CDcj8MMMMLyPPXuV//7BiLlZno0AJggVOrWNIr7gLd
 NQBFVIMcucZ3r2OgTgNY8UHVm9ftspQAJMY= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 35a0k5hnaw-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 08 Dec 2020 00:13:40 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 8 Dec 2020 00:13:39 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Uo6/eUvoy+uGkEPEf8RmRHCiJ4gXUK66gYJUx/YzdwbXzqPyWkabNnUr3/XK9wV+Jqwkea2RdLlkBAeoJc5+51evGGsNi+5+Bxvp6cDkfXwFlFRfxF5xEtwqD267R8onfR9LcrpE4JzSSFM2t297cgN/tjmHYoEOxhgzWGeX7n+NmZUITxQI9AqRPy7P47K/HSA4t/t2OHNHH5GJy6UMRFEjsDOFJ+0DBW0jsOhCgSAcSz0z51REuFDRkuVfVjaWlvoQ4Rx0HDOLpMcUVzSAA7IWGraGN6vA6p9DyPykZvvuCfK63wpLoQn+XBmofxC1rycfKpj04tgxGjS07x/Bzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rFtFa4m7Z2spdZyiBJFMKt2KWA0HjSpg/OUXUxCn8Ew=;
 b=Pak7teAKiHA9HRsNws3QMDJRXhCNEnBmGBIFXotCMKm7ydxUU8z6lzBAOyu+u2Go6laN19tkTBb5fwbq7+/JzFOE/t1dpkgeLzXe39fWZeZlxQ5uZag+CjIins97AmwMqRc4Ht0OYtQrRbQ7baET9fLqbgV8zIWDZibKOVDAIKzhzmhDiomr+AjN+YVBHPZcvDvKFok0gO9hFE3OWSw7AtL/5I0zwVf5sBcaeLFXTIDO1FbB7YQk7VgTZNf5uFScJjUX/hgYCepf/4rhGEMZ9SbS/s9XyUdfOg2ptessnWAQklJ1WBXzOm+OPfUTvc6WZ3ND9Zb8ISE8/JuUX/lmNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rFtFa4m7Z2spdZyiBJFMKt2KWA0HjSpg/OUXUxCn8Ew=;
 b=Dxg17asrTGhFE6/CFx9OO3x1b+ghTgV72M9lRhJR+vNC1zBPqcC8YrBJa9tIwVqgHe3fsb7tZvv7lvWfoMKm9A3+gbo6nC6vPazNplkF8UdAct2cVmu4QmpCwSyv1uf7OOEzagIDIo3f8yT2p8CxNbaqH68q5yB4Sr23Tk9gSxc=
Authentication-Results: amazon.co.jp; dkim=none (message not signed)
 header.d=none;amazon.co.jp; dmarc=none action=none header.from=fb.com;
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by BYAPR15MB2774.namprd15.prod.outlook.com (2603:10b6:a03:15d::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.19; Tue, 8 Dec
 2020 08:13:38 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::2831:21bf:8060:a0b]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::2831:21bf:8060:a0b%7]) with mapi id 15.20.3632.023; Tue, 8 Dec 2020
 08:13:38 +0000
Date:   Tue, 8 Dec 2020 00:13:28 -0800
From:   Martin KaFai Lau <kafai@fb.com>
To:     Kuniyuki Iwashima <kuniyu@amazon.co.jp>
CC:     <ast@kernel.org>, <benh@amazon.com>, <bpf@vger.kernel.org>,
        <daniel@iogearbox.net>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <kuni1840@gmail.com>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
Subject: Re: [PATCH v1 bpf-next 03/11] tcp: Migrate
 TCP_ESTABLISHED/TCP_SYN_RECV sockets in accept queues.
Message-ID: <20201208081328.aspzklzmeznw3hob@kafai-mbp.dhcp.thefacebook.com>
References: <20201207201438.kdlfdspusadadfvi@kafai-mbp.dhcp.thefacebook.com>
 <20201208062714.96230-1-kuniyu@amazon.co.jp>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201208062714.96230-1-kuniyu@amazon.co.jp>
X-Originating-IP: [2620:10d:c090:400::5:565a]
X-ClientProxiedBy: MW3PR06CA0013.namprd06.prod.outlook.com
 (2603:10b6:303:2a::18) To BY5PR15MB3571.namprd15.prod.outlook.com
 (2603:10b6:a03:1f6::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:565a) by MW3PR06CA0013.namprd06.prod.outlook.com (2603:10b6:303:2a::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.17 via Frontend Transport; Tue, 8 Dec 2020 08:13:36 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b4e477b4-5a27-4258-5c6e-08d89b512abd
X-MS-TrafficTypeDiagnostic: BYAPR15MB2774:
X-Microsoft-Antispam-PRVS: <BYAPR15MB2774FB92AD3FC5ABA14A8FC7D5CD0@BYAPR15MB2774.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EFvfupsOnhDRvhKEB51W1ZmQwaK19SQafein99/6pMYZuKCoBOkwDZFmJLYhLd5S6xQsI316uc3opWCqFuUi4MJKQxknjUZLGzDRJex05VuM7yIocn1aIprxsjIvijXrav3XUMXjULRu0lYCprUlKKCd7tichyBi/QBeYbp5bby2rNnGAVg+PEtgwzTe/4Q2sHUUwC4Wx+L7MNIEps1FfWZYjkQzjhlg52GejdQRKIgOwOpbaEUpyzr4aw0+5Ud294UN5mLaS23oMpA1bVxN+c84iQgAdc86jQKETPILBwdqg/sfkhVSF2Xkn3d1IoIuwbHIGSY9vIh7QBs1UON3Yw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(136003)(366004)(376002)(39860400002)(346002)(52116002)(5660300002)(6506007)(9686003)(8676002)(1076003)(7696005)(7416002)(478600001)(4326008)(186003)(83380400001)(6666004)(316002)(2906002)(8936002)(16526019)(66946007)(6916009)(66476007)(66556008)(86362001)(55016002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?3XKxtby0OA4rB6m58aM/JtDzgLy2eQuhbhE6u4Rm9lA/kIYAipcaLm4PNqNY?=
 =?us-ascii?Q?1l6JObdgha0QQ24hfWj50weZ9PHp5hkiMAcF95LKIJoJ4Uy9+yrsB/hc1Ys+?=
 =?us-ascii?Q?uLTvR6VkcIffB0mLbwUu65X+sTQirU3ZRR/NiB0M76BfAFaier2haXbNb27p?=
 =?us-ascii?Q?hWcTmNEXqZ1xUwBFp0/euhNJkO9lryrkbGCgEbz+dEyNg/dzupJnSoiYMYbk?=
 =?us-ascii?Q?lTp7ln0gf99XxIc36VlyBndx4kl/kGhPrCSwAc6w7z8Vjgd+DLvOM/7JNH5X?=
 =?us-ascii?Q?7CuyicvZJFMDNoGUajuyl14zO3OoUUJwcgvXTvBgNzl3qMpPHnDYseJVH+Vv?=
 =?us-ascii?Q?fI8yWxXlp7lQHShqeRjkFx+h0rwv9cuu5giVX601XEgaa7LwjRTDlHdfAHqC?=
 =?us-ascii?Q?X4V2SCxU/qpvN8f4Bg/o44gR2PrMEdyP1Gm2RQ0XRXxRuVvg3Gd27BAbxVzF?=
 =?us-ascii?Q?SYXxBQuBgEI9omvvT2wlbKcrYJeflssCBAXGJ4psSdPn/1/Ac+w9tri+xnrd?=
 =?us-ascii?Q?+q8uTKT1+OOaHdmu4PlslI4ReZXriP3RVtO/TOYE6A0die/+o+zENV05kjWn?=
 =?us-ascii?Q?8lftRw0WJD70rq41UHj60yDxXDtuLpnha6Y52xDkOZLPZ6qddfPSNmq9I2RK?=
 =?us-ascii?Q?RRS1EimIt7OY9KnLBQEk907CcNfSHZSmGzRmqeNUP6VMEXWcH7PHRLAFy6fs?=
 =?us-ascii?Q?AzasfcFyMvPNRgAlbufrPn9FnOB4FldIb/Sq8ZmMEFfJHfXLX56DKofZUpYg?=
 =?us-ascii?Q?MKvNU7cp1cdhGUfSMsrufDT2me9vYywQYCNNRB5CnYb1GzwhJWZgdRG1Vai8?=
 =?us-ascii?Q?k3n/wOEP9dv8ZrC8fmjqEBU5OSiqiou8UtSqsvBFNzLI/yP+RONGf09krD6S?=
 =?us-ascii?Q?GlxK/kvMuLDj3MNw1OlfyZ1nEKs0qhRl/mXamyIqFCh8oRHwYjGC+UA52s21?=
 =?us-ascii?Q?EgHMpfmJCpsH83OSNE3cVSlm6IZM9rjGCqrxhNd5O4HLmrYzoI9CEW0beyYK?=
 =?us-ascii?Q?xdQfIYFc4KcBDjBc7/dbElncmA=3D=3D?=
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB3571.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2020 08:13:38.4314
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-Network-Message-Id: b4e477b4-5a27-4258-5c6e-08d89b512abd
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Z8MmVEuXEvwa1L3B3BaKxFlZ9JLtaxBQ1EWIlPGW6XY1Pm8u3d2Y8ckRu370EP+v
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2774
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-08_03:2020-12-04,2020-12-08 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015
 suspectscore=1 bulkscore=0 lowpriorityscore=0 mlxscore=0 phishscore=0
 spamscore=0 adultscore=0 impostorscore=0 malwarescore=0 priorityscore=1501
 mlxlogscore=806 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012080051
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 08, 2020 at 03:27:14PM +0900, Kuniyuki Iwashima wrote:
> From:   Martin KaFai Lau <kafai@fb.com>
> Date:   Mon, 7 Dec 2020 12:14:38 -0800
> > On Sun, Dec 06, 2020 at 01:03:07AM +0900, Kuniyuki Iwashima wrote:
> > > From:   Martin KaFai Lau <kafai@fb.com>
> > > Date:   Fri, 4 Dec 2020 17:42:41 -0800
> > > > On Tue, Dec 01, 2020 at 11:44:10PM +0900, Kuniyuki Iwashima wrote:
> > > > [ ... ]
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
> > > > Is it under rcu_read_lock() here?
> > > 
> > > reuseport_lock is locked in this function, and we do not modify the prog,
> > > but is rcu_dereference_protected() preferable?
> > > 
> > > ---8<---
> > > prog = rcu_dereference_protected(reuse->prog,
> > > 				 lockdep_is_held(&reuseport_lock));
> > > ---8<---
> > It is not only reuse->prog.  Other things also require rcu_read_lock(),
> > e.g. please take a look at __htab_map_lookup_elem().
> > 
> > The TCP_LISTEN sk (selected by bpf to be the target of the migration)
> > is also protected by rcu.
> 
> Thank you, I will use rcu_read_lock() and rcu_dereference() in v3 patchset.
> 
> 
> > I am surprised there is no WARNING in the test.
> > Do you have the needed DEBUG_LOCK* config enabled?
> 
> Yes, DEBUG_LOCK* was 'y', but rcu_dereference() without rcu_read_lock()
> does not show warnings...
I would at least expect the "WARN_ON_ONCE(!rcu_read_lock_held() ...)"
from __htab_map_lookup_elem() should fire in your test
example in the last patch.

It is better to check the config before sending v3.

[ ... ]

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
> > > > I am also not very thrilled on this double spin_lock.
> > > > Can this be done in (or like) inet_csk_listen_stop() instead?
> > > 
> > > It will be possible to migrate sockets in inet_csk_listen_stop(), but I
> > > think it is better to do it just after reuseport_detach_sock() becuase we
> > > can select a different listener (almost) every time at a lower cost by
> > > selecting the moved socket and pass it to inet_csk_reqsk_queue_migrate()
> > > easily.
> > I don't see the "lower cost" point.  Please elaborate.
> 
> In reuseport_select_sock(), we pass sk_hash of the request socket to
> reciprocal_scale() and generate a random index for socks[] to select
> a different listener every time.
> On the other hand, we do not have request sockets in unhash path and
> sk_hash of the listener is always 0, so we have to generate a random number
> in another way. In reuseport_detach_sock(), we can use the index of the
> moved socket, but we do not have it in inet_csk_listen_stop(), so we have
> to generate a random number in inet_csk_listen_stop().
> I think it is at lower cost to use the index of the moved socket.
Generate a random number is not a big deal for the migration code path.

Also, I really still failed to see a particular way that the kernel
pick will help in the migration case.  The kernel has no clue
on how to select the right process to migrate to without
a proper policy signal from the user.  They are all as bad as
a random pick.  I am not sure this migration feature is
even useful if there is no bpf prog attached to define the policy.
That said, if it is still desired to do a random pick by kernel when
there is no bpf prog, it probably makes sense to guard it in a sysctl as
suggested in another reply.  To keep it simple, I would also keep this
kernel-pick consistent instead of request socket is doing something
different from the unhash path.

> 
> 
> > > sk_hash of the listener is 0, so we would have to generate a random number
> > > in inet_csk_listen_stop().
> > If I read it correctly, it is also passing 0 as the sk_hash to
> > bpf_run_sk_reuseport() from reuseport_detach_sock().
> > 
> > Also, how is the sk_hash expected to be used?  I don't see
> > it in the test.
> 
> I expected it should not be used in unhash path.
> We do not have the request socket in unhash path and cannot pass a proper
> sk_hash to bpf_run_sk_reuseport(). So, if u8 migration is
> BPF_SK_REUSEPORT_MIGRATE_QUEUE, we cannot use sk_hash.

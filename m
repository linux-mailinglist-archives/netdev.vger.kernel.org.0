Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EEC02D5083
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 02:54:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727069AbgLJByf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 20:54:35 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:18226 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727020AbgLJBye (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Dec 2020 20:54:34 -0500
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0BA1n4iP023149;
        Wed, 9 Dec 2020 17:53:31 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=qvcVQlk+vpjOlk80iXppK74fAxXugUvOT/xCuGWt7iE=;
 b=SmJ/lU86ZGxQm+ze18nMx/6Q6cdhseJ1+BuI34u+20VIrH6sWIHCYNM3AL+9wHVWqTrO
 qe4Sp3aySyG+ZrEimMcf4ZUE36vyPnOCyjUkmnSEIN67Bl2b7tJI6EjW8lEwsSzknRpi
 AV4RzMLSYbtVC8fWcnaiUyr1SSHExuXHfNM= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 35ak7a92mn-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 09 Dec 2020 17:53:31 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 9 Dec 2020 17:53:28 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NQRWxqDMIi4VZzzBh0vtTu6l6ls9C1LjAABZ77nV9pLBGaUsJ3cXyjOj+92iGhG9HB6ZrJQRvE1Rhy6kZYYhBzZ9W/CdYMDsKSHN2zBX5T+PkbV9KWHxwCnWpeO6TuoDdMAz1PdESS3GtA/Rhr3R4bNATWkthTqjtsMy2TF1WE0DSM1wfJcgx0kjvV+kjr3Up/knQ5ti/qG1N8zJJapgw94O00oEeDu8ONU2YAGEicNo5bWyOHVpeU3UogClSn89Ny2PNnzQD3bf+E8d2kRJ3eygQMJZ5gWivak9FocPfMATuDdhcYgwx20cHBGvXls8QFoRTjgYXpPr4AVFEnq5kA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qvcVQlk+vpjOlk80iXppK74fAxXugUvOT/xCuGWt7iE=;
 b=bbbFVMaZvyH+9nAQw8CtNnG0KeuDmoSN3J9Cpz/plJ06wwXsiPmvxox/nb4F0Y8Trpatc73DptSL1pFp1wvjiUhk9cGEXSnzmzq3P+Go5PHhWXCyV1duI9KrrtH3A2PmdQ6Yx9/BjaXHImgo0n3V1hXZC39zb3FGzHjvGhTHYkRfg0m9K3F2eW8qrCqILz9y2uC9ad38i3LUO3KSxV2pDXDz3DgcI0v4fp2M+KaU5ERSg/kmpNBHO3zbzpp1ydi52+X1qc61+ByUMeNV2wGWaVKPYkpGwhgAUmGm0JI+h1cxAUFxbECcZAmaMedictBIlJzLlaFGmX2hX7QRPSUU9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qvcVQlk+vpjOlk80iXppK74fAxXugUvOT/xCuGWt7iE=;
 b=KgGgWR2jJzpb+39v3aJcSnvlOKT7EK8MyGNLpzsQsQEc3ied8TCCtiqOWfCMVhgjpy50IuRqnRKXXYT5uky6j4WrxBXplz3XKUXqTal8jy7j7ALz+D/tuJsUDYkam05j0dnXMTHyg6d/HmJ7iBLFA+XygQKlOyl/12Of2d9l+iA=
Authentication-Results: amazon.co.jp; dkim=none (message not signed)
 header.d=none;amazon.co.jp; dmarc=none action=none header.from=fb.com;
Received: from CH2PR15MB3573.namprd15.prod.outlook.com (2603:10b6:610:e::28)
 by CH2PR15MB3542.namprd15.prod.outlook.com (2603:10b6:610:7::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.21; Thu, 10 Dec
 2020 01:53:27 +0000
Received: from CH2PR15MB3573.namprd15.prod.outlook.com
 ([fe80::81f0:e22:522e:9dd]) by CH2PR15MB3573.namprd15.prod.outlook.com
 ([fe80::81f0:e22:522e:9dd%7]) with mapi id 15.20.3632.021; Thu, 10 Dec 2020
 01:53:27 +0000
Date:   Wed, 9 Dec 2020 17:53:19 -0800
From:   Martin KaFai Lau <kafai@fb.com>
To:     Kuniyuki Iwashima <kuniyu@amazon.co.jp>
CC:     <ast@kernel.org>, <benh@amazon.com>, <bpf@vger.kernel.org>,
        <daniel@iogearbox.net>, <davem@davemloft.net>,
        <edumazet@google.com>, <eric.dumazet@gmail.com>, <kuba@kernel.org>,
        <kuni1840@gmail.com>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>
Subject: Re: [PATCH v1 bpf-next 03/11] tcp: Migrate
 TCP_ESTABLISHED/TCP_SYN_RECV sockets in accept queues.
Message-ID: <20201210015319.e6njlcwuhfpre3bn@kafai-mbp.dhcp.thefacebook.com>
References: <20201209080509.66504-1-kuniyu@amazon.co.jp>
 <20201209165719.73652-1-kuniyu@amazon.co.jp>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201209165719.73652-1-kuniyu@amazon.co.jp>
X-Originating-IP: [2620:10d:c090:400::5:55be]
X-ClientProxiedBy: SJ0PR05CA0192.namprd05.prod.outlook.com
 (2603:10b6:a03:330::17) To CH2PR15MB3573.namprd15.prod.outlook.com
 (2603:10b6:610:e::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:55be) by SJ0PR05CA0192.namprd05.prod.outlook.com (2603:10b6:a03:330::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.7 via Frontend Transport; Thu, 10 Dec 2020 01:53:25 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 61472f4b-5be6-4db9-4284-08d89cae6343
X-MS-TrafficTypeDiagnostic: CH2PR15MB3542:
X-Microsoft-Antispam-PRVS: <CH2PR15MB35422E8C25AF10CCAC788458D5CB0@CH2PR15MB3542.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:2089;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Q4WuePVpW7wSnjO928xKLpq26Uh79wFNLx6cyG+0qtxBdbhRBuSvXr3sNLp7sXSIjUB76MZNtKyGkT8sWJcG3KdSI0hqfNd6kapeyXClk7wjF5V0adu4jWeFaYRHm5rE4XMuH9KilvtZ58GelF2A+ArDPnYgBkcaFB9gFJr/SgmYqlko0tFqus1slpdAhHWhuFvgGx0XFa9jelDtFJ+ktibqkK9AaraWJzzMzCwKmeRik6Y87Pfm4ybiYNBGpY7oYZTs8OCxLgvYc5TreywQzmiglinu+2iC/8uyRjyoAGBSDLVqqJnJs6gqGYK1tKeau7YsNJ9SVVI5FTA6X7zHEw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR15MB3573.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(136003)(346002)(366004)(66556008)(7696005)(52116002)(1076003)(66946007)(4326008)(30864003)(2906002)(6506007)(66476007)(8676002)(16526019)(186003)(83380400001)(508600001)(55016002)(6916009)(8936002)(6666004)(5660300002)(86362001)(7416002)(9686003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?PCmkD9CxXtEPRKWwVxIZdE04IMe1ojbqt34F2tilFMp/O1q32KQmdPebWwUj?=
 =?us-ascii?Q?Fe3Jhxbr0jxlb66JzHMrNXouBGz2OqBSH0u5l+vcEkNcBFoGnRrOAF+QXpd/?=
 =?us-ascii?Q?fT3VujTzUiNSrbgJtj595R70m2BmAmQ76VsPp7kkrDHDeFN1/51BOflLzUZ3?=
 =?us-ascii?Q?DvhnqhGjYc7mWxViV7jcptSF72Dze0ZK4ZNCIhKs/hsCdbEwBaeTXHqURWiQ?=
 =?us-ascii?Q?wFdROzO2o0h3GTZwjPYufJUSIiZ7vGpJlw0hR20jrgiOAd0UAjGyFHZF4CFo?=
 =?us-ascii?Q?BwkWLhsHtAzPaUBPeKamYcpAecvJBVNKxIykuPdl47HnuS2u2590KhJ50fy6?=
 =?us-ascii?Q?rR6vE+7iSv+X7gYWySKKVHKwYE0J/pc+8SR2F65ExREbzXaMygnHIAB08EdC?=
 =?us-ascii?Q?05wGp3oRWUD57gPBaHOJa2NMPtolMyn7raQoDiwsnNQRpTLpZBjC9nLO7v2J?=
 =?us-ascii?Q?2MvkR/qqcHLCyQdAij9tOgM/HgAhjjTIuBeivXz6m962w4oWKImxffgODzlT?=
 =?us-ascii?Q?yiXFeReXf9DKWPI8yxDw70TIxToxvmMPbXwWZcUcgSSYwFaesI/OX01F/YCT?=
 =?us-ascii?Q?PB8G2OXaaNP+i3rIRWI1LpfqVK/V18eFTxxsy6JjIMQ/aeMjp3gTJ65K7UgI?=
 =?us-ascii?Q?VXHVsnvmEU53AW9m1as/oaidSDfE6UMDtQdLECGQ1irh5mENbaiAQNRaPu2i?=
 =?us-ascii?Q?zOgB+eyL6pXNqeVQTO2+rxAkefY80aVfBKeBvUrcAJLNTxt0BrC0zEB18Zfs?=
 =?us-ascii?Q?HfD8zLFFEUGVDO1tE9VfLXwjVIjjw3yNGc5BE1lvL3f7FSV4sYgHSMDTAWjs?=
 =?us-ascii?Q?t8iXIX2nsUYpRsKMsK7ujdbCr4htkiiwF/+V5Yln+LzzrsDEZagwoSOtsEtx?=
 =?us-ascii?Q?7NOgYqDQAbun7/CZ4fJLqzu427poVBAR8EHxGmrfSW2sqXmBjAHSWQsCXXr3?=
 =?us-ascii?Q?cgY0AtwVsneHABz5HD7HYrWTO7ScIViRhjMVLExTNNau9bDFb+BPzBtCJfCH?=
 =?us-ascii?Q?8c9SCWDrV3PhT/N9l6uVR+Bozw=3D=3D?=
X-MS-Exchange-CrossTenant-AuthSource: CH2PR15MB3573.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Dec 2020 01:53:27.5790
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-Network-Message-Id: 61472f4b-5be6-4db9-4284-08d89cae6343
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: P3nG/7spFscfQC/H9PZtv6q1urgS/TcKKRTgGzj0m1SEXt/GSdKP2k1oKypfFli/
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR15MB3542
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-09_19:2020-12-09,2020-12-09 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 impostorscore=0
 malwarescore=0 mlxscore=0 suspectscore=1 spamscore=0 adultscore=0
 lowpriorityscore=0 bulkscore=0 phishscore=0 mlxlogscore=511
 priorityscore=1501 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2012100012
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 10, 2020 at 01:57:19AM +0900, Kuniyuki Iwashima wrote:
[ ... ]

> > > > I think it is a bit complex to pass the new listener from
> > > > reuseport_detach_sock() to inet_csk_listen_stop().
> > > > 
> > > > __tcp_close/tcp_disconnect/tcp_abort
> > > >  |-tcp_set_state
> > > >  |  |-unhash
> > > >  |     |-reuseport_detach_sock (return nsk)
> > > >  |-inet_csk_listen_stop
> > > Picking the new listener does not have to be done in
> > > reuseport_detach_sock().
> > > 
> > > IIUC, it is done there only because it prefers to pick
> > > the last sk from socks[] when bpf prog is not attached.
> > > This seems to get into the way of exploring other potential
> > > implementation options.
> > 
> > Yes.
> > This is just idea, but we can reserve the last index of socks[] to hold the
> > last 'moved' socket in reuseport_detach_sock() and use it in
> > inet_csk_listen_stop().
> > 
> > 
> > > Merging the discussion on the last socks[] pick from another thread:
> > > >
> > > > I think most applications start new listeners before closing listeners, in
> > > > this case, selecting the moved socket as the new listener works well.
> > > >
> > > >
> > > > > That said, if it is still desired to do a random pick by kernel when
> > > > > there is no bpf prog, it probably makes sense to guard it in a sysctl as
> > > > > suggested in another reply.  To keep it simple, I would also keep this
> > > > > kernel-pick consistent instead of request socket is doing something
> > > > > different from the unhash path.
> > > >
> > > > Then, is this way better to keep kernel-pick consistent?
> > > >
> > > >   1. call reuseport_select_migrated_sock() without sk_hash from any path
> > > >   2. generate a random number in reuseport_select_migrated_sock()
> > > >   3. pass it to __reuseport_select_sock() only for select-by-hash
> > > >   (4. pass 0 as sk_hash to bpf_run_sk_reuseport not to use it)
> > > >   5. do migration per queue in inet_csk_listen_stop() or per request in
> > > >      receive path.
> > > >
> > > > I understand it is beautiful to keep consistensy, but also think
> > > > the kernel-pick with heuristic performs better than random-pick.
> > > I think discussing the best kernel pick without explicit user input
> > > is going to be a dead end. There is always a case that
> > > makes this heuristic (or guess) fail.  e.g. what if multiple
> > > sk(s) being closed are always the last one in the socks[]?
> > > all their child sk(s) will then be piled up at one listen sk
> > > because the last socks[] is always picked?
> > 
> > There can be such a case, but it means the newly listened sockets are
> > closed earlier than old ones.
> > 
> > 
> > > Lets assume the last socks[] is indeed the best for all cases.  Then why
> > > the in-progress req don't pick it this way?  I feel the implementation
> > > is doing what is convenient at that point.  And that is fine, I think
> > 
> > In this patchset, I originally assumed four things:
> > 
> >   migration should be done
> >     (i)   from old to new
> >     (ii)  to redistribute requests evenly as possible
> >     (iii) to keep the order of requests in the queue
> >           (resulting in splicing queues)
> >     (iv)  in O(1) for scalability
> >           (resulting in fix-up rsk_listener approach)
> > 
> > I selected the last socket in unhash path to satisfy above four because the
> > last socket changes at every close() syscall if application closes from
> > older socket.
> > 
> > But in receiving ACK or retransmitting SYN+ACK, we cannot get the last
> > 'moved' socket. Even if we reserve the last 'moved' socket in the last
> > index by the idea above, we cannot sure the last socket is changed after
> > close() for each req->listener. For example, we have listeners A, B, C, and
> > D, and then call close(A) and close(B), and receive the final ACKs for A
> > and B, then both of them are assigned to C. In this case, A for D and B for
> > C is desired. So, selecting the last socket in socks[] for incoming
> > requests cannnot realize (ii).
> > 
> > This is why I selected the last moved socket in unhash path and a random
> > listener in receive path.
> > 
> > 
> > > for kernel-pick, it should just go for simplicity and stay with
> > > the random(/hash) pick instead of pretending the kernel knows the
> > > application must operate in a certain way.  It is fine
> > > that the pick was wrong, the kernel will eventually move the
> > > childs/reqs to the survived listen sk.
> > 
> > Exactly. Also the heuristic way is not fair for every application.
> > 
> > After reading below idea (migrated_sk), I think random-pick is better
> > at simplicity and passing each sk.
> > 
> > 
> > > [ I still think the kernel should not even pick if
> > >   there is no bpf prog to instruct how to pick
> > >   but I am fine as long as there is a sysctl to
> > >   guard this. ]
> > 
> > Unless different applications listen on the same port, random-pick can save
> > connections which would be aborted. So, I would add a sysctl to do
> > migration when no eBPF prog is attached.
> > 
> > 
> > > I would rather focus on ensuring the bpf prog getting what it
> > > needs to make the migration pick.  A few things
> > > I would like to discuss and explore:
> > > > If we splice requests like this, we do not need double lock?
> > > > 
> > > >   1. lock the accept queue of the old listener
> > > >   2. unlink all requests and decrement refcount
> > > >   3. unlock
> > > >   4. update all requests with new listener
> > > I guess updating rsk_listener can be done without acquiring
> > > the lock in (5) below is because it is done under the
> > > listening_hash's bucket lock (and also the global reuseport_lock) so
> > > that the new listener will stay in TCP_LISTEN state?
> > 
> > If we do migration in inet_unhash(), the lock is held, but it is not held
> > in inet_csk_listen_stop().
> > 
> > 
> > > I am not sure iterating the queue under these
> > > locks is a very good thing to do though.  The queue may not be
> > > very long in usual setup but still let see
> > > if that can be avoided.
> > 
> > I agree, lock should not be held long.
> > 
> > 
> > > Do you think the iteration can be done without holding
> > > bucket lock and the global reuseport_lock?  inet_csk_reqsk_queue_add()
> > > is taking the rskq_lock and then check for TCP_LISTEN.  May be
> > > something similar can be done also?
> > 
> > I think either one is necessary at least, so if the sk_state of selected
> > listener is TCP_CLOSE (this is mostly by random-pick of kernel), then we
> > have to fall back to call inet_child_forget().
> > 
> > 
> > > While doing BPF_SK_REUSEPORT_MIGRATE_REQUEST,
> > > the bpf prog can pick per req and have the sk_hash.
> > > However, while doing BPF_SK_REUSEPORT_MIGRATE_QUEUE,
> > > the bpf prog currently does not have a chance to
> > > pick individually for each req/child on the queue.
> > > Since it is iterating the queue anyway, does it make
> > > sense to also call the bpf to pick for each req/child
> > > in the queue?  It then can pass sk_hash (from child->sk_hash?)
> > > to the bpf prog also instead of current 0.  The cost of calling
> > > bpf prog is not really that much / signficant at the
> > > migration code path.  If the queue is somehow
> > > unusally long, there is already an existing
> > > cond_resched() in inet_csk_listen_stop().
> > > 
> > > Then, instead of adding sk_reuseport_md->migration,
> > > it can then add sk_reuseport_md->migrate_sk.
> > > "migrate_sk = req" for in-progress req and "migrate_sk = child"
> > > for iterating acceptq.  The bpf_prog can then tell what sk (req or child)
> > > it is migrating by reading migrate_sk->state.  It can then also
> > > learn the 4 tuples src/dst ip/port while skb is missing.
> > > The sk_reuseport_md->sk can still point to the closed sk
> > > such that the bpf prog can learn the cookie.
> > > 
> > > I suspect a few things between BPF_SK_REUSEPORT_MIGRATE_REQUEST
> > > and BPF_SK_REUSEPORT_MIGRATE_QUEUE can be folded together
> > > by doing the above.  It also gives a more consistent
> > > interface for the bpf prog, no more MIGRATE_QUEUE vs MIGRATE_REQUEST.
> > 
> > I think this is really nice idea. Also, I tried to implement random-pick
> > one by one in inet_csk_listen_stop() yesterday, I found a concern about how
> > to handle requests in TFO queue.
> > 
> > The request can be already accepted, so passing it to eBPF prog is
> > confusing? But, redistributing randomly can affect all listeners
> > unnecessary. How should we handle such requests?
> 
> I've implemented one-by-one migration only for the accept queue for now.
> In addition to the concern about TFO queue,
You meant this queue:  queue->fastopenq.rskq_rst_head?
Can "req" be passed?
I did not look up the lock/race in details for that though.

> I want to discuss which should
> we pass NULL or request_sock to eBPF program as migrate_sk when selecting a
> listener for SYN ?
hmmm... not sure I understand your question.

You meant the existing lookup listener case from inet_lhash2_lookup()?
There is nothing to migrate at that point, so NULL makes sense to me.
migrate_sk's type should be PTR_TO_SOCK_COMMON_OR_NULL.

> 
> ---8<---
> diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
> index a82fd4c912be..d0ddd3cb988b 100644
> --- a/net/ipv4/inet_connection_sock.c
> +++ b/net/ipv4/inet_connection_sock.c
> @@ -1001,6 +1001,29 @@ struct sock *inet_csk_reqsk_queue_add(struct sock *sk,
>  }
>  EXPORT_SYMBOL(inet_csk_reqsk_queue_add);
>  
> +static bool inet_csk_reqsk_queue_migrate(struct sock *sk, struct sock *nsk, struct request_sock *req)
> +{
> +       struct request_sock_queue *queue = &inet_csk(nsk)->icsk_accept_queue;
> +       bool migrated = false;
> +
> +       spin_lock(&queue->rskq_lock);
> +       if (likely(nsk->sk_state == TCP_LISTEN)) {
> +               migrated = true;
> +
> +               req->dl_next = NULL;
> +               if (queue->rskq_accept_head == NULL)
> +                       WRITE_ONCE(queue->rskq_accept_head, req);
> +               else
> +                       queue->rskq_accept_tail->dl_next = req;
> +               queue->rskq_accept_tail = req;
> +               sk_acceptq_added(nsk);
> +               inet_csk_reqsk_queue_migrated(sk, nsk, req);
need to first resolve the question raised in patch 5 regarding
to the update on req->rsk_listener though.

> +       }
> +       spin_unlock(&queue->rskq_lock);
> +
> +       return migrated;
> +}
> +
>  struct sock *inet_csk_complete_hashdance(struct sock *sk, struct sock *child,
>                                          struct request_sock *req, bool own_req)
>  {
> @@ -1023,9 +1046,11 @@ EXPORT_SYMBOL(inet_csk_complete_hashdance);
>   */
>  void inet_csk_listen_stop(struct sock *sk)
>  {
> +       struct sock_reuseport *reuseport_cb = rcu_access_pointer(sk->sk_reuseport_cb);
>         struct inet_connection_sock *icsk = inet_csk(sk);
>         struct request_sock_queue *queue = &icsk->icsk_accept_queue;
>         struct request_sock *next, *req;
> +       struct sock *nsk;
>  
>         /* Following specs, it would be better either to send FIN
>          * (and enter FIN-WAIT-1, it is normal close)
> @@ -1043,8 +1068,19 @@ void inet_csk_listen_stop(struct sock *sk)
>                 WARN_ON(sock_owned_by_user(child));
>                 sock_hold(child);
>  
> +               if (reuseport_cb) {
> +                       nsk = reuseport_select_migrated_sock(sk, req_to_sk(req)->sk_hash, NULL);
> +                       if (nsk) {
> +                               if (inet_csk_reqsk_queue_migrate(sk, nsk, req))
> +                                       goto unlock_sock;
> +                               else
> +                                       sock_put(nsk);
> +                       }
> +               }
> +
>                 inet_child_forget(sk, req, child);
>                 reqsk_put(req);
> +unlock_sock:
>                 bh_unlock_sock(child);
>                 local_bh_enable();
>                 sock_put(child);
> ---8<---
> 
> 
> > > >   5. lock the accept queue of the new listener
> > > >   6. splice requests and increment refcount
> > > >   7. unlock
> > > > 
> > > > Also, I think splicing is better to keep the order of requests. Adding one
> > > > by one reverses it.
> > > It can keep the order but I think it is orthogonal here.

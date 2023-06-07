Return-Path: <netdev+bounces-8917-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 07E987264A5
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 17:28:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5655C1C20D8F
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 15:28:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0470B34447;
	Wed,  7 Jun 2023 15:28:35 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5B6C1ACB5
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 15:28:34 +0000 (UTC)
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAD8B271E
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 08:28:07 -0700 (PDT)
Received: by mail-lf1-x130.google.com with SMTP id 2adb3069b0e04-4f61efe4584so2878e87.1
        for <netdev@vger.kernel.org>; Wed, 07 Jun 2023 08:28:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686151659; x=1688743659;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qObgbYaFcaskIbABQbPOzpT+mA1o63LMYBFQa3B3P2M=;
        b=6n6UeIP091KfURrhFgJ09uB3YFwdIlch5kic/RctRkl7/jVjNarsD8uJjeYjjM5PhO
         NH8lnkqOyYhR7ywmU0XxTqSPycWMblRyq2sOq4hUp49a2f454QeHbAETRS99mFkx2sOl
         d+HtJXJ2XyiDNodn7pM5N0MsTQFXmO7iPv48h7bV7iZB8SKJK/d7HGtc7oEVOLTSs3nA
         RqT5XxHn1P3KbvhGLxELLcSVPKe+WCcUVlfu/hEs1RIzCwEFhUYtzErBaTO9G4Mz+yi9
         kXenX/yU/+hOiiBN51slZP0aav+NjyHj8eq3fqBRZPplvQzGbfCTqrEJYnfcs5iUs/ON
         7tRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686151659; x=1688743659;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qObgbYaFcaskIbABQbPOzpT+mA1o63LMYBFQa3B3P2M=;
        b=DFZWh1+xPIOPNWVmg9Xa01MSaDTqWiShZJiYJkXSJZEtUyP1Xr1cGCF58iaHstkaFl
         fS9+Lr59BWDz5RNhItIGx5+xbQ72W6EFyHYg1h6BbfhnlAbDDdeAmzRE+yUx24z832Wl
         17sJN0iQCRVR+I9XTSqraFGeJ5sIDfgkWp+nq7LeR4NY7u6+PXAquD45imdD3HeMYmqu
         vPd14QThHpQwS4xw1OIHY+iYC6HRJBNB1413qYriy2E0J8GpNB03x87mHs+z0t3xCLMZ
         eNXsckL34p1qKK7jx7OKzrFi2DLOTaQ5M4EB1AulspLG6wFWXBfbJcxSb9Ue3LyTrhto
         0KTg==
X-Gm-Message-State: AC+VfDw8MwKrVu9t76k8OXyD7n/iXMKfu5SMWMWBld6g8LfUXp2ySr/9
	9sAG+Ji1WR7y67cETKxrQLg/oX1wJFQB+gA9wTQseg==
X-Google-Smtp-Source: ACHHUZ7LR5vou+bNzEEV30UgzqIxuSFs8cJa1chfHdUPUXM3u8u+HRCQXfq8gt5UwysxnkKyyixxka9le/heRotPrZc=
X-Received: by 2002:ac2:5392:0:b0:4f6:132d:a9c2 with SMTP id
 g18-20020ac25392000000b004f6132da9c2mr117671lfh.3.1686151658685; Wed, 07 Jun
 2023 08:27:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230606064306.9192-1-duanmuquan@baidu.com> <CANn89iKwzEtNWME+1Xb57DcT=xpWaBf59hRT4dYrw-jsTdqeLA@mail.gmail.com>
 <DFBEBE81-34A5-4394-9C5B-1A849A6415F1@baidu.com> <CANn89iLm=UeSLBVjACnqyaLo7oMTrY7Ok8RXP9oGDHVwe8LVng@mail.gmail.com>
 <D8D0327E-CEF0-4DFC-83AB-BC20EE3DFCDE@baidu.com>
In-Reply-To: <D8D0327E-CEF0-4DFC-83AB-BC20EE3DFCDE@baidu.com>
From: Eric Dumazet <edumazet@google.com>
Date: Wed, 7 Jun 2023 17:27:26 +0200
Message-ID: <CANn89iKXttFLj4WCVjWNeograv=LHta4erhtqm=fpfiEWscJCA@mail.gmail.com>
Subject: Re: [PATCH v2] tcp: fix connection reset due to tw hashdance race.
To: "Duan,Muquan" <duanmuquan@baidu.com>
Cc: "davem@davemloft.net" <davem@davemloft.net>, "dsahern@kernel.org" <dsahern@kernel.org>, 
	"kuba@kernel.org" <kuba@kernel.org>, "pabeni@redhat.com" <pabeni@redhat.com>, 
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
	ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL,
	USER_IN_DEF_SPF_WL autolearn=unavailable autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, Jun 7, 2023 at 5:18=E2=80=AFPM Duan,Muquan <duanmuquan@baidu.com> w=
rote:
>
> Hi, Eric,
>
> Thanks for your reply!
> One module of our CDN product suffered from the  connection refuse error =
caused by the hashdance race,    I am trying to solve this issue that hurt =
userland applications, not  all the possible cases. Except this reset case,=
 the worst case I can figure out is the lost of the passive closer=E2=80=99=
s FIN which will cause a retransmission, this kind of case will not cause a=
n error on applications, and the possibility is very small, I think we do n=
ot need to introduce reader=E2=80=99s lock for this kind of cases.
>
> I can't agree more that we tried too hard to =E2=80=98detect races=E2=80=
=99, but I also have concern about the performance if introducing reader=E2=
=80=99s lock, do we have any test result about the performance with the rea=
der=E2=80=99s lock? I will also do some test on this, if the impact can be =
tolerated, we=E2=80=99d better introduce the lock.
>
> Anyway, I think tw sock's tw_refcnt should be set before added tw into th=
e list, and  this modification can make the setting of refcnt in the spin_l=
ock=E2=80=99s protection,  what is your opinion about this modification?

My opinion is that we should set the refcnt to not zero only at when
the tw object is ready to be seen by other cpus.

Moving this earlier can trigger subtle bugs with RCU lookups,
that might see a non zero refcnt on an object still containing garbage.

You missed the important comment :

> 153      * Also note that after this point, we lost our implicit referenc=
e
> 154      * so we are not allowed to use tw anymore.

We are not _allowed_ to access tw anymore after setting its refcnt to 3.

Again, this patch does not fix the fundamental issue, just moving
things around and hope for the best.

>
> 145    spin_lock(lock);
> 146
> 147     /* tw_refcnt is set to 3 because we have :
> 148      * - one reference for bhash chain.
> 149      * - one reference for ehash chain.
> 150      * - one reference for timer.
> 151      * We can use atomic_set() because prior spin_lock()/spin_unlock(=
)
> 152      * committed into memory all tw fields.
> 153      * Also note that after this point, we lost our implicit referenc=
e
> 154      * so we are not allowed to use tw anymore.
> 155      */
> 156     refcount_set(&tw->tw_refcnt, 3);                                 =
<-----------------------------------------------
> 157     inet_twsk_add_node_tail_rcu(tw, &ehead->chain);
> 158
> 159     /* Step 3: Remove SK from hash chain */
> 160     if (__sk_nulls_del_node_init_rcu(sk))
> 161         sock_prot_inuse_add(sock_net(sk), sk->sk_prot, -1);
> 162
> 163     spin_unlock(lock);
>
>
>
> BTW, I met trouble on sending emails,  and some emails may not delivered,=
 thanks a lot for Jason and Simon=E2=80=99s comments!
>
> Best Regards!
> Duan
>
>
>
>
> > 2023=E5=B9=B46=E6=9C=887=E6=97=A5 =E4=B8=8B=E5=8D=889:32=EF=BC=8CEric D=
umazet <edumazet@google.com> =E5=86=99=E9=81=93=EF=BC=9A
> >
> > On Wed, Jun 7, 2023 at 1:59=E2=80=AFPM Duan,Muquan <duanmuquan@baidu.co=
m> wrote:
> >>
> >> Hi, Eric,
> >>
> >> Thanks for your comments!
> >>
> >> About the second lookup, I am sorry that I did not give enough explana=
tions about it. Here are some details:
> >>
> >> 1.  The second lookup can find the tw sock and avoid the connection re=
fuse error on userland applications:
> >>
> >> If the original sock is found, but when validating its refcnt, it has =
been destroyed and sk_refcnt has become 0 after decreased by tcp_time_wait(=
)->tcp_done()->inet_csk_destory_sock()->sock_put().The validation for refcn=
t fails and the lookup process gets a listener sock.
> >>
> >> When this case occurs, the hashdance has definitely finished=EF=BC=8Cb=
ecause tcp_done() is executed after inet_twsk_hashdance(). Then if look up =
the ehash table again, hashdance has already finished, tw sock will be foun=
d.
> >>
> >> With this fix, logically we can solve the connection reset issue compl=
etely when no established sock is found due to hashdance race.In my reprodu=
cing environment, the connection refuse error will occur about every 6 hour=
s with only the fix of bad case (2). But with both of the 2 fixes, I tested=
 it many times, the longest test continues for 10 days, it does not occur a=
gain,
> >>
> >>
> >>
> >> 2. About the performance impact:
> >>
> >>     A similar scenario is that __inet_lookup_established() will do ine=
t_match() check for the second time, if fails it will look up    the list a=
gain. It is the extra effort to reduce the race impact without using reader=
 lock. inet_match() failure occurs with about the same probability with ref=
cnt validation failure in my test environment.
> >>
> >> The second lookup will only be done in the condition that FIN segment =
gets a listener sock.
> >>
> >>  About the performance impact:
> >>
> >> 1)  Most of the time, this condition will not met, the added codes int=
roduces at most 3 comparisons for each segment.
> >>
> >> The second inet_match() in __inet_lookup_established()  does least 3 c=
omparisons for each segmet.
> >>
> >>
> >> 2)  When this condition is met, the probability is very small. The imp=
act is similar to the second try due to inet_match() failure. Since tw sock=
 can definitely be found in the second try, I think this cost is worthy to =
avoid connection reused error on userland applications.
> >>
> >>
> >>
> >> My understanding is, current philosophy is avoiding the reader lock by=
 tolerating the minor defect which occurs in a small probability.For exampl=
e, if the FIN from passive closer is dropped due to the found sock is destr=
oyed, a retransmission can be tolerated, it only makes the connection termi=
nation slower. But I think the bottom line is that it does not affect the u=
serland applications=E2=80=99 functionality. If application fails to connec=
t due to the hashdance race, it can=E2=80=99t be tolerated. In fact, guys f=
rom product department push hard on the connection refuse error.
> >>
> >>
> >> About bad case (2):
> >>
> >> tw sock is found, but its tw_refcnt has not been set to 3, it is still=
 0, validating for sk_refcnt will fail.
> >>
> >> I do not know the reason why setting tw_refcnt after adding it into li=
st, could anyone help point out the reason? It adds  extra race because the=
 new added tw sock may be found and checked in other CPU concurrently befor=
e =C6=92setting tw_refcnt to 3.
> >>
> >> By setting tw_refcnt to 3 before adding it into list, this case will b=
e solved, and almost no cost. In my reproducing environment, it occurs more=
 frequently than bad case (1), it appears about every 20 minutes, bad case =
(1) appears about every 6 hours.
> >>
> >>
> >>
> >> About the bucket spinlock, the original established sock and tw sock a=
re stored in the ehash table, I concern about the performance when there ar=
e lots of short TCP connections, the reader lock may affect the performance=
 of connection creation and termination. Could you share some details of yo=
ur idea? Thanks in advance.
> >>
> >>
> >
> > Again, you can write a lot of stuff, the fact is that your patch does
> > not solve the issue.
> >
> > You could add 10 lookups, and still miss some cases, because they are
> > all RCU lookups with no barriers.
> >
> > In order to solve the issue of packets for the same 4-tuple being
> > processed by many cpus, the only way to solve races is to add mutual
> > exclusion.
> >
> > Note that we already have to lock the bucket spinlock every time we
> > transition a request socket to socket, a socket to timewait, or any
> > insert/delete.
> >
> > We need to expand the scope of this lock, and cleanup things that we
> > added in the past, because we tried too hard to 'detect races'
> >
> >>
> >>
> >>
> >> Best Regards!
> >>
> >> Duan
> >>
> >>
> >> 2023=E5=B9=B46=E6=9C=886=E6=97=A5 =E4=B8=8B=E5=8D=883:07=EF=BC=8CEric =
Dumazet <edumazet@google.com> =E5=86=99=E9=81=93=EF=BC=9A
> >>
> >> On Tue, Jun 6, 2023 at 8:43=E2=80=AFAM Duan Muquan <duanmuquan@baidu.c=
om> wrote:
> >>
> >>
> >> If the FIN from passive closer and the ACK for active closer's FIN are
> >> processed on different CPUs concurrently, tw hashdance race may occur.
> >> On loopback interface, transmit function queues a skb to current CPU's
> >> softnet's input queue by default. Suppose active closer runs on CPU 0,
> >> and passive closer runs on CPU 1. If the ACK for the active closer's
> >> FIN is sent with no delay, it will be processed and tw hashdance will
> >> be done on CPU 0; The passive closer's FIN will be sent in another
> >> segment and processed on CPU 1, it may fail to find tw sock in the
> >> ehash table due to tw hashdance on CPU 0, then get a RESET.
> >> If application reconnects immediately with the same source port, it
> >> will get reset because tw sock's tw_substate is still TCP_FIN_WAIT2.
> >>
> >> The dmesg to trace down this issue:
> >>
> >> .333516] tcp_send_fin: sk 0000000092105ad2 cookie 9 cpu 3
> >> .333524] rcv_state_process:FIN_WAIT2 sk 0000000092105ad2 cookie 9 cpu =
3
> >> .333534] tcp_close: tcp_time_wait: sk 0000000092105ad2 cookie 9 cpu 3
> >> .333538] hashdance: tw 00000000690fdb7a added to ehash cookie 9 cpu 3
> >> .333541] hashdance: sk 0000000092105ad2 removed cookie 9 cpu 3
> >> .333544] __inet_lookup_established: Failed the refcount check:
> >>                !refcount_inc_not_zero 00000000690fdb7a ref 0 cookie 9 =
cpu 0
> >> .333549] hashdance: tw 00000000690fdb7a before add ref 0 cookie 9 cpu =
3
> >> .333552] rcv_state: RST for FIN listen 000000003c50afa6 cookie 0 cpu 0
> >> .333574] tcp_send_fin: sk 0000000066757bf8 ref 2 cookie 0 cpu 0
> >> .333611] timewait_state: TCP_TW_RST tw 00000000690fdb7a cookie 9 cpu 0
> >> .333626] tcp_connect: sk 0000000066757bf8 cpu 0 cookie 0
> >>
> >> Here is the call trace map:
> >>
> >> CPU 0                                    CPU 1
> >>
> >> --------                                 --------
> >> tcp_close()
> >> tcp_send_fin()
> >> loopback_xmit()
> >> netif_rx()
> >> tcp_v4_rcv()
> >> tcp_ack_snd_check()
> >> loopback_xmit
> >> netif_rx()                              tcp_close()
> >> ...                                     tcp_send_fin()
> >>                                                                       =
        loopback_xmit()
> >>                                                                       =
        netif_rx()
> >>                                                                       =
        tcp_v4_rcv()
> >>                                                                       =
        ...
> >> tcp_time_wait()
> >> inet_twsk_hashdance() {
> >> ...
> >>                                   <-__inet_lookup_established()
> >>                                                               (bad cas=
e (1), find sk, may fail tw_refcnt check)
> >> inet_twsk_add_node_tail_rcu(tw, ...)
> >>                                   <-__inet_lookup_established()
> >>                                                               (bad cas=
e (1), find sk, may fail tw_refcnt check)
> >>
> >> __sk_nulls_del_node_init_rcu(sk)
> >>                                   <-__inet_lookup_established()
> >>                                                               (bad cas=
e (2), find tw, may fail tw_refcnt check)
> >> refcount_set(&tw->tw_refcnt, 3)
> >>                                   <-__inet_lookup_established()
> >>                                                               (good ca=
se, find tw, tw_refcnt is not 0)
> >> ...
> >> }
> >>
> >> This issue occurs with a small probability on our application working
> >> on loopback interface, client gets a connection refused error when it
> >> reconnects. In reproducing environments on kernel 4.14,5.10 and
> >> 6.4-rc1, modify tcp_ack_snd_check() to disable delay ack all the
> >> time; Let client connect server and server sends a message to client
> >> then close the connection; Repeat this process forever; Let the client
> >> bind the same source port every time, it can be reproduced in about 20
> >> minutes.
> >>
> >> Brief of the scenario:
> >>
> >> 1. Server runs on CPU 0 and Client runs on CPU 1. Server closes
> >> connection actively and sends a FIN to client. The lookback's driver
> >> enqueues the FIN segment to backlog queue of CPU 0 via
> >> loopback_xmit()->netif_rx(), one of the conditions for non-delay ack
> >> meets in __tcp_ack_snd_check(), and the ACK is sent immediately.
> >>
> >> 2. On loopback interface, the ACK is received and processed on CPU 0,
> >> the 'dance' from original sock to tw sock will perfrom, tw sock will
> >> be inserted to ehash table, then the original sock will be removed.
> >>
> >> 3. On CPU 1, client closes the connection, a FIN segment is sent and
> >> processed on CPU 1. When it is looking up sock in ehash table (with no
> >> lock), tw hashdance race may occur, it fails to find the tw sock and
> >> get a listener sock in the flowing 3 cases:
> >>
> >> (1) Original sock is found, but it has been destroyed and sk_refcnt
> >>         has become 0 when validating it.
> >> (2) tw sock is found, but its tw_refcnt has not been set to 3, it is
> >>         still 0, validating for sk_refcnt will fail.
> >> (3) For versions without Eric and Jason's commit(3f4ca5fafc08881d7a5
> >>         7daa20449d171f2887043), tw sock is added to the head of the li=
st.
> >>         It will be missed if the list is traversed before tw sock is
> >>         added. And if the original sock is removed before it is found,=
 no
> >>         established sock will be found.
> >>
> >> The listener sock will reset the FIN segment which has ack bit set.
> >>
> >> 4. If client reconnects immediately and is assigned with the same
> >> source port as previous connection, the tw sock with tw_substate
> >> TCP_FIN_WAIT2 will reset client's SYN and destroy itself in
> >> inet_twsk_deschedule_put(). Application gets a connection refused
> >> error.
> >>
> >> 5. If client reconnects again, it will succeed.
> >>
> >> Introduce the flowing 2 modifications to solve the above 3 bad cases:
> >>
> >> For bad case (2):
> >> Set tw_refcnt to 3 before adding it into list.
> >>
> >> For bad case (1):
> >> In function tcp_v4_rcv(), if __inet_lookup_skb() returns a listener
> >> sock and this segment has FIN bit set, then retry the lookup process
> >> one time. This fix can cover bad case (3) for the versions without
> >> Eric and Jason's fix.
> >>
> >> There may be another bad case, if the original sock is found and passe=
s
> >> validation, but during further process for the passive closer's FIN on
> >> CPU 1, the sock has been destroyed on CPU 0, then the FIN segment will
> >> be dropped and retransmitted. This case does not hurt application as
> >> much as resetting reconnection, and this case has less possibility tha=
n
> >> the other bad cases, it does not occur on our product and in
> >> experimental environment, so it is not considered in this patch.
> >>
> >> Could you please check whether this fix is OK, or any suggestions?
> >> Looking forward for your precious comments!
> >>
> >> Signed-off-by: Duan Muquan <duanmuquan@baidu.com>
> >> ---
> >> net/ipv4/inet_timewait_sock.c | 15 +++++++--------
> >> net/ipv4/tcp_ipv4.c           | 13 +++++++++++++
> >> 2 files changed, 20 insertions(+), 8 deletions(-)
> >>
> >> diff --git a/net/ipv4/inet_timewait_sock.c b/net/ipv4/inet_timewait_so=
ck.c
> >> index 40052414c7c7..ed1f255c9aa8 100644
> >> --- a/net/ipv4/inet_timewait_sock.c
> >> +++ b/net/ipv4/inet_timewait_sock.c
> >> @@ -144,14 +144,6 @@ void inet_twsk_hashdance(struct inet_timewait_soc=
k *tw, struct sock *sk,
> >>
> >>       spin_lock(lock);
> >>
> >> -       inet_twsk_add_node_tail_rcu(tw, &ehead->chain);
> >> -
> >> -       /* Step 3: Remove SK from hash chain */
> >> -       if (__sk_nulls_del_node_init_rcu(sk))
> >> -               sock_prot_inuse_add(sock_net(sk), sk->sk_prot, -1);
> >> -
> >> -       spin_unlock(lock);
> >> -
> >>       /* tw_refcnt is set to 3 because we have :
> >>        * - one reference for bhash chain.
> >>        * - one reference for ehash chain.
> >> @@ -162,6 +154,13 @@ void inet_twsk_hashdance(struct inet_timewait_soc=
k *tw, struct sock *sk,
> >>        * so we are not allowed to use tw anymore.
> >>        */
> >>       refcount_set(&tw->tw_refcnt, 3);
> >> +       inet_twsk_add_node_tail_rcu(tw, &ehead->chain);
> >> +
> >> +       /* Step 3: Remove SK from hash chain */
> >> +       if (__sk_nulls_del_node_init_rcu(sk))
> >> +               sock_prot_inuse_add(sock_net(sk), sk->sk_prot, -1);
> >> +
> >> +       spin_unlock(lock);
> >> }
> >> EXPORT_SYMBOL_GPL(inet_twsk_hashdance);
> >>
> >> diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
> >> index 06d2573685ca..3e3cef202f76 100644
> >> --- a/net/ipv4/tcp_ipv4.c
> >> +++ b/net/ipv4/tcp_ipv4.c
> >> @@ -2018,6 +2018,19 @@ int tcp_v4_rcv(struct sk_buff *skb)
> >>       sk =3D __inet_lookup_skb(net->ipv4.tcp_death_row.hashinfo,
> >>                              skb, __tcp_hdrlen(th), th->source,
> >>                              th->dest, sdif, &refcounted);
> >> +
> >> +       /* If tw "dance" is performed on another CPU, the lookup proce=
ss may find
> >> +        * no tw sock for the passive closer's FIN segment, but a list=
ener sock,
> >> +        * which will reset the FIN segment. If application reconnects=
 immediately
> >> +        * with the same source port, it will get reset because the tw=
 sock's
> >> +        * tw_substate is still TCP_FIN_WAIT2. Try to get the tw sock =
in another try.
> >> +        */
> >> +       if (unlikely(th->fin && sk && sk->sk_state =3D=3D TCP_LISTEN))=
 {
> >> +               sk =3D __inet_lookup_skb(net->ipv4.tcp_death_row.hashi=
nfo,
> >> +                                      skb, __tcp_hdrlen(th), th->sour=
ce,
> >> +                                      th->dest, sdif, &refcounted);
> >> +       }
> >> +
> >>
> >>
> >> I do not think this fixes anything, there is no barrier between first
> >> and second lookup.
> >> This might reduce race a little bit, but at the expense of extra code
> >> in the fast path.
> >>
> >> If you want to fix this properly, I think we need to revisit handling
> >> for non established sockets,
> >> to hold the bucket spinlock over the whole thing.
> >>
> >> This will be slightly more complex than this...
> >>
> >>
>


Return-Path: <netdev+bounces-1247-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 51C986FCE87
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 21:28:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1FC592813C2
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 19:28:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 39223174EC;
	Tue,  9 May 2023 19:28:05 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21902174E9
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 19:28:05 +0000 (UTC)
Received: from smtp-fw-80006.amazon.com (smtp-fw-80006.amazon.com [99.78.197.217])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 356104483
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 12:28:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1683660483; x=1715196483;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=LIT8yZmDpTrXQIluw3Ho6Vx61zZ4xW/MakVU9pdPjyY=;
  b=aFedpOoieKPrmwGMj/cyuIWUpvb6p0wviFWD1IhkTCQPtFDF0ebf92sx
   bpsakEw/KLRqhzU6JDW0ReWSjWyi6O8mvh1s2tjopImb3G6F/r41YolUi
   ZW/9sAKl+bMP7s6EPRphJIVxZsoAnRFhw7aa/F9ZhU5BrB41F5rAiH8aD
   g=;
X-IronPort-AV: E=Sophos;i="5.99,262,1677542400"; 
   d="scan'208";a="212438427"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-iad-1a-m6i4x-96feee09.us-east-1.amazon.com) ([10.25.36.210])
  by smtp-border-fw-80006.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 May 2023 19:28:00 +0000
Received: from EX19MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
	by email-inbound-relay-iad-1a-m6i4x-96feee09.us-east-1.amazon.com (Postfix) with ESMTPS id 47E4E43758;
	Tue,  9 May 2023 19:27:57 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX19MTAUWB001.ant.amazon.com (10.250.64.248) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Tue, 9 May 2023 19:27:45 +0000
Received: from 88665a182662.ant.amazon.com (10.187.171.38) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Tue, 9 May 2023 19:27:42 +0000
From: Kuniyuki Iwashima <kuniyu@amazon.com>
To: <edumazet@google.com>
CC: <davem@davemloft.net>, <dsahern@kernel.org>, <kuba@kernel.org>,
	<kuni1840@gmail.com>, <kuniyu@amazon.com>, <mubashirq@google.com>,
	<ncardwell@google.com>, <netdev@vger.kernel.org>, <pabeni@redhat.com>,
	<zob@amazon.com>, <nyoshif@amazon.com>
Subject: Re: [PATCH v1 net-next] tcp: Add net.ipv4.tcp_reset_challenge.
Date: Tue, 9 May 2023 12:27:34 -0700
Message-ID: <20230509192734.41099-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <CANn89i+ZK6+bPQds2fbff=-ojJ=W=czUvrWPyOCTno=qO6yzDQ@mail.gmail.com>
References: <CANn89i+ZK6+bPQds2fbff=-ojJ=W=czUvrWPyOCTno=qO6yzDQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.187.171.38]
X-ClientProxiedBy: EX19D033UWA004.ant.amazon.com (10.13.139.85) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
Precedence: Bulk
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,T_SCC_BODY_TEXT_LINE,
	T_SPF_PERMERROR,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Eric Dumazet <edumazet@google.com>
Date: Tue, 9 May 2023 15:42:45 +0200
> On Tue, May 9, 2023 at 3:34 PM Paolo Abeni <pabeni@redhat.com> wrote:
> >
> > On Mon, 2023-05-08 at 15:27 -0700, Kuniyuki Iwashima wrote:
> > > Our Network Load Balancer (NLB) [0] consists of multiple nodes with unique
> > > IP addresses.  These nodes forward TCP flows from clients to backend
> > > targets by modifying the destination IP address.  NLB offers an option [1]
> > > to preserve the client's source IP address and port when routing packets
> > > to backend targets.
> > >
> > > When a client connects to two different NLB nodes, they may select the same
> > > backend target.  If the client uses the same source IP and port, the two
> > > flows at the backend side will have the same 4-tuple.
> > >
> > >                          +---------------+
> > >             1st flow     |  NLB Node #1  |   src: 10.0.0.215:60000
> > >          +------------>  |   10.0.3.4    |  +------------+
> > >          |               |    :10000     |               |
> > >          +               +---------------+               v
> > >   +------------+                                   +------------+
> > >   |   Client   |                                   |   Target   |
> > >   | 10.0.0.215 |                                   | 10.0.3.249 |
> > >   |   :60000   |                                   |   :10000   |
> > >   +------------+                                   +------------+
> > >          +               +---------------+               ^
> > >          |               |  NLB Node #2  |               |
> > >          +------------>  |   10.0.4.62   |  +------------+
> > >             2nd flow     |    :10000     |   src: 10.0.0.215:60000
> > >                          +---------------+
> > >
> > > The kernel responds to the SYN of the 2nd flow with Challenge ACK.  In this
> > > situation, there are multiple valid reply paths, but the flows behind NLB
> > > are tracked to ensure symmetric routing [2].  So, the Challenge ACK is
> > > routed back to the 2nd NLB node.
> > >
> > > The 2nd NLB node forwards the Challenge ACK to the client, but the client
> > > sees it as an invalid response to SYN in tcp_rcv_synsent_state_process()
> > > and finally sends RST in tcp_v[46]_do_rcv() based on the sequence number
> > > by tcp_v[46]_send_reset().  The RST effectively closes the first connection
> > > on the target, and a retransmitted SYN successfully establishes the 2nd
> > > connection.
> > >
> > >   On client:
> > >   10.0.0.215.60000 > 10.0.3.4.10000: Flags [S], seq 772948343  ... via NLB Node #1
> > >   10.0.3.4.10000 > 10.0.0.215.60000: Flags [S.], seq 3739044674, ack 772948344
> > >   10.0.0.215.60000 > 10.0.3.4.10000: Flags [.], ack 3739044675
> > >
> > >   10.0.0.215.60000 > 10.0.4.62.10000: Flags [S], seq 248180743 ... via NLB Node #2
> > >   10.0.4.62.10000 > 10.0.0.215.60000: Flags [.], ack 772948344 ... Invalid Challenge ACK
> > >   10.0.0.215.60000 > 10.0.4.62.10000: Flags [R], seq 772948344 ... RST w/ correct seq #
> > >   10.0.0.215.60000 > 10.0.4.62.10000: Flags [S], seq 248180743
> > >   10.0.4.62.10000 > 10.0.0.215.60000: Flags [S.], seq 4160908213, ack 248180744
> > >   10.0.0.215.60000 > 10.0.4.62.10000: Flags [.], ack 4160908214
> > >
> > >   On target:
> > >   10.0.0.215.60000 > 10.0.3.249.10000: Flags [S], seq 772948343 ... via NLB Node #1
> > >   10.0.3.249.10000 > 10.0.0.215.60000: Flags [S.], seq 3739044674, ack 772948344
> > >   10.0.0.215.60000 > 10.0.3.249.10000: Flags [.], ack 3739044675
> > >
> > >   10.0.0.215.60000 > 10.0.3.249.10000: Flags [S], seq 248180743 ... via NLB Node #2
> > >   10.0.3.249.10000 > 10.0.0.215.60000: Flags [.], ack 772948344 ... Forwarded to 2nd flow
> > >   10.0.0.215.60000 > 10.0.3.249.10000: Flags [R], seq 772948344 ... Close the 1st connection
> > >   10.0.0.215.60000 > 10.0.3.249.10000: Flags [S], seq 248180743
> > >   10.0.3.249.10000 > 10.0.0.215.60000: Flags [S.], seq 4160908213, ack 248180744
> > >   10.0.0.215.60000 > 10.0.3.249.10000: Flags [.], ack 4160908214
> > >
> > > The first connection is still alive from the client's point of view.  When
> > > the client sends data over the first connection, the target responds with
> > > Challenge ACK.  The Challenge ACK is routed back to the 1st connection, and
> > > the client responds with Dup ACK, and the target responds to the Dup ACK
> > > with Challenge ACK, and this continues.
> > >
> > >   On client:
> > >   10.0.0.215.60000 > 10.0.3.4.10000: Flags [P.], seq 772948344:772948349, ack 3739044675, length 5
> > >   10.0.3.4.10000 > 10.0.0.215.60000: Flags [.], ack 248180744, length 0  ... Challenge ACK
> > >   10.0.0.215.60000 > 10.0.3.4.10000: Flags [.], ack 3739044675, length 0 ... Dup ACK
> > >   10.0.3.4.10000 > 10.0.0.215.60000: Flags [.], ack 248180744, length 0  ... Challenge ACK
> > >   ...
> > >
> > > In RFC 5961, Challenge ACK assumes that it will be routed back via an
> > > asymmetric path to the peer of the established connection.  However, in
> > > a situation where multiple valid reply paths are tracked, Challenge ACK
> > > gives a hint to snipe another connection and also triggers the Challenge
> > > ACK Dup ACK war on the connection.
> > >
> > > A new sysctl knob, net.ipv4.tcp_reset_challenge, allows us to respond to
> > > invalid packets described in RFC 5961 with RST and keep the established
> > > socket open.
> >
> > I did not double check with the RFC, but the above looks like a knob to
> > enable a protocol violation.
> >
> > I'm wondering if the same results could be obtained with a BPF program
> > instead?

XDP could.  But implementing TCP stack like prog could be hard, and more
than anything, this is actually a corner case (we quite often observe
this though), so applying such prog for every packet will cause a large
performance drop.


> >
> > IMHO we should avoid adding system wide knobs for such specific use-
> > case, especially when the controlled behaviour is against the spec.
> >
> 
> Agreed, this patch looks quite suspect to me.
> 
> We will then add many more knobs for other similar situations.

I think there is a tacit understanding in RFC that can be applied to
most situations.  Challenge ACK assumes a asymmetric routing between
peer vs attacker, but the assumption is not always true, and we have
a situation where RFC 5961 is rather harmful.

There is some knobs to switch on/off RFC behaviour.  We just want to
disable RFC 5961 here.


> Network Load Balancers can be tricky to implement right.
> 
> We should not have to tweak many TCP stacks just because of one implementation.
> 
> Maglev (one of the load balancers used at Google) never asked for a
> modification of a TCP stack.

I'm reading this Maglev paper ( https://research.google/pubs/pub44824/ )
and the notable difference is that our Network Load Balancer does not
support DSR and ensure symmetric routing so that the response can be
filtered based on customer's configuration (of Security Group).

This issue can be caused generally, but I'll leave the explanation to
Jon.


> 
> I think such a change would need IETF discussion and approval first.

CCing Yoshi from TCPM WG, I'm discussing this topic with him.


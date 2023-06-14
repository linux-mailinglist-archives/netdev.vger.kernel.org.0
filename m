Return-Path: <netdev+bounces-10796-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0FF63730579
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 18:53:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BF0AD28148D
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 16:53:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CCA282EC18;
	Wed, 14 Jun 2023 16:53:03 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BACE87F;
	Wed, 14 Jun 2023 16:53:03 +0000 (UTC)
Received: from smtp-fw-80009.amazon.com (smtp-fw-80009.amazon.com [99.78.197.220])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C0CA1BC6;
	Wed, 14 Jun 2023 09:53:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1686761582; x=1718297582;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=eplfOdVA/Gtb1sMFHGiGQO4cWp3IaiH84feaBJgtGc8=;
  b=vTaROZBP2k5WputhhE4s4JzQMQObZ6l8rA87stgxP7t7z++VgEZ9goK1
   iHGjYVHjxl0/VkbkZH7UQGA922bgHQnaD1+cgH6P2eSWQEbU5oAnkd419
   BQKTmSTwQTAX6/BDZF9putnKTloOptdSD7xo0prG9/7nU/LCFA6qbvy0L
   Q=;
X-IronPort-AV: E=Sophos;i="6.00,243,1681171200"; 
   d="scan'208";a="10138159"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-pdx-2b-m6i4x-7fa2de02.us-west-2.amazon.com) ([10.25.36.214])
  by smtp-border-fw-80009.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jun 2023 16:53:00 +0000
Received: from EX19MTAUWC002.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
	by email-inbound-relay-pdx-2b-m6i4x-7fa2de02.us-west-2.amazon.com (Postfix) with ESMTPS id C812240DF5;
	Wed, 14 Jun 2023 16:52:58 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX19MTAUWC002.ant.amazon.com (10.250.64.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Wed, 14 Jun 2023 16:52:56 +0000
Received: from 88665a182662.ant.amazon.com (10.187.170.18) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Wed, 14 Jun 2023 16:52:51 +0000
From: Kuniyuki Iwashima <kuniyu@amazon.com>
To: <lmb@isovalent.com>
CC: <andrii@kernel.org>, <ast@kernel.org>, <bpf@vger.kernel.org>,
	<daniel@iogearbox.net>, <davem@davemloft.net>, <dsahern@kernel.org>,
	<edumazet@google.com>, <haoluo@google.com>, <hemanthmalla@gmail.com>,
	<joe@wand.net.nz>, <john.fastabend@gmail.com>, <jolsa@kernel.org>,
	<kpsingh@kernel.org>, <kuba@kernel.org>, <kuniyu@amazon.com>,
	<linux-kernel@vger.kernel.org>, <linux-kselftest@vger.kernel.org>,
	<martin.lau@linux.dev>, <mykolal@fb.com>, <netdev@vger.kernel.org>,
	<pabeni@redhat.com>, <sdf@google.com>, <shuah@kernel.org>, <song@kernel.org>,
	<willemdebruijn.kernel@gmail.com>, <yhs@fb.com>
Subject: Re: [PATCH bpf-next v2 3/6] net: remove duplicate reuseport_lookup functions
Date: Wed, 14 Jun 2023 09:52:44 -0700
Message-ID: <20230614165244.59782-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <CAN+4W8ijtoew8ouaN3i1NXtg0_G_HHmZyAtf5LsCBb6shCAx2Q@mail.gmail.com>
References: <CAN+4W8ijtoew8ouaN3i1NXtg0_G_HHmZyAtf5LsCBb6shCAx2Q@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.187.170.18]
X-ClientProxiedBy: EX19D046UWB002.ant.amazon.com (10.13.139.181) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
Precedence: Bulk
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
	T_SCC_BODY_TEXT_LINE,T_SPF_PERMERROR autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Lorenz Bauer <lmb@isovalent.com>
Date: Wed, 14 Jun 2023 16:25:05 +0100
> On Tue, Jun 13, 2023 at 7:57 PM Kuniyuki Iwashima <kuniyu@amazon.com> wrote:
> >
> >                         else {
> >                                 result = sk;
> >                         }
> >
> > The assignment to result below is buggy.  Let's say SO_REUSEPROT group
> > have TCP_CLOSE and TCP_ESTABLISHED sockets.
> 
> I'm not very familiar with SO_REUSEPORT, I assumed (incorrectly
> probably) that such a group would only ever have TCP_CLOSE in UDP case
> and TCP_LISTENING in TCP case. Can you explain how I could end up in
> this situation?

When we call conenct() for UDP socket in SO_REUSEPORT group, the state
is changed from TCP_CLOSE to TCP_ESTABLISHED in __ip4_datagram_connect(),
and the socket remains in the group.

That's why we check TCP_ESTABLISHED in reuseport_select_sock_by_hash()
that is always false for TCP but true for UDP in the case above.


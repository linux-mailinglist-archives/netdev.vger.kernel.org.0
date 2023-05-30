Return-Path: <netdev+bounces-6501-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8E473716B30
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 19:34:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2E4C31C20956
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 17:34:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF5CC23C7D;
	Tue, 30 May 2023 17:34:39 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A48DA1F92D
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 17:34:39 +0000 (UTC)
Received: from smtp-fw-80009.amazon.com (smtp-fw-80009.amazon.com [99.78.197.220])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79098C5
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 10:34:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1685468077; x=1717004077;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=+SlefOS06cRo3KwSlLbRtGxcz953jW3t9+Fvxnsk+oc=;
  b=WW2X0sq7LanZ8Ga3lhfNbZpVPW3soH4kWrcSqilavsTaiAG9o2k0VbCd
   97fF69WFnP1tuL2v4+mj53OVRmuSVrkieRpisVDjE+xk0JU/RItxfPRmJ
   ZOhkKIvvGWvYvBX9YgYkaVi4+U4tmCwN2KDq8QDUqIYvEwhiVdNFu5VA9
   Y=;
X-IronPort-AV: E=Sophos;i="6.00,204,1681171200"; 
   d="scan'208";a="6849050"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-pdx-2b-m6i4x-f323d91c.us-west-2.amazon.com) ([10.25.36.214])
  by smtp-border-fw-80009.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 May 2023 17:34:34 +0000
Received: from EX19MTAUWC001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
	by email-inbound-relay-pdx-2b-m6i4x-f323d91c.us-west-2.amazon.com (Postfix) with ESMTPS id 5DBF040D8C;
	Tue, 30 May 2023 17:34:34 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX19MTAUWC001.ant.amazon.com (10.250.64.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Tue, 30 May 2023 17:34:33 +0000
Received: from 88665a182662.ant.amazon.com.com (10.106.101.21) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Tue, 30 May 2023 17:34:30 +0000
From: Kuniyuki Iwashima <kuniyu@amazon.com>
To: <willemdebruijn.kernel@gmail.com>
CC: <davem@davemloft.net>, <dsahern@kernel.org>, <edumazet@google.com>,
	<kuba@kernel.org>, <kuni1840@gmail.com>, <kuniyu@amazon.com>,
	<netdev@vger.kernel.org>, <pabeni@redhat.com>
Subject: Re: [PATCH v1 net-next 00/14] udp: Farewell to UDP-Lite.
Date: Tue, 30 May 2023 10:34:22 -0700
Message-ID: <20230530173422.71583-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <CAF=yD-L88D+vxGcd1u9y07VKW242_macrQ+Q10ZCo_br9z2+ow@mail.gmail.com>
References: <CAF=yD-L88D+vxGcd1u9y07VKW242_macrQ+Q10ZCo_br9z2+ow@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.106.101.21]
X-ClientProxiedBy: EX19D040UWA002.ant.amazon.com (10.13.139.113) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
Precedence: Bulk
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,T_SCC_BODY_TEXT_LINE,T_SPF_PERMERROR
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date: Mon, 29 May 2023 22:15:06 -0400
> On Mon, May 29, 2023 at 9:04 PM Kuniyuki Iwashima <kuniyu@amazon.com> wrote:
> >
> > Recently syzkaller reported a 7-year-old null-ptr-deref [0] that occurs
> > when a UDP-Lite socket tries to allocate a buffer under memory pressure.
> >
> > Someone should have stumbled on the bug much earlier if UDP-Lite had been
> > used in a real app.  Additionally, we do not always need a large UDP-Lite
> > workload to hit the bug since UDP and UDP-Lite share the same memory
> > accounting limit.
> >
> > Given no one uses UDP-Lite, we can drop it and simplify UDP code by
> > removing a bunch of conditionals.
> >
> > This series removes UDP-Lite support from the core networking stack first
> > and incrementally removes the dead code.
> >
> > [0]: https://lore.kernel.org/netdev/20230523163305.66466-1-kuniyu@amazon.com/
> 
> Even if there is high confidence that this protocol is unused, for
> which I'm not sure the above is sufficient proof, it should be
> disabled first and left in place, and removed only when there is no
> chance that it has to be re-enabled.
> 
> We already have code churn here from the split between UDP and
> UDPLite, which was reverted in commit db8dac20d519 ("[UDP]: Revert
> udplite and code split."). This series would be an enormous change to
> revert. And if sufficient time passes in between, there might be ample
> patch conflicts, the fixups of which are sources for subtle bugs.

Thanks Willem, I didn't know someone attempted to disable UDP-Lite.

You may prefer this way.
https://lore.kernel.org/netdev/20230525151011.84390-1-kuniyu@amazon.com/

I'm fine whichever, but the next question will be like how long should we
wait ?  We happen to know that we have already waited for 7 years.


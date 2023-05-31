Return-Path: <netdev+bounces-6648-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0E4767172CF
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 03:01:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9E0E51C20DC0
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 01:01:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 61A2CED2;
	Wed, 31 May 2023 01:01:50 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5096EA2D
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 01:01:50 +0000 (UTC)
Received: from smtp-fw-80009.amazon.com (smtp-fw-80009.amazon.com [99.78.197.220])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94836FC
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 18:01:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1685494908; x=1717030908;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=SOfArmLCjgMEMqU6lpGUodmtwzDKckUkvRvmArZE3es=;
  b=W8i/oxUe6juwVU2JE9W/vMOwGMTtKbQ4pkxHJwmE/PW1VvxjQnnYaQJ1
   R+rtYg4YCf8PFs2w6oEeS0tBiGXXvcV42xHUbj91ZeXLnVyZ4lwJNs0av
   eXBFHHdMLaYHle4/3CvmpZKlDZ4MtsHuxb+bs0ci3n9Z+imzKNet37M7/
   E=;
X-IronPort-AV: E=Sophos;i="6.00,205,1681171200"; 
   d="scan'208";a="6943586"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-pdx-2b-m6i4x-32fb4f1a.us-west-2.amazon.com) ([10.25.36.214])
  by smtp-border-fw-80009.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 May 2023 01:01:46 +0000
Received: from EX19MTAUWB002.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
	by email-inbound-relay-pdx-2b-m6i4x-32fb4f1a.us-west-2.amazon.com (Postfix) with ESMTPS id C7A18CB350;
	Wed, 31 May 2023 01:01:45 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX19MTAUWB002.ant.amazon.com (10.250.64.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Wed, 31 May 2023 01:01:41 +0000
Received: from 88665a182662.ant.amazon.com (10.106.101.21) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Wed, 31 May 2023 01:01:38 +0000
From: Kuniyuki Iwashima <kuniyu@amazon.com>
To: <kuba@kernel.org>
CC: <davem@davemloft.net>, <dsahern@kernel.org>, <edumazet@google.com>,
	<kuni1840@gmail.com>, <kuniyu@amazon.com>, <netdev@vger.kernel.org>,
	<pabeni@redhat.com>, <willemdebruijn.kernel@gmail.com>
Subject: Re: [PATCH v1 net-next 00/14] udp: Farewell to UDP-Lite.
Date: Tue, 30 May 2023 18:01:30 -0700
Message-ID: <20230531010130.43390-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230530151401.621a8498@kernel.org>
References: <20230530151401.621a8498@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.106.101.21]
X-ClientProxiedBy: EX19D032UWA002.ant.amazon.com (10.13.139.81) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
Precedence: Bulk
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,T_SCC_BODY_TEXT_LINE,T_SPF_PERMERROR
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Jakub Kicinski <kuba@kernel.org>
Date: Tue, 30 May 2023 15:14:01 -0700
> On Tue, 30 May 2023 16:16:20 -0400 Willem de Bruijn wrote:
> > Is it a significant burden to keep the protocol, in case anyone is
> > willing to maintain it?
> > 
> > If consensus is that it is time to remove, a warning may not be
> > sufficient for people to notice.
> > 
> > Perhaps break it, but in a way that can be undone trivially,
> > preferably even without recompiling the kernel. Say, returning
> > EOPNOTSUPP on socket creation, unless a sysctl has some magic
> > non-deprecated value. But maybe I'm overthinking it. There must be
> > prior art for this?
> 
> It may be the most intertwined feature we attempted to remove.
> UFO was smaller, right?
> 
> Did deprecation warnings ever work? 
> 
> How about we try to push a WARN_ONCE() on socket creation to net and
> stable? With a message along the lines of "UDP lite is assumed to have
> no users, and is been deleted, please contact netdev@.."
> 
> Then delete the whole thing in net-next? Hopefully pushing to stable
> would expedite user reports? We'll find out if Greg throws rotten fruit
> at us or not..

Yes, if it's ok, it would be better to add a WARN_ONCE() to stable.

If we added it only in net-next, no one might notice it and we could
remove UDP-Lite before the warning is available in the next LTS stable
tree.


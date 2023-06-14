Return-Path: <netdev+bounces-10905-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 48A06730B1B
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 01:01:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EE1F4281418
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 23:01:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3028A1429D;
	Wed, 14 Jun 2023 23:01:27 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A41813ADE
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 23:01:26 +0000 (UTC)
Received: from smtp-fw-2101.amazon.com (smtp-fw-2101.amazon.com [72.21.196.25])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C809211D
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 16:01:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1686783686; x=1718319686;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=UoyOhoNm5LMyq8GE3SEOm6utill003TNi3pzLzEV8WQ=;
  b=KyWgeeAJpIklcdBqmvVp/tmik90uMkNADMZN//fTswDqm65sdWuhsFf4
   LWxI/yZcwPpWCGuOlyZhPbu2Ih8Mii5HyJmBILwejlhu52PWcowx9X1uh
   GTF8QBHpnJ4QBGo6y4ZlBXEMQyNGfocmLPM9u3NZwhWpm0Rnqmg5BZ/mr
   8=;
X-IronPort-AV: E=Sophos;i="6.00,243,1681171200"; 
   d="scan'208";a="334148379"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-iad-1a-m6i4x-9fe6ad2f.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-2101.iad2.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jun 2023 23:01:23 +0000
Received: from EX19MTAUWC002.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
	by email-inbound-relay-iad-1a-m6i4x-9fe6ad2f.us-east-1.amazon.com (Postfix) with ESMTPS id A7CC380966;
	Wed, 14 Jun 2023 23:01:20 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX19MTAUWC002.ant.amazon.com (10.250.64.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Wed, 14 Jun 2023 23:01:20 +0000
Received: from 88665a182662.ant.amazon.com (10.187.170.18) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Wed, 14 Jun 2023 23:01:17 +0000
From: Kuniyuki Iwashima <kuniyu@amazon.com>
To: "David S. Miller" <davem@davemloft.net>, Eric Dumazet
	<edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
	<pabeni@redhat.com>, David Ahern <dsahern@kernel.org>
CC: Kuniyuki Iwashima <kuniyu@amazon.com>, Kuniyuki Iwashima
	<kuni1840@gmail.com>, <netdev@vger.kernel.org>
Subject: [PATCH v1 net-next 0/5] ipv6: Random cleanup for Extension Header.
Date: Wed, 14 Jun 2023 16:01:02 -0700
Message-ID: <20230614230107.22301-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.187.170.18]
X-ClientProxiedBy: EX19D033UWC001.ant.amazon.com (10.13.139.218) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
Precedence: Bulk
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
	T_SCC_BODY_TEXT_LINE,T_SPF_PERMERROR autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

This series (1) cleans up pskb_may_pull() in some functions, where needed
data are already pulled by their caller, (2) removes redundant multicast
test, and (3) optimises reload timing of the header.


Kuniyuki Iwashima (5):
  ipv6: rpl: Remove pskb(_may)?_pull() in ipv6_rpl_srh_rcv().
  ipv6: rpl: Remove redundant multicast tests in ipv6_rpl_srh_rcv().
  ipv6: exthdrs: Replace pskb_pull() with skb_pull() in ipv6_srh_rcv().
  ipv6: exthdrs: Reload hdr only when needed in ipv6_srh_rcv().
  ipv6: exthdrs: Remove redundant skb_headlen() check in
    ip6_parse_tlv().

 include/net/rpl.h  |  3 ---
 net/ipv6/exthdrs.c | 33 +++++----------------------------
 net/ipv6/rpl.c     |  7 -------
 3 files changed, 5 insertions(+), 38 deletions(-)

-- 
2.30.2



Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2D462278BB
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 08:15:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726821AbgGUGPx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 02:15:53 -0400
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:64095 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725294AbgGUGPx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jul 2020 02:15:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1595312152; x=1626848152;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=ziIztNK7+ZkvWB3iPdBmBpcHTX7JFLpHEveWCfGCPHY=;
  b=RT5vNawVkSivcEaY6XuaMwCor0/zktiVuiQ2cJ+69SCjpdOSz1jyUceV
   Doi2YMXoR5UYmBvxv/JTOo1bbU5SazPDLmnB4KN2PzTlZwsU7torlt8CP
   fzN2s33g+q6to5xKrttJMHbZTkO9CUnQUvevXkD+lZ0HfoQBrRfqeWtYC
   0=;
IronPort-SDR: J976QiJbX6T4P5HqJn5uJHxBmDQIdt8dhAoo9plr7qYmMuNTpUYdXtqX++A0NNnL6N15SMURIe
 3ZBj6fIRIyOQ==
X-IronPort-AV: E=Sophos;i="5.75,377,1589241600"; 
   d="scan'208";a="43063925"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-2b-81e76b79.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-2101.iad2.amazon.com with ESMTP; 21 Jul 2020 06:15:51 +0000
Received: from EX13MTAUWA001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan3.pdx.amazon.com [10.170.41.166])
        by email-inbound-relay-2b-81e76b79.us-west-2.amazon.com (Postfix) with ESMTPS id C8685A22D2;
        Tue, 21 Jul 2020 06:15:47 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWA001.ant.amazon.com (10.43.160.118) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 21 Jul 2020 06:15:47 +0000
Received: from 38f9d3582de7.ant.amazon.com.com (10.43.161.34) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 21 Jul 2020 06:15:42 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     "David S . Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        "Jakub Kicinski" <kuba@kernel.org>
CC:     Willem de Bruijn <willemb@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Craig Gallek <kraig@google.com>,
        Paolo Abeni <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        "Kuniyuki Iwashima" <kuni1840@gmail.com>,
        Benjamin Herrenschmidt <benh@amazon.com>,
        <osa-contribution-log@amazon.com>
Subject: [PATCH net 0/2] udp: Fix reuseport selection with connected sockets.
Date:   Tue, 21 Jul 2020 15:15:29 +0900
Message-ID: <20200721061531.94236-1-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.17.2 (Apple Git-113)
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.161.34]
X-ClientProxiedBy: EX13D46UWB001.ant.amazon.com (10.43.161.16) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: kuniyu <kuniyu@amazon.co.jp>

This patch set addresses two issues which happen when both connected and
unconnected sockets are in the same UDP reuseport group.

Kuniyuki Iwashima (2):
  udp: Copy has_conns in reuseport_grow().
  udp: Improve load balancing for SO_REUSEPORT.

 net/core/sock_reuseport.c |  1 +
 net/ipv4/udp.c            | 15 +++++++++------
 net/ipv6/udp.c            | 15 +++++++++------
 3 files changed, 19 insertions(+), 12 deletions(-)

-- 
2.17.2 (Apple Git-113)


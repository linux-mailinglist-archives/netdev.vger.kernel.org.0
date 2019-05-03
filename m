Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E2459130CD
	for <lists+netdev@lfdr.de>; Fri,  3 May 2019 17:01:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727809AbfECPBr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 May 2019 11:01:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51930 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727425AbfECPBr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 3 May 2019 11:01:47 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 03D1FC0753C2;
        Fri,  3 May 2019 15:01:47 +0000 (UTC)
Received: from localhost.localdomain.com (unknown [10.32.181.182])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 328C753E06;
        Fri,  3 May 2019 15:01:46 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 0/4] net: extend indirect calls helper usage
Date:   Fri,  3 May 2019 17:01:35 +0200
Message-Id: <cover.1556889691.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.32]); Fri, 03 May 2019 15:01:47 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series applies the indirect calls helper introduced with commit 
283c16a2dfd3 ("indirect call wrappers: helpers to speed-up indirect 
calls of builtin") to more hooks inside the network stack.

Overall this avoids up to 4 indirect calls for each RX packets,
giving small but measurable gain TCP_RR workloads and 5% under UDP
flood.

Paolo Abeni (4):
  net: use indirect calls helpers for ptype hook
  net: use indirect calls helpers for L3 handler hooks
  net: use indirect calls helpers at early demux stage
  net: use indirect calls helpers at the socket layer

 net/core/dev.c       |  6 ++++--
 net/ipv4/ip_input.c  | 11 +++++++++--
 net/ipv6/ip6_input.c | 12 ++++++++++--
 net/ipv6/tcp_ipv6.c  |  5 +++--
 net/ipv6/udp.c       |  5 +++--
 net/socket.c         | 20 ++++++++++++++++----
 6 files changed, 45 insertions(+), 14 deletions(-)

-- 
2.20.1


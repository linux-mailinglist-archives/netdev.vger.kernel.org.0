Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A78BF3829A
	for <lists+netdev@lfdr.de>; Fri,  7 Jun 2019 04:15:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726819AbfFGCPh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 22:15:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39984 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726305AbfFGCPh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 Jun 2019 22:15:37 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 88B823082E4B;
        Fri,  7 Jun 2019 02:15:37 +0000 (UTC)
Received: from epycfail.redhat.com (ovpn-112-18.ams2.redhat.com [10.36.112.18])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9543A7C5B6;
        Fri,  7 Jun 2019 02:15:33 +0000 (UTC)
From:   Stefano Brivio <sbrivio@redhat.com>
To:     David Miller <davem@davemloft.net>
Cc:     Jianlin Shi <jishi@redhat.com>, Wei Wang <weiwan@google.com>,
        David Ahern <dsahern@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org
Subject: [PATCH net v2 0/2] ipv6: Fix listing and flushing of cached route exceptions
Date:   Fri,  7 Jun 2019 04:14:55 +0200
Message-Id: <cover.1559872578.git.sbrivio@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.46]); Fri, 07 Jun 2019 02:15:37 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The commands 'ip -6 route list cache' and 'ip -6 route flush cache'
don't work at all after route exceptions have been moved to a separate
hash table in commit 2b760fcf5cfb ("ipv6: hook up exception table to store
dst cache"). Fix that.

v2: Add count of routes handled in partial dumps, and skip them, in patch 1/2.

Stefano Brivio (2):
  ipv6: Dump route exceptions too in rt6_dump_route()
  ip6_fib: Don't discard nodes with valid routing information in
    fib6_locate_1()

 include/net/ip6_fib.h   |  1 +
 include/net/ip6_route.h |  2 +-
 net/ipv6/ip6_fib.c      | 27 ++++++++++++-----
 net/ipv6/route.c        | 65 +++++++++++++++++++++++++++++++++++++----
 4 files changed, 80 insertions(+), 15 deletions(-)

-- 
2.20.1


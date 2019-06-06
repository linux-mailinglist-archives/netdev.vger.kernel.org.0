Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 66A7037DE4
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 22:14:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728627AbfFFUOF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 16:14:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38508 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727082AbfFFUOF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 Jun 2019 16:14:05 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 2CF31308421A;
        Thu,  6 Jun 2019 20:14:05 +0000 (UTC)
Received: from epycfail.redhat.com (ovpn-112-18.ams2.redhat.com [10.36.112.18])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0C8D616BF2;
        Thu,  6 Jun 2019 20:14:00 +0000 (UTC)
From:   Stefano Brivio <sbrivio@redhat.com>
To:     David Miller <davem@davemloft.net>
Cc:     Jianlin Shi <jishi@redhat.com>, Wei Wang <weiwan@google.com>,
        David Ahern <dsahern@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org
Subject: [PATCH net 0/2] ipv6: Fix listing and flushing of cached route exceptions
Date:   Thu,  6 Jun 2019 22:13:40 +0200
Message-Id: <cover.1559851514.git.sbrivio@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.40]); Thu, 06 Jun 2019 20:14:05 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The commands 'ip -6 route list cache' and 'ip -6 route flush cache'
don't work at all after route exceptions have been moved to a separate
hash table in commit 2b760fcf5cfb ("ipv6: hook up exception table to store
dst cache"). Fix that.

Stefano Brivio (2):
  ipv6: Dump route exceptions too in rt6_dump_route()
  ip6_fib: Don't discard nodes with valid routing information in
    fib6_locate_1()

 net/ipv6/ip6_fib.c | 10 ++++------
 net/ipv6/route.c   | 38 +++++++++++++++++++++++++++++++++++---
 2 files changed, 39 insertions(+), 9 deletions(-)

-- 
2.20.1


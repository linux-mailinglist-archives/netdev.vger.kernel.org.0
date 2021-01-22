Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF1E42FFEE5
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 10:01:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727135AbhAVI7h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 03:59:37 -0500
Received: from mailout2.hostsharing.net ([83.223.78.233]:37027 "EHLO
        mailout2.hostsharing.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727241AbhAVI7T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jan 2021 03:59:19 -0500
X-Greylist: delayed 632 seconds by postgrey-1.27 at vger.kernel.org; Fri, 22 Jan 2021 03:59:12 EST
Received: from h08.hostsharing.net (h08.hostsharing.net [83.223.95.28])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "*.hostsharing.net", Issuer "RapidSSL TLS DV RSA Mixed SHA256 2020 CA-1" (verified OK))
        by mailout2.hostsharing.net (Postfix) with ESMTPS id 9FA2F10189A1B;
        Fri, 22 Jan 2021 09:47:34 +0100 (CET)
Received: from localhost (unknown [89.246.108.87])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by h08.hostsharing.net (Postfix) with ESMTPSA id 778036017D32;
        Fri, 22 Jan 2021 09:47:34 +0100 (CET)
X-Mailbox-Line: From 012e6863d0103d8dda1932d56427d1b5ba2b9619 Mon Sep 17 00:00:00 2001
Message-Id: <cover.1611304190.git.lukas@wunner.de>
From:   Lukas Wunner <lukas@wunner.de>
Date:   Fri, 22 Jan 2021 09:47:00 +0100
Subject: [PATCH nf-next v4 0/5] Netfilter egress hook
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
To:     "Pablo Neira Ayuso" <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Thomas Graf <tgraf@suug.ch>,
        Laura Garcia Liebana <nevola@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Netfilter egress hook, 4th iteration:

Previously traffic control suffered a performance degradation with this
series applied.  Not anymore, see patch [1/5].

Pablo added netfilter egress handling to af_packet, patch [5/5].

Pablo also moved the netfilter egress hook behind traffic control to
address an objection from Daniel Borkmann, see patch [4/5].  The commit
message was amended with Laura's and Pablo's use cases to make it clear
that the series is no longer motivated by an out-of-tree module.
A bunch of small performance improvements and bugfixes were applied.

Please review and test.  Thanks!

Link to previous version:
https://lore.kernel.org/netfilter-devel/cover.1598517739.git.lukas@wunner.de/


Lukas Wunner (4):
  net: sched: Micro-optimize egress handling
  netfilter: Rename ingress hook include file
  netfilter: Generalize ingress hook include file
  netfilter: Introduce egress hook

Pablo Neira Ayuso (1):
  af_packet: Introduce egress hook

 include/linux/netdevice.h         |   4 ++
 include/linux/netfilter_ingress.h |  58 ----------------
 include/linux/netfilter_netdev.h  | 112 ++++++++++++++++++++++++++++++
 include/uapi/linux/netfilter.h    |   1 +
 net/core/dev.c                    |  16 +++--
 net/netfilter/Kconfig             |   8 +++
 net/netfilter/core.c              |  34 ++++++++-
 net/netfilter/nft_chain_filter.c  |   4 +-
 net/packet/af_packet.c            |  35 ++++++++++
 9 files changed, 206 insertions(+), 66 deletions(-)
 delete mode 100644 include/linux/netfilter_ingress.h
 create mode 100644 include/linux/netfilter_netdev.h

-- 
2.29.2


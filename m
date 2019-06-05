Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93FEE3606C
	for <lists+netdev@lfdr.de>; Wed,  5 Jun 2019 17:40:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728485AbfFEPj7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jun 2019 11:39:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46398 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728241AbfFEPj6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 Jun 2019 11:39:58 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 6EBDDC1EB1EE;
        Wed,  5 Jun 2019 15:39:50 +0000 (UTC)
Received: from localhost.localdomain.com (unknown [10.32.181.77])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CA2F617D4B;
        Wed,  5 Jun 2019 15:39:47 +0000 (UTC)
From:   Davide Caratti <dcaratti@redhat.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Dave Watson <davejwatson@fb.com>,
        Boris Pismenny <borisp@mellanox.com>,
        Aviad Yehezkel <aviadye@mellanox.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org
Subject: [RFC PATCH net-next 0/2] net: extend INET_DIAG_INFO with information specific to TCP ULP
Date:   Wed,  5 Jun 2019 17:39:21 +0200
Message-Id: <cover.1559747691.git.dcaratti@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.32]); Wed, 05 Jun 2019 15:39:58 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The current kernel does not provide any diagnostic tool, except
getsockopt(TCP_ULP), to know more about TCP sockets that have an upper
layer protocol (ULP) on top of them. This series extends the set of
information exported by INET_DIAG_INFO, to include data that are specific
to the ULP (and that might be meaningful for debug/testing purposes).

patch 1/2 extends INET_DIAG_INFO and allows knowing the ULP name for
each TCP socket that has done setsockopt(TCP_ULP) successfully.

kernel TLS is the only TCP ULP user at the moment: patch 2/2 extends kTLS
to let programs like 'ss' know the protocol version and the cipher in use.

Davide Caratti (2):
  tcp: ulp: add functions to dump ulp-specific information
  net: tls: export protocol version and cipher to socket diag

 include/net/tcp.h              |  3 +++
 include/uapi/linux/inet_diag.h |  9 +++++++
 include/uapi/linux/tls.h       |  8 +++++++
 net/ipv4/tcp_diag.c            | 34 +++++++++++++++++++++++++--
 net/tls/tls_main.c             | 43 ++++++++++++++++++++++++++++++++++
 5 files changed, 95 insertions(+), 2 deletions(-)

-- 
2.20.1


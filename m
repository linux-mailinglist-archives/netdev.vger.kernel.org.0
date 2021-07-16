Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1E2A3CB66C
	for <lists+netdev@lfdr.de>; Fri, 16 Jul 2021 12:54:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232146AbhGPK5V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Jul 2021 06:57:21 -0400
Received: from novek.ru ([213.148.174.62]:42354 "EHLO novek.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231880AbhGPK5U (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Jul 2021 06:57:20 -0400
Received: from nat1.ooonet.ru (gw.zelenaya.net [91.207.137.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by novek.ru (Postfix) with ESMTPSA id 1429050030A;
        Fri, 16 Jul 2021 13:52:05 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 novek.ru 1429050030A
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=novek.ru; s=mail;
        t=1626432726; bh=tm9yU/BljWD6hu9WtZ1TCgeB/JvGwt9BIEWMshOsThI=;
        h=From:To:Cc:Subject:Date:From;
        b=SgbpfFWLO5Wnk4iKe26XRjFf8i/LOwiM3gIL/1sqYzrG5WY3h5bTLix7iuSYMLG9S
         9WXOg5SNRITbkfKF9subt4voSFKXDFU7Y154bbR4HdVpF17BU7eQgXOOOvq3z5nl7Q
         f539S38NBze4btwNclvpN9bs0cUEIuVeamS+h6W4=
From:   Vadim Fedorenko <vfedorenko@novek.ru>
To:     David Ahern <dsahern@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Xin Long <lucien.xin@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Vadim Fedorenko <vfedorenko@novek.ru>
Subject: [PATCH net v2 0/2] Fix PMTU for ESP-in-UDP encapsulation
Date:   Fri, 16 Jul 2021 13:54:15 +0300
Message-Id: <20210716105417.7938-1-vfedorenko@novek.ru>
X-Mailer: git-send-email 2.18.4
X-Spam-Status: No, score=0.0 required=5.0 tests=UNPARSEABLE_RELAY
        autolearn=ham autolearn_force=no version=3.4.1
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on gate.novek.ru
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Bug 213669 uncovered regression in PMTU discovery for UDP-encapsulated
routes and some incorrect usage in udp tunnel fields. This series fixes
problems and also adds such case for selftests

v2:
 - remove refactor code that was in first patch
 - move checking logic to __udp{4,6}_lib_err_encap
 - add more tests, especially routed configuration

Vadim Fedorenko (2):
  udp: check encap socket in __udp_lib_err_encap
  selftests: net: add ESP-in-UDP PMTU test

 net/ipv4/udp.c                        |  23 ++-
 net/ipv6/udp.c                        |  23 ++-
 tools/testing/selftests/net/nettest.c |  55 ++++++-
 tools/testing/selftests/net/pmtu.sh   | 212 +++++++++++++++++++++++++-
 4 files changed, 294 insertions(+), 19 deletions(-)

-- 
2.18.4


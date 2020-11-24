Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EF8A2C2B35
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 16:25:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389690AbgKXPZN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 10:25:13 -0500
Received: from novek.ru ([213.148.174.62]:47198 "EHLO novek.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389434AbgKXPZN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Nov 2020 10:25:13 -0500
Received: from nat1.ooonet.ru (gw.zelenaya.net [91.207.137.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by novek.ru (Postfix) with ESMTPSA id 1A3125030A7;
        Tue, 24 Nov 2020 18:25:24 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 novek.ru 1A3125030A7
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=novek.ru; s=mail;
        t=1606231525; bh=mO+bX/215FkY07mOamMQiBMBu8TNVFK/UNvxc7Ptm8Q=;
        h=From:To:Cc:Subject:Date:From;
        b=Osok2aHXwuCEYE8k6Ee0FpzIhEGVQiKN3ylTsmQy/5489KL71pWfhoEbhNM6FQAlC
         vfoly82GE2bMV9/B317XuY0N4xTQ46rrNgoZEc8Un1G1vtnR0BSdqOr6vDxpZ+3m2C
         uxBuAIRi1HPG81mko9S92fTQ4+eBvc9GmSO+f4aI=
From:   Vadim Fedorenko <vfedorenko@novek.ru>
To:     Jakub Kicinski <kuba@kernel.org>,
        Boris Pismenny <borisp@nvidia.com>,
        Aviad Yehezkel <aviadye@nvidia.com>
Cc:     Vadim Fedorenko <vfedorenko@novek.ru>, netdev@vger.kernel.org,
        linux-crypto@vger.kernel.org
Subject: [net-next v2 0/5] Add CHACHA20-POLY1305 cipher to Kernel TLS
Date:   Tue, 24 Nov 2020 18:24:45 +0300
Message-Id: <1606231490-653-1-git-send-email-vfedorenko@novek.ru>
X-Mailer: git-send-email 1.8.3.1
X-Spam-Status: No, score=0.0 required=5.0 tests=UNPARSEABLE_RELAY
        autolearn=ham autolearn_force=no version=3.4.1
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on gate.novek.ru
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RFC 7905 defines usage of ChaCha20-Poly1305 in TLS connections. This
cipher is widely used nowadays and it's good to have a support for it
in TLS connections in kernel.
Changes v2: 
  nit fixes suggested by Jakub Kicinski
  add linux-crypto to review patch set

Vadim Fedorenko (5):
  net/tls: make inline helpers protocol-aware
  net/tls: add CHACHA20-POLY1305 specific defines and structures
  net/tls: add CHACHA20-POLY1305 specific behavior
  net/tls: add CHACHA20-POLY1305 configuration
  selftests/tls: add CHACHA20-POLY1305 to tls selftests

 include/net/tls.h                 | 32 ++++++++++++++++---------------
 include/uapi/linux/tls.h          | 15 +++++++++++++++
 net/tls/tls_device.c              |  2 +-
 net/tls/tls_device_fallback.c     | 13 +++++++------
 net/tls/tls_main.c                |  3 +++
 net/tls/tls_sw.c                  | 34 ++++++++++++++++++++++++---------
 tools/testing/selftests/net/tls.c | 40 ++++++++++++++++++++++++++++++++-------
 7 files changed, 101 insertions(+), 38 deletions(-)

-- 
1.8.3.1


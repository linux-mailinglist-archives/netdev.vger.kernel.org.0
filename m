Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 468991BE964
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 22:59:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727027AbgD2U7e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 16:59:34 -0400
Received: from mail.zx2c4.com ([192.95.5.64]:36243 "EHLO mail.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726775AbgD2U7e (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Apr 2020 16:59:34 -0400
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 30266848;
        Wed, 29 Apr 2020 20:47:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=from:to:cc
        :subject:date:message-id:mime-version:content-type
        :content-transfer-encoding; s=mail; bh=8mtmtUizDv2sIv17mb1xjpp1z
        zI=; b=ys3G3im96+bJUZ3uIFMWxe8dWnYWGwItltwHc2o1lmXNF7P1Ih1ziaq8J
        zjcP3wMx3rA1uwOSmOVz8etdY+E58ERSkI4IcDQEHB02nqWLsFRv9Z1IyjcBPKp1
        Blll+ulWUXkxbBLJ6gemH8aBm8/edkoXVtd17hdCToKWEfgWnOCpJ/KJUy81q0S5
        STBDdUp+n3vEwTpIgkdGppE2bcIsrXZJEv1DCNI/Bo+6h2+j1WdXt4fpVlRORleb
        TEZQOYWo5BnYva85ur1dQRrzwU8JRV0gb4zZlsA+UOyQAUdpD3ltupTsfxCUUo6K
        iBPJm9JpWOmSoGasmCdrXtx6ktkHg==
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 841b67e5 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Wed, 29 Apr 2020 20:47:41 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH net 0/3] wireguard fixes for 5.7-rc4
Date:   Wed, 29 Apr 2020 14:59:19 -0600
Message-Id: <20200429205922.295361-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave,

This series contains two fixes and a cleanup for wireguard:

1) Removal of a spurious newline, from Sultan Alsawaf.

2) Fix for a memory leak in an error path, in which memory allocated
   prior to the error wasn't freed, reported by Sultan Alsawaf.

3) Fix to ECN support to use RFC6040 properly like all the other tunnel
   drivers, from Toke Høiland-Jørgensen.

Thanks,
Jason


Jason A. Donenfeld (1):
  wireguard: queueing: cleanup ptr_ring in error path of
    packet_queue_init

Sultan Alsawaf (1):
  wireguard: send: remove errant newline from packet_encrypt_worker

Toke Høiland-Jørgensen (1):
  wireguard: receive: use tunnel helpers for decapsulating ECN markings

 drivers/net/wireguard/queueing.c | 4 +++-
 drivers/net/wireguard/receive.c  | 6 ++----
 drivers/net/wireguard/send.c     | 1 -
 3 files changed, 5 insertions(+), 6 deletions(-)

-- 
2.26.2


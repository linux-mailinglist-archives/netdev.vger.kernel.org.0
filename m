Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E5983F4BEC
	for <lists+netdev@lfdr.de>; Mon, 23 Aug 2021 15:54:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230314AbhHWNy3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Aug 2021 09:54:29 -0400
Received: from bee.birch.relay.mailchannels.net ([23.83.209.14]:51773 "EHLO
        bee.birch.relay.mailchannels.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230135AbhHWNyW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Aug 2021 09:54:22 -0400
X-Sender-Id: 9wt3zsp42r|x-authuser|john.efstathiades@pebblebay.com
Received: from relay.mailchannels.net (localhost [127.0.0.1])
        by relay.mailchannels.net (Postfix) with ESMTP id 645CD542F3A;
        Mon, 23 Aug 2021 13:53:33 +0000 (UTC)
Received: from ares.krystal.co.uk (100-96-18-119.trex-nlb.outbound.svc.cluster.local [100.96.18.119])
        (Authenticated sender: 9wt3zsp42r)
        by relay.mailchannels.net (Postfix) with ESMTPA id 13082543738;
        Mon, 23 Aug 2021 13:53:31 +0000 (UTC)
X-Sender-Id: 9wt3zsp42r|x-authuser|john.efstathiades@pebblebay.com
Received: from ares.krystal.co.uk (ares.krystal.co.uk [77.72.0.130])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384)
        by 100.96.18.119 (trex/6.3.3);
        Mon, 23 Aug 2021 13:53:33 +0000
X-MC-Relay: Neutral
X-MailChannels-SenderId: 9wt3zsp42r|x-authuser|john.efstathiades@pebblebay.com
X-MailChannels-Auth-Id: 9wt3zsp42r
X-Attack-Occur: 7a16826c45adf95c_1629726813036_751361437
X-MC-Loop-Signature: 1629726813036:3265790798
X-MC-Ingress-Time: 1629726813035
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=pebblebay.com; s=default; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=8KBzZy8UzyP0bIQsUpdtMKz8/p3OJzJF5WE0TD2X2y0=; b=0VrsTHTgtZh7GFOzu4vgzOpKAJ
        nWxmMR8Mzqy7glD6dlDlzOPd1qz2pGIphMBqR3t0o8lUFCuDrT/W/wmhJs1CUKRti2YA02p4BLN59
        4A38tzzh+5UOc3L/B7S2nDy3qbkVIYVs7E7qjDNNB5SxJWtlm4PxTyiCj/eMQ0rq7elf0oStBUf7m
        bLXdM7NjlotGnXc6IQBi8AHMMVdkKkQr09NJgnO1JWdH2h+M8I7Z71Bs6I0zr151/qeYcUKfGdgvH
        uodHHKuLh6GwrdFleLg+dAC1/ylnPiC97GZnZBNlgCPdT3NwxcjUTk/lO6vBLn5e7Um6SkIb5NWTM
        DmDuuYHA==;
Received: from cpc160185-warw19-2-0-cust743.3-2.cable.virginm.net ([82.21.62.232]:51812 helo=pbcl-dsk9.pebblebay.com)
        by ares.krystal.co.uk with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <john.efstathiades@pebblebay.com>)
        id 1mIAOI-003PzY-4K; Mon, 23 Aug 2021 14:53:29 +0100
From:   John Efstathiades <john.efstathiades@pebblebay.com>
Cc:     UNGLinuxDriver@microchip.com, woojung.huh@microchip.com,
        davem@davemloft.net, netdev@vger.kernel.org,
        john.efstathiades@pebblebay.com
Subject: [PATCH net-next 00/10] LAN7800 driver improvements
Date:   Mon, 23 Aug 2021 14:52:19 +0100
Message-Id: <20210823135229.36581-1-john.efstathiades@pebblebay.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-AuthUser: john.efstathiades@pebblebay.com
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch set introduces a number of improvements and fixes for
problems found during testing of a modification to add a NAPI-style
approach to packet handling to improve performance.

NOTE: the NAPI changes are not part of this patch set and the issues
      fixed by this patch set are not coupled to the NAPI changes.

Patch 1 fixes white space and style issues.

Patch 2 removes an unused timer.

Patch 3 introduces macros to set the internal packet FIFO flow
control levels, which makes it easier to update the levels in future.

Patch 4 removes an unused queue.

Patch 5 stops the device initiating USB link power management state
transitions that can introduce a packet transmit latency with some
USB 3 hosts and hubs.

Patch 6 updates the LAN7800 MAC reset code to ensure there is no
PHY register access in progress when the MAC is reset. This change
prevents a kernel exception that can otherwise occur.

Patch 7 fixes problems with system suspend and resume handling while
the device is transmitting and receiving data.

Patch 8 fixes problems with auto-suspend and resume handling and
depends on changes introduced by patch 7.

Patch 9 fixes problems with device disconnect handling that can result
in kernel exceptions and/or hang.

Patch 10 limits the rate at which driver warning messages are emitted.

John Efstathiades (10):
  lan78xx: Fix white space and style issues
  lan78xx: Remove unused timer
  lan78xx: Set flow control threshold to prevent packet loss
  lan78xx: Remove unused pause frame queue
  lan78xx: Disable USB3 link power state transitions
  lan78xx: Fix exception on link speed change
  lan78xx: Fix partial packet errors on suspend/resume
  lan78xx: Fix race conditions in suspend/resume handling
  lan78xx: Fix race condition in disconnect handling
  lan78xx: Limit number of driver warning messages

 drivers/net/usb/lan78xx.c | 1074 +++++++++++++++++++++++++++++--------
 1 file changed, 846 insertions(+), 228 deletions(-)

-- 
2.25.1


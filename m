Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E0CD204EA3
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 12:00:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732135AbgFWJ76 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 05:59:58 -0400
Received: from mail.zx2c4.com ([192.95.5.64]:42093 "EHLO mail.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731947AbgFWJ75 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Jun 2020 05:59:57 -0400
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 3e0fa82c;
        Tue, 23 Jun 2020 09:41:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=from:to:cc
        :subject:date:message-id:mime-version:content-transfer-encoding;
         s=mail; bh=tJHSsa/WpyLQZvunBAmuYEMzU5U=; b=gydD8o1Qtxgk9mxyZCuP
        t3TJBGMsdb0SMB2iK0tsuU/fZ647/EpDSKVElXA1uzBHNuMPF814s76Qa1xa4pCU
        NahsuHxFFLiAnextUEsjB+D54/ps7qP09cSRlEMrRXpEaFLFnd97CxrgplyHdtF2
        D/bfgM/+YhlsWHXm/NG432T1K9S/qfKPLrdBgz1VuoHedn92Xzyt8Nb9aLWFSyxN
        ygj3JlZ/epzosCypxqDfKUtiJmGgIFuvP3rnJKR3alCJ6JS8hsad7GXs4CmxdnXw
        QKt4WCHXTu/aNXEFks+C3Bp0ALW9i67yiojHQPoqnxXGY7HekzmgxAm7PNrm+zK5
        mQ==
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 40f83448 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Tue, 23 Jun 2020 09:41:04 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH net 0/2] wireguard fixes for 5.8-rc3
Date:   Tue, 23 Jun 2020 03:59:43 -0600
Message-Id: <20200623095945.1402468-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave,

This series contains two fixes, one cosmetic and one quite important:

1) Avoid the `if ((x = f()) == y)` pattern, from Frank
   Werner-Krippendorf.

2) Mitigate a potential memory leak by creating circular netns
   references, while also making the netns semantics a bit more
   robust.

Patch (2) has a "Fixes:" line and should be backported to stable.

Thanks,
Jason


Frank Werner-Krippendorf (1):
  wireguard: noise: do not assign initiation time in if condition

Jason A. Donenfeld (1):
  wireguard: device: avoid circular netns references

 drivers/net/wireguard/device.c             | 58 ++++++++++------------
 drivers/net/wireguard/device.h             |  3 +-
 drivers/net/wireguard/netlink.c            | 14 ++++--
 drivers/net/wireguard/noise.c              |  4 +-
 drivers/net/wireguard/socket.c             | 25 +++++++---
 tools/testing/selftests/wireguard/netns.sh | 13 ++++-
 6 files changed, 69 insertions(+), 48 deletions(-)

-- 
2.27.0


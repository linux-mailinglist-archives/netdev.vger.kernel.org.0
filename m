Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 899AE1521C7
	for <lists+netdev@lfdr.de>; Tue,  4 Feb 2020 22:17:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727555AbgBDVRq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Feb 2020 16:17:46 -0500
Received: from frisell.zx2c4.com ([192.95.5.64]:54783 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727500AbgBDVRq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 4 Feb 2020 16:17:46 -0500
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 9b68b99a;
        Tue, 4 Feb 2020 21:16:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=from:to:cc
        :subject:date:message-id:mime-version:content-transfer-encoding;
         s=mail; bh=eQPYhbDiQsejzANkYB9cpBh/noo=; b=nggcYAtYYXkAZDMlE7RO
        OLjZd/kiRtLreH0gxuBCx127UTnXfJ2hSnwL/oEMTZ3PrApxbP12R+6Ffx/zNuzB
        QYBIdgbpCkMvfEwNLSI2ZvnOLuA1sYpsLSO+r6YPXKFTe+T/GROsEEgSHSJ6LShR
        8bN5yOwwqiOhbAzdUS+GF6bLvmbDHFot+V/Mi88S5sPefqICmwwjmgdkr1cVAe93
        VcbZ6gDewLyDZ7qw90hsjlnyQQ/I+cCEXGYHelmIrkJsDYFBHNFbXpnqaNW+AZeu
        CuT88yuqqj4rS4W7/dnGKxHLCj+36cmEhIDzLfXlj+d27yWesZRBiI2F6CA+axaF
        Zw==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id fdbc0595 (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO);
        Tue, 4 Feb 2020 21:16:53 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH net 0/5] wireguard fixes for 5.6-rc1
Date:   Tue,  4 Feb 2020 22:17:24 +0100
Message-Id: <20200204211729.365431-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave,

Here are fixes for WireGuard before 5.6-rc1 is tagged. It includes:

1) A fix for a UaF (caused by kmalloc failing during a very small
   allocation) that syzkaller found, from Eric Dumazet.

2) A fix for a deadlock that syzkaller found, along with an additional
   selftest to ensure that the bug fix remains correct, from me.

3) Two little fixes/cleanups to the selftests from Krzysztof Kozlowski
   and me.

Thanks,
Jason


Eric Dumazet (1):
  wireguard: allowedips: fix use-after-free in root_remove_peer_lists

Jason A. Donenfeld (3):
  wireguard: noise: reject peers with low order public keys
  wireguard: selftests: ensure non-addition of peers with failed
    precomputation
  wireguard: selftests: tie socket waiting to target pid

Krzysztof Kozlowski (1):
  wireguard: selftests: cleanup CONFIG_ENABLE_WARN_DEPRECATED

 drivers/net/wireguard/allowedips.c            |  1 +
 drivers/net/wireguard/netlink.c               |  6 ++---
 drivers/net/wireguard/noise.c                 | 10 +++++---
 tools/testing/selftests/wireguard/netns.sh    | 23 +++++++++++--------
 .../selftests/wireguard/qemu/debug.config     |  1 -
 5 files changed, 24 insertions(+), 17 deletions(-)

-- 
2.25.0


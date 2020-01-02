Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 909C412E8E6
	for <lists+netdev@lfdr.de>; Thu,  2 Jan 2020 17:47:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728864AbgABQr4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jan 2020 11:47:56 -0500
Received: from frisell.zx2c4.com ([192.95.5.64]:39917 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728795AbgABQrz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 Jan 2020 11:47:55 -0500
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 79356afe;
        Thu, 2 Jan 2020 15:49:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=from:to:cc
        :subject:date:message-id:mime-version:content-transfer-encoding;
         s=mail; bh=p1rkLRS8iqQZ7lUXVYusVpRdY5Y=; b=KhvU5+M/5cVxlaMt8ETX
        QzB3fo1r7ecC0g6HW43yY6rmVy4HmZwwWu+lyx9VzYo9tkmGKWjNDLiRaX32Mj4f
        Nw8gh232Ir83jJq+MXMAPmRLdtDpR3uFbUQ4OnQdDI9tfpzS0oOo1ClosprPXc4i
        AHwsUBNHxDK1P6I3stbCNGg2IeCJ+0KtZbsw6SBKuAY3Zl+nrMjrBBL17nxHfTZE
        wiYm0eENL3S3mbR7bCrNx0RwlfnqOhvMrgh4h4+xm2mPYoovoY44gB/ENbdXpXs3
        3zyZsQOah3kX6/67rvrev0n8Kc9VznfQ9LVymyVUSba5x8CycUgh15TDQ8iEteAZ
        OQ==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 0866deab (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO);
        Thu, 2 Jan 2020 15:49:22 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH net-next 0/3] WireGuard bug fixes and cleanups
Date:   Thu,  2 Jan 2020 17:47:48 +0100
Message-Id: <20200102164751.416922-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I've been working through some personal notes and also the whole git
repo history of the out-of-tree module, looking for places where
tradeoffs were made (and subsequently forgotten about) for old kernels.
The first two patches in this series clean up those. The first one does
so in the self-tests and self-test harness, where we're now able to
expand test coverage by a bit, and we're now cooking away tests on every
commit to both the wireguard-linux repo and to net-next. The second one
removes a workaround for a skbuff.h bug that was fixed long ago.
Finally, the last patch in the series fixes in a bug unearthed by newer
Qualcomm chipsets running the rmnet_perf driver, which does UDP GRO.

Jason A. Donenfeld (3):
  wireguard: selftests: remove ancient kernel compatibility code
  wireguard: queueing: do not account for pfmemalloc when clearing skb
    header
  wireguard: socket: mark skbs as not on list when receiving via gro

 drivers/net/wireguard/queueing.h              |  3 -
 drivers/net/wireguard/socket.c                |  1 +
 tools/testing/selftests/wireguard/netns.sh    | 11 +--
 .../testing/selftests/wireguard/qemu/Makefile | 82 ++++++++++---------
 .../selftests/wireguard/qemu/arch/m68k.config |  2 +-
 tools/testing/selftests/wireguard/qemu/init.c |  1 +
 .../selftests/wireguard/qemu/kernel.config    |  2 +
 7 files changed, 51 insertions(+), 51 deletions(-)

-- 
2.24.1


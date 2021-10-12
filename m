Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AB7442A914
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 18:06:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230056AbhJLQIl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 12:08:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:52730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229629AbhJLQIk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Oct 2021 12:08:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CD9586101D;
        Tue, 12 Oct 2021 16:06:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634054799;
        bh=qJKPcRk2vIQGwaLgPIFkr2eL2bxMRxvWc00UNQXProg=;
        h=From:To:Cc:Subject:Date:From;
        b=qzo+TxTaBYK+8S+5p+ZBAXnRFXpnZ9HZcBO1FdaQ3SNpWNK0lmj/lyChiYBWF6hrR
         9kssKFGSkHOKoNcPmHM/dDsIM9c+X+n+TaQDau4zHwZJC8A0B5arXtaMNW4vuAJ9Dd
         PxvZpMflPi/7qt61DxMTtXbKnjt072ed9OOBQYNio9OILhHi0PFAFKGsJMmOkaBiFs
         oTh0u1PgM8+df+HWquzO/BCzHooPd/xOZkTalxSC/63mQcLkKFJy4uQAZT4D5WH1I+
         60EqmjoXGCDjw8l6wbpResnhwmL5z+GF4HtDJ4rGbc4BzvhghVXxZDSY4A6x8SlaEq
         G5eEDCDXZ0syA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 0/3] net: use dev_addr_set() in hamradio and ip tunnels
Date:   Tue, 12 Oct 2021 09:06:31 -0700
Message-Id: <20211012160634.4152690-1-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 406f42fa0d3c ("net-next: When a bond have a massive amount 
of VLANs...") introduced a rbtree for faster Ethernet address look
up. To maintain netdev->dev_addr in this tree we need to make all
the writes to it got through appropriate helpers.

Jakub Kicinski (3):
  netdevice: demote the type of some dev_addr_set() helpers
  hamradio: use dev_addr_set() for setting device address
  ip: use dev_addr_set() in tunnels

 drivers/net/hamradio/6pack.c      | 6 +++---
 drivers/net/hamradio/baycom_epp.c | 2 +-
 drivers/net/hamradio/bpqether.c   | 5 ++---
 drivers/net/hamradio/dmascc.c     | 2 +-
 drivers/net/hamradio/hdlcdrv.c    | 2 +-
 drivers/net/hamradio/mkiss.c      | 6 +++---
 drivers/net/hamradio/scc.c        | 5 ++---
 drivers/net/hamradio/yam.c        | 2 +-
 include/linux/netdevice.h         | 4 ++--
 net/ipv4/ip_gre.c                 | 2 +-
 net/ipv4/ip_tunnel.c              | 2 +-
 net/ipv4/ip_vti.c                 | 2 +-
 net/ipv4/ipip.c                   | 2 +-
 net/ipv6/ip6_gre.c                | 4 ++--
 net/ipv6/ip6_tunnel.c             | 2 +-
 net/ipv6/ip6_vti.c                | 2 +-
 net/ipv6/sit.c                    | 4 ++--
 17 files changed, 26 insertions(+), 28 deletions(-)

-- 
2.31.1


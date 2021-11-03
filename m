Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4177844490D
	for <lists+netdev@lfdr.de>; Wed,  3 Nov 2021 20:38:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230380AbhKCTlG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Nov 2021 15:41:06 -0400
Received: from todd.t-8ch.de ([159.69.126.157]:58401 "EHLO todd.t-8ch.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229918AbhKCTlG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Nov 2021 15:41:06 -0400
From:   =?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=weissschuh.net;
        s=mail; t=1635968308;
        bh=F7/IqXfrZtyQ8NW8rysMnKtrgiVYUxBlS6M/A2Yg+4k=;
        h=From:To:Cc:Subject:Date:From;
        b=VNiMoSp6ylT3mDXyPfrQtncCFOmKtCeB+EOnyRasaVPfN6fidBD0XzW7NsLyLA1Zd
         wn7v6SSdCkWEMffw23ksshCVOUke2Io+47sSdtUtDMBTc2bCMXLqjDELqh9UDWk2OB
         hzYwGIYcd6HyNK02dFXeRkepQtfUi6PDKDq5caRU=
To:     v9fs-developer@lists.sourceforge.net, netdev@vger.kernel.org
Cc:     =?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
        Dominique Martinet <asmadeus@codewreck.org>,
        Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Stefano Stabellini <stefano@aporeto.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/4] net/9p: optimize transport module loading
Date:   Wed,  3 Nov 2021 20:38:19 +0100
Message-Id: <20211103193823.111007-1-linux@weissschuh.net>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a continuation of the single patch
"net/9p: autoload transport modules".

Patch 1 is a cleaned up version of the original patch.

Patch 2 splits the filedescriptor-based transports into their own module.

Patch 3 adds autoloading for the xen transport. Please note that this is
completely untested, but other xenbus drivers do the same.

Patch 4 adds some fallback transport loading from modules if none is usable at
the moment.

Changes since v1:
( https://lore.kernel.org/netdev/20211017134611.4330-1-linux@weissschuh.net/ )

* Fix warnings
* Split FD transport into its own module
* Autoload xen transport when xenbus device is present
* Load transports from modules when none is specified and loaded

Thomas Weißschuh (4):
  net/9p: autoload transport modules
  9p/trans_fd: split into dedicated module
  9p/xen: autoload when xenbus service is available
  net/p9: load default transports

 include/net/9p/9p.h        |  2 --
 include/net/9p/transport.h |  8 +++++++-
 net/9p/Kconfig             |  7 +++++++
 net/9p/Makefile            |  5 ++++-
 net/9p/mod.c               | 41 ++++++++++++++++++++++++++++++--------
 net/9p/trans_fd.c          | 14 +++++++++++--
 net/9p/trans_rdma.c        |  1 +
 net/9p/trans_virtio.c      |  1 +
 net/9p/trans_xen.c         |  2 ++
 9 files changed, 67 insertions(+), 14 deletions(-)


base-commit: cc0356d6a02e064387c16a83cb96fe43ef33181e
-- 
2.33.1


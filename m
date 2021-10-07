Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCB6C4253F8
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 15:25:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241261AbhJGN1O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 09:27:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:35866 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232869AbhJGN1N (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Oct 2021 09:27:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 16A2960E74;
        Thu,  7 Oct 2021 13:25:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633613120;
        bh=L2bO7FcBSJu/DBiCZD6fRblQBoU3A8dIBZ41b3D2p5E=;
        h=From:To:Cc:Subject:Date:From;
        b=tJh8t+U1PJYuPmtCVjKaCdXuUe/M9qGv64j3eNvnb0UZxnQm17edvTBFe3vGI6Nf4
         0yhKEldveuiMy+FvEx/+RfmaYCs4+D08wFuVvRuf7NXiPZ2rOGfbSt+i2Rn4LS+S2y
         6D9G587fWR141jEP+I8eloyQESy+V0+YFN3So//gWbLTq2DQL8TwhzcrefZK83ofC4
         1u0wOE0H5NUbjm7jLpYc+jeYVOzkjHLLkWMjO1hrUzd5Q4I2gFq7reTm2bTaWEipU5
         17ORYbM8Klg47v+dsFOV2T7xJGmBS7rULVkNnxfI5jE9SOwsnNY8266fO+3wuyUTeB
         2bPuohTo0bZ8g==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, vladimir.oltean@nxp.com, michael@walle.cc,
        andrew@lunn.ch, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 0/3] net: add a helpers for loading netdev->dev_addr from platform
Date:   Thu,  7 Oct 2021 06:25:08 -0700
Message-Id: <20211007132511.3462291-1-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Similarly to recently added device_get_ethdev_address()
and of_get_ethdev_address() create a helper for drivers
loading mac addr from platform data.

nvmem_get_mac_address() does not have driver callers
so instead of adding a helper there unexport it.

Jakub Kicinski (3):
  ethernet: un-export nvmem_get_mac_address()
  eth: platform: add a helper for loading netdev->dev_addr
  ethernet: use platform_get_ethdev_address()

 drivers/net/ethernet/actions/owl-emac.c       |  2 +-
 drivers/net/ethernet/mediatek/mtk_star_emac.c |  2 +-
 drivers/net/usb/smsc75xx.c                    |  3 +--
 drivers/net/usb/smsc95xx.c                    |  3 +--
 include/linux/etherdevice.h                   |  1 +
 net/ethernet/eth.c                            | 21 ++++++++++++++++++-
 6 files changed, 25 insertions(+), 7 deletions(-)

-- 
2.31.1


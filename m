Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF567425A87
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 20:19:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243557AbhJGSUu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 14:20:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:51496 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243507AbhJGSUt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Oct 2021 14:20:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BB64260F4C;
        Thu,  7 Oct 2021 18:18:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633630735;
        bh=L2bO7FcBSJu/DBiCZD6fRblQBoU3A8dIBZ41b3D2p5E=;
        h=From:To:Cc:Subject:Date:From;
        b=n+bF0fYRlGSvU0MGaFgz/T7qDtsMCNJ0ddUKhZOkQBRg1ykFd8iAPpuYo9EVUmYkT
         gwwYIQK2OSM4EuPWDxpCxEtW6xfZkPH9V07mZAHmkJqZ3Aesh6FLbKAOwOZFV6ir/Z
         eg4LAAs7uavqhadmfx+Oq5xMniW6RCtLHdhUzWOFRmKYB0s/h8+k0LVdMzbWe+gaf1
         4yvLABci0mdE3+xKGSCRETFf8Yc5LUtGlqK5IKLlUyFt/Jb1CoZ3yCLGBwT4KSSxPk
         mogKFAFUF+fMA56tO73cVj8oRL0gK2Dt/mq4D0GyI2qleOPVo7ZoPL6uY3jkQH8HNJ
         dojtniVxkeJrw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, vladimir.oltean@nxp.com, michael@walle.cc,
        andrew@lunn.ch, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v2 0/3] net: add a helpers for loading netdev->dev_addr from platform
Date:   Thu,  7 Oct 2021 11:18:44 -0700
Message-Id: <20211007181847.3529859-1-kuba@kernel.org>
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


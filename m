Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1731CE2656
	for <lists+netdev@lfdr.de>; Thu, 24 Oct 2019 00:23:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436672AbfJWWXq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Oct 2019 18:23:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:54266 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2407859AbfJWWXq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Oct 2019 18:23:46 -0400
Received: from lore-desk.lan (unknown [151.66.11.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 77BF22173B;
        Wed, 23 Oct 2019 22:23:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571869425;
        bh=vlpVZYvaUE1VTVX3xNbH1XFQzcYBGlvDDimEJavMs7Q=;
        h=From:To:Cc:Subject:Date:From;
        b=a0RQrO7uQMbl1YJAk4yto+/yIEVkW8iXZAO9gSN505iwNEfPi89F10AumMQjIYdm2
         wrvLGl6yhlM99pON3NPDAC/CBDAgFE9mJgKdPYKE47arTb0u7lGA7UgIO5M2ZkLHcy
         h8R/KW9dqvtZPY787nM5MFcu/SecWnrKbGwMovNw=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org, nbd@nbd.name, sgruszka@redhat.com,
        lorenzo.bianconi@redhat.com, oleksandr@natalenko.name,
        netdev@vger.kernel.org
Subject: [PATCH wireless-drivers 0/2] fix mt76x2e hangs on U7612E mini-pcie
Date:   Thu, 24 Oct 2019 00:23:14 +0200
Message-Id: <cover.1571868221.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Various mt76x2e issues have been reported on U7612E mini-pcie card [1].
On U7612E-H1 PCIE_ASPM causes continuous mcu hangs and instability and
so patch 1/2 disable it by default.
Moreover mt76 does not properly unmap dma buffers for non-linear skbs.
This issue may result in hw hangs if the system relies on IOMMU.
Patch 2/2 fix the problem properly unmapping data fragments on
non-linear skbs. 

[1]: https://lore.kernel.org/netdev/deaafa7a3e9ea2111ebb5106430849c6@natalenko.name/

Lorenzo Bianconi (2):
  mt76: mt76x2e: disable pcie_aspm by default
  mt76: dma: fix buffer unmap with non-linear skbs

 drivers/net/wireless/mediatek/mt76/dma.c      | 10 ++--
 drivers/net/wireless/mediatek/mt76/mmio.c     | 47 +++++++++++++++++++
 drivers/net/wireless/mediatek/mt76/mt76.h     |  1 +
 .../net/wireless/mediatek/mt76/mt76x2/pci.c   |  2 +
 4 files changed, 57 insertions(+), 3 deletions(-)

-- 
2.21.0


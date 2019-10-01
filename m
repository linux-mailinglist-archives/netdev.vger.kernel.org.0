Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 89F7CC301E
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 11:25:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728848AbfJAJYy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 05:24:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:49046 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727473AbfJAJYy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Oct 2019 05:24:54 -0400
Received: from localhost.localdomain.com (nat-pool-mxp-t.redhat.com [149.6.153.186])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8395F2133F;
        Tue,  1 Oct 2019 09:24:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569921893;
        bh=i5lhRccWlSPxayGVX22AQkN1hLdu+7dQ4eTbYlu2Zsc=;
        h=From:To:Cc:Subject:Date:From;
        b=CXO644EWM9iMGVfBcaL8923GT3IEXc95vqMwlTCiO26U4RnHgH0goEoTrmdyWKOC9
         ukBroyeb/u7eJAHwjAX0ubby5XNEMVfiyIqSBWoJzF19Zr40alxJ7PpnJQyGnQEkt9
         ZRFZSmbM5xvGbz0W2FKpC/jfQPLtUDgap9m6fO5g=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     thomas.petazzoni@bootlin.com, ilias.apalodimas@linaro.org,
        brouer@redhat.com, mcroce@redhat.com
Subject: [RFC 0/4] add basic XDP support to mvneta driver
Date:   Tue,  1 Oct 2019 11:24:40 +0200
Message-Id: <cover.1569920973.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add basic XDP support to mvneta driver for devices that rely on software
buffer management. Currently supported verdicts are:
- XDP_DROP
- XDP_PASS
- XDP_REDIRECT

Convert mvneta driver to page_pool API.
This series is based on previous work done by Jesper and Ilias.
I am currently working on XDP_TX verdict and I will add it before
posting a formal series

Lorenzo Bianconi (4):
  net: mvneta: introduce page pool API for sw buffer manager
  net: mvneta: rely on build_skb in mvneta_rx_swbm poll routine
  net: mvneta: add basic XDP support
  net: mvneta: move header prefetch in mvneta_swbm_rx_frame

 drivers/net/ethernet/marvell/Kconfig  |   1 +
 drivers/net/ethernet/marvell/mvneta.c | 383 ++++++++++++++++++--------
 2 files changed, 270 insertions(+), 114 deletions(-)

-- 
2.21.0


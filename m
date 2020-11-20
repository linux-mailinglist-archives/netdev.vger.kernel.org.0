Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC6DD2BB128
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 18:07:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728060AbgKTRGO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 12:06:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:56864 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727788AbgKTRGO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Nov 2020 12:06:14 -0500
Received: from lore-desk.redhat.com (unknown [151.66.8.153])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0993F2078B;
        Fri, 20 Nov 2020 17:06:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605891973;
        bh=up85eYAWugNdFQC6ERzloRCZoOxF93EKe+EnPdjGtTY=;
        h=From:To:Cc:Subject:Date:From;
        b=a0OoR6Ys6FXS6dQx54Yg5xm4UvBbY0+bSblFEs3xFgB9C5IPZe4GchDWG8w+D/rFA
         E9KGRJ6hRmNT8Mc7GTbFxB0yQRLkgQFUyy0EqLBHoOZWzQ31cLe3BfyIi5zBWYWJ3a
         i4Vn1/frULFqsd4+iqqtayIWE/jPfUXUnd8H7KYc=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        brouer@redhat.com, echaudro@redhat.com, john.fastabend@gmail.com
Subject: [PATCH net-next 0/3] mvneta: access skb_shared_info only on last frag
Date:   Fri, 20 Nov 2020 18:05:41 +0100
Message-Id: <cover.1605889258.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Build skb_shared_info on mvneta_rx_swbm stack and sync it to xdp_buff
skb_shared_info area only on the last fragment.
Avoid avoid unnecessary xdp_buff initialization in mvneta_rx_swbm routine.
This a preliminary series to complete xdp multi-buff in mvneta driver.

Lorenzo Bianconi (3):
  net: mvneta: avoid unnecessary xdp_buff initialization
  net: mvneta: move skb_shared_info in mvneta_xdp_put_buff
  net: mvneta: alloc skb_shared_info on the mvneta_rx_swbm stack

 drivers/net/ethernet/marvell/mvneta.c | 55 +++++++++++++++++----------
 1 file changed, 35 insertions(+), 20 deletions(-)

-- 
2.26.2


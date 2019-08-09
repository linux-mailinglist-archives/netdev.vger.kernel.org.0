Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E35F187A06
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 14:31:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406909AbfHIMbf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 08:31:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:57992 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406901AbfHIMbd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Aug 2019 08:31:33 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8829C217F5;
        Fri,  9 Aug 2019 12:31:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565353892;
        bh=dsEU41ZjboX8wiCrbr7wPmTyqRM39fWwxhY2724+fZY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Bl3vgSmoKi9r2wrC3ViVDbNebdWSj0nOUdV/z79fpjz7qUj1woqXC2GoIJRMKbmrP
         o04g/bcESOTFQUX/Wy/8Fbdl4HL3LHp34Dclp5yD+1QrSWlA1VZ5tsynayMwI2gXiu
         E0ct3ckr1GXd50nEb4AVbd94JK4u6J4CHd5+ghf0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     netdev@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        intel-wired-lan@lists.osuosl.org
Subject: [PATCH v2 14/17] fm10k: no need to check return value of debugfs_create functions
Date:   Fri,  9 Aug 2019 14:31:05 +0200
Message-Id: <20190809123108.27065-15-gregkh@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190809123108.27065-1-gregkh@linuxfoundation.org>
References: <20190809123108.27065-1-gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When calling debugfs functions, there is no need to ever check the
return value.  The function can work or not, but the code logic should
never do something different based on this.

Cc: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: intel-wired-lan@lists.osuosl.org
Cc: netdev@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/intel/fm10k/fm10k_debugfs.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/fm10k/fm10k_debugfs.c b/drivers/net/ethernet/intel/fm10k/fm10k_debugfs.c
index dca104121c05..1d27b2fb23af 100644
--- a/drivers/net/ethernet/intel/fm10k/fm10k_debugfs.c
+++ b/drivers/net/ethernet/intel/fm10k/fm10k_debugfs.c
@@ -160,8 +160,6 @@ void fm10k_dbg_q_vector_init(struct fm10k_q_vector *q_vector)
 	snprintf(name, sizeof(name), "q_vector.%03d", q_vector->v_idx);
 
 	q_vector->dbg_q_vector = debugfs_create_dir(name, interface->dbg_intfc);
-	if (!q_vector->dbg_q_vector)
-		return;
 
 	/* Generate a file for each rx ring in the q_vector */
 	for (i = 0; i < q_vector->tx.count; i++) {
-- 
2.22.0


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F0442C28BD
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 14:53:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388675AbgKXNxU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 08:53:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388659AbgKXNxO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Nov 2020 08:53:14 -0500
X-Greylist: delayed 530 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 24 Nov 2020 05:53:14 PST
Received: from simonwunderlich.de (packetmixer.de [IPv6:2001:4d88:2000:24::c0de])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CD24C0613D6
        for <netdev@vger.kernel.org>; Tue, 24 Nov 2020 05:53:14 -0800 (PST)
Received: from kero.packetmixer.de (p200300c59720c9e082fbfcd64a8e5ba3.dip0.t-ipconnect.de [IPv6:2003:c5:9720:c9e0:82fb:fcd6:4a8e:5ba3])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by simonwunderlich.de (Postfix) with ESMTPSA id 4107B174060;
        Tue, 24 Nov 2020 14:44:19 +0100 (CET)
From:   Simon Wunderlich <sw@simonwunderlich.de>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, b.a.t.m.a.n@lists.open-mesh.org,
        Taehee Yoo <ap420073@gmail.com>,
        Sven Eckelmann <sven@narfation.org>,
        Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 1/1] batman-adv: set .owner to THIS_MODULE
Date:   Tue, 24 Nov 2020 14:44:17 +0100
Message-Id: <20201124134417.17269-2-sw@simonwunderlich.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201124134417.17269-1-sw@simonwunderlich.de>
References: <20201124134417.17269-1-sw@simonwunderlich.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Taehee Yoo <ap420073@gmail.com>

If THIS_MODULE is not set, the module would be removed while debugfs is
being used.
It eventually makes kernel panic.

Fixes: c6c8fea29769 ("net: Add batman-adv meshing protocol")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
---
 net/batman-adv/log.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/batman-adv/log.c b/net/batman-adv/log.c
index a67b2b091447..c0ca5fbe5b08 100644
--- a/net/batman-adv/log.c
+++ b/net/batman-adv/log.c
@@ -180,6 +180,7 @@ static const struct file_operations batadv_log_fops = {
 	.read           = batadv_log_read,
 	.poll           = batadv_log_poll,
 	.llseek         = no_llseek,
+	.owner          = THIS_MODULE,
 };
 
 /**
-- 
2.20.1


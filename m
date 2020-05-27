Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BFFC1E4118
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 14:01:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726787AbgE0MBg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 08:01:36 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:57892 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725775AbgE0MBf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 08:01:35 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1jdukT-0003EU-NN; Wed, 27 May 2020 12:01:29 +0000
From:   Colin King <colin.king@canonical.com>
To:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net: dsa: b53: remove redundant premature assignment to new_pvid
Date:   Wed, 27 May 2020 13:01:29 +0100
Message-Id: <20200527120129.172676-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Variable new_pvid is being assigned with a value that is never read,
the following if statement updates new_pvid with a new value in both
of the if paths. The assignment is redundant and can be removed.

Addresses-Coverity: ("Unused value")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/dsa/b53/b53_common.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index ceb8be653182..1df05841ab6b 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -1325,7 +1325,6 @@ int b53_vlan_filtering(struct dsa_switch *ds, int port, bool vlan_filtering)
 	u16 pvid, new_pvid;
 
 	b53_read16(dev, B53_VLAN_PAGE, B53_VLAN_PORT_DEF_TAG(port), &pvid);
-	new_pvid = pvid;
 	if (!vlan_filtering) {
 		/* Filtering is currently enabled, use the default PVID since
 		 * the bridge does not expect tagging anymore
-- 
2.25.1


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D212247D4B3
	for <lists+netdev@lfdr.de>; Wed, 22 Dec 2021 16:59:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343948AbhLVP6z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Dec 2021 10:58:55 -0500
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:51831 "EHLO
        relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343803AbhLVP6V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Dec 2021 10:58:21 -0500
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by relay4-d.mail.gandi.net (Postfix) with ESMTPSA id D1A7BE0012;
        Wed, 22 Dec 2021 15:58:18 +0000 (UTC)
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan@vger.kernel.org
Cc:     David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        netdev@vger.kernel.org,
        Romuald Despres <Romuald.Despres@qorvo.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [wpan-tools 1/7] iwpan: Fix the channels printing
Date:   Wed, 22 Dec 2021 16:58:10 +0100
Message-Id: <20211222155816.256405-2-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20211222155816.256405-1-miquel.raynal@bootlin.com>
References: <20211222155816.256405-1-miquel.raynal@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Romuald Despres <Romuald.Despres@qorvo.com>

The presence of a channel capability is checked against the tb_msg
netlink attributes array which is the root one, while here we are
looking for channel capabilities, themselves being nested and parsed
into tb_caps. Use tb_caps instead of tb_msg here otherwise we are
accessing a random index in the upper attributes list.

Signed-off-by: Romuald Despres <Romuald.Despres@qorvo.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
---
 src/info.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/info.c b/src/info.c
index f85690c..8ed5e4f 100644
--- a/src/info.c
+++ b/src/info.c
@@ -342,7 +342,7 @@ static int print_phy_handler(struct nl_msg *msg, void *arg)
 			printf("\b \n");
 		}
 
-		if (tb_msg[NL802154_CAP_ATTR_CHANNELS]) {
+		if (tb_caps[NL802154_CAP_ATTR_CHANNELS]) {
 			int counter = 0;
 			int rem_pages;
 			struct nlattr *nl_pages;
-- 
2.27.0


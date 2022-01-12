Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A82A48C9C5
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 18:36:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241457AbiALRft (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 12:35:49 -0500
Received: from relay6-d.mail.gandi.net ([217.70.183.198]:48013 "EHLO
        relay6-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355696AbiALRff (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 12:35:35 -0500
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by relay6-d.mail.gandi.net (Postfix) with ESMTPSA id A48B9C0005;
        Wed, 12 Jan 2022 17:35:32 +0000 (UTC)
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        linux-wireless@vger.kernel.org,
        Romuald Despres <Romuald.Despres@qorvo.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [wpan-tools v2 1/7] iwpan: Fix the channels printing
Date:   Wed, 12 Jan 2022 18:35:23 +0100
Message-Id: <20220112173529.765170-2-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220112173529.765170-1-miquel.raynal@bootlin.com>
References: <20220112173529.765170-1-miquel.raynal@bootlin.com>
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


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A325134CED0
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 13:24:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231693AbhC2LYc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 07:24:32 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:60214 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232164AbhC2LYB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Mar 2021 07:24:01 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1lQpzu-0001Ua-9L; Mon, 29 Mar 2021 11:23:54 +0000
From:   Colin King <colin.king@canonical.com>
To:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-wpan@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ieee802154: hwsim: remove redundant initialization of variable res
Date:   Mon, 29 Mar 2021 12:23:54 +0100
Message-Id: <20210329112354.87503-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The variable res is being initialized with a value that is
never read and it is being updated later with a new value.
The initialization is redundant and can be removed.

Addresses-Coverity: ("Unused value")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/ieee802154/mac802154_hwsim.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ieee802154/mac802154_hwsim.c b/drivers/net/ieee802154/mac802154_hwsim.c
index c0bf7d78276e..da9135231c07 100644
--- a/drivers/net/ieee802154/mac802154_hwsim.c
+++ b/drivers/net/ieee802154/mac802154_hwsim.c
@@ -268,7 +268,7 @@ static int hwsim_get_radio(struct sk_buff *skb, struct hwsim_phy *phy,
 			   struct netlink_callback *cb, int flags)
 {
 	void *hdr;
-	int res = -EMSGSIZE;
+	int res;
 
 	hdr = genlmsg_put(skb, portid, seq, &hwsim_genl_family, flags,
 			  MAC802154_HWSIM_CMD_GET_RADIO);
-- 
2.30.2


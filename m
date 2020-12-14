Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95D832D975E
	for <lists+netdev@lfdr.de>; Mon, 14 Dec 2020 12:32:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437287AbgLNLbs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 06:31:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2407656AbgLNLbf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Dec 2020 06:31:35 -0500
X-Greylist: delayed 534 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 14 Dec 2020 03:30:54 PST
Received: from sym2.noone.org (sym2.noone.org [IPv6:2a01:4f8:120:4161::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEFF2C0613D6
        for <netdev@vger.kernel.org>; Mon, 14 Dec 2020 03:30:54 -0800 (PST)
Received: by sym2.noone.org (Postfix, from userid 1002)
        id 4Cvf9f0qjczvjlg; Mon, 14 Dec 2020 12:21:57 +0100 (CET)
From:   Tobias Klauser <tklauser@distanz.ch>
To:     Jiri Pirko <jiri@nvidia.com>
Cc:     Moshe Shemesh <moshe@mellanox.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH] devlink: use _BITUL() macro instead of BIT() in the UAPI header
Date:   Mon, 14 Dec 2020 12:21:57 +0100
Message-Id: <20201214112157.4841-1-tklauser@distanz.ch>
X-Mailer: git-send-email 2.11.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The BIT() macro is not available for the UAPI headers. Moreover, it can
be defined differently in user space headers. Thus, replace its usage
with the _BITUL() macro which is already used in other macro definitions
in <linux/devlink.h>.

Fixes: dc64cc7c6310 ("devlink: Add devlink reload limit option")
Signed-off-by: Tobias Klauser <tklauser@distanz.ch>
---
 include/uapi/linux/devlink.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
index 5203f54a2be1..cf89c318f2ac 100644
--- a/include/uapi/linux/devlink.h
+++ b/include/uapi/linux/devlink.h
@@ -322,7 +322,7 @@ enum devlink_reload_limit {
 	DEVLINK_RELOAD_LIMIT_MAX = __DEVLINK_RELOAD_LIMIT_MAX - 1
 };
 
-#define DEVLINK_RELOAD_LIMITS_VALID_MASK (BIT(__DEVLINK_RELOAD_LIMIT_MAX) - 1)
+#define DEVLINK_RELOAD_LIMITS_VALID_MASK (_BITUL(__DEVLINK_RELOAD_LIMIT_MAX) - 1)
 
 enum devlink_attr {
 	/* don't change the order or add anything between, this is ABI! */
-- 
2.27.0


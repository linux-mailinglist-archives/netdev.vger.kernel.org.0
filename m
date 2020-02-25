Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D207016BF08
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 11:45:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730389AbgBYKpk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 05:45:40 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:33186 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730378AbgBYKpg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Feb 2020 05:45:36 -0500
Received: by mail-wr1-f65.google.com with SMTP id u6so14157648wrt.0
        for <netdev@vger.kernel.org>; Tue, 25 Feb 2020 02:45:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zHMa5uRfXauRxVZHxXo1hn0OuQImAgMVG7rq6bvn8lE=;
        b=xW8RloKA5icTHVx4p7Un1LETk8CG8nSsX9ySaRneq4P/1jXmtk4awTPYkrtJj1WWkJ
         mVlTqOLxtM70KXdqnGQFLSNGcMgVO++mEA/Wxt85Sbp1yO43W6PvMQoj5VOoyqbD7+CN
         qkniuUYAsm/S0QzunfZMya5VDrtYbHeLzeXPNpyJhp+TsTrwg7K+0LHhc9bbFVEUW2Xh
         e8k29+JUCB7OcUE7LyH2y1owrAeFCcWQuULJeHQaniAQ/a2mXD4jY/859OO1oOEiTdWr
         68z2eIAtJ2p+gCUTx7QUnNRBBiPM+rUwA6nzjOKP9+Q+Pz/9/QmGsVKkerkzpFdCZq8N
         I3eQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zHMa5uRfXauRxVZHxXo1hn0OuQImAgMVG7rq6bvn8lE=;
        b=HZ5/5NZGccG+Xhp/jWxozdE+D4Ecvk2TRbGS1ZSqm539w8dhEoDVluLWJ2llokBMFU
         9DY71/OpuPUyuojc9T0PIv8viDEXR7uX2DiBztURZToMVlOeKXKyHpHl7M8FeGs+hwHe
         EYxQjlG/1uUGv1GtKIOnzqrkY+B/lBz8sd0pcOClhD+9JAQ+zu6V3HK8nx2u4wBjUg4j
         e7/jfraN3gFWE6iDcP8uoWI21dRzLZU8stNBmlx8nRPwTAGMKyANlofltlU9c+uNMguq
         P5xy4OimsnMXNECRDOA8xxUEG1R+dawhaASq/pBVOJVRSRehqF3j6tj7PWwHb8PXipE7
         iCrQ==
X-Gm-Message-State: APjAAAX6FLMRECTjJkYHvk47aBQnO+eOukPWRmeohO2uawAX30zlMEgg
        0Cy+TicGZnnV9xjUT60vUmFnpXFt7Kk=
X-Google-Smtp-Source: APXvYqzIbEpUUx7MYono2jb+XvEPAsoUBTLxIVbdCcHfgW2snhFlowMbK36AM06ZQ7Im/Y1KN+gVGg==
X-Received: by 2002:a5d:6344:: with SMTP id b4mr21120186wrw.224.1582627534967;
        Tue, 25 Feb 2020 02:45:34 -0800 (PST)
Received: from localhost (ip-89-177-130-96.net.upcbroadband.cz. [89.177.130.96])
        by smtp.gmail.com with ESMTPSA id v16sm3528583wml.11.2020.02.25.02.45.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Feb 2020 02:45:34 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, nhorman@tuxdriver.com,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, idosch@mellanox.com,
        mlxsw@mellanox.com
Subject: [patch net-next v2 05/10] mlxsw: core_acl_flex_actions: Add trap with userdef action
Date:   Tue, 25 Feb 2020 11:45:22 +0100
Message-Id: <20200225104527.2849-6-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20200225104527.2849-1-jiri@resnulli.us>
References: <20200225104527.2849-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

Expose "Trap action with userdef". It is the same as already
defined "Trap action" with a difference that it would ask the policy
engine to pass arbitrary value (userdef) alongside with received packets.
This would be later on used to carry cookie index.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 .../mellanox/mlxsw/core_acl_flex_actions.c    | 30 +++++++++++++++++--
 1 file changed, 28 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_actions.c b/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_actions.c
index 424ef26e6cca..b7a846dd8f32 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_actions.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_actions.c
@@ -747,18 +747,25 @@ int mlxsw_afa_block_append_vlan_modify(struct mlxsw_afa_block *block,
 }
 EXPORT_SYMBOL(mlxsw_afa_block_append_vlan_modify);
 
-/* Trap Action
- * -----------
+/* Trap Action / Trap With Userdef Action
+ * --------------------------------------
  * The Trap action enables trapping / mirroring packets to the CPU
  * as well as discarding packets.
  * The ACL Trap / Discard separates the forward/discard control from CPU
  * trap control. In addition, the Trap / Discard action enables activating
  * SPAN (port mirroring).
+ *
+ * The Trap with userdef action action has the same functionality as
+ * the Trap action with addition of user defined value that can be set
+ * and used by higher layer applications.
  */
 
 #define MLXSW_AFA_TRAP_CODE 0x03
 #define MLXSW_AFA_TRAP_SIZE 1
 
+#define MLXSW_AFA_TRAPWU_CODE 0x04
+#define MLXSW_AFA_TRAPWU_SIZE 2
+
 enum mlxsw_afa_trap_trap_action {
 	MLXSW_AFA_TRAP_TRAP_ACTION_NOP = 0,
 	MLXSW_AFA_TRAP_TRAP_ACTION_TRAP = 2,
@@ -794,6 +801,15 @@ MLXSW_ITEM32(afa, trap, mirror_agent, 0x08, 29, 3);
  */
 MLXSW_ITEM32(afa, trap, mirror_enable, 0x08, 24, 1);
 
+/* user_def_val
+ * Value for the SW usage. Can be used to pass information of which
+ * rule has caused a trap. This may be overwritten by later traps.
+ * This field does a set on the packet's user_def_val only if this
+ * is the first trap_id or if the trap_id has replaced the previous
+ * packet's trap_id.
+ */
+MLXSW_ITEM32(afa, trap, user_def_val, 0x0C, 0, 20);
+
 static inline void
 mlxsw_afa_trap_pack(char *payload,
 		    enum mlxsw_afa_trap_trap_action trap_action,
@@ -805,6 +821,16 @@ mlxsw_afa_trap_pack(char *payload,
 	mlxsw_afa_trap_trap_id_set(payload, trap_id);
 }
 
+static inline void
+mlxsw_afa_trapwu_pack(char *payload,
+		      enum mlxsw_afa_trap_trap_action trap_action,
+		      enum mlxsw_afa_trap_forward_action forward_action,
+		      u16 trap_id, u32 user_def_val)
+{
+	mlxsw_afa_trap_pack(payload, trap_action, forward_action, trap_id);
+	mlxsw_afa_trap_user_def_val_set(payload, user_def_val);
+}
+
 static inline void
 mlxsw_afa_trap_mirror_pack(char *payload, bool mirror_enable,
 			   u8 mirror_agent)
-- 
2.21.1


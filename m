Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E2E5716B187
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 22:08:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727932AbgBXVIK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 16:08:10 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:43574 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727891AbgBXVII (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 16:08:08 -0500
Received: by mail-wr1-f67.google.com with SMTP id r11so12105690wrq.10
        for <netdev@vger.kernel.org>; Mon, 24 Feb 2020 13:08:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zHMa5uRfXauRxVZHxXo1hn0OuQImAgMVG7rq6bvn8lE=;
        b=ne6Ixy3BkYtmZf/cpVH0FHisd0jTTMwWAyr9ov/Mo9SlVkwzv0VRjS7NJD6aWz/ftm
         sncKL0oLGyl7PxEzXk+6SJEbf8BYn+RIB5RytPVWaU6f9DsYXZseBjFhstCRfSONjtMM
         3QNiGb3os8Zenk9gN2zQCjOvHRF0qIcn/SzT7SyOaYcy67qAuMBCT+C/1tsERZHjLZsE
         FUlZoCdWPaGQt2+zHN5U7SaTCPyjBLgUT7AiuVFMqC4qrW3iOOVfwFbO/c7i/0ria/Tu
         HiMQkqZdEczXg691JeLnLSvTQqHRk5Jar5OtPDJ/iw0LSABJ/xO3O1WHjqMJ5pobvCeO
         43Qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zHMa5uRfXauRxVZHxXo1hn0OuQImAgMVG7rq6bvn8lE=;
        b=piJcSCYG7zfRdsB9220xOr1UrBzqJFADzJqFJh+cfsX2VL7tf1acmWT9NdUMBmm+e0
         Wy2n4C3+q7487wtvolXNM04JpFkdDvD+y5qd/s6dOGqne6XD+wGh/w7esknQh2kQrbt1
         W4zAXFMCHsYzd32eNmy9qr0YUHgL/MExNhYM2b+8d5erqOWkZGQo5TNuBLeaqCMNAvYs
         H9K2yhQ92O9WJkXxKBBfGvOYPtQMi6DRNLG4th1ZYsnUFM86ugtULAROpWNtErVbJanw
         4fVCob8Zec2fsut0S/loAcZIPXnVvFK4Yqchw/wcz1BESPiTB2EkWWufEy0pi4TwcpFC
         vgFA==
X-Gm-Message-State: APjAAAU8OO7w2zNUdU6BN8CEJLoET3Yhig9t7Tdf455VPIC4e0U/foQZ
        AHeZFn4f7FS8V+Jm8q6SXholH57Hy2A=
X-Google-Smtp-Source: APXvYqwP+GdZRXZYkwGvVsIQ03n4m6pN5dcLwvC30L+Rj4pG2h66udKkAszNqC8LGo/vbJxHGmg6dw==
X-Received: by 2002:a5d:410e:: with SMTP id l14mr65582179wrp.238.1582578486511;
        Mon, 24 Feb 2020 13:08:06 -0800 (PST)
Received: from localhost (ip-89-177-130-96.net.upcbroadband.cz. [89.177.130.96])
        by smtp.gmail.com with ESMTPSA id t131sm944894wmb.13.2020.02.24.13.08.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Feb 2020 13:08:06 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, nhorman@tuxdriver.com,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, idosch@mellanox.com,
        mlxsw@mellanox.com
Subject: [patch net-next 05/10] mlxsw: core_acl_flex_actions: Add trap with userdef action
Date:   Mon, 24 Feb 2020 22:07:53 +0100
Message-Id: <20200224210758.18481-6-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20200224210758.18481-1-jiri@resnulli.us>
References: <20200224210758.18481-1-jiri@resnulli.us>
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


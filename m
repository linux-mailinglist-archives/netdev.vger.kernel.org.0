Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 66CFA1696A1
	for <lists+netdev@lfdr.de>; Sun, 23 Feb 2020 08:32:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727221AbgBWHcC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Feb 2020 02:32:02 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:34131 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727166AbgBWHb5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Feb 2020 02:31:57 -0500
Received: by mail-wr1-f65.google.com with SMTP id n10so6694701wrm.1
        for <netdev@vger.kernel.org>; Sat, 22 Feb 2020 23:31:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=UYqYR89l8BFIJtR9mul68iSWj4t0DjjeF40zV1Ja8sU=;
        b=2LxeY4/sIl1NSjsBaoY9UtZZ97C8eW+SXmzgavXz3kMaC3WYyDKf6x82cRp7o+gbq9
         gzKGhOGkb9zBNmWYLm4uHyGQ3LjwsXHLEK7Pfge1SwkRCGipU1TWLHtIRSPZzE7j/Tgm
         +MF1pm3p49yiNOKXOgZkB8LcEjot80xDHlHy6vlj8BGOYsK454+0vdp3JamF1l7zcD12
         5vEog+XpPds6SOPIroU+NbxNfZalH/4gv3vkc/a8o6weh5cGX/WLw38CWg97pzx/XxL/
         YmStKl5wlr4N9bY1mh4hxm5SeqldHCxUzFrHu1VjV/XM+NqQCrw13tURMQwUpMZLnsMo
         nqcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UYqYR89l8BFIJtR9mul68iSWj4t0DjjeF40zV1Ja8sU=;
        b=PyRCAPEZpa83dgNo16aU5aKfnyn2AJhkbMTG8dWVFn2uP9DqjSo/rV7HzjaKrqXtt6
         O73ZV+Hw2cXtaJaGFczXg5NTTlnIYjD5VAC98hd2h5DRjpizXXkDo1l10+PUQTuUWTbQ
         l1atRykuFyoLZsgCOyrx8uyai3o0HnyAMWEEFTX75vOJVb16feajQJDYrVQsAPhaRzPf
         V7z1CsUCCABYQurgcZzYk1/jR7DNTvh0yyRhi00YkcJ33O6VrwJ5Xl+66/39mBYh6aKC
         XdXW9Ps/Up5OaCn6XYxKleN1Mhp47XTIpqIkq4fGJBkDBkL78NC4Kr0MCqQ1nXuyRCV1
         p1zg==
X-Gm-Message-State: APjAAAVmxFiOd+dZDLgxDePh3m1oudpJy8xj4H78hqF9zK2yvkdvkSxK
        pjCNkcYK3IqgbpEPWRF9Lnqb7H/RpOw=
X-Google-Smtp-Source: APXvYqyzkix0LFUbFvBGZWqtymOXzVb0oZIZa/SVeyEACR5xSVWE9MqFf9zCLFGPGYePdJT1t9xRWQ==
X-Received: by 2002:adf:eec3:: with SMTP id a3mr55865404wrp.337.1582443115995;
        Sat, 22 Feb 2020 23:31:55 -0800 (PST)
Received: from localhost (ip-89-177-130-96.net.upcbroadband.cz. [89.177.130.96])
        by smtp.gmail.com with ESMTPSA id s23sm12298665wra.15.2020.02.22.23.31.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 22 Feb 2020 23:31:55 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, idosch@mellanox.com,
        mlxsw@mellanox.com
Subject: [patch net-next 09/12] mlxsw: spectrum_trap: Make global arrays const as they should be
Date:   Sun, 23 Feb 2020 08:31:41 +0100
Message-Id: <20200223073144.28529-10-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20200223073144.28529-1-jiri@resnulli.us>
References: <20200223073144.28529-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

The global arrays are treated as const, they should be const, so make
them const.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
index 871bd609b0c9..2f2ddc751f3d 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
@@ -125,7 +125,7 @@ static void mlxsw_sp_rx_exception_listener(struct sk_buff *skb, u8 local_port,
 	MLXSW_RXL(mlxsw_sp_rx_exception_listener, _id,			      \
 		   _action, false, SP_##_group_id, DISCARD)
 
-static struct devlink_trap mlxsw_sp_traps_arr[] = {
+static const struct devlink_trap mlxsw_sp_traps_arr[] = {
 	MLXSW_SP_TRAP_DROP(SMAC_MC, L2_DROPS),
 	MLXSW_SP_TRAP_DROP(VLAN_TAG_MISMATCH, L2_DROPS),
 	MLXSW_SP_TRAP_DROP(INGRESS_VLAN_FILTER, L2_DROPS),
@@ -156,7 +156,7 @@ static struct devlink_trap mlxsw_sp_traps_arr[] = {
 	MLXSW_SP_TRAP_DROP(OVERLAY_SMAC_MC, TUNNEL_DROPS),
 };
 
-static struct mlxsw_listener mlxsw_sp_listeners_arr[] = {
+static const struct mlxsw_listener mlxsw_sp_listeners_arr[] = {
 	MLXSW_SP_RXL_DISCARD(ING_PACKET_SMAC_MC, L2_DISCARDS),
 	MLXSW_SP_RXL_DISCARD(ING_SWITCH_VTAG_ALLOW, L2_DISCARDS),
 	MLXSW_SP_RXL_DISCARD(ING_SWITCH_VLAN, L2_DISCARDS),
@@ -201,7 +201,7 @@ static struct mlxsw_listener mlxsw_sp_listeners_arr[] = {
  * be mapped to the same devlink trap. Order is according to
  * 'mlxsw_sp_listeners_arr'.
  */
-static u16 mlxsw_sp_listener_devlink_map[] = {
+static const u16 mlxsw_sp_listener_devlink_map[] = {
 	DEVLINK_TRAP_GENERIC_ID_SMAC_MC,
 	DEVLINK_TRAP_GENERIC_ID_VLAN_TAG_MISMATCH,
 	DEVLINK_TRAP_GENERIC_ID_INGRESS_VLAN_FILTER,
@@ -280,7 +280,7 @@ int mlxsw_sp_trap_init(struct mlxsw_core *mlxsw_core,
 	int i;
 
 	for (i = 0; i < ARRAY_SIZE(mlxsw_sp_listener_devlink_map); i++) {
-		struct mlxsw_listener *listener;
+		const struct mlxsw_listener *listener;
 		int err;
 
 		if (mlxsw_sp_listener_devlink_map[i] != trap->id)
@@ -301,7 +301,7 @@ void mlxsw_sp_trap_fini(struct mlxsw_core *mlxsw_core,
 	int i;
 
 	for (i = 0; i < ARRAY_SIZE(mlxsw_sp_listener_devlink_map); i++) {
-		struct mlxsw_listener *listener;
+		const struct mlxsw_listener *listener;
 
 		if (mlxsw_sp_listener_devlink_map[i] != trap->id)
 			continue;
@@ -318,8 +318,8 @@ int mlxsw_sp_trap_action_set(struct mlxsw_core *mlxsw_core,
 	int i;
 
 	for (i = 0; i < ARRAY_SIZE(mlxsw_sp_listener_devlink_map); i++) {
+		const struct mlxsw_listener *listener;
 		enum mlxsw_reg_hpkt_action hw_action;
-		struct mlxsw_listener *listener;
 		int err;
 
 		if (mlxsw_sp_listener_devlink_map[i] != trap->id)
-- 
2.21.1


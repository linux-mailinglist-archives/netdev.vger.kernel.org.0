Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A711D1696A0
	for <lists+netdev@lfdr.de>; Sun, 23 Feb 2020 08:32:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727181AbgBWHb6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Feb 2020 02:31:58 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:53942 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727109AbgBWHb4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Feb 2020 02:31:56 -0500
Received: by mail-wm1-f68.google.com with SMTP id s10so5886750wmh.3
        for <netdev@vger.kernel.org>; Sat, 22 Feb 2020 23:31:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Y26g+pdIuwRXIw6RuVFfe5w1jhqhyGeVhM/oD/rk+ms=;
        b=GN7L8MKPjHwJrai5Ca9tG+VxFCT0bKuvGGeJPcWqZ7/bKR3L1yLZ6NSF+ZJFkGlCQV
         OqkZhNgsRqGtx4glul/s9nbjQGTPduWkeozb5PlV9qD7fdaKky7z17kKuIFZB5UiMSsf
         y+7CXkUeSasDGnKlLVzKb8hziWldSjWS5nt9kShkj6Pz6OGIQKcPZjGQa+3WrFfyDAWf
         XcyBN1Id2UwHwfD195SZpxoUip0aAqA56zJy2j7qRke/oCDJ64+dR3BKXBLzoYL+Zbp3
         9O0unIItElEzk+zM/EmsI+7Zec6aQQXqfBp+3Bn91ibjdGHO731h3kypGVK+4yWIjCEy
         ejTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Y26g+pdIuwRXIw6RuVFfe5w1jhqhyGeVhM/oD/rk+ms=;
        b=g0OHIw8g2s3Z2RjTdUMOd5gd68LV1Xggv2n1X7neECLcjPQK4LyVUUjyFBsPzQvGhJ
         RQJf+BGVRL43DMcPlSqT4OCztlmYCeXf1bIoC1OEUvrxJq5BQl5w9Geb5BfnZR6gvahO
         sS3iFvkNz8o1xgN/R/VwmCoqjCNP6EYwl4bw/sVra6A+0mHjYB08dwylkfvuz4p92Ai2
         lyWmL4UcM8QkZBOgDvvMWS0pbJfDRY9nDeoMiDqpbFGvpALpyBOpHveR0nj2pTKGthIP
         jEGvDhGM5VPTYyb1TFhg6wqIhvmcA96BMnD1BtopTuNm5YQZNaSixwNQZhVHAwDw+D4r
         SMkQ==
X-Gm-Message-State: APjAAAXmUuj7zf4EvidNHGwXHIFd69OREO5OdDW4y1xoFZRzdFD1HWn/
        uwceVLz7InTMH1gP30Y96tX1+6L914Q=
X-Google-Smtp-Source: APXvYqydpy7Z5EHvFNjlm6GR/kznSxFKgIlTFVdFkrmprM+Jxz4XGlgPMoOhARKnpxXssw5VEBGCrw==
X-Received: by 2002:a05:600c:34d:: with SMTP id u13mr14953705wmd.77.1582443112619;
        Sat, 22 Feb 2020 23:31:52 -0800 (PST)
Received: from localhost (ip-89-177-130-96.net.upcbroadband.cz. [89.177.130.96])
        by smtp.gmail.com with ESMTPSA id z10sm11652076wmk.31.2020.02.22.23.31.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 22 Feb 2020 23:31:52 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, idosch@mellanox.com,
        mlxsw@mellanox.com
Subject: [patch net-next 06/12] mlxsw: core: Remove dummy union name from struct mlxsw_listener
Date:   Sun, 23 Feb 2020 08:31:38 +0100
Message-Id: <20200223073144.28529-7-jiri@resnulli.us>
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

The dummy name for union is no longer needed, remove it.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/core.c | 8 ++++----
 drivers/net/ethernet/mellanox/mlxsw/core.h | 6 +++---
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.c b/drivers/net/ethernet/mellanox/mlxsw/core.c
index 0d630096a28c..1ad959de909d 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.c
@@ -1611,11 +1611,11 @@ static int mlxsw_core_listener_register(struct mlxsw_core *mlxsw_core,
 {
 	if (listener->is_event)
 		return mlxsw_core_event_listener_register(mlxsw_core,
-						&listener->u.event_listener,
+						&listener->event_listener,
 						priv);
 	else
 		return mlxsw_core_rx_listener_register(mlxsw_core,
-						&listener->u.rx_listener,
+						&listener->rx_listener,
 						priv);
 }
 
@@ -1625,11 +1625,11 @@ static void mlxsw_core_listener_unregister(struct mlxsw_core *mlxsw_core,
 {
 	if (listener->is_event)
 		mlxsw_core_event_listener_unregister(mlxsw_core,
-						     &listener->u.event_listener,
+						     &listener->event_listener,
 						     priv);
 	else
 		mlxsw_core_rx_listener_unregister(mlxsw_core,
-						  &listener->u.rx_listener,
+						  &listener->rx_listener,
 						  priv);
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.h b/drivers/net/ethernet/mellanox/mlxsw/core.h
index de56f489b6ab..ba767329e20d 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.h
@@ -75,7 +75,7 @@ struct mlxsw_listener {
 	union {
 		struct mlxsw_rx_listener rx_listener;
 		struct mlxsw_event_listener event_listener;
-	} u;
+	};
 	enum mlxsw_reg_hpkt_action action;
 	enum mlxsw_reg_hpkt_action unreg_action;
 	u8 trap_group;
@@ -87,7 +87,7 @@ struct mlxsw_listener {
 		  _unreg_action)					\
 	{								\
 		.trap_id = MLXSW_TRAP_ID_##_trap_id,			\
-		.u.rx_listener =					\
+		.rx_listener =						\
 		{							\
 			.func = _func,					\
 			.local_port = MLXSW_PORT_DONT_CARE,		\
@@ -103,7 +103,7 @@ struct mlxsw_listener {
 #define MLXSW_EVENTL(_func, _trap_id, _trap_group)			\
 	{								\
 		.trap_id = MLXSW_TRAP_ID_##_trap_id,			\
-		.u.event_listener =					\
+		.event_listener =					\
 		{							\
 			.func = _func,					\
 			.trap_id = MLXSW_TRAP_ID_##_trap_id,		\
-- 
2.21.1


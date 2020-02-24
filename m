Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E90F1169F56
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 08:36:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727337AbgBXHgI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 02:36:08 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:54374 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727282AbgBXHgE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 02:36:04 -0500
Received: by mail-wm1-f65.google.com with SMTP id z12so4692771wmi.4
        for <netdev@vger.kernel.org>; Sun, 23 Feb 2020 23:36:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SaA8kEHhXJ+n0m3af4mczRuqHp8Y9mwPllOXfdw2i8k=;
        b=WoWUMJE1Tz6yUB/09Nn/qQisDDWwiyT0EHQaQwMX6lFv5SK0GfGw1UYdc2wDd3quGt
         nXw3Xkzy3rz2umVEFc+rUumb+FimfdvwuamnADS8GSBuqnTefTvIwh6SgelTSv4BqP+t
         nwMhF+gghaxNhMSW8hNpUveIffPBtnVY7tyWsFUbtZua+JkTexnBxYp5x0uf13ZzdJIe
         9J/+8lZzqC7Nit9IuDuOmYKSYM6juCIF11FOdV3WSavVdhN/VyWGoa86Pjj7wV8krVSc
         xFzuaLRRFneRX1sYJ3zYq66/L544UOpG4NvTG/jkONRLgW+ZlS0P69T3RRczPuXEQF+w
         a4ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SaA8kEHhXJ+n0m3af4mczRuqHp8Y9mwPllOXfdw2i8k=;
        b=lC4DTdDpJfJy0N1fXO+svOtGRjyB5dJR57lzdSWUy5ZSA25Cym1XnwAImLa9Ix5qir
         a9hAVrxkEnrpDk19IBOLRp3qtzBc3vFkl7kj5tQX+k7NghXMEXQQCL0kgyb8xx1P0Rg/
         VIHo0/kWPnW6GsDODTs0dB0hAglYd2+LljQfYXjaFjNX3owZraC15ID0V/tBVaz6Gzut
         DjF1cg9St20e9py+Rv5j9mwo//cprmiR5uMDMWlifij9oF5OwaChV2pBVK/zleA4ifzZ
         Kz4XbWKZVPz+RCiFfHIkyGH/7GhLWTu64SCH781kwLRzzqgYxxad6foDr2xpXQLjoMYW
         lvfQ==
X-Gm-Message-State: APjAAAVZEU6U7VZOIBwNxzBatL9hnt3nS53gddbtuiGxvYTPnr+iqhnG
        iSHUTmP2XWsZgBmD8VOoKFFwFLlmtTY=
X-Google-Smtp-Source: APXvYqwf7ZZg/cW3wA7U3ydc9erLoEXp/DvHmH13GTXQG8I0Pr6yxrt2AvX5cBGzmJS+GCssNi0EpQ==
X-Received: by 2002:a1c:e2c3:: with SMTP id z186mr20740180wmg.70.1582529761007;
        Sun, 23 Feb 2020 23:36:01 -0800 (PST)
Received: from localhost (ip-89-177-130-96.net.upcbroadband.cz. [89.177.130.96])
        by smtp.gmail.com with ESMTPSA id p5sm17006233wrt.79.2020.02.23.23.36.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Feb 2020 23:36:00 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, idosch@mellanox.com,
        mlxsw@mellanox.com
Subject: [patch net-next 01/16] mlxsw: spectrum_trap: Set unreg_action to be SET_FW_DEFAULT
Date:   Mon, 24 Feb 2020 08:35:43 +0100
Message-Id: <20200224073558.26500-2-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20200224073558.26500-1-jiri@resnulli.us>
References: <20200224073558.26500-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

Currently it does not really matter if it is set to DISCARD or
SET_FW_DEFAULT because it is set only during unregister of the listener.
The unreg_action is going to be used for disabling the listener too, so
change to SET_FW_DEFAULT and ensure the HW is going to behave correctly.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
index 2f2ddc751f3d..1622fec6512d 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
@@ -119,11 +119,11 @@ static void mlxsw_sp_rx_exception_listener(struct sk_buff *skb, u8 local_port,
 
 #define MLXSW_SP_RXL_DISCARD(_id, _group_id)				      \
 	MLXSW_RXL(mlxsw_sp_rx_drop_listener, DISCARD_##_id, SET_FW_DEFAULT,   \
-		  false, SP_##_group_id, DISCARD)
+		  false, SP_##_group_id, SET_FW_DEFAULT)
 
 #define MLXSW_SP_RXL_EXCEPTION(_id, _group_id, _action)			      \
 	MLXSW_RXL(mlxsw_sp_rx_exception_listener, _id,			      \
-		   _action, false, SP_##_group_id, DISCARD)
+		   _action, false, SP_##_group_id, SET_FW_DEFAULT)
 
 static const struct devlink_trap mlxsw_sp_traps_arr[] = {
 	MLXSW_SP_TRAP_DROP(SMAC_MC, L2_DROPS),
-- 
2.21.1


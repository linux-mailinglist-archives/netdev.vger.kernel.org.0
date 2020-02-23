Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5AE891696A2
	for <lists+netdev@lfdr.de>; Sun, 23 Feb 2020 08:32:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727249AbgBWHcG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Feb 2020 02:32:06 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:37668 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725980AbgBWHb5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Feb 2020 02:31:57 -0500
Received: by mail-wr1-f65.google.com with SMTP id l5so2391923wrx.4
        for <netdev@vger.kernel.org>; Sat, 22 Feb 2020 23:31:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cA3wZF6GuH65vDB8IdJdVfBkN3kQeFAWoRSoX27WtQI=;
        b=UfWMW/s9y6ZKUrqL9i0UUKe++9NIrHLKpRDjG2+Bou7Q9DDA250uN9ufL45Nc9OdwS
         GGWWFAPqamGcpdm7PyUiV8X/4UFo9r0QdaBJms8KuLXyTy0TWEQ39oa0ta+/ckHH0ZIm
         JoK8InDsNCUv6L1to/PFBwKG9qcb0OE6rwpoXPBkcuBlk2F1nTSvtQbA3NujLGohgi4T
         bnJ7Axh3lgGQrbXNkMmo+1oRX2jARV89afbM/bZU/gWtrXYvwiQpQz1grej0+DApT5NM
         79niTZNULpSl/MML8ZrP8JcYmV+tp72LYjrcbHmZO+kvd+h0jzyncpYndub07kCH1gRR
         o/sQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cA3wZF6GuH65vDB8IdJdVfBkN3kQeFAWoRSoX27WtQI=;
        b=bPh0Y7j1JkKCCKIp8aaQsQJ0OoDVwfqvigY1KxzyqYJUoHuE4Q+U64kf27zO7xy5SD
         AC2Du1RCkzHbNPFIs93ed6Hf9Ul5K96QrIZlJMPrhuIKrVAVCXuH2JXvTegup+eD6Sh5
         C6asIgFsjECpM2woZYH9nyAeQQVD09SSmKOb4R1hjO3i+ii0M6xw75O+4CeK/ZV9HjxO
         5HbHpGnPdJXo9g7fWyWhsNrjFKwO5llqFdT/gmxHINadJpkeUctIythiS1I1h9WnCDu1
         1u44Yf+zXgx9royk3fciNXGS4e2dtnYjqd9nxB5Ne7xbpY59AmQGlSfZ5r41n+ExXNXG
         WMIw==
X-Gm-Message-State: APjAAAW6cjaKEFxS9ufydVSCAq03sqeP3QHpAVoNeORvquTtiAMvxmPQ
        Jl6OC0P7xQdsIswHmI5ferHAI70//wk=
X-Google-Smtp-Source: APXvYqznVksGNJcHtAJ/m2BBVw8ii0h15zhilPkZcgF/wUlYEGpbPB7ws3wU7TJeYkzfxTflZJcHqw==
X-Received: by 2002:adf:f6c1:: with SMTP id y1mr57588282wrp.17.1582443114854;
        Sat, 22 Feb 2020 23:31:54 -0800 (PST)
Received: from localhost (ip-89-177-130-96.net.upcbroadband.cz. [89.177.130.96])
        by smtp.gmail.com with ESMTPSA id u23sm12592527wmu.14.2020.02.22.23.31.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 22 Feb 2020 23:31:54 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, idosch@mellanox.com,
        mlxsw@mellanox.com
Subject: [patch net-next 08/12] mlxsw: core: Remove initialization to false of mlxsw_listener struct
Date:   Sun, 23 Feb 2020 08:31:40 +0100
Message-Id: <20200223073144.28529-9-jiri@resnulli.us>
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

No need to initialize to false, so remove it.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/core.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.h b/drivers/net/ethernet/mellanox/mlxsw/core.h
index 76c0d6e975db..c5890e35fd2f 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.h
@@ -97,7 +97,6 @@ struct mlxsw_listener {
 		.unreg_action = MLXSW_REG_HPKT_ACTION_##_unreg_action,	\
 		.trap_group = MLXSW_REG_HTGT_TRAP_GROUP_##_trap_group,	\
 		.is_ctrl = _is_ctrl,					\
-		.is_event = false,					\
 	}
 
 #define MLXSW_EVENTL(_func, _trap_id, _trap_group)			\
@@ -110,7 +109,6 @@ struct mlxsw_listener {
 		},							\
 		.action = MLXSW_REG_HPKT_ACTION_TRAP_TO_CPU,		\
 		.trap_group = MLXSW_REG_HTGT_TRAP_GROUP_##_trap_group,	\
-		.is_ctrl = false,					\
 		.is_event = true,					\
 	}
 
-- 
2.21.1


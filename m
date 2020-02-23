Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 75EAB16969E
	for <lists+netdev@lfdr.de>; Sun, 23 Feb 2020 08:31:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727150AbgBWHbz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Feb 2020 02:31:55 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:36410 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725980AbgBWHby (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Feb 2020 02:31:54 -0500
Received: by mail-wr1-f65.google.com with SMTP id z3so6668353wru.3
        for <netdev@vger.kernel.org>; Sat, 22 Feb 2020 23:31:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZSFPlPCWRnut6I3Xv1MSf4pHtORYFVZeB23u8wH4qSQ=;
        b=nkhlSITVbD6N8rBv/vDK6CvK011qkBNoBic9NSmBq5RlyaPysZYmcTgLDUxs3J7EgZ
         HMKxvSOkyXKPK9hQ+t5Lu8AgLy3nPz3PaFh8sHTDbW55nefRJ4TouoIES4fb9aSOGZXb
         kScMB+VmOtvvZI3bqHoXW21kdrf99YtDvT37g+TaN5lhjvSVu8z7LyVaUvnUFO5+auK/
         5fx+iDTNTZzWoBKvZJDYtDGkdPEKqyFcvxRsvHjeXbmzP8y0wwvXaZ5X/7lpw3MTJxk1
         O3LKZaGMU7klFF/od7yHImV3dvC7uZ+EIMSunELgKlDac7tIL4y3DPFzS6ZELXoM9gvU
         tUZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZSFPlPCWRnut6I3Xv1MSf4pHtORYFVZeB23u8wH4qSQ=;
        b=aXfwYa9fX6n92Ru/7y7dIKn666aYDK2Cz3GcwtMvbzcwgCZqtdkkLMp7ghfXqC/UwJ
         pEUYoqT6P/u2gc29rlXohZOvKO1CfAPWI7UBX5qF/57An9LbzIpFem+HNFBX6Tw/Hu2y
         F90JPvNj252axR3gJ86ZwSPejtIIHdBiSpEYBt+fMYJfemBwTCajMcZwvJmmFWV6sPtU
         NO6SG3DkKld4HCL9UqftfyF6MLaM3fdplG1Thqs3DR1YDO/hWB6nAJUwjy/6hKvVLgXr
         naVxkF1lSnkujpI2WxVeCfs09vqkhg4vy+Mxzr0hjiwwN+rzx29YfVabULbHtOf06w0q
         0Vtw==
X-Gm-Message-State: APjAAAXov+hmSr+LwPCZddJfkdJM94zl2aUQA1tsEJG3IBmM7Soc5KBr
        3W6ezZ5aNCgkymOqFhEns6esIFxK5KE=
X-Google-Smtp-Source: APXvYqzE6xyTc6sG+a+7lkFekwcgqvHg1GOiK/DKFPJioVDUGe1v2s2cmtUiYYaL98spbZF9QLXxUg==
X-Received: by 2002:a5d:5752:: with SMTP id q18mr61528883wrw.277.1582443111515;
        Sat, 22 Feb 2020 23:31:51 -0800 (PST)
Received: from localhost (ip-89-177-130-96.net.upcbroadband.cz. [89.177.130.96])
        by smtp.gmail.com with ESMTPSA id j12sm863251wrt.35.2020.02.22.23.31.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 22 Feb 2020 23:31:51 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, idosch@mellanox.com,
        mlxsw@mellanox.com
Subject: [patch net-next 05/12] mlxsw: core: Remove unused action field from mlxsw_rx_listener struct
Date:   Sun, 23 Feb 2020 08:31:37 +0100
Message-Id: <20200223073144.28529-6-jiri@resnulli.us>
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

Commit 0791051c43ef ("mlxsw: core: Create a generic function to
register / unregister traps") moved this field to struct mlxsw_listener,
but forgot to remove it from struct mlxsw_rx_listener.
Remove the unused field.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/core.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.h b/drivers/net/ethernet/mellanox/mlxsw/core.h
index 543476a2e503..de56f489b6ab 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.h
@@ -62,7 +62,6 @@ struct mlxsw_rx_listener {
 	void (*func)(struct sk_buff *skb, u8 local_port, void *priv);
 	u8 local_port;
 	u16 trap_id;
-	enum mlxsw_reg_hpkt_action action;
 };
 
 struct mlxsw_event_listener {
-- 
2.21.1


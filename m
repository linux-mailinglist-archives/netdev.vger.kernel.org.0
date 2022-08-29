Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4481E5A47A5
	for <lists+netdev@lfdr.de>; Mon, 29 Aug 2022 12:56:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229631AbiH2K4l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Aug 2022 06:56:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbiH2K4k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Aug 2022 06:56:40 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63E595C9F0;
        Mon, 29 Aug 2022 03:56:39 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id u22so7583293plq.12;
        Mon, 29 Aug 2022 03:56:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=AUETLg45qX01n2RmwwzRQQGYPyVNK9kTDSOD2H9EAus=;
        b=f25aWLpfm5yey6afT+MDjjrRJP8tZgz66jtzhNZZdl3vexOlhYm4vqeIH9rWfcAvKU
         AqQ2ut3ST7XBTT+m4h9MsHCjx1VS5O3nwGVoWGMwhbikCIl20NDypz/+ydTtF0TdqIlR
         /+M7yVwLLq+CyzDzHv6N575hZZjId3rK42uWI+Ghtb90Bf8PBlJlDR4FwWUZEtVYQdjY
         L8T2KWa7Mt+zMD9SFewDYqmwZmvZtbMP0UilD5MWrdBwzauRcnKqmJC9I87tTwv8SdVF
         WBOmASU9eQuhWJf7eSWprH4YmGx++5jhjrO3vh7xEZUkH0u0uwbGj1GZJ+idS5vqw/lX
         ey2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=AUETLg45qX01n2RmwwzRQQGYPyVNK9kTDSOD2H9EAus=;
        b=peCK34GtUqY7NcKBBysUevpMOoEdu1dB4myzQ19XGcDr06s8B5ZnDbsXzpNye39t/5
         JRQleQjkxrYhQ0nbg6KAnCzyw+sb06VduqVZcWNJ3ZKdvKqDi+aKxSS2Vzkm1jyhPXwu
         UbqD552GCRtisoiBgWy1YbTFXi0eYt/zFTbfFBFFGmbZMslFFd7Q1M+NSz88r8OCSTtV
         OyvVjgzo5IY7ReoN9EDFyl/atpGydtDu37qCP0dWzlnMyIQNvGV2Am90C0AZS+FOjka1
         +dvhQOwIRXROZjc2m8VFo1XmmOa75j6cQLPusQvgbwlGaZMN6vsPy2Czi957oSGbHFR3
         /frw==
X-Gm-Message-State: ACgBeo09fumIJJhta1KX98m6sALYTuqEU1lZKQZATv/S0al2VzRC4P/1
        lmN3qEbmuVt67Sm6ODO4kLQ=
X-Google-Smtp-Source: AA6agR58BatydnUw2ve/SMTAxE2+wVUrnbzg+XFFDb99La42ZBOIWHhFF3NTG0KW8PdUPHEdeSoyDQ==
X-Received: by 2002:a17:902:864c:b0:172:bc0d:c769 with SMTP id y12-20020a170902864c00b00172bc0dc769mr16112085plt.146.1661770598941;
        Mon, 29 Aug 2022 03:56:38 -0700 (PDT)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id x9-20020a170902a38900b0016f154c8910sm4978311pla.204.2022.08.29.03.56.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Aug 2022 03:56:38 -0700 (PDT)
From:   cgel.zte@gmail.com
X-Google-Original-From: cui.jinpeng2@zte.com.cn
To:     idosch@nvidia.com
Cc:     petrm@nvidia.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jinpeng Cui <cui.jinpeng2@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH linux-next] mlxsw: remove redundant err variable
Date:   Mon, 29 Aug 2022 10:54:55 +0000
Message-Id: <20220829105454.266509-1-cui.jinpeng2@zte.com.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jinpeng Cui <cui.jinpeng2@zte.com.cn>

Return value from mlxsw_core_bus_device_register() directly
instead of taking this in another redundant variable.

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Jinpeng Cui <cui.jinpeng2@zte.com.cn>
---
 drivers/net/ethernet/mellanox/mlxsw/core.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.c b/drivers/net/ethernet/mellanox/mlxsw/core.c
index afbe046b35a0..be9901ddf987 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.c
@@ -1496,15 +1496,14 @@ mlxsw_devlink_core_bus_device_reload_up(struct devlink *devlink, enum devlink_re
 					struct netlink_ext_ack *extack)
 {
 	struct mlxsw_core *mlxsw_core = devlink_priv(devlink);
-	int err;
 
 	*actions_performed = BIT(DEVLINK_RELOAD_ACTION_DRIVER_REINIT) |
 			     BIT(DEVLINK_RELOAD_ACTION_FW_ACTIVATE);
-	err = mlxsw_core_bus_device_register(mlxsw_core->bus_info,
+
+	return mlxsw_core_bus_device_register(mlxsw_core->bus_info,
 					     mlxsw_core->bus,
 					     mlxsw_core->bus_priv, true,
 					     devlink, extack);
-	return err;
 }
 
 static int mlxsw_devlink_flash_update(struct devlink *devlink,
-- 
2.25.1


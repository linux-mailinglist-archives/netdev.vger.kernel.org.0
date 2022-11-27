Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54461639AD2
	for <lists+netdev@lfdr.de>; Sun, 27 Nov 2022 14:10:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229469AbiK0NKJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Nov 2022 08:10:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229690AbiK0NKE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Nov 2022 08:10:04 -0500
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A120DDF6C;
        Sun, 27 Nov 2022 05:09:58 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id p12so7813352plq.4;
        Sun, 27 Nov 2022 05:09:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0ZsXPiwPOVu7JihBSzIX9RMliHJg1zhwJcyiOwYn5LE=;
        b=KwJMKBZedewWTw2AYgadSrDQJh5K2xX0zFcZDpqAsOMhznSyUoNmuTIG+/DMG+evxd
         SWjXdQyeXnwoGbQxFBekzMnAuZDeV5dSl6PwXdzNzkb45jJC+8K8j1myIffH6fmXqzE3
         VD9cUWqGlAKdzpnDikGQXNMNPVdY1yUGugFJ++7CmRhP3fL1HlIZt/1ZEZ5ckPpLnUX4
         6ilBV0dhoGa07b8xjMJF+WXsiYuOyZWIXmI7s1/BOHDSbh7Lg2QWkKv9LFnFFwnFVePN
         MTRBsE53vqKkTMGHNPRmiWsiVIugI8n+Gy9030V7S3QGpwQiMsjepWBhiYHOz2O8OfYb
         65Hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=0ZsXPiwPOVu7JihBSzIX9RMliHJg1zhwJcyiOwYn5LE=;
        b=CdgrDpMq7SkR/QDCQhTVEbuA8EfSsmla1748vtMyVk+oQLGGmy4YQIHec8pdyLFWCe
         LbAWy2phYLR2/1k3k5U3nCgEBsfTPArNVHLG7257sG+kM1+KTwqw3+EUXQWOE7AMLViz
         ijk8SCQ0S2Y1tOtBUPHMa+7JuO3FO4nqKjSP99RNY0xsfGT/Q9n7dIGMjrqOhHj972wm
         e8xUeDhm7fx+hQvpfmKvmyd32CZqRyp4Bhq+Zr2TWvhkgK5RQEgLtjjL0bSdR25U4VfJ
         EwiFnzVzfw+COcIeInEr3M8sqY452L1v0BmUuZct6/oOKaMo/iT0HzR9Oy3EYK1W9OAw
         AAvg==
X-Gm-Message-State: ANoB5pnCQoY17Ko9VMYkdZl8AToa9rKPlkUZEE9T5mHOat8A2Pner/0u
        5kkL1EOCkilJoP+L1jOQj38=
X-Google-Smtp-Source: AA0mqf4V5hYar5riUHM4zUSas46jIem/YoPjekB9ahNyuLrurPdoxj2NAgRwb39fvA5BSY7GOsR6oA==
X-Received: by 2002:a17:902:c946:b0:186:99e3:c079 with SMTP id i6-20020a170902c94600b0018699e3c079mr27225014pla.149.1669554597977;
        Sun, 27 Nov 2022 05:09:57 -0800 (PST)
Received: from localhost.localdomain (124x33x176x97.ap124.ftth.ucom.ne.jp. [124.33.176.97])
        by smtp.gmail.com with ESMTPSA id q17-20020a170902eb9100b00188a908cbddsm6710225plg.302.2022.11.27.05.09.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Nov 2022 05:09:57 -0800 (PST)
Sender: Vincent Mailhol <vincent.mailhol@gmail.com>
From:   Vincent Mailhol <mailhol.vincent@wanadoo.fr>
To:     Jiri Pirko <jiri@nvidia.com>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        Boris Brezillon <bbrezillon@kernel.org>,
        Arnaud Ebalard <arno@natisbad.org>,
        Srujana Challa <schalla@marvell.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Dimitris Michailidis <dmichail@fungible.com>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sunil Goutham <sgoutham@marvell.com>,
        Linu Cherian <lcherian@marvell.com>,
        Geetha sowjanya <gakula@marvell.com>,
        Jerin Jacob <jerinj@marvell.com>,
        hariprasad <hkelam@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Ido Schimmel <idosch@nvidia.com>,
        Petr Machata <petrm@nvidia.com>,
        Simon Horman <simon.horman@corigine.com>,
        Shannon Nelson <snelson@pensando.io>, drivers@pensando.io,
        Ariel Elior <aelior@marvell.com>,
        Manish Chopra <manishc@marvell.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Vadim Fedorenko <vadfed@fb.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Vadim Pasternak <vadimp@mellanox.com>,
        Shalom Toledo <shalomt@mellanox.com>,
        linux-crypto@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        linux-rdma@vger.kernel.org, oss-drivers@corigine.com,
        Jiri Pirko <jiri@mellanox.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Hao Chen <chenhao288@hisilicon.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        Minghao Chi <chi.minghao@zte.com.cn>,
        Shijith Thotton <sthotton@marvell.com>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next v3 1/5] mlxsw: minimal: fix mlxsw_m_module_get_drvinfo() to correctly report driver name
Date:   Sun, 27 Nov 2022 22:09:15 +0900
Message-Id: <20221127130919.638324-2-mailhol.vincent@wanadoo.fr>
X-Mailer: git-send-email 2.37.4
In-Reply-To: <20221127130919.638324-1-mailhol.vincent@wanadoo.fr>
References: <20221122154934.13937-1-mailhol.vincent@wanadoo.fr>
 <20221127130919.638324-1-mailhol.vincent@wanadoo.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, mlxsw_m_module_get_drvinfo() reports the device_kind. The
device_kind is not necessarily the same as the device_name. For
example, the mlxsw_i2c implementation sets up the device_kind as
ic2_client::name in [1] which indicates the type of the device
(e.g. chip name), not the actual driver name.

Fix it so that it correctly reports the driver name.

[1] mlxsw_i2c_probe() from drivers/net/ethernet/mellanox/mlxsw/i2c.c
Link: https://elixir.bootlin.com/linux/v6.1-rc1/source/drivers/net/ethernet/mellanox/mlxsw/i2c.c#L714

Fixes: 9bbd7efbc055 ("mlxsw: i2c: Extend initialization with querying firmware info")
CC: Shalom Toledo <shalomt@mellanox.com>
CC: Ido Schimmel <idosch@mellanox.com>
CC: Vadim Pasternak <vadimp@mellanox.com>
Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
---
 drivers/net/ethernet/mellanox/mlxsw/minimal.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/minimal.c b/drivers/net/ethernet/mellanox/mlxsw/minimal.c
index 6b56eadd736e..9b37ddbe0cba 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/minimal.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/minimal.c
@@ -92,7 +92,7 @@ static void mlxsw_m_module_get_drvinfo(struct net_device *dev,
 	struct mlxsw_m_port *mlxsw_m_port = netdev_priv(dev);
 	struct mlxsw_m *mlxsw_m = mlxsw_m_port->mlxsw_m;
 
-	strscpy(drvinfo->driver, mlxsw_m->bus_info->device_kind,
+	strscpy(drvinfo->driver, dev_driver_string(dev->dev.parent),
 		sizeof(drvinfo->driver));
 	snprintf(drvinfo->fw_version, sizeof(drvinfo->fw_version),
 		 "%d.%d.%d",
-- 
2.37.4


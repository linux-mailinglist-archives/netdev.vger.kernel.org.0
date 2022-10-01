Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20CA05F1A1B
	for <lists+netdev@lfdr.de>; Sat,  1 Oct 2022 08:02:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229501AbiJAGCN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Oct 2022 02:02:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbiJAGCE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Oct 2022 02:02:04 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AD23DF69D
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 23:01:59 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id rk17so12933089ejb.1
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 23:01:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=lMF6OxhpO77TCv6j/JI/rAyTxaoEZW/QukSEoe2fqbM=;
        b=EFS7Daa2J8ElLPEooFAoHOXm4K50xhXErl9jOY7sY19BHsF58Lt+cSdZ7cjYFlkWij
         OBgBhTtuDbugasvtf2GaRKM/hRKNDG+3J2NTw9KBRaMmogXbYP1k0LjrEeJoFhbP5ILE
         td9w/bKogxz2Ky+JqkF0sC/szDW4CMLqsM+l4RvW8zTEV0WFhq2w6rwSF7UEbtmHqTOq
         ljsy0NjRM+jVXrLWWNZpatq8DZTZ4MZcLBeLMxl6rU4kGscOEDxUcmZvjXTiSoenma19
         4N4+oMLWfnoMh9g2xI0PPJDdASLgITpUHvio/Aa6/+0JxsGG9gGyE3IVRXiq6kwo9CWD
         jEWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=lMF6OxhpO77TCv6j/JI/rAyTxaoEZW/QukSEoe2fqbM=;
        b=iW559MX5BAL1dcnpMyu2D3IKo96HzXMuaS6UwT+pHfyxWg2svGKlazgTVpq+nuzagg
         7tCumkLuQBI9dfWjcrOt/FBxycCDJN5nyNFYl+J+WuG8D7qp9lP6DNCaAcLyc7k7hpMp
         PIM3iyll9LH6Yn8K7QHVKrH5rwBqzHFfy9GI2djjYfIl6YdRp3qN42wlNc+i4dxwTA4B
         Tt4RLUmNMjKR8Pl6uL5oiRUT7auOQ4LH6X86zalVH1mnFOMEkP6+ERN0maXHYcDooCi7
         2tsk7XR7jhQL7+e4zf3z3KxXbTFllOupXa/GduHGip/JaYyiB6WiLHSVkM89UsOOE7oO
         wzVg==
X-Gm-Message-State: ACrzQf05XhL/X+R+SsspHN58XOZ9T7VCqZ42yE3DKut+z9pvVTqztDaT
        mNIp5EQurLap/uVmlgC3+i87gY/xnCqsTEPj
X-Google-Smtp-Source: AMsMyM5lLWaYxJatJNJmQKT8ZFvIbQ5Cl7yGh1dftI6ytO454FoANPtucVjinCY80sdaiAs2DlnfBA==
X-Received: by 2002:a17:907:2c4b:b0:77e:2c09:4111 with SMTP id hf11-20020a1709072c4b00b0077e2c094111mr8961975ejc.21.1664604119217;
        Fri, 30 Sep 2022 23:01:59 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id cz7-20020a0564021ca700b0045724875fa2sm2928152edb.15.2022.09.30.23.01.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Sep 2022 23:01:58 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, tariqt@nvidia.com, moshe@nvidia.com,
        saeedm@nvidia.com
Subject: [patch net-next 07/13] net: devlink: remove netdev arg from devlink_port_type_eth_set()
Date:   Sat,  1 Oct 2022 08:01:39 +0200
Message-Id: <20221001060145.3199964-8-jiri@resnulli.us>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20221001060145.3199964-1-jiri@resnulli.us>
References: <20221001060145.3199964-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

Since devlink_port_type_eth_set() should no longer be called by any
driver with netdev pointer as it should rather use
SET_NETDEV_DEVLINK_PORT, remove the netdev arg. Add a warn to
type_clear()

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx4/main.c |  2 +-
 include/net/devlink.h                     |  3 +--
 net/core/devlink.c                        | 23 ++++++++++++++---------
 3 files changed, 16 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/main.c b/drivers/net/ethernet/mellanox/mlx4/main.c
index d3fc86cd3c1d..3ae246391549 100644
--- a/drivers/net/ethernet/mellanox/mlx4/main.c
+++ b/drivers/net/ethernet/mellanox/mlx4/main.c
@@ -3043,7 +3043,7 @@ static int mlx4_init_port_info(struct mlx4_dev *dev, int port)
 	 */
 	if (!IS_ENABLED(CONFIG_MLX4_EN) &&
 	    dev->caps.port_type[port] == MLX4_PORT_TYPE_ETH)
-		devlink_port_type_eth_set(&info->devlink_port, NULL);
+		devlink_port_type_eth_set(&info->devlink_port);
 	else if (!IS_ENABLED(CONFIG_MLX4_INFINIBAND) &&
 		 dev->caps.port_type[port] == MLX4_PORT_TYPE_IB)
 		devlink_port_type_ib_set(&info->devlink_port, NULL);
diff --git a/include/net/devlink.h b/include/net/devlink.h
index 6c55aabaedf1..b1582b32183a 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -1582,8 +1582,7 @@ int devlink_port_register(struct devlink *devlink,
 			  unsigned int port_index);
 void devl_port_unregister(struct devlink_port *devlink_port);
 void devlink_port_unregister(struct devlink_port *devlink_port);
-void devlink_port_type_eth_set(struct devlink_port *devlink_port,
-			       struct net_device *netdev);
+void devlink_port_type_eth_set(struct devlink_port *devlink_port);
 void devlink_port_type_ib_set(struct devlink_port *devlink_port,
 			      struct ib_device *ibdev);
 void devlink_port_type_clear(struct devlink_port *devlink_port);
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 87aa39bc481e..f119ac43c50d 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -10097,17 +10097,15 @@ static void __devlink_port_type_set(struct devlink_port *devlink_port,
  *	devlink_port_type_eth_set - Set port type to Ethernet
  *
  *	@devlink_port: devlink port
- *	@netdev: related netdevice
+ *
+ *	If driver is calling this, most likely it is doing something wrong.
  */
-void devlink_port_type_eth_set(struct devlink_port *devlink_port,
-			       struct net_device *netdev)
+void devlink_port_type_eth_set(struct devlink_port *devlink_port)
 {
-	if (!netdev)
-		dev_warn(devlink_port->devlink->dev,
-			 "devlink port type for port %d set to Ethernet without a software interface reference, device type not supported by the kernel?\n",
-			 devlink_port->index);
-
-	__devlink_port_type_set(devlink_port, DEVLINK_PORT_TYPE_ETH, netdev,
+	dev_warn(devlink_port->devlink->dev,
+		 "devlink port type for port %d set to Ethernet without a software interface reference, device type not supported by the kernel?\n",
+		 devlink_port->index);
+	__devlink_port_type_set(devlink_port, DEVLINK_PORT_TYPE_ETH, NULL,
 				false);
 }
 EXPORT_SYMBOL_GPL(devlink_port_type_eth_set);
@@ -10130,9 +10128,16 @@ EXPORT_SYMBOL_GPL(devlink_port_type_ib_set);
  *	devlink_port_type_clear - Clear port type
  *
  *	@devlink_port: devlink port
+ *
+ *	If driver is calling this for clearing Ethernet type, most likely
+ *	it is doing something wrong.
  */
 void devlink_port_type_clear(struct devlink_port *devlink_port)
 {
+	if (devlink_port->type == DEVLINK_PORT_TYPE_ETH)
+		dev_warn(devlink_port->devlink->dev,
+			 "devlink port type for port %d cleared without a software interface reference, device type not supported by the kernel?\n",
+			 devlink_port->index);
 	__devlink_port_type_set(devlink_port, DEVLINK_PORT_TYPE_NOTSET, NULL,
 				false);
 }
-- 
2.37.1


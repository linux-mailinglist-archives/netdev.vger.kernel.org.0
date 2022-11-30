Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D814163DC57
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 18:47:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229963AbiK3Rrg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 12:47:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229897AbiK3RrT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 12:47:19 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BAF4578D1;
        Wed, 30 Nov 2022 09:47:18 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id w4-20020a17090ac98400b002186f5d7a4cso2742293pjt.0;
        Wed, 30 Nov 2022 09:47:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Jw/lz6qBvhDf1TeMH0QpjUbxo1UIWujCkJAcKsFr2sI=;
        b=UeVcfWv4VtbGtbKXgZckHOn84zZh27z1dOXv9De1s2MVPJv6/7zXstZUaxtjo8xz32
         AK/ykoByYoXfHJEG3cpzUr48xT9ZDT63InvQaBYEuGTpXlPCS4mqbisxA9m0fzc/m5iL
         ldJZDs6RPIiWOorP1q+ytWYjdndNL/umQClOssptuxKnnbMe/zOY0U8xmMdeTfrK5R0a
         m/f4mtJxY0ljBMJ6lUCvnEWjHKL8GJ/rrW98/Nb5Py5ayfs++HLO3hjeRC9VF9m+l9qB
         hevw0vTFtA0kMOxs0i5bznHZlTr2udoIaaNn+PX13SJyq6/mwPnZcZ2kNPgQA02ppe+e
         xr8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Jw/lz6qBvhDf1TeMH0QpjUbxo1UIWujCkJAcKsFr2sI=;
        b=2VNFnnns+7/2jp7zQ6DfYlG61a2roSp1bP+AGO7nMv3d0PTkz+atF331A7MlKr8ahM
         HcIYcJfYOFm2Is93kHBD8bUosSUzuXmOSFjs6t+chql08hC7GwkQhsl4oLMALHpNOzC/
         nVEUJbfh26WShMf3y6ehzd7GMZi2BqngBhQi13D6Uq3krLhmR5sNShfKLqgsEliwVNig
         OOq9UZ42wUomgKSsNVsUs9+kJNf7j2b2eTSk4ilOm4MnIBbk2mIU93HErr0jE/s88393
         u5Q+DUx8wrsVJ6yA/JJMxhel43GjKCVgo7ELrxK/CJsF0kU7fE5GPXRwA5o50Zs31I0n
         iznw==
X-Gm-Message-State: ANoB5pndVfQTM2B5No35RuiKUMys2X3/CDk7Oe1uqyNXxnxiaInGI1JB
        n4XPmPMVKYrdB9rWwcSVID6lid3fuRstpg==
X-Google-Smtp-Source: AA0mqf4PDfh+joxiwLONgAFdNOWXbxO7cD13836/Kf4oQ0vYMJdhDNXIW0HBZbCrff2c8mcTE5xC1g==
X-Received: by 2002:a17:902:e313:b0:189:97e9:c8e with SMTP id q19-20020a170902e31300b0018997e90c8emr11087620plc.63.1669830437763;
        Wed, 30 Nov 2022 09:47:17 -0800 (PST)
Received: from localhost.localdomain (124x33x176x97.ap124.ftth.ucom.ne.jp. [124.33.176.97])
        by smtp.gmail.com with ESMTPSA id p3-20020aa79e83000000b00574cdb63f03sm1714505pfq.144.2022.11.30.09.47.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Nov 2022 09:47:17 -0800 (PST)
Sender: Vincent Mailhol <vincent.mailhol@gmail.com>
From:   Vincent Mailhol <mailhol.vincent@wanadoo.fr>
To:     linux-can@vger.kernel.org
Cc:     Marc Kleine-Budde <mkl@pengutronix.de>,
        linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        Saeed Mahameed <saeed@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>, Jiri Pirko <jiri@nvidia.com>,
        Lukas Magel <lukas.magel@posteo.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Subject: [PATCH v5 2/7] can: etas_es58x: add devlink port support
Date:   Thu,  1 Dec 2022 02:46:53 +0900
Message-Id: <20221130174658.29282-3-mailhol.vincent@wanadoo.fr>
X-Mailer: git-send-email 2.37.4
In-Reply-To: <20221130174658.29282-1-mailhol.vincent@wanadoo.fr>
References: <20221104073659.414147-1-mailhol.vincent@wanadoo.fr>
 <20221130174658.29282-1-mailhol.vincent@wanadoo.fr>
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

Add support for devlink port which extends the devlink support to the
network interface level. For now, the etas_es58x driver will only rely
on the default features that devlink port has to offer and not
implement additional feature ones.

Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
---
 drivers/net/can/usb/etas_es58x/es58x_core.c | 34 ++++++++++++++++-----
 drivers/net/can/usb/etas_es58x/es58x_core.h |  3 ++
 2 files changed, 29 insertions(+), 8 deletions(-)

diff --git a/drivers/net/can/usb/etas_es58x/es58x_core.c b/drivers/net/can/usb/etas_es58x/es58x_core.c
index aeffe61faed8..de884de9fe57 100644
--- a/drivers/net/can/usb/etas_es58x/es58x_core.c
+++ b/drivers/net/can/usb/etas_es58x/es58x_core.c
@@ -2039,10 +2039,16 @@ static int es58x_set_mode(struct net_device *netdev, enum can_mode mode)
  * @es58x_dev: ES58X device.
  * @priv: ES58X private parameters related to the network device.
  * @channel_idx: Index of the network device.
+ *
+ * Return: zero on success, errno if devlink port could not be
+ *	properly registered.
  */
-static void es58x_init_priv(struct es58x_device *es58x_dev,
-			    struct es58x_priv *priv, int channel_idx)
+static int es58x_init_priv(struct es58x_device *es58x_dev,
+			   struct es58x_priv *priv, int channel_idx)
 {
+	struct devlink_port_attrs attrs = {
+		.flavour = DEVLINK_PORT_FLAVOUR_PHYSICAL,
+	};
 	const struct es58x_parameters *param = es58x_dev->param;
 	struct can_priv *can = &priv->can;
 
@@ -2061,6 +2067,10 @@ static void es58x_init_priv(struct es58x_device *es58x_dev,
 	can->state = CAN_STATE_STOPPED;
 	can->ctrlmode_supported = param->ctrlmode_supported;
 	can->do_set_mode = es58x_set_mode;
+
+	devlink_port_attrs_set(&priv->devlink_port, &attrs);
+	return devlink_port_register(priv_to_devlink(es58x_dev),
+				     &priv->devlink_port, channel_idx);
 }
 
 /**
@@ -2084,7 +2094,10 @@ static int es58x_init_netdev(struct es58x_device *es58x_dev, int channel_idx)
 	}
 	SET_NETDEV_DEV(netdev, dev);
 	es58x_dev->netdev[channel_idx] = netdev;
-	es58x_init_priv(es58x_dev, es58x_priv(netdev), channel_idx);
+	ret = es58x_init_priv(es58x_dev, es58x_priv(netdev), channel_idx);
+	if (ret)
+		goto free_candev;
+	SET_NETDEV_DEVLINK_PORT(netdev, &es58x_priv(netdev)->devlink_port);
 
 	netdev->netdev_ops = &es58x_netdev_ops;
 	netdev->ethtool_ops = &es58x_ethtool_ops;
@@ -2092,16 +2105,20 @@ static int es58x_init_netdev(struct es58x_device *es58x_dev, int channel_idx)
 	netdev->dev_port = channel_idx;
 
 	ret = register_candev(netdev);
-	if (ret) {
-		es58x_dev->netdev[channel_idx] = NULL;
-		free_candev(netdev);
-		return ret;
-	}
+	if (ret)
+		goto devlink_port_unregister;
 
 	netdev_queue_set_dql_min_limit(netdev_get_tx_queue(netdev, 0),
 				       es58x_dev->param->dql_min_limit);
 
 	return ret;
+
+ devlink_port_unregister:
+	devlink_port_unregister(&es58x_priv(netdev)->devlink_port);
+ free_candev:
+	es58x_dev->netdev[channel_idx] = NULL;
+	free_candev(netdev);
+	return ret;
 }
 
 /**
@@ -2118,6 +2135,7 @@ static void es58x_free_netdevs(struct es58x_device *es58x_dev)
 		if (!netdev)
 			continue;
 		unregister_candev(netdev);
+		devlink_port_unregister(&es58x_priv(netdev)->devlink_port);
 		es58x_dev->netdev[i] = NULL;
 		free_candev(netdev);
 	}
diff --git a/drivers/net/can/usb/etas_es58x/es58x_core.h b/drivers/net/can/usb/etas_es58x/es58x_core.h
index bf24375580e5..a76789119229 100644
--- a/drivers/net/can/usb/etas_es58x/es58x_core.h
+++ b/drivers/net/can/usb/etas_es58x/es58x_core.h
@@ -17,6 +17,7 @@
 #include <linux/netdevice.h>
 #include <linux/types.h>
 #include <linux/usb.h>
+#include <net/devlink.h>
 
 #include "es581_4.h"
 #include "es58x_fd.h"
@@ -230,6 +231,7 @@ union es58x_urb_cmd {
  * @can: struct can_priv must be the first member (Socket CAN relies
  *	on the fact that function netdev_priv() returns a pointer to
  *	a struct can_priv).
+ * @devlink_port: devlink instance for the network interface.
  * @es58x_dev: pointer to the corresponding ES58X device.
  * @tx_urb: Used as a buffer to concatenate the TX messages and to do
  *	a bulk send. Please refer to es58x_start_xmit() for more
@@ -255,6 +257,7 @@ union es58x_urb_cmd {
  */
 struct es58x_priv {
 	struct can_priv can;
+	struct devlink_port devlink_port;
 	struct es58x_device *es58x_dev;
 	struct urb *tx_urb;
 
-- 
2.37.4


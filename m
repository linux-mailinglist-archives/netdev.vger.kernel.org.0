Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 193B267BB23
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 20:52:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236057AbjAYTwD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Jan 2023 14:52:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235890AbjAYTve (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Jan 2023 14:51:34 -0500
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F750582B3
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 11:51:14 -0800 (PST)
Received: by mail-ej1-x62f.google.com with SMTP id qx13so50518183ejb.13
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 11:51:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MPZRbcn+ayOOx/787tD+d5yfOpNzt8F4/+0TUH3wcFQ=;
        b=xWuzZuT6B1uM5aAUffyZgQxOrYA9VusXutUVZ5QO9TF9e/Kpe3RBVU6cJlxUC55o6D
         SBX2+JVmpDG5pOrITnrCYKJna+28SxE1qCr4VOtrrqrfEjPTHk0SCZ/vGYgU0gDW4m3q
         6LImlYw7L/6+NC0oFFQSLfDDTnRzKaIQ+IVYI0VbdC5xnaMmV9pllfI2Zy9+Je/2Gjs9
         jIj2HJ+fa2SDWgnnDwnEJu3OJ8SO+UGfVMj7iXLIlG5IvL3nVEqUBiyWA+A7fDA4cija
         cb1cloQSJVBlQAnzyF0QiTEjOsmzwkgZYiqakQmAtEsNjMw3y0IOibU7u5SjKMMWim72
         NzWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MPZRbcn+ayOOx/787tD+d5yfOpNzt8F4/+0TUH3wcFQ=;
        b=QZ0S06mHLom53+kLl5KTuHe6O6Y4ww6v4nlF26X0nBoTsN9qKKLxE2AOnv2IZotB+o
         fv8gNYjR676ShSMJf0ijzEyX3PM1nee26Iw0dwY1p6usWc+cZQckcS6b9mXUpckx/W4K
         wfWcYJkXrV5xDqrz5k/KsTVOszGt/HwtG9LE3Mq43702+KromDzuqbUIhtralX6uWLZP
         +nsyaxkHQwzi7OCa6/Shl89BwPCxBARo9YlP0mKJxB4KigK7ky+zDV/JqmyHOzpUdNRr
         bAKl1XCizAxlt0LsBkbSn1xkQHzvx4Eo7BLguD+WslX5mjPesw7jS4jWmcVSi9o2YzGn
         Tq2Q==
X-Gm-Message-State: AFqh2kr/5BRwpSEwV8h6TXfb9RnYse1dkjcpMlBE8kZpzzVIL04Hfu58
        7JO6ompEETg1tsMCqG3HTgTubQ==
X-Google-Smtp-Source: AMrXdXuVk5AeiwMrKX66/D1k0AoW61Fv4jcEOjCxHt3CQfTytOmKK+R50Z7lGzr/RAlCjhvlAUPukQ==
X-Received: by 2002:a17:906:514:b0:7c1:1ada:5e1e with SMTP id j20-20020a170906051400b007c11ada5e1emr34079325eja.26.1674676274128;
        Wed, 25 Jan 2023 11:51:14 -0800 (PST)
Received: from blmsp.fritz.box ([2001:4091:a247:815f:ef74:e427:628a:752c])
        by smtp.gmail.com with ESMTPSA id s15-20020a170906454f00b00872c0bccab2sm2778830ejq.35.2023.01.25.11.51.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Jan 2023 11:51:13 -0800 (PST)
From:   Markus Schneider-Pargmann <msp@baylibre.com>
To:     Marc Kleine-Budde <mkl@pengutronix.de>,
        Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Wolfgang Grandegger <wg@grandegger.com>
Cc:     Vincent MAILHOL <mailhol.vincent@wanadoo.fr>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Markus Schneider-Pargmann <msp@baylibre.com>
Subject: [PATCH v2 11/18] can: m_can: Add rx coalescing ethtool support
Date:   Wed, 25 Jan 2023 20:50:52 +0100
Message-Id: <20230125195059.630377-12-msp@baylibre.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230125195059.630377-1-msp@baylibre.com>
References: <20230125195059.630377-1-msp@baylibre.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the possibility to set coalescing parameters with ethtool.

rx-frames-irq and rx-usecs-irq can only be set and unset together as the
implemented mechanism would not work otherwise. rx-frames-irq can't be
greater than the RX FIFO size.

Also all values can only be changed if the chip is not active.

Signed-off-by: Markus Schneider-Pargmann <msp@baylibre.com>
---
 drivers/net/can/m_can/m_can.c | 46 +++++++++++++++++++++++++++++++++++
 1 file changed, 46 insertions(+)

diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
index 31a5e551ebd9..35c38c230a00 100644
--- a/drivers/net/can/m_can/m_can.c
+++ b/drivers/net/can/m_can/m_can.c
@@ -1935,8 +1935,54 @@ static const struct net_device_ops m_can_netdev_ops = {
 	.ndo_change_mtu = can_change_mtu,
 };
 
+static int m_can_get_coalesce(struct net_device *dev,
+			      struct ethtool_coalesce *ec,
+			      struct kernel_ethtool_coalesce *kec,
+			      struct netlink_ext_ack *ext_ack)
+{
+	struct m_can_classdev *cdev = netdev_priv(dev);
+
+	ec->rx_max_coalesced_frames_irq = cdev->rx_max_coalesced_frames_irq;
+	ec->rx_coalesce_usecs_irq = cdev->rx_coalesce_usecs_irq;
+
+	return 0;
+}
+
+static int m_can_set_coalesce(struct net_device *dev,
+			      struct ethtool_coalesce *ec,
+			      struct kernel_ethtool_coalesce *kec,
+			      struct netlink_ext_ack *ext_ack)
+{
+	struct m_can_classdev *cdev = netdev_priv(dev);
+
+	if (cdev->can.state != CAN_STATE_STOPPED) {
+		netdev_err(dev, "Device is in use, please shut it down first\n");
+		return -EBUSY;
+	}
+
+	if (ec->rx_max_coalesced_frames_irq > cdev->mcfg[MRAM_RXF0].num) {
+		netdev_err(dev, "rx-frames-irq (%u) greater than the RX FIFO (%u)\n",
+			   ec->rx_max_coalesced_frames_irq,
+			   cdev->mcfg[MRAM_RXF0].num);
+		return -EINVAL;
+	}
+	if ((ec->rx_max_coalesced_frames_irq == 0) != (ec->rx_coalesce_usecs_irq == 0)) {
+		netdev_err(dev, "rx-frames-irq and rx-usecs-irq can only be set together\n");
+		return -EINVAL;
+	}
+
+	cdev->rx_max_coalesced_frames_irq = ec->rx_max_coalesced_frames_irq;
+	cdev->rx_coalesce_usecs_irq = ec->rx_coalesce_usecs_irq;
+
+	return 0;
+}
+
 static const struct ethtool_ops m_can_ethtool_ops = {
+	.supported_coalesce_params = ETHTOOL_COALESCE_RX_USECS_IRQ |
+		ETHTOOL_COALESCE_RX_MAX_FRAMES_IRQ,
 	.get_ts_info = ethtool_op_get_ts_info,
+	.get_coalesce = m_can_get_coalesce,
+	.set_coalesce = m_can_set_coalesce,
 };
 
 static int register_m_can_dev(struct net_device *dev)
-- 
2.39.0


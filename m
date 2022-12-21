Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3039C653344
	for <lists+netdev@lfdr.de>; Wed, 21 Dec 2022 16:26:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234762AbiLUP0Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Dec 2022 10:26:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234683AbiLUP0A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Dec 2022 10:26:00 -0500
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D6B812ABA
        for <netdev@vger.kernel.org>; Wed, 21 Dec 2022 07:25:52 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id bj12so37537593ejb.13
        for <netdev@vger.kernel.org>; Wed, 21 Dec 2022 07:25:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7qkv359vs+V03J9W3PEiKayIw2ITJGoxZQc1nNZiMa0=;
        b=jYNtoHPQcv86qHwAc21NMAy0uCh7Ev9M+xF1Fue6qX2ybYd0A8C8fREC9nPRZ7fjUo
         CGUiEkYVTrJ3btOpVADkOwzwnFf67C9ASyUksqh4gAfYBDjx7wdLPXvpeQBw0VJVsN16
         ELVE3/C5wqlk57AkAd+qfO7FkpSyM4f/BsHuqEinUeBVUXSbKbS2wbQttQP1pVIvNjbv
         y83XC2gDs+NbSk1gAkrhJSEXO/SpWhr5Yk8Akg/mM5OwFOWRSzPeh6RmDLfRh7MVFUh9
         juTVAR7500B02t3uia+waPRYzIZIoGrwMexI+TZEZkfNsLzDY3CkEpHn/l+vQv49F4b5
         0V7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7qkv359vs+V03J9W3PEiKayIw2ITJGoxZQc1nNZiMa0=;
        b=jLu5wiNAHTF1yP4XbJ5avi6ZauviBamB+9jTU5PJxPmMQsGqW9ayu3Q4Rj0ACDfED0
         NeUTsAH1vHhcW6ERDSEHC5hgmli6MOmGtKYBlXEJBMDJ6eojr4GeVhE2W39qKVfoi71w
         U7ZHIF4MWgYVSXZpgWH3AmSqCHxxY0kBTSlIv+q0WRJIl/E7IiKNUd8BDCanTQej6FOj
         r32Zd8uVs6Xqp0GXUd1JOPs36tv4dK7uAhy3GN2e0GZPPztXzaiEYj4mhy2iU/WX0emN
         iuutG4cXWHAE66bMyTsrtv5IWfTsqaAekuhcBti2QMkuiKi1paeuB9yA4KtREkiyDxgQ
         2C3A==
X-Gm-Message-State: AFqh2koSqQu62G1LVTsIVtjjimjSAFThrsURan453l94DdALTAYDlOYW
        H4YdAS0kF0rhn4hFUBjRGZiayQ==
X-Google-Smtp-Source: AMrXdXu81S7HNvpCDpU2jleiliCs7ibmwUsBthVQXINrqRWS1I2VNqN7+qR6R0qQWqiRSDx16PUBHA==
X-Received: by 2002:a17:906:30d3:b0:838:9b81:1c98 with SMTP id b19-20020a17090630d300b008389b811c98mr1648212ejb.1.1671636350915;
        Wed, 21 Dec 2022 07:25:50 -0800 (PST)
Received: from blmsp.fritz.box ([2001:4091:a245:805c:8713:84e4:2a9e:cbe8])
        by smtp.gmail.com with ESMTPSA id n19-20020aa7c793000000b0045cf4f72b04sm7105428eds.94.2022.12.21.07.25.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Dec 2022 07:25:50 -0800 (PST)
From:   Markus Schneider-Pargmann <msp@baylibre.com>
To:     Marc Kleine-Budde <mkl@pengutronix.de>,
        Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Wolfgang Grandegger <wg@grandegger.com>
Cc:     Vincent MAILHOL <mailhol.vincent@wanadoo.fr>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Markus Schneider-Pargmann <msp@baylibre.com>
Subject: [PATCH 11/18] can: m_can: Add rx coalescing ethtool support
Date:   Wed, 21 Dec 2022 16:25:30 +0100
Message-Id: <20221221152537.751564-12-msp@baylibre.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221221152537.751564-1-msp@baylibre.com>
References: <20221221152537.751564-1-msp@baylibre.com>
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
index a84a17386c02..4d6fc8ade4d6 100644
--- a/drivers/net/can/m_can/m_can.c
+++ b/drivers/net/can/m_can/m_can.c
@@ -1909,8 +1909,54 @@ static const struct net_device_ops m_can_netdev_ops = {
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
2.38.1


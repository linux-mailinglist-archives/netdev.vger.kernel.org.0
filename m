Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF4F7547CA7
	for <lists+netdev@lfdr.de>; Sun, 12 Jun 2022 23:43:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236843AbiFLVlh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Jun 2022 17:41:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237514AbiFLVlT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Jun 2022 17:41:19 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4860E2FE67
        for <netdev@vger.kernel.org>; Sun, 12 Jun 2022 14:40:33 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id kq6so7662738ejb.11
        for <netdev@vger.kernel.org>; Sun, 12 Jun 2022 14:40:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amarulasolutions.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6efkiC5TQ5d8cecscsrXOmD2HlmxuShBu5gYbYTpObM=;
        b=gkAi7IMOOIGcRbSgxyuwNuF+yLKH5vQfyxa+wwgE54dvDLD/gkJ65zcvVF3CVDIA99
         Nf2msatumXRQ/PinSPOFZacm2A+UMAVMBdKGzFQGE9p68kb8QqPpPoF4ajerF5xIuFYI
         LUIIi8dzgnhI9dI4kK3MT8SxDdKo1hcgk8qzU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6efkiC5TQ5d8cecscsrXOmD2HlmxuShBu5gYbYTpObM=;
        b=LOqOXT9yaszlObNrVNw/E2kzqf9vkYHswa8daVjdHQH6rnfpopmqRNyl/hnvLl7gFL
         rw/XFpoGcu0oVKwzWmXo6Y3sY8L/RoyVU+RQWlYvhuheNM3YMldJwhqUoUvlVRwqJ/QD
         osgagXUPyBXVn72uTvRcCjkRGJeInEoX8gh+M5licwGJwF/WIm90L6jCpEZLOhhwBZyh
         GYgqaGQGl1+qKxJKOqbLvK7V3ihTAXjZ26+KZN1AKvh1hnj3SPB61jHe946hMm+L5PQN
         TZSBC6X1SsgBB6vYtbe4G5vv49eVqyDJaUWki5h/AMo484rPCVP6uSPg/WQMmdXQdTK6
         jEcw==
X-Gm-Message-State: AOAM533ScApYBzaS8Lz7EdOUDzWRrdnGEEipDVJAM9HcX+SPqecg6uX4
        lWyyp42fxN34sbhytsB6CyUBJg==
X-Google-Smtp-Source: ABdhPJz+w92q3G2uw+ykCJPkHvxDtHSA6uDD3Z79m2a5NYbWqLtv19nrHeaI40rCsGt5F8VVzKAqJg==
X-Received: by 2002:a17:907:9605:b0:6f5:c66:7c13 with SMTP id gb5-20020a170907960500b006f50c667c13mr49390538ejc.66.1655070032889;
        Sun, 12 Jun 2022 14:40:32 -0700 (PDT)
Received: from dario-ThinkPad-T14s-Gen-2i.homenet.telecomitalia.it (host-80-116-90-174.pool80116.interbusiness.it. [80.116.90.174])
        by smtp.gmail.com with ESMTPSA id u10-20020a1709061daa00b00711d546f8a8sm2909398ejh.139.2022.06.12.14.40.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Jun 2022 14:40:32 -0700 (PDT)
From:   Dario Binacchi <dario.binacchi@amarulasolutions.com>
To:     linux-kernel@vger.kernel.org
Cc:     michael@amarulasolutions.com,
        Amarula patchwork <linux-amarula@amarulasolutions.com>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Dario Binacchi <dario.binacchi@amarulasolutions.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Slaby <jirislaby@kernel.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Paolo Abeni <pabeni@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Wolfgang Grandegger <wg@grandegger.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH v3 13/13] can: slcan: extend the protocol with CAN state info
Date:   Sun, 12 Jun 2022 23:39:27 +0200
Message-Id: <20220612213927.3004444-14-dario.binacchi@amarulasolutions.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220612213927.3004444-1-dario.binacchi@amarulasolutions.com>
References: <20220612213927.3004444-1-dario.binacchi@amarulasolutions.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It extends the protocol to receive the adapter CAN state changes
(warning, busoff, etc.) and forward them to the netdev upper levels.

Signed-off-by: Dario Binacchi <dario.binacchi@amarulasolutions.com>

---

Changes in v3:
- Drop the patch "can: slcan: simplify the device de-allocation".
- Add the patch "can: netlink: dump bitrate 0 if can_priv::bittiming.bitrate is -1U".

Changes in v2:
- Continue error handling even if no skb can be allocated.

 drivers/net/can/slcan/slcan-core.c | 66 ++++++++++++++++++++++++++++++
 1 file changed, 66 insertions(+)

diff --git a/drivers/net/can/slcan/slcan-core.c b/drivers/net/can/slcan/slcan-core.c
index 48077edb9497..5ba1c141f942 100644
--- a/drivers/net/can/slcan/slcan-core.c
+++ b/drivers/net/can/slcan/slcan-core.c
@@ -78,6 +78,9 @@ MODULE_PARM_DESC(maxdev, "Maximum number of slcan interfaces");
 #define SLC_CMD_LEN 1
 #define SLC_SFF_ID_LEN 3
 #define SLC_EFF_ID_LEN 8
+#define SLC_STATE_LEN 1
+#define SLC_STATE_BE_RXCNT_LEN 3
+#define SLC_STATE_BE_TXCNT_LEN 3
 
 struct slcan {
 	struct can_priv         can;
@@ -175,6 +178,67 @@ int slcan_enable_err_rst_on_open(struct net_device *ndev, bool on)
   *			STANDARD SLCAN DECAPSULATION			 *
   ************************************************************************/
 
+static void slc_bump_state(struct slcan *sl)
+{
+	struct net_device *dev = sl->dev;
+	struct sk_buff *skb;
+	struct can_frame *cf;
+	char *cmd = sl->rbuff;
+	u32 rxerr, txerr;
+	enum can_state state, rx_state, tx_state;
+
+	if (*cmd != 's')
+		return;
+
+	cmd += SLC_CMD_LEN;
+	switch (*cmd) {
+	case 'a':
+		state = CAN_STATE_ERROR_ACTIVE;
+		break;
+	case 'w':
+		state = CAN_STATE_ERROR_WARNING;
+		break;
+	case 'p':
+		state = CAN_STATE_ERROR_PASSIVE;
+		break;
+	case 'f':
+		state = CAN_STATE_BUS_OFF;
+		break;
+	default:
+		return;
+	}
+
+	if (state == sl->can.state)
+		return;
+
+	cmd += SLC_STATE_BE_RXCNT_LEN + 1;
+	cmd[SLC_STATE_BE_TXCNT_LEN] = 0;
+	if (kstrtou32(cmd, 10, &txerr))
+		return;
+
+	*cmd = 0;
+	cmd -= SLC_STATE_BE_RXCNT_LEN;
+	if (kstrtou32(cmd, 10, &rxerr))
+		return;
+
+	skb = alloc_can_err_skb(dev, &cf);
+
+	if (skb) {
+		cf->data[6] = txerr;
+		cf->data[7] = rxerr;
+	}
+
+	tx_state = txerr >= rxerr ? state : 0;
+	rx_state = txerr <= rxerr ? state : 0;
+	can_change_state(dev, skb ? cf : NULL, tx_state, rx_state);
+
+	if (state == CAN_STATE_BUS_OFF)
+		can_bus_off(dev);
+
+	if (skb)
+		netif_rx(skb);
+}
+
 static void slc_bump_err(struct slcan *sl)
 {
 	struct net_device *dev = sl->dev;
@@ -378,6 +442,8 @@ static void slc_bump(struct slcan *sl)
 		return slc_bump_frame(sl);
 	case 'e':
 		return slc_bump_err(sl);
+	case 's':
+		return slc_bump_state(sl);
 	default:
 		return;
 	}
-- 
2.32.0


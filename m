Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5998E54B0E4
	for <lists+netdev@lfdr.de>; Tue, 14 Jun 2022 14:37:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243343AbiFNM3d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jun 2022 08:29:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244028AbiFNM2o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jun 2022 08:28:44 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AA75237C0
        for <netdev@vger.kernel.org>; Tue, 14 Jun 2022 05:28:43 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id z7so11366638edm.13
        for <netdev@vger.kernel.org>; Tue, 14 Jun 2022 05:28:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amarulasolutions.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jYzinqDMpP0ikE9sweLWXVziLbiFyEvA5RI0XjmyrwA=;
        b=Imdk9ZoAO7r/Y6UVbKyaxge6cRhAyLHgqo3qmRoll6SHjI2N9ANOIGfYQIMaeNGSth
         ra88H+SQDybPy9pjjuWUAgxHAjKq81PjEvGEpTd0lW60HFGyiaiObr2EsRI7CMA0w6v/
         227Sy3qPSjAcxRr+VJ96cM8sgfSp70zYhzT98=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jYzinqDMpP0ikE9sweLWXVziLbiFyEvA5RI0XjmyrwA=;
        b=v6BAI+2DFUPNpAE7Ch+kF/ZJt5D5gng7g45wxbOHwcdU+OsjGuo6jexCpXpS4Y3I67
         zLnwE422vOWuYVfsniMIGAMes+N5wY7MJ2gIgahVsYAqj/HgOsbQaaV/txeqQaQvbc4O
         DZ5Mt92dojW5BjmqUXqTFjFrQhMy5p9diG0XlHwnvYTW6iWsKpC3b6Tu1k/iwGzq91UN
         d1g2D2RUYaz+J1NrBrK4bMpN3XiNcbI1VeEE/Xm5TfiQvwwBiO6rqP+OH3aOaAbtui1l
         XiZaoEXGa2fnyp+69qSWerybof/9/oGTu6bjoNk127Pkd8JjMNtHsvo7VBXw+dMFE5z6
         spVA==
X-Gm-Message-State: AJIora9a2WgqNUOV88wxQkjKY5oBctOABCj1YY68/qveMdN/sE7onvRm
        bwQMKFpCLyrR7hDXTUUSl0YXrA==
X-Google-Smtp-Source: AGRyM1sdy+mQgJGKcTg6pr0d+IxotebryiK/R/VGzkIZerKFSEHj3SGvS1zYgLu1DOiAntsMFGuuxg==
X-Received: by 2002:aa7:c604:0:b0:42d:cffb:f4dc with SMTP id h4-20020aa7c604000000b0042dcffbf4dcmr5869600edq.270.1655209722774;
        Tue, 14 Jun 2022 05:28:42 -0700 (PDT)
Received: from dario-ThinkPad-T14s-Gen-2i.amarulasolutions.com (host-80-116-90-174.pool80116.interbusiness.it. [80.116.90.174])
        by smtp.gmail.com with ESMTPSA id z22-20020a17090655d600b006f3ef214e2csm5087043ejp.146.2022.06.14.05.28.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jun 2022 05:28:42 -0700 (PDT)
From:   Dario Binacchi <dario.binacchi@amarulasolutions.com>
To:     linux-kernel@vger.kernel.org
Cc:     Amarula patchwork <linux-amarula@amarulasolutions.com>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        michael@amarulasolutions.com,
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
Subject: [PATCH v4 12/12] can: slcan: extend the protocol with CAN state info
Date:   Tue, 14 Jun 2022 14:28:21 +0200
Message-Id: <20220614122821.3646071-13-dario.binacchi@amarulasolutions.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220614122821.3646071-1-dario.binacchi@amarulasolutions.com>
References: <20220614122821.3646071-1-dario.binacchi@amarulasolutions.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
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

Changes in v4:
- Add description of slc_bump_state() function.
- Remove check for the 's' character at the beggining of the function.
  It was already checked by the caller function.
- Protect decoding against the case the frame len is longer than the
  received data (add SLC_STATE_FRAME_LEN macro).
- Set cf to NULL in case of alloc_can_err_skb() failure.
- Some small changes to make the decoding more readable.
- Use the character 'b' instead of 'f' for bus-off state.

Changes in v3:
- Drop the patch "can: slcan: simplify the device de-allocation".
- Add the patch "can: netlink: dump bitrate 0 if can_priv::bittiming.bitrate is -1U".

Changes in v2:
- Continue error handling even if no skb can be allocated.

 drivers/net/can/slcan/slcan-core.c | 74 +++++++++++++++++++++++++++++-
 1 file changed, 73 insertions(+), 1 deletion(-)

diff --git a/drivers/net/can/slcan/slcan-core.c b/drivers/net/can/slcan/slcan-core.c
index 6c7c815eaf45..e2d7645ff8d2 100644
--- a/drivers/net/can/slcan/slcan-core.c
+++ b/drivers/net/can/slcan/slcan-core.c
@@ -78,7 +78,11 @@ MODULE_PARM_DESC(maxdev, "Maximum number of slcan interfaces");
 #define SLC_CMD_LEN 1
 #define SLC_SFF_ID_LEN 3
 #define SLC_EFF_ID_LEN 8
-
+#define SLC_STATE_LEN 1
+#define SLC_STATE_BE_RXCNT_LEN 3
+#define SLC_STATE_BE_TXCNT_LEN 3
+#define SLC_STATE_FRAME_LEN       (1 + SLC_CMD_LEN + SLC_STATE_BE_RXCNT_LEN + \
+				   SLC_STATE_BE_TXCNT_LEN)
 struct slcan {
 	struct can_priv         can;
 	int			magic;
@@ -255,6 +259,72 @@ static void slc_bump_frame(struct slcan *sl)
 	dev_kfree_skb(skb);
 }
 
+/* A change state frame must contain state info and receive and transmit
+ * error counters.
+ *
+ * Examples:
+ *
+ * sb256256 : state bus-off: rx counter 256, tx counter 256
+ * sa057033 : state active, rx counter 57, tx counter 33
+ */
+static void slc_bump_state(struct slcan *sl)
+{
+	struct net_device *dev = sl->dev;
+	struct sk_buff *skb;
+	struct can_frame *cf;
+	char *cmd = sl->rbuff;
+	u32 rxerr, txerr;
+	enum can_state state, rx_state, tx_state;
+
+	switch (cmd[1]) {
+	case 'a':
+		state = CAN_STATE_ERROR_ACTIVE;
+		break;
+	case 'w':
+		state = CAN_STATE_ERROR_WARNING;
+		break;
+	case 'p':
+		state = CAN_STATE_ERROR_PASSIVE;
+		break;
+	case 'b':
+		state = CAN_STATE_BUS_OFF;
+		break;
+	default:
+		return;
+	}
+
+	if (state == sl->can.state || sl->rcount < SLC_STATE_FRAME_LEN)
+		return;
+
+	cmd += SLC_STATE_BE_RXCNT_LEN + SLC_CMD_LEN + 1;
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
+	if (skb) {
+		cf->data[6] = txerr;
+		cf->data[7] = rxerr;
+	} else {
+		cf = NULL;
+	}
+
+	tx_state = txerr >= rxerr ? state : 0;
+	rx_state = txerr <= rxerr ? state : 0;
+	can_change_state(dev, cf, tx_state, rx_state);
+
+	if (state == CAN_STATE_BUS_OFF)
+		can_bus_off(dev);
+
+	if (skb)
+		netif_rx(skb);
+}
+
 /* An error frame can contain more than one type of error.
  *
  * Examples:
@@ -388,6 +458,8 @@ static void slc_bump(struct slcan *sl)
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


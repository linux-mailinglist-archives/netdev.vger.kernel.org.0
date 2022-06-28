Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A73C55E9FD
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 18:42:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237400AbiF1QgQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 12:36:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237767AbiF1Qe7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 12:34:59 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5933F35877
        for <netdev@vger.kernel.org>; Tue, 28 Jun 2022 09:32:05 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id d2so15169658ejy.1
        for <netdev@vger.kernel.org>; Tue, 28 Jun 2022 09:32:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amarulasolutions.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dlTOY2xvVGa6BOY+C/5W0PL43wDapCN5T2ZQIpzidGs=;
        b=FFGuQTgNFPUOJy7W7LyC6yuBr+1gnvvgi5oICNleFC9tYjsV7E65ZItYDQYG7QxPMu
         MYIGFHznp0t0+2QDquc6gaj6dHhvwNNv+YdX7n2h4XyOO0mGYF8/Tc+AeoWBnrTskmRA
         IKRfOaJ1/XK68brtxVVQKiW43xvrFYdzhNbLo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dlTOY2xvVGa6BOY+C/5W0PL43wDapCN5T2ZQIpzidGs=;
        b=ViOaqSZQFFwtJEhgz7JPLzO35CU7lqaSEh3tpM7j7H9+B8OUoClNjWNXmuWQ1cPVum
         /wDDTV7htozqBQOdoD6sqKrLcFm+oz5U+PRh457OnOSkFxMO/NNjNPpfeA9jd5cFYw2/
         sAW4ay8t4VaOuC0m1FNbgg3sbrfDh+ZNXPHRMKAh/gjTojdVCl2XR24P6GbWA0ecgGTk
         yDss+rgl40Hk+TrRbRNeSXz6jjUk0RRezZLjGhWkav9RqN6fFiLLMGefsIw7NsEwzCOW
         X4666Fl/Uulc/RlcGSA20ddgep39ljtxBdSpiU2VaFXauxc5y0jWyqrOgonthTnptaBd
         ClvQ==
X-Gm-Message-State: AJIora9CFm7Weuz5lsUcEgk1Kxzu7EwYoIHdVHtKmKYoef6azy1Zx/8Q
        RmkxcTbXNIK0lj0NLWzpuDN53A==
X-Google-Smtp-Source: AGRyM1vx3ooj/k5/B7RWpo8vUen0e+1A7wWHA37jOfUxzwtSR3c2Ip2cIO8jdB2tCXVi8ls/o9KiGw==
X-Received: by 2002:a17:907:94d4:b0:722:e4b8:c2f2 with SMTP id dn20-20020a17090794d400b00722e4b8c2f2mr18565878ejc.527.1656433924935;
        Tue, 28 Jun 2022 09:32:04 -0700 (PDT)
Received: from dario-ThinkPad-T14s-Gen-2i.homenet.telecomitalia.it (host-80-116-90-174.pool80116.interbusiness.it. [80.116.90.174])
        by smtp.gmail.com with ESMTPSA id b20-20020a0564021f1400b0042e15364d14sm9916952edb.8.2022.06.28.09.32.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jun 2022 09:32:04 -0700 (PDT)
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
Subject: [PATCH v5 11/12] can: slcan: extend the protocol with error info
Date:   Tue, 28 Jun 2022 18:31:35 +0200
Message-Id: <20220628163137.413025-12-dario.binacchi@amarulasolutions.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220628163137.413025-1-dario.binacchi@amarulasolutions.com>
References: <20220628163137.413025-1-dario.binacchi@amarulasolutions.com>
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

It extends the protocol to receive the adapter CAN communication errors
and forward them to the netdev upper levels.

Signed-off-by: Dario Binacchi <dario.binacchi@amarulasolutions.com>

---

(no changes since v4)

Changes in v4:
- Add description of slc_bump_err() function.
- Remove check for the 'e' character at the beggining of the function.
  It was already checked by the caller function.
- Protect decoding against the case the len value is longer than the
  received data.
- Some small changes to make the decoding more readable.
- Increment all the error counters at the end of the function.

Changes in v2:
- Protect decoding against the case the len value is longer than the
  received data.
- Continue error handling even if no skb can be allocated.

 drivers/net/can/slcan/slcan-core.c | 140 ++++++++++++++++++++++++++++-
 1 file changed, 139 insertions(+), 1 deletion(-)

diff --git a/drivers/net/can/slcan/slcan-core.c b/drivers/net/can/slcan/slcan-core.c
index c1fd1e934d93..4269b2267be2 100644
--- a/drivers/net/can/slcan/slcan-core.c
+++ b/drivers/net/can/slcan/slcan-core.c
@@ -175,7 +175,7 @@ int slcan_enable_err_rst_on_open(struct net_device *ndev, bool on)
   ************************************************************************/
 
 /* Send one completely decapsulated can_frame to the network layer */
-static void slc_bump(struct slcan *sl)
+static void slc_bump_frame(struct slcan *sl)
 {
 	struct sk_buff *skb;
 	struct can_frame *cf;
@@ -254,6 +254,144 @@ static void slc_bump(struct slcan *sl)
 	dev_kfree_skb(skb);
 }
 
+/* An error frame can contain more than one type of error.
+ *
+ * Examples:
+ *
+ * e1a : len 1, errors: ACK error
+ * e3bcO: len 3, errors: Bit0 error, CRC error, Tx overrun error
+ */
+static void slc_bump_err(struct slcan *sl)
+{
+	struct net_device *dev = sl->dev;
+	struct sk_buff *skb;
+	struct can_frame *cf;
+	char *cmd = sl->rbuff;
+	bool rx_errors = false, tx_errors = false, rx_over_errors = false;
+	int i, len;
+
+	/* get len from sanitized ASCII value */
+	len = cmd[1];
+	if (len >= '0' && len < '9')
+		len -= '0';
+	else
+		return;
+
+	if ((len + SLC_CMD_LEN + 1) > sl->rcount)
+		return;
+
+	skb = alloc_can_err_skb(dev, &cf);
+
+	if (skb)
+		cf->can_id |= CAN_ERR_PROT | CAN_ERR_BUSERROR;
+
+	cmd += SLC_CMD_LEN + 1;
+	for (i = 0; i < len; i++, cmd++) {
+		switch (*cmd) {
+		case 'a':
+			netdev_dbg(dev, "ACK error\n");
+			tx_errors = true;
+			if (skb) {
+				cf->can_id |= CAN_ERR_ACK;
+				cf->data[3] = CAN_ERR_PROT_LOC_ACK;
+			}
+
+			break;
+		case 'b':
+			netdev_dbg(dev, "Bit0 error\n");
+			tx_errors = true;
+			if (skb)
+				cf->data[2] |= CAN_ERR_PROT_BIT0;
+
+			break;
+		case 'B':
+			netdev_dbg(dev, "Bit1 error\n");
+			tx_errors = true;
+			if (skb)
+				cf->data[2] |= CAN_ERR_PROT_BIT1;
+
+			break;
+		case 'c':
+			netdev_dbg(dev, "CRC error\n");
+			rx_errors = true;
+			if (skb) {
+				cf->data[2] |= CAN_ERR_PROT_BIT;
+				cf->data[3] = CAN_ERR_PROT_LOC_CRC_SEQ;
+			}
+
+			break;
+		case 'f':
+			netdev_dbg(dev, "Form Error\n");
+			rx_errors = true;
+			if (skb)
+				cf->data[2] |= CAN_ERR_PROT_FORM;
+
+			break;
+		case 'o':
+			netdev_dbg(dev, "Rx overrun error\n");
+			rx_over_errors = true;
+			rx_errors = true;
+			if (skb) {
+				cf->can_id |= CAN_ERR_CRTL;
+				cf->data[1] = CAN_ERR_CRTL_RX_OVERFLOW;
+			}
+
+			break;
+		case 'O':
+			netdev_dbg(dev, "Tx overrun error\n");
+			tx_errors = true;
+			if (skb) {
+				cf->can_id |= CAN_ERR_CRTL;
+				cf->data[1] = CAN_ERR_CRTL_TX_OVERFLOW;
+			}
+
+			break;
+		case 's':
+			netdev_dbg(dev, "Stuff error\n");
+			rx_errors = true;
+			if (skb)
+				cf->data[2] |= CAN_ERR_PROT_STUFF;
+
+			break;
+		default:
+			if (skb)
+				dev_kfree_skb(skb);
+
+			return;
+		}
+	}
+
+	if (rx_errors)
+		dev->stats.rx_errors++;
+
+	if (rx_over_errors)
+		dev->stats.rx_over_errors++;
+
+	if (tx_errors)
+		dev->stats.tx_errors++;
+
+	if (skb)
+		netif_rx(skb);
+}
+
+static void slc_bump(struct slcan *sl)
+{
+	switch (sl->rbuff[0]) {
+	case 'r':
+		fallthrough;
+	case 't':
+		fallthrough;
+	case 'R':
+		fallthrough;
+	case 'T':
+		return slc_bump_frame(sl);
+	case 'e':
+		return slc_bump_err(sl);
+	default:
+		return;
+	}
+}
+
 /* parse tty input stream */
 static void slcan_unesc(struct slcan *sl, unsigned char s)
 {
-- 
2.32.0


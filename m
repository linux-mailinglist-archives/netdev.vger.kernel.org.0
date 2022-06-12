Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D330547CAD
	for <lists+netdev@lfdr.de>; Sun, 12 Jun 2022 23:43:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236761AbiFLVlf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Jun 2022 17:41:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237225AbiFLVlF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Jun 2022 17:41:05 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFDEB2AE0D
        for <netdev@vger.kernel.org>; Sun, 12 Jun 2022 14:40:28 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id gl15so7712299ejb.4
        for <netdev@vger.kernel.org>; Sun, 12 Jun 2022 14:40:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amarulasolutions.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=P8N6mZ+VdIxDHB3ERFZNuvKgcE/qcXFBtcxLWjsi6yU=;
        b=qYQO15I8ouBWG3nzQVKzDy0l5yfrVKs2RfJvILCb7ee/vE9KuIwTO/uxK2j5jv0no9
         E66rq0iKFVjF1W3vdr9JDgUdIIPrajXRxgvtUz0AOk3gJOCodQfUhtdaCBs70zf1+4i2
         0f8o7DJFbrFzIxC6izhz/jXCYZ3QCeKkATWJE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=P8N6mZ+VdIxDHB3ERFZNuvKgcE/qcXFBtcxLWjsi6yU=;
        b=Yycq6EcIuGSl6BV1xnytZy/lSMY0PK+OsyH7XehTapC2jaR7X9YeG+n6ll+EnNnpoZ
         CErkbUz1DUHuFMVe27/9v+hjyYZSDkz12+ki2oauyqr3Oe7hkVtLMlN1wNhe8pimyjQc
         MTdjeSoVDp1c6aL4UIBrD2bPyWYRT+AaqOojhWhsO5wE4ZHpumw/Dd8WDVI3XnZcsSOX
         ucLeqcn1kHDCbi9QYayOTWehxc9bQ+c1J94s48OTpDt+x3bl3qTPNjA9eMsNkLWDN1zR
         EcyRUJMGTOqW7gNO7FZ7Ivw7QiMuEgBwE1IFKXDvHgBNTI8SmzdLsf0WcHqB01RlNTrx
         h8Yw==
X-Gm-Message-State: AOAM5301oj+2uVjNDJYUPeDwJxaaevhIdHoynSS0mw8AsIA2qoPoj9Cw
        eex6CPzitYHG0r9kSt5BGhfs3Q==
X-Google-Smtp-Source: ABdhPJyUeiYzT1GYIfPFtuWvZIsAAUx4pBf+/bipXCF0qgcMdvrgIdqg9PmRTntQVDLBlBuOwtPYxA==
X-Received: by 2002:a17:906:6947:b0:711:a86b:6780 with SMTP id c7-20020a170906694700b00711a86b6780mr37988734ejs.686.1655070028311;
        Sun, 12 Jun 2022 14:40:28 -0700 (PDT)
Received: from dario-ThinkPad-T14s-Gen-2i.homenet.telecomitalia.it (host-80-116-90-174.pool80116.interbusiness.it. [80.116.90.174])
        by smtp.gmail.com with ESMTPSA id u10-20020a1709061daa00b00711d546f8a8sm2909398ejh.139.2022.06.12.14.40.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Jun 2022 14:40:27 -0700 (PDT)
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
Subject: [PATCH v3 12/13] can: slcan: extend the protocol with error info
Date:   Sun, 12 Jun 2022 23:39:26 +0200
Message-Id: <20220612213927.3004444-13-dario.binacchi@amarulasolutions.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220612213927.3004444-1-dario.binacchi@amarulasolutions.com>
References: <20220612213927.3004444-1-dario.binacchi@amarulasolutions.com>
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

(no changes since v2)

Changes in v2:
- Protect decoding against the case the len value is longer than the
  received data.
- Continue error handling even if no skb can be allocated.

 drivers/net/can/slcan/slcan-core.c | 130 ++++++++++++++++++++++++++++-
 1 file changed, 129 insertions(+), 1 deletion(-)

diff --git a/drivers/net/can/slcan/slcan-core.c b/drivers/net/can/slcan/slcan-core.c
index 3df35ae8f040..48077edb9497 100644
--- a/drivers/net/can/slcan/slcan-core.c
+++ b/drivers/net/can/slcan/slcan-core.c
@@ -175,8 +175,118 @@ int slcan_enable_err_rst_on_open(struct net_device *ndev, bool on)
   *			STANDARD SLCAN DECAPSULATION			 *
   ************************************************************************/
 
+static void slc_bump_err(struct slcan *sl)
+{
+	struct net_device *dev = sl->dev;
+	struct sk_buff *skb;
+	struct can_frame *cf;
+	char *cmd = sl->rbuff;
+	bool rx_errors = false, tx_errors = false;
+	int i, len;
+
+	if (*cmd != 'e')
+		return;
+
+	cmd += SLC_CMD_LEN;
+	/* get len from sanitized ASCII value */
+	len = *cmd++;
+	if (len >= '0' && len < '9')
+		len -= '0';
+	else
+		return;
+
+	skb = alloc_can_err_skb(dev, &cf);
+
+	if (skb)
+		cf->can_id |= CAN_ERR_PROT | CAN_ERR_BUSERROR;
+
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
+			dev->stats.rx_over_errors++;
+			dev->stats.rx_errors++;
+			if (skb) {
+				cf->can_id |= CAN_ERR_CRTL;
+				cf->data[1] = CAN_ERR_CRTL_RX_OVERFLOW;
+			}
+
+			break;
+		case 'O':
+			netdev_dbg(dev, "Tx overrun error\n");
+			dev->stats.tx_errors++;
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
+	if (tx_errors)
+		dev->stats.tx_errors++;
+
+	if (skb)
+		netif_rx(skb);
+}
+
 /* Send one completely decapsulated can_frame to the network layer */
-static void slc_bump(struct slcan *sl)
+static void slc_bump_frame(struct slcan *sl)
 {
 	struct sk_buff *skb;
 	struct can_frame *cf;
@@ -255,6 +365,24 @@ static void slc_bump(struct slcan *sl)
 	dev_kfree_skb(skb);
 }
 
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


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 335C954B0EA
	for <lists+netdev@lfdr.de>; Tue, 14 Jun 2022 14:37:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356847AbiFNM3i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jun 2022 08:29:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243963AbiFNM2n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jun 2022 08:28:43 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB9C222BF5
        for <netdev@vger.kernel.org>; Tue, 14 Jun 2022 05:28:42 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id me5so16891899ejb.2
        for <netdev@vger.kernel.org>; Tue, 14 Jun 2022 05:28:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amarulasolutions.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=UY9xGJVeCuDiPWb4quL1k0Um37OolG5UZs6VBw/8AE4=;
        b=Ja543dMnsKVa7wE7vuA6UlJiYXkD9BavIblMmMDRdLnKW7bCJrM2IIjuTxTLUa4zc7
         uVtITCAEoFl0NcEewAfa1WXTa70NjmLqNp/cbTZMmJprWmqvGUMBnmcIZIxbJAcdjIrj
         0nAK46ia7vSr4W9Hz2eGoJjUjFYilr226hhXM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UY9xGJVeCuDiPWb4quL1k0Um37OolG5UZs6VBw/8AE4=;
        b=lASTZ9IeyJQEfSuTwhOyhi8zhyf2/Y42hpwrS+57FiFqfFMLoIJLO8H7Yp6zwgfxd2
         RRnm3jIkPmRPIjJIidEHDQUgD4hpoYoq0jroHV2ExWyHiAXQA4z7bYmdilmi9B+RNE17
         NcPQskyQWdcy2QfrYJ7UPD7caSCf3lbluZW8QvzyQQL+oR1/wQrnLp8rZpKAV1kt0tNT
         /zYsEVR+irjPRmeZhTHxPP9WQdvLk/pieLQ9QY5FZpCe125hiGewT8c6WUaYVDGyUh8a
         f8Gurhr4Tf7Oj5Bl1aXcH6wx19eg3evXSM2Rgncky8eibu0LDVPL4oim6AcfBw5bc0Gj
         lsqA==
X-Gm-Message-State: AOAM530qWixNkk7RHgl9D2PJy8Yq5zxTRpFsRgahlJhQjlwwY3kuqzvI
        2mLWxgMW3+TFvjo1UWYV2r4TBQ==
X-Google-Smtp-Source: ABdhPJwKLJW79JRioqe4q4q0L5vsiJcGfGbq3CLDF09ftdlAWx5GCdDH3yrVc9h4vQzyecCO5U90UA==
X-Received: by 2002:a17:906:4482:b0:70a:19e3:d18a with SMTP id y2-20020a170906448200b0070a19e3d18amr3911625ejo.510.1655209721319;
        Tue, 14 Jun 2022 05:28:41 -0700 (PDT)
Received: from dario-ThinkPad-T14s-Gen-2i.amarulasolutions.com (host-80-116-90-174.pool80116.interbusiness.it. [80.116.90.174])
        by smtp.gmail.com with ESMTPSA id z22-20020a17090655d600b006f3ef214e2csm5087043ejp.146.2022.06.14.05.28.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jun 2022 05:28:40 -0700 (PDT)
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
Subject: [PATCH v4 11/12] can: slcan: extend the protocol with error info
Date:   Tue, 14 Jun 2022 14:28:20 +0200
Message-Id: <20220614122821.3646071-12-dario.binacchi@amarulasolutions.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220614122821.3646071-1-dario.binacchi@amarulasolutions.com>
References: <20220614122821.3646071-1-dario.binacchi@amarulasolutions.com>
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

It extends the protocol to receive the adapter CAN communication errors
and forward them to the netdev upper levels.

Signed-off-by: Dario Binacchi <dario.binacchi@amarulasolutions.com>

---

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
index b4f29ab2ab72..6c7c815eaf45 100644
--- a/drivers/net/can/slcan/slcan-core.c
+++ b/drivers/net/can/slcan/slcan-core.c
@@ -176,7 +176,7 @@ int slcan_enable_err_rst_on_open(struct net_device *ndev, bool on)
   ************************************************************************/
 
 /* Send one completely decapsulated can_frame to the network layer */
-static void slc_bump(struct slcan *sl)
+static void slc_bump_frame(struct slcan *sl)
 {
 	struct sk_buff *skb;
 	struct can_frame *cf;
@@ -255,6 +255,144 @@ static void slc_bump(struct slcan *sl)
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


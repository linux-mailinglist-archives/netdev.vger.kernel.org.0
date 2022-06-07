Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C0D853FA50
	for <lists+netdev@lfdr.de>; Tue,  7 Jun 2022 11:51:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237653AbiFGJux (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jun 2022 05:50:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240197AbiFGJtG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jun 2022 05:49:06 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17FA9E8BAE
        for <netdev@vger.kernel.org>; Tue,  7 Jun 2022 02:48:36 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id u8so19008233wrm.13
        for <netdev@vger.kernel.org>; Tue, 07 Jun 2022 02:48:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amarulasolutions.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=52GScXsc3r0EaHze1UuoV0GZvaNkVo4y3j7sOuEIJJg=;
        b=rfbDySEIkeXsxScHE6waneBGxdkvnI60ZQfnEp5JSr5QC4sE+srEselhgT+QjckgqO
         6tCrd7AKmTQclOZuFHLyLrBrhuVMroHqP0zmUx+MieYmNYGug4n4s+Ur9luZ71tpZFrp
         1Nt+YEH1E8xe4mGJq11zLGFiK3mudUMFxMgpU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=52GScXsc3r0EaHze1UuoV0GZvaNkVo4y3j7sOuEIJJg=;
        b=aAI3dQFbYaLXZICT4rGD14zLGyTsez4yeRu4dSEKxWTBlJb779wy68CJqa4Z1W/JID
         xYGvM/FwIbD4LwbPsmh7jEELIzmytFYKekrhk2Da5D1Xm2k8rH5DqA7hMXajdBOJnlmU
         9MW3K8saJ9OxQ8n7cMyzc4OnKB9TYBFyM504w4E3+EHs37HqHvR6ycMCQFUlBqCW1XDn
         tWAEAM2b324gJRkr/tUPyppTQKuL8qi3d/oT4I+iBuvZxPXYKyoNQrqXzO24LQSqeTDV
         FXmv0Ov5PJbrnFSbVbS7Hiih0xKs9UMxaDnXc/bOYF+wPQHQXjNy4hlBPH1kS4p3Y+qX
         b6BQ==
X-Gm-Message-State: AOAM532WdDg9fvqj2/ubREiFby5l2jmo2aUDLjtlz55ck1KbYCxZns0m
        mFQLzV00cd51+BSJ+yYr2l2IOw==
X-Google-Smtp-Source: ABdhPJzaV7KVviwsHCw6xcXPhFjg7QhrHRaAxy2JTpnVmpydEdIsfELh6RDODEriaMU+7gdzBq4oAg==
X-Received: by 2002:a05:6000:1acc:b0:20f:e35e:450 with SMTP id i12-20020a0560001acc00b0020fe35e0450mr25901221wry.531.1654595316197;
        Tue, 07 Jun 2022 02:48:36 -0700 (PDT)
Received: from dario-ThinkPad-T14s-Gen-2i.pdxnet.pdxeng.ch (mob-5-90-137-51.net.vodafone.it. [5.90.137.51])
        by smtp.gmail.com with ESMTPSA id o4-20020a05600c510400b0039748be12dbsm23200547wms.47.2022.06.07.02.48.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jun 2022 02:48:35 -0700 (PDT)
From:   Dario Binacchi <dario.binacchi@amarulasolutions.com>
To:     linux-kernel@vger.kernel.org
Cc:     Amarula patchwork <linux-amarula@amarulasolutions.com>,
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
Subject: [RFC PATCH 13/13] can: slcan: extend the protocol with CAN state info
Date:   Tue,  7 Jun 2022 11:47:52 +0200
Message-Id: <20220607094752.1029295-14-dario.binacchi@amarulasolutions.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220607094752.1029295-1-dario.binacchi@amarulasolutions.com>
References: <20220607094752.1029295-1-dario.binacchi@amarulasolutions.com>
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

 drivers/net/can/slcan/slcan-core.c | 65 ++++++++++++++++++++++++++++++
 1 file changed, 65 insertions(+)

diff --git a/drivers/net/can/slcan/slcan-core.c b/drivers/net/can/slcan/slcan-core.c
index 02e7c14de45c..ab4c08a7dc81 100644
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
@@ -182,6 +185,66 @@ int slcan_enable_err_rst_on_open(struct net_device *ndev, bool on)
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
+	if (unlikely(!skb))
+		return;
+
+	cf->data[6] = txerr;
+	cf->data[7] = rxerr;
+
+	tx_state = txerr >= rxerr ? state : 0;
+	rx_state = txerr <= rxerr ? state : 0;
+	can_change_state(dev, cf, tx_state, rx_state);
+
+	if (state == CAN_STATE_BUS_OFF)
+		can_bus_off(dev);
+
+	netif_rx(skb);
+}
+
 static void slc_bump_err(struct slcan *sl)
 {
 	struct net_device *dev = sl->dev;
@@ -354,6 +417,8 @@ static void slc_bump(struct slcan *sl)
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


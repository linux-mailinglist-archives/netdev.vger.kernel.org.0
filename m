Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99731637CEB
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 16:25:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229998AbiKXPZP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Nov 2022 10:25:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229951AbiKXPZO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Nov 2022 10:25:14 -0500
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 514BF769ED;
        Thu, 24 Nov 2022 07:25:13 -0800 (PST)
Received: by mail-pg1-x529.google.com with SMTP id h193so1790779pgc.10;
        Thu, 24 Nov 2022 07:25:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ihmcpAV1uu+DHpKZV9irEtpd+m80Oyx9msRgKJnz1F0=;
        b=Twl/kMsZwxdO2ceWcTqv1XCLrINDgG2W35Mde55raeC4ydBLb3pDSfL/CBwFJw621d
         q/NpP37xFeuOxOpUpfhow2GP95UofXUf9Is9/Vu98iBQkUuX5A3Z8IYSA4rNAbOW+k4P
         eZFSkwcR9bX6262q4A8ySK68sxob1JDk2zn2BhUqEh/UwpRbGp+FwIfzKO5sSUs/HSrL
         CKpoLbqsqF6CVRoCmgZVbm7iwQfLbbHW2sFciiblOwTat80nyZivmoCAfmwCsrtjmf62
         7VZbwGXDpek7GmPLyNYTGwa2gw+55J3Zq8jELIeoZcQgCigqi+ytRb554TKsbh7wXXzu
         li7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ihmcpAV1uu+DHpKZV9irEtpd+m80Oyx9msRgKJnz1F0=;
        b=zfArut+XmKHzDWjVtMN+gXc7/CsKjiA83fGy6oX7oW3vHRAta9eMLwSHWhnXb+A1P8
         o5+GiBRYBDhoqkIDFxyzfcDmkiGumN1w7tBfWP1k2zEEnoy/8HCaOo/tijZKchUa0xlb
         f6B1q1O4do1lMyTPZZsrLUx1wUjiwxkd1Opuz/Y3q1VvhN3Yrf3xDsXM7C2mMIxWAxr2
         SsQ44UKFLUXvSdldKKhODY8JvdENLK5PrecBOoAiWOgCa66N8NKGTd6Ch/sL+Hn7ziVI
         RPkKRrZ5I9uLi0oAscpRLSu2siinpA4duYVXadxPJs/Ocn7iDSHnsj/YJobVlQWAia9Y
         aYzQ==
X-Gm-Message-State: ANoB5pm5P8O//bFkpVV8uBB0/GzbuniWn0u04CDI3oSH9TAjvxBG32R5
        O9Z4bDDQVM5OQjAOVgAmzarNltvipA8=
X-Google-Smtp-Source: AA0mqf6pZj3EYiRtNCVV7e1LyFWmOpfvQVsSQEPACrjcPoptXvdM3WWSNKN+wQZY9hi9k87PjZvQ4w==
X-Received: by 2002:a63:225d:0:b0:477:beb8:70f8 with SMTP id t29-20020a63225d000000b00477beb870f8mr6354923pgm.281.1669303512780;
        Thu, 24 Nov 2022 07:25:12 -0800 (PST)
Received: from x570.spacecubics.com (221x245x252x90.ap221.ftth.ucom.ne.jp. [221.245.252.90])
        by smtp.gmail.com with ESMTPSA id x13-20020aa79a4d000000b0056ba7cda4b5sm1399420pfj.16.2022.11.24.07.25.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Nov 2022 07:25:12 -0800 (PST)
From:   Yasushi SHOJI <yasushi.shoji@gmail.com>
X-Google-Original-From: Yasushi SHOJI <yashi@spacecubics.com>
To:     Yasushi SHOJI <yashi@spacecubics.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     remigiusz.kollataj@mobica.com, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2] can: mcba_usb: Fix termination command argument
Date:   Fri, 25 Nov 2022 00:25:03 +0900
Message-Id: <20221124152504.125994-1-yashi@spacecubics.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Microchip USB Analyzer can activate the internal termination resistors
by setting the "termination" option ON, or OFF to to deactivate them.
As I've observed, both with my oscilloscope and captured USB packets
below, you must send "0" to turn it ON, and "1" to turn it OFF.

From the schematics in the user's guide, I can confirm that you must
drive the CAN_RES signal LOW "0" to activate the resistors.

Reverse the argument value of usb_msg.termination to fix this.

These are the two commands sequence, ON then OFF.

> No.     Time           Source                Destination           Protocol Length Info
>       1 0.000000       host                  1.3.1                 USB      46     URB_BULK out
>
> Frame 1: 46 bytes on wire (368 bits), 46 bytes captured (368 bits)
> USB URB
> Leftover Capture Data: a80000000000000000000000000000000000a8
>
> No.     Time           Source                Destination           Protocol Length Info
>       2 4.372547       host                  1.3.1                 USB      46     URB_BULK out
>
> Frame 2: 46 bytes on wire (368 bits), 46 bytes captured (368 bits)
> USB URB
> Leftover Capture Data: a80100000000000000000000000000000000a9

Signed-off-by: Yasushi SHOJI <yashi@spacecubics.com>
---
 drivers/net/can/usb/mcba_usb.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/net/can/usb/mcba_usb.c b/drivers/net/can/usb/mcba_usb.c
index 218b098b261d..47619e9cb005 100644
--- a/drivers/net/can/usb/mcba_usb.c
+++ b/drivers/net/can/usb/mcba_usb.c
@@ -47,6 +47,10 @@
 #define MCBA_VER_REQ_USB 1
 #define MCBA_VER_REQ_CAN 2
 
+/* Drive the CAN_RES signal LOW "0" to activate R24 and R25 */
+#define MCBA_VER_TERMINATION_ON 0
+#define MCBA_VER_TERMINATION_OFF 1
+
 #define MCBA_SIDL_EXID_MASK 0x8
 #define MCBA_DLC_MASK 0xf
 #define MCBA_DLC_RTR_MASK 0x40
@@ -463,7 +467,7 @@ static void mcba_usb_process_ka_usb(struct mcba_priv *priv,
 		priv->usb_ka_first_pass = false;
 	}
 
-	if (msg->termination_state)
+	if (msg->termination_state == MCBA_VER_TERMINATION_ON)
 		priv->can.termination = MCBA_TERMINATION_ENABLED;
 	else
 		priv->can.termination = MCBA_TERMINATION_DISABLED;
@@ -785,9 +789,9 @@ static int mcba_set_termination(struct net_device *netdev, u16 term)
 	};
 
 	if (term == MCBA_TERMINATION_ENABLED)
-		usb_msg.termination = 1;
+		usb_msg.termination = MCBA_VER_TERMINATION_ON;
 	else
-		usb_msg.termination = 0;
+		usb_msg.termination = MCBA_VER_TERMINATION_OFF;
 
 	mcba_usb_xmit_cmd(priv, (struct mcba_usb_msg *)&usb_msg);
 
-- 
2.38.1


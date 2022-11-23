Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2ADE636A07
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 20:45:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239125AbiKWTof (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 14:44:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238997AbiKWTob (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 14:44:31 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3541970A7;
        Wed, 23 Nov 2022 11:44:29 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id k7so17550346pll.6;
        Wed, 23 Nov 2022 11:44:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=iq+S8pJ19eLCshsu6zUlPlVA+hDzpK61Zpqontnfdxc=;
        b=Dm3D+mqV77F9C7k/l2vNMGPcVRDxMjooR0mQRAyxRRzmPWscbW1/2i1odpXbhpeRtY
         P3pzvJJBuS5S6DpvDSAM29Kb6D2R4UU5MbTrgxZQxKsX1uZh7VWa78UdZtK1E8SRa+/K
         /J3QaiKVGVsFYtfyT4JPlP43OCJMpQEuHZNFb5DZOBslo4lGCvTNAAVvbalZu+6ob478
         6cn9H8U8CBK7DCT5ZPNNmyQlvg/Ncp1VMJ9dBhLI+2sw+BR2X/0f6SyQWRTzadz17cYi
         rA2ZSGaIPL1zb970UrUzKAaSqLmZbwwh7lW0mPhiJYwEpHE96kJ1sY3yDICfiVEqrYjC
         sVsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=iq+S8pJ19eLCshsu6zUlPlVA+hDzpK61Zpqontnfdxc=;
        b=o/Q7CVe0KtAsb5Ot2mE9wfx/IDmGBKpKv/Tt0lC1CJaiG1T2rQmBcrCtgWMWRrLj3C
         iYOTR5pD02lHozwK2nZnKJOF+zPBmE2MzJCrMPepYQWbTqqOwnMCNno80aMl8nhTyizq
         r1eWXPxfZkUPzKN9V+sdml8sSf8wTgEduKhgUYvA9HLx2BcAfIsj4YfeXG73CWgF2ALU
         tXUwqg4LXXK17z+GwExL2rzKR8TSZ0qO6PvuXd4rmmyUNuK5FRsY/fMDZvqf0weMFr59
         v0zhHflaThiUAEJVZGN5fjE8HXL13PEpwE4IEhfeE/a+dKY0s35BvF3mGy4fIkUOuToO
         ag5g==
X-Gm-Message-State: ANoB5pk4xJGOHDJ5D8uRSv0eVmH1mzMV36HXCsxegV1R/ndLvv520Rxn
        QsO4aqUOzoDfP4BULr+89eo=
X-Google-Smtp-Source: AA0mqf4Sib+LsBB6wxr85YLdCZMtxzjPRgIkr15/KD5fuNvZWALUMZlQYGL3bhcQwJFptLutb36uyg==
X-Received: by 2002:a17:902:7fc3:b0:189:4d89:a442 with SMTP id t3-20020a1709027fc300b001894d89a442mr2964656plb.151.1669232669273;
        Wed, 23 Nov 2022 11:44:29 -0800 (PST)
Received: from x570.spacecubics.com (221x245x252x90.ap221.ftth.ucom.ne.jp. [221.245.252.90])
        by smtp.gmail.com with ESMTPSA id t8-20020a170902e84800b0017a0f40fa19sm14795066plg.191.2022.11.23.11.44.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Nov 2022 11:44:28 -0800 (PST)
From:   Yasushi SHOJI <yasushi.shoji@gmail.com>
X-Google-Original-From: Yasushi SHOJI <yashi@spacecubics.com>
To:     Yasushi SHOJI <yashi@spacecubics.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] can: mcba_usb: Fix termination command argument
Date:   Thu, 24 Nov 2022 04:44:06 +0900
Message-Id: <20221123194406.80575-1-yashi@spacecubics.com>
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

Microchip USB Analyzer can be set with termination setting ON or OFF.
As I've observed, both with my oscilloscope and USB packet capture
below, you must send "0" to turn it ON, and "1" to turn it OFF.

Reverse the argument value to fix this.

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
 drivers/net/can/usb/mcba_usb.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/can/usb/mcba_usb.c b/drivers/net/can/usb/mcba_usb.c
index 218b098b261d..67beff1a3876 100644
--- a/drivers/net/can/usb/mcba_usb.c
+++ b/drivers/net/can/usb/mcba_usb.c
@@ -785,9 +785,9 @@ static int mcba_set_termination(struct net_device *netdev, u16 term)
 	};
 
 	if (term == MCBA_TERMINATION_ENABLED)
-		usb_msg.termination = 1;
-	else
 		usb_msg.termination = 0;
+	else
+		usb_msg.termination = 1;
 
 	mcba_usb_xmit_cmd(priv, (struct mcba_usb_msg *)&usb_msg);
 
-- 
2.38.1


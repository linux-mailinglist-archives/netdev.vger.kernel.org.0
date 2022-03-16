Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86AD94DBB2F
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 00:39:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348033AbiCPXk6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 19:40:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242323AbiCPXk5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 19:40:57 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15D4D19C2D;
        Wed, 16 Mar 2022 16:39:41 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id x15so5048123wru.13;
        Wed, 16 Mar 2022 16:39:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=mjSEl7HojYtgNDKj+uOkVCMlpQD09Tv32k+7XUaokl8=;
        b=Gw5/xgTuCklheDRPRa4qe+QjLlluOQH5o0yQ+fxGyl4Jjk2w5SDX8N8wvr3GoS2vQQ
         SaXD/K2bOcqOv6zGk/3Y0tjHXeN59TDrd7CrCslYXNZ37iQjPfuxLfSQYOkmzVjpA9jx
         ZCG2q/uNyJRkjmxCmRDL4ZTdCOIZxFPE490HHZX+ZNreNX7GPRPwYX3v2sCgE9RJmNez
         d6Ylrn4JIFbSXsh7wCsJkKagVXACrCpbTmhTEWCyAb+7d95ajiAnzE1lQYAFCr2IZQ1o
         5gyikE0HPOXd20zn+tqdQY0FYoMUv8LWa6A/LXQOXoiX7dhIlont6hRvG0gJUj1C/p+t
         I4IA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=mjSEl7HojYtgNDKj+uOkVCMlpQD09Tv32k+7XUaokl8=;
        b=hjeEAt4veTJZtpDX4tZTirpEhbjFwWdBUFfwXCEnxnf79S/J94MOdkAR6V9l0PxzRU
         T3YOr7Dpho7ewEBTpfX3T2el7FiNnVJbZ00IR7UCAbcHNB969iiERF+FvMilKa6BK80n
         Im4SZc6g0cKBn/QAplbAxYEkyvu0LegCcpVC29dOpjI8xRw1E/CGXiHBpK0n8qMwSJQ7
         I0cjHUMI9jvvxnfgFtl9MLOd5G7alu5sGQ5mxIFurRnpYTuIXuwvYcyORYkzBDtsZAB4
         47i8YmoWKK6QukcMt6bX1CL+wzJV0esX8aaI7piV1j65Thhb+8h7Pa20HuzMeUlXeW1N
         4nig==
X-Gm-Message-State: AOAM531oODGr1+7GdI1SojKCNOiKxTXacjSvWhk7jHfqN52oiSwIZ+vS
        EO7iR1cYedx4UqEB2U3gCTQ=
X-Google-Smtp-Source: ABdhPJx3if0VkRG5NVIO6As67D7R3M/XZ29FQ1ERAzN54brcCJ2IpK+TOAwFekQOiQ0LIu/Wt0IAYQ==
X-Received: by 2002:a05:6000:1849:b0:203:d6ae:b4b8 with SMTP id c9-20020a056000184900b00203d6aeb4b8mr1841549wri.542.1647473980070;
        Wed, 16 Mar 2022 16:39:40 -0700 (PDT)
Received: from localhost (cpc154979-craw9-2-0-cust193.16-3.cable.virginm.net. [80.193.200.194])
        by smtp.gmail.com with ESMTPSA id m3-20020a5d6243000000b001e33760776fsm2649525wrv.10.2022.03.16.16.39.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Mar 2022 16:39:39 -0700 (PDT)
From:   Colin Ian King <colin.i.king@gmail.com>
To:     Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] brcmfmac: p2p: Fix spelling mistake "Comback" -> "Comeback"
Date:   Wed, 16 Mar 2022 23:39:38 +0000
Message-Id: <20220316233938.55135-1-colin.i.king@gmail.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are some spelling mistakes in comments and brcmf_dbg messages.
Fix these.

Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c
index d3f08d4f380b..479041f070f9 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c
@@ -90,8 +90,8 @@
 #define P2PSD_ACTION_CATEGORY		0x04	/* Public action frame */
 #define P2PSD_ACTION_ID_GAS_IREQ	0x0a	/* GAS Initial Request AF */
 #define P2PSD_ACTION_ID_GAS_IRESP	0x0b	/* GAS Initial Response AF */
-#define P2PSD_ACTION_ID_GAS_CREQ	0x0c	/* GAS Comback Request AF */
-#define P2PSD_ACTION_ID_GAS_CRESP	0x0d	/* GAS Comback Response AF */
+#define P2PSD_ACTION_ID_GAS_CREQ	0x0c	/* GAS Comeback Request AF */
+#define P2PSD_ACTION_ID_GAS_CRESP	0x0d	/* GAS Comeback Response AF */
 
 #define BRCMF_P2P_DISABLE_TIMEOUT	msecs_to_jiffies(500)
 
@@ -396,11 +396,11 @@ static void brcmf_p2p_print_actframe(bool tx, void *frame, u32 frame_len)
 				  (tx) ? "TX" : "RX");
 			break;
 		case P2PSD_ACTION_ID_GAS_CREQ:
-			brcmf_dbg(TRACE, "%s P2P GAS Comback Request\n",
+			brcmf_dbg(TRACE, "%s P2P GAS Comeback Request\n",
 				  (tx) ? "TX" : "RX");
 			break;
 		case P2PSD_ACTION_ID_GAS_CRESP:
-			brcmf_dbg(TRACE, "%s P2P GAS Comback Response\n",
+			brcmf_dbg(TRACE, "%s P2P GAS Comeback Response\n",
 				  (tx) ? "TX" : "RX");
 			break;
 		default:
-- 
2.35.1


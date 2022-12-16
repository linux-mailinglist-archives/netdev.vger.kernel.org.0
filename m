Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A45664EED1
	for <lists+netdev@lfdr.de>; Fri, 16 Dec 2022 17:17:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232086AbiLPQR5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Dec 2022 11:17:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231843AbiLPQRy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Dec 2022 11:17:54 -0500
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A20126F;
        Fri, 16 Dec 2022 08:17:53 -0800 (PST)
Received: by mail-wr1-x42b.google.com with SMTP id o5so3024128wrm.1;
        Fri, 16 Dec 2022 08:17:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=irH1XmQtG5dO1L6/FH3q43QSzL37yuS1O7l4CdF6kPc=;
        b=FG8yWOdxGgc6SwbGZHu7J9QvVeusKO0ux+/rRZvr4UKA6znMb5whGu37TNYc5oCH06
         g9qfHaov9fVSSX2+SAhZ+eSKG2u0sk8aXhiUEmfrgMjOUOferuDZB040QQM+FUaXtDSY
         rjfUou7TeNBSCN9Rfzpjwu8XKzT7HDnksIeSj93A8q2gwKwkIojJASg7mvyIXK3pznwd
         4u8aetCpA0fvXrFarmzafWaM0bE27l36ALhkuBF3v95xJfy99EwJCKv8LU9X2Ja6YONs
         Ds1ncekkw3blNgpGFoDrouZCBnQvtlOTpDY/DvKfxmKneSQrnPSkZ97q5f8yz1fr48e1
         JkcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=irH1XmQtG5dO1L6/FH3q43QSzL37yuS1O7l4CdF6kPc=;
        b=daNLGl4XpHpeEJjvTLFIQ2BFCSmhvSdqSGRUauKJH3w2xaBvQeITMQTP3Td9EOBOOD
         tPe7o9XuidRgfthrYCOMsneiVPFJxbQ4ylt6JR0lZ7l3x+dtqBZhBBUIOqfuXI5mGqIl
         CFaBAFEL7j55n03sevrbv2tZa9TZ2XH6WOMCndLX1gxFDjdrd5sElPIqOSwnGNiaPljn
         sR9IaVChDMTiSrfociuOegRGSEVHUem/9B/vfizFVkHfi5oPPQYba9nJTWhPUbTR0SuZ
         ePbZvE/VRZYpNO50ZvTtow9OTPDeBW/AkiLtUFbx0CiyLRv0JqDGMx/KS4fjQ6xqm5uq
         XHmA==
X-Gm-Message-State: ANoB5pmXSjYZUTsQHqAkEWVtjChje8nDWL8u79tcMECK5sx91ad9gHCS
        3/4R0VTvGJxcFiwS5g07Qcg=
X-Google-Smtp-Source: AA0mqf7Rw9n9RqN+D6JpXEQlEPO10gS7RpNRUUAPV+bWKAvaEJ25IETeOZbsbfztE8X5k0La3xVmLw==
X-Received: by 2002:adf:ec10:0:b0:242:2206:7c61 with SMTP id x16-20020adfec10000000b0024222067c61mr27960551wrn.62.1671207471699;
        Fri, 16 Dec 2022 08:17:51 -0800 (PST)
Received: from localhost.localdomain (93-42-71-18.ip85.fastwebnet.it. [93.42.71.18])
        by smtp.googlemail.com with ESMTPSA id bj19-20020a0560001e1300b002238ea5750csm3079720wrb.72.2022.12.16.08.17.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Dec 2022 08:17:51 -0800 (PST)
From:   Christian Marangi <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Christian Marangi <ansuelsmth@gmail.com>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Ronald Wahl <ronald.wahl@raritan.com>, stable@vger.kernel.org
Subject: [net PATCH 2/5] net: dsa: tag_qca: fix wrong MGMT_DATA2 size
Date:   Fri, 16 Dec 2022 17:17:18 +0100
Message-Id: <20221216161721.23863-2-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20221216161721.23863-1-ansuelsmth@gmail.com>
References: <20221216161721.23863-1-ansuelsmth@gmail.com>
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

It was discovered that MGMT_DATA2 can contain up to 28 bytes of data
instead of the 12 bytes written in the Documentation by accounting the
limit of 16 bytes declared in Documentation subtracting the first 4 byte
in the packet header.

Update the define with the real world value.

Tested-by: Ronald Wahl <ronald.wahl@raritan.com>
Fixes: c2ee8181fddb ("net: dsa: tag_qca: add define for handling mgmt Ethernet packet")
Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
Cc: stable@vger.kernel.org # v5.18+
---
 include/linux/dsa/tag_qca.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/dsa/tag_qca.h b/include/linux/dsa/tag_qca.h
index b1b5720d89a5..ee657452f122 100644
--- a/include/linux/dsa/tag_qca.h
+++ b/include/linux/dsa/tag_qca.h
@@ -45,8 +45,8 @@ struct sk_buff;
 					QCA_HDR_MGMT_COMMAND_LEN + \
 					QCA_HDR_MGMT_DATA1_LEN)
 
-#define QCA_HDR_MGMT_DATA2_LEN		12 /* Other 12 byte for the mdio data */
-#define QCA_HDR_MGMT_PADDING_LEN	34 /* Padding to reach the min Ethernet packet */
+#define QCA_HDR_MGMT_DATA2_LEN		28 /* Other 28 byte for the mdio data */
+#define QCA_HDR_MGMT_PADDING_LEN	18 /* Padding to reach the min Ethernet packet */
 
 #define QCA_HDR_MGMT_PKT_LEN		(QCA_HDR_MGMT_HEADER_LEN + \
 					QCA_HDR_LEN + \
-- 
2.37.2


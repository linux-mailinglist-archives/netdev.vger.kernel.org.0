Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B10E750E43C
	for <lists+netdev@lfdr.de>; Mon, 25 Apr 2022 17:21:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241970AbiDYPXp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Apr 2022 11:23:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229557AbiDYPXm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Apr 2022 11:23:42 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43425BF32A;
        Mon, 25 Apr 2022 08:20:38 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id k27so3655567edk.4;
        Mon, 25 Apr 2022 08:20:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=fbFo0WfowGPP9sPESJqw4Wjx6QEMuAVeUZmPdLIEBDc=;
        b=X+1gub6Wv0mDmrdLwSu3+rRVhrEPi9qz9oFTepTKw8ILEPJsa37Jo3TuUHudV6ufJY
         UGysEIZUwx0H1HmlcGOfzeB8e17g40U5fJpnU/Ud2rRjeg+vztspRgjQwvMa/y33MrF9
         5KhB9t5/+NIBlbsK64BsSqMtZB4u/NRFF8UQntJJWvgPZzRymEZU/tNDlbnz1e97OG7M
         5Y79WXLCsMyUxhrTmzPEEya+BvW6fApqAfV82T2HAxWI5VYU+okS6q14gu9QbjT9dBP8
         NnjB/e5Q7s+eyA3DQxU/cdTVAMB6Ukujo03IenjhsjGFKu6mtEVTbQ7ivY3aR8X/kToG
         cSsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=fbFo0WfowGPP9sPESJqw4Wjx6QEMuAVeUZmPdLIEBDc=;
        b=VPBmPCEZZoDXa2CN/o9IyzdHm0AZDCJpZBiCAZPT7CDspp+s7dj7ofMICupy1vc5Mp
         FtCJbcEIFeT6aeHmY1+0DTyKalr3eouTnNn91I0CaNa6JA2OV9Mv5bONP9kbU/yI4GrP
         kAaeRYzvCHjWY5bqC7PheaxftzysUWUfetz4rYYbRJrL3wQh2vtXp7o3l84wqw4rcCgJ
         BB6Ja3Hu1woe3Ql5bpMH/ZDhY0moNpwfTBKu4wZmuNG0IKCifb+hWaev/St9rL98Ls/l
         5qrf1Y4sZ9tmjpJhn847idVLYN3pbBTMPIOZejtVbfvRqCdiAlBcSjBy6tvRugIctbQR
         djqw==
X-Gm-Message-State: AOAM532gKqHI6Jet/Fq4A6yVSb86+ufjuQNK4gasKmxkIFujkArtvjgG
        wqAUzdVkp/GL0d/VnsE5JRX+9tlplus=
X-Google-Smtp-Source: ABdhPJwnjNAACi3/RaJ/oigSRsvntTMGmnyYT17JnY2mZjztEGiMH7PmI1yuCwG7JSmqjxyrcu5wXg==
X-Received: by 2002:a05:6402:42d4:b0:412:c26b:789 with SMTP id i20-20020a05640242d400b00412c26b0789mr19842837edc.232.1650900036465;
        Mon, 25 Apr 2022 08:20:36 -0700 (PDT)
Received: from localhost.localdomain (dynamic-2a01-0c23-b81b-0800-f22f-74ff-fe21-0725.c23.pool.telefonica.de. [2a01:c23:b81b:800:f22f:74ff:fe21:725])
        by smtp.googlemail.com with ESMTPSA id l17-20020a056402231100b0041d98ed7ad8sm4802863eda.46.2022.04.25.08.20.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Apr 2022 08:20:35 -0700 (PDT)
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To:     netdev@vger.kernel.org
Cc:     hauke@hauke-m.de, linux-kernel@vger.kernel.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, olteanv@gmail.com, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        stable@vger.kernel.org, Jan Hoffmann <jan@3e8.eu>
Subject: [PATCH net] net: dsa: lantiq_gswip: Don't set GSWIP_MII_CFG_RMII_CLK
Date:   Mon, 25 Apr 2022 17:20:27 +0200
Message-Id: <20220425152027.2220750-1-martin.blumenstingl@googlemail.com>
X-Mailer: git-send-email 2.36.0
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

Commit 4b5923249b8fa4 ("net: dsa: lantiq_gswip: Configure all remaining
GSWIP_MII_CFG bits") added all known bits in the GSWIP_MII_CFGp
register. It helped bring this register into a well-defined state so the
driver has to rely less on the bootloader to do things right.
Unfortunately it also sets the GSWIP_MII_CFG_RMII_CLK bit without any
possibility to configure it. Upon further testing it turns out that all
boards which are supported by the GSWIP driver in OpenWrt which use an
RMII PHY have a dedicated oscillator on the board which provides the
50MHz RMII reference clock.

Don't set the GSWIP_MII_CFG_RMII_CLK bit (but keep the code which always
clears it) to fix support for the Fritz!Box 7362 SL in OpenWrt. This is
a board with two Atheros AR8030 RMII PHYs. With the "RMII clock" bit set
the MAC also generates the RMII reference clock whose signal then
conflicts with the signal from the oscillator on the board. This results
in a constant cycle of the PHY detecting link up/down (and as a result
of that: the two ports using the AR8030 PHYs are not working).

At the time of writing this patch there's no known board where the MAC
(GSWIP) has to generate the RMII reference clock. If needed this can be
implemented in future by providing a device-tree flag so the
GSWIP_MII_CFG_RMII_CLK bit can be toggled per port.

Fixes: 4b5923249b8fa4 ("net: dsa: lantiq_gswip: Configure all remaining GSWIP_MII_CFG bits")
Cc: stable@vger.kernel.org
Tested-by: Jan Hoffmann <jan@3e8.eu>
Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
---
 drivers/net/dsa/lantiq_gswip.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/dsa/lantiq_gswip.c b/drivers/net/dsa/lantiq_gswip.c
index a416240d001b..12c15da55664 100644
--- a/drivers/net/dsa/lantiq_gswip.c
+++ b/drivers/net/dsa/lantiq_gswip.c
@@ -1681,9 +1681,6 @@ static void gswip_phylink_mac_config(struct dsa_switch *ds, int port,
 		break;
 	case PHY_INTERFACE_MODE_RMII:
 		miicfg |= GSWIP_MII_CFG_MODE_RMIIM;
-
-		/* Configure the RMII clock as output: */
-		miicfg |= GSWIP_MII_CFG_RMII_CLK;
 		break;
 	case PHY_INTERFACE_MODE_RGMII:
 	case PHY_INTERFACE_MODE_RGMII_ID:
-- 
2.36.0


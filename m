Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EF866C385C
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 18:35:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229674AbjCURfN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 13:35:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230327AbjCURfB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 13:35:01 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1D855507D;
        Tue, 21 Mar 2023 10:34:27 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id i9so14537769wrp.3;
        Tue, 21 Mar 2023 10:34:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679420066;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=asmFs22xWYwR1Ql9m/IrNv+MPUNDn8hSjmwDRYvO7mE=;
        b=Cqj2C6aG5vEOlhh9N3ybvDA0CV38nhQODnfdnr7utNddd323iDagoJty1Wmi3MAzj1
         5ORmYT5fQvUnild7C4RhcCNTBn+MoYZ+wDZwZYelu6BKHkW11YFK949ax5B50by+ASR2
         z+rGI3wR5fVXd4VDgmcsT6zF5x69wKyhbhqIfrhG9BVFTctfaBgDS/l+bX1C56kSqv82
         bQkKSSAehSLGpFoCU3q62OGoZVi3jDe6HDb5M1Dp2mgHhqsW19otZpJ57DjtZ1CmtPai
         o7T/ew6WoIYSl6whBmV36jeNaDJ3TItOBrKc4nMJBDWaCg4DNzUSe0ei5Xz7Oik5lb3p
         y9ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679420066;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=asmFs22xWYwR1Ql9m/IrNv+MPUNDn8hSjmwDRYvO7mE=;
        b=UdI2iQNBYwRf40ivf3ROR132t95BU/p3RUzXdZLCyz6c6JWtECQ5byyGeEwoX10n5u
         HlepoNTJxMFLYrAHGvNLDPpWPuLXMa645S1mCVZ7NyWp8W96XzSynNZPeXHuJdb464QU
         A7UTRSW3mlvKe9OR3EcB2CfBZv0yHWR0ldbnxcxGUFw8z78PNqpOVnITtjBdfpGesJ9c
         VJw+fiM6hCcahor4nk9LLcAryPm8xmhDLxBKaLILO8wyTUiHY8G9hsXnFCtcpetnF5wS
         pW13beAE+odb7ZZaXZUYpWGYhCe/hLzNjbo8YpgzHwadZthxPrT5YvNIYwyrvoViLM0n
         KDRQ==
X-Gm-Message-State: AO0yUKW+9H/kqcAUyWeZhZJhiJjsBcYn1THmZaSDrPrk/pNuGXJXGtJd
        NgsGZW8iSqLEv81yK+U5Os8=
X-Google-Smtp-Source: AK7set/lzQZwCSxVaOe5dZ+7TR3xaQty/vg5xvZDpRW8TwTiPQblIbw5kJJTPLp67RySehrPIlCqSg==
X-Received: by 2002:a5d:65c9:0:b0:2ce:ac31:54ff with SMTP id e9-20020a5d65c9000000b002ceac3154ffmr2776515wrw.2.1679420066191;
        Tue, 21 Mar 2023 10:34:26 -0700 (PDT)
Received: from atlantis.lan (255.red-79-146-124.dynamicip.rima-tde.net. [79.146.124.255])
        by smtp.gmail.com with ESMTPSA id b13-20020a056000054d00b002da1261aa44sm184775wrf.48.2023.03.21.10.34.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Mar 2023 10:34:25 -0700 (PDT)
From:   =?UTF-8?q?=C3=81lvaro=20Fern=C3=A1ndez=20Rojas?= 
        <noltari@gmail.com>
To:     f.fainelli@gmail.com, jonas.gorski@gmail.com, andrew@lunn.ch,
        olteanv@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     =?UTF-8?q?=C3=81lvaro=20Fern=C3=A1ndez=20Rojas?= 
        <noltari@gmail.com>, Simon Horman <simon.horman@corigine.com>
Subject: [PATCH v2 4/4] net: dsa: b53: add BCM63268 RGMII configuration
Date:   Tue, 21 Mar 2023 18:33:59 +0100
Message-Id: <20230321173359.251778-5-noltari@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230321173359.251778-1-noltari@gmail.com>
References: <20230320155024.164523-1-noltari@gmail.com>
 <20230321173359.251778-1-noltari@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

BCM63268 requires special RGMII configuration to work.

Signed-off-by: Álvaro Fernández Rojas <noltari@gmail.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
---
 v2: no changes.

 drivers/net/dsa/b53/b53_common.c | 6 +++++-
 drivers/net/dsa/b53/b53_regs.h   | 1 +
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index 97327d7a6760..1f9b251a5452 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -1240,8 +1240,12 @@ static void b53_adjust_63xx_rgmii(struct dsa_switch *ds, int port,
 		break;
 	}
 
-	if (port != dev->imp_port)
+	if (port != dev->imp_port) {
+		if (is63268(dev))
+			rgmii_ctrl |= RGMII_CTRL_MII_OVERRIDE;
+
 		rgmii_ctrl |= RGMII_CTRL_ENABLE_GMII;
+	}
 
 	b53_write8(dev, B53_CTRL_PAGE, off, rgmii_ctrl);
 
diff --git a/drivers/net/dsa/b53/b53_regs.h b/drivers/net/dsa/b53/b53_regs.h
index b2c539a42154..bfbcb66bef66 100644
--- a/drivers/net/dsa/b53/b53_regs.h
+++ b/drivers/net/dsa/b53/b53_regs.h
@@ -138,6 +138,7 @@
 
 #define B53_RGMII_CTRL_IMP		0x60
 #define   RGMII_CTRL_ENABLE_GMII	BIT(7)
+#define   RGMII_CTRL_MII_OVERRIDE	BIT(6)
 #define   RGMII_CTRL_TIMING_SEL		BIT(2)
 #define   RGMII_CTRL_DLL_RXC		BIT(1)
 #define   RGMII_CTRL_DLL_TXC		BIT(0)
-- 
2.30.2


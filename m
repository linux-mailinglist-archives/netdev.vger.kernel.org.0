Return-Path: <netdev+bounces-12209-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0DDFE736B2F
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 13:42:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BC78428122A
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 11:41:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC40210961;
	Tue, 20 Jun 2023 11:41:04 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D97F154BD
	for <netdev@vger.kernel.org>; Tue, 20 Jun 2023 11:41:04 +0000 (UTC)
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B693010F3
	for <netdev@vger.kernel.org>; Tue, 20 Jun 2023 04:41:02 -0700 (PDT)
Received: by mail-lf1-x129.google.com with SMTP id 2adb3069b0e04-4f867700f36so3872483e87.0
        for <netdev@vger.kernel.org>; Tue, 20 Jun 2023 04:41:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rasmusvillemoes.dk; s=google; t=1687261259; x=1689853259;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rc0VF9QAKItzIoQIN+TGeSbpZSwD884ZJlY6XLWEwnQ=;
        b=OSo/IOjpcTOvWjExcqsUbvuVyXnARS++fI0WVy3bVnpKwZGoSPB4IrOxk/VnscG8BF
         FfeSlGKun5ERhfnpb5CLB13pbyP1lWPKhVHkcU8hsfjhGbLJJtwZAFIiMr/anJHqRSP1
         +eIcUHFwHvqjxUsQOzyIPT2Qmnbt5eDVXiQBE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687261259; x=1689853259;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rc0VF9QAKItzIoQIN+TGeSbpZSwD884ZJlY6XLWEwnQ=;
        b=T3312094T/hnwinW58x+87ToxPzIU28MRgZ8zAXW0F+vTJnz4SyilyoTbUD4RjvBtZ
         Xh8fxREGDwvBGaXl53+FmVKJgvUsGIGFeXK1OtTMsXF2ELhx3dNYDpghBUyPBfjM+t+0
         X7cZPm4bbGZWwKYWf6iRGYDNkDfSWHbax/rmzpsGQEhS9XSX6guSUnUCS2toWnZXfZFy
         q4MWyC+vlgLVMnUzgK0+MvsoMdJxSJMCtdbeRO7EoaH1INFfsR05liWuciBa9qwwlWck
         NVpvS/FJikKZ0/D1yG7cnqluxqzfUfa40BxLRaclKjJVrRrG7uMptHf32Iso9SRoLZSF
         uXxA==
X-Gm-Message-State: AC+VfDx92x65jMKSxo0jEdU66iDSYl7mgWbAoB880H610+adfK2vpMb2
	DSLiFesoKot+aslcCG3SLm3Vlg==
X-Google-Smtp-Source: ACHHUZ7vTB7KJs+ED1EvGxXyIkcZbS3zd6TkV0QsQM3gGOpK8DiScTUsVPoFeq/WVfuUiSUwiOZvhQ==
X-Received: by 2002:ac2:5b12:0:b0:4f3:dd96:bf55 with SMTP id v18-20020ac25b12000000b004f3dd96bf55mr7093121lfn.11.1687261258951;
        Tue, 20 Jun 2023 04:40:58 -0700 (PDT)
Received: from localhost.localdomain ([87.54.42.112])
        by smtp.gmail.com with ESMTPSA id d12-20020ac2544c000000b004f84162e08bsm329879lfn.185.2023.06.20.04.40.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Jun 2023 04:40:58 -0700 (PDT)
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Woojung Huh <woojung.huh@microchip.com>,
	UNGLinuxDriver@microchip.com,
	Andrew Lunn <andrew@lunn.ch>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Vladimir Oltean <olteanv@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH net-next 3/3] net: dsa: microchip: fix writes to phy registers >= 0x10
Date: Tue, 20 Jun 2023 13:38:54 +0200
Message-Id: <20230620113855.733526-4-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20230620113855.733526-1-linux@rasmusvillemoes.dk>
References: <20230620113855.733526-1-linux@rasmusvillemoes.dk>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

According to the errata sheets for ksz9477 and ksz9567, writes to the
PHY registers 0x10-0x1f (i.e. those located at addresses 0xN120 to
0xN13f) must be done as a 32 bit write to the 4-byte aligned address
containing the register, hence requires a RMW in order not to change
the adjacent PHY register.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 drivers/net/dsa/microchip/ksz9477.c | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/microchip/ksz9477.c b/drivers/net/dsa/microchip/ksz9477.c
index fc5157a10af5..83b7f2d5c1ea 100644
--- a/drivers/net/dsa/microchip/ksz9477.c
+++ b/drivers/net/dsa/microchip/ksz9477.c
@@ -329,11 +329,27 @@ int ksz9477_r_phy(struct ksz_device *dev, u16 addr, u16 reg, u16 *data)
 
 int ksz9477_w_phy(struct ksz_device *dev, u16 addr, u16 reg, u16 val)
 {
+	u32 mask, val32;
+
 	/* No real PHY after this. */
 	if (!dev->info->internal_phy[addr])
 		return 0;
 
-	return ksz_pwrite16(dev, addr, 0x100 + (reg << 1), val);
+	if (reg < 0x10)
+		return ksz_pwrite16(dev, addr, 0x100 + (reg << 1), val);
+
+	/* Errata: When using SPI, I2C, or in-band register access,
+	 * writes to certain PHY registers should be performed as
+	 * 32-bit writes instead of 16-bit writes.
+	 */
+	val32 = val;
+	mask = 0xffff;
+	if ((reg & 1) == 0) {
+		val32 <<= 16;
+		mask <<= 16;
+	}
+	reg &= ~1;
+	return ksz_prmw32(dev, addr, 0x100 + (reg << 1), mask, val32);
 }
 
 void ksz9477_cfg_port_member(struct ksz_device *dev, int port, u8 member)
-- 
2.37.2



Return-Path: <netdev+bounces-11849-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2A046734D65
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 10:17:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BF6B21C20939
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 08:17:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 63DEE6FCC;
	Mon, 19 Jun 2023 08:17:33 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5872F6ADF
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 08:17:33 +0000 (UTC)
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2508100
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 01:17:30 -0700 (PDT)
Received: by mail-lf1-x12d.google.com with SMTP id 2adb3069b0e04-4f86e6e4038so1038597e87.0
        for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 01:17:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rasmusvillemoes.dk; s=google; t=1687162649; x=1689754649;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=2Yv2rIjaXMDMpPLlwF9jwu6QeCtYranVnkffyN+HyQU=;
        b=PwoutS+BntF9MCQalJkmoo5F0NDU9r5BLunwlMmivEzDmJCqE0xV3ZIlYjX5JDEi/p
         T1imxKFaIUWUEf1c8DVAUeT0hwnmVlNhEgz8f3A1trJ8ZvDzPZUpL8GtWINkVb4XyxGN
         lGsmTavgOCfyEFps6M/vTYd7rLHJU07DiLGNo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687162649; x=1689754649;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2Yv2rIjaXMDMpPLlwF9jwu6QeCtYranVnkffyN+HyQU=;
        b=OlNYgk87ECnK3f9EAIBZmuVAVB0dyNmT04c1H0zPBosU4V4MVNkR/HvKLNRoSpn9UT
         OkcJw3GBVuWCjd2loMmJcji8Q4Jy6eiIPvoPuXLcJMQN+R9EW46opSbFvgg3N6HQt5QJ
         qDnFrF8UC+w7Emdu8LZ2pdmZzEO8nKRVcsPIXg5/gKvdPH44AwI55hbFXBhqCl0h+N2h
         0oaZaPKRlm5ztHFAVxsG0p+xrxrTcmQfEqRMC6D0ocXy3xpBQrr76Ii0GCfVO11OqLNb
         ETUNzJvmeE3I8Mh5hQsNZFE+jgmjRPSU//tuSED1CVDFhMbOVRYKtba65+CrWWW9TRfb
         pIwA==
X-Gm-Message-State: AC+VfDzLVmZy/CZwQe6CGsNgbqzrG9QD45swK41aCZ0ACinzUtBGV6Mp
	OHyQ31A/JCacTEFJ+oCIG2tw0g==
X-Google-Smtp-Source: ACHHUZ7qO6cBJkmxBk4du5cNmihY6RimwgxVhN5bfZR9+X6qndg8wPmimAT8wFwu0qd2uAI5R7zWEg==
X-Received: by 2002:a05:6512:2ef:b0:4f4:ffae:7b93 with SMTP id m15-20020a05651202ef00b004f4ffae7b93mr2891866lfq.7.1687162648785;
        Mon, 19 Jun 2023 01:17:28 -0700 (PDT)
Received: from prevas-ravi.prevas.se ([81.216.59.226])
        by smtp.gmail.com with ESMTPSA id g23-20020a19ee17000000b004f4b3e9e0cesm4137924lfb.297.2023.06.19.01.17.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Jun 2023 01:17:28 -0700 (PDT)
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Woojung Huh <woojung.huh@microchip.com>,
	UNGLinuxDriver@microchip.com,
	Andrew Lunn <andrew@lunn.ch>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Vladimir Oltean <olteanv@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Robert Hancock <hancock@sedsystems.ca>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	stable@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH net-next] net: dsa: microchip: ksz9477: follow errata sheet when applying fixups
Date: Mon, 19 Jun 2023 10:16:32 +0200
Message-Id: <20230619081633.589703-1-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 2.37.2
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

The errata sheets for both ksz9477 and ksz9567 begin with

  IMPORTANT NOTE

  Multiple errata workarounds in this document call for changing PHY
  registers for each PHY port. PHY registers 0x0 to 0x1F are in the
  address range 0xN100 to 0xN13F, while indirect (MMD) PHY registers
  are accessed via the PHY MMD Setup Register and the PHY MMD Data
  Register.

  Before configuring the PHY MMD registers, it is necessary to set the
  PHY to 100 Mbps speed with auto-negotiation disabled by writing to
  register 0xN100-0xN101. After writing the MMD registers, and after
  all errata workarounds that involve PHY register settings, write
  register 0xN100-0xN101 again to enable and restart auto-negotiation.

Without that explicit auto-neg restart, we do sometimes have problems
establishing link.

Rather than writing back the hardcoded 0x1340 value the errata sheet
suggests (which likely just corresponds to the most common strap
configuration), restore the original value, setting the
PORT_AUTO_NEG_RESTART bit if PORT_AUTO_NEG_ENABLE is set.

Fixes: 1fc33199185d ("net: dsa: microchip: Add PHY errata workarounds")
Cc: stable@vger.kernel.org
Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
While I do believe this is a fix, I don't think it's post-rc7
material, hence targeting net-next with cc stable.

 drivers/net/dsa/microchip/ksz9477.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/net/dsa/microchip/ksz9477.c b/drivers/net/dsa/microchip/ksz9477.c
index bf13d47c26cf..9a712ea71ee7 100644
--- a/drivers/net/dsa/microchip/ksz9477.c
+++ b/drivers/net/dsa/microchip/ksz9477.c
@@ -902,6 +902,16 @@ static void ksz9477_port_mmd_write(struct ksz_device *dev, int port,
 
 static void ksz9477_phy_errata_setup(struct ksz_device *dev, int port)
 {
+	u16 cr;
+
+	/* Errata document says the PHY must be configured to 100Mbps
+	 * with auto-neg disabled before configuring the PHY MMD
+	 * registers.
+	 */
+	ksz_pread16(dev, port, REG_PORT_PHY_CTRL, &cr);
+	ksz_pwrite16(dev, port, REG_PORT_PHY_CTRL,
+		     PORT_SPEED_100MBIT | PORT_FULL_DUPLEX);
+
 	/* Apply PHY settings to address errata listed in
 	 * KSZ9477, KSZ9897, KSZ9896, KSZ9567, KSZ8565
 	 * Silicon Errata and Data Sheet Clarification documents:
@@ -943,6 +953,13 @@ static void ksz9477_phy_errata_setup(struct ksz_device *dev, int port)
 	ksz9477_port_mmd_write(dev, port, 0x1c, 0x1d, 0xe7ff);
 	ksz9477_port_mmd_write(dev, port, 0x1c, 0x1e, 0xefff);
 	ksz9477_port_mmd_write(dev, port, 0x1c, 0x20, 0xeeee);
+
+	/* Restore PHY CTRL register, restart auto-negotiation if
+	 * enabled in the original value.
+	 */
+	if (cr & PORT_AUTO_NEG_ENABLE)
+		cr |= PORT_AUTO_NEG_RESTART;
+	ksz_pwrite16(dev, port, REG_PORT_PHY_CTRL, cr);
 }
 
 void ksz9477_get_caps(struct ksz_device *dev, int port,
-- 
2.37.2



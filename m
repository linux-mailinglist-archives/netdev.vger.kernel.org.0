Return-Path: <netdev+bounces-477-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 174AC6F7999
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 01:07:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3A827280F7F
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 23:07:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E6B0C15B;
	Thu,  4 May 2023 23:07:39 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4168FC156
	for <netdev@vger.kernel.org>; Thu,  4 May 2023 23:07:39 +0000 (UTC)
Received: from mail-qt1-x835.google.com (mail-qt1-x835.google.com [IPv6:2607:f8b0:4864:20::835])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C53712094;
	Thu,  4 May 2023 16:07:37 -0700 (PDT)
Received: by mail-qt1-x835.google.com with SMTP id d75a77b69052e-3ef5bea20caso4651371cf.3;
        Thu, 04 May 2023 16:07:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683241656; x=1685833656;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=K/W435ELPheTBswndumHoGwwCmqI4GKA76kRzPB3uIw=;
        b=BWDBsJ0Rzimf3W7ms+EXKNHW70EVwyfEHUkG5hfMkbJ/Os0x29RnMBe4au9FRa4Lk9
         aCzjQNFWtNTToiI1Lq78XCWO9pUtLCi7hCz7PT1qbkG9CIM6n8HKsuMpEHiYl6yEIUCl
         RyB8GEY6Ykn5OVpepy0+mvlQMeeszvIx8htVFxD4fp4iU+p4eRa8v0vpbMLPmd7nzStr
         SO5HneJ7+GoobgkFHubBuuSRW8Co/hfQltdzJd2Su59mR7ibeuAAvM6yiRzG8vTjqokB
         Tcmpm+Gp4Ii+Df32vPQwlLOXhTg07Ch8hSpUhiCfNsHg0n+PKh7n9p8AfFyBaB8vgkDe
         rdxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683241656; x=1685833656;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=K/W435ELPheTBswndumHoGwwCmqI4GKA76kRzPB3uIw=;
        b=M9xKzTBHoFmoBzB+SCOakBHLMSEDiCTMdaIAgv1pZDogJoS+qMy1+VTSa+xNHwZTK1
         XlDn/BfZR2gAaN3m0/k5w4Z7zyyYvC+GwER0F30zfA0DFw8S1Lgnn/GTbUTH9fSGhsDv
         PVqxiTLcaW4nxv9BdjF0UTOEWOqOn0vg0ywQ/9RJdFV3fYhH4aWMEPL8iex4K4GRgeSd
         W45lPaY0oenwJUb3OVIkGrckfiXooHWq6LUzclKU2322Jqugz4fgF3dXcDVYAzZGGHz9
         uN2SsuNV9OIcStQ01iY+iHEzLS9ms1Aff5J00R2pGeCPJY7CPsPMCAj3o+CZ1WdBj9pa
         GXcQ==
X-Gm-Message-State: AC+VfDx6ykPfcgSDp4R04nu8z67XTnkeEkYUo5qOFB6fqNeqijMk+XBU
	xCJTMGHkDALimuhtppBoAc4g+bX4+9o=
X-Google-Smtp-Source: ACHHUZ47fjc28LaP4XJaj++uztpA5cmMKTNxTnoZ1Mcmg7ZJRaD4aCq8yg8hmJg8dIp8a09PajqLMg==
X-Received: by 2002:ac8:7d46:0:b0:3ef:6393:4bcc with SMTP id h6-20020ac87d46000000b003ef63934bccmr8421423qtb.15.1683241656100;
        Thu, 04 May 2023 16:07:36 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id b16-20020ac844d0000000b003f0a79e6a8bsm80137qto.28.2023.05.04.16.07.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 May 2023 16:07:35 -0700 (PDT)
From: Florian Fainelli <f.fainelli@gmail.com>
To: netdev@vger.kernel.org
Cc: andrew@lunn.ch,
	hkallweit1@gmail.com,
	linux@armlinux.org.uk,
	Florian Fainelli <f.fainelli@gmail.com>,
	Doug Berger <opendmb@gmail.com>,
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net] net: bcmgenet: Remove phy_stop() from bcmgenet_netif_stop()
Date: Thu,  4 May 2023 16:07:27 -0700
Message-Id: <20230504230727.729539-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

The call to phy_stop() races with the later call to phy_disconnect(),
resulting in concurrent phy_suspend() calls being run from different
CPUs. The final call to phy_disconnect() ensures that the PHY is
stopped and suspended, too.

Fixes: c96e731c93ff ("net: bcmgenet: connect and disconnect from the PHY state machine")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/ethernet/broadcom/genet/bcmgenet.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
index d937daa8ee88..f28ffc31df22 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -3465,7 +3465,6 @@ static void bcmgenet_netif_stop(struct net_device *dev)
 	/* Disable MAC transmit. TX DMA disabled must be done before this */
 	umac_enable_set(priv, CMD_TX_EN, false);
 
-	phy_stop(dev->phydev);
 	bcmgenet_disable_rx_napi(priv);
 	bcmgenet_intr_disable(priv);
 
-- 
2.34.1



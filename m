Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74ECC2E89C9
	for <lists+netdev@lfdr.de>; Sun,  3 Jan 2021 02:27:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726999AbhACB0l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Jan 2021 20:26:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726689AbhACB0k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 Jan 2021 20:26:40 -0500
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B658C061573;
        Sat,  2 Jan 2021 17:26:00 -0800 (PST)
Received: by mail-ej1-x634.google.com with SMTP id jx16so32165987ejb.10;
        Sat, 02 Jan 2021 17:26:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6S17wZsGDVyR7PYBl6TcY4s1Y0lYR9kSxULYqsFA63c=;
        b=teWo+rdSZiDaZ/e8gyEiEMInO56DHz1W2A5q3lEv60OHkbktKyj/bk/mtFQhpafAUs
         rH1X/J08zE7SRkoC0V6mNOQCrZMmIVZJISRg4zoonLhjazPlVbWfvE8w54VxnohXlVGu
         /4ehxpwMkMZBCupZlX5TtZcKi/gB8x5Kp2We0sh7iIicpip7TgEo6MLy6z+IGb53nX3l
         zYaARjGdu8gW6ByVyEvhMhkDANkKwgYRkHClXjz9gBg8Mf3ccY3fPLlkOgAD+TAyS+NX
         MA7sCXR0Z9H8ybKSgtV7ASwFUI2Ezd9UkXpRIvwsI2qdrNkNTs2wOXR79t+6TsmLybhg
         ZkbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6S17wZsGDVyR7PYBl6TcY4s1Y0lYR9kSxULYqsFA63c=;
        b=Ws6g4ZXiCHo26gqsYCnGJChDlgp2TwAVJLEFtcxIaSqdBpkIDsmhEsumB/b5CZP2xY
         vjpAM0hLQIgXYzFNSO0Ss8J2CfxyRopVzsUZ6EgnrIvClM7+6jjJvY1dX7BDvqBcaEzU
         1hCEk78NhgjjvmWHOIzF6W6+bsIYk08LdxlMN1ojpIReqML/+qB/Sqt+/qXrYawiAfVA
         j+N8euaNnRsVRCyojiDsGbDN2Wa4vlPqWA3zOXwxNNkM27DF1KSKQCFMgs2WKLzcDbZs
         NWiWhYyv16LBipLsei2AvolHlp2cjdzBxoSlMkP11mXmEv6NxYhNkbmxWcy7FIAZucRc
         Akcw==
X-Gm-Message-State: AOAM531apls/E52t4lyM3AmnMgPG+G2dYAqHaS5b2eFr8NkiXeaLZPeD
        RIFojH/8H/CU9fodPicqWfM=
X-Google-Smtp-Source: ABdhPJyio+qH5Tk9ypzinBxHS2HnKAwv8uOIxbI9dzyzgxtlp2hwslxAJSly5MBQh3e+xGmsXUZJrw==
X-Received: by 2002:a17:906:fa12:: with SMTP id lo18mr63742103ejb.354.1609637158900;
        Sat, 02 Jan 2021 17:25:58 -0800 (PST)
Received: from localhost.localdomain (p200300f13724fd00428d5cfffeb99db8.dip0.t-ipconnect.de. [2003:f1:3724:fd00:428d:5cff:feb9:9db8])
        by smtp.googlemail.com with ESMTPSA id op5sm22118006ejb.43.2021.01.02.17.25.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 02 Jan 2021 17:25:58 -0800 (PST)
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To:     hauke@hauke-m.de, netdev@vger.kernel.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH 0/2] net: dsa: lantiq_gswip: two fixes for -net/-stable
Date:   Sun,  3 Jan 2021 02:25:42 +0100
Message-Id: <20210103012544.3259029-1-martin.blumenstingl@googlemail.com>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While testing the lantiq_gswip driver in OpenWrt at least one board had
a non-working Ethernet port connected to an internal 100Mbit/s PHY22F
GPHY. The problem which could be observed:
- the PHY would detect the link just fine
- ethtool stats would see the TX counter rise
- the RX counter in ethtool was stuck at zero

It turns out that two independent patches are needed to fix this:
- first we need to enable the MII data lines also for internal PHYs
- second we need to program the GSWIP_MII_CFG registers for all ports
  except the CPU port

These two patches have also been tested by back-porting them on top of
Linux 5.4.86 in OpenWrt.

Special thanks to Hauke for debugging and brainstorming this on IRC
with me!


Martin Blumenstingl (2):
  net: dsa: lantiq_gswip: Enable GSWIP_MII_CFG_EN also for internal PHYs
  net: dsa: lantiq_gswip: Fix GSWIP_MII_CFG(p) register access

 drivers/net/dsa/lantiq_gswip.c | 27 +++++++--------------------
 1 file changed, 7 insertions(+), 20 deletions(-)

-- 
2.30.0


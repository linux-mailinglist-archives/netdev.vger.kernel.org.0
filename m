Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 075D555058A
	for <lists+netdev@lfdr.de>; Sat, 18 Jun 2022 16:48:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232719AbiFROs2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Jun 2022 10:48:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbiFROs1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Jun 2022 10:48:27 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6987217A97;
        Sat, 18 Jun 2022 07:48:26 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id n20so6799898ejz.10;
        Sat, 18 Jun 2022 07:48:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=WlLbgDasKJ1im1j+lOloRZZaui0VTdPP0RSuLZMaCi8=;
        b=UY1TU11K1ASSWh4jo62ivRwnhP5NHZoa/nSs5/KgycrfEqO9AQfhSlUy3uykE+riVo
         sOUSmVBtabe48idsgp5ypyOnTRloIX6v+BLsu5rUILoEK1mtNcTnbo0fzhKbZL6kQDjw
         PPAkTSZVwG4cC5MH05FKkMLlmBpOJ3XPhy4jm4xOysveDIsBTknOhIAkJ8WocQALdjIR
         Erd5clNJ4esQBKqVSfQ2l9g4zfC8rhTvELIySz6yy9gXOsvkS5FdPi6lz7iZtaz1N3iy
         91CQE0azAYJ5HEU44QzWeaITA7I2YHgufi/YlqIEGSFbXIj/27hH+fAs2Oa++uNVK1io
         9oAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=WlLbgDasKJ1im1j+lOloRZZaui0VTdPP0RSuLZMaCi8=;
        b=mfDFYRXzIFadPVJRmm3uWpnAu5lYsAhFsQxRcDVT06qYtVMZmbC0Hgg5CSbyQlWV2D
         NkEzh+2wrM/KQiEx8a8PNZPUVLS8lhnP/nvdEq+j/94jnh3FatDhQydAXS5oULXiOZtY
         p6NW05vsAyJtWNFvYbsoVWucUWEVnCjpR5XdsF833muMwKHiL5edDfW4a2NVVhi+1Mbe
         gIbXsobJ8ZsrNV9ZgcQqynRR+IpAUUnbM4FPm66wwAS/oXjODv28j00i3JEMUPzzEcNm
         QLpDUSRRVhmZhW++hktiVo3I8IlcE14FZWSE1XQW7q00zJJtah5oONmbVX8vJwqWkRIN
         3UPw==
X-Gm-Message-State: AJIora/hFdTBJgApYDVBwwFEypgzodejrM9wD1k74IpXWbnOWxVSOuWV
        McExJbNv/OtDOLc2VcpL/VxWyFe6ySE=
X-Google-Smtp-Source: AGRyM1t+IwA+CvOfT/inbDO1uhckKDbqX+arxd1vk83uvy6IWXxT8iH40dsykJZez36LpryYEbJcvQ==
X-Received: by 2002:a17:907:1b1e:b0:6d7:31b0:e821 with SMTP id mp30-20020a1709071b1e00b006d731b0e821mr13798089ejc.334.1655563704707;
        Sat, 18 Jun 2022 07:48:24 -0700 (PDT)
Received: from localhost.localdomain (93-42-70-190.ip85.fastwebnet.it. [93.42.70.190])
        by smtp.googlemail.com with ESMTPSA id h20-20020a1709070b1400b006fe7d269db8sm3450296ejl.104.2022.06.18.07.48.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Jun 2022 07:48:24 -0700 (PDT)
From:   Christian Marangi <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jonathan McDowell <noodles@earth.li>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Christian Marangi <ansuelsmth@gmail.com>
Subject: [PATCH 1/3] net: dsa: qca8k: reduce mgmt ethernet timeout
Date:   Sat, 18 Jun 2022 08:22:58 +0200
Message-Id: <20220618062300.28541-1-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DATE_IN_PAST_06_12,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The current mgmt ethernet timeout is set to 100ms. This value is too
big and would slow down any mdio command in case the mgmt ethernet
packet have some problems on the receiving part.
Reduce it to just 5ms to handle case when some operation are done on the
master port that would cause the mgmt ethernet to not work temporarily.

Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
---
 drivers/net/dsa/qca8k.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/qca8k.h b/drivers/net/dsa/qca8k.h
index 04408e11402a..ec58d0e80a70 100644
--- a/drivers/net/dsa/qca8k.h
+++ b/drivers/net/dsa/qca8k.h
@@ -15,7 +15,7 @@
 
 #define QCA8K_ETHERNET_MDIO_PRIORITY			7
 #define QCA8K_ETHERNET_PHY_PRIORITY			6
-#define QCA8K_ETHERNET_TIMEOUT				100
+#define QCA8K_ETHERNET_TIMEOUT				5
 
 #define QCA8K_NUM_PORTS					7
 #define QCA8K_NUM_CPU_PORTS				2
-- 
2.36.1


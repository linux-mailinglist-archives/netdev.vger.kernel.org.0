Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DF885505E5
	for <lists+netdev@lfdr.de>; Sat, 18 Jun 2022 17:52:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234460AbiFRPwQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Jun 2022 11:52:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230082AbiFRPwP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Jun 2022 11:52:15 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7433813D10;
        Sat, 18 Jun 2022 08:52:14 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id m32-20020a05600c3b2000b0039756bb41f2so3702667wms.3;
        Sat, 18 Jun 2022 08:52:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=WlLbgDasKJ1im1j+lOloRZZaui0VTdPP0RSuLZMaCi8=;
        b=WUFejGDG/Z44pDXvIUaaiJbcI7gUm1KnhUNL/rZLSInthig5fAgnIkZKgtEc7k00dF
         KwpEOSH8SxzVDSxU+TcIlXv2hdi+m3Z1voHYeGx4pVLvTs/LE/5ls+LkgFLvm0NSep19
         85ViAZL9PC8oicozXpDd8LOj77Outv5nvjEa31Tn+jVvp6uZ7MdOqZglvxRt9GBAZe/L
         gKRYi26veR+qfwmoAr0Z3U1qAFmpG//tMYgAx6b0WR8GMNgV6io/G3Cxjwm4WQvhaBFw
         Jdei4b8VsukIaX+OnDjpVjt8vnH8N6p1xq2jVbG5gNiQgYZLRinYQr1Q9uLQ/gt3voHb
         X8cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=WlLbgDasKJ1im1j+lOloRZZaui0VTdPP0RSuLZMaCi8=;
        b=UVt1ZGHjuGUoE6X170NQ1ylpcnaLxfkPGljn+p0hQpJ8sSgShXkqrn4wO/kUfS4yWE
         k546J/KjxiDA0drc7PWYdhVD92iahVYjeaRCXSpUeWD9dOEMrhZqgIjQTCTQRcZ2UEwM
         bwBPneuKY4+wDNkgQ7m7fZbzKwpYsu7USNPa4lrFL8PFL4gOenPUHSYiJ4CCkAav7TJO
         gFbykNc3NWIphCOGpsDF5OgGnFCPnuFT08DhKLnhlsPtctNmjipUnmDb+W1uDmEMDIKj
         mO44TQm3x1anihyjj3dDCl7KzC/A79Z9EEf1jVWumjk3peJRVUSyfDbpZc0ZQxriTwok
         m7lw==
X-Gm-Message-State: AOAM532VoLfTJk2sDBvBmmrP7LBmqNK16GNU0iYKnA+GJUcYXMUjZm0v
        h1fv2vKeNzSiDhifYll05fM=
X-Google-Smtp-Source: ABdhPJzDAGYaxccU9fjdXNossisUYb/8irdwQBJFqJMXllpbLj7P2DrSKd+EgBYo6QuwJTWji1wm4Q==
X-Received: by 2002:a05:600c:4ec9:b0:39c:69c7:715d with SMTP id g9-20020a05600c4ec900b0039c69c7715dmr25799221wmq.154.1655567532736;
        Sat, 18 Jun 2022 08:52:12 -0700 (PDT)
Received: from localhost.localdomain (93-42-70-190.ip85.fastwebnet.it. [93.42.70.190])
        by smtp.googlemail.com with ESMTPSA id a8-20020adfed08000000b0020d106c0386sm1952188wro.89.2022.06.18.08.52.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Jun 2022 08:52:12 -0700 (PDT)
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
Subject: [RESEND net-next PATCH 1/3] net: dsa: qca8k: reduce mgmt ethernet timeout
Date:   Sat, 18 Jun 2022 09:26:48 +0200
Message-Id: <20220618072650.3502-1-ansuelsmth@gmail.com>
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


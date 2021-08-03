Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AE7B3DEE00
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 14:41:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236098AbhHCMlN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 08:41:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236028AbhHCMlA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Aug 2021 08:41:00 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A27BEC061764;
        Tue,  3 Aug 2021 05:40:49 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id u16so15012210ple.2;
        Tue, 03 Aug 2021 05:40:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=IghreoH0EV+JzcXbJzyg8ag9UQhB8aBaKVtS7Rb1A+E=;
        b=tZPIOGHtyiSJSaC1x9erQ0KSW4TgYQvx7WTuNUjv4yE42XcuCl9Euzn+SPJT/Gv+/x
         LXgYMJUpYz9QFXL4lBXg/DT+gYh6E/NO4Tmbmo4VlANCI7aKmF4Gfic+j+vN5IBKSXCd
         N3D/7L2yCDmi0FSc3amZE+946RSZphpDT0ubzA8P+sd9IdEjwD1Os8/2iFfFJSNTKYu0
         yA8Pm1j5/2HZ19udQxVYMKlGdOzMiHZdlCVj2pZ2T8vsH78rKUPBrjTQ0nYD+b7GTfjU
         7tZPk0Wk7/ALw6wWOVX0FlahMUq5KI1HKKi8W1+uFpUBosO2ffwjMmq87TIiiDMKEgvK
         uwNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=IghreoH0EV+JzcXbJzyg8ag9UQhB8aBaKVtS7Rb1A+E=;
        b=J+XhuOurCjQYV/vcwAjlv3DFXZcZfujNK4LMya/zqWEhWKckEJ+wpunVijXENLi9Ye
         ZNngbp2s01ZZYNtlTMlxjjDfjTPFxgnV/nFr+W1uHxA8KeTJJuBqHzmjRl6QOLPXdEIc
         66GqkTQOqXWUx+dxMyB+eY0oD0gdYA1VgyyCvrlFckiDhrPPGtNp+7zDkAXznwrNGjnj
         +NfMB4rv312SZbDxorKkpXi3yHFaH2+s24Oij4Ue5h7Y0lW1R1+eJx1xXS0xRZrdB9ME
         fzZzJe8Ug0QlAc2II4A1vPs+1oO5ymxtLLzccbTQtzmAFXx2FClhHQ7frnOqDi32HEtz
         GnXQ==
X-Gm-Message-State: AOAM533PWJT6JCsP56B0pOpMaW4Wc7trUYZ2I4Ei/MvhyrP/faVFLykD
        Hz3iN66UwJN0Fs2DxohiLHk=
X-Google-Smtp-Source: ABdhPJzipk/rEXZOBgGQv1DnquIjRxhiFr8GQzLr+KoPcpuPmQflWsm+Bt6zcvyGvQr451BVfZ3oBQ==
X-Received: by 2002:a17:902:c202:b029:12c:9970:bdf9 with SMTP id 2-20020a170902c202b029012c9970bdf9mr16524134pll.30.1627994449277;
        Tue, 03 Aug 2021 05:40:49 -0700 (PDT)
Received: from haswell-ubuntu20.lan ([138.197.212.246])
        by smtp.gmail.com with ESMTPSA id g25sm15747499pfk.138.2021.08.03.05.40.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Aug 2021 05:40:48 -0700 (PDT)
From:   DENG Qingfang <dqfext@gmail.com>
To:     Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Cc:     Eric Woudstra <ericwouds@gmail.com>,
        =?UTF-8?q?Ren=C3=A9=20van=20Dorst?= <opensource@vdorst.com>,
        Frank Wunderlich <frank-w@public-files.de>,
        Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
Subject: [PATCH net-next 3/4] net: dsa: mt7530: set STP state on filter ID 1
Date:   Tue,  3 Aug 2021 20:40:21 +0800
Message-Id: <20210803124022.2912298-4-dqfext@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210803124022.2912298-1-dqfext@gmail.com>
References: <20210803124022.2912298-1-dqfext@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As filter ID 1 is the only one used for bridges, set STP state on it.

Signed-off-by: DENG Qingfang <dqfext@gmail.com>
---
RFC -> v1: only set FID 1's state

 drivers/net/dsa/mt7530.c | 3 ++-
 drivers/net/dsa/mt7530.h | 4 ++--
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index 12f449a54833..8d84d7ddad38 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -1147,7 +1147,8 @@ mt7530_stp_state_set(struct dsa_switch *ds, int port, u8 state)
 		break;
 	}
 
-	mt7530_rmw(priv, MT7530_SSP_P(port), FID_PST_MASK, stp_state);
+	mt7530_rmw(priv, MT7530_SSP_P(port), FID1_PST_MASK,
+		   FID1_PST(stp_state));
 }
 
 static int
diff --git a/drivers/net/dsa/mt7530.h b/drivers/net/dsa/mt7530.h
index a308886fdebc..53b7bb1f5368 100644
--- a/drivers/net/dsa/mt7530.h
+++ b/drivers/net/dsa/mt7530.h
@@ -181,8 +181,8 @@ enum mt7530_vlan_egress_attr {
 
 /* Register for port STP state control */
 #define MT7530_SSP_P(x)			(0x2000 + ((x) * 0x100))
-#define  FID_PST(x)			((x) & 0x3)
-#define  FID_PST_MASK			FID_PST(0x3)
+#define  FID1_PST(x)			(((x) & 0x3) << 2)
+#define  FID1_PST_MASK			FID1_PST(0x3)
 
 enum mt7530_stp_state {
 	MT7530_STP_DISABLED = 0,
-- 
2.25.1


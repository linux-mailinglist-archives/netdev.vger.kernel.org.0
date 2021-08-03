Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E6DD3DF210
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 18:04:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231907AbhHCQEy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 12:04:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231659AbhHCQEv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Aug 2021 12:04:51 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93DBEC061757;
        Tue,  3 Aug 2021 09:04:37 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id mt6so30265084pjb.1;
        Tue, 03 Aug 2021 09:04:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rFG+y2/f0kIS+1piSi01lqKfhQxPbZdynLRltnbgxiQ=;
        b=b4ukp4ubuRoZUf5QUsgGIX5Z8hvILnPKu2bruY8jXI93TywzIyFGzaosjq4ZjaNoAC
         OKdQZZJ06HFDVSEohb37uw6lIL88NyO5QjsVGO0KoSM/rbmyRPcvJzuP6Qh3bGN9zyul
         alerxWFjJxOIGbCUqIZGOXxcxx7QHqCQBazx/skeJLZLvZixB9/WZfmx7Wxi4RZpE/WS
         E3kmThx1F+PtgAXmLlYi4AsW3TzJoFxMLq4dkOsy+A6ym1ZMYGm+dns1Wgd73GlDasVH
         7P5x9yiaipdWdfFRLVnsY9pdTOua3l35OpEPyzZdHquo5u6TBeWZa9zW9T1AgPjqBbgu
         VtUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rFG+y2/f0kIS+1piSi01lqKfhQxPbZdynLRltnbgxiQ=;
        b=Ez03jqJpsgo2pNeJfrrL7xJS55ucLBZrnbu3wknXD8ZX/OfgooQb2I8qBZSUkv/GeG
         zz35VR3UBMiD4zh7tQ7XzlFrfuck1dLZXOib2hhbz8F1f8vbgKbE2DZiASasVFCAJfk0
         5GadMQjgIOm18SL2bbVsKDlkN6R3Z/7xAQ/3q+9ynmgbHNb2Ta8rzRdQIZfdfndG3VKa
         vc5jNLbE+wQZNHFXAYIHU8fDk0J7PrYHMMxoan6wBWXoPSvHg066GWXWeRHOQK993P4+
         ANZM3IZgX3C78v6iMA3BY14FCEa5AgNSed1cH0GEhLyyd/R2NCeo+vJdG/cTcNpOtc+x
         hsbg==
X-Gm-Message-State: AOAM532fjO6QCA2v2P9csPNMB71oR/kbrzHQov0+2qhFrGujIXgDwIIa
        s06FeL3h65IeGEvT8ZGGuvQ=
X-Google-Smtp-Source: ABdhPJx4BoskHpHIo9eH9vJqEQqPWI4dffs5KXtrUgvidGJ1BKKYoycFmaK2P+nodC/c528ekaPG3A==
X-Received: by 2002:a63:62c7:: with SMTP id w190mr288455pgb.55.1628006677214;
        Tue, 03 Aug 2021 09:04:37 -0700 (PDT)
Received: from haswell-ubuntu20.lan ([138.197.212.246])
        by smtp.gmail.com with ESMTPSA id y6sm14390653pjr.48.2021.08.03.09.04.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Aug 2021 09:04:36 -0700 (PDT)
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
Subject: [PATCH net-next v2 3/4] net: dsa: mt7530: set STP state on filter ID 1
Date:   Wed,  4 Aug 2021 00:04:03 +0800
Message-Id: <20210803160405.3025624-4-dqfext@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210803160405.3025624-1-dqfext@gmail.com>
References: <20210803160405.3025624-1-dqfext@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As filter ID 1 is the only one used for bridges, set STP state on it.

Signed-off-by: DENG Qingfang <dqfext@gmail.com>
---
v1 -> v2: use FID enum instead of hardcoding.

 drivers/net/dsa/mt7530.c | 3 ++-
 drivers/net/dsa/mt7530.h | 4 ++--
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index 606a9f4db579..9b39ccd9dd4c 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -1147,7 +1147,8 @@ mt7530_stp_state_set(struct dsa_switch *ds, int port, u8 state)
 		break;
 	}
 
-	mt7530_rmw(priv, MT7530_SSP_P(port), FID_PST_MASK, stp_state);
+	mt7530_rmw(priv, MT7530_SSP_P(port), FID_PST_MASK(FID_BRIDGED),
+		   FID_PST(FID_BRIDGED, stp_state));
 }
 
 static int
diff --git a/drivers/net/dsa/mt7530.h b/drivers/net/dsa/mt7530.h
index d44640bbd865..5b70ccef9459 100644
--- a/drivers/net/dsa/mt7530.h
+++ b/drivers/net/dsa/mt7530.h
@@ -186,8 +186,8 @@ enum mt7530_vlan_egress_attr {
 
 /* Register for port STP state control */
 #define MT7530_SSP_P(x)			(0x2000 + ((x) * 0x100))
-#define  FID_PST(x)			((x) & 0x3)
-#define  FID_PST_MASK			FID_PST(0x3)
+#define  FID_PST(fid, state)		(((state) & 0x3) << ((fid) * 2))
+#define  FID_PST_MASK(fid)		FID_PST(fid, 0x3)
 
 enum mt7530_stp_state {
 	MT7530_STP_DISABLED = 0,
-- 
2.25.1


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3804C1A725C
	for <lists+netdev@lfdr.de>; Tue, 14 Apr 2020 06:17:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405197AbgDNERS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Apr 2020 00:17:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2405149AbgDNEQq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Apr 2020 00:16:46 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD440C008748;
        Mon, 13 Apr 2020 21:16:45 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id a25so12727319wrd.0;
        Mon, 13 Apr 2020 21:16:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=ra5+xF56vl//7UQmklkjgQ0mAqGgB+1LQ/hOVbR+zp8=;
        b=n1mQh4zZgBTivIGIq0ThPh99lt7S4FyW1UChIFlAwSdXkBJR2/4+kSNFOa/WCLQA03
         nkg/u3g+SRR0REzWDyTaoYwsc+1kZ3R5zIpgqdDI8Fdx3pwMUxYuPDJc879NJzCbCqTS
         Yg+lwbtKbsMfPp/Plt5urXY7NUAcKKlowAUNj+WbOiRq4aXfG65C6i85IEnvygc0vlcP
         Me5OX7gtNUwonSK03HGwxucAg0ljDeNBsajyWyVCI37QWVq6EWcN+bzlBkFHjZXLf0w7
         KSmtnhzTkBygOd3vULpq+Ss6TooUf4zBnJ8gx7i7VnmIdydkvu87illGZUh1urZS11gj
         Osfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=ra5+xF56vl//7UQmklkjgQ0mAqGgB+1LQ/hOVbR+zp8=;
        b=AjJ0kUMgm857nmte4Ht4PFSP7w+Gb5TZ9MeiHEsgS34ZeJiB+U32SSMToJHHxDjtV8
         VLFak+6Kf2nxM4LEEW1lMJoG7v+8PD+x69Zpw0NRWufuzwCG8YQCg8e/ejAUSqe6jed0
         dJa9yf4HFsuOIWDl5XpU6WG7erkT6ts11JEieKZaBf5D5eH0WGgTB/Hd1eYg4ki9F0hw
         ksm7rj3N3Pdy/PsO0USE0gLEhMBXLOWG6oD4cwpTR+D0HqFiKyBbYDAN5fbPSY9+BUgG
         tWsie4b2/3M0UNkSrxYGcjqMkYbZ3DDFpdIetGrN+39P3FrRiTR1RThv2SXY8fJvJPGu
         ZlsQ==
X-Gm-Message-State: AGi0PubDjWwcUpQc1DhQTXwrnBh4EyvafWQhQKNjY4P0NljjuHzhwot4
        YGiX3RyyVzgtiBv/ei6ChasZXDLA
X-Google-Smtp-Source: APiQypJ/i7+CQzsGFIbl7j9E8gK6ahy1bJ4l277DKHg/E1+y06RBB87cOEhcbxQubMbHmFFOlf1Cnw==
X-Received: by 2002:a5d:5273:: with SMTP id l19mr21605238wrc.42.1586837804231;
        Mon, 13 Apr 2020 21:16:44 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id n4sm16704471wmi.20.2020.04.13.21.16.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Apr 2020 21:16:43 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@savoirfairelinux.com>,
        linux-kernel@vger.kernel.org (open list), davem@davemloft.net,
        kuba@kernel.org
Subject: [PATCH net 3/4] net: dsa: b53: Fix ARL register definitions
Date:   Mon, 13 Apr 2020 21:16:29 -0700
Message-Id: <20200414041630.5740-4-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200414041630.5740-1-f.fainelli@gmail.com>
References: <20200414041630.5740-1-f.fainelli@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The ARL {MAC,VID} tuple and the forward entry were off by 0x10 bytes,
which means that when we read/wrote from/to ARL bin index 0, we were
actually accessing the ARLA_RWCTRL register.

Fixes: 1da6df85c6fb ("net: dsa: b53: Implement ARL add/del/dump operations")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/dsa/b53/b53_regs.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/b53/b53_regs.h b/drivers/net/dsa/b53/b53_regs.h
index 2a9f421680aa..d914e756cdab 100644
--- a/drivers/net/dsa/b53/b53_regs.h
+++ b/drivers/net/dsa/b53/b53_regs.h
@@ -304,7 +304,7 @@
  *
  * BCM5325 and BCM5365 share most definitions below
  */
-#define B53_ARLTBL_MAC_VID_ENTRY(n)	(0x10 * (n))
+#define B53_ARLTBL_MAC_VID_ENTRY(n)	((0x10 * (n)) + 0x10)
 #define   ARLTBL_MAC_MASK		0xffffffffffffULL
 #define   ARLTBL_VID_S			48
 #define   ARLTBL_VID_MASK_25		0xff
@@ -316,7 +316,7 @@
 #define   ARLTBL_VALID_25		BIT(63)
 
 /* ARL Table Data Entry N Registers (32 bit) */
-#define B53_ARLTBL_DATA_ENTRY(n)	((0x10 * (n)) + 0x08)
+#define B53_ARLTBL_DATA_ENTRY(n)	((0x10 * (n)) + 0x18)
 #define   ARLTBL_DATA_PORT_ID_MASK	0x1ff
 #define   ARLTBL_TC(tc)			((3 & tc) << 11)
 #define   ARLTBL_AGE			BIT(14)
-- 
2.17.1


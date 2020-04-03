Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6EFA219D5DA
	for <lists+netdev@lfdr.de>; Fri,  3 Apr 2020 13:30:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390802AbgDCL34 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Apr 2020 07:29:56 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:34302 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390783AbgDCL3q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Apr 2020 07:29:46 -0400
Received: by mail-pl1-f195.google.com with SMTP id a23so2607480plm.1;
        Fri, 03 Apr 2020 04:29:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8rXpdWw7x9PpBvoBR/qm/XcVJsNWHJ1tSvQ9UIVcPLA=;
        b=iegDoB1IxCA4quOPEOuEst/h/o+3lRJuFDKhH/u9bys+FKqKdgPy8zwo7dxJoU2DwR
         OqDJQKEkNLhlMWWPZ065eDbOe6Eo4ZD2JqnLMoX4sksEkxM3ZDYy5kzvKC2zOoRSXSix
         t4aCJWtpQqSvrC2solgN22MI9dJUgkfeMjY9mCzCjV3+JrCclicKu8HBvSumuae23O0f
         YKuek9MktR7z3Pa6J8hUkwLCmerbyvtBYv3ux2yPUeMxkyXQt8qVyoEDBorLtSBfEd5K
         OyxNXrHVYivJX0Up0fRhONeNVQ+BFkAj2kkYUT2zWAdglRTaY2wwTkrVVQKGMJYZypuJ
         v5YA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8rXpdWw7x9PpBvoBR/qm/XcVJsNWHJ1tSvQ9UIVcPLA=;
        b=kXlRLJUqIFfWAFPsfiwYuGzh5x1N3JZ3KQW7qFLWFkLE5Ai/l6mMccFhnZajqXiFA6
         tCzhjuIEwJ497mwwRbceZpwRDh8m5MDz98GmBwuZlrYN95D52ZYPC67Sof55lVOw0VJ9
         my6XkabdGL1fNS64ztn05A8WiNzqRboQhB+dKVbX5ASzx2DVZVCHnqB2n7YS+UnsF8OH
         4ZGt7in73vy4qsVRh1bOwwFx2ZPI2GMmz9VetkPxWOC2mjJuWIAlcub4KpmdHU5uKuz5
         BYEva4Y59ye/BynE+GGJuGYCy6ZwmhTZDXHcanI+sValOygyUbcmIC+T9TIZDput3UHb
         Mr1Q==
X-Gm-Message-State: AGi0PuaRyRoZjx880J91xAQaoPPKbY3MZLDFEjJlw1hgc6K1KOUKUSDL
        Ou93nUOCClTk1kyiBVV/l8p1Uyp0gw8=
X-Google-Smtp-Source: APiQypJ73aRw0jbyNSgssLXyjPahMN2KTO/im/OozAk2AXrhtWeGe0HEMNdi7dRewEFL4MTJbkL6Mg==
X-Received: by 2002:a17:90a:37ea:: with SMTP id v97mr9591002pjb.26.1585913384901;
        Fri, 03 Apr 2020 04:29:44 -0700 (PDT)
Received: from guoguo-omen.lan ([240e:379:95c:7214:abe6:11ff:840d:b9a7])
        by smtp.gmail.com with ESMTPSA id g18sm5034114pgh.42.2020.04.03.04.29.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Apr 2020 04:29:44 -0700 (PDT)
From:   Chuanhong Guo <gch981213@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Chuanhong Guo <gch981213@gmail.com>, stable@vger.kernel.org,
        Sean Wang <sean.wang@mediatek.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        =?UTF-8?q?Ren=C3=A9=20van=20Dorst?= <opensource@vdorst.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net: dsa: mt7530: fix null pointer dereferencing in port5 setup
Date:   Fri,  3 Apr 2020 19:28:24 +0800
Message-Id: <20200403112830.505720-1-gch981213@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 2nd gmac of mediatek soc ethernet may not be connected to a PHY
and a phy-handle isn't always available.
Unfortunately, mt7530 dsa driver assumes that the 2nd gmac is always
connected to switch port 5 and setup mt7530 according to phy address
of 2nd gmac node, causing null pointer dereferencing when phy-handle
isn't defined in dts.
This commit fix this setup code by checking return value of
of_parse_phandle before using it.

Fixes: 38f790a80560 ("net: dsa: mt7530: Add support for port 5")
Signed-off-by: Chuanhong Guo <gch981213@gmail.com>
Cc: stable@vger.kernel.org
---

mt7530 is available as a standalone chip and we should not make it
tightly coupled with a specific type of ethernet dt binding in the
first place.
A proper fix is to replace this port detection logic with a dt
property under mt7530 node, but that's too much for linux-stable.

 drivers/net/dsa/mt7530.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index 6e91fe2f4b9a..1d53a4ebcd5a 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -1414,6 +1414,9 @@ mt7530_setup(struct dsa_switch *ds)
 				continue;
 
 			phy_node = of_parse_phandle(mac_np, "phy-handle", 0);
+			if (!phy_node)
+				continue;
+
 			if (phy_node->parent == priv->dev->of_node->parent) {
 				ret = of_get_phy_mode(mac_np, &interface);
 				if (ret && ret != -ENODEV)
-- 
2.25.1


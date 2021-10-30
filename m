Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADBB6440AAC
	for <lists+netdev@lfdr.de>; Sat, 30 Oct 2021 19:41:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230233AbhJ3Rnq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Oct 2021 13:43:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229474AbhJ3Rno (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Oct 2021 13:43:44 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F9A5C061570;
        Sat, 30 Oct 2021 10:41:14 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id s13so14549739wrb.3;
        Sat, 30 Oct 2021 10:41:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Eu1iSxTwRsLRLsgJoPAuIgttiEmBvdky8CdJQqw7CWM=;
        b=gdgSK30LOSfVUGzzocLUT7jd+cwOhjqLoxi7H8dpqgaalI+3fw7o4Tn715iyv06FHF
         /yPDY4seZH/R7cQy5XyyWy2GKwI8ezSJCt+W5nEzVnvOtD3J+6LVKwyNic8zNp3RU8lL
         f9JFgUEPRGXrjK9YstZqMpcS+DoWZx73q+iCEGXAndZwdcb78QmShPH8lwKt6JV9SX84
         grFZvV0Di886F9BM5NF0IZoR/wnI/v8LnNf2BKFuCCJOVbm+lIhf7dxvHBNwkEcPmQtj
         utf+owvMEfXLvHRNWk6oQJ4ABq+opoQjxKL2LJOI702Cj6MfgFBuN+mmP2uLMdnwVJex
         7lfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Eu1iSxTwRsLRLsgJoPAuIgttiEmBvdky8CdJQqw7CWM=;
        b=Xtg63LGpzgNJ5ulq+/xPsw5G1dlITQjJWtfs29PcAklDMtDxntXUEyr75VrFN48ATA
         /wVB41dUxDKtXsuhzkPGHt+8iuv70dKWsdlaFPOCAAeR8EvD/uSVxcUybFgrrus/QU2a
         ronvXKItVkTudaFt7zClEueJNr8XehGzdGoc4E/zsad2fGODBJ+nKPg0hGzzA6IeGcHZ
         Jejc/m8L5dnGl2pHf4OFVUyoL1sANCXgsUu8fSC0ocPwDZMKhwREgvcmkVVbw78mFF8l
         p9WR2Qz7zy+irIAtwM32jrwNpueI0gHnMvgb1fZ3OEUy+l97MLfv3JywJkNLB7qWtHAv
         lfNA==
X-Gm-Message-State: AOAM532e5Uu/YXHswPzpGnz+PXsGx3wFLgO5KDCdS/lXsNnX6D9H3zOw
        zZzQArBogUELGlX6gioBlK8Q4e2UFYs=
X-Google-Smtp-Source: ABdhPJwteW9Gltx7viCtDKg6VAfQ/Ssaz6GcgW8wMGZfPvYZySJ6XnzED4rE8e3Zyf1HIBDcpPKHfw==
X-Received: by 2002:a5d:6843:: with SMTP id o3mr12747163wrw.174.1635615672623;
        Sat, 30 Oct 2021 10:41:12 -0700 (PDT)
Received: from debian64.daheim (p5b0d7cd8.dip0.t-ipconnect.de. [91.13.124.216])
        by smtp.gmail.com with ESMTPSA id z6sm354992wrm.93.2021.10.30.10.41.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 30 Oct 2021 10:41:12 -0700 (PDT)
Received: from chuck by debian64.daheim with local (Exim 4.95)
        (envelope-from <chunkeey@gmail.com>)
        id 1mgsLv-0060he-Rl;
        Sat, 30 Oct 2021 19:41:11 +0200
From:   Christian Lamparter <chunkeey@gmail.com>
To:     netdev@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-wireless@vger.kernel.org, ath10k@lists.infradead.org
Cc:     Ansuel Smith <ansuelsmth@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, Len Brown <lenb@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>, Michael Walle <michael@walle.cc>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [RFC net-next/wireless-next v1 1/2] ethernet: check nvmem cells for mac-address
Date:   Sat, 30 Oct 2021 19:41:10 +0200
Message-Id: <20211030174111.1432663-1-chunkeey@gmail.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

of_get_mac_address() gained this function with
commit d01f449c008a ("of_net: add NVMEM support to of_get_mac_address")
with the following justification:
"Many embedded devices have information such as MAC addresses stored
inside NVMEMs like EEPROMs and so on. [...]

Adding support for NVMEM into every other driver would mean adding a lot
of repetitive code. This patch allows us to configure MAC addresses in
various devices like ethernet and wireless adapters directly [...]."

the common device_/fwnode_get_mac_address could use the
same functionality by just a few adjustments.

Signed-off-by: Christian Lamparter <chunkeey@gmail.com>
---
 net/ethernet/eth.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/ethernet/eth.c b/net/ethernet/eth.c
index c7d9e08107cb..5e55b08577b1 100644
--- a/net/ethernet/eth.c
+++ b/net/ethernet/eth.c
@@ -602,7 +602,9 @@ static int fwnode_get_mac_addr(struct fwnode_handle *fwnode,
  * checked first, because that is supposed to contain to "most recent" MAC
  * address. If that isn't set, then 'local-mac-address' is checked next,
  * because that is the default address.  If that isn't set, then the obsolete
- * 'address' is checked, just in case we're using an old device tree.
+ * 'address' is checked, just in case we're using an old device tree. If any
+ * of the above isn't set, then try to get MAC address from nvmem cell named
+ * 'mac-address'.
  *
  * Note that the 'address' property is supposed to contain a virtual address of
  * the register set, but some DTS files have redefined that property to be the
@@ -622,7 +624,7 @@ int fwnode_get_mac_address(struct fwnode_handle *fwnode, char *addr)
 	    !fwnode_get_mac_addr(fwnode, "address", addr))
 		return 0;
 
-	return -ENOENT;
+	return nvmem_get_mac_address(fwnode->dev, addr);
 }
 EXPORT_SYMBOL(fwnode_get_mac_address);
 
-- 
2.33.1


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 454AA3F0785
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 17:07:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239783AbhHRPHw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 11:07:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235131AbhHRPHr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Aug 2021 11:07:47 -0400
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8288C061764;
        Wed, 18 Aug 2021 08:07:12 -0700 (PDT)
Received: by mail-lj1-x230.google.com with SMTP id x7so5650691ljn.10;
        Wed, 18 Aug 2021 08:07:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Uq7jOLhIzmeqdxixhYyKft2oiqKCnNb7TcSQh4dCmmU=;
        b=IZhIe7wkQo6rWVFNpLkLjbd4rWhBuJVTk1KQn9uc5JhLOTMs5dKuWlBDZU7XFsLxhl
         XcO7151yxMctmP9N008kq3O+gK7eDtg/KH//wn3mikEY+pTL22wLvCRA97QrjilnI1w6
         Ld4KlEYWV3qTWHZBvlCRFNn7GvuUB4pYQqu43/ykPDzHFPAdOyLF7/nbX3RBI+uu5tmi
         3pUWaRaxy4PHHtn73lIfSdmznbyxG7oeu3mpC1ms/n5T3vr3A283oggPwc5XjGr0MhSD
         oQOkq9DDJv5dIre/M6HLvZymcfRImW2HCt7kfqQuNnxjKktxwRHoEaxKYlBu/IjuvdJS
         P+EA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Uq7jOLhIzmeqdxixhYyKft2oiqKCnNb7TcSQh4dCmmU=;
        b=lBqPNNJ6QkQKK3h9pLCK6IAgjakM/lnE06CBFj5JT/aJNY1o6wyWXM9TaFX0iQhYFk
         8f/a64cj8gh72En7lXBfOYx1ctjgdbJ2r+uRO6cdr/AKjkN7ortQBnaISBx2vP6nRtvp
         bbWR2S3VRGnEVZkkBVpGclLDdW1FqVzIF8lB6RHVhLDsLipFiSKwgv0e04YYKVZeQqbY
         wSlFG6jqAQE61djAAziO8SYMWM+SIVrijcmXmeqyuzrQzwfFllPjxeMb3VRuTPS8s1tv
         KSkoEjiNu96HIek1qF6WjmZVi11hK4Jte/8ixcZZUMpHfthiq4Kenxg6yi8PPewsTUCt
         b/kg==
X-Gm-Message-State: AOAM533Sy6blgryqas8qhtJaAazAlMcUc3/4ahlCt0u7oYsCH6i5fieY
        wqJEFqo25SrgosIaEoHEws8=
X-Google-Smtp-Source: ABdhPJz2qLRT1pY8IVngUaTPpNPePT6GeD9ixYTs5scUybiQs90CkMkkPA/QHzJcTYiZUkU9rODxWw==
X-Received: by 2002:a2e:9594:: with SMTP id w20mr8456492ljh.361.1629299231061;
        Wed, 18 Aug 2021 08:07:11 -0700 (PDT)
Received: from localhost.localdomain ([46.235.66.127])
        by smtp.gmail.com with ESMTPSA id c10sm11811ljr.134.2021.08.18.08.07.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Aug 2021 08:07:10 -0700 (PDT)
From:   Pavel Skripkin <paskripkin@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org,
        andriy.shevchenko@linux.intel.com, christophe.jaillet@wanadoo.fr,
        kaixuxia@tencent.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pavel Skripkin <paskripkin@gmail.com>
Subject: [PATCH v3 2/2] net: mii: make mii_ethtool_gset() return void
Date:   Wed, 18 Aug 2021 18:07:09 +0300
Message-Id: <0e388dcbe5bbf002b15ba760191e1a862723bc07.1629298981.git.paskripkin@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <7e8946ac52de91a963beb7fa0354a19a21c5cf73.1629298981.git.paskripkin@gmail.com>
References: <7e8946ac52de91a963beb7fa0354a19a21c5cf73.1629298981.git.paskripkin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

mii_ethtool_gset() does not return any errors. Since there are no users
of this function that rely on its return value, it can be
made void.

Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
---

Changes in v3:
	1. removed empty comment line
	2. there is -> there are

Changes in v2:
	inverted the order of patches

---
 drivers/net/mii.c   | 6 +-----
 include/linux/mii.h | 2 +-
 2 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/net/mii.c b/drivers/net/mii.c
index 779c3a96dba7..22680f47385d 100644
--- a/drivers/net/mii.c
+++ b/drivers/net/mii.c
@@ -49,10 +49,8 @@ static u32 mii_get_an(struct mii_if_info *mii, u16 addr)
  *
  * The @ecmd parameter is expected to have been cleared before calling
  * mii_ethtool_gset().
- *
- * Returns 0 for success, negative on error.
  */
-int mii_ethtool_gset(struct mii_if_info *mii, struct ethtool_cmd *ecmd)
+void mii_ethtool_gset(struct mii_if_info *mii, struct ethtool_cmd *ecmd)
 {
 	struct net_device *dev = mii->dev;
 	u16 bmcr, bmsr, ctrl1000 = 0, stat1000 = 0;
@@ -131,8 +129,6 @@ int mii_ethtool_gset(struct mii_if_info *mii, struct ethtool_cmd *ecmd)
 	mii->full_duplex = ecmd->duplex;
 
 	/* ignore maxtxpkt, maxrxpkt for now */
-
-	return 0;
 }
 
 /**
diff --git a/include/linux/mii.h b/include/linux/mii.h
index 219b93cad1dd..12ea29e04293 100644
--- a/include/linux/mii.h
+++ b/include/linux/mii.h
@@ -32,7 +32,7 @@ struct mii_if_info {
 
 extern int mii_link_ok (struct mii_if_info *mii);
 extern int mii_nway_restart (struct mii_if_info *mii);
-extern int mii_ethtool_gset(struct mii_if_info *mii, struct ethtool_cmd *ecmd);
+extern void mii_ethtool_gset(struct mii_if_info *mii, struct ethtool_cmd *ecmd);
 extern void mii_ethtool_get_link_ksettings(
 	struct mii_if_info *mii, struct ethtool_link_ksettings *cmd);
 extern int mii_ethtool_sset(struct mii_if_info *mii, struct ethtool_cmd *ecmd);
-- 
2.32.0


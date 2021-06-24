Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7950E3B256F
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 05:27:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229952AbhFXD3e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Jun 2021 23:29:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229759AbhFXD3e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Jun 2021 23:29:34 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA533C061574
        for <netdev@vger.kernel.org>; Wed, 23 Jun 2021 20:27:14 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id h4so3557914pgp.5
        for <netdev@vger.kernel.org>; Wed, 23 Jun 2021 20:27:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=endlessos.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1LLIC3vRiG+w0WjNyQ8lQ5PIeBqu2QLtcug58Mws1YI=;
        b=MP59ehY2gcJqOTHqkBlY4QGel69RQBa5TRyYV5Oju8LE309jcgJ9ep7stD6zT2oWt2
         VkLnJatqjONYjfrfYPxPTN/edsPBa2TAmt3aThfwzvx91IZIWTPYjaVfzeRSnHlQi4lx
         mXek0pKBZW/pd+yfuZKWFj2QRp94owrT9aR+0jK1XoPDw+BivitzFLiGlkh2bonTrrWc
         kB3Xf82f5+jxN4Qvo3iqG4tHR01BywTD2frEg5zE3N1iJQH4Y2FIpAmY+gHqGUf/4jCh
         uzk3k1TN+HGZmJqBdlFdk8PR490cPb3pZ+gFRL2Fr8IO4lZlX+lGs/cL+djUXkhV5yQi
         Z4+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1LLIC3vRiG+w0WjNyQ8lQ5PIeBqu2QLtcug58Mws1YI=;
        b=GEpuJ8zbaZA7+qFzrfcP7lffqupTn4oEDqIUqV2O95ADsEeZnmNCy8w0/PfZ5sEw2k
         konxaN0ik6BvIJMeXIKwshLzDbMNRVXvOF94E54+ApTOp0i+9KGQly6frogZYcflRxnT
         9ltBzKF8EP19ZpeCEh8lPFPKCxrz7HWfxWNU7hFuoL5N2Q2cYan2V96hEEWSCzdEiyZx
         Lkw8DMuPJn1M52Opq/zZtiBgFvT5PUHLNpaZB4IYlsZ/8AgmhGg20OYzZszjsyY5/H9w
         xkvnwIGAqHqvY3W3OdbK909IeZCuIBplEoK5qFnmAcYY+J7iIymhiPr40gKpljuw4bnM
         aXpw==
X-Gm-Message-State: AOAM530DMa+i3sn8LwhIgWbUa5/B9n/OQ0tNjcfaBF/cQ/gQJpJt4Xx6
        iGXz8+xe+qbjQWeHmCyXm+aiCQ==
X-Google-Smtp-Source: ABdhPJzR7qGM5Y1VLJIaoENINagdKpJMRZv5QbppIGWb61G406kqo7f1xAHqQOXkEWNo73QXOEzuRQ==
X-Received: by 2002:a62:6d07:0:b029:2e9:1e3c:ad54 with SMTP id i7-20020a626d070000b02902e91e3cad54mr2923946pfc.46.1624505234340;
        Wed, 23 Jun 2021 20:27:14 -0700 (PDT)
Received: from starnight.local ([150.116.242.79])
        by smtp.googlemail.com with ESMTPSA id n23sm1079428pff.93.2021.06.23.20.27.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Jun 2021 20:27:14 -0700 (PDT)
From:   Jian-Hong Pan <jhp@endlessos.org>
To:     Florian Fainelli <f.fainelli@gmail.com>,
        Stefan Wahren <stefan.wahren@i2se.com>,
        Doug Berger <opendmb@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux@endlessos.org,
        linux-rpi-kernel@lists.infradead.org,
        Jian-Hong Pan <jhp@endlessos.org>
Subject: [PATCH v3] net: bcmgenet: Add mdio-bcm-unimac soft dependency
Date:   Thu, 24 Jun 2021 11:22:41 +0800
Message-Id: <20210624032240.2609-1-jhp@endlessos.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <7f4e15bb-feb5-b4d2-57b9-c2a9b2248d4a@gmail.com>
References: <7f4e15bb-feb5-b4d2-57b9-c2a9b2248d4a@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The Broadcom UniMAC MDIO bus from mdio-bcm-unimac module comes too late.
So, GENET cannot find the ethernet PHY on UniMAC MDIO bus. This leads
GENET fail to attach the PHY as following log:

bcmgenet fd580000.ethernet: GENET 5.0 EPHY: 0x0000
...
could not attach to PHY
bcmgenet fd580000.ethernet eth0: failed to connect to PHY
uart-pl011 fe201000.serial: no DMA platform data
libphy: bcmgenet MII bus: probed
...
unimac-mdio unimac-mdio.-19: Broadcom UniMAC MDIO bus

It is not just coming too late, there is also no way for the module
loader to figure out the dependency between GENET and its MDIO bus
driver unless we provide this MODULE_SOFTDEP hint.

This patch adds the soft dependency to load mdio-bcm-unimac module
before genet module to fix this issue.

Buglink: https://bugzilla.kernel.org/show_bug.cgi?id=213485
Fixes: 9a4e79697009 ("net: bcmgenet: utilize generic Broadcom UniMAC MDIO controller driver")
Signed-off-by: Jian-Hong Pan <jhp@endlessos.org>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
v3: Modified the subject and added some more description in the commit
    message by Florian's suggestion.

v2: Load mdio-bcm-unimac before genet module instead of trying to
    connect the PHY in a loop.

 drivers/net/ethernet/broadcom/genet/bcmgenet.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
index fcca023f22e5..41f7f078cd27 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -4296,3 +4296,4 @@ MODULE_AUTHOR("Broadcom Corporation");
 MODULE_DESCRIPTION("Broadcom GENET Ethernet controller driver");
 MODULE_ALIAS("platform:bcmgenet");
 MODULE_LICENSE("GPL");
+MODULE_SOFTDEP("pre: mdio-bcm-unimac");
-- 
2.32.0


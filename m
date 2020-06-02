Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C01D1EC415
	for <lists+netdev@lfdr.de>; Tue,  2 Jun 2020 22:55:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728377AbgFBUze (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jun 2020 16:55:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728344AbgFBUzc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jun 2020 16:55:32 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1135AC08C5C0
        for <netdev@vger.kernel.org>; Tue,  2 Jun 2020 13:55:31 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id o9so14324317ljj.6
        for <netdev@vger.kernel.org>; Tue, 02 Jun 2020 13:55:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Hm5lfx1+p9LZFBPWiYoySZYVMdJDqNUBSnzCSIT3LW0=;
        b=ciTdLXttCx2ZgfgwevVus/XZs4lybsIgYV3SSLzK6Z/8guZwkbqcwt9u9HQdLaF/9Q
         oOMMiorGT4g0izG3AIgo41UtgKzV/E+qGD/XBheEca3qZJk8y+Q0bwaBUF2KH3ViQrp9
         fDScQ2l7rA2g8RVpP/nGpbHLrhOc2lYXbk7+rOIRf/dA1vO33bu/wT9voMy9AjH2bGbx
         kjt3c/yMnUH4x4OYhaQhZSvjKJvpyf6Nc6EN8vHnV84ztqUouYdGkRIPwqBJyflewq8l
         Nqjq8s1pcEqfkTYrLfuAW/mD2/PFNJBiFZPdu0Th8n0ydIgS/PVflZnxASOrnfOB8WqL
         DUOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Hm5lfx1+p9LZFBPWiYoySZYVMdJDqNUBSnzCSIT3LW0=;
        b=cy6ccpve+BdrhHjO1oFa0zvtG72Gt6c5jt7dNoY3F/LCMW1X59VgdZjxLlSZZw0c4A
         vSNYpmRcEiU9AVJ8jQS3cgkQL3TfWdkANrU52nfu/yXj2uM8H5cEYDiSrWKGieJaG4uG
         qIri6zYTLfVuJpc3HG2mD4KHL1vgH0spCyiRndzS4P55S6mw2zPZxlvZC6AqkkT2HEDh
         ii09SrfjFTLetHFjA687kqDm4UCSY9iDxbkT7MiaNKp6UfSsA96sdaK64n/XEPAD8T3A
         u6cTZw2Ryxw9QBjdYclGQ71vG20NM/4kDhwBlOJd7BMm+qjI4gXi4tWD/d7j8bBAmczK
         7rqw==
X-Gm-Message-State: AOAM532GSIki5YvqqaulbhHCEo+f3h+BBf3ppGE4z3QcOcWpWvw5OiPD
        Y0OH6mUBYOE1z1RyqTLhEETE4w==
X-Google-Smtp-Source: ABdhPJxss376tMIW1Cm//hbmjPgOcSJqlHsP1ZkXZCP2L5G3i82Sor0DB+IWHVedRP7BKXbjEpvNFw==
X-Received: by 2002:a2e:a48d:: with SMTP id h13mr457150lji.120.1591131329540;
        Tue, 02 Jun 2020 13:55:29 -0700 (PDT)
Received: from localhost.bredbandsbolaget (c-8cdb225c.014-348-6c756e10.bbcust.telenor.se. [92.34.219.140])
        by smtp.gmail.com with ESMTPSA id t5sm41962lff.39.2020.06.02.13.55.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Jun 2020 13:55:29 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        DENG Qingfang <dqfext@gmail.com>
Subject: [net-next PATCH 5/5] net: dsa: rtl8366: Use top VLANs for default
Date:   Tue,  2 Jun 2020 22:54:56 +0200
Message-Id: <20200602205456.2392024-5-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200602205456.2392024-1-linus.walleij@linaro.org>
References: <20200602205456.2392024-1-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The RTL8366 DSA switches will not work unless we set
up a default VLAN for each port. We are currently using
e.g. VLAN 1..6 for a 5-port switch as default VLANs.

This is not very helpful for users, move it to allocate
the top VLANs for default instead, for example on
RTL8366RB there are 16 VLANs so instead of using
VLAN 1..6 as default use VLAN 10..15 so VLAN 1
thru VLAN 9 is available for users.

Cc: DENG Qingfang <dqfext@gmail.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/net/dsa/rtl8366.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/rtl8366.c b/drivers/net/dsa/rtl8366.c
index 7f0691a6da13..4e7562b41598 100644
--- a/drivers/net/dsa/rtl8366.c
+++ b/drivers/net/dsa/rtl8366.c
@@ -260,8 +260,8 @@ static int rtl8366_set_default_vlan_and_pvid(struct realtek_smi *smi,
 	u16 vid;
 	int ret;
 
-	/* This is the reserved default VLAN for this port */
-	vid = port + 1;
+	/* Use the top VLANs for per-port default VLAN */
+	vid = smi->num_vlan_mc - smi->num_ports + port;
 
 	if (port == smi->cpu_port)
 		/* For the CPU port, make all ports members of this
-- 
2.26.2


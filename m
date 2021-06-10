Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9119C3A30EC
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 18:41:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231552AbhFJQmy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 12:42:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231447AbhFJQml (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 12:42:41 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FD1DC061760;
        Thu, 10 Jun 2021 09:40:29 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id k7so160340ejv.12;
        Thu, 10 Jun 2021 09:40:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=uTnxI5g7pTP4jGA31eYupvoRHHosLhVQl5fsqQt2kmE=;
        b=K/BnfP2x9atKngYttqB+Vgh7F78oLYUi2dLhhdvn+WIKorMVnrCZ/4AIn0z4hsBSBg
         C8JsL0qfFxpEQCi7ImdqY4ivRaFG9dL67PCUySfiYGsuRRBDZnYsDydtA39XMS5qufJc
         7KGsGJMP1/1rPbxKdK0LDeJa0YrnuLNz70DONMZYo62Wj5D32LA4HltXfTDILMDsevow
         cxTnXQT+YtnvesijhgjyeZhxdJxszi4Ptmt5U8Q7fxZ1EfD3s3K7Cp3C1jJ/YkXh+5ve
         T/koiAk4tce9oS6KdwSZNtYndEHHIa4n63AkRJTjjZaurmqeikGzuJNvjwd0G70QKSkU
         3Jnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uTnxI5g7pTP4jGA31eYupvoRHHosLhVQl5fsqQt2kmE=;
        b=PcnjaLegeB+nOb7GmPgYqhgG9Pnzmy8cc8UXW1A2j0qM0/EIL7uGdxMz0+bRTmlDL9
         vqudTgluJBUWBV05ApOpbf0tS/oY/nVIhjG4lbIB7DFNNVZri46JR+D/nhV3+LaVyN31
         XrRKyyFP1BrzvEiBKTSqX0vOgFXqHyfeJmLGEkE/Nr+JjxxB8aF9zq8uKi+RiK1rna6Z
         V+c6lqOl2iWCWIXqTU6qImH/6XVCB9n1laBd5DC4elHBZoKOyQA/9a4hR7U8/hRIvWM5
         AO/87hedZz98FobD38OiYcV9VYgxEf8z1XwWUVY7+bdHtJnB3bhD1iF1H8EC8Es0XvN7
         8l7A==
X-Gm-Message-State: AOAM533x926Ey/swm2124bRXTKR2ly2mTPLu8kxOUtO74Ob5GvnsgDRE
        x7dL8E0+UakDQJWZ51/C1H4=
X-Google-Smtp-Source: ABdhPJyeSYOloOR8hF4HGXfH8IkYg4P/EpFpKhL/014YAO7Rb5LLYqsJNRpGRx36Jh8sGTjQQmYguw==
X-Received: by 2002:a17:906:7742:: with SMTP id o2mr495849ejn.284.1623343228063;
        Thu, 10 Jun 2021 09:40:28 -0700 (PDT)
Received: from yoga-910.localhost ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id e22sm1657166edv.57.2021.06.10.09.40.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Jun 2021 09:40:27 -0700 (PDT)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
To:     Grant Likely <grant.likely@arm.com>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Jeremy Linton <jeremy.linton@arm.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Pieter Jansen Van Vuuren <pieter.jansenvv@bamboosystems.io>,
        Jon <jon@solid-run.com>, Saravana Kannan <saravanak@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, calvin.johnson@nxp.com
Cc:     Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Florin Laurentiu Chiculita <florinlaurentiu.chiculita@nxp.com>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        linux-arm-kernel@lists.infradead.org,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux.cj@gmail.com, netdev@vger.kernel.org,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Len Brown <lenb@kernel.org>,
        "Rafael J . Wysocki" <rjw@rjwysocki.net>,
        Calvin Johnson <calvin.johnson@oss.nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next v8 06/15] of: mdio: Refactor of_get_phy_id()
Date:   Thu, 10 Jun 2021 19:39:08 +0300
Message-Id: <20210610163917.4138412-7-ciorneiioana@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210610163917.4138412-1-ciorneiioana@gmail.com>
References: <20210610163917.4138412-1-ciorneiioana@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Calvin Johnson <calvin.johnson@oss.nxp.com>

With the introduction of fwnode_get_phy_id(), refactor of_get_phy_id()
to use fwnode equivalent.

Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---

Changes in v8: None
Changes in v7: None
Changes in v6: None
Changes in v5: None
Changes in v4: None
Changes in v3: None
Changes in v2: None

 drivers/net/mdio/of_mdio.c | 12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff --git a/drivers/net/mdio/of_mdio.c b/drivers/net/mdio/of_mdio.c
index 0ba1158796d9..29f121cba314 100644
--- a/drivers/net/mdio/of_mdio.c
+++ b/drivers/net/mdio/of_mdio.c
@@ -29,17 +29,7 @@ MODULE_LICENSE("GPL");
  * ethernet-phy-idAAAA.BBBB */
 static int of_get_phy_id(struct device_node *device, u32 *phy_id)
 {
-	struct property *prop;
-	const char *cp;
-	unsigned int upper, lower;
-
-	of_property_for_each_string(device, "compatible", prop, cp) {
-		if (sscanf(cp, "ethernet-phy-id%4x.%4x", &upper, &lower) == 2) {
-			*phy_id = ((upper & 0xFFFF) << 16) | (lower & 0xFFFF);
-			return 0;
-		}
-	}
-	return -EINVAL;
+	return fwnode_get_phy_id(of_fwnode_handle(device), phy_id);
 }
 
 static struct mii_timestamper *of_find_mii_timestamper(struct device_node *node)
-- 
2.31.1


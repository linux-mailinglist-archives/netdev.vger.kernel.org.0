Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1E39454EED
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 22:05:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240350AbhKQVI0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 16:08:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240391AbhKQVIS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Nov 2021 16:08:18 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6095EC061570;
        Wed, 17 Nov 2021 13:05:19 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id e3so16990288edu.4;
        Wed, 17 Nov 2021 13:05:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Moo6C6ux3Max+74jfwWrTQaUIS07OsmKfAQTULmbues=;
        b=oxNuq3iaqHNFEvebZeULCPIkxAZqRtvK1AkgC3Ma+PPCZEC9JJ1pruVdLcZZDp7YmS
         UH7fD+ZRjIlvohXHSTfDW+VNm5zW26t2LBOFqqzUKTHZvOLJYVjO8/OizFj1nA2khY/z
         uLZNOW5L7iIxCDMpA9mKgRmrC687mImv1R+vzXT55lKWCs8Pd9PepAjPCcTiybhNbZ6E
         1Oka6kkP3LOITU/bMJiA8DosFbaHGn13sYeM9v9fjQRU8fvybaYiskXd5gH4iWSUG2wf
         ysIKsv4cP06LbFQ+JIpdHPFvgo4t+Yc+sM0OY0mf9RJNmgCFMcqTyt2T13me5hMlXVeF
         p8yQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Moo6C6ux3Max+74jfwWrTQaUIS07OsmKfAQTULmbues=;
        b=csZd8dBPn1buGrjsfEhyJMYw+vaQ1ge8s3deZtJGC48wlJtNLpCUIaaNOvLyQ507+a
         QCJ4KKL6151B5bc76RSacAS9Wp4ap2X8kfKKmLc0Rty0HMfquA9Y7KmzDCafME34Jqho
         Tic3yp26dYims+58Xa2ihRb3RrGuzxhIxUhrFZsRs/8BQ0usD/G9x9jbRBJqf5GkmDAW
         mhkooyam1SONjyN/L++l9Vb45QoxDVo0bQeMZogCX9nVMxIQa4imJP/d7vgTSUxWueXD
         QwQ4WRlEwcwUgWrBGLnamVOaOQEs6NjXWRBVNO1pGsiYqakStAh+uxLtD0JTXfthHmDY
         vu1g==
X-Gm-Message-State: AOAM533fUCOzTS+w3LTpSBd7iAlxMgJ8iCDXryfcthGQy3SGvuAZZukJ
        zjFGmRLkS0cvY6wYg09iK+g=
X-Google-Smtp-Source: ABdhPJzkDuTqDHeE4UME6g9rnaR3ooTieU2fHLNozwyxHqcsDBA00FSjg89N8GMr/xEJfAMgY42ayg==
X-Received: by 2002:a17:907:2622:: with SMTP id aq2mr25873180ejc.76.1637183117881;
        Wed, 17 Nov 2021 13:05:17 -0800 (PST)
Received: from localhost.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id di4sm467070ejc.11.2021.11.17.13.05.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Nov 2021 13:05:17 -0800 (PST)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     kernel test robot <lkp@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: [net-next PATCH 02/19] net: dsa: qca8k: remove redundant check in parse_port_config
Date:   Wed, 17 Nov 2021 22:04:34 +0100
Message-Id: <20211117210451.26415-3-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211117210451.26415-1-ansuelsmth@gmail.com>
References: <20211117210451.26415-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The very next check for port 0 and 6 already make sure we don't go out
of bounds with the ports_config delay table.
Remove the redundant check.

Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 drivers/net/dsa/qca8k.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index a429c9750add..bfffc1fb7016 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -983,7 +983,7 @@ qca8k_parse_port_config(struct qca8k_priv *priv)
 	u32 delay;
 
 	/* We have 2 CPU port. Check them */
-	for (port = 0; port < QCA8K_NUM_PORTS && cpu_port_index < QCA8K_NUM_CPU_PORTS; port++) {
+	for (port = 0; port < QCA8K_NUM_PORTS; port++) {
 		/* Skip every other port */
 		if (port != 0 && port != 6)
 			continue;
-- 
2.32.0


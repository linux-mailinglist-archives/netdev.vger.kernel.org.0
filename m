Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E69E373273
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 00:34:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233119AbhEDWbq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 May 2021 18:31:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233174AbhEDWat (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 May 2021 18:30:49 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A26A7C0613ED;
        Tue,  4 May 2021 15:29:52 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id u3so15559165eja.12;
        Tue, 04 May 2021 15:29:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8fOo83xlBs/xozrteM4iypBpLdSQw0aqTY6M9O2PZdU=;
        b=YDmEmrDkE6UrtYBIbvjwf4R1f3DhjnyHs4ohcO2esxnel9zLNowel8ROytTr3rxJWb
         61vey7BKxVGmTTFvuYxyMVEk5Gb1FQ3cDZLo8tTGvnBdZ+zWQkAZlojjAROjIgVPI0vT
         Ggtxb0t6atvgZeQWjyIjN+XEsO47CHlUJKvdOwHRdk3d09kkj/FAQw3SI58vglDmVIb7
         chrhUjvFEEl3sSBgJAkzqNM0t5FtqlBn7ZkbPoag02H9S1hf9mjUJk/H0AlQ3F3dWv8e
         ZkX4E+kGLxYj8ztHHQ+woYxrSfjBR3zbnK8uQg5/bDQ2R1H4erhr7wXxpl1FdC2/cK6k
         lvgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8fOo83xlBs/xozrteM4iypBpLdSQw0aqTY6M9O2PZdU=;
        b=UUWwN9AsBB18QgA7HHrU+tfRYTAW60u+MA9jFoGmzkEcqTQCkGAjZ/YOfk1WF9gfCI
         MjAx3DeSacZEr0TGwTFJ3qAMesVfVgawJH8xHijNk+rq5Au2iWiTAadbmkgZ67EsoYp0
         k4VV/UA/Q1Ldx1dqOi9si06M9ZwKlQja7SjWFyxxfx70ItIPpNdLCHLQCvJGoi/80xib
         LZA3sZ58c/NwqFz762fjmPEocivPUanbYeC5uCMNkTX08BNc49IqbgXvkCBUUPXmsdEy
         KURnXanhhlgmGDOU3/2AfH7CS0f1nU80tZdmYknCa+6Afm/rrBRSGD3dWChDpX4JS8oy
         wlkQ==
X-Gm-Message-State: AOAM530EQzbjBv1hvWyNNtyILjyBaovLlTo1K7PaYxXtEo+Tk02jTAlZ
        PORdSLnfb2oSx1Mpm1ktuMFafze0MnzOeA==
X-Google-Smtp-Source: ABdhPJxZd1Lb9xfT+A5tzyOts1+SARa7+y3LcANA4s54mtGew4u/NpZn8i2YLU9KCkHXf9wUOpelIw==
X-Received: by 2002:a17:906:314f:: with SMTP id e15mr24509929eje.30.1620167391316;
        Tue, 04 May 2021 15:29:51 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-35-189-2.ip56.fastwebnet.it. [93.35.189.2])
        by smtp.googlemail.com with ESMTPSA id q12sm2052946ejy.91.2021.05.04.15.29.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 May 2021 15:29:50 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Ansuel Smith <ansuelsmth@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH net-next v3 16/20] net: dsa: qca8k: enlarge mdio delay and timeout
Date:   Wed,  5 May 2021 00:29:10 +0200
Message-Id: <20210504222915.17206-16-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210504222915.17206-1-ansuelsmth@gmail.com>
References: <20210504222915.17206-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

- Enlarge set page delay to QDSK source
- Enlarge mdio MASTER timeout busy wait

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 drivers/net/dsa/qca8k.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index 27234dd4c74a..b4cd891ad35d 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -140,6 +140,7 @@ qca8k_set_page(struct mii_bus *bus, u16 page)
 	}
 
 	qca8k_current_page = page;
+	usleep_range(1000, 2000);
 	return 0;
 }
 
@@ -641,7 +642,7 @@ qca8k_mdio_busy_wait(struct qca8k_priv *priv, u32 reg, u32 mask)
 
 	qca8k_split_addr(reg, &r1, &r2, &page);
 
-	timeout = jiffies + msecs_to_jiffies(20);
+	timeout = jiffies + msecs_to_jiffies(2000);
 
 	/* loop until the busy flag has cleared */
 	do {
-- 
2.30.2


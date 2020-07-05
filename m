Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4026215054
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 01:16:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728236AbgGEXQJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jul 2020 19:16:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728220AbgGEXQG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Jul 2020 19:16:06 -0400
Received: from mail-lf1-x143.google.com (mail-lf1-x143.google.com [IPv6:2a00:1450:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45FD2C061794
        for <netdev@vger.kernel.org>; Sun,  5 Jul 2020 16:16:06 -0700 (PDT)
Received: by mail-lf1-x143.google.com with SMTP id k15so21554333lfc.4
        for <netdev@vger.kernel.org>; Sun, 05 Jul 2020 16:16:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bEnvRIle9ouYWtzoth+BrQzE2gQE9/8+m5/d/sfeHBA=;
        b=TzjSZww2QTqv2PaavxaJsKSzwDtKnRMVtuXVlJyqgWjSVW8lj5c7cXA3mv8CEEMMw8
         4dSo/ymC41Sdhx98vBWE1PI/SuwHkC+zeU5dpfJ3Nc9Rpa4IQS35zzClCv5iNw/kkv76
         Ji6lSzGhLSf1t+LLTEsgKBiZDbVLhklV7bdR5STby9/XQ1qYtApqGJnJ58NF58/KSRFN
         NYTtDs/Tah11mOxkewCAPgpxmAwvgcL6X+nC942zDyCnEdlW1BjeoZlh2m8x5yLZsKO1
         RXUd/g2aUfQXL/KtUotM5bF9U4lUhebl/RV/54VZO7OXRKCaDhT/yDUB12xhZEc7nKM3
         Pkhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bEnvRIle9ouYWtzoth+BrQzE2gQE9/8+m5/d/sfeHBA=;
        b=dglD+tcWqdFUK9+QcyCVbWVffK12TeXfGl+d6DZwJffkViuOiiwR2s6rCGoTZaSIj5
         wVAeAcQtpr6tucoao5padhxolUlWVRI1qYrqJ9zUkjqq46BKm0Zz+I4gNfsPI0fM9Ifx
         cOaEr1aLVYvF90a18zAVqA4iWLL8xkbtq7s35zG/vtL6SD5i7oX+clgjvJOHtBY4D+PC
         CSe18COqHxY0R5lczr3O2Hs8fO1f2Fb68GIUYsxzCSzwlY9wAZZbcJ/f71fD01wiitPB
         S6Xy+PiqhF190299m8EYmbJLb+a+KyVbwCFivw4Ez/JV14wKLw0+DZa8DI0mvEFBLh+p
         vWTQ==
X-Gm-Message-State: AOAM531NQ0SJrLLzRc7Vs5bMbXJ41Zg16lhIlAoP0cK53pAy79E4ZE4T
        Le0lInbEq1XYiTviSvu3FV4Hqw==
X-Google-Smtp-Source: ABdhPJzFrp/SZOv4AY6O9feQI7mMSbcurCHiQet113X3BsONFha6XqhGXKu3lWhN/N/6mnD0Dr4+JA==
X-Received: by 2002:ac2:5a5e:: with SMTP id r30mr28480711lfn.30.1593990964759;
        Sun, 05 Jul 2020 16:16:04 -0700 (PDT)
Received: from localhost.bredbandsbolaget (c-92d7225c.014-348-6c756e10.bbcust.telenor.se. [92.34.215.146])
        by smtp.gmail.com with ESMTPSA id f14sm8439410lfa.35.2020.07.05.16.16.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Jul 2020 16:16:04 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        DENG Qingfang <dqfext@gmail.com>,
        Mauri Sandberg <sandberg@mailfence.com>
Subject: [net-next PATCH 5/5 v3] net: dsa: rtl8366: Use top VLANs for default
Date:   Mon,  6 Jul 2020 01:15:50 +0200
Message-Id: <20200705231550.77946-6-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200705231550.77946-1-linus.walleij@linaro.org>
References: <20200705231550.77946-1-linus.walleij@linaro.org>
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
Cc: Mauri Sandberg <sandberg@mailfence.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
ChangeLog v2->v3:
- Collect Andrew's reviewed-by.
ChangeLog v1->v2:
- Rebase on v5.8-rc1.
---
 drivers/net/dsa/rtl8366.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/rtl8366.c b/drivers/net/dsa/rtl8366.c
index a000d458d121..06adcf68ff8d 100644
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


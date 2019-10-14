Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 77B43D68B2
	for <lists+netdev@lfdr.de>; Mon, 14 Oct 2019 19:40:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388661AbfJNRkd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Oct 2019 13:40:33 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:46202 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388646AbfJNRkc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Oct 2019 13:40:32 -0400
Received: by mail-pg1-f195.google.com with SMTP id e15so2489919pgu.13;
        Mon, 14 Oct 2019 10:40:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3raRjkh411jqmJuSd7tR/NOj57+SAWqZk6Zr5JKxLGc=;
        b=M9lDjrMJjbBDodTzmoFm5niWXhLC4ZLf1L2eBPYPVBZfQMDdupuwl7Kv3Tdxid15Kh
         P0vSblrBDXOET3c1Sv5Gzk5USK6ITosJaFXMY7Nt/bpQs+63Y1p5SHyMpvfikGTEHFO/
         wCN1liPBoaSVwFT33Oa52zjCYDkUERbsj1XAmRUcW0PKo5+xjpzA1uFG0fBSl9oC77lV
         CSO9MkD69ZghjRHZzl8UnJNLjLWc76tgJoeiHOZ3SKzf5jVJgRcjrZiagUq5taHHgmSr
         e8oZG9eaz7zcseCnbTvllZHwdZlo2jXQNG+1zJ+LJa3XgBy9zyOl2LviMpSksuSgc4GL
         p9EA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3raRjkh411jqmJuSd7tR/NOj57+SAWqZk6Zr5JKxLGc=;
        b=Q/Gsy89tqJFPoGTsR8FJVMTsBYSA2efnSshYOc+u/hUX6RUoWLp0uH5rSbVaZa70lh
         /NzS9prZKkKS5RzojouVcfk93GdGKk/i/m4vXqUL+Ga2vVWEn53kQ0ntLJRt512jlX+j
         LDB9OU2TVkztPZj3QW04OD+OF8LAiJ4OfHkDMDYErcNI2ylXlREgvCvHw6Ijkzde1BP6
         2oGtgb64vT8qgSGQj1ueqEhDofInxDdYr+shNaXHODgJZvrxXOlTNreH3sAQkuK9Vd46
         bFc5UqbBsqRgtrF/+0OAXM0293Jba6yDZMHVFdqs047defoYLr+5jralq+7GbBEIXM0r
         +Uvg==
X-Gm-Message-State: APjAAAXW/VF3gWhoPnrL5pFW20YtnrCIOND/v2CVPt3x+Obqs6FxWq9v
        Tbj/V6WZW+2ylwKd5sUY7VY=
X-Google-Smtp-Source: APXvYqyt6H4tar6sW6SeNzx59TyuW49NybHYbW3BHLGUt3TOtKmZZ0JCqYd1VaFEjjncfgVVopMMoA==
X-Received: by 2002:a17:90a:b003:: with SMTP id x3mr37943388pjq.101.1571074830826;
        Mon, 14 Oct 2019 10:40:30 -0700 (PDT)
Received: from dtor-ws.mtv.corp.google.com ([2620:15c:202:201:3adc:b08c:7acc:b325])
        by smtp.gmail.com with ESMTPSA id k66sm18784535pjb.11.2019.10.14.10.40.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Oct 2019 10:40:30 -0700 (PDT)
From:   Dmitry Torokhov <dmitry.torokhov@gmail.com>
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH v2 3/3] net: phy: fixed_phy: switch to using fwnode_gpiod_get_index
Date:   Mon, 14 Oct 2019 10:40:22 -0700
Message-Id: <20191014174022.94605-4-dmitry.torokhov@gmail.com>
X-Mailer: git-send-email 2.23.0.700.g56cf767bdb-goog
In-Reply-To: <20191014174022.94605-1-dmitry.torokhov@gmail.com>
References: <20191014174022.94605-1-dmitry.torokhov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

gpiod_get_from_of_node() is being retired in favor of
[devm_]fwnode_gpiod_get_index(), that behaves similar to
[devm_]gpiod_get_index(), but can work with arbitrary firmware node. It
will also be able to support secondary software nodes.

Let's switch this driver over.

Acked-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>

---

 drivers/net/phy/fixed_phy.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/fixed_phy.c b/drivers/net/phy/fixed_phy.c
index 4190f9ed5313..73a72ff0fb16 100644
--- a/drivers/net/phy/fixed_phy.c
+++ b/drivers/net/phy/fixed_phy.c
@@ -210,8 +210,8 @@ static struct gpio_desc *fixed_phy_get_gpiod(struct device_node *np)
 	 * Linux device associated with it, we simply have obtain
 	 * the GPIO descriptor from the device tree like this.
 	 */
-	gpiod = gpiod_get_from_of_node(fixed_link_node, "link-gpios", 0,
-				       GPIOD_IN, "mdio");
+	gpiod = fwnode_gpiod_get_index(of_fwnode_handle(fixed_link_node),
+				       "link-gpios", 0, GPIOD_IN, "mdio");
 	if (IS_ERR(gpiod) && PTR_ERR(gpiod) != -EPROBE_DEFER) {
 		if (PTR_ERR(gpiod) != -ENOENT)
 			pr_err("error getting GPIO for fixed link %pOF, proceed without\n",
-- 
2.23.0.700.g56cf767bdb-goog


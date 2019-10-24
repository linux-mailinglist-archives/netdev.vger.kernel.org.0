Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D799FE3C46
	for <lists+netdev@lfdr.de>; Thu, 24 Oct 2019 21:45:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437143AbfJXTpY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Oct 2019 15:45:24 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:50414 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2407614AbfJXTpW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Oct 2019 15:45:22 -0400
Received: by mail-wm1-f67.google.com with SMTP id 11so645542wmk.0
        for <netdev@vger.kernel.org>; Thu, 24 Oct 2019 12:45:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=pbifXKbD0yyD/d0RIU0adLTCmC38ngsMfA9+T5hK8Zg=;
        b=rm974sSD9VsxBD7n3LRs7Y1smQv+IJzY2DZ9gCHgWVbAVGhsMR8tWzz4Cl9NSp1iZ7
         jJTZ024S5gMYLCBCgNBiyRx+6nFYn7r/pGsfEhUDx7hsgY4a+ebopL8Ylt9o7GBD8gbm
         YJMNtlpTUGLBqq35PQVWNAyP8rpXUaMgFgL9kgYLugdXG0FVfHtL/XCP4P37dO6i2/PZ
         zywsLqovVGvkTmHBb4k3lc5B0q6uVusmIOWU8JeF0uh9u6VcjONI1KMlX6MxiKJd9TXX
         W7sH/apZpO4NUL1viYKIT7V596rmrAEoohP/DkyvGSrULCLvecXecdd1gix9CxKH0KVd
         2PJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=pbifXKbD0yyD/d0RIU0adLTCmC38ngsMfA9+T5hK8Zg=;
        b=l9RJuATtsxzY2wvoC8PLoY9tI1XulAw70pw5AC6BRM7fyfg+cOx6kBEIEacuJxgSg5
         /F+tMNSI3oBWU+fmriGIeE02VmQ2gqtzxDK5sIvqi7uGpXTZwmbmpnjklDM9ep8XEllu
         g7DKXcYwhRKebhQhNG7niTzKiTufk0jDXU+pOEYsRK/SSOWGvERzHsR9SWBY0SxUC8PL
         YgcMbbcxIoPb5ofNeWMY6hYQpSrcusZ4ZB30xbiuAdnDlN+TMrZjSqCu33jWy0yAhoT2
         3tbcAIHDxQnlegD7PD/WmPkbGYes8VQ4MYqNTwXT33MfMH4rA6SG7Gy812vCr3V+OswJ
         HXWA==
X-Gm-Message-State: APjAAAWO1fCW+DKu+4ibwETNv1IL1LX0+VKrYiL/vYTQJJI7887Ay/lW
        tU9kqNUmou9sHAu8aOEC34vC70Fg
X-Google-Smtp-Source: APXvYqzbh7zyN2qRUMNDN7AONNYHh8vLntf0eywc8g4nSfHAyBuAR2CkTlkov1eg5On5d38hyA+1NA==
X-Received: by 2002:a1c:a90f:: with SMTP id s15mr61845wme.100.1571946319666;
        Thu, 24 Oct 2019 12:45:19 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 37sm39273250wrc.96.2019.10.24.12.45.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2019 12:45:19 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>, andrew@lunn.ch,
        vivien.didelot@gmail.com, davem@davemloft.net,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: [PATCH net-next 2/2] net: dsa: bcm_sf2: Wire up MDB operations
Date:   Thu, 24 Oct 2019 12:45:08 -0700
Message-Id: <20191024194508.32603-3-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191024194508.32603-1-f.fainelli@gmail.com>
References: <20191024194508.32603-1-f.fainelli@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Leverage the recently add b53_mdb_{add,del,prepare} functions since they
work as-is for bcm_sf2.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/dsa/bcm_sf2.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/dsa/bcm_sf2.c b/drivers/net/dsa/bcm_sf2.c
index c068a3b7207b..a4a46f8df352 100644
--- a/drivers/net/dsa/bcm_sf2.c
+++ b/drivers/net/dsa/bcm_sf2.c
@@ -968,6 +968,9 @@ static const struct dsa_switch_ops bcm_sf2_ops = {
 	.set_rxnfc		= bcm_sf2_set_rxnfc,
 	.port_mirror_add	= b53_mirror_add,
 	.port_mirror_del	= b53_mirror_del,
+	.port_mdb_prepare	= b53_mdb_prepare,
+	.port_mdb_add		= b53_mdb_add,
+	.port_mdb_del		= b53_mdb_del,
 };
 
 struct bcm_sf2_of_data {
-- 
2.17.1


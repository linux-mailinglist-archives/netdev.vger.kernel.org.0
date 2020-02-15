Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB57F15FB79
	for <lists+netdev@lfdr.de>; Sat, 15 Feb 2020 01:32:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727691AbgBOAce (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 19:32:34 -0500
Received: from mail-pl1-f176.google.com ([209.85.214.176]:46846 "EHLO
        mail-pl1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727529AbgBOAce (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Feb 2020 19:32:34 -0500
Received: by mail-pl1-f176.google.com with SMTP id y8so4308241pll.13;
        Fri, 14 Feb 2020 16:32:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=gjic0RXEfrgy7QbCi6Q0Q7dhAgvAaIHlh+rIMSyFpZE=;
        b=qyrC+9400c0WVFWtbhDvFVpEmlOkA7XXHFMMqFG93m2if7P86f5TAD/evJQBjAuFx1
         GcrqI0pgw3OXgsmF2a+nKBJaxwFATBI5BAXuGkn32LMkcd2PcwlxTv6EaEIM4SiSKQ9i
         HcqbFbdbULumwTR4iCdbZucSJ8GAqdwgN3JgyBA7OhKb4hwayPoM/m8KGd53loKGk/an
         J2ul6FzSatcJECfNTvi2BOqvYf/8ZHpDKROIE4q/p4Jj++qSz57oZ+A2bebB9cvRTV43
         5YRDRm/iZEafus96x5oliNv20UDK2KbJ36k401o0R1WImwbsWYWykmTAuz9vmnhxBiXt
         s4fQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=gjic0RXEfrgy7QbCi6Q0Q7dhAgvAaIHlh+rIMSyFpZE=;
        b=dotSXTAzL/z845HhJlw/dMjT5DZfHwCJKGo4WEZBuMAn85vLPi83N0XENu7ks53ehU
         YAlv6IFXpvzIpwKnAgQpgxrKvbUo+eiY4qGg9vEZmWxloxezNbzlxIpT33/ihXDt/uJj
         mcPLFwJM5vOuV+wO2YXK+Hasv35OdDGUCRZ3S6/stjv+DA9Q9sFFRh+Bd2Uab01FRlOH
         dnT4Z9MYKcIq49ZcFbE4nmN7R0m2CDg44M1kDcOPBlRSj582WjGgqAjw0+7xeonwin34
         sWMK4MNZ9War8WNXKNdSAa9WBy7mx8y5vG9pGAH7snVjxf52Nz+j3hAH5Y6PMM8kkFJ8
         bbLQ==
X-Gm-Message-State: APjAAAUnFJ3LnZQAqtYvS3aYDfPm8CXgE3h+YnFYcy/HiWDSp7o6VK/J
        ILnhTOdl0SVLLPFe8Fr4uSRkMMNn
X-Google-Smtp-Source: APXvYqx/tNo0wVmaj9SiEm72H8hoxYD+DFdYzKicSjwNCWV/yThe4AOzJFCu2qM29jDMpUebt0b7nQ==
X-Received: by 2002:a17:90a:d103:: with SMTP id l3mr6943730pju.116.1581726752408;
        Fri, 14 Feb 2020 16:32:32 -0800 (PST)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id b21sm8622622pfp.0.2020.02.14.16.32.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Feb 2020 16:32:31 -0800 (PST)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net-next] net: dsa: bcm_sf2: Also configure Port 5 for 2Gb/sec on 7278
Date:   Fri, 14 Feb 2020 16:32:29 -0800
Message-Id: <20200215003230.27181-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Either port 5 or port 8 can be used on a 7278 device, make sure that
port 5 also gets configured properly for 2Gb/sec in that case.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/dsa/bcm_sf2.c      | 3 +++
 drivers/net/dsa/bcm_sf2_regs.h | 1 +
 2 files changed, 4 insertions(+)

diff --git a/drivers/net/dsa/bcm_sf2.c b/drivers/net/dsa/bcm_sf2.c
index d1955543acd1..6feaf8cb0809 100644
--- a/drivers/net/dsa/bcm_sf2.c
+++ b/drivers/net/dsa/bcm_sf2.c
@@ -616,6 +616,9 @@ static void bcm_sf2_sw_mac_config(struct dsa_switch *ds, int port,
 	if (state->duplex == DUPLEX_FULL)
 		reg |= DUPLX_MODE;
 
+	if (priv->type == BCM7278_DEVICE_ID && dsa_is_cpu_port(ds, port))
+		reg |= GMIIP_SPEED_UP_2G;
+
 	core_writel(priv, reg, offset);
 }
 
diff --git a/drivers/net/dsa/bcm_sf2_regs.h b/drivers/net/dsa/bcm_sf2_regs.h
index d8a5e6269c0e..784478176335 100644
--- a/drivers/net/dsa/bcm_sf2_regs.h
+++ b/drivers/net/dsa/bcm_sf2_regs.h
@@ -178,6 +178,7 @@ enum bcm_sf2_reg_offs {
 #define  RXFLOW_CNTL			(1 << 4)
 #define  TXFLOW_CNTL			(1 << 5)
 #define  SW_OVERRIDE			(1 << 6)
+#define  GMIIP_SPEED_UP_2G		(1 << 7)
 
 #define CORE_WATCHDOG_CTRL		0x001e4
 #define  SOFTWARE_RESET			(1 << 7)
-- 
2.17.1


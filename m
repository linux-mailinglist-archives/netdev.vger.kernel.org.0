Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B90C116B5F5
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 00:45:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728359AbgBXXpP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 18:45:15 -0500
Received: from mail-wm1-f42.google.com ([209.85.128.42]:54336 "EHLO
        mail-wm1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727081AbgBXXpP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 18:45:15 -0500
Received: by mail-wm1-f42.google.com with SMTP id z12so1115882wmi.4;
        Mon, 24 Feb 2020 15:45:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=XQ6eIa2wiDB1DP4Ns8nniAL5OvDLQpxBQOfpTu4sj3A=;
        b=skRHFhdEj7ZwR3Bv/P8yPBSVbJndUUgSZPSs2Vj4J+OmjjnYK8dF+Iw8RenCChTbRW
         OetwNpiW8PiNNUfo/iEDK25Jlhahfq98KX6a68O7jV+bTGCQ6Lz1Ts8KrdBiusjcEzpN
         vyckGR2BPAr3VuJpDj4Nix6nHOFVpgqpelNhpCkOIsYpTqnXcMe2jAvnbzOISHf6yMQ+
         w+D6VXshzyPtmT50f5fgWsxJI9aIJaReqsKEDwuvmSLbHdqXv3asv1jIlxV8O3PTN6EM
         uiwILQ38VME3oKxbXdhieG/JT1xBViCuYsvyOJvc9lRLauOCcuo4Xvubc/PKlEOIKwDA
         Pnyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=XQ6eIa2wiDB1DP4Ns8nniAL5OvDLQpxBQOfpTu4sj3A=;
        b=Y1c2/YZ2Kr80qqZhu3VsJ7yB+Xo1Lv7IoAtNy7joNcn0e8BWpSm40FYvjTmWhFS0Zb
         AWyozIBwOcisJqKMzckPHqtjLXSzJfJpefA1ShYikCI86LZxeOjkFZYhrR6urSYX8ihI
         pnChbGcrFU7B4VHmOEJQ3W+yr5YPYnIh62YyF2mpvJkB9fiPaAsZIs8fGZU4eRtp6JeA
         A82WMy/pBamLo82PPBWmPECmmueCT2cS//fgyMlDc6i6ye5BgZEnnhg9gaL6tSt/ZARQ
         zbijzt1SGZ2nnI6fyGSDNc9RfB/MDritDRYpvCySVwnHIgUNj6cAYTqEZs7K7jmhd7xV
         6yfA==
X-Gm-Message-State: APjAAAVuDYRpwsnZa0EhKD/Rq2s4RlR5WS2qIlx1s2R3nDpx+veDi786
        WABdL/hhufSqxWKGwrnNFgQzMT+C
X-Google-Smtp-Source: APXvYqyrpySeKDATHMSflKxO0Op6nmlp1zXoB5YcDWGtn+DjBJNY1E3sFZxpaoZSClA+Kx8RadcDdw==
X-Received: by 2002:a05:600c:21c4:: with SMTP id x4mr1395211wmj.147.1582587912353;
        Mon, 24 Feb 2020 15:45:12 -0800 (PST)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id l2sm1475946wme.1.2020.02.24.15.45.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Feb 2020 15:45:11 -0800 (PST)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net-next] Revert "net: dsa: bcm_sf2: Also configure Port 5 for 2Gb/sec on 7278"
Date:   Mon, 24 Feb 2020 15:44:26 -0800
Message-Id: <20200224234427.12736-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This reverts commit 7458bd540fa0a90220b9e8c349d910d9dde9caf8 ("net: dsa:
bcm_sf2: Also configure Port 5 for 2Gb/sec on 7278") as it causes
advanced congestion buffering issues with 7278 switch devices when using
their internal Giabit PHY. While this is being debugged, continue with
conservative defaults that work and do not cause packet loss.

Fixes: 7458bd540fa0 ("net: dsa: bcm_sf2: Also configure Port 5 for 2Gb/sec on 7278")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/dsa/bcm_sf2.c      | 3 ---
 drivers/net/dsa/bcm_sf2_regs.h | 1 -
 2 files changed, 4 deletions(-)

diff --git a/drivers/net/dsa/bcm_sf2.c b/drivers/net/dsa/bcm_sf2.c
index 6feaf8cb0809..d1955543acd1 100644
--- a/drivers/net/dsa/bcm_sf2.c
+++ b/drivers/net/dsa/bcm_sf2.c
@@ -616,9 +616,6 @@ static void bcm_sf2_sw_mac_config(struct dsa_switch *ds, int port,
 	if (state->duplex == DUPLEX_FULL)
 		reg |= DUPLX_MODE;
 
-	if (priv->type == BCM7278_DEVICE_ID && dsa_is_cpu_port(ds, port))
-		reg |= GMIIP_SPEED_UP_2G;
-
 	core_writel(priv, reg, offset);
 }
 
diff --git a/drivers/net/dsa/bcm_sf2_regs.h b/drivers/net/dsa/bcm_sf2_regs.h
index 784478176335..d8a5e6269c0e 100644
--- a/drivers/net/dsa/bcm_sf2_regs.h
+++ b/drivers/net/dsa/bcm_sf2_regs.h
@@ -178,7 +178,6 @@ enum bcm_sf2_reg_offs {
 #define  RXFLOW_CNTL			(1 << 4)
 #define  TXFLOW_CNTL			(1 << 5)
 #define  SW_OVERRIDE			(1 << 6)
-#define  GMIIP_SPEED_UP_2G		(1 << 7)
 
 #define CORE_WATCHDOG_CTRL		0x001e4
 #define  SOFTWARE_RESET			(1 << 7)
-- 
2.17.1


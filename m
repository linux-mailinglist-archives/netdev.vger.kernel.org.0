Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E10D2289F7
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 22:34:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730592AbgGUUeT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 16:34:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730434AbgGUUeS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jul 2020 16:34:18 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03824C061794
        for <netdev@vger.kernel.org>; Tue, 21 Jul 2020 13:34:18 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id a9so2112005pjd.3
        for <netdev@vger.kernel.org>; Tue, 21 Jul 2020 13:34:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=uCXEufMUDu8XZSJLfGXZ0f5ud7b9oLseRzNAct0iNYs=;
        b=liGVRFCA5A4Jp4wV5dNp+mql+GEHMSWAJkl25ZG2cKZuOSCELXQrIoBYizKTlVEYK+
         T/pZ/u/8MYdnXNEGuCnai8zm5CHQdDPtuOBlalCPYO3v9xa9dqED1AYmyoWjzaz6a1s3
         KRy2vLQ+5IUIbs/wuLEpd422Qz39Rqd0p9R49XQfAhNJEuj67U7a7PzagZRybw0mbjRC
         xMeyEjG08/USjYkJp5jTCM7YRxQ6ABmVeay5mE+qIi3K14v0EDQ7fUzy7v+9W9Gnb7E6
         jmGGtK5q+h0lQ5hL6E2xXbjUNUU1tnP02Idxncrq7HdohjoFJtt8Mn3IRr+bcvQ+KqrS
         eOQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=uCXEufMUDu8XZSJLfGXZ0f5ud7b9oLseRzNAct0iNYs=;
        b=rPTMW3d1gNKyTJHTp2hd27g6ep6n6lvoH8KvD2CuD2ZqgwCSs8guV2e5Fnt/W7B0nW
         +qg6fRYzslS13gmhUAA4soV5fsCEPfCaCACDhKqoUu7XM5cM3+6uJaXIdaFRvsWSVzH3
         WQK1i5TIQUbJgF0NKZuEWirZbHgQ5FHiel33a7ZEOwQHebLVV0kzxQbywFHKIzXNegdu
         bx7nwz25A7qOQ9X6XHLxkxlbWlGz4jFOO3bZQsp0/cemdeib4KX3Zz8yUcULfC/hI0S9
         /reT4nh6XyhZjyPTRBLfKw0gvsxB53805+bo4Bf6aEdS/iAhxb/DQ//wk+Xa4MEpdVsJ
         BYXg==
X-Gm-Message-State: AOAM531f5QlE7YcpgkE15vF2c+nKt9SO52WeIvRP0MyLrQP49rKtjBfD
        Bn0lahM2a+U+BTFXykUUavdhaHhcn2Q=
X-Google-Smtp-Source: ABdhPJwc3yJAuusQj3gxl2p/Yboyr1JJt8Pvp8+2elgBGDYwyVMEE/SQOWJzPt/86+XxbvmsLJ2RVw==
X-Received: by 2002:a17:90a:2d7:: with SMTP id d23mr6658480pjd.57.1595363657303;
        Tue, 21 Jul 2020 13:34:17 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id p11sm4075107pjb.3.2020.07.21.13.34.16
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 21 Jul 2020 13:34:16 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net-next 2/6] ionic: set netdev default name
Date:   Tue, 21 Jul 2020 13:34:05 -0700
Message-Id: <20200721203409.3432-3-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200721203409.3432-1-snelson@pensando.io>
References: <20200721203409.3432-1-snelson@pensando.io>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If the host system's udev fails to set a new name for the
network port, there is no NETDEV_CHANGENAME event to trigger
the driver to send the name down to the firmware.  It is safe
to set the lif name multiple times, so we add a call early on
to set the default netdev name to be sure the FW has something
to use in its internal debug logging.  Then when udev gets
around to changing it we can update it to the actual name the
system will be using.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 drivers/net/ethernet/pensando/ionic/ionic_lif.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index cfcef41b7b23..bbfa25cd3294 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -2631,6 +2631,7 @@ int ionic_lifs_register(struct ionic *ionic)
 		return err;
 	}
 	ionic->master_lif->registered = true;
+	ionic_lif_set_netdev_info(ionic->master_lif);
 
 	return 0;
 }
-- 
2.17.1


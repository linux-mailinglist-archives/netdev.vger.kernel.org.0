Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11BD73D0A8B
	for <lists+netdev@lfdr.de>; Wed, 21 Jul 2021 10:32:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236002AbhGUHlN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Jul 2021 03:41:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236349AbhGUHfH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Jul 2021 03:35:07 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F073DC0613DB;
        Wed, 21 Jul 2021 01:15:38 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id v14so578270plg.9;
        Wed, 21 Jul 2021 01:15:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Wxcy7B70uHdtCZtzYHY9+tkRqLtyDIYNmVQhqkQuKMQ=;
        b=b7snUcK34wADOU+Vlxm8K2nbAVUjfcaAl9DEWsm8rB2SheW7gWN4xag9ASUuZea1bP
         AGlvO3cr8OkBYiW+7y2URPAsCqeDfJzEFc3DE9FA/rj/2szlNCpsB8MCbGILBAsVjMpb
         vdspvmYzPg2AEYC4UzWJkajJBlX1XYSk29MIDi6DOb9nhyJWH0407cA7kO8NWkeO33li
         gC8qWjtcwfDqN1GshUPixMbwFGVsrpu2187uAV/YvuKslsgZ3rEmpDOgtLY1MqQgA7wi
         Tx825rpS8IbwGJR0nM3CRZYiL9uRQReQQvl/cb/K/Qr6QXaEFWataTxGlLZ3dsAef0id
         RGGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Wxcy7B70uHdtCZtzYHY9+tkRqLtyDIYNmVQhqkQuKMQ=;
        b=QVoQq0jjbIWPDVT71PAXQHbuy1qZl6h5UnqrMQJ668d+bHzGDNwPjoMoJmTF19W6Jf
         g8It4drDoW0QeaZkIqKlMNLkb5nMa2Pv8+BucgLDifwGAZenC0EvmHWC5eWkuAh9xj8t
         Hdpm3ixuB0SEfDM2ar6J3JTS9ZBqf8BKmEtfwk41hm9eA/xT3eSB/G+IofqG2C68Yz8o
         tYiW/7hrj7XHau01XVx3uw9dP9bMpvw/3pkndnYGAP91r/ewYMkDdJeuTBEb0ZXUCkVL
         iTiKAG2tVGVOiSl7wYEIvC1QNs/i57qUU9xzi6XOAhpQBNkfLgd4PUi5uUHxouWlxLXM
         ++WQ==
X-Gm-Message-State: AOAM5305dnrVocGKKiMErl6P5JHpm5RnggY92RXDNGALOyRAFvLVjsf/
        RK6/345Uvs/ayrg/gKZ0z8U=
X-Google-Smtp-Source: ABdhPJzq7o1yw/VLBQioWQfOJEjRLY8VoXnIzSelcqkVgT5OS8VTM2PyWoMOcDTZPcSwIRa3dUs3ng==
X-Received: by 2002:a17:90a:86:: with SMTP id a6mr2583154pja.133.1626855338469;
        Wed, 21 Jul 2021 01:15:38 -0700 (PDT)
Received: from localhost.localdomain ([154.16.166.166])
        by smtp.gmail.com with ESMTPSA id g1sm28391398pgs.23.2021.07.21.01.15.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Jul 2021 01:15:38 -0700 (PDT)
From:   Dongliang Mu <mudongliangabcd@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Johan Hovold <johan@kernel.org>,
        Oliver Neukum <oneukum@suse.com>,
        David Sterba <dsterba@suse.com>,
        Jiri Slaby <jirislaby@kernel.org>,
        Dongliang Mu <mudongliangabcd@gmail.com>,
        Rustam Kovhaev <rkovhaev@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Anirudh Rayabharam <mail@anirudhrb.com>
Cc:     linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RESEND PATCH V3 2/2] usb: hso: remove the bailout parameter
Date:   Wed, 21 Jul 2021 16:14:57 +0800
Message-Id: <20210721081510.1516058-2-mudongliangabcd@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210721081510.1516058-1-mudongliangabcd@gmail.com>
References: <20210721081510.1516058-1-mudongliangabcd@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are two invocation sites of hso_free_net_device. After
refactoring hso_create_net_device, this parameter is useless.
Remove the bailout in the hso_free_net_device and change the invocation
sites of this function.

Signed-off-by: Dongliang Mu <mudongliangabcd@gmail.com>
---
 drivers/net/usb/hso.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/usb/hso.c b/drivers/net/usb/hso.c
index dec96e8ab567..827d574f764a 100644
--- a/drivers/net/usb/hso.c
+++ b/drivers/net/usb/hso.c
@@ -2353,7 +2353,7 @@ static int remove_net_device(struct hso_device *hso_dev)
 }
 
 /* Frees our network device */
-static void hso_free_net_device(struct hso_device *hso_dev, bool bailout)
+static void hso_free_net_device(struct hso_device *hso_dev)
 {
 	int i;
 	struct hso_net *hso_net = dev2net(hso_dev);
@@ -2376,7 +2376,7 @@ static void hso_free_net_device(struct hso_device *hso_dev, bool bailout)
 	kfree(hso_net->mux_bulk_tx_buf);
 	hso_net->mux_bulk_tx_buf = NULL;
 
-	if (hso_net->net && !bailout)
+	if (hso_net->net)
 		free_netdev(hso_net->net);
 
 	kfree(hso_dev);
@@ -3133,7 +3133,7 @@ static void hso_free_interface(struct usb_interface *interface)
 				rfkill_unregister(rfk);
 				rfkill_destroy(rfk);
 			}
-			hso_free_net_device(network_table[i], false);
+			hso_free_net_device(network_table[i]);
 		}
 	}
 }
-- 
2.25.1


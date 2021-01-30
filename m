Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42FEB30992D
	for <lists+netdev@lfdr.de>; Sun, 31 Jan 2021 01:03:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232750AbhAaABh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Jan 2021 19:01:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232496AbhA3XtS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Jan 2021 18:49:18 -0500
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BBBCC061788;
        Sat, 30 Jan 2021 15:47:59 -0800 (PST)
Received: by mail-ej1-x62c.google.com with SMTP id rv9so18534788ejb.13;
        Sat, 30 Jan 2021 15:47:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=CG9ZiWaCv3bx5ltk61kSJm2LBKdDpzjaTjs3MVGhqzs=;
        b=N49ZbO8KQSEl3A0VbcrsegyS842aB2mNMwWGEXpArgao+qmKK1pWT2BmVQbXtqSyQ4
         2Wa94o1ojWDEE//z6V55OIipzBzqMX13pNzFigYInjnGcyUpGgPMuVndChwTI5s+fQKl
         Ftba+H9mo/QmKi32nOWT9lt+ajGLNryyN0wwIEaVc5ISLFL1B3kNjsc4tz94HrmxFe62
         nJuUJzncoOEYZWRJB/EIWk4+nu8FArX4pm8XseY8EUErYGR/nZ6KlUctUlk6dZjPp81B
         nKsPt6Hra1vGjXxMtPzECNBja/NY3pi7tlS14XnDJJR7BNC3aJJZ0CgmE6lcvXSFOVUQ
         by+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=CG9ZiWaCv3bx5ltk61kSJm2LBKdDpzjaTjs3MVGhqzs=;
        b=DPls6KkwXVY5uOXifDvu5a6K/N1B0b8iLuz/u7kqIbrx2Lw8xVPwZQ6J9PbqTgT6b+
         jHeEbbpGIGwyvj5850A2h/mgLwTWy6X20xvj4jtICd3BLL5QvDyDdcNVCO75ZrOHrCrP
         ZiVdqEVTM8Qbzy2NKSOu7m899Qct6BaTVQMYMxYmJ5bEMCXG4w+nZw4U3/MSaycvbZYz
         gec8gGEmmhtJTiZUZqk83hvq1kMLKiTH4zNjKhLOWK5k71mXGYiSlnZ12iSORqK8dSwI
         kmEOPCv5rE+kEGI6vDcn8vlFFoza0pmEK4NJ/GnT5ndTCA1ZM0Du2xUqD79nNP8ZBPlj
         JXfA==
X-Gm-Message-State: AOAM532AwIijtyJphJslA4fNgKSNhHecTVGDBEGxCn7moYPIHrHk0jLR
        56ijENhix287N1JQTiM8fdOQcJ+Axy2xiASN
X-Google-Smtp-Source: ABdhPJxeVK1C+uuWTDxDamSGNl3ende1ALay85m5HsEbTYC8Uxdkd8bJX8lUc5NDz0emUgNHd7MsuQ==
X-Received: by 2002:a17:906:68d0:: with SMTP id y16mr11364287ejr.128.1612050478265;
        Sat, 30 Jan 2021 15:47:58 -0800 (PST)
Received: from stitch.. ([80.71.140.73])
        by smtp.gmail.com with ESMTPSA id u17sm6628009edr.0.2021.01.30.15.47.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 30 Jan 2021 15:47:57 -0800 (PST)
Sender: Emil Renner Berthing <emil.renner.berthing@gmail.com>
From:   Emil Renner Berthing <kernel@esmil.dk>
To:     netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-ppp@vger.kernel.org
Cc:     Emil Renner Berthing <kernel@esmil.dk>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Petko Manolov <petkan@nucleusys.com>,
        Luc Van Oostenryck <luc.vanoostenryck@gmail.com>,
        Jing Xiangfeng <jingxiangfeng@huawei.com>,
        Oliver Neukum <oneukum@suse.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 7/9] net: usb: pegasus: use new tasklet API
Date:   Sun, 31 Jan 2021 00:47:28 +0100
Message-Id: <20210130234730.26565-8-kernel@esmil.dk>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210130234730.26565-1-kernel@esmil.dk>
References: <20210130234730.26565-1-kernel@esmil.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This converts the driver to use the new tasklet API introduced in
commit 12cc923f1ccc ("tasklet: Introduce new initialization API")

Signed-off-by: Emil Renner Berthing <kernel@esmil.dk>
---
 drivers/net/usb/pegasus.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/usb/pegasus.c b/drivers/net/usb/pegasus.c
index 32e1335c94ad..9a907182569c 100644
--- a/drivers/net/usb/pegasus.c
+++ b/drivers/net/usb/pegasus.c
@@ -553,12 +553,11 @@ static void read_bulk_callback(struct urb *urb)
 	tasklet_schedule(&pegasus->rx_tl);
 }
 
-static void rx_fixup(unsigned long data)
+static void rx_fixup(struct tasklet_struct *t)
 {
-	pegasus_t *pegasus;
+	pegasus_t *pegasus = from_tasklet(pegasus, t, rx_tl);
 	int status;
 
-	pegasus = (pegasus_t *) data;
 	if (pegasus->flags & PEGASUS_UNPLUG)
 		return;
 
@@ -1129,7 +1128,7 @@ static int pegasus_probe(struct usb_interface *intf,
 		goto out1;
 	}
 
-	tasklet_init(&pegasus->rx_tl, rx_fixup, (unsigned long) pegasus);
+	tasklet_setup(&pegasus->rx_tl, rx_fixup);
 
 	INIT_DELAYED_WORK(&pegasus->carrier_check, check_carrier);
 
-- 
2.30.0


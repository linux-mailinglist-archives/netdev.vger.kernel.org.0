Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CB44216356
	for <lists+netdev@lfdr.de>; Tue,  7 Jul 2020 03:28:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727817AbgGGB2A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 21:28:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726906AbgGGB2A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jul 2020 21:28:00 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30189C061755;
        Mon,  6 Jul 2020 18:28:00 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id g67so18325463pgc.8;
        Mon, 06 Jul 2020 18:28:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jYisy9Bvbcrb7vDFBK5Rop4LvhAvViQQbVWr4zAKaGo=;
        b=OoKgeKXJi0cf1OCYdMIOiuRoGvnhJHcyBvIiYiIQ54J+EtkCyuCbzdqvHhzIPt2Tiw
         PbCYWq/PmBVv6mtnGForZDoOS9YumAVThpu7j20isEnAjjYIkIufs357Ycc5yX/FDl5W
         v/ZR5WeUB0iIAIivmnNvbOC69TlWIOQ/qPBPfyn/+Q6u1dptOzSunkS6/aCu+Au68m0M
         z3k0pmwYrvGYvq8v2uuAZHAHF47mBFiYFYNRRHkvTUIQLlIjWzTXn29pKrjjjQw9vBOg
         mqfvRjIh9EEMMrlTSwGsaK6813NA4rF7nq0lONiB8kkKh+F7tbgOmUBzOWh1x186/FI7
         pLsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jYisy9Bvbcrb7vDFBK5Rop4LvhAvViQQbVWr4zAKaGo=;
        b=S0TP9FQbykiAnJY8wcPdhnvRFjGwHB1yHQORNc2MbkfvzPe3lOa+jvX9e9Z8OuYrnr
         75M9/7v8rDNNKEOV0Uhju3WBy9Y2TCZJkBZsdMedKqYONapWPazIsHv45cq48M3qYYX+
         CWqQ8yzxzscrLk91SpdEgoQ3yBKFtTB53zREb4BKQypuZP6R9Ub2PQgFSQA3bNMLqCIt
         KvIKK5ns7BJEqe3Xxz7Llb6ks97/QHDln595ot7wirxjl1dx5ds+uW0zNTant/FytGs4
         1+cTSFcaIttgBqJMRz3PqrUwdLFQwcSDQweAu0fie224YRDZZnEimnkpqm3fkJJjh1yM
         /yIw==
X-Gm-Message-State: AOAM531s4R61TVD2avubFjMx4i2l8BueZv7K2RUs0RdjBs9b80nhy6Fd
        PeYulf3FqwhlH2TBB5XDLXY=
X-Google-Smtp-Source: ABdhPJzb1S6S75TZCzd4kf2Jvbn54xFt1FUWWJeDFFov0kzggsj9PhIndc95OjhrAtYY77WvAtUN3Q==
X-Received: by 2002:aa7:9092:: with SMTP id i18mr48236144pfa.18.1594085279684;
        Mon, 06 Jul 2020 18:27:59 -0700 (PDT)
Received: from localhost.localdomain.com ([2605:e000:160b:911f:a2ce:c8ff:fe03:6cb0])
        by smtp.gmail.com with ESMTPSA id v10sm4020224pfc.118.2020.07.06.18.27.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jul 2020 18:27:59 -0700 (PDT)
From:   Chris Healy <cphealy@gmail.com>
X-Google-Original-From: Chris Healy <cphealy@localhost.localdomain>
To:     linux@armlinux.org.uk, andrew@lunn.ch, f.fainelli@gmail.com,
        hkallweit1@gmail.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Chris Healy <cphealy@gmail.com>
Subject: [PATCH net-next v3] net: sfp: Unique GPIO interrupt names
Date:   Mon,  6 Jul 2020 18:27:07 -0700
Message-Id: <20200707012707.13267-1-cphealy@localhost.localdomain>
X-Mailer: git-send-email 2.21.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Chris Healy <cphealy@gmail.com>

Dynamically generate a unique GPIO interrupt name, based on the
device name and the GPIO name.  For example:

103:          0   sx1503q  12 Edge      sff2-los
104:          0   sx1503q  13 Edge      sff2-tx-fault

The sffX indicates the SFP the los and tx-fault are associated with.

Signed-off-by: Chris Healy <cphealy@gmail.com>

v3:
- reverse Christmas tree new variable
- fix spaces vs tabs
v2:
- added net-next to PATCH part of subject line
- switched to devm_kasprintf()
---
 drivers/net/phy/sfp.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
index 73c2969f11a4..7bdfcde98266 100644
--- a/drivers/net/phy/sfp.c
+++ b/drivers/net/phy/sfp.c
@@ -2238,6 +2238,7 @@ static int sfp_probe(struct platform_device *pdev)
 {
 	const struct sff_data *sff;
 	struct i2c_adapter *i2c;
+	char *sfp_irq_name;
 	struct sfp *sfp;
 	int err, i;
 
@@ -2349,12 +2350,16 @@ static int sfp_probe(struct platform_device *pdev)
 			continue;
 		}
 
+		sfp_irq_name = devm_kasprintf(sfp->dev, GFP_KERNEL,
+					      "%s-%s", dev_name(sfp->dev),
+					      gpio_of_names[i]);
+
 		err = devm_request_threaded_irq(sfp->dev, sfp->gpio_irq[i],
 						NULL, sfp_irq,
 						IRQF_ONESHOT |
 						IRQF_TRIGGER_RISING |
 						IRQF_TRIGGER_FALLING,
-						dev_name(sfp->dev), sfp);
+						sfp_irq_name, sfp);
 		if (err) {
 			sfp->gpio_irq[i] = 0;
 			sfp->need_poll = true;
-- 
2.21.3


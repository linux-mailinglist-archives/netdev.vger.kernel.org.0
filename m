Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50375408D63
	for <lists+netdev@lfdr.de>; Mon, 13 Sep 2021 15:24:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240233AbhIMNZp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Sep 2021 09:25:45 -0400
Received: from smtp-relay-internal-0.canonical.com ([185.125.188.122]:34148
        "EHLO smtp-relay-internal-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241169AbhIMNX2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Sep 2021 09:23:28 -0400
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com [209.85.221.69])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 470A34027D
        for <netdev@vger.kernel.org>; Mon, 13 Sep 2021 13:20:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1631539250;
        bh=Fky4BN6I50Xw0PgUAedFiL1xcmFxZZIBVgJL+3QtpWs=;
        h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=LDLkqs8XWdJPlHwSTXyxBqQgS9MUADcFkE2jeuQ1h1KLFFQr12xXbs0/xRC364wcl
         sPciEhQIlfWS5UBUJ7ZaX0nxjDSekxJpqo03sLPA34Z9h5iqSShgjabo/B1nr7tAf2
         9tMo6cIGW4/p+dywCEinGyvGkCgpmbLYQDgHPyNOxOHNdKcHc2+6i19KA8Vbv8vo1C
         +H5SPzBhLdqVmvoa8OeThfp23B2pNz9oBEsZDxamVfUmeod6v0rakq0ugxbr69xQPh
         mB43Yedahb3jr57kc96lcNW2j9sLMFGpfBPmOsbBg1nnrEIjdvgI5cGDRWjN8sL9Ev
         N7Yq8xekTvcng==
Received: by mail-wr1-f69.google.com with SMTP id r5-20020adfb1c5000000b0015cddb7216fso2581932wra.3
        for <netdev@vger.kernel.org>; Mon, 13 Sep 2021 06:20:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Fky4BN6I50Xw0PgUAedFiL1xcmFxZZIBVgJL+3QtpWs=;
        b=wgrr1+PeRFKR7onuJs8Z4SnUr2eKt4zR/a4eA2OaznBQ4l4V9PCxPca3KWmqiFCjKW
         BKL6dkUrzi/aNrjXsSL3fRkjiXQrg66g4NREkiHw0PXkrnC7dhNtLBe0lEcTtSWDyL1Q
         MIjE+8be1UuGp9o6TjFs4XOHpB6bSUIKhaVkSF26vy6h4K135E+VMF0W67kh8IrHUSVV
         4Nbcc6nuTbWw6PxnBk2qSV2ZNBR/vhsKSFo33jp1B257CLbjKlC97bHqJFN1WmdELtNd
         9q/OSnzOL80IMl6PkRe1B5PQA3l4FJLSoFzKk+VsRFkA/wIGJf1a7+0U+FQI9YwVlAD5
         lA5A==
X-Gm-Message-State: AOAM531ZGYpL+a22+mBjgQpWCq73fCiPVBGxsm+iqOcgCiJG2MidIisA
        /MUKl18k4rhlH+paw+DkFSbDdowm8a6MqtEPeQSn7V3DC7H2+CvWZ2DDo6e9s12IzhRE4hHVo/X
        LXybUVFwLppighooM+9CN2PjULC9JdDMI3g==
X-Received: by 2002:adf:8064:: with SMTP id 91mr12357527wrk.252.1631539249990;
        Mon, 13 Sep 2021 06:20:49 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw5+h/fKlKQdXDMhGSM5nR9XBZObuvBHmrufg69rir3eN+eLiOg4WceN/MxX2SmmovwgHEcrQ==
X-Received: by 2002:adf:8064:: with SMTP id 91mr12357504wrk.252.1631539249872;
        Mon, 13 Sep 2021 06:20:49 -0700 (PDT)
Received: from kozik-lap.lan (lk.84.20.244.219.dc.cable.static.lj-kabel.net. [84.20.244.219])
        by smtp.gmail.com with ESMTPSA id n3sm7195888wmi.0.2021.09.13.06.20.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Sep 2021 06:20:49 -0700 (PDT)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Krzysztof Opasiak <k.opasiak@samsung.com>,
        Mark Greer <mgreer@animalcreek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-nfc@lists.01.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org
Subject: [PATCH v2 05/15] nfc: pn533: drop unneeded debug prints
Date:   Mon, 13 Sep 2021 15:20:25 +0200
Message-Id: <20210913132035.242870-6-krzysztof.kozlowski@canonical.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210913132035.242870-1-krzysztof.kozlowski@canonical.com>
References: <20210913132035.242870-1-krzysztof.kozlowski@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ftrace is a preferred and standard way to debug entering and exiting
functions so drop useless debug prints.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
---
 drivers/nfc/pn533/i2c.c   | 4 ----
 drivers/nfc/pn533/pn533.c | 2 --
 2 files changed, 6 deletions(-)

diff --git a/drivers/nfc/pn533/i2c.c b/drivers/nfc/pn533/i2c.c
index e6bf8cfe3aa7..f5610b6b9894 100644
--- a/drivers/nfc/pn533/i2c.c
+++ b/drivers/nfc/pn533/i2c.c
@@ -128,7 +128,6 @@ static int pn533_i2c_read(struct pn533_i2c_phy *phy, struct sk_buff **skb)
 static irqreturn_t pn533_i2c_irq_thread_fn(int irq, void *data)
 {
 	struct pn533_i2c_phy *phy = data;
-	struct i2c_client *client;
 	struct sk_buff *skb = NULL;
 	int r;
 
@@ -137,9 +136,6 @@ static irqreturn_t pn533_i2c_irq_thread_fn(int irq, void *data)
 		return IRQ_NONE;
 	}
 
-	client = phy->i2c_dev;
-	dev_dbg(&client->dev, "IRQ\n");
-
 	if (phy->hard_fault != 0)
 		return IRQ_HANDLED;
 
diff --git a/drivers/nfc/pn533/pn533.c b/drivers/nfc/pn533/pn533.c
index 2f3f3fe9a0ba..c5f127fe2d45 100644
--- a/drivers/nfc/pn533/pn533.c
+++ b/drivers/nfc/pn533/pn533.c
@@ -1235,8 +1235,6 @@ static void pn533_listen_mode_timer(struct timer_list *t)
 {
 	struct pn533 *dev = from_timer(dev, t, listen_timer);
 
-	dev_dbg(dev->dev, "Listen mode timeout\n");
-
 	dev->cancel_listen = 1;
 
 	pn533_poll_next_mod(dev);
-- 
2.30.2


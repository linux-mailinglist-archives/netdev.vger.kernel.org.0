Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A81A40288E
	for <lists+netdev@lfdr.de>; Tue,  7 Sep 2021 14:19:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344822AbhIGMUh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Sep 2021 08:20:37 -0400
Received: from smtp-relay-internal-1.canonical.com ([185.125.188.123]:33702
        "EHLO smtp-relay-internal-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1344346AbhIGMTw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Sep 2021 08:19:52 -0400
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com [209.85.128.70])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 0921840779
        for <netdev@vger.kernel.org>; Tue,  7 Sep 2021 12:18:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1631017118;
        bh=AKOLSiNotprej29rkzU07CereuPK7jDMwjY+iTyzzwA=;
        h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=HFklzmnP9rTq9LMetMxwEr9i1bDD5hHmIqw5uu274s1r8Uf+oLJTxZtOocBDrf5jm
         yH1mhPaWN+VeYCAxy2sfZ7/aFp7MS2iojNdSAWeuPD9qAIAtNiBZxPtnW2Rca7yNRJ
         AyEcYKW6rnsYpvCz6sSTykeW/xY5FLzvfYf/9ctdoeuZMjIECe3hPvdI6aDYwIossl
         a8goohdPd/dnNfzWMR9NtfWhioG6ZiDu+R6W/mWuyIN13rYSF9Of6Zljy/PLpUwoYZ
         XcMwvv0Egboeb1j7FctJqKa/AmN4oxJlbPDjOaHAacgbnAOVjBVQgtYWUjKO/imTi1
         KqxV2Nps2WIQA==
Received: by mail-wm1-f70.google.com with SMTP id r126-20020a1c4484000000b002e8858850abso3325877wma.0
        for <netdev@vger.kernel.org>; Tue, 07 Sep 2021 05:18:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=AKOLSiNotprej29rkzU07CereuPK7jDMwjY+iTyzzwA=;
        b=Fxrz8P0GEPnxk632xGHOk16cNPIrJrkpH7ek9Z6Nk7Yn5pr3u0myDoPjyBmwFJ9QzJ
         95tob7U40jyHAgcMB+yJlTybi5o1B2DDnodPUZ6nb3gMFReeTS2ZScKe+wUg1cB9wyic
         bDMyIcjxtGh9PYWqo9wlwVJU9lESV+f23ygsju7HnuxdLGOufyrJT3zs6rAOfswVgN80
         ntjlKuESbgLYXmHRMeqVFvIg/hyeYpTlcsG184qOVVejJXeOAykPt+uTyGbPkW2VNu0S
         cAk2974epvBjTQYQ0XOi4qaF/OruVy7B55YF54L9yxTf0fb9VE8ArkHkF/s/FMnbMmn7
         EtzA==
X-Gm-Message-State: AOAM532w3LFn1GOHa2bRiF0LMhoYsV40E9L4DKbwq7/j42mRzmODMcJD
        Yxr6l5dsk1fpbxediq3jdLEAu6jvvTY0qX9fjz7NxdQv0Unt73Ff2OSjvr+OmOAbcD7GweBlSm5
        SjEfgdqWLaLWDLv9KG12MuACE9Fz9RItxeQ==
X-Received: by 2002:a5d:4ec5:: with SMTP id s5mr18813221wrv.267.1631017117795;
        Tue, 07 Sep 2021 05:18:37 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzVLcRdCI3iDjK/G4gORzXajvhzjEDqB6WvYfzQBGQHCjdeU0byAvmPWP02UqU4TwnqzrjuVw==
X-Received: by 2002:a5d:4ec5:: with SMTP id s5mr18813203wrv.267.1631017117668;
        Tue, 07 Sep 2021 05:18:37 -0700 (PDT)
Received: from kozik-lap.lan ([79.98.113.47])
        by smtp.gmail.com with ESMTPSA id m3sm13525216wrg.45.2021.09.07.05.18.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Sep 2021 05:18:37 -0700 (PDT)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Krzysztof Opasiak <k.opasiak@samsung.com>,
        Mark Greer <mgreer@animalcreek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-nfc@lists.01.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org
Subject: [PATCH 13/15] nfc: microread: drop unneeded debug prints
Date:   Tue,  7 Sep 2021 14:18:14 +0200
Message-Id: <20210907121816.37750-14-krzysztof.kozlowski@canonical.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210907121816.37750-1-krzysztof.kozlowski@canonical.com>
References: <20210907121816.37750-1-krzysztof.kozlowski@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ftrace is a preferred and standard way to debug entering and exiting
functions so drop useless debug prints.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
---
 drivers/nfc/microread/i2c.c | 4 ----
 drivers/nfc/microread/mei.c | 2 --
 2 files changed, 6 deletions(-)

diff --git a/drivers/nfc/microread/i2c.c b/drivers/nfc/microread/i2c.c
index 86f593c73ed6..067295124eb9 100644
--- a/drivers/nfc/microread/i2c.c
+++ b/drivers/nfc/microread/i2c.c
@@ -237,8 +237,6 @@ static int microread_i2c_probe(struct i2c_client *client,
 	struct microread_i2c_phy *phy;
 	int r;
 
-	dev_dbg(&client->dev, "client %p\n", client);
-
 	phy = devm_kzalloc(&client->dev, sizeof(struct microread_i2c_phy),
 			   GFP_KERNEL);
 	if (!phy)
@@ -262,8 +260,6 @@ static int microread_i2c_probe(struct i2c_client *client,
 	if (r < 0)
 		goto err_irq;
 
-	nfc_info(&client->dev, "Probed\n");
-
 	return 0;
 
 err_irq:
diff --git a/drivers/nfc/microread/mei.c b/drivers/nfc/microread/mei.c
index 8edf761a6b2a..686be3381727 100644
--- a/drivers/nfc/microread/mei.c
+++ b/drivers/nfc/microread/mei.c
@@ -23,8 +23,6 @@ static int microread_mei_probe(struct mei_cl_device *cldev,
 	struct nfc_mei_phy *phy;
 	int r;
 
-	pr_info("Probing NFC microread\n");
-
 	phy = nfc_mei_phy_alloc(cldev);
 	if (!phy) {
 		pr_err("Cannot allocate memory for microread mei phy.\n");
-- 
2.30.2


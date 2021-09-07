Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF12A402880
	for <lists+netdev@lfdr.de>; Tue,  7 Sep 2021 14:19:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344610AbhIGMUU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Sep 2021 08:20:20 -0400
Received: from smtp-relay-internal-1.canonical.com ([185.125.188.123]:33688
        "EHLO smtp-relay-internal-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1344313AbhIGMTu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Sep 2021 08:19:50 -0400
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com [209.85.128.70])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id F353E4015D
        for <netdev@vger.kernel.org>; Tue,  7 Sep 2021 12:18:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1631017110;
        bh=NBr1U4LAwKajfkWi8d66f/F7DJmWNcP01ndf/w7qpqs=;
        h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=PN/OgM3lunGwgycn8et2C4vNacltmKKfNlmUUFbrGWpS3C4ybrYeybVbCB/ociM15
         VLBswpaUVEvRR0gwRmEj3dCotqrvlEyrfcj14XqtadaRbGxwS3qUFo7aICSgeBuCoX
         gFcwDXEiX1EV0u/N5vHhjtIUiBUK57RfB9T/EpYdAKw7Wv23EtsUp3+hM0Z1Sw6gnv
         WlWNQh3kTXj/28whJnw4wecELya0uzowKAHYiScEd67ter83Xv5duSVX1p5ba6qgJp
         g6bXfmpT+fIXZ1toEkaAnobqxkzbD/SFzMvTcVFPTUYNd7kxLZOGBEroQPovrASCbF
         BlAgAQV2cX9dQ==
Received: by mail-wm1-f70.google.com with SMTP id r125-20020a1c2b830000b0290197a4be97b7so1027798wmr.9
        for <netdev@vger.kernel.org>; Tue, 07 Sep 2021 05:18:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NBr1U4LAwKajfkWi8d66f/F7DJmWNcP01ndf/w7qpqs=;
        b=LNsRADMbnrQL+6RrSilHE80DadC4ZQG4RPpOP62NadKW3aapF+a8o3dUzomycmVPj5
         n1RTNahY7YSRYJGbj2WXB/cRbDVfYPQrNlWgr2yI6lTTslLDle4Fkdp6yyHw+nkFqZop
         0QGFPqmHmOmGPx0cjXekZA/zcPZlJxuAULkOY6WjAc3ERBMFStisn5PLVaVU6jMIJ+5I
         kEdhdn2eSh+IXn62pXqmGE0M8Ld7BzIqYjaFE1mOpANern/78aZGTv4rUbv7oaG9qzSS
         8ksAlrkr+7qvYD5Z9sXBeoeQpSiALL96m93OPmkC1VvAHSZhBSVi/tjvZEQcdPTO36T5
         6Kvg==
X-Gm-Message-State: AOAM533xc7wI1XYqlQUy+Q3mFPLv0sPHCJXVFyJCcknn4Al2DmL5DruX
        cqWrzMUMVnrT4tJacKvzlsZgtGoyeyPy1JgMTq0OxH+W5l73VORsAqLphT51E+ldKonLROddBvQ
        cJt+V+Eddxvm9gk84f5bDUJ9IOzKpOuS1dA==
X-Received: by 2002:a05:600c:210a:: with SMTP id u10mr3577100wml.127.1631017110345;
        Tue, 07 Sep 2021 05:18:30 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwpmN+J+nVSHJybMfzx2E98USXqdlKN6XTJk2Iwf0j0Co7NOrQuorgTzMhtPjYxrxKxWVDRvA==
X-Received: by 2002:a05:600c:210a:: with SMTP id u10mr3577088wml.127.1631017110234;
        Tue, 07 Sep 2021 05:18:30 -0700 (PDT)
Received: from kozik-lap.lan ([79.98.113.47])
        by smtp.gmail.com with ESMTPSA id m3sm13525216wrg.45.2021.09.07.05.18.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Sep 2021 05:18:29 -0700 (PDT)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Krzysztof Opasiak <k.opasiak@samsung.com>,
        Mark Greer <mgreer@animalcreek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-nfc@lists.01.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org
Subject: [PATCH 07/15] nfc: pn544: drop unneeded debug prints
Date:   Tue,  7 Sep 2021 14:18:08 +0200
Message-Id: <20210907121816.37750-8-krzysztof.kozlowski@canonical.com>
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
 drivers/nfc/pn544/mei.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/nfc/pn544/mei.c b/drivers/nfc/pn544/mei.c
index 5c10aac085a4..a519fa0a53e2 100644
--- a/drivers/nfc/pn544/mei.c
+++ b/drivers/nfc/pn544/mei.c
@@ -22,8 +22,6 @@ static int pn544_mei_probe(struct mei_cl_device *cldev,
 	struct nfc_mei_phy *phy;
 	int r;
 
-	pr_info("Probing NFC pn544\n");
-
 	phy = nfc_mei_phy_alloc(cldev);
 	if (!phy) {
 		pr_err("Cannot allocate memory for pn544 mei phy.\n");
@@ -46,8 +44,6 @@ static void pn544_mei_remove(struct mei_cl_device *cldev)
 {
 	struct nfc_mei_phy *phy = mei_cldev_get_drvdata(cldev);
 
-	pr_info("Removing pn544\n");
-
 	pn544_hci_remove(phy->hdev);
 
 	nfc_mei_phy_free(phy);
-- 
2.30.2


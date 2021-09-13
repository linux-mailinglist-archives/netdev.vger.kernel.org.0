Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52E8C408D65
	for <lists+netdev@lfdr.de>; Mon, 13 Sep 2021 15:24:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241071AbhIMNZr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Sep 2021 09:25:47 -0400
Received: from smtp-relay-internal-0.canonical.com ([185.125.188.122]:34174
        "EHLO smtp-relay-internal-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240928AbhIMNXi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Sep 2021 09:23:38 -0400
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com [209.85.128.69])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 5B40B4025C
        for <netdev@vger.kernel.org>; Mon, 13 Sep 2021 13:20:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1631539254;
        bh=NBr1U4LAwKajfkWi8d66f/F7DJmWNcP01ndf/w7qpqs=;
        h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=eKne7l7JsWA9Oyqv1ej25m2CyAPojw00ksawllNBhUEzH0ZbiNYz83s/f9tfqky5F
         nIdM5nruK+ENQJgamMXhOKzqvqbmCXZ0H7gNdv623agZNW7W2TuB96pz0byZuS9kyg
         1gIsNpbQ/fU/u2CvHGQ7E4mmq4mZF83AJeCB6w2dhSVcMdPe8ZpB4/rbC/mVA9BAH3
         jRY1ekDZCtXtrgeMFeSLZzbPulME9H2eq2URilg78BcpkGrFBSPkCj3QHpTJIw+OJb
         fpCvjHdVDEuROrY95Re+jRus9/7YOom1q421gYqjLlWq7zNYRyfRgH8AR48iUwxE9P
         KRmlgh5GimozA==
Received: by mail-wm1-f69.google.com with SMTP id z18-20020a1c7e120000b02902e69f6fa2e0so4910703wmc.9
        for <netdev@vger.kernel.org>; Mon, 13 Sep 2021 06:20:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NBr1U4LAwKajfkWi8d66f/F7DJmWNcP01ndf/w7qpqs=;
        b=ujzcYt8u+UezoTANtm2+pFsHMIZ4ZDEHLTz9HowdqI727RxLBsdqWoMl0yRPIpraIb
         nNMloi6cvON8gBXJDM68lvye8vDBWSn2fuj2PSWcjuo1K+ssD2EF1056DdDS+KZtYttS
         r0UnanaVbeoLlHUcezGZ+LMBztkMlk1dpKNy6pthohIg9gH2peRpU84UUwVnEJQqYgT/
         nuFnYbyrGY0R+iYCSMG3fGwik1dNWJobTpXLgnHz6FEcuk0ehBgJsAx6Zev92vcrj+Z/
         AvXuy69gm5wSEZZgsqJYvxj5wuh2z0uvpQs5BnUvj5y8zNG1o1Roe0rvs9PhPUPGRRMP
         Ehyw==
X-Gm-Message-State: AOAM531b1kIk//zAS5yqdFKJQqTIvufCVXntRJK0L2eiThEwTI2DqdhV
        bbJhYqQpmwwq638kKW9YvxY1voWIZPj1J02n6lb9Ef071PxDfrmXVF8K4Xvr++qKcrP5Ew1ZhDp
        uKtasuWXPbqIp45SuRAMYn2O7kwoS9s55CA==
X-Received: by 2002:a1c:f60c:: with SMTP id w12mr11300816wmc.3.1631539253788;
        Mon, 13 Sep 2021 06:20:53 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw4mhlijtrqBRrwe325QIJTV+NH9oRbw4vOfFD3MMxQ/lm7QV3e8395RpL+PFPpNFF13sZ40A==
X-Received: by 2002:a1c:f60c:: with SMTP id w12mr11300790wmc.3.1631539253600;
        Mon, 13 Sep 2021 06:20:53 -0700 (PDT)
Received: from kozik-lap.lan (lk.84.20.244.219.dc.cable.static.lj-kabel.net. [84.20.244.219])
        by smtp.gmail.com with ESMTPSA id n3sm7195888wmi.0.2021.09.13.06.20.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Sep 2021 06:20:53 -0700 (PDT)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Krzysztof Opasiak <k.opasiak@samsung.com>,
        Mark Greer <mgreer@animalcreek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-nfc@lists.01.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org
Subject: [PATCH v2 07/15] nfc: pn544: drop unneeded debug prints
Date:   Mon, 13 Sep 2021 15:20:27 +0200
Message-Id: <20210913132035.242870-8-krzysztof.kozlowski@canonical.com>
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


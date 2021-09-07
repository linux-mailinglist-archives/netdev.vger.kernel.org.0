Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3AC640287D
	for <lists+netdev@lfdr.de>; Tue,  7 Sep 2021 14:19:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344580AbhIGMUR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Sep 2021 08:20:17 -0400
Received: from smtp-relay-internal-0.canonical.com ([185.125.188.122]:36972
        "EHLO smtp-relay-internal-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1344183AbhIGMTi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Sep 2021 08:19:38 -0400
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com [209.85.128.71])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id AD4AA4079B
        for <netdev@vger.kernel.org>; Tue,  7 Sep 2021 12:18:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1631017111;
        bh=alAZCnXDBZFqFGCWdjT1NtYwVcFPW4mHC6+AQVNQmag=;
        h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=trlr4oC8LLuY5GeQkmvHgbJsYUtlqK9BukxXXgZehcZTvW+lLylO5H1FoHfVU4RHQ
         qIAb7rHlZFUJpfMJuHiwXDYuDjjdWh1S0TeH6qjenACrNrzK2JJdwuRtUjLa0vh4Z7
         PdVmQEJz8PFLICWDV1BkzqRHkM9deQdBgPYvdrlHngODvLJxksmuJhe8rivaeuCod3
         34LP/rzzXApaDTTc8nvyAD/xoeDhGnVjjncnRFaKSGr6jh9moGDyUqGrJax0j+tDIL
         KabZ+QGFTrv0SML9Uk+unL1eM6+kSoMmjRxkwStkkSwNzq97krA5Ikz/qvd+7PeEok
         bsEIbaJyLIVLw==
Received: by mail-wm1-f71.google.com with SMTP id p11-20020a05600c204b00b002f05aff1663so1039085wmg.2
        for <netdev@vger.kernel.org>; Tue, 07 Sep 2021 05:18:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=alAZCnXDBZFqFGCWdjT1NtYwVcFPW4mHC6+AQVNQmag=;
        b=PZtBfE9+gNn0zGfGufqRnZjcnDdTwTKlFPphJtf2v3jICArrKorJv3TyJ67a2lMOfH
         3H0lOWWoxVeDi90J6zsJRBLGySej7pYh7WBJwyYJ5xpOlqxxRDLPJFMQY/esF0/9tRWm
         Iccy3XyC1JIQcrhfqEBczmWRpnbxdihW3mYatqJAzmPjbQeREc9yMjmFmoRwVW8CG3Lz
         iMjMOoDdncdQCUCnV1bhWy+0W9fKd9kKR+xx7QXTfZkblrXFs0L3fZLPrKWH7jTmBCK4
         N1WGHQb0/S79McKYrBPSEKkImHgifQnoQgnXQNSMpdvRowIska1AohC1m99GaIjGn9tB
         /aXQ==
X-Gm-Message-State: AOAM530hH4nPnYbZf3YmOVsA2l4LQqjgIF8mnsAJUk/lrudWby+iZNya
        lLN3EdYCrcpH6SSWDDssW8pGEbLkjq8qeHvpEvB+K/KpkbqJDkl1fN2fM10xllo/f+xMBf2qqWX
        Trl2amkHBjom3Wzs10N2cNwrDDFtyc9eJBg==
X-Received: by 2002:a7b:c4d2:: with SMTP id g18mr3717620wmk.135.1631017111462;
        Tue, 07 Sep 2021 05:18:31 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxSzLNNlEK8DFo/MnzQggQYeVU3xGdFUyuK/8MdNZjNchdqevSP20XoztHRWZaK3JDeEdaRWA==
X-Received: by 2002:a7b:c4d2:: with SMTP id g18mr3717597wmk.135.1631017111286;
        Tue, 07 Sep 2021 05:18:31 -0700 (PDT)
Received: from kozik-lap.lan ([79.98.113.47])
        by smtp.gmail.com with ESMTPSA id m3sm13525216wrg.45.2021.09.07.05.18.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Sep 2021 05:18:30 -0700 (PDT)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Krzysztof Opasiak <k.opasiak@samsung.com>,
        Mark Greer <mgreer@animalcreek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-nfc@lists.01.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org
Subject: [PATCH 08/15] nfc: pn544: drop unneeded memory allocation fail messages
Date:   Tue,  7 Sep 2021 14:18:09 +0200
Message-Id: <20210907121816.37750-9-krzysztof.kozlowski@canonical.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210907121816.37750-1-krzysztof.kozlowski@canonical.com>
References: <20210907121816.37750-1-krzysztof.kozlowski@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

nfc_mei_phy_alloc() already prints an error message on memory allocation
failure.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
---
 drivers/nfc/pn544/mei.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/nfc/pn544/mei.c b/drivers/nfc/pn544/mei.c
index a519fa0a53e2..c493f2dbd0e2 100644
--- a/drivers/nfc/pn544/mei.c
+++ b/drivers/nfc/pn544/mei.c
@@ -23,10 +23,8 @@ static int pn544_mei_probe(struct mei_cl_device *cldev,
 	int r;
 
 	phy = nfc_mei_phy_alloc(cldev);
-	if (!phy) {
-		pr_err("Cannot allocate memory for pn544 mei phy.\n");
+	if (!phy)
 		return -ENOMEM;
-	}
 
 	r = pn544_hci_probe(phy, &mei_phy_ops, LLC_NOP_NAME,
 			    MEI_NFC_HEADER_SIZE, 0, MEI_NFC_MAX_HCI_PAYLOAD,
-- 
2.30.2


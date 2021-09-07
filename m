Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9F18402892
	for <lists+netdev@lfdr.de>; Tue,  7 Sep 2021 14:20:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344229AbhIGMUx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Sep 2021 08:20:53 -0400
Received: from smtp-relay-internal-1.canonical.com ([185.125.188.123]:33688
        "EHLO smtp-relay-internal-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1344479AbhIGMUC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Sep 2021 08:20:02 -0400
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com [209.85.128.71])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 7864840815
        for <netdev@vger.kernel.org>; Tue,  7 Sep 2021 12:18:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1631017119;
        bh=KQ0ijwIeFsveeXdiNAQIdSvmUM7JWh6ALRqQaOVckDE=;
        h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=wdnn4Cu+1kPZwLD8NSz8v4+gilcSmMUNzV19dgbI8z7OTYIm2VXD0H26q7CVS0LZj
         yljS/ufJWBhbS/vOu54tXmjjowYXkYptc6MqU18Wu+GLPJlOKcSag9KpzRK6VWHUI5
         1UaA7r+j6H8qnaWHjz902P+1V2FL2pYJB1kMH6o2b57CIKo7Lj8XUYHNk8EUlefj4Z
         /dqXgfX117aM2QSFadNarzKjSA520y5UEYG2gUt+GsfJge7We8YCLW+HoMusrEaUJP
         0Glsx42KKI0/e3z4u5KoSbsxyo9sqE8RhUF9U//V8EP2zp3H+3p6wXArsOsrhXbo54
         dTAhJ7X/hTHqA==
Received: by mail-wm1-f71.google.com with SMTP id r126-20020a1c4484000000b002e8858850abso3325902wma.0
        for <netdev@vger.kernel.org>; Tue, 07 Sep 2021 05:18:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KQ0ijwIeFsveeXdiNAQIdSvmUM7JWh6ALRqQaOVckDE=;
        b=dC3KMI43V8G5EhhelU0rI4pbugCVGwwGb9moCT4+aVx5DSENj3JZv0RCl1NUsQqj0c
         hIpKm8Uk+mIaVtz1IOfPwEoeJcstGFOJDhruDFacqRc6RXTPSvfMoEYfespWQjFKsEhi
         foCBOxIj76pR49xmXHrWx3U+hBst7uy2yAh50W5dF5q80+jgozGkkMONsj2QUetdtVTz
         4Qao8sMYmPTwsonlGjdBU7Yc8FhL0aLNUPDuL4wnpBv3WpLrzhhyuiMHxagxup+ky+M5
         JwnoqGY3Jfu3MOXLmh1iyfwDlXrnHAL7dMQr1BxPGv+RwL3I+5ffqamDnPKSVJj+UdF2
         1tPA==
X-Gm-Message-State: AOAM532kmtp/30iPjSNxKjiI5K57rILEKKuPTDSepI/jL6/IjBi+xRU6
        0cR55aaQ7KFj2chCbhCIZoff8drLMKdV/tZDnytW1XY0MEchVygRb4AZXn7uNgCw0sjaMqhOd2v
        yPnKjaM8BEWzdU/fZCi443129n6fKha3khA==
X-Received: by 2002:a1c:4e02:: with SMTP id g2mr3721765wmh.64.1631017119171;
        Tue, 07 Sep 2021 05:18:39 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxQnetzmuiPkZxY5ujifiMc0ZSDMSRGclmWVVBN7PzhHJltL2XOpfe1Q53piPXGFgUJqPpP0w==
X-Received: by 2002:a1c:4e02:: with SMTP id g2mr3721745wmh.64.1631017119053;
        Tue, 07 Sep 2021 05:18:39 -0700 (PDT)
Received: from kozik-lap.lan ([79.98.113.47])
        by smtp.gmail.com with ESMTPSA id m3sm13525216wrg.45.2021.09.07.05.18.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Sep 2021 05:18:38 -0700 (PDT)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Krzysztof Opasiak <k.opasiak@samsung.com>,
        Mark Greer <mgreer@animalcreek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-nfc@lists.01.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org
Subject: [PATCH 14/15] nfc: microread: drop unneeded memory allocation fail messages
Date:   Tue,  7 Sep 2021 14:18:15 +0200
Message-Id: <20210907121816.37750-15-krzysztof.kozlowski@canonical.com>
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
 drivers/nfc/microread/mei.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/nfc/microread/mei.c b/drivers/nfc/microread/mei.c
index 686be3381727..e2a77a5fc887 100644
--- a/drivers/nfc/microread/mei.c
+++ b/drivers/nfc/microread/mei.c
@@ -24,10 +24,8 @@ static int microread_mei_probe(struct mei_cl_device *cldev,
 	int r;
 
 	phy = nfc_mei_phy_alloc(cldev);
-	if (!phy) {
-		pr_err("Cannot allocate memory for microread mei phy.\n");
+	if (!phy)
 		return -ENOMEM;
-	}
 
 	r = microread_probe(phy, &mei_phy_ops, LLC_NOP_NAME,
 			    MEI_NFC_HEADER_SIZE, 0, MEI_NFC_MAX_HCI_PAYLOAD,
-- 
2.30.2


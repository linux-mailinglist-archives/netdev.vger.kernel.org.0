Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16307408D93
	for <lists+netdev@lfdr.de>; Mon, 13 Sep 2021 15:26:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240298AbhIMN1c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Sep 2021 09:27:32 -0400
Received: from smtp-relay-internal-0.canonical.com ([185.125.188.122]:34138
        "EHLO smtp-relay-internal-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241731AbhIMNZ1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Sep 2021 09:25:27 -0400
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com [209.85.221.69])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 4985B4027B
        for <netdev@vger.kernel.org>; Mon, 13 Sep 2021 13:20:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1631539256;
        bh=alAZCnXDBZFqFGCWdjT1NtYwVcFPW4mHC6+AQVNQmag=;
        h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=G9djHexx0R9NXdFbT6r2ji1LWT3IAbRkzWQgazK6/VEwNWmqrZNvuUhnXu0fh2Hu4
         najF96bqY1mZwlFxe0OmAWSj9P1sq9eUw3i82zFLm0mylPlPYsSjC66mzzxhUJvQkJ
         1ODm+0Qsm7teBvMnWF+YOdFSfvVoVcXdY8Gx2J46MrwDAMv1oDR0RczB/RHPcWGWMf
         qYHwDwak48slGNo0zWx6Z8YiQJRvlLcfjRiAWl97/AdO4SOQl0pUZeVF7EjQ/Ds6AW
         azPU35IMMUw4bgXO8xPk5fLLyCgSBLggKHMgyQsaZw7fI9gi2ULOV7SUlvdhnDf0hl
         RDVlwL6khJpnA==
Received: by mail-wr1-f69.google.com with SMTP id v1-20020adfc401000000b0015e11f71e65so213653wrf.2
        for <netdev@vger.kernel.org>; Mon, 13 Sep 2021 06:20:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=alAZCnXDBZFqFGCWdjT1NtYwVcFPW4mHC6+AQVNQmag=;
        b=pIR5Qh86MxkBwVxs6oWP2vm9ovsiKkE43Bl1iL6QgJia1BzeRXmg89B4Uef8OZdeuP
         qunZiikxkACGf/oAFy7rO9Ja38YlVef/OIbtVKInkJlYFTu5HVUn/2SDZKqBgFxWXSkb
         iWeaggzW/Ly1e8CYDiO6oW2NctIB4YwLLg7nKpyel4azS4mamzyh1pUiSVampZfU5bZU
         CMGDPHu/owbN8PFGqpGGWUrXCu+8Jjv/XMIOIUKQx7wKWhM+c+Xw2H3k9JUT0CvtXUc7
         ov4Z8s01gOmwqQqgT0ROP0jGHJfh2e5DDs03h5ZTuveCxyQ/7wunDNvk3i5QV1eeF71r
         ESVw==
X-Gm-Message-State: AOAM533XJvxwcIbwesZRQ40G2zvBBKZQXOLAjTiMT7fl7j6JOg9hRrab
        ekBX5uVYZH16I8f0auxt+V8IB7hnYKfzIljaeQHYiQUNAygploLKwD+w/zIYDt3Le5Nj4QSVBrH
        D106Rcruo+ZYWWlMUs2f5kb3uZITUcUkG1w==
X-Received: by 2002:a5d:6792:: with SMTP id v18mr12576739wru.416.1631539255420;
        Mon, 13 Sep 2021 06:20:55 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwY6LXmCoBiMxgVg0ZBqajR5G6WaCpegfR/vq0xViC/Z1KjH8g67spH4c6MeVe7uNeK0A2zmQ==
X-Received: by 2002:a5d:6792:: with SMTP id v18mr12576720wru.416.1631539255299;
        Mon, 13 Sep 2021 06:20:55 -0700 (PDT)
Received: from kozik-lap.lan (lk.84.20.244.219.dc.cable.static.lj-kabel.net. [84.20.244.219])
        by smtp.gmail.com with ESMTPSA id n3sm7195888wmi.0.2021.09.13.06.20.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Sep 2021 06:20:54 -0700 (PDT)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Krzysztof Opasiak <k.opasiak@samsung.com>,
        Mark Greer <mgreer@animalcreek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-nfc@lists.01.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org
Subject: [PATCH v2 08/15] nfc: pn544: drop unneeded memory allocation fail messages
Date:   Mon, 13 Sep 2021 15:20:28 +0200
Message-Id: <20210913132035.242870-9-krzysztof.kozlowski@canonical.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210913132035.242870-1-krzysztof.kozlowski@canonical.com>
References: <20210913132035.242870-1-krzysztof.kozlowski@canonical.com>
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


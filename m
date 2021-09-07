Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E063D402895
	for <lists+netdev@lfdr.de>; Tue,  7 Sep 2021 14:20:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344473AbhIGMVB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Sep 2021 08:21:01 -0400
Received: from smtp-relay-internal-1.canonical.com ([185.125.188.123]:33710
        "EHLO smtp-relay-internal-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1344497AbhIGMUC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Sep 2021 08:20:02 -0400
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com [209.85.221.72])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id A0A954079E
        for <netdev@vger.kernel.org>; Tue,  7 Sep 2021 12:18:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1631017120;
        bh=IGi454bY1uM8p5QRZSKGDo9YXvHCL/LufQFtzz+SznM=;
        h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=BKgQmkFGobUvYp4GFsCJgQW/pS4+dZHWtVS2CgD0+/SI7oAylF4qKPMClkPE2XS9K
         KiZgUKdoGhiybUMClbmES0ASH/vud9PeZBpFkNjWyNt1E5o1XhJkp7Rpx++N8C3zW6
         Ho1loJ4DQ2kx8RN6QMF24nvlqOSbTPQAKgfAid2UyNRputTZHAaoQs+OO5q23+jOtk
         x6M9WFETDet2o8tUchLOwI9jxOtL8VKItU8ahicahuLk/ImV0VX/13u7+cHFhCxhbQ
         ZXqRG6pQpbHxYhkM5caBjQto37Wy/nRNpkqVFkWT+0GhNR+RcCyPMu8vz/LMs5nc6E
         2oXBE6+0V5CTw==
Received: by mail-wr1-f72.google.com with SMTP id t15-20020a5d42cf000000b001565f9c9ee8so2055596wrr.2
        for <netdev@vger.kernel.org>; Tue, 07 Sep 2021 05:18:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=IGi454bY1uM8p5QRZSKGDo9YXvHCL/LufQFtzz+SznM=;
        b=L2S4VNWzSnOh3/HUN6pf9n2wotZURKz1tFLQnz3bkcjdC2Pi7dhWafA6uWDTz6MWIk
         dX/mIbFcAPwO/ks1DoGd3a+s6KClH6m2GRJN0iPiHP5OHD9VJVEbPkhHtdrO/Cx/J0ke
         5Lj1lbkQORj1EP3lpOP83+1KGjmGrP/RdYlmcs2uUVfw4flCG+8RtqczuOaW0i+z9HFq
         Ch7cy5323ju66Z3g28vfAbyxhgPU9+Bray1J6BgNqx/WBfi78/xFl33xk7Sz69A7eQGY
         iewsZeezVfdrMl86epFuXNjXT1a1c+OcezGWOItmU3rBPVKBrxB+lcnjo1meaew4UrTi
         h/jQ==
X-Gm-Message-State: AOAM531lH7G6BYzrPSUuOJh1CUbKJM6aXpbK1z+aE5q0CL6eR2CGEUe9
        rNIJN/5IGkEPr9e2tfwH9t5ZTRw1x7VV8kb3Ul1r779VP2pb7SqV2CtUPcb5V35mOZXwOcpUohW
        1cvdcv+AfmnNqA7jlza2gEqtQCJS9OnONfg==
X-Received: by 2002:a05:600c:1d27:: with SMTP id l39mr3629441wms.146.1631017120415;
        Tue, 07 Sep 2021 05:18:40 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxzkQReT6hqXvnsRi4xVMvPv5mwLHDY/KqHilLqyCDbOJpRRpQ8tjRRU7brxn8w70vPDRKkmA==
X-Received: by 2002:a05:600c:1d27:: with SMTP id l39mr3629425wms.146.1631017120289;
        Tue, 07 Sep 2021 05:18:40 -0700 (PDT)
Received: from kozik-lap.lan ([79.98.113.47])
        by smtp.gmail.com with ESMTPSA id m3sm13525216wrg.45.2021.09.07.05.18.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Sep 2021 05:18:39 -0700 (PDT)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Krzysztof Opasiak <k.opasiak@samsung.com>,
        Mark Greer <mgreer@animalcreek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-nfc@lists.01.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org
Subject: [PATCH 15/15] nfc: mrvl: drop unneeded memory allocation fail messages
Date:   Tue,  7 Sep 2021 14:18:16 +0200
Message-Id: <20210907121816.37750-16-krzysztof.kozlowski@canonical.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210907121816.37750-1-krzysztof.kozlowski@canonical.com>
References: <20210907121816.37750-1-krzysztof.kozlowski@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

nci_skb_alloc() already prints an error message on memory allocation
failure.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
---
 drivers/nfc/nfcmrvl/fw_dnld.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/nfc/nfcmrvl/fw_dnld.c b/drivers/nfc/nfcmrvl/fw_dnld.c
index edac56b01fd1..e83f65596a88 100644
--- a/drivers/nfc/nfcmrvl/fw_dnld.c
+++ b/drivers/nfc/nfcmrvl/fw_dnld.c
@@ -76,10 +76,8 @@ static struct sk_buff *alloc_lc_skb(struct nfcmrvl_private *priv, uint8_t plen)
 	struct nci_data_hdr *hdr;
 
 	skb = nci_skb_alloc(priv->ndev, (NCI_DATA_HDR_SIZE + plen), GFP_KERNEL);
-	if (!skb) {
-		pr_err("no memory for data\n");
+	if (!skb)
 		return NULL;
-	}
 
 	hdr = skb_put(skb, NCI_DATA_HDR_SIZE);
 	hdr->conn_id = NCI_CORE_LC_CONNID_PROP_FW_DL;
-- 
2.30.2


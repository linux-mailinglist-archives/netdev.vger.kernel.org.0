Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E3CF408DA1
	for <lists+netdev@lfdr.de>; Mon, 13 Sep 2021 15:27:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236893AbhIMN1w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Sep 2021 09:27:52 -0400
Received: from smtp-relay-internal-0.canonical.com ([185.125.188.122]:34290
        "EHLO smtp-relay-internal-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241188AbhIMNZj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Sep 2021 09:25:39 -0400
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com [209.85.221.70])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 5BF5E40289
        for <netdev@vger.kernel.org>; Mon, 13 Sep 2021 13:21:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1631539270;
        bh=IGi454bY1uM8p5QRZSKGDo9YXvHCL/LufQFtzz+SznM=;
        h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=TVKJmnVJLRM5Hrah7bOUMODh5Vj2a4tf0Uy/kSSXkYAij64cluvAPFXi9l5UMOY/O
         OzZT4Wm0ftonrNR7Jor0StEYPT1X2eBJUxa4T/ErI7IlACiUqY1tNNsbcT/DDiRzG3
         ygtg3Z3K94aM2EKy6GSEbL9mbC/qvY765Slj0Y2JFuAyfJNLJ3dA1YGtJ+HiulRJ6Q
         eGct19qat+WAYVzla/3csbW3Axocc7aKnQ0mSsHA3Fka/yfLHXGnKFNT1eA7OReb59
         D1ez94Rqp+yp2GA7NVKe11Fcr+qXKANEg8ExV+puCigQCoHYA0VNqv14iJiWq66q9I
         WiFe9/ooT2jFg==
Received: by mail-wr1-f70.google.com with SMTP id n1-20020a5d4c41000000b00159305d19baso2671630wrt.11
        for <netdev@vger.kernel.org>; Mon, 13 Sep 2021 06:21:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=IGi454bY1uM8p5QRZSKGDo9YXvHCL/LufQFtzz+SznM=;
        b=bXly3jhS3HjUQevRnsHew8JXT+x6aGpZz86Pmxfg8UUiLMftbcOMx+91rz3wsFEheZ
         mFoHeSy6waQkiBK5A1piMLP6jlYmFsSkAVeezHuHAL9RvXDJtu8nF75rZp991Nz68Jn3
         9q1CTs1Z76nOiAJv1NbGmPLPZCivC7iUadWq4HR+EqLmwl91dx1sLBe/S1RbIDeYI+3x
         IsYXKpM5VGO91O8UQtSWGhJSsWz01N7wrl4hR5w+iKKXXUFvzti6Kc6Q2Dfwjm2FujWS
         rjpb5l6Q7d5w5AbjlT4zOCCNtBJuWfyBX43EcBpv2OyhGQmSu8TaXL8aoivJ6j0G+n3i
         arOA==
X-Gm-Message-State: AOAM533uu9tnNB2A3b1OuKHX3ajpWnf7IJBeycFiNptK6O+raIZFxoyw
        bNctKO0khKNkSGXpGnuDMvPNVx6WczuALvndGI8bw0mjE55qYXmKlnJdui1O15JKQGOffCMA0zz
        KgQO7+mOxR9P8kI7DfPsTqmlY85HqOqoPsw==
X-Received: by 2002:a7b:cc94:: with SMTP id p20mr10982108wma.75.1631539270108;
        Mon, 13 Sep 2021 06:21:10 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyzcTw8iBQqSZqojTcM4kP7OKiemOCKYYc0KcyxRfeOMDAJB3GM+IUl88UZvA8hAphcWLUGHQ==
X-Received: by 2002:a7b:cc94:: with SMTP id p20mr10982078wma.75.1631539269943;
        Mon, 13 Sep 2021 06:21:09 -0700 (PDT)
Received: from kozik-lap.lan (lk.84.20.244.219.dc.cable.static.lj-kabel.net. [84.20.244.219])
        by smtp.gmail.com with ESMTPSA id n3sm7195888wmi.0.2021.09.13.06.21.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Sep 2021 06:21:09 -0700 (PDT)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Krzysztof Opasiak <k.opasiak@samsung.com>,
        Mark Greer <mgreer@animalcreek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-nfc@lists.01.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org
Subject: [PATCH v2 15/15] nfc: mrvl: drop unneeded memory allocation fail messages
Date:   Mon, 13 Sep 2021 15:20:35 +0200
Message-Id: <20210913132035.242870-16-krzysztof.kozlowski@canonical.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210913132035.242870-1-krzysztof.kozlowski@canonical.com>
References: <20210913132035.242870-1-krzysztof.kozlowski@canonical.com>
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


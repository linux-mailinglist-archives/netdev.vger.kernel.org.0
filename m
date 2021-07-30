Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C08AA3DB40D
	for <lists+netdev@lfdr.de>; Fri, 30 Jul 2021 08:57:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237790AbhG3G5G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Jul 2021 02:57:06 -0400
Received: from smtp-relay-canonical-0.canonical.com ([185.125.188.120]:39410
        "EHLO smtp-relay-canonical-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237720AbhG3G5D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Jul 2021 02:57:03 -0400
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com [209.85.208.69])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-0.canonical.com (Postfix) with ESMTPS id 158473F237
        for <netdev@vger.kernel.org>; Fri, 30 Jul 2021 06:56:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1627628218;
        bh=lpVZTJlpKGPodj4MHtc+rObtHPXyuiLkFrg5L18y8PI=;
        h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=QC4ZaHWZffbPrX9LCG+qHi/sh2WDdMpPKl3I65VUFDzht0++wfthNKp853WMcCHOL
         w3dUziOnGHlsgOtK8HRd7VcG5ocI4Z7pxEL75CXrJxkd24361VnXgSnJuJGPsawMNL
         NSxvhFOcLxJgCQGewTAVr0H0MEKoSbF9rxoIq5X0q9AWU9L3UMuhhCFsxlOjlc36yU
         cpbIIC8L7RoqayID0bUXZXm5cBtYAOnld411fdDLD8WcFq0i4dHk5wFpa56pSGh/5+
         DKvvU5ix1XHt/im2ynRMjFGcwjgPEWVnqbka+I8xbqM1FD/EPuTYjNsqxKhd2Dcaua
         0GKer/RJhm8DA==
Received: by mail-ed1-f69.google.com with SMTP id de5-20020a0564023085b02903bb92fd182eso4182859edb.8
        for <netdev@vger.kernel.org>; Thu, 29 Jul 2021 23:56:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lpVZTJlpKGPodj4MHtc+rObtHPXyuiLkFrg5L18y8PI=;
        b=Iqk7JCLRaOImnV/6pU/1BCIGB8qbaYAR6WV4rwJsQO2knZB4dXmuIsKDdxrKxRpCOV
         2IZDZZdf692OEKsh2NSHLYfRxOIC178mPKMCFME6twMC5HtcO1m/MqpzuMdidGjyubhf
         Y9MJ2dYlSMiHMbbazlnsSs6YQrgfsCNYFvNBhJs/YcJYiR8VGNfWFLfsRS8zQIbDDfsW
         WeoaRTPLBfjff2LN02wxge3cv8+ML7sUZ3KllpWaxPjnmSYVssGcxmNCasPzi+SDj9om
         MvSyOf7cV9rAww9Al82v9FRm7gEv8yfmMqA8UhcJjW/GBBEiDBrWN6bPobavqndFDOMs
         b5Cg==
X-Gm-Message-State: AOAM533KA/O551jLhaOuzg0H0l1UW4DQH022Thx+fbFb0IDjgaQfSfPt
        v5UBiRNSCvKY9Ajf0fD51o2DHgNHtPE0Da0PHjf+Ps7l+j5bW7KsdpDi2/gl5sdRaYAonmYr10e
        jYsZ1nGCY6OtJX9HcedhpbNUQF3IDJ4ZCmg==
X-Received: by 2002:a17:906:2cc5:: with SMTP id r5mr1170218ejr.454.1627628217827;
        Thu, 29 Jul 2021 23:56:57 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzF1UJnDm47YAqdL4xKsUu+WQrS9jxPRbWrkT1jujqczwIF2v+flQ3oigoS89wz7xoV7GxOhg==
X-Received: by 2002:a17:906:2cc5:: with SMTP id r5mr1170206ejr.454.1627628217697;
        Thu, 29 Jul 2021 23:56:57 -0700 (PDT)
Received: from localhost.localdomain ([86.32.47.9])
        by smtp.gmail.com with ESMTPSA id m9sm238518ejn.91.2021.07.29.23.56.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Jul 2021 23:56:57 -0700 (PDT)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-nfc@lists.01.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/8] nfc: mrvl: correct nfcmrvl_spi_parse_dt() device_node argument
Date:   Fri, 30 Jul 2021 08:56:18 +0200
Message-Id: <20210730065625.34010-2-krzysztof.kozlowski@canonical.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210730065625.34010-1-krzysztof.kozlowski@canonical.com>
References: <20210730065625.34010-1-krzysztof.kozlowski@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The device_node in nfcmrvl_spi_parse_dt() cannot be const as it is
passed to OF functions which modify it.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
---
 drivers/nfc/nfcmrvl/spi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nfc/nfcmrvl/spi.c b/drivers/nfc/nfcmrvl/spi.c
index d64abd0c4df3..b182ab2e03c0 100644
--- a/drivers/nfc/nfcmrvl/spi.c
+++ b/drivers/nfc/nfcmrvl/spi.c
@@ -106,7 +106,7 @@ static const struct nfcmrvl_if_ops spi_ops = {
 	.nci_update_config = nfcmrvl_spi_nci_update_config,
 };
 
-static int nfcmrvl_spi_parse_dt(const struct device_node *node,
+static int nfcmrvl_spi_parse_dt(struct device_node *node,
 				struct nfcmrvl_platform_data *pdata)
 {
 	int ret;
-- 
2.27.0


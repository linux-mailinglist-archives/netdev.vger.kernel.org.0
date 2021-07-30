Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7D033DBAD6
	for <lists+netdev@lfdr.de>; Fri, 30 Jul 2021 16:42:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239286AbhG3OmU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Jul 2021 10:42:20 -0400
Received: from smtp-relay-canonical-0.canonical.com ([185.125.188.120]:44744
        "EHLO smtp-relay-canonical-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239200AbhG3OmS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Jul 2021 10:42:18 -0400
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com [209.85.208.72])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-0.canonical.com (Postfix) with ESMTPS id 158353F22A
        for <netdev@vger.kernel.org>; Fri, 30 Jul 2021 14:42:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1627656133;
        bh=lpVZTJlpKGPodj4MHtc+rObtHPXyuiLkFrg5L18y8PI=;
        h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=Um8cfwRwb4P7eWhWO7sYFJU1UF3AvYuziymLzZnEJH9xCvBXURp1bm8yzELOgGESC
         6ybjUD4sWcfWYXAZfeBF2+WwrXOITZ+c0AoI4mZX6IiFApe+K7EvcqTZDXcInNodxe
         oTj2UVEf7rTsYdxb38RJ+YSgroqATHC/qzZEErA4RYPLBtY8E5TBETKNTKB2uf+9nx
         f8nFQa/wjEiuX6ZzQ2lJmnQp739DSQNHFuAOOJ0s38+UMBSiz6oI3BVecVO9qry6gX
         1Skl22Ytejcsbm0xDdSFqzdqCLHtWmv+v5rnIsMwDHa32VW0SOA6HtMe5WkeMLK8HV
         XbgtE4W5hYgVg==
Received: by mail-ed1-f72.google.com with SMTP id p2-20020a50c9420000b02903a12bbba1ebso4695986edh.6
        for <netdev@vger.kernel.org>; Fri, 30 Jul 2021 07:42:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lpVZTJlpKGPodj4MHtc+rObtHPXyuiLkFrg5L18y8PI=;
        b=HCDWw65sWcswLWGrRYauZpLAJYxEc/HjGW3Z3jCdVD0udmg6Yn97WPUWWFtZzU2Uzo
         fIOvP8RR2gEL6roy+NPqTONLsJ4xXM4GbzZ9uWRrjiQHAxpwEZngrGayyL7JhyVeiVPL
         vn30ej5r/4s5EaVJW67QR4H8iOSeWVjRdXcY7zqVOYhE0ZzrGykZLKprm3LW47YgArJh
         osH3mGpqClCoE5ZXGYTW7BeJBHSQyieD0DxHz6tCCdD75yxRehA5iPB43h7tCHMd+wnp
         HzQ8+IykrEJdXhKJo8ztBLN5e7mzUyqE9KbNiPLdL3ZxbHEWk1NjeBEt20tXfEcgG3Rf
         k+Kg==
X-Gm-Message-State: AOAM53308jApHGyGHWBgBDRK0WDbyZIJ21ibZFMUsBNVjU+ij9PeVxyy
        xuCbr2wL6PoG2I13r5RFv2aI45ifkUmr5taaw7kWEvMGU6aWyPu9QT3hVWfYNW0PINWzrK/HLYg
        DkjYWczgdTqgFengr8VpZrYYVX71jGnU2wg==
X-Received: by 2002:a05:6402:1c19:: with SMTP id ck25mr3395015edb.128.1627656132803;
        Fri, 30 Jul 2021 07:42:12 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwEYNd2rGK8vmEVNFNmAp5fQBjwS6feWC8FOd6wG1bhDOFk//GYqhLi16ea5fwlunfc1R0zxw==
X-Received: by 2002:a05:6402:1c19:: with SMTP id ck25mr3395003edb.128.1627656132665;
        Fri, 30 Jul 2021 07:42:12 -0700 (PDT)
Received: from localhost.localdomain ([86.32.47.9])
        by smtp.gmail.com with ESMTPSA id z8sm626325ejd.94.2021.07.30.07.42.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Jul 2021 07:42:12 -0700 (PDT)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-nfc@lists.01.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 1/7] nfc: mrvl: correct nfcmrvl_spi_parse_dt() device_node argument
Date:   Fri, 30 Jul 2021 16:41:56 +0200
Message-Id: <20210730144202.255890-2-krzysztof.kozlowski@canonical.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210730144202.255890-1-krzysztof.kozlowski@canonical.com>
References: <20210730144202.255890-1-krzysztof.kozlowski@canonical.com>
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

